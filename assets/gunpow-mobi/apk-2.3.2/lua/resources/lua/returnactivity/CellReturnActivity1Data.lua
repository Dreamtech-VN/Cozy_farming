--CellReturnActivity1Data.lua
--@brief	CellReturnActivity1的数据模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动累登

CellReturnActivity1 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellReturnActivity1:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLoginCell = {}
	self.m_tCellType = {}
	self.m_tReturnLoginData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellReturnActivity1:_unInit()
	self.m_root = nil
	self.m_tLoginCell = {}
	self.m_tCellType = {}
	self.m_tReturnLoginData = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellReturnActivity1:createElement()
	if CellReturnActivity1.m_root ~= nil then
		WindowManager:removeWindow(CellReturnActivity1.m_root, CellReturnActivity1, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellReturnActivity1")
	assert(element, "CellReturnActivity1 create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

function CellReturnActivity1:setActivityIdORType(activityId, _type)
	self.m_nActivityId = activityId
	self.m_nActivityType = _type
end

function CellReturnActivity1:setActivity1Data(rewardId, status, content)
	local data = {}
	for i=1, #rewardId do
		local tab = {}
		tab.id = rewardId[i]
		tab.status = status[i]
		tab.reward = content[i]
		data[i] = tab
	end
	return data
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellReturnActivity1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
