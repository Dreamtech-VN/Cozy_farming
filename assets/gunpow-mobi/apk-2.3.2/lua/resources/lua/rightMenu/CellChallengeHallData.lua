--CellChallengeHallData.lua
--@brief	CellChallengeHall的数据模块
--@date		2014/02/12
--@author	liangguang_long
--@note		挑战大厅

CellChallengeHall = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellChallengeHall:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_sRanks = nil      			 --排行榜排名
	self.m_sPlayerName = nil 		     --打过Boss的玩家名字
	self.m_nHurt = nil  	  			 --打过Boss的玩家的伤害输出
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellChallengeHall:_unInit()
	self.m_root = nil
	self.m_sRanks = nil      			 --排行榜排名
	self.m_sPlayerName = nil 		     --打过Boss的玩家名字
	self.m_nHurt = nil  	  			 --打过Boss的玩家的伤害输出
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellChallengeHall:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellChallengeHall table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellChallengeHall")
	assert(element, "CellChallengeHall element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief  设置cell中的数据
--@param #1 sRanks:排行榜排名
--@param #2 playerName:打过Boss的玩家名字
--@param #3 nHurt:打过Boss的玩家的伤害输出
function CellChallengeHall:setCellAllElement( sRanks , sPlayerName , nHurt )	
	if self.m_root == nil then
		return
	end
	self.m_sRanks = sRanks     			 --排行榜排名
	self.m_sPlayerName = sPlayerName     --打过Boss的玩家名字
	self.m_nHurt = nHurt	  			 --打过Boss的玩家的伤害输出
	self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellChallengeHall:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
