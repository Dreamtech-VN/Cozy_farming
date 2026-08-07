--CellPrivilegesGrowth.lua
--@brief	CellPrivilegesGrowth的UI模块
--@date		2022/03/22
--@author	yrd
--@note		大厅特权-成长礼包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPrivilegesGrowth:onEnter(element)
	self.m_root = element

	GlobalGame:getGameEventDispathcer():Add(LobbyPrivilegesEvent.LobbyPrivilegesEvent_GrowthReceive,self.getActivityDoOk,self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPrivilegesGrowth:onExit(element)
	GlobalGame:getGameEventDispathcer():Remove(LobbyPrivilegesEvent.LobbyPrivilegesEvent_GrowthReceive,self.getActivityDoOk,self)

	self:_unInit()
end

--@brief 	显示登录活动面板
function CellPrivilegesGrowth:showWindow()
	self:updateUI()
end

--@brief 	更新界面
function CellPrivilegesGrowth:updateUI()
	self.m_tTaskItemObj = {}

	local flcTaskItems = GetElement(self.m_root,"flcTaskItems_CellPrivilegesGrowth",WZUIFreeListContainer)
	flcTaskItems:removeAll()
	for i=1,#self.m_tTaskData do
		local conTaskItem = WZUISystem:getInstance():createElement("conTaskItem_CellPrivilegesGrowth")
		conTaskItem = WZUIContainer:luaTo(conTaskItem)
		conTaskItem:setVisible(true)
        flcTaskItems:pushBack(conTaskItem)
        self.m_tTaskItemObj[i] = conTaskItem

        local txtLevel = GetElement(conTaskItem,"txtLevel",WZUILabelTTF)
        txtLevel:setText(self.m_tTaskData[i].rewardDesc)

	    local imgReceived = GetElement(conTaskItem,"imgReceived",WZUIImage)
	    local btnReceive = GetElement(conTaskItem,"btnReceive",WZUIButton)
	    btnReceive:setTag(self.m_tTaskData[i].level) --保存等级在领取奖励时用
	    if self.m_tTaskData[i].giftStates == -1 then
	        imgReceived:setVisible(false)
	        btnReceive:setVisible(true)
	        btnReceive:setTouchEnable(false)
	    elseif self.m_tTaskData[i].giftStates == 0 then
	        imgReceived:setVisible(false)
	        btnReceive:setVisible(true)
	        btnReceive:setTouchEnable(true)
	    elseif self.m_tTaskData[i].giftStates == 1 then
	        imgReceived:setVisible(true)
	        btnReceive:setVisible(false)
	    end

	    for j=1,4 do
		    local conItem = GetElement(conTaskItem,"conItem"..j,WZUIContainer)
		    conItem:removeAllChildrenWithCleanup(true)
	    	if self.m_tTaskData[i].rewardItems[j] then
		        local element, tNewObj = CellGoodItem:createElement()
		        if element and tNewObj then 
		            element:setTag(j - 1)
		            tNewObj:setCellGoodLocalId(self.m_tTaskData[i].rewardItems[j].itemId, self.m_tTaskData[i].rewardItems[j].itemCount, 17)
		            tNewObj:setItemClickFun(self, self.onClickItem)
		            conItem:addChild(element)
		        end
	        end
	    end
	end

    flcTaskItems:getMoveElement():setPositionY(flcTaskItems:getMinPosition().y)
end

--@brief    点击奖励回调
function CellPrivilegesGrowth:onClickItem(tItem, nTag, tData)
    WZLog("CellPrivilegesGrowth:onClickItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--@brief    点击领取按钮
function CellPrivilegesGrowth:onClickReceive(element)
    WZLog("CellPrivilegesGrowth:onClickReceive")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tag = element:getTag()
	local rewardKey = json.encode({rewardKey=tag})
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.activityId, 1, rewardKey )
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
