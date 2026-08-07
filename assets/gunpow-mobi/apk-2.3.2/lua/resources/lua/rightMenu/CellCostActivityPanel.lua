--CellCostActivityPanel.lua
--@brief	CellCostActivityPanel的UI模块
--@date		2015/02/04
--@author	weidong_wu
--@note		目标奖励活动界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCostActivityPanel:onEnter(element)
	self.m_root = element
	self:_setStaticTxtInfo()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCostActivityPanel:onExit(element)
	GetElement(self.m_root,"flconCostRewardList",WZUIFreeListContainer):disableSchedule()
--	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function CellCostActivityPanel:onEnterTransitionDidFinish(element)
--  	self.m_root:enableSchedule("_scheduleUpdateTime", 0.02)
end

--@brief 	显示窗口
function CellCostActivityPanel:showWindow()
    self:_resetInterface()
	self:_caculateTime()
	self:_setProgress(self.count)
	self:_setTabList()
	self:_setRewardItems()
end

--@brief    初始化信息
function CellCostActivityPanel:setMessage( activityId, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count ,target, index)
	self.activityId=activityId
	self.tips=tips 
	self.startTime=startTime
	self.endTime=endTime
	self.serverTime=serverTime
	self.rewardId=rewardId
	self.status=status 
	self.rewardItems=rewardItems 
	self.rewardItemsParamCount=rewardItemsParamCount 
	self.rewardCounts=rewardCounts 
	self.count = count
	self.target = target
    self.m_nIndex = index
    WZLog("CellCostActivityPanel:setMessage", index)
end


--@brief 	
function CellCostActivityPanel:sortItemByIndex( nIndex )
	WZLog("CellActivityVipPanel:removeItemByIndex index="..nIndex)

	local size =  #CellCostActivityPanel.m_current.m_tRewardList.m_tDoingList
	local removePos = 0
	for i=1,size do
		if nIndex == CellCostActivityPanel.m_current.m_tRewardList.m_tDoingList[i].RewardId then 
		 	local len = #CellCostActivityPanel.m_current.m_tRewardList.m_tDoneList
		 	CellCostActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1] = {}
		 	CellCostActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].RewardId = CellCostActivityPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId
			CellCostActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].AId = CellCostActivityPanel.m_current.m_tRewardList.m_tDoingList[i].activityId
			CellCostActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].items=CellCostActivityPanel.m_current.m_tRewardList.m_tDoingList[i].items
			CellCostActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].state=1
			CellCostActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellCostActivityPanel.m_current.m_tRewardList.m_tDoingList[i].tip
			CellCostActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].target = CellCostActivityPanel.m_current.m_tRewardList.m_tDoingList[i].target
			removePos = i
		end 
	end
	table.remove(CellCostActivityPanel.m_current.m_tRewardList.m_tDoingList,removePos)
	CellCostActivityPanel.m_current:_setRewardItems()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 定时器
function CellCostActivityPanel:_scheduleUpdateTime(element, data)
    self.reduceTime = self.reduceTime + data
    if self.reduceTime > 1.0 then
        self.reduceTime = 0.0
        if self.now_time <= 0 and self.b_scheduleState then
            self.b_scheduleState = false
            self.m_root:disableSchedule()
        elseif self.now_time>0 and self.b_scheduleState then
            self.now_time = self.now_time - 1 
            local n_hour = self.now_time / 3600
            n_hour = math.floor(n_hour)
            local n_min = (self.now_time - n_hour*3600)/60
            n_min = math.floor(n_min)
            local n_sec = self.now_time%60
            local txt_string = string.format("%02d:%02d:%02d",n_hour,n_min,n_sec)
           	self:_setTims(txt_string)
        end
    end 
end

--@brief 计算倒计时时间
function CellCostActivityPanel:_caculateTime(  )
    GetElement(self.m_root,"txt_activity_time_value",WZUILabelTTF):setVisible(false)
    local txt_activity_day_value = GetElement(self.m_root,"txt_activity_day_value",WZUILabelTTF)
    local DayStartTab = os.date("*t",self.startTime)
    local DayEndTab = os.date("*t",self.endTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT,DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    if txt_activity_day_value~= nil then 
        txt_activity_day_value:setText(needDay_str)
    end 
end


--@brief 设置静态文本
function CellCostActivityPanel:_setStaticTxtInfo(  )
	local txt_activity_day_key = GetElement(self.m_root,"txt_activity_day_key",WZUILabelTTF)
	if txt_activity_day_key ~= nil then 
		txt_activity_day_key:setText(LocalStrings.ACTIVE_TIME..":")
	end 
	self:_setDays(0)
	self:_setTims("")
	self:_setProgress(0)
end

--@brief 设置活动剩余天数
function CellCostActivityPanel:_setDays( nDays )
	local txt_activity_day_value = GetElement(self.m_root,"txt_activity_day_value",WZUILabelTTF)
	if txt_activity_day_value~= nil then 
		txt_activity_day_value:setText(string.format(LocalStrings.SHOP_DAY,nDays))
	end 
end

--@brief 设置活动剩余倒计时
function CellCostActivityPanel:_setTims( nTimes )
	local txt_activity_time_value = GetElement(self.m_root,"txt_activity_time_value",WZUILabelTTF)
	if txt_activity_time_value~= nil then 
		txt_activity_time_value:setText(nTimes)
	end 
end

--@brief 	设置进度文本
function CellCostActivityPanel:_setProgress( nProTxt )
	local strInfo = ""
	local hallInfo = GDatatab_integral["id_"..CacheCenter:getPlayerInfo().tournamentLevel]
	if hallInfo == nil then
		strInfo = LocalStrings.DESIGNATION_NO
	else
		strInfo = hallInfo.dan
	end 

	local strProTxt = LocalStrings.ACTIVITY_CURRENT_COMPETILIVE_LEVEL .. strInfo
	local txt_tip_cost_reward = GetElement(self.m_root,"txt_tip_cost_reward",WZUILabelTTF)
	if txt_tip_cost_reward~= nil then 
		txt_tip_cost_reward:setText(strProTxt)
	end 

    local txtCurLevel = GetElement(self.m_root, "txtCurLevel_CellCostActivityPanel", WZUIFreeTextBox)
    local sContentTemp = [[<T C="255,236,193" S="22" P="1" SC="127,70,26" SE="1" SS="4">%s</T><T C="255,227,116" S="22" P="1" SC="127,70,26" SE="1" SS="4">%s</T>]]
    strProTxt = string.format(sContentTemp, LocalStrings.ACTIVITY_CURRENT_COMPETILIVE_LEVEL, strInfo)
    txtCurLevel:setShowText(strProTxt)
end


--@brief 	设置奖励列表
function CellCostActivityPanel:_setRewardItems( )
	local flconCostRewardList = GetElement(self.m_root,"flconCostRewardList",WZUIFreeListContainer)
	if flconCostRewardList == nil then 
		return 
	end 
	if flconCostRewardList:size() > 0 then 
		flconCostRewardList:removeAll()
	end 

	self.cellItemIndex = 1 
    self.m_currentIndex = 1
    flconCostRewardList:enableSchedule("_loadItemByFrame")
end

function CellCostActivityPanel:_loadItemByFrame( element,delate )
	if element == nil then 
        return 
    end 
    element = WZUIFreeListContainer:luaTo(element)

    local listCount = #self.m_tRewardList.m_tDoingList + #self.m_tRewardList.m_tDoneList
    if listCount == 0 then 
        element:disableSchedule()
        return 
    end 
    if self.m_currentIndex > listCount then 
        element:disableSchedule()
        return 
    end 
    local ItemTab = nil 
    if self.m_currentIndex > #self.m_tRewardList.m_tDoingList then 
        ItemTab = self.m_tRewardList.m_tDoneList[self.cellItemIndex]
        self.cellItemIndex = self.cellItemIndex + 1
    else 
        ItemTab = self.m_tRewardList.m_tDoingList[self.cellItemIndex]
        if self.m_currentIndex == #self.m_tRewardList.m_tDoingList then 
            self.cellItemIndex = 1 
        else 
            self.cellItemIndex = self.cellItemIndex + 1
        end 
    end
    if ItemTab then
	    local cellElement,tNewLuaObj = CellCostActivityItem:createElement()
	    tNewLuaObj:setTargetInfo(ItemTab.target)
		tNewLuaObj:setButtonState(ItemTab.state)
		tNewLuaObj:setIdAndRewardId(ItemTab.AId,ItemTab.RewardId)
		tNewLuaObj:setItems(ItemTab.items)
		tNewLuaObj:setIndex(self.m_currentIndex)
		tNewLuaObj:setFunc(self.sortItemByIndex,CellCostActivityPanel)
	    element:pushBack(WZUIContainer:luaTo(cellElement))
	    element:update()
	    element:getMoveElement():setPositionY(element:getMinPosition().y)
	    self.m_currentIndex = self.m_currentIndex + 1
	end
end


--@brief 	设置物品列表
function CellCostActivityPanel:_setTabList(  )
	if not self.rewardItems or next(self.rewardItems) == nil then return end
	if not self.rewardItemsParamCount or next(self.rewardItemsParamCount) == nil then return end

	self.m_tRewardList = {}
	self.m_tRewardList.m_tDoingList = {}
	self.m_tRewardList.m_tDoneList = {}
	local ItemCount = 1
	local DoneIdx = 1
	local DoingIdx = 1
	for i=1,#self.rewardId do
		local Items
		local items = ""
		for j=1,self.rewardCounts[i] do
			if j==self.rewardCounts[i] then 
				items = string.format("%s%d|%d",items,self.rewardItems[ItemCount],self.rewardItemsParamCount[ItemCount])
			else 
				items = string.format("%s%d|%d,",items,self.rewardItems[ItemCount],self.rewardItemsParamCount[ItemCount])
			end 
			ItemCount = ItemCount + 1
		end
		if self.status[i]==1 then 
			Items = self.m_tRewardList.m_tDoneList
			Items[DoneIdx] = {}
			Items[DoneIdx].RewardId = self.rewardId[i]
			Items[DoneIdx].AId = self.activityId 
			Items[DoneIdx].items=items
			Items[DoneIdx].state=self.status[i]
			Items[DoneIdx].tip=self.tips[i]
			Items[DoneIdx].target = self.target[i]
			DoneIdx = DoneIdx +1
		else 
			Items = self.m_tRewardList.m_tDoingList 
			Items[DoingIdx] = {}
			Items[DoingIdx].RewardId = self.rewardId[i]
			Items[DoingIdx].AId = self.activityId
			Items[DoingIdx].items=items
			Items[DoingIdx].state=self.status[i]
			Items[DoingIdx].tip=self.tips[i]
			Items[DoingIdx].target = self.target[i]
			DoingIdx = DoingIdx +1
		end 
	end
end

--@brief    当时竞技目标奖励时，隐藏掉其他内容
function CellCostActivityPanel:_resetInterface()
    -- body
    local flcon = GetElement(self.m_root, "flconCostRewardList", WZUIFreeListContainer)
    local conCurJifen = GetElement(self.m_root, "conCurJifen_CellCostActivityPanel", WZUIContainer)
    local imgBK = GetElement(self.m_root, "imgBK_CellCostActivityPanel", WZUIImage)
    imgBK:setVisible(false)
    if self.m_nIndex == 262 then
        GetElement(self.m_root, "conRole_CellCostActivityPanel", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conTime_CellCostActivityPanel", WZUIContainer):setVisible(false)
        conCurJifen:setVisible(true)
        flcon:setAbsContentSize(GlobalMethod:CCSize(630,420))
        flcon:setRelativeSize(GlobalMethod:CCSize(1,1))
        flcon:updateRelativeSize()
    elseif self.m_nIndex == g_tGameActivityTypes.ACTIVITY_NEWSERVER_ATHLETICSUP then
        GetElement(self.m_root, "conRole_CellCostActivityPanel", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conTime_CellCostActivityPanel", WZUIContainer):setVisible(true)
        conCurJifen:setVisible(false)
        conCurJifen:setRelativePosition(GlobalMethod:ccp(0.5,0.915))
        imgBK:setVisible(true)
        GetElement(self.m_root,"txt_tip_cost_reward",WZUILabelTTF):setVisible(false)

        flcon:setAbsContentSize(GlobalMethod:CCSize(630,345))
        flcon:setRelativeSize(GlobalMethod:CCSize(1,1))
        flcon:updateRelativeSize()
    else
        GetElement(self.m_root, "conRole_CellCostActivityPanel", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conTime_CellCostActivityPanel", WZUIContainer):setVisible(true)
        conCurJifen:setVisible(false)
        flcon:setAbsContentSize(GlobalMethod:CCSize(486,350))
        flcon:setRelativeSize(GlobalMethod:CCSize(1,1))
        flcon:updateRelativeSize()
    end
end
-------------------------------------私有方法模块End----------------------------------------
--------------------------------------语言适配Begin-----------------------------------------
function CellCostActivityPanel:_adaptLanguage_es(  )
	local txtCurLevel = GetElement(self.m_root, "txtCurLevel_CellCostActivityPanel", WZUIFreeTextBox)
	txtCurLevel:setMaxWidth(500)
end

function CellCostActivityPanel:_adaptLanguage_tr(  )
	local txtCurLevel = GetElement(self.m_root, "txtCurLevel_CellCostActivityPanel", WZUIFreeTextBox)
	txtCurLevel:setMaxWidth(500)
end
-------------------------------------语言适配End---------------------------------------------