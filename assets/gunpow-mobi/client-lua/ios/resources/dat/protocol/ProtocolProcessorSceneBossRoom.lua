--ProtocolProcessorSceneBossRoom.lua
--@brief	副本房间协议
--@date  	2013/12/10
--@author 	xiezemin
--@note 	副本房间协议


ProtocolProcessorSceneBossRoom = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneBossRoom:regAll()

	--@brief	退出房间（BOSSMAPROOM_QuitRoom = 7）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_QuitRoom, "ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom_ErrorProcess", "is" )

	--@brief	（被踢）退出房间成功（BOSSMAPROOM_QuitRoomOk = 8）
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_QuitRoomOk, "ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_QuitRoomOk", "bb")

	--@brief	邀请（BOSSMAPROOM_Invite = 22）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Invite, "ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite_ErrorProcess", "is" )
	
	--@brief	玩家准备（BOSSMAPROOM_GameReady = 16）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GameReady , "ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady_ErrorProcess", "is" )

	--@brief	玩家准备（BOSSMAPROOM_GameReadyOk = 17）
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GameReadyOk, "ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_GameReadyOk", "ib")

	--@brief	副本通知所有玩家正在随机配对对战用户（BOSSMAPROOM_MakePair = 24）
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_MakePair , "ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePair", "i")

	--@brief	副本随机配对成功同步对战玩家数据（BOSSMAPROOM_MakePairOk = 25）
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_MakePairOk, "ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePairOk", "iiivivsvsvsvsvivivivivivivivivivivivivivivivivivivivivivivsvivivsvivivivivnvivivi")

	--@brief	副本通知所有玩家正在随机配对对战用户（BOSSMAPROOM_MakePairFail = 26）
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_MakePairFail, "ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePairFail", "")

	--@brief	房主更新房间属性（BOSSMAPROOM_UpdateRoom = 12）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_UpdateRoom, "ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom_ErrorProcess", "is" )

	--@brief	房间相关协议(MAIN_BOSSMAPROOM = 18)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_UpdateSeat, "ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateSeat_ErrorProcess", "is" )

	--获取角色技能列表成功
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkillOk, "ProtocolProcessorSceneBossRoom:parse_PLAYER_GetPlayerSkillOk", "vivs")

	--@brief	副本战斗记录（BOSSMAPROOM_BossMapRecord = 29）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BossMapRecord, "ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_BossMapRecord_ErrorProcess", "is" )

	--@brief	副本战斗记录（BOSSMAPROOM_BossMapRecordOk = 30）
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BossMapRecordOk, "ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_BossMapRecordOk", "vivsvivivivivivivivivi")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorSceneBossRoom:unregAll()
	
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	退出房间（BOSSMAPROOM_QuitRoom = 7）
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom(roomId, oldSeat )
	WZLog("send_BOSSMAPROOM_QuitRoom")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_QuitRoom )
	if sender==nil then WZLog("sender == nil") return end
	
	sender:writeInt( roomId )	-- 玩家所在的房间Id
	sender:writeInt( oldSeat )	-- 玩家所在的座位位置
	SendProtocol(sender,true) --true:showLoading
end

	
--@brief	邀请（BOSSMAPROOM_Invite = 22）
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite(roomId, playerId ,assist)
	WZLog("send_BOSSMAPROOM_Invite")
	if assist == nil then
		assist  = 1
	end
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Invite )
	if sender==nil then WZLog("sender == nil") return end
	
	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( playerId )	-- 玩家Id
	sender:writeInt(assist)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	玩家准备（BOSSMAPROOM_GameReady = 16）
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady (roomId, oldSeat, ready )
	WZLog("send_BOSSMAPROOM_GameReady ")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GameReady  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 玩家所在的房间
	sender:writeInt( oldSeat )	-- 玩家所在的座位位置
	sender:writeBoolean( ready )	-- true准备，false取消准备
	SendProtocol(sender,true) --true:showLoading
end

--@brief	副本随机配对对战用户（BOSSMAPROOM_MakePair = 24）
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_MakePair(roomId )
	WZLog("send_BOSSMAPROOM_MakePair")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_MakePair )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	房主更新房间属性
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom(roomId, playerNumMode, passWord, mapId, wnersId, roomName )
	WZLog("send_BOSSMAPROOM_UpdateRoom ",type(passWord))
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_UpdateRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( playerNumMode )	-- 对战人数模式
	sender:writeString( passWord )	-- 房间密码
	sender:writeInt( mapId )	-- 房间地图id
	sender:writeInt( wnersId )	-- 房主id
    sender:writeString( roomName )	-- 房间名称
	SendProtocol(sender,false) --true:showLoading
end

--@brief	房间相关协议(MAIN_BOSSMAPROOM = 18)
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateSeat(roomId, oldSeat, newSeat )
	WZLog("send_BOSSMAPROOM_UpdateSeat")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_UpdateSeat )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( oldSeat )	-- 玩家所在的座位位置
	sender:writeInt( newSeat )	-- 玩家新座位位置
	SendProtocol(sender,false) --true:showLoading
end


--@brief	副本战斗记录（BOSSMAPROOM_BossMapRecord = 29）
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_BossMapRecord(mapNum )
	WZLog("send_BOSSMAPROOM_BossMapRecord")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BossMapRecord )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mapNum )	-- 地图id
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	副本随机配对成功同步对战玩家数据（BOSSMAPROOM_MakePairOk = 25）
function ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePairOk(battleId,mapId, playerCount, playerId, serverId, 
	playerName, playerTitle, playerCommunity, playerLevel, playerSex, maxHP, maxPF, maxSP, attack, critRate, defence, 
	injuryFree, wreckDefense, reduceCrit, power, armor, constitution, agility, lucky, headId, faceId, bodyId, weaponId, 
	wingId, item_id, skillId, playerBuffCount, buffId, petId, petParam, guaiBattleId, guaiId,tournamentLevel, 
	petLevel, colour, bodyColour,footmark)
	-- battleId : 战斗组Id
	-- mapId : 地图id
	-- playerCount : 玩家数量
	-- playerId : 所有玩家id
	-- playerName : 房间内玩家昵称
	-- playerTitle : 称号
	-- playerGuild : 公会名称
	-- playerLevel : 房间内玩家等级
	-- playerSex : 玩家性别（0男1女）
	-- maxHP : 最大血量
	-- maxPF : 最大体力值
	-- maxSP : 最大怒气
	-- attack : 普攻击力
	-- critRate : 爆击攻击力比率
	-- defence : 防御力
	-- injuryFree : 免伤(10000)
	-- wreckDefense : 破防(10000)
	-- reduceCrit : 免暴(10000)
	-- power : 力量
	-- armor : 护甲
	-- constitution : 体质
	-- agility : 敏捷
	-- lucky : 幸运
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- weaponId : 武器ID
	-- wingId : 翅膀ID
	-- item_id : 技能道具ID（0没装备，-1锁, 其他ID）
	-- playerBuffCount : 表示每一个player,buff的数量,如果没有要填零
	-- buffId : 玩家BUFFID
	-- petId : 宠物形象，空字符串表示无宠物
	-- petSkill : 宠物技能id
	-- petGift : 宠物资质
	-- guaiBattleId : 在本次对战中的独立id,每一个怪都不一样,如果是被招出来的怪是-1,即一开始不在对战出现
	-- guaiId : 怪在怪表中的id
	-- tournamentLevel : 竞技等级
	WZLog("ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePairOk")

	local locData = GDatatab_team_map["id_"..mapId]
	if locData.map_num == 0 then
		SceneMarryCopy:receiveMakePairOk(VectorToTable(battleId),
			VectorToTable(mapId),
			VectorToTable(playerCount),
			VectorToTable(playerId),
			VectorToTable(serverId),
			VectorToTable(playerName),
			VectorToTable(playerTitle),
			VectorToTable(playerCommunity),
			VectorToTable(playerLevel),
			VectorToTable(playerSex),
			VectorToTable(maxHP),
			VectorToTable(maxPF),
			VectorToTable(maxSP),
			VectorToTable(attack),
			VectorToTable(critRate),
			VectorToTable(defence),
			VectorToTable(injuryFree),
			VectorToTable(wreckDefense),
			VectorToTable(reduceCrit),
			VectorToTable(power),
			VectorToTable(armor),
			VectorToTable(constitution),
			VectorToTable(agility),
			VectorToTable(lucky),
			VectorToTable(headId),
			VectorToTable(faceId),
			VectorToTable(bodyId),
			VectorToTable(weaponId),
			VectorToTable(wingId),
			VectorToTable(item_id),
			VectorToTable(playerBuffCount),
			VectorToTable(buffId),
			VectorToTable(petId),
			VectorToTable(skillId),
			VectorToTable(petParam),
			VectorToTable(guaiBattleId),
			VectorToTable(guaiId),
			VectorToTable(tournamentLevel),
			VectorToTable(petLevel),
			VectorToTable(colour),
			VectorToTable(bodyColour),
			VectorToTable(footmark))
	else
		SceneBossRoom:receiveMakePairOk(VectorToTable(battleId),
			VectorToTable(mapId),
			VectorToTable(playerCount),
			VectorToTable(playerId),
			VectorToTable(serverId),
			VectorToTable(playerName),
			VectorToTable(playerTitle),
			VectorToTable(playerCommunity),
			VectorToTable(playerLevel),
			VectorToTable(playerSex),
			VectorToTable(maxHP),
			VectorToTable(maxPF),
			VectorToTable(maxSP),
			VectorToTable(attack),
			VectorToTable(critRate),
			VectorToTable(defence),
			VectorToTable(injuryFree),
			VectorToTable(wreckDefense),
			VectorToTable(reduceCrit),
			VectorToTable(power),
			VectorToTable(armor),
			VectorToTable(constitution),
			VectorToTable(agility),
			VectorToTable(lucky),
			VectorToTable(headId),
			VectorToTable(faceId),
			VectorToTable(bodyId),
			VectorToTable(weaponId),
			VectorToTable(wingId),
			VectorToTable(item_id),
			VectorToTable(playerBuffCount),
			VectorToTable(buffId),
			VectorToTable(petId),
			VectorToTable(skillId),
			VectorToTable(petParam),
			VectorToTable(guaiBattleId),
			VectorToTable(guaiId),
			VectorToTable(tournamentLevel),
			VectorToTable(petLevel),
			VectorToTable(colour),
			VectorToTable(bodyColour),
			VectorToTable(footmark))
	end



	---[[
	WZLog("ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePairOk","\n\nbattleId",

		Serialize(VectorToTable(battleId)),Serialize(VectorToTable(mapId)),Serialize(VectorToTable(playerCount)),Serialize(VectorToTable(playerId)),Serialize(VectorToTable(playerName)),Serialize(VectorToTable(playerTitle)),Serialize(VectorToTable(playerCommunity)),"\n\nplayerLevel",

		Serialize(VectorToTable(playerLevel)),Serialize(VectorToTable(playerSex)),Serialize(VectorToTable(maxHP)),Serialize(VectorToTable(maxPF)),Serialize(VectorToTable(maxSP)),Serialize(VectorToTable(attack)),Serialize(VectorToTable(critRate)),Serialize(VectorToTable(defence)),Serialize(VectorToTable(injuryFree)),"\n\nwreckDefense",

		Serialize(VectorToTable(wreckDefense)),Serialize(VectorToTable(reduceCrit)),Serialize(VectorToTable(power)),Serialize(VectorToTable(armor)),Serialize(VectorToTable(constitution)),Serialize(VectorToTable(agility)),Serialize(VectorToTable(lucky)),"\n\nheadId",

		Serialize(VectorToTable(headId)),Serialize(VectorToTable(faceId)),Serialize(VectorToTable(bodyId)),Serialize(VectorToTable(weaponId)),Serialize(VectorToTable(wingId)),Serialize(VectorToTable(item_id)),Serialize(VectorToTable(playerBuffCount)),Serialize(VectorToTable(buffId)),"\n\npetId",

		Serialize(VectorToTable(petId)),Serialize(VectorToTable(petParam)),Serialize(VectorToTable(guaiBattleId)),Serialize(VectorToTable(guaiId)),Serialize(VectorToTable(tournamentLevel)),
        "\npetLevel:", Serialize(VectorToTable(petLevel)),
			Serialize(VectorToTable(colour)),
			Serialize(VectorToTable(bodyColour)))
	--]]
end

--@brief	玩家准备（BOSSMAPROOM_GameReadyOk = 17）
function ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_GameReadyOk(roomId, ready)
	-- ready : true准备，false取消准备
	WZLog("ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_GameReadyOk")
	WZLog("roomId : ", roomId);
	WZLog("ready : ", ready);
	
end

--@brief	副本通知所有玩家正在随机配对对战用户（BOSSMAPROOM_MakePair = 24）
function ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePair(roomId)
	-- roomId : 房间Id
	WZLog("ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePair ")
	if SceneMarryCopy.m_root then
		SceneMarryCopy:receiveMakePairring(roomId)
	else
		SceneBossRoom:receiveMakePairring(roomId)
	end
end

--@brief	被踢出房间成功（BOSSMAPROOM_QuitRoomOk = 8）
function ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_QuitRoomOk(isInitiative,bDissolution)
    -- isInitiative : 是否主动退出
    -- bDissolution : 是否解散房间
	WZLog("ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_QuitRoomOk ")
    --[[GlobalGame.g_tSysConfig.cartonTab = 1
	replaceScene(SceneIsland:createElement());
    SceneCarton:onJumpToSceneCarton()]]

	if SceneMarryCopy.m_root then
		ProtocolProcessorWndMarry:send_WEDDING_GetMarryInfo()
		WndMarryManager:createLoading()
		return
	else
		SceneBossRoom:exitMulRoom()
		if isInitiative then
			DelayCallFunction(function ()
				MsgBoxManager:showTipBox(LocalStrings.BOOSROOM_KICKEDOUT)
			end,nil,0.5)
		elseif bDissolution then
			DelayCallFunction(function ()
				MsgBoxManager:showTipBox(LocalStrings.ROOM_BEINVITED_5)
			end,nil,0.5)
		end
	end
end

--@brief	副本战斗记录（BOSSMAPROOM_BossMapRecordOk = 30）
function ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_BossMapRecordOk(playerId, playerName, level, headId, faceId, fight, sex, difficulty, recordId, mapId,headColor)
	-- playerId : 玩家Id
	-- playerName : 玩家名称
	-- level : 等级
	-- headId : 头像Id
	-- faceId : 脸部Id
	-- fight : 战斗力
	-- sex : 性别
	-- difficulty : 难度
	-- recordId : 战斗Id
	-- mapId : 地图id
	WZLog("ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_BossMapRecordOk")
	WndMultiCopy:initVideoData(playerId, playerName, level, headId, faceId, fight, sex, difficulty,recordId,mapId,headColor)
end
------------------------------------------------------------------------------------------------

--@brief	退出房间（BOSSMAPROOM_QuitRoom = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_QuitRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_QuitRoom, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	邀请（BOSSMAPROOM_Invite = 22）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_Invite_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_Invite, nflag, sMessage)
	DelayCallFunction(function() MsgBoxManager:showTipBox(sMessage) end, nil, 1.5)
end

--@brief	玩家准备（BOSSMAPROOM_GameReady = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_GameReady _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GameReady , nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	副本随机配对对战用户（BOSSMAPROOM_MakePair = 24）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_MakePair_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_MakePair_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_MakePair, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	副本通知所有玩家正在随机配对对战用户（BOSSMAPROOM_MakePairFail = 26）
function ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePairFail()
	WZLog("ProtocolProcessorSceneBossRoom:parse_BOSSMAPROOM_MakePairFail")
	SceneBossRoom:receiveMakePairFail()
end

--@brief	房主更新房间属性（BOSSMAPROOM_UpdateRoom = 12）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_UpdateRoom, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	房间相关协议(MAIN_BOSSMAPROOM = 18)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateSeat_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_UpdateSeat_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_UpdateSeat, nflag, sMessage)
    MsgBoxManager:showTipBox(sMessage)
end

--@brief	获取角色技能列表成功
function ProtocolProcessorSceneBossRoom:parse_PLAYER_GetPlayerSkillOk(itemId,skillExplain)
	-- count : 数量
	-- id : 道具序号
	WZLog("ProtocolProcessorSceneBossRoom:parse_PLAYER_GetPlayerSkillOk ")
    SceneBossRoom:receiveGetPlayerSkillOk(VectorToTable(itemId), VectorToTable(skillExplain))
end

--@brief	副本战斗记录（BOSSMAPROOM_BossMapRecord = 29）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_BossMapRecord_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneBossRoom:send_BOSSMAPROOM_BossMapRecord_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BossMapRecord, nflag, sMessage)
end
