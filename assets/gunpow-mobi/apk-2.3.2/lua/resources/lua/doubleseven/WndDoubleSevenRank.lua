--WndDoubleSevenRank.lua
--@brief	WndDoubleSevenRank的UI模块
--@date		2020/08/03
--@author	hyx
--@note		情侣榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDoubleSevenRank:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDoubleSevenRank:onExit(element)
	self:_unInit()
	self:unregister()
end
function WndDoubleSevenRank:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndDoubleSevenRank:register()
	GlobalGame:getGameEventDispathcer():Add(WndDoubleSevenEvent.WndDoubleSevenEvent_ConfreeRank,self._onDoubleSevenConfreeRank,self)
end
function WndDoubleSevenRank:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndDoubleSevenEvent.WndDoubleSevenEvent_ConfreeRank,self._onDoubleSevenConfreeRank,self)
end
function WndDoubleSevenRank:actionCallback()
	self:initShow()
end
function WndDoubleSevenRank:initShow()
	GetElement(self.m_root, "title_name", WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT4)

	local titleCon = GetElement(self.m_root, "titleCon", WZUIContainer)
	self.m_tTitleChange = {}
	local name = {LocalStrings.ATH_REWARD_CHECK, LocalStrings.RANK}
	for i=1,2 do
		local tab = {}
		tab.normal = GetElement(titleCon, "normal_"..i, WZUIImage)
		tab.select = GetElement(titleCon, "select_"..i, WZUIImage)
		tab.select:setVisible(false)
		tab.name = GetElement(titleCon, "name_"..i, WZUILabelTTF)
		tab.name:setColor(GlobalMethod:ccc3(127,70,26))
		tab.name:setEnableStroke(false)
		tab.name:setText(name[i])
		self.m_tTitleChange[i] = tab
	end
	--默认是奖励
	self.m_tTitleChange[self.m_nCurIndex].normal:setVisible(false)
	self.m_tTitleChange[self.m_nCurIndex].select:setVisible(true)
	self.m_tTitleChange[self.m_nCurIndex].name:setEnableStroke(true)
	self.m_tTitleChange[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(255,236,193))
	self.m_tTitleChange[self.m_nCurIndex].name:setStrokeColor(GlobalMethod:ccc3(127,70,26))
	self.m_tTitleChange[self.m_nCurIndex].name:setStrokeSize(4)

	--奖励
	self.reward_container = GetElement(self.m_root, "reward_container", WZUIContainer)
	self.reward_container:setVisible(true)
	self.reward_freeList = GetElement(self.reward_container, "reward_freeList", WZUIFreeListContainer)
	--排名
	self.rank_container = GetElement(self.m_root, "rank_container", WZUIContainer)
	self.rank_container:setVisible(false)
	GetElement(self.rank_container,"rank_label",WZUILabelTTF):setText(LocalStrings.RANK)
	GetElement(self.rank_container,"love_label",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT12)
	GetElement(self.rank_container,"love_value_label",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT13)

	self.rank_freeList = GetElement(self.rank_container, "rank_freeList", WZUIFreeListContainer)
	self.score_freetext = GetElement(self.rank_container,"score_freetext",WZUIFreeTextBox)
	
	self.value_freetext = GetElement(self.rank_container,"value_freetext",WZUIFreeTextBox)
	local value = WndDoubleSeven:getMyConfreeValue()
	local str = string.format([[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%d</T>]],LocalStrings.DOUBLE_SEVEN_TEXT15, value)
	self.value_freetext:setShowText(str)

	self:setLovesRankItem(1)
end
--切换按钮
function WndDoubleSevenRank:onClickChangeTitle(element)
	local tag = tonumber(element:getTag())
	if self.m_nCurIndex == tag then return end

	if self.m_tTitleChange[self.m_nCurIndex] ~= nil then
		self.m_tTitleChange[self.m_nCurIndex].normal:setVisible(true)
		self.m_tTitleChange[self.m_nCurIndex].select:setVisible(false)
		self.m_tTitleChange[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(127,70,26))
		self.m_tTitleChange[self.m_nCurIndex].name:setEnableStroke(false)
	end
	if self.m_tTitleChange[tag] ~= nil then
		self.m_tTitleChange[tag].normal:setVisible(false)
		self.m_tTitleChange[tag].select:setVisible(true)
		self.m_tTitleChange[tag].name:setEnableStroke(true)
		self.m_tTitleChange[tag].name:setColor(GlobalMethod:ccc3(255,236,193))
		self.m_tTitleChange[tag].name:setStrokeColor(GlobalMethod:ccc3(127,70,26))
		self.m_tTitleChange[tag].name:setStrokeSize(4)
	end

	self.reward_container:setVisible(tag == 1)
	self.rank_container:setVisible(tag == 2)
	self:setLovesRankItem(tag)

	self.m_nCurIndex = tag
end
--处理子项的数据
function WndDoubleSevenRank:setLovesRankItem(tag)
	if self.m_tLovesItem[tag] == true then return end
	if tag == 1 then
		local count, data = self:getRankReward()
		for i = 1, count do
	        local element, tLuaObj = CellDoubleSevenRewardItem:createElement()
	        self.reward_freeList:pushBack(WZUIContainer:luaTo(element))
	        self.reward_freeList:getMoveElement():setPositionY(self.reward_freeList:getMinPosition().y)
	        tLuaObj:setRewardInitMessage(i, data[i])
	    end
	elseif tag == 2 then
		ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiRankingList( )
	end
	self.m_tLovesItem[tag] = true
end
--显示奖励的信息
function WndDoubleSevenRank:getRankReward()
	local count = 0
	local tData = {}

	local answer = CacheCenter:getGameParam().qixiRankingReward
	if answer then
		local answer = string.sub(answer,2,-2)
		local array = SplitStringWithSeparator(answer,"rank:")
		local rank_ids, rank_nums = {},{}
		local boy_ids, boy_nums = {},{}
		local girl_ids, girl_nums = {},{}

		local sex = CacheCenter:getPlayerInfo().sex
		-- sex 1 女
		for i=1,#array do
			if i >= 2 then
				local start1,endpos1 = string.find(array[i], ",reward_boy:", 1) 
				local sub1 = string.sub(array[i], 1, start1-1)
				rank_ids[i-1], rank_nums[i-1] = SplitItemString(sub1)

				local start2,endpos2 = string.find(array[i], ",reward_girl:", start1) 
				local start3,endpos3 = string.find(array[i], "]\"", start2) 
				if sex == 0 then
					local sub2 = string.sub(array[i], endpos1+1, start2-1)
					boy_ids[i-1], boy_nums[i-1] = SplitItemString(sub2)
				else
					local sub3 = string.sub(array[i], endpos2+1, start3)
					girl_ids[i-1], girl_nums[i-1] = SplitItemString(sub3)
				end
			end
		end
		count = #rank_ids
		for i,v in ipairs(rank_ids) do
			local tab = {}
			tab.rank_ids = rank_ids[i][1]
			tab.rank_nums = rank_nums[i][1]
			if sex == 0 then
				tab.reward_ids = boy_ids[i]
				tab.reward_nums = boy_nums[i]
			else
				tab.reward_ids = girl_ids[i]
				tab.reward_nums = girl_nums[i]
			end
			tData[i] = tab
		end
	end
	return count, tData
end

function WndDoubleSevenRank:onClickClose()
	WindowManager:removeWindow(self.m_root, self, true)
end
--显示情侣的排名
function WndDoubleSevenRank:showConfreeRank(playerId, nickname, headId, headColor, faceId, sex, level, confessSum)
	if next(playerId) == nil then
		ShowPanelNullTip(self.rank_container)
		return
	end

	local myPlayID = CacheCenter:getPlayerInfo().id
	local rankIndex = nil --计算个人的排名
	local tDataLeft = {} --左边的数据
	local tDataRight = {} --右边的数据
	for i=1,#playerId do
		local tab = {}
		tab.playerId = playerId[i]
		tab.nickname = nickname[i]
		tab.headId = headId[i]
		tab.headColor = headColor[i]
		tab.faceId = faceId[i]
		tab.sex = sex[i]
		tab.level = level[i]

		local id = math.ceil(i/2)
		if myPlayID == playerId[i] then
			rankIndex = id
		end		
		if i%2 == 0 then
			tDataRight[id] = tab
		else
			tDataLeft[id] = tab
		end
	end

	local rank_str = LocalStrings.NOT_IN_RANKLIST
	if rankIndex then
		rank_str = rankIndex
	end
	local str = string.format([[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%s</T>]],LocalStrings.DOUBLE_SEVEN_TEXT14,rank_str)
	self.score_freetext:setShowText(str)

	for i = 1, #confessSum do
        local element, tLuaObj = CellDoubleSevenRankItem:createElement()
        self.rank_freeList:pushBack(WZUIContainer:luaTo(element))
        self.rank_freeList:getMoveElement():setPositionY(self.rank_freeList:getMinPosition().y)
        tLuaObj:setRankInitMessage(i, tDataLeft[i], tDataRight[i], confessSum[i])
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndDoubleSevenRank:_onDoubleSevenConfreeRank(playerId, nickname, headId, headColor, faceId, sex, level, confessSum)
	self:showConfreeRank(playerId, nickname, headId, headColor, faceId, sex, level, confessSum)
end


-------------------------------------私有方法模块End----------------------------------------
