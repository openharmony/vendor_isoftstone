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

import router from '@ohos.router'

@Entry
@Component
struct Second{
  build() {
    Column() {
      Text('后厨正在处理')
      .fontSize(30)
      .fontColor(Color.Black)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
  onPageShow() {
    console.info('gjh teh onPageShow is start')
    setTimeout(() => {
      router.replace({
        url: 'pages/index'
      })
    },1000)
  }
}