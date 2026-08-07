--WndBluePrivilege.lua
--@brief	WndBluePrivilege的UI模块
--@date		2022/03/17
--@author	XTX
--@note		蓝钻特权


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBluePrivilege:onEnter(element)
	self.m_root = element
    --@brief    复用的操作协议（ACTIVITY2_ActivityDoOk = 108）
    ProtocolProcessorFestivalActivity:regProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk", "iiiis")
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetActivityTitleName, self.GetActivityListInfoOK, self)
    GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
    GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
    GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBluePrivilege:onExit(element)
    --@brief    复用的操作协议（ACTIVITY2_ActivityDoOk = 108）
    ProtocolProcessorFestivalActivity:unregProtocolCallbackFunction( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk", "iiiis")
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetActivityTitleName, self.GetActivityListInfoOK, self)
    GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
    GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
    GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)

    g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}

	self:_unInit()
end

--@brief    onenter函数已执行
function WndBluePrivilege:onEnterTransitionDidFinish(element)
    WZLog("WndBluePrivilege:onEnterTransitionDidFinish")
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    --弹窗动画
    self:_createLoading()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(21)
    self:_setRechargeBtnText()
end

--@brief    点击关闭按钮回调
function WndBluePrivilege:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击item的响应方法
function WndBluePrivilege:updataParentByCellItem(nTag, nType)
    if self.m_nClickNowId == nTag then
        return
    end
    local tbActivityItem = GetElement(self.m_root,"tbActivityItem_WndBluePrivilege", WZUITableContainer)
    for i=1, #self.m_tListItem do
        local pos = i-1
        local cellElement = tbActivityItem:getCellElement(i - 1)
        cellElement = WZUIContainer:luaTo(cellElement)
        local cellItem = cellElement:getChildElement("__CellQQActivityItem")
        local cellItem_obj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()

        if i == nTag then
            self.m_nCurrentSelectTypeId = cellItem_obj:getCellType()
            self.m_nSelectedActivityId = cellItem_obj:getCellItem()
            cellItem_obj:isItemHighLighted(true)
            self:_ActivityContext(cellItem_obj:getCellItem(),cellItem_obj:getCellType(),cellItem_obj)
        else
            cellItem_obj:isItemHighLighted(false)
        end
    end
    self.m_nClickNowId = nTag
end

--@brief    点击开通蓝钻或续费蓝钻按钮回调
function WndBluePrivilege:onCLickRecharge(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if isChannelQQHall() and WQQGameHelper then
        WndVip:createLoadingUI()
        WQQGameHelper:on_start_buy_vip("")
        return
    end
    PassportSdkManager:gotoPaymentPage()
end

--@brief    发送请求刷新充值进度
function WndBluePrivilege:refreshActivityContext()
    -- body
    self:_ActivityContext(self.m_nSelectedActivityId, self.m_nCurrentSelectTypeId, self.m_cellItemObj)
end

--@brief    更新福利界面红点
function WndBluePrivilege:showRedDot()
    --body
    if self.m_root == nil or self.m_tCellItemObject == nil then return end

    for i = 1, #self.m_tCellItemObject do
        if self.m_tCellItemObject[i] then
            local bIsHavedRed = false
            if CacheCenter.m_tActivityBluePriRedDotList then
                for idx = 1, #CacheCenter.m_tActivityBluePriRedDotList do
                    WZLog("WndBluePrivilege:showRedDot ", CacheCenter.m_tActivityBluePriRedDotList[idx])
                    if self.m_tCellItemObject[i].key == CacheCenter.m_tActivityBluePriRedDotList[idx] then
                        bIsHavedRed = true
                        break
                    end
                end
            end
            if bIsHavedRed then
                self.m_tCellItemObject[i].Obj:AddRedDot(true)
            else
                self.m_tCellItemObject[i].Obj:removeRedDot()
            end
        end
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新列表数据
function WndBluePrivilege:_updateListItem(  )
	local tbActivityItem = GetElement(self.m_root,"tbActivityItem_WndBluePrivilege" , WZUITableContainer)
	tbActivityItem:cleanTable()

	local ItemCount = #self.m_tListItem
    WZLog("WndBluePrivilege:_updateListItem", ItemCount)
    self.m_tCellItemObject = {}
    local nFirstIndex = self:_getFirstRedDotItem()

	for i = 1, ItemCount do
		local element,tNewObj = CellQQActivityItem:createElement()
        tNewObj:setCellType(self.m_tListItem[i].types)
        tNewObj:setItemName(self.m_tListItem[i].title)
        tNewObj:setCellId(self.m_tListItem[i])
        local cellTab = {}
        cellTab.key = self.m_tListItem[i].types
        cellTab.Obj = tNewObj
        table.insert(self.m_tCellItemObject,cellTab)
        if CacheCenter.m_tActivityBluePriRedDotList then
            for idx=1,#CacheCenter.m_tActivityBluePriRedDotList do
                if self.m_tListItem[i].types == CacheCenter.m_tActivityBluePriRedDotList[idx] then 
                    tNewObj:AddRedDot(true) 
                end 
            end
        end
        if i == 1 then
            if nFirstIndex then 
        	   self.m_nClickNowId = nFirstIndex
            else
               self.m_nClickNowId = 1
            end
        	self.m_nCurrentSelectTypeId = self.m_tListItem[self.m_nClickNowId].types
            self.m_nSelectedActivityId = self.m_tListItem[self.m_nClickNowId].activityId
        end
        if i == self.m_nClickNowId then 
            tNewObj:isItemHighLighted(true)
            self:_ActivityContext(self.m_tListItem[self.m_nClickNowId].activityId,self.m_tListItem[self.m_nClickNowId].types)
        end

        element:setTag(i - 1)
        tbActivityItem:setCellElement(element)
	end

	tbActivityItem:getMoveElement():setPositionY(tbActivityItem:getMinPosition().y)
end

--@brief 	设置活动面板内容
function WndBluePrivilege:_ActivityContext( nId ,nType , cellObj)
	WZLog("WndBluePrivilege:_ActivityContext  nId="..nId, nType)

    self.m_cellItemObj = cellObj
    if nType == 999999 then
        self:_updateActivityContext(self.m_nSelectedActivityId)
    else
        self:_createLoading()
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId, nType)
    end
end

--@brief 	设置面板内容
function WndBluePrivilege:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, finishCondition)
	local conActivityContext = GetElement(self.m_root, "conActivityContext_WndBluePrivilege", WZUIContainer)

    if self.m_nSelectedActivityId == activityId then
        conActivityContext:removeAllChildrenWithCleanup(true)
    else
        return 
    end
  
	if g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_NEWGIFT == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_DAYGIFT == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_BULEPRIVILEGE_GROWGIFT == self.m_nCurrentSelectTypeId or 999999 == self.m_nCurrentSelectTypeId then 
		local NodeTag = self.m_nCurrentSelectTypeId
        local bRet = true
        self.m_tCommonPanelElement = conActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellBluePrivilege:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            conActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        
        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurrentSelectTypeId, content, activityId, startTime, endTime, serverTime)      
    end 
    
	if self.m_tCommonPanelElement ~= nil and self.m_tCommonPanelLuaObj and self.m_tCommonPanelLuaObj.showWindow then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    设置充值按钮字
function WndBluePrivilege:_setRechargeBtnText()
    local imgBtnRecharge = GetElement(self.m_root, "imgBtnRecharge_WndBluePrivilege", WZUIImage)
    local playerInfo = CacheCenter:getPlayerInfo()
    if imgBtnRecharge then 
        if playerInfo.qqHallData and playerInfo.qqHallData.is_blue_vip then
            imgBtnRecharge:setFile("ui/qqHall/common_btn_lz_xf.png")
        else
            imgBtnRecharge:setFile("ui/qqHall/common_btn_lz_kt.png")
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
