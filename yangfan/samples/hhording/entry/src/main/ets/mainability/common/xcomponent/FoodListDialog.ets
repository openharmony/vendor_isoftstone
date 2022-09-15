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

import prompt from '@ohos.prompt';

@CustomDialog
export struct FoodListDialog {
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void
  @Consume totalNumber: number
  @Link orderList: Array<any>
  @Consume totalPrice: number
  @Consume total: number
  aboutToAppear() {
    this.total = this.totalNumber
  }

  build() {
    Column() {
      List() {
        ForEach(this.orderList, (item) => {
          ListItem() {
            Column({ space: 10 }) {
              Text(item.foodName)
              .width('90%')
              .fontSize($r('app.float.distance_18'))
              .fontFamily('HarmonyOS_Sans_SC')
              .textAlign(TextAlign.Start)
              Row({ space: '5' }) {
                Text('￥' + String(Number(item.price) * item.orderNumber))
                .fontSize($r('app.float.distance_17'))
                .fontColor('#f0494d')
                .fontFamily('HarmonyOS_Sans_SC')
                .textAlign(TextAlign.Start)
                Blank()
                Image($r('app.media.reduce'))
                .width($r('app.float.distance_34'))
                .height($r('app.float.distance_34'))
                .objectFit(ImageFit.None)
                .onClick(() => {
                  this.total--
                  this.totalPrice -= Number(item.price)
                  if (item.orderNumber > 1) {
                    item.orderNumber--
                  } else {
                    let index = this.orderList.indexOf(item)
                    this.orderList.splice(index, 1)
                    if (this.total == 0) {
                      this.controller.close()
                      this.cancel()
                    } else {
                      console.info(`gjh the 购物车 not null`)
                    }
                  }
                })
                Text(String(item.orderNumber))
                .width($r('app.float.distance_51'))
                .fontSize($r('app.float.distance_17'))
                .textAlign(TextAlign.Center)
                .fontFamily('HarmonyOS_Sans_SC')
                Image($r('app.media.add'))
                .width($r('app.float.distance_34'))
                .height($r('app.float.distance_34'))
                .objectFit(ImageFit.None)
                .onClick(() => {
                  this.total++
                  item.orderNumber++
                  this.totalPrice += Number(item.price)
                })
              }
              .width('90%')
              .justifyContent(FlexAlign.Center)
              Divider().width('100%')
            }
          }
          .align(Alignment.Center)
          .margin({ top: '30px' })
        })
      }
      .align(Alignment.Center)
      .height('70%')
      Row() {
        Row() {
          Text('总数   ')
          .fontSize($r('app.float.distance_17'))
          .fontFamily('HarmonyOS_Sans_SC')
          Text(this.total.toString())
          .fontSize($r('app.float.distance_17'))
          .fontFamily('HarmonyOS_Sans_SC')
        }
        .width('45%')
        .height(45)
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.Start)
        Blank()
        Column() {
          Text('合计   ￥' + this.totalPrice.toString())
          .fontSize($r('app.float.distance_17'))
          .fontFamily('HarmonyOS_Sans_SC')
          Text('优惠   ￥0')
          .fontSize($r('app.float.distance_17'))
          .fontColor('#f0494d')
          .fontFamily('HarmonyOS_Sans_SC')
        }
        .height(45)
        .alignItems(HorizontalAlign.Start)
      }
      .width('85%')
      .height(100)
      .justifyContent(FlexAlign.Start)
      Text('去结算 ￥' + String(this.totalPrice))
      .width('90%')
      .height(28)
      .fontSize(15)
      .fontColor('#ffffff')
      .fontFamily('HarmonyOS_Sans_SC')
      .borderRadius($r('app.float.distance_25'))
      .textAlign(TextAlign.Center)
      .backgroundColor('#f0494d')
      .margin({ bottom: '30px' })
      .onClick(() => {
        this.controller.close()
        this.confirm()
      })
    }
    .width('21%')
    .height('87%')
    .borderRadius(10)
    .backgroundColor(Color.White)
  }

}