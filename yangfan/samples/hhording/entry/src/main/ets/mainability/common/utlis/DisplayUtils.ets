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

import display from '@ohos.display'

class DisplayUtils{

  /**
   * 获取屏幕宽度
   */
  getDisplayWidth() {
    display.getDefaultDisplay((err, data) => {
      if(err) {
        console.info(`gjh the getDisplayWidth error is ${err}`)
      } else {
        return data.width
      }
    })
  }

  /**
   * 获取屏幕高度
   */
  getDisplayHeight() {
    display.getDefaultDisplay((err, data) => {
      if(err) {
        console.info(`gjh the getDisplayWidth error is ${err}`)
      } else {
        return data.height
      }
    })
  }

}

export default new DisplayUtils