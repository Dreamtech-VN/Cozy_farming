--CellCommonBoxData.lua
--@brief	CellCommonBox的数据模块
--@date		2021/02/22
--@author	hyx
--@note		宝箱的进度条

CellCommonBox = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellCommonBox:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBoxBaseMsg = {}
	self.m_tCreateCommonBox = {}
	self.m_nActivityId = nil
	self.m_nDayTotleCount = nil
	self.m_sBoxCommonProgress = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellCommonBox:_unInit()
	self.m_root = nil
	self.m_tBoxBaseMsg = {}
	self.m_tCreateCommonBox = {}
	self.m_nActivityId = nil
	self.m_nDayTotleCount = nil
	self.m_sBoxCommonProgress = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellCommonBox:createElement(data,activityId, _type)
	if CellCommonBox.m_root ~= nil then
		WindowManager:removeWindow(CellCommonBox.m_root, CellCommonBox, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellCommonBox")
	assert(element, "CellCommonBox create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element

	tNewObj.m_tBoxBaseMsg = data or {}
	if activityId then
		self.m_nActivityId = tonumber(activityId)
	end
	self.m_nBoxType = _type or 1 --默认是1  2:崛起之路
	return element, tNewObj
end


--宝箱数据
--[[
rewardId: 宝箱id
status: 宝箱状态
rewardItems:奖励的物品id
rewardItemsParamCount:奖励的物品数量
rewardCounts:切割的数量
finishCondition:宝箱的目标数量
]]
function CellCommonBox:setBoxProgressData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,finishCondition)
	local index = 1
	local table_insert = table.insert
	local box_data = {}
	for i,v in ipairs(rewardCounts) do
		local tab = {}
		tab.id = rewardId[i]
		tab.tager = finishCondition[i]
		tab.status = status[i]
		local reward_id = {}
		local reward_num = {}
		for m=1,rewardCounts[i] do
			table_insert(reward_id,rewardItems[index])
			table_insert(reward_num,rewardItemsParamCount[index])
			index = index + 1
		end
		tab.reward_id = reward_id
		tab.reward_num = reward_num
		box_data[rewardId[i]] = tab
	end
	return box_data
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellCommonBox:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
