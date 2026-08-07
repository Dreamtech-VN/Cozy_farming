--CellFriendModel.lua
--@brief	CellFriendModel的UI模块
--@date		2021/07/27
--@author	hyc
--@note		好友格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFriendModel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFriendModel:onExit(element)
	self:_unInit()
end

function CellFriendModel:onend( ... )
	-- body
end

function CellFriendModel:onLoadData(  )
	-- body
	WZLog("CellFriendModel:onLoadData")

end

function CellFriendModel:upDateShow(  )
	-- body

	if self.m_root == nil then return end
	WZLog("CellFriendModel:upDateShow",Serialize(self.m_tData))
	local data = self.m_tData
	if (data.send == 1 or data.send == true) and data.serverId  == CacheCenter:getPlayerInfo().serverId then
		GetElement(self.m_root, "btnRecive", WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"btnRecive", WZUIButton):setVisible(false)
	end
	local playerLevel = GetElement(self.m_root,"playerLevel",WZUILabelTTF)
	playerLevel:setText(data.level)
	local playerLName = GetElement(self.m_root,"playerName",WZUILabelTTF)
	playerLName:setText(data.name)
	local imgWeapon = GetElement(self.m_root,"imgWeapon",WZUIImage)


	if data.isOnline == 1 then
		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setText(LocalStrings.REWARD_BTN_ONLINE)
	else
		local offline = self:getOfflineTime(data.offlineTime)
		GetElement(self.m_root,"onlineState_CellMaster",WZUILabelTTF):setText(offline)
	end
	-- imgWeapon:set
end

-- function CellFriendModel:showModel(  )
-- 	-- body
-- 	WZLog("CellFriendModel:showModel")
-- 	local tData = self.m_tData
-- 	if self.m_root == nil then return end
-- 	local conRole = GetElement(self.m_root,"conRole",WZUIContainer)
-- 	local nSex = tData.sex or 0
-- 	local tEquip = {}
-- 	local conPlayer
-- 	table.insert(tEquip,tData.headItemId)
-- 	table.insert(tEquip,tData.faceItemId)
-- 	table.insert(tEquip,tData.bodyId)
-- 	table.insert(tEquip,tData.wingId)

-- 	conPlayer, _1, _2, isMonster = CreatePlayerFigure(nSex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, tData.headColor, tData.bodyColor)
-- end

--@brief   玩家人物
function CellFriendModel:showModel()
	if self.m_root == nil then return end
	local tData = self.m_tData
	local nSex = tData.sex or 0
	local tEquip = {}
	table.insert(tEquip,tData.headItemId)
	table.insert(tEquip,tData.faceItemId)
	table.insert(tEquip,tData.bodyId)
	table.insert(tEquip,tData.wingId)

	WZLog("密友头id",tData.headId,tData.faceId,tData.bodyId,tData.wingId)
	local conPlayerAni = self.m_root:getChildElement("conRole")

	local conPlayer
	if self.m_tPlayerAni == nil then
		if tEquip == {} then
			conPlayer, _1, _2, isMonster = CreatePlayerFigure(nSex, nil, "wait0", nil, nil, nil, nil, nil, nil, nil, tData.headColor, tData.bodyColor)
		else
			conPlayer, _1, _2, isMonster = CreatePlayerFigure(nSex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, tData.headColor, tData.bodyColor)
		end
		conPlayerAni:addChild(conPlayer:getAnimNode())
		conPlayerAni:setTouchEnable(false)
		conPlayer:getAnimNode():setScale(0.85)
		self.m_tPlayerAni = conPlayer
		if isMonster == true then
			conPlayer:getAnimNode():setRelativePosition(ccp(0.5,0.23))
		end
	else
		conPlayer = self.m_tPlayerAni
	end

end

--@brief	获得离线时间字符串
function CellFriendModel:getOfflineTime(loginTime)
	--剩余时间
	local t = loginTime
	local desc = ""
	local s,m,h,d
	--总秒数
	WZLog("离线时间计算",SystemTime:getServerTime(),loginTime)
	local tt = (SystemTime:getServerTime() - t)
	WZLog("剩余秒数",tt)
	if tt <= 0 then
		desc = LocalStrings.REWARD_BTN_ONLINE
	else
		s = tt % 60--s
		tt = math.floor(tt/60)
		m = tt % 60--m
		tt = math.floor(tt/60)
		h = tt % 24--h
		tt = math.floor(tt/24)
		d = tt 
		local tip = LocalStrings.OFFLINESTATE--剩余时间:
		--大于一天只显示天数
		if d > 0 then
			if d > 30 then
				desc = string.format(tip.."%d"..LocalStrings.SPACE31, 1)
			else
				desc = string.format(tip.."%d"..LocalStrings.DAY, d)
			end
		else
			--大于一小时只显示小时数
			if h > 0 then 
				local ds = tip.."%d%s"
				desc = string.format(ds,h,LocalStrings.HOUR1)
			elseif m > 3 then
				local ds = tip.."%d%s"
				desc = string.format(ds, m, LocalStrings.MINUTE1)
			else 
				desc = LocalStrings.JUST_NOW .. tip
			end
		end
	end
	if d ~= nil and d >= 3 then self.m_bOffLineLong = true end
	return desc
end

--@brief 	赠送活力回调
function CellFriendModel:onRecive( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local vector = WZLuaVector_int_:create()

	vector:push(self.m_tData.id)
	WZLog("CellFriendModel:onRecive",self.m_tData.id,1)
    WndFriends.m_nOperarorType = 1
	ProtocolProcessorWndFriends:send_FRIEND_Operation(vector,1)
	self:createLoading()
end

--@brief 	点击查看空间
function CellFriendModel:onCheck( element )
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.id)
end

--@brief   创建加载框
function CellFriendModel:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
