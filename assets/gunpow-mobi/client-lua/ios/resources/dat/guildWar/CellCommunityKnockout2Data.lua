--CellCommunityKnockout2Data.lua
--@brief	CellCommunityKnockout2的数据模块
--@date		2016/08/22
--@author	Tianxiang_Xu
--@note		公会战房间参战成员子节点

CellCommunityKnockout2 = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCommunityKnockout2:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_nType = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCommunityKnockout2:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_tCallBack = nil 
	self.m_nType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommunityKnockout2:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommunityKnockout2 table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setName("__CellCommunityKnockout2")
	element:setLuaObjectIndex(tNewObj)
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(275,105))

	return element,tNewObj
end

--@brief 	设置数据
--@param 	nType:类型：1->会长；2->非会长
function CellCommunityKnockout2:setData(tData, nType)
	-- body
	self.m_tData = tData
	self.m_nType = nType 
end

--@brief 	设置点击回调函数
function CellCommunityKnockout2:setCallBackFunc(tCell, func)
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
function CellCommunityKnockout2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
