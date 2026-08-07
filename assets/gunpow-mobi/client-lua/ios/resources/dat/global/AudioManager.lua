--AudioManager.lua
--@brief	音频通用接口
--@date		2013/1/26
--@author	create:罗剑锋  modified:张凯,叶威（规范整理）


AudioManager =
{
	
	m_pAudio = nil,								--声音接口
	m_bBackgroundMusicState = true,             --背景音
	m_bEffectState = true,						--音效
	m_bIsMute = false,							--静音
	m_sCurBackGroundMusic = "",					--当前背景音乐路径
	m_bBackLoop = false,
	m_sEffectMusic = "",
	m_bEffectLoop = false,
	m_iCurEffectId = nil,						--当前播放音效的id
    m_tEffectsPlayed = nil                      --记录播放过的音效
}


-------------------------------------公有方法模块Begin--------------------------------------


--@brief 初始化
--@param bMusic:是否打开背景音
--@param bSound:是否打开音效
function AudioManager:init(bMusic, bSound)
    self.m_tEffectsPlayed = nil
	WZLog("AudioManager:Init")
	self:shareAudio()

	self:_setBackgroundMusicState(bMusic)
	self:_setEffectState(bSound)

	local data = WZDataFile:getInstance():getUserData()
  	if data then
        local musicVolume = data:getStringValue("Volume", "musicVolume")
        local soundVolume = data:getStringValue("Volume", "soundVolume")
        if musicVolume ~= nil and musicVolume ~= "" then
           self:setBackgroundMusicVolume(tonumber(musicVolume))
        else
           self:setBackgroundMusicVolume(0.8)		
        end
        if soundVolume ~= nil and soundVolume ~= "" then
           self:setEffectsVolume(tonumber(soundVolume))	
        else
           self:setEffectsVolume(1.0)
        end
  end
end

--@brief 播放背景音乐
function AudioManager:playBackgroundMusic(szFileName, bLoop)
	if self.m_sCurBackGroundMusic == szFileName and self.m_bBackLoop == bLoop then 
        return
    end
    self.m_sCurBackGroundMusic = szFileName
	self.m_bBackLoop = bLoop
    
	self:_refreshBackgroundMusic()
end

--@brief 停止背景音乐
function AudioManager:stopBackgroundMusic()
	if self.m_pAudio ~= nil then
		self.m_pAudio:stopBackgroundMusic(false)
	end
end

--@brief 播放音效
function AudioManager:playEffectMusic(szFileName, bLoop)
	self.m_sEffectMusic = szFileName
	self.m_bEffectLoop = bLoop
    
	return self:_refreshEffectMusic()
end

--@brief 停止播放当前音效
function AudioManager:stopEffectMusic(nId)
    if nId == nil then 
        nId = self.m_iCurEffectId
    end
	if nId ~= nil and self:shareAudio() ~= nil then
			self:shareAudio():stopEffect(nId)
	end
end

--@brief 清除所有音频
function AudioManager:destoryAll()
    WZLog("AudioManager:destoryAll")
	if self.m_pAudio == nil then
        return
	end
    self.m_pAudio:stopBackgroundMusic(false)
	self:_clearAllEffectSound()
end
--@brief 获得音频底层接口
function AudioManager:shareAudio()
	self.m_pAudio = SimpleAudioEngine:sharedEngine()
    return self.m_pAudio
end

--@brief 是否打开了背景音乐
--@return #1,是否打开的bool变量
function AudioManager:isBackgroundMusicOpen()
	return self.m_bBackgroundMusicState == true
end

--@brief  是否在播放背景音乐
--@return #1 true 正在播放背景音乐  false 没有在播放背景音乐
function AudioManager:isBackgroundMusicPlaying()
    if self.m_pAudio == nil then return false end 
    return self:shareAudio():isBackgroundMusicPlaying()
end
--@brief 是否打开了音效
--@return #1,是否打开的bool变量
function AudioManager:isEffectOpen()
	return self.m_bEffectState == true
end
--@brief 是否设置了静音
--@return #1,是否打开的bool变量
function AudioManager:isMute()
	return self.m_bIsMute == true
end

function AudioManager:getMuteState()
	return self.m_bIsMute
end

--@brief 操作静音开关
function AudioManager:setMuteState(bMute)
	self:_setMuteState(bMute)

	self:_refreshBackgroundMusic()
	self:_refreshEffectMusic()
end
--@brief 操作背景音乐开关
function AudioManager:setBackgroundMusicState(bBackgroundMusic)
	WZLog("setBackgroundMusicState")
	self:_setBackgroundMusicState(bBackgroundMusic)

	--self:_refreshBackgroundMusic()
end
--@brief 操作音效开关
function AudioManager:setEffectState(bEffect)
	if self.m_pAudio == nil then return end
	self:_setEffectState(bEffect)
--	self:_refreshEffectMusic()
end

--@brief 设置当前背景音乐音量
--param  nVolume:音量大小 0-1
function AudioManager:setBackgroundMusicVolume(nVolume,bPassSave)
	WZLog("AudioManager:setBackgroundMusicVolume")
	if self.m_pAudio == nil then
        return
    end
    local data = WZDataFile:getInstance():getUserData()
  	if not bPassSave and data then
        data:setStringValue("Volume", "musicVolume", nVolume)
        data:flush()
  	end
	self.m_pAudio:setBackgroundMusicVolume(nVolume)
	if nVolume <= 0 then
		self:_setBackgroundMusicState(false)
		PostPlayerEvent:postEvent(PostPlayerEvent.event_closeMusic)
	else
		self:_setBackgroundMusicState(true)
	end
end

--@brief 设置当前背景音乐音量
--param  nVolume:音量大小 0-1
function AudioManager:setBackgroundMusicVolumeIntenal(nVolume)
	WZLog("AudioManager:setBackgroundMusicVolume")
	if self.m_pAudio == nil then
        return
    end
	self.m_pAudio:setBackgroundMusicVolume(nVolume)
	if nVolume <= 0 then
		self:_setBackgroundMusicState(false)
	else
		self:_setBackgroundMusicState(true)
	end
end

--@brief 设置音效音量
--param  nVolume:音量大小 0-1
function AudioManager:setEffectsVolume(nVolume)
	WZLog("AudioManager:SetEffectsVolume")

	if self.m_pAudio == nil then
        return
    end
    local data = WZDataFile:getInstance():getUserData()
  	if data then
        data:setStringValue("Volume", "soundVolume", nVolume)
        data:flush()
  	end
	self.m_pAudio:setEffectsVolume(nVolume)
	if nVolume <= 0 then
		self:_setEffectState(false)
		PostPlayerEvent:postEvent(PostPlayerEvent.event_closeEffect)
	else
		self:_setEffectState(true)
	end
end


--@brief 获得音效音量
--@return #1:音量大小
function AudioManager:getEffectsVolume()
	if self.m_pAudio == nil then
        return 0
    end
	return self.m_pAudio:getEffectsVolume() or 0
end


--@brief 获取当前背景音乐音量
--@return #1:音量大小
function AudioManager:getBackgroundMusicVolume()

	if self.m_pAudio == nil then 
		return 0 
	end
	return self.m_pAudio:getBackgroundMusicVolume() or 0
end

--@brief 预载音效
--@param sName:文件名
function AudioManager:preloadEffectSound( sName )

	if self.m_pAudio == nil then 
		return
	end
	local platForm =  WZUISystem:getInstance():getPlatformInfo()
	if platForm == 13 then
		sName = string.gsub(sName,".mp3",".wav")
	end

	local fullpath = CCFileUtils:sharedFileUtils():fullPathForFilename(sName)
	local bExist = WZFileUtil:isFileExist(fullpath)
	if not bExist then
		return
	end

	self.m_pAudio:preloadEffect(fullpath)
end


--@brief  暂停当前背景音乐播放
function AudioManager:pauseBackgroundMusic()
    if self.m_pAudio then
        self.m_pAudio:pauseBackgroundMusic()
    end
end

--@brief  恢复背景音乐播放
function AudioManager:resumeBackgroundMusic()
    if self.m_pAudio then
        self.m_pAudio:resumeBackgroundMusic()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 设置背景音乐的状态
--@param bOpen:是否打开
function AudioManager:_setBackgroundMusicState(bOpen)
		self.m_bBackgroundMusicState = bOpen
end
--@brief 设置静音状态
--@param bMute:是否静音
function AudioManager:_setMuteState(bMute)
	self.m_bIsMute = bMute
end
--@brief 设置音效状态
--@param bEffect:是否打开
function AudioManager:_setEffectState(bEffect)
	self.m_bEffectState = bEffect
end

--@brief 刷新背景音
function AudioManager:_refreshBackgroundMusic()
    WZLog("AudioManager:_refreshBackgroundMusic",self:isBackgroundMusicOpen(),self:isMute(),self.m_sCurBackGroundMusic)
	if self:shareAudio() == nil then
        return
    end
	
	if self:isBackgroundMusicOpen() and not self:isMute() and self.m_sCurBackGroundMusic~=nil and self.m_sCurBackGroundMusic~="" then
		local platForm =  WZUISystem:getInstance():getPlatformInfo()
		local sName = self.m_sCurBackGroundMusic
		if platForm == 13 then
			sName = string.gsub(sName,".mp3",".wav")
		end
		local filePath = CCFileUtils:sharedFileUtils():fullPathForFilename(sName)
		local isExist = WZFileUtil:isFileExist(filePath)
		if isExist then
            WZLog("fileName:"..tostring(self.m_sCurBackGroundMusic))
			self:shareAudio():playBackgroundMusic(filePath,self.m_bBackLoop)
        else
			WZLog("--background music file is not exist! fn:"..tostring(self.m_sCurBackGroundMusic))
		end
    else
		self:shareAudio():stopBackgroundMusic(false)
	end
end
--@brief 刷新音效
function AudioManager:_refreshEffectMusic()
	if self.m_pAudio == nil then
        return 0
    end
    WZLog("AudioManager:_refreshEffectMusic",self:isEffectOpen(),self:isMute())
    WZLog(self.m_sEffectMusic)
	if not self:isEffectOpen() or self:isMute() then
		if self.m_iCurEffectId ~= nil then
			self.m_pAudio:stopEffect(self.m_iCurEffectId)
			self.m_iCurEffectId = nil
			self.m_sEffectMusic = ""
			self.m_bEffectLoop = false
		end
    else
		--文件名错误
		if self.m_sEffectMusic==nil or self.m_sEffectMusic=="" or string.find(self.m_sEffectMusic,".")==nil then
            return 0
        end
		local platForm =  WZUISystem:getInstance():getPlatformInfo()
		local sName = self.m_sEffectMusic
		if platForm == 13 then
			sName = string.gsub(sName,".mp3",".wav")
		end
		local filePath = CCFileUtils:sharedFileUtils():fullPathForFilename(sName)
		local isExist = WZFileUtil:isFileExist(filePath)
        
		if isExist then
			--播放
			self.m_iCurEffectId = self.m_pAudio:playEffect(filePath, self.m_bEffectLoop)
			WZLog("m_iCurEffectId="..tostring(self.m_iCurEffectId), self.m_sEffectMusic)
            self:_addEffectSound(self.m_iCurEffectId)
			return self.m_iCurEffectId
        else
			WZLog("--effect file is not exist! fn:"..tostring(self.m_sEffectMusic))
		end
		return 0;
	end
end

--@brief 添加音效到音效表
--@param id:音效id
function AudioManager:_addEffectSound(id)
    if self.m_tEffectsPlayed == nil then
        self.m_tEffectsPlayed = {}
    end
    table.insert(self.m_tEffectsPlayed,id)
end

--@brief 清除所有音效
function AudioManager:_clearAllEffectSound()
    if self.m_tEffectsPlayed == nil or type(self.m_tEffectsPlayed) ~= "table" then
        return
    end
    for i=1,#self.m_tEffectsPlayed do
        if self.m_pAudio ~= nil then
            self.m_pAudio:stopEffect(self.m_tEffectsPlayed[i])
        end
    end
    self.m_tEffectsPlayed = nil
end


-------------------------------------私有方法模块End----------------------------------------







