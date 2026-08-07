--CellPastureWorkerData.lua
--@brief	CellPastureWorker的数据模块
--@date		2021/05/14
--@author	hyx
--@note		牧场工坊

CellPastureWorker = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPastureWorker:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCellMakeItem = {}
	self.m_tMakeWorkShopData = {} --工坊表的数据
	self.m_bIsMake = nil --是否可以制作
	self.m_tMakePriceData = {} --制作与加成的价格
	self.m_tChooseMakeItemData = {}
	self.m_sBagTableContainer = nil
	self.m_tMakeBagData = {} --背包数据
	self.m_nBagIndex = 0 --数量
	self.m_tBagCellItemObj = {}
	self.m_nMakeNumber = {1,1,1,1} --制作的数量
	self.m_sMakeScheduleId = nil --计时器
	self.m_tMakeScheduleTime = {} --计时器时间
	self.m_tAccScheduleTime = {} --加速计时器时间
	self.m_tConsumeDaimand = {} --制作消耗的钻石
	self.m_UnLockData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPastureWorker:_unInit()
	self.m_root = nil
	self.m_tCellMakeItem = {}
	self.m_tMakeWorkShopData = {}
	self.m_bIsMake = nil 
	self.m_tMakePriceData = {}
	self.m_tChooseMakeItemData = {}
	self.m_sBagTableContainer = nil
	self.m_tMakeBagData = {}
	self.m_nBagIndex = 0
	self.m_tBagCellItemObj = {}
	self.m_nMakeNumber = {1,1,1,1}
	self.m_sMakeScheduleId = nil
	self.m_tMakeScheduleTime = {}
	self.m_tAccScheduleTime = {}
	self.m_tConsumeDaimand = {}
	self.m_UnLockData = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellPastureWorker:createElement()
	if CellPastureWorker.m_root ~= nil then
		WindowManager:removeWindow(CellPastureWorker.m_root, CellPastureWorker, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPastureWorker")
	assert(element, "CellPastureWorker create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPastureWorker:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
