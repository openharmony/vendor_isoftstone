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

import DisplayUtils from '../utils/DisplayUtils'

@Component
export struct FoodGrid {
  private rowGaps: number
  private topGaps: number
  private foodLists: Array<any> = []
  @Link orderList: any

  aboutToAppear() {
    let width = DisplayUtils.getDisplayWidth()
    console.info(`gjh the DisplayUtils width is ${width}`)
  }

  build() {
    Column() {
        Grid() {
          ForEach(this.foodLists, (item) => {
            GridItem() {
              FoodGridItem({ orderList: $orderList, foodItem: item })
            }
            .height('280px')
            .margin({ top: '33px'})
          })
        }
        .width('100%')
        .height('97%')
        .rowsGap('10px')
        .columnsGap('20px')
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .backgroundColor('#f8f8f8')
        .padding({ left: '20px', right: '20px' })
        .borderRadius('20px')
    }
    .width('100%')
  }
}

@Component
struct FoodGridItem {
  @Link orderList: any
  @Consume totalNumber:number
  @Consume totalPrice: number
  private foodItem: any

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(this.foodItem.foodImageSrc)
        .height('100%')
        .objectFit(ImageFit.Fill)
        .borderRadius('10px')
        Row() {
          Column() {
            Text(this.foodItem.foodName)
            .width('100%')
            .fontSize('17px')
            .textOverflow({ overflow: TextOverflow.Clip })
            .fontColor(Color.White)
            .fontFamily('HarmonyOS_Sans_SC')
            .textAlign(TextAlign.Start)
            Text('￥ ' + String(this.foodItem.price))
            .width('100%')
            .fontSize('17px')
            .fontColor(Color.White)
            .fontFamily('HarmonyOS_Sans_SC')
            .textAlign(TextAlign.Start)
          }
          .width('50%')
          .padding({ left: '12px' })
          Row() {
            Image($r('app.media.reduce2'))
              .width('30px')
              .height('30px')
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.onReduce()
              })
            Text(this.orderList.indexOf(this.foodItem) != -1 ? String(this.orderList[this.orderList.indexOf(this.foodItem)].orderNumber) : '0')
              .width('45px')
              .fontSize('15px')
              .fontColor('#ffffff')
              .textAlign(TextAlign.Center)
            Image($r('app.media.add2'))
              .width('30px')
              .height('30px')
              .objectFit(ImageFit.Contain)
              .margin({ right: '13px' })
              .onClick(() => {
                this.addFood()
              })
          }
          .width('50%')
          .margin({ left: '12px' })
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height('55px')
        .justifyContent(FlexAlign.Center)
        .opacity(0.9)
        .backgroundImage($r('app.media.background_red'))
        .backgroundImageSize({ width: '100%', height: '100%' })
      }
      .width('100%')
      .height('100%')
    }
  }

  /**
   * 增加餐品
   */
  addFood() {
    this.totalNumber++
    this.totalPrice += Number(this.foodItem.price)
    let index = this.orderList.indexOf(this.foodItem)
    if(index >= 0) {
      this.orderList[index].orderNumber++
    } else {
      this.foodItem.orderNumber = 1
      this.orderList.push(this.foodItem)
    }
  }

  /**
   * 取消餐品
   */
  onReduce() {
    if(this.totalNumber > 0) {
      let pow = this.orderList.indexOf(this.foodItem)
      if(pow >= 0) {
        if(this.orderList[pow].orderNumber == 1) {
          this.orderList.splice(pow, 1)
          this.totalNumber--
          this.totalPrice -= Number(this.foodItem.price)
        } else {
          this.orderList[pow].orderNumber--
          this.totalNumber--
          this.totalPrice -= Number(this.foodItem.price)
        }
      } else {
        console.info('gjh the fooItem is null')
      }
    } else {
      this.totalNumber = 0
    }
  }
}