--CellCharmRewardData.lua
--@brief	CellCharmReward的数据模块
--@date		2016/08/24
--@author	mpt
--@note		鲜花榜奖励

CellCharmReward = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCharmReward:_init()
	self.m_root = nil  			--Cell的根节点
	self.rank = nil 			--排名
	self.reward = nil 			--奖励
	self.type = nil
	self.tag = nil
	self.onLoad = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCharmReward:_unInit()
	self.m_root = nil
	self.rank = nil 			
	self.reward = nil
	self.type = nil
	self.tag = nil
	self.onLoad = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCharmReward:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCharmReward table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	assert(element, "CellCharmReward element create failed!")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(783,90))
	element:setLuaObjectIndex(tNewObj)
	--tNewObj.m_root = element
	return element,tNewObj
end

function CellCharmReward:onLoadData( element )
	local cellElement = WZUISystem:getInstance():createElement("CellCharmReward")
	self.m_root:addChild(cellElement)
	self.onLoad = true
	self:_update()
end

function CellCharmReward:setData( rank,reward,tag )
	self.rank = rank
	--self.type = type
	self.reward = reward
	self.tag = tag
	--WZLog("--CellCharmReward:reward--",#self.reward)
	--self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCharmReward:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
