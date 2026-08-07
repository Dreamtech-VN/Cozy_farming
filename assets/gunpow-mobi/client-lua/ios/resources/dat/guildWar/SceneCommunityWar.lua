--SceneCommunityWar.lua
--@brief	SceneCommunityWar的UI模块
--@date		2017/02/03
--@author	Tianxiang_Xu
--@note		新公会战


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunityWar:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    ProtocolProcessorCommunityWar:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunityWar:onExit(element)
    self.m_root:disableSchedule()
    self.m_nodeTopCon:disableSchedule()
	self:_unInit()
end

--@brief    场景加载完成回调
function SceneCommunityWar:onEnterTransitionDidFinish(element)
    -- body
    ChangeChatChannel(Chat_Channel_Community_Progress)
    self:_addTop()
    self:_setStaticText()
    self:_getRaceTime()
    --目标红点
    self:updateTargetBtnRedDot()

    local pgconForGroup = GetElement(self.m_root, "pgconForGroup_SceneCommunityWar", WZUIPageContainer)
    pgconForGroup:setMoveActionFinishCallback("onPageChanged")
    self.m_nodeTopCon = GetElement(self.m_root, "conTop_SceneCommunityWar", WZUIContainer) 
    --获取服务器日期、时间
    self.m_ReceiveTimeType = 0 
    self:_createLoading()
    ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime( )
end

--@brief    初始化界面
function SceneCommunityWar:_initWnd()
    -- body
    self.m_nSectionIndex = self:getCurSection()
    self.m_nBottomIndex = self.m_nSectionIndex
    if self.m_nBottomIndex > 4 then self.m_nBottomIndex = 4 end
    self.m_nLeftSeconds, self.m_nLeftTimeIndex = self:_getLastTime()
    if self.m_nSectionIndex == 1 or self.m_nSectionIndex == 2 then
        self:_loadRankList(self.m_nSectionIndex)
    elseif self.m_nSectionIndex == 3  or self.m_nSectionIndex == 4 or self.m_nSectionIndex > 4 then
        self:_loadGroupData()
    end

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
    WndChat:addChatWindowToCurScene()

    --延时显示成就特效
    ShowDelayAchie()
end

--@brief    触摸开始回调
function SceneCommunityWar:onTouchBegan(element, pt)
    -- body
    if WndTips.m_root ~= nil and not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end

    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end
end

--@brief    关闭公会战按钮回调
function SceneCommunityWar:onTempClose()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1])
    else
        local tempScene = SceneCity:createElement()
        replaceScene(tempScene)
    end
end


--@brief    点击历届、奖励、目标按钮回调
function SceneCommunityWar:onTab(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 1 then   --历届
        WndCompeteHistory:showWnd()
    elseif nTag == 2 then   --奖励
        WndCompeteGift:showWnd()
    elseif nTag == 3 then   --目标
        WndCompeteTask:showWnd()
    end
end

--@brief    点击出线按钮回调
function SceneCommunityWar:onTabProgress1(element)
    -- body
    if self.m_nBottomIndex == 1 then return end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    --还没到该阶段
    if self.m_nSectionIndex < 1 then 
        MsgBoxManager:showTipBox(LocalStrings.COMMYNITY_COMPETE_TEXT39)
        return 
    end

    self.m_nBottomIndex = 1 
    self:_loadRankList(self.m_nBottomIndex)
end

--@brief    点击入围按钮回调
function SceneCommunityWar:onTabProgress2(element)
    -- body
    if self.m_nBottomIndex == 2 then return end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    --还没到该阶段
    if self.m_nSectionIndex < 2 then 
        MsgBoxManager:showTipBox(LocalStrings.COMMYNITY_COMPETE_TEXT39)
        return 
    end
    self.m_nBottomIndex = 2 
    self:_loadRankList(self.m_nBottomIndex)
end

--@brief    点击小组按钮回调
function SceneCommunityWar:onTabProgress3(element)
    -- body
    if self.m_nBottomIndex == 3 then return end
    --还没到该阶段
    if self.m_nSectionIndex < 3 then 
        MsgBoxManager:showTipBox(LocalStrings.COMMYNITY_COMPETE_TEXT39)
        return 
    end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_nBottomIndex = 3 

    self:_loadGroupData()
end

--@brief    点击决赛按钮回调
function SceneCommunityWar:onTabProgress4(element)
    -- body
    if self.m_nBottomIndex == 4 then return end
    --还没到该阶段
    if self.m_nSectionIndex < 4 then 
        MsgBoxManager:showTipBox(LocalStrings.COMMYNITY_COMPETE_TEXT39)
        return 
    end

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    self.m_nBottomIndex = 4 

    self:_loadGroupData()
end

--@brief    点击创建房间按钮回调
function SceneCommunityWar:onCreateRoom(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local nState = self:_cantEnterRoomAtt()
    if nState == 99 then
        WZLog("SceneCommunityWar:onCreateRoom")
        if self.m_nSectionIndex == 1 or self.m_nSectionIndex == 2 then
            --出线和入围房间
            self:_createLoading()
            local num = math.random(1,5)
            local roomName = LocalStrings.ROOM_NAME_RANDOM[num]
            local battleChannel = 1 --赛程
            if self.m_nSectionIndex == 2 then
                battleChannel = 2
            end
            ProtocolProcessorSceneArena:send_ROOM_CreateRoom(roomName, 1, self.personCnt, "-1", self.matchMode,8,battleChannel)--32出线，33入围
            return 
        elseif self.m_nSectionIndex == 3 or self.m_nSectionIndex == 4 then 
            --小组和决赛房间
            SceneCommunityKnockout:showScene()
        end
    else
        MsgBoxManager:showTipBox(self.m_tEnterRoomAtt[nState + 1])
        return 
    end
end

--@brief    加载所有分组
function SceneCommunityWar:loadAllGroup()
    -- body
    if self.m_root == nil then return end 

    local pgconForGroup = GetElement(self.m_root, "pgconForGroup_SceneCommunityWar", WZUIPageContainer)
    pgconForGroup:setVisible(true)
    pgconForGroup:removeAll()

    for i = 1, 4 do
        local celElement, tNewObj = CellGuildWarGroup:createElement()
        if celElement and tNewObj then
            tNewObj:setGroupIndex(i)
            tNewObj:setData(self.m_tGroupData[i])
            WZLog("SceneCommunityWar:loadAllGroup", i)
            pgconForGroup:setPageElement(i - 1, celElement)
        end
    end
    --把我所在的分组设置为默认显示的页
    pgconForGroup:setDefaultCenterPage(self.m_nGroupSelIndex - 1)
    self:_updatePageButton(self.m_nGroupSelIndex)

    self:_createGroupVSList()
end

--@brief    显示决赛界面
-- 比赛名次（1为32强,2为16强，3为8强，4为4强，5为 4强进2强失败，6为2强，7为 第四名,8为季军，9为亚军，10为冠军）
function SceneCommunityWar:loadGroupFinal()
    -- body
    self.m_tFinalData = {}
    for i = 1, #self.m_tGroupData do
        for j = 1, #self.m_tGroupData[i] do
            if self.m_tGroupData[i][j].guildResult > 3 then
                table.insert(self.m_tFinalData, self.m_tGroupData[i][j])
                break 
            end
        end
    end

    local conForGroup = GetElement(self.m_root, "conForGroup_SceneCommunityWar", WZUIContainer)
    local celElement, tNewObj = CellGuildWarFinal:createElement()
    if celElement and tNewObj then
        tNewObj:setData(self.m_tFinalData)
        celElement:setTag(444)
        conForGroup:addChild(celElement)
    end

    self:_createGroupVSList()
end

--@brief    翻页时被调用的函数
--@param    nIndex:当前序号
function SceneCommunityWar:onPageChanged(nIndex)
    WZLog("SceneCommunityWar:onPageChanged ")
    if nIndex == nil then
        local pgconForGroup = GetElement(self.m_root, "pgconForGroup_SceneCommunityWar", WZUIPageContainer)
        nIndex = pgconForGroup:getCurrentPageIndex()
    end
    if self.m_nGroupSelIndex - 1 == nIndex then
        return
    end
    self:_setCurrentPageIndex(nIndex + 1)
end

--@brief    向下翻页
function SceneCommunityWar:onLastPage(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nGroupSelIndex > 1 then
        self:_setCurrentPageIndex(self.m_nGroupSelIndex - 1)
    end
end

--@brief    向上翻页
function SceneCommunityWar:onNextPage(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nGroupSelIndex < 4 then
        self:_setCurrentPageIndex(self.m_nGroupSelIndex + 1)
    end
end

--@brief    点击弹公会信息框回调
function SceneCommunityWar:onCheckCommunityInfo(guildId)
    -- body
    WZLog("SceneCommunityWar:onCheckCommunityInfo", guildId)
    if guildId == -1 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_COMPETE_TEXT15)
        return 
    end
    self:_createLoading()
    ProtocolProcessorSceneCommunity:send_GUILD_GetGuild(guildId, 1)
end

--@brief    点击查看按钮回调
--@param    tData : 比赛双方数据
--@param    nRaceMark : 比赛标记：1~6（32-16；16-8；8-4；4-2；季军；冠军）
function SceneCommunityWar:onClickCheck(tData, nRaceMark)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local guildId
    if tData[1] then
        guildId = tData[1].guildId
    else
        guildId = tData[2].guildId
    end
    WZLog("SceneCommunityWar:onClickCheck")
    WndGuildGroupTeam:showInterface(guildId, nRaceMark)
end

--@brief    点击比赛回顾按钮回调
function SceneCommunityWar:onCheckRecord(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nBottomIndex == 3 then
        WndVSRecord:showInterface(self.m_tGroupData, self.m_nGroupSelIndex, 1)
    elseif self.m_nBottomIndex == 4 then
        WndVSRecord:showInterface(self.m_tFinalData, nil, 2)
    end
end

--@brief    目标按钮红点
function SceneCommunityWar:updateTargetBtnRedDot()
    -- body
    if self.m_root == nil then return end

    local imgTargetRedDot = GetElement(self.m_root, "imgTargetRedDot_SceneCommunityWar", WZUIImage)
    if imgTargetRedDot then
        imgTargetRedDot:setVisible(GlobalGame.g_bIsGuildWarHaveRedDot)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    加载出线和入围榜单
function SceneCommunityWar:_loadRankList(nRankType)
    -- body
    if self.m_tRankList == nil then
        self.m_tRankList = {}
    end
    if self.m_tRankList[nRankType] == nil then 
        self:_createLoading()
        ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarRank(nRankType)
    else
        self:_createRankList(self.m_tRankList[nRankType])
    end
end

--@brief    加载小组和决赛数据
function SceneCommunityWar:_loadGroupData()
    -- body
    self:showWarProgress()
    --测试数据
--    SceneCommunityWar:setGroupData({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,1147,30,31,32}, {"guildname1","guildname2","guildname3","guildname4","guildname5","guildname6","guildname7","guildname8","guildname9","guildname10","guildname11","guildname12","guildname13","guildname14","guildname15","guildname16","guildname17","guildname18","guildname19","guildname20","guildname21","guildname22","guildname23","guildname24","guildname25","guildname26","guildname27","guildname28","guildname29","guildname30","guildname31","guildname32"}, {1,7,1,2, 3,1,3,1, 1,2,2,1, 2,1,1,9, 1,3,2,1, 2,1,1,3, 1,2,8,1, 10,1,1,2})
    self:_createLoading()
    ProtocolProcessorCommunityWar:send_GUILDWAR_GuildFightInfo()
end

--@brief    创建出线或入围榜单
function SceneCommunityWar:_createRankList(tRankList)
    -- body
    --如果为空，则发送协议获取列表
    if tRankList == nil then
        return 
    end
    self:showWarProgress()
    WZLog("SceneCommunityWar:_createRankList", #tRankList)
    local tbconForRank = GetElement(self.m_root, "tbconForRank_SceneCommunityWar", WZUITableContainer)
    tbconForRank:cleanTable()
    local conLeftRank = GetElement(self.m_root, "conLeftRank_SceneCommunityWar", WZUIContainer)
    if #tRankList == 0 then
        ShowPanelNullTip(conLeftRank)
        return 
    end
    removeShowPanelNullTip(conLeftRank)

    --创建列表
    for i = 1, #tRankList do
        local celElement, tNewObj = CellGuildRankList:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setData(tRankList[i], self.m_nBottomIndex)
            tNewObj:setCallBackFunc(SceneCommunityWar, self.onCheckCommunityInfo)
            tbconForRank:setCellElement(celElement)
        end
    end
end

--@brief    赛事对战列表
-- 比赛名次（1为32强,2为16强，3为8强，4为4强，5为 4强进2强失败，6为2强，7为 第四名,8为季军，9为亚军，10为冠军）
function SceneCommunityWar:_createGroupVSList()
    -- body
    local tbconForVSList = GetElement(self.m_root, "tbconForVSList_SceneCommunityWar", WZUITableContainer)
    tbconForVSList:cleanTable()
    local conRightGroup = GetElement(self.m_root, "conRightGroup_SceneCommunityWar", WZUIContainer)
    --如果已经过了小组赛或决赛，再点击小组或决赛，右框显示 "暂无数据"
    if (self.m_nSectionIndex > 3 and self.m_nBottomIndex == 3) or (self.m_nSectionIndex > 4 and self.m_nBottomIndex == 4) then
        ShowPanelNullTip(conRightGroup)
        return 
    end
    removeShowPanelNullTip(conRightGroup)
    --有赛程，则显示赛程列表
    local tGroupData = self.m_tGroupData[self.m_nGroupSelIndex]
    WZLog("SceneCommunityWar:_createGroupVSList", Serialize(tGroupData))
    local nCurDay = self:getCurDay(self.m_sCommunityTime)
    if self.m_nSectionIndex == 3 then
        if nCurDay == 15 then  --15号
            local nTag = 0 
            for i = 1, #tGroupData, 2 do
                local celElement, tNewObj = CellGuildWarVSList:createElement()
                if celElement and tNewObj then
                    tNewObj:setData(tGroupData[i], tGroupData[i + 1], self.m_nGroupSelIndex, self.m_nGroupSelIndex)
                    tNewObj:setCallBackFunc(SceneCommunityWar, self.onCheckCommunityInfo, self.onClickCheck)
                    celElement:setTag(nTag)
                    tbconForVSList:setCellElement(celElement)

                    nTag = nTag + 1
                end
            end
        elseif nCurDay == 16 then     --16号
            local tTempData = {}
            --前4个公会中晋级的两个
            for i = 1, #tGroupData / 2 do
                if #tTempData < 2 then
                    if tGroupData[i].guildId ~= -1 and tGroupData[i].guildResult > 1 then
                        table.insert(tTempData, tGroupData[i])
                    elseif tGroupData[i].guildId == -1 then
                        table.insert(tTempData, tGroupData[i])
                    end
                else
                    break
                end
            end

            local celElement, tNewObj = CellGuildWarVSList:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], self.m_nGroupSelIndex, self.m_nGroupSelIndex)
                tNewObj:setCallBackFunc(SceneCommunityWar, self.onCheckCommunityInfo, self.onClickCheck)
                celElement:setTag(0)
                tbconForVSList:setCellElement(celElement)
            end
            --后4个公会中晋级的两个
            tTempData = {}
            for i = 5, #tGroupData do
                if #tTempData < 2 then
                    if tGroupData[i].guildId ~= -1 and tGroupData[i].guildResult > 1 then
                        table.insert(tTempData, tGroupData[i])
                    elseif tGroupData[i].guildId == -1 then
                        table.insert(tTempData, tGroupData[i])
                    end
                else
                    break
                end
            end
            celElement, tNewObj = CellGuildWarVSList:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], self.m_nGroupSelIndex, self.m_nGroupSelIndex)
                tNewObj:setCallBackFunc(SceneCommunityWar, self.onCheckCommunityInfo, self.onClickCheck)
                celElement:setTag(1)
                tbconForVSList:setCellElement(celElement)
            end
        elseif nCurDay == 17 then     --17号
            local tTempData = {}
            --前4个公会中晋级的一个
            for i = 1, #tGroupData / 2 do
                if #tTempData == 0 then
                    if tGroupData[i].guildId ~= -1 and tGroupData[i].guildResult > 2 then
                        table.insert(tTempData, tGroupData[i])
                    elseif tGroupData[i].guildId == -1 then
                        table.insert(tTempData, tGroupData[i])
                    end
                else
                    break
                end
            end
            --后4个公会中晋级的一个
            for i = 5, #tGroupData do
                if #tTempData == 1 then
                    if tGroupData[i].guildId ~= -1 and tGroupData[i].guildResult > 2 then
                        table.insert(tTempData, tGroupData[i])
                    elseif tGroupData[i].guildId == -1 then
                        table.insert(tTempData, tGroupData[i])
                    end
                else
                    break
                end
            end
            local celElement, tNewObj = CellGuildWarVSList:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], self.m_nGroupSelIndex, self.m_nGroupSelIndex)
                tNewObj:setCallBackFunc(SceneCommunityWar, self.onCheckCommunityInfo, self.onClickCheck)
                celElement:setTag(0)
                tbconForVSList:setCellElement(celElement)
            end
        end
    elseif self.m_nSectionIndex == 4 then
        local tFinalData = self.m_tFinalData
        if nCurDay == 18 then     --18号
            local nTag = 0 
            for i = 1, #tFinalData, 2 do
                local celElement, tNewObj = CellGuildWarVSList:createElement()
                if celElement and tNewObj then
                    tNewObj:setData(tFinalData[i], tFinalData[i + 1], i, i + 1)
                    tNewObj:setCallBackFunc(SceneCommunityWar, self.onCheckCommunityInfo, self.onClickCheck)
                    celElement:setTag(nTag)
                    tbconForVSList:setCellElement(celElement)

                    nTag = nTag + 1
                end
            end
        elseif nCurDay == 19 then     --19号
            local tTempData = {}
            local tGroupIndex = {}
            --前4个公会中晋级的一个
            for i = 1, #tFinalData do
                if #tTempData < 2 then
                    if tFinalData[i].guildResult == 5 or tFinalData[i].guildResult == 7 or tFinalData[i].guildResult == 8 then
                        table.insert(tTempData, tFinalData[i])
                        table.insert(tGroupIndex, i)
                    end
                else
                    break
                end
            end
            local celElement, tNewObj = CellGuildWarVSList:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], tGroupIndex[1], tGroupIndex[2])
                tNewObj:setCallBackFunc(SceneCommunityWar, self.onCheckCommunityInfo, self.onClickCheck)
                celElement:setTag(0)
                tbconForVSList:setCellElement(celElement)
            end
        elseif nCurDay == 20 then     --20号
            local tTempData = {}
            local tGroupIndex = {}
            --前4个公会中晋级的一个
            for i = 1, #tFinalData do
                if #tTempData < 2 then
                    if tFinalData[i].guildResult == 6 or tFinalData[i].guildResult == 9 or tFinalData[i].guildResult == 10 then
                        table.insert(tTempData, tFinalData[i])
                        table.insert(tGroupIndex, i)
                    end
                else
                    break
                end
            end
            local celElement, tNewObj = CellGuildWarVSList:createElement()
            if celElement and tNewObj then
                tNewObj:setData(tTempData[1], tTempData[2], tGroupIndex[1], tGroupIndex[2])
                tNewObj:setCallBackFunc(SceneCommunityWar, self.onCheckCommunityInfo, self.onClickCheck)
                celElement:setTag(0)
                tbconForVSList:setCellElement(celElement)
            end
        end
    end

    tbconForVSList:getMoveElement():setPositionY(tbconForVSList:getMinPosition().y)
end

--@brief    设置赛程底部阶段高亮
function SceneCommunityWar:_setBottomMenuSel()
    -- body
    for i = 1, 4 do
        local imgCheckSel = GetElement(self.m_root, string.format("imgCheckSel%d_SceneCommunityWar", i), WZUIImage)
        if imgCheckSel then
            if self.m_nBottomIndex == i then
                imgCheckSel:setVisible(true)
            else
                imgCheckSel:setVisible(false)
            end
        end
    end
end

--@brief    设置静态文本
function SceneCommunityWar:_setStaticText()
    -- body
    local txtCheckTime1 = GetElement(self.m_root, "txtCheckTime1_SceneCommunityWar", WZUILabelTTF)
    local txtCheckTime2 = GetElement(self.m_root, "txtCheckTime2_SceneCommunityWar", WZUILabelTTF)
    local txtCheckTime3 = GetElement(self.m_root, "txtCheckTime3_SceneCommunityWar", WZUILabelTTF)
    local txtCheckTime4 = GetElement(self.m_root, "txtCheckTime4_SceneCommunityWar", WZUILabelTTF)

    txtCheckTime1:setText(string.format("(" .. LocalStrings.COMMUNITYWAR_TEXT24 .. ")", "1-7"))
    txtCheckTime2:setText(string.format("(" .. LocalStrings.COMMUNITYWAR_TEXT24 .. ")", "8-14"))
    txtCheckTime3:setText(string.format("(" .. LocalStrings.COMMUNITYWAR_TEXT24 .. ")", "15-17"))
    txtCheckTime4:setText(string.format("(" .. LocalStrings.COMMUNITYWAR_TEXT24 .. ")", "18-20"))
end

--@brief    根据标记显示当前赛程进度
function SceneCommunityWar:showWarProgress()
    -- body
    local prgStep = GetElement(self.m_root, "prgStep_SceneCommunityWar", WZUIProgress)
    if self.m_nSectionIndex == 1 then
        prgStep:setPercentage(0)
    elseif self.m_nSectionIndex == 2 then
        prgStep:setPercentage(35)
    elseif self.m_nSectionIndex == 3 then
        prgStep:setPercentage(70)
    elseif self.m_nSectionIndex >= 4 then
        prgStep:setPercentage(100)
    end
    --设置选中的赛程高亮
    self:_setBottomMenuSel()
    self:_setDynamicText()
end

--@brief    设置动态的文字
function SceneCommunityWar:_setDynamicText()
    -- body
    local conLeftGroup = GetElement(self.m_root, "conLeftGroup_SceneCommunityWar", WZUIContainer)
    local conRightGroup = GetElement(self.m_root, "conRightGroup_SceneCommunityWar", WZUIContainer)
    local conLeftRank = GetElement(self.m_root, "conLeftRank_SceneCommunityWar", WZUIContainer)
    local conRightRule = GetElement(self.m_root, "conRightRule_SceneCommunityWar", WZUIContainer)
    local conGroupMark = GetElement(self.m_root, "conGroupMark_SceneCommunityWar", WZUIContainer)
    local pgconForGroup = GetElement(self.m_root, "pgconForGroup_SceneCommunityWar", WZUIPageContainer)
    conLeftGroup:setVisible(false)
    conRightGroup:setVisible(false)
    conLeftRank:setVisible(false)
    conRightRule:setVisible(false)
    conGroupMark:setVisible(false)
    pgconForGroup:setVisible(false)

    local conForGroup = GetElement(self.m_root, "conForGroup_SceneCommunityWar", WZUIContainer)
    if conForGroup:getChildByTag(444) then
        conForGroup:removeChildByTag(444, true)
    end

    local txtRankTitle = GetElement(self.m_root, "txtRankTitle_SceneCommunityWar", WZUILabelTTF)
    local txtRuleTitle = GetElement(self.m_root, "txtRuleTitle_SceneCommunityWar", WZUILabelTTF)
    local ftxtGroupTitle = GetElement(self.m_root, "ftxtGroupTitle_SceneCommunityWar", WZUIFreeTextBox)
    local ftxtMyRank = GetElement(self.m_root, "ftxtMyRank_SceneCommunityWar", WZUIFreeTextBox)
    local txtGuildNameAndSeverName = GetElement(self.m_root, "txtGuildNameAndSeverName_SceneCommunityWar", WZUILabelTTF)
    if self.m_nBottomIndex == 1 then
        conLeftRank:setVisible(true)
        conRightRule:setVisible(true)
        txtRankTitle:setText(LocalStrings.COMMUNITYWAR_TEXT6)
        txtRuleTitle:setText(LocalStrings.COMMUNITYWAR_TEXT8)
        txtGuildNameAndSeverName:setText(LocalStrings.COMMUNITYWAR_TEXT4)

        --出线赛规则
        self:_upMoveContainerLayer(LocalStrings.COMMUNITYWAR_TEXT12)
        --出线榜我的公会排名
        local sNoInListFormat = [[<T C="138,122,106" S="20" P="1">%s:</T><T C="138,122,106" S="20" P="1">%s</T>]]
        if CacheCenter:getPlayerInfo().guildName == nil or CacheCenter:getPlayerInfo().guildName == "" then
            ftxtMyRank:setShowText(string.format(sNoInListFormat, LocalStrings.MY_COMMUNITY, LocalStrings.SHOP_NOGONGHUI))
        else
            if self.m_nMyOutRaceRank > 0 then
                ftxtMyRank:setShowText(string.format(LocalStrings.COMMUNITYWAR_TEXT14, self.m_nMyOutRaceRank))
            else
                ftxtMyRank:setShowText(string.format(sNoInListFormat, LocalStrings.MY_COMMUNITY, LocalStrings.NOT_IN_RANKLIST))
            end
        end
    elseif self.m_nBottomIndex == 2 then
        conLeftRank:setVisible(true)
        conRightRule:setVisible(true)
        txtRankTitle:setText(LocalStrings.COMMUNITYWAR_TEXT7)
        txtRuleTitle:setText(LocalStrings.COMMUNITYWAR_TEXT9)
        txtGuildNameAndSeverName:setText(LocalStrings.COMMUNITYWAR_TEXT31)
        --入围赛规则
        self:_upMoveContainerLayer(LocalStrings.COMMUNITYWAR_TEXT13)
        --出线榜我的公会排名
        local sNoInListFormat = [[<T C="138,122,106" S="20" P="1">%s:</T><T C="138,122,106" S="20" P="1">%s</T>]]
        --入围榜我的公会排名
        if CacheCenter:getPlayerInfo().guildName == nil or CacheCenter:getPlayerInfo().guildName == "" then
            ftxtMyRank:setShowText(string.format(sNoInListFormat, LocalStrings.MY_COMMUNITY, LocalStrings.SHOP_NOGONGHUI))
        else
            if self.m_nMyInRaceRank > 0 then
                ftxtMyRank:setShowText(string.format(LocalStrings.COMMUNITYWAR_TEXT14, self.m_nMyInRaceRank))
            else
                ftxtMyRank:setShowText(string.format(sNoInListFormat, LocalStrings.MY_COMMUNITY, LocalStrings.NOT_IN_RANKLIST))
            end
        end
    elseif self.m_nBottomIndex == 3 then
        conLeftGroup:setVisible(true)
        conRightGroup:setVisible(true)
        pgconForGroup:setVisible(true)
        conGroupMark:setVisible(true)
        if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1044 then
            ftxtGroupTitle:setShowText(string.format(LocalStrings.COMMUNITYWAR_TEXT10,"21:00" .. "-" .. "21:30" ))
        else
            ftxtGroupTitle:setShowText(string.format(LocalStrings.COMMUNITYWAR_TEXT10,self.m_sGroupReadyTime .. "-" .. self.m_sGroupEndTime ))
        end
    elseif self.m_nBottomIndex == 4 then
        conLeftGroup:setVisible(true)
        conRightGroup:setVisible(true)
        if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1044 then
            ftxtGroupTitle:setShowText(string.format(LocalStrings.COMMUNITYWAR_TEXT11, "21:00" .. "-" .. "21:30" ))
        else
            ftxtGroupTitle:setShowText(string.format(LocalStrings.COMMUNITYWAR_TEXT11, self.m_sFinalReadyTime .. "-" .. self.m_sFinalEndTime))
        end
    end
    --倒计时
    self:_showLeftTime()
    self.m_root:enableSchedule("_caculateTime", 0.2)
    --房间按钮
    self:_setRoomBtnState()
end

--@brief    更新滚动容器内部布局函数
--@param    txtContent: 要显示的内容
function SceneCommunityWar:_upMoveContainerLayer(txtContent)
    WZLog("SceneCommunityWar:_upMoveContainerLayer()")
    if self.m_root == nil then
        return
    end
    --获取规则说明内容文本的大小
    local txtRuleDetail = GetElement(self.m_root, "ftxtRuleDetail_SceneCommunityWar", WZUIFreeTextBox)
    txtRuleDetail:setShowText(txtContent)
    local txtSize = txtRuleDetail:getContentSize() 
    txtRuleDetail:setPositionY(txtSize.height)

    WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
    
    local rollconRule = self.m_root:getChildElement("rollconRule_SceneCommunityWar")
    if rollconRule == nil then 
        return
    end
    rollconRule = WZUIMoveContainer:luaTo(rollconRule)
    local rollSize = rollconRule:getContentSize()
    --更改滚动容器Element的大小
    local moveElement = rollconRule:getMoveElement()
    local size = moveElement:getRelativeSize()
    moveElement:setRelativeSize( GlobalMethod:CCSize(1 , txtSize.height / (rollSize.height - 5) ) )
    rollconRule:UpdateInsidePosition()  --更新滚动容器内部布局
    moveElement:setPositionY(rollconRule:getMinPosition().y)
    WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

--@brief    剩余时间
function SceneCommunityWar:_showLeftTime()
    -- body
    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_SceneCommunityWar", WZUIFreeTextBox)
    local sTimeFormat = [[<T C="195,171,148" S="20" P="1">%s</T><T C="255,89,74" S="20" P="1"> %s</T>]]
    local sTimeFormat1 = [[<T C="255,89,74" S="20" P="1">%s</T><T C="195,171,148" S="20" P="1"> %s</T>]]
    if ftxtLeftTime then
        local nHour = math.floor(self.m_nLeftSeconds / 3600)
        local nMinute = math.floor((self.m_nLeftSeconds - nHour * 3600) / 60)
        local nSecond = self.m_nLeftSeconds - nHour * 3600 - nMinute * 60
        local sLeftTime = string.format("%d:%02d:%02d", nHour, nMinute, nSecond)
        if self.m_nLeftTimeIndex == 1 then
            ftxtLeftTime:setShowText(string.format(sTimeFormat1, sLeftTime, LocalStrings.COMMUNITYWAR_TEXT16))
        elseif self.m_nLeftTimeIndex == 2 then
            ftxtLeftTime:setShowText(string.format(sTimeFormat, LocalStrings.SHOP_GOODSSHEGN, sLeftTime))
        elseif self.m_nLeftTimeIndex == 3 then
            ftxtLeftTime:setVisible(false)
        elseif self.m_nLeftTimeIndex == 4 then 
            ftxtLeftTime:setShowText(string.format(sTimeFormat1, "", LocalStrings.GUILDWAR_NEWTEXT1))
        end
    end
end

--@brief    剩余时间倒计时
function SceneCommunityWar:_caculateTime(element, delta)
    -- body
    self.m_nTempSecond = self.m_nTempSecond + delta
    if self.m_nTempSecond >= 1 then
        if self.m_nLeftTimeIndex == 1 then
            if self.m_nLeftSeconds > 0 then 
                self.m_nLeftSeconds = self.m_nLeftSeconds - 1 
                self.m_nTempSecond = self.m_nTempSecond - 1
                self:_showLeftTime()
            else
                self.m_nLeftSeconds, self.m_nLeftTimeIndex = self:_getLastTime()
                WZLog("SceneCommunityWar:_caculateTime 0000", self.m_nLeftSeconds, self.m_nLeftTimeIndex)
                self:_showLeftTime()
            end
        elseif self.m_nLeftTimeIndex == 2 then
            if self.m_nLeftSeconds > 0 then
                self.m_nLeftSeconds = self.m_nLeftSeconds - 1 
                self.m_nTempSecond = self.m_nTempSecond - 1
                self:_showLeftTime()
            else
                self.m_root:disableSchedule()
                --获取服务器日期、时间
                self:_createLoading()
                ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime()
                -- self.m_nLeftSeconds, self.m_nLeftTimeIndex = self:_getLastTime()
                -- WZLog("SceneCommunityWar:_caculateTime", self.m_nLeftSeconds, self.m_nLeftTimeIndex)
                -- self:_showLeftTime()
            end
        elseif self.m_nLeftTimeIndex == 3 or self.m_nLeftTimeIndex == 4 then
            self.m_root:disableSchedule()
        end
    end
end

--@brief    计算当天凌晨到现在的时间
function SceneCommunityWar:_caculateDateTime(element, delta)
    --body
    self.m_nCurDaySeconds = self.m_nCurDaySeconds + 1
    if self.m_nCurDaySeconds >= 24 * 3600 then 
        self.m_nCurDaySeconds = 0 
        --获取服务器日期、时间
        self.m_ReceiveTimeType = 1
        self.m_nodeTopCon:disableSchedule()
        self:_createLoading()
        ProtocolProcessorCommunityWar:send_GUILDWAR_GuildWarTime()
    end
end

--@brief    添加顶部信息
function SceneCommunityWar:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/community/common_icon_ghzwz.png",SceneCommunityWar,SceneCommunityWar.onTempClose,true,1,true,"SceneCommunityWar")
    self.m_root:addChild(celElement, 0, 666)
end

--@brief    设置房间按钮的隐藏和显示
function SceneCommunityWar:_setRoomBtnState()
    -- body
    local btnRoom = GetElement(self.m_root, "btnRoom_SceneCommunityWar", WZUIButton)
    local txtCreateRoom = GetElement(self.m_root, "txtCreateRoom_SceneCommunityWar", WZUILabelTTF)
    local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_SceneCommunityWar", WZUIFreeTextBox)
    btnRoom:setVisible(false)
    ftxtLeftTime:setVisible(false)

    local nCurTime = SystemTime:getServerTime()
    local bIsBtnVisible = false
    local bIsFtxtVisible = false
    if self.m_nSectionIndex == self.m_nBottomIndex then
        btnRoom:setVisible(true)
        ftxtLeftTime:setVisible(true)
    end

    if self.m_nBottomIndex == 1 then
        txtCreateRoom:setText(LocalStrings.CREATE_ROOM)
    elseif self.m_nBottomIndex == 2 then
        txtCreateRoom:setText(LocalStrings.CREATE_ROOM)
    elseif self.m_nBottomIndex == 3 then
        txtCreateRoom:setText(LocalStrings.COMMUNITY_COMPETE_TEXT13)
    elseif self.m_nBottomIndex == 4 then
        txtCreateRoom:setText(LocalStrings.COMMUNITY_COMPETE_TEXT13)
    end
end

--@brief    设置当前页数
--@param    nIndex:页数
function SceneCommunityWar:_setCurrentPageIndex(nIndex)
    WZLog("SceneCommunityWar:_setCurrentPageIndex = ",nIndex)
    if self.m_root == nil then
        return
    end

    self.m_nGroupSelIndex = nIndex 
    local pgconForGroup = GetElement(self.m_root, "pgconForGroup_SceneCommunityWar", WZUIPageContainer)
    pgconForGroup:setDefaultCenterPage(self.m_nGroupSelIndex - 1)
    self:_createGroupVSList()
    self:_updatePageButton(self.m_nGroupSelIndex) --更新翻页按钮
end

--@brief    更新翻页按钮
--@param    nCurPageIndex:当前页数
function SceneCommunityWar:_updatePageButton(nCurPageIndex)
    WZLog("SceneCommunityWar:_updatePageButton =",nCurPageIndex)
    local btnNext = GetElement(self.m_root, "btnNext_SceneCommunityWar", WZUIButton)
    local btnPrevious = GetElement(self.m_root, "btnLast_SceneCommunityWar", WZUIButton)
    
    if nCurPageIndex == 1 then
        btnNext:setVisible(true)
        btnPrevious:setVisible(false)
    elseif nCurPageIndex == 4 then
        btnNext:setVisible(false)
        btnPrevious:setVisible(true)
    else
        btnNext:setVisible(true)
        btnPrevious:setVisible(true)
    end
    local sGroupMark 
    if nCurPageIndex == 1 then
        sGroupMark = "A"
    elseif nCurPageIndex == 2 then
        sGroupMark = "B"
    elseif nCurPageIndex == 3 then
        sGroupMark = "C"
    elseif nCurPageIndex == 4 then
        sGroupMark = "D"
    end

    local txtGroupMark = GetElement(self.m_root, "txtGroupMark_SceneCommunityWar", WZUILabelTTF)
    if txtGroupMark then
        txtGroupMark:setText(sGroupMark .. LocalStrings.COMMUNITY_COMPETE_TEXT22)
        if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
            txtGroupMark:setText(LocalStrings.COMMUNITY_COMPETE_TEXT22.." "..sGroupMark)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function SceneCommunityWar:_adaptLanguage_en()
    GetElement(self.m_root,"txtCreateRoom_SceneCommunityWar",WZUILabelTTF):setScale(0.7) 
end

function SceneCommunityWar:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtLeftGroup_SceneCommunityWar",WZUILabelTTF):setFontSize(11)
end

function SceneCommunityWar:_adaptLanguage_pt()
    local txtCreateRoom = GetElement(self.m_root,"txtCreateRoom_SceneCommunityWar",WZUILabelTTF)
    txtCreateRoom:setScale(0.7)
    txtCreateRoom:setDimensions(GlobalMethod:CCSize(140))
end

function SceneCommunityWar:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtLeftGroup_SceneCommunityWar",WZUILabelTTF):setFontSize(11)
end

function SceneCommunityWar:_adaptLanguage_es(  )
    local txtLeft = GetElement(self.m_root,"txtLeftGroup_SceneCommunityWar",WZUILabelTTF)
    txtLeft:setFontSize(11)
    txtLeft:setDimensions(GlobalMethod:CCSize(60,0))

    local txtCreateRoom = GetElement(self.m_root, "txtCreateRoom_SceneCommunityWar", WZUILabelTTF)
    txtCreateRoom:setDimensions(GlobalMethod:CCSize(130,0))
    txtCreateRoom:setScale(0.7)
    GetElement(self.m_root, "ftxtLeftTime_SceneCommunityWar", WZUIFreeTextBox):setScale(0.8)
end

function SceneCommunityWar:_adaptLanguage_tr(  )
    GetElement(self.m_root,"imgBtn1_SceneCommunityWar",WZUIImage):setScale(0.8)
    GetElement(self.m_root,"imgBtn2_SceneCommunityWar",WZUIImage):setScale(0.8)
    GetElement(self.m_root,"imgBtn3_SceneCommunityWar",WZUIImage):setScale(0.8)

    local txtLeft = GetElement(self.m_root,"txtLeftGroup_SceneCommunityWar",WZUILabelTTF)
    txtLeft:setScale(0.6)
    txtLeft:setDimensions(GlobalMethod:CCSize(100,0))

end
------------------------------------语言适配End---------------------------------------------