--WndLuckyFlip.lua
--@brief    WndLuckyFlip的UI模块
--@date     2025/11/26
--@author   yrd
--@note     幸运翻牌


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndLuckyFlip:onEnter(element)
    self.m_root = element

    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
    ProtocolProcessorFestivalActivity:regAll6()
    GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
    GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
    -- GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

    local checkSkip = GetElement(self.m_root,"checkSkip",WZUICheckBox)
    local data = WZDataFile:getInstance():getUserData()
    if data then
        local nCheckIndex = data:getStringValue("WndLuckyFlip", "checkSkip") == "1" and 1 or 0
        self.m_nCheckIndex = nCheckIndex
        checkSkip:setCheckIndex(nCheckIndex)
    end

    self:showUI2(false)
    self:_initStaticText()
    self:_updateCoinNum()
    self:_showAnimal()
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndLuckyFlip:onExit(element)
    g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
    CacheCenter:unregisterUpatePlayerItemObserver(self)
    ProtocolProcessorFestivalActivity:unregAll6()
    GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
    GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
    -- GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)

    self:_unInit()
    LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndLuckyFlip:onEnterTransitionDidFinish(element)
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7183, 7183)

    local tData = {pool = 0}
    local tData2 = {pool = 1}
    local strJson = json.encode(tData)
    local strJson2 = json.encode(tData2)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7183, 2, strJson)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7183, 2, strJson2)
end

--@brief    外部入口
function WndLuckyFlip:showInterface()
    LoadNewActivityRes(true)
    local wnd = WndLuckyFlip:createElement()
    WindowManager:addWindow(wnd, WndLuckyFlip, false)
end

--@brief    点击关闭窗口按钮
function WndLuckyFlip:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndLuckyFlip:onRuleClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.LUCKY_FLIP_TEXT2)
end

--@brief    初始化静态文本
function WndLuckyFlip:_initStaticText()
    GetElement(self.m_root,"txtActivityWord_WndLuckyFlip",WZUILabelTTF):setText(LocalStrings.ACTIVE_TIME)
    GetElement(self.m_root,"txtRightTitle_WndLuckyFlip",WZUILabelTTF):setText(LocalStrings.LUCKY_FLIP_TEXT1[6])
    GetElement(self.m_root,"txtRightReceive_WndLuckyFlip",WZUILabelTTF):setText(LocalStrings.GET_REWARD)

end

--@brief    初始化活动时间
function WndLuckyFlip:_initActivityTime()
    local tStartDate = os.date("*t", self.m_nStartTime)
    local tEndDate = os.date("*t", self.m_nEndTime)
    local strFormat = [[<T C="255,255,255" S="18" P="1">%02d</T><T C="255,255,255" S="18" P="1">%02d</T><T C="255,255,255" S="18" P="1"> - </T><T C="255,255,255" S="18" P="1">%02d</T><T C="255,255,255" S="18" P="1">%02d</T>]]
    GetElement(self.m_root, "ftbActivityTime_WndLuckyFlip", WZUIFreeTextBox):setShowText(string.format(strFormat, tStartDate.month, tStartDate.day, tEndDate.month, tEndDate.day))
end

--@brief    更新许愿币的数量
function WndLuckyFlip:_updateCoinNum()
    local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,255,255" S="20" P="1" SC="31,71,213" SS="4" SE="0">%d</T>]]
    local basicData = GDatatab_item["id_" .. self.m_nCoinId]
    local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
    GetElement(self.m_root, "ftbCoin_WndLuckyFlip", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief    初始化左边界面
function WndLuckyFlip:updateLeftUI()
    local nSex = CacheCenter:getPlayerInfo().sex

    self.m_tItemObjs = self.m_tItemObjs or {}
    local conItemsShow = GetElement(self.m_root,"conItemsShow_WndLuckyFlip",WZUIContainer)
    for i = 1, #self.m_nShowIds do
        if self.m_tItemObjs[i] == nil then
            local x = 0.107 + (i - 1) % 6 * 0.1322
            local y = 0.886 - math.floor((i - 1) / 6) * 0.1304
            local element, tNewObj = CellGoodItem:createElement()
            element:setTag(i-1)
            element:setScale(0.85)
            element:setRelativePosition(GlobalMethod:ccp(x, y))
            tNewObj:setItemClickFun(self,self.onItemClick)
            tNewObj:setTouchHeightVisible(false)
            tNewObj:setbtnImg2Pos({0.5,0.475})
            conItemsShow:addChild(element)
            self.m_tItemObjs[i] = tNewObj
        end
        local item = self.m_tShowPoolStr[self.m_nShowIds[i]+1]
        self.m_tItemObjs[i]:setCellGoodLocalId(item[nSex+1], item[3], 17)
        self.m_tItemObjs[i]:setQualityFrameVisible(false)
        self.m_tItemObjs[i]:setGrayRender(true)
        self.m_tItemObjs[i]:setBackImgFile("ui/newActivity/common_xyfp_tbd_01.png", nil, 1.18, GlobalMethod:ccp(0.5,0.465))
        if self.m_tSpine2List[i] then
            self.m_tSpine2List[i]:setVisible(false)
        end
    end

    for i = 1, #self.m_nShowRewardIds do
        self.m_tItemObjs[self.m_nShowRewardIds[i]+1]:setGrayRender(false)
        self.m_tItemObjs[self.m_nShowRewardIds[i]+1]:setBackImgFile("ui/newActivity/common_xyfp_tbd_02.png", nil, 1.18, GlobalMethod:ccp(0.5,0.465))
        if self.m_tSpine2List[self.m_nShowRewardIds[i]+1] then
            self.m_tSpine2List[self.m_nShowRewardIds[i]+1]:setVisible(true)
        end
    end

    --收集奖励
    for i = 1, #self.m_nCollectRewardStatus do
        if self.m_tSpine6List[i] then
            self.m_tSpine6List[i]:setVisible(self.m_nCollectRewardStatus[i] == 0)
        end
        GetElement(self.m_root,"imgBoxRedDot"..i,WZUIImage):setVisible(self.m_nCollectRewardStatus[i] == 0)
    end
end

--@brief    显示五音自选奖励
function WndLuckyFlip:_showFiveKeyReward()
    local reward_ids = self.m_tFiveKeyReward.reward_ids1
    local reward_nums = self.m_tFiveKeyReward.reward_nums1
    local tTempData = self.m_tFiveKeyReward
    if self.m_tCellCircleRewards == nil then 
        local tbFiveReward = GetElement(self.m_root, "tbFiveReward_WndLuckyFlip", WZUITableContainer)
        tbFiveReward:cleanTable()
        self.m_tCellCircleRewards = {}
        for i = 1, #reward_ids do
            local tabItem = GDatatab_item["id_".. reward_ids[i]]
            local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
            local bVisibleLimit = false
            local strLimit = "" 
            if tTempData.leftConfig then 
                itemInfo.leftConfig = tTempData.leftConfig[i]
                bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
            end
            if tTempData.chooseState then 
                itemInfo.chooseState = tTempData.chooseState[i]
            end
            if tTempData.pool then 
                itemInfo.pool = tTempData.pool
            end
            local nType = 17 
            local celElement,tCell = CellGoodItem:createElement()
            if celElement and tCell then
                tCell:setCellGoodItem(itemInfo, nType)
                celElement:setTag(i-1)
                celElement:setScale(0.8)
                tbFiveReward:setCellElement(celElement)
                if tTempData.chooseState then 
                    tCell:setItemClickFun(self,self.onClickItem2)
                else
                    tCell:setItemClickFun(self,self.onItemClick)
                end
                if bVisibleLimit then 
                    tCell:_addNumLimit(strLimit)
                end
                if itemInfo.chooseState and itemInfo.chooseState == 1 then 
                    tCell:setItemSelState(true)
                end
                tCell:setBackImgFile("ui/newActivity/common_yxty_tbd_01.png", nil, nil, GlobalMethod:ccp(0.556,0.411))
                tCell:setQualityFrameVisible(false)

                table.insert(self.m_tCellCircleRewards, tCell)
            end
        end
    else
        for i = 1, #reward_ids do
            local tabItem = GDatatab_item["id_".. reward_ids[i]]
            local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
            local bVisibleLimit = false
            local strLimit = "" 
            if tTempData.leftConfig then 
                itemInfo.leftConfig = tTempData.leftConfig[i]
                bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
            end
            if tTempData.chooseState then 
                itemInfo.chooseState = tTempData.chooseState[i]
            end
            if tTempData.pool then 
                itemInfo.pool = tTempData.pool
            end
            local tCell = self.m_tCellCircleRewards[i]
            if tCell then
                if bVisibleLimit then 
                    tCell:_addNumLimit(strLimit)
                end
                if itemInfo.chooseState and itemInfo.chooseState == 1 then 
                    tCell:setItemSelState(true)
                else
                    tCell:setItemSelState(false)
                end
            end
        end
    end
end

--@brief    可领取大奖次数
function WndLuckyFlip:updateBigRewardCount()
    GetElement(self.m_root,"txtRightCount_WndLuckyFlip",WZUILabelTTF):setText(LocalStrings.LUCKY_FLIP_TEXT1[4] .. ": " .. self.m_nGiftReward)
end

--@brief    更新抽奖按钮
function WndLuckyFlip:updateWishingBtn()
    local ftbUseTool1 = GetElement(self.m_root,"ftbUseTool1",WZUIFreeTextBox)

    local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
    local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
    local freeCount = 0 --免费次数
    if self.m_nDrawToolType == 0 then 
        freeCount = self.m_nCount > 0 and 1 or 0 
    end
    local nTimes = self.m_tDrawNumList[self.m_nDrawNumType]
    local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
    if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[self.m_nDrawNumType] then
        nTimes = nAllTimes
    end
    nTimes = math.min(nTimes, (36-#self.m_nShowRewardIds))
    local strformat = [[<I Z="0.4" P="1">%s</I><T C="255,255,255" S="18" P="1" SC="132,66,29" SS="4" SE="1">%s</T><T C="255,255,255" S="26" P="1" SC="132,66,29" SS="4" SE="1"> %s</T>]]
    local strFormat1 = LocalStrings.LUCKY_FLIP_TEXT1[2]
    local strFormat2 = LocalStrings.LUCKY_FLIP_TEXT1[3]
    local basicData = GDatatab_item["id_" .. self.m_nCoinId]
    if freeCount == 1 then
        if self.m_nDrawNumType == 1 then
            local tempStr = strFormat1
            local cost = self.m_tCostByType[self.m_nDrawToolType + 1] * (nTimes - freeCount)
            ftbUseTool1:setShowText(string.format(strformat, basicData.icon, cost, tempStr))
        elseif self.m_nDrawNumType == 2 then
            if nTempTimes == 0 then
                local tempStr = string.format(strFormat2, self.m_tDrawNumList[self.m_nDrawNumType])
                local cost = self.m_tCostByType[self.m_nDrawToolType + 1] * (self.m_tDrawNumList[self.m_nDrawNumType] - freeCount)
                ftbUseTool1:setShowText(string.format(strformat, basicData.icon, cost, tempStr))
            else
                local tempStr = string.format(strFormat2, nTimes)
                local cost = self.m_tCostByType[self.m_nDrawToolType + 1] * (nTimes - freeCount)
                ftbUseTool1:setShowText(string.format(strformat, basicData.icon, cost, tempStr))
            end
        end
    else
        if nTimes == 0 then
            local tempStr = string.format(strFormat2, self.m_tDrawNumList[self.m_nDrawNumType])
            local cost = self.m_tCostByType[self.m_nDrawToolType + 1] * (self.m_tDrawNumList[self.m_nDrawNumType] - freeCount)
            ftbUseTool1:setShowText(string.format(strformat, basicData.icon, cost, tempStr))
        else
            local tempStr = string.format(strFormat2, nTimes)
            local cost = self.m_tCostByType[self.m_nDrawToolType + 1] * (nTimes - freeCount)
            ftbUseTool1:setShowText(string.format(strformat, basicData.icon, cost, tempStr))
        end
    end
end

--@brief    点击许愿按钮回调
function WndLuckyFlip:onClickUseTool(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --点击切换数量按钮响应
    local nTag = element:getTag()
    if nTag == 2 then
        self.m_nDrawNumType = self.m_nDrawNumType % 2 + 1
        self:updateWishingBtn()
        return
    end

    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    if self.m_bOpenState then return end

    -- 收集奖励宝箱
    if #self.m_nShowRewardIds == 36 then
        --抽满了,但收集宝箱没领
        for i=1,#self.m_nCollectRewardStatus do
            if self.m_nCollectRewardStatus[i] == 0 then
                MsgBoxManager:showTipBox(LocalStrings.LUCKY_FLIP_TEXT1[11])
                return
            end
        end
        --抽满了,但没刷新
        MsgBoxManager:showTipBox(LocalStrings.LUCKY_FLIP_TEXT1[12])
        return
    end

    local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
    local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
    local freeCount = 0 --免费次数
    if self.m_nDrawToolType == 0 then 
        freeCount = self.m_nCount > 0 and 1 or 0 
    end
    self.m_nAniType = self.m_nDrawNumType
    local nTimes = self.m_tDrawNumList[self.m_nDrawNumType]
    local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
    if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[self.m_nDrawNumType] then
        nTimes = nAllTimes
    end

    local nCostNum = nTimes * self.m_tCostByType[self.m_nDrawToolType + 1]
    if nCostNum - freeCount > nArrowNum or self.m_nAniType == 2 and nArrowNum == 0 then 
        local basicData = GDatatab_item["id_" .. self.m_nCoinId]
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
        return 
    end

    self:setOpenState(true)
    self:updateWishingBtn()

    local tData = {}
    tData.times = self.m_tDrawNumList[self.m_nDrawNumType]
    local stringData = json.encode(tData)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief    选择奖励返回
function WndLuckyFlip:chooseReturn(tag, index, status)
    if self.m_root == nil then return end 

    local tTempData = self.m_tFiveKeyReward
    tTempData.chooseState[index] = status
    self.m_tCellCircleRewards[index]:updateChooseStateData(status)
    if status == 0 then 
        self.m_tCellCircleRewards[index]:setItemSelState(false)
    elseif status == 1 then 
        self.m_tCellCircleRewards[index]:setItemSelState(true)
    end
end

--@brief    前往小推车购买
function WndLuckyFlip:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        -- WndActivityPropsGift:showInterface(self.m_nCoinId)
        WndApartmentAct:showInterface()
    end
end

--@brief    点击物品弹出对应的tips
function WndLuckyFlip:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief    点击奖励回调
function WndLuckyFlip:onClickItem2(tCell, tag, tData)
    WZLog("WndLuckyFlip:onClickItem2 ")
    local otherData = {}
    otherData.activityId = self.m_nActivityId
    otherData.chooseInfo = {strKey="LUCKY_FLIP_TEXT1", wordIndex=5, doType=4}
    otherData.changeRes = 2
    otherData.img9Bg = "ui/common/frame_tc_xiao.png"
    otherData.img9SecBg = "ui/common/frame_lieb.png"
    otherData.img9Bg_UseOriginSize = false
    otherData.titlePt = GlobalMethod:ccp(0.5,0.926)
    otherData.titleStroke = true
    otherData.titleColor = GlobalMethod:ccc3(255,250,236)
    otherData.titleStrokeColor = GlobalMethod:ccc3(132,66,29)
    otherData.tabRewardPt = GlobalMethod:ccp(0.5,0.55)
    WndAthShop:showInterface("", self.m_tFiveKeyReward, LocalStrings.LUCKY_FLIP_TEXT1[7], otherData)
end

--@brief    展示转盘物品
function WndLuckyFlip:_showWheelItems()
    -- 横
    local img_path = {"ui/common_num/xyfp_A.png", "ui/common_num/xyfp_B.png", "ui/common_num/xyfp_C.png", "ui/common_num/xyfp_D.png", "ui/common_num/xyfp_E.png", "ui/common_num/xyfp_F.png"}
    local conWheelItem1 = GetElement(self.m_root,"conWheelItem1",WZUIContainer)
    conWheelItem1:removeAllChildrenWithCleanup(true)
    --奖品
    local num1 = 6
    for i=0,num1+2 do
        local idx = (i+num1-1)%num1+1
        local img = WZUIImage:create()
        img:setFile(img_path[idx])
        img:setUseOriginSize(true)
        img:setRelativePosition(GlobalMethod:ccp(0.5, 0.5+(i-1)))
        conWheelItem1:addChild(img)
    end

    -- 竖
    local conWheelItem2 = GetElement(self.m_root,"conWheelItem2",WZUIContainer)
    conWheelItem2:removeAllChildrenWithCleanup(true)
    --奖品
    local num2 = 6
    local strFormat = [[<A IMG = "ui/common_num/xyfp_0-9.png" Z="1" W="45" H="59" CHAR="0">%d</A>]]
    for i=0,num2+2 do
        local idx = (i+num2-1)%num2+1
        local ftbRatio = WZUIFreeTextBox:create()
        ftbRatio:setMaxWidth(1000)
        ftbRatio:setRelativePosition(GlobalMethod:ccp(0.5, 0.5+(i-1)))
        ftbRatio:setShowText(string.format(strFormat, idx))
        conWheelItem2:addChild(ftbRatio)
    end
end

--@brief    点击领取按钮回调
function WndLuckyFlip:onClickReceive(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nGiftReward <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.LUCKY_FLIP_TEXT1[9])
        return
    end

    local bCanReceive = false
    for i=1,#self.m_tFiveKeyReward.chooseState do
        if self.m_tFiveKeyReward.chooseState[i] == 1 then
            bCanReceive = true
            break
        end
    end
    -- if bCanReceive == false then
    --     MsgBoxManager:showTipBox(LocalStrings.LUCKY_FLIP_TEXT1[13])
    --     return
    -- end

    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 7, "")
end


--@brief    确定使用蓝钻代替进行摇一摇
function WndLuckyFlip:sureToUseDiaInstead()
    local tData = {times = 1}
    local strJson = json.encode(tData)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, strJson)
end

--@breif 开始滚动相关数值
function WndLuckyFlip:_startRoll()
    WZLog("WndLuckyFlip:_startRoll")
    local conDrawWheel = GetElement(self.m_root,"conDrawWheel",WZUIContainer)

    if self.m_nCheckIndex == 1 then
        self:_passRoll()
    else
        self.n_speed = {0.4,0.2} --初始速度
        self.t_bActionOver = {0,0} --转盘动画结束
        conDrawWheel:enableSchedule("_starRollSchedule")
    end
end

--@breif 跳过动画直接滚动
function WndLuckyFlip:_passRoll()
    local idx1 = math.floor(self.m_nShowId / 6) + 1
    local idx2 = self.m_nShowId % 6 + 1
    local tEndPosIdx = {idx1, idx2} --最终抽到的物品或倍率下标

    for i=1,#tEndPosIdx do
        local conWheelItem = GetElement(self.m_root,"conWheelItem"..i,WZUIContainer)
        local curPos = conWheelItem:getRelativePosition()
        local endPosY = 0.5 - 1 * (tEndPosIdx[i] - 1)
        conWheelItem:setRelativePosition(GlobalMethod:ccp(curPos.x, endPosY))
    end

    local existSpine = CheckEffectFile(self.m_strSpinePath)
    if existSpine and self.m_nCheckIndex ~= 1 then
        self:_playSpecialEffectsAnimation()
    else
        WndRewardShow:showById(self.m_tBlessItemIds, self.m_tBlessItemNums)
        self.m_bOpenState = false
        self:updateWishingBtn()
        self:updateLeftUI()
        self:updateRefreshBtn()
        self:updateBigRewardCount()
    end
end

--@brief 开始滚动
function WndLuckyFlip:_starRollSchedule()
    local conDrawWheel = GetElement(self.m_root,"conDrawWheel",WZUIContainer)

    local nMinSpeed1 = 0.1 --第一段减速时最小速度
    local nDeclineSpeed1 = 0.005 --第一段减速时速度每帧减小
    local nMinSpeed2 = 0.005 --第二段减速时最小速度
    local nDeclineSpeed2 = 0.001 --第二段减速时速度每帧减小

    local idx1 = math.floor(self.m_nShowId / 6) + 1
    local idx2 = self.m_nShowId % 6 + 1
    local tEndPosIdx = {idx1, idx2} --最终抽到的物品或倍率下标
    local tRewardList = {6, 6}

    for i=1,#tEndPosIdx do
        local conWheelItem = GetElement(self.m_root,"conWheelItem"..i,WZUIContainer)
        local curPos = conWheelItem:getRelativePosition()

        local endPosY = 0.5 - 1 * (tEndPosIdx[i] - 1)

        local nPrevNum = math.min(tRewardList[i], 5) --提前5个开始减慢速度
        local nPrevPosIdx = ((tEndPosIdx[i] - 1) + tRewardList[i] - nPrevNum) % tRewardList[i] + 1
        local nPrevPosY = 0.5 - 1 * (nPrevPosIdx - 1)
        if (i == 1 or i ~= 1 and self.t_bActionOver[i-1] == 1) and ( --第二个转盘要等第一个转盘先结束
            (self.n_speed[i] < nMinSpeed1 and self.n_speed[i] > nMinSpeed2) or
            (self.n_speed[i] == nMinSpeed1 and curPos.y - self.n_speed[i] <= nPrevPosY and curPos.y >= nPrevPosY)
        ) then
            self.n_speed[i] = math.max(self.n_speed[i] - nDeclineSpeed2, nMinSpeed2)
        elseif (i == 1 or i ~= 1 and self.t_bActionOver[i-1] == 1) and self.n_speed[i] > nMinSpeed1 then
            self.n_speed[i] = math.max(self.n_speed[i] - nDeclineSpeed1, nMinSpeed1)
        end

        if (i == 1 or i ~= 1 and self.t_bActionOver[i-1] == 1) and self.n_speed[i] == nMinSpeed2 and curPos.y - self.n_speed[i] <= endPosY and curPos.y >= endPosY then
            conWheelItem:setRelativePosition(GlobalMethod:ccp(curPos.x, endPosY))
            self.t_bActionOver[i] = 1
        else
            local posY = curPos.y - self.n_speed[i]
            if posY <= 0.5 - 1 * tRewardList[i] then
                posY = 0.5
            end
            conWheelItem:setRelativePosition(GlobalMethod:ccp(curPos.x, posY))
        end
    end

    local bEndAni = true
    for i=1, #self.t_bActionOver do
        if self.t_bActionOver[i] ~= 1 then
            bEndAni = false
            break
        end
    end
    if bEndAni then
        conDrawWheel:disableSchedule()
        self:_passRoll()
    end
end

--@brief    勾选跳过动画按钮回调
function WndLuckyFlip:onClickSkip(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local checkSkip = GetElement(self.m_root,"checkSkip",WZUICheckBox)
    self.m_nCheckIndex = checkSkip:getCheckIndex()
    local data = WZDataFile:getInstance():getUserData()
    if data then
        data:setStringValue("WndLuckyFlip", "checkSkip", tostring(self.m_nCheckIndex))
        data:flush()
    end
end

--@brief    勾选跳过动画按钮回调
function WndLuckyFlip:_playSpecialEffectsAnimation()
    for i=1,2 do
        self.m_tSpine3List[i]:play("wait_daiji3", true)
        self.m_tSpine3List[i]:setVisible(true)
    end

    local conItemsSpine = GetElement(self.m_root,"conItemsSpine_WndLuckyFlip",WZUIContainer)
    conItemsSpine:enableSchedule("_scheduleAni1",0.7)
end

--@brief    动画1
function WndLuckyFlip:_scheduleAni1()
    for i=1,2 do
        self.m_tSpine3List[i]:setVisible(false)
    end

    self.m_tSpine4:play("wait_daiji4", false)
    self.m_tSpine4:setVisible(true)

    local conItemsSpine = GetElement(self.m_root,"conItemsSpine_WndLuckyFlip",WZUIContainer)
    conItemsSpine:enableSchedule("_scheduleAni2",1)
end

--@brief    动画2
function WndLuckyFlip:_scheduleAni2()
    self.m_tSpine4:setVisible(false)

    self.m_tSpine5:play("wait_daiji5", false)
    self.m_tSpine5:setVisible(true)

    local conItemsSpine = GetElement(self.m_root,"conItemsSpine_WndLuckyFlip",WZUIContainer)
    conItemsSpine:enableSchedule("_scheduleAni3",1)
end

--@brief    动画3
function WndLuckyFlip:_scheduleAni3()
    self.m_tSpine5:setVisible(false)

    local conItemsSpine = GetElement(self.m_root,"conItemsSpine_WndLuckyFlip",WZUIContainer)
    conItemsSpine:disableSchedule()

    WndRewardShow:showById(self.m_tBlessItemIds, self.m_tBlessItemNums)
    self.m_bOpenState = false
    self:updateWishingBtn()
    self:updateLeftUI()
    self:updateRefreshBtn()
    self:updateBigRewardCount()
end



--@brief    更新刷新按钮
function WndLuckyFlip:updateRefreshBtn()
    local ftbRefresh = GetElement(self.m_root,"ftbRefresh_WndLuckyFlip",WZUIFreeTextBox)
    if #self.m_nShowRewardIds == 36 then
        local strFormat = [[<T C="255,255,255" S="24" P="1" SC="145,49,255" SS="4" SE="1">%s</T><BR></BR>]]
        ftbRefresh:setShowText(string.format(strFormat, LocalStrings.REFRESH))
    elseif self.m_nRefreshTimes < self.m_tContent.refreshConfig[1] then
        local strLeftTime = string.format(LocalStrings.LUCKYGIFT_FREEDRAW, (self.m_tContent.refreshConfig[1] - self.m_nRefreshTimes))
        local strFormat = [[<T C="255,255,255" S="16" P="1" SC="145,49,255" SS="4" SE="1">%s</T><BR></BR><T C="255,255,255" S="16" P="1" SC="145,49,255" SS="4" SE="1">%s</T><BR></BR><T C="255,255,255" S="14" P="1" SC="145,49,255" SS="4" SE="1">%s</T>]]
        ftbRefresh:setShowText(string.format(strFormat, LocalStrings.PETFREE2, LocalStrings.REFRESH, strLeftTime))
    elseif self.m_nRefreshTimes < self.m_tContent.refreshConfig[1] + self.m_tContent.refreshConfig[5] then
        local tCostInfo = GDatatab_item["id_"..self.m_tContent.refreshConfig[2]]
        local nCostNum = self.m_tContent.refreshConfig[3] + (self.m_nRefreshTimes - self.m_tContent.refreshConfig[1]) * self.m_tContent.refreshConfig[4]
        local strFormat = [[<T C="255,255,255" S="22" P="1" SC="145,49,255" SS="4" SE="1">%s</T><BR></BR><I Z="0.3" P="1">%s</I><T C="255,255,255" S="14" P="1" SC="145,49,255" SS="4" SE="1">%s</T>]]
        ftbRefresh:setShowText(string.format(strFormat, LocalStrings.REFRESH, tCostInfo.icon, nCostNum))
    else
        local strFormat = [[<T C="255,255,255" S="24" P="1" SC="145,49,255" SS="4" SE="1">%s</T><BR></BR>]]
        ftbRefresh:setShowText(string.format(strFormat, LocalStrings.REFRESH))
    end
end

--@brief    点击刷新按钮
function WndLuckyFlip:onRefreshClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- 收集奖励宝箱
    if #self.m_nShowRewardIds == 36 then
        --抽满了,但收集宝箱没领
        for i=1,#self.m_nCollectRewardStatus do
            if self.m_nCollectRewardStatus[i] == 0 then
                MsgBoxManager:showTipBox(LocalStrings.LUCKY_FLIP_TEXT1[11])
                return
            end
        end
    end

    if #self.m_nShowRewardIds == 36 then
    elseif self.m_nRefreshTimes < self.m_tContent.refreshConfig[1] then
    elseif self.m_nRefreshTimes < self.m_tContent.refreshConfig[1] + self.m_tContent.refreshConfig[5] then
        local nCostNum = self.m_tContent.refreshConfig[3] + (self.m_nRefreshTimes - self.m_tContent.refreshConfig[1]) * self.m_tContent.refreshConfig[4]
        if not JudgeMoneyIsEnough(self.m_tContent.refreshConfig[2], nCostNum, nil, nil, nil, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
            return
        end
    else
        MsgBoxManager:showTipBox(LocalStrings.DEFENDFARM_TEXT1[22])
        return
    end

    self:sureToUseDiamondInstead()
end

--@brief    确认用钻石代替礼券抽奖
function WndLuckyFlip:sureToUseDiamondInstead()
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
end



--@brief    点击收集奖宝箱
function WndLuckyFlip:showUI2(bShow)
    GetElement(self.m_root,"conUI2_WndLuckyFlip",WZUIContainer):setVisible(bShow)
end

--@brief    关闭
function WndLuckyFlip:onUI2TouchBegin(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:showUI2(false)
end

--@brief    点击收集奖宝箱
function WndLuckyFlip:onBoxClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()

    local nSex = CacheCenter:getPlayerInfo().sex

    if self.m_nCollectRewardStatus[tag] == 0 then
        local tData = {id = tag-1}
        local strJson = json.encode(tData)
        ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, strJson)
    else
        local conU2Items = GetElement(self.m_root,"conU2Items_WndLuckyFlip",WZUIContainer)
        conU2Items:removeAllChildrenWithCleanup(true)
        for i=1, #self.m_nCollectIds[tag] do
            local x = 0.11 + (i - 1) * 0.156 + (6 - #self.m_nCollectIds[tag]) * 0.078
            local y = 0.47
            local itemId = self.m_tBigRewardList["reward_ids"][self.m_nCollectIds[tag][i]+1]
            local itemNum = self.m_tBigRewardList["reward_nums"][self.m_nCollectIds[tag][i]+1]
            local element, tNewObj = CellGoodItem:createElement()
            element:setTag(i-1)
            element:setScale(0.85)
            element:setRelativePosition(GlobalMethod:ccp(x, y))
            tNewObj:setCellGoodLocalId(itemId, itemNum, 17)
            tNewObj:setItemClickFun(self,self.onItemClick)
            tNewObj:setBackImgFile("ui/newActivity/common_xyfp_tbd_02.png", nil, 1.18, GlobalMethod:ccp(0.5,0.465))
            tNewObj:setQualityFrameVisible(false)
            tNewObj:setTouchHeightVisible(false)
            tNewObj:setbtnImg2Pos({0.5,0.475})
            conU2Items:addChild(element)
        end
        self:showUI2(true)
    end
end



--@brief    显示动画
function WndLuckyFlip:_showAnimal()
    local spinePath = self.m_strSpinePath
    local existSpine = CheckEffectFile(self.m_strSpinePath)
    if existSpine then
        local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
        spineBG:setFileJson(spinePath .. ".json")
        spineBG:setFileAtlas(spinePath .. ".atlas")
        spineBG:play("wait_daiji", true)

        local conItemsSpine = GetElement(self.m_root,"conItemsSpine_WndLuckyFlip",WZUIContainer)

        self.m_tSpine2List = {}
        for i = 1, 36 do
            local x = 0.19 + (i - 1) % 6 * 0.1322
            local y = 0.225 - math.floor((i - 1) / 6) * 0.1304
            local spine = WZUISpine:create()
            spine:setVisible(false)
            spine:setTouchEnable(false)
            spine:setFileJson(spinePath .. ".json")
            spine:setFileAtlas(spinePath .. ".atlas")
            spine:setUseOriginSize(true)
            spine:setRelativePosition(GlobalMethod:ccp(x, y))
            spine:play("wait_daiji2", true)
            conItemsSpine:addChild(spine)
            self.m_tSpine2List[i] = spine
        end

        self.m_tSpine3List = {}
        for i = 1, 2 do
            local x = 1.15 + (i - 1) * 0.29
            local y = -0.372
            local spine = WZUISpine:create()
            spine:setVisible(false)
            spine:setTouchEnable(false)
            spine:setFileJson(spinePath .. ".json")
            spine:setFileAtlas(spinePath .. ".atlas")
            spine:setUseOriginSize(true)
            spine:setRelativePosition(GlobalMethod:ccp(x, y))
            -- spine:play("wait_daiji3", false)
            conItemsSpine:addChild(spine)
            self.m_tSpine3List[i] = spine
        end

        self.m_tSpine4 = nil
        local spine = WZUISpine:create()
        spine:setVisible(false)
        spine:setTouchEnable(false)
        spine:setFileJson(spinePath .. ".json")
        spine:setFileAtlas(spinePath .. ".atlas")
        spine:setUseOriginSize(true)
        spine:setRelativePosition(GlobalMethod:ccp(0.967, -0.129))
        spine:play("wait_daiji4", false)
        conItemsSpine:addChild(spine)
        self.m_tSpine4 = spine

        self.m_tSpine5 = nil
        local spine = WZUISpine:create()
        spine:setVisible(false)
        spine:setTouchEnable(false)
        spine:setFileJson(spinePath .. ".json")
        spine:setFileAtlas(spinePath .. ".atlas")
        spine:setUseOriginSize(true)
        spine:setScale(5)
        spine:setRelativePosition(GlobalMethod:ccp(0.443,-2.75))
        spine:play("wait_daiji5", true)
        conItemsSpine:addChild(spine)
        self.m_tSpine5 = spine

        self.m_tSpine6List = {}
        for i = 1, 6 do
            local x = 1.188
            local y = 0.88 - (i - 1) * 0.1304
            local spine = WZUISpine:create()
            spine:setVisible(false)
            spine:setTouchEnable(false)
            spine:setFileJson(spinePath .. ".json")
            spine:setFileAtlas(spinePath .. ".atlas")
            spine:setUseOriginSize(true)
            spine:setRelativePosition(GlobalMethod:ccp(x, y))
            spine:play("wait_daiji6", true)
            spine:setRotation(-90)
            conItemsSpine:addChild(spine)
            table.insert(self.m_tSpine6List, spine)
        end
        for i = 1, 6 do
            local x = 0.102 + (i - 1) * 0.1322
            local y = -0.176
            local spine = WZUISpine:create()
            spine:setVisible(false)
            spine:setTouchEnable(false)
            spine:setFileJson(spinePath .. ".json")
            spine:setFileAtlas(spinePath .. ".atlas")
            spine:setUseOriginSize(true)
            spine:setRelativePosition(GlobalMethod:ccp(x, y))
            spine:play("wait_daiji6", true)
            conItemsSpine:addChild(spine)
            table.insert(self.m_tSpine6List, spine)
        end

    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
