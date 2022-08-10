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
import { TabList } from '../common/xcomponent/TabList'
import { FoodListDialog } from '../common/xcomponent/FoodListDialog'
import windowUtils from '../common/utils/WindowUtils'
import app from '@system.app';

@Entry
@Component
export struct FoodList {
  @Provide totalNumber: number = 0 //总点菜数
  @State orderList: any = [] //购物车菜单
  @Provide totalPrice: number = 0 //总价格
  @Provide total: number = 0  //弹窗关闭时刷新totalNumber数据
  private order: string = '下单'
  @Provide foodLists: any = [{
                              'foodImageSrc': $r("app.media.boiled_meat"),
                              'foodName': '水煮肉片',
                              'price': '56',
                              'foodType': '今日特价 + 荤菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.braised_meat'),
                              'foodName': '红烧肉',
                              'price': '45',
                              'foodType': '荤菜 今日特价',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.broccoli'),
                              'foodName': '西兰花',
                              'price': '20',
                              'foodType': '素菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.chicken'),
                              'foodName': '宫保鸡丁',
                              'price': '45',
                              'foodType': '荤菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.fruit_juice'),
                              'foodName': '果汁',
                              'price': '10',
                              'foodType': '饮料',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.cakes'),
                              'foodName': '糕点',
                              'price': '20',
                              'foodType': '小吃',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r("app.media.spring_rolls"),
                              'foodName': '香菇豆干',
                              'price': '17',
                              'foodType': '素菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.cocktail'),
                              'foodName': '鸡尾酒',
                              'price': '15',
                              'foodType': '饮料',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.crispy_shrimp'),
                              'foodName': '香酥虾',
                              'price': '58',
                              'foodType': '荤菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.duckMeat'),
                              'foodName': '北京烤鸭',
                              'price': '98',
                              'foodType': '荤菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.ice_red_tea'),
                              'foodName': '冰红茶',
                              'price': '12',
                              'foodType': '饮料',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.lotus'),
                              'foodName': '荷塘月色',
                              'price': '20',
                              'foodType': '素菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.mushroom'),
                              'foodName': '香菇青菜',
                              'price': '18',
                              'foodType': '素菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.rolls'),
                              'foodName': '春卷',
                              'price': '18',
                              'foodType': '小吃',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.sour_cabbage'),
                              'foodName': '醋溜白菜',
                              'price': '20',
                              'foodType': '素菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.sprite'),
                              'foodName': '雪碧',
                              'price': '6',
                              'foodType': '饮料',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.sugar_ball'),
                              'foodName': '糖球',
                              'price': '15',
                              'foodType': '小吃',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.sweet_cake'),
                              'foodName': '年糕',
                              'price': '18',
                              'foodType': '小吃',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.vegetables'),
                              'foodName': '炒青菜',
                              'price': '18',
                              'foodType': '素菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.white_mushroom'),
                              'foodName': '白玉菇养生汤',
                              'price': '22',
                              'foodType': '素菜 + 汤类',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.braised_steak_fillet'),
                              'foodName': '农家小炒肉',
                              'price': '32',
                              'foodType': '荤菜',
                              'orderNumber': 1
                            },
                            {
                              'foodImageSrc': $r('app.media.pork_with_salted_vegetable'),
                              'foodName': '梅菜扣肉',
                              'price': '52',
                              'foodType': '荤菜',
                              'orderNumber': 1
                            },
                             {
                               'foodImageSrc': $r('app.media.biscuit'),
                               'foodName': '饼干',
                               'price': '10',
                               'foodType': '小吃',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.water_broccoli'),
                               'foodName': '清水芙蓉',
                               'price': '20',
                               'foodType': '素菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.cake'),
                               'foodName': '草莓蛋糕',
                               'price': '27',
                               'foodType': '小吃',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.doughnut'),
                               'foodName': '甜甜圈',
                               'price': '13',
                               'foodType': '小吃',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.hairy_crabs'),
                               'foodName': '大闸蟹',
                               'price': '88',
                               'foodType': '荤菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.lemon_juice'),
                               'foodName': '柠檬汁',
                               'price': '6',
                               'foodType': '饮料',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.mapo_tofu'),
                               'foodName': '麻婆豆腐',
                               'price': '23',
                               'foodType': '素菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.mutton_shashlik'),
                               'foodName': '烤羊肉串',
                               'price': '30',
                               'foodType': '荤菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.qiqu_cake'),
                               'foodName': '奇曲饼',
                               'price': '23',
                               'foodType': '小吃',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.red_bull'),
                               'foodName': '红牛',
                               'price': '7',
                               'foodType': '饮料',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.roast_turkey'),
                               'foodName': '烤火鸡',
                               'price': '68',
                               'foodType': '荤菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.spicy_crayfish'),
                               'foodName': '麻辣小龙虾',
                               'price': '88',
                               'foodType': '荤菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.strawberry'),
                               'foodName': '草莓宴',
                               'price': '23',
                               'foodType': '素菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.sushi'),
                               'foodName': '寿司',
                               'price': '15',
                               'foodType': '素菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.ve'),
                               'foodName': '什锦蔬菜沙拉',
                               'price': '25',
                               'foodType': '素菜',
                               'orderNumber': 1
                             },
                             {
                               'foodImageSrc': $r('app.media.eggplant_with_beans'),
                               'foodName': '豆角茄子',
                               'price': '23',
                               'foodType': '素菜',
                               'orderNumber': 1
                             }]

  aboutToAppear() {
    windowUtils.setFullScreen(true).then(() => {
      console.info('setFullScreen finished.')
    }).catch((err) => {
      console.error('setFullScreen err: ' + err)
    })
  }

  build() {
    Row() {
      Column() {
        Row() {
          Image($r('app.media.back'))
          .width('14px')
          .height('26px')
          .objectFit(ImageFit.Fill)
          .margin({ left: '30px' })
          .onClick(() => {
            this.onExitApp()
          })
          Text('返回')
          .fontSize('25px')
          .fontColor('#f0494d')
          .margin({ left: '35px' })
          .onClick(() => {
            this.onExitApp()
          })
        }
        .width('100%')
        .height('9%')
        .backgroundColor('#f8f8f8')
        TabList({ orderList: $orderList })
      }
      .width('92%')
      .height('100%')
      Column() {
          Badge({
            count: this.totalNumber,
            style: { color: '#f0494d', badgeColor: '#f8f8f8', badgeSize: 14, fontSize: 12 }
          }) {
            Column() {
              Image(this.totalNumber == 0 ? $r('app.media.shopping_cart_unchoosed') : $r('app.media.shopping_cart_choosed'))
              .width('90%')
              .height('50%')
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.dialogController.open()
              })
              Text('商品消费')
              .width('70px')
              .fontSize('17px')
              .fontColor(this.totalNumber == 0 ? '#000000' : '#f0494d')
              .margin({ top: '13px' })
              .onClick(() => {
                this.dialogController.open()
              })
            }
        }
        .width('45%')
        .height('8%')
        .margin({ top: '7%' })
      }
      .width('7%')
      .height('100%')
      .enabled(this.totalNumber == 0 ? false : true)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#f8f8f8')
      .margin({ left : '1%'})
    }
    .backgroundColor('#DADADA')
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: FoodListDialog({ cancel: this.onCancel, confirm: this.onConfirm, orderList: $orderList }),
    cancel: this.onCancel,
    autoCancel: true,
    customStyle: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: '430px', dy: '-22px' }
  })

  onCancel() {
    this.totalNumber = this.total
  }

  onConfirm() {
    this.orderList.length = 0
    this.totalNumber = 0
    this.totalPrice = 0
    this.total = 0
    router.push({
      url: 'pages/second'
    })
  }

  onExitApp() {
    app.terminate()
    console.info('exit app finished')
  }
}
