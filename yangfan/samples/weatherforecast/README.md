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

天气预报样例是基于Open Harmony 3.1Release进行开发，在rk3399E开发板上运行，界面如下：

![](screenshots/switchCity.jpg)
![](screenshots/weatherForecast1.jpg)
![](screenshots/weatherForecast2.jpg)

天气预报所包含的数据：

实时数据：包括当前温度，当前天气状况等；

天气预警：实时的天气预警信息；

逐小时天气预报：24小时内的整点天气预报，包括整点的天气状况以及温度，可通过滚动的方式查看全部数据；

逐天天气预报：7天内的天气预报，包括每日的天气状况以及最高、最低温度；

空气质量：实时的空气评估指数，并通过图像的方式直观的展示了当前的空气污染情况。

功能：查看城市温度、天气状况、空气质量以及切换到其他城市进行查看。



 **涉及OpenHarmony技术特性** 

·ArkUI框架     ·数据请求