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

import {Device} from '../model/devices.ets'
import Logger from '../Logger'
@CustomDialog
export struct DevicesDialog {
  @State deviceList: Array<Device> = []
  private dms
  controller: CustomDialogController
  action: () => void
  devicesManager
  private handleSelectDevice: (item: Device) => void

  aboutToAppear() {
    Logger.info('aboutToAppear ---- ')
    this.devicesManager.createDevicesManager(dms => {
      Logger.info('createDevicesManager ---- ')
      this.dms = dms
      dms.registerDeviceListCallback(devices => {
        Logger.info('registerDeviceListCallback -- devices -- ' + JSON.stringify(devices))
        this.deviceList = devices
      })
      dms.startDeviceDiscovery()
    })
  }

  aboutToDisappear() {
    Logger.info('aboutToDisappear ---- ')
    this.deviceList=[]
  }

  build() {
    Column() {
      Text($r('app.string.check_device'))
        .fontSize(20)
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
      List() {
        ForEach(this.deviceList, (item, index) => {
          ListItem() {
            Row() {
              Text(item.deviceInfo.deviceName)
                .fontSize(20)
                .width('90%')
                .fontColor(Color.Black)
              if (item.checked) {
                Image($r('app.media.checked'))
                  .width(25)
                  .height(25)
              } else {
                Image($r('app.media.uncheck'))
                  .width(20)
                  .height(20)
              }
            }
            .height(55)
            .margin({ left: 20, right: 20, top: 10, bottom: 10 })
            .onClick(() => {
              this.controller.close()
              this.dms.stopDeviceDiscovery()
              this.handleSelectDevice(item)
            })
          }
        }, item => item.deviceInfo.deviceName)
      }

      Text('未发现设备')
        .fontColor('#fb0d0d')
        .width('90%')
        .textAlign(TextAlign.Center)
        .margin({ left: 20, right: 20, top: 10, bottom: 10 })
        .fontSize(20)
        .visibility(this.deviceList.length > 0 ? Visibility.None : Visibility.Visible)

      Button() {
        Text($r('app.string.cancel'))
          .fontColor('#0D9FFB')
          .width('90%')
          .textAlign(TextAlign.Center)
          .fontSize(20)
      }
      .type(ButtonType.Capsule)
      .backgroundColor(Color.White)
      .onClick(() => {
        this.controller.close()
        this.dms.stopDeviceDiscovery()
      })
    }
    .backgroundColor(Color.White)
    .border({ color: Color.White, radius: 20 })
    .padding(10)
  }
}