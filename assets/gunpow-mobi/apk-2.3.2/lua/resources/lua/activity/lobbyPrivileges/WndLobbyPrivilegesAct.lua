--WndLobbyPrivilegesAct.lua
--@brief	WndLobbyPrivilegesAct的UI模块
--@date		2022/03/21
--@author	yrd
--@note		大厅特权活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLobbyPrivilegesAct:onEnter(element)
	self.m_root = element
	
	ProtocolProcessorWndActivityOnLine:regAll()
    ProtocolProcessorFestivalActivity:regAll6()
    GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_createLoading()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(22)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLobbyPrivilegesAct:onExit(element)
    GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_unInit()
end

--@brief	点击关闭按钮
function WndLobbyPrivilegesAct:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    界面加载完成回调
function WndLobbyPrivilegesAct:onEnterTransitionDidFinish(element)
end

--@brief    网络勾搭动画
function WndLobbyPrivilegesAct:_createLoading()
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief    关闭网络勾搭动画
function WndLobbyPrivilegesAct:_closeLoading()
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief    更新界面信息
function WndLobbyPrivilegesAct:updateUI()
    -- body
    --左边标题列表
    self:updateTitleList()
    --右边内容展示
	self:setTitleStates()
end

--@brief	更新标题列表
function WndLobbyPrivilegesAct:updateTitleList()
	local flcTitleItems = GetElement(self.m_root, "flcTitleItems_WndLobbyPrivilegesAct", WZUIFreeListContainer)
	flcTitleItems:removeAll()
	self.m_tTitleListObj = {}

    for i = 1, #self.m_tTitleListData do
		local element, tLuaObj = CellLobbyPrivilegesActTitle:createElement()
		element:setTag(i-1)
		flcTitleItems:pushBack(WZUIContainer:luaTo(element))
		tLuaObj:setData(self.m_tTitleListData[i])
		tLuaObj:setClickCallBack(self.onClickTitle,self)
        if CacheCenter.m_tActivityHallPriRedDotList then
            for idx=1,#CacheCenter.m_tActivityHallPriRedDotList do
                if self.m_tTitleListData[i].types == CacheCenter.m_tActivityHallPriRedDotList[idx] then 
                    tLuaObj:AddRedDot(true) 
                end 
            end
        end
		self.m_tTitleListObj[i] = tLuaObj
    end

    flcTitleItems:getMoveElement():setPositionY(flcTitleItems:getMinPosition().y)

end

--@brief	点击标题按钮回调
--@param	tLuaObj:CellLobbyPrivilegesActTitle对象
function WndLobbyPrivilegesAct:onClickTitle(tLuaObj)
	for i=1,#self.m_tTitleListObj do
		self.m_tTitleListObj[i]:setSelectedStates(false)
	end
	tLuaObj:setSelectedStates(true)
	self.m_nCurActivityType = tLuaObj:getData().types
	self:setTitleStates()
end

--@brief	点击标题按钮回调
function WndLobbyPrivilegesAct:setTitleStates()
	if self.m_nCurActivityType == nil then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITYCLOSE)
		return
	end

    for i = 1, #self.m_tTitleListObj do
    	local tItemData = self.m_tTitleListObj[i]:getData()
        self.m_tTitleListObj[i]:setSelectedStates(false)
        if tItemData.types == self.m_nCurActivityType then
            self.m_tTitleListObj[i]:setSelectedStates(true)

	    	self:_createLoading()
	        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(tItemData.activityId, tItemData.types)
        end
    end

end


--@brief    设置面板内容
function WndLobbyPrivilegesAct:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, finishCondition)
    WZLog("WndLobbyPrivilegesAct::_updateActivityContext")
    if self.m_nCurActivityType == nil then return end 

    local conContext = GetElement(self.m_root,"conContext_WndLobbyPrivilegesAct",WZUIContainer)
    conContext:removeAllChildrenWithCleanup(true)
    conContext:setVisible(true)

    WZLog("m_nCurrentSelectTypeId="..self.m_nCurActivityType)
    self.m_tCommonPanelElement = nil
    if g_tGameActivityTypes.ACTIVITY_LOBBY_NEWBIE == self.m_nCurActivityType or g_tGameActivityTypes.ACTIVITY_LOBBY_DAILY == self.m_nCurActivityType then
        WZLog("WndLobbyPrivilegesAct:_updateActivityContext|| 新手礼包 每日礼包")
        self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellPrivilegesNewbie:createElement()
        self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        conContext:addChild(self.m_tCommonPanelElement)
        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurActivityType, activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, finishCondition)

    elseif g_tGameActivityTypes.ACTIVITY_LOBBY_GROWTH == self.m_nCurActivityType then
        WZLog("WndLobbyPrivilegesAct:_updateActivityContext|| 成长礼包")
        self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellPrivilegesGrowth:createElement()
        self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        conContext:addChild(self.m_tCommonPanelElement)
        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurActivityType, activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, finishCondition)

    -- elseif g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE == self.m_nCurActivityType or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST == self.m_nCurActivityType or g_tGameActivityTypes.ACTIVITY_STRENGTHEN == self.m_nCurActivityType or g_tGameActivityTypes.ACTIVITY_BACK_RECHARGE == self.m_nCurActivityType then 
    --     WZLog("WndLobbyPrivilegesAct:_updateActivityContext|| 累计充值|累计消费|装备强化|回归充值")
    --     local NodeTag = 102
    --     local bRet = true
    --     self.m_tCommonPanelElement = conContext:getChildByTag(NodeTag)
    --     if self.m_tCommonPanelElement ~= nil then
    --         self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
    --         self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
    --         bRet = false
    --     else
    --         bRet = true
    --         self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTotalRechargetPanel:createElement()
    --         self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
    --     end
    --     if bRet then
    --         conContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
    --     end

    --     self.m_tCommonPanelLuaObj:setMessage(self.m_nCurActivityType,tips,startTime ,endTime ,serverTime,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,activityId,target)
    end
    
    if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新福利界面红点
function WndLobbyPrivilegesAct:showRedDot()
    --body
    if self.m_root == nil or self.m_tTitleListObj == nil then return end

    for i = 1, #self.m_tTitleListObj do
        if self.m_tTitleListObj[i] then
            local bIsHavedRed = false
            local titleData = self.m_tTitleListObj[i]:getData()
            if CacheCenter.m_tActivityHallPriRedDotList then
                for idx = 1, #CacheCenter.m_tActivityHallPriRedDotList do
                    WZLog("WndLobbyPrivilegesAct:showRedDot ", CacheCenter.m_tActivityHallPriRedDotList[idx])
                    if titleData.types == CacheCenter.m_tActivityHallPriRedDotList[idx] then
                        bIsHavedRed = true
                        break
                    end
                end
            end
            if bIsHavedRed then
                self.m_tTitleListObj[i]:AddRedDot(true)
            else
                self.m_tTitleListObj[i]:removeRedDot()
            end
        end
    end
end




-------------------------------------私有方法模块End----------------------------------------


