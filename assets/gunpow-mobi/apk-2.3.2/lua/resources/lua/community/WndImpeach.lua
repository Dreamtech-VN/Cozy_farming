--WndImpeach.lua
--@brief	WndImpeach的UI模块
--@date		2016/12/27
--@author	zsq
--@note		公会弹劾


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndImpeach:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

function WndImpeach:actionCallback(element, data)

end

function WndImpeach:onEnterTransitionDidFinish(element)
	self.m_nCount = 1
	self.m_root:enableSchedule("countDown",1)
	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndImpeach:onExit(element)
	self:_unInit()
end

function WndImpeach:onClose(element)
	WZLog("WndImpeach:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then return end
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndImpeach:onConfirm()
	WZLog("WndImpeach:onConfirm")
	if tonumber(self.voteStatus) == 0 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO150)
		return
	end
	if tonumber(self.voteStatus) == 2 then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO147)
		return
	end
	if tonumber(self.voteStatus) == 1 then
		ProtocolProcessorSceneCommunity:send_GUILD_ImpeachVote( )
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndImpeach:update()
	--self.captainName = captainName
	--self.offlineDays = offlineDays
	--self.memberNum = memberNum
	--self.agreeNum = agreeNum
	--self.voteStatus = voteStatus
	--self.impeachCountDown = impeachCountDown
	if self.m_root == nil then return end

	WZLog("WndImpeach:update",self.captainName,self.offlineDays,self.memberNum,self.agreeNum,self.voteStatus,self.impeachCountDown)
	if self.impeachCountDown > 0 then
		GetElement(self.m_root,"con1",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"con2",WZUIContainer):setVisible(true)
		self:setTime()
		
	elseif self.impeachCountDown == 0 then
		GetElement(self.m_root,"con1",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"con2",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"txt1_WndImpeach",WZUIFreeTextBox):setShowText(string.format(LocalStrings.COMMUNITYINFO148,self.captainName,tostring(self.offlineDays)))
		GetElement(self.m_root,"txt2_WndImpeach",WZUILabelTTF):setText(self.agreeNum.."/"..self.memberNum)
	end

	if tonumber(self.offlineDays) == 0 then
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

function WndImpeach:setTime()
		local s = self.impeachCountDown % 60
		if s < 10 then s = "0"..s end
		local m = math.floor(self.impeachCountDown / 60) % 60
		if m < 10 then m = "0"..m end
		local h = math.floor(self.impeachCountDown / 3600) % 60
		if h < 10 then h = "0"..h end
		GetElement(self.m_root,"txt3_WndImpeach",WZUILabelTTF):setText(h..":"..m..":"..s)
end

function WndImpeach:countDown()
	if self.impeachCountDown == nil then return end
	self.m_nCount = self.m_nCount + 1
	if self.impeachCountDown > 0 then
		self.impeachCountDown = self.impeachCountDown - 1 
		self:setTime()
	elseif self.impeachCountDown <= 0 then
		WZLog("倒计时",self.m_nCount)
		if (self.m_nCount % 10) == 0 then
			ProtocolProcessorSceneCommunity:send_GUILD_GetImpeachInfo( )
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin-------------------------------------
function WndImpeach:_adaptLanguage_en(  )
	local txt1 = GetElement(self.m_root,"txt1_WndImpeach",WZUIFreeTextBox)
	txt1:setMaxWidth(380)
end

function WndImpeach:_adaptLanguage_th(  )
	local txt1 = GetElement(self.m_root,"txt1_WndImpeach",WZUIFreeTextBox)
	txt1:setMaxWidth(300)
	local txt2 = GetElement(self.m_root,"txt2_WndImpeach",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.6,0.335))
end

function WndImpeach:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtBtn_WndImpeach",WZUIFreeTextBox):setScale(0.8)

	GetElement(self.m_root,"txt2_WndImpeach",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.674285,0.335))
	GetElement(self.m_root,"txt4_WndImpeach",WZUILabelTTF):setFontSize(20)
end

function WndImpeach:_adaptLanguage_es(  )
	GetElement(self.m_root,"txt4_WndImpeach",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtBtn_WndImpeach",WZUIFreeTextBox):setScale(0.88)
end

function WndImpeach:_adaptLanguage_vn(  )
	local txt2 = GetElement(self.m_root,"txt2_WndImpeach",WZUILabelTTF)
	txt2:setRelativePosition(GlobalMethod:ccp(0.6,0.335))
end
---------------------------------语言适配End--------------------------------------------