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

import Storage from '@ohos.data.storage'
import ability_featureAbility from '@ohos.ability.featureAbility'

class StorageUtil {
    private storage: Storage.Storage

    async initStorage() {
        if (!this.storage) {
			let fileDir = await ability_featureAbility.getContext().getFilesDir()
            this.storage = await Storage.getStorage(fileDir + '/mystore')
        }
    }

    async getValue(key, defValue): Promise<any> {
        await this.initStorage()
        return await this.storage.get(key, defValue)
    }

    async getValueSync(key, defValue, callback) {
        await this.initStorage()
        this.storage.get(key, defValue, callback)
    }

    async setValue(key, value) {
        await this.initStorage()
        await this.storage.put(key, value)
        await this.storage.flush()
    }

    async hasKey(key): Promise<boolean> {
        await this.initStorage()
        return await this.storage.has(key)
    }

    async delKey(key) {
        await this.initStorage()
        this.storage.delete(key)
        this.storage.flush()
    }
}

export default new StorageUtil()