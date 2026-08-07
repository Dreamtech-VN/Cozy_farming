--WndDoubleSevenInvit.lua
--@brief	WndDoubleSevenInvit的UI模块
--@date		2020/08/04
--@author	hyx
--@note		邀请界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDoubleSevenInvit:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDoubleSevenInvit:onExit(element)
	self:_unInit()
	self:unregister()
end
function WndDoubleSevenInvit:register()
	GlobalGame:getGameEventDispathcer():Add(WndDoubleSevenEvent.WndDoubleSevenEvent_InvateNotice,self._onInvateNoticeResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndDoubleSevenEvent.WndDoubleSevenEvent_GetDoubleSevenFriends,self._onInvateGetFriendsList,self)
end
function WndDoubleSevenInvit:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndDoubleSevenEvent.WndDoubleSevenEvent_InvateNotice,self._onInvateNoticeResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndDoubleSevenEvent.WndDoubleSevenEvent_GetDoubleSevenFriends,self._onInvateGetFriendsList,self)
end
function WndDoubleSevenInvit:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndDoubleSevenInvit:actionCallback()
	self:initShow()
end
function WndDoubleSevenInvit:initShow()
	GetElement(self.m_root, "title_name", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT19)

	local titleCon = GetElement(self.m_root, "titleCon", WZUIContainer)
	self.m_tTitleChange = {}
	local name = {LocalStrings.DOUBLE_SEVEN_TEXT20, LocalStrings.DOUBLE_SEVEN_TEXT21}
	for i=1,2 do
		local tab = {}
		tab.normal = GetElement(titleCon, "normal_"..i, WZUIImage)
		tab.select = GetElement(titleCon, "select_"..i, WZUIImage)
		tab.select:setVisible(false)
		tab.name = GetElement(titleCon, "name_"..i, WZUILabelTTF)
		tab.name:setColor(GlobalMethod:ccc3(127,70,26))
		tab.name:setEnableStroke(false)
		tab.name:setText(name[i])
		self.m_tTitleChange[i] = tab
	end
	--默认是选择
	self.m_tTitleChange[self.m_nCurIndex].normal:setVisible(false)
	self.m_tTitleChange[self.m_nCurIndex].select:setVisible(true)
	self.m_tTitleChange[self.m_nCurIndex].name:setEnableStroke(true)
	self.m_tTitleChange[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
	self.m_tTitleChange[self.m_nCurIndex].name:setStrokeColor(GlobalMethod:ccc3(127,70,26))
	self.m_tTitleChange[self.m_nCurIndex].name:setStrokeSize(4)

	self.choose_container = GetElement(self.m_root,"choose_container",WZUIContainer)
	self.choose_container:setVisible(true)
	self.choose_freelist = GetElement(self.choose_container,"choose_freelist",WZUIFreeListContainer)
	
	local btnInvite = GetElement(self.choose_container,"btnInvite",WZUIButton)
	local inviteLabel = GetElement(btnInvite,"inviteLabel",WZUILabelTTF)
	inviteLabel:setText(LocalStrings.INVITE..LocalStrings.FRIEND)
	local choose_tips = GetElement(self.choose_container,"choose_tips",WZUILabelTTF)
	choose_tips:setText(LocalStrings.DOUBLE_SEVEN_TEXT22)
	local is_bind = WndDoubleSeven:getBindFriend()
	if is_bind ~= 0 then
		btnInvite:setTouchEnable(false)
		inviteLabel:setColor(GlobalMethod:ccc3(255,255,255))
		inviteLabel:setStrokeColor(GlobalMethod:ccc3(80,61,50))
	end

	self.notice_container = GetElement(self.m_root,"notice_container",WZUIContainer)
	self.notice_container:setVisible(false)
	self.notice_freelist = GetElement(self.notice_container,"notice_freelist",WZUIFreeListContainer)
	self:setInvateContainerFlag(self.m_nCurIndex)
end

function WndDoubleSevenInvit:onBtnClickChangeTitle(element)
	local tag = tonumber(element:getTag())
	if self.m_nCurIndex == tag then return end

	if self.m_tTitleChange[self.m_nCurIndex] ~= nil then
		self.m_tTitleChange[self.m_nCurIndex].normal:setVisible(true)
		self.m_tTitleChange[self.m_nCurIndex].select:setVisible(false)
		self.m_tTitleChange[self.m_nCurIndex].name:setEnableStroke(false)
		self.m_tTitleChange[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
	end
	if self.m_tTitleChange[tag] ~= nil then
		self.m_tTitleChange[tag].normal:setVisible(false)
		self.m_tTitleChange[tag].select:setVisible(true)
		self.m_tTitleChange[tag].name:setEnableStroke(true)
		self.m_tTitleChange[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tTitleChange[tag].name:setStrokeColor(GlobalMethod:ccc3(127,70,26))
		self.m_tTitleChange[tag].name:setStrokeSize(4)
	end

	self:setInvateContainerFlag(tag)
	self.m_nCurIndex = tag
end

function WndDoubleSevenInvit:setInvateContainerFlag(tag)
	self.choose_container:setVisible(tag == 1)
	self.notice_container:setVisible(tag == 2)
	if self.m_tInvateItem[tag] == true then return end
	if tag == 1 then
		ProtocolProcessorWndFriends:send_FRIEND_GetFriend(17, 1, 0)
	elseif tag == 2 then
	 	ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfessList( )
	end
	self.m_tInvateItem[tag] = true
end
--选择邀请好友的返回
--status:1->邀请 
function WndDoubleSevenInvit:setChooseFriendsResult(index, status, playerId)
	if status == 1 then
		self.m_tInvateFriends[index] = playerId
	elseif status == 0 then
		self.m_tInvateFriends[index] = nil
	end
end

--邀请好友
function WndDoubleSevenInvit:onBtnClickInvite()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if next(self.m_tInvateFriends) == nil then
		MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT23)
		return
	end
	
	local tab = {}
	for i,v in pairs(self.m_tInvateFriends) do
		table.insert(tab, v)
	end
	ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiConfess(1, TableToVector(tab, WZLuaVector_int_) )
end

function WndDoubleSevenInvit:showInterface(index)
	local invite = WndDoubleSevenInvit:createElement()
    WindowManager:addWindow(invite,WndDoubleSevenInvit,nil,false)
    self.m_nCurIndex = index or 1
end
function WndDoubleSevenInvit:onClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndDoubleSevenInvit:setInvateFriendsList(playerId, sex, playerName, level, headItemId, faceItemId, colour, serverId, headEffectId, qqHallInfo)
	if next(playerId) == nil then
		ShowPanelNullTip(self.choose_container)
		return
	end
	local tData = {}
	for i=1,#playerId do
		local tab = {}
		tab.playerId = playerId[i]
		tab.sex = sex[i]
		tab.playerName = playerName[i]
		tab.level = level[i]
		tab.headItemId = headItemId[i]
		tab.faceItemId = faceItemId[i]
		tab.colour = colour[i]
		tab.serverId = serverId[i]
		tab.headEffectId = headEffectId and headEffectId[i] and headEffectId[i] or 0
		if qqHallInfo and qqHallInfo[i] and qqHallInfo[i] ~= "" then 
			tab.qqHallData = json.decode(qqHallInfo[i])
		end
		tData[i] = tab
	end
	if self.choose_freelist then
		for i = 1, #playerId do
	        local element, tLuaObj = CellChooseFriendsItem:createElement()
	        self.choose_freelist:pushBack(WZUIContainer:luaTo(element))
	        self.choose_freelist:getMoveElement():setPositionY(self.choose_freelist:getMinPosition().y)
	        tLuaObj:setChooseFriendsMessage(i, tData[i])
	        tLuaObj:setChooseFriendsCallFun(function(index, status, playerId)
	        	self:setChooseFriendsResult(index, status, playerId)
	    	end)
	    end
	end
end

function WndDoubleSevenInvit:setInvateNoticeData(playerId, nickname, headId, headColor, faceId, sex, level, confessContext, confessTime, confessType, confessStatus)
	if next(confessStatus) == nil then
		ShowPanelNullTip(self.notice_container)
		return
	end
	local tData = {}
	for i=1,#confessStatus do
		local tab = {}
		tab.playerId = playerId[i]
		tab.nickname = nickname[i]
		tab.headId = headId[i]
		tab.headColor = headColor[i]
		tab.faceId = faceId[i]
		tab.sex = sex[i]
		tab.level = level[i]
		tab.desc = LocalStrings.DOUBLE_SEVEN_TEXT24[confessContext[i]]
		tab.confessTime = confessTime[i]
		tab.confessType = confessType[i]
		tab.confessStatus = confessStatus[i]

		tData[i] = tab
	end
	table.sort(tData, function(a,b) return a.confessTime < b.confessTime end)

	-- confessType 1=拒绝  2=接受
	for i = 1, #tData do
		local element
		if tData[i].confessType == 1 then
			element, tLuaObj = CellInvateNoticeItem2:createElement()
			tLuaObj:setNotice2InitMessage(tData[i])
		elseif tData[i].confessType == 2 then
			element, tLuaObj = CellInvateNoticeItem1:createElement()
			tLuaObj:setNotice1InitMessage(tData[i])
		end
        if element then
        	element:setRelativeSize(GlobalMethod:CCSize(1,0.185))
	        self.notice_freelist:pushBack(WZUIContainer:luaTo(element))
	        self.notice_freelist:getMoveElement():setPositionY(self.notice_freelist:getMinPosition().y)
	    end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndDoubleSevenInvit:_onInvateNoticeResult(playerId, nickname, headId, headColor, faceId, sex, level, confessContext, confessTime, confessType, confessStatus)
	self:setInvateNoticeData(playerId, nickname, headId, headColor, faceId, sex, level, confessContext, confessTime, confessType, confessStatus)
end

function WndDoubleSevenInvit:_onInvateGetFriendsList(playerId, sex, playerName, level, headItemId, faceItemId, colour, serverId, headEffectId, qqHallInfo)
	self:setInvateFriendsList(playerId, sex, playerName, level, headItemId, faceItemId, colour, serverId, headEffectId)
end
-------------------------------------私有方法模块End----------------------------------------
