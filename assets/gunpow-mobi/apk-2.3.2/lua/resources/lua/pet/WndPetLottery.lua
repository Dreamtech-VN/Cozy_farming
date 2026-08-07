--WndPetLottery.lua
--@brief	WndPetLottery的UI模块
--@date		2021/05/28
--@author	hyc
--@note		宠物抽奖


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetLottery:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndRankList:regAll3()
	ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(2)
	AdaptLanguage(self)

	self:_adaptIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetLottery:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
	WndPets:getTime()
	-- SceneCity:updateZhaohuanRedDot(GlobalGame.g_tRedPointList.lottery1_redPoint,GlobalGame.g_tRedPointList.lottery2_redPoint,GlobalGame.g_tRedPointList.lottery3_redPoint,GlobalGame.g_tRedPointList.lottery4_redPoint)
	TeachGroup1:endTeachStep({12,6})
end


function WndPetLottery:onEnterTransitionDidFinish(element)
	self:_addTop()

end

--@brief 	触摸开始按钮
function WndPetLottery:onTouchBegan(element)
	-- body
	if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

function WndPetLottery:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/hlzd.png", self, self.onCloseClick, true, false, false, nil, {goldType = 16})
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
	local pinkIdcfg,PinkNumcfg = SplitItemString(mountDrawConfig["pinkPrice"])
	local pinkOneId,pinkOneNum = tonumber(pinkIdcfg[1]),tonumber(PinkNumcfg[1])
	local equipPriceId,equipPriceNum = SplitItemString(mountDrawConfig["petLotteryPrice"])
	local showId1,showNum1 = tonumber(equipPriceId[1]),tonumber(equipPriceNum[1])
	local showId2,showNum2 = tonumber(equipPriceId[2]),tonumber(equipPriceNum[2])
    tcell.goldCellInfo.tcell:showCoin({177,pinkOneId,showId1,showId2},{1,1,1,1})

    self.m_topCellLua = tcell
end

function WndPetLottery:onCloseClick() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    -- WindowManager:removeWindow(self.m_root, self, true)
	WndSummonEntrance:closeWin()

    self:onCloseClick2()
end


--@brief 	点击前往宠物按钮回调
function WndPetLottery:onClickGotoPet(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if WndPets.m_root == nil then
    	OpenPartner()
    else
    	WndPets:onClose()
    	OpenPartner()
    end
    self:onCloseClick2()
end

function WndPetLottery:onCloseClick2()
	WZLog("WndPetLottery:onCloseClick2")
    if WndPets.m_root then
    	WndPets.m_root:setVisible(true)
    end
    local bRefresh = true
    if WndPetsUpgrade.m_root ~= nil then
    	WZLog("WndPetLottery:onCloseClick22")
    	WndPetsUpgrade:setPetList()
    	bRefresh = false
    end
    if  WndPetsEvolution.m_root ~= nil then
    	WndPetsEvolution:initChoiceList()
    	WZLog("WndPetLottery:onCloseClick33")
    	bRefresh = false
    end
    if bRefresh then
    	WZLog("WndPetLottery:onCloseClick44")
    	WndPets:doRefresh()
    end
end

--@brief 查看召唤商店
function WndPetLottery:onClickLotteryStore(element)
	WZLog("WndPetLottery:onClickLotteryStore")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CheckButtonOpen(LOTTERY_SHOP) then
		WndStore:showStoreByType(3)
	end
end

--@brief 查看说明
function WndPetLottery:onClickExplain(element)
	-- body
	WZLog("WndPetLottery:onClickExplain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.EQUIPMENT_DRAW_EXPLAIN2)
end

--@brief 图鉴
function WndPetLottery:onClickHankShow(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndLotteryHank:showInterface(1)

end

--@brief 选择使用礼钻
function WndPetLottery:onChooseLizuan(element)
	self.m_usePinkDiamond = not self.m_usePinkDiamond
	self:initRightContent()
	self:onUpdateUi()
end

function WndPetLottery:onContinue(tag)
	-- body
	self.m_lotteryShowTag = nil
	self.m_lotteryShowTag = tag
	self:onClickLottery()
end

function WndPetLottery:upRedDot()
	-- body
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
	local num = mountDrawConfig["num"]
	local isShowRewardRed = self.m_lotteryNum >= num
    if isShowRewardRed ~= nil then
        WZLog("isOneRedDot1")
        local btn = GetElement(self.m_root, "conReward_WndPetLottery", WZUIContainer)
        SceneCity:setRedPoint(btn, isShowRewardRed, GlobalMethod:ccp(80,80),0.8)
    end	
	local costCommon,costCommonNum = SplitItemString(mountDrawConfig["petLotteryPrice"])
	local needId,needNum = tonumber(costCommon[1]),tonumber(costCommonNum[1])
	local needId1,needNum1 = tonumber(costCommon[2]),tonumber(costCommonNum[2])

	local CoinNum1 = CacheCenter:getPlayerItemCountById(needId)
	-- local CoinNum2 = CacheCenter:getPlayerItemCountById(needId1)
	-- local btnRed2 = CoinNum2 >= needNum
 --    if btnRed2 ~= nil then
 --        WZLog("isOneRedDot2")
 --        local btn = GetElement(self.m_root, "btn2_WndPetLottery", WZUIContainer)
 --        SceneCity:setRedPoint(btn, btnRed2, GlobalMethod:ccp(196,58),0.8)
 --    end	

    local btnRed1 = (self.m_freeTime <= 0 or CoinNum1 >= needNum)
     if btnRed1 ~= nil then
        WZLog("isOneRedDot4")
        local btn = GetElement(self.m_root, "btn1_WndPetLottery", WZUIContainer)
        SceneCity:setRedPoint(btn, btnRed1, GlobalMethod:ccp(196,58),0.8)
    end     

    WndPets:getTime()
end

function WndPetLottery:isHaveRed()
	-- body
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
	local costCommon,costCommonNum = SplitItemString(mountDrawConfig["petLotteryPrice"])
	local needId,needNum = tonumber(costCommon[1]),tonumber(costCommonNum[1])
	local needId1,needNum1 = tonumber(costCommon[2]),tonumber(costCommonNum[2])

	local CoinNum1 = CacheCenter:getPlayerItemCountById(needId)
	local CoinNum2 = CacheCenter:getPlayerItemCountById(needId1)
	local btnRed2 = CoinNum2 >= needNum
    local btnRed1 = (self.m_freeTime <= 0 or CoinNum1 >= needNum)
	
	if btnRed1 ~= nil or btnRed2 ~= nil then
		return true
	else 
		return false
	end
end

--@brief 抽奖
function WndPetLottery:onClickLottery(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_tag = self.m_lotteryShowTag or  element:getTag()

	self.m_nMaxNum = tonumber(CacheCenter:getGameParam()["petNumUpper"])
	local pets=CacheCenter:getPlayerPetInfo()

	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
	WZLog("点击抽奖",Serialize(mountDrawConfig))
	local pinkIdcfg,PinkNumcfg = SplitItemString(mountDrawConfig["pinkPrice"])
	local pinkOneId,pinkOneNum = tonumber(pinkIdcfg[1]),tonumber(PinkNumcfg[1])
	local pinkTenId,pinkTenNum = tonumber(pinkIdcfg[1]),tonumber(PinkNumcfg[2])

	local otherId,otherNum = SplitItemString(mountDrawConfig["petLotteryPrice"])
	local otherOneId,otherOneNum = tonumber(otherId[1]),tonumber(otherNum[1])
	local otherTowId,otherTowNum = tonumber(otherId[2]),tonumber(otherNum[2])
	local drawExchangeRate = json.decode(CacheCenter:getGameParam()["drawExchangeRate"])
	WZLog("抽奖比例",drawExchangeRate)
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
			if #pets > (self.m_nMaxNum - 1) then
				MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
				return
			end
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
		else 				
			if CoinNum >= otherOneNum then
				if #pets > (self.m_nMaxNum - 10) then
					MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
					return
				end
				WZLog("钥匙10抽",CoinNum,otherOneNum)
				ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
			elseif otherOneNum <= CoinNum  and CoinNum < otherOneNum * 10 then
				if #pets > (self.m_nMaxNum - 1) then
					MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
					return
				end
				WZLog("钥匙1抽",CoinNum,otherOneNum)
				ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
			elseif otherOneNum > CoinNum then
				WZLog("钥匙不足",CoinNum,otherOneNum)
			 	MsgBoxManager:showTipBox(LocalStrings.LOTTERY_TEXT7)
			 	WndFastGetItems:show(otherOneId)
			end
		end
		TeachGroup1:endTeachStep({12,4})
	elseif self.m_tag == 2 then
		CoinNum = CacheCenter:getPlayerItemCountById(pinkOneId)
		if CoinNum >= pinkOneNum then --金召唤币
			if #pets > (self.m_nMaxNum - 1) then
				MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
				return
			end
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
		else --越南粉钻代替
			local needPinkNum = pinkOneNum2 - CoinNum * drawExchangeRate
			if vnPinkDiamond >= needPinkNum then
				if #pets > (self.m_nMaxNum - 1) then
					MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
					return
				end
				if not JudgeMoneyIsEnough(pinkOneId,pinkOneNum, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead,1) then
					return
				end
			else
				if not JudgeMoneyIsEnough(pinkOneId,pinkOneNum, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead1,1) then
					return
				end
			end
		end
		TeachGroup1:endTeachStep({12,5})
	elseif self.m_tag == 3 then
		CoinNum = CacheCenter:getPlayerItemCountById(pinkTenId)
		if CoinNum >= pinkTenNum then --金召唤币
			if #pets > (self.m_nMaxNum - 10) then
				MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
				return
			end
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,lotteryType,self.m_batch[1])
		else --越南粉钻代替
			local needPinkNum = pinkTenNum2 - CoinNum * drawExchangeRate
			if vnPinkDiamond >= needPinkNum then
				if #pets > (self.m_nMaxNum - 10) then
					MsgBoxManager:showTipBox(LocalStrings.PETMAXNUM)
					return
				end
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

function WndPetLottery:sureUseDiamondInstead1()
	-- body
	if not JudgeMoneyIsEnough(177, needBlueNum, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE_VN, nil, Chat_Channel_Card, nil, nil, nil, nil, self, self.sureUseDiamondInstead1) then
		return
	end
end

function WndPetLottery:sureUseDiamondInstead()
	-- body
	ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,1,self.m_batch[1])
end

--@brief 领取自选礼包
function WndPetLottery:onClickReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward(self.m_lType)
end

--@brief 初始化界面
function WndPetLottery:onUpdateUi()
	local playerLevel = CacheCenter:getPlayerInfo().level
	local btnStore = GetElement(self.m_root,"btnStore_WndPetLottery",WZUIContainer)
	btnStore:setVisible(false)
	WZLog("进来了1",playerLevel,GDatatab_button_info["id_"..206].show_level)
	if playerLevel >= GDatatab_button_info["id_"..206].show_level then
		btnStore:setVisible(true)
	end
	-- self.m_root:enableSchedule("scheduleUpdateRaffleTime",1)
	local refreshTime = GetElement(self.m_root,"txtRefresh_WndPetLottery",WZUILabelTTF)
	local leaveTime = self:formatTime(self.m_reTime)
	refreshTime:setText(leaveTime)
	WZLog("进来了1")
	--equipDrawConfig
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
	WZLog("宠物抽奖系统配置",Serialize(mountDrawConfig))
	local num1 = mountDrawConfig["num"]
	local txtFormat1 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="163,74,20" SS="4" SE="1">%s</T>]]
	local txtFormat2 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="0,108,3" SS="4" SE="1">%d</T>]]

	local txtFormat3 = GetElement(self.m_root,"TxtCommon_WndPetLottery",WZUIFreeTextBox)
	local txtFormat31 = GetElement(self.m_root,"TxtCommon1_WndPetLottery",WZUILabelTTF)
	local costCommon,costCommonNum = SplitItemString(mountDrawConfig["petLotteryPrice"])
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
	WZLog("进来了1")
	local txtOne = GetElement(self.m_root,"TxtOne_WndPetLottery",WZUIFreeTextBox)
	local txtOne1 = GetElement(self.m_root,"TxtOne1_WndPetLottery",WZUILabelTTF)
	local itemId,num = SplitItemString(mountDrawConfig["pinkPrice"])
	local costOneId,costOneNum = tonumber(itemId[1]),tonumber(num[1])
	local haveOneNum = CacheCenter:getPlayerItemCountById(costOneId)
	local haveOneNum1 = CacheCenter:getPlayerItemCountById(needId1)
	local iconPath1 = GDatatab_item["id_"..costOneId].icon
	local iconPath4 = GDatatab_item["id_"..needId1].icon
	txtOne:setShowText(string.format(txtFormat1,iconPath1,costOneNum))
	-- if needNum1 > haveOneNum1 then
	-- 	txtOne1:setText(LocalStrings.ONE_LOTTERY)
	-- 	txtOne:setShowText(string.format(txtFormat1,iconPath1,math.floor(costOneNum)))
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
	WZLog("进来了1")
	local txtTen = GetElement(self.m_root,"txtTen_WndPetLottery",WZUIFreeTextBox)
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

	local reward = json.decode(mountDrawConfig["raward"])
	local conNode = GetElement(self.m_root,"conReward_WndPetLottery",WZUIContainer)
	local labelReward = GetElement(self.m_root,"labelReward_WndPetLottery",WZUILabelTTF)
	if num1 > self.m_lotteryNum then
		labelReward:setText(string.format(LocalStrings.NEED_LOTTERY_REWARD,num1 - self.m_lotteryNum))
	else 
		labelReward:setText(LocalStrings.GET_LOTTERY_REWARD)
	end

	local freeTime = GetElement(self.m_root,"txtFreeTime",WZUILabelTTF)
	local freeTime1 = GetElement(self.m_root,"txtFreeTime1",WZUILabelTTF)
	if self.m_freeTime <= 0 then
		freeTime:setVisible(false)
		freeTime1:setVisible(false)
	else 
		freeTime:setVisible(true)
		freeTime1:setVisible(true)
		self.m_root:enableSchedule("scheduleUpdateRaffleTime",1)
		local leaveTime = self:formatTime1(self.m_freeTime)
		freeTime:setText(leaveTime)	
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
        tLuaObj:setItemClickFun(WndPetLottery,self.onItemClick)
    end

end

--奖励轮换定时器
function WndPetLottery:scheduleUpdateRaffleTime(element)
	self.m_freeTime = self.m_freeTime -1
	if self.m_freeTime <=0 then
		element:disableSchedule()
	end
	local freeTime = self:formatTime1(self.m_freeTime)
    local txtTime = GetElement(self.m_root,"txtFreeTime",WZUILabelTTF)
    txtTime:setText(freeTime)
end

--@brief 点击自选礼包，可领取直接领取，不可领取时弹出tips
function WndPetLottery:onItemClick(tCell,tag,tData)
	-- body
	if tData == nil then return end
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
	local num = mountDrawConfig["num"]
	WZLog("点击自选礼包1",self.m_lotteryNum)
	WZLog("点击自选礼包2",num)
	if self.m_lotteryNum >= num then
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward(self.m_lType)
	else 
    	WndItemInfo:onCloseClick()
    	WndItemInfo:showInfo(tCell.m_root,WndPetLottery.m_root,1,tData,false,nil,true)	
    end 	
end

function WndPetLottery:initRightContent()
	local showData = {}
	if self.m_usePinkDiamond then
		--使用礼钻，展示礼钻批次
		for k,v in pairs(GDatatab_total_draw) do
			if v.type == self.m_lType and v.batch_pink == self.m_batch[1] then
				table.insert(showData,v)
			end
		end
	else 
		--蓝钻批次
		for k,v in pairs(GDatatab_total_draw) do
			if v.type == self.m_lType and v.batch_blue == self.m_batch[2] then
				table.insert(showData,v)
			end
		end
	end
	WZLog("批次显示的宠物",Serialize(showData))
	if showData and next(showData) then
		for i,v in pairs(showData) do
			-- local animation_index_code = GDatatab_item["id_"..v.item_id[1][1]].animation_index_code
			local animation_index_code
			for k,x in pairs(GDatatab_pet_advanced) do
				if x.item_id == v.item_id[1][1] and x.level == 7 then
					animation_index_code = x.animation
				end
			end
			local conNode = GetElement(self.m_root,"conNode"..i.."_WndPetLottery",WZUIContainer)
			local txtName = GetElement(self.m_root,"name"..i,WZUILabelTTF)
			local name = GDatatab_item["id_"..showData[i].item_id[1][1]].name
			txtName:setText(name)
			local petAni = CreatePetAni(conNode, nil, animation_index_code)
		end
	end
end

--@brief 点击领取自选
function WndPetLottery:onGetReward(element)
	-- body
	
	local needNum = json.decode(CacheCenter:getGameParam()["petDrawConfig"])
	local num = needNum["num"]

	WZLog("点击领取自选",self.m_lotteryNum,num)
	if self.m_lotteryNum >= num then
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward(self.m_lType)
		self.m_lotteryNum = self.m_lotteryNum - num
	end	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	iphoneX适配
function WndPetLottery:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftBtn_WndPetLottery", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.93,0.5))
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndPetLottery:_adaptLanguage_vn()
	local txtDesc = GetElement(self.m_root,"txtDesc_WndPetLottery",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(400,0))
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,1))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.36))
	
	local txtTime = GetElement(self.m_root,"txtFreeTime",WZUILabelTTF)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.13,0.9))

	GetElement(self.m_root,"labelReward_WndPetLottery",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.95))
end
-------------------------------------语言适配End----------------------------------------
