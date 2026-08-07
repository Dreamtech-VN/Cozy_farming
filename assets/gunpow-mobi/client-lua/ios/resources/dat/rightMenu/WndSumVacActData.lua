--WndSumVacActData.lua
--@brief	WndSumVacAct的数据模块
--@date		2017/07/07
--@author	 qixiang
--@note		暑假活动

WndSumVacAct = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSumVacAct:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_tListItem = {}
	self.m_nCurShowActivityId = nil      --当前显示的活动类型  3030-夏日专属 3031-夏日盛惠 3032-夏日赏金 3033-夏日放价
    self.m_nCurShowActivityType = nil
    self.m_nClickNowId = nil
    self.m_tSummerMonsterInfo = {}  --夏日赏金信息
    self.m_nGetRewardMonsterId = nil
    self.m_nGetRewardChestId = nil   --领取宝箱奖励
    self.m_tPacksInfo = {} --夏日盛惠
    self.m_tDiscountP = {} --夏日折扣
    self.m_tPacksFashion = {} --夏日专属

    self.m_tBuyItemCallback = {}

    self.m_tRewardList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSumVacAct:_unInit()
	self.m_root = nil
	self.m_tActivityList = nil
	self.m_tListItem = nil
	self.m_tSummerMonsterInfo = nil
	self.m_nGetRewardMonsterId = nil
	self.m_nGetRewardChestId = nil   --领取宝箱奖励
	self.m_tPacksInfo = nil
	self.m_tDiscountP = nil
	self.m_tPacksFashion = nil
	self.m_nClickNowId = nil
	 self.m_tBuyItemCallback = nil
	 self.m_tRewardList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSumVacAct:createElement()
	if WndSumVacAct.m_root ~= nil then
		WindowManager:removeWindow(WndSumVacAct.m_root, WndSumVacAct, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSumVacAct")
	assert(element, "WndSumVacAct create element failed!")
	self:_init()
	return element
end

--@brief 	获得列表成功
function WndSumVacAct:GetActivityListInfoOK( activityId, title, startTime, endTime, serverTime , types, type2)
	WZLog("WndSumVacAct:GetActivityListInfoOK")
    if self.m_root == nil then return end
    self.m_tListItem = {}
    local index = 1 
	for i=1,#activityId do
        WZLog("--*****WndNewActivity****--111", activityId[i], title[i],type2[i],types[i])
		if type2[i] == 3 then    --等于2 的才是暑假活动
    		if serverTime < endTime[i] then 
    			if types[i] > 0 then
    				self.m_tListItem[index] = {}
    				self.m_tListItem[index].activityId = activityId[i]
    				self.m_tListItem[index].title = title[i]
    				self.m_tListItem[index].startTime = startTime[i]
    				self.m_tListItem[index].endTime = endTime[i]
    				self.m_tListItem[index].types = types[i]
    				index = index + 1
    			end 
    		end 
        end
	end
	self:_updateListItem()
end

--更新夏日赏金信息
function WndSumVacAct:updateMonsterActInfo(configId,killTimes,rewardStatus,score,targetScore,drawStatus,rewardStr)
	-- body
	WZLog("WndSumVacAct:updateMonsterActInfo ")
	local GetElement = GetElement
	local conActivityContext = GetElement(self.m_root,"conActivityC_WndSumVacAct",WZUIContainer)
    local conActivityContext3 = GetElement(conActivityContext,"conActivityContext3_WndSumVacAct",WZUIContainer)
    local txtTotalIntegral = GetElement(conActivityContext3,"txtTotalIntegral_WndSumVacAct",WZUILabelTTF)
    txtTotalIntegral:setText(score)

    local tempT = {}
    for i=1,4 do
    	local temp = {}
    	table.insert(temp,configId[i])
    	table.insert(temp,killTimes[i])
    	table.insert(temp,rewardStatus[i])

    	table.insert(tempT,temp)
    end

    table.sort(tempT,function (a,b)
    	-- body
    	local temppA = GDatatab_wanted_monster["id_" .. a[1]]
    	local temppB = GDatatab_wanted_monster["id_" .. b[1]]
    	if temppA.type < temppB.type then
    		return true
    	end
    	return false
    end)

    local tempT2 = {}
    for i=1,3 do
    	local temp = {}
    	table.insert(temp,targetScore[i])
    	table.insert(temp,drawStatus[i])
    	table.insert(temp,rewardStr[i])
    	table.insert(tempT2,temp)
    end

    table.sort(tempT2,function (a,b)
    	-- body
    	if a[1] < b[1] then
    		return true
    	end
    	return false
    end)

    self.m_tSummerMonsterInfo = {}
    self.m_tSummerMonsterInfo.configId = tempT
    self.m_tSummerMonsterInfo.targetScore = tempT2

    local totalScore = tempT2[3][1]
    local pgIntegral = GetElement(conActivityContext3,"pgIntegral_WndSumVacAct",WZUIProgress)
    pgIntegral:setPercentage((score/totalScore)*100)
    for i=1,4 do
    	local monsterInfo = tempT[i]
    	local conAct = GetElement(self.m_root,"conAct" .. i .. "_WndSumVacAct",WZUIContainer)
    	local txtStats = GetElement(conAct,"txtStats_WndSumVacAct",WZUILabelTTF)
    	local imgMonster = GetElement(conAct,"imgMonster_WndSumVacAct",WZUIImage)
    	local txtKillCount = GetElement(conAct,"txtKillCount_WndSumVacAct",WZUILabelTTF)
    	local txtIntegral = GetElement(conAct,"txtIntegral_WndSumVacAct",WZUILabelTTF)
    	local imgPass = GetElement(conAct,"imgPass_WndSumVacAct",WZUIImage)
    	imgPass:setVisible(false)
    	local conBtn = GetElement(conAct,"conBtn_WndSumVacAct",WZUIContainer)
    	local txtMonsterName = GetElement(conAct,"txtMonsterName_WndSumVacAct",WZUILabelTTF)
    	conBtn:setVisible(true)
    	local imgReward1 = GetElement(conAct,"imgReward1_WndSumVacAct",WZUIImage)
    	local txtReward1Count = GetElement(conAct,"txtReward1Count_WndSumVacAct",WZUILabelTTF)
    	local imgReward2 = GetElement(conAct,"imgReward2_WndSumVacAct",WZUIImage)
    	local txtReward2Count = GetElement(conAct,"txtReward2Count_WndSumVacAct",WZUILabelTTF)

    	local btnMonsterInfo = GetElement(conAct,"btnMonsterInfo_WndSumVacAct",WZUIButton)
    	local imgNormal = GetElement(conBtn,"imgNormal_WndSumVacAct",WZUI9Image)
    	local imgSel = GetElement(conBtn,"imgSel_WndSumVactAct",WZUI9Image)

    	local dataInfo = GDatatab_wanted_monster["id_" .. monsterInfo[1]]
    	btnMonsterInfo:setTag(dataInfo.id)
    	txtMonsterName:setText(dataInfo.name)

    	local reward = dataInfo.reward
    	local itemInfo1 = GDatatab_item["id_" .. reward[1][1]]
    	local itemInfo2 = GDatatab_item["id_" .. reward[2][1]]

    	imgReward1:setFile(itemInfo1.icon)
    	imgReward2:setFile(itemInfo2.icon)

    	txtReward1Count:setText(reward[1][2])
    	txtReward2Count:setText(reward[2][2])


    	local txt = string.format(LocalStrings.Daily_GOAL1_3,killTimes[i],dataInfo.number)
    	txtKillCount:setText(txt)

    	txtIntegral:setText("(" .. LocalStrings.BOUNTY .. dataInfo.integral .. ")")
    	imgMonster:setFile(dataInfo.image)
    	
    	if monsterInfo[3] == 1 then
    		imgPass:setVisible(false)
    		txtStats:setText(LocalStrings.ACTIVE_BTN_GO)
    		imgNormal:setFile("ui/common/common_btn_anniu3_1.png")
    		imgSel:setFile("ui/common/common_btn_anniu3_1_sel.png")
    		txtStats:setLabelStyleKey("NORMAL_ORANGE_BTN")
    	elseif monsterInfo[3] == 2 then --领取奖励
    		imgPass:setVisible(false)
    		txtStats:setText(LocalStrings.ACTIVE_BTN_GET)
    		imgNormal:setFile("ui/common/common_btn_anniu10_0.png")
    		imgSel:setFile("ui/common/common_btn_anniu10_0_sel.png")
    		txtStats:setLabelStyleKey("NORMAL_GREEN_BTN")
    	else
    		conBtn:setVisible(false)
    		imgPass:setVisible(true)
    	end

        if ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
            txtMonsterName:setScale(0.7)
            txtMonsterName:setDimensions(GlobalMethod:CCSize(150))
            txtIntegral:setScale(0.8)
            txtKillCount:setScale(0.8)
        elseif ProjConfig.LANGUAGE == "en" then
            txtMonsterName:setScale(0.8)
            txtIntegral:setScale(0.8)
        end
    end

    
    self.m_tRewardList = {}
    for i=1,3 do
    	local rewardS = tempT2[i][3]
    	local ids,nums = SplitItemString(rewardS)
    	local rewardList = {}
		rewardList.icon = {}
		rewardList.num = {}
    	for i,v in ipairs(ids) do
    		local itemInfo = GDatatab_item["id_" .. v]
    		table.insert(rewardList.icon,itemInfo.icon)
    		table.insert(rewardList.num,nums[i])
    	end
    	table.insert(self.m_tRewardList,rewardList)
    	local conReward = GetElement(conActivityContext3,"conReward" .. i .. "_WndSumVacAct",WZUIContainer)
    	local txtIntegralTarget = GetElement(conReward,"txtIntegralTarget_WndSumVacAct",WZUILabelTTF)
    	txtIntegralTarget:setText(tempT2[i][1])

    	conReward:setRelativePosition(GlobalMethod:ccp(tempT2[i][1]/totalScore,-0.2))

    	local armBox = GetElement(conReward,"armBox_WndSumVacAct",WZArmature)
    	armBox:setVisible(false)

    	if tempT2[i][2] == 2 and i == 1 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSumVacAct",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSumVacAct",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_lan2.png")
    		imgBoxSel:setFile("ui/common/common_icon_lan2.png")
    		armBox:setVisible(true)
    	elseif tempT2[i][2] == 2 and i == 2 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSumVacAct",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSumVacAct",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_zi2.png")
    		imgBoxSel:setFile("ui/common/common_icon_zi2.png")
    		armBox:setVisible(true)
    	elseif tempT2[i][2] == 2 and i == 3 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSumVacAct",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSumVacAct",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_huang2.png")
    		imgBoxSel:setFile("ui/common/common_icon_huang2.png")
    		armBox:setVisible(true)
    	end

    	if tempT2[i][2] == 3 and i == 1 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSumVacAct",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSumVacAct",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_lan3.png")
    		imgBoxSel:setFile("ui/common/common_icon_lan3.png")
    	elseif tempT2[i][2] == 3 and i == 2 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSumVacAct",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSumVacAct",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_zi3.png")
    		imgBoxSel:setFile("ui/common/common_icon_zi3.png")
    	elseif tempT2[i][2] == 3 and i == 3 then
    		local imgBoxNor = GetElement(conReward,"imgBoxNor_WndSumVacAct",WZUIImage)
    		local imgBoxSel = GetElement(conReward,"imgBoxSel_WndSumVacAct",WZUIImage)
    		imgBoxNor:setFile("ui/common/common_icon_huang3.png")
    		imgBoxSel:setFile("ui/common/common_icon_huang3.png")
    	end
    end
end

--@brief    创建并显示活动界面
--@param    activityId: 活动类型，值从m_tGameActivityTypes 取
--@tMsg     从消息列表传过来的数据
function WndSumVacAct:showInterface()
    -- body
    WZLog("WndSumVacAct:showInterface")
    local wndSumVacAct = WndSumVacAct:createElement()
    if wndSumVacAct ~= nil then
        WindowManager:addWindow(wndSumVacAct,WndSumVacAct,nil,nil,nil,true)
    end
end

--显示获取到的奖励信息
function WndSumVacAct:showGetReward(rewardStr)
	-- body
	WZLog("WndSumVacAct:showGetReward ",rewardStr)
	if self.m_root == nil then return end
	if rewardStr ~= "" and rewardStr ~= nil then
		local ids = nil
		local nums = nil
		ids , nums = SplitItemString(rewardStr)
		WndRewardShow:showById(ids,nums)
	end
	if self.m_nGetRewardMonsterId ~= nil or self.m_nGetRewardChestId then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWantedMonsterInfo()
		self.m_nGetRewardChestId = nil
	    self.m_nGetRewardMonsterId = nil
	end
end

--@brief  获得充值礼包信息成功
function WndSumVacAct:GetVipRechargeInfoOK(ids, icons, number, giftNumber, price, payCodeId, flag, name, remark,showPrice,itemId,sortId,leftTimes, limitType, needVipLv)
    WZLog("WndSumVacAct:GetVipRechargeInfoOK ")

    if self.m_root == nil then return end 
    if self.m_nCurShowActivityId == 3030 then
    	self.m_tPacksFashion = {}
    	for i,v in ipairs(ids) do
		    local tempTT = {}
		    table.insert(tempTT,ids[i])
		    table.insert(tempTT,icons[i])
		    table.insert(tempTT,number[i])
		    table.insert(tempTT,giftNumber[i])
		    table.insert(tempTT,price[i])
		    table.insert(tempTT,payCodeId[i])
		    table.insert(tempTT,flag[i])
		    table.insert(tempTT,name[i])
		    table.insert(tempTT,remark[i])
		    table.insert(tempTT,showPrice[i])
		    table.insert(tempTT,itemId[i])
		    table.insert(tempTT,sortId[i])
		    table.insert(tempTT,leftTimes[i])
		    table.insert(tempTT,limitType[i])
		    table.insert(tempTT,needVipLv[i])

		    table.insert(self.m_tPacksFashion,tempTT)
		end
    WZLog("WndSumVacAct:GetVipRechargeInfoOK2", Serialize(self.m_tPacksFashion))
		local conActivityC = GetElement(self.m_root,"conActivityC_WndSumVacAct",WZUIContainer)
		local conActivityContext1 = GetElement(conActivityC,"conActivityContext1_WndSumVacAct",WZUIContainer)
		local txtPrice = GetElement(conActivityContext1,"txtPrice_WndSumVacAct",WZUILabelTTF)
		local conBtnBuy = GetElement(conActivityContext1,"conBtnBuy_WndSumVacAct",WZUIContainer)
		local imgSoldOut = GetElement(conActivityContext1,"imgSoldOut_WndSumVacAct",WZUIImage)
		conBtnBuy:setVisible(true)
		imgSoldOut:setVisible(false)
		if leftTimes[1] <= 0 then
			imgSoldOut:setVisible(true)
			conBtnBuy:setVisible(false)
		else
			txtPrice:setText(showPrice[1])
		end

		
        local itemCount1 = nil
        local itemCount2 = nil
        local itemCount3 = nil
        local itemCount4 = nil

        local itemId1
        local itemId2 
        local itemId3
        local itemId4

		local tDataList = {}
		local sexKey = {"man_item_id", "woman_item_id"}
		local sex = tonumber(CacheCenter:getPlayerInfo().sex)

		for i,v in pairs(GDatatab_gifts) do
            for j,k in ipairs(itemId) do
                if v.item_id == k then
					local tempData = {}
					tempData.itemId = v[sexKey[sex+1]]
					tempData.count = v.count
					table.insert(tDataList, tempData)
                end
            end
		end

		local _sort = function(a, b)
			return a.itemId > b.itemId
		end
		table.sort(tDataList, _sort)

		if tDataList[1] ~= nil then
			itemId1 = tDataList[1].itemId
        	itemCount1 = tDataList[1].count
		end
		if tDataList[2] ~= nil then
			itemId2 = tDataList[2].itemId
        	itemCount2 = tDataList[2].count
		end
		if tDataList[3] ~= nil then
			itemId3 = tDataList[3].itemId
        	itemCount3 = tDataList[3].count
		end
		if tDataList[4] ~= nil then
			itemId4 = tDataList[4].itemId
        	itemCount4 = tDataList[4].count
		end

		
		------  分割线   -------
        local conItem1 = GetElement(conActivityContext1,"conItem1_WndSumVacAct",WZUIContainer)
        local conItem2 = GetElement(conActivityContext1,"conItem2_WndSumVacAct",WZUIContainer)
        local conItem3 = GetElement(conActivityContext1,"conItem3_WndSumVacAct",WZUIContainer)
        local conItem4 = GetElement(conActivityContext1,"conItem4_WndSumVacAct",WZUIContainer)

		local startT = nil
		local endT = nil
		for i,v in ipairs(self.m_tListItem) do
			if v.types == 3030 then
				startT = v.startTime
				endT = v.endTime
				break
			end
		end

		startT = os.date("%m.%d",startT)
		endT = os.date("%m.%d",endT)
		local actT = LocalStrings.ACTIVITY_TIME_KEY .. "：" .. startT .. "-" .. endT
		local txtActivitySkillT = GetElement(conActivityContext1,"txtActivitySkillT_WndSumVacAct",WZUILabelTTF)
        txtActivitySkillT:setText(actT)
        GetElement(conActivityContext1, "conActivityTime1_WndSumVacAct", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.38))

		if itemId1 ~= nil then
        local conItem1 = GetElement(conActivityContext1,"conItem1_WndSumVacAct",WZUIContainer)
        local txtItemName = GetElement(conItem1,"txtItemName_WndSumVacAct",WZUILabelTTF)
        local conItem = GetElement(conItem1,"conItem_WndSumVacAct",WZUIContainer)
        local eItem, tItem = CellGoodItem:createElement()
        eItem:setScale(0.86)
        tItem:setItemClickFun(self, self.onClickListItem)
        local tData = {
            id = itemId1,
            isUse = false,
            data = "",
            playerItemId = -1,
            lastNum = itemCount1,
            basicInfo = GetItemLocalData(itemId1)
        }
        tItem:setCellGoodItem(tData,4)
        conItem:addChild(eItem)
        local itemInfo = GDatatab_item["id_" .. itemId1]
        txtItemName:setText(itemInfo.name)
		end

		if itemId2 ~= nil then
        local conItem2 = GetElement(conActivityContext1,"conItem2_WndSumVacAct",WZUIContainer)
        txtItemName = GetElement(conItem2,"txtItemName_WndSumVacAct",WZUILabelTTF)
        conItem = GetElement(conItem2,"conItem_WndSumVacAct",WZUIContainer)
        local eItem, tItem = CellGoodItem:createElement()
        eItem:setScale(0.86)
        tItem:setItemClickFun(self, self.onClickListItem)
        local tData = {
            id = itemId2,
            isUse = false,
            data = "",
            playerItemId = -1,
            lastNum = itemCount2,
            basicInfo = GetItemLocalData(itemId2)
        }
        tItem:setCellGoodItem(tData,4)
        conItem:addChild(eItem)
        local itemInfo = GDatatab_item["id_" .. itemId2]
        txtItemName:setText(itemInfo.name)
		end

		if itemId3 ~= nil then
        local conItem3 = GetElement(conActivityContext1,"conItem3_WndSumVacAct",WZUIContainer)
        conItem = GetElement(conItem3,"conItem_WndSumVacAct",WZUIContainer)
        txtItemName = GetElement(conItem3,"txtItemName_WndSumVacAct",WZUILabelTTF)
        itemInfo = GDatatab_item["id_" .. itemId3]
        txtItemName:setText(itemInfo.name)

        local eItem, tItem = CellGoodItem:createElement()
        eItem:setScale(0.86)
        tItem:setItemClickFun(self, self.onClickListItem)
        local tData = {
            id = itemId3,
            isUse = false,
            data = "",
            playerItemId = -1,
            lastNum = itemCount3,
            basicInfo = GetItemLocalData(itemId3)
        }
        tItem:setCellGoodItem(tData,4)
        conItem:addChild(eItem)
		end

		if itemId4 ~= nil then
        local conItem4 = GetElement(conActivityContext1,"conItem4_WndSumVacAct",WZUIContainer)
        conItem = GetElement(conItem4,"conItem_WndSumVacAct",WZUIContainer)
        txtItemName = GetElement(conItem4,"txtItemName_WndSumVacAct",WZUILabelTTF)
        itemInfo = GDatatab_item["id_" .. itemId4]
        txtItemName:setText(itemInfo.name)

        local eItem, tItem = CellGoodItem:createElement()
        eItem:setScale(0.86)
        tItem:setItemClickFun(self, self.onClickListItem)
        local tData = {
            id = itemId4,
            isUse = false,
            data = "",
            playerItemId = -1,
            lastNum = itemCount4,
            basicInfo = GetItemLocalData(itemId4)
        }
        tItem:setCellGoodItem(tData,4)
        conItem:addChild(eItem)
		end

    elseif self.m_nCurShowActivityId == 3031 then --夏日盛惠
    	self.m_tPacksInfo = {}
		for i,v in ipairs(ids) do
		    local tempTT = {}
		    table.insert(tempTT,ids[i])
		    table.insert(tempTT,icons[i])
		    table.insert(tempTT,number[i])
		    table.insert(tempTT,giftNumber[i])
		    table.insert(tempTT,price[i])
		    table.insert(tempTT,payCodeId[i])
		    table.insert(tempTT,flag[i])
		    table.insert(tempTT,name[i])
		    table.insert(tempTT,remark[i])
		    table.insert(tempTT,showPrice[i])
		    table.insert(tempTT,itemId[i])
		    table.insert(tempTT,sortId[i])
		    table.insert(tempTT,leftTimes[i])
		    table.insert(tempTT,limitType[i])
		    table.insert(tempTT,needVipLv[i])

		    table.insert(self.m_tPacksInfo,tempTT)
		end
        
		table.sort( self.m_tPacksInfo, function (a,b)
		    if tonumber(a[5]) < tonumber(b[5]) then
		        return true
		    end
		    return false
		end )
        
		local conActivityC = GetElement(self.m_root,"conActivityC_WndSumVacAct",WZUIContainer)
		local conActivityContext2 = GetElement(conActivityC,"conActivityContext2_WndSumVacAct",WZUIContainer)

        local startT = nil
        local endT = nil
        for i,v in ipairs(self.m_tListItem) do
            if v.types == 3031 then
                startT = v.startTime
                endT = v.endTime
                break
            end
        end

        startT = os.date("%m.%d",startT)
        endT = os.date("%m.%d",endT)
        local actT = LocalStrings.ACTIVITY_TIME_KEY .. "：" .. startT .. "-" .. endT
        local txtActivitySkillT = GetElement(conActivityContext2,"txtActivitySkillT_WndSumVacAct",WZUILabelTTF)
        txtActivitySkillT:setText(actT)

		for i,v in ipairs(self.m_tPacksInfo) do
			local conA = GetElement(conActivityContext2,"conA" .. i .. "_WndSumVacAct",WZUIContainer)
			local conBtn = GetElement(conA,"conBtn_WndSumVacAct",WZUIContainer)
			local imgSoldOut = GetElement(conA,"imgSoldOut_WndSumVacAct",WZUIImage)
			local conItemInfo = GetElement(conA,"conItemInfo_WndSumVacAct",WZUIContainer)
			local txtPrice = GetElement(conA,"txtPrice_WndSumVacAct",WZUILabelTTF)
			local txtLimitBuyTip = GetElement(conA,"txtLimitBuyTip_WndSumVacAct",WZUILabelTTF)
			local txtPacksName = GetElement(conA,"txtPacksName_WndSumVacAct",WZUILabelTTF)
		    local  itemInfo =	GDatatab_item["id_" .. v[11] ]
		    txtPacksName:setText(itemInfo.name)
			txtLimitBuyTip:setText("(" .. LocalStrings.SHOP_DAY_LIMIT .. ":" .. "1" .. LocalStrings.SHOP_CISHU .. ")" )
			imgSoldOut:setVisible(false)
			conBtn:setVisible(true)
			if v[13] <= 0 then
				WndNewActivity:updateRechargeInfo(v[10],v[1])
				txtPrice:setText(LocalStrings.BOUGHT)
				imgSoldOut:setVisible(true)
				conBtn:setVisible(false)
			else
				txtPrice:setText(v[10] )
			end
			local eItem, tItem = CellGoodItem:createElement()
			eItem:setScale(1)
			tItem:setItemClickFun(self, self.onClickListItem)

			local tData = {
			    id = v[11],
			    isUse = false,
			    data = "",
			    playerItemId = -1,
			    lastNum = 1,
			    basicInfo = GetItemLocalData(v[11])
			}
			tItem:setCellGoodItem(tData,4)
			conItemInfo:addChild(eItem)
		end
    end
    
end


function WndSumVacAct:onClickListItem(tItem, nTag, tData)
	-- body
	WZLog("WndSumVacAct:onClickListItem")
	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false)
end

--@brief  获得活动内容成功
function WndSumVacAct:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	if self.m_root == nil then return end
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
end

--@brief 获取奖励成功
function WndSumVacAct:GetRewardOk(rewardItems,rewardCount,ntype)
    if self.m_root == nil then return end

	WZLog("WndSumVacAct:GetRewardOk types=")
    if rewardItems ~= nil and #rewardItems > 0 and  rewardItems[1] > 0 then
        WndRewardShow:showById(rewardItems,rewardCount)
    end
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nCurShowActivityType ,self.m_nCurShowActivityId)
end

--是否需要显示红点
function WndSumVacAct:bShowRedPoint()
    -- body
    WZLog("WndSumVacAct:bShowRedPoint")
    if CacheCenter.m_tActivityItemRedDotList ~= nil and type(CacheCenter.m_tActivityItemRedDotList) == "table" then
        for i,v in ipairs(CacheCenter.m_tActivityItemRedDotList) do
            if v == 3032 then
                return true
            end
        end
    end
    return false
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndSumVacAct:getSDKData(tag,data)
	WZLog("WndSumVacAct:getSDKData ",tag)
	local dataT = data[tag]
	local itemInfo = GDatatab_item["id_"..dataT[11]]
	local productName = itemInfo.name
	local productDesc = dataT[8]
	local quantifier = LocalStrings.SHOP_IND
	local number = dataT[3]
	if dataT[11] == 50 or dataT[11] == 51 or dataT[11]== 52 or dataT[11] == 56 then
		quantifier = LocalStrings.Expand
		number = 1
	end
	local sdkData = {
		id = dataT[1],
		price =dataT[5],
		payCode = dataT[6],
		productName = productName,
		productDesc = productDesc,
		quantifier = quantifier,
		number = math.max(1,number),
		giftNumber = dataT[4],
	}
	return sdkData
end


-------------------------------------私有方法模块End----------------------------------------
