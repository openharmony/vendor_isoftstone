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
import {NowQuality} from '../model/weatherData'

@Component
export struct pollutionIndex {
  @Link indexNum: NowQuality
  //创建一个CanvasRenderingContext2D 实例，在 Canvas 上绘制具体内容
  //初始化RenderingContextSettings并设置为抗锯齿
  private setting: RenderingContextSettings = new RenderingContextSettings(true)
  private sett: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting)
  private con: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.sett)

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Canvas(this.context) //画布1
        .width(150)
        .height(150)
        .onReady(() => {
          this.context.lineWidth = 18
          this.context.strokeStyle = '#edeede8e'
          this.context.arc(70, 75, 55, 4.71, (this.indexNum.aqi / 500) * 6.28 + 4.71)
          this.context.stroke()
        })

      Canvas(this.con) //画布2
        .width(150)
        .height(150)
        .onReady(() => {
          this.con.lineWidth = 15
          this.con.strokeStyle = '#ff70a2cd'
          this.con.arc(70, 75, 55, (this.indexNum.aqi / 500) * 6.28 + 4.71, 4.71) //起始位置是坐标轴y轴正半轴处
          this.con.stroke()
        })
        .opacity(0.3) //透明度

      Column({ space: 3 }) {
        Text(this.indexNum.category)
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)

        Text(this.indexNum.aqi.toString())
          .fontSize(30)
          .fontColor(Color.Black)
      }
      .width(100)
      .padding({ right: 10 })

    }
    .margin({ top: 5 })
    .width(150)
    .height(150)
  }
}