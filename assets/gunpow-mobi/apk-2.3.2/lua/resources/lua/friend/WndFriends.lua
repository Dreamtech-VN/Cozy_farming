--WndFriends.lua
--@brief	WndFriends的UI模块
--@date		2015/07/21
--@author	wuweidong
--@note		好友界面

RRANK_INDEX = 1     --推荐
FRIEND_INDEX = 2    --好友
ONLINE_INDEX = 3    --动态
RECOMMEND_INDEX = 4 --推荐
INVITE_INDEX = 5    --邀请
BLACKLIST_INDEX = 6    --黑名单
FRIENDCIRCLE_INDEX = 7    --好友圈
HOTCIRCLE_INDEX = 8    --热点心情
MYCIRCLE_INDEX = 9    --我的心情
COMMENT_PERPAGE_NUM = 10 --评论每页显示的条数
FILTER_LIST = 11    --筛选列表
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFriends:onEnter(element)
	ChangeChatChannel(Chat_Channel_Friends_Social)
	self.m_root = element
    AdaptLanguage(self)
    WZLog("WndFriends:onEnter::",CacheCenter.m_nDailyMark)
    if CacheCenter.m_nDailyMark == 1 then
        self:showDynamicMark(true)
    else
        self:showDynamicMark(false)
    end
    if CacheCenter.m_nInviteMark > 0 then
        self:showFriendsMark(true)
    else
        self:showFriendsMark(false)
    end
    self:showMyCircleMark(GlobalGame.g_tRedPointList.myCircle)

    --玩家金币栏
    self:_addTop()

    local leftCon = GetElement(self.m_root,"conMid_WndFriends",WZUIContainer)
    leftCon:setVisible(true)
    WindowManagerAni:createSwitchTabAction(leftCon,0,false)
    self:_setTitleTxt()
    self.m_nMaxFriendliness = tonumber(CacheCenter:getGameParam()["maxFriendNum"]) or 99999

	ProtocolProcessorWndBag:regAll()
    ProtocolProcessorWndMaster:regAll1()
    self:register()

    --不显示师徒
    local checkTheme5 = GetElement(self.m_root,"checkTheme5_WndFriends",WZUICheckBox)
    checkTheme5:setVisible(false)
end

function WndFriends:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/bag_icon_hy.png", WndFriends, WndFriends.onCloseClick, true, false, false, "WndFriends")
    self.m_root:addChild(celElement)
    tNewObj:setTopType()
end

--@brief	加载动画
function WndFriends:onEnterTransitionDidFinish(element)
    --语言适配
    local conMidContent = GetElement(self.m_root,"conMidContent_WndFriends",WZUIContainer)
    conMidContent:enableSchedule("downloadFile", 0.1)

    self.m_nDefaultShowCommentNum = tonumber(CacheCenter:getGameParam().reviewShow) or 3
    WZLog("WndFriends:onEnterTransitionDidFinish", CacheCenter:getGameParam().reviewShow)
    self:_showMultiLanguage()
    
    --直接进入好友
    local checkTheme1_WndFriends = GetElement(self.m_root,"checkTheme1_WndFriends",WZUICheckBox)
    checkTheme1_WndFriends:setCheckIndex(0)
    local checkTheme2_WndFriends = GetElement(self.m_root,"checkTheme2_WndFriends",WZUICheckBox)
    checkTheme2_WndFriends:setCheckIndex(0)
    --Add By Tianxiang_Xu
    --海马包屏蔽掉社区
    local checkTheme3_WndFriends = GetElement(self.m_root,"checkTheme3_WndFriends",WZUICheckBox)
    checkTheme1_WndFriends:setVisible(false)
    local checkTheme4_WndFriends = GetElement(self.m_root,"checkTheme4_WndFriends",WZUICheckBox)
    local checkTheme5_WndFriends = GetElement(self.m_root,"checkTheme5_WndFriends",WZUICheckBox)
    local checkTheme7 = GetElement(self.m_root,"checkTheme7_WndFriends",WZUICheckBox)
    local checkTheme8 = GetElement(self.m_root,"checkTheme8_WndFriends",WZUICheckBox)
    local checkTheme9 = GetElement(self.m_root,"checkTheme9_WndFriends",WZUICheckBox)

    checkTheme4_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.85))
    checkTheme2_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
    checkTheme3_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.35))
    checkTheme5_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.1))
    local conCheck1_WndFriends = GetElement(self.m_root, "conCheck1_WndFriends", WZUIContainer)
    conCheck1_WndFriends:setVisible(false)
    local conCheck2_WndFriends = GetElement(self.m_root, "conCheck2_WndFriends", WZUIContainer)
    conCheck2_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
    local conCheck3_WndFriends = GetElement(self.m_root, "conCheck3_WndFriends", WZUIContainer)
    conCheck3_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.35))
    local conCheck4_WndFriends = GetElement(self.m_root, "conCheck4_WndFriends", WZUIContainer)
    conCheck4_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.85))
    local conCheck5_WndFriends = GetElement(self.m_root, "conCheck5_WndFriends", WZUIContainer)
    conCheck5_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.1))

    local conCheck1Sel_WndFriends = GetElement(self.m_root, "conCheckTheme1Sel_WndFriends", WZUIContainer)
    conCheck1Sel_WndFriends:setVisible(false)
    local conCheck2Sel_WndFriends = GetElement(self.m_root, "conCheckTheme2Sel_WndFriends", WZUIContainer)
    conCheck2Sel_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.6))
    local conCheck3Sel_WndFriends = GetElement(self.m_root, "conCheckTheme3Sel_WndFriends", WZUIContainer)
    conCheck3Sel_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.35))
    local conCheck4Sel_WndFriends = GetElement(self.m_root, "conCheckTheme4Sel_WndFriends", WZUIContainer)
    conCheck4Sel_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.85))
    local conCheck5Sel_WndFriends = GetElement(self.m_root, "conCheckTheme5Sel_WndFriends", WZUIContainer)
    conCheck5Sel_WndFriends:setRelativePosition(GlobalMethod:ccp(0.5, 0.1))

    local conCheck7 = GetElement(self.m_root, "conCheck7_WndFriends", WZUIContainer)
    local conCheck8 = GetElement(self.m_root, "conCheck8_WndFriends", WZUIContainer)
    local conCheck9 = GetElement(self.m_root, "conCheck9_WndFriends", WZUIContainer)
    local conCheck7Sel = GetElement(self.m_root, "conCheckTheme7Sel_WndFriends", WZUIContainer)
    local conCheck8Sel = GetElement(self.m_root, "conCheckTheme8Sel_WndFriends", WZUIContainer)
    local conCheck9Sel = GetElement(self.m_root, "conCheckTheme9Sel_WndFriends", WZUIContainer)
    local addPtY = 0
    if not CheckButtonShow(83) then
        checkTheme5_WndFriends:setVisible(false)
        conCheck5_WndFriends:setVisible(false)
        addPtY = addPtY + 1
    end
    if not CheckButtonShow(165) then
        checkTheme7:setVisible(false)
        conCheck7Sel:setVisible(false)
        conCheck7:setVisible(false)
        addPtY = addPtY + 1
    else
        --如果邀请不显示，则黑名单上移
        checkTheme7:setRelativePosition(GlobalMethod:ccp(0.5, 0.1 + addPtY * 0.25))
        conCheck7:setRelativePosition(GlobalMethod:ccp(0.5, 0.1 + addPtY * 0.25))
        conCheck7Sel:setRelativePosition(GlobalMethod:ccp(0.5, 0.1 + addPtY * 0.25))
    end
    if not CheckButtonShow(166) then
        checkTheme8:setVisible(false)
        conCheck8Sel:setVisible(false)
        conCheck8:setVisible(false)
        addPtY = addPtY + 1
    else
        --如果邀请不显示，则黑名单上移
        checkTheme8:setRelativePosition(GlobalMethod:ccp(0.5, -0.15 + addPtY * 0.25))
        conCheck8:setRelativePosition(GlobalMethod:ccp(0.5, -0.15 + addPtY * 0.25))
        conCheck8Sel:setRelativePosition(GlobalMethod:ccp(0.5, -0.15 + addPtY * 0.25))
    end
    
    if not CheckButtonShow(167) then
        checkTheme9:setVisible(false)
        conCheck9Sel:setVisible(false)
        conCheck9:setVisible(false)
    else
        --如果邀请不显示，则黑名单上移
        checkTheme9:setRelativePosition(GlobalMethod:ccp(0.5, -0.4 + addPtY * 0.25))
        conCheck9:setRelativePosition(GlobalMethod:ccp(0.5, -0.4 + addPtY * 0.25))
        conCheck9Sel:setRelativePosition(GlobalMethod:ccp(0.5, -0.4 + addPtY * 0.25))
    end
    --End Add 
    if self.m_nSpecifyCheckIndex then 
        self.m_tAddPhotoData = nil 
        self.m_nNeedUploadPhotoNum = 0
        self.m_nCheckIndex = self.m_nSpecifyCheckIndex
        if self.m_nSpecifyCheckIndex == FRIENDCIRCLE_INDEX then 
            --好友圈
            self:_setCheckBoxSelVisible(false, false, false, false, false, false, true, false, false)
            ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle(2, 0)
        elseif self.m_nSpecifyCheckIndex == HOTCIRCLE_INDEX then 
            --热点圈
            self:_setCheckBoxSelVisible(false, false, false, false, false, false, false, true, false)
            ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle(3, 0)
        elseif self.m_nSpecifyCheckIndex == MYCIRCLE_INDEX then 
            --我的心情
            self:_setCheckBoxSelVisible(false, false, false, false, false, false, false, false, true)
            ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle(1, 0)
        end
        return 
    end
    if CacheCenter.m_nDailyMark == 1 then
        self:_setCheckBoxSelVisible(false, false, true, false, false, false, false, false, false)
        ChangeChatChannel(Chat_Channel_Friends_Info)
        WZLog("有红点，就直接就跳动态::",CacheCenter.m_nDailyMark)
        CacheCenter.m_nDailyMark = 0
        if CacheCenter.m_nDailyMark == 0 then
            CacheCenter:addMark("btnFriend_WndOwnCity",0)
        end
        self:clear()
        self.m_nCheckIndex = ONLINE_INDEX
        self:showDynamicMark(false)
        self:_showButtonByIndex(ONLINE_INDEX)
        self:_showFriendCount(false)
        self:_showRecvGift(true)
        self:_showButton(true,true)
        self:showAppMark(false)
        --每次主动请求获取动态列表
        self.m_bIsSendForUpdate = true
        self.m_nCurPageIndex = 1
        self:createLoading()
        ProtocolProcessorWndFriends:send_FRIEND_Accept( )
    elseif CacheCenter.m_nInviteMark > 0 and checkTheme5_WndFriends:isVisible() then
        self:_setCheckBoxSelVisible(false, true, false, false, false, false, false, false, false)
        checkTheme2_WndFriends:setCheckIndex(1)
        
        self:clear()
        self.m_nCheckIndex = FRIEND_INDEX
        self:_showButtonByIndex(FRIEND_INDEX)
        self:_showRecvGift(false)
        -- self:_showButton(true,false, false)

        self.m_bIsResetFriends = true
        self:createLoading()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriendInfoList( )
    elseif CacheCenter:getFriendCount() > 0 and self.m_nOpenLayerIndex == nil then 
        self:_setCheckBoxSelVisible(false, true, false, false, false, false, false, false, false)
        checkTheme2_WndFriends:setCheckIndex(1)
        
        self:clear()
        self.m_nCheckIndex = FRIEND_INDEX
        self:_showButtonByIndex(FRIEND_INDEX)
        self:_showRecvGift(false)

        self.m_bIsResetFriends = true
        self:createLoading()
        ProtocolProcessorWndFriends:send_FRIEND_GetFriendInfoList( )
	else 
        self:_setCheckBoxSelVisible(false, false, false, true, false, false, false, false, false)
        checkTheme4_WndFriends:setCheckIndex(1)
        self:clear()
        self.m_nCheckIndex = RECOMMEND_INDEX
        self:_showButtonByIndex(RECOMMEND_INDEX) 
        self:_showFriendCount(true)     --显示好友数量
        self:_showRecvGift(false)
        --获取在线玩家列表
        ProtocolProcessorWndFriends:send_FRIEND_OnlinePlayer(2)
        self:createLoading()
	end 
end

function WndFriends:jumpTo(nIndex)
    -- body
    if self.m_root ~= nil then
        return
    end

    local wndFriends = WndFriends:createElement()
    self.m_nOpenLayerIndex = nIndex or 2
    if wndFriends ~= nil then
        WindowManager:addWindow(wndFriends,WndFriends)
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFriends:onExit(element)
	GlobalGame:getBtnRedPointEvent():unregListener("btnTask","WndFriends")
    GlobalGame:getBtnRedPointEvent():unregListener("btnBag","WndFriends")
    if self.m_root then 
        local conMidContent = GetElement(self.m_root,"conMidContent_WndFriends",WZUIContainer)
        conMidContent:disableSchedule()
        
        self.m_root:disableSchedule()
    end
    if self.m_nCountDownScheduleId1 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nCountDownScheduleId1)
        self.m_nCountDownScheduleId1 = nil
    end 
	self:_unInit()
    CCArmatureDataManager:sharedArmatureDataManager():removeAll()
    ProtocolProcessorWndMaster:unregAll1()
    self:unregister()
end

function WndFriends:register()
    GlobalGame:getGameEventDispathcer():Add(FriendEvent.FriendEvent_TeachBox,self._onGetBuyBoxResult,self)
    GlobalGame:getGameEventDispathcer():Add(FriendEvent.FriendEvent_TeachActivityBox,self._onGetActivityBoxInfo,self)
    GlobalGame:getGameEventDispathcer():Add(FriendEvent.FriendEvent_RemoveTeachRelation,self._onRemoveTeachRelationResult,self)
    GlobalGame:getGameEventDispathcer():Add(FriendEvent.CircleOfFriendEvent_SetTop,self._onCircleSetTopResult,self)
end
function WndFriends:unregister()
    GlobalGame:getGameEventDispathcer():Remove(FriendEvent.FriendEvent_TeachBox,self._onGetBuyBoxResult,self)
    GlobalGame:getGameEventDispathcer():Remove(FriendEvent.FriendEvent_TeachActivityBox,self._onGetActivityBoxInfo,self)
    GlobalGame:getGameEventDispathcer():Remove(FriendEvent.FriendEvent_RemoveTeachRelation,self._onRemoveTeachRelationResult,self)
    GlobalGame:getGameEventDispathcer():Remove(FriendEvent.CircleOfFriendEvent_SetTop,self._onCircleSetTopResult,self)
end

--@brief	关闭按钮回调事件
function WndFriends:onCloseClick(element)
	WZLog("关闭按钮回调事件")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    self:exitClose()
end

--@brief	关闭按钮回调事件
function WndFriends:exitClose()
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	窗口动画关闭完成回调
function WndFriends:onDisappearActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	排行按钮回调事件
function WndFriends:onClickRanking(element)
	if self.m_nCheckIndex == RRANK_INDEX then
		return 
	end
    self:_setCheckBoxSelVisible(true, false, false, false, false, false, false, false, false)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	self:clear()
	self.m_nCheckIndex = RRANK_INDEX
	self:_showButtonByIndex(RRANK_INDEX)	
	self:_showFriendCount(true)
	self:_show2ColorTTF("txtNumTitle_WndFriends","txtNum_WndFriends",0)--好友数量
	self:_showRecvGift(false)
	self:_showEmptyTip(0,LocalStrings.FRIENDS_SEND_TIP_3,true)
	self:showAppMark(false)
end

--@brief   	开始按下回调函数
function WndFriends:onBeginTouch(element, pt)	
	WZLog("WndFriends:onBeginTouch")
	local bFlag = WndPopupMenu:ifPointInMenu( pt )--关闭菜单
	if bFlag == false then 
		WndPopupMenu:disappear()
	end 

    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end

    if WndTips.m_root then
        WndTips:onCloseClick()
    end
    if self.m_nCheckIndex == MYCIRCLE_INDEX then 
        local conNotReadList = GetElement(self.m_root, "conNotReadList_WndFriends", WZUIContainer)
        if conNotReadList:isVisible() and not self:checkPointInNewMessageList(pt) then 
            conNotReadList:setVisible(false)
            if self.m_nNewMessageNum > 0 then 
                GetElement(self.m_root, "conNotRead_WndFriends", WZUIContainer):setVisible(true)
            end
        end
    end
    self:checkWhetherHideRewardDrop(pt)

    if self.m_nCheckIndex == INVITE_INDEX then
        if self.m_nCurIndex then
            self:_updateCheckboxGroupIndex()
        end 
    end    
end

function WndFriends:onEndTouch()
    -- body
    if self.m_nCheckIndex == INVITE_INDEX then
        if self.m_nCurIndex then
            self:_updateCheckboxGroupIndex()
        end
    end
end

function WndFriends:checkWhetherHideRewardDrop(pt)
    -- body
    if self.m_root == nil then return end 

    local conRightButtom = GetElement(self.m_root, "conTarget_WndFriends", WZUIContainer)
    local index = 1
    if conRightButtom:isVisible() then 
        index = 2
    end

    if index == 2 then 
        if not self:checkPointInBtn(pt, index) and conRightButtom:isVisible() then 
            conRightButtom:setVisible(false)
        end
    end
end

function WndFriends:checkPointInBtn(pt, index)
    WZLog("WndFriends:checkPoint")
    if self.m_root == nil then return end
    if index == 2 then 
        btn = GetElement(self.m_root, "conTarget_WndFriends", WZUIContainer)
    end
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得btn 世界坐标",ptA.x,ptA.y, ptA.x + btnSize.width, ptA.y + btnSize.height, pt.x, pt.y)
    WZLog("按钮大小",btnSize.width,btnSize.height)
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        WZLog("WndSingleCopy:checkPoint  true")
        return true
    else
        return false
    end 
end

function WndFriends:checkPointInNewMessageList(pt)
    WZLog("WndFriends:checkPointInNewMessageList")
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conNotReadContent_WndFriends", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        WZLog("WndFriends:checkPointInNewMessageList  true")
        return true
    else
        return false
    end 
end

--@brief   	按钮一回调事件
function WndFriends:onBtnOneClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	element = WZUIButton:luaTo(element)
    local tag = element:getTag()
    if tag == RRANK_INDEX then--排行按钮回调 
    elseif tag == FRIEND_INDEX then--审批界面按钮回调
        local wnd = WndOnlineHintFriend:createElement()
        if wnd then
            WindowManager:addWindow(wnd, WndOnlineHintFriend, true)
            local tTempFriend = CacheCenter:getFriendList()
            local tItem = {}
            for i,data in pairs(tTempFriend) do 
                if data.type == 1 then
                    if data.serverId ~= nil then
                        table.insert(tItem,data)
                    end
                end
            end
            local tFriends = CopyTable(tItem)
            WndOnlineHintFriend:setData(tFriends, 1)
        end
    elseif tag == FILTER_LIST then --筛选
        GetElement(self.m_root, "checkboxFilter_WndFriends", WZUICheckBox):setCheckIndex(0)
        self:_resetFriendsList()
    else--动态好友界面按钮回调
        self:onAKeySend(element, self.m_tDynamic, tag)
    end
    
end

--@brief    点击好友置顶按钮回调
function WndFriends:onClickTopFriend(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    element = WZUIButton:luaTo(element)
    local tag = element:getTag()
    if tag == FRIEND_INDEX then
        local wnd = WndOnlineHintFriend:createElement()
        if wnd then
            WindowManager:addWindow(wnd, WndOnlineHintFriend, true)
            local tTempFriend = CacheCenter:getFriendList()
            local tItem = {}
            for i,data in pairs(tTempFriend) do 
                if data.type == 1 then
                    if data.serverId ~= nil then
                        table.insert(tItem,data)
                    end
                end
            end
            local tFriends = CopyTable(tItem)
            WndOnlineHintFriend:setData(tFriends, 4)
        end
    end
end

--@brief   	按钮二回调事件
function WndFriends:onBtnTwoClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	element = WZUIButton:luaTo(element)
	local tag = element:getTag()
	if tag == RRANK_INDEX then--排行按钮回调 
	elseif tag == FRIEND_INDEX then--审批界面按钮回调
        self:onMySpaceClick(element)
    elseif tag == INVITE_INDEX then
        self:onInviteFB()
	else--动态好友界面按钮回调
		self:onAKeyRecv(element)
	end
end

--@brief    邀请Facebook好友
function WndFriends:onInviteFB(  )
    PassportSdkManager:facebookTask("inviteFacebook")
end

--@brief    按钮三回调事件
function WndFriends:onBtnThreeClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndFriendInviteCode:showInterface(CacheCenter:getInviteCodeState())
end

--@brief    添加密友按钮回调
function WndFriends:onBtnFourClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 12 then  
        if CheckButtonOpen(87) then
            local wnd = WndOnlineHintFriend:createElement()
            if wnd then
                WindowManager:addWindow(wnd, WndOnlineHintFriend, true)

                WndOnlineHintFriend:setData(nil, 2)
                WndOnlineHintFriend:setCallBackFunc(WndFriends, self.onAddBestFriend)
            end
        end
    elseif nTag == FILTER_LIST then 
        if self.m_tSelFriends == nil or #self.m_tSelFriends == 0 then 
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_DELETE3)
            return 
        end

        MsgBoxManager:showConfirmBox(LocalStrings.FRIEND_DELETE2, self, self.sureToDeleteAll)
    end
end

--@brief    确认删除好友
function WndFriends:sureToDeleteAll()
    -- body
    local tFriendId = {}
    
    for i = 1, #self.m_tSelFriends do
        table.insert(tFriendId, self.m_tSelFriends[i].id)
    end
    WZLog("WndFriends:sureToDeleteAll", Serialize(tFriends))
    ProtocolProcessorWndFriends:send_FRIEND_DeleteFriend(TableToIntVector(tFriendId))
end

--@brief    添加密友按钮回调
function WndFriends:onAddBestFriend(vector)
    self:createLoading()
    ProtocolProcessorWndFriends:send_FRIEND_AddChum(vector)
end

--@brief    按钮复制回调事件
function WndFriends:onBtnCopyClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
end

--@brief    添加好友按钮回调
function WndFriends:onAddFriend(vector)
    ProtocolProcessorWndFriends:send_FRIEND_AddFriend(vector)
    self:createLoading()
end

--@brief	一键领取
function WndFriends:onAKeyRecv(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local nReveiveUpper = GetReceiveUpper(CacheCenter:getPlayerInfo().vipLevel)
	if self.m_root == nil then
        return
    elseif  self.m_tDynamic == nil or #self.m_tDynamic == 0 then
        WZLog("没有可领取的活力值1")
        MsgBoxManager:showTipBox(self.NO_VATALITY_CAN_GET)
		return
	end
	CacheCenter.m_bOneKeyOperator_Friends = true
	local vector = WZLuaVector_int_:create()
    local isSend = false
	for i,data in pairs(self.m_tDynamic) do
        WZLog("i,id,name,status",i,data.id,data.name,data.status)
        if data.status == 1 and data.typeList == 1 then
            isSend = true
            vector:push(data.id)
        end
	end
    if isSend == false then
        MsgBoxManager:showTipBox(self.NO_VATALITY_CAN_GET)--暂无好友赠送活力
        return
    end
    if tonumber(CacheCenter:getTodayRecvVigor()) >= tonumber(nReveiveUpper) then
        local nMaxVipLevel = GetMaxVipLevel()
        if CacheCenter:getPlayerInfo().vipLevel >= nMaxVipLevel then
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_OVERVIGOR)--今日领取次数已用完
        else
            MsgBoxManager:showConfirmBox(LocalStrings.RECEIVE_TIMES_OUT, self, self.needHigherVipCallBack, nil, nil)
        end
        
        return
    end
    --活力是否已满
    if CacheCenter:getPlayerInfo().vigor + vector:size() * 2 > g_nMaxVigor  then
        MsgBoxManager:showTipBox(LocalStrings.TIPS10)
        return 
    end
	self:createLoading()
    self.m_nOperarorType = 2
	ProtocolProcessorWndFriends:send_FRIEND_Operation(vector,2)--1
end

--@brief	一键赠送
--@param    tFriendList 相应的列表
--@param    nIndex 相应的选项卡
function WndFriends:onAKeySend(element, tFriendList, nIndex)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root == nil then 
        return
    elseif tFriendList == nil or #tFriendList == 0  then
        MsgBoxManager:showTipBox(LocalStrings.FRIEND_NOFRIENDVIGOR)--暂无好友赠送活力
        return 
    end 
    CacheCenter.m_bOneKeyOperator_Friends = true 
    local vector = WZLuaVector_int_:create()
    local isSend = false
    local isGetFisrt = false
    for i,data in pairs(tFriendList) do
        if nIndex == FRIEND_INDEX then
            WZLog("i,id,name,status",i,data.id,data.name,data.status)
            --状态1、可领取，2、可回馈，3、已回馈
            if data.send == true then
                isSend = true
                vector:push(data.id)
            end
        elseif nIndex == ONLINE_INDEX then
            WZLog("i,id,name,status",i,data.id,data.name,data.status, data.typeList)
            --状态1、可回馈，0、已回馈
            if data.sendType == 1 and data.typeList == 1 then
                isSend = true
                vector:push(data.id)
            end
        end
    end
    if isSend == false then
        if nIndex == ONLINE_INDEX then
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_NOFRIENDVIGOR)--领取后再赠送
        else
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_NOFRIENDVIGOR)--暂无好友赠送活力
        end
        return
    end
    self:createLoading()
    self.m_nOperarorType = 1
    ProtocolProcessorWndFriends:send_FRIEND_Operation(vector,1)--2
end

--@brief	好友按钮回调事件
function WndFriends:onClickFriend(element)
	if self.m_nCheckIndex == FRIEND_INDEX then
		return
	end
    local tag =element:getTag()
    -- WZLog("***** WndFriends:onClickFriend *****",self.m_nCheckIndex)
    --ChangeChatChannel(Chat_Channel_Friends_F)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nCheckIndex = GetElement(self.m_root, "checkboxFilter_WndFriends", WZUICheckBox):getCheckIndex()
    WZLog("WndFriends:onClickFriend",self.m_nCheckIndex,nCheckIndex)
    if nCheckIndex == 1 then 
        local tFriend = CacheCenter:getFriendList()
        local tTempFriend = {}
        local curTime = SystemTime:getServerTime()
        if tFriend then
            for i, data in pairs(tFriend) do 
                local nTime = curTime - data.offlineTime
                if data.isOnline ~= 1 and nTime >= 30 * 24 * 3600 then
                    table.insert(tTempFriend, data)
                end
            end
        end
        
        if #tTempFriend == 0 then
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_DELETE4)
            GetElement(self.m_root, "checkboxFilter_WndFriends", WZUICheckBox):setCheckIndex(0)
            return 
        end

        self:_setCheckBoxSelVisible(false, true, false, false, false, false, false, false, false)
        
        self:clear()
        self.m_nCheckIndex = tag
        self:_showRecvGift(false)
        -- self:_showButton(true, false, true)

        self:_showFriendCount(true)     --显示好友数量
        self.m_bIsFilterFriend = true
        self.m_tFriend = tTempFriend
        self.m_nCurPageIndex = 1
        self.m_nFriendsTableIndex = 0
        local tbconFriend = self:getCurUsingTableContainer()
        tbconFriend:cleanTable()
        self:_sortFriendListType()--排序类型    
        self:_updateFriend()
        self:_updateModel()
        self:_showButtonByIndex(FILTER_LIST)
    else
        self:_resetFriendsList()
        self:_updateModel()
    end
end

--@brief    显示密友模型
function WndFriends:_updateModel(  )
    local conModel = GetElement(self.m_root,"conModels_WndFriends",WZUIContainer)
    conModel:setVisible(true)
    local bestFriendData = CacheCenter:getBestFriendData()
    WZLog("密友数据",#bestFriendData)
    self.m_tBestFriendsCell = {}
    if bestFriendData and next(bestFriendData) then
        for i = 1,#bestFriendData do
            local model = GetElement(conModel,"model" .. i,WZUIContainer)
            if model:getChildByTag(i-1) then
                model:removeChildByTag(i-1,true)
            end
            WZLog("i的值=",i)
            GetElement(conModel,"btnAdd" .. i,WZUIButton):setVisible(false)
            local celElement,tCell = CellFriendModel:createElement()
            if celElement ~= nil and tCell ~= nil then 
                celElement:setTag(i-1)    --从0开始设置Tag值
                tCell:setData(bestFriendData[i])
                tCell.m_tParentWnd = self
                model:addChild(celElement)

                table.insert(self.m_tBestFriendsCell, {tCell, celElement, i})
            end 
        end            
    end
end

--@brief    查找回调
function WndFriends:onFind(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editFind = WZUIEditBox:luaTo(self.m_root:getChildElement("editFind_WndFriends"))
    local desc = editFind:getText()
    WZLog("desc===",desc)
    if desc == nil then
        MsgBoxManager:showTipBox(self.PLEASE_INPUT_ID_FIRST)
        return
    end
    if tonumber(desc) == nil then
        MsgBoxManager:showTipBox(self.ID_MUST_BE_NUMBER)
        return
    end
    
    ProtocolProcessorWndFriends:send_FRIEND_SearchFriend(tonumber(desc),"")
end

--@brief    输入完成回调
function WndFriends:onFinishInput(element)
    -- body
    element = WZUIEditBox:luaTo(element)
    local txt = element:getText()
    if txt ~= nil and txt ~= "" then
        GetElement(self.m_root, "btnCancelFind_WndFriends", WZUIButton):setVisible(true)
        --限制数量
        local nInputTextLen = WndBag:_checkInputTxtLen(txt)
        if nInputTextLen > 12 then
            local nTempEndIndex = 6
            local tempTxt = string.sub(txt, 1, nTempEndIndex)
            local nTempLen = WndBag:_checkInputTxtLen(tempTxt)
            while nTempLen < 12 do
                nTempEndIndex = nTempEndIndex + 1
                local tempTxt1 = string.sub(txt, 1, nTempEndIndex)
                nTempLen = WndBag:_checkInputTxtLen(tempTxt1)
                if nTempLen <= 12 then
                    tempTxt = tempTxt1
                end
            end
            element:setText(tempTxt)
        end
    else
        GetElement(self.m_root, "btnCancelFind_WndFriends", WZUIButton):setVisible(false)
    end
end

--@brief    关键字查找好友
function WndFriends:onFriendFind(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local editFriendFind = GetElement(self.m_root, "editFriendFind_WndFriends", WZUIEditBox)
    local sTempContent = editFriendFind:getText()
    if sTempContent == nil or sTempContent == "" or sTempContent == " " then
        MsgBoxManager:showTipBox(LocalStrings.INPUTRECT_NULL_ATT)
        return 
    end
    --查找是否有好友信息
    local tFriend = CacheCenter:getFriendList()
    local tTempFriend = {}
    if tFriend then
        for i,data in pairs(tFriend) do 
            if data.type == 1 then
                local nStartName = string.find(data.name, sTempContent)
                local nStartId = string.find(data.id, sTempContent)
                if nStartId or nStartName then
                    table.insert(tTempFriend, data)
                end
            end
        end
    end
    
    if #tTempFriend == 0 then
        MsgBoxManager:showTipBox(LocalStrings.SEARCH_NO_RESULT)
        return 
    end

    self.m_bIsFindFriend = true
    self.m_tFriend = tTempFriend
    self.m_nCurPageIndex = 1
    self.m_nFriendsTableIndex = 0
    local tbconFriend = self:getCurUsingTableContainer()
    tbconFriend:cleanTable()
    self:_sortFriendListType()--排序类型    
    self:_updateFriend()
end

--@brief    取消查找
function WndFriends:onCancelFind(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --清楚查找框的内容
    GetElement(self.m_root, "editFriendFind_WndFriends", WZUIEditBox):setText("")
    GetElement(self.m_root, "btnCancelFind_WndFriends", WZUIButton):setVisible(false)
    --刷新列表
    if self.m_bIsFindFriend then
        local tbconFriend = self:getCurUsingTableContainer()
        tbconFriend:cleanTable()
        self.m_bIsFindFriend = false
        self:setFriendData(CacheCenter:getFriendList())
    end
end

--查找玩家
function WndFriends:onFindSuc(playerId)
    if self.m_root == nil then
        return
    end
    WndCheckOther:show(playerId)
end

--@brief    领取邀请码任务奖励
function WndFriends:onRevReward(taskId)
    -- body
    WZLog("WndFriends:onRevReward")
    self:createLoading()
    ProtocolProcessorWndFriends:send_INVITE_GetInviteRewards(taskId)
end

--@brief    添加返回后重新获取刷新推荐列表
function WndFriends:WndAddFriendSuc()
    --body
    if self.m_root == nil then
        return
    end
    if self.m_nCheckIndex ~= RECOMMEND_INDEX then return end
    WZLog("********* WndFriends:WndAddFriendSuc **********")
    self:closeLoading()
    ProtocolProcessorWndFriends:send_FRIEND_OnlinePlayer(2)
    self:createLoading()
end

function WndFriends:_DoEventOnBtnFriend(  )
	self:clear()
	self.m_nCheckIndex = FRIEND_INDEX
	self:_showButtonByIndex(FRIEND_INDEX)
	self:_showRecvGift(false)
	self:_showButton(true,false, true)
	if CacheCenter:getFriendList() == nil then 
        self.m_tFriend = nil 
        self:_showEmptyTip(0,LocalStrings.EMPTYFRIENDTIP1,true)
        return 
    end
	if #CacheCenter:getFriendList() > 0 then 
		local conFriendList_WndFriends = GetElement(self.m_root,"conFriendList_WndFriends",WZUIContainer)
		removeShowPanelNullTip(conFriendList_WndFriends)
	end
	self:setFriendData(CacheCenter:getFriendList())
	self:_showFriendCount(true)
	self:_showFriendNum()
end

--@brief	好友动态按钮回调事件
function WndFriends:onClickOnline(element)
	if self.m_nCheckIndex == ONLINE_INDEX then
		return 
	end
    self:_setCheckBoxSelVisible(false, false, true, false, false, false, false, false, false)
    local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriendCD_WndFriends"))
    tbconFriend:setVisible(true)
	ChangeChatChannel(Chat_Channel_Friends_Info)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("好友动态按钮回调事件::",CacheCenter.m_nDailyMark)
	CacheCenter.m_nDailyMark = 0
	if CacheCenter.m_nDailyMark == 0 then
		CacheCenter:addMark("btnFriend_WndOwnCity",0)
	end
	self:clear()
	self.m_nCheckIndex = ONLINE_INDEX
	self:showDynamicMark(false)
	self:_showButtonByIndex(ONLINE_INDEX)
	self:_showFriendCount(false)
	self:_showRecvGift(true)
	self:_showButton(true,true)
    self:showAppMark(false)
    --每次主动请求获取动态列表
    self.m_bIsSendForUpdate = true
    self.m_nCurPageIndex = 1
    self:createLoading()
    ProtocolProcessorWndFriends:send_FRIEND_Accept( )
end

--@brief    点击推荐按钮回调
function WndFriends:onClickRecommend( element )
    -- body
    if self.m_nCheckIndex == RECOMMEND_INDEX then
        return 
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    self:_setCheckBoxSelVisible(false, false, false, true, false, false, false, false, false)
    ChangeChatChannel(Chat_Channel_Friends_Add)

    local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriendCD_WndFriends"))
    tbconFriend:setVisible(true)
    tbconFriend:cleanTable()

    self:clear()
    self.m_nCheckIndex = RECOMMEND_INDEX
    self:_showButtonByIndex(RECOMMEND_INDEX)
    self:_showFriendCount(true)     --显示好友数量
    self:_showRecvGift(false)
    --获取在线玩家列表
    ProtocolProcessorWndFriends:send_FRIEND_OnlinePlayer(2)
    self:createLoading()
end

--@brief    点击师徒按钮回调
function WndFriends:onClickInvite( element )
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local day = tonumber(CacheCenter:getGameParam().openDays)
    local openDay = CacheCenter:getGameParam().openMentoring and tonumber(CacheCenter:getGameParam().openMentoring) or 4
    if day >= openDay then
        if not CheckButtonOpen(ISLAND_NPC_TEACHER) then return end 
        ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
    else
        MsgBoxManager:showTipBox(string.format(LocalStrings.MASTEROPENTIPS,openDay-day))
        return
    end
    self.m_nCheckIndex = INVITE_INDEX
    self:updateMasterContent()
    self:setMasterTagerRedPoint()
    self:setDisCipleRedPoint()
    self:setMyDiscipleRedPoint()
end

--@brief    
function WndFriends:onClickInviteFinish(element)
    -- body
    local tag = element:getTag()
    if tag == 5 then
        if not CheckButtonOpen(ISLAND_NPC_TEACHER) then
            GetElement(self.m_root, "checkGroup_WndFriends", WZUICheckBoxGroup):setCheckIndex(self:getCheckIndexByType(self.m_nCheckIndex)) 
            return 
        end   
    end  
end

--@brief    刷新师徒
function WndFriends:updateMasterContent(  )
    -- body
    self:_setCheckBoxSelVisible(false, false, false, false, true, false, false, false, false)
    local checkTheme2_WndFriends = GetElement(self.m_root,"checkTheme2_WndFriends",WZUICheckBox)
    checkTheme2_WndFriends:setCheckIndex(0)
    GetElement(self.m_root,"conMidContent_WndFriends",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"imgMidBg_WndFriends",WZUI9Image):setVisible(false)
    local conMaster = GetElement(self.m_root,"conMaster_WndFriends",WZUIContainer)
    conMaster:setVisible(true)
    self.m_nCurIndex = 1
    self:_updateCheckboxGroupIndex()

    self:_changeWndowByCurIndex()   
end

--@brief    更新CheckboxGroup选中标签
function WndFriends:_updateCheckboxGroupIndex()
    WZLog("更新CheckboxGroup选中标签",self.m_nCurIndex)
    GetElement(self.m_root, "checkGroup_WndMaster", WZUICheckBoxGroup):setCheckIndex(self.m_nCurIndex-1)
end
--师徒目标的红点
function WndFriends:setMasterTagerRedPoint()
    if not self.m_root then return end
    local hasTarget = GetElement(self.m_root,"hasTarget_WndMaster",WZUIImage)
    local visible = GlobalGame.g_tRedPointTypeList[300]
    hasTarget:setVisible(visible)
end
--徒弟购买宝箱
function WndFriends:setDisCipleRedPoint()
    if not self.m_root then return end

    local hasTarget = GetElement(self.m_root,"hasBox_WndMaster",WZUIImage)
    local visible = GlobalGame.g_tRedPointTypeList[301]
    hasTarget:setVisible(visible)
end
--我的徒弟宝箱是否可领取
function WndFriends:setMyDiscipleRedPoint()
    if not self.m_root then return end

    local discipleBox = GetElement(self.m_root,"discipleBox_WndMaster",WZUIImage)
    local visible = GlobalGame.g_tRedPointTypeList[302]
    discipleBox:setVisible(visible)
end
--@biref    根据当前索引打开相应界面
--@note     根据当前索引打开相应界面
function WndFriends:_changeWndowByCurIndex()
    --窗口默认不可见，清空玩家窗口设置

    if self.m_tHallElement ~= nil then
        self.m_tHallElement:setVisible(false)
    end
    if self.m_tMemberElement ~= nil then
        self.m_tMemberElement:setVisible(false)
    end
    if self.m_tRewardElement ~= nil then
        self.m_tRewardElement:setVisible(false)
    end
    if self.m_tLogElement ~= nil then
        self.m_tLogElement:setVisible(false)
    end
    if self.m_tTarget ~= nil then
        self.m_tTarget:setVisible(false)
    end
    if self.m_sDisciple ~= nil then
        self.m_sDisciple:setVisible(false)
    end
    
    local playerInfo = CacheCenter:getPlayerInfo()
    local masterInfo = CacheCenter:getMasterInfo()
--    WZLog("师徒数据",Serialize(masterInfo))
    if masterInfo == nil or playerInfo == nil then return end
    --是否显示消息提示
    if masterInfo.message == true then
        GetElement(self.m_root, "hasMessage_WndMaster", WZUIImage):setVisible(true)
    else
        GetElement(self.m_root, "hasMessage_WndMaster", WZUIImage):setVisible(false)
    end
    --切换到师徒大厅
    if 1 == self.m_nCurIndex then
        WZLog("WndFriends:_changeWndowByCurIndex",self.m_nCurIndex)
        if self.m_tHallElement == nil then
            self.m_tHallElement = WndMasterHall:createElement()
            local conCurWindow = GetElement(self.m_root,"conMaster_WndFriends",WZUIContainer)
            conCurWindow:addChild(self.m_tHallElement)
        end
        self.m_tHallElement:setVisible(true)
    --切换到师父界面
    elseif 2 == self.m_nCurIndex then
        if self.m_tMemberElement == nil then
            self.m_tMemberElement = WndMasterMember1:createElement(1)
            local conCurWindow = GetElement(self.m_root,"conMaster_WndFriends",WZUIContainer)
            conCurWindow:addChild(self.m_tMemberElement)
            if masterInfo.hasMaster == true then
                ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster()
            else
                WndMasterMember1:setNotMasterTips(true)
            end
        end
        WndMasterMember1:setSceneType()
        self.m_tMemberElement:setVisible(true)
    --切换到师徒奖励
    elseif 3 == self.m_nCurIndex then
        if self.m_tRewardElement ~= nil then
            self.m_tRewardElement:removeFromParentAndCleanup(true)
            self.m_tRewardElement = nil
        end
        if self.m_tRewardElement == nil then
            self.m_tRewardElement = WndMasterReward:createElement()
            local conCurWindow = self.m_root:getChildElement("conMaster_WndFriends")
            conCurWindow:addChild(self.m_tRewardElement)
        end
        self.m_tRewardElement:setVisible(true)
    --切换到师徒消息
    elseif 4 == self.m_nCurIndex then
        if self.m_tLogElement == nil then
            self.m_tLogElement = WndMasterLog:createElement()
            local conCurWindow = self.m_root:getChildElement("conMaster_WndFriends")
            conCurWindow:addChild(self.m_tLogElement)
        end
        self.m_tLogElement:setVisible(true)
        --获得消息列表
        ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage()
    --切换到徒弟
    elseif 5 == self.m_nCurIndex then
        if self.m_sDisciple == nil then
            self.m_sDisciple = WndMasterMember:createElement(2)
            local conCurWindow = GetElement(self.m_root,"conMaster_WndFriends",WZUIContainer)
            conCurWindow:addChild(self.m_sDisciple)
            ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils()
        end
        WndMasterMember:setSceneType()
        self.m_sDisciple:setVisible(true)
    end
end

--师徒界面的时候
function WndFriends:onCheckMaster(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = 1
    if type(element) == "number" then
        tag = element
    else
        tag = element:getTag()
    end
    if tag == self.m_nCurIndex then return end
    self.m_nCurIndex = tag
    --更新界面
    self:_changeWndowByCurIndex()
end
--师徒目标
function WndFriends:onBtnClickMasterTager(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_tTarget ~= nil then
        self.m_tTarget:removeFromParentAndCleanup(true)
        self.m_tTarget = nil
    end
    if self.m_tTarget == nil then
        self.m_tTarget = WndMasterTask:createElement()
        local conCurWindow = self.m_root:getChildElement("conTarget_WndFriends")
        conCurWindow:setVisible(true)
        conCurWindow:addChild(self.m_tTarget)
    end
    self.m_tTarget:setVisible(true)
end
--师徒宝箱
function WndFriends:onBtnClickMasterBox(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local masterInfo = CacheCenter:getMasterInfo()
    if masterInfo and masterInfo.hasMaster == true then
        ProtocolProcessorWndMaster:send_MENTORING_GetMyBagInfo()
    else
        MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT71)
    end
end
--是否存在购买宝箱行为
function WndFriends:_onGetBuyBoxResult(bagType)
    if bagType == -2 then
        MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT72)
    elseif bagType == 0 then --购买宝箱
        WndMasterBuyBox:showInterface()
    elseif bagType == 1 or bagType == 2 or bagType == 3 then
        ProtocolProcessorWndMaster:send_MENTORING_GetBagInfo(0)
    end
end
--查看宝箱的活跃度
function WndFriends:_onGetActivityBoxInfo(playerId, progress, bagType, status)
    --本人的时候
    if playerId == 0 then
        WndMasterBoxActivity:showInterface(progress, bagType, status)
    end
end
--解除关系
function WndFriends:_onRemoveTeachRelationResult()
    --返回师徒大厅
    self:onCheckMaster(1)
    self.m_tMemberElement = nil
end


--@brief    点击邀请按钮回调
function WndFriends:onClickInveit( element )
    -- body
    self.m_nCurPageIndex = 1 
    self.m_nCurTag = 0
    self.m_nInviteFriend = 0 
    SoundManager:playEffectSound(SoundManager.E_S_CLICK_BTN2)
    self:createLoading()
    ProtocolProcessorWndFriends:send_INVITE_RequestInviteInfoList( )    
end


--@brief    点击返回好友按钮
function WndFriends:onClickBackFriends( element )
    -- body
    SoundManager:playEffectSound(SoundManager.E_S_CLICK_BTN2)

    GetElement(self.m_root,"conInventBg_WndFriend",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conInvite_WndFriends",WZUIContainer):setVisible(false)    
end


--@brief    点击分享按钮
function WndFriends:onClickShare( element )
    -- body
    SoundManager:playEffectSound(SoundManager.E_S_CLICK_BTN2)
    WZLog("点击分享邀请码按钮")
    if CacheCenter:getPlayerItemCountById(114) > 0 then
        GetElement(self.m_root,"btnShare_WndFriends",WZUIButton):setTouchEnable(false)
        -- GetElement(self.m_root,"imgShare_WndFriends",WZUI9Image):setGrayRender(true)
        self.btnTxt = GetElement(self.m_root,"txtShared_WndFriends",WZUILabelTTF)
        self.btnTxt:setText("30s")
        self.btnTime = 30
        self.btnTxt:enableSchedule("_btnTime",1)
        local sendTxt = string.format(LocalStrings.MY_INVITE_CODE .. self.m_sMyInviteCode)
        ProtocolProcessorGlobal:send_CHAT_SendMessage(6,0,sendTxt,0,0)
        WndChat:sendChatByChannel(CHANNEL_WORLD,sendTxt,{})
    else 
        MsgBoxManager:showConfirmBox(LocalStrings.CHAT_NOLABA,self,self.clickSureBack)
    end

end

function WndFriends:_btnTime()
    -- body
    self.btnTime = self.btnTime - 1
    self.btnTxt:setText(self.btnTime.."s")
    if self.btnTime == 0 then
        self.btnTime = nil
        self.btnTxt:disableSchedule()
        GetElement(self.m_root,"txtShared_WndFriends",WZUILabelTTF):setText(LocalStrings.SHARE)
        GetElement(self.m_root,"btnShare_WndFriends",WZUIButton):setTouchEnable(true)
        -- GetElement(self.m_root,"imgShare_WndFriends",WZUI9Image):setGrayRender(false)
    end
end

--@brief 世界喇叭不足购买世界喇叭
function WndFriends:clickSureBack(nId,nType)
    if nType == MSGBOXRESTYPE_CONFIRM then
        self.m_nOrder = self.m_root:getZOrder()
        WndPurchase:showBuyInterface(6,114,nil,nil,nil,self.m_nOrder)
    end
end

--@brief    点击黑名单按钮回调
function WndFriends:onClickBlacklist(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    WndFriendBlackList:showInterface()
end

--@brief	显示好友列表
function WndFriends:onShowFriend(element, delta)
	if self.m_root == nil or self.m_tFriend == nil then
		return
	end

	local tbconFriend = WZUITableContainer:luaTo(element)
    tbconFriend:cleanTable()
--    WZLog("WndFriends:onShowFriend",self.m_nCurNeedLoadNum,self.m_nCurLoadIndex,Serialize(self.m_tFriend))
    for i = 1, self.m_nCurNeedLoadNum do
        if self.m_tFriend[self.m_nCurLoadIndex] and self.m_tFriend[self.m_nCurLoadIndex].bBestFriend ~= 1 then
        	local celElement, tCell = CellFriends:createElement()
        	celElement:setTag(self.m_nCurTag)
        	tbconFriend:setCellElement(celElement)
        	tCell:setBackFun(self,self.onFriendClick,self.onSendClick)
            if self.m_bIsFilterFriend then 
                tCell:setCellData(self.m_tFriend[self.m_nCurLoadIndex], FILTER_LIST)
                local nSelState = self:getFriendsSelState(self.m_tFriend[self.m_nCurLoadIndex].id)
                if nSelState == 1 then 
                    tCell:setOneCheckboxState(nSelState)
                end
            else
        	    tCell:setCellData(self.m_tFriend[self.m_nCurLoadIndex], self.m_nCheckIndex) 
            end
            self.m_nCurTag = self.m_nCurTag + 1
        end
        self.m_nFriendsTableIndex = self.m_nFriendsTableIndex + 1
        self.m_nCurLoadIndex = self.m_nCurLoadIndex + 1
    end

    if self.m_nCleanPositionY then
        tbconFriend:getMoveElement():setPositionY(self.m_nCleanPositionY)
        self.m_nCleanPositionY = nil
    else
        tbconFriend:getMoveElement():setPositionY(tbconFriend:getMinPosition().y)
    end

    self:_setLoadMoreVisible(self.m_tFriend, self.m_nFriendsTableIndex)
end

--@brief    显示推荐列表
function WndFriends:onShowRecommend(element)
    if self.m_root == nil or self.m_tRecommend == nil then
        return
    end

    local tbcon = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriendCD_WndFriends"))
    for i=1, #self.m_tRecommend do 
        self.m_nRecommend = self.m_nRecommend + 1
        local celElement , tCell = CellFriends:createElement()
        celElement:setTag(self.m_nRecommend - 1)
        tbcon:setCellElement(celElement)
        tCell:setCellData(self.m_tRecommend[self.m_nRecommend], self.m_nCheckIndex)

        self.m_nIndex = self.m_nIndex + 1
    end
    tbcon:getMoveElement():setPositionY(tbcon:getMinPosition().y)
end

--@brief    显示邀请列表
function WndFriends:onShowInvite()
    -- body
    if self.m_root == nil then
        return 
    end
    GetElement(self.m_root,"conInventBg_WndFriend",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"conInvite_WndFriends",WZUIContainer):setVisible(true)
    -- GetElement(self.m_root,"imgShare_WndFriends",WZUI9Image):setGrayRender(false)
    GetElement(self.m_root,"txtShared_WndFriends",WZUILabelTTF):setText(LocalStrings.SHARE)
    if self.m_sMyInviteCode then
        local txtInventNum = GetElement(self.m_root,"txtInventNum_WndFriends",WZUILabelTTF)
        txtInventNum:setText(self.m_sMyInviteCode)
    end
    --我的邀请码
    if self.m_sMyInviteCode then
        local sCodeFormat = [[<T C="229,105,22" S="24" P="1">%s</T><T C="127,70,26" S="24" P="1">%s</T>]]
        local txtFreeMyCode = GetElement(self.m_root, "txtFreeMyCode_WndFriends", WZUIFreeTextBox)
        txtFreeMyCode:setShowText(string.format(sCodeFormat, LocalStrings.MY_INVITE_CODE, self.m_sMyInviteCode))
    end

    self:_updateInviteFriends()
    self:_updateInviteTask()
end



--@brief    查看玩家信息
function WndFriends:onPlayerInfo(tCell, tag, tData)
    -- body
    WndCheckOther:show(tData.id)
end

--赠送回调
function WndFriends:onSendClick(tCell,tag,tData)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 	WZLog("WndFriends:onSendClick(tCell,tag,tData)")
 	local tbconFriend = self:getCurUsingTableContainer()
 	self.m_nCurrentRowIndex = tbconFriend:getCurrentRowIndex()
	local vector = WZLuaVector_int_:create()
	vector:push(tData.id)
	self:createLoading()
	WZLog("赠送回调::",tData.id,1)
    self.m_nOperarorType = 1
	ProtocolProcessorWndFriends:send_FRIEND_Operation(vector, 1)
end

--@brief	好友点击回调
function WndFriends:onFriendClick(tCell,tag,tData)
	WZLog("WndFriends:onFriendClick():::", tData.id)
    if self.m_tClickFriendData == nil then
        self.m_tClickFriendData = {}
    end
    self.m_tClickFriendData.id = tData.id
    self.m_tClickFriendData.name = tData.name

	self.m_nFriendTag = self:_getFriendTag(self.m_tFriend, tData)
end

--@brief	好友动态列表
function WndFriends:onShowDynamic(element)
    if self.m_root == nil then
        return
    end

    element = WZUITableContainer:luaTo(element)
    element:cleanTable()

    for i=1, self.m_nCurNeedLoadNum do 
        if self.m_tDynamic[self.m_nCurLoadIndex] ~= nil then
            local celElement , tCell = CellDynamic:createElement()
            celElement:setTag(self.m_nCurTag)
            element:setCellElement(celElement)
            tCell:setBackFun(self,self.onRecvClick,self.onBackSend,self.onSure, self.onRefuse)
            tCell:setCellData(self.m_tDynamic[self.m_nCurLoadIndex])
        end

        self.m_nCurLoadIndex = self.m_nCurLoadIndex + 1
        self.m_nCurTag = self.m_nCurTag + 1
        self.m_nDynamic = self.m_nDynamic + 1
    end

    if self.m_nCleanPositionY then
        local tCurSize = element:getMoveElement():getContentSize()
        element:getMoveElement():setPositionY(self.m_nCleanPositionY - (tCurSize.height - self.m_nLastMoveElementHeight)/2)
        self.m_nCleanPositionY = nil 
        self.m_nLastMoveElementHeight = nil 
    else
        element:getMoveElement():setPositionY(element:getMinPosition().y)
    end

    self:_setLoadMoreVisible(self.m_tDynamic, self.m_nDynamic)
end

--@brief	领取活力回调事件
function WndFriends:onRecvClick(tCell,tag,tDynamic)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndFriends:onRecvClick")
    local nReveiveUpper = GetReceiveUpper(CacheCenter:getPlayerInfo().vipLevel)
	if tonumber(CacheCenter:getTodayRecvVigor()) >= tonumber(nReveiveUpper) then
        local nMaxVipLevel = GetMaxVipLevel()
        if CacheCenter:getPlayerInfo().vipLevel >= nMaxVipLevel then
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_OVERVIGOR)--今日领取次数已用完
        else
            MsgBoxManager:showConfirmBox(LocalStrings.RECEIVE_TIMES_OUT, self, self.needHigherVipCallBack, nil, nil)
        end
		return
	end
    
    if CacheCenter:getPlayerInfo().vigor + 2 >= g_nMaxVigor  then
        MsgBoxManager:showTipBox(LocalStrings.TIPS10)
        return 
    end

    self.m_tClickDynamic = tDynamic
    self.m_tClickedCell = tCell
	local vector = WZLuaVector_int_:create()
	vector:push(tDynamic.id)
	self:createLoading()
	WZLog("WndFriends:onRecvClick",tDynamic.id,2)
    self.m_nOperarorType = 2
	ProtocolProcessorWndFriends:send_FRIEND_Operation(vector,2)
end

--@brief	赠送活力回调
function WndFriends:onBackSend(tCell,tag,tDynamic, element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local vector = WZLuaVector_int_:create()

    -- local conFriendList = GetElement(self.m_root, "conFriendList_WndFriends", WZUIContainer)
    -- local tbconFriend = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconFriend_WndFriends"))
    -- local nTempX = element:getPositionX()
    -- local nTempY = element:getPositionY()
    -- local www = element:convertToWorldSpace(GlobalMethod:ccp(0, nTempY))
    -- local ttt = conFriendList:convertToNodeSpace(www)
    -- local ttt222 = tbconFriend:getMoveElement():convertToNodeSpace(www)
    -- local yyy = tbconFriend:getMoveElement():getPositionY()
    -- local hhhh = tbconFriend:getMoveElement():getContentSize()

    -- self.m_nCleanPositionY = yyy - 58
    -- local tempTT = self.m_tDynamic[3]
    -- table.insert(self.m_tDynamic,3,tempTT)
    -- WZLog("WndFriends:onBackSend", nTempX, nTempY, ttt.x, ttt.y,ttt222.x, ttt222.y, www.x, www.y, yyy)
    -- self:addNewCell(tbconFriend)
    -- do return end
    self.m_tClickDynamic = tDynamic
    self.m_tClickedCell = tCell
	vector:push(tDynamic.id)
	WZLog("WndFriends:onBackSend",tDynamic.id,1)
    self.m_nOperarorType = 1
	ProtocolProcessorWndFriends:send_FRIEND_Operation(vector,1)
	self:createLoading()
end

--@brief    测试用测试用
function WndFriends:addNewCell(tbconFriend)
    -- body
    self.m_nDynamic = 0
    self.m_nCurNeedLoadNum =  #self.m_tDynamic
    self.m_nCurLoadIndex = 1
    self.m_nPageUporDownIndex = 0           
    self.m_nCurTag = 0 
    self:onShowDynamic(tbconFriend)
end

--@brief   	删除好友二次确认框
--@param	#1 nId:消息ID
--@param	#2 nType:回调函数返回值类型,1：确定，2：关闭
function WndFriends:onSureDelFriend(nId , nType)	
	WZLog("WndFriends:onSureDelFriend")
	if tonumber(nType) == 2 then
		WZLog("WndFriends:onSureDelFriend type = 2")
		return
	end
	self:_delFriend()
end

function WndFriends:showDynamicMark(bShow)
	if self.m_root == nil then
		return
	end
    WZLog("****** WndFriends:showDynamicMark *****", bShow)
	if self.m_nCheckIndex == ONLINE_INDEX or CacheCenter:getDynamicFriendList() == nil or #CacheCenter:getDynamicFriendList() == 0 then 
		bShow = false
	end
	local conMark = WZUIContainer:luaTo(self.m_root:getChildElement("conDynamicMark_WndFriends"))
	conMark:setVisible(bShow)
end

function WndFriends:showFriendsMark( bShow )
	if self.m_root == nil then
		return
	end
	local conFriendsMark = WZUIContainer:luaTo(self.m_root:getChildElement("conFriendsMark_WndFriends"))
	conFriendsMark:setVisible(bShow)
    GetElement(self.m_root,"redDotInvent_WndFriends",WZUIImage):setVisible(bShow)
end


function WndFriends:showAppMark(bShow)
	if self.m_root == nil then
		return
	end
	if self.m_nCheckIndex ~= FRIEND_INDEX then
		bShow = false
	end
	local conMark = WZUIContainer:luaTo(self.m_root:getChildElement("conAppMark_WndFriends"))
	conMark:setVisible(bShow)
end

--@brief    我的心情红点
function WndFriends:showMyCircleMark(bShow)
    if self.m_root == nil then
        return
    end
    
    local conMark = WZUIContainer:luaTo(self.m_root:getChildElement("conMyCircleMark_WndFriends"))
    conMark:setVisible(bShow)
end

function WndFriends:needHigherVipCallBack(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

function WndFriends:updateFriendsNum()
    -- body
    if self.m_root ~= nil then
        if self.m_nCheckIndex == ONLINE_INDEX then
            self:_show2ColorTTF("txtRecvTitle_WndFriends","txtRecvNum_WndFriends",self:_getTodayRecv())
        --    self:_showFriendNum()
        elseif self.m_nCheckIndex == INVITE_INDEX then
            
        else
            self:_showFriendNum()
        end
    end
end

--@brief  我 的空间按钮回调
function WndFriends:onMySpaceClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSpaceMain:show(CacheCenter:getPlayerInfo().id)
end

--@brief    点击好友空间按钮回调
--@param    friendId:好友的Id
function WndFriends:onClickSpace(tCell, friendId)
    -- body
    if self.m_nCheckIndex == FRIEND_INDEX then 
        for i = 1, #self.m_tFriend do
            if self.m_tFriend[i].id == friendId then
                self.m_tFriend[i].spaceVisitState = 1
                tCell:setSpaceVisitState(self.m_tFriend[i].spaceVisitState)
                break 
            end
        end
    end
end

function WndFriends:onSure(friendId, tCell, typeList)
    local vector = WZLuaVector_int_:create()
    vector:push(friendId)
    self.m_tClickedCell = tCell 
    if typeList == 4 then
        local nFriendCount  = CacheCenter:getFriendCount()
        
        local nMaxFriendsNum = GetMaxFriends(CacheCenter:getPlayerInfo().vipLevel)
        if nFriendCount >= nMaxFriendsNum then
            local nMaxVipLevel = GetMaxVipLevel()
            if CacheCenter:getPlayerInfo().vipLevel >= nMaxVipLevel then
                MsgBoxManager:showTipBox(LocalStrings.FRIEND_MAX)
            else
                MsgBoxManager:showConfirmBox(LocalStrings.FRIENDS_FULL_ATT, self, self.needHigherVipCallBack, nil, nil)
            end
            return
        end
        ProtocolProcessorWndFriends:send_FRIEND_Approve(vector,1)   
    elseif typeList == 7 then
        ProtocolProcessorWndFriends:send_FRIEND_ApproveChum(friendId, 1)
    elseif typeList == 9 then --同意双修
        ProtocolProcessorWndFriends:send_FRIENTD_ApproveShuangXiu(friendId, 1)
    end
    self:createLoading()    
end

function WndFriends:onRefuse(friendId, tCell, typeList)
    local vector = WZLuaVector_int_:create()
    vector:push(friendId)
    self.m_tClickedCell = tCell 
    if typeList == 4 then
        ProtocolProcessorWndFriends:send_FRIEND_Approve(vector,2)
    elseif typeList == 7 then
        ProtocolProcessorWndFriends:send_FRIEND_ApproveChum(friendId, 2)
    elseif typeList == 9 then --拒绝双修
        ProtocolProcessorWndFriends:send_FRIENTD_ApproveShuangXiu(friendId, 2)
    end
    self:createLoading()
end

--@brief    领取和赠送活力操作反馈
function WndFriends:showResultForOperator(vigorNum, playerId)
    -- body
    if WndFriends.m_root == nil then return end
    local bHaveRelation = false
    if playerId:size() == 1 then
        bHaveRelation = CacheCenter:judgeWhetherHaveRelation(playerId:get(0))
    end
    WZLog("WndFriends:showResultForOperator", bHaveRelation)
    if self.m_nOperarorType == 1 then
        if tonumber(CacheCenter:getGameParam()["sendFriendNum"]) ~= nil then
            local nNumTemp = tonumber(CacheCenter:getGameParam()["sendFriendNum"])
            if bHaveRelation then
                nNumTemp = 2 * nNumTemp
            end
            local txtAtt = string.format(LocalStrings.GIVE_VIGOR_SUCCESS, nNumTemp)
            MsgBoxManager:showTipBox(txtAtt)
        else
            WZLog("The System param sendFriendNum is nil ")
        end
    elseif self.m_nOperarorType == 2 then 
        local nNumTemp = 2
        if bHaveRelation then
            nNumTemp = 2 * nNumTemp
        end
        local txtAtt = string.format(LocalStrings.GET_VIGOR_OK, nNumTemp)
        MsgBoxManager:showTipBox(txtAtt)
    end

    self.m_nOperarorType = 0 
end

--@brief    显示黑名单列表
function WndFriends:onShowBlacklist()
    if self.m_root == nil then
        return
    end
    local tbconBlacklist = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconBlacklist_WndFriends"))
    tbconBlacklist:cleanTable()

    local conBlacklist = GetElement(self.m_root, "conBlacklist_WndFriends", WZUIContainer)
    self.m_tBlacklist = CacheCenter:getFriendBlacklist()
    if self.m_tBlacklist == nil or #self.m_tBlacklist == 0 then
        ShowPanelNullTip( conBlacklist, LocalStrings.BLACKLIST_TEXT6)
        return 
    end
    removeShowPanelNullTip(conBlacklist)
    table.sort(self.m_tBlacklist, function (a,b)
        -- body
        local onlineA = WndFriends:checkSortOnline(a)
        local onlineB = WndFriends:checkSortOnline(b)

        if onlineA ~= onlineB then
            return onlineA >= onlineB
        elseif a.level ~= b.level then
            return a.level > b.level 
        else
            return a.id < b.id
        end
    end)

    for i = 1, #self.m_tBlacklist do 
        local celElement , tCell = CellFriendBlacklist:createElement()
        celElement:setTag(i - 1)
        tbconBlacklist:setCellElement(celElement)
        tCell:setCellData(self.m_tBlacklist[i])
    end

    tbconBlacklist:getMoveElement():setPositionY(tbconBlacklist:getMinPosition().y)
end

function WndFriends:DelBlacklistSuccess(playerId)
    if self.m_root == nil then return end
    
    self:closeLoading()
    --是否是从上线好友列表进去删除的
    WZLog("***** WndFriends:DelFriendSuccess *****")
    self.m_tBlacklist = CacheCenter:getFriendBlacklist()

    local tbconBlacklist = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconBlacklist_WndFriends"))
    --根据id获取tag，删除相应的好友，防止由于下线等引起tag变化后删错相应的好友cell
    local nTag = 0 
    local cellElement = tbconBlacklist:getCellElement(nTag)
    while cellElement do
        cellElement = WZUIContainer:luaTo(cellElement)
        local cellItem = cellElement:getChildElement("__CellFriendBlacklist")
        if cellItem then
            local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
            if cellObj then
                local nFriendId = cellObj:getFriendId() 
                if playerId == nFriendId then 
                    tbconBlacklist:removeCellElementByReset(nTag)
                    break 
                end
            end
        end
        nTag = nTag + 1
        cellElement = tbconBlacklist:getCellElement(nTag)
    end
    -------------------------

    if self.m_tBlacklist == nil or self.m_tBlacklist == {} or #self.m_tBlacklist == 0 then
        local conBlacklist = GetElement(self.m_root, "conBlacklist_WndFriends", WZUIContainer)
        ShowPanelNullTip( conBlacklist, LocalStrings.BLACKLIST_TEXT6)
    end
end

--@brief    筛选离线好友回调
function WndFriends:onClickFilter(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    --查找是否有好友信息
    local nCheckIndex = GetElement(self.m_root, "checkboxFilter_WndFriends", WZUICheckBox):getCheckIndex()
    if nCheckIndex == 1 then 
        local tFriend = CacheCenter:getFriendList()
        local tTempFriend = {}
        local curTime = SystemTime:getServerTime()
        if tFriend then
            for i, data in pairs(tFriend) do 
                local nTime = curTime - data.offlineTime
                if data.isOnline ~= 1 and nTime >= 30 * 24 * 3600 then
                    table.insert(tTempFriend, data)
                end
            end
        end
        
        if #tTempFriend == 0 then
            MsgBoxManager:showTipBox(LocalStrings.FRIEND_DELETE4)
            GetElement(self.m_root, "checkboxFilter_WndFriends", WZUICheckBox):setCheckIndex(0)
            return 
        end

        self:_showButtonByIndex(FILTER_LIST)
        GetElement(self.m_root,"conBottomBtn_WndFriends",WZUIContainer):setVisible(true) 
        self.m_bIsFilterFriend = true
        self.m_tFriend = tTempFriend
        self.m_nCurPageIndex = 1
        self.m_nFriendsTableIndex = 0
        local tbconFriend = self:getCurUsingTableContainer()
        tbconFriend:cleanTable()
        self:_sortFriendListType()--排序类型    
        self:_updateFriend()
        GetElement(self.m_root,"txtNumTitle_WndFriends",WZUILabelTTF):setVisible(false)
    else
        GetElement(self.m_root,"txtNumTitle_WndFriends",WZUILabelTTF):setVisible(true)
        self:_resetFriendsList()
    end
end

--@brief    重新获取好友信息显示
function WndFriends:_resetFriendsList()
    -- body
    self:_setCheckBoxSelVisible(false, true, false, false, false, false, false, false, false)
        
    self:clear()
    self.m_nCheckIndex = FRIEND_INDEX
    self:_showButtonByIndex(FRIEND_INDEX)
    self:_showRecvGift(false)
    -- self:_showButton(true,false, true)

    self.m_tSelFriends = nil 
    self.m_bIsResetFriends = true
    self.m_nCurPageIndex = 1
    self.m_nFriendsTableIndex = 0

    self:createLoading()
    ProtocolProcessorWndFriends:send_FRIEND_GetFriendInfoList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndFriends:_updateFriend()
	if self.m_root == nil or self.m_tFriend == nil or #self.m_tFriend == 0 then
		return
	end	
	self:_showFriendNum()
	local tbconFriend = self:getCurUsingTableContainer()
    tbconFriend:setVisible(true)
    --如果需要重新加载列表，先清理原列表
    --列表有内容时候
    if tbconFriend:getCellElement(0) then
        self.m_nCleanPositionY = tbconFriend:getMoveElement():getPositionY()
    end
    tbconFriend:cleanTable()
    if tbconFriend:getChildByTag(self.m_nTableEmptyLabelTag) then
        tbconFriend:removeChildByTag(self.m_nTableEmptyLabelTag,true)
    end
	self.m_nFriendIndex = 0
    local bestNum =  CacheCenter:getBestFriendNum()
    WZLog("WndFriends:_updateFriend 333", self.m_nFriendsTableIndex, self.m_nDisplayedNum)
    if self.m_nFriendsTableIndex - self.m_nDisplayedNum <= 0 then
        self.m_nFriendsTableIndex = 0 
        if #self.m_tFriend < self.m_nDisplayedNum then 
            self.m_nCurNeedLoadNum = #self.m_tFriend
        else
            self.m_nCurNeedLoadNum = self.m_nDisplayedNum
        end
        self.m_nCurLoadIndex = 1
        WZLog("WndFriends:_updateFriend 111", self.m_nFriendsTableIndex, self.m_nCurNeedLoadNum, self.m_nCurLoadIndex)
    else
        self.m_nFriendsTableIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum
        self.m_nCurNeedLoadNum = #self.m_tFriend - (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum
        if self.m_nCurNeedLoadNum > self.m_nDisplayedNum then
            self.m_nCurNeedLoadNum = self.m_nDisplayedNum
        end
        self.m_nCurLoadIndex = self.m_nFriendsTableIndex + 1
        WZLog("WndFriends:_updateFriend 222", self.m_nFriendsTableIndex, self.m_nCurNeedLoadNum, self.m_nCurLoadIndex)
    end
    -- self.m_nCurNeedLoadNum = self.m_nCurNeedLoadNum - bestNum
    self.m_nPageUporDownIndex = 0           
    self.m_nCurTag = 0 
	self:onShowFriend(tbconFriend)
end


--@brief    是否需要显示加载更多脚签
--@param    tFriend:要加载的数据表
--@param    nIndex:当前加载的数据在表中的索引
--@param    bIsOnlyDown:只需要向下加载更多，不需要向上加载
function WndFriends:_setLoadMoreVisible(tFriend, nIndex, bIsOnlyDown)
    -- body
    local tbconFriend = self:getCurUsingTableContainer()
    if bIsOnlyDown == nil or bIsOnlyDown == false then
        if self:_getUpPage(nIndex) then
            --Begin:翻页效果2
            tbconFriend:setEnableDropRefresh(false)
            local ttf = WZUILabelTTF:create()
            ttf:setText(LocalStrings.UP_TO_LOAD_MORE)
            ttf:setFontSize(22)
            ttf:setUseOriginSize(true)
            ttf:setColor(GlobalMethod:ccc3(255,236,193))
            tbconFriend:setTopNotice(LocalStrings.UP_TO_LOAD_MORE, LocalStrings.RELAX_TO_LOAD)
            tbconFriend:setTopElementFunction("onPageUp")--设置TopElement的Lua回调函数
            tbconFriend:setEnableTopElement(true)--设置TopElement是否可用
            tbconFriend:setVisibleHeight(30)
            tbconFriend:setHideTopElement(false)--设置topElement是否隐藏
            tbconFriend:setTopElement(ttf)--设置容器的TopElement对象
            --End
        else
            tbconFriend:setEnableDropRefresh(false)
            tbconFriend:setEnableTopElement(false)
            tbconFriend:setHideTopElement(true)
        end
    end
    if self:_getDownPage(#tFriend, nIndex) then
        --Begin:翻页效果2
        tbconFriend:setEnableDagLoading(false)
        local ttf = WZUILabelTTF:create()
        ttf:setText(LocalStrings.UP_TO_LOAD_MORE)
        ttf:setFontSize(22)
        ttf:setColor(GlobalMethod:ccc3(255,236,193))
        ttf:setUseOriginSize(true)
        tbconFriend:setBottomNotice(LocalStrings.UP_TO_LOAD_MORE, LocalStrings.RELAX_TO_LOAD)
        tbconFriend:setBottomElementFunction("onPageDown")  --设置BottomElement的Lua回调函数
        tbconFriend:setVisibleHeight(30)
        tbconFriend:setEnableBottomElement(true) --设置BottomElement是否可用
        tbconFriend:setHideBottomElement(false) --设置bottomElement是否隐藏
        tbconFriend:setBottomElement(ttf) --设置容器的BottomElement对象
        --End
    else 
        tbconFriend:setEnableDagLoading(false)
        tbconFriend:setEnableBottomElement(false)
        tbconFriend:setHideBottomElement(true)
    end
end

--@brief	点击上一页触发函数
--@param	element:表绑定的UI节点引用
function WndFriends:onPageUp(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_bUpPageShowLastPosition = true
    local tbconFriend = self:getCurUsingTableContainer()
    local conPositionY = tbconFriend:getMoveElement():getPositionY()
    if self.m_nCheckIndex == ONLINE_INDEX then 
        if self.m_tDynamic and self:_getUpPage(self.m_nDynamic) then 
            local nAddNum =self.m_nDisplayedNum
            if nAddNum <= 0 then return end
            if nAddNum > self.m_nDisplayedNum then
                nAddNum = self.m_nDisplayedNum 
            end

            --在前面添加的好友
            self.m_nCurPageIndex = self.m_nCurPageIndex - 1
            self.m_nCurNeedLoadNum = nAddNum            
            self.m_nCurLoadIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum + 1
            self.m_nCurTag = 0 
            self.m_nDynamic = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum
            WZLog("WndFriends:onPageUp  动态", self.m_nDynamic, self.m_nCurLoadIndex, self.m_nCurNeedLoadNum, self.m_nCurPageIndex)
            self:onShowDynamic(tbconFriend)
        end
    elseif self.m_nCheckIndex == INVITE_INDEX then 
        if self.m_tInviteFriends and self:_getUpPage(self.m_nInviteFriend) then 
            local nAddNum =self.m_nDisplayedNum
            if nAddNum <= 0 then return end
            --在前面添加的好友
            self.m_nCurPageIndex = self.m_nCurPageIndex - 1
            self.m_nCurNeedLoadNum = nAddNum            
            self.m_nCurLoadIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum + 1
            self.m_nCurTag = 0 
            self.m_nInviteFriend = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum
            WZLog("WndFriends:onPageUp  邀请码好友", self.m_nInviteFriend, self.m_nCurLoadIndex, self.m_nCurNeedLoadNum, self.m_nCurPageIndex)
            self:_updateInviteFriends()
        end
    else
        if self.m_tFriend and self:_getUpPage(self.m_nFriendsTableIndex) then 
        --    local nAddNum = self.m_nFriendsTableIndex - self.m_nDisplayedNum
            local nAddNum = self.m_nDisplayedNum
            if nAddNum <= 0 then return end
            if nAddNum > EACHTIME_LOAD_NUM then
                nAddNum = EACHTIME_LOAD_NUM 
            end

            --在前面添加的好友
            self.m_nCurPageIndex = self.m_nCurPageIndex - 1
            self.m_nCurNeedLoadNum = nAddNum            
            self.m_nCurLoadIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum + 1
            self.m_nCurTag = 0 
            self.m_nFriendsTableIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum    
            self:onShowFriend(tbconFriend)
        end
        --设置加载更多是否可见
        WZLog("******* self:_setLoadMoreVisible ******* 11111 ")
        self:_setLoadMoreVisible(self.m_tFriend, self.m_nFriendsTableIndex)
    end
end

--@brief    点击下一页触发函数
--@param    element:表绑定的UI节点引用
function WndFriends:onPageDown(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tbconFriend = self:getCurUsingTableContainer()

    if self.m_nCheckIndex == ONLINE_INDEX then 
        if self.m_tDynamic and self:_getDownPage(#self.m_tDynamic, self.m_nDynamic) then 
            local nAddNum = #self.m_tDynamic - self.m_nDynamic

            if nAddNum > EACHTIME_LOAD_NUM then
                nAddNum = EACHTIME_LOAD_NUM 
            end
            
            --添加后面几个好友
            self.m_nCurPageIndex = self.m_nCurPageIndex + 1 
            self.m_nCurNeedLoadNum = nAddNum    
            self.m_nCurLoadIndex = self.m_nDynamic + 1    
            self.m_nCurTag = 0             
            self:onShowDynamic(tbconFriend)
        end
    elseif self.m_nCheckIndex == INVITE_INDEX then 
        if self.m_tInviteFriends and self:_getDownPage(#self.m_tInviteFriends, self.m_nInviteFriend) then 
            local nAddNum = #self.m_tInviteFriends - self.m_nInviteFriend

            if nAddNum > self.m_nDisplayedNum then
                nAddNum = self.m_nDisplayedNum 
            end
            
            --添加后面几个好友
            self.m_nCurPageIndex = self.m_nCurPageIndex + 1 
            self.m_nCurNeedLoadNum = nAddNum    
            self.m_nCurLoadIndex = self.m_nInviteFriend + 1    
            self.m_nCurTag = 0             
            self:_updateInviteFriends()
        end
    else
        if self.m_tFriend and self:_getDownPage(#self.m_tFriend, self.m_nFriendsTableIndex) then 
            local nAddNum = #self.m_tFriend - self.m_nFriendsTableIndex
            if nAddNum > self.m_nDisplayedNum then
                nAddNum = self.m_nDisplayedNum 
            end
            
            --添加后面几个好友
            self.m_nCurPageIndex = self.m_nCurPageIndex + 1 
            self.m_nCurNeedLoadNum = nAddNum            
            self.m_nCurLoadIndex = self.m_nFriendsTableIndex + 1      
            self.m_nCurTag = 0         
            self:onShowFriend(tbconFriend)
        end
        --设置加载更多是否可见
        self:_setLoadMoreVisible(self.m_tFriend, self.m_nFriendsTableIndex)
    end
end

--@brief    添加好友成功返回处理添加按钮变灰
function WndFriends:addFriendsSuccess( playerId )
    -- body
    if self.m_nCheckIndex ~= RECOMMEND_INDEX then return end
    if self.m_root == nil then return end 

    local tbcon = self:getCurUsingTableContainer()
    if tbcon == nil then return end 

    for i = 1, #playerId do
        local nTag = 0 
        local cellElement = tbcon:getCellElement(nTag)
        while cellElement do
            cellElement = WZUIContainer:luaTo(cellElement)
            local cellItem = cellElement:getChildElement("__CellFriends")
            if cellItem then
                local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
                if cellObj then
                    local nFriendId = cellObj:getFriendId() 
                    if playerId[i] == nFriendId then 
                        cellObj:_setHavedAdd()
                        break 
                    end
                end
            end
            nTag = nTag + 1
            cellElement = tbcon:getCellElement(nTag)
        end
    end
end


--@note		好友动态更新
function WndFriends:_updateDynamicFriend()
	if self.m_root == nil or self.m_tDynamic == nil or #self.m_tDynamic == 0 then
		return
	end	
	self:_show2ColorTTF("txtRecvTitle_WndFriends","txtRecvNum_WndFriends",self:_getTodayRecv())--好友数量
	local tbcon = self:getCurUsingTableContainer()
    --如果是从其他标签进入动态界面，清表
    --列表有内容时候
    if tbcon:getCellElement(0) then
        local tSize = tbcon:getMoveElement():getContentSize()
        self.m_nLastMoveElementHeight = tSize.height
        self.m_nCleanPositionY = tbcon:getMoveElement():getPositionY()
    end
    tbcon:cleanTable()
    tbcon:setContentOffsetByRowIndex(0)

	tbcon:setEnableDropRefresh(false)
	tbcon:setEnableTopElement(false)
	tbcon:setHideTopElement(true)
	tbcon:setEnableDagLoading(false)
	tbcon:setEnableBottomElement(false)
	tbcon:setHideBottomElement(true)
    WZLog("_updateDynamicFriend 333", self.m_nDynamic, self.m_nDisplayedNum)
    if self.m_nDynamic - self.m_nDisplayedNum <= 0 then
        self.m_nDynamic = 0
        if #self.m_tDynamic < self.m_nDisplayedNum then
            self.m_nCurNeedLoadNum =  #self.m_tDynamic
        else
            self.m_nCurNeedLoadNum = self.m_nDisplayedNum
        end
        self.m_nCurLoadIndex = 1
        WZLog("_updateDynamicFriend 000", self.m_nDynamic, self.m_nCurNeedLoadNum, self.m_nCurLoadIndex)
    else
        self.m_nDynamic = (self.m_nCurPageIndex - 1)*self.m_nDisplayedNum
        self.m_nCurNeedLoadNum = #self.m_tDynamic - (self.m_nCurPageIndex - 1)*self.m_nDisplayedNum
        if self.m_nCurNeedLoadNum > self.m_nDisplayedNum then
            self.m_nCurNeedLoadNum = self.m_nDisplayedNum
        end
        self.m_nCurLoadIndex = self.m_nDynamic + 1
        WZLog("_updateDynamicFriend 222", self.m_nDynamic, self.m_nCurNeedLoadNum, self.m_nCurLoadIndex)
    end
    self.m_nCurTag = 0 
    self.m_nPageUporDownIndex = 0

	self:onShowDynamic(tbcon)
end

function WndFriends:_updateRecommend()
    -- body
    local tbconFriend = self:getCurUsingTableContainer()
    tbconFriend:setEnableDropRefresh(false)
    tbconFriend:setEnableTopElement(false)
    tbconFriend:setHideTopElement(true)
    tbconFriend:setEnableDagLoading(false)
    tbconFriend:setEnableBottomElement(false)
    tbconFriend:setHideBottomElement(true)
    self.m_nRecommend = 0
    tbconFriend:setVisible(true)
    tbconFriend:cleanTable()
    self.m_nIndex = 0 
    
    self:onShowRecommend()
end

function WndFriends:_showFriendNum()
	local count = CacheCenter:getFriendCount()
    
    WZLog("WndFriends:_showFriendNum", count)
    local nMaxFriendsNum = GetMaxFriends(CacheCenter:getPlayerInfo().vipLevel)
	local friendNum = count.."/"..tostring(nMaxFriendsNum)
	self:_show2ColorTTF("txtNumTitle_WndFriends","txtNum_WndFriends",friendNum)--好友数量
end

--@brief    邀请码好友
function WndFriends:_updateInviteFriends()
    -- body
    local conLeft = GetElement(self.m_root, "conLeft_WndFriends", WZUIContainer)
    if conLeft:getChildByTag(100) then
        conLeft:removeChildByTag(100,true)
    end

    local txtInviteFriendsNum = GetElement(self.m_root, "txtInviteFriendsNum_WndFriends", WZUILabelTTF)
    if self.m_tInviteFriends == nil or #self.m_tInviteFriends == 0 then
        txtInviteFriendsNum:setText("(" .. "0" .. LocalStrings.SPACE8 .. ")")
        ShowPanelNullTip(conLeft, LocalStrings.INVITE_CODE_ATT4)
        return 
    else
        txtInviteFriendsNum:setText("(" .. #self.m_tInviteFriends .. LocalStrings.SPACE8 .. ")")
    end

    local tbInviteFriends = GetElement(self.m_root, "tbInviteFriends_WndFriends", WZUITableContainer)
    tbInviteFriends:cleanTable()
    --邀请好友列表
    for j = 1, self.m_nCurNeedLoadNum do
        if self.m_tInviteFriends[self.m_nCurLoadIndex] then
            local celElement, tNewObj = CellFriendInvite:createElement()
            if celElement then
                celElement:setTag(self.m_nCurTag)
                tbInviteFriends:setCellElement(celElement)
                tNewObj:setData(self.m_tInviteFriends[self.m_nCurLoadIndex])
            end

            self.m_nCurLoadIndex = self.m_nCurLoadIndex + 1
            self.m_nInviteFriend = self.m_nInviteFriend + 1
            self.m_nCurTag = self.m_nCurTag + 1
        end
    end
    WZLog("WndFriends:_updateInviteFriends", type(self.m_nCleanPositionY))
    if self.m_nCleanPositionY then
        local tCurSize = tbInviteFriends:getMoveElement():getContentSize()
        tbInviteFriends:getMoveElement():setPositionY(self.m_nCleanPositionY - (tCurSize.height - self.m_nLastMoveElementHeight)/2)
        self.m_nCleanPositionY = nil 
        self.m_nLastMoveElementHeight = nil 
    else
        tbInviteFriends:getMoveElement():setPositionY(tbInviteFriends:getMinPosition().y)
    end

    self:_setLoadMoreVisible(self.m_tInviteFriends, self.m_nInviteFriend)
end


--@brief    邀请码任务
function WndFriends:_updateInviteTask()
    -- body
    if self.m_root == nil then return end

    local tbInviteRewards = GetElement(self.m_root, "tbInviteRewards_WndFriends", WZUITableContainer)
    tbInviteRewards:cleanTable()

    --任务列表
    for i = 1, #self.m_tInviteTask do
        local celElement, tNewObj = CellFriendInviteTask:createElement()
        if celElement then
            celElement:setTag(i - 1)
            tbInviteRewards:setCellElement(celElement)
            tNewObj:setData(self.m_tInviteTask[i])
            tNewObj:setCallBackFunc(self, self.onRevReward)
        end
    end

    if self.m_nCleanPositionY then
        tbInviteRewards:getMoveElement():setPositionY(self.m_nCleanPositionY)
        self.m_nCleanPositionY = nil 
    end
end

--@note		好友数量
function WndFriends:_showFriendCount(bShow)	
	local count = CacheCenter:getFriendCount()
	
    local nMaxFriendsNum = GetMaxFriends(CacheCenter:getPlayerInfo().vipLevel)
	local friendNum = tostring(count).."/"..tostring(nMaxFriendsNum)
	self:_show2ColorTTF("txtNumTitle_WndFriends","txtNum_WndFriends",friendNum)--好友数量
	local txtTitle = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNumTitle_WndFriends"))
    local txtNum = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtNum_WndFriends"))
	local btnBlackList = WZUIButton:luaTo(self.m_root:getChildElement("btnBlackList_WndFriends"))
    local btnInvent = WZUIButton:luaTo(self.m_root:getChildElement("btnInvent_WndFriends"))
    local checkboxFilter = GetElement(self.m_root, "checkboxFilter_WndFriends", WZUICheckBox)
	txtTitle:setVisible(bShow)
    txtNum:setVisible(bShow)
    -- btnBlackList:setVisible(bShow)
    if self.m_nCheckIndex == FRIEND_INDEX then 
        checkboxFilter:setVisible(true)
        btnInvent:setVisible(true)
        btnBlackList:setVisible(true)
    else
	    checkboxFilter:setVisible(false)
        btnInvent:setVisible(false)
        btnBlackList:setVisible(false)
    end
end

--@note		领取数量
function WndFriends:_showRecvGift(bShow)	
	self:_show2ColorTTF("txtRecvTitle_WndFriends","txtRecvNum_WndFriends",self:_getTodayRecv())--好友数量
	local txtTitle = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtRecvTitle_WndFriends"))
	local txtNum = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtRecvNum_WndFriends"))
	txtTitle:setVisible(bShow)
	txtNum:setVisible(bShow)
end

--@note		显示按钮
function WndFriends:_showButton(bShowA,bShowB,bShowC)	
	local btn1 = WZUIButton:luaTo(self.m_root:getChildElement("btn1_WndFriends"))
    local btn2 = WZUIButton:luaTo(self.m_root:getChildElement("btn2_WndFriends"))
	local btn4 = WZUIButton:luaTo(self.m_root:getChildElement("btn4_WndFriends"))
	btn1:setVisible(bShowA)
    --添加个人空间显示等级
    if bShowB then
        if CheckButtonShow(60) then
	        btn2:setVisible(bShowB)
        else
            btn2:setVisible(false)
        end
    end
    if bShowC then
        btn4:setVisible(bShowC)
        btn4:setRelativePosition(GlobalMethod:ccp(0.77, 0.5))
        btn1:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    else
        btn4:setVisible(false)
        btn1:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    end
	btn1:setTag(self.m_nCheckIndex)
	btn2:setTag(self.m_nCheckIndex)
end

function WndFriends:_showButtonByIndex(Index)
    WZLog("WndFriends:_showButtonByIndex",Index)
	local txt1 = self:_showTTFText("txt1_Friends",LocalStrings.ONEKEY_GIFTBACK)--一键回赠
    local txt2 = self:_showTTFText("txt2_Friends",LocalStrings.MAIL_GETALL)--一键领取
	local txt4 = self:_showTTFText("txt4_Friends",LocalStrings.FRIENDS_BESTFRIEND)--添加密友
    local btn1 = GetElement(self.m_root,"btn1_WndFriends",WZUIButton)
    local btn2 = GetElement(self.m_root,"btn2_WndFriends",WZUIButton)
    local btn3 = GetElement(self.m_root,"btn3_WndFriends",WZUIButton)
    local btn4 = GetElement(self.m_root,"btn4_WndFriends",WZUIButton)
    local btn5 = GetElement(self.m_root,"btn5_WndFriends",WZUIButton)
    local btn6 = GetElement(self.m_root,"btn6_WndFriends",WZUIButton)
    btn1:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
    btn4:setScale(1)
    btn4:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
	local bShow1 = false 
	local bShow2 = false 
    local bShow3 = false 
    local bShow4 = false 
    local bShow5 = false
    local bShow6 = false
	txt1:setVisible(bShow1)
	txt2:setVisible(bShow2)
    GetElement(self.m_root, "conFind_WndFriends", WZUIContainer):setVisible(false)
    --排行
	if Index == RRANK_INDEX then
		bShow2 = true 	
		txt2:setText(LocalStrings.INVITE)--邀请
    --好友
	elseif Index == FRIEND_INDEX then
		bShow1 = false 	
        bShow2 = false
        bShow4 = false 
        bShow5 = true
        bShow6 = true
        --添加个人空间显示等级
        if not CheckButtonShow(60) then
           bShow2 = false
        end 	
		txt1:setText(LocalStrings.FRIEND_ONLINE_ATT)--上线提醒
		txt2:setText(LocalStrings.MY_SPACE)--我的空间
        if ProjConfig.LANGUAGE == "pt" then
            txt2:setScale(1)
            txt1:setScale(1)
            txt4:setScale(0.7)
            txt4:setDimensions(GlobalMethod:CCSize(200,0))
        elseif ProjConfig.LANGUAGE == "vn" then
            txt1:setScale(0.76)
            txt2:setScale(0.9)
            txt4:setScale(0.88)
        elseif ProjConfig.LANGUAGE == "es" then
            txt4:setScale(0.7)
            txt4:setDimensions(GlobalMethod:CCSize(180,0))
            txt2:setScale(0.7)
            txt2:setDimensions(GlobalMethod:CCSize(180,0))
            txt1:setDimensions(GlobalMethod:CCSize(180,0))
            txt1:setScale(0.7)
        elseif ProjConfig.LANGUAGE == "tr" then
            txt4:setScale(0.7)
            txt4:setDimensions(GlobalMethod:CCSize(200,0))
        elseif ProjConfig.LANGUAGE == "ug" then
            txt1:setScale(0.6)
            txt1:setDimensions(GlobalMethod:CCSize(220))
        end
        btn1:setRelativePosition(GlobalMethod:ccp(-0.55,0.5))
    --推荐
    elseif Index == RECOMMEND_INDEX then
        bShow1 = false   
        bShow2 = false 
        GetElement(self.m_root, "conFind_WndFriends", WZUIContainer):setVisible(true)
    --邀请
    elseif Index == INVITE_INDEX then
        if ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1051 
            or ProjConfig.CHANNEL_ID == 1053 then
            txt2:setText(LocalStrings.INVITE)
            bShow1 = false
            bShow2 = true
            bShow3 = true
        else
            bShow1 = false
            bShow2 = false
            bShow3 = true
        end
    elseif Index == BLACKLIST_INDEX then
    elseif Index == FILTER_LIST then 
    WZLog("点击筛选是否显示按钮")   
        bShow1 = true
        bShow4 = true
        txt1:setText(LocalStrings.CANCEL)--取消
        txt4:setText(LocalStrings.POPUPMENUSTRING4)--删除
        btn1:setRelativePosition(GlobalMethod:ccp(0.65,0.5))
        btn4:setRelativePosition(GlobalMethod:ccp(0.88,0.5))
        btn1:setScale(0.6)
        btn4:setScale(0.6)
    --动态
	else 
		bShow1 = true 	
		bShow2 = true
        if ProjConfig.LANGUAGE == "pt" then
            txt2:setScale(0.7)
            txt1:setScale(0.8)
        elseif ProjConfig.LANGUAGE == "vn" then
            txt2:setScale(1)
            txt1:setScale(1)
        elseif ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" then
            txt1:setDimensions(GlobalMethod:CCSize(170,0))
            txt1:setScale(0.73)
        elseif ProjConfig.LANGUAGE == "ug" then
            txt1:setScale(0.6)
            txt1:setDimensions(GlobalMethod:CCSize(220))
        end
	end
	txt1:setTag(Index)
	txt2:setTag(Index)
	txt1:setVisible(bShow1)
	txt2:setVisible(bShow2)

    btn1:setVisible(bShow1)
    btn2:setVisible(bShow2)
    btn3:setVisible(bShow3)
    btn4:setVisible(bShow4)
    btn5:setVisible(bShow5)
    btn6:setVisible(bShow6)
    btn1:setTag(Index)
    btn2:setTag(Index)
    btn3:setTag(Index)
    btn4:setTag(Index)
    btn5:setTag(Index)
    btn6:setTag(Index)
end

--@note		多语言文本
function WndFriends:_showMultiLanguage()
	self:_showTTFText("txtCheck1_WndFriends","社交")--排行
	self:_showTTFText("txtCheck2_WndFriends",LocalStrings.FRIEND)--好友
	self:_showTTFText("txtCheck3_WndFriends",self.FRIENDDYNAMIC)--好友动态
    self:_showTTFText("txtCheck4_WndFriends",LocalStrings.SHOP_RECOMMEND)--推荐
    self:_showTTFText("txtCheck5_WndFriends",LocalStrings.MASTER_APPRENTICE)--邀请
	self:_showTTFText("txtNumTitle_WndFriends",LocalStrings.FRIENDNUM..":")--好友数量
	self:_showTTFText("txtRecvTitle_WndFriends",LocalStrings.TODAYRECV..":")--今日领取数量
	self:_showButtonByIndex(RRANK_INDEX)
end

--@brief   删除好友
function WndFriends:_delFriend()
	local tFriend = self.m_tClickFriendData
	local vector = WZLuaVector_int_:create()
	vector:push(tFriend.id)
	WZLog("WndFriends:_delFriend():::",tFriend.id, vector:get(0))
	self:createLoading()
	ProtocolProcessorWndFriends:send_FRIEND_DeleteFriend(vector)
end

function WndFriends:DelFriendSuccess(  )
    if self.m_root == nil then return end
    
	self:closeLoading()
    if self.m_bIsFilterFriend then 
        GetElement(self.m_root, "checkboxFilter_WndFriends", WZUICheckBox):setCheckIndex(0)
        self:_resetFriendsList()
        return 
    end
    --是否是从上线好友列表进去删除的
    local delFriendData = WndOnlineHintFriend:DelFriendSuccess()
    if delFriendData then
        self.m_tClickFriendData = {}
        self.m_tClickFriendData.id = delFriendData.id 
        self.m_tClickFriendData.name = delFriendData.name
    end

    WZLog("***** WndFriends:DelFriendSuccess *****")
	local idx = self:_getFriendTag(self.m_tFriend, self.m_tClickFriendData)
	
	table.remove(self.m_tFriend,idx)
	local tbcon = self:getCurUsingTableContainer()
    local nCurPositionY = tbcon:getMoveElement():getPositionY()
    local tLastSize = tbcon:getMoveElement():getContentSize()
    --根据id获取tag，删除相应的好友，防止由于下线等引起tag变化后删错相应的好友cell
    local nTag = 0 
    local cellElement = tbcon:getCellElement(nTag)
    while cellElement do
        cellElement = WZUIContainer:luaTo(cellElement)
        local cellItem = cellElement:getChildElement("__CellFriends")
        if cellItem then
            local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
            if cellObj then
                local nFriendId = cellObj:getFriendId() 
                if self.m_tClickFriendData.id == nFriendId then 
                    tbcon:removeCellElementByReset(nTag)
                    break 
                end
            end
        end
        nTag = nTag + 1
        cellElement = tbcon:getCellElement(nTag)
    end
    -------------------------
    self.m_nFriendsTableIndex = self.m_nFriendsTableIndex - 1
    --删除后，如果还有好友未加载出来，则加载
    if self.m_nFriendsTableIndex > 0 then
        self:_dealWithDelFriend(tbcon, nCurPositionY, tLastSize)
    end

    if self.m_tFriend == nil or self.m_tFriend == {} or #self.m_tFriend == 0 then
        if self.m_nCheckIndex == 1 then
            self:_showEmptyTip(0,LocalStrings.EMPTYFRIENDTIP1,true)
        elseif self.m_nCheckIndex == 2 then
            self:_showEmptyTip(0,LocalStrings.FRIENDS_NO_OTHERFRIEND, true)
        end
    end

	self:_showFriendNum()
end

--@brief    解除蜜友关系成功处理
function WndFriends:removeBestFriendSuccess(nDelFriendId)
    --body
    if self.m_root == nil then return end 
    if self.m_tBestFriendsCell == nil then return end 

    local conModel = GetElement(self.m_root,"conModels_WndFriends",WZUIContainer)

    for i = 1, #self.m_tBestFriendsCell do
        local cellObj = self.m_tBestFriendsCell[i][1]
        if cellObj then
            local nFriendId = cellObj:getFriendId() 
            if nDelFriendId == nFriendId then 
                local model = GetElement(conModel, "model" .. self.m_tBestFriendsCell[i][3], WZUIContainer)
                if model:getChildByTag(i-1) then
                    model:removeChildByTag(i-1,true)
                end
                GetElement(conModel,"btnAdd" .. self.m_tBestFriendsCell[i][3],WZUIButton):setVisible(true)
                break 
            end
        end
    end
end

--@brief   今日领取次数
function WndFriends:_getTodayRecv()
    local nReveiveUpper = GetReceiveUpper(CacheCenter:getPlayerInfo().vipLevel)
	local Maxcount = GetReceiveUpper(CacheCenter:getPlayerInfo().vipLevel)
	local count = Maxcount - CacheCenter:getTodayRecvVigor()
	return tostring(count).."/"..tostring(Maxcount)
end


--@brief   设置标题
function WndFriends:_setTitleTxt(  )
    GetElement(self.m_root, "editFind_WndFriends", WZUIEditBox):setPlaceHolder(LocalStrings.TOUCH_TO_INPUT)
    GetElement(self.m_root, "editFriendFind_WndFriends", WZUIEditBox):setPlaceHolder(LocalStrings.INPUT_KEY_SEARCH)
end

--@brief    设置选项卡高亮
--@param    bCommunityVisible 设置社区选项卡高亮
--@param    bFriendsVisible 设置好友选项卡高亮
--@param    bDynamicVisible 设置动态选项卡高亮
--@param    bRecommendVisible 设置推荐选项卡高亮
--@param    bInvideVisible 设置邀请选项卡高亮
function WndFriends:_setCheckBoxSelVisible(bCommunityVisible, bFriendsVisible, bDynamicVisible, bRecommendVisible, bInvideVisible, bBlackListVisible, bFriendCircle, bHotCircle, bMyCircle)
    -- body
    GetElement(self.m_root,"conMidContent_WndFriends",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"conMaster_WndFriends",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"imgMidBg_WndFriends",WZUI9Image):setVisible(true)
    GetElement(self.m_root,"imgFriendsBg_WndFriends",WZUI9Image):setVisible(false)
    GetElement(self.m_root,"conBottomBtn_WndFriends",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"conModels_WndFriends",WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conListPanel_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root,"checkboxFilter_WndFriends",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    GetElement(self.m_root,"txtNumTitle_WndFriends",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.12,0.5))
    GetElement(self.m_root,"conSceneBg_WndFriends"):setVisible(true)
    local conFriendList = GetElement(self.m_root,"conFriendList_WndFriends",WZUIContainer)
    local conBottomBtn = GetElement(self.m_root, "conBottomBtn_WndFriends", WZUIContainer)
    local conBlacklist = GetElement(self.m_root, "conBlacklist_WndFriends", WZUIContainer)
    conBlacklist:setVisible(false)
    
    if bInvideVisible == true then        
        conFriendList:setVisible(false)
    elseif bBlackListVisible then
        conBlacklist:setVisible(true)
        conFriendList:setVisible(false)
        GetElement(self.m_root, "conInvite_WndFriends", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conMyCode_WndFriends", WZUIContainer):setVisible(false)
    elseif bFriendCircle or bHotCircle or bMyCircle then 
        conFriendList:setVisible(false)
        conBlacklist:setVisible(false)

        GetElement(self.m_root, "conListPanel_WndFriends", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conInvite_WndFriends", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conMyCode_WndFriends", WZUIContainer):setVisible(false)

        if conBottomBtn:getChildByTag(888) then
            conBottomBtn:removeChildByTag(888, true)
        end

    elseif bFriendsVisible == true then
        WZLog("WndFriends:_setCheckBoxSelVisible")
        GetElement(self.m_root,"imgMidBg_WndFriends",WZUI9Image):setVisible(false)
        GetElement(self.m_root,"imgFriendsBg_WndFriends",WZUI9Image):setVisible(true)    
        -- GetElement(self.m_root,"conBottomBtn_WndFriends",WZUIContainer):setVisible(false)    
        GetElement(self.m_root,"conModels_WndFriends",WZUIContainer):setVisible(true)
        GetElement(self.m_root,"checkboxFilter_WndFriends",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.95,0.5))
        GetElement(self.m_root,"txtNumTitle_WndFriends",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1.6,0.5))
        conFriendList:setVisible(true)
    else
        GetElement(self.m_root, "conInvite_WndFriends", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conMyCode_WndFriends", WZUIContainer):setVisible(false)
        conFriendList:setVisible(true)

        if conBottomBtn:getChildByTag(888) then
            conBottomBtn:removeChildByTag(888, true)
        end
    end
    --显示本服好友和跨服好友复选框
    GetElement(self.m_root, "conCheckBox_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conCheckTheme1Sel_WndFriends", WZUIContainer):setVisible(bCommunityVisible)
    GetElement(self.m_root, "conCheckTheme2Sel_WndFriends", WZUIContainer):setVisible(bFriendsVisible)
    GetElement(self.m_root, "conCheckTheme3Sel_WndFriends", WZUIContainer):setVisible(bDynamicVisible)
    GetElement(self.m_root, "conCheckTheme4Sel_WndFriends", WZUIContainer):setVisible(bRecommendVisible)
    GetElement(self.m_root, "conCheckTheme5Sel_WndFriends", WZUIContainer):setVisible(bInvideVisible)
    GetElement(self.m_root, "conCheckTheme7Sel_WndFriends", WZUIContainer):setVisible(bFriendCircle)
    GetElement(self.m_root, "conCheckTheme8Sel_WndFriends", WZUIContainer):setVisible(bHotCircle)
    GetElement(self.m_root, "conCheckTheme9Sel_WndFriends", WZUIContainer):setVisible(bMyCircle)
    GetElement(self.m_root, "txtBlacklistAtt_WndFriends", WZUILabelTTF):setVisible(bBlackListVisible)
    GetElement(self.m_root, "conMidBottom_WndFriends", WZUIContainer):setVisible(not bBlackListVisible and not bMyCircle and not bFriendCircle and not bHotCircle)
    GetElement(self.m_root, "editFriendFind_WndFriends", WZUIEditBox):setText("")
    GetElement(self.m_root, "btnCancelFind_WndFriends", WZUIButton):setVisible(false)
    GetElement(self.m_root, "tbconFriend_WndFriends", WZUITableContainer):setVisible(bFriendsVisible)
    GetElement(self.m_root, "tbconFriendCD_WndFriends", WZUITableContainer):setVisible(bDynamicVisible or bRecommendVisible)
    GetElement(self.m_root, "conMyCircle_WndFriends", WZUIContainer):setVisible(bFriendCircle or bHotCircle or bMyCircle)
    GetElement(self.m_root, "conNotRead_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conNotReadList_WndFriends", WZUIContainer):setVisible(false)
    self.m_bIsFindFriend = false
    self.m_bIsFilterFriend = false 
end

--@brief    获取某个好友数据在整个列表中的位置
function WndFriends:_getFriendTag(tFriends, tData)
    -- body
    if tFriends == nil or tData == nil then return nil end

    for i = 1, #tFriends do
        if tFriends[i].id == tData.id then
            return i
        end
    end

    return nil
end

--@brief    删除好友成功后列表的处理
function WndFriends:_dealWithDelFriend(tbcon, nCurPositionY, tLastSize)
    -- body
    WZLog("WndFriends:_dealWithDelFriend")
    if self.m_tFriend then
        if self:_getDownPage(#self.m_tFriend, self.m_nFriendsTableIndex) then  
            --如果下面还有数据，则加载下一条，顶替删除的项流出的空缺
            --减去已经移除的那个
            local nTagTemp = self.m_nCurTag - 1

            WZLog("WndFriends:_dealWithDelFriend 111", self.m_nFriendsTableIndex, nTagTemp)
            local celElement, tCell = CellFriends:createElement()
            celElement:setTag(nTagTemp)
            tbcon:setCellElement(celElement)
            tCell:setBackFun(self,self.onFriendClick,self.onSendClick)
            tCell:setCellData(self.m_tFriend[self.m_nFriendsTableIndex + 1],self.m_nCheckIndex)
            self.m_nFriendsTableIndex = self.m_nFriendsTableIndex + 1
            --设置加载更多是否可见
            tbcon:updateContainerSize()
            --重新设置列表的位置
            local tCurSize = tbcon:getMoveElement():getContentSize()
            local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
            if nTempPositionY > tbcon:getMaxPosition().y then
                nTempPositionY = tbcon:getMaxPosition().y
            end
            tbcon:getMoveElement():setPositionY(nTempPositionY)
            WZLog("******* self:_setLoadMoreVisible ******* 33333 ")
            self:_setLoadMoreVisible(self.m_tFriend, self.m_nFriendsTableIndex)
        elseif not self:_getDownPage(#self.m_tFriend, self.m_nFriendsTableIndex) and self.m_nCurPageIndex > 1 and self.m_nCurPageIndex > math.ceil(#self.m_tFriend/self.m_nDisplayedNum) then
            --如果当前页是最后一页，且数据已经全部删除，则跳到上一页显示上一页的数据
            self.m_nCurPageIndex = self.m_nCurPageIndex - 1
            self.m_nCurNeedLoadNum = self.m_nDisplayedNum            
            self.m_nCurLoadIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum + 1
            self.m_nCurTag = 0 
            self.m_nFriendsTableIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum    
            self:onShowFriend(tbcon)
        else
            tbcon:updateContainerSize()
            --重新设置列表位置
            local tCurSize = tbcon:getMoveElement():getContentSize()
            local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
            if nTempPositionY > tbcon:getMaxPosition().y then
                nTempPositionY = tbcon:getMaxPosition().y
            end
            tbcon:getMoveElement():setPositionY(nTempPositionY)
        end
        return
    end
end

--@brief    删除好友申请动态成功后列表的处理
function WndFriends:_dealWithDelDynamic(tbcon, nCurPositionY, tLastSize)
    -- body
    WZLog("WndFriends:_dealWithDelDynamic")
    if self.m_tDynamic then
        if self:_getDownPage(#self.m_tDynamic, self.m_nDynamic) then  
            --如果下面还有数据，则加载下一条，顶替删除的项流出的空缺
            --减去已经移除的那个
            local nTagTemp = self.m_nCurTag - 1
            
            WZLog("WndFriends:_dealWithDelDynamic 111", self.m_nDynamic, nTagTemp)
            local celElement , tCell = CellDynamic:createElement()
            celElement:setTag(nTagTemp)
            tbcon:setCellElement(celElement)
            tCell:setBackFun(self,self.onRecvClick,self.onBackSend,self.onSure, self.onRefuse)
            tCell:setCellData(self.m_tDynamic[self.m_nDynamic + 1])

            self.m_nDynamic = self.m_nDynamic + 1
            --设置加载更多是否可见
            tbcon:updateContainerSize()
            --重新设置列表位置
            local nCurSize = tbcon:getMoveElement():getContentSize()
            local nTempPositionY = nCurPositionY - (nCurSize.height - tLastSize.height)/2
            if nTempPositionY > tbcon:getMaxPosition().y then
                nTempPositionY = tbcon:getMaxPosition().y
            end
            tbcon:getMoveElement():setPositionY(nTempPositionY)
            -----
            self:_setLoadMoreVisible(self.m_tDynamic, self.m_nDynamic)
        elseif not self:_getDownPage(#self.m_tDynamic, self.m_nDynamic) and self.m_nCurPageIndex > 1 and self.m_nCurPageIndex > math.ceil(#self.m_tDynamic/self.m_nDisplayedNum) then
            --如果当前页是最后一页，且数据已经全部删除，则跳到上一页显示上一页的数据
            self.m_nCurPageIndex = self.m_nCurPageIndex - 1
            self.m_nCurNeedLoadNum = self.m_nDisplayedNum            
            self.m_nCurLoadIndex = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum + 1
            self.m_nCurTag = 0 
            self.m_nDynamic = (self.m_nCurPageIndex - 1) * self.m_nDisplayedNum
            self:onShowDynamic(tbcon)
        else
            tbcon:updateContainerSize()
            local nCurSize = tbcon:getMoveElement():getContentSize()
            local nTempPositionY = nCurPositionY - (nCurSize.height - tLastSize.height)/2
            if nTempPositionY > tbcon:getMaxPosition().y then
                nTempPositionY = tbcon:getMaxPosition().y
            end
            tbcon:getMoveElement():setPositionY(nTempPositionY)
        end
        return
    end
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------好友圈Start------------------------------------------
--@brief    点击好友圈按钮回调
function WndFriends:onClickCircle(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local nTag = element:getTag()
    if self.m_nCheckIndex == nTag then return end 

    self.m_tAddPhotoData = nil 
    self.m_nNeedUploadPhotoNum = 0
    self.m_tExtendCircle = {} 
    if nTag == FRIENDCIRCLE_INDEX then 
        --好友圈
        if not CheckButtonOpen(165) then return end 
        self.m_nCheckIndex = nTag
        self:_setCheckBoxSelVisible(false, false, false, false, false, false, true, false, false)
        ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle(2, 0)
    elseif nTag == HOTCIRCLE_INDEX then 
        --热点圈
        if not CheckButtonOpen(166) then return end 
        self.m_nCheckIndex = nTag
        self:_setCheckBoxSelVisible(false, false, false, false, false, false, false, true, false)
        ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle(3, 0)
    elseif nTag == MYCIRCLE_INDEX then 
        --我的心情
        if not CheckButtonOpen(167) then return end 
        self.m_nCheckIndex = nTag
        self:_setCheckBoxSelVisible(false, false, false, false, false, false, false, false, true)
        ProtocolProcessorWndFriends:send_FRIENTD_GetFriendCircle(1, 0)
    end
end

--@brief    根据类型获取checkBoxGroup的索引
function WndFriends:getCheckIndexByType(nType)
    if nType == RRANK_INDEX then
        return 0
    elseif nType == FRIEND_INDEX then
        return 1
    elseif nType == ONLINE_INDEX then
        return 2
    elseif nType == RECOMMEND_INDEX then
        return 3
    elseif nType == INVITE_INDEX then
        return 4
    elseif nType == BLACKLIST_INDEX then
    elseif nType == FRIENDCIRCLE_INDEX then
        return 5
    elseif nType == HOTCIRCLE_INDEX then
        return 6
    elseif nType == MYCIRCLE_INDEX then
        return 7
    elseif nType == COMMENT_PERPAGE_NUM then
    elseif nType == FILTER_LIST then
    end
	return -1
end

--@brief    
function WndFriends:onClickCircleFinish(element)
    -- body
    local nTag = element:getTag()
    -- self.m_nCheckIndex = tag
    if nTag == FRIENDCIRCLE_INDEX then 
        --好友圈
        if not CheckButtonOpen(165, false) then GetElement(self.m_root, "checkGroup_WndFriends", WZUICheckBoxGroup):setCheckIndex(self:getCheckIndexByType(self.m_nCheckIndex)) return end 
    elseif nTag == HOTCIRCLE_INDEX then 
        --热点圈
        if not CheckButtonOpen(166, false) then GetElement(self.m_root, "checkGroup_WndFriends", WZUICheckBoxGroup):setCheckIndex(self:getCheckIndexByType(self.m_nCheckIndex)) return end 
    elseif nTag == MYCIRCLE_INDEX then 
        --我的心情
        if not CheckButtonOpen(167, false) then GetElement(self.m_root, "checkGroup_WndFriends", WZUICheckBoxGroup):setCheckIndex(self:getCheckIndexByType(self.m_nCheckIndex)) return end 
    end
end

--@brief    点击发布心情按钮回调
function WndFriends:onClickAddCircle(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local maxCircleNum = tonumber(CacheCenter:getGameParam().myMoodSaveNum)
    if #self.m_tMyCircleData >= maxCircleNum then 
        MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT23)
        return 
    end
    self.m_tAddPhotoData = nil 
    self.m_nNeedUploadPhotoNum = 0
    GetElement(self.m_root, "editCircle_WndFriends", WZUIEditBox):setText("")
    self.m_bIsClickAddCircle = not self.m_bIsClickAddCircle 

    self:showMyCircle()
end

--@brief    点击非好友不让评论复选框回调
function WndFriends:onClickForbid(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    if self.m_nForbidIndex == 1 then 
        self.m_nForbidIndex = 0 
    else
        self.m_nForbidIndex = 1
    end
end

--@brief    点击发布按钮回调
function WndFriends:onClickPublish(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local maxCircleNum = tonumber(CacheCenter:getGameParam().myMoodSaveNum)
    if #self.m_tMyCircleData >= maxCircleNum then 
        MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT23)
        self.m_bIsClickAddCircle = not self.m_bIsClickAddCircle 

        self:showMyCircle()
        return 
    end

    if self.m_bUploading == true then return end

    local editCircle = GetElement(self.m_root, "editCircle_WndFriends", WZUIEditBox)
    local txt = editCircle:getText()
    if txt == nil or txt == "" then 
        MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT13)
        return 
    end

    --存在空格就不能发送
    if checkBlankSpace(txt) then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
        return
    end

    local sMaxWordConfig = tonumber(CacheCenter:getGameParam().wordsNum)
    local nCount = GetWordCount(txt)
    if nCount > sMaxWordConfig then 
        MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT27)
        return 
    end
    local txtContent, bHaveMask = CheckYellow(txt)
    if bHaveMask then 
        MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
        return 
    end

    --加载圆圈
    if self.m_nNeedUploadPhotoNum > 0 then 
        self.m_nLoadingCircleId = MsgBoxManager:showLoadingBox(16)
        self.m_bUploading = true
        self.m_nUploadTime = 0
        self.m_nUploadPhotoIndex = 1
        self.m_bUploadOutTime = false
        WZLog("WndFriends:onClickPublish", self.m_nNeedUploadPhotoNum)
        self:startUploadPhoto()
    else
    --    MsgBoxManager:showTipBox(LocalStrings.RED_PACK9[3])
        local tAddPhotoData = {}
        ProtocolProcessorWndFriends:send_FRIENTD_AddFriendCircle(txtContent, TableToStdStringVector(tAddPhotoData), self.m_nForbidIndex)
    end
end

--@brief    上传照片
function WndFriends:startUploadPhoto()
    -- body
    local nIndex = self.m_nUploadPhotoIndex 
    WZLog("WndFriends:startUploadPhoto 111", nIndex)
    for i = nIndex, 3 do
        if self.m_tAddPhotoData and self.m_tAddPhotoData[i] then 
            WZLog("WndFriends:startUploadPhoto 000")
            local sJson =  json.encode(self.m_tAddPhotoData[i]) 
            WZLog("WndFriends:startUploadPhoto 111")
            DSSdkManager:putFile(sJson, self.onUploadFinish, self)
            WZLog("WndFriends:startUploadPhoto", self.m_tAddPhotoData[i].objName)
            self.m_root:enableSchedule("onUploadCountdown", 1)
            break 
        else
            self.m_nUploadPhotoIndex = self.m_nUploadPhotoIndex + 1
        end
    end
end

--@brief    上传计时
function WndFriends:onUploadCountdown(element, t)
    self.m_nUploadTime = self.m_nUploadTime + 1
    WZLog("WndFriends:onUploadCountdown", self.m_nUploadTime)
    if self.m_nUploadTime > 15 then
        self.m_bUploadOutTime = true
        self.m_bUploading = false
        --弹出上传失败提示
        MsgBoxManager:showTipBox(LocalStrings.SPACE78)
        element:disableSchedule()
    end
end

--@brief    上传完成回调
function WndFriends:onUploadFinish(sjson)
    WZLog("WndFriends:onUploadFinish", sjson)
    if self.m_bUploadOutTime == true then return end
    self.m_nUploadPhotoIndex = self.m_nUploadPhotoIndex + 1
    local sJson = json.decode(sjson) 
    if sJson["return"] == "success" then 
        WZLog("WndFriends:onUploadFinish 000")
        self.m_nHavedUploadNum = self.m_nHavedUploadNum + 1

        if self.m_nHavedUploadNum >= self.m_nNeedUploadPhotoNum then 
            --取消圆圈的转动效果
            MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
            self.m_bUploading = false
            
            local editCircle = GetElement(self.m_root, "editCircle_WndFriends", WZUIEditBox)
            local txt = editCircle:getText()
            local tSpacePhoto = {}
            for i = 1, 3 do
                if self.m_tAddPhotoData and self.m_tAddPhotoData[i] then 
                    table.insert(tSpacePhoto, self.m_tAddPhotoData[i].objName)
                end
            end

            local txtContent = CheckYellow(txt)
            ProtocolProcessorWndFriends:send_FRIENTD_AddFriendCircle(txtContent, TableToStdStringVector(tSpacePhoto), self.m_nForbidIndex)
            MsgBoxManager:showTipBox(LocalStrings.SPACE50)
        else
            self:startUploadPhoto()
        end
    else
        --取消圆圈的转动效果
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingCircleId)
        self.m_bUploading = false

        MsgBoxManager:showTipBox(LocalStrings.SPACE51)
    end

end

--@brief    点击取消发布按钮回调
function WndFriends:onClickCancelPublish(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_bUploading == true then return end

    self.m_bIsClickAddCircle = not self.m_bIsClickAddCircle 

    self:showMyCircle()
end

--@brief    点击未读信息按钮回调
function WndFriends:onClickNewMessage(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    ProtocolProcessorWndFriends:send_FRIENTD_LookFriendCircle()
end

--@brief    点击隐藏新消息提示列表
function WndFriends:onClickHideNewList(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    GetElement(self.m_root, "conNotReadList_WndFriends", WZUIContainer):setVisible(false)
    if self.m_nNewMessageNum > 0 then 
        GetElement(self.m_root, "conNotRead_WndFriends", WZUIContainer):setVisible(true)
        self:showMyCircleMark(true)
    else
        self:showMyCircleMark(false)
    end
end

--@brief    点击评论展示评论输入框回调
function WndFriends:clickCommentCallback(tCell)
    -- body
    if self.m_tCellBeingComment == nil then 
        self.m_tCellBeingComment = tCell
        return 
    else
        self.m_tCellBeingComment:resetCommentInterface()
        self.m_tCellBeingComment = tCell 
    end
end

--@brief    点击评论展示评论输入框回调
function WndFriends:cleanClickCommentCallback()
    -- body
    self.m_tCellBeingComment = nil 
end

--@brief    显示圈列表
function WndFriends:showCircleList()
    -- body
    WZLog("WndFriends:showCircleList", self.m_nCheckIndex)
    if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
        self:showFriendOrHotCircle()
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then 
        ChangeChatChannel(Chat_Channel_Friends_HotCircle)
        self:showFriendOrHotCircle()
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
        ChangeChatChannel(Chat_Channel_Friends_MyCircle)
        self:showMyCircle()
    end
end

--@brief    显示我的心情
function WndFriends:showMyCircle()
    -- body
    if self.m_nCheckIndex ~= MYCIRCLE_INDEX then return end 

    local conMyCircle = GetElement(self.m_root, "conMyCircle_WndFriends", WZUIContainer)

    GetElement(self.m_root, "conShowMyCircleList_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conEditMyCircle_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conOtherCircle_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conNotRead_WndFriends", WZUIContainer):setVisible(false)
    if self.m_nNewMessageNum > 0 then 
        GetElement(self.m_root, "conNotRead_WndFriends", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "txtNewMessageNum_WndFriends", WZUILabelTTF):setText(string.format(LocalStrings.FRIENDCIRCLE_TEXT30, self.m_nNewMessageNum))
        self:showMyCircleMark(true)
    else
        self:showMyCircleMark(false)
    end
    if self.m_bIsClickAddCircle then --添加心情界面
        GetElement(self.m_root, "conEditMyCircle_WndFriends", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "txtNewVersion_WndFriends", WZUILabelTTF):setVisible(true)

        self:_updateInputWordsNum()
        local pictureNum = tonumber(CacheCenter:getGameParam().pictureNum)

        for i = 1, pictureNum do 
            local conPhoto = GetElement(self.m_root, "conPhoto" .. i .. "_WndFriends", WZUIContainer)
            conPhoto:setVisible(true)
            conPhoto:removeAllChildrenWithCleanup(true)

            local celElement,tCell = CellSpacePhoto:createElement()
            tCell.m_nIndex = i
            tCell.m_nType = 2
            celElement:setTag(i-1)    --从0开始设置Tag值
            celElement:setScale(0.8)
            tCell:setType(2)
            conPhoto:addChild(celElement)

            tCell:updateAddCircle()
        end 
    else
        GetElement(self.m_root, "conShowMyCircleList_WndFriends", WZUIContainer):setVisible(true)
        local flMyCircleList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)
        if flMyCircleList:size() > 0 then
            flMyCircleList:removeAll()
        end
        if self.m_tMyCircleData == nil or #self.m_tMyCircleData == 0 then 
            ShowPanelNullTip2( conMyCircle, LocalStrings.FRIENDCIRCLE_TEXT11, nil, nil, GlobalMethod:ccp(0.3, 0), nil)
            return 
        end
        removeShowPanelNullTip(conMyCircle)

        for i = 1, #self.m_tMyCircleData do
            local conSize = GlobalMethod:CCSize(920, 300)
            if self.m_tMyCircleData[i].picNum <= 0 then 
                conSize = GlobalMethod:CCSize(920, 165)
            end
            local element, tNewObj = CellCircleOfFriend:createElement(conSize)
            if element and tNewObj then 
                element = WZUIContainer:luaTo(element)

                tNewObj:setData(self.m_tMyCircleData[i])
                tNewObj:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
                flMyCircleList:pushBack(element)
                --添加点赞的Cell
                if self.m_tMyCircleData[i].goodNum > 0 then 
                    local celElement, tCell = CellCircleComment:createElement()
                    if celElement and tCell then 
                        celElement = WZUIContainer:luaTo(celElement)
                        tCell:setData(self.m_tMyCircleData[i], 1)

                        flMyCircleList:pushBack(celElement)
                    end
                end
                --添加评论的Cell
                if self.m_tMyCircleData[i].commentNum > 0 then 
                    local nCommentIndex = 0 
                    for k = 1, self.m_tMyCircleData[i].commentNum do
                        local celElement, tCell = CellCircleComment:createElement()
                        if celElement and tCell then 
                            celElement = WZUIContainer:luaTo(celElement)
                            tCell:setData(self.m_tMyCircleData[i], 2, self.m_tMyCircleData[i].commentData[k])
                            tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
                            
                            flMyCircleList:pushBack(celElement)

                            nCommentIndex = nCommentIndex + 1
                            if nCommentIndex >= self.m_nDefaultShowCommentNum then 
                                break 
                            end
                        end
                    end
                end
                --添加可扩展的Cell
                if self.m_tMyCircleData[i].commentNum > self.m_nDefaultShowCommentNum then 
                    local conSize = GlobalMethod:CCSize(920, 30)
                    local celElement, tCell = CellCircleComment:createElement(conSize)
                    if celElement and tCell then 
                        celElement = WZUIContainer:luaTo(celElement)
                        tCell:setData(self.m_tMyCircleData[i], 3)
                        tCell:setExtendCallBack(self, self.onShowAllComment, self.onShowLess, self.onChangePage)

                        flMyCircleList:pushBack(celElement)
                    end
                end
            end
            --分割线
            local lineNode, tLineCell = CellCircleBottomLine:createElement()
            if lineNode and tLineCell then 
                lineNode = WZUIContainer:luaTo(lineNode)
                tLineCell:setData(self.m_tMyCircleData[i].id)

                flMyCircleList:pushBack(lineNode)
            end
        end

        flMyCircleList:getMoveElement():setPositionY(flMyCircleList:getMinPosition().y)
    end
end

--@brief    检测输入变化
function WndFriends:onEditTextChange(element)
    -- body
    element = WZUIEditBox:luaTo(element)
    local txt = element:getText()

    self:_updateInputWordsNum()
end

--@brief    更新输入的字数
function WndFriends:_updateInputWordsNum()
    -- body
    local txtMaxInputNum = GetElement(self.m_root, "txtMaxInputNum_WndFriends", WZUILabelTTF)
    local sMaxWordConfig = CacheCenter:getGameParam().wordsNum
    txtMaxInputNum:setText("/" .. sMaxWordConfig)
    --
    local editCircle = GetElement(self.m_root, "editCircle_WndFriends", WZUIEditBox)
    local txt = editCircle:getText()
    local count = GetWordCount(txt)
    local txtCurInputNum = GetElement(self.m_root, "txtCurInputNum_WndFriends", WZUILabelTTF)
    txtCurInputNum:setText(count)
end

--@brief    显示热点心情或好友圈
function WndFriends:showFriendOrHotCircle()
    -- body
    if self.m_nCheckIndex ~= FRIENDCIRCLE_INDEX and self.m_nCheckIndex ~= HOTCIRCLE_INDEX then return end 
    local conMyCircle = GetElement(self.m_root, "conMyCircle_WndFriends", WZUIContainer)
    GetElement(self.m_root, "conShowMyCircleList_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conEditMyCircle_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conNotRead_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conNotReadList_WndFriends", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "conOtherCircle_WndFriends", WZUIContainer):setVisible(true)
    local flOtherCircleList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    if flOtherCircleList:size() > 0 then
        flOtherCircleList:removeAll()
    end

    local tTempData = self.m_tFriendCircleData
    if self.m_nCheckIndex == HOTCIRCLE_INDEX then 
        tTempData = self.m_tHotCircleData
    end
    WZLog("WndFriends:showFriendOrHotCircle", conMyCircle:isVisible(), self.m_nCheckIndex, #tTempData)
    if tTempData == nil or #tTempData == 0 then 
        ShowPanelNullTip2( conMyCircle, LocalStrings.FRIENDCIRCLE_TEXT12, nil, nil, GlobalMethod:ccp(0.3, 0), nil)
        return 
    end
    removeShowPanelNullTip(conMyCircle)

    for i = 1, #tTempData do
        local conSize = GlobalMethod:CCSize(920, 300)
        if tTempData[i].picNum <= 0 then 
            conSize = GlobalMethod:CCSize(920, 165)
        end
        local element, tNewObj = CellCircleOfFriend:createElement(conSize)
        if element and tNewObj then 
            element = WZUIContainer:luaTo(element)

            tNewObj:setData(tTempData[i])
            tNewObj:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
            if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
                tNewObj:setInterfaceTab(FRIENDCIRCLE_INDEX)
            end
            flOtherCircleList:pushBack(element)

            --添加点赞的Cell
            if tTempData[i].goodNum > 0 then 
                local celElement, tCell = CellCircleComment:createElement()
                if celElement and tCell then 
                    celElement = WZUIContainer:luaTo(celElement)
                    tCell:setData(tTempData[i], 1)

                    flOtherCircleList:pushBack(celElement)
                end
            end
            --添加评论的Cell
            if tTempData[i].commentNum > 0 then 
                local nCommentIndex = 0 
                for k = 1, tTempData[i].commentNum do
                    local celElement, tCell = CellCircleComment:createElement()
                    if celElement and tCell then 
                        celElement = WZUIContainer:luaTo(celElement)
                        tCell:setData(tTempData[i], 2, tTempData[i].commentData[k])
                        tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
                        
                        flOtherCircleList:pushBack(celElement)

                        nCommentIndex = nCommentIndex + 1
                        if nCommentIndex >= self.m_nDefaultShowCommentNum then 
                            break 
                        end
                    end
                end
            end
            --添加可扩展的Cell
            if tTempData[i].commentNum > self.m_nDefaultShowCommentNum then 
                local conSize = GlobalMethod:CCSize(920, 30)
                local celElement, tCell = CellCircleComment:createElement(conSize)
                if celElement and tCell then 
                    celElement = WZUIContainer:luaTo(celElement)
                    tCell:setData(tTempData[i], 3)
                    tCell:setExtendCallBack(self, self.onShowAllComment, self.onShowLess, self.onChangePage)
                    flOtherCircleList:pushBack(celElement)
                end
            end
        end
        --分割线
        local lineNode, tLineCell = CellCircleBottomLine:createElement()
        if lineNode and tLineCell then 
            lineNode = WZUIContainer:luaTo(lineNode)
            tLineCell:setData(tTempData[i].id)

            flOtherCircleList:pushBack(lineNode)
        end
    end

    flOtherCircleList:getMoveElement():setPositionY(flOtherCircleList:getMinPosition().y)
end

--@brief    显示未读消息列表
function WndFriends:showNewMessageList()
    -- body
    local flNewMessageList = GetElement(self.m_root, "flNewMessageList_WndFriends", WZUIFreeListContainer)
    if flNewMessageList:size() > 0 then 
        flNewMessageList:removeAll()
    end
    GetElement(self.m_root, "conNotReadList_WndFriends", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "conNotRead_WndFriends", WZUIContainer):setVisible(false)

    for i = 1, #self.m_tNewMessageData do
        local element, tNewObj = CellCircleNewList:createElement()
        if element and tNewObj then 
            element = WZUIContainer:luaTo(element)
            tNewObj:setData(self.m_tNewMessageData[i])

            flNewMessageList:pushBack(element)
        end
    end

    flNewMessageList:getMoveElement():setPositionY(flNewMessageList:getMinPosition().y)
end

--@brief    展示所有的评论
function WndFriends:onShowAllComment(tCircleData)
    -- body
    if self.m_tExtendCircle == nil then self.m_tExtendCircle = {} end 

    self.m_tExtendCircle[tostring(tCircleData.id)] = true
    local flTempList 
    if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
        flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer) 
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then   
        flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
        flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)    
    end
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    local tNewObj, pos = self:getHeartTotalObjByIdAndType(tCircleData.id, 3)
    if tNewObj and pos then 
        local tempPos = pos - 1
        local nCount = math.min(tCircleData.commentNum, COMMENT_PERPAGE_NUM)
        for k = self.m_nDefaultShowCommentNum + 1, nCount do
            local celElement, tCell = CellCircleComment:createElement()
            if celElement and tCell then 
                celElement = WZUIContainer:luaTo(celElement)
                tCell:setData(tCircleData, 2, tCircleData.commentData[k])
                tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
                
                flTempList:insert(tempPos, celElement)

                tempPos = tempPos + 1
            end
        end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief    隐藏部分评论回调
function WndFriends:onShowLess(tCircleData, nCurPage, nTotalPage)
    -- body
    if self.m_tExtendCircle == nil then self.m_tExtendCircle = {} end 

    self.m_tExtendCircle[tostring(tCircleData.id)] = false

    local flTempList 
    if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
        flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer) 
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then   
        flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
        flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)    
    end
    if flTempList == nil then return end 

    local nCurPosY = flTempList:getMoveElement():getPositionY()
    local tNewObj, pos = self:getHeartTotalObjByIdAndType(tCircleData.id, 3)
    if tNewObj and pos then 
        --先删掉原有的
        local nCountTemp
        if nCurPage ~= nTotalPage then 
            nCountTemp = COMMENT_PERPAGE_NUM
        else
            if nTotalPage == 1 then 
                nCountTemp = tCircleData.commentNum - self.m_nDefaultShowCommentNum
            else
                nCountTemp = math.fmod(tCircleData.commentNum, COMMENT_PERPAGE_NUM)
            end
        end
        local tempPos = pos - nCountTemp - 1
        for i = 1, nCountTemp do
            flTempList:removeAt(tempPos)
        end
        if nTotalPage == 1 then 
            flTempList:getMoveElement():setPositionY(nCurPosY)
            return
        end
        --添加前五个
        local nCount = math.min(tCircleData.commentNum, self.m_nDefaultShowCommentNum)
        for k = 1, nCount do
            local celElement, tCell = CellCircleComment:createElement()
            if celElement and tCell then 
                celElement = WZUIContainer:luaTo(celElement)
                tCell:setData(tCircleData, 2, tCircleData.commentData[k])
                tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
                
                flTempList:insert(tempPos, celElement)

                tempPos = tempPos + 1
            end
        end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end

--@brief    切换页回调
function WndFriends:onChangePage(tCircleData, nCurPage, nLastPage, nTotalPage)
    -- body
    local flTempList 
    if self.m_nCheckIndex == FRIENDCIRCLE_INDEX then 
        flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer) 
    elseif self.m_nCheckIndex == HOTCIRCLE_INDEX then   
        flTempList = GetElement(self.m_root, "flOtherCircleList_WndFriends", WZUIFreeListContainer)
    elseif self.m_nCheckIndex == MYCIRCLE_INDEX then 
        flTempList = GetElement(self.m_root, "flMyCircleList_WndFriends", WZUIFreeListContainer)    
    end
    if flTempList == nil then return end 
    WZLog("WndFriends:onChangePage", nCurPage, nLastPage, nTotalPage)
    local nCurPosY = flTempList:getMoveElement():getPositionY()
    local tNewObj, pos = self:getHeartTotalObjByIdAndType(tCircleData.id, 3)
    if tNewObj and pos then 
        --先删掉原有的
        local nCountTemp
        if nLastPage == nil then 
            nCountTemp = 0
        else
            if nLastPage ~= nTotalPage then 
                nCountTemp = COMMENT_PERPAGE_NUM
            else
                nCountTemp = math.fmod(tCircleData.commentNum, COMMENT_PERPAGE_NUM)
                if nCountTemp == 0 then 
                    nCountTemp = COMMENT_PERPAGE_NUM
                end
            end
        end
        local tempPos = pos - nCountTemp - 1
        for i = 1, nCountTemp do
            flTempList:removeAt(tempPos)
        end
        --添加当前页的评论
        local nCount = COMMENT_PERPAGE_NUM
        if nCurPage == nTotalPage then 
            nCount = math.fmod(tCircleData.commentNum, COMMENT_PERPAGE_NUM)
            if nCount == 0 then 
                nCount = COMMENT_PERPAGE_NUM
            end
        end
        if nLastPage == nil then 
            nCount = COMMENT_PERPAGE_NUM
        end
        local nDataIndex = (nCurPage - 1) * COMMENT_PERPAGE_NUM + 1
        WZLog("WndFriends:onChangePage yyy", nDataIndex, nCount)
        for k = nDataIndex, nDataIndex + nCount - 1 do
            local celElement, tCell = CellCircleComment:createElement()
            if celElement and tCell then 
                celElement = WZUIContainer:luaTo(celElement)
                tCell:setData(tCircleData, 2, tCircleData.commentData[k])
                tCell:setShowCommentEditBoxCallback(self, self.clickCommentCallback, self.cleanClickCommentCallback)
                
                flTempList:insert(tempPos, celElement)

                tempPos = tempPos + 1
            end
        end
    end

    flTempList:getMoveElement():setPositionY(nCurPosY)
end
-------------------------------------好友圈End------------------------------------------
-------------------------------------下载文件管理Begin----------------------------------------
--@brief    新增下载文件任务
--@param    fileName文件名,tCell1设置图片的Cell,tCell2设置图片的Cell
function WndFriends:addDownloadFileList(fileName, tCell1, tCell2, size, tCell)
    WZLog("WndFriends:addDownloadFileList",fileName)
    if fileName == nil or fileName == "" then return end
    self.m_nSize = size
    local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
    --如果文件存在，不下载，直接使用
    local bExist = WZFileUtil:isFileExist(path)
    if bExist then
        WZLog("文件存在",tCell1,tCell2,tCell ~= nil)
        local fileError = false
        if tCell1 ~= nil then 
            tCell1:setFile(path) 
            if self.m_nSize ~= nil then
                local imgSize = tCell1:getContentSize()
                local x = self.m_nSize/imgSize.width 
                local y = self.m_nSize/imgSize.height
                WZLog("缩放比例",self.m_nSize,imgSize.width,imgSize.height,math.max(x,y))
                tCell1:setScale(math.max(x,y))
                if imgSize.width < 10 or imgSize.width > 2000 then fileError = true end
                if imgSize.height < 10 or imgSize.height > 2000 then fileError = true end
            end
        end
        if tCell2 ~= nil then 
            tCell2:setFile(path) 
            if self.m_nSize ~= nil then
                local imgSize = tCell2:getContentSize()
                local x = self.m_nSize/imgSize.width 
                local y = self.m_nSize/imgSize.height
                tCell2:setScale(math.max(x,y))
            end
        end
        if tCell ~= nil then
            WZLog("隐藏loding",tCell.m_nIndex)
            tCell:setLodingPhoto(false)
            if fileError then tCell:setInvalidPhoto() end
        end
    else
        --在下载列表中新增记录
        if self.m_tDownloadFileList == nil then self.m_tDownloadFileList = {} end
        --检测是否是重复任务
        for i=1,#self.m_tDownloadFileList do
            if fileName == self.m_tDownloadFileList[i].fileName then
                WZLog("重复下载",fileName)
                return
            end
        end
        local tempTable = {fileName=fileName,tCell1=tCell1,tCell2=tCell2,status="init",tCell=tCell}
        table.insert(self.m_tDownloadFileList,tempTable)
    end
end

--@brief    下载文件
function WndFriends:downloadFile(element,t)
    --列表中没有任务，返回
    if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
    --有文件正在下载，返回
    for i=1,#self.m_tDownloadFileList do
        if self.m_tDownloadFileList[i].status=="downloading" then return end
    end
    --没有文件正在下载，开始下载第一个任务
    local fileName = self.m_tDownloadFileList[1].fileName
    local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..fileName
    local s = {}
    s.filePath = path
    s.objName = fileName
    WZLog("WndFriends 调用sdk下载文件",fileName, path)
    self.m_tDownloadFileList[1].status="downloading"
    DSSdkManager:downFile(json.encode(s),self.downloadFileFinish, self)
    --WndFriends:createLoading()
end

--@brief    下载成功回调
function WndFriends:downloadFileFinish(result)
    WZLog("WndFriends:downloadFileFinish",result)
    if self.m_tDownloadFileList == nil or #self.m_tDownloadFileList == 0 then return end
    local result = json.decode(result)
    local fileName = result.objName
    --如果下载失败，把任务清出队列，返回
    WZLog("下载结果",result["return"])
    if result["return"] == "fail" then
        for i=1,#self.m_tDownloadFileList do
            if self.m_tDownloadFileList[i].status == "downloading" then
                table.remove(self.m_tDownloadFileList,i)
                return
            end
        end
    end 
    if fileName == nil then return end
    local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..result.objName
    --WZLog("下载完成",path,Serialize(self.m_tDownloadFileList))
    WZLog("下载完成",path)

    for i=1,#self.m_tDownloadFileList do
        WZLog(i,self.m_tDownloadFileList[i],self.m_tDownloadFileList[i].fileName,fileName)
        if self.m_tDownloadFileList[i].fileName == fileName and self.m_tDownloadFileList[i].status == "downloading" then
            local x,y
            if self.m_tDownloadFileList[i].tCell ~= nil then
                if self.m_tDownloadFileList[i].tCell.m_root ~= nil then
                    if self.m_tDownloadFileList[i].tCell1 ~= nil then
                        local imgPhoto = self.m_tDownloadFileList[i].tCell1
                        imgPhoto:setFile(path)
                        local size = imgPhoto:getContentSize()
                        local hh = 236
                        if self.m_nSize ~= nil then hh = self.m_nSize end
                        x = hh/size.width 
                        y = hh/size.height
                        imgPhoto:setScale(math.max(x,y))
                    end
                    if self.m_tDownloadFileList[i].tCell2 ~= nil then
                        local imgPhoto = self.m_tDownloadFileList[i].tCell2
                        imgPhoto:setFile(path)
                        imgPhoto:setScale(math.max(x,y))
                    end
                end
                self.m_tDownloadFileList[i].tCell:setLodingPhoto(false)
            else
                if self.m_tDownloadFileList[i].tCell1 ~= nil then
                    local imgPhoto = self.m_tDownloadFileList[i].tCell1
                    imgPhoto:setFile(path)
                    local size = imgPhoto:getContentSize()
                    local hh = 236
                    if self.m_nSize ~= nil then hh = self.m_nSize end
                    x = hh/size.width 
                    y = hh/size.height
                    imgPhoto:setScale(math.max(x,y))
                end
                if self.m_tDownloadFileList[i].tCell2 ~= nil then
                    local imgPhoto = self.m_tDownloadFileList[i].tCell2
                    imgPhoto:setFile(path)
                    imgPhoto:setScale(math.max(x,y))
                end
            end
            --一次只下载一个文件,从列表中找到即可返回
            table.remove(self.m_tDownloadFileList,i)
            --WndFriends:closeLoading()
            self.m_nSize = nil
            return
        end
    end
end

--@brief 刷新好友容器
function WndFriends:refreshFriendCon()
    self:_sortFriendListType()
    self:_updateFriend()
end

-------------------------------------下载文件管理Start--------------------------------------
-------------------------------------语言适配模块Start--------------------------------------
--@brief 英文适配函数
--@note  英文适配
function WndFriends:_adaptLanguage_en()
    local txtCheck3_unSel = GetElement(self.m_root, "txtCheck3_unSel_WndFriends", WZUILabelTTF)
    if txtCheck3_unSel then
        txtCheck3_unSel:setFontSize(20)
    end
    local txtCheck3 = GetElement(self.m_root, "txtCheck3_WndFriends", WZUILabelTTF)
    if txtCheck3 then
        txtCheck3:setFontSize(22)
    end

    local txt1_Friends = GetElement(self.m_root, "txt1_Friends", WZUILabelTTF)
    if txt1_Friends then 
        txt1_Friends:setScale(0.8)
        txt1_Friends:setDimensions(GlobalMethod:CCSize(130))
    end

    local txtNum = GetElement(self.m_root, "txtNum_WndFriends", WZUILabelTTF)
    if txtNum then
        txtNum:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
    end

    local conMidContent = GetElement(self.m_root,"conMidContent_WndFriends",WZUIContainer)
    local btn3 = GetElement(conMidContent,"btn3_WndFriends",WZUIButton)
    btn3:setAbsContentSize(GlobalMethod:CCSize(192,66))
    btn3:updateRelativeSize()

    local txt3 = GetElement(btn3,"txt3_Friends",WZUILabelTTF)
    txt3:setScale(0.75)

    local txtRecvNum = GetElement(self.m_root, "txtRecvNum_WndFriends", WZUILabelTTF)
    
    local txtRecvTitle = GetElement(self.m_root,"txtRecvTitle_WndFriends",WZUILabelTTF)
    txtRecvTitle:setFontSize(18)
    txtRecvTitle:setRelativePosition(GlobalMethod:ccp(0,0.5))
    txtRecvNum:setRelativePosition(GlobalMethod:ccp(0.83,0.5))
    
    GetElement(self.m_root,"txtCheck7_WndFriends",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtCheck5_WndFriends",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtCheck8_WndFriends",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtCheck4_WndFriends",WZUILabelTTF):setFontSize(20)

    GetElement(self.m_root,"txtCheck8_WndFriends",WZUILabelTTF):setFontSize(11)
    GetElement(self.m_root,"txtCheck4_WndFriends",WZUILabelTTF):setFontSize(11)

    local txtCheck11 = GetElement(self.m_root, "txtCheck11_WndFriends", WZUILabelTTF)
    txtCheck11:setFontSize(18)
    txtCheck11:setDimensions(GlobalMethod:CCSize(80))
    txtCheck11:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck12 = GetElement(self.m_root, "txtCheck12_WndFriends", WZUILabelTTF)
    txtCheck12:setFontSize(18)
    txtCheck12:setDimensions(GlobalMethod:CCSize(80))
    txtCheck12:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
end

--@brief 泰文适配函数
--@note  泰文适配
function WndFriends:_adaptLanguage_th()
    local txtNum = GetElement(self.m_root, "txtNum_WndFriends", WZUILabelTTF)
    if txtNum then
        txtNum:setRelativePosition(GlobalMethod:ccp(0.25,0.5))
    end

    local txtRecvNum = GetElement(self.m_root, "txtRecvNum_WndFriends", WZUILabelTTF)
    if txtRecvNum then
        txtRecvNum:setRelativePosition(GlobalMethod:ccp(0.48,0.5))
    end

    local txt1 = GetElement(self.m_root,"txt1_Friends",WZUILabelTTF)
    txt1:setScale(0.85)

    local txt3 = GetElement(self.m_root,"txt3_Friends",WZUILabelTTF)
    txt3:setScale(0.85)
end

function WndFriends:_adaptLanguage_pt(  )
    GetElement(self.m_root, "txtCheck4_WndFriends", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtCheck2_WndFriends", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtCheck3_WndFriends", WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root, "txtCheck5_WndFriends", WZUILabelTTF):setFontSize(18)
    local txtCheck8 = GetElement(self.m_root, "txtCheck8_WndFriends", WZUILabelTTF)
    txtCheck8:setFontSize(18)
    txtCheck8:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck7 = GetElement(self.m_root, "txtCheck7_WndFriends", WZUILabelTTF)
    txtCheck7:setFontSize(18)
    txtCheck7:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck9 = GetElement(self.m_root, "txtCheck9_WndFriends", WZUILabelTTF)
    txtCheck9:setFontSize(18)
    txtCheck9:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck11 = GetElement(self.m_root, "txtCheck11_WndFriends", WZUILabelTTF)
    txtCheck11:setFontSize(18)
    txtCheck11:setDimensions(GlobalMethod:CCSize(80))
    txtCheck11:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck12 = GetElement(self.m_root, "txtCheck12_WndFriends", WZUILabelTTF)
    txtCheck12:setFontSize(18)
    txtCheck12:setDimensions(GlobalMethod:CCSize(80))
    txtCheck12:setRelativePosition(GlobalMethod:ccp(0.55,0.5))

    local txt3 = GetElement(self.m_root,"txt3_Friends",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(180,0))
    txt3:setScale(0.75)

    local txt1_Friends = GetElement(self.m_root, "txt1_Friends", WZUILabelTTF)
    if txt1_Friends then 
        txt1_Friends:setScale(0.8)
    end

    local edit = GetElement(self.m_root,"editFind_WndFriends",WZUIEditBox)
    edit:setRelativePosition(GlobalMethod:ccp(0.83,0.5))
    edit:setRelativeSize(GlobalMethod:CCSize(0.8,1))
    GetElement(self.m_root,"txtRecvNum_WndFriends",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    
    -- GetElement(self.m_root,"txtCheckBox3_WndFriends",WZUILabelTTF):setFontSize(16)
    -- GetElement(self.m_root,"txtCheckBox4_WndFriends",WZUILabelTTF):setFontSize(16)
    local editFriend = GetElement(self.m_root,"editFriendFind_WndFriends",WZUIEditBox)
    editFriend:setRelativeSize(GlobalMethod:CCSize(0.7,1))
    editFriend:setRelativePosition(GlobalMethod:ccp(0.8,0.5))

    GetElement(self.m_root, "txtBlacklistAtt_WndFriends", WZUILabelTTF):setScale(0.88)
end

--@note  越南适配
function WndFriends:_adaptLanguage_vn()
    WZLog("WndFriends:_adaptLanguage_vn")
    --GetElement(self.m_root,"editFind_WndFriends",WZUIEditBox):setRelativePosition(GlobalMethod:ccp(0.94,0.5))
    GetElement(self.m_root,"txtNum_WndFriends",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(1,0.5))
    
    local txtAddCircle = GetElement(self.m_root,"txtAddCircle_WndFriends",WZUILabelTTF)
    if txtAddCircle then
        txtAddCircle:setScale(0.8)
    end
    for i=1,2 do
        local txtCheckBox = GetElement(self.m_root,"txtCheckBox"..i.."_conMyPhoto",WZUILabelTTF)
        if txtCheckBox then
            txtCheckBox:setDimensions(GlobalMethod:CCSize(200))
        end
    end

    GetElement(self.m_root,"txtCheck17_WndFriends",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCheck14_WndFriends",WZUILabelTTF):setScale(0.8)
end

function WndFriends:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtCheck2_WndFriends",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtNum_WndFriends",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.5))
    GetElement(self.m_root,"txtRecvNum_WndFriends",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.8,0.5))

    local txtCheckTheme4 = GetElement(self.m_root,"txtCheck8_WndFriends",WZUILabelTTF)
    txtCheckTheme4:setFontSize(20)
    txtCheckTheme4:setDimensions(GlobalMethod:CCSize(100,0))
    local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndFriends",WZUILabelTTF)
    txtCheck4:setFontSize(20)
    txtCheck4:setDimensions(GlobalMethod:CCSize(100,0))

    local txtCheck9 = GetElement(self.m_root,"txtCheck9_WndFriends",WZUILabelTTF)
    txtCheck9:setFontSize(20)

    GetElement(self.m_root,"txtCheck5_WndFriends",WZUILabelTTF):setFontSize(20)

    local txtRecvTitle = GetElement(self.m_root,"txtRecvTitle_WndFriends",WZUILabelTTF)
    txtRecvTitle:setFontSize(18)

    local txt3 = GetElement(self.m_root,"txt3_Friends",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(180,0))
    txt3:setScale(0.7)

    GetElement(self.m_root,"txtCheck7_WndFriends",WZUILabelTTF):setFontSize(20)

    local txtCheck11 = GetElement(self.m_root, "txtCheck11_WndFriends", WZUILabelTTF)
    txtCheck11:setFontSize(18)
    txtCheck11:setDimensions(GlobalMethod:CCSize(80))
    txtCheck11:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck12 = GetElement(self.m_root, "txtCheck12_WndFriends", WZUILabelTTF)
    txtCheck12:setFontSize(18)
    txtCheck12:setDimensions(GlobalMethod:CCSize(80))
    txtCheck12:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
end

function WndFriends:_adaptLanguage_es(  )
    GetElement(self.m_root, "txtCheck4_WndFriends", WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root, "txtCheck3_WndFriends", WZUILabelTTF):setFontSize(18)
  
    local txtCheck8 = GetElement(self.m_root, "txtCheck8_WndFriends", WZUILabelTTF)
    txtCheck8:setFontSize(14)
    txtCheck8:setRelativePosition(GlobalMethod:ccp(0.55,0.5))

    local txt3 = GetElement(self.m_root,"txt3_Friends",WZUILabelTTF)
    txt3:setDimensions(GlobalMethod:CCSize(180,0))
    txt3:setScale(0.75)

    local txt1 = GetElement(self.m_root, "txt1_Friends", WZUILabelTTF)
    txt1:setScale(0.7)

    local edit = GetElement(self.m_root,"editFind_WndFriends",WZUIEditBox)
    edit:setRelativePosition(GlobalMethod:ccp(0.83,0.5))
    edit:setRelativeSize(GlobalMethod:CCSize(0.8,0.8))
    GetElement(self.m_root,"txtRecvNum_WndFriends",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.75,0.5))
    GetElement(self.m_root,"txtFreeMyCode_WndFriends",WZUIFreeTextBox):setMaxWidth(400)
    GetElement(self.m_root,"txtInviteFriends_WndFriends",WZUILabelTTF):setFontSize(16)
    -- local txtCheckBox1 = GetElement(self.m_root,"txtCheckBox1_WndFriends",WZUILabelTTF)
    -- txtCheckBox1:setFontSize(18)
    -- txtCheckBox1:setDimensions(GlobalMethod:CCSize(130,0))

    -- local txtCheckBox2 = GetElement(self.m_root,"txtCheckBox2_WndFriends",WZUILabelTTF)
    -- txtCheckBox2:setFontSize(18)
    -- txtCheckBox2:setDimensions(GlobalMethod:CCSize(130,0))
    
    -- GetElement(self.m_root,"txtCheckBox3_WndFriends",WZUILabelTTF):setFontSize(18)
    -- GetElement(self.m_root,"txtCheckBox4_WndFriends",WZUILabelTTF):setFontSize(18)

    local txtCheck11 = GetElement(self.m_root, "txtCheck11_WndFriends", WZUILabelTTF)
    txtCheck11:setFontSize(18)
    txtCheck11:setDimensions(GlobalMethod:CCSize(80))
    txtCheck11:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck12 = GetElement(self.m_root, "txtCheck12_WndFriends", WZUILabelTTF)
    txtCheck12:setFontSize(18)
    txtCheck12:setDimensions(GlobalMethod:CCSize(80))
    txtCheck12:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    
    GetElement(self.m_root, "txtBlacklistAtt_WndFriends", WZUILabelTTF):setScale(0.88)
end

function WndFriends:_adaptLanguage_ug(  )
    local txtCheck = GetElement(self.m_root, "txtCheck10_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    txtCheck:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck = GetElement(self.m_root, "txtCheck7_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    txtCheck:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck = GetElement(self.m_root, "txtCheck6_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    txtCheck:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck = GetElement(self.m_root, "txtCheck8_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    txtCheck:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck = GetElement(self.m_root, "txtCheck9_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    txtCheck:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck = GetElement(self.m_root, "txtCheck11_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    txtCheck:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    local txtCheck = GetElement(self.m_root, "txtCheck1_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    local txtCheck = GetElement(self.m_root, "txtCheck2_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    local txtCheck = GetElement(self.m_root, "txtCheck3_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    local txtCheck = GetElement(self.m_root, "txtCheck4_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    local txtCheck = GetElement(self.m_root, "txtCheck5_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))
    local txtCheck = GetElement(self.m_root, "txtCheck12_WndFriends", WZUILabelTTF)
    txtCheck:setScale(0.7)
    txtCheck:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root, "txtBlacklistAtt_WndFriends", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(700))

    GetElement(self.m_root, "txtNumTitle_WndFriends", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.15,0.5))
    local txtNum = GetElement(self.m_root, "txtNum_WndFriends", WZUILabelTTF)
    txtNum:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtNum:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
    local txtRecvTitle = GetElement(self.m_root, "txtRecvTitle_WndFriends", WZUILabelTTF)
    txtRecvTitle:setRelativePosition(GlobalMethod:ccp(0.08,0.5))
    txtRecvTitle:setDimensions(GlobalMethod:CCSize(400))
    local txtRecvTitle = GetElement(self.m_root, "txtRecvNum_WndFriends", WZUILabelTTF)
    txtRecvTitle:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtRecvTitle:setRelativePosition(GlobalMethod:ccp(0.15,0.5))
    
    local txt1 = GetElement(self.m_root,"txt1_Friends",WZUILabelTTF)
    txt1:setScale(0.6)
    txt1:setDimensions(GlobalMethod:CCSize(220))
    local txt2 = GetElement(self.m_root,"txt2_Friends",WZUILabelTTF)
    txt2:setScale(0.6)
    txt2:setDimensions(GlobalMethod:CCSize(220))
    local txt3 = GetElement(self.m_root,"txt3_Friends",WZUILabelTTF)
    txt3:setScale(0.6)
    txt3:setDimensions(GlobalMethod:CCSize(220))
    local txt4 = GetElement(self.m_root,"txt4_Friends",WZUILabelTTF)
    txt4:setScale(0.6)
    txt4:setDimensions(GlobalMethod:CCSize(220))

    local txtInviteFriends = GetElement(self.m_root, "txtInviteFriends_WndFriends", WZUILabelTTF)
    txtInviteFriends:setScale(0.7)
    local txtInviteFriendsNum = GetElement(self.m_root, "txtInviteFriendsNum_WndFriends", WZUILabelTTF)
    txtInviteFriendsNum:setScale(0.7)

end
-------------------------------------语言适配模块End----------------------------------------