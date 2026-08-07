--SoundManager.lua
--@brief	音乐和音效播放管理
--@date		2013/1/26
--@author	叶威
SoundManager =
{
    nBgMusicState = 1,   --背景音乐静音状态，1,为打开，0为关闭，默认为1
    nEffectState = 1 ,     --音效静音状态，1,为打开，0为关闭，默认为1
    nCurrentBackgroundVolumne = 0.8, --当前背景音乐大小
}

--------------------------------------公有方法Begin-----------------------------------

--@brief 初始化
--@note  需在程序运行开始进行初始化
function SoundManager:init()
    WZLog("SoundManager:init")
    
    local data = WZDataFile:getInstance():getUserData()
    
    if data ~=  nil then
		local nBgMusicState = data:getStringValue(MUSIC_DATA, BG_MUSIC_STATE)
        local nBgEffectState = data:getStringValue(MUSIC_DATA, EFFECT_STATE)
        if nBgMusicState == nil or nBgMusicState == "" then
            nBgMusicState = "1"
        end
        if nBgEffectState == nil or nBgEffectState == "" then
            nBgEffectState = "1"
        end
        self:setBgMusicMute(tonumber(nBgMusicState))
        self:setEffectSoundMute(tonumber(nBgEffectState))
	end
    
    if SoundManager.m_bInited == true then
        return
    end
    SoundManager.m_bInited = true
	SoundManager:stopBgMusic()
    AudioManager:init(true, true)
    self:_preLoadFiles()
    self:setBgMusicMute(self.nBgMusicState)
    self:setEffectSoundMute(self.nEffectState)
    --读取本地音频开关信息    
end

--@brief 播放背景音乐
--@param fileKey:文件名变量，参看SoundDefine中的定义
--@param bLoop:是否循环播放,可选，默认为true，
function SoundManager:playBgMusic(fileKey,bLoop)
    WZLog("SoundManager:playBgMusic",fileKey)
    if fileKey == nil then
        WZLog("fileKey is nil")
        return
    end
    if bLoop == nil then
        bLoop = true
    end
    self.m_fileKey = fileKey
    AudioManager:playBackgroundMusic(fileKey, bLoop)
end

--@brief 停止背景音乐
function SoundManager:stopBgMusic()
    WZLog("SoundManager:stopBgMusic")
    AudioManager:stopBackgroundMusic()
end

--@brief  是否在播放背景音乐
--@return #1 true 正在播放背景音乐  false 没有在播放背景音乐
function SoundManager:isBackgroundMusicPlaying()
    return AudioManager:isBackgroundMusicPlaying()
end

--@brief 预载音效
--@param sName:文件名
function SoundManager:preloadEffectSound( sName )
    WZLog("SoundManager:preloadEffectSound:"..sName)
    AudioManager:preloadEffectSound( sName )
end

--@brief 播放音效
--@param fileKey:文件名变量，参看SoundDefine中的定义
--@param bLoop:是否循环播放,可选，默认为false
function SoundManager:playEffectSound(fileKey,bLoop,isRolePath)
    WZLog("SoundManager:playEffectSound")
    if fileKey == nil then
        WZLog("fileKey is nil")
        return 0
    end
    if bLoop == nil then
        bLoop = false
    end
    if isRolePath then
        fileKey = GetRoleSound() .. "/" .. fileKey
    end
    return AudioManager:playEffectMusic(fileKey, bLoop)
end

--@brief 停止当前音效
function SoundManager:stopEffectSound(nId)
    WZLog("SoundManager:stopBgMusic")
    AudioManager:stopEffectMusic(nId)
end

--@brief 设置背景音打开状态
--@param nOpen:是否打开，0:不打开，1：打开
--@param bSave:是否保存信息到本地，可选，默认不保存
function SoundManager:setBgMusicMute(nOpen,bSave)
    local bOpen = false
    if nOpen == 1 then
        bOpen = true
    end
    --更新静音状态全局数据
    self.nBgMusicState = nOpen
    if bSave then
        local data = WZDataFile:getInstance():getUserData()
		if data ~= nil then
			data:setStringValue(MUSIC_DATA, BG_MUSIC_STATE, tostring(nOpen))
			data:flush()
		end
    end
    AudioManager:setBackgroundMusicState(bOpen)
end

--@brief 设置音效打开状态
--@param nOpen:是否打开，0:不打开，1：打开
--@param bSave:是否保存信息到本地，可选，默认不保存
function SoundManager:setEffectSoundMute(nOpen,bSave)
    local bOpen = false
    if nOpen == 1 then
        bOpen = true
    end
    --更新静音状态全局数据
    self.nEffectState = nOpen
    if bSave then
        local data = WZDataFile:getInstance():getUserData()
		if data ~= nil then
			data:setStringValue(MUSIC_DATA, EFFECT_STATE, tostring(nOpen))
			data:flush()
		end
    end
    AudioManager:setEffectState(bOpen)
end

--@brief 程序进入后台时候音频的处理
function SoundManager:enterBackGround()
     self.nCurrentBackgroundVolume = AudioManager:getBackgroundMusicVolume()
     AudioManager:setBackgroundMusicVolumeIntenal(0)
     if  self.nBgMusicState == 1 then
        AudioManager:setBackgroundMusicState(false)
        AudioManager:_refreshBackgroundMusic()
     end
     if  self.nEffectState == 1 then
        AudioManager:setEffectState(false)
     end
end 

--@brief 程序进入前台时候音频的处理
function SoundManager:enterForeGround()
     if self.nCurrentBackgroundVolume ~= nil and self.nCurrentBackgroundVolume > 0 then 
        AudioManager:setBackgroundMusicVolumeIntenal(self.nCurrentBackgroundVolume)
     else 
        local data = WZDataFile:getInstance():getUserData()
        if data then
            local musicVolume = data:getStringValue("Volume", "musicVolume")
            if musicVolume ~= nil and musicVolume ~= "" then
               AudioManager:setBackgroundMusicVolumeIntenal(tonumber(musicVolume))
            else
               AudioManager:setBackgroundMusicVolumeIntenal(0.8)		
            end
        else
            AudioManager:setBackgroundMusicVolumeIntenal(0.8)
        end
     end     
     if  self.nBgMusicState == 1 then
        AudioManager:setBackgroundMusicState(true)
		AudioManager:_refreshBackgroundMusic()
     end
     if  self.nEffectState == 1 then
        AudioManager:setEffectState(true)
     end
end

----------------------------add 2015-04-23-----------------------
--@brief 设置当前声音的状态
function SoundManager:setSoundState(n_state,b_save)
    WZLog("SoundManager:setSoundState",tostring(n_state), tostring(b_save))
     SoundManager:setEffectSoundMute(n_state,b_save)
     --SoundManager:setBgMusicMute(n_state,b_save)
end

--@brief 获得当前声音的状态
function SoundManager:getSoundState()
     return self.nBgMusicState and self.nEffectState
end

--@brief 获得当前声音的状态
function SoundManager:getState()
     return self.nBgMusicState, self.nEffectState
end

--@brief  暂停当前背景音乐播放
function SoundManager:pauseBackgroundMusic()
    if self.nBgMusicState == 1 then
        AudioManager:pauseBackgroundMusic()
    end
end

--@brief  恢复背景音乐播放
function SoundManager:resumeBackgroundMusic()
    if self.nBgMusicState == 1 then
        AudioManager:resumeBackgroundMusic()
    end
end


--------------------------------------公有方法End-----------------------------------

--------------------------------------私有方法Begin-----------------------------------

--@brief 预载音效
function SoundManager:_preLoadFiles()
    WZLog("xxxxxxxxxxxxxxxxxx")
     local preList = SoundDefine.preloadList
     WZLog(preList)
      WZLog(#preList)
     if preList == nil or type(preList) ~= "table" then
        WZLog("yyyyyyyyyyyyyyy")
        return
     end
     for k,v in pairs(preList) do
        self:preloadEffectSound(v)
     end

end
--------------------------------------公有方法End-----------------------------------
