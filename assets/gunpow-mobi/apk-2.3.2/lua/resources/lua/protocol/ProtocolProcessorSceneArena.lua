--ProtocolProcessorSceneArena.lua
--@brief	游戏大厅协议
--@date  	2013/12/10
--@author 	李光森
--@note 	游戏大厅使用的协议


ProtocolProcessorSceneArena = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorSceneArena:regAll()
    WZLog("ProtocolProcessorSceneArena:regAll")
	--数据表
	self.m_tData = nil
	--返回房间列表
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomListOk, "ProtocolProcessorSceneArena:parse_ROOM_GetRoomListOk", "ivivsvivivivsvivivbi")
    --角色信息获取成功(S->C)
    --找到房间需要密码
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoomOk, "ProtocolProcessorSceneArena:parse_ROOM_SelectRoomOk", "is")

    --@brief	获取房间列表（ROOM_GetRoomList = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomList, "ProtocolProcessorSceneArena:send_ROOM_GetRoomList_ErrorProcess", "is" )
    --@brief	创建房间（ROOM_CreateRoom = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom, "ProtocolProcessorSceneArena:send_ROOM_CreateRoom_ErrorProcess", "is" )
    --@brief	快速游戏（ROOM_QuickGame = 13）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame, "ProtocolProcessorSceneArena:send_ROOM_QuickGame_ErrorProcess", "is" )
    --查找房间错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom, "ProtocolProcessorSceneArena:send_ROOM_SelectRoom_ErrorProcess", "is" )

    --@brief	获取竞技商品列表（ROOM_GetArenaStoreOk = 24）
    --self:regProtocolCallbackFunction( Protocol.MAIN_ROOM , Protocol.ROOM_GetArenaStoreOk, "ProtocolProcessorSceneArena:parse_ROOM_GetArenaStoreOk", "vivsvsviil")
    --@brief	获取竞技商品列表（ROOM_GetArenaStore = 23）错误处理(S->C)
    --self:regProtocolCallbackFunction( Protocol.MAIN_ROOM , Protocol.ROOM_GetArenaStore, "ProtocolProcessorSceneArena:send_ROOM_GetArenaStore_ErrorProcess", "is" )
    --@brief	购买竞技商店物品（ROOM_BuyArenaStore = 25）错误处理(S->C)
    --self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_BuyArenaStore, "ProtocolProcessorSceneArena:send_ROOM_BuyArenaStore_ErrorProcess", "is" )
    --@brief	购买竞技商店物品（ROOM_BuyArenaStoreOk = 26）
    --self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_BuyArenaStoreOk, "ProtocolProcessorSceneArena:parse_ROOM_BuyArenaStoreOk", " ")
    --@brief	刷新竞技商店（ROOM_RefreshArenaStore = 27）错误处理(S->C)
    --self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_RefreshArenaStore, "ProtocolProcessorSceneArena:send_ROOM_RefreshArenaStore_ErrorProcess", "is" )
    --@brief	获取每日竞技目标列表（ROOM_GetTournamentAim = 30）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetTournamentAim, "ProtocolProcessorSceneArena:send_ROOM_GetTournamentAim_ErrorProcess", "is" )
    --@brief	获取每日竞技目标列表成功（ROOM_GetTournamentAimOK = 31）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetTournamentAimOK, "ProtocolProcessorSceneArena:parse_ROOM_GetTournamentAimOK", "viviiiiiiiiiii")
    --@brief	领取每日竞技目标奖励（ROOM_ReceiveTournamentAim = 32）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_ReceiveTournamentAim, "ProtocolProcessorSceneArena:send_ROOM_ReceiveTournamentAim_ErrorProcess", "is" )
    --@brief	领取每日竞技目标奖励成功（ROOM_ReceiveTournamentAimOK = 33）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_ReceiveTournamentAimOK, "ProtocolProcessorSceneArena:parse_ROOM_ReceiveTournamentAimOK", "is")
    --@brief	取消随机配对对战用户（ROOM_EndPair = 34）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_EndPair, "ProtocolProcessorSceneArena:send_ROOM_EndPair_ErrorProcess", "is" )
    --@brief	退出匹配成功（ROOM_EndPairOk = 35）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_EndPairOk, "ProtocolProcessorSceneArena:parse_ROOM_EndPairOk", "")
    --@brief	获取竞技场记录（ROOM_AllRecord=81）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_AllRecord, "ProtocolProcessorSceneArena:send_ROOM_AllRecord_ErrorProcess", "is" )
    --@brief	获取竞技场记录成功（ROOM_AllRecordOK=82）
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_AllRecordOK, "ProtocolProcessorSceneArena:parse_ROOM_AllRecordOK", "vivsviviviviviviivivi")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorSceneArena:unregAll()
	self.m_tData = nil
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
----@brief	获取竞技商品列表（ROOM_GetArenaStore = 23）
--function ProtocolProcessorSceneArena:send_ROOM_GetArenaStore( )
--    WZLog("send_ROOM_GetArenaStore")
--    local sender = Protocol:getSender( Protocol.MAIN_ROOM , Protocol.ROOM_GetArenaStore )
--    if sender==nil then WZLog("sender == nil") return end
--
--    SendProtocol(sender,false) --true:showLoading
--end
--
----@brief	购买竞技商店物品（ROOM_BuyArenaStore = 25）
--function ProtocolProcessorSceneArena:send_ROOM_BuyArenaStore(storeId )
--    WZLog("send_ROOM_BuyArenaStore")
--    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_BuyArenaStore )
--    if sender==nil then WZLog("sender == nil") return end
--
--    sender:writeInt( storeId )	-- 123456
--    SendProtocol(sender,false) --true:showLoading
--end
--
----@brief	刷新竞技商店（ROOM_RefreshArenaStore = 27）
--function ProtocolProcessorSceneArena:send_ROOM_RefreshArenaStore( )
--    WZLog("send_ROOM_RefreshArenaStore")
--    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_RefreshArenaStore )
--    if sender==nil then WZLog("sender == nil") return end
--    SendProtocol(sender,false) --true:showLoading
--end


--@brief	获取房间列表（ROOM_GetRoomList = 3）
function ProtocolProcessorSceneArena:send_ROOM_GetRoomList(roomChannel, pageNum )
    WZLog("send_ROOM_GetRoomList")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( roomChannel )	-- 房间所属频道
    sender:writeInt( pageNum )	-- 分页页数0开始
    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取在线好友
function ProtocolProcessorSceneArena:send_PLAYER_GetOnlinePlayerNew(pageNumber,showLoading)
	WZLog("send_PLAYER_GetOnlinePlayerNew")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetOnlinePlayerNew )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( pageNumber )	-- 需要的页数
	SendProtocol(sender,showLoading) --true:showLoading
end

--@brief	获取玩家身上装备列表
function ProtocolProcessorSceneArena:send_PLAYER_GetPlayerBodyEquipment(playerId )
	WZLog("send_PLAYER_GetPlayerBodyEquipment")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerBodyEquipment )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( playerId )	-- 玩家ID
	SendProtocol(sender,true) --true:showLoading
end

--@brief	创建房间（ROOM_CreateRoom = 1）
function ProtocolProcessorSceneArena:send_ROOM_CreateRoom(roomName, battleMode, playerNumMode, passWord, startMode, roomChannel,schedule)
    WZLog("send_ROOM_CreateRoom 1111= ",startMode,roomChannel)
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString( roomName )	-- 房间名称
    sender:writeInt( battleMode )	-- 战斗模式
    sender:writeInt( playerNumMode )	-- 对战人数模式
    sender:writeString( passWord )	-- 房间密码
    sender:writeInt( startMode )	-- 撮合方式
    sender:writeInt( roomChannel )	-- 房间所属频道
    sender:writeInt( schedule )  -- 赛程
    SendProtocol(sender,false) --true:showLoading
end

--@brief	查找房间
function ProtocolProcessorSceneArena:send_ROOM_SelectRoom(roomId,roomChannel,numMode,passWord )
	WZLog("send_ROOM_SelectRoom ",roomId,passWord)
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt(roomId)	-- 房间Id
    sender:writeInt(roomChannel) --房间频道
    sender:writeInt(numMode) --[177+]房间人数模式(2=2V2|3=3V3)
	sender:writeString(passWord)	-- 房间密码，"-1"为没有密码
	SendProtocol(sender,false) --true:showLoading
end

--@brief	快速游戏（ROOM_QuickGame = 13）
function ProtocolProcessorSceneArena:send_ROOM_QuickGame(roomChannel,battleMode,schedule,numMode)
    WZLog("ProtocolProcessorSceneArena:send_ROOM_QuickGam", roomChannel,battleMode)
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame )
    if sender==nil then WZLog("sender == nil") return end
    sender:writeInt(roomChannel)    -- 房间所属频道
    sender:writeInt(battleMode)   -- 战斗模式
    sender:writeInt(schedule) --赛程
    sender:writeInt(numMode or 0) --[177+]房间人数模式(2=2V2|3=3V3)
    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取在线好友（PLAYER_GetOnlinePlayer = 20）
function ProtocolProcessorSceneArena:send_PLAYER_GetOnlinePlayer( )
	WZLog("send_PLAYER_GetOnlinePlayer...........")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetOnlinePlayer )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取每日竞技目标列表（ROOM_GetTournamentAim = 30）
function ProtocolProcessorSceneArena:send_ROOM_GetTournamentAim(dataType)
    WZLog("send_ROOM_GetTournamentAim")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_GetTournamentAim )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeByte( dataType )	-- 获取的数据类型 0每日目标数据，1每周排行数据
    SendProtocol(sender,false) --true:showLoading
end

--@brief	领取每日竞技目标奖励（ROOM_ReceiveTournamentAim = 32）
function ProtocolProcessorSceneArena:send_ROOM_ReceiveTournamentAim(rewardId )
    WZLog("send_ROOM_ReceiveTournamentAim")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_ReceiveTournamentAim )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( rewardId )	-- 奖励id(竞技目标奖励表id)
    SendProtocol(sender,false) --true:showLoading
end

--@brief	取消随机配对对战用户（ROOM_EndPair = 34）
function ProtocolProcessorSceneArena:send_ROOM_EndPair(roomId )
    WZLog("send_ROOM_EndPair")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_EndPair )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( roomId )	-- 房间Id
    SendProtocol(sender,false) --true:showLoading
end

--@brief	获取竞技场记录（ROOM_AllRecord=81）
function ProtocolProcessorSceneArena:send_ROOM_AllRecord(recordType )
    WZLog("send_ROOM_AllRecord")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_AllRecord )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( recordType )	-- 记录类型1、1v1，2、2v2，3、3v3，4、个人
    SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

----@brief	获取竞技商品列表（ROOM_GetArenaStoreOk = 24）
--function ProtocolProcessorSceneArena:parse_ROOM_GetArenaStoreOk(storeId, store, cost, status, refreshCount, nextRefreshTime)
--    -- storeId : 商店ID（购买时使用该ID）
--    -- store : 商品,格式[100,2]
--    -- cost : 购买消耗，格式[7,100]
--    -- status : 状态0未买过，1已买过了
--    -- refreshCount : 刷新次数
--    -- nextRefreshTime : 下次自动刷新时间(秒数)
--    WZLog("ProtocolProcessorSceneArena:parse_ROOM_GetArenaStoreOk")
--    WndAthShop:closeLoadingBox()
--    local shopInfo = {}
--    shopInfo.refreshCount = refreshCount
--    shopInfo.refreshTime = nextRefreshTime
--    local allProp = {}
--    for i = 0, storeId:size()-1 do
--        local temp
--        local prop = {}
--        prop.storeId = storeId:get(i)
--        temp = SplitTeachTalkStringWithSeparator(store:get(i))
--        temp = SplitStringWithSeparator(temp[1],",")
--        prop.propId = tonumber(temp[1])
--        prop.propNum = tonumber(temp[2])
--        temp = SplitTeachTalkStringWithSeparator(cost:get(i))
--        temp = SplitStringWithSeparator(temp[1],",")
--        prop.costId = tonumber(temp[1])
--        prop.costNum = tonumber(temp[2])
--        prop.status = status:get(i)
--        --物品基础数据
--        local key = "id_"..prop.propId
--        prop.basicInfo = GDatatab_item[key]
--        if prop.basicInfo then table.insert(allProp,prop) end
--    end
----    for i = 1, #allProp do
----        WZLog("----------------ath prop shop info---------------------------",
----        allProp[i].storeId,allProp[i].propId,allProp[i].propNum,allProp[i].costId,allProp[i].costNum,allProp[i].status)
----    end
--    shopInfo.prop = allProp
--    WndAthShop:setAthShopInfo(shopInfo)
--    WZLog("--------------------------get ath shop list-------------------------------")
--end
--
----@brief	购买竞技商店物品（ROOM_BuyArenaStoreOk = 26）
--function ProtocolProcessorSceneArena:parse_ROOM_BuyArenaStoreOk()
--    WZLog("ProtocolProcessorSceneArena:parse_ROOM_BuyArenaStoreOk")
--    WZLog("----------buy-----------success---------------ath------------------")
--    WndAthShop:buySuccess()
--end

--@brief	返回房间列表
function ProtocolProcessorSceneArena:parse_ROOM_GetRoomListOk(channel, roomId, roomName, battleStatus, battleMode, playerNumMode, passWord, playerNum, startMode, roomStaus,totalSize)
	-- channel : 房间数量
	-- roomId : 房间Id数组
	-- roomName : 房间名称数组
	-- battleStatus : 房间状态数组
	-- battleMode : 房间战斗模式数组
	-- playerNumMode : 房间对战人数模式数组
	-- passWord : 房间密码数组
	-- playerNum : 房间当前人数数组
	-- startMode : 房间撮合方式数组
	-- roomStaus : 房间是否已满
	WZLog("ProtocolProcessorSceneArena:parse_ROOM_GetRoomListOk")
    ScenePvpArena:receiveRoomList(channel, VectorToTable(roomId), VectorToTable(roomName), VectorToTable(battleStatus), VectorToTable(battleMode), VectorToTable(playerNumMode), VectorToTable(passWord), VectorToTable(playerNum), VectorToTable(startMode), VectorToTable(roomStaus),totalSize)
end

--@brief	找到房间需要密码
function ProtocolProcessorSceneArena:parse_ROOM_SelectRoomOk(roomId, passWord)
	-- roomId : 房间Id
	-- passWord : 房间密码
	WZLog("ProtocolProcessorSceneArena:parse_ROOM_SelectRoomOk")
    ScenePvpArena:receiveSelectRoomOk(roomId, passWord)
end

--@brief	获取每日竞技目标列表成功（ROOM_GetTournamentAimOK = 31）
function ProtocolProcessorSceneArena:parse_ROOM_GetTournamentAimOK(rewardId, status, fightNum, winNum,rank,score,mfightNum,mwinNum,gfightNum,gwinNum,ffightNum,fwinNum)
    -- rewardId : 奖励ID
    -- status : 领取状态(0可领取，1已领取)
    -- fightNum : 战斗次数
    -- winNum : 胜利次数
    WZLog("ProtocolProcessorSceneArena:parse_ROOM_GetTournamentAimOK",Serialize(VectorToTable(status)))
    WZLog("---------WndAthReward.m_root----------",WndAthReward.m_root)
    WZLog("---------WndAthRank.m_root----------",WndAthRank.m_root)
    WZLog("---------SceneCity.m_root----------",SceneCity.m_root)
    if WndAthReward.m_root then
        WndAthReward:setGoalData(rewardId, status, fightNum, winNum,mfightNum,mwinNum,gfightNum,gwinNum,ffightNum,fwinNum)
    elseif WndAthRank.m_root then
        WndAthRank:setMyRankData(fightNum, winNum,rank,score)
    end
    if ScenePvpArena.m_root then
        ScenePvpArena:setGoalTipsData(fightNum,winNum)
    end
	if SceneCity and SceneCity.m_root then
		local statusList = VectorToTable(status)
		if statusList == nil or statusList == 0 then return end
		for i=1,#statusList do
			if statusList[i] == -1 then
				SceneCity:createCompetitiveGoal(true)
				return 
			end
		end
		SceneCity:createCompetitiveGoal(false)
	end
end

--@brief	领取每日竞技目标奖励成功（ROOM_ReceiveTournamentAimOK = 33）
function ProtocolProcessorSceneArena:parse_ROOM_ReceiveTournamentAimOK(rewardId, reward)
    -- rewardId : 目标奖励id
    -- reward : 获得奖励[1,1]&[2,2]
    WZLog("ProtocolProcessorSceneArena:parse_ROOM_ReceiveTournamentAimOK")
    WndAthReward:updateCellList(rewardId,reward)
end


--@brief	退出匹配成功（ROOM_EndPairOk = 35）
function ProtocolProcessorSceneArena:parse_ROOM_EndPairOk()
    WZLog("ProtocolProcessorSceneArena:parse_ROOM_EndPairOk")
    if ScenePvpArena.m_root then
        ScenePvpArena:matchResult()
    end
end

--@brief	获取竞技场记录成功（ROOM_AllRecordOK=82）
function ProtocolProcessorSceneArena:parse_ROOM_AllRecordOK(playerId, playerName, level, headId, faceId, fight, sex, recordId,recordType,num,headColor)
    -- playerId : 玩家Id
    -- playerName : 玩家名称
    -- level : 等级
    -- headId : 头像Id
    -- faceId : 脸部Id
    -- fight : 战斗力
    -- sex : 性别
    -- recordId : 战斗Id
    -- recordType: 录像类型
    -- num: 人数
    WZLog("ProtocolProcessorSceneArena:parse_ROOM_AllRecordOK")
    WndAthVideo:setVideoData(playerId, playerName, level, headId, faceId, fight, sex, recordId,recordType,num,headColor)
end

------------------------------------------------------------------------------------------------------------------------

--@brief	获取房间列表（ROOM_GetRoomList = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneArena:send_ROOM_GetRoomList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneArena:send_ROOM_GetRoomList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomList, nFlag, sMessage)
end



--@brief	创建房间（ROOM_CreateRoom = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneArena:send_ROOM_CreateRoom_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneArena:send_ROOM_CreateRoom_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom, nFlag, sMessage)
end

--@brief	查找房间错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneArena:send_ROOM_SelectRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorSceneArena:send_ROOM_SelectRoom_ErrorProcess",sMessage)
    ScenePvpArena:receiveSelectRoomFail()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom, nFlag, sMessage)
end

--@brief	快速游戏（ROOM_QuickGame = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneArena:send_ROOM_QuickGame_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneArena:send_ROOM_QuickGame_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_QuickGame, nFlag, sMessage)
end


----@brief	获取竞技商品列表（ROOM_GetArenaStore = 23）错误处理函数(S->C)
----@param	nFlag:标志位
----@param	sMessage:错误信息
----@note	在此对协议错误进行相应处理
--function ProtocolProcessorSceneArena:send_ROOM_GetArenaStore_ErrorProcess(nFlag, sMessage)
--    WZLog("ProtocolProcessorSceneArena:send_ROOM_GetArenaStore_ErrorProcess")
--    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM , Protocol.ROOM_GetArenaStore, nFlag, sMessage)
--end
--
----@brief	购买竞技商店物品（ROOM_BuyArenaStore = 25）错误处理函数(S->C)
----@param	nFlag:标志位
----@param	sMessage:错误信息
----@note	在此对协议错误进行相应处理
--function ProtocolProcessorSceneArena:send_ROOM_BuyArenaStore_ErrorProcess(nFlag, sMessage)
--    WZLog("ProtocolProcessorSceneArena:send_ROOM_BuyArenaStore_ErrorProcess")
--    WndAthShop:closeLoadingBox()
--    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_BuyArenaStore, nFlag, sMessage)
--end

----@brief	刷新竞技商店（ROOM_RefreshArenaStore = 27）错误处理函数(S->C)
----@param	nFlag:标志位
----@param	sMessage:错误信息
----@note	在此对协议错误进行相应处理
--function ProtocolProcessorSceneArena:send_ROOM_RefreshArenaStore_ErrorProcess(nFlag, sMessage)
--    WZLog("ProtocolProcessorSceneArena:send_ROOM_RefreshArenaStore_ErrorProcess")
--    WndAthShop:closeLoadingBox()
--    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_RefreshArenaStore, nFlag, sMessage)
--end

--@brief	获取每日竞技目标列表（ROOM_GetTournamentAim = 30）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneArena:send_ROOM_GetTournamentAim_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneArena:send_ROOM_GetTournamentAim_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_GetTournamentAim, nFlag, sMessage)
end

--@brief	领取每日竞技目标奖励（ROOM_ReceiveTournamentAim = 32）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneArena:send_ROOM_ReceiveTournamentAim_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneArena:send_ROOM_ReceiveTournamentAim_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_ReceiveTournamentAim, nFlag, sMessage)
end

--@brief	取消随机配对对战用户（ROOM_EndPair = 34）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneArena:send_ROOM_EndPair_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneArena:send_ROOM_EndPair_ErrorProcess")
    ScenePvpArena:matchResulet()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_EndPair, nflag, sMessage)
end

--@brief	获取竞技场记录（ROOM_AllRecord=81）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorSceneArena:send_ROOM_AllRecord_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorSceneArena:send_ROOM_AllRecord_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_AllRecord, nflag, sMessage)
end
