--WndGameActivityData.lua
--@brief	WndGameActivity的数据模块
--@date		2015/04/23
--@author	weidong_wu
--@note		游戏活动界面

WndGameActivity = {
	--请不要在这里定义变量
	
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGameActivity:_init()
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
    self.m_cellItemObj = nil 
    self.m_nSpecifyActivityId = nil     --进活动界面指定显示的活动类型
    self.m_tMsgData = nil   
    self.m_nSelectedActivityId = nil    
    if ProjConfig.CHANNEL_ID == 1042 or ProjConfig.CHANNEL_ID == 1043 or
        ProjConfig.CHANNEL_ID == 1044 then
        self.m_localActivityItem = {
           -- {title = LocalStrings.ASCENDING24, activityId = 999999, types = g_tGameActivityTypes.ACTIVITY_GUANGGAO, button_id = 21},
       }
    else
        self.m_localActivityItem = {
	       -- {title = LocalStrings.ASCENDING24, activityId = 999999, types = g_tGameActivityTypes.ACTIVITY_GUANGGAO, button_id = 21},
            {title = LocalStrings.ATH_REWARD_CHECK, activityId = 999998, types = g_tGameActivityTypes.ACTIVITY_FREEREWARD, button_id = 21}
	   }
    end

    self.m_bJumpReturneeAct = false  --是否可以跳转回归活动
    self.m_tCommonPanle = {}
    self.m_sCurActivityPanel = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGameActivity:_unInit()
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
    self.m_cellItemObj = nil 
    self.m_nSpecifyActivityId = nil     --进活动界面指定显示的活动类型
    self.m_tMsgData = nil 
    self.m_localActivityItem = nil 
    self.m_nSelectedActivityId = nil  
    self.m_tCommonPanle = {}
    self.m_sCurActivityPanel = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGameActivity:createElement(activityId)
	local element = WZUISystem:getInstance():createElement("WndGameActivity")
	assert(element, "WndGameActivity create element failed!")
	self:_init()
    self.m_nSpecifyActivityId = activityId or nil
	return element
end

--@brief    获得列表成功
function WndGameActivity:GetActivityListInfoOK( activityId, title, startTime, endTime, serverTime , types, type2, sortValue)
    --body
    if self.m_root == nil then return end
    self.m_nListItemServerTime = serverTime
    local index = 1 
    self.m_tListItem = {}
    --WZLog("serverTime="..serverTime)
    
    if bJumpReturneeAct then   --判断之后是否有回归活动
        self.m_bJumpReturneeAct = true
    end
    for i=1,#activityId do
        if type2[i] == 0 then    --等于0 的才是活动
            if serverTime < endTime[i] then 
                if types[i]>0 then 
                    if types[i] ~= g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE and types[i] ~= g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE2 and types[i] ~= g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD and types[i] ~= g_tGameActivityTypes.ACIVIITY_WEEKCARD_DISCOUNT and types[i] ~= g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT then
                        self.m_tListItem[index] = {}
                        self.m_tListItem[index].activityId = activityId[i]
                        self.m_tListItem[index].title = g_tGameActivityTitle[types[i]]
                        WZLog("WndGameActivity:GetActivityListInfoOK2", self.m_tListItem[index].title, startTime[i], endTime[i], types[i],activityId[i])
                        self.m_tListItem[index].startTime = startTime[i]
                        self.m_tListItem[index].endTime = endTime[i]
                        self.m_tListItem[index].types = types[i]
                        if types[i] == g_tGameActivityTypes.ACTIVITY_MARRYDISCOUNT then
                            g_tMarryDiscountTime = {}
                            g_tMarryDiscountTime.startTime = startTime[i]
                            g_tMarryDiscountTime.endTime = endTime[i]
                        end
                        if sortValue then 
                            self.m_tListItem[index].sortValue = sortValue[i]
                        end

                        index = index + 1
                    end
                end 
            end 
        end
    end

    table.sort(self.m_tListItem, function (a, b)
        -- body
        return a.sortValue < b.sortValue
    end)

    local foreverCardNum = CacheCenter:getPlayerItemCountById(52)
    local enjoyCardNum = CacheCenter:getPlayerItemCountById(56)

    for idx, value in pairs(self.m_localActivityItem) do
        if CheckButtonShow(value.button_id) then
            if value.types == g_tGameActivityTypes.ACTIVITY_GUANGGAO then
                if CacheCenter:getGameParam().isAd == "true" then
                    table.insert(self.m_tListItem, value)
                end
            elseif value.types == g_tGameActivityTypes.ACTIVITY_FREEREWARD then  
                if NeedFyber(1) then
                    table.insert(self.m_tListItem, value)
                end
            else
                table.insert(self.m_tListItem, value)
            end
        end
    end
    self:_closeLoading()
    self:_updateListItem()
end

--@brief    有些活动完成后需要将其从活动列表中移除掉
function WndGameActivity:removeAndUpdateActivityList(activityId)
    -- body
    WZLog("*********** WndGameActivity:removeAndUpdateActivityList ********")
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
function WndGameActivity:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self:_closeLoading()
    WZLog("********* WndGameActivity:GetActivityInfoOK ** 66666 ***", activityId, self.m_nCurrentSelectTypeId)
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
end

--@brief  获得开服活动-限时折扣内容成功
function WndGameActivity:GetActivityInfoOK_newServer(configId, originPrice, curPrice, needVip, reward, timesLimit, times, countdown)
    self:_closeLoading()
    WZLog("********* WndGameActivity:GetActivityInfoOK *****")
    if #configId == 0 then 
        self:_removeActivityByType(g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT)
        return 
    end
    WndGameActivity:_updateActivityContext_newServer(configId, originPrice, curPrice, needVip, reward, timesLimit, times, countdown)
end

--@brief    获取开服活动-月战力之榜数据
function WndGameActivity:GetMonthFightingListOK_newServer(session, playerId, rank, worshipTimes, totlaWorshipTimes, fighting, name, faceId, headId, sex, level, vipLevel, headColor, bodyId, bodyColor, windId, crossServer, rewardRank, reward)
    self:_closeLoading()
    WZLog("********* WndGameActivity:GetMonthFightingListOK_newServer *****",self.m_nCurrentSelectTypeId)
    
    local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)

    if g_tGameActivityTypes.ACIVIITY_RECHARGERANK == self.m_nCurrentSelectTypeId
        or g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACIVIITY_CONSUMERANK == self.m_nCurrentSelectTypeId
        or g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_FLOWER_LIST == self.m_nCurrentSelectTypeId
        or g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext_newServer|| 开服活动-月战力榜",self.m_nCurrentSelectTypeId)
        if con_ActivityContext then
            con_ActivityContext:removeAllChildrenWithCleanup(true)
        end
        local NodeTag = 132
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellFightingRankPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage_newServer(session, playerId, rank, worshipTimes, totlaWorshipTimes, fighting, name, faceId, headId, sex, level, vipLevel, headColor, bodyId, bodyColor, windId, crossServer, self.m_nCurrentSelectTypeId, rewardRank, reward)

        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelLuaObj:showWindow()
        end
    end

end

--@brief    获取全民众筹活动详情数据
function WndGameActivity:GetManyCollectDataOK(configId, verifyKey, target, current, join, joinType, costItem, joinGain, randomGain, defaultNum)
    self:_closeLoading()
    WZLog("********* WndGameActivity:GetMonthFightingListOK_newServer *****")
    
    local conContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
    if conContext then
        conContext:removeAllChildrenWithCleanup(true)
    end

    if g_tGameActivityTypes.ACTIVITY_MANY_COLLECT == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext_newServer|| 全民众筹")
        local NodeTag = 135
        local bRet = true
        self.m_tCommonPanelElement = conContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellManyCollectPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            conContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(configId, verifyKey, target, current, join, joinType, costItem, joinGain, randomGain, defaultNum)
    end

    if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    获取超值礼包活动详情数据
function WndGameActivity:GetSmallRechargeDataOK(id, icon, count, giftDiamondCount, price, showFlag, name, describe, showPrice, itemId, sort, payCodeId, leftTimes, limitType, needVipLv)
    self:_closeLoading()
    WZLog("********* WndGameActivity:GetSmallRechargeDataOK *****")
    
    local conContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
    if conContext then
        conContext:removeAllChildrenWithCleanup(true)
    end

    if g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext_newServer||超值礼包")
        local NodeTag = 136
        local bRet = true
        self.m_tCommonPanelElement = conContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTotalRechargetPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            conContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage_smallRecharge(id, icon, count, giftDiamondCount, price, showFlag, name, describe, showPrice, itemId, sort, payCodeId, leftTimes, limitType, needVipLv)
    end

    if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end


--@brief 获取奖励成功
function WndGameActivity:GetRewardOk(rewardItems,rewardCount,ntype,rewardId)
    if self.m_root == nil then return end

	WZLog("WndGameActivity:GetRewardOk types="..ntype)
	if ntype == g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE or ntype == g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE2 then 
		CellRechargePanelActivity:showRewardBox(0,rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST == ntype or g_tGameActivityTypes.ACTIVITY_STRENGTHEN == ntype or g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE == ntype or g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE == ntype or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET == ntype 
            or g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL == ntype or g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY == ntype or g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE == ntype or g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY == ntype or g_tGameActivityTypes.ACTIVITY_COST_ONLYTICKET == ntype or g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND == ntype or g_tGameActivityTypes.ACTIVITY_EQUIP_STAR == ntype or g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY == ntype or g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND == ntype or g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE == ntype or g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND == ntype 
            or g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY == ntype or g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY == ntype or g_tGameActivityTypes.ACTIVITY_PET_UPGRADE == ntype or g_tGameActivityTypes.ACTIVITY_MOUNT_UPGRADE == ntype or g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL == ntype or g_tGameActivityTypes.ACTIVITY_PET_QUAIL == ntype  or g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN == ntype  or g_tGameActivityTypes.ACTIVITY_CHANNEL_RECHARGE == ntype 
            or g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL3 == ntype or g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT == ntype or g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 == ntype then 
		CellTotalRechargeItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_GRADE then 
		CellLevelSprintPanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN then 
        CellGradePanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_TIMEDLOGIN then 
		CellGradePanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_IMPROVEFIGHT then 
		CellFightingPanelItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG or ntype == g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG_TICKET then 
		CellActivityGifPanel:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_VIPGIFBAG then 
		CellActivityVipItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_TARGETREWARD_1 or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_2 ==ntype or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_3 == ntype or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_4 == ntype or g_tGameActivityTypes.ACTIVITY_NEWSERVER_ATHLETICSUP == ntype then 
		CellCostActivityItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then
        CellEatthingsPanel:ACTIVITY_TasteOk()
    elseif ntype == g_tGameActivityTypes.ACTIVITY_DAILYFIRSTRECHARGE then 
        CellDailyFirstRecharge:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount, nType)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_TIMEDFIRSTRECHARGE then 
        CellTimeFirstRecharge:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount, nType)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_NEWWEAPON or ntype == g_tGameActivityTypes.ACTIVITY_NEWWEAPON_TICKET then
        CellBuyLimitePanel:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT or ntype == g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT_TICKET or ntype == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then
        CellTimeDiscountPanel:ACTIVITY_BuyGoodsOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_EXCHANGE or ntype == g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE or ntype == g_tGameActivityTypes.ACIVIITY_OLD_EXCHANGE or ntype == g_tGameActivityTypes.ACTIVITY_EXCHANGE_ONE or ntype == g_tGameActivityTypes.ACTIVITY_EXCHANGE_TWO or ntype == g_tGameActivityTypes.ACTIVITY_EXCHANGE_THREE or ntype == g_tGameActivityTypes.ACTIVITY_EXCHANGE_FOUR then
        CellExchangePanel:ACTIVITY_ExchangeGoodsOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_PLAYERBACK then
        WndPlayerBack:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_DISCOUNT_NEW then
        CellDiscountLimitPanel:ACTIVITY_BuyGoodsOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMECHALLENGE then 
        CellTimeChallengePanel:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BREAKEGGS then 
        CellBreakEggsItem:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_TYPE_5009 then 
		CellNewOnLineReward:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_TYPE_5010 then 
        CellNewTotalLogin:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_MANY_COLLECT then 
        CellManyCollectPanel:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_UNIVERSALGROUP then 
        WndUniversalGroup:showRewardBox(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_WEEKEND_LIMITED then
        CellWeekendLimitedPanel:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_DOUBLE_ELEVEN then
        if self.m_tCommonPanelLuaObj then
            self.m_tCommonPanelLuaObj:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount, rewardId)
        end
    elseif ntype == g_tGameActivityTypes.ACTIVITY_INVESTREBATE_NOR then 
        WndInvestRebateNor:showRewardBox(rewardItems, rewardCount)
    elseif ntype == g_tGameActivityTypes.ACTIVITY_CHRISTMAS_CARNIVAL then
        if self.m_tCommonPanelLuaObj then
            self.m_tCommonPanelLuaObj:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount,rewardId)
        end
    elseif ntype == g_tGameActivityTypes.ACTIVITY_EIGHTY_EIGHT then 
        CellEightyEightRecharge:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount, nType)
	end 

	self:removeRedDot(ntype)
end

--@brief    移除相应活动的红点
function WndGameActivity:removeRedDot(ntype)
    -- body
    if self.m_root == nil then return end 
    
    local m_bIsContainerActivityType = false
    if CacheCenter.m_tActivityItemRedDotList ~= nil then
        for idx=1,#CacheCenter.m_tActivityItemRedDotList do
            if ntype == CacheCenter.m_tActivityItemRedDotList[idx] then 
                m_bIsContainerActivityType = true  
            end 
        end
    end
    WZLog("WndGameActivity:removeRedDot", Serialize(CacheCenter.m_tActivityItemRedDotList), m_bIsContainerActivityType)

    if m_bIsContainerActivityType == false and self.m_tCellItemObject ~= nil then 
        for i=1, #self.m_tCellItemObject do
            local cellTab = self.m_tCellItemObject[i]
            if tonumber(ntype) == tonumber(cellTab.key) then 
                local luaObj = cellTab.Obj 
                luaObj:removeRedDot()
                table.remove(self.m_tCellItemObject, i)
                return
            end 
        end 
    end 
end

--@brief    根据活动类型获取活动日期
function WndGameActivity:getActivityTime(activityType)
    -- body
    for i = 1, #self.m_tListItem do 
        if self.m_tListItem[i].types == activityType then
            return self.m_tListItem[i].startTime, self.m_tListItem[i].endTime, self.m_tListItem[i].activityId
        end
    end

    return nil 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取第一个红点的索引
function WndGameActivity:_getFirstRedDotItem()
    -- body
    local nFirstIndex = nil 

    for i = 1, #self.m_tListItem do
        if CacheCenter.m_tActivityItemRedDotList then
            for idx = 1, #CacheCenter.m_tActivityItemRedDotList do
                if self.m_tListItem[i].types == CacheCenter.m_tActivityItemRedDotList[idx] then
                    nFirstIndex = i
                    break 
                end
            end
            if nFirstIndex then 
                break
            end
        end
    end

    return nFirstIndex
end




-------------------------------------私有方法模块End----------------------------------------
