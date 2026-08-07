--[[
活动界面模板

]]
function CellCommonPanel:onEnter(element)
	self.m_root = element
    self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommonPanel:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellCommonPanel:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetRewardCommonResult,self)
	if self.m_nCommonActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND then 
		WZLog("CellCommonPanel:register")
		ProtocolProcessorFestivalActivity:regAll6()
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
		GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
	end
end
function CellCommonPanel:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetRewardCommonResult,self)
	if self.m_nCommonActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND then 
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
		GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
		ProtocolProcessorFestivalActivity:unregAll6()
	end
end
--@brief    初始化信息
function CellCommonPanel:setActivityReturnInfo(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self.m_nActivityId = activityId
    self.m_bIsCharge = tips[1]
    self.m_tCellCommonData = {}
    self.m_nStartTime = startTime
    self.m_nEndTime = endTime
    local data = {} 
    local index = 1
    for i=1,#rewardCounts do
    	local tab = {}
    	tab.status = status[i]
    	local id = {}
    	local num = {}
    	for m=1,rewardCounts[i] do
    		table.insert(id, rewardItems[index])
    		table.insert(num, rewardItemsParamCount[index])
    		index = index + 1
    	end
    	tab.reward_id = i
    	tab.id = id
    	tab.num = num
    	tab.activityId = activityId
    	tab.chargeNum = maxCount --充值金额
    	data[i] = tab
    end
    self.m_tCellCommonData = data

    WZLog("CellCommonPanel:setActivityReturnInfo", self.m_bIsCharge, self.m_nStartTime, self.m_nEndTime, Serialize(data))
end
--排序
function CellCommonPanel:taskTableSort(data_sort)
	local temp = {
		[-1] = 2, --未领取
		[0] = 1, --可领取
		[1] = 3, --已领取
		[2] = 4, --已过期
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.reward_id < b.reward_id
		end
	end
	table.sort(data_sort, testFunc)
end
--@brief    显示窗口
function CellCommonPanel:showWindow(  )
    if not self.m_root then return end
    WZLog("CellCommonPanel:showWindow")
    local txtTime = GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF)
    local _start = SystemTime:getTimeConverLocal4(self.m_nStartTime)
    local _end = SystemTime:getTimeConverLocal4(self.m_nEndTime)
    txtTime:setText(_start.."-".._end)

    local totleRechargeBanner = GetElement(self.m_root,"totleRechargeBanner",WZUIImage)
    local btn_Recharge_event8 = GetElement(self.m_root,"btn_Recharge_event8",WZUIButton)
    local btnRule = GetElement(self.m_root,"btnRule",WZUIButton)
    btnRule:setVisible(false)
    if self.m_nCommonActivityType == g_tGameActivityTypes.ACTIVITY_CHARGE30_REBATE then
    	totleRechargeBanner:setFile("ui/gameActivity/activity_pic_hd_23.png")
    	btnRule:setVisible(true)
    	if tostring(self.m_bIsCharge) == "false" then
    		btn_Recharge_event8:setVisible(true)
    	end
    end

    if self.m_nCommonActivityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND then 
    	totleRechargeBanner:setFile("ui/gameActivity/activity_pic_hd_24.png")
    	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_nActivityId, 2)
    else
    	self:showList()
    end
end

function CellCommonPanel:RechargeEvent8(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    PassportSdkManager:gotoPaymentPage()
end
function CellCommonPanel:onBtnRule()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.OPTIMIZE_TEXT53)
end

function CellCommonPanel:_onGetRewardCommonResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	if self.m_tCellCommonData then
		for i,v in pairs(self.m_tCellCommonData) do
			if rewardId == v.reward_id then
				v.status = 1
				break
			end
		end
		
		self:showList()
	end
end

--@brief 	显示列表
function CellCommonPanel:showList()
	self:taskTableSort(self.m_tCellCommonData)
    local conflConsume = GetElement(self.m_root,"conflConsume1_CellTotalRechargePanel",WZUIFreeListContainer)
    conflConsume:setVisible(true)
    conflConsume:removeAll()
    for i = 1, #self.m_tCellCommonData do
		local element, tLuaObj = CellCommonItem:createElement()
		conflConsume:pushBack(WZUIContainer:luaTo(element))
		conflConsume:getMoveElement():setPositionY(conflConsume:getMinPosition().y)
		tLuaObj:setMessageData(self.m_tCellCommonData[i])
	end
end