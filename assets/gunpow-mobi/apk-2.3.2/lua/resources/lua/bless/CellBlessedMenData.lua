--CellBlessedMenData.lua
--@brief	CellBlessedMen的数据模块
--@date		2016/03/28
--@author	Tianxiang_Xu
--@note		祈福师节点

CellBlessedMen = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBlessedMen:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 			--节点数据
	self.m_tCallBack = nil 		--回调列表
	self.m_bIsCanTouch = true 	--判断祈福师是否可以点击
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBlessedMen:_unInit()
	self.m_root = nil
	self.m_tData = nil 			--节点数据
	self.m_tCallBack = nil 		--回调列表
	self.m_bIsCanTouch = nil 	--判断祈福师是否可以点击
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBlessedMen:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBlessedMen table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellBlessedMen")
	assert(element, "CellBlessedMen element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置节点数据
function CellBlessedMen:setData(tData)
	-- body
	if tData == nil or tData == {} then
		return
	end

	self.m_tData = tData
	WZLog("CellBlessedMen:setData", Serialize(tData))

	self:update()
end

--@brief 	设置召唤回调
function CellBlessedMen:setCallBackFun(tCell, func)
	--body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBlessedMen:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
