--CellLeagueReplayItem.lua
--@brief	CellLeagueReplayItem的UI模块
--@date		2016/06/15
--@author	Tianxiang_Xu
--@note		英雄联赛-回放列表项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueReplayItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueReplayItem:onExit(element)
	self:_unInit()
end

--@brief    点击查看按钮回调
function CellLeagueReplayItem:onClickCheck(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nIndex == 1 then
        --退出战队界面
        ProtocolProcessorWndLeague:send_HERO_OutHeroRoom()
        
        ProtocolProcessorGlobal:send_PLAYER_Watch(self.m_tData.id)
    else
        WndLeagueVSInfo:showInterface(self.m_tData.id, self.m_nIndex, self.m_tData.team1, self.m_tData.team2)
    end
end

--@brief    加载cell数据信息
function CellLeagueReplayItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellLeagueReplayItem")
    self.m_root:addChild(cellElement)

    self.m_bIsLoaded = true
    self:_update()
end

--@brief    点击左方队伍图标回调
function CellLeagueReplayItem:onClickLeftTeam(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], element, self.m_tData.id, self.m_tData.team1.teamId, 1)
    end
end

--@brief    点击右方队伍图标回调
function CellLeagueReplayItem:onClickRightTeam(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], element, self.m_tData.id, self.m_tData.team2.teamId, 2)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新界面信息
function CellLeagueReplayItem:_update()
    -- body
    self:_showVSTeamInfo()
    self:_showCheckNumAndState()
    self:_showVSResult()
end

--@brief    设置队伍信息
function CellLeagueReplayItem:_showVSTeamInfo()
    --body
    --左队图标
    local conLeftTeamIcon = GetElement(self.m_root, "conLeftTeamIcon", WZUIContainer)
    local celElement,tCell = CellDownloadImg:createElement()
    conLeftTeamIcon:addChild(celElement)

    SceneLeagueMain:addDownloadFileList(self.m_tData.team1.teamIcon, tCell, nil, 52)

    --左队的名字
    local txtLeftTeamName = GetElement(self.m_root, "txtLeftTeamName_CellLeagueReplayItem", WZUILabelTTF)
    txtLeftTeamName:setText(self.m_tData.team1.teamName)
    --左队的ID
    local txtLeftTeamID = GetElement(self.m_root, "txtLeftTeamID_CellLeagueReplayItem", WZUILabelTTF)
    txtLeftTeamID:setText(LocalStrings.LEAGUE_REPLAY_TEXT1 .. self.m_tData.team1.teamId)

    --右队图标
    local conRightTeamIcon = GetElement(self.m_root, "conRightTeamIcon", WZUIContainer)
    local celElementR,tCellR = CellDownloadImg:createElement()
    conRightTeamIcon:addChild(celElementR)

    SceneLeagueMain:addDownloadFileList(self.m_tData.team2.teamIcon, tCellR, nil, 52)
    --右队的名字
    local txtRightTeamName = GetElement(self.m_root, "txtRightTeamName_CellLeagueReplayItem", WZUILabelTTF)
    txtRightTeamName:setText(self.m_tData.team2.teamName)
    --右队的ID
    local txtRightTeamID = GetElement(self.m_root, "txtRightTeamID_CellLeagueReplayItem", WZUILabelTTF)
    txtRightTeamID:setText(LocalStrings.LEAGUE_REPLAY_TEXT1 .. self.m_tData.team2.teamId)
end

--@brief    设置观看人数和状态
function CellLeagueReplayItem:_showCheckNumAndState()
    --body
    --查看人数
    local txtCheckNum = GetElement(self.m_root, "txtCheckNum_CellLeagueReplayItem", WZUILabelTTF)
    txtCheckNum:setVisible(false)
    if self.m_nIndex == 1 then
        txtCheckNum:setVisible(true)
    end

    if self.m_tData.checkNum > 100000 then
        txtCheckNum:setText(math.floor(self.m_tData.checkNum/10000) .. LocalStrings.LEAGUE_REPLAY_TEXT3)
    else
        txtCheckNum:setText(self.m_tData.checkNum .. LocalStrings.LEAGUE_REPLAY_TEXT2)
    end
    --观看状态
    local txtHavedCheck = GetElement(self.m_root, "txtHavedCheck_CellLeagueReplayItem", WZUILabelTTF)
    local imgNew = GetElement(self.m_root, "imgNew_CellLeagueReplayItem", WZUIImage)
    local txtBtn = GetElement(self.m_root, "txtBtn_CellLeagueReplayItem", WZUILabelTTF)
    if self.m_nIndex == 1 then
        txtHavedCheck:setVisible(false)
        imgNew:setVisible(false)
        txtBtn:setText(LocalStrings.LEAGUE_REPLAY_TEXT15)
    else
        txtBtn:setText(LocalStrings.PETLOOK)
        if self.m_tData.state == -1 then
            txtHavedCheck:setVisible(false)
            imgNew:setVisible(true)
        else
            txtHavedCheck:setVisible(true)
            txtHavedCheck:setText(LocalStrings.LEAGUE_REPLAY_TEXT4)
            imgNew:setVisible(false)
        end
    end
end

--@brief    显示比赛结果和场数
function CellLeagueReplayItem:_showVSResult()
    -- body
    --第几场
    local txtMark = GetElement(self.m_root, "txtMark_CellLeagueReplayItem", WZUILabelTTF)
    txtMark:setText(self.m_tData.mark)
    local txtGang = GetElement(self.m_root, "txtGang_CellLeagueReplayItem", WZUILabelTTF)
    --左队结果
    local imgLeftResult = GetElement(self.m_root, "imgLeftResult_CellLeagueReplayItem", WZUIImage)
    --右队结果
    local imgRightResult = GetElement(self.m_root, "imgRightResult_CellLeagueReplayItem", WZUIImage)
    if self.m_nIndex == 1 then  --正在进行
        txtGang:setVisible(false)
        imgRightResult:setVisible(false)
        imgLeftResult:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        imgLeftResult:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        imgLeftResult:setFile("ui/hero/hero_icon_xvsdz.png")
    else
        if self.m_tData.team1.result == 0 then
            imgLeftResult:setFile("ui/hero/hero_icon_vsfu.png")
        else
            imgLeftResult:setFile("ui/hero/hero_icon_vssheng.png")
        end
        
        if self.m_tData.team2.result == 0 then
            imgRightResult:setFile("ui/hero/hero_icon_vsfu.png")
        else
            imgRightResult:setFile("ui/hero/hero_icon_vssheng.png")
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
