--CellMagicStoneRewardData.lua
--@brief	CellMagicStoneReward的数据模块
--@date		2019/10/24
--@author	Tianxiang_Xu
--@note		幻石系统-奖励

CellMagicStoneReward = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellMagicStoneReward:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nType = 1			--1：奖励；2：奖励预览；3：全服奖励
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMagicStoneReward:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMagicStoneReward:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMagicStoneReward table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellMagicStoneReward")
    element:setAbsContentSize(GlobalMethod:CCSize(115, 358))
    element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellMagicStoneReward:createElementTwo()
	local tNewObj = self:_new()
	assert(tNewObj, "CellMagicStoneReward table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMagicStoneReward")
	assert(element, "CellMagicStoneReward element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end


--@brief 	设置数据
function CellMagicStoneReward:setData(tData, nType)
	-- body
	self.m_tData = tData
	self.m_nType = nType
end

--@brief 	设置数据
function CellMagicStoneReward:setData1(tData, nType)
	-- body
	self.m_tData = tData
	self.m_nType = nType

	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellMagicStoneReward:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
