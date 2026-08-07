--WndBattleSetting.lua
--@brief	WndBattleSetting的UI模块
--@date		2013/1/16
--@author	Zjh
--@note		战斗设置界面

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBattleSetting:onEnter(element)
    WZLog("WndBattleSetting:onEnter")
	self.m_root = element
    --多语言版本界面适配
	AdaptLanguage(self)
	--多语言版本文本
    self:_initSoundCheckBox()
	self:_moreLanguage()
	self:_updateLanguageText()
    self:_setVoiceState()
    self:_setExitGameEnable()
    
    --self:onClickMusic(nil,nil,SoundManager.nBgMusicState)

    local state = SoundManager.nBgMusicState
    local img = GetElement(self.m_root,"imgMusic_WndBattleSetting",WZUIImage)
    if state == 1 then
        img:setRelativePositionLuaTo(0.656,0.615196)
    else
        img:setRelativePositionLuaTo(0.575,0.615196)
    end

    local state = SoundManager.nEffectState
    local img = GetElement(self.m_root,"imgEffectSound_WndBattleSetting",WZUIImage)
    if state == 1 then
        img:setRelativePosition(GlobalMethod:ccp(0.656,0.615196))
    else
        img:setRelativePosition(GlobalMethod:ccp(0.575,0.615196))
    end

    self:initLineStyleData()

    if ProjConfig.DEBUG == 1 then
        --WBattleGlobal:getCurrent():getCurrentCharacter().m_bUseBigSkill = true
        --WBattleGlobal:getCurrent():getMyHero():setSp(100)
    end
end

function WndBattleSetting:setState()
    local state = SoundManager.nBgMusicState
    WZLog("WndBattleSetting:setState", tostring(sender), tostring(sender2), tostring(state), SoundManager.nBgMusicState, SoundManager.nEffectState)

    local img = GetElement(self.m_root,"imgMusic_WndBattleSetting",WZUIImage)
    if state ~= 1 then
        img:setRelativePositionLuaTo(0.656,0.615196)
    else
        img:setRelativePositionLuaTo(0.567,0.615196)
    end

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBattleSetting:onExit(element)
	self:_unInit()
end

--@brief 初始化声音,改变声音的checkbox状态
function WndBattleSetting:_initSoundCheckBox()
    --                                                                         
    self.m_initMusicVolume = math.floor(AudioManager:getBackgroundMusicVolume() * 100)
    self.m_initSoundVolume = math.floor(AudioManager:getEffectsVolume() * 100)
    
    GetElement(self.m_root, "txtMusic_WndSetting", WZUILabelTTF):setText(self.m_initMusicVolume)
    GetElement(self.m_root, "txtSound_WndSetting", WZUILabelTTF):setText(self.m_initSoundVolume)

    local m,s = SoundManager:getState()
    WZLog("WndBattleSetting:_initSoundCheckBox:", self.m_initMusicVolume, self.m_initSoundVolume,m,s,type(m))
    if m == 0 then
        SoundManager:setBgMusicMute(1,true)
        AudioManager:_refreshBackgroundMusic()
    end
    if s == 0 then
        SoundManager:setEffectSoundMute(1,true)
    end
end

--@brief    语音自动播放checkbox的点击回调函数
--@param    element:表绑定的UI节点引用
function WndBattleSetting:onSoundDone( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleSetting:onSoundDone:",element:getTag())
    if self.m_addVolume == 0 then
        self.m_addVolume = 10
    else
        return
    end
    local tag =  element:getTag()
    self:setVolume(tag)
    element:disableSchedule()
end

--@brief    设置音量
--@param    tag
function WndBattleSetting:setVolume()

    if self.m_VolumeTag == 1 then --音乐减少
        self.m_initMusicVolume = math.max(0, self.m_initMusicVolume - 10)
        GetElement(self.m_root, "txtMusic_WndSetting", WZUILabelTTF):setText(self.m_initMusicVolume)
        AudioManager:setBackgroundMusicVolume(self.m_initMusicVolume/100)
    elseif self.m_VolumeTag == 2 then --音乐增加
        self.m_initMusicVolume = math.min(100, self.m_initMusicVolume + 10)
        GetElement(self.m_root, "txtMusic_WndSetting", WZUILabelTTF):setText(self.m_initMusicVolume)
        AudioManager:setBackgroundMusicVolume(self.m_initMusicVolume/100)
        if self.m_initMusicVolume == 10 then
            WZLog("WndBattleSetting:setVolume two")
            SoundManager:setBgMusicMute(1,true)
            AudioManager:_refreshBackgroundMusic()
        end
    elseif self.m_VolumeTag == 3 then --音效减少
        self.m_initSoundVolume = math.max(0, self.m_initSoundVolume - 10)
        GetElement(self.m_root, "txtSound_WndSetting", WZUILabelTTF):setText(self.m_initSoundVolume)
        AudioManager:setEffectsVolume(self.m_initSoundVolume/100)
    elseif self.m_VolumeTag == 4 then --音效增加
        self.m_initSoundVolume = math.min(100, self.m_initSoundVolume + 10)
        GetElement(self.m_root, "txtSound_WndSetting", WZUILabelTTF):setText(self.m_initSoundVolume)
        AudioManager:setEffectsVolume(self.m_initSoundVolume/100)
    end
end

--@brief    语音自动播放checkbox的点击回调函数
--@param    element:表绑定的UI节点引用
function WndBattleSetting:onSoundPush( element )
    WZLog("WndBattleSetting:onSoundPush:",element:getTag())
    self.m_addVolume = 0
    local tag =  element:getTag()
    self.m_VolumeTag = tag
    element:enableSchedule("updateVolume",0.5)
end

--@brief  更新音量的大小
function  WndBattleSetting:updateVolume(element)
    self:setVolume()
end

--@brief	退出按钮点击后的Lua回调
--@param	sender:退出按钮元素
--@note
function WndBattleSetting:onExitGame(sender)
    if WBattleGlobal:getCurrent().m_bIsWaitSynchronousBattle then
        return
    end

    if WBattleGlobal:getCurrent().m_isQuickCopyTest and WBattleGlobal:getCurrent():isSingleStage() then
        WBattleGlobal:getCurrent():testCopyEnd(false)
        WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
        return
    end

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    g_bIsShowWndDressUp = true
	
    if g_SpatterScheduleId then 
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(g_SpatterScheduleId)
        g_SpatterScheduleId = nil 
    end

    if WBattleGlobal:getCurrent():isSingleStage() then
        
        SceneBattle:leftBattle()
    else
        if WBattleGlobal:getCurrent():isAudience() then
            ProtocolProcessorGlobal:send_HERO_EndWatch(WBattleGlobal:getCurrent().m_tMakePairOk.battleId)
        else
            ProtocolProcessorBattleInterface:send_BATTLE_QuitBattle(WBattleGlobal:getCurrent().m_tMakePairOk.battleId,WBattleGlobal:getCurrent():getMyBattleId())
        end
        SceneBattle:leftBattle()
    end
end

--@brief	继续游戏按钮点击后的Lua回调
--@param	sender:继续游戏按钮元素
--@note
function WndBattleSetting:onContinueGame(sender)
    if SceneBattle:getBattlePointsLine() then
        SceneBattle:getBattlePointsLine():checkLineView()
    end
    if true and WBattleGlobal:getCurrent().m_isQuickCopyTest and WBattleGlobal:getCurrent():isSingleStage() then
        WBattleGlobal:getCurrent():testCopyEnd(true)
        WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
        return
    end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	--WindowManager:removeWindow(self.m_root, WndBattleSetting,true)
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
    
end


--@brief	退出场景时被调用的函数
function WndBattleSetting:onCloseActionCallback(elem,data)
    WZLog("WndBattleSetting:onCloseActionCallback",elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
    
end
--@brief onEnter函数执行完成回调
function WndBattleSetting:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndBattleSetting:actionCallback(element, data)
    self.m_root:enableSchedule("scheduleLoadUI", 0)
end

--@brief    加载界面元素定时器
function WndBattleSetting:scheduleLoadUI()
    self.m_root:disableSchedule()
end


--@brief	语音聊天按钮点击后的Lua回调
--@param	sender:游戏按钮元素
--@note
function WndBattleSetting:onSetVoiceChat(sender)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if VoiceChat.m_bIsOpenVoiceChat == false then
        return
    end
    --获取背景音乐checkbax的索引
	local index = self:_getVoiceChatStatic()
    --选中状态，由于控件的状态是回调后才改变，所以需要取反
    local sel = 1
    if index == 0 then
        sel = 1
        VoiceChat.m_bSetVoiceChat = 1
        VoiceChat:StopVoice()
        --WndBattleHud:setVoiceRecordVisible(false)
    else
        VoiceChat.m_bSetVoiceChat = 0
        sel = 0
        --播放语音聊天
        VoiceChat:playVoice()
        --WndBattleHud:setVoiceRecordVisible(true)
    end
end
--@brief	游戏背景音乐按钮点击后的Lua回调
--@param	sender:游戏按钮元素
--@note
function WndBattleSetting:onSetMusic(sender)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    --获取背景音乐checkbax的索引
	local index = self:_getBackMusicStatic()
    WZLog("WndBattleSetting:onSetMusic :" , index )
    --选中状态，由于控件的状态是回调后才改变，所以需要取反
    local sel = 1
    if index == 0 then
        sel = 1
        else
        sel = 0
    end
    --设置静音状态
    SoundManager:setBgMusicMute(sel,true)
end

--@brief	游戏音乐按钮点击后的Lua回调
--@param	sender:游戏按钮元素
--@note
function WndBattleSetting:onSetSounds(sender)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local index = self:_getGameMusicStatic()
    
	WZLog("WndBattleSetting:onSetSounds :" , index )
    --选中状态，由于控件的状态是回调后才改变，所以需要取反
    local sel = 1
    if index == 0 then
        sel = 1
    else
        sel = 0
    end
    --设置静音状态
    SoundManager:setEffectSoundMute(sel,true)
end

function WndBattleSetting:onClickMusic(sender,sender2, state)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    state = state or (1 - SoundManager.nBgMusicState)
    WZLog("WndBattleSetting:onClickMusic", tostring(sender), tostring(sender2), tostring(state), SoundManager.nBgMusicState, SoundManager.nEffectState)

    local img = GetElement(self.m_root,"imgMusic_WndBattleSetting",WZUIImage)
    if state == 1 then
        img:setRelativePositionLuaTo(0.656,0.615196)
    else
        img:setRelativePositionLuaTo(0.575,0.615196)
    end

    SoundManager:setBgMusicMute(state,true)
    AudioManager:_refreshBackgroundMusic()

end

function WndBattleSetting:onClickEffectSound(sender,sender2, state)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    state = state or (1 - SoundManager.nEffectState)
    WZLog("WndBattleSetting:onClickEffectSound", tostring(sender), tostring(sender2), tostring(state), SoundManager.nBgMusicState, SoundManager.nEffectState)

    local img = GetElement(self.m_root,"imgEffectSound_WndBattleSetting",WZUIImage)
    if state == 1 then
        img:setRelativePosition(GlobalMethod:ccp(0.656,0.615196))
    else
        img:setRelativePosition(GlobalMethod:ccp(0.575,0.615196))
    end

    SoundManager:setSoundState(state, true)
end


function WndBattleSetting:onLineDone(sender)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBattleSetting:onLineDone",tostring(self.m_bLineBtnSel))

   self:changeConLineSelView()
end

function WndBattleSetting:changeConLineSelView()
    self.m_bLineBtnSel = not self.m_bLineBtnSel

    GetElement(self.m_root,"conLineSel_WndBattleSetting",WZUIContainer):setVisible(self.m_bLineBtnSel)
    if self.m_bLineBtnSel then
        GetElement(self.m_root,"btnLine_WndBattleSetting",WZUIButton):setScaleY(-1)
    else
        GetElement(self.m_root,"btnLine_WndBattleSetting",WZUIButton):setScaleY(1)
    end
end

function WndBattleSetting:LineSelDone(sender)
    WZLog("WndBattleSetting:LineSelDone",sender:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if sender:getTag() == 101 then
        WndBattleHud.g_nPointLineStyle = 1
    elseif sender:getTag() == 102 then
        WndBattleHud.g_nPointLineStyle = 2
    elseif sender:getTag() == 103 then
        WndBattleHud.g_nPointLineStyle = 3
    else
        if CacheCenter:getPlayerInfo().vipLevel == 0 then
            MsgBoxManager:showTipBox(LocalStrings.LINE_VIP_ENGOUH)
            self:changeConLineSelView()
            return
        end
        WndBattleHud.g_nPointLineStyle = 4
    end
    self:setLineStyleData()
    self:changeConLineSelView()
    GetElement(self.m_root,"imgCurLine_WndBattleSetting",WZUIImage):setFile(string.format("ui/combat/lx_0%d.png",WndBattleHud.g_nPointLineStyle))
end

function  WndBattleSetting:initLineStyleData()
    self:getLineStyleData()
    GetElement(self.m_root,"imgCurLine_WndBattleSetting",WZUIImage):setFile(string.format("ui/combat/lx_0%d.png",WndBattleHud.g_nPointLineStyle))
end


function WndBattleSetting:setLineStyleData()
    local data = WZDataFile:getInstance():getUserData()
    if data then        
        data:setStringValue("BattleSetting", "lineStyle", WndBattleHud.g_nPointLineStyle)
        data:flush()
    end
end

--@brief    拉线类型
function WndBattleSetting:getLineStyleData()
    if WBattleGlobal:getCurrent():isWindTeach() or WBattleGlobal:getCurrent():isBossAndChapterOneTeach() or WBattleGlobal:getCurrent():isFirstPvp() then
        WndBattleHud.g_nPointLineStyle = 1
        return WndBattleHud.g_nPointLineStyle
    end
     local data = WZDataFile:getInstance():getUserData()
     if data ~=  nil then
        local value = data:getStringValue("BattleSetting", "lineStyle")
        if value ~= nil and value ~= "" then
            if not (tonumber(value) == 4 and CacheCenter:getPlayerInfo().vipLevel == 0) then
                WndBattleHud.g_nPointLineStyle = tonumber(value)
                return WndBattleHud.g_nPointLineStyle
            end
        end
    end
    WndBattleHud.g_nPointLineStyle = 1
    return WndBattleHud.g_nPointLineStyle
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获取背景音乐checkbax的索引
--@param	index:checkbax的索引,0为不选中,1为选中
function WndBattleSetting:_getBackMusicStatic()
	if self.m_root == nil then
		return
	end
	local selBackMusic = self.m_root:getChildElement("selBackMusic_WndBattleSetting")
	if selBackMusic == nil then
		return
	end
	selBackMusic = WZUICheckBox:luaTo(selBackMusic)
	local index = selBackMusic:getCheckIndex()
	return index
end
--@brief	获取游戏音乐checkbax的索引
--@param	index:checkbax的索引,0为不选中,1为选中
function WndBattleSetting:_getGameMusicStatic()
	if self.m_root == nil then
		return
	end
	local selGameMusic = self.m_root:getChildElement("selGameMusic_WndBattleSetting")
	if selGameMusic == nil then
		return
	end
	selGameMusic = WZUICheckBox:luaTo(selGameMusic)
	local index = selGameMusic:getCheckIndex()
	return index
end
--@brief	获取游戏音乐checkbax的索引
--@param	index:checkbax的索引,0为不选中,1为选中
function WndBattleSetting:_getVoiceChatStatic()
	if self.m_root == nil then
		return
	end
	local selVoice = self.m_root:getChildElement("selVoiceChat_WndBattleSetting")
	if selVoice == nil then
		return
	end
	selVoice = WZUICheckBox:luaTo(selVoice)
	local index = selVoice:getCheckIndex()
	return index
end
--@brief 设置语音聊天开关状态
function WndBattleSetting:_setVoiceState()
    local index = nil
    local item1 = GetElement(self.m_root,"item1_WndBattleSetting")
    local item2 = GetElement(self.m_root,"item2_WndBattleSetting")
    if VoiceChat.m_bIsOpenVoiceChat == false then
        GetElement(self.m_root,"item3_WndBattleSetting"):setVisible(false)
        item1:setRelativePositionLuaTo(0,0.25)
        item2:setRelativePositionLuaTo(0.52,0.25)
    else
        GetElement(self.m_root,"item3_WndBattleSetting"):setVisible(true)
        item1:setRelativePositionLuaTo(0,0.5)
        item2:setRelativePositionLuaTo(0.52,0.5)
    end
        
    if VoiceChat.m_bSetVoiceChat == 0 then
        index = 0
    else
        index = 1
    end

    --WZUICheckBox:luaTo(GetElement(self.m_root,"selVoiceChat_WndBattleSetting")):setCheckIndex(index)
    --WZUICheckBox:luaTo(GetElement(self.m_root,"selBackMusic_WndBattleSetting")):setCheckIndex(SoundManager.nBgMusicState)
    --WZUICheckBox:luaTo(GetElement(self.m_root,"selGameMusic_WndBattleSetting")):setCheckIndex(SoundManager.nEffectState)
end

--@brief	多语言文本设置
function WndBattleSetting:_updateLanguageText()

    local isLeague = false
    local isBoss = false
    local isRank = false
    local nPlayerVip = CacheCenter:getPlayerInfo().vipLevel
	local warnging = not WBattleGlobal:getCurrent():getMyHero():isDead()
	if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL then
        if WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_DZ or WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == GlobalGame.g_tBattleMode.BATTLE_MODE_LD then
			warnging = warnging and true
        else
            isLeague = true
            warnging = warnging and true
        end
	end
    if WBattleGlobal:getCurrent().m_tMakePairOk.battleChannle == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
        isRank = true
        warnging = warnging and true
    end
    
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        isBoss = true
        warnging = warnging and true
    end

    if WBattleGlobal:getCurrent():isSingleStage() then
        warnging = false
    end

    if WBattleGlobal:getCurrent():isAudience() then
        warnging = false
    end

    --背景音乐
	local txtBackMusic = self.m_root:getChildElement("txtBackMusic_WndBattleSetting")
	if txtBackMusic then
		txtBackMusic = WZUILabelTTF:luaTo(txtBackMusic)
		local txt = LocalStrings.BACKGROUND
		txtBackMusic:setText( txt )
	end
	--游戏音效
	local txtGameMusic = self.m_root:getChildElement("txtGameMusic_WndBattleSetting")
	if txtGameMusic then
		txtGameMusic = WZUILabelTTF:luaTo(txtGameMusic)
		txt = LocalStrings.GAME
		txtGameMusic:setText( txt )
	end
    --语音屏蔽
	local txtVoice = self.m_root:getChildElement("txtVoiceChat_WndBattleSetting")
	if txtVoice then
		txtVoice = WZUILabelTTF:luaTo(txtVoice)
		txt = LocalStrings.VOICECHAT
		txtVoice:setText( txt )
	end
    
	if warnging then
        local text = LocalStrings.BATTLE_EXIT_WARNING
        if isLeague then
            text = LocalStrings.BATTLE_EXIT_WARNING2
        elseif isBoss then
            text = LocalStrings.BATTLE_EXIT_WARNING3
        elseif isRank then
            text = LocalStrings.BATTLE_EXIT_WARNING4 or ""
        end
		WZUILabelTTF:luaTo(GetElement(self.m_root,"txtJg_WndBattleSetting")):setText(text)
        GetElement(self.m_root,"conMusic_WndBattleSetting"):setRelativePositionLuaTo(0.5,0.5925)
        GetElement(self.m_root,"conSound_WndBattleSetting"):setRelativePositionLuaTo(0.5,0.455)
	else
		WZUILabelTTF:luaTo(GetElement(self.m_root,"txtJg_WndBattleSetting")):setText("")
        GetElement(self.m_root,"conMusic_WndBattleSetting"):setRelativePositionLuaTo(0.5,0.5575)
        GetElement(self.m_root,"conSound_WndBattleSetting"):setRelativePositionLuaTo(0.5,0.3825)
	end
	WZUIShadowTTF:luaTo(GetElement(self.m_root,"txtTc_WndBattleSetting")):setText(LocalStrings.BATTLE_EXIT)
	WZUIShadowTTF:luaTo(GetElement(self.m_root,"txtJx_WndBattleSetting")):setText(LocalStrings.CONTINUE_GAME)
end

--@brief	设置退出按钮
function WndBattleSetting:_setExitGameEnable()
     if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS then

            local btnExitGame = WZUIButton:luaTo(GetElement(self.m_root,"btnExitGame_WndBattleSetting"))
            btnExitGame:setTouchEnable(false)
            
        end
    end
end

--多语言版本文本
function WndBattleSetting:_moreLanguage()
	for i = 1,3 do
		local exitName = string.format("txtExitGame%d_WndBattleSetting",i)
		local txtExitGame_WndBattleSetting = self.m_root:getChildElement(exitName)
        
        local txtLabel = string.format("txtLabel%d_WndBattleSetting",i)
		local txtLabel_WndBattleSetting = self.m_root:getChildElement(txtLabel)

		if nil == txtExitGame_WndBattleSetting then
			WZLog("nil == txtExitGame_WndBattleSetting")
			return 
		end
        if nil == txtLabel_WndBattleSetting then
			WZLog("nil == txtLabel_WndBattleSetting")
			return
		end
		txtExitGame_WndBattleSetting = WZUILabelTTF:luaTo(txtExitGame_WndBattleSetting)
		if nil ~= txtExitGame_WndBattleSetting then
			txtExitGame_WndBattleSetting:setText(LocalStrings.BATTLE_EXIT)
		end
        txtLabel_WndBattleSetting = WZUILabelTTF:luaTo(txtLabel_WndBattleSetting)
		if nil ~= txtLabel_WndBattleSetting then
			txtLabel_WndBattleSetting:setText(LocalStrings.CONTINUE_GAME)
		end
	end

    local txtLabel_WndBattleSetting = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtMusic_WndBattleSetting"))
    txtLabel_WndBattleSetting:setText(LocalStrings.BACKGROUND)

    local txtLabel_WndBattleSetting = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtEffectSound_WndBattleSetting"))
    txtLabel_WndBattleSetting:setText(LocalStrings.GAME)

    local txtLabel_WndBattleSetting = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtTitle_WndBattleSetting"))
    txtLabel_WndBattleSetting:setText(LocalStrings.SETTING_TITLE or "")
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
--@brief    越南语适配函数
--@note     越南语适配函数
function WndBattleSetting:_adaptLanguage_vn()
    WZLog("WndBattleSetting:_adaptLanguage_vn")
    
    for i = 1,3 do
        local exitName = string.format("txtExitGame%d_WndBattleSetting",i)
        local txtExitGame_WndBattleSetting = self.m_root:getChildElement(exitName)

        local exitImg = string.format("imgExitGame%d_WndBattleSetting",i)
        local imgExitGame_WndBattleSetting = self.m_root:getChildElement(exitImg)

        if nil == txtExitGame_WndBattleSetting or imgExitGame_WndBattleSetting == nil then
            WZLog("nil == txtExitGame_WndBattleSetting")
            return 
        end

        txtExitGame_WndBattleSetting = WZUILabelTTF:luaTo(txtExitGame_WndBattleSetting)
        if nil ~= txtExitGame_WndBattleSetting then
            txtExitGame_WndBattleSetting:setFontSize(28)
        end

        if imgExitGame_WndBattleSetting ~= nil then
            WZUI9Image:luaTo(imgExitGame_WndBattleSetting):setRelativeSize(GlobalMethod:CCSize(1.3,1))
        end

    end

    local txt = GetElement(self.m_root,"txtJg_WndBattleSetting",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(380,40))
    txt:setFontSize(20)
    txt:setRelativePosition(GlobalMethod:ccp(0.495,0.4025))
end

--@brief    英语适配函数
function WndBattleSetting:_adaptLanguage_en()
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_1 then --大乱斗屏蔽提示
        GetElement(self.m_root,"txtJg_WndBattleSetting",WZUILabelTTF):setVisible(false)
    end
    local txt = GetElement(self.m_root,"txtJg_WndBattleSetting",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(320,40))
    txt:setFontSize(18)
    txt:setRelativePosition(GlobalMethod:ccp(0.51,0.43))
end

--@brief    泰语适配函数
function WndBattleSetting:_adaptLanguage_th()
    local txt = GetElement(self.m_root,"txtJg_WndBattleSetting",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(380,40))
    txt:setFontSize(18)
    txt:setRelativePosition(GlobalMethod:ccp(0.51,0.43))
end

function WndBattleSetting:_adaptLanguage_pt()
    local txtJg = GetElement(self.m_root,"txtJg_WndBattleSetting",WZUILabelTTF)
    txtJg:setDimensions(GlobalMethod:CCSize(300))
    txtJg:setRelativePosition(GlobalMethod:ccp(0.485,0.445))
    txtJg:setAlignment(kCCTextAlignmentCenter)
end

function WndBattleSetting:_adaptLanguage_es()
    local txt = GetElement(self.m_root,"txtJg_WndBattleSetting",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(320,40))
    txt:setFontSize(18)
    txt:setRelativePosition(GlobalMethod:ccp(0.51,0.43))
end

function WndBattleSetting:_adaptLanguage_tr()
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_NORMAL and WBattleGlobal:getCurrent().m_tMakePairOk.battleMode == BattleConstants.g_tBossBattleMode.MODE_BOSSMAP_1 then --大乱斗屏蔽提示
        GetElement(self.m_root,"txtJg_WndBattleSetting",WZUILabelTTF):setVisible(false)
    end
    local txt = GetElement(self.m_root,"txtJg_WndBattleSetting",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(400))
    txt:setScale(0.8)
    txt:setRelativePosition(GlobalMethod:ccp(0.485,0.435))
end
-------------------------------------语言适配End--------------------------------------------