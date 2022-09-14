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

import SettingCallback from '../callback'
import LayerInfo from '../model/layer'
import Logger from '../Logger'

@Preview
@Component
export struct SettingView {
  @State showSet: boolean = true
  @State width: number = 1
  @State r: number = 0
  @State g: number = 0
  @State b: number = 0
  @State isClean: boolean = false
  callback: SettingCallback = undefined

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
        Button() {
          Image($r("app.media.confirm"))
            .width('100%')
            .height('100%')
        }
        .align(Alignment.Center)
        .backgroundColor('#ffffff')
        .margin({ right: vp2px(18), top: vp2px(15) })
        .type(ButtonType.Normal)
        .width(vp2px(30))
        .height(vp2px(30))
        .onClick(() => {
          let color = `#${ts(this.r)}${ts(this.g)}${ts(this.b)}`
          this.callback.call(new LayerInfo(parseInt(this.width.toFixed(0)), color))
        })
      }
      .width('100%')

      Text('画笔宽度').fontSize(vp2px(18)).fontColor('#00278a').margin({ left: vp2px(14) })
      Row() {
        Slider({
          value: this.width,
          min: 0,
          max: 20,
          step: 1,
          style: SliderStyle.OutSet
        })
          .blockColor(Color.Blue)
          .trackColor(Color.Gray)
          .selectedColor(Color.Blue)
          .showSteps(true)
          .showTips(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.width = value
            Logger.info('value:' + value + 'mode:' + mode.toString())
          })
        Text(this.width.toFixed(0)).fontSize(vp2px(16))
      }
      .width('90%')

      Row() {
        Text('画笔颜色').fontSize(vp2px(18)).fontColor('#000000')
        Text()
          .backgroundColor(`#${ts(this.r)}${ts(this.g)}${ts(this.b)}`)
          .width(vp2px(40))
          .height(vp2px(20))
          .margin({ left: vp2px(14) })
      }.margin({ left: vp2px(14), top: vp2px(14) })

      Row() {
        Text('红').fontSize(vp2px(16)).fontColor('#FF0000')
        Slider({
          value: this.r,
          min: 0,
          max: 255,
          step: 1,
          style: SliderStyle.OutSet
        })
          .blockColor(Color.Red)
          .trackColor(Color.Gray)
          .selectedColor(Color.Red)
          .showSteps(true)
          .showTips(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.r = value
          })

      }
      .width('85%')
      .margin({ top: vp2px(14), left: vp2px(14) })

      Row() {
        Text('绿').fontSize(vp2px(16)).fontColor('#00FF00')
        Slider({
          value: this.g,
          min: 0,
          max: 255,
          step: 1,
          style: SliderStyle.OutSet
        })
          .blockColor(Color.Green)
          .trackColor(Color.Gray)
          .selectedColor(Color.Green)
          .showSteps(true)
          .showTips(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.g = value
          })

      }
      .width('85%')
      .margin({ top: vp2px(14), left: vp2px(14) })

      Row() {
        Text('蓝').fontSize(vp2px(16)).fontColor('#0000FF')
        Slider({
          value: this.b,
          min: 0,
          max: 255,
          step: 1,
          style: SliderStyle.OutSet
        })
          .blockColor(Color.Blue)
          .trackColor(Color.Gray)
          .selectedColor(Color.Blue)
          .showSteps(true)
          .showTips(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.b = value
          })

      }
      .width('85%')
      .margin({ top: vp2px(14), left: vp2px(14) })

      Button(this.isClean ? '画笔' : '橡皮擦', { type: ButtonType.Normal, stateEffect: true })
        .backgroundColor(this.isClean ? '#FFEEFF' : '#fffa9f')
        .fontColor(Color.Black)
        .margin({ top: vp2px(14), left: vp2px(14) })
        .onClick(() => {
          this.isClean = !this.isClean
          let color = `#${ts(this.r)}${ts(this.g)}${ts(this.b)}`
          this.callback.call(new LayerInfo(parseInt(this.width.toFixed(0)), this.isClean ? '#FFEEFF' : color))
        })
        .border({ width: vp2px(1), color: '#0a0909' })
    }
    .width('100%')
    .height('50%')
    .backgroundColor(0xFFFFFF)
    .padding({ top: 5, left: vp2px(10) })
    .alignItems(HorizontalAlign.Start)
    .visibility(this.showSet ? Visibility.Visible : Visibility.None)
    .position({ x: 0, y: '50%' })
  }
}

function ts(value: number) {
  let num = parseInt(value.toFixed(0))
  return num > 9 ? num.toString(16) : '0' + num.toString(16)
}