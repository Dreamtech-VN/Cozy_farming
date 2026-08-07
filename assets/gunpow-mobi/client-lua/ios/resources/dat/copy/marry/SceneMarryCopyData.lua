--SceneMarryCopyData.lua
--@brief	SceneMarryCopy的数据模块
--@date		2016-7-17
--@author	binshao
--@note		夫妻副本房间

SceneMarryCopy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneMarryCopy:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bShowTipsSkillProp = false	--显示技能道具提示
	self.seatCell = {}		-- 座位cell
	self.allFight = 0		-- 玩家的总战力
	self.selDiff = nil
	self.topCell = {}		-- UI上方cell
	self.heartBeat = nil	-- 心跳
	self.roomData = nil		-- 房间数据
	self.copyData = {}		-- 副本本地数据
	self.loveId = nil		-- 夫妻对方的ID
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneMarryCopy:_unInit()
	self.m_root = nil
	self.m_bShowTipsSkillProp = nil
	self.seatCell = nil
	self.allFight = 0
	self.selDiff = nil
	self.topCell = nil
	self.heartBeat = nil
	self.roomData = nil			--场景ui信息
	self.copyData = {}
	self.loveId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneMarryCopy:createElement()
	local element = WZUISystem:getInstance():createElement("SceneMarryCopy")
	assert(element, "SceneMarryCopy create element failed!")
	self:_init()
	return element
end


-- 获取夫妻对方的ID和房间ID
function SceneMarryCopy:getLoveIdAndRoomId()
	return self.roomData.roomId,self.loveId
end

--@brief  设置副本房间数据信息
function SceneMarryCopy:setMerryRoomData(roomId, passWord, roomName, playerNumMode, mapId, wnersId,
	playerNum, seatUsed, playerId, serverId,playerName, playerLevel, playerReady, playerSex,
	playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel, zsleve,
	playerStar,playerFighting,pet,extranInfo,headColor,bodyColor,mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum)
	WZLog("SceneMarryCopy:setMerryRoomData",roomId,passWord,roomName,playerNumMode,mapId,wnersId,playerNum)
	local localData = GDatatab_team_map["id_"..mapId]
	self.roomData = {
        roomId = roomId,
        passWord = passWord,
        roomName = roomName,
		playerNumMode = playerNumMode,
		mapId = mapId,
		wnersId = wnersId,
		playerNum = playerNum,
		seatUsed = VectorToTable(seatUsed),
		playerId = VectorToTable(playerId),
		serverId = VectorToTable(serverId),
		playerName = VectorToTable(playerName),
		playerLevel = VectorToTable(playerLevel),
		playerReady = VectorToTable(playerReady),
		playerSex = VectorToTable(playerSex),
		playerEquipment = VectorToTable(playerEquipment),
		playerEquipmentLevel = VectorToTable(playerEquipmentLevel),
		vipLevel = VectorToTable(vipLevel),
		playerTitle = VectorToTable(player_title),
		qualifyingLevel = VectorToTable(qualifyingLevel),
		zsleve = VectorToTable(zsleve),
		playerStar = VectorToTable(playerStar),
      	playerFighting = VectorToTable(playerFighting),
      	pet = VectorToTable(pet),
      	extranInfo = VectorToTable(extranInfo),
		headColor = VectorToTable(headColor),
		bodyColor = VectorToTable(bodyColor),
        difficulty = localData.difficulty,
        mapName = localData.map_name,
	}

	-- 当前队伍的战斗力
	self.allFight = 0
	local fightTab = VectorToTable(playerFighting)
	for k,v in pairs(fightTab) do
		self.allFight = self.allFight + v
	end
	WZLog("cur--------------fight",self.allFight)


	self:_shieldClick()
    self:_update()
end 

--@brief	正在匹配中
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneMarryCopy:receiveMakePairring(roomId)
	WZLog("SceneMarryCopy:receiveMakePairring")
end

--@brief	匹配失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneMarryCopy:receiveMakePairFail()
	WZLog("SceneMarryCopy:receiveMakePairFail")
	MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_MATCH_FAILED)
	self:_update()
end

--@brief	匹配完成
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneMarryCopy:receiveMakePairOk(battleId, mapId, playerCount, playerId, serverId, playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount, buffId, petId, petSkill,petParam, guaiBattleId, guaiId,tournamentLevel,petLevel, colour, bodyColour,footmark)
    WZLog("SceneMarryCopy:receiveMakePairOk")
    WBattleGlobal:getCurrent():destroy()
    WBattleGlobal:getCurrent().m_tMakePairOk = {
    battleId=battleId, battleMull=false, battleChannle=-1,mapId=mapId,playerCount=playerCount,playerId=playerId, serverId=serverId,playerName=playerName,

    playerTitle=playerTitle,playerCommunity=playerCommunity,playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,

    critRate=critRate,defence=defence,injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,power=power,armor=armor,

    constitution=constitution,agility=agility,lucky=lucky,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,

    playerBuffCount=playerBuffCount,buffId=buffId,petId=petId,petSkill=petSkill,petLevel=petLevel, petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId, battleMode=BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_2,tournamentLevel=tournamentLevel, colour=colour, bodyColour=bodyColour,footmark = footmark}


    WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODE_LOVE_STAGE
    --保存标记，游戏中获取装备时，等自动跳转会副本界面时才弹装备提示
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    self.m_toBattleLoadingScene = true
    replaceScene(SceneBattleLoading:createElement())
end

--@brief    玩家被邀请进入副本房间
function SceneMarryCopy:beInvited(roomId , playerName,mapId,password,roomChannel)
	WZLog("SceneMarryCopy:beInvited")
    local data = GDatatab_team_map["id_"..mapId]
    -- 获取房间难度
    local diff = 1
    for k,v in pairs(GDatatab_team_map) do
        if v.id == mapId then
            diff = v.difficulty
            break
        end
    end
    local diffName = {LocalStrings.COMMON,LocalStrings.DIFFICULTY,LocalStrings.HELL}
	local desc = string.format(LocalStrings.ROOM_BEINVITED,playerName,data.map_name,diffName[diff])
	WndInvited:showInterface( self , self.send_EnterRoom , roomId ,password, mapId,desc,playerName,nil,nil,roomChannel)
end

--@brief    被邀请时，确定按钮的回调  (发送进入房间的协议)
function SceneMarryCopy:send_EnterRoom(roomId,roomChannel,password,mapId)
	WZLog("SceneMarryCopy:send_EnterRoom ")
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end
	ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId,password,mapId,roomChannel)
end

--@brief	玩家技能
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneMarryCopy:receiveGetPlayerSkillOk(itemId,skillExplain)
	WZLog("SceneMarryCopy:receiveGetPlayerSkillOk")
	-- if WndSkillProp.m_root ~= nil then
	-- 	WZLog("WndSkillProp.m_root ~= nil")
	-- 	self.m_bShowTipsSkillProp = false
	-- else
	-- 	for i=1,#itemId do
	-- 		if itemId[i] == 0 then
	-- 			self.m_bShowTipsSkillProp = true
	-- 		end
	-- 	end
	-- end
	self:_updateTips()
end

--@brief	玩家道具
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneMarryCopy:receiveGetPlayerPropOk(count, id, name, icon, priceCostGold, desc, itemMainType, itemSubType, param1, param2, tireValue, consumePower, specialAttackType, specialAttackParam)
	WZLog("SceneMarryCopy:receiveGetPlayerPropOk")
	-- if WndSkillProp.m_root ~= nil then
	-- 	WZLog("WndSkillProp.m_root ~= nil")
	-- 	self.m_bShowTipsSkillProp = false
	-- else
	-- 	for i=1,count do
	-- 		if id[i] == 0 then
	-- 			self.m_bShowTipsSkillProp = true
	-- 		end
	-- 	end
	-- end
	self:_updateTips()
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

-- 初始化地图数据
-- 地图关卡数据 stage = {{简单难度},{困难难度},{地狱难度}}
-- self.copyData = {{stage1}，{stage2}，...}
function SceneMarryCopy:_initCopyData()
	-- 初始化本地数据和玩家初始数据
	local sIndex = 1	-- 开始下标
	self.copyData = {}
	for i,v in pairs(GDatatab_team_map) do
		local mapNum,mapDif = v.map_num,v.difficulty
		if mapNum <= 0 then
			local index = self:findIndexByMapNum(mapNum)	-- 当前副本数据是否存在
			if index then
				self.copyData[index][mapDif] = v
			else
				self.copyData[sIndex] = {}
				self.copyData[sIndex].userData = { mapId = mapNum, passTime = 0, starLevel = 0 }
				self.copyData[sIndex][mapDif] = v
				sIndex = sIndex + 1
			end
		end
	end

	--从缓存中心读取用户数据，更新用户数据
	local ccData = CacheCenter:getMultiCopyData()
	for i,v in ipairs(ccData) do
		local curIndex = SceneMarryCopy:findIndexByMapNum(v.mapId)
		if curIndex and self.copyData[curIndex] then
			self.copyData[curIndex].userData = v
		end
	end

	-- 重置次数
	self.copyData.resetTime = ccData.resetTime

	-- 体力和次数
	self:initPlayCntAndPower()
end

-- 寻找当前的mapNum数据是否创建
function SceneMarryCopy:findIndexByMapNum(mapNum)
    --最大4个
    local nMaxDif = 0
    for k,v in pairs(GDatatab_team_map) do
        if tonumber(v.map_num) == 0 and nMaxDif < 4 then
            nMaxDif = nMaxDif + 1
        end
    end
	for i = 1, #self.copyData do
		local data = self.copyData[i]
		for dif = 1, nMaxDif do
			if data[dif] then
				if data[dif].map_num == mapNum then
					return i
				end
				break
			end
		end
	end
	return nil
end

-- 获取当前副本的mapID
function SceneMarryCopy:getCurMarryCopyMapId()
	-- 从缓存中心拿去夫妻副本的数据
	local starLv = 0
	local ccData = CacheCenter:getMultiCopyData()
	for k,v in ipairs(ccData) do
		if 0 == v.mapId  then
			starLv = v.starLevel
		end
	end

    --最大4个
    local nMaxDif = 0
    for k,v in pairs(GDatatab_team_map) do
        if tonumber(v.map_num) == 0 and nMaxDif < 4 then
            nMaxDif = nMaxDif + 1
        end
    end
	for k,v in pairs(GDatatab_team_map) do
		local mapNum,mapDif = v.map_num,v.difficulty
		local nextLv = starLv == nMaxDif and nMaxDif or starLv + 1
		if mapNum == 0 and mapDif == nextLv then
			return v.id
		end
	end
end

--brief    获取地图难度
function SceneMarryCopy:_getDifficult()
	local tCopyData = GDatatab_team_map["id_"..self.roomData.mapId]
	return tCopyData.difficulty
end

-- 根据难度获取地图id
function SceneMarryCopy:_getMapIdByDifficult(nDifficult)
	local tCopyData = GDatatab_team_map["id_"..self.roomData.mapId]
	for i,v in pairs(GDatatab_team_map) do
		if v.map_num == tCopyData.map_num and v.difficulty == nDifficult then
			return v.id
		end
	end
end
-------------------------------------私有方法模块End---------------------------------------