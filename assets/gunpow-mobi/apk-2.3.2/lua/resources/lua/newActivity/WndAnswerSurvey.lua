--WndAnswerSurvey.lua
--@brief	WndAnswerSurvey的UI模块
--@date		2019/12/12
--@author	Tianxiang_Xu
--@note		问题调研


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAnswerSurvey:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAnswerSurvey:onExit(element)
	self:_unInit()
end

--@brief    onenter函数已执行
function WndAnswerSurvey:onEnterTransitionDidFinish(element)
    WZLog("WndAnswerSurvey:onEnterTransitionDidFinish")
    local sConfig = CacheCenter:getGameParam().researchDate
    self.m_tSystemConfig = json.decode(sConfig)
    WZLog("onEnterTransitionDidFinish", Serialize(self.m_tSystemConfig))

    self:getQuestionData()
end

--@brief    关闭窗口
function WndAnswerSurvey:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief 	点击提交按钮回调
function WndAnswerSurvey:onClickSubmit(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tableLen = 0
	if self.m_tAnswerList ~= nil then 
		tableLen = GetTableLen(self.m_tAnswerList)
	end
	WZLog("WndAnswerSurvey:onClickSubmit", tableLen, #self.m_tQuestionList)
	if tableLen < #self.m_tQuestionList then 
		MsgBoxManager:showTipBox(LocalStrings.ANSWER_TEXT5)
		return 
	end

	MsgBoxManager:showConfirmBox(LocalStrings.ANSWER_TEXT4, self, self.sureToCommit)
end

--@brief 	确认提交
function WndAnswerSurvey:sureToCommit()
	-- body
	local titleId = {}
	local option = {}
	for i = 1, #self.m_tQuestionList do
		if self.m_tAnswerList[i] and #self.m_tAnswerList > 0 then 
			table.insert(titleId, self.m_tQuestionList[i].turn)
			local tempString = ""
			for k = 1, #self.m_tAnswerList[i] do
				if k == 1 then 
					tempString = tempString .. self.m_tAnswerList[i][k]
				else
					tempString = tempString .. ","
					tempString = tempString .. self.m_tAnswerList[i][k]
				end
			end
			table.insert(option, tempString)
		end
	end
	
	self:_createLoading()
	WZLog("WndAnswerSurvey:sureToCommit", Serialize(titleId), Serialize(option))
	ProtocolProcessorSceneIsland:send_PLAYER_Investigate(TableToIntVector(titleId), TableToStdStringVector(option))
end

-- 点击物品后的回调
function WndAnswerSurvey:onClickListItem(tItem, nTag, tData)
    WZLog("------------------click item-------------------")
    WndItemInfo:_onCloseClick()

    WndItemInfo:showInfo(tItem.m_root, self.m_root, 1, tData, false, nil, false)
end

--@brief 	保存答案数据
function WndAnswerSurvey:answerCallback(tData, nTag, bAdd)
	-- body
	if self.m_tAnswerList == nil then self.m_tAnswerList = {} end

	if tData.choose == 1 then 
		self.m_tAnswerList[tData.turn] = {nTag}
	else
		if self.m_tAnswerList[tData.turn] == nil then self.m_tAnswerList[tData.turn] = {} end 

		if bAdd then 
			table.insert(self.m_tAnswerList[tData.turn], nTag)
		else
			for i = 1, #self.m_tAnswerList[tData.turn] do
				if self.m_tAnswerList[tData.turn][i] == nTag then 
					table.remove(self.m_tAnswerList[tData.turn], i)
					break 
				end
			end
			if #self.m_tAnswerList[tData.turn] == 0 then 
				self.m_tAnswerList[tData.turn] = nil
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndAnswerSurvey:_update()
	-- body
	local tbAnswerItem = GetElement(self.m_root, "tbAnswerItem_WndAnswerSurvey", WZUITableContainer)
	tbAnswerItem:cleanTable()

	for i = 1, #self.m_tQuestionList do
		local element, tNewObj = CellAnswerSurvey:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tQuestionList[i])

			tbAnswerItem:setCellElement(element)
		end
	end

	--奖励
	local tbReward = GetElement(self.m_root, "tbReward_WndAnswerSurvey", WZUITableContainer)
	tbReward:cleanTable()
	local ids, num = SplitItemString(self.m_tSystemConfig.reward)
	for i = 1, #ids do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tNewObj:setCellGoodLocalId(tonumber(ids[i]), tonumber(num[i]), 16)
			tNewObj:setItemClickFun(self, self.onClickListItem)
			element:setScale(0.85)

			tbReward:setCellElement(element)
		end
	end

	--活动时间
	local txtTime = GetElement(self.m_root, "txtTime_WndAnswerSurvey", WZUILabelTTF)
	if txtTime then 
		txtTime:setText(LocalStrings.ANSWER_TEXT6 .. self.m_tSystemConfig.startDate .. " " .. self.m_tSystemConfig.endDate)
	end
end




-------------------------------------私有方法模块End----------------------------------------
