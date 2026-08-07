--CellRechargePanelActivityData.lua
--@brief	CellRechargePanelActivity的数据模块
--@date		2014/12/02
--@author	wuweidong
--@note		首冲活动面板

CellRechargePanelActivity = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellRechargePanelActivity:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_context = nil		--活动描述
	self.b_status = nil		--是否可领取
	self.m_trewardItems = nil	--物品Id
	self.m_rewardItemsParamCount = nil  --物品数量
	self.m_nLoadingId0 = 0
	self.b_needAutoMove = false
	self.MaxMoveY = 0
	self.activityId = nil
    self.rewardId = nil 
    self.m_rewardCounts = nil 
    self.m_target = nil 
    self.m_nPetGift = nil 	
	self.m_nLoadingId = nil
	self.m_bIsText = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRechargePanelActivity:_unInit()
	self.m_root = nil
	self.b_status = nil 
	self.m_trewardItems = nil	--物品Id
	self.m_rewardItemsParamCount = nil  --物品数量
	self.m_nLoadingId0 = 0
	self.b_needAutoMove = false
	self.MaxMoveY = 0
	self.activityId = nil 
    self.rewardId = nil 
    self.m_rewardCounts = nil 
    self.m_target = nil 
    self.m_nPetGift = nil 
	self.m_nLoadingId = nil
	self.m_bIsText = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellRechargePanelActivity:createElement()
	local element = WZUISystem:getInstance():createElement("CellRechargePanelActivity")
	assert(element, "CellRechargePanelActivity create element failed!")
	self:_init()
	return element
end

--@brief   创建加载框
function CellRechargePanelActivity:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function CellRechargePanelActivity:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--function CellRechargePanelActivity:createElement()
--	local tNewObj = self:_new()
--	assert(tNewObj, "CellRechargePanelActivity table create failed!")
--	tNewObj:_init()
--	local element = WZUISystem:getInstance():createElement("CellRechargePanelActivity")
--	assert(element, "CellRechargePanelActivity element create failed!")
--	element:setLuaObjectIndex(tNewObj)
--	tNewObj.m_root = element
--	return element,tNewObj
--end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
--function CellRechargePanelActivity:_new( )
--	local tNewObj = {}
--	setmetatable(tNewObj, self)
--	self.__index = self
--    CellRechargePanelActivity.m_current = tNewObj
--	return tNewObj
--end

-------------------------------------私有方法模块End----------------------------------------
