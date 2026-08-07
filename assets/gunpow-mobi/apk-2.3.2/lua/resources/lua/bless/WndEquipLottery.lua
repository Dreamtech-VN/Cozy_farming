--WndEquipLottery.lua
--@brief	WndEquipLottery的UI模块
--@date		2021/05/29
--@author	hyc
--@note		装备抽奖


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEquipLottery:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndRankList:regAll3()
	ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(1)
	AdaptLanguage(self)

	self:_adaptIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEquipLottery:onExit(element)
    if self.m_bIsCloseClick == nil then
        local isEndTeach41, teachStep41 = TeachGroup1:isTeachFinish(41)
        if teachStep41 > 4 then
            TeachGroup1:setTeachFinish(41, -1)
            TeachGroup1:removeTeach()
        end
    end
	self:_unInit()
end


function WndEquipLottery:onEnterTransitionDidFinish(element)
	local conLeftBtn = GetElement(self.m_root, "conLeftBtn_WndEquipLottery", WZUIContainer)
	CreateLimitPackage(11, conLeftBtn, GlobalMethod:ccp(0.5,0.26), true)
	self:_addTop()
	self:getAllBatch()
end

--@brief 	触摸开始按钮
function WndEquipLottery:onTouchBegan(element)
	-- body
	if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

function WndEquipLottery:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_xyzh.png", self, self.onCloseClick, true, false, false, nil, {goldType = 16})
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])
	local pinkIdcfg,PinkNumcfg = SplitItemString(mountDrawConfig["pinkPrice"])
	local pinkOneId,pinkOneNum = tonumber(pinkIdcfg[1]),tonumber(PinkNumcfg[1])
	local equipPriceId,equipPriceNum = SplitItemString(mountDrawConfig["equipLotteryPrice"])
	local showId1,showNum1 = tonumber(equipPriceId[1]),tonumber(equipPriceNum[1])
	local showId2,showNum2 = tonumber(equipPriceId[2]),tonumber(equipPriceNum[2])
    tcell.goldCellInfo.tcell:showCoin({177,pinkOneId,showId1,showId2},{1,1,1,1})

    self.m_topCellLua = tcell
end

function WndEquipLottery:getAllBatch()
	 for k,v in pairs(GDatatab_total_draw) do
	 	if self.m_lType == v.type and v.batch_pink >= self.m_allBatch  then
	 		self.m_allBatch = v.batch_pink
	 	end
	 end
	 WZLog("最大批次",self.m_allBatch)
end

function WndEquipLottery:onCloseClick() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	-- WindowManager:removeWindow(self.m_root, self, true)


    local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
    if isEndTeach41 ~= true and step41 > 0 then
    	self.m_bIsCloseClick = true
    	-- WindowManager:removeWindow(self.m_root,self,true)
    	WndSummonEntrance:closeWin()
        SceneCity.m_tWndBottomBarObj:endMoveVerticalBar(nil, false)
        --return
    else
    	self.m_bIsCloseClick = true
    	-- WindowManager:removeWindow(self.m_root,self,true)
    	WndSummonEntrance:closeWin()
    	pushEquipInList()
    end
end

--查看物品大全
function WndEquipLottery:onClickAllEquipment(element)
	WZLog("WndEquipmentLottery:onClickAllEquipment")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndGoodsFull:showInterface(1)
end

--@brief 前往皮肤
--@brief 	点击前往装备按钮回调
function WndEquipLottery:onClickGotoEquip(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if WndBagMain.m_root then
		self.m_bIsCloseClick = true
    	-- WindowManager:removeWindow(self.m_root,self,true)
    	WndSummonEntrance:closeWin()
		return 
	end
	WndBagMain:showBeibao()
end

--@brief 查看召唤商店
function WndEquipLottery:onClickLotteryStore(element)
	WZLog("WndPetLottery:onClickLotteryStore")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("查看召唤商店",CheckButtonOpen(LOTTERY_SHOP))
	if CheckButtonOpen(LOTTERY_SHOP) then
		WndStore:showStoreByType(8)
	end
end

--@brief 查看说明
function WndEquipLottery:onClickExplain(element)
	-- body
	WZLog("WndEquipLottery:onClickExplain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.EQUIPMENT_DRAW_EXPLAIN1)
end

--@brief 图鉴
function WndEquipLottery:onClickHankShow(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndLotteryHank:showInterface(4)

end

--@brief 选择使用礼钻
function WndPetLottery:onChooseLizuan(element)
	self.m_usePinkDiamond = not self.m_usePinkDiamond
	self:initRightContent()
	self:onUpdateUi()
end

function WndEquipLottery:onContinue(tag)
	-- body
	self.m_lotteryShowTag = tag
	self:onClickLottery()
	self.m_lotteryShowTag = nil
end

--@brief 抽奖
function WndEquipLottery:onClickLottery(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_tag = self.m_lotteryShowTag or  element:getTag()
	local count =  CacheCenter:getRemainAmount()
	WZLog("背包剩余格子数",count)
	if count <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		return
	end

	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])
	local pinkIdcfg,PinkNumcfg = SplitItemString(mountDrawConfig["pinkPrice"])
	local pinkOneId,pinkOneNum = tonumber(pinkIdcfg[1]),tonumber(PinkNumcfg[1])
	local pinkTenId,pinkTenNum = tonumber(pinkIdcfg[1]),tonumber(PinkNumcfg[2])

	local otherId,otherNum = SplitItemString(mountDrawConfig["equipLotteryPrice"])
	local otherOneId,otherOneNum = tonumber(otherId[1]),tonumber(otherNum[1])
	local otherTowId,otherTowNum = tonumber(otherId[2]),tonumber(otherNum[2])
	local drawExchangeRate = json.decode(CacheCenter:getGameParam()["drawExchangeRate"])
	pinkOneNum2 = pinkOneNum * drawExchangeRate
	pinkTenNum2 = pinkTenNum * drawExchangeRate

	local lotteryType = 1

	local blueNum = CacheCenter:getMoneyList().blueDiamond
	local pinkNum = CacheCenter:getMoneyList().ticket
	local vnPinkDiamond = CacheCenter:getMoneyList().vnPinkDiamond
	local CoinNum = 0

	if CacheCenter:getGameParam().isUseTicket == "1" then --不使用双货币
		pinkNum = 0
	end

	if self.m_tag == 1 then
		CoinNum = CacheCenter:getPlayerItemCountById(otherOneId)
		if self.m_freeTime <= 0 then
			-- if count < 1 then
			-- 	MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			-- 	return
			-- end
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
		else 				
			if CoinNum >= otherOneNum then
				WZLog("钥匙10抽",CoinNum,otherOneNum)
				-- if count < 10 then
				-- 	MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
				-- 	return
				-- end
				ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
			elseif otherOneNum <= CoinNum  and CoinNum < otherOneNum * 10 then
				WZLog("钥匙1抽",CoinNum,otherOneNum)
				-- if count < 1 then
				-- 	MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
				-- 	return
				-- end
				ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
			elseif otherOneNum > CoinNum then
				WZLog("钥匙不足",CoinNum,otherOneNum)
			 	MsgBoxManager:showTipBox(LocalStrings.NOTENOUTH3)
			 	WndFastGetItems:show(otherOneId)
			end
		end
		TeachGroup1:endTeachStep({41,3})
	elseif self.m_tag == 2 then
		CoinNum = CacheCenter:getPlayerItemCountById(pinkOneId)
		if CoinNum >= pinkOneNum then --金召唤币
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
		else --越南粉钻代替
			local needPinkNum = pinkOneNum2 - CoinNum * drawExchangeRate
			if vnPinkDiamond >= needPinkNum then
				if not JudgeMoneyIsEnough(pinkOneId,pinkOneNum, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead,1) then
					return
				end
			else
				if not JudgeMoneyIsEnough(pinkOneId,pinkOneNum, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead1,1) then
					return
				end
			end
		end
		TeachGroup1:endTeachStep({41,5})
	elseif self.m_tag == 3 then
		local count =  CacheCenter:getRemainAmount()
		if count < 10 then
			MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
			return
		end

		CoinNum = CacheCenter:getPlayerItemCountById(pinkTenId)
		if CoinNum >= pinkTenNum then --金召唤币
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
		else --越南粉钻代替
			local needPinkNum = pinkTenNum2 - CoinNum * drawExchangeRate
			if vnPinkDiamond >= needPinkNum then
				if not JudgeMoneyIsEnough(pinkTenId,pinkTenNum, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead,1) then
					return
				end
			else 
				if not JudgeMoneyIsEnough(pinkTenId,pinkTenNum, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead1,1) then
					return
				end
			end
		end
	end   
	self.m_lotteryShowTag = nil			
end

function WndEquipLottery:sureUseDiamondInstead1()
	-- body
	if not JudgeMoneyIsEnough(177, needBlueNum, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE_VN, nil, Chat_Channel_Card, nil, nil, nil, nil, self, self.sureUseDiamondInstead1) then
		return
	end
end

function WndEquipLottery:sureUseDiamondInstead()
	-- body
	ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,1,self.m_batch[1])
end


function WndEquipLottery:scheduleUpdateRaffleTime(element)
	self.m_freeTime = self.m_freeTime -1
	if self.m_freeTime <=0 then
		element:disableSchedule()
	end
	local freeTime = self:formatTime(self.m_freeTime)
    local txtTime = GetElement(self.m_root,"txtFreeTime",WZUILabelTTF)
    txtTime:setText(freeTime)
end

-- function WndEquipLottery:scheduleUpdateRaffleTime1(element)
-- 	self.m_reTime = self.m_reTime -1
-- 	if self.m_reTime <=0 then
-- 		element:disableSchedule()
-- 	end
-- 	local freeTime = self:formatTime(self.m_reTime)
--     local txtTime = GetElement(self.m_root,"txtDiscountTime",WZUILabelTTF)
--     txtTime:setText(freeTime)
-- end

function WndEquipLottery:upRedDot()
	-- body
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])
	local num = mountDrawConfig["num"]
	local isShowRewardRed = self.m_lotteryNum >= num
    if isShowRewardRed ~= nil then
        local btn = GetElement(self.m_root, "conReward_WndEquipLottery", WZUIContainer)
        SceneCity:setRedPoint(btn, isShowRewardRed, GlobalMethod:ccp(80,80),0.8)
    end	
	local costCommon,costCommonNum = SplitItemString(mountDrawConfig["equipLotteryPrice"])
	local needId,needNum = tonumber(costCommon[1]),tonumber(costCommonNum[1])
	local needId1,needNum1 = tonumber(costCommon[2]),tonumber(costCommonNum[2])

	local CoinNum1 = CacheCenter:getPlayerItemCountById(needId)
	-- local CoinNum2 = CacheCenter:getPlayerItemCountById(needId1)
	-- local btnRed2 = CoinNum2 >= needNum
 --    if btnRed2 ~= nil then
 --        WZLog("isOneRedDot2")
 --        local btn = GetElement(self.m_root, "btn2_WndEquipLottery", WZUIContainer)
 --        SceneCity:setRedPoint(btn, btnRed2, GlobalMethod:ccp(196,58),0.8)
 --    end	

    local btnRed1 = (self.m_freeTime <= 0 or CoinNum1 >= needNum)
     if btnRed1 ~= nil then
        local btn = GetElement(self.m_root, "btn1_WndEquipLottery", WZUIContainer)
        SceneCity:setRedPoint(btn, btnRed1, GlobalMethod:ccp(196,58),0.8)
    end     
end

--@brief 初始化界面
function WndEquipLottery:onUpdateUi()
	-- body
	-- WZLog("进来了1",CheckButtonShow(LOTTERY_SHOP))
	local playerLevel = CacheCenter:getPlayerInfo().level
	local btnStore = GetElement(self.m_root,"btnStore_WndEquipLottery",WZUIContainer)
	btnStore:setVisible(false)
	WZLog("进来了1",playerLevel,GDatatab_button_info["id_"..206].show_level)
	if playerLevel >= GDatatab_button_info["id_"..206].show_level then
		btnStore:setVisible(true)
	end

	--equipDrawConfig
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])
	local num1 = mountDrawConfig["num"]
	local drawExchangeRate = json.decode(CacheCenter:getGameParam()["drawExchangeRate"])
	local txtFormat1 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="163,74,20" SS="4" SE="1">%s</T>]]
	local txtFormat2 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="0,108,3" SS="4" SE="1">%d</T>]]

	local txtFormat3 = GetElement(self.m_root,"TxtCommon_WndEquipLottery",WZUIFreeTextBox)
	local txtFormat31 = GetElement(self.m_root,"TxtCommon1_WndEquipLottery",WZUILabelTTF)
	local costCommon,costCommonNum = SplitItemString(mountDrawConfig["equipLotteryPrice"])
	local needId,needNum = tonumber(costCommon[1]),tonumber(costCommonNum[1])
	local needId1,needNum1 = tonumber(costCommon[2]),tonumber(costCommonNum[2])
	local iconPath3 = GDatatab_item["id_"..needId].icon
	if self.m_freeTime <= 0 then
		txtFormat3:setShowText(string.format(txtFormat1,iconPath3,LocalStrings.PETFREE2))
		txtFormat31:setText(LocalStrings.ONE_LOTTERY)
		txtFormat3:setRelativePosition(GlobalMethod:ccp(0,0.5))
	else 
		local haveNeedNum = CacheCenter:getPlayerItemCountById(needId)
		if needNum * 10 <= haveNeedNum then
			txtFormat31:setText(LocalStrings.TEN_LOTTERY)
			txtFormat3:setShowText(string.format(txtFormat1,iconPath3,tostring(needNum * 10)))
		elseif needNum * 10 > haveNeedNum then
			txtFormat3:setShowText(string.format(txtFormat1,iconPath3,tostring(needNum)))
			txtFormat31:setText(LocalStrings.ONE_LOTTERY)
			txtFormat3:setRelativePosition(GlobalMethod:ccp(0.1,0.5))
		end
	end
	local txtOne = GetElement(self.m_root,"TxtOne_WndEquipLottery",WZUIFreeTextBox)
	local txtOne1 = GetElement(self.m_root,"TxtOne1_WndEquipLottery",WZUILabelTTF)
	local itemId,num = SplitItemString(mountDrawConfig["pinkPrice"])
	local costOneId,costOneNum = tonumber(itemId[1]),tonumber(num[1])
	local haveOneNum = CacheCenter:getPlayerItemCountById(costOneId)
	local haveOneNum1 = CacheCenter:getPlayerItemCountById(needId1)
	local iconPath1 = GDatatab_item["id_"..costOneId].icon
	local iconPath4 = GDatatab_item["id_"..needId1].icon
	txtOne:setShowText(string.format(txtFormat1,iconPath1,costOneNum))
	-- if needNum1 > haveOneNum1 then
	-- 	txtOne1:setText(LocalStrings.ONE_LOTTERY)
	-- 	if self.m_reTime <= 0 then
	-- 		txtOne:setShowText(string.format(txtFormat1,iconPath1,math.floor(costOneNum)))
	-- 	else 
	-- 		txtOne:setShowText(string.format(txtFormat1,iconPath1,math.floor(costOneNum)))
	-- 	end
	-- else 
	-- 	if needNum1 * 10 <= haveOneNum1 then
	-- 		txtOne1:setText(LocalStrings.TEN_LOTTERY)
	-- 		txtOne:setShowText(string.format(txtFormat1,iconPath4,needNum1*10))
	-- 	else 
	-- 		txtOne1:setText(LocalStrings.ONE_LOTTERY)
	-- 		txtOne:setShowText(string.format(txtFormat1,iconPath4,needNum1))
	-- 	end
	-- end
	txtOne1:setText(LocalStrings.ONE_LOTTERY)
	local txtTen = GetElement(self.m_root,"txtTen_WndEquipLottery",WZUIFreeTextBox)
	local costTenId,costTenNum = tonumber(itemId[2]),tonumber(num[2])
	local iconPath2 = GDatatab_item["id_"..costTenId].icon
	txtTen:setShowText(string.format(txtFormat2,iconPath2,costTenNum))

	local freeTime = GetElement(self.m_root,"txtFreeTime",WZUILabelTTF)
	local freeTime1 = GetElement(self.m_root,"txtFreeTime1",WZUILabelTTF)
	self.m_root:enableSchedule("scheduleUpdateRaffleTime",1)
	if self.m_freeTime <= 0 then
		freeTime:setVisible(false)
		freeTime1:setVisible(false)
	else 
		freeTime:setVisible(true)
		freeTime1:setVisible(true)
		
		local leaveTime = self:formatTime(self.m_freeTime)
		freeTime:setText(leaveTime)	
	end

	-- local discountTime,discountNum = SplitItemString(mountDrawConfig["equipDrawBenefits"])
	-- local discountTime1,discountNum1 = tonumber(discountTime),tonumber(discountNum)
	-- local txtDiscountTime = GetElement(self.m_root,"txtDiscountTime",WZUILabelTTF)
	-- local txtDiscountTime1 = GetElement(self.m_root,"txtDiscountTime1",WZUILabelTTF)
	-- txtDiscountTime:enableSchedule("scheduleUpdateRaffleTime1",1)
	-- if self.m_reTime <= 0 then
	-- 	txtDiscountTime:setVisible(false)
	-- 	txtDiscountTime1:setVisible(false)
	-- else 
	-- 	txtDiscountTime:setVisible(true)
	-- 	txtDiscountTime1:setVisible(true)
	-- 	-- txtDiscountTime:setText(discountNum1..%)

	-- 	local leaveTime = self:formatTime(self.m_reTime)
	-- 	txtDiscountTime:setText(leaveTime)	
	-- end	

	local reward = json.decode(mountDrawConfig["raward"])
	WZLog("坐骑抽奖系统配置",Serialize(pinkPrice),num,self.m_lotteryNum,Serialize(reward))
	local conNode = GetElement(self.m_root,"conReward_WndEquipLottery",WZUIContainer)
	local labelReward = GetElement(self.m_root,"labelReward_WndEquipLottery",WZUILabelTTF)
	if num1 > self.m_lotteryNum then
		labelReward:setText(string.format(LocalStrings.NEED_LOTTERY_REWARD,num1 - self.m_lotteryNum))
	else 
		labelReward:setText(LocalStrings.GET_LOTTERY_REWARD)
	end
    local key = "id_"..reward[1]
    if GDatatab_item[key] then
        local name = GDatatab_item[key].name
        local path = GDatatab_item[key].icon
        local quality = GDatatab_item[key].quality
        local num = reward[2]
        local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
        local celElement,tLuaObj = CellGoodItem:createElement()
        tLuaObj:setCellGoodItem(itemInfo, 15)
        celElement:setScale(1)
        celElement:setRelativePosition(GlobalMethod:ccp(0.5,0.55))
        conNode:addChild(celElement)
        tLuaObj:setItemClickFun(WndEquipLottery,self.onItemClick)
    end
end


--@brief 点击自选礼包，可领取直接领取，不可领取时弹出tips
function WndEquipLottery:onItemClick(tCell,tag,tData)
	-- body
	if tData == nil then return end
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["equipDrawConfig"])
	local num = mountDrawConfig["num"]
	WZLog("点击自选礼包1",self.m_lotteryNum)
	WZLog("点击自选礼包2",num)
	if self.m_lotteryNum >= num then
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward(self.m_lType)
	else 
    	WndItemInfo:onCloseClick()
    	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false,nil,true)	
    end 
end

function WndEquipLottery:initRightContent()
	local showData = {}
	local mData = {}
	if self.m_batch[1] == 0 then
		return
	end
	for k,v in pairs(GDatatab_total_draw) do
		if v.type == self.m_lType and v.batch_pink == self.m_batch[1] then
			table.insert(showData,v)
		end
	end

	WZLog("批次显示的装备",Serialize(showData))
	local suitName = GetElement(self.m_root,"suitName_WndEquipLottery",WZUILabelTTF)
	for k,v in pairs(GDatatab_total_draw) do
		if v.item_id[1][1] == showData[1].item_id[1][1] and (v.batch_pink ~= 0 or v.batch_blue ~= 0) then
			local name = v.suit_name 
			suitName:setText(name)
		end
	end
	local tabCon = GetElement(self.m_root,"tabItem_WndEquipLottery",WZUITableContainer)
	tabCon:cleanTable()
	for i = 1,#showData do
		WZLog("显示的装备id",showData[i].item_id[1][1])
		local celElement,tLuaObj = CellGoodItem:createElement()
		if celElement and tLuaObj then
			celElement:setTag(i-1)
			tLuaObj:setCellGoodItem(GDatatab_item["id_"..showData[i].item_id[1][1]],17)
			tLuaObj:setItemClickFun(WndEquipLottery,self.onClickItem)
			tabCon:setCellElement(celElement)
		end
	end
end

function WndEquipLottery:onClickItem(tItem, nTag, tData)
	-- body
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil, true)	
end

--@brief 显示下一批次
function WndEquipLottery:showNext(element)
	WZLog("显示下一批次",self.m_batch[1],self.m_allBatch)
	self.m_batch[1] = self.m_batch[1] + 1
	if self.m_batch[1] > 4 then
		self.m_batch[1] = 1
	end
	self:initRightContent()
end

--@brief 显示上一批次
function WndEquipLottery:showPrevious(element)
	WZLog("显示上一批次",self.m_batch[1],self.m_allBatch)
	self.m_batch[1] = self.m_batch[1] - 1
	if self.m_batch[1] < 1 then
		self.m_batch[1] = 4
	end
	self:initRightContent()
end

--@brief 	点击限时特惠礼包按钮回调
function WndEquipLottery:OpenNewUserPackage(element)
	--body
	OpenNewUserPackage(element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	iphoneX适配
function WndEquipLottery:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftBtn_WndEquipLottery", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.93,0.5))
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndEquipLottery:_adaptLanguage_vn()
	local txtDesc = GetElement(self.m_root,"txtDesc_WndEquipLottery",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(400,0))
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,1))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.36))

	local txtTime = GetElement(self.m_root,"txtFreeTime",WZUILabelTTF)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.13,0.9))
	
	GetElement(self.m_root,"labelReward_WndEquipLottery",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.95))
end
-------------------------------------语言适配End----------------------------------------
