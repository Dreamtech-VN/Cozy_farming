--WndLeagueHPR.lua
--@brief	WndLeagueHPR的UI模块
--@date		2016/06/15
--@author	Tianxiang_Xu
--@note		英雄联赛-荣誉、回放、奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeagueHPR:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeagueHPR:onExit(element)
    self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    界面加载完成回调方法
function WndLeagueHPR:onEnterTransitionDidFinish(element)
    -- body
    self.m_root:enableSchedule("switchRoleAni", 3)
    self:_initInterface()
end

--@brief    觸摸開始回調
function WndLeagueHPR:onTouchBegin(element)
    -- body
    if WndItemInfo.m_root then
        WndItemInfo.onCloseClick()
    end
end

--@brief    点击荣誉左菜单回调函数
function WndLeagueHPR:onClickHonourLeft(nCurId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    local tbLeftList = GetElement(self.m_root, "tbLeftList_WndLeagueHPR", WZUITableContainer)

    for i = 1, #self.m_tHonourItemList do
        local element = tbLeftList:getCellElement(i - 1)
        if element then
            local celElement = element:getChildElement("__CellLeagueHPRItem")
            local tNewObj = WZUIContainer:luaTo(celElement):getLuaObjectIndex()
            WZLog("WndLeagueHPR:onClickHonourLeft", type(tNewObj))
            if tNewObj then 
                local id = tNewObj:getId()
                if id == nCurId then
                    self.m_nCurIndex = self.m_tHonourItemList[i].roundId
                    tNewObj:setHighLight(true)
                    self:_getHonourContent()
                else 
                    tNewObj:setHighLight(false)
                end
            end
        end
    end
    self.m_nCurIndex = nCurId 
end

--@brief    点击回放左菜单回调函数
function WndLeagueHPR:onClickReplayLeft(nCurId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    local tbLeftList = GetElement(self.m_root, "tbLeftList_WndLeagueHPR", WZUITableContainer)

    for i = 1, #self.m_tReplayItemList do
        local element = tbLeftList:getCellElement(i - 1)
        if element then
            local celElement = element:getChildElement("__CellLeagueHPRItem")
            local tNewObj = WZUIContainer:luaTo(celElement):getLuaObjectIndex()
            WZLog("WndLeagueHPR:onClickReplayLeft", type(tNewObj))
            if tNewObj then 
                local id = tNewObj:getId()
                if id == nCurId then
                    self.m_nCurIndex = self.m_tReplayItemList[i].id
                    tNewObj:setHighLight(true)
                    self:_getReplayContent()
                else 
                    tNewObj:setHighLight(false)
                end
            end
        end
    end
    self.m_nCurIndex = nCurId 
end

--@brief    点击奖励左菜单回调函数
function WndLeagueHPR:onClickRewardLeft(nCurId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    local tbLeftList = GetElement(self.m_root, "tbLeftList_WndLeagueHPR", WZUITableContainer)

    for i = 1, #self.m_tRewardItemList do
        local element = tbLeftList:getCellElement(i - 1)
        if element then
            local celElement = element:getChildElement("__CellLeagueHPRItem")
            local tNewObj = WZUIContainer:luaTo(celElement):getLuaObjectIndex()
            WZLog("WndLeagueHPR:onClickRewardLeft", type(tNewObj), nCurId)
            if tNewObj then 
                local id = tNewObj:getId()
                if id == nCurId then
                    self.m_nCurIndex = self.m_tRewardItemList[i].id
                    tNewObj:setHighLight(true)
                    self:_getRewardContent()
                else 
                    tNewObj:setHighLight(false)
                end
            end
        end
    end
    self.m_nCurIndex = nCurId 
end

--@brief    荣誉界面，角色动画随机切换
function WndLeagueHPR:switchRoleAni(element, delta)
    -- body
    if self.m_nIndex == 3 then
        local tRandomList = GetRandomNum(1, 4)
        if tRandomList ~= nil and tRandomList ~= {} then
            local nRandom = math.floor(tRandomList[1])
            if nRandom <= 0 then 
                nRandom = nRandom + 1
            end
            WZLog("***** WndLeagueHPR:switchRoleAni *****", nRandom)
            local conRole = GetElement(self.m_root, string.format("conRole%d_WndLeagueHPR", nRandom), WZUIContainer)
            if conRole then
                local celElement = conRole:getChildByTag(88)
                if celElement then
                    local tNewObj = celElement:getLuaObjectIndex()
                    if tNewObj then
                        tNewObj:changeRoleAni()
                    end
                end
            end
        end
    end
end

--@brief    获取战队成员信息
--@param    id:唯一id
--@param    teamId:战队Id
--@param    type:战队位置：1->左；2->右
function WndLeagueHPR:clickTeanIcon(element, id, teamId, type)
    -- body
    self.m_Element = element 
    self.m_nClickId = teamId 
    self.m_nPositionIndex = type
    if self.m_nCurIndex == 1 then
    else
        self:_createLoading()
        ProtocolProcessorWndLeague:send_HERO_RecordMes(self.m_nCurIndex, id)
    end
end

--@brief    获取战队成员信息成功
function WndLeagueHPR:getTeamPlayersOK(playerId, faceId, headId, name, sex, camp, mvp, teamId, level, headColor)
    -- body
    self:_closeLoading()

    local player = {}
    for i = 0, playerId:size() - 1 do
        if self.m_nClickId == teamId:get(i) then
            local tItem = {}
            tItem.id = playerId:get(i)
            tItem.name = name:get(i)
            tItem.sex = sex:get(i)
            if mvp == playerId:get(i) then
                tItem.mvpMark = 1 
            else
                tItem.mvpMark = 0
            end
            tItem.headId = headId:get(i)
            tItem.faceId = faceId:get(i)
            tItem.level = level:get(i)
            tItem.headColor = headColor:get(i)

            table.insert(player, tItem)
        end
    end
    WZLog("WndLeagueHPR:getTeamPlayersOK", Serialize(player), playerId:size())

    if self.m_nPositionIndex == 1 then
        WndTeamTips:show(self.m_Element,SceneLeagueMain.m_root,player,GlobalMethod:ccp(220,60))
    else
        WndTeamTips:show(self.m_Element,SceneLeagueMain.m_root,player,GlobalMethod:ccp(-100,60))
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    根据点击的标签，显示相应的内容
function WndLeagueHPR:_initInterface()
    -- body
    WZLog("WndLeagueHPR:_initInterface", self.m_nIndex)
    if self.m_nIndex == 3 then  -- 荣誉
        GetElement(self.m_root, "conRightHonour", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conRightReplay", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conRightReward", WZUIContainer):setVisible(false)
        self:_createLoading()
        ProtocolProcessorWndLeague:send_HERO_TeamFirstList()
    elseif self.m_nIndex == 4 then  -- 回放
        self:setReplayItemData()
        GetElement(self.m_root, "conRightHonour", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conRightReplay", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conRightReward", WZUIContainer):setVisible(false)
    elseif self.m_nIndex == 5 then  -- 奖励
        self:setRewardItemData()
        GetElement(self.m_root, "conRightHonour", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conRightReplay", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conRightReward", WZUIContainer):setVisible(true)
    end
end

--@brief    创建荣誉左边菜单列表
function WndLeagueHPR:_createHonourList()
    -- body
    local conLeagueHPR = GetElement(self.m_root, "conLeagueHPR", WZUIContainer)
    if self.m_tHonourItemList == nil or #self.m_tHonourItemList == 0 then
        if conLeagueHPR then
            conLeagueHPR:setVisible(false)
        end

        ShowPanelNullTip(self.m_root, LocalStrings.LEAGUE_HONOUR_TEXT1, GlobalMethod:ccc3(255,236,193))
        return
    end

    conLeagueHPR:setVisible(true)
    --移除暂无数据
    removeShowPanelNullTip(self.m_root)

    local tbLeftList = GetElement(self.m_root, "tbLeftList_WndLeagueHPR", WZUITableContainer)
    tbLeftList:cleanTable()

    for i = 1, #self.m_tHonourItemList do
        local celElement, tNewObj = CellLeagueHPRItem:createElement()
        if celElement then
            if i == 1 and self.m_nCurIndex == nil then
                self.m_nCurIndex = self.m_tHonourItemList[i].roundId
                tNewObj:setHighLight(true)
                self:_getHonourContent()
            end
            celElement:setTag(i - 1)
            tbLeftList:setCellElement(celElement)
            tNewObj:setCallFunc(self, self.onClickHonourLeft)
            tNewObj:setData(self.m_tHonourItemList[i].roundId, self.m_tHonourItemList[i].teamName, self.m_tHonourItemList[i].roundId)
        end
    end

    WndLeagueHPR:_getHonourContent()
end

--@brief    发送协议，获取相应的冠军队的信息
function WndLeagueHPR:_getHonourContent()
    -- body
    WZLog("WndLeagueHPR:_getHonourContent")
    self:_createLoading()
    ProtocolProcessorWndLeague:send_HERO_TeamFirstDetail(self.m_nCurIndex)
end

--@brief    创建右边的荣誉内容
function WndLeagueHPR:_createHonourContent()
    -- body
    if self.m_tHonourData == nil then return end

    --标题
    local txtTitle = GetElement(self.m_root, "txtTitle_WndLeagueHPR", WZUILabelTTF)
    txtTitle:setText(string.format(LocalStrings.LEAGUE_HONOUR_TITLE, self.m_tHonourData.roundId))
    --战队图标
    local conTeamIcon = GetElement(self.m_root, "conTeamIcon_WndLeagueHPR", WZUIContainer)
    local celElement,tCell = CellDownloadImg:createElement()
    conTeamIcon:addChild(celElement)

    SceneLeagueMain:addDownloadFileList(self.m_tHonourData.teamIcon, tCellL, nil, 60)
    --战队名字
    local txtTemaName = GetElement(self.m_root, "txtTemaName_WndLeagueHPR", WZUILabelTTF)
    txtTemaName:setText(self.m_tHonourData.teamName)
    --战队宣言
    local txtTeamWords = GetElement(self.m_root, "txtTeamWords_WndLeagueHPR", WZUILabelTTF)
    txtTeamWords:setText(self.m_tHonourData.teamWords)
    --战队人员
    local tPlayer = self.m_tHonourData.player
    for i = 1, 4 do
        local conRole = GetElement(self.m_root, string.format("conRole%d_WndLeagueHPR", i), WZUIContainer)
        conRole:removeAllChildrenWithCleanup(true)
    end
    for i = 1, #tPlayer do
        local celElement, tNewObj = CellLeagueHonourItem:createElement()
        if celElement then
            local conRole = GetElement(self.m_root, string.format("conRole%d_WndLeagueHPR", i), WZUIContainer)
            conRole:removeAllChildrenWithCleanup(true)
            celElement:setTag(88)
            tNewObj:setData(tPlayer[i])
            conRole:addChild(celElement)
        end
    end
end

--@brief    创建回放左菜单列表
function WndLeagueHPR:_createReplayList()
    -- body
    local conLeagueHPR = GetElement(self.m_root, "conLeagueHPR", WZUIContainer)
    conLeagueHPR:setVisible(true)
    if self.m_tReplayItemList == nil then return end

    local tbLeftList = GetElement(self.m_root, "tbLeftList_WndLeagueHPR", WZUITableContainer)
    tbLeftList:cleanTable()

    for i = 1, #self.m_tReplayItemList do
        local celElement, tNewObj = CellLeagueHPRItem:createElement()
        if celElement then
            if i == 1 and self.m_nCurIndex == nil then
                self.m_nCurIndex = self.m_tReplayItemList[i].id
                tNewObj:setHighLight(true)
                self:_getReplayContent()
            end
            celElement:setTag(i - 1)
            tbLeftList:setCellElement(celElement)
            tNewObj:setCallFunc(self, self.onClickReplayLeft)
            tNewObj:setData(self.m_tReplayItemList[i].id, self.m_tReplayItemList[i].itemName)
        end
    end
end

--@brief    发送协议，获取相应的回放列表的信息
function WndLeagueHPR:_getReplayContent()
    -- body
    WZLog("WndLeagueHPR:_getReplayContent", self.m_nCurIndex)
    self:_createLoading()
    if self.m_nCurIndex == 1 then
        ProtocolProcessorWndLeague:send_HERO_WatchList()
    else
        ProtocolProcessorWndLeague:send_HERO_RecordList(self.m_nCurIndex)
    end
end

--@brief    创建右边的回放内容
function WndLeagueHPR:_createReplayContent()
    --body
    local tbRecordList = GetElement(self.m_root, "tbRecordList_WndLeagueHPR", WZUITableContainer)
    tbRecordList:cleanTable()

    local conRightReplay = GetElement(self.m_root, "conRightReplay", WZUIContainer)
    if self.m_tReplayData == nil or #self.m_tReplayData == 0 then 
        if self.m_nCurIndex == 1 then --正在进行
            ShowPanelNullTip( conRightReplay, LocalStrings.LEAGUE_REPLAY_TEXT5)
        elseif self.m_nCurIndex == 2 then --精彩回放
            ShowPanelNullTip( conRightReplay, LocalStrings.LEAGUE_REPLAY_TEXT6)
        elseif self.m_nCurIndex == 3 then --决赛回放
            ShowPanelNullTip( conRightReplay, LocalStrings.LEAGUE_REPLAY_TEXT13)
        elseif self.m_nCurIndex == 4 then --我的回放
            ShowPanelNullTip( conRightReplay, LocalStrings.LEAGUE_REPLAY_TEXT14)
        end
        return 
    end 
    --移除暂无数据
    removeShowPanelNullTip(conRightReplay)

    WZLog("WndLeagueHPR:_createReplayContent", #self.m_tReplayData)

    for i = 1, #self.m_tReplayData do
        local celElement, tNewObj = CellLeagueReplayItem:createElement()
        if celElement then
            celElement:setTag(i - 1)
            tbRecordList:setCellElement(celElement)
            tNewObj:setData(self.m_nCurIndex, self.m_tReplayData[i])
            tNewObj:setCallFunc(self, self.clickTeanIcon)
        end
    end
end

--@brief    创建回放左菜单列表
function WndLeagueHPR:_createRewardList()
    -- body
    local conLeagueHPR = GetElement(self.m_root, "conLeagueHPR", WZUIContainer)
    conLeagueHPR:setVisible(true)
    if self.m_tRewardItemList == nil then return end

    local tbLeftList = GetElement(self.m_root, "tbLeftList_WndLeagueHPR", WZUITableContainer)
    tbLeftList:cleanTable()
    WZLog("WndLeagueHPR:_createRewardList", #self.m_tRewardItemList)
    for i = 1, #self.m_tRewardItemList do
        local celElement, tNewObj = CellLeagueHPRItem:createElement()
        if celElement then
            if i == 1 and self.m_nCurIndex == nil then
                self.m_nCurIndex = self.m_tRewardItemList[i].id
                tNewObj:setHighLight(true)
                self:_getRewardContent()
            end
            celElement:setTag(i - 1)
            tbLeftList:setCellElement(celElement)
            tNewObj:setCallFunc(self, self.onClickRewardLeft)
            tNewObj:setData(self.m_tRewardItemList[i].id, self.m_tRewardItemList[i].itemName)
        end
    end
end

--@brief    发送协议，获取相应的回放列表的信息
function WndLeagueHPR:_getRewardContent()
    -- body
    WZLog("WndLeagueHPR:_getRewardContent", self.m_nCurIndex)
    self:_createLoading()
    ProtocolProcessorWndLeague:send_HERO_FirstSelectReward(self.m_nCurIndex)
end

--@brief    创建右边的回放内容
function WndLeagueHPR:_createRewardContent()
    --body
    if self.m_tRewardData == nil then return end 

    --
    local txtTime = GetElement(self.m_root, "txtTime_WndLeagueHPR", WZUILabelTTF)
    if txtTime then
        txtTime:setVisible(true)
    end
    --重置时间
    local txtRefreshTime = GetElement(self.m_root, "txtRefreshTime_WndLeagueHPR", WZUIFreeTextBox)
    txtRefreshTime:setVisible(true)
    local  txtRightContent = GetElement(self.m_root, "txtRightContent_WndLeagueHPR", WZUIFreeTextBox)
    txtRightContent:setVisible(true)
    if self.m_nCurIndex == 1 then
        txtRefreshTime:setShowText(LocalStrings.LEAGUE_REWARD_TEXT2)
        --右下角文字内容
        local sRightContent = string.format(LocalStrings.LEAGUE_REWARD_TEXT1, self.m_nFightNum, self.m_nWinNum)
		if ProjConfig.LANGUAGE == "en" then
			sRightContent = string.format(LocalStrings.LEAGUE_REWARD_TEXT1, self.m_nWinNum, self.m_nFightNum)
		end
        txtRightContent:setShowText(sRightContent)
        --海选赛时间
        txtTime:setText(LocalStrings.LEAGUE18 .. self.m_sStartTime .. "-" .. self.m_sEndTime)
    elseif self.m_nCurIndex == 2 then
        local nRefrushSeconds = SceneLeagueMain:transformStringToTime(self.m_sGiveRewardsTime, true)
        local sNewDay = os.date("*t", nRefrushSeconds)
        local sRefrushDate = string.format("%d-%02d-%02d %02d:%02d", sNewDay.year, sNewDay.month, sNewDay.day, sNewDay.hour, sNewDay.min)
        WZLog("WndLeagueHPR:_createRewardContent", sRefrushDate)
        txtRefreshTime:setShowText(string.format(LocalStrings.LEAGUE_REWARD_TEXT3, sRefrushDate))
        --右下角文字内容
        local sRightContent
        if self.m_nMyTeamRank < 0 then
            sRightContent = string.format(LocalStrings.LEAGUE_REWARD_TEXT4, LocalStrings.NONE)
        else
            sRightContent = string.format(LocalStrings.LEAGUE_REWARD_TEXT4, tostring(self.m_nMyTeamRank))
        end
        txtRightContent:setShowText(sRightContent)
        txtTime:setVisible(false)

        if ProjConfig.LANGUAGE == "vn" then
            txtRefreshTime:setMaxWidth(440)
        end
    elseif self.m_nCurIndex == 3 then
        txtRefreshTime:setVisible(false)
        --右下角文字内容
        txtRightContent:setVisible(false)
        --联赛时间
        txtTime:setText(LocalStrings.LEAGUE10 .. self.m_sStartTime .. "-" .. self.m_sEndTime)
        --联赛时间
        txtTime:setText(LocalStrings.LEAGUE10 .. self.m_sStartTime .. "-" .. self.m_sEndTime)
    elseif self.m_nCurIndex == 4 then
        txtRefreshTime:setVisible(false)
        --右下角文字内容
        local sRightContent = string.format(LocalStrings.LEAGUE_REWARD_TEXT5, self.m_nKillNum)
        txtRightContent:setShowText(sRightContent)
        --击杀提示
        txtTime:setText(LocalStrings.LEAGUE_REWARD_TEXT8)
    end

    local tbRewardsList = GetElement(self.m_root, "tbRewardsList_WndLeagueHPR", WZUITableContainer)
    tbRewardsList:cleanTable()

    WZLog("WndLeagueHPR:_createRewardContent", #self.m_tRewardData)

    for i = 1, #self.m_tRewardData do
        local celElement, tNewObj = CellLeagueRewardItem:createElement()
        if celElement then
            celElement:setTag(i - 1)
            tbRewardsList:setCellElement(celElement)
            tNewObj:setData(self.m_tRewardData[i])
        end
    end
end

--@brief    网络加载界面
function WndLeagueHPR:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    网络加载界面
function WndLeagueHPR:_closeLoading()
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    self.m_nLoadingId = nil 
end
-------------------------------------私有方法模块End----------------------------------------
