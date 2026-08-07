--WndSuona.lua
--@brief	WndSuona的UI模块
--@date		2014/01/20
--@author	孙珊珊
--@note		喇叭接口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSuona:onEnter(element)
	WZLog("WndSuona:onEnter")
	self.m_root = element
    
    --当切换账号 场景还没ONTER
	local nChannel = self.suonaQuene[1].nChannel
	local sendName = self.suonaQuene[1].sendName
	local message = self.suonaQuene[1].message
	local chatType = self.suonaQuene[1].chatType
	local subType = self.suonaQuene[1].subType
	local sendVipLevel = self.suonaQuene[1].sendVipLevel or 0
	if nChannel == CHANNEL_GOLD then --金喇叭消息
		local newMsg = shieldQQQunNum(message)
		if newMsg then 
			message = newMsg
		end
	end
	local temp = sendName .. ":" .. message
	self:_initTxtWorldChat(temp)
	self.m_sOriginal = temp	
	local showText = ToChangeFreeText(temp,"252,138,32",nil,nil,nil,18)
	self.m_sOriginal_suonaMsg = {nChannel=nChannel,sendName=sendName,message=message,chatType=chatType,subType=subType,sendVipLevel=sendVipLevel}
	if (chatType == 0 and subType == 2) or (chatType == 1 and subType == 2) or chatType == 2 or nChannel == CHANNEL_GOLD then
		if self.m_sOriginal_suonaMsg.sendVipLevel >= 21 then
			--跨服喇叭vip21名称显示为金色255,227,116 描边132,66,29
			WZLog("WndSuona:onEnter111", Serialize(self.m_sOriginal_suonaMsg))
			showText = ToChangeFreeText(self.m_sOriginal_suonaMsg.sendName,"255,227,116","132,66,29","4","1",18)..ToChangeFreeText(":" .. self.m_sOriginal_suonaMsg.message,"252,138,32",nil,nil,nil,18)
		end
	elseif chatType == 99 then 
		showText = ToChangeFreeText(temp,"255,236,193",nil,nil,nil,18)
	elseif chatType == 100 then 
		showText = ToChangeFreeText(temp,"255,236,193",nil,nil,nil,18)
	end
	self.m_txtWorldChat:setShowText(showText)
	local freeTextHight = self.m_txtWorldChat:getContentSize().height
	local conbottom = self.m_root:getChildElement("conbottom_WndSuona")
	if freeTextHight >= 40 and conbottom then
		conbottom = WZUIContainer:luaTo(conbottom)
		conbottom:setAbsContentSize(GlobalMethod:CCSize(704,45))
		conbottom:updateRelativeSize()
	elseif conbottom then
		conbottom = WZUIContainer:luaTo(conbottom)
		conbottom:setAbsContentSize(GlobalMethod:CCSize(704,28))
		conbottom:updateRelativeSize()
	end
	local imgSuonaType = self.m_root:getChildElement("imgSuonaType_WndSuona")
	local img9Bk = GetElement(self.m_root, "img9Bk_WndSuona", WZUI9Image)
	local spineEffect = GetElement(self.m_root, "spineEffect_WndSuona", WZUISpine)
	if imgSuonaType==nil or img9Bk == nil then
		return
	end
	imgSuonaType = WZUIImage:luaTo(imgSuonaType)
	imgSuonaType:setRelativePosition(GlobalMethod:ccp(0.038,0.490222))
	
	local width = self.m_tempTxt:getLabelContentSize().width
	
	local nDuration = width/100*1.2-- is runtime
	--local nMoveX = -width/490
	local nMoveX = -width

	WZLog("::::::::::::::::::::",nMoveX)
	if nChannel == CHANNEL_GOLD then --金喇叭消息
		img9Bk:setFile("ui/chat/common_jinsedi.png")
		imgSuonaType:setFile("ui/chat/horn_04_1.png")
		spineEffect:setFileJson("")
		spineEffect:setFileAtlas("")
		local effectPath = "ui/otherUI/ui_paomadeng"
		local existSpine = CheckEffectFile(effectPath)
		if existSpine then 
			spineEffect:setFileJson(effectPath .. ".json")
			spineEffect:setFileAtlas(effectPath .. ".atlas")
			spineEffect:play("animation", true)
			spineEffect:setVisible(true)
		end
		self.m_root:enableSchedule("_scheduleColorChange",1)
	else
		spineEffect:setVisible(false)
		if (chatType == 0 and subType == 2) or (chatType == 1 and subType == 2) or chatType == 2 then
			WZLog("cai ce la ba :::::::::::::::::::::::::::::::::")
			imgSuonaType:setFile("ui/chat/chat_common_icon_laba2.png")
			img9Bk:setFile("ui/common/common_scale9_heidi1.png")
			self.m_root:enableSchedule("_scheduleColorChange",1) 
		elseif chatType == 99 then 
			img9Bk:setFile("ui/common/common_scale9_heidi1.png")
			imgSuonaType:setRelativePosition(GlobalMethod:ccp(0.07,0.490222))
			imgSuonaType:setFile("ui/chat/horn_zl.png")
			spineEffect:setFileJson("")
			spineEffect:setFileAtlas("")
			local effectPath = "ui/otherUI/ui_pmd"
			local existSpine = CheckEffectFile(effectPath)
			if existSpine then 
				spineEffect:setFileJson(effectPath .. ".json")
				spineEffect:setFileAtlas(effectPath .. ".atlas")
				spineEffect:play("wait", true)
				spineEffect:setVisible(true)
			end
		elseif chatType == 100 then 
			img9Bk:setFile("ui/chat/common_jinsedi_mrb.png")
			imgSuonaType:setRelativePosition(GlobalMethod:ccp(0.05,0.490222))
			imgSuonaType:setFile("ui/chat/horn_mrb.png")
			spineEffect:setFileJson("")
			spineEffect:setFileAtlas("")
			local effectPath = "ui/otherUI/ui_mrt"
			local existSpine = CheckEffectFile(effectPath)
			if existSpine then 
				spineEffect:setFileJson(effectPath .. ".json")
				spineEffect:setFileAtlas(effectPath .. ".atlas")
				spineEffect:play("animation", true)
				spineEffect:setVisible(true)
			end
		else
			img9Bk:setFile("ui/common/common_scale9_heidi1.png")
			imgSuonaType:setFile("ui/chat/chat_common_icon_laba3.png")
		end
	end
	
	self:_createMoveAction(self.m_conMoveNode,nDuration,nMoveX)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSuona:onExit(element)
	WZLog("wndSuona:onExithaha")
	self:_unInit()
end

--@brief	调用喇叭接口函数
--@param	nChannel:频道
--@param	sendName:发信息人名称
--@param	message:信息内容
--@param	vipLevel发送人vip等级（系统的默认为0）
function WndSuona:showSuonaWithSendNameAndMessage(channel,sendName,message,chatType,subType,vipLevel)
--	WZLog("WndSuona:showSuonaWithSendNameAndMessage", channel, sendName, message, chatType, subType, vipLevel)
	local sendVipLevel = vipLevel or 0
    if message == nil or message == "" then
    	return
    end 
    --单人副本界面，15级之前不显示系统喇叭信息
    if CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().level < 15 and WndSingleCopy and WndSingleCopy.m_root then 
    	return 
    end

    --遗迹之光信息不显示
    local sStart,sEnd,sContent = string.find(message,g_REMAINSMessage_Mark)
    if sContent then
        -- local tabContent = json.decode(sContent)
        -- message = tabContent.desc .. tabContent.text
        return
	end

	if channel == CHANNEL_COLORCHAT and sendName == LocalStrings.CHAT_SYSTEM then 
		local strTempMark = string.sub(message, 1, string.len(g_FightOne_Login_Mark))
		local strTempMark2 = string.sub(message, 1, string.len(g_RechargeOne_Login_Mark))
		if strTempMark == g_FightOne_Login_Mark then 
			chatType = 99 --用于战力榜第一上线提醒
			message = string.sub(message, string.len(g_FightOne_Login_Mark) + 1, -1)
		end
		if strTempMark2 == g_RechargeOne_Login_Mark then 
			chatType = 100 --用于名人榜第重置一上线提醒
			message = string.sub(message, string.len(g_RechargeOne_Login_Mark) + 1, -1)
		end
	end

    local strLen = string.len(message)
	local indexx = string.find(message," ",strLen)
	if indexx ~= nil and indexx ~= strLen then
		message = message .. " "
	end
    if SceneLoginMgr ~= nil and SceneLoginMgr.m_root ~= nil then
    	return
    end
    if SceneHolidayVillage ~= nil and SceneHolidayVillage.m_root ~= nil then
    	return
    end
	if self.suonaQuene == nil then
		--初始化队列
		self.suonaQuene = {}
	end
	if #self.suonaQuene >=10 then
		table.remove(self.suonaQuene,1)
	end
	table.insert(self.suonaQuene,{nChannel=channel,sendName=sendName,message=message,chatType=chatType,subType=subType,sendVipLevel=sendVipLevel})
	--保持只有队列里的第一条信息触发
	if #self.suonaQuene <= 1 then
		self:_nextSuina()
	end
end

function WndSuona:_nextSuina()
	WZLog("WndSuona:_nextSuina")
	if SceneLoginMgr ~= nil and SceneLoginMgr.m_root ~= nil then
		if WndSuona.m_root ~= nil then
			WindowManager:removeWindow(WndSuona.m_root,WndSuona,true)
		end
		return 
    end
	--
	--WZLog(debug.traceback())

	if self.m_root == nil then

		local currentRoot = WindowManager:getSceneRoot()

		local sceneLuaObj = currentRoot:getLuaObjectIndex()
		
		local wndSuona = WndSuona:createElement()

		wndSuona:setZOrder(SUONA_ZORDER)
		if sceneLuaObj ~= nil and sceneLuaObj.m_root ~= nil and sceneLuaObj.addChild ~= nil then 
			--如果场景本身提供了添加子元素的方法则使用场景自己的添加方法
			sceneLuaObj:addChild(wndSuona)
		else
		
			currentRoot:addChild(wndSuona)
		end
    elseif self.m_root ~= nil then
    	local nChannel = self.suonaQuene[1].nChannel
		local sendName = self.suonaQuene[1].sendName
		local message = self.suonaQuene[1].message
		local chatType = self.suonaQuene[1].chatType
		local subType = self.suonaQuene[1].subType
		local sendVipLevel = self.suonaQuene[1].sendVipLevel
		WndSuona.m_root:setVisible(true)

		if nChannel == CHANNEL_GOLD then --金喇叭消息
			local newMsg = shieldQQQunNum(message)
			if newMsg then 
				message = newMsg
			end
		end
		local temp = sendName..":"..message
		self.m_sOriginal = temp
		
		local showText = ToChangeFreeText(temp,"252,138,32",nil,nil,nil,18)
		self.m_sOriginal_suonaMsg = {nChannel=nChannel,sendName=sendName,message=message,chatType=chatType,subType=subType,sendVipLevel=sendVipLevel}
		if (chatType == 0 and subType == 2) or (chatType == 1 and subType == 2) or chatType == 2 or nChannel == CHANNEL_GOLD then
			if self.m_sOriginal_suonaMsg.sendVipLevel >= 21 then
				--跨服喇叭vip21名称显示为金色255,227,116
				WZLog("WndSuona:_nextSuina111", Serialize(self.m_sOriginal_suonaMsg))
				showText = ToChangeFreeText(self.m_sOriginal_suonaMsg.sendName,"255,227,116","132,66,29","4","1",18)..ToChangeFreeText(":" .. self.m_sOriginal_suonaMsg.message,"252,138,32",nil,nil,nil,18)
			end
		elseif chatType == 99 then 
			showText = ToChangeFreeText(temp,"255,236,193",nil,nil,nil,18)
		elseif chatType == 100 then 
			showText = ToChangeFreeText(temp,"255,236,193",nil,nil,nil,18)
		end
		
		local tempChat = temp
		for i,v in pairs(WndChat.FACEIMASK) do
			tempChat = string.gsub(tempChat,v,"AAA")
		end
		self.m_tempTxt:setText(tempChat)

		local imgSuonaType = self.m_root:getChildElement("imgSuonaType_WndSuona")
		local img9Bk = GetElement(self.m_root, "img9Bk_WndSuona", WZUI9Image)
		local spineEffect = GetElement(self.m_root, "spineEffect_WndSuona", WZUISpine)
		if imgSuonaType==nil or img9Bk == nil then
			return
		end
		imgSuonaType = WZUIImage:luaTo(imgSuonaType)
		imgSuonaType:setRelativePosition(GlobalMethod:ccp(0.038,0.490222))
	
		local width = self.m_tempTxt:getLabelContentSize().width
		self.m_txtWorldChat:setShowText("")
        self.m_txtWorldChat:setMaxWidth(width+700)
        self.m_txtWorldChat:setShowText(showText)
        local freeTextHight = self.m_txtWorldChat:getContentSize().height
        local conbottom = self.m_root:getChildElement("conbottom_WndSuona")
		conbottom = WZUIContainer:luaTo(conbottom)
		if freeTextHight >= 40 and conbottom then
			conbottom = WZUIContainer:luaTo(conbottom)
			conbottom:setAbsContentSize(GlobalMethod:CCSize(704,45))
			conbottom:updateRelativeSize()
	    elseif conbottom then
			conbottom = WZUIContainer:luaTo(conbottom)
			conbottom:setAbsContentSize(GlobalMethod:CCSize(704,28))
			conbottom:updateRelativeSize()
	    end

		local nDuration = width/100*0.7-- is runtime
		--local nMoveX = -width/490
		local nMoveX = -width
	
		WZLog("::::::::::::::::::::",nChannel)
		WZLog("::::::::::::::::::::",chatType)
		WZLog("::::::::::::::::::::",subType)
		WZLog(":::::::::::::::::::: sendVipLevel",sendVipLevel)
		if nChannel == CHANNEL_GOLD then --金喇叭消息
			img9Bk:setFile("ui/chat/common_jinsedi.png")
			imgSuonaType:setFile("ui/chat/horn_04_1.png")
			spineEffect:setFileJson("")
			spineEffect:setFileAtlas("")
			local effectPath = "ui/otherUI/ui_paomadeng"
			local existSpine = CheckEffectFile(effectPath)
			if existSpine then 
				spineEffect:setFileJson(effectPath .. ".json")
				spineEffect:setFileAtlas(effectPath .. ".atlas")
				spineEffect:play("animation", true)
	 			spineEffect:setVisible(true)
	 		end
			self.m_root:enableSchedule("_scheduleColorChange",1)
		else
			spineEffect:setVisible(false)
			if (chatType == 0 and subType == 2) or (chatType == 1 and subType == 2) or chatType == 2 then
				WZLog("cai ce la ba :::::::::::::::::::::::::::::::::")
				imgSuonaType:setFile("ui/chat/chat_common_icon_laba2.png")
				img9Bk:setFile("ui/common/common_scale9_heidi1.png")
				self.m_root:enableSchedule("_scheduleColorChange",1)
			elseif chatType == 99 then 
				img9Bk:setFile("ui/common/common_scale9_heidi1.png")
				imgSuonaType:setRelativePosition(GlobalMethod:ccp(0.07,0.490222))
				imgSuonaType:setFile("ui/chat/horn_zl.png")
				spineEffect:setFileJson("")
				spineEffect:setFileAtlas("")
				local effectPath = "ui/otherUI/ui_pmd"
				local existSpine = CheckEffectFile(effectPath)
				if existSpine then 
					spineEffect:setFileJson(effectPath .. ".json")
					spineEffect:setFileAtlas(effectPath .. ".atlas")
					spineEffect:play("wait", true)
					spineEffect:setVisible(true)
				end
			elseif chatType == 100 then 
				img9Bk:setFile("ui/chat/common_jinsedi_mrb.png")
				imgSuonaType:setRelativePosition(GlobalMethod:ccp(0.05,0.490222))
				imgSuonaType:setFile("ui/chat/horn_mrb.png")
				spineEffect:setFileJson("")
				spineEffect:setFileAtlas("")
				local effectPath = "ui/otherUI/ui_mrt"
				local existSpine = CheckEffectFile(effectPath)
				if existSpine then 
					spineEffect:setFileJson(effectPath .. ".json")
					spineEffect:setFileAtlas(effectPath .. ".atlas")
					spineEffect:play("animation", true)
					spineEffect:setVisible(true)
				end
			else
				imgSuonaType:setFile("ui/chat/chat_common_icon_laba3.png")
				img9Bk:setFile("ui/common/common_scale9_heidi1.png")
			end
		end
		
		self:_createMoveAction(self.m_conMoveNode,nDuration,nMoveX)
    end
end

--@brief 	点击隐藏回调
function WndSuona:onHide(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndSuona:onHide 00")
	if WndSuona.m_root ~= nil then
		WZLog("WndSuona:onHide 11")
		WndSuona.m_root:setVisible(false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	创建文本移动动画
--@param	element:表绑定的UI节点引用
function WndSuona:_createMoveAction(element,nDuration,nMoveX)
	element:stopAllActions()

	local _, nMoveY = element:getPosition()
	
 	local array = CCArray:create()
	array:addObject(CCDelayTime:create(2.0))
	array:addObject(CCMoveTo:create(nDuration, GlobalMethod:ccp(nMoveX, nMoveY)))
	array:addObject(CCCallFuncN:create(function ()
		self:_onFinishActionBack()
	end))
 	local action = CCSequence:create(array)

    if action and element then
		--element:runUIAction(action)
		element:runAction(action)
	end
	
end

--@brief	动画完成回调函数
--@param	obj:执行该动作的对象
function WndSuona:_onFinishActionBack(obj)
    --取消定时器
	self.m_root:disableSchedule()
	local currentRoot = WindowManager:getSceneRoot()
	local con = currentRoot:getChildElement("WndSuona")
	if con~=nil then
		--等完成了上一个，才能加载下一条
		table.remove(self.suonaQuene,1)
		if #self.suonaQuene >=1 and self.m_conMoveNode then
			local ps = self.m_conMoveNode:getRelativePosition()
			self.m_conMoveNode:setRelativePosition(GlobalMethod:ccp(0, ps.y))
			self:_nextSuina()
		else
			con:removeFromParentAndCleanup(true)
		end
	end
end

--@brief	设置彩聊内容颜色变化
function WndSuona:_scheduleColorChange(element,delta)
    --WZLog("WndSuona:_scheduleColorChange",delta)
    if SceneLoginMgr ~= nil and SceneLoginMgr.m_root ~= nil then
		if WndSuona.m_root ~= nil then
			WindowManager:removeWindow(WndSuona.m_root,WndSuona,true)
		end
		return 
    end
	if self.m_txtWorldChat==nil then
		WZLog("self.m_txtWorldChat==nil")
		return
	end
   
	local randIndex = math.random(1,#self.m_tColor)
	if self.m_sOriginal then
		local showText = ToChangeFreeText(self.m_sOriginal,self.m_tColor[randIndex],nil,nil,nil,18)
		if self.m_sOriginal_suonaMsg then
			if self.m_sOriginal_suonaMsg.sendName and self.m_sOriginal_suonaMsg.message then
			    --跨服喇叭vip21名称显示为金色255,227,116
				if self.m_sOriginal_suonaMsg.nChannel == CHANNEL_GOLD and self.m_tColor_gold then
					randIndex = math.random(1,#self.m_tColor_gold)
					showText = ToChangeFreeText(self.m_sOriginal,self.m_tColor_gold[randIndex],nil,nil,nil,18)
					if self.m_sOriginal_suonaMsg.sendVipLevel >= 21 then
						showText = ToChangeFreeText(self.m_sOriginal_suonaMsg.sendName,"255,227,116","132,66,29","4","1",18)..ToChangeFreeText(":" .. self.m_sOriginal_suonaMsg.message, self.m_tColor_gold[randIndex],nil,nil,nil,18)
					end
				end
				if (self.m_sOriginal_suonaMsg.chatType == 0 and self.m_sOriginal_suonaMsg.subType == 2) or (self.m_sOriginal_suonaMsg.chatType == 1 and self.m_sOriginal_suonaMsg.subType == 2) or self.m_sOriginal_suonaMsg.chatType == 2 then
					--跨服喇叭vip21名称显示为金色255,227,116
					WZLog("WndSuona:_scheduleColorChange", self.m_sOriginal_suonaMsg.sendVipLevel, self.m_sOriginal_suonaMsg.chatType, self.m_sOriginal_suonaMsg.subType)
					randIndex = math.random(1,#self.m_tColor)
					if self.m_sOriginal_suonaMsg.sendVipLevel >= 21 then
						showText = ToChangeFreeText(self.m_sOriginal_suonaMsg.sendName,"255,227,116","132,66,29","4","1",18)..ToChangeFreeText(":" .. self.m_sOriginal_suonaMsg.message, self.m_tColor[randIndex],nil,nil,nil,18)
					end
				end
			end	
		end
		self.m_txtWorldChat:setShowText(showText)
	end
end

--@brief	初始化世界聊天文本CCLabelTTF
function WndSuona:_initTxtWorldChat(chat )
	WZLog("WndSuona:_initTxtWorldChat =",chat)
	local sciconMsg = GetElement(self.m_root, "sciconMsg_WndSuona", WZUIScissorContainer)
	sciconMsg:removeAllChildrenWithCleanup(true)

	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	con:setRelativePosition(GlobalMethod:ccp(0,0.5))

	self.m_txtWorldChat = WZUIFreeTextBox:create()
	self.m_txtWorldChat:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	self.m_txtWorldChat:setRelativePosition(GlobalMethod:ccp(0,0.5))

	self.m_tempTxt = WZUILabelTTF:create()
	self.m_tempTxt:setFontSize(18)
	local temp = chat
	for i,v in pairs(WndChat.FACEIMASK) do
		temp = string.gsub(temp,v,"AAA")
	end

	self.m_tempTxt:setText(temp)
	self.m_tempTxt:setVisible(false)

	sciconMsg:addChild(self.m_tempTxt)

	local txtSize = self.m_tempTxt:getLabelContentSize()
	local width = txtSize.width
	
	con:setAbsContentSize(GlobalMethod:CCSize(width+30,57))
	self.m_txtWorldChat:setMaxWidth(width+700)
	con:addChild(self.m_txtWorldChat)
	self.m_conMoveNode = con
	sciconMsg:addChild(con)
end

-------------------------------------私有方法模块End----------------------------------------
