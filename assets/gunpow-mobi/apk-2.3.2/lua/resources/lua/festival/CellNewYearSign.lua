--CellNewYearSign.lua
--@brief	CellNewYearSign的UI模块
--@date		2021/04/29
--@author	hyx
--@note		周年签到


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewYearSign:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewYearSign:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellNewYearSign:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetSignInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetSignResult,self)
end
function CellNewYearSign:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetSignInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetSignResult,self)
end
function CellNewYearSign:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nActivityId,self.m_nActivityType)
end

function CellNewYearSign:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewYearSign:_onGetSignInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == self.m_nActivityId then
		self.m_tSignData = self:setSignData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts)

		local signTableContainer = GetElement(self.m_root,"signTableContainer",WZUITableContainer)
		signTableContainer:cleanTable()
		for i = 1, #self.m_tSignData do
	        local celElement,tCell = CellNewYearSignItem:createElement()
	        self.m_tCellSignItem[i] = tCell
			celElement:setTag(i-1)
	        signTableContainer:setCellElement(celElement)
	        tCell:setSignItemData(self.m_tSignData[i], self.m_nActivityId)
		end
	end
end
function CellNewYearSign:_onGetSignResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	if self.m_tCellSignItem and self.m_tCellSignItem[rewardId] then
		self.m_tSignData[rewardId].status = 1
		self.m_tCellSignItem[rewardId]:setSignStatus(1)

		local redpoint = false
		for i,v in pairs(self.m_tSignData) do
			if v.status == 0 then
				redpoint = true
				break
			end
		end
		WndNewYearActivityMain:setRedPointStatus(self.m_nActivityType, redpoint)
	end
end

-------------------------------------私有方法模块End----------------------------------------
