--WndSpaceTape.lua
--@brief	WndSpaceTape的UI模块
--@date		2016/01/18
--@author	zsq
--@note		录音


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpaceTape:onEnter(element)
	self.m_root = element
	GetElement(self.m_root,"conBefore",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conTaping",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conFinish",WZUIContainer):setVisible(false)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpaceTape:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndSpaceTape:onClose(element)
	if self.m_bPlaying == true then self:resumeBgMusic() self.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	确定按钮点击回调
function WndSpaceTape:onClose1(element)
	if self.m_bPlaying == true then self:resumeBgMusic() self.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	确定保存录音
function WndSpaceTape:onConfirm()
	if self.m_bPlaying == true then self:resumeBgMusic() self.m_bPlaying = false end
	if self.m_nTime == nil then self.m_nTime = 0 end

	--上传录音
	local s = {} 
	s.objName = self.m_nTime.."_"..ProjConfig:getChannelId().."_"..WndSpaceMain.m_nPlayerId.."_"..os.time().."_tape.mp3"
	s.filePath = self.m_sTape
	local sJson =  json.encode(s) 
	DSSdkManager:putFile(sJson,WndSpaceDetail.onUploadFinish,WndSpaceDetail)
	WZLog("上传文件名",s.objName)

	WndSpaceMain.m_tData.voiceInfo = s.objName
	--WndSpaceDetail:update()
	--WndSpaceMain:sendProtocol()

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	开始录音
function WndSpaceTape:onBeagn(element)
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--暂停背景音乐
	SoundManager:pauseBackgroundMusic()

	GetElement(self.m_root,"conTaping",WZUIContainer):setVisible(true)

	local result = WZDeviceHelper:sharedDeviceHelper():startRecord(50)
	self.m_root:enableSchedule("scheduleTime",1)
	self.m_nTime = 0
end

function WndSpaceTape:scheduleTime()
	GetElement(self.m_root,"taping_time",WZUILabelTTF):setText(self.m_nTime.."s")
	self.m_nTime = self.m_nTime + 1
end

--@brief	取消录音
function WndSpaceTape:onCancel(element)
	GetElement(self.m_root,"conTaping",WZUIContainer):setVisible(false)
 	WZDeviceHelper:sharedDeviceHelper():stopRecord()
end

--@brief	删除录音
function WndSpaceTape:onDelete(element)
	if self.m_bPlaying == true then self:resumeBgMusic() self.m_bPlaying = false end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    MsgBoxManager:showConfirmBox(LocalStrings.SPACE53, self, self.onDeleteCall, MSGBOXLEVEL_HIGH, nil,false)
end

--@brief	删除录音回调
function WndSpaceTape:onDeleteCall(element)
	WndSpaceMain.m_tData.voiceInfo = ""
	WndSpaceMain:sendProtocol()
	MsgBoxManager:showTipBox(LocalStrings.SPACE49)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	完成录音
function WndSpaceTape:onFinish(element)
	GetElement(self.m_root,"conBefore",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTaping",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conFinish",WZUIContainer):setVisible(true)
 	self.m_sTape = WZDeviceHelper:sharedDeviceHelper():stopRecord()
	self.m_root:disableSchedule()
	GetElement(self.m_root,"tapeFinishTime",WZUILabelTTF):setText(self.m_nTime..[["]])
	GetElement(self.m_root,"btnConfirm",WZUIButton):setVisible(true)
	GetElement(self.m_root,"btnClose",WZUIButton):setVisible(false)

	--恢复背景音乐
	SoundManager:resumeBackgroundMusic()
end

--@brief	设置完成界面
function WndSpaceTape:setFinish(displayTime)
	GetElement(self.m_root,"conBefore",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conTaping",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conFinish",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"tapeFinishTime",WZUILabelTTF):setText(displayTime)
	GetElement(self.m_root,"btnConfirm",WZUIButton):setVisible(false)
	GetElement(self.m_root,"btnClose",WZUIButton):setVisible(true)
end

--@brief	播放录音
function WndSpaceTape:onBroadcast(element)
	WZLog("WndSpaceTape:onBroadcast",self.m_sTape)
	if self.m_bPlaying == true then return end
	if self.m_sTape == nil or self.m_sTape == "" then return end
	--记住当前是否打开背景音乐
	self.nBgMusicState = SoundManager.nBgMusicState
	local fileName = string.match(self.m_sTape, ".+/([^/]*%.%w+)$")
	local prefix
	if string.find(fileName,"_") == nil then
		self.m_nCountdown = self.m_nTime
	else
		prefix = string.sub(fileName,1,string.find(fileName,"_")-1)
		if tonumber(prefix) ~= nil then
			self.m_nCountdown = tonumber(prefix)
		else
			self.m_nCountdown = self.m_nTime
		end
	end
	WZLog("文件名前缀是",prefix,self.m_nCountdown)
	--打开背景音乐
	SoundManager:setBgMusicMute(1)
	SAVEDBGMUSIC = SoundManager.m_fileKey
	SoundManager:playBgMusic(self.m_sTape,false)
	WZLog("播放录音",self.m_sTape)
	self.m_bPlaying = true

	self.m_root:enableSchedule("scheduleBGM",1)
end

--@brief	录音播放完后恢复背景音乐状态
function WndSpaceTape:scheduleBGM()
	WZLog("WndSpaceTape:scheduleBGM",SoundManager:isBackgroundMusicPlaying(),self.m_nCountdown,self.nBgMusicState)
	if self.m_nCountdown == nil then
		self:resumeBgMusic()
		self.m_root:disableSchedule()
		self.m_bPlaying = false
	end
	self.m_nCountdown = self.m_nCountdown - 1
	if self.m_nCountdown <= 0 then
		WZLog("播放结束")
		self:resumeBgMusic()
		self.m_root:disableSchedule()
		self.m_bPlaying = false
	end
end

--@brief	中断录音时的处理
function WndSpaceTape:resumeBgMusic()
	if self.m_bPlaying == false then return end
	--恢复之前的背景音乐设置
	if self.nBgMusicState ~= nil then
		SoundManager:setBgMusicMute(self.nBgMusicState)
	end
	--播放之前的背景音乐
	if SAVEDBGMUSIC == nil then
		SoundManager:playBgMusic(SoundDefine.E_MUSIC_ISLAND)
	else
		SoundManager:playBgMusic(SAVEDBGMUSIC)
	end
	if self.nBgMusicState == 0 then
		SoundManager:stopBgMusic()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
