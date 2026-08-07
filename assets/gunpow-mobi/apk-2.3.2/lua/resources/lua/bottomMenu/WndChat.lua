--WndChat.lua
--@brief	WndChat的UI模块
--@date	2013/12/09
--@author	孙珊珊
--@modify   qixiang_xie
--@note     可切换频道的聊天界面

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note	在这里做场景进入前的准备工作
function WndChat:onEnter(element)
	WZLog("WndChat:onEnter")
	self.m_root = element
	self:setConetextCon(true)
	
	--self:removeFreelistAllCell()
	self:freelistUpdate(self.m_nIsCurrent)
	
    CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
    CacheCenter:registerUpatePlayerInfoObserver(self)--玩家信息

    if not self.m_bAddWeclome then
    	self.m_bAddWeclome = true
    	self:_pushWords(CHANNEL_SYSTEM,nil,nil, nil, nil, LocalStrings.DANADNDAO_WELCOME,nil,nil,nil,nil,nil)
    end

    self:_showCachePriList()
    self:showOldCacheMsg()
	local conchatcontext= GetElement(self.m_root,"conchatcontext_wndchant",WZUIContainer)
    conchatcontext:enableSchedule("showCacheMsg",0.5)
    self:_getBubbleList()
    self:_setPlayerBubbleId()
    self:_initStaticText()
end

local comCCPoint = ccp(0,0)
local comCCSize = CCSize(0,0)

--@brief  监听玩家数据更改
function WndChat:updatePlayerItemData()
	WZLog("WndChat:updatePlayerItemData")
	if self.m_nIsCurrent == CHANNEL_COLORCHAT then
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(115) 
        WZUILabelTTF:luaTo(self.m_root:getChildElement("txtChatPropsCount_WndChat")):setText("x"..nColorLabaNum)
	elseif self.m_nIsCurrent == CHANNEL_GOLD then
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(161057) 
		WZUILabelTTF:luaTo(self.m_root:getChildElement("txtChatPropsCount_WndChat")):setText("x"..nColorLabaNum)
	else
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(114) 
		WZUILabelTTF:luaTo(self.m_root:getChildElement("txtChatPropsCount_WndChat")):setText("x"..nColorLabaNum)
	end
end

--弹窗动画
function WndChat:onEnterTransitionDidFinish(element)
	WZLog("WndChat:onEnterTransitionDidFinish", self.m_nWorldChannelOpenLevel)
	--local leftCon = GetElement(WndChat.m_root,"conchatcontext_wndchant",WZUIContainer)
	--WindowManagerAni:createSwitchTabAction(leftCon,0,true,nil,self,self.oncloseani,0)
   	--WindowManagerAni:createSwitchTabAction(leftCon,0,false,nil,WndChat,WndChat.actionCallback,0)
   	self:SetCheckBoxVisible()
   	self:actionCallback()
   	self:_AdaptationIphoneX()
end

--@brief  弹窗动画结束回调
function WndChat:actionCallback()
	WZLog("actionCallback")
	--启动1秒定时
	local conchatimg = GetElement(self.m_root,"conchatimg_wndchat",WZUIContainer)
	conchatimg:enableSchedule("_scheduleSetTime",1)  
    --self:_freeLockUpdata()
	--刷新每个freelist	
	--self:_updateList()
	--self:_freeLockUpdata()
	
	--多语言版本界面适配
    AdaptLanguage(self)

	--ProtocolProcessorGlobal:send_CHAT_GetSpeakerNum(CacheCenter:getPlayerInfo().id)

	if self.m_root:isVisible() then
		self.isHiden = false
	else
		self.isHiden  = true
	end
    
    --私聊接口进入 特殊处理
	if self.m_ptempname ~= nil then
       	self:_setChoseFriendListBtnText(self.m_ptempname)
    else
    	if CHANNEL_WHISPER == self.m_nIsCurrent then
			self:onClickFastPriChatCallback(0)
		end
	end
	--self.m_ptempname = nil
	
	if self.m_nIsCurrent == CHANNEL_COLORCHAT then
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(115) 
        WZUILabelTTF:luaTo(self.m_root:getChildElement("txtChatPropsCount_WndChat")):setText("x"..nColorLabaNum)
    elseif self.m_nIsCurrent == CHANNEL_GOLD then
    	local nColorLabaNum = CacheCenter:getPlayerItemCountById(161057) 
        WZUILabelTTF:luaTo(self.m_root:getChildElement("txtChatPropsCount_WndChat")):setText("x"..nColorLabaNum)
	else
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(114) 
		local txtChatPropsCount = GetElement(self.m_root,"txtChatPropsCount_WndChat",WZUILabelTTF)
		if txtChatPropsCount ~= nil then
			txtChatPropsCount:setText("x"..nColorLabaNum)
		end
	end
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note	在这里做场景退出前的清理工作
function WndChat:onExit(element) 
	WZLog("WndChat:onExit",self.m_root:retainCount())
	self.m_root:setZOrder(0) 
	self:_unInit()
	self.isHiden = true
    
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
end

--------------------------------------关于外部调用创建接口函数---------------------------------
--@brief	加载聊天界面接口
function WndChat:initChat()
	WZLog("WndChat:initChat")
	if self.m_root == nil then
		WZLog("WndChat:initChat 123")
		self:_createChatWindow(CHANNEL_WORLD)
		WindowManager:addWindow(self.m_root, WndChat,nil,nil,nil,false)
		self:_hideChatWindows()
	end
end

-- --@brief	加载聊天界面接口
-- function WndChat:showChatWindow()
-- 	if self.m_root == nil then
-- 		self:_createChatWindow(CHANNEL_WORLD)
-- 	end
-- 	WindowManager:addWindow(self.m_root, WndChat)
-- end

--@brief      加载聊天界面接口
--@param    nOrder: 界面order值
function WndChat:showChatWindowForFightingByOrder(channelType, txtContent)
    WZLog("WndChat:showChatWindowForFightingByOrder  00 =",channelType)
    local bLoad = false
    if channelType == nil and CacheCenter:getRedState( "btnChat" ) then
    	channelType = CHANNEL_WHISPER
    end
    local nPlayerLevel = CacheCenter:getPlayerInfo().level
	if self.m_root == nil then
		local nTempChannelType 
		if self.m_nIsCurrent == nil then
			nTempChannelType = CHANNEL_WORLD
			bLoad = true
		else
			if channelType == nil then
				channelType = self.m_nIsCurrent
			end
			nTempChannelType = channelType
			bLoad = true
		end
		self:_createChatWindow(nTempChannelType)
	end
	if channelType ~= nil then
		WZLog("WndChat:showChatWindowForFightingByOrder 222",channelType)
		self.m_nIsCurrent = channelType
	end

	WndCurrentChat:wndCurChatVisible(false)
	
	if not WindowManager:ifWindowExist(WndChat) then
   		WindowManager:addWindow(self.m_root, WndChat,false)
   		self.m_root:setVisible(true)
   	else
   		if not self.m_root:isVisible() then
		    self.m_root:setVisible(true)
		    self:actionCallback()
   		end
	end
	
	if not bLoad then
		self:_setChatType(self.m_nIsCurrent)

		self:selTextChange(self.m_nIsCurrent)
		self:freelistUpdate(self.m_nIsCurrent)
		local index = self:_getCheckIndex(self.m_nIsCurrent)
		self:setShowFrameelement(index)
	end
	
	-- Add hyx
	-- if CHANNEL_WHISPER == self.m_nIsCurrent then
	-- 	self:onClickFastPriChatCallback(0)
	-- end

	CacheCenter:setRedState("btnChat", false)
	GlobalGame:getBtnRedPointEvent():dispatcher()

	--Add By Tianxiang_Xu
	if txtContent then
		if channelType == CHANNEL_WORLD then
			local conWorld = WZUIContainer:luaTo(self.m_root:getChildElement("conWorld_WndChat"))
			local edtInputWorld = WZUIEditBox:luaTo(conWorld:getChildElement("edtInputWorld_WndChat"))
			if not conWorld:isVisible() then
				return
			end
			if edtInputWorld ~= nil then
				edtInputWorld:setText(txtContent)
			end
		elseif channelType == CHANNEL_GUILD then
			local conCur = WZUIContainer:luaTo(self.m_root:getChildElement("conCur_WndChat"))
			local edtInputCur = WZUIEditBox:luaTo(conCur:getChildElement("edtInputCur_WndChat"))
			if not conCur:isVisible() then
				return
			end
			if edtInputCur ~= nil then
				edtInputCur:setText(txtContent)
			end
		end
	end
end

--把聊天系统窗口添加到当前场景
function WndChat:addChatWindowToCurScene()
	WZLog("WndChat:addChatWindowToCurScene")
	if self.m_root == nil then
		if self.m_nIsCurrent == nil then
			self:_createChatWindow(CHANNEL_WORLD)
		else
			self:_createChatWindow(self.m_nIsCurrent)
		end
	end

	if not WindowManager:ifWindowExist(WndChat) then
		self.m_root:setZOrder(0)
   		WindowManager:addWindow(self.m_root, WndChat,false)
   		self.m_root:setVisible(false)
	end
end

--@brief      好友中，加载聊天界面接口（用于私聊）
--@param    receivePlayerId   被私聊的玩家id
--@param    receivePlayerName 被私聊的玩家name
--@param    receivePlayerSex  被私聊的玩家性别
--@param    receivePlayerLevel  被私聊的玩家等级
--@param    receivePlayerVipLevel  被私聊的玩家VIP等级
--@param    receivePlayerHead 被私聊的玩家头像ID
--@param    receivePlayerFace 被私聊的玩家脸ID
--@param    receivePlayerHeadColor 被私聊的玩家头颜色
function WndChat:showChatWindowForPrivateWithIdAndName(receivePlayerId,receivePlayerName,receivePlayerSex,receivePlayerLevel,receivePlayerVipLevel,receivePlayerHead,receivePlayerFace,receivePlayerHeadColor, receivePlayerHeadEffectId)
	WZLog("WndChat:showChatWindowForPrivateWithIdAndName")
	if receivePlayerId == nil or receivePlayerName == nil or receivePlayerSex == nil or receivePlayerLevel == nil or receivePlayerVipLevel == nil then
	    return
	end
	local bCleanFreeList = false
	if self.m_nReciveId ~= receivePlayerId then
		bCleanFreeList = true
	end
	self.m_nReciveId = receivePlayerId
	self.m_nReciveLevel = receivePlayerLevel
	self.m_nReceivePlayerSex = receivePlayerSex          
	self.m_nReceivePlayerVipLevel = receivePlayerVipLevel     
	if self.m_nReceivePlayerSex == 1 then
		receivePlayerHead = receivePlayerHead and receivePlayerHead or 4906
		receivePlayerFace = receivePlayerFace and receivePlayerFace or 4905
	else
		receivePlayerHead = receivePlayerHead and receivePlayerHead or 4903
		receivePlayerFace = receivePlayerFace and receivePlayerFace or 4902
	end
	receivePlayerHeadColor = receivePlayerHeadColor and receivePlayerHeadColor or 0

	self.m_nReceivePlayerHead  = receivePlayerHead        
	self.m_nReceivePlayerFace = receivePlayerFace         
	self.m_nReceivePlayerHeadColor = receivePlayerHeadColor
	self.m_nReceivePlayerHeadEffectId = receivePlayerHeadEffectId

    self.m_ptempname  = receivePlayerName
	self:showChatWindowForPrivate(receivePlayerName)

	self:_addLatelyPriChatPlayer(self.m_nReciveId, self.m_nReciveLevel, receivePlayerName, self.m_nReceivePlayerVipLevel, receivePlayerHead, receivePlayerFace, receivePlayerSex, receivePlayerHeadColor, nil, true, nil, nil, nil, receivePlayerHeadEffectId)

	if bCleanFreeList then
		local freelistconPrivate = GetElement(self.m_root,"freelistconPrivate_WndChat",WZUIFreeListContainer)
	    freelistconPrivate:removeAll()
	    self:showCurPriList()
	end
end

--@brief      好友中，加载聊天界面接口（用于私聊）
--@param    playerName 玩家name
--@param    playerId 私聊好友ID
function WndChat:showChatWindowForPrivate(playerName)
	WZLog("self.m_root::::",self.m_root,playerName)
	self.m_ptempname  = playerName
	self.m_nIsCurrent = CHANNEL_WHISPER
	
    if WindowManager:ifWindowExist(WndChat) then
   		--WindowManager:removeWindow(self.m_root, self,true)
	end
	
	--下方的显示
	WndChat:showChatWindowForFightingByOrder(nil)
	self:callbackAddPrivate(playerName)
end

--@brief 	点击红包按钮回调
function WndChat:onClickRedPack(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if SceneBattle.m_root then 
		MsgBoxManager:showTipBox(LocalStrings.RED_PACK13)
		return 
	end
	local channelId = 0
	if self.m_nIsCurrent == 0 then
		channelId = 0
	elseif self.m_nIsCurrent == 2 then
		channelId = 1
	end
	WndChallengeLevel:showInterface(nil, nil, nil, nil, channelId)
end

--@brief    点击世界红包回调
function WndChat:onClickGetRedPack(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    ProtocolProcessorGlobal:send_CHAT_GrabRedEnvelope(-1,0)
    --点击过，隐藏快捷领取按钮
    g_QuickRedPackState = false
    if SceneCity and SceneCity.m_tWndBottomBarObj then
        SceneCity.m_tWndBottomBarObj:setRedPackBtnVisible()
    end
    WndChat:setRedPackBtnVisible()
end

--@brief    点击公会红包回调
function WndChat:onClickGetRedPack2(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    ProtocolProcessorGlobal:send_CHAT_GrabRedEnvelope(-1,1)
    --点击过，隐藏快捷领取按钮
    g_QuickRedPackState2 = false
    if SceneCity and SceneCity.m_tWndBottomBarObj then
        SceneCity.m_tWndBottomBarObj:setRedPackBtnVisible()
    end
    WndChat:setRedPackBtnVisible()
end

------------------------------------关于界面点击事件----------------------------------------

--@brief	点击界面
--@param	点击界面关闭更新
function WndChat:onTouchBegin(element, pt) --点击界面，如想玩家姓名弹出玩家信息
	self.m_lTouchTime = os.time()
	self.m_nVoiceSecond = os.time()
	self.m_nTouchX = pt.x
	self.m_nTouchY = pt.y
	self:canRecording(pt)
	if not self.m_bRecording  then
		GetElement(self.m_root,"frameelement_WndChat",WZUIFrameElement):setTouchEnable(true)
	end
	if WndChatReportMenu and WndChatReportMenu.m_root then 
		if not WndChatReportMenu:checkPointInBtn(pt) then 
			WndChatReportMenu:closeMenuWin()
		end
	end
end

function WndChat:onEditBoxTouchBegin()
	WZLog("WndChat:onEditBoxTouchBegin")
	self:setFaceBoxNotVisible()
	self:setBubbleBoxNotVisible()
	self:setBlockStrangerVisible(false)
end

--@brief  监听触摸移动
function WndChat:onTouchMove(element,pt)
	--if math.abs((pt.y-self.m_nTouchY)) > 15 and self.m_bRecording then --取消发送录音
    	if self.m_bRecording then
    		--WZLog("---------取消录音发送----------")
    		GetElement(self.m_root,"frameelement_WndChat",WZUIFrameElement):setTouchEnable(false)
    		self:canRecording(pt)
    	end

	--end
end

--@brief	弹起事件
--@param 	弹起的时候恢复更新
function WndChat:onTouchEnd(element,pt)
	WZLog("WndChat:onTouchEnd...................")
	
	if self.m_bRecording then
		self:cancelSendRecord()
	else
		self:disableVoiceChat()
	end
end

--@brief  判断录音状态
function WndChat:canRecording(pt)
	WZLog("WndChat:canRecording")
	local isTouchRecordBtn = false
	if WGCloudVoiceNotify:IsSupportVoice()  then  --可以进行语音聊天
		local playerInfo = CacheCenter:getPlayerInfo()
		if self.m_nIsCurrent ~= CHANNEL_WHISPER then
			local conVoiceChat = nil
			local conWorldVoice = nil
			if self.m_nIsCurrent ~= CHANNEL_WORLD and self.m_nIsCurrent ~= CHANNEL_COLORCHAT and self.m_nIsCurrent ~= CHANNEL_GOLD then
				conVoiceChat = GetElement(self.m_root,"conVoiceChat_WndChat",WZUIContainer)
				if not conVoiceChat:isVisible() then
					return
				end
			else
				conWorldVoice = GetElement(self.m_root,"conWorldVoice_WndChat",WZUIContainer)
				if not conWorldVoice:isVisible() then
					return
				end
			end
			
			local conVoiceChatSize = nil
			local clPt = nil
			if self.m_nIsCurrent ~= CHANNEL_WORLD and self.m_nIsCurrent ~= CHANNEL_COLORCHAT and self.m_nIsCurrent ~= CHANNEL_GOLD then
				conVoiceChatSize = conVoiceChat:getContentSize()
				clPt = conVoiceChat:convertToNodeSpace(pt)
			else
				conVoiceChatSize = conWorldVoice:getContentSize()
				clPt = conWorldVoice:convertToNodeSpace(pt)
			end
			
			if clPt.x >= 0 and clPt.x <=  conVoiceChatSize.width and clPt.y>=0 and clPt.y <= conVoiceChatSize.height then
	            if GetPlayTalk() == 1 then
		            MsgBoxManager:showTipBox(LocalStrings.VOICE_CHAT_STOP)
		            return 
	            end

	            if self.m_nTimes > 0 then
				    MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
				    return
			    end

	            if WndChat.m_oCurPlayRecordCell ~= nil then
		    		WZLog("stop play recording .........")
    				self:stopPlayVoice()
		    	end

		    	if self.m_bRecording then
		    		local conRecordingArm = GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer)
		    		conRecordingArm:setVisible(true)
		    		
		    	    GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
		    	    if  self.m_nIsCurrent == CHANNEL_WORLD then
		    	    	GetElement(self.m_root,"txtVoiceControl3_WndChat",WZUILabelTTF):setText(LocalStrings.SEND_RECORDING)
		    	    else
		    	    	GetElement(self.m_root,"txtVoiceControl_WndChat",WZUILabelTTF):setText(LocalStrings.SEND_RECORDING)
		    	    end
		    	end
		    	
		    	--根据当前场景获取相应的聊天室
		    	if not self.m_bRecording and self.m_nIsCurrent == CHANNEL_CURRENT then
		    		local bSupprot = self:bSupportRecod()
		    		if not bSupprot then
		    			return
		    		end
	                
					local temp = {["chatChannel"]=self.m_nIsCurrent,["recPlayerId"]=0}
	                local errorCode = self:_startVoiceRecording(temp)
	                if not errorCode then
	                	return
	                end
	                --开始语音聊天
				    self.m_bRecording = true
	                GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer):setVisible(true)
		    	    GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
		    	    GetElement(self.m_root,"txtVoiceControl_WndChat",WZUILabelTTF):setText(LocalStrings.SEND_RECORDING)
				    return
				elseif not self.m_bRecording and self.m_nIsCurrent == CHANNEL_GUILD and playerInfo.guildId  > 0 then
				    
				    local bSupprot = self:bSupportRecod()
		    		if not bSupprot then
		    			return
		    		end
	                
	                local temp = {["chatChannel"]=self.m_nIsCurrent,["recPlayerId"]=0}
	                local errorCode = self:_startVoiceRecording(temp)
	                if not errorCode then
	                	return
	                end
	                self.m_bRecording = true
	                GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer):setVisible(true)
		    	    GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
		    	    GetElement(conVoiceChat,"txtVoiceControl_WndChat",WZUILabelTTF):setText(LocalStrings.SEND_RECORDING)
	               
	                return
		           
				elseif not self.m_bRecording and ( self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT or self.m_nIsCurrent == CHANNEL_GOLD) then
					local bSupprot = self:bSupportRecod()
		    		if not bSupprot then
		    			return
		    		end

					--世界频道vip2以上才能语音
					if CacheCenter:getPlayerInfo().vipLevel < 2 then
						MsgBoxManager:showTipBox(LocalStrings.CHAT_VOICE_LIMIT)
						return
					end

	                if self.m_nIsCurrent == CHANNEL_WORLD then
		    			local nLabaNum = CacheCenter:getPlayerItemCountById(114) 
						if nLabaNum < 1 then
							MsgBoxManager:showConfirmBox(LocalStrings.CHAT_NOLABA,self,self.clickSureBack) --世界喇叭不足，请先购买该道具！
					        return
					    end
	                elseif self.m_nIsCurrent == CHANNEL_GOLD then
	                	local nLabaNum = CacheCenter:getPlayerItemCountById(161057) 
						if nLabaNum < 1 then
							WndFastGetItems:show(161057, 1) --金喇叭不足
					        return
					    end
					else
						local nLabaNum = CacheCenter:getPlayerItemCountById(115) 
						if nLabaNum < 1 then
							MsgBoxManager:showConfirmBox(LocalStrings.CHAT_NOCOLORLABA,self,self.clickColorSureBack) --跨服喇叭不足，请先购买该道具！
					        return
					    end
		    		end
		    		
		    		local temp = {["chatChannel"]=self.m_nIsCurrent,["recPlayerId"]=0}
	                local errorCode = self:_startVoiceRecording(temp)
	                if not errorCode then
	                	return
	                end

		    		--开始语音聊天
				    self.m_bRecording = true
	                GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer):setVisible(true)
		    	    GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
		    	    GetElement(self.m_root,"txtVoiceControl3_WndChat",WZUILabelTTF):setText(LocalStrings.SEND_RECORDING)
			    	
				    return
				elseif not self.m_bRecording and self.m_nIsCurrent == CHANNEL_GUILD and playerInfo.guildId <= 0 then
					MsgBoxManager:showTipBox(LocalStrings.SHOP_NOGONGHUI)
					self.m_bRecording = false
					return
				elseif not self.m_bRecording and self.m_nIsCurrent == CHANNEL_TEAM then
					if SceneBattle.m_root == nil and SceneRoom.m_root == nil then
			            MsgBoxManager:showTipBox(LocalStrings.NO_INBATTLE_TIP)
			            return 
		            end
		            local bSupprot = self:bSupportRecod()
		    		if not bSupprot then
		    			return
		    		end
			    	
			    	local temp = {["chatChannel"]=self.m_nIsCurrent,["recPlayerId"]=0}
	                local errorCode = self:_startVoiceRecording(temp)
	                if not errorCode then
	                	return
	                end
	                --开始语音聊天
					self.m_bRecording = true
	                GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer):setVisible(true)
		    		GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
			    	GetElement(self.m_root,"txtVoiceControl3_WndChat",WZUILabelTTF):setText(LocalStrings.SEND_RECORDING)
				    
					return
				elseif not self.m_bRecording and self.m_nIsCurrent == CHANNEL_UNION and (playerInfo.unionInfo == nil or playerInfo.unionInfo.id == nil or playerInfo.unionInfo.id <= 0) then 
					MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[49])
					self.m_bRecording = false
					return
		    	end
		    	isTouchRecordBtn = true
			end
		elseif self.m_nIsCurrent == CHANNEL_WHISPER then
			local conPriRecord = GetElement(self.m_root,"conPriRecord_WndChat",WZUIContainer)
			if not conPriRecord:isVisible() then
				return
			end
			local conPriRecordSize = conPriRecord:getContentSize()
			local clPt = conPriRecord:convertToNodeSpace(pt)
			if clPt.x >= 0 and clPt.x <=  conPriRecordSize.width and clPt.y>=0 and clPt.y <= conPriRecordSize.height then
	            if GetPlayTalk() == 1 then
		            MsgBoxManager:showTipBox(LocalStrings.VOICE_CHAT_STOP)
		            return 
	            end
	            local conPri = GetElement(self.m_root,"conPri_WndChat",WZUIContainer)
			    local txtFriendName = GetElement(conPri,"txtFriendName_WndChat",WZUILabelTTF)
			    local playerN = txtFriendName:getText()
			    if playerN == nil or playerN == "" or string.len(playerN) == 0 or self.m_nReciveId == 0 or self.m_nReciveId == nil then
			    	MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_ID)--选择好友名字
			    	return
			    end
			    
			    if self.m_bRecording then
			    	local conRecordingArm = GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer)
		    		conRecordingArm:setVisible(true)
		    	    GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
		    	    GetElement(self.m_root,"txtVoiceControl2_WndChat",WZUILabelTTF):setText(LocalStrings.SEND_RECORDING)
		    	end

			    if not self.m_bRecording then
			    	local bSupprot = self:bSupportRecod()
		    		if not bSupprot then
		    			return
		    		end
				    
				    local temp = {["chatChannel"]=self.m_nIsCurrent,["recPlayerId"]=self.m_nReciveId}
	                local errorCode = self:_startVoiceRecording(temp)
	                if not errorCode then
	                	return
	                end
	                 --开始语音聊天
		    		GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer):setVisible(true)
		    	    GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
		    	    GetElement(self.m_root,"txtVoiceControl2_WndChat",WZUILabelTTF):setText(LocalStrings.SEND_RECORDING)
	                self.m_bRecording = true
				    return
			    end
			    isTouchRecordBtn = true
			end
		end
	end
   
	if not isTouchRecordBtn and self.m_bRecording then
		GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(true)
		if self.m_nIsCurrent ~= CHANNEL_WHISPER then
			if isChannelPC() then 
				GetElement(self.m_root,"txtVoiceControl_WndChat",WZUILabelTTF):setText(LocalStrings.QQHALL_TEXT1[6])
			else
				GetElement(self.m_root,"txtVoiceControl_WndChat",WZUILabelTTF):setText(LocalStrings.LOOSEN_YOUR_FINGER_CANCEL)
			end
		else
			if isChannelPC() then 
				GetElement(self.m_root,"txtVoiceControl2_WndChat",WZUILabelTTF):setText(LocalStrings.QQHALL_TEXT1[6])
			else
				GetElement(self.m_root,"txtVoiceControl2_WndChat",WZUILabelTTF):setText(LocalStrings.LOOSEN_YOUR_FINGER_CANCEL)
			end
		end
	end
end


--@brief	弹出好友界面
--@param	element:定时器绑定的UI节点引用
function WndChat:onclickFriend(element)
	WZLog("WndChat:onclickFriend(element)")
	local wndFriendImpl = WndFriendImpl:createElement()
    	WndFriendImpl:setClickFlag(1)
	local zOrder = self.m_root:getZOrder()
	zOrder = math.max(zOrder,self.m_nOrder)
	wndFriendImpl:setZOrder(zOrder)
	WndFriendImpl:setFriendCloseBackFun(self,self.selectFriend)
	WZLog("WndFriendImpl:setFriendCloseBackFun(self,self.selectFriend)")
	if self.m_backFun then
		self.m_backFun[2](self.m_backFun[1])
		self.m_backFun = nil 
	end
    WindowManager:addWindow(wndFriendImpl, WndFriendImpl)
end

--@brief  取消录音发送
function WndChat:cancelSendRecord()
	WZLog("WndChat:cancelSendRecord")
	WGCloudVoiceNotify:CancelRecording()
	self.m_bRecording = false
	self.m_nRecordLength = 0
	self.m_bCancelRecording = true
	self:disableVoiceChat()
	GetElement(self.m_root,"txtVoiceControl_WndChat",WZUILabelTTF):setText(LocalStrings.VOICE_CHAT)
	GetElement(self.m_root,"txtVoiceControl2_WndChat",WZUILabelTTF):setText(LocalStrings.VOICE_CHAT)
	GetElement(self.m_root,"txtRecordLength_WndChat",WZUILabelTTF):setText("")
	GetElement(self.m_root,"frameelement_WndChat",WZUIFrameElement):setTouchEnable(true)
end

function WndChat:disableVoiceChat()
	local conRecordingArm = GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer)
	if conRecordingArm ~= nil and conRecordingArm:isVisible() then
		conRecordingArm:setVisible(false)
	end

	local txtRecordTip = GetElement(conRecordingArm,"txtRecordTip_WndChat",WZUILabelTTF)
	if txtRecordTip then
		if isChannelPC() then 
			txtRecordTip:setTextKey("")
			txtRecordTip:setTex(LocalStrings.QQHALL_TEXT1[7])
		else
			txtRecordTip:setTextKey("NOT_RECORD_VOICE")
		end
	end
	local conRecordingCancel = GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
	if conRecordingCancel ~= nil and conRecordingCancel:isVisible() then
		conRecordingCancel:setVisible(false)
	end
end

--@brief 选择好友聊天回调
function WndChat:selectFriend(friendInfo)
    WZLog("WndChat:selectFriend ")
    WZLog("friendId = ",friendInfo.id,friendInfo.name)
    local bCleanFreeList = false
	if self.m_nReciveId ~= friendInfo.id then
		bCleanFreeList = true
	end
	
    self.m_ptempname =  friendInfo.name      
	self.m_nReciveId = friendInfo.id   
	self.m_nReciveLevel = friendInfo.level 
	self.m_nReceivePlayerSex = friendInfo.sex    
	self.m_nReceivePlayerVipLevel = friendInfo.vipLevel

	if friendInfo.sex   == 1 then
		friendInfo.headItemId = friendInfo.headItemId and friendInfo.headItemId or 4906
		friendInfo.faceItemId = friendInfo.faceItemId and friendInfo.faceItemId or 4905
	else
		friendInfo.headItemId = friendInfo.headItemId and friendInfo.headItemId or 4903
		friendInfo.faceItemId = friendInfo.faceItemId and friendInfo.faceItemId or 4902
	end
	friendInfo.headColor = friendInfo.headColor and friendInfo.headColor or 0

	self.m_nReceivePlayerHead  = friendInfo.headItemId
	self.m_nReceivePlayerFace = friendInfo.faceItemId   
	self.m_nReceivePlayerHeadColor = friendInfo.headColor
	self.m_nReceivePlayerHeadEffectId = friendInfo.headEffectId


	self:_addLatelyPriChatPlayer(self.m_nReciveId, self.m_nReciveLevel, self.m_ptempname, self.m_nReceivePlayerVipLevel, self.m_nReceivePlayerHead, self.m_nReceivePlayerFace, self.m_nReceivePlayerSex, self.m_nReceivePlayerHeadColor, nil, true, nil, nil, nil, self.m_nReceivePlayerHeadEffectId)

	self:_setChoseFriendListBtnText(self.m_ptempname)

	if bCleanFreeList then
		local freelistconPrivate = GetElement(self.m_root,"freelistconPrivate_WndChat",WZUIFreeListContainer)
	    freelistconPrivate:removeAll()
		self:showCurPriList()
	end

end

--@brief	弹出好友界面
--@param	element:定时器绑定的UI节点引用
function WndChat:onclickFriendList(element)
   	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   	local wndFriendImpl = WndFriendList:showInterface(7,WndChat,self.selectFriend)
    WindowManager:addWindow(wndFriendImpl, WndFriendList)  
end

--是否可以进行语音聊天
function WndChat:bSupportRecod()
	WZLog("WndChat:bSupportRecod")
	local playerLevel =  CacheCenter:getPlayerInfo().level
	if playerLevel < GDatatab_button_info["id_54"].open_level and self.m_nIsCurrent ~= CHANNEL_WORLD and self.m_nIsCurrent ~= CHANNEL_COLORCHAT then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_54"].feedback_info)
		return false
	else
		if self.m_nIsCurrent == CHANNEL_WORLD  then
			local openLevel = GDatatab_button_info["id_67"].open_level
		    if playerLevel < openLevel then
		    	MsgBoxManager:showTipBox(GDatatab_button_info["id_67"].feedback_info)
		    	return false
		    end
		    if playerLevel < GDatatab_button_info["id_54"].open_level then
		        MsgBoxManager:showTipBox(GDatatab_button_info["id_54"].feedback_info)
		        return false
		    end
		elseif self.m_nIsCurrent == CHANNEL_COLORCHAT then
			local openLevel = GDatatab_button_info["id_70"].open_level
			if playerLevel < openLevel then
		    	MsgBoxManager:showTipBox(GDatatab_button_info["id_70"].feedback_info)
		    	return false
		    end
		    if playerLevel < GDatatab_button_info["id_54"].open_level then
		        MsgBoxManager:showTipBox(GDatatab_button_info["id_54"].feedback_info)
		        return false
		    end
		elseif self.m_nIsCurrent == CHANNEL_CURRENT then
			local packageName = WGameCmUtil:GetBundleIdentifier()
			if packageName ~= "com.bombman.omgEU" and packageName ~= "com.bombman.omg" and  
				packageName ~= "com.bombmaster.mg" and packageName ~= "com.sao.ios.bmmj" and 
				packageName ~= "com.sfrz.ddd" and packageName ~= "com.ddd.haiwai" and 
				packageName ~= "com.overseas.dan" then
				if playerLevel < 12 and SceneCity.m_root ~= nil then
		    		MsgBoxManager:showTipBox(LocalStrings.CITY_SCENE_NOT_SUPPORT_CHAT)
		    		return false
		    	end
		    end
		end
	end
	return true
end

--@brief  进行语音聊天
function WndChat:onClickVoice(element)
	WZLog("WndChat:onClickVoice")
	--do return end 
	
	if not WGCloudVoiceNotify:IsSupportVoice() then
		MsgBoxManager:showTipBox(LocalStrings.VOICE_CHAT_STOP)
		return 
	end

	if GetPlayTalk() == 1 then
		MsgBoxManager:showTipBox(LocalStrings.VOICE_CHAT_STOP)
		return 
	end

	local bSupport = self:bSupportRecod()
	if not bSupport then
		return
	end

	--世界频道vip2以上才能语音
	if (self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT) and CacheCenter:getPlayerInfo().vipLevel < 2 then
		MsgBoxManager:showTipBox(LocalStrings.CHAT_VOICE_LIMIT)
		return
	end
	
	if self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT or self.m_nIsCurrent == CHANNEL_GOLD then
		GetElement(self.m_root,"conWorld_WndChat",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conWorldVoice_WndChat",WZUIContainer):setVisible(true)
	end
	self.m_bRecordingChat = true
	self:_setChatType(self.m_nIsCurrent)
end

--@brief 进行语音聊天
function WndChat:onClickVoiceChat(element)
	WZLog("WndChat:onClickVoiceChat")
	if not self.m_bRecording then
		return
	end
	self:sendRecordChat()
end

--@brief  发送语音信息
function WndChat:sendRecordChat()
    WZLog("WndChat:sendRecordChat")
    GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conRecordingCancel_WndChat",WZUIContainer):setVisible(false)
	local curT = os.time()
	local recordT = curT - self.m_nVoiceSecond  --录制了多少秒
	if recordT >= 1 then
		WZLog("WndChat:sendRecordChat--------------------")
		local bExit = false
		local tempIndex = nil
		for i,v in ipairs(self.m_tPriPlayerInfo) do
			if v[1] == self.m_nReciveId then
				bExit = true
				tempIndex = i
				break
			end
		end
		if self.m_nReciveId ~= nil and self.m_nReciveId > 0 then
			if not bExit then
				local temp = {}
				table.insert(temp,self.m_nReciveId)
				table.insert(temp,self.m_ptempname)
				table.insert(self.m_tPriPlayerInfo,temp)
				
			else
				if tempIndex ~= nil then
					self.m_tPriPlayerInfo[tempIndex][2] = self.m_ptempname
				end
			end
		end
		self.m_nTimes = self.m_nTimes + 5
		self.m_nRecordLength = 0
		GetElement(self.m_root,"frameelement_WndChat",WZUIFrameElement):setTouchEnable(true)
		GetElement(self.m_root,"txtRecordLength_WndChat",WZUILabelTTF):setText("")
		self.m_bRecording = false
		WGCloudVoiceNotify:StopRecording()
		return
	else
		MsgBoxManager:showTipBox(LocalStrings.RECODRING_ERROR)
	end
	self:cancelSendRecord()
end

--@brief 进行键盘输入聊天
function WndChat:onClickKeyboard(element)
	WZLog("WndChat:onClickKeyboard")

	if not self.m_bSupportRecord then
		WZLog("not support record")
		return
	end
	self.m_bRecordingChat = false
	self.m_bRecording = false
	self:_setChatType(self.m_nIsCurrent)
end

--@breif  播放语音
function WndChat:onClickPlayRecord(element)
	WZLog("WndChat:onClickPlayRecord ",WndChat)
	if not WGCloudVoiceNotify:IsSupportVoice()  then  --可以进行语音聊天
		MsgBoxManager:showTipBox(LocalStrings.VOICE_CHAT_NOT_SUPPORT)
		return
	end
	local parent = element:getParent()
	local pParent = parent:getParent()
	if WndChat.m_oCurPlayRecordCell == nil then
		local voiceElement = WZUIContainer:luaTo(pParent:getParent())
		local parentElement = WZUIContainer:luaTo(voiceElement:getParent())
		WndChat:playRecordVoice(parentElement)
	else--停止播放语音信息
    	WndChat:stopPlayVoice()
	end
    
end

--@brief  播放语音
function WndChat:playRecordVoice(element)
	WZLog("WndChat:playRecordVoice")
	local conMsgInfo = GetElement(element,"conMsgInfo_WndChat",WZUIContainer)
	local recordId = GetElement(conMsgInfo,"txtMsgId_WndChat",WZUILabelTTF):getText()
	if recordId == nil or recordId == "" then
		WZLog("recordId is nil")
		return
	end
	
	local playerStatus = WGCloudVoiceNotify:PlayRecordedFile(recordId)
	WZLog("playerStatus = ",playerStatus)
	if playerStatus and tonumber(playerStatus) and tonumber(playerStatus) ~= 0 then
		MsgBoxManager:showTipBox(LocalStrings.VOICE_RECORDING_ERROR2)
		return
	end

	local bExit = false
	for i,v in ipairs(self.m_tPlayerVoiceId) do
		if v == recordId then
			bExit = true
			break
		end
	end
	if not bExit then
		table.insert(self.m_tPlayerVoiceId,recordId)
	end

	WndChat.m_oCurPlayRecordCell = element
	--SoundManager:pauseBackgroundMusic()
	local imgVoice = GetElement(conMsgInfo,"imgVoice_WndChat",WZUIImage)
	if imgVoice then
		imgVoice:setVisible(false)
	end
	local armPlayRecord = GetElement(conMsgInfo,"armPlayRecord_WndChat",WZUISpine)
	if armPlayRecord then
		armPlayRecord:setVisible(true)
	end

	local conPlayRecordS = GetElement(conMsgInfo,"conPlayRecordS_WndChat",WZUIContainer)
	if conPlayRecordS then
		conPlayRecordS:setVisible(false)
	end

	--更新本地私聊缓存播放状态为已播放
	--WZLog("WndChat:playRecordVoice === m_tOldPrivateMsgList", Serialize(self.m_tOldPrivateMsgList))
	for i,v in ipairs(self.m_tOldPrivateMsgList) do
		for j,k in ipairs(v) do
			mainChannel = k.mainChannel
			if mainChannel == nil then
				break
			end
			local recordMsg = k.recordMsg
			local messageId = k.messageId
			if recordMsg and messageId == recordId then --语音聊天
				WZLog("WndChat:playRecordVoice === find out cur voiceId 1")
				--WZLog("WndChat:playRecordVoice === find out cur voiceId 1", Serialize(v[j]))
				self.m_tOldPrivateMsgList[i][j].bPlayed = 1
				--WZLog("WndChat:playRecordVoice === find out cur voiceId 2", Serialize(self.m_tOldPrivateMsgList[i][j]))
				self:_addPriChatToLocal()
			end
		end
	end
end

--@brief 停止播放语音
function WndChat:stopPlayVoice()
	WZLog("WndChat:stopPlayVoice")
	WGCloudVoiceNotify:StopPlayFile()
	if WndChat.m_oCurPlayRecordCell == nil then
		return
	end
	local imgVoice = GetElement(WndChat.m_oCurPlayRecordCell,"imgVoice_WndChat",WZUIImage)
	if imgVoice then
		imgVoice:setVisible(true)
	end
	local armPlayRecord = GetElement(WndChat.m_oCurPlayRecordCell,"armPlayRecord_WndChat",WZUISpine)
	if armPlayRecord then
		armPlayRecord:setVisible(false)
	end
	WndChat.m_oCurPlayRecordCell = nil
end

--@brief  播放语音完毕回调
function WndChat:callbackRecordPlayFinish()
	WZLog("WndChat:callbackRecordPlayFinish ")
	if WndChat.m_oCurPlayRecordCell ~= nil and WndChat.m_root ~= nil then
		local imgVoice = GetElement(WndChat.m_oCurPlayRecordCell,"imgVoice_WndChat",WZUIImage)
		if imgVoice then
			imgVoice:setVisible(true)
		end
		local armPlayRecord = GetElement(WndChat.m_oCurPlayRecordCell,"armPlayRecord_WndChat",WZUISpine)
		if armPlayRecord then
			armPlayRecord:setVisible(false)
		end
    	WndChat.m_oCurPlayRecordCell = nil	
	end
end

--@brief	关闭当前聊天页面
--@param	element:定时器绑定的UI节点引用
function WndChat:onClickClose(element)
	WZLog("WndChat:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	self:oncloseani()
end

function WndChat:oncloseani()
	WZLog("WndChat:oncloseani")
	WndChat:_hideChatWindows()
end

--查看特定玩家的私聊信息
function WndChat:onClickFastPriChatCallback(tag)
	WZLog("WndChat:onClickFastPriChatCallback")
	if WndChat.m_oCurPlayRecordCell then
		self:stopPlayVoice()
	end
	local tabFriendList = GetElement(self.m_root,"tabFriendList_WndChat",WZUITableContainer)
	for i,v in ipairs(self.m_tRecentlyPlayerList) do
		if i ~= tag+1 then
			local element = tabFriendList:getCellElement(i-1)
			if element then
				element =WZUIContainer:luaTo(element:getChildByTag(i-1))
				local luaObjectIndex = element:getLuaObjectIndex()
				if luaObjectIndex then
					luaObjectIndex:setBSelect(false)
				end
			end
		end
	end

	local freelistconPrivate = GetElement(self.m_root,"freelistconPrivate_WndChat",WZUIFreeListContainer)
	freelistconPrivate:removeAll()
	WZLog("**********-----: ",tag)
	if tag == 0 then
		local tempT = self:getAssantToLocal()
		--去掉重复的东西
		local has_msg = {}
		local has_index = 1
		for i,v in ipairs(tempT) do
			local status = true

			local index = 1
			local str_msg = string.match(v.words,"{^ttyy##%d+##")
			local str_circle = string.match(v.words, g_FriendCircleMessage_Mark)
			if str_msg then
				index = string.match(str_msg,"%d+")
				index = tonumber(index)
			end
			if not str_circle then 
				for i,item in pairs(has_msg) do
					if index >= 44 and index <= 99 then
					else
						if item.words == v.words then
							status = false
							break
						end
					end
				end
			end
			if status == true then
				has_msg[has_index] = v
				has_index = has_index + 1
			end
		end

		-- WZLog("has_msg......::: ",Serialize(has_msg))
		local index, start = 1, 1
		if #has_msg - 10 > 0 then
			start = #has_msg - 9
		end
		local showmsg = {}
		for i=start, #has_msg do
			showmsg[index] = has_msg[i]
			index = index + 1
		end
		-- WZLog("showmsg......::: ",Serialize(showmsg))
		self.m_nReciveId = 0
		self.m_ptempname = nil
		local recentlyPlayerInfo = self.m_tRecentlyPlayerList[1]
		recentlyPlayerInfo.bShowRed = false
		self:_setChoseFriendListBtnText(nil)
		if next(showmsg) ~= nil then
			for i,v in ipairs(showmsg) do
				self:showMsg(v,CHANNEL_WHISPER)
			end
	    end
	else
		local recentlyPlayerInfo = self.m_tRecentlyPlayerList[tag+1]
		recentlyPlayerInfo.bShowRed = false
		local tempId = recentlyPlayerInfo.id
		self.m_nReciveId = tempId
		self.m_ptempname = recentlyPlayerInfo.name
		self.m_nReciveLevel = recentlyPlayerInfo.level              
		self.m_nReceivePlayerSex = recentlyPlayerInfo.sex          
		self.m_nReceivePlayerVipLevel = recentlyPlayerInfo.vipLevel    
		self.m_nReceivePlayerHead  = recentlyPlayerInfo.head        
		self.m_nReceivePlayerFace = recentlyPlayerInfo.face        
		self.m_nReceivePlayerHeadColor = recentlyPlayerInfo.headColor 
		self.m_nReceivePlayerHeadEffectId = recentlyPlayerInfo.headEffectId   
		self:_setChoseFriendListBtnText(self.m_ptempname)

		self:showCurPriList()
	end
end


--@brief	发送信息
--@param	element:发送按钮
function WndChat:onclickSend(element)
    WZLog("WndChat:onclickSend", self.m_nIsCurrent)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if not CheckButtonOpen(FUNC_CHAT_SEND) then 
    	return 
    end
    if judgeWetherForbid() then return end 
    
    self.m_bIsUpdate = true
    local curServerName ,curServerId = IPDhttpServer:getCurServerName()
    curServerId = tonumber(curServerId)
   
	local edtInputCur,edtPriInput,edtWorld,conCur,conPri,conWorld = self:_getAllEidtBox()
	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo == nil then return end
	local nSex = playerInfo.sex--玩家性别
	local head,face = self:getPlayerHeadAndFace()
	local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
	local headEffectId = CacheCenter:getPlayerHeadEffectItemId()
    local gameParam = CacheCenter:getGameParam()

    local showTitle = ""
    if playerInfo.title and playerInfo.title ~= "" then
	    local bShowTitle = WhetherShowDesignation(playerInfo.title)
	    if bShowTitle then
	    	showTitle = playerInfo.title
	    end
	end

	if self.m_nIsCurrent == CHANNEL_WHISPER then --私聊图片类型tag
		if tonumber(gameParam.WhisperOpenChatLevel) > playerInfo.level then
			MsgBoxManager:showTipBox(string.format(LocalStrings.WHISPER_CHAT_OPEN_LEVLE,gameParam.WhisperOpenChatLevel))
		    return
		end
		local conPri = GetElement(self.m_root,"conPri_WndChat",WZUIContainer)
		local txtFriendName = GetElement(conPri,"txtFriendName_WndChat",WZUILabelTTF)
		local player_pri = txtFriendName:getText()
		local content_pri = edtPriInput:getText()
		--content_pri = filterBadChar(content_pri)
		if content_pri==nil or content_pri=="" then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT) --请输入聊天内容！
			return
		end
		if not self:bSend(content_pri,self.m_nIsCurrent) then
		    edtPriInput:setText("")
		    return
		end
		if player_pri==nil or player_pri=="" or player_pri==LocalStrings.CHAT_MSG_ID then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_ID)--好友id请输入数字！
		elseif checkBlankSpace(content_pri) then --存在空格就不能发送
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
		else
			WZLog("聊天系统私聊信息发送内容：=",self.m_nReciveId)
			if self.m_nPrivateTimes > 0 then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
				return
			end

			local tempTxt = self:getMaxSubString(content_pri,self.m_nIsCurrent,false,playerInfo.name)
		    local tempStr, bHaveMask = self:CheckYellow(tempTxt)
			if HaveLimitFace(tempStr) then 
				return 
			end
		    -- if bHaveMask then 
		    -- 	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
		    -- 	return 
		    -- end
			
		    tempTxt = self:_addSpaceStr(tempStr)
			self.m_nPrivateTimes = self.m_nPrivateTimes + 2
			tempTxt = self:CheckYellow(tempTxt)
			--保存私聊的陌生人Id
			saveChatStrangerId(self.m_nReciveId, tempTxt)
			ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_WHISPER,0,tempTxt,self.m_nReciveId,self.m_nCurBubbleId)
			edtPriInput:setText("")
			local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
        	if _sendTime ~= nil then
        	--	tempTxt = self:CheckYellow(tempTxt)
        		WZLog("FFFFFFFFFFFFFFFFFFFFFFFFF", tempTxt)
            	self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, self.m_nReciveId, player_pri, tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId, self.m_nReceivePlayerHeadEffectId)
            	self:_resetEditInputMsg(true) --重置输入框里的内容
        	else
            	assert(_sendTime==nil,"_sendTime is nil")
        	end 
		end
	elseif  self.m_nIsCurrent == CHANNEL_COLORCHAT  then
		--判断vip等级
    	local vipLimit = gameParam.chatChannelColorVipLimit or 0
    	if CacheCenter:getPlayerInfo().vipLevel < vipLimit then
    		local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, vipLimit)
    	    MsgBoxManager:showConfirmCancelBox(sMsg, WndIntensifyStrengthen, WndIntensifyStrengthen.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
			return
		end
		if tonumber(gameParam.WorldOpenChatLevel) > playerInfo.level then
		    MsgBoxManager:showTipBox(string.format(LocalStrings.COLOR_CHAT_OPEN_LEVEL,gameParam.WorldOpenChatLevel))
	        return
		end
	    local content = edtWorld:getText()
	    --content = filterBadChar(content)
	    if content==nil or content=="" then
		   MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
		   return
	    end
	    if not self:bSend(content,self.m_nIsCurrent) then
		    edtWorld:setText("")
		    return
		end
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(115) 
		if nColorLabaNum<1 then
			MsgBoxManager:showConfirmBox(LocalStrings.CHAT_NOCOLORLABA,self,self.clickColorSureBack)
		elseif checkBlankSpace(content) then --存在空格就不能发送
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
		else
			if self.m_nTimes > 0 then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
	            local tempStr, bHaveMask = self:CheckYellow(tempTxt)
			    if HaveLimitFace(tempStr) then 
					return 
				end
			    -- if bHaveMask then 
			    -- 	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
			    -- 	return 
			    -- end

	            tempTxt = self:_addSpaceStr(tempStr)
				self.m_nTimes = self.m_nTimes + 5
				--越南要求10秒后才能发言,所以再加5秒
				if ProjConfig.LANGUAGE == "vn" then
					self.m_nTimes = self.m_nTimes + 5
				end
				WZLog("聊天系统彩聊信息发送内容：",tempTxt)
				tempTxt = self:CheckYellow(tempTxt)
				ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_COLORCHAT,0,tempTxt, 0,self.m_nCurBubbleId)
				edtWorld:setText("")
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
    			if _sendTime ~= nil then
    	 		--	tempTxt = self:CheckYellow(tempTxt)
    	 			WndSuona:showSuonaWithSendNameAndMessage(self.m_nIsCurrent,playerInfo.name,tempTxt,0,2,playerInfo.vipLevel)
     				self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime, playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
     				self:_resetEditInputMsg() --重置输入框里的内容
    			else
        			assert(_sendTime==nil,"_sendTime is nil")
    			end
			end
		end
	elseif self.m_nIsCurrent==CHANNEL_WORLD then --世界图片类型tag
		if tonumber(gameParam.WorldOpenChatLevel) > playerInfo.level then
		    MsgBoxManager:showTipBox(string.format(LocalStrings.PLAYER_LEVEL_UNREACHED,gameParam.WorldOpenChatLevel))
	        return
		end
		local content = edtWorld:getText()
		--content = filterBadChar(content)
		if content==nil or content=="" then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
		else
			if not self:bSend(content,self.m_nIsCurrent) then
		        edtWorld:setText("")
		        return
		    end
		    local labaId = 114
		    local nTempChatType = nil 
			local nLabaNum = CacheCenter:getPlayerItemCountById(labaId) 
			
			if nLabaNum < 1 then
				MsgBoxManager:showConfirmBox(LocalStrings.CHAT_NOLABA,self,self.clickSureBack) --世界喇叭不足，请先购买该道具！
			elseif checkBlankSpace(content) then --存在空格就不能发送
				MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
			else
				if self.m_nTimes > 0 then
					MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
				else
					local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
					WZLog("World = ",tempTxt)
					local tempStr, bHaveMask = self:CheckYellow(tempTxt)
					if HaveLimitFace(tempStr) then 
						return 
					end

					tempTxt = self:_addSpaceStr(tempStr)
					self.m_nTimes = self.m_nTimes + 5
					--越南要求10秒后才能发言,所以再加5秒
					if ProjConfig.LANGUAGE == "vn" then
						self.m_nTimes = self.m_nTimes + 5
					end
					tempTxt = self:CheckYellow(tempTxt)
					ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_WORLD,0,tempTxt, 0,self.m_nCurBubbleId)
					edtWorld:setText("")
					local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	                if _sendTime ~= nil then
	                    WndSuona:showSuonaWithSendNameAndMessage(self.m_nIsCurrent,playerInfo.name,tempTxt, 4,2,playerInfo.vipLevel)
	                    self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nTempChatType, headEffectId)
	                    self:_resetEditInputMsg()
	                else
	                    assert(_sendTime==nil,"_sendTime is nil")
	                end
				end
			end
		end
	elseif self.m_nIsCurrent==CHANNEL_CURRENT then --当前图片类型tag
		sendChannel = CHANNEL_CURRENT
		local packageName = WGameCmUtil:GetBundleIdentifier()
		if SceneCity.m_root ~= nil then
			if packageName ~= "com.bombman.omgEU" and packageName ~= "com.bombman.omg" and 
				packageName ~= "com.bombmaster.mg" and packageName ~= "com.sao.ios.bmmj" and 
				packageName ~= "com.sfrz.ddd" and packageName ~= "com.ddd.haiwai" and 
				packageName ~= "com.overseas.dan" then
				if playerInfo.level < 12 then
					MsgBoxManager:showTipBox(LocalStrings.CITY_SCENE_NOT_SUPPORT_CHAT)
					return
				end
			end
		end
		local content = edtInputCur:getText()
		
		if content==nil or content=="" then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
		else
			if not self:bSend(content,self.m_nIsCurrent) then
		        edtInputCur:setText("")
		        return
		    end

			if self.m_nTimes > 0 then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
			elseif checkBlankSpace(content) then --存在空格就不能发送
				MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
				local tempStr, bHaveMask = self:CheckYellow(tempTxt)
				if HaveLimitFace(tempStr) then 
					return 
				end
			    -- if bHaveMask then 
			    -- 	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
			    -- 	return 
			    -- end

			    tempTxt = self:_addSpaceStr(tempStr)
				if self.m_nCurSecond > 0 then
					local nCurSecond = os.time()
					local temp = nCurSecond - self.m_nCurSecond
					if temp <= 1800 then
						MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
						return
					else
						self.m_nCurSecond = 0
					end
				end

				table.insert(self.m_tCacheMsg,tempTxt)
				local advert = self:bAdvert()
				if advert then
					self.m_tCacheMsg = {}
					MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
					return
				end
				
				self.m_nTimes = self.m_nTimes + 5
				WZLog("聊天系统当前信息发送内容：",tempTxt)
				tempTxt = self:CheckYellow(tempTxt)
				ProtocolProcessorGlobal:send_CHAT_SendMessage(self.m_nIsCurrent,0,tempTxt, 0,self.m_nCurBubbleId)
				edtInputCur:setText("")
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	        	if _sendTime ~= nil then
	            --	tempTxt = self:CheckYellow(tempTxt)
	            	self:showChatBubble(self.m_nIsCurrent,playerInfo.id,tempTxt,self.m_nCurBubbleId)
	            	self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	            	self:_resetEditInputMsg()
	        	else
	            	assert(_sendTime==nil,"_sendTime is nil")
	        	end
			end              
		end
	elseif self.m_nIsCurrent==CHANNEL_GUILD then --公会图片类型tag
		local content = edtInputCur:getText()
		--content = filterBadChar(content)
		if content==nil or content=="" then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
		else
			if not self:bSend(content,self.m_nIsCurrent) then
		        edtInputCur:setText("")
		        return
		    end
			if checkInCommunity() ==false then
				MsgBoxManager:showTipBox(LocalStrings.TXT_NOSOCISY_FREND)
				return 
			end
			if self.m_nTimes > 0  then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
			elseif checkBlankSpace(content) then --存在空格就不能发送
				MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
				local tempStr, bHaveMask = self:CheckYellow(tempTxt)
				if HaveLimitFace(tempStr) then 
					return 
				end
			    -- if bHaveMask then 
			    -- 	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
			    -- 	return 
			    -- end

			    tempTxt = self:_addSpaceStr(tempStr)
				self.m_nTimes = self.m_nTimes + 5
				WZLog("聊天系统公会信息发送内容：",tempTxt,CacheCenter:getPlayerInfo().guildId )
				tempTxt = self:CheckYellow(tempTxt)
				ProtocolProcessorGlobal:send_CHAT_SendMessage(self.m_nIsCurrent,0,tempTxt, 0,self.m_nCurBubbleId)
				edtInputCur:setText("")

            	local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
            	if _sendTime ~= nil then
                --    tempTxt = self:CheckYellow(tempTxt)
                    self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
                    self:_resetEditInputMsg()
            	else
                	assert(_sendTime==nil,"_sendTime is nil")
            	end

			end
		end
	elseif self.m_nIsCurrent == CHANNEL_TEAM then
		if SceneBattle.m_root == nil and SceneRoom.m_root == nil and SceneBossRoom.m_root == nil and SceneGuildWarRoom.m_root == nil then
			MsgBoxManager:showTipBox(LocalStrings.NO_INBATTLE_TIP)
			return 
		end
		local content = edtInputCur:getText()
		--content = filterBadChar(content)
		if content==nil or content=="" then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
		else
			if not self:bSend(content,self.m_nIsCurrent) then
		        edtInputCur:setText("")
		        return
		    end
			if self.m_nTimes > 0 then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
			elseif checkBlankSpace(content) then --存在空格就不能发送
				MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
				local tempStr, bHaveMask = self:CheckYellow(tempTxt)
				if HaveLimitFace(tempStr) then 
					return 
				end
			    -- if bHaveMask then 
			    -- 	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
			    -- 	return 
			    -- end
			    
			    tempTxt = self:_addSpaceStr(tempStr)
				self.m_nTimes = self.m_nTimes + 5
				WZLog("聊天系统当前信息发送内容：",tempTxt)
				tempTxt = self:CheckYellow(tempTxt)
				ProtocolProcessorGlobal:send_CHAT_SendMessage(self.m_nIsCurrent,0,tempTxt, 0,self.m_nCurBubbleId)
				edtInputCur:setText("")
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	        	if _sendTime ~= nil then
	            --	tempTxt = self:CheckYellow(tempTxt)
	            	self:showChatBubble(self.m_nIsCurrent,playerInfo.id,tempTxt,self.m_nCurBubbleId)
	            	self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	            	self:_resetEditInputMsg()
	        	else
	            	assert(_sendTime==nil,"_sendTime is nil")
	        	end
			end              
		end
	elseif self.m_nIsCurrent==CHANNEL_GOLD then --世界金喇叭
		if tonumber(gameParam.goldChatVipLevel) > playerInfo.vipLevel then 
		    MsgBoxManager:showTipBox(string.format(LocalStrings.GOPHERBALL_TEXT1[23],gameParam.goldChatVipLevel))
		    return 
		end
		
		local content = edtWorld:getText()
		if content==nil or content=="" then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
		else
			if not self:bSend(content,self.m_nIsCurrent) then
		        edtWorld:setText("")
		        return
		    end
		    local labaId = 161057
			local nLabaNum = CacheCenter:getPlayerItemCountById(labaId) 
			
			if nLabaNum < 1 then
				WndFastGetItems:show(labaId, 1)
			else
				if self.m_nTimes > 0 then
					MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
				elseif checkBlankSpace(content) then --存在空格就不能发送
					MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
				else
					local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
					WZLog("Gold = ",tempTxt)
					local tempStr, bHaveMask = self:CheckYellow(tempTxt)
					if HaveLimitFace(tempStr) then 
						return 
					end

					tempTxt = self:_addSpaceStr(tempStr)
					self.m_nTimes = self.m_nTimes + 5
					ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_GOLD, 0, tempTxt, 0, self.m_nCurBubbleId)
					edtWorld:setText("")
					local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	                if _sendTime ~= nil then
	                    WndSuona:showSuonaWithSendNameAndMessage(self.m_nIsCurrent,playerInfo.name,tempTxt, 4, 2,playerInfo.vipLevel)
	                    self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	                    self:_resetEditInputMsg()
	                else
	                    assert(_sendTime==nil,"_sendTime is nil")
	                end
				end
			end
		end
	elseif self.m_nIsCurrent==CHANNEL_UNION then --联盟聊天类型tag
		local content = edtInputCur:getText()
		if content==nil or content=="" then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
		else
			if not self:bSend(content,self.m_nIsCurrent) then
		        edtInputCur:setText("")
		        return
		    end
			if checkInUnion() ==false then
				MsgBoxManager:showTipBox(LocalStrings.UNION_TEXT1[49])
				return 
			end
			if self.m_nTimes > 0  then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
			elseif checkBlankSpace(content) then --存在空格就不能发送
				MsgBoxManager:showTipBox(LocalStrings.KID_TEXT147)
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
				local tempStr, bHaveMask = self:CheckYellow(tempTxt)
				if HaveLimitFace(tempStr) then 
					return 
				end

			    tempTxt = self:_addSpaceStr(tempStr)
				self.m_nTimes = self.m_nTimes + 5
				WZLog("聊天系统联盟信息发送内容：",tempTxt )
				ProtocolProcessorGlobal:send_CHAT_SendMessage(self.m_nIsCurrent,0,tempTxt, 0,self.m_nCurBubbleId)
				edtInputCur:setText("")

            	local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
            	if _sendTime ~= nil then
                --    tempTxt = self:CheckYellow(tempTxt)
                    self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
                    self:_resetEditInputMsg()
            	else
                	assert(_sendTime==nil,"_sendTime is nil")
            	end

			end
		end
	end
end

--发的是否为广告(控制在当前频道的聊天数据，连续发送6条相同数据后就屏蔽玩家发言)
function WndChat:bAdvert()
	WZLog("WndChat:bAdvert")
	local tempCount = 0
	local count = #self.m_tCacheMsg
	if count >30 then
		table.remove(self.m_tCacheMsg,1)
	end
	for i,v in ipairs(self.m_tCacheMsg) do
		local tempMsg = v
		if i < count then
			if tempMsg == self.m_tCacheMsg[i+1] then
				tempCount = tempCount + 1
			else
				tempCount = 0
			end
		end
	end
	if tempCount >= 6 then
		self.m_nCurSecond = os.time()
		return true
	end
	return false
end

--local indexxxx = 0
function WndChat:_scheduleSetTime(element,delta)
	if self.m_nTimes~=nil and self.m_nTimes> 0  then
		self.m_nTimes = self.m_nTimes - 1
	end

	if self.m_nPrivateTimes~=nil and self.m_nPrivateTimes> 0  then
		self.m_nPrivateTimes =  self.m_nPrivateTimes - 1
	end
	if self.m_bRecording then
		self.m_nRecordLength = self.m_nRecordLength + 1
		if self.m_nRecordLength >= self.m_nRecordMaxLength then  --录音大于60秒取消录音
			self:sendRecordChat()
			return
		end
		if self.m_nRecordLength >=50 then
			GetElement(self.m_root,"txtRecordLength_WndChat",WZUILabelTTF):setText(60 - self.m_nRecordLength)
		end
		return
	end
end

--@brief	延迟动画
--@param	element:当前节点控件
--@param	duration:播放动画总时间
--@param	fun:回调函数
function WndChat:DelayAnimation(element,duration,fun)
	element:stopAllActions()
    	local actionXml = [[ <Action Type="WZUIActionDelayTime"  Duration="%f"  FinishLuaFunction="%s"/>]]
    	actionXml = string.format(actionXml,duration,fun)
    	local action = WZUISystem:getInstance():createUIActionFromXmlText(actionXml)
    	if action and element then
		element:runUIAction(action)
	end
end

function WndChat:_DelayOk()
	self.m_nTimes = 0
end

--@brief   选择彩聊或是世界普通聊天
function WndChat:onclickType(element)
	WZLog("WndChat:onclickType ",self.m_nIsCurrent)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if  GlobalMethod:crossServiceOpen() == 0 then
		MsgBoxManager:showTipBox(LocalStrings.CROSS_SERVICE_TIP)
		return
	end
	local edtInputWorld =WZUIEditBox:luaTo(self.m_root:getChildElement("edtInputWorld_WndChat"))
	local strText = edtInputWorld:getText()
    edtInputWorld:setText("")
	edtInputWorld:setText(strText)

	local txtWorldItemsCount= WZUILabelTTF:luaTo(self.m_root:getChildElement("txtChatPropsCount_WndChat"))
	if  self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT or self.m_nIsCurrent == CHANNEL_GOLD then
		if self.m_nIsCurrent == CHANNEL_WORLD then
            self.m_nIsCurrent = CHANNEL_COLORCHAT
            self:_setChatType(CHANNEL_COLORCHAT)
        elseif self.m_nIsCurrent == CHANNEL_GOLD then 
            self.m_nIsCurrent = CHANNEL_WORLD
        	self:_setChatType(CHANNEL_WORLD)
        elseif self.m_nIsCurrent == CHANNEL_COLORCHAT then
            self.m_nIsCurrent = CHANNEL_GOLD
            self:_setChatType(CHANNEL_GOLD)
		end
	end
end

--@brief   彩聊
function WndChat:onClickVariety(element)
	WZLog("WndChat:onClickVariety")
	self:_setChatType(CHANNEL_COLORCHAT)
	local txt = self.m_root:getChildElement("txtCurChannelType_WndChat")
    txt = WZUILabelTTF:luaTo(txt)
    txt:setText(LocalStrings.CHAT_COLORLIAO)
end

--@brief   世界普通聊天
function WndChat:onClickWorldNor(element)
	WZLog("WndChat:onClickWorldNor")
	self:_setChatType(CHANNEL_WORLD)
	local txt = self.m_root:getChildElement("txtCurChannelType_WndChat")
    txt = WZUILabelTTF:luaTo(txt)
    txt:setText(LocalStrings.CHAT_WORLD)
end

--@brief  根据id显示不同的frame
function WndChat:setShowFrameelement(tag)
	WZLog("WndChat:setShowFrameelement ",tag)
	local frameelement = self.m_root:getChildElement("frameelement_WndChat")
	frameelement = WZUIFrameElement:luaTo(frameelement)
	frameelement:ShowFrameElement(tag)
end


--@brief	切换聊天类型（上方）
--@param	element:checkbox
function WndChat:onclickTopSelect(element)
	WZLog("WndChat:onclickTopSelect")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	element = WZUICheckBox:luaTo(element)
    local tag = element:getTag()
    self:setShowFrameelement(tag)
    if tag == 0 then
    	tag = CHANNEL_CURRENT
    elseif tag == 1  then
		local imgType = self.m_root:getChildElement("imgWorldType_WndChat")
        imgType = WZUIImage:luaTo(imgType)
        imgType:setFile("ui/chat/chat_common_icon_laba3.png")
        local txtChatPropsCount = GetElement(self.m_root,"txtChatPropsCount_WndChat",WZUILabelTTF)
        local nColorLabaNum = CacheCenter:getPlayerItemCountById(114) 
        txtChatPropsCount:setText("x"..nColorLabaNum)
    	tag = CHANNEL_WORLD
    elseif tag == 2 then
    	tag = CHANNEL_GUILD
    	if g_OpenOfflineMessage then
    		for i = 1,#g_OfflineMessage do 
    			if g_OfflineMessage[i].channel == tag then 
	    			self:_pushWords(
	    			 g_OfflineMessage[i].channel, g_OfflineMessage[i].sendId, g_OfflineMessage[i].sendName, g_OfflineMessage[i].receiveId, g_OfflineMessage[i].receiveName,
	    			 g_OfflineMessage[i].message, g_OfflineMessage[i].rrtime, g_OfflineMessage[i].vipLevel, g_OfflineMessage[i].sendHeadId, g_OfflineMessage[i].sendFaceId,
	    			 g_OfflineMessage[i].sendSex, g_OfflineMessage[i].headScul, g_OfflineMessage[i].serviceId, nil,nil,nil,nil, g_OfflineMessage[i].headColor, g_OfflineMessage[i].sendLevel,
	    			 g_OfflineMessage[i].rtime, g_OfflineMessage[i].bubbleId, g_OfflineMessage[i].playerTitle, g_OfflineMessage[i].playerPvpLevel, g_OfflineMessage[i].professionId,
	    			 g_OfflineMessage[i].openStatus, g_OfflineMessage[i].offlineMessage, nil, g_OfflineMessage[i].headEffectId)
	    		end
    		end
    		g_OpenOfflineMessage = false
    	end
    elseif tag == 3 then
    	tag = CHANNEL_WHISPER
    	-- if not self.initFirstAssint then
    	-- 	self.initFirstAssint = true
	    	self:onClickFastPriChatCallback(0)
	    -- end
    elseif tag == 4 then
    	tag = CHANNEL_TEAM
    elseif tag == 5 then
    	tag = CHANNEL_COPY
    elseif tag == 6 then 
    	tag = CHANNEL_UNION
    	if g_OpenUnionOfflineMessage then
    		for i = 1,#g_OfflineMessage do 
    			if g_OfflineMessage[i].channel == tag then 
	    			self:_pushWords(
	    			 g_OfflineMessage[i].channel, g_OfflineMessage[i].sendId, g_OfflineMessage[i].sendName, g_OfflineMessage[i].receiveId, g_OfflineMessage[i].receiveName,
	    			 g_OfflineMessage[i].message, g_OfflineMessage[i].rrtime, g_OfflineMessage[i].vipLevel, g_OfflineMessage[i].sendHeadId, g_OfflineMessage[i].sendFaceId,
	    			 g_OfflineMessage[i].sendSex, g_OfflineMessage[i].headScul, g_OfflineMessage[i].serviceId, nil,nil,nil,nil, g_OfflineMessage[i].headColor, g_OfflineMessage[i].sendLevel,
	    			 g_OfflineMessage[i].rtime, g_OfflineMessage[i].bubbleId, g_OfflineMessage[i].playerTitle, g_OfflineMessage[i].playerPvpLevel, g_OfflineMessage[i].professionId,
	    			 g_OfflineMessage[i].openStatus, g_OfflineMessage[i].offlineMessage, nil, g_OfflineMessage[i].headEffectId)
	    		end
    		end
    		g_OpenUnionOfflineMessage = false
    	end
    end

	if self.m_nIsCurrent==tag then
		return
	end

	if WndChat.m_oCurPlayRecordCell then
		self:stopPlayVoice()
	end
    self.m_nIsCurrent = tag
	
	local edtInputCur =WZUIEditBox:luaTo(self.m_root:getChildElement("edtInputCur_WndChat"))
	if edtInputCur ~= nil and edtInputCur:getText() ~= nil then
		 self.m_sText = edtInputCur:getText()
		 edtInputCur:setText("")
	end

	local edtPriInput = WZUIEditBox:luaTo(self.m_root:getChildElement("edtPriInput_WndChat"))
	if edtPriInput ~= nil and edtInputCur:getText() ~=nil then
		self.m_sText = edtInputCur:getText()
		edtPriInput:setText("")
	end

	if tag==CHANNEL_WHISPER then
		if self.m_sText ~= nil then
			edtPriInput:setText(self.m_sText)
		end
		GlobalGame.g_nPrivateNum = 0 --当点击上方私聊，未读私聊信息数目清零
		--当别的频道编辑框输入消息未发送且又切换到私聊频道时，未发送的消息做清空处理
		local img4 = GetElement(self.m_root,"img4_WndChat",WZUIImage)
		img4:setVisible(false)
	else
		if self.m_sText ~= nil then
			edtInputCur:setText(self.m_sText)
		end
	end

	if (self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT) and CacheCenter:getPlayerInfo().vipLevel < 2 then
		self.m_bRecordingChat = false
		self.m_bRecording = false
	end
	
	self:_setChatType(tag)
	self:freelistUpdate(tag)
end

--删除freelist所有cell
function WndChat:removeFreelistAllCell()
	WZLog("WndChat:removeFreelistAllCell")
	if WndChat.m_oCurPlayRecordCell then
		WGCloudVoiceNotify:StopPlayFile()
	end
	WndChat.m_oCurPlayRecordCell = nil
	
	self.m_elementTranslate = nil
	local freelistconWorld = self.m_root:getChildElement("freelistconWorld_WndChat")	
	if freelistconWorld ~=nil then
	    freelistconWorld = WZUIFreeListContainer:luaTo(freelistconWorld)
	    freelistconWorld:removeAll()
	end

	local freelistconPrivate = self.m_root:getChildElement("freelistconPrivate_WndChat")
	if freelistconPrivate ~=nil then
		freelistconPrivate = WZUIFreeListContainer:luaTo(freelistconPrivate)
	    freelistconPrivate:removeAll()
	end

	local freelistconGonghui = self.m_root:getChildElement("freelistconGonghui_WndChat")
	if freelistconGonghui ~=nil then
		freelistconGonghui = WZUIFreeListContainer:luaTo(freelistconGonghui)
	    freelistconGonghui:removeAll()
	end

	local freelistconCur = self.m_root:getChildElement("freelistconCur_WndChat")
	if freelistconCur ~=nil then
		freelistconCur = WZUIFreeListContainer:luaTo(freelistconCur)
	    freelistconCur:removeAll()
	end

	local freelistconTeam = self.m_root:getChildElement("freelistconTeam_WndChat")
	if freelistconTeam ~=nil then
		freelistconTeam = WZUIFreeListContainer:luaTo(freelistconTeam)
	    freelistconTeam:removeAll()
	end

	local freelistconCopy = self.m_root:getChildElement("freelistconCopy_WndChat")
	if freelistconCopy ~=nil then
		freelistconCopy = WZUIFreeListContainer:luaTo(freelistconCopy)
	    freelistconCopy:removeAll()
	end

	local reelistconGold = self.m_root:getChildElement("freelistconGold_WndChat")	
	if reelistconGold ~=nil then
	    reelistconGold = WZUIFreeListContainer:luaTo(reelistconGold)
	    reelistconGold:removeAll()
	end

	local freelistconUnion = self.m_root:getChildElement("freelistconUnion_WndChat")
	if freelistconUnion ~=nil then
		freelistconUnion = WZUIFreeListContainer:luaTo(freelistconUnion)
	    freelistconUnion:removeAll()
	end
end

--@brief  根据频道刷新freelist
--@param  channel:频道信息
function WndChat:freelistUpdate(channel)
	WZLog("WndChat:freelistUpdate")
	if channel == CHANNEL_WORLD or channel == CHANNEL_SYSTEM or channel == CHANNEL_COLORCHAT or channel == CHANNEL_GOLD then
		--世界
		local freelistconWorld = self.m_root:getChildElement("freelistconWorld_WndChat")	
		if freelistconWorld ~=nil then
		    freelistconWorld = WZUIFreeListContainer:luaTo(freelistconWorld)
		    freelistconWorld:update()
		end

		local freelistconSystem = self.m_root:getChildElement("freelistconSystem_WndChat")
		if freelistconSystem ~=nil then
			freelistconSystem = WZUIFreeListContainer:luaTo(freelistconSystem)
		    freelistconSystem:update()
		end

		local freelistconGold = self.m_root:getChildElement("freelistconGold_WndChat")	
		if freelistconGold ~=nil then
		    freelistconGold = WZUIFreeListContainer:luaTo(freelistconGold)
		    freelistconGold:update()
		end
	end
	
    if channel == CHANNEL_WHISPER then
    	--私聊
		local freelistconPrivate = self.m_root:getChildElement("freelistconPrivate_WndChat")
		if freelistconPrivate ~=nil then
			freelistconPrivate = WZUIFreeListContainer:luaTo(freelistconPrivate)
		    freelistconPrivate:update()
		end
    end
    
	if channel== CHANNEL_GUILD then
		--公会
		local freelistconGonghui = self.m_root:getChildElement("freelistconGonghui_WndChat")
		if freelistconGonghui ~=nil then
			freelistconGonghui = WZUIFreeListContainer:luaTo(freelistconGonghui)
		    freelistconGonghui:update()
		end
	end
	
	if channel ==CHANNEL_CURRENT then
		local freelistconCur = self.m_root:getChildElement("freelistconCur_WndChat")
		if freelistconCur ~=nil then
			freelistconCur = WZUIFreeListContainer:luaTo(freelistconCur)
		    freelistconCur:update()
		end
	end
    
    if channel == CHANNEL_TEAM then
    	local freelistconTeam = self.m_root:getChildElement("freelistconTeam_WndChat")
		if freelistconTeam ~=nil then
			freelistconTeam = WZUIFreeListContainer:luaTo(freelistconTeam)
		    freelistconTeam:update()
		end
    end

    if channel == CHANNEL_COPY then
    	local freelistconCopy = self.m_root:getChildElement("freelistconCopy_WndChat")
		if freelistconCopy ~=nil then
			freelistconCopy = WZUIFreeListContainer:luaTo(freelistconCopy)
		    freelistconCopy:update()
		end
    end

    if channel == CHANNEL_UNION then
	    local freelistconUnion = self.m_root:getChildElement("freelistconUnion_WndChat")
		if freelistconUnion ~=nil then
			freelistconUnion = WZUIFreeListContainer:luaTo(freelistconUnion)
		    freelistconUnion:update()
		end
	end
end

--打开快速回复窗口
function WndChat:onClickOpenFastChat(element)
	WZLog("WndChat:onClickOpenFastChat")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTab = 1
	if self.m_nIsCurrent == CHANNEL_TEAM then 
		nTab = 2 
	end
	WndQuickChatList:showInterface(2, nTab)
end

--快速发送聊天信息
function WndChat:onClickFastSend(element)
	WZLog("WndChat:onClickFastSend")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent = element:getParent()
	local tag = parent:getTag()
	local curServerName ,curServerId = IPDhttpServer:getCurServerName()
    curServerId = tonumber(curServerId)

	local playerInfo = CacheCenter:getPlayerInfo()

	local nSex = playerInfo.sex--玩家性别
    
	local head,face = self:getPlayerHeadAndFace()
	local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()

    local key = "FAST_CHAT_" .. (tag + 1)
    local str = LocalStrings[key]
	local content = str

	content = self:_addSpaceStr(content)
	if self.m_nTimes > 0 then
		MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
	else
		self.m_nTimes = self.m_nTimes + 5
		-- tempTxt = self:CheckYellow(tempTxt)
		ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_TEAM,0,content, 0,self.m_nCurBubbleId)
		local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
    	if _sendTime ~= nil then
        	self:showChatBubble(CHANNEL_TEAM,playerInfo.id,content,self.m_nCurBubbleId)
        	self:_pushWords(CHANNEL_TEAM,playerInfo.id,playerInfo.name, 0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor)
    	else
        	assert(_sendTime==nil,"_sendTime is nil")
    	end
	end
end

--弹出聊天气泡
function WndChat:onClickBubble(element)
	-- body
	WZLog("WndChat:onClickBubble")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local conBubbleBox = GetElement(self.m_root,"conBubbleBox_WndChat",WZUIContainer)
	conBubbleBox:setVisible(true)

	self:_setBubbleCell()
end

--选中某个聊天气泡
function WndChat:onClickBubbleCell(element)
	-- body
	local parent = WZUIContainer:luaTo(element:getParent())
	local tag = parent:getTag()
	WZLog("WndChat:onClickBubbleCell =",tag,self.m_nCurBubbleId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local indexx = self:_getIndexByBubbleId(self.m_nCurBubbleId)

	self:showItemInfo(parent,tag+1)
	
	if tag+1 == indexx then return end
	
	if not self:handleClickBubble(parent,tag+1) then return end

	local conchatcontext = GetElement(self.m_root,"conchatcontext_wndchant",WZUIContainer)
	local conBubbleBox = GetElement(conchatcontext,"conBubbleBox_WndChat",WZUIContainer)
	local tableBubbleList = GetElement(conBubbleBox,"tableBubbleList_WndChat",WZUITableContainer)
	local curCellElement = tableBubbleList:getCellElement(indexx-1)
	if curCellElement then
		curCellElement = WZUIContainer:luaTo(curCellElement)
		GetElement(curCellElement,"imgSel_CellBubble",WZUIImage):setVisible(false)
	end
	GetElement(parent,"imgSel_CellBubble",WZUIImage):setVisible(true)

	self:savePlayerSelBubble(tag+1)

	-- self:onClickCloseBubble()
end

--显示物品信息
function WndChat:showItemInfo(element,nTag)
	local conBubbleBox = GetElement(self.m_root,"conBubbleBox_WndChat",WZUIContainer)
	local bubbleList = self:_getBubbleList()
	local bubbleInfo = bubbleList[nTag]
	if bubbleInfo.id > 0 then
		local nNum = CacheCenter:getPlayerItemCountById(bubbleInfo.id)
		if bubbleInfo.property[1][1] > 0 and nNum <= 0 then
			local tData = CopyTable(bubbleInfo)
			tData.tBtnList = {LocalStrings.CANCEL, LocalStrings.BUY}
			WndItemInfo:showInfo(conBubbleBox, self.m_root, 1, tData, true, GlobalMethod:ccp(360,150), true)
			WndItemInfo:setClickButtonCallback(self, self.buyBubble)
		else
			local tData = CopyTable(bubbleInfo)
			WndItemInfo:showInfo(conBubbleBox, self.m_root, 1, tData, false, GlobalMethod:ccp(360,150))
		end
	end
end

function WndChat:handleClickBubble(element,nTag)
	-- body
	WZLog("WndChat:handleClickBubble =",nTag)

	local bubbleList = self:_getBubbleList()
	local bubbleInfo = bubbleList[nTag]
	local playerInfo = CacheCenter:getPlayerInfo()
	if bubbleInfo.id > 0 and bubbleInfo.property[1][1] == -1 and playerInfo.vipLevel < bubbleInfo.property[1][2] then --VIP激活
		local tipss = string.format(LocalStrings.BUBBLE_OPEN_BY_VIP, bubbleInfo.property[1][2])
		MsgBoxManager:showConfirmCancelBox(tipss,self,self._EventToVIP)
		return false
	elseif bubbleInfo.id > 0 and bubbleInfo.property[1][1] == 0 then --通过福利卡使用
		if not whetherHaveWelfareCard() then 
			MsgBoxManager:showConfirmCancelBox(LocalStrings.BACKGROUND_VIP_TEXT5, self, self._EventToVIP)
			return false
		end
	elseif bubbleInfo.id > 0 and bubbleInfo.property[1][1] > 0 then --需要购买的气泡
		local nNum = CacheCenter:getPlayerItemCountById(bubbleInfo.id) 
		if nNum <= 0 then
			return false
		end
	elseif bubbleInfo.id > 0 and bubbleInfo.property[1][1] == -2 then --活动专属 活动获得
		local nNum = CacheCenter:getPlayerItemCountById(bubbleInfo.id)
		if nNum <= 0 then
			return false
		end
	end

	return true
end

--保存玩家选择的聊天气泡(玩家会进行换号登陆要保存多个玩家设置的气泡信息)
function WndChat:savePlayerSelBubble(index)
	-- body
	WZLog("WndChat:savePlayerSelBubble ",index)
	if index ~= nil then
		local tempT = {}
		local playerInfo = CacheCenter:getPlayerInfo()
		local indexx = nil
		for i,v in ipairs(self.m_tBubbleSettingByPlayer) do
			if playerInfo.id == tonumber(v[2]) then
				indexx = i
			end
		end
		if indexx ~= nil then
			table.remove(self.m_tBubbleSettingByPlayer,indexx)
		end
		local bubbleId = self.m_tBubbleList[index].id
		local tempT = {}
		table.insert(tempT,bubbleId)
		table.insert(tempT,playerInfo.id)

		table.insert(self.m_tBubbleSettingByPlayer,tempT)

		local tempBubbleInfo ={}
		for i,v in ipairs(self.m_tBubbleSettingByPlayer) do
			table.insert(tempBubbleInfo,v[1])
			table.insert(tempBubbleInfo,",")
			table.insert(tempBubbleInfo,v[2])
			table.insert(tempBubbleInfo,",")
		end
		
		self.m_nCurBubbleId = self.m_tBubbleList[index].id

		local strTag = table.concat(tempBubbleInfo)
		WZFileUtil:writeStringToFile("bubble_chat.txt",strTag,false)
	end
end

--获取玩家使用的聊天气泡ID
function WndChat:getPlayerBubble()
	-- body
	local strTemp = WZFileUtil:getStringFromFile("bubble_chat.txt",false)
	WZLog("WndChat:getPlayerBubble ",strTemp)
	local temp = 0
	if strTemp ~= "" then
		local tempT = SplitStringWithSeparator(strTemp,",")
		self.m_tBubbleSettingByPlayer = {}
		local tempTT = {}
		for i,v in ipairs(tempT) do
			table.insert(tempTT,v)
			if  i % 2 == 0 and i > 0 and #tempTT >= 2 then
				table.insert(self.m_tBubbleSettingByPlayer,tempTT)
				tempTT = {}
			end
		end
		
		local playerInfo = CacheCenter:getPlayerInfo()
		for i,v in ipairs(self.m_tBubbleSettingByPlayer) do
			if tonumber(v[2]) == playerInfo.id then
				temp = tonumber(v[1])
			end
		end
	end
	return temp
end

--@brief    前往vip充值
function WndChat:_EventToVIP( nId, nResType )
    WZLog("WndChat:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
    	if WndBattleHud.m_root ~= nil then 
    		MsgBoxManager:showTipBox(LocalStrings.CHAT_CANTBUY)
    		return 
    	end
        WndVip:showWndUI(0)
    end
end

--点击打开屏蔽陌生人按钮
function WndChat:onClickBlockStrangerBox(element)
	WZLog("WndChat:onClickBlockStranger")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:setBlockStrangerVisible(true)

	self:_setBlockStrangerBox()
end

--点击屏蔽陌生人选择框
function WndChat:onClickBlockStrangerCheck(element)
	WZLog("WndChat:onClickBlockStrangerCheck")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nBtnCount = 2
	local tag = element:getTag()
	local checkBlockStranger = GetElement(self.m_root, "checkBlockStranger"..tag.."_WndChat", WZUICheckBox)
	local nIndex = checkBlockStranger:getCheckIndex()
	checkBlockStranger:setCheckIndex(1-nIndex) --这里先不改变状态,等协议返回成功再改
	local chatShield = CacheCenter:getPlayerInfo().chatShield
	local tBits = self:_NumberToBits(chatShield, nBtnCount)
	tBits[tag] = nIndex
	chatShield = BitsToNumber(tBits)
	ProtocolProcessorGlobal:send_CHAT_ChatShield(chatShield)
end

---------------------------------关于方法回调----------------------------------------------
--@brief	设置私聊接口回调(好友系统中)
--@param	playerName:玩家name
function WndChat:callbackAddPrivate(playerName)
	WZLog("WndChat:callbackAddPrivate= ",playerName)

	self:_setChoseFriendListBtnText(playerName)

	local frameelement = self.m_root:getChildElement("frameelement_WndChat")
	if frameelement == nil then
	   return
	end
	frameelement = WZUIFrameElement:luaTo(frameelement)
	frameelement:ShowFrameElement(3)

	local checkboxPri = self.m_root:getChildElement("checkboxPri_WndChat")
	if checkboxPri == nil then
		return
    end
	local checkboxGong = self.m_root:getChildElement("checkboxGong_WndChat")
	if checkboxGong == nil then
		return
    end
    local checkboxWorld = self.m_root:getChildElement("checkboxWorld_WndChat")
	if checkboxWorld == nil then
		return
    end

    local checkboxCur = self.m_root:getChildElement("checkboxCur_WndChat")
	if checkboxCur == nil then
		return
    end

    local checkboxTeam = self.m_root:getChildElement("checkboxTeam_WndChat")
	if checkboxTeam == nil then
		return
    end
    local checkboxUnion = self.m_root:getChildElement("checkboxUnion_WndChat")
	if checkboxUnion == nil then
		return
    end
	
	checkboxPri = WZUICheckBox:luaTo(checkboxPri)
	checkboxGong = WZUICheckBox:luaTo(checkboxGong)
	checkboxWorld = WZUICheckBox:luaTo(checkboxWorld)
	checkboxCur = WZUICheckBox:luaTo(checkboxCur)
	checkboxTeam = WZUICheckBox:luaTo(checkboxTeam)
	checkboxUnion = WZUICheckBox:luaTo(checkboxUnion)
	
	checkboxPri:setCheckIndex(1)
	checkboxGong:setCheckIndex(0)
	checkboxWorld:setCheckIndex(0)
	checkboxCur:setCheckIndex(0)
	checkboxTeam:setCheckIndex(0)
	checkboxUnion:setCheckIndex(0)
end

--@brief  点击弹出的确认购买时触发的函数
--@param  nType，按钮类型，关闭，取消，确定
--@param  nId，按钮id
function WndChat:clickColorSureBack(nId,nType)
	WZLog("WndChat:clickColorSureBack(nId,nType)",nId,nType)
    if nType == MSGBOXRESTYPE_CONFIRM then
		WndPurchase:showBuyInterface(6,115,nil,nil,nil,self.m_nOrder)
	end
end

--@brief 世界喇叭不足购买世界喇叭
function WndChat:clickSureBack(nId,nType)
	if nType == MSGBOXRESTYPE_CONFIRM then
		WndPurchase:showBuyInterface(6,114,nil,nil,nil,self.m_nOrder)
	end
end

--弹出表情框
function WndChat:onClickExpression(element)
	WZLog("WndChat:onClickExpression")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local conFaceBox = GetElement(self.m_root,"conFaceBox_WndChat",WZUIContainer)
	conFaceBox:setVisible(true)
	if self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_WHISPER then
		conFaceBox:setRelativePosition(GlobalMethod:ccp(0.248551,0.192758))
	else
		conFaceBox:setRelativePosition(GlobalMethod:ccp(0.156551,0.192758))
	end
	self:_createFaceBox()
end

--点击聊天表情回调
function WndChat:onSelFace(index)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local fackMask = self.FACEIMASK[index]
	local curEditBox = self:_getCurEditBox()
	if curEditBox then
		local curText = curEditBox:getText()
	    if fackMask then
			curText = curText .. fackMask
			if ChineseStringLen(curText) > 24 then
				--MsgBoxManager:showTipBox(LocalStrings.INPUT_MAX_CHAT)
				return
		    end
		    curEditBox:setText(curText)
	    end
	end
end

--编辑框待发送文字
function WndChat:setEditBoxText(s_text)
	local curEditBox = self:_getCurEditBox()
	if curEditBox then
	    curEditBox:setText(s_text)
	end
end

function WndChat:SetCheckBoxState(first,second,thrid,fourth,five)
	WZLog("WndChat:SetCheckBoxState(first,second,thrid,fourth")
	GetElement(self.m_root,"checkboxPri_WndChat",WZUICheckBox):setCheckIndex(first)
	GetElement(self.m_root,"checkboxGong_WndChat",WZUICheckBox):setCheckIndex(second)
	GetElement(self.m_root,"checkboxWorld_WndChat",WZUICheckBox):setCheckIndex(thrid)
	GetElement(self.m_root,"checkboxCur_WndChat",WZUICheckBox):setCheckIndex(fourth)
	GetElement(self.m_root,"checkboxTeam_WndChat",WZUICheckBox):setCheckIndex(five)
end

function WndChat:SetCheckBoxVisible()
	if not self.m_root then return end

	local nLevel = CacheCenter:getPlayerInfo().level 
	if nLevel < self.m_nWorldChannelOpenLevel then
		GetElement(self.m_root,"checkboxCur_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.1,0.549))
		GetElement(self.m_root,"checkboxTeam_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.275,0.549))
		GetElement(self.m_root,"checkboxWorld_WndChat",WZUICheckBox):setVisible(false)
		GetElement(self.m_root,"checkboxGong_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.45,0.549))
		GetElement(self.m_root,"checkboxUnion_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.625,0.549))
		GetElement(self.m_root,"checkboxPri_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.8,0.549))
		GetElement(self.m_root,"checkboxCopy_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.975,0.549))
		GetElement(self.m_root, "img4_WndChat", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.695,1.073))
	else
		GetElement(self.m_root,"checkboxCur_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.1,0.549))
		GetElement(self.m_root,"checkboxWorld_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.275,0.549))
		GetElement(self.m_root,"checkboxWorld_WndChat",WZUICheckBox):setVisible(true)
		GetElement(self.m_root,"checkboxTeam_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.45,0.549))
		GetElement(self.m_root,"checkboxGong_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.625,0.549))
		GetElement(self.m_root,"checkboxUnion_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.8,0.549))
		GetElement(self.m_root,"checkboxPri_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.975,0.549))
		GetElement(self.m_root, "img4_WndChat", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.834,1.07299))
		GetElement(self.m_root,"checkboxCopy_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(1.15,0.549))
	end
end


--切账号 置空所有聊天数据
function WndChat:chatrelease()
	WZLog("WndChat:chatrelease()")
	self.m_tAutoPlayerCurVoiceList = {}  
	self.m_tAutoPlayerGuildVoiceList = {}  
	if self.m_root == nil then
		return
	end
	GetElement(self.m_root,"freelistconPrivate_WndChat",WZUIFreeListContainer):removeAll()
	GetElement(self.m_root,"freelistconGonghui_WndChat",WZUIFreeListContainer):removeAll()
	GetElement(self.m_root,"freelistconWorld_WndChat",WZUIFreeListContainer):removeAll()
	GetElement(self.m_root,"freelistconCur_WndChat",WZUIFreeListContainer):removeAll()
	GetElement(self.m_root,"freelistconSystem_WndChat",WZUIFreeListContainer):removeAll()	
	GetElement(self.m_root,"freelistconCopy_WndChat",WZUIFreeListContainer):removeAll()	
	GetElement(self.m_root,"freelistconGold_WndChat",WZUIFreeListContainer):removeAll()
	GetElement(self.m_root,"freelistconUnion_WndChat",WZUIFreeListContainer):removeAll()
end

--设置除了透明背景外的容器 触摸 WindowManagement特殊处理
function WndChat:setConetextCon(bfalg)
	if not self.m_root then return end
	bfalg = bfalg or false
	GetElement(self.m_root,"conchatcontext_wndchant",WZUIContainer):setTouchEnable(bfalg)
end

-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
--@brief      开始创建聊天页面
--@param    _type 聊天频道类型
function WndChat:_createChatWindow(_type)
    WZLog("WndChat:_createChatWindow", _type)
	if self.m_root == nil then
		self.m_root = self:createElement()
		if self.m_root == nil then
			return
		end
		if _type ~= nil then
			WZLog("WndChat:_createChatWindow  222", _type)
			if _type == CHANNEL_WORLD and CacheCenter:getPlayerInfo().level < self.m_nWorldChannelOpenLevel then 
				_type = CHANNEL_CURRENT
			end
			self.m_nIsCurrent = _type
		end
		self.m_root:retain()--整个游戏运行过程中不要释放，因为聊天页面存在整个游戏过程中
		
		self.m_root = WZUIElementContainer:luaTo(self.m_root)
		if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" 
			or ProjConfig.LANGUAGE == "es" then
			local edtInputCur = GetElement(self.m_root,"edtInputCur_WndChat",WZUIEditBox)
			edtInputCur:setMaxLength(64)

			local edtInputWorld = GetElement(self.m_root,"edtInputWorld_WndChat",WZUIEditBox)
			edtInputWorld:setMaxLength(64)

			local edtPriInput = GetElement(self.m_root,"edtPriInput_WndChat",WZUIEditBox)
			edtPriInput:setMaxLength(64)
        end
		self:_initAllMsg()
		--下方的显示
		self.m_bSupportRecord = WGCloudVoiceNotify:IsSupportVoice()
		WZLog("self.m_bSupportRecord = ",self.m_bSupportRecord)
	    self:_setChatType(self.m_nIsCurrent)
	    self:selTextChange(self.m_nIsCurrent)
	    local indexx = self:_getCheckIndex(self.m_nIsCurrent)
		self:setShowFrameelement(indexx)
		local packName = WGameCmUtil:GetBundleIdentifier()
		if packName == "com.wyd.gplay.bombheroes" or packName == "com.wyd.appstore.bombheroes" or packName == "com.wyd.brgp.bombheroes" 
			or packName == "com.wyd.tcl.bombheroes" or packName == "com.wyd.samsung.bombheroes" or packName == "com.wyd.samsungbr.bombheroes"
			 or packName == "com.ios.rwt.bombcrash" or packName == "com.ios.jt.bombboombang" or packName == "com.letui.doombomb" 
			 or packName == "com.ios.jt.bombgala" or packName == "com.bombman.omg" or packName == "com.bombman.omgEU" 
			 or packName == "com.tutu.chibibomberios" or packName == "com.tutu.chibibomberandroid" or packName == "com.bombmaster.mg" 
			 or packName == "com.wyd.gplay.bombheroesen" or packName == "com.wyd.gplay.heroibomba" or packName == "com.ios.edo.bomb" 
			 or packName == "com.ios.rwt.bomberclash" or packName == "com.edo.ios.Ihabombom" or packName == "com.ios.jt.bombmonster" 
			 or packName == "com.ios.jt.bouncelegends" or packName == "com.ios.jt.bouncingchurch" or packName == "com.sfrz.ddd" 
			 or packName == "com.ddd.haiwai" or packName == "com.overseas.dan" 
			 or packName == "com.ios.jt.bouncelegends" or packName == "com.ios.jt.bouncingchurch" or packName == "com.ios.jt.bombcyclone" 
			 or packName == "com.sfrz.ddd" or packName == "com.ios.jt.shootertribe" or packName == "com.DDBom.b" or packName == "com.mh.jl" 
			 or packName == "com.ios.jt.secrettreasure" or packName == "dd.pd.cr" or packName == "com.ios.jt.projectilefiring" 
			  or packName == "com.ios.jt.mysteriousland" or packName == "com.ios.jt.galgun" then
			self.m_bSupportRecord = false
		end
	    self:_setChatType(_type)
		self:setShowFrameelement(1)
	end
    isHiden = true
end

--@brief	关闭界面
function WndChat:_hideChatWindows()
	WZLog("WndChat:_hideChatWindows")
	if self.m_root == nil then 
		return
	end

	if WndChat.m_oCurPlayRecordCell then
		GetElement(WndChat.m_oCurPlayRecordCell,"imgVoice_WndChat",WZUIImage):setVisible(true)
    	GetElement(WndChat.m_oCurPlayRecordCell,"armPlayRecord_WndChat",WZUISpine):setVisible(false)
    	WGCloudVoiceNotify:StopPlayFile()
	end
	WndChat.m_oCurPlayRecordCell = nil

	self.m_root:setVisible(false)
	self.m_nOrder = self.m_root:getZOrder()
	self.m_root:setZOrder(10000)
	
	self.isHiden = true
    --取消彩聊定时器
	local element = nil

	local conBottum = GetElement(self.m_root,"conBottum_WndChat",WZUIContainer)
	conBottum:disableSchedule()
	
	local edtInputCur,edtPriInput,edtWorld,conCur,conPri,conWorld = self:_getAllEidtBox()
	edtInputCur:setText("")
	edtPriInput:setText("")
	edtWorld:setText("")
	conCur:setVisible(false)
	conPri:setVisible(false)
	conWorld:setVisible(false)

	self:showGiveRedPackBtn(false)

	WndCurrentChat:wndCurChatVisible(true)
	self:_removeChatCell()
	--每次关闭聊天界面都需要清空当前频道自动播放列表
	self.m_tAutoPlayerCurVoiceList = {}  
	--关闭举报窗口
	WndChatReport:closeReportWin()
end


function WndChat:_setChoseFriendListBtnText(s_text)
	WZLog("_setChoseFriendListBtnText =",s_text)
    local conPri = GetElement(self.m_root,"conPri_WndChat",WZUIContainer)
    local conFriendN = GetElement(conPri,"conFriendN_WndChat",WZUIContainer)
    local txtFriendName = GetElement(conFriendN,"txtFriendName_WndChat",WZUILabelTTF)
	
	if s_text and s_text ~= "" then
		conFriendN:setVisible(true)
		txtFriendName:setText(s_text)
   	else
   		conFriendN:setVisible(false)
   		txtFriendName:setText("")
	end
end

--@brief	设置左下角显示聊天类型，为点击类型cell的回调
--@param	index:cell中button的tag
function WndChat:_setChatType(index)
    WZLog("WndChat:_setChatType = ",index)
	local edtInputCur,edtPriInput,edtWorld,conCur,conPri,conWorlds = self:_getAllEidtBox()
	conPri:setVisible(false)

	conWorlds:setVisible(false)
	conCur:setVisible(false)
	conPri:setVisible(false)
	local conBottum = GetElement(self.m_root,"conBottum_WndChat",WZUIContainer)
	conBottum:setVisible(true)

	self:showGiveRedPackBtn(false)
	
    if index == CHANNEL_WORLD or index == CHANNEL_COLORCHAT or index == CHANNEL_GOLD then
		-- GetElement(self.m_root,"conDivision_WndChat",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"freelistconSystem_WndChat",WZUIFreeListContainer):setVisible(true)
	else
		GetElement(self.m_root,"conDivision_WndChat",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"freelistconSystem_WndChat",WZUIFreeListContainer):setVisible(false)
	end
	local btnVoice = GetElement(self.m_root,"btnVoice_WndChat",WZUIButton)
	local btnKeyboard = GetElement(self.m_root,"btnKeyboard_WndChat",WZUIButton)
	local conVoiceChat = GetElement(self.m_root,"conVoiceChat_WndChat",WZUIContainer)
	local conWorldVoice = GetElement(self.m_root,"conWorldVoice_WndChat",WZUIContainer)
	local btnSend = GetElement(self.m_root,"btnSend_WndChat",WZUIButton)
	local conPriRecord = GetElement(self.m_root,"conPriRecord_WndChat",WZUIContainer)
	local conExpression = GetElement(self.m_root,"conExpression_WndChat",WZUIContainer)
	local conPrii = GetElement(self.m_root,"conPrii_WndChat",WZUIContainer)
	local conchatcontext = GetElement(self.m_root,"conchatcontext_wndchant",WZUIContainer)
	local img4 = GetElement(conchatcontext,"img4_WndChat",WZUIImage)
	conVoiceChat:setVisible(false)
	conWorldVoice:setVisible(false)
	conPriRecord:setVisible(false)
	conExpression:setVisible(false)
	conPrii:setVisible(false)

	if index == CHANNEL_WHISPER then
		conPrii:setVisible(true)
		img4:setVisible(false)
	end

	local btnFastSendChat = GetElement(conBottum,"btnFastSendChat_WndChat",WZUIContainer)
	local imgWorldType = GetElement(conBottum,"imgWorldType_WndChat",WZUIImage)
	local txtChatPropsCount = GetElement(conBottum,"txtChatPropsCount_WndChat",WZUILabelTTF)
	
	if index == CHANNEL_TEAM or index == CHANNEL_CURRENT then
		if SceneBattle.m_root ~= nil then
			btnFastSendChat:setVisible(true)
		else
			btnFastSendChat:setVisible(false)
		end
	else
		btnFastSendChat:setVisible(false)
	end

	if index == CHANNEL_WORLD then 
		imgWorldType:setFile("ui/chat/chat_common_icon_laba3.png")
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(114) 
        txtChatPropsCount:setText("x"..nColorLabaNum)
	elseif index == CHANNEL_GOLD then
		imgWorldType:setFile("ui/chat/horn_04_1.png")
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(161057) 
        txtChatPropsCount:setText("x"..nColorLabaNum)
	elseif index == CHANNEL_COLORCHAT  then
		imgWorldType:setFile("ui/chat/chat_common_icon_laba2.png")
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(115) 
        txtChatPropsCount:setText("x"..nColorLabaNum)
    elseif index == CHANNEL_COPY then
    	conBottum:setVisible(false)
    	return
	end

	if self.m_bSupportRecord then  --
		if index==CHANNEL_WORLD or index == CHANNEL_COLORCHAT or index == CHANNEL_GOLD then
			conWorlds:setVisible(true)
			if not self.m_bRecordingChat then
				btnVoice:setVisible(true)
				btnKeyboard:setVisible(false)
				btnSend:setVisible(true)
			else
				conWorldVoice:setVisible(true)
				btnSend:setVisible(false)
				btnVoice:setVisible(false)
				self.m_bRecordingChat = true
				btnKeyboard:setVisible(true)
			end
			self:showGiveRedPackBtn(true)
		elseif index==CHANNEL_CURRENT or index==CHANNEL_GUILD or index == CHANNEL_TEAM or index == CHANNEL_UNION then
			conCur:setVisible(true)
			if not self.m_bRecordingChat then        
				btnVoice:setVisible(true)
				btnSend:setVisible(true)
				btnKeyboard:setVisible(false)
				self.m_bRecordingChat = false
			else
				btnSend:setVisible(false)
				conVoiceChat:setVisible(true)
				self.m_bRecordingChat = true
				btnKeyboard:setVisible(true)
			end
			if index == CHANNEL_GUILD then
				self:showGiveRedPackBtn(true)
			end
		elseif index==CHANNEL_WHISPER then
			self:_setChoseFriendListBtnText(self.m_ptempname) --请选择好友
			conPri:setVisible(true)
			if not self.m_bRecordingChat then
				btnSend:setVisible(true)
				self.m_bRecordingChat = false
				btnVoice:setVisible(true)
				btnKeyboard:setVisible(false)
				conExpression:setVisible(true)
			else
				self.m_bRecordingChat = true
				btnSend:setVisible(false)
				conPriRecord:setVisible(true)
				conExpression:setVisible(false)
				btnVoice:setVisible(false)
				btnKeyboard:setVisible(true)
			end
		end
	else
		btnKeyboard:setVisible(true)
		btnSend:setVisible(true)
		btnVoice:setVisible(false)
		if index == CHANNEL_WORLD or index == CHANNEL_COLORCHAT or index == CHANNEL_GOLD then
			conWorlds:setVisible(true)
			self:showGiveRedPackBtn(true)
		elseif index == CHANNEL_CURRENT or index == CHANNEL_GUILD or index == CHANNEL_TEAM or index == CHANNEL_UNION then
			conCur:setVisible(true)
			if index == CHANNEL_GUILD then
				self:showGiveRedPackBtn(true)
			end
		elseif index==CHANNEL_WHISPER then
			conPri:setVisible(true)
			conExpression:setVisible(true)
		end
	end
	--不让切换语音
	--btnKeyboard:setVisible(true)
	--btnVoice:setVisible(false)
end

--翻译
function WndChat:onClickTranslate(element)
	WZLog("WndChat:onClickTranslate")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent = element:getParent()
	parent = parent:getParent()
	parent = parent:getParent()
	parent = parent:getParent()
	parent = parent:getParent()
	parent = WZUIContainer:luaTo(parent)
	local luaObject = parent:getLuaObjectIndex()
	local chatLuaData = luaObject:getData()
	local index = parent:getName()
	index = tonumber(index)
	local chatData = chatLuaData[index]
	local words = chatData.nodeData.words
	WZLog("words=",words)
	if words == nil or words == "" then
		return
	end
	local translateChat = chatData.nodeData.translateText
	local bExit = false
	if translateChat ~= nil and translateChat ~= "" then
		bExit = true
	end
	WndChat.m_elementTranslate = parent
	local originallyText = translateChat
	if not bExit then
		WndChat.m_nLoadId = MsgBoxManager:showLoadingBox(10)
		YDMicrosoftTranslation:translationLanguage(words)
	else
		WndChat:translateCallback(originallyText)
	end
end

--翻译回调
--translateText ： 翻译成功后的字符串
function WndChat:translateCallback(translateChat)
	WZLog("WndChat:translateCallback =",translateChat)
	if self.m_nLoadId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadId)
		self.m_nLoadId = nil
	end
	if self.m_elementTranslate == nil then return end

	local luaObject = self.m_elementTranslate:getLuaObjectIndex()
	local chatLuaData = luaObject:getData()
	local index = self.m_elementTranslate:getName()
	index = tonumber(index)
	local chatData = chatLuaData[index]
	if chatData ~= nil then
		self.m_elementTranslate:removeChildByTag(1199,true)
		local nodeData = chatData.nodeData
		nodeData.translateText = nodeData.words
		nodeData.words = translateChat
		local tbl = chatData.tbl
		local psx1,psy1 = tbl:getPosition()
	    local moveElementHeight = tbl:getContentSize().height
		luaObject:onLoadData(self.m_elementTranslate)
	end
	self.m_elementTranslate = nil
end

--@brief	验证是否为数字
--@param	str:要判断的字符串
function WndChat:isNumbers(str)
    	if string.find(str,"^%d+$") ~= nil and string.len(str) > 0 then
        		return true
    	end
    return false
end

--@brief	关闭经验动画
function WndChat:_closeEx_WndChat()
    local actionEx = self.m_root:getChildElement("actionEx_WndChat")
	if actionEx==nil then
	   WZLog("actionEx==nil")
	   return
	end
	actionEx = WZUIContainer:luaTo(actionEx)
	actionEx:removeFromParentAndCleanup(true)
end

--获取当前编辑器
function WndChat:_getCurEditBox()
	WZLog("WndChat:_getCurEditBox")
	local edtInputCur = GetElement(self.m_root,"edtInputCur_WndChat",WZUIEditBox)
	local edtPriInput = GetElement(self.m_root,"edtPriInput_WndChat",WZUIEditBox)
	local edtInputWorld = GetElement(self.m_root,"edtInputWorld_WndChat",WZUIEditBox)
	if self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT or self.m_nIsCurrent == CHANNEL_GOLD then
		return edtInputWorld
	elseif self.m_nIsCurrent == CHANNEL_WHISPER then
		return edtPriInput
	else
		return edtInputCur
	end
end

--@brief	获取输入框等界面元素
function WndChat:_getAllEidtBox()
   
	--当前内容输入框
	local edtInputCur = GetElement(self.m_root,"edtInputCur_WndChat",WZUIEditBox)
	--好友内容输入框
	local edtPriInput = GetElement(self.m_root,"edtPriInput_WndChat",WZUIEditBox)
	local edtInputWorld = GetElement(self.m_root,"edtInputWorld_WndChat",WZUIEditBox)

	--当前
	local conCur = self.m_root:getChildElement("conCur_WndChat")
	if conCur == nil then
		return
	end
	conCur = WZUIContainer:luaTo(conCur)
	--获取私聊相关容器
	local conPri = self.m_root:getChildElement("conPri_WndChat")
	if conPri == nil then
		return
	end
	conPri = WZUIContainer:luaTo(conPri)

	local conWorld = self.m_root:getChildElement("conWorld_WndChat")
	if conWorld == nil then
		return
	end
	conWorld = WZUIContainer:luaTo(conWorld)
	return edtInputCur,edtPriInput,edtInputWorld,conCur,conPri,conWorld
end

--@brief	弹出角色界面
--@param	element:定时器绑定的UI节点引用
function WndChat:onClickLookPlayerInfo(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if element== nil then
	  WZLog("_displayPlayer(element) == nil")
	  return
	end
	--self:_hideChatWindows()
	local playerId = element:getParent():getTag()
	if playerId ~= 66666666 and playerId ~= 0 then
		WndCheckOther:show(playerId)
	end
end

--@brief  创建系统频道信息
function WndChat:createSystemItem(tbl,nodeData)

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

	comCCSize.width=cellSizeWigth / parentSize.width
	comCCSize.height = cellSizeHeight / parentSize.height


	local data = {tbl=tbl,nodeData = nodeData}
	local cellObj,cellTable = CellMsgItem:createElement(comCCSize.width,comCCSize.height)
	cellTable:setData(data)
	local dataCount = #cellTable:getData()
	cellObj:setName(tostring(dataCount))
	tbl:pushBack(cellObj)
	--pItem:setRelativeSize(comCCSize)
	
end


--@brief	创建显示世界、公会、私聊、当前频道
--@param	tbl:全部频道的freelist
--@param	nodeData:一条信息
function WndChat:_createWorldItem(tbl,nodeData,freelistconPSY)
	--列表加载优
	if nodeData.sendID == nil or (nodeData.sendID <= 0 and nodeData.mainChannel ~= 2)then
	    WZLog("sendID = nil")
	    return
	elseif nodeData.mainChannel == CHANNEL_WHISPER and nodeData.sendID == nodeData.recvID then --GM小助手发的消息-隐藏掉配置表没有的
		local index = string.match(nodeData.words,"{^ttyy##%d+##")
	    if index then
	        index1 = string.match(index,"%d+")
	        if index1 then
	            local config = GDatatab_assistant["id_"..index1]
	            if config == nil then return end 
	        end
	    end
	end
	local bMasterMessage = WhetherMasterMessage(nodeData.mainChannel, nodeData.words)

	local messId = -1
	local data = {tbl=tbl,nodeData = nodeData}
	local cellObj = nil
	local cellTable = nil
	if nodeData.recordMsg then
		local tempPerchent = 135/445
		if bMasterMessage then
			tempPerchent = 185/445
		end
		cellObj,cellTable = CellMsgItem:createElement(536/666,tempPerchent)
	else
		local freeTextTemp = GetElement(self.m_root,"freeTextTemp_WndChat",WZUIFreeTextBox)
		local freeTextTempPri = GetElement(self.m_root,"freeTextTempPri_WndChat",WZUIFreeTextBox)
		freeTextTemp:setShowText("")
		freeTextTempPri:setShowText("")
		if nodeData.mainChannel == CHANNEL_WHISPER then
			freeTextTemp = freeTextTempPri
		end
		-- local freeText = ToChangeFreeText(nodeData.words)
		-- freeTextTemp:setShowText(freeText)
		--local freeTextTempSize = freeTextTemp:getContentSize()
		--local tempHeight = 110
		local tempPerchent = 110 / 445
		if bMasterMessage then
			tempPerchent = 160/445
		end
		if nodeData.mainChannel == CHANNEL_GOLD then 
			tempPerchent = 56/120
		end
		cellObj,cellTable = CellMsgItem:createElement(536/666, tempPerchent)
	end
	cellTable:setData(data)
	local dataCount = #cellTable:getData()
	cellObj:setName(tostring(dataCount))
	tbl:pushBack(cellObj)
	local moveElementHeight = tbl:getMoveElement():getContentSize().height
	local maxY = tbl:getMaxPosition().y
	local size = tbl:size()
	--tbl:updateContainerSize()
	if size > 6 and math.abs(maxY) - math.abs(freelistconPSY) > 240 then
		resetMoveElementPositionY(tbl,freelistconPSY,moveElementHeight)
	end
end

--@brief	创建一条信息UI
--@param	tbl:各频道的freelist
--@param	nodeData:一条信息
function WndChat:_createOneItem(tbl, nodeData)
	WZLog("WndChat:_createOneItem")
	local pItem = WZUIContainer:create()
	comCCPoint.x = 0.5
	comCCPoint.y = 0.5
	pItem:setAnchorPoint(comCCPoint)
    
    comCCPoint.x = 0
	comCCPoint.y = 0

	--内容
	local sContent = nodeData.words
	
	local pLblWords = WZUILabelTTF:create()
	if nodeData.recordMsg then --语音聊天信息
		pLblWords:setText("recordMsg")
	else
		pLblWords:setText(sContent)
	end

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
	
	return pItem,pLblWords
end

--设置表情框不可见
function WndChat:setFaceBoxNotVisible()
	WZLog("WndChat:setFaceBoxNotVisible")
	if self.m_root == nil then return end
	local conFaceBox = GetElement(self.m_root,"conFaceBox_WndChat",WZUIContainer)
	if conFaceBox:isVisible() then
		conFaceBox:setVisible(false)
	end
end


--设置气泡不可见
function WndChat:setBubbleBoxNotVisible()
	WZLog("WndChat:setBubbleBoxNotVisible")
	if self.m_root == nil then return end
	local conBubbleBox = GetElement(self.m_root,"conBubbleBox_WndChat",WZUIContainer)
	if conBubbleBox:isVisible() then
		conBubbleBox:setVisible(false)
	end
end

function WndChat:onClickCloseFaceBox(element)
	WZLog("WndChat:onClickCloseFaceBox")
	local conFaceBox = GetElement(self.m_root,"conFaceBox_WndChat",WZUIContainer)
	if not conFaceBox:isVisible() then return end
	conFaceBox:setVisible(false)
end

function WndChat:onClickCloseBubble(element)
	-- body
	WZLog("WndChat:onClickCloseBubble")
	local conBubbleBox = GetElement(self.m_root,"conBubbleBox_WndChat",WZUIContainer)
	if not conBubbleBox:isVisible() then return end
	conBubbleBox:setVisible(false)
end

--设置屏蔽陌生人框不可见
function WndChat:setBlockStrangerVisible(bShow)
	WZLog("WndChat:setBlockStrangerVisible")
	if self.m_root == nil then return end
	local conBlockStranger = GetElement(self.m_root,"conBlockStranger_WndChat",WZUIContainer)
	conBlockStranger:setVisible(bShow)
end

--点击背景关闭陌生人框
function WndChat:onClickCloseBlockStranger(element)
	WZLog("WndChat:onClickCloseBlockStranger")
	self:setBlockStrangerVisible(false)
end

--@brief   复制消息函数
function WndChat:_copy(element)
	WZLog("WndChat:_copy ", self.m_nIsCurrent)
	local bMatching = SceneRoom:getClickSeat()
    if bMatching == false then
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
	local conMsg = WZUIContainer:luaTo(element:getParent())
	local imgMsgBg = GetElement(conMsg, "imgMsgBg_WndChat", WZUI9Image)
	if imgMsgBg == nil then return end 
	local strFileName = imgMsgBg:getFile()
	local nStartIndex, nEndIndex = string.find(strFileName, "talk_hb_")
	if nStartIndex and nEndIndex and nEndIndex > 0 then --红包的底
		local redPackId = element:getTag()
		local channelId = 0
		if self.m_nIsCurrent == 0 then
			channelId = 0
		elseif self.m_nIsCurrent == 2 then
			channelId = 1
		end
		ProtocolProcessorGlobal:send_CHAT_GrabRedEnvelope(redPackId,channelId)
		return 
	end
    local playerid = element:getTag()-11
	local txtTemp = GetElement(conMsg,"txtTemp_WndChat",WZUILabelTTF)
	if txtTemp == nil then
		return
	end
	local txt = txtTemp:getText()
	local indexx = string.find(txt,"##~")
	local tempT = nil
	local roomId = nil 
	local mapId = nil
	if indexx ~= nil and indexx > 0 then
		local teamRoomInfo = string.sub(txt,indexx+3)
		tempT = SplitStringWithSeparator(teamRoomInfo,"||")
		if tempT and #tempT == 2 then
			roomId = tonumber(tempT[1])
		    mapId = tonumber(tempT[2])
		    WZLog("roomInfo =",roomId,mapId)
		    txt = string.sub(txt,0,indexx-1)
		end
	end
	local playerInfo = CacheCenter:getPlayerInfo()
	if self.m_nIsCurrent == CHANNEL_COPY and CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) and roomId ~= nil and mapId ~= nil and playerid ~= playerInfo.id then
    	if SceneRoom.m_root == nil and SceneBossRoom.m_root == nil and SceneBattle.m_root == nil and SceneBattleLoading.m_root == nil and GlobalGame.g_bIfInBattle == false and WndTeachOpenModule.m_root == nil and WndTeachTalk.m_root == nil and SceneKingMain.m_root == nil and not WndChat.m_bRecording and not SceneHall:getMatchState() and not WndStrengthen.m_root and not WndTowerScroll.m_root and not SceneWeddingChurch.m_root and not SceneLeagueRoom.m_root and not SceneAthMelee.m_root and SceneMarryCopy.m_root == nil and SceneTabooBattle.m_root == nil and SceneGuildWarRoom.m_root == nil and WndLeagueTeamDetail.m_root == nil and SceneWorldTeamBossRoom.m_root == nil and SceneCoupleHegemonyRoom.m_root == nil and WndDoubleTowerRoom.m_root == nil then
            ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId,"",mapId,5)   
            return
        else
        	MsgBoxManager:showTipBox(LocalStrings.WORLD_TEAM_IV_ERROR2)
        	return
        end
	end

	self.m_tClickMsgData = nil 
	if self.m_nIsCurrent ~= CHANNEL_COPY then 
		if playerid ~= playerInfo.id then 
			self.m_tClickMsgData = {}
			self.m_tClickMsgData.playerId = playerid 
			self.m_tClickMsgData.content = txt 
			self.m_tClickMsgData.playerName = " "

			local conItemMsg = WZUIContainer:luaTo(conMsg:getParent())
			local txtSendMsgNameS = GetElement(conItemMsg, "txtSendMsgNameS_WndChat", WZUILabelTTF)
			if txtSendMsgNameS then 
				self.m_tClickMsgData.playerName = txtSendMsgNameS:getText()
			end

			WndChatReportMenu:showInterface(conMsg, self.m_tClickMsgData)
		else
			local edit = WndChat:_getCurEditBox()
			if edit then
				local strTxt = string.gsub(txt, " ", "")
				edit:setText(strTxt)
			end
		end
	end
end

--@brief 	点击删除金喇叭消息按钮回调
function WndChat:onClickDel(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local pToList = WndChat.m_root:getChildElement("freelistconGold_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	for i = 0, pToList:size() - 1 do
		local parent = pToList:getAt(i)
		parent = WZUIContainer:luaTo(parent)
		local luaObject = parent:getLuaObjectIndex()
		local chatLuaData = luaObject:getData()
		local index = parent:getName()
		index = tonumber(index)
		local chatData = chatLuaData[index]
		WZLog("WndChat:onClickDel",chatData and chatData.nodeData.msgIndex)
		if chatData and chatData.nodeData.msgIndex == nTag then
			if self.m_oCurPlayRecordCell ~= parent and self.m_elementTranslate ~= parent then
				pToList:removeAt(i)
			end
		end
    end

    if pToList:size() > 0 then 
    	WndChat:_resetConSize(0)
    else
    	WndChat:_resetConSize(1)
    end
end

--@brief 	点击删除金喇叭消息
function WndChat:delGoldMsg(nTag)
	local pToList = WndChat.m_root:getChildElement("freelistconGold_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	for i = 0, pToList:size() - 1 do
		local parent = pToList:getAt(i)
		parent = WZUIContainer:luaTo(parent)
		local luaObject = parent:getLuaObjectIndex()
		local chatLuaData = luaObject:getData()
		local index = parent:getName()
		index = tonumber(index)
		local chatData = chatLuaData[index]
		WZLog("WndChat:delGoldMsg",chatData and chatData.nodeData.msgIndex)
		if chatData and chatData.nodeData.msgIndex == nTag then
			if self.m_oCurPlayRecordCell ~= parent and self.m_elementTranslate ~= parent then
				pToList:removeAt(i)
			end
		end
    end

    if pToList:size() > 0 then 
    	self:_resetConSize(0)
    else
    	self:_resetConSize(1)
    end
end

--@brief	初始化队列
function WndChat:_initAllMsg()
	--私聊--公会--彩聊--当前--系统
	self.PrivateWords = {LIMIT= 30, count=0,}
	self.GongHui = {LIMIT= 30, count=0,}
	self.Union = {LIMIT= 30, count=0,}
	self.Current = {LIMIT= 30, count=0,}
	self.System = {LIMIT= 5, count=0,}
	self.conWorld = {LIMIT= 30, count=0,}
	self.goldWorld = {LIMIT= 2, count=0,}
end

--@brief	创建一条信息表
--@param	iMainChannel等:服务器传过来的数据字段
function WndChat:_createListNode(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerhead,playerFace,playerSex,bRecordChat,nRecordT,messId,headScul,serviceId,isOwnSend,headColor,senderlevel,recLevel,sendTime,recPlayerVipLevel,recPlayerHead,recPlayerFace,recPlayerSex,recPlayerHeadColor,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, chatType, headEffectId, receivePlayerHeadEffectId)
	local t = {}
    WZLog("创建一条信息表",iSendID,isOwnSend, headEffectId)
    --WZLog(iMainChannel.."|"..iSendID.."|"..sSendName.."|"..iRecvID.."|"..sRecvName.."|"..sMsgContent.."|"..tm.."|"..vipLevel)qwertyuiop
	t.nextNode = nil
	t.mainChannel = iMainChannel
	t.mainChannelName = nil
	t.sendID = iSendID
    t.head = playerhead
    t.face = playerFace
    t.sex = playerSex
	t.sendName = sSendName
	t.recvID = iRecvID
	t.recvName = sRecvName
	t.recvLevel = recLevel
	t.words = sMsgContent
	t.tm = tm
	t.headColor = headColor
	t.senderlevel = senderlevel
	t.vipLevel = vipLevel
	t.recordMsg = bRecordChat
	t.recordT = nRecordT
	t.messageId = messId
	t.bPlayed = bPlayed or 0
	if headScul == nil or headScul == "" or headScul == 0 then
		headScul = 0
	else
		headScul = 1
	end
	t.playerPhoto = headScul
	t.serviceId = serviceId
	if isOwnSend then
	    t.ownSend = isOwnSend
	else
		t.ownSend = false
		if iSendID == GlobalGame.g_tPlayerInfo.nPlayerId then
			t.ownSend = true
		end
	end
	if sendTime == nil then
	    t.sendTime = os.time()
	else
		t.sendTime = sendTime
	end
	if iMainChannel == CHANNEL_WHISPER then
		if recPlayerVipLevel then
		    t.recPlayerVipLevel = recPlayerVipLevel
		end
		if recPlayerHead then
			t.recPlayerHead = recPlayerHead
		end

		if recPlayerFace then
			t.recPlayerFace = recPlayerFace
		end

		if recPlayerSex then
			t.recPlayerSex = recPlayerSex
		end

		if recPlayerHeadColor then
			t.recPlayerHeadColor = recPlayerHeadColor
		end
	end
	if bubbleId == nil then
		bubbleId = -1
	end
	t.bubbleId = bubbleId

	t.playerTitle = playerTitle
	t.playerPvpLevel = playerPvpLevel
	t.professionId = professionId
	t.openStatus = openStatus
	if chatType and (chatType == 9 or chatType == 10) then 
		t.chatType = chatType
	end
	t.headEffectId = headEffectId or 0
	t.receivePlayerHeadEffectId = receivePlayerHeadEffectId
	
	return t
end

--@brief	获取频道名字和id
--@param	channel:频道号
function WndChat:_getChannelTableAndName(channel)
	local n
	--channel
	if channel == CHANNEL_COLORCHAT then
		n = LocalStrings.CHAT_COLORLIAOK
	elseif channel == CHANNEL_WORLD or channel == CHANNEL_GOLD then
		n = LocalStrings.CHAT_WORLDK
	elseif channel == CHANNEL_CURRENT then
		n = LocalStrings.CHAT_CURRENTK
	elseif channel == CHANNEL_WHISPER then
		n = LocalStrings.CHAT_PRIVATEK
	elseif channel == CHANNEL_GUILD then
		n = LocalStrings.CHAT_GONGHUIK
	elseif channel == CHANNEL_SYSTEM then
		n = LocalStrings.CHAT_SYSTEMK
	elseif  channel == CHANNEL_TEAM then
		n = LocalStrings.TEAM
	elseif channel == CHANNEL_COPY then
		n = LocalStrings.CHAT_COLORLIAOK
	elseif channel == CHANNEL_UNION then
		n = LocalStrings.UNION_TEXT1[50]
	else
		n = nil
	end
	return n
end

--@brief	接收到聊天信息进行显示
--@param	iMainChannel等:频道号等
function WndChat:_pushWords(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,headScul,
	serviceId,bRecordChat,nRecordT,messageId,isOwnSend,headColor,senderLevel,rtime,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, offlineMessage, chatType, headEffectId, receivePlayerHeadEffectId)
	WZLog("WndChat:_pushWordsb ",iMainChannel,isOwnSend,isOwnSend, headEffectId, chatType, offlineMessage)
	if (sMsgContent == nil or sMsgContent == "" or string.len(sMsgContent) == 0) and not bRecordChat then
        WZLog("sMsgContent is nil")
		return
	end
	if (iMainChannel ~= CHANNEL_SYSTEM and sSendName ~= LocalStrings.CHAT_SYSTEM and iMainChannel ~= CHANNEL_COLORCHAT and iMainChannel ~= CHANNEL_COPY and iMainChannel ~= CHANNEL_GOLD ) or ( iMainChannel == CHANNEL_SYSTEM and sSendName == LocalStrings.TIP) then
		if iMainChannel == CHANNEL_WHISPER then
			local sTempMsg = string.sub(sMsgContent, 1, 6)
			if sTempMsg == g_MasterMessage_Mark then
				local sCurrentMsg = string.gsub(sMsgContent, g_MasterMessage_Mark, "")
				WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sCurrentMsg, tm, vipLevel, bRecordChat)
			else
				WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel, bRecordChat)
			end
		elseif iMainChannel == CHANNEL_GUILD then
	        local sStart,sEnd,sContent = string.find(sMsgContent,g_REMAINSMessage_Mark)
        	if sContent then
	            tabContent = json.decode(sContent)
	            local sCurrentMsg = tabContent.desc .. tabContent.text
				WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sCurrentMsg, tm, vipLevel, bRecordChat)
			else
				if chatType == 10 then 
					local sTempString = string.format(LocalStrings.RED_PACK12, sSendName)
					WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sTempString, tm, vipLevel, bRecordChat)
				else
					WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel, bRecordChat)
				end
			end
		else
			if chatType == 9 then 
				local sTempString = string.format(LocalStrings.RED_PACK12, sSendName)
				WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sTempString, tm, vipLevel, bRecordChat)
			else
				WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel, bRecordChat)
			end
		end
	end

	if isOwnSend then
	    if self.m_nCurBubbleId == 0 then
	    	self:_setPlayerBubbleId()
	    end
	    bubbleId = self.m_nCurBubbleId
	end

	if self.m_root == nil then
		--私聊缓存
		WZLog("WndChat:m_root nil", iMainChannel,bRecordChat,nRecordT,messageId)
		if iMainChannel == CHANNEL_WHISPER then
			CacheCenter:setRedState("btnChat", true)
		    GlobalGame:getBtnRedPointEvent():dispatcher()
			self:_addPriChatCache(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead, playerFace, playerSex, headScul, serviceId, headColor, senderLevel, rtime, bubbleId, playerTitle, playerPvpLevel, professionId, openStatus,bRecordChat,nRecordT,messageId, headEffectId)  
		end
		return 
	end

	if iMainChannel ~= 5 and not bRecordChat and sSendName ~= LocalStrings.CHAT_SYSTEM then
	    if not self:bSend(sMsgContent) then return end
	end

	if iMainChannel == CHANNEL_WHISPER then
		if not isOwnSend then
		    self:_addLatelyPriChatPlayer(iSendID, senderLevel, sSendName, vipLevel, playerHead, playerFace, playerSex, headColor, rtime, isOwnSend, true, true, nil, headEffectId)
		else
			self:_addLatelyPriChatPlayer(self.m_nReciveId, self.m_nReciveLevel, self.m_ptempname, self.m_nReceivePlayerVipLevel, self.m_nReceivePlayerHead, self.m_nReceivePlayerFace, self.m_nReceivePlayerSex, self.m_nReceivePlayerHeadColor, rtime, true, nil, nil, nil, self.m_nReceivePlayerHeadEffectId)
		end
	end

	local recvDataListNode = self:_createListNode(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,bRecordChat,nRecordT,messageId,headScul,serviceId,isOwnSend,headColor,senderLevel,self.m_nReciveLevel,rtime,self.m_nReceivePlayerVipLevel,self.m_nReceivePlayerHead,self.m_nReceivePlayerFace,self.m_nReceivePlayerSex,self.m_nReceivePlayerHeadColor,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, chatType, headEffectId, receivePlayerHeadEffectId)	 --创建一条信息表
	recvDataListNode.mainChannelName = self:_getChannelTableAndName(iMainChannel) --获取频道的名字
	recvDataListNode.mainChannelName = recvDataListNode.mainChannelName or ""
	self:_showRedPoint(iMainChannel,sSendName)

	if recvDataListNode.mainChannel ~= CHANNEL_SYSTEM and recvDataListNode.sendName ~=LocalStrings.CHAT_SYSTEM and (iSendID ~= GlobalGame.g_tPlayerInfo.nPlayerId or (offlineMessage~=nil and offlineMessage == 1) or recvDataListNode.mainChannel == CHANNEL_GOLD) then
		if recvDataListNode.mainChannel == CHANNEL_WORLD or recvDataListNode.mainChannel == CHANNEL_COLORCHAT or recvDataListNode.mainChannel == CHANNEL_GOLD then
			local tNodeCopy = CopyTable(recvDataListNode)
			if recvDataListNode.mainChannel == CHANNEL_GOLD then 
				if #self.m_tWorldGoldMsgList >= self.goldWorld.LIMIT then
				    table.remove(self.m_tWorldGoldMsgList,1)
			    end
			    recvDataListNode.msgIndex = self.m_nGoldMsgIndex
			    table.insert(self.m_tWorldGoldMsgList,recvDataListNode)
			    self.m_nGoldMsgIndex = self.m_nGoldMsgIndex + 1
			    self:_resetConSize(0)
			end
		    if #self.m_tWorldMsgList >= self.Current.LIMIT then
			    table.remove(self.m_tWorldMsgList,1)
		    end
		    if recvDataListNode.mainChannel == CHANNEL_GOLD then 
		    	tNodeCopy.mainChannel = CHANNEL_COLORCHAT
		    end
		    table.insert(self.m_tWorldMsgList, tNodeCopy)
		elseif recvDataListNode.mainChannel == CHANNEL_GUILD then
			WZLog("打开公会聊天",#self.m_tGuildMsgList,self.GongHui.LIMIT)
			if #self.m_tGuildMsgList >= self.GongHui.LIMIT then
			    table.remove(self.m_tGuildMsgList,1)
		    end
		    table.insert(self.m_tGuildMsgList,recvDataListNode)
		elseif recvDataListNode.mainChannel == CHANNEL_WHISPER then
			if #self.m_tPrivateMsgList >= self.Current.LIMIT then
			    table.remove(self.m_tPrivateMsgList,1)
		    end
		    table.insert(self.m_tPrivateMsgList,recvDataListNode)
		elseif recvDataListNode.mainChannel == CHANNEL_CURRENT then
			if #self.m_tCurrentMsgList >= self.Current.LIMIT then
			    table.remove(self.m_tCurrentMsgList,1)
		    end
		    table.insert(self.m_tCurrentMsgList,recvDataListNode)
		elseif recvDataListNode.mainChannel == CHANNEL_TEAM then
			if #self.m_tTeamMsgList >= self.Current.LIMIT then
			    table.remove(self.m_tTeamMsgList,1)
		    end
		    table.insert(self.m_tTeamMsgList,recvDataListNode)
		    if #self.m_tCurrentMsgList >= self.Current.LIMIT then --接收到队伍频道信息也需要在当前频道显示
			    table.remove(self.m_tCurrentMsgList,1)
		    end
		    table.insert(self.m_tCurrentMsgList,recvDataListNode)
		elseif recvDataListNode.mainChannel == CHANNEL_COPY then
			if #self.m_tCopyMsgList >= self.Current.LIMIT then
			    table.remove(self.m_tCopyMsgList,1)
		    end
		    table.insert(self.m_tCopyMsgList,recvDataListNode)
		elseif recvDataListNode.mainChannel == CHANNEL_UNION then
			WZLog("Union chat",#self.m_tUnionMsgList,self.Union.LIMIT)
			if #self.m_tUnionMsgList >= self.Union.LIMIT then
			    table.remove(self.m_tUnionMsgList,1)
		    end
		    table.insert(self.m_tUnionMsgList,recvDataListNode)
		end
		return
	end
	self:addMsgToOldList(recvDataListNode)
	self:showMsg(recvDataListNode,recvDataListNode.mainChannel)
	if recvDataListNode.mainChannel == CHANNEL_TEAM then --队伍聊天信息需要在当前频道显示
		self:showMsg(recvDataListNode,CHANNEL_CURRENT)
	end

	if recvDataListNode.mainChannel == CHANNEL_WHISPER then
		self:_addPriChatToLocal()
	end
end

function WndChat:addMsgToOldList(recvDataListNode)
	WZLog("WndChat:addMsgToOldList", recvDataListNode.mainChannel)
	if recvDataListNode.mainChannel == CHANNEL_WORLD or recvDataListNode.mainChannel == CHANNEL_COLORCHAT then
	    if #self.m_tOldWorldMsgList >= self.Current.LIMIT then
		    table.remove(self.m_tOldWorldMsgList,1)
	    end
	    table.insert(self.m_tOldWorldMsgList,recvDataListNode)
	elseif recvDataListNode.mainChannel == CHANNEL_GUILD then
		if #self.m_tOldGuildMsgList >= self.GongHui.LIMIT then
		    table.remove(self.m_tOldGuildMsgList,1)
	    end
	    table.insert(self.m_tOldGuildMsgList,recvDataListNode)
	elseif recvDataListNode.mainChannel == CHANNEL_WHISPER then
		local bExit = false
	    local tempT = nil
	    local playerInfo = CacheCenter:getPlayerInfo()
	    for i,v in ipairs(self.m_tOldPrivateMsgList) do  --私聊特殊处理，需要保存每个私聊的聊天列表
	    	for j,k in ipairs(v) do
	    		if k.sendID == recvDataListNode.sendID and not k.ownSend and not recvDataListNode.ownSend then
	    		    bExit = true
	    		    tempT = v
		    	elseif k.recvID == recvDataListNode.recvID and k.ownSend and recvDataListNode.ownSend then
		    	    bExit = true
		    		tempT = v
		    	elseif k.recvID == recvDataListNode.sendID and k.ownSend and not recvDataListNode.ownSend then
		    	    bExit = true
		    		tempT = v
		    	elseif k.sendID == recvDataListNode.recvID and not k.ownSend and  recvDataListNode.ownSend then
		    	    bExit = true
		    		tempT = v
		    	end
	    	end
	    	if bExit then
	    		break
	    	end
	    end
	    if not bExit then
	    	local temp = {}
	    	table.insert(temp,recvDataListNode)
	    	table.insert(self.m_tOldPrivateMsgList,temp)
	    else
	    	if #tempT >=30 then
	    		table.remove(tempT,1)
	    	end
	    	table.insert(tempT,recvDataListNode)
	    end
	elseif recvDataListNode.mainChannel == CHANNEL_CURRENT then
		if #self.m_tOldCurrentMsgList >= self.Current.LIMIT then
		    table.remove(self.m_tOldCurrentMsgList,1)
	    end
	    table.insert(self.m_tOldCurrentMsgList,recvDataListNode)
	elseif recvDataListNode.mainChannel == CHANNEL_TEAM then 
		if #self.m_tOldTeamMsgList >= self.Current.LIMIT then
		    table.remove(self.m_tOldTeamMsgList,1)
	    end
	    table.insert(self.m_tOldTeamMsgList,recvDataListNode)

	    if #self.m_tOldCurrentMsgList >= self.Current.LIMIT then  --自己发的队伍信息，需要保存到当前频道列表
		    table.remove(self.m_tOldCurrentMsgList,1)
	    end
	    table.insert(self.m_tOldCurrentMsgList,recvDataListNode)
	elseif recvDataListNode.mainChannel == CHANNEL_COPY then
		if #self.m_tOldCopyMsgList >= self.Current.LIMIT then
		    table.remove(self.m_tOldCopyMsgList,1)
	    end
	    table.insert(self.m_tOldCopyMsgList,recvDataListNode)
	elseif recvDataListNode.mainChannel == CHANNEL_UNION then
		if #self.m_tOldUnionMsgList >= self.Union.LIMIT then
		    table.remove(self.m_tOldUnionMsgList,1)
	    end
	    table.insert(self.m_tOldUnionMsgList,recvDataListNode)
	end
end

--@brief 显示聊天信息
--ntag : 标志 （0世界，1当前，2公会，3队伍，4私聊, 5系统, 6彩聊
function WndChat:showMsg(recvDataListNode,nTag)
	self:_pushWordsToUI(recvDataListNode,nTag)
end

--@brief  获取世界频道容器
function WndChat:getFreelistWorld()
--	WZLog("WndChat:getFreelistWorld")
	local pToList = self.m_root:getChildElement("freelistconWorld_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local psy1 = pToList:getMoveElement():getPositionY()
	if pToList:size() >= self.conWorld.LIMIT then
		local element = pToList:getAt(0)
		element = WZUIContainer:luaTo(element)
		if self.m_oCurPlayRecordCell ~= element and self.m_elementTranslate ~= element then
			pToList:removeAt(0)
		end
    end
    return pToList,psy1
end

--@brief  获取世界频道金喇叭容器
function WndChat:getFreelistWorldGold()
--	WZLog("WndChat:getFreelistWorld")
	local pToList = self.m_root:getChildElement("freelistconGold_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local psy1 = pToList:getMoveElement():getPositionY()
	if pToList:size() >= self.goldWorld.LIMIT then
		local element = pToList:getAt(0)
		element = WZUIContainer:luaTo(element)
		if self.m_oCurPlayRecordCell ~= element and self.m_elementTranslate ~= element then
			pToList:removeAt(0)
		end
    end
    return pToList,psy1
end

--@brief  获取系统频道容器
function WndChat:getFreelistSystem()
	WZLog("WndChat:getFreelistSystem")
	local pToList = self.m_root:getChildElement("freelistconSystem_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	if pToList:size() >= self.System.LIMIT then
		local element = pToList:getAt(0)
		pToList:removeAt(0)
    end
    return pToList
end

--@brief  获取公会频道容器
function WndChat:getFreelistGuild()
	WZLog("WndChat:getFreelistGuild")
	local pToList = self.m_root:getChildElement("freelistconGonghui_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local psy1 = pToList:getMoveElement():getPositionY()
	if pToList:size() >= self.GongHui.LIMIT then
		local element = pToList:getAt(0)
		element = WZUIContainer:luaTo(element)
		if self.m_oCurPlayRecordCell ~= element and self.m_elementTranslate ~= element then
			pToList:removeAt(0)
		end
    end
    return pToList,psy1
end

--@brief  获取当前频道容器
function WndChat:getFreelistCur()
	WZLog("WndChat:getFreelistCur")
	local pToList = self.m_root:getChildElement("freelistconCur_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local psy1 = pToList:getMoveElement():getPositionY()
	if pToList:size() >= self.Current.LIMIT then
		local element = pToList:getAt(0)
		element = WZUIContainer:luaTo(element)
		if self.m_oCurPlayRecordCell ~= element and self.m_elementTranslate ~= element then
			pToList:removeAt(0)
		end
    end
    return pToList,psy1
end

--@brief  获取副本频道容器
function WndChat:getFreelistCopy()
--	WZLog("WndChat:getFreelistCopy")
	local pToList = self.m_root:getChildElement("freelistconCopy_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local psy1 = pToList:getMoveElement():getPositionY()
	if pToList:size() >= self.Current.LIMIT then
		local element = pToList:getAt(0)
		element = WZUIContainer:luaTo(element)
		pToList:removeAt(0)
    end
    return pToList,psy1
end

--@brief  获取队伍频道容器
function WndChat:getFreelistTeam()
	WZLog("WndChat:getFreelistTeam")
	local pToList = self.m_root:getChildElement("freelistconTeam_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local psy1 = pToList:getMoveElement():getPositionY()
	if pToList:size() >= self.Current.LIMIT then
		local element = pToList:getAt(0)
		element = WZUIContainer:luaTo(element)
		if self.m_oCurPlayRecordCell ~= element and self.m_elementTranslate ~= element then
			pToList:removeAt(0)
		end
    end
    return pToList,psy1
end

--@brief  获取私聊频道容器
function WndChat:getFreelistPri()
	WZLog("WndChat:getFreelistPri")
	local pToList = self.m_root:getChildElement("freelistconPrivate_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local psy1 = pToList:getMoveElement():getPositionY()
	if pToList:size() >= self.PrivateWords.LIMIT then
		local element = pToList:getAt(0)
		element = WZUIContainer:luaTo(element)
		if self.m_oCurPlayRecordCell ~= element and self.m_elementTranslate ~= element then
			pToList:removeAt(0)
		end
    end
    return pToList,psy1
end

--@brief  获取联盟频道容器
function WndChat:getFreelistUnion()
	WZLog("WndChat:getFreelistUnion")
	local pToList = self.m_root:getChildElement("freelistconUnion_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local psy1 = pToList:getMoveElement():getPositionY()
	if pToList:size() >= self.Union.LIMIT then
		local element = pToList:getAt(0)
		element = WZUIContainer:luaTo(element)
		if self.m_oCurPlayRecordCell ~= element and self.m_elementTranslate ~= element then
			pToList:removeAt(0)
		end
    end
    return pToList,psy1
end

--@brief	在界面上显示一条信息
--@param	nodeData:一条信息
--@param    ntag : 标志 （0世界，1当前，2公会，3队伍，4私聊, 5系统, 6彩聊）  nodeData.InfaceTag:界面id
function WndChat:_pushWordsToUI(nodeData,ntag)
    WZLog("WndChat:_pushWordsToUI", ntag)
	if self.m_root == nil then
		return
	end
	if nodeData == nil then
		return
	end

	local pToList = nil
	local freelistPSY = nil
	if ntag == CHANNEL_SYSTEM then
		pToList = self:getFreelistSystem()
		self:createSystemItem(pToList, nodeData)
	end
	
	if ntag == CHANNEL_GOLD then
		pToList,freelistPSY = self:getFreelistWorldGold()
	elseif ntag == CHANNEL_WORLD or (ntag == CHANNEL_COLORCHAT and nodeData.sendName ~=LocalStrings.CHAT_SYSTEM ) then
		pToList,freelistPSY = self:getFreelistWorld()
	elseif ntag == CHANNEL_WHISPER  then
		pToList,freelistPSY = self:getFreelistPri()
	elseif ntag == CHANNEL_GUILD  then
		pToList,freelistPSY = self:getFreelistGuild()
	elseif ntag == CHANNEL_CURRENT  then  --当前聊天频道
		pToList,freelistPSY = self:getFreelistCur()
	elseif ntag == CHANNEL_TEAM then
		pToList,freelistPSY = self:getFreelistTeam()
	elseif ntag == CHANNEL_COPY then
		pToList,freelistPSY = self:getFreelistCopy()
	elseif ntag == CHANNEL_UNION  then
		pToList,freelistPSY = self:getFreelistUnion()
	end
	if pToList ~= nil then
		self:_createWorldItem(pToList, nodeData,freelistPSY)
	end
end


function WndChat:_changeNColor(ttf,channel)
	if channel == CHANNEL_CURRENT then
		ttf:setColor(GlobalMethod:ccc3(255,255,255))
	elseif channel == CHANNEL_WORLD or channel == CHANNEL_COLORCHAT or channel == CHANNEL_GOLD then
		ttf:setColor(GlobalMethod:ccc3(255,227,116))
	elseif channel == CHANNEL_GUILD then
		ttf:setColor(GlobalMethod:ccc3(255,121,31))
	elseif channel == CHANNEL_WHISPER then
		ttf:setColor(GlobalMethod:ccc3(199,139,255))
	elseif channel == CHANNEL_TEAM then
		ttf:setColor(GlobalMethod:ccc3(233,166,62))
	end
end

--@brief  接收到语音聊天信息回调
--@param  recordMsg : 接收到语音信息 
function WndChat:recRecordCallback(recordMsg)
	WZLog("WndChat:recRecordCallback =",Serialize(recordMsg))
	if recordMsg == nil then
		return
	end

	if type(recordMsg) ~= "table" then
		return
	end
    
	local recordId = tostring(recordMsg.fileID) 
	local recordPath = tostring(recordMsg.filePath or "")
	local recordLen = tonumber(recordMsg.time)
	local channel = tonumber(recordMsg.chatChannel)
	local recPlayerId = tonumber(recordMsg.recPlayerId)
	local recPlayerName = ""
	
	for i,v in ipairs(self.m_tPriPlayerInfo) do
		if v[1] == recPlayerId then
			recPlayerName = v[2]
			break
		end
	end
	WZLog("recordLen =",recordLen)
	if recordLen == nil or  recordLen < 1  then
		recordLen = 1
	end

    local curServerName ,curServerId = IPDhttpServer:getCurServerName()
    curServerId = tonumber(curServerId)
	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo == nil then return end
	local nSex = playerInfo.sex--玩家性别
	local head,face = self:getPlayerHeadAndFace()
	local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
    local gameParam = CacheCenter:getGameParam()
    local tempT = {}
    table.insert(tempT,recordId)
    table.insert(tempT,channel)
    table.insert(tempT,recPlayerId)
    table.insert(tempT,recPlayerName)
    table.insert(tempT,recordLen)
    table.insert(tempT,recordPath)
    table.insert(self.m_tRecordFileId,tempT)
    --WGCloudVoiceNotify:SpeechToText(recordId)
    self:callbackTranslateByRecord(recordMsg)
end

-------------------------------------私有方法模块End----------------------------------------

--@brief    获得当前发送时间
function WndChat:_getSendTimeString(tm)
        local _tm = nil
        if nil == tm then
        	_tm =os.time()
        else
        	_tm = tm
        end
    	
    	local timeStruct = os.date("*t",_tm)
    	WZLog("System tiem::".._tm,os.date())
    	local timeStr = string.format("%02d:%02d",timeStruct.hour,timeStruct.min)
    	WZLog(timeStruct.month.."-"..timeStruct.day)
    	--local _sendTime = string.format("%02d-%02d %s",timeStruct.month,timeStruct.day,timeStr)
    	if timeStr ~= nil then
        	return timeStr
    	end
    return
end

--@brief    重置输入框里的内容
--btag 私聊不能清空edtFriendID  特殊处理 
function WndChat:_resetEditInputMsg(btag)
	local edtInputCur,edtPriInput,edtWorld,conCur,conPri,conWorld = self:_getAllEidtBox()
	if btag ~= nil then    	
    	edtInputCur:setText("")
    	--edtFriendID:setText("")
    	edtPriInput:setText("")
	else
    	edtInputCur:setText("")
    	edtPriInput:setText("")
    	edtWorld:setText("")
	end
end

-- --敏感词汇检查
-- function WndChat:CheckYellow(tstr)
-- 	WZLog("WndChat:CheckYellow(tstr)")
-- 	if ProjConfig.LANGUAGE == "tr" then
-- 		return tstr
-- 	end
-- 	local yellowstr = tstr
-- 	for k,v in ipairs(ChatKeyWords) do
-- 		yellowstr = string.gsub(yellowstr,v,"xxx")
-- 	end
--     return yellowstr
-- end

--敏感词汇检查
function WndChat:CheckYellow(tstr)
	WZLog("WndChat:CheckYellow(tstr)")
	if ProjConfig.LANGUAGE == "tr"  then
		return tstr
	end
	local yellowstr, bHaveMask = CheckYellow(tstr)
    return yellowstr, bHaveMask
end

function WndChat:selTextChange(channel)
	WZLog("WndChat:selTextChange", channel)
	local checkBoxGroup = GetElement(self.m_root,"checkBoxGroup_WndChat",WZUICheckBoxGroup)
	if channel == CHANNEL_WORLD then
		checkBoxGroup:setCheckIndex(1)
	elseif channel == CHANNEL_CURRENT then
		checkBoxGroup:setCheckIndex(0)
	elseif channel ==CHANNEL_GUILD then
		checkBoxGroup:setCheckIndex(2)
	elseif channel == CHANNEL_WHISPER then
		checkBoxGroup:setCheckIndex(3)
	elseif channel == CHANNEL_TEAM then
		checkBoxGroup:setCheckIndex(4)
	elseif channel == CHANNEL_COPY then
		checkBoxGroup:setCheckIndex(5)
	elseif channel == CHANNEL_UNION then
		checkBoxGroup:setCheckIndex(6)
	end
end

--@brief 	购买气泡
function WndChat:buyBubble(nTag, bubbleInfo)
	-- body
	WZLog("self.m_tBuyBubbleData", Serialize(bubbleInfo))
	WndItemInfo:_onCloseClick()
	if nTag == 1 then return end 
	if WndBattleHud.m_root then 
		MsgBoxManager:showTipBox(LocalStrings.CHAT_CANTBUY)
		return 
	end

	self.m_tBuyBubbleData = CopyTable(bubbleInfo)
	if not JudgeMoneyIsEnough(bubbleInfo.basicInfo.property[1][1], bubbleInfo.basicInfo.property[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.useDiamondToBuyBubble) then
		return false
	end
	self:useDiamondToBuyBubble()
end

--@brief 	使用蓝钻代替粉钻消耗
function WndChat:useDiamondToBuyBubble()
	-- body
	if self.m_tBuyBubbleData then
		ProtocolProcessorGlobal:send_CHAT_BuyChatBubble(self.m_tBuyBubbleData.id)
		self.m_tBuyBubbleData = nil 
	end
end

--@brief 	打开举报界面，暂停刷消息列表
function WndChat:stopFrashMsgList()
	-- body
	if self.m_root == nil then return end 
	
	local conchatcontext= GetElement(self.m_root,"conchatcontext_wndchant",WZUIContainer)
	local bStop = false 
	if WndChatReportMenu and WndChatReportMenu.m_root then 
    	bStop = true
    end

    if WndChatReport and WndChatReport.m_root then 
    	bStop = true
    end
    if bStop then 
    	conchatcontext:disableSchedule()
    else
    	conchatcontext:enableSchedule("showCacheMsg",0.5)
    end
end

--@brief    设置红包按钮是否可见
function WndChat:setRedPackBtnVisible()
    if self.m_root == nil then return end 

    local btnRedPack = GetElement(self.m_root, "btnRedPack_WndChat", WZUIButton)
    if btnRedPack:isVisible() ~= g_QuickRedPackState then 
        btnRedPack:setVisible(g_QuickRedPackState)
    end

    local btnRedPack2 = GetElement(self.m_root, "btnRedPack2_WndChat", WZUIButton)
    if btnRedPack2:isVisible() ~= g_QuickRedPackState2 then 
        btnRedPack2:setVisible(g_QuickRedPackState2)
    end
end

--@brief    设置发红包按钮是否可见
function WndChat:showGiveRedPackBtn(bShow)
    if self.m_root == nil then return end 

    local btnRedPack = GetElement(self.m_root, "btnGiveRedPack_WndChat", WZUIButton)
    btnRedPack:setVisible(bShow)
end


--@brief 	qq大厅适配
function WndChat:_initStaticText()
	local txtCancelRec = GetElement(self.m_root, "txtCancelRec_WndChat", WZUILabelTTF)
	local conRecordingArm = GetElement(self.m_root,"conRecordingArm_WndChat",WZUIContainer)
	local txtRecordTip = GetElement(conRecordingArm,"txtRecordTip_WndChat",WZUILabelTTF)
	local txtUnion = GetElement(self.m_root, "txtUnion_WndChat", WZUILabelTTF)
	local txtUnionSel = GetElement(self.m_root, "txtUnionSel_WndChat", WZUILabelTTF)

	if isChannelPC() then 
		txtCancelRec:setTextKey("")
		txtCancelRec:setText(LocalStrings.QQHALL_TEXT1[6])
		txtRecordTip:setTextKey("")
		txtRecordTip:setText(LocalStrings.QQHALL_TEXT1[7])
	end
	if txtUnion and txtUnionSel then 
		txtUnion:setText(LocalStrings.UNION_TEXT1[1])
		txtUnionSel:setText(LocalStrings.UNION_TEXT1[1])
	end
end

--@brief 	重置世界聊天框的大小、设置金喇叭消息置顶
function WndChat:_resetConSize(nIndex)
	local conGoldWorld = GetElement(self.m_root, "conGoldWorld_WndChat", WZUIContainer)
	WZLog("WndChat:_resetConSize", nIndex)
	if nIndex == 0 then 
	    if not conGoldWorld:isVisible() then 
	    	conGoldWorld:setVisible(true)
	    	local conWorldBk = GetElement(self.m_root, "conWorldBk_WndChat", WZUIContainer)
	    	conWorldBk:setAbsContentSize(GlobalMethod:CCSize(685, 186))
	    	conWorldBk:updateRelativeSize()
	    	local freelistconWorld = GetElement(self.m_root, "freelistconWorld_WndChat", WZUIFreeListContainer)
	    	freelistconWorld:setRelativeSize(GlobalMethod:CCSize(1, 0.68))
	    --	freelistconWorld:updateRelativeSize()
	    end
	elseif nIndex == 1 then 
		if conGoldWorld:isVisible() then 
	    	conGoldWorld:setVisible(false)
	    	local conWorldBk = GetElement(self.m_root, "conWorldBk_WndChat", WZUIContainer)
	    	conWorldBk:setAbsContentSize(GlobalMethod:CCSize(685, 66))
	    	conWorldBk:updateRelativeSize()
	    	local freelistconWorld = GetElement(self.m_root, "freelistconWorld_WndChat", WZUIFreeListContainer)
	    	freelistconWorld:setRelativeSize(GlobalMethod:CCSize(1, 0.93))
	    --	freelistconWorld:updateRelativeSize()
	    end
	end
end

-------------------------------------语言适配模块Begin----------------------------------------
--@brief	英文适配函数
--@return	无
--@note		备注
function WndChat:_adaptLanguage_en()
	local edtInputCur = GetElement(self.m_root,"edtInputCur_WndChat",WZUIEditBox)
	edtInputCur:setMaxLength(65)

	local edtInputWorld = GetElement(self.m_root,"edtInputWorld_WndChat",WZUIEditBox)
	edtInputWorld:setMaxLength(65)

	local edtPriInput = GetElement(self.m_root,"edtPriInput_WndChat",WZUIEditBox)
	edtPriInput:setMaxLength(65)
	GetElement(self.m_root,"txtPrii_WndChat",WZUILabelTTF):setScale(0.8)
end
function WndChat:_adaptLanguage_vn()
	local edtInputCur = GetElement(self.m_root,"edtInputCur_WndChat",WZUIEditBox)
	edtInputCur:setMaxLength(64)

	local edtInputWorld = GetElement(self.m_root,"edtInputWorld_WndChat",WZUIEditBox)
	edtInputWorld:setMaxLength(64)

	local edtPriInput = GetElement(self.m_root,"edtPriInput_WndChat",WZUIEditBox)
	edtPriInput:setMaxLength(64)
end

function WndChat:_adaptLanguage_pt(  )
	local edtInputCur = GetElement(self.m_root,"edtInputCur_WndChat",WZUIEditBox)
	edtInputCur:setMaxLength(64)

	local edtInputWorld = GetElement(self.m_root,"edtInputWorld_WndChat",WZUIEditBox)
	edtInputWorld:setMaxLength(64)

	local edtPriInput = GetElement(self.m_root,"edtPriInput_WndChat",WZUIEditBox)
	edtPriInput:setMaxLength(64)
	GetElement(self.m_root,"txtBoxPriSel_WndChat",WZUILabelTTF):setFontSize(22)

end

function WndChat:_adaptLanguage_es()
	local edtInputCur = GetElement(self.m_root,"edtInputCur_WndChat",WZUIEditBox)
	edtInputCur:setMaxLength(64)

	local edtInputWorld = GetElement(self.m_root,"edtInputWorld_WndChat",WZUIEditBox)
	edtInputWorld:setMaxLength(64)

	local edtPriInput = GetElement(self.m_root,"edtPriInput_WndChat",WZUIEditBox)
	edtPriInput:setMaxLength(64)
	
	GetElement(self.m_root,"txtPrii_WndChat",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheckCurSel_WndChat",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtBoxPriSel_WndChat",WZUILabelTTF):setFontSize(20)

	local txtBoxPri = GetElement(self.m_root,"txtBoxPri_WndChat",WZUILabelTTF)
	txtBoxPri:setScale(0.65)
	txtBoxPri:setDimensions(GlobalMethod:CCSize(140))
	local txtBoxPriSel = GetElement(self.m_root,"txtBoxPriSel_WndChat",WZUILabelTTF)
	txtBoxPriSel:setScale(0.65)
	txtBoxPriSel:setDimensions(GlobalMethod:CCSize(140))
end

function WndChat:_adaptLanguage_tr()
	local edtInputCur = GetElement(self.m_root,"edtInputCur_WndChat",WZUIEditBox)
	edtInputCur:setMaxLength(64)

	local edtInputWorld = GetElement(self.m_root,"edtInputWorld_WndChat",WZUIEditBox)
	edtInputWorld:setMaxLength(64)

	local edtPriInput = GetElement(self.m_root,"edtPriInput_WndChat",WZUIEditBox)
	edtPriInput:setMaxLength(64)

end

--适配iphoneX
function WndChat:_AdaptationIphoneX()
    -- body
    WZLog("WndChat:_AdaptationIphoneX")
    if IsIphoneX() then
		local conParentNode = GetElement(self.m_root,"conchatcontext_wndchant",WZUIContainer)
		conParentNode:setRelativePosition(GlobalMethod:ccp(0.0503333,0.002))
	end
end

-------------------------------------语言适配模块End----------------------------------------
