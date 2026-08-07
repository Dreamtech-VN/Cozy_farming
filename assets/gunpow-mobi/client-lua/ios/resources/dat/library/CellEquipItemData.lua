--CellEquipItemData.lua
--@brief	CellEquipItem的数据模块
--@date		2016/05/21
--@author	maopeiting
--@note		装备栏物品分类

CellEquipItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellEquipItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil			--物品数据
	self.tag = nil				--物品的tag值
	self.id = nil				--标签栏的tag值
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEquipItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.tag = nil
	self.id = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellEquipItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellEquipItem table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	assert(element, "CellEquipItem element create failed!")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(450,95)) 
	element:setLuaObjectIndex(tNewObj)
	--tNewObj.m_root = element
	return element,tNewObj
end

function CellEquipItem:onLoadData( element )
	local cellElement = WZUISystem:getInstance():createElement("CellEquipItem")     
    self.m_root:addChild(cellElement)
    self:_update()
end

function CellEquipItem:setData( id,data,tag )
	self.id = id
	if self.m_tData == nil then self.m_tData = {} end
	self.m_tData = data
	if tag < 4 and tag >= 2 then
		self.tag = (tag % 4)*4 - 3
	elseif tag >= 4 then
		self.tag = (tag - 1)*4 + 1
	elseif tag == 1 then
		self.tag = tag
	end

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellEquipItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
