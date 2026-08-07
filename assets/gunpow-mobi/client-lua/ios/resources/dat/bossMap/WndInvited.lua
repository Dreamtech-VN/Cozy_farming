--WndInvited.lua
--@brief	WndInvited的UI模块
--@date		2014/01/23
--@author	liangguang_long
--@note		副本战斗邀请请求模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndInvited:onEnter(element)
	--SoundManager:playBgMusic(SoundDefine.E_S_OPEN_WIN)
	self.m_root = element
	--@brief	多语言版本文本
	--self:_initMoreLanguage()
	--1.8多语言文本
	self:_moreLanguageForStroke()
	--@brief	更新函数
	--self:_update()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndInvited:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮回调函数
function WndInvited:onCloseClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then
		return
	end
	--关闭关于窗口
	WindowManager:removeWindow( self.m_root , WndInvited , true )
end

--@brief   根据定时器计算等待邀请时间
--@note	   如果邀请时间超过7秒，就取消邀请
function WndInvited:scheduleInvite( element )
	if self.m_root == nil then
		element:disableSchedule()
		return
	end
	self.m_nInviteIndex = self.m_nInviteIndex - 1
	--@brief	显示邀请剩余时间
	self:_showInviteTime( self.m_nInviteIndex )
	--如果时间超时就关闭窗口
	if self.m_nInviteIndex < 0 then
		element:disableSchedule()
		self:onCloseClick()
	end	
end

--@brief	拒绝按钮回调函数
function WndInvited:onRefusalClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end
	--停止定时器
	self.m_root:disableSchedule()
	--关闭窗口
	WindowManager:removeWindow( self.m_root , WndInvited , true )
end

--@brief	确定按钮回调函数
function WndInvited:onSureClick()
	WZLog("WndInvited:onSureClick ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil or self.m_tCell == nil or self.m_tCallbackFun == nil then
		return
	end

	--停止定时器
	self.m_root:disableSchedule()
	if self.m_sPassword == "" or self.m_sPassword == nil then
		if self.m_nRoomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_WTB then
			if self.m_sPassword == nil then 
				self.m_sPassword = "-1"
			end
		else
			self.m_sPassword = "-1"
		end
	end
	if self.m_nAssistFight == nil then
		self.m_nAssistFight = 1
	end

	if self.m_nRoomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
		if IsShowPunishTime(true) then
			WindowManager:removeWindow( self.m_root , WndInvited , true )
			return
		end
	end

	--回调函数
	if self.m_nRoomChannel and self.m_nRoomChannel > 0  then
		self.m_tCallbackFun( self.m_tCell , self.m_nId , self.m_nRoomChannel,self.m_sPassword, self.mapId, self.m_sDesc , self.m_nBattleId,self.m_nAssistFight )
	else
		self.m_tCallbackFun( self.m_tCell , self.m_nId , self.m_sPassword, self.mapId, self.m_sDesc , self.m_nBattleId )
	end
	
	--关闭窗口
	WindowManager:removeWindow( self.m_root , WndInvited , true )
end

function WndInvited:bContinue()
	-- body
	WZLog("WndInvited:bContinue")
	if SceneRoom.m_root == nil and SceneBossRoom.m_root == nil and SceneBattle.m_root == nil and SceneBattleLoading.m_root == nil and GlobalGame.g_bIfInBattle == false and WndTeachOpenModule.m_root == nil and WndTeachTalk.m_root == nil and SceneKingMain.m_root == nil and not WndChat.m_bRecording and not SceneHall:getMatchState() and not WndStrengthen.m_root and not WndTowerScroll.m_root and not SceneWeddingChurch.m_root and not SceneLeagueRoom.m_root and not SceneAthMelee
.m_root and SceneMarryCopy.m_root == nil and SceneTabooBattle.m_root == nil and SceneGuildWarRoom.m_root == nil and SceneWorldTeamBossRoom.m_root == nil then
       return true
    end
    return false
end

--@brief	外部接口函数
--@param    #1 element:表名
--@param    #2 callbackfun:函数名
--@param    #3 nId:副本代号
--@param    #4 password:房间密码
--@param    #5 mapId 地图ID， 组队副本使用
--@param    #6 desc:邀请说明内容
--@param    #7 nBattleId:战斗房间ID
--@param    #8 Schedule:是否开启计时
function WndInvited:showInterface( element , callbackfun, nId , password ,mapId, desc ,playerName, nBattleId, Schedule ,roomChannel,assistFight)
	WZLog("WndInvited:showInterface ",roomChannel)
	if self:bContinue() then
        if G_Friend_BeInvite == 1 and element ~= WndLeagueTeamDetail then
            if CacheCenter:isFriendByName(playerName) then
                return 
            end
        end
        if G_Stranger_BeInvite == 1 and element ~= WndLeagueTeamDetail then 
        	if not CacheCenter:isFriendByName(playerName) then
                return 
            end 
        end

        if element == WndLeagueTeamDetail then
        	if G_Corps_INVITE == 1 then
        		return
        	end
        end

        --排位赛正在匹配的时候，不弹被邀请框
        if ScenePvpRank.m_root and ScenePvpRank:getMatchState() then
        	return 
        end

        if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then return end

        if self.m_root == nil then
		    local wndInvitedElement = WndInvited:createElement()
			if wndInvitedElement == nil then
				return
			end
		    WindowManager:addWindow(wndInvitedElement , WndInvited)
	    end
	
		--@brief	开始要求定时器
		if Schedule == nil or Schedule then
			self:_beginInviteSchedule()
		end
		--@brief	显示邀请内容说明
		--debug.traceback()
		GetElement(self.m_root,"imgLeague",WZUIImage):setVisible(false)
		--desc = self:_changeTipByAssistFight(assistFight,desc)
		WZLog("=====:"..desc)
		if roomChannel == GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_PW then
			IsShowPunishTime(false)
		end
		self:_showInviteDesc( desc )
		self.m_nAssistFight = assistFight
		self:_showAssistFightTip(assistFight)
		--@brief	设置回调函数
		self:_setCallBackFun( element, callbackfun , nId,password ,mapId, nBattleID ,roomChannel)
		if element == WndLeagueTeamDetail or desc == LocalStrings.INVITE_LEAGUE  then
			self:leagueInvite()
		end

		if Schedule == nil then
			local txtSurplusTime = GetElement(self.m_root,"txtSurplusTime_WndInvited",WZUILabelAtlasFont)
			txtSurplusTime:setVisible(true)
			txtSurplusTime:setText("7")
			GetElement(self.m_root,"txtInvitedDesc_WndInvited",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(280,0))
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	开始要求定时器
--@note		用于计算玩家接受邀请等待时间，如果时间超过10秒就关闭窗口
function WndInvited:_beginInviteSchedule()
	if self.m_root == nil then
		return
	end
	self.m_nInviteIndex = 7			--邀请索引，用于计算接受邀请时间
	self.m_root:enableSchedule( "scheduleInvite" , 1 )
end

--@brief	显示邀请剩余时间
--@param	sText:显示文本内容，在这里是邀请剩余时间
function WndInvited:_showInviteTime( sText )
	if self.m_root == nil then
		return
	end
	local txtSurplusTime = self.m_root:getChildElement("txtSurplusTime_WndInvited")
	if txtSurplusTime == nil then
		return
	end
	txtSurplusTime = WZUILabelAtlasFont:luaTo(txtSurplusTime)
	txtSurplusTime:setText( sText )

	txtSurplusTime:setVisible(true)
	GetElement(self.m_root,"txtInvitedDesc_WndInvited",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(280,0))
end

--@brief	隐藏倒计时数字
function WndInvited:leagueInvite()
	GetElement(self.m_root,"txtSurplusTime_WndInvited",WZUILabelAtlasFont):setVisible(false)
	GetElement(self.m_root,"imgLeague",WZUIImage):setVisible(true)
	GetElement(self.m_root,"txtInvitedDesc_WndInvited",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(350,0))
end

--@brief	显示邀请内容说明
--@param	sText:显示文本内容，在这里是邀请内容(谁邀请谁)
function WndInvited:_showInviteDesc( sText )
	if self.m_root == nil then
		return
	end
	local txtInvitedDesc = self.m_root:getChildElement("txtInvitedDesc_WndInvited")
	if txtInvitedDesc == nil then
		return
	end
	txtInvitedDesc = WZUILabelTTF:luaTo(txtInvitedDesc)
	txtInvitedDesc:setText( sText )
end

function WndInvited:_showAssistFightTip(bAssistFight)
	-- body
	WZLog("WndInvited:_showAssistFightTip")
	if self.m_root == nil then
		return
	end
	local txtAssistFight = GetElement(self.m_root,"txtAssistFight_WndInvited",WZUILabelTTF)
	txtAssistFight:setVisible(false)
	if bAssistFight == 0 then
		txtAssistFight:setVisible(true)
	end
end

--@brief	设置回调函数
--@param    #1 element:表名
--@param    #2 callbackfun:函数名
--@param    #3 password:密码
--@param    #4 nBattleId:战斗房间ID
function WndInvited:_setCallBackFun( element , callbackfun , nId ,password, mapId, nBattleID ,roomChannel)
	if self.m_root == nil then
		return
	end
	self.m_tCell = element              --表名
	self.m_tCallbackFun =  callbackfun	--回调函数
	self.m_nId = nId					--房间ID
	self.m_sPassword = password
	self.mapId = mapId
	self.m_nBattleId = nBattleID		--战斗房间ID
	self.m_nRoomChannel = roomChannel   --房间所属频道
end

--@brief	多语言版本文本
--[[function WndInvited:_initMoreLanguage()
	if self.m_root == nil then
		return
	end
	local txtRefusalBtn = self.m_root:getChildElement("txtRefusalBtn_WndInvited")
	if txtRefusalBtn == nil then
		return
	end
	txtRefusalBtn = WZUILabelTTF:luaTo(txtRefusalBtn)
	txtRefusalBtn:setText( LocalStrings.REJECT )
	--确定按钮
	local txtSureBtn = self.m_root:getChildElement("txtSureBtn_WndInvited")
	if txtSureBtn == nil then
		return
	end
	txtSureBtn = WZUILabelTTF:luaTo(txtSureBtn)
	txtSureBtn:setText( LocalStrings.CONFIRM )
end--]]

--@brief  1.8多语言文本
function WndInvited:_moreLanguageForStroke()
	if self.m_root == nil then
		return
	end
	local txtRefusalBtn = self.m_root:getChildElement("txtRefusalBtn_WndInvited")
	if txtRefusalBtn ~= nil then
		txtRefusalBtn = WZUILabelTTF:luaTo(txtRefusalBtn)	
		txtRefusalBtn:setText(LocalStrings.REJECT)
		txtRefusalBtn:setVisible(true)
	end
	local txtSureBtn = self.m_root:getChildElement("txtSureBtn_WndInvited")
	if txtSureBtn ~= nil then
		txtSureBtn = WZUILabelTTF:luaTo(txtSureBtn)	
		txtSureBtn:setText(LocalStrings.AGREE)
		txtSureBtn:setVisible(true)
	end
end

--修改提示
function WndInvited:_changeTipByAssistFight(assistFight,tip)
	-- body
	WZLog("WndInvited:_changeTipByAssistFight")
	if assistFight ~= nil and assistFight == 0 then
		tip = tip .. "(" .. LocalStrings.ASSIST_IN_FIGHTING .. ")"
	end
	return tip
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配器模块Begin--------------------------------------
--@brief	葡语适配函数

--@note		葡语适配函数

function WndInvited:_adaptLanguage_pt()
    WZLog("WndInvited:_adaptLanguage_pt")
    local txtRefusalBtn = self.m_root:getChildElement("txtRefusalBtn_WndInvited")
    if txtRefusalBtn ~= nil then
        txtRefusalBtn = WZUILabelTTF:luaTo(txtRefusalBtn)
        txtRefusalBtn:setFontSize(24)
    end


    local txtSureBtn = self.m_root:getChildElement("txtSureBtn_WndInvited")
        if txtSureBtn ~= nil then
        txtSureBtn = WZUILabelTTF:luaTo(txtSureBtn)
        txtSureBtn:setFontSize(24)
    end

    local txtAssistFight = GetElement(self.m_root,"txtAssistFight_WndInvited",WZUILabelTTF)
    txtAssistFight:setScale(0.55)
    txtAssistFight:setDimensions(GlobalMethod:CCSize(420))

    local txtInvitedDesc = GetElement(self.m_root,"txtInvitedDesc_WndInvited",WZUILabelTTF)
    txtInvitedDesc:setFontSize(20)
    txtInvitedDesc:setRelativePosition(GlobalMethod:ccp(0,0.7))
end


function WndInvited:_adaptLanguage_vn()
    local txtAssistFight = GetElement(self.m_root,"txtAssistFight_WndInvited",WZUILabelTTF)
    txtAssistFight:setScale(0.55)
    txtAssistFight:setDimensions(GlobalMethod:CCSize(420))

    GetElement(self.m_root,"txtInvitedDesc_WndInvited",WZUILabelTTF):setFontSize(16)
end

function WndInvited:_adaptLanguage_es()
    local txtAssistFight = GetElement(self.m_root,"txtAssistFight_WndInvited",WZUILabelTTF)
    txtAssistFight:setScale(0.55)
    txtAssistFight:setDimensions(GlobalMethod:CCSize(420))

    local txtInvitedDesc = GetElement(self.m_root,"txtInvitedDesc_WndInvited",WZUILabelTTF)
    txtInvitedDesc:setFontSize(20)
    txtInvitedDesc:setRelativePosition(GlobalMethod:ccp(0,0.7))
end

function WndInvited:_adaptLanguage_en()
    local txtAssistFight = GetElement(self.m_root,"txtAssistFight_WndInvited",WZUILabelTTF)
    txtAssistFight:setScale(0.55)
    txtAssistFight:setDimensions(GlobalMethod:CCSize(420))

    local txtInvitedDesc = GetElement(self.m_root,"txtInvitedDesc_WndInvited",WZUILabelTTF)
    txtInvitedDesc:setFontSize(20)
    txtInvitedDesc:setRelativePosition(GlobalMethod:ccp(0,0.7))
end
-------------------------------------语言适配器模块End----------------------------------------








