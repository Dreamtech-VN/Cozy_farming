--CellLoginActivityPanel.lua
--@brief	CellLoginActivityPanel的UI模块
--@date		2015/02/05
--@author	weidong_wu
--@note		登录活动界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLoginActivityPanel:onEnter(element)
	self.m_root = element
    --多语言版本界面适配
    AdaptLanguage(self)
end


--@brief onEnter函数执行完成回调
function CellLoginActivityPanel:onEnterTransitionDidFinish(element)
  
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLoginActivityPanel:onExit(element)
    self.m_root:disableSchedule()
    self:_unInit()
end


--@brief    显示登录活动面板
function CellLoginActivityPanel:showWindow()
    if self.m_nCurActivityType and self.m_nCurActivityType == g_tGameActivityTypes.ACTIVITY_BACK_LOGIN then
        -- 适配回归活动界面
        self.m_root:setAbsContentSize(GlobalMethod:CCSize(620,390))
        self.m_root:updateRelativeSize()
        local conUI = GetElement(self.m_root,"conUI_CellLoginActivityPanel",WZUIContainer)
        conUI:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conUI:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        -- conUI:setUseAbsSize(false)
        local txt_activityTime_key = GetElement(self.m_root,"txt_activityTime_key",WZUILabelTTF)
        txt_activityTime_key:setColor(ccc3(255,255,255))
        txt_activityTime_key:setStrokeColor(ccc3(40,60,140))
        txt_activityTime_key:setRelativePosition(GlobalMethod:ccp(0.035,0.6))
        local txt_activityTime_value = GetElement(self.m_root,"txt_activityTime_value",WZUILabelTTF)
        txt_activityTime_value:setColor(ccc3(99,255,96))
        txt_activityTime_value:setStrokeColor(ccc3(40,60,140))
        txt_activityTime_value:setRelativePosition(GlobalMethod:ccp(0.264,0.6))
        local txtMsgInfo = GetElement(self.m_root,"txtMsgInfo_CellLoginActivityPanel",WZUILabelTTF)
        txtMsgInfo:setColor(ccc3(255,255,255))
        txtMsgInfo:setStrokeColor(ccc3(40,60,140))
        txtMsgInfo:setEnableStroke(true)
        txtMsgInfo:setStrokeSize(4)
        GetElement(self.m_root, "flconReturnee_CellLoginActivityPanel", WZUIFreeListContainer):setVisible(true)
        local img9Bg = GetElement(self.m_root,"img9Bg_CellLoginActivityPanel",WZUI9Image)
        img9Bg:setVisible(false)

        self.m_root:enableSchedule("_countDownTime", 1)
    end
	self:_initStaticText()
    self:_setTabList()
    self:_setRewardList()
    AdaptLanguage(self)
end

--@brief    设置滑动列表的x位置坐标
function CellLoginActivityPanel:getFreeListPositionX(  )
    local flistView = GetElement(CellLoginActivityPanel.m_current.m_root, "confl_listview_loginpanel", WZUIFreeListContainer)
    if CellLoginActivityPanel.m_current and CellLoginActivityPanel.m_current.m_nCurActivityType and CellLoginActivityPanel.m_current.m_nCurActivityType == g_tGameActivityTypes.ACTIVITY_BACK_LOGIN then
        flistView = GetElement(CellLoginActivityPanel.m_current.m_root, "flconReturnee_CellLoginActivityPanel", WZUIFreeListContainer)
    end
    if flistView == nil then
        return
    end
    local PositionX =  flistView:getMaxPosition().x
    local movePositionX = flistView:getMoveElement():getPositionX()
    return PositionX,movePositionX
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置奖励列表
function CellLoginActivityPanel:_setRewardList()
    local flistView = GetElement(self.m_root,"confl_listview_loginpanel",WZUIFreeListContainer)
    -- 适配回归活动界面
    if self.m_nCurActivityType and self.m_nCurActivityType == g_tGameActivityTypes.ACTIVITY_BACK_LOGIN then
        flistView = GetElement(self.m_root,"flconReturnee_CellLoginActivityPanel",WZUIFreeListContainer)
    end
    
    if flistView == nil then
        return
    end


    if flistView:size() > 0 then 
        flistView:removeAll()
    end
    --Modify By Tianxiang_Xu
    local bIsNoList = true
    for i=1,#self.rewardId do
        if not (self.rewardId[i] == -1) then
            bIsNoList = false
        end
        WZLog("rewardId="..i.."="..self.rewardId[i])
    end
    local itemCount = 0
    local NowDay = os.date("*t",self.serverTime)
    local DayString = string.format("%02d-%02d",NowDay.month,NowDay.day)
    
    local ItemIdx = 1
    local index = 1
    for i=1,#self.rewardId do
        if not (self.rewardId[i] == -1) then 
            local ItemTab = nil 
            if ItemIdx > #self.m_tRewardList.m_tDoingList then 
                ItemTab = self.m_tRewardList.m_tDoneList[index]
                index = index + 1
            else 
                ItemTab = self.m_tRewardList.m_tDoingList[index]
                if ItemIdx == #self.m_tRewardList.m_tDoingList then 
                    index = 1 
                else 
                    index = index + 1
                end 
            end
            local cellElement,newLuaObj = CellGradePanelItem:createElement()
            cellElement = WZUIContainer:luaTo(cellElement)
            --Add By Tianxiang_Xu
            if self.m_nCurActivityType and self.m_nCurActivityType == g_tGameActivityTypes.ACTIVITY_BACK_LOGIN then
                local sDate = string.format(LocalStrings.ACTIVITY_BACK_TEXT4, ItemTab.rewardId + 1)
                WZLog("********* CellLoginActivityPanel:_setRewardList ******", ItemTab.rewardId, ItemTab.status, self.n_needTime)
                newLuaObj:setMessage(ItemIdx, ItemTab.rewardId, ItemTab.m_tData, sDate, ItemTab.status, self.n_ActivityType, self.m_cellItemObj)
                local nTempRewardId = self:getCurRewardId()
                if nTempRewardId == ItemTab.rewardId then 
                    newLuaObj:setTime(tonumber(self.n_needTime))
                end
            else
                local nStart, nEnd = string.find(ItemTab.tip, "-")
                local sMonth = string.sub(ItemTab.tip, 0, nStart - 1)
                local sDay = string.sub(ItemTab.tip, nEnd + 1, string.len(ItemTab.tip))
                WZLog("********* CellLoginActivityPanel:_setRewardList ******",nStart, nEnd, sMonth, sDay)
                local sDate = string.format(LocalStrings.LIMETED_LOGIN_REWARD, sMonth, sDay)
                --End Add
                newLuaObj:setMessage(ItemIdx,ItemTab.rewardId,ItemTab.m_tData,sDate,ItemTab.status,self.n_ActivityType,self.m_cellItemObj)
            end
            newLuaObj:setUIType(1)
            cellElement:setTag(ItemIdx-1)
            if self.m_nCurActivityType and self.m_nCurActivityType ~= g_tGameActivityTypes.ACTIVITY_BACK_LOGIN then
                if DayString == ItemTab.tip then 
                    newLuaObj:setTime(tonumber(self.n_needTime))
                end 
            end

            cellElement:setContentSize(GlobalMethod:CCSize(486,138))
            cellElement:setRelativeSize(GlobalMethod:CCSize(1,138/340))
            newLuaObj:setFunc(self.sortItemByIndex, CellLoginActivityPanel)
            flistView:pushBack(cellElement)
            ItemIdx = ItemIdx + 1
        end 
    end
    flistView:update()
    flistView:getMoveElement():setPositionY(flistView:getMinPosition().y)
end


--@brief   设置静态文本
function CellLoginActivityPanel:_initStaticText()
	local txt_activityTime_key = GetElement(self.m_root,"txt_activityTime_key",WZUILabelTTF)
	if txt_activityTime_key == nil then 
		return 
	end 
	txt_activityTime_key:setText(LocalStrings.ACTIVITY_TIME_KEY..":")

	local DayStartTab = os.date("*t",self.startTime)
	local DayEndTab = os.date("*t",self.endTime)
    local format_txt_value = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txt_activityTime_value = GetElement(self.m_root,"txt_activityTime_value",WZUILabelTTF)
	if txt_activityTime_value == nil then 
		return 
	end 
	txt_activityTime_value:setText(format_txt_value)
end


function CellLoginActivityPanel:_setTabList(  )
    if not self.rewardId then return end
    
    self.m_tRewardList = {}
    self.m_tRewardList.m_tDoingList = {}
    self.m_tRewardList.m_tDoneList = {}
    local ItemCount = 1
    local DoneIdx = 1
    local DoingIdx = 1
    local itemIndex = 1
    for i=1,#self.rewardId do
        if self.rewardId[i] == -1 then
            local itemCount = self.rewardCounts[i]
            itemIndex = itemIndex + itemCount
        elseif not  (self.rewardId[i] == -1) then 
            local Items
            if self.status[i]==1 or self.status[i]==2 then  --已领取和已过期的
                Items = self.m_tRewardList.m_tDoneList
                Items[DoneIdx] = {}
                Items[DoneIdx].rewardId = self.rewardId[i]
                local tData = {}
                local itemCount = self.rewardCounts[i]
                for i=1,itemCount do
                    local t_item = {id=self.rewardItems[itemIndex],num=self.rewardItemsParamCount[itemIndex]}
                    table.insert(tData,t_item)
                    itemIndex = itemIndex + 1
                end
                Items[DoneIdx].m_tData = tData 
                Items[DoneIdx].tip=self.tips[i]
                Items[DoneIdx].status = self.status[i]
                DoneIdx = DoneIdx +1
            else 
                Items = self.m_tRewardList.m_tDoingList 
                Items[DoingIdx] = {}
                Items[DoingIdx].rewardId = self.rewardId[i]
                local tData = {}
                local itemCount = self.rewardCounts[i]
                for i=1,itemCount do
                    local t_item = {id=self.rewardItems[itemIndex],num=self.rewardItemsParamCount[itemIndex]}
                    table.insert(tData,t_item)
                    itemIndex = itemIndex + 1
                end
                Items[DoingIdx].m_tData = tData
                Items[DoingIdx].tip=self.tips[i]
                Items[DoingIdx].status = self.status[i]
                DoingIdx = DoingIdx +1
            end 
        end 
    end
end

--@brief    
function CellLoginActivityPanel:sortItemByIndex( nIndex )
    WZLog("CellLoginActivityPanel:removeItemByIndex index="..nIndex)
    local size =  #CellLoginActivityPanel.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i = 1, size do
        if nIndex == CellLoginActivityPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellLoginActivityPanel.m_current.m_tRewardList.m_tDoneList
            CellLoginActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1] = {}
            CellLoginActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = CellLoginActivityPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId
            CellLoginActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].m_tData = CellLoginActivityPanel.m_current.m_tRewardList.m_tDoingList[i].m_tData
            CellLoginActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].status=1
            CellLoginActivityPanel.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellLoginActivityPanel.m_current.m_tRewardList.m_tDoingList[i].tip
            removePos = i
            if CellLoginActivityPanel.m_current.m_nCurActivityType and CellLoginActivityPanel.m_current.m_nCurActivityType == g_tGameActivityTypes.ACTIVITY_BACK_LOGIN then
                CellLoginActivityPanel.m_current.n_needTime = 0
            end
        end 
    end
    table.remove(CellLoginActivityPanel.m_current.m_tRewardList.m_tDoingList,removePos)
    CellLoginActivityPanel.m_current:_setRewardList()
end

--@brief    获取当前天奖励Id
function CellLoginActivityPanel:getCurRewardId()
    -- body
    local rewardId = 99
    for i = 1, #self.m_tRewardList.m_tDoingList do
        if self.m_tRewardList.m_tDoingList[i].rewardId < rewardId and self.m_tRewardList.m_tDoingList[i].status == -1 then 
            rewardId = self.m_tRewardList.m_tDoingList[i].rewardId
        end
    end

    return rewardId
end

--@brief    跨天倒数
function CellLoginActivityPanel:_countDownTime(element, delta)
    -- body
    if self.serverTime and self.serverTime > 0 then 
        self.serverTime = self.serverTime - 1
    else
        self.m_root:disableSchedule()
        if WndWelfare.m_root then 
            WndWelfare:chooseMethod()
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin-----------------------------
function CellLoginActivityPanel:_adaptLanguage_vn()
    WZLog("CellLoginActivityPanel:_adaptLanguage_vn")
    GetElement(self.m_root,"txt_activityTime_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.405,0.5))

    -- if self.m_nCurActivityType == g_tGameActivityTypes.ACTIVITY_BACK_LOGIN then    
    --     local txt_activityTime_key = GetElement(self.m_root,"txt_activityTime_key",WZUILabelTTF)
    --     txt_activityTime_key:setScale(0.8)
    --     local txt_activityTime_value = GetElement(self.m_root,"txt_activityTime_value",WZUILabelTTF)
    --     txt_activityTime_value:setScale(0.8)
    --     txt_activityTime_value:setRelativePosition(GlobalMethod:ccp(0.328,0.5))
    -- end
end

function CellLoginActivityPanel:_adaptLanguage_pt()
    GetElement(self.m_root,"txtMsgInfo_CellLoginActivityPanel",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txt_activityTime_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.5))   
end

function CellLoginActivityPanel:_adaptLanguage_en()
    GetElement(self.m_root,"txt_activityTime_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.5))
end

function CellLoginActivityPanel:_adaptLanguage_es()
    GetElement(self.m_root,"txtMsgInfo_CellLoginActivityPanel",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(500))
end

---------------------------------------语言适配End-----------------------------