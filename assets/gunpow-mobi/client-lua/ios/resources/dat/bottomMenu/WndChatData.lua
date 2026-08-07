--WndChatData.lua
--@brief	WndChat的数据模块
--@date		2013/12/09
--@author	孙珊珊

WndChat = {
	--请不要在这里定义变量
	FACEIMASK =
    {
		[1]= "/01",
		[2]= "/02",
		[3]= "/03",
		[4]= "/04",
		[5]= "/05",
		[6]= "/06",
		[7]= "/07",
		[8]= "/08",
		[9]= "/09",
		[10]= "/10",
		[11]= "/11",
		[12]= "/12",
		[13]= "/13",
		[14]= "/14",
		[15]= "/15",
		[16]= "/16",
		[17]= "/17",
		[18]= "/18",
		[19]= "/19",
		[20]= "/20",
		[21]= "/21",
		[22]= "/22",
		[23]= "/23",
		[24]= "/24",
   },
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChat:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTimes = 0                   --控制发送信息时间
	self.m_nPrivateTimes = 0             --控制私聊发送间隔
	self.m_backFun = nil
	self.m_nOrder = 0                   --本界面的层值
	
	self.m_nIsCurrent = CHANNEL_WORLD    --保证不重复点切换checkbox
	self.m_nCount = 0                    --帧计数

	self.m_ptempname = nil               --被私聊的玩家名字
	self.m_nReciveId = 0               --被私聊的玩家ID
	self.m_nReciveLevel = nil              --被私聊的玩家等级
	self.m_nReceivePlayerSex = nil          --被私聊的玩家性别
	self.m_nReceivePlayerVipLevel = nil     --被私聊的玩家VIP等级
	self.m_nReceivePlayerHead  = nil        --被私聊的玩家头部ID
	self.m_nReceivePlayerFace = nil         --被私聊的玩家脸部ID
	self.m_nReceivePlayerHeadColor = nil    --被私聊的玩家头部颜色

	self.m_nRecordMaxLength = 60         --录音最长时间为60秒
	self.m_tColor = 
	{
		ccc3(93, 222, 254),
		ccc3(255, 227, 116),
		ccc3(99, 255, 95),
		ccc3(255, 89, 74),
		ccc3(198,130, 255)
	} --颜色表
	self.m_tVoiceType = {1,2,3,4,5}
	
	self.m_Define = {fontsize=22,margin=20,}
	
	self.m_nAnimationCount = 0          --刷屏动画计数
	self.m_nWorldTime = nil --记录上次世界聊天的时间
	self.m_nColorTime = nil --记录上次彩聊聊天的时间
	self.m_sText = nil      --保存当前输入框的聊天内容
	self.m_lTouchTime = nil
	self.m_lEndTouchTime = nil
	self.m_bRecording = false
	self.m_bRecordingChat= false
	self.m_nVoiceSecond = nil
	self.m_nTouchX = nil
	self.m_nTouchY = nil
	self.m_bSupportRecord = false
	self.m_nRecordLength = 0   --记录录音时长
	self.m_oCurPlayRecordCell = nil -- 正在进行播放语音信息的cell
	self.m_nCurPlayRecordId = nil  --正在播放的语音ID
	self.m_bCancelRecording = false  --记录是否正在取消录音
	self.m_nMaxEnterRoom = 3 
	self.m_nEnterRoomCount = 0
	self.m_nExitRoomCount = 0
	self.m_bAddWeclome = false
	self.m_nCurVolume = nil   --存放用户当前手机音量
	self.m_tAutoPlayerCurVoiceList = {}  --存放当前频道自动播放的语音列表
	self.m_tAutoPlayerGuildVoiceList = {}  --存放公会频道自动播放的语音列表
	self.m_tCurrentMsgList = {} 
	self.m_tGuildMsgList = {}
	self.m_tWorldMsgList = {}
	self.m_tPrivateMsgList = {}
	self.m_tSystemMsgList = {}  --存放小助手的聊天信息
	self.m_tTeamMsgList = {}
	self.m_tCopyMsgList = {}

    self.m_bShowFace = false
	self.m_tOldCurrentMsgList = {} 
	self.m_tOldGuildMsgList = {}
	self.m_tOldWorldMsgList = {}
	self.m_tOldPrivateMsgList = {}
	self.m_tOldTeamMsgList = {}
	self.m_tOldSystemList = {}
	self.m_tOldCopyMsgList = {}

    self.m_tRecentlyPlayerList = {}  --最近联系人列表

	self.m_tCacheMsg = {}
	self.m_nCurSecond = 0

	self.m_nCurShowTag = nil
	self.m_bFirstLoad = true
	self.m_tPriPlayerInfo = {}   --记录语音私聊的玩家ID与名字与频道
	self.m_tRecordFileId = {}  --记录正在翻译中的语音文件id
	self.m_tPlayerVoiceId = {} --记录播放过的语音id
	self.m_nWorldChannelOpenLevel = tonumber(CacheCenter:getGameParam().controlWorldChatLevel) or 7
	self.m_elementTranslate = nil --正在进行翻译的节点
	self.m_nLoadId = nil
	self.m_nCurBubbleId = 0
	self.m_tBubbleList = nil
	self.m_tBubbleSettingByPlayer = {} --保存玩家设置的冒泡背景
	self.m_tBuyBubbleData = nil 		--保存购买的气泡数据
	self.m_tBubbleElementList = nil 	--气泡列表
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChat:_unInit()
	self.nodeData = nil
	self.ntag = nil
	self.m_nWorldTime = nil
	self.m_nColorTime = nil
	self.m_sText = nil
	self.m_tBuyBubbleData = nil 
	self.m_tBubbleElementList = nil
end

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChat:createElement()
	local element = WZUISystem:getInstance():createElement("WndChat")
	assert(element, "WndChat create element failed!")
	self:_init()
	return element
end

--切换到登录界面时，把聊天节点释放掉
function WndChat:rootRelease()
	WZLog("WndChat:rootRelease")
	if self.m_root ~= nil then
		local retainCount = self.m_root:retainCount()
		if retainCount >=2 then
			self.m_root:release()
			self.m_root = nil
		end
	end
end

--@brief	成功接收到消息后的回调
--@param	channel : 频道（0世界，1当前，2公会，3队伍，4私聊，5系统，彩聊）
--@param	sendId : 信息发送人ID
--@param	sendName : 信息发送人名称
--@param	receiveId : 信息接收人ID
--@param	receiveName : 信息接收人名称
--@param	message : 聊天内容
--@param	time : MM-dd	 
--@param    vipLevel : 发送人vip等级
--@param    sendFaceId : 发送人脸道具id
--@param    sendHeadId : 发送人头道具id
--@param    sendSex : 发送人性别
--@param    headSul:头像，（有头像为1，没有头像为0）
--@param    serviceId:信息接收人所在服ID
function WndChat:getReceiveMessageOK(channel, sendId, sendName, receiveId, receiveName, message, rtime, vipLevel,sendFaceId,sendHeadId,sendSex,headScul,serviceId,headColor,sendLevel,chatType,bubbleId, playerTitle, playerPvpLevel)
    WZLog("WndChat:getReceiveMessageOK = ",channel,message,bubbleId)
    if channel == 4 and sendId <= 0 and chatType ~= 6 then
        WZLog("私聊的玩家已离线 = ",message)
        return
    end
    if sendId == GlobalGame.g_tPlayerInfo.nPlayerId or ((WBattleGlobal:getCurrent().m_tMakePairOk.selfId ~= nil) and (sendId== (0 - WBattleGlobal:getCurrent().m_tMakePairOk.selfId))) then
    	--GlobalGame.g_nPrivateNum = 0
    	WZLog("自己发的信息")
    else
    	if message == nil or message == "" then
			return
		end
		local bshow = true  --私聊中是否有屏蔽玩家不让私聊
		if channel == CHANNEL_WHISPER or channel == CHANNEL_CURRENT or channel == CHANNEL_WORLD or channel == CHANNEL_GUILD or channel == CHANNEL_COLORCHAT then
			BANCHAT = CacheCenter:getFriendBlacklist()
			if BANCHAT then
				for i,v in ipairs(BANCHAT) do
					if sendId == v.id then
					   bshow = false
					   break
					end
				end
			end
		end
		if not bshow then
			return
		end
		if chatType ~= 7 then
			message = self:_addSpaceStr(message)
		end
		
        local rrtime = self:_getSendTimeString(rtime)

		if chatType == 6 then  --GM小助手发的聊天信息
			if self.m_root == nil then return end
			if  #self.m_tSystemMsgList >= 30 then
				table.remove(self.m_tSystemMsgList,1)
			end
			local temp = {}
			temp.sendName = LocalStrings.ASSISTANT2
			temp.level = 99
			temp.tm = rrtime
			temp.sendID = 66666666
			temp.words = message
			temp.mainChannel = CHANNEL_WHISPER
			temp.ownSend = false
			temp.recvID = 66666666
			temp.bubbleId = bubbleId
			table.insert(self.m_tSystemMsgList,temp)
			self:_showRedPoint(channel,nil,chatType)
			if self.m_root then
				self:_addLatelyPriChatPlayer(0,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
			end
			return
		end
		
		if chatType == 7 then     
		    local msss = SplitStringWithSeparator(message,"&")     
		    local recordLen = tonumber(msss[2])
		    local fileId = msss[1]
		    local showText = msss[3]
		    if msss == nil or msss[1] == nil then return end
		    WZLog("收到语音消息 = ",showText)                                                                                                                
			self:_pushWords(channel, sendId, sendName, receiveId, receiveName,showText,rrtime, vipLevel,sendHeadId,sendFaceId,sendSex,headScul,serviceId,true,recordLen,fileId,false,headColor,sendLevel,rtime,bubbleId, playerTitle, playerPvpLevel)
		else
			self:showChatBubble(channel,sendId,message,bubbleId)
   		    self:_pushWords(channel, sendId, sendName, receiveId, receiveName, message, rrtime, vipLevel,sendHeadId,sendFaceId,sendSex,headScul,serviceId,nil,nil,nil,nil,headColor,sendLevel,rtime,bubbleId, playerTitle, playerPvpLevel)
		end
    end
end

--显示聊天冒泡在房间与战斗中才显示
function WndChat:showChatBubble(channel,sendId,message,bubbleId)
    WZLog("WndChat:showChatBubble", channel, sendId, message)
	if SceneRoom ~= nil and SceneRoom.m_root and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		SceneRoom:showChat(message,sendId,bubbleId)
	elseif SceneGuildWarRoom ~= nil and SceneGuildWarRoom.m_root and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		SceneGuildWarRoom:showChat(message,sendId,bubbleId)
	elseif SceneBattle ~= nil and SceneBattle.m_root and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		WBattleGlobal:battleTalk(sendId,message,bubbleId)
	elseif SceneBossRoom and SceneBossRoom.m_root and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		SceneBossRoom:showChat(message,sendId,bubbleId)
	elseif WndLeagueTeamDetail and WndLeagueTeamDetail.m_root and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		WndLeagueTeamDetail:showBubble(message,sendId,bubbleId)
	elseif SceneWorldTeamBossRoom and SceneWorldTeamBossRoom.m_root and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		SceneWorldTeamBossRoom:showChat(message,sendId,bubbleId)
	end
end

--@brief	关闭回调回调
function WndChat:setCloseBackFun(tCell,backFun)
	if tCell and backFun then
		self.m_backFun = {}
		table.insert(self.m_backFun,tCell)
		table.insert(self.m_backFun,backFun)
	end
end

--@brief  获取玩家头或者脸的形象ID 
function WndChat:getPlayerHeadAndFace()
	local head,face 
    local tEquip = CacheCenter:getEquipmentList()
    local sex = CacheCenter:getPlayerInfo().sex
	for i=1,#tEquip do  --获取玩家头像
		local nEquipId = tEquip[i]
		if type(nEquipId) == "table" then nEquipId = nEquipId.id end
		local tEquipData = GetItemLocalData(nEquipId)
		if tEquipData then
            local maintype = tEquipData.main_type
            local subtype = tEquipData.sub_type
            if maintype == 5 and subtype == 1 then --物品是否是脸谱
                face = nEquipId
            elseif maintype == 5 and subtype == 0 then -- 物品是否是头部 
                head = nEquipId
            end 
        end
	end
	if sex == 1 then
		head = head and head or 4906
		face = face and face or 4905
	else
		head = head and head or 4903
		face = face and face or 4902
	end
	return head ,face
end

function WndChat:showOldCacheMsg()
	WZLog("WndChat:showOldCacheMsg")
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

	
	for i,v in ipairs(self.m_tOldCurrentMsgList) do
	    self:showMsg(v,CHANNEL_CURRENT)
	end

	for i,v in ipairs(self.m_tOldWorldMsgList) do
		self:showMsg(v,CHANNEL_WORLD)
	end

	if self.m_nReciveId ~= nil then
		local tempId = self.m_nReciveId 
		local tempT = nil
		if tempId > 0 then
			for i,v in ipairs(self.m_tOldPrivateMsgList) do
				for j,k in ipairs(v) do
					if tempId == k.recvID and k.ownSend then
					    tempT = v
					    break
					elseif tempId == k.sendID and not k.ownSend then
					    tempT = v
					    break
					end
				end
				if tempT then
					break
				end
		    end
		    if tempT ~= nil then
		    	for i,v in ipairs(tempT) do
		    		self:showMsg(v,CHANNEL_WHISPER)
		    	end
		    end
		end
	end

	for i,v in ipairs(self.m_tOldGuildMsgList) do
		self:showMsg(v,CHANNEL_GUILD)
	end

	for i,v in ipairs(self.m_tOldTeamMsgList) do
		self:showMsg(v,CHANNEL_TEAM)
	end

	for i,v in ipairs(self.m_tOldCopyMsgList) do
		self:showMsg(v,CHANNEL_COPY)
	end

    if self.m_nReciveId <= 0 then
    	for i,v in ipairs(self.m_tOldSystemList) do
    		self:showMsg(v,CHANNEL_WHISPER)
	    end
	end
end

--@brief  显示当前频道缓存的聊天信息
function WndChat:showCacheMsg()
	for i,v in ipairs(self.m_tCurrentMsgList) do
		if #self.m_tOldCurrentMsgList >=30 then
			table.remove(self.m_tOldCurrentMsgList,1)
		end
		table.insert(self.m_tOldCurrentMsgList,v)
		local temp = v
		table.remove(self.m_tCurrentMsgList,i)
		self:showMsg(temp,CHANNEL_CURRENT)
		break
	end

	for i,v in ipairs(self.m_tWorldMsgList) do
		if #self.m_tOldWorldMsgList >=30 then
			table.remove(self.m_tOldWorldMsgList,1)
		end
		table.insert(self.m_tOldWorldMsgList,v)
		local temp = v
		table.remove(self.m_tWorldMsgList,i)
		self:showMsg(temp,CHANNEL_WORLD)
		break
	end
	local bExit = false
	local tempT = nil
	for i,v in ipairs(self.m_tPrivateMsgList) do  --私聊特殊处理，需要保存每个私聊的聊天列表
    	for j,k in ipairs(self.m_tOldPrivateMsgList) do
    		for m,n in ipairs(k) do
    			if v.sendID == n.sendID and not v.ownSend and not n.ownSend then
	    		    WZLog("1111")
	    		    bExit = true
	    		    tempT = k
	    		    break
		    	elseif v.recvID == n.recvID and v.ownSend and n.ownSend then
		    	    WZLog("2222")
		    	    bExit = true
		    		tempT = k
		    		break
		    	elseif v.recvID == n.sendID and v.ownSend and not n.ownSend then
		    	    WZLog("3333")
		    	    bExit = true
		    		tempT = k
		    		break
		    	elseif v.sendID == n.recvID and not v.ownSend and n.ownSend then
		    	    WZLog("4444")
		    	    bExit = true
		    		tempT = k
		    		break
		    	end
    		end
    		if tempT then
    			break
    		end
    	end
    	if not bExit then
	    	local temp = {}
	    	table.insert(temp,v)
	    	table.insert(self.m_tOldPrivateMsgList,temp)
	    else
	    	if #tempT >= 30 then --每个人最多显示最近三十条聊天信息
                table.remove(tempT,1)
            end
	    	table.insert(tempT,v)
	    end
	    local temp = v
	    table.remove(self.m_tPrivateMsgList,i)
	    if v.sendID == self.m_nReciveId then
	        self:showMsg(temp,CHANNEL_WHISPER)
	    end
		self:_addPriChatToLocal()
		break
	end

	for i,v in ipairs(self.m_tGuildMsgList) do
		if #self.m_tOldGuildMsgList >=30 then
			table.remove(self.m_tOldGuildMsgList,1)
		end
		table.insert(self.m_tOldGuildMsgList,v)
		local temp = v
		table.remove(self.m_tGuildMsgList,i)
		self:showMsg(temp,CHANNEL_GUILD)
		break
	end

	for i,v in ipairs(self.m_tTeamMsgList) do
		if #self.m_tOldTeamMsgList >=30 then
			table.remove(self.m_tOldTeamMsgList,1)
		end
		table.insert(self.m_tOldTeamMsgList,v)
		local temp = v
		table.remove(self.m_tTeamMsgList,i)
		self:showMsg(temp,CHANNEL_TEAM)
		break
	end

	for i,v in ipairs(self.m_tCopyMsgList) do
		if #self.m_tOldCopyMsgList >=30 then
			table.remove(self.m_tOldCopyMsgList,1)
		end
		table.insert(self.m_tOldCopyMsgList,v)
		local temp = v
		table.remove(self.m_tCopyMsgList,i)
		self:showMsg(temp,CHANNEL_COPY)
		break
	end

	for i,v in ipairs(self.m_tSystemMsgList) do
		if #self.m_tOldSystemList >=30 then
			table.remove(self.m_tOldSystemList,1)
		end
		table.insert(self.m_tOldSystemList,v)
		local temp = v
		table.remove(self.m_tSystemMsgList,i)
		if self.m_nReciveId ~= nil and self.m_nReciveId == 0 then
			self:showMsg(temp,CHANNEL_WHISPER)
		end
		break
	end
end



--@brief  录音时把音量调到最大
function WndChat:setMaxVolumn()
	AudioManager:setEffectsVolume(1)
end

--@brief  恢复到原来的音量大小
function WndChat:setResetVolumn()
	AudioManager:setEffectsVolume(self.m_nCurVolume)
end

--@brief  自动播放语音优先播放最先接收到的语音信息
function WndChat:autoPlayRecordVoice()
	local curVoiceChat = nil
	if #self.m_tAutoPlayerCurVoiceList >=1  then
		curVoiceChat = self.m_tAutoPlayerCurVoiceList[1][1]
	end

	local guildVoiceChat = nil
	if #self.m_tAutoPlayerGuildVoiceList >= 1 then
		guildVoiceChat = self.m_tAutoPlayerGuildVoiceList[1][1]
	end

	if curVoiceChat ~= nil and guildVoiceChat ~= nil then
		if curVoiceChat < guildVoiceChat then
		    return self.m_tAutoPlayerCurVoiceList[1][2]
	    else
		    return self.m_tAutoPlayerGuildVoiceList[1][2]
	    end
	end
	
	if curVoiceChat == nil and guildVoiceChat == nil then
		return nil
	end

	if curVoiceChat == nil then
		if #self.m_tAutoPlayerGuildVoiceList >= 1 then
			return self.m_tAutoPlayerGuildVoiceList[1][2]
		end
	end

	if guildVoiceChat == nil then
		if #self.m_tAutoPlayerCurVoiceList >=1 then
			return self.m_tAutoPlayerCurVoiceList[1][2]
		end
	end
	return nil
end

--@brief  删除换行符
--@param  msgContent:需要查找的字符串
function WndChat:removeLineFeed(msgContent)
	WZLog("WndChat:removeLineFeed")
    local index = string.find(msgContent,"\n",0)
    if index ~= nil and tonumber(index) > 0 then
    	msgContent = string.gsub(msgContent,"\n","")
    end
    return msgContent
end


--@brief  好友上线提示
--@param  friendsName:好友名字
function WndChat:showFriendsLoginTips(friendsName)
	WZLog("WndChat:showFriendsLoginTips")
	self:_pushWords(CHANNEL_SYSTEM,nil,LocalStrings.TIP, nil, nil,string.format(LocalStrings.FRIENG_ONLINE_TIP,friendsName),nil,0,nil,nil,nil,nil,nil,nil,nil)
end

--提供对外的发送聊天信息接口
--channel : 频道
--chatMsg : 聊天
--receiveId : 接收人名称
function WndChat:sendChat(channel,chatMsg,receivePlayerId,receivePlayerName,receivePlayerSex,receivePlayerLevel,receivePlayerVipLevel,receivePlayerHead,receivePlayerFace,receivePlayerHeadColor)
	WZLog("WndChat:sendChat")
	if WndChat.m_root == nil then return end
	if chatMsg==nil or chatMsg=="" then
		MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT) --请输入聊天内容！
		return
	end
	chatMsg = self:_addSpaceStr(chatMsg)
	if channel == CHANNEL_WHISPER then
		if receivePlayerId == nil or receivePlayerId=="" or receivePlayerId==LocalStrings.CHAT_MSG_ID then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_ID)--好友id请输入数字！
			return
		end

		ProtocolProcessorGlobal:send_CHAT_SendMessage(channel,0,chatMsg,receivePlayerId,self.m_nCurBubbleId)
		local playerInfo = CacheCenter:getPlayerInfo()
	    if playerInfo == nil then return end
	    local nSex = playerInfo.sex--玩家性别
	    local head,face = self:getPlayerHeadAndFace()
	    local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
	  
		local bCleanFreeList = false
		if self.m_nReciveId ~= receivePlayerId then
			bCleanFreeList = true
		end

	    if receivePlayerLevel == nil then
	    	return
	    end

	    if receivePlayerSex == nil then
	    	return
	    end

	    if receivePlayerVipLevel == nil then
	    	return
	    end

	    self.m_ptempname = receivePlayerName
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
		self:_setChoseFriendListBtnText(self.m_ptempname)
	    local curServerName ,curServerId = IPDhttpServer:getCurServerName()
        curServerId = tonumber(curServerId)
        if bCleanFreeList then
			local freelistconPrivate = GetElement(self.m_root,"freelistconPrivate_WndChat",WZUIFreeListContainer)
		    freelistconPrivate:removeAll()
		    self:showCurPriList()
		end

		local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
		self:_pushWords(CHANNEL_WHISPER,playerInfo.id,playerInfo.name,receivePlayerId,receivePlayerName,chatMsg, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level)
	
	end
end

local faceIndex =
{
    [1]= "wuyu",
    [2]= "yun",
    [3]= "Fennu",
    [4]= "daku",
    [5]= "haixiu",
    [6]= "dianzan",
    [7]= "budianzan",
    [8]= "kaixin",
    [9]= "Otu",
    [10]= "jingya",
    [11]= "Nanshou",
    [12]= "yiwen",
    [13]= "Daxiao",
    [14]= "bishi",
    [15]= "no",
    [16]= "yes",
    [17]= "xiangku",
    [18]= "xia",
    [19]= "shuijiao",
    [20]= "qin",
    [21]= "se",
    [22]= "touxiao",
    [23]= "baibai",
    [24]= "Koubi",
}

--显示当前私聊的玩家信息列表
function WndChat:showCurPriList()
	WZLog("WndChat:showCurPriList")
	if self.m_nReciveId <= 0 then
		if self.m_tOldSystemList and #self.m_tOldSystemList > 0 then
			for i,v in ipairs(self.m_tOldSystemList) do
		        self:showMsg(v,CHANNEL_WHISPER)
            end
		end
	else
		local tempT = nil
		for i,v in ipairs(self.m_tOldPrivateMsgList) do
			for j,k in ipairs(v) do
				if self.m_nReciveId == k.recvID and k.ownSend then
				    tempT = v
				    break
				elseif self.m_nReciveId == k.sendID and not k.ownSend then
				    tempT = v
				    break
				end
			end
			if tempT then
				break
			end
		end
		if tempT then
			for i,v in ipairs(tempT) do
				self:showMsg(v,CHANNEL_WHISPER)
			end
		end
	end
end

--@brief	创建表情控件
--@note
function WndChat:_createFaceBox()
	WZLog("WndChat:_createFaceBox")
	if self.m_bShowFace then
		return
	end
	local faceBox = GetElement(self.m_root,"conFaceBox2_WndChat")
	faceBox:removeAllChildrenWithCleanup(true)
	local startPos = { x = 0.095, y = 0.90}
	for row=1,4 do
		for column=1,6 do
			local button = WZUIButton:create()
			button:setUseAbsSize(true)
			button:setAbsContentSize(GlobalMethod:CCSize(66,66))

			button:setRelativePositionLuaTo(startPos.x+(column-1)*0.155 + 0.015,startPos.y-(row-1)*0.23 - 0.03)
			local index=(row-1)*6+column

            WZLog("WndChat:_createFaceBox",index,row,column,button:getRelativePosition().x,button:getRelativePosition().y)
			local icon = WZUIImage:create()
			icon:setUseOriginSize(true)
			icon:setFile("battle/face/common_icon_"..faceIndex[index]..".png")
			local con = WZUIContainer:create()
			button:setNormalElement(con)
			con:addChild(icon)

			con = WZUIContainer:create()
			icon = WZUIImage:create()
			icon:setUseOriginSize(true)
			icon:setFile("battle/face/common_icon_"..faceIndex[index]..".png")
			button:setSelectElement(con)
			con:addChild(icon)
            local icon2 = WZUIImage:create()
            icon2:setUseOriginSize(true)
            icon2:setFile("battle/face/common_icon_biaoqing_sel.png")
            con:addChild(icon2)

			button:setTag(index)
			button:setLuaDoneFunctionName("onSelFace")
			faceBox:addChild(button)
		end
	end
	self.m_bShowFace = true
end

function WndChat:sendChatByChannel(channel,sendTxt,otherInfo)
	-- body
	WZLog("WndChat:sendChatByChannel ")
	local playerInfo = CacheCenter:getPlayerInfo()
	local head,face = self:getPlayerHeadAndFace()
	local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
	local gameParam = CacheCenter:getGameParam()
	local nSex = playerInfo.sex--玩家性别
	local curServerName ,curServerId = IPDhttpServer:getCurServerName()
    curServerId = tonumber(curServerId)
	if channel==CHANNEL_COPY then
		if CacheCenter:getPlayerInfo().vipLevel < 1 then
    		local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, 1)
    	    MsgBoxManager:showConfirmCancelBox(sMsg, WndIntensifyStrengthen, WndIntensifyStrengthen.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
			return
		end
		
		if tonumber(gameParam.WorldOpenChatLevel) > playerInfo.level then
		    MsgBoxManager:showTipBox(string.format(LocalStrings.PLAYER_LEVEL_UNREACHED,gameParam.WorldOpenChatLevel))
	        return
		end
		local nLabaNum = CacheCenter:getPlayerItemCountById(115) 
		if nLabaNum < 1 then
			MsgBoxManager:showConfirmBox(LocalStrings.CHAT_NOCOLORLABA,self,self.clickColorSureBack)
		else
			if self.m_nTimes > 0 then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
			else
				local tempTxt = self:getMaxSubString(sendTxt,CHANNEL_COLORCHAT,false,playerInfo.name)
				WZLog("World = ",tempTxt)
				tempTxt = self:_addSpaceStr(tempTxt)
				self.m_nTimes = self.m_nTimes + 5
				local tempTxt2 = sendTxt .. "##~" .. otherInfo.roomId .. "||" .. otherInfo.mapId
				ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_COLORCHAT,0,tempTxt2, 0,self.m_nCurBubbleId)
				MsgBoxManager:showTipBox(LocalStrings.INVITATION_HAS_BEEN_SENT)
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
		        if _sendTime ~= nil then
		            tempTxt = self:CheckYellow(tempTxt)
		            self:_pushWords(channel,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level)
		            self:_resetEditInputMsg()
		        else
		            assert(_sendTime==nil,"_sendTime is nil")
		        end
			end
		end
	end
end

--@brief 	购买气泡成功
function WndChat:buyBubbleOk(itemId)
	-- body
	MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)

	--隐藏掉消耗
	self:_resetBubbleCostById(itemId)
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

--删除聊天信息cell(私聊、公会、当前、世界有语音信息)
function WndChat:_removeChatCell()
	local pToList = self.m_root:getChildElement("freelistconPrivate_WndChat")
	if pToList == nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	local pToListSize = pToList:size()
	if pToListSize >= self.PrivateWords.LIMIT then
	   local removeCount =pToListSize - self.PrivateWords.LIMIT
	   for i=1,removeCount do
	   	   local element = pToList:getAt(i-1)
	   	   element = WZUIContainer:luaTo(element)
	   	   pToList:removeAt(i-1)
	   end
	end

	pToList = self.m_root:getChildElement("freelistconGonghui_WndChat")
	if pToList == nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	pToListSize = pToList:size()
	if pToListSize >= self.GongHui.LIMIT then
	   local removeCount =pToListSize - self.GongHui.LIMIT
	   for i=1,removeCount do
	   	    local element = pToList:getAt(i-1)
		   	element = WZUIContainer:luaTo(element)
		   	self:removeAutoPlayVoiceCell(element)
	   	    pToList:removeAt(i-1)
	   end
	end

	pToList = self.m_root:getChildElement("freelistconCur_WndChat")
	if pToList == nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	pToListSize = pToList:size()
	if pToListSize >= self.Current.LIMIT then
	   local removeCount =pToListSize - self.Current.LIMIT
	   for i=1,removeCount do
	   	    local element = pToList:getAt(i-1)
		   	element = WZUIContainer:luaTo(element)
		   	self:removeAutoPlayVoiceCell(element)
	   	    pToList:removeAt(i-1)
	   end
	end

	pToList = self.m_root:getChildElement("freelistconTeam_WndChat")
	if pToList == nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	pToListSize = pToList:size()
	if pToListSize >= self.Current.LIMIT then
	   local removeCount =pToListSize - self.Current.LIMIT
	   for i=1,removeCount do
	   	    local element = pToList:getAt(i-1)
		   	element = WZUIContainer:luaTo(element)
		   	self:removeAutoPlayVoiceCell(element)
	   	    pToList:removeAt(i-1)
	   end
	end

	local pToList = self.m_root:getChildElement("freelistconWorld_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	pToListSize = pToList:size()
	if pToList:size() >= self.conWorld.LIMIT then
		local removeCount =pToListSize - self.conWorld.LIMIT
		for i=1,removeCount do
            local element = pToList:getAt(i-1)
            element = WZUIContainer:luaTo(element)
		    pToList:removeAt(i-1)
		end
    end
end

function WndChat:_addSpaceStr(str)
	WZLog("WndChat:_addSpaceStr = ",str)
	if str then
		local strLen = string.len(str)
		local indexx = string.find(str," ",strLen)
		if indexx ~= strLen then
			str = str .. " "
		end
	end
	return str
end

--删除与某个人的私聊缓存
function WndChat:removePriChatCallback(playerId)
	WZLog("WndChat:removePriChatCallback")
	if WndChat.m_oCurPlayRecordCell then
		self:stopPlayVoice()
	end
	local index = nil
	for i,v in ipairs(self.m_tRecentlyPlayerList) do
		if v.id == playerId then
			index = i
			break
		end
	end
	table.remove(self.m_tRecentlyPlayerList,index)
	if playerId ~= nil then
		local removeIndex = nil
		for i,v in ipairs(self.m_tOldPrivateMsgList) do  --删除与某个玩家的私聊信息缓存
			for j,k in ipairs(v) do
				if playerId == k.recvID and k.ownSend then
				    removeIndex = i
				    break
				elseif playerId == k.sendID and not k.ownSend then
				    removeIndex = i
				    break
				end
			end
			if removeIndex then
				break
			end
	    end
	    if removeIndex ~= nil then
	    	table.remove(self.m_tOldPrivateMsgList,removeIndex)
	    	self:_addPriChatToLocal()
	    end
	end
	local bCleanFreeList = false
	if playerId == self.m_nReciveId then
		bCleanFreeList = true
		if self.m_tRecentlyPlayerList[index] then
			self.m_nReciveId = self.m_tRecentlyPlayerList[index].id
		else
			self.m_nReciveId = self.m_tRecentlyPlayerList[index-1].id
		end
	end
	self:_showLatelyPriChatPlayerList()		
	if bCleanFreeList then
		local conchatcontext = GetElement(self.m_root,"conchatcontext_wndchant",WZUIContainer)
		local freelistconPrivate = GetElement(conchatcontext,"freelistconPrivate_WndChat",WZUIFreeListContainer)
		freelistconPrivate:removeAll()
		self:showCurPriList()
	end
end

--联系人列表超过20个人，列表里只保存20个人，要删除一个联系人
function WndChat:removeRecentContacts()
	WZLog("WndChat:removeRecentContacts")
	local count = #self.m_tRecentlyPlayerList
	if count >= 21 then --超过21个人要删除列表里最底部的联系人
		local playerInfo = self.m_tRecentlyPlayerList[21]
		local removePlayerId = nil
		if self.m_nReciveId == 0 then
			removePlayerId = self.m_tRecentlyPlayerList[21].id
			table.remove(self.m_tRecentlyPlayerList,21) 
		elseif playerInfo and playerInfo.id ~= self.m_nReciveId then 
			removePlayerId = self.m_tRecentlyPlayerList[21].id
			table.remove(self.m_tRecentlyPlayerList,21) --删除最底部的联系人的聊天记录
		else  --要删除的联系人刚好被玩家正在查看则删除第20个联系人
			removePlayerId = self.m_tRecentlyPlayerList[20].id
			table.remove(self.m_tRecentlyPlayerList,20) --删除最底部的联系人的聊天记录
		end

		if removePlayerId ~= nil then
			local removeIndex = nil
			for i,v in ipairs(self.m_tOldPrivateMsgList) do  --删除与某个玩家的私聊信息缓存
				for j,k in ipairs(v) do
					if removePlayerId == k.recvID and k.ownSend then
					    removeIndex = i
					    break
					elseif removePlayerId == k.sendID and not k.ownSend then
					    removeIndex = i
					    break
					end
				end
				if removeIndex then
					break
				end
		    end
		    if removeIndex ~= nil then
		    	table.remove(self.m_tOldPrivateMsgList,removeIndex)
		    end
		end
	end
end

--新增私聊频道的最近联系人
function WndChat:_addLatelyPriChatPlayer(playerId,playerLevel,playerName,playerVIPLevel,head,face,sex,headColor,rtime,isOwnSend,bSort,bRed,bSendOnlineStats)
	WZLog("WndChat:_addLatelyPriChatPlayer ",playerId,playerName,isOwnSend)
	if playerId == nil then
		return
	end
	local tTemp = CopyTable(self.m_tRecentlyPlayerList)
	local bInsert = true
	local tempIndex = nil
	if playerId == 0 then
		bInsert = false
		local temp = self.m_tRecentlyPlayerList[1]
		if temp and temp.id == 0 then
			tempIndex = 1
			self.m_tRecentlyPlayerList[1].bShowRed = bRed
		end
	else
		for i,v in ipairs(self.m_tRecentlyPlayerList) do
			if v.id == playerId  then
				tempIndex = i
				v.level = playerLevel
				v.name = playerName
				v.vipLevel = playerVIPLevel
				v.head = head
				v.face = face
				v.headColor = headColor
				v.bShowRed = bRed
				v.sendTime = rtime and rtime or os.time()
				bInsert = false
				break
			end
	    end
	    table.sort(self.m_tRecentlyPlayerList,function (a,b)
			if a.sendTime > b.sendTime then
			    return true
			end
			return false
		end)
	    if playerId == self.m_nReciveId then
	    	self.m_nReciveLevel = playerLevel
	    	self.m_ptempname = playerName
	    	self.m_nReceivePlayerVipLevel = playerVIPLevel
	    	self.m_nReceivePlayerHead = head
	    	self.m_nReceivePlayerFace = face
	    	self.m_nReceivePlayerHeadColor = headColor
	    end
	end
	local conPrii = GetElement(self.m_root,"conPrii_WndChat",WZUIContainer)
	local tabFriendList = GetElement(conPrii,"tabFriendList_WndChat",WZUITableContainer)
	local moveElement = tabFriendList:getMoveElement()
	local curPSx,curPSy = moveElement:getPosition()

	if bInsert then
		self:removeRecentContacts()
		local temp = {}
		temp.id = playerId
		temp.level = playerLevel
		temp.name = playerName
		temp.vipLevel = playerVIPLevel
		temp.head = head
		temp.face = face
		temp.sex = sex
		temp.headColor = headColor
		temp.bOnline = true
		temp.bShowRed = bRed
		temp.sendTime = rtime and rtime or os.time()
		table.insert(self.m_tRecentlyPlayerList,temp)
		table.sort(self.m_tRecentlyPlayerList,function (a,b)
			if a.sendTime > b.sendTime then
			    return true
			end
			return false
		end)
		if bSort == false then
			playerId = nil
		end
		self:_showLatelyPriChatPlayerList(playerId,bSendOnlineStats)			
	else 
		local bReset = false
		local tempIn = nil
		for i,v in ipairs(self.m_tRecentlyPlayerList) do
			if v.id ~= tTemp[i].id then
				bReset = true
				break
			end
			if v.id == playerId then
				tempIn = i
			end
		end
		if (isOwnSend and tempIn ~= tempIndex ) or bReset then
		    self:_showLatelyPriChatPlayerList(playerId,bSendOnlineStats)	
		else
			for i,v in ipairs(self.m_tRecentlyPlayerList) do
				local cellElement = tabFriendList:getCellElement(i-1)
				if cellElement then
		            cellElement = WZUIContainer:luaTo(cellElement:getChildByTag(i-1))
					local luaObjectIndex = cellElement:getLuaObjectIndex()
					if luaObjectIndex then
						luaObjectIndex:setBSelect(false)
					end
					if v.id == self.m_nReciveId then
						if luaObjectIndex then
						    luaObjectIndex:setBSelect(true)
						    luaObjectIndex:setRedPoint(false)
					    end
					    if tempIndex then
					    	if self.m_tRecentlyPlayerList[tempIndex].id == self.m_nReciveId then
					    		self.m_tRecentlyPlayerList[tempIndex].bShowRed = false
					    	end
					    end
					end
					if v.id == playerId then
						if v.id > 0 then
							luaObjectIndex:setData(v.id,v.name,v.sex,v.level,v.vipLevel,v.head,v.face,v.headColor,false)
						    luaObjectIndex:updateHead()
						end
						if not isOwnSend and playerId ~= self.m_nReciveId then
						    luaObjectIndex:setRedPoint(true)
						end
					end
				end
		    end
		end
	end
	if not isOwnSend and self.m_nReciveId ~= playerId then
		moveElement:setPosition(curPSx,curPSy)
	end
end


--更新私聊最近联系人的状态UI
--cellElement : 节点
function WndChat:_updateLatelyPriChatPlayerElement(tag)
	WZLog("WndChat:_updateLatelyPriChatPlayerElement ",tag)
	if tag then
		local conPrii = GetElement(self.m_root,"conPrii_WndChat",WZUIContainer)
	    local tabFriendList = GetElement(conPrii,"tabFriendList_WndChat",WZUITableContainer)
		local temp = tabFriendList:getCellElement(tag-1)
		if temp then
			temp = WZUIContainer:luaTo(temp:getChildByTag(tag-1))
			local info = self.m_tRecentlyPlayerList[tag]
			if info and temp then
				local luaObject = temp:getLuaObjectIndex()
				if luaObject then
					if info.bOnline == 1 then
					    luaObject:setOnlineStats(true)
					else
						luaObject:setOnlineStats(false)
					end
				end
			else
				WZLog("childNode is nil or  info is nil ")
			end
		end
	end
end

--更新最近联系人列表
function WndChat:_updateLatelyPriChatPlayerList(onLineStats)
	WZLog("WndChat:_updateLayelyPriChatPlayerList")
	if self.m_root == nil then return end
	if onLineStats then
		for i,v in ipairs(onLineStats) do
			for j,k in ipairs(self.m_tRecentlyPlayerList) do
				if v.playerId == k.id then
					k.bOnline = v.isOnLine
					self:_updateLatelyPriChatPlayerElement(j)
				end
			end
		end
	end
end

--显示最近联系人列表
function WndChat:_showLatelyPriChatPlayerList(playerId,bSendOnlineStats)
	WZLog("WndChat:_showLatelyPriChatPlayerList =",playerId)
	local conPrii = GetElement(self.m_root,"conPrii_WndChat",WZUIContainer)
	local tabFriendList = GetElement(conPrii,"tabFriendList_WndChat",WZUITableContainer)
	tabFriendList:cleanTable()
	local tempCount = #self.m_tRecentlyPlayerList
	local tempPlayerIdList = {}
	for i,v in ipairs(self.m_tRecentlyPlayerList) do
		local cellElement,cellTable = CellPrivateChatHead:createElement()
		cellElement:setTag(i-1)
		cellTable:setClickCallback(self,self.onClickFastPriChatCallback)
		cellTable:setClickRemoveCallback(self,self.removePriChatCallback)
		cellTable:setRedPoint(v.bShowRed)
		if  v.id == 0 then
			if self.m_nReciveId ==  v.id then
				self.m_ptempname = nil
				self:_setChoseFriendListBtnText(nil)
			    cellTable:setBSelect(true)
		    end
		    cellTable:setData(nil,nil,nil,nil,nil,nil,nil,nil,true)
		else
			table.insert(tempPlayerIdList,v.id)
			cellTable:setData(v.id,v.name,v.sex,v.level,v.vipLevel,v.head,v.face,v.headColor,false)
			if self.m_nReciveId ~= nil and v.id ==  self.m_nReciveId then
				self.m_nReciveId = v.id
				self.m_nReciveLevel = v.level
				self.m_nReceivePlayerSex = v.sex          
				self.m_nReceivePlayerVipLevel = v.vipLevel     
				self.m_nReceivePlayerHead  = v.head        
				self.m_nReceivePlayerFace = v.face         
				self.m_nReceivePlayerHeadColor = v.headColor
				self.m_ptempname = v.name
				cellTable:setBSelect(true)
				self:_setChoseFriendListBtnText(v.name)
			else
				if playerId ~= nil then
					if v.id == playerId then
						cellTable:setRedPoint(true)
				    end
				end
			end
			cellTable:setOnlineStats(v.bOnline)
		end
		tabFriendList:setCellElement(cellElement)
	end
	if (bSendOnlineStats or bSendOnlineStats == nil) and  #tempPlayerIdList > 0 then
	 	ProtocolProcessorAccount:send_PLAYER_CheckOnline(TableToVector(tempPlayerIdList,WZLuaVector_int_))
	end
end

--添加私聊缓存
function WndChat:_addPriChatCache(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,headScul,serviceId,headColor,senderLevel,rtime,bubbleId, playerTitle, playerPvpLevel)
	WZLog("WndChat:_addPriChatCache")
	CacheCenter:addPriChatCache(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,headScul,serviceId,headColor,senderLevel,rtime,bubbleId, playerTitle, playerPvpLevel)
end

--显示本地保存的私聊聊天信息
function WndChat:_showLocalChatCache()
	WZLog("WndChat:_showLocalChatCache")
	local strTemp = WZFileUtil:getStringFromFile("tempTemp.txt",false)
	if strTemp == nil or strTemp == "" then
		return
	end
	local plyaerId = CacheCenter:getPlayerInfo().id
	local tempT = Unserialize(strTemp)
	WZLog("tempT =",type(tempT))
	if tempT ~= nil and type(tempT) == "table" and  #tempT > 0 then
		local tempTPlayerId = {}
		for i,v in ipairs(tempT) do
		    local iMainChannel = v[1]
		    if iMainChannel == "" then
		    	return
		    end
		    iMainChannel = tonumber(iMainChannel)
		    local iSendID = v[2]
		    local sSendName = v[3]
		    local iRecvID = v[4]
		    local sRecvName = v[5]
		    local sMsgContent = v[6]
		    local tm = v[7]
		    local vipLevel = v[8]
		    local playerHead = v[9]
		    local playerFace = v[10]
		    local playerSex = v[11]
		    local headScul = v[12]
		    local serviceId = v[13]
		    local isOwnSend = v[14]
		    local headColor = v[15]
		    local senderlevel = v[16]
		    local recvLevel = v[17]
		    local sendTime = v[18]
		    if iSendID == nil or sSendName == nil or iRecvID == nil or sRecvName == nil or sMsgContent == nil or tm == nil or vipLevel == nil or playerHead == nil or playerFace == nil or playerSex == nil or headScul == nil or serviceId == nil or isOwnSend == nil or headColor == nil or senderlevel == nil or recvLevel == nil or sendTime == nil then
		       break
		    end
		    
		    sendTime = tonumber(sendTime)
		    playerHead = tonumber(playerHead)
		    playerFace = tonumber(playerFace)
		    playerSex = tonumber(playerSex)
		    serviceId = tonumber(serviceId)
		    recVipLevel = tonumber(recVipLevel)
		    if isOwnSend == "1" then
		        isOwnSend = true
		    else
		    	isOwnSend = false
		    end
		    headColor = tonumber(headColor)
		    iRecvID = tonumber(iRecvID)
		    iSendID = tonumber(iSendID)

		    local recVipLevel = nil
		    local recPlayerHead = nil
			local recPlayerFace = nil
			local recPlyaerSex = nil
			local recHeadColor = nil
			local bShow = false
			local bubbleId = nil
			local playerTitle = nil 
			local playerPvpLevel = nil 

		    if isOwnSend then
		        if plyaerId == iSendID then
			        recVipLevel = tonumber(v[19])
			        recPlayerHead = tonumber(v[20])
				    recPlayerFace = tonumber(v[21])
				    recPlyaerSex = tonumber(v[22])
				    recHeadColor = tonumber(v[23])
				    bubbleId = tonumber(v[24])
				    playerTitle = v[25]
				    playerPvpLevel = tonumber(v[26])
				    if recVipLevel == nil or recPlayerHead == nil or recPlayerFace == nil or recPlyaerSex == nil or recHeadColor == nil then
				        WZFileUtil:writeStringToFile("tempTemp.txt","",false)
				        break
				    end
				    table.insert(tempTPlayerId,iRecvID)

			        self:_addLatelyPriChatPlayer(iRecvID,recvLevel,sRecvName,recVipLevel,recPlayerHead,recPlayerFace,recPlyaerSex,recHeadColor,sendTime,true,false,false,false)
		            bShow = true
		        else
		        	WZFileUtil:writeStringToFile("tempTemp.txt","",false)
		        	return 
		        end
		    else
		    	bubbleId = tonumber(v[19])
		    	playerTitle = v[20]
				playerPvpLevel = tonumber(v[21])
		    	if iRecvID == plyaerId then
		    		if playerHead == nil or playerFace == nil or playerSex == nil or headColor == nil then
				        WZFileUtil:writeStringToFile("tempTemp.txt","",false)
				        break
				    end
		    		bShow = true
		    		 table.insert(tempTPlayerId,iSendID)
		    		self:_addLatelyPriChatPlayer(iSendID,senderlevel,sSendName,vipLevel,playerHead,playerFace,playerSex,headColor,sendTime,false,false,false,false)
		    	else
		    		WZFileUtil:writeStringToFile("tempTemp.txt","",false)
		    		return 
		    	end
		    end
		    
		    if bShow then
		    	local recvDataListNode = self:_createListNode(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,nil,nil,nil,headScul,serviceId,isOwnSend,headColor,senderlevel,recvLevel,sendTime,recVipLevel,recPlayerHead,recPlayerFace,recPlyaerSex,recHeadColor,bubbleId, playerTitle, playerPvpLevel)	 --创建一条信息表
		        self:addMsgToOldList(recvDataListNode)
		    end
	    end

	    if #tempTPlayerId > 0  then
	    	ProtocolProcessorAccount:send_PLAYER_CheckOnline(TableToVector(tempTPlayerId,WZLuaVector_int_))
	    end

	else
		WZFileUtil:writeStringToFile("tempTemp.txt","",false)
	end
end

--把私聊信息保存到本地
function WndChat:_addPriChatToLocal()
	WZLog("WndChat:_addPriChatToLocal")
	local mainChannel = nil
	local sendID = nil
	local sendName = nil
	local recvID = nil
	local recvName = nil
	local msgContent = nil
	local tm = nil
	local vipLevel = nil
	local playerHead = nil
	local playerFace = nil
	local playerSex = nil
	local headScul = nil
	local serviceId = nil
	local isOwnSend = nil
	local headColor = nil
	local senderLevel = nil
	local recvLevel = nil
	local sendTime = nil
	local bubbleId = nil   
	local playerTitle = nil 
	local playerPvpLevel = nil         
	local tempS = ""
	local tempPPS = {}
	for i,v in ipairs(self.m_tOldPrivateMsgList) do
		for j,k in ipairs(v) do
			local bIsBoy = k.sex ~= 1 and true or false
			if bIsBoy == true then
			    if k.head == nil then k.head =  4903 end
			    if k.face == nil then k.face =  4902 end
			else
			    if k.head == nil then k.head =  4906 end
			    if k.face == nil then k.face = 4905 end
			end

			mainChannel = k.mainChannel
			if mainChannel == nil then
				break
			end
			local recordMsg = k.recordMsg
			if recordMsg == nil or not recordMsg then --语音聊天不添加到本地缓存
				sendID = k.sendID
				sendName = k.sendName
				recvID = k.recvID
				recvName = k.recvName
				msgContent = k.words
				tm = k.tm
				vipLevel = k.vipLevel
				playerHead = k.head
				playerFace = k.face
				playerSex = k.sex
				headScul = k.playerPhoto
				serviceId = k.serviceId
				isOwnSend = k.ownSend
				headColor = k.headColor
				senderLevel = k.senderlevel
				recvLevel = k.recvLevel
				sendTime = k.sendTime
				bubbleId = k.bubbleId
				playerTitle = k.playerTitle
				playerPvpLevel = k.playerPvpLevel
				if recvLevel == nil then
					recvLevel = 0
				end
				if isOwnSend then
				    isOwnSend = "1"
				    local recPlayerVipLevel = k.recPlayerVipLevel
				    if recPlayerVipLevel == nil then
				    	break
				    end

				    local recPlayerHead = k.recPlayerHead
				    if recPlayerHead == nil then
				    	break
				    end
				    local recPlayerFace = k.recPlayerFace
				    if recPlayerFace == nil then
				    	break
				    end
				    local recPlayerSex = k.recPlayerSex
				    if recPlayerSex == nil then
				    	break
				    end
				    local recPlayerHeadColor = k.recPlayerHeadColor
				    if recPlayerHeadColor == nil then
				    	break
				    end
				    local tempPP = {}
				    table.insert(tempPP,mainChannel)
				    table.insert(tempPP,sendID)
				    table.insert(tempPP,sendName)
				    table.insert(tempPP,recvID)
				    table.insert(tempPP,recvName)
				    table.insert(tempPP,msgContent)
				    table.insert(tempPP,tm)
				    table.insert(tempPP,vipLevel)
				    table.insert(tempPP,playerHead)
				    table.insert(tempPP,playerFace)
				    table.insert(tempPP,playerSex)
				    table.insert(tempPP,headScul)
				    table.insert(tempPP,serviceId)
				    table.insert(tempPP,isOwnSend)
				    table.insert(tempPP,headColor)
				    table.insert(tempPP,senderLevel)
				    table.insert(tempPP,recvLevel)
				    table.insert(tempPP,sendTime)
				    table.insert(tempPP,recPlayerVipLevel)
				    table.insert(tempPP,recPlayerHead)
				    table.insert(tempPP,recPlayerFace)
				    table.insert(tempPP,recPlayerSex)
				    table.insert(tempPP,recPlayerHeadColor)
				    table.insert(tempPP,bubbleId)
				    table.insert(tempPP,playerTitle)
				    table.insert(tempPP,playerPvpLevel)
				    table.insert(tempPPS,tempPP)
				else
					isOwnSend = "0"
					local tempPP = {}
				    table.insert(tempPP,mainChannel)
				    table.insert(tempPP,sendID)
				    table.insert(tempPP,sendName)
				    table.insert(tempPP,recvID)
				    table.insert(tempPP,recvName)
				    table.insert(tempPP,msgContent)
				    table.insert(tempPP,tm)
				    table.insert(tempPP,vipLevel)
				    table.insert(tempPP,playerHead)
				    table.insert(tempPP,playerFace)
				    table.insert(tempPP,playerSex)
				    table.insert(tempPP,headScul)
				    table.insert(tempPP,serviceId)
				    table.insert(tempPP,isOwnSend)
				    table.insert(tempPP,headColor)
				    table.insert(tempPP,senderLevel)
				    table.insert(tempPP,recvLevel)
				    table.insert(tempPP,sendTime)
				    table.insert(tempPP,bubbleId)
				    table.insert(tempPP,playerTitle)
				    table.insert(tempPP,playerPvpLevel)
				    table.insert(tempPPS,tempPP)
				end
			end
		end
	end
	tempS = Serialize(tempPPS,nil,true)
	WZLog("tempS = ",tempS)
	if tempS == nil then
	    WZFileUtil:writeStringToFile("tempTemp.txt","",false)
	else
		WZFileUtil:writeStringToFile("tempTemp.txt",tempS,false)
	end
end

--初始化最近联系列表
function WndChat:_initLatelyContactList()
	WZLog("WndChat:_initLatelyContactLis")
    local priChatCache = CacheCenter:getChatCache() --聊天窗口没加载时收到聊天信息
	if #priChatCache > 0 then
		for i,v in ipairs(priChatCache) do
		    self:_pushWords(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8],v[9],v[10],v[11],v[12],v[13],nil,nil,nil,nil,v[14],v[15],v[16], nil, v[18], v[19])
	    end
	    CacheCenter:resetChatCache()
	end
end

function WndChat:_showRedPoint(iMainChannel,sSendName,chatType)
	WZLog("WndChat:_showRedPoint")
	--当窗口显示的时候 
	if (iMainChannel == CHANNEL_WHISPER or chatType == 6) and self.m_nIsCurrent ~= iMainChannel and iMainChannel ~= CHANNEL_SYSTEM and sSendName ~= LocalStrings.CHAT_SYSTEM then
	    --显示相应的红点提示
		local img4 = GetElement(self.m_root,"img4_WndChat",WZUIImage)
		if not img4:isVisible() then
			img4:setVisible(true)
		end
	end
	
	if self.m_root ~= nil and not self.m_root:isVisible() and iMainChannel == CHANNEL_WHISPER then
		CacheCenter:setRedState("btnChat", true)
		GlobalGame:getBtnRedPointEvent():dispatcher()
	end
end

function WndChat:_showCachePriList()
	WZLog("WndChat:_showCachePriList")
	if self.m_bFirstLoad then
		self.m_bFirstLoad = false
		local temp = {}
		temp.id = 0
		temp.level = 99
		temp.name = LocalStrings.ASSISTANT2
		temp.sendTime = 42949672967
		local bExit = false
		for i,v in ipairs(self.m_tRecentlyPlayerList) do
			if v.id == 0 then
				bExit = true
			end
		end
		if not bExit then
			table.insert(self.m_tRecentlyPlayerList,temp)
		end
		self:_showLocalChatCache()
		self:_initLatelyContactList()
	end
	self:_showLatelyPriChatPlayerList(nil)
end
function WndChat:getMaxSubString(sMsgContent,iMainChannel,bRecordChat,sSendName)
	if (ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "hk" ) and iMainChannel ~= 5 and not bRecordChat and sSendName ~= LocalStrings.CHAT_SYSTEM then
		local txtTemp = GetElement(self.m_root,"txtTempP_WndChat",WZUILabelTTF)
		txtTemp:setMaxLength(24)
		txtTemp:setText(sMsgContent)
		local childrens = txtTemp:getChildren()
		local tempStr = ""
		if childrens and childrens:count() > 0 then
		    for i=0,childrens:count()-1 do
		        tempStr = tolua.cast(childrens:objectAtIndex(i),"CCLabelTTF"):getString()
		    end
        end
		return tempStr
	else
		local txtTemp = GetElement(self.m_root,"txtTempP_WndChat",WZUILabelTTF)
		txtTemp:setMaxLength(64)
		txtTemp:setText(sMsgContent)
		local childrens = txtTemp:getChildren()
		local tempStr = ""
		if childrens and childrens:count() > 0 then
		    for i=0,childrens:count()-1 do
		        tempStr = tolua.cast(childrens:objectAtIndex(i),"CCLabelTTF"):getString()
		    end
        end
		return tempStr
	end
	return sMsgContent
end

--判断发送的内容是否能进行发送
function WndChat:bSend(sMsgContent,channel)
	WZLog("WndChat:bSend")
	if sMsgContent == nil or sMsgContent == "" then return end
	local freeTextTemp = nil
	local freeTextTemp2 = nil
	local maxWidth = 425
	local maxWidth2 = 430
	
	freeTextTemp = GetElement(self.m_root,"freeTextTemp_WndChat",WZUIFreeTextBox)
	freeTextTemp2 = GetElement(self.m_root,"freeTextTemp2_WndChat",WZUIFreeTextBox)

	local freeText = ToChangeFreeText(sMsgContent)
	freeTextTemp:setShowText(freeText)
	freeTextTemp2:setShowText(freeText)
	local freeTextTempSize = freeTextTemp:getContentSize()
	local freeTextTempSize2 = freeTextTemp2:getContentSize()

	freeTextTemp:setShowText("")
	freeTextTemp2:setShowText("")
	

	if freeTextTempSize2.width >= maxWidth2 and freeTextTempSize.height < 30 then
		
		return false
	end

	if freeTextTempSize.height <= 71 then
		return true
	end
	
	return false
end


--语音翻译回调
function WndChat:callbackTranslateByRecord(tMessage)
	WZLog("WndChat:callbackTranslateByRecord ")
	local fileId = tostring(tMessage.fileID)
	local recordId = fileId
	local txt = tMessage.txt  --翻译的结果
	if txt == nil or txt == "" then
		txt = "......"
	end
   
	local channel = nil
	local reciveId = 0
	local recordLen = 1
	local reciveName = ""
	for i,v in ipairs(self.m_tRecordFileId) do
		if v[1] == fileId then
			channel = v[2]
			reciveId = v[3]
			reciveName = v[4]
			recordLen = v[5]
		end
	end

	if fileId == nil or fileId == "" then
		WZLog("fildTag = nil")
		return
	end

	if channel == CHANNEL_COLORCHAT then
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(115) 
		if nColorLabaNum <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_NOCOLORLABA)
			return
		end
	elseif channel == CHANNEL_WORLD then
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(114) 
		if nColorLabaNum <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_NOLABA)
			return
		end
	end

	local content = txt
	if txt ~= "" then
		content = self:CheckYellow(txt)
	end

	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo == nil then return end
	local nSex = playerInfo.sex--玩家性别
    
	local head,face = self:getPlayerHeadAndFace()
	local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
    local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
    local curServerName ,curServerId = IPDhttpServer:getCurServerName()
    curServerId = tonumber(curServerId)
	local getElement = GetElement
	local sendText = fileId .. "&" .. recordLen .. "&".. txt
	local childNode = nil
	local parentFreeList = nil

	if channel == CHANNEL_WHISPER then --私聊图片类型tag
		reciveId = tonumber(reciveId)
        self:_pushWords(CHANNEL_WHISPER,playerInfo.id,playerInfo.name,reciveId,reciveName,content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level)
	elseif  channel == CHANNEL_COLORCHAT  then
 		self:_pushWords(CHANNEL_COLORCHAT,playerInfo.id,playerInfo.name, 0, "", content, _sendTime, playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level)
	    WndSuona:showSuonaWithSendNameAndMessage(CHANNEL_COLORCHAT,playerInfo.name,content,0,2)
	elseif channel == CHANNEL_WORLD then --世界图片类型tag
        self:_pushWords(CHANNEL_WORLD,playerInfo.id,playerInfo.name, 0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level)
	    WndSuona:showSuonaWithSendNameAndMessage(CHANNEL_WORLD,playerInfo.name,content,4,2)
	elseif channel == CHANNEL_CURRENT then --当前图片类型tag
        self:_pushWords(CHANNEL_CURRENT,playerInfo.id,playerInfo.name,0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level)
	elseif channel == CHANNEL_GUILD then --公会图片类型tag
        self:_pushWords(CHANNEL_GUILD,playerInfo.id,playerInfo.name,0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level)
	elseif channel == CHANNEL_TEAM then
        self:_pushWords(CHANNEL_TEAM,playerInfo.id,playerInfo.name, 0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level)
	end

	reciveId = tonumber(reciveId)
	WZLog("sendText = ",channel,sendText,reciveId)
	ProtocolProcessorGlobal:send_CHAT_SendMessage(channel,7,sendText,reciveId,self.m_nCurBubbleId)
end


function WndChat:_startVoiceRecording(tempT)
	WZLog("WndChat:_startVoiceRecording")
	local errorCode = WGCloudVoiceNotify:StartRecording(tempT)
	if errorCode then
    	errorCode = tonumber(errorCode)
    	if errorCode ~= nil and errorCode == 4102 then
    		MsgBoxManager:showTipBox(LocalStrings.VOICE_RECORDING_ERROR)
    		return false
    	end
    end
	return true
end

function WndChat:getMaxSubString(sMsgContent,iMainChannel,bRecordChat,sSendName)
	if ( ProjConfig.LANGUAGE == "cn" or ProjConfig.LANGUAGE == "hk" ) and iMainChannel ~= 5 and not bRecordChat and sSendName ~= LocalStrings.CHAT_SYSTEM then
		local txtTemp = GetElement(self.m_root,"txtTempP_WndChat",WZUILabelTTF)
		txtTemp:setMaxLength(24)
		txtTemp:setText(sMsgContent)
		local childrens = txtTemp:getChildren()
		local tempStr = ""
		if childrens and childrens:count() > 0 then
		    for i=0,childrens:count()-1 do
		        tempStr = tolua.cast(childrens:objectAtIndex(i),"CCLabelTTF"):getString()
		    end
        end
		return tempStr
	else
		local txtTemp = GetElement(self.m_root,"txtTempP_WndChat",WZUILabelTTF)
		txtTemp:setMaxLength(64)
		txtTemp:setText(sMsgContent)
		local childrens = txtTemp:getChildren()
		local tempStr = ""
		if childrens and childrens:count() > 0 then
		    for i=0,childrens:count()-1 do
		        tempStr = tolua.cast(childrens:objectAtIndex(i),"CCLabelTTF"):getString()
		    end
        end
		return tempStr
	end
	return sMsgContent
end

--判断发送的内容是否能进行发送
function WndChat:bSend(sMsgContent,channel)
	WZLog("WndChat:bSend")
	if sMsgContent == nil or sMsgContent == "" then return end
	local freeTextTemp = nil
	local freeTextTemp2 = nil
	local maxWidth = 490
	local maxWidth2 = 500
	if channel == CHANNEL_WHISPER then
		maxWidth = 390
		maxWidth2 = 400
		freeTextTemp = GetElement(self.m_root,"freeTextTempPri_WndChat",WZUIFreeTextBox)
		freeTextTemp2 = GetElement(self.m_root,"freeTextTemp4_WndChat",WZUIFreeTextBox)
	else
		freeTextTemp = GetElement(self.m_root,"freeTextTemp_WndChat",WZUIFreeTextBox)
		freeTextTemp2 = GetElement(self.m_root,"freeTextTemp3_WndChat",WZUIFreeTextBox)
	end
	local freeText = ToChangeFreeText(sMsgContent)
	freeTextTemp:setShowText(freeText)
	freeTextTemp2:setShowText(freeText)
	local freeTextTempSize = freeTextTemp:getContentSize()
	local freeTextTempSize2 = freeTextTemp2:getContentSize()

	freeTextTemp:setShowText("")
	freeTextTemp2:setShowText("")
	
	if freeTextTempSize2.width >= maxWidth2 and freeTextTempSize.height < 30 then
		return false
	end

	if freeTextTempSize.height <= 60 then
		return true
	end
	
	return false
end

function WndChat:_getCheckIndex(chatType)
	WZLog("WndChat:_getCheckIndex")
	if chatType == CHANNEL_WORLD or chatType == CHANNEL_COLORCHAT or chatType == CHANNEL_SYSTEM then
		return 1
	elseif chatType == CHANNEL_CURRENT then
		return 0
	elseif chatType == CHANNEL_TEAM then
		return 4
	elseif chatType == CHANNEL_GUILD then
		return 2
	elseif chatType == CHANNEL_WHISPER then
		return 3
	elseif chatType == CHANNEL_COPY then
		return 5
	end
end

--显示气泡列表
function WndChat:_setBubbleCell()
	-- body
	WZLog("WndChat:_setBubbleCell")
	local conchatcontext = GetElement(self.m_root,"conchatcontext_wndchant",WZUIContainer)
	local conBubbleBox = GetElement(conchatcontext,"conBubbleBox_WndChat",WZUIContainer)
	local tableBubbleList = GetElement(conBubbleBox,"tableBubbleList_WndChat",WZUITableContainer)
	tableBubbleList:cleanTable()
	local bubbleId = self.m_nCurBubbleId
	local bubbleList = self:_getBubbleList()
	local tempCount = #bubbleList
	self.m_tBubbleElementList = {}
	local playerInfo = CacheCenter:getPlayerInfo()

	for i=1,tempCount do
		local cellBubble = WZUIContainer:luaTo(CreateElement("CellBubble_WndChat"))
		cellBubble:setVisible(true)
		cellBubble:setTag(i-1)
		local imgBg = GetElement(cellBubble,"imgBg_CellBubble",WZUIImage)
		local imgSel = GetElement(cellBubble,"imgSel_CellBubble",WZUIImage)
		local imgOpenType = GetElement(cellBubble,"imgOpenType_CellBubble",WZUIImage)
		local imagName = ""
		if i == 1 then
			imagName = "ui/chat/chat_common_icon_siliao2.png"
		else
			imagName = "ui/chat/" .. bubbleList[i].animation_index_code ..".png"
		end
		imgBg:setFile(imagName)
		if bubbleList[i].id > 0 and  bubbleList[i].property[1][1] == -1 and playerInfo.vipLevel < bubbleList[i].property[1][2] then --VIP激活
			imgOpenType:setFile("ui/common/common_talk_qpvip.png")
			imgOpenType:setVisible(true)
		elseif bubbleList[i].id > 0 and bubbleList[i].property[1][1] == 0 then --使用气泡卡激活
			local nNum = CacheCenter:getPlayerItemCountById(bubbleList[i].id)
			if nNum <= 0 then
				imgOpenType:setFile("ui/common/common_talk_qphd.png")
				imgOpenType:setVisible(true)
			end
		end
		if bubbleList[i].id == bubbleId then
			imgSel:setVisible(true)
		end
		--消耗
		self:_showBubbleCost(cellBubble, bubbleList[i].id)

		tableBubbleList:setCellElement(cellBubble)
		table.insert(self.m_tBubbleElementList, cellBubble)
	end
end

function WndChat:_setPlayerBubbleId()
	-- body
	WZLog("WndChat:_setPlayerBubbleId")
	local bubbleId = self:getPlayerBubble()
	WZLog("bubbleId =",bubbleId)
	self.m_nCurBubbleId = bubbleId
end

function WndChat:_getBubbleList()
	-- body
	WZLog("WndChat:_getBubbleList")
	if self.m_tBubbleList ~= nil then return self.m_tBubbleList end
	self.m_tBubbleList = {}
	for k,v in pairs(GDatatab_item) do
		if v.main_type == 25 and v.sub_type == 1 then
			table.insert(self.m_tBubbleList,v)
		end
	end

	table.sort(self.m_tBubbleList,function (a,b)
		if a.id < b.id then
			return true
		end
		return false
	end)

	table.insert(self.m_tBubbleList,1,{id=0})
	return self.m_tBubbleList
end

--根据冒泡ID获取索引
function WndChat:_getIndexByBubbleId(bubbleId)
	-- body
	WZLog("WndChat:_getIndexByBubbleId ",bubbleId)
	for i,v in ipairs(self:_getBubbleList()) do
		if v.id == bubbleId then
			return i
		end
	end
	return 1
end

--@brief 	拒绝或同意拜师或收徒请求后，处理私聊信息
function WndChat:dealwithMsgAfterOperate()
	-- body
	WZLog("WndChat:dealwithMsgAfterOperate", Serialize(self.m_tOldPrivateMsgList), self.m_nReciveId)
	if self.m_tOldPrivateMsgList == nil then return end 
	local nTempId = g_nOperatePlayerId or self.m_nReciveId
	g_nOperatePlayerId = nil 
	
	if nTempId <= 0 then
		return 
	else
		local tempT = nil
		for i,v in ipairs(self.m_tOldPrivateMsgList) do
			for j,k in ipairs(v) do
				if nTempId == k.recvID and k.ownSend then
				    tempT = v
				    break
				elseif nTempId == k.sendID and not k.ownSend then
				    tempT = v
				    break
				end
			end
			if tempT then
				break
			end
		end
		if tempT then
			for i,v in ipairs(tempT) do
				local bMasterMessage = WhetherMasterMessage(v.mainChannel, v.words)
				if bMasterMessage then
					v.words = string.gsub(v.words, g_MasterMessage_Mark, "")
				end
			end
		end
	end

	self:_addPriChatToLocal()

	if self.m_root == nil then return end 
	local freelistconPrivate = GetElement(self.m_root,"freelistconPrivate_WndChat",WZUIFreeListContainer)
	freelistconPrivate:removeAll()
	self:showCurPriList()
end

--@brief 	消耗
function WndChat:_showBubbleCost(cellBubble, id)
	-- body
	local ftxtCost = GetElement(cellBubble, "ftxtCost_CellBubble", WZUIFreeTextBox)
	local basicData = GDatatab_item["id_" .. id]
	if ftxtCost and id > 0 then
		local nNum = CacheCenter:getPlayerItemCountById(id) 
		if basicData.property[1][1] > 0 and nNum <= 0 then
			ftxtCost:setVisible(true)
			local sFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T>]]
			local tCostData = GDatatab_item["id_" .. basicData.property[1][1]]
			if tCostData then
				ftxtCost:setShowText(string.format(sFormat, tCostData.icon, basicData.property[1][2]))
			end
		else
			ftxtCost:setVisible(false)
		end
	end
end

--@brief 	根据id获取气泡索引
function WndChat:_resetBubbleCostById(id)
	-- body
	local bubbleList = self:_getBubbleList()
	for i = 1, #bubbleList do
		if bubbleList[i].id > 0 and bubbleList[i].id == id then
			self:_showBubbleCost(self.m_tBubbleElementList[i], id)
			break 
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
