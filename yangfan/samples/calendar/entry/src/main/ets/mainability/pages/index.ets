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
# limitations under the License.
*/

import StorageUtil from '../config/StorageUtil'
import LayoutConstant from '../config/LayoutConstant'

@Entry
@Component
struct calendar {
  private date = new Date()
  @State private thisItem: number = -1
  @State remark: string = ''
  @State month: number = this.date.getMonth() + 1
  private days1: Array<number>
  private year: number = this.date.getFullYear()
  private day: number
  private week: number
  private thisYear
  private thisMonth
  private days: number
  private blank: Array<string>
  private show: boolean = false
  private dataStr: string = ''
  private visibility: Visibility = Visibility.None
  private defaultValue: string = ''
  private aaa: Array<string> = ['日', '一', '二', '三', '四', '五', '六']
  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Image($r('app.media.left')).backgroundColor(Color.Red).height($r("app.float.length_24")).width($r("app.float.length_24")).onClick(() => {
          if (this.month == 1) {
            this.month = 12
            --this.year
          }
          else {
            --this.month
          }
          this.month_days()
        })
        Image($r('app.media.right')).height($r("app.float.length_24")).width($r("app.float.length_24")).onClick(() => {
          if (this.month == 12) {
            this.month = 1
            ++this.year
          }
          else {
            ++this.month
          }
          this.month_days()
        })
      }.width(LayoutConstant.WH_90_100).margin({ top: $r("app.float.length_10"), bottom: $r("app.float.length_10") }).height(LayoutConstant.WH_5_100)

      Text(this.year + '年' + this.month + '月').fontSize(30)
      Grid() {
        ForEach(this.aaa, item => {
          GridItem() {
            Text(item).fontSize($r("app.float.length_20")).fontWeight(FontWeight.Bold)
          }
        })
      }.columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .rowsTemplate('1fr')
      .margin({ top: $r("app.float.length_10"), bottom: $r("app.float.length_10") })
      .height(30)
      Grid() {
        ForEach(this.blank, () => {
          GridItem() {
          }
        })
        ForEach(this.days1, (item: number) => {
          GridItem() {
            if (this.thisItem === item && this.thisMonth === this.month && this.thisYear === this.year) {
              Text((item + 1).toString())
                .fontSize($r("app.float.length_20"))
                .width($r("app.float.length_30"))
                .height($r("app.float.length_30"))
                .backgroundColor('#29bafe')
                .borderRadius($r("app.float.length_10"))
                .textAlign(TextAlign.Center)
            }
            else if (this.date.getDate() === new Date(this.year, this.month - 1, item + 1).getDate() && this.date.getFullYear() === new Date(this.year, this.month - 1, item + 1).getFullYear() && this.date.getMonth() === new Date(this.year, this.month - 1, item + 1).getMonth()) {
              Text((item + 1).toString())
                .fontSize($r("app.float.length_20"))
                .width($r("app.float.length_30"))
                .height($r("app.float.length_30"))
                .borderRadius($r("app.float.length_10"))
                .borderColor('#29bafe')
                .borderWidth(2)
                .textAlign(TextAlign.Center)
            }
            else {
              Text((item + 1).toString()).fontSize($r("app.float.length_20"))
                .width($r("app.float.length_30"))
                .height($r("app.float.length_30"))
                .textAlign(TextAlign.Center)
            }
          }.onClick(() => {
            this.day = new Date(this.year, this.month - 1, item + 1).getDate()
            this.show = !this.show
            this.thisItem = item
            this.thisYear = this.year
            this.thisMonth = this.month
            this.dataStr = this.year + '.' + this.month + '.' + this.day
            StorageUtil.getValueSync(this.dataStr, '', data => {
              this.remark = data
              if (this.remark == '') {
                this.visibility = Visibility.None
              } else {
                this.visibility = Visibility.Visible
              }
            })
          })
        })
      }.height(LayoutConstant.WH_50_100)
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .rowsGap(10)

      Panel(this.show) {
        Column() {
          Text(this.year + '年' + this.month + '月' + this.day + '日')
            .fontSize($r("app.float.length_20"))
            .textAlign(TextAlign.Center)
            .width(LayoutConstant.WH_95_100)
          Text(this.remark)
            .backgroundColor('')
            .fontSize($r("app.float.length_20"))
            .width(LayoutConstant.WH_95_100)
            .height($r("app.float.length_60"))
            .borderRadius(15)
            .margin({ top: 5 })
            .textAlign(TextAlign.Center)
            .visibility(this.visibility)
          TextArea({ text: this.defaultValue })
            .placeholderColor("#2b2b2b")
            .placeholderFont({ size: 30, weight: 100, family: 'cursive', style: FontStyle.Italic })
            .textAlign(TextAlign.Center)
            .caretColor(Color.Blue)
            .height($r("app.float.length_60"))
            .fontSize($r("app.float.length_20"))
            .fontWeight(FontWeight.Bold)
            .fontFamily("sans-serif")
            .fontStyle(FontStyle.Normal)
            .margin({ left: $r("app.float.length_10"), right: $r("app.float.length_10") })
            .onChange((value: string) => {
              this.defaultValue = value
            })
          Button() {
            Text($r('app.string.save'))
              .fontSize($r("app.float.length_20"))
          }.width($r("app.float.length_80"))
          .margin({ top: $r("app.float.length_10") })
          .backgroundColor('#9f9f9f')
          .onClick(() => {
            StorageUtil.setValue(this.dataStr, this.defaultValue)
            this.defaultValue = ' '
            this.show = false
          })
        }
      }
      .type(PanelType.Foldable)
      .mode(PanelMode.Full)
      .dragBar(true)
      .height(LayoutConstant.WH_70_100)
    }
  }
  aboutToAppear() {
    this.month_days()
  }

  month_days() {
    if (this.month == 1 || this.month == 3 || this.month == 5 || this.month == 7 || this.month == 8 || this.month == 10 || this.month == 12) {
      this.days = 31
    }
    else if (this.month == 4 || this.month == 6 || this.month == 9 || this.month == 11) {
      this.days = 30
    }
    else if ((this.year % 4 == 0 && this.year % 100 != 0) || this.year % 400 == 0) {
      this.days = 29
    }
    else {
      this.days = 28
    }
    this.days1 = [...Array(this.days).keys()]
    this.week = new Date(this.year, this.month - 1, 1).getDay()
    this.blank = Array(this.week)
  }
}


