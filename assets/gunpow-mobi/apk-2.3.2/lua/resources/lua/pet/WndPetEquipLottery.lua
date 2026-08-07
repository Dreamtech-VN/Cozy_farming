--WndPetEquipLottery.lua
--@brief	WndPetEquipLottery的UI模块
--@date		2022/05/18
--@author	yrd
--@note		宠物装备召唤


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetEquipLottery:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndRankList:regAll3()

	self:_adaptIphoneX()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetEquipLottery:onExit(element)
	self:_unInit()
end

function WndPetEquipLottery:onEnterTransitionDidFinish(element)
	self:_addTop()

	ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(6)
end

--@brief 	触摸开始按钮
function WndPetEquipLottery:onTouchBegan(element)
	if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

function WndPetEquipLottery:onCloseClick() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WndSummonEntrance:closeWin()

	WndPetEquipLottery:onCloseClick2()
end

function WndPetEquipLottery:onCloseClick2()
	WZLog("WndPetEquipLottery:onCloseClick2")
	if WndPetsEquipment.m_root then
	    WndPetsEquipment:updateCurPetInfo()
	end
end

function WndPetEquipLottery:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_xyzh.png", self, self.onCloseClick, true, false, false, nil, {goldType = 16})
	local petequipDrawConfig = json.decode(CacheCenter:getGameParam()["petequipDrawConfig"])
	local pinkIdcfg,PinkNumcfg = SplitItemString(petequipDrawConfig["pinkPrice"])
	local pinkOneId,pinkOneNum = tonumber(pinkIdcfg[1]),tonumber(PinkNumcfg[1])
	local equipPriceId,equipPriceNum = SplitItemString(petequipDrawConfig["bluePrice"])
	local showId1,showNum1 = tonumber(equipPriceId[1]),tonumber(equipPriceNum[1])
	local showId2,showNum2 = tonumber(equipPriceId[2]),tonumber(equipPriceNum[2])
    tcell.goldCellInfo.tcell:showCoin({1,70,showId1,pinkOneId},{1,1,1,1})
    self.m_topCellLua = tcell
end

--@brief 更新最大批次
function WndPetEquipLottery:updateAllBatch()
	for k,v in pairs(GDatatab_total_draw) do
		local tempbatch
		if self.m_usePinkDiamond then
			tempbatch = v.batch_pink
		else
			tempbatch = v.batch_blue
		end

		if self.m_allBatch == nil then
			self.m_allBatch = 0
		end
		if self.m_lType == v.type and tempbatch > self.m_allBatch then
			self.m_allBatch = tempbatch
		end
	end
	WZLog("最大批次",self.m_allBatch)
end

--@brief 奖池礼包
function WndPetEquipLottery:upRedDot()
	local petequipDrawConfig = json.decode(CacheCenter:getGameParam()["petequipDrawConfig"])
	local num = petequipDrawConfig["num"]
	local isShowRewardRed = self.m_lotteryNum >= num
    if isShowRewardRed ~= nil then
        WZLog("isOneRedDot1")
        local btn = GetElement(self.m_root, "conReward_WndPetEquipLottery", WZUIContainer)
        SceneCity:setRedPoint(btn, isShowRewardRed, GlobalMethod:ccp(80,80),0.8)
    end	   
end

--@brief 初始化界面
function WndPetEquipLottery:updateUI()
	local txtDesc = GetElement(self.m_root,"txtDesc_WndPetEquipLottery",WZUILabelTTF)
	local conShowReward = GetElement(self.m_root,"conShowReward_WndPetEquipLottery",WZUIContainer)
	if self.m_usePinkDiamond then
		txtDesc:setText(LocalStrings.PET_EQUIPMENT_LOTTERY_3)
		conShowReward:setVisible(false)
	else 
		txtDesc:setText(LocalStrings.PET_EQUIPMENT_LOTTERY_4)
		conShowReward:setVisible(true)
	end

	local petequipDrawConfig = json.decode(CacheCenter:getGameParam()["petequipDrawConfig"])
	local num1 = petequipDrawConfig["num"]
	local itemId,num
	if self.m_usePinkDiamond then
		itemId,num = SplitItemString(petequipDrawConfig["pinkPrice"])
	else 
		itemId,num = SplitItemString(petequipDrawConfig["bluePrice"])
	end

	local txtFormat1 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	local txtFormat2 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="0,108,3" SS="4" SE="1">%d</T>]]

	local txtOne = GetElement(self.m_root,"txtOne_WndPetEquipLottery",WZUIFreeTextBox)
	local costOneId,costOneNum = tonumber(itemId[1]),tonumber(num[1])
	local iconPath1 = GDatatab_item["id_"..costOneId].icon
	txtOne:setShowText(string.format(txtFormat1,iconPath1,costOneNum))

	local txtTen = GetElement(self.m_root,"txtTen_WndPetEquipLottery",WZUIFreeTextBox)
	local costTenId,costTenNum = tonumber(itemId[2]),tonumber(num[2])
	local iconPath2 = GDatatab_item["id_"..costTenId].icon
	txtTen:setShowText(string.format(txtFormat2,iconPath2,costTenNum))


	local reward = json.decode(petequipDrawConfig["raward"])
	WZLog("宠物装备抽奖系统配置",Serialize(pinkPrice),num,self.m_lotteryNum,Serialize(reward))
	local conNode = GetElement(self.m_root,"conReward_WndPetEquipLottery",WZUIContainer)
	local labelReward = GetElement(self.m_root,"labelReward_WndPetEquipLottery",WZUILabelTTF)
	if num1 > self.m_lotteryNum then
		labelReward:setText(string.format(LocalStrings.PET_EQUIPMENT_13,self.m_lotteryNum,num1))
	else 
		labelReward:setText(LocalStrings.GET_LOTTERY_REWARD)
	end

	
	local txtTitle = GetElement(self.m_root,"txtTitle_WndPetEquipLottery",WZUILabelTTF)
	if self.m_usePinkDiamond then
		txtTitle:setVisible(false)
	else
		txtTitle:setVisible(true)
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
        tLuaObj:setItemClickFun(WndPetEquipLottery,self.onItemClick)
    end
end

--@brief 点击自选礼包，可领取直接领取，不可领取时弹出tips
function WndPetEquipLottery:onItemClick(tCell,tag,tData)
	-- body
	if tData == nil then return end
	local petequipDrawConfig = json.decode(CacheCenter:getGameParam()["petequipDrawConfig"])
	local num = petequipDrawConfig["num"]
	WZLog("点击自选礼包1",self.m_lotteryNum)
	WZLog("点击自选礼包2",num)
	if self.m_lotteryNum >= num then
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward(self.m_lType)
	else 
    	WndItemInfo:onCloseClick()
    	WndItemInfo:showInfo(tCell.m_root,WndPetEquipLottery.m_root,1,tData,false,nil,true)	
    end 	
end

--@brief 套装展示
function WndPetEquipLottery:initRightContent()
	local showDataPink = {}
	local showDataBlue = {}
	local showDataEquip = {}
	if self.m_usePinkDiamond then
		--银币召唤
		for k,v in pairs(GDatatab_total_draw) do
			if v.type == self.m_lType and v.batch_pink == self.m_curBatch then
				table.insert(showDataPink,v)
			end
		end
		showDataEquip = showDataPink
	else
		--金币召唤
		for k,v in pairs(GDatatab_total_draw) do
			if v.type == self.m_lType and v.batch_blue == self.m_curBatch then
				table.insert(showDataBlue,v)
			end
		end
		showDataEquip = showDataBlue
	end

	local suitName = GetElement(self.m_root,"suitName_WndPetEquipLottery",WZUILabelTTF)
	if showDataEquip[1] then
		suitName:setText(showDataEquip[1].suit_name)
	end

	local tabItem = GetElement(self.m_root,"tabItem_WndPetEquipLottery",WZUITableContainer)
	tabItem:cleanTable()
	for i = 1,#showDataEquip do
		WZLog("WndPetEquipLottery:initRightContent id",showDataEquip[i].item_id[1][1])
		local celElement,tLuaObj = CellGoodItem:createElement()
		if celElement and tLuaObj then
			celElement:setTag(i-1)
			local tDataTemp = {}
			tDataTemp.basicInfo = CopyTable(GDatatab_item["id_"..showDataEquip[i].item_id[1][1]])
		    if self.m_usePinkDiamond then 
		    	tDataTemp.origin = 120008
		    else
    			tDataTemp.origin = 120009
		    end
			tLuaObj:setCellGoodItem(tDataTemp, 17)
			tLuaObj:setItemClickFun(WndPetEquipLottery,self.onClickItem)
			tabItem:setCellElement(celElement)
		end
	end
end

--@brief 点击物品
function WndPetEquipLottery:onClickItem(tItem, nTag, tData)
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil, true)	
end

--@brief 继续抽奖
function WndPetEquipLottery:onContinue(tag)
	-- body
	self.m_lotteryShowTag = nil
	self.m_lotteryShowTag = tag
	self:onClickLottery()
end

--@brief 抽奖
function WndPetEquipLottery:onClickLottery(element)
	local petequipDrawConfig = json.decode(CacheCenter:getGameParam()["petequipDrawConfig"])
	local blueNum = CacheCenter:getMoneyList().blueDiamond
	local pinkNum = CacheCenter:getMoneyList().ticket
	local CoinNum = 0
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local drawExchangeRate = json.decode(CacheCenter:getGameParam()["drawExchangeRate"])

	self.m_tag = self.m_lotteryShowTag or element:getTag()
	self.m_consumeType = 0
	local costId = 0
	local constNum = 0

	if self.m_usePinkDiamond then
		self.m_consumeType = 1
	else 
		self.m_consumeType = 2
	end
	if self.m_consumeType == 1 then
		local itemId,num = SplitItemString(petequipDrawConfig["pinkPrice"])
		if self.m_tag == 2 then
			costId,costNum = tonumber(itemId[1]),tonumber(num[1])	
		else
			costId,costNum = tonumber(itemId[2]),tonumber(num[2])
		end
		costNum = costNum * drawExchangeRate
		CoinNum = CacheCenter:getPlayerItemCountById(costId)
		if CoinNum * drawExchangeRate < costNum then
			local needNum1 = costNum - CoinNum * drawExchangeRate
			if pinkNum< needNum1 then
				local needNum2 = needNum1 - pinkNum
				if blueNum < needNum2 then
					if not JudgeMoneyIsEnough(costId,needNum2, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead1,3,pinkNum) then
						return
					end
				else 
					if not JudgeMoneyIsEnough(costId,needNum2, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead,3,pinkNum) then
						return
					end
				end
			else 
				if not JudgeMoneyIsEnough(costId, needNum1, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead,1) then
					return
				end
			end
		else
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,self.m_consumeType,self.m_batch[self.m_consumeType])
		end
	elseif self.m_consumeType == 2 then
		local itemId,num = SplitItemString(petequipDrawConfig["bluePrice"])
		if self.m_tag == 2 then
			costId,costNum = tonumber(itemId[1]),tonumber(num[1])	
		else
			costId,costNum = tonumber(itemId[2]),tonumber(num[2])
		end
		costNum = costNum * drawExchangeRate
		CoinNum = CacheCenter:getPlayerItemCountById(costId)
		if CoinNum * drawExchangeRate < costNum then
			local needNum1 = costNum - CoinNum *drawExchangeRate
			WZLog("金召唤币10chou",needNum1)
			if blueNum < needNum1 then
				if not JudgeMoneyIsEnough(costId,needNum1, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead1,2) then
					return
				end					
			else 
				if not JudgeMoneyIsEnough(costId,needNum1, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead,2) then
					return
				end					
			end

		else
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,self.m_consumeType,self.m_batch[self.m_consumeType])
		end
	end   			
end

function WndPetEquipLottery:sureUseDiamondInstead1()
	if not JudgeMoneyIsEnough(1, needBlueNum, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, nil, Chat_Channel_Card, nil, nil, nil, nil, self, self.sureUseDiamondInstead1) then
		return
	end
end

function WndPetEquipLottery:sureUseDiamondInstead()
	ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,self.m_consumeType,self.m_batch[self.m_consumeType])
end

--@brief 显示下一批次
function WndPetEquipLottery:showNext(element)
	self.m_curBatch = self.m_curBatch + 1
	if self.m_curBatch > self.m_allBatch then
		self.m_curBatch = 1
	end
	self:initRightContent()
end

--@brief 显示上一批次
function WndPetEquipLottery:showPrevious(element)
	self.m_curBatch = self.m_curBatch - 1
	if self.m_curBatch < 1 then
		self.m_curBatch = self.m_allBatch
	end
	self:initRightContent()
end

--@brief 查看说明
function WndPetEquipLottery:onClickExplain(element)
	WZLog("WndPetEquipLottery:onClickExplain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.PET_EQUIPMENT_LOTTERY_2)
end

--@brief 前往皮肤
--@brief 	点击前往装备按钮回调
function WndPetEquipLottery:onClickGotoEquip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if CheckButtonShow(222) then
		WndPets:showInterface(1,2)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	iphoneX适配
function WndPetEquipLottery:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftBtn_WndPetEquipLottery", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.93,0.5))
	end
end




-------------------------------------私有方法模块End----------------------------------------



function WndPetEquipLottery:_adaptLanguage_vn()
	local txtDesc = GetElement(self.m_root,"txtDesc_WndPetEquipLottery",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(400,0))
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,1))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.36))
	txtDesc:setText(LocalStrings.CRAZY_GASHAPON_TEXT6)
end
