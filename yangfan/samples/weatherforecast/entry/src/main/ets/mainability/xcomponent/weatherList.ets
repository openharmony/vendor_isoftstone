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
import {DailyData} from '../model/weatherData'
@Component
export struct weatherList{
  @Link dailyData:DailyData[]
  build(){
    Column(){
      List({space:6}){
        ForEach(this.dailyData,item=> {
          ListItem() {
            weatherListItem({dailyDataItem:item})
          }
        })
      }
      .padding({top:10,bottom:10})
    }
    .backgroundColor('#5296d3')
    .margin({top:15})
    .width('92%')
    .borderRadius(20)
  }
}
@Component
struct weatherListItem {
  private dailyDataItem:DailyData
  build(){
    Flex({justifyContent:FlexAlign.Start,alignItems:ItemAlign.Center}) {
      Text(this.dailyDataItem.today)
        .fontSize(20)
        .width('15%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
      Text(`${this.dailyDataItem.months}月${this.dailyDataItem.day}日`)
        .fontSize(20)
        .width('15%')
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
      Image($rawfile(this.dailyDataItem.iconDay + '.svg'))
        .objectFit(ImageFit.Contain)
        .autoResize(false)
        .height(40)
        .width('55%')
        .align(Alignment.Center)
        .flexGrow(1)

      Text(this.dailyDataItem.tempMin + '/' + this.dailyDataItem.tempMax + '℃')
        .fontSize(20)
        .fontColor(Color.White)
        .width('15%')
        .textAlign(TextAlign.Center)
    }
    .layoutWeight(4)
    .padding({left:18,right:18})
  }
}