--CellBackFightPanel.lua
--@brief	CellBackFightPanel的UI模块
--@date		2018/11/21
--@author	Tianxiang_Xu
--@note		回归活动-每日战斗


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBackFightPanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBackFightPanel:onExit(element)
	self:_unInit()
end

--@brief 	显示登录活动面板
function CellBackFightPanel:showWindow()
	self:_initStaticText()
    self:_setTabList()
    self:_setRewardList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置奖励列表
function CellBackFightPanel:_setRewardList()
    local flistView = GetElement(self.m_root,"flistView_CellBackFightPanel", WZUIFreeListContainer)
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
    if bIsNoList == true then
        GetElement(self.m_root, "conLight_CellBackFightPanel", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "imgGiftBox1_CellBackFightPanel", WZUIImage):setVisible(false)
        GetElement(self.m_root, "imgGiftBox2_CellBackFightPanel", WZUIImage):setVisible(false)
    end

    local itemCount = 0
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
            local cellElement,newLuaObj = CellBackFightItem:createElement()
            cellElement = WZUIContainer:luaTo(cellElement)

            newLuaObj:setData(ItemTab)

            cellElement:setTag(ItemIdx-1)

            cellElement:setContentSize(GlobalMethod:CCSize(486,138))
            cellElement:setRelativeSize(GlobalMethod:CCSize(1,138/340))
            newLuaObj:setFunc(self.sortItemByIndex, CellBackFightPanel)
            flistView:pushBack(cellElement)
            ItemIdx = ItemIdx + 1
        end 
    end
    flistView:update()
    flistView:getMoveElement():setPositionY(flistView:getMinPosition().y+20)
end

--@brief   设置静态文本
function CellBackFightPanel:_initStaticText()
	local txtTime = GetElement(self.m_root, "txtTime_CellBackFightPanel", WZUILabelTTF)
	if txtTime == nil then 
		return 
	end 
	txtTime:setText(LocalStrings.ACTIVITY_TIME_KEY..":")

	local DayStartTab = os.date("*t", self.startTime)
	local DayEndTab = os.date("*t", self.endTime)
    local format_txt_value = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_CellBackFightPanel", WZUILabelTTF)
	if txtTimeValue == nil then 
		return 
	end 
	txtTimeValue:setText(format_txt_value)
end


function CellBackFightPanel:_setTabList(  )
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
                Items[DoneIdx].activityId = self.n_ActivityType
                local tData = {}
                local itemCount = self.rewardCounts[i]
                for i=1,itemCount do
                    local t_item = {id=self.rewardItems[itemIndex],num=self.rewardItemsParamCount[itemIndex]}
                    table.insert(tData,t_item)
                    itemIndex = itemIndex + 1
                end
                Items[DoneIdx].reward = tData 
                Items[DoneIdx].tip=self.tips[i]
                Items[DoneIdx].desc=self.content[i]
                Items[DoneIdx].status = self.status[i]
                Items[DoneIdx].maxNum = self.target[(i-1)*3 + 1]
                Items[DoneIdx].uiId = self.target[(i-1)*3 + 2]
                Items[DoneIdx].curNum = self.target[(i-1)*3 + 3]
                DoneIdx = DoneIdx +1
            else 
                Items = self.m_tRewardList.m_tDoingList 
                Items[DoingIdx] = {}
                Items[DoingIdx].rewardId = self.rewardId[i]
                Items[DoingIdx].activityId = self.n_ActivityType
                local tData = {}
                local itemCount = self.rewardCounts[i]
                for i=1,itemCount do
                    local t_item = {id=self.rewardItems[itemIndex],num=self.rewardItemsParamCount[itemIndex]}
                    table.insert(tData,t_item)
                    itemIndex = itemIndex + 1
                end
                Items[DoingIdx].reward = tData
                Items[DoingIdx].tip=self.tips[i]
                Items[DoingIdx].desc=self.content[i]
                Items[DoingIdx].status = self.status[i]
                Items[DoingIdx].maxNum = self.target[(i-1)*3 + 1]
                Items[DoingIdx].uiId = self.target[(i-1)*3 + 2]
                Items[DoingIdx].curNum = self.target[(i-1)*3 + 3]
                DoingIdx = DoingIdx +1
            end 
        end 
    end
end


--@brief    
function CellBackFightPanel:sortItemByIndex( nIndex )
    WZLog("CellBackFightPanel:removeItemByIndex index="..nIndex)
    local size =  #CellBackFightPanel.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i=1,size do
        if nIndex == CellBackFightPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellBackFightPanel.m_current.m_tRewardList.m_tDoneList
            local tTempData = CellBackFightPanel.m_current.m_tRewardList.m_tDoingList[i]
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1] = {}

            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = tTempData.rewardId
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].activityId = tTempData.activityId
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].reward = tTempData.reward
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].status = 1
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].tip = tTempData.tip
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].desc = tTempData.desc
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].maxNum = tTempData.maxNum
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].uiId = tTempData.uiId
            CellBackFightPanel.m_current.m_tRewardList.m_tDoneList[len+1].curNum = tTempData.curNum
            removePos = i
        end 
    end
    table.remove(CellBackFightPanel.m_current.m_tRewardList.m_tDoingList,removePos)
    CellBackFightPanel.m_current:_setRewardList()
end
-------------------------------------私有方法模块End----------------------------------------

function CellBackFightPanel:_adaptLanguage_vn()
    -- GetElement(self.m_root, "txtTimeValue_CellBackFightPanel", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.405,0.5))
    local txtTime = GetElement(self.m_root,"txtTime_CellBackFightPanel",WZUILabelTTF)
    txtTime:setScale(0.8)
    local txtTimeValue = GetElement(self.m_root,"txtTimeValue_CellBackFightPanel",WZUILabelTTF)
    txtTimeValue:setScale(0.8)
    txtTimeValue:setRelativePosition(GlobalMethod:ccp(0.328,0.5))
end