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

import { FoodGrid } from './FoodGrid'

@Component
export struct TabList {
  @State currentIndex: number = 0 //当前标签页
  @Consume foodLists: any
  @Link orderList: any
  private menuList: Array<string> = ['今日特价', '荤菜', '素菜', '汤类', '小吃', '饮料']
  private imageList: Array<any> = [ $r('app.media.recommend_unchoose'), $r('app.media.meat_dishes_unchoose'), $r("app.media.vegetables_dishes_unchoose"),
  $r('app.media.soup_dishes_unchoose'), $r('app.media.snack_dishes_unchoose'), $r('app.media.drink_dishes_unchoose')]
  private imageChoose: Array<any> = [$r('app.media.recommend_choose'), $r('app.media.meat_dishes_choose'), $r('app.media.vegetables_dishes_choose'),
  $r('app.media.soup_dishes_choose'), $r('app.media.snack_dishes_choose'), $r('app.media.drink_dishes_choose')]


  @Builder tabItem(index: number) {
    Row() {
      Text(this.menuList[index])
      .width('80%')
      .fontSize('20px')
      .fontColor(this.currentIndex == index ? '#f0494d' : '#000000')
      .textAlign(TextAlign.Center)
      Image(this.currentIndex == index ? this.imageChoose[index] : this.imageList[index])
      .width('14%')
      .height('24%')
      .objectFit(ImageFit.Fill)
      .position({ x: '73%', y: '36%'})
    }
    .width('95%')
    .height('100%')
    .backgroundColor('#f8f8f8')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start }) {
        ForEach(this.menuList, (menuItem, index) => {
          TabContent() {
            FoodGrid({ orderList: $orderList, foodLists: this.foodLists.filter(item => (item.foodType.indexOf(menuItem)) != -1) })
          }.tabBar(this.tabItem(index))
        })
      }
      .width('100%')
      .height('90%')
      .barWidth('14%')
      .barHeight('100%')
      .barMode(BarMode.Fixed)
      .vertical(true)
      .scrollable(false)
      .animationDuration(0)
      .margin({ top: '1%' })
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
  }
}