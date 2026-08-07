--CellMsgItem.lua
--@brief	CellMsgItem的UI模块
--@date		2016/05/18
--@author	qixiang_xie
--@note		聊天信息内容
local comCCPoint = ccp(0,0)
local comCCSize = CCSize(0,0)

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMsgItem:onEnter(element)
	WZLog("CellMsgItem:onEnter")
	self.m_root = element
end

function CellMsgItem:onEnterTransitionDidFinish(element)
	WZLog("CellMsgItem:onEnterTransitionDidFinish")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMsgItem:onExit(element)
	self:_unInit()
end

--@brief    点击同意按钮回调
function CellMsgItem:onClickAgree(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local name = element:getName()
    name = tonumber(name)
    ProtocolProcessorWndMaster:send_MENTORING_Processing(tonumber(self.m_data[name].nodeData.sendID), 1 )

end

--@brief    点击同意按钮回调
function CellMsgItem:onClickRefuse(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local name = element:getName()
    name = tonumber(name)
    WZLog("CellMsgItem:onClickRefuse", Serialize(self.m_data[name]))
    ProtocolProcessorWndMaster:send_MENTORING_Processing(tonumber(self.m_data[name].nodeData.sendID), 0 )
end

--@brief  加载数据
function CellMsgItem:onLoadData(element)
	WZLog("CellMsgItem:onLoadData..........")
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
	if nodeTempData == nil or nodeTempData.sendID == nil or nodeTempData.sendID <= 0 then
	   return
	end
    local nodeData = CopyTable(nodeTempData)
    local bMasterMessage = false    --是否是拜师或收徒的信息
    if nodeData.mainChannel == CHANNEL_WHISPER then
        local sTempMsg = string.sub(nodeData.words, 1, 6)
        if sTempMsg == g_MasterMessage_Mark then
            bMasterMessage = true
            local sCurrentMsg = string.gsub(nodeData.words, g_MasterMessage_Mark, "")
            nodeData.words = sCurrentMsg
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
	
	if nodeData.ownSend == nil or not nodeData.ownSend then  --不是自己发的信息
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
        if nodeData.recordMsg == nil or not nodeData.recordMsg then
        	if YDMicrosoftTranslation and YDMicrosoftTranslation:needTranslation() and (nodeData.recordMsg == nil or not nodeData.recordMsg) then
                conTranslate:setVisible(true)
		    else
		        conTranslate:setVisible(false)
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
        	local freeText = ToChangeFreeText(nodeData.words)
            txtSendMsgS:setTag(1000)
            local psx = 25 / parentSize.width
            if conMsgSize.width <= 80 then
            	psx = 30 / parentSize.width
            end
            if bMasterMessage then
                txtSendMsgS:setRelativePosition(GlobalMethod:ccp(psx,0.6))
            else
                txtSendMsgS:setRelativePosition(GlobalMethod:ccp(psx,0.409091))
            end
            txtSendMsgS:setShowText(freeText)

            local elementRelativeSize = element:getRelativeSize()
            WZLog("elementRelativeSizeHeight = ",elementRelativeSize.height)
            if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
                if nodeData.mainChannel == CHANNEL_WHISPER and nodeData.sendID == nodeData.recvID then --GM小助手发的消息
                    local tempHeight = 445 * elementRelativeSize.height - 110
                    conMsg:setAbsContentSize(GlobalMethod:CCSize(conMsg:getAbsContentSize().width,80+ tempHeight))
                end
            end
            if elementRelativeSize.height > 0.25 then 
            	local tempHeight = 445 * elementRelativeSize.height - 110
            	WZLog("tempHeightH = ",tempHeight)
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
        else
        	CellHead:show(conPlayerFigureS,nodeData.head,nodeData.face,nodeData.sex,nil,GlobalMethod:ccp(0.52,0.29),nil,nodeData.headColor)
        end
        
    	local txtSendMsgNameS= GetElement(conMsgLeftSma,"txtSendMsgNameS_WndChat",WZUILabelTTF)
    	txtSendMsgNameS:setText(nodeData.sendName)

    	local conVip = GetElement(conMsgLeftSma,"conVip_WndChat",WZUIContainer)
        
        self:_changeNColor(txtSendMsgNameS,nodeData.mainChannel)

    	if nodeData.vipLevel and nodeData.vipLevel > 0 then
    		conVip:setVisible(true)
    		local txtVip = GetElement(conVip,"txtVip_WndChat",WZUILabelAtlasFont)
    		txtVip:setText(nodeData.vipLevel)
    	else
    		
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
        	txtWhisperS:setText(LocalStrings.WHISPER_TO_ME)
        	txtWhisperS:setTag(nodeData.recvID)

            local txtSendTSAdd = GetElement(conMsgLeftSma, "txtSendTSAdd_WndChat", WZUILabelTTF)
            txtSendTSAdd:setText(nodeData.tm)
            if nodeData.playerTitle and nodeData.playerTitle ~= "" then
                txtSendTSAdd:setRelativePosition(GlobalMethod:ccp(1.1, 0.5))
            end
            txtSendTS:setVisible(false)
        end
        
        if not nodeData.recordMsg then
        	GetElement(conMsgLeftSma,"btnA_WndChat",WZUIButton):setTag(nodeData.sendID+11)
        end
	else
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

        --排位图标
        local imgPvpIcon = GetElement(conMsgRightSma, "imgPvpIcon_WndChat", WZUIImage)
        if nodeData.playerPvpLevel then
            local tTempData = GetPvpDataByLevel(nodeData.playerPvpLevel)
            if tTempData then
                imgPvpIcon:setFile("ui/common/" .. tTempData.icon .. ".png")
                imgPvpIcon:setVisible(true)
            else
                imgPvpIcon:setVisible(false)
                conTitle:setRelativePosition(GlobalMethod:ccp(0.95, 0.718))
            end
        else
            imgPvpIcon:setVisible(false)
            conTitle:setRelativePosition(GlobalMethod:ccp(0.95, 0.718))
        end
        --称号
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
        self:_changeNColor(txtSendMsgNameRS,nodeData.mainChannel)
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
        	local freeText = ToChangeFreeText(nodeData.words)
            txtSendMsgRS:setShowText(freeText)
            txtSendMsgRS:setTag(1000)
            local psxx = 25 / conMsg:getAbsContentSize().width
            if conMsgSize.width <= 80 then
            	psxx = 30 / conMsg:getAbsContentSize().width
            end

            txtSendMsgRS:setRelativePosition(GlobalMethod:ccp(psxx,0.409091))
            
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
        
        CellHead:show(conPlayerFigureRS,nodeData.head,nodeData.face,nodeData.sex,nil,GlobalMethod:ccp(0.52,0.29),nil,nodeData.headColor)

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
    		local txtVip = GetElement(conVip,"txtVip_WndChat",WZUILabelAtlasFont)
    		txtVip:setText(nodeData.vipLevel)
    		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "en" then
    			txtSendTRS:setFontSize(13)
    		end
    	end
    	
        if not nodeData.recordMsg then
        	GetElement(conMsgRightSma,"btnC_WndChat",WZUIButton):setTag(nodeData.sendID+11)
        end
	end
    
	if nodeData.bubbleId ~= nil and nodeData.bubbleId > 1 then --1：代表使用默认的聊天背景
        local imgMsgBg = GetElement(cellItem,"imgMsgBg_WndChat",WZUI9Image)
        local itemInfo = GDatatab_item["id_" .. nodeData.bubbleId]
		imgMsgBg:setFile(itemInfo.icon)
	end

	if (nodeData.mainChannel == CHANNEL_COLORCHAT and cellItem ~= nil) or nodeData.mainChannel == CHANNEL_COPY then
		local imgCrossService = GetElement(cellItem,"imgCrossService_WndChat",WZUIImage)
		imgCrossService:setVisible(true)
		
        local conMsg = GetElement(cellItem,"conMsg_WndChat",WZUIContainer)
        local conMsgSize = conMsg:getAbsContentSize()
		local anchorPoint = imgCrossService:getAnchorPoint()
        if anchorPoint.x == 1 then
            imgCrossService:setRelativePosition(GlobalMethod:ccp((conMsgSize.width -14) /conMsgSize.width,imgCrossService:getRelativePosition().height))
        else
            imgCrossService:setRelativePosition(GlobalMethod:ccp(12/conMsgSize.width,imgCrossService:getRelativePosition().height))
        end
	end

	local txtTemp = GetElement(cellItem,"txtTemp_WndChat",WZUILabelTTF)
	if txtTemp then
		txtTemp:setText(tempMsg)
	end

	local conMsgInfo = GetElement(cellItem,"conMsgInfo_WndChat",WZUIContainer)
	conMsgInfo:setTag(nodeData.sendID+33)
	--tbl:update()
	cellItem:setTag(1199)
	element:addChild(cellItem)
	WZLog("CellMsgItem:createWorldItem end......")
	return pItem
end

--@brief	创建一条信息UI
--@param	tbl:各频道的freelist
--@param	nodeData:一条信息
function CellMsgItem:_createOneItem(tbl, nodeData)
	WZLog("CellMsgItem:_createOneItem")
	local pItem = WZUIContainer:create()
	comCCPoint.x = 0.5
	comCCPoint.y = 0.5
	pItem:setAnchorPoint(comCCPoint)
    
    comCCPoint.x = 0
	comCCPoint.y = 0

	--内容
	local sContent = nodeData.words
	local temp = sContent
	if not nodeData.recordMsg then
		for i,v in ipairs(WndChat.FACEIMASK) do
		    temp = string.gsub(temp,v,"AAA")
	    end
	end
	
	
	local pLblWords = WZUILabelTTF:create()
	--if nodeData.recordMsg then --语音聊天信息
	--	pLblWords:setText("recordMsg")
	--else
		pLblWords:setText(temp)
	--end

    pLblWords:setAlignment(kCCTextAlignmentLeft)
	pLblWords:setColor(GlobalMethod:ccc3(255,89,74))

	if nodeData.mainChannel == CHANNEL_SYSTEM and nodeData.sendName ~= LocalStrings.TIP then
		pLblWords:setColor(GlobalMethod:ccc3(255,89,74))
	elseif nodeData.mainChannel == CHANNEL_SYSTEM and nodeData.sendName == LocalStrings.TIP then
	    pLblWords:setColor(GlobalMethod:ccc3(5,180,0))
	end
	pLblWords:setFontSize(self.m_Define.fontsize)
	pLblWords:setAnchorPoint(comCCPoint)
	
	pLblWords:setTag(1000)
   
    pItem:addChild(pLblWords)
	
	--tbl:pushBack(pItem)
	
	return pItem,pLblWords
end

function CellMsgItem:resetSize(nodeData,conMsg,conMsgParent,txtSendMsg,worldSize)
	-- body
	WZLog("CellMsgItem:resetSize")
	local bResetSize = true
	if nodeData.mainChannel == CHANNEL_WHISPER then
	    if worldSize.width > self.m_Define.fontsize*19-10 then -- 发送的私聊信息超过19个字
	    	if nodeData.recordMsg then
	    		conMsgParent:setAbsContentSize(GlobalMethod:CCSize(536,135))
	    		conMsg:setAbsContentSize(GlobalMethod:CCSize(424,96))
	    		txtSendMsg:setDimensions(GlobalMethod:CCSize(390,0))
	    		bResetSize = false
	    	end
	    end
    else
        if worldSize.width > self.m_Define.fontsize*24-10  then -- 发送的私聊信息超过24个字
            if nodeData.recordMsg then
                conMsgParent:setAbsContentSize(GlobalMethod:CCSize(536,135))
                conMsg:setAbsContentSize(GlobalMethod:CCSize(524,96))
                txtSendMsg:setDimensions(GlobalMethod:CCSize(480,0))
                bResetSize = false
            end
        end
	end
	    
    if bResetSize then
    	local wSizeW = worldSize.width
		if wSizeW <= 80 then
			if (nodeData.recordMsg == nil or not nodeData.recordMsg) then
				conMsg:setAbsContentSize(GlobalMethod:CCSize(140,66))
			else
				conMsg:setAbsContentSize(GlobalMethod:CCSize(140,76))
			end
	    else
	    	if (nodeData.recordMsg == nil or not nodeData.recordMsg) then
	    		if nodeData.mainChannel == CHANNEL_WHISPER then
	    			if wSizeW+50 < 424 then
	    				conMsg:setAbsContentSize(GlobalMethod:CCSize(wSizeW+50,66))
	    			else
	    				conMsg:setAbsContentSize(GlobalMethod:CCSize(424,66))
	    			end
	    		else
	    			if wSizeW+50 < 514 then
	    				conMsg:setAbsContentSize(GlobalMethod:CCSize(wSizeW+50,66))
	    			else
	    				conMsg:setAbsContentSize(GlobalMethod:CCSize(524,66))
	    			end
	    		end
	    	else
		        if wSizeW > 80 then
		        	if nodeData.mainChannel ~= CHANNEL_WHISPER then
		        		if wSizeW + 50 < 514 then
		        			conMsg:setAbsContentSize(GlobalMethod:CCSize(wSizeW+50,76))
		        		else
		        			conMsg:setAbsContentSize(GlobalMethod:CCSize(524,76))
		        		end
		        	else
		        		if wSizeW + 50 < 424 then
		        			conMsg:setAbsContentSize(GlobalMethod:CCSize(wSizeW+50,76))
		        		else
		        			conMsg:setAbsContentSize(GlobalMethod:CCSize(424,76))
		        		end
		        	end
		        else
					conMsg:setAbsContentSize(GlobalMethod:CCSize(140,76))
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
	comCCPoint.x = 0.05
	comCCPoint.y = centerY
	
	pLblWords:setRelativePosition(comCCPoint)
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

function CellMsgItem:_changeNColor(ttf,channel)
	WZLog("CellMsgItem:_changeNColor")
	if channel == CHANNEL_CURRENT then
		ttf:setColor(GlobalMethod:ccc3(255,255,255))
	elseif channel == CHANNEL_WORLD or channel == CHANNEL_COLORCHAT then
		ttf:setColor(GlobalMethod:ccc3(255,227,116))
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
    imgNor:setFile("ui/common/common_btn_anniu10_0.png")
    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/common/common_btn_anniu10_0_sel.png")

    btnReset:setNormalElement(imgNor)
    btnReset:setSelectElement(imgSel)

    local txtValue = WZUILabelTTF:create()
    txtValue:setFontSize(24)
    txtValue:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txtValue:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    txtValue:setColor(GlobalMethod:ccc3(255,236,193))
    txtValue:setStrokeColor(GlobalMethod:ccc3(0,72,3))
    txtValue:setStrokeSize(4)
    txtValue:setEnableStroke(true)
    txtValue:setText(textBtn)
    btnReset:addChild(txtValue)

    return btnReset
end




-------------------------------------私有方法模块End----------------------------------------
