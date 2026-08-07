--CellCardMarkData.lua
--@brief	CellCardMark的数据模块
--@date		2016/07/27
--@author	Tianxiang_Xu
--@note		卡牌标记项

CellCardMark = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCardMark:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_sTitle = nil 
	self.m_bCanTouch = false
	self.m_tCallBack = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCardMark:_unInit()
	self.m_root = nil
	self.m_sTitle = nil 
	self.m_bCanTouch = nil 
	self.m_tCallBack = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCardMark:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCardMark table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCardMark")
	assert(element, "CellCardMark element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
--@param 	sTitle:标题
--@param 	bCanTouch:是否可以触摸
function CellCardMark:setData(sTitle, bCanTouch)
	-- body
	self.m_sTitle = sTitle
	self.m_bCanTouch = bCanTouch

	self:_update()
end

--@brief 	设置回调函数
function CellCardMark:setCallBackFunc(tCell, func)
	-- body
	if self.m_tCallBack == nil then
		self.m_tCallBack = {}
	end
	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCardMark:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
