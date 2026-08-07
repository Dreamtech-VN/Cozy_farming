--CellPetChoiceListData.lua
--@brief	CellPetChoiceList的数据模块
--@date		2015/05/22
--@author	zhangming
--@note		宠物选择Cell

CellPetChoiceList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPetChoiceList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nType = 0            --空间类型，1为升级，2为进阶，3为重生
	self.t_PetInfo = {}         --宠物的属性
	self.m_nOtherValue = 0      --属性值，不同列表代表不同的属性值
	self.b_isClick = false      --是否已勾选
	self.n_Tag = 0              --tag,用于记录标签
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPetChoiceList:_unInit()
	self.m_root = nil
	self.m_nType = nil
	self.t_PetInfo = nil
	self.m_nOtherValue = nil
	self.b_isClick = nil
	self.n_Tag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPetChoiceList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPetChoiceList table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("CellMailList")          --”√”⁄‘⁄±ÌµƒÕ‚√Ê£¨Õ®π˝√˚◊÷ªÒ»°∂‘”¶µƒ±ÌΩ·ππ
    element:setAbsContentSize(GlobalMethod:CCSize(383,100))
	assert(element, "CellPetChoiceList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPetChoiceList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
