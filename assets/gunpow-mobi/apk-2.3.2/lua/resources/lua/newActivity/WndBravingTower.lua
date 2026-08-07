--WndBravingTower.lua
--@brief    WndBravingTower的UI模块
--@date     2025/12/04
--@author   yrd
--@note     勇闯高塔


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndBravingTower:onEnter(element)
    WZLog("WndBravingTower:onEnter")
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
        local nCheckIndex = data:getStringValue("WndBravingTower", "checkSkip") == "1" and 1 or 0
        self.m_nCheckIndex = nCheckIndex
        checkSkip:setCheckIndex(nCheckIndex)
    end

    self:_initStaticText()
    -- self:_adaptIphoneX()

    AdaptLanguage(self)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndBravingTower:onExit(element)
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
function WndBravingTower:onEnterTransitionDidFinish(element)
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7185, 7185)

    local tData = {pool = 0}
    local tData2 = {pool = 1}
    local strJson = json.encode(tData)
    local strJson2 = json.encode(tData2)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7185, 2, strJson)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7185, 2, strJson2)

    self:_showAnimal()
end

--@brief    外部接口
function WndBravingTower:showInterface()
    LoadNewActivityRes(true)
    local wndWater = WndBravingTower:createElement()
    if wndWater then 
        WindowManager:addWindow(wndWater, WndBravingTower, false)
    end
end

--@brief    关闭窗口
function WndBravingTower:onCloseClick(element)
    local eleType = type(element)
    if eleType ~= "number" then 
        SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    end

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndBravingTower:onRuleClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface1(LocalStrings.BRAVING_TOWER_TEXT2) 
end

--@brief    初始化活动时间
function WndBravingTower:_initActivityTime()
    local tStartDate = os.date("*t", self.m_nStartTime)
    local tEndDate = os.date("*t", self.m_nEndTime)
    local strFormat = [[<T C="255,236,193" S="16" P="1" SC="132,66,29" SS="4" SE="1">%s:</T><BR></BR><T C="255,255,255" S="16" P="1" SC="132,66,29" SS="4" SE="1">%d %02d.%02d %02d:%02d</T><BR></BR><T C="255,255,255" S="16" P="1" SC="132,66,29" SS="4" SE="1">- %02d.%02d %02d:%02d</T>]]
    GetElement(self.m_root, "ftbActivityTime", WZUIFreeTextBox):setShowText(string.format(strFormat, LocalStrings.ACTIVE_TIME, tStartDate.year, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min))
end

--@brief    初始化静态文本
function WndBravingTower:_initStaticText()
    GetElement(self.m_root, "txtBtnTask1_WndBravingTower", WZUILabelTTF):setText(LocalStrings.RANKLIST_TITLE)
    GetElement(self.m_root, "txtRoundWord", WZUILabelTTF):setText(LocalStrings.BRAVING_TOWER_TEXT1[5])

    for i=1,6 do
        local btnReplaceReward = GetElement(self.m_root,"btnReplaceReward"..i,WZUIButton)
        GetElement(btnReplaceReward,"txtReplaceReward",WZUILabelTTF):setText(LocalStrings.BRAVING_TOWER_TEXT1[4])
    end
end

--@brief    显示更换大奖按钮
function WndBravingTower:_showRoundText()
    for i=1,#self.m_tContent.scoreConfig do
        local txtRoundTarget = GetElement(self.m_root,"txtRoundTarget"..i,WZUILabelTTF)
        txtRoundTarget:setText(string.format(LocalStrings.BRAVING_TOWER_TEXT1[6], self.m_tContent.scoreConfig[i]))
    end
end

--@brief    更新硬币的数量
function WndBravingTower:_updateCoinNum()
    local ftxtLightNum = GetElement(self.m_root, "ftxtLightNum_WndBravingTower", WZUIFreeTextBox)
    local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="18" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
    local basicData = GDatatab_item["id_" .. self.m_nCoinId]
    local nLightNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
    ftxtLightNum:setShowText(string.format(sFormat, basicData.icon, nLightNum))
end

--@brief    点击目标按钮回调
function WndBravingTower:onClickTask(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if SystemTime:getServerTime() >= self.m_nEndTime then 
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END) 
        self:onCloseClick(0)
        return 
    end 

    local nTag = element:getTag()
    if nTag == 1 then
        local otherData = {}
        otherData.type = 1
        otherData.strRankTitleName = LocalStrings.RANKLIST_TITLE
        otherData.strChangeTitle = LocalStrings.BRAVING_TOWER_TEXT1[8]
        otherData.strScoreTitle = LocalStrings.BRAVING_TOWER_TEXT1[9] .. ":"
        WndShopRank:showInterface(90, self.m_nActivityId, nil, nil, otherData)
    end
end

--@brief    更新抽奖按钮
function WndBravingTower:_updateDrawBtn()
    for i=1, 2 do
        local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
        local nTempTimes = math.floor(nArrowNum/self.m_nCoinNum) --可许愿次数
        local freeCount = self.m_nCount > 0 and self.m_nCount or 0 --免费次数

        local txtUseTool = GetElement(self.m_root,"txtUseTool"..i,WZUILabelTTF)
        txtUseTool:setText(string.format(LocalStrings.BRAVING_TOWER_TEXT1[3], self.m_tDrawNumList[i]))
        if i == 1 then
            if freeCount > 0 then
                txtUseTool:setText(LocalStrings.BRAVING_TOWER_TEXT1[2])
            end
        elseif i == 2 then
            if nTempTimes ~= 0 then
                local nTimes = self.m_tDrawNumList[i]
                local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
                if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[i] then
                    nTimes = nAllTimes
                end
                txtUseTool:setText(string.format(LocalStrings.BRAVING_TOWER_TEXT1[3], nTimes))
            end
        end
    end
end

--@brief    点击许愿按钮回调
function WndBravingTower:onClickUseTool(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end

    -- 请先选择轮数奖励
    local pool = 1
    for i=1,#self.m_tBigRewardList[pool] do
        local bflag = false
        for j=1,#self.m_tBigRewardList[pool][i].chooseState do
            if self.m_tBigRewardList[pool][i].chooseState[j] == 1 then
                bflag = true
                break
            end
        end
        if bflag == false then
            MsgBoxManager:showTipBox(LocalStrings.BRAVING_TOWER_TEXT1[11])
            return
        end
    end

    local nTag = element:getTag()
    local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
    local nTempTimes = math.floor(nArrowNum/self.m_nCoinNum) --可许愿次数
    local freeCount = self.m_nCount > 0 and self.m_nCount or 0 --免费次数
    local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数

    if nAllTimes == 0 then
        local basicData = GDatatab_item["id_" .. self.m_nCoinId]
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
        return 
    end

    self.m_nAniType = nTag
    self.m_bOpenState = true

    local tData = {}
    tData.times = self.m_tDrawNumList[nTag]
    local stringData = json.encode(tData)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief    前往小推车购买
function WndBravingTower:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        -- WndActivityPropsGift:showInterface(self.m_nCoinId)
        WndApartmentAct:showInterface()
    end
end


--@brief    显示更换大奖按钮
function WndBravingTower:_showReplaceBtns()
    for i=1,#self.m_tContent.superConfig do
        local btnReplaceReward = GetElement(self.m_root,"btnReplaceReward"..i,WZUIButton)
        btnReplaceReward:setVisible(self.m_tContent.superConfig[i] == 1)
    end
end

--@brief    点击物品弹出对应的tips
function WndBravingTower:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief    显示层级大奖
function WndBravingTower:_showLevelBigReward()
    local conItemList = GetElement(self.m_root,"conItemList",WZUIContainer)

    local pool = 0
    self.m_tBigRewardObj[pool] = self.m_tBigRewardObj[pool] or {}
    for i=1,#self.m_tBigRewardList[pool] do
        for j=1,#self.m_tBigRewardList[pool][i].chooseState do
            if self.m_tBigRewardList[pool][i].chooseState[j] == 1 then
                if self.m_tBigRewardObj[pool][i] == nil then
                    local x = 0.5 - self.m_tContent.giftConfig[i] * 0.0315
                    local y = self.m_tItemPosY[i]
                    local element, tNewObj = CellGoodItem:createElement()
                    element:setTag(i-1)
                    element:setScale(0.75)
                    element:setRelativePosition(GlobalMethod:ccp(x, y))
                    tNewObj:setItemClickFun(self, self.onItemClick)
                    tNewObj:setbtnImg2Pos({0.5,0.475})
                    conItemList:addChild(element)
                    self.m_tBigRewardObj[pool][i] = tNewObj
                end
                local basicData = GDatatab_item["id_" .. self.m_tBigRewardList[pool][i].reward_ids1[j]]
                self.m_tBigRewardObj[pool][i]:setCellGoodLocalId(self.m_tBigRewardList[pool][i].reward_ids1[j], self.m_tBigRewardList[pool][i].reward_nums1[j], 17)
                self.m_tBigRewardObj[pool][i]:setBackImgFile(self.m_tItemQuality[basicData.quality], nil, 1.3, GlobalMethod:ccp(0.49,0.48))
                self.m_tBigRewardObj[pool][i]:setQualityFrameVisible(false)
                break
            end
        end
    end
end

--@brief    显示层级普通奖
function WndBravingTower:_showLevelOrdinaryReward()
    local conItemList = GetElement(self.m_root,"conItemList",WZUIContainer)

    for i=1,#self.m_tGiftIds do
        for j=1,#self.m_tGiftIds[i] do
            self.m_tLevelOrdinaryRewardObj[i] = self.m_tLevelOrdinaryRewardObj[i] or {}
            if self.m_tLevelOrdinaryRewardObj[i][j] == nil then
                local x = 0.5 - self.m_tContent.giftConfig[i] * 0.0315 + j * 0.063
                local y = self.m_tItemPosY[i]
                local element, tNewObj = CellGoodItem:createElement()
                element:setTag(i-1)
                element:setScale(0.75)
                element:setRelativePosition(GlobalMethod:ccp(x, y))
                tNewObj:setItemClickFun(self, self.onItemClick)
                tNewObj:setbtnImg2Pos({0.5,0.475})
                conItemList:addChild(element)
                self.m_tLevelOrdinaryRewardObj[i][j] = tNewObj
            end

            local index = self.m_tGiftIds[i][j] + 1
            local basicData = GDatatab_item["id_" .. self.m_tLevelOrdinaryPoolData[i][index][1]]
            self.m_tLevelOrdinaryRewardObj[i][j]:setCellGoodLocalId(self.m_tLevelOrdinaryPoolData[i][index][1], self.m_tLevelOrdinaryPoolData[i][index][2], 17)
            self.m_tLevelOrdinaryRewardObj[i][j]:setBackImgFile(self.m_tItemQuality[basicData.quality], nil, 1.4, GlobalMethod:ccp(0.5,0.5))
            self.m_tLevelOrdinaryRewardObj[i][j]:setQualityFrameVisible(false)
        end
    end
end

--@brief    点击更换层级大奖按钮
function WndBravingTower:onClickReplace0(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()

    local strName = string.format(LocalStrings.BRAVING_TOWER_TEXT1[7], tag)
    local otherData = {}
    otherData.winType = 1
    otherData.activityId = self.m_nActivityId
    otherData.chooseInfo = {strKey=strName, doType=4, index=tag-1, only=true}
    WndJoinReward:showInterface("", self.m_tBigRewardList[0][tag], nil, LocalStrings.TREASURE_TEXT7, nil, 1, otherData)
end


--@brief    显示轮数奖励
function WndBravingTower:_showRoundBigReward()
    local pool = 1
    self.m_tBigRewardObj[pool] = self.m_tBigRewardObj[pool] or {}
    for i=1,#self.m_tBigRewardList[pool] do
        local conRoundReward = GetElement(self.m_root,"conRoundReward"..i,WZUIContainer)
        local bShowAdd = true
        for j=1,#self.m_tBigRewardList[pool][i].chooseState do
            if self.m_tBigRewardList[pool][i].chooseState[j] == 1 then
                bShowAdd = false
                if self.m_tBigRewardObj[pool][i] == nil then
                    local element, tNewObj = CellGoodItem:createElement()
                    element:setTag(i-1)
                    element:setScale(0.75)
                    element:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
                    tNewObj:setItemClickFun(self, self.onItemClick2)
                    tNewObj:setbtnImg2Pos({0.5,0.475})
                    conRoundReward:addChild(element)
                    self.m_tBigRewardObj[pool][i] = tNewObj
                end
                local basicData = GDatatab_item["id_" .. self.m_tBigRewardList[pool][i].reward_ids1[j]]
                self.m_tBigRewardObj[pool][i]:setCellGoodLocalId(self.m_tBigRewardList[pool][i].reward_ids1[j], self.m_tBigRewardList[pool][i].reward_nums1[j], 17)
                self.m_tBigRewardObj[pool][i]:setBackImgFile(self.m_tItemQuality[basicData.quality], nil, 1.4, GlobalMethod:ccp(0.5,0.5))
                self.m_tBigRewardObj[pool][i]:setQualityFrameVisible(false)
                break
            end
        end
        GetElement(self.m_root,"btnRoundAdd"..i,WZUIButton):setVisible(bShowAdd)
    end
end

--@brief    点击更换轮数大奖按钮
function WndBravingTower:onClickReplace1(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tag = element
    local eleType = type(element)
    if eleType ~= "number" then
        tag = element:getTag()
    end

    local strName = string.format(LocalStrings.BRAVING_TOWER_TEXT1[6], self.m_tContent.scoreConfig[tag])
    local otherData = {}
    otherData.winType = 1
    otherData.activityId = self.m_nActivityId
    otherData.chooseInfo = {strKey=strName, doType=4, index=tag-1, only=true}
    WndJoinReward:showInterface("", self.m_tBigRewardList[1][tag], nil, LocalStrings.TREASURE_TEXT7, nil, 1, otherData)
end

--@brief    点击物品弹出对应的tips
function WndBravingTower:onItemClick2(tCell,tag,tData)
    if tData == nil then
       return
    end

    if self.m_tScoreRewardStatus[tag+1] == -1 then
        self:onClickReplace1(tag+1)
    elseif self.m_tScoreRewardStatus[tag+1] == 0 then
        local tData = {id = tag}
        local strJson = json.encode(tData)
        ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7185, 5, strJson)
    elseif self.m_tScoreRewardStatus[tag+1] == 1 then
        self:onItemClick(tCell,tag,tData)
    end
end

--@brief    显示层级
function WndBravingTower:_showLevelNum(tCell,tag,tData)
    for i=1,6 do
        GetElement(self.m_root,"conLevelLight"..i,WZUIContainer):setVisible((self.m_nLevelNum + 1) == i)
    end
end

--@brief    显示轮数
function WndBravingTower:_showRoundNum(tCell,tag,tData)
    GetElement(self.m_root,"txtRoundNum",WZUILabelTTF):setText(string.format(LocalStrings.BRAVING_TOWER_TEXT1[6], self.m_nRoundNum))

    local nProg = self.m_nRoundNum / self.m_tContent.scoreConfig[#self.m_tContent.scoreConfig] * 100
    GetElement(self.m_root,"progRoundReward",WZUIProgress):setPercentage(nProg)
end

--@brief    显示轮数状态
function WndBravingTower:_updateRoundStatus()
    for i=1,#self.m_tScoreRewardStatus do
        local spienRoundReward = GetElement(self.m_root,"spienRoundReward"..i,WZUISpine)
        local imgRoundYLQ = GetElement(self.m_root,"imgRoundYLQ"..i,WZUIImage)
        if self.m_tScoreRewardStatus[i] == -1 then
            spienRoundReward:setVisible(false)
            imgRoundYLQ:setVisible(false)
        elseif self.m_tScoreRewardStatus[i] == 0 then
            spienRoundReward:setVisible(true)
            imgRoundYLQ:setVisible(false)
        elseif self.m_tScoreRewardStatus[i] == 1 then
            spienRoundReward:setVisible(false)
            imgRoundYLQ:setVisible(true)
        end
    end
end



--@brief    设置待机特效
function WndBravingTower:_showAnimal()
    local spinePath = "activity/hd_pic_ycgt"
    local existSpine = CheckEffectFile(spinePath)
    if existSpine then
        local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
        spineBG:setFileJson(spinePath .. ".json")
        spineBG:setFileAtlas(spinePath .. ".atlas")
        spineBG:play("wait1", true)

        local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
        spineOpen:setFileJson(spinePath .. ".json")
        spineOpen:setFileAtlas(spinePath .. ".atlas")
        spineOpen:play("wait_2", true)

        local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
        spineCopy:setFileJson(spinePath .. ".json")
        spineCopy:setFileAtlas(spinePath .. ".atlas")
        spineCopy:play("wait_2", true)
    end

    local spinePath2 = "city/ui_main_iconeffect"
    local existSpine2 = CheckEffectFile(spinePath2)
    if existSpine2 then
        for i = 1, 3 do
            local spineScoreBox = GetElement(self.m_root, "spienRoundReward" .. i, WZUISpine)
            if spineScoreBox then 
                spineScoreBox:setFileJson(spinePath2 .. ".json")
                spineScoreBox:setFileAtlas(spinePath2 .. ".atlas")
                spineScoreBox:play("animation", true)
            end
        end
    end
end

--@breif    开始滚动相关数值
function WndBravingTower:_startRoll()
    if self.m_nCheckIndex == 1 then
        self:showWheelReward()
    else
        self.m_curCircle = 0
        self.m_curItem = 1
        self.m_temrRecord = 0
        local conItemList = GetElement(self.m_root,"conItemList",WZUIContainer)
        conItemList:enableSchedule("_starRollSchedule")

        local x = 0.5 - (#self.m_tRollReward - 1) * 0.0315  + (self.m_curItem - 1) * 0.063
        local y = self.m_tItemPosY[self.m_nLevelNum + 1]
        local spineOpen = GetElement(self.m_root,"spineOpen",WZUISpine)
        spineOpen:setRelativePosition(GlobalMethod:ccp(x, y))
        spineOpen:play("wait_2", true)
        spineOpen:setVisible(true)
    end
end

--@brief 开始滚动
function WndBravingTower:_starRollSchedule()
    self.m_temrRecord = self.m_temrRecord + 1
    if self.m_curCircle == 0 then --初始状态
        if self.m_temrRecord > 0 then
            self.m_temrRecord = 0
            self:updateHighlightCell()
        end
    elseif self.m_curCircle == 1 then --第一圈
        if self.m_temrRecord > 1 then
            self.m_temrRecord = 0
            self:updateHighlightCell()
        end
    elseif self.m_curCircle == 2 then --第二圈
        if self.m_temrRecord > 1 then
            self.m_temrRecord = 0
            self:updateHighlightCell()
        end
    elseif self.m_curCircle == 3 then --第三圈
        if self.m_temrRecord > 2 then
            self.m_temrRecord = 0
            self:updateHighlightCell()
        end
    elseif self.m_curCircle == 4 then --第四圈
        if self.m_temrRecord > 3 then
            self.m_temrRecord = 0
            self:updateHighlightCell()
        end
    end
end

--@brief  抽奖cell高亮
function WndBravingTower:updateHighlightCell()
    if self.m_bCopyRoll == true then
        local x = 0.5 - (#self.m_tRollReward - 1) * 0.0315  + (self.m_curItem - 1) * 0.063
        local y = self.m_tItemPosY[self.m_nLevelNum + 1]
        local spineCpoy = GetElement(self.m_root,"spineCopy",WZUISpine)
        spineCpoy:setRelativePosition(GlobalMethod:ccp(x, y))
        spineCpoy:setVisible(true)
    end

    self.m_curCircle = self.m_curCircle + math.floor(self.m_curItem / #self.m_tRollReward)
    self.m_curItem = self.m_curItem % #self.m_tRollReward + 1

    local x = 0.5 - (#self.m_tRollReward - 1) * 0.0315  + (self.m_curItem - 1) * 0.063
    local y = self.m_tItemPosY[self.m_nLevelNum + 1]
    local spineOpen = GetElement(self.m_root,"spineOpen",WZUISpine)
    spineOpen:setRelativePosition(GlobalMethod:ccp(x, y))

    self.m_bCopyRoll = true

    if self.m_curCircle >= 4 and self.m_curItem == self.m_nWinningIndex then
        local conItemList = GetElement(self.m_root,"conItemList",WZUIContainer)
        conItemList:enableSchedule("showWheelReward",0.5)

        local spineOpen = GetElement(self.m_root,"spineOpen",WZUISpine)
        spineOpen:play("wait_3", false)

        self.m_bCopyRoll = false
        local spineCpoy = GetElement(self.m_root,"spineCopy",WZUISpine)
        spineCpoy:setVisible(false)
    end
end

--@brief    显示转盘奖励
function WndBravingTower:showWheelReward(element)
    local spineOpen = GetElement(self.m_root,"spineOpen",WZUISpine)
    spineOpen:setVisible(false)

    local conItemList = GetElement(self.m_root,"conItemList",WZUIContainer)
    conItemList:disableSchedule()

    self.m_bOpenState = false

    self:_showReward()


    --刷新界面
    if self.m_nOldLevelNum then
        self.m_nLevelNum = self.m_nOldLevelNum
        self.m_nOldLevelNum = nil
        self:_showLevelNum()
    end
    if self.m_nOldRoundNum then
        self.m_nRoundNum = self.m_nOldRoundNum
        self.m_nOldRoundNum = nil
        self:_showRoundNum()
    end
    if self.m_tOldGiftIds then
        self.m_tGiftIds = self.m_tOldGiftIds
        self.m_tOldGiftIds = nil
        self:_showLevelOrdinaryReward()
    end

    --刷新自选奖励
    if self.m_tOldBigRewardList then
        self.m_tBigRewardList = CopyTable(self.m_tOldBigRewardList)
        self.m_tOldBigRewardList = nil
        self:_showLevelBigReward()
    end
end

--@brief    显示奖励
function WndBravingTower:_showReward()
    if self.m_root == nil then return end

    local tBigReward = {}
    if self.m_tOpenResult.bigRewards and #self.m_tOpenResult.bigRewards > 0 then 
        for i = 1, #self.m_tOpenResult.bigRewards do
            table.insert(tBigReward, self.m_tOpenResult.bigRewards[i])
        end
    end

    if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
        WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards, tBigReward)
    elseif #tBigReward > 0 then 
        WndHoraryBigReward:showInterface(6, tBigReward)
    end
end

--@brief    勾选跳过动画按钮回调
function WndBravingTower:onClickSkip(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local checkSkip = GetElement(self.m_root,"checkSkip",WZUICheckBox)
    self.m_nCheckIndex = checkSkip:getCheckIndex()
    local data = WZDataFile:getInstance():getUserData()
    if data then
        data:setStringValue("WndBravingTower", "checkSkip", tostring(self.m_nCheckIndex))
        data:flush()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


---------------------------------------------语言适配Begin-----------------------------------

function WndBravingTower:_adaptLanguage_vn(  )
    for i=1,6 do
        local btnReplaceReward = GetElement(self.m_root,"btnReplaceReward"..i,WZUIButton)
        btnReplaceReward:setAbsContentSize(GlobalMethod:CCSize(172,72))
        btnReplaceReward:updateRelativeSize()
        local txtReplaceReward = GetElement(btnReplaceReward,"txtReplaceReward",WZUILabelTTF)
        txtReplaceReward:setScale(0.7)
        txtReplaceReward:setDimensions(GlobalMethod:CCSize(240,0))
        txtReplaceReward:setRelativePosition(GlobalMethod:ccp(0.5,0.54))
    end
end

---------------------------------------------语言适配End--------------------------------------
