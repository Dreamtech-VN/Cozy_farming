--CellKidSchoolApproveData.lua
--@brief	CellKidSchoolApprove的数据模块
--@date		2021/04/23
--@author	yrd
--@note		孩子学校会员审批-子项

CellKidSchoolApprove = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellKidSchoolApprove:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = {}
	self.m_bIsSelectedState = false		--是否选中 true:选中 false:没选
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellKidSchoolApprove:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsSelectedState = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellKidSchoolApprove:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellKidSchoolApprove table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellKidSchoolApprove")
	assert(element, "CellKidSchoolApprove element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置数据
function CellKidSchoolApprove:setData(tData)
	self.m_tData = tData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellKidSchoolApprove:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
