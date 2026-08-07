--WndFootballActivityData.lua
--@brief	WndFootballActivity的数据模块
--@date		2017/05/22
--@author	peiting_mao
--@note		足球活动入口

WndFootballActivity = {
	--请不要在这里定义变量

}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootballActivity:_init()
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
    self._monstMovePos = nil
    self.m_nPreResult = 2           --点球预设结果
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootballActivity:_unInit()
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
     self._monstMovePos = nil
     self.m_nPreResult = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootballActivity:createElement()
	local element = WZUISystem:getInstance():createElement("WndFootballActivity")
	assert(element, "WndFootballActivity create element failed!")
	self:_init()
	return element
end

--@brief 	获得列表成功
function WndFootballActivity:GetActivityListInfoOK( activityId, title, startTime, endTime, serverTime , types, type2)
	WZLog("WndFootballActivity:GetActivityListInfoOK")
    if self.m_root == nil then return end
    local activityType = g_tGameActivityTypes
	self.m_nListItemServerTime = serverTime
	local index = 1 
    self.m_tListItem = {}
	for i=1,#activityId do
        WZLog("--*****WndFootballActivity****--111", activityId[i], title[i],type2[i],types[i])
		if type2[i] == 5 then    --等于5 的才是世界杯活动
    		if serverTime < endTime[i] then 
    			if types[i] > 0 then 
                    --if types[i] == activityType.ACTIVITY_FOOTBALL_SHOOT then
        			self.m_tListItem[index] = {}
        			self.m_tListItem[index].activityId = activityId[i]
        			self.m_tListItem[index].title = g_tGameActivityTitle[types[i]]
        			self.m_tListItem[index].startTime = startTime[i]
        			self.m_tListItem[index].endTime = endTime[i]
        			self.m_tListItem[index].types = types[i]
        			index = index + 1
                    --end
    			end 
    		end 
        end
	end

    table.sort(self.m_tListItem, function (a,b)
        -- body
        return a.types > b.types
    end)
    
	self:_closeLoading()
	self:_updateListItem()
end

--@brief    有些活动完成后需要将其从活动列表中移除掉
function WndFootballActivity:removeAndUpdateActivityList(activityId)
    -- body
    WZLog("*********** WndFootballActivity:removeAndUpdateActivityList ********")
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
function WndFootballActivity:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	if self.m_root == nil then return end
    self:_closeLoading()
    WZLog("********* WndFootballActivity:GetActivityInfoOK ***** ")
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
end


--处理接收嫂烟花排行榜积分
function WndFootballActivity:handleRankInfo(status, ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRnak,otherServer)
    WZLog("WndFootballActivity:handleRankInfo",status,Serialize(CellFootballGame.m_current.m_tRewardList))
    --if status == 0 or self.m_root == nil then return end
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT then

        local footballShootRank = CellFootballShootRank:createElement()
        if footballShootRank == nil then return end
        CellFootballShootRank:setRankListInfo(ranking, playerId, name, faceId, headId, sex, level, vipLevel, headColour,score,myRnak, otherServer, CellFootballGame.m_current.m_tRewardList)
        footballShootRank:setZOrder(10)
        local conActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
        local childNode = conActivityContext:getChildByTag(122)
        if childNode then
            childNode:setVisible(false)
        end
        conActivityContext:addChild(footballShootRank)
    end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
