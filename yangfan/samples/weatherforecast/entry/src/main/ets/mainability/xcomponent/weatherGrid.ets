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
import {HourlyData} from '../model/weatherData'
@Component
export struct weatherGrid {
  private heightValue: number = 0
  @Link  hourlyData: HourlyData[]

  aboutToAppear() {
    this.heightValue = 160;
  }
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column() {
        Grid() {
          ForEach(this.hourlyData, item => {
            GridItem() {
              weatherGridItem({ hourlyDataItem: item })
            }
          })
        }
        .margin({ top: 10 })
        .rowsTemplate('1fr ')
        .height(this.heightValue)
        .backgroundColor('#5296d3')
        .borderRadius(20)
        .columnsGap(8)
        .padding({ top: 15, left: 15, right: 15 })
        .width('92%')
        .onScrollIndex((first: number) => { //实现横向滚动
          console.info(first.toString())
        })
      }
    }
  }
}
@Component
struct weatherGridItem {
  private hourlyDataItem: HourlyData

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        Text(this.hourlyDataItem.fxTime.substring(11, 16))
          .fontSize(20)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
        Row() {
          Image($rawfile(this.hourlyDataItem.icon + '.svg'))
            .objectFit(ImageFit.Contain)
            .autoResize(false)
            .width(50)
            .height(50)
            .margin({ top: 15, bottom: 15 })
        }
        Text(this.hourlyDataItem.temp + "℃")
          .fontSize(20)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
      }
    }
    .width(80)
    .margin({ left: 5, right: 5 })
  }
}