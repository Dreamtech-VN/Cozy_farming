--SceneRuneLockDraw.lua
--@brief	SceneRuneLockDraw的UI模块
--@date		2017/03/15
--@author	qixiang
--@note		符文抽奖


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneRuneLockDraw:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndRuneDraw:regAll()
	self:addTop()
	ProtocolProcessorWndRuneDraw:send_RUNE_GetLotteryInfo()
	AdaptLanguage(self)
	self.isUseTicket = CacheCenter:getGameParam().isUseTicket
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneRuneLockDraw:onExit(element)
	ProtocolProcessorWndRuneDraw:unregAll()
	self:_unInit()
end

--@brief 	触摸开始回调
function SceneRuneLockDraw:onTouchBegin(element)
	-- body
	if self.m_tTopHangle then
        self.m_tTopHangle.goldCellInfo.tcell:removeCreateTips()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    关闭按钮点击回调
--@param 	element:button的引用
function SceneRuneLockDraw:onCloseClick(element)
	WZLog("SceneRuneLockDraw:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root,self,true)
    
end

--打开符文主界面
function SceneRuneLockDraw:onClickToSceneRune(element)
	WZLog("SceneRuneLockDraw:onClickToSceneRune")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root,self,true)
	if SceneRune and SceneRune.m_root then
		if WndRuneBook and WndRuneBook.m_root then
			WindowManager:removeWindow(WndRuneBook.m_root,WndRuneBook,true)
		end
	else
		WndBagMain:showRune()
	end
end

function SceneRuneLockDraw:initUI()
	WZLog("SceneRuneLockDraw:initUI")
	local gameParam = CacheCenter:getGameParam()
	self.m_nRuneDiamondLotteryFPrice = tonumber(gameParam.runeDiamondLotteryFPrice) 
	self.m_nRuneDiamondLotteryPrice = tonumber(gameParam.runeDiamondLotteryPrice) 

	self.m_nRuneGoldLotteryPrice = tonumber(gameParam.runeGoldLotteryPrice)
	self.m_nRuneGoldLotteryFPrice = tonumber(gameParam.runeGoldLotteryFPrice)
	
	local GetElement = GetElement
	local conCenter = GetElement(self.m_root,"conCenter_SceneRuneLockDraw",WZUIContainer)
	local txtTip1 = GetElement(conCenter,"txtTip1_SceneRuneLockDraw",WZUILabelTTF)
	local txtTip2 = GetElement(conCenter,"txtTip2_SceneRuneLockDraw",WZUILabelTTF)
	local txtTip3 = GetElement(conCenter,"txtTip3_SceneRuneLockDraw",WZUILabelTTF)
	local txtTip4 = GetElement(conCenter,"txtTip4_SceneRuneLockDraw",WZUILabelTTF)
	txtTip2:setText(self.m_nRuneGoldLotteryFPrice)
	txtTip3:setText(self.m_nRuneDiamondLotteryPrice)
	txtTip4:setText(self.m_nRuneDiamondLotteryFPrice)
	txtTip1:setText(self.m_nRuneGoldLotteryPrice)
    
    local gainGold = tonumber(gameParam.runeLotteryGainGold)
    local txtDrawCountTip1 = GetElement(conCenter,"txtDrawCountTip1_SceneRuneLockDraw",WZUILabelTTF)
    txtDrawCountTip1:setText(LocalStrings.BUY2..gainGold)

    local txtDrawCountTip2 = GetElement(conCenter,"txtDrawCountTip2_SceneRuneLockDraw",WZUILabelTTF)
    local temp222 = gainGold * 10
    txtDrawCountTip2:setText(LocalStrings.BUY2..temp222)

    local freeTextDraw1 = GetElement(conCenter,"freeTextDraw1_SceneRuneLockDraw",WZUIFreeTextBox)
    local freeTextDraw2 = GetElement(conCenter,"freeTextDraw2_SceneRuneLockDraw",WZUIFreeTextBox)
    
    local strIndex1 = "(" .. LocalStrings.DRAW_RUNE_TIP2
    local strIndex2 = LocalStrings.DRAW_COUNT .. ")"
    local tempFreeText = string.format(LocalStrings.DRAW_TIP_FREE_TEXT2,strIndex1,1,strIndex2)
    if tempFreeText then
    	freeTextDraw1:setShowText(tempFreeText)
    end
    
    strIndex1 = "(" .. LocalStrings.DRAW_RUNE_TIP2
    tempFreeText = string.format(LocalStrings.DRAW_TIP_FREE_TEXT2,strIndex1,10,strIndex2)
    if tempFreeText then
    	freeTextDraw2:setShowText(tempFreeText)
    end
	
	local imgCostIcon1 = GetElement(conCenter, "imgCostIcon1_SceneRuneLockDraw", WZUIImage)
	if imgCostIcon1 then
		if self.isUseTicket == "0" then
			imgCostIcon1:setFile(GDatatab_item["id_70"].icon)
		else
			imgCostIcon1:setFile(GDatatab_item["id_1"].icon)
		end
		imgCostIcon1:setScale(0.55)
	end
	local imgCostIcon2 = GetElement(conCenter, "imgCostIcon2_SceneRuneLockDraw", WZUIImage)
	if imgCostIcon2 then
		if self.isUseTicket == "0" then
			imgCostIcon2:setFile(GDatatab_item["id_70"].icon)
		else
			imgCostIcon2:setFile(GDatatab_item["id_1"].icon)
		end
		imgCostIcon2:setScale(0.55)
	end

	local imgRed1 = GetElement(conCenter,"imgRed1_SceneRuneLockDraw",WZUIImage)
	imgRed1:setVisible(false)
	local txtCountDown = GetElement(conCenter,"txtCountDown_SceneRuneLockDraw",WZUILabelTTF)
	local txtCountDown2 = GetElement(conCenter,"txtCountDown2_SceneRuneLockDraw",WZUILabelTTF)
	txtCountDown:disableSchedule()
	if self.m_nFreeTime <= 0 then
		txtTip3:setText(LocalStrings.PETFREE2)
		imgRed1:setVisible(true)
		txtCountDown:setText("")
		txtCountDown2:setVisible(false)
	else
		txtCountDown2:setVisible(true)
		txtTip3:setText(self.m_nRuneDiamondLotteryPrice)
		local temp = GlobalMethod:formatTime(self.m_nFreeTime)
		txtCountDown:setText(temp)
		txtCountDown:enableSchedule("countDown",1)
	end
	self:updateDrawTip()
end

--符文抽奖
function SceneRuneLockDraw:onClickDraw(element)
	WZLog("SceneRuneLockDraw:onClickDraw")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_bEnableDraw then return end
	local tag = element:getTag()
	self.m_nTag = tag
	if self.m_nFreeTime == nil then return end
	if tag == 1 then
		local goldCount = CacheCenter:getPlayerItemCountById(2)
		if goldCount < self.m_nRuneGoldLotteryPrice then
			MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
			return
		end
		self.m_bEnableDraw = false
		ProtocolProcessorWndRuneDraw:send_RUNE_Lottery(1,1)
	elseif tag == 2 then
		local goldCount = CacheCenter:getPlayerItemCountById(2)
		if goldCount < self.m_nRuneGoldLotteryFPrice then
			MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
			return
		end
		self.m_bEnableDraw = false
		ProtocolProcessorWndRuneDraw:send_RUNE_Lottery(1,10)
	elseif tag == 3 then
		if self.m_nFreeTime <= 0 then
			ProtocolProcessorWndRuneDraw:send_RUNE_Lottery(0,1)
			self.m_bEnableDraw = false
			return
		else
			if self.isUseTicket == "0" then
				if not JudgeMoneyIsEnough(70,self.m_nRuneDiamondLotteryPrice,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,197, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
                	return
            	end
            else
            	if not JudgeMoneyIsEnough(1,self.m_nRuneDiamondLotteryPrice,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,197, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
                	return
            	end
            end
		end
		
		self:sureUseDiamondInstead()
	elseif tag == 4 then
		if self.isUseTicket == "0" then
			if not JudgeMoneyIsEnough(70,self.m_nRuneDiamondLotteryFPrice,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,197, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            	return
        	end
        else
        	if not JudgeMoneyIsEnough(1,self.m_nRuneDiamondLotteryFPrice,LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE,nil,197, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
            	return
        	end
        end
		
		self:sureUseDiamondInstead()
	end
end

--@brief 	确认用钻石代替礼券抽取符文回调
function SceneRuneLockDraw:sureUseDiamondInstead()
	-- body
	self.m_bEnableDraw = false
	if self.m_nTag == 3 then 
		ProtocolProcessorWndRuneDraw:send_RUNE_Lottery(0,1)
	elseif self.m_nTag == 4 then
		ProtocolProcessorWndRuneDraw:send_RUNE_Lottery(0,10)
	end
end

--@brief	快速购买金币框
function SceneRuneLockDraw:buyGold(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndBuyActivity:showBuyInterface(26)
	end
end

--@brief  跳转到充值界面
--@param    nResType:响应类型(超时，确定，取消)
function SceneRuneLockDraw:clickSureMoney(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
	end
end

--免费抽奖到时时
function SceneRuneLockDraw:countDown(element)
	self.m_nFreeTime = self.m_nFreeTime - 1
	if self.m_nFreeTime <= 0 then
		element:disableSchedule()
		self:updateFreeDraw(true)
	else
		local txtCountDown = GetElement(self.m_root,"txtCountDown_SceneRuneLockDraw",WZUILabelTTF)
		local temp = GlobalMethod:formatTime(self.m_nFreeTime)
		txtCountDown:setText(temp)
	end
end

function SceneRuneLockDraw:updateFreeDraw(bFree)
	WZLog("SceneRuneLockDraw:updateFreeDraw")
	local getElement = GetElement
	local txtCountDown = getElement(self.m_root,"txtCountDown_SceneRuneLockDraw",WZUILabelTTF)
	local txtCountDown2 = getElement(self.m_root,"txtCountDown2_SceneRuneLockDraw",WZUILabelTTF)
	local txtTip3 = getElement(self.m_root,"txtTip3_SceneRuneLockDraw",WZUILabelTTF)
	local imgRed1 = getElement(self.m_root,"imgRed1_SceneRuneLockDraw",WZUIImage)
	if bFree then
	    txtCountDown:setText("")
	    txtCountDown2:setVisible(false)
	    txtTip3:setText(LocalStrings.PETFREE2)
	    imgRed1:setVisible(true)
	end
end

function SceneRuneLockDraw:updateDrawTip()
	WZLog("SceneRuneLockDraw:updateDrawTip")
	local getElement = GetElement
	local txtDrawBuyGold = getElement(self.m_root,"txtDrawBuyGold_SceneRuneLockDraw",WZUILabelTTF)
	local txtDrawBuyDiamond = getElement(self.m_root,"txtDrawBuyDiamond_SceneRuneLockDraw",WZUILabelTTF)

	local temp1 = string.format(LocalStrings.LUCK_DRAW_TIP3,self.m_ntype0STimes)
	txtDrawBuyGold:setText(temp1)
	local temp2 = string.format(LocalStrings.LUCK_DRAW_TIP4,self.m_ntype1STimes)
	txtDrawBuyDiamond:setText(temp2)
end


function SceneRuneLockDraw:onClickNext(element)
	WZLog("SceneRuneLockDraw:onClickNext")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local getElement = GetElement
	local conCenter = getElement(self.m_root,"conCenter_SceneRuneLockDraw",WZUIContainer)
	local conDrawTip = getElement(self.m_root,"conDrawTip_SceneRuneLockDraw",WZUIContainer)
	local conDrawTip2 = getElement(self.m_root,"conDrawTip2_SceneRuneLockDraw",WZUIContainer)
	local conDraw = getElement(self.m_root,"conDraw_SceneRuneLockDraw",WZUIContainer)
	local conBtn = getElement(self.m_root,"conBtn_SceneRuneLockDraw",WZUIContainer)
	conCenter:setVisible(true)
	conDrawTip:setVisible(false)
	conDrawTip2:setVisible(false)
	conDraw:setVisible(true)
	conBtn:setVisible(true)
	self.m_tTopHangle:setTopTouchEnable(true)
	local conDrawItem = nil
	for i=1,10 do
		conDrawItem = getElement(conDrawTip2,"conDrawItem" .. i .. "_SceneRuneLockDraw",WZUIContainer)
		conDrawItem:setVisible(false)
	end
	for i=1,10 do
		conDrawItem = getElement(conDraw,"conDrawItem" .. i .. "_SceneRuneLockDraw",WZUIContainer)
		conDrawItem:setVisible(false)
	end
	local conDrawItem = getElement(conDrawTip,"conDrawItem_SceneRuneLockDraw",WZUIContainer)
	conDrawItem:setVisible(false)
	self.m_tDrawItemId = nil
    self.m_tDrawItemNum = nil
end

--显示抽奖成功的物品
function SceneRuneLockDraw:showDrawItem(itemIds,itemNums)
	WZLog("SceneRuneLockDraw:showDrawItem")
	local getElement = GetElement
	local conDrawTip = getElement(self.m_root,"conDrawTip_SceneRuneLockDraw",WZUIContainer)
	local conCenter = getElement(self.m_root,"conCenter_SceneRuneLockDraw",WZUIContainer)
	local conDraw = getElement(self.m_root,"conDraw_SceneRuneLockDraw",WZUIContainer)
	local conBtn = getElement(self.m_root,"conBtn_SceneRuneLockDraw",WZUIContainer)
	local conDrawTip2 = getElement(self.m_root,"conDrawTip2_SceneRuneLockDraw",WZUIContainer)
	conCenter:setVisible(false)
	conDraw:setVisible(false)
	conBtn:setVisible(false)
	if #itemIds <= 1 then
		conDrawTip:setVisible(true)
		local conDrawItem = getElement(conDrawTip,"conDrawItem_SceneRuneLockDraw",WZUIContainer)
		conDrawItem:setVisible(true)
		local imgRune = getElement(conDrawItem,"imgRune_SceneRuneLockDraw",WZUIImage)
		local txtRuneName = getElement(conDrawItem,"txtRuneName_SceneRuneLockDraw",WZUILabelTTF)
		local itemInfo = GDatatab_item["id_" .. itemIds[1]]
		for i,v in ipairs(itemInfo.property) do
			getElement(conDrawItem,"txt" .. i .. "_SceneRuneLockDraw",WZUILabelTTF):setText(ATTR_TITLE[v[1]])
			getElement(conDrawItem,"txtV" .. i .. "_SceneRuneLockDraw",WZUILabelTTF):setText("+" .. v[2])
			if ProjConfig.LANGUAGE == "vn" then
				getElement(conDrawItem,"txt" .. i .. "_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.636,1.111111-i*0.29))
				getElement(conDrawItem,"txtV" .. i .. "_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.65,1.111111-i*0.29))
			end
		end
		txtRuneName:setColor(QUALITYCOLOR[itemInfo.quality])
		txtRuneName:setText(itemInfo.name)
		imgRune:setFile(itemInfo.icon)
	else
		conDrawTip2:setVisible(true)
		local conDrawItem = nil
		for i,v in ipairs(itemIds) do
			conDrawItem = getElement(conDrawTip2,"conDrawItem" .. i .. "_SceneRuneLockDraw",WZUIContainer)
			conDrawItem:setVisible(true)
			local imgRune = getElement(conDrawItem,"imgRune_SceneRuneLockDraw",WZUIImage)
		    local txtRuneName = getElement(conDrawItem,"txtRuneName_SceneRuneLockDraw",WZUILabelTTF)
		    local itemInfo = GDatatab_item["id_" .. itemIds[i]]
		    for i,v in ipairs(itemInfo.property) do
				getElement(conDrawItem,"txt" .. i .. "_SceneRuneLockDraw",WZUILabelTTF):setText(ATTR_TITLE[v[1]])
				getElement(conDrawItem,"txtV" .. i .. "_SceneRuneLockDraw",WZUILabelTTF):setText("+" .. v[2])
				if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" then
					getElement(conDrawItem,"txt" .. i .. "_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.636,1.111111-i*0.29))
					getElement(conDrawItem,"txtV" .. i .. "_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.65,1.111111-i*0.29))
				end
			end
			txtRuneName:setColor(QUALITYCOLOR[itemInfo.quality])
			txtRuneName:setText(itemInfo.name)
			imgRune:setFile(itemInfo.icon)
			if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
				txtRuneName:setScale(0.8)
			end
		end
	end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function SceneRuneLockDraw:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtDrawBuyGold_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtDrawBuyDiamond_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtCountDown2_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.52,0.13722))
	for i=1,4 do
		GetElement(self.m_root,"txtBtn"..i.."_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)
	end

	GetElement(self.m_root,"txtOneG1_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtOneG2_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)
	-- GetElement(self.m_root,"txtOneD1_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)
	-- GetElement(self.m_root,"txtOneD2_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)
	local txtDrawCountTip1 = GetElement(self.m_root,"txtDrawCountTip1_SceneRuneLockDraw",WZUILabelTTF)
	txtDrawCountTip1:setScale(0.7)
	local txtDrawCountTip2 = GetElement(self.m_root,"txtDrawCountTip2_SceneRuneLockDraw",WZUILabelTTF)
	txtDrawCountTip2:setScale(0.7)
	local freeTextDraw1 = GetElement(self.m_root,"freeTextDraw1_SceneRuneLockDraw",WZUIFreeTextBox)
	freeTextDraw1:setMaxWidth(400)
    local freeTextDraw2 = GetElement(self.m_root,"freeTextDraw2_SceneRuneLockDraw",WZUIFreeTextBox)
    freeTextDraw2:setMaxWidth(400)
end

function SceneRuneLockDraw:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtEquip_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCountDown2_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.43,0.13722))
end

function SceneRuneLockDraw:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtDrawBuyGold_SceneRuneLockDraw",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtDrawBuyDiamond_SceneRuneLockDraw",WZUILabelTTF):setScale(0.6)
	
	GetElement(self.m_root,"txtCountDown2_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.573958,0.13722))

	for i=1,4 do
		GetElement(self.m_root,"txtBtn"..i.."_SceneRuneLockDraw",WZUILabelTTF):setScale(0.8)
	end

	for i=1,2 do
		GetElement(self.m_root,"txtDrawCountTip"..i.."_SceneRuneLockDraw",WZUILabelTTF):setScale(0.7)
	end
end

function SceneRuneLockDraw:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtDrawBuyGold_SceneRuneLockDraw",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtDrawBuyDiamond_SceneRuneLockDraw",WZUILabelTTF):setScale(0.6)
	
	GetElement(self.m_root,"txtCountDown_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.693032,0.13722))
	GetElement(self.m_root,"txtCountDown2_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.27245,0.13722))

	for i=1,4 do
		GetElement(self.m_root,"txtBtn"..i.."_SceneRuneLockDraw",WZUILabelTTF):setScale(0.7)
	end

	for i=1,2 do
		GetElement(self.m_root,"txtDrawCountTip"..i.."_SceneRuneLockDraw",WZUILabelTTF):setScale(0.7)
	end
end

function SceneRuneLockDraw:_adaptLanguage_th( )
	local txtDrawCountTip1 = GetElement(self.m_root,"txtDrawCountTip1_SceneRuneLockDraw",WZUILabelTTF)
	txtDrawCountTip1:setScale(0.8)
	local txtDrawCountTip2 = GetElement(self.m_root,"txtDrawCountTip2_SceneRuneLockDraw",WZUILabelTTF)
	txtDrawCountTip2:setScale(0.8)
end

function SceneRuneLockDraw:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtDrawBuyGold_SceneRuneLockDraw",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtDrawBuyDiamond_SceneRuneLockDraw",WZUILabelTTF):setScale(0.7)

	local txtDrawCountTip1 = GetElement(self.m_root,"txtDrawCountTip1_SceneRuneLockDraw",WZUILabelTTF)
	txtDrawCountTip1:setDimensions(GlobalMethod:CCSize(100))
	local txtDrawCountTip2 = GetElement(self.m_root,"txtDrawCountTip2_SceneRuneLockDraw",WZUILabelTTF)
	txtDrawCountTip2:setDimensions(GlobalMethod:CCSize(100))

	GetElement(self.m_root,"txtEquip_SceneRuneLockDraw",WZUILabelTTF):setScale(0.7)
	
	GetElement(self.m_root,"txtCountDown2_SceneRuneLockDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.643569,0.13722))
end
-------------------------------------语言适配End--------------------------------------------