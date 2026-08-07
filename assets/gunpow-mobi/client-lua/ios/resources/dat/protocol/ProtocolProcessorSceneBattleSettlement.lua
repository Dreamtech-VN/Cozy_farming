--ProtocolProcessorBattleSettlement.lua
--@brief	战斗结算协议
--@date  	2014/2/13
--@author 	xiezemin
--@note 	战斗结算使用的协议


ProtocolProcessorBattleSettlement = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorBattleSettlement:regAll()
	--进入房间成功                                                                                                                                
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_EnterRoomOk, "ProtocolProcessorBattleSettlement:parse_ROOM_EnterRoomOk", "iiiiiiiiiivbvivivsvivbvivivivivsssvivsvivivivsvivsvivsvivissssssvivivivivi")
	--@brief	普通房间被踢
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_QuitRoomOk, "ProtocolProcessorBattleSettlement:parse_ROOM_QuitRoomOk", "b")
	--@brief	副本房间房间被踢
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.BOSSMAPROOM_QuitRoomOk, "ProtocolProcessorBattleSettlement:parse_BOSSMAPROOM_QuitRoomOk", "b")
	
    --@brief	返回房间(BATTLE_BackToRoom = 31)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_BackToRoom, "ProtocolProcessorBattleSettlement:send_BATTLE_BackToRoom_ErrorProcess", "is" )
    --@brief	返回房间(BOSSMAPBATTLE_BackToRoom = 31)错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BackToRoom, "ProtocolProcessorBattleSettlement:send_BOSSMAPROOM_BackToRoom_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
function ProtocolProcessorBattleSettlement:unregAll()
	self.m_tData = nil
	self:clearReg()
end


-------------------------------------客户端到服务器协议发送方法模块Begin--------------------------------------
--@brief	返回房间(BATTLE_BackToRoom = 31)
function ProtocolProcessorBattleSettlement:send_BATTLE_BackToRoom(roomId )
    local player = WBattleGlobal:getCurrent():getMyBattleId()
    WZLog("send_BATTLE_BackToRoom", roomId, player)
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_BackToRoom )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( roomId )	-- 房间号
    sender:writeInt(player)
	SendProtocol(sender,false) --true:showLoading
end

--@brief	返回副本房间(BOSSMAPROOM_BackToRoom = 31)
function ProtocolProcessorBattleSettlement:send_BOSSMAPROOM_BackToRoom(roomId, mapId )
	WZLog("send_BATTLE_BackToRoom")
	local sender = Protocol:getSender( Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BackToRoom )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( roomId )	-- 房间号
	sender:writeInt( mapId )	-- 房间Id
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------客户端到服务器协议发送方法模块End--------------------------------------


-------------------------------------服务器到客户端协议回调方法模块Begin--------------------------------------
--@brief	进入房间成功                                          
function ProtocolProcessorBattleSettlement:parse_ROOM_EnterRoomOk(roomId, roomStatus, battleMode, roomChannel, playerNumMode,schedule, mapId, wnersId, startMode, playerNum, seatUsed, playerId, serviceId, playerName, playerLevel, playerReady, playerSex, equipmentId, equipmentLevel, vipLevel, playerTitle, roomName, roomPassword, fighting, pet, tournamentLevel, winNum, playNum, extranInfo,tournamentExp,url,teamId,teamName,headColors,bodyColors, mentoringStr, coupleStr, chumStr, coupleNum, chumNum,mentoringNum,matchLevel,matchscore,joinTimes,winTimes,continuousWinTimes)
	-- roomId : 房间Id
	-- battleMode : 战斗模式
	-- roomChannel : 房间所属频道（1初级，2中级，3高级）
	-- playerNumMode : 对战人数模式
    -- schedule : 比赛赛程
	-- mapId : 房间地图id
	-- wnersId : 房主id
	-- startMode : 撮合方式
	-- playerNum : 房间座位数量
	-- seatUsed : 该座位是否使用
	-- playerId : 房间内玩家id
	-- playerName : 房间内玩家昵称
	-- playerLevel : 房间内玩家等级
	-- playerReady : 玩家是否已准备
	-- playerSex : 玩家性别
	-- playerEquipment : 玩家身上的装备
	-- playerWeaponLevel : 玩家装备等级
	-- vipLevel : 玩家vip等级0表示非vip
	-- playerTitle : 玩家称号
	-- qualifyingLevel : 荣誉等级
	-- playerBuffCount : 表示每一个player,buffer的数量，如果没有要填零
	-- buffId : 玩家BUFFID
	-- eventMode : 特殊事件模式
	-- roomName : 房间名称
	-- roomPassword : 房间密码
    -- fighting : 玩家战斗力

    local inroom = false
    for i,id in pairs(VectorToTable(playerId)) do
        if id == CacheCenter:getPlayerInfo().id then
            inroom = true
        end
    end
    WZLog("ProtocolProcessorBattleSettlement:parse_ROOM_EnterRoomOk = ",Serialize(VectorToTable(headColors)),Serialize(VectorToTable(bodyColors)))

    local roomLua = SceneRoom
    --工会战房间
    if WBattleGlobal:getCurrent():isGuildWarStage() then
    	roomLua = SceneGuildWarRoom
    end

    if roomLua.m_root == nil then
        if inroom == true then
            local roomElement = roomLua:createElement()
            replaceScene(roomElement)
        else
            -- if 为公会战  elseif 为竞技场
            if BattleGlobal:getCurrent():isGuildWarStage() then
                replaceScene(SceneCommunityMain:createElement())
                if g_isQuitRoom then
                    MsgBoxManager:showTipBox(LocalStrings.BOOSROOM_KICKEDOUT)
                end
                return
            elseif WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and
                    WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ then
                replaceScene(SceneHall:createElement())
                if g_isQuitRoom then
                    MsgBoxManager:showTipBox(LocalStrings.BOOSROOM_KICKEDOUT)
                end
                return
            end
        end
    end
    roomLua:receiveEnterRoomOk(roomId,roomStatus,battleMode, roomChannel,
				playerNumMode,schedule,mapId,wnersId,startMode,playerNum, VectorToTable(seatUsed),
				VectorToTable(playerId), VectorToTable(playerName),
				VectorToTable(playerLevel), VectorToTable(playerReady),
				VectorToTable(playerSex), VectorToTable(equipmentId),
				VectorToTable(equipmentLevel), VectorToTable(vipLevel),
				VectorToTable(playerTitle),roomName,roomPassword,VectorToTable(fighting),
				VectorToTable(pet),VectorToTable(tournamentLevel),VectorToTable(winNum),
				VectorToTable(playNum),VectorToTable(extranInfo),VectorToTable(serviceId),
				VectorToTable(tournamentExp),VectorToTable(headColors),VectorToTable(bodyColors),mentoringStr,coupleStr,chumStr,coupleNum,chumNum,mentoringNum,VectorToTable(matchLevel),VectorToTable(matchscore),VectorToTable(joinTimes),VectorToTable(winTimes),VectorToTable(continuousWinTimes))
end

--@brief	被踢出房间
function ProtocolProcessorBattleSettlement:parse_ROOM_QuitRoomOk(mark)
	-- mark : 是否被踢
	WZLog("ProtocolProcessorBattleSettlement:parse_ROOM_QuitRoomOk被踢出房间")
    g_isQuitRoom = mark
end

--@brief	被踢出房间
function ProtocolProcessorBattleSettlement:parse_BOSSMAPROOM_QuitRoomOk(mark)
	-- mark : 是否被踢
	WZLog("ProtocolProcessorBattleSettlement:parse_BOSSMAPROOM_QuitRoomOk被踢出房间")
	--ScenceBattleSettlment:receiveQuitRoomOk(mark)
end
-------------------------------------服务器到客户端协议回调方法模块End--------------------------------------


-------------------------------------协议错误处理方法模块Begin--------------------------------------

--@brief	返回房间(BATTLE_BackToRoom = 31)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorBattleSettlement:send_BATTLE_BackToRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorBattleSettlement:send_BATTLE_BackToRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BATTLE, Protocol.BATTLE_BackToRoom, nflag, sMessage)
    -- if 为公会战  elseif 为竞技场
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if g_isQuitRoom then
            MsgBoxManager:showTipBox(LocalStrings.BOOSROOM_KICKEDOUT)
        end

    	local battleChannel = WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle
        if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ then
        	replaceScene(SceneHall:createElement())
        	return
        end
        
        if WBattleGlobal:getCurrent():isGuildWarStage() then
            SceneCommunityWar:showInterface()
            return
        end
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
        	replaceScene(SceneAthMelee:createElement())
        	return
        end
        if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_YL then
            replaceScene(ScenePvpAmuse:createElement())
            return
        end

        if battleChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        	replaceScene(ScenePvpRank:createElement())
        	return
        end
        replaceScene(SceneHall:createElement())
        
        return
    end
end

--@brief	返回副本房间(BOSSMAPROOM_BackToRoom = 31)错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理	
function ProtocolProcessorBattleSettlement:send_BOSSMAPROOM_BackToRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorBattleSettlement:send_BOSSMAPROOM_BackToRoom_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BOSSMAPROOM, Protocol.BOSSMAPROOM_BackToRoom, nflag, sMessage)
end
-------------------------------------协议错误处理方法模块End--------------------------------------

