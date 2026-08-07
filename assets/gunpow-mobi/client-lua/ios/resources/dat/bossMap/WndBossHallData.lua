--WndBossHallData.lua
--@brief	WndBossHall的数据模块
--@date		2014/01/14
--@author	林庆凯
--@note		副本大厅窗口

WndBossHall = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBossHall:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRoomList = nil              --用来存储从服务器返回房间列表的数据
	self.m_nCurrentCellIndex = nil      --单元格当前索引
    self.m_bIsEnterRoom = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBossHall:_unInit()
	self.m_root = nil
	self.m_tRoomList = nil 
	self.m_nCurrentCellIndex = nil      --单元格当前索引
    self.m_bIsEnterRoom = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBossHall:createElement()
	local element = WZUISystem:getInstance():createElement("WndBossHall")
	assert(element, "WndBossHall create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


--@brief	取得房间列表（BOSSMAPROOM_GetRoomListOk = 4）
--@param #1 roomCount : 房间数量
--@param #2  roomId : 房间Id数组
--@param #4  battleStatus : 房间状态数组（0是等待中，1是战斗中）
--@param #5  playerCountNum : 房间对战人数
--@param #6  passWord : 房间密码数组
--@param #7  playerNum : 房间当前人数数组
--@param #8  roomStaus : 房间是否已满（true是已满，false未满）
--@param #7  mapId : 地图ID
function WndBossHall:getRoomListOk(roomCount, roomId, battleStatus, playerCountNum, passWord, playerNum, roomStaus, mapId)
	WZLog("WndBossHall:getRoomListOk")
	self.m_tRoomList = {}
	self.m_tRoomList.roomCount = roomCount
	self.m_tRoomList.roomId = {}
	self.m_tRoomList.roomName = {}
	self.m_tRoomList.battleStatus = {}
	self.m_tRoomList.playerCountNum = {}
	self.m_tRoomList.passWord = {}
	self.m_tRoomList.playerNum = {}
	self.m_tRoomList.roomStaus = {}
	self.m_tRoomList.mapId = {}
	self.m_tRoomList.roomStar = {}
	self.m_tRoomList.nameAndRoomStar = {}
	for i = 0, roomId:size()-1 do
        local tLocalData = GDatatab_team_map["id_"..mapId:get(i)]
        assert(tLocalData, "getRoomListOk : "..mapId:get(i).." can not find local data")
		table.insert(self.m_tRoomList.roomId, roomId:get(i))
		table.insert(self.m_tRoomList.roomName, tLocalData.map_name)
		table.insert(self.m_tRoomList.battleStatus, battleStatus:get(i))
		table.insert(self.m_tRoomList.playerCountNum, playerCountNum:get(i))
		table.insert(self.m_tRoomList.passWord, passWord:get(i))
		table.insert(self.m_tRoomList.playerNum, playerNum:get(i))
		table.insert(self.m_tRoomList.roomStaus, roomStaus:get(i))
		table.insert(self.m_tRoomList.mapId, mapId:get(i))
		table.insert(self.m_tRoomList.roomStar, tLocalData.difficulty)
        local tDifficulty = {
            LocalStrings.COMMON,
            LocalStrings.DIFFICULTY,
            LocalStrings.HELL  
        }
		local sNameAndRoomStar = tLocalData.map_num.."-"..tLocalData.map_name.." ("..tDifficulty[tLocalData.difficulty]..")"
		table.insert(self.m_tRoomList.nameAndRoomStar, sNameAndRoomStar)
	end
	self:_update()
end 




--@brief	进入房间（BOSSMAPROOM_EnterRoom = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function WndBossHall:getEnterRoomErrorProcess(nFlag,sMessage)
	--获取房间列表（BOSSMAPROOM_GetRoomList = 3）
    if self.m_root ~= nil then
        ProtocolProcessorBossMap:send_BOSSMAPROOM_GetRoomList( )
    end
end 


--@brief	找到房间需要密码（BOSSMAPROOM_SelectRoomOk = 15）
function WndBossHall:selectRoomOk(roomId, passWord)
	--进入相应房间
	ProtocolProcessorBossMap:send_BOSSMAPROOM_EnterRoom(roomId,0 )
end 


--@brief	查找房间（BOSSMAPROOM_SelectRoom = 14）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function WndBossHall:selectRoomErrorProcess(nFlag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end 


--@brief	快速游戏（BOSSMAPROOM_QuickGame = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function WndBossHall:quickGameErrorProcess(nFlag, sMessage)
	MsgBoxManager:showTipBox(sMessage)
end 


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
