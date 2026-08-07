--CellFightingPanel.lua
--@brief	CellFightingPanel的UI模块
--@date		2015/05/13
--@author	weidong_wu
--@note		战力冲刺活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFightingPanel:onEnter(element)
	self.m_root = element
	self:_initStaticTxt()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFightingPanel:onExit(element)
    local flFightingList_CellFightingPanel = GetElement(self.m_root,"flFightingList_CellFightingPanel",WZUIFreeListContainer)
    flFightingList_CellFightingPanel:disableSchedule()
	self:_unInit()
end

--@brief onEnter函数执行完成回调
function CellFightingPanel:onEnterTransitionDidFinish(element)

end

--@@brief 	显示窗口
function CellFightingPanel:showWindow(  )
    self:_setTabList()
	self:_setRewardList()
end


--@brief 	我要变强的按钮响应
function CellFightingPanel:BeStrongeEvent(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	CheckLuaLoad(LUAFILES_BLOCK_COMMON)
    CheckLuaLoad(Chat_Channel_BecomeStronger)
    WndStrong:showInterface()
end

--@brief    设置滑动列表的x位置坐标
function CellFightingPanel:getFreeListPositionY()
    local flFightingList_CellFightingPanel = GetElement(CellFightingPanel.m_current.m_root,"flFightingList_CellFightingPanel",WZUIFreeListContainer)
    if flFightingList_CellFightingPanel == nil then
        return
    end
    local PositionY =  flFightingList_CellFightingPanel:getMinPosition().y
    local movePositionY = flFightingList_CellFightingPanel:getMoveElement():getPositionY()
    return PositionY,movePositionY
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 初始化静态文本
function CellFightingPanel:_initStaticTxt(  )
    local txtCurLevel = GetElement(self.m_root, "txtCurLevel_CellFightingPanel", WZUIFreeTextBox)
    local sContentTemp = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,236,193" S="22" P="1">%d</T>]]
    strProTxt = string.format(sContentTemp, LocalStrings.ACTIVITY_CURRENT_FIGHTING, CacheCenter:getPlayerInfo().fighting)
    txtCurLevel:setShowText(strProTxt)
end

--@brief 设置奖励列表
function CellFightingPanel:_setRewardList(  )
    local flFightingList_CellFightingPanel = GetElement(self.m_root,"flFightingList_CellFightingPanel",WZUIFreeListContainer)
    if flFightingList_CellFightingPanel == nil then
        return
    end

    if flFightingList_CellFightingPanel:size() > 0 then 
        flFightingList_CellFightingPanel:removeAll()
    end

    self.cellItemIndex = 1 
    self.m_currentIndex = 1

    self:_loadItemByFrame(flFightingList_CellFightingPanel)
end


function CellFightingPanel:_loadItemByFrame( element,delate )
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

        local cellElement,newLuaObj = CellFightingPanelItem:createElement()
        cellElement = WZUIContainer:luaTo(cellElement)
        newLuaObj:setMessage(self.m_currentIndex,ItemTab.rewardId,ItemTab.m_tData,ItemTab.tips,ItemTab.status,self.index,ItemTab.target)
        cellElement:setTag(self.m_currentIndex-1)
        newLuaObj:setFunc(self.sortItemByIndex,CellFightingPanel)
        cellElement:setContentSize(GlobalMethod:CCSize(486,138))
        cellElement:setRelativeSize(GlobalMethod:CCSize(1,138/350))
        element:pushBack(cellElement)
        element:update()
        element:getMoveElement():setPositionY(element:getMinPosition().y)
        self.m_currentIndex = self.m_currentIndex + 1
    end
end


function CellFightingPanel:_setTabList(  )
    self.m_tRewardList = {}
    self.m_tRewardList.m_tDoingList = {}
    self.m_tRewardList.m_tDoneList = {}
    local ItemCount = 1
    local DoneIdx = 1
    local DoingIdx = 1
    local itemIndex = 1
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
            DoingIdx = DoingIdx +1
        end 
    end
end


--@brief    
function CellFightingPanel:sortItemByIndex( nIndex )
    WZLog("CellFightingPanel:removeItemByIndex index="..nIndex)
    local size =  #CellFightingPanel.m_current.m_tRewardList.m_tDoingList
    local removePos = 0
    for i=1,size do
        if nIndex == CellFightingPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId then 
            local len = #CellFightingPanel.m_current.m_tRewardList.m_tDoneList
            CellFightingPanel.m_current.m_tRewardList.m_tDoneList[len+1] = {}
            CellFightingPanel.m_current.m_tRewardList.m_tDoneList[len+1].rewardId = CellFightingPanel.m_current.m_tRewardList.m_tDoingList[i].rewardId
            CellFightingPanel.m_current.m_tRewardList.m_tDoneList[len+1].m_tData = CellFightingPanel.m_current.m_tRewardList.m_tDoingList[i].m_tData
            CellFightingPanel.m_current.m_tRewardList.m_tDoneList[len+1].status=1
            CellFightingPanel.m_current.m_tRewardList.m_tDoneList[len+1].tip=CellFightingPanel.m_current.m_tRewardList.m_tDoingList[i].tip
            CellFightingPanel.m_current.m_tRewardList.m_tDoneList[len+1].target = CellFightingPanel.m_current.m_tRewardList.m_tDoingList[i].target
            removePos = i
        end 
    end
    table.remove(CellFightingPanel.m_current.m_tRewardList.m_tDoingList,removePos)
    CellFightingPanel.m_current:_setRewardList()
end
-------------------------------------私有方法模块End----------------------------------------
