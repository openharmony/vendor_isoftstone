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


import distributedData from '@ohos.data.distributeddata'
import Logger from '../Logger'
const STORE_ID = 'DrawingBoard'

class KvStoreModel {
  kvManager
  kvStore

  constructor() {
  }

  createKvStore(callback) {
    if ((typeof (this.kvStore) != 'undefined')) {
      callback()
      return;
    }
    var config = {
      bundleName: 'com.example.drawingboard',
      userInfo: {
        userId: '0',
        userType: 0
      }
    };
    let self = this;
    Logger.info('createKVManager begin')
    distributedData.createKVManager(config).then((manager) => {
      Logger.info('createKVManager success, kvManager=' + JSON.stringify(manager))
      self.kvManager = manager;
      let options = {
        createIfMissing: true,
        encrypt: false,
        backup: false,
        autoSync: true,
        kvStoreType: 1,
        securityLevel: 1,
      };
      Logger.info('kvManager.getKVStore begin')
      self.kvManager.getKVStore(STORE_ID, options).then((store) => {
        Logger.info('getKVStore success, kvStore=' + store)
        self.kvStore = store
        callback()
      })
      Logger.info('kvManager.getKVStore end')
    });
    Logger.info('createKVManager end')
  }

  put(key, value) {
    Logger.info('kvStore.put ' + key + '=' + value);
    this.kvStore.put(key, value).then((data) => {
      Logger.info('kvStore.put ' + key + ' finished, data=' + JSON.stringify(data))
    }).catch((err) => {
      Logger.error('kvStore.put ' + key + ' failed, ' + JSON.stringify(err))
    });
  }

  setOnMessageReceivedListener(msg, callback) {
    Logger.info('setOnMessageReceivedListener ' + msg)
    let self = this
    this.createKvStore(() => {
      Logger.info('kvStore.on(dataChange) begin')
      self.kvStore.on('dataChange', 1, (data) => {
        Logger.info('dataChange, ' + JSON.stringify(data));
        Logger.info('dataChange, insert ' + data.insertEntries.length + ' udpate '
        + data.updateEntries.length)
        let entries = data.insertEntries.length > 0 ? data.insertEntries : data.updateEntries
        for (let i = 0; i < entries.length; i++) {
          if (entries[i].key === msg) {
            let value = entries[i].value.value
            Logger.info('Entries receive ' + msg + '=' + value)
            callback(value)
            return;
          }
        }
      });
      Logger.info('kvStore.on(dataChange) end')
    })
  }
}

export default new KvStoreModel()