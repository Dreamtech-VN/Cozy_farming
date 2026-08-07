--CellMidFestival2.lua
--@brief	CellMidFestival2的UI模块
--@date		2021/08/18
--@author	hyx
--@note		中秋活动1


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMidFestival2:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMidFestival2:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellMidFestival2:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function CellMidFestival2:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
end
function CellMidFestival2:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(self.m_tActivityData.activityId, 1)
end
function CellMidFestival2:actionCallback()
	local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
	local startTime = SystemTime:getTimeConverLocal(self.m_tActivityData.startTime)
	local endTime = SystemTime:getTimeConverLocal11(self.m_tActivityData.endTime)
	txtActivityTime:setText(startTime.."-"..endTime)
end

function CellMidFestival2:onBtnGotoCharge()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndNewVip:showInterface(1)
	WindowManager:removeWindow(WndMidFestivalActivity.m_root, WndMidFestivalActivity, true)
end
function CellMidFestival2:onBtnGetReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nRewardId then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tActivityData.activityId, self.m_nRewardId)
	end
end
function CellMidFestival2:onBtnCheckGift(element)
	if not self.m_nRewardId then return end
	local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
	local info = CopyTable(GDatatab_item["id_"..taskData.reward[1][1]]) 
	if info then
		local itemInfo = {lastTime=1,lastNum=1,basicInfo=CopyTable(info)}
		WndItemInfo:showInfo(element,self.m_root,1,info,false,nil,true)
	end
end
function CellMidFestival2:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMidFestival2:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	if self.m_tActivityData.activityId == activityId then
		--按照需求任务每次只会有一条
		self.m_nRewardId = id[1] or 0
		self:setGetButtomState(status[1])
		local txtRichTask = GetElement(self.m_root,"txtRichTask",WZUIFreeTextBox)
		local taskData = GDatatab_new_activity_task["id_"..self.m_nRewardId]
		if taskData then
			local str1 = progress[1].."/"..target[1]
			local str2 = progress[2].."/"..target[2]
			txtRichTask:setShowText(string.format(taskData.desc, str1, str2))
			local txtGiftBagName = GetElement(self.m_root, "txtGiftBagName_CellMidFestival", WZUILabelTTF)
			if txtGiftBagName then 
				local basicData = GDatatab_item["id_" .. taskData.reward[1][1]]
				if basicData then 
					txtGiftBagName:setText(basicData.name)
				end
			end
		end
	end
end
function CellMidFestival2:setGetButtomState(status)
	local btnGetReward = GetElement(self.m_root,"btnGetReward",WZUIButton)
	local txtGetReward = GetElement(btnGetReward,"txtGetReward",WZUILabelTTF)
	btnGetReward:setVisible(true)
	btnGetReward:setTouchEnable(status == 0)
	if status == -1 or status == 1 then
		txtGetReward:setColor(ccc3(255,255,255))
		if status == 1 then
			txtGetReward:setText(LocalStrings.ACTIVE_GET)
		else
			txtGetReward:setText(LocalStrings.INVITE_RECEIVE)
		end
	elseif status == 0 then
		txtGetReward:setColor(ccc3(114,55,9))
		txtGetReward:setText(LocalStrings.INVITE_RECEIVE)
	end
end
function CellMidFestival2:_onGetTaskResult(activityId, taskId)
	if self.m_tActivityData.activityId == activityId then
		WndMidFestivalActivity:setVisibleTitleRedPoint(false)
		self:setGetButtomState(1)
	end
end




-------------------------------------私有方法模块End----------------------------------------
