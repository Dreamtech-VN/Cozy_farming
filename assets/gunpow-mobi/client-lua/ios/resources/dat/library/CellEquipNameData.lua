--CellEquipNameData.lua
--@brief	CellEquipName的数据模块
--@date		2016/05/21
--@author	maopeiting
--@note		装备栏物品名称分类

CellEquipName = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellEquipName:_init()
	self.m_root = nil  			--Cell的根节点
	self.id = nil				--标题的次序
	self.tag = nil				--标签栏的tag值
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEquipName:_unInit()
	self.m_root = nil
	self.id = nil
	self.tag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellEquipName:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellEquipName table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	assert(element, "CellEquipName element create failed!")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(450,40)) 
	element:setLuaObjectIndex(tNewObj)
	--tNewObj.m_root = element
	return element,tNewObj
end

function CellEquipName:onLoadData( element )
	local cellElement = WZUISystem:getInstance():createElement("CellEquipName")
	self.m_root:addChild(cellElement)
	AdaptLanguage(self)
	self:_update()
end

function CellEquipName:setId( tag,id )
	self.tag = tag
	self.id = id
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellEquipName:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
