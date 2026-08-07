--SceneLeagueRoomData.lua
--@brief	SceneLeagueRoom的数据模块
--@date		2016-06-27
--@author	binshao
--@note		英雄联赛房间

SceneLeagueRoom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneLeagueRoom:_init()
	self.m_root = nil	 	  	--场景根节点
	self.timeHX = 1				-- 海选赛倒计时
	self.timeLS = 120			-- 小组赛倒计时
	self.captain = nil			-- 队长
	self.pInfo = {}				-- 玩家信息
	self.matchType = nil		-- 比赛类型， 8位海选，否则是其他
	self.btnFlag = false		-- 初始化返回按键标志位
	self.tipsData = {}
	self.timeOut = false
	self.loadingId = nil

	self.teamInfo = nil			-- 战队信息，队伍名字，队伍ID，队伍图标
	self.myWin = 0				-- 自己胜利次数
	self.otherWin = 0			-- 对手胜利次数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneLeagueRoom:_unInit()
	self.m_root = nil
	self.captain = nil
	self.pInfo = nil
	self.matchType = nil
	self.timeHX = nil
	self.timeLS = nil
	self.btnFlag = nil
	self.tipsData = nil
	self.timeOut = nil
	self.loadingId = nil
	self.teamInfo = nil
	self.myWin = 0				-- 自己胜利次数
	self.otherWin = 0			-- 对手胜利次数
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneLeagueRoom:createElement()
	local element = WZUISystem:getInstance():createElement("SceneLeagueRoom")
	assert(element, "SceneLeagueRoom create element failed!")
	self:_init()
	return element
end

--
function SceneLeagueRoom:setPlayerData(roomId, roomStatus, battleMode, roomChannel, playerNumMode,schedule, mapId, wnersId,
	startMode, playerNum, seatUsed, playerId, serviceId, playerName, playerLevel, playerReady, playerSex, equipmentId,
	equipmentLevel, vipLevel, playerTitle, roomName, roomPassword, fighting, pet, tournamentLevel, winNum, playNum,
	extranInfo,tournamentExp,url,teamId,teamName,headColor,bodyColor)
	local roomChannel = roomChannel
	local seatUsed = VectorToTable(seatUsed)
	local playerId = VectorToTable(playerId)
	local serviceId = VectorToTable(serviceId)
	local playerName = VectorToTable(playerName)
	local playerLevel = VectorToTable(playerLevel)
	local playerSex = VectorToTable(playerSex)
	local equip = VectorToTable(equipmentId)
	local equipmentLevel = VectorToTable(equipmentLevel)
	local fighting = VectorToTable(fighting)
	local pet = VectorToTable(pet)
	local tournamentLevel = VectorToTable(tournamentLevel)
	local winNum = VectorToTable(winNum)
	local playNum = VectorToTable(playNum)
	local extranInfo = VectorToTable(extranInfo)
	local tournamentExp = VectorToTable(tournamentExp)
	local url = VectorToTable(url)
	local teamId = VectorToTable(teamId)
	local teamName = VectorToTable(teamName)
	local headColor = VectorToTable(headColor)
	local bodyColor = VectorToTable(bodyColor)
	WZLog("--------------SceneLeagueRoom:setPlayerData------------id",#playerId)
	WZLog("--------------SceneLeagueRoom:setPlayerData------------name",teamName)
	WZLog("--------------SceneLeagueRoom:setPlayerData------------name1",type(teamName))

	for i = 1, #playerId do
		WZLog("---------------playerInfo--------------",playerId[i],playerName[i],playerLevel[i],playerSex[i],fighting[i])
	end


	-- 比赛类型
	if not self.matchType then
		self.matchType = schedule

	end

	-- 玩家位置
	local pIndex = self:findPlayerIndex(playerId)
	WZLog("-------------cur player index--------------",pIndex)

	-- 战队信息
	if not self.teamInfo and teamName then
		self.teamInfo = {}
		WZLog("url-----------------",url[1],url[4])
		WZLog("teamId-----------------",teamId[1],teamId[4])
		WZLog("teamName-----------------",teamName[1],teamName[4])
		if pIndex <= 3 then
			self.teamInfo[1] = {url = url[1],teamId = teamId[1], teamName = teamName[1]}
			self.teamInfo[2] = {url = url[4],teamId = teamId[4], teamName = teamName[4]}
		else
			self.teamInfo[1] = {url = url[4],teamId = teamId[4], teamName = teamName[4]}
			self.teamInfo[2] = {url = url[1],teamId = teamId[1], teamName = teamName[1]}
		end

		-- 获取战绩比
		if self.matchType >= 5 and self.matchType <= 16 then
			ProtocolProcessorWndLeague:send_HERO_GetFightMes(self.teamInfo[1].teamId, self.matchType )
			ProtocolProcessorWndLeague:send_HERO_GetFightMes(self.teamInfo[2].teamId, self.matchType )
		end
	end


	-- 玩家位置，如果玩家位置小于3，表示玩家在前面3组，否则在后面3组
	-- 如果位于后面3组，则显示的时候需要放到前面3组，保证自己队伍位于右边
	for i = 1, #playerId do
		local info = self:createPlayerInfoData(i,playerId,playerName,playerLevel,playerSex,serviceId,pet,extranInfo,fighting,equip,headColor,bodyColor)
		if pIndex <= 3 then
			if info then info.pos = i end
			self.pInfo[i] = info
		else
			if i <= 3 then
				if info then info.pos = i + 3 end
				self.pInfo[i+3] = info
			else
				if info then info.pos = i - 3 end
				self.pInfo[i-3] = info
			end
		end
	end

	-- 更新
	self:update()
end

function SceneLeagueRoom:judgeCaptain()
	WZLog("------------judgeCaptain----------")
	local captain = WndLeagueTeamDetail:getTeamData().captain
	local playerId = CacheCenter:getPlayerInfo().id
	WZLog("--------------captain,playerId------------",captain)
	WZLog("--------------captain,playerId------------",playerId)
	local captainFlag = captain == playerId
	return captainFlag
end

-- 查找玩家位置
function SceneLeagueRoom:findPlayerIndex(playerId)
	local selfId = CacheCenter:getPlayerInfo().id
	for i = 1 , #playerId do
		if tonumber(playerId[i]) == tonumber(selfId) then
			return i
		end
	end
	return 1
end

function SceneLeagueRoom:_initTipsData()
	self.tipsData = {}
	for k,v in pairs(GDatatab_tips) do
		table.insert(self.tipsData,v)
	end

	self:_updateTips()
end

-- 创建一个玩家的数据
function SceneLeagueRoom:createPlayerInfoData(pos,playerId,playerName,playerLevel,playerSex,serviceId,pet,extranInfo,fighting,equip,headColor,bodyColor)
	-- ID为0表示没有玩家
	if tonumber(playerId[pos]) == 0 then
		return nil
	end

	local info = {}
	info.playerId = playerId[pos]
	info.playerName = playerName[pos]
	info.playerLevel = playerLevel[pos]
	info.playerSex = playerSex[pos]
	info.serverId = serviceId[pos]
	info.headColor = headColor[pos]
	info.bodyColor = bodyColor[pos]
	info.pet = json.decode(pet[pos])
	info.extranInfo = json.decode(extranInfo[pos])
	info.fighting = fighting[pos]
	info.equip = {}
	for k = 1, 5 do
		local index = (pos-1)*5+k
		table.insert(info.equip,equip[index])
	end

	return info
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
