--CellRemainsChallengeData.lua
--@brief	CellRemainsChallenge的数据模块
--@date		2019/07/12
--@author	yrd
--@note		遗迹之光挑战

CellRemainsChallenge = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellRemainsChallenge:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRemainsChallenge:_unInit()
	self.m_root = nil
	self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellRemainsChallenge:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellRemainsChallenge table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellRemainsChallenge")
	assert(element, "CellRemainsChallenge element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--playerId			遗迹发现者Id
--playerName		遗迹发现者名称
--mapTime			遗迹剩余时间
--mapId				副本Id(服务器生成的唯一id)
--mapNum			遗迹副本表中id
--bossBloodMax		boss总血量
--bossBloodCurrent	boss当前血量
--mapStatus			副本状态 0挑战中 1挑战成功 2挑战失败
--mapSize			当前遗迹容量使用数
--challengeTime		剩余挑战次数
--time				恢复挑战次数剩余时间(秒)
function CellRemainsChallenge:setData(tData)
	self.m_tData = tData
	
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellRemainsChallenge:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
