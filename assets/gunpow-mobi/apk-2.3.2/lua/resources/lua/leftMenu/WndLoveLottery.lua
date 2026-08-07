--WndLoveLottery.lua
--@brief	WndLoveLottery的UI模块
--@date		2015/04/02
--@author	qixiang_xie
--@note		爱心许愿
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLoveLottery:onEnter(element)
    WZLog("WndLoveLottery:onEnter")
	self.m_root = element

	self:_setLocalText()
	ChangeChatChannel(Chat_Channel_Lottery)
	ProtocolProcessorFestivalActivity:regAll6()	--注册协议
	
	--从缓存中心获得物品列表
    GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result, self._onGetLoveLotteryResult, self)

	self.m_ncount =1
    self:_updateTable()
    self:_setTime()

    --设置许愿按钮可点击
    self:setBtnLotteryEnable(true)

    self.m_nRewardId = 2
	CacheCenter:registerUpatePlayerItemObserver(self)
	AdaptLanguage(self)

    SendBusinessCode(BUSINESSCODE_STATICVALUE + self.m_nActivityType, 2, true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLoveLottery:onExit(element)
	WZLog("WndLoveLottery:onExit -----")
    GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result, self._onGetLoveLotteryResult, self)

    CacheCenter:updateMoneyData()
	CacheCenter:setUpdateNewStatus(false)

	self.m_root:disableSchedule()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
    Teach:isStartTeach("WndLoveLottery:onExit")
	ProtocolProcessorFestivalActivity:unregAll()
end

--@brief	退出爱心许愿响应函数
--@param	element:表绑定的UI节点引用
function WndLoveLottery:onCloseClick(element)
	WZLog("WndLoveLottery:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WindowManager:removeWindow(self.m_root , WndLoveLottery , true)
end

--@brief    onenter函数已执行
function WndLoveLottery:onEnterTransitionDidFinish(element)
    WZLog("WndLoveLottery:onEnterTransitionDidFinish")
end

--@brief  幸运抽奖奖品列表
function WndLoveLottery:_updateTable()
	WZLog("WndLoveLottery:_updateTable")
    if self.m_root == nil then
		WZLog("WndLoveLottery root is nil")
		return
	end
    local count = #self.m_tGiftName
    local conPrize = nil
    self.m_root:disableSchedule()

    -- self:updateDrawPrice()
	for i=1,10 do
		local cellElement,tCell = self:_createCellGoodItem(i,self.m_tGiftId[i],self.m_tGiftNum[i])
		WZLog("SceneLottery:self.m_tGiftId[i]",self.m_tGiftId[i])
		local icon = self.m_tGiftIcon[i]
		conPrize = self.m_root:getChildElement("conPrize"..i.."_WndLoveLottery")
        if i > 8 then 
            GetElement(conPrize, "conUnusual_WndLoveLottery", WZUIContainer):setVisible(true)
        end
		conPrize:addChild(cellElement)
    end
    
    self.m_isShowCellLotteryList = false
end

-- function WndLoveLottery:updateDrawPrice()
-- 	-- body
-- 	WZLog("WndLoveLottery:updateDrawPrice", type(self.m_nSendGold))
-- 	local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndLoveLottery",WZUILabelTTF)
-- 	local txtPrice = GetElement(self.m_root,"txtPrice_WndLoveLottery",WZUILabelTTF)
--     local diamonds = self.m_nPrice
--     local gold = self.m_nSendGold
--     local drawCount = 1
--     local imgCostType = GetElement(self.m_root,"imgCostType_WndLoveLottery",WZUIImage)
-- 	local icon = GDatatab_item["id_" .. self.m_nCostType].icon
-- 	imgCostType:setFile(icon)

--     if self.m_bTenTakeOut then
--     	diamonds = diamonds * 10
--     	gold = gold * 10
--     	drawCount = 10
--     end
--     --DRAW_LUCKY_TIP = "买%d金币\n(送转盘%d次)",
--     txtPrice:setText(diamonds)
--     local tempS = string.format(LocalStrings.DRAW_LUCKY_TIP,gold,drawCount)
--     txtDrawTip:setText(tempS)
-- end

--@brief    创建一个物品格子
--@param    nIndex，序号
function WndLoveLottery:_createCellGoodItem(nIndex,itemId,itemCount)
	WZLog("WndLoveLottery:_createCellGoodItem =",nIndex,itemId,itemCount)
    local eItem, tItem = CellGoodItem:createElement()
    --eItem:setScale(0.3)
    tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(WndLoveLottery, WndLoveLottery.onClickItem) 
    if itemId then
        local tData = {
            id = itemId,
            lastNum = itemCount,
            lastTime = itemCount,
			customizeLastTime = itemCount,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(itemId)
        }
		local main_type = GDatatab_item["id_"..itemId].main_type
		if main_type == 5 then
            tData.customizeLastTime = tData.lastTime *86400
        	tItem:setCellGoodItem(tData, 16)
		else
        	tItem:setCellGoodItem(tData, 4)
		end
        tItem:clearItemQualityPic(true)
    end
    return eItem, tItem
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndLoveLottery:onClickItem(tItem, nTag, tData)
    WZLog("WndLoveLottery:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,WndGameActivity.m_root,1,tData, false)
end

function WndLoveLottery:_setTime()
	WZLog("WndLoveLottery:_setTime")
	
	local txtStartTime =  GetElement(self.m_root,"txtStartTime_WndLoveLottery",WZUILabelTTF)
	local txtEndTime =  GetElement(self.m_root,"txtEndTime_WndLoveLottery",WZUILabelTTF)

	local strStartTime = nil
	local strEndTime = nil

    
	strStartTime =  os.date("%Y-%m-%d",math.floor(self.m_sStartTime)) 
	strEndTime =  os.date("%m-%d",math.floor(self.m_sEndTime))
	if ProjConfig.LANGUAGE == "vn" then
		strStartTime =  os.date("%d-%m-%Y",math.floor(self.m_sStartTime)) 
		strEndTime =  os.date("%d-%m",math.floor(self.m_sEndTime))
	end 
	
	txtStartTime:setText(strStartTime)
	txtEndTime:setText(LocalStrings.UNITY .. strEndTime)
end

--@brief  抽奖cell高亮
--@param  curCellIndex:需要高亮的cell
--@node   此方法也做了旋转速度控制
--@node   播放方式是(慢、中、快、慢)
function WndLoveLottery:_setHighlightCell(curCellIndex)
	WZLog("WndLoveLottery:_setHighlightCell ")
	local tempIndex = self.m_nStartPs + 1
	if tempIndex > 10 then
		tempIndex = 1
		self.m_nStartPs = 0
	end

    local conPrize =  GetElement(self.m_root,"conPrize" .. tempIndex .. "_WndLoveLottery")
    GetElement(conPrize,"conComm_WndLoveLottery",WZUIContainer):setVisible(false)
    GetElement(conPrize,"conSel_WndLoveLottery",WZUIContainer):setVisible(true)

    local tag = conPrize:getTag()
    local beforeIndex = tag - 1
    if tag == 1 then
    	beforeIndex = 10
    end
    
    conPrize =  GetElement(self.m_root,"conPrize" .. beforeIndex .. "_WndLoveLottery")
    GetElement(conPrize,"conComm_WndLoveLottery",WZUIContainer):setVisible(true)
    GetElement(conPrize,"conSel_WndLoveLottery",WZUIContainer):setVisible(false)

    if self.m_nid >= 10 then
    	self.m_curCircle = self.m_curCircle + 1
    	self.m_nid = 1
    else
    	self.m_nid = self.m_nid + 1
    end
    self.m_nStartPs = self.m_nStartPs + 1

    SoundManager:playEffectSound(SoundDefine.E_S_LOVELOTTERY_SHAO)
	if self.m_curCircle >=4 and tag == self.m_nRewardId then
		self.m_root:disableSchedule()
		self.m_bRaffling = false
		self.m_nid = 1
	    self.m_temrRecord = 0
        self.m_curCircle = 1
        self.m_nStartPs = self.m_nRewardId
        self.m_ncount = self.m_nRewardId
        CacheCenter:updateMoneyData()
        CacheCenter:setUpdateNewStatus(false)
        if GlobalGame.g_bFightRage then  
        	upPlayerFightingAni()
        end
        self:showPrize()
	end
end

--@brief  显示抽奖到的奖品
function WndLoveLottery:showPrize()
	WZLog("WndLoveLottery:showPrize")
	local tItemId ={}
	local tItemCount = {}
	for i,v in ipairs(self.m_tItemList) do
		table.insert(tItemId,v)
	end
	for i,v in ipairs(self.m_tItemNumList) do
		table.insert(tItemCount,v)
	end

	self.m_sPrizeId = tItemId   
    self.m_sPrizeCount = tItemCount       
	WndRewardShow:showById(self.m_sPrizeId,self.m_sPrizeCount)
    --展示奖励时候才刷新保底进度
    CellLoveLotteryBox:setData(CellLoveLotteryBox.m_nCurTimes, nil, true)
	self.m_sPrizeId = nil
	self.m_sPrizeCount = nil
	self:setBtnLotteryEnable(true)
    --弹穿上或打开提示框
    pushEquipInList()
    CacheCenter:updateMoneyData()
    CacheCenter:setUpdateNewStatus(false)
    if GlobalGame.g_bFightRage then  
    	upPlayerFightingAni()
    end
    self.m_tItemList = nil
    self.m_tItemNumList = nil
end

--@brief  设置许愿按钮点击状态
--@param  bTouchEnable:true可点击，false不可点击
function WndLoveLottery:setBtnLotteryEnable(bTouchEnable)
	local btnLottery1 = self.m_root:getChildElement("btnLottery1_WndLoveLottery")
	if btnLottery1 ~= nil then
	    btnLottery1 = WZUIButton:luaTo(btnLottery1)
	    btnLottery1:setTouchEnable(bTouchEnable)
	end
    local btnLottery10 = self.m_root:getChildElement("btnLottery10_WndLoveLottery")
    if btnLottery10 ~= nil then
        btnLottery10 = WZUIButton:luaTo(btnLottery10)
        btnLottery10:setTouchEnable(bTouchEnable)
    end
end

--十连抽
-- function WndLoveLottery:onClickTen(element)
-- 	local cbTen = GetElement(self.m_root,"cbTen_WndLoveLottery",WZUICheckBox)
-- 	local checkIndex = cbTen:getCheckIndex()
-- 	WZLog("WndLoveLottery:onClickTen = ",checkIndex)
-- 	if checkIndex > 0 then
-- 	    self.m_bTenTakeOut = true
-- 	else
-- 		self.m_bTenTakeOut = false
-- 	end
-- 	-- self:updateDrawPrice()
-- end

--@brief    前往vip充值
function WndLoveLottery:_EventToVIP( nId, nResType )
    WZLog("WndLoveLottery:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndVip:showWndUI(0)
    end
end

--@brief  点击许愿按钮时触发
--@param  element，触发该事件的界面元素
function WndLoveLottery:onClickRaffle(element)
    local tag = tonumber(element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if tag == 10 then
        self.m_bTenTakeOut = true
    else
        self.m_bTenTakeOut = false
    end
    MsgBoxManager:showConfirmBoxWithBg(LocalStrings.ACTIVITY_BUY_SECOND, self, self.toContinue, nil, nil, "WndLoveLottery" .. self.m_nCostType)
end

--@brief    继续抽奖
function WndLoveLottery:toContinue()
    -- body
    local count =  CacheCenter:getRemainAmount()
    if count <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    if self.m_nLoadingId ~= nil and self.m_nLoadingId > 0 then
        WZLog("WndLoveLottery:access to the net")
        return
    end

    local totalCost = 1
    if self.m_bTenTakeOut then
        totalCost = 10
    end
    if not JudgeMoneyIsEnough(self.m_nCostType, totalCost * self.m_nPrice, nil, nil, 126, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
        return
    end
    
    self:sureToUseDiamondInstead()
end

--@brief    确认用钻石代替礼券抽奖
function WndLoveLottery:sureToUseDiamondInstead()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    CacheCenter:setUpdateNewStatus(true)
    local lotteryNum = 1
    if self.m_bTenTakeOut then
        lotteryNum = 10
    end
    local tData = {}
    tData.lotteryNum = lotteryNum
    local sMsg = json.encode(tData)
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, sMsg)
end

--@brief  触发定时回调函数
--@param  element，触发该函数的元素
function WndLoveLottery:_scheduleSetCellState(element,detal)
   self.m_temrRecord = self.m_temrRecord + 1
    local bRun = false
    if self.m_curCircle == 1 then --第一圈
       if self.m_temrRecord > 1   then
       	    bRun = true
       end
    elseif self.m_curCircle > 1 and self.m_curCircle < 3 and  self.m_temrRecord >1 then --第二圈
    	bRun = true
    elseif self.m_curCircle >=3 and self.m_curCircle < 4 then --第三圈
		if self.m_temrRecord > 3  then
			bRun = true
		end
    else
    	if self.m_temrRecord >= 10  then
    		bRun = true
		end
    end
    if bRun then
    	self:_setHighlightCell(self.m_nid)
        self.m_temrRecord = 0
    end
end

--@brief  点击弹出的确认购买时触发的函数
--@param  nType，按钮类型，关闭，取消，确定
--@param  nId，按钮id
function WndLoveLottery:clickSureBack(nId,nType)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if nType == MSGBOXRESTYPE_CONFIRM then
    	 PassportSdkManager:gotoPaymentPage()
	end
end

--@brief 显示购买爱心框
function WndLoveLottery:showWndPurchase(element,detal)
	element:disableSchedule()
	WndPurchase:showBuyInterface(6,116,WndLoveLottery,self.BuyOK,nil)
end

--@brief  购买爱心成功回调
function WndLoveLottery:BuyOK()
	WZLog("WndLoveLottery:BuyOK")
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置本地界面文本
function WndLoveLottery:_setLocalText()
	WZLog("WndLoveLottery:_setLocalText")

	self.txtPrice1_WndLoveLottery = GetElement(self.m_root,"txtPrice1_WndLoveLottery",WZUILabelTTF)
    self.txtPrice1_WndLoveLottery:setText(self.m_nPrice)
    self.txtPrice10_WndLoveLottery = GetElement(self.m_root,"txtPrice10_WndLoveLottery",WZUILabelTTF)
    self.txtPrice10_WndLoveLottery:setText(self.m_nPrice*10)

    local icon = GDatatab_item["id_" .. self.m_nCostType].icon    
    self.imgCostType1_WndLoveLottery = GetElement(self.m_root,"imgCostType1_WndLoveLottery",WZUIImage)
    self.imgCostType1_WndLoveLottery:setFile(icon)
    self.imgCostType10_WndLoveLottery = GetElement(self.m_root,"imgCostType10_WndLoveLottery",WZUIImage)
    self.imgCostType10_WndLoveLottery:setFile(icon)

    local gainGold = tonumber(CacheCenter:getGameParam().luckyLotteryGainGold)
    self.txtDrawTip1_WndLoveLottery = GetElement(self.m_root,"txtDrawTip1_WndLoveLottery",WZUILabelTTF)
    local tempS = string.format(LocalStrings.DRAW_LUCKY_TIP,gainGold,1)
    self.txtDrawTip1_WndLoveLottery:setText(tempS)
    self.txtDrawTip10_WndLoveLottery = GetElement(self.m_root,"txtDrawTip10_WndLoveLottery",WZUILabelTTF)
    tempS = string.format(LocalStrings.DRAW_LUCKY_TIP,gainGold*10,10)
    self.txtDrawTip10_WndLoveLottery:setText(tempS)

    self.btnLuckCountLabel1 = GetElement(self.m_root,"btnLuckCountLabel1",WZUILabelTTF)
    self.btnLuckCountLabel1:setText(string.format(LocalStrings.NEW_ACTIVITY_TEXT_5,1))
    self.btnLuckCountLabel10 = GetElement(self.m_root,"btnLuckCountLabel10",WZUILabelTTF)
    self.btnLuckCountLabel10:setText(string.format(LocalStrings.NEW_ACTIVITY_TEXT_5,10))
end


function WndLoveLottery:onTouchBegan()
	WZLog("WndLoveLottery:onTouchBegan")
	WndItemInfo:onCloseClick()
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndLoveLottery:_adaptLanguage_cn(  )
	GetElement(self.m_root,"txtEndTime_WndLoveLottery",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.3,-0.00229095))
end

function WndLoveLottery:_adaptLanguage_vn(  )
    local txtDrawTip1 = GetElement(self.m_root,"txtDrawTip1_WndLoveLottery",WZUILabelTTF)
    txtDrawTip1:setScale(0.7)
    txtDrawTip1:setDimensions(GlobalMethod:CCSize(170))

    local txtDrawTip10 = GetElement(self.m_root,"txtDrawTip10_WndLoveLottery",WZUILabelTTF)
    txtDrawTip10:setScale(0.7)
    txtDrawTip10:setDimensions(GlobalMethod:CCSize(170))
end

function WndLoveLottery:_adaptLanguage_en(  )
	local txtDrawTip1 = GetElement(self.m_root,"txtDrawTip1_WndLoveLottery",WZUILabelTTF)
    txtDrawTip1:setScale(0.7)
    txtDrawTip1:setDimensions(GlobalMethod:CCSize(160,0))

    local txtDrawTip10 = GetElement(self.m_root,"txtDrawTip10_WndLoveLottery",WZUILabelTTF)
    txtDrawTip10:setScale(0.7)
    txtDrawTip10:setDimensions(GlobalMethod:CCSize(160,0))
end

function WndLoveLottery:_adaptLanguage_tr()
    local txtDrawTip1 = GetElement(self.m_root,"txtDrawTip1_WndLoveLottery",WZUILabelTTF)
    txtDrawTip1:setScale(0.7)
    txtDrawTip1:setDimensions(GlobalMethod:CCSize(160,0))

    local txtDrawTip10 = GetElement(self.m_root,"txtDrawTip10_WndLoveLottery",WZUILabelTTF)
    txtDrawTip10:setScale(0.7)
    txtDrawTip10:setDimensions(GlobalMethod:CCSize(160,0))
end

function WndLoveLottery:_adaptLanguage_es(  )
    local txtDrawTip1 = GetElement(self.m_root,"txtDrawTip1_WndLoveLottery",WZUILabelTTF)
    txtDrawTip1:setScale(0.6)
    txtDrawTip1:setDimensions(GlobalMethod:CCSize(180,0))

    local txtDrawTip10 = GetElement(self.m_root,"txtDrawTip10_WndLoveLottery",WZUILabelTTF)
    txtDrawTip10:setScale(0.6)
    txtDrawTip10:setDimensions(GlobalMethod:CCSize(180,0))
end

function WndLoveLottery:_adaptLanguage_th()
    local txtDrawTip1 = GetElement(self.m_root,"txtDrawTip1_WndLoveLottery",WZUILabelTTF)
    txtDrawTip1:setScale(0.7)
    txtDrawTip1:setDimensions(GlobalMethod:CCSize(160,0))

    local txtDrawTip10 = GetElement(self.m_root,"txtDrawTip10_WndLoveLottery",WZUILabelTTF)
    txtDrawTip10:setScale(0.7)
    txtDrawTip10:setDimensions(GlobalMethod:CCSize(160,0))
end

function WndLoveLottery:_adaptLanguage_pt(  )
    local txtDrawTip1 = GetElement(self.m_root,"txtDrawTip1_WndLoveLottery",WZUILabelTTF)
    txtDrawTip1:setScale(0.7)
    txtDrawTip1:setDimensions(GlobalMethod:CCSize(160,0))

    local txtDrawTip10 = GetElement(self.m_root,"txtDrawTip10_WndLoveLottery",WZUILabelTTF)
    txtDrawTip10:setScale(0.7)
    txtDrawTip10:setDimensions(GlobalMethod:CCSize(160,0))
end
-------------------------------------语言适配End--------------------------------------------
