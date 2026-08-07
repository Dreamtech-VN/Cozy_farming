--WndCommunityHallData.lua
--@brief	WndCommunityHall的数据模块
--@date		2013/12/16
--@author	李光森
--@note		游戏大厅模块

WndCommunityHall = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityHall:_init()
	self.m_root = nil	 	  			--场景根节点
    self.baseInfo = {}
    self.roomInfo = {}
    self.bGetTime = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityHall:_unInit()
	self.m_root = nil
    self.baseInfo = nil
    self.roomInfo = nil
    self.bGetTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityHall:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityHall")
	assert(element, "WndCommunityHall create element failed!")
	self:_init()
	return element
end

-- 显示公会竞技场UI
function WndCommunityHall:showWnd()
    local wnd = WndCommunityHall:createElement()
    WindowManager:addWindow( wnd ,WndCommunityHall,false)
end

-- 房间列表的名字随机
function WndCommunityHall:_randomRoomName()
    local name = LocalStrings.ROOM_NAME_RANDOM
    local random = math.random(#name)

    return name[random]
end

-- 剩余时间转换
function WndCommunityHall:_descTimeDown(time)
    local d = 24*60*60
    local h = 60*60
    local m = 60
    local day = math.floor(time/d)
    if day >= 1 then return day,LocalStrings.DAY end
    local hour = math.floor((time-day*d)/h)
    if hour >= 1 then return hour,LocalStrings.HOUR1 end
    local min = math.floor((time-day*d-hour*h)/m)
    if min >= 1 then return min,LocalStrings.MINUTE1 end
    local sec = time-day*d-hour*h-min*m

    return sec,LocalStrings.SECOND
end

--warCount	int	历史战斗次数
--winCount	int	历史战斗胜利次数
--first	int	冠军次数
--second	int	亚军次数
--third	int	季军次数
--name2	String	上周冠军公会名称
--warCount2	int	上周冠军公会本周战斗次数
--winCount2	int	上周冠军公会本周战斗胜利次数
--score2	int	上周冠军公会当前积分
--rank2	int	上周冠军公会当前排名
--timeLeft	int 结算剩余时间（秒）
--roomId	int[]	房间ID
--playerNumMode	int[]	对战人数模式:2=2v2， 3=3v3
--playerNum	int[]	房间当前人数
--roomStatus	int[]	房间状态： 0表示等待中， 1表示战斗
function WndCommunityHall:setCommunityHallData(warCount,winCount,first,second,third,name2,warCount2,winCount2,score2,rank2,timeLeft,roomId,playerNumMode,playerNum,roomStatus)
    -- 初始化公会基本信息
    self.baseInfo = {}
    self.baseInfo = {warCount=warCount, winCount=winCount, first=first, second=second, third=third, name2=name2, warCount2=warCount2, winCount2=winCount2, score2=score2, rank2=rank2,timeLeft = timeLeft}

    --self.baseInfo = {warCount=8, winCount=4, first=1, second=2, third=3, name2="OOO", warCount2=4, winCount2=1, score2=10000, rank2=2, timeLeft = -1}

    -- 初始化房间信息
    self.roomInfo = {}
    for i = 1, #roomId do
        local room = {}
        room.roomId = roomId[i]
        room.RoomNum = string.format("%04d",roomId[i])
        room.curNum = playerNum[i]
        room.maxNum = playerNumMode[i]
        room.roomName = self:_randomRoomName()
        room.battleStatus = roomStatus[i]
        room.password = "-1"
        room.battleMode = 4
        table.insert(self.roomInfo,room)
    end

--    for i = 1, 8 do
--        local room = {RoomNum = 0001,curNum = i,maxNum = 8,roomName = self:_randomRoomName(),battleStatus = i%2==0 and 0 or 1,password = "-1",battleMode=4 }
--        table.insert(self.roomInfo,room)
--    end

    self:_update()
end