--CellMsgItem.lua
--@brief    CellMsgItem的UI模块
--@date     2016/05/18
--@author   qixiang_xie
--@note     聊天信息内容
local comCCSize = CCSize(0,0)

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function CellMsgItem:onEnter(element)
--  WZLog("CellMsgItem:onEnter")
    self.m_root = element
end

function CellMsgItem:onEnterTransitionDidFinish(element)

end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function CellMsgItem:onExit(element)
    if element then 
        local conMsg = element:setTag(1199)
        if conMsg then 
            local txtSendTS = GetElement(conMsg, "txtSendTS_WndChat", WZUILabelTTF)
            if txtSendTS then 
                txtSendTS:disableSchedule()
            end
        end
    end

    self:_unInit()
end

--@brief    同意
function CellMsgItem:onClickAgree(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local name = element:getName()
    name = tonumber(name)
    local nType = string.sub(self.m_data[name].nodeData.words,-2)
    ProtocolProcessorWndMaster:send_MENTORING_Processing(tonumber(self.m_data[name].nodeData.sendID), 1, tonumber(nType))
end

--@brief    拒绝
function CellMsgItem:onClickRefuse(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local name = element:getName()
    name = tonumber(name)
    local nType = string.sub(self.m_data[name].nodeData.words,-2)
    ProtocolProcessorWndMaster:send_MENTORING_Processing(tonumber(self.m_data[name].nodeData.sendID), 0, tonumber(nType))
end

--@brief    点击遗迹按钮回调
function CellMsgItem:onClickRemains(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if SceneBattle.m_root then return end
    if SceneBossRoom.m_root or SceneMarryCopy.m_root or SceneWorldTeamBossRoom.m_root or SceneCoupleHegemonyRoom.m_root or SceneGuildWarRoom.m_root or SceneRoom.m_root then
        MsgBoxManager:showTipBox(LocalStrings.CURRENT_ROOM_CANNOT_RELIC)
        return
    end
    local name = element:getName()
    name = tonumber(name)
    WndRemainsInfo:showInterface(self.m_data[name].nodeData.tabContent.mapId)
end
--点击小助手进入按钮
function CellMsgItem:onAssistantClick(element)
    if SceneBattle.m_root then return end
    local config = GDatatab_assistant["id_"..element:getTag()]
    if config and config.button ~= -1 then
        JumpByUIId(config.button)
        if WndChat.m_root then
            WindowManager:removeWindow(WndChat.m_root, WndChat, true)
            WndChat.m_root:setVisible(false)
        end
    end
end

--@brief    点击小助手好友新增好友圈提示回调
function CellMsgItem:onCircleFriendClick(element)
    -- body
    if SceneBattle.m_root then return end
    WZLog("CellMsgItem:onCircleFriendClick")
    WndFriends:showInterface(FRIENDCIRCLE_INDEX)
    if WndChat.m_root then
        WindowManager:removeWindow(WndChat.m_root, WndChat, true)
        WndChat.m_root:setVisible(false)
    end
end
function CellMsgItem:onHonourPointClick()
    WndHonorCheckShow:showInterface()
    if WndChat.m_root then
        WindowManager:removeWindow(WndChat.m_root, WndChat, true)
        WndChat.m_root:setVisible(false)
    end
end
--@brief  加载数据
function CellMsgItem:onLoadData(element)
    local index = element:getTag()
    local name = element:getName()
    local parent =WZUIFreeListContainer:luaTo(element:getParent():getParent())
    name = tonumber(name)
    
    local data = self.m_data[name]
    if data == nil then
        WZLog("onLoadData data = nil")
        return
    end

    local nodeData = data.nodeData
    local tbl = data.tbl
    if tbl == parent then
        if nodeData.mainChannel == CHANNEL_SYSTEM then
            self:createSystemItem(element,tbl, nodeData)
        else
            self:createWorldItem(element,tbl, nodeData)
        end
    end
end

function CellMsgItem:createWorldItem(element,tbl, nodeTempData)
    WZLog("CellMsgItem:createWorldItem = ",nodeTempData.words)
    local GetElement = GetElement
    if nodeTempData == nil or nodeTempData.sendID == nil or (nodeTempData.sendID <= 0 and nodeTempData.mainChannel ~= 2) then
       return
    end
    local nodeData = CopyTable(nodeTempData)
    if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
        local _string = SplitStringWithSeparator(nodeData.words, "|", nil, true)
        self.m_nRedPackId = _string[1]
        nodeData.words = LocalStrings.RED_PACK1[_string[2] or 1]
        self.m_nRedpackSkinId = _string[3] or 0
    end
    local bMasterMessage = false    --是否是拜师或收徒的信息
    if nodeData.mainChannel == CHANNEL_WHISPER then
        local sTempMsg = string.sub(nodeData.words, 1, 6)
        if sTempMsg == g_MasterMessage_Mark then
            bMasterMessage = true
            local sCurrentMsg = string.gsub(nodeData.words, g_MasterMessage_Mark, "")
            local _temp_str = sCurrentMsg
            local sStart, _end = string.find(sCurrentMsg, g_MasterMsgPrivate)
            if sStart then
                _temp_str = string.sub(sCurrentMsg, 1, tonumber(sStart)-1)
            end
            nodeData.words = _temp_str
        else
            local _temp_str1 = nodeData.words
            local sStart, _end = string.find(nodeData.words, g_MasterMsgPrivate)
            if sStart then
                _temp_str1 = string.sub(nodeData.words, 1, tonumber(sStart)-1)
            end
            nodeData.words = _temp_str1
        end
    end

    --遗迹聊天内容
    local bRemainsMessage = false
    local tabContent = nil
    if nodeData.mainChannel == CHANNEL_COPY or nodeData.mainChannel == CHANNEL_GUILD or nodeData.mainChannel == CHANNEL_CURRENT then
        local sStart,sEnd,sContent = string.find(nodeData.words,g_REMAINSMessage_Mark)
        if sContent then
            bRemainsMessage = true
            tabContent = json.decode(sContent)
            nodeData.words = tabContent.desc
            if nodeData.ownSend then
                nodeData.words = tabContent.desc..tabContent.text
            end

            local name = element:getName()
            name = tonumber(name)
            self.m_data[name].nodeData.tabContent = {}
            self.m_data[name].nodeData.tabContent = tabContent
        end
    end

    local tempMsg = nodeData.words
    if nodeData.mainChannel == CHANNEL_COPY then
        local indexx = string.find(nodeData.words,"##~")
        if indexx ~= nil and indexx > 0 then
            local teamRoomInfo = string.sub(nodeData.words,0,indexx-1)
            local teamRoomInfo2 = string.sub(nodeData.words,indexx+3)
            local tempT = SplitStringWithSeparator(teamRoomInfo2,"||")
            if tempT and #tempT == 2 then
                nodeData.words = teamRoomInfo
            end
        end
    end

    if nodeData.vipLevel then
        nodeData.vipLevel = tonumber(nodeData.vipLevel)
    end
    local GetElement = GetElement
    nodeData.words = self:removeLineFeed(nodeData.words)
    --by  hyx
    if nodeData.mainChannel == CHANNEL_WHISPER and nodeData.sendID == nodeData.recvID then --GM小助手发的消息
        local temp_str = nodeData.words
        nodeData.tempWords = temp_str   
        nodeData.words, nodeData.whisperTag = self:_getServerWord(nodeData.words)
        if nodeData.words == "" then
            nodeData.words = temp_str
        end
    else
        local newWords = shieldQQQunNum(nodeData.words)
        if newWords then 
            nodeData.words = newWords
            tempMsg = nodeData.words
        end
    end

    local pItem,pLblWords = self:_createOneItem(tbl, nodeData) --创建一条信息UI
    local parentSize = tbl:getContentSize()
    local worldSize = pLblWords:getLabelContentSize()
    --tbl:remove(pItem)
    WZLog("worldSize = ",worldSize.width)
    local cellItem = nil
    local bIsBoy = nSex ~= 1 and true or false
    if bIsBoy == true then
        if nodeData.head == nil then nodeData.head =  4903 end
        if nodeData.face == nil then nodeData.face =  4902 end
    else
        if nodeData.head == nil then nodeData.head =  4906 end
        if nodeData.face == nil then nodeData.face = 4905 end
    end
    if nodeData.head ~= nil then
        nodeData.head = tonumber(nodeData.head)
    end
    
    if nodeData.face ~= nil then
        nodeData.face = tonumber(nodeData.face)
    end

    if nodeData.bubbleId ~= nil and nodeData.bubbleId > 1 then --1：代表使用默认的聊天背景
        local itemInfo = GDatatab_item["id_" .. nodeData.bubbleId]
        self.m_strBubble = SplitStringWithSeparator(itemInfo.animation_index_code,",")
    end
	if nodeData.ownSend == nil or not nodeData.ownSend then  --不是自己发的信息
        WZLog("conMsgLeft_WndChat", nodeData.mainChannel, nodeData.chatType)
        if nodeData.mainChannel == CHANNEL_GOLD then 
            self:_createGoldSuonaMsg(element, nodeData, 0)
            return
        end
        local conMsgLeftSma = nil
        if nodeData.recordMsg then  --语音信息
            WZLog("conRecordLeftSma_WndChat")
            conMsgLeftSma = CreateElement("conRecordLeftSma_WndChat")
        else  --别的玩家发的信息显示在屏幕的左边
            conMsgLeftSma = CreateElement("conMsgLeft_WndChat")
            WZLog("conMsgLeft_WndChat")
        end
        cellItem = conMsgLeftSma
        conMsgLeftSma = WZUIContainer:luaTo(conMsgLeftSma)
        conMsgLeftSma:setVisible(true)
        local conMsg = GetElement(conMsgLeftSma,"conMsg_WndChat",WZUIContainer)
        local conMsgInfo = GetElement(conMsgLeftSma,"conMsgInfo_WndChat",WZUIContainer)
        local conRecord = nil
        local txtSendMsg = nil
        if nodeData.recordMsg  then
            txtSendMsg = GetElement(conMsgLeftSma,"txtSendMsg_WndChat",WZUILabelTTF)
            conRecord = GetElement(conMsgLeftSma,"conRecord_WndChat",WZUIContainer)
        end

        local conTranslate = GetElement(conMsgLeftSma,"conTranslate_WndChat",WZUIContainer)
        local imgBattleHelp = GetElement(conMsgLeftSma, "imgBattleHelp_WndChat", WZUIImage)
        local assist = 0 
        if CacheCenter:getPlayerInfo() then 
            assist = CacheCenter:getPlayerInfo().assistTime > 0 and 1 or 0
        end
        if assist == 1 and nodeData.mainChannel == CHANNEL_COPY and not bRemainsMessage then 
            imgBattleHelp:setVisible(true)
        else
            imgBattleHelp:setVisible(false)
        end
        if nodeData.recordMsg == nil or not nodeData.recordMsg then
            if YDMicrosoftTranslation and YDMicrosoftTranslation:needTranslation() and (nodeData.recordMsg == nil or not nodeData.recordMsg) then
                conTranslate:setVisible(true)
            else
                conTranslate:setVisible(false)
                imgBattleHelp:setRelativePosition(GlobalMethod:ccp(1, 0.5))
            end
        end
        
        self:resetSize(nodeData,conMsg,conMsgLeftSma,txtSendMsg,worldSize)

        local conMsgSize = conMsg:getAbsContentSize()
        local txtSendMsgS = GetElement(conMsgLeftSma,"txtSendMsgS_WndChat",WZUIFreeTextBox)
        if bMasterMessage then
            if conMsgSize.width < 320 then
                conMsgSize.width = 320
            end
            conMsg:setAbsContentSize(GlobalMethod:CCSize(conMsgSize.width, conMsgSize.height + 50))
        end
        conMsgSize = conMsg:getAbsContentSize()
        
        --遗迹聊天内容宽度
        if bRemainsMessage then
            if conMsgSize.width < 440 then
                conMsgSize.width = 440
            end
            conMsg:setAbsContentSize(GlobalMethod:CCSize(conMsgSize.width, conMsgSize.height))
        end
        conMsgSize = conMsg:getAbsContentSize()

        if nodeData.recordMsg then
            if (conMsgSize.width >= 424 and nodeData.mainChannel == CHANNEL_WHISPER) or conMsgSize.width >= 524 then
                conRecord:setRelativePosition(GlobalMethod:ccp(20/conMsgSize.width,0.845462))
            else
                conRecord:setRelativePosition(GlobalMethod:ccp(20/conMsgSize.width,0.803795))
            end
        end

        --如果是拜师或收徒信息，则显示按钮
        if bMasterMessage then
            local name = element:getName()

            if conMsg:getChildByTag(88) then conMsg:removeChildByTag(88, true) end
            local btnAgree = self:createResetBtn(LocalStrings.AGREE, 88, GlobalMethod:ccp(0.65, 0.23))
            btnAgree:setLuaDoneFunctionName("onClickAgree")
            btnAgree:setName(tostring(name))
            conMsg:addChild(btnAgree)

            if conMsg:getChildByTag(89) then conMsg:removeChildByTag(89, true) end
            local btnRefuse = self:createResetBtn(LocalStrings.REJECT, 89, GlobalMethod:ccp(0.35, 0.23))
            btnRefuse:setLuaDoneFunctionName("onClickRefuse")
            btnRefuse:setName(tostring(name))
            conMsg:addChild(btnRefuse)
        end

        --遗迹按钮
        if bRemainsMessage then
            local name = element:getName()
            name = tonumber(name)

            if conMsg:getChildByTag(90) then conMsg:removeChildByTag(90, true) end
            local btnReset = WZUIButton:create()
            btnReset:setUseAbsSize(true)
            btnReset:setAbsContentSize(GlobalMethod:CCSize(220, 58))
            btnReset:setRelativePosition(GlobalMethod:ccp(0.7, 0.4))
            btnReset:setTag(90)
            local txtValue = WZUILabelTTF:create()
            txtValue:setFontSize(24)
            txtValue:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            txtValue:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
            txtValue:setColor(GlobalMethod:ccc3(255,236,193))
            txtValue:setStrokeColor(GlobalMethod:ccc3(0,72,3))
            txtValue:setStrokeSize(4)
            txtValue:setEnableStroke(true)
            txtValue:setText(self.m_data[name].nodeData.tabContent.text)
            btnReset:addChild(txtValue)
            btnReset:setLuaDoneFunctionName("onClickRemains")
            btnReset:setName(tostring(name))
            conMsg:addChild(btnReset)

            if ProjConfig.LANGUAGE == "vn" then
                txtValue:setScale(0.6)
                btnReset:setAbsContentSize(GlobalMethod:CCSize(180, 58))
                btnReset:setRelativePosition(GlobalMethod:ccp(0.77, 0.4))
            end
        end
       
        local txtSendTS =  GetElement(conMsgLeftSma,"txtSendTS_WndChat",WZUILabelTTF)
        local conTitle = GetElement(conMsgLeftSma, "conTitle_WndChat", WZUIContainer)

        if nodeData.recordMsg then
            local txtMsgId = GetElement(conMsgLeftSma,"txtMsgId_WndChat",WZUILabelTTF)
            txtMsgId:setText(nodeData.messageId)

            conMsg:setTag(nodeData.sendID)
            local txtRecordSecond = GetElement(conMsgLeftSma,"txtRecordSecond_WndChat",WZUILabelTTF)
            txtRecordSecond:setText(nodeData.recordT .. "\"")
            txtSendMsg:setText(nodeData.words)
            local parentSize = conMsg:getAbsContentSize()
            local psx = (parentSize.width / 2 -1 ) / parentSize.width
            txtSendMsg:setRelativePosition(GlobalMethod:ccp(psx,0.0323684))
            local voideId = txtMsgId:getText()
            if WndChat.m_tPlayerVoiceId then
                local fileId = tostring(nodeData.messageId)
                local bPlayed = false --是否已播放过
                for i,v in ipairs(WndChat.m_tPlayerVoiceId) do
                   if v == voideId then
                        bPlayed = true
                        break
                   end
                end
                if not bPlayed then
                    local conPlayRecordS = GetElement(conMsgLeftSma,"conPlayRecordS_WndChat",WZUIContainer)
                    conPlayRecordS:setVisible(true)
                end
            end

            if parentSize.width > 150 then
                local conRecord = GetElement(conMsgLeftSma,"conRecord_WndChat",WZUIContainer)
                local wid = parentSize.width - 85
                if wid < 75 then
                    wid = 75
                end
                conRecord:setAbsContentSize(GlobalMethod:CCSize(wid,35))
            end
        else
            local parentSize = conMsg:getAbsContentSize()
            local txtSendMsgS = GetElement(conMsgLeftSma,"txtSendMsgS_WndChat",WZUIFreeTextBox)
            if nodeData.mainChannel == CHANNEL_WHISPER then
                txtSendMsgS:setMaxWidth(390)
            end
            if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
                if nodeData.mainChannel == CHANNEL_WHISPER then
                    txtSendMsgS:setMaxWidth(430)
                end
            end
            local _temp_str = nodeData.words
            if nodeData.mainChannel == CHANNEL_WHISPER and nodeData.sendID ~= nodeData.recvID then
                local sStart, _end = string.find(nodeData.words, g_MasterMsgPrivate)
                if sStart then
                    _temp_str = string.sub(nodeData.words, 1, tonumber(sStart)-1)
                end
            end
            local sColorString = "127,70,26"
            local specialOffset = 0
            if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
                sColorString = "255,255,255"
            else
                if self.m_strBubble then --1：代表使用默认的聊天背景
                    if self.m_strBubble[4] and self.m_strBubble[4] ~= "-1" then 
                        sColorString = string.gsub(self.m_strBubble[4], "|", ",")
                    end
                    if self.m_strBubble[7] then 
                        specialOffset = tonumber(self.m_strBubble[7])
                    end
                end
            end
            local freeText = ToChangeFreeText(_temp_str, sColorString)
            txtSendMsgS:setTag(1000)

            local psx = (25 + specialOffset) / parentSize.width
            if conMsgSize.width <= 80 then
            	psx = (30 + specialOffset) / parentSize.width
            end
            if bMasterMessage then
                txtSendMsgS:setRelativePosition(GlobalMethod:ccp(psx,0.6))
            else
                if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
                    txtSendMsgS:setRelativePosition(GlobalMethod:ccp(psx - 0.03,0.55))
                else
                    txtSendMsgS:setRelativePosition(GlobalMethod:ccp(psx, 0.409091))
                end
            end
            
            --0628增加功能跳转
            if nodeData.mainChannel == CHANNEL_WHISPER and nodeData.sendID == nodeData.recvID then --GM小助手发的消息
                self.m_sTxtSendMsgS = txtSendMsgS
                conMsg:setAbsContentSize(GlobalMethod:CCSize(420,66)) --直接写死吧
                self:_promptAssitant(conMsg, nodeData.words, nodeData.whisperTag, nodeData.tempWords)
                GetElement(conMsgLeftSma,"btnA_WndChat",WZUIButton):setTouchEnable(false)
            else
                txtSendMsgS:setShowText(freeText)
                GetElement(conMsgLeftSma,"btnA_WndChat",WZUIButton):setTouchEnable(true)
            end
            
            local elementRelativeSize = element:getRelativeSize()
            if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
                if nodeData.mainChannel == CHANNEL_WHISPER and nodeData.sendID == nodeData.recvID then --GM小助手发的消息
                    local tempHeight = 445 * elementRelativeSize.height - 110
                    conMsg:setAbsContentSize(GlobalMethod:CCSize(conMsg:getAbsContentSize().width,80+ tempHeight))
                end
            end
            if elementRelativeSize.height > 0.25 then 
                local tempHeight = 445 * elementRelativeSize.height - 110
                conMsgLeftSma:setAbsContentSize(GlobalMethod:CCSize(conMsgLeftSma:getAbsContentSize().width,110 + tempHeight))
                conMsgInfo:setAbsPosition(GlobalMethod:ccp(80,110 + tempHeight))
                conMsg:setAbsContentSize(GlobalMethod:CCSize(conMsg:getAbsContentSize().width,45+ tempHeight))
            end
        end
        --称号
        self:_createTitle(conTitle, nodeData.playerTitle)

        txtSendTS:setText(nodeData.tm)
        local conPlayerFigureS = GetElement(conMsgLeftSma,"conPlayerFigureS_WndChat",WZUIContainer)
        conPlayerFigureS:setTag(nodeData.sendID)

        if nodeData.mainChannel == CHANNEL_WHISPER and nodeData.sendID == nodeData.recvID then --GM小助手发的消息
            local image =  WZUIImage:create()
            image:setUseOriginSize(true)
            image:setFile("battle/head/npc_0002.png")
            image:setScale(0.75)
            conPlayerFigureS:addChild(image)
            image:setTouchEnable(false)
        elseif nodeData.mainChannel == CHANNEL_GUILD and nodeData.sendID == nodeData.recvID then --GM小助手发的公会boss被击杀消息
            local image =  WZUIImage:create()
            image:setUseOriginSize(true)
            image:setFile("battle/head/npc_0002.png")
            image:setScale(0.75)
            conPlayerFigureS:addChild(image)
            image:setTouchEnable(false)

            nodeData.playerPvpLevel = nil
            nodeData.serviceId = nil 
            GetElement(conMsgLeftSma,"btnA_WndChat",WZUIButton):setTouchEnable(false)
        else
            CellHead:show(conPlayerFigureS,nodeData.head,nodeData.face,nodeData.sex,nil,GlobalMethod:ccp(0.52,0.29),nil,nodeData.headColor, nil, nil, nil, nil, nodeData.headEffectId)
        end
        
        local txtSendMsgNameS= GetElement(conMsgLeftSma,"txtSendMsgNameS_WndChat",WZUILabelTTF)
        txtSendMsgNameS:setText(nodeData.sendName)

        local conVip = GetElement(conMsgLeftSma,"conVip_WndChat",WZUIContainer)
        
        self:_changeNColor(txtSendMsgNameS,nodeData.mainChannel,nodeData.vipLevel)

        if nodeData.vipLevel and nodeData.vipLevel > 0 then
            conVip:setVisible(true)
            local txtVip = GetElement(conVip, "ftxtVip_WndChat", WZUIFreeTextBox)
            --根据等级设置vip的图标
            local iconPath = setVipIconByVipLevel(nil, nodeData.vipLevel)
            --根据等级设置vip美术字
            local vipContent = self:getVipContent(iconPath, nodeData.vipLevel)
            txtVip:setShowText(vipContent)
        end

        local startPtX = 0.01

        --排位图标
        local imgPvpIcon = GetElement(conMsgLeftSma, "imgPvpIcon_WndChat", WZUIImage)
        local conVipRelPs = imgPvpIcon:getRelativePosition()
        if nodeData.playerPvpLevel then 
            local tTempData = GetPvpDataByLevel(nodeData.playerPvpLevel)
            if tTempData then
                imgPvpIcon:setFile("ui/common/" .. tTempData.icon .. ".png")
                imgPvpIcon:setVisible(true)

                startPtX = startPtX + 0.12
            else
                imgPvpIcon:setVisible(false)
            end
        else
            imgPvpIcon:setVisible(false)
        end

        --职业图标
        local imgProfessionIcon = GetElement(conMsgLeftSma, "imgProfessionIcon_WndChat", WZUIImage)
        WZLog("职业图标1",nodeData.professionId,nodeData.openStatus)
        if nodeData.professionId and nodeData.professionId > 0 then 
            if nodeData.openStatus == 1 then
                imgProfessionIcon:setFile(g_professionIcon[nodeData.professionId])
            elseif nodeData.openStatus == 2 then 
                imgProfessionIcon:setFile(g_professionIcon2[nodeData.professionId])
            end
            imgProfessionIcon:setRelativePosition(GlobalMethod:ccp(startPtX,conVipRelPs.y))
            imgProfessionIcon:setVisible(true)

            startPtX = startPtX + 0.11
        else
            imgProfessionIcon:setVisible(false)
        end

        local bCrossService = ISCrossService(nodeData.serviceId) --是否跨服聊天
        if bCrossService and not nodeData.recordMsg then
            local conCrossService = GetElement(conMsgLeftSma,"conCrossService_WndChat",WZUIContainer)
            conCrossService:setVisible(true)
            conCrossService:setRelativePosition(GlobalMethod:ccp(startPtX,conVipRelPs.y))

            startPtX = startPtX + 0.06
        end

        if nodeData.playerPhoto ~= nil  and nodeData.playerPhoto ~= "" and tonumber(nodeData.playerPhoto) ~= 0 then
            local conMsgInfo= GetElement(conMsgLeftSma,"conMsgInfo_WndChat",WZUIContainer)
            
            local playerHeadIcon = WZUIImage:create()
            playerHeadIcon:setUseOriginSize(true)
            playerHeadIcon:setAnchorPoint(GlobalMethod:ccp(0,0.5))
            playerHeadIcon:setFile("ui/chat/chat_marry_icon_ltzp.png")
            playerHeadIcon:setScale(0.9)
            conMsgInfo:addChild(playerHeadIcon)
            playerHeadIcon:setTouchEnable(false)
            playerHeadIcon:setRelativePosition(GlobalMethod:ccp(startPtX,conVipRelPs.y))

            startPtX = startPtX + 0.07
        end
        txtSendMsgNameS:setRelativePosition(GlobalMethod:ccp(startPtX, conVipRelPs.y))


        if nodeData.mainChannel == CHANNEL_WHISPER then
            WZLog("nodeData.mainChannel == CHANNEL_WHISPER")
            local txtWhisperS = GetElement(conMsgLeftSma,"txtWhisperS_WndChat",WZUILabelTTF)
            txtWhisperS:setVisible(true)
            txtWhisperS:setColor(GlobalMethod:ccc3(99,255,95))
            txtWhisperS:setText(LocalStrings.WHISPER_TO_ME)
            txtWhisperS:setTag(nodeData.recvID)

            local txtSendTSAdd = GetElement(conMsgLeftSma, "txtSendTSAdd_WndChat", WZUILabelTTF)
            txtSendTSAdd:setColor(GlobalMethod:ccc3(195,171,148))
            txtSendTSAdd:setText(nodeData.tm)
            if nodeData.playerTitle and nodeData.playerTitle ~= "" then
                txtSendTSAdd:setRelativePosition(GlobalMethod:ccp(1.1, 0.5))
            end
            txtSendTS:setVisible(false)
        end
        
        if not nodeData.recordMsg then
            GetElement(conMsgLeftSma,"btnA_WndChat",WZUIButton):setTag(nodeData.sendID+11)
        end
        if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
            GetElement(conMsgLeftSma, "btnA_WndChat", WZUIButton):setTag(self.m_nRedPackId)
        end
    else
        if nodeData.mainChannel == CHANNEL_GOLD then 
            self:_createGoldSuonaMsg(element, nodeData, 1)
            return
        end
        local conMsgRightSma = nil 
        if nodeData.recordMsg then
            conMsgRightSma = CreateElement("conRecordRightSma_WndChat")
        else
            conMsgRightSma = CreateElement("conMsgRight_WndChat")
        end
        conMsgRightSma = WZUIContainer:luaTo(conMsgRightSma)
        local conMsg = GetElement(conMsgRightSma,"conMsg_WndChat",WZUIContainer)
        local conRecord = nil
        local txtSendMsg = nil
        if nodeData.recordMsg  then
            txtSendMsg = GetElement(conMsgRightSma,"txtSendMsg_WndChat",WZUILabelTTF)
            conRecord = GetElement(conMsgRightSma,"conRecord_WndChat",WZUIContainer)
        end

        cellItem = conMsgRightSma
        conMsgRightSma = WZUIContainer:luaTo(conMsgRightSma)
        conMsgRightSma:setVisible(true)

        self:resetSize(nodeData,conMsg,conMsgRightSma,txtSendMsg,worldSize)
        local conMsgSize = conMsg:getAbsContentSize()
        if nodeData.recordMsg then
            if (conMsgSize.width >= 424 and nodeData.mainChannel == CHANNEL_WHISPER) or conMsgSize.width >= 524 then
                conRecord:setRelativePosition(GlobalMethod:ccp((conMsgSize.width - 22)/conMsgSize.width,0.845462))
            else
                conRecord:setRelativePosition(GlobalMethod:ccp((conMsgSize.width - 22)/conMsgSize.width,0.803795))
            end
        end

        local txtSendTRS =  GetElement(conMsgRightSma,"txtSendTRS_WndChat",WZUILabelTTF)
        local txtSendMsgNameRS= GetElement(conMsgRightSma,"txtSendMsgNameRS_WndChat",WZUILabelTTF)
        local conTitle = GetElement(conMsgRightSma, "conTitle_WndChat", WZUIContainer)
        local imgProfessionIcon = GetElement(conMsgRightSma, "imgProfessionIcon_WndChat", WZUIImage)

        --排位图标
        local imgPvpIcon = GetElement(conMsgRightSma, "imgPvpIcon_WndChat", WZUIImage)
        local nTempBit = 0
        if nodeData.playerPvpLevel then
            local tTempData = GetPvpDataByLevel(nodeData.playerPvpLevel)
            if tTempData then
                imgPvpIcon:setFile("ui/common/" .. tTempData.icon .. ".png")
                imgPvpIcon:setVisible(true)

                nTempBit = nTempBit + 1
            else
                imgPvpIcon:setVisible(false)
                imgProfessionIcon:setRelativePosition(GlobalMethod:ccp(0.89, 0.718))
            end
        else
            imgPvpIcon:setVisible(false)
            imgProfessionIcon:setRelativePosition(GlobalMethod:ccp(0.89, 0.718))
        end
        --职业图标
        if nodeData.professionId and nodeData.professionId > 0 then 
            WZLog("职业图标2",nodeData.professionId)
            WZLog("职业图标3",nodeData.openStatus)
            if CacheCenter:getPlayerInfo().professionAttr2 == "{}" then
                imgProfessionIcon:setFile(g_professionIcon[nodeData.professionId])
            else
                imgProfessionIcon:setFile(g_professionIcon2[nodeData.professionId])
            end
            imgProfessionIcon:setVisible(true)

            nTempBit = nTempBit + 1 
        else
            imgProfessionIcon:setVisible(false)
        end

        --称号
        if nTempBit == 1 then 
            conTitle:setRelativePosition(GlobalMethod:ccp(0.88, 0.718))
        elseif nTempBit == 2 then 
            conTitle:setRelativePosition(GlobalMethod:ccp(0.79, 0.718)) 
        elseif nTempBit == 0 then 
            conTitle:setRelativePosition(GlobalMethod:ccp(0.95, 0.718)) 
        end
        self:_createTitle(conTitle, nodeData.playerTitle)

        if nodeData.recordMsg then
            GetElement(conMsgRightSma,"txtMsgId_WndChat",WZUILabelTTF):setText(nodeData.messageId)
            conMsg:setTag(nodeData.sendID)
            txtSendMsg:setText(nodeData.words)
            local psxx = (conMsgSize.width / 2 - 2) / conMsgSize.width
            txtSendMsg:setRelativePosition(GlobalMethod:ccp(psxx,0.0323684))
            local conRecord = GetElement(conMsgRightSma,"conRecord_WndChat",WZUIContainer)
            if conMsgSize.width > 150 then
                local wid = conMsgSize.width - 85
                if wid < 75 then
                    wid = 75
                end
                conRecord:setAbsContentSize(GlobalMethod:CCSize(wid,35))
            end

            local txtRecordSecond = GetElement(conMsgRightSma,"txtRecordSecond_WndChat",WZUILabelTTF)
            txtRecordSecond:setText(nodeData.recordT .. "\"")

            local conRecordSize = conRecord:getAbsContentSize()
            psxx = (conRecordSize.width - 30) / conRecordSize.width
            txtRecordSecond:setRelativePosition(GlobalMethod:ccp(psxx,0.5))

            local imgVoice = GetElement(conMsgRightSma,"imgVoice_WndChat",WZUIImage)
            psxx = (conRecordSize.width - 7) / conRecordSize.width
            imgVoice:setRelativePosition(GlobalMethod:ccp(psxx,0.5))

            local armPlayRecord = GetElement(conMsgRightSma,"armPlayRecord_WndChat",WZUISpine)
            armPlayRecord:setRelativePosition(GlobalMethod:ccp(psxx,0.5))
        end
        
        
        if nodeData.mainChannel == CHANNEL_WHISPER then
            txtSendMsgNameRS:setText(nodeData.recvName)
        else
            txtSendMsgNameRS:setText(nodeData.sendName)
        end
        self:_changeNColor(txtSendMsgNameRS,nodeData.mainChannel,nodeData.vipLevel)
        if not nodeData.recordMsg then
            local txtSendMsgRS = GetElement(conMsgRightSma,"txtSendMsgRS_WndChat",WZUIFreeTextBox)
            if nodeData.mainChannel == CHANNEL_WHISPER then
                txtSendMsgRS:setMaxWidth(390)
            end
            if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
                if nodeData.mainChannel == CHANNEL_WHISPER then
                    txtSendMsgRS:setMaxWidth(430)
                end
            end
            
            local _temp_str3 = nodeData.words
            if nodeData.mainChannel == CHANNEL_WHISPER and nodeData.sendID ~= nodeData.recvID then
                local sStart, _end = string.find(nodeData.words, g_MasterMsgPrivate)
                if sStart then
                    _temp_str = string.gsub(nodeData.words, 1, tonumber(sStart)-1)
                end
            end
            local sColorString = "127,70,26"
            local specialOffsetX = 0
            if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
                sColorString = "255,255,255"
            else
                if self.m_strBubble then --1：代表使用默认的聊天背景
                    if self.m_strBubble[4] and self.m_strBubble[4] ~= "-1" then 
                        sColorString = string.gsub(self.m_strBubble[4], "|", ",")
                    end
                    if self.m_strBubble[7] then 
                        specialOffsetX = tonumber(self.m_strBubble[7])
                    end
                end
            end
            local freeText = ToChangeFreeText(_temp_str3, sColorString)
            txtSendMsgRS:setShowText(freeText)
            txtSendMsgRS:setTag(1000)
            local psxx = (25 + specialOffsetX) / conMsg:getAbsContentSize().width
            if conMsgSize.width <= 80 then
            	psxx = (30 + specialOffsetX) / conMsg:getAbsContentSize().width
            end

            if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
                txtSendMsgRS:setRelativePosition(GlobalMethod:ccp(psxx - 0.03, 0.55))
            else
                txtSendMsgRS:setRelativePosition(GlobalMethod:ccp(psxx,0.409091))
            end
            
            local elementRelativeSize = element:getRelativeSize()
            WZLog("elementRelativeSizeHeight2 = ",elementRelativeSize.height)
            if elementRelativeSize.height > 0.25 then 
                local tempHeight = 445 * elementRelativeSize.height - 110
                WZLog("tempHeightH2 = ",tempHeight)
                local conMsgInfo = GetElement(conMsgRightSma,"conMsgInfo_WndChat",WZUIContainer)
                conMsgRightSma:setAbsContentSize(GlobalMethod:CCSize(conMsgRightSma:getAbsContentSize().width,110 + tempHeight))
                conMsgInfo:setAbsPosition(GlobalMethod:ccp(460,110 + tempHeight))
                conMsg:setAbsContentSize(GlobalMethod:CCSize(conMsg:getAbsContentSize().width,45+ tempHeight))
            end
        end

        txtSendTRS:setText(nodeData.tm)
        local conPlayerFigureRS = GetElement(conMsgRightSma,"conPlayerFigureRS_WndChat",WZUIContainer)
        conPlayerFigureRS:setTag(nodeData.sendID)
        
        CellHead:show(conPlayerFigureRS,nodeData.head,nodeData.face,nodeData.sex,nil,GlobalMethod:ccp(0.52,0.29),nil,nodeData.headColor, nil, nil, nil, nil, nodeData.headEffectId)

        local txtWhisperRS = GetElement(conMsgRightSma,"txtWhisperRS_WndChat",WZUILabelTTF)
        local conVip = GetElement(conMsgRightSma,"conVip_WndChat",WZUIContainer)

        if nodeData.mainChannel == CHANNEL_WHISPER then
            txtWhisperRS:setVisible(true)
            txtWhisperRS:setText(LocalStrings.ME_TO_WHISPER)
            txtWhisperRS:setTag(nodeData.recvID+11)

            local txtSendTRSAdd = GetElement(conMsgRightSma, "txtSendTRSAdd_WndChat", WZUILabelTTF)
            txtSendTRSAdd:setText(nodeData.tm)
            txtSendTRS:setVisible(false)
        end
        
        if nodeData.vipLevel and nodeData.vipLevel > 0 then
            conVip:setVisible(true)
            local txtVip = GetElement(conVip,"ftxtVip_WndChat", WZUIFreeTextBox)
            --根据等级设置vip的图标
            local iconPath = setVipIconByVipLevel(nil, nodeData.vipLevel)
            --根据等级设置vip美术字
            local vipContent = self:getVipContent(iconPath, nodeData.vipLevel)
            txtVip:setShowText(vipContent)
            if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
                txtSendTRS:setFontSize(13)
            end
        end
        
        if not nodeData.recordMsg then
            GetElement(conMsgRightSma,"btnC_WndChat",WZUIButton):setTag(nodeData.sendID+11)
        end

        local imgBattleHelp = GetElement(conMsgRightSma, "imgBattleHelp_WndChat", WZUIImage)
        imgBattleHelp:setVisible(false)
        if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
            GetElement(conMsgRightSma, "btnC_WndChat", WZUIButton):setTag(self.m_nRedPackId)
            GetElement(cellItem,"imgMsgBg_WndChat",WZUI9Image):setScaleX(1)
        end
    end
    
    local tColorConfig = nil 
    if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
        local imgMsgBg = GetElement(cellItem,"imgMsgBg_WndChat",WZUI9Image)
        imgMsgBg:setRelativePosition(GlobalMethod:ccp(0.5, 0.42))
        if self.m_nRedpackSkinId == 0 then 
            imgMsgBg:setFile("ui/chat/talk_hb_1.png")
        else
            local basicData = GDatatab_item["id_" .. self.m_nRedpackSkinId]
            if basicData then 
                local filePath = string.gsub(basicData.icon, "common_lt_xzhb", "talk_hb")
                imgMsgBg:setFile(filePath)
            end
        end
    else
    	if self.m_strBubble then --1：代表使用默认的聊天背景
            local imgMsgBg = GetElement(cellItem,"imgMsgBg_WndChat",WZUI9Image)
            imagName = "ui/chat/" .. self.m_strBubble[1] ..".png"
            if self.m_strBubble[5] and self.m_strBubble[5] ~= "-1" then 
                local insetList = SplitStringWithSeparator(self.m_strBubble[5],"|", nil, true)
                imgMsgBg:setCapInsets(CCRectMake(insetList[1],insetList[2],insetList[3],insetList[4]))
            end
            imgMsgBg:setFile(imagName)
            if self.m_strBubble[4] and self.m_strBubble[4] ~= "-1" then 
                tColorConfig = SplitStringWithSeparator(self.m_strBubble[4],"|")
            end
        end
    end
    if (nodeData.mainChannel == CHANNEL_COLORCHAT and cellItem ~= nil) or nodeData.mainChannel == CHANNEL_COPY then
        local imgCrossService = GetElement(cellItem,"imgCrossService_WndChat",WZUIImage)
        imgCrossService:setVisible(true)
        
        local conMsg = GetElement(cellItem,"conMsg_WndChat",WZUIContainer)
        local conMsgSize = conMsg:getAbsContentSize()
        local anchorPoint = imgCrossService:getAnchorPoint()

        if anchorPoint.x == 1 then
            if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
                imgCrossService:setRelativePosition(GlobalMethod:ccp((conMsgSize.width) /conMsgSize.width, -0.08))
            else
                imgCrossService:setRelativePosition(GlobalMethod:ccp((conMsgSize.width -14) /conMsgSize.width,imgCrossService:getRelativePosition().height))
            end
        else
            if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
                imgCrossService:setRelativePosition(GlobalMethod:ccp(0,-0.08))
            else
                imgCrossService:setRelativePosition(GlobalMethod:ccp(12/conMsgSize.width,imgCrossService:getRelativePosition().height))
            end
        end
    end

    local txtTemp = GetElement(cellItem,"txtTemp_WndChat",WZUILabelTTF)
    if txtTemp then
        if tColorConfig then 
            txtTemp:setColor(GlobalMethod:ccc3(tColorConfig[1],tColorConfig[2],tColorConfig[3]))
        end
        txtTemp:setText(tempMsg)
    end

    local conMsgInfo = GetElement(cellItem,"conMsgInfo_WndChat",WZUIContainer)
    conMsgInfo:setTag(nodeData.sendID+33)
    cellItem:setTag(1199)
    element:addChild(cellItem)
    return pItem
end
--小助手功能跳转 -----start
--获取文字
function CellMsgItem:_getServerWord(words)
    --根据指定的子串规则来提取出数字
    local text = ""
    local index1 = nil
    local index = string.match(words,"{^ttyy##%d+##")
    local circleMark = string.find(words, g_FriendCircleMessage_Mark)
    if index then
        index1 = string.match(index,"%d+")
        if index1 then
            local config = GDatatab_assistant["id_"..index1]
            if config then
                text = string.gsub(config.test1, "\"", "")
            end
        end
    elseif circleMark then 
        text = string.gsub(words, g_FriendCircleMessage_Mark, "")
    end
    return text, index1
end
function CellMsgItem:_promptAssitant(nodeMsg, words, whisperTag, originWords)
    if not nodeMsg then return end
    words = words or ""    
    self.m_sTxtSendMsgS:setRelativePosition(GlobalMethod:ccp(0.05, 0.40))

    local bHonourPoint = false
    local nHonour, _end = string.find(words, g_HonourMessage_Mark)
    if nHonour then
        bHonourPoint = true
        words = string.sub(words,_end+1)
    end
        
    local status, _index, index_end = self:setAssiantSpecialChat(words)
    if status then
        words = string.sub(words,index_end+1)
        
        whisperTag = _index
    end

    self.m_sTxtSendMsgS:setShowText(ToChangeFreeText(words))
    local btnAssistant = WZUIButton:create()
    btnAssistant:setUseAbsSize(true)
    btnAssistant:setAnchorPoint(GlobalMethod:ccp(1,0))
    local config = nil
    local bCircleFriend = false 
    if originWords then 
        local nStart = string.find(originWords, g_FriendCircleMessage_Mark)
        if nStart then 
            bCircleFriend = true
        end
    end
    
    if not bCircleFriend then 
        btnAssistant:setAbsContentSize(GlobalMethod:CCSize(150, 50))
        btnAssistant:setRelativePosition(GlobalMethod:ccp(0.96, 0))
        if whisperTag then
            btnAssistant:setTag(whisperTag)
            config = GDatatab_assistant["id_"..whisperTag]
        end
        if config and config.buttonid ~= -1 then
            local txtValue = WZUILabelTTF:create()
            txtValue:setFontSize(14)
            txtValue:setAnchorPoint(GlobalMethod:ccp(1,0))
            txtValue:setRelativePosition(GlobalMethod:ccp(1,0))
            txtValue:setColor(GlobalMethod:ccc3(255,236,193))
            txtValue:setStrokeColor(GlobalMethod:ccc3(0,72,3))
            txtValue:setStrokeSize(4)
            txtValue:setEnableStroke(true)
            txtValue:setText("["..LocalStrings.TOUCH_COME_IN.."]")
            btnAssistant:setLuaDoneFunctionName("onAssistantClick")
            btnAssistant:addChild(txtValue)
            nodeMsg:addChild(btnAssistant)
        end
    else
        WZLog("CellMsgItem:_promptAssitant")
        btnAssistant:setUseAbsSize(false)
        btnAssistant:setRelativePosition(GlobalMethod:ccp(1, 0))
        btnAssistant:setLuaDoneFunctionName("onCircleFriendClick")
        nodeMsg:addChild(btnAssistant)
    end
    if bHonourPoint == true then
        local txtValue = WZUILabelTTF:create()
        txtValue:setFontSize(14)
        txtValue:setAnchorPoint(GlobalMethod:ccp(1,0))
        txtValue:setRelativePosition(GlobalMethod:ccp(1,0))
        txtValue:setColor(GlobalMethod:ccc3(255,236,193))
        txtValue:setStrokeColor(GlobalMethod:ccc3(0,72,3))
        txtValue:setStrokeSize(4)
        txtValue:setEnableStroke(true)
        txtValue:setText("["..LocalStrings.TOUCH_COME_IN.."]")
        btnAssistant:setLuaDoneFunctionName("onHonourPointClick")
        btnAssistant:addChild(txtValue)
        nodeMsg:addChild(btnAssistant)
    end
end
--小助手功能跳转 -----end

--@brief    创建一条信息UI
--@param    tbl:各频道的freelist
--@param    nodeData:一条信息
function CellMsgItem:_createOneItem(tbl, nodeData)
    WZLog("CellMsgItem:_createOneItem")
    local pItem = WZUIContainer:create()
    self.m_tComCCPoint.x = 0.5
    self.m_tComCCPoint.y = 0.5
    pItem:setAnchorPoint(self.m_tComCCPoint)
    
    self.m_tComCCPoint.x = 0
    self.m_tComCCPoint.y = 0

    --内容
    local sContent = nodeData.words
    local temp = sContent
    if not nodeData.recordMsg then
        for i,v in pairs(WndChat.FACEIMASK) do
            temp = string.gsub(temp,v,"AAA")
        end
    end
    
    
    local pLblWords = WZUILabelTTF:create()
    pLblWords:setText(temp)

    pLblWords:setAlignment(kCCTextAlignmentLeft)
    pLblWords:setColor(GlobalMethod:ccc3(255,89,74))
    pLblWords:setFontSize(self.m_Define.fontsize)
    if nodeData.mainChannel == CHANNEL_SYSTEM and nodeData.sendName ~= LocalStrings.TIP then
        pLblWords:setColor(GlobalMethod:ccc3(255,236,193))
        pLblWords:setEnableStroke(true)
        pLblWords:setStrokeColor(GlobalMethod:ccc3(132,66,29))
        pLblWords:setStrokeSize(4)
        pLblWords:setFontSize(18)
    elseif nodeData.mainChannel == CHANNEL_SYSTEM and nodeData.sendName == LocalStrings.TIP then
        pLblWords:setColor(GlobalMethod:ccc3(255,236,193))
        pLblWords:setEnableStroke(true)
        pLblWords:setStrokeColor(GlobalMethod:ccc3(132,66,29))
        pLblWords:setStrokeSize(4)
        pLblWords:setFontSize(18)
    end
    pLblWords:setAnchorPoint(self.m_tComCCPoint)
    pLblWords:setTag(1000)
    pItem:addChild(pLblWords)   
    return pItem,pLblWords
end

function CellMsgItem:resetSize(nodeData,conMsg,conMsgParent,txtSendMsg,worldSize)
    -- body
    WZLog("CellMsgItem:resetSize")
    local bResetSize = true
    local addWidth = 0 --专属表情的额外宽度
    local tSpecialFace = getLimitFaceNum(nodeData.words)
--    WZLog("CellMsgItem:resetSize", type(tSpecialFace), Serialize(tSpecialFace))
    for k,v in pairs(tSpecialFace) do
        local tmpWidth = 1
        if k == 32 then
            tmpWidth = 28
        elseif k == 33 or k == 34 or k == 35 then
            tmpWidth = 20
        elseif k == 41 then
            tmpWidth = 40
        elseif k == 42 then
            tmpWidth = 90
        elseif k == 43 then
            tmpWidth = 80
        elseif k == 45 then
            tmpWidth = 10
        elseif k == 47 then
            tmpWidth = 25
        elseif k == 48 then
            tmpWidth = 50
        end
        addWidth = addWidth + v * tmpWidth
    end
    if nodeData.chatType and (nodeData.chatType == 9 or nodeData.chatType == 10) then 
        addWidth = 30
    end
    if self.m_strBubble and self.m_strBubble[6] then 
        addWidth = addWidth + tonumber(self.m_strBubble[6])
    end

    if nodeData.mainChannel == CHANNEL_WHISPER then
        if worldSize.width > self.m_Define.fontsize*19-10 then -- 发送的私聊信息超过19个字
            if nodeData.recordMsg then
                conMsgParent:setAbsContentSize(GlobalMethod:CCSize(536 + addWidth,135))
                conMsg:setAbsContentSize(GlobalMethod:CCSize(424 + addWidth,96))
                txtSendMsg:setDimensions(GlobalMethod:CCSize(390,0))
                bResetSize = false
            end
        end
    else
        if worldSize.width > self.m_Define.fontsize*24-10  then -- 发送的私聊信息超过24个字
            if nodeData.recordMsg then
                conMsgParent:setAbsContentSize(GlobalMethod:CCSize(536 + addWidth,135))
                conMsg:setAbsContentSize(GlobalMethod:CCSize(524 + addWidth,96))
                txtSendMsg:setDimensions(GlobalMethod:CCSize(480,0))
                bResetSize = false
            end
        end
    end
        
    if bResetSize then
        local wSizeW = worldSize.width
        if wSizeW <= 80 then
            if (nodeData.recordMsg == nil or not nodeData.recordMsg) then
                conMsg:setAbsContentSize(GlobalMethod:CCSize(140 + addWidth,66))
            else
                conMsg:setAbsContentSize(GlobalMethod:CCSize(140 + addWidth,76))
            end
        else
            if (nodeData.recordMsg == nil or not nodeData.recordMsg) then
                if nodeData.mainChannel == CHANNEL_WHISPER then
                    if wSizeW+50 < 424 then
                        conMsg:setAbsContentSize(GlobalMethod:CCSize(wSizeW+50 + addWidth,66))
                    else
                        conMsg:setAbsContentSize(GlobalMethod:CCSize(424 + addWidth,66))
                    end
                else
                    if wSizeW+50 < 514 then
                        conMsg:setAbsContentSize(GlobalMethod:CCSize(wSizeW+50 + addWidth,66))
                    else
                        conMsg:setAbsContentSize(GlobalMethod:CCSize(524 + addWidth,66))
                    end
                end
            else
                if wSizeW > 80 then
                    if nodeData.mainChannel ~= CHANNEL_WHISPER then
                        if wSizeW + 50 < 514 then
                            conMsg:setAbsContentSize(GlobalMethod:CCSize(wSizeW+50 + addWidth,76))
                        else
                            conMsg:setAbsContentSize(GlobalMethod:CCSize(524 + addWidth,76))
                        end
                    else
                        if wSizeW + 50 < 424 then
                            conMsg:setAbsContentSize(GlobalMethod:CCSize(wSizeW+50 + addWidth,76))
                        else
                            conMsg:setAbsContentSize(GlobalMethod:CCSize(424 + addWidth,76))
                        end
                    end
                else
                    conMsg:setAbsContentSize(GlobalMethod:CCSize(140 + addWidth,76))
                end
            end
        end
    end
end

function CellMsgItem:createSystemItem(element,tbl,nodeData)
    WZLog("CellMsgItem:createSystemItem")
    nodeData.words = self:removeLineFeed(nodeData.words)
    local pItem,pLblWords = self:_createOneItem(tbl, nodeData) --创建一条信息UI
    local parentSize = tbl:getContentSize()
    local cellSizeHeight = 0
    local cellSizeWigth = parentSize.width

    if nodeData.sendName == LocalStrings.TIP then
       nodeData.mainChannelName = LocalStrings.TIP
    end
    
    local systemContents =  nodeData.mainChannelName..pLblWords:getText()
    systemContents =  nodeData.mainChannelName..pLblWords:getText()
    pLblWords:setText(systemContents)
    pLblWords:setAlignment(kCCTextAlignmentLeft)
    local worldSize = pLblWords:getLabelContentSize()
    
    pLblWords:setDimensions(GlobalMethod:CCSize(23*self.m_Define.fontsize,0))
    local lineCount =math.ceil(worldSize.width/(23*self.m_Define.fontsize))
    lineCount = lineCount*31
    cellSizeHeight = lineCount

    local centerY = (cellSizeHeight/2- cellSizeHeight+ cellSizeHeight/2)/cellSizeHeight
    self.m_tComCCPoint.x = 0.05
    self.m_tComCCPoint.y = centerY
    
    pLblWords:setRelativePosition(self.m_tComCCPoint)
    element:addChild(pItem)
end

--@brief  删除换行符
--@param  msgContent:需要查找的字符串
function CellMsgItem:removeLineFeed(msgContent)
    WZLog("CellMsgItem:removeLineFeed")
    local index = string.find(msgContent,"\n",0)
    if index ~= nil and tonumber(index) > 0 then
        msgContent = string.gsub(msgContent,"\n","")
    end
    return msgContent
end

function CellMsgItem:_changeNColor(ttf,channel,vipLevel)
    WZLog("CellMsgItem:_changeNColor")
    if channel == CHANNEL_CURRENT then
        ttf:setColor(GlobalMethod:ccc3(255,255,255))
    elseif channel == CHANNEL_WORLD or channel == CHANNEL_COLORCHAT or channel == CHANNEL_GOLD then
        ttf:setColor(GlobalMethod:ccc3(198,130,255))
        if vipLevel and vipLevel >= 21 then
            --vip21名称显示为金色255,227,116 描边132,66,29
            ttf:setColor(GlobalMethod:ccc3(255,227,116))
            ttf:setStrokeColor(GlobalMethod:ccc3(132,66,29))
            ttf:setStrokeSize(4)
            ttf:setEnableStroke(true)
        end
    elseif channel == CHANNEL_GUILD then
        ttf:setColor(GlobalMethod:ccc3(255,121,31))
    elseif channel == CHANNEL_WHISPER then
        ttf:setColor(GlobalMethod:ccc3(199,139,255))
    elseif channel == CHANNEL_TEAM then
        ttf:setColor(GlobalMethod:ccc3(233,166,62))
    end
end

--@brief    创建称号
function CellMsgItem:_createTitle(conTitle, playerTitle)
    -- body
    --称号
    if playerTitle and playerTitle ~= "" then
        --如果称号含有特效id，则去掉
        local sTitleName = SplitStringWithSeparator(playerTitle,"&")
        local sNewTitle, nLetterNum = string.gsub(playerTitle, "&", ",")

        local sTempTitle = playerTitle
        if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
            if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then
            else
                sTempTitle = sTitleName[1]
            end
        end
        local nInputTxtLen = WndBag:_checkInputTxtLen(sTempTitle)
        conTitle:setAbsContentSize(GlobalMethod:CCSize(nInputTxtLen * 11, 26))
        conTitle:updateRelativeSize()

        local playerTitleBg = WZUIImage:create()
        playerTitleBg:setFile("ui/chat/chat_talk_titlebk.png")
        conTitle:addChild(playerTitleBg)
        playerTitleBg:setTouchEnable(false)

        --称号
        local txtTitle = WZUILabelTTF:create()
        txtTitle:setText(sTempTitle)
        txtTitle:setFontSize(20)
        txtTitle:setColor(GlobalMethod:ccc3(255,227,116))
        conTitle:addChild(txtTitle)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    觉醒界面创建重置按钮
function CellMsgItem:createResetBtn(textBtn, nTag, rPt)
    -- body
    local btnReset = WZUIButton:create()
    btnReset:setUseAbsSize(true)
    btnReset:setAbsContentSize(GlobalMethod:CCSize(116, 58))
    btnReset:setRelativePosition(rPt)
    btnReset:setScale(0.7)
    btnReset:setTag(nTag)

    local imgNor = WZUIImage:create()
    imgNor:setUseOriginSize(true)
    imgNor:setFile("ui/common/common_btn_05.png")
    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/common/common_btn_05.png")

    btnReset:setNormalElement(imgNor)
    btnReset:setSelectElement(imgSel)

    local txtValue = WZUILabelTTF:create()
    txtValue:setFontSize(24)
    txtValue:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txtValue:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    txtValue:setColor(GlobalMethod:ccc3(255,250,236))
    txtValue:setStrokeColor(GlobalMethod:ccc3(163,74,20))
    txtValue:setStrokeSize(4)
    txtValue:setEnableStroke(true)
    txtValue:setText(textBtn)
    btnReset:addChild(txtValue)

    return btnReset
end

--@brief    创建金喇叭消息
--@param    dirIndex : 0=别人发的消息；1玩家自己发的消息
function CellMsgItem:_createGoldSuonaMsg(element, nodeData, dirIndex)
    local cellItem = nil
    local conMsgLeftSma = nil
    if nodeData.recordMsg then  --语音信息
        WZLog("conRecordLeftSmaGold_WndChat")
        if dirIndex == 0 then 
            conMsgLeftSma = CreateElement("conRecordLeftSmaGold_WndChat")
        else
            conMsgLeftSma = CreateElement("conRecordRightSmaGold_WndChat")
        end
    else  --别的玩家发的信息显示在屏幕的左边
        if dirIndex == 0 then 
            conMsgLeftSma = CreateElement("conMsgLeftGold_WndChat")
        else
            conMsgLeftSma = CreateElement("conMsgRightGold_WndChat")
        end
        WZLog("conMsgLeftGold_WndChat")
    end
    cellItem = conMsgLeftSma
    conMsgLeftSma = WZUIContainer:luaTo(conMsgLeftSma)
    conMsgLeftSma:setVisible(true)
    local conMsg = GetElement(conMsgLeftSma,"conMsg_WndChat",WZUIContainer)
    local conMsgInfo = GetElement(conMsgLeftSma,"conMsgInfo_WndChat",WZUIContainer)
    local conRecord = nil
    local txtSendMsg = nil
    if nodeData.recordMsg  then
        txtSendMsg = GetElement(conMsgLeftSma,"txtSendMsg_WndChat",WZUILabelTTF)
        conRecord = GetElement(conMsgLeftSma,"conRecord_WndChat",WZUIContainer)
    end

    local conTranslate = GetElement(conMsgLeftSma,"conTranslate_WndChat",WZUIContainer)
    if nodeData.recordMsg == nil or not nodeData.recordMsg then
        if YDMicrosoftTranslation and YDMicrosoftTranslation:needTranslation() and (nodeData.recordMsg == nil or not nodeData.recordMsg) then
            conTranslate:setVisible(true)
        else
            conTranslate:setVisible(false)
        end
    end
    
    local conMsgSize = conMsg:getAbsContentSize()
    local txtSendMsgS = GetElement(conMsgLeftSma,"txtSendMsgS_WndChat",WZUIFreeTextBox)
    
    if nodeData.recordMsg then
        if conMsgSize.width >= 524 then
            conRecord:setRelativePosition(GlobalMethod:ccp(20/conMsgSize.width,0.845462))
        else
            conRecord:setRelativePosition(GlobalMethod:ccp(20/conMsgSize.width,0.803795))
        end
    end
   
    local txtSendTS =  GetElement(conMsgLeftSma,"txtSendTS_WndChat",WZUILabelTTF)

    if nodeData.recordMsg then
        local txtMsgId = GetElement(conMsgLeftSma,"txtMsgId_WndChat",WZUILabelTTF)
        txtMsgId:setText(nodeData.messageId)

        conMsg:setTag(nodeData.sendID)
        local txtRecordSecond = GetElement(conMsgLeftSma,"txtRecordSecond_WndChat",WZUILabelTTF)
        txtRecordSecond:setText(nodeData.recordT .. "\"")
        txtSendMsg:setText(nodeData.words)
        local parentSize = conMsg:getAbsContentSize()
        local psx = (parentSize.width / 2 -1 ) / parentSize.width
        txtSendMsg:setRelativePosition(GlobalMethod:ccp(psx,0.0323684))
        local voideId = txtMsgId:getText()
        if WndChat.m_tPlayerVoiceId then
            local fileId = tostring(nodeData.messageId)
            local bPlayed = false --是否已播放过
            for i,v in ipairs(WndChat.m_tPlayerVoiceId) do
               if v == voideId then
                    bPlayed = true
                    break
               end
            end
            if not bPlayed then
                local conPlayRecordS = GetElement(conMsgLeftSma,"conPlayRecordS_WndChat",WZUIContainer)
                conPlayRecordS:setVisible(true)
            end
        end

        if parentSize.width > 150 then
            local conRecord = GetElement(conMsgLeftSma,"conRecord_WndChat",WZUIContainer)
            local wid = parentSize.width - 85
            if wid < 75 then
                wid = 75
            end
            conRecord:setAbsContentSize(GlobalMethod:CCSize(wid,35))
        end
    else
        local _temp_str = nodeData.words
        local sColorString = "255,236,193"
        local freeText = ToChangeFreeText(_temp_str, sColorString)
        txtSendMsgS:setTag(1000)
        
        txtSendMsgS:setShowText(freeText)
        GetElement(conMsgLeftSma,"btnA_WndChat",WZUIButton):setTouchEnable(true)
    end

    self.m_nDelSeconds = tonumber(CacheCenter:getGameParam().goldChatTime or 10)
    txtSendTS:setText(self.m_nDelSeconds .. "S")
    local conPlayerFigureS = GetElement(conMsgLeftSma,"conPlayerFigureS_WndChat",WZUIContainer)
    conPlayerFigureS:setTag(nodeData.sendID)

    CellHead:show(conPlayerFigureS,nodeData.head,nodeData.face,nodeData.sex,nil,GlobalMethod:ccp(0.52,0.29),nil,nodeData.headColor, nil, nil, nil, nil, nodeData.headEffectId)
    
    local conVip = GetElement(conMsgLeftSma,"conVip_WndChat",WZUIContainer)
    
    if nodeData.vipLevel and nodeData.vipLevel > 0 then
        conVip:setVisible(true)
        local txtVip = GetElement(conVip, "ftxtVip_WndChat", WZUIFreeTextBox)
        --根据等级设置vip的图标
        local iconPath = setVipIconByVipLevel(nil, nodeData.vipLevel)
        --根据等级设置vip美术字
        local vipContent = self:getVipContent(iconPath, nodeData.vipLevel)
        txtVip:setShowText(vipContent)
    end

    if not nodeData.recordMsg then
        GetElement(conMsgLeftSma,"btnA_WndChat",WZUIButton):setTag(nodeData.sendID+11)
    end
    
    GetElement(conMsgLeftSma, "btnDel_WndChat", WZUIButton):setTag(nodeData.msgIndex)
    txtSendTS:setTag(nodeData.msgIndex)

    local conMsgInfo = GetElement(cellItem,"conMsgInfo_WndChat",WZUIContainer)
    conMsgInfo:setTag(nodeData.sendID+33)
    cellItem:setTag(1199)
    element:addChild(cellItem)
    txtSendTS:enableSchedule("caculateTime", 1)

    return cellItem
end

--@brief    金喇叭消息倒计时
function CellMsgItem:caculateTime(element)
    WZLog("CellMsgItem:caculateTime", self.m_nDelSeconds)
    if self.m_nDelSeconds > 0 then 
        self.m_nDelSeconds = self.m_nDelSeconds - 1
        local txtSendTS = WZUILabelTTF:luaTo(element)
        if txtSendTS then 
            txtSendTS:setText(self.m_nDelSeconds .. "S")
        end
    else
        element:disableSchedule()

        local nTag = element:getTag()
        WndChat:delGoldMsg(nTag)
    end
end

--根据等级设置vip美术字
function CellMsgItem:getVipContent(iconPath, vipLevel)
    WZLog("CellMsgItem:getVipContent", iconPath, vipLevel)
    if not vipLevel or not iconPath then
        return ""
    end
    --Vip1-vip14用原来默认的不变
    --local vipContent = string.format([[<I Z="0.8" P="1">%s</I><I Z="0.35" P="1">ui/chat/caht_commom_icon_v.png</I><A IMG = "ui/common_num/common_num_vip.png" Z ="0.4" W = "22" H = "40" CHAR = "0" P="1">%d</A>]], iconPath, vipLevel)
    local vipContent = ""
    if vipLevel >= 1 and vipLevel <= 15 then
        --中级vip:Vip1-vip15
        vipContent = string.format([[<I Z="0.8" P="1">%s</I><I Z="0.95" P="1">ui/chat/common_icon_vip_zj.png</I><A IMG = "ui/common_num/common_icon_vip_zj_num.png" Z ="0.95" W = "11" H = "15" CHAR = "0" P="1">%d</A>]], iconPath, vipLevel)
    elseif vipLevel >= 16 and vipLevel <= 22 then
        --高级vip:Vip16-vip22
        vipContent = string.format([[<I Z="0.8" P="1">%s</I><I Z="1" P="1">ui/chat/common_icon_vip_gj.png</I><A IMG = "ui/common_num/common_icon_vip_gj_num.png" Z ="1" W = "11" H = "15" CHAR = "0" P="1">%d</A>]], iconPath, vipLevel)
    elseif vipLevel >= 23 then
        --顶级vip:Vip23+
        vipContent = string.format([[<I Z="0.8" P="1">%s</I><I Z="1" P="1">ui/chat/common_icon_vip_dj.png</I><A IMG = "ui/common_num/common_icon_vip_dj_num.png" Z ="1" W = "12" H = "15" CHAR = "0" P="1">%d</A>]], iconPath, vipLevel)
    end
    --WZLog("CellMsgItem:getVipContent", vipContent)
    return vipContent or ""
end
-------------------------------------私有方法模块End----------------------------------------
