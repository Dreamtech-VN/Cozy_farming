--ProtocolProcessorWndTrain.lua
--@brief	ProtocolProcessorWndTrain的UI模块
--@date		2017/04/21
--@author	 
--@note		练习赛协议



ProtocolProcessorWndTrain = ProtocolProcessorBase:new()

function ProtocolProcessorWndTrain:regAll()
    WZLog("ProtocolProcessorWndTrain:regAll")
	--返回房间列表
	self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomListOk, "ProtocolProcessorWndTrain:parse_ROOM_GetRoomListOk", "ivivsvivivivsvivivbi")
    --角色信息获取成功(S->C)
    --找到房间需要密码
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoomOk, "ProtocolProcessorWndTrain:parse_ROOM_SelectRoomOk", "is")

    --@brief	获取房间列表（ROOM_GetRoomList = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomList, "ProtocolProcessorWndTrain:send_ROOM_GetRoomList_ErrorProcess", "is" )
    --@brief	创建房间（ROOM_CreateRoom = 1）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom, "ProtocolProcessorWndTrain:send_ROOM_CreateRoom_ErrorProcess", "is" )
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndTrain:unregAll()
	self.m_tData = nil
	self:clearReg()
end



--@brief	获取房间列表（ROOM_GetRoomList = 3）
function ProtocolProcessorWndTrain:send_ROOM_GetRoomList(roomChannel)
    WZLog("send_ROOM_GetRoomList")
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomList )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeInt( roomChannel )	-- 房间所属频道
    SendProtocol(sender,false) --true:showLoading
end

--@brief	创建房间（ROOM_CreateRoom = 1）
function ProtocolProcessorWndTrain:send_ROOM_CreateRoom(roomName, battleMode, playerNumMode, passWord, startMode, roomChannel ,schedule)
    WZLog("send_ROOM_CreateRoom 1111= ",schedule)
    local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom )
    if sender==nil then WZLog("sender == nil") return end

    sender:writeString( roomName )	-- 房间名称
    sender:writeInt( battleMode )	-- 战斗模式
    sender:writeInt( playerNumMode )	-- 对战人数模式
    sender:writeString( passWord )	-- 房间密码
    sender:writeInt( startMode )	-- 撮合方式
    sender:writeInt( roomChannel )	-- 房间所属频道
    sender:writeInt( schedule )  --赛程
    SendProtocol(sender,false) --true:showLoading
end

--@brief	查找房间
function ProtocolProcessorWndTrain:send_ROOM_SelectRoom(roomId,roomChannel,passWord )
	WZLog("send_ROOM_SelectRoom ",roomId,passWord)
	local sender = Protocol:getSender( Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( roomId )	-- 房间Id
    sender:writeInt(roomChannel)  --房间所属频道
	sender:writeString( passWord )	-- 房间密码，"-1"为没有密码
	SendProtocol(sender,false) --true:showLoading
end


--@brief	返回房间列表
function ProtocolProcessorWndTrain:parse_ROOM_GetRoomListOk(channel, roomId, roomName, battleStatus, battleMode, playerNumMode, passWord, playerNum, startMode, roomStaus,totalSize)
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
	WZLog("ProtocolProcessorWndTrain:parse_ROOM_GetRoomListOk")
	WndTrain:receiveRoomList(channel, VectorToTable(roomId), VectorToTable(roomName), VectorToTable(battleStatus), VectorToTable(battleMode), VectorToTable(playerNumMode), VectorToTable(passWord), VectorToTable(playerNum), VectorToTable(startMode), VectorToTable(roomStaus),totalSize)
end


--@brief	找到房间需要密码
function ProtocolProcessorWndTrain:parse_ROOM_SelectRoomOk(roomId, passWord)
	-- roomId : 房间Id
	-- passWord : 房间密码
	WZLog("ProtocolProcessorWndTrain:parse_ROOM_SelectRoomOk")
    WndTrain:receiveSelectRoomOk(roomId, passWord)
end


--@brief	获取房间列表（ROOM_GetRoomList = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndTrain:send_ROOM_GetRoomList_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndTrain:send_ROOM_GetRoomList_ErrorProcess")
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_GetRoomList, nFlag, sMessage)
end


--@brief	创建房间（ROOM_CreateRoom = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndTrain:send_ROOM_CreateRoom_ErrorProcess(nFlag, sMessage)
    WZLog("ProtocolProcessorWndTrain:send_ROOM_CreateRoom_ErrorProcess")
    WndTrain:receiveSelectRoomFail()
    ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_CreateRoom, nFlag, sMessage)
end

--@brief	查找房间错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndTrain:send_ROOM_SelectRoom_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndTrain:send_ROOM_SelectRoom_ErrorProcess",sMessage)
	WndTrain:receiveSelectRoomFail()
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ROOM, Protocol.ROOM_SelectRoom, nFlag, sMessage)
end