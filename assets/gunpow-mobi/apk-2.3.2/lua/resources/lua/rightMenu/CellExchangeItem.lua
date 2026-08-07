--CellExchangeItem.lua
--@brief	CellExchangeItem的UI模块
--@date		2016/08/13
--@author	Tianxiang_Xu
--@note		物品兑换活动子列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellExchangeItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellExchangeItem:onExit(element)
	self:_unInit()
end

--@brief    加载cell信息数据
function CellExchangeItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellExchangeItem")
    self.m_root:addChild(celElement)

    AdaptLanguage(self)
    self:_update()
end

--@brief    点击Item时回调tips
function CellExchangeItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellExchangePanel.m_current.m_root,1,tData,false)
end

--@brief    点击兑换回调
function CellExchangeItem:onClickExchange(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local itemId = self.m_tRewardsData[1].id
	--是否已有无限期时装
    local bIsHaved = gCheckHaveOrNot(itemId)
	--是否已有坐骑
	local hasMount = checkOwnMount(itemId)
	--礼包内是否有时装或坐骑
	local checkGiftOwn, text = checkGiftOwn(itemId)

    local tCustomUIConfig = {strTitle = LocalStrings.MARRY_END[8]}
    if bIsHaved then
        local tBasicInfo = GDatatab_item["id_" .. itemId]
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.ACTIVITY_HAVED_ATT, tBasicInfo.name), self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, tCustomUIConfig)
	elseif hasMount then
        MsgBoxManager:showConfirmBox(LocalStrings.OWNMOUNT, self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, tCustomUIConfig)
	elseif checkGiftOwn then
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.OWN1, text), self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, tCustomUIConfig)
    else
        self:event_SureBuyAgain()
    end
end

function CellExchangeItem:event_SureBuyAgain()
    if self.m_nLeftTimes <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.ATH_CNT_NOT_ENOUGH)
        return 
    end
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_EXCHANGE or self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_EXCHANGE_ONE or self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_EXCHANGE_TWO or self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_EXCHANGE_THREE or self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_EXCHANGE_FOUR then 
        local wndChooseReward = WndChooseReward:createElement()
        WindowManager:addWindow(wndChooseReward,WndChooseReward,nil,nil,nil,true)
        local tData = {}
        tData.cost = self.m_tConsumeData
        tData.reward = self.m_tRewardsData
        tData.tCell = self
        tData.func = self.event_SureBuyAgain_Two
        tData.maxNum = self.m_nLeftTimes
        WndChooseReward:setData(tData, 1)
    else
        local sAtt = self:_checkGoodsEnough()
        if sAtt then
            MsgBoxManager:showTipBox(sAtt .. " " .. LocalStrings.NOT_ENABLE)
            return
        end
        self:event_SureBuyAgain_Two()
    end
end

function CellExchangeItem:event_SureBuyAgain_Two(num)
    if self.m_tCallBack then
        self.m_nChooseNum = num or 1
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_rewardId, num)
    end
end

--@brief    获取奖励Id
function CellExchangeItem:getRewardId()
    -- body
    return self.m_rewardId
end

--@brief    兑换成功后，更新数据
function CellExchangeItem:refreshData(bRefreshTimes)
    -- body
    if bRefreshTimes then
        --剩余次数
        if self.m_nChooseNum then 
            self.m_nLeftTimes = self.m_nLeftTimes - self.m_nChooseNum
        else
            self.m_nLeftTimes = self.m_nLeftTimes - 1
        end
        local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_CellExchangeItem", WZUIFreeTextBox)
        if txtLeftTimes then
            local sTimesFormat = [[<T C="105,65,46" S="20" P="1">%s</T><T C="255,227,116" S="20" P="1" SC="128,54,13" SS="4" SE="1">%d</T><T C="105,65,46" S="20" P="1">%s</T>]]
            txtLeftTimes:setShowText(string.format(sTimesFormat, LocalStrings.SHOP_GOODSSHEGN, self.m_nLeftTimes, LocalStrings.SHOP_CISHU))
        end
    end

    --兑换消耗的物品
    if self.m_tConsumeData then
        for i = 1, #self.m_tConsumeData do
            --数量
            local txtNumber = GetElement(self.m_root, string.format("txtNumber%d_CellExchangeItem", i), WZUILabelTTF)
            if txtNumber then
                --数量
                local nTempNum = self.m_tConsumeData[i].num 
                if nTempNum == -1 then
                    nTempNum = 1 
                end

                local nLastNum = CacheCenter:getPlayerItemCountById(self.m_tConsumeData[i].id)
                local itemInfo = GDatatab_item["id_"..self.m_tConsumeData[i].id]
                if itemInfo.main_type == 10 then
                    nLastNum = CacheCenter:getPetCountByItemId(self.m_tConsumeData[i].id)
                elseif itemInfo.main_type == 37 then
                    nLastNum = 0
                    local tSkinEquipmentData = CellExchangePanel.m_current.m_tSkinEquipmentData
                    for j=1,#tSkinEquipmentData do
                        if tSkinEquipmentData[j].id == self.m_tConsumeData[i].id then
                            nLastNum = nLastNum + 1
                        end
                    end
                end

                if nLastNum == -1 then
                    nLastNum = 1
                else
                    local key = "id_" .. self.m_tConsumeData[i].id
                    if GDatatab_item[key].main_type == 5 then
                        if nLastNum > 0 then
                            nLastNum = 0 
                        end
                    end
                end
                txtNumber:setText(nLastNum .. "/" .. nTempNum)
            else
                break 
            end
        end
    end
end

--@brief    更新消耗
function CellExchangeItem:updateConsume()
    if self.m_tConsumeData then
        for i = 1, #self.m_tConsumeData do
            local txtNumber = GetElement(self.m_root, string.format("txtNumber%d_CellExchangeItem", i), WZUILabelTTF)
            local nLastNum = CacheCenter:getPlayerItemCountById(self.m_tConsumeData[i].id)
            local itemInfo = GDatatab_item["id_"..self.m_tConsumeData[i].id]
            if itemInfo.main_type == 10 then
                nLastNum = CacheCenter:getPetCountByItemId(self.m_tConsumeData[i].id)
            elseif itemInfo.main_type == 37 then
                nLastNum = 0
                local tSkinEquipmentData = CellExchangePanel.m_current.m_tSkinEquipmentData
                for j=1,#tSkinEquipmentData do
                    if tSkinEquipmentData[j].id == self.m_tConsumeData[i].id then
                        nLastNum = nLastNum + 1
                    end
                end
            end
            if nLastNum == -1 then
                nLastNum = 1
            else
                local key = "id_" .. self.m_tConsumeData[i].id
                if GDatatab_item[key].main_type == 5 then
                    if nLastNum > 0 then
                        nLastNum = 0 
                    end
                end
            end
            local nTempNum = self.m_tConsumeData[i].num 
            if nTempNum == -1 then
                nTempNum = 1 
            end
            if txtNumber then
                txtNumber:setText(nLastNum .. "/" .. nTempNum)
            end
        end
    end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    显示cell信息
function CellExchangeItem:_update()
    -- body
    WZLog("CellExchangeItem:_update")
    --剩余次数
    local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_CellExchangeItem", WZUIFreeTextBox)
    if txtLeftTimes then
        local sTimesFormat = [[<T C="105,65,46" S="20" P="1">%s</T><T C="255,227,116" S="20" P="1" SC="128,54,13" SS="4" SE="1">%d</T><T C="105,65,46" S="20" P="1">%s</T>]]
        txtLeftTimes:setShowText(string.format(sTimesFormat, LocalStrings.SHOP_GOODSSHEGN, self.m_nLeftTimes, LocalStrings.SHOP_CISHU))
    end
    --兑换得到的物品
    local conItem = GetElement(self.m_root, "ConItem", WZUIContainer)
    if conItem then
        local element, tNewObj = CellGoodItem:createElement()
        local key = "id_" .. self.m_tRewardsData[1].id
        if element and tNewObj then
            local itemInfo = {id = self.m_tRewardsData[1].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tRewardsData[1].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tNewObj:setCellGoodItem(itemInfo,17)
 
            tNewObj:setItemClickFun(self,self.onOthersClick)
            conItem:addChild(element)
        end
    end
    --兑换消耗的物品
    if self.m_tConsumeData then
        for i = 1, #self.m_tConsumeData do
            local itemCon = GetElement(self.m_root, string.format("ConItem%d", i), WZUIContainer)
            if itemCon then 
                local element, tNewObj = CellGoodItem:createElement()
                local key = "id_" .. self.m_tConsumeData[i].id
                if element and tNewObj then
                    local itemInfo = {id = self.m_tConsumeData[i].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tConsumeData[i].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                    if GDatatab_item[key].main_type == 5 then
                        tNewObj:setCellGoodItem(itemInfo,17)
                    else
                        tNewObj:setCellGoodItem(itemInfo,17)
                        tNewObj:_setItemVisible(false)
                    end
                    
                    tNewObj:setItemClickFun(self,self.onOthersClick)
                    element:setScale(0.6)
                    itemCon:addChild(element)
                end
                --数量
                local nTempNum = self.m_tConsumeData[i].num 
                if nTempNum == -1 then
                    nTempNum = 1 
                end
                
                local txtNumber = GetElement(self.m_root, string.format("txtNumber%d_CellExchangeItem", i), WZUILabelTTF)
                local nLastNum = CacheCenter:getPlayerItemCountById(self.m_tConsumeData[i].id)
                local itemInfo = GDatatab_item["id_"..self.m_tConsumeData[i].id]
                if itemInfo.main_type == 10 then
                    nLastNum = CacheCenter:getPetCountByItemId(self.m_tConsumeData[i].id)
                elseif itemInfo.main_type == 37 then
                    nLastNum = 0
                    local tSkinEquipmentData = CellExchangePanel.m_current.m_tSkinEquipmentData
                    for j=1,#tSkinEquipmentData do
                        if tSkinEquipmentData[j].id == self.m_tConsumeData[i].id then
                            nLastNum = nLastNum + 1
                        end
                    end
                end
                if nLastNum == -1 then
                    nLastNum = 1
                else
                    if GDatatab_item[key].main_type == 5 then
                        if nLastNum > 0 then
                            nLastNum = 0 
                        end
                    end
                end
                txtNumber:setText(nLastNum .. "/" .. nTempNum)
            end
        end
    end

end

--@brief    检测消耗道具是否不足
function CellExchangeItem:_checkGoodsEnough()
    -- body
    local sAtt = nil 
    if self.m_tConsumeData then
        for i = 1, #self.m_tConsumeData do
            local nLastNum = CacheCenter:getPlayerItemCountById(self.m_tConsumeData[i].id)
            local itemInfo = GDatatab_item["id_"..self.m_tConsumeData[i].id]
            if itemInfo.main_type == 10 then
                nLastNum = CacheCenter:getPetCountByItemId(self.m_tConsumeData[i].id)
            elseif itemInfo.main_type == 37 then
                nLastNum = 0
                local tSkinEquipmentData = CellExchangePanel.m_current.m_tSkinEquipmentData
                for j=1,#tSkinEquipmentData do
                    if tSkinEquipmentData[j].id == self.m_tConsumeData[i].id then
                        nLastNum = nLastNum + 1
                    end
                end
            end
            local key = "id_" .. self.m_tConsumeData[i].id
            if GDatatab_item[key].main_type == 5 then 
                if nLastNum ~= self.m_tConsumeData[i].num then
                    sAtt = GDatatab_item[key].name
                    break 
                end
            else
                if nLastNum < self.m_tConsumeData[i].num then
                    sAtt = GDatatab_item[key].name
                    break 
                end
            end
        end
    end

    return sAtt
end


-------------------------------------私有方法模块End----------------------------------------
-------------------------------------多语言适配模块 Start----------------------------------------
--@brief    英语
function CellExchangeItem:_adaptLanguage_en()
    -- body
    local txtExchangeArrow = GetElement(self.m_root, "txtExchangeArrow_CellExchangeItem", WZUILabelTTF)
    if txtExchangeArrow then
        txtExchangeArrow:setScale(0.65)
    end
    -- body
    local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_CellExchangeItem", WZUIFreeTextBox)
    txtLeftTimes:setScale(0.7)
    txtLeftTimes:setRelativePosition(GlobalMethod:ccp(0.5,1.32143))
end

function CellExchangeItem:_adaptLanguage_pt()
    -- body
    local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_CellExchangeItem", WZUIFreeTextBox)
    txtLeftTimes:setScale(0.7)
    txtLeftTimes:setRelativePosition(GlobalMethod:ccp(0.5,1.32143))
end

function CellExchangeItem:_adaptLanguage_es()
    -- body
    local txtExchangeArrow = GetElement(self.m_root, "txtExchangeArrow_CellExchangeItem", WZUILabelTTF)
    txtExchangeArrow:setFontSize(10)
    GetElement(self.m_root, "txt_buttonName", WZUILabelTTF):setFontSize(18)
end

function CellExchangeItem:_adaptLanguage_pt()
    local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_CellExchangeItem", WZUIFreeTextBox)
    txtLeftTimes:setMaxWidth(200)
    txtLeftTimes:setScale(0.8)
    txtLeftTimes:setRelativePosition(GlobalMethod:ccp(0.475,1.25))
end


-------------------------------------多语言适配模块 END----------------------------------------
