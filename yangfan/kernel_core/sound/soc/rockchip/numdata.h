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

#ifndef _NUMDATA_H
#define _NUMDATA_H
/*
 * ACDC_CLK  D2A_CLK   D2A_SYNC Sample rates supported
 * 49.152MHz 49.152MHz 6.144MHz 12/24/48/96/192kHz
 * 45.154MHz 45.154MHz 5.644MHz 11.025/22.05/44.1/88.2/176.4kHz
 * 32.768MHz 32.768MHz 4.096MHz 8/16/32/64/128kHz
 *
 */
enum Audio_Sample_Rate {          //音频采样率
    ASR_HIGH_1 = 0x2ee0,
    ASR_HIGH_2 = 0x5dc0,
    ASR_HIGH_3 = 0xbb80,
    ASR_HIGH_4 = 0x17700,
    ASR_HIGH_5 = 0x2ee00,

    ASR_MIDDLE_1 = 0x2b11,
    ASR_MIDDLE_2 = 0x5622,
    ASR_MIDDLE_3 = 0xac44,
    ASR_MIDDLE_4 = 0x15888,
    ASR_MIDDLE_5 = 0x2b110,

    ASR_LOW_1 = 0x1f40,
    ASR_LOW_2 = 0x3e80,
    ASR_LOW_3 = 0x7d00,
    ASR_LOW_4 = 0xfa00,
    ASR_LOW_5 = 0x1f400,
};

enum Audio_Sampling_Clock {      //音频采样时钟
    AMC_HIGH = 0x2ee0000,
    ASC_HIGH = 0x5dc000,

    AMC_MIDDLE = 0x2b11000,
    ASC_MIDDLE = 0x562200,

    AMC_LOW = 0x1f40000,
    ASC_LOW = 0x3e8000,
};
#define OFFSET 16

#endif
