--CellNewYearRedBag.lua
--@brief	CellNewYearRedBag的UI模块
--@date		2020/12/24
--@author	hyx
--@note		新年红包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearRedBag:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearRedBag:onExit(element)
	if self.m_sRedBagOpenSpine then
		self.m_sRedBagOpenSpine:disableSchedule()
		self.m_sRedBagOpenSpine:removeFromParentAndCleanup(true)
		self.m_sRedBagOpenSpine = nil
	end
	self:unregister()
	self:_unInit()
end

function CellNewYearRedBag:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetRedBagInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetRedBagOpenResult,self)
end
function CellNewYearRedBag:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetRedBagInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetRedBagOpenResult,self)
end

function CellNewYearRedBag:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nActivityId,self.m_nActivityType)
end

function CellNewYearRedBag:onBtnClickOpenRedBag()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nActivityId then
		if self.m_nRemainOpenRedBagCount > 0 then
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 0, "")
			GetElement(self.m_root, "btnOpen_CellNewYearRedBag", WZUIButton):setTouchEnable(false)
		else
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT23)	
		end
	end
end

function CellNewYearRedBag:setRemainCountText(count)
	local remain_count = GetElement(self.m_root,"remain_count",WZUILabelTTF)
	if remain_count then
		remain_count:setText(count)
	end
end
function CellNewYearRedBag:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
function CellNewYearRedBag:createBombSpine()
	if self.m_sRedBagOpenSpine then
		self.m_sRedBagOpenSpine:removeFromParentAndCleanup(true)
		self.m_sRedBagOpenSpine = nil
	end
	local bombSpine = GetElement(self.m_root,"bombSpine",WZUIContainer)
	bombSpine:setVisible(true)
	self.m_sRedBagOpenSpine = WZUISpine:create()
	self.m_sRedBagOpenSpine:setTouchEnable(false)
	self.m_sRedBagOpenSpine:setFileJson("ui/kaihongbao.json")
	self.m_sRedBagOpenSpine:setFileAtlas("ui/kaihongbao.atlas")
	self.m_sRedBagOpenSpine:play("animation", false)
	self.m_sRedBagOpenSpine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	bombSpine:addChild(self.m_sRedBagOpenSpine)

	bombSpine:enableSchedule("animationEventFunc", 0.8)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearRedBag:_onGetRedBagInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if self.m_nActivityId == activityId then
		self.m_nRemainOpenRedBagCount = count
		self:_setGetRedBagTask(count,rewardId,status,rewardCounts,finishCondition)
	end
end
--获得红包的任务
function CellNewYearRedBag:_setGetRedBagTask(count,rewardId,status,rewardCounts,finishCondition)
	self:setRemainCountText(count)

	local flcRedBag = GetElement(self.m_root,"flcRedBag",WZUIFreeListContainer)
	flcRedBag:removeAll()

	local conRedBag1 = CreateElement("conRedBag")
	conRedBag1 = WZUIContainer:luaTo(conRedBag1)
	conRedBag1:setVisible(true)
	local redBagText = GetElement(conRedBag1,"redBagText",WZUIFreeTextBox)
	local status_str = "0/1"
	if status[1] == 1 then
		status_str = "1/1"
	end
	redBagText:setShowText(string.format(LocalStrings.NEWYEAR_TEXT6, status_str))
	flcRedBag:pushBack(conRedBag1)

	for i=2,#rewardId do
		local conRedBag = CreateElement("conRedBag")
		conRedBag = WZUIContainer:luaTo(conRedBag)
		conRedBag:setVisible(true)
		local redBagText = GetElement(conRedBag,"redBagText",WZUIFreeTextBox)

		local progress = rewardId[i].."/"..finishCondition[i]
		local status_str1 = "0/"..rewardCounts[i]
		if status[i] == 1 then
			status_str1 = rewardCounts[i].."/"..rewardCounts[i]
		end
		local str = string.format(LocalStrings.NEWYEAR_TEXT7, i, progress, status_str1)
		redBagText:setShowText(str)

		flcRedBag:pushBack(conRedBag)
	end
	
	flcRedBag:getMoveElement():setPositionY(flcRedBag:getMinPosition().y)
end

function CellNewYearRedBag:_onGetRedBagOpenResult(activityId, doType, result, msg)
	if self.m_nActivityId == activityId then
		if msg then
			msg = json.decode(msg)
			self.m_nRemainOpenRedBagCount = msg.num
			self:setRemainCountText(msg.num)
			if msg.num <= 0 then
				WndNewYearActivityMain:setRedPointStatus(self.m_nActivityType, false)
				WndNewYearActivityMain:setHolidayTitleItemRedPoint(self.m_nActivityType, false)
			end
			local data = {}
			for i=1, #msg.itemIds do
				local tab = {}
				tab.id = msg.itemIds[i]
				tab.num = msg.itemNums[i]
				data[i] = tab
			end
			self.m_tRedBagOpenData = data
			self:createBombSpine()
		--	self:animationEventFunc()
		end
	end
end
function CellNewYearRedBag:animationEventFunc(element)
	if element then 
		element:disableSchedule()
		element:setVisible(false)
	end
--	self:createBombSpine()
	if self.m_tRedBagOpenData then
		CellNewYearRedBagOpen:showInterface(self.m_tRedBagOpenData)
		GetElement(self.m_root, "btnOpen_CellNewYearRedBag", WZUIButton):setTouchEnable(true)
	end
end
-------------------------------------私有方法模块End----------------------------------------
