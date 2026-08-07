--WndAmberPlayerData.lua
--@brief	WndAmberPlayer的数据模块
--@date		2020/09/09
--@author	nijinlin
--@note		oppo琥珀大玩家专属福利

WndAmberPlayer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAmberPlayer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = 0
	self.m_nListItemServerTime = 0 			--列表中的获得的服务器时间
	self.m_tListItem = nil  				--列表数据表

	self.m_nClickNowId = -1 			--当前选择的item
	self.m_nCurrentSelectTypeId = 0 		--当前选中的类型ID
    self.m_tCellItemObject = nil 
    self.m_nSelectedActivityId = nil    
    self.m_isOpenedOVTips = false --是否已经打开过OV琥珀大玩家进入游戏中心弹框，每次打开界面只允许弹出一次
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAmberPlayer:_unInit()
	self.m_root = nil
	self.m_nLoadingId = 0
	self.m_nListItemServerTime = 0 			--列表中的获得的服务器时间
	self.m_tListItem = nil  				--列表数据表

	self.m_nClickNowId = -1 			--当前选择的item
	self.m_nCurrentSelectTypeId = 0 		--当前选中的类型ID
    self.m_tCellItemObject = nil 
    self.m_nSelectedActivityId = nil    
    self.m_isOpenedOVTips = false --是否已经打开过OV琥珀大玩家进入游戏中心弹框，每次打开界面只允许弹出一次
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAmberPlayer:createElement()
	if WndAmberPlayer.m_root ~= nil then
		WindowManager:removeWindow(WndAmberPlayer.m_root, WndAmberPlayer, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAmberPlayer")
	assert(element, "WndAmberPlayer create element failed!")
	self:_init()
	return element
end

--@brief    获得列表成功
function WndAmberPlayer:GetActivityListInfoOK( activityId, title, startTime, endTime, serverTime , types, type2)
	WZLog("WndAmberPlayer:GetActivityListInfoOK",
        "\nactivityId=",Serialize(activityId),
        "\ntitle=",Serialize(title),
        "\nstartTime=",Serialize(startTime),
        "\nendTime=",Serialize(endTime),
        "\nserverTime=",Serialize(serverTime),
        "\ntypes=",Serialize(types),
        "\ntype2=",Serialize(type2))
    --body
    if self.m_root == nil then return end
    self.m_nListItemServerTime = serverTime
    local index = 1 
    self.m_tListItem = {}
    local temp = nil
    for i=1,#activityId do
        WZLog("WndAmberPlayer:GetActivityListInfoOK1", activityId[i], title[i],type2[i],types[i],serverTime,endTime[i])
        if type2[i] == 9 then    --等于0 的才是活动
            if serverTime < endTime[i] then 
                if types[i]>0 then 
                    if types[i] ~= g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE and types[i] ~= g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE2 then
                        if types[i] == g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL then
                            temp = {}
                            temp.activityId = activityId[i]
                            temp.title = g_tGameActivityTitle[types[i]]
                            temp.startTime = startTime[i]
                            temp.endTime = endTime[i]
                            temp.types = types[i]
                        else
                            self.m_tListItem[index] = {}
                            self.m_tListItem[index].activityId = activityId[i]
                            self.m_tListItem[index].title = g_tGameActivityTitle[types[i]]
                            WZLog("WndAmberPlayer:GetActivityListInfoOK2", self.m_tListItem[index].title, startTime[i], endTime[i], types[i])
                            self.m_tListItem[index].startTime = startTime[i]
                            self.m_tListItem[index].endTime = endTime[i]
                            self.m_tListItem[index].types = types[i]
                            if types[i] == g_tGameActivityTypes.ACTIVITY_MARRYDISCOUNT then
                                g_tMarryDiscountTime = {}
                                g_tMarryDiscountTime.startTime = startTime[i]
                                g_tMarryDiscountTime.endTime = endTime[i]
                            end
                            
                            index = index + 1
                        end
                    end
                end 
            end 
        end
    end

    self:_closeLoading()
    self:_updateListItem()
end

--@brief  获得活动内容成功
function WndAmberPlayer:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self:_closeLoading()
    WZLog("********* WndAmberPlayer:GetActivityInfoOK *****")
    if g_tGameActivityTypes and self.m_nCurrentSelectTypeId and g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE == self.m_nCurrentSelectTypeId then
        WZLog("********* WndAmberPlayer:GetActivityInfoOK ***** ", self.m_nCurrentSelectTypeId)
        for i=1,#status do
            --WZLog("********* WndAmberPlayer:GetActivityInfoOK ***** index=", i, status[i], tips[i])
            if i == 2 then
                WZLog("********* WndAmberPlayer:GetActivityInfoOK ***** index=", i, status[i], tips[i])
                if status[i] and tonumber(status[i]) == -1 then -- -1:不可领取状态 0:未领取可领取 1:已领取
                    WndAmberPlayer:refreshUserData(1, "1")
                else
                    WndAmberPlayer:refreshUserData(1, "0")
                end
            end
        end
    end
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
end

--@brief 更新用户缓存数据
--param1 ntype 类型：0读，1写
--param1 ndata 数据可空 "0"或"1"
--return bool 是否可以显示进入游戏中心的弹框提示
function WndAmberPlayer:refreshUserData(ntype, ndata)
    --读取缓存信息，如果发送过ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OppoWelfare() -125协议，不用再弹框提示进入游戏中心
    --local result = false
    WZLog("WndAmberPlayer:refreshUserData", ntype, ndata)
    local data = WZDataFile:getInstance():getUserData()
    if data then    
        if ntype == 0 then
            local can = data:getStringValue("ExtendInfo", "isCanOpenOPPOGameCenter")    
            if can and can == "1" then
                --MsgBoxManager:showConfirmCancelBox(LocalStrings.GAME_ACTIVITY_OPPO_BIGVIP_TIPS, self, self.OnJumpToOPPOGameCenter, MSGBOXLEVEL_HIGH,nil)
                return true
            else
                return false
            end
            if can then
                WZLog("WndAmberPlayer:refreshUserData", can)
            end
        elseif ntype == 1 then
            data:setStringValue("ExtendInfo", "isCanOpenOPPOGameCenter", ndata)
            data:flush()
        end        
    end
end

--@brief 获取奖励成功
function WndAmberPlayer:GetRewardOk(rewardItems,rewardCount,ntype)
    if self.m_root == nil then return end

	WZLog("WndAmberPlayer:GetRewardOk types="..ntype)
	if ntype == g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE or ntype == g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE2 then 
		CellRechargePanelActivity:showRewardBox(0,rewardItems,rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST == ntype or g_tGameActivityTypes.ACTIVITY_STRENGTHEN == ntype or g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE == ntype or g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE == ntype or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET == ntype 
            or g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL == ntype or g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY == ntype or g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE == ntype or g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY == ntype or g_tGameActivityTypes.ACTIVITY_COST_ONLYTICKET == ntype or g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND == ntype or g_tGameActivityTypes.ACTIVITY_EQUIP_STAR == ntype or g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY == ntype or g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND == ntype or g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE == ntype or g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND == ntype 
            or g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY == ntype or g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY == ntype or g_tGameActivityTypes.ACTIVITY_PET_UPGRADE == ntype or g_tGameActivityTypes.ACTIVITY_MOUNT_UPGRADE == ntype or g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL == ntype or g_tGameActivityTypes.ACTIVITY_PET_QUAIL == ntype  or g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN == ntype  or g_tGameActivityTypes.ACTIVITY_CHANNEL_RECHARGE == ntype 
            or g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT == ntype or g_tGameActivityTypes.ACTIVITY_RECHARGEHAVEGIFT2 == ntype or g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE == ntype then 
		CellTotalRechargeItem:ACTIVITY_ReceiveActivityRewardOk(rewardItems,rewardCount)
	elseif g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE == ntype or g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_SIGNIN == ntype then
		CellAmberPlayer:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
	end 

	local m_bIsContainerActivityType = false
    if CacheCenter.m_tActivityItemRedDotList ~= nil then
    	for idx=1,#CacheCenter.m_tActivityItemRedDotList do
    		--WZLog("=============get RedDot List============="..idx..CacheCenter.m_tActivityItemRedDotList[idx])
            if ntype == CacheCenter.m_tActivityItemRedDotList[idx] then 
                m_bIsContainerActivityType = true  
            end 
        end
    end
    WZLog("WndAmberPlayer:GetRewardOk", Serialize(CacheCenter.m_tActivityItemRedDotList))

    if m_bIsContainerActivityType == false and self.m_tCellItemObject ~= nil then 
        self:removeRedDot(ntype)
    end 
end

--@brief    移除相应活动的红点
function WndAmberPlayer:removeRedDot(ntype)
    -- body
	for i=1, #self.m_tCellItemObject do
	 	local cellTab = self.m_tCellItemObject[i]
	 	if tonumber(ntype) == tonumber(cellTab.key) then 
	 		local luaObj = cellTab.Obj 
	 		luaObj:removeRedDot()
	 		table.remove(self.m_tCellItemObject, i)
	 		return
	 	end 
	end 

    WndActivityIntegrate:setRedDot()
end

--@brief    根据活动类型获取活动日期
function WndAmberPlayer:getActivityTime(activityType)
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
function WndAmberPlayer:_getFirstRedDotItem()
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
