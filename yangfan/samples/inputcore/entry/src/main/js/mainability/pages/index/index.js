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

// @ts-nocheck
import brightness from '@system.brightness';
import app from '@system.app';
import inputDevice from '@ohos.multimodalInput.inputDevice';
import inputConsumer from "@ohos.multimodalInput.inputConsumer";
import inputMonitor from "@ohos.multimodalInput.inputMonitor";
import inputEventClient from '@ohos.multimodalInput.inputEventClient';
import pointer from '@ohos.multimodalInput.pointer';
import process from '@ohos.process';
import hiLog from '@ohos.hilog'
import worker from '@ohos.worker';

export default {
    data: {
        domainId: 0xD002800,
        label: 'MultimodalinputJs',
        infoList: [],
        keyCode: 2018,
        inputData: " ",
    },

    log() {
        let info = '';
        for (let i = 0; i < arguments.length ; i ++) {
            if (i > 0) {
                info += ':';
            }
            info += arguments[i];
        }
        if (!info.includes(' enter') && !info.includes(' leave')) {
            this.infoList.push(info);
        }
        // hiLog.info(this.domainId, this.label, "%{public}s", info)
        hiLog.error(this.domainId, this.label, "%{public}s", info);
    },

    onShow() {
        brightness.setKeepScreenOn({
            keepScreenOn: true,
        })
    },

    touchMove(e) {
        if (e.direction == "right") {
            app.terminate();
        }
    },

    OnChangeInput(e) {
        this.inputData = e.value;
        this.log('OnChangeInput', this.inputData);
    },

    ShowPointer() {
        this.log('ShowPointer enter');
        pointer.setPointerVisible(true, (err, data) => {
            if (err) {
                this.log(`callbackPointer failed. err=${JSON.stringify(err)}`);
                return;
            }
            this.log(`callbackPointer success. `);
        });
        this.log('ShowPointer leave');
    },

    HidePointer() {
        this.log('HidePointer enter');
        pointer.setPointerVisible(false).then( data => {
             this.log(`HidePointer success`);
        }, data => {
             this.log(`HidePointer failed err=${JSON.stringify(data)}`);
        });
        this.log('HidePointer leave');
    },

    isCallbackPointer(err, data) {
        if (err) {
            this.log(`isCallbackPointer failed. err=${JSON.stringify(err)}`);
            return;
        }
        this.log(`isCallbackPointer success. data=${JSON.stringify(data)}`);
    },

    //    function isPointerVisible(callback: AsyncCallback<boolean>): void;
    isPointerCallback() {
        this.log('isPointerCallback enter');
        pointer.isPointerVisible(this.isCallbackPointer);
        this.log('isPointerCallback leave');
    },

    isPointerThen() {
        this.log('isPointerThen enter');
        pointer.isPointerVisible().then( data => {
             this.log(`isPointerThen success data=${JSON.stringify(data)}`);
        }, data => {
             this.log(`isPointerThen failed err=${JSON.stringify(data)}`);
        });
        this.log('isPointerThen leave');
    },

    onRunCmd() {
        this.log('runCmd enter');
        var child = process.runCmd("/data/MoveMouseToolAuto");
        var stdoutRes = child.getOutput();
        var stderrRes = child.getErrorOutput();
        var status = child.wait();

        stdoutRes.then(val=>{
            this.log("stdout = " + val);
        });

        stderrRes.then(val=> {
            this.log("stderr = " + val);
        });

        status.then(val=>{
            this.log("status = " + val);
        });
    },

    // --------------------------------------------------------------------------
    callbackKey(data) {
        this.log(`callbackKey enter`);
        if (!data) {
            this.log(`callbackKey error. err=${JSON.stringify(err)}`);
            return;
        }
        this.log(`callbackKey success. data=${JSON.stringify(data)}`);
    },

    onClickConsumerOn() {
        this.log(`onClickConsumerOn enter`)
        let params = {
            preKeys: [],
            finalKey: this.keyCode,
            isFinalKeyDown: false,
            finalKeyDownDuration: 0,
        };
        inputConsumer.on("key", params, this.callbackKey);
        this.log(`onClickConsumerOn success`)
    },

    onClickInjectKey() {
        this.infoList=[];
        this.log(`onClickInjectKey enter`)
        let keyUp = {
            isPressed: false,
            keyCode: this.keyCode,
            keyDownDuration: 10,
            isIntercepted: false,
        }
        this.onInjeckKeyEvent(keyUp);
        this.log(`onClickInjectKey leave`)
    },

    onClickConsumerOff() {
        this.log(`onClickConsumerOff enter`)
        let params = {
            preKeys: [],
            finalKey: this.keyCode,
            isFinalKeyDown: false,
            finalKeyDownDuration: 0,
        };

        inputConsumer.off("key", params, this.callbackKey);
        this.log(`onClickConsumerOff success`);
    },

    callbackMonitor(data) {
        this.infoList=[];
        this.log(`callbackMonitorTouch enter`);
        if (!data) {
            this.log(`callbackMonitorTouch error. err=${JSON.stringify(err)}`);
            return;
        }
        this.log(`callbackMonitorTouch success. data=${JSON.stringify(data)}`);
    },

    touchMonitorOn() {
        this.log(`touchMonitorOn enter`);
        inputMonitor.on("touch",this.callbackMonitor)
        this.log(`touchMonitorOn success`);
    },

    touchMonitorOff() {
        this.log(`touchMonitorOff enter`);
        inputMonitor.off("touch")
        this.log(`touchMonitorOff success`);
    },

    mouseMonitorOn() {
        this.log(`touchMonitorOn enter`);
        inputMonitor.on("mouse",this.callbackMonitor)
        this.log(`touchMonitorOn success`);
    },

    mouseMonitorOff() {
        this.log(`touchMonitorOff enter`);
        inputMonitor.off("mouse")
        this.log(`touchMonitorOff success`);
    },

    onClickDeviceIds() {
        this.log(`onClickDeviceIds enter`);
        inputDevice.getDeviceIds((data, err) => {
            if (data) {
                this.log(`onClickDeviceIds success:${JSON.stringify(data)}`);
            } else {
                this.log(`onClickDeviceIds error:${JSON.stringify(err)}`);
            }
        })
        this.log(`onClickDeviceIds leave`);
    },

    onClickGetDevice() {
        this.log(`onClickGetDevice enter`);
        inputDevice.getDevice(1, (data, err) => {
            if (data) {
                this.log(`onClickGetDevice success :${JSON.stringify(data)}`);
            } else {
                this.log(`onClickGetDevice error:${JSON.stringify(err)}`);
            }
        })
        this.log(`onClickGetDevice leave`);
    },

    onSupportKeys() {
        this.log(`onSupportKeys enter`);
        inputDevice.supportKeys(1, [17, 22, 2055], (data, err) => {
            if (data) {
                this.log(`onSupportKeys success :${JSON.stringify(data)}`);
            } else {
                this.log(`onSupportKeys error:${JSON.stringify(err)}`);
            }
        })
        this.log(`onSupportKeys leave`);
    },

    onGetKeyboardType() {
        this.log(`onGetKeyboardType enter`);
        inputDevice.getKeyboardType(1, (data, err) => {
            if (data) {
                this.log(`onGetKeyboardType success :${JSON.stringify(data)}`);
            } else {
                this.log(`onGetKeyboardType error:${JSON.stringify(err)}`);
            }
        })
        this.log(`onGetKeyboardType leave`);
    },

    onClickTest() {
        this.log(`onClickTest enter`);
        var child = process.runCmd('sh /mnt/keyA.sh');
        child.wait();
        this.log(`onClickTest leave`);
    },

   onInputDeviceOn() {
       this.log(`onInputDeviceOn enter`);
       let isPhysicalKeyboardExist = true;
       inputDevice.on("change", (data) => {
           this.log("type:deviceId: ");
           inputDevice.getKeyboardType(data.deviceId, (err, ret) => {
               this.log(`The keyboard type of the device is: ${JSON.stringify(ret)}`);
               if (ret == inputDevice.KeyboardType.ALPHABETIC_KEYBOARD && data.type == 'add') {
                   // �����������������ӡ�
                   isPhysicalKeyboardExist = true;
               } else if (ret == inputDevice.KeyboardType.ALPHABETIC_KEYBOARD && data.type == 'remove') {
                   // �������������ѶϿ���
                   isPhysicalKeyboardExist = false;
               }
           });
       });
       this.log(`onInputDeviceOn success`);
       this.log(`onInputDeviceOn leave`);
   },

    onInputDeviceOff() {
        this.log(`onInputDeviceOff enter`);
        function listener(data) {
            this.log("type: deviceId: " );
            expect(data.type== 'add' || data.type== 'remove').assertTrue();
            expect(data).assertInstanceOf('DeviceListener');
        }
        // ����ȡ��listener�ļ�����
        inputDevice.off("change", listener);
        this.log(`onInputDeviceOff success`);
        this.log(`onInputDeviceOff leave`);
    },

    onInputDeviceOnMultithread() {
        this.log(`onInputDeviceOnMultithread-main enter`);
        let isPhysicalKeyboardExist = true;
        inputDevice.on("change", (data) => {
            this.log("type:deviceId: ");
            inputDevice.getKeyboardType(data.deviceId, (err, ret) => {
                this.log(`The keyboard type of the device is: ${JSON.stringify(ret)}`);
                if (ret == inputDevice.KeyboardType.ALPHABETIC_KEYBOARD && data.type == 'add') {
                    // �����������������ӡ�
                    isPhysicalKeyboardExist = true;
                } else if (ret == inputDevice.KeyboardType.ALPHABETIC_KEYBOARD && data.type == 'remove') {
                    // �������������ѶϿ���
                    isPhysicalKeyboardExist = false;
                }
            });
        });
        inputDevice.off("change");
        this.log(`onInputDeviceOnMultithread-main success`);
        const nw = new worker.Worker("workers/worker.js");
        nw.onmessage = function(e) {
            let ret = e.data;
            console.log(`receive from worker thread:  ${JSON.stringify(ret)}`)
        }
        nw.postMessage("hello worker");

        setTimeout(() => {
            this.log(`onInputDeviceOnMultithread-worker success`);
            nw.terminate();
        }, 1000);

        this.log(`onInputDeviceOnMultithread-main leave`);
    },

    // --------------------------------------------------------
    onClickBack() {
        this.log(`onClickBack enter`);
        let keyEvent = {
            isPressed: true,
            keyCode: 2,
            keyDownDuration: 10,
            isIntercepted: false,
        }
        this.onInjeckKeyEvent(keyEvent);
        this.log(`onClickBack leave`);
    },

    onInjeckKeyEvent(keyEvent) {
        this.log(`onInjeckKeyEvent enter`);
        inputEventClient.injectEvent({KeyEvent: keyEvent});
        this.log(`onInjeckKeyEvent success`);
    },

    tabChange() {
        this.log(`tabChange enter`);
    },

    onClickClear() {
        this.infoList=[];
    },
}