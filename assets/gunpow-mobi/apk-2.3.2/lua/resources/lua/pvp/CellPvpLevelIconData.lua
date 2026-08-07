--CellPvpLevelIconData.lua
--@brief	CellPvpLevelIcon的数据模块
--@date		2017/02/13
--@author	Tianxiang_Xu
--@note		排位赛等级图标节点

CellPvpLevelIcon = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPvpLevelIcon:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_bIsCircleVisible = false 
	self.m_nScale = 1 
	self.m_bCanTouch = false 
	self.m_tPvpData = nil 
	self.m_nCurIntegral = 0
	self.m_nHistoryMaxLevel = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPvpLevelIcon:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_bIsCircleVisible = nil  
	self.m_nScale = nil 
	self.m_bCanTouch = nil  
	self.m_tPvpData = nil 
	self.m_nCurIntegral = nil 
	self.m_nHistoryMaxLevel = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPvpLevelIcon:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPvpLevelIcon table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPvpLevelIcon")
	assert(element, "CellPvpLevelIcon element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
--@param 	nScale：节点缩放倍数
--@param	bCanTouch : 是否可以点击查看tips
function CellPvpLevelIcon:setData(tData, bIsCircleVisible, nScale, bCanTouch)
	-- body
	self.m_tData = tData
	self.m_bIsCircleVisible = bIsCircleVisible
	if self.m_bIsCircleVisible == nil then
		self.m_bIsCircleVisible = true
	end
	self.m_nScale = nScale or 1
	self.m_bCanTouch = bCanTouch or false 

	self:_update()
end

--@brief 	设置排位数据
--@param 	sMessage:json格式的数据
function CellPvpLevelIcon:setPvpRankData(sMessage, nIntegral, historyMaxLevel)
	-- body
	self.m_tPvpData = json.decode(sMessage)
	self.m_nCurIntegral = nIntegral
	self.m_nHistoryMaxLevel = historyMaxLevel
end
--------------------------------公有方法模块End----------------------------------------


--------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPvpLevelIcon:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
