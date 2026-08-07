--WndNewActivityData.lua
--@brief	WndNewActivity的数据模块
--@date		2017/05/22
--@author	peiting_mao
--@note		一周年活动入口

WndNewActivity = {
	--请不要在这里定义变量

}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNewActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = 0 
	self.m_nListItemServerTime = 0 			--列表中的获得的服务器时间
	self.m_tListItem = {}  				--列表数据表
	self.m_nClickNowId = -1 			--当前选择的item
	self.m_nCurrentSelectTypeId = 0 		--当前选中的类型ID
	self.m_tCommonPanelElement = nil
    self.m_tCommonPanelLuaObj = nil  
    self.confl_ActivityContext = nil
    self.m_tCellItemObject = nil 
    self.m_nSpecifyActivityId = nil     --进活动界面指定显示的活动类型
    self.m_tMsgData = nil   
    self.m_nSelectedActivityId = nil
    self.m_localActivityItem = {
        {title = LocalStrings.ASCENDING24, activityId = 999999, types = g_tGameActivityTypes.ACTIVITY_GUANGGAO, button_id = 21},
    }

    self.m_nDayIndex = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNewActivity:_unInit()
	self.m_root = nil
	self.m_nLoadingId = 0
	self.m_nListItemServerTime = 0 			--列表中的获得的服务器时间
	self.m_tListItem = nil  				--列表数据表
	self.m_nClickNowId = -1 			--当前选择的item
	self.m_nCurrentSelectTypeId = 0 		--当前选中的类型ID
	self.m_tCommonPanelElement = nil
    self.m_tCommonPanelLuaObj = nil  
    self.confl_ActivityContext = nil
    self.m_tCellItemObject = nil
    self.m_nSpecifyActivityId = nil     --进活动界面指定显示的活动类型
    self.m_tMsgData = nil
     self.m_nSelectedActivityId = nil  
     self.m_localActivityItem = nil   
     self.m_nDayIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNewActivity:createElement()
	local element = WZUISystem:getInstance():createElement("WndNewActivity")
	assert(element, "WndNewActivity create element failed!")
	self:_init()
	return element
end

--@brief 	获得列表成功
function WndNewActivity:GetActivityListInfoOK( activityId, title, startTime, endTime, serverTime , types, type2)
	WZLog("WndNewActivity:GetActivityListInfoOK")
    if self.m_root == nil then return end
    local activityType = g_tGameActivityTypes
	self.m_nListItemServerTime = serverTime
	local index = 1 
    self.m_tListItem = {}
	for i=1,#activityId do
        WZLog("--*****WndNewActivity****--111", activityId[i], title[i],type2[i],types[i])
		if type2[i] == 2 then    --等于2 的才是周年活动
    		if serverTime < endTime[i] then 
    			if types[i] > 0 then 
                    if types[i] == activityType.ACTIVITY_CUMULATIVELOGIN2 or types[i] == activityType.ACTIVITY_TYPE_FIREWORK or types[i] == activityType.ACTIVITY_ORDERREDPACK then
        				self.m_tListItem[index] = {}
        				self.m_tListItem[index].activityId = activityId[i]
        				self.m_tListItem[index].title = g_tGameActivityTitle[types[i]]
        				self.m_tListItem[index].startTime = startTime[i]
        				self.m_tListItem[index].endTime = endTime[i]
        				self.m_tListItem[index].types = types[i]
        				index = index + 1
                    end
    			end 
    		end 
        end
	end
    local serverTime = SystemTime:getServerTime()

    local gameParam = CacheCenter:getGameParam()
    local nianGifeStar = gameParam.nianGifeStar
    local nianGifeEnd = gameParam.nianGifeEnd
   
    local tTempStart = SplitStringWithSeparator(nianGifeStar,"-")
    local tTempEnd = SplitStringWithSeparator(nianGifeEnd,"-")
   
    if tTempStart and #tTempStart > 1 and gameParam.gdatatab =="true" then
        
        if not self:_activityBEnd(88888)  then --喜庆礼包
            local tRecharge = {}
            for k,v in pairs(GDatatab_recharge) do
                if v.type == 100 then
                    table.insert(tRecharge,v)
                end
            end
            if #tRecharge > 0 then
                table.sort( tRecharge, function (a,b)
                    if a.id < b.id then
                        return true
                    end
                    return false
                end )
            end

            self.m_tListItem[index] = {}
            self.m_tListItem[index].activityId = 88888
            self.m_tListItem[index].title = LocalStrings.ONE_YEAR_ACTIVITY
            self.m_tListItem[index].startTime = nianGifeStar
            self.m_tListItem[index].endTime = nianGifeEnd
            self.m_tListItem[index].types = 88888
            index =index+1
        end
    end

    if not self:_activityBEnd(99999) then --充值双倍
        self.m_tListItem[index] = {}
        self.m_tListItem[index].activityId = 99999
        self.m_tListItem[index].title = LocalStrings.RECHARGE_DOUBLE
        self.m_tListItem[index].types = 99999
        index =index+1
    end
  
    if not self:_activityBEnd(77777) then -- 许愿活动
        local tWishStartTiem = SplitStringWithSeparator(gameParam.wishWellResetDate,"-",nil,true)
        if tWishStartTiem and #tWishStartTiem >= 3 then
            self.m_tListItem[index] = {}
            self.m_tListItem[index].activityId = 77777
            self.m_tListItem[index].title = LocalStrings.WISHING_COME_BACK
            self.m_tListItem[index].types = 77777

            if serverTime >= 1497888000 then --许愿活动的开启时间
                self.m_tListItem[index].startTime = 0
            else
                local interval = 1497888000 - serverTime
                local second = 24*3600
                local day = math.ceil(math.max(1,interval /second ))
                self.m_tListItem[index].title = LocalStrings.WISHING_NOT_OPEN_TITLE
                self.m_tListItem[index].startTime = day
            end
            index =index+1
        end
    end

    table.sort(self.m_tListItem,function (a,b)
        if a.types == 3029 then
            return true
        end
        return false
    end)
    
	self:_closeLoading()
	self:_updateListItem()
end

--根据活动类型判断活动是否已结束
function WndNewActivity:_activityBEnd(activityType)
    WZLog("WndNewActivity:_activityBEnd")
    local serverTime = SystemTime:getServerTime()

    local gameParam = CacheCenter:getGameParam()
    local timeCur = os.date("*t",serverTime)
    local time = false
    if activityType == 99999 then
        local doubleRechargeEndTime = gameParam.nianGifeEnd2  --充值双倍的结束时间
        local tdoubleRechargeEndTime = SplitStringWithSeparator(doubleRechargeEndTime,"-",nil,true)
        if timeCur.year > tdoubleRechargeEndTime[1] then
            time = true
        elseif timeCur.year < tdoubleRechargeEndTime[1] then
            time = false
        elseif timeCur.month > tdoubleRechargeEndTime[2] then
            time = true
        elseif timeCur.month < tdoubleRechargeEndTime[2] then
            time = false
        elseif timeCur.month == tdoubleRechargeEndTime[2] and timeCur.day >= tdoubleRechargeEndTime[3] then
            time = true
        else
            time = false
        end
        if serverTime >= 1498838400 then
            time = true
        else
            time = false
        end
    elseif activityType == 77777 then
        local wishActivityEnd = gameParam.nianGifeEnd3 -- 许愿活动的结束时间
        
        local tWishEndTime = SplitStringWithSeparator(wishActivityEnd,"-",nil,true)
        if timeCur.year > tWishEndTime[1] then
            time = true
        elseif timeCur.year < tWishEndTime[1] then
            time = false
        elseif timeCur.month > tWishEndTime[2] then
            time = true
        elseif timeCur.month < tWishEndTime[2] then
            time = false
        elseif timeCur.month == tWishEndTime[2] and timeCur.day >= tWishEndTime[3] then
            time = true
        else
            time = false
        end
        -- if serverTime >= 1498579200 then
        --     time = true
        -- else
        --     time = false
        -- end
    elseif activityType == 88888 then --喜庆礼包
        local tRedBox = SplitStringWithSeparator(CacheCenter:getGameParam().nianGifeEnd or "", "-",nil,true)
        if timeCur.year > tRedBox[1] then
            time = true
        elseif timeCur.year < tRedBox[1] then
            time = false
        elseif timeCur.month > tRedBox[2] then
            time = true
        elseif timeCur.month < tRedBox[2] then
            time = false
        elseif timeCur.month == tRedBox[2] and timeCur.day >= tRedBox[3] then
            time = true
        else
            time = false
        end
        if serverTime >= 1498838400 then
            time = true
        else
            time = false
        end
    end
    return time
end

--@brief    有些活动完成后需要将其从活动列表中移除掉
function WndNewActivity:removeAndUpdateActivityList(activityId)
    -- body
    WZLog("*********** WndNewActivity:removeAndUpdateActivityList ********")
    if self.m_tListItem == nil or self.m_tListItem == {} then return end
    for i = 1, #self.m_tListItem do
        if self.m_tListItem[i].activityId == activityId then
            table.remove(self.m_tListItem, i)
            break
        end
    end

    self:_updateListItem()
end

--@brief  获得活动内容成功
function WndNewActivity:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	if self.m_root == nil then return end
    self:_closeLoading()
    WZLog("********* WndNewActivity:GetActivityInfoOK ***** ")
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
end


--@brief  获得充值礼包信息成功
function WndNewActivity:GetVipRechargeInfoOK(ids, icons, number, giftNumber, price, payCodeId, flag, name, remark,showPrice,itemId,sortId,leftTimes, limitType, needVipLv)
    WZLog("WndNewActivity:GetVipRechargeInfoOK ")
    if self.m_root == nil then return end 
    self:_closeLoading()
    if self.m_nCurrentSelectTypeId == 88888 then    
        local tempT = {}
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

            table.insert(tempT,tempTT)
        end
        table.sort( tempT, function (a,b)
            if a[1] < b[1] then
                return true
            end
            return false
        end )

        local conActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
        conActivityContext:removeAllChildrenWithCleanup(true)

        local childNode = CellRechargePacks:createElement()
        CellRechargePacks:setData(tempT)
        conActivityContext:addChild(childNode)
    end
end

--@brief 获取奖励成功
function WndNewActivity:GetRewardOk(rewardItems,rewardCount,ntype)
    if self.m_root == nil then return end

	WZLog("WndNewActivity:GetRewardOk types=",ntype,Serialize(rewardItems),Serialize(rewardCount))
	if ntype == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN then 
        CellGradePanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_TIMEDLOGIN then 
		CellGradePanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2 then
        CellDayRewardContain:updateUI(self.m_nDayIndex,1)
        if rewardItems ~= nil and #rewardItems > 0 and  rewardItems[1] > 0 then
            WndRewardShow:showById(rewardItems,rewardCount)
        end
	end 

	local m_bIsContainerActivityType = false
    if CacheCenter.m_tActivityItemRedDotList ~= nil then
    	for idx=1,#CacheCenter.m_tActivityItemRedDotList do
            if ntype == CacheCenter.m_tActivityItemRedDotList[idx] then 
                m_bIsContainerActivityType = true  
            end 
        end
    end
    WZLog("WndNewActivity:GetRewardOk")

    if m_bIsContainerActivityType == false and self.m_tCellItemObject ~= nil then 
    	for i=1,#self.m_tCellItemObject do
    	 	local cellTab = self.m_tCellItemObject[i]
    	 	if tonumber(ntype) == tonumber(cellTab.key) then 
    	 		local luaObj = cellTab.Obj 
    	 		luaObj:removeRedDot()
    	 		table.remove(self.m_tCellItemObject,i)
    	 		return
    	 	end 
    	end 
    end 
end


function WndNewActivity:sendProErrorResetCellLua()
    WZLog("sendProErrorResetCellLua")
    if self.m_root == nil then return end
    self.m_cellGetReward = nil
end

--处理接收嫂烟花排行榜积分
function WndNewActivity:handleRankInfo(status, ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRnak,otherServer)
    WZLog("WndNewActivity:handleRankInfo")
    if status == 0 or self.m_root == nil then return end
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then

        local cellFireworksAnn = CellFireworksAnn:createElement()
        if cellFireworksAnn == nil then return end
        CellFireworksAnn:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRnak,otherServer)
        cellFireworksAnn:setZOrder(10)
        local conActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
        local childNode = conActivityContext:getChildByTag(122)
        if childNode then
            childNode:setVisible(false)
        end
        conActivityContext:addChild(cellFireworksAnn)
    end
end

function WndNewActivity:resetLocalRechargeInfo()
    -- body
    WZLog("WndNewActivity:resetLocalRechargeInfo")
    if RECHARGE_CURRENT_ID ~= nil then
        local indexxx = nil
        local playerInfo = CacheCenter:getPlayerInfo()
        for i,v in ipairs(RECHARGE_YEAR_ACTIVITY) do
            if v.ids == RECHARGE_CURRENT_ID and v.playerId == playerInfo.id then
                indexxx = i
                break
            end
        end
        RECHARGE_CURRENT_ID = nil
        if indexxx ~= nil then
            table.remove(RECHARGE_YEAR_ACTIVITY,indexxx)
            self:saveRechargeInfo()
        end
    end
end

--更新本地的充值信息
function WndNewActivity:saveRechargeInfo()
    -- body
    WZLog("WndNewActivity:saveRechargeInfo")
    local tempS = Serialize(RECHARGE_YEAR_ACTIVITY,nil,true)
    if tempS ~= nil then
        WZLog("CellRechargePacks:rechargeCallback = ",tempS)
        WZFileUtil:writeStringToFile("rechargeTemp.txt",tempS,false)
    end
end

--更新本地充值的缓存信息
function WndNewActivity:updateRechargeInfo(price,ids,leftTimes)
    WZLog("WndNewActivity:updateRechargeInfo", price, ids,leftTimes)
	local price = tonumber(price)
	local ids = tonumber(ids)
	local leftTimes = tonumber(leftTimes)
	if leftTimes == nil then leftTimes = 1 end
    WZLog("WndNewActivity:updateRechargeInfo1", price, ids,leftTimes)
    local strTemp = WZFileUtil:getStringFromFile("rechargeTemp.txt",false)
    local tempT = Unserialize(strTemp)
		WZLog("WndNewActivity:updateRechargeInfo_start", Serialize(tempT))
    if tempT ~= nil and tempT ~= "" and type(tempT) == "table" then
        RECHARGE_YEAR_ACTIVITY = tempT
        local tempT = {}
        local serverTime = SystemTime:getServerTime()
        local playerInfo = CacheCenter:getPlayerInfo()
        for i,v in ipairs(RECHARGE_YEAR_ACTIVITY) do
            if v.time - serverTime > 600 and v.playerId == playerInfo.id  then --失败超过10分钟的把这条信息进行删除
                local temp = {}

                table.insert(temp,v.ids)
                table.insert(temp,v.playerId)

                table.insert(tempT,temp)
            end
            if price then
					WZLog("看类型", type(v.price), type(price), type(v.playerId), type(playerInfo.id), type(v.ids), type(ids))
                if v.price == price and v.playerId == playerInfo.id and v.ids == ids and v.leftTimes ~= leftTimes then
                    local temp = {}
                    table.insert(temp,v.ids)
                    table.insert(temp,v.playerId)

                    table.insert(tempT,temp)
                end
            end
        end
        local index = nil
        for i,v in ipairs(tempT) do
            index = nil
            for j,k in ipairs(RECHARGE_YEAR_ACTIVITY) do
                if v[1] == k.ids and v[2] == playerInfo.id then
                    index = j
                    break
                end
            end
            if index then
                table.remove(RECHARGE_YEAR_ACTIVITY,index)
            end
        end
		WZLog("WndNewActivity:updateRechargeInfo_end", Serialize(tempT))
        if #tempT > 0 then
            self:saveRechargeInfo()
        end
    end
end

--是否可以进行充值
function WndNewActivity:bRecharge(price,ids,playerId,leftTimes)
    WZLog("WndNewActivity:bRecharge ",price,ids,playerId)
    do return true end
    price = tonumber(price)
    ids = tonumber(ids)
    playerId = tonumber(playerId)
    leftTimes = tonumber(leftTimes)
	if leftTimes == nil then leftTimes = 1 end

    local indexx = nil
    if #RECHARGE_YEAR_ACTIVITY > 0 then 
        for i,v in ipairs(RECHARGE_YEAR_ACTIVITY) do
            if v.ids == ids and v.playerId == playerId then
                local tempTime = v.time
                local serverTime = SystemTime:getServerTime()
                if serverTime - tempTime <= 600 then 
                    MsgBoxManager:showTipBox(LocalStrings.RECHARGE_YEAR_ACTIVITY_BAG)
                    return false
                end
                indexx = i  
                break
            end
        end
        if indexx ~= nil then --充值成功等待10分钟都没有收到成功的协议则可以重新充值
            table.remove(RECHARGE_YEAR_ACTIVITY,indexx)
        end
    end

    local tempT = {}
    tempT.price = price
    tempT.ids = ids
    tempT.time = SystemTime:getServerTime()
    tempT.playerId = playerId
	tempT.leftTimes = leftTimes
    table.insert(RECHARGE_YEAR_ACTIVITY,tempT)
    RECHARGE_CURRENT_ID = ids
    self:saveRechargeInfo()
    return true
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--周年活动是否已开始
function WndNewActivity:_bActivityStart()
    WZLog("WndNewActivity:_bActivityStart")
    local serverTime = SystemTime:getServerTime()

    local timeCur = os.date("*t",serverTime)


    local gameParam = CacheCenter:getGameParam()
    local activityStartTime = gameParam.nianGifeStar or ""
    local tTempStart = SplitStringWithSeparator(activityStartTime,"-")
    local DayEndTab = {}
    local time = false
    if #tTempStart == 3 then
        DayEndTab.year = tonumber(tTempStart[1])
        DayEndTab.month = tonumber(tTempStart[2])
        DayEndTab.day = tonumber(tTempStart[3])
        if timeCur.year > DayEndTab.year then
            time = true
        elseif timeCur.year < DayEndTab.year then
            time = false
        elseif timeCur.month > DayEndTab.month then
            time = true
        elseif timeCur.month < DayEndTab.month then
            time = false
        elseif timeCur.month == DayEndTab.month and timeCur.day >= DayEndTab.day then
            time = true
        else
            time = false
        end
        if serverTime >= 1497542400 then
            time = true
        else 
            time = false
        end
    end
    return time
end

function WndNewActivity:_updateLoginRed(bVisible)
    WZLog("WndNewActivity:_updateLoginRed")
    if bVisible == nil then return end
    local conActivity1 = GetElement(self.m_root,"conActivity1_WndNewActivity",WZUIContainer)
    local imgActRed = GetElement(conActivity1,"imgActRed_WndNewActivity",WZUIImage)
    imgActRed:setVisible(bVisible)
end



--周年活动是否存在
function WndNewActivity:_activityIsExit(activityType)
    WZLog("WndNewActivity:_activityIsExit =",activityType)
    local serverTime = SystemTime:getServerTime()
    local timeTemp = os.date("*t",serverTime)
    local timeCur = timeTemp
    local time = false
    if activityType == 77777 then --许愿的活动
        local tWishEndTime = SplitStringWithSeparator(CacheCenter:getGameParam().nianGifeEnd3 or "", "-",nil,true)
        if timeCur.year > tWishEndTime[1] then
            time = false
        elseif timeCur.year < tWishEndTime[1] then
            time = true
        elseif timeCur.month > tWishEndTime[2] then
            time = false
        elseif timeCur.month < tWishEndTime[2] then
            time = true
        elseif timeCur.month == tWishEndTime[2] and timeCur.day >= tWishEndTime[3] then
            time = false
        else
            time = true
        end
        -- if serverTime >= 1498579200 then
        --     time = false
        -- else
        --     time = true
        -- end
    elseif activityType == 99999 then --充值双倍
        local tdoubleRechargeEndTime = SplitStringWithSeparator(CacheCenter:getGameParam().nianGifeEnd2 or "", "-",nil,true)
        if timeCur.year > tdoubleRechargeEndTime[1] then
            time = false
        elseif timeCur.year < tdoubleRechargeEndTime[1] then
            time = true
        elseif timeCur.month > tdoubleRechargeEndTime[2] then
            time = false
        elseif timeCur.month < tdoubleRechargeEndTime[2] then
            time = true
        elseif timeCur.month == tdoubleRechargeEndTime[2] and timeCur.day >= tdoubleRechargeEndTime[3] then
            time = false
        else
            time = true
        end
        if serverTime >= 1498838400 then
            time = false
        else
            time = true
        end
    elseif activityType == 88888 then --喜庆礼包
        local tRedBox = SplitStringWithSeparator(CacheCenter:getGameParam().nianGifeEnd or "", "-",nil,true)
        if timeCur.year > tRedBox[1] then
            time = false
        elseif timeCur.year < tRedBox[1] then
            time = true
        elseif timeCur.month > tRedBox[2] then
            time = false
        elseif timeCur.month < tRedBox[2] then
            time = true
        elseif timeCur.month == tRedBox[2] and timeCur.day >= tRedBox[3] then
            time = false
        else
            time = true
        end
        if serverTime >= 1498838400 then
            time = false
        else
            time = true
        end
    elseif activityType == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2 then  --周年累计登录
        for i,v in ipairs(self.m_tListItem) do
            if v.types == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2 then
                local endTime = v.endTime
                if endTime and serverTime >= endTime then
                    return false
                end
            end
        end
        return true
    elseif activityType == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then  --放烟花的活动
        for i,v in ipairs(self.m_tListItem) do
            if v.types == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then
                local endTime = v.endTime
                if endTime and serverTime >= endTime then
                    return false
                end
            end
        end
        return true
    elseif activityType == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK then  --口令红包活动
        for i,v in ipairs(self.m_tListItem) do
            if v.types == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK then
                local endTime = v.endTime
                if endTime and serverTime >= endTime then
                    return false
                end
            end
        end
        return true
    else
        local tTemp = SplitStringWithSeparator(CacheCenter:getGameParam().nianGifeEnd or "", "-",nil,true)
        if timeCur.year > tTemp[1] then
            time = false
        elseif timeCur.year < tTemp[1] then
            time = true
        elseif timeCur.month > tTemp[2] then
            time = false
        elseif timeCur.month < tTemp[2] then
            time = true
        elseif timeCur.month == tTemp[2] and timeCur.day >= tTemp[3] then
            time = false
        else
            time = true
        end
        if serverTime >= 1498838400 then
            time = false
        else
            time = true 
        end
    end
    return time
end

-------------------------------------私有方法模块End----------------------------------------
