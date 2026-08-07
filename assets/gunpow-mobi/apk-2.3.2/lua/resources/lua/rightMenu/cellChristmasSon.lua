--cellChristmasSon.lua
--@brief	cellChristmasSon的UI模块
--@date		2020/12/08
--@author	hyc
--@note		圣诞狂欢子item


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function cellChristmasSon:onEnter(element)
	self.m_root = element

	self:_initTxt()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function cellChristmasSon:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------
function cellChristmasSon:onGetReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("zzzzzzzzzzzzzzzzzzzzzzz",self.m_rewardId)
	local tag = self.m_rewardId
	if tag == 1 then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_activityId, self.m_rewardId , 0)
	end
	if tag == 2 then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_activityId, self.m_rewardId , 0)
	end
end

-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


function cellChristmasSon:_initTxt( )
    local fristText = GetElement(self.m_root,"fristText_cellChristmasSon",WZUILabelTTF)
    fristText:setText(LocalStrings.ACTIVITY7001_TEXT1)
    local secondText = GetElement(self.m_root,"secondText_cellChristmasSon",WZUILabelTTF)
    secondText:setText(LocalStrings.ACTIVITY7001_TEXT3)
    local thirdText = GetElement(self.m_root,"thirdText_cellChristmasSon",WZUILabelTTF)
    thirdText:setText(LocalStrings.ACTIVITY7001_TEXT2)
    local fourthText = GetElement(self.m_root,"fourthText_cellChristmasSon",WZUILabelTTF)
    fourthText:setText(LocalStrings.ACTIVITY7001_TEXT3)
end