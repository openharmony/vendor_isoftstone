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

import window from '@ohos.window'

/**
 * 屏幕设置
 */
class WindowUtils {

  /**
   * 设置屏幕全屏
   * @param isFull 是否全屏
   * 不含状态栏和导航栏
   */
  setFullScreen(isFull: boolean): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      window.getTopWindow().then((win) => {
        try {
          win.setFullScreen(isFull).then(() => {
            resolve()
          }).catch((err) => {
            reject(err)
          })
        } catch (err) {
          reject(err)
        }
      })
    })
  }

  /**
   * 设置状态栏和导航栏的显示
   * @param names需要隐藏的栏（数组形式）
   */
  setSystemBarEnable( names: Array<'status' | 'navigation'> ) {
    return new Promise<void>((resolve, reject) => {
      window.getTopWindow().then((win) => {
        try {
          win.setSystemBarEnable(names).then(() => {
            resolve()
          }).catch((err) => {
          reject(err)
          })
        } catch (err) {
          reject(err)
        }
      })
    })
  }

}

export default new WindowUtils