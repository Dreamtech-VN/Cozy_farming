--CellBlessItemData.lua
--@brief	CellBlessItem的数据模块
--@date		2016/03/25
--@author	Tianxiang_Xu
--@note		祈福节点

CellBlessItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBlessItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 			--节点数据
	self.m_nType = nil 			--节点类型
	self.m_tTipParentNode = nil 	--节点tips框父节点
	self.m_tCallBack = nil 		--回调表
	self.m_tDevourCallBack = nil 	--吞噬界面的回调
	self.m_bIsGrayBG = false 
	self.m_tCallBack2 = nil 		--回调表
	self.m_bIsExtraction = false 	--是否是萃取
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBlessItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 			--节点数据
	self.m_nType = nil 			--节点类型
	self.m_tTipParentNode = nil 	--节点tips框父节点
	self.m_tCallBack = nil 		--回调表
	self.m_tDevourCallBack = nil 	--吞噬界面的回调
	self.m_bIsGrayBG = nil 		
	self.m_tCallBack2 = nil 		--回调表
	self.m_bIsExtraction = nil  	--是否是萃取
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBlessItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBlessItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellBlessItem")
	assert(element, "CellBlessItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置节点数据
--@tData 	节点相关数据信息
--@nType 	类型：根据类型，显示不同状态
--@param 	parentNode ：祝福tips框父节点
--@note 	祈福数据
function CellBlessItem:setData(tData, nType, parentNode)
	-- body
	self.m_tData = tData
	self.m_nType = nType
	self.m_tTipParentNode = parentNode
	-- if not self.m_tData then 
	-- 	WZLog("CellBlessItem:setData  tData is nil")
	-- 	return
	-- end

	--刷新界面的显示信息
	self:update()
end

--@brief 	设置回调方法
function CellBlessItem:setCallBackFun(tCell, func1, func2, func3)
	-- body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func1
	self.m_tCallBack[3] = func2
	self.m_tCallBack[4] = func3
end

--@brief 	设置吞噬界面点击祝福回调方法
function CellBlessItem:setDevourCallBackFun(tCell, func1)
	-- body
	if self.m_tDevourCallBack == nil then
		self.m_tDevourCallBack = {}
	end

	self.m_tDevourCallBack[1] = tCell
	self.m_tDevourCallBack[2] = func1
end

--@brief 	设置融合界面点击祝福回调方法
function CellBlessItem:setFuseCallBackFun(tCell, func1)
	-- body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func1
end

--@brief 	设置萃取界面点击祝福回调方法
function CellBlessItem:setExtractionCallBackFun(tCell, func1)
	-- body
	if self.m_tCallBack2 == nil then
		self.m_tCallBack2 = {}
	end

	self.m_tCallBack2[1] = tCell
	self.m_tCallBack2[2] = func1
end

--@brief 	设置萃取
function CellBlessItem:setExtraction(bool)
	-- body
	self.m_bIsExtraction = bool 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBlessItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
