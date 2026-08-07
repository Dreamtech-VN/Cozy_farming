--CellPrivilegesGrowthData.lua
--@brief	CellPrivilegesGrowth的数据模块
--@date		2022/03/22
--@author	yrd
--@note		大厅特权-成长礼包

CellPrivilegesGrowth = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPrivilegesGrowth:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tTaskItemObj = {} 	--任务对象
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPrivilegesGrowth:_unInit()
	self.m_root = nil
	self.m_tTaskItemObj = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPrivilegesGrowth:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPrivilegesGrowth table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPrivilegesGrowth")
	assert(element, "CellPrivilegesGrowth element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	初始化数据信息
function CellPrivilegesGrowth:setMessage(activityType, activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count ,maxCount, finishCondition)
	self.activityType = activityType
	self.activityId = activityId 
	self.content = json.decode(content)
	self.tips = tips
	self.startTime = startTime 
	self.endTime = endTime 
	self.serverTime = serverTime 
	self.rewardId = rewardId 
	self.status = status
	self.rewardItems = rewardItems 
	self.rewardItemsParamCount = rewardItemsParamCount 
	self.rewardCounts = rewardCounts
	self.count = count
	self.maxCount = maxCount
	self.finishCondition = finishCondition

	WZLog("CellPrivilegesGrowth:setMessage",Serialize(self.content))
	self:updateTaskData()
end

--@brief	更新任务数据
function CellPrivilegesGrowth:updateTaskData()
	self.m_tTaskData = {}
	for k,v in pairs(self.content.rewardItems) do
		local tempData = {}
		tempData.level = tonumber(k)
		tempData.rewardDesc = self.content.rewardDesc[k]
		tempData.giftStates = self.content.giftState[k]
		tempData.rewardItems = {}

	    local rewardItems = SplitStringWithSeparator(self.content.rewardItems[k],"&")
		for i=1,#rewardItems do
	        local rewardItem = string.sub(rewardItems[i],2,-2)
	        local tItem = SplitStringWithSeparator(rewardItem,",")
	        local itemId = tItem[1]
	        if CacheCenter:getPlayerInfo().sex == 1 then
	            itemId = tItem[2]
	        end
	        local itemCount = tItem[3]
	        table.insert(tempData.rewardItems,{itemId=itemId,itemCount=itemCount})
		end

		table.insert(self.m_tTaskData,tempData)
	end

	table.sort( self.m_tTaskData, function(a,b)
		return tonumber(a.level) < tonumber(b.level)
	end )

	WZLog("CellPrivilegesGrowth:updateTaskData",Serialize(self.m_tTaskData))
end

--@brief 	收到领取返回协议
function CellPrivilegesGrowth:getActivityDoOk(activityId, activityType, doType, result, strjson)
	if result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.VIP_RECVSUCCESS)
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.NEWFIRSTCHARGE_TEXT5)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT26)
	end

	if not self.m_root then
		return
	end

	--刷新数据和界
	local content = json.decode(strjson)
	if content.rewards then
		local tItemIds = {}
		local tItemCount = {}
		for i=1,#content.rewards do
			local itemId = content.rewards[i][1]
	        if CacheCenter:getPlayerInfo().sex == 1 then
	            itemId = content.rewards[i][2]
	        end
	        local itemCount = content.rewards[i][3]

	        table.insert(tItemIds,itemId)
	        table.insert(tItemCount,itemCount)
		end
		WndRewardShow:showById(tItemIds,tItemCount)

		self.content.giftState = content.giftStates
		self:updateTaskData()
		self:updateUI()
	end
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPrivilegesGrowth:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
