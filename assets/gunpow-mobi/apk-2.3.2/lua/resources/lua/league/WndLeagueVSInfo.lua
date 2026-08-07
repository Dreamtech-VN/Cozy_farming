--WndLeagueVSInfo.lua
--@brief	WndLeagueVSInfo的UI模块
--@date		2016/06/21
--@author	Tianxiang_Xu
--@note		查看回放确认界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeagueVSInfo:onEnter(element)
	self.m_root = element
    ChangeChatChannel(Chat_Channel_League_CHECKVS)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeagueVSInfo:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调方法
function WndLeagueVSInfo:onEnterTransitionDidFinish(element)
    -- body
    WindowManagerAni:createAction(self.m_root,true,"onActionFinish",self)
end

--@brief    界面弹出动画完成回调
function WndLeagueVSInfo:onActionFinish()
    -- body
    self:_createLoading()
    ProtocolProcessorWndLeague:send_HERO_RecordMes(self.m_nTypeId, self.m_nRecordId)
end

--@brief    点击观看按钮回调
function WndLeagueVSInfo:onClickCheck(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self:_createLoading()
    ProtocolProcessorWndLeague:send_HERO_Record(self.m_nRecordId, self.m_nTypeId)
end

--@brief    关闭界面函数
function WndLeagueVSInfo:closeCallBack()
    -- body
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief    窗口动画关闭完成回调
function WndLeagueVSInfo:onCloseActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief    点击触摸开始回调
function WndLeagueVSInfo:onTouchBegin(element, pt)
    -- body
    if not self:checkPointInBtn(pt) then
        self:closeCallBack()
    end
end

--@brief    发送退出房间协议
function WndLeagueVSInfo:checkAndQuitRoom()
    -- body
    self:_closeLoading()
    --退出战队界面
    ProtocolProcessorWndLeague:send_HERO_OutHeroRoom()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新信息
function WndLeagueVSInfo:_update()
    -- body
    if self.m_tData == nil then return end
    --左战队信息
    local tLeftData = self.m_tData.tLeftTeamData
    --战队图标
    local conTeamIcon_Left = GetElement(self.m_root, "conTeamIcon_Left", WZUIContainer)
    local celElementL,tCellL = CellDownloadImg:createElement()
    conTeamIcon_Left:addChild(celElementL)

    SceneLeagueMain:addDownloadFileList(tLeftData.teamIcon, tCellL, nil, 68)
    --战队名字
    local txtTeamName_Left = GetElement(self.m_root, "txtTeamName_Left", WZUILabelTTF)
    txtTeamName_Left:setText(tLeftData.teamName)
    --战队ID
    local txtTeamID_Left = GetElement(self.m_root, "txtTeamID_Left", WZUILabelTTF)
    txtTeamID_Left:setText(LocalStrings.LEAGUE_REPLAY_TEXT1 .. tLeftData.teamId)
    --左边战队队员
    for i = 1, #tLeftData.player do
        local conMember = GetElement(self.m_root, string.format("conMember%d_Left", i), WZUIContainer)
        if tLeftData.player[i] then
            local celElement, tNewObj = CellTeamMember:createElement()
            if celElement then
                tNewObj:setData(tLeftData.player[i])
                tNewObj:resetRelativePosition()
                conMember:addChild(celElement)
            end
        end
    end

    --右战队信息
    local tRightData = self.m_tData.tRightTeamData
    --战队图标
    local conTeamIcon_Right = GetElement(self.m_root, "conTeamIcon_Right", WZUIContainer)
    local celElementR,tCellR = CellDownloadImg:createElement()
    conTeamIcon_Right:addChild(celElementR)

    SceneLeagueMain:addDownloadFileList(tRightData.teamIcon, tCellR, nil, 68)
    --战队名字
    local txtTeamName_Right = GetElement(self.m_root, "txtTeamName_Right", WZUILabelTTF)
    txtTeamName_Right:setText(tRightData.teamName)
    --战队ID
    local txtTeamID_Right = GetElement(self.m_root, "txtTeamID_Right", WZUILabelTTF)
    txtTeamID_Right:setText(LocalStrings.LEAGUE_REPLAY_TEXT1 .. tRightData.teamId)
    --右边战队队员
    for i = 1, #tRightData.player do
        local conMember = GetElement(self.m_root, string.format("conMember%d_Right", i), WZUIContainer)
        if tRightData.player[i] then
            local celElement, tNewObj = CellTeamMember:createElement()
            if celElement then
                tNewObj:setData(tRightData.player[i])
                conMember:addChild(celElement)
            end
        end
    end
end

function WndLeagueVSInfo:checkPointInBtn(pt)
    WZLog("WndLeagueVSInfo:checkPointInBtn",pt.x,pt.y)
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conMember1_Left", WZUIContainer)
    --获得btn的世界坐标
    local ptA 
    local btnSize
    if btn then 
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end
    btn = GetElement(self.m_root, "conMember2_Left", WZUIContainer)
    if btn then
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end
    btn = GetElement(self.m_root, "conMember3_Left", WZUIContainer)
    if btn then
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end
    btn = GetElement(self.m_root, "conMember1_Right", WZUIContainer)
    if btn then
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end
    btn = GetElement(self.m_root, "conMember2_Right", WZUIContainer)
    if btn then
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end
    btn = GetElement(self.m_root, "conMember3_Right", WZUIContainer)
    if btn then
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end

    btn = GetElement(self.m_root, "btnCheck_WndLeagueVSInfo", WZUIButton)
    if btn then
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end
    btn = GetElement(self.m_root, "conTeamIcon_Left", WZUIContainer)
    if btn then
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end
    btn = GetElement(self.m_root, "conTeamIcon_Right", WZUIContainer)
    if btn then
        btnSize = btn:getContentSize()
        ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
        if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
            return true
        end
    end
    
    return false
end

--@brief    网络加载界面
function WndLeagueVSInfo:_createLoading()
    -- body
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief    网络加载界面
function WndLeagueVSInfo:_closeLoading()
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    self.m_nLoadingId = nil 
end
-------------------------------------私有方法模块End----------------------------------------
