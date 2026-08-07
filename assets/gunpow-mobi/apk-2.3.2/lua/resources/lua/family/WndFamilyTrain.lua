--WndFamilyTrain.lua
--@brief	WndFamilyTrain的UI模块
--@date		2017/09/15
--@author	Tianxiang_Xu
--@note		家园饲养探险界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFamilyTrain:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFamilyTrain:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    界面加载完成回调
function WndFamilyTrain:onEnterTransitionDidFinish(element)
    -- body
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    local sSpeedPrice = CacheCenter:getGameParam()["homeSpeedUpProduceCost"]
    local tId, tValue = SplitItemString(sSpeedPrice)
    self.m_nSpeedPriceId = tonumber(tId[1]) 
    self.m_nSpeedPriceValue = tonumber(tValue[1]) 
    WZLog("WndFamilyTrain:onEnterTransitionDidFinish", self.m_nSpeedPriceId, self.m_nSpeedPriceValue)
    self.m_conReward = GetElement(self.m_root, "conReward_WndFamilyTrain", WZUIContainer)

    self.m_nOperateType = 0
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_GetBuildingInfo(self.m_tBuildingData.indexX - 1, self.m_tBuildingData.indexY - 1)
end

--@brief    触摸开始回调
function WndFamilyTrain:onTouchBegin(element)
    -- body
    
end

--@brief    点击关闭按钮回调
function WndFamilyTrain:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndFamilyOperate.m_bIsClickFunc = false
    g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击加速按钮回调
function WndFamilyTrain:onClickTrain(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nState = self:_getTrainState()
    if nState == 0 then 
        --开始饲养或探险
        local tData = self.m_tBuildingData 
        --佣人数量判断
        local nFreeButlerNum = SceneFamily:getFreeButlerNum()
        WZLog("WndFamilyTrain:onClickTrain", nFreeButlerNum)
        if nFreeButlerNum <= 0 then 
            MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT28)
            return 
        end
        --当天次数判断
        if self.m_nUsedTimes >= self.m_nTotalTimes then 
            if self.m_nTotalTimes < self.m_nMaxTotalTimes then 
                if tData.basicData.sub_type == 5 then 
                    MsgBoxManager:showTipBox(LocalStrings.FAMILY2_TEXT3)
                elseif tData.basicData.sub_type == 6 then 
                    MsgBoxManager:showTipBox(LocalStrings.FAMILY2_TEXT19)
                end
            else
                if tData.basicData.sub_type == 5 then 
                    MsgBoxManager:showTipBox(LocalStrings.FAMILY2_TEXT19)
                elseif tData.basicData.sub_type == 6 then 
                    MsgBoxManager:showTipBox(LocalStrings.FAMILY2_TEXT20)
                end
            end
            return 
        end
        if not JudgeMoneyIsEnough(tData.basicData.functions[1][2], tData.basicData.functions[1][3], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then 
            return 
        end
        self:sureToUseDiamondInstead()
    elseif nState == 4 then 
        --查看奖励
        self:_setConVisible(false, true)
        self:_showRewardList()
    elseif nState == 5 then 
        --领取奖励
        self:_createLoading()
        ProtocolProcessorFamily:send_HOME_DrawReward(self.m_tBuildingData.indexX - 1, self.m_tBuildingData.indexY - 1)
    end
end

--@brief    确认用钻石代替礼钻饲养或探险
function WndFamilyTrain:sureToUseDiamondInstead()
    -- body
    WZLog("WndFamilyTrain:sureToUseDiamondInstead")
    self.m_nOperateType = 2
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_StartProduct(self.m_tBuildingData.indexX - 1, self.m_tBuildingData.indexY - 1)
end

--@brief    点击饲养或探险按钮回调
function WndFamilyTrain:onClickSpeed(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nLeftSeconds > 0 then 
        local nSpeedPrice = self.m_nSpeedPriceValue * math.ceil(self.m_nLeftSeconds/60)
        local priceIcon = GDatatab_item["id_" .. self.m_nSpeedPriceId].icon
        local sContent = string.format(LocalStrings.FAMILY2_TEXT11, priceIcon, nSpeedPrice)
        MsgBoxManager:showConfirmBox(sContent, self, self.sureToSpeed)
    end
end

--@brief    确认加速回调
function WndFamilyTrain:sureToSpeed()
    -- body
    if self.m_nLeftSeconds > 0 then 
        local nSpeedPrice = self.m_nSpeedPriceValue * math.ceil(self.m_nLeftSeconds/60)
        if not JudgeMoneyIsEnough(self.m_nSpeedPriceId, nSpeedPrice, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondToSpeed) then 
            return 
        end
        self:sureToUseDiamondToSpeed()
    else
        local tData = self.m_tBuildingData.basicData
        if tData.sub_type == 5 then 
            MsgBoxManager:showTipBox(LocalStrings.FAMILY2_TEXT12)        
        else
            MsgBoxManager:showTipBox(LocalStrings.FAMILY2_TEXT13)        
        end
    end
end

--@brief    确认用钻石代替礼钻加速饲养或探险
function WndFamilyTrain:sureToUseDiamondToSpeed()
    -- body
    WZLog("WndFamilyTrain:sureToUseDiamondToSpeed")
    self:_createLoading()
    --发送协议进行饲养或探险
    ProtocolProcessorFamily:send_HOME_SpeedUpProduct(self.m_tBuildingData.indexX - 1, self.m_tBuildingData.indexY - 1)
end

--@brief    点击返回按钮回调
function WndFamilyTrain:onClickReturn(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self:_setConVisible(true, false)
end

--@brief    点击奖励物品回调
function WndFamilyTrain:onClickItem(luaTable, tag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, WndFamilyTrain.m_root, 1, tData, false, nil, false, nil, nil, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    界面刷新
function WndFamilyTrain:_update()
    -- body
    self:getDailyTotalTimes()

    self:_drawBuilding()
    self:_setStaticText()
    if self.m_nLeftSeconds > 0 then 
        self.m_root:enableSchedule("_caculateTime", 1)
    end
end

--@brief    设置静态文字
function WndFamilyTrain:_setStaticText()
    -- body
    local ftxtTrainState = GetElement(self.m_root, "ftxtTrainState_WndFamilyTrain", WZUIFreeTextBox)
    local ftxtTrainTimes = GetElement(self.m_root, "ftxtTrainTimes_WndFamilyTrain", WZUIFreeTextBox)
    local ftxtTrainCost = GetElement(self.m_root, "ftxtTrainCost_WndFamilyTrain", WZUIFreeTextBox)
    local txtTrainBtnText = GetElement(self.m_root, "txtTrainBtnText_WndFamilyTrain", WZUILabelTTF)
    --饲养次数
    local tData = self.m_tBuildingData 
    if ftxtTrainTimes then 
        if tData.basicData.sub_type == 5 then 
            ftxtTrainTimes:setShowText(string.format(LocalStrings.FAMILY2_TEXT8, self.m_nUsedTimes, self.m_nTotalTimes))
        elseif tData.basicData.sub_type == 6 then 
            ftxtTrainTimes:setShowText(string.format(LocalStrings.FAMILY2_TEXT18, self.m_nUsedTimes, self.m_nTotalTimes))
        end
    end
    local nState = self:_getTrainState()
    local sFormat = [[<T C="255,255,255" S="22" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
    if nState == 0 then
        local sFormatCost = [[<T C="127,70,26" S="18" P="1">%s</T><I Z="0.5" P="1">%s</I><T C="158,0,0" S="18" P="1">x%d</T>]]
        local costIcon = GDatatab_item["id_" .. tData.basicData.functions[1][2]].icon
        ftxtTrainCost:setVisible(true)
        ftxtTrainCost:setShowText(string.format(sFormatCost, LocalStrings.PETUSE, costIcon, tData.basicData.functions[1][3]))
        ftxtTrainState:setShowText(string.format(sFormat, LocalStrings.FAMILY2_TEXT2))
        if tData.basicData.sub_type == 5 then 
            txtTrainBtnText:setText(LocalStrings.FAMILY2_TEXT9)
        elseif tData.basicData.sub_type == 6 then
            txtTrainBtnText:setText(LocalStrings.FAMILY2_TEXT15)
        end
    elseif nState == 4 then 
        ftxtTrainCost:setVisible(false)
        self:_showStateTime()
        txtTrainBtnText:setText(LocalStrings.CHECK_REWARD)
    elseif nState == 5 then 
        ftxtTrainCost:setVisible(false)
        if tData.basicData.sub_type == 5 then 
            ftxtTrainState:setShowText(string.format(sFormat, LocalStrings.FAMILY2_TEXT5))
        elseif tData.basicData.sub_type == 6 then 
            ftxtTrainState:setShowText(string.format(sFormat, LocalStrings.FAMILY2_TEXT16))
        end
        txtTrainBtnText:setText(LocalStrings.GET_REWARD)
    end
end

--@brief    建筑的名字、等级、形态
function WndFamilyTrain:_drawBuilding()
    -- body
    local tData = self.m_tBuildingData 
    --标题
    self:_setConVisible(true, false)
    --描述
    local txtDesc = GetElement(self.m_root, "txtDesc_WndFamilyTrain", WZUILabelTTF)
    if txtDesc then
        txtDesc:setText(tData.basicData.desc)
    end
    --建筑图标
    local conForBuilding = GetElement(self.m_root, "conForBuilding_WndFamilyTrain", WZUIContainer)
    if conForBuilding then
        local celElement, tNewObj = CellFamilyBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(tData, 1)
            tNewObj:setBuildingBG()
            tNewObj:setBuildingTouch(false)
            if tData.basicData.type == 0 and tData.basicData.sub_type == 0 then 
                celElement:setScale(0.7)
            end
            conForBuilding:addChild(celElement)
        end
    end
end

--@brief    显示已经获得奖励列表
function WndFamilyTrain:_showRewardList()
    -- body
    local tableReward = GetElement(self.m_root, "tableReward_WndFamilyTrain", WZUITableContainer)
    tableReward:cleanTable()

    local conReward = GetElement(self.m_root, "conReward_WndFamilyTrain", WZUIContainer)

    if self.m_tRewardList == nil or #self.m_tRewardList == 0 then 
        ShowPanelNullTip( conReward, LocalStrings.FAMILY2_TEXT1)
        return 
    end
    removeShowPanelNullTip(conReward)

    for i = 1, #self.m_tRewardList do
        local element, tNewObj = CellGoodItem:createElement()
        if element and tNewObj then 
            tNewObj:setCellGoodLocalId(self.m_tRewardList[i].id, self.m_tRewardList[i].num, 4)
            element:setTag(i - 1)
            tableReward:setCellElement(element)
            tNewObj:setItemClickFun(self, self.onClickItem)
        end
    end
end

--@brief    设置显示的是奖励还是饲养界面
function WndFamilyTrain:_setConVisible(bTrainVisible, bRewardVisible)
    -- body
    GetElement(self.m_root, "conState_WndFamilyTrain", WZUIContainer):setVisible(bTrainVisible)
    local txtTitle = GetElement(self.m_root, "txtTitle_WndFamilyTrain", WZUILabelTTF)
    local tData = self.m_tBuildingData
    if bTrainVisible then 
        if txtTitle then 
            txtTitle:setText(tData.basicInfo.name .. "(" .. tData.basicData.level .. LocalStrings.LEVEL1 .. ")")
        end
    end
    self.m_conReward:setVisible(bRewardVisible)
    if bRewardVisible then 
        self:_showLeftSeconds()
        if tData.basicData.sub_type == 5 then 
            txtTitle:setText(LocalStrings.FAMILY2_TEXT6)
        elseif tData.basicData.sub_type == 6 then 
            txtTitle:setText(LocalStrings.FAMILY2_TEXT14)
        end
    end
end

--@brief    奖励界面剩余时间
function WndFamilyTrain:_showLeftSeconds()
    -- body
    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndFamilyTrain", WZUIFreeTextBox)
    if ftxtLeftTime then 
        local nHours = math.floor(self.m_nLeftSeconds / 3600)
        local nMinutes = math.floor((self.m_nLeftSeconds - nHours * 3600) / 60)
        local nSeconds = self.m_nLeftSeconds - nHours * 3600 - nMinutes * 60
        if self.m_nLeftSeconds > 0 then 
            if self.m_tBuildingData.basicData.sub_type == 5 then 
                ftxtLeftTime:setShowText(string.format(LocalStrings.FAMILY2_TEXT7, nHours, nMinutes, nSeconds))
            elseif self.m_tBuildingData.basicData.sub_type == 6 then 
                ftxtLeftTime:setShowText(string.format(LocalStrings.FAMILY2_TEXT17, nHours, nMinutes, nSeconds))
            end
            GetElement(self.m_root, "btnSpeed_WndFamilyTrain", WZUIButton):setTouchEnable(true)
        else
            ftxtLeftTime:setShowText(string.format([[<T C="255,255,255" S="22" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]], LocalStrings.FAMILY2_TEXT10))
            GetElement(self.m_root, "btnSpeed_WndFamilyTrain", WZUIButton):setTouchEnable(false)
        end
    end
end

--@brief    状态界面时间
function WndFamilyTrain:_showStateTime()
    -- body
    local ftxtTrainState = GetElement(self.m_root, "ftxtTrainState_WndFamilyTrain", WZUIFreeTextBox)
    if ftxtTrainState then 
        local nHours = math.floor(self.m_nLeftSeconds / 3600)
        local nMinutes = math.floor((self.m_nLeftSeconds - nHours * 3600) / 60)
        local nSeconds = self.m_nLeftSeconds - nHours * 3600 - nMinutes * 60
        if self.m_nLeftSeconds > 0 then 
            if self.m_tBuildingData.basicData.sub_type == 5 then 
                ftxtTrainState:setShowText(string.format(LocalStrings.FAMILY2_TEXT7, nHours, nMinutes, nSeconds))
            elseif self.m_tBuildingData.basicData.sub_type == 6 then 
                ftxtTrainState:setShowText(string.format(LocalStrings.FAMILY2_TEXT17, nHours, nMinutes, nSeconds))
            end
        end
    end
end

--@brief    剩余时间
function WndFamilyTrain:_caculateTime(element)
    -- body
    if self.m_nLeftSeconds > 0 then 
        self.m_nLeftSeconds = self.m_nLeftSeconds - 1
        if self.m_conReward:isVisible() then 
            self:_showLeftSeconds()
        end
        self:_showStateTime()
    else
        self.m_root:disableSchedule()
        if self.m_conReward:isVisible() then 
            self:_showLeftSeconds()
        end
        --研究倒计时结束，发送协议请求更新
        self:_createLoading()
        ProtocolProcessorFamily:send_HOME_GetBuildingInfo(self.m_tBuildingData.indexX - 1, self.m_tBuildingData.indexY - 1)
        --请求数据刷新
        SceneFamily:toRequestUpdate()
    end
end
-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndFamilyTrain:_adaptLanguage_vn( ... )
    local txtTrainBtnText = GetElement(self.m_root, "txtTrainBtnText_WndFamilyTrain", WZUILabelTTF)
    txtTrainBtnText:setScale(0.65)
    txtTrainBtnText:setDimensions(GlobalMethod:CCSize(160))

    GetElement(self.m_root,"ftxtTrainState_WndFamilyTrain",WZUIFreeTextBox):setScale(0.7)
end

function WndFamilyTrain:_adaptLanguage_th(  )
    local txtTrainBtnText = GetElement(self.m_root, "txtTrainBtnText_WndFamilyTrain", WZUILabelTTF)
    txtTrainBtnText:setScale(0.65)
    txtTrainBtnText:setDimensions(GlobalMethod:CCSize(160))

    GetElement(self.m_root,"ftxtTrainState_WndFamilyTrain",WZUIFreeTextBox):setScale(0.7)
end

function WndFamilyTrain:_adaptLanguage_en(  )
    local txtTrainBtnText = GetElement(self.m_root, "txtTrainBtnText_WndFamilyTrain", WZUILabelTTF)
    txtTrainBtnText:setScale(0.65)
    txtTrainBtnText:setDimensions(GlobalMethod:CCSize(160))

    local ftxtTrainState = GetElement(self.m_root,"ftxtTrainState_WndFamilyTrain",WZUIFreeTextBox)
    ftxtTrainState:setScale(0.65)
    ftxtTrainState:setMaxWidth(400)

    local ftxtTrainTimes = GetElement(self.m_root, "ftxtTrainTimes_WndFamilyTrain", WZUIFreeTextBox)
    ftxtTrainTimes:setScale(0.7)

    local txtTitle = GetElement(self.m_root, "txtTitle_WndFamilyTrain", WZUILabelTTF)
    txtTitle:setScale(0.7)

    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndFamilyTrain", WZUIFreeTextBox)
    ftxtLeftTime:setMaxWidth(430)
end

function WndFamilyTrain:_adaptLanguage_es(  )
    local txtTrainBtnText = GetElement(self.m_root, "txtTrainBtnText_WndFamilyTrain", WZUILabelTTF)
    txtTrainBtnText:setScale(0.65)
    txtTrainBtnText:setDimensions(GlobalMethod:CCSize(160))

    local ftxtTrainState = GetElement(self.m_root,"ftxtTrainState_WndFamilyTrain",WZUIFreeTextBox)
    ftxtTrainState:setScale(0.65)
    ftxtTrainState:setMaxWidth(400)

    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndFamilyTrain", WZUIFreeTextBox)
    ftxtLeftTime:setMaxWidth(430)
    
    local txtTitle = GetElement(self.m_root, "txtTitle_WndFamilyTrain", WZUILabelTTF)
    txtTitle:setScale(0.7)
end

function WndFamilyTrain:_adaptLanguage_pt(  )
    local txtTrainBtnText = GetElement(self.m_root, "txtTrainBtnText_WndFamilyTrain", WZUILabelTTF)
    txtTrainBtnText:setScale(0.65)
    txtTrainBtnText:setDimensions(GlobalMethod:CCSize(160))

    local ftxtTrainState = GetElement(self.m_root,"ftxtTrainState_WndFamilyTrain",WZUIFreeTextBox)
    ftxtTrainState:setScale(0.7)
    ftxtTrainState:setMaxWidth(340)

    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndFamilyTrain", WZUIFreeTextBox)
    ftxtLeftTime:setMaxWidth(430)

    local txtTitle = GetElement(self.m_root, "txtTitle_WndFamilyTrain", WZUILabelTTF)
    txtTitle:setScale(0.7)
end

function WndFamilyTrain:_adaptLanguage_tr(  )
    local txtTrainBtnText = GetElement(self.m_root, "txtTrainBtnText_WndFamilyTrain", WZUILabelTTF)
    txtTrainBtnText:setScale(0.65)
    txtTrainBtnText:setDimensions(GlobalMethod:CCSize(160))

    local ftxtTrainState = GetElement(self.m_root,"ftxtTrainState_WndFamilyTrain",WZUIFreeTextBox)
    ftxtTrainState:setScale(0.65)
    ftxtTrainState:setMaxWidth(400)

    local ftxtTrainTimes = GetElement(self.m_root, "ftxtTrainTimes_WndFamilyTrain", WZUIFreeTextBox)
    ftxtTrainTimes:setScale(0.7)
    
    local txtTitle = GetElement(self.m_root, "txtTitle_WndFamilyTrain", WZUILabelTTF)
    txtTitle:setScale(0.7)
end
---------------------------------------语言适配End------------------------------------------