--WndLeagueApply.lua
--@brief	WndLeagueApply的UI模块
--@date		2016/06/14
--@author	zsq
--@note		战队申请


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLeagueApply:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

function WndLeagueApply:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndLeague:send_HERO_GetEnterPlayerList()
	--ProtocolProcessorWndLeague:send_HERO_ReadyFight()
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
	--查询队长id
	if CacheCenter:getPlayerInfo().teamId ~= 0 then
		SceneLeagueMain.m_nCheckType = 3
		ProtocolProcessorWndLeague:send_HERO_SearchTeam(CacheCenter:getPlayerInfo().teamId )
	end
end

--@brief    弹窗动画完成后的回调
function WndLeagueApply:actionCallback(element, data)
	GetElement(self.m_root,"con1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"con2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"btnCheck2",WZUIButton):setVisible(false)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLeagueApply:onExit(element)
	self:_unInit()
end

function WndLeagueApply:onClose()
	WZLog("WndLeagueApply:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	显示接口
function WndLeagueApply:show()
	WZLog("WndLeagueApply:show")
	if self.m_root == nil then 
		local wnd = WndLeagueApply:createElement()
		WindowManager:addWindow(wnd, WndLeagueApply, nil, nil, true)
	end
end

--@brief	显示报名列表
function WndLeagueApply:onCheck1()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"con1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"con2",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"btnCheck2",WZUIButton):setVisible(true)
end

--@brief	显示报名界面
function WndLeagueApply:onCheck2()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(self.m_root,"con1",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"con2",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"btnCheck2",WZUIButton):setVisible(false)
end

--@brief	确认报名
function WndLeagueApply:onAgree(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--已经报名
	if self.myTeamTatus == 1 then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE50)
		return
	end
	--海选赛结束后才可报名
	local timer = SceneLeagueMain.m_tTime
	if timer.nowTime <= SceneLeagueMain:transformStringToTime(timer.startSignTime.." 00:00") or 
		timer.nowTime > SceneLeagueMain:transformStringToTime(timer.endSignTime.." 24:00") then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE47)
		return
	end
	--没有战队不能报名
	if CacheCenter:getPlayerInfo().teamId == 0 then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE43)
		return
	end
	--积分2000以上才能报名
	WZLog("积分限制",CacheCenter:getGameParam().heroScoreRequire)
	if self.myTeamScore < tonumber(CacheCenter:getGameParam().heroScoreRequire) then
		MsgBoxManager:showTipBox(string.format(LocalStrings.LEAGUE46,tonumber(CacheCenter:getGameParam().heroScoreRequire)))
		return
	end
	--只有队长可进行报名
	WZLog("队长id",SceneLeagueMain.m_nCaptain)
	if SceneLeagueMain.m_nCaptain == nil or SceneLeagueMain.m_nCaptain ~= CacheCenter:getPlayerInfo().id then
		MsgBoxManager:showTipBox(LocalStrings.LEAGUE48)
		return
	end
	ProtocolProcessorWndLeague:send_HERO_SignHeroStrong()
    WindowManager:removeWindow(self.m_root , self , true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndLeagueApply:update()
	local s = [[<T C="127,70,26" S="22" P="0">  %s</T><BR></BR><T C="127,70,26" S="22" P="0">%s</T>]]
	GetElement(self.m_root, "freeText1", WZUIFreeTextBox):setShowText(string.format(s,LocalStrings.LEAGUE_REPLAY_TEXT8,
		string.sub(SceneLeagueMain.m_tTime.startTime32,1,10)))
	GetElement(self.m_root, "freeText2", WZUIFreeTextBox):setShowText(string.format(s," "..LocalStrings.LEAGUE_REPLAY_TEXT9,
		string.sub(SceneLeagueMain.m_tTime.startTime16,1,10)))
	GetElement(self.m_root, "freeText3", WZUIFreeTextBox):setShowText(string.format(s," "..LocalStrings.LEAGUE_REPLAY_TEXT10,
		string.sub(SceneLeagueMain.m_tTime.startTime8,1,10)))
	GetElement(self.m_root, "freeText4", WZUIFreeTextBox):setShowText(string.format(LocalStrings.LEAGUE16,tonumber(CacheCenter:getGameParam().heroScoreRequire)))
	
	local freeListContainer = GetElement(self.m_root,"freeCon_WndLeagueApply",WZUIFreeListContainer)
	freeListContainer:removeAll()

	--没有数据时显示提示
	if self.m_tDataList == nil or #self.m_tDataList == 0 then 
		ShowPanelNullTip(freeListContainer,nil,GlobalMethod:ccc3(255,236,193))
	else
		removeShowPanelNullTip(freeListContainer)
	end

	for i=1,#self.m_tDataList do
		local celElement,tCell = CellLeagueApply:createElement()
		if celElement ~= nil and tCell ~= nil then 
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(self.m_tDataList[i])
			freeListContainer:pushBack(celElement)
			freeListContainer:getMoveElement():setPositionY(freeListContainer:getMinPosition().y)
		end 
	end

	--我的积分
	GetElement(self.m_root,"txtMyScore",WZUILabelTTF):setText(self.myTeamScore)
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndLeagueApply:_adaptLanguage_vn(  )
	local txtAgree = GetElement(self.m_root,"txtAgree_WndRecruit",WZUILabelTTF)
	txtAgree:setDimensions(GlobalMethod:CCSize(160,0))
	txtAgree:setScale(0.8)
	local txtRefuse = GetElement(self.m_root,"txtRefuse_WndRecruit",WZUILabelTTF)
	txtRefuse:setDimensions(GlobalMethod:CCSize(160,0))
	txtRefuse:setScale(0.8)
	local txtQuery = GetElement(self.m_root,"txtQuery_WndLeagueApply",WZUILabelTTF)
	txtQuery:setDimensions(GlobalMethod:CCSize(160,0))
	txtQuery:setScale(0.8)
end
-------------------------------------语言适配End--------------------------------------------