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

import device from '@system.device';

export default {
    data: {
        gameState: "start",
        currentPlayer: '1',
        chessPositionArr: [],
        checkerBoardArr: [],
        judgeWinArr: [],
        tipsInfo: null,
        startColumnArr: [],
        endColumnArr: [],
        screenWidth: undefined,
        screenHeight: undefined,
        screenDensity: undefined,
        allChessIndexArry: []
    },
    onclickChooseBai() {
        this.currentPlayer = '0';
        this.gameState = "running";
    },
    onclickChooseHei() {
        this.currentPlayer = '1';
        this.gameState = "running";
    },
    getInfo(callbak) {
        device.getInfo({
            success: function (data) {
                callbak(data);
            },
            fail: function (data, code) {
                console.log('Failed to obtain device information. Error code:' + code + '; Error information: ' +
                JSON.stringify(data));
            },
        });
    },
    onInit() {
        this.getInfo(basedate => {
            this.screenWidth = basedate.windowWidth;
            this.screenHeight = basedate.windowHeight;
            this.screenDensity = basedate.screenDensity;
        });
        this.chessPositionArr = new Array(225).fill('');
        this.checkerboardArr = new Array(196).fill('');
        for (let i = 1; i < 15; i++) {
            this.startColumnArr.push(15 * i)
        }
        for (let j = 0; j < 15; j++) {
            this.endColumnArr.push(14 + (15 * j))
        }
    },
    repentanceChess() { //悔棋
        if (this.allChessIndexArry.length===0){
            this.tipsInfo='$r(app.string.tip)';
            this.gameState="gameOver";
            return;
        };
        let index = this.allChessIndexArry.shift();
        this.chessPositionArr.splice(index, 1, '');
        this.currentPlayer = this.currentPlayer == '1' ? '0' : '1';
    },
    restartGame() {
        this.chessPositionArr = new Array(225).fill('');
        this.gameState = "start";
        this.currentPlayer = '1';
        this.judgeWinArr = [];
    },
    playGame(e) {
        if (this.gameState === "start") {
            this.gameState = "running"
        }
        if (this.gameState === "gameOver") {
            return;
        }
        if (this.chessPositionArr[e] == '1' || this.chessPositionArr[e] == '0') {
            return;
        }
        this.chessPositionArr.splice(e, 1, this.currentPlayer);
        this.allChessIndexArry.unshift(e);

        this.calChess(e, 1, this.judgeWinArr);
        this.calChess(e, -1, this.judgeWinArr);
        this.judgeIsWin(this.judgeWinArr);

        this.calChess(e, 15, this.judgeWinArr);
        this.calChess(e, -15, this.judgeWinArr);
        this.judgeIsWin(this.judgeWinArr);

        this.calChess(e, 14, this.judgeWinArr);
        this.calChess(e, -14, this.judgeWinArr);
        this.judgeIsWin(this.judgeWinArr);

        this.calChess(e, 16, this.judgeWinArr);
        this.calChess(e, -16, this.judgeWinArr);
        this.judgeIsWin(this.judgeWinArr);

        this.currentPlayer = this.currentPlayer == '1' ? '0' : '1';
    },

    calChess(id, d, chessPositionArr) {
        id = parseInt(id);
        if (this.chessPositionArr[id + d] && this.chessPositionArr[id + d] == this.currentPlayer && this.findChess(id + d, d)) {
            chessPositionArr.push(id);
            this.calChess(id + d, d, chessPositionArr);
        } else {
            chessPositionArr.push(id);
        }
    },
    findChess(id, d) {
        if ((d == 1 && this.startColumnArr.indexOf(id) > -1)
        || (d == -1 && this.endColumnArr.indexOf(id) > -1)
        || (d == 14 && this.endColumnArr.indexOf(id) > -1)
        || (d == -14 && this.startColumnArr.indexOf(id) > -1)
        || (d == 16 && this.startColumnArr.indexOf(id) > -1)
        || (d == -16 && this.endColumnArr.indexOf(id) > -1)) {
            return false;
        }
        return true;
    },
    judgeIsWin(chessPositionArr) {
        if (chessPositionArr.length > 5) {
            this.tipsInfo = this.gameOver(this.currentPlayer) + '胜';
            chessPositionArr.length = 0;
        } else {
            chessPositionArr.length = 0;
        }
    },
    gameOver(currentPlayer) {
        this.gameState = "gameOver";
        if (currentPlayer == '1') {
            return '$r(app.string.chess_black)'
        } else {
            return '$r(app.string.chess_white)'
        }
        console.log("$string:gameOver")
    },
}
