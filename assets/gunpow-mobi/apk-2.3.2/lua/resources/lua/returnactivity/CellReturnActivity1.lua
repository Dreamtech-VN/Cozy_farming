--CellReturnActivity1.lua
--@brief	CellReturnActivity1的UI模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动累登


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellReturnActivity1:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellReturnActivity1:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellReturnActivity1:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetReturnActivity1Info,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetLoginRewardResult,self)
end
function CellReturnActivity1:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetReturnActivity1Info,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetLoginRewardResult,self)
end
function CellReturnActivity1:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nActivityId,self.m_nActivityType)
end


function CellReturnActivity1:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellReturnActivity1:_onGetReturnActivity1Info(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips )
	if activityId == self.m_nActivityId then
		local txtActivity1Time = GetElement(self.m_root,"txtActivity1Time",WZUIFreeTextBox)
		if txtActivity1Time then
			local time = SystemTime:getTimeConverLocal(endTime)
			local str = string.format([[%s<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4"> %s</T>]],LocalStrings.SEVENDAY_TEXT4, time)
			txtActivity1Time:setShowText(str)
		end
		content = json.decode(content)
		local data = self:setActivity1Data(rewardId, status, content)
		self.m_tReturnLoginData = data
		local cell1Container = GetElement(self.m_root,"cell1Container",WZUIContainer)
		local temp_pos = {}
		for i=1,#data do
			if #data[i].reward >= 2 then
				temp_pos[i+1] = true
			end
		end
		local init_posx = 20
		for i=1, #data do
			local celElement,tCell
			local pos = 150
			local is_type = 1
			if #data[i].reward >= 2 then
				is_type = 2
				celElement,tCell = CellLoginItem2:createElement(self.m_nActivityId)
				tCell:setLoginItem2Data(data[i])
			else
				celElement,tCell = CellLoginItem1:createElement(self.m_nActivityId)
				tCell:setLoginItem1Data(data[i])
			end
			self.m_tCellType[i] = is_type
			self.m_tLoginCell[i] = tCell
			celElement:setUseAbsCoordinate(true)
			celElement:setAnchorPoint(ccp(0,0))
			cell1Container:addChild(celElement)
			if temp_pos[i] == true then
				pos = 260
			end
			if i%4 == 1 then
				init_posx = 20
			else
				init_posx = init_posx + pos
			end
			local _y = 220 - (math.floor((i-1)/4)*200)
			celElement:setAbsPosition(GlobalMethod:ccp(init_posx, _y))
		end
	end
end

function CellReturnActivity1:_onGetLoginRewardResult(itemsId, count, _type, rewardId)
	if self.m_nActivityType == _type then
		if self.m_tCellType[rewardId] and self.m_tLoginCell[rewardId] then
			if self.m_tCellType[rewardId] == 1 then
				self.m_tLoginCell[rewardId]:onLoginItem1Status()
			elseif self.m_tCellType[rewardId] == 2 then
				self.m_tLoginCell[rewardId]:onLoginItem2Status()
				WindowManager:removeWindow(CellLoginReward.m_root, CellLoginReward, true)
			end
		end
		WndRewardShow:showById(itemsId, count)
		if self.m_tReturnLoginData[rewardId] then
			self.m_tReturnLoginData[rewardId].status = 1
		end
		local redpoint_status = false
		for i,v in pairs(self.m_tReturnLoginData) do
			if v.status == 0 then
				redpoint_status = true
				break
			end
		end
		WndReturnActivityMain:setReturnRedPointStatus(self.m_nActivityType, redpoint_status)
	end
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块begin--------------------------------------
function CellReturnActivity1:_adaptLanguage_vn()
	GetElement(self.m_root,"txtActivity1Time",WZUIFreeTextBox):setMaxWidth(800)
end
-------------------------------------语言适配模块end--------------------------------------
