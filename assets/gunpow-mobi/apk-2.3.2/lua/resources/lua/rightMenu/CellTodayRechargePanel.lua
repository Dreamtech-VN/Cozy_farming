--CellTodayRechargePanel.lua
--@brief	CellTodayRechargePanel的UI模块
--@date		2016/07/18
--@author	maopeiting
--@note		每日充值奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTodayRechargePanel:onEnter(element)
	self.m_root = element
	--self:_initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTodayRechargePanel:onExit(element)
	self:_unInit()
end

--@brief    初始化信息
function CellTodayRechargePanel:setMessage(index,tips,startTime ,endTime ,serverTime,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,activityId,target)
    self.startTime = startTime
    self.endTime = endTime
    self.serverTime = serverTime
    self.rewardItems = rewardItems
    self.rewardId = rewardId
    self.rewardItemsParamCount = rewardItemsParamCount
    self.theirConditions = theirConditions
    self.rewardCounts = rewardCounts
    self.count = count
    self.status = status
    self.index = index
    self.tips = tips
    self.maxCount = maxCount
    self.activityId = activityId
    self.target = target
end

--@brief    显示窗口
function CellTodayRechargePanel:showWindow( )
    self:_setTabList()
    self:_updateReward()
    self:_initUI()
    AdaptLanguage(self)
end

--@brief	初始化界面UI
function CellTodayRechargePanel:_initUI(  )
	local progCostProgress = GetElement(self.m_root,"progCostProgress_CellTodayRechargePanel",WZUIProgress)
	local txtCurCostValue = GetElement(self.m_root,"txtCurCostValue_CellTodayRechargePanel",WZUILabelTTF)

	local value = string.format("%d/%d",self.count,self.maxCount)
	WZLog("CellTodayRechargePanel:value",value)
	txtCurCostValue:setText(value)

	local percentValue = 0.0
	if self.maxCount > 0 then
		percentValue = self.count/self.maxCount
		if percentValue > 1.0 then
			percentValue = 1.0
		end
		percentValue = percentValue * 100
	end
	progCostProgress:setPercentage(percentValue)

end

--@brief	加载奖励
function CellTodayRechargePanel:_updateReward(  )

	local conflListview = GetElement(self.m_root,"conflListview_CellTodayRechargePanel",WZUIFreeListContainer)
	conflListview:removeAll()

	local listCount = #self.m_tRewardList.m_tDoingList + #self.m_tRewardList.m_tDoneList
    if listCount == 0 then 
        return 
    end 
    for i = 1, listCount do
        local ItemTab = nil 
        if self.m_currentIndex > #self.m_tRewardList.m_tDoingList then 
            ItemTab = self.m_tRewardList.m_tDoneList[self.cellItemIndex]
            self.cellItemIndex = self.cellItemIndex + 1
        else 
            ItemTab = self.m_tRewardList.m_tDoingList[self.cellItemIndex]
            if self.m_currentIndex == #self.m_tRewardList.m_tDoingList then 
                self.cellItemIndex = 1 
            else 
                self.cellItemIndex = self.cellItemIndex + 1
            end 
        end

        local cellElement,newLuaObj = CellTodayRechargeItem:createElement()
      	if cellElement and newLuaObj then
      		cellElement = WZUIContainer:luaTo(cellElement)
      		newLuaObj:setMessage(self.m_currentIndex,ItemTab.rewardId,ItemTab.m_tData,ItemTab.tips,ItemTab.status,self.activityId,ItemTab.target)
        	cellElement:setTag(self.m_currentIndex-1)       
       	 	--newLuaObj:setFunc(self.sortItemByIndex,CellTodayRechargePanel)

        	conflListview:pushBack(cellElement)
       		self.m_currentIndex = self.m_currentIndex + 1
      	end
        conflListview:getMoveElement():setPositionY(conflListview:getMinPosition().y)
    end


end

--@brief	充值按钮回调
function CellTodayRechargePanel:RechargeEvent(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    PassportSdkManager:gotoPaymentPage()
    WindowManager:removeWindow(WndWelfare.m_root,WndWelfare,true)
end

function CellTodayRechargePanel:_setTabList(  )
    self.m_tRewardList = {}
    self.m_tRewardList.m_tDoingList = {}
    self.m_tRewardList.m_tDoneList = {}
    local ItemCount = 1
    local DoneIdx = 1
    local DoingIdx = 1
    local itemIndex = 1
    local listCount = #self.rewardId
    for i=1,#self.rewardId do
        local Items
        if self.status[i]==1 then 
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
            Items[DoneIdx].target = self.target[i]
            -- if self.index == 18 then 
            --     Items[DoneIdx].GradeIndex = self.target[listCount+i]
            -- end 
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
            Items[DoingIdx].target = self.target[i]
            -- if self.index == 18 then 
            --     Items[DoingIdx].GradeIndex = self.target[listCount+i]
            -- end
            DoingIdx = DoingIdx +1
        end 
    end
    WZLog("CellTodayRechargePanel:item",Serialize(self.m_tRewardList))
    table.sort(self.m_tRewardList.m_tDoingList, sortReward)
end

--@brief	排序
function sortReward(a, b)
    if a.status ~= b.status then
        return a.status > b.status
    else
        return a.rewardId < b.rewardId
    end
end

function CellTodayRechargePanel:sortItemByIndex( nIndex )
    WZLog("CellTodayRechargePanel:removeItemByIndex index="..nIndex)
    local size =  #CellTodayRechargePanel.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i=1,size do
        if nIndex == CellTodayRechargePanel.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellTodayRechargePanel.m_current.m_tRewardList.m_tDoneList
            CellTodayRechargePanel.m_current.m_tRewardList.m_tDoneList[len+1] = {}
            CellTodayRechargePanel.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = CellTodayRechargePanel.m_current.m_tRewardList.m_tDoingList[i].rewardId
            CellTodayRechargePanel.m_current.m_tRewardList.m_tDoneList[len+1].m_tData = CellTodayRechargePanel.m_current.m_tRewardList.m_tDoingList[i].m_tData
            CellTodayRechargePanel.m_current.m_tRewardList.m_tDoneList[len+1].status=1
            CellTodayRechargePanel.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellTodayRechargePanel.m_current.m_tRewardList.m_tDoingList[i].tip
            CellTodayRechargePanel.m_current.m_tRewardList.m_tDoneList[len+1].target = CellTodayRechargePanel.m_current.m_tRewardList.m_tDoingList[i].target
            removePos = i
        end 
    end
    table.remove(CellTodayRechargePanel.m_current.m_tRewardList.m_tDoingList,removePos)
    CellTodayRechargePanel.m_current:_updateReward()
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin---------------------------------------
function CellTodayRechargePanel:_adaptLanguage_vn(  )
    --GetElement(self.m_root,"CellTotal_day_value",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.66,0.5))
end

function CellTodayRechargePanel:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtRecharge_CellTodayRechargePanel",WZUILabelTTF):setScale(0.7)
end
-------------------------------语言适配End-----------------------------------------------