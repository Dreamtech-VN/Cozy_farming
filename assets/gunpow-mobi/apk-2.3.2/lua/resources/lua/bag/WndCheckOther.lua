--WndCheckOther.lua
--@brief	WndCheckOther的UI模块
--@date		2015/07/06
--@author	zsq
--@note		查看其它玩家信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCheckOther:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorWndBag:regAll()
	ProtocolProcessorRecycling:regAll()
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	if WZFileUtil:isFileExist("pack/footmark/pack_footmark_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/footmark/pack_footmark_0.plist")
    end
    if WZFileUtil:isFileExist("pack/footmark/pack_footmark_1.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/footmark/pack_footmark_1.plist")
    end

	-- if CacheCenter:getGameParam().gameStatus == "1" then
	-- 	local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
	-- 	checkBoxMate:setVisible(false)
	-- 	local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
	-- 	checkBoxKid:setVisible(false)
	-- end

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCheckOther:onExit(element)
	if self.m_root then 
		local conInfo = GetElement(self.m_root, "conInfo_WndCheckOther", WZUIContainer)
		conInfo:disableSchedule()

		local conMessage = GetElement(self.m_root, "conMessage_WndCheckOther", WZUIContainer)
		conMessage:disableSchedule()
	end
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
	ProtocolProcessorWndBag:unregAll()
	if WZFileUtil:isFileExist("pack/footmark/pack_footmark_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/footmark/pack_footmark_0.plist")
    end
    if WZFileUtil:isFileExist("pack/footmark/pack_footmark_1.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/footmark/pack_footmark_1.plist")
    end
end

--@brief	加载动画
function WndCheckOther:onEnterTransitionDidFinish(element)
	WZLog("WndCheckOther:onEnterTransitionDidFinish",self.m_nPlayerId)
	self:resetLeftPosition()
	local conInfo = GetElement(self.m_root, "conInfo_WndCheckOther", WZUIContainer)
	conInfo:enableSchedule("downloadFile",0.1)

	self:_addTop()
	ProtocolProcessorWndSpace:send_SPACE_GetSpaceInfo(self.m_nPlayerId)  
	ProtocolProcessorWndSpace:send_SPACE_GetPhotoList(WndCheckOther.m_nPlayerId)

	self:_initStaticText()
	local conAllContent = GetElement(self.m_root, "conAllContent_WndCheckOther", WZUIContainer)
	if CacheCenter:getPlayerInfo() == nil then return end
	--查看自己从缓存取数据,查看别人发协议
	local tOtherBtnList = {}

	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		self.m_bIsHost = true
		self.m_topCellLua.goldCellInfo.cell:setVisible(false)

		local bAddBtn = addWeChatBtn(conInfo,8,GlobalMethod:ccp(0.219,0.08),1.12, true)
		if bAddBtn then 
			table.insert(tOtherBtnList, "btnShare_WndCheckOther")
		end

		self.m_tPlayerInfo = CacheCenter:getPlayerInfo()
		self.m_tPlayerInfo.item = CacheCenter:getPlayerItems()
		self.m_tPlayerInfo.segmentId = CacheCenter:getPlayerInfo().segmentLevel
		local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
		self.m_tPlayerInfo.headColor = headColor
		self.m_tPlayerInfo.bodyColor = bodyColor

		self:_updateFire()
		self:_showPet()
		self:_showKids()
		self:setDianZanNum()
		GetElement(self.m_root,"btnBlacklist_WndCheckOther", WZUIButton):setVisible(false)
		--右侧信息列表
		if type(CacheCenter:getPlayerInfo().allMountsMessage) == "table" then
			self.m_tMount = CopyTable(CacheCenter:getPlayerInfo().allMountsMessage)
		else
			self.m_tMount = {}
		end
		if type(CacheCenter:getPlayerInfo().footMark) == "table" then
			self.m_tFootMark = CopyTable(CacheCenter:getPlayerInfo().footMark)
		else
			self.m_tFootMark = {}
		end
		if type(CacheCenter:getPlayerInfo().shape) == "table" then
			self.m_tSkin = CopyTable(CacheCenter:getPlayerInfo().shape)
		else
			self.m_tSkin = {}
		end
		self:updateInfo()
		self:_setCheckBoxState()
		self.m_tPlayerInfo.infoBarItemId = CacheCenter:getPlayerInfoRectEffectItemId()
		self.m_tPlayerInfo.headEffectId = CacheCenter:getPlayerHeadEffectItemId()
		self.m_tPlayerInfo.medalInfo = CacheCenter:getActivityMedalData()
	else
		self.m_bIsHost = false
		self.m_topCellLua.goldCellInfo.cell:setVisible(false)

		GetElement(self.m_root,"btnBlacklist_WndCheckOther", WZUIButton):setVisible(true)
		local txtBlacklist = GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF)
		txtBlacklist:setText(LocalStrings.BLACKLIST_TEXT8)
		BANCHAT = CacheCenter:getFriendBlacklist()
		for i = 1, #BANCHAT do
			if BANCHAT[i].id == self.m_nPlayerId then
				txtBlacklist:setText(LocalStrings.BLACKLIST_TEXT7)
				break 
			end
		end
		--从服务器获得玩家信息
		ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_nPlayerId)
	end

	--查看自己不显示加好友，私信，发邮件按钮
	local bIsAddBtn6 = false 
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		GetElement(self.m_root,"Btn1_WndCheckOther",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnVisitor_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"Btn2_WndCheckOther",WZUIButton):setVisible(false)
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or 
			ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
			GetElement(self.m_root,"Btn6_WndCheckOther",WZUIButton):setVisible(false)
			bIsAddBtn6 = true 
		end

		GetElement(self.m_root,"btnAddGift_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnFoot_WndCheckOther",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnFlower_WndCheckOther",WZUIButton):setVisible(false)
		GetElement(self.m_root,"ttf1_WndCheckOther", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
	else
		GetElement(self.m_root,"btnVisitor_WndCheckOther",WZUIButton):setVisible(false)
		GetElement(self.m_root,"Btn1_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"Btn2_WndCheckOther",WZUIButton):setVisible(true)
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or 
			ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
			GetElement(self.m_root,"Btn6_WndCheckOther",WZUIButton):setVisible(false)
			bIsAddBtn6 = false 
		end

		GetElement(self.m_root,"btnAddGift_WndCheckOther",WZUIButton):setVisible(false)
		GetElement(self.m_root,"btnFoot_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnFlower_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"ttf2_WndCheckOther", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
		GetElement(self.m_root,"ttf3_WndCheckOther", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
	end

	--苹果审核屏蔽兑换码按钮
	if CacheCenter:getGameParam().gameStatus == "1" then
		GetElement(self.m_root,"Btn6_WndCheckOther",WZUIButton):setVisible(false)
		bIsAddBtn6 = false 
	end	
	if bIsAddBtn6 then 
		table.insert(tOtherBtnList, "Btn6_WndCheckOther")
	end

	--是否显示英雄俱乐部按钮
	local bIsAddBtn5 = false 
	GetElement(self.m_root,"Btn5_WndCheckOther",WZUIButton):setVisible(false)
	--local curSdkObj = PassportSdkManager:getCurSdkObj()
    --if self.m_nPlayerId == CacheCenter:getPlayerInfo().id and curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needBloc == "true" then
	
	if IsNewHeroControl() then
		if self.m_nPlayerId == CacheCenter:getPlayerInfo().id and g_bloc_club == "true" and CheckButtonShow(104) then
			GetElement(self.m_root,"Btn5_WndCheckOther",WZUIButton):setVisible(false)
			bIsAddBtn5 = true
		end
	else
		if self.m_nPlayerId == CacheCenter:getPlayerInfo().id and CheckButtonShow(104) then
			GetElement(self.m_root,"Btn5_WndCheckOther",WZUIButton):setVisible(false)
			bIsAddBtn5 = true
		end
	end
	
	--战斗中不显示英雄俱乐部按钮
	if SceneBattle.m_root ~= nil or SceneBattleLoading.m_root ~= nil then 
		bIsAddBtn5 = false 
		GetElement(self.m_root,"Btn5_WndCheckOther",WZUIButton):setVisible(false)
	end
	if bIsAddBtn5 then 
		table.insert(tOtherBtnList, "Btn5_WndCheckOther")
	end

	if GetTableLen(tOtherBtnList) == 1 then 
		if tOtherBtnList[1] == "btnShare_WndCheckOther" then 
			addWeChatBtn(conInfo,8,GlobalMethod:ccp(0.219,0.08),1)
		else
			GetElement(self.m_root, tOtherBtnList[1], WZUIButton):setVisible(true)
		end
	elseif GetTableLen(tOtherBtnList) > 1 then 
		local conOtherBtn = GetElement(self.m_root, "conOtherBtn_WndCheckOther", WZUIContainer)
		GetElement(self.m_root,"btnOther_WndCheckOther",WZUIButton):setVisible(true)
		for i = 1, #tOtherBtnList do
			if tOtherBtnList[i] == "btnShare_WndCheckOther" then
				local conForShare = GetElement(self.m_root, "conForShare_WndCheckOther", WZUIContainer)
				conForShare:setVisible(true)
				addWeChatBtn(conForShare, 8, GlobalMethod:ccp(0.5,0.5),1, nil, true)
			elseif tOtherBtnList[i] == "Btn5_WndCheckOther" then
				GetElement(self.m_root, "Btn5_2_WndCheckOther", WZUIButton):setVisible(true)
			elseif tOtherBtnList[i] == "Btn6_WndCheckOther" then
				GetElement(self.m_root, "Btn6_2_WndCheckOther", WZUIButton):setVisible(true)
			end
		end
	end

	--显示设置背景按钮
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		GetElement(self.m_root,"Btn7_WndCheckOther",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"Btn7_WndCheckOther",WZUIButton):setVisible(false)
	end

	self:_adaptIphoneX()
end

--@brief	开始点击
function WndCheckOther:onTouchBegan(element,pt)
	WZLog("WndCheckOther:onTouchBegan")
	if self.m_root == nil then return end 
	
	local conForBg = GetElement(self.m_root, "conForBg_WndCHeckOther", WZUIContainer)
	if not WndItemInfo.m_root then
		if conForBg and conForBg:isVisible() and not self:checkPointInBtn(pt) then
			conForBg:setVisible(false)
		end
	end

	if WndItemInfo.m_root and not WndItemInfo:checkPoint(pt) then
		WndItemInfo:_onCloseClick()
	end

	local bFlag = WndPopupMenu:ifPointInMenu(pt)
	if bFlag == false then 
		WndPopupMenu:disappear()
	end 

	local conOtherBtn = GetElement(self.m_root, "conOtherBtn_WndCheckOther", WZUIContainer)
	if conOtherBtn:isVisible() and not self:checkPointInOtherBtn(pt) then 
		conOtherBtn:setVisible(false)
	end
end

--@brief	外部调用显示接口
function WndCheckOther:show(id)
	WZLog("WndCheckOther:show",id)
	if id and self.m_root and self.m_tPlayerInfo and id == self.m_tPlayerInfo.id then return end 

	if id == nil then id = CacheCenter:getPlayerInfo().id end
	--if self.m_root == nil thenı
		self.m_nPlayerId = id
		WZLog("WndCheckOther:show1",self.m_nPlayerId)
		local wnd = WndCheckOther:createElement()
		WindowManager:addWindow(wnd, WndCheckOther, false, nil, nil, true)
	--end
end

--@brief	关闭按钮点击回调
function WndCheckOther:onClose(element)
    WZLog("WndCheckOther:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_nShowBgId and self.m_nShowBgId > 0 and self.m_nShowBgId ~= 830 then 
		local nNum = CacheCenter:getPlayerItemCountById(self.m_nShowBgId)
		if nNum <= 0 then
			local tCustomUIConfig = {MSGBOXUICFG_CANCEL=LocalStrings.CANCEL} 
			local basicData = GDatatab_item["id_" .. self.m_nShowBgId]
			if basicData.property[1][1] == -1 then 
				if CacheCenter:getPlayerInfo().vipLevel < basicData.property[1][2] then 
					local sContent = string.format(LocalStrings.BACKGROUND_VIP_TEXT1, basicData.property[1][2])
					MsgBoxManager:showConfirmBox(sContent, self, self.needHigherVipCallBack, nil, tCustomUIConfig, nil, nil, nil, self.cancelToBuy)
					return
				end
			elseif basicData.property[1][1] == 0 then 
				if not whetherHaveWelfareCard() then 
					MsgBoxManager:showConfirmBox(LocalStrings.BACKGROUND_VIP_TEXT2, self, self.gotoBuyWelfareCard, nil, tCustomUIConfig, nil, nil, nil, self.cancelToBuy)
					return
				end
			elseif basicData.property[1][1] == -2 then 
				local vipMedal	
				if self.m_tPlayerInfo.vipMedal and self.m_tPlayerInfo.vipMedal ~= "" then
					vipMedal = json.decode(self.m_tPlayerInfo.vipMedal)
				end
				if vipMedal and vipMedal.level < basicData.property[1][2] then 
					local sContent = string.format(LocalStrings.BACKGROUND_MEDAL1, basicData.property[1][2])
					MsgBoxManager:showConfirmBox(sContent, self, self.needHigherMedalLvCallBack, nil, tCustomUIConfig, nil, nil, nil, self.cancelToBuy)
					return 
				end
			elseif basicData.property[1][1] == -3 then 
				if basicData.property[1][2] == 1 then 
					tCustomUIConfig = {MSGBOXUICFG_CONFIRM = LocalStrings.OBTAIN, MSGBOXUICFG_CANCEL=LocalStrings.CANCEL} 
					local sContent = string.format(LocalStrings.BACKGROUND_MEDAL3, LocalStrings.BACKGROUND_MEDAL4[basicData.property[1][2]])
					MsgBoxManager:showConfirmBox(sContent, self, self.jumpToUI, nil, tCustomUIConfig, nil, nil, nil, self.cancelToBuy)
					return
				end
			else
				local costData = GDatatab_item["id_" .. basicData.property[1][1]]
				local sContent = string.format(LocalStrings.CHECKOTHER_TEXT1, self:getBgCardPrice(basicData.id), costData.name)
				MsgBoxManager:showConfirmBox(sContent, self, self.sureToBuy, nil, tCustomUIConfig, nil, nil, nil, self.cancelToBuy)
				return 
			end
		end
	end

	self:cancelToBuy()
end

--@brief 	取消购买
function WndCheckOther:cancelToBuy()
	-- body
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	确定购买试穿背景
function WndCheckOther:sureToBuy()
	-- body
	local tData = {}
	tData.basicInfo = GDatatab_item["id_" .. self.m_nShowBgId]
	self:tryWear(2, tData)
end

--@brief 	前往购买福利卡
function WndCheckOther:gotoBuyWelfareCard(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief 	点击设置背景按钮回调
function WndCheckOther:onClickSetBg(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndBattleHud.m_root then 
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_TEXT10)
		return 
	end
	if SceneRoom.m_root and not SceneRoom.m_bCanClickSeat then
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_TEXT9)
		return 
	end
	local conForBg = GetElement(self.m_root, "conForBg_WndCHeckOther", WZUIContainer)
	if not conForBg:isVisible() then
		conForBg:setVisible(true)
		self:_switchTabCallBack()
	end
end
--点击是信誉积分的显示
function WndCheckOther:onBtnClickHonor()
	if self.m_bIsHost == true then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		WndHonorCheckShow:showInterface()
	end
end

--@brief 	点击展示翅膀按钮回调
function WndCheckOther:onClickWing(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nOperateType = 1

	local checkBoxWing = GetElement(self.m_root, "checkBoxWing_WndCheckOther", WZUICheckBox)
	local nIndex = checkBoxWing:getCheckIndex()
	local showMes = CacheCenter:getPlayerInfo().showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	tBits[1] = nIndex
	showMes = BitsToNumber(tBits)
	WZLog("WndCheckOther:onClickWing", showMes)
	ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, CacheCenter:getPlayerInfo().background)
end

--@brief 	点击展示伴侣按钮回调
function WndCheckOther:onClickMate(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
	if self.m_tPlayerInfo.mateName == nil or self.m_tPlayerInfo.mateName == "" then
		checkBoxMate:setCheckIndex(0)
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_TEXT2)
		return 
	end
	self.m_nOperateType = 2

	local nIndex = checkBoxMate:getCheckIndex()
	WZLog("WndCheckOther:onClickMate", nIndex)
	local showMes = CacheCenter:getPlayerInfo().showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	tBits[2] = nIndex
	showMes = BitsToNumber(tBits)
	WZLog("WndCheckOther:onClickMate", showMes)
	ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, CacheCenter:getPlayerInfo().background)
end

--@brief 	点击展示宠物按钮回调
function WndCheckOther:onClickShowPet(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not CheckButtonOpen(27, false) then
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_TEXT8)
		return 
	end
	self.m_nOperateType = 3

	local checkBoxPet = GetElement(self.m_root, "checkBoxPet_WndCheckOther", WZUICheckBox)
	local nIndex = checkBoxPet:getCheckIndex()
	WZLog("WndCheckOther:onClickShowPet", nIndex)
	local showMes = CacheCenter:getPlayerInfo().showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	tBits[3] = nIndex
	showMes = BitsToNumber(tBits)
	WZLog("WndCheckOther:onClickShowPet", showMes)
	ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, CacheCenter:getPlayerInfo().background)
end

--@brief 	点击展示孩子按钮回调
function WndCheckOther:onClickShowKid(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndCheckOther:onClickShowKid", self.m_tPlayerInfo.childMes)
	local kidMes = self.m_tPlayerInfo.childMes
	if kidMes == nil or kidMes == "[]" then
		GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox):setCheckIndex(0)
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
		return 
	end
	self.m_nOperateType = 4

	local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
	local nIndex = checkBoxKid:getCheckIndex()
	WZLog("WndCheckOther:onClickShowKid", nIndex)
	local showMes = CacheCenter:getPlayerInfo().showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	tBits[4] = nIndex
	showMes = BitsToNumber(tBits)
	ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, CacheCenter:getPlayerInfo().background)
end

--@brief 	点击展示坐骑按钮回调
function WndCheckOther:onClickShowMount(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not CheckButtonOpen(28, false) then
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_TEXT8)
		return 
	end
	self.m_nOperateType = 5

	local checkBoxMount = GetElement(self.m_root, "checkBoxMount_WndCheckOther", WZUICheckBox)
	local nIndex = checkBoxMount:getCheckIndex()
	local showMes = CacheCenter:getPlayerInfo().showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	tBits[5] = nIndex
	showMes = BitsToNumber(tBits)
	WZLog("WndCheckOther:onClickShowMount", showMes)
	ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, CacheCenter:getPlayerInfo().background)
end

--@brief 	点击展示皮肤按钮回调
function WndCheckOther:onClickShowSkin(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not CheckButtonOpen(118, false) then
		MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_TEXT8)
		return 
	end
	self.m_nOperateType = 6

	local checkBoxSkin = GetElement(self.m_root, "checkBoxSkin_WndCheckOther", WZUICheckBox)
	local nIndex = checkBoxSkin:getCheckIndex()
	local showMes = CacheCenter:getPlayerInfo().showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	tBits[6] = nIndex
	showMes = BitsToNumber(tBits)
	WZLog("WndCheckOther:onClickShowSkin", showMes)
	ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, CacheCenter:getPlayerInfo().background)
end


--@brief 	点击伴侣形象回调
function WndCheckOther:onCheckMateInfo(element)
	-- body
	local showMes = self.m_tPlayerInfo.showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	WZLog("WndCheckOther:onCheckMateInfo", tBits[2])
	if tBits[2] == 0 then return end 

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tIdList = SplitStringWithSeparator(self.m_tPlayerInfo.coupleMes, "|", nil, true)
	WZLog("WndCheckOther:onCheckMateInfo 1111", type(tIdList[7]), tIdList[7])
	if tIdList and tIdList[7] then
		WndCheckOther:show(tonumber(tIdList[7]))
	end
end


--@brief 	点击留言板按钮回调
function WndCheckOther:onClickMsg(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CheckButtonOpen(62) then 
		if SceneBattle.m_root then 
			MsgBoxManager:showTipBox(LocalStrings.CHECKOTHER_TEXT10)
			return 
		end
		
		WndSpaceMessage:showInterface()
	end
end

--@brief 	点击最近访客按钮回调
function WndCheckOther:onClickVisitor(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

--	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceRecord:createElement()
	WindowManager:addWindow(wnd, WndSpaceRecord, true, nil, nil, true)
	WndSpaceRecord:setType3()
end


--@brief	访客踩一踩
function WndCheckOther:onLeft1(element)
	WZLog("WndCheckOther:onLeft1")
--	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndSpace:send_SPACE_JoinPlayer(self.m_nPlayerId)
end

--@brief	访客送鲜花
function WndCheckOther:onLeft2(element)
	WZLog("WndCheckOther:onLeft2")
--	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceSendFlower:createElement()
	WindowManager:addWindow(wnd, WndSpaceSendFlower, false, nil, nil, true)
end

--@brief	放置礼物
function WndCheckOther:onBtn1(element)
--	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	if self.m_bIsHost ~= true then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpacePutGift:createElement()
	WindowManager:addWindow(wnd, WndSpacePutGift, true, nil, nil, true)
end

--@brief	人气记录
function WndCheckOther:onBtn2(element)
--	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceRecord:createElement()
	WindowManager:addWindow(wnd, WndSpaceRecord, true, nil, nil, true)
	WndSpaceRecord:setType1()
end

--@brief	魅力
function WndCheckOther:onBtn3(element)
--	if WndSpaceDetail and WndSpaceDetail.m_bPlaying == true then WndSpaceDetail:resumeBgMusic() WndSpaceDetail.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wnd = WndSpaceRecord:createElement()
	WindowManager:addWindow(wnd, WndSpaceRecord, true, nil, nil, true)
	WndSpaceRecord:setType2()
end

--@brief 	点击其他按钮回调
function WndCheckOther:onClickOther(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local conOtherBtn = GetElement(self.m_root, "conOtherBtn_WndCheckOther", WZUIContainer)
	local bVisible = conOtherBtn:isVisible()
	conOtherBtn:setVisible(not bVisible)
end

--@brief 	点击踩一踩羁绊按钮回调
function WndCheckOther:onFootTitle(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndTips:show(element, WndCheckOther.m_root, 58, self.m_tFootTitleData, GlobalMethod:ccp(230,-150), true)
end
--@brief 	点击鲜花羁绊回调
function WndCheckOther:onFlowerTitle(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndTips:show(element, WndCheckOther.m_root, 58, self.m_tFlowerTitleData, GlobalMethod:ccp(230,-150), true)
end

--@brief 	点击好友关系回调
function WndCheckOther:onFriendTitle(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndTips:show(element, WndCheckOther.m_root, 58, self.m_tFriendsTitleData, GlobalMethod:ccp(230,-150), true)
end

--@brief 	外观界面点击标签回调
function WndCheckOther:onClickTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if self.m_nTabIndex == nTag then return end 

	self.m_nTabIndex = nTag
	self:_switchTabCallBack()
end

--@brief 	复选框切换是否显示留言回调
function WndCheckOther:onClickShowMessage(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	self.m_nOperateType = 7

	local checkBoxMes = GetElement(self.m_root, "checkBoxMes_WndCheckOther", WZUICheckBox)
	local nIndex = checkBoxMes:getCheckIndex()
	local showMes = CacheCenter:getPlayerInfo().showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	tBits[7] = nIndex == 1 and 0 or 1
	showMes = BitsToNumber(tBits)
	WZLog("WndCheckOther:onClickShowMessage", showMes)
	ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, CacheCenter:getPlayerInfo().background)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示人物形象
function WndCheckOther:showPlayer(tEquip1)
	if self.m_tPlayerInfo == nil then return end
	if self.m_tPlayerInfo.item == nil then return end 
	if self.m_root == nil then return end
	if self.conPlayer ~= nil then 
		self.conPlayer:getAnimNode():removeFromParentAndCleanup(true) 
		self.conPlayer = nil
	end

	if self.conMatePlayer ~= nil then 
		self.conMatePlayer:getAnimNode():removeFromParentAndCleanup(true) 
		self.conMatePlayer = nil
	end

	local showMes = self.m_tPlayerInfo.showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)

	local tEquip = {}
	for k,v in pairs(tEquip1) do
		if v.isUse == true then
			if v.maintype == 5 and v.subtype == 3 then
				if tBits[1] == 1 then
					table.insert(tEquip, v)
				end
			else
				table.insert(tEquip, v)
			end
		end
	end
	local sex = self.m_tPlayerInfo.sex
    local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conPlayerAni_WndCheckOther"))
    GetElement(self.m_root, "btnBoy_WndCheckOther", WZUIButton):setTouchEnable(false)
    GetElement(self.m_root, "btnGirl_WndCheckOther", WZUIButton):setTouchEnable(false)
    if tBits[2] == 1 and self.m_tPlayerInfo.mateName and self.m_tPlayerInfo.mateName ~= "" then
    	if sex == 0 then
    		conP = WZUIContainer:luaTo(self.m_root:getChildElement("conForBoy_WndCheckOther"))
    	else
    		conP = WZUIContainer:luaTo(self.m_root:getChildElement("conForGirl_WndCheckOther"))
    	end
    	conP:setVisible(true)
    end
    if not self.conPlayer then
		local conPlayer
		if self.m_tPlayerInfo.shapeId ~= 0 and tBits[6] == 1 then
			if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
				--if WndPhantom.show == 1 then
        		conPlayer = CreatePlayerFigure(sex, nil, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,true,self.m_tPlayerInfo.shapeId)
			else
        		conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,true,self.m_tPlayerInfo.shapeId)
			end
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.6,0.01))
        	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
		elseif self.m_tPlayerInfo.mountsId ~= nil and tBits[5] == 1 then
			-- if tBits[2] == 0 then
			-- 	conPlayer = CreatePlayerFigure(sex, tEquip, "wait", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,false)
			-- 	conPlayer:setMount(self.m_tPlayerInfo.mountsId)
			-- 	conPlayer:setScale(0.78)
			-- 	conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.03))
			-- else
			-- 	conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,false)
			-- 	conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.6,0.01))
			-- 	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
			-- end

			conPlayer = CreatePlayerFigure(sex, tEquip, "wait", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,false)
			conPlayer:setMount(self.m_tPlayerInfo.mountsId)
			conPlayer:setScale(0.78)
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.01))
			conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
		else
        	conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,false)
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.6,0.01))
			--conPlayer:setScale(0.95)
		end
        self.conPlayer = conPlayer
        if sex == 1 and tBits[2] == 1 and self.m_tPlayerInfo.mateName and self.m_tPlayerInfo.mateName ~= "" then
        	self.conPlayer:setFlipX(true)
        end
        conP:addChild(conPlayer:getAnimNode(),5)
        if self.m_nPlayerId and self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
	        self:showRoleFootEffect(conP, conPlayer)
	    end
    end

    if not self.conMatePlayer and tBits[2] == 1 and self.m_tPlayerInfo.mateName and self.m_tPlayerInfo.mateName ~= "" then
    	local mateSex = 0
    	local conMateP = WZUIContainer:luaTo(self.m_root:getChildElement("conForBoy_WndCheckOther"))
    	if sex == 0 then
    		mateSex = 1
    		conMateP = WZUIContainer:luaTo(self.m_root:getChildElement("conForGirl_WndCheckOther"))
    	end
    	WZLog("sexsexsexsex", mateSex)
    	if mateSex == 0 then
    		GetElement(self.m_root, "btnBoy_WndCheckOther", WZUIButton):setTouchEnable(true)
    	else
    		GetElement(self.m_root, "btnGirl_WndCheckOther", WZUIButton):setTouchEnable(true)
    	end
    	conMateP:setVisible(true)
    	local tIdList = SplitStringWithSeparator(self.m_tPlayerInfo.coupleMes, "|", nil, true)
    	local tEquip = {}
        table.insert(tEquip,tIdList[2])
        table.insert(tEquip,tIdList[1])
        table.insert(tEquip,tIdList[4])
        if tBits[1] == 1 then
        	table.insert(tEquip,tIdList[6])
        else
        	table.insert(tEquip,0)
        end
        WZLog("伴侣的bodyId", tIdList[4], tIdList[3], tIdList[5])
    	local conMatePlayer = CreatePlayerFigure(mateSex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, tIdList[3], tIdList[5])
    	conMatePlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
    	conMatePlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
    	if mateSex == 1 then
    		conMatePlayer:setFlipX(true)
    	end
    	self.conMatePlayer = conMatePlayer
        conMateP:addChild(conMatePlayer:getAnimNode(),5)
    end
end

--@brief 显示足迹
function WndCheckOther:showRoleFootEffect(conP, conPlayer)
	local footId = CacheCenter:getUsingFootMarkId()
    if footId == nil then return end
    if not self.m_rolePlayer then
	    self.m_rolePlayer = FootEffectManager:addEffect1(conP, footId, conPlayer:getPosition(),true,50,nil,nil,-150)
	end
end

--@brief   更新人物标题信息栏和战斗力信息栏
function WndCheckOther:_updateFire()
	WZLog("WndCheckOther:_updateFire")
	if self.m_root == nil or self.m_tPlayerInfo == nil then return end
	--设置vip等级
	GetElement(self.m_root,"labelVip_WndCheckOther",WZUILabelAtlasFont):setText(self.m_tPlayerInfo.vipLevel)
	if tonumber(self.m_tPlayerInfo.vipLevel) >= 10 then
		GetElement(self.m_root,"imgVip_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.33,0.28))
		GetElement(self.m_root,"labelVip_WndCheckOther",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.535385,0.27))
	else
		GetElement(self.m_root,"imgVip_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.421538,0.28))
		GetElement(self.m_root,"labelVip_WndCheckOther",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.626923,0.27))
	end
	local imgVipIcon = GetElement(self.m_root, "imgVipIcon_WndCheckOther", WZUIImage)
	setVipIconByVipLevel(imgVipIcon, tonumber(self.m_tPlayerInfo.vipLevel))
	local btnChangeName = GetElement(self.m_root,"btnChangeName_WndCheckOther",WZUIButton)
	local btnBlacklist = GetElement(self.m_root,"btnBlacklist_WndCheckOther",WZUIButton)
	--设置经验条
	local txtRemarkName = GetElement(self.m_root, "txtRemarkName_WndCheckOther", WZUILabelTTF)
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		txtRemarkName:setVisible(false)
		GetElement(self.m_root,"conExp",WZUIContainer):setVisible(true)
		local exp = self.m_tPlayerInfo.exp
		local maxExp = self.m_tPlayerInfo.maxExp
		if self.m_tPlayerInfo.level ~= nil and GDatatab_player_upgrade["id_"..self.m_tPlayerInfo.level] ~= nil then
			maxExp = GDatatab_player_upgrade["id_"..self.m_tPlayerInfo.level].exp
		end
		local maxExpFormat = GetCurExpStr(maxExp)
		local curExpStr = GetCurExpStr(exp)
		local txt = curExpStr .."/".. maxExpFormat
		local percent = tonumber(exp)*100/tonumber(maxExp)
		GetElement(self.m_root,"expPer_WndCheckOther",WZUILabelTTF):setText(txt)
		GetElement(self.m_root,"progrExpProgress_WndCheckOther",WZUIProgress):setPercentage(percent)
		--改名笔
		btnChangeName:setVisible(true)
		--战斗中不显示改名笔
		if SceneLeagueMain.m_root ~= nil or SceneBattle.m_root ~= nil or SceneBattleLoading.m_root ~= nil then 
			btnChangeName:setVisible(false)
		end
	else
		txtRemarkName:setVisible(true)
		txtRemarkName:setText("")
		if self.m_tPlayerInfo.remarkName and self.m_tPlayerInfo.remarkName ~= "" then 
			txtRemarkName:setText(self.m_tPlayerInfo.remarkName)
		end
		GetElement(self.m_root,"conExp",WZUIContainer):setVisible(false)
		--改名笔
		btnChangeName:setVisible(false)
		if self.m_tPlayerInfo.isFriend then 
			btnChangeName:setVisible(true)
			GetElement(self.m_root, "imgPen_WndCheckOther", WZUIImage):setFile("shopitems/magic_ym.png")
		else
			btnBlacklist:setRelativePosition(GlobalMethod:ccp(0.93, 0.6))
		end
	end

	--设置战斗力
    local txtFight = GetElement(self.m_root,"txtFight_WndCheckOther",WZUILabelTTF)
    CCNodePropertySetter:setValue(txtFight, "skewX", 10)
	local labelFire = GetElement(self.m_root,"fight_WndCheckOther",WZUIFreeTextBox)
	local fight_power = [[<A IMG = "ui/common_num/common_num_zhandouli.png" Z ="1" W = "16" H = "26" CHAR = "0">%d</A>]]
	labelFire:setShowText(string.format(fight_power,  self.m_tPlayerInfo.fighting))

	--信誉值
	local curHonorPoint = GetElement(self.m_root,"curHonorPoint_WndCheckOther",WZUILabelTTF)
	if self.m_tPlayerInfo.honourPoint then
		curHonorPoint:setText(":"..self.m_tPlayerInfo.honourPoint)
	end
	--设置等级名字经验进度条
	local name = GetElement(self.m_root,"name_WndCheckOther",WZUILabelTTF)
	name:setText(self.m_tPlayerInfo.name)
	local conLevelInfo = GetElement(self.m_root, "conLevelInfo", WZUIContainer)
	local txtTitle = GetElement(self.m_root,"title_WndCheckOther",WZUILabelTTF)
	local sTitleContent = self.m_tPlayerInfo.title
	if self.m_tPlayerInfo.title == nil or self.m_tPlayerInfo.title == "" then
		sTitleContent = LocalStrings.SHOP_NOCHENGHAO 
	end

	local tempPoint = GlobalMethod:ccp(0.5,1.5)
	CreateDesiSpine(conLevelInfo, txtTitle, sTitleContent, tempPoint, true)
	--设置等级
	GetElement(self.m_root,"lv_WndCheckOther",WZUILabelTTF):setText(LocalStrings.LV..self.m_tPlayerInfo.level)
    --qq大厅蓝钻年费图标
    SetQQHallBlueIcon(self.m_root, self.m_tPlayerInfo.qqHallData, {"imgQQBlue_WndCheckOther", "imgQQYear_WndCheckOther"}, {"name_WndCheckOther", "btnChangeName_WndCheckOther", "btnBlacklist_WndCheckOther"}, {WZUILabelTTF, WZUIButton, WZUIButton}, 0.09)
end

--@brief	宠物
function WndCheckOther:_showPet()
	--WZLog("WndCheckOther:_showPet",self.m_tPlayerInfo.petMessage)
	if self.m_root == nil then return end
	if self.m_tPlayerInfo == nil then return end
    local conPet = GetElement(self.m_root, "conPet1_WndCheckOther", WZUIContainer)
	if conPet:getChildByTag(1) then
		conPet:removeChildByTag(1,true)
		self.conPlayerPet = nil 
	end


	local showMes = self.m_tPlayerInfo.showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	self:setPetPosition(tBits)
	if tBits[3] == 0 then return end 

	local con = WZUIContainer:create()
	conPet:addChild(con)
	con:setTag(1)

	local petMessage = self.m_tPlayerInfo.petMessage
	if petMessage ~= nil and petMessage ~= "" then
		petMessage = json.decode(petMessage)
		local ani, ani1 = CreatePetAni(con, nil, petMessage.animation, petMessage.advancedLevel, petMessage.petSkinItemId)
		ani:getAnimNode():setTouchEnable(false)
        ani:getAnimNode():setScale(0.8)
		if ani1 ~= nil then
        	ani1:setScale(0.8)
		end

		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "hk" then
			ani:getAnimNode():setScale(0.4)
			if ani1 ~= nil then
	        	ani1:setScale(0.4)
			end
		end 

		self.conPlayerPet = ani
		if tBits[2] == 1 and self.m_tPlayerInfo.sex == 1 and self.m_tPlayerInfo.mateName and self.m_tPlayerInfo.mateName ~= "" then
			self.conPlayerPet:setFlipX(true)
		end
	end
end

--@brief 	根据显示的设置宠物的位置
function WndCheckOther:setPetPosition(tBits)
	-- body
	local conPet = GetElement(self.m_root, "conPet1_WndCheckOther", WZUIContainer)
	local btnOwnPet = GetElement(self.m_root, "btnOwnPet_WndCheckOther", WZUIButton)
	WZLog("WndCheckOther:setPetPosition", tBits[2])
	if tBits[2] == 1 and self.m_tPlayerInfo.mateName and self.m_tPlayerInfo.mateName ~= "" then
		if self.m_tPlayerInfo.sex == 0 then
--			btnOwnPet:setRelativePosition(GlobalMethod:ccp(0.03,0.588923))
			conPet:setRelativePosition(GlobalMethod:ccp(-0.27,0.45))
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "hk" then
				conPet:setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
			end 
		else
--			btnOwnPet:setRelativePosition(GlobalMethod:ccp(0.39,0.588923))
			conPet:setRelativePosition(GlobalMethod:ccp(0.92,0.5))
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "hk" then
				conPet:setRelativePosition(GlobalMethod:ccp(0.92,0.5))
			end 
		end
		if self.conPlayerPet and self.m_tPlayerInfo.sex == 1 then
			self.conPlayerPet:setFlipX(true)
		end
	else
		if self.conPlayerPet then
			self.conPlayerPet:setFlipX(false)
		end
--		btnOwnPet:setRelativePosition(GlobalMethod:ccp(0.112,0.588923))
		conPet:setRelativePosition(GlobalMethod:ccp(0,0.45))
	end
end

--@brief	刷新消息
function WndCheckOther:updateInfo()
	if self.m_tPlayerInfo == nil then return end
	if self.m_tSpaceDynamicData == nil then return end 
	if self.m_bIsLoadCell == true then return end 
	if self.m_tMount == nil or self.m_tFootMark == nil or self.m_tSkin == nil then return end 
	if self.m_tPlayerInfo.item == nil then return end 
	if not self.m_bGetInfoData and self.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then return end 

	self:showPlayer(self.m_tPlayerInfo.item)

	self.m_bIsLoadCell = true
	self.m_nStartIndex = -3

	local freeListContainer = GetElement(self.m_root,"freeCon_WndCheckOther",WZUIFreeListContainer)
	freeListContainer:removeAll()

	self.m_root:enableSchedule("_addCell",0)


	if self.m_tPlayerInfo.isFriend == false then
    	GetElement(self.m_root, "ttfBtn1_WndCheckOther", WZUILabelTTF):setText(LocalStrings.BAGBTNTEXT3)
    	GetElement(self.m_root, "Btn1_WndCheckOther", WZUIButton):setVisible(true)
	else
    	GetElement(self.m_root, "ttfBtn1_WndCheckOther", WZUILabelTTF):setText(LocalStrings.BAGBTNTEXT5)
    	GetElement(self.m_root, "Btn1_WndCheckOther", WZUIButton):setVisible(true)
	end
	if self.m_tPlayerInfo.chum == 1 then
    	GetElement(self.m_root, "Btn4_WndCheckOther", WZUIButton):setVisible(true)
	elseif self.m_tPlayerInfo.chum == 0 then
    	GetElement(self.m_root, "Btn4_WndCheckOther", WZUIButton):setVisible(false)
	end
	--查看自己不显示加好友，私信，发邮件按钮
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
    	GetElement(self.m_root, "Btn1_WndCheckOther", WZUIButton):setVisible(false)
	end
	--更新背景
	self:_setNewBg(self.m_tPlayerInfo.background)
	--显示职业图标
	if self.m_tPlayerInfo.professionId and self.m_tPlayerInfo.professionId > 0 and self.m_tPlayerInfo.professionAttr2 == "{}" then 
		GetElement(self.m_root, "imgProfessionIcon_WndCheckOther", WZUIImage):setFile(g_professionIcon[self.m_tPlayerInfo.professionId])
	elseif self.m_tPlayerInfo.professionId and self.m_tPlayerInfo.professionId > 0 and self.m_tPlayerInfo.professionAttr2 ~= "{}" then
		GetElement(self.m_root, "imgProfessionIcon_WndCheckOther", WZUIImage):setFile(g_professionIcon2[self.m_tPlayerInfo.professionId])
	end
end

--@brief	每帧加载cell
function WndCheckOther:_addCell()
	if self.m_tPlayerInfo == nil then return end
	if self.m_tSpaceDynamicData == nil then return end
	if not self.m_bIsHost and self.m_nHavePhotoNum == nil then return end 

	local freeListContainer = GetElement(self.m_root,"freeCon_WndCheckOther",WZUIFreeListContainer)
	if freeListContainer == nil then return end
	
	local EndIndex = 999999 --一个随便大数,给self.m_nStartIndex赋值用于停止计时器

	if self.m_nStartIndex == -3 then
		--个人空间
		local celElement,tCell = CellCheckOther3:createElement()
		if celElement ~= nil and tCell ~= nil then 
			self.m_tSpaceCell = tCell
			celElement = WZUIContainer:luaTo(celElement)
			freeListContainer:pushBack(celElement)
		end 
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == -2 then --展开栏
		local element = CellCheckOtherOpen:createElement()
		element = WZUIContainer:luaTo(element)
		freeListContainer:pushBack(element)

		local bExpand = true
		if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
			local data = WZDataFile:getInstance():getUserData()
			if data then
				local expandStatus = data:getStringValue("PlayerSpace", "expand")
				if expandStatus == "0" then
					bExpand = false
				end
			end
		else
			bExpand = self.m_bOtherPlayerExpand
		end
		if bExpand == false then
			self.m_nStartIndex = EndIndex
		else
			self.m_nStartIndex = self.m_nStartIndex + 1
		end
	elseif self.m_nStartIndex == -1 then  --心情
		WZLog("WndCheckOther:_addCell", CheckButtonOpen(165, false))
		if not self.m_bIsHost or CheckButtonOpen(165, false) then 
			WZLog("WndCheckOther:_addCell 000", type(self.m_tSpaceDynamicData), type(self.m_tSpaceDynamicData.message))
			if self.m_tSpaceDynamicData and self.m_tSpaceDynamicData.message and self.m_tSpaceDynamicData.message ~= "" then 
				local element = WndSpaceDynamic:createElement()
				element = WZUIContainer:luaTo(element)
				freeListContainer:pushBack(element)
				WndSpaceDynamic:setData(self.m_tSpaceDynamicData)
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 0 then  --照片
		--照片墙
		if self.m_bIsHost or self.m_nHavePhotoNum > 12 then 
			local element = WndSpacePhotoThree:createElement()
			element = WZUIContainer:luaTo(element)
			freeListContainer:pushBack(element)
		elseif self.m_nHavePhotoNum > 6 and self.m_nHavePhotoNum <= 12 then 
			local element = WndSpacePhoto:createElement()
			element = WZUIContainer:luaTo(element)
			freeListContainer:pushBack(element)
		else
			if self.m_nHavePhotoNum > 0 and self.m_nHavePhotoNum <= 6 then 
				local element = WndSpacePhotoOne:createElement()
				element = WZUIContainer:luaTo(element)
				local tPhotoUrl = {}
				local tPhotoStatue = {}
				for i = 1, 6 do
					table.insert(tPhotoUrl, self.m_tSpacePhotoData[i].photoUrl)
					table.insert(tPhotoStatue, self.m_tSpacePhotoData[i].photoStatus)
				end
				freeListContainer:pushBack(element)
				WndSpacePhotoOne:setData(tPhotoUrl, tPhotoStatue)
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 2 then
		--徽章 
		local tIconType = {}
		if CheckButtonShow(5) then  	--竞技
			table.insert(tIconType, 0)
		end
		if CheckButtonShow(23) then
			table.insert(tIconType, 2)  --排位
		end
		if CheckButtonShow(23) then 	--排位印记
			table.insert(tIconType, 3)
		end
		if CheckButtonOpen(98, false) and self.m_tPlayerInfo.ylJsonInfo then  	--娱乐赛
			table.insert(tIconType, 1)
		end
		if CheckButtonOpen(31, false) then --成就
			table.insert(tIconType, 12)
		end
		if CheckButtonOpen(229, false) then --战略赛2v2和3v3
			table.insert(tIconType, 21)
			table.insert(tIconType, 22)
		end
		local tCardData = json.decode(WndCheckOther.m_tPlayerInfo.cardMessage)
		if CheckButtonShow(76) and CheckButtonOpen(76,1) and tCardData.level > 0 then --卡牌图标
			table.insert(tIconType, 10)
		end
		local tPrayData = json.decode(WndCheckOther.m_tPlayerInfo.prayInfo)
		if CheckButtonOpen(ISLAND_UP_BLESS,1) and tPrayData.level then --祈福图标
			local nTotalLevel = 0 
			for i, value in pairs(tPrayData.level) do
				nTotalLevel = nTotalLevel + value
			end
			if nTotalLevel > 0 then 
				table.insert(tIconType, 16)
			end
		end
		local level = WndCheckOther.m_tPlayerInfo.totemLevel
		if tonumber(level) > 0 then 	--公会图标
			table.insert(tIconType, 4)
		end
		if CheckButtonShow(8) then 		--恩爱图标
		--	if CacheCenter:getGameParam().gameStatus ~= "1" then
				table.insert(tIconType, 5)
		--	end
		end
		if CheckButtonShow(30) then 	--师德图标
			table.insert(tIconType, 6)
		end
		local kidMes = WndCheckOther.m_tPlayerInfo.childMes --孩子
		if CheckButtonOpen(145, false) and kidMes and kidMes ~= "" and kidMes ~= "[]" then
			table.insert(tIconType, 11)
		end
		if CheckButtonShow(131) then 	--家园图标
			table.insert(tIconType, 9)
		end
		local shapeId = WndCheckOther.m_tPlayerInfo.shapeId
		if shapeId ~= nil and shapeId >= 0 then --幻化图标
			table.insert(tIconType, 7)
		end
		local petMessage = self.m_tPlayerInfo.petMessage --宠物
		if CheckButtonOpen(27, false) and petMessage and petMessage ~= "" then
			table.insert(tIconType, 13)
		end
		local professionAttr1 = self.m_tPlayerInfo.professionAttr1
		local professionAttr2 = self.m_tPlayerInfo.professionAttr2
		WZLog("职业勋章的属性",professionAttr1,professionAttr2)
		WZLog("职业id",self.m_tPlayerInfo.professionId)
		if CheckButtonShow(152) and professionAttr1 ~= "" and self.m_tPlayerInfo.professionId > 0 then
			table.insert(tIconType, 15)
		end
		if CheckButtonShow(120) then 	--觉醒图标
			table.insert(tIconType, 8)
		end

		local wedBufLevel = self.m_tPlayerInfo.wedBufLevel
		local wedBufTime = self.m_tPlayerInfo.wedBufTime
		if CheckButtonShow(8) and wedBufLevel and wedBufLevel > 0 and wedBufTime and wedBufTime - SystemTime:getServerTime() > 0 then 	--婚礼buff
			table.insert(tIconType, 14)
		end
		if self.m_tPlayerInfo.medalInfo and self.m_tPlayerInfo.medalInfo ~= "" then 
			local tTempMedal = {}
			for key, value in pairs(self.m_tPlayerInfo.medalInfo) do
				local tItem = {}
				tItem[1] = 17 
				tItem[2] = tonumber(key)
				tItem[3] = value
				table.insert(tTempMedal, tItem)
			end

			table.sort( tTempMedal, function (a,b) return a[2] < b[2] end )
			for i = 1, #tTempMedal do
				table.insert(tIconType, tTempMedal[i])
			end
		end

		--符文共振
		if self.m_tPlayerInfo.runeResonateAdd ~= "" then
			table.insert(tIconType, 18)
		end

		--卡魂瞻仰
		if self.m_tPlayerInfo.cardSoulBuffAdd ~= "" then
			table.insert(tIconType, 19)
		end

		--图腾洗礼
		if self.m_tPlayerInfo.guildBaptismAdd ~= "" then
			table.insert(tIconType, 20)
		end

		local nRowNum = math.ceil(#tIconType/6)
		WZLog("YYYYYYYYYYYYYYY", Serialize(tIconType))
		local nDataIndex = 1 
		for i = 1, nRowNum do
			local element,tNewObj = CellCheckOther01:createElement()
			local tTempData = {}
			for j = nDataIndex, #tIconType do
				table.insert(tTempData, tIconType[j])

				nDataIndex = nDataIndex + 1
				if #tTempData == 6 then
					break 
				end
			end
			if element ~= nil and tNewObj ~= nil then 
				element = WZUIContainer:luaTo(element)
				if i == 1 then 
					tNewObj:setType(tTempData, LocalStrings.CHECKOTHER6, nRowNum)
				else
					tNewObj:setType(tTempData)
				end
				freeListContainer:pushBack(element)
			end 
		end

		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 3 then
		--装备
		local celElement,tCell = CellCheckOther7:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			freeListContainer:pushBack(celElement)
			tCell:showEquip(self.m_tPlayerInfo.item)
		end 
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 4 then
		--时装(展示)
		local celElement,tCell = CellCheckOther4:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			freeListContainer:pushBack(celElement)
			tCell:showDress(self.m_tPlayerInfo.item)
		end 
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 5 then
		--时装(战力)
		local celElement,tCell = CellCheckOther4:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			freeListContainer:pushBack(celElement)
			tCell:showDress1(self.m_tPlayerInfo.item)
		end 
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 9 then
		--足迹打卡印记
		if self.m_tPlayerInfo.footMarkCityIds and #self.m_tPlayerInfo.footMarkCityIds ~= 0 then
			local tTempList = {}
			for i = 1, #self.m_tPlayerInfo.footMarkCityIds do
				local tItem = {}

				tItem.id = self.m_tPlayerInfo.footMarkCityIds[i]
				tItem.time = self.m_tPlayerInfo.footMarkCityTimes[i]

				table.insert(tTempList, tItem)
			end
			table.sort( tTempList, function (a, b) return a.id < b.id end)
			local nRowNum = math.ceil(#tTempList/6)
			local nDataIndex = 1 
			for i = 1, nRowNum do
				local element,tNewObj = CellCheckOther9:createElement()
				local tTempData = {}
				for j = nDataIndex, #tTempList do
					table.insert(tTempData, tTempList[j])

					nDataIndex = nDataIndex + 1
					if #tTempData == 6 then
						break 
					end
				end
				if element ~= nil and tNewObj ~= nil then 
					element = WZUIContainer:luaTo(element)
					if i == 1 then 
						tNewObj:setData(tTempData, 7, LocalStrings.FOOTMARK_TEXT32, nRowNum)
					else
						tNewObj:setData(tTempData, 7)
					end
					freeListContainer:pushBack(element)
				end 
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 11 then
		--修炼
		--self.m_tPlayerInfo.xlId = {3,76}
    	if CheckButtonOpen(72, "") then
			if self.m_tPlayerInfo.xlId ~= nil and #self.m_tPlayerInfo.xlId ~= 0 then
				local nRowNum = math.ceil(#self.m_tPlayerInfo.xlId/6)
				local tSortData = {}
				for i = 1, #self.m_tPlayerInfo.xlId do
					local tempTable = {}
					local tPractice = GDatatab_upgrade_attr["id_".. self.m_tPlayerInfo.xlId[i]]
					if tPractice.level ~= 0 then
						tempTable.exp = self.m_tPlayerInfo.xlExp[i]
						tempTable.attrId = tPractice.attr[1][1]
						tempTable.xlId = self.m_tPlayerInfo.xlId[i]
						
						table.insert(tSortData, tempTable)
					end
				end
				if #tSortData > 0 then 
					table.sort(tSortData, _sortPractice)
					-- local nDataIndex = 1 
					-- for i = 1, nRowNum do
					-- 	local element,tNewObj = CellCheckOther10:createElement()
					-- 	local tTempData = {}
					-- 	local tTempData2 = {}
					-- 	for j = nDataIndex, #tSortData do
					-- 		table.insert(tTempData, tSortData[j].xlId)
					-- 		table.insert(tTempData2, tSortData[j].exp)

					-- 		nDataIndex = nDataIndex + 1
					-- 		if #tTempData == 6 then
					-- 			break 
					-- 		end
					-- 	end
					-- 	if element ~= nil and tNewObj ~= nil then 
					-- 		element = WZUIContainer:luaTo(element)
					-- 		freeListContainer:pushBack(element)
					-- 		if i == 1 then
					-- 			tNewObj:setData(tTempData, 4, tTempData2, LocalStrings.PRACTICE_TITLE, nRowNum)	
					-- 		else
					-- 			tNewObj:setData(tTempData, 4, tTempData2)	
					-- 		end
					-- 	end 
					-- end
					local nDataIndex = 1 
					local element,tNewObj = CellCheckOther10:createElement()
					local tTempData = {}
					local tTempData2 = {}
					for j = nDataIndex, #tSortData do
						table.insert(tTempData, tSortData[j].xlId)
						table.insert(tTempData2, tSortData[j].exp)

						nDataIndex = nDataIndex + 1
					end
					if element ~= nil and tNewObj ~= nil then 
						element = WZUIContainer:luaTo(element)
						freeListContainer:pushBack(element)
						tNewObj:setData(tTempData, 4, tTempData2, LocalStrings.PRACTICE_TITLE, nRowNum)
					end 
				end
			end

    	end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 6 then
		--坐骑
		if self.m_tMount and #self.m_tMount ~= 0 then
			local tMountData = self:getMyMountData()
			local nRowNum = math.ceil(#tMountData/6)
			local nDataIndex = 1 
			for i = 1, nRowNum do
				local element,tNewObj = CellCheckOther9:createElement()
				local tTempData = {}
				for j = nDataIndex, #tMountData do
					table.insert(tTempData, tMountData[j])

					nDataIndex = nDataIndex + 1
					if #tTempData == 6 then
						break 
					end
				end
				if element ~= nil and tNewObj ~= nil then 
					element = WZUIContainer:luaTo(element)
					if i == 1 then 
						tNewObj:setData(tTempData, 1, LocalStrings.CHECKOTHER1, nRowNum)
					else
						tNewObj:setData(tTempData, 1)
					end
					freeListContainer:pushBack(element)
				end 
			end
		end

		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 10 then
		--足迹
		if self.m_tFootMark and #self.m_tFootMark ~= 0 then
			local tFootMarkData = self:getMyFootMarkData()

			local nRowNum = math.ceil(#tFootMarkData/6)
			local nDataIndex = 1 
			for i = 1, nRowNum do
				local element,tNewObj = CellCheckOther9:createElement()
				local tTempData = {}
				for j = nDataIndex, #tFootMarkData do
					table.insert(tTempData, tFootMarkData[j])

					nDataIndex = nDataIndex + 1
					if #tTempData == 6 then
						break 
					end
				end
				if element ~= nil and tNewObj ~= nil then 
					element = WZUIContainer:luaTo(element)
					if i == 1 then 
						tNewObj:setData(tTempData, 5, LocalStrings.CHECKOTHER11, nRowNum)
					else
						tNewObj:setData(tTempData, 5)
					end
					freeListContainer:pushBack(element)
				end 
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 7 then
		--幻化
		if self.m_tSkin ~= {} and next(self.m_tSkin) then
			local tSkinData = self:getMySkinData()
			local nRowNum = math.ceil(#tSkinData/6)
			local nDataIndex = 1 
			for i = 1, nRowNum do
				local element,tNewObj = CellCheckOther9:createElement()
				local tTempData = {}
				for j = nDataIndex, #tSkinData do
					table.insert(tTempData, tSkinData[j])

					nDataIndex = nDataIndex + 1
					if #tTempData == 6 then
						break 
					end
				end
				if element ~= nil and tNewObj ~= nil then 
					element = WZUIContainer:luaTo(element)
					if i == 1 then 
						tNewObj:setData(tTempData, 6, LocalStrings.CHECKOTHER13, nRowNum)
					else
						tNewObj:setData(tTempData, 6)
					end
					freeListContainer:pushBack(element)
				end 
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 12 then
		--时装元魂
		self.m_tFashionSoul = {}

		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 13 then		
		if self.m_tPlayerInfo.soulInfo ~= "" then 
			local config = SplitStringWithSeparator(self.m_tPlayerInfo.soulInfo, ",", nil, true)
			for i = 1, #config do
				table.insert(self.m_tFashionSoul, {item_id = config[i], item_num = 1})
			end
		end

		-- WZLog("时装元魂数据2",Serialize(self.m_tFashionSoul))
		self.m_tFashionSoul = self:syntheticItemData(self.m_tFashionSoul)
		local sortOnce = function(a, b)
			-- body
			local t1 = GDatatab_spirit["id_"..a.item_id]
			local t2 = GDatatab_spirit["id_"..b.item_id]
			if t1.level >= t2.level then
				return t1.level < t2.level
			else 
				return t1.level > t2.level
			end
		end
		local sortRune = function(a, b)
			local t1 = GDatatab_item["id_"..GDatatab_spirit["id_"..a.item_id].item_id]
			local t2 = GDatatab_item["id_"..GDatatab_spirit["id_"..b.item_id].item_id]
			-- local t3 = 
			if t1.sub_type ~= t2.sub_type then
				return t1.sub_type < t2.sub_type
			else
				if t1.quality ~= t2.quality then
					return t1.quality > t2.quality
				else
					return t1.id < t2.id
				end
			end
		end
		table.sort( self.m_tFashionSoul, sortOnce )
		table.sort(self.m_tFashionSoul, sortRune)
		if #self.m_tFashionSoul ~= 0 then
			local element,tNewObj = CellCheckOtherRune:createElement()
			if element ~= nil and tNewObj ~= nil then 
				element = WZUIContainer:luaTo(element)
				freeListContainer:pushBack(element)
				tNewObj:setData(self.m_tFashionSoul, LocalStrings.CASTSOUL_TEXT25, 1)
			end
		end
		--符文
		self.m_tRuneInfo = {}
		for i=1,#self.m_tPlayerInfo.runeItemId do
			table.insert(self.m_tRuneInfo, {item_id = self.m_tPlayerInfo.runeItemId[i], item_num = self.m_tPlayerInfo.runeItemNum[i]})
		end

		local sortRune = function(a, b)
			local t1 = GDatatab_item["id_"..a.item_id]
			local t2 = GDatatab_item["id_"..b.item_id]
			if t1.sub_type ~= t2.sub_type then
				return t1.sub_type < t2.sub_type
			else
				if t1.quality ~= t2.quality then
					return t1.quality > t2.quality
				else
					return t1.id < t2.id
				end
			end
		end
		table.sort(self.m_tRuneInfo, sortRune)
		if #self.m_tRuneInfo ~= 0 then
			local element,tNewObj = CellCheckOtherRune:createElement()
			if element ~= nil and tNewObj ~= nil then 
				element = WZUIContainer:luaTo(element)
				freeListContainer:pushBack(element)
				tNewObj:setData(self.m_tRuneInfo, LocalStrings.CHECKOTHER12,0)
			end

		end

		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 1 then --贵族勋章
		local vipMedal = nil
		local nStarNum = 0
		local vipMedalReal = {stage = {}}
		if self.m_tPlayerInfo.vipMedal then
			vipMedal = json.decode(self.m_tPlayerInfo.vipMedal)
			if vipMedal.stage and #vipMedal.stage > 0 then 
				for i = 1, #vipMedal.stage do
					if vipMedal.stage[i] then
						local info = GDatatab_vip_medal_stage["id_" .. vipMedal.stage[i][2]]
						nStarNum = nStarNum + info.stage
						if info.stage > 0 then 
							table.insert(vipMedalReal.stage, vipMedal.stage[i])
						end
					end
				end
			end
		end
		if nStarNum > 0 then 
			local nRowNum = math.ceil(#vipMedalReal.stage/6)
			local nDataIndex = 1 
			for i = 1, nRowNum do
				local element,tNewObj = CellCheckOther9:createElement()
				local tTempData = {stage = {}}
				for j = nDataIndex, #vipMedalReal.stage do
					table.insert(tTempData.stage, vipMedalReal.stage[j])

					nDataIndex = nDataIndex + 1
					if #tTempData.stage == 6 then
						break 
					end
				end
				if element ~= nil and tNewObj ~= nil then 
					element = WZUIContainer:luaTo(element)
					if i == 1 then 
						tNewObj:setData(tTempData, 8, LocalStrings.NEWVIP_TEXT1[4], nRowNum)
					else
						tNewObj:setData(tTempData, 8)
					end
					freeListContainer:pushBack(element)
				end 
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 8 then 	--皮肤装备
		local celElement,tCell = CellCheckOther4:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			freeListContainer:pushBack(celElement)
			tCell:showPhantomEquip(self.m_tPlayerInfo.phantomEquipment)
		end 
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 14 then
		--坐骑灵石
		self.m_tStone = {}
		local temp_index = 1
		for i = 1, 8 do
			if self.m_tPlayerInfo.spriteStoneInfo[i] ~= "" then
				self.m_tStone[temp_index] = json.decode(self.m_tPlayerInfo.spriteStoneInfo[i])
				temp_index = temp_index + 1
			end
		end
		if #self.m_tStone > 0 then 
			local celElement,tCell = CellCheckOther7:createElement()
			if celElement ~= nil and tCell ~= nil then
				celElement = WZUIContainer:luaTo(celElement)
				freeListContainer:pushBack(celElement)
				tCell:showStone(self.m_tStone)
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 15 then
		--签名
		local celElement,tCell = CellCheckOther2:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			freeListContainer:pushBack(celElement)
			tCell:setSignature(self.m_tPlayerInfo.signature)
			tCell:update(4)
		end 
		self.m_nStartIndex = self.m_nStartIndex + 1
	else
		self.m_root:disableSchedule()
	end
	freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
end

function WndCheckOther:convert_data(data)
	 local new_data = {}
	 for index, v in ipairs(data) do
	  if not new_data[v.item_id] then -- 第一次处理该类型数据
	   new_data[v.item_id] = {}
	   new_data[v.item_id]["item_id"] = v.item_id
	   new_data[v.item_id]["item_num"] = 0
	  end
	  new_data[v.item_id]["item_num"] = new_data[v.item_id]["item_num"] + v.item_num
	 end
	 return new_data
end

function WndCheckOther:syntheticItemData(itemData)
    local item2 = {}

    for i=1,#itemData do
        local bIsExist = false
        local index = 0
        for j=1,#item2 do
            if itemData[i].item_id == item2[j].item_id then
                bIsExist = true
                index = j
                break
            end
        end
        if bIsExist == false then
            local temp = {}
            temp.item_id = itemData[i].item_id
            temp.item_num = itemData[i].item_num
            table.insert(item2,temp)
        else
            item2[index].item_num = item2[index].item_num + itemData[i].item_num
        end
    end
    return item2
end
--@brief    根据属性表，计算战力
--@param    tProperty:属性表
function WndCheckOther:_caculateFighting(tProperty)
    -- body
    -- WZLog("传过去计算战力1",Serialize(tProperty))
    if tProperty == nil or #tProperty == 0 then return 0 end

    local extraInfo = {}
    extraInfo["12"] = 0 
    extraInfo["13"] = 0
    extraInfo["10"] = 0
    extraInfo["11"] = 0
    extraInfo["9"] = 0 
    extraInfo["1"] = 0
    extraInfo["3"] = 0
    extraInfo["4"] = 0
    extraInfo["5"] = 0
    extraInfo["7"] = 0
    extraInfo["19"] = 0
    extraInfo["20"] = 0
    extraInfo["18"] = 0

    for i = 1, #tProperty do
        local sIndex = tostring(tProperty[i][1])
        extraInfo[sIndex] = tProperty[i][2]
    end
    -- WZLog("传过去计算战力2",Serialize(extraInfo))
    local nFighting = caculateClothesFighting(extraInfo)

    return nFighting
end

--@brief 	显示留言滚屏
function WndCheckOther:showMessageList()
	--body

	local showMes = self.m_tPlayerInfo.showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	local conMessage = GetElement(self.m_root, "conMessage_WndCheckOther", WZUIContainer)
	if tBits[7] == 1 then 
		conMessage:disableSchedule()
		conMessage:setVisible(false)
		return 
	end 
	conMessage:setVisible(true)
	conMessage:enableSchedule("createMessage", 0.8)
end
-------------------------------------私有方法模块End----------------------------------------
--@brief	点击私聊回调
function WndCheckOther:onChat(element)
	WZLog("WndCheckOther:onChat")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerInfo == nil then return end

	local equipmentList = self.m_tPlayerInfo.item

	local HeadId 
	local FaceId 
	local color = self.m_tPlayerInfo.headColor
	--取消格子
	for j=1,#equipmentList do
		if equipmentList[j].maintype == 5 and equipmentList[j].subtype == 0 and equipmentList[j].isUse == true then
			HeadId = equipmentList[j].basicInfo.id
		end
		if equipmentList[j].maintype == 5 and equipmentList[j].subtype == 1 and equipmentList[j].isUse == true then
			FaceId = equipmentList[j].basicInfo.id
		end
	end
	local info = self.m_tPlayerInfo
	WZLog("私聊参数",HeadId,FaceId,color)
	if whetherCanPrivateChat(info.id) then 
		WndChat:showChatWindowForPrivateWithIdAndName(info.id,info.name,info.sex,info.level,info.vipLevel,HeadId,FaceId,color, info.headEffectId)
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief	点击加好友回调
function WndCheckOther:onFriend(element)
	WZLog("WndCheckOther:onFriend")
	if self.m_tPlayerInfo == nil then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_RESULT)
		return 
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--跨服不能加好友
	-- if self.m_tPlayerInfo.serverId ~= CacheCenter:getPlayerInfo().serverId then
	-- 	-- MsgBoxManager:showTipBox(LocalStrings.SPACE104)
	-- 	-- return
	-- end
	
	--不能添加不同分组服务器
	if tonumber(GlobalMethod:crossServiceOpen()) ~= CacheCenter:getServerStatusByServerId(tonumber(self.m_tPlayerInfo.serverId)) then
		MsgBoxManager:showTipBox(LocalStrings.CANTADD)
		return 
	end
	
	if self.m_tPlayerInfo.serverId ~= CacheCenter:getPlayerInfo().serverId 
			and tonumber(GlobalMethod:crossServiceOpen()) == 0 and CacheCenter:getServerStatusByServerId(tonumber(self.m_tPlayerInfo.serverId)) == 0 then
		MsgBoxManager:showTipBox(LocalStrings.CANTADD)
		return 
	end

	local vector = WZLuaVector_int_:create()
	vector:push(self.m_tPlayerInfo.id)
	if self.m_tPlayerInfo.isFriend == false then
		local nMaxFriendsNum = GetMaxFriends(CacheCenter:getPlayerInfo().vipLevel)
    	if CacheCenter:getFriendCount() >= nMaxFriendsNum then
    	    local nMaxVipLevel = GetMaxVipLevel()
    	    if CacheCenter:getPlayerInfo().vipLevel >= nMaxVipLevel then
    	        MsgBoxManager:showTipBox(LocalStrings.FRIEND_MAX)
    	    else
    	        MsgBoxManager:showConfirmBox(LocalStrings.FRIENDS_FULL_ATT, self, self.needHigherVipCallBack, nil, nil)
    	    end
    	    return
    	end

    	local bInBlacklist = false 
    	BANCHAT = CacheCenter:getFriendBlacklist()
		for i = 1, #BANCHAT do
			if BANCHAT[i].id == self.m_nPlayerId then
				bInBlacklist = true
				break 
			end
		end
		if bInBlacklist then
			MsgBoxManager:showConfirmBox(LocalStrings.BLACKLIST_TEXT4, self, self.continueToAddFriend)
			return
		end
		ProtocolProcessorWndFriends:send_FRIEND_AddFriend(vector)
	else
		if self.m_tPlayerInfo.couple ~= 0 then
			MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_TOP1)
			return
		elseif self.m_tPlayerInfo.mentoring ~= 0 then
			MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_TOP2)
			return
		end
		
	 	--跨服不同提示
	 	if self.m_tPlayerInfo.serverId ~= CacheCenter:getPlayerInfo().serverId then
        	MsgBoxManager:showConfirmBox(LocalStrings.SUREDELFRIEND1, self, self.deleteFriend, nil, nil)
		else
        	MsgBoxManager:showConfirmBox(LocalStrings.SUREDELFRIEND, self, self.deleteFriend, nil, nil)
	 	end
	end
end

--@brief 	继续添加好友
function WndCheckOther:continueToAddFriend()
	-- body
	local vector = WZLuaVector_int_:create()
	vector:push(self.m_tPlayerInfo.id)
	
	ProtocolProcessorWndFriends:send_FRIEND_AddFriend(vector)
end

function WndCheckOther:needHigherVipCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

function WndCheckOther:needHigherMedalLvCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
    	WndNewVip:showInterface(4)
    end
end

function WndCheckOther:jumpToUI(nId, nResType, tData)
	WZLog("WndCheckOther:jumpToUI", nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
    	local itemId 
    	if tData then 
    		itemId = tData.id
    	else
    		itemId = self.m_nShowBgId
    	end
    	local basicInfo = GDatatab_item["id_" .. itemId]
		local nums = SplitStringWithSeparator(basicInfo.channel, ",", nil, true)
		local nType = nums[1]
		local nUIMainId = nums[2]
		WZLog("WndCheckOther:jumpToUI", nType)
		if nType == 3 then 
			WZLog("WndCheckOther:jumpToUI 11", nType)
    		JumpByUIId(nUIMainId)
    	end
    end
end

--@brief	进入英雄俱乐部
function WndCheckOther:onHero()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"red5_WndCheckOther",WZUIImage):setVisible(false)
	PassportSdkManager:showHeoClub()
end

--@brief	英雄俱乐部按钮显示红点
function WndCheckOther:showRed5()
	if self.m_root == nil then return end
	GetElement(self.m_root,"red5_WndCheckOther",WZUIImage):setVisible(true)
end

--@brief 	解除密友
function WndCheckOther:deleteMiFriend(element)
	if self.m_tPlayerInfo == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	if self.m_tPlayerInfo.chum == 1 then
		local desc = string.format(LocalStrings.FRIENDS_BESTFRIEND17, self.m_tPlayerInfo.name)
		MsgBoxManager:showConfirmBox(desc, self, self.sureToDeleteMiFriend, nil, nil)
		return 
	end
end

--@brief 	确定删除蜜友
function WndCheckOther:sureToDeleteMiFriend()
	-- body
	--发送协议
	ProtocolProcessorWndFriends:send_FRIEND_RemoveChum(self.m_tPlayerInfo.id)
end

--@brief 	解除蜜友成功
function WndCheckOther:deleteBestFriendOK()
	-- body
	MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND18)
	if self.m_root == nil then return end
	GetElement(self.m_root, "Btn4_WndCheckOther", WZUIButton):setVisible(false)
end

--@brief	删除好友
function WndCheckOther:deleteFriend()
	if self.m_tPlayerInfo == nil then return end
	local vector = WZLuaVector_int_:create()
	vector:push(self.m_tPlayerInfo.id)
	ProtocolProcessorWndFriends:send_FRIEND_DeleteFriend(vector)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击发邮件回调
function WndCheckOther:onMail(element)
	WZLog("WndCheckOther:onMail")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerInfo == nil then return end
	WndMail:showMail(self.m_tPlayerInfo.id,self.m_tPlayerInfo.name)
end

--@brief	点击时装格子回调
function WndCheckOther:onDressClicked(tLuaObj,tag,tData)
	WZLog("WndCheckOther:onDressClicked",tag)
	if tData ~= nil and tData.basicInfo ~= nil then
    	local con2 = GetElement(self.m_root, "conOtherGrid"..tag.."_WndPlayer", WZUIContainer)
    	WndItemInfo:showInfo(tLuaObj.m_root,WndCheckOther.m_root,1,tData,false, nil, true)
	else
		local showWord = {LocalStrings.PHOTO,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING}
		WndItemInfo:showInfo(tLuaObj.m_root,WndCheckOther.m_root,3,showWord[tag],false, nil, true)
	end
end

--@brief	点击vip等级显示tips
function WndCheckOther:onVIP(element)
	WZLog("WndPlayer:onVIP")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerInfo == nil then return end
	local vipLevel = self.m_tPlayerInfo.vipLevel
	local tData = {vipLevel=vipLevel,other=true,id=self.m_tPlayerInfo.id}
	WndTips:show(GetElement(self.m_root,"conVip",WZUIContainer),self.m_root,20,tData,GlobalMethod:ccp(115,-120), true)
end

--@brief	点击改名
function WndCheckOther:onChangeName(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tPlayerInfo.id == CacheCenter:getPlayerInfo().id then 
		if CheckButtonOpen(155) then
			local itemNum = CacheCenter:getPlayerItemCountById(100)
			if itemNum >= 1 then
				local tData = CacheCenter:getPlayerItemById(100)
				local element = WndEditBox:createElement()
				WndEditBox:setOkCallBack(self.onApplyRename, self)
				WndEditBox:setOtherData(tData)
				WndEditBox:setData(LocalStrings.INPUT_NEW_NAME, LocalStrings.CLICK_TO_INPUT_NAME)
				WindowManager:addWindow(element, WndEditBox)
			else
				--checkIsOnSale(100,text)
				checkIsOnSale(100)
			end
		end
	else
		self:onClickRemark(element)
	end
end

--@brief	改名笔使用回调
function WndCheckOther:onApplyRename(txt,lua,tData)
	if tData.maintype == 2 and tData.subtype == 0 then--使名笔
		local nPlayerItemId = tData.playerItemId
		self.m_nUseType = 1   --标记为改名笔
		result = JudgeResultInClientForInputText(self.m_nUseType, txt)
		WZLog("改名结果是",result)
		if result == 0 then 
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(nPlayerItemId, 1, txt )
		else
			self:displayResult(result)
		end
	end
end

--@brief    显示改名结果
--@param    #1返回的结果result : 1、成功，2、重名，3、非法字符，4、名字不能为空，5、名字太长, 6、名字太短,7、纯数字
function WndCheckOther:displayResult(result)
    --WZLog("************** WndCheckOther:displayResult **************** ", result,type(result),result+1)
	local result = tonumber(result)
	--WZLog("************** WndCheckOther:displayResult **************** ", result,type(result),result+1)
    if result == 1 then
	    MsgBoxManager:showTipBox(LocalStrings.PLAYER_RENAME)
		GetElement(self.m_root,"name_WndCheckOther",WZUILabelTTF):setText(CacheCenter:getPlayerInfo().name)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.NAME_HAVED_EXIST)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO3)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
    elseif result == 5 then
        MsgBoxManager:showTipBox(string.format(LocalStrings.ACTOR_MAX_NAME,6))
    elseif result == 6 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_TOO_SHOOT)
    elseif result == 7 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_CANT_BE_NUMBER)
    elseif result == 8 then 
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO5)
    end
end

--@brief	点击个人属性
function WndCheckOther:onAttr(element)
	WZLog("WndCheckOther:onAttr")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerInfo == nil then return end
	WndPropertyInfo:show(self.m_tPlayerInfo)
	do return end

	local tData = {icon="",
	attrInfo1=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.HEALTH,WndCheckOther.m_tPlayerInfo.hp),
	attrInfo2=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.ATTACK,WndCheckOther.m_tPlayerInfo.attack),
	attrInfo3=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.DEFENSE,WndCheckOther.m_tPlayerInfo.defend),
	attrInfo4=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.CRIT,WndCheckOther.m_tPlayerInfo.critRate),
	attrInfo5=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.FREESTORM,WndCheckOther.m_tPlayerInfo.reduceCrit),
	attrInfo6=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.TIZHI,WndCheckOther.m_tPlayerInfo.physique),
	attrInfo7=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.POWER,WndCheckOther.m_tPlayerInfo.force),
	attrInfo8=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.PRACTICE_ARMOR,WndCheckOther.m_tPlayerInfo.armor),
	attrInfo9=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.AGILITY,WndCheckOther.m_tPlayerInfo.agility),
	attrInfo10=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.LUCKY,WndCheckOther.m_tPlayerInfo.luck),
	attrInfo11=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.ANTIBREAKING,WndCheckOther.m_tPlayerInfo.wreckDefense),
	attrInfo12=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.AVOIDINJURY,WndCheckOther.m_tPlayerInfo.injuryFree),
	attrInfo13=string.format([[<T C="255,227,116" S="22" P="0">%s:</T><T C="255,236,193" S="22" P="0">%d</T>]],LocalStrings.RANGE,WndCheckOther.m_tPlayerInfo.range),
	}
	WndTips:show(element,WndCheckOther.m_root,2,tData,GlobalMethod:ccp(430,-88), true)
	GetElement(WndTips.m_root,"bgType2_WndTips",WZUI9Image):setContentSize(GlobalMethod:CCSize(150,435))
	GetElement(WndTips.m_root,"bgType2_WndTips",WZUI9Image):setRelativePosition(ccp(-0.1,0.51))
	--语言适配
	local language = ProjConfig.LANGUAGE
	if "vn" == language or "en" == language or "th" == language 
		or "pt" == language or "tr" == language then
		local attrInfo
		local positionY
		for i=1,13 do
			if i == 1 or i == 13 then
				attrInfo = GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox)
				positionY = attrInfo:getRelativePosition().y
			else
				attrInfo = GetElement(WndTips.m_root,"attrInfo"..i,WZUIFreeTextBox)
				positionY = attrInfo:getRelativePosition().y
			end
			attrInfo:setScale(0.85)
			attrInfo:setRelativePosition(GlobalMethod:ccp(0.025,positionY))
		end
	elseif ProjConfig.LANGUAGE == "es" then
		local attrInfo
		local positionY
		for i=1,13 do
			if i == 1 or i == 13 then
				attrInfo = GetElement(self.m_root,"attrInfo"..i,WZUIFreeTextBox)
				positionY = attrInfo:getRelativePosition().y
			else
				attrInfo = GetElement(WndTips.m_root,"attrInfo"..i,WZUIFreeTextBox)
				positionY = attrInfo:getRelativePosition().y
			end
			attrInfo:setScale(0.6)
			attrInfo:setRelativePosition(GlobalMethod:ccp(0.02,positionY))
		end
	end
end

--@brief	点击space按钮
function WndCheckOther:onSpace()
	WZLog("WndCheckOther:onSpace")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerInfo == nil then return end
	--跨服不能看空间
	--if self.m_tPlayerInfo.serverId ~= CacheCenter:getPlayerInfo().serverId then
	--	MsgBoxManager:showTipBox(LocalStrings.SPACE104)
	--	return
	--end

	if SceneCommunityKnockout.m_root ~= nil then
		MsgBoxManager:showTipBox(LocalStrings.SPACE97)
		return
	end
	if SceneCommunityWar.m_root ~= nil then
		MsgBoxManager:showTipBox(LocalStrings.SPACE97)
		return
	end

	if GlobalGame.g_bIfInBattle == true then
		MsgBoxManager:showTipBox(LocalStrings.SPACE96)
		return
	end
	if self.m_nPlayerId == nil then
		WZLog("保存的玩家id为nil")
		return 
	end
	if self.m_nChecFromMsg then
		self.m_nChecFromMsg = false
		WndSpaceMain:showOther(self.m_nPlayerId)
		WindowManager:removeWindow(self.m_root, self, true)
	else
		WndSpaceMain:show(self.m_nPlayerId)
	end
end

--@brief	宠物触摸结束
function WndCheckOther:onPetEnd()
	if self.m_tPlayerInfo == nil then return end
	local showMes = self.m_tPlayerInfo.showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)
	if tBits[3] == 0 then return end --不展示宠物时候，触摸不弹宠物tips

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local petMessage = self.m_tPlayerInfo.petMessage
	WZLog("宠物触摸结束:",petMessage)
	if petMessage ~= nil and petMessage ~= "" then
		petMessage = json.decode(petMessage)
		local conPet = WZUIWindow:luaTo(self.m_root:getChildElement("conPet_WndCheckOther"))
		WndTips:show(conPet,self.m_root,13,petMessage,GlobalMethod:ccp(430,-10), true)
	end
end

--@brief	角色形象点击响应
function WndCheckOther:onClickRole(element)
	WZLog("WndCheckOther:onClickRole")
	if self.conPlayer == nil then return end
	if self.m_tPlayerInfo == nil then return end
	if self.m_tPlayerInfo.mountsId ~= nil then
		local name
		if self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 1 then
            name = "wait"
        elseif self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 2 then
            name = "walk2"
        elseif self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 3 then
            name = "walk3"
        elseif self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 4 then
            name = "walk4"
        else
            name = "walk"
        end
		self.conPlayer:play(name,false)
   		self.m_root:enableSchedule("updateRole1")
	else
		local random = os.time()%2 + 1
		if random == 1 then
			self.conPlayer:play("run",false)
		elseif random == 2 then
			self.conPlayer:play("win",false)
		end
   		self.m_root:enableSchedule("updateRole")
	end
end

--@brief	角色形象动画完成回调(无坐骑时)
function WndCheckOther:updateRole(element,t)
    WZLog("WndCheckOther:updateRole")

    if not self.conPlayer:isPlaying() then
        local isEnd = self.conPlayer:isCurrentAnimationDone()
        if isEnd == true then
			self.conPlayer:play("wait0",true)
            self.m_root:disableSchedule()
        end
    end
end

--@brief	角色形象动画完成回调(有坐骑时)
function WndCheckOther:updateRole1(element,t)
    WZLog("WndCheckOther:updateRole1")

    if not self.conPlayer:isPlaying() then
        local isEnd = self.conPlayer:isCurrentAnimationDone()
        if isEnd == true then
			self.conPlayer:play("wait",true)
            self.m_root:disableSchedule()
        end
    end
end

--@brief	点击兑换事件
function WndCheckOther:onClickCode( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndGameGift:showInterface()
end

--@brief 	时间戳转化为时间格式
function WndCheckOther:getTimeByTimestamp(nTimestamp)
	local strTime = ""

	if nTimestamp >= 86400 then
		local day = math.floor(nTimestamp/86400)
		local hour = math.floor(nTimestamp%86400/3600)
		strTime = string.format(LocalStrings.TOPGOLD_TEXT1,day,hour)
	else
		local strFormat = "%d:%d:%d"
		local hour = math.floor(nTimestamp/3600)
		local min = math.floor(nTimestamp%3600/60)
		local sec = nTimestamp%60
		strTime = string.format(strFormat,hour,min,sec)
	end

	return strTime
end

--@brief 	移动背景卡容器位置
--@param 	bShow:是否有显示背景卡打折时间
function WndCheckOther:setBgCardPos(bShow)
	local tbForBg = GetElement(self.m_root, "tbForBg_WndCheckOther", WZUITableContainer)
	local conShowBtn = GetElement(self.m_root, "conShowBtn_WndCheckOther", WZUIContainer)
	if bShow then
		tbForBg:setRelativePosition(GlobalMethod:ccp(0.5,0.97))
		conShowBtn:setRelativePosition(GlobalMethod:ccp(0.5,0))
	else
		tbForBg:setRelativePosition(GlobalMethod:ccp(0.5,1.01))
		conShowBtn:setRelativePosition(GlobalMethod:ccp(0.5,0.02))
	end
end

--@brief 	背景卡打折计时器
function WndCheckOther:_updateDiscountTime(element)
	local txtTimeKey = GetElement(self.m_root, "txtTimeKey_WndCheckOther", WZUILabelTTF)
	local txtTimeValue = GetElement(self.m_root, "txtTimeValue_WndCheckOther", WZUILabelTTF)
	self.m_nRemainTime = self.m_nRemainTime - 1
	if self.m_nRemainTime > 0 then
		txtTimeKey:setVisible(true)
		local strTime = self:getTimeByTimestamp(self.m_nRemainTime)
		txtTimeValue:setText(strTime)

		self:setBgCardPos(true)
	else
		txtTimeKey:setVisible(false)
		txtTimeValue:setText("")
		txtTimeValue:disableSchedule()

		self:setBgCardPos(false)
	end
end

--@brief 	展示所有背景
function WndCheckOther:showSetBg()
	-- body

	-- 背景卡打折倒计时
	local txtTimeKey = GetElement(self.m_root, "txtTimeKey_WndCheckOther", WZUILabelTTF)
	local txtTimeValue = GetElement(self.m_root, "txtTimeValue_WndCheckOther", WZUILabelTTF)
	local itemDiscount = json.decode(CacheCenter:getGameParam()["itemDiscount"])
	local strEndTime = itemDiscount.endDate .. " 23:59:59"
	local pattern = "(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)"
	local xyear,xmonth,xday,xhour,xminute,xseconds = strEndTime:match(pattern)
	local nEndTimestamp = os.time({year = xyear,month = xmonth,day = xday,hour = xhour,min = xminute,sec = xseconds})
	local nServerTime = SystemTime:getServerTime()
	self.m_nRemainTime = nEndTimestamp - nServerTime
	if self.m_nRemainTime > 0 then
		txtTimeKey:setVisible(true)
		local strTime = self:getTimeByTimestamp(self.m_nRemainTime)
		txtTimeValue:setText(strTime)
		txtTimeValue:disableSchedule()
		txtTimeValue:enableSchedule("_updateDiscountTime",1)

		self:setBgCardPos(true)
	else
		txtTimeKey:setVisible(false)
		txtTimeValue:setText("")
		txtTimeValue:disableSchedule()

		self:setBgCardPos(false)
	end



	local tbForBg = GetElement(self.m_root, "tbForBg_WndCheckOther", WZUITableContainer)
	tbForBg:cleanTable()
	if self.m_tBgList == nil then 
		self.m_tBgList = {}
		for i, v in pairs(GDatatab_item) do
			if v.main_type == 25 and v.sub_type == 3 and v.can_sale ~= -1 then
				local tItem = CopyTable(v)
				table.insert(self.m_tBgList, tItem)
			end
		end
	end
	WZLog("WndCheckOther:showSetBg one", Serialize(self.m_tBgList))
	local function rtnState(itemId)
		-- body
		local state = -1 
		local nNum = CacheCenter:getPlayerItemCountById(itemId)
		if nNum > 0 then
			state = 0 
		end

		local basicData = GDatatab_item["id_" .. itemId]
		if basicData.property[1][1] == -1 then 
			if CacheCenter:getPlayerInfo().vipLevel >= basicData.property[1][2] then 
				state = 0
			end
		elseif basicData.property[1][1] == 0 and itemId ~= 830 then
			if whetherHaveWelfareCard() then 
				state = 0 
			end
		elseif basicData.property[1][1] == -2 then 
			local vipMedal	
			if self.m_tPlayerInfo.vipMedal and self.m_tPlayerInfo.vipMedal ~= "" then
				vipMedal = json.decode(self.m_tPlayerInfo.vipMedal)
			end
			if vipMedal and vipMedal.level >= basicData.property[1][2] then 
				state = 0
			end
		end

		if CacheCenter:getPlayerInfo().background and CacheCenter:getPlayerInfo().background == itemId then
			state = 1
		end

		return state
	end
	table.sort(self.m_tBgList, function (a,b)
		-- body
		local stateA = rtnState(a.id)
		local stateB = rtnState(b.id)
		if stateA ~= stateB then
			return stateA > stateB
		else
			return a.id < b.id
		end
	end)
	WZLog("WndCheckOther:showSetBg", Serialize(self.m_tBgList))
	for i = 1, #self.m_tBgList do
		local element, tNewObj = CellCheckOtherBg:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tBgList[i])
			if CacheCenter:getPlayerInfo().background and self.m_tBgList[i].id == CacheCenter:getPlayerInfo().background then
				tNewObj:setSelState(true)
				self.m_tCellClickBg = tNewObj 
				self.m_tCellLastUsingBg = tNewObj
			end
			tbForBg:setCellElement(element)
		end
	end
end

--@brief 	点击背景列表回调
function WndCheckOther:clickBgCellCallBack(element, tCell, tData)
	-- body
	if self.m_tCellClickBg then
		self.m_tCellLastClickBg = self.m_tCellClickBg
		self.m_tCellClickBg:setSelState(false)
	end

	self.m_tCellClickBg = tCell 
	self.m_tClickBgData = tData
	self.m_tCellClickBg:setSelState(true)

	local basicData = GDatatab_item["id_" .. tData.id]
	local function rtnState(itemId)
		-- body
		local state = -1 
		local nNum = CacheCenter:getPlayerItemCountById(itemId)
		if nNum > 0 then
			state = 0 
		end

		if basicData.property[1][1] == -1 then 
			if CacheCenter:getPlayerInfo().vipLevel >= basicData.property[1][2] then 
				state = 0
			end
		elseif basicData.property[1][1] == -2 then 
			local vipMedal	
			if self.m_tPlayerInfo.vipMedal and self.m_tPlayerInfo.vipMedal ~= "" then
				vipMedal = json.decode(self.m_tPlayerInfo.vipMedal)
			end
			if vipMedal and vipMedal.level >= basicData.property[1][2] then 
				state = 0
			end
		elseif basicData.property[1][1] == 0 and itemId ~= 830 then
			if whetherHaveWelfareCard() then 
				state = 0 
			end
		end

		if CacheCenter:getPlayerInfo().background and CacheCenter:getPlayerInfo().background == itemId then
			state = 1
		end

		return state
	end

	local state = rtnState(tData.id)
	if self.m_tClickBgData.id ~= 830 and state == -1 then
		if basicData.property[1][1] == -1 then 
			tData.tBtnList = {LocalStrings.TRYWEAR, LocalStrings.BACKGROUND_VIP_TEXT4}
		elseif basicData.property[1][1] == 0 then 
			tData.tBtnList = {LocalStrings.TRYWEAR, LocalStrings.BUY}
		elseif basicData.property[1][1] == -2 then 
			tData.tBtnList = {LocalStrings.TRYWEAR, LocalStrings.BACKGROUND_VIP_TEXT4}
		elseif basicData.property[1][1] == -3 then 
			if basicData.property[1][2] == 1 then 
				tData.tBtnList = {LocalStrings.TRYWEAR, LocalStrings.OBTAIN}
			else
				tData.tBtnList = {LocalStrings.TRYWEAR}
			end
		else
			tData.tBtnList = {LocalStrings.TRYWEAR, LocalStrings.BUY}
		end
		WndItemInfo:showInfo(element, self.m_root, 1, tData, true, nil, true)
		WndItemInfo:setClickButtonCallback(self, self.tryWear)
	elseif self.m_tClickBgData.id == 830 or state == 0 then
		--发送使用协议
		self.m_nOperateType = 0

		ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(CacheCenter:getPlayerInfo().showMes, self.m_tClickBgData.id)

		WndItemInfo:showInfo(element, self.m_root, 1, tData, true, nil, true)
	elseif state == 1 then
		WndItemInfo:showInfo(element, self.m_root, 1, tData, true, nil, true)
	end
end

--@brief 	关闭设置背景界面
function WndCheckOther:onCloseBgSet(element)
	-- body
	local conForBg = GetElement(self.m_root, "conForBg_WndCHeckOther", WZUIContainer)
	if conForBg:isVisible() then
		conForBg:setVisible(false)
	end
end

function WndCheckOther:checkPointInBtn(pt)
	WZLog("WndCheckOther:checkPoint")
	if self.m_root == nil then return end
	local btn = GetElement(self.m_root, "conForBg_WndCHeckOther", WZUIContainer)
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	WZLog("获得btn 世界坐标",ptA.x,ptA.y, ptA.x + btnSize.width, ptA.y + btnSize.height, pt.x, pt.y)
	WZLog("按钮大小",btnSize.width,btnSize.height)
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		WZLog("WndCheckOther:checkPoint  true")
		return true
	else
		return false
	end 
end

function WndCheckOther:checkPointInOtherBtn(pt)
	WZLog("WndCheckOther:checkPointInOtherBtn")
	if self.m_root == nil then return end
	local btn = GetElement(self.m_root, "conOtherBtn_WndCheckOther", WZUIContainer)
	if btn == nil then return false end
	local btnSize = btn:getContentSize()
	--获得btn的世界坐标
	local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
	
	if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
		WZLog("WndCheckOther:checkPoint  true")
		return true
	else
		return false
	end 
end

--@brief 	点击购买试穿回调
function WndCheckOther:tryWear(nTag, tData)
	-- body
	WndItemInfo:_onCloseClick()
	if nTag == 1 then
		--试穿
		self.m_nShowBgId = tData.id
		self:_setNewBg(tData.id)
		return 
	end
	--购买
	if tData.basicInfo.property[1][1] == -1 then 
		self:needHigherVipCallBack(nil, MSGBOXRESTYPE_CONFIRM)
	elseif tData.basicInfo.property[1][2] == 0 and tData.basicInfo.id ~= 830 then 
		self:gotoBuyWelfareCard(nil, MSGBOXRESTYPE_CONFIRM)
	elseif tData.basicInfo.property[1][1] == -2 then 
		self:needHigherMedalLvCallBack(nil, MSGBOXRESTYPE_CONFIRM)
	elseif tData.basicInfo.property[1][1] == -3 then 
		self:jumpToUI(nil, MSGBOXRESTYPE_CONFIRM, tData)
	else
		if not JudgeMoneyIsEnough(tData.basicInfo.property[1][1], self:getBgCardPrice(tData.basicInfo.id), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamond) then
			return 
		end

		self:sureToUseDiamond()
	end
end

--@brief 	确定购买
function WndCheckOther:sureToUseDiamond()
	-- body
	--发送购买协议购买背景
	if self.m_tClickBgData then
		WZLog("WndCheckOther:sureToUseDiamond", self.m_tClickBgData.id)
		ProtocolProcessorWndBag:send_PLAYER_BuyBackgroundShow(self.m_tClickBgData.id)
	end
end

--@brief 	判断有没有背景卡打折活动,然后获取价格
function WndCheckOther:getBgCardPrice(itemId)
	local price = GDatatab_item["id_" .. itemId].property[1][2]

	local itemDiscount = json.decode(CacheCenter:getGameParam()["itemDiscount"])
	local strEndTime = itemDiscount.endDate .. " 23:59:59"
	local pattern = "(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)"
	local xyear,xmonth,xday,xhour,xminute,xseconds = strEndTime:match(pattern)
	local nEndTimestamp = os.time({year = xyear,month = xmonth,day = xday,hour = xhour,min = xminute,sec = xseconds})
	local nServerTime = SystemTime:getServerTime()

	local ids, nums = SplitItemString(itemDiscount.reward)
	if nServerTime <= nEndTimestamp then
		for i=1,#ids do
			if tonumber(ids[i]) == itemId then
				price = math.ceil(price*tonumber(nums[i])/100)
				break
			end
		end
	end
	return price
end

--@brief 	设置背景
function WndCheckOther:_setNewBg(itemId)
	-- body
	if self.m_root == nil then return end 

	local tBasicData = GDatatab_item["id_" .. itemId]

	local imgSetBg = GetElement(self.m_root, "imgSetBg_WndCheckOther", WZUIImage)
	local imgCircle = GetElement(self.m_root, "imgCircle_WndCheckOther", WZUIImage)
	local spineBg = GetElement(self.m_root, "spineBg_WndCheckOther", WZUISpine)
	local conBGOne = GetElement(self.m_root, "conBGOne_WndCheckOther", WZUIContainer)
	imgSetBg:setVisible(true)
	spineBg:setFileJson("")
	spineBg:setFileAtlas("")
	spineBg:setAnimationName("")
	conBGOne:removeAllChildrenWithCleanup(true)
	if itemId == nil or itemId == 0 or itemId == 830 then
		imgCircle:setVisible(true)
		imgSetBg:setFile("ui/common_bg/common_pic_commonbg.png")
		imgSetBg:setScale(2)
	else
		if tBasicData then
			imgCircle:setVisible(false)
			if tBasicData.animation_index_code == -1 then 
				local sFilePath = string.gsub(tBasicData.icon, "player_bg2", "player_bg")
				local sFileJsonPath = string.gsub(sFilePath, ".png", ".json")
				local bExistSpine = WZFileUtil:isFileExist(sFileJsonPath)
				if bExistSpine then 
					local sFileAtlasPath = string.gsub(sFilePath, ".png", ".atlas")
					spineBg:setFileJson(sFileJsonPath)
					spineBg:setFileAtlas(sFileAtlasPath)
					spineBg:setAnimationName("animation")
				else
					if imgSetBg then
						WZLog("WndCheckOther:_setNewBg", sFilePath)
						imgSetBg:setFile(sFilePath)
						imgSetBg:setScale(1)
					end
				end
			else
				local tTempArray = SplitStringWithSeparator(tBasicData.animation_index_code, "&")
				for i = 1, #tTempArray do
					local strTemp = tTempArray[i]
					local tConfig = SplitStringWithSeparator(strTemp, ",")
					local nStartIndex, nEndIndex = string.find(tConfig[1], ".png")
					local effectFile = "ui/checkother/" .. tConfig[1]
					if nStartIndex and nEndIndex then 
						local bIsUseOriginSize = true 
						if tConfig[4] then 
							if tonumber(tConfig[4]) == 0 then 
								bIsUseOriginSize = false 
							end
						end
						local imgTemp = createImage(effectFile, GlobalMethod:ccp(tonumber(tConfig[2]), tonumber(tConfig[3])), nil, bIsUseOriginSize, GlobalMethod:ccp(0.5,0.5))
						conBGOne:addChild(imgTemp)
					else
						local bExistEffect = WZFileUtil:isFileExist(effectFile .. ".json")
						if bExistEffect then 
							local data = {}
							data.path = effectFile
							data.play = tConfig[4]
							data.loop = true
							data.ccp = GlobalMethod:ccp(tonumber(tConfig[2]), tonumber(tConfig[3]))
			    			createEffectSpine(conBGOne, data)
			    		end
					end
				end
			end
		else
			imgCircle:setVisible(true)
			imgSetBg:setFile("ui/common_bg/common_pic_commonbg.png")
			imgSetBg:setScale(2)
		end
	end
end

--@brief 	设置复选框的状态
function WndCheckOther:_setCheckBoxState()
	-- body
	local checkBoxWing = GetElement(self.m_root, "checkBoxWing_WndCheckOther", WZUICheckBox)
	local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
	local checkBoxPet = GetElement(self.m_root, "checkBoxPet_WndCheckOther", WZUICheckBox)
	local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
	local checkBoxMount = GetElement(self.m_root, "checkBoxMount_WndCheckOther", WZUICheckBox)
	local checkBoxSkin = GetElement(self.m_root, "checkBoxSkin_WndCheckOther", WZUICheckBox)
	local checkBoxMes = GetElement(self.m_root, "checkBoxMes_WndCheckOther", WZUICheckBox)  --一开始默认要选中，所以特殊处理0为选中状态，1为未选中状态

	local tBits = self:_NumberToBits(CacheCenter:getPlayerInfo().showMes, self.m_nBgCheckNum)
	checkBoxWing:setCheckIndex(tBits[1] or 0)
	if self.m_tPlayerInfo.mateName == nil or self.m_tPlayerInfo.mateName == "" then
		checkBoxMate:setCheckIndex(0)
	else
		checkBoxMate:setCheckIndex(tBits[2] or 0)
	end
	checkBoxPet:setCheckIndex(tBits[3] or 0)
	local kidMes = self.m_tPlayerInfo.childMes
	if kidMes == nil or kidMes == "[]" then
		checkBoxKid:setCheckIndex(0)
	else
		checkBoxKid:setCheckIndex(tBits[4] or 0)
	end

	local mesValue = 0
	if tBits[7] == nil or tBits[7] == 0 then 
		mesValue = 1
	end


	checkBoxMount:setCheckIndex(tBits[5] or 0)
	checkBoxSkin:setCheckIndex(tBits[6] or 0)
	checkBoxMes:setCheckIndex(mesValue)
end

--@brief 	展示孩子
function WndCheckOther:_showKids()
	-- body
	if self.m_tPlayerInfo == nil then return end
	if self.m_root == nil then return end
	local conKid1 = GetElement(self.m_root, "conKid1_WndCheckOther", WZUIContainer)
	local conKid2 = GetElement(self.m_root, "conKid2_WndCheckOther", WZUIContainer)
	conKid1:setVisible(false)
	conKid2:setVisible(false)
	conKid1:removeAllChildrenWithCleanup(true)
	conKid2:removeAllChildrenWithCleanup(true)

	local showMes = self.m_tPlayerInfo.showMes
	local tBits = self:_NumberToBits(showMes, self.m_nBgCheckNum)

	if tBits[4] == 0 then return end 
	local tKidData = json.decode(self.m_tPlayerInfo.childMes)
	local nKidNum = #tKidData 
	local kidPt = {}
	if nKidNum == 1 then
		if tBits[2] == 1 and self.m_tPlayerInfo.mateName and self.m_tPlayerInfo.mateName ~= "" then
			kidPt[1] = GlobalMethod:ccp(0.5, 0.2)
		else
			kidPt[1] = GlobalMethod:ccp(0.35, 0.2)
		end
	else
		if tBits[2] == 1 then
			kidPt[1] = GlobalMethod:ccp(0.4, 0.2)
			kidPt[2] = GlobalMethod:ccp(0.6, 0.2)
		else
			kidPt[1] = GlobalMethod:ccp(0.35, 0.2)
			kidPt[2] = GlobalMethod:ccp(0.8, 0.2)
		end
	end
	for i = 1, nKidNum do
		local tEquip = {}
		local conKid = GetElement(self.m_root, "conKid" .. i .. "_WndCheckOther", WZUIContainer)
		conKid:setRelativePosition(kidPt[i])
		conKid:setVisible(true)

	    table.insert(tEquip,tKidData[i].headId)
	    table.insert(tEquip,tKidData[i].faceId)
	    table.insert(tEquip,tKidData[i].bodyId)

	    local conPlayerKid = CreatePlayerBabyFigure(tKidData[i].sex, tEquip, "wait")
	    conPlayerKid:getAnimNode():setScale(0.6)
	    conPlayerKid:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
	    conPlayerKid:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
	    if i == 2 then
	    	conPlayerKid:getAnimNode():setFlipX(true)
	    end
	    
	    conKid:addChild(conPlayerKid:getAnimNode())
	end
end

--@brief 	设置点赞的数量
function WndCheckOther:setDianZanNum()
	-- body
	local txtZanNum = GetElement(self.m_root, "txtZanNum_WndCheckOther", WZUILabelTTF)
	if txtZanNum then
		if self.m_tPlayerInfo.thumbUpNum < 10000 then
			txtZanNum:setText(self.m_tPlayerInfo.thumbUpNum)
		elseif self.m_tPlayerInfo.thumbUpNum >= 10000 then
			txtZanNum:setText(math.floor(self.m_tPlayerInfo.thumbUpNum/10000) .. "W")
		else
			txtZanNum:setText(0)
		end
	end

	self:showLikeIcon()
end

--@brief 	点击点赞按钮回调
function WndCheckOther:onDianZan(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerInfo == nil then return end

	local tData = {}
	if self.m_tPlayerInfo.thumbUpNum and self.m_tPlayerInfo.thumbUpNum >= 0 then
		tData.zanNum = self.m_tPlayerInfo.thumbUpNum
	else
		tData.zanNum = 0
	end
	WndTips:show(element,WndCheckOther.m_root,52,tData,GlobalMethod:ccp(330,-88), true)
end

--@brief    添加顶部钻石栏
function WndCheckOther:_addTop()
    -- body
    local conTop = GetElement(self.m_root, "conTop_WndCheckOther", WZUIContainer)
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_wjxx.png", WndCheckOther, WndCheckOther.onClose, true, false, false,nil,{goldType = 1},false)
    conTop:addChild(celElement)
    self.m_topCellLua = tNewObj
    tNewObj:setWifiSignalVisible(false)
    tNewObj:setTopBGVisible(false)
end

--@brief 	空间信息显示
function WndCheckOther:updateSpaceInfo()
	-- body
	if self.m_root == nil then return end 

	local tData = self.m_tData
	--礼物
	GetElement(self.m_root, "ttf1_WndCheckOther", WZUILabelTTF):setText(tData.giftNum..LocalStrings.SPACE4)
	--人气
	GetElement(self.m_root, "ttf2_WndCheckOther", WZUILabelTTF):setText(tData.popularity)
	--魅力
	GetElement(self.m_root, "ttf3_WndCheckOther", WZUILabelTTF):setText(tData.charmNum)

	local posList = {GlobalMethod:ccp(0.5,0.67), GlobalMethod:ccp(0.5,0.42), GlobalMethod:ccp(0.5,0.17)}
	local posIndex = 1
	--踩一踩和鲜花羁绊
	if #self.m_tFlowerTitleData > 0 then
		GetElement(self.m_root, "btnFlowerTitle_WndCheckOther", WZUIButton):setVisible(true)
		GetElement(self.m_root, "btnFlowerTitle_WndCheckOther", WZUIButton):setRelativePosition(posList[posIndex])
		if self.m_tFlowerTitleData[1].rank == 1 then 
			GetElement(self.m_root, "imgFlowerTitle_WndCheckOther", WZUIImage):setFile("ui/checkother/common_icon_d_sh2.png")
		elseif self.m_tFlowerTitleData[1].rank == 2 then 
			GetElement(self.m_root, "imgFlowerTitle_WndCheckOther", WZUIImage):setFile("ui/checkother/common_icon_d_sh1.png")
		elseif self.m_tFlowerTitleData[1].rank == 3 then 
			GetElement(self.m_root, "imgFlowerTitle_WndCheckOther", WZUIImage):setFile("ui/checkother/common_icon_d_sh.png")
		end

		posIndex = posIndex + 1
	end
	if #self.m_tFootTitleData > 0 then
		GetElement(self.m_root, "btnFootTitle_WndCheckOther", WZUIButton):setVisible(true)
		GetElement(self.m_root, "btnFootTitle_WndCheckOther", WZUIButton):setRelativePosition(posList[posIndex])
		if self.m_tFootTitleData[1].rank == 1 then 
			GetElement(self.m_root, "imgFootTitle_WndCheckOther", WZUIImage):setFile("ui/checkother/common_icon_d_cyc2.png")
		elseif self.m_tFootTitleData[1].rank == 2 then 
			GetElement(self.m_root, "imgFootTitle_WndCheckOther", WZUIImage):setFile("ui/checkother/common_icon_d_cyc1.png")
		elseif self.m_tFootTitleData[1].rank == 3 then 
			GetElement(self.m_root, "imgFootTitle_WndCheckOther", WZUIImage):setFile("ui/checkother/common_icon_d_cyc.png")
		end

		posIndex = posIndex + 1
	end

	if #self.m_tFriendsTitleData > 0 then 
		GetElement(self.m_root, "btnFriendTitle_WndCheckOther", WZUIButton):setVisible(true)
		GetElement(self.m_root, "btnFriendTitle_WndCheckOther", WZUIButton):setRelativePosition(posList[posIndex])
		if self.m_tFriendsTitleData[1].rank == 1 then 
			GetElement(self.m_root, "imgFriendTitle_WndCheckOther", WZUIImage):setFile("ui/common/common_icon_hydmy03.png")
		elseif self.m_tFriendsTitleData[1].rank == 2 then 
			GetElement(self.m_root, "imgFriendTitle_WndCheckOther", WZUIImage):setFile("ui/common/common_icon_hydmy02.png")
		elseif self.m_tFriendsTitleData[1].rank == 3 then 
			GetElement(self.m_root, "imgFriendTitle_WndCheckOther", WZUIImage):setFile("ui/common/common_icon_hydmy01.png")
		end
	end
end

--@brief    点击添加备注按钮回调
function WndCheckOther:onClickRemark(element)
    -- body
    WZLog("WndCheckOther:onClickRemark")

    local element = WndEditBox:createElement()
    WndEditBox:setOkCallBack(self.onApplyRemarkName, self)
    WndEditBox:setOtherData(self.m_tPlayerInfo)
    WndEditBox:setEditType(3)
    WndEditBox:setData(LocalStrings.FRIEND_DELETE6, LocalStrings.FRIEND_DELETE7)
    WindowManager:addWindow(element, WndEditBox)
end

--@brief    
function WndCheckOther:onApplyRemarkName(txt, lua, tData)
    -- body
    ProtocolProcessorWndFriends:send_FRIEND_RemarkFriend(tData.id, txt)
end
-------------------------------------下载文件管理Begin----------------------------------------
--@brief 	新增下载文件任务
--@param	fileName文件名,tCell1设置图片的Cell,tCell2设置图片的Cell
function WndCheckOther:addDownloadFileList(fileName, tCell1, tCell2, size, tCell)
	WZLog("WndCheckOther:addDownloadFileList",fileName)
	if fileName == nil or fileName == "" then return end
	self.m_nSize = size
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
	--如果文件存在，不下载，直接使用
	local bExist = WZFileUtil:isFileExist(path)
	if bExist then
		WZLog("文件存在",tCell1,tCell2,tCell ~= nil)
		local fileError = false
		if tCell1 ~= nil then 
			tCell1:setFile(path) 
			if self.m_nSize ~= nil then
				local imgSize = tCell1:getContentSize()
				local x = self.m_nSize/imgSize.width 
				local y = self.m_nSize/imgSize.height
				WZLog("缩放比例",self.m_nSize,imgSize.width,imgSize.height,math.max(x,y))
				tCell1:setScale(math.max(x,y))
				if imgSize.width < 10 or imgSize.width > 2000 then fileError = true end
				if imgSize.height < 10 or imgSize.height > 2000 then fileError = true end
			end
		end
		if tCell2 ~= nil then 
			tCell2:setFile(path) 
			if self.m_nSize ~= nil then
				local imgSize = tCell2:getContentSize()
				local x = self.m_nSize/imgSize.width 
				local y = self.m_nSize/imgSize.height
				tCell2:setScale(math.max(x,y))
			end
		end
		if tCell ~= nil then
			WZLog("隐藏loding",tCell.m_nIndex)
			tCell:setLodingPhoto(false)
			if fileError then tCell:setInvalidPhoto() end
		end
	else
		--在下载列表中新增记录
		if self.m_tDownloadFileList == nil then self.m_tDownloadFileList = {} end
		--检测是否是重复任务
		for i=1,#self.m_tDownloadFileList do
			if fileName == self.m_tDownloadFileList[i].fileName then
				WZLog("重复下载",fileName)
				return
			end
		end
		local tempTable = {fileName=fileName,tCell1=tCell1,tCell2=tCell2,status="init",tCell=tCell}
		table.insert(self.m_tDownloadFileList,tempTable)
	end
end

--@brief	下载文件
function WndCheckOther:downloadFile(element,t)
	--列表中没有任务，返回
	if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
	--有文件正在下载，返回
	for i=1,#self.m_tDownloadFileList do
		if self.m_tDownloadFileList[i].status=="downloading" then return end
	end
	--没有文件正在下载，开始下载第一个任务
	local fileName = self.m_tDownloadFileList[1].fileName
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
	local s = {}
	s.filePath = path
	s.objName = fileName
	DSSdkManager:downFile(json.encode(s),self.downloadFileFinish, self)
	WZLog("WndCheckOther 调用sdk下载文件",fileName, path)
	self.m_tDownloadFileList[1].status="downloading"
	--WndCheckOther:createLoading()
end

--@brief	下载成功回调
function WndCheckOther:downloadFileFinish(result)
	WZLog("WndCheckOther:downloadFileFinish",result)
	if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
	local result = json.decode(result)
	local fileName = result.objName
	--如果下载失败，把任务清出队列，返回
	WZLog("下载结果",result["return"])
	if result["return"] == "fail" then
		for i=1,#self.m_tDownloadFileList do
			if self.m_tDownloadFileList[i].status == "downloading" then
				table.remove(self.m_tDownloadFileList,i)
				return
			end
		end
	end 
	if fileName == nil then return end
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
	--WZLog("下载完成",path,Serialize(self.m_tDownloadFileList))
	WZLog("下载完成",path)

	for i=1,#self.m_tDownloadFileList do
		WZLog(i,self.m_tDownloadFileList[i],self.m_tDownloadFileList[i].fileName,fileName)
		if self.m_tDownloadFileList[i].fileName == fileName and self.m_tDownloadFileList[i].status == "downloading" then
			local x,y
			if self.m_tDownloadFileList[i].tCell ~= nil then
				if self.m_tDownloadFileList[i].tCell.m_root ~= nil then
					if self.m_tDownloadFileList[i].tCell1 ~= nil then
						local imgPhoto = self.m_tDownloadFileList[i].tCell1
						imgPhoto:setFile(path)
						local size = imgPhoto:getContentSize()
						local hh = 236
						if self.m_nSize ~= nil then hh = self.m_nSize end
						x = hh/size.width 
						y = hh/size.height
						imgPhoto:setScale(math.max(x,y))
					end
					if self.m_tDownloadFileList[i].tCell2 ~= nil then
						local imgPhoto = self.m_tDownloadFileList[i].tCell2
						imgPhoto:setFile(path)
						imgPhoto:setScale(math.max(x,y))
					end
				end
				self.m_tDownloadFileList[i].tCell:setLodingPhoto(false)
			else
				if self.m_tDownloadFileList[i].tCell1 ~= nil then
					local imgPhoto = self.m_tDownloadFileList[i].tCell1
					imgPhoto:setFile(path)
					local size = imgPhoto:getContentSize()
					local hh = 236
					if self.m_nSize ~= nil then hh = self.m_nSize end
					x = hh/size.width 
					y = hh/size.height
					imgPhoto:setScale(math.max(x,y))
				end
				if self.m_tDownloadFileList[i].tCell2 ~= nil then
					local imgPhoto = self.m_tDownloadFileList[i].tCell2
					imgPhoto:setFile(path)
					imgPhoto:setScale(math.max(x,y))
				end
			end
			--一次只下载一个文件,从列表中找到即可返回
			table.remove(self.m_tDownloadFileList,i)
			--WndCheckOther:closeLoading()
			self.m_nSize = nil
			return
		end
	end
end

--@brief 	创建留言
function WndCheckOther:createMessage(element)
	-- body
	if self.m_nMessageIndex > #self.m_tMessageData.messages then 
		element:disableSchedule()
		return 
	end

	local nRadom = math.random(1, 100)
	local nRanPtY = nRadom/100
	local nRanColor = math.fmod(nRadom,4) + 1
	local sContent = self.m_tMessageData.messages[self.m_nMessageIndex]
	local yellowstr, bIsHasMask = CheckYellow(sContent)
	if bIsHasMask then 
		sContent = yellowstr
	end
	local txtMessage = createLabel(sContent, GlobalMethod:ccp(1, nRanPtY), GlobalMethod:ccp(0, 0.5), 20, QUALITYCOLOR[nRanColor])
	txtMessage:setEnableStroke(true)
	txtMessage:setStrokeSize(4)
	txtMessage:setStrokeColor(GlobalMethod:ccc3(79,60,48))
	txtMessage:setShowAll(true)
	element:addChild(txtMessage)

	local moveTo = WZUIActionMoveTo:create()
    moveTo:setMoveX(-0.5)
    moveTo:setMoveY(nRanPtY)
    moveTo:setDuration(12)
    moveTo:setFinishLuaFunction("actionRemoveText")
    txtMessage:runUIAction(moveTo)

	self.m_nMessageIndex = self.m_nMessageIndex + 1
end

function WndCheckOther:actionRemoveText(element)
	-- body
	element:removeFromParentAndCleanup(true)
end

--@brief 	适配iphoneX 
function WndCheckOther:_adaptIphoneX()
	-- body
	if IsIphoneX() then
		GetElement(self.m_root, "conInfo_WndCheckOther", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.96, 0.5))
		GetElement(self.m_root,"conLeftIcon_WndCheckOther",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.05, 0.5))
	end
end

--@brief 
function WndCheckOther:resetLeftPosition()
	-- body
	local limitRate = 1136 / 640
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	local screenRate = screenSize.width / screenSize.height
    
	if screenRate > limitRate then
        CCLuaLog("ScaleToAdjustSpecialScreen two ".."element = "..tostring(element).." screenSize = "..screenSize.width..","..screenSize.height.." screenRate = "..screenRate.." limitRate = "..limitRate)
		local nOriginalWidth = screenSize.height / 640 * 1136
		local nScale = screenSize.width / nOriginalWidth
		local conLeft = GetElement(self.m_root, "conLeft_WndCheckOther", WZUIContainer)
		local oriPos = conLeft:getRelativePosition()
		conLeft:setRelativePosition(GlobalMethod:ccp(oriPos.x * nScale, 0.5))
	end
end

--@brief 	根据点赞的数量，显示对应的点赞图标
function WndCheckOther:showLikeIcon()
	local imgGiveLike = GetElement(self.m_root, "imgGiveLike_WndCheckOther", WZUIImage)
	local fabulous = CacheCenter:getGameParam().fabulous
	local subString = string.sub(fabulous, 2, -2) 
	local num1 = tonumber(SplitStringWithSeparator(subString,",")[1])
	local num2 = tonumber(SplitStringWithSeparator(subString,",")[2])
	if imgGiveLike then 
		if self.m_tPlayerInfo.thumbUpNum >= num2 then 
			imgGiveLike:setFile("ui/common/common_icon_pvpdz2.png")
		elseif self.m_tPlayerInfo.thumbUpNum >= num1 then 
			imgGiveLike:setFile("ui/common/common_icon_pvpdz1.png")
		else
			imgGiveLike:setFile("ui/common/common_icon_pvpdz.png")
		end
	end
end

--@brief 	切换外观标签回调方法
function WndCheckOther:_switchTabCallBack()
	if self.m_nTabIndex == 1 then 
		GetElement(self.m_root, "conBG_WndCheckOther", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conFrame_WndCheckOther", WZUIContainer):setVisible(false)
		self:showSetBg()
	elseif self.m_nTabIndex == 2 then 
		GetElement(self.m_root, "conBG_WndCheckOther", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFrame_WndCheckOther", WZUIContainer):setVisible(true)
		self:showFrame()
	elseif self.m_nTabIndex == 3 then 
		GetElement(self.m_root, "conBG_WndCheckOther", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFrame_WndCheckOther", WZUIContainer):setVisible(true)
		self:showFrame()
	end
end

--@brief 	显示头像框和信息框
function WndCheckOther:showFrame()
	local tbFrame = GetElement(self.m_root, "tbFrame_WndCheckOther", WZUITableContainer)
	tbFrame:cleanTable()
	local conFrame = GetElement(self.m_root, "conFrame_WndCheckOther", WZUIContainer)

	local tListData = {}
	if self.m_nTabIndex == 2 then 
		for i, value in pairs(GDatatab_item) do
			if value.main_type == 40 and value.sub_type == 1 then 
				local itemData = CacheCenter:getPlayerItemById(value.id)
				local tTempItem = {}

				tTempItem.id = value.id 
				tTempItem.basicInfo = CopyTable(value)
				if itemData then 
					local lastNum = CacheCenter:caculatePlayerItemCountById(value.id)
					tTempItem.playerItemId = itemData.playerItemId 
					tTempItem.lastTime = lastNum 
					tTempItem.lastNum = lastNum
					tTempItem.isUse = itemData.isUse
				else
					tTempItem.playerItemId = 0 
					tTempItem.lastTime = 0 
					tTempItem.lastNum = 0
					tTempItem.isUse = false
				end

				table.insert(tListData, tTempItem)
			end
		end
	elseif self.m_nTabIndex == 3 then 
		for i, value in pairs(GDatatab_item) do
			if value.main_type == 2 and value.sub_type == 49 then 
				local itemData = CacheCenter:getPlayerItemById(value.id)
				local tTempItem = {}

				tTempItem.id = value.id 
				tTempItem.basicInfo = CopyTable(value)
				if itemData then 
					tTempItem.playerItemId = itemData.playerItemId 
					tTempItem.lastTime = itemData.lastTime 
					tTempItem.lastNum = itemData.lastNum
					tTempItem.isUse = itemData.isUse
				else
					tTempItem.playerItemId = 0 
					tTempItem.lastTime = 0 
					tTempItem.lastNum = 0
					tTempItem.isUse = false
				end
				
				table.insert(tListData, tTempItem)
			end
		end
	end

	if tListData == nil or #tListData == 0 then 
		ShowPanelNullTip( conFrame, LocalStrings.CHARM_RESULT)
		return 
	end
	table.sort(tListData, sortHeadAndInfoRect)
	removeShowPanelNullTip(conFrame)

	for i = 1, #tListData do
		local celElement,tCell = CellGoodItem:createElement()
		if celElement and tCell then
			celElement:setTag(i - 1)
			tCell:setCellGoodItem(tListData[i], 2)
			tCell:setItemClickFun(self, self.onItemClick)
			if tListData[i].lastNum == 0 then 
				tCell:setGrayRender(true)
			end

			tbFrame:setCellElement(celElement)
		end
	end
end

--@brief 	点击物品回调
function WndCheckOther:onItemClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if tData.lastNum == 0 then 
		WndFastGetItems:show(tData.id, 1)
	else
		WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,nil,nil,true)	
	end
end

--@brief 	排序特效框
function sortHeadAndInfoRect(a, b)
	local valueA = a.isUse == true and 3 or a.lastNum > 0 and 2 or 1 
	local valueB = b.isUse == true and 3 or b.lastNum > 0 and 2 or 1 
	if valueA == valueB then 
		return a.id < b.id
	else
		return valueA > valueB
	end
end

--@brief 	静态文本显示
function WndCheckOther:_initStaticText()
	GetElement(self.m_root, "ttfBtn7_WndCheckOther", WZUILabelTTF):setText(LocalStrings.OTHER_TEXT1[15])
	GetElement(self.m_root, "txtTab3_WndCheckOther", WZUILabelTTF):setText(LocalStrings.OTHER_TEXT1[14])
	GetElement(self.m_root, "txtTabSel3_WndCheckOther", WZUILabelTTF):setText(LocalStrings.OTHER_TEXT1[14])
	GetElement(self.m_root, "txtShowMes_WndCheckOther", WZUILabelTTF):setText(LocalStrings.OTHER_TEXT1[16])
	GetElement(self.m_root, "txtShowMesSel_WndCheckOther", WZUILabelTTF):setText(LocalStrings.OTHER_TEXT1[16])
end
---------------------------------------------语言适配Begin-----------------------------------
function WndCheckOther:_adaptLanguage_vn(  )
	GetElement(self.m_root,"ttfBtn3_WndCheckOther",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF):setScale(0.8)
	local ttfBtn4 = GetElement(self.m_root,"ttfBtn4_WndCheckOther",WZUILabelTTF)
	ttfBtn4:setScale(0.75)
	
	local ttfBtn7 = GetElement(self.m_root,"ttfBtn7_WndCheckOther",WZUILabelTTF)
	ttfBtn7:setDimensions(GlobalMethod:CCSize(100,0))
	ttfBtn7:setScale(0.7)

	GetElement(self.m_root,"curHonorPoint_WndCheckOther",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.32,0.23))
end

function WndCheckOther:_adaptLanguage_th(  )
	GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF):setScale(0.8)
end

function WndCheckOther:_adaptLanguage_en(  )
	GetElement(self.m_root,"ttfBtn3_WndCheckOther",WZUILabelTTF):setFontSize(22)
	-- local title = GetElement(self.m_root,"title_WndCheckOther",WZUILabelTTF)
	-- title:setAlignment(kCCTextAlignmentCenter)
	-- title:setRelativePosition(GlobalMethod:ccp(0.5,0.81))
	-- txtSetChat:setDimensions(GlobalMethod:CCSize(100))
	
	local ttfBtn6 = GetElement(self.m_root,"ttfBtn6_WndCheckOther",WZUILabelTTF)
	ttfBtn6:setDimensions(GlobalMethod:CCSize(130,0))
	ttfBtn6:setScale(0.8)

	local title = GetElement(self.m_root,"title_WndCheckOther",WZUILabelTTF)
	title:setAlignment(kCCTextAlignmentCenter)
	title:setRelativePosition(GlobalMethod:ccp(0.5,0.81))
	title:setScale(0.7)
    title:setDimensions(GlobalMethod:CCSize(260))

    local ttfBtn7 = GetElement(self.m_root,"ttfBtn7_WndCheckOther",WZUILabelTTF)
	ttfBtn7:setDimensions(GlobalMethod:CCSize(160,0))
	ttfBtn7:setScale(0.8)

	local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
	checkBoxMate:setRelativePosition(GlobalMethod:ccp(0.58,0.896825))
	local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
	checkBoxKid:setRelativePosition(GlobalMethod:ccp(0.58,0.354497))

	local txtBlacklist = GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF)
	txtBlacklist:setScale(0.7)
	txtBlacklist:setDimensions(GlobalMethod:CCSize(150))
	
	GetElement(self.m_root,"conVip",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0,0.6))
end

function WndCheckOther:_adaptLanguage_pt(  )
	GetElement(self.m_root,"ttfBtn3_WndCheckOther",WZUILabelTTF):setFontSize(22)
	local title = GetElement(self.m_root,"title_WndCheckOther",WZUILabelTTF)
	title:setRelativePosition(GlobalMethod:ccp(0.5,0.81))
	title:setAlignment(kCCTextAlignmentCenter)
	title:setScale(0.7)
    title:setDimensions(GlobalMethod:CCSize(260))
	-- local txtSetChat = GetElement(self.m_root,"ttfSetChat",WZUILabelTTF)
	-- txtSetChat:setDimensions(GlobalMethod:CCSize(80,0))
	-- txtSetChat:setFontSize(20)

    local ttfBtn1 = GetElement(self.m_root,"ttfBtn1_WndCheckOther",WZUILabelTTF)
    ttfBtn1:setScale(0.8)
    ttfBtn1:setDimensions(GlobalMethod:CCSize(160))
    local ttfBtn2 = GetElement(self.m_root,"ttfBtn2_WndCheckOther",WZUILabelTTF)
    ttfBtn2:setScale(0.8)
    ttfBtn2:setDimensions(GlobalMethod:CCSize(160))
    local ttfBtn6 = GetElement(self.m_root,"ttfBtn6_WndCheckOther",WZUILabelTTF)
	ttfBtn6:setDimensions(GlobalMethod:CCSize(160,0))
	ttfBtn6:setScale(0.8)
	local ttfBtn7 = GetElement(self.m_root,"ttfBtn7_WndCheckOther",WZUILabelTTF)
	ttfBtn7:setDimensions(GlobalMethod:CCSize(160,0))
	ttfBtn7:setScale(0.8)
	local ttfBtn4 = GetElement(self.m_root,"ttfBtn4_WndCheckOther",WZUILabelTTF)
	ttfBtn4:setDimensions(GlobalMethod:CCSize(180,0))
	ttfBtn4:setScale(0.7)

	local checkBoxWing = GetElement(self.m_root, "checkBoxWing_WndCheckOther", WZUICheckBox)
	checkBoxWing:setRelativePosition(GlobalMethod:ccp(0.05,0.883598))
	local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
	checkBoxMate:setRelativePosition(GlobalMethod:ccp(0.56,0.883598))
	local checkBoxPet = GetElement(self.m_root, "checkBoxPet_WndCheckOther", WZUICheckBox)
	checkBoxPet:setRelativePosition(GlobalMethod:ccp(0.05,0.354497))
	local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
	checkBoxKid:setRelativePosition(GlobalMethod:ccp(0.56,0.354497))

	local txtBlacklist = GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF)
	txtBlacklist:setScale(0.7)
	txtBlacklist:setDimensions(GlobalMethod:CCSize(150))

	GetElement(self.m_root,"conVip",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0,0.6))
end

function WndCheckOther:_adaptLanguage_cn(  )
    local title = GetElement(self.m_root,"title_WndCheckOther",WZUILabelTTF)
    --title:setScale(0.6)
    --title:setRelativePosition(GlobalMethod:ccp(0.55,0.81))
end

function WndCheckOther:_adaptLanguage_tr(  )
	local ttfBtn1 = GetElement(self.m_root,"ttfBtn1_WndCheckOther",WZUILabelTTF)
	ttfBtn1:setDimensions(GlobalMethod:CCSize(130,0))
	ttfBtn1:setScale(0.75)

	local ttfBtn6 = GetElement(self.m_root,"ttfBtn6_WndCheckOther",WZUILabelTTF)
	ttfBtn6:setDimensions(GlobalMethod:CCSize(140,0))
	ttfBtn6:setScale(0.8)

	local title = GetElement(self.m_root,"title_WndCheckOther",WZUILabelTTF)
	title:setFontSize(16)
end

function WndCheckOther:_adaptLanguage_es(  )

	local ttfBtn4 = GetElement(self.m_root,"ttfBtn4_WndCheckOther",WZUILabelTTF)
	ttfBtn4:setDimensions(GlobalMethod:CCSize(180,0))
	ttfBtn4:setScale(0.7)

	local ttfBtn1 = GetElement(self.m_root,"ttfBtn1_WndCheckOther",WZUILabelTTF)
	ttfBtn1:setScale(0.7)

	GetElement(self.m_root,"lv_WndCheckOther",WZUILabelTTF):setFontSize(16)
	local name = GetElement(self.m_root,"name_WndCheckOther",WZUILabelTTF)
	name:setFontSize(16)
	name:setRelativePosition(GlobalMethod:ccp(0.413334,0.31))

	local ttfBtn6 = GetElement(self.m_root,"ttfBtn6_WndCheckOther",WZUILabelTTF)
	ttfBtn6:setDimensions(GlobalMethod:CCSize(160,0))
	ttfBtn6:setScale(0.8)	
	local ttfBtn7 = GetElement(self.m_root,"ttfBtn7_WndCheckOther",WZUILabelTTF)
	ttfBtn7:setDimensions(GlobalMethod:CCSize(160,0))
	ttfBtn7:setScale(0.8)

	local title = GetElement(self.m_root,"title_WndCheckOther",WZUILabelTTF)
	title:setAlignment(kCCTextAlignmentCenter)
	title:setRelativePosition(GlobalMethod:ccp(0.5,0.81))
	title:setScale(0.7)
    title:setDimensions(GlobalMethod:CCSize(260))

	local ttfBtn1 = GetElement(self.m_root,"ttfBtn1_WndCheckOther",WZUILabelTTF)
    ttfBtn1:setScale(0.8)
    ttfBtn1:setDimensions(GlobalMethod:CCSize(160))
    local ttfBtn2 = GetElement(self.m_root,"ttfBtn2_WndCheckOther",WZUILabelTTF)
    ttfBtn2:setScale(0.8)
    ttfBtn2:setDimensions(GlobalMethod:CCSize(160))
    local ttfBtn6 = GetElement(self.m_root,"ttfBtn6_WndCheckOther",WZUILabelTTF)
	ttfBtn6:setDimensions(GlobalMethod:CCSize(160,0))
	ttfBtn6:setScale(0.8)
	local ttfBtn7 = GetElement(self.m_root,"ttfBtn7_WndCheckOther",WZUILabelTTF)
	ttfBtn7:setDimensions(GlobalMethod:CCSize(160,0))
	ttfBtn7:setScale(0.8)

	local checkBoxWing = GetElement(self.m_root, "checkBoxWing_WndCheckOther", WZUICheckBox)
	checkBoxWing:setRelativePosition(GlobalMethod:ccp(0.05,0.883598))
	local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
	checkBoxMate:setRelativePosition(GlobalMethod:ccp(0.56,0.883598))
	local checkBoxPet = GetElement(self.m_root, "checkBoxPet_WndCheckOther", WZUICheckBox)
	checkBoxPet:setRelativePosition(GlobalMethod:ccp(0.05,0.354497))
	local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
	checkBoxKid:setRelativePosition(GlobalMethod:ccp(0.56,0.354497))
	
	local txtBlacklist = GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF)
	txtBlacklist:setScale(0.7)
	txtBlacklist:setDimensions(GlobalMethod:CCSize(150))	

	GetElement(self.m_root,"conVip",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0,0.6))
end


function WndCheckOther:_adaptLanguage_ug(  )
	local ttfBtn1 = GetElement(self.m_root,"ttfBtn1_WndCheckOther",WZUILabelTTF)
	ttfBtn1:setScale(0.6)
	ttfBtn1:setDimensions(GlobalMethod:CCSize(200))
	local ttfBtn2 = GetElement(self.m_root,"ttfBtn2_WndCheckOther",WZUILabelTTF)
	ttfBtn2:setScale(0.6)
	ttfBtn2:setDimensions(GlobalMethod:CCSize(200))
	local ttfBtn3 = GetElement(self.m_root,"ttfBtn3_WndCheckOther",WZUILabelTTF)
	ttfBtn3:setScale(0.6)
	ttfBtn3:setDimensions(GlobalMethod:CCSize(200))
	local ttfBtn4 = GetElement(self.m_root,"ttfBtn4_WndCheckOther",WZUILabelTTF)
	ttfBtn4:setScale(0.6)
	ttfBtn4:setDimensions(GlobalMethod:CCSize(200))
	local ttfBtn5 = GetElement(self.m_root,"ttfBtn5_WndCheckOther",WZUILabelTTF)
	ttfBtn5:setScale(0.6)
	ttfBtn5:setDimensions(GlobalMethod:CCSize(200))
	local ttfBtn6 = GetElement(self.m_root,"ttfBtn6_WndCheckOther",WZUILabelTTF)
	ttfBtn6:setScale(0.6)
	ttfBtn6:setDimensions(GlobalMethod:CCSize(200))
	local ttfBtn7 = GetElement(self.m_root,"ttfBtn7_WndCheckOther",WZUILabelTTF)
	ttfBtn7:setScale(0.6)
	ttfBtn7:setDimensions(GlobalMethod:CCSize(200))
	local txtBlacklist = GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF)
	txtBlacklist:setScale(0.5)
	txtBlacklist:setDimensions(GlobalMethod:CCSize(200))


	local txtBoxWing1 = GetElement(self.m_root,"txtBoxWing1_WndCheckOther",WZUILabelTTF)
    txtBoxWing1:setScale(0.7)
    txtBoxWing1:setDimensions(GlobalMethod:CCSize(180))
    local txtBoxWing2 = GetElement(self.m_root,"txtBoxWing2_WndCheckOther",WZUILabelTTF)
    txtBoxWing2:setScale(0.7)
    txtBoxWing2:setDimensions(GlobalMethod:CCSize(180))

	local txtBoxMate1 = GetElement(self.m_root,"txtBoxMate1_WndCheckOther",WZUILabelTTF)
    txtBoxMate1:setScale(0.7)
    txtBoxMate1:setDimensions(GlobalMethod:CCSize(180))
    local txtBoxMate2 = GetElement(self.m_root,"txtBoxMate2_WndCheckOther",WZUILabelTTF)
    txtBoxMate2:setScale(0.7)
    txtBoxMate2:setDimensions(GlobalMethod:CCSize(180))

	local txtBoxPet1 = GetElement(self.m_root,"txtBoxPet1_WndCheckOther",WZUILabelTTF)
    txtBoxPet1:setScale(0.7)
    txtBoxPet1:setDimensions(GlobalMethod:CCSize(180))
    local txtBoxPet2 = GetElement(self.m_root,"txtBoxPet2_WndCheckOther",WZUILabelTTF)
    txtBoxPet2:setScale(0.7)
    txtBoxPet2:setDimensions(GlobalMethod:CCSize(180))

	local txtBoxKid1 = GetElement(self.m_root,"txtBoxKid1_WndCheckOther",WZUILabelTTF)
    txtBoxKid1:setScale(0.7)
    txtBoxKid1:setDimensions(GlobalMethod:CCSize(180))
    local txtBoxKid2 = GetElement(self.m_root,"txtBoxKid2_WndCheckOther",WZUILabelTTF)
    txtBoxKid2:setScale(0.7)
    txtBoxKid2:setDimensions(GlobalMethod:CCSize(180))
end
---------------------------------------------语言适配End--------------------------------------
