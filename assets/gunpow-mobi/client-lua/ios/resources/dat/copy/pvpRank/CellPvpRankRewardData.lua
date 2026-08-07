--CellPvpRankRewardData.lua
--@brief	CellPvpRankReward的数据模块
--@date		2015-11-11
--@author	binshao
--@note		排位赛奖励物品

CellPvpRankReward = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPvpRankReward:_init()
	self.m_root = nil  			--Cell的根节点
	self.data = nil             -- 周排行奖励数据
    self.reward = {}            -- 物品信息
    self.callFunc = {}          -- 点击物品的回调函数
    self.m_nIndex = nil 
end

--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function CellPvpRankReward:_unInit()
    self.m_root = nil
    self.data = nil
    self.reward = nil
    self.callFunc = nil
    self.m_nIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPvpRankReward:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPvpRankReward table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(726,94))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	初始化数据
function CellPvpRankReward:setReward(data, nIndex)
    self.data = data
    self.m_nIndex = nIndex
end

-- 设置回调函数
function CellPvpRankReward:setCallFunc(object,callFunc)
    self.callFunc[1] = object
    self.callFunc[2] = callFunc
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPvpRankReward:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
