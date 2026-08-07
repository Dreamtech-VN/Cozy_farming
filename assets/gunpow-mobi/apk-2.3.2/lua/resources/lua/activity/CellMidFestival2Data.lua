--CellMidFestival2Data.lua
--@brief	CellMidFestival2的数据模块
--@date		2021/08/18
--@author	hyx
--@note		中秋活动1

CellMidFestival2 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMidFestival2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tActivityData = {}
	self.m_nRewardId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMidFestival2:_unInit()
	self.m_root = nil
	self.m_tActivityData = {}
	self.m_nRewardId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellMidFestival2:createElement()
	if CellMidFestival2.m_root ~= nil then
		WindowManager:removeWindow(CellMidFestival2.m_root, CellMidFestival2, true)
	end
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellMidFestival2")
	assert(element, "CellMidFestival2 create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end
function CellMidFestival2:setAcvitityData(data)
	self.m_tActivityData = data
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMidFestival2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
