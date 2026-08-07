--WndAuctionHouseAct.lua
--@brief	WndAuctionHouseAct的UI模块
--@date		2020/08/03
--@author	yrd
--@note		拍卖行活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAuctionHouseAct:onEnter(element)
	self.m_root = element
    ProtocolProcessorNewActivity:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAuctionHouseAct:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
    self.m_root:disableSchedule()
    ProtocolProcessorNewActivity:unregAll()

	self:_unInit()
end

--@brief    onenter函数已执行
function WndAuctionHouseAct:onEnterTransitionDidFinish(element)
    WZLog("WndAuctionHouseAct:onEnterTransitionDidFinish")
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    self:setTitle()

    self:_ActivityContext(self.m_nCurrentSelectTypeId)

    self.m_root:enableSchedule("_removeInvalidActivity", 2)
end

--@brief    关闭窗口
function WndAuctionHouseAct:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    
   WindowManager:removeWindow(self.m_root , self , true)
end

--@brief    点击规则按钮回调
function WndAuctionHouseAct:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE == self.m_nCurrentSelectTypeId then
        WndAuctionCurrencyObtain:showInterface(2)
    end
end

--@brief    发送请求刷新充值进度
function WndAuctionHouseAct:refreshActivityContext()
    -- body
    self:_closeLoading()
    self:_ActivityContext(self.m_nCurrentSelectTypeId)
end

--@brief 	设置活动面板内容
function WndAuctionHouseAct:_ActivityContext(nType)
	if nType == g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE then --拍卖行
        ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionInfo( )
	end
end

--@brief    触摸开始回调
function WndAuctionHouseAct:onTouchBegan(element)
    -- body
    self.m_nStartTouchTime = WZThread:getUTickCount()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置面板内容
function WndAuctionHouseAct:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	-- WZLog("WndAuctionHouseAct::_updateActivityContext()")
	-- local conActivityC = GetElement(self.m_root,"conActivityC_WndAuctionHouseAct",WZUIContainer)
 --    if conActivityC == nil then
 --        return
 --    end

 --    WZLog("WndAuctionHouseAct.m_nCurrentSelectTypeId="..self.m_nCurrentSelectTypeId)
	-- if g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE == self.m_nCurrentSelectTypeId then 
	-- 	WZLog("WndAuctionHouseAct:_updateActivityContext|| 拍卖行")
	-- 	local NodeTag = 10
 --        local bRet = true
 --        self.m_tCommonPanelElement = conActivityC:getChildByTag(NodeTag)
 --        if self.m_tCommonPanelElement ~= nil then
 --            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
 --            self.m_tCommonPanelLuaObj = CellAuctionHouse
 --            bRet = false
 --        else
 --            bRet = true
 --            self.m_tCommonPanelElement = CellAuctionHouse:createElement()
 --            self.m_tCommonPanelLuaObj = CellAuctionHouse
 --        end
 --        if bRet then
 --            conActivityC:addChild(self.m_tCommonPanelElement, 0, NodeTag)
 --        end
 --        self.m_tCommonPanelLuaObj:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
 --    end 
    
	-- if self.m_tCommonPanelElement ~= nil then
 --        self.m_tCommonPanelLuaObj:showWindow()
 --    end
end

--@brief    凌晨时，扫描一遍活动列表，把到期的活动移除掉
function WndAuctionHouseAct:_removeInvalidActivity(element)
    -- body
    if g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE == self.m_nCurrentSelectTypeId then
        if g_cityExtenInfo.auction == nil or g_cityExtenInfo.auction == 0 then
            WindowManager:removeWindow(self.m_root, self, true)
            MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_END_TITLE)
        end
    end


    local serverTime = SystemTime:getServerTime()
    if self.m_nEndTime == nil then return end 
    
    if self.m_nEndTime <= serverTime then 
    	element:disableSchedule()
        if g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE == self.m_nCurrentSelectTypeId then 
            g_cityExtenInfo.activityPokerStatus = 0
            if WndHappyShakeTask.m_root then 
                WindowManager:removeWindow(WndHappyShakeTask.m_root, WndHappyShakeTask, true)
            end
        end
    	WindowManager:removeWindow(self.m_root, self, true)
    	MsgBoxManager:showTipBox(LocalStrings.WORLD_BOSS_END_TITLE)
    end
end

--@brief    设置标题
function WndAuctionHouseAct:setTitle( )
    -- body
    local imgTitle = GetElement(self.m_root, "imgTitle_WndAuctionHouseAct", WZUIImage)
    local btnTip = GetElement(self.m_root, "btnTip_WndAuctionHouseAct", WZUIButton)
    if g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE == self.m_nCurrentSelectTypeId then 
        imgTitle:setFile("ui/newActivity/auctionHouse/hd_text_06.png")
    end
end
function WndAuctionHouseAct:_adaptLanguage_vn()
    local btnRule = GetElement(self.m_root,"btnRule",WZUIButton)
    if btnRule then
        btnRule:setRelativePosition(GlobalMethod:ccp(0.78,0.827))
    end
end
-------------------------------------私有方法模块End----------------------------------------
