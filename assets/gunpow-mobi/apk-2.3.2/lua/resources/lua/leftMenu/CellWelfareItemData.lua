--CellWelfareItemData.lua
--@brief	CellWelfareItem的数据模块
--@date		2016/05/12
--@author	Tianxiang_Xu
--@note		福利或比赛子分类

CellWelfareItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellWelfareItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_sItemName = nil 		--福利项的名字
	self.m_nItemId = nil 		--福利项的Id
	self.m_tCallBack = nil 		
	self.m_bIsLoad = false
	self.m_bIsHighLight = nil
	self.m_bIsHaveRedDot = false 
	self.n_fyberTime = 0
	self.m_nType = nil 
	self.m_bIsFreeCardDiscount = false
	self.m_tItemData = nil 
	self.m_bIsHotActivity = false
	self.b_isClicked = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWelfareItem:_unInit()
	self.m_root = nil
	self.m_sItemName = nil 		--福利项的名字
	self.m_nItemId = nil 		--福利项的Id
	self.m_tCallBack = nil 	
	self.m_bIsLoad = nil
	self.m_bIsHighLight = nil
	self.m_bIsHaveRedDot = nil 
	self.n_fyberTime = nil 
	self.m_nType = nil 
	self.m_bIsFreeCardDiscount = nil
	self.m_tItemData = nil 
	self.m_bIsHotActivity = nil 
	self.b_isClicked = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellWelfareItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellWelfareItem table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellWelfareItem")
    element:setAbsContentSize(GlobalMethod:CCSize(212,65))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief 	设置数据
--@param 	tItemData: 数据
--@param 	nType: 界面类型
function CellWelfareItem:setData(tItemData, nType)
	-- body
	self.m_tItemData = tItemData
	self.m_sItemName = tItemData.name
	self.m_nItemId = tItemData.ui_id
	self.m_nType = nType
end

--@brief 	设置点击回调
function CellWelfareItem:setCallBack(tCell, func)
	-- body
	if self.m_tCallBack == nil then 
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end

--@brief 	设置福利卡打折状态
function CellWelfareItem:setFreeCardDiscountState(bIsFreeCardDiscount)
	-- body
	self.m_bIsFreeCardDiscount = bIsFreeCardDiscount
	if self.m_bIsLoad == false then return end
	self:setCorner()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellWelfareItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
