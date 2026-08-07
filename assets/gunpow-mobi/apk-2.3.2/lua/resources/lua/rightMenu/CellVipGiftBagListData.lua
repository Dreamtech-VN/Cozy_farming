--CellVipGiftBagListData.lua
--@brief	CellVipGiftBagList的数据模块
--@date		2014/04/19
--@author	jiaming_liu
--@note		会员每日礼包详情列表

CellVipGiftBagList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellVipGiftBagList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nBtnStauts = 0 		--按钮状态，1表示已经领取，2表示VIP多少可以领取，3表示领取
	self.m_tData = nil          -- 存在VIP等级奖励的信息
	self.m_nIndex = 1           -- 当前cell的index
	self.m_tWindwos = nil
	self.m_nLv = nil            -- 当前VIP等级
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellVipGiftBagList:_unInit()
	self.m_root = nil
	self.m_nBtnStauts = nil
	self.m_tData = nil
	self.m_nIndex = nil
	self.m_tWindwos = nil
	self.m_nLv = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellVipGiftBagList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellVipGiftBagList table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellVipGiftBagList")
	assert(element, "CellVipGiftBagList element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellVipGiftBagList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
