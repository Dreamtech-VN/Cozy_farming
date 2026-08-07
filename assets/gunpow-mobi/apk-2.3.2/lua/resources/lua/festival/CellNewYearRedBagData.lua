--CellNewYearRedBagData.lua
--@brief	CellNewYearRedBag的数据模块
--@date		2020/12/24
--@author	hyx
--@note		新年红包

CellNewYearRedBag = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearRedBag:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nRemainOpenRedBagCount = 0
	self.m_sRedBagOpenSpine = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearRedBag:_unInit()
	self.m_root = nil
	self.m_nRemainOpenRedBagCount = 0
	self.m_sRedBagOpenSpine = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearRedBag:createElement()
	if CellNewYearRedBag.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearRedBag.m_root, CellNewYearRedBag, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellNewYearRedBag")
	assert(element, "CellNewYearRedBag create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

function CellNewYearRedBag:setActivityIdORType(activityId, _type)
	self.m_nActivityId = activityId
	self.m_nActivityType = _type
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearRedBag:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
