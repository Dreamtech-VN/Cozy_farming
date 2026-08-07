--WndAmberPlayer.lua
--@brief	WndAmberPlayer的UI模块
--@date		2020/09/09
--@author	nijinlin
--@note		oppo琥珀大玩家专属福利


-------------------------------------公有方法模块Begin--------------------------------------
-- WndAmberPlayer={}
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAmberPlayer:onEnter(element)
	self.m_root = element
	GlobalGame.g_oppo_isAmberPlayer = true
    --注册缓存中心数据监听
    CacheCenter:registerUpatePlayerItemObserver(self)
    self.m_isOpenedOVTips = false
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAmberPlayer:onExit(element)
	self:_unInit()
    if self.m_root then
        self.m_root:disableSchedule()
    end
    --反注册缓存中心数据监听
    CacheCenter:unregisterUpatePlayerItemObserver(self)
end

--@brief    onenter函数已执行
function WndAmberPlayer:onEnterTransitionDidFinish(element)
    WZLog("WndAmberPlayer:onEnterTransitionDidFinish")
    --弹窗动画
    self:_createLoading()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(9)
    local packageName = WGameCmUtil:GetBundleIdentifier()
end

--OV琥珀大玩家-点击弹框提示跳转到oppo游戏中心
function WndAmberPlayer:OnJumpToOPPOGameCenter(nId, nResType)
    WZLog("WndAmberPlayer:OnJumpToOPPOGameCenter")
    if nResType ~= MSGBOXRESTYPE_CONFIRM then return end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm ~= 2 then
        return 
    end
    local curSdkObj = PassportSdkManager:getCurSdkObj()
    if curSdkObj then
        local config = curSdkObj.m_tConfig
        if config then
            local postData = {}
            postData.funType = "openOPPOGameCenter"
            local sJsonArg = json.encode(postData)
            curSdkObj:accountOthers(sJsonArg, nil, nil)
            --self:Others(postData)  
        end
    end  
end

--@brief 	点击item的响应方法
function WndAmberPlayer:updataParentByCellItem(nTag, nType)
    if self.m_nClickNowId == nTag and nType ~= g_tGameActivityTypes.ACTIVITY_FREEREWARD then
        return
    end
    local flActivityItem_WndAmberPlayer = GetElement(self.m_root,"flActivityItem_WndAmberPlayer",WZUIFreeListContainer)
    for i=1,#self.m_tListItem do
        local pos = i-1
        local cellItem = flActivityItem_WndAmberPlayer:getAt(pos)
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
--@brief 	刷新列表数据
function WndAmberPlayer:_updateListItem(  )
	local flActivityItem = GetElement(self.m_root,"flActivityItem_WndAmberPlayer" ,WZUIFreeListContainer)
	if flActivityItem:size() > 0 then 
		flActivityItem:removeAll()
	end 
	local ItemCount = #self.m_tListItem
    self.m_tCellItemObject = {}
    local bIsEatthingsActive = false
    local bSpecifyIdExist = false--self:_isRechargePanelActivityExist()
    local nFirstIndex = self:_getFirstRedDotItem()

	for i=1,ItemCount do
		local element,tNewObj = CellActivityOnLineItem:createElement()
		element = WZUIContainer:luaTo(element)
        tNewObj:setCellType(self.m_tListItem[i].types)
        tNewObj:setItemName(self.m_tListItem[i].title)
        tNewObj:setCellId(self.m_tListItem[i])
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

function WndAmberPlayer:updateRedDot( )
    -- body
    WZLog("************ WndAmberPlayer:updateRedDot **********")
    if self.m_tCellItemObject == nil or self.m_tCellItemObject == {} then return end

    self.m_tCellItemObject = nil
    self.m_tCellItemObject = {}
    local bIsEatthingsActive = false

    local flActivityItem_WndAmberPlayer = GetElement(self.m_root,"flActivityItem_WndAmberPlayer" ,WZUIFreeListContainer)
    for i=1,#self.m_tListItem do
        local element = flActivityItem_WndAmberPlayer:getAt(i)
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

--@brief    发送请求刷新充值进度
function WndAmberPlayer:refreshActivityContext()
    -- body
    self:_ActivityContext(self.m_nSelectedActivityId, self.m_nCurrentSelectTypeId, self.m_cellItemObj)
end

function WndAmberPlayer:setFyberTime()
    --body
    local flActivityItem = GetElement(self.m_root,"flActivityItem_WndAmberPlayer" ,WZUIFreeListContainer)
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
function WndAmberPlayer:_ActivityContext( nId ,nType , cellObj)
	WZLog("WndAmberPlayer:_ActivityContext  nId="..nId, nType)

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
function WndAmberPlayer:_updateRightContent()
    -- body
    local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndAmberPlayer",WZUIContainer)
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
        WZLog("WndAmberPlayer:_updateRightContent 奖励")
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
function WndAmberPlayer:onTouchBegan(element,pt)
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
function WndAmberPlayer:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	WZLog("WndAmberPlayer::_updateActivityContext()")
	local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndAmberPlayer",WZUIContainer)
    if con_ActivityContext == nil then
        return
    end
    if self.m_nSelectedActivityId == activityId then
        con_ActivityContext:removeAllChildrenWithCleanup(true)
    else
        return 
    end
	if g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_RECHARGE == self.m_nCurrentSelectTypeId  then 
        WZLog("WndAmberPlayer:_updateActivityContext|| 累计充值|累计消费|装备强化|连续充值|累计副本|升星|各种十连抽奖励|充值有礼", content)

		local NodeTag = 101
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
	elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_5010 then
		WZLog("WndAmberPlayer:_updateActivityContext  新服累计登录")
        local NodeTag = 102
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
    elseif g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE == self.m_nCurrentSelectTypeId  or g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_SIGNIN == self.m_nCurrentSelectTypeId  then
    	WZLog("WndAmberPlayer:_updateActivityContext  oppo新服累计登录", self.m_nCurrentSelectTypeId, activityId)
        local NodeTag = 102
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellAmberPlayer:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        --self.m_tCommonPanelLuaObj:setMessage(activityId,startTime,endTime, maxCount, count, status, rewardCounts)
        self.m_tCommonPanelLuaObj:setMessage(self.m_nCurrentSelectTypeId, activityId,rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, self.m_cellItemObj, tips, startTime, endTime, target, count)
        if g_tGameActivityTypes.ACTIVITY_OPPO_BIGVIP_WELFARE == self.m_nCurrentSelectTypeId then
            --读取缓存信息，如果发送过ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OppoWelfare() -125协议，代表
            local isCanOpenGameCenter = WndAmberPlayer:refreshUserData(0, nil)
            if GlobalGame.g_oppo_isStartFromGameCenter == true then
                WZLog("WndAmberPlayer:_updateActivityContext", "g_oppo_isStartFromGameCenter = true")
                if isCanOpenGameCenter ~= nil and isCanOpenGameCenter == true then
                    --ProtocolProcessorWndActivityOnLine:send_ACTIVITY_OppoWelfare()
                    self:refreshActivityContext()
                end                
                WndAmberPlayer:refreshUserData(1, "0")
            else
                if isCanOpenGameCenter ~= nil and isCanOpenGameCenter == true and WndActivityIntegrate.m_root and WndActivityIntegrate.m_nFirstCurIndex and WndActivityIntegrate.m_nFirstCurIndex == 6 and self.m_isOpenedOVTips == false then
                    --MsgBoxManager:showConfirmCancelBox(LocalStrings.GAME_ACTIVITY_OPPO_BIGVIP_TIPS, self, self.OnJumpToOPPOGameCenter, MSGBOXLEVEL_HIGH,nil)
                    self.m_isOpenedOVTips = true
                end
            end
        end
    else
		WZLog("jkljgkjkkkjjjlll",self.m_nCurrentSelectTypeId)
    end 
    
	if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndAmberPlayer:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndAmberPlayer:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end




-------------------------------------私有方法模块End----------------------------------------
