--CellMonthCardPanel.lua
--@brief	CellMonthCardPanel的UI模块
--@date		2016/06/05
--@author	Tianxiang_Xu
--@note		月卡活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMonthCardPanel:onEnter(element)
	self.m_root = element
    if whetherCloseRecharge() then
        GetElement(self.m_root,"btn_getReward_event",WZUIButton):setVisible(false)
        GetElement(self.m_root,"txtCost_CellMonthCardPanel",WZUILabelTTF):setVisible(false)
    end
    local isCanBuy = checkIsCanBuyIOSAutoRenewalSubscription()
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_CellMonthCardPanel", WZUILabelTTF)
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellMonthCardPanel", WZUILabelTTF)
    local txtSubscription = ""
    if LocalStrings.SUBSCRIPTIONING then
        txtSubscription = LocalStrings.SUBSCRIPTIONING
    end
    if isCanBuy == -1 then
        txtTimeWord:setTextKey("")
        txtTimeWord:setText(txtSubscription)
        txtTimeValue:setVisible(false)
    elseif isCanBuy == -2 then
        txtTimeWord:setTextKey("")
        txtTimeWord:setText("")
        txtTimeValue:setVisible(false)
    end
    
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMonthCardPanel:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    点击立即购买回调
function CellMonthCardPanel:onRechargeEvent(element)
    -- body
    WZLog("CellMonthCardPanel:onRechargeEvent")
    GlobalGame.g_bIsClickMonthCard = true
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local nLimiteDays = tonumber(CacheCenter:getGameParam().limitMonthlyCardDay)
    WZLog("CellMonthCardPanel:onRechargeEvent nLimiteDays", nLimiteDays, self.m_nCardActivityState, self.m_nBuyCardTimes)
    --月卡剩余时间大于0不再操作
    --if self:_getMonthCardTime() > 0 then
        --MsgBoxManager:showTipBox(string.format(LocalStrings.MAX_MOUTH_CARD, nLimiteDays))
        --return
    --end
    local isCanBuy = checkIsCanBuyIOSAutoRenewalSubscription()
    WZLog("CellMonthCardPanel:onRechargeEvent isCanBuy", isCanBuy)
    if isCanBuy == -2 then
        --开放了订阅功能，未获取到订阅状态-检查订阅状态
        ProtocolProcessorRecharge:send_PURCHASE_IOSSubscrip()
        return
    elseif isCanBuy == -1 then
        --已订阅且订阅仍在有效期之内
        if LocalStrings.SUBSCRIPTIONING then
            MsgBoxManager:showTipBox(LocalStrings.SUBSCRIPTIONING, nil, nil, nil, nil)
        end
        return
    end
    if self:_getMonthCardTime() >= nLimiteDays then
        MsgBoxManager:showTipBox(string.format(LocalStrings.MAX_MOUTH_CARD, nLimiteDays))
    else
        WndGameActivity:_createLoading()
        if self.newRechargeType and self.m_nCardActivityState == 0 and self.m_nBuyCardTimes <= 0 and self.m_tRechargeData then 
            local nCurTime = SystemTime:getServerTime()
            if nCurTime < self.m_nCardActivityEndTime then 
                --popFastRechargeUI(50, self.m_tRechargeData.price)
                popFastRechargeUI50(50, self.m_tRechargeData.price)
                return 
            end
        end
        --popFastRechargeUI(50)
        popFastRechargeUI50(50)
    end    
    --WZLog("CellMonthCardPanel:onRechargeEvent self:_getMonthCardTime()", self:_getMonthCardTime())
end

--@brief    点击物品回调
function CellMonthCardPanel:onOthersClick(luaTable,tag,tData)
    -- body
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    显示窗口
function CellMonthCardPanel:showWindow()
    self.newRechargeType = tonumber(CacheCenter:getGameParam().monthCardDiscountRechargeType)

    self.m_tRechargeData = self:getRechargeData(self.newRechargeType)
    WZLog("CellMonthCardPanel:showWindow", self.newRechargeType, self.m_nCardActivityState)
    if self.m_nCardActivityState == 0 then 
        self.m_root:enableSchedule("_caculateTime", 1)
    end

    self:_staticText()
    self:_setRewardsList()
end

--@brief    刷新剩余时间
function CellMonthCardPanel:updateLeftDay()
    -- body
    if self.m_root == nil then return end
    WZLog("CellMonthCardPanel:updateLeftDay")
    local nLastDay = self:_getMonthCardTime()
    local bIsGet = self:_isMonthCardRewardGet()
    -- if bIsGet then
    --     nLastDay = nLastDay - 1
    -- end
    local conLeftTime = GetElement(self.m_root, "conLeftTime_CellMonthCardPanel", WZUIContainer)
    if nLastDay > 0 then
        conLeftTime:setVisible(true)
    else
        conLeftTime:setVisible(false)
    end
    --月卡剩余时间
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_CellMonthCardPanel", WZUILabelTTF)
    txtTimeValue:setText(string.format(LocalStrings.SHOP_DAY, nLastDay))

    local isCanBuy = checkIsCanBuyIOSAutoRenewalSubscription()
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellMonthCardPanel", WZUILabelTTF)
    local txtSubscription = ""
    if LocalStrings.SUBSCRIPTIONING then
        txtSubscription = LocalStrings.SUBSCRIPTIONING
    end
    if isCanBuy == -1 then
        txtTimeWord:setTextKey("")
        txtTimeWord:setText(txtSubscription)
        txtTimeValue:setVisible(false)
    elseif isCanBuy == -2 then
        txtTimeWord:setTextKey("")
        txtTimeWord:setText("")
        txtTimeValue:setVisible(false)
    end
    AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMonthCardPanel:_staticText()
    -- body
    local nLastDay = self:_getMonthCardTime()
    local bIsGet = self:_isMonthCardRewardGet()
    -- if bIsGet then
    --     nLastDay = nLastDay - 1
    -- end
    local conLeftTime = GetElement(self.m_root, "conLeftTime_CellMonthCardPanel", WZUIContainer)
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellMonthCardPanel", WZUILabelTTF)
    if nLastDay > 0 then
        conLeftTime:setVisible(true)
        txtTimeWord:setTextKey("MONTHCARD_LEFTTIME")
    else
        conLeftTime:setVisible(false)
    end
    --月卡剩余时间
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_CellMonthCardPanel", WZUILabelTTF)
    txtTimeValue:setText(string.format(LocalStrings.SHOP_DAY, nLastDay))
    --花费
    local showPrice = self:_getMonthCarShowPrice(50)
    WZLog("CellMonthCardPanel:_staticText", showPrice, nLastDay)
    local txtCost = GetElement(self.m_root, "txtCost_CellMonthCardPanel", WZUILabelTTF)
    if showPrice then
        txtCost:setRelativePosition(GlobalMethod:ccp(0.5,0.9))
        txtCost:setUseSystemFont(true)
        txtCost:setText(showPrice)
    end
    --移除斜杠和新价格
    local conForBtn = GetElement(self.m_root, "conForBtn_CellMonthCardPanel", WZUIContainer)
    if conForBtn:getChildByTag(777) then 
        conForBtn:removeChildByTag(777, true)
    end
    if txtCost:getChildByTag(888) then 
        txtCost:removeChildByTag(888, true)
    end
    --活动提示语
    if self.m_root:getChildByTag(999) then 
        self.m_root:removeChildByTag(999, true)
    end
    local imgBK = GetElement(self.m_root, "imgBK_CellMonthCardPanel", WZUIImage)
    imgBK:setFile("ui/newActivity/activity_pic_flk_yk.png")
    if self.m_nCardActivityState == 0 then 
        conLeftTime:setVisible(true)
        txtTimeWord:setTextKey("PEOPLE_SHOP_TEXT1")
        local tTempList = WndWelfare:getFreecaData()
        local startTime = SystemTime:getServerTime()
        for i = 1, #tTempList do
            if tTempList[i].type == g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT then 
                startTime = tTempList[i].startTime
                break 
            end
        end
        local startDate = os.date("*t", startTime)
        local endDate = os.date("*t", self.m_nCardActivityEndTime)
        txtTimeValue:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min))

        local textContent1 
        local textContent2 
        if self.m_nBuyCardTimes <= 0 then 
            textContent1 = LocalStrings.CARD_ACTIVITY_TEXT1
            txtCost:setRelativePosition(GlobalMethod:ccp(0.5,0.9))
            if self.newRechargeType then
                if self.m_tRechargeData then 
                    self:_createNewPrice(conForBtn, self.m_tRechargeData.unit, showPrice)
                end
            end
            imgBK:setFile("ui/newActivity/activity_pic_hd_ykdz.png")
        else
            textContent1 = LocalStrings.CARD_ACTIVITY_TEXT1 
            textContent2 = LocalStrings.CARD_ACTIVITY_TEXT4
        end
        local conTips = self:_createActivityTips(textContent1, textContent2)
        conTips:setRelativePosition(GlobalMethod:ccp(0.8, 0.35))
        self.m_root:addChild(conTips, 0, 999)
    end
end

--@brief    获取月卡时间剩余天数
function CellMonthCardPanel:_getMonthCardTime()
    --body
    local tPlayerItemsList = CacheCenter:getPlayerItems()
    if tPlayerItemsList == nil or tPlayerItemsList == {} then return end
    local nLastTime = 0
    for i = 1, #tPlayerItemsList do
        if tPlayerItemsList[i].id == 50 or tPlayerItemsList[i].id == 51 then
            --WZLog("********* CellMonthCardPanel:_getMonthCardTime *********", i, tPlayerItemsList[i].id, tPlayerItemsList[i].lastTime, nLastTime)
            nLastTime = nLastTime + tPlayerItemsList[i].lastTime
        end
    end

    WZLog("********* CellMonthCardPanel:_getMonthCardTime *********", nLastTime)

    local nLastDays = (nLastTime - (os.time() - SETITEMSTIME)) / (24 * 3600)

    return math.ceil(nLastDays)
end

--@brief    显示奖励列表
function CellMonthCardPanel:_setRewardsList()
    -- body
    local tbConReward = GetElement(self.m_root, "tbConReward_CellMonthCardPanel", WZUITableContainer)
    tbConReward:cleanTable()

    local rewardsList = self:_getMonthCardTaskRewards()
    if rewardsList == nil then return end 
    table.sort(rewardsList, sortRewards)
    --奖励大于3个时把金币放最后面
    if #rewardsList > 3 then
        for k, v in pairs(rewardsList) do
            if v[1] == 2 then
                table.insert(rewardsList, v)
                table.remove(rewardsList, k)
            end
        end
    end

    for i = 1, #rewardsList do
        local key = "id_"..rewardsList[i][1]
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
            local itemInfo = {id = rewardsList[i][1], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=rewardsList[i][2],quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tLuaObj:setCellGoodItem(itemInfo,4)
            celElement:setTag(i-1)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
            tbConReward:setCellElement(celElement)
        end
    end
end

--@biref    获取月卡显示价格
function CellMonthCardPanel:_getMonthCarShowPrice(itemId)
    -- body
    local vipList = CacheCenter:getVipList()
    if vipList == nil then return end
    for i = 1, #vipList do
        if self.m_nCardActivityState == 0 then
            if vipList[i].itemId == itemId and self.m_tRechargeData and self.m_tRechargeData.id ~= vipList[i].ids then
                WZLog("CellMonthCardPanel:_getMonthCarShowPrice", vipList[i].showPrice)
                return vipList[i].showPrice
            end
        end
    end 

    --如果没有月卡打折活动 就先取月卡中价格最高的显示
    local tTempVip = CopyTable(vipList)
    table.sort( tTempVip, function ( a,b )
            return tonumber(a.price) > tonumber(b.price)
        end )
    for i=1,#tTempVip do
        if tTempVip[i].itemId == itemId then
            return tTempVip[i].showPrice
        end
    end

    return nil 
end

--@brief    获取月卡福利奖励列表
function CellMonthCardPanel:_getMonthCardTaskRewards()
    -- body
    local rewardsList = nil 
    for idx, value in pairs(GDatatab_task) do
    --    if value.sub_type == 30014 and value.level <= CacheCenter:getPlayerInfo().level and value.max_level >= CacheCenter:getPlayerInfo().level then
        if value.sub_type == 30014 then
            rewardsList = value.reward
            break
        end
    end
    return rewardsList
end

--@brief    判断当日的月卡福利是否已经领取过
function CellMonthCardPanel:_isMonthCardRewardGet()
    -- body
    self.m_tDailyTaskCompleted = PrefetchCache:getTaskList().tDailyTask.tCompleted

    if self.m_tDailyTaskCompleted == nil then
        return false
    end

    for i = 1, #self.m_tDailyTaskCompleted do
        local nTask_sub_type = GDatatab_task["id_"..self.m_tDailyTaskCompleted[i].nId].sub_type 
        if nTask_sub_type == 30014 and self.m_tDailyTaskCompleted[i].nTaskStatus >= TASKSTATUS_COMPLETED then 
            return true
        end
    end
    return false
end

--计算时间
function CellMonthCardPanel:_caculateTime()
    -- body
    local nCurTime = SystemTime:getServerTime()

    if self.m_nCardActivityEndTime and nCurTime >= self.m_nCardActivityEndTime then 
        self.m_root:disableSchedule()
        WndFreeca:refreshActivityContext(g_tGameActivityTypes.ACTIVITY_MONTHCARD)
    end
end

--@brief    创建活动提示语
function CellMonthCardPanel:_createActivityTips(text1, text2)
    -- body
    local conOutSide = WZUIContainer:create()
    conOutSide:setName("conOutSide" .. "_CellMonthCardPanel")
    conOutSide:setUseAbsSize(true)
    conOutSide:setAbsContentSize(GlobalMethod:CCSize(200,60))

    --底1
    local img9BK1 = WZUI9Image:create()
    img9BK1:setFile("ui/common/common_scale9_di24.png")
    conOutSide:addChild(img9BK1)

    --数量
    if text1 then
        local ftxtText1 = WZUIFreeTextBox:create()
        ftxtText1:setMaxWidth(200)
        ftxtText1:setName("ftxtText1_CellMonthCardPanel")
        if text2 then 
            ftxtText1:setRelativePosition(GlobalMethod:ccp(0.5,0.67))
        else
            ftxtText1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        end
        ftxtText1:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        ftxtText1:setShowText(text1)
        conOutSide:addChild(ftxtText1)
    end
    if text2 then 
        local ftxtText2 = WZUIFreeTextBox:create()
        ftxtText2:setMaxWidth(200)
        ftxtText2:setName("ftxtText2_CellMonthCardPanel")

         ftxtText2:setRelativePosition(GlobalMethod:ccp(0.5,0.33))
        ftxtText2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        ftxtText2:setShowText(text2)
        conOutSide:addChild(ftxtText2)
    end

    return conOutSide
end

--@brief    创建新价格，斜杠
function CellMonthCardPanel:_createNewPrice(conForBtn, text, showPrice)
    -- body
    local txtCost = GetElement(self.m_root, "txtCost_CellMonthCardPanel", WZUILabelTTF)
    --斜杠
    if showPrice then
        local imgRedLine = WZUIImage:create()
        imgRedLine:setFile("ui/gameActivity/common_icon_xiexian3.png")
        imgRedLine:setUseOriginSize(true)
        imgRedLine:setScaleX(0.3)
        imgRedLine:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
        txtCost:addChild(imgRedLine, 0, 888)
    end
    --新价格
    local txtText = WZUILabelTTF:create()
    txtText:setName("txtText_CellMonthCardPanel")
    txtText:setEnableStroke(true)
    txtText:setStrokeSize(4)
    txtText:setFontSize(22)
    txtText:setColor(GlobalMethod:ccc3(99,255,95))
    txtText:setStrokeColor(GlobalMethod:ccc3(0,72,3))
    txtText:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    txtText:setRelativePosition(GlobalMethod:ccp(0.75,0.8))
    txtText:setUseSystemFont(true)
    txtText:setText(text)
    conForBtn:addChild(txtText, 0, 777)
end

function CellMonthCardPanel:_adaptLanguage_en()
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_CellMonthCardPanel",WZUILabelTTF)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.505259,0.5))
    local txtGoto = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txtGoto:setFontSize(18)
end

function CellMonthCardPanel:_adaptLanguage_pt(  )
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_CellMonthCardPanel",WZUILabelTTF)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.539124,0.5))
    local txtGoto = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txtGoto:setFontSize(18)
end

function CellMonthCardPanel:_adaptLanguage_tr(  )
    local txtGoto = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txtGoto:setFontSize(18)
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_CellMonthCardPanel",WZUILabelTTF)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.51,0.5))
end

function CellMonthCardPanel:_adaptLanguage_es()
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_CellMonthCardPanel",WZUILabelTTF)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.77,0.5))
    local txtGoto = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txtGoto:setFontSize(18)
end

function CellMonthCardPanel:_adaptLanguage_ug()
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_CellMonthCardPanel",WZUILabelTTF)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.72,0.5))
    local txtGoto = GetElement(self.m_root,"txt_gotoButton",WZUILabelTTF)
    txtGoto:setScale(0.7)
    txtGoto:setDimensions(GlobalMethod:CCSize(170))
end
-------------------------------------私有方法模块End----------------------------------------
