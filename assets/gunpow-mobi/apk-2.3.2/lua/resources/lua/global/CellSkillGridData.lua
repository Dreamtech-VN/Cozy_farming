--CellSkillGridData.lua
--@brief	CellSkillGrid的数据模块
--@date		2021/06/04
--@author	yrd
--@note		一个技能格子

CellSkillGrid = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSkillGrid:_init()
	self.m_root = nil  			--Cell的根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSkillGrid:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSkillGrid:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSkillGrid table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellSkillGrid")
	assert(element, "CellSkillGrid element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 设置一个本地配置的物品ID,去初始化改物品框
function CellSkillGrid:showSkillById(localSkillId, number)
	local sKey = string.format("id_%s", localSkillId)
	local mData = GDatatab_skill[sKey]
	if nil == mData then
		return
	end
	local t = {}
	t.basicInfo = mData
	t.lastNum = tonumber(number)
	self:setCellSkillItem(t)
end

--@brief	设置数据
function CellSkillGrid:setCellSkillItem(tData)
    self.m_tItem = {}
	self.m_tItem = tData
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSkillGrid:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
