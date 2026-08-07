--WndMountLottery.lua
--@brief	WndMountLottery的UI模块
--@date		2021/04/23
--@author	hyc
--@note		坐骑抽奖


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMountLottery:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndRankList:regAll3()
	AdaptLanguage(self)
	self:_adaptIphoneX()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMountLottery:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end


function WndMountLottery:onEnterTransitionDidFinish(element)
	self:_addTop()
	self:initUi()
	ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(3)
end

--初始化页面
function WndMountLottery:initUi()
	-- body
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
	local itemId,num = SplitItemString(mountDrawConfig["bluePrice"])
	local oneTxt = GetElement(self.m_root,"TxtOne_WndMountLottery",WZUIFreeTextBox)
	local tenTxt = GetElement(self.m_root,"txtTen_WndMountLottery",WZUIFreeTextBox)
	WZLog("初始化页面",Serialize(itemId),Serialize(num))
end

--@brief 	触摸开始按钮
function WndMountLottery:onTouchBegan(element)
	-- body
	if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

function WndMountLottery:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_zqzh.png", self, self.onCloseClick, true, false, false, nil, {goldType = 16})
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
	local pinkIdcfg,PinkNumcfg = SplitItemString(mountDrawConfig["pinkPrice"])
	local pinkOneId,pinkOneNum = tonumber(pinkIdcfg[1]),tonumber(PinkNumcfg[1])
	local equipPriceId,equipPriceNum = SplitItemString(mountDrawConfig["bluePrice"])
	local showId1,showNum1 = tonumber(equipPriceId[1]),tonumber(equipPriceNum[1])
	local showId2,showNum2 = tonumber(equipPriceId[2]),tonumber(equipPriceNum[2])
    tcell.goldCellInfo.tcell:showCoin({1,177,showId1,pinkOneId},{1,1,1,1})
    self.m_topCellLua = tcell
end

function WndMountLottery:onCloseClick() 
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	-- WindowManager:removeWindow(self.m_root, self, true)
	WndSummonEntrance:closeWin()
end

--@brief 前往坐骑
function WndMountLottery:gotoMount(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if WndPets.m_root == nil then
    	OpenPartner(2)
    	WndPets:showInterface(2,1)
    else
    	WndPets:onClose()
    	OpenPartner(2)
    	WndPets:showInterface(2,1)
    end
end

--@brief 查看召唤商店
function WndMountLottery:onClickLotteryStore(element)
	WZLog("WndPetLottery:onClickLotteryStore")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("查看召唤商店",CheckButtonOpen(LOTTERY_SHOP))
	if CheckButtonOpen(LOTTERY_SHOP) then
		WndStore:showStoreByType(12)
	end
end

--@brief 查看说明
function WndMountLottery:onClickExplain(element)
	-- body
	WZLog("WndMountLottery:onClickExplain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_usePinkDiamond then
		WndSingleMapDesc:showInterface1(LocalStrings.EQUIPMENT_DRAW_EXPLAIN6)
	else 
		WndSingleMapDesc:showInterface1(LocalStrings.EQUIPMENT_DRAW_EXPLAIN3)
	end
end

--@brief 图鉴
function WndMountLottery:onClickHankShow(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndLotteryHank:showInterface(2)

end

--@brief 选择使用礼钻
function WndMountLottery:onChooseLizuan(element)
	self.m_usePinkDiamond = not self.m_usePinkDiamond
	self:showPinkMount()	
	self:onUpdateUi()
end

--@brief 是否展示粉钻批次
function WndMountLottery:showPinkMount(isBool)
	-- body
	if self.m_usePinkDiamond then
		GetElement(self.m_root,"conNodeOne_WndMountLottery",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conNodeTow_WndMountLottery",WZUIContainer):setVisible(false)
	else 
		GetElement(self.m_root,"conNodeOne_WndMountLottery",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conNodeTow_WndMountLottery",WZUIContainer):setVisible(true)
	end
end

function WndMountLottery:onContinue(tag)
	-- body
	self.m_lotteryShowTag = nil
	self.m_lotteryShowTag = tag
	self:onClickLottery()
end

--@brief 抽奖
function WndMountLottery:onClickLottery(element)
	-- body
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
	local blueNum = CacheCenter:getMoneyList().blueDiamond
	local pinkNum = CacheCenter:getMoneyList().ticket
	local vnPinkDiamond = CacheCenter:getMoneyList().vnPinkDiamond
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
		local itemId,num = SplitItemString(mountDrawConfig["pinkPrice"])
		if self.m_tag == 2 then
			costId,costNum = tonumber(itemId[1]),tonumber(num[1])	
		else
			costId,costNum = tonumber(itemId[2]),tonumber(num[2])
		end

		if CacheCenter:getGameParam().isUseTicket == "1" then --不使用双货币
			costId,costNum = tonumber(itemId[1]),tonumber(num[2])
			pinkNum = 0
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
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,self.m_consumeType,0)
		end
	elseif self.m_consumeType == 2 then
		local itemId,num = SplitItemString(mountDrawConfig["bluePrice"])
		if self.m_tag == 2 then
			costId,costNum = tonumber(itemId[1]),tonumber(num[1])	
		else
			costId,costNum = tonumber(itemId[2]),tonumber(num[2])
		end
		costNum2 = costNum * drawExchangeRate
		CoinNum = CacheCenter:getPlayerItemCountById(costId)
		if CoinNum < costNum then
			local needNum1 = costNum2 - CoinNum *drawExchangeRate
			WZLog("金召唤币10chou",needNum1)
			if vnPinkDiamond < needNum1 then
				if not JudgeMoneyIsEnough(costId,costNum, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead1,2) then
					return
				end				
			else 
				if not JudgeMoneyIsEnough(costId,costNum, nil, nil, 151, nil, nil, nil, nil, self, self.sureUseDiamondInstead,2) then
					return
				end					
			end

		else 
			ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,self.m_consumeType,0)
		end
	end   			
end

function WndMountLottery:upRedDot()
	-- body
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
	local num = mountDrawConfig["num"]
	local isShowRewardRed = self.m_lotteryNum >= num
    if isShowRewardRed ~= nil then
        WZLog("isOneRedDot1")
        local btn = GetElement(self.m_root, "conReward_WndMountLottery", WZUIContainer)
        SceneCity:setRedPoint(btn, isShowRewardRed, GlobalMethod:ccp(80,80),0.8)
    end	   
end

function WndMountLottery:sureUseDiamondInstead1()
	-- body
	if not JudgeMoneyIsEnough(177, needBlueNum, LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE_VN, nil, Chat_Channel_Card, nil, nil, nil, nil, self, self.sureUseDiamondInstead1) then
		return
	end
end

function WndMountLottery:sureUseDiamondInstead()
	-- body
	ProtocolProcessorWndRankList:send_PLAYER2_Lottery(self.m_lType,self.m_tag,self.m_consumeType,0)
end

--@brief 初始化界面
function WndMountLottery:onUpdateUi()
	-- body
	self.m_root:enableSchedule("scheduleUpdateRaffleTime",1)
	local refreshTime = GetElement(self.m_root,"txtRefresh_WndMountLottery",WZUILabelTTF)
	local leaveTime = self:formatTime(self.m_reTime)
	refreshTime:setText(leaveTime)
	local txtDesc = GetElement(self.m_root,"txtDesc_WndMountLottery",WZUILabelTTF)
	local conRewrad = GetElement(self.m_root,"conShowReward_WndMountLottery",WZUIContainer)
	conRewrad:setVisible(true)
	if self.m_usePinkDiamond then
		txtDesc:setText(LocalStrings.LOTTERY_MOUNT5)
		conRewrad:setVisible(false)
	else 
		txtDesc:setText(LocalStrings.LOTTERY_MOUNT)
	end
	--equipDrawConfig
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
	local num1 = mountDrawConfig["num"]
	local drawExchangeRate = json.decode(CacheCenter:getGameParam()["drawExchangeRate"])

	local txtFormat1 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="163,74,20" SS="4" SE="1">%d</T>]]
	local txtFormat2 = [[<I Z="0.5" P="1" >%s</I><T S="22" C="255,250,236" P="1" SC="0,108,3" SS="4" SE="1">%d</T>]]
	local txtOne = GetElement(self.m_root,"TxtOne_WndMountLottery",WZUIFreeTextBox)
	local itemId,num
	if self.m_usePinkDiamond then
		itemId,num = SplitItemString(mountDrawConfig["pinkPrice"])
	else 
		itemId,num = SplitItemString(mountDrawConfig["bluePrice"])
	end
	local costOneId,costOneNum = tonumber(itemId[1]),tonumber(num[1])
	-- local iconPath1 = GDatatab_item["id_"..costOneId].icon
	local iconPath1 = GDatatab_item["id_"..costOneId].icon
	txtOne:setShowText(string.format(txtFormat1,iconPath1,costOneNum))

	local txtTen = GetElement(self.m_root,"txtTen_WndMountLottery",WZUIFreeTextBox)
	local costTenId,costTenNum = tonumber(itemId[2]),tonumber(num[2])
	-- local iconPath2 = GDatatab_item["id_"..costTenId].icon
	local iconPath2 = GDatatab_item["id_"..costTenId].icon
	txtTen:setShowText(string.format(txtFormat2,iconPath2,costTenNum))


	local reward = json.decode(mountDrawConfig["raward"])
	WZLog("坐骑抽奖系统配置",Serialize(pinkPrice),num,self.m_lotteryNum,Serialize(reward))
	local conNode = GetElement(self.m_root,"conReward_WndMountLottery",WZUIContainer)
	local labelReward = GetElement(self.m_root,"labelReward_WndMountLottery",WZUILabelTTF)
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
        tLuaObj:setItemClickFun(WndMountLottery,self.onItemClick)
    end

end

--奖励轮换定时器
function WndMountLottery:scheduleUpdateRaffleTime(element)
	self.m_reTime = self.m_reTime -1
	if self.m_reTime <=0 then
		element:disableSchedule()
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryInfo(3)
	end
	local leaveTime = self:formatTime(self.m_reTime)
    local txtTime1 = GetElement(self.m_root,"txtRefresh_WndMountLottery",WZUILabelTTF)
    txtTime1:setText(leaveTime)
end


--@brief 点击自选礼包，可领取直接领取，不可领取时弹出tips
function WndMountLottery:onItemClick(tCell,tag,tData)
	-- body
	if tData == nil then return end
	local mountDrawConfig = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
	local num = mountDrawConfig["num"]
	WZLog("点击自选礼包1",self.m_lotteryNum)
	WZLog("点击自选礼包2",num)
	if self.m_lotteryNum >= num then
		ProtocolProcessorWndRankList:send_PLAYER2_GetLotteryReward(self.m_lType)
	else 
    	WndItemInfo:onCloseClick()
    	WndItemInfo:showInfo(tCell.m_root,WndMountLottery.m_root,1,tData,false,nil,true)	
    end 	
end

function WndMountLottery:initRightContent()
	local showDataPink = {}
	local showDataBlue = {}
	-- if self.m_usePinkDiamond then
		--使用礼钻，展示礼钻批次
		for k,v in pairs(GDatatab_total_draw) do
			if v.type == self.m_lType and v.batch_pink == self.m_batch[1] then
				table.insert(showDataPink,v)
			end
		end
	-- else 
		--蓝钻批次
		for k,v in pairs(GDatatab_total_draw) do
			WZLog("蓝钻批次",v.type,self.m_lType,v.batch_blue,self.m_batch[2])
			if v.type == self.m_lType and v.batch_blue == self.m_batch[2] then
				table.insert(showDataBlue,v)
			end
		end
	-- end
	WZLog("批次显示的粉钻坐骑",Serialize(showDataPink))
	if showDataPink and next(showDataPink) then
		for i = 1,3 do
			local conNode = GetElement(self.m_root,"conNode"..i.."_WndMountLottery",WZUIContainer)
			local txtName = GetElement(self.m_root,"name"..i,WZUILabelTTF)
			local name = GDatatab_item["id_"..showDataPink[i].item_id[1][1]].name
			txtName:setText(name)
			self:_createMountAni(conNode,showDataPink[i])
		end
	end

	WZLog("批次显示的蓝钻坐骑",Serialize(showDataBlue))
	if showDataBlue and next(showDataBlue) then
		for i = 1,3 do
			local conNode = GetElement(self.m_root,"conNode1"..i.."_WndMountLottery",WZUIContainer)
			local txtName = GetElement(self.m_root,"name1"..i,WZUILabelTTF)
			local name = GDatatab_item["id_"..showDataBlue[i].item_id[1][1]].name
			txtName:setText(name)
			self:_createMountAni(conNode,showDataBlue[i])
		end
	end

end

-- 坐骑动画
function WndMountLottery:_createMountAni(con,info)

    local sex = CacheCenter:getPlayerInfo().sex 
    if con:getChildByTag(99) then con:removeChildByTag(99,true) end

    local head,body = CacheCenter:getHeadAndBodyColor()
    local ani = CreatePlayerFigure(sex, nil, "mount_show",nil,nil,nil,nil,nil,nil,nil,head,body,false)
    local animation_index_code = GDatatab_item["id_"..info.item_id[1][1]].animation_index_code
    ani:setMount(animation_index_code)

    local node = ani:getAnimNode()
    node:setScale(0.6)
    node:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    node:setRelativePosition(GlobalMethod:ccp(0.5,0))
    con:addChild(node,0,99)
    -- con:setScale(0)
    -- local scaleTo = CCScaleTo:create(0.5,1,1)

    -- con:runAction(scaleTo)
end

--@brief 点击领取自选
function WndMountLottery:onGetReward(element)
	-- body
	
	local needNum = json.decode(CacheCenter:getGameParam()["mountDrawConfig"])
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
function WndMountLottery:_adaptIphoneX()
	if IsIphoneX() then
		GetElement(self.m_root, "conLeftBtn_WndMountLottery", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.93,0.5))
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndMountLottery:_adaptLanguage_vn()
	local txtDesc = GetElement(self.m_root,"txtDesc_WndMountLottery",WZUILabelTTF)
	txtDesc:setScale(0.8)
	txtDesc:setDimensions(GlobalMethod:CCSize(400,0))
	txtDesc:setAnchorPoint(GlobalMethod:ccp(0,1))
	txtDesc:setRelativePosition(GlobalMethod:ccp(0.05,0.36))
	
	GetElement(self.m_root,"labelReward_WndMountLottery",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.95))
end
-------------------------------------语言适配End----------------------------------------
