--CellNewYearBlessData.lua
--@brief	CellNewYearBless的数据模块
--@date		2020/12/24
--@author	hyx
--@note		新年祈福

CellNewYearBless = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearBless:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tShowBigReward = {} --显示大奖奖励
	self.m_tGetBigReward = nil --获取大奖信息
	self.m_nBtnBlessTicker = nil
	self.m_tBlessBoxData = {}
	self.m_tCreateBelssBox = {}
	self.m_nRemainCount = 0
	self.m_nDayTotleCount = 0
	self.m_sFireworkSpine = nil
	self.m_tOpenFireWorkData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearBless:_unInit()
	self.m_root = nil
	self.m_tShowBigReward = {}
	self.m_tGetBigReward = nil
	self.m_nBtnBlessTicker = nil
	self.m_tBlessBoxData = {}
	self.m_tCreateBelssBox = {}
	self.m_nRemainCount = 0
	self.m_nDayTotleCount = 0
	self.m_sFireworkSpine = nil
	self.m_tOpenFireWorkData = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearBless:createElement()
	if CellNewYearBless.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearBless.m_root, CellNewYearBless, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellNewYearBless")
	assert(element, "CellNewYearBless create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

function CellNewYearBless:setActivityIdORType(activityId, _type)
	self.m_nActivityId = activityId
	self.m_nActivityType = _type
end

--宝箱的数据
function CellNewYearBless:setBlessBoxData(rewardId, rewardItems, rewardItemsParamCount, rewardCounts, finishCondition, status)
	if not rewardId or next(rewardId) == nil then
		return {}
	end
	local table_insert = table.insert
	local index = 1
	for i=1, #rewardId do
		local tab = {}
		tab.rewardId = rewardId[i]
		tab.tager = finishCondition[i]
		tab.status = status[i]
		local rewardIds = {}
		local rewardNums = {}
		for m=1,rewardCounts[i] do
			table_insert(rewardIds, rewardItems[index])
			table_insert(rewardNums, rewardItemsParamCount[index])
			index = index + 1
		end
		tab.rewardIds = rewardIds
		tab.rewardNums = rewardNums
		self.m_tBlessBoxData[rewardId[i]] = tab
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearBless:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
