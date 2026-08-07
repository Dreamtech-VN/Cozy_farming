--WndTurnTableLottery.lua
--@brief	WndTurnTableLottery的UI模块
--@date		2015/04/02
--@author	qixiang_xie
--@note		爱心许愿
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTurnTableLottery:onEnter(element)
    WZLog("WndTurnTableLottery:onEnter")
	self.m_root = element
	AdaptLanguage(self)
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDiamondLotteryInfo()

    --AdaptLanguage(self)
	CacheCenter:registerUpatePlayerItemObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTurnTableLottery:onExit(element)
	WZLog("WndTurnTableLottery:onExit -----")
    CacheCenter:updateMoneyData()
	CacheCenter:setUpdateNewStatus(false)

	self.m_root:disableSchedule()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
    Teach:isStartTeach("WndTurnTableLottery:onExit")
	ProtocolProcessorSceneLottery:unregAll()
end

--@brief	退出爱心许愿响应函数
--@param	element:表绑定的UI节点引用
function WndTurnTableLottery:onCloseClick(element)
	WZLog("WndTurnTableLottery:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end

--@brief    弹窗动画完成后的回调
function WndTurnTableLottery:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root , WndTurnTableLottery , true)
end


--@brief  幸运抽奖奖品列表
function WndTurnTableLottery:_updateTable()
	WZLog("WndTurnTableLottery:_updateTable")
    if self.m_root == nil then
		WZLog("WndTurnTableLottery root is nil")
		return
	end
	local gameParam = CacheCenter:getGameParam()

	local txtDrawDiamonds = GetElement(self.m_root,"txtDrawDiamonds_WndTurnTableLottery",WZUILabelTTF)
	local tempS = string.format(LocalStrings.DRAW_LUCKY_TIP,gameParam.diamondLotteryGainGold,1)
	if tempS then
		txtDrawDiamonds:setText(tempS)
	end

    local conItem = nil
    self.m_root:disableSchedule()
	for i=1,8 do
		local cellElement,tCell = self:_createCellGoodItem(i,self.m_tGiftId[i],self.m_tGiftNum[i])
		cellElement:setScale(0.8)
		WZLog("SceneLottery:self.m_tGiftId[i]",self.m_tGiftId[i])
		
		conItem = self.m_root:getChildElement("conPrize"..i.."_WndTurnTableLottery")

		conItem = WZUIContainer:luaTo(conItem)

		conItem:addChild(cellElement)
    end
    

end

--@brief    创建一个物品格子
--@param    nIndex，序号
function WndTurnTableLottery:_createCellGoodItem(nIndex,itemId,itemCount)
	WZLog("WndTurnTableLottery:_createCellGoodItem =",nIndex,itemId,itemCount)
    local eItem, tItem = CellGoodItem:createElement()
    --eItem:setScale(0.3)
    tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(WndTurnTableLottery, WndTurnTableLottery.onClickItem)
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
        tItem:setBackImgFile("ui/common/common_scale9_beibaodi2.png", true)
        tItem:setNumColor(GlobalMethod:ccc3(255,236,193), GlobalMethod:ccc3(132,66,29))
    end
    return eItem, tItem
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndTurnTableLottery:onClickItem(tItem, nTag, tData)
    WZLog("WndTurnTableLottery:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--@brief   设置爱心数量和钻石数量
function WndTurnTableLottery:_setData()
	WZLog("WndTurnTableLottery:_setData")
	local imgCostType = GetElement(self.m_root,"imgCostType_WndTurnTableLottery",WZUIImage)
	local icon = GDatatab_item["id_" .. self.m_nCostType].icon
	imgCostType:setFile(icon)

	local txtPrice = GetElement(self.m_root,"txtPrice_WndTurnTableLottery",WZUILabelTTF)
	txtPrice:setText(self.m_nPrice)

	local txtCount = GetElement(self.m_root,"txtCount_WndTurnTableLottery",WZUILabelTTF)
	local tempCount = string.format(LocalStrings.CUR_TURN_COUNT,self.m_nLeftTime)
	txtCount:setText(tempCount)

	local txtStartTime =  GetElement(self.m_root,"txtStartTime_WndTurnTableLottery",WZUILabelTTF)
	local txtEndTime =  GetElement(self.m_root,"txtEndTime_WndTurnTableLottery",WZUILabelTTF)

	local strStartTime = nil
	local strEndTime = nil

    
	strStartTime =  os.date("%Y-%m-%d",math.floor(self.m_sStartTime)) 
	strEndTime =  os.date("%Y-%m-%d",math.floor(self.m_sEndTime)) 
	
	txtStartTime:setText(strStartTime)
	txtEndTime:setText(LocalStrings.UNITY .. strEndTime)
end

--@brief  抽奖cell高亮
--@param  curCellIndex:需要高亮的cell
--@node   此方法也做了旋转速度控制
--@node   播放方式是(慢、中、快、慢)
function WndTurnTableLottery:_setHighlightCell(curCellIndex)
	WZLog("WndTurnTableLottery:_setHighlightCell = ",curCellIndex)
	local imgArrow =self.m_root:getChildElement("imgArrow_WndTurnTableLottery")
	local imgColor =self.m_root:getChildElement("imgColor_WndTurnTableLottery")
	if imgArrow == nil then
		return
	end

    imgArrow = WZUIImage:luaTo(imgArrow)
	local rotation = imgArrow:getRotation()
	local colorRotation = imgColor:getRotation()
	local originColrRo = colorRotation
	local arrRo = rotation
    
	local rotation = imgArrow:getRotation()
	if rotation >=360 then
		self.m_nid = 1
		rotation =rotation % 360 + 45
		self.m_curCircle = self.m_curCircle + 1
	else
		self.m_nid = self.m_nid + 1
		rotation = rotation + 45
	end

	if colorRotation >= 360 then
		colorRotation = colorRotation % 360 + 15
	else
        colorRotation = colorRotation + 15
	end

    imgArrow:setRotation(rotation)
    imgColor:setRotation(colorRotation)
    SoundManager:playEffectSound(SoundDefine.E_S_LOVELOTTERY_SHAO)
	if self.m_curCircle >=4 and self.m_nid == self.m_nRewardId then
		self.m_root:disableSchedule()
		self.m_nid = self.m_nRewardId
	    self.m_ncount  = 1
	    self.m_temrRecord = 0
        self.m_curCircle = 1
        imgArrow:setRotation(arrRo)
        local rota = originColrRo % 45
        if rota ~= 0 then
        	rota = (45 - rota)+rota
        end
        imgColor:setRotation(rota)
        
        local blinkAction = CCBlink:create(1, 3)
        imgArrow:runAction(blinkAction)
        imgArrow:enableSchedule("scheduleShowPrize",1)
        CacheCenter:updateMoneyData()
        CacheCenter:setUpdateNewStatus(false)
        if GlobalGame.g_bFightRage then  
        	upPlayerFightingAni()
        end
	end
end

--@brief  展示获取到的物品
function WndTurnTableLottery:scheduleShowPrize(element)
	WZLog("WndTurnTableLottery:scheduleShowPrize")
	element:disableSchedule()
	self:showPrize()
end

--@brief  显示抽奖到的奖品
function WndTurnTableLottery:showPrize()
	WZLog("WndTurnTableLottery:showPrize")
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
	self:_setBackBtnEnable(true)
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
function WndTurnTableLottery:setBtnLotteryEnable(bTouchEnable)
	local btnLottery = self.m_root:getChildElement("btnLottery_WndTurnTableLottery")
	if btnLottery~=nil then
	    btnLottery = WZUIButton:luaTo(btnLottery)
	    btnLottery:setTouchEnable(bTouchEnable)
	end
end


--@brief    前往vip充值
function WndTurnTableLottery:_EventToVIP( nId, nResType )
    WZLog("WndTurnTableLottery:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndVip:showWndUI(0)
    end
end

--@brief  点击许愿按钮时触发
--@param  element，触发该事件的界面元素
function WndTurnTableLottery:onClickRaffle(element)
	WZLog("WndTurnTableLottery:onClickRaffle loveNum ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZTempLog("self.m_nLeftTime>>>>>>>>>> ",self.m_nLeftTime)
    -- MsgBoxManager:showConfirmBoxWithBg(LocalStrings.ACTIVITY_BUY_SECOND, self, self.toContinue, nil, nil, "WndTurnTableLottery" .. self.m_nCostType)
    if self.m_nLeftTime <= 0 then
	    MsgBoxManager:showConfirmBox("Nạp mức bất kỳ, có ngay cơ hội rút thưởng! Nạp ngay nhé?", self, function()
	    	WndVip:showWndUI(0)
		end)
	else
		self:toContinue()
	end
end

--@brief 
function WndTurnTableLottery:toContinue()
    -- body
    if self.m_nLoadingId ~= nil and self.m_nLoadingId > 0 then
        WZLog("WndTurnTableLottery:access to the net")
        return
    end

    local totalCost = self.m_nPrice
    
    if not JudgeMoneyIsEnough(self.m_nCostType, totalCost, nil, nil, 126, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
        return
    end
    
    self:sureToUseDiamondInstead()
end

--@brief    确认用钻石代替礼券抽奖
function WndTurnTableLottery:sureToUseDiamondInstead()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    CacheCenter:setUpdateNewStatus(true)
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DiamondLottery()
end

--@brief  触发定时回调函数
--@param  element，触发该函数的元素
function WndTurnTableLottery:_scheduleSetCellState(element,detal)
   self.m_temrRecord = self.m_temrRecord + 1
    if self.m_curCircle == 1 then --第一圈
       if self.m_temrRecord > 1   then
            self:_setHighlightCell(self.m_nid)
            self.m_temrRecord = 0
       end
    elseif self.m_curCircle > 1 and self.m_curCircle < 3 and  self.m_temrRecord >1 then --第二圈
        self:_setHighlightCell(self.m_nid)
        self.m_temrRecord = 0
    elseif self.m_curCircle >=3 and self.m_curCircle < 4 then --第三圈
		if self.m_temrRecord > 3  then
		    self:_setHighlightCell(self.m_nid)
		    self.m_temrRecord = 0
		end
    else
    	if self.m_temrRecord >= 8  then
		    self:_setHighlightCell(self.m_nid)
		    self.m_temrRecord = 0
		end
   end
end

--@brief  设置返回和抽奖按钮和其他按钮点击状态
--@param bTouchEnable:true可点击，false不可点击
function WndTurnTableLottery:_setBackBtnEnable(bTouchEnable)
	local btnBack = self.m_root:getChildElement("btnClose_WndTurnTableLottery")
	if btnBack~=nil then
		btnBack = WZUIButton:luaTo(btnBack)
		btnBack:setTouchEnable(bTouchEnable)
	end
	self:setBtnLotteryEnable(bTouchEnable)
end

--@brief  点击弹出的确认购买时触发的函数
--@param  nType，按钮类型，关闭，取消，确定
--@param  nId，按钮id
function WndTurnTableLottery:clickSureBack(nId,nType)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if nType == MSGBOXRESTYPE_CONFIRM then
    	 PassportSdkManager:gotoPaymentPage()
	end
end


function WndTurnTableLottery:onClickDetail(element)
    WZLog("WndTurnTableLottery:onClickDetail")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.DIAMONDS_TURNTABLE_TIP )
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


function WndTurnTableLottery:onTouchBegan()
	WZLog("WndTurnTableLottery:onTouchBegan")
	WndItemInfo:onCloseClick()
end

-------------------------------------私有方法模块End----------------------------------------

------------------------------------语言适配Begin----------------------------------------------------
function WndTurnTableLottery:_adaptLanguage_vn(  )
	local txtDrawDiamonds = GetElement(self.m_root,"txtDrawDiamonds_WndTurnTableLottery",WZUILabelTTF)
	-- txtDrawDiamonds:setScale(0.6)
	txtDrawDiamonds:setDimensions(GlobalMethod:CCSize(140))

	GetElement(self.m_root,"imgCostType_WndTurnTableLottery",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
	GetElement(self.m_root,"txtPrice_WndTurnTableLottery",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.6,0.5))
end

function WndTurnTableLottery:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtDrawDiamonds_WndTurnTableLottery",WZUILabelTTF):setVisible(false)
end

function WndTurnTableLottery:_adaptLanguage_cn(  )
	GetElement(self.m_root,"txtDrawDiamonds_WndTurnTableLottery",WZUILabelTTF):setVisible(false)
end
function WndTurnTableLottery:_adaptLanguage_pt(  )
	local txtDrawDiamonds = GetElement(self.m_root,"txtDrawDiamonds_WndTurnTableLottery",WZUILabelTTF)
	txtDrawDiamonds:setVisible(false)
	txtDrawDiamonds:setScale(0.6)
	txtDrawDiamonds:setDimensions(GlobalMethod:CCSize(140))
end

function WndTurnTableLottery:_adaptLanguage_es(  )
	local txtDrawDiamonds = GetElement(self.m_root,"txtDrawDiamonds_WndTurnTableLottery",WZUILabelTTF)
	txtDrawDiamonds:setVisible(false)
	txtDrawDiamonds:setScale(0.5)
	txtDrawDiamonds:setDimensions(GlobalMethod:CCSize(160))
end

function WndTurnTableLottery:_adaptLanguage_en(  )
	local txtDrawDiamonds = GetElement(self.m_root,"txtDrawDiamonds_WndTurnTableLottery",WZUILabelTTF)
	txtDrawDiamonds:setVisible(false)
	txtDrawDiamonds:setScale(0.6)
	txtDrawDiamonds:setDimensions(GlobalMethod:CCSize(140))
end

function WndTurnTableLottery:_adaptLanguage_tr(  )
	local txtDrawDiamonds = GetElement(self.m_root,"txtDrawDiamonds_WndTurnTableLottery",WZUILabelTTF)
	txtDrawDiamonds:setVisible(false)
end