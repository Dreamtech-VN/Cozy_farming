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
		[25]= "/25",
		[26]= "/26",
		[27]= "/27",
		[28]= "/28",
		[29]= "/29",
		[30]= "/30",
		[31]= "/31",
		[32]= "/32",
		[33]= "/33",
		[34]= "/34",
		[35]= "/35",
		[36]= "/36",
		[37]= "/37",
		[38]= "/38",
		[39]= "/39",
		[50]= "/50",
   },
   FACEIMASK_INDEX = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,36,37,38,39,32,33,34,35,50},
   FACELIMIT = {[32] = {1, 7}, [33] = {1, 7}, [34] = {1, 7}, [35] = {1, 7}, [50] = {1, 10}}, 	--表情专属条件：{1->vip, 所需vip等级}
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
	self.m_tUnionMsgList = {}

    -- self.m_bShowFaceCellItem = {}
	self.m_tOldCurrentMsgList = {} 
	self.m_tOldGuildMsgList = {}
	self.m_tOldWorldMsgList = {}
	self.m_tOldPrivateMsgList = {}
	self.m_tOldTeamMsgList = {}
	self.m_tOldSystemList = {}
	self.m_tOldCopyMsgList = {}
	self.m_tOldUnionMsgList = {}

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
	self.m_tClickMsgData = nil 			--点击的聊天数据
	self.m_nMessageType = 0 			--0：普通和彩色喇叭；11：金色喇叭
	self.m_tWorldGoldMsgList = {}
	self.m_nGoldMsgIndex = 0 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChat:_unInit()
	-- self.m_bShowFaceCellItem = {}
	self.nodeData = nil
	self.ntag = nil
	self.m_nWorldTime = nil
	self.m_nColorTime = nil
	self.m_sText = nil
	self.m_tBuyBubbleData = nil 
	self.m_tBubbleElementList = nil
	self.m_tClickMsgData = nil 			--点击的聊天数据
	self.m_tFilterMessage = nil 
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
function WndChat:getReceiveMessageOK(channel, sendId, sendName, receiveId, receiveName, message, rtime, vipLevel,sendFaceId,sendHeadId,sendSex,headScul,
	serviceId,headColor,sendLevel,chatType,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, offlineMessage, headEffectId)
    WZLog("WndChat:getReceiveMessageOK = ",chatType,channel,offlineMessage)
    WZLog("聊天玩家的职业状态",Serialize(openStatus))
    if channel == 4 and sendId <= 0 and chatType ~= 6 then
        WZLog("私聊的玩家已离线 = ",message)
        return
    end
    if channel == CHANNEL_SHOOTARROW then 
    	WndShootArrow:putNewMessage(message)
    	return 
    end
    if (sendId == GlobalGame.g_tPlayerInfo.nPlayerId and (offlineMessage == nil or offlineMessage == 0) and chatType ~= 9 and chatType ~= 10) or ((WBattleGlobal:getCurrent().m_tMakePairOk.selfId ~= nil) and (sendId== (0 - WBattleGlobal:getCurrent().m_tMakePairOk.selfId))) then
    	--GlobalGame.g_nPrivateNum = 0
    	WZLog("自己发的信息")
    else
    	if message == nil or message == "" then
			return
		end
		local bshow = true  --私聊中是否有屏蔽玩家不让私聊
		if channel == CHANNEL_WHISPER or channel == CHANNEL_CURRENT or channel == CHANNEL_WORLD or channel == CHANNEL_GUILD or channel == CHANNEL_COLORCHAT or channel == CHANNEL_GOLD or channel == CHANNEL_UNION then
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
			if self.m_tFilterMessage == nil then 
				self.m_tFilterMessage = {}
			end
			if  #self.m_tSystemMsgList >= 30 then
				table.remove(self.m_tSystemMsgList,1)
			end
			--有可能出现本地保存的小助手消息与刷新的消息存在重叠，所以要过滤一次
			local str_msg = string.match(message,"{^ttyy##%d+##")
			local str_circle = string.match(message, g_FriendCircleMessage_Mark)

			local status,_index,_ = self:setAssiantSpecialChat(message)
			if str_msg or status then
				local index = 1
				if str_msg then
					index = string.match(str_msg,"%d+")
				elseif status then
					index = _index
				end
				index = tonumber(index)
				local config = GDatatab_assistant["id_"..index]
				if config and type(config.time) == "table" then
				else
					if index >= 44 and index <= 49 then --非常规操作
					else
						if self.m_tFilterMessage[rtime..index] and self.m_tFilterMessage[rtime..index] == true then
							WZTempLog("--------- 红点 。。。 --------------------")
							self:_showRedPoint(channel,nil,chatType)
							return
						end
					end
					self.m_tFilterMessage[rtime..index] = true
				end
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
		elseif chatType == 7 then     
		    local msss = SplitStringWithSeparator(message,"&")     
		    local recordLen = tonumber(msss[2])
		    local fileId = msss[1]
		    local showText = msss[3]
		    if msss == nil or msss[1] == nil then return end
		    WZLog("收到语音消息 = ",showText, fileId, recordLen)                                                                                                                
			self:_pushWords(channel, sendId, sendName, receiveId, receiveName,showText,rrtime, vipLevel,sendHeadId,sendFaceId,sendSex,headScul,serviceId,true,recordLen,fileId,false,headColor,sendLevel,rtime,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, nil, nil, headEffectId)
		else
			if offlineMessage == 1 then 
				local tab = {}
				tab.channel = channel
				tab.sendId = sendId
				tab.sendName = sendName
				tab.receiveId = receiveId
				tab.receiveName = receiveName
				tab.message = message
				tab.rrtime = rrtime
				tab.vipLevel = vipLevel
				tab.sendHeadId = sendHeadId
				tab.sendFaceId = sendFaceId
				tab.sendSex = sendSex
				tab.headScul = headScul
				tab.serviceId = serviceId
				tab.headColor = headColor
				tab.sendLevel = sendLevel
				tab.rtime = rtime
				tab.bubbleId = bubbleId
				tab.playerTitle = playerTitle
				tab.playerPvpLevel = playerPvpLevel
				tab.professionId = professionId
				tab.openStatus = openStatus
				tab.offlineMessage = offlineMessage
				tab.headEffectId = headEffectId
				table.insert(g_OfflineMessage,tab)
			else 
				if chatType ~= 9 and chatType ~= 10 then 
					self:showChatBubble(channel,sendId,message,bubbleId)
				end
   		    	self:_pushWords(channel, sendId, sendName, receiveId, receiveName, message, rrtime, vipLevel,sendHeadId,sendFaceId,sendSex,headScul,serviceId,nil,nil,nil,nil,headColor,sendLevel,rtime,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, offlineMessage, chatType, headEffectId)
			end
		end
    end
end

--显示聊天冒泡在房间与战斗中才显示
function WndChat:showChatBubble(channel,sendId,message,bubbleId)
    WZLog("WndChat:showChatBubble", channel, sendId, message)
    local newWords = shieldQQQunNum(message)
    if newWords then 
        message = newWords
    end
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
	elseif SceneCoupleHegemonyRoom and SceneCoupleHegemonyRoom.m_root and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		SceneCoupleHegemonyRoom:showChat(message,sendId,bubbleId)
	elseif WndDoubleTowerRoom and WndDoubleTowerRoom.m_root and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		WndDoubleTowerRoom:showChat(message,sendId,bubbleId)
	elseif WndSingleCopyInfo and WndSingleCopyInfo.m_root and WndSingleCopyInfo.m_bIslandRoom and (channel == CHANNEL_CURRENT or channel == CHANNEL_TEAM) then
		WndSingleCopyInfo:showChat(message,sendId,bubbleId)
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

	local freelistconUnion = self.m_root:getChildElement("freelistconUnion_WndChat")
	if freelistconUnion ~=nil then
		freelistconUnion = WZUIFreeListContainer:luaTo(freelistconUnion)
	    freelistconUnion:removeAll()
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

	for i,v in ipairs(self.m_tOldUnionMsgList) do
		self:showMsg(v,CHANNEL_UNION)
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

	for i,v in ipairs(self.m_tWorldGoldMsgList) do
		local temp = v
		table.remove(self.m_tWorldGoldMsgList,i)
		self:showMsg(temp,CHANNEL_GOLD)
		break
	end

	for i,v in ipairs(self.m_tUnionMsgList) do
		if #self.m_tOldUnionMsgList >=30 then
			table.remove(self.m_tOldUnionMsgList,1)
		end
		table.insert(self.m_tOldUnionMsgList,v)
		local temp = v
		table.remove(self.m_tUnionMsgList,i)
		self:showMsg(temp,CHANNEL_UNION)
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
	self:_pushWords(CHANNEL_SYSTEM,nil,LocalStrings.TIP, nil, nil,string.format(LocalStrings.FRIENG_ONLINE_TIP,friendsName),nil,0,nil,nil,nil,nil,nil,nil,nil, nil)
end

--提供对外的发送聊天信息接口
--channel : 频道
--chatMsg : 聊天
--receiveId : 接收人名称
function WndChat:sendChat(channel,chatMsg,receivePlayerId,receivePlayerName,receivePlayerSex,receivePlayerLevel,receivePlayerVipLevel,receivePlayerHead,
	receivePlayerFace,receivePlayerHeadColor, receivePlayerHeadEffectId)
	WZLog("WndChat:sendChat",
	Serialize(channel),
	Serialize(chatMsg),
	Serialize(receivePlayerId),
	Serialize(receivePlayerName),
	Serialize(receivePlayerSex),
	Serialize(receivePlayerLevel),
	Serialize(receivePlayerVipLevel),
	Serialize(receivePlayerHead),
	Serialize(receivePlayerFace),
	Serialize(receivePlayerHeadColor))
	--4	"*h~`4Z我是个好师傅，做我徒弟好不好！"	302	"跑龙套"	1	13	0	4211	4411	0	
	--4	"*h~`4Z我想收个徒弟，你愿意吗？"	62	"虞6杀无赦"	0	15	0	4903	4902	0
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
		saveChatStrangerId(receivePlayerId, chatMsg)
		ProtocolProcessorGlobal:send_CHAT_SendMessage(channel,0,chatMsg,receivePlayerId,self.m_nCurBubbleId)
		local playerInfo = CacheCenter:getPlayerInfo()
	    if playerInfo == nil then return end
	    local nSex = playerInfo.sex--玩家性别
	    local head,face = self:getPlayerHeadAndFace()
	    local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
	    local headEffectId = CacheCenter:getPlayerHeadEffectItemId()
	  
		local bCleanFreeList = false
		if self.m_nReciveId ~= receivePlayerId then
			bCleanFreeList = true
		end

	    if receivePlayerLevel == nil or receivePlayerSex == nil or receivePlayerVipLevel == nil then
	    	return
	    end

	    local showTitle = ""
	    if playerInfo.title and playerInfo.title ~= "" then
		    local bShowTitle = WhetherShowDesignation(playerInfo.title)
		    if bShowTitle then
		    	showTitle = playerInfo.title
		    end
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
		self.m_nReceivePlayerHeadEffectId = receivePlayerHeadEffectId
		self:_setChoseFriendListBtnText(self.m_ptempname)
	    local curServerName ,curServerId = IPDhttpServer:getCurServerName()
        curServerId = tonumber(curServerId)
        if bCleanFreeList then
			local freelistconPrivate = GetElement(self.m_root,"freelistconPrivate_WndChat",WZUIFreeListContainer)
		    freelistconPrivate:removeAll()
		    self:showCurPriList()
		end

		local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
		self:_pushWords(CHANNEL_WHISPER,playerInfo.id,playerInfo.name,receivePlayerId,receivePlayerName,chatMsg, _sendTime,playerInfo.vipLevel,head,face,
			nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, 
			playerInfo.professionId, nil, nil, nil, nil, headEffectId)
	
	end
end

--显示一条自己发的消息
--channel : 频道
--chatMsg : 聊天
function WndChat:sendOwnChatMsg(channel,chatMsg)
	if WndChat.m_root == nil then return end
	if chatMsg==nil or chatMsg=="" then
		return
	end
	chatMsg = self:_addSpaceStr(chatMsg)
	local playerInfo = CacheCenter:getPlayerInfo()
    if playerInfo == nil then return end
    local nSex = playerInfo.sex
    local head,face = self:getPlayerHeadAndFace()
    local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
    local headEffectId = CacheCenter:getPlayerHeadEffectItemId()

    local curServerName ,curServerId = IPDhttpServer:getCurServerName()
    curServerId = tonumber(curServerId)

    local showTitle = ""
    if playerInfo.title and playerInfo.title ~= "" then
	    local bShowTitle = WhetherShowDesignation(playerInfo.title)
	    if bShowTitle then
	    	showTitle = playerInfo.title
	    end
	end

	local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	self:_pushWords(channel,playerInfo.id,playerInfo.name,0,nil,chatMsg, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
end

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

function WndChat:_createFaceBox()
	WZLog("WndChat:_createFaceBox")
	local faceBox = GetElement(self.m_root,"conFaceBox2_WndChat")
	faceBox:removeAllChildrenWithCleanup(true)
	local freeFace_WndChat = GetElement(self.m_root,"freeFace_WndChat",WZUITableContainer)
	freeFace_WndChat:cleanTable()

	local faceCount = GetTableLen(self.FACEIMASK)
	for i=1, faceCount do
		local celElement,tCell = CellFaceItem:createElement()
		if celElement and tCell then
			celElement:setTag(i-1)
			freeFace_WndChat:setCellElement(celElement)
			tCell:setFaceMessage(self.FACEIMASK_INDEX[i])
			tCell:setItemClickFun(function(index)
				self:onSelFace(index)
			end)
		end
	end
	-- self.m_bShowFace = true
end

function WndChat:sendChatByChannel(channel,sendTxt,otherInfo)
	-- body
	WZLog("WndChat:sendChatByChannel ",channel,sendTxt)
	local playerInfo = CacheCenter:getPlayerInfo()
	local head,face = self:getPlayerHeadAndFace()
	local headColor,bodyColor = CacheCenter:getHeadAndBodyColor()
	local gameParam = CacheCenter:getGameParam()
	local nSex = playerInfo.sex--玩家性别
	local curServerName ,curServerId = IPDhttpServer:getCurServerName()
    curServerId = tonumber(curServerId)
    local headEffectId = CacheCenter:getPlayerHeadEffectItemId()

    local showTitle = ""
    if playerInfo.title and playerInfo.title ~= "" then
	    local bShowTitle = WhetherShowDesignation(playerInfo.title)
	    if bShowTitle then
	    	showTitle = playerInfo.title
	    end
	end

	if channel == CHANNEL_COPY then
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
				local tempStr, bHaveMask = self:CheckYellow(tempTxt)
				if HaveLimitFace(tempStr) then 
					return 
				end
			    -- if bHaveMask then 
			    -- 	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
			    -- 	return 
			    -- end
				WZLog("World = ",tempStr)
				tempTxt = self:_addSpaceStr(tempStr)
				self.m_nTimes = self.m_nTimes + 5
				local tempTxt2 = sendTxt .. "##~" .. otherInfo.roomId .. "||" .. otherInfo.mapId
				ProtocolProcessorGlobal:send_CHAT_SendMessage(CHANNEL_COLORCHAT,0,tempTxt2, 0,self.m_nCurBubbleId)
				MsgBoxManager:showTipBox(LocalStrings.INVITATION_HAS_BEEN_SENT)
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
		        if _sendTime ~= nil then
		        --    tempTxt = self:CheckYellow(tempTxt)
		            self:_pushWords(channel, playerInfo.id, playerInfo.name, 0, "", tempTxt, _sendTime, playerInfo.vipLevel, head, face, nSex, playerInfo.headScul, curServerId, nil, nil, nil, true, headColor, playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
		            self:_resetEditInputMsg()
		        else
		            assert(_sendTime==nil,"_sendTime is nil")
		        end
			end
		end
	elseif channel == CHANNEL_CURRENT then
		local content = sendTxt
		
		if content==nil or content=="" then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_MSG_CONTENT)
		else
			if self.m_nTimes > 0 then
				MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
			else
				local tempTxt = self:getMaxSubString(content,channel,false,playerInfo.name)
				local tempStr, bHaveMask = self:CheckYellow(tempTxt)
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
				ProtocolProcessorGlobal:send_CHAT_SendMessage(channel,0,tempTxt, 0, self.m_nCurBubbleId)
				local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	        	if _sendTime ~= nil then
	            --	tempTxt = self:CheckYellow(tempTxt)
	            	self:showChatBubble(channel,playerInfo.id,tempTxt,self.m_nCurBubbleId)
	            	self:_pushWords(channel, playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	            	self:_resetEditInputMsg()
	        	else
	            	assert(_sendTime==nil,"_sendTime is nil")
	        	end
			end              
		end
	elseif channel == CHANNEL_TEAM then
		local content = sendTxt
		if self.m_nTimes > 0 then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
		else
			local tempTxt = self:getMaxSubString(content,channel,false,playerInfo.name)
			local tempStr, bHaveMask = self:CheckYellow(tempTxt)
		    -- if bHaveMask then 
		    -- 	MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
		    -- 	return 
		    -- end
		    
		    tempTxt = self:_addSpaceStr(tempStr)
			self.m_nTimes = self.m_nTimes + 5
			WZLog("聊天系统当前信息发送内容：",tempTxt)
			ProtocolProcessorGlobal:send_CHAT_SendMessage(channel,0,tempTxt, 0,self.m_nCurBubbleId)
			local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
        	if _sendTime ~= nil then
            --	tempTxt = self:CheckYellow(tempTxt)
            	self:showChatBubble(channel,playerInfo.id,tempTxt,self.m_nCurBubbleId)
            	self:_pushWords(channel,playerInfo.id,playerInfo.name, 0, "", tempTxt, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,nil,nil,nil,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
            	self:_resetEditInputMsg()
        	else
            	assert(_sendTime==nil,"_sendTime is nil")
        	end
		end
	elseif channel == CHANNEL_WORLD then
		WZLog("分享显示的聊天信息",channel,sendTxt,otherInfo)
		if self.m_nTimes > 0 then
			MsgBoxManager:showTipBox(LocalStrings.CHAT_SENDMORE)
		else
			local tempTxt = self:getMaxSubString(sendTxt,CHANNEL_COLORCHAT,false,playerInfo.name)
			local tempStr, bHaveMask = self:CheckYellow(tempTxt)
			WZLog("World = ",tempStr)
			tempTxt = self:_addSpaceStr(tempStr)
			self.m_nTimes = self.m_nTimes + 5

			MsgBoxManager:showTipBox(LocalStrings.CAHT_SEND_CODE)
			local _sendTime = self:_getSendTimeString(nil) --获得当前发送时间
	        if _sendTime ~= nil then

	            self:_pushWords(channel, playerInfo.id, playerInfo.name, 0, "", tempTxt, _sendTime, playerInfo.vipLevel, head, face, nSex, playerInfo.headScul, curServerId, nil, nil, nil, true, headColor, playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	            self:_resetEditInputMsg()
	        else
	            assert(_sendTime==nil,"_sendTime is nil")
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

	pToList = self.m_root:getChildElement("freelistconWorld_WndChat")
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

    pToList = self.m_root:getChildElement("freelistconGold_WndChat")
	if pToList==nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	pToListSize = pToList:size()
	if pToList:size() >= self.goldWorld.LIMIT then
		local removeCount =pToListSize - self.goldWorld.LIMIT
		for i=1,removeCount do
            local element = pToList:getAt(i-1)
            element = WZUIContainer:luaTo(element)
		    pToList:removeAt(i-1)
		end
    end

    pToList = self.m_root:getChildElement("freelistconUnion_WndChat")
	if pToList == nil then return end
	pToList = WZUIFreeListContainer:luaTo(pToList)
	pToListSize = pToList:size()
	if pToListSize >= self.Union.LIMIT then
	   local removeCount =pToListSize - self.Union.LIMIT
	   for i=1,removeCount do
	   	    local element = pToList:getAt(i-1)
		   	element = WZUIContainer:luaTo(element)
		   	self:removeAutoPlayVoiceCell(element)
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
function WndChat:_addLatelyPriChatPlayer(playerId, playerLevel, playerName, playerVIPLevel, head, face, sex, headColor, rtime, isOwnSend, bSort, bRed, bSendOnlineStats, headEffectId)
	WZLog("WndChat:_addLatelyPriChatPlayer ",playerId,playerName,isOwnSend, headEffectId)
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
				v.headEffectId = headEffectId
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
	    	self.m_nReceivePlayerHeadEffectId = headEffectId
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
		temp.headEffectId = headEffectId
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
							luaObjectIndex:setData(v.id,v.name,v.sex,v.level,v.vipLevel,v.head,v.face,v.headColor,false, v.headEffectId)
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
--	WZLog("WndChat:_updateLatelyPriChatPlayerElement ",tag)
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
--	WZLog("WndChat:_updateLayelyPriChatPlayerList")
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
--	WZLog("WndChat:_showLatelyPriChatPlayerList =",playerId)
	local conPrii = GetElement(self.m_root,"conPrii_WndChat",WZUIContainer)
	local tabFriendList = GetElement(conPrii,"tabFriendList_WndChat",WZUITableContainer)
	tabFriendList:cleanTable()
	local tempCount = #self.m_tRecentlyPlayerList
	WZLog("WndChat:_showLatelyPriChatPlayerList", Serialize(self.m_tRecentlyPlayerList))
	local tempPlayerIdList = {}
	for i,v in ipairs(self.m_tRecentlyPlayerList) do
		local cellElement,cellTable = CellPrivateChatHead:createElement()
		cellElement:setTag(i-1)
		cellTable:setClickCallback(self,self.onClickFastPriChatCallback)
		cellTable:setClickRemoveCallback(self,self.removePriChatCallback)
		cellTable:setRedPoint(v.bShowRed)
		if v.id == 0 then
			if self.m_nReciveId ==  v.id then
				self.m_ptempname = nil
				self:_setChoseFriendListBtnText(nil)
			    cellTable:setBSelect(true)
		    end
		    cellTable:setData(nil,nil,nil,nil,nil,nil,nil,nil,true)
		else
			table.insert(tempPlayerIdList,v.id)
			cellTable:setData(v.id,v.name,v.sex,v.level,v.vipLevel,v.head,v.face,v.headColor,false, v.headEffectId)
			if self.m_nReciveId ~= nil and v.id ==  self.m_nReciveId then
				self.m_nReciveId = v.id
				self.m_nReciveLevel = v.level
				self.m_nReceivePlayerSex = v.sex          
				self.m_nReceivePlayerVipLevel = v.vipLevel     
				self.m_nReceivePlayerHead  = v.head        
				self.m_nReceivePlayerFace = v.face         
				self.m_nReceivePlayerHeadColor = v.headColor
				self.m_nReceivePlayerHeadEffectId = v.headEffectId
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
function WndChat:_addPriChatCache(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,headScul,serviceId,headColor,senderLevel,rtime,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, bRecordChat, nRecordT, messageId, headEffectId)
	WZLog("WndChat:_addPriChatCache")
	CacheCenter:addPriChatCache(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,headScul,serviceId,headColor,senderLevel,rtime,bubbleId, playerTitle, playerPvpLevel, professionId, openStatus, bRecordChat, nRecordT, messageId, headEffectId)--支持语音
end

--显示本地保存的私聊聊天信息
function WndChat:_showLocalChatCache()
	local strTemp = WZFileUtil:getStringFromFile("tempTemp.txt",false)
	WZLog("WndChat:_showLocalChatCache", strTemp)
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
			local headEffectId = nil 
			local receivePlayerHeadEffectId = nil 

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
				    headEffectId = v[27] and tonumber(v[27]) or 0
				    receivePlayerHeadEffectId = v[28] and tonumber(v[28]) or 0
				    if recVipLevel == nil or recPlayerHead == nil or recPlayerFace == nil or recPlyaerSex == nil or recHeadColor == nil then
				        WZFileUtil:writeStringToFile("tempTemp.txt","",false)
				        break
				    end
				    table.insert(tempTPlayerId,iRecvID)

			        self:_addLatelyPriChatPlayer(iRecvID,recvLevel,sRecvName,recVipLevel,recPlayerHead,recPlayerFace,recPlyaerSex,recHeadColor,sendTime,true,false,false,false, receivePlayerHeadEffectId)
		            bShow = true
		        else
		        	WZFileUtil:writeStringToFile("tempTemp.txt","",false)
		        	return 
		        end
		    else
		    	bubbleId = tonumber(v[19])
		    	playerTitle = v[20]
				playerPvpLevel = tonumber(v[21])
				headEffectId = v[22] and tonumber(v[22]) or 0
		    	if iRecvID == plyaerId then
		    		if playerHead == nil or playerFace == nil or playerSex == nil or headColor == nil then
				        WZFileUtil:writeStringToFile("tempTemp.txt","",false)
				        break
				    end
		    		bShow = true
		    		 table.insert(tempTPlayerId,iSendID)
		    		self:_addLatelyPriChatPlayer(iSendID,senderlevel,sSendName,vipLevel,playerHead,playerFace,playerSex,headColor,sendTime,false,false,false,false, headEffectId)
		    	else
		    		WZFileUtil:writeStringToFile("tempTemp.txt","",false)
		    		return 
		    	end
		    end
		    
		    if bShow then
		    	local recvDataListNode = self:_createListNode(iMainChannel, iSendID, sSendName, iRecvID, sRecvName, sMsgContent, tm, vipLevel,playerHead,playerFace,playerSex,nil,nil,nil,headScul,serviceId,isOwnSend,headColor,senderlevel,recvLevel,sendTime,recVipLevel,recPlayerHead,recPlayerFace,recPlyaerSex,recHeadColor,bubbleId, playerTitle, playerPvpLevel, nil, nil, nil, headEffectId)	 --创建一条信息表
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
--小助手针对特殊字符处理
function WndChat:setAssiantSpecialChat(words)
	local status,index, index_end = nil,1,1
	local str = {"*y~`2F","*y~`3F","*y~`4F","*y~`5F"}
	local id = {59,60,61,62}
	for i,v in ipairs(str) do
		local strSpecial, _end = string.find(words, v)
		if strSpecial then
			status = true
			index = id[i]
			index_end = _end
		end
	end
	return status,index,index_end
end
--小助手信息存到本地
function WndChat:saveAssiantToLacal(words,tm)
	local bubbleId = 0
	local mainChannel = 4
	local sendName = LocalStrings.ASSISTANT2

	local tempPPS = self:getAssantToLocal()
	local timeStruct = os.date("*t",tm)
	local timeStr = string.format("%02d:%02d",timeStruct.hour,timeStruct.min)

	if self.m_tFilterMessage == nil then 
		self.m_tFilterMessage = {}
	end
	local str_msg = string.match(words,"{^ttyy##%d+##")
	local strCircle = string.find(words, g_FriendCircleMessage_Mark)
	if self.m_tFilterMessage == nil then 
		self.m_tFilterMessage = {}
	end
	local strHonour, _ = string.find(words, g_HonourMessage_Mark)
	local status, _index,_ = self:setAssiantSpecialChat(words)
	if str_msg or status then
		local index = 1
		if str_msg then
			index = string.match(str_msg,"%d+")
		elseif status then
			index = _index
		end
		self.m_tFilterMessage[tm..index] = true
		--配置表存在的时候才保存
		local plyaerId = CacheCenter:getPlayerInfo().id
		local tempPP = {}
		tempPP.words = words
		tempPP.sendID = 66666666
		tempPP.recvID = 66666666 
		tempPP.tm = timeStr
		tempPP.bubbleId = bubbleId
		tempPP.mainChannel = mainChannel
		tempPP.sendName = sendName
		table.insert(tempPPS,tempPP)
		local tempS = Serialize(tempPPS,nil,true)
		WZFileUtil:writeStringToFile(string.format("assant_%s.txt",plyaerId),tempS,false)
	elseif strCircle then
		local plyaerId = CacheCenter:getPlayerInfo().id
		local tempPP = {}
		tempPP.words = words
		tempPP.sendID = 66666666
		tempPP.recvID = 66666666 
		tempPP.tm = timeStr
		tempPP.bubbleId = bubbleId
		tempPP.mainChannel = mainChannel
		tempPP.sendName = sendName
		table.insert(tempPPS,tempPP)
		local tempS = Serialize(tempPPS,nil,true)
		WZFileUtil:writeStringToFile(string.format("assant_%s.txt",plyaerId),tempS,false)
	elseif strHonour then
		local plyaerId = CacheCenter:getPlayerInfo().id
		local tempPP = {}
		tempPP.words = words
		tempPP.sendID = 66666666
		tempPP.recvID = 66666666 
		tempPP.tm = timeStr
		tempPP.bubbleId = bubbleId
		tempPP.mainChannel = mainChannel
		tempPP.sendName = sendName
		table.insert(tempPPS,tempPP)
		local tempS = Serialize(tempPPS,nil,true)
		WZFileUtil:writeStringToFile(string.format("assant_%s.txt",plyaerId),tempS,false)
	else
		local plyaerId = CacheCenter:getPlayerInfo().id
		local tempPP = {}
		tempPP.words = words
		tempPP.sendID = 66666666
		tempPP.recvID = 66666666 
		tempPP.tm = timeStr
		tempPP.bubbleId = bubbleId
		tempPP.mainChannel = mainChannel
		tempPP.sendName = sendName
		table.insert(tempPPS,tempPP)
		local tempS = Serialize(tempPPS,nil,true)
		WZFileUtil:writeStringToFile(string.format("assant_%s.txt",plyaerId),tempS,false)
	end
end
--小助手信息本地的读取
function WndChat:getAssantToLocal()
	local plyaerId = CacheCenter:getPlayerInfo().id
	local strTemp = WZFileUtil:getStringFromFile(string.format("assant_%s.txt",plyaerId),false)
	if strTemp == nil or strTemp == "" then
		return {}
	end
	strTemp = Unserialize(strTemp)
	return strTemp
end
--把私聊信息保存到本地
function WndChat:_addPriChatToLocal()
--	WZLog("WndChat:_addPriChatToLocal")
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
	local headEffectId = nil         
	local receivePlayerHeadEffectId = nil         
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
				headEffectId = k.headEffectId or 0
				receivePlayerHeadEffectId = k.receivePlayerHeadEffectId or 0

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
				    table.insert(tempPP,headEffectId)
				    table.insert(tempPP,receivePlayerHeadEffectId)
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
				    table.insert(tempPP,headEffectId)
				    table.insert(tempPPS,tempPP)
				end
			end
		end
	end
	tempS = Serialize(tempPPS,nil,true)
--	WZLog("tempS = ",tempS)
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
		    self:_pushWords(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8],v[9],v[10],v[11],v[12],v[13],nil,nil,nil,nil,v[14],v[15],v[16], nil, v[18], v[19], v[20], nil, nil, nil, v[22], v[23])
	    end
	    CacheCenter:resetChatCache()
	end
end

function WndChat:_showRedPoint(iMainChannel,sSendName,chatType)
	WZTempLog("WndChat:_showRedPoint")
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
			WZLog("WndChat:_showCachePriList", Serialize(temp))
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
	elseif channel == CHANNEL_GOLD then
		local nColorLabaNum = CacheCenter:getPlayerItemCountById(161057) 
		if nColorLabaNum <= 0 then
			local basicData = GDatatab_item["id_161057"]
			MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basicData.name))
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

	local showTitle = ""
    if playerInfo.title and playerInfo.title ~= "" then
	    local bShowTitle = WhetherShowDesignation(playerInfo.title)
	    if bShowTitle then
	    	showTitle = playerInfo.title
	    end
	end
	local headEffectId = CacheCenter:getPlayerHeadEffectItemId()

	if channel == CHANNEL_WHISPER then --私聊图片类型tag
		reciveId = tonumber(reciveId)
		saveChatStrangerId(reciveId, sendText)
        self:_pushWords(CHANNEL_WHISPER,playerInfo.id,playerInfo.name,reciveId,reciveName,content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	elseif  channel == CHANNEL_COLORCHAT  then
 		self:_pushWords(CHANNEL_COLORCHAT,playerInfo.id,playerInfo.name, 0, "", content, _sendTime, playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	    WndSuona:showSuonaWithSendNameAndMessage(CHANNEL_COLORCHAT,playerInfo.name,content,0,2)
	elseif channel == CHANNEL_WORLD then --世界图片类型tag
        self:_pushWords(CHANNEL_WORLD,playerInfo.id,playerInfo.name, 0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	    WndSuona:showSuonaWithSendNameAndMessage(CHANNEL_WORLD,playerInfo.name,content,4,2)
	elseif channel == CHANNEL_CURRENT then --当前图片类型tag
        self:_pushWords(CHANNEL_CURRENT,playerInfo.id,playerInfo.name,0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	elseif channel == CHANNEL_GUILD then --公会图片类型tag
        self:_pushWords(CHANNEL_GUILD,playerInfo.id,playerInfo.name,0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	elseif channel == CHANNEL_TEAM then
        self:_pushWords(CHANNEL_TEAM,playerInfo.id,playerInfo.name, 0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
    elseif channel == CHANNEL_GOLD then --世界图片类型tag
        self:_pushWords(CHANNEL_GOLD,playerInfo.id,playerInfo.name, 0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
	    WndSuona:showSuonaWithSendNameAndMessage(CHANNEL_GOLD,playerInfo.name,content,4,2)
	elseif channel == CHANNEL_UNION then --联盟聊天类型tag
        self:_pushWords(CHANNEL_UNION,playerInfo.id,playerInfo.name,0, "", content, _sendTime,playerInfo.vipLevel,head,face,nSex,playerInfo.headScul,curServerId,true,recordLen,recordId,true,headColor,playerInfo.level, nil, nil, showTitle, playerInfo.segmentLevel, playerInfo.professionId, nil, nil, nil, headEffectId)
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
		WZLog("WndChat:bSend 11")
		return false
	end

	if freeTextTempSize.height <= 71 then
		return true
	end
	
	WZLog("WndChat:bSend 22")
	return false
end

function WndChat:_getCheckIndex(chatType)
	WZLog("WndChat:_getCheckIndex")
	if chatType == CHANNEL_WORLD or chatType == CHANNEL_COLORCHAT or chatType == CHANNEL_SYSTEM or chatType == CHANNEL_GOLD then
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
	elseif chatType == CHANNEL_UNION then
		return 6
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
			local strBubble = SplitStringWithSeparator(bubbleList[i].animation_index_code,",")
			imagName = "ui/chat/" .. strBubble[1] ..".png"
		end
		imgBg:setFile(imagName)
		if bubbleList[i].id > 0 and  bubbleList[i].property[1][1] == -1 and playerInfo.vipLevel < bubbleList[i].property[1][2] then --VIP激活
			imgOpenType:setFile("ui/common/common_talk_qpvip.png")
			imgOpenType:setVisible(true)
		elseif bubbleList[i].id > 0 and bubbleList[i].property[1][1] == 0 then --福利卡专属
			-- local nNum = CacheCenter:getPlayerItemCountById(bubbleList[i].id)
			-- if nNum <= 0 then
			-- 	imgOpenType:setFile("ui/common/common_talk_qphd.png")
			-- 	imgOpenType:setVisible(true)
			-- end
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
	--WZLog("WndChat:_showBubbleCost", id)
	local ftxtCost = GetElement(cellBubble, "ftxtCost_CellBubble", WZUIFreeTextBox)
	local basicData = GDatatab_item["id_" .. id]
	--WZLog("WndChat:_showBubbleCost", Serialize(basicData))
	if ftxtCost and id > 0 then
		local nNum = CacheCenter:getPlayerItemCountById(id) 
		--WZLog("WndChat:_showBubbleCost nNum", nNum)
		if basicData.property[1][1] > 0 and nNum <= 0 then
			--购买
			ftxtCost:setVisible(true)
			local sFormat = [[<I Z="0.5">%s</I><T C="255,255,255" S="18" P="1" SC="79,60,48" SS="4" SE="1">%d</T>]]
			local tCostData = GDatatab_item["id_" .. basicData.property[1][1]]
			if tCostData then
				ftxtCost:setShowText(string.format(sFormat, tCostData.icon, basicData.property[1][2]))
			end
		elseif basicData.property[1][1] == 0 and nNum <= 0 then 
			--福利卡专属
			ftxtCost:setVisible(true)
			local sFormat = [[<T C="255,255,255" S="16" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
			ftxtCost:setShowText(string.format(sFormat, LocalStrings.BACKGROUND_VIP_TEXT3))
		elseif basicData.property[1][1] == -2 and nNum <= 0 then
			--活动专属 活动获得
			ftxtCost:setVisible(true)
			local sFormat = [[<T C="255,255,255" S="16" P="1" SC="79,60,48" SS="4" SE="1">%s</T>]]
			ftxtCost:setShowText(string.format(sFormat, basicData.channel))
		else
			ftxtCost:setVisible(false)
		end
	end
	if ProjConfig.LANGUAGE == "vn" then
		ftxtCost:setMaxWidth(200)
		ftxtCost:setScale(0.7)
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

--@brief 	判断是否符合使用条件
function WndChat:_canUseFace(index)
	-- body
	local canUse = true 
	if self.FACELIMIT[index] then 
		if self.FACELIMIT[index][1] == 1 then
			local myVipLevel = CacheCenter:getPlayerInfo().vipLevel
			if myVipLevel < self.FACELIMIT[index][2] then 
				canUse = false 
			end
		end
	end

	return canUse
end

--注册玩家信息回调
function WndChat:updatePlayerInfoData()
    if self.m_root then self:_setBlockStrangerBox() end
end

function WndChat:_NumberToBits(n, nCount)
    local tBits = {}

    while n >= 0 and #tBits < nCount do
        table.insert(tBits, math.fmod(n, 2))
        n = math.floor(n/2)
    end

    return tBits
end

-- 设置屏蔽陌生人框
function WndChat:_setBlockStrangerBox()
	local nBtnCount = 2
	local chatShield = CacheCenter:getPlayerInfo().chatShield
	local tBits = self:_NumberToBits(chatShield, nBtnCount)
	for i=1,nBtnCount do
		local checkBlockStranger = GetElement(self.m_root, "checkBlockStranger"..i.."_WndChat", WZUICheckBox)
		checkBlockStranger:setCheckIndex(tBits[i] or 0)
	end
end


--********************* 表情包 *************************
CellFaceItem = {}
function CellFaceItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFaceItem:_unInit()
	self.m_root = nil
	self.m_sSelFaceFunc = nil 
	self.m_nFaceIndex = nil 
end

--@brief	创建控件
function CellFaceItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(66,66))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellFaceItem:setFaceMessage(index)
	self.m_nFaceIndex = index
end
--@brief 	开始加载
function CellFaceItem:onLoadData(element)
	self:setFaceDataItem()
end

function CellFaceItem:setFaceDataItem()
	if not self.m_root then return end

	local button = WZUIButton:create()
	button:setUseAbsSize(true)
	button:setAbsContentSize(GlobalMethod:CCSize(66,66))
	button:setLuaDoneFunctionName("onCellFace")
	self.m_root:addChild(button)

	local ftxtCost = WZUIFreeTextBox:create()
	ftxtCost:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	local str1 = "face"..self.m_nFaceIndex*10
	local scale = 0.5
	if self.m_nFaceIndex == 50 then
		scale = 0.35
	end

	local bExist = WZFileUtil:isFileExist(string.format("chat/%s.xml",str1))
	if bExist == true then
		local str2 = string.format("chat/%s.xml",str1)
		local str3 = string.format("chat/%s.plist",str1)
		ftxtCost:setShowText(string.format([[<AR A="%s" AF="%s" AP="%s" II="0"  Z="%s" ></AR>]],str1,str2,str3,scale))
		button:addChild(ftxtCost)
	end

	if WndChat.FACELIMIT[self.m_nFaceIndex] then 
		if WndChat.FACELIMIT[self.m_nFaceIndex][1] == 1 then 
			local myVipLevel = CacheCenter:getPlayerInfo().vipLevel
			if myVipLevel < WndChat.FACELIMIT[self.m_nFaceIndex][2] then 
				local imgLock = createImage("ui/common/common_icon_suo6.png", GlobalMethod:ccp(1, 1), nil, true, GlobalMethod:ccp(1, 1))
				button:addChild(imgLock)
			else
				-- local vipString = string.format(LocalStrings.BACKGROUND_ONLYFOR_VIP, WndChat.FACELIMIT[self.m_nFaceIndex][2])
				-- local txtVipLevel = createLabel(vipString, GlobalMethod:ccp(0.5, 0.8), GlobalMethod:ccp(0.5, 0.5), 18, GlobalMethod:ccc3(255,255,255))
				-- button:addChild(txtVipLevel)
			end
		end
	end
end

function CellFaceItem:setItemClickFun(func)
	self.m_sSelFaceFunc = func
end
function CellFaceItem:onCellFace()
	if not WndChat:_canUseFace(self.m_nFaceIndex) then
		if WndChat.FACELIMIT[self.m_nFaceIndex] and WndChat.FACELIMIT[self.m_nFaceIndex][1] == 1 then 
			MsgBoxManager:showTipBox(string.format(LocalStrings.VIP_FACE, WndChat.FACELIMIT[self.m_nFaceIndex][2]))
			return 
		end
	end
	if self.m_sSelFaceFunc then
		self.m_sSelFaceFunc(self.m_nFaceIndex)
	end
end
--@return	新建的表实例对象
function CellFaceItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
