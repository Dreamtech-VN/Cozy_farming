--CellBookListItemData.lua
--@brief	CellBookListItem的数据模块
--@date		2021/01/07
--@author	hyc
--@note		4个图鉴

CellBookListItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBookListItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_index = nil			--用以区分皮肤
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBookListItem:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_index = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBookListItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBookListItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellBookListItem")
    element:setAbsContentSize(GlobalMethod:CCSize(1000,260))
    element:setLuaObjectIndex(tNewObj)

	return element,tNewObj
end

--@brief 	设置数据
function CellBookListItem:setData(tData,index)
	--body
	WZLog("1第几个",index)
	self.m_tData = tData
	self.m_index = index
end

--@brief 	设置点击卡牌的回调函数
function CellBookListItem:setCallBackFunc(tCell, func, func2)
	-- body
	if self.m_tCallBack == nil  then
		self.m_tCallBack = {}
	end

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
	self.m_tCallBack[3] = func2
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBookListItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
