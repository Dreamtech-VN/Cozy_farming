--CellFuseBlessListData.lua
--@brief	CellFuseBlessList的数据模块
--@date		2016/10/12
--@author	Tianxiang_Xu
--@note		圣光系统-融合祈福子节点

CellFuseBlessList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellFuseBlessList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nLabelIndex = nil 
	self.m_tCallBack = nil 
	self.m_nIsLoaded = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFuseBlessList:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nLabelIndex = nil 
	self.m_tCallBack = nil 
	self.m_nIsLoaded = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellFuseBlessList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFuseBlessList table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellFuseBlessList")
	element:setAbsContentSize(GlobalMethod:CCSize(311,101))
	element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
function CellFuseBlessList:setData(tData, nLabelIndex)
	-- body
	self.m_tData = tData 
	self.m_nLabelIndex = nLabelIndex
end

--@brief 	设置回调函数
function CellFuseBlessList:setCallBackFunc(tCell, func)
	-- body
	self.m_tCallBack = {}

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFuseBlessList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
