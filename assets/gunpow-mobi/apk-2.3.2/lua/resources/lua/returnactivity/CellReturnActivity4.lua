--CellReturnActivity4.lua
--@brief	CellReturnActivity4的UI模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动分享好礼


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellReturnActivity4:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellReturnActivity4:onExit(element)
	self:unregister()
	self:_unInit()
end
function CellReturnActivity4:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetReturnActivity4Info,self)
end
function CellReturnActivity4:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetReturnActivity4Info,self)
end
function CellReturnActivity4:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nActivityId,self.m_nActivityType)
	local txtDesc = GetElement(self.m_root,"txtDesc",WZUIFreeTextBox)
	txtDesc:setShowText(LocalStrings.ACTIVITY_TEXT35)
end

function CellReturnActivity4:onBtnRule( ... )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   	WndSingleMapDesc:showInterface(LocalStrings.ACTIVITY_TEXT48)
end

function CellReturnActivity4:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellReturnActivity4:_onGetReturnActivity4Info(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips )
	if activityId == self.m_nActivityId then
		local txtActivity4Time = GetElement(self.m_root,"txtActivity4Time",WZUIFreeTextBox)
		if txtActivity4Time then
			local time = SystemTime:getTimeConverLocal(endTime)
			local str = string.format([[%s<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4"> %s</T>]],LocalStrings.SEVENDAY_TEXT4, time)
			txtActivity4Time:setShowText(str)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块begin--------------------------------------
function CellReturnActivity4:_adaptLanguage_vn()
	GetElement(self.m_root,"txtActivity4Time",WZUIFreeTextBox):setMaxWidth(800)
end
-------------------------------------语言适配模块end--------------------------------------
