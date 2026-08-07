--WndPelletChip.lua
--@brief	WndPelletChip的UI模块
--@date		2021/09/13
--@author	hyx
--@note		回忆录
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPelletChip:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPelletChip:onExit(element)
	self:_unInit()
	self:unregister()
end
function WndPelletChip:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetChipResult,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.setGiftRedPoint, self)
end
function WndPelletChip:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetChipResult,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.setGiftRedPoint, self)
end
function WndPelletChip:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPelletChip:actionCallback()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7028, 3, "")
	WndPelletChip:setGiftRedPoint()
end
function WndPelletChip:showInterface()
	local wndChip = WndPelletChip:createElement()
	if wndChip ~= nil then
	    WindowManager:addWindow(wndChip,WndPelletChip,nil,nil)
	end
end
function WndPelletChip:onBtnLeft()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCurLibraryIndex = self.m_nCurLibraryIndex - 1
	self:setChangeLibrary()
end
function WndPelletChip:onBtnRight()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCurLibraryIndex = self.m_nCurLibraryIndex + 1
	self:setChangeLibrary()
end
function WndPelletChip:setChangeLibrary()
	if self.m_nCurLibraryIndex <= 0 then return end
	if self.m_nCurLibraryIndex > self.m_nCurMaxIndex then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT168)
		self.m_nCurLibraryIndex = self.m_nCurLibraryIndex - 1
		return
	end
	
	local btnLeft = GetElement(self.m_root,"btnLeft",WZUIButton)
	btnLeft:setVisible(true)
	local btnRight = GetElement(self.m_root,"btnRight",WZUIButton)
	btnRight:setVisible(true)

	if self.m_nCurLibraryIndex <= 1 then
		btnLeft:setVisible(false)
	end
	if self.m_nCurLibraryIndex >= 4 then
		btnRight:setVisible(false)
	end

	local pic_name = {"ui/common_bg/hd_pic_tndz_hy01.png","ui/common_bg/hd_pic_tndz_hy02.png","ui/common_bg/hd_pic_tndz_hy03.png","ui/common_bg/hd_pic_tndz_hy04.png"}
	local imgLibrary = GetElement(self.m_root,"imgLibrary",WZUIImage)
	imgLibrary:setFile(pic_name[self.m_nCurLibraryIndex])

	local btnLight = GetElement(self.m_root,"btnLight",WZUIButton)
	btnLight:setVisible(true)
	if GetTableLen(self.m_tLightChipData[self.m_nCurLibraryIndex]) >= self.m_tNeedMemPiecesNums[self.m_nCurLibraryIndex] then
		btnLight:setTouchEnable(false)
	else
		btnLight:setTouchEnable(true)
	end

	local temp_index = self.m_nCurLibraryIndex
	if self.m_nNextCurIndex then
		GetElement(self.m_root,"comChipLibrary"..self.m_nNextCurIndex,WZUIContainer):setVisible(false)
	end
	local comChipLibrary = GetElement(self.m_root,"comChipLibrary"..temp_index,WZUIContainer)
	comChipLibrary:setVisible(true)
	
	local img_chip = {"ui/activityWords/frame_suip_03.png","ui/activityWords/frame_suip_02.png","ui/activityWords/frame_suip_01.png","ui/activityWords/frame_suip_01.png"}
	local chip_hw = {{72,168},{72,67},{45,48},{45,48}} --宽高
	local start_xy = {{37,252},{37,302},{24,311},{24,311}} --起始坐标
	local max_index = {10,10,16,16} --一排最大数量
	if self.m_tChipItem[temp_index] == nil then
		self.m_tChipItem[temp_index] = {}
		doStopAllActions(comChipLibrary)
		for i=1,self.m_tNeedMemPiecesNums[temp_index] do
			if self.m_tLightChipData[temp_index][i] == nil then
				local icon = WZUIImage:create()
				icon:setUseOriginSize(true)
		        icon:setUseAbsCoordinate(true)
		        icon:setFile(img_chip[temp_index])
		        comChipLibrary:addChild(icon)
		        local _x = start_xy[temp_index][1] + ((i-1)%max_index[temp_index]) * chip_hw[temp_index][1]
		        local _y = start_xy[temp_index][2] - math.floor((i-1)/max_index[temp_index]) * chip_hw[temp_index][2]
		        icon:setAbsPosition(ccp(_x, _y))
		        self.m_tChipItem[temp_index][i] = icon
		    end
		end
	end
	self.m_nNextCurIndex = temp_index
end
--点亮碎片
function WndPelletChip:onBtnLight()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nChipNumbers <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.FRAGMENT_NOT_ENOUGH)
		return
	end
	local tab = {}
	tab.photoId = self.m_nCurLibraryIndex
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7028, 4, tab)
end
function WndPelletChip:onBtnGift()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tGiftReward then
		WndPelletGift:showInterface(self.m_tGiftReward, self.m_tLightData, self.m_tPhotoIdData)
	end
end
--领取礼物的状态
function WndPelletChip:setRewardGiftState(index)
	self.m_tLightData[index] = 2 --已经领取的
end
--领取红点
function WndPelletChip:setGiftRedPoint()
	if not self.m_root then return end
	visible = GlobalGame.g_tRedPointTypeList[27028]
	GetElement(self.m_root,"imgGiftRedPoint",WZUIImage):setVisible(visible)
	WndPelletMain:setRecallRedPoint()
end
function WndPelletChip:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPelletChip:_onGetChipResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7028) then
		msg = json.decode(msg)
		if doType == 3 then
			self.m_nChipNumbers = msg.havePiecesNum
			GetElement(self.m_root,"txtChipNum",WZUILabelTTF):setText(msg.havePiecesNum)
			self.m_tGiftReward = msg.rewards
			self.m_tLightData = msg.lightens
			self.m_tPhotoIdData = msg.oldPhotoIds
			self.m_tNeedMemPiecesNums = msg.needMemPiecesNums
			self:setChipData(msg.oldPhotoIds, msg.slotsInfos)
			local temp_index = nil
			for i=1,#self.m_tLightChipData do
				if GetTableLen(self.m_tLightChipData[i]) < self.m_tNeedMemPiecesNums[i] then
					self.m_nCurLibraryIndex = i
					temp_index = true
					break
				end
			end
			if temp_index then
				self.m_nCurMaxIndex = self.m_nCurLibraryIndex
			else
				self.m_nCurMaxIndex = 4
			end
			self:setChangeLibrary()
		elseif doType == 4 then
			if result == 1 then
				self.m_nChipNumbers = msg.havePiecesNum
				if self.m_nChipNumbers <= 0 then
					GlobalGame.g_tRedPointTypeList[37028] = false
					WndPelletMain:setRecallRedPoint()
					local red_point = GlobalGame.g_tRedPointTypeList[127028] or GlobalGame.g_tRedPointTypeList[27028] or GlobalGame.g_tRedPointTypeList[37028]
					SceneCity:setSceneMainIconRedPoint(FISH_ACTIVITY, red_point)
				end
				GetElement(self.m_root,"txtChipNum",WZUILabelTTF):setText(msg.havePiecesNum)
				for i,v in pairs(msg.lightSlots) do
					self.m_tLightChipData[msg.photoId][v] = 1
					if self.m_tChipItem[msg.photoId][v] then
						self.m_tChipItem[msg.photoId][v]:setVisible(false)
					end
				end
				if msg.isLighten == 1 then
					self.m_nCurMaxIndex = self.m_nCurMaxIndex + 1
					GetElement(self.m_root,"btnLight",WZUIButton):setTouchEnable(false)
					for i=1, #self.m_tLightData do
						if msg.photoId and i == msg.photoId then
							self.m_tLightData[i] = 1
							break
						end
					end
				end
			else
				MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT162[result])
			end
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
