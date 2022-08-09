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

import router from '@system.router';
import {CityInfo,LocationInfo} from '../model/whetherDataDetail'
import http from '@ohos.net.http'
import prompt from '@system.prompt';
@Component
@Entry
struct cityManagement{
  private locationInfo:LocationInfo = new LocationInfo()
  private locationId:string = ""
  private locationName:string = ""
  aboutToAppear(){
  }
  build(){
    Column(){
      Flex({justifyContent:FlexAlign.Start,alignItems: ItemAlign.Center}){
        Image($rawfile('backee.webp'))
          .width(20)
          .height(20)
          .margin({top:2.5,left: 15,right: 5})
        Text($r('app.string.back'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({left:5})
        .fontColor(Color.White)
        .onClick(() => {
          router.push({
            uri:"pages/index"
          })
        })
      }
      .height('7%')
      Divider()
       .color(Color.Gray)
      .opacity(0.6)
      .margin({bottom:20})
        Text($r('app.string.SelectCity'))
          .fontSize(25)
          .fontColor(Color.White)
      .margin({top:10})
      Text("西安")
        .fontSize(30)
      .backgroundColor('#559bd9')
      .borderRadius(10)
      .width('80%')
      .height(50)
      .padding({left:10})
      .margin({top:30})
        .fontColor(Color.White)
      .textAlign(TextAlign.Center)
        .onClick(() => {
          this.locationName = "西安"
          this.getRequestId()
        })
      Text("北京")
        .fontSize(30)
        .backgroundColor('#559bd9')
        .borderRadius(10)
        .width('80%')
        .fontColor(Color.White)
        .height(50)
        .padding({left:10})
        .margin({top:10})
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.locationName = "北京"
          this.getRequestId()
        })
      Text("上海")
        .fontSize(30)
        .backgroundColor('#559bd9')
        .borderRadius(10)
        .width('80%')
        .height(50)
        .padding({left:10})
        .fontColor(Color.White)
        .margin({top:10})
        .textAlign(TextAlign.Center)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.locationName = "上海"
          this.getRequestId()
        })
      Text("广州")
        .fontSize(30)
        .backgroundColor('#559bd9')
        .borderRadius(10)
        .width('80%')
        .height(50)
        .fontColor(Color.White)
        .padding({left:10})
        .margin({top:10})
        .textAlign(TextAlign.Center)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.locationName = "广州"
          this.getRequestId()
        })
      Text("杭州")
        .fontSize(30)
        .backgroundColor('#559bd9')
        .borderRadius(10)
        .width('80%')
        .height(50)
        .padding({left:10})
        .fontColor(Color.White)
        .margin({top:10})
        .textAlign(TextAlign.Center)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.locationName = "杭州"
          this.getRequestId()
        })
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
  }
  getRequestId(){
    let url = 'https://geoapi.qweather.com/v2/city/lookup?key=07a00515d20a413cb14abe0e9f58a6ab&location=' + this.locationName
    let httpRequest2 = http.createHttp()
    httpRequest2.request(encodeURI(url)).then(data => {
      if(data.responseCode == 200){
        //解析数据
        var cityinfo:CityInfo = JSON.parse(data.result.toString())
        if(cityinfo.code == 200){
          this.locationId = cityinfo.location[0].id
          this.locationName = cityinfo.location[0].name
        }else{
          //接口异常，弹出提示
          prompt.showToast({message:cityinfo.code.toString(),duration:1000})
        }
      }else{
        //请求失败，弹出提示
        prompt.showToast({message:'网络异常',duration:1000})
      }
      router.push({
        uri: 'pages/index',
        params:{
          "locationId":this.locationId,
          "locationName":this.locationName
        }
      })
    })
  }
}