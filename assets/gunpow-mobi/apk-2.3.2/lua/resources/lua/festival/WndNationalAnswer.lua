--WndNationalAnswer.lua
--@brief	WndNationalAnswer的UI模块
--@date		2020/09/08
--@author	hyx
--@note		趣味答题


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNationalAnswer:onEnter(element)
	self.m_root = element
	ProtocolProcessorFestivalActivity:regAll()
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNationalAnswer:onExit(element)
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end
function WndNationalAnswer:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_AnswerInfoData,self._onGetAnswerInfoData,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_StartAnswerResult,self._onStartAnswerResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetAnswerRewardInfo,self._onAnswerRewardInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetAnswerRankTotal,self._onAnswerRankTotalResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetAnswerRankGuild,self._onAnswerRankGuildResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetAnswerRankReward,self._onAnswerRankRewardResult,self)
end
function WndNationalAnswer:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_AnswerInfoData,self._onGetAnswerInfoData,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_StartAnswerResult,self._onStartAnswerResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetAnswerRewardInfo,self._onAnswerRewardInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetAnswerRankTotal,self._onAnswerRankTotalResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetAnswerRankGuild,self._onAnswerRankGuildResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetAnswerRankReward,self._onAnswerRankRewardResult,self)
end
function WndNationalAnswer:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndNationalAnswer:actionCallback()
	self:initShow()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerInfo( )
end
function WndNationalAnswer:initShow()
	for i=1,2 do
		local tab = {}
		tab.title_name = GetElement(self.m_root,"name_"..i,WZUILabelTTF)
		tab.title_name:setColor(GlobalMethod:ccc3(0,112,202))
		tab.title_name:setText(LocalStrings.FESTIVAL_TEXT13[i])
		self.m_tChangeContainerList[i] = tab
	end
	--默认点击的
	self.m_tChangeContainerList[self.m_nChangeCurIndex].title_name:setColor(GlobalMethod:ccc3(255,255,255))
	self.m_tChangeContainerList[self.m_nChangeCurIndex].title_name:setEnableStroke(true)
	self.m_tChangeContainerList[self.m_nChangeCurIndex].title_name:setStrokeColor(GlobalMethod:ccc3(0,112,202))
	self.m_tChangeContainerList[self.m_nChangeCurIndex].title_name:setStrokeSize(4)

	self.answer_container = GetElement(self.m_root,"answer_container",WZUIContainer)
	self.rank_container = GetElement(self.m_root,"rank_container",WZUIContainer)
	self.rank_container:setVisible(false)
	self:AnswerContainer()
	self:RankContainer()
end
--答题区域
function WndNationalAnswer:AnswerContainer()
	if not self.answer_container then return end

	local left = GetElement(self.answer_container,"left",WZUIContainer)
	self.answer_value_1 = GetElement(left,"value_1",WZUILabelTTF)
	self.answer_value_2 = GetElement(left,"value_2",WZUILabelTTF)
	self.answer_value_3 = GetElement(left,"value_3",WZUILabelTTF)
	self.answer_label_4 = GetElement(left,"label_4",WZUILabelTTF)
	-- self.answer_label_4:setText(LocalStrings.FESTIVAL_TEXT10)

	self.btnAnswer = GetElement(left,"btnAnswer",WZUIButton)
	self.btnAnswerLabel = GetElement(self.btnAnswer,"answerLabel",WZUILabelTTF)
	self.tipNoticeContainer = GetElement(left,"tipNoticeContainer",WZUIContainer)

	self.start_container = GetElement(left,"start_container",WZUIContainer)
	--规则说明
	local tipsContent = GetElement(left,"tipsContent_WndNationalAnswer",WZUIFreeTextBox)
	tipsContent:setShowText(LocalStrings.FESTIVAL_TEXT6)
    self:_upMoveContainerLayer()
end
function WndNationalAnswer:_upMoveContainerLayer()
	if self.m_root == nil then return end

	--文本大小size
	local left = GetElement(self.answer_container,"left",WZUIContainer)
	local txtNotice = GetElement(left,"tipsContent_WndNationalAnswer",WZUIFreeTextBox)
	local txtSize = txtNotice:getContentSize()

	-- 滑动层size
	local scroll = GetElement(left, "scrollNotice_WndNationalANswer", WZUIMoveContainer)
	if scroll == nil then return end
    local scrollSize = scroll:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = scroll:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize( size.width, txtSize.height / scrollSize.height) )
	scroll:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(scroll:getMinPosition().y)
end
--学霸排行区域
function WndNationalAnswer:RankContainer()
	if not self.rank_container then return end

	for i=1,4 do
		local tab = {}
		tab.normal = GetElement(self.rank_container,"normal"..i,WZUI9Image)
		tab.select = GetElement(self.rank_container,"select"..i,WZUI9Image)
		tab.select:setVisible(false)
		tab.name = GetElement(self.rank_container,"name"..i,WZUILabelTTF)
		tab.name:setText(LocalStrings.FESTIVAL_TEXT15[i])
		tab.name:setColor(GlobalMethod:ccc3(255,255,255))
		self.m_tChangeRankTitleList[i] = tab
	end
	self.m_tChangeRankTitleList[self.m_nCurRankTitleIndex].normal:setVisible(false)
	self.m_tChangeRankTitleList[self.m_nCurRankTitleIndex].select:setVisible(true)
	self.m_tChangeRankTitleList[self.m_nCurRankTitleIndex].name:setColor(GlobalMethod:ccc3(0,112,202))
end

function WndNationalAnswer:onBtnAnswerTab(element)
	local index = tonumber(element:getTag())
	if index == self.m_nChangeCurIndex then return end
	if self.m_tChangeContainerList[self.m_nChangeCurIndex] ~= nil then
		self.m_tChangeContainerList[self.m_nChangeCurIndex].title_name:setEnableStroke(false)
		self.m_tChangeContainerList[self.m_nChangeCurIndex].title_name:setColor(GlobalMethod:ccc3(0,112,202))
	end
	if self.m_tChangeContainerList[index] ~= nil then
		self.m_tChangeContainerList[index].title_name:setColor(GlobalMethod:ccc3(255,255,255))
		self.m_tChangeContainerList[index].title_name:setEnableStroke(true)
		self.m_tChangeContainerList[index].title_name:setStrokeColor(GlobalMethod:ccc3(0,112,202))
		self.m_tChangeContainerList[index].title_name:setStrokeSize(4)
	end
	self.m_tRankTitleAreaList = {}
	self.answer_container:setVisible(index == 1)
	self.rank_container:setVisible(index == 2)
	if index == 2 then
		self:touchTitleRankContainer(self.m_nCurRankTitleIndex)
	end
	self.m_nChangeCurIndex = index
end
--排行头部点击处理
function WndNationalAnswer:onClickChangeRank(element)
	local index = tonumber(element:getTag())

	if index == self.m_nCurRankTitleIndex then return end
	if self.m_tChangeRankTitleList[self.m_nCurRankTitleIndex] ~= nil then
		self.m_tChangeRankTitleList[self.m_nCurRankTitleIndex].normal:setVisible(true)
		self.m_tChangeRankTitleList[self.m_nCurRankTitleIndex].select:setVisible(false)
		self.m_tChangeRankTitleList[self.m_nCurRankTitleIndex].name:setColor(GlobalMethod:ccc3(255,255,255))
	end
	if self.m_tChangeRankTitleList[index] ~= nil then
		self.m_tChangeRankTitleList[index].normal:setVisible(false)
		self.m_tChangeRankTitleList[index].select:setVisible(true)
		self.m_tChangeRankTitleList[index].name:setColor(GlobalMethod:ccc3(0,112,202))
	end

	self:touchTitleRankContainer(index)
	self.m_nCurRankTitleIndex = index
end
--排行容器处理
function WndNationalAnswer:touchTitleRankContainer(index)
	GetElement(self.rank_container,"rank1",WZUIContainer):setVisible(index == 1)
	GetElement(self.rank_container,"rank2",WZUIContainer):setVisible(index == 2)
	GetElement(self.rank_container,"rank3",WZUIContainer):setVisible(index == 3)
	GetElement(self.rank_container,"rank4",WZUIContainer):setVisible(index == 4)

	if self.m_tRankTitleAreaList[index] == true then return end
	self.m_tRankTitleAreaList[index] = true

	if index == 1 then --总排行
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerRanking( )
	elseif index == 2 then --公会
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswerGuildRanking( )
	elseif index == 3 then --总 奖励
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingReward(0)
	elseif index == 4 then --公会 奖励
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingReward(1)
	end
end
function WndNationalAnswer:showInterface()
	local wndAnswer = WndNationalAnswer:createElement()
	if wndAnswer ~= nil then
	    WindowManager:addWindow(wndAnswer,WndNationalAnswer,nil,false)
	end
end
--题目选择区域
function WndNationalAnswer:startSubjectContainer(aIndex, title, answers)
	if not self.start_container then return end

	if self.answer_label_4 then
		self.answer_label_4:setText(string.format(LocalStrings.FESTIVAL_TEXT19,tonumber(aIndex)))
	end
	local subject_label = GetElement(self.start_container,"subject_label",WZUILabelTTF)
	subject_label:setFontSize(18)
	subject_label:setDimensions(GlobalMethod:CCSize(470))
	subject_label:setText(title)

	local height = subject_label:getContentSize().height
	for i=1,4 do
		if self.m_tSubjectList[i] and self.m_tSubjectList[i].item then
			self.m_tSubjectList[i].item:setVisible(false)
		end
	end
	local pos_y = 0.72
	if height >= (32*3) then
		pos_y = 0.63
	end
	local text = {"A.","B.","C.","D."}
	for i = 1, #answers do
		local tab = {}
		tab.item = GetElement(self.start_container,"answer_key"..i,WZUIContainer)
		tab.item:setVisible(true)
		tab.item:setRelativePosition(GlobalMethod:ccp(0.5,pos_y-(i-1)*0.19))
		tab.select_key = GetElement(self.start_container,"select_key"..i,WZUIContainer)
		tab.select_key:setVisible(false)
		tab.normal_value = GetElement(self.start_container,"normal_value"..i,WZUILabelTTF)
		tab.label = text[i]..answers[i]
		tab.normal_value:setText(tab.label)
		tab.normal_value:setDimensions(GlobalMethod:CCSize(450))
		tab.normal_value:setColor(GlobalMethod:ccc3(255,255,255))
		tab.normal_value:setFontSize(16)
		self.m_tSubjectList[i] = tab
	end
end
--选择答案
function WndNationalAnswer:onBtnClickChooseAnswer(element)
	if not self.m_nAnswerCouponCount then return end
	if self.m_nAnswerCouponCount <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.FESTIVAL_TEXT21)
		return
	end
	local index = tonumber(element:getTag())

	if self.m_tSubjectList and self.m_tSubjectList[index] then
		self.m_tSubjectList[index].normal_value:setText(self.m_tSubjectList[index].label)
		self.m_tSubjectList[index].normal_value:setDimensions(GlobalMethod:CCSize(450))
		self.m_tSubjectList[index].normal_value:setColor(GlobalMethod:ccc3(255,227,114))
		self.m_tSubjectList[index].select_key:setVisible(true)
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_InterestingAnswer(index)
end
--开始答题
function WndNationalAnswer:onBtnClickAnswer()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswer( )
end

function WndNationalAnswer:onBtnClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.FESTIVAL_TEXT28)
end
function WndNationalAnswer:onBtnClickClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
--答题奖励
function WndNationalAnswer:CreateRewardItem(data)
	if not data then return end

	local right = GetElement(self.answer_container,"right",WZUIContainer)
	local answer_FreeList = GetElement(right,"answer_FreeList",WZUIFreeListContainer)
	if not self.m_sIsRewardItemList then
		self.m_sIsRewardItemList = true
		for i = 1, #data do
			local element, tLuaObj = CellNotionalAnswerGetItem:createElement()
			self.m_tRewardItemList[i] = tLuaObj
			answer_FreeList:pushBack(WZUIContainer:luaTo(element))
			answer_FreeList:getMoveElement():setPositionY(answer_FreeList:getMinPosition().y)
			tLuaObj:setNationalAnswerMessage(i, data[i])
		end
	else
		for i,v in ipairs(self.m_tRewardItemList) do
			if v then
				v:setBtnGetStatus(i,data[i].status or -1, data[i].desc, data[i].reward, data[i].num, data[i].id)
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--获取基本信息
--就是前3个固定是参与答题|后3个固定是答对|第7个是获得物品数量|最后3个是幸运抽奖获得(根据策划所言)
--[[
FESTIVAL_TEXT24 = "参与答题%d/%d次",
FESTIVAL_TEXT25 = "答对%d/%d道题",
FESTIVAL_TEXT26 = "获得%d/%d张答题劵",
FESTIVAL_TEXT27 = "幸运抽奖获得%d/%d张答题劵",
]]
function WndNationalAnswer:_onGetAnswerInfoData(result, itemNum, rightNum, totalNum, rewardProcess, rewardStatus)
	self.m_nAnswerCouponCount = itemNum --答题卷的数
	self.m_sAnswerResult = result
	if result == 0 then
		if self.btnAnswer and self.tipNoticeContainer then
			self.answer_label_4:setText(LocalStrings.FESTIVAL_TEXT10)
			self.btnAnswer:setVisible(true)
			self.tipNoticeContainer:setVisible(true)
		end
	elseif result == 1 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetInterestingAnswer( )
	end
	if self.answer_value_1 then
		self.answer_value_1:setText(itemNum)
	end
	if self.answer_value_2 then
		self.answer_value_2:setText(rightNum)
	end
	if self.answer_value_3 then
		local count = string.format("%d",(rightNum / totalNum) * 100)
		self.answer_value_3:setText(count.."%")
	end
	if self.m_tRewardInfoData then
		local temp_data = CopyTable(self.m_tRewardInfoData)
		for i,v in ipairs(temp_data) do
			v.status = rewardStatus[i]
			local str = ""
			if i <= 3 then
				str = string.format(LocalStrings.FESTIVAL_TEXT24,tonumber(rewardProcess[i]),tonumber(v.target))
			elseif i > 3 and i <= 6 then
				str = string.format(LocalStrings.FESTIVAL_TEXT25,tonumber(rewardProcess[i]),tonumber(v.target))
			elseif i == 7 then
				str = string.format(LocalStrings.FESTIVAL_TEXT26,tonumber(rewardProcess[i]),tonumber(v.target))
			elseif i > 7 and i <= 10 then
				str = string.format(LocalStrings.FESTIVAL_TEXT27,tonumber(rewardProcess[i]),tonumber(v.target))
			end
			v.desc = str
		end
		self:taskSort(temp_data)
		self:CreateRewardItem(temp_data)
	end
end
--排序
function WndNationalAnswer:taskSort(data_sort)
	-- 0可领取 1已经领取了 2不可领取
	local temp = {
		[0] = 1, --可领取
		[1] = 3, --已领取
		[2] = 2, --未领取
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.id < b.id
		end
	end
	table.sort(data_sort, testFunc)
end
--获取题目信息
function WndNationalAnswer:_onStartAnswerResult(result, aIndex, title, answers)
	-- 1成功 2今日的题目已经答完了 3没有答题劵了
	if result == 1 then
		self:startSubjectContainer(aIndex, title, answers)
		if self.btnAnswer then
			self.btnAnswer:setVisible(false)
		end
		if self.tipNoticeContainer then
			self.tipNoticeContainer:setVisible(false)
		end
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.FESTIVAL_TEXT20)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.FESTIVAL_TEXT21)
	end
end
--奖励状态
function WndNationalAnswer:_onAnswerRewardInfo(rewardIds, rewardTargets, rewardItemCounts, rewardItemIds, rewardItemNums)
	local table_insert = table.insert
	local index = 1
	local data = {}
	for i=1,#rewardTargets do
		local tab = {}
		tab.target = rewardTargets[i]
		tab.id = rewardIds[i]
		local ids_item = {}
		local ids_num = {}
		for m=1,rewardItemCounts[i] do
			table_insert(ids_item, rewardItemIds[index])
			table_insert(ids_num, rewardItemNums[index])
			index = index + 1
		end
		tab.reward = ids_item
		tab.num = ids_num
		data[i] = tab
	end
	self.m_tRewardInfoData = data
end
--获取总排行榜
function WndNationalAnswer:_onAnswerRankTotalResult(myRank, myRightNum, myTotalNum, ranks, playerIds, levels, vipLevels, names, faceIds, headIds, headColors, sexs, rightNums, cross)
	if self.rank_container then
		
		local myValue = GetElement(self.rank_container,"myValue",WZUILabelTTF)
		if myRank >= 0 then 
			myValue:setText(myRank)
		else
			myValue:setText(LocalStrings.NOT_IN_RANKLIST)
		end
		local subjectRightCount = GetElement(self.rank_container,"subjectRightCount",WZUILabelTTF)
		subjectRightCount:setText(myRightNum)
		local rankContainer = GetElement(self.rank_container,"rank1",WZUIContainer)
		local rankFreeList = GetElement(rankContainer,"rankFreeList1",WZUIFreeListContainer)
		rankFreeList:removeAll()
		local data = {}
		for i=1,#ranks do
			local tab = {}
			tab.rank = ranks[i]
			tab.playerId = playerIds[i]
			tab.level = levels[i]
			tab.vipLevel = vipLevels[i]
			tab.name = names[i]
			tab.faceId = faceIds[i]
			tab.headId = headIds[i]
			tab.headColor = headColors[i]
			tab.sex = sexs[i]
			tab.rightNum = rightNums[i]
			tab.cross = cross[i]
			data[i] = tab
		end
		for i=1, #data do
			local element, tLuaObj = CellRank1Item:createElement()
			rankFreeList:pushBack(WZUIContainer:luaTo(element))
			rankFreeList:getMoveElement():setPositionY(rankFreeList:getMinPosition().y)
			tLuaObj:setRankItemMessage(1, data[i])
		end
	end
end
--获取公会排行榜
function WndNationalAnswer:_onAnswerRankGuildResult(myRank, myRightNum, myTotalNum, ranks, guildIds, levels, names, rightNums)
	if self.rank_container then
		local myValue2 = GetElement(self.rank_container,"myValue2",WZUILabelTTF)
		if myRank >= 0 then
			myValue2:setText(myRank)
		else
			myValue2:setText(LocalStrings.NOT_IN_RANKLIST)
		end
		local subjectRightCount2 = GetElement(self.rank_container,"subjectRightCount2",WZUILabelTTF)
		subjectRightCount2:setText(myRightNum)
		local rankContainer = GetElement(self.rank_container,"rank2",WZUIContainer)
		local rankFreeList = GetElement(rankContainer,"rankFreeList2",WZUIFreeListContainer)
		rankFreeList:removeAll()
		local data = {}
		for i=1,#ranks do
			local tab = {}
			tab.rank = ranks[i]
			tab.guildId = guildIds[i]
			tab.level = levels[i]
			tab.name = names[i]
			tab.rightNum = rightNums[i]
			data[i] = tab
		end
		for i=1, #data do
			local element, tLuaObj = CellRank1Item:createElement()
			rankFreeList:pushBack(WZUIContainer:luaTo(element))
			rankFreeList:getMoveElement():setPositionY(rankFreeList:getMinPosition().y)
			tLuaObj:setRankItemMessage(2, data[i])
		end
	end
end
--获取排行榜的奖励
-- 0:总排行 1:公会
function WndNationalAnswer:_onAnswerRankRewardResult(rType, ranks, itemCounts, itemIds, itemNums)
	if self.rank_container then
		local table_insert = table.insert
		local data = {}
		local index = 1
		for i=1,#ranks do
			local tab = {}
			local ids_item = {}
			local ids_num = {}
			for m=1,itemCounts[i] do
				table_insert(ids_item, itemIds[index])
				table_insert(ids_num, itemNums[index])
				index = index + 1
			end
			tab.rank = ranks[i]
			tab.reward = ids_item
			tab.num = ids_num
			data[i] = tab
		end
		local temp_index = {3,4}
		local rankContainer = GetElement(self.rank_container,"rank"..temp_index[rType+1], WZUIContainer)
		local rankFreeList = GetElement(rankContainer,"rankFreeList"..temp_index[rType+1], WZUIFreeListContainer)
		rankFreeList:removeAll()
		for i = 1, #data do
			local element, tLuaObj = CellReward1Item:createElement()
			rankFreeList:pushBack(WZUIContainer:luaTo(element))
			rankFreeList:getMoveElement():setPositionY(rankFreeList:getMinPosition().y)
			tLuaObj:setRankRewardItemMessage(data[i])
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------



function WndNationalAnswer:_adaptLanguage_vn(  )
    GetElement(self.m_root,"value_1",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.242,0.943))
    GetElement(self.m_root,"value_2",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.645,0.943))
    GetElement(self.m_root,"value_3",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.893,0.943))

    GetElement(self.m_root,"label_4",WZUILabelTTF):setFontSize(12)

    -- GetElement(self.m_root,"name_1",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"name_2",WZUILabelTTF):setScale(0.75)
end
