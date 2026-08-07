--WndEquipmentLotteryData.lua
--@brief	WndEquipmentLottery的数据模块
--@date		2016/05/10
--@author	xiang
--@note		装备抽奖系统

WndEquipmentLottery = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndEquipmentLottery:_init()
	self.m_root = nil 	  			--场景根节点
	self.m_nleaveTime = nil
	self.m_nlotteryTime = nil
	self.m_bActivity = false
	self.m_bCanTouch = true 
	self.m_tIds = nil
	self.m_tNums = nil
	self.m_tItems = nil
	self.m_bUpdate = false
	self.m_nRaffleType = nil  -- 1、碎片2、钻石、3十连抽
	self.m_nSummonTimeType = nil
	self.m_bPlayingSpine = false
	self.m_scheduleId = nil
	self.m_bIsShowWeiXinBtn = false
	self.isUseTicket = nil 	--是否使用双货币
	self.m_nTenLotteryTime = nil

	self.m_tRewardInfo = nil
	self.m_tRewardItems = nil

	self.m_bTeachDraw = true --是否新手引导单抽
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndEquipmentLottery:_unInit()
	self.m_root = nil
	self.m_nleaveTime = nil
	self.m_nlotteryTime = nil
	self.m_bCanTouch = nil
	self.m_bActivity = nil
	self.m_tIds = nil
	self.m_tNums = nil
	self.m_bUpdate = nil
	self.m_tItems = nil
	self.m_nRaffleType = nil
	self.m_nSummonTimeType = nil
	self.m_bPlayingSpine = nil
	self.m_scheduleId = nil
	self.m_bIsShowWeiXinBtn = nil 
	self.isUseTicket = nil
	self.m_nTenLotteryTime = nil
	self.m_tRewardInfo = nil
	self.m_tRewardItems = nil

	self.m_bTeachDraw = nil --是否是抽奖后
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndEquipmentLottery:createElement()
	local element = WZUISystem:getInstance():createElement("WndEquipmentLottery")
	assert(element, "WndEquipmentLottery create element failed!")
	self:_init()
	return element
end

--更新抽奖信息
function WndEquipmentLottery:updateUIInfo(leaveTime,lotteryTime,bActivity,tenLotteryTime)
	WZLog("WndEquipmentLottery:updateUIInfo = ",bActivity,self.m_bUpdate)
	self.m_nleaveTime = leaveTime
	self.m_nlotteryTime = lotteryTime
	self.m_bActivity = bActivity
	self.m_bCanTouch = true
	self.m_nTenLotteryTime = tenLotteryTime
	self:stopLoading()
	local imgActivity = GetElement(self.m_root,"imgActivity_WndEquipmetLottery",WZUIImage)
    if self.m_bActivity  then --有抽奖活动
    	imgActivity:setVisible(true)
    else
    	imgActivity:setVisible(false)
    end
	AdaptLanguage(self)

    if self.m_scheduleId == nil then
    	self.m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.updateSchedule,10, false)
    end

    -- local conMiddle = GetElement(self.m_root,"conMiddle_WndEquipmentLottery",WZUIContainer)

	if self.m_bUpdate --[[or not conMiddle:isVisible()--]] then
		self:initUI()
		local isEndTeach41, step41 = TeachGroup1:isTeachFinish(41)
		WZLog("WndEquipmentLottery:updateUIInfo",isEndTeach41, step41)
		if isEndTeach41 ~= true and step41 < 3 and CacheCenter:getPlayerInfo().level == 9 then
		    TeachGroup1:startGroup({41,3,self.m_root})
		elseif isEndTeach41 ~= true and step41 < 5 and CacheCenter:getPlayerInfo().level == 9 and self.m_bTeachDraw == true --[[and GetElement(self.m_root,"conRSEEE_WndEquipmentLottery",WZUIContainer):isVisible() == false--]] then
		    TeachGroup1:startGroup({41,5,self.m_root})
		end
	end
end

--抽奖成功
function WndEquipmentLottery:raffleSuccess(itemId)
	WZLog("WndEquipmentLottery:raffleSuccess")
    WindowManager:removeTeachShelterLayer()
	self.m_tItems = itemId
	if self.m_root ~= nil then
		self:stopLoading()
	    local itemCount = #itemId
	    WZLog("itemCount=",itemCount)
	    if itemCount > 0 then
	    	SoundManager:playEffectSound(SoundDefine.E_S_LOTTER_DRAW_EFFECT)
	    	-- local child = self.m_root:getChildByTag(1199)
	    	-- child:setVisible(false)

	    	ProtocolProcessorWndEquipmentRaffle:send_EQUIP_GetFreeTime()
	        WndEquipmentLottery.m_bUpdate = true

	    	-- local conMiddle = GetElement(self.m_root,"conMiddle_WndEquipmentLottery",WZUIContainer)
	    	-- conMiddle:setVisible(false)
	    	self:hideContainer()

	    	local conRSEEE = GetElement(self.m_root,"conRSEEE_WndEquipmentLottery",WZUIContainer)
	    	conRSEEE:setVisible(false)

	    	local conRSE = GetElement(conRSEEE,"conRSE_WndEquipmentLottery",WZUIContainer)
		    conRSE:setVisible(false)

	        conRSEEE:enableSchedule("spineEvent1",1.3)
	    	local conShelter = GetElement(self.m_root,"conShelter_WndEquipmentLottery",WZUIContainer)
	    	conShelter:setVisible(true)
	    	local spineBox =  GetElement(self.m_root,"spineBox_WndEquipmentLottery",WZUISpine)
	    	if itemCount > 1 and self.m_nRaffleType == 3 then
	    		self.m_bPlayingSpine = true
	    		spineBox:play("box3_open",false)
	    	else
	    		if self.m_nRaffleType == 1 then
	    			self.m_bPlayingSpine = true
	    			spineBox:play("box3_open",false)
	    		elseif self.m_nRaffleType == 2 then
	    			self.m_bPlayingSpine = true
	    			spineBox:play("box3_open",false)
	    		end
	    	end
	    end
	end
	ProtocolProcessorWndEquipmentRaffle:send_EQUIP_TenLotteryRewardStatus()
end

function WndEquipmentLottery:getSummonTimeType()
	if self.m_nSummonTimeType then
		return self.m_nSummonTimeType
	end
	return nil
end

function WndEquipmentLottery:resetValue()
	WZLog("WndEquipmentLottery:resetValue")
	self.m_bCanTouch = true
	self:stopLoading()
	WindowManager:removeTeachShelterLayer()
end

--把秒 转化成XX时XX分XX秒
function WndEquipmentLottery:formatTime(time)
	WZLog("WndEquipmentLottery:formatTime")
	local hour = math.floor(time/3600)
	local minute = math.fmod(math.floor(time/60),60)
	local second = math.fmod(time,60)
	local rtTime = string.format("%s:%s:%s",hour,minute,second)
    
    return rtTime
end

--停止loading
function WndEquipmentLottery:stopLoading()
	WZLog("WndEquipmentLottery:stopLoading")
	if self.m_nLoadingId ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil
	end
end

function WndEquipmentLottery:resetFile()
	WZLog("WndEquipmentLottery:resetFile")

	local spineBox = GetElement(self.m_root,"spineBox_WndEquipmentLottery",WZUISpine)
	spineBox:play("box3",true)

	self:hideContainer()

end

--更新武器文字颜色
function WndEquipmentLottery:updateEquipName(txtObject,quality)
	if quality == 1 then
		txtObject:setLabelStyleKey("C15_F24_S4_C5")
	elseif quality == 2 then
		txtObject:setLabelStyleKey("C9_F24_S4_C5")
	elseif quality == 3 then
		txtObject:setLabelStyleKey("C17_F24_S4_C5")
	elseif quality == 4 then
		txtObject:setLabelStyleKey("C12_F24_S4_C5")
	end
end

function WndEquipmentLottery:addEquipmentLotteryToCurScene()
    -- local wndEquipmentLottery = WndEquipmentLottery:createElement()
    -- WindowManager:addWindow(wndEquipmentLottery,WndEquipmentLottery)
    WndSummonEntrance:showInterface(1)
end


--是否有小红点显示
function WndEquipmentLottery:isShowRed()
	WZLog("WndEquipmentLottery:isShowRed")
	local equipLotteryPrice =  CacheCenter:getGameParam().equipLotteryPrice
	local tIds,tNums = SplitItemString(equipLotteryPrice)
	local fragmentCount =  CacheCenter:getPlayerItemCountById(tIds[4])
	if fragmentCount >= tonumber(tNums[4]) * 10 then
		return true
	end

	local fragmentCount =  CacheCenter:getPlayerItemCountById(tIds[1])
	if fragmentCount >= tonumber(tNums[1]) * 10 then
		return true
	end
	return false
end

function WndEquipmentLottery:setRewardStatus(targetTimes, status, rewardItems, rewardItemsCount, rewardCounts)
	-- body
	WZLog("WndEquipmentLottery:setRewardStatus")
	if self.m_root == nil then return end
	self.m_tRewardInfo = {}
	self.m_tRewardInfo.targetTimes = targetTimes
	self.m_tRewardInfo.status = status
	self.m_tRewardInfo.rewardItems = rewardItems
	self.m_tRewardInfo.rewardItemsCount = rewardItemsCount
	self.m_tRewardInfo.rewardCounts = rewardCounts
	WZLog("askdfalsdj =",Serialize(self.m_tRewardInfo))
	self:showRewardStats(self.m_tRewardInfo)
end

function WndEquipmentLottery:showRewardStats(tRewardInfo)
	-- body
	WZLog("WndEquipmentLottery:showRewardStats")
	local bShowHaveReward = false
	local bRewardIndex = nil
	for i,v in ipairs(tRewardInfo.status) do
		if v == 0 then
			bShowHaveReward = true
			bRewardIndex = i
			break
		end
	end

	local bShow = false
	if bRewardIndex == nil then
		for i,v in ipairs(tRewardInfo.targetTimes) do
			if self.m_nTenLotteryTime < v then
				bRewardIndex = i
				break
			end
		end

		for i,v in ipairs(tRewardInfo.status) do
			if v == -1 or v == 0 then
				bShow = true
				break
			end
		end
	end



	local conMiddle = GetElement(self.m_root,"conMiddle_WndEquipmentLottery",WZUIContainer)
	local txtGiveMore = GetElement(conMiddle,"txtGiveMore_WndEquipmentLottery",WZUILabelTTF)
	local conRewardItem = GetElement(conMiddle,"conRewardItem_WndEquipmentLottery",WZUIContainer)
	local imgRedGiveMove = GetElement(conRewardItem,"imgRedGiveMove_WndEquipmentLottery",WZUIImage)
	local conItem = GetElement(conRewardItem,"conItem_WndEquipmentLottery",WZUIContainer)
	local btnShowListItem = GetElement(conMiddle,"btnShowListItem_WndEquipmentLottery",WZUIButton)
	conItem:removeAllChildrenWithCleanup(true)
	txtGiveMore:setText("")
	conRewardItem:setVisible(false)
	imgRedGiveMove:setVisible(false)
	local tCount = 0
	local tCount2 = 1
	local tempItem = {}
	for i,v in ipairs(tRewardInfo.rewardItems) do
		tCount = tCount + 1
		if tCount == tRewardInfo.rewardCounts[tCount2] then
			tCount2 = tCount2 + 1
			tCount = 0
			table.insert(tempItem,v)
		end
	end
	self.m_tRewardItems = tempItem
	if bShowHaveReward then
		conRewardItem:setVisible(true)
		btnShowListItem:setVisible(true)
		txtGiveMore:setText(LocalStrings.CAN_GET)
		local itemCount = tRewardInfo.rewardCounts[bRewardIndex]
		local itemId = tempItem[bRewardIndex]
		local item = self:_createCellGoodItem(bRewardIndex,itemId)
		conItem:addChild(item)
		imgRedGiveMove:setVisible(true)
	else
		if bRewardIndex ~= nil and bShow then
			conRewardItem:setVisible(true)
			local count = tRewardInfo.targetTimes[bRewardIndex] - self.m_nTenLotteryTime
			local sTemp = string.format(LocalStrings.GIVE_MOVE,count)
			txtGiveMore:setText(sTemp)
			local itemId  = tempItem[bRewardIndex]
			local item = self:_createCellGoodItem(bRewardIndex,itemId)
			conItem:addChild(item)
		end
	end

	if WndEquipReward and WndEquipReward.m_root then
		WndEquipReward:setRewardData(self.m_tRewardInfo,self.m_tRewardItems,self.m_nTenLotteryTime)
	end
end



--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
function WndEquipmentLottery:_createCellGoodItem(nIndex, nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nIndex)
    --tItem:setItemClickFun(self, self.onClickListItem)
    eItem:setScale(0.6)
    local tData = nil
    if type(nItemId) == "table" then
        local itemId = nItemId[1]
        local itemNum = nItemId[2]
        tData = {
            id = itemId,
            lastNum = itemNum,
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(itemId)
        }
    else
        tData = {
            id = nItemId,
            lastNum = 0,
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(nItemId)
        }
    end
    
    tItem:setCellGoodItem(tData,4)
    return eItem, tItem
end


--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndEquipmentLottery:onClickListItem(element)
    WZLog("WndEquipmentLottery:onClickListItem ")
    WndEquipReward:showInterface(0)
	WndEquipReward:setRewardData(self.m_tRewardInfo,self.m_tRewardItems,self.m_nTenLotteryTime)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief  添加金币图标动画
function WndEquipmentLottery:_addTop()
    local cell, tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    cell:setTag(1199)
    tcell:setTopData("ui/common/common_icon_szzh.png", WndEquipmentLottery, self.onCloseClick,true,true,nil,nil,{goldType=4})
    self.m_topCellLua = tcell
end

-------------------------------------私有方法模块End----------------------------------------
