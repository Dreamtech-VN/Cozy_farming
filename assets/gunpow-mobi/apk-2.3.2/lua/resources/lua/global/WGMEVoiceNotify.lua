--WGMEVoiceNotify.lua
--@brief	语言实现类
--@date		2017/03/22
--@author	zhangming
--@note		语言实现类
--https://www.tencentcloud.com/zh/document/product/607/30260

WGMEVoiceNotify = {
	m_sFilePath = "",
	m_tVoiceMsg = {},
	m_bSupport = false,
	m_nMode = 1,
	m_sRoomName = "",
	m_sRoomId = 0,
    m_nJoinRoomScheduleId = 0,
    m_nPlayerId = 0,
    m_nMusicVolume = 0.8,
    m_nButtonState = nil,
    m_gmeId = "1400631953",
    m_gmeKey = "CE0Ys0thHchV3KK4",
}

WGME_ITMG_MAIN_EVENT_TYPE = {
    WGME_ITMG_MAIN_EVENT_TYPE_NONE = 0,

    --Notification of entering a room, triggered by EnterRoom API.
    WGME_ITMG_MAIN_EVENT_TYPE_ENTER_ROOM = 1,
    --Notification of exiting a room, triggered by ExitRoom API.
    WGME_ITMG_MAIN_EVENT_TYPE_EXIT_ROOM = 2,
    --Notification of room disconnection due to network or other reasons, which will trigger automatically.
    WGME_ITMG_MAIN_EVENT_TYPE_ROOM_DISCONNECT = 3,
    --Notification of the updates of room members, the notification contains detailed information, refer to ITMG_EVENT_ID_USER_UPDATE.
    WGME_ITMG_MAIN_EVNET_TYPE_USER_UPDATE = 4,

    WGME_ITMG_MAIN_EVENT_TYPE_NUMBER_OF_USERS_UPDATE = 7,-- number of users in current room
    WGME_ITMG_MAIN_EVENT_TYPE_NUMBER_OF_AUDIOSTREAMS_UPDATE = 8,-- number of audioStreams in current room
    --Notification of room reconnection happened, which indicates services will be temporarily unavailable.
    WGME_ITMG_MAIN_EVENT_TYPE_RECONNECT_START = 11,
    --Notification of room reconnection succeeded, which indicates services have recovered.
    WGME_ITMG_MAIN_EVENT_TYPE_RECONNECT_SUCCESS = 12,
	--Notification of switching a room, triggered by SwitchRoom API.
	WGME_ITMG_MAIN_EVENT_TYPE_SWITCH_ROOM = 13,
    --Notification of RoomType have been Changed by Other EndUser
    WGME_ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_TYPE = 21,

    WGME_ITMG_MAIN_EVENT_TYPE_AUDIO_DATA_EMPTY = 22,

    WGME_ITMG_MAIN_EVENT_TYPE_ROOM_SHARING_START = 23,
    WGME_ITMG_MAIN_EVENT_TYPE_ROOM_SHARING_STOP = 24,

	WGME_ITMG_MAIN_EVENT_TYPE_RECORD_COMPLETED = 30,
	WGME_ITMG_MAIN_EVENT_TYPE_RECORD_PREVIEW_COMPLETED = 31,
	WGME_ITMG_MAIN_EVENT_TYPE_RECORD_MIX_COMPLETED = 32,
    
    WGME_ITMG_MAIN_EVENT_TYPE_AUDIOROUTE_UPDATE = 33,
    
	--Notify user the default speaker device is changed in the PC, refresh the Speaker devices when you recv this event.
	WGME_ITMG_MAIN_EVENT_TYPE_SPEAKER_DEFAULT_DEVICE_CHANGED = 1008,
	--Notify user new Speaker device in the PC, refresh the Speaker devices when you recv this event.
	WGME_ITMG_MAIN_EVENT_TYPE_SPEAKER_NEW_DEVICE = 1009,
	--Notify user speaker device lost from the PC, refresh the Speaker devices when you recv this event.
	WGME_ITMG_MAIN_EVENT_TYPE_SPEAKER_LOST_DEVICE = 1010,
	--Notify user new mic device in the PC, refresh the Speaker devices when you recv this event.
	WGME_ITMG_MAIN_EVENT_TYPE_MIC_NEW_DEVICE = 1011,
	--Notify user mic device lost from the PC, refresh the Speaker devices when you recv this event.
	WGME_ITMG_MAIN_EVENT_TYPE_MIC_LOST_DEVICE = 1012,
	--Notify user the default mic device is changed in the PC, refresh the mic devices when you recv this event.
	WGME_ITMG_MAIN_EVENT_TYPE_MIC_DEFAULT_DEVICE_CHANGED = 1013,

	WGME_ITMG_MAIN_EVENT_TYPE_AUDIO_ROUTE_CHANGED = 1014,

	--Notification of volumes of users in room
	WGME_ITMG_MAIN_EVENT_TYPE_USER_VOLUMES = 1020,
	
	--quality information
	WGME_ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_QUALITY = 1022,  

	--Notification of accompany finished
	WGME_ITMG_MAIN_EVENT_TYPE_ACCOMPANY_FINISH = 1090,
    
    --Notification of Server Audio Route Event
    WGME_ITMG_MAIN_EVENT_TYPE_SERVER_AUDIO_ROUTE_EVENT = 1091,
    
    --Notification of Custom Audio Data
    WGME_ITMG_MAIN_EVENT_TYPE_CUSTOMDATA_UPDATE = 1092,
    
    WGME_ITMG_MAIN_EVENT_TYPE_REALTIME_ASR = 1093,
	
    WGME_ITMG_MAIN_EVENT_TYPE_CHORUS_EVENT = 1094,
    
    WGME_ITMG_MAIN_EVENT_TYPE_CHANGETEAMID = 1095,
    
    WGME_ITMG_MAIN_EVNET_TYPE_AUDIO_READY = 2000,
    
    WGME_ITMG_MAIN_EVENT_TYPE_HARDWARE_TEST_RECORD_FINISH = 2001,
    
    WGME_ITMG_MAIN_EVENT_TYPE_HARDWARE_TEST_PREVIEW_FINISH = 2002,
	
	-- Notification of PTT Record
	WGME_ITMG_MAIN_EVNET_TYPE_PTT_RECORD_COMPLETE = 5001,
	-- Notification of PTT Upload
    WGME_ITMG_MAIN_EVNET_TYPE_PTT_UPLOAD_COMPLETE = 5002,
	-- Notification of PTT Download
    WGME_ITMG_MAIN_EVNET_TYPE_PTT_DOWNLOAD_COMPLETE = 5003,
	-- Notification of PTT Play
    WGME_ITMG_MAIN_EVNET_TYPE_PTT_PLAY_COMPLETE = 5004,
	-- Notification of PTT 2Text
    WGME_ITMG_MAIN_EVNET_TYPE_PTT_SPEECH2TEXT_COMPLETE = 5005,
    -- Notification of StreamRecognition
    WGME_ITMG_MAIN_EVNET_TYPE_PTT_STREAMINGRECOGNITION_COMPLETE = 5006,
    --Notification of StreamRecognition intermediate result 
    WGME_ITMG_MAIN_EVNET_TYPE_PTT_STREAMINGRECOGNITION_IS_RUNNING = 5007,
    
    WGME_ITMG_MAIN_EVNET_TYPE_ROOM_MANAGEMENT_OPERATOR = 6000,

}

WGME_ITMG_ROOM_TYPE = {
	WGME_ITMG_ROOM_TYPE_FLUENCY = 1,
	WGME_ITMG_ROOM_TYPE_STANDARD = 2,
	WGME_ITMG_ROOM_TYPE_HIGHQUALITY = 3,
}

WGME_ITMG_EVENT_ID_USER_UPDATE = {
	--Notification of entering a room
	WGME_ITMG_EVENT_ID_USER_ENTER=1,
	--Notification of exiting a room
	WGME_ITMG_EVENT_ID_USER_EXIT=2,
	--Notification of member up video
	WGME_ITMG_EVENT_ID_USER_HAS_CAMERA_VIDEO=3,
	--Notification of member not up video any more
	WGME_ITMG_EVENT_ID_USER_NO_CAMERA_VIDEO=4,
	--Notification of member audio event
	WGME_ITMG_EVENT_ID_USER_HAS_AUDIO=5,
	--Notification of no member audio event is received for 2 seconds
	WGME_ITMG_EVENT_ID_USER_NO_AUDIO=6,
}

--@brief    initSDK函数
--@param  playerId角色Id，登入语音SDK的唯一标识
function WGMEVoiceNotify:init(playerId)
	WZLog("WGMEVoiceNotify:init", playerId, self.m_nPlayerId, self.m_bSupport)
    if playerId == nil then 
        return 
    end
    --针对东南亚等这些不需要语言功能的包屏蔽
  --   if tonumber(ProjConfig.GCLOUDVOICE_ID) == 0 then
 	-- 	return
 	-- end
 	if not WGMEVoiceNotify.m_gmeId or tonumber(WGMEVoiceNotify.m_gmeId) == 0 or WGMEVoiceNotify.m_gmeId == "" then
 		return
 	end
	if GMEVoiceBridge then
		WZLog("WGMEVoiceNotify:init 1")
		if GMEVoiceBridge:isSupportVoice() then
			WZLog("WGMEVoiceNotify:init 2")
	 		if self.m_nPlayerId ~= playerId or not self.m_bSupport then
	 			WZLog("ggggggggg:", WGMEVoiceNotify.m_gmeId,WGMEVoiceNotify.m_gmeKey,playerId,GMEVoiceBridge:GetVoiceEngine())                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
		    	--GMEVoiceBridge:GetVoiceEngine():SetAppInfo(ProjConfig.GCLOUDVOICE_ID,ProjConfig.GCLOUDVOICE_KEY,""..playerId);
		   		--GMEVoiceBridge:GetVoiceEngine():Init()
		   		--GMEVoiceBridge:setCloudVoiceNotify()
		   		--GMEVoiceBridge:GetVoiceEngine():SetSpeakerVolume(50)
		   		--GMEVoiceBridge:GetVoiceEngine():ApplyMessageKey(6000)
		   		--openid > 10000
		   		GMEVoiceBridge:init(WGMEVoiceNotify.m_gmeId,WGMEVoiceNotify.m_gmeKey,"10000"..playerId)
		   		--GMEVoiceBridge:GetVoiceEngine():GetAudioCtrl():SetSpeakerVolume(100)
		   		self.m_bSupport = true
	            self.m_nPlayerId = playerId
	            WZLog("ggggggggg3333:",playerId)
	            if  not CheckButtonShow(121,false) then
	            	self.m_bSupport = false
	            end
	            return
	   		end
		end
   	end
 	WZLog("device dons't supportVoice")
end

--@brief    是否支持语音判断
--@return   是否支持
function WGMEVoiceNotify:IsSupportVoice()
	--WZLog("WGMEVoiceNotify:IsSupportVoice:",self.m_bSupport)
	return self.m_bSupport	
end

--@brief   设置语音方式
--@param   nMode语音格式，0实时，1离线，2语音转文字
function WGMEVoiceNotify:SetMode(nMode)
	WZLog("WGMEVoiceNotify:SetMode:",nMode)
	if not self.m_bSupport then return end
	self.m_nMode = nMode
	--GMEVoiceBridge:GetVoiceEngine():SetMode(nMode)
end

--@brief    录制语音
--@param #filePath 语音文件的存储路径
function WGMEVoiceNotify:StartRecording(tExtend)
	WZLog("WGMEVoiceNotify:StartRecording:")
	if not self.m_bSupport then return end
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if true or platForm == 2 then
		SoundManager:pauseBackgroundMusic()
	end
	self.m_sFilePath = CCFileUtils:sharedFileUtils():getTmpWritablePath()
	self.m_sFilePath = self.m_sFilePath.."__"..tExtend.chatChannel.."__"..tExtend.recPlayerId.."__"..os.time()
	local ret = GMEVoiceBridge:GetVoiceEngine():GetPTT():StartRecording(self.m_sFilePath)
    WZLog("WGMEVoiceNotify:StartRecording path:",self.m_sFilePath,ret)
    if ret ~= 0 then
    	if ret ~= 4102 then
    		--4102:麦克风sdk权限未授权错误
			SoundManager:resumeBackgroundMusic()
		end
    end
    return ret
end

--@brief   取消录制语音
--@param 
function WGMEVoiceNotify:CancelRecording()
	WZLog("WGMEVoiceNotify:CancelRecording:")
	if not self.m_bSupport then return end
	GMEVoiceBridge:GetVoiceEngine():GetPTT():CancelRecording()
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if true or platForm == 2 then
		SoundManager:resumeBackgroundMusic()
	end
end

--@brief    停止录制语音，并上传
--@param #filePath 语音文件的存储路径
function WGMEVoiceNotify:StopRecording()
	WZLog("WGMEVoiceNotify:StopRecording")
	if not self.m_bSupport then return end
	local state = GMEVoiceBridge:GetVoiceEngine():GetPTT():StopRecording()
	WZLog("WGMEVoiceNotify:StopRecording result = ",state)
	-- GMEVoiceBridge:GetVoiceEngine():UploadRecordedFile(self.m_sFilePath, 60000)
	-- local platForm =  WZUISystem:getInstance():getPlatformInfo()
	-- if true  or platForm == 2 then
	-- 	SoundManager:resumeBackgroundMusic()
	-- end
end

--@brief   翻译文字
--@param #filePath 语音文件的存储路径
function WGMEVoiceNotify:SpeechToText(fileID)
	WZLog("WGMEVoiceNotify:SpeechToText")
	if not self.m_bSupport then return end
	--将指定的语音文件识别成文字
	GMEVoiceBridge:GetVoiceEngine():GetPTT():SpeechToText(fileID)
	--将指定的语音文件翻译成文字（指定语言）https://www.tencentcloud.com/zh/document/product/607/30260
	--普通话 （中国大陆）:cmn-Hans-CN, 國語 （中国台灣）:cmn-Hant-TW, English (Great Britain):en-GB, English (United States):en-US
	--Tiếng Việt (Việt Nam)越南语（越南）:vi-VN
	--GMEVoiceBridge:GetVoiceEngine():GetPTT():SpeechToText(fileID, "vi-VN")
end

--@brief    获取扩展信息
--@return
function WGMEVoiceNotify:getExtends(filePath)
	WZLog("WGMEVoiceNotify:getExtends:",filePath)
	local t = string.find(filePath,"__")
    local b = string.sub(filePath,t+2)
    local t2 = string.find(b,"__")
    local str1 = string.sub(b,0,t2-1)
    local c = string.sub(b,t2+2)
    local t3 = string.find(c,"__")
    local str2 = string.sub(c,0,t3-1)
    return str1,str2
end

--@brief  停止播放语音()
function WGMEVoiceNotify:StopPlayFile()
	if not self.m_bSupport then return end
	GMEVoiceBridge:GetVoiceEngine():GetPTT():StopPlayFile()
	SoundManager:resumeBackgroundMusic()
end

--@brief  播放语音(其实是先下载，下载成功后在播放)
function WGMEVoiceNotify:PlayRecordedFile(fileId)
	if not self.m_bSupport then return end
	WZLog("WGMEVoiceNotify:PlayRecordedFile:",fileId)
	if not fileId or fileId == "" then
		return
	end
	--GMEVoiceBridge:GetVoiceEngine():StopPlayFile();--先停止播放先，免得边播边下
	local filePath = ""
	for k,v in pairs(self.m_tVoiceMsg) do
		if v.id == fileId then
			filePath = v.filePath
			local filePathExist = WZDataFile:getInstance():checkFileExist(v.filePath)
			if filePathExist then
				local ret = WGMEVoiceNotify:playRecorded(v.filePath)
				return ret
			end
		end
	end

	WZLog("WGMEVoiceNotify:PlayRecordedFile:",filePath)
	local downPath = CCFileUtils:sharedFileUtils():getTmpWritablePath().."down_"..os.time()
	if filePath ~= "" then
		downPath = filePath
	end
	local ret = GMEVoiceBridge:GetVoiceEngine():GetPTT():DownloadRecordedFile(fileId, downPath)
	return ret
end

--@brief    下载语音文件回调
--@return
function WGMEVoiceNotify:playRecorded(filePath)
	WZLog("WGMEVoiceNotify:playRecorded:", filePath)
	SoundManager:pauseBackgroundMusic()
	local ret = GMEVoiceBridge:GetVoiceEngine():GetPTT():PlayRecordedFile(filePath)
	return ret
end

--@brief    加入小队语言
--@return
function WGMEVoiceNotify:JoinTeamRoom(roomName)
	WZLog("WGMEVoiceNotify:JoinTeamRoom:", roomName)
	if not self.m_bSupport then return end	
	local roomSplit = SplitStringWithSeparator(roomName, "_")
	local roomId = tonumber(roomSplit[#roomSplit])
	if not roomId or roomId <= 0 then
		return
	end
	self:SetMode(0) --设置下模式
	if self.m_sRoomName ~= "" and roomName ~= self.m_sRoomName then
		self:QuitRoom(self.m_sRoomName)
        self.m_sRoomName = ""
        self.m_sRoomId = 0
	end
	local ret = GMEVoiceBridge:enterRoom(roomId, WGME_ITMG_ROOM_TYPE.WGME_ITMG_ROOM_TYPE_STANDARD)
    if ret == 0 then 
        self.m_sRoomName = roomName
        self.m_sRoomId = roomId
    end
    if WZUISystem:getInstance():getPlatformInfo() == 1 then
		local data = WZDataFile:getInstance():getUserData()
	  	if data then
	        local musicVolume = data:getStringValue("Volume", "musicVolume")
			self.m_nMusicVolume = musicVolume
		end	
		AudioManager:setBackgroundMusicVolume(0,true)
	else
		SoundManager:pauseBackgroundMusic()
	end
    WZLog("WGMEVoiceNotify:JoinTeamRoom:", roomName,ret)
    return ret
end   

--@brief   屏蔽某个人的消息
--@return
function WGMEVoiceNotify:ForbidMemberVoice(id,bForbid)
	if not self.m_bSupport then return end
	WZLog("WGMEVoiceNotify:ForbidMemberVoice:", id,bForbid)
	-- GMEVoiceBridge:GetVoiceEngine():ForbidMemberVoice(id,bForbid)
	GMEVoiceBridge:GetVoiceEngine():GetAudioCtrl():AddAudioBlackList(id)
end

--@brief    离开小队语言
--@return
function WGMEVoiceNotify:QuitRoom(roomName)
	if not self.m_bSupport then return end
	WZLog("WGMEVoiceNotify:QuitRoom:", roomName)
	local roomSplit = SplitStringWithSeparator(roomName, "_")
	local roomId = tonumber(roomSplit[#roomSplit])
	if not roomId or roomId <= 0 then
		return
	end
	local ret = GMEVoiceBridge:exitRoom()
    if ret == 0 then 
        self.m_sRoomName = ""
        self.m_sRoomId = 0
    end
    WZLog("WGMEVoiceNotify:QuitRoom222:", self.m_nMusicVolume)
    if WZUISystem:getInstance():getPlatformInfo() == 1 then
   	 	AudioManager:setBackgroundMusicVolume(tonumber(self.m_nMusicVolume),true)
   	else
   		SoundManager:resumeBackgroundMusic()
   	end
    return ret 
end

--@brief   打开小队语言麦克风
--@return
function WGMEVoiceNotify:OpenMic()
	WZLog("WGMEVoiceNotify:OpenMic:")
	if not self.m_bSupport then return end
	-- if WZUISystem:getInstance():getPlatformInfo() == 1 then
	-- 	local data = WZDataFile:getInstance():getUserData()
	--   	if data then
	--         local musicVolume = data:getStringValue("Volume", "musicVolume")
	-- 		self.m_nMusicVolume = musicVolume
	-- 	end	
	-- 	AudioManager:setBackgroundMusicVolume(0,true)
	-- else
	-- 	SoundManager:pauseBackgroundMusic()
	-- end
	GMEVoiceBridge:GetVoiceEngine():GetAudioCtrl():EnableMic(true)
end

--@brief   关闭小队语言麦克风
--@return
function WGMEVoiceNotify:CloseMic()
	WZLog("WGMEVoiceNotify:CloseMic:")
	if not self.m_bSupport then return end
	GMEVoiceBridge:GetVoiceEngine():GetAudioCtrl():EnableMic(false)
	-- if WZUISystem:getInstance():getPlatformInfo() == 1 then
 --   	 	AudioManager:setBackgroundMusicVolume(tonumber(self.m_nMusicVolume),true)
 --   	else
 --   		SoundManager:resumeBackgroundMusic()
 --   	end
end

--@brief   打开小队语言扬声器
--@return
function WGMEVoiceNotify:OpenSpeaker()
	WZLog("WGMEVoiceNotify:OpenSpeaker:")
	if not self.m_bSupport then return end
	GMEVoiceBridge:GetVoiceEngine():GetAudioCtrl():EnableSpeaker(true)
end

--@brief   关闭小队语言扬声器
--@return
function WGMEVoiceNotify:CloseSpeaker()
	WZLog("WGMEVoiceNotify:CloseSpeaker:")
	if not self.m_bSupport then return end
	GMEVoiceBridge:GetVoiceEngine():GetAudioCtrl():EnableSpeaker(false)
end

--@brief   进入后台处理
--@return
function WGMEVoiceNotify:Pause()
	WZLog("WGMEVoiceNotify:Pause:")
	if not self.m_bSupport then return end
	GMEVoiceBridge:pause()
end

--@brief    进入前台处理
--@return
function WGMEVoiceNotify:Resume()
	WZLog("WGMEVoiceNotify:Resume:")
	if not self.m_bSupport then return end
	GMEVoiceBridge:resume()
end

function WGMEVoiceNotify:joinWGCloudVoiceRoom(dt)
	if WGMEVoiceNotify.m_sRoomName and WGMEVoiceNotify.m_sRoomName ~= "" then
        --local ret = GMEVoiceBridge:GetVoiceEngine():enterRoom(WGMEVoiceNotify.m_sRoomName,10000)
		local roomSplit = SplitStringWithSeparator(WGMEVoiceNotify.m_sRoomName, "_")
		local roomId = tonumber(roomSplit[#roomSplit])
		if not roomId or roomId <= 0 then
			return
		end
		local ret = GMEVoiceBridge:enterRoom(roomId, WGME_ITMG_ROOM_TYPE.WGME_ITMG_ROOM_TYPE_STANDARD)
		WZLog("WGMEVoiceNotify:joinWGCloudVoiceRoom:", ret)
        if ret == 0 and WGMEVoiceNotify.m_nJoinRoomScheduleId > 0 then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGMEVoiceNotify.m_nJoinRoomScheduleId)
            WGMEVoiceNotify.m_nJoinRoomScheduleId = 0
        end
    else 
       CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGMEVoiceNotify.m_nJoinRoomScheduleId)
       WGMEVoiceNotify.m_nJoinRoomScheduleId = 0 
    end
end


--@brief    添加语言列表
--@return
function WGMEVoiceNotify:_addVoice(tVoice)
	if #self.m_tVoiceMsg >= 100 then --删除第一条语音信息
	end
	table.insert( self.m_tVoiceMsg, tVoice)
	
end

--@brief    GME语言回调
--@parma 	sJson:{"eventType" : "", "data" : ""}
--@return 
function WGMEVoiceNotify:OnEvent(sJson)
	WZLog("WGMEVoiceNotify:OnEvent:",sJson)
	local tResult = json.decode(sJson)
	if tResult.eventType and tResult.data then
		WZLog("WGMEVoiceNotify:OnEvent 111:")
		local eventType = tonumber( tResult.eventType)
		local data = json.encode(tResult.data )
		WZLog("WGMEVoiceNotify:OnEvent 1111:", eventType, data)
		if eventType == WGME_ITMG_MAIN_EVENT_TYPE.WGME_ITMG_MAIN_EVENT_TYPE_ENTER_ROOM then
			WGMEVoiceNotify:OnJoinRoom(data)
		elseif eventType == WGME_ITMG_MAIN_EVENT_TYPE.WGME_ITMG_MAIN_EVENT_TYPE_EXIT_ROOM then
			WGMEVoiceNotify:OnQuitRoom(data)
		elseif eventType == WGME_ITMG_MAIN_EVENT_TYPE.WGME_ITMG_MAIN_EVNET_TYPE_USER_UPDATE then
			--成员状态变化 data["event_id"], data["user_list"]
			WGMEVoiceNotify:OnStatusUpdate(data)
		elseif eventType == WGME_ITMG_MAIN_EVENT_TYPE.WGME_ITMG_MAIN_EVNET_TYPE_PTT_RECORD_COMPLETE then
			--启动录音的回调 result, file_path
			WZLog("WGMEVoiceNotify:OnEvent 222:", WGME_ITMG_MAIN_EVNET_TYPE_PTT_RECORD_COMPLETE)
			WGMEVoiceNotify:OnRecordComplete(data)
		elseif eventType == WGME_ITMG_MAIN_EVENT_TYPE.WGME_ITMG_MAIN_EVNET_TYPE_PTT_UPLOAD_COMPLETE then
			--上传语音完成的回调 result，file_path 和 file_id
			WGMEVoiceNotify:OnUploadFile(data)
		elseif eventType == WGME_ITMG_MAIN_EVENT_TYPE.WGME_ITMG_MAIN_EVNET_TYPE_PTT_DOWNLOAD_COMPLETE then
			--下载语音文件完成回调 result，file_path 和 file_id
			WGMEVoiceNotify:OnDownloadFile(data)
		elseif eventType == WGME_ITMG_MAIN_EVENT_TYPE.WGME_ITMG_MAIN_EVNET_TYPE_PTT_PLAY_COMPLETE then
			--播放语音的回调 result，file_path
			WGMEVoiceNotify:OnPlayRecordedFile(data)
		elseif eventType == WGME_ITMG_MAIN_EVENT_TYPE.WGME_ITMG_MAIN_EVNET_TYPE_PTT_SPEECH2TEXT_COMPLETE then
			--识别回调 result、file_path 和 text,其中 text 为识别的文本
			WGMEVoiceNotify:OnSpeechToText(data)
		end
	end
end

--@brief    Callback when JoinXxxRoom successful or failed.
--@return
function WGMEVoiceNotify:OnJoinRoom(sJson)
	WZLog("WGMEVoiceNotify:OnJoinRoom:",sJson)
	local tResult = json.decode(sJson)
    
    if self.m_nJoinRoomScheduleId > 0 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nJoinRoomScheduleId)
        self.m_nJoinRoomScheduleId = 0
    end
    --0000  成功
    --7006	鉴权失败 有以下几个原因：1、AppID 不存在或者错误，2、authbuff 鉴权错误，3、鉴权过期 4、openID不符合规范。
	--7007	已经在其它房间。
	--1001	已经在进房过程中，然后又重复了此操作。建议在进房回调返回之前不要再调用进房接口。
	--1003	已经进房了在房间中，又调用一次进房接口。
    --1101	确保已经初始化 SDK，或者确保在同一线程调用接口，以及确保 Poll 接口正常调用。
	if tResult.result == 0 then
		joinVoiceRoom(tResult.memberID)
		if WZUISystem:getInstance():getPlatformInfo() == 1 then
			local data = WZDataFile:getInstance():getUserData()
	  		if data then
	        	local musicVolume = data:getStringValue("Volume", "musicVolume")
				self.m_nMusicVolume = musicVolume
			end	
				AudioManager:setBackgroundMusicVolume(0,true)
		else
			SoundManager:pauseBackgroundMusic()
		end
	else
		local roomSplit = SplitStringWithSeparator(WGMEVoiceNotify.m_sRoomName, "_")
		local roomId = tonumber(roomSplit[#roomSplit])
		if not roomId or roomId <= 0 then
			return
		end
		local ret = GMEVoiceBridge:enterRoom(roomId, WGME_ITMG_ROOM_TYPE.WGME_ITMG_ROOM_TYPE_STANDARD)
		WZLog("WGMEVoiceNotify:OnJoinRoom222:", ret)
        if ret ~= 0 then 
            self.m_nJoinRoomScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WGMEVoiceNotify.joinWGCloudVoiceRoom, 0.2, false)
        end
	end
end

--@brief    Callback when dropped from the room
--@return
function WGMEVoiceNotify:OnStatusUpdate(sJson)
	WZLog("WGMEVoiceNotify:OnStatusUpdate:",sJson)
	--成员状态变化 data["event_id"], data["user_list"]
	local tResult = json.decode(sJson)
	local event_id = tResult.event_id
	if event_id == WGME_ITMG_EVENT_ID_USER_UPDATE.WGME_ITMG_EVENT_ID_USER_ENTER then
		--有成员进入房间
	elseif event_id == WGME_ITMG_EVENT_ID_USER_UPDATE.WGME_ITMG_EVENT_ID_USER_EXIT then
		--有成员退出房间
	elseif event_id == WGME_ITMG_EVENT_ID_USER_UPDATE.WGME_ITMG_EVENT_ID_USER_HAS_AUDIO then
		--有成员发送音频包
	elseif event_id == WGME_ITMG_EVENT_ID_USER_UPDATE.WGME_ITMG_EVENT_ID_USER_NO_AUDIO then
		--有成员停止发送音频包
	end
	if tResult.user_list then
		local data = {}
		data.count = #tResult.user_list
		data.members = tResult.user_list
		data = json.encode(data)
		WGMEVoiceNotify:OnMemberVoice(data)
	end
end

--@brief    Callback when QuitRoom successful or failed.
--@return
function WGMEVoiceNotify:OnQuitRoom(sJson)
	WZLog("WGMEVoiceNotify:OnQuitRoom:",sJson)
	local tResult = json.decode(sJson)
	if tResult.code == 0 then
		self:SetMode(2) --设置下模式
		self.m_sRoomName = ""
		self.m_sRoomId = 0
	else
		GMEVoiceBridge:exitRoom()
	end
end

--@brief    Callback when someone saied or silence in the same room.
--@return
function WGMEVoiceNotify:OnMemberVoice(sJson)
	WZLog("WGMEVoiceNotify:OnMemberVoice:",sJson)
	voiceMemberState(sJson)
end

--@brief    Callback when finish a voice file play end.
--@return
function WGMEVoiceNotify:OnPlayRecordedFile(sJson)
	WZLog("WGMEVoiceNotify:OnPlayRecordedFile:",sJson)
	SoundManager:resumeBackgroundMusic()
	WndChat:callbackRecordPlayFinish()
end

--@brief    Callback when translate voice to text successful or failed.
--@return
function WGMEVoiceNotify:OnSpeechToText(sJson,extend)
	WZLog("WGMEVoiceNotify:OnSpeechToText:",sJson)
	local tResult = json.decode(sJson)
	--{"file_id":"","text":"","result":0}，其中 text 为识别的文本。
	if tResult.result == 0 and tResult.text then
		tResult.txt = tResult.text or ""
		tResult.fileID = tResult.file_id
		WndChat:callbackTranslateByRecord(tResult)
		--MsgBoxManager:showTipBox(unicode_to_utf8(tResult.result))
	end
end

--@brief     Callback when client is using microphone recording audio
--@return
function WGMEVoiceNotify:OnRecording(sJson)
	WZLog("WGMEVoiceNotify:OnRecording:",sJson)
	
end

--@brief     Callback when client is using microphone recording audio
--@return
function WGMEVoiceNotify:OnRecordComplete(sJson)
	WZLog("WGMEVoiceNotify:OnRecordComplete:",sJson)
	--启动录音的回调 result, file_path
	local tResult = json.decode(sJson)
	if tResult.result == 0 and tResult.file_path and tResult.file_path ~= "" then
		WZLog("WGMEVoiceNotify:OnRecordComplete:",tResult.file_path, self.m_sFilePath)
		GMEVoiceBridge:GetVoiceEngine():GetPTT():UploadRecordedFile(tResult.file_path)
		local platForm =  WZUISystem:getInstance():getPlatformInfo()
		if true  or platForm == 2 then
			SoundManager:resumeBackgroundMusic()
		end
	end
end
--@brief    initSDK回调函数
function WGMEVoiceNotify:OnApplyMessageKey(sJson)
	-- WZLog("WGMEVoiceNotify:OnApplyMessageKey:",sJson, GV_ON_MESSAGE_KEY_APPLIED_SUCC)
	-- local tResult = json.decode(sJson)
	-- if tResult.code == GV_ON_MESSAGE_KEY_APPLIED_SUCC then
	-- 	WZLog("WGMEVoiceNotify:OnApplyMessageKey222")
	-- 	self:SetMode(2)
	-- 	GMEVoiceBridge:GetVoiceEngine():SetMaxMessageLength(58000)
	-- else
	-- 	--没有进入，则再次进入
	-- 	GMEVoiceBridge:GetVoiceEngine():ApplyMessageKey(6000)
	-- end
end

--@brief    上传语音文件回调
--@return
function WGMEVoiceNotify:OnUploadFile(sJson)
	WZLog("WGMEVoiceNotify:OnUploadFile:",sJson)
	local tResult = json.decode(sJson)
	-- if tResult.code  == GV_ON_UPLOAD_RECORD_DONE then
	-- 	local tVoice = {}
	-- 	tVoice.filePath = tResult.filePath
	-- 	tVoice.id = tResult.fileID
	-- 	WGMEVoiceNotify:_addVoice(tVoice)
	-- 	g_fileId = tVoice.id
	-- 	local tab = {}
	-- 	tab.fileID = tResult.fileID
	-- 	tab.chatChannel,tab.recPlayerId=self:getExtends(tResult.filePath)
	-- 	tab.time = GMEVoiceBridge:getAudioLength(tResult.filePath)
	-- 	WndChat:recRecordCallback(tab)	
	-- end

	--result,file_path 和 file_id
	if tResult.result  == 0 and tResult.file_path and tResult.file_id then
		local tVoice = {}
		tVoice.filePath = tResult.file_path
		tVoice.id = tResult.file_id
		WGMEVoiceNotify:_addVoice(tVoice)
		g_fileId = tVoice.id
		local tab = {}
		tab.fileID = tResult.file_id
		tab.chatChannel,tab.recPlayerId=self:getExtends(tResult.file_path)
		tab.time = math.ceil(GMEVoiceBridge:getAudioLength(tResult.file_path) / 1000)--ms
		tab.filePath = tResult.file_path
		WZLog("WGMEVoiceNotify:OnUploadFile:",tVoice, tab)
		WndChat:recRecordCallback(tab)	
	end
end

--@brief    下载语音文件回调
--@return
function WGMEVoiceNotify:OnDownloadFile(sJson)
	WZLog("WGMEVoiceNotify:OnDownloadFile:",sJson)
	local tResult = json.decode(sJson)
	-- if tResult.code == GV_ON_DOWNLOAD_RECORD_DONE then
	-- 	local ret =  WGMEVoiceNotify:playRecorded(tResult.filePath)
	-- 	return ret
	-- end
	--20221009 nijinlin
	--{"file_id":"","file_path":"","result":0}
	if tResult.result == 0 and tResult.file_path and tResult.file_id then		
		local tVoice = {}
		tVoice.filePath = tResult.file_path
		tVoice.id = tResult.file_id
		WGMEVoiceNotify:_addVoice(tVoice)
		g_fileId = tVoice.id
		local ret =  WGMEVoiceNotify:playRecorded(tResult.file_path)
		return ret
	end
	return -1
end


--[[

--回调消息
ITMG_MAIN_EVENT_TYPE_ENTER_ROOM	进入音频房间消息
ITMG_MAIN_EVENT_TYPE_EXIT_ROOM	退出音频房间消息
ITMG_MAIN_EVENT_TYPE_ROOM_DISCONNECT	房间因为网络等原因断开消息
ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_TYPE	房间类型变化事件
ITMG_MAIN_EVENT_TYPE_MIC_NEW_DEVICE	新增麦克风设备消息
ITMG_MAIN_EVENT_TYPE_MIC_LOST_DEVICE	丢失麦克风设备消息
ITMG_MAIN_EVENT_TYPE_SPEAKER_NEW_DEVICE	新增扬声器设备消息
ITMG_MAIN_EVENT_TYPE_SPEAKER_LOST_DEVICE	丢失扬声器设备消息
ITMG_MAIN_EVENT_TYPE_ACCOMPANY_FINISH	伴奏结束消息
ITMG_MAIN_EVNET_TYPE_USER_UPDATE	房间成员更新消息
ITMG_MAIN_EVENT_TYPE_NUMBER_OF_USERS_UPDATE	房间成员数量更新消息
ITMG_MAIN_EVENT_TYPE_NUMBER_OF_AUDIOSTREAMS_UPDATE	房间音频流数量更新消息
ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_QUALITY	房间质量信息
ITMG_MAIN_EVNET_TYPE_PTT_RECORD_COMPLETE	PTT 录音完成
ITMG_MAIN_EVNET_TYPE_PTT_UPLOAD_COMPLETE	上传 PTT 完成
ITMG_MAIN_EVNET_TYPE_PTT_DOWNLOAD_COMPLETE	下载 PTT 完成
ITMG_MAIN_EVNET_TYPE_PTT_PLAY_COMPLETE	播放 PTT 完成
ITMG_MAIN_EVNET_TYPE_PTT_SPEECH2TEXT_COMPLETE	语音转文字完成

--Data 列表
ITMG_MAIN_EVENT_TYPE_ENTER_ROOM	result; error_info	{"error_info":"","result":0}
ITMG_MAIN_EVENT_TYPE_EXIT_ROOM	result; error_info	{"error_info":"","result":0}
ITMG_MAIN_EVENT_TYPE_ROOM_DISCONNECT	result; error_info	{"error_info":"waiting timeout, please check your network","result":0}
ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_TYPE	result; error_info; sub_event_type; new_room_type	{"error_info":"","new_room_type":0,"result":0}
ITMG_MAIN_EVENT_TYPE_SPEAKER_NEW_DEVICE	result; error_info	{"deviceID":"{0.0.0.00000000}.{a4f1e8be-49fa-43e2-b8cf-dd00542b47ae}","deviceName":"扬声器 (Realtek High Definition Audio)","error_info":"","isNewDevice":true,"isUsedDevice":false,"result":0}
ITMG_MAIN_EVENT_TYPE_SPEAKER_LOST_DEVICE	result; error_info	{"deviceID":"{0.0.0.00000000}.{a4f1e8be-49fa-43e2-b8cf-dd00542b47ae}","deviceName":"扬声器 (Realtek High Definition Audio)","error_info":"","isNewDevice":false,"isUsedDevice":false,"result":0}
ITMG_MAIN_EVENT_TYPE_MIC_NEW_DEVICE	result; error_info	{"deviceID":"{0.0.1.00000000}.{5fdf1a5b-f42d-4ab2-890a-7e454093f229}","deviceName":"麦克风 (Realtek High Definition Audio)","error_info":"","isNewDevice":true,"isUsedDevice":true,"result":0}
ITMG_MAIN_EVENT_TYPE_MIC_LOST_DEVICE	result; error_info	{"deviceID":"{0.0.1.00000000}.{5fdf1a5b-f42d-4ab2-890a-7e454093f229}","deviceName":"麦克风 (Realtek High Definition Audio)","error_info":"","isNewDevice":false,"isUsedDevice":true,"result":0}
ITMG_MAIN_EVNET_TYPE_USER_UPDATE	user_list; event_id	{"event_id":1,"user_list":["0"]}
ITMG_MAIN_EVENT_TYPE_NUMBER_OF_USERS_UPDATE	AllUser; AccUser; ProxyUser	{"AllUser":3,"AccUser":2,"ProxyUser":1}
ITMG_MAIN_EVENT_TYPE_NUMBER_OF_AUDIOSTREAMS_UPDATE	AudioStreams	{"AudioStreams":3}
ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_QUALITY	weight; loss; delay	{"weight":5,"loss":0.1,"delay":1}
ITMG_MAIN_EVNET_TYPE_PTT_RECORD_COMPLETE	result; file_path	{"file_path":"","result":0}
ITMG_MAIN_EVNET_TYPE_PTT_UPLOAD_COMPLETE	result; file_path;file_id	{"file_id":"","file_path":"","result":0}
ITMG_MAIN_EVNET_TYPE_PTT_DOWNLOAD_COMPLETE	result; file_path;file_id	{"file_id":"","file_path":"","result":0}
ITMG_MAIN_EVNET_TYPE_PTT_PLAY_COMPLETE	result; file_path	{"file_path":"","result":0}
ITMG_MAIN_EVNET_TYPE_PTT_SPEECH2TEXT_COMPLETE	result; text;file_id	{"file_id":"","text":"","result":0}
ITMG_MAIN_EVNET_TYPE_PTT_STREAMINGRECOGNITION_COMPLETE	result; file_path; text;file_id	{"file_id":"","file_path":","text":"","result":0}

ITMG_MAIN_EVENT_TYPE_ENTER_ROOM    加入房间事件的回调    {"error_info":"","result":0}
ITMG_MAIN_EVENT_TYPE_ROOM_DISCONNECT    房间因为网络等原因断开消息    {"error_info":"waiting timeout, please check your network","result":0}
ITMG_MAIN_EVENT_TYPE_EXIT_ROOM    退出房间回调    {"error_info":"","result":0}
ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_TYPE    房间类型完成回调    {"error_info":"","new_room_type":0,"result":0}    new_room_type
	ITMG_ROOM_CHANGE_EVENT_ENTERROOM    1    表示在进房的过程中，自带的音频类型与房间不符合，被修改为所进入房间的音频类型
	ITMG_ROOM_CHANGE_EVENT_START    2    表示已经在房间内，音频类型开始切换（例如调用 ChangeRoomType 接口后切换音频类型 ）
	ITMG_ROOM_CHANGE_EVENT_COMPLETE    3    表示已经在房间，音频类型切换完成
	ITMG_ROOM_CHANGE_EVENT_REQUEST    4    表示房间成员调用 ChangeRoomType 接口，请求切换房间音频类型
ITMG_MAIN_EVNET_TYPE_USER_UPDATE    成员状态变化    {"event_id":0,"user_list":""}
	ITMG_EVENT_ID_USER_ENTER	有成员进入房间
	ITMG_EVENT_ID_USER_EXIT		有成员退出房间
	ITMG_EVENT_ID_USER_HAS_AUDIO	有成员发送音频包，通过此事件可以判断用户是否说话，并展示声纹效果
	ITMG_EVENT_ID_USER_NO_AUDIO		有成员停止发送音频包
ITMG_MAIN_EVENT_TYPE_CHANGE_ROOM_QUALITY    房间通话质量监控事件	{"weight":0,"loss":0,"delay":0}
	weight:int,范围是1 - 50，数值为50是音质评分极好，数值为1是音质评分很差，几乎不能使用，数值为0代表初始值，无含义。一般数值在 30 以下就可以提醒用户网络较差，建议切换网络。
	loss:double,上行丢包率。
	delay:int,音频触达延迟时间（ms）。

ITMG_MAIN_EVNET_TYPE_PTT_STREAMINGRECOGNITION_COMPLETE    流式语音识别的回调(是在停止录制并完成识别后才返回文字，相当于一段话说完才会返回识别的文字。)	{"text":"","result":0,"file_path":"","file_id":0} file_id:录音在后台的 url 地址，录音在服务器存放90天
ITMG_MAIN_EVNET_TYPE_PTT_STREAMINGRECOGNITION_IS_RUNNING 	流式语音识别的回调(是在录音过程中就会实时返回识别到的文字，相当于边说话边返回识别到的文字。)	{"text":"","result":0,"file_path":"","file_id":空}
ITMG_MAIN_EVNET_TYPE_PTT_RECORD_COMPLETE	启动录音的回调(result,file_path)
ITMG_MAIN_EVNET_TYPE_PTT_PLAY_COMPLETE		播放语音的回调(result,file_path)
ITMG_MAIN_EVNET_TYPE_PTT_UPLOAD_COMPLETE	上传语音完成的回调(result，file_path,file_id)
ITMG_MAIN_EVNET_TYPE_PTT_DOWNLOAD_COMPLETE	下载语音文件完成回调(result，file_path,file_id)
ITMG_MAIN_EVNET_TYPE_PTT_SPEECH2TEXT_COMPLETE	将指定的语音文件识别成文字的回调(result、file_path 和 text)

ITMGContext virtual const char* GetSDKVersion()
ITMGContext int SetLogLevel(ITMG_LOG_LEVEL levelWrite, ITMG_LOG_LEVEL levelPrint)
ITMGContext ITMGAudioCtrl int AddAudioBlackList(const char* openId)		加入音频数据黑名单
ITMGContext ITMGAudioCtrl int RemoveAudioBlackList(const char* openId)		移除音频数据黑名单
--函数列表(ITMGContext.GetInstance(this).GetPTT())
ITMGPTT virtual int SetMaxMessageLength(int msTime) 	语音消息录制	限制最大语音消息的长度，最大支持58秒。
ITMGPTT virtual int StartRecording(const char* fileDir)    启动录音     此接口用于启动录音。需要将录音文件上传后才可以进行语音转文字等操作。
ITMGPTT virtual int PauseRecording()	暂停录音	此接口用于暂停录音。如需恢复录音请调用接口 ResumeRecording
ITMGPTT virtual int ResumeRecording()	恢复录音	此接口用于恢复录音。
ITMGPTT virtual int StopRecording()		停止录音    此接口用于停止录音。此接口为异步接口，停止录音后会有录音完成回调，成功之后录音文件才可用。
ITMGPTT virtual int CancelRecording()	取消录音    调用此接口取消录音。取消之后没有回调。
ITMGPTT virtual int GetMicLevel()	获取语音消息麦克风实时音量		此接口用于获取麦克风实时音量，返回值为 int 类型，值域为0到200。
ITMGPTT virtual int SetMicVolume(int vol)	设置语音消息录制音量	此接口用于设置离线语音录制音量，值域为0到200。
ITMGPTT virtual int GetMicVolume()		获取语音消息录制音量	此接口用于获取离线语音录制音量。返回值为 int 类型，值域为0到200。
ITMGPTT virtual int GetSpeakerLevel()	获取语音消息扬声器实时音量		此接口用于获取扬声器实时音量。返回值为 int 类型，值域为0到200。
ITMGPTT virtual int SetSpeakerVolume(int vol)	设置语音消息播放音量	此接口用于设置离线语音播放音量，值域为0到200。
ITMGContextGetInstance()->GetPTT()->PlayRecordedFile(filePath);
ITMGPTT virtual int StopPlayFile()		停止播放语音		此接口用于停止播放语音。停止播放语音也会有播放完成的回调。
ITMGPTT virtual int GetFileSize(const char* filePath)		获取语音文件的大小		通过此接口，获取语音文件的大小。
ITMGPTT virtual int GetVoiceFileDuration(const char* filePath)		获取语音文件的时长		此接口用于获取语音文件的时长，单位毫秒。
ITMGPTT virtual int UploadRecordedFile(const char* filePath)		上传语音文件        此接口用于上传语音文件。
ITMGPTT virtual int DownloadRecordedFile(const char* fileId, const char* filePath) 		下载语音文件 		此接口用于下载语音文件。

--语音转文字服务
ITMGPTT virtual void SpeechToText(const char* fileID)		将指定的语音文件识别成文字		此接口用于将指定的语音文件识别成文字。
ITMGPTT virtual int SpeechToText(const char* fileID,const char* speechLanguage,const char* translateLanguage)		将指定的语音文件翻译成文字（指定语言）		此接口可以指定语言进行识别，也可以将语音中识别到的信息翻译成指定的语言返回。
]]