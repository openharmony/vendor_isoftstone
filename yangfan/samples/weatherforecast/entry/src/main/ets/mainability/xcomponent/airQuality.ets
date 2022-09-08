
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
import {pollutionIndex} from './pollutionIndex'
import {NowQuality} from '../model/weatherData'
@Component
export struct airQuality{
  @Link private nowQuality:NowQuality
  build(){
    Column(){
      Flex(){
        Text('空气质量')
          .fontSize(20)
          .fontColor(Color.White)
          .width('50%')
        Text('更多  >')
          .fontSize(20)
          .fontColor(Color.White)
          .width('50%')
          .textAlign(TextAlign.End)
      }
      .width('90%')
      Flex(){
        Column(){
          Text('污染指数')
            .fontSize(18)
            .margin({top:8})
            .fontColor(Color.White)
          pollutionIndex({ indexNum : $nowQuality})
        }
        .margin({top:14})
        .width('50%')
        .height(150)
        Column(){
          Flex(){
            Text('PM10             ')
              .fontSize(15)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
            Text(this.nowQuality.pm10.toString())
              .fontSize(15)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({top:10})
          Flex(){
              Text('PM2.5          ')
                .fontSize(15)
                .width('50%')
                .textAlign(TextAlign.Start)
                .fontColor(Color.White)
              Text(this.nowQuality.pm2p5.toString())
                .fontSize(15)
                .width('50%')
                .textAlign(TextAlign.Start)
                .fontColor(Color.White)
          }
          .margin({top:10})
          Flex(){
              Text('NO2            ')
                .fontSize(15)
                .width('50%')
                .textAlign(TextAlign.Start)
                .fontColor(Color.White)
              Text(this.nowQuality.no2.toString())
                .fontSize(15)
                .textAlign(TextAlign.Start)
                .fontColor(Color.White)
          }
          .margin({top:10})
          Flex(){
            Text('SO2            ')
              .fontSize(15)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
            Text(this.nowQuality.so2.toString())
              .fontSize(15)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({top:10})
          Flex(){
            Text('O3             ')
              .fontSize(15)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
            Text(this.nowQuality.o3.toString())
              .fontSize(15)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({top:10})
          Flex(){
            Text('CO            ')
              .fontSize(15)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
            Text(this.nowQuality.co.toString())
              .fontSize(15)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({top:10})
        }
        .width('50%')
        .margin({ top: 16 })
      }
      .width('92%')
      .backgroundColor('#ffa6c8e7')
      .margin({top:10,bottom:16})
      .padding({bottom:20})
      .borderRadius(20)
    }
    .margin({top:10})
  }
}