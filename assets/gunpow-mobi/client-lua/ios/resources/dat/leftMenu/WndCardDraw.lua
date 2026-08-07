--WndCardDraw.lua
--@brief	WndCardDraw的UI模块
--@date		2015/04/02
--@author	qixiang_xie
--@note		爱心许愿
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCardDraw:onEnter(element)
    WZLog("WndCardDraw:onEnter")
	self.m_root = element
	
	self:_setLocalText()
	ChangeChatChannel(Chat_Channel_Lottery)
	ProtocolProcessorSceneLottery:regAll()	--注册协议
	
	-- --从缓存中心获得物品列表
    ProtocolProcessorSceneLottery:send_ACTIVITY_GetCardLotteryInfo()
    -- self:_updateTable()

    --设置许愿按钮可点击
    self:setBtnLotteryEnable(true)

	CacheCenter:registerUpatePlayerItemObserver(self)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCardDraw:onExit(element)
	WZLog("WndCardDraw:onExit -----")
    CacheCenter:updateMoneyData()
	CacheCenter:setUpdateNewStatus(false)

	self.m_root:disableSchedule()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
    Teach:isStartTeach("WndCardDraw:onExit")
	ProtocolProcessorSceneLottery:unregAll()
end

--@brief	退出爱心许愿响应函数
--@param	element:表绑定的UI节点引用
function WndCardDraw:onCloseClick(element)
	WZLog("WndCardDraw:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end

--@brief    弹窗动画完成后的回调
function WndCardDraw:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root , WndCardDraw , true)
end

--@brief    onenter函数已执行
function WndCardDraw:onEnterTransitionDidFinish(element)
    WZLog("WndCardDraw:onEnterTransitionDidFinish")
    --弹窗动画
    --WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndCardDraw:actionCallback(element, data)
    
end

--@brief  幸运抽奖奖品列表
function WndCardDraw:_updateTable()
	WZLog("WndCardDraw:_updateTable")
    if self.m_root == nil then
		WZLog("WndCardDraw root is nil")
		return
	end
    local conPrize = nil
    self.m_root:disableSchedule()

    self:updateDrawPrice()
  
	for i=1,8 do
		local cellElement,tCell = self:_createCellGoodItem(i,self.m_tGiftId[i],self.m_tGiftNum[i])
		WZLog("SceneLottery:self.m_tGiftId[i]",self.m_tGiftId[i])
		conPrize = self.m_root:getChildElement("conPrize"..i.."_WndCardDraw")
		conPrize:addChild(cellElement)
    end
    
    self.m_isShowCellLotteryList = false
end

function WndCardDraw:updateDrawPrice()
	-- body
	WZLog("WndCardDraw:updateDrawPrice")
	local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
	local txtPrice = GetElement(self.m_root,"txtPrice_WndCardDraw",WZUILabelTTF)
    local diamonds = self.m_nPrice
    local gold = self.m_nSendGold
    local drawCount = 1
    local imgCostType = GetElement(self.m_root,"imgCostType_WndCardDraw",WZUIImage)
	local icon = GDatatab_item["id_" .. self.m_nCostType].icon
	imgCostType:setFile(icon)

    if self.m_bTenTakeOut then
    	diamonds = diamonds * 10
    	gold = gold * 10
    	drawCount = 10
    end
    txtPrice:setText(diamonds)
    local tempS = string.format(LocalStrings.DRAW_LUCKY_TIP,gold,drawCount)
    txtDrawTip:setText(tempS)
end

--@brief    创建一个物品格子
--@param    nIndex，序号
function WndCardDraw:_createCellGoodItem(nIndex,itemId,itemCount)
	WZLog("WndCardDraw:_createCellGoodItem =",nIndex,itemId,itemCount)
    local eItem, tItem = CellGoodItem:createElement()
    --eItem:setScale(0.3)
    tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(WndCardDraw, WndCardDraw.onClickItem)
    if itemId then
        local tData = {
            id = nItemId,
            lastNum = itemCount,
            lastTime = itemCount,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(itemId)
        }
        tItem:setCellGoodItem(tData, 2)
    end
    return eItem, tItem
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndCardDraw:onClickItem(tItem, nTag, tData)
    WZLog("WndCardDraw:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--@brief  抽奖cell高亮
--@param  curCellIndex:需要高亮的cell
--@node   此方法也做了旋转速度控制
--@node   播放方式是(慢、中、快、慢)
function WndCardDraw:_setHighlightCell(curCellIndex)
	WZLog("WndCardDraw:_setHighlightCell ")
	local tempIndex = self.m_nStartPs + 1
	if tempIndex > 8 then
		tempIndex = 1
		self.m_nStartPs = 0
	end

    local conPrize =  GetElement(self.m_root,"conPrize" .. tempIndex .. "_WndCardDraw")
    GetElement(conPrize,"conComm_WndCardDraw",WZUIContainer):setVisible(false)
    GetElement(conPrize,"conSel_WndCardDraw",WZUIContainer):setVisible(true)

    local tag = conPrize:getTag()
    local beforeIndex = tag - 1
    if tag == 1 then
    	beforeIndex = 8
    end
    
    conPrize =  GetElement(self.m_root,"conPrize" .. beforeIndex .. "_WndCardDraw")
    GetElement(conPrize,"conComm_WndCardDraw",WZUIContainer):setVisible(true)
    GetElement(conPrize,"conSel_WndCardDraw",WZUIContainer):setVisible(false)

    if self.m_nid >= 8 then
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
function WndCardDraw:showPrize()
	WZLog("WndCardDraw:showPrize")
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
function WndCardDraw:setBtnLotteryEnable(bTouchEnable)
	local btnLottery = self.m_root:getChildElement("btnLottery_WndCardDraw")
	if btnLottery~=nil then
	    btnLottery = WZUIButton:luaTo(btnLottery)
	    btnLottery:setTouchEnable(bTouchEnable)
	end
end

--十连抽
function WndCardDraw:onClickTen(element)
	local cbTen = GetElement(self.m_root,"cbTen_WndCardDraw",WZUICheckBox)
	local checkIndex = cbTen:getCheckIndex()
	WZLog("WndCardDraw:onClickTen = ",checkIndex)
	if checkIndex > 0 then
	    self.m_bTenTakeOut = true
	else
		self.m_bTenTakeOut = false
	end
	self:updateDrawPrice()
end

--@brief    前往vip充值
function WndCardDraw:_EventToVIP( nId, nResType )
    WZLog("WndCardDraw:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndVip:showWndUI(0)
    end
end

--@brief   设置爱心数量和钻石数量
function WndCardDraw:_setData()
	WZLog("WndCardDraw:_setData")
	local imgCostType = GetElement(self.m_root,"imgCostType_WndCardDraw",WZUIImage)
	local icon = GDatatab_item["id_" .. self.m_nCostType].icon
	imgCostType:setFile(icon)

	local txtPrice = GetElement(self.m_root,"txtPrice_WndCardDraw",WZUILabelTTF)
	txtPrice:setText(self.m_nPrice)
end

--@brief  点击许愿按钮时触发
--@param  element，触发该事件的界面元素
function WndCardDraw:onClickRaffle(element)
	WZLog("WndCardDraw:onClickRaffle loveNum ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    MsgBoxManager:showConfirmBoxWithBg(LocalStrings.ACTIVITY_BUY_SECOND, self, self.toContinue, nil, nil, "WndCardDraw" .. self.m_nCostType)
end

--@brief    继续购买
function WndCardDraw:toContinue()
    -- body
    local count =  CacheCenter:getRemainAmount()
    if count <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    if self.m_nLoadingId ~= nil and self.m_nLoadingId > 0 then
        WZLog("WndCardDraw:access to the net")
        return
    end

    local totalCost = self.m_nPrice
    if self.m_bTenTakeOut then
        totalCost = self.m_nPrice * 10
    end
    if not JudgeMoneyIsEnough(self.m_nCostType, totalCost, nil, nil, 126, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
        return
    end
    
    self:sureToUseDiamondInstead()
end

--@brief    确认用钻石代替礼券抽奖
function WndCardDraw:sureToUseDiamondInstead()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    CacheCenter:setUpdateNewStatus(true)
    local rewardType = 0
    if self.m_bTenTakeOut then
        rewardType = 1
    end
    ProtocolProcessorSceneLottery:send_ACTIVITY_CardLottery(rewardType)
end

--@brief  触发定时回调函数
--@param  element，触发该函数的元素
function WndCardDraw:_scheduleSetCellState(element,detal)
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
    	if self.m_temrRecord >= 8  then
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
function WndCardDraw:clickSureBack(nId,nType)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if nType == MSGBOXRESTYPE_CONFIRM then
    	 PassportSdkManager:gotoPaymentPage()
	end
end

--@brief 显示购买爱心框
function WndCardDraw:showWndPurchase(element,detal)
	element:disableSchedule()
	WndPurchase:showBuyInterface(6,116,WndCardDraw,self.BuyOK,nil)
end

--@brief  购买爱心成功回调
function WndCardDraw:BuyOK()
	WZLog("WndCardDraw:BuyOK")
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置本地界面文本
function WndCardDraw:_setLocalText()
	WZLog("WndCardDraw:_setLocalText")
	
end


function WndCardDraw:onTouchBegan()
	WZLog("WndCardDraw:onTouchBegan")
	WndItemInfo:onCloseClick()
end

-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndCardDraw:_adaptLanguage_vn(  )
    local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
    txtDrawTip:setScale(0.8)
    txtDrawTip:setDimensions(GlobalMethod:CCSize(140))
end

function WndCardDraw:_adaptLanguage_th()
    WZLog("WndCardDraw:_adaptLanguage_th ")
    GetElement(self.m_root,"cbTen_WndCardDraw",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.479311,0.5))
    GetElement(self.m_root,"txtTenT_WndCardDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.637932,0.5))

    local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
    txtDrawTip:setScale(0.8)
    txtDrawTip:setDimensions(GlobalMethod:CCSize(140))
end

function WndCardDraw:_adaptLanguage_vn(  )
    local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
    txtDrawTip:setScale(0.8)
    txtDrawTip:setDimensions(GlobalMethod:CCSize(140))
end
function WndCardDraw:_adaptLanguage_en()
    local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
    txtDrawTip:setScale(0.8)
    txtDrawTip:setDimensions(GlobalMethod:CCSize(140))
end

function WndCardDraw:_adaptLanguage_pt(  )
    local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
    txtDrawTip:setScale(0.7)
    txtDrawTip:setDimensions(GlobalMethod:CCSize(160))
end

function WndCardDraw:_adaptLanguage_es(  )
    local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
    txtDrawTip:setScale(0.6)
    txtDrawTip:setDimensions(GlobalMethod:CCSize(180))
    GetElement(self.m_root,"cbTen_WndCardDraw",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(-0.170896,0.5))
    GetElement(self.m_root,"txtTenT_WndCardDraw",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.383587,0.5))
end

function WndCardDraw:_adaptLanguage_en(  )
    local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
    txtDrawTip:setScale(0.7)
    txtDrawTip:setDimensions(GlobalMethod:CCSize(160))
end
function WndCardDraw:_adaptLanguage_tr(  )
    local txtDrawTip = GetElement(self.m_root,"txtDrawTip_WndCardDraw",WZUILabelTTF)
    txtDrawTip:setScale(0.7)
    txtDrawTip:setDimensions(GlobalMethod:CCSize(160))

    local txtTenT = GetElement(self.m_root,"txtTenT_WndCardDraw",WZUILabelTTF)
    txtTenT:setScale(0.7)
    txtTenT:setDimensions(GlobalMethod:CCSize(100))
end
---------------------------------------语言适配End------------------------------------------