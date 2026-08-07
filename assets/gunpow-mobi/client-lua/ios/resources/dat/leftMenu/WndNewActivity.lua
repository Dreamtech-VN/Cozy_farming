--WndNewActivity.lua
--@brief	WndNewActivity的UI模块
--@date		2017/05/22
--@author	peiting_mao
--@note		一周年活动入口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewActivity:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
	ProtocolProcessorWndActivityOnLine:regAll()
    ProtocolProcessorWndRankList:regAll()
    --注册缓存中心数据监听
    CacheCenter:registerUpatePlayerItemObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewActivity:onExit(element)
    GlobalGame.g_autoNewActivity = false
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
    --self.m_root:disableSchedule()
    --反注册缓存中心数据监听
    CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
	ProtocolProcessorWndActivityOnLine:unregAll()
end

--@brief    onenter函数已执行
function WndNewActivity:onEnterTransitionDidFinish(element)
    WZLog("WndNewActivity:onEnterTransitionDidFinish")
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
    
    if self:_bActivityStart() then
        self:_createLoading()
        GetElement(self.m_root,"conExplain_WndNewActivity",WZUIContainer):setVisible(true)
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityListInfo()
    else
        local conExplain= GetElement(self.m_root,"conExplain_WndNewActivity",WZUIContainer)
        conExplain:setVisible(false)

        local conTrailerActivity = GetElement(self.m_root,"conTrailerActivity_WndNewActivity",WZUIContainer)
        conTrailerActivity:setVisible(true)

        self:updateImage(true)
    end
    self:updateRechargeInfo()
end

--@brief    弹窗动画完成后的回调
function WndNewActivity:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    关闭窗口
function WndNewActivity:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end

--@brief 	点击item的响应方法
function WndNewActivity:updataParentByCellItem(nTag)
   
    local activityInfo = self.m_tListItem[nTag+1]

    self.m_nCurrentSelectTypeId = activityInfo.types
    self.m_nSelectedActivityId = activityInfo.activityId
    WZLog("WndNewActivity:updataParentByCellItem",nTag,self.m_nCurrentSelectTypeId)
    
    self:_ActivityContext(self.m_nSelectedActivityId,self.m_nCurrentSelectTypeId)
    
    if CacheCenter.m_tYearActivityItemRedDotList and self.m_nSelectedActivityId ~=  g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2 then
        for i,v in ipairs(CacheCenter.m_tYearActivityItemRedDotList) do
            if v == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2 then
                self:_updateLoginRed(true)
            end
        end
    end
end

--@brief    创建并显示活动界面
--@param    activityId: 活动类型，值从m_tGameActivityTypes 取
--@tMsg     从消息列表传过来的数据
function WndNewActivity:showInterface(activityId, tMsg)
    -- body
    local isTeach = TeachGroup1.ISTEACH == true and TeachGroup1.GROUP == 24 and TeachGroup1.STEP == 1
    if CheckButtonOpen(122) and SceneCity:isAnniversary() and isTeach ~= true and self:_bActivityStart() and self:_activityIsExit() then
        if self.m_root ~= nil then
            self.m_nSpecifyActivityId = nil 
            self:_updateListItem()
        else
            local wndNewActivity = WndNewActivity:createElement()
            if wndNewActivity ~= nil then
                self.m_nSpecifyActivityId = activityId
                WindowManager:addWindow(wndNewActivity,WndNewActivity,nil,nil,nil,true)
                if tMsg then
                    self.m_tMsgData = tMsg
                end
            end
        end
    end
end

--@brief   创建加载框
function WndNewActivity:_createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndNewActivity:_closeLoading()
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId( nId )
end

--@brief 	刷新列表数据
function WndNewActivity:_updateListItem()
    WZLog("WndNewActivity:_updateListItem")
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
        local conActivity = GetElement(self.m_root,"conActivity" .. i .. "_WndNewActivity",WZUIContainer)
        local btn = GetElement(conActivity,"btn_WndNewActivity",WZUIButton)
        local txtActivityName = GetElement(conActivity,"txtActivityName_WndNewActivity",WZUILabelTTF)
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
end

function WndNewActivity:onClickActivity(element)
    WZLog("WndNewActivity:onClickActivity")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = element:getTag()
    local activityInfo = self.m_tListItem[tag]
    if not self:_activityIsExit(activityInfo.types) then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return
    end
    element:setTouchEnable(false)
   
    local indexxx = self.m_nClickNowId + 1
    local GetElement = GetElement
    local conActivity = GetElement(self.m_root,"conActivity" .. indexxx .. "_WndNewActivity",WZUIContainer)
    local btn = GetElement(conActivity,"btn_WndNewActivity",WZUIButton)
    btn:setTouchEnable(true)
    self.m_nClickNowId = tag - 1
    self:updataParentByCellItem(self.m_nClickNowId)
   
    
end

function WndNewActivity:updateRedDot()
    -- body
    WZLog("************ WndNewActivity:updateRedDot **********")
    
end

--@breif   对列表进行刷选
function WndNewActivity:_sortListItem( ItemCount )
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
--@param   bRecharge：是否为充值活动刷新
function WndNewActivity:refreshActivityContext(bRecharge)
    WZLog("WndNewActivity:refreshActivityContext")
    if self.m_root == nil then return end
    if bRecharge then
        if self.m_nCurrentSelectTypeId ~= 88888 then return end
    end
    self:_ActivityContext(self.m_nSelectedActivityId, self.m_nCurrentSelectTypeId)
end


--@brief 	设置活动面板内容
function WndNewActivity:_ActivityContext( nId ,nType )
	WZLog("WndNewActivity:_ActivityContext  nId=",nId ,nType)
    if self.m_root == nil then return end
    local GetElement = GetElement
    local conActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
    local conRechargeDouble = GetElement(self.m_root,"conRechargeDouble_WndNewActivity",WZUIContainer)
    local conWishingAct = GetElement(self.m_root,"conWishingAct_WndNewActivity",WZUIContainer)
    local conRedboxAct = GetElement(self.m_root,"conRedboxAct_WndNewActivity",WZUIContainer)
    conRechargeDouble:setVisible(false)
    conWishingAct:setVisible(false)
    conRedboxAct:setVisible(false)

     self:updateImage()
    if nType == 77777 then
        conWishingAct:setVisible(true)
        conActivityContext:removeAllChildrenWithCleanup(true)
        local activityInfo = self.m_tListItem[self.m_nClickNowId+1]
        local startTime = activityInfo.startTime
        local imgNotOpen = GetElement(conWishingAct,"imgNotOpen_WndNewActivity",WZUIImage)
        local imgOpen = GetElement(conWishingAct,"imgOpen_WndNewActivity",WZUIImage)
        local conGoWishing = GetElement(conWishingAct,"conGoWishing_WndNewActivity",WZUIContainer)
        local imgTime = GetElement(conWishingAct,"imgTime_WndNewActivity",WZUIImage)
        imgTime:setFile("")
        if startTime > 0 then
            imgNotOpen:setVisible(true)
            imgOpen:setVisible(false)
            conGoWishing:setVisible(false)
            imgTime:setVisible(true)
            if startTime > 5 then
                startTime = 5
            end
            imgTime:setFile("ui/anniversary/znq_sz" .. startTime .. ".png")
        else
            imgNotOpen:setVisible(false)
            imgOpen:setVisible(true)
            conGoWishing:setVisible(true)
        end
    elseif nType == 88888 then
        self:_createLoading()
        ProtocolProcessorRecharge:send_PURCHASE_GetNianGiftIdList(ProjConfig.CHANNEL_ID)
    elseif nType == 99999 then
        conActivityContext:removeAllChildrenWithCleanup(true)
        conRechargeDouble:setVisible(true)
    else
        self:_createLoading()
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(nId,nType)
    end
end

--@brief    事件
function WndNewActivity:onTouchBegan(element,pt)
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

function WndNewActivity:onClickToRecharge(element)
    WZLog("WndNewActivity:onClickToRecharge")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self:_activityIsExit(99999) then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return
    end
    WndVip:showWndUI(0)
    self:actionCallback_close()
end

--@brief 	设置面板内容
function WndNewActivity:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	WZLog("WndNewActivity::_updateActivityContext ",rewardCounts[1],Serialize(tips))
	local con_ActivityContext = GetElement(self.m_root,"conActivityContext_WndGameActivity",WZUIContainer)
    local conRedboxAct =  GetElement(self.m_root,"conRedboxAct_WndNewActivity",WZUIContainer)
    local conRechargeDouble = GetElement(self.m_root,"conRechargeDouble_WndNewActivity",WZUIContainer)
    local conWishingAct = GetElement(self.m_root,"conWishingAct_WndNewActivity",WZUIContainer)
    if con_ActivityContext == nil then
        return
    end
    con_ActivityContext:setVisible(true)
    if self.m_nSelectedActivityId == activityId then
        con_ActivityContext:removeAllChildrenWithCleanup(true)
    else
        return 
    end
    conRedboxAct:setVisible(false)
    conRechargeDouble:setVisible(false)
    conWishingAct:setVisible(false)
    WZLog("m_nCurrentSelectTypeId="..self.m_nCurrentSelectTypeId)
    local g_tGameActivityTypes = g_tGameActivityTypes
    if self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK then 
        local NodeTag = 118
        local bRet = true 
        
        conRedboxAct:setVisible(true)
        local txtOverTip = GetElement(conRedboxAct,"txtOverTip_WndNewActivity",WZUILabelTTF)
        local maxTip = #tips
        local indexxx = math.random(1,maxTip)
        txtOverTip:setText(tips[indexxx])

        local txtRedboxTip = GetElement(conRedboxAct,"txtRedboxTip_WndNewActivity",WZUILabelTTF)
        local temp = string.format(LocalStrings.REDPACK_ATT22,maxCount-count,maxCount)
        txtRedboxTip:setText(temp)

        local txtRedboxTime = GetElement(conRedboxAct,"txtRedboxTime_WndNewActivity",WZUILabelTTF)
        local startTimedd = os.date("%m.%d",startTime)

        local endTimeddd = os.date("%m.%d",endTime)
        txtRedboxTime:setText(LocalStrings.ACTIVE_TIME .. ":" .. startTimedd .. "-" .. endTimeddd)
        self.m_nRewardCounts = rewardCounts[1]
        local conGoToChat = GetElement(conRedboxAct,"conGoToChat_WndNewActivity",WZUIContainer)
        local txtOverTip = GetElement(conRedboxAct,"txtOverTip_WndNewActivity",WZUILabelTTF)
        txtOverTip:setVisible(true)
        if self.m_nRewardCounts > 0 and maxCount-count > 0 then
            local sTime   = returnToTimeFormat(self.m_nRewardCounts)
            local ftbCountdown = GetElement(conRedboxAct,"ftbCountdown_WndNewActivity",WZUIFreeTextBox)
            ftbCountdown:disableSchedule()
            ftbCountdown:setShowText(string.format(LocalStrings.REDPACK_ATT3,sTime))
            ftbCountdown:enableSchedule("caculateTime",1)
            txtOverTip:setVisible(false)
            conGoToChat:setVisible(true)
        end

        if maxCount-count <= 0 then
            local txtStats = GetElement(conRedboxAct,"txtStats_WndNewActivity",WZUILabelTTF)
            txtStats:setTextKey("PASS_OVER")

            local ftbCountdown = GetElement(conRedboxAct,"ftbCountdown_WndNewActivity",WZUIFreeTextBox)
            ftbCountdown:disableSchedule()
            ftbCountdown:setShowText("")
            txtOverTip:setText(LocalStrings.PASS_OVER)
            txtOverTip:setVisible(true)
            conGoToChat:setVisible(false)
        end
        
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
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2 then
        local element = CellDayRewardContain:createElement()
        CellDayRewardContain:setGetRewardCallback(self,self.sendProtocolGetReward)
        CellDayRewardContain:setRewardData(activityId,rewardId,rewardItems,rewardCounts,status,startTime,endTime,rewardItemsParamCount)
        con_ActivityContext:addChild(element)

        self:_updateLoginRed(false)
    else
		WZLog("error activity ",self.m_nCurrentSelectTypeId)
    end 
    
	if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    红包奖励领取成功后的处理
function WndNewActivity:getRedPackOKClose()
    -- body
    ShowRedEnvelopesRain()
end

--@brief    计时
function WndNewActivity:caculateTime(element)
    local conRedboxAct = GetElement(self.m_root,"conRedboxAct_WndNewActivity",WZUIContainer)
    local ftbCountdown = GetElement(conRedboxAct, "ftbCountdown_WndNewActivity", WZUIFreeTextBox)
    local txtOverTip = GetElement(conRedboxAct,"txtOverTip_WndNewActivity",WZUILabelTTF)
    if self.m_nRewardCounts  and self.m_nRewardCounts > 0 then
        self.m_nRewardCounts = self.m_nRewardCounts - 1 
        if ftbCountdown then
            local sTime     = returnToTimeFormat(self.m_nRewardCounts)
            ftbCountdown:setShowText(string.format(LocalStrings.REDPACK_ATT3, sTime))
        end
        txtOverTip:setVisible(false)
    else
        ftbCountdown:setShowText("")
        element:disableSchedule()
        txtOverTip:setVisible(true)
    end
end

function WndNewActivity:onClickDetail(element)
    WZLog("WndNewActivity:onClickDetail")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.ONE_YEAR_DES)
end

function WndNewActivity:sendProtocolGetReward(activityId,rewardId,dayIndex)
    WZLog("WndNewActivity:sendProtocolGetReward =",activityId,rewardId,dayIndex)
    if activityId == nil or rewardId == nil or dayIndex == nil then return end
    if not self:_activityIsExit(g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2) then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return
    end
    self.m_nDayIndex = dayIndex
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(activityId,rewardId)
end

function WndNewActivity:updateImage(closeStats)
    WZLog("WndNewActivity:updateImage ",self.m_nCurrentSelectTypeId)
    local imgPeople = GetElement(self.m_root,"imgPeople_WndNewActivity",WZUIImage)
    imgPeople:setTouchEnable(false)
    if closeStats then
        imgPeople:setFile("ui/combat/common_pic_meinv1_excited.png")
        imgPeople:setZOrder(3)
        imgPeople:setRelativePosition(GlobalMethod:ccp(0.357291,0.406491))
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_CUMULATIVELOGIN2 then --累计登录
        imgPeople:setFile("ui/combat/common_pic_meinv1_excited.png")
        imgPeople:setZOrder(0)
        imgPeople:setRelativePosition(GlobalMethod:ccp(0.357291,0.406491))
    elseif self.m_nCurrentSelectTypeId == 77777 then --许愿归来
        imgPeople:setFile("ui/combat/common_pic_shuaige1_excited.png")
        imgPeople:setZOrder(3)
        imgPeople:setRelativePosition(GlobalMethod:ccp(0.357291,0.406491))
    elseif self.m_nCurrentSelectTypeId ==  88888 then --喜庆礼包
        imgPeople:setFile("ui/combat/common_pic_meinv1_excited.png")
        imgPeople:setZOrder(0)
        imgPeople:setRelativePosition(GlobalMethod:ccp(0.357291,0.406491))
    elseif self.m_nCurrentSelectTypeId ==  99999 then --充值双倍
        imgPeople:setFile("ui/combat/common_pic_meinv4_excited.png")
        imgPeople:setZOrder(3)
        imgPeople:setRelativePosition(GlobalMethod:ccp(0.357291,0.406491))
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_ORDERREDPACK then --口令红包
        imgPeople:setFile("ui/combat/common_pic_shuaige1_happy.png")
        imgPeople:setZOrder(3)
        imgPeople:setRelativePosition(GlobalMethod:ccp(0.357291,0.406491))
    elseif self.m_nCurrentSelectTypeId == g_tGameActivityTypes.ACTIVITY_TYPE_FIREWORK then --放烟花
        imgPeople:setFile("ui/combat/common_pic_meinv4_excited.png")
        imgPeople:setZOrder(0)
        imgPeople:setRelativePosition(GlobalMethod:ccp(0.357291,0.406491))
    end
end

function WndNewActivity:onClickGoWishing(element)
    WZLog("WndNewActivity:onClickGoWishing")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self:_activityIsExit(77777) then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return
    end
    WndPromiseShrine:showWnd()
    self:actionCallback_close()
end

--@brief    点击前往按钮回调
function WndNewActivity:onClickGoTo(element)
    WZLog("WndNewActivity:onClickGoTo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not self:_activityIsExit(g_tGameActivityTypes.ACTIVITY_ORDERREDPACK) then
        MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
        return
    end
    local conRedboxAct = GetElement(self.m_root,"conRedboxAct_WndNewActivity",WZUIContainer)
    local txtOverTip = GetElement(conRedboxAct,"txtOverTip_WndNewActivity",WZUILabelTTF)
    local tempText = txtOverTip:isVisible() and txtOverTip:getText() or ""
    WndChat:showChatWindowForFightingByOrder(CHANNEL_WORLD,tempText)
    self:actionCallback_close()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

function WndNewActivity:_adaptLanguage_vn( )
    for i = 1, 6 do
        local conActivity = GetElement(self.m_root,"conActivity"..i.."_WndNewActivity",WZUIContainer)
        local txtActivityName = GetElement(conActivity,"txtActivityName_WndNewActivity",WZUILabelTTF)
        txtActivityName:setScale(0.6)
        txtActivityName:setDimensions(GlobalMethod:CCSize(150))
        txtActivityName:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    end
    GetElement(self.m_root,"txtGotoWishing1_WndNewActivity",WZUILabelTTF):setScale(0.6)
    GetElement(self.m_root,"txtGotoWishing2_WndNewActivity",WZUILabelTTF):setScale(0.6)
end

function WndNewActivity:_adaptLanguage_pt( )
    for i = 1, 6 do
        local conActivity = GetElement(self.m_root,"conActivity"..i.."_WndNewActivity",WZUIContainer)
        local txtActivityName = GetElement(conActivity,"txtActivityName_WndNewActivity",WZUILabelTTF)
        txtActivityName:setScale(0.6)
        txtActivityName:setDimensions(GlobalMethod:CCSize(150))
        txtActivityName:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    end

    local txtRedboxTip = GetElement(self.m_root,"txtRedboxTip_WndNewActivity",WZUILabelTTF)
    txtRedboxTip:setScale(0.8)
    txtRedboxTip:setRelativePosition(GlobalMethod:ccp(0.153184,-0.0839571))
    local txtRedboxTime = GetElement(self.m_root,"txtRedboxTime_WndNewActivity",WZUILabelTTF)
    txtRedboxTime:setRelativePosition(GlobalMethod:ccp(0.547575,-0.157034))

    local txtRedpack = GetElement(self.m_root,"txtRedpack_WndNewActivity",WZUILabelTTF)
    txtRedpack:setScale(0.7)
    txtRedpack:setRelativePosition(GlobalMethod:ccp(0.287162,0.0440288))
    local conGoToChat = GetElement(self.m_root,"conGoToChat_WndNewActivity",WZUIContainer)
    conGoToChat:setRelativePosition(GlobalMethod:ccp(0.483797,0.0402575))

    local ftbCountdown = GetElement(self.m_root,"ftbCountdown_WndNewActivity",WZUIFreeTextBox)
    ftbCountdown:setScale(0.7)
    ftbCountdown:setMaxWidth(320)
    ftbCountdown:setRelativePosition(GlobalMethod:ccp(0.340319,0.2554))

    local txtOverTip = GetElement(self.m_root,"txtOverTip_WndNewActivity",WZUILabelTTF)
    txtOverTip:setScale(0.7)
    txtOverTip:setDimensions(GlobalMethod:CCSize(340))
    txtOverTip:setRelativePosition(GlobalMethod:ccp(0.359091,0.475))
end

function WndNewActivity:_adaptLanguage_es( )    
    local conRedboxAct =  GetElement(self.m_root,"conRedboxAct_WndNewActivity",WZUIContainer)
    conRedboxAct:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    for i = 1, 6 do
        local conActivity = GetElement(self.m_root,"conActivity"..i.."_WndNewActivity",WZUIContainer)
        local txtActivityName = GetElement(conActivity,"txtActivityName_WndNewActivity",WZUILabelTTF)
        txtActivityName:setScale(0.6)
        txtActivityName:setDimensions(GlobalMethod:CCSize(150))
        txtActivityName:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    end
    local txtRedboxTip = GetElement(self.m_root,"txtRedboxTip_WndNewActivity",WZUILabelTTF)
    txtRedboxTip:setScale(0.8)
    txtRedboxTip:setRelativePosition(GlobalMethod:ccp(0.153184,-0.0839571))
    local txtRedboxTime = GetElement(self.m_root,"txtRedboxTime_WndNewActivity",WZUILabelTTF)
    txtRedboxTime:setRelativePosition(GlobalMethod:ccp(0.547575,-0.157034))

    local txtRedpack = GetElement(self.m_root,"txtRedpack_WndNewActivity",WZUILabelTTF)
    txtRedpack:setScale(0.57)
    txtRedpack:setRelativePosition(GlobalMethod:ccp(0.287162,0.0440288))
    local conGoToChat = GetElement(self.m_root,"conGoToChat_WndNewActivity",WZUIContainer)
    conGoToChat:setRelativePosition(GlobalMethod:ccp(0.483797,0.0402575))

    local ftbCountdown = GetElement(self.m_root,"ftbCountdown_WndNewActivity",WZUIFreeTextBox)
    ftbCountdown:setScale(0.7)
    ftbCountdown:setMaxWidth(320)
    ftbCountdown:setRelativePosition(GlobalMethod:ccp(0.340319,0.2554))

    local txtOverTip = GetElement(self.m_root,"txtOverTip_WndNewActivity",WZUILabelTTF)
    txtOverTip:setScale(0.7)
    txtOverTip:setDimensions(GlobalMethod:CCSize(340))
    txtOverTip:setRelativePosition(GlobalMethod:ccp(0.359091,0.475))
end

function WndNewActivity:_adaptLanguage_en( )
    local conRedboxAct =  GetElement(self.m_root,"conRedboxAct_WndNewActivity",WZUIContainer)
    conRedboxAct:setRelativePosition(GlobalMethod:ccp(0.6,0.5))

    for i = 1, 6 do
        local conActivity = GetElement(self.m_root,"conActivity"..i.."_WndNewActivity",WZUIContainer)
        local txtActivityName = GetElement(conActivity,"txtActivityName_WndNewActivity",WZUILabelTTF)
        txtActivityName:setScale(0.6)
        txtActivityName:setDimensions(GlobalMethod:CCSize(150))
        txtActivityName:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    end
    
    local txtRedboxTip = GetElement(self.m_root,"txtRedboxTip_WndNewActivity",WZUILabelTTF)
    txtRedboxTip:setScale(0.8)
    txtRedboxTip:setRelativePosition(GlobalMethod:ccp(0.153184,-0.0839571))
    local txtRedboxTime = GetElement(self.m_root,"txtRedboxTime_WndNewActivity",WZUILabelTTF)
    txtRedboxTime:setRelativePosition(GlobalMethod:ccp(0.547575,-0.157034))

    local txtRedpack = GetElement(self.m_root,"txtRedpack_WndNewActivity",WZUILabelTTF)
    txtRedpack:setScale(0.7)
    txtRedpack:setRelativePosition(GlobalMethod:ccp(0.287162,0.0440288))
    local conGoToChat = GetElement(self.m_root,"conGoToChat_WndNewActivity",WZUIContainer)
    conGoToChat:setRelativePosition(GlobalMethod:ccp(0.483797,0.0402575))

    local ftbCountdown = GetElement(self.m_root,"ftbCountdown_WndNewActivity",WZUIFreeTextBox)
    ftbCountdown:setScale(0.7)
    ftbCountdown:setMaxWidth(320)
    ftbCountdown:setRelativePosition(GlobalMethod:ccp(0.340319,0.2554))
    
    local txtOverTip = GetElement(self.m_root,"txtOverTip_WndNewActivity",WZUILabelTTF)
    txtOverTip:setScale(0.7)
    txtOverTip:setDimensions(GlobalMethod:CCSize(340))
    txtOverTip:setRelativePosition(GlobalMethod:ccp(0.359091,0.475))
end