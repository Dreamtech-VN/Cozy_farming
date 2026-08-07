--ScenePvpStrategic.lua
--@brief	ScenePvpStrategic的UI模块
--@date		2022/12/07
--@author	yrd
--@note		战略赛


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function ScenePvpStrategic:onEnter(element)
	self.m_root = element


	local zlsBattleConfig = json.decode(CacheCenter:getGameParam().zlsBattleConfig)
	self.m_nSkillPropNum = zlsBattleConfig.skillNum

	ChangeChatChannel(Chat_Channel_PVP_STRATEGIC)
	WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)

	self:register()

	CacheCenter:registerUpatePlayerInfoObserver(self)
	CacheCenter:registerUpatePlayerItemObserver(self)
	CacheCenter:registerUpdateDecorationObserver(self)

	ProtocolProcessorScenePvpStrategic:regAll()
	ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsBattleInfo()

	self:_initStaticText()

	WndChat:addChatWindowToCurScene()
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)
	IsShowZlsPunishTime(false)

	self:showRedDot()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function ScenePvpStrategic:onExit(element)

	CacheCenter:unregisterUpatePlayerInfoObserver(self)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	CacheCenter:unregisterUpateDecorationObserver(self)

	ProtocolProcessorScenePvpStrategic:unregAll()

	self:unregister()
	self:_unInit()
end

function ScenePvpStrategic:register()
	GlobalGame:getGameEventDispathcer():Add(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onScenePvpStrategicInfoData,self)
end
function ScenePvpStrategic:unregister()
	GlobalGame:getGameEventDispathcer():Remove(bottomMeneEvent.WndBottomMeneEvent_HonorPointCountDown,self._onScenePvpStrategicInfoData,self)
end

--@brief	顶部栏
function ScenePvpStrategic:_addTop()
	local cell,tcell = CellTopHandle:createElement()
	self.m_root:addChild(cell)
	tcell:setTopData("",self,self.onReturn,false,true,true,"ScenePvpStrategic")
	local strFormat = [[<I Z="1">ui/common/common_icon_zls_s.png</I><A IMG = "ui/common_num/common_icon_ss0-9.png" Z="1" W="18" H="40" CHAR="0">%d</A><I Z="1">ui/common/common_icon_ss1sj.png</I>]]
	tcell:setTitleFtb(string.format(strFormat,self.season))
	tcell:setWifiSignalVisible(false)
end

function ScenePvpStrategic:showRedDot()
	local bShow = false
	local tTaskList = PrefetchCache:getTaskList()
	if #tTaskList.tStrategicDailyTask.tToSubmit > 0 or #tTaskList.tStrategicSeasonTask.tToSubmit > 0 then
		bShow = true
	end
	local btnWin1BtnSs2 = GetElement(self.m_root,"btnWin1BtnSs2_ScenePvpStrategic",WZUIButton)
	SceneCity:setRedPoint(btnWin1BtnSs2, bShow, GlobalMethod:ccp(80,80))
end

--@brief 外部接口
function ScenePvpStrategic:showInterface()
	replaceScene(ScenePvpStrategic:createElement())
end

--@brief 关闭界面
function ScenePvpStrategic:onReturn()
	WZLog("ScenePvpStrategic:onReturn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	ScenePvp:showScene()
end

--@brief 刷新战略赛信息
function ScenePvpStrategic:updateZlsBattleInfo()
	if not self.m_root then
		return
	end

	local isEndTeach52, step52 = TeachGroup1:isTeachFinish(52)
	if isEndTeach52 ~= true then
		if #self.skillIds == 0 or #self.propIds == 0 then
			TeachGroup1:startGroup({52,1,self.m_root})
		else
			TeachGroup1:setTeachFinish(52,-1)
			TeachGroup1:removeTeach()
		end
	end

    --赛季时间
    SystemTime:getTimeConverLocal(self.startDate)
    local txtWin1Date = GetElement(self.m_root, "txtWin1Date_ScenePvpStrategic", WZUILabelTTF)
    txtWin1Date:setText(LocalStrings.TIME_OF_THE_SEASON .. SystemTime:getTimeConverLocal(self.startDate) .. "-" .. SystemTime:getTimeConverLocal1(self.endDate))

	local nCurModeLevel
	local nCurModeScore
	local nStar
	if self.m_nPvpMode == 2 then
		nCurModeLevel = self.level
		nCurModeScore = self.score
		nStar = self.star
	elseif self.m_nPvpMode == 3 then
		nCurModeLevel = self.level2
		nCurModeScore = self.score2
		nStar = self.star2
	end

	self:showPvpModeBtnStatus()

	local tCurLevelInfo = GetZlsPvpDataByLevel(nCurModeLevel)

	local spinePath = "ui/zls/" .. tCurLevelInfo.animation
    local existSpine = CheckEffectFile(spinePath)
    if existSpine then 
		local spineRankLevel = GetElement(self.m_root,"spineRankLevel_ScenePvpStrategic",WZUISpine)
		spineRankLevel:setFileJson(spinePath .. ".json")
		spineRankLevel:setFileAtlas(spinePath .. ".atlas")
		spineRankLevel:play(tCurLevelInfo.action,true)
	else
		local imgRankLevel = GetElement(self.m_root,"imgRankLevel_ScenePvpStrategic",WZUIImage)
		imgRankLevel:setVisible(true)
		imgRankLevel:setFile("ui/common/"..tCurLevelInfo.icon..".png")
	end
	local formatStar = [[<I Z="0.6" P="1">ui/common/common_icon_xingxing5.png</I><T C="127,70,26" S="20" P="1">x%d</T>]]
	local ftbRankStar = GetElement(self.m_root,"ftbRankStar_ScenePvpStrategic",WZUIFreeTextBox)
	ftbRankStar:setShowText("")
	if tCurLevelInfo.id == 999 then
		ftbRankStar:setShowText(string.format(formatStar,nStar))
	end
	local txtRankLevel = GetElement(self.m_root,"txtRankLevel_ScenePvpStrategic",WZUILabelTTF)
	txtRankLevel:setText(tCurLevelInfo.name)
	local txtRankScore = GetElement(self.m_root,"txtRankScore_ScenePvpStrategic",WZUILabelTTF)
	txtRankScore:setText(LocalStrings.PVP_STRATEGIC_TEXT1[9]..":"..nCurModeScore.."/"..tCurLevelInfo.level_up_score)
	local progRankScore = GetElement(self.m_root,"progRankScore_ScenePvpStrategic",WZUIProgress)
	progRankScore:setPercentage(nCurModeScore/tCurLevelInfo.level_up_score*100)

	--段位保护
	local txtRankProtect = GetElement(self.m_root,"txtRankProtect_ScenePvpStrategic",WZUILabelTTF)
	if self.protectNum and self.protectNum > 0 then
		txtRankProtect:setText(string.format(LocalStrings.PVP_STRATEGIC_TEXT1[28], self.protectNum))
	else
		txtRankProtect:setText("")
	end

	--技能道具
	self:updatePlayerSkillProp()

	--开放倒计时
	local txtWin1Time = GetElement(self.m_root,"txtWin1Time_ScenePvpStrategic",WZUILabelTTF)
	self:_updateW1CountDown()
	txtWin1Time:enableSchedule("_updateW1CountDown",1)
end

--@brief    主界面开放倒计时
function ScenePvpStrategic:_updateW1CountDown(element)
	local txtWin1Time = GetElement(self.m_root,"txtWin1Time_ScenePvpStrategic",WZUILabelTTF)
	txtWin1Time:setText("")
	if self:isSeasonOpenTime() then
		if self:isDayOpenTime() then
			local nLeftTime = self:getOpenTime()
			if nLeftTime == -1 then
				txtWin1Time:setText(LocalStrings.PVP_STRATEGIC_TEXT1[30])
			elseif nLeftTime > 0 then
				txtWin1Time:setText(self:getStrCountdown(nLeftTime))
			else
				txtWin1Time:setText("")
			end
		else
			txtWin1Time:setText(LocalStrings.PVP_STRATEGIC_TEXT1[31])
		end
	else
		txtWin1Time:setText(LocalStrings.PVP_STRATEGIC_TEXT1[32])
	end
end


--@brief 技能道具
function ScenePvpStrategic:updatePlayerSkillProp()
	local skillIds
	local propIds
	if self.m_nPvpMode == 2 then
		skillIds = self.skillIds
		propIds = self.propIds
	elseif self.m_nPvpMode == 3 then
		skillIds = self.skillIds2
		propIds = self.propIds2
	end

	for i=1,self.m_nSkillPropNum do
		local conSkill = GetElement(self.m_root,"conSkill"..i.."_ScenePvpStrategic",WZUIContainer)
		local imgSkillIcon = GetElement(conSkill,"imgSkillIcon_ScenePvpStrategic",WZUIImage)
		local imgSkillAdd = GetElement(conSkill,"imgSkillAdd_ScenePvpStrategic",WZUIImage)
		imgSkillIcon:setFile("")
		imgSkillAdd:setVisible(true)
	end
	for i=1,self.m_nSkillPropNum do
		local conProp = GetElement(self.m_root,"conProp"..i.."_ScenePvpStrategic",WZUIContainer)
		local imgPropIcon = GetElement(conProp,"imgPropIcon_ScenePvpStrategic",WZUIImage)
		local imgPropAdd = GetElement(conProp,"imgPropAdd_ScenePvpStrategic",WZUIImage)
		imgPropIcon:setFile("")
		imgPropAdd:setVisible(true)
	end

	local nSkillIndex = 1
	for i=1,#skillIds do
		if skillIds[i] > 0 then
			local conSkill = GetElement(self.m_root,"conSkill"..nSkillIndex.."_ScenePvpStrategic",WZUIContainer)
			local imgSkillIcon = GetElement(conSkill,"imgSkillIcon_ScenePvpStrategic",WZUIImage)
			local imgSkillAdd = GetElement(conSkill,"imgSkillAdd_ScenePvpStrategic",WZUIImage)
			local tSkillInfo = GDatatab_skill["id_"..skillIds[i]]
			imgSkillIcon:setFile(tSkillInfo.icon)
			imgSkillAdd:setVisible(false)
			nSkillIndex = nSkillIndex + 1
		end
	end
	local nPropIndex = 1
	for i=1,#propIds do
		if propIds[i] > 0 then
			local conProp = GetElement(self.m_root,"conProp"..nPropIndex.."_ScenePvpStrategic",WZUIContainer)
			local imgPropIcon = GetElement(conProp,"imgPropIcon_ScenePvpStrategic",WZUIImage)
			local imgPropAdd = GetElement(conProp,"imgPropAdd_ScenePvpStrategic",WZUIImage)
			local tSkillInfo = GDatatab_skill["id_"..propIds[i]]
			imgPropIcon:setFile(tSkillInfo.icon)
			imgPropAdd:setVisible(false)
			nPropIndex = nPropIndex + 1
		end
	end

end

--@brief 显示模式按钮状态
function ScenePvpStrategic:showPvpModeBtnStatus()
	for i=2,3 do
		local imgSwitchPvpMode = GetElement(self.m_root,"imgSwitchPvpMode"..i.."_ScenePvpStrategic",WZUI9Image)
		local txtSwitchPvpMode = GetElement(self.m_root,"txtSwitchPvpMode"..i.."_ScenePvpStrategic",WZUILabelTTF)
		if i == self.m_nPvpMode then
			imgSwitchPvpMode:setFile("ui/common/common_btn_hd_01.png")
			txtSwitchPvpMode:setColor(ccc3(0,97,179))
		else
			imgSwitchPvpMode:setFile("ui/common/common_btn_hd_02_1.png")
			txtSwitchPvpMode:setColor(ccc3(255,255,255))
		end
	end
end

--@brief 点击"快速加入"按钮
function ScenePvpStrategic:onClickQuickJoin()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not (self:isSeasonOpenTime() and self:isDayOpenTime() and (self:getOpenTime() == 0)) then
		MsgBoxManager:showTipBox(LocalStrings.PVP_STRATEGIC_TEXT1[25])
		return
	end
	
	local skillIds
	local propIds
	if self.m_nPvpMode == 2 then
		skillIds = self.skillIds
		propIds = self.propIds
	elseif self.m_nPvpMode == 3 then
		skillIds = self.skillIds2
		propIds = self.propIds2
	end
	if #skillIds ~= self.m_nSkillPropNum or #propIds ~= self.m_nSkillPropNum then
		MsgBoxManager:showTipBox(LocalStrings.PVP_STRATEGIC_TEXT1[26])
		return
	end
	ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo()
	self.nStartMathIndex = 1
end

--@brief 点击"快速开始"按钮
function ScenePvpStrategic:onClickQuickStart()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not (self:isSeasonOpenTime() and self:isDayOpenTime() and (self:getOpenTime() == 0)) then
		MsgBoxManager:showTipBox(LocalStrings.PVP_STRATEGIC_TEXT1[25])
		return
	end

	local skillIds
	local propIds
	if self.m_nPvpMode == 2 then
		skillIds = self.skillIds
		propIds = self.propIds
	elseif self.m_nPvpMode == 3 then
		skillIds = self.skillIds2
		propIds = self.propIds2
	end
	if #skillIds ~= self.m_nSkillPropNum or #propIds ~= self.m_nSkillPropNum then
		MsgBoxManager:showTipBox(LocalStrings.PVP_STRATEGIC_TEXT1[26])
		return
	end

	ProtocolProcessorWndTask:send_PLAYER_GetHonourInfo()
	self.nStartMathIndex = 2
end

--@brief 点击切换模式按钮 
function ScenePvpStrategic:onClickSwitchMode(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	self.m_nPvpMode = tag

	if self:isSeasonOpenTime() and self:isDayOpenTime() then
	else
		MsgBoxManager:showTipBox(LocalStrings.PVP_HALL_34)
	end

	self:updateZlsBattleInfo()
end

--@brief 点击"选技能"按钮 
function ScenePvpStrategic:onClickSkillProp(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	TeachGroup1:endTeachStep({52,1})

	local tag = element:getTag()
	local pvpMode = self.m_nPvpMode
	WndPvpStrategicSkillProp:showInterface(pvpMode,tag)
end

--@brief 点击属性按钮
function ScenePvpStrategic:onCheckInfo(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndTips:show(element,self.m_root,88,nil,GlobalMethod:ccp(-240,-200),true)
end

--@brief 点击规则按钮
function ScenePvpStrategic:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.PVP_STRATEGIC_TEXT3) 
end

--@brief 点击按钮
function ScenePvpStrategic:onClickBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if tag == 1 then --赛事信息
		self:showWin2UI(self.m_nPvpMode)
	elseif tag == 2 then --赛事奖励
		self:showWin5UI()
	elseif tag == 3 then --排名
		WndPvpStrategicRank:showWin4UI(1,self.m_nPvpMode)
	end
end

--@brief 点击段位详情按钮
function ScenePvpStrategic:onClickLevelInfo(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:showWin3UI()
end



--@brief 判断信誉积分
function ScenePvpStrategic:_onScenePvpStrategicInfoData(honourPoint, restoreTime, serverTime)
	local _, score = GlobalMethod:HonorPointStatus(6)
	if tonumber(honourPoint) >= score then
		if IsShowZlsPunishTime(true) then return end
		if self.nStartMathIndex then
			local roomChannel = GlobalGame.g_tRoomChannel.BATTLE_CHANNEL_ZLS
			if self.nStartMathIndex == 1 then
				local num = math.random(1,#LocalStrings.ROOM_NAME_RANDOM)
				local roomName = LocalStrings.ROOM_NAME_RANDOM[num]
				ProtocolProcessorScenePvpStrategic:send_ROOM_CreateRoom(roomName, 1, self.m_nPvpMode, "-1", 1, roomChannel,0)
				-- ProtocolProcessorScenePvpStrategic:send_ROOM_SelectRoom(0,roomChannel,self.m_nPvpMode,"-1")  --房间id为0表示快速加入
			elseif self.nStartMathIndex == 2 then
				ProtocolProcessorScenePvpStrategic:send_ROOM_QuickGame(roomChannel,1,0,self.m_nPvpMode)
				self:_initMarkTime()
			end
		end
	else
		local status, score = GlobalMethod:HonorPointStatus(6)
		if status == false then
			WndHonorPoint:showInterface(score, honourPoint, restoreTime, serverTime)
		end
	end
end

--@brief 初始化匹配时间
function ScenePvpStrategic:_initMarkTime()
	self.m_nMarkTime = 1
	self.m_bIsStartMatch = true
	local con = GetElement(self.m_root,"conMark_ScenePvpStrategic",WZUIContainer)
	con:setVisible(true)

	local lafTime = GetElement(self.m_root,"lafTime_ScenePvpStrategic",WZUILabelAtlasFont)
	lafTime:setText(self.m_nMarkTime)

	self:updateDescTips()

	local conMain = GetElement(self.m_root,"conMain_ScenePvpStrategic",WZUIContainer)
	conMain:enableSchedule("_updateMarkTime",1)
end

--@brief 更新匹配时间
function ScenePvpStrategic:_updateMarkTime()
	self.m_nMarkTime = self.m_nMarkTime + 1
	local lafTime = GetElement(self.m_root,"lafTime_ScenePvpStrategic",WZUILabelAtlasFont)
	lafTime:setText(self.m_nMarkTime)

	if self.m_nMarkTime%5 == 0 then
		self:updateDescTips()
	end

	if self.m_nMarkTime == 60 then
		local con = GetElement(self.m_root,"conMark_ScenePvpStrategic",WZUIContainer)
		con:setVisible(false)
		local conMain = GetElement(self.m_root,"conMain_ScenePvpStrategic",WZUIContainer)
		conMain:disableSchedule()
		MsgBoxManager:showTipBox(LocalStrings.MATCHFAIL, nil, nil, nil, nil)
	end
end

-- 取消匹配
function ScenePvpStrategic:onCancelMatch()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_bIsStartMatch = false
	ProtocolProcessorScenePvpStrategic:send_ROOM_EndPair(0)
	local con = GetElement(self.m_root,"conMark_ScenePvpStrategic",WZUIContainer)
	con:setVisible(false)
	local conMain = GetElement(self.m_root,"conMain_ScenePvpStrategic",WZUIContainer)
	conMain:disableSchedule()
end

-- 更新小提示
function ScenePvpStrategic:updateDescTips()
	local ttfDesc = GetElement(self.m_root,"txtTimeDownTip_ScenePvpStrategic",WZUILabelTTF)
	local nIndex = math.random(1, #LocalStrings.PVP_STRATEGIC_TEXT2)
	if ttfDesc:getText() == LocalStrings.PVP_STRATEGIC_TEXT2[nIndex] then
		nIndex = nIndex+1
		if nIndex > #LocalStrings.PVP_STRATEGIC_TEXT2 then nIndex = 1 end
	end
	ttfDesc:setText(LocalStrings.TIPS..":"..LocalStrings.PVP_STRATEGIC_TEXT2[nIndex])
end

-------------------------------------赛事信息begin----------------------------------------

--@brief 点击关闭赛事信息按钮
function ScenePvpStrategic:onClickCloseWin2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	self.m_tWin2DataList = nil

	local conWin2 = GetElement(self.m_root,"conWin2_ScenePvpStrategic",WZUIContainer)
	conWin2:setVisible(false)
end

--@brief 显示赛事信息界面
function ScenePvpStrategic:showWin2UI(nPvpMode)
	if nPvpMode then
		self.m_nWin2PvpMode = nPvpMode
	end

	local conWin2 = GetElement(self.m_root,"conWin2_ScenePvpStrategic",WZUIContainer)
	conWin2:setVisible(true)

	self:showWin2PvpModeBtnStatus()

	if self.m_tWin2DataList == nil then
		self.m_tWin2DataList = {}
	end
	if self.m_tWin2DataList[self.m_nWin2PvpMode] == nil then
		ProtocolProcessorScenePvpStrategic:send_TRIO_GetZlsSeasonInfoList(self.m_nWin2PvpMode)
	else
		self:updateWin2UI()
	end


end

--@brief 刷新赛事信息界面
function ScenePvpStrategic:updateWin2UI()
	if self.m_tWin2ObjList == nil then
		self.m_tWin2ObjList = {}
	end
	self.m_tWin2ObjList[self.m_nWin2PvpMode] = {}
	local flcW2 = GetElement(self.m_root,"flcW2_ScenePvpStrategic",WZUIFreeListContainer)
	flcW2:removeAll()
	if next(self.m_tWin2DataList[self.m_nWin2PvpMode]) == nil then
		ShowPanelNullTip(flcW2, LocalStrings.CHARM_RESULT)
	else
		removeShowPanelNullTip(flcW2)
		for i=1, #self.m_tWin2DataList[self.m_nWin2PvpMode] do
			local newElement, tLuaObj = CellPvpStrategicWin2Grid:createElement()
			newElement = WZUIContainer:luaTo(newElement)
			tLuaObj:setData(self.m_tWin2DataList[self.m_nWin2PvpMode][i])
			tLuaObj:setCallback(self, self.onClickWin2Grid)
			newElement:setVisible(true)
			flcW2:pushBack(newElement)
			table.insert(self.m_tWin2ObjList[self.m_nWin2PvpMode],tLuaObj)
		end
		if self.m_win2curPosX then
			flcW2:getMoveElement():setPositionX(self.m_win2curPosX)
		else
			flcW2:getMoveElement():setPositionX(flcW2:getMaxPosition().x)
		end
		self.m_win2curPosX = nil
	end
end

--@brief 显示模式按钮状态
function ScenePvpStrategic:showWin2PvpModeBtnStatus()
	for i=2,3 do
		local imgWin2PvpMode = GetElement(self.m_root,"imgWin2PvpMode"..i.."_ScenePvpStrategic",WZUI9Image)
		local txtWin2PvpMode = GetElement(self.m_root,"txtWin2PvpMode"..i.."_ScenePvpStrategic",WZUILabelTTF)
		if i == self.m_nWin2PvpMode then
			imgWin2PvpMode:setFile("ui/common/common_btn_hd_01.png")
			txtWin2PvpMode:setColor(ccc3(0,97,179))
		else
			imgWin2PvpMode:setFile("ui/common/common_btn_hd_02_1.png")
			txtWin2PvpMode:setColor(ccc3(255,255,255))
		end
	end
end

--@brief 点击窗口2切换匹配模式按钮
function ScenePvpStrategic:onClickWin2SwitchMode(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if tag == self.m_nWin2PvpMode then
		return
	end
	self:showWin2UI(tag)
end

--@brief	点击格子
function ScenePvpStrategic:onClickWin2Grid(tLuaObj)
	local flcW2 = GetElement(self.m_root,"flcW2_ScenePvpStrategic",WZUIFreeListContainer)
	for i=1,#self.m_tWin2DataList[self.m_nWin2PvpMode] do
		if self.m_tWin2DataList[self.m_nWin2PvpMode][i].season == tLuaObj.m_tData.season then
			if self.m_tWin2DataList[self.m_nWin2PvpMode][i].nType == 1 then
				self.m_tWin2DataList[self.m_nWin2PvpMode][i].nType = 2
				self.m_win2curPosX = flcW2:getMoveElement():getPositionX() + 295
			elseif self.m_tWin2DataList[self.m_nWin2PvpMode][i].nType == 2 then
				self.m_tWin2DataList[self.m_nWin2PvpMode][i].nType = 1
				self.m_win2curPosX = flcW2:getMoveElement():getPositionX() - 295
			end
			break
		end
	end
	self:updateWin2UI()
end
-------------------------------------赛事信息end----------------------------------------


-------------------------------------段位详情begin----------------------------------------
--@brief 更新赛事详情按钮
function ScenePvpStrategic:updateWin3Data()

	local tLevelScore = {}
	for i=3,31 do
		local tCurZlsLevelInfo = GDatatab_zls_level["id_"..i]
		local tPrevZlsLevelInfo = GDatatab_zls_level["id_"..(i-1)]
		if tLevelScore[tCurZlsLevelInfo.level - 1] == nil then
			tLevelScore[tCurZlsLevelInfo.level - 1] = 0
		end
		tLevelScore[tCurZlsLevelInfo.level] = tLevelScore[tCurZlsLevelInfo.level - 1] + tPrevZlsLevelInfo.level_up_score
	end
	local tCurZlsLevelInfo = GDatatab_zls_level["id_999"]
	local tPrevZlsLevelInfo = GDatatab_zls_level["id_31"]
	tLevelScore[tCurZlsLevelInfo.level] = tLevelScore[tCurZlsLevelInfo.level - 1] + tPrevZlsLevelInfo.level_up_score
	tLevelScore[1] = 1

	self.m_tWin3DataList = {}
	for i=1,6 do
		local tempzlsData = {}
		for j=(i-1)*5+2,(i-1)*5+6 do
			local tZlsLevelInfo = CopyTable(GDatatab_zls_level["id_"..j])
			tZlsLevelInfo.nScoreConditions = tLevelScore[tZlsLevelInfo.level]
			table.insert(tempzlsData,tZlsLevelInfo)
		end
		table.insert(self.m_tWin3DataList,tempzlsData)
	end
	local tempzlsData = {}
	local tZlsLevelInfo = CopyTable(GDatatab_zls_level["id_999"])
	tZlsLevelInfo.nScoreConditions = tLevelScore[tZlsLevelInfo.level]
	table.insert(tempzlsData,tZlsLevelInfo)
	table.insert(self.m_tWin3DataList,tempzlsData)

	self.m_tWin3TypeList = {}
	for i=1,#self.m_tWin3DataList do
		table.insert(self.m_tWin3TypeList,1)
	end

	self:updateWin3UI()
end

--@brief 点击关闭段位详情按钮
function ScenePvpStrategic:onClickCloseWin3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	self.m_tWin3DataList = nil

	local conWin3 = GetElement(self.m_root,"conWin3_ScenePvpStrategic",WZUIContainer)
	conWin3:setVisible(false)
end

--@brief 显示段位详情界面
function ScenePvpStrategic:showWin3UI()
	local conWin3 = GetElement(self.m_root,"conWin3_ScenePvpStrategic",WZUIContainer)
	conWin3:setVisible(true)

	if self.m_tWin3DataList == nil then
		self:updateWin3Data()
	else
		self:updateWin3UI()
	end
end

--@brief 显示段位详情界面
function ScenePvpStrategic:updateWin3UI()
	self.m_tWin3ObjList = {}
	local flcW3 = GetElement(self.m_root,"flcW3_ScenePvpStrategic",WZUIFreeListContainer)
	flcW3:removeAll()
	if next(self.m_tWin3DataList) == nil then
		ShowPanelNullTip(flcW3, LocalStrings.CHARM_RESULT)
	else
		removeShowPanelNullTip(flcW3)
		for i=1, #self.m_tWin3DataList do
			local newElement, tLuaObj = CellPvpStrategicWin3Grid:createElement()
			newElement = WZUIContainer:luaTo(newElement)
			tLuaObj:setType(self.m_tWin3TypeList[i])
			tLuaObj:setIndex(i)
			tLuaObj:setData(self.m_tWin3DataList[i])
			tLuaObj:setCallback(self, self.onClickWin3Grid)
			newElement:setVisible(true)
			flcW3:pushBack(newElement)
			table.insert(self.m_tWin3ObjList,tLuaObj)
		end
		if self.m_win3curPosX then
			flcW3:getMoveElement():setPositionX(self.m_win3curPosX)
		else
			flcW3:getMoveElement():setPositionX(flcW3:getMaxPosition().x)
		end
		self.m_win3curPosX = nil
	end
end

--@brief	点击格子
function ScenePvpStrategic:onClickWin3Grid(tLuaObj)
	local flcW3 = GetElement(self.m_root,"flcW3_ScenePvpStrategic",WZUIFreeListContainer)

	if self.m_tWin3TypeList[tLuaObj.m_nIndex] == 1 then
		self.m_tWin3TypeList[tLuaObj.m_nIndex] = 2
		self.m_win3curPosX = flcW3:getMoveElement():getPositionX() + 295
	elseif self.m_tWin3TypeList[tLuaObj.m_nIndex] == 2 then
		self.m_tWin3TypeList[tLuaObj.m_nIndex] = 1
		self.m_win3curPosX = flcW3:getMoveElement():getPositionX() - 295
	end

	self:updateWin3UI()
end

-------------------------------------段位详情end----------------------------------------



-------------------------------------赛事奖励begin----------------------------------------
--@brief 点击赛事奖励按钮
function ScenePvpStrategic:onClickCloseWin5(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	self.m_tWin5DataList = nil

	local conWin5 = GetElement(self.m_root,"conWin5_ScenePvpStrategic",WZUIContainer)
	conWin5:setVisible(false)
end

--@brief 显示赛事奖励界面
function ScenePvpStrategic:showWin5UI()
	local conWin5 = GetElement(self.m_root,"conWin5_ScenePvpStrategic",WZUIContainer)
	conWin5:setVisible(true)

	if self.m_tWin5DataList == nil then
		self:updateWin5Data()
	else
		self:updateWin5UI()
	end

end

--@brief    更新赛事奖励数据
function ScenePvpStrategic:updateWin5Data()
	if self.m_tWin5DataList == nil then
		self.m_tWin5DataList = {}
	end
	local tTaskList = PrefetchCache:getTaskList()
	for i=1,#tTaskList.tStrategicDailyTask.tToSubmit do
		table.insert(self.m_tWin5DataList,tTaskList.tStrategicDailyTask.tToSubmit[i])
	end
	for i=1,#tTaskList.tStrategicSeasonTask.tToSubmit do
		table.insert(self.m_tWin5DataList,tTaskList.tStrategicSeasonTask.tToSubmit[i])
	end
	for i=1,#tTaskList.tStrategicDailyTask.tDoing do
		table.insert(self.m_tWin5DataList,tTaskList.tStrategicDailyTask.tDoing[i])
	end
	for i=1,#tTaskList.tStrategicSeasonTask.tDoing do
		table.insert(self.m_tWin5DataList,tTaskList.tStrategicSeasonTask.tDoing[i])
	end
	for i=1,#tTaskList.tStrategicDailyTask.tCompleted do
		table.insert(self.m_tWin5DataList,tTaskList.tStrategicDailyTask.tCompleted[i])
	end
	for i=1,#tTaskList.tStrategicSeasonTask.tCompleted do
		table.insert(self.m_tWin5DataList,tTaskList.tStrategicSeasonTask.tCompleted[i])
	end

	local function getSortIndex(status)
		if status == 1 then
			return 1
		elseif status == 0 then
			return 2
		elseif status == 2 then
			return 3
		end
	end

	table.sort(self.m_tWin5DataList,function(a,b)
		if a.nTaskStatus ~= b.nTaskStatus then
			return getSortIndex(a.nTaskStatus) < getSortIndex(b.nTaskStatus)
		else
			if a.nTaskType ~= b.nTaskType then
				return a.nTaskType < b.nTaskType
			else
				return a.nId < b.nId
			end
		end
	end)
	self:updateWin5UI()
end

--@brief    更新赛事奖励界面
function ScenePvpStrategic:updateWin5UI()
	self.m_tWin5ObjList = {}
	local tcW5Task = GetElement(self.m_root,"tcW5Task_ScenePvpStrategic",WZUITableContainer)
	tcW5Task:cleanTable()
	for i = 1, #self.m_tWin5DataList do
		local cell,tcell = CellPvpStrategicWin5Grid:createElement()
		cell:setTag(i-1)
		tcell:setData(self.m_tWin5DataList[i])
		tcell:setCallback(self,self.onClickWin5Item)
		cell:setVisible(true)
		tcW5Task:setCellElement(cell)
		table.insert(self.m_tWin5ObjList,tCell)
	end
end

--@brief 点击奖励按钮回调
function ScenePvpStrategic:onClickWin5Item(luaObject,data)
	WndItemInfo:showInfo(luaObject.m_root,self.m_root,1,data,false)
end

-------------------------------------赛事奖励end----------------------------------------



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function ScenePvpStrategic:_initStaticText()
	GetElement(self.m_root,"txtSelectSkills_ScenePvpStrategic",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[4])
	GetElement(self.m_root,"txtBtnSs0_ScenePvpStrategic",WZUILabelTTF):setText(LocalStrings.PET_2)
	GetElement(self.m_root,"txtBtnSs1_ScenePvpStrategic",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[5])
	GetElement(self.m_root,"txtBtnSs2_ScenePvpStrategic",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[6])
	GetElement(self.m_root,"txtBtnSs3_ScenePvpStrategic",WZUILabelTTF):setText(LocalStrings.RANKLIST_TITLE)

	GetElement(self.m_root,"txtW3Title_ScenePvpStrategic",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[12])

	GetElement(self.m_root,"txtW5Title_ScenePvpStrategic",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[6])
	GetElement(self.m_root,"txtW5Desc_ScenePvpStrategic",WZUILabelTTF):setText(LocalStrings.PVP_STRATEGIC_TEXT1[21])
end

function ScenePvpStrategic:createLoadingBox()
	if not self.loadingId then
		self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
	end
end

function ScenePvpStrategic:closeLoadingBox()
	if self.loadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
		self.loadingId = nil
	end
end

-------------------------------------私有方法模块End----------------------------------------
