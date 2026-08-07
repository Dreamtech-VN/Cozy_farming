--WndFootballActivity.lua
--@brief	WndFootballActivity的UI模块
--@date		2017/05/22
--@author	peiting_mao
--@note		足球活动入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootballActivity:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    ProtocolProcessorWndRankList:regAll()
    --注册缓存中心数据监听
    CacheCenter:registerUpatePlayerItemObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFootballActivity:onExit(element)
    GlobalGame.g_autoNewActivity = false
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
    --self.m_root:disableSchedule()
    --反注册缓存中心数据监听
    CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
    if WZFileUtil:isFileExist("pack/football/pack_football_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/football/pack_football_0.plist")
    end
end

--@brief    onenter函数已执行
function WndFootballActivity:onEnterTransitionDidFinish(element)
    WZLog("WndFootballActivity:onEnterTransitionDidFinish")
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    
    local conActivityContext = GetElement(self.m_root, "conActivityContext_WndGameActivity", WZUIContainer)
    if GlobalGame.g_autoFootballActivity and GlobalGame.g_autoFootballActivity == 1 then
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo(5)
    else
        ShowPanelNullTip( conActivityContext, LocalStrings.ACTIVITY_YEAR_END)
    end
end

--@brief    弹窗动画完成后的回调
function WndFootballActivity:actionCallback_close()
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    关闭窗口
function WndFootballActivity:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    IS_FOOTBALL_RANK = false

    self:actionCallback_close()
end

--@brief 	点击item的响应方法
function WndFootballActivity:updataParentByCellItem(nTag)
   
    local activityInfo = self.m_tListItem[nTag+1]

    self.m_nCurrentSelectTypeId = activityInfo.types
    self.m_nSelectedActivityId = activityInfo.activityId
    WZLog("WndFootballActivity:updataParentByCellItem",nTag,self.m_nCurrentSelectTypeId)
    
    self:_ActivityContext(self.m_nSelectedActivityId,self.m_nCurrentSelectTypeId)
end

--@brief    创建并显示活动界面
--@param    activityId: 活动类型，值从m_tGameActivityTypes 取
--@tMsg     从消息列表传过来的数据
function WndFootballActivity:showInterface(activityId, tMsg)
    -- body
    if self.m_root ~= nil then
        self.m_nSpecifyActivityId = nil 
        self:_updateListItem()
    else
        local wndFootball = WndFootballActivity:createElement()
        if wndFootball ~= nil then
            self.m_nSpecifyActivityId = activityId
            WindowManager:addWindow(wndFootball, WndFootballActivity, nil, nil, nil, true)
            if tMsg then
                self.m_tMsgData = tMsg
            end
        end
    end
end

--@brief    点击规则按钮回调
function WndFootballActivity:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.FOOTBALL_TEXT8)
end

--@brief   创建加载框
function WndFootballActivity:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndFootballActivity:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end

--@brief 	刷新列表数据
function WndFootballActivity:_updateListItem()
    WZLog("WndFootballActivity:_updateListItem")
    local GetElement  = GetElement
	local ItemCount = #self.m_tListItem
    local bIsEatthingsActive = false
    local bExit = false
    if self.m_nSpecifyActivityId ~= nil then
        for i,v in ipairs(self.m_tListItem) do
            if v.types == self.m_nSpecifyActivityId then
                bExit = true
                break
            end
        end
    end
    if not bExit then
        self.m_nSpecifyActivityId = nil
    end
    
	for i=1,ItemCount do
        local conActivity = GetElement(self.m_root,"conActivity" .. i .. "_WndFootballActivity",WZUIContainer)
        local btn = GetElement(conActivity,"btn_WndFootballActivity",WZUIButton)
        local txtActivityName = GetElement(conActivity,"txtActivityName_WndFootballActivity",WZUILabelTTF)
        conActivity:setVisible(true)
        txtActivityName:setText(self.m_tListItem[i].title)
        if self.m_nSpecifyActivityId == nil then  --or not bSpecifyIdExist
            if i == 1 then
                btn:setTouchEnable(false)
            	self.m_nClickNowId = 0
            	self.m_nCurrentSelectTypeId = self.m_tListItem[i].types
                self.m_nSelectedActivityId = self.m_tListItem[i].activityId
                self:_ActivityContext(self.m_tListItem[i].activityId,self.m_tListItem[i].types)
            end
        else
            if self.m_nSpecifyActivityId == self.m_tListItem[i].types then
                self.m_nClickNowId = i-1
                self.m_nCurrentSelectTypeId = self.m_tListItem[i].types
                self.m_nSelectedActivityId = self.m_tListItem[i].activityId
                btn:setTouchEnable(false)
                self:_ActivityContext(self.m_tListItem[i].activityId,self.m_tListItem[i].types)
            end
        end
	end

    GetElement(self.m_root, "imgSel" .. (self.m_nClickNowId + 1) .. "_WndFootballActivity"):setVisible(true)
end

function WndFootballActivity:onClickActivity(element)
    WZLog("WndFootballActivity:onClickActivity")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = element:getTag()
    local activityInfo = self.m_tListItem[tag]
    -- if not self:_activityIsExit(activityInfo.types) then
    --     MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
    --     return
    -- end
    element:setTouchEnable(false)
   
    local indexxx = self.m_nClickNowId + 1
    GetElement(self.m_root, "imgSel" .. indexxx .. "_WndFootballActivity"):setVisible(false)
    local GetElement = GetElement
    local conActivity = GetElement(self.m_root,"conActivity" .. indexxx .. "_WndFootballActivity",WZUIContainer)
    local btn = GetElement(conActivity,"btn_WndFootballActivity",WZUIButton)
    btn:setTouchEnable(true)
    GetElement(self.m_root, "imgSel" .. tag .. "_WndFootballActivity"):setVisible(true)
    self.m_nClickNowId = tag - 1
    self:updataParentByCellItem(self.m_nClickNowId)
   
    
end

function WndFootballActivity:updateRedDot()
    -- body
    WZLog("************ WndFootballActivity:updateRedDot **********")
    
end

--@brief 	设置活动面板内容
function WndFootballActivity:_ActivityContext( nId ,nType )
	WZLog("WndFootballActivity:_ActivityContext  nId=",nId ,nType)
    if self.m_root == nil then return end
    
    self:_createLoading()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId,nType)
end

--@brief    事件
function WndFootballActivity:onTouchBegan(element,pt)
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

-- 活动标题
function WndFootballActivity:_updateTitle( )
    local imgTitle = GetElement(self.m_root,"imgTitle_WndFootballActivity",WZUIImage)
    local g_tGameActivityTypes = g_tGameActivityTypes
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT then
        imgTitle:setFile("ui/football/football_text_001.png")
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FOOTBALL_QUIZ then
        imgTitle:setFile("ui/football/football_text_001.png")
    end
end

--@brief 	设置面板内容
function WndFootballActivity:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	WZLog("WndFootballActivity::_updateActivityContext ",self.m_nSelectedActivityId == activityId,rewardCounts[1],Serialize(tips))
    self:_updateTitle( )
	local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
    
    if con_ActivityContext == nil then
        return
    end
    con_ActivityContext:setVisible(true)
    if self.m_nSelectedActivityId == activityId then
        con_ActivityContext:removeAllChildrenWithCleanup(true)
    else
        return 
    end
   
    WZLog("m_nCurrentSelectTypeId="..self.m_nCurrentSelectTypeId)
    local g_tGameActivityTypes = g_tGameActivityTypes

    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT then
        WZLog("WndGameActivity:_updateRightContent  CellFootballGame")
        local NodeTag = 122
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement, self.m_tCommonPanelLuaObj = CellFootballGame:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(tips, rewardItems, rewardItemsParamCount, rewardCounts, count)
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_FOOTBALL_QUIZ then
        WZLog("WndGameActivity:_updateRightContent  CellFootballGame")
        local NodeTag = 123
        local bRet = true
        self.m_tCommonPanelElement = con_ActivityContext:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = self.m_tCommonPanelElement:getLuaObjectIndex()
            bRet = false
        else
            --WndGameSingIn.m_bNeedSendProtocol = true
            self.m_tCommonPanelElement = WndFootballAct:createElement()
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            bRet = true
            self.m_tCommonPanelLuaObj = WndFootballAct
        end
        if bRet then
            con_ActivityContext:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(tips, rewardItems, rewardItemsParamCount, rewardCounts)
    else
		WZLog("error activity ",self.m_nCurrentSelectTypeId)
    end 
    
    self:setActivityTime(startTime, endTime)
	if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    设置活动时间
function WndFootballActivity:setActivityTime(startTime, endTime)
    -- body
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_WndFootballActivity", WZUILabelTTF)
    local txtTime = GetElement(self.m_root, "txtTime_WndFootballActivity", WZUILabelTTF)

    txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")

    local startDate = os.date("*t", startTime)
    local endDate = os.date("*t", endTime)
    txtTime:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min))
end

--@brief    红包奖励领取成功后的处理
-- function WndFootballActivity:getRedPackOKClose()
--     -- body
--     ShowRedEnvelopesRain()
-- end

--@brief    计时
-- function WndFootballActivity:caculateTime(element)
--     local conRedboxAct = GetElement(self.m_root,"conRedboxAct_WndFootballActivity",WZUIContainer)
--     local ftbCountdown = GetElement(conRedboxAct, "ftbCountdown_WndFootballActivity", WZUIFreeTextBox)
--     local txtOverTip = GetElement(conRedboxAct,"txtOverTip_WndFootballActivity",WZUILabelTTF)
--     if self.m_nRewardCounts  and self.m_nRewardCounts > 0 then
--         self.m_nRewardCounts = self.m_nRewardCounts - 1 
--         if ftbCountdown then
--             local sTime     = returnToTimeFormat(self.m_nRewardCounts)
--             ftbCountdown:setShowText(string.format(LocalStrings.REDPACK_ATT3, sTime))
--         end
--         txtOverTip:setVisible(false)
--     else
--         ftbCountdown:setShowText("")
--         element:disableSchedule()
--         txtOverTip:setVisible(true)
--     end
-- end

function WndFootballActivity:onClickDetail(element)
    WZLog("WndFootballActivity:onClickDetail")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.ONE_YEAR_DES)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

function WndFootballActivity:_adaptLanguage_vn( )
    for i = 1, 6 do
        local conActivity = GetElement(self.m_root,"conActivity"..i.."_WndFootballActivity",WZUIContainer)
        local txtActivityName = GetElement(conActivity,"txtActivityName_WndFootballActivity",WZUILabelTTF)
        txtActivityName:setScale(0.6)
        txtActivityName:setDimensions(GlobalMethod:CCSize(150))
        txtActivityName:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    end
end

-- function WndFootballActivity:_adaptLanguage_pt( )
--     for i = 1, 6 do
--         local conActivity = GetElement(self.m_root,"conActivity"..i.."_WndFootballActivity",WZUIContainer)
--         local txtActivityName = GetElement(conActivity,"txtActivityName_WndFootballActivity",WZUILabelTTF)
--         txtActivityName:setScale(0.6)
--         txtActivityName:setDimensions(GlobalMethod:CCSize(150))
--         txtActivityName:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
--     end

--     local txtRedboxTip = GetElement(self.m_root,"txtRedboxTip_WndFootballActivity",WZUILabelTTF)
--     txtRedboxTip:setScale(0.8)
--     txtRedboxTip:setRelativePosition(GlobalMethod:ccp(0.153184,-0.0839571))
--     local txtRedboxTime = GetElement(self.m_root,"txtRedboxTime_WndFootballActivity",WZUILabelTTF)
--     txtRedboxTime:setRelativePosition(GlobalMethod:ccp(0.547575,-0.157034))

--     local txtRedpack = GetElement(self.m_root,"txtRedpack_WndFootballActivity",WZUILabelTTF)
--     txtRedpack:setScale(0.7)
--     txtRedpack:setRelativePosition(GlobalMethod:ccp(0.287162,0.0440288))
--     local conGoToChat = GetElement(self.m_root,"conGoToChat_WndFootballActivity",WZUIContainer)
--     conGoToChat:setRelativePosition(GlobalMethod:ccp(0.483797,0.0402575))

--     local ftbCountdown = GetElement(self.m_root,"ftbCountdown_WndFootballActivity",WZUIFreeTextBox)
--     ftbCountdown:setScale(0.7)
--     ftbCountdown:setMaxWidth(320)
--     ftbCountdown:setRelativePosition(GlobalMethod:ccp(0.340319,0.2554))

--     local txtOverTip = GetElement(self.m_root,"txtOverTip_WndFootballActivity",WZUILabelTTF)
--     txtOverTip:setScale(0.7)
--     txtOverTip:setDimensions(GlobalMethod:CCSize(340))
--     txtOverTip:setRelativePosition(GlobalMethod:ccp(0.359091,0.475))
-- end

-- function WndFootballActivity:_adaptLanguage_es( )    
--     local conRedboxAct =  GetElement(self.m_root,"conRedboxAct_WndFootballActivity",WZUIContainer)
--     conRedboxAct:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
--     for i = 1, 6 do
--         local conActivity = GetElement(self.m_root,"conActivity"..i.."_WndFootballActivity",WZUIContainer)
--         local txtActivityName = GetElement(conActivity,"txtActivityName_WndFootballActivity",WZUILabelTTF)
--         txtActivityName:setScale(0.6)
--         txtActivityName:setDimensions(GlobalMethod:CCSize(150))
--         txtActivityName:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
--     end
--     local txtRedboxTip = GetElement(self.m_root,"txtRedboxTip_WndFootballActivity",WZUILabelTTF)
--     txtRedboxTip:setScale(0.8)
--     txtRedboxTip:setRelativePosition(GlobalMethod:ccp(0.153184,-0.0839571))
--     local txtRedboxTime = GetElement(self.m_root,"txtRedboxTime_WndFootballActivity",WZUILabelTTF)
--     txtRedboxTime:setRelativePosition(GlobalMethod:ccp(0.547575,-0.157034))

--     local txtRedpack = GetElement(self.m_root,"txtRedpack_WndFootballActivity",WZUILabelTTF)
--     txtRedpack:setScale(0.57)
--     txtRedpack:setRelativePosition(GlobalMethod:ccp(0.287162,0.0440288))
--     local conGoToChat = GetElement(self.m_root,"conGoToChat_WndFootballActivity",WZUIContainer)
--     conGoToChat:setRelativePosition(GlobalMethod:ccp(0.483797,0.0402575))

--     local ftbCountdown = GetElement(self.m_root,"ftbCountdown_WndFootballActivity",WZUIFreeTextBox)
--     ftbCountdown:setScale(0.7)
--     ftbCountdown:setMaxWidth(320)
--     ftbCountdown:setRelativePosition(GlobalMethod:ccp(0.340319,0.2554))

--     local txtOverTip = GetElement(self.m_root,"txtOverTip_WndFootballActivity",WZUILabelTTF)
--     txtOverTip:setScale(0.7)
--     txtOverTip:setDimensions(GlobalMethod:CCSize(340))
--     txtOverTip:setRelativePosition(GlobalMethod:ccp(0.359091,0.475))
-- end

-- function WndFootballActivity:_adaptLanguage_en( )
--     local conRedboxAct =  GetElement(self.m_root,"conRedboxAct_WndFootballActivity",WZUIContainer)
--     conRedboxAct:setRelativePosition(GlobalMethod:ccp(0.6,0.5))

--     for i = 1, 6 do
--         local conActivity = GetElement(self.m_root,"conActivity"..i.."_WndFootballActivity",WZUIContainer)
--         local txtActivityName = GetElement(conActivity,"txtActivityName_WndFootballActivity",WZUILabelTTF)
--         txtActivityName:setScale(0.6)
--         txtActivityName:setDimensions(GlobalMethod:CCSize(150))
--         txtActivityName:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
--     end
    
--     local txtRedboxTip = GetElement(self.m_root,"txtRedboxTip_WndFootballActivity",WZUILabelTTF)
--     txtRedboxTip:setScale(0.8)
--     txtRedboxTip:setRelativePosition(GlobalMethod:ccp(0.153184,-0.0839571))
--     local txtRedboxTime = GetElement(self.m_root,"txtRedboxTime_WndFootballActivity",WZUILabelTTF)
--     txtRedboxTime:setRelativePosition(GlobalMethod:ccp(0.547575,-0.157034))

--     local txtRedpack = GetElement(self.m_root,"txtRedpack_WndFootballActivity",WZUILabelTTF)
--     txtRedpack:setScale(0.7)
--     txtRedpack:setRelativePosition(GlobalMethod:ccp(0.287162,0.0440288))
--     local conGoToChat = GetElement(self.m_root,"conGoToChat_WndFootballActivity",WZUIContainer)
--     conGoToChat:setRelativePosition(GlobalMethod:ccp(0.483797,0.0402575))

--     local ftbCountdown = GetElement(self.m_root,"ftbCountdown_WndFootballActivity",WZUIFreeTextBox)
--     ftbCountdown:setScale(0.7)
--     ftbCountdown:setMaxWidth(320)
--     ftbCountdown:setRelativePosition(GlobalMethod:ccp(0.340319,0.2554))
    
--     local txtOverTip = GetElement(self.m_root,"txtOverTip_WndFootballActivity",WZUILabelTTF)
--     txtOverTip:setScale(0.7)
--     txtOverTip:setDimensions(GlobalMethod:CCSize(340))
--     txtOverTip:setRelativePosition(GlobalMethod:ccp(0.359091,0.475))
-- end