/*
# Copyright (c) 2020-2030 iSoftStone Information Technology (Group) Co.,Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
*/

import dataStorage from '@ohos.data.storage'
import ability_featureAbility from '@ohos.ability.featureAbility'
import { Logger } from './Logger'

let logger = new Logger('PreferenceUtil')
/**
 * 数据存储工具类
 */
class PreferenceUtil {
  constructor() {
  }

  setStorageValue(key, value, ex?) {
    Preference.getInstance().then((preference) => {
      return preference.setStorageValue(key, value)
    }).catch((err) => {
      ex(err)
    })
  }

  getStorageValue(key, defValue, callback, ex?) {
    Preference.getInstance().then((preference) => {
      return preference.getStorageValue(key, defValue)
    }).then((data) => {
      callback(data)
    }).catch((err) => {
      ex(err)
    })
  }

  deleteStorageKey(key, ex?) {
    Preference.getInstance().then((preference) => {
      return preference.deleteStorageKey(key)
    }).catch((err) => {
      ex(err)
    })
  }

  registerDataChangedListener(onChangedListener: (key: string) => void) {
    Preference.getInstance().then((preference) => {
      preference.registerDataChangedListener(onChangedListener)
    })
  }

  unRegisterDataChangedListener(onChangedListener: (key: string) => void) {
    Preference.getInstance().then((preference) => {
      preference.unRegisterDataChangedListener(onChangedListener)
    })
  }
}

let self: Preference

export class Preference {
  private static sInstance: Preference = undefined
  private OnChangedListeners: Set<(key: string) => void> = new Set
  private storage: dataStorage.Storage = undefined

  /**
   * 创建单列
   */
  public static getInstance(): Promise<Preference> {
    return new Promise<Preference>((resolve, reject) => {
      if (!Preference.sInstance) {
        let preference = new Preference()
        preference.initStorage((err) => { //
          if (err) {
            reject('initStorage failed.')
          } else {
            Preference.sInstance = preference
            resolve(preference)
          }
        })
      } else {
        resolve(Preference.sInstance)
      }
    })
  }

  private constructor() {
    self = this
  }

  private initStorage(call) {
    if (self.storage) {
      call(undefined)
      return
    }
    let context = ability_featureAbility.getContext()
    context.getFilesDir().then((data) => {
      logger.log(`initStorage getFilesDir, data = ${data}`)
      return dataStorage.getStorage(`${data}/mystore`)
    }).then((storage) => {
      self.storage = storage
      logger.log(`initStorage getStorage success`)
      call(undefined)
    }).catch((err) => {
      logger.error(`getFilesDir failed, err = ${err}`)
      call(`getFilesDir failed, err = ${err}`)
    })
  }

  private storageObserver(key: string) {
    for (let onChangedListener of self.OnChangedListeners) {
      onChangedListener(key)
    }
  }

  setStorageValue(key: string, value: number | string | boolean): Promise<void>{
    return new Promise<void>((resolve, reject) => {
      logger.info(`setStorageValue, key: ${key}, value: ${value}`)
      if (self.storage) {
        self.storage.put(key, value)
          .then(() => {
            return self.storage.flush()
          })
          .then(() => {
            logger.log("setStorageValue flush success")
            resolve()
          })
          .catch((err) => {
            logger.error(`setStorageValue failed, err = ${err}`)
            reject(err)
          })
      } else {
        reject('storage is null')
      }
    })
  }

  getStorageValue(key: string, defValue: number | string | boolean): Promise<number | string | boolean>{
    return new Promise<number | string | boolean>((resolve, reject) => {
      logger.info(`getStorageValue, key: ${key}, defaultValue: ${defValue}`)
      if (self.storage) {
        self.storage.get(key, defValue).then((data) => {
          logger.info(`getStorageValue success, data = ${data}`)
          resolve(data)
        }).catch((err) => {
          logger.error(`getStorageValue failed, err = ${err}`)
          reject(err)
        })
      } else {
        reject('storage is null')
      }
    })
  }

  deleteStorageKey(key: string): Promise<void>{
    return new Promise<void>((resolve, reject) => {
      logger.info(`deleteStorageKey, key: ${key}`)
      if (self.storage) {
        self.storage.delete(key).then(() => {
          logger.log("deleteStorageKey success")
          resolve()
        }).catch((err) => {
          logger.error(`deleteStorageKey failed, err = ${err}`)
          reject(err)
        })
      } else {
        reject('storage is null')
      }
    })
  }

  registerDataChangedListener(onChangedListener: (key: string) => void) {
    if (!onChangedListener) {
      logger.error(`registerDataChangedListener onChangedListener is null`)
      return
    }
    if (self.storage && !self.OnChangedListeners.has(onChangedListener)) {
      self.OnChangedListeners.add(onChangedListener)
      logger.log(`registerDataChangedListener OnChangedListeners size = ${self.OnChangedListeners.size}`)
      if (self.OnChangedListeners.size == 1) {
        self.storage.on('change', (data) => {
          logger.log(`registerDataChangedListener change data = ${data}`)
          self.storageObserver(data.key)
        })
      }
    }
  }

  unRegisterDataChangedListener(onChangedListener: (key: string) => void) {
    if (!onChangedListener || !self.OnChangedListeners.has(onChangedListener)) {
      return
    }
    self.OnChangedListeners.delete(onChangedListener)
    logger.log(`unRegisterDataChangedListener OnChangedListeners size = ${self.OnChangedListeners.size}`)
    if (self.OnChangedListeners.size == 0) {
      self.storage.off('change', (data) => {
        console.log(JSON.stringify(data))
      })
    }
  }
}

export default new PreferenceUtil