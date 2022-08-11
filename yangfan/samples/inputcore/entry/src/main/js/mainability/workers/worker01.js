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

// worker.js
// @ts-nocheck
import worker from '@ohos.worker';
import inputDevice from '@ohos.multimodalInput.inputDevice';

const parentPort = worker.parentPort;
parentPort.onmessage = function(e){

    console.info(`work01:02800::MultimodalInputDevice_on_test enter`);
    let isPhysicalKeyboardExist = true;
    inputDevice.on("change", (data) => {
        console.info("02800::type: " + data.type + ", deviceId: " + data.deviceId);
        inputDevice.getKeyboardType(data.deviceId, (err, ret) => {
            console.info("02800::The keyboard type of the device is: " + ret);
            if (ret == inputDevice.KeyboardType.ALPHABETIC_KEYBOARD && data.type == 'add') {
                // 监听物理键盘已连接。
                isPhysicalKeyboardExist = true;
            } else if (ret == inputDevice.KeyboardType.ALPHABETIC_KEYBOARD && data.type == 'remove') {
                // 监听物理键盘已断开。
                isPhysicalKeyboardExist = false;
            }
        });
    });

    var start = (new Date()).getTime();
    while ((new Date()).getTime() - start < 2000) {
        continue;
    }

    let data = e.data + "; hello main";
    setTimeout(() => {
        parentPort.postMessage(data)
        console.info(`work01:02800::MultimodalInputDevice_on_test leave`);
    }, 2000);

}