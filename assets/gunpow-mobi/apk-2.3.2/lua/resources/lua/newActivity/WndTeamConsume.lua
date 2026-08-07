--WndTeamConsume.lua
--@brief	WndTeamConsume的UI模块
--@date		2023/04/10
--@author	XTX
--@note		组团消费活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTeamConsume:onEnter(element)
	self.m_root = element

	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTeamConsume:onExit(element)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetTaskInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetTaskResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)

	self:_unInit()
	ChangeChatChannel(g_nLastChannelId_ShootArrow)
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndTeamConsume:onEnterTransitionDidFinish(element)
    WZLog("WndTeamConsume:onEnterTransitionDidFinish")
    ChangeChatChannel(Chat_Channel_TeamConsume)
    
    self:_initStaticText()

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7074, 7074)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(g_cityExtenInfo.activity7074, -1, 1)
end

--@brief    关闭窗口
function WndTeamConsume:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    local nTag = element:getTag()
    if nTag == 2 then 
    	GetElement(self.m_root, "conTaskUI_WndTeamConsume", WZUIContainer):setVisible(true)
    	GetElement(self.m_root, "conRankUI_WndTeamConsume", WZUIContainer):setVisible(false)
    elseif nTag == 1 then 
    	WindowManager:removeWindow(self.m_root, self, true)
    end
end

--@brief    点击规则按钮回调
function WndTeamConsume:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.TEAMCONSUME_TEXT2, false, 1) 
end

function WndTeamConsume:onBtnRole()
	if not self.m_tRoleData then return end

	WndCheckOther:show(self.m_tRoleData.playerId)
end

--@brief 	点击切换标签
function WndTeamConsume:onClickTab(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = element:getTag()
    if self.m_nTabIndex == nTag then return end 

    self.m_nTabIndex = nTag 
    self:_setDynamicText()
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7074, self.m_nTabIndex)
end

--@brief 	
function WndTeamConsume:onClickTask(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 1 then --排行榜
    	GetElement(self.m_root, "conTaskUI_WndTeamConsume", WZUIContainer):setVisible(false)
    	GetElement(self.m_root, "conRankUI_WndTeamConsume", WZUIContainer):setVisible(true)

    	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_nActivityId, self.m_nTabIndex)
    elseif nTag == 2 then --队长礼包
    	if self.m_nGiftRewardNum == 1 then
			--背包已满提示
		    if CacheCenter:getRemainAmount() <= 0 then
		        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
		        return
		    end
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
		else
			local data = {}

			data.title = string.format(LocalStrings.TEAMCONSUME_TEXT1[10], self.m_nGiftConfigNum)
			data.titleFontSize = 18
	        data.scale = 0.4
	        local reward_id = {}
	        local reward_num = {}
	        for id, value in pairs(self.m_tContent.captainPack) do
	            table.insert(reward_id,  tonumber(id))
	            table.insert(reward_num, tonumber(value))
	        end
	        data.rewardIds = reward_id
	        data.rewardNums = reward_num
	        local conTaskUI = GetElement(self.m_root, "conTaskUI_WndTeamConsume", WZUIContainer)
	        WndNewTipsReward:showInterface(conTaskUI, element, data, false, GlobalMethod:ccp(0.5, 0.5))
		end
    elseif nTag == 3 then --我的消息
    	WndHouseInvite:showInterface(6, self.m_nActivityId, 2)
    end
end

--@brief 	点击成为队长、邀请按钮回调
function WndTeamConsume:onClickInvite(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 1 then --成为队长
    	local element = WndEditBox:createElement()
		WndEditBox:setOkCallBack(self.onApplyRename, self)
		WndEditBox:setOtherData(tData)
		WndEditBox:setEditType(5)
		WndEditBox:setData(LocalStrings.TEAMCONSUME_TEXT1[22], LocalStrings.SHOOTARROW_TEXT13, nil, "(" .. LocalStrings.TEAMCONSUME_TEXT1[11] .. ")")
		WindowManager:addWindow(element, WndEditBox)
    elseif nTag == 2 then --邀请好友
    	WndHouseInvite:showInterface(6, self.m_nActivityId)
    elseif nTag == 3 then --邀请好友
    	WndHouseInvite:showInterface(6, self.m_nActivityId)
    end
end

--@brief	队名回调
function WndTeamConsume:onApplyRename(txt,lua,tData)
	WZLog("WndTeamConsume:onApplyRename:",txt)
	if txt == "" then 
		txt = LocalStrings.TEAMCONSUME_TEXT1[23]
	end
	result = JudgeResultInClientForInputText(5, txt)
	if result == 0 then 
		local tData = {}
		tData.name = txt
		local strData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, strData)
	else
		DisplayResult(result)
	end
end
-------------------------------------公有方法模块End----------------------------------------
--@brief 	初始化静态文本
function WndTeamConsume:_initStaticText()
	GetElement(self.m_root, "txtCheckBox1_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[4])
	GetElement(self.m_root, "txtCheckBoxSel1_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[4])
	GetElement(self.m_root, "txtCheckBox2_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[5])
	GetElement(self.m_root, "txtCheckBoxSel2_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[5])
	GetElement(self.m_root, "txtTeam_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[2] .. ":")
	GetElement(self.m_root, "txtConsumeWords_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[16] .. ":")
	GetElement(self.m_root, "txtMyInfo_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[15])
	GetElement(self.m_root, "txtRank_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.RANKLIST_TITLE)
	GetElement(self.m_root, "txtCaptainGift_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[3])

	self:_setDynamicText()
end

--@brief 	设置动态文本
function WndTeamConsume:_setDynamicText()
	if self.m_nTabIndex == 1 then 
		GetElement(self.m_root, "txtBottom3_WndTeamConsume", WZUILabelTTF):setVisible(true)
		GetElement(self.m_root, "txtMyRank_WndTeamConsume", WZUILabelTTF):setVisible(true)
		GetElement(self.m_root, "txtBottom3_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[6] .. ":")
		GetElement(self.m_root, "txtMyRankWords_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[7] .. ":")
		GetElement(self.m_root, "txtBottom4_WndTeamConsume", WZUILabelTTF):setText(string.format(LocalStrings.FOURSTAR_TEXT28, 100))
		GetElement(self.m_root, "txtTop3_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[6])
		GetElement(self.m_root, "txtTop2_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[2])
		GetElement(self.m_root, "txtTop4_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[8])
	else
		GetElement(self.m_root, "txtTop2_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[2])
		GetElement(self.m_root, "txtTop4_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.PLAYER)
		GetElement(self.m_root, "txtTop3_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.PETUSE)
		GetElement(self.m_root, "txtBottom4_WndTeamConsume", WZUILabelTTF):setText(string.format(LocalStrings.FOURSTAR_TEXT28, 10))
		if self:_judgeIsCaptain() then 
			GetElement(self.m_root, "txtBottom3_WndTeamConsume", WZUILabelTTF):setVisible(true)
			GetElement(self.m_root, "txtMyRank_WndTeamConsume", WZUILabelTTF):setVisible(true)
			GetElement(self.m_root, "txtBottom3_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[17])
			GetElement(self.m_root, "txtMyRankWords_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT14)
		else
			GetElement(self.m_root, "txtBottom3_WndTeamConsume", WZUILabelTTF):setVisible(false)
			GetElement(self.m_root, "txtMyRank_WndTeamConsume", WZUILabelTTF):setVisible(false)
		end
	end
end

-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	创建任务列表
function WndTeamConsume:_createTastList()
	local tbTaskList = GetElement(self.m_root, "tbTaskList_WndTeamConsume", WZUITableContainer)
	tbTaskList:cleanTable()
	self.m_tTaskItemCell = {}

	local count = getnTableCount(self.m_tTaskData)
	taskTableSort(self.m_tTaskData)
	for i = 1, count do
		local element, tLuaObj = CellTeamCTaskItem:createElement()
		if element and tLuaObj then 
			element:setTag(i - 1)
			element:setVisible(true)
			self.m_tTaskItemCell[i] = tLuaObj
			tbTaskList:setCellElement(element)
			tLuaObj:setGiftBuyMessage(i, self.m_tTaskData[i])
		end
	end
end

--@brief 	红点
function WndTeamConsume:showRedDot()
	-- body
	if self.m_root == nil then return end 

	local imgMsgReddot = GetElement(self.m_root, "imgMsgReddot_WndTeamConsume", WZUIImage)

	if GlobalGame.g_tRedPointTypeList and GlobalGame.g_tRedPointTypeList[17074] then 
		imgMsgReddot:setVisible(true)
	else
		imgMsgReddot:setVisible(false)
	end
end

--@brief 	显示队伍数据
function WndTeamConsume:_showTeamMenbers()
	self:_showTeamTotalData()
	if self.m_tTeamMenbers == nil or #self.m_tTeamMenbers == 0 then 
		local conMenber1 = GetElement(self.m_root, "conMenber1_WndTeamConsume", WZUIContainer)
		conMenber1:setVisible(true)
		GetElement(conMenber1, "btnInvite_WndTeamConsume", WZUIContainer):setVisible(true)
		GetElement(conMenber1, "txtBtn_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.TEAMCONSUME_TEXT1[9])
		return 
	end
	local bIsCaptain = false 
	for i = 1, 3 do
		local conMenber = GetElement(self.m_root, "conMenber" .. i .. "_WndTeamConsume", WZUIContainer)
		if self.m_tTeamMenbers[i] then 
			if i == 1 and self.m_tTeamMenbers[i].id == CacheCenter:getPlayerInfo().id then 
				bIsCaptain = true
			end
			
			self:_showMenberDetail(self.m_tTeamMenbers[i], i)
		else
			if bIsCaptain then 
				conMenber:setVisible(true)
				GetElement(conMenber, "btnInvite_WndTeamConsume", WZUIContainer):setVisible(true)
				GetElement(conMenber, "txtBtn_WndTeamConsume", WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT186)
			end
		end
	end
end

--@brief 	显示队员详情
function WndTeamConsume:_showMenberDetail(tMemberData, nIndex)
	-- body
	local conMenber = GetElement(self.m_root, "conMenber" .. nIndex .. "_WndTeamConsume", WZUIContainer)
	conMenber:setVisible(true)
	GetElement(conMenber, "btnInvite_WndTeamConsume", WZUIContainer):setVisible(false)
	--头像
	local conHead = GetElement(conMenber, "conHead_WndTeamConsume", WZUIContainer)
	conHead:setVisible(true)
	local celElement = CellHead:show(conHead, tMemberData.headId, tMemberData.faceId, tMemberData.sex, nil, nil, tMemberData.vipLevel, tMemberData.headColor, nil, nil, nil, nil, tMemberData.headEffectId)
	local txtServerName = GetElement(conMenber, "txtServerName_WndTeamConsume", WZUILabelTTF)
	local serverName = CacheCenter:getServerNameByServerId(tMemberData.serverId)
	txtServerName:setText(serverName)

	local txtPlayerName = GetElement(conMenber, "txtPlayerName_WndTeamConsume", WZUILabelTTF)
	local txtConWords = GetElement(conMenber, "txtConWords_WndTeamConsume", WZUILabelTTF)
	local txtConNum = GetElement(conMenber, "txtConNum_WndTeamConsume", WZUILabelTTF)
	txtPlayerName:setText(tMemberData.name)
	txtConWords:setText(LocalStrings.TEAMCONSUME_TEXT1[16] .. ":")
	txtConNum:setText(tMemberData.cost)

	--
	local imgCaptain = GetElement(conMenber, "imgCaptain_WndTeamConsume", WZUIImage)
	if nIndex == 1 then 
		imgCaptain:setFile("ui/activityWords/common_ztxf_dz.png")
	else
		imgCaptain:setFile("ui/activityWords/common_ztxf_dy.png")
	end
end

--@brief 	刷新赛事礼包的信息
function WndTeamConsume:showBagGiftInfo()
	-- body
	if self.m_nGiftRewardNum == 1 then 
		GetElement(self.m_root, "imgHavedGet_WndTeamConsume", WZUIImage):setVisible(false)
		GetElement(self.m_root, "imgGiftReddot_WndTeamConsume", WZUIImage):setVisible(true)
		GetElement(self.m_root, "txtGiftNum_WndTeamConsume", WZUILabelTTF):setText(self.m_nGiftRewardNum)
	else
		if self.m_nGiftRewardNum == 2 then 
			GetElement(self.m_root, "imgHavedGet_WndTeamConsume", WZUIImage):setVisible(true)
		end
		GetElement(self.m_root, "imgGiftReddot_WndTeamConsume", WZUIImage):setVisible(false)
	end
end

--@brief	显示当前队伍总消耗
function WndTeamConsume:_showTeamTotalData()
	local txtTeamName = GetElement(self.m_root, "txtTeamName_WndTeamConsume", WZUILabelTTF)
	local txtConsumeNum = GetElement(self.m_root, "txtConsumeNum_WndTeamConsume", WZUILabelTTF)
	local imgIcon = GetElement(self.m_root, "imgIcon_WndTeamConsume", WZUIImage)

	if self.m_tTeamInfo == nil or self.m_tTeamInfo.teamName == nil or self.m_tTeamInfo.teamName == "" then 
		txtTeamName:setText(LocalStrings.NONE)
	else
		txtTeamName:setText(self.m_tTeamInfo.teamName)
	end 

	local basicInfo = GDatatab_item["id_" .. self.m_tTeamInfo.costId]
	if basicInfo then 
		imgIcon:setFile(basicInfo.icon)
	end

	if self.m_tTeamInfo == nil or self.m_tTeamInfo.costNum == nil then 
		txtConsumeNum:setText("0")
	else
		txtConsumeNum:setText(self.m_tTeamInfo.costNum)
	end
end
-------------------------------------私有方法模块End----------------------------------------


function WndTeamConsume:_adaptLanguage_vn()
	for i=1,3 do
		local conMenber = GetElement(self.m_root, "conMenber"..i.."_WndTeamConsume", WZUIContainer)
		GetElement(conMenber, "txtBtn_WndTeamConsume", WZUILabelTTF):setScale(0.7)
	end
	GetElement(self.m_root, "txtCaptainGift_WndTeamConsume", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtRank_WndTeamConsume", WZUILabelTTF):setScale(0.7)
end