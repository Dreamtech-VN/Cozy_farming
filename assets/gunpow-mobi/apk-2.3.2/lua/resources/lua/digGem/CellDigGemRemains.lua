--CellDigGemRemains.lua
--@brief	CellDigGemRemains的UI模块
--@date		2019/07/03
--@author	yrd
--@note		挖宝系统-遗迹之光


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDigGemRemains:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDigGemRemains:onExit(element)
	self:_unInit()
end

function CellDigGemRemains:_update()
	local txtBtnShare = GetElement(self.m_root,"txtBtnShare_CellDigGemRemains",WZUILabelTTF)
	txtBtnShare:setText(LocalStrings.SHARE)
	txtBtnShare:setLabelStyleKey("SMALL_ORANGE_BTN")
	local btnShare = GetElement(self.m_root,"btnShare_CellDigGemRemains",WZUIButton)
	btnShare:setButtonStatus(0)
	btnShare:setTouchEnable(true)

	local tDigMap = GDatatab_dig_map["id_"..self.tData.mapNum]
	local sName = tDigMap.map_name
	local imgMap = tDigMap.mini_map

	local min = math.ceil(self.tData.overTime/60)%60
	local hour = math.floor(math.ceil(self.tData.overTime/60)/60)

	GetElement(self.m_root,"txtName_CellDigGemRemains",WZUILabelTTF):setText(sName)
	GetElement(self.m_root,"imgIcon_CellDigGemRemains",WZUIImage):setFile(imgMap)

	local txtChallengeState = GetElement(self.m_root,"txtChallengeState_CellDigGemRemains",WZUILabelTTF)
	local ftbLeftCnt = GetElement(self.m_root,"ftbLeftCnt_CellDigGemRemains",WZUIFreeTextBox)
	if self.tData.mapStatus == 0 then
		ftbLeftCnt:setVisible(true)
		txtChallengeState:setVisible(false)
		ftbLeftCnt:setShowText(string.format(LocalStrings.RELIC_TEXT_4,hour,min))
	elseif self.tData.mapStatus == 1 then
		ftbLeftCnt:setVisible(false)
		txtChallengeState:setVisible(true)
		txtChallengeState:setText(LocalStrings.RELIC_TEXT_5)
	elseif self.tData.mapStatus == 2 then
		ftbLeftCnt:setVisible(false)
		txtChallengeState:setVisible(true)
		txtChallengeState:setText(LocalStrings.RELIC_TEXT_6)
	end
end

--@brief	分享按钮
function CellDigGemRemains:onShareClick(element)
	if not self.tData then return end

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.tData.mapStatus == 0 then
		local conShare = GetElement(self.m_root,"conShare_CellDigGemRemains",WZUIContainer)
		conShare:setVisible(false)
		conShare:enableSchedule("_updateCountDownShare",10)

		local mapid = tostring(self.tData.mapId)
		local bubbleId = WndChat:getPlayerBubble()
		local shareType = 0
		ProtocolProcessorDigGem:send_MINING_ShareMap(mapid, bubbleId, shareType)
	else
		MsgBoxManager:showTipBox(LocalStrings.RELIC_TEXT_16)
	end
end

function CellDigGemRemains:_updateCountDownShare(element)
	element:setVisible(false)
	element:disableSchedule()
end

--@brief	世界分享
function CellDigGemRemains:onShareWorld(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conShare_CellDigGemRemains",WZUIContainer):setVisible(false)

	local mapid = tostring(self.tData.mapId)
	local bubbleId = WndChat:getPlayerBubble()
	local shareType = 1
	ProtocolProcessorDigGem:send_MINING_ShareMap(mapid, bubbleId, shareType)

end

--@brief	公会分享
function CellDigGemRemains:onShareGuild(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"conShare_CellDigGemRemains",WZUIContainer):setVisible(false)


	if checkInCommunity() ==false then
		MsgBoxManager:showTipBox(LocalStrings.TXT_NOSOCISY_FREND)
		return 
	end
	local mapid = tostring(self.tData.mapId)
	local bubbleId = WndChat:getPlayerBubble()
	local shareType = 2
	ProtocolProcessorDigGem:send_MINING_ShareMap(mapid, bubbleId, shareType)

end

--@brief	查看按钮
function CellDigGemRemains:onChallenge(element)
	if not self.tData then return end

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WndRemainsInfo:showInterface(self.tData.mapId)
end

function CellDigGemRemains:showShareCD(time)
	if time > 0 then
		local txtBtnShare = GetElement(self.m_root,"txtBtnShare_CellDigGemRemains",WZUILabelTTF)
		txtBtnShare:setText(LocalStrings.SHARE)
		txtBtnShare:setLabelStyleKey("SMALL_GRAY_BTN")
		txtBtnShare:setText(time)
		local btnShare = GetElement(self.m_root,"btnShare_CellDigGemRemains",WZUIButton)
		btnShare:setButtonStatus(2)
		btnShare:setTouchEnable(false)
	elseif time <= 0 then 
		local txtBtnShare = GetElement(self.m_root,"txtBtnShare_CellDigGemRemains",WZUILabelTTF)
		txtBtnShare:setText(LocalStrings.SHARE)
		txtBtnShare:setLabelStyleKey("SMALL_ORANGE_BTN")
		local btnShare = GetElement(self.m_root,"btnShare_CellDigGemRemains",WZUIButton)
		btnShare:setButtonStatus(0)
		btnShare:setTouchEnable(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配begin----------------------------------------
function CellDigGemRemains:_adaptLanguage_vn()
	GetElement(self.m_root,"txtName_CellDigGemRemains",WZUILabelTTF):setScale(0.69)
end
-------------------------------------语言适配end----------------------------------------
