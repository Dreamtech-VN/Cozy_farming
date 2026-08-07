--WndApartmentActData.lua
--@brief	WndApartmentAct的数据模块
--@date		2017/08/08
--@author	zsq
--@note		公寓活动

WndApartmentAct = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndApartmentAct:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nSoundId = nil
	self.m_nTag = nil
	self.exchangeTip = nil
	self.exchangeNum = nil
	self.endTime = nil
	self.tag3 = nil
	self.data3 = nil
	self.date7 = nil
	self.giftId3 = nil
	self.giftId7 = nil
	self.m_tDataList10 = nil
	self.m_tAllActivityType = nil 	--代言人活动的活动类型
	self.m_nDisappearTime = nil 	--活动不展示的时间
	self.m_nodeElement = nil 
	self.m_tCellElement = nil 
	self.m_nMoveElementPosX = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndApartmentAct:_unInit()
	self.m_root = nil
	self.m_nSoundId = nil
	self.m_nTag = nil
	self.exchangeTip = nil
	self.exchangeNum = nil
	self.m_nConListPositionY = nil
	self.endTime = nil
	self.tag3 = nil
	self.data3 = nil
	self.date7 = nil
	self.giftId3 = nil
	self.giftId7 = nil
	self.m_tDataList10 = nil
	self.m_tAllActivityType = nil 	--代言人活动的活动类型
	self.m_nDisappearTime = nil 
	self.m_nodeElement = nil 
	self.m_tCellElement = nil 
	self.m_nMoveElementPosX = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndApartmentAct:createElement()
	if WndApartmentAct.m_root ~= nil then
		WindowManager:removeWindow(WndApartmentAct.m_root, WndApartmentAct, true)
	end
	local element = WZUISystem:getInstance():createElement("WndApartmentAct")
	assert(element, "WndApartmentAct create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	活动列表
--@param1 	param1: 活动不展示的时间戳
function WndApartmentAct:GetActivityListInfoOK(activityId, title, startTime, endTime, serverTime , types, type2, param1, param2)
	WZLog("WndApartmentAct:GetActivityListInfoOK")
    if self.m_root == nil then return end
    self.m_tListItem = {}
    local index = 1 
	for i=1,#activityId do
        WZLog("WndApartmentAct:GetActivityListInfoOK111", activityId[i], title[i],type2[i],types[i], param1[i], param2[i])
		if type2[i] == 4 then    --等于4 的才是代言人活动
    		if serverTime < endTime[i] then 
    			if types[i] > 0 then
    				self.m_tListItem[index] = {}
    				self.m_tListItem[index].activityId = activityId[i]
    				self.m_tListItem[index].title = title[i]
    				self.m_tListItem[index].startTime = startTime[i]
    				self.m_tListItem[index].endTime = endTime[i]
    				self.m_tListItem[index].types = types[i]
    				self.m_tListItem[index].param2 = param2[i]
    				if param1[i] == 0 then 
    					self.m_tListItem[index].disappearTime = endTime[i]
    				else
    					self.m_tListItem[index].disappearTime = param1[i]
    				end
    				index = index + 1
    			end 
    		end 
        end
	end

	WZLog("代言人活动数据", Serialize(self.m_tListItem))
	self:_updateTab()
end

function WndApartmentAct:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	if self.m_root == nil then return end
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
end

--@brief 	设置面板内容
function WndApartmentAct:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	WZLog("WndApartmentAct::_updateActivityContext =",activityId, content, Serialize(tips), startTime, endTime, serverTime, Serialize(rewardId), Serialize(status), Serialize(rewardItems), Serialize(rewardItemsParamCount), Serialize(rewardCounts),count,maxCount,Serialize(target))
	self.activityId = activityId
	self.content = content
	self.tips = tips
	self.startTime = startTime
	self.endTime = endTime
	self.serverTime = serverTime
	self.rewardId = rewardId
	self.status = status
	self.rewardItems = rewardItems
	self.rewardItemsParamCount = rewardItemsParamCount
	self.rewardCounts = rewardCounts
	self.count = count
	self.maxCount = maxCount
	self.target = target

	WZLog("WndApartmentAct::_updateActivityContext ==", type(self.m_nTag), self.m_nTag)
	WndApartmentAct["_update"..self.m_nTag](WndApartmentAct)
	WZLog("WndApartmentAct::_updateActivityContext ==?", type(self.m_nTag), self.m_nTag)
end

--@brief  获得充值礼包信息成功
function WndApartmentAct:GetVipRechargeInfoOK(ids, icons, number, giftNumber, price, payCodeId, flag, name, remark,showPrice,itemId,sortId,leftTimes, limitType, needVipLv)
    WZLog("WndApartmentAct:GetVipRechargeInfoOK ", self.m_nCurShowActivityId)

    if self.m_root == nil then return end 
    if self.m_nCurShowActivityId == 3030 then
    	self.m_tPacksFashion7 = {}
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

		    table.insert(self.m_tPacksFashion7,tempTT)
		end

		WZLog("购买价格",showPrice[1],Serialize(itemId), Serialize(number), Serialize(giftNumber))
		GetElement(self.m_root,"txtPrice",WZUILabelTTF):setText(showPrice[1])
		local conBtnBuy = GetElement(self.m_root,"conBtnBuy_WndSumVacAct",WZUIContainer)
		local imgSoldOut = GetElement(self.m_root,"imgSoldOut",WZUIImage)
		conBtnBuy:setVisible(true)
		imgSoldOut:setVisible(false)
		if leftTimes[1] <= 0 then
			imgSoldOut:setVisible(true)
			conBtnBuy:setVisible(false)
		else
			GetElement(self.m_root,"txtPrice",WZUILabelTTF):setText(showPrice[1])
		end

		for i=1,4 do
			GetElement(self.m_root,"conItem"..i.."_ApartmentAct7",WZUIContainer):setVisible(false)
		end
		
        local itemCount1 = nil
        local itemCount2 = nil
        local itemCount3 = nil
        local itemCount4 = nil

        local itemId1
        local itemId2
        local itemId3
        local itemId4

		---------  分割线   ---------
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
		self.giftId7 = itemId1

		local pg = {ccp(1,0.83),ccp(0.823,0.83),ccp(0.662,0.83),ccp(0.5,0.83)}
		pg[0] = ccp(0.823,0.83)
		GetElement(self.m_root,"conShowGift7",WZUIContainer):setRelativePosition(pg[#tDataList])
		---------  分割线   ---------
		--itemId2 = itemId[1]
		--itemCount2 = number[1]
		--self.giftId7 = itemId2

		local startT = nil
		local endT = nil
		for i,v in ipairs(self.m_tListItem) do
			if v.types == 3030 then
				startT = v.startTime
				endT = v.endTime
				break
			end
		end

		local cellType = 13
		cellType = 4

		if itemId1 ~= nil then
        local conItem1 = GetElement(self.m_root,"conItem1_ApartmentAct7",WZUIContainer)
		conItem1:setVisible(true)
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
            lastTime = itemCount1,
            basicInfo = GetItemLocalData(itemId1)
        }
        tItem:setCellGoodItem(tData,cellType)
        conItem:addChild(eItem)
        local itemInfo = GDatatab_item["id_" .. itemId1]
        txtItemName:setText(itemInfo.name)
		end

		if itemId2 ~= nil then
        local conItem2 = GetElement(self.m_root,"conItem2_ApartmentAct7",WZUIContainer)
		conItem2:setVisible(true)
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
            lastTime = itemCount2,
            basicInfo = GetItemLocalData(itemId2)
        }
        tItem:setCellGoodItem(tData,cellType)
        conItem:addChild(eItem)
        local itemInfo = GDatatab_item["id_" .. itemId2]
        txtItemName:setText(itemInfo.name)
		end

		if itemId3 ~= nil then
        local conItem3 = GetElement(self.m_root,"conItem3_ApartmentAct7",WZUIContainer)
		conItem3:setVisible(true)
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
            lastTime = itemCount3,
            basicInfo = GetItemLocalData(itemId3)
        }
        tItem:setCellGoodItem(tData,cellType)
        conItem:addChild(eItem)
		end

		if itemId4 ~= nil then
        local conItem4 = GetElement(self.m_root,"conItem4_ApartmentAct7",WZUIContainer)
		conItem4:setVisible(true)
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
            lastTime = itemCount4,
            basicInfo = GetItemLocalData(itemId4)
        }
        tItem:setCellGoodItem(tData,4)
        conItem:addChild(eItem)
		end
		return
	end


    if self.m_nCurShowActivityId == 3031 or self.m_nCurShowActivityId == 3054 then
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
		table.sort( self.m_tPacksFashion, 
			function (a,b)
		    	if a[12] < b[12] then
		    	    return true
		    	end
		    	return false
			end 
		)
    	WZLog("WndApartmentAct:GetVipRechargeInfoOK ", Serialize(self.m_tPacksFashion))
		self:_update3()
	end

    if self.m_nCurShowActivityId == 3043 then
    	self.m_tPacksFashion8 = {}
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

		    table.insert(self.m_tPacksFashion8,tempTT)
		end

		WZLog("购买价格8",showPrice[1],Serialize(itemId))
		GetElement(self.m_root,"txtPrice_WndApartmentAct",WZUILabelTTF):setText(showPrice[1])
		local conBtnBuy = GetElement(self.m_root,"conBtnBuy_WndApartmentAct",WZUIContainer)
		local imgSoldOut = GetElement(self.m_root,"imgSoldOut_WndApartmentAct",WZUIImage)
		conBtnBuy:setVisible(true)
		imgSoldOut:setVisible(false)
		if leftTimes[1] <= 0 then
			imgSoldOut:setVisible(true)
			conBtnBuy:setVisible(false)
		else
			GetElement(self.m_root,"txtPrice_WndApartmentAct",WZUILabelTTF):setText(showPrice[1])
		end

		for i=1,4 do
			GetElement(self.m_root,"conItem"..i.."_ApartmentAct8",WZUIContainer):setVisible(false)
		end
		
        local itemCount1 = nil
        local itemCount2 = nil
        local itemCount3 = nil
        local itemCount4 = nil

        local itemId1
        local itemId2
        local itemId3
        local itemId4

		-------  分割线   -------
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
		self.giftId8 = itemId1
		
		local pg = {ccp(1,0.83),ccp(0.823,0.83),ccp(0.662,0.83),ccp(0.5,0.83)}
		pg[0] = ccp(0.823,0.83)
		GetElement(self.m_root,"conShowGift8",WZUIContainer):setRelativePosition(pg[#tDataList])
		-------  分割线   -------
		--itemId2 = itemId[1]
		--itemCount2 = number[1]
		--self.giftId8 = itemId2
		
		local startT = nil
		local endT = nil
		for i,v in ipairs(self.m_tListItem) do
			if v.types == 3043 then
				startT = v.startTime
				endT = v.endTime
				break
			end
		end

		local cellType = 13
		cellType = 4

		if itemId1 ~= nil then
        local conItem1 = GetElement(self.m_root,"conItem1_ApartmentAct8",WZUIContainer)
		conItem1:setVisible(true)
        local txtItemName = GetElement(conItem1,"txtItemName_WndApartmentAct",WZUILabelTTF)
        local conItem = GetElement(conItem1,"conItem_WndApartmentAct",WZUIContainer)
        local eItem, tItem = CellGoodItem:createElement()
        eItem:setScale(0.86)
        tItem:setItemClickFun(self, self.onClickListItem)
        local tData = {
            id = itemId1,
            isUse = false,
            data = "",
            playerItemId = -1,
            lastNum = itemCount1,
            lastTime = itemCount1,
            basicInfo = GetItemLocalData(itemId1)
        }
        tItem:setCellGoodItem(tData,cellType)
        conItem:addChild(eItem)
        local itemInfo = GDatatab_item["id_" .. itemId1]
        txtItemName:setText(itemInfo.name)
		end

		if itemId2 ~= nil then
        local conItem2 = GetElement(self.m_root,"conItem2_ApartmentAct8",WZUIContainer)
		conItem2:setVisible(true)
        txtItemName = GetElement(conItem2,"txtItemName_WndApartmentAct",WZUILabelTTF)
        conItem = GetElement(conItem2,"conItem_WndApartmentAct",WZUIContainer)
        local eItem, tItem = CellGoodItem:createElement()
        eItem:setScale(0.86)
        tItem:setItemClickFun(self, self.onClickListItem)
        local tData = {
            id = itemId2,
            isUse = false,
            data = "",
            playerItemId = -1,
            lastNum = itemCount2,
            lastTime = itemCount2,
            basicInfo = GetItemLocalData(itemId2)
        }
        tItem:setCellGoodItem(tData,cellType)
        conItem:addChild(eItem)
        local itemInfo = GDatatab_item["id_" .. itemId2]
        txtItemName:setText(itemInfo.name)
		end

		if itemId3 ~= nil then
        local conItem3 = GetElement(self.m_root,"conItem3_ApartmentAct8",WZUIContainer)
		conItem3:setVisible(true)
        conItem = GetElement(conItem3,"conItem_WndApartmentAct",WZUIContainer)
        txtItemName = GetElement(conItem3,"txtItemName_WndApartmentAct",WZUILabelTTF)
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
            lastTime = itemCount3,
            basicInfo = GetItemLocalData(itemId3)
        }
        tItem:setCellGoodItem(tData,cellType)
        conItem:addChild(eItem)
		end

		if itemId4 ~= nil then
        local conItem4 = GetElement(self.m_root,"conItem4_ApartmentAct8",WZUIContainer)
		conItem4:setVisible(true)
        conItem = GetElement(conItem4,"conItem_WndApartmentAct",WZUIContainer)
        txtItemName = GetElement(conItem4,"txtItemName_WndApartmentAct",WZUILabelTTF)
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
            lastTime = itemCount4,
            basicInfo = GetItemLocalData(itemId4)
        }
        tItem:setCellGoodItem(tData,4)
        conItem:addChild(eItem)
		end
		return
	end

    if self.m_nCurShowActivityId == 3044 then
    	self.m_tPacksFashion9 = {}
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

		    table.insert(self.m_tPacksFashion9,tempTT)
		end
		table.sort( self.m_tPacksFashion9, 
			function (a,b)
		    	if a[12] < b[12] then
		    	    return true
		    	end
		    	return false
			end 
		)
    	WZLog("WndApartmentAct:GetVipRechargeInfoOK ", Serialize(self.m_tPacksFashion9))
		self:_update9()
	end
end

function WndApartmentAct:onClickListItem(tItem, nTag, tData)
	-- body
	WZLog("WndApartmentAct:onClickListItem")
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false)
end

--@brief 获取奖励成功
function WndApartmentAct:GetRewardOk(rewardItems,rewardCount,ntype)
    if self.m_root == nil then return end

	WZLog("WndApartmentAct:GetRewardOk types=")
    if rewardItems ~= nil and #rewardItems > 0 and  rewardItems[1] > 0 then
        WndRewardShow:showById(rewardItems,rewardCount)
    end
	if (self.m_nTag ==1 or self.m_nTag ==2) and self.m_nCurShowActivityType ~= nil and self.m_nCurShowActivityId ~= nil then
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nCurShowActivityType ,self.m_nCurShowActivityId)
	end
end

--@brief 	获取活动消失时间
function WndApartmentAct:getActivityDisappearTime(nActivityId)
	-- body
	for i = 1, #self.m_tListItem do
		if self.m_tListItem[i].activityId == nActivityId then 
			return self.m_tListItem[i].disappearTime
		end
	end
end

--@brief 	获取活动数据根据活动id
function WndApartmentAct:getActivityDataByActivityType(nActivityType)
	-- body
	for i = 1, #self.m_tListItem do
		if self.m_tListItem[i].types == nActivityType then 
			return self.m_tListItem[i]
		end
	end
end

--@brief 	获取圣诞树活动数据成功
function WndApartmentAct:getChristmasTreeDataOK(activityId, startTime, endTime, rewardItems, rewardCounts, serverIntegration, rank, rankPlayerName, rankIntegration, myRank, myIntegration, itemId, itemNum, freeCount, rankPlayerId, rankParam, rankReward)
	-- body
	WndChristmasTree:setData(activityId, startTime, endTime, rewardItems, rewardCounts, serverIntegration, rank, rankPlayerName, rankIntegration, myRank, myIntegration, itemId, itemNum, freeCount, rankPlayerId, rankParam, rankReward)
end

--@brief 	获取活动是否还存在
function WndApartmentAct:_activityIsExit(nActivityType)
	-- body
	if self.m_tListItem == nil or #self.m_tListItem == 0 then return false end
	local serverTime = SystemTime:getServerTime()

	for i,v in ipairs(self.m_tListItem) do
        if v.types == nActivityType then
            local endTime = v.endTime
            if endTime and serverTime >= endTime then
                return false
            end
        end
    end
    
    return true
end

--处理接收嫂烟花排行榜积分
function WndApartmentAct:handleRankInfo(ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRnak,otherServer)
    WZLog("WndApartmentAct:handleRankInfo")
    if self.m_root == nil then return end
    if self.m_nTag == 16 and self.m_nodeElement then
        local cellFireworksAnn = CellFireworksAnn:createElement()
        if cellFireworksAnn == nil then return end
        CellFireworksAnn:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour, score, myRnak, otherServer)
        cellFireworksAnn:setZOrder(10)
        local conForRank = GetElement(self.m_nodeElement, "conForRank_CellFireworks", WZUIContainer)
        local childNode = conForRank:getChildByTag(122)
        if childNode then
            childNode:setVisible(false)
        end
        conForRank:addChild(cellFireworksAnn)
    end
end
-------------------------------------私有方法模块End----------------------------------------
