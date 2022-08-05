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
import http from '@ohos.net.http'
import prompt from '@system.prompt';
import { CurrentWeather, DailyForecast, HourlyForecast, AirQuality, NowQuality, NowData, HourlyData, DailyData,
  WeatherWarning, WarningData } from '../model/whetherDataDetail'
import router from '@system.router';
import { AirDisplay } from '../xComponent/AirDisplay'
import { WhetherGrid } from '../xComponent/WhetherGrid'
import { WhetherList } from '../xComponent/WhetherList'

let self

@Entry
@Component
struct Index {
  @State private nowData: NowData = new NowData()
  @State private hourlyData: HourlyData[] = []
  @State private dailyData: DailyData[] = []
  @State private nowQuality: NowQuality = new NowQuality()
  @State private warningData: WarningData[] = []
  @State private locationName: string = ""
  @State private loactionId: string = ""
  @State nowWeatherUrl: string = 'https://devapi.qweather.com/v7/weather/now?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  @State hourlyWeatherUrl: string = 'https://devapi.qweather.com/v7/weather/24h?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  @State dailyWeatherUrl: string = 'https://devapi.qweather.com/v7/weather/7d?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  @State qualityWeatherUrl: string = 'https://devapi.qweather.com/v7/air/now?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  @State warningWeatherUrl: string = 'https://devapi.qweather.com/v7/warning/now?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  scroller: Scroller = new Scroller()
  aboutToAppear() {
    self = this
    console.log('index start')
    if (router.getParams() != null) {
      this.loactionId = router.getParams().locationId.toString()
      this.locationName = router.getParams().locationName.toString()
    }
    if (this.locationName === "") { //if语句。当locationName为空时，用西安的值；当不为空时，用传过来的参数locationName;现在拿不到传过来的参数
      this.locationName = "西安"
      this.nowWeatherUrl = this.nowWeatherUrl + 101110101
      this.hourlyWeatherUrl = this.hourlyWeatherUrl + 101110101
      this.dailyWeatherUrl = this.dailyWeatherUrl + 101110101
      this.qualityWeatherUrl = this.qualityWeatherUrl + 101110101
      this.warningWeatherUrl = this.warningWeatherUrl + 101110101
    } else {
      this.nowWeatherUrl = this.nowWeatherUrl + this.loactionId
      this.hourlyWeatherUrl = this.hourlyWeatherUrl + this.loactionId
      this.dailyWeatherUrl = this.dailyWeatherUrl + this.loactionId
      this.qualityWeatherUrl = this.qualityWeatherUrl + this.loactionId
      this.warningWeatherUrl = this.warningWeatherUrl + this.loactionId
    }
    //拿数据赋给此组件成员变量
    this.getRequestCurrent()
    this.getRequestDaily()
    this.getRequestHourly()
    this.getRequestQuality()
    this.getRequestWarning()
  }
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll(this.scroller) {
        Column() {
          Flex({ justifyContent: FlexAlign.End }) {
            Text("切换城市")
              .margin({ right: 15, top: 10 })
              .fontSize(20)
              .fontColor(Color.White)
          }
          .onClick(() => {
            router.push({
              uri: 'pages/cityManagement'
            })
          })
          Flex({ justifyContent: FlexAlign.Center }) {
            Text(this.locationName)
              .fontSize(35)
              .margin({ top: 30 })
              .fontColor(Color.White)
              .onClick(() => {
                router.push({
                  uri: 'pages/cityManagement'
                })
              })
          }
          Text(this.nowData.temp + "℃")
            .fontSize(60)
            .fontColor(Color.White)
          Text(this.dailyData[0].tempMin + " / " + this.dailyData[0].tempMax + "℃")
            .fontSize(20)
            .fontColor(Color.White)
          Text(this.nowData.text + ' | 空气' + this.nowQuality.category)
            .fontSize(20)
            .fontColor(Color.White)
            .margin({ top: 6, bottom: 15 })
          //判断是否有预警信息，有则显示预警界面部分
          if (this.warningData.length != 0) {
            //粗略预警
            Button({ type: ButtonType.Capsule }) {
              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Image($r('app.media.9998'))
                  .width(20)
                  .height(20)
                  .margin({ top: 2.5, left: 15, right: 10 })
                Text(this.warningData[0].typeName + this.warningData[0].level + "预警")
                  .fontSize(15)
                  .fontColor(Color.White)
              }
            }
            .width(150)
            .backgroundColor('#5296d3')
            .margin({ top: 6 })
            //详细预警
            Button({ type: ButtonType.Capsule }) {
              Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                Image($r('app.media.9998'))
                  .objectFit(ImageFit.Contain)
                  .width(20)
                  .height(20)
                  .margin({ top: 2.5, left: 5, right: 15 })
                Grid() {
                  GridItem() {
                    Text(this.warningData[0].text)
                      .fontSize(20)
                      .fontColor(Color.White)
                  }
                }
                .rowsTemplate('1fr ')
                .padding({ left: 10, right: 20 })
              }
            }
            .width('92%')
            .backgroundColor('#5296d3')
            .margin({ top: 30 })
          }
          WhetherGrid({ hourlyData: $hourlyData })
          WhetherList({ dailyData: $dailyData })
          Button({ type: ButtonType.Capsule }) {
            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Image($rawfile('calendar.webp'))
                .width(20)
                .height(20)
                .padding({ right: 6 })
              Text($r('app.string.seeMore'))
                .fontSize(20)
                .fontColor(Color.White)
            }
          }
          .width('92%')
          .backgroundColor('#5296d3')
          .margin({ top: 10, left: 15, right: 15 })
          AirDisplay({ nowQuality: $nowQuality })
          //lifeindexdisplay({lifeIndex: this.lifeIndex}) //生活指数
        }
        .width('100%')
        .backgroundImage($rawfile("background.jpg"))
        .backgroundImageSize(ImageSize.Cover)
      }
      .scrollable(ScrollDirection.Vertical)
      //      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray).scrollBarWidth(30)
    }
  }
  //实时数据传输
  getRequestCurrent() {
    self = this
    console.log('getRequest start ====')
    let httpRequest = http.createHttp()
    httpRequest.request(self.nowWeatherUrl, (err, data) => {
      if (!err) {
        if (data.responseCode == 200) {
          var currentWeather: CurrentWeather = JSON.parse(data.result.toString())
          if (currentWeather.code == 200) {
            self.nowData = currentWeather.now;
          } else {
            //接口异常，弹出提示
            prompt.showToast({ message: currentWeather.code.toString() , duration: 1000})
          }
        } else {
          //请求失败，弹出提示
          prompt.showToast({ message: '网络异常' , duration: 1000})
          console.log('network data error ==' + JSON.stringify(data.responseCode))
        }
      } else {
        //请求失败，弹出提示
        prompt.showToast({ message: err.message , duration: 1000})
        console.log(`network request error, error:${JSON.stringify(err)}`)
      }
    }
    )
  }
  //逐小时预报数据传输
  getRequestHourly() {
    let httpRequest = http.createHttp()
    httpRequest.request(this.hourlyWeatherUrl, (err, data) => {
      if (!err) {
        if (data.responseCode == 200) {
          //解析数据
          var hourlyForecast: HourlyForecast = JSON.parse(data.result.toString())
          if (hourlyForecast.code == 200) {
            this.hourlyData = hourlyForecast.hourly
          } else {
            //接口异常，弹出提示
            prompt.showToast({ message: hourlyForecast.code.toString() , duration: 1000})
          }
        } else {
          //请求失败，弹出提示
          prompt.showToast({ message: '网络异常' , duration: 1000})
          console.log('network data error ==' + JSON.stringify(data.responseCode))
        }
      } else {
        //请求失败，弹出提示
        prompt.showToast({ message: err.message , duration: 1000})
        console.log('network request error ==' + JSON.stringify(err))
      }
    }
    )
  }
  //逐天预报数据传输
  getRequestDaily() {
    let httpRequest = http.createHttp() //创建一个传输请求
    httpRequest.request(this.dailyWeatherUrl, (err, data) => { //传url和回调函数，其中err是错误信息，data是传过来的数据
      if (!err) {
        if (data.responseCode == 200) {
          //解析数据
          var dailyForecast: DailyForecast = JSON.parse(data.result.toString()) //将拿过来的json数据转换成对象
          if (dailyForecast.code == 200) {
            this.dailyData = dailyForecast.daily //把拿过来的数据需要用的部分的值赋给自定义的变量
            this.dailyData[0].weeke = "今天"
            this.dailyData[1].weeke = "明天"
            var dateArray = this.dailyData[0].fxDate.split("-")
            var date = new Date(parseInt(dateArray[0]), parseInt(dateArray[1]) - 1, parseInt(dateArray[2]))
            this.dailyData[0].monthe = date.getMonth() + 1
            this.dailyData[0].daye = date.getDate()
            dateArray = this.dailyData[1].fxDate.split("-")
            date = new Date(parseInt(dateArray[0]), parseInt(dateArray[1]) - 1, parseInt(dateArray[2]))
            this.dailyData[1].monthe = date.getMonth() + 1
            this.dailyData[1].daye = date.getDate()
            dateArray = this.dailyData[2].fxDate.split("-")
            date = new Date(parseInt(dateArray[0]), parseInt(dateArray[1]) - 1, parseInt(dateArray[2]))
            this.dailyData[2].weeke = "周" + "日一二三四五六".charAt(date.getDay())
            this.dailyData[2].monthe = date.getMonth() + 1
            this.dailyData[2].daye = date.getDate()
            dateArray = this.dailyData[3].fxDate.split("-")
            date = new Date(parseInt(dateArray[0]), parseInt(dateArray[1]) - 1, parseInt(dateArray[2]))
            this.dailyData[3].weeke = "周" + "日一二三四五六".charAt(date.getDay())
            this.dailyData[3].monthe = date.getMonth() + 1
            this.dailyData[3].daye = date.getDate()
            dateArray = this.dailyData[4].fxDate.split("-")
            date = new Date(parseInt(dateArray[0]), parseInt(dateArray[1]) - 1, parseInt(dateArray[2]))
            this.dailyData[4].weeke = "周" + "日一二三四五六".charAt(date.getDay())
            this.dailyData[4].monthe = date.getMonth() + 1
            this.dailyData[4].daye = date.getDate()
            dateArray = this.dailyData[5].fxDate.split("-")
            date = new Date(parseInt(dateArray[0]), parseInt(dateArray[1]) - 1, parseInt(dateArray[2]))
            this.dailyData[5].weeke = "周" + "日一二三四五六".charAt(date.getDay())
            this.dailyData[5].monthe = date.getMonth() + 1
            this.dailyData[5].daye = date.getDate()
            dateArray = this.dailyData[6].fxDate.split("-")
            date = new Date(parseInt(dateArray[0]), parseInt(dateArray[1]) - 1, parseInt(dateArray[2]))
            this.dailyData[6].weeke = "周" + "日一二三四五六".charAt(date.getDay())
            this.dailyData[6].monthe = date.getMonth() + 1
            this.dailyData[6].daye = date.getDate()
          } else {
            //接口异常，弹出提示
            prompt.showToast({ message: dailyForecast.code.toString(), duration: 1000 })
          }
        } else {
          //请求失败，弹出提示
          prompt.showToast({ message: '网络异常' , duration: 1000})
          console.log('network data error ==' + JSON.stringify(data.responseCode))
        }
      } else {
        //请求失败，弹出提示
        prompt.showToast({ message: err.message , duration: 1000})
        console.log('network request error ==' + JSON.stringify(err))
      }
    }
    )
  }
  //空气质量数据传输
  getRequestQuality() {
    console.log('getRequest start ====')
    let httpRequest = http.createHttp()
    httpRequest.request(this.qualityWeatherUrl, (err, data) => {
      if (!err) {
        if (data.responseCode == 200) {
          //解析数据
          var airQulity: AirQuality = JSON.parse(data.result.toString())
          if (airQulity.code == 200) {
            this.nowQuality = airQulity.now;
          } else {
            //接口异常，弹出提示
            prompt.showToast({ message: airQulity.code.toString() , duration: 1000})
          }
        } else {
          //请求失败，弹出提示
          prompt.showToast({ message: '网络异常' , duration: 1000})
          console.log('network data error ==' + JSON.stringify(data.responseCode))
        }
      } else {
        //请求失败，弹出提示
        prompt.showToast({ message: err.message , duration: 1000})
        console.log('network request error ==' + JSON.stringify(err))
      }
    }
    )
  }
  //警报信息传输
  getRequestWarning() {
    console.log('getRequest start ====')
    let httpRequest = http.createHttp()
    httpRequest.request(this.warningWeatherUrl, (err, data) => {
      if (!err) {
        if (data.responseCode == 200) {
          //解析数据
          var weatherWarning: WeatherWarning = JSON.parse(data.result.toString())
          console.log('WeatherWarning ==' + JSON.stringify(weatherWarning))
          if (weatherWarning.code == 200) {
            this.warningData = weatherWarning.warning;
          } else {
            //接口异常，弹出提示
            prompt.showToast({ message: weatherWarning.code.toString() , duration: 1000})
          }
        } else {
          //请求失败，弹出提示
          prompt.showToast({ message: '网络异常' , duration: 1000})
          console.log('network data error ==' + JSON.stringify(data.responseCode))
        }
      } else {
        //请求失败，弹出提示
        prompt.showToast({ message: err.message , duration: 1000})
        console.log('network request error ==' + JSON.stringify(err))
      }
    }
    )
  }
}

//生活指数
/*@Component
struct lifeindexdisplay{
  private lifeIndex

  build(){
    Column(){
      Flex(){
        Text('生活指数')
          .fontSize(20)
          .fontColor(Color.White)
          .width('50%')
        //          .padding({left:20})

        Text('更多 >')
          .fontSize(20)
          .fontColor(Color.White)
          .width('50%')
          .textAlign(TextAlign.End)
        //          .padding({right:20})
        //       .flexGrow(1)
      }
      .width('92%')
      Grid(){
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('湿度')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.humidity.toString() + '％')
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('体感温度')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.sentemp.toString() + '℃')
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('风力')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.windpower.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('风向')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.winddirection.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('穿衣')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.dressing.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('运动')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.motion.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('感冒')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.cold.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('紫外线')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.uv.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('洗车')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.carwash.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('钓鱼')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.gofishing.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('过敏')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.allergy.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('路况')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.pavementcon.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('防晒')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.sunscreen.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('晾晒')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.airing.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('晨练')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.morningexer.toString())
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
        GridItem(){
          Column(){
            Image($r('app.media.life'))
              .width(50)
              .height(50)
              .margin({bottom:10})
            Text('交通')
              .fontSize(20)
              .fontColor(Color.White)
            Text(this.lifeIndex.traffic.toString() )
              .fontSize(20)
              .fontColor(Color.White)
          }

        }
      }
      .rowsTemplate('1fr 1fr 1fr 1fr ')
      .columnsTemplate('1fr 1fr 1fr 1fr ')
      //      .columnsGap(0)
      //      .rowsGap(0)
      .width('92%')
      .backgroundColor('#5296d3')
      .margin({top: 10})
      .height(4 * 192 - 8)



    }
    .margin({top:10})

  }
}*/
