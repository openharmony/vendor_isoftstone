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

import {NowQuality} from '../model/whetherDataDetail'

//空气污染图像
@Component
export struct ProgressBar {
  @Link progress: NowQuality
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private settings1: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private context1: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings1)

  build() {

    Stack({ alignContent: Alignment.Center }) {

      Canvas(this.context) //画布1
        .width(150)
        .height(150)
        .onReady(() => {
          this.context.lineWidth = 17
          this.context.strokeStyle = '#f6d339'
          //          this.context.arc(70, 75, 55, 0, (this.progress.aqi / 500) * 6.28)//设置弧的起始坐标，半径、起始位置、终止位置
          this.context.arc(70, 75, 55, 4.71, (this.progress.aqi / 500) * 6.28 + 4.71)


          this.context.stroke();
        })


      Canvas(this.context1) //画布2
        .width(150)
        .height(150)
        .onReady(() => {
          this.context1.lineWidth = 17
          this.context1.strokeStyle = '#77aee0'
          //          this.context1.arc(70, 75, 55, (this.progress.aqi / 500) * 6.28, 6.28)//起始位置是坐标轴x正半轴处
          this.context1.arc(70, 75, 55, (this.progress.aqi / 500) * 6.28 + 4.71, 4.71) //起始位置是坐标轴y轴正半轴处

          this.context1.stroke();
        })
        .opacity(0.4)

      Column({ space: 2 }) {
        Text(this.progress.category)
          .fontSize(15)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)

        Text(this.progress.aqi.toString())
          .fontSize(30)
          .fontColor(Color.White)
      }
      .width(100)
      .padding({ right: 10 })

    }
    .margin({ top: 15 })
    .width(150)
    .height(150)

  }
}
