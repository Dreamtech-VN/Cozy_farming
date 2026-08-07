--CellPetSellData.lua
--@brief	CellPetSell的数据模块
--@date		2018/01/25
--@author	zsq
--@note		回收宠物cell

CellPetSell = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPetSell:_init()
	self.m_root = nil  			--Cell的根节点
	self.selected = false
	self.onTouch = false
	self.m_nType = 0
	self.num = nil				--经验宠物总数
	self.tag = nil
	self.chooseNum = 0
	self.m_nSpace = 0.18
	self.m_aniStone1 = nil		--镶嵌动画
	self.m_aniStone2 = nil		--镶嵌动画
	self.m_aniStone3 = nil		--镶嵌动画
	self.m_aniStone4 = nil		--镶嵌动画
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPetSell:_unInit()
	self.m_root = nil
	self.selected = nil
	self.onTouch = nil
	self.m_nType = nil 
	self.num = nil 				
	self.tag = nil
	self.chooseNum = nil
	self.m_nSpace = nil
	self.m_aniStone1 = nil		--镶嵌动画
	self.m_aniStone2 = nil		--镶嵌动画
	self.m_aniStone3 = nil		--镶嵌动画
	self.m_aniStone4 = nil		--镶嵌动画
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPetSell:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPetSell table create failed!")
	tNewObj:_init()
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellPetSell")          --用于在表的外面，通过名字获取对应的表结构
    element:setAbsContentSize(GlobalMethod:CCSize(90,90))   --这个容器的大小要和cell的大小一致

	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief    获取已选择的数量
function CellPetSell:getChooseNum()
    -- body
    return self.chooseNum or 0
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPetSell:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
