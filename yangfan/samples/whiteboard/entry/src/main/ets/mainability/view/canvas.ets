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

import LayerInfo from '../model/layer'
import {Layer} from '../view/layer'
import Logger from '../Logger'

@Component
export struct BCanvas {
  @State layers: Array<LayerInfo> = new Array()
//  del_layers: Array<LayerInfo> = new Array()
  @State showSet: boolean = false
  @State width: number = 1
  @State color: string = '#000000'
  private update: () => void

  build() {
    Stack() {
      Stack() {
        ForEach(this.layers, (item, index) => {
          Layer({ layerInfo: item })
        })
      }
      .backgroundColor('#fef')
      .width('100%')
      .height('100%')
      .onTouch((event) => {
        if (this.showSet) {
          return
        }
        let env = event.changedTouches[0]
        if (env.id > 0) {
          return
        }
        switch (env.type) {
          case TouchType.Down:
//            this.del_layers = new Array()
            var layer = new LayerInfo(this.width, this.color)
            layer.commands = `M${vp2px(env.x)} ${vp2px(env.y)} L${vp2px(env.x)} ${vp2px(env.y)}`
            this.layers.push(layer)
            break
          case TouchType.Move:
            this.layers[this.layers.length-1].commands += ` ${vp2px(env.x)} ${vp2px(env.y)}`
            break
          case TouchType.Up:
            Logger.info('Layer LayerInfo:' + this.layers[this.layers.length-1].commands)
            this.update()
            break
          default:
            break
        }
      })
    }
    .width('100%')
    .height('100%')


  }
}