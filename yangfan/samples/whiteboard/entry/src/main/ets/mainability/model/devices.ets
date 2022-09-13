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

import deviceManager from '@ohos.distributedHardware.deviceManager'
import Logger from '../Logger'
export class DevicesManager {
  #dmInstance
  subscribeId

  createDevicesManager(createCall) {
    if (typeof (this.#dmInstance) == 'undefined') {
      Logger.log('deviceManager.createDeviceManager begin')
      let self = this
      deviceManager.createDeviceManager('com.example.drawingboard', (err, manager) => {
        if (err) {
          Logger.info('createDeviceManager err:' + JSON.stringify(err))
          return
        }
        Logger.info('createDeviceManager success')
        self.#dmInstance = manager
        createCall(self)
      })
      Logger.log('deviceManager.createDeviceManager end')
    } else {
      createCall(this)
    }
  }

  registerDeviceListCallback(registerCall) {
    let trustedList = this.#dmInstance.getTrustedDeviceListSync()
    Logger.info('registerDeviceListCallback deviceList=' + JSON.stringify(trustedList))
    let allList = trustedList.map(data => {
      return { deviceInfo: data, checked: true }
    })
    Logger.info('registerDeviceListCallback allList=' + JSON.stringify(allList))

    this.#dmInstance.on('deviceStateChange', (data) => {
      Logger.info('deviceStateChange data=' + JSON.stringify(data))
    })

    this.#dmInstance.on('deviceFound', (data) => {
      Logger.info('deviceFound data=' + JSON.stringify(data))
      if (allList.length == 0) {
        Logger.info('deviceFound allList=' + JSON.stringify(allList))
        allList.push({ deviceInfo: data.device, checked: false })
        Logger.info('deviceFound allList=' + JSON.stringify(allList))
        registerCall(allList)
        return
      }
      for (var i = 0;i < allList.length; i++) {
        if (allList[i].deviceId == data.device.deviceId) {
          return
        }
        allList.push({ deviceInfo: data.device, checked: false })
      }
      if (allList.length > 0) {
        registerCall(allList)
      }
    })
    this.#dmInstance.on('discoverFail', (data) => {
      Logger.info('discoverFail data=' + JSON.stringify(data))
    })
    this.#dmInstance.on('serviceDie', () => {
      Logger.info('serviceDie')
    })
    registerCall(allList)
  }

  startDeviceDiscovery() {
    this.subscribeId = Math.floor(65536 * Math.random())
    var info = {
      subscribeId: this.subscribeId,
      mode: 0xAA,
      medium: deviceManager.ExchangeMedium.AUTO,
      freq: deviceManager.ExchangeFreq.SUPER_HIGH,
      isSameAccount: false,
      isWakeRemote: true,
      capability: deviceManager.SubscribeCap.SUBSCRIBE_CAPABILITY_DDMP
    }
    this.#dmInstance.startDeviceDiscovery(info)
    Logger.info('startDeviceDiscovery ' + this.subscribeId)
  }

  stopDeviceDiscovery() {
    Logger.info('stopDeviceDiscovery ' + this.subscribeId)
    this.#dmInstance.stopDeviceDiscovery(this.subscribeId)
    this.#dmInstance.off('deviceStateChange')
    this.#dmInstance.off('deviceFound')
    this.#dmInstance.off('discoverFail')
    this.#dmInstance.off('serviceDie')
  }

  authenticateDevice(device: Device, authCallback) {
    Logger.info('authenticateDevice ' + JSON.stringify(device))

    let extraInfo = {
      "targetPkgName": 'com.example.drawingboard',
      "appName": 'drawingboard',
      "appDescription": 'drawingboard',
      "business": '0'
    };
    let authParam = {
      "authType": 1,
      "appIcon": '',
      "appThumbnail": '',
      "extraInfo": extraInfo
    };

    Logger.info('authenticateDevice deviceInfo:' + JSON.stringify(device.deviceInfo))
    this.#dmInstance.authenticateDevice(device.deviceInfo, authParam, (err, data) => {
      if (err) {
        Logger.info('authenticateDevice error:' + JSON.stringify(err))
      } else {
        Logger.info('authenticateDevice succeed:' + JSON.stringify(data))
        authCallback(device.deviceInfo.deviceId)
      }
    });
  }
}

export class Device {
  deviceInfo
  checked: boolean
}