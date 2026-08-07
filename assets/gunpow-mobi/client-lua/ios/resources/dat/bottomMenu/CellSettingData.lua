--CellSettingData.lua
--@brief	CellSetting的数据模块
--@date		2014/03/27
--@author	liangguang_long
--@note		设置模块

CellSetting = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSetting:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 			--数据列表
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSetting:_unInit()
	self.m_root = nil
	self.m_tData = nil 			--数据列表
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSetting:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSetting table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellSetting")
	assert(element, "CellSetting element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSetting:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	数据列表
--@param	tData[1]:回调节点
--@param	tData[2]:回调函数名
--@param	tData[3]:正常状体图片
--@param	tData[4]:选中状态图片
--@param	tData[5]:按钮文字图片
function CellSetting:setAllData(tData)
	self.m_tData = {}
	self.m_tData = tData
	--更新函数
	self:_update()
end

-------------------------------------私有方法模块End----------------------------------------
