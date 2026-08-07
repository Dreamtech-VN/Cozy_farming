--CellDiscountLimitPanel.lua
--@brief	CellDiscountLimitPanel的UI模块
--@date		2017/07/19
--@author	Tianxiang_Xu
--@note		折扣限购活动，可以配置消耗货币类型


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDiscountLimitPanel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDiscountLimitPanel:onExit(element)
	self:_unInit()
end

--@brief    显示
function CellDiscountLimitPanel:showWindow( ... )
    -- body
    self:_showTime()
    self:_showGoods()
    AdaptLanguage(self)
end

--@brief    点击购买回调
function CellDiscountLimitPanel:clickBuy(tData)
    -- body
    self.m_tClickData = tData
    MsgBoxManager:showConfirmBoxWithBg(LocalStrings.ACTIVITY_BUY_SECOND, self, self.toContinue, nil, nil, "CellDiscountLimitPanel" .. self.m_nActivityType)
end

--@brief 
function CellDiscountLimitPanel:toContinue()
    -- body
    local tData = self.m_tClickData
    --数量不足
    if tData.times <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.LIMITE_BUY_SOLDOUT)
        return
    end
    
    --货币不足
    if not JudgeMoneyIsEnough(tData.priceId, tData.curPrice, nil, nil, Chat_Channel_GameActivity, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then 
        return 
    end

    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券购买物品
function CellDiscountLimitPanel:sureUseDiamondInstead()
    -- body
    local tData = self.m_tClickData
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    --是否已有无限期时装
    local bIsHaved = gCheckHaveOrNot(tData.id)
    --是否已有坐骑
    local hasMount = checkOwnMount(tData.id)
    --礼包内是否有时装或坐骑
    local checkGiftOwn, text = checkGiftOwn(tData.id)

    self.m_nClickRewardId = tData.rewardId
    if bIsHaved then
        local tBasicInfo = GDatatab_item["id_" .. tData.id]

        MsgBoxManager:showConfirmBox(string.format(LocalStrings.ACTIVITY_HAVED_ATT, tBasicInfo.name), self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    elseif hasMount then
        MsgBoxManager:showConfirmBox(LocalStrings.OWNMOUNT, self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    elseif checkGiftOwn then
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.OWN1, text), self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    else
        self:event_SureBuyAgain()
    end
end

function CellDiscountLimitPanel:event_SureBuyAgain()

    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_activityId, self.m_nClickRewardId)
end

--@brief    提示充值框的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function CellDiscountLimitPanel:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置活动时间
function CellDiscountLimitPanel:_showTime()
    -- body
    --字“活动时间”
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellDiscountLimitPanel", WZUILabelTTF)
    if txtTimeWord then
        txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    --活动具体日期
    local txtTime = GetElement(self.m_root, "txtTime_CellDiscountLimitPanel", WZUILabelTTF)
    if txtTime then
        local startDate = os.date("*t", self.m_nStartTime)
        local endDate = os.date("*t", self.m_nEndTime)
        local sTimeContent = string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min)
        txtTime:setText(sTimeContent)
    end
end

--@brief    显示出售的物品
function CellDiscountLimitPanel:_showGoods()
    -- body
    local tableList = GetElement(self.m_root, "tableList_CellDiscountLimitPanel", WZUITableContainer)
    tableList:cleanTable()
    self.m_tCellList = {}

    if self.m_rewardItems == nil or #self.m_rewardItems == 0 then return end
    local nCount = #self.m_rewardItems 
    WZLog("CellDiscountLimitPanel:_showGoods", nCount)
    for i = 1, nCount do
        local tData = {}
        tData.id = self.m_rewardItems[i]
        tData.num = self.m_rewardItemsParamCount[i]
        tData.originPrice = self.m_target[i * 4 - 2] 
        tData.curPrice = self.m_target[i * 4 - 1]
        tData.rewardId = self.m_rewardId[i]
        tData.times = self.m_rewardCounts[i]
        tData.priceId = self.m_target[i * 4] 

        local element, tNewObj = CellDiscountLimitItem:createElement()
        WZLog("CellDiscountLimitPanel:_showGoods", type(element), type(tNewObj))
        if element and tNewObj then
            self.m_tCellList[i] = tNewObj
            element:setTag(i - 1)
            tableList:setCellElement(element)
            
            tNewObj:setData(tData, self.m_nActivityType)
            tNewObj:setCallBackFunc(self, self.clickBuy)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-------------------------------------------------------------------------
function CellDiscountLimitPanel:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtTime_CellDiscountLimitPanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end
------------------------------------语言适配End-----------------------------------------------------------------------------