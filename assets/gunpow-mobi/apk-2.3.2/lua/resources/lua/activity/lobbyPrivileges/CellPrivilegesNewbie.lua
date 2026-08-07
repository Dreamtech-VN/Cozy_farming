--CellPrivilegesNewbie.lua
--@brief	CellPrivilegesNewbie的UI模块
--@date		2022/03/22
--@author	yrd
--@note		大厅特权-新手礼包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPrivilegesNewbie:onEnter(element)
	self.m_root = element

    GlobalGame:getGameEventDispathcer():Add(LobbyPrivilegesEvent.LobbyPrivilegesEvent_NewbieReceive,self.getActivityDoOk,self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPrivilegesNewbie:onExit(element)
    GlobalGame:getGameEventDispathcer():Remove(LobbyPrivilegesEvent.LobbyPrivilegesEvent_NewbieReceive,self.getActivityDoOk,self)
	self:_unInit()
end

--@brief 	显示登录活动面板
function CellPrivilegesNewbie:showWindow()
	self:updateUI()
    self:updateRewardList()
end

--@brief 	更新界面
function CellPrivilegesNewbie:updateUI()
	local imgActivityText = GetElement(self.m_root,"imgActivityText_CellPrivilegesNewbie",WZUIImage)
	if g_tGameActivityTypes.ACTIVITY_LOBBY_NEWBIE == self.activityType then --新手礼包
		imgActivityText:setFile("ui/gameActivity/lobbyPrivileges/text_hd_pic_dttq_1.png")
	elseif g_tGameActivityTypes.ACTIVITY_LOBBY_DAILY == self.activityType then --每日礼包
		imgActivityText:setFile("ui/gameActivity/lobbyPrivileges/text_hd_pic_dttq_2.png")
	end 
end

--@brief 	更新奖励列表
function CellPrivilegesNewbie:updateRewardList()
    local imgReceived = GetElement(self.m_root,"imgReceived_CellPrivilegesNewbie",WZUIImage)
    local btnReceive = GetElement(self.m_root,"btnReceive_CellPrivilegesNewbie",WZUIButton)
    if self.content.giftState == -1 then
        imgReceived:setVisible(false)
        btnReceive:setVisible(true)
        btnReceive:setTouchEnable(false)
    elseif self.content.giftState == 0 then
        imgReceived:setVisible(false)
        btnReceive:setVisible(true)
        btnReceive:setTouchEnable(true)
    elseif self.content.giftState == 1 then
        imgReceived:setVisible(true)
        btnReceive:setVisible(false)
    end

    -- local rewardItems = json.decode(self.content.rewardItems)
    -- rewardItems = SplitStringWithSeparator(rewardItems[1],"&")
    -- WZLog("CellPrivilegesNewbie:updateRewardList rewardItems",Serialize(rewardItems))

    local flcRewards = GetElement(self.m_root, "flcRewards_CellPrivilegesNewbie", WZUIFreeListContainer)
    flcRewards:removeAll()
    for i = 1, #self.content.rewardItems do
        -- local rewardItem = string.sub(rewardItems[i],2,-2)
        -- local tItem = SplitStringWithSeparator(rewardItem,",")
        local nItemId = self.content.rewardItems[i][1]
        if CacheCenter:getPlayerInfo().sex == 1 then
            nItemId = self.content.rewardItems[i][2]
        end
        local nItemCount = self.content.rewardItems[i][3]
        local element, tNewObj = CellGoodItem:createElement()
        if element and tNewObj then 
            element:setTag(i - 1)
            tNewObj:setCellGoodLocalId(tonumber(nItemId), tonumber(nItemCount), 17)
            tNewObj:setItemClickFun(self, self.onClickItem)

            flcRewards:pushBack(WZUIContainer:luaTo(element))
        end
    end
    flcRewards:getMoveElement():setPositionX(flcRewards:getMaxPosition().x)
end

--@brief    点击奖励回调
function CellPrivilegesNewbie:onClickItem(tItem, nTag, tData)
    WZLog("CellPrivilegesNewbie:onClickItem ")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--@brief    点击领取按钮
function CellPrivilegesNewbie:onClickReceive(element)
    WZLog("CellPrivilegesNewbie:onClickReceive")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tag = element:getTag()
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.activityId, 1, "" )
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
