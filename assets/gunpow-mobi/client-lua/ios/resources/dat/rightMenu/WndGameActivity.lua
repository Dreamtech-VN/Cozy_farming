--WndGameActivity.lua
--@brief	WndGameActivity的UI模块
--@date		2015/04/23
--@author	weidong_wu
--@note		游戏活动界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameActivity:onEnter(element)
	self.m_root = element
    ChangeChatChannel(Chat_Channel_GameActivity)
	ProtocolProcessorWndActivityOnLine:regAll()
    --注册缓存中心数据监听
    CacheCenter:registerUpatePlayerItemObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameActivity:onExit(element)
    GlobalGame.g_autoGameActivity = false
    g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
    self.m_root:disableSchedule()
    --反注册缓存中心数据监听
    CacheCenter:unregisterUpatePlayerItemObserver(self)
    self:_unInit()
    if WndApartmentAct.m_root == nil and WndSumVacAct.m_root == nil and WndFreeca.m_root == nil then 
	   ProtocolProcessorWndActivityOnLine:unregAll()
    end
end
--@brief    onenter函数已执行
function WndGameActivity:onEnterTransitionDidFinish(element)
    WZLog("WndGameActivity:onEnterTransitionDidFinish")
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    --弹窗动画
    WindowManagerAni:createAppearAction(self.m_root, true, "actionCallback", self)
    self.m_root:enableSchedule("_removeInvalidActivity", 2)
end

--@brief    弹窗动画完成后的回调
function WndGameActivity:actionCallback(element, data)
    WZLog("******** WndGameActivity:actionCallback ******* ", GlobalGame.g_autoGameActivity)
    --获得活动列表
--    if not GlobalGame.g_autoGameActivity then
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo( )
--    end
end

--@brief    弹窗动画完成后的回调
function WndGameActivity:actionCallback_close(element,data)
    WZLog("WndGameActivity:actionCallback_close ", GlobalGame.g_autoSummerActivity)
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    WindowManager:removeWindow(self.m_root , self , true)

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then return end 
    if GlobalGame.g_autoSummerActivity == 3 then
        WZLog("--****showSummerActivity****--")
        if WndSumVacAct.m_root == nil then
            MsgBoxManager:showSummerActivity()
        end
    elseif g_isFirstGangsterInnShow == true then
        local tNewUserPackageList = CacheCenter:getLimitPackageList()
        if tNewUserPackageList == nil or #tNewUserPackageList == 0 then return end 
        WndGangsterInnOwner:showWindow(1)
    end 
end

--@brief    关闭活动界面方法
function WndGameActivity:closeGameActivity()
    -- body
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end

--@brief    关闭窗口
function WndGameActivity:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end

--@brief    点击规则按钮回调
function WndGameActivity:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.LOVELOTTERY_TEXT2) 
end

--@brief 	点击item的响应方法
function WndGameActivity:updataParentByCellItem(nTag, nType)
    if self.m_nClickNowId == nTag and nType ~= g_tGameActivityTypes.ACTIVITY_FREEREWARD then
        return
    end
    local flActivityItem_WndGameActivity = GetElement(self.m_root,"flActivityItem_WndGameActivity",WZUIFreeListContainer)
    for i=1,#self.m_tListItem do
        local pos = i-1
        local cellItem = flActivityItem_WndGameActivity:getAt(pos)
        if cellItem ~= nil then
            cellItem = WZUIContainer:luaTo(cellItem)
        end
        local cellItem_obj = cellItem:getLuaObjectIndex()
        if i==nTag then
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

--@brief    创建并显示活动界面
--@param    activityId: 活动类型，值从m_tGameActivityTypes 取
--@tMsg     从消息列表传过来的数据
function WndGameActivity:showInterface(activityId, tMsg)
	WZLog("WndGameActivity:showInterface", activityId)
    -- body
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1
    if CheckButtonOpen(21) and isTeach ~= true then
        if self.m_root ~= nil then
            self.m_nSpecifyActivityId = nil 
            self:_updateListItem()
        else
            local wndGameActivity = WndGameActivity:createElement()
            if wndGameActivity ~= nil then
                self.m_nSpecifyActivityId = activityId
                WindowManager:addWindow(wndGameActivity,WndGameActivity)
                if tMsg then
                    self.m_tMsgData = tMsg
                end
            end
        end
		return true
    end
	return false
end

--@brief   关闭购买月卡时弹出的加载框
function WndGameActivity:closeLoadingInMonthCard()
    if self.m_root == nil then return end
end  
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndGameActivity:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndGameActivity:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end

--@brief 	刷新列表数据
function WndGameActivity:_updateListItem(  )
	local flActivityItem = GetElement(self.m_root,"flActivityItem_WndGameActivity" ,WZUIFreeListContainer)
	if flActivityItem:size() > 0 then 
		flActivityItem:removeAll()
	end 
	local ItemCount = #self.m_tListItem
    self.m_tCellItemObject = {}
    local bIsEatthingsActive = false
    local bSpecifyIdExist = self:_isRechargePanelActivityExist()
    local nFirstIndex = self:_getFirstRedDotItem()

	for i=1,ItemCount do
		local element,tNewObj = CellActivityOnLineItem:createElement()
		element = WZUIContainer:luaTo(element)
        tNewObj:setCellType(self.m_tListItem[i].types)
        tNewObj:setItemName(self.m_tListItem[i].title)
        tNewObj:setCellId(self.m_tListItem[i].activityId)
        if CacheCenter.m_tActivityItemRedDotList then
            for idx=1,#CacheCenter.m_tActivityItemRedDotList do
                if self.m_tListItem[i].types == CacheCenter.m_tActivityItemRedDotList[idx] then 
                    tNewObj:AddRedDot(true) 
                    local cellTab = {}
                    cellTab.key = self.m_tListItem[i].types
                    cellTab.Obj = tNewObj
                    table.insert(self.m_tCellItemObject,cellTab)

                    if CacheCenter.m_tActivityItemRedDotList[idx] == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then
                        bIsEatthingsActive = true
                    end
                end 
            end
        end
        WZLog("==============================对象列表======"..#self.m_tCellItemObject)
        if self.m_nSpecifyActivityId == nil or not bSpecifyIdExist then
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
                if  not tNewObj:CheckItemIsClick() then
                    tNewObj:addCellItemId(self.m_tListItem[self.m_nClickNowId].activityId)
                    tNewObj:setIsClickEnable(true)
                end
                self:_ActivityContext(self.m_tListItem[self.m_nClickNowId].activityId,self.m_tListItem[self.m_nClickNowId].types)
            end
        else
            if self.m_nSpecifyActivityId == self.m_tListItem[i].types then
                self.m_nClickNowId = i
                self.m_nCurrentSelectTypeId = self.m_tListItem[i].types
                self.m_nSelectedActivityId = self.m_tListItem[i].activityId
            end
        end

        if not (i==1) then
            tNewObj:CheckItemIsClick()
        end
        tNewObj:ItemStateByImage()
        flActivityItem:pushBack(element)
        element:setTag(i)
        element:setContentSize(GlobalMethod:CCSize(212,80))
        element:setRelativeSize(GlobalMethod:CCSize(1,80/440))
	end
    --当在补充活力界面时，刷新按钮
    if CellEatthingsPanel.m_root then
        CellEatthingsPanel:setBtnTouchEnable(bIsEatthingsActive)
    end
	flActivityItem:update()

    if self.m_nClickNowId > 5 then 
        local curPositionY = flActivityItem:getMinPosition().y + (self.m_nClickNowId - 5) * 80
        if curPositionY > flActivityItem:getMaxPosition().y then
            curPositionY = flActivityItem:getMaxPosition().y
        end
        flActivityItem:getMoveElement():setPositionY(curPositionY)
    else
	   flActivityItem:getMoveElement():setPositionY(flActivityItem:getMinPosition().y)
    end
end

function WndGameActivity:updateRedDot( )
    -- body
    WZLog("************ WndGameActivity:updateRedDot **********")
    if self.m_tCellItemObject == nil or self.m_tCellItemObject == {} then return end

    self.m_tCellItemObject = nil
    self.m_tCellItemObject = {}
    local bIsEatthingsActive = false

    local flActivityItem_WndGameActivity = GetElement(self.m_root,"flActivityItem_WndGameActivity" ,WZUIFreeListContainer)
    for i=1,#self.m_tListItem do
        local element = flActivityItem_WndGameActivity:getAt(i)
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        for idx=1,#CacheCenter.m_tActivityItemRedDotList do
            if self.m_tListItem[i].types == CacheCenter.m_tActivityItemRedDotList[idx] then 
                tNewObj:AddRedDot() 
                local cellTab = {}
                cellTab.key = self.m_tListItem[i].types
                cellTab.Obj = tNewObj
                table.insert(self.m_tCellItemObject,cellTab)

                if CacheCenter.m_tActivityItemRedDotList[idx] == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then
                    bIsEatthingsActive = true
                end
            end 
        end
    end

    --当在补充活力界面时，刷新按钮
    if CellEatthingsPanel.m_root then
        CellEatthingsPanel:setBtnTouchEnable(bIsEatthingsActive)
    end
end

--@breif   对列表进行刷选
function WndGameActivity:_sortListItem( ItemCount )
	local m_tNewItem = {}
	local m_tNormalItem = {}
	for i=1,ItemCount do
		local isOld = CellActivityOnLineItem:CheckItemIsClickById(self.m_tListItem[i].activityId)
		if isOld then 
			table.insert(m_tNormalItem,self.m_tListItem[i])
		else
			table.insert(m_tNewItem,self.m_tListItem[i])
		end 
	end
	table.sort( m_tNewItem,function ( a,b )
		return a.startTime>b.startTime
	end )
	table.sort( m_tNormalItem,function ( a,b )
		return a.startTime>b.startTime
	end )
	self.m_tListItem = {} 
	for i=1,#m_tNewItem do
		table.insert(self.m_tListItem,m_tNewItem[i])
	end
	for i=1,#m_tNormalItem do
		table.insert(self.m_tListItem,m_tNormalItem[i])
	end
end

--@brief    发送请求刷新充值进度
function WndGameActivity:refreshActivityContext()
    -- body
    self:_ActivityContext(self.m_nSelectedActivityId, self.m_nCurrentSelectTypeId, self.m_cellItemObj)
end

function WndGameActivity:setFyberTime()
    --body
    local flActivityItem = GetElement(self.m_root,"flActivityItem_WndGameActivity" ,WZUIFreeListContainer)
    for i = 0, flActivityItem:size() - 1 do
        local element = flActivityItem:getAt(i)
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        if tNewObj then
            local nType = tNewObj:getCellType()
            if nType == g_tGameActivityTypes.ACTIVITY_FREEREWARD then
                tNewObj:setFyberTime()
                break 
            end
        end
    end
end

--@brief 	设置活动面板内容
function WndGameActivity:_ActivityContext( nId ,nType , cellObj)
	WZLog("WndGameActivity:_ActivityContext  nId="..nId, nType)
    self.m_cellItemObj = cellObj
    if nType == g_tGameActivityTypes.ACTIVITY_INN or nType == g_tGameActivityTypes.ACTIVITY_GUANGGAO or nType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_DIAMONDROUND or nType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_CARPACKAGE or nType == g_tGameActivityTypes.ACTIVITY_FREEREWARD then
		WZLog("路径1")
        self:_updateRightContent()
    elseif nType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT then --开服活动-折扣限购
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetDailyDiscountInfo()
    elseif nType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK then 
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(5)
    elseif nType == g_tGameActivityTypes.ACTIVITY_MANY_COLLECT then 
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetGrowdfunding( )
    elseif nType == g_tGameActivityTypes.ACTIVITY_SMALL_RECHARGE then
        self:_createLoading()
        ProtocolProcessorRecharge:send_PURCHASE_GetSummerGiftIdList(ProjConfig.CHANNEL_ID, 105)
    elseif nType == g_tGameActivityTypes.ACIVIITY_RECHARGERANK then   --本服充值达人
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(1)
    elseif nType == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK then   --跨服充值达人
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(2)
    elseif nType == g_tGameActivityTypes.ACIVIITY_CONSUMERANK then   --本服消费达人
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(3)
    elseif nType == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK then   --跨服消费达人
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(4)
    elseif nType == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then   --鲜花榜
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(6)
    else
		WZLog("路径2")
        self:_createLoading()
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId,nType)
    end
end

--@brief    设置右边容器内容
function WndGameActivity:_updateRightContent()
    -- body
    local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
    if con_ActivityContext == nil then
        return
    end
    if self.m_nCurrentSelectTypeId ~= g_tGameActivityTypes.ACTIVITY_FREEREWARD then
        con_ActivityContext:removeAllChildrenWithCleanup(true)
    end
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_GUANGGAO then
        local NodeTag = 117
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = WndAdvertising1:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
	elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_INN then
        local NodeTag = 118
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = WndGangsterInnActivity:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FREEREWARD then
        WZLog("WndGameActivity:_updateRightContent 奖励")
        DoFyberReward(1)
        return 
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_DIAMONDROUND then 
        local NodeTag = 129
        
        self.m_tCommonPanelElement = WndTurnTableLottery:createElement()
        self.m_tCommonPanelLuaObj = WndTurnTableLottery
        con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        return 
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_CARPACKAGE then
        local NodeTag = 134
        
        self.m_tCommonPanelElement = WndCardDraw:createElement()
        self.m_tCommonPanelLuaObj = WndCardDraw
        con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        return 
    end

    if self.m_tCommonPanelLuaObj then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    事件
function WndGameActivity:onTouchBegan(element,pt)
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt,dir)
    WZLog("开始按下回调函数:",bPoint)
    if bPoint == true then
        WZLog("回调函数1:",type(bPoint),bPoint)
    else 
        WZLog("回调函数12:",type(bPoint),bPoint)
        WndItemInfo:onCloseClick()
    end

    if WndTips.m_root then
        WndTips:onCloseClick()
    end
end

--@brief 	设置面板内容
function WndGameActivity:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	WZLog("WndGameActivity::_updateActivityContext()")
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then
        GetElement(self.m_root, "img9GrayBg_WndGameActivity", WZUI9Image):setVisible(false)
    else
        GetElement(self.m_root, "img9GrayBg_WndGameActivity", WZUI9Image):setVisible(true)
    end
	local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
    if con_ActivityContext == nil then
        return
    end

    if self.m_nSelectedActivityId == activityId then
        con_ActivityContext:removeAllChildrenWithCleanup(true)
    else
        return 
    end
    WZLog("m_nCurrentSelectTypeId="..self.m_nCurrentSelectTypeId)
	if g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE2 == self.m_nCurrentSelectTypeId then 
		WZLog("WndGameActivity:_updateActivityContext|| 首次充值", Serialize(status))
		local NodeTag = 101
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellRechargePanelActivity:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        WZLog("rewardId="..rewardId[1])
        self.m_tCommonPanelLuaObj:setMessage(content,status,rewardItems,activityId,rewardId, rewardCounts, target, rewardItemsParamCount)
	elseif g_tGameActivityTypes.ACTIVITY_TOTALFIRSTRECHARGE == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_STRENGTHEN == self.m_nCurrentSelectTypeId or 
        g_tGameActivityTypes.ACTIVITY_CONTINUERECHARGE == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_ACCUMULATIVE == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_CUMULATIVECOST_TICKET == self.m_nCurrentSelectTypeId or 
        g_tGameActivityTypes.ACTIVITY_NEWSERVER_TOTALRECHARGE == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_NEWSERVER_SINGLECOPY == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_COST_ONLYTICKET == self.m_nCurrentSelectTypeId or 
        g_tGameActivityTypes.ACTIVITY_COST_ONLYDIAMOND == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_EQUIP_STAR == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_TEN_LOTTERY == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_EIGHTTIMES_DIAMOND == self.m_nCurrentSelectTypeId or 
        g_tGameActivityTypes.ACTIVITY_FIVETIMES_DIAMOND == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_RECHARGELEVEL == self.m_nCurrentSelectTypeId or 
        g_tGameActivityTypes.ACTIVITY_ATHLETIC_VICTORY == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_RANKING_VICTORY == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_PET_UPGRADE == self.m_nCurrentSelectTypeId or 
        g_tGameActivityTypes.ACTIVITY_MOUNT_UPGRADE == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_EQUIPMENT_CALL == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_PET_QUAIL == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_CONTINUOUS_LOGIN == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_CHANNEL_RECHARGE == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext|| 累计充值|累计消费|装备强化|连续充值|累计副本|升星|各种十连抽奖励", content)
        for i=1,#tips do
            WZLog("tip "..i.."|"..tips[i])
        end

        for i=1,#target do
            WZLog("=======================>"..target[i])
        end 

		local NodeTag = 102
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTotalRechargetPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end

        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurrentSelectTypeId,tips,startTime ,endTime ,serverTime,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,activityId,target, content)
	elseif g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN == self.m_nCurrentSelectTypeId then 
		WZLog("WndGameActivity:_updateActivityContext|| 累计登录")
        local NodeTag = 103
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTotalLoginPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, self.m_cellItemObj, tips, startTime, endTime)
	elseif g_tGameActivityTypes.ACTIVITY_TIMEDLOGIN == self.m_nCurrentSelectTypeId then 
		WZLog("WndGameActivity:_updateActivityContext|| 限时登录")
        local NodeTag = 104
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellLoginActivityPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,tips,startTime,endTime,serverTime,rewardItems,rewardId,rewardItemsParamCount,count ,status,rewardCounts,self.m_cellItemObj)
	elseif g_tGameActivityTypes.ACTIVITY_GRADE == self.m_nCurrentSelectTypeId then 
		WZLog("WndGameActivity:_updateActivityContext|| 等级冲刺")
        local NodeTag = 105
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellLevelSprintPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurrentSelectTypeId,tips,startTime,endTime,serverTime,rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,activityId,target)
	elseif g_tGameActivityTypes.ACTIVITY_IMPROVEFIGHT == self.m_nCurrentSelectTypeId then 
		WZLog("WndGameActivity:_updateActivityContext|| 战力冲刺")
        local NodeTag = 106
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellFightingPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,tips,startTime,endTime,serverTime,rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts,target)
	elseif g_tGameActivityTypes.ACTIVITY_VIPGIFBAG == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext|| VIP等级礼包") 
        local NodeTag = 107
        local bRet = true 
        for i=1,#tips do
            WZLog("VIP等级礼包 "..i.."|"..tips[i] .. "|" .. status[i])
        end
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellActivityVipPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage( activityId,count,maxCount ,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, tips)
    elseif g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_DISCOUNTGIFBAG_TICKET == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext|| 优惠礼包") 
        local NodeTag = 108
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellActivityGifPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end 
        self.m_tCommonPanelLuaObj:setMessage(activityId, startTime, endTime, rewardItems, rewardItemsParamCount, count, status[1], maxCount, rewardId, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TARGETREWARD_1 or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_2 ==self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_3 == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_TARGETREWARD_4 == self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_NEWSERVER_ATHLETICSUP == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext|| 副本关卡|竞技目标奖励|排位积分|弹王积分|开服活动-限时竞技升阶", content)

        for i=1,#target do
            WZLog("=======================>"..target[i])
        end
        
        local NodeTag = 109
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellCostActivityPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end 
        
        self.m_tCommonPanelLuaObj:setMessage( activityId, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count ,target, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then 
        WZLog("WndGameActivity:_updateActivityContext|| 补充活力") 
        local NodeTag = 110
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)

        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellEatthingsPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end 

        self.m_tCommonPanelLuaObj:setMessage(activityId,self.m_nCurrentSelectTypeId,status,serverTime,rewardItems,rewardItemsParamCount)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_DAILYFIRSTRECHARGE then 
        WZLog("WndGameActivity:_updateActivityContext|| 每日首充")
        local NodeTag = 111
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellDailyFirstRecharge:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        WZLog("rewardId="..rewardId[1])
        self.m_tCommonPanelLuaObj:setMessage(activityId, status[1], startTime, endTime, serverTime, rewardItems,rewardItemsParamCount,rewardId[1], target[1])
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TIMEDFIRSTRECHARGE or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_THREETIMES_DIAMOND then 
        WZLog("WndGameActivity:_updateActivityContext|| 限时充值|三倍钻石") 
        local NodeTag = 112
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTimeFirstRecharge:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        WZLog("rewardId="..rewardId[1])
        self.m_tCommonPanelLuaObj:setMessage(activityId, status[1], serverTime, rewardItems,rewardItemsParamCount, startTime, endTime, rewardId[1], content, tips, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_PRERECHARGE or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_ATHLETICSHAPPINESS or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_CHEATSWELFARE or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_MULDOUBLE or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_ELITEDOUBLE or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FINDDOG or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_LINECONNECT or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_RANKPVP_REWARD or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FLOP_CARD then 
        WZLog("WndGameActivity:_updateActivityContext|| 封测充值 || 竞技乐翻天 || 秘籍福利 || 精英双倍 || 组队双倍 || 寻找狗二弹 || 红线情缘 || 组队翻牌折扣") 
        local NodeTag = 113
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellPreRechargePanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end

        self.m_tCommonPanelLuaObj:setMessage(activityId, content, tips, self.m_nCurrentSelectTypeId, count, startTime, endTime)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_LEVELLIST or g_tGameActivityTypes.ACTIVITY_ATHLETICSLIST ==self.m_nCurrentSelectTypeId or g_tGameActivityTypes.ACTIVITY_FIGHTINGLIST == self.m_nCurrentSelectTypeId or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_COUPLEFIGHTING or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_COMMUNITYFIGHTING then 
        WZLog("WndGameActivity:_updateActivityContext|| 排行")

        local NodeTag = 114
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellListPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end 

        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurrentSelectTypeId, tips, startTime, endTime, serverTime, rewardId, rewardItems, rewardItemsParamCount, rewardCounts, activityId, content)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_LOTTERY then
        --target[1]:消耗的物品ID,target[2]:消耗的物品数量
        WZLog("WndGameActivity:_updateActivityContext|| 幸运抽奖", startTime,endTime,target[2],target[1])
        local NodeTag = 115
        local bRet = true 
        --创建自由列表容器
        local flistAct = WZUIFreeListContainer:create()
        flistAct:setEnableMoveHorizontal(false)
        flistAct:setName("flistAct_WndGameActivity")
        con_ActivityContext:addChild(flistAct)
        --广告展示图栏
        local adElement = self:_createAD("ui/gameActivity/activity_pic_dzpcj.png", LocalStrings.LOVELOTTERY_TEXT1, startTime, endTime)
        --进度
        local loveProBox = CellLoveLotteryBox:createElement()
        loveProBox:setAnchorPoint(GlobalMethod:ccp(0,0))
        loveProBox:setRelativePosition(GlobalMethod:ccp(0,-0.06))
        adElement:addChild(loveProBox)

        adElement = WZUIContainer:luaTo(adElement)
        adElement:setRelativeSize(GlobalMethod:CCSize(1,115/453))
        flistAct:pushBack(adElement)
        --转盘
        self.m_tCommonPanelElement = WndLoveLottery:createElement()
        self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        WndLoveLottery:setLotteryInfo(startTime,endTime,target[2], target[1])
        self.m_tCommonPanelElement:setRelativeSize(GlobalMethod:CCSize(1,1))
        flistAct:pushBack(self.m_tCommonPanelElement)

        flistAct:getMoveElement():setPositionY(flistAct:getMinPosition().y)
        return
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_MARRYDISCOUNT then
        WZLog("WndGameActivity:_updateActivityContext|| 结婚打折", startTime,endTime)
        local NodeTag = 116
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellMarryDiscount:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(startTime,endTime)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_NEWWEAPON or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_NEWWEAPON_TICKET then
        WZLog("WndGameActivity:_updateActivityContext|| 新武器打折", content)
        local NodeTag = 117
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellBuyLimitePanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardItems,rewardItemsParamCount,count,status[1],maxCount,rewardId, content, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_CUTEPET or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACIVIITY_WEEKCARD_DISCOUNT or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT then
        WZLog("WndGameActivity:_updateActivityContext|| 萌宠上线|口令红包|月卡打折|周卡买一送一")
        local NodeTag = 118
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellCutePetPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        
        if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK then
            self.m_tCommonPanelLuaObj:setMessage2(startTime,endTime,activityId, rewardCounts, tips, serverTime, count, maxCount, self.m_nCurrentSelectTypeId)
        else
            self.m_tCommonPanelLuaObj:setMessage(startTime,endTime,activityId, content, tips, self.m_nCurrentSelectTypeId)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_GOODSDISCOUNT_TICKET then
        WZLog("WndGameActivity:_updateActivityContext|| 物品限时折扣")
        local NodeTag = 119
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTimeDiscountPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardId, rewardItems, target, rewardCounts, rewardItemsParamCount, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_EXCHANGE or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACIVIITY_OLD_EXCHANGE then
        WZLog("WndGameActivity:_updateActivityContext|| 物品兑换")
        local NodeTag = 120
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellExchangePanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardItems, rewardCounts, rewardItemsParamCount, target, content, rewardId, tips, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_ZBSHILIAN then
        WZLog("WndGameActivity:_updateActivityContext|| 装备十连抽")
        local NodeTag = 121
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTenLottery:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId, startTime, endTime, content)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then
        WZLog("WndGameActivity:_updateRightContent  放烟花")
        local NodeTag = 122
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellFireworks:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardCounts, rewardId, count)
		return
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_SCHEDULE_RED_PACEKET then
        WZLog("WndGameActivity:_updateRightContent  红包雨")
        local NodeTag = 123
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellActivityRedEnvelope:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, maxCount, count)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_PLAYERBACK then
        WZLog("WndGameActivity:_updateRightContent  老玩家回归奖励")
        local NodeTag = 124
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tCommonPanelElement = WndPlayerBack:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        WndPlayerBack:setMessage(activityId,startTime,endTime, status[1], rewardItems,rewardItemsParamCount,target[1])
	    return
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_NOVICE_RED_PACKET then
        WZLog("WndGameActivity:_updateRightContent  新手红包")
        local NodeTag = 125
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellActivitySevenRedEnvelope:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, maxCount, count, status, rewardCounts)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_DISCOUNT_NEW then
        WZLog("WndGameActivity:_updateActivityContext|| 物品限时折扣配消耗类型")
        local NodeTag = 126
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = CellDiscountLimitPanel
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement = CellDiscountLimitPanel:createElement()
            self.m_tCommonPanelLuaObj = CellDiscountLimitPanel
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardId, rewardItems, target, rewardCounts, rewardItemsParamCount, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMECHALLENGE then
        WZLog("WndGameActivity:_updateActivityContext|| 开服活动-限时挑战", activityId)
        local NodeTag = 128
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = CellDiscountLimitPanel
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellTimeChallengePanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardId, status, rewardItems, rewardItemsParamCount,target, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BREAKEGGS then
        WZLog("WndGameActivity:_updateActivityContext|| 开服活动-砸金蛋", activityId)
        local NodeTag = 130
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = CellDiscountLimitPanel
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellBreakEggsPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardId, status, maxCount, count, content, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_NEWSERVER_FIGHTINGRANK then
        WZLog("WndGameActivity:_updateActivityContext|| 开服活动-战力月榜", activityId)
        local NodeTag = 131
        local bRet = true 
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = CellDiscountLimitPanel
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellFightingRankPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end

        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardId, status, rewardItems, rewardItemsParamCount,target, self.m_nCurrentSelectTypeId)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_5009 then
        WZLog("WndGameActivity:_updateRightContent  新服在线奖励")
        local NodeTag = 132
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellNewOnLineReward:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
	--(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
        self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, rewardId, rewardItems, rewardItemsParamCount, rewardCounts, count, target, status)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_5010 then
        WZLog("WndGameActivity:_updateRightContent  新服累计登录")
        local NodeTag = 133
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellNewTotalLogin:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        --self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, maxCount, count, status, rewardCounts)
        self.m_tCommonPanelLuaObj:setMessage(activityId,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, self.m_cellItemObj, tips, startTime, endTime, target, count)
    elseif g_tGameActivityTypes.ACTIVITY_TODAYRECHARGE == self.m_nCurrentSelectTypeId then
        WZLog("WndGameActivity:_updateActivityContext||每日充值奖励") 
        
        local NodeTag = 134
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTodayRechargePanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end

        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurrentSelectTypeId,tips,startTime ,endTime ,serverTime,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,activityId,target)
    else
		WZLog("jkljgkjkkkjjjlll",self.m_nCurrentSelectTypeId)
    end 
    
	if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    开服活动的详细数据
function WndGameActivity:_updateActivityContext_newServer(configId, originPrice, curPrice, needVip, reward, timesLimit, times, countdown)
    WZLog("WndGameActivity::_updateActivityContext_newServer")
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_EASTTHINGS then
        GetElement(self.m_root, "img9GrayBg_WndGameActivity", WZUI9Image):setVisible(false)
    else
        GetElement(self.m_root, "img9GrayBg_WndGameActivity", WZUI9Image):setVisible(true)
    end
    local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
    if con_ActivityContext == nil then
        return
    end

    con_ActivityContext:removeAllChildrenWithCleanup(true)
    WZLog("m_nCurrentSelectTypeId= tttt"..self.m_nCurrentSelectTypeId)
    if g_tGameActivityTypes.ACTIVITY_NEWSERVER_TIMEDISCOUNT == self.m_nCurrentSelectTypeId then 
        WZLog("WndGameActivity:_updateActivityContext_newServer|| 开服活动-折扣限购")
        local NodeTag = 127
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellTimeDiscountPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement,0,NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage_newServer(configId, originPrice, curPrice, needVip, reward, timesLimit, times, countdown, self.m_nCurrentSelectTypeId)
    end

    if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    凌晨时，扫描一遍活动列表，把到期的活动移除掉
function WndGameActivity:_removeInvalidActivity()
    -- body
    local serverTime = SystemTime:getServerTime()

    if self.m_tListItem == nil or self.m_tListItem == {} then 
        self.m_root:disableSchedule()
        return 
    end
    local bIsFlashItemList = false
    local endTime = 0
    local tActivityList = CopyTable(self.m_tListItem)
    if tActivityList == nil then return end
    for i = 1, #tActivityList do
        if #self.m_tListItem >= i and self.m_tListItem[i] and self.m_tListItem[i].endTime ~= nil then
            endTime = self.m_tListItem[i].endTime
            if self.m_tListItem[i].types == g_tGameActivityTypes.ACIVIITY_RECHARGERANK or self.m_tListItem[i].types == g_tGameActivityTypes.ACIVIITY_CROSS_RECHARGERANK or
                self.m_tListItem[i].types == g_tGameActivityTypes.ACIVIITY_CONSUMERANK or self.m_tListItem[i].types == g_tGameActivityTypes.ACIVIITY_CROSS_CONSUMERANK or
                self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
                endTime = endTime + 86400
            end
            if endTime <= serverTime then
                table.remove(self.m_tListItem, i)
                bIsFlashItemList = true
            end
        end
    end
    if bIsFlashItemList then
        WZLog("_removeInvalidActivity 222")
        self:_updateListItem()
    end
end

--@brief    根据活动类型，移除相应的活动
function WndGameActivity:_removeActivityByType(nActivityType)
    -- body
    local bIsFlashItemList = false
    local tActivityList = CopyTable(self.m_tListItem)
    if tActivityList == nil then return end
    for i = 1, #tActivityList do
        if tActivityList[i].types == nActivityType then
            table.remove(self.m_tListItem, i)
            bIsFlashItemList = true
        end
    end

    if bIsFlashItemList then
        self:_updateListItem()
    end
end

--@brief    判断是否存在首充活动
function WndGameActivity:_isRechargePanelActivityExist()
    -- body
    local ItemCount = #self.m_tListItem
    local bIsExist = false
    if self.m_nSpecifyActivityId == nil then return bIsExist end

    for i=1,ItemCount do
        if self.m_nSpecifyActivityId == self.m_tListItem[i].types then
            bIsExist = true
            break 
        end
    end

    return bIsExist
end

--@brief    红包奖励领取成功后的处理
function WndGameActivity:getRedPackOKClose()
    -- body
    ShowRedEnvelopesRain()
end

--@brief    创建广告展示图
function WndGameActivity:_createAD(adImgPath, textAtt, startTime, endTime)
    -- body
    local conForAD = WZUIContainer:create()
    conForAD:setUseAbsSize(true)
    conForAD:setAbsContentSize(GlobalMethod:CCSize(502, 115))

    --广告图
    local imgAD = WZUIImage:create()
    imgAD:setUseOriginSize(true)
    imgAD:setFile(adImgPath)
    conForAD:addChild(imgAD)
    --时间底图
    local conForTime = WZUIContainer:create()
    conForTime:setUseAbsSize(true)
    conForTime:setAbsContentSize(GlobalMethod:CCSize(502, 42))
    conForTime:setAnchorPoint(GlobalMethod:ccp(0.5,1))
    conForTime:setRelativePosition(GlobalMethod:ccp(0.5,1))
    conForAD:addChild(conForTime)

    imgAD = WZUI9Image:create()
    imgAD:setFile("ui/common/common_scale9_heidi7.png")
    imgAD:setOpacity(150)
    conForTime:addChild(imgAD)
    --活动时间
    local txtTimeWord = WZUILabelTTF:create()
    txtTimeWord:setFontSize(22)
    txtTimeWord:setColor(GlobalMethod:ccc3(255,227,116))
    txtTimeWord:setEnableStroke(true)
    txtTimeWord:setStrokeSize(4)
    txtTimeWord:setStrokeColor(GlobalMethod:ccc3(128,54,13))
    txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    txtTimeWord:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    txtTimeWord:setRelativePosition(GlobalMethod:ccp(0.05,0.5))
    conForTime:addChild(txtTimeWord)

    local txtTime = WZUILabelTTF:create()
    txtTime:setFontSize(22)
    txtTime:setColor(GlobalMethod:ccc3(255,89,74))
    txtTime:setEnableStroke(true)
    txtTime:setStrokeSize(4)
    txtTime:setStrokeColor(GlobalMethod:ccc3(158,0,0))
    txtTime:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    txtTime:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
    if ProjConfig.LANGUAGE == "vn" then
        txtTime:setRelativePosition(GlobalMethod:ccp(0.42,0.5))
    end
    conForTime:addChild(txtTime)
    local DayStartTab = os.date("*t", startTime)
    local DayEndTab = os.date("*t", endTime)
    local format_txt_value = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    txtTime:setText(format_txt_value)
    --规则按钮
    local btnRule = WZUIButton:create()
    btnRule:setUseAbsSize(true)
    btnRule:setRelativePosition(GlobalMethod:ccp(0.96, 0.83))

    local imgNor = WZUIImage:create()
    imgNor:setUseOriginSize(true)
    imgNor:setFile("ui/common/common_icon_gth.png")
    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/common/common_icon_gth.png")
    imgSel:setScale(1.1)
    btnRule:setNormalElement(imgNor)
    btnRule:setSelectElement(imgSel)
    btnRule:setLuaDoneFunctionName("onClickRule")
    conForAD:addChild(btnRule)
    
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
        if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_LOTTERY then
            btnRule:setVisible(false)
        end
    end

    --提示语
    -- local txtAtt = WZUILabelTTF:create()
    -- txtAtt:setFontSize(22)
    -- txtAtt:setColor(GlobalMethod:ccc3(255,236,193))
    -- txtAtt:setText(textAtt)
    -- txtAtt:setRelativePosition(GlobalMethod:ccp(0.5, 0.1))
    -- conForAD:addChild(txtAtt)

    return conForAD
end
-------------------------------------私有方法模块End----------------------------------------
