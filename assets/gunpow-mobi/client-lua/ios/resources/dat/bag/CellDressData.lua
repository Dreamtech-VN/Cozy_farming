--CellDressData.lua
--@brief	CellDress的数据模块
--@date		2015/03/06
--@author	zsq
--@note		时装格子

CellDress = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellDress:_init()
	self.m_root = nil  			--Cell的根节点
	self.gridElement = nil
	self.gridLuaObj = nil
	self.renewBackFunc = nil
	self.dressBackFunc = nil
	self.m_tData = nil
	self.m_nCountdown = nil		--时装剩余时间
	self.m_sDisappear = nil
	self.m_nShowType = nil 		--时装格子类型
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDress:_unInit()
	self.m_root = nil
	self.gridElement = nil
	self.gridLuaObj = nil
	self.renewBackFunc = nil
	self.dressBackFunc = nil
	self.m_tData = nil
	self.m_nCountdown = nil
	self.m_sDisappear = nil
	self.m_nShowType = nil 		--时装格子类型
end

--@brief   设置续费回调
function CellDress:onRenewCallBack(tcell,backFunc)
	if tcell and backFunc then
		self.renewBackFunc = {}
		self.renewBackFunc[1] = tcell
		self.renewBackFunc[2] = backFunc
	end
end

--@brief   设置穿戴回调
function CellDress:onDressCallBack(tcell,backFunc)
	if tcell and backFunc then
		self.dressBackFunc = {}
		self.dressBackFunc[1] = tcell
		self.dressBackFunc[2] = backFunc
	end
end

--@brief	设置当前战力最高
function CellDress:setFight(bool)
	if self.m_root == nil then return end
	local bool = bool or false
	if GetElement(self.m_root,"imgFight_CellDress",WZUIImage) == nil then return end
	GetElement(self.m_root,"imgFight_CellDress",WZUIImage):setVisible(bool)
	if self.m_tData.floorPrice ~= nil then
		GetElement(self.m_root,"imgFight_CellDress",WZUIImage):setVisible(false)
	end
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellDress:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellDress table create failed!")
	tNewObj:_init()
	--local element = WZUISystem:getInstance():createElement("CellDress")
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
	element:setName("__CellDress")          --用于在表的外面，通过名字获取对应的表结构
    element:setAbsContentSize(GlobalMethod:CCSize(375,92)) 
	assert(element, "CellDress element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellDress:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
