--WGCloudVoiceNotify.lua
--@brief	语言实现类
--@date		2017/03/22
--@author	zhangming
--@note		语言实现类

WGCloudVoiceNotify = {
	m_sFilePath = "",
	m_tVoiceMsg = {},
	m_bSupport = false,
	m_nMode = 1,
	m_sRoomName = "",
    m_nJoinRoomScheduleId = 0,
    m_nPlayerId = 0,
    m_nMusicVolume = 0.8,
    m_nButtonState = nil,
}

--@brief    initSDK函数
--@param  playerId角色Id，登入语音SDK的唯一标识
function WGCloudVoiceNotify:init(playerId)
	if isUseGMEVoiceEngine() then
		WGMEVoiceNotify:init(playerId)
		return
	end
    if playerId == nil then 
        return 
    end
    --针对东南亚等这些不需要语言功能的包屏蔽
    if tonumber(ProjConfig.GCLOUDVOICE_ID) == 0 then
 		return
 	end
	if GCloudVoiceBridge ~= nil and GCloudVoiceBridge:isSupportVoice() then
 		if self.m_nPlayerId ~= playerId or not self.m_bSupport then
 			WZLog("ggggggggg:", ProjConfig.GCLOUDVOICE_ID,ProjConfig.GCLOUDVOICE_KEY,playerId,GCloudVoiceBridge:GetVoiceEngine())                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	    	GCloudVoiceBridge:GetVoiceEngine():SetAppInfo(ProjConfig.GCLOUDVOICE_ID,ProjConfig.GCLOUDVOICE_KEY,""..playerId);
	   		GCloudVoiceBridge:GetVoiceEngine():Init()
	   		GCloudVoiceBridge:setCloudVoiceNotify()
	   		GCloudVoiceBridge:GetVoiceEngine():SetSpeakerVolume(50)
	   		GCloudVoiceBridge:GetVoiceEngine():ApplyMessageKey(6000)
	   		self.m_bSupport = true
            self.m_nPlayerId = playerId
            WZLog("ggggggggg3333:",playerId)
            if  not CheckButtonShow(121,false) then
            	self.m_bSupport = false
            end
            return
   		end
   	end
 	WZLog("device dons't supportVoice")
end

--@brief    是否支持语音判断
--@return   是否支持
function WGCloudVoiceNotify:IsSupportVoice()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:IsSupportVoice()		
	end
	return self.m_bSupport	
end

--@brief    initSDK回调函数
function WGCloudVoiceNotify:OnApplyMessageKey(sJson)	
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:OnApplyMessageKey(sJson)
	end
	WZLog("WGCloudVoiceNotify:OnApplyMessageKey:",sJson, GV_ON_MESSAGE_KEY_APPLIED_SUCC)
	local tResult = json.decode(sJson)
	if tResult.code == GV_ON_MESSAGE_KEY_APPLIED_SUCC then
		WZLog("WGCloudVoiceNotify:OnApplyMessageKey222")
		self:SetMode(2)
		GCloudVoiceBridge:GetVoiceEngine():SetMaxMessageLength(120000)
	else
		--没有进入，则再次进入
		GCloudVoiceBridge:GetVoiceEngine():ApplyMessageKey(6000)
	end
end

--@brief   设置语音方式
--@param   nMode语音格式，0实时，1离线，2语音转文字
function WGCloudVoiceNotify:SetMode(nMode)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:SetMode(nMode)	
	end
	WZLog("WGCloudVoiceNotify:SetMode:",nMode)
	if not self.m_bSupport then return end
	self.m_nMode = nMode
	GCloudVoiceBridge:GetVoiceEngine():SetMode(nMode)
end

--@brief    录制语音
--@param #filePath 语音文件的存储路径
function WGCloudVoiceNotify:StartRecording(tExtend)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:StartRecording(tExtend)
	end
	WZLog("WGCloudVoiceNotify:StartRecording:")
	if not self.m_bSupport then return end
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if true or platForm == 2 then
		SoundManager:pauseBackgroundMusic()
	end
	self.m_sFilePath = CCFileUtils:sharedFileUtils():getTmpWritablePath()
	self.m_sFilePath = self.m_sFilePath.."__"..tExtend.chatChannel.."__"..tExtend.recPlayerId.."__"..os.time()
	local ret = GCloudVoiceBridge:GetVoiceEngine():StartRecording(self.m_sFilePath)
    WZLog("WGCloudVoiceNotify:StartRecording path:",self.m_sFilePath,ret)
    if ret ~= 0 then
    	if ret ~= 4102 then
			SoundManager:resumeBackgroundMusic()
		end
    end
    return ret
end

--@brief   取消录制语音
--@param 
function WGCloudVoiceNotify:CancelRecording()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:CancelRecording()
	end
	WZLog("WGCloudVoiceNotify:CancelRecording:")
	if not self.m_bSupport then return end
	GCloudVoiceBridge:GetVoiceEngine():StopRecording()
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if true or platForm == 2 then
		SoundManager:resumeBackgroundMusic()
	end
end

--@brief    停止录制语音，并上传
--@param #filePath 语音文件的存储路径
function WGCloudVoiceNotify:StopRecording()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:StopRecording()
	end
	WZLog("WGCloudVoiceNotify:StopRecording")
	if not self.m_bSupport then return end
	local state = GCloudVoiceBridge:GetVoiceEngine():StopRecording()
	WZLog("WGCloudVoiceNotify:StopRecording result = ",state)
	GCloudVoiceBridge:GetVoiceEngine():UploadRecordedFile(self.m_sFilePath, 60000)
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if true  or platForm == 2 then
		SoundManager:resumeBackgroundMusic()
	end
end

--@brief   翻译文字
--@param #filePath 语音文件的存储路径
function WGCloudVoiceNotify:SpeechToText(fileID)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:SpeechToText(fileID)
	end
	WZLog("WGCloudVoiceNotify:SpeechToText")
	if not self.m_bSupport then return end
	GCloudVoiceBridge:GetVoiceEngine():SpeechToText(fileID, 60000, 0) 
end

--@brief    上传语音文件回调
--@return
function WGCloudVoiceNotify:OnUploadFile(sJson)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:OnUploadFile(sJson)
	end
	WZLog("WGCloudVoiceNotify:OnUploadFile:",sJson)
	local tResult = json.decode(sJson)
	if tResult.code  == GV_ON_UPLOAD_RECORD_DONE then
		local tVoice = {}
		tVoice.filePath = tResult.filePath
		tVoice.id = tResult.fileID
		WGCloudVoiceNotify:_addVoice(tVoice)
		g_fileId = tVoice.id
		local tab = {}
		tab.fileID = tResult.fileID
		tab.chatChannel,tab.recPlayerId=self:getExtends(tResult.filePath)
		tab.time = GCloudVoiceBridge:getAudioLength(tResult.filePath)
		WndChat:recRecordCallback(tab)	
	end
end

--@brief    获取扩展信息
--@return
function WGCloudVoiceNotify:getExtends(filePath)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:getExtends(filePath)
	end
	WZLog("WGCloudVoiceNotify:getExtends:",filePath)
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
function WGCloudVoiceNotify:StopPlayFile()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:StopPlayFile()
	end
	if not self.m_bSupport then return end
	GCloudVoiceBridge:GetVoiceEngine():StopPlayFile();
	SoundManager:resumeBackgroundMusic()
end

--@brief  播放语音(其实是先下载，下载成功后在播放)
function WGCloudVoiceNotify:PlayRecordedFile(fileId)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:PlayRecordedFile(fileId)
	end
	if not self.m_bSupport then return end
	WZLog("WGCloudVoiceNotify:PlayRecordedFile:",fileId)
	--GCloudVoiceBridge:GetVoiceEngine():StopPlayFile();--先停止播放先，免得边播边下
	for k,v in pairs(self.m_tVoiceMsg) do
		if v.id == fileId then
			local ret = WGCloudVoiceNotify:playRecorded(v.filePath)
			return ret
		end
	end
	local downPath = CCFileUtils:sharedFileUtils():getTmpWritablePath().."down_"..os.time()
	local ret = GCloudVoiceBridge:GetVoiceEngine():DownloadRecordedFile(fileId, downPath, 60000)
	return ret
end

--@brief    下载语音文件回调
--@return
function WGCloudVoiceNotify:OnDownloadFile(sJson)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:OnDownloadFile(sJson)
	end
	WZLog("WGCloudVoiceNotify:OnDownloadFile:",sJson)
	local tResult = json.decode(sJson)
	if tResult.code == GV_ON_DOWNLOAD_RECORD_DONE then
		local ret =  WGCloudVoiceNotify:playRecorded(tResult.filePath)
		return ret
	end
	return -1
end

--@brief    下载语音文件回调
--@return
function WGCloudVoiceNotify:playRecorded(filePath)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:playRecorded(filePath)
	end
	WZLog("WGCloudVoiceNotify:playRecorded:", filePath)
	SoundManager:pauseBackgroundMusic()
	local ret = GCloudVoiceBridge:GetVoiceEngine():PlayRecordedFile(filePath)
	return ret
end

--@brief    加入小队语言
--@return
function WGCloudVoiceNotify:JoinTeamRoom(roomName)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:JoinTeamRoom(roomName)
	end
	WZLog("WGCloudVoiceNotify:JoinTeamRoom:", roomName)
	if not self.m_bSupport then return end
	self:SetMode(0) --设置下模式
	if self.m_sRoomName ~= "" and roomName ~= self.m_sRoomName then
		self:QuitRoom(self.m_sRoomName)
        self.m_sRoomName = ""
	end
	local ret = GCloudVoiceBridge:GetVoiceEngine():JoinTeamRoom(roomName,10000)
    if ret == 0 then 
        self.m_sRoomName = roomName
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
    WZLog("WGCloudVoiceNotify:JoinTeamRoom:", roomName,ret)
    return ret
end   

--@brief   屏蔽某个人的消息
--@return
function WGCloudVoiceNotify:ForbidMemberVoice(id,bForbid)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:ForbidMemberVoice(id,bForbid)
	end
	if not self.m_bSupport then return end
	WZLog("WGCloudVoiceNotify:ForbidMemberVoice:", id,bForbid)
	GCloudVoiceBridge:GetVoiceEngine():ForbidMemberVoice(id,bForbid)
end

--@brief    离开小队语言
--@return
function WGCloudVoiceNotify:QuitRoom(roomName)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:QuitRoom(roomName)
	end
	if not self.m_bSupport then return end
	WZLog("WGCloudVoiceNotify:QuitRoom:", roomName)
	local ret = GCloudVoiceBridge:GetVoiceEngine():QuitRoom(roomName,10000)
    if ret == 0 then 
        self.m_sRoomName = ""
    end
    WZLog("WGCloudVoiceNotify:QuitRoom222:", self.m_nMusicVolume)
    if WZUISystem:getInstance():getPlatformInfo() == 1 then
   	 	AudioManager:setBackgroundMusicVolume(tonumber(self.m_nMusicVolume),true)
   	else
   		SoundManager:resumeBackgroundMusic()
   	end
    return ret 
end

--@brief   打开小队语言麦克风
--@return
function WGCloudVoiceNotify:OpenMic()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:OpenMic()
	end
	WZLog("WGCloudVoiceNotify:OpenMic:")
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
	GCloudVoiceBridge:GetVoiceEngine():OpenMic()
end

--@brief   关闭小队语言麦克风
--@return
function WGCloudVoiceNotify:CloseMic()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:CloseMic()
	end
	WZLog("WGCloudVoiceNotify:CloseMic:")
	if not self.m_bSupport then return end
	GCloudVoiceBridge:GetVoiceEngine():CloseMic()
	-- if WZUISystem:getInstance():getPlatformInfo() == 1 then
 --   	 	AudioManager:setBackgroundMusicVolume(tonumber(self.m_nMusicVolume),true)
 --   	else
 --   		SoundManager:resumeBackgroundMusic()
 --   	end
end

--@brief   打开小队语言扬声器
--@return
function WGCloudVoiceNotify:OpenSpeaker()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:OpenSpeaker()
	end
	WZLog("WGCloudVoiceNotify:OpenSpeaker:")
	if not self.m_bSupport then return end
	GCloudVoiceBridge:GetVoiceEngine():OpenSpeaker()
end

--@brief   关闭小队语言扬声器
--@return
function WGCloudVoiceNotify:CloseSpeaker()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:CloseSpeaker()
	end
	WZLog("WGCloudVoiceNotify:CloseSpeaker:")
	if not self.m_bSupport then return end
	GCloudVoiceBridge:GetVoiceEngine():CloseSpeaker()
end

--@brief   进入后台处理
--@return
function WGCloudVoiceNotify:Pause()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:Pause()
	end
	WZLog("WGCloudVoiceNotify:Pause:")
	if not self.m_bSupport then return end
	GCloudVoiceBridge:GetVoiceEngine():Pause()
end

--@brief    进入前台处理
--@return
function WGCloudVoiceNotify:Resume()
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:Resume()
	end
	WZLog("WGCloudVoiceNotify:Resume:")
	if not self.m_bSupport then return end
	GCloudVoiceBridge:GetVoiceEngine():Resume()
end

--@brief    Callback when JoinXxxRoom successful or failed.
--@return
function WGCloudVoiceNotify:OnJoinRoom(sJson)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:OnJoinRoom(sJson)
	end
	WZLog("WGCloudVoiceNotify:OnJoinRoom:",sJson)
	local tResult = json.decode(sJson)
    
    if self.m_nJoinRoomScheduleId > 0 then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nJoinRoomScheduleId)
        self.m_nJoinRoomScheduleId = 0
    end
    
	if tResult.code == GV_ON_JOINROOM_SUCC then
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
		local ret = GCloudVoiceBridge:GetVoiceEngine():JoinTeamRoom(self.m_sRoomName,10000)
		WZLog("WGCloudVoiceNotify:OnJoinRoom222:", ret)
        if ret ~= 0 then 
            self.m_nJoinRoomScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(joinWGCloudVoiceRoom, 0.2, false)
        end
	end
end

function joinWGCloudVoiceRoom(dt)
	if isUseGMEVoiceEngine() then
		return WGMEVoiceNotify:joinWGCloudVoiceRoom(dt)
	end
	if WGCloudVoiceNotify.m_sRoomName and WGCloudVoiceNotify.m_sRoomName ~= "" then
        local ret = GCloudVoiceBridge:GetVoiceEngine():JoinTeamRoom(WGCloudVoiceNotify.m_sRoomName,10000)
		WZLog("WGCloudVoiceNotify:OnJoinRoom222:", ret)
        if ret == 0 and WGCloudVoiceNotify.m_nJoinRoomScheduleId > 0 then 
            CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGCloudVoiceNotify.m_nJoinRoomScheduleId)
            WGCloudVoiceNotify.m_nJoinRoomScheduleId = 0
        end
    else 
       CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(WGCloudVoiceNotify.m_nJoinRoomScheduleId)
       WGCloudVoiceNotify.m_nJoinRoomScheduleId = 0 
    end
end
--@brief    Callback when dropped from the room
--@return
function WGCloudVoiceNotify:OnStatusUpdate(sJson)
	WZLog("WGCloudVoiceNotify:OnStatusUpdate:",sJson)
	
end

--@brief    Callback when QuitRoom successful or failed.
--@return
function WGCloudVoiceNotify:OnQuitRoom(sJson)
	WZLog("WGCloudVoiceNotify:OnQuitRoom:",sJson)
	local tResult = json.decode(sJson)
	if tResult.code == GV_ON_QUITROOM_SUCC then
		self:SetMode(2) --设置下模式
		self.m_sRoomName = ""
	else
		GCloudVoiceBridge:GetVoiceEngine():QuitRoom(tResult.roomName,10000)
	end
end

--@brief    Callback when someone saied or silence in the same room.
--@return
function WGCloudVoiceNotify:OnMemberVoice(sJson)
	WZLog("WGCloudVoiceNotify:OnMemberVoice:",sJson)
	voiceMemberState(sJson)
end

--@brief    Callback when finish a voice file play end.
--@return
function WGCloudVoiceNotify:OnPlayRecordedFile(sJson)
	WZLog("WGCloudVoiceNotify:OnPlayRecordedFile:",sJson)
	SoundManager:resumeBackgroundMusic()
	WndChat:callbackRecordPlayFinish()
end

--@brief    Callback when translate voice to text successful or failed.
--@return
function WGCloudVoiceNotify:OnSpeechToText(sJson,extend)
	WZLog("WGCloudVoiceNotify:OnSpeechToText:",sJson)
	local tResult = json.decode(sJson)
	if tResult.code == GV_ON_STT_SUCC then
		tResult.txt = extend or ""
		WndChat:callbackTranslateByRecord(tResult)
		--MsgBoxManager:showTipBox(unicode_to_utf8(tResult.result))
	end
end

--@brief     Callback when client is using microphone recording audio
--@return
function WGCloudVoiceNotify:OnRecording(sJson)
	WZLog("WGCloudVoiceNotify:OnRecording:",sJson)
	
end


--@brief    添加语言列表
--@return
function WGCloudVoiceNotify:_addVoice(tVoice)
	if #self.m_tVoiceMsg >= 100 then --删除第一条语音信息
	end
	table.insert( self.m_tVoiceMsg, tVoice)
	
end
