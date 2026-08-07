--WndFourStarLabrary.lua
--@brief	WndFourStarLabrary的UI模块
--@date		2021/02/24
--@author	hyx
--@note		图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFourStarLabrary:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFourStarLabrary:onExit(element)
	if self.m_sLightUpSpine then
		self.m_sLightUpSpine:removeFromParentAndCleanup(true)
		self.m_sLightUpSpine = nil
	end
	if self.m_sLightUpResultSpine then
		self.m_sLightUpResultSpine:removeFromParentAndCleanup(true)
		self.m_sLightUpResultSpine = nil
	end
	self:_unInit()
	self:unregister()
end

function WndFourStarLabrary:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetLibraryInfo,self)
end
function WndFourStarLabrary:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetLibraryInfo,self)
end
function WndFourStarLabrary:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFourStarLabrary:actionCallback()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7008, 4, "")
	self:initShow()
end

function WndFourStarLabrary:showInterface()
	local wndLibrary = WndFourStarLabrary:createElement()
	if wndLibrary ~= nil then
	    WindowManager:addWindow(wndLibrary,WndFourStarLabrary,nil,false)
	end
end

function WndFourStarLabrary:initShow()
	for i=1,4 do
		local tab = {}
		local chipReward = GetElement(self.m_root,"chipReward"..i,WZUIContainer)
		tab.chipProgress = GetElement(chipReward,"chipProgress"..i,WZUIContainer)
		tab.txtChipNum = GetElement(chipReward,"txtChipNum"..i,WZUILabelTTF)
		tab.btnChip = GetElement(chipReward,"btnChip"..i,WZUIButton)
		self.m_tChipContainer[i] = tab
	end
	self:setRewardRedPoint(WndFourStar.m_sTaskRedPoint)
end
function WndFourStarLabrary:setRewardRedPoint(visible)
	if self.m_root == nil then return end 
	
	local imgRewardRedPoint = GetElement(self.m_root,"imgRewardRedPoint",WZUIImage)
	if imgRewardRedPoint then
		imgRewardRedPoint:setVisible(visible)
	end
end
--点亮类型0青龙|1白虎|2朱雀|3玄武
function WndFourStarLabrary:onBtnLightUp(element)
	local tag = element:getTag()
	self.m_nLightUpIndex = tonumber(tag)
	if not self.m_sLightUpSpine then
		local name = {"ui_common_DL1","ui_common_DL2","ui_common_DL3","ui_common_DL4"}
		local data = {
			path = "ui/otherUI/ui_common_DL4",
			play = name[self.m_nLightUpIndex+1]
		}
		self.m_sLightUpSpine = createEffectSpine(self.m_tChipContainer[self.m_nLightUpIndex+1].chipProgress,data)
		if self.m_sLightUpSpine then 
			self.m_sLightUpSpine:setLuaSpineEventFunc("setLightUpStart")
		else
			self:setLightUpStart(nil, "end", nil)
		end
	end
end
function WndFourStarLabrary:setLightUpStart(animation, name, eventName)
	if name == "end" then
		local tab = {}
		tab.pieceType = self.m_nLightUpIndex
		tab = json.encode(tab)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7008, 5, tab)
		if self.m_sLightUpSpine then
			self.m_sLightUpSpine:removeFromParentAndCleanup(true)
			self.m_sLightUpSpine = nil
		end
	end
end
--奖励
function WndFourStarLabrary:onBtnReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarLabraryReward:showInterface()
end

function WndFourStarLabrary:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFourStarLabrary:_onGetLibraryInfo(activityId, doType, result, msg)
	msg = json.decode(msg)
	if msg then
		self:setChipLightData(msg)
		if doType == 4 then
			for i=1,4 do
				if self.m_tChipContainer[i] then
					if self.m_tChipMaskItem[i] == nil then
						self.m_tChipMaskItem[i] = {}
					end
					for num=1,self.m_tChipData[i].pieceTarget do
						local mask = WZUIImage:create()
						mask:setUseOriginSize(true)
						mask:setUseAbsCoordinate(true)
						mask:setAnchorPoint(GlobalMethod:ccp(0,1))
						mask:setFile("ui/activity/frame_71.png")
						local _x = 5 + ((num-1)%9)*20
						local _y = 248 - (math.floor((num-1)/9)*20)
						mask:setAbsPosition(GlobalMethod:ccp(_x,_y))
						self.m_tChipContainer[i].chipProgress:addChild(mask)
						if self.m_tChipLightPos[i] and self.m_tChipLightPos[i][num] then
							mask:setVisible(false)
						end
						self.m_tChipMaskItem[i][num] = mask
					end	
				end
			end
		elseif doType == 5 then
			local index = msg.pieceType+1
			self.m_nLightResultIndex = index
			if not self.m_sLightUpResultSpine then
				local data = {
					path = "ui/otherUI/ui_common_DL",
					play = "ui_common_DL",
					ccp = GlobalMethod:ccp(0.5,0.44)
				}
				self.m_sLightUpResultSpine = createEffectSpine(self.m_tChipContainer[index].chipProgress,data)
				if self.m_sLightUpResultSpine then 
					self.m_sLightUpResultSpine:setLuaSpineEventFunc("setLightUpResult")
				else
					self:setLightUpResult(nil, "end", nil)
				end
			end
		end
	end
end

function WndFourStarLabrary:setChipLightData(data)
	self:setChipData( data )
	--处理红点
	local status = false
	WndFourStar.m_sCollectRedPoint = false
	for i,v in pairs(self.m_tChipData) do
		if v.pieceCount > 0 and getnTableCount(self.m_tChipLightPos[i]) < self.m_tChipData[i].pieceTarget then
			status = true
			WndFourStar.m_sCollectRedPoint = true
			break
		end
	end
	WndFourStar:setImgLibraryRedPoint(status)
	for i=1,4 do
		if self.m_tChipContainer[i] then
			self.m_tChipContainer[i].txtChipNum:setText(self.m_tChipData[i].pieceCount)
			if self.m_tChipData[i].pieceCount <= 0 then
				self.m_tChipContainer[i].btnChip:setTouchEnable(false)
			end
		end
		--如果存在全部开完的时候还有碎片就不让点击按钮
		if (getnTableCount(self.m_tChipLightPos[i]) >= self.m_tChipData[i].pieceTarget and self.m_tChipData[i].pieceCount > 0) or 
			(self.m_tChipData[i].precesNum >= self.m_tChipData[i].pieceTarget) then
			self.m_tChipContainer[i].btnChip:setVisible(false)
		else
			self.m_tChipContainer[i].btnChip:setVisible(true)
		end
	end
end

function WndFourStarLabrary:setLightUpResult(animation, name, eventName)
	if name == "end" then
		if self.m_tChipMaskItem[self.m_nLightResultIndex] then
			for i, item in pairs(self.m_tChipMaskItem[self.m_nLightResultIndex]) do
				if item and self.m_tChipLightPos[self.m_nLightResultIndex] and self.m_tChipLightPos[self.m_nLightResultIndex][i] then
					item:setVisible(false)
				end
			end
		end
		if self.m_sLightUpResultSpine then
			self.m_sLightUpResultSpine:removeFromParentAndCleanup(true)
			self.m_sLightUpResultSpine = nil
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndFourStarLabrary:_adaptLanguage_vn()
	GetElement(self.m_root,"txtChipNum1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.21))
	GetElement(self.m_root,"txtChipNum2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.21))
	GetElement(self.m_root,"txtChipNum3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.21))
	GetElement(self.m_root,"txtChipNum4",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.21))
end
-------------------------------------语言适配End----------------------------------------
