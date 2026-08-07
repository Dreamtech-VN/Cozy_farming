--CellVipGiftListData.lua
--@brief	CellVipGiftList的数据模块
--@date		2017/01/10
--@author	jiaming_liu
--@note		礼包列表

CellVipGiftList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellVipGiftList:_init()
	self.m_root = nil  			--Cell的根节点
	self.sproductName = nil
	self.m_nType = 0 			--1:周礼包，0：其他
	self.m_tOriginPrice = nil 
	self.m_tCurPrice = nil 
    self.data = {}
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellVipGiftList:_unInit()
	self.m_root = nil
	self.sproductName = nil
	self.m_nType = nil 
	self.m_tOriginPrice = nil 
	self.m_tCurPrice = nil 
    self.data = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellVipGiftList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellVipGiftList table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(870,130))   --这个容器的大小要和cell的大小一致
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end


function CellVipGiftList:setData(data, nType)
    self.data = data
    self.m_nType = nType or 0
    --WZLog("CellVipGiftList:setData", Serialize(data))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellVipGiftList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------
