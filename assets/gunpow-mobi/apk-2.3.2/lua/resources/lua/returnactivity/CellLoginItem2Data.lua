--CellLoginItem2Data.lua
--@brief	CellLoginItem2的数据模块
--@date		2021/05/20
--@author	hyx
--@note		回归活动累登子项2

CellLoginItem2 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellLoginItem2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nActivityId = nil
	self.m_sGetSpine = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLoginItem2:_unInit()
	self.m_root = nil
	self.m_nActivityId = nil
	self.m_sGetSpine = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellLoginItem2:createElement(activityId)
	if CellLoginItem2.m_root ~= nil then
		WindowManager:removeWindow(CellLoginItem2.m_root, CellLoginItem2, true)
	end
	local tNewObj = self:_new()
	assert(tNewObj, "CellLoginItem2 table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellLoginItem2")
	assert(element, "CellLoginItem2 element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self.m_nActivityId = activityId
	return element,tNewObj
end


function CellLoginItem2:setLoginItem2Data(data)
	self.m_tLoginItem2Data = data
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLoginItem2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
