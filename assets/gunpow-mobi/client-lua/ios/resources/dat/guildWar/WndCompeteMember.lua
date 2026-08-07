--WndCompeteMember.lua
--@brief	WndCompeteMember的UI模块
--@date		2016/08/22
--@author	Tianxiang_Xu
--@note		公会战房间成员列表窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCompeteMember:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCompeteMember:onExit(element)
	self:_unInit()
end

--@brief    进入界面完成回调
function WndCompeteMember:onEnterTransitionDidFinish(element)
    -- body
    WindowManagerAni:createAppearAction(self.m_root, true, "finishCallBack", self)
end

--@brief    界面动画播完回调
function WndCompeteMember:finishCallBack()
    -- body
    self:_createMemberList()
end

--@brief    点击关闭按钮回调
function WndCompeteMember:onBackClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManagerAni:createDisappearAction(self.m_root, "closeCallBack", self)
end

--@brief    关闭界面动画完成回调
function WndCompeteMember:closeCallBack()
    -- body
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击列表cell回调
function WndCompeteMember:onClickCell(element, tData, tCell)
    -- body
    WZLog("WndCompeteMember:onClickCell")
    self.m_tClickCell = tCell
    WndTips:show(element,self.m_root,30,tData,GlobalMethod:ccp(320,30))
end

--@brief    触摸开始回调
function WndCompeteMember:onTouchBegan(element, pt)
    -- body
    if WndTips.m_root and not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end
end

--@brief    点击cell队伍按钮
--@param    nTag:点击的队伍号：1,2,3
--@param    id:点击的会员id
function WndCompeteMember:onClickTeamBtn(nTag, id, tCell)
    -- body
    local nOldTeamId = 0 
    --检测设置的队伍是否已经满人
    local bFull = self:_isTeamFull(nTag, id)
    if bFull then
        MsgBoxManager:showTipBox(LocalStrings.COMMYNITY_COMPETE_TEXT32)
        return 
    end

    
    for i = 1, #self.m_tMemberList do
        if self.m_tMemberList[i].id == id then
            nOldTeamId = self.m_tMemberList[i].teamId

            if self.m_tMemberList[i].teamId == nTag then
                --self:_createLoading()
                ProtocolProcessorCommunityWar:send_GUILDWAR_OutMember(id, nTag - 1)
            else
                --self:_createLoading()
                ProtocolProcessorCommunityWar:send_GUILDWAR_InstallMember(id, nTag - 1)
            end
            break
        end
    end
end

--@brief    点击邀请按钮回调
function WndCompeteMember:onClickInvite(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndFriendList:showInterface(9, WndCompeteMember, self.inviteCommunityMember)
end

--@brief    发送邀请协议函数
function WndCompeteMember:inviteCommunityMember(tData)
    -- body
    for i,v in ipairs(self.m_tMemberList) do
        if v == tData.id then
           MsgBoxManager:showTipBox(LocalStrings.BATTLETEAM_PLAYER_ALREADY_ROOM)
           return
        end
    end
    if tData==nil or tData.id == nil then
       return
    end

    --发送公会战邀请
    ProtocolProcessorCommunityWar:send_GUILDWAR_Invite(tData.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    创建列表
function WndCompeteMember:_createMemberList()
	if self.m_root == nil then return end
    -- body
    local conList = GetElement(self.m_root, "conList_WndCompeteMember", WZUIContainer)
    --房间成员数量
    self:_setStaticText()

    if self.m_tMemberList == nil or #self.m_tMemberList == 0 then
        ShowPanelNullTip( conList, LocalStrings.COMMUNITY_COMPETE_TEXT26)
        return 
    end

    if conList then
        removeShowPanelNullTip(conList)
    end

    local tbconList = GetElement(self.m_root, "tbconList_WndCompeteMember", WZUITableContainer)
    tbconList:cleanTable()
    WZLog("WndCompeteMember:_createMemberList", #self.m_tMemberList)
	local index = 1
    for i = 1, #self.m_tMemberList do
		if self.m_tMemberList[i].state == 2 or self.m_tMemberList[i].state == 4 then
        local element, tNewObj = CellCompeteMemberList:createElement()
        if element and tNewObj then
            tNewObj:setData(self.m_tMemberList[i])
            tNewObj:setCallBackFun(self, self.onClickCell, self.onClickTeamBtn)
            element:setTag(index - 1)
            tbconList:setCellElement(element)
			index = index + 1
        end
		end
    end

    local txtListNum = GetElement(self.m_root, "txtListNum_WndCompeteMember", WZUILabelTTF)
    txtListNum:setText(string.format(LocalStrings.COMMUNITY_COMPETE_TEXT28, index-1))

    --底部头像
    self:_createBottomHead()
end

--@brief    设置文本标签内容
function WndCompeteMember:_setStaticText()
    -- body
    --标题
    local txtWndTitleName = GetElement(self.m_root, "txtWndTitleName_WndCompeteMember", WZUILabelTTF)
    if txtWndTitleName then
        txtWndTitleName:setText(LocalStrings.COMMUNITY_COMPETE_TEXT27)
    end
end

--@brief    更新底部队伍成员头像
--@param    nTag:队伍号：1,2,3
--@param    nOldTeamId:旧队伍号
--@param    id:会员id
function WndCompeteMember:_updateBottomHead(nTag, nOldTeamId, id)
    -- body
    if nTag == nOldTeamId then      --取消参战
        local nConIndex = 1 
        for i = 1, #self.m_tTeamPlayerId[nOldTeamId] do
            if self.m_tTeamPlayerId[nOldTeamId][i] == id then
                nConIndex = i 
                self.m_tTeamPlayerId[nOldTeamId][i] = 0
                break
            end
        end
        --移除相应队伍当中该玩家的头像
        local conHead = GetElement(self.m_root, string.format("conHead%d_%d", nOldTeamId, nConIndex), WZUIContainer)
        conHead:removeAllChildrenWithCleanup(true)
    elseif nOldTeamId == 0 then     --新添加
        local nConIndex = 1 
        for i = 1, #self.m_tTeamPlayerId[nTag] do
            if self.m_tTeamPlayerId[nTag][i] == 0 then
                nConIndex = i 
                self.m_tTeamPlayerId[nTag][i] = id
                break
            end
        end
        --添加相应玩家的头像到队伍当中
        local conHead = GetElement(self.m_root, string.format("conHead%d_%d", nTag, nConIndex), WZUIContainer)
        local nDataIndex = self:_getDataById(id)
        if nDataIndex then
            local tData = self.m_tMemberList[nDataIndex]
            local element = CellHead:show(conHead,tData.headId,tData.faceId,tData.sex,nil,nil,tData.vipLevel, tData.headColor)
        end
    elseif nTag ~= nOldTeamId and nOldTeamId ~= 0 then  --切换队伍
        local nConIndex = 1 
        for i = 1, #self.m_tTeamPlayerId[nOldTeamId] do
            if self.m_tTeamPlayerId[nOldTeamId][i] == id then
                nConIndex = i 
                self.m_tTeamPlayerId[nOldTeamId][i] = 0
                break
            end
        end
        --移除相应队伍当中该玩家的头像
        local conHead = GetElement(self.m_root, string.format("conHead%d_%d", nOldTeamId, nConIndex), WZUIContainer)
        conHead:removeAllChildrenWithCleanup(true)

        nConIndex = 1 
        for i = 1, #self.m_tTeamPlayerId[nTag] do
            if self.m_tTeamPlayerId[nTag][i] == 0 then
                nConIndex = i 
                self.m_tTeamPlayerId[nTag][i] = id
                break
            end
        end
        --添加相应玩家的头像到队伍当中
        conHead = GetElement(self.m_root, string.format("conHead%d_%d", nTag, nConIndex), WZUIContainer)
        local nDataIndex = self:_getDataById(id)
        if nDataIndex then
            local tData = self.m_tMemberList[nDataIndex]
            local element = CellHead:show(conHead,tData.headId,tData.faceId,tData.sex,nil,nil,tData.vipLevel, tData.headColor)
        end
    end
end

--@brief    检测队伍是否满人
--@param    nTeamId:队伍号：1,2,3
--@param    id:操作的会员id
function WndCompeteMember:_isTeamFull(nTeamId, id)
    -- body
    local bAdd = true
    local bFull = true 

    for i = 1, #self.m_tTeamPlayerId[nTeamId] do
        if self.m_tTeamPlayerId[nTeamId][i] == id then
            bAdd = false
            bFull = false 
            break
        end
    end

    if bAdd then
        for i = 1, #self.m_tTeamPlayerId[nTeamId] do
            if self.m_tTeamPlayerId[nTeamId][i] == 0 then
                bFull = false 
                break
            end
        end
    end

    return bFull 
end

--@brief    创建底部战队头像
function WndCompeteMember:_createBottomHead()
    -- body
    for i = 1, #self.m_tTeamPlayerId do
        for j = 1, #self.m_tTeamPlayerId[i] do
            local conHead = GetElement(self.m_root, string.format("conHead%d_%d", i, j), WZUIContainer)
            if conHead then
                conHead:removeAllChildrenWithCleanup(true)
            end

            if self.m_tTeamPlayerId[i][j] ~= 0 then
                local nDataIndex = self:_getDataById(self.m_tTeamPlayerId[i][j])
                if nDataIndex then
                    local tData = self.m_tMemberList[nDataIndex]
                    local element = CellHead:show(conHead,tData.headId,tData.faceId,tData.sex,nil,nil,tData.vipLevel, tData.headColor)
                end
            end
        end
    end
end

--@brief    移除一些退出房间的成员
--@param    tExitIds:退出房间的成员Id
function WndCompeteMember:_removeMembers(tExitIds)
    -- body
    if tExitIds == nil or #tExitIds == 0 then return end 
    --刷新列表会员队伍状态
    local tbconList = GetElement(self.m_root, "tbconList_WndCompeteMember", WZUITableContainer)
    local nCurPositionY = tbconList:getMoveElement():getPositionY()
    local tLastSize = tbconList:getMoveElement():getContentSize()

    for i = 1, #tExitIds do
        local nTag = 0 
        local cellElement = tbconList:getCellElement(nTag)
        while cellElement do
            cellElement = WZUIContainer:luaTo(cellElement)
            local cellItem = cellElement:getChildElement("__CellCompeteMemberList")
            if cellItem then
                local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
                if cellObj then
                    local nPlayerId = cellObj:getPlayerId()
                    if nPlayerId == tExitIds[i] then
                        tbconList:removeCellElementByReset(nTag)
                        break 
                    end
                end
            end
            nTag = nTag + 1
            cellElement = tbconList:getCellElement(nTag)
        end
    end

    --重新设置列表的位置
    local tCurSize = tbconList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tbconList:getMaxPosition().y then
        nTempPositionY = tbconList:getMaxPosition().y
    end
    tbconList:getMoveElement():setPositionY(nTempPositionY)

end

--@brief    新增房间成员
--@param    tNewIds:新进房间的成员id
function WndCompeteMember:_addMember(tNewIds)
    -- body
    if tNewIds == nil or #tNewIds == 0 then return end

    --刷新列表会员队伍状态
    local tbconList = GetElement(self.m_root, "tbconList_WndCompeteMember", WZUITableContainer)
    local nCurPositionY = tbconList:getMoveElement():getPositionY()
    local tLastSize = tbconList:getMoveElement():getContentSize()


    self:_createMemberList()
    -- local nCount = #self.m_tMemberList
    -- local nOriginCount = nCount - #tNewIds
    -- for i = nCount, 1, -1 do
    --     local celTemp = tbconList:getCellElement(i - 1)
    --     if celTemp then 
    --         local nNewTag = i - 1 + nAddNum
    --         local child = celTemp:getChildByTag(i - 1)
    --         celTemp:setTag(nNewTag)
    --         child:setTag(nNewTagag)
    --     end
    -- end

    --重新设置列表的位置
    local tCurSize = tbconList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tbconList:getMaxPosition().y then
        nTempPositionY = tbconList:getMaxPosition().y
    end
    tbconList:getMoveElement():setPositionY(nTempPositionY)
end
-------------------------------------私有方法模块End----------------------------------------
