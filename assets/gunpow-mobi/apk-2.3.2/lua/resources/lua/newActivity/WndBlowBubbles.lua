--WndBlowBubbles.lua
--@brief	WndBlowBubbles的UI模块
--@date		2023/12/29
--@author	yrd
--@note		吹泡泡活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBlowBubbles:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_initStaticText()
	self:_updateCoinNum()

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBlowBubbles:onExit(element)
	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndBlowBubbles:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7107, 7107)
end

--@brief    点击关闭窗口按钮
function WndBlowBubbles:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndBlowBubbles:createElement()
	WindowManager:addWindow(wnd, WndBlowBubbles, false)
end

--@brief    点击关闭窗口按钮
function WndBlowBubbles:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndBlowBubbles:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local otherInfo = {imgBg="ui/common/frame_tc_xiao_lan.png", imgClose = "ui/newvip/common_top_btn_guanbi_lan.png"}
 	WndFourStarRuleDesc:showInterface(LocalStrings.BLOW_BUBBLES_TEXT2, nil, otherInfo)
end

--@brief    初始化静态文本
function WndBlowBubbles:_initStaticText()
	self:getToolType()
	self:_showAnimal()

	GetElement(self.m_root,"txtChoosePrize",WZUILabelTTF):setText(LocalStrings.WATERMELON_TEXT1[22])

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.BLOW_BUBBLES_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.BLOW_BUBBLES_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setText(LocalStrings.BLOW_BUBBLES_TEXT1[6])
	GetElement(self.m_root,"txtOperateBtn4",WZUILabelTTF):setText(LocalStrings.BLOW_BUBBLES_TEXT1[7])
end

--@brief 	更新许愿币的数量
function WndBlowBubbles:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndBlowBubbles:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT1.. " "..sDuration)
end

--@brief 	红点
function WndBlowBubbles:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot2 = GetElement(self.m_root, "imgBtnRedDot2", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[217107] or GlobalGame.g_tRedPointTypeList[227107] or GlobalGame.g_tRedPointTypeList[237107]) then 
		imgBtnRedDot2:setVisible(true)
	else
		imgBtnRedDot2:setVisible(false)
	end

	if self.m_tLoginGiftData and self.m_tLoginGiftData.status == 0 then 
		GetElement(self.m_root, "imgBtnRedDot4", WZUIImage):setVisible(true)
	else
		GetElement(self.m_root, "imgBtnRedDot4", WZUIImage):setVisible(false)
	end
end

--@brief 	更新界面
function WndBlowBubbles:updateUI()

end

--@brief 	点击选择瓶子按钮回调
function WndBlowBubbles:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateWishingBtn()
	self:_playAni(1, true)
	self:_playAnotherAni(0)
end

--@brief 	点击选择数量按钮回调
function WndBlowBubbles:onClickSwitchNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nDrawNumType = self.m_nDrawNumType % 2 + 1

	self:updateWishingBtn()
end

--@brief 	更新许愿按钮
function WndBlowBubbles:updateWishingBtn()
	local txtUseTool = GetElement(self.m_root,"txtUseTool1",WZUILabelTTF)

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
	local freeCount = 0 --免费次数
	if self.m_nDrawToolType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	local nTimes = self.m_tDrawNumList[self.m_nDrawNumType]
	local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
	if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[self.m_nDrawNumType] then
		nTimes = nAllTimes
	end
	if freeCount == 1 then
		if self.m_nDrawNumType == 1 then
			txtUseTool:setText(LocalStrings.BLOW_BUBBLES_TEXT1[2])
		elseif self.m_nDrawNumType == 2 then
			if nTempTimes == 0 then
				txtUseTool:setText(string.format(LocalStrings.BLOW_BUBBLES_TEXT1[3], self.m_tDrawNumList[self.m_nDrawNumType]))
			else
				txtUseTool:setText(string.format(LocalStrings.BLOW_BUBBLES_TEXT1[3], nTimes))
			end
		end
	else
		txtUseTool:setText(string.format(LocalStrings.BLOW_BUBBLES_TEXT1[3], nTimes))
	end

	local tempStrokeColorList = {GlobalMethod:ccc3(163,74,20), GlobalMethod:ccc3(0,108,3)}
	txtUseTool:setStrokeColor(tempStrokeColorList[self.m_nDrawNumType])

	local imgUseTool1 = GetElement(self.m_root,"imgUseTool1",WZUIImage)
	local tempImgPathList = {"ui/newvip/common_btn_41_1.png", "ui/newvip/common_btn_42_1.png"}
	imgUseTool1:setFile(tempImgPathList[self.m_nDrawNumType])
end


--@brief 	设置待机特效
function WndBlowBubbles:_showAnimal()
	local spinePath = "activity/hd_pic_chuipaop"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait", true)
		end

		local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
		if spineOpen then
			spineOpen:setFileJson(spinePath .. ".json") 
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_playAni(1, true)
		end
		local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
		if spineCopy then
			spineCopy:setFileJson(spinePath .. ".json") 
			spineCopy:setFileAtlas(spinePath .. ".atlas")
			self:_playAnotherAni(0)
		end
	end

	local spinePath = "activity/hd_pic_chuipaop02"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then
		local spineBG = GetElement(self.m_root, "spineBG2", WZUISpine)
		if spineBG then 
			spineBG:setFileJson(spinePath .. ".json")
			spineBG:setFileAtlas(spinePath .. ".atlas")
			spineBG:play("wait", true)
		end
	end
end

function WndBlowBubbles:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndBlowBubbles:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBlowBubbles:_playAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineOpen:setVisible(false)
		return
	end
	spineOpen:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineOpen then 
		spineOpen:play(self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndBlowBubbles:_playAnotherAni(aniIndex, bLoop)
	local spineCopy = GetElement(self.m_root, "spineCopy", WZUISpine)
	aniIndex = aniIndex or 0
	if aniIndex == 0 then
		spineCopy:setVisible(false)
		return
	end
	spineCopy:setVisible(true)
	bLoop = bLoop == true and true or false

	if spineCopy then 
		spineCopy:play(self.m_tClipAniName[self.m_nDrawToolType + 1][aniIndex], bLoop)
	end
end

--@brief 	显示开启动画
function WndBlowBubbles:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_chuipaop"
	local existSpine1 = CheckEffectFile(spinePath1)
	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAnotherAni(aniIndex, false)
			-- local nSeconds = 2
			-- spineOpen:enableSchedule("showShootReward", nSeconds)
			spineOpen:enableSchedule("showShootBefore", 0)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndBlowBubbles:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndBlowBubbles:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.BLOW_BUBBLES_TEXT1[11] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end



--@brief 	点击"自选奖励"按钮回调
function WndBlowBubbles:onClickChoosePrize(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}
	self.m_bIsOpenReward = true 

	local tData = {pool = 0}
	local tData2 = {pool = 1}
	local tData3 = {pool = 2}
	local strJson = json.encode(tData)
	local strJson2 = json.encode(tData2)
	local strJson3 = json.encode(tData3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
end

--@brief 	点击许愿按钮回调
function WndBlowBubbles:onClickUseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
	if CacheCenter:getRemainAmount() <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end
	if self.m_bOpenState then return end 

	if self.m_nChooseReward == 0 then 
		self:onClickChoosePrize(0)

		self.m_nChooseReward = 1
		self:saveOperateTimes()
		return 
	end

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	local nTempTimes = math.floor(nArrowNum/self.m_tCostByType[self.m_nDrawToolType + 1]) --可许愿次数
	local freeCount = 0 --免费次数
	if self.m_nDrawToolType == 0 then 
		freeCount = self.m_nCount > 0 and 1 or 0 
	end
	self.m_nAniType = self.m_nDrawNumType
	local nTimes = self.m_tDrawNumList[self.m_nDrawNumType]
	local nAllTimes = nTempTimes + freeCount --可许愿次数 + 免费次数
	if nAllTimes > 0 and nAllTimes < self.m_tDrawNumList[self.m_nDrawNumType] then
		nTimes = nAllTimes
	end

	local nCostNum = nTimes * self.m_tCostByType[self.m_nDrawToolType + 1]
	if nCostNum - freeCount > nArrowNum or self.m_nAniType == 2 and nArrowNum == 0 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.WATERCOUNTRY_TEXT4, basicData.name), self, self.goToBuy)
		return 
	end

	self:setOpenState(true)

	local tData = {}
	tData.times = self.m_tDrawNumList[self.m_nDrawNumType]
	tData.pool = self.m_nDrawToolType
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, stringData)
end

--@brief 	前往小推车购买
function WndBlowBubbles:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndBlowBubbles:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		WndDollMachineShop:showInterface(18, self.m_nActivityId)
	elseif nTag == 2 then
		CellNewYearTask:showInterface(54, self.m_nActivityId)
	elseif nTag == 3 then
		WndShopRank:showInterface(75, self.m_nActivityId)
	elseif nTag == 4 then
		if self.m_tLoginGiftData.status == 0 then 
			--背包已满提示
		    if CacheCenter:getRemainAmount() <= 0 then
		        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		        return
		    end

		    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 8, "")
		else
			local tData = self.m_tLoginGiftData
			local data = {}

	        data.scale = 0.4
	        data.title = LocalStrings.SUMMERSURF_TEXT1[21]
	    	data.titleFontSize = 18
	        data.rewardIds = tData.ids
	        data.rewardNums = tData.nums
	        local conLeftMenu = GetElement(self.m_root, "conLeftMenu_WndSummerSurf", WZUIContainer)
	        WndNewTipsReward:showInterface(self.m_root, element, data, true, GlobalMethod:ccp(0.7, 0.5))
		end
	end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndBlowBubbles:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root,"btnOperate1",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.075,0.499))
		GetElement(self.m_root,"cbgTools",WZUICheckBoxGroup):setRelativePosition(GlobalMethod:ccp(0.07,0.219))
		GetElement(self.m_root,"btnOperate4",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.822,0.098))
		GetElement(self.m_root,"conOperate",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.917,0.27))
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndBlowBubbles:_adaptLanguage_vn()
	local txtUseTool = GetElement(self.m_root,"txtUseTool1",WZUILabelTTF)
	txtUseTool:setScale(0.6)
	txtUseTool:setDimensions(GlobalMethod:CCSize(220,0))
	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setScale(0.5)
	GetElement(self.m_root,"txtOperateBtn3",WZUILabelTTF):setScale(0.8)
end

-------------------------------------语言适配模块End----------------------------------------

