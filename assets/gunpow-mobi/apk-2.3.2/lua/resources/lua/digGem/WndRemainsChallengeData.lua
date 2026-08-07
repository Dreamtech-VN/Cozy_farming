--WndRemainsChallengeData.lua
--@brief	WndRemainsChallenge的数据模块
--@date		2019/07/11
--@author	yrd
--@note		遗迹之光挑战

WndRemainsChallenge = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndRemainsChallenge:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tRemainsList = {}
	self.m_nMapSize = nil
	self.m_sChallengeTime = nil
	self.m_nTime = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRemainsChallenge:_unInit()
	self.m_root = nil
	self.m_tRemainsList = nil
	self.m_nMapSize = nil
	self.m_sChallengeTime = nil
	self.m_nTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndRemainsChallenge:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root,WndRemainsChallenge,true)
    end
	local element = WZUISystem:getInstance():createElement("WndRemainsChallenge")
	assert(element, "WndRemainsChallenge create element failed!")
	self:_init()
	return element
end

function WndRemainsChallenge:setData(playerId, playerName, mapTime, mapId, mapNum, bossBloodMax, bossBloodCurrent, mapStatus, challengeTime, time)
	self.m_nMapSize = mapSize
	self.m_sChallengeTime = challengeTime
	self.m_nTime = time

	self.m_tRemainsList = {}
	for i=1,#playerId do
		local tmpRemainsList = {}
		tmpRemainsList.nPlayerId = playerId[i]
		tmpRemainsList.nPlayerName = playerName[i]
		tmpRemainsList.nMapTime = mapTime[i]
		tmpRemainsList.nMapId = mapId[i]
		tmpRemainsList.nMapNum = mapNum[i]
		tmpRemainsList.nBossBloodMax = bossBloodMax[i]
		tmpRemainsList.nBossBloodCurrent = bossBloodCurrent[i]
		tmpRemainsList.nMapStatus = mapStatus[i]

		table.insert(self.m_tRemainsList,tmpRemainsList)
	end

	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndRemainsChallenge:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
