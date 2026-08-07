--ProtocolProcessorBossMap.lua
--@brief	副本相关协议
--@date  	2013/1/14
--@author 	林庆凯
--@note 	副本冒险相关协议


ProtocolProcessorBossMap = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------


--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorBossMap:regAll() 
     --@brief	进入房间成功（BOSSMAPROOM_EnterRoomOk = 6）
     self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk", "issiiiivbvivivsvivbvivivivivsvivivivivsvsvivissssssvivivivivivivivivivivitvsviviivi")

    --@brief	返回房间列表
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetRoomListOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_GetRoomListOk", "ivivivivsvivbvivsi")

    
	--@brief	获取房间列表（BOSSMAPROOM_GetRoomList = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetRoomList, "ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList_ErrorProcess", "is" )

	--@brief	进入房间（BOSSMAPROOM_EnterRoom = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoom, "ProtocolProcessorBossMap:send_BOSSMAPROOM_EnterRoom_ErrorProcess", "is" )

	--@brief	查找房间（BOSSMAPROOM_SelectRoom = 14）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_SelectRoom, "ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom_ErrorProcess", "is" )

    
    --@brief	创建房间错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_CreateRoom, "ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom_ErrorProcess", "is" )
	
	--@brief	快速游戏（BOSSMAPROOM_QuickGame = 13）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_QuickGame, "ProtocolProcessorBossMap:send_BOSSMAPROOM_QuickGame_ErrorProcess", "is" )

	--@brief	找到房间需要密码（BOSSMAPROOM_SelectRoomOk = 15）
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_SelectRoomOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_SelectRoomOk", "is")

    --@brief	重置副本挑战次数成功
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_ResetMapOk, "ProtocolProcessorBossMap:parse_BOSSMAPROOM_ResetMapOk", "ii")

	--@brief	重置副本挑战次数错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_ResetMap, "ProtocolProcessorBossMap:send_BOSSMAPROOM_ResetMap_ErrorProcess", "is" )

end 


--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorBossMap:unregAll()
	self:clearReg()
end



-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	创建房间
function ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom(bossMapId, passWord, battleMode)
	WZLog("send_BOSSMAPROOM_CreateRoom", bossMapId, passWord, battleMode)
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_CreateRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( bossMapId )	-- 副本地图Id
	sender:writeString( passWord )	-- 房间密码
	sender:writeInt(battleMode)	-- 战斗模式 15双人修炼塔 16岛主挑战
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取房间列表（BOSSMAPROOM_GetRoomList = 3）
function ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList( mapId )
	WZLog("send_BOSSMAPROOM_GetRoomList")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetRoomList )
	if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( mapId )	-- 房间地图id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	进入房间（BOSSMAPROOM_EnterRoom = 5）
function ProtocolProcessorBossMap:send_BOSSMAPROOM_EnterRoom(roomId , mapId)
	WZLog("send_BOSSMAPROOM_EnterRoom")

	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoom )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( roomId )	-- 房间Id
	sender:writeInt( mapId )	-- 地图Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	查找房间（BOSSMAPROOM_SelectRoom = 14）
function ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId, passWord, mapId,roomChannel, assist)
	if assist == nil then
		assist = 0
	end
	WZLog("send_BOSSMAPROOM_SelectRoom =", mapId, assist)
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_SelectRoom )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( roomId )	-- 房间Id
	sender:writeString( passWord )	-- 房间密码，"-1"为没有密码
	sender:writeInt( mapId )	-- 地图ID
	sender:writeInt(roomChannel) --房间频道
--	sender:writeInt(assist) --是否助战（0：否）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	快速游戏（BOSSMAPROOM_QuickGame = 13）
function ProtocolProcessorBossMap:send_BOSSMAPROOM_QuickGame(mapId )
	WZLog("send_BOSSMAPROOM_QuickGame")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_QuickGame )
	if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( mapId )	-- 房间地图id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	重置副本挑战次数
function ProtocolProcessorBossMap:send_BOSSMAPROOM_ResetMap(mapId )
	WZLog("send_BOSSMAPROOM_ResetMap")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_ResetMap )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( mapId )	-- 地图id
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	进入房间成功（BOSSMAPROOM_EnterRoomOk = 6）
function ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk(roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId, serviceId, playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel, vipLevel, player_title, qualifyingLevel, zsleve, playerStar, playerFighting, pet, extranInfo, playerHeadColour, playerBodyColour, mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, winNum, playNum, tournamentExp, skillId, matchLevel, matchscore, joinTimes, winTimes, continuousWinTimes,assist,assistTimesState, floorState, useMountsMes, professionId, topMapId, roomAssist, openStatus)
	-- roomId : 房间Id
	-- passWord : 房间密码
	-- roomName : 房间名称
	-- playerNumMode : 对战人数
	-- mapId : 房间地图id
	-- wnersId : 房主id
	-- playerNum : 房间座位数量
	-- seatUsed : 该座位是否使用
	-- playerId : 房间内玩家id
	-- serviceId : 房间内玩家所在服id
	-- playerName : 房间内玩家昵称
	-- playerLevel : 房间内玩家等级
	-- playerReady : 玩家是否已准备
	-- playerSex : 玩家性别
	-- playerEquipment : 玩家身上的装备
	-- playerEquipmentLevel : 玩家装备等级
	-- vipLevel : vip等级
	-- player_title : 玩家称号
	-- qualifyingLevel : 排位等级
	-- zsleve : 玩家转生等级
	-- playerStar : 房间内玩家的副本星级
	-- playerFighting : 房间内玩家的战斗力
	-- pet : 房间内玩家的宠物信息
	-- extranInfo : 装备扩展信息(武器)
	-- playerHeadColour : 房间内玩家的头颜色
	-- playerBodyColour : 房间内玩家的身颜色
	-- mentoringStr : 师徒关系(id|id,id|id)
	-- coupleStr : 夫妻关系(id|id,id|id)
	-- chumStr : 密友关系(id|id,id|id)
	-- coupleNum : 夫妻恩爱值(恩爱值|恩爱等级,恩爱值|恩爱等级)
	-- chumNum : 密友关系(好友值,好友值)
	-- mentoringNum : 师德值(好友值|师德等级,好友值|师德等级)
	-- winNum : 胜利场次
	-- playNum : 战斗场次
	-- tournamentExp : 竞技积分
	-- skillId : 携带技能id
	-- matchLevel : 排位赛等级
	-- matchscore : 排位赛积分
	-- joinTimes :  赛季参与次数
	-- winTimes : 赛季胜利次数
	-- continuousWinTimes : 赛季当前连胜次数
	-- assist ：是否助战（1为助战）
	-- assistTimesState ：赏金次数状态（1增加赏金次数；0不增加）
	-- floorState ：关卡条件状态（三位二进制位标识三个条件完成情况）
	-- useMountsMes ：使用中的坐骑信息
	-- professionId : 职业Id
	-- topMapId : 获取组队副本指定关卡可挑战的最高难道副本ID
	-- roomAssist : 房间是否赏金 1为赏金  负值表示岛主副本
	-- openStatus : 转职状态 0未开启，1开启一转，2开启二转
	WZLog("ProtocolProcessorBossMap:parse_BOSSMAPROOM_EnterRoomOk",Serialize(VectorToTable(assist)), Serialize(VectorToTable(assistTimesState)), type(floorState))
    if GlobalGame.g_bIfInBattle then
        if WndMultiWin.m_root and WndMultiWin:canBackRoom() == false then
            return
        elseif WndMultiLose.m_root and WndMultiLose:canBackRoom() == false then
            return
        end
    end
    
    local inroom = false
	for i,id in pairs(VectorToTable(playerId)) do
		if id == CacheCenter:getPlayerInfo().id then
			inroom = true
		end
	end

	if AutoRunBattleConst.AUTO_RUN_BATTLE and AutoRunBattleConst.Boss_Room_Enter then
		AutoRunBattleConst.Boss_Room_Enter = false
		if WndMultiWin.m_root or WndMultiLose.m_root then
			inroom = false
		end
	end

	if roomAssist < 0 then --岛主挑战
		if WndSingleCopyInfo.m_root == nil then
	        if CopyManager:bJumpToSingleCopy(mapId) then
	            SceneCopy:showScene(1, nil, mapId, false, nil, nil, nil, 2)
	        end
	    end

		WndSingleCopyInfo:receiveEnterRoomOk(
					roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum,VectorToTable(seatUsed),VectorToTable(playerId),VectorToTable(serviceId),VectorToTable(playerName),VectorToTable(playerLevel),VectorToTable(playerReady),VectorToTable(playerSex),VectorToTable(playerEquipment),VectorToTable(playerEquipmentLevel),
					VectorToTable(vipLevel),VectorToTable(player_title),VectorToTable(qualifyingLevel),VectorToTable(zsleve),VectorToTable(playerStar),VectorToTable(playerFighting),VectorToTable(pet),VectorToTable(extranInfo),VectorToTable(playerHeadColour),VectorToTable(playerBodyColour),mentoringStr, coupleStr, chumStr, coupleNum, chumNum,mentoringNum,VectorToTable(matchLevel),VectorToTable(matchscore),VectorToTable(joinTimes),VectorToTable(winTimes),VectorToTable(continuousWinTimes),VectorToTable(serviceId),VectorToTable(assist), VectorToTable(assistTimesState), floorState)

	else
		local localData = GDatatab_team_map["id_"..mapId]
		if localData and localData.map_num == 0 then
			-- 夫妻副本
			if inroom then
				-- local loveId = SceneMarryWedding:getLoveId()
				-- WZLog("-----------loveId-------------12",loveId)
				-- SceneMarryCopy:showScene(loveId)
				SceneMarryCopy:showScene()
				SceneMarryCopy:setMerryRoomData(
					roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, seatUsed, playerId,serviceId,
					playerName, playerLevel, playerReady, playerSex, playerEquipment, playerEquipmentLevel,
					vipLevel, player_title, qualifyingLevel, zsleve, playerStar,playerFighting,pet,extranInfo,playerHeadColour,playerBodyColour,
					mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum)
			else
				local scene = SceneMarryWedding:createElement()
				replaceScene(scene)
			end
		else
			-- 组队副本
			local mapData = GDatatab_grouptower_map["id_" .. mapId]
			if mapData then 
				if WndDoubleTowerRoom.m_root == nil then
					if inroom == true then
						WndDoubleTowerRoom:showInterface()
					else
						--跳转到多人副本界面
						SceneCopy:showScene(4, 2)
						return
					end
				end

				WndDoubleTowerRoom:receiveEnterRoomOk(
					roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum,VectorToTable(seatUsed),VectorToTable(playerId),VectorToTable(serviceId),VectorToTable(playerName),VectorToTable(playerLevel),VectorToTable(playerReady),VectorToTable(playerSex),VectorToTable(playerEquipment),VectorToTable(playerEquipmentLevel),
					VectorToTable(vipLevel),VectorToTable(player_title),VectorToTable(qualifyingLevel),VectorToTable(zsleve),VectorToTable(playerStar),VectorToTable(playerFighting),VectorToTable(pet),VectorToTable(extranInfo),VectorToTable(playerHeadColour),VectorToTable(playerBodyColour),mentoringStr, coupleStr, chumStr, coupleNum, chumNum,mentoringNum,VectorToTable(matchLevel),VectorToTable(matchscore),VectorToTable(joinTimes),VectorToTable(winTimes),VectorToTable(continuousWinTimes),VectorToTable(serviceId),VectorToTable(assist), VectorToTable(assistTimesState), floorState)
			else
				if SceneBossRoom.m_root == nil then
					if inroom == true then
						local sceneBossRoom = SceneBossRoom:createElement()
						replaceScene(sceneBossRoom)
					else
						--跳转到多人副本界面
						SceneCopy:showScene(2)
						return
					end
				end

				SceneBossRoom:receiveEnterRoomOk(
					roomId, passWord, roomName, playerNumMode, mapId, wnersId, playerNum, VectorToTable(seatUsed), VectorToTable(playerId), VectorToTable(serviceId), VectorToTable(playerName), VectorToTable(playerLevel), VectorToTable(playerReady), VectorToTable(playerSex),VectorToTable(playerEquipment),VectorToTable(playerEquipmentLevel),
					VectorToTable(vipLevel),VectorToTable(player_title),VectorToTable(qualifyingLevel),VectorToTable(zsleve),VectorToTable(playerStar),VectorToTable(playerFighting),VectorToTable(pet),VectorToTable(extranInfo),VectorToTable(playerHeadColour),VectorToTable(playerBodyColour), mentoringStr, coupleStr, chumStr, coupleNum, chumNum, mentoringNum, VectorToTable(matchLevel), VectorToTable(matchscore), VectorToTable(joinTimes),VectorToTable(winTimes),VectorToTable(continuousWinTimes),VectorToTable(serviceId), VectorToTable(assist), VectorToTable(assistTimesState), VectorToTable(useMountsMes), VectorToTable(professionId), VectorToTable(topMapId), roomAssist, VectorToTable(openStatus))
			end
		end
	end
end

--@brief	返回房间列表
function ProtocolProcessorBossMap:parse_BOSSMAPROOM_GetRoomListOk(roomCount, roomId, battleStatus, playerCountNum, passWord, playerNum, roomStaus, mapId, roomName, assist)
	-- roomCount : 房间数量
	-- roomId : 房间Id数组
	-- battleStatus : 房间状态数组（0是等待中，1是战斗中）
	-- playerCountNum : 房间对战人数
	-- passWord : 房间密码数组
	-- playerNum : 房间当前人数数组
	-- roomStaus : 房间是否已满（true是已满，false未满）
	-- mapId : 房间地图id
    -- roomName : 房间名称
    -- assist : 助战（玩家还有助战次数标记1可助战）
	WZLog("ProtocolProcessorBossMap:parse_BOSSMAPROOM_GetRoomListOk", assist)
    WndMultiCopy:getRoomListOk({
        roomCount = roomCount,
        roomId = VectorToTable(roomId),
        battleStatus = VectorToTable(battleStatus),
        playerCountNum = VectorToTable(playerCountNum),
        passWord = VectorToTable(passWord),
        playerNum = VectorToTable(playerNum),
        roomStaus = VectorToTable(roomStaus),
        mapId = VectorToTable(mapId),
        roomName = VectorToTable(roomName),
        assist = assist,
    })
end

--@brief	找到房间需要密码（BOSSMAPROOM_SelectRoomOk = 15）
function ProtocolProcessorBossMap:parse_BOSSMAPROOM_SelectRoomOk(roomId, passWord)
	-- roomId : 房间Id
	-- passWord : 房间密码
	WZLog("ProtocolProcessorBossMap:parse_BOSSMAPROOM_SelectRoomOk")
end

--@brief	重置副本挑战次数成功
function ProtocolProcessorBossMap:parse_BOSSMAPROOM_ResetMapOk(mapId, resetTime)
	-- mapId : 地图id
	-- resetTime : 玩家副本重置次数
	WZLog("ProtocolProcessorBossMap:parse_BOSSMAPROOM_ResetMapOk")
    --更新缓存中心
    CacheCenter:resetMultiCopySuccess(mapId, resetTime)
    --WndResetCopy:resetSuccess()
end

-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	创建房间（BOSSMAPROOM_CreateRoom = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorBossMap:send_BOSSMAPROOM_CreateRoom_ErrorProcess")
	WndMultiCopy:closeLoadingBox()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_CreateRoom, nflag, sMessage)
end

--@brief	获得房间信息（BOSSMAPROOM_GetRoomInfo = 20）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomInfo_ErrorProcess")
	WndMultiCopy:closeLoadingBox()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetRoomInfo, nflag, sMessage)
end

--@brief	获取房间列表（BOSSMAPROOM_GetRoomList = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList_ErrorProcess")
	WndMultiCopy:closeLoadingBox()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_GetRoomList, nflag, sMessage)
    --MsgBoxManager:showTipBox(sMessage)
end

--@brief	进入房间（BOSSMAPROOM_EnterRoom = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorBossMap:send_BOSSMAPROOM_EnterRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorBossMap:send_BOSSMAPROOM_EnterRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_EnterRoom, nflag, sMessage)
	--MsgBoxManager:showTipBox(sMessage)
    WndBossHall:getEnterRoomErrorProcess(nFlag,sMessage)
    WndBossHall.m_bIsEnterRoom = false
	WndMultiCopy:closeLoadingBox()
end

--@brief	查找房间（BOSSMAPROOM_SelectRoom = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom_ErrorProcess(nFlag, sMessage)
	WZLog(" ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom_ErrorProcess")
	WndMultiCopy:closeLoadingBox()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_SelectRoom, nflag, sMessage)
end

--@brief	快速游戏（BOSSMAPROOM_QuickGame = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorBossMap:send_BOSSMAPROOM_QuickGame_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorBossMap:send_BOSSMAPROOM_QuickGame_ErrorProcess")
	WndMultiCopy:closeLoadingBox()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_QuickGame, nflag, sMessage)
	--MsgBoxManager:showTipBox(sMessage)
    WndBossHall.m_bIsEnterRoom = false
end

--@brief	重置副本挑战次数错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorBossMap:send_BOSSMAPROOM_ResetMap_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorBossMap:send_BOSSMAPROOM_ResetMap_ErrorProcess")
	WndMultiCopy:closeLoadingBox()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_ResetMap, nflag, sMessage)
    --MsgBoxManager:showTipBox(sMessage)
end

