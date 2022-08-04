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
//生活指数
/*
export class LifeIndex{
  humidity:number;//湿度
  sentemp:number;//体感温度
  windpower:string;//风力
  winddirection:string;//风向
  dressing:string;//穿衣
  motion:string;//运动
  cold:string;//感冒
  uv:string;//紫外线
  carwash:string;//洗车
  gofishing:string;//钓鱼
  allergy:string;//过敏
  pavementcon:string;//路况
  sunscreen:string;//防晒
  airing:string;//晾晒
  morningexer:string;//晨练
  traffic:string;//交通

  constructor(humidity:number,sentemp:number,windpower:string,winddirection:string,dressing:string,motion:string,cold:string,uv:string,carwash:string,gofishing:string,allergy:string,pavementcon:string,sunscreen:string,airing:string,morningexer:string,traffic:string){
    this.humidity = humidity;
    this.sentemp=sentemp;
    this.windpower = windpower;
    this.winddirection = winddirection;
    this.dressing = dressing;
    this.motion = motion;
    this.cold = cold;
    this.uv = uv;
    this.carwash = carwash;
    this.gofishing = gofishing;
    this.allergy = allergy;
    this.pavementcon = pavementcon;
    this.sunscreen = sunscreen;
    this.airing = airing;
    this.morningexer = morningexer;
    this.traffic = traffic;
  }


}*/


//实时数据
export class CurrentWeather{

  code:number;
  updateTime:string;
  fxLink:string;
  now:NowData;


  refer: {
    sources: [
        QWeather:string,
        NMC:string,
        ECMWF:string
    ],
    license: [
        commerciallicense:string
    ]
  }

}
export class NowData {
  obsTime: string;
  temp: number;
  feelsLike: string;
  icon: string;
  text: string;
  wind360: string;
  windDir: string;
  windScale: string;
  windSpeed: string;
  humidity: string;
  precip: string;
  pressure: string;
  vis: string;
  cloud: string;
  dew: string;
}


//逐天预报的数据
export class DailyForecast{
  code:number;
  updateTime:string;
  fxLink:string;
  daily:DailyData[];

  refer: {
    sources: [
        QWeather:string,
        NMC:string,
        ECMWF:string
    ],
    license: [
        commerciallicense:string
    ]
  }

}

export class DailyData{
  fxDate: string;
  sunrise: string;
  sunset: string;
  moonrise : string;
  moonset : string;
  moonPhaseIcon : string;
  tempMax : number;
  tempMin : number;
  iconDay : number;
  textDay: string;
  iconNight : number;
  textNight : string;
  wind360Day: string;
  windDirDay: string;
  windScaleDay: string;
  windSpeedDay: number;
  wind360Night: string;
  windDirNight: string;
  windScaleNight: string;
  windSpeedNight: number;
  humidity: number;
  precip: string;
  pressure: string;
  vis : number;
  cloud: number;
  dew: number;
  weeke:string;
  monthe:number;
  daye:number;
}



//逐小时预报的数据
export class HourlyForecast{
  code:number;
  updateTime:string;
  fxLink:string;

  hourly:HourlyData[];//把接口中的hourly整合成一个类，在想获取指定数据的时候，直接指向这个类去赋值、操作

  refer: {
    sources: [
        QWeather:string,
        NMC:string,
        ECMWF:string
    ],
    license: [
        commerciallicense:string
    ]
  }

}

export class HourlyData{
  fxTime: string;
    temp: number;
    icon: string;
    text: string;
    wind360: string;
    windDir: string;
    windScale: string;
    windSpeed: string;
    humidity: string;
    pop: number;
    precip: string;
    pressure: string;
    cloud: number;
    dew: number;
}


//空气质量指数
export class AirQuality{
  code:number;
  updateTime:string;
  fxLink:string;
  now:NowQuality;

  refer: {
    sources: string[],
    license:string[]
  }


}
export class NowQuality{
    pubTime: string;
    aqi: number;
    level: number;
    category: string;
    primary: string;
    pm10: number;
    pm2p5: number;
    no2: number;
    so2: number;
    co: number;
    o3: number;
}

//天气灾害预警
export class WeatherWarning{
  code:number;
  updateTime:string;
  fxLink:string;
  warning:WarningData[];

  refer: {
    sources: string[],
    license: string[]
  }
}

export class WarningData{
      id: string;
      sender: string;
      pubTime: string;
      title: string;
      startTime: string;
      endTime: string;
      status: string;
      level: string;
      severity: string;
      severityColor: string;
      typee: number;
      typeName: string;
      text: string;
      related: string;
}

//城市信息
export class CityInfo{
  code:number;
  location:LocationInfo[];

  refer: {
    sources: string[],
    license: string[]
  };



}
export class LocationInfo{
      name: string;
      id: string;
      lat: number;
      lon: number;
      adm2: string;
      adm1: string;
      country: string;
      tz: string;
      utcOffset: string;
      isDst: string;
      typee: string;
      rank: number;
      fxLink: string;
}






















