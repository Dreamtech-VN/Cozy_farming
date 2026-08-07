--WndFreeca.lua
--@brief	WndFreeca的UI模块
--@date		2017/02/24
--@author	maopeiting
--@note		福利卡


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFreeca:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFreeca:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end

--@brief    界面加载完成回调
function WndFreeca:onEnterTransitionDidFinish(element)
    -- body
    self:_initItem()
    self:sortCard()
end

--@brief   创建加载框
function WndFreeca:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndFreeca:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end

--@brief    关闭窗口
function WndFreeca:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    -- if self.m_tMsgData ~= nil then 
    --     self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    -- end
    
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end

--@brief    点击上一个按钮回调
function WndFreeca:onClickPre(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if self.m_nClickNowId == 1 then 
        self.m_nClickNowId = #self.m_tListItem
    else
        self.m_nClickNowId = self.m_nClickNowId - 1
    end
    self:updataParentByCellItem(self.m_nClickNowId)
end

--@brief    点击下一个按钮回调
function WndFreeca:onClickNext(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if self.m_nClickNowId == #self.m_tListItem then 
        self.m_nClickNowId = 1
    else
        self.m_nClickNowId = self.m_nClickNowId + 1
    end
    self:updataParentByCellItem(self.m_nClickNowId)
end

--@brief    弹窗动画完成后的回调
function WndFreeca:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief 	刷新列表数据
function WndFreeca:_updateListItem(  )
	local ItemCount = #self.m_tListItem
	for i=1,ItemCount do
        for j=1,#CacheCenter.m_tFreecaRedDotList do
            if self.m_tListItem[i].types == CacheCenter.m_tFreecaRedDotList[j] then
            end
        end

        if self.m_nSpecifyActivityId == nil then
            if i == 1 then
            	self.m_nClickNowId = 1
            	self.m_nCurrentSelectTypeId = self.m_tListItem[i].types
                self.m_nSelectedActivityId = self.m_tListItem[i].activityId

                self:_ActivityContext(self.m_tListItem[i].activityId,self.m_tListItem[i].types)
            end
        else
            if self.m_nSpecifyActivityId == self.m_tListItem[i].types then
                self.m_nClickNowId = i
                self.m_nCurrentSelectTypeId = self.m_tListItem[i].types
                self.m_nSelectedActivityId = self.m_tListItem[i].activityId

                self:_ActivityContext(self.m_tListItem[i].activityId,self.m_tListItem[i].types)
            end
        end
	end
end

function WndFreeca:sortCard(  )
    WZLog("--WndFreeca:sortCard--",CacheCenter:getPlayerItemCountById(52),CacheCenter:getPlayerItemCountById(50))
	if CacheCenter:getPlayerItemCountById(55) > 0 then
		--WZLog("--1111111111111111--")
		for i=1,#self.m_tListItem do
			if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_WEEKCARD then
				table.insert(self.m_tListItem,self.m_tListItem[i])
				table.remove(self.m_tListItem,i)
				--return
			end
		end
	end
	if CacheCenter:getPlayerItemCountById(50) > 0 then
		--WZLog("--22222222222222222--")
		for i=1,#self.m_tListItem do
			if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_MONTHCARD then
				table.insert(self.m_tListItem,self.m_tListItem[i])
				table.remove(self.m_tListItem,i)
				--return
			end
		end
	end
	if CacheCenter:getPlayerItemCountById(52) ~= 0 then
		--WZLog("--33333333333333333--")
		for i=1,#self.m_tListItem do
			if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_FOREVERWELFARECARD then
				table.insert(self.m_tListItem,self.m_tListItem[i])
				table.remove(self.m_tListItem,i)
				--return
			end
		end
	end
	if CacheCenter:getPlayerItemCountById(56) ~= 0 then
		--WZLog("--44444444444444444444444444--")
		for i=1,#self.m_tListItem do
			if self.m_tListItem[i].types == g_tGameActivityTypes.ACTIVITY_ENJOYCARD then
				table.insert(self.m_tListItem,self.m_tListItem[i])
				table.remove(self.m_tListItem,i)
				--return
			end
		end
	end
    self:_updateListItem()
end

--@brief 	点击item的响应方法
function WndFreeca:updataParentByCellItem(nTag)
	WZLog("WndFreeca:updataParentByCellItem", nTag)

    for i = 1, #self.m_tListItem do
        if i == nTag then
 			self.m_nCurrentSelectTypeId = self.m_tListItem[i].types
            self.m_nSelectedActivityId = self.m_tListItem[i].activityId
            
            self:_ActivityContext(self.m_nSelectedActivityId, self.m_nCurrentSelectTypeId)
        end
    end
    self.m_nClickNowId = nTag
end

--@brief    发送请求刷新充值进度
function WndFreeca:refreshActivityContext(activityId)
    WZLog("--WndFreeca:refreshActivityContext--")
    self:sortCard()
    self.m_nSpecifyActivityId = activityId
end

--@brief 	设置面板内容
function WndFreeca:_ActivityContext( nId, nType)
	WZLog("WndFreeca:_ActivityContext  nId="..nId, nType)
    if nType == g_tGameActivityTypes.ACTIVITY_WEEKCARD
			or nType == g_tGameActivityTypes.ACTIVITY_MONTHCARD
            or nType == g_tGameActivityTypes.ACTIVITY_FOREVERWELFARECARD
            or nType == g_tGameActivityTypes.ACTIVITY_ENJOYCARD
            or nType == g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD then
		WZLog("路径1")
        
        if nType == g_tGameActivityTypes.ACTIVITY_MONTHCARD then
            self:_createLoading()
            ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWelfareCardActivityInfo(g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT)
        elseif nType == g_tGameActivityTypes.ACTIVITY_WEEKCARD then 
            self:_createLoading()
            ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWelfareCardActivityInfo(g_tGameActivityTypes.ACIVIITY_WEEKCARD_DISCOUNT)
        elseif nType == g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD then 
            self:_createLoading()

            ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWelfareCardActivityInfo(g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD)
        else
            self:_updateRightContent()
        end
    end
end

--@brief    设置右边容器内容
function WndFreeca:_updateRightContent(progress, num, endTime, rewardStatus, itemId, itemNum, activityId)
    -- body
    local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndFreeca",WZUIContainer)
    if con_ActivityContext == nil then
        return
    end
    WZTempLog("self.m_nCurrentSelectTypeId>>>>>>>>>>>>>> ",self.m_nCurrentSelectTypeId)
    con_ActivityContext:removeAllChildrenWithCleanup(true)
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_WEEKCARD then
        WZLog("WndFreeca:_updateRightContent  周卡")
        local NodeTag = 115
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement = WndWeekCard:createElement()
            self.m_tCommonPanelLuaObj = WndWeekCard
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        self.m_tCommonPanelLuaObj:setMessage(progress, num, endTime)
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_MONTHCARD then
        WZLog("WndFreeca:_updateRightContent  月卡")
        local NodeTag = 116
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellMonthCardPanel:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        self.m_tCommonPanelLuaObj:setMessage(progress, num, endTime)
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FOREVERWELFARECARD then
        WZLog("WndFreeca:_updateRightContent  永久福利卡")
        local NodeTag = 119
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = WndWelfareCard:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_ENJOYCARD then
        WZLog("WndFreeca:_updateRightContent  永久尊享卡福利")
        local NodeTag = 120
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = WndEnjoyCard:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD then
        WZLog("WndFreeca:_updateRightContent  周一计划卡")
        local NodeTag = 121
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            self.m_tCommonPanelElement = CellMondayPlanCard:createElement()
            self.m_tCommonPanelLuaObj = CellMondayPlanCard
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        self.m_tCommonPanelLuaObj:setMessage(progress, num, endTime, rewardStatus, itemId, itemNum, activityId)
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
    end

    if self.m_tCommonPanelLuaObj then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    事件
function WndFreeca:onTouchBegan(element,pt)
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

--@brief 	刷新周卡，月卡的剩余时间
function WndFreeca:_updatePlayerItemData()
    --body
    WZLog("WndFreeca:_updatePlayerItemData")
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_MONTHCARD 
        or self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_WEEKCARD then
        WZLog("WndFreeca:_updatePlayerItemData 111")
        self.m_tCommonPanelLuaObj:updateLeftDay()
    end
end

function WndFreeca:setVisibleStatus(visible)
    local rootContainer = GetElement(self.m_root, "rootContainer", WZUIContainer)
    if rootContainer then
        rootContainer:setVisible(visible)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
