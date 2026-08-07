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
end

local comCCPoint = ccp(0,0)
local comCCSize = CCSize(0,0)

--@brief  监听玩家数据更改
function WndChat:updatePlayerItemData()
	WZLog("WndChat:updatePlayerItemData")
	if self.m_nIsCurrent == CHANNEL_COLORCHAT then
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(115) 
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
    	--self:_setChoseFriendListBtnText(LocalStrings.CHAT_MSG_ID)--请选择好友
	end
	--self.m_ptempname = nil
	
	if self.m_nIsCurrent == CHANNEL_COLORCHAT then
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(115) 
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
    WZLog("WndChat:showChatWindowForFightingByOrder =",channelType)
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

	CacheCenter:setRedState("btnChat", false)
	GlobalGame:getBtnRedPointEvent():dispatcher()

	--Add By Tianxiang_Xu
	if txtContent then
		local conWorld = WZUIContainer:luaTo(self.m_root:getChildElement("conWorld_WndChat"))
		local edtInputWorld = WZUIEditBox:luaTo(conWorld:getChildElement("edtInputWorld_WndChat"))
		if not conWorld:isVisible() then
			return
		end
		if edtInputWorld ~= nil then
			edtInputWorld:setText(txtContent)
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
function WndChat:showChatWindowForPrivateWithIdAndName(receivePlayerId,receivePlayerName,receivePlayerSex,receivePlayerLevel,receivePlayerVipLevel,receivePlayerHead,receivePlayerFace,receivePlayerHeadColor)
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

    self.m_ptempname  = receivePlayerName
	self:showChatWindowForPrivate(receivePlayerName)

	self:_addLatelyPriChatPlayer(self.m_nReciveId,self.m_nReciveLevel,receivePlayerName,self.m_nReceivePlayerVipLevel,receivePlayerHead,receivePlayerFace,receivePlayerSex,receivePlayerHeadColor,nil,true)

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

------------------------------------关于界面点击事件----------------------------------------

--@brief	点击界面
--@param	点击界面关闭更新
function WndChat:onTouchBegin(element,pt) --点击界面，如想玩家姓名弹出玩家信息
	self.m_lTouchTime = os.time()
	self.m_nVoiceSecond = os.time()
	self.m_nTouchX = pt.x
	self.m_nTouchY = pt.y
	self:canRecording(pt)
	if not self.m_bRecording  then
		GetElement(self.m_root,"frameelement_WndChat",WZUIFrameElement):setTouchEnable(true)
	end
end

function WndChat:onEditBoxTouchBegin()
	WZLog("WndChat:onEditBoxTouchBegin")
	self:setFaceBoxNotVisible()
	self:setBubbleBoxNotVisible()
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
			if self.m_nIsCurrent ~= CHANNEL_WORLD and self.m_nIsCurrent ~= CHANNEL_COLORCHAT then
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
			if self.m_nIsCurrent ~= CHANNEL_WORLD and self.m_nIsCurrent ~= CHANNEL_COLORCHAT then
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
		           
				elseif not self.m_bRecording and ( self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT ) then
					local bSupprot = self:bSupportRecod()
		    		if not bSupprot then
		    			return
		    		end

	                if self.m_nIsCurrent == CHANNEL_WORLD then
		    			local nLabaNum = CacheCenter:getPlayerItemCountById(114) 
						if nLabaNum < 1 then
							MsgBoxManager:showConfirmBox(LocalStrings.CHAT_NOLABA,self,self.clickSureBack) --世界喇叭不足，请先购买该道具！
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
			GetElement(self.m_root,"txtVoiceControl_WndChat",WZUILabelTTF):setText(LocalStrings.LOOSEN_YOUR_FINGER_CANCEL)
		else
			GetElement(self.m_root,"txtVoiceControl2_WndChat",WZUILabelTTF):setText(LocalStrings.LOOSEN_YOUR_FINGER_CANCEL)
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
	txtRecordTip:setTextKey("NOT_RECORD_VOICE")

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
	self.m_nReceivePlayerHeadColor =friendInfo.headColor


	self:_addLatelyPriChatPlayer(self.m_nReciveId,self.m_nReciveLevel,self.m_ptempname,self.m_nReceivePlayerVipLevel,self.m_nReceivePlayerHead,self.m_nReceivePlayerFace,self.m_nReceivePlayerSex,self.m_nReceivePlayerHeadColor,nil,true)

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
	do return end 
	
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
	
	if self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT then
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

	if tag == 0 then
		tempT = self.m_tOldSystemList
		self.m_nReciveId = 0
		self.m_ptempname = nil
		local recentlyPlayerInfo = self.m_tRecentlyPlayerList[1]
		recentlyPlayerInfo.bShowRed = false
		self:_setChoseFriendListBtnText(nil)
		if tempT then
			for i,v in ipairs(tempT) do
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
		self:_setChoseFriendListBtnText(self.m_ptempname)

		self:showCurPriList()
	end
end


--@brief	发送信息
--@param	element:发送按钮
function WndChat:onclickSend(element)
    WZLog("WndChat:onclickSend")

    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.m_bIsUpdate = true
    local curServerName ,curServerId = IPDhttpServer:getCurServerName()
    curServerId = tonumber(curServerId)
   
	local edtInputCur,edtPriInput,edtWorld,conCur,conPri,conWorld = self:_getAllEidtBox()
	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo == nil then return end
	local nSex = playerInfo.sex--玩家性别
    
	local head,face = self:getPlayerHeadAndFace()
	local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()

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
		else
			WZLog("聊天系统私聊信息发送内容：=",self.m_nReciveId)
			if self.m_nPrivateTimes > 0 then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
				return
			end

			local tempTxt = self:getMaxSubString(content_pri,self.m_nIsCurrent,false,playerInfo.name)
		    tempTxt = self:_addSpaceStr(tempTxt)
			
			self.m_nPrivateTimes = self.m_nPrivateTimes + 2
			ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_WHISPER,0,tempTxt,self.m_nReciveId,self.m_nCurBubbleId)
			edtPriInput:setText("")
			local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
        	if _sendTime ~= nil then
        		tempTxt = self:CheckYellow(tempTxt)
        		WZLog("FFFFFFFFFFFFFFFFFFFFFFFFF", tempTxt)
            	self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, self.m_nReciveId, player_pri, tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level)
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
		else
			if self.m_nTimes > 0 then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
	            tempTxt = self:_addSpaceStr(tempTxt)

				self.m_nTimes = self.m_nTimes + 5
				WZLog("聊天系统彩聊信息发送内容：",tempTxt)
				ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_COLORCHAT,0,tempTxt, 0,self.m_nCurBubbleId)
				edtWorld:setText("")
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
    			if _sendTime ~= nil then
    	 			tempTxt = self:CheckYellow(tempTxt)
    	 			WndSuona:showSuonaWithSendNameAndMessage(self.m_nIsCurrent,playerInfo.name,tempTxt,0,2)
     				self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime, playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel)
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
			local nLabaNum = CacheCenter:getPlayerItemCountById(114) 
			
			if nLabaNum<1 then
				MsgBoxManager:showConfirmBox(LocalStrings.CHAT_NOLABA,self,self.clickSureBack) --世界喇叭不足，请先购买该道具！
			else
				if self.m_nTimes > 0 then
					MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
				else
					local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
					WZLog("World = ",tempTxt)
					tempTxt = self:_addSpaceStr(tempTxt)

					self.m_nTimes = self.m_nTimes + 5
					ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_WORLD,0,tempTxt, 0,self.m_nCurBubbleId)
					edtWorld:setText("")
					local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	                if _sendTime ~= nil then
	                    tempTxt = self:CheckYellow(tempTxt)
	                    WndSuona:showSuonaWithSendNameAndMessage(self.m_nIsCurrent,playerInfo.name,tempTxt,4,2)
	                    self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel)
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
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
			    tempTxt = self:_addSpaceStr(tempTxt)
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
				ProtocolProcessorGlobal:send_CHAT_SendMessage(self.m_nIsCurrent,0,tempTxt, 0,self.m_nCurBubbleId)
				edtInputCur:setText("")
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	        	if _sendTime ~= nil then
	            	tempTxt = self:CheckYellow(tempTxt)
	            	self:showChatBubble(self.m_nIsCurrent,playerInfo.id,tempTxt,self.m_nCurBubbleId)
	            	self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel)
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
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
			    tempTxt = self:_addSpaceStr(tempTxt)
				self.m_nTimes = self.m_nTimes + 5
				WZLog("聊天系统公会信息发送内容：",tempTxt,CacheCenter:getPlayerInfo().guildId )
				ProtocolProcessorGlobal:send_CHAT_SendMessage(self.m_nIsCurrent,0,tempTxt, 0,self.m_nCurBubbleId)
				edtInputCur:setText("")

            	local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
            	if _sendTime ~= nil then
                    tempTxt = self:CheckYellow(tempTxt)
                    self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel)
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
			else
				local tempTxt = self:getMaxSubString(content,self.m_nIsCurrent,false,playerInfo.name)
			    tempTxt = self:_addSpaceStr(tempTxt)
				self.m_nTimes = self.m_nTimes + 5
				WZLog("聊天系统当前信息发送内容：",tempTxt)
				ProtocolProcessorGlobal:send_CHAT_SendMessage(self.m_nIsCurrent,0,tempTxt, 0,self.m_nCurBubbleId)
				edtInputCur:setText("")
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	        	if _sendTime ~= nil then
	            	tempTxt = self:CheckYellow(tempTxt)
	            	self:showChatBubble(self.m_nIsCurrent,playerInfo.id,tempTxt,self.m_nCurBubbleId)
	            	self:_pushWords(self.m_nIsCurrent,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel)
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
	if  self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT then
		if self.m_nIsCurrent == CHANNEL_WORLD then
            self.m_nIsCurrent = CHANNEL_COLORCHAT
            self:_setChatType(CHANNEL_COLORCHAT)
        elseif self.m_nIsCurrent == CHANNEL_COLORCHAT then
            self.m_nIsCurrent = CHANNEL_WORLD
            self:_setChatType(CHANNEL_WORLD)
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
    elseif tag == 3 then
    	tag = CHANNEL_WHISPER
    elseif tag == 4 then
    	tag = CHANNEL_TEAM
    elseif tag == 5 then
    	tag = CHANNEL_COPY
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
end

--@brief  根据频道刷新freelist
--@param  channel:频道信息
function WndChat:freelistUpdate(channel)
	WZLog("WndChat:freelistUpdate")
	if channel == CHANNEL_WORLD or channel == CHANNEL_SYSTEM or channel == CHANNEL_COLORCHAT  then
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
end

--打开快速回复窗口
function WndChat:onClickOpenFastChat(element)
	WZLog("WndChat:onClickOpenFastChat")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local GetElement = GetElement
	GetElement(self.m_root,"conFastSendChat_WndChat",WZUIContainer):setVisible(false)
	local conFastChatList = GetElement(self.m_root,"conFastChatList_WndChat",WZUIContainer)
	conFastChatList:setVisible(true)

	local tabFastChatList = GetElement(conFastChatList,"tabFastChatList_WndChat",WZUITableContainer)
	tabFastChatList:cleanTable()
	for i=1,8 do
		local conFastChat = CreateElement("conFastChat_WndChat")
		conFastChat:setVisible(true)
		conFastChat = WZUIContainer:luaTo(conFastChat)
		conFastChat:setTag(i-1)
		tabFastChatList:setCellElement(conFastChat)
		local txtFastChat = GetElement(conFastChat,"txtFastChat_WndChat",WZUILabelTTF)
		local key = "FAST_CHAT_" .. i
		local txt = LocalStrings[key]
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" then
			--txtFastChat:setDimensions(GlobalMethod:CCSize(180,0))
			txtFastChat:setScale(0.7)
		elseif ProjConfig.LANGUAGE == "vn" then
			txtFastChat:setScale(0.8)
		elseif ProjConfig.LANGUAGE == "pt" then
			txtFastChat:setScale(0.6)
		end
		txtFastChat:setText(txt)
		if i == 8 then
			local conLine = GetElement(conFastChat,"conLine_WndChat",WZUIContainer)
			conLine:setVisible(false)
		end
	end
end

--关闭快速回复窗口
function WndChat:onClickCloseFastChat(element)
	WZLog("WndChat:onClickCloseFastChat")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local conFastChatList = GetElement(self.m_root,"conFastChatList_WndChat",WZUIContainer)
	conFastChatList:setVisible(false)

	local conFastSendChat = GetElement(self.m_root,"conFastSendChat_WndChat",WZUIContainer)
	conFastSendChat:setVisible(true)
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
		GetElement(self.m_root,"conFastChatList_WndChat",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conFastSendChat_WndChat",WZUIContainer):setVisible(true)
		self.m_nTimes = self.m_nTimes + 5
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

	self:onClickCloseBubble()
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
	elseif bubbleInfo.id > 0 and bubbleInfo.property[1][1] == 0 then --通过气泡卡使用
		local propertyInfo = bubbleInfo.channel
		local tempT = SplitStringWithSeparator(propertyInfo,",")
		local nNum = CacheCenter:getPlayerItemCountById(bubbleInfo.id) 
		if nNum <= 0 then --物品不足
			local itemId = tonumber(tempT[2])
			nNum = CacheCenter:getPlayerItemCountById(itemId) --是否有气泡卡
			if nNum <= 0 then --没有气泡卡弹出获取方式
				WndFastGetItems:show(itemId)
				return false
			else --有气泡卡则进行激活
				local itemInfo = GDatatab_item["id_" .. itemId]
				WndItemInfo:showInfo(element,WndChat.m_root,1,itemInfo,true,nil,true)
				return false
			end 
		end
	elseif bubbleInfo.id > 0 and bubbleInfo.property[1][1] > 0 then --需要购买的气泡
		local nNum = CacheCenter:getPlayerItemCountById(bubbleInfo.id) 
		if nNum <= 0 then
			local tData = CopyTable(bubbleInfo)
			tData.tBtnList = {LocalStrings.CANCEL, LocalStrings.BUY}
			WndItemInfo:showInfo(element, self.m_root, 1, tData, true, nil, true)
			WndItemInfo:setClickButtonCallback(self, self.buyBubble)
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
	
	checkboxPri = WZUICheckBox:luaTo(checkboxPri)
	checkboxGong = WZUICheckBox:luaTo(checkboxGong)
	checkboxWorld = WZUICheckBox:luaTo(checkboxWorld)
	checkboxCur = WZUICheckBox:luaTo(checkboxCur)
	checkboxTeam = WZUICheckBox:luaTo(checkboxTeam)
	
	checkboxPri:setCheckIndex(1)
	checkboxGong:setCheckIndex(0)
	checkboxWorld:setCheckIndex(0)
	checkboxCur:setCheckIndex(0)
	checkboxTeam:setCheckIndex(0)
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
function WndChat:onSelFace(sender)
	WZLog("WndChat:onSelFace = ",sender:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = sender:getTag()

	local fackMask = self.FACEIMASK[tag]
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

function WndChat:SetCheckBoxState(first,second,thrid,fourth,five)
	WZLog("WndChat:SetCheckBoxState(first,second,thrid,fourth")
	GetElement(self.m_root,"checkboxPri_WndChat",WZUICheckBox):setCheckIndex(first)
	GetElement(self.m_root,"checkboxGong_WndChat",WZUICheckBox):setCheckIndex(second)
	GetElement(self.m_root,"checkboxWorld_WndChat",WZUICheckBox):setCheckIndex(thrid)
	GetElement(self.m_root,"checkboxCur_WndChat",WZUICheckBox):setCheckIndex(fourth)
	GetElement(self.m_root,"checkboxTeam_WndChat",WZUICheckBox):setCheckIndex(five)
end

function WndChat:SetCheckBoxVisible()
	WZLog("WndChat:SetCheckBoxVisible")
	local nLevel = CacheCenter:getPlayerInfo().level 
	if nLevel < self.m_nWorldChannelOpenLevel then
		GetElement(self.m_root,"checkboxCur_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.109274,0.549971))
		GetElement(self.m_root,"checkboxTeam_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.305287,0.549971))
		GetElement(self.m_root,"checkboxWorld_WndChat",WZUICheckBox):setVisible(false)
		GetElement(self.m_root,"checkboxGong_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.500909,0.549971))
		GetElement(self.m_root,"checkboxPri_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.696513,0.549971))
		GetElement(self.m_root,"checkboxCopy_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.891901,0.549971))
		GetElement(self.m_root, "img4_WndChat", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.65,1.06437))
	else
		GetElement(self.m_root,"checkboxCur_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.109274,0.549971))
		GetElement(self.m_root,"checkboxWorld_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.305287,0.549971))
		GetElement(self.m_root,"checkboxWorld_WndChat",WZUICheckBox):setVisible(true)
		GetElement(self.m_root,"checkboxTeam_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.500909,0.549971))
		GetElement(self.m_root,"checkboxGong_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.696513,0.549971))
		GetElement(self.m_root,"checkboxPri_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.891901,0.549971))
		GetElement(self.m_root, "img4_WndChat", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.810902,1.06437))
		GetElement(self.m_root,"checkboxCopy_WndChat",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(1.0865,0.549971))
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
end

--设置除了透明背景外的容器 触摸 WindowManagement特殊处理
function WndChat:setConetextCon(bfalg)
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

	WndCurrentChat:wndCurChatVisible(true)
	self:_removeChatCell()
	--每次关闭聊天界面都需要清空当前频道自动播放列表
	self.m_tAutoPlayerCurVoiceList = {}  
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
	local conFastChatList = GetElement(conBottum,"conFastChatList_WndChat",WZUIContainer)

    if index == CHANNEL_WORLD or index == CHANNEL_COLORCHAT then
		GetElement(self.m_root,"conDivision_WndChat",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"freelistconSystem_WndChat",WZUIFreeListContainer):setVisible(true)
	else
		GetElement(self.m_root,"conDivision_WndChat",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"freelistconSystem_WndChat",WZUIFreeListContainer):setVisible(false)
	end
	conFastChatList:setVisible(false)
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

	local conFastSendChat = GetElement(conBottum,"conFastSendChat_WndChat",WZUIContainer)
	local imgWorldType = GetElement(conBottum,"imgWorldType_WndChat",WZUIImage)
	local txtChatPropsCount = GetElement(conBottum,"txtChatPropsCount_WndChat",WZUILabelTTF)
	
	if index == CHANNEL_TEAM then
		if SceneBattle.m_root ~= nil then
			conFastSendChat:setVisible(true)
		else
			conFastSendChat:setVisible(false)
		end
	else
		conFastSendChat:setVisible(false)
	end

	if index == CHANNEL_WORLD then
		imgWorldType:setFile("ui/chat/chat_common_icon_laba3.png")
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(114) 
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
		if index==CHANNEL_WORLD or index == CHANNEL_COLORCHAT then
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
		elseif index==CHANNEL_CURRENT or index==CHANNEL_GUILD or index == CHANNEL_TEAM then
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
		if index == CHANNEL_WORLD or index == CHANNEL_COLORCHAT then
			conWorlds:setVisible(true)
		elseif index == CHANNEL_CURRENT or index == CHANNEL_GUILD or index == CHANNEL_TEAM then
			conCur:setVisible(true)
		elseif index==CHANNEL_WHISPER then
			conPri:setVisible(true)
			conExpression:setVisible(true)
		end
	end
	--不让切换语音
	btnKeyboard:setVisible(true)
	btnVoice:setVisible(false)
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
	if self.m_nIsCurrent == CHANNEL_WORLD or self.m_nIsCurrent == CHANNEL_COLORCHAT then
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
	if playerId ~= 66666666 then
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
	WZLog("WndChat:_createWorldItem")
	--列表加载优
	if nodeData.sendID == nil or nodeData.sendID <= 0 then
	    WZLog("sendID = nil")
	    return
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
		-- if freeTextTempSize.height > 30 then
		-- 	local tempHeight2 = 110 + freeTextTempSize.height - 20
		-- 	WZLog("tempHeight2 = ",tempHeight2)
  --           tempPerchent = tempHeight2/ 445
		-- end
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

	GetElement(self.m_root,"conFastChatList_WndChat",WZUIContainer):setVisible(false)
end

function WndChat:onClickCloseBubble(element)
	-- body
	WZLog("WndChat:onClickCloseBubble")
	local conBubbleBox = GetElement(self.m_root,"conBubbleBox_WndChat",WZUIContainer)
	if not conBubbleBox:isVisible() then return end
	conBubbleBox:setVisible(false)

	GetElement(self.m_root,"conFastChatList_WndChat",WZUIContainer):setVisible(false)
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
    	if SceneRoom.m_root == nil and SceneBossRoom.m_root == nil and SceneBattle.m_root == nil and SceneBattleLoading.m_root == nil and GlobalGame.g_bIfInBattle == false and WndTeachOpenModule.m_root == nil and WndTeachTalk.m_root == nil and SceneKingMain.m_root == nil and not WndChat.m_bRecording and not SceneHall:getMatchState() and not WndStrengthen.m_root and not WndTowerScroll.m_root and not SceneWeddingChurch.m_root and not SceneLeagueRoom.m_root and not SceneAthMelee
.m_root and SceneMarryCopy.m_root == nil and SceneTabooBattle.m_root == nil and SceneGuildWarRoom.m_root == nil and WndLeagueTeamDetail.m_root == nil and SceneWorldTeamBossRoom.m_root == nil then
            ProtocolProcessorBossMap:send_BOSSMAPROOM_SelectRoom(roomId,"",mapId,5)   
            return
        else
        	MsgBoxManager:showTipBox(LocalStrings.WORLD_TEAM_IV_ERROR2)
        	return
        end
	end

	local edit = WndChat:_getCurEditBox()
	if edit then
		edit:setText(txt)
	end
end

--@brief	初始化队列
function WndChat:_initAllMsg()
	--私聊--公会--彩聊--当前--系统
	self.PrivateWords = {LIMIT= 30, count=0,}
	self.GongHui = {LIMIT= 30, count=0,}
	self.Current = {LIMIT= 30, count=0,}
	self.System = {LIMIT= 5, count=0,}
	self.conWorld = {LIMIT= 30, count=0,}
end

--@brief	创建一条信息表
--@param	iMainChannel等:服务器传过来的数据字段
function WndChat:_createListNode(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerhead,playerFace,playerSex,bRecordChat,nRecordT,messId,headScul,serviceId,isOwnSend,headColor,senderlevel,recLevel,sendTime,recPlayerVipLevel,recPlayerHead,recPlayerFace,recPlayerSex,recPlayerHeadColor,bubbleId, playerTitle, playerPvpLevel)
	local t = {}
    WZLog("创建一条信息表")
    --WZLog(iMainChannel.."|"..iSendID.."|"..sSendName.."|"..iRecvID.."|"..sRecvName.."|"..sMsgContent.."|"..tm.."|"..vipLevel)
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
	
	return t
end

--@brief	获取频道名字和id
--@param	channel:频道号
function WndChat:_getChannelTableAndName(channel)
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
	elseif  channel == CHANNEL_TEAM then
		n = LocalStrings.TEAM
	elseif channel == CHANNEL_COPY then
		n = LocalStrings.CHAT_COLORLIAOK
	else
		n = nil
	end
	return n
end

--@brief	接收到聊天信息进行显示
--@param	iMainChannel等:频道号等
function WndChat:_pushWords(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,headScul,serviceId,bRecordChat,nRecordT,messageId,isOwnSend,headColor,senderLevel,rtime,bubbleId, playerTitle, playerPvpLevel)
	WZLog("WndChat:_pushWordsb ",iMainChannel)
	if (sMsgContent == nil or sMsgContent == "" or string.len(sMsgContent) == 0) and not bRecordChat then
        WZLog("sMsgContent is nil")
		return
	end
	
	if (iMainChannel ~= CHANNEL_SYSTEM and sSendName ~= LocalStrings.CHAT_SYSTEM and iMainChannel ~= CHANNEL_COLORCHAT and iMainChannel ~= CHANNEL_COPY ) or ( iMainChannel == CHANNEL_SYSTEM and sSendName == LocalStrings.TIP) then
		if iMainChannel == CHANNEL_WHISPER then
			local sTempMsg = string.sub(sMsgContent, 1, 6)
			if sTempMsg == g_MasterMessage_Mark then
				local sCurrentMsg = string.gsub(sMsgContent, g_MasterMessage_Mark, "")
				WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sCurrentMsg, tm, vipLevel, bRecordChat)
			else
				WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel, bRecordChat)
			end
		else
			WndCurrentChat:getChatInfo(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel, bRecordChat)
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
		if iMainChannel == CHANNEL_WHISPER and (bRecordChat == nil or  bRecordChat == false) then
			CacheCenter:setRedState("btnChat", true)
		    GlobalGame:getBtnRedPointEvent():dispatcher()
			self:_addPriChatCache(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead, playerFace, playerSex, headScul, serviceId, headColor, senderLevel, rtime, bubbleId, playerTitle, playerPvpLevel)  
		end
		return 
	end

	if iMainChannel ~= 5 and not bRecordChat and sSendName ~= LocalStrings.CHAT_SYSTEM then
	    if not self:bSend(sMsgContent) then return end
	end

	if iMainChannel == CHANNEL_WHISPER then
		if not isOwnSend then
		    self:_addLatelyPriChatPlayer(iSendID,senderLevel,sSendName,vipLevel,playerHead,playerFace,playerSex,headColor,rtime,isOwnSend,true,true)
		else
			self:_addLatelyPriChatPlayer(self.m_nReciveId,self.m_nReciveLevel,self.m_ptempname,self.m_nReceivePlayerVipLevel,self.m_nReceivePlayerHead,self.m_nReceivePlayerFace,self.m_nReceivePlayerSex,self.m_nReceivePlayerHeadColor,rtime,true)
		end
	end

	local recvDataListNode = self:_createListNode(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,bRecordChat,nRecordT,messageId,headScul,serviceId,isOwnSend,headColor,senderLevel,self.m_nReciveLevel,rtime,self.m_nReceivePlayerVipLevel,self.m_nReceivePlayerHead,self.m_nReceivePlayerFace,self.m_nReceivePlayerSex,self.m_nReceivePlayerHeadColor,bubbleId, playerTitle, playerPvpLevel)	 --创建一条信息表
	recvDataListNode.mainChannelName = self:_getChannelTableAndName(iMainChannel) --获取频道的名字
	recvDataListNode.mainChannelName = recvDataListNode.mainChannelName or ""
	self:_showRedPoint(iMainChannel,sSendName)

	if recvDataListNode.mainChannel ~= CHANNEL_SYSTEM and recvDataListNode.sendName ~=LocalStrings.CHAT_SYSTEM and iSendID ~= GlobalGame.g_tPlayerInfo.nPlayerId then
		if  recvDataListNode.mainChannel == CHANNEL_WORLD or recvDataListNode.mainChannel == CHANNEL_COLORCHAT then
		    if #self.m_tWorldMsgList >= self.Current.LIMIT then
			    table.remove(self.m_tWorldMsgList,1)
		    end
		    table.insert(self.m_tWorldMsgList,recvDataListNode)
		elseif recvDataListNode.mainChannel == CHANNEL_GUILD then
			if #self.m_tGuildMsgList >= self.Current.LIMIT then
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
		end
		return
	end
	self:addMsgToOldList(recvDataListNode)
	self:showMsg(recvDataListNode,recvDataListNode.mainChannel)
	if recvDataListNode.mainChannel == CHANNEL_TEAM then --队伍聊天信息需要在当前频道显示
		self:showMsg(recvDataListNode,CHANNEL_CURRENT)
	end

	if recvDataListNode.mainChannel == CHANNEL_WHISPER and (bRecordChat == nil or  bRecordChat == false) then
		self:_addPriChatToLocal()
	end
end

function WndChat:addMsgToOldList(recvDataListNode)
	WZLog("WndChat:addMsgToOldList")
	if  recvDataListNode.mainChannel == CHANNEL_WORLD or recvDataListNode.mainChannel == CHANNEL_COLORCHAT then
	    if #self.m_tOldWorldMsgList >= self.Current.LIMIT then
		    table.remove(self.m_tOldWorldMsgList,1)
	    end
	    table.insert(self.m_tOldWorldMsgList,recvDataListNode)
	elseif recvDataListNode.mainChannel == CHANNEL_GUILD then
		if #self.m_tOldGuildMsgList >= self.Current.LIMIT then
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
	end
end

--@brief 显示聊天信息
--ntag : 标志 （0世界，1当前，2公会，3队伍，4私聊, 5系统, 6彩聊
function WndChat:showMsg(recvDataListNode,nTag)
	WZLog("WndChat:showMsg")
	self:_pushWordsToUI(recvDataListNode,nTag)
end

--@brief  获取世界频道容器
function WndChat:getFreelistWorld()
	WZLog("WndChat:getFreelistWorld")
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
	WZLog("WndChat:getFreelistCopy")
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

--@brief	在界面上显示一条信息
--@param	nodeData:一条信息
--@param    ntag : 标志 （0世界，1当前，2公会，3队伍，4私聊, 5系统, 6彩聊）  nodeData.InfaceTag:界面id
function WndChat:_pushWordsToUI(nodeData,ntag)
    WZLog("WndChat:_pushWordsToUI")
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
	
	if ntag == CHANNEL_WORLD or (ntag == CHANNEL_COLORCHAT and nodeData.sendName ~=LocalStrings.CHAT_SYSTEM ) then
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
	end
	if pToList ~= nil then
		self:_createWorldItem(pToList, nodeData,freelistPSY)
	end
end


function WndChat:_changeNColor(ttf,channel)
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
    table.insert(self.m_tRecordFileId,tempT)
    WGCloudVoiceNotify:SpeechToText(recordId)
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

--敏感词汇检查
function WndChat:CheckYellow(tstr)
	WZLog("WndChat:CheckYellow(tstr)")
	if ProjConfig.LANGUAGE == "tr" then
		return tstr
	end
	local yellowstr = tstr
	for k,v in ipairs(ChatKeyWords) do
		yellowstr = string.gsub(yellowstr,v,"xxx")
	end
    return yellowstr
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
