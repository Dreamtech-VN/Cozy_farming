--WndArcticExploration.lua
--@brief	WndArcticExploration的UI模块
--@date		2023/11/01
--@author	yrd
--@note		极地探险


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndArcticExploration:onEnter(element)
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
function WndArcticExploration:onExit(element)
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
function WndArcticExploration:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7103, 7103)

	local tData = {pool = 3}
	local strJson = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7103, 2, strJson)
end

--@brief    点击关闭窗口按钮
function WndArcticExploration:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndArcticExploration:createElement()
	WindowManager:addWindow(wnd, WndArcticExploration, false)
end

--@brief    点击关闭窗口按钮
function WndArcticExploration:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self:saveToolType()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndArcticExploration:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local otherInfo = {imgBg="ui/common/frame_tc_xiao_lan.png", imgClose = "ui/newvip/common_top_btn_guanbi_lan.png"}
 	WndFourStarRuleDesc:showInterface(LocalStrings.ARCTIC_EXPLORATION_TEXT2, nil, otherInfo)
end

--@brief    初始化静态文本
function WndArcticExploration:_initStaticText()
	self:getToolType()
	self:_showAnimal()

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[4])
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[5])
	GetElement(self.m_root,"txtOperateBtn4",WZUILabelTTF):setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[6])

	GetElement(self.m_root,"txtMapTitle",WZUILabelTTF):setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[16])
	GetElement(self.m_root,"txtMapDesc",WZUILabelTTF):setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[17])
	GetElement(self.m_root,"txtMapReward",WZUILabelTTF):setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[18])
end

--@brief 	更新许愿币的数量
function WndArcticExploration:_updateCoinNum()
	local sFormat = [[<I Z="0.4" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="163,74,20" SS="4" SE="0">%d</T>]]
	local basicData = GDatatab_item["id_" .. self.m_nCoinId]
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	GetElement(self.m_root, "ftbOwnCoin", WZUIFreeTextBox):setShowText(string.format(sFormat, basicData.icon, nNum))
end

--@brief 	初始化活动时间
function WndArcticExploration:_initActivityTime()
	local tStartDate = os.date("*t", self.m_nStartTime)
	local tEndDate = os.date("*t", self.m_nEndTime)
	local sDuration = string.format(LocalStrings.ACTIVITYTIME_FORMAT, tStartDate.month, tStartDate.day, tStartDate.hour, tStartDate.min, tEndDate.month, tEndDate.day, tEndDate.hour, tEndDate.min)
	GetElement(self.m_root, "txtActivityTime", WZUILabelTTF):setText(LocalStrings.PEOPLE_SHOP_TEXT1.. " "..sDuration)
end

--@brief 	红点
function WndArcticExploration:showRedDot()
	if self.m_root == nil then return end 

	local imgBtnRedDot1 = GetElement(self.m_root, "imgBtnRedDot1", WZUIImage)
	if GlobalGame.g_tRedPointTypeList and (GlobalGame.g_tRedPointTypeList[117103] or GlobalGame.g_tRedPointTypeList[127103]) then 
		imgBtnRedDot1:setVisible(true)
	else
		imgBtnRedDot1:setVisible(false)
	end
end

--@brief 	刷新"全民许愿"礼包的信息
function WndArcticExploration:showBagGiftInfo()
	if self.m_nGiftRewardNum > 0 then 
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		GetElement(self.m_root, "imgGiftRed", WZUIImage):setVisible(false)
	end
end

--@brief 	点击选择瓶子按钮回调
function WndArcticExploration:onClickChooseTool(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nIndex = GetElement(self.m_root, "cbgTools", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nDrawToolType == nIndex then
		return
	end

	self.m_nDrawToolType = nIndex
	self:updateDrawgBtn()
	self:_playAni(1, true)
	self:_playAnotherAni(0)
end


--@brief 	设置待机特效
function WndArcticExploration:_showAnimal()
	local spinePath = "activity/hd_pic_jdtx"
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
end

function WndArcticExploration:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndArcticExploration:downloadEffectCallback",taskId,extraData,failed)
    self:_showAnimal()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndArcticExploration:_playAni(aniIndex, bLoop)
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
function WndArcticExploration:_playAnotherAni(aniIndex, bLoop)
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
function WndArcticExploration:showOpenAction()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	local spinePath1 = "activity/hd_pic_jdtx"
	local existSpine1 = CheckEffectFile(spinePath1)
	if spineOpen then 
		if existSpine1 then
			local aniIndex = self.m_nAniType + 1 
			self:_playAnotherAni(aniIndex, false)
			spineOpen:enableSchedule("showShootBefore", 0)
		else
			self:showShootReward()
		end
	end
end

--@brief 	显示开启奖励 处理抽奖时人物人物会闪一下问题
function WndArcticExploration:showShootBefore()
	self:_playAni(0)
	local nSeconds = 2
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	spineOpen:enableSchedule("showShootReward", nSeconds)
end

--@brief 	显示开启奖励
function WndArcticExploration:showShootReward()
	local spineOpen = GetElement(self.m_root, "spineOpen", WZUISpine)
	spineOpen:disableSchedule()
	self:_playAni(1, true)
	self:_playAnotherAni(0)

	local strContent = ""
	if self.m_tOpenResult.addExp and self.m_tOpenResult.addExp > 0 then 
		strContent = strContent .. LocalStrings.ARCTIC_EXPLORATION_TEXT1[19] .. "+" .. self.m_tOpenResult.addExp .. "    "
	end
	if strContent ~= "" then 
		MsgBoxManager:showTipBox(strContent, nil, nil, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(0.5, 0.77))
	end

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	点击"自选奖励"按钮回调
function WndArcticExploration:onClickChoosePrize(element)
	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end

	self.m_bIsOpenReward = true 

	self.m_tGetTimes = {}
	self.m_tBigRewardList = {}

	local tData1 = {pool = 0}
	local tData2 = {pool = 1}
	local tData3 = {pool = 2}
	local strJson1 = json.encode(tData1)
	local strJson2 = json.encode(tData2)
	local strJson3 = json.encode(tData3)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson1)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson2)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, strJson3)
end

--@brief 	点击选择数量按钮回调
function WndArcticExploration:onClickSwitchNum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nDrawNumType = self.m_nDrawNumType % 2 + 1

	self:updateDrawgBtn()
end

--@brief 	更新许愿按钮
function WndArcticExploration:updateDrawgBtn()
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
			txtUseTool:setText(LocalStrings.ARCTIC_EXPLORATION_TEXT1[2])
		elseif self.m_nDrawNumType == 2 then
			if nTempTimes == 0 then
				txtUseTool:setText(string.format(LocalStrings.ARCTIC_EXPLORATION_TEXT1[3], self.m_tDrawNumList[self.m_nDrawNumType]))
			else
				txtUseTool:setText(string.format(LocalStrings.ARCTIC_EXPLORATION_TEXT1[3], nTimes))
			end
		end
	else
		txtUseTool:setText(string.format(LocalStrings.ARCTIC_EXPLORATION_TEXT1[3], nTimes))
	end

	local tempStrokeColor = {GlobalMethod:ccc3(163,74,20), GlobalMethod:ccc3(0,108,3)}
	txtUseTool:setStrokeColor(tempStrokeColor[self.m_nDrawNumType])

	local imgUseTool1 = GetElement(self.m_root,"imgUseTool1",WZUIImage)
	local tempImgPathList = {"ui/common/common_btn_41_2.png", "ui/common/common_btn_42_3.png"}
	imgUseTool1:setFile(tempImgPathList[self.m_nDrawNumType])
end

--@brief 	点击许愿按钮回调
function WndArcticExploration:onClickUseTool(element)
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
function WndArcticExploration:goToBuy(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndApartmentAct:showInterface()
    end
end

--@brief 	点击按钮回调
function WndArcticExploration:onClickOperateBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	if nTag == 1 then
		CellNewYearTask:showInterface(50, self.m_nActivityId)
	elseif nTag == 2 then
		WndShopRank:showInterface(69, self.m_nActivityId)
	elseif nTag == 4 then
		if self.m_nGiftRewardNum >= 1 then
			if CacheCenter:getRemainAmount() <= 0 then --背包已满提示
				MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
				return
			end
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
		else
			local tData = {}
			tData.txtTitle = string.format(LocalStrings.ARCTIC_EXPLORATION_TEXT1[10], self.m_tContent.globalConfig[1])
			tData.nType = 2
			WndTips:show(element, self.m_root, 52, tData, GlobalMethod:ccp(70,80), true)
		end
	end
end

--@brief 	显示等级经验
function WndArcticExploration:_showLvAndExp()
	local txtLevel = GetElement(self.m_root, "txtLevel", WZUILabelTTF)
	local txtLvTitle = GetElement(self.m_root, "txtLvTitle", WZUILabelTTF)
	local txtExp = GetElement(self.m_root, "txtExp", WZUILabelTTF)
	local prgExp = GetElement(self.m_root, "prgExp", WZUIProgress)

	local tCurInfo, tNextInfo, nMaxLv = self:getCurLvInfo()
	local strLvTitle = LocalStrings.MAGIC_CLASSROOM_TEXT3[1]
	local nCurLevel = 0 
	if tCurInfo then 
		nCurLevel = tCurInfo.lv
		strLvTitle = tCurInfo.name 
	end
	txtLevel:setText(LocalStrings.LV .. nCurLevel)
	txtLvTitle:setText(strLvTitle)
	if tCurInfo and tCurInfo.lv >= nMaxLv then 
		txtExp:setText("Max")
	else
		txtExp:setText(self.m_nCurExp .. "/" .. tNextInfo.exp)
	end

	local nPercentage = math.floor(100 * self.m_nCurExp/tNextInfo.exp)
	if nPercentage > 100 then 
		nPercentage = 100
	end
	prgExp:setPercentage(nPercentage)
end

--@brief 	点击领取等级奖励按钮
function WndArcticExploration:onClickLvReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "conLvReward", WZUIContainer):setVisible(true)
	self:_createLvRewardList()
end

--@brief 	关闭捕鼠奖励界面
function WndArcticExploration:onCloseTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	GetElement(self.m_root, "conLvReward", WZUIContainer):setVisible(false)
	self:showRedDot()
end

--@brief 	创建捕鼠奖励
function WndArcticExploration:_createLvRewardList()
	local tbLvRewardList = GetElement(self.m_root, "tbLvRewardList", WZUITableContainer)
	tbLvRewardList:cleanTable()
	for i = 1, #self.m_tLvRewardList do
		local element, tNewObj = CellLvRewardItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLvRewardList[i], 7)

			tbLvRewardList:setCellElement(element)
		end
	end
end

--@brief 	显示五音自选奖励
function WndArcticExploration:_showFiveKeyReward()
	local tcReward = GetElement(self.m_root, "tcMapReward", WZUITableContainer)
	tcReward:cleanTable()

	local reward_ids = self.m_tFiveKeyReward.reward_ids1
	local reward_nums = self.m_tFiveKeyReward.reward_nums1
	local tTempData = self.m_tFiveKeyReward
	for i = 1, #reward_ids do
		local tabItem = GDatatab_item["id_".. reward_ids[i]]
		local itemInfo = {id = tabItem.id, name=tabItem.name,icon=tabItem.icon,lastTime=reward_nums[i],quality=tabItem.quality,basicInfo=CopyTable(tabItem), index = i}
		local bVisibleLimit = false
		local strLimit = "" 
		if tTempData.leftConfig then 
			itemInfo.leftConfig = tTempData.leftConfig[i]
			bVisibleLimit, strLimit = WndJoinReward:getLimitData(itemInfo.leftConfig.soldNum, itemInfo.leftConfig.limitNum, itemInfo.leftConfig.dailyLimit, itemInfo.leftConfig.dailyBuyNum)
		end
		if tTempData.chooseState then 
			itemInfo.chooseState = tTempData.chooseState[i]
		end
		if tTempData.pool then 
			itemInfo.pool = tTempData.pool
		end
		local nType = 17 
		if tTempData.type then 
			nType = tTempData.type
			itemInfo.rootNode = self.m_root
		end
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			tCell:setCellGoodItem(itemInfo, nType)
			celElement:setTag(i-1)
			celElement:setScale(0.6)
			tcReward:setCellElement(celElement)
			if tTempData.chooseState then 
				tCell:setItemClickFun(self,self.onClickItem2)
			else
				tCell:setItemClickFun(self,self.onItemClick)
			end
			if bVisibleLimit then 
				tCell:_addNumLimit(strLimit)
			end
			if itemInfo.chooseState and itemInfo.chooseState == 1 then 
				tCell:setItemSelState(true)
			end
		end
	end
end

--@brief 	显示探险进度
function WndArcticExploration:showPageProgress()
	local nNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId2)
	GetElement(self.m_root,"txtMapPoint",WZUILabelTTF):setText(nNum .. "/" .. self.m_tContent.giftConfig[3])

	for i=1,self.m_tContent.giftConfig[3] do
		local imgMapZone = GetElement(self.m_root,"imgMapZone"..i,WZUIImage)
		local imgMapStar = GetElement(self.m_root,"imgMapStar"..i,WZUIImage)
		if i <= nNum then
			imgMapZone:setVisible(true)
			imgMapStar:setVisible(true)
		else
			imgMapZone:setVisible(false)
			imgMapStar:setVisible(false)
		end
	end
end

--@brief	点击物品弹出对应的tips
function WndArcticExploration:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief    点击奖励回调
function WndArcticExploration:onClickItem2(tCell, tag, tData)
    if tData.chooseState and tData.chooseState == 0 then 
		local _, _, bIsSoldOut = WndJoinReward:getLimitData(tData.leftConfig.soldNum, tData.leftConfig.limitNum, tData.leftConfig.dailyLimit, tData.leftConfig.dailyBuyNum)
	    if bIsSoldOut then
	  	   	MsgBoxManager:showTipBox(string.format(LocalStrings.PLANETSEARCH_TEXT1[18], LocalStrings.ARCTIC_EXPLORATION_TEXT1[18], tData.basicInfo.name, tData.lastTime))
	  	   	return
	  	else
	  		self.m_tClickCell = tCell 
	  		local tTempData = {}
	  		local doType = 4
			tTempData.id = tData.index - 1
			tTempData.pool = tData.pool
	  		
			local stringData = json.encode(tTempData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, doType, stringData)
	   end
    elseif tData.chooseState and tData.chooseState == 1 then 
		self.m_tClickCell = tCell 
		local tTempData = {}
		local doType = 4
		tTempData.id = tData.index - 1
		tTempData.pool = tData.pool
			
		local stringData = json.encode(tTempData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, doType, stringData)
		tCell:setItemSelState(false)
    end
end

--@brief 	选择奖励返回
function WndArcticExploration:chooseReturn(tag, index, status)
	if self.m_root == nil then return end 

	local tTempData = self.m_tFiveKeyReward
	tTempData.chooseState[index] = status
	self.m_tClickCell:updateChooseStateData(status)
	if status == 0 then 
		self.m_tClickCell:setItemSelState(false)
	elseif status == 1 then 
		self.m_tClickCell:setItemSelState(true)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndArcticExploration:_adaptIphoneX()
	if IsIphoneX() then
	end
end




-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------

function WndArcticExploration:_adaptLanguage_vn(  )
	local txtMapDesc = GetElement(self.m_root,"txtMapDesc",WZUILabelTTF)
	txtMapDesc:setScale(0.7)
	txtMapDesc:setDimensions(GlobalMethod:CCSize(360,0))
	GetElement(self.m_root,"txtUseTool1",WZUILabelTTF):setScale(0.6)

	GetElement(self.m_root,"txtOperateBtn1",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtOperateBtn2",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtOperateBtn4",WZUILabelTTF):setScale(0.7)
end

---------------------------------------语言适配End------------------------------------------
