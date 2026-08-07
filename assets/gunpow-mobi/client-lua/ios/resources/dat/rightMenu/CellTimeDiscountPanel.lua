--CellTimeDiscountPanel.lua
--@brief	CellTimeDiscountPanel的UI模块
--@date		2016/08/11
--@author	Tianxiang_Xu
--@note		限时折扣活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTimeDiscountPanel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTimeDiscountPanel:onExit(element)
	self:_unInit()
end

--@brief    显示
function CellTimeDiscountPanel:showWindow( ... )
    -- body
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then 
        GetElement(self.m_root, "imgBK_CellTimeDiscountPanel", WZUIImage):setFile("ui/gameActivity/activity_pic_cdzksp.png")
    end
    self:_showTime()
    self:_showGoods()
    self:_showLeftSeconds()
    AdaptLanguage(self)
end

--@brief    点击购买回调
function CellTimeDiscountPanel:clickBuy(tData)
    -- body
    self.m_tClickData = tData
    MsgBoxManager:showConfirmBoxWithBg(LocalStrings.ACTIVITY_BUY_SECOND, self, self.toContinue, nil, nil, "CellTimeDiscountPanel" .. self.m_nActivityType)
end

--@brief    继续
function CellTimeDiscountPanel:toContinue()
    -- body
    local tData = self.m_tClickData 
    --数量不足
    if tData.times <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.LIMITE_BUY_SOLDOUT)
        return
    end
    WZLog("CellTimeDiscountPanel:clickBuy", tData.needVip, CacheCenter:getPlayerInfo().vipLevel)
    if tData.needVip > CacheCenter:getPlayerInfo().vipLevel then
        MsgBoxManager:showConfirmBox(LocalStrings.NEWACTIVITY_TEXT9, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_NORMAL, nil)
        return 
    end

    CellTimeDiscountPanel.m_currentClick = self
    --钻石不足
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT_TICKET then
        if not JudgeMoneyIsEnough(70, tData.curPrice, nil, nil, Chat_Channel_GameActivity, nil, nil, nil, nil, CellTimeDiscountPanel.m_currentClick, CellTimeDiscountPanel.m_currentClick.sureUseDiamondInstead) then 
            return 
        end
    elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then
        if not JudgeMoneyIsEnough(tData.priceId, tData.curPrice, nil, nil, Chat_Channel_GameActivity, nil, nil, nil, nil, CellTimeDiscountPanel.m_currentClick, CellTimeDiscountPanel.m_currentClick.sureUseDiamondInstead) then 
            return 
        end
    else
        if not JudgeMoneyIsEnough(1, tData.curPrice, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, Chat_Channel_GameActivity) then 
            return 
        end
    end

    CellTimeDiscountPanel.m_currentClick:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券购买物品
function CellTimeDiscountPanel:sureUseDiamondInstead()
    -- body
    local tData = CellTimeDiscountPanel.m_currentClick.m_tClickData
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    self.m_nClickRwardId = tData.rewardId
	--是否已有无限期时装
    local bIsHaved = gCheckHaveOrNot(tData.id)
    --是否已有坐骑
    local hasMount = checkOwnMount(tData.id)
    --礼包内是否有时装或坐骑
    local checkGiftOwn, text = checkGiftOwn(tData.id)

    CellTimeDiscountPanel.m_currentClick.m_nClickRewardId = tData.rewardId
    if bIsHaved then
        local tBasicInfo = GDatatab_item["id_" .. tData.id]

        MsgBoxManager:showConfirmBox(string.format(LocalStrings.ACTIVITY_HAVED_ATT, tBasicInfo.name), CellTimeDiscountPanel.m_currentClick, CellTimeDiscountPanel.m_currentClick.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    elseif hasMount then
        MsgBoxManager:showConfirmBox(LocalStrings.OWNMOUNT, CellTimeDiscountPanel.m_currentClick, CellTimeDiscountPanel.m_currentClick.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    elseif checkGiftOwn then
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.OWN1, text), CellTimeDiscountPanel.m_currentClick, CellTimeDiscountPanel.m_currentClick.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    else
        CellTimeDiscountPanel.m_currentClick:event_SureBuyAgain()
    end
end

function CellTimeDiscountPanel:event_SureBuyAgain()

    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_activityId, self.m_nClickRewardId)
end

--@brief    提示充值框的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function CellTimeDiscountPanel:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置活动时间
function CellTimeDiscountPanel:_showTime()
    -- body
    --字“活动时间”
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellTimeDiscountPanel", WZUILabelTTF)
    if txtTimeWord then
        txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    --活动具体日期
    local txtTime = GetElement(self.m_root, "txtTime_CellTimeDiscountPanel", WZUILabelTTF)
    if txtTime then
        local startDate = os.date("*t", self.m_nStartTime)
        local endDate = os.date("*t", self.m_nEndTime)
        local sTimeContent = string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min)
        txtTime:setText(sTimeContent)
    end
end

--@brief    显示出售的物品
function CellTimeDiscountPanel:_showGoods()
    -- body
    local flconList = GetElement(self.m_root, "flconList_CellTimeDiscountPanel", WZUIFreeListContainer)
    flconList:removeAll()
    self.m_tCellList = {}

    if self.m_rewardItems == nil or #self.m_rewardItems == 0 then return end
    local nCount = #self.m_rewardItems

    local tNewServerData = {}
    for i = 1, nCount do
        if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then --开服活动-限时折扣
            --物品id和数量
            local tData = {}

            local strTemp = string.sub(self.m_rewardItems[i],2,-2) 
            local id = SplitStringWithSeparator(strTemp,",")[1]
            local num = SplitStringWithSeparator(strTemp,",")[2]
            tData.id = tonumber(id)
            tData.num = tonumber(num)
            --原价
            strTemp = string.sub(self.m_target[i],2,-2) 
            id = SplitStringWithSeparator(strTemp,",")[1]
            num = SplitStringWithSeparator(strTemp,",")[2]
            tData.priceId = tonumber(id)
            tData.originPrice = tonumber(num)
            --现价
            strTemp = string.sub(self.m_tCurPrice[i],2,-2) 
            id = SplitStringWithSeparator(strTemp,",")[1]
            num = SplitStringWithSeparator(strTemp,",")[2]
            tData.curPrice = tonumber(num)
            tData.rewardId = self.m_rewardId[i]
            tData.times = self.m_rewardCounts[i] - self.m_rewardItemsParamCount[i]
            tData.needVip = self.m_tNeedVip[i]

            table.insert(tNewServerData, tData)
        end
    end 

    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then
        table.sort(tNewServerData, function (a,b)
            -- body
            if a.needVip ~= b.needVip then
                return a.needVip < b.needVip 
            else
                return a.rewardId < b.rewardId 
            end
        end)
    end

    for i = 1, nCount do
        local tData = {}

        if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then --开服活动-限时折扣
            tData = tNewServerData[i]
        else
            tData.id = self.m_rewardItems[i]
            tData.num = self.m_rewardItemsParamCount[i]
            tData.originPrice = self.m_target[2 * nCount + i] 
            tData.curPrice = self.m_target[nCount + i]
            tData.rewardId = self.m_rewardId[i]
            tData.times = self.m_rewardCounts[i]
            tData.needVip = 0 
        end

        local element, tNewObj = CellTimeDiscountItem:createElement()
        if element and tNewObj then
            self.m_tCellList[i] = tNewObj
            tNewObj:setData(tData, self.m_nActivityType)
            tNewObj:setCallBackFunc(self, self.clickBuy)
            element:setTag(i - 1)
            element = WZUIContainer:luaTo(element)
            element:setRelativeSize(GlobalMethod:CCSize(160/500,1))
            element:setAbsContentSize(GlobalMethod:CCSize(160,288))
            flconList:pushBack(element)
        end
    end
    flconList:getMoveElement():setPositionX(flconList:getMaxPosition().x)
end

--@brief    显示倒计时
function CellTimeDiscountPanel:_showLeftSeconds()
    -- body
    local conForLeftTime = GetElement(self.m_root, "conForLeftTime_CellTimeDiscountPanel", WZUIContainer)
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then
        conForLeftTime:setVisible(true)
        self:displayLeftSecond()
        conForLeftTime:enableSchedule("_caculateTime", 1)
    else
        conForLeftTime:setVisible(false)
    end
end

--@brief    
function CellTimeDiscountPanel:displayLeftSecond()
    -- body
    local ftxtLeftSeconds = GetElement(self.m_root, "ftxtLeftSeconds_CellTimeDiscountPanel", WZUIFreeTextBox)
    local sFormat = [[<T C="255,227,116" S="18" P="1" SC="105,65,46" SS="4" SE="1">%s</T><T C="255,89,74" S="18" P="1" SC="158,0,0" SS="4" SE="1">%02d:%02d:%02d</T>]]
    if ftxtLeftSeconds then 
        local nHour = math.floor(self.m_nLeftSeconds/3600)
        local nMinute = math.floor((self.m_nLeftSeconds - nHour * 3600)/ 60)
        local nSecond = self.m_nLeftSeconds - nHour * 3600 - nMinute * 60 
        ftxtLeftSeconds:setShowText(string.format(sFormat, LocalStrings.PROMISE_SHRINE_TEXT3, nHour, nMinute, nSecond))
    end
end

--@brief    
function CellTimeDiscountPanel:_caculateTime()
    -- body
    if self.m_nLeftSeconds > 0 then 
        self.m_nLeftSeconds = self.m_nLeftSeconds - 1 
        self:displayLeftSecond()
    elseif self.m_nLeftSeconds == 0 then
        local conForLeftTime = GetElement(self.m_root, "conForLeftTime_CellTimeDiscountPanel", WZUIContainer)
        conForLeftTime:disableSchedule()
        --跨天请求刷新的时候，如果礼钻不足提示窗口打开，则关闭
        WZLog("CellTimeDiscountPanel:_caculateTime", type(g_nConfirmCancelBoxId))
        if g_nConfirmCancelBoxId then 
            WZLog("CellTimeDiscountPanel:_caculateTime 1111")
            MsgBoxManager:removeMsgById(g_nConfirmCancelBoxId)
        end
        --跨天请求刷新
        WndGameActivity:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDailyDiscountInfo()
    end
end
-------------------------------------私有方法模块End----------------------------------------
--------------------------------------语言适配Begin-----------------------------------------
function CellTimeDiscountPanel:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtTime_CellTimeDiscountPanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end

function CellTimeDiscountPanel:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtTime_CellTimeDiscountPanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.5))
end

function CellTimeDiscountPanel:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtTime_CellTimeDiscountPanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.5))
end
---------------------------------------语言适配End------------------------------------------