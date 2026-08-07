--WndRoomInviteList.lua
--@brief	WndRoomInviteList的UI模块
--@date		2019/03/12
--@author	Tianxiang_Xu
--@note		房间邀请界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRoomInviteList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRoomInviteList:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	加载动画
function WndRoomInviteList:onEnterTransitionDidFinish(element)
	self:onInitInterface(self.m_nInterface)
    self:addInviteAtt(self.m_nPlayerNum, self.m_tPWLevelList, self.m_tPlayerId)
	self.m_root:enableSchedule("_updateList", 1)
end

--@brief	关闭按钮回调事件
function WndRoomInviteList:onClose(element)
	WZLog("关闭按钮回调事件")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief	关闭按钮回调事件
function WndRoomInviteList:onCloseActionCallback(element,data)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	显示列表
function WndRoomInviteList:onShowFriend(element)
	if self.m_root == nil or self:getListData() == nil then
		return 
	end
	local maxCount = #self:getListData()
	
	WZLog("self.m_nIndex::",self.m_nIndex,maxCount)

	for i=1,maxCount do    --Modified By Tianxiang_Xu
        local isSelect = false
        local pid = self:getListData()[self.m_nIndex + 1].id
        if self.m_tInvitePlayer ~= nil then 
            for i,v in pairs(self.m_tInvitePlayer) do
                WZLog("id====",v,pid)
                if v == pid then
                    isSelect = true
                    break
                end
            end
        end 
        self.m_nIndex = self.m_nIndex + 1
        local celElement, tCell = CellRoomInviteList:createElement()
        celElement:setTag(self.m_nIndex - 1)
        tCell:setCellData(self:getListData()[self.m_nIndex],self.m_nSelect)
        tCell:setUIIndex(self.m_nInterface)
        tCell:setBackFun(self,self.onFriendClick)
        self:getCurFrame():setCellElement(celElement)
        WZLog("========player  =",self:getListData()[self.m_nIndex].id,self:getListData()[self.m_nIndex].name,self:getListData()[self.m_nIndex].level)
        if isSelect == true then
           tCell:showInvateIcon(isSelect)
        end
	end

    local tcon = self:getCurFrame()
    if self.m_bSetOriginalPos == true then
        self.m_bSetOriginalPos = false
        tcon:getMoveElement():setPositionY(tcon:getMinPosition().y)
    else
        if tcon:getMoveElement():getContentSize().height > tcon:getAbsContentSize().height then
            if tcon:getMaxPosition().y >= self.m_nCurPosY then
                tcon:getMoveElement():setPositionY(self.m_nCurPosY)
            else
                tcon:getMoveElement():setPositionY(tcon:getMaxPosition().y)
            end
        else
            tcon:getMoveElement():setPositionY(tcon:getMinPosition().y)
        end
    end
end

--@brief	好友checkbox点击回调
function WndRoomInviteList:onFriend(element)
	WZLog("WndRoomInviteList:onFriend:: ",self.m_nSelect)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nSelect == 1 then 
		return 
	end 
    --切换选项时，停止滑动
    local tableInviteList = GetElement(self.m_root, "tableInviteList_WndRoomInviteList", WZUITableContainer)
    tableInviteList:stopMoveAction()

	local conInviteList = GetElement(self.m_root,"conInviteList_WndRoomInviteList",WZUIContainer)
	removeShowPanelNullTip(conInviteList)
    self.m_nSelect = 1

    self.m_bIsChangeBox = true

    if self.m_nInterface == 11 then
        local pwLevel = SceneRoom:getPlayerPWLevel()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,1,self.m_nTopLevel, pwLevel)
    elseif self.m_nInterface == 20 then
        local pwLevel = SceneRoom:getPlayerPWLevel()
        local playerNumMode = SceneRoom:getPlayerNumMode()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,1,self.m_nTopLevel, pwLevel, playerNumMode)
    elseif self.m_nInterface == 12 then
        local amuseLevel = SceneRoom:getPlayerAmuseLevel()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface, 1, nil, amuseLevel)
    else
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,1)
    end
end

--@brief	公会checkbox点击回调
function WndRoomInviteList:onGuild(element)
	WZLog("WndRoomInviteList:onGuild::")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    
	if self.m_nSelect == 2 then 
		return 
	end
    --切换选项时，停止滑动
    local tableInviteList = GetElement(self.m_root, "tableInviteList_WndRoomInviteList", WZUITableContainer)
    tableInviteList:stopMoveAction()

	local conInviteList = GetElement(self.m_root,"conInviteList_WndRoomInviteList",WZUIContainer)
	removeShowPanelNullTip(conInviteList)
    self.m_nSelect = 2

    self.m_bIsChangeBox = true

    if self.m_nInterface == 11 then
        local pwLevel = SceneRoom:getPlayerPWLevel()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,2,self.m_nTopLevel, pwLevel)
    elseif self.m_nInterface == 20 then
        local pwLevel = SceneRoom:getPlayerPWLevel()
        local playerNumMode = SceneRoom:getPlayerNumMode()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,2,self.m_nTopLevel, pwLevel, playerNumMode)
    elseif self.m_nInterface == 12 then
        local amuseLevel = SceneRoom:getPlayerAmuseLevel()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,2,nil, amuseLevel)
    else
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,2)
    end
end
--@brief    大厅checkbox点击回调
function WndRoomInviteList:onHall(element)
    WZLog("WndRoomInviteList:onHall::")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nSelect == 3 then 
		return 
	end
    --切换选项时，停止滑动
    local tableInviteList = GetElement(self.m_root, "tableInviteList_WndRoomInviteList", WZUITableContainer)
    tableInviteList:stopMoveAction()

	local conInviteList = GetElement(self.m_root,"conInviteList_WndRoomInviteList",WZUIContainer)
	removeShowPanelNullTip(conInviteList)
    self.m_nSelect = 3

    self.m_bIsChangeBox = true
	
    if self.m_nInterface == 11 then
        local pwLevel = SceneRoom:getPlayerPWLevel()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,3,self.m_nTopLevel, pwLevel)
    elseif self.m_nInterface == 20 then
        local pwLevel = SceneRoom:getPlayerPWLevel()
        local playerNumMode = SceneRoom:getPlayerNumMode()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,3,self.m_nTopLevel, pwLevel, playerNumMode)
    elseif self.m_nInterface == 12 then 
        local amuseLevel = SceneRoom:getPlayerAmuseLevel()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,3,nil, amuseLevel)
    else
        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,3)
    end
end
--师门
function WndRoomInviteList:onMaster(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_nSelect == 6 then 
        return 
    end
    --切换选项时，停止滑动
    local tableInviteList = GetElement(self.m_root, "tableInviteList_WndRoomInviteList", WZUITableContainer)
    tableInviteList:stopMoveAction()

    local conInviteList = GetElement(self.m_root,"conInviteList_WndRoomInviteList",WZUIContainer)
    removeShowPanelNullTip(conInviteList)
    self.m_nSelect = 6

    self.m_bIsChangeBox = true
    local pwLevel = SceneRoom:getPlayerPWLevel()
    local playerNumMode = SceneRoom:getPlayerNumMode()
    ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface,6,self.m_nTopLevel, pwLevel, playerNumMode)
end

--@brief	好友点击回调
function WndRoomInviteList:onFriendClick(tCell,tag,tData)
    WZLog("WndRoomInviteList:onFriendClick(tCell,tag,tData)")
	if self.m_root == nil or self:getListData() == nil or #self:getListData() == 0 then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndRoomInviteList:onFriendClick::",tag,self:getListData()[tag+1].id,self:getListData()[tag+1].name)
    
	if self.m_tBack and self.m_tBack[1] and self.m_tBack[2] then
        local bAssetFight = 1 --是否助战（0为助战）
        if self.m_nSelect == 5 then
            bAssetFight = 0
        end
		self.m_tBack[2](self.m_tBack[1],self:getListData()[tag+1],self.m_nSelect,bAssetFight, self.m_nSelect)
	end
    if self.m_nInterface == 3 or self.m_nInterface == 6 or self.m_nInterface == 11 or self.m_nInterface == 12 or self.m_nInterface == 20 then
    	if self.m_tInviteFriendIds~=nil and #self.m_tInviteFriendIds > 0 then 
    		for i,v in ipairs(self.m_tInviteFriendIds) do
    			WZLog("onFriendClick=====playerId="..v)
    			if v == tData.id then
    	   			return 
    			end
    		end
    	end 

    	tCell:showInvateIcon(true)
        if self.m_tInvitePlayer == nil then
            self.m_tInvitePlayer = {}
        end
        WZLog("playerid===",tData.id)
        table.insert(self.m_tInvitePlayer,tData.id)
    end 
end

--@brief    点击隐藏邀请列表
function WndRoomInviteList:onClickHideInvite(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if self.m_nInterface == 6 then 
        SceneBossRoom:hideInviteListCallBack()
    else
        SceneRoom:hideInviteListCallBack()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndRoomInviteList:getListData()
	if self.m_nSelect == 1 or self.m_nSelect == 4 then
		return self.m_tFriend
	elseif self.m_nSelect == 2 then 
		return self.m_tGuild
    elseif self.m_nSelect == 3 then
        return self.m_tHall
    elseif self.m_nSelect == 5 then
        return self.m_tAssistIn
    elseif self.m_nSelect == 6 then
        return self.m_tMaster
	end
end


function WndRoomInviteList:_update()
	if self.m_root == nil then
		return
    end
    local t = self:getListData()
    local tbcon = self:getCurFrame()
    self.m_nCurPosY = tbcon:getMoveElement():getPositionY()
    tbcon:cleanTable()
    tbcon:setContentOffsetByRowIndex(0)

    if t == nil or #t == 0 then
    	local desc = LocalStrings.EMPTYFRIENDTIP1
    	if CacheCenter:getFriendCount()>0 then 
        	desc = LocalStrings.TXT_ONLINEFRIEND_ISNULL
    	end 
        if self.m_nSelect == 2 then
        	local PlayerInfo = CacheCenter:getPlayerInfo()
        	if PlayerInfo.guildId==0 then 
        		desc = LocalStrings.TXT_NOSOCISY_FREND
        	else 
        		desc = LocalStrings.TXT_ONLINEGUILD_ISNULL
        	end  
        elseif self.m_nSelect == 3 then
            desc = self.NO_PLAYER_IN_HALL
        elseif self.m_nSelect == 4 then
            desc = LocalStrings.ATT_ONLINEFRIEND_NULL
        elseif self.m_nSelect == 6 then
            desc = LocalStrings.OPTIMIZE_TEXT87
        end
        if self.m_nInterface == 11 then
            desc = LocalStrings.PVPRANK_INVITE_NO_DATA
        end
        self:_showEmptyTip(0,desc)
        return
    end

    WZLog("#t===",#t)
    self:_showEmptyTip(#t,desc)
    self.m_nIndex = 0
	self:onShowFriend(tbcon)
end

--@brief	空数据提示语
function WndRoomInviteList:_showEmptyTip(count,desc)
	local conInviteList = GetElement(self.m_root,"conInviteList_WndRoomInviteList",WZUIContainer)
	removeShowPanelNullTip(conInviteList)
	if count > 0 then
		return
	else
        if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" then
            ShowPanelNullTip(conInviteList, desc, nil, nil, 18, nil, GlobalMethod:CCSize(200,0))
        else
            ShowPanelNullTip(conInviteList, desc, nil, nil, 18)
        end
	end
end

function WndRoomInviteList:getCurFrame()
	return WZUITableContainer:luaTo(self.m_root:getChildElement("tableInviteList_WndRoomInviteList"))
end

--@brief 	定时刷新列表
function WndRoomInviteList:_updateList(element, delta)
	-- body
	if self.m_nLeftTime > 0 then 
		self.m_nLeftTime = self.m_nLeftTime - 1
	else
		self.m_nLeftTime = 6
		self.m_tInvitePlayer = {}
        if self.m_nInterface == 11 then
            local pwLevel = SceneRoom:getPlayerPWLevel()
            ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface, self.m_nSelect, self.m_nTopLevel, pwLevel)
        elseif self.m_nInterface == 20 then
            local pwLevel = SceneRoom:getPlayerPWLevel()
            local playerNumMode = SceneRoom:getPlayerNumMode()
            ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface, self.m_nSelect, self.m_nTopLevel, pwLevel, playerNumMode)
        elseif self.m_nInterface == 12 then
            local amuseLevel = SceneRoom:getPlayerAmuseLevel()
            ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface, self.m_nSelect, nil, amuseLevel)
	    else
	        ProtocolProcessorWndFriends:send_FRIEND_GetFriend(self.m_nInterface, self.m_nSelect)
	    end
	end
end

--@brief    邀请提示语
function WndRoomInviteList:addInviteAtt(playerNum, pwLevelList, playerId)
    -- body
    WZLog("WndRoomInviteList:addInviteAtt", playerNum, type(self.m_root), Serialize(pwLevelList), Serialize(playerId))
    self.m_tPWLevelList = pwLevelList
    self.m_nPlayerNum = playerNum 
    self.m_tPlayerId = playerId
    if self.m_root == nil then return end 

    local txtInviteAtt = GetElement(self.m_root, "txtInviteAtt_WndRoomInviteList", WZUILabelTTF)
    if self.m_nInterface == 11 then 
        local tTempList = {}
        for i = 1, #pwLevelList do
            if playerId[i] > 0 then 
                local bExist = false 
                for j = 1, #tTempList do
                    if tTempList[j] == pwLevelList[i] then 
                        bExist = true 
                        break 
                    end
                end
                if not bExist then 
                    table.insert(tTempList, pwLevelList[i])
                end
            end
            if #tTempList >= playerNum then 
                break 
            end
        end
        local tLevel6 = self:getCanInviteData(tTempList)
        WZLog("WndRoomInviteList:addInviteAtt rrr", Serialize(tLevel6), Serialize(tTempList))
        local content = ""
        for i = 1, #tLevel6 do
            if i ~= #tLevel6 then 
                content = content .. LocalStrings.ROOMINVITE_TEXT2[tLevel6[i]] .. ","
            else
                content = content .. LocalStrings.ROOMINVITE_TEXT2[tLevel6[i]]
            end
        end
        txtInviteAtt:setText(string.format(LocalStrings.ROOMINVITE_TEXT1, content))
    elseif self.m_nInterface == 12 then 
        local tTempList = {}
        if pwLevelList then
            for i = 1, #pwLevelList do
                if playerId[i] > 0 then 
                    local bExist = false 
                    for j = 1, #tTempList do
                        if tTempList[j] == pwLevelList[i] then 
                            bExist = true 
                            break 
                        end
                    end
                    if not bExist then 
                        table.insert(tTempList, pwLevelList[i])
                    end
                end
                if #tTempList >= playerNum then 
                    break 
                end
            end
        end
        local tLevel6 = self:getCanInviteData(tTempList)
        WZLog("WndRoomInviteList:addInviteAtt rrr", Serialize(tLevel6), Serialize(tTempList))
        local content = ""
        for i = 1, #tLevel6 do
            if i ~= #tLevel6 then 
                content = content .. LocalStrings.AMUSERANK_TEXT4[tLevel6[i]] .. ","
            else
                content = content .. LocalStrings.AMUSERANK_TEXT4[tLevel6[i]]
            end
        end
        local amuseName = SceneRoom:getAmuseName()
        txtInviteAtt:setText(string.format(LocalStrings.AMUSERANK_TEXT3, content, amuseName))
    else
        txtInviteAtt:setText("")
    end
end

--@brief    根据排位等级，返回提示语
function WndRoomInviteList:getCanInviteData(pwLevelList)
    -- body
    local nCount = #pwLevelList
    local tLevel6 = {}

    local bHaveFive = false 
    local bHaveSix = false 
    for i = 1, nCount do
        local nQualifyLevel = pwLevelList[i]
        local temp = nQualifyLevel + 1
        local mathInfo = GDatatab_trio_rank_match_config["id_" .. temp]
        if mathInfo == nil then
            mathInfo = GDatatab_trio_rank_match_config["id_999"]
        end
        if mathInfo.level6 == 5 then 
            bHaveFive = true 
            break 
        elseif mathInfo.level6 == 6 then 
            bHaveSix = true 
            break 
        end
    end

    if bHaveFive then 
        tLevel6[1] = 4
        tLevel6[2] = 5
    elseif bHaveSix then 
        tLevel6[1] = 6
    else
        if nCount == 1 then 
            local nQualifyLevel = pwLevelList[1]
            local temp = nQualifyLevel + 1
            local mathInfo = GDatatab_trio_rank_match_config["id_" .. temp]
            if mathInfo == nil then
                mathInfo = GDatatab_trio_rank_match_config["id_999"]
            end
           
            tLevel6[1] = mathInfo.level6
            if mathInfo.level6 == 1 then 
                tLevel6[2] = mathInfo.level6 + 1
            else
                tLevel6[2] = mathInfo.level6 - 1
                tLevel6[3] = mathInfo.level6 + 1
            end
        elseif nCount > 1 then 
            local nQualifyLevel = pwLevelList[1]
            local temp = nQualifyLevel + 1
            local mathInfo = GDatatab_trio_rank_match_config["id_" .. temp]
            if mathInfo == nil then
                mathInfo = GDatatab_trio_rank_match_config["id_999"]
            end

            local tempLeve6 = mathInfo.level6
            local bEqual = true 
            for i = 1, nCount do
                local temp = pwLevelList[i] + 1
                local mathInfo = GDatatab_trio_rank_match_config["id_" .. temp]
                if mathInfo == nil then
                    mathInfo = GDatatab_trio_rank_match_config["id_999"]
                end
                local bExist = false 
                for k = 1, #tLevel6 do
                    if tLevel6[k] == mathInfo.level6 then 
                        bExist = true
                        break 
                    end
                end
                if not bExist then 
                    table.insert(tLevel6, mathInfo.level6)
                end
            end
            if #tLevel6 == 1 then
                if tLevel6[1] == 1 then 
                    tLevel6[2] = tLevel6[1] + 1
                else
                    tLevel6[2] = tLevel6[1] - 1
                    tLevel6[3] = tLevel6[1] + 1
                end
            end
        end
    end

    return tLevel6
end

--@brief    根据娱乐等级，返回提示语
--@param    pwLevelList:娱乐赛等级
function WndRoomInviteList:getAmuseCanInviteData(pwLevelList)
    -- body
    local nCount = #pwLevelList
    local tLevel6 = {}

    if nCount == 1 then 
        local nQualifyLevel = pwLevelList[1]
        local mathInfo = GDatatab_entertainment_level["id_" .. nQualifyLevel]
        
        tLevel6[1] = mathInfo.level2
        if mathInfo.level2 == 1 then 
            tLevel6[2] = mathInfo.level2 + 1
        else
            tLevel6[2] = mathInfo.level2 - 1
            tLevel6[3] = mathInfo.level2 + 1
        end
    elseif nCount > 1 then 
        for i = 1, nCount do
            local temp = pwLevelList[i]
            if temp > 0 then 
                local mathInfo = GDatatab_entertainment_level["id_" .. temp]
                
                local bExist = false 
                for k = 1, #tLevel6 do
                    if tLevel6[k] == mathInfo.level2 then 
                        bExist = true
                        break 
                    end
                end
                if not bExist then 
                    table.insert(tLevel6, mathInfo.level2)
                end
            end
        end
        if #tLevel6 == 1 then
            if tLevel6[1] == 1 then 
                tLevel6[2] = tLevel6[1] + 1
            else
                tLevel6[2] = tLevel6[1] - 1
                tLevel6[3] = tLevel6[1] + 1
            end
        end
    end

    return tLevel6
end
-------------------------------------私有方法模块End----------------------------------------
