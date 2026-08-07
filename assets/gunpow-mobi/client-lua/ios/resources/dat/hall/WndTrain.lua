--WndTrain.lua
--@brief	WndTrain的UI模块
--@date		2017/04/21
--@author	 
--@note		训练营


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTrain:onEnter(element)
	self.m_root = element
	ChangeChatChannel(Chat_Channel_Hall)
	ProtocolProcessorSceneHall:unregAll()
	ProtocolProcessorWndTrain:regAll()
	ProtocolProcessorWndTrain:send_ROOM_GetRoomList(GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX)
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTrain:onExit(element)
	ChangeChatChannel(Chat_Channel_Hall)
	ProtocolProcessorSceneHall:regAll()
	ProtocolProcessorWndTrain:unregAll()
	self:_unInit()
end

--关闭窗口
function WndTrain:onClickClose(element)
	WZLog("WndTrain:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self,true)
end

--查找房间
function WndTrain:onClickFindRoom(element)
	WZLog("WndTrain:onClickFindRoom")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local wndFindRoom = WndFindRoom:createElement()
    if wndFindRoom ~= nil then
        WindowManager:addWindow(wndFindRoom,WndFindRoom,true,nil,nil)
        WndFindRoom:setFindBtnCallBack(self.searchRoom,self)
    end
end

--创建房间
function WndTrain:onClickCreateRoom(element)
	WZLog("WndTrain:onClickCreateRoom")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local name = LocalStrings.ROOM_NAME_RANDOM
    local random = math.random(#name)
    local GlobalGame = GlobalGame
    ProtocolProcessorWndTrain:send_ROOM_CreateRoom(name[random],GlobalGame.g_tBattleMode.BATTLE_MODE_JJ,GlobalGame.g_tNumMode.NUM_MODE_3,"-1",GlobalGame.g_tStartMode.START_MODE_LIBERTY,GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_LX,0)
    self:createLoadingBox()
end

--@brief	查找房间
--@param 	入参与创建房间的协议发送方法参数相同
--@return	true:关闭WndEditBox，false:反之
--@note     调用这个函数发送查找房间协议,起到代理的作用
function WndTrain:searchRoom(roomId,password)
	WZLog("WndTrain:searchRoom =",roomId)
	local id = tonumber(roomId)
	if id == nil then
        MsgBoxManager:showTipBox(LocalStrings.ROOM_FIND_TIPS)
    else
		--假房间直接提示，返回
		-- for k,v in pairs(self.roomData) do
		-- 	--WZLog("查找假房间", tostring(v.roomId), string.format("%04d",id))
		-- 	if tostring(v.roomId) == string.format("%04d",id) and v.fake == true then
		-- 		MsgBoxManager:showTipBox(LocalStrings.FAKEROOM)
		-- 		return
		-- 	end
		-- end
    	if password == nil  then 
    		WZLog("WndTrain:searchRoom password == nil ")
			ProtocolProcessorWndTrain:send_ROOM_SelectRoom(id,10,"-1")
		else
			WZLog("WndTrain:searchRoom password ~= nil ")
			if password == "" then 
				ProtocolProcessorWndTrain:send_ROOM_SelectRoom(id,10,"-1")
			else 
				ProtocolProcessorWndTrain:send_ROOM_SelectRoom(id,10,password) 
			end 
		end
		self:createLoadingBox()
	end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndTrain:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
    end
end

function WndTrain:closeLoadingBox()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end

--@brief	输入房间密码
--@param 	入参与创建房间的协议发送方法参数相同
--@note     当房间需要密码时，弹出窗口
function WndTrain:enterRoomPassword()
	WZLog("WndTrain:enterRoomPassword")
	local element = WndEditBox:createElement()
    if nil ~= element then
    	local tNewObj= element:getLuaObjectIndex()
        WndEditBox:setData(LocalStrings.ROOM_PASSWORD,LocalStrings.CLICK_TO_INPUT_PASSWORD)
        WndEditBox:setEditType(2)
        WndEditBox:setOkCallBack(self.enterRoomPasswordOk,self)
        WindowManager:addWindow(element, WndEditBox,true,nil,nil)
    end
end

--@brief	输入房间密码完毕
--@note     当房间需要密码时，弹出窗口
function WndTrain:enterRoomPasswordOk(password)
	WZLog("WndTrain:enterRoomPassword =",password)
	if password ~= self.m_tSearchRoomData.password then
		MsgBoxManager:showTipBox(LocalStrings.PASSWORD_NOT_MATCH)
		return false
	else
		self:searchRoom(self.m_tSearchRoomData.roomId,self.m_tSearchRoomData.password)
		return true
	end
end

-- 创建房间列表
function WndTrain:initRoomListOnce()
    local tab = GetElement(self.m_root,"tabRoomList_WndTrain",WZUITableContainer)
    tab:cleanTable()
    for i = 1, #self.roomData do
        local cell,tcell = CellRoomItem:createElement()
        cell:setTag(i-1)
        tab:setCellElement(cell)
        tcell:setData(self.roomData[i])
        tcell:setClickCallback(self.onRoomListClick,self)
    end
end

--@brief	房间列表项点击回调
--@param 	element:cellRoomItem的引用
--@note		由cellRoomItem回调
function WndTrain:onRoomListClick(element)
	WZLog("WndTrain:onRoomListClick")
	--假房间直接提示，返回
	if element.m_tData.battleStatus ~= 0 then --战斗中
		MsgBoxManager:showTipBox(LocalStrings.ROOM_BATTLEING)
	elseif element.m_tData.playerNum == element.m_tData.maxNum then --房间已满
		MsgBoxManager:showTipBox(LocalStrings.ROOM_FULL)
	else
		if element.m_tData.passWord ~= "-1" then
			--需要输入密码
        	self.m_tSearchRoomData = {roomId=element.m_tData.roomId, password=element.m_tData.passWord}
        	self:enterRoomPassword()
        else 
        	self:searchRoom(element.m_tData.roomId)
    	end
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndTrain:_adaptLanguage_es(  )
	local txtDesc = GetElement(self.m_root,"txtDescribe_WndTrain",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(310,0))

	local txtBtn1 = GetElement(self.m_root,"txtBtn1_WndTrain",WZUILabelTTF)
	txtBtn1:setScale(0.8)
	txtBtn1:setDimensions(GlobalMethod:CCSize(130,0))

	local txtBtnSel1 = GetElement(self.m_root,"txtBtnSel1_WndTrain",WZUILabelTTF)
	txtBtnSel1:setScale(0.8)
	txtBtnSel1:setDimensions(GlobalMethod:CCSize(130,0))

	local txtBtn2 = GetElement(self.m_root,"txtBtn2_WndTrain",WZUILabelTTF)
	txtBtn2:setScale(0.8)
	txtBtn2:setDimensions(GlobalMethod:CCSize(130,0))

	local txtBtnSel2 = GetElement(self.m_root,"txtBtnSel2_WndTrain",WZUILabelTTF)
	txtBtnSel2:setScale(0.8)
	txtBtnSel2:setDimensions(GlobalMethod:CCSize(130,0))
end

function WndTrain:_adaptLanguage_en(  )
	local txtBtn2 = GetElement(self.m_root,"txtBtn2_WndTrain",WZUILabelTTF)
	txtBtn2:setScale(0.7)
	local txtBtnSel2 = GetElement(self.m_root,"txtBtnSel2_WndTrain",WZUILabelTTF)
	txtBtnSel2:setScale(0.7)
end
-------------------------------------语言适配End--------------------------------------------