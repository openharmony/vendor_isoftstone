/*
 * Copyright (c) 2021 iSoftStone Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { NowQuality } from '../model/whetherDataDetail';
import {ProgressBar} from './ProgressBar'
@Component
export struct AirDisplay {
  @Link private nowQuality: NowQuality

  build() {
    Column() {
      Flex() {
        Text($r('app.string.airQuality'))
          .fontSize(20)
          .fontColor(Color.White)
          .width('50%')

        Text('更多 >')
          .fontSize(20)
          .fontColor(Color.White)
          .width('50%')
          .textAlign(TextAlign.End)
      }
      .width('91%')

      Flex() {

        Column() {
          Text("污染指数")
            .fontSize(20)
            .margin({ top: 20 })
            .fontColor(Color.White)

          ProgressBar({ progress: $nowQuality })

        }
        .margin({ top: 16 })
        .width('50%')
        .height(150)

        Column() {
          Flex() {
            Text('PM10      ')
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)


            Text(this.nowQuality.pm10.toString())
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({ top: 12 })

          Flex() {
            Text('PM2.5      ')
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)

            Text(this.nowQuality.pm2p5.toString())
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({ top: 12 })

          Flex() {
            Text('NO2      ')
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)

            Text(this.nowQuality.no2.toString())
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({ top: 12 })

          Flex() {
            Text('SO2      ')
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)

            Text(this.nowQuality.so2.toString())
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({ top: 12 })

          Flex() {
            Text('O3      ')
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)

            Text(this.nowQuality.o3.toString())
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({ top: 12 })

          Flex() {
            Text('CO      ')
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)

            Text(this.nowQuality.co.toString())
              .fontSize(20)
              .width('50%')
              .textAlign(TextAlign.Start)
              .fontColor(Color.White)
          }
          .margin({ top: 12, bottom: 12 })


        }
        .width('50%')
        .margin({ top: 16 })

      }
      .width('92%')
      .backgroundColor('#5296d3')
      .margin({ top: 10, bottom: 16 })
      .padding({ bottom: 20 })
      .borderRadius(20)
    }
    .margin({ top: 10 })

  }
}