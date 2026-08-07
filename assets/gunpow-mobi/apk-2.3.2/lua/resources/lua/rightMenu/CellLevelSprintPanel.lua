--CellLevelSprintPanel.lua
--@brief	CellLevelSprintPanel的UI模块
--@date		2015/05/13
--@author	weidong_wu
--@note		等级冲刺
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLevelSprintPanel:onEnter(element)
	self.m_root = element
	self:_initStaticTxt()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLevelSprintPanel:onExit(element)
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function CellLevelSprintPanel:onEnterTransitionDidFinish(element)

end

--@@brief 	显示窗口
function CellLevelSprintPanel:showWindow(  )
     self:_setTabList()
	 self:_setRewardList()
end


--@brief    设置滑动列表的x位置坐标
function CellLevelSprintPanel:getFreeListPositionY()
    local flCellLevelSprintList_CellCellLevelSprintPanel = GetElement(CellLevelSprintPanel.m_current.m_root,"flCellLevelSprintList_CellCellLevelSprintPanel",WZUIFreeListContainer)
    if flCellLevelSprintList_CellCellLevelSprintPanel == nil then
        return
    end
    local PositionY =  flCellLevelSprintList_CellCellLevelSprintPanel:getMinPosition().y
    local movePositionY = flCellLevelSprintList_CellCellLevelSprintPanel:getMoveElement():getPositionY()
    return PositionY,movePositionY
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 初始化静态文本
function CellLevelSprintPanel:_initStaticTxt(  )

end

--@brief 设置奖励列表
function CellLevelSprintPanel:_setRewardList(  )
    local flCellLevelSprintList = GetElement(self.m_root,"flCellLevelSprintList_CellCellLevelSprintPanel",WZUIFreeListContainer)
    if flCellLevelSprintList == nil then
        return
    end

    if flCellLevelSprintList:size() > 0 then 
        flCellLevelSprintList:removeAll()
    end
    self.cellItemIndex = 1 
    self.m_currentIndex = 1
    self:_loadItemByFrame(flCellLevelSprintList)    
end


function CellLevelSprintPanel:_loadItemByFrame(element)
    if element == nil then 
        return 
    end 
    element = WZUIFreeListContainer:luaTo(element)

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
        local cellElement,newLuaObj = CellLevelSprintPanelItem:createElement()
        cellElement = WZUIContainer:luaTo(cellElement)
        newLuaObj:setMessage(self.m_currentIndex,ItemTab.rewardId,ItemTab.m_tData,ItemTab.tips,ItemTab.status,self.activityId,ItemTab.target)
        cellElement:setTag(self.m_currentIndex-1)

        cellElement:setContentSize(GlobalMethod:CCSize(486,138))
        cellElement:setRelativeSize(GlobalMethod:CCSize(1,138/380))
        newLuaObj:setFunc(self.sortItemByIndex,CellLevelSprintPanel)
        element:pushBack(cellElement)
        
        self.m_currentIndex = self.m_currentIndex + 1
    end

    element:update()
    element:getMoveElement():setPositionY(element:getMinPosition().y)
end


function CellLevelSprintPanel:_setTabList(  )
    self.m_tRewardList = {}
    self.m_tRewardList.m_tDoingList = {}
    self.m_tRewardList.m_tDoneList = {}
    local ItemCount = 1
    local DoneIdx = 1
    local DoingIdx = 1
    local itemIndex = 1
    if self.rewardId == nil then return end
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
            DoneIdx = DoneIdx+1
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
            DoingIdx = DoingIdx +1
        end 
    end
end


--@brief    
function CellLevelSprintPanel:sortItemByIndex( nIndex )
    WZLog("CellLevelSprintPanel:removeItemByIndex index="..nIndex)
    local size =  #CellLevelSprintPanel.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i=1,size do
        if nIndex == CellLevelSprintPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellLevelSprintPanel.m_current.m_tRewardList.m_tDoneList
            CellLevelSprintPanel.m_current.m_tRewardList.m_tDoneList[len+1] = {}
            CellLevelSprintPanel.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = CellLevelSprintPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId
            CellLevelSprintPanel.m_current.m_tRewardList.m_tDoneList[len+1].m_tData = CellLevelSprintPanel.m_current.m_tRewardList.m_tDoingList[i].m_tData
            CellLevelSprintPanel.m_current.m_tRewardList.m_tDoneList[len+1].status=1
            CellLevelSprintPanel.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellLevelSprintPanel.m_current.m_tRewardList.m_tDoingList[i].tip
            CellLevelSprintPanel.m_current.m_tRewardList.m_tDoneList[len+1].target = CellLevelSprintPanel.m_current.m_tRewardList.m_tDoingList[i].target
            removePos = i
        end 
    end
    table.remove(CellLevelSprintPanel.m_current.m_tRewardList.m_tDoingList,removePos)
    CellLevelSprintPanel.m_current:_setRewardList()
end
-------------------------------------私有方法模块End----------------------------------------