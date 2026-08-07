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
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCheckOther:onExit(element)
	self:_unInit()
	ProtocolProcessorWndBag:unregAll()
end

--@brief	加载动画
function WndCheckOther:onEnterTransitionDidFinish(element)
	WZLog("WndCheckOther:onEnterTransitionDidFinish",self.m_nPlayerId)


	if CacheCenter:getPlayerInfo() == nil then return end
	--查看自己从缓存取数据,查看别人发协议
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		addWeChatBtn(element,8,GlobalMethod:ccp(0.59,0.08),1.12)

		self.m_tPlayerInfo = CacheCenter:getPlayerInfo()
		--WZLog("WndCheckOther:onEnterTransitionDidFinish 111",Serialize(self.m_tPlayerInfo))
		--self.m_tPlayerInfo.item = CacheCenter:getEquipmentList()
		self.m_tPlayerInfo.item = CacheCenter:getPlayerItems()
		self.m_tPlayerInfo.segmentId = CacheCenter:getPlayerInfo().segmentLevel
		local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
		self.m_tPlayerInfo.headColor = headColor
		self.m_tPlayerInfo.bodyColor = bodyColor

		self:showPlayer(self.m_tPlayerInfo.item)
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
		self:updateInfo()
		self:_setCheckBoxState()
	else
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

	--local con = GetElement(self.m_root,"freeCon_WndCheckOther",WZUIFreeListContainer)
	--GetElement(self.m_root,"conInfoBg_WndCheckOther",WZUIContainer):setVisible(true)
	--con:setContentSize(GlobalMethod:CCSize(410,375))

	--查看自己不显示加好友，私信，发邮件按钮
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		GetElement(self.m_root,"Btn1_WndCheckOther",WZUIButton):setVisible(false)
		GetElement(self.m_root,"Btn2_WndCheckOther",WZUIButton):setVisible(false)
		GetElement(self.m_root,"Btn3_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"Btn3_WndCheckOther",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.895,0.08))
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or 
			ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
			GetElement(self.m_root,"Btn6_WndCheckOther",WZUIButton):setVisible(true)
			GetElement(self.m_root,"Btn6_WndCheckOther",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.743,0.08))
		end
	else
		GetElement(self.m_root,"Btn1_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"Btn2_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"Btn3_WndCheckOther",WZUIButton):setVisible(true)
		GetElement(self.m_root,"Btn3_WndCheckOther",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.895,0.08))
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or 
			ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
			GetElement(self.m_root,"Btn6_WndCheckOther",WZUIButton):setVisible(false)
		end
	end

	--苹果审核屏蔽兑换码按钮
	if CacheCenter:getGameParam().gameStatus == "1" then
		GetElement(self.m_root,"Btn6_WndCheckOther",WZUIButton):setVisible(false)
	end	

	--是否显示英雄俱乐部按钮
	GetElement(self.m_root,"Btn5_WndCheckOther",WZUIButton):setVisible(false)
	--local curSdkObj = PassportSdkManager:getCurSdkObj()
    --if self.m_nPlayerId == CacheCenter:getPlayerInfo().id and curSdkObj and curSdkObj.m_tConfig.SDKOtherConfig.needBloc == "true" then
	
	if IsNewHeroControl() then
		if self.m_nPlayerId == CacheCenter:getPlayerInfo().id and g_bloc_club == "true" and CheckButtonShow(104) then
			GetElement(self.m_root,"Btn5_WndCheckOther",WZUIButton):setVisible(true)
		end
	else
		if self.m_nPlayerId == CacheCenter:getPlayerInfo().id and CheckButtonShow(104) then
			GetElement(self.m_root,"Btn5_WndCheckOther",WZUIButton):setVisible(true)
		end
	end
	
	--战斗中不显示英雄俱乐部按钮
	if SceneBattle.m_root ~= nil or SceneBattleLoading.m_root ~= nil then 
		GetElement(self.m_root,"Btn5_WndCheckOther",WZUIButton):setVisible(false)
	end

	--个人空间开启才显示按钮
	if CheckButtonShow(60) and CheckButtonOpen(60,false) then
		GetElement(self.m_root,"Btn3_WndCheckOther",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"Btn3_WndCheckOther",WZUIButton):setVisible(false)
	end

	--显示设置背景按钮
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		GetElement(self.m_root,"Btn7_WndCheckOther",WZUIButton):setVisible(true)
	else
		GetElement(self.m_root,"Btn7_WndCheckOther",WZUIButton):setVisible(false)
	end
end

--@brief	开始点击
function WndCheckOther:onTouchBegan(element,pt)
	WZLog("WndCheckOther:onTouchBegan")
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
end

--@brief	外部调用显示接口
function WndCheckOther:show(id)
	WZLog("WndCheckOther:show",id)
	if id == nil then id = CacheCenter:getPlayerInfo().id end
	--if self.m_root == nil thenı
		self.m_nPlayerId = id
		WZLog("WndCheckOther:show1",self.m_nPlayerId)
		local wnd = WndCheckOther:createElement()
		WindowManager:addWindow(wnd, WndCheckOther, true, nil, nil, true)
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
			local costData = GDatatab_item["id_" .. basicData.property[1][1]]
			local sContent = string.format(LocalStrings.CHECKOTHER_TEXT1, basicData.property[1][2], costData.name)
			MsgBoxManager:showConfirmBox(sContent, self, self.sureToBuy, nil, tCustomUIConfig, nil, nil, nil, self.cancelToBuy)
			return 
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
		self:showSetBg()
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
	local tBits = self:_NumberToBits(showMes, 4)
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
	local tBits = self:_NumberToBits(showMes, 4)
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
	local tBits = self:_NumberToBits(showMes, 4)
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
	local tBits = self:_NumberToBits(showMes, 4)
	tBits[4] = nIndex
	showMes = BitsToNumber(tBits)
	ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(showMes, CacheCenter:getPlayerInfo().background)
end

--@brief 	点击伴侣形象回调
function WndCheckOther:onCheckMateInfo(element)
	-- body
	local showMes = self.m_tPlayerInfo.showMes
	local tBits = self:_NumberToBits(showMes, 4)
	WZLog("WndCheckOther:onCheckMateInfo", tBits[2])
	if tBits[2] == 0 then return end 

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tIdList = SplitStringWithSeparator(self.m_tPlayerInfo.coupleMes, "|", nil, true)
	WZLog("WndCheckOther:onCheckMateInfo 1111", type(tIdList[7]), tIdList[7])
	if tIdList and tIdList[7] then
		WndCheckOther:show(tonumber(tIdList[7]))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	显示人物形象
function WndCheckOther:showPlayer(tEquip1)
	if self.m_tPlayerInfo == nil then return end
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
	local tBits = self:_NumberToBits(showMes, 4)

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
		if self.m_tPlayerInfo.shapeId ~= 0 and self.m_tPlayerInfo.showShape == 1 then
			if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
				--if WndPhantom.show == 1 then
        		conPlayer = CreatePlayerFigure(sex, nil, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,true,self.m_tPlayerInfo.shapeId)
			else
        		conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,true,self.m_tPlayerInfo.shapeId)
			end
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.6,0.01))
        	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
		elseif self.m_tPlayerInfo.mountsId ~= nil then
        	if tBits[2] == 0 then
        		conPlayer = CreatePlayerFigure(sex, tEquip, "wait", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,false)
				conPlayer:setMount(self.m_tPlayerInfo.mountsId)
				conPlayer:setScale(0.78)
				conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.03))
			else
				conPlayer = CreatePlayerFigure(sex, tEquip, "wait0", nil, nil ,nil, nil, nil ,nil, nil, self.m_tPlayerInfo.headColor ,self.m_tPlayerInfo.bodyColor,false)
				conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.6,0.01))
        		conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
			end
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

	--设置经验条
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		GetElement(self.m_root,"conExp",WZUIContainer):setVisible(true)
		local exp = self.m_tPlayerInfo.exp
		local maxExp = self.m_tPlayerInfo.maxExp
	if self.m_tPlayerInfo.level ~= nil and GDatatab_player_upgrade["id_"..self.m_tPlayerInfo.level] ~= nil then
		maxExp = GDatatab_player_upgrade["id_"..self.m_tPlayerInfo.level].exp
	end
		local txt = tostring(exp).."/"..tostring(maxExp)
		local percent = tonumber(exp)*100/tonumber(maxExp)
		GetElement(self.m_root,"expPer_WndCheckOther",WZUILabelTTF):setText(txt)
		GetElement(self.m_root,"progrExpProgress_WndCheckOther",WZUIProgress):setPercentage(percent)
		--改名笔
		GetElement(self.m_root,"btnChangeName_WndCheckOther",WZUIButton):setVisible(true)
		--战斗中不显示改名笔
		if SceneLeagueMain.m_root ~= nil or SceneBattle.m_root ~= nil or SceneBattleLoading.m_root ~= nil then 
			GetElement(self.m_root,"btnChangeName_WndCheckOther",WZUIButton):setVisible(false)
		end
	else
		GetElement(self.m_root,"conExp",WZUIContainer):setVisible(false)
		--改名笔
		GetElement(self.m_root,"btnChangeName_WndCheckOther",WZUIButton):setVisible(false)
	end

	--设置战斗力
	local labelFire = GetElement(self.m_root,"fight_WndCheckOther",WZUIFreeTextBox)
	labelFire:setShowText(string.format(LocalStrings.FIGHT_POWER,  self.m_tPlayerInfo.fighting))

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
	local tBits = self:_NumberToBits(showMes, 4)
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
			btnOwnPet:setRelativePosition(GlobalMethod:ccp(0.03,0.588923))
			conPet:setRelativePosition(GlobalMethod:ccp(-0.15,0.45))
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "hk" then
				conPet:setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
			end 
		else
			btnOwnPet:setRelativePosition(GlobalMethod:ccp(0.39,0.588923))
			conPet:setRelativePosition(GlobalMethod:ccp(0.8,0.5))
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
		btnOwnPet:setRelativePosition(GlobalMethod:ccp(0.112,0.588923))
		conPet:setRelativePosition(GlobalMethod:ccp(0,0.45))
	end
end

--@brief	刷新消息
function WndCheckOther:updateInfo()
	if self.m_tPlayerInfo == nil then return end
	self.m_nStartIndex = 1

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
end

--@brief	每帧加载cell
function WndCheckOther:_addCell()
	if self.m_tPlayerInfo == nil then return end
	local freeListContainer = GetElement(self.m_root,"freeCon_WndCheckOther",WZUIFreeListContainer)
	if freeListContainer == nil then return end
	
	if self.m_nStartIndex == 1 then
		--个人空间
		local celElement,tCell = CellCheckOther3:createElement()
		if celElement ~= nil and tCell ~= nil then 
			self.m_tSpaceCell = tCell
			celElement = WZUIContainer:luaTo(celElement)
			freeListContainer:pushBack(celElement)
		end 
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 2 then
		--徽章 
		local celElement,tCell = CellCheckOther8:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setTitle(LocalStrings.CHECKOTHER6)
			freeListContainer:pushBack(celElement)
		end
		local tIconType = {}
		if CheckButtonShow(5) then  	--竞技
			table.insert(tIconType, 1)
		end
		if CheckButtonShow(23) then
			table.insert(tIconType, 2)  --排位
		end
		if CheckButtonShow(23) then 	--排位印记
			table.insert(tIconType, 3)
		end
		local level = WndCheckOther.m_tPlayerInfo.totemLevel
		if tonumber(level) > 0 then 	--公会图标
			table.insert(tIconType, 4)
		end
		if CheckButtonShow(8) then 		--恩爱图标
			table.insert(tIconType, 5)
		end
		if CheckButtonShow(30) then 	--师德图标
			table.insert(tIconType, 6)
		end
		local shapeId = WndCheckOther.m_tPlayerInfo.shapeId
		if shapeId ~= nil and shapeId >= 0 then --幻化图标
			table.insert(tIconType, 7)
		end
		if CheckButtonShow(120) then 	--觉醒图标
			table.insert(tIconType, 8)
		end
		if CheckButtonShow(131) then 	--家园图标
			table.insert(tIconType, 9)
		end
		local tCardData = json.decode(WndCheckOther.m_tPlayerInfo.cardMessage)
		if CheckButtonShow(76) and CheckButtonOpen(76,1) and tCardData.level > 0 then --卡牌图标
			table.insert(tIconType, 10)
		end

		local kidMes = WndCheckOther.m_tPlayerInfo.childMes
		if CheckButtonOpen(145, false) and kidMes and kidMes ~= "" and kidMes ~= "[]" then
			table.insert(tIconType, 11)
		end

		if CheckButtonOpen(31, false) then
			table.insert(tIconType, 12)
		end

		local petMessage = self.m_tPlayerInfo.petMessage
		if CheckButtonOpen(27, false) and petMessage and petMessage ~= "" then
			table.insert(tIconType, 13)
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
				tNewObj:setType(tTempData)
				freeListContainer:pushBack(element)
			end 
		end

		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 3 then
		--装备
		local celElement,tCell
		celElement,tCell = CellCheckOther7:createElement()
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
	elseif self.m_nStartIndex == 6 then
		--祈福
		--if CheckButtonOpen(ISLAND_UP_BLESS) and CheckButtonShow(ISLAND_UP_BLESS) then
		if #self.m_tPlayerInfo.prayIds ~= 0 then
			local celElement,tCell = CellCheckOther8:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setTitle(LocalStrings.ASCENDING_FUSE6)
				freeListContainer:pushBack(celElement)
			end 

			local nRowNum = math.ceil(#self.m_tPlayerInfo.prayIds/6)

			local nDataIndex = 1 
			for i = 1, nRowNum do
				local element,tNewObj = CellCheckOther10:createElement()
				local tTempData = {}
				for j = nDataIndex, #self.m_tPlayerInfo.prayIds do
					table.insert(tTempData, self.m_tPlayerInfo.prayIds[j])

					nDataIndex = nDataIndex + 1
					if #tTempData == 6 then
						break 
					end
				end
				if element ~= nil and tNewObj ~= nil then 
					element = WZUIContainer:luaTo(element)
					freeListContainer:pushBack(element)
					tNewObj:setData(tTempData, 3)	
				end 
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 7 then
		--修炼
		--self.m_tPlayerInfo.xlId = {3,76}
    	if CheckButtonOpen(72, "") then
			if self.m_tPlayerInfo.xlId ~= nil and #self.m_tPlayerInfo.xlId ~= 0 then
				local celElement,tCell = CellCheckOther8:createElement()
				if celElement ~= nil and tCell ~= nil then 
					celElement = WZUIContainer:luaTo(celElement)
					tCell:setTitle(LocalStrings.CHECKOTHER10)
					freeListContainer:pushBack(celElement)
				end 

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
				table.sort(tSortData, _sortPractice)
				local nDataIndex = 1 
				for i = 1, nRowNum do
					local element,tNewObj = CellCheckOther10:createElement()
					local tTempData = {}
					local tTempData2 = {}
					for j = nDataIndex, #tSortData do
						table.insert(tTempData, tSortData[j].xlId)
						table.insert(tTempData2, tSortData[j].exp)

						nDataIndex = nDataIndex + 1
						if #tTempData == 6 then
							break 
						end
					end
					if element ~= nil and tNewObj ~= nil then 
						element = WZUIContainer:luaTo(element)
						freeListContainer:pushBack(element)
						tNewObj:setData(tTempData, 4, tTempData2)	
					end 
				end
			end

    	end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 8 then
		--坐骑
		if #self.m_tMount ~= 0 then
			local celElement,tCell = CellCheckOther8:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setTitle(LocalStrings.CHECKOTHER1)
				freeListContainer:pushBack(celElement)
			end 
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
					freeListContainer:pushBack(element)
					tNewObj:setData(tTempData, 1)	
				end 
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 9 then
		--足迹
		if #self.m_tFootMark ~= 0 then
			local celElement,tCell = CellCheckOther8:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setTitle(LocalStrings.CHECKOTHER11)
				freeListContainer:pushBack(celElement)
			end 
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
					freeListContainer:pushBack(element)
					tNewObj:setData(tTempData, 5)	
				end 
			end
		end
		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 10 then
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
			local celElement,tCell = CellCheckOther8:createElement()
			if celElement ~= nil and tCell ~= nil then 
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setTitle(LocalStrings.CHECKOTHER12)
				freeListContainer:pushBack(celElement)
			end 

			local nRowNum = math.ceil(#self.m_tRuneInfo/6)

			local nDataIndex = 1 
			for i = 1, nRowNum do
				local element,tNewObj = CellCheckOtherRune:createElement()
				local tTempData = {}
				for j = nDataIndex, #self.m_tRuneInfo do
					table.insert(tTempData, self.m_tRuneInfo[j])

					nDataIndex = nDataIndex + 1
					if #tTempData == 6 then
						break 
					end
				end
				if element ~= nil and tNewObj ~= nil then 
					element = WZUIContainer:luaTo(element)
					freeListContainer:pushBack(element)
					tNewObj:setData(tTempData, 5)	
				end 
			end
		end

		self.m_nStartIndex = self.m_nStartIndex + 1
	elseif self.m_nStartIndex == 11 then
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
	WndChat:showChatWindowForPrivateWithIdAndName(info.id,info.name,info.sex,info.level,info.vipLevel,HeadId,FaceId,color )
	--WndChat:showChatWindowForPrivateWithIdAndName(receivePlayerId,receivePlayerName,receivePlayerSex,receivePlayerLevel,receivePlayerVipLevel,receivePlayerHead,receivePlayerFace,receivePlayerHeadColor)
	WindowManager:removeWindow(self.m_root, self, true)
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
    	WndItemInfo:showInfo(tLuaObj.m_root,WndCheckOther.m_root,1,tData,false)
	else
		local showWord = {LocalStrings.PHOTO,LocalStrings.WNDDRESS1,LocalStrings.CLOTHES,LocalStrings.WING}
		WndItemInfo:showInfo(tLuaObj.m_root,WndCheckOther.m_root,3,showWord[tag],false)
	end
end

--@brief	点击vip等级显示tips
function WndCheckOther:onVIP(element)
	WZLog("WndPlayer:onVIP")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tPlayerInfo == nil then return end
	local vipLevel = self.m_tPlayerInfo.vipLevel
	local tData = {vipLevel=vipLevel,other=true,id=self.m_tPlayerInfo.id}
	WndTips:show(GetElement(self.m_root,"conVip",WZUIContainer),self.m_root,20,tData,GlobalMethod:ccp(115,-120))
end

--@brief	点击改名
function WndCheckOther:onChangeName(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
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
	WndTips:show(element,WndCheckOther.m_root,2,tData,GlobalMethod:ccp(430,-88))
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
	local tBits = self:_NumberToBits(showMes, 4)
	if tBits[3] == 0 then return end --不展示宠物时候，触摸不弹宠物tips

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local petMessage = self.m_tPlayerInfo.petMessage
	WZLog("宠物触摸结束:",petMessage)
	if petMessage ~= nil and petMessage ~= "" then
		petMessage = json.decode(petMessage)
		local conPet = WZUIWindow:luaTo(self.m_root:getChildElement("conPet_WndCheckOther"))
		WndTips:show(conPet,self.m_root,13,petMessage,GlobalMethod:ccp(430,-10))
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

--@brief 	展示所有背景
function WndCheckOther:showSetBg()
	-- body
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

	local function rtnState(itemId)
		-- body
		local state = -1 
		local nNum = CacheCenter:getPlayerItemCountById(itemId)
		if nNum > 0 then
			state = 0 
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

	for i = 1, #self.m_tBgList do
		local element, tNewObj = CellCheckOtherBg:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setData(self.m_tBgList[i])
			if CacheCenter:getPlayerInfo().background and self.m_tBgList[i].id == CacheCenter:getPlayerInfo().background then
				tNewObj:setSelState(true)
				self.m_tCellClickBg = tNewObj 
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

	local function rtnState(itemId)
		-- body
		local state = -1 
		local nNum = CacheCenter:getPlayerItemCountById(itemId)
		if nNum > 0 then
			state = 0 
		end

		if CacheCenter:getPlayerInfo().background and CacheCenter:getPlayerInfo().background == itemId then
			state = 1
		end

		return state
	end

	local state = rtnState(tData.id)
	if self.m_tClickBgData.id ~= 830 and state == -1 then
		tData.tBtnList = {LocalStrings.TRYWEAR, LocalStrings.BUY}
		WndItemInfo:showInfo(element, self.m_root, 1, tData, true)
		WndItemInfo:setClickButtonCallback(self, self.tryWear)
	elseif self.m_tClickBgData.id == 830 or state == 0 then
		--发送使用协议
		self.m_nOperateType = 5

		ProtocolProcessorWndBag:send_PLAYER_SetBackgroundShow(CacheCenter:getPlayerInfo().showMes, self.m_tClickBgData.id)
	elseif state == 1 then
		
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
	if not JudgeMoneyIsEnough(tData.basicInfo.property[1][1], tData.basicInfo.property[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamond) then
		return 
	end

	self:sureToUseDiamond()
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

--@brief 	设置背景
function WndCheckOther:_setNewBg(itemId)
	-- body
	if self.m_root == nil then return end 

	local tBasicData = GDatatab_item["id_" .. itemId]

	local imgSetBg = GetElement(self.m_root, "imgSetBg_WndCheckOther", WZUIImage)
	local imgCircle = GetElement(self.m_root, "imgCircle_WndCheckOther", WZUIImage)
	if itemId == nil or itemId == 0 or itemId == 830 then
		imgSetBg:setVisible(false)
		imgCircle:setVisible(true)
	else
		if tBasicData then
			imgCircle:setVisible(false)
			imgSetBg:setVisible(true)
			if imgSetBg then
				local sFilePath = string.gsub(tBasicData.icon, "player_bg2", "player_bg")
				WZLog("WndCheckOther:_setNewBg", sFilePath)
				imgSetBg:setFile(sFilePath)
			end
		else
			imgCircle:setVisible(true)
			imgSetBg:setVisible(false)
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

	local tBits = self:_NumberToBits(CacheCenter:getPlayerInfo().showMes, 4)
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
	local tBits = self:_NumberToBits(showMes, 4)

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
	WndTips:show(element,WndCheckOther.m_root,52,tData,GlobalMethod:ccp(330,-88))
end
---------------------------------------------语言适配Begin-----------------------------------
function WndCheckOther:_adaptLanguage_vn(  )
	GetElement(self.m_root,"ttfBtn3_WndCheckOther",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"img1_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.35,0.94))
	GetElement(self.m_root,"img2_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.65,0.94))

	local checkBoxMate = GetElement(self.m_root, "checkBoxMate_WndCheckOther", WZUICheckBox)
	checkBoxMate:setRelativePosition(GlobalMethod:ccp(0.58,0.896825))
	local checkBoxKid = GetElement(self.m_root, "checkBoxKid_WndCheckOther", WZUICheckBox)
	checkBoxKid:setRelativePosition(GlobalMethod:ccp(0.58,0.354497))

	GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF):setScale(0.8)
end

function WndCheckOther:_adaptLanguage_th(  )
	GetElement(self.m_root, "txtBlacklist_WndCheckOther", WZUILabelTTF):setScale(0.8)
end

function WndCheckOther:_adaptLanguage_en(  )
	GetElement(self.m_root,"ttfBtn3_WndCheckOther",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"img1_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.35,0.94))
	GetElement(self.m_root,"img2_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.65,0.94))
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
	GetElement(self.m_root,"img1_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.31,0.94))
	GetElement(self.m_root,"img2_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.69,0.94))
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
    GetElement(self.m_root,"img1_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.35,0.94))
	GetElement(self.m_root,"img2_WndCheckOther",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.65,0.94))
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
---------------------------------------------语言适配End--------------------------------------
