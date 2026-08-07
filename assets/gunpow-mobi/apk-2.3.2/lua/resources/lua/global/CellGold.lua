--CellGold.lua
--@brief	CellGold的UI模块
--@date		2014/08/20
--@author	周亚茜
--@note		底部金币公共模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGold:onEnter(element)
	self.m_root = element

	--WZLog("---*********--1111",Serialize(CacheCenter:getGameParam()))
	--if CacheCenter:getGameParam().isUseTicket == "1" then
		--GetElement(self.m_root,"conTicket_CellGold",WZUIContainer):setVisible(false)
		--GetElement(self.m_root,"conGold_CellGold",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	--end

	--判断缓存信息是否存在
	if CacheCenter:hasPlayerInfo() then
	 	self:getStartInfoList()
	else
		WZLog("缓存数据不存在")
	end
	
	CacheCenter:registerUpateMoneyObserver(self)
	CacheCenter:registerUpdateOtherObserver(self)
end

--@brief 	显示相应的货币
--@param 	tItemId:货币的物品id
--@param 	tNeedAddIcon:是否需要显示+号标记
function CellGold:showCoin(tItemId, tNeedAddIcon)
	-- body
	if self.m_root == nil then return end 
	if CacheCenter:getGameParam().isUseTicket == "1" then
		local tag
		for i=1,#tItemId do
			if tItemId[i] == 70 then
				tag = i
			end
		end
		if tag ~= nil then
			table.remove(tItemId,tag)
			table.remove(tNeedAddIcon,tag)
		end
	end

	local tempItemId = {}
	local tempAddIcon = {}
	for i=1,#tItemId do
		if not utilsValueInTable(tItemId[i],tempItemId) then
			table.insert(tempItemId,tItemId[i])
			table.insert(tempAddIcon,tNeedAddIcon[i])
		end
	end
	tItemId = tempItemId
	tNeedAddIcon = tempAddIcon


	self.m_tItemIdList = tItemId 	--货币的物品ID
	self.m_tNeedAddIcon = tNeedAddIcon 	--货币是否需要+号标记

	for i=1,4 do
		if self.m_root:getChildByTag(i - 1) then 
			self.m_root:removeChildByTag(i - 1, true)
		end
	end

	for i = 1, #tItemId do
		if self.m_root:getChildByTag(i - 1) then 
			self.m_root:removeChildByTag(i - 1, true)
		end
		local con = self:_createConForCoin(tItemId[i], tNeedAddIcon[i])
		con:setRelativePosition(GlobalMethod:ccp(0.24 + (i - 1) * 0.184,0.5))
		con:setTag(i - 1)
		self.m_root:addChild(con)
		if ProjConfig.LANGUAGE == "vn" then
			con:setRelativePosition(GlobalMethod:ccp(0.36 + (i - 1) * 0.184,0.5))
		end
	end
	-- if ProjConfig.LANGUAGE == "vn" then
	-- 	-- 越南12+防沉迷图片
	-- 	local icon = "ui/common/12-plus-detail.png"
	-- 	local img = WZUIImage:create()
	-- 	img:setFile(icon)
	-- 	img:setUseOriginSize(true)
	-- 	img:setRelativePosition(GlobalMethod:ccp(0.18,0.5))
	-- 	img:setTouchEnable(false)
	-- 	img:setTouchSwallow(false)
	-- 	img:setScale(0.3)
	-- 	self.m_root:addChild(img)
	-- end

	self:_update()
	-- self:_setGoldTypeBk()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGold:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpateMoneyObserver(self)
	CacheCenter:unregisterUpateOtherObserver(self)
end

--@brief 	点击货币按钮回调
function CellGold:onClickBtn(element)
	-- body
	if self.m_bIsMatching then
		MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
		return 
	end
	if self.shieldClick then 
		return 
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local nTag = element:getTag()
	if nTag == 1 then 
		self:onAddDiamond(element)
	elseif nTag == 177 then
		self:onAddDiamond2(element)
	elseif nTag == 2 then 
		self:onAddGold(element)
	elseif nTag == 6 then 
		self:onAddBadge(element)
	elseif nTag == 58 or nTag == 60 or nTag == 66 or nTag == 67 then 
		WndBuyActivity:showBuyInterface(nTag)
	elseif nTag == 23 or nTag == 61 or nTag == 165 or nTag == 164 or nTag == 107 or nTag == 163 or nTag == 59 or nTag == 26 or nTag == 70 or nTag == 79 or nTag == 85 or nTag == 86 or nTag == 95 or nTag == 96 or nTag == 283 or nTag == 284 then
		WndFastGetItems:show(nTag)
	elseif nTag == 22 then
		WndClownTreasure:showInterface()
	else
		local ptTips 
		if nTag == 107 or nTag == 164 then 
			ptTips = GlobalMethod:ccp(0.6,0)
		elseif nTag == 88 then 
			ptTips = GlobalMethod:ccp(0.4,0)
		end
		self:onClickOtherCoin(nTag, ptTips)
	end
end

--@brief	点击添加钻石按钮调用函数
--@param	element:说明按钮的UI节点引用
function CellGold:onAddDiamond(element)
	if CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_34"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_34"].feedback_info)
		return
	end
	if self.m_tAddDiamon then
		self.m_tAddDiamon[2](self.m_tAddDiamon[1],element)
	end
	--跳转到充值界面
	PassportSdkManager:gotoPaymentPage()
	g_payEventId = -1
	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2,-1)
end

--@brief	点击添加越南粉钻按钮调用函数
--@param	element:说明按钮的UI节点引用
function CellGold:onAddDiamond2(element)
	if CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_34"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_34"].feedback_info)
		return
	end
	if self.m_tAddDiamon then
		self.m_tAddDiamon[2](self.m_tAddDiamon[1],element)
	end
	--跳转到充值界面
	PassportSdkManager:gotoPaymentPage(1)
	g_payEventId = -1
	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2,-1)
end

--@brief	点击添加金币按钮调用函数
--@param	element:说明按钮的UI节点引用
function CellGold:onAddGold(element)
	if CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_35"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_35"].feedback_info)
		return
	end
	--跳转到金币购买界面
	if self.m_tAddGold then
		self.m_tAddGold[2](self.m_tAddGold[1],element)
	end
	WndBuyActivity:showBuyInterface(26)
end

--@brief	点击添加活力按钮调用函数
--@param	element:说明按钮的UI节点引用
function CellGold:onAddLoveGoods(element)
	WZLog("CellGold:onAddLoveGoods")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = GDatatab_item["id_107"]
    if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" then
    	WndItemInfo:showInfo(element,self.m_root,3,tData.name.."\n"..tData.desc,false,GlobalMethod:ccp(0,0))
    else
    	WndItemInfo:showInfo(element,self.m_root,3,tData.name.."                    "..tData.desc,false,GlobalMethod:ccp(180,0))
    end
end

--@brief	点击添加宠物卡调用函数
--@param	element:说明按钮的UI节点引用
function CellGold:onPetCard(element)
	WZLog("CellGold:onPetCard")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = GDatatab_item["id_163"]
    if ProjConfig.LANGUAGE == "vn" then
    	WndItemInfo:showInfo(element,self.m_root,3,tData.name.." "..tData.desc,false,GlobalMethod:ccp(180,0))
    elseif ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en"  then
		WndItemInfo:showInfo(element,self.m_root,3,tData.name.."\n"..tData.desc,false,GlobalMethod:ccp(80,0))
	elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
		WndItemInfo:showInfo(element,self.m_root,3,tData.name.."\n"..tData.desc,false,GlobalMethod:ccp(0,0))
	else
    	WndItemInfo:showInfo(element,self.m_root,3,tData.name.."                  "..tData.desc,false,GlobalMethod:ccp(180,0))
    end
end

--@brief	点击添加徽章按钮调用函数
--@param	element:说明按钮的UI节点引用
function CellGold:onAddBadge(element)
	if CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_36"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_36"].feedback_info)
		return
	end
	--跳转到徽章购买界面
	if self.m_tAddBadge then
		self.m_tAddBadge[2](self.m_tAddBadge[1],element)
	end

	local Vigor = CacheCenter:getPlayerInfo().vigor
	local MaxVigor = 1000
    --打开确认面板
    if Vigor >= MaxVigor then
        MsgBoxManager:showConfirmBox(LocalStrings.CANNOT_BUY_VIGOR, self, self.clickSureBack, nil, nil, true)
        return
    end
        
    WndBuyActivity:showBuyInterface(1056)
end

function CellGold:onClickRuneCoin(element)
	WZLog("CellGold:onClickRuneCoin")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = GDatatab_item["id_59"]
	if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en"  then
		WndItemInfo:showInfo(element,self.m_root,3,tData.name.."\n"..tData.desc,false,GlobalMethod:ccp(180,0))
	else
	    WndItemInfo:showInfo(element,self.m_root,3,tData.name.."                     "..tData.desc,false,GlobalMethod:ccp(180,0))
	end
end

function CellGold:onClickPhantomCoin(element)
	WZLog("CellGold:onClickPhantomCoin")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tData = GDatatab_item["id_61"]
	if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en"  then
		WndItemInfo:showInfo(element,self.m_root,3,tData.name.."\n"..tData.desc,false,GlobalMethod:ccp(180,0))
	else
	    WndItemInfo:showInfo(element,self.m_root,3,tData.name.."                     "..tData.desc,false,GlobalMethod:ccp(180,0))
	end
end

function CellGold:aniForNum()
	-- body
	local bStopAni = true

--	WZLog("**************  CellGold:aniForNum  *******************************")

	if self.m_tGoldNumForAni.blueDiamond > self.m_tGold.blueDiamond then
		bStopAni = false
		self.m_tGoldNumForAni.blueDiamond = self.m_tGoldNumForAni.blueDiamond - self.m_tGoldNumForAni.eachDiamondNum
		if self.m_tGoldNumForAni.blueDiamond < self.m_tGold.blueDiamond then
			self.m_tGoldNumForAni.blueDiamond = self.m_tGold.blueDiamond
		end
		self:_setBlueDiamond(self.m_tGoldNumForAni.blueDiamond)	--设置玩家钻石信息
	elseif self.m_tGoldNumForAni.blueDiamond < self.m_tGold.blueDiamond then
		bStopAni = false
		self.m_tGoldNumForAni.blueDiamond = self.m_tGoldNumForAni.blueDiamond + self.m_tGoldNumForAni.eachDiamondNum
		if self.m_tGoldNumForAni.blueDiamond > self.m_tGold.blueDiamond then
			self.m_tGoldNumForAni.blueDiamond = self.m_tGold.blueDiamond
		end
		self:_setBlueDiamond(self.m_tGoldNumForAni.blueDiamond)	--设置玩家钻石信息
	elseif self.m_tGoldNumForAni.blueDiamond == self.m_tGold.blueDiamond then

	end
	--金币
	if self.m_tGoldNumForAni.gold > self.m_tGold.gold then
		bStopAni = false
		self.m_tGoldNumForAni.gold = self.m_tGoldNumForAni.gold - self.m_tGoldNumForAni.eachGoldNum
		if self.m_tGoldNumForAni.gold < self.m_tGold.gold then
			self.m_tGoldNumForAni.gold = self.m_tGold.gold
		end
		self:_setGold(self.m_tGoldNumForAni.gold)				--设置玩家金币信息
	elseif self.m_tGoldNumForAni.gold < self.m_tGold.gold then
		bStopAni = false
		self.m_tGoldNumForAni.gold = self.m_tGoldNumForAni.gold + self.m_tGoldNumForAni.eachGoldNum
		if self.m_tGoldNumForAni.gold > self.m_tGold.gold then
			self.m_tGoldNumForAni.gold = self.m_tGold.gold
		end
		self:_setGold(self.m_tGoldNumForAni.gold)				--设置玩家金币信息
	elseif self.m_tGoldNumForAni.gold == self.m_tGold.gold then

	end
	--活力
	if CacheCenter:getPlayerInfo() == nil then 
		self.m_root:disableSchedule()
		self:_update()
		return 
	end
	if self.m_tGoldNumForAni.vigor > CacheCenter:getPlayerInfo().vigor then
		bStopAni = false
		self.m_tGoldNumForAni.vigor = self.m_tGoldNumForAni.vigor - self.m_tGoldNumForAni.eachVigorNum
		if self.m_tGoldNumForAni.vigor < CacheCenter:getPlayerInfo().vigor then
			self.m_tGoldNumForAni.vigor = CacheCenter:getPlayerInfo().vigor
		end
		local Vigor = self.m_tGoldNumForAni.vigor
    	local MaxVigor = CacheCenter:getPlayerInfo().maxVigor
		self:_setBadge(Vigor.."/"..MaxVigor)				--设置玩家活力值信息
	elseif self.m_tGoldNumForAni.vigor < CacheCenter:getPlayerInfo().vigor then
		bStopAni = false
		self.m_tGoldNumForAni.vigor = self.m_tGoldNumForAni.vigor + self.m_tGoldNumForAni.eachVigorNum
		if self.m_tGoldNumForAni.vigor > CacheCenter:getPlayerInfo().vigor then
			self.m_tGoldNumForAni.vigor = CacheCenter:getPlayerInfo().vigor
		end
		local Vigor = self.m_tGoldNumForAni.vigor
    	local MaxVigor = CacheCenter:getPlayerInfo().maxVigor
		self:_setBadge(Vigor.."/"..MaxVigor)				--设置玩家活力值信息
	elseif self.m_tGoldNumForAni.vigor == CacheCenter:getPlayerInfo().vigor then

	end

	if bStopAni == true then
		self.m_root:disableSchedule()
		self:_update()
	end
end

--@brief 	获取金币图标节点
function CellGold:getGoldNode()
	-- body
	if self.m_root == nil then return end 

	return goldNode
end

--装备钥匙
-- function CellGold:onClickEquipKey(element)
-- 	WZLog("onClickEquipFragment")
-- 	local conItemTip = GetElement(self.m_root,"conItemTip_CellGold",WZUIContainer)
-- 	local txtItemName = GetElement(conItemTip,"txtItemName_CellGold",WZUILabelTTF)
-- 	local itemInfo =GDatatab_item["id_" .. 164]
-- 	txtItemName:setText(itemInfo.name)

-- 	local txtItemDes = GetElement(conItemTip,"txtItemDes_CellGold",WZUILabelTTF)
-- 	txtItemDes:setText(itemInfo.desc)

-- 	if ProjConfig.LANGUAGE == "en" then
-- 		txtItemName:setScale(0.7)
-- 		txtItemDes:setScale(0.7)
-- 	end
-- 	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
-- 		txtItemName:setScale(0.7)
-- 		txtItemDes:setScale(0.6)
-- 	end

-- 	if ProjConfig.LANGUAGE == "tr" then
-- 		txtItemName:setScale(0.7)
-- 		txtItemDes:setScale(0.7)
-- 		txtItemDes:setDimensions(GlobalMethod:CCSize(230,0))
-- 	end

-- 	conItemTip:setVisible(true)
-- 	conItemTip:setRelativePosition(GlobalMethod:ccp(0.595239,-0.533333))

-- end

-- --装备碎片
-- function CellGold:onClickEquipFragment(element)
-- 	WZLog("onClickEquipFragment")
-- 	local conItemTip = GetElement(self.m_root,"conItemTip_CellGold",WZUIContainer)
	
-- 	local txtItemName = GetElement(conItemTip,"txtItemName_CellGold",WZUILabelTTF)
-- 	local itemInfo =GDatatab_item["id_" .. 165]
-- 	txtItemName:setText(itemInfo.name)

-- 	local txtItemDes = GetElement(conItemTip,"txtItemDes_CellGold",WZUILabelTTF)
-- 	txtItemDes:setText(itemInfo.desc)

-- 	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
-- 		txtItemName:setScale(0.7)
-- 		txtItemDes:setScale(0.6)
-- 	end
	
-- 	conItemTip:setVisible(true)
-- 	conItemTip:setRelativePosition(GlobalMethod:ccp(0.832144,-0.533333))
-- end

-- function CellGold:closeEquipmentTip()
-- 	local conItemTip = GetElement(self.m_root,"conItemTip_CellGold",WZUIContainer)
-- 	if conItemTip:isVisible() then
-- 		conItemTip:setVisible(false)
-- 	end

-- 	if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" then
-- 		txtName:setFontSize(18)
-- 		txtDes:setFontSize(18)
-- 		txtName:setRelativePosition(GlobalMethod:ccp(0.05,0.75))
-- 		txtDes:setRelativePosition(GlobalMethod:ccp(0.05,0.55))
-- 	end
-- 	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
-- 		txtName:setFontSize(18)
-- 		txtDes:setFontSize(18)
-- 		txtName:setRelativePosition(GlobalMethod:ccp(0.05,0.75))
-- 		txtDes:setRelativePosition(GlobalMethod:ccp(0.05,0.55))
-- 	end
-- end

--@brief 	移除tips
function CellGold:removeCreateTips()
	-- body
	local childNode = self.m_root:getChildByTag(9999)
	if childNode then
		self.m_root:removeChildByTag(9999, true)
	end
end

--@brief 	点击没加号的货币栏
function CellGold:onClickOtherCoin(nTag, ptTips)
	-- body
	WZLog("CellGold:onClickBlessCoin")
	local conTip = WZUIContainer:create()
	conTip:setAbsContentSize(GlobalMethod:CCSize(260,100))
	conTip:setUseAbsSize(true)
	conTip:setAnchorPoint(GlobalMethod:ccp(0.5,1))
	if ptTips then
		conTip:setRelativePosition(ptTips)
	else
		conTip:setRelativePosition(GlobalMethod:ccp(0.8,0))
	end

	local imgBK = WZUI9Image:create()
	imgBK:setFile("ui/common/common_scale9_di24.png")

	conTip:addChild(imgBK)

	local tData = GDatatab_item["id_" .. nTag]

	local txtName = WZUILabelTTF:create()
	conTip:addChild(txtName,1)
	txtName:setFontSize(22)
	txtName:setAlignment(kCCTextAlignmentLeft)
	txtName:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtName:setRelativePosition(GlobalMethod:ccp(0.05,0.72))
	txtName:setColor(GlobalMethod:ccc3(127,70,26))
	txtName:setDimensions(GlobalMethod:CCSize(230,0))
	txtName:setText(tData.name)
	--描述
	local txtDes = WZUILabelTTF:create()
	txtDes:setAlignment(kCCTextAlignmentLeft)
	txtDes:setFontSize(22)
	txtDes:setAnchorPoint(GlobalMethod:ccp(0,1))
	txtDes:setRelativePosition(GlobalMethod:ccp(0.05,0.57))
	txtDes:setColor(GlobalMethod:ccc3(127,70,26))
	txtDes:setDimensions(GlobalMethod:CCSize(230,0))
	txtDes:setText(tData.desc)
	conTip:addChild(txtDes,1)

	if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "ug" then
		txtName:setFontSize(18)
		txtDes:setFontSize(18)
		--特殊情况，弹令的时候
		if nTag == 88 then
			conTip:setAbsContentSize(GlobalMethod:CCSize(260,150))
		end
	end

	-- local conBless = GetElement(self.m_root, "conBlessMedal_CellGold", WZUIContainer)
	-- conBless:addChild(conTip,1,678)

	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" 
		or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
		sFormat = [[<T C="127,70,26" S="18" P="1">%s</T><BR></BR><T C="127,70,26" S="18" P="1">%s</T>]]
	end
	self.m_root:addChild(conTip,1,9999)
end

--@brief 	移除tips
-- function CellGold:removeCreateMedalTips()
-- 	-- body
-- 	local conBless = GetElement(self.m_root, "conBlessMedal_CellGold", WZUIContainer)
-- 	if conBless:getChildByTag(678) then
-- 		conBless:removeChildByTag(678, true)
-- 	end

-- 	local imgBK = WZUI9Image:create()
-- 	imgBK:setFile("ui/common/common_scale9_di24.png")

-- 	conTip:addChild(imgBK)

-- 	local tData = GDatatab_item["id_" .. nTag]

-- 	local sFormat = [[<T C="255,236,193" S="22" P="1">%s</T><BR></BR><T C="255,236,193" S="22" P="1">%s</T>]]
-- 	local ftxtDesc = WZUIFreeTextBox:create()
-- 	ftxtDesc:setAnchorPoint(GlobalMethod:ccp(0,0.5))
-- 	ftxtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.5))
-- 	ftxtDesc:setMaxWidth(250)
-- 	ftxtDesc:setShowText(string.format(sFormat, tData.name, tData.desc))
-- 	conTip:addChild(ftxtDesc,1)

-- 	self.m_root:addChild(conTip,1,9999)
-- end

--@brief 	点击礼券
function CellGold:onClickTicket(element)
	-- body
	WZLog("CellGold:onClickTicket")
	local tData = GDatatab_item["id_70"]
	--对背包、圣光、
	if WindowManager:ifActiveWindow(WndAscending) then
		WndTips:show(element,WndAscending.m_root,41,tData,GlobalMethod:ccp(300,-100))
	elseif WindowManager:ifActiveWindow(WndPhantomChest) or WndPhantomChest.m_root then
		WndTips:show(element,WndPhantomChest.m_root,41,tData,GlobalMethod:ccp(300,-100))
	elseif WindowManager:ifActiveWindow(WndPhantom) or WndPhantom.m_root then
		WndTips:show(element,WndPhantom.m_root,41,tData,GlobalMethod:ccp(300,-100))
	elseif WindowManager:ifActiveWindow(WndBagMain) then
		WndTips:show(element,WndBagMain.m_root,41,tData,GlobalMethod:ccp(300,-100))
	elseif WindowManager:ifActiveWindow(Wndwardrobe) or Wndwardrobe.m_root then
		WndTips:show(element,Wndwardrobe.m_root,41,tData,GlobalMethod:ccp(300,-100))
	elseif WndBagMain.m_root and not WindowManager:isFullWindow(WindowManager:getActiveWindow()) and WindowManager:ifActiveWindow(WndBag) or (WndBag.m_root and not WindowManager:isFullWindow(WindowManager:getActiveWindow())) then
		WndTips:show(element,WndBag.m_root,41,tData,GlobalMethod:ccp(300,-100)) 
	else
		WndTips:show(element,self.m_root,41,tData,GlobalMethod:ccp(300,-100))
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	更新数据列表
function CellGold:_update()
	if self.m_root == nil or self.m_tGold == nil or self.m_tItemIdList == nil then
		return
	end
	
	for i = 1, #self.m_tItemIdList do
		local txtValue = GetElement(self.m_root, "txtValue" .. self.m_tItemIdList[i] .. "_CellGold", WZUILabelTTF)
		if txtValue then 
			local num = 0 
			if self.m_tItemIdList[i] == 1 then 
				num = self.m_tGold.blueDiamond 
			elseif self.m_tItemIdList[i] == 2 then 
				num = self.m_tGold.gold 
				if num >= 99999999999 then 
					txtValue:setScale(0.9)
				end
			elseif self.m_tItemIdList[i] == 6 then 
				local Vigor = CacheCenter:getPlayerInfo().vigor
				local MaxVigor = CacheCenter:getPlayerInfo().maxVigor
				num = Vigor .. "/" .. MaxVigor 
			elseif self.m_tItemIdList[i] == 22 then 
				num = self.m_tGold.bless
			elseif self.m_tItemIdList[i] == 23 then 
				num = self.m_tGold.blessMedal
			elseif self.m_tItemIdList[i] == 26 then 
				num = self.m_tGold.card
			elseif self.m_tItemIdList[i] == 58 then 
				num = self.m_tGold.gemCoin
			elseif self.m_tItemIdList[i] == 70 then 
				num = self.m_tGold.ticket
			elseif self.m_tItemIdList[i] == 60 then 
				local nTempNum = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[i])
				num = nTempNum .. "/" .. CacheCenter:getTabooCoinMaxNum()
			elseif self.m_tItemIdList[i] == 79 then 
				local nTempNum = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[i])
				if nTempNum > 24 * 60 then 
					local nDay = math.floor(nTempNum / (24 * 60))
					local nHour = math.floor((nTempNum - nDay * 24 * 60) / 60)

					num = string.format(LocalStrings.TOPGOLD_TEXT1, nDay, nHour)
				else
					local nHour = math.floor(nTempNum / 60)
					local nMinutes = nTempNum - nHour * 60 

					num = string.format(LocalStrings.TOPGOLD_TEXT2, nHour, nMinutes)
				end
			else
				num = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[i])
			end
			txtValue:setText(num)
			if self.m_tItemIdList[i] == 79 then
				if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "vn" then
					txtValue:setScale(0.7)
				end
			end
		end
	end

	self:setDataForAni(self.m_tGold)
end

--@brief 	设置背景条类型
function CellGold:_setGoldTypeBk()
	-- body
	if self.m_tItemIdList == nil then return end 

	if self.m_nType == 1 then
		for i = 1, #self.m_tItemIdList do
			GetElement(self.m_root, "imgBK2_conGold" .. self.m_tItemIdList[i], WZUI9Image):setVisible(true)
			GetElement(self.m_root, "imgBK1_conGold" .. self.m_tItemIdList[i], WZUI9Image):setVisible(false)
		end
	else
		for i = 1, #self.m_tItemIdList do
			GetElement(self.m_root, "imgBK2_conGold" .. self.m_tItemIdList[i], WZUI9Image):setVisible(false)
			GetElement(self.m_root, "imgBK1_conGold" .. self.m_tItemIdList[i], WZUI9Image):setVisible(true)
		end
	end
end

--@brief	设置玩家蓝钻信息
function CellGold:_setBlueDiamond(txt)
	WZLog("CellGold:_setBlueDiamond",txt)
	local txtDiamond = GetElement(self.m_root, "txtValue1_CellGold", WZUILabelTTF)
	if txtDiamond then
		txtDiamond:setText(txt)
	end
end

--@brief	设置玩家礼券信息
function CellGold:_setTicket(txt)
	WZLog("CellGold:_setTicket",txt)

	local txtTicket = GetElement(self.m_root, "txtValue70_CellGold", WZUILabelTTF)
	if txtTicket then
		txtTicket:setText(txt)
	end
end

--@brief	设置玩家金币信息
function CellGold:_setGold(txt)
	WZLog("_setGold",txt)
	local txtGold = GetElement(self.m_root, "txtValue2_CellGold", WZUILabelTTF)
	if txtGold then
	   txtGold:setText(txt)
	end
end

--@brief	设置玩家徽章信息
function CellGold:_setBadge(txt)
	local txtBadge = GetElement(self.m_root, "txtValue6_CellGold", WZUILabelTTF)
	if  txtBadge then
		txtBadge:setText(txt)
	end
end

--@brief 	根据货币类型创建
--@param 	itemId: 货币的物品id
--@param 	nNeedAddIcon: 是否需要加号标记：1->需要；0->不需要
function CellGold:_createConForCoin(itemId, nNeedAddIcon)
	-- body
	local conOutSide = WZUIContainer:create()
	conOutSide:setName("con" .. itemId .. "_CellGold")
	conOutSide:setUseAbsSize(true)
	conOutSide:setAbsContentSize(GlobalMethod:CCSize(125,30))

	--底2
	local img9BK2 = WZUI9Image:create()
	img9BK2:setName("imgBK2_conGold" .. itemId)
	img9BK2:setFile("ui/city/beta/main_icon_jinbishuliangdi_2.png")
	img9BK2:setCapInsets(CCRectMake(80,20,1,1))
	img9BK2:setUseOriginSize(true)
	img9BK2:setScaleX(0.93)
	img9BK2:setVisible(false)
	conOutSide:addChild(img9BK2)

	--底1
	local img9BK1 = WZUI9Image:create()
	img9BK1:setName("imgBK1_conGold" .. itemId)
	img9BK1:setFile("ui/city/beta/main_icon_jinbishuliangdi_3.png")
	img9BK1:setUseOriginSize(true)
	img9BK1:setScaleX(1.1)
	img9BK1:setVisible(false)
	conOutSide:addChild(img9BK1)

	--底3
	local img9BK3 = WZUI9Image:create()
	img9BK3:setName("imgBK3_conGold" .. itemId)
	img9BK3:setFile("ui/common/common_top_shuzidi.png")
	conOutSide:addChild(img9BK3)

	--数量
	local txtValue = WZUILabelTTF:create()
	txtValue:setFontSize(20)
	txtValue:setName("txtValue" .. itemId .. "_CellGold")
	txtValue:setAnchorPoint(GlobalMethod:ccp(1,0.5))
	txtValue:setRelativePosition(GlobalMethod:ccp(0.99,0.45))
	txtValue:setColor(GlobalMethod:ccc3(255,255,255))
	txtValue:setUseOriginSize(true)
	conOutSide:addChild(txtValue)

	--图标
	local imgCoin = WZUIImage:create()
	local tBasicData = GDatatab_item["id_" .. itemId]
	imgCoin:setFile(tBasicData.icon)
	imgCoin:setUseOriginSize(true)
	imgCoin:setScale(0.55)
	imgCoin:setRelativePosition(GlobalMethod:ccp(-0.05,0.5))
	conOutSide:addChild(imgCoin)

	--按钮
	local btnCoin = WZUIButton:create()
	btnCoin:setLuaDoneFunctionName("onClickBtn")
	btnCoin:setUseAbsSize(true)
	btnCoin:setAbsContentSize(GlobalMethod:CCSize(135,30))
	btnCoin:setTag(itemId)
	conOutSide:addChild(btnCoin)
	if nNeedAddIcon == 1 then 
		local imgNor = WZUIImage:create()
        imgNor:setUseOriginSize(true)
        imgNor:setFile("ui/common/common_top_btn_+.png")
        imgNor:setScale(0.9)
        imgNor:setRelativePosition(GlobalMethod:ccp(0.12,0.193))
        local imgSel = WZUIImage:create()
        imgSel:setUseOriginSize(true)
        imgSel:setFile("ui/common/common_top_btn_+.png")
        imgSel:setRelativePosition(GlobalMethod:ccp(0.12,0.193))

        btnCoin:setNormalElement(imgNor)
        btnCoin:setSelectElement(imgSel)
	end

	return conOutSide
end

--@brief 	觉醒界面创建重置按钮
function CellGold:createResetBtn(tCell, func, pt)
	-- body
	if self.m_root:getChildByTag(88) then return end 
	
	self.m_tResetCallBack = {}
	self.m_tResetCallBack[1] = tCell
	self.m_tResetCallBack[2] = func

	local btnReset = WZUIButton:create()
	btnReset:setLuaDoneFunctionName("onClickReset")
	btnReset:setUseAbsSize(true)
	btnReset:setAbsContentSize(GlobalMethod:CCSize(80,50))
	if pt then
		btnReset:setRelativePosition(pt)
	else
		btnReset:setRelativePosition(GlobalMethod:ccp(0.76, 0.5))
	end
	btnReset:setTag(88)
	self.m_root:addChild(btnReset, 1)

	local imgNor = WZUIImage:create()
    imgNor:setUseOriginSize(true)
    imgNor:setFile("ui/common/common_btn_anniu5.png")
    imgNor:setScale(0.95)
    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/common/common_btn_anniu5_sel.png")

    btnReset:setNormalElement(imgNor)
    btnReset:setSelectElement(imgSel)

    local txtValue = WZUILabelTTF:create()
	txtValue:setFontSize(18)
	txtValue:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	txtValue:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	txtValue:setColor(GlobalMethod:ccc3(255,236,193))
	txtValue:setStrokeColor(GlobalMethod:ccc3(128,54,13))
	txtValue:setStrokeSize(4)
	txtValue:setEnableStroke(true)
	txtValue:setText(LocalStrings.RESET)
	btnReset:addChild(txtValue)

	if ProjConfig.LANGUAGE == "vn" then
		txtValue:setScale(0.85)
		btnReset:setRelativePosition(GlobalMethod:ccp(1.03, 0.5))
	elseif ProjConfig.LANGUAGE == "en" or  ProjConfig.LANGUAGE == "pt" or  ProjConfig.LANGUAGE == "es" then
		txtValue:setScale(0.6)
		btnReset:setRelativePosition(GlobalMethod:ccp(0.76, 0.5))
	end
end

--@brief 	点击重置按钮回调
function CellGold:onClickReset(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tResetCallBack then
		self.m_tResetCallBack[2](self.m_tResetCallBack[1])
	end
end
-------------------------------------私有方法模块End----------------------------------------
