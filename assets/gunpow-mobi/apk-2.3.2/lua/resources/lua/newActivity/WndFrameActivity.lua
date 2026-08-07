--WndFrameActivity.lua
--@brief	WndFrameActivity的UI模块
--@date		2020/05/15
--@author	XTX
--@note		独立框架活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFrameActivity:onEnter(element)
	self.m_root = element
    ProtocolProcessorNewActivity:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFrameActivity:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
    self.m_root:disableSchedule()
    ProtocolProcessorNewActivity:unregAll()

	self:_unInit()
end

--@brief    onenter函数已执行
function WndFrameActivity:onEnterTransitionDidFinish(element)
    WZLog("WndFrameActivity:onEnterTransitionDidFinish")
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    self:setTitle()

    self:_ActivityContext(self.m_nCurrentSelectTypeId)

    self.m_root:enableSchedule("_removeInvalidActivity", 2)
end

--@brief    关闭窗口
function WndFrameActivity:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    self:closeWin()
end

--@brief    关闭界面
function WndFrameActivity:closeWin()
    if self.m_root == nil then return end 
    --如果是自动弹出的活动界面
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    
   WindowManager:removeWindow(self.m_root , self , true)
end

--@brief    点击规则按钮回调
function WndFrameActivity:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if g_tGameActivityTypes.ACTIVITY_INVESTREBATE == self.m_nCurrentSelectTypeId then 
        WndSingleMapDesc:showInterface1(LocalStrings.FRAMEACTIVITY_TEXT1) 
    elseif g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE == self.m_nCurrentSelectTypeId then 
    	WndSingleMapDesc:showInterface1(LocalStrings.FOURYEAR_TEXT10) 
    elseif g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING == self.m_nCurrentSelectTypeId then
        WndTips:show(element,self.m_root,64,nil,GlobalMethod:ccp(50,20), true)
    end
end

--@brief    发送请求刷新充值进度
function WndFrameActivity:refreshActivityContext()
    -- body
    self:_closeLoading()
    self:_ActivityContext(self.m_nCurrentSelectTypeId)
end

--@brief 	设置活动面板内容
function WndFrameActivity:_ActivityContext(nType)
	--body
	if nType == g_tGameActivityTypes.ACTIVITY_INVESTREBATE then 
		--投资返利
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.IRStatus, nType)
    elseif nType == g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE then 
        --全民摇摇乐
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activityPokerStatus, nType)
    elseif nType == g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING then 
        --疯狂翻倍
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.CDStatus, nType)
	end
end

--@brief    触摸开始回调
function WndFrameActivity:onTouchBegan(element)
    -- body
    self.m_nStartTouchTime = WZThread:getUTickCount()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置面板内容
function WndFrameActivity:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	WZLog("WndFrameActivity::_updateActivityContext()")
	local conActivityC = GetElement(self.m_root,"conActivityC_WndFrameActivity",WZUIContainer)
    if conActivityC == nil then
        return
    end

    WZLog("m_nCurrentSelectTypeId="..self.m_nCurrentSelectTypeId)
	if g_tGameActivityTypes.ACTIVITY_INVESTREBATE == self.m_nCurrentSelectTypeId then 
		WZLog("WndFrameActivity:_updateActivityContext|| 投资返利", Serialize(status))
		local NodeTag = 10
        local bRet = true
        self.m_tCommonPanelElement = conActivityC:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = WndInvestRebate
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement = WndInvestRebate:createElement()
            self.m_tCommonPanelLuaObj = WndInvestRebate
        end
        if bRet then
            conActivityC:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        WZLog("rewardId="..rewardId[1])
        self.m_tCommonPanelLuaObj:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
    elseif g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE == self.m_nCurrentSelectTypeId then 
        WZLog("WndFrameActivity:_updateActivityContext|| 全民摇摇乐", Serialize(status))
        local NodeTag = 11
        local bRet = true
        self.m_tCommonPanelElement = conActivityC:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = WndHappyShake
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement = WndHappyShake:createElement()
            self.m_tCommonPanelLuaObj = WndHappyShake
        end
        if bRet then
            conActivityC:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end

        self.m_tCommonPanelLuaObj:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
    elseif g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING == self.m_nCurrentSelectTypeId then 
        WZLog("WndFrameActivity:_updateActivityContext|| 疯狂翻倍", Serialize(status))
        local NodeTag = 12
        local bRet = true
        self.m_tCommonPanelElement = conActivityC:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = WndCrazyDoubling
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement = WndCrazyDoubling:createElement()
            self.m_tCommonPanelLuaObj = WndCrazyDoubling
        end
        if bRet then
            conActivityC:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end

        self.m_tCommonPanelLuaObj:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
    end 
    
	if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    凌晨时，扫描一遍活动列表，把到期的活动移除掉
function WndFrameActivity:_removeInvalidActivity(element)
    -- body
    if g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING == self.m_nCurrentSelectTypeId then
        if g_cityExtenInfo.CDStatus == 0 then --活动被直接删除时
            WindowManager:removeWindow(self.m_root, self, true)
            MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_END_TITLE)
        end
    end

    local serverTime = SystemTime:getServerTime()
    if self.m_nEndTime == nil then return end 

    if self.m_nEndTime <= serverTime then 
    	element:disableSchedule()
        if g_tGameActivityTypes.ACTIVITY_INVESTREBATE == self.m_nCurrentSelectTypeId then 
            g_cityExtenInfo.IRStatus = 0
        elseif g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE == self.m_nCurrentSelectTypeId then 
            g_cityExtenInfo.activityPokerStatus = 0
            if WndHappyShakeTask.m_root then 
                WindowManager:removeWindow(WndHappyShakeTask.m_root, WndHappyShakeTask, true)
            end
        elseif g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING == self.m_nCurrentSelectTypeId then 
            g_cityExtenInfo.CDStatus = 0
        end
    	WindowManager:removeWindow(self.m_root, self, true)
    	MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_END_TITLE)
    end
end

--@brief    设置标题
function WndFrameActivity:setTitle( )
    -- body
    local imgTitle = GetElement(self.m_root, "imgTitle_WndFrameActivity", WZUIImage)
    local btnTip = GetElement(self.m_root, "btnTip_WndFrameActivity", WZUIButton)
    if g_tGameActivityTypes.ACTIVITY_INVESTREBATE == self.m_nCurrentSelectTypeId then 
        imgTitle:setFile("ui/gameActivity/hd_text_03.png")
    elseif g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE == self.m_nCurrentSelectTypeId then 
        imgTitle:setFile("ui/gameActivity/hd_text_05.png")
        btnTip:setVisible(false)
    elseif g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING == self.m_nCurrentSelectTypeId then 
        imgTitle:setFile("ui/gameActivity/hd_text_02.png")
    end
end
-------------------------------------私有方法模块End----------------------------------------
