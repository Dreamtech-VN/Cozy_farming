--CellListPanelData.lua
--@brief	CellListPanel的数据模块
--@date		2016/06/02
--@author	Tianxiang_Xu
--@note		冲榜类活动

CellListPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellListPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.startTime = nil
    self.endTime = nil
    self.serverTime = nil
    self.rewardItems = nil
    self.rewardId = nil
    self.rewardItemsParamCount = nil
    self.rewardCounts = nil
    self.index = 0
    self.tips = nil
    self.content = nil
    self.m_nActivityId = nil 
    self.m_tRewardList = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellListPanel:_unInit()
	self.m_root = nil
	self.startTime = nil
    self.endTime = nil
    self.serverTime = nil
    self.rewardItems = nil
    self.rewardId = nil
    self.rewardItemsParamCount = nil
    self.rewardCounts = nil
    self.index = nil
    self.tips = nil
    self.content = nil
    self.m_nActivityId = nil 
    self.m_tRewardList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellListPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellListPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellListPanel")
	assert(element, "CellListPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellListPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellListPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
