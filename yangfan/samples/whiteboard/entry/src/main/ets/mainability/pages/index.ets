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

import {BCanvas} from '../view/canvas'
import {SettingView} from '../view/setting'
import SettingCallback from '../callback'
import Logger from '../Logger'
import featureAbility from '@ohos.ability.featureAbility'
import kvStoreModel from '../model/kvstore.ets'
import LayerInfo from '../model/layer.ets'
import bundle from '@ohos.bundle'
import abilityAccessCtrl from "@ohos.abilityAccessCtrl"
import {DevicesDialog} from '../view/dialog.ets'
import {DevicesManager} from '../model/devices.ets'


const CHANGE = 'changed'
const EXIT = 'exit'

async function requestPermission() {
  Logger.info('requestPermission begin');
  let array: Array<string> = ["ohos.permission.DISTRIBUTED_DATASYNC"];
  let tokenID = undefined;
  const appInfo = await bundle.getApplicationInfo('com.example.drawingboard', 0, 100);
  tokenID = appInfo.accessTokenId;
  const atManager = abilityAccessCtrl.createAtManager();
  let requestPermissions: Array<string> = [];
  for (let i = 0;i < array.length; i++) {
    let result = await atManager.verifyAccessToken(tokenID, array[i]);
    Logger.info("verifyAccessToken result:" + JSON.stringify(result));
    if (result == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    } else {
      requestPermissions.push(array[i]);
    }
  }
  Logger.info("requestPermissions:" + JSON.stringify(requestPermissions));
  if (requestPermissions.length == 0 || requestPermissions == []) {
    return;
  }
  let context = featureAbility.getContext();
  context.requestPermissionsFromUser(requestPermissions, 1, (data) => {
    Logger.info("data:" + JSON.stringify(data));
  });
  Logger.info('requestPermission end');
}


@Entry
@Component
struct Index {
  @State isDistributed: boolean = false
  @State commands: string[] = []
  @State showSet: boolean = false
  @State width: number = 1
  @State color: string = '#000000'
  @State layers: Array<LayerInfo> = new Array()
//  @State del_layers: Array<LayerInfo> = new Array()
  private deviceId
  private callback: SettingCallback = {
    call: (value) => {
      this.width = value.width
      this.color = value.color
      this.showSet = !this.showSet
    }
  }
  private devicesManager: DevicesManager = new DevicesManager()
  handleSelectDevice = (device) => {
    Logger.log('handleSelectDevice device : ' + JSON.stringify(device))
    if (device.checked) {
      this.deviceId = device.deviceInfo.deviceId
      this.isDistributed = true
      this.startAbility(this.deviceId)
      return
    }
    this.devicesManager.authenticateDevice(device, (deviceId) => {
      Logger.log('authenticate success : ' + deviceId)
      this.deviceId = deviceId
      this.isDistributed = true
      this.startAbility(this.deviceId)
    })
  }
  dialogController: CustomDialogController = new CustomDialogController({
    builder: DevicesDialog({
      devicesManager: this.devicesManager,
      handleSelectDevice: this.handleSelectDevice
    }),
    autoCancel: false
  })

  aboutToAppear() {
    requestPermission()
    featureAbility.getWant((error, want) => {
      Logger.info('featureAbility.getWant =' + JSON.stringify(want.parameters));
      if (want.parameters.isFA === 'FA') {
        this.isDistributed = true
        this.syncData(want.parameters.data)
      }
    })

    kvStoreModel.setOnMessageReceivedListener(CHANGE, (value) => {
      if (this.isDistributed) {
        Logger.info('changed -- str -- ' + value)
        this.syncData(value)
      }
    })
  }

  syncData(data) {
    Logger.info('syncData -- data -- ' + data)
    let dataJson = JSON.parse(data)
    this.layers = dataJson.layers.map(item => {
      return JSON.parse(item)
    })
      .map(item => {
        var lay = new LayerInfo(item.width, item.color)
        lay.commands = item.commands
        return lay
      })
    //    this.del_layers = dataJson.del_layers.map(item => {
    //      return JSON.parse(item)
    //    })
    //      .map(item => {
    //        var lay = new LayerInfo(item.width, item.color)
    //        lay.commands = item.commands
    //        return lay
    //      })
  }

  startAbility(deviceId) {
    if (!this.isDistributed) {
      return
    }
    let data = this.getAllData()
    Logger.log('startAbility deviceId:' + deviceId)
    featureAbility.startAbility({
      want: {
        bundleName: 'com.example.drawingboard',
        abilityName: 'com.example.drawingboard.MainAbility',
        deviceId: deviceId,
        parameters: {
          isFA: 'FA',
          data: JSON.stringify(data)
        }
      }
    }).then((data) => {
      Logger.log('start ability finished:' + JSON.stringify(data))
    }).catch((err) => {
      Logger.log('start ability catch:' + JSON.stringify(err))
    })
  }

  getAllData() {
    let layers = []
    //    let remlayers = []
    if (this.layers.length > 0) {
      for (let layer of this.layers) {
        layers.push(JSON.stringify(layer.toObj()))
      }
    }
    Logger.log('startAbility layers:' + JSON.stringify(layers))
    //
    //    if (this.del_layers.length > 0) {
    //      for (let layer of this.del_layers) {
    //        remlayers.push(JSON.stringify(layer.toObj()))
    //      }
    //    }
    //    Logger.log('startAbility remlayers:' + JSON.stringify(remlayers))
    let data = { layers: layers }
    Logger.log('startAbility data:' + JSON.stringify(data))
    return data
  }

  updateLay() {
    Logger.log('update layers :' + this.layers.length)
    //    Logger.log('update del_layers :' + this.del_layers.length)

    let data = this.getAllData()
    if (this.isDistributed) {
      kvStoreModel.put(CHANGE, JSON.stringify(data))
    }
  }

//  async startAbilityRandom(deviceId: string, layers: Array<LayerInfo>, del_layers: Array<LayerInfo>) {
//    Logger.info('featureAbility.startAbility deviceId=' + deviceId)
//    let wantValue = {
//      bundleName: 'com.example.drawingboard',
//      abilityName: 'com.example.drawingboard.MainAbility',
//      deviceId: deviceId,
//      parameters: {
//        layers: layers,
//        del_layers: del_layers
//      }
//    };
//    featureAbility.startAbility({
//      want: wantValue
//    }).then((data) => {
//      Logger.info(' featureAbility.startAbility finished, ' + JSON.stringify(data))
//    })
//  }

  aboutToDisappear() {
    Logger.info('aboutToDisappear');
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {

      BCanvas({
        layers: this.layers,
        //        del_layers: this.del_layers,
        showSet: this.showSet,
        width: this.width,
        color: this.color,
        update: () => {
          this.updateLay()
        }
      })
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {

        Button() {
          Image($r("app.media.previous"))
            .width('100%')
            .height('100%')
        }
        .align(Alignment.Center)
        .backgroundColor('#FFEEFF')
        .type(ButtonType.Normal)
        .width(vp2px(35))
        .height(vp2px(35))
        .margin({ right: vp2px(15), top: vp2px(15) })
        .onClick(() => {
          if (this.layers.length > 0) {
            this.layers.pop()
            this.updateLay()
          }
        })

        Button() {
          Image($r("app.media.share"))
            .width('100%')
            .height('100%')
        }
        .align(Alignment.Center)
        .backgroundColor('#FFEEFF')
        .type(ButtonType.Normal)
        .width(vp2px(35))
        .height(vp2px(35))
        .margin({ right: vp2px(15), top: vp2px(15) })
        .onClick(() => {
          Logger.info('showDialog start')
          this.dialogController.open()
        })

        Button() {
          Image($r("app.media.menu"))
            .width('100%')
            .height('100%')
        }
        .align(Alignment.Center)
        .backgroundColor('#FFEEFF')
        .margin({ right: vp2px(15), top: vp2px(15) })
        .type(ButtonType.Normal)
        .width(vp2px(35))
        .height(vp2px(35))
        .onClick(() => {
          this.showSet = !this.showSet
        })
      }
      .width('100%')
      .visibility(this.showSet ? Visibility.None : Visibility.Visible)

      SettingView({ showSet: this.showSet, callback: this.callback })


    }
    .width('100%')
    .height('100%')
  }
}