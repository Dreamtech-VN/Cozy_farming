--WndHonorPoint.lua
--@brief	WndHonorPoint的UI模块
--@date		2020/10/30
--@author	hyx
--@note		荣誉积分过低的提示框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHonorPoint:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHonorPoint:onExit(element)
	if self.m_nHonorScheduleId then 
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nHonorScheduleId)
		self.m_nHonorScheduleId = nil
	end 
	self:_unInit()	
	self:unregister()
end

function WndHonorPoint:register()
    GlobalGame:getGameEventDispathcer():Add(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onWndHonorPointInfoData,self)
end
function WndHonorPoint:unregister()
    GlobalGame:getGameEventDispathcer():Remove(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onWndHonorPointInfoData,self)
end

function WndHonorPoint:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end

function WndHonorPoint:actionCallback()
end

function WndHonorPoint:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nHonorScheduleId then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nHonorScheduleId)
		self.m_nHonorScheduleId = nil
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndHonorPoint:showInterface(score, honourPoint, restoreTime, serverTime)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local honorpoint = WndHonorPoint:createElement()
	if honorpoint ~= nil then
	    WindowManager:addWindow(honorpoint,WndHonorPoint,nil,false)
	end
	self:_onHonorPointInfoData(score, honourPoint, restoreTime, serverTime)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
function WndHonorPoint:_onWndHonorPointInfoData(honourPoint, restoreTime, serverTime)
	if not self.m_root then return end

	if restoreTime <= 0 then
		return
	end
	self:onDescMessage(self.m_nCurPlayingScore, honourPoint, restoreTime, serverTime)
end
function WndHonorPoint:_onHonorPointInfoData(score, honourPoint, restoreTime, serverTime)
	if not self.m_root then return end
	self.m_nCurPlayingScore = score

	if not honourPoint then
		self:register()
		ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo( )
	else
		self:onDescMessage(score, honourPoint, restoreTime, serverTime)
	end
end

function WndHonorPoint:onDescMessage(score, honourPoint, restoreTime, serverTime)
	local curHonorPoint = GetElement(self.m_root,"curHonorPoint",WZUILabelTTF)
	if curHonorPoint then
		curHonorPoint:setText(honourPoint)
	end
	local lowHonorPointValue = GetElement(self.m_root,"lowHonorPointValue",WZUILabelTTF)
	local value1 = 2
	local value2 = 1
	if lowHonorPointValue then
		local creditRecover = CacheCenter:getGameParam().creditRecover
		if creditRecover then
			local _string = string.sub(creditRecover,2,-2)
			value1 = SplitStringWithSeparator(_string,",")[1]
			value2 = SplitStringWithSeparator(_string,",")[2]
		end
		score = score or 60
		lowHonorPointValue:setText(string.format(LocalStrings.OPTIMIZE_TEXT17, score, value1, value2))
	end

	if restoreTime <= 0 then
		GetElement(self.m_root,"remainTime",WZUILabelTTF):setText("00:00:00")
	else
		local temp_score = score-honourPoint
		local time = restoreTime+ temp_score*(tonumber(value1)*60)*60 - serverTime
		if time <= 0 then
			time = 0
		end
		self.m_nCurCountDownTime = time
		self.m_sRemainTimeLabel = GetElement(self.m_root,"remainTime",WZUILabelTTF)
		if self.m_sRemainTimeLabel then	
			self.m_sRemainTimeLabel:setText(SystemTime:getTimeConverLocal2(time))
		end
		self.m_nHonorScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function(dt)
	        self:_onTimeCountDown(dt)
	    end, 1, false)
	end
end
function WndHonorPoint:_onTimeCountDown(dt)
	if self.m_sRemainTimeLabel then
		if self.m_nCurCountDownTime <= 0 then
			if self.m_nHonorScheduleId then 
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nHonorScheduleId)
				self.m_nHonorScheduleId = nil
			end 
		else
			self.m_nCurCountDownTime = self.m_nCurCountDownTime - 1
			self.m_sRemainTimeLabel:setText(SystemTime:getTimeConverLocal2(self.m_nCurCountDownTime))	
		end		
	end
end

-------------------------------------私有方法模块End----------------------------------------
