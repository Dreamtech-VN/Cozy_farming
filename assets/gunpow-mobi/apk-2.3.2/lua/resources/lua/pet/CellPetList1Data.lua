--CellPetList1Data.lua
--@brief	CellPetList1的数据模块
--@date		2021/03/01
--@author	hyc
--@note		宠物列表

CellPetList1 = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPetList1:_init()
	self.m_root = nil  			--Cell的根节点
	self.t_PetInfo = {}         --宠物的属性
	self.choiceState = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPetList1:_unInit()
	self.m_root = nil
	self.t_PetInfo = nil
	self.choiceState = nil
	
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPetList1:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPetList table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("CellMailList")          --”√”⁄‘⁄±ÌµƒÕ‚√Ê£¨Õ®π˝√˚◊÷ªÒ»°∂‘”¶µƒ±ÌΩ·ππ
    element:setAbsContentSize(GlobalMethod:CCSize(133,187))
	assert(element, "CellPetList1 element create failed!")
	tNewObj.m_root = element
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPetList1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------
