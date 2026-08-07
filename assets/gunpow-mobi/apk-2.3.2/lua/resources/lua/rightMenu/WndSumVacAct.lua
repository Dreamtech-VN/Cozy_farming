--WndSumVacAct.lua
--@brief	WndSumVacAct的UI模块
--@date		2017/07/07
--@author	 qixiang
--@note		暑假活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSumVacAct:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end


function WndSumVacAct:onEnterTransitionDidFinish(element)
	-- body
	WZLog("WndSumVacAct:onEnterTransitionDidFinish")
	local conActivityEnd = GetElement(self.m_root,"conActivityEnd_WndSumVacAct",WZUIContainer)
	local conLeft = GetElement(self.m_root,"conLeft_WndSumVacAct",WZUIContainer)
	if GlobalGame.g_autoSummerActivity == 3 then
		conActivityEnd:setVisible(false)
		conLeft:setVisible(true)
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(3)
		GetElement(self.m_root,"conExplain_WndSumVacAct",WZUIContainer):setVisible(true)
	else
		conActivityEnd:setVisible(true)
		conLeft:setVisible(false)
		local txtActivityTime = GetElement(conActivityEnd,"txtActivityTime_WndSumVacAct",WZUILabelTTF)

		local timeCur = os.date("%Y.%m.%d",GlobalGame.g_autoSummerStartT)
		timeCur = string.format(LocalStrings.SUMMER_VACTION_START_T,timeCur)
		txtActivityTime:setText(timeCur)

		GetElement(self.m_root,"conExplain_WndSumVacAct",WZUIContainer):setVisible(false)
	end
	WndNewActivity:updateRechargeInfo()
		
		--美洲情人节活动调整
		local imgBg = GetElement(self.m_root,"imgBg_WndSumVacAct",WZUIImage)
		imgBg:setFile("ui/gameActivity/qr_di1.png")
		imgBg:setRelativePosition(GlobalMethod:ccp(0.4945,0.476789))
		local imgTitleBg = GetElement(self.m_root,"imgTitleBg_WndSumVacAct",WZUIImage)
		imgTitleBg:setFile("ui/gameActivity/qr_di2.png")
		imgTitleBg:setRelativePosition(GlobalMethod:ccp(0.494792,0.87911))
		local imgBtnClose1 = GetElement(self.m_root,"imgBtnClose1_WndSumVacAct",WZUIImage)
		imgBtnClose1:setFile("ui/common/qr_di3.png")
		local imgBtnClose2 = GetElement(self.m_root,"imgBtnClose2_WndSumVacAct",WZUIImage)
		imgBtnClose2:setFile("ui/common/qr_di3.png")
		local imgTitle = GetElement(self.m_root,"imgTitle_WndSumVacAct",WZUIImage)
		imgTitle:setFile("ui/gameActivity/qr_vd.png")
		imgTitle:setRelativePosition(GlobalMethod:ccp(0.489584,0.890715))
		for i = 1, 4 do
			GetElement(self.m_root,"imgAct" .. i .. "Btn1_WndSumVacAct",WZUIImage):setFile("ui/gameActivity/qr_an.png")
			GetElement(self.m_root,"imgAct" .. i .. "Btn2_WndSumVacAct",WZUIImage):setFile("ui/gameActivity/qr_an_sel.png")
			GetElement(self.m_root,"imgAct" .. i .. "Btn3_WndSumVacAct",WZUIImage):setFile("ui/gameActivity/qr_an_sel.png")

			GetElement(self.m_root,"imgActivity3Reward" .. i .. "_WndSumVacAct",WZUI9Image):setFile("ui/gameActivity/qr_di4.png")
			GetElement(self.m_root,"imgActivity4Reward" .. i .. "_WndSumVacAct",WZUI9Image):setFile("ui/gameActivity/qr_di4.png")
		end
		GetElement(self.m_root,"imgActivity3di_WndSumVacAct",WZUI9Image):setFile("ui/gameActivity/qr_di7.png")
		local imgExplain1 = GetElement(self.m_root,"imgExplain1_WndSumVacAct",WZUIImage)
		imgExplain1:setFile("ui/common/qr_gth.png")
		local imgExplain2 = GetElement(self.m_root,"imgExplain2_WndSumVacAct",WZUIImage)
		imgExplain2:setFile("ui/common/qr_gth.png")

		GetElement(self.m_root,"conGiftBox_WndSumVacAct",WZUIContainer):setVisible(true)
		
		GetElement(self.m_root,"conExplain_WndSumVacAct",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.125083,0.0562496))
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSumVacAct:onExit(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetSummerActivityStatus()
	self:_unInit()
end

--@brief    发送请求刷新充值进度
--@param   bRecharge：是否为充值活动刷新
function WndSumVacAct:refreshActivityContext(bRecharge)
    WZLog("WndSumVacAct:refreshActivityContext")
    if self.m_root == nil then return end
    if bRecharge then
        if self.m_nCurShowActivityId == 3030 or self.m_nCurShowActivityId == 3031  then  --夏日专属与夏日盛慧
        	self:_ActivityContext(self.m_nCurShowActivityType,self.m_nCurShowActivityId)
        end
    end
end



function WndSumVacAct:onClickActivity(element)
    WZLog("WndSumVacAct:onClickActivity ")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if GlobalGame.g_autoSummerActivity == 1 then
    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
    	return
    end
    local tag = element:getTag()
    
    local parent = element:getParent()
    parent = WZUIContainer:luaTo(parent)
    local btn = GetElement(parent,"btn_WndSumVacAct",WZUIButton)
    btn:setTouchEnable(false)

    local conTop = GetElement(self.m_root,"conLeft_WndSumVacAct",WZUIContainer)
    local conActivity = GetElement(conTop,"conActivity" .. self.m_nClickNowId .. "_WndSumVacAct",WZUIContainer)
    
    local btn = GetElement(conActivity,"btn_WndSumVacAct",WZUIButton)
    btn:setTouchEnable(true)
    self.m_nClickNowId = tag
    local imgActRed = GetElement(parent,"imgActRed_WndSumVacAct",WZUIImage)
    
    local activityInfo = self.m_tListItem[tag]
    
    self.m_nCurShowActivityId = activityInfo.types
    self.m_nCurShowActivityType = activityInfo.activityId

    imgActRed:setVisible(false)

    self:_ActivityContext(self.m_nCurShowActivityType,self.m_nCurShowActivityId)
    if self.m_nCurShowActivityId ~= 3032 then --显示红点
    	for i,v in ipairs(self.m_tListItem) do
			if v.types == 3032 then
				if self:bShowRedPoint() then
					local conActivity = GetElement(conTop,"conActivity" .. i .. "_WndSumVacAct",WZUIContainer)
				    local imgActRed = GetElement(conActivity,"imgActRed_WndSumVacAct",WZUIImage)
					imgActRed:setVisible(true)
				end
		    	return
			end
        end
    end
end

--购买时装
function WndSumVacAct:onClickBuy(element)
	-- body
	WZLog("WndSumVacAct:onClickBuy ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent = element:getParent()
	parent = parent:getParent()
	parent = WZUIContainer:luaTo(parent)
	local imgSoldOut = GetElement(parent,"imgSoldOut_WndSumVacAct",WZUIImage)
	if imgSoldOut:isVisible()  then
		return
	end
	
	local tag = element:getTag()
	local dataT = self.m_tPacksInfo[tag]
	local playerInfo = CacheCenter:getPlayerInfo()
	local data = {
            ids = dataT[1],
            icons = dataT[2],--icons[i],
            number = dataT[3],
            giftNumber = dataT[4],
            price = dataT[5],
            payCodeId = dataT[6],
            flag = dataT[7],
            name = dataT[8],
            remark = dataT[9],
            showPrice = dataT[10],
            itemId = dataT[11],
            sortId = dataT[12],
            leftTimes = dataT[13],
            limitType = dataT[14],
            needVipLv = dataT[15],
            showType = 1
        }

    local temp = WndNewActivity:bRecharge(data.price,data.ids,playerInfo.id)
    if not temp then
        return
    end
    
    if data.limitType ~= 0 and data.leftTimes <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_COUNT)
        return
    end

    if data.needVipLv > 0 and CacheCenter.m_tPlayerInfo.vipLevel < data.needVipLv then
        MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_VIP)
        return
    end
    
    WndVip:createLoadingUI()
    local sdkData = self:getSDKData(tag,self.m_tPacksInfo)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
    PassportSdkManager:getOrderNum(sdkData)
end

--@brief    关闭窗口
function WndSumVacAct:onCloseClick()
	WZLog("WndSumVacAct:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root, self, true)
    if g_isFirstGangsterInnShow == true then
    	local tNewUserPackageList = CacheCenter:getLimitPackageList()
	    if tNewUserPackageList == nil or #tNewUserPackageList == 0 then return end 
        WndGangsterInnOwner:showWindow(1)
    end 
end

--夏日赏金
function WndSumVacAct:onClickDo(element)
	-- body
	WZLog("WndSumVacAct:onClickDo")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if GlobalGame.g_autoSummerActivity == 1 then
    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
    	return
    end
	local tag = element:getTag()
	local parent = element:getParent()
	parent = WZUIContainer:luaTo(parent)
	local txtStats = GetElement(parent,"txtStats_WndSumVacAct",WZUILabelTTF)
	local txt = txtStats:getText()
	local monsterId = self.m_tSummerMonsterInfo.configId[tag][1]
	local rewardInfo = GDatatab_wanted_monster["id_" .. monsterId]
	if txt == LocalStrings.ACTIVE_BTN_GO then
		local script = rewardInfo.script
		JumpByUIId(script[1][1] , script[1][2])
	elseif txt == LocalStrings.ACTIVE_BTN_GET then --可领取
		self.m_nGetRewardMonsterId = monsterId
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DrawWantedMonsterReward(1,monsterId)
	else

	end
end


function WndSumVacAct:onClickDetail(element)
    WZLog("WndSumVacAct:onClickDetail")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.SUMMER_VACTION_DES)
end

--领取夏日赏金宝箱
function WndSumVacAct:onClickByIntegral(element)
	-- body
	WZLog("WndSumVacAct:onClickByIntegral")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if GlobalGame.g_autoSummerActivity == 1 then
    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
    	return
    end
	local tag = element:getTag()
	local targetScoreInfo = self.m_tSummerMonsterInfo.targetScore[tag]
	if targetScoreInfo[2]  == 2 then --可以领取奖励
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_DrawWantedMonsterReward(2,targetScoreInfo[1])
		self.m_nGetRewardChestId = true
	else
		local score =  self.m_tSummerMonsterInfo.targetScore[tag][1]
		local itemList = self.m_tRewardList[tag]
		itemList.singleCopy = false
		local desc = string.format(LocalStrings.KILL_REWARD_TIP,score)
		itemList.desc = desc
		itemList.charm = true
		local offset = {x=0,y=0}
		WndTips:show(element,self.m_root,3,itemList,offset)
	end
end

--夏日专属
function WndSumVacAct:onClickRecharge2(element)
	-- body
	WZLog("WndSumVacAct:onClickRecharge2")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if GlobalGame.g_autoSummerActivity == 1 then
    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
    	return
    end
		
	local dataT = self.m_tPacksFashion[1]
	local playerInfo = CacheCenter:getPlayerInfo()
	local data = {
	        ids = dataT[1],
	        icons = dataT[2],--icons[i],
	        number = dataT[3],
	        giftNumber = dataT[4],
	        price = dataT[5],
	        payCodeId = dataT[6],
	        flag = dataT[7],
	        name = dataT[8],
	        remark = dataT[9],
	        showPrice = dataT[10],
	        itemId = dataT[11],
	        sortId = dataT[12],
	        leftTimes = dataT[13],
	        limitType = dataT[14],
	        needVipLv = dataT[15],
	        showType = 1
	    }

	local temp = WndNewActivity:bRecharge(data.price,data.ids,playerInfo.id)
	if not temp then
	    return
	end

	if data.limitType ~= 0 and data.leftTimes <= 0 then
	    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_COUNT)
	    return
	end

	if data.needVipLv > 0 and CacheCenter.m_tPlayerInfo.vipLevel < data.needVipLv then
	    MsgBoxManager:showTipBox(LocalStrings.BUY_GIFT_NO_VIP)
	    return
	end

	WndVip:createLoadingUI()
	local sdkData = self:getSDKData(1, self.m_tPacksFashion)
	PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
	PassportSdkManager:getOrderNum(sdkData)

end

--@brief 	设置面板内容
function WndSumVacAct:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	WZLog("WndSumVacAct::_updateActivityContext =")
	if self.m_nCurShowActivityId == 3033 then
		local conActivityContext4 = GetElement(self.m_root,"conActivityContext4_WndSumVacAct",WZUIContainer)
		self.m_tDiscountP = {}
		local startT = startTime
        local endT = endTime

        startT = os.date("%m.%d",startT)
        endT = os.date("%m.%d",endT)
        local actT = LocalStrings.ACTIVITY_TIME_KEY .. "：" .. startT .. "-" .. endT
        local txtActivitySkillT = GetElement(conActivityContext4,"txtActivitySkillT_WndSumVacAct",WZUILabelTTF)
        txtActivitySkillT:setText(actT)

		for i=1,4 do
			local conItem = GetElement(conActivityContext4,"conItem" .. i .. "_WndSumVacAct",WZUIContainer)
			local conItemInfo = GetElement(conItem,"conItemInfo_WndSumVacAct",WZUIContainer)
			local eItem, tItem = CellGoodItem:createElement()
			eItem:setScale(0.86)
			tItem:setItemClickFun(self, self.onClickListItem)

			local tData = {
			    id = rewardItems[i],
			    isUse = false,
			    data = "",
			    playerItemId = -1,
			    lastNum = rewardItemsParamCount[i], --物品数量
			    basicInfo = GetItemLocalData(rewardItems[i])
			}
			tItem:setCellGoodItem(tData,4)
			conItemInfo:addChild(eItem)
			local tempT = {}

			table.insert(tempT,activityId)
			table.insert(tempT,rewardId[i])

			local txtOriginPrice = GetElement(conItem,"txtOriginPrice_WndSumVacAct",WZUILabelTTF)
			local txtDiscountPrice = GetElement(conItem,"txtDiscountPrice_WndSumVacAct",WZUILabelTTF)
			local txtRemainingCount = GetElement(conItem,"txtRemainingCount_WndSumVacAct",WZUILabelTTF)
			local txtItemName = GetElement(conItem,"txtItemName_WndSumVacAct",WZUILabelTTF)
			local itemInfo = GDatatab_item["id_" .. rewardItems[i]]
			txtItemName:setText(itemInfo.name)

			local conBuy = GetElement(conItem,"conBuy_WndSumVacAct",WZUIContainer)
			local imgSoldOut = GetElement(conItem,"imgSoldOut_WndSumVacAct",WZUIImage)
			conBuy:setVisible(true)
			imgSoldOut:setVisible(false)
			if rewardCounts[i] <= 0 then
				conBuy:setVisible(false)
				imgSoldOut:setVisible(true)
			end
			
			txtRemainingCount:setText(LocalStrings.SHOP_GOODSSHEGN .. ":" ..rewardCounts[i] )
			if i == 1 then
				txtOriginPrice:setText(LocalStrings.LIMITE_BUY_ORIGINPRICE .. ":" .. target[9] )
				txtDiscountPrice:setText(LocalStrings.LIMITE_BUY_CURPRICE .. ":" .. target[5])
				table.insert(tempT,target[5])
			elseif i == 2 then
				txtOriginPrice:setText(LocalStrings.LIMITE_BUY_ORIGINPRICE .. ":" ..target[10] )
				txtDiscountPrice:setText(LocalStrings.LIMITE_BUY_CURPRICE .. ":" .. target[6])
				table.insert(tempT,target[6])
			elseif i == 3 then
				txtOriginPrice:setText(LocalStrings.LIMITE_BUY_ORIGINPRICE .. ":" ..target[11] )
				txtDiscountPrice:setText(LocalStrings.LIMITE_BUY_CURPRICE .. ":" .. target[7])
				table.insert(tempT,target[7])
			elseif i == 4 then
				txtOriginPrice:setText(LocalStrings.LIMITE_BUY_ORIGINPRICE .. ":" ..target[12] )
				txtDiscountPrice:setText(LocalStrings.LIMITE_BUY_CURPRICE .. ":" .. target[8])
				table.insert(tempT,target[8])
			end
			table.insert(tempT,rewardCounts[i])
			table.insert(self.m_tDiscountP,tempT)

			if ProjConfig.LANGUAGE == "es" then
				txtItemName:setScale(0.7)
				txtOriginPrice:setScale(0.6)
				txtDiscountPrice:setScale(0.6)
			elseif ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
				txtItemName:setScale(0.8)				
				txtOriginPrice:setScale(0.8)
				txtDiscountPrice:setScale(0.8)
			end
		end
	end
end

function WndSumVacAct:onClickBuyItem(element)
	-- body
	WZLog("WndSumVacAct:onClickBuyItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if GlobalGame.g_autoSummerActivity == 1 then
    	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
    	return
    end
	local tag = element:getTag()
	local discountInfo = self.m_tDiscountP[tag]
	local price = discountInfo[3]
	if discountInfo[4] <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.ATH_CNT_NOT_ENOUGH)
		return
	end
	self.m_tBuyItemCallback = {}
	table.insert(self.m_tBuyItemCallback,discountInfo[1])
	table.insert(self.m_tBuyItemCallback,discountInfo[2])
	if JudgeMoneyIsEnough(1, price, text,nil,nil,nil,nil,nil,nil,self,self.buyItemCallback) then 
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(discountInfo[1], discountInfo[2] )
	end
end

--使用钻石购买
function WndSumVacAct:buyItemCallback()
	-- body
	WZLog("WndSumVacAct:buyItemCallback")
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_tBuyItemCallback[1],self.m_tBuyItemCallback[2])
    self.m_tBuyItemCallback = {}
end


--查看夏日赏金怪物信息
function WndSumVacAct:onClickLook(element)
	-- body
	WZLog("WndSumVacAct:onClickLook")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	local tag = element:getTag()
	local monsterInfo = GDatatab_wanted_monster["id_" .. tag]
	WndItemInfo:showInfo(element,self.m_root,3,monsterInfo.describe,false,{x=30,y=30})
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	刷新列表数据
function WndSumVacAct:_updateListItem()
    WZLog("WndSumVacAct:_updateListItem ")
    local GetElement  = GetElement
	local ItemCount = #self.m_tListItem
    local conTop = GetElement(self.m_root,"conLeft_WndSumVacAct",WZUIContainer)
    local bExit = false
    if self.m_nCurShowActivityId ~= nil then
    	for i,v in ipairs(self.m_tListItem) do
			if v.types == self.m_nCurShowActivityId then
				bExit = true
				break
			end
        end
		if not bExit then
			self.m_nCurShowActivityId = nil
		end
    end
    
	for i=1,ItemCount do
        local conActivity = GetElement(conTop,"conActivity" .. i .. "_WndSumVacAct",WZUIContainer)
        conActivity:setVisible(false)

        local btn = GetElement(conActivity,"btn_WndSumVacAct",WZUIButton)
       
        local imgNormalTitle = GetElement(btn,"imgNormalTitle_WndSumVacAct",WZUIImage)
        local imgSelTitle = GetElement(btn,"imgSelTitle_WndSumVacAct",WZUIImage)
        local imgNotEnableTitle = GetElement(btn,"imgNotEnableTitle_WndSumVacAct",WZUIImage)
        local imgActRed = GetElement(conActivity,"imgActRed_WndSumVacAct",WZUIImage)
        if self.m_tListItem[i].types == 3030 then
        	conActivity:setVisible(true)
        	imgNormalTitle:setFile("ui/gameActivity/holiday_top01.png")
        	imgSelTitle:setFile("ui/gameActivity/holiday_top01.png")
        	imgNotEnableTitle:setFile("ui/gameActivity/holiday_top1.png")
        elseif self.m_tListItem[i].types == 3031 then
        	conActivity:setVisible(true)
        	imgNormalTitle:setFile("ui/gameActivity/holiday_top03.png")
        	imgSelTitle:setFile("ui/gameActivity/holiday_top03.png")
        	imgNotEnableTitle:setFile("ui/gameActivity/holiday_top3.png")
        elseif self.m_tListItem[i].types == 3032 then
        	conActivity:setVisible(true)
        	imgActRed:setVisible(false)
        	imgNormalTitle:setFile("ui/gameActivity/holiday_top05.png")
        	imgSelTitle:setFile("ui/gameActivity/holiday_top05.png")
        	imgNotEnableTitle:setFile("ui/gameActivity/holiday_top5.png")
        	if self:bShowRedPoint() and  self.m_nCurShowActivityId  ~= 3032 then
        		imgActRed:setVisible(true)
        	end
        	
        elseif self.m_tListItem[i].types == 3033 then
        	conActivity:setVisible(true)
        	imgNormalTitle:setFile("ui/gameActivity/holiday_top04.png")
        	imgSelTitle:setFile("ui/gameActivity/holiday_top04.png")
        	imgNotEnableTitle:setFile("ui/gameActivity/holiday_top4.png")
        end
        
        if  self.m_nCurShowActivityId == nil then
        	btn:setTouchEnable(false)
        	self.m_nClickNowId = btn:getTag()
        	self.m_nCurShowActivityId = tonumber(self.m_tListItem[i].types)
        	self.m_nCurShowActivityType = self.m_tListItem[i].activityId
            self:_ActivityContext(self.m_tListItem[i].activityId,self.m_tListItem[i].types)
        elseif self.m_nCurShowActivityId == tonumber(self.m_tListItem[i].types) then
        	btn:setTouchEnable(false)
        	self.m_nClickNowId = btn:getTag()
        	self.m_nCurShowActivityId = tonumber(self.m_tListItem[i].types)
        	self.m_nCurShowActivityType = self.m_tListItem[i].activityId
            self:_ActivityContext(self.m_tListItem[i].activityId,self.m_tListItem[i].types)
        end

        if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" then
			imgNormalTitle:setScale(0.8)
			imgSelTitle:setScale(0.8)
			imgNotEnableTitle:setScale(0.8)
        end
	end
end

--@brief 	设置活动面板内容
function WndSumVacAct:_ActivityContext( nId ,nType )
	WZLog("WndSumVacAct:_ActivityContext  nId=",nId ,nType)
    if self.m_root == nil then return end
    local GetElement = GetElement
    local conActivityC = GetElement(self.m_root,"conActivityC_WndSumVacAct",WZUIContainer)
    local conActivityContext1 = GetElement(conActivityC,"conActivityContext1_WndSumVacAct",WZUIContainer)
    local conActivityContext2 = GetElement(conActivityC,"conActivityContext2_WndSumVacAct",WZUIContainer)
    local conActivityContext3 = GetElement(conActivityC,"conActivityContext3_WndSumVacAct",WZUIContainer)
    local conActivityContext4 = GetElement(conActivityC,"conActivityContext4_WndSumVacAct",WZUIContainer)
    conActivityContext1:setVisible(false)
    conActivityContext2:setVisible(false)
    conActivityContext3:setVisible(false)
    conActivityContext4:setVisible(false)

    if nType == 3030 then --夏日专属
    	conActivityContext1:setVisible(true)
        ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(ProjConfig.CHANNEL_ID,102)
    elseif nType == 3031 then --夏日盛惠
    	conActivityContext2:setVisible(true)
        ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(ProjConfig.CHANNEL_ID,101)
    elseif nType == 3032 then --夏日赏金
    	conActivityContext3:setVisible(true)
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWantedMonsterInfo()
    elseif nType == 3033 then --夏日放价
    	conActivityContext4:setVisible(true)
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId,nType)
    end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndSumVacAct:_adaptLanguage_es(  )
	local txtCrossServerBounty = GetElement(self.m_root,"txtCrossServerBounty_WndSumVacAct",WZUILabelTTF)
	txtCrossServerBounty:setScale(0.7)
	txtCrossServerBounty:setDimensions(GlobalMethod:CCSize(140))
	txtCrossServerBounty:setRelativePosition(GlobalMethod:ccp(0.1,0.7))
end

function WndSumVacAct:_adaptLanguage_en(  )
	local txtCrossServerBounty = GetElement(self.m_root,"txtCrossServerBounty_WndSumVacAct",WZUILabelTTF)
	txtCrossServerBounty:setScale(0.7)
	txtCrossServerBounty:setDimensions(GlobalMethod:CCSize(140))
	txtCrossServerBounty:setRelativePosition(GlobalMethod:ccp(0.1,0.7))
end

function WndSumVacAct:_adaptLanguage_pt(  )
	local txtCrossServerBounty = GetElement(self.m_root,"txtCrossServerBounty_WndSumVacAct",WZUILabelTTF)
	txtCrossServerBounty:setScale(0.7)
	txtCrossServerBounty:setDimensions(GlobalMethod:CCSize(140))
	txtCrossServerBounty:setRelativePosition(GlobalMethod:ccp(0.1,0.7))
end


--------------------------------------语言适配End-----------------------------------------