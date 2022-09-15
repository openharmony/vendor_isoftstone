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
import prompt from '@system.prompt'
import router from '@system.router'
import { CurrentWeather, DailyForecast, HourlyForecast, AirQuality, NowQuality, NowData, HourlyData, DailyData,
  WeatherWarning, WarningData } from '../model/weatherData'
import {weatherGrid} from '../componments/weatherGrid'
import {weatherList} from '../componments/weatherList'
import {airQuality}  from '../componments/airQuality'
@Entry
@Component
struct Index {
  @State private nowData: NowData = new NowData()
  @State hourlyData: HourlyData[] = []
  @State private dailyData: DailyData[] = []
  @State private nowQuality: NowQuality = new NowQuality()
  @State private warningData: WarningData[] = []
  @State private locationName: string = ""
  @State private locationId: string = ""
  @State nowWeatherUrl: string = 'https://devapi.qweather.com/v7/weather/now?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  @State hourlyWeatherUrl: string = 'https://devapi.qweather.com/v7/weather/24h?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  @State dailyWeatherUrl: string = 'https://devapi.qweather.com/v7/weather/7d?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  @State qualityWeatherUrl: string = 'https://devapi.qweather.com/v7/air/now?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  @State warningWeatherUrl: string = 'https://devapi.qweather.com/v7/warning/now?key=07a00515d20a413cb14abe0e9f58a6ab&location='
  scroller: Scroller = new Scroller()
  aboutToAppear() {
    console.log('start operate')
    if (router.getParams() != null) {
      this.locationId = router.getParams().locationId.toString()
      this.locationName = router.getParams().locationName.toString()
    }
    let self = this
    this.nowData.temp='36'
    this.dailyData[0]={fxDate:"2022-09-14",sunrise:"06:20",sunset:"18:36",moonrise:"15:24",moonset:"01:03",moonPhase:"盈凸月",moonPhaseIcon:"803",tempMax:"29",tempMin:"16",iconDay:"100",textDay:"晴",iconNight:"150",textNight:"晴",wind360Day:"225",windDirDay:"西南风",windScaleDay:"1-2",windSpeedDay:"3",wind360Night:"180",windDirNight:"南风",windScaleNight:"1-2",windSpeedNight:"3",humidity:"33",precip:"0.0",pressure:"962",vis:"25",cloud:"25",uvIndex:"7",dew: '',today:'', months:0,day:0}
    this.nowData.text="多云"
    this.nowQuality={"pubTime":"2022-09-06T10:00+08:00","aqi":63,"level":2,"category":"良","primary":"PM10","pm10":76,"pm2p5":19,"no2":43,"so2":8,"co":0.6,"o3":6}
    //    this.warningData=[]
    if (this.locationName === "") { //if语句。当locationName为空时，用西安的值；当不为空时，用传过来的参数locationName;现在拿不到传过来的参数
      this.locationName = "西安"
      this.nowWeatherUrl = this.nowWeatherUrl + '101110101'
      this.hourlyWeatherUrl = this.hourlyWeatherUrl + '101110101'
      this.dailyWeatherUrl = this.dailyWeatherUrl + '101110101'
      this.qualityWeatherUrl = this.qualityWeatherUrl + '101110101'
      this.warningWeatherUrl = this.warningWeatherUrl + '101110101'
    } else {
      console.log('123')
      this.nowWeatherUrl = this.nowWeatherUrl + this.locationId
      this.hourlyWeatherUrl = this.hourlyWeatherUrl + this.locationId
      this.dailyWeatherUrl = this.dailyWeatherUrl + this.locationId
      this.qualityWeatherUrl = this.qualityWeatherUrl + this.locationId
      this.warningWeatherUrl = this.warningWeatherUrl + this.locationId
    }

    this.getRequestNowData()
    this.getRequestHourlyData()
    this.getRequestDailyData()
    this.getRequestAirQuality()
    this.getRequestWarning()

  }
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Scroll(this.scroller) {
        //沿垂直方向布局的容器
        Column() {
          //
          Flex({ justifyContent: FlexAlign.End }) {
            Text("切换城市")
              .margin({ right: 15, top: 10 })
              .fontSize(20)
              .fontColor(Color.White)
          }
          .onClick(() => {
            router.push({
              uri: 'pages/cityChange'
            })
          })

          Flex({ justifyContent: FlexAlign.Center }) {
            Text(this.locationName)
              .fontSize(30)
              .margin({ top: 30 })
              .fontColor(Color.White)
              .onClick(() => {
                router.push({
                  uri: "pages/cityChange"
                })
              })
          }
          Text(this.nowData.temp+ '℃')
            .fontSize(60)
            .fontColor(Color.White)
          Text(this.dailyData[0].tempMin + " / " + this.dailyData[0].tempMax + "℃")
            .fontSize(20)
            .fontColor(Color.White)
          Text(this.nowData.text + ' | 空气' + this.nowQuality.category)
            .fontSize(20)
            .fontColor(Color.White)
            .margin({ top: 6, bottom: 15 })
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
          weatherGrid({hourlyData:$hourlyData})
          weatherList({dailyData:$dailyData})

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
          airQuality({nowQuality:$nowQuality})
        }
        .width('100%')
        .backgroundImage($rawfile("background.jpg"))
        .backgroundImageSize(ImageSize.Cover)
      }
      .scrollable(ScrollDirection.Vertical)
      //      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray).scrollBarWidth(30)
    }
    .width('100%')
  }
  getRequestNowData() {
    let self = this
    console.log('getRequest start ====')
    let httpRequest = http.createHttp()
    httpRequest.request(self.nowWeatherUrl, (err, data) => {
      if (!err) {
        if (data.responseCode == 200) {
          var currentWeather: CurrentWeather = JSON.parse(data.result.toString())
          console.log('cW:',currentWeather)
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
    })
  }
  //获得每小时的天气数据
  getRequestHourlyData(){
    let httpRequest=http.createHttp()
    httpRequest.request(this.hourlyWeatherUrl,(err,data)=>{
      if (!err) {
        if (data.responseCode == 200) {
          //解析数据
          var getHourlyData:HourlyForecast = JSON.parse(data.result.toString())
          if (getHourlyData.code == 200) {
            this.hourlyData = getHourlyData.hourly
          } else {
            //接口异常
            prompt.showToast({message:getHourlyData.code.toString(),duration:1000})
          }
          //http请求失败
        } else {
          prompt.showToast({message:'network anomaly',duration:1000})
          console.log('network request error ='+ JSON.stringify(data.responseCode))
        }
      } else{
        prompt.showToast({message:err.message,duration:1000})
        console.log('network request error ='+ JSON.stringify(err))
      }
    })
  }
  //获得每天天气情况数据
  getRequestDailyData(){
    let httpRequest = http.createHttp()
    httpRequest.request(this.dailyWeatherUrl,(err,data) => {
      if (!err) {
        if (data.responseCode == 200) {
          var getDailyData : DailyForecast = JSON.parse(data.result.toString())
          if (getDailyData.code == 200) {
            this.dailyData = getDailyData.daily
            for(var i = 0; i < 7; i++) {
              if (i == 0) {
                this.dailyData[0].today = "今天"
              }
              if (i == 1) {
                this.dailyData[1].today = "明天"
              }
              var dateArray = this.dailyData[i].fxDate.split("-")
              var date = new Date(parseInt(dateArray[0]), parseInt(dateArray[1]) - 1, parseInt(dateArray[2]))
              this.dailyData[i].today = "周" + "日一二三四五六".charAt(date.getDay())
              this.dailyData[i].months = date.getMonth() + 1
              this.dailyData[i].day = date.getDate()
            }
          } else {
            //接口异常
            prompt.showToast({message:getDailyData.code.toString(),duration:1000})
          }
        } else {
          prompt.showToast({message:'network anomaly',duration:1000})
          console.log('network request error ='+ JSON.stringify(data.responseCode))
        }
      } else {
        prompt.showToast({message:err.message,duration:1000})
        console.log('network request error ='+ JSON.stringify(err))
      }
    })
  }
  //获得空气质量数据
  getRequestAirQuality() {
    let httpRequest = http.createHttp()
    httpRequest.request(this.qualityWeatherUrl, (err, data) => {
      if (!err) {
        if (data.responseCode == 200) {
          var getAirData : AirQuality = JSON.parse(data.result.toString())
          if (getAirData.code == 200) {
            this.nowQuality = getAirData.now
          } else {
            //接口异常
            prompt.showToast({message:getAirData.code.toString(),duration:1000})
          }
        } else {
          prompt.showToast({message:'network anomaly',duration:1000})
          console.log('network request error ='+ JSON.stringify(data.responseCode))
        }
      } else {
        prompt.showToast({message:err.message,duration:1000})
        console.log('network request error ='+ JSON.stringify(err))
      }
    })
  }
  // 获得预警信息数据
  getRequestWarning() {
    let httpRequest = http.createHttp()
    httpRequest.request(this.warningWeatherUrl, (err, data) => {
      if (!err) {
        if (data.responseCode == 200) {
          var getWearingData :WeatherWarning = JSON.parse(data.result.toString())
          if (getWearingData.code == 200) {
            this.warningData = getWearingData.warning
          }else {
            //接口异常
            prompt.showToast({message:getWearingData.code.toString(),duration:1000})
          }
        } else {
          prompt.showToast({message:'network anomaly',duration:1000})
          console.log('network request error ='+ JSON.stringify(data.responseCode))
        }
      } else {
        prompt.showToast({message:err.message,duration:1000})
        console.log('network request error ='+ JSON.stringify(err))
      }
    })
  }
}