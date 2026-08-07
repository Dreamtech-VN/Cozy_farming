--CellSelPriceData.lua
--@brief	CellSelPrice的数据模块
--@date		2015-5-26
--@author	binshao
--@note		商城道具类型选择模块

CellSelPrice = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSelPrice:_init()
	self.m_root = nil  			    --Cell的根节点
	self.m_propData = nil 			--道具数据
    self.m_tCallBackFunc = nil      -- 回调函数
    self.m_nCurPrice = nil          -- 当前选中商品的价格
    self.m_tPrice = {}              -- 商品的当前选择价格和天数
    self.m_curData = {}
    self.selState = true
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSelPrice:_unInit()
	self.m_root = nil
	self.m_propData = nil
    self.m_tCallBackFunc = nil
    self.m_tPrice = nil
    self.m_nCurPrice = nil
    self.m_curData = nil
	self.selState = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSelPrice:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSelPrice table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellSelPrice")
	assert(element, "CellSelPrice element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSelPrice:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	数据列表
function CellSelPrice:SetCellPriceData(tData)
	self.m_propData = {}
	self.m_propData = tData
    self.m_curData = {index = 0,id = tData.initData.id}
	self:_update()
end

-- 设置回调
function CellSelPrice:SetCallBackFunc(element,backFunc)
    self.m_tCallBackFunc = {}
    self.m_tCallBackFunc[1] = element
    self.m_tCallBackFunc[2] = backFunc
end
-------------------------------------私有方法模块End----------------------------------------
