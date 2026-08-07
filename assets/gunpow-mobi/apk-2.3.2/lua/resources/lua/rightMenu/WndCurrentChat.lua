--WndCurrentChat.lua
--@brief	WndCurrentChat的UI模块
--@date		2014/01/20
--@author	孙珊珊
--@note		当前聊天接口
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCurrentChat:onEnter(element)
	self.m_root = element
	self.m_root:enableSchedule("callBackCheck",1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCurrentChat:onExit(element)
	WZLog("WndCurrentChat:onExit")
	self:_unInit()
end

--@brief    设置WndCurrentChat是否可见
function WndCurrentChat:wndCurChatVisible(visible)
	WZLog("WndCurrentChat:wndCurChatVisible = ",visible)
	if self.m_root == nil then
		return
	end
	local conEle = self.m_root:getChildElement("con_WndCurrentChat")
	if conEle == nil then
		return
	end
	conEle = WZUIContainer:luaTo(conEle)
	if visible then
		if WndChat.isHiden and self.nItemNumber > 0 then
			conEle:setVisible(visible)
		end
	else
		conEle:setVisible(visible)
	end
	
	if visible then
		local freeConChat = self.m_root:getChildElement("freeConChat_WndCurrentChat")
		freeConChat = WZUIFreeListContainer:luaTo(freeConChat)
		freeConChat:update()
	end
end

--@brief    添加聊天小列表到当前根Scene
function WndCurrentChat:addWndCurrentChatToCurScene(sceneName,rootObject)
	WZLog("WndCurrentChat:addWndCurrentChatToCurScene ",sceneName)
	if self.m_root ~= nil then
		local parent = self.m_root:getParent()
		if parent then
			parent:removeChild(self.m_root,true)
		end
	end
	if self.m_root == nil then
		self:initChat(rootObject)
	end
		
	
	self.m_root:setShowAll(true)

	self:wndCurChatVisible(false)
	self.m_root:setTag(78945)
	self.m_root:setZOrder(0)
	local freeConChat = self.m_root:getChildElement("freeConChat_WndCurrentChat")
	freeConChat = WZUIFreeListContainer:luaTo(freeConChat)
	local con = GetElement(self.m_root,"con_WndCurrentChat",WZUIContainer)
	con:setRelativePosition(GlobalMethod:ccp(0.5,0.35))
	local root = WZUIWindow:luaTo(self.m_root)
	root:setAbsContentSize(GlobalMethod:CCSize(490,70))
	root:updateRelativeSize()
    if freeConChat ~= nil then
		if self.m_sSceneName ~= sceneName then
			self.m_sSceneName = sceneName
			if self.m_sSceneName == "SceneBattle"  then
				if WndBattleHud:checkVoiceChannelLv() then
					self.m_root:setRelativePosition(GlobalMethod:ccp(0.060,0.141884))
				else
					self.m_root:setRelativePosition(GlobalMethod:ccp(0.005,0.141884))
				end
			elseif self.m_sSceneName == "SceneRoom"  or  self.m_sSceneName == "SceneBossRoom" then
				root:setAbsContentSize(GlobalMethod:CCSize(490,110))
				con:setRelativePosition(GlobalMethod:ccp(0.45,0.31))
				root:updateRelativeSize()
				self:setMaxCount(3)
				self.m_nMaxTxtCount = 30
			elseif self.m_sSceneName == "SceneGuildWarRoom" then
				root:setAbsContentSize(GlobalMethod:CCSize(490,150))
				con:setRelativePosition(GlobalMethod:ccp(0.45,0.295019))
				root:updateRelativeSize()
				self:setMaxCount(4)
				self.m_nMaxTxtCount = 30
			elseif self.m_sSceneName == "SceneLeagueMain" then
				root:setAbsContentSize(GlobalMethod:CCSize(490,150))
				con:setRelativePosition(GlobalMethod:ccp(0.45,0.295019))
				root:updateRelativeSize()
				self:setMaxCount(4)
				self.m_nMaxTxtCount = 30
				self.m_root:setZOrder(21)
			elseif self.m_sSceneName ~= "SceneCity" then
			  	self.m_root:setRelativePosition(GlobalMethod:ccp(0.0654167,0.001))
			end
		end

	    freeConChat:removeAll()  
		self.nItemNumber = 0
	    freeConChat:update()
    end
end

--@brief	加载聊天界面接口
function WndCurrentChat:initChat(rootObject)
	WZLog("WndChat:initChat")
	if self.m_root == nil then
		self:_createChatWindow()
		if rootObject ~= nil then
			rootObject:addChild(self.m_root)
		else
			WindowManager:addWindow(self.m_root, WndCurrentChat)
		end
	end
end

function WndCurrentChat:onTouchBegan(element)
	WZLog("WndCurrentChat:onTouchBegan")
end

--@brief  暂时隐藏底部聊天信息
function WndCurrentChat:hideButtomChat()
	if self.m_root ~= nil and self.m_root:getParent() then
		self.m_root:setVisible(false)
	end
end

--@brief  显示底部聊天信息
function WndCurrentChat:showButtomChat()
	if self.m_root ~= nil and self.m_root:getParent() then
		self.m_root:setVisible(true)
	end
end

--@brief  释放底部聊天
function WndCurrentChat:releaseRoot()
	if self.m_root ~= nil then
		local freeConChat = self.m_root:getChildElement("freeConChat_WndCurrentChat")
		freeConChat = WZUIFreeListContainer:luaTo(freeConChat)
		freeConChat:removeAll()
	end
end

function WndCurrentChat:removeFromParent()
	WZLog("WndCurrentChat:removeFromParent")
	if self.m_root ~= nil then
		local parent = self.m_root:getParent()
		if parent ~= nil then
			self.m_root:removeFromParentAndCleanup(true)
		end
	end
end

-------------------------------------私有方法模块Begain----------------------------------------
--@brief      开始创建聊天页面
--@param    _type 聊天频道类型
function WndCurrentChat:_createChatWindow()
    WZLog("WndCurrentChat:_createChatWindow")
	if self.m_root == nil then
		self.m_root = self:createElement()
		if self.m_root == nil then
			return
		end
		--self.m_root:retain()--整个游戏运行过程中不要释放，因为聊天页面存在整个游戏过程中
	end
end

--@brief    更新聊天信息
function WndCurrentChat:_update()
	WZLog("WndCurrentChat:_update")
	
	if self.m_tChatData == nil or self.m_root == nil  then
		WZLog("_update() m_tChatData is nil")
		return
	end
	if self.nItemNumber >= self.m_nMaxCount then
		local freeConChat = self.m_root:getChildElement("freeConChat_WndCurrentChat")
		freeConChat = WZUIFreeListContainer:luaTo(freeConChat)
		if freeConChat == nil then
		  return 
		end
		freeConChat = WZUIFreeListContainer:luaTo(freeConChat)
		freeConChat:removeAt(0)
		self.nItemNumber = self.nItemNumber -1
	end
	self.nItemNumber = self.nItemNumber + 1
	self:_updateTable()
end

--@brief	更新列表
function WndCurrentChat:_updateTable()
	WZLog("WndCurrentChat:_updateTable")
	--向列表里添加一条
	self:_addChatToList()
end


--@brief	向表里添加聊天信息
function WndCurrentChat:_addChatToList()
	WZLog("WndCurrentChat:_addChatToList = ",self.m_sSceneName)
	local freeConChat = self.m_root:getChildElement("freeConChat_WndCurrentChat")
	if freeConChat == nil then
		return
	end
	freeConChat = WZUIFreeListContainer:luaTo(freeConChat)
    
	if self.m_tChatData.mainChannel ==  CHANNEL_WHISPER then
	   self:_createPrivateItem(freeConChat,self.m_tChatData)
	   self.m_tChatData = nil
	elseif self.m_tChatData.mainChannel ==  CHANNEL_SYSTEM and self.m_tChatData.sendName == LocalStrings.TIP then
	   self:_createFriendOnlineItem(freeConChat,self.m_tChatData)
	   self.m_tChatData = nil
	else
	   self:_createWorldItem(freeConChat,self.m_tChatData)
	   self.m_tChatData = nil
	end
end

--@brief  删除换行符
--@param  msgContent:需要查找的字符串
function WndCurrentChat:removeLineFeed(msgContent)
	WZLog("WndChat:removeLineFeed")
    local index = string.find(msgContent,"\n",0)
    if index ~= nil and tonumber(index) > 0 then
    	msgContent = string.gsub(msgContent,"\n","")
    end
    return msgContent
end

--@brief  创建好友上线提示信息
--@param  nodeData:数据表
function WndCurrentChat:_createFriendOnlineItem(tbl, nodeData)
	WZLog("WndCurrentChat:_createFriendOnlineItem")
	local parentSize = tbl:getContentSize()
	local pItem = WZUIContainer:create()

	local pLblWords = nil
    --内容
	local sContent = nodeData.words
	pLblWords = WZUILabelTTF:create()
	pLblWords:setMaxLength(18)
	pLblWords:setText(LocalStrings.TIP .. nodeData.words)
	pLblWords:setColor(GlobalMethod:ccc3(5,180,0))
	pLblWords:setFontSize(self.fontsize)
	pLblWords:setTag(1005)
	pLblWords:setBoldFont(true)
	pLblWords:setAnchorPoint(CCPoint(0,0.5))
	pItem:addChild(pLblWords)

	tbl:pushBack(pItem)
	local itemH = 22+6
	pItem:setUseAbsSize(true)
	pItem:setAnchorPoint(CCPoint(0.5,0.5))
	pItem:setRelativeSize(GlobalMethod:CCSize(500/parentSize.width, itemH/parentSize.height))

	pLblWords:setRelativePosition(GlobalMethod:ccp(0.015, 0.5))
	tbl:update()
	return pItem
end

--@brief	创建显示世界频道
--@param	tbl:全部频道的freelist
--@param	nodeData:一条信息
function WndCurrentChat:_createWorldItem(tbl, nodeData)
	WZLog("WndChat:_createWorldItem ",tbl:getTag())
	--创建UI
	nodeData.words =self:removeLineFeed(nodeData.words)
    local parentSize,pItem, pLblChannel,pLblSenderName,pLblSay,pLblWords,recorImg= self:_createOneItem(tbl, nodeData) --创建一条信息UI
	pLblSenderName:setTag(nodeData.sendID)
	--调整位置

	local itemH = 22+6
	local itemW = parentSize.width

	pItem:setUseAbsSize(true)
	pItem:setAnchorPoint(CCPoint(0.5,0.5))
	pItem:setRelativeSize(GlobalMethod:CCSize(500/parentSize.width, itemH/parentSize.height))
	--[频道]
	pLblChannel:setRelativePosition(GlobalMethod:ccp(0.015, 0.5))

    local startX = 5
    startX =  startX+ pLblChannel:getLabelContentSize().width
	
	pLblSenderName:setRelativePosition(GlobalMethod:ccp(startX/itemW, 0.5))
	startX = startX + pLblSenderName:getLabelContentSize().width
	pLblSay:setRelativePosition(GlobalMethod:ccp(startX/itemW, 0.5))
    startX = startX + pLblSay:getLabelContentSize().width
	--内容
	startX = startX + 3
	if pLblWords ~= nil then
		pLblWords:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
	else
		recorImg:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
	end
	
	tbl:update()
	return pItem
end

--@brief	创建一条信息表
--@param	iMainChannel等:服务器传过来的数据字段
function WndCurrentChat:_createListNode(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,bRecordChat)
	local t = {}
	WZLog("创建一条信息表 =",iRecvID)
	--WZLog(iMainChannel.."|"..iSendID.."|"..sSendName.."|"..iRecvID.."|"..sRecvName.."|"..sMsgContent.."|"..tm.."|"..vipLevel)
	t.nextNode = nil
	t.mainChannel = iMainChannel
	t.mainChannelName = nil
	t.sendID = iSendID
	t.sendName = sSendName
	t.recvID = iRecvID
	t.recvName = sRecvName
	t.words = sMsgContent
	t.tm = tm
	t.vipLevel = vipLevel
	t.recordChat = bRecordChat
	return t
end

--@brief	创建一条信息UI
--@param	tbl:各频道的freelist
--@param	nodeData:一条信息
function WndCurrentChat:_createOneItem(tbl, nodeData)
	WZLog("WndCurrentChat:_createOneItem")
	local newWords = shieldQQQunNum(nodeData.words)
    local sStart,sEnd,sContent = string.find(nodeData.words,g_REMAINSMessage_Mark)
    if sContent then --遗迹副本消息不做数字屏蔽
    else
	    if newWords then 
	        nodeData.words = newWords
	    end
	end

	local parentSize = tbl:getContentSize()
	local pItem = WZUIContainer:create()
	--频道
	local sTitle = nodeData.mainChannelName
	local pLblChannel = WZUILabelTTF:create()
	pLblChannel:setText(sTitle)
	pLblChannel:setColor(GlobalMethod:ccc3(255,236,193))
	pLblChannel:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	pLblChannel:setFontSize(self.fontsize)
	pLblChannel:setBoldFont(true)
	pLblChannel:setEnableStroke(true)
	pLblChannel:setStrokeColor(GlobalMethod:ccc3(79,60,48))
	pLblChannel:setStrokeSize(2)
	pItem:addChild(pLblChannel)

	local pLblSenderName = WZUILabelTTF:create()
	pLblSenderName:setText(nodeData.sendName)
	pLblSenderName:setColor(GlobalMethod:ccc3(255,236,193))
	pLblSenderName:setFontSize(self.fontsize)
	pLblSenderName:setBoldFont(true)
	pLblSenderName:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	pLblSenderName:setEnableStroke(true)
	pLblSenderName:setStrokeColor(GlobalMethod:ccc3(79,60,48))
	pLblSenderName:setStrokeSize(2)
	pItem:addChild(pLblSenderName)

	--说
	local pLblSay = WZUILabelTTF:create()
	pLblSay:setText(":")
	pLblSay:setColor(GlobalMethod:ccc3(255,236,193))
	pLblSay:setFontSize(self.fontsize)
	pLblSay:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	pLblSay:setBoldFont(true)
	pLblSay:setEnableStroke(true)
	pLblSay:setStrokeColor(GlobalMethod:ccc3(79,60,48))
	pLblSay:setStrokeSize(2)
	pItem:addChild(pLblSay)
	local pLblWords = nil
	local recorImg = nil
	--遗迹聊天内容
    local bRemainsMessage = false
    local tabContent = nil
    if nodeData.mainChannel == CHANNEL_COPY or nodeData.mainChannel == CHANNEL_GUILD or nodeData.mainChannel == CHANNEL_CURRENT then
        local sStart,sEnd,sContent = string.find(nodeData.words,g_REMAINSMessage_Mark)
        if sContent then
        	WZLog("WndCurrentChat:_createOneItem", sContent)
            bRemainsMessage = true
            tabContent = json.decode(sContent)
            nodeData.words = tabContent.desc..tabContent.text
        end
    end

    if nodeData.recordChat ~= nil and nodeData.recordChat then
    	recorImg = WZUIImage:create()
    	recorImg:setUseOriginSize(true)
    	recorImg:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    	if nodeData.CHANNEL_WHISPER then
    		recorImg:setFile("ui/chat/chat_common_icon_liaotianxiao.png")
    	else
    		recorImg:setFile("ui/chat/chat_common_icon_liaotianxiao2.png")
    	end
    	pItem:addChild(recorImg)
    else
    	--内容
		local sContent = nodeData.words
		sContent = GetShortName(sContent,self.m_nMaxTxtCount,self.m_nMaxTxtCount)
		local len = string.len(sContent)
		local startIndex = len - 8
		local index = string.find(sContent,"/",startIndex)
		if index then --判断截取的最后字符是否为表情掩码
			local subStr = string.sub(nodeData.words,index,index+2)
			local bFace = false
			for i,v in pairs(WndChat.FACEIMASK) do
				if subStr == v then
					bFace = true
				end
			end
			if bFace then
				sContent = string.sub(sContent,1,index-1)
				sContent = sContent .. subStr .. "..."
			end
		end
		
		pLblWords = WZUIFreeTextBox:create()
		pLblWords:setMaxWidth(560)
		pLblWords:setTag(1000)
		pLblWords:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		local freeText = ToChangeFreeText(sContent,"255,236,193","79,60,48","2","1")
		pLblWords:setShowText(freeText)
		pItem:addChild(pLblWords)
    end

	--频道颜色
	self:_changeNColor(pLblChannel,nodeData.mainChannel)
	self:_changeNColor(pLblSenderName,nodeData.mainChannel)
	tbl:pushBack(pItem)
	return parentSize,pItem, pLblChannel,pLblSenderName,pLblSay,pLblWords,recorImg
end

function WndCurrentChat:_changeNColor(ttf,channel)
	if channel == CHANNEL_CURRENT then
		ttf:setColor(GlobalMethod:ccc3(255,255,255))
	elseif channel == CHANNEL_WORLD then
		ttf:setColor(GlobalMethod:ccc3(255,227,116))
	elseif channel == CHANNEL_GUILD then
		ttf:setColor(GlobalMethod:ccc3(255,121,31))
	elseif channel == CHANNEL_WHISPER then
		ttf:setColor(GlobalMethod:ccc3(199,139,255))
	elseif channel == CHANNEL_TEAM then
		ttf:setColor(GlobalMethod:ccc3(233,166,62))
	end
end

--@brief	创建显示私聊频道
--@param	tbl:私聊频道的freelist
--@param	nodeData:一条信息
function WndCurrentChat:_createPrivateItem(tbl, nodeData)
	--创建UI
	WZLog(" WndCurrentChat:_createPrivateItem", type(nodeData.words))
	nodeData.words =self:removeLineFeed(nodeData.words)
    local parentSize,pItem, pLblChannel,pLblSenderName,pLblSay,pLblWords ,recorImg = self:_createOneItem(tbl, nodeData) --创建一条信息UI
	
	if nodeData.mainChannel == CHANNEL_WHISPER and CacheCenter:getPlayerInfo().name == nodeData.sendName then
		pLblSenderName:setText(LocalStrings.CHAT_ME) --你
		pLblSenderName:setColor(GlobalMethod:ccc3(99,255,95))
	else
		pLblSenderName:setText(nodeData.sendName)
		pLblSenderName:setColor(GlobalMethod:ccc3(199,139,255))
	end
	pLblSenderName:setTag(nodeData.sendID)

	--对
	local pLblTo = WZUILabelTTF:create()
	pLblTo:setText(LocalStrings.CHAT_RIGHT)
	pLblTo:setColor(GlobalMethod:ccc3(99,255,95))
	pLblTo:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	pLblTo:setFontSize(self.fontsize)
	pLblTo:setEnableStroke(true)
	pLblTo:setStrokeColor(GlobalMethod:ccc3(79,60,48))
	pLblTo:setStrokeSize(2)
	pItem:addChild(pLblTo)
	--接收者
	local pLblReceiver = WZUILabelTTF:create()
	pLblReceiver:setEnableStroke(true)
	pLblReceiver:setStrokeColor(GlobalMethod:ccc3(79,60,48))
	pLblReceiver:setStrokeSize(2)
	pLblReceiver:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	if CacheCenter:getPlayerInfo().name == nodeData.recvName then
		pLblReceiver:setText(LocalStrings.CHAT_ME)
		pLblReceiver:setColor(GlobalMethod:ccc3(99,255,95))
	else
		pLblReceiver:setText(nodeData.recvName)
		pLblReceiver:setColor(GlobalMethod:ccc3(199,139,255))
	end
	--pLblReceiver:setLuaTouchEndedFunction("_displayPlayer")
	pLblReceiver:setFontSize(self.fontsize)
	pLblReceiver:setTag(nodeData.recvID)
	pItem:addChild(pLblReceiver)

	--调整位置
    local startX = 35
    local itemW = 650--parentSize.width
	local itemH = 22+6  --22是字体大小

    pLblChannel:setRelativePosition(GlobalMethod:ccp(0.02, 0.5))
    startX = startX + pLblChannel:getLabelContentSize().width

    --[私聊]我对XX说
	if pLblSenderName:getText() ==  LocalStrings.CHAT_ME then
		pLblSenderName:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		startX=startX+pLblSenderName:getLabelContentSize().width
		pLblTo:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		startX  = startX + pLblTo:getLabelContentSize().width
		if pImageVip then
			pImageVip:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
			startX = startX + pImageVip:getLabelContentSize().width
		end
		pLblReceiver:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		startX = startX + pLblReceiver:getLabelContentSize().width
		pLblSay:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		startX = startX + pLblSay:getLabelContentSize().width
	else --[私聊]XX对我说
		pLblSenderName:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		startX=startX+pLblSenderName:getLabelContentSize().width
		pLblTo:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		startX  = startX + pLblTo:getLabelContentSize().width
		pLblReceiver:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		startX = startX + pLblReceiver:getLabelContentSize().width
		pLblSay:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		startX = startX + pLblSay:getLabelContentSize().width
	end
	startX = startX + 3
	if pLblWords ~= nil then
		pLblWords:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
	else
		if recorImg ~= nil then
			recorImg:setRelativePosition(GlobalMethod:ccp(startX/itemW,0.5))
		end
	end
    
	pItem:setContentSize(GlobalMethod:CCSize(650, itemH))
	pItem:setRelativeSize(GlobalMethod:CCSize(650/parentSize.width, itemH/parentSize.height ))
	
	tbl:update()
	return pItem
end

--@brief	获取频道名字和id
--@param	channel:频道号
function WndCurrentChat:_getChannelTableAndName(channel)
	local n
	--channel
	if channel == CHANNEL_COLORCHAT then
		n = LocalStrings.CHAT_COLORLIAOK
	elseif channel == CHANNEL_WORLD then
		n = LocalStrings.CHAT_WORLDK
	elseif channel == CHANNEL_CURRENT then
		n = LocalStrings.CHAT_CURRENTK
	elseif channel == CHANNEL_WHISPER then
		n = LocalStrings.CHAT_PRIVATEK
	elseif channel == CHANNEL_GUILD then
		n = LocalStrings.CHAT_GONGHUIK
	elseif channel == CHANNEL_SYSTEM then
		n = LocalStrings.CHAT_SYSTEMK
	elseif channel == CHANNEL_TEAM then
		n = LocalStrings.CHAT_TEAM
	elseif channel == CHANNEL_UNION then
		n = LocalStrings.UNION_TEXT1[50]
	else
		n = nil
	end
	return n
end

--@brief	弹出角色界面
--@param	element:定时器绑定的UI节点引用
function WndCurrentChat:_displayPlayer(element)
	WZLog("WndCurrentChat:_displayPlayer")
	if element== nil then
		WZLog("_displayPlayer(element) == nil")
		return
    	end
    	self:_actionScalePlayer(element,0.2,0.15,0.05)
     	WndCheckOther:show(element:getTag())	
end


-------------------------------------私有方法模块End----------------------------------------
