--WndCharmSpace.lua
--@brief	WndCharmSpace的UI模块
--@date		2016/08/19
--@author	maopeiting
--@note		魅力空间


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCharmSpace:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	local edit = GetElement(self.m_root,"edit_WndCharmSpace",WZUIEditBox)
	edit:setPlaceHolder(LocalStrings.TOUCH_TO_INPUT)
end

function WndCharmSpace:onEnterTransitionDidFinish( element )
	ProtocolProcessorWndCharmRank:regAll()
	CacheCenter:registerUpateDressSuitObserver(self) --注册多套时装
	--推荐消耗
	local tConfigCost = CacheCenter:getGameParam().glamourfashionConsume
	local string = string.sub(tConfigCost,2,-2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]
	self.m_fashionRecommendCost = {tonumber(id), tonumber(num)}
	self.m_nFashionRecommendConfigTime = tonumber(CacheCenter:getGameParam().glamourfashionRecommendtinme)

	GetElement(self.m_root, "checkGroupBoxLeft_WndCharmSpace", WZUICheckBoxGroup):setCheckIndex(self.m_nInterfaceType)
	GetElement(self.m_root,"con_WndCharmSpace",WZUIContainer):enableSchedule("downloadFile",0.01)
	self:_setContentByType()

	if self.m_nInterfaceType == 0 then 
		ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2)
	elseif self.m_nInterfaceType == 1 then 
		ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo()
	end
end

--@brief	关闭按钮的点击事件
function WndCharmSpace:onClose(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root,self,true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCharmSpace:onExit(element)
	CacheCenter:unregisterUpateDressSuitObserver(self)
	if self.m_root then 
		GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):disableSchedule()
	end
	self:_unInit()
	--ProtocolProcessorWndSpace:unregAll()
	ProtocolProcessorWndCharmRank:unregAll()
end

function WndCharmSpace:createLoadingBox()
    -- if not self.loadingId then
    --     self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingBox)
    -- end
end

function WndCharmSpace:closeLoadingBox()
    -- MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    -- self.loadingId = nil
end

--@brief 	点击切换类型
function WndCharmSpace:onClickLeftBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local nTag = element:getTag()

	if self.m_nInterfaceType == nTag - 1 then return end 
	self.m_nInterfaceType = nTag - 1

	self:_setContentByType()
	WZLog("WndCharmSpace:onClickLeftBox", self.m_nInterfaceType, self.m_nSpaceTag)
	if self.m_nInterfaceType == 0 then 
		self.m_nFashionTag = self.tag 
		self:exchangeTopTab(self.m_nSpaceTag)
	elseif self.m_nInterfaceType == 1 then 
		self.m_nSpaceTag = self.tag 
		self:exchangeTopTab(self.m_nFashionTag)
	end
end

--@brief	标签的点击事件
function WndCharmSpace:onCheckBox( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()

	if self.tag == tag then return end 

	self:exchangeTopTab(tag)
end

--@brief	切换顶部标签
function WndCharmSpace:exchangeTopTab(tag)
	-- body
	self.tag = tag
	WZLog("WndCharmSpace:exchangeTopTab", type(self.preTag), self.preTag, self.currentTag)
	if self.m_nInterfaceType == 0 then 
		if tag == 4 then
		--	if self.preTag ~= tag then
				self.preTag = tag

				self:_updateCheck(tag)
				self:_update(tag)
		--	end
		else
		--	if self.preTag ~= tag then
				self.preTag = tag

				self:_updateCheck(tag)
		--	end
		end

		if tag == 1 then
			if self.currentTag == 1 then
				ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2)
			elseif self.currentTag == 2 then
				ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(0)
			elseif self.currentTag == 3 then
				ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(1)
			end
		elseif tag == 2 then
			ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(26) --鲜花周榜的总排行榜
			ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(26) --鲜花周榜的个人排行榜
		elseif tag == 3 then
			ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(27) --鲜花总榜的总排行榜
			ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(27) --鲜花总榜的个人排行榜
		end
	elseif self.m_nInterfaceType == 1 then 
		if tag >= 1 and tag <= 4 then 
			if tag == 4 then
			--	if self.preTag ~= tag then
					self.preTag = tag

					self:_updateCheck(tag)
					self:_update(tag)
			--	end
			else
			--	if self.preTag ~= tag then
					self.preTag = tag

					self:_updateCheck(tag)
			--	end
			end
			if tag == 1 then
				if self.currentTag == 1 then
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2)
				elseif self.currentTag == 2 then
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(0)
				elseif self.currentTag == 3 then
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1)
				end
			elseif tag == 2 then
				self.m_nWeekListPositionY = nil 
				self.m_nBeGoodPlayerId = nil 

				ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(48) --点赞周榜的总排行榜
				ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(48) --点赞周榜的个人排行榜
			elseif tag == 3 then
				ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(49) --点赞总榜的总排行榜
				ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(49) --点赞总榜的个人排行榜
			end
		elseif tag == 5 then 	--报名
			ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo()
		elseif tag == 6 then 	--历届冠军
			ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList( )
		end
	end
end

--@brief	更新标签的点亮状态
function WndCharmSpace:_updateCheck( tag )
	local tab1 = GetElement(self.m_root,"tab1_WndCharmSpace",WZUITableContainer) --奖励列表
	local tab2 = GetElement(self.m_root,"tab2_WndCharmSpace",WZUITableContainer) --鲜花榜列表
	local conList = GetElement(self.m_root,"conList_WndCharmSpace",WZUIContainer) --鲜花榜单
	local conDetail = GetElement(self.m_root,"conDetail_WndCharmSpace",WZUIContainer) --人物详情
	local conRecommend1 = GetElement(self.m_root,"conRecommend1_WndCharmSpace",WZUIContainer)
	local conFlower = GetElement(self.m_root,"conFlower_WndCharmSpace",WZUIContainer)
	local conReward = GetElement(self.m_root,"conReward_WndCharmSpace",WZUIContainer)
	local tab3 = GetElement(self.m_root,"tab3_WndCharmSpace",WZUITableContainer) --随机推荐
	local txtMessage = GetElement(self.m_root,"txtMessage_WndCharmSpace",WZUILabelTTF)

	tab3:cleanTable()
	tab1:cleanTable()
	tab2:cleanTable()

	if self.m_nInterfaceType == 0 then 
		for i=1,4 do
			GetElement(self.m_root,"con"..i.."_WndCharmSpace",WZUIContainer):setVisible(i==tag)
		end
	elseif self.m_nInterfaceType == 1 then 
		self:_showFashionTopTab()
	end

	--根据标签项显示相应的内容
	if tag == 1 then
		txtMessage:setVisible(false)
		tab3:setVisible(true)
		tab1:setVisible(false)
		tab2:setVisible(false)
		conList:setVisible(false)
		conDetail:setVisible(false)
		conRecommend1:setVisible(true)
		conFlower:setVisible(false)
		conReward:setVisible(false)
		--txtRefresh:setText(LocalStrings.CHARM_REFRESH)
	elseif tag == 2 then
		txtMessage:setVisible(false)
		tab3:setVisible(false)
		tab1:setVisible(false)
		tab2:setVisible(true)
		conList:setVisible(false)
		conDetail:setVisible(false)
		conRecommend1:setVisible(false)
		conFlower:setVisible(true)
		conReward:setVisible(false)
		if self.m_nInterfaceType == 1 then 
			self:_setFashionContentVisible(false, true, false, false, false, false)
		end
	elseif tag == 3 then
		txtMessage:setVisible(false)
		tab3:setVisible(false)
		tab1:setVisible(false)
		tab2:setVisible(true)
		conList:setVisible(false)
		conDetail:setVisible(false)
		conRecommend1:setVisible(false)
		conFlower:setVisible(true)
		conReward:setVisible(false)
		if self.m_nInterfaceType == 1 then 
			self:_setFashionContentVisible(false, false, true, false, false, false)
		end
	elseif tag == 4 then
		if self.m_nInterfaceType == 0 then 
			txtMessage:setVisible(false)
			tab3:setVisible(false)
			tab1:setVisible(true)
			tab2:setVisible(false)
			conList:setVisible(false)
			conDetail:setVisible(false)
			conRecommend1:setVisible(false)
			conFlower:setVisible(false)
			conReward:setVisible(true)
		elseif self.m_nInterfaceType == 1 then 
			txtMessage:setVisible(false)
			tab3:setVisible(false)
			tab1:setVisible(true)
			tab2:setVisible(false)
			conList:setVisible(false)
			conDetail:setVisible(false)
			conRecommend1:setVisible(false)
			conFlower:setVisible(false)
			conReward:setVisible(true)

			self:_setFashionContentVisible(false, false, false, true, false, false)
		end
	end
end

--@brief	推荐按钮点击事件
function WndCharmSpace:onRecommend( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	self.currentTag = tag
	self:_updateRecommend(tag)

	if self.m_nInterfaceType == 1 then 
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(0)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1)
		end
	else
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(0)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(1)
		end
	end
end

--@brief	更新选择推荐性别的点亮状态
function WndCharmSpace:_updateRecommend( tag )
	for i=1,3 do
		GetElement(self.m_root,"con"..(i+13).."_WndCharmSpace",WZUIContainer):setVisible(i==tag)
	end
end

--@brief	刷新按钮点击事件
function WndCharmSpace:onRefresh( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	if self.m_nInterfaceType == 0 then 
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(0)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(1)
		end
	else
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(0)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1)
		end
	end

	self.m_root:enableSchedule("_schedule",1)
	GetElement(self.m_root,"btnRefresh_WndCharmSpace",WZUIButton):setTouchEnable(false)
	local txtTime = GetElement(self.m_root,"txtTime_WndCharmSpace",WZUILabelTTF)
	local txtRefresh = GetElement(self.m_root,"txtRefresh_WndCharmSpace",WZUILabelTTF)
	txtTime:setText(self.time.."s")
	txtTime:setVisible(true)
	txtRefresh:setVisible(false)
end

--@brief	冷却刷新按钮两秒
function WndCharmSpace:_schedule( element )
	local txtRefresh = GetElement(self.m_root,"txtRefresh_WndCharmSpace",WZUILabelTTF)
	local txtTime = GetElement(self.m_root,"txtTime_WndCharmSpace",WZUILabelTTF)

	self.time = self.time - 1 
	txtTime:setText(self.time.."s")
	if self.time <= 0 then
		txtTime:setVisible(false)
		txtRefresh:setVisible(true)
		element:disableSchedule()
		GetElement(self.m_root,"btnRefresh_WndCharmSpace",WZUIButton):setTouchEnable(true)
		txtRefresh:setText(LocalStrings.CHARM_REFRESH)
		self.time = 2
	end
	--WZLog("---WndCharmSpace:_schedule--",txtTime:getText(),self.time)
end

--@brief	更新随机推荐，鲜花周榜，鲜花总榜，排名奖励内容
--@param	tag:标签值
function WndCharmSpace:_update( tag )
	if tag == 1 then --随机推荐
		if self.m_nInterfaceType == 0 then 
			GetElement(self.m_root,"conRecommend_WndCharmSpace",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(false)
			local tab = GetElement(self.m_root,"tab3_WndCharmSpace",WZUITableContainer)
			for i=1,#self.playerId do
				WZLog("--WndCharmSpace1--")
				local celElement,tCell = CellCharmRecommend:createElement()
				if celElement and tCell then
					WZLog("---WndCharmSpace2---")
					celElement:setTag(i-1)
					tCell:setData(self.playerId[i],self.playerName[i],self.photoUrl[i],self.sex[i],self.cross[i],self.level[i])
					tab:setCellElement(celElement)
				end
			end
		else
			self:_showFashionRecommendList()
		end
	elseif tag == 2 then --周鲜花榜
		GetElement(self.m_root,"conRecommend_WndCharmSpace",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(true)
		local conList = GetElement(self.m_root,"conList_WndCharmSpace",WZUIContainer) --鲜花榜单
		local conDetail = GetElement(self.m_root,"conDetail_WndCharmSpace",WZUIContainer) --人物详情
		local tab = GetElement(self.m_root,"tab2_WndCharmSpace",WZUITableContainer)
		local txtMessage = GetElement(self.m_root,"txtMessage_WndCharmSpace",WZUILabelTTF)
		if #self.rank >= 100 then
			txtMessage:setVisible(false)
			conList:setVisible(true)
			conDetail:setVisible(true)
			for i=1,100 do
				local celElement,tCell = CellCharmRank:createElement()
				if celElement and tCell then
					celElement:setTag(i-1)
					tCell:setData(i,self.rank[i],self.playerId[i],self.photoUrl[i],self.playerName[i],self.sex[i],self.level[i],self.cross[i],self.partner[i],self.server[i],self.community[i],self.flowerNum[i])
					tCell:setRankType(26)
					if self.m_nInterfaceType == 1 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(48)
					end
					tab:setCellElement(celElement)
					if self.m_nBeGoodPlayerId then 
						if self.m_nBeGoodPlayerId == self.playerId[i] then 
							self.preCel = tCell
						end
					else
						if i == 1 then
							self.preCel = tCell
						end
					end
				end
			end
		elseif #self.rank < 100 and #self.rank > 0 then
			txtMessage:setVisible(false)
			conList:setVisible(true)
			conDetail:setVisible(true)
			for i=1,#self.rank do
				local celElement,tCell = CellCharmRank:createElement()
				if celElement and tCell then
					celElement:setTag(i-1)
					tCell:setData(i,self.rank[i],self.playerId[i],self.photoUrl[i],self.playerName[i],self.sex[i],self.level[i],self.cross[i],self.partner[i],self.server[i],self.community[i],self.flowerNum[i])
					tCell:setRankType(26)
					if self.m_nInterfaceType == 1 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(48)
					end
					tab:setCellElement(celElement)
					if self.m_nBeGoodPlayerId then 
						if self.m_nBeGoodPlayerId == self.playerId[i] then 
							self.preCel = tCell
						end
					else
						if i == 1 then
							self.preCel = tCell
						end
					end
				end
			end
		elseif #self.rank <= 0 then
			txtMessage:setVisible(true)
			conList:setVisible(false)
			conDetail:setVisible(false)
			GetElement(self.m_root,"conList_WndCharmSpace",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"conDetail_WndCharmSpace",WZUIContainer):setVisible(false)
			GetElement(self.m_root, "txtFashionPlayerName_WndCharmSpace", WZUILabelTTF):setText("")
			local conFashionDetail = GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer)
			if conFashionDetail:getChildByTag(11) then 
				conFashionDetail:removeChildByTag(11, true)
			end
			txtMessage:setText(LocalStrings.CHARM_RESULT)
		end
		if self.m_nWeekListPositionY then 
			tab:getMoveElement():setPositionY(self.m_nWeekListPositionY)
		else
			tab:getMoveElement():setPositionY(tab:getMinPosition().y)
		end
	elseif tag == 3 then --总鲜花榜
		GetElement(self.m_root,"conRecommend_WndCharmSpace",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(true)
		local conList = GetElement(self.m_root,"conList_WndCharmSpace",WZUIContainer) --鲜花榜单
		local conDetail = GetElement(self.m_root,"conDetail_WndCharmSpace",WZUIContainer) --人物详情
		local tab = GetElement(self.m_root,"tab2_WndCharmSpace",WZUITableContainer)
		local txtMessage = GetElement(self.m_root,"txtMessage_WndCharmSpace",WZUILabelTTF)
		if #self.rank >= 100 then
			txtMessage:setVisible(false)
			conList:setVisible(true)
			conDetail:setVisible(true)
			for i=1,100 do
				local celElement,tCell = CellCharmRank:createElement()
				if celElement and tCell then
					celElement:setTag(i-1)
					tCell:setData(i,self.rank[i],self.playerId[i],self.photoUrl[i],self.playerName[i],self.sex[i],self.level[i],self.cross[i],self.partner[i],self.server[i],self.community[i],self.flowerNum[i])
					tCell:setRankType(27)
					if self.m_nInterfaceType == 1 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(49)
					end
					tab:setCellElement(celElement)
					if i == 1 then
						self.preCel = tCell
					end
				end
			end
		elseif #self.rank < 100 and #self.rank > 0 then
			txtMessage:setVisible(false)
			conList:setVisible(true)
		 	conDetail:setVisible(true)
			for i=1,#self.rank do
				local celElement,tCell = CellCharmRank:createElement()
				if celElement and tCell then
					celElement:setTag(i-1)
					tCell:setData(i,self.rank[i],self.playerId[i],self.photoUrl[i],self.playerName[i],self.sex[i],self.level[i],self.cross[i],self.partner[i],self.server[i],self.community[i],self.flowerNum[i])
					tCell:setRankType(27)
					if self.m_nInterfaceType == 1 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(49)
					end
					tab:setCellElement(celElement)
					if i == 1 then
						self.preCel = tCell
					end
				end
			end
		elseif #self.rank <= 0 then
			txtMessage:setVisible(true)
			conList:setVisible(false)
			conDetail:setVisible(false)
			GetElement(self.m_root,"conList_WndCharmSpace",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"conDetail_WndCharmSpace",WZUIContainer):setVisible(false)
			local conFashionDetail = GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer)
			GetElement(self.m_root, "txtFashionPlayerName_WndCharmSpace", WZUILabelTTF):setText("")
			if conFashionDetail:getChildByTag(11) then 
				conFashionDetail:removeChildByTag(11, true)
			end
			txtMessage:setText(LocalStrings.CHARM_RESULT)
		end

		tab:getMoveElement():setPositionY(tab:getMinPosition().y)

	elseif tag == 4 then --排名奖励
		GetElement(self.m_root,"conRecommend_WndCharmSpace",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(false)
		--WZLog("--WndCharmSpace:_update4--")
		local m = 0
		local num = 0
		local sex = CacheCenter:getPlayerInfo().sex

		local tab = GetElement(self.m_root,"tab1_WndCharmSpace",WZUITableContainer)
		local tTableReward = GDatatab_charm_rank_reward
		if self.m_nInterfaceType == 1 then 
			tTableReward = GDatatab_glamour_fashion
		end
		for k,v in pairs(tTableReward) do
			num = num + 1
		end

		if sex == 0 then --男性玩家
			for i=1,num do
				if tTableReward["id_"..i].type == 1 then
					m = m + 1
					local celElement,tCell = CellCharmReward:createElement()
					if celElement and tCell then
						celElement:setTag(m-1)
						tCell:setData(tTableReward["id_"..i].rank,tTableReward["id_"..i].reward_boy,m)
						--WZLog("---reward----",Serialize(tTableReward["id_"..i].reward_boy))
						tab:setCellElement(celElement)
					end
				end
			end

		elseif sex == 1 then --女性玩家
			for i=1,num do
				if tTableReward["id_"..i].type == 1 then
					m = m + 1
					local celElement,tCell = CellCharmReward:createElement()
					if celElement and tCell then
						celElement:setTag(m-1)
						--WZLog("---reward----",Serialize(tTableReward["id_"..i].reward_girl))
						tCell:setData(tTableReward["id_"..i].rank,tTableReward["id_"..i].reward_girl,m)
						tab:setCellElement(celElement)
					end
				end
			end

		end
		tab:getMoveElement():setPositionY(tab:getMinPosition().y)
	end
end

function WndCharmSpace:_update2( tag )
	GetElement(self.m_root,"imgWeek_WndCharmSpace",WZUI9Image):setVisible(true)
	GetElement(self.m_root,"imgTotal_WndCharmSpace",WZUI9Image):setVisible(false)
	local txtRank1 = GetElement(self.m_root,"txt3_WndCharmSpace",WZUILabelTTF) --我的排名
	local txtRank2 = GetElement(self.m_root,"txt5_WndCharmSpace",WZUILabelTTF)
	local txtFlowerNum1 = GetElement(self.m_root,"txtNum1_WndCharmSpace",WZUILabelTTF) --我的周鲜花数量
	local txtFlowerNum2 = GetElement(self.m_root,"txtNum2_WndCharmSpace",WZUILabelTTF) --我的总鲜花数量
	if self.m_nInterfaceType == 1 then 
		txtFlowerNum1 = GetElement(self.m_root,"txtGoodNum1_WndCharmSpace",WZUILabelTTF) --我的周点赞数量
		txtFlowerNum2 = GetElement(self.m_root,"txtGoodNum2_WndCharmSpace",WZUILabelTTF) --我的总点赞数量
	end

	--WZLog("---WndCharmSpace:getMyRankListInfo--",Serialize(CacheCenter:getMyRankListInfo()))
	local myRankList = CacheCenter:getMyRankListInfo()

	if tag == 2 then
		WZLog("---playerSpaceWeeklyRec---",CacheCenter:getGameParam().playerSpaceWeeklyRec)
		if self.m_nInterfaceType == 0 then 
			GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conFlower3_WndCharmSpace", WZUIContainer):setVisible(true)
			GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setText(string.format(LocalStrings.CHARM_RELOAD,CacheCenter:getGameParam().playerSpaceWeeklyRec))
		elseif self.m_nInterfaceType == 1 then 
			GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conFlower3_WndCharmSpace", WZUIContainer):setVisible(false)
			GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setText(string.format(LocalStrings.CHARM_LIFT24,CacheCenter:getGameParam().glamourfashionWeeklyRec))
			GetElement(self.m_root,"txtWeekWord_WndCharmSpace",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"txtTotalWord_WndCharmSpace",WZUILabelTTF):setVisible(false)
		end
		GetElement(self.m_root,"txt4_WndCharmSpace",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt2_WndCharmSpace",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF):setVisible(false)
		txtRank1:setVisible(true)
		txtRank2:setVisible(false)
		local rank 
		local flowerNum
		if self.m_nInterfaceType == 1 then 
			rank = myRankList[48].myRank
			flowerNum = myRankList[48].rankValue
		else
			rank = myRankList[26].myRank
			flowerNum = myRankList[26].rankValue
		end

		--WZLog("---WndCharmSpace1:rank,flowerNum---",rank,flowerNum)

		if rank == -1 then
			txtRank1:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			txtRank1:setText(rank)
		end
		txtFlowerNum1:setText(flowerNum)

	elseif tag == 3 then
		WZLog("---playerSpaceTotalRec---",CacheCenter:getGameParam().playerSpaceTotalRec)
		GetElement(self.m_root,"imgWeek_WndCharmSpace",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"imgTotal_WndCharmSpace",WZUI9Image):setVisible(true)
		txtRank1:setVisible(false)
		txtRank2:setVisible(true)
		GetElement(self.m_root,"txt4_WndCharmSpace",WZUILabelTTF):setVisible(true)
		GetElement(self.m_root,"txt2_WndCharmSpace",WZUILabelTTF):setVisible(false)
		if self.m_nInterfaceType == 0 then 
			GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(false)
			GetElement(self.m_root, "conFlower3_WndCharmSpace", WZUIContainer):setVisible(true)

			GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF):setText(string.format(LocalStrings.CHARM_RELOAD2,CacheCenter:getGameParam().playerSpaceTotalRec))
		elseif self.m_nInterfaceType == 1 then 
			GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF):setText(string.format(LocalStrings.CHARM_LIFT25,CacheCenter:getGameParam().glamourfashionTotalRec))
			GetElement(self.m_root,"txtWeekWord_WndCharmSpace",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"txtTotalWord_WndCharmSpace",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conFlower3_WndCharmSpace", WZUIContainer):setVisible(false)
		end
		GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setVisible(false)
		GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF):setVisible(true)
		local rank 
		local flowerNum 
		if self.m_nInterfaceType == 1 then  
			rank = myRankList[49].myRank
			flowerNum = myRankList[49].rankValue
		else
			rank = myRankList[27].myRank
			flowerNum = myRankList[27].rankValue
		end
		--WZLog("---WndCharmSpace2:rank,flowerNum---",rank,flowerNum)
		if rank == -1 then
			txtRank2:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			txtRank2:setText(rank)
		end
		txtFlowerNum2:setText(flowerNum)
	end

	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or 
		ProjConfig.LANGUAGE == "vn" then
		local conFlower1 = GetElement(self.m_root,"conFlower1_WndCharmSpace",WZUIContainer)
		conFlower1:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
		GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setFontSize(16)
		local conFlower6 = GetElement(self.m_root,"conFlower6_WndCharmSpace",WZUIContainer)
		conFlower6:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
		GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF):setFontSize(20)
		GetElement(self.m_root,"conFlower2_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.638,0.5))
		GetElement(self.m_root,"conFlower3_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.91,0.5))
	end
end

--@brief	点击奖励物品时显示tips
function WndCharmSpace:onOthersClick( tCell,tag,tData )
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief window的点击事件
function WndCharmSpace:onTouch(element, point)
	WndItemInfo:onCloseClick()
	WndTips:onCloseClick()

	if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(point) then
        self.m_tCellDressSuit:hideSuitList()
    end

    if self.m_nInterfaceType == 1 then 
    	if self.tag == 1 then 
    		self:_cancelFashionRecommendSel(point)
    	end
    end
end

--@brief	点击鲜花榜的cell时，右边容器显示其详细信息
--@param	data：玩家信息数据
--@param 	roleInfo: 玩家形象数据
function WndCharmSpace:_showDetail(data, roleInfo)
	if self.m_nInterfaceType == 1 then 
		self.m_tRankRoleInfo = roleInfo

		GetElement(self.m_root, "conDetail_WndCharmSpace", WZUIContainer):setVisible(false)
		local conFashionDetail = GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer)
		conFashionDetail:setVisible(true)
		if conFashionDetail:getChildByTag(11) then 
			conFashionDetail:removeChildByTag(11, true)
		end

		GetElement(self.m_root, "txtFashionPlayerName_WndCharmSpace", WZUILabelTTF):setText(roleInfo.playerName)

		local tEquip = {}
	    table.insert(tEquip, roleInfo.headId)
	    table.insert(tEquip, roleInfo.faceId)
	    table.insert(tEquip, roleInfo.bodyId)
	    table.insert(tEquip, roleInfo.wingId)

		local conPlayer = CreatePlayerFigure(roleInfo.sex, tEquip, "wait0", nil, nil, ccp(-0.4,1.5), nil, nil, nil, nil,roleInfo.headColor, roleInfo.bodyColor)
		conPlayer:getAnimNode():setTouchEnable(false)
        conFashionDetail:addChild(conPlayer:getAnimNode(), 0, 11)
		return 
	end

	GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer):setVisible(false)
	GetElement(self.m_root, "conDetail_WndCharmSpace", WZUIContainer):setVisible(true)
	local imgHead = GetElement(self.m_root,"imgHead_WndCharmSpace",WZUIImage)
	local txtLevel= GetElement(self.m_root,"txtLevel_WndCharmSpace",WZUILabelTTF)
	local txtID = GetElement(self.m_root,"txtID_WndCharmSpace",WZUILabelTTF)
	local txtServer = GetElement(self.m_root,"txtServer_WndCharmSpace",WZUILabelTTF)
	local txtPartner = GetElement(self.m_root,"txtPartner_WndCharmSpace",WZUILabelTTF)
	local txtCommunity = GetElement(self.m_root,"txtCommunity_WndCharmSpace",WZUILabelTTF)
	local imgBoy = GetElement(self.m_root,"imgBoy_WndCharmSpace",WZUI9Image) --男性图标
	local imgGirl = GetElement(self.m_root,"imgGirl_WndCharmSpace",WZUI9Image) --女性图标
	local imgCross = GetElement(self.m_root,"imgKua_WndCharmSpace",WZUIImage) --跨服标识
	local txtName1 = GetElement(self.m_root,"txtName1_WndCharmSpace",WZUILabelTTF)
	local txtName2 = GetElement(self.m_root,"txtName2_WndCharmSpace",WZUILabelTTF)
	local btn1 = GetElement(self.m_root,"btn1_WndCharmSpace",WZUIButton) --个人信息
	local btn2 = GetElement(self.m_root,"btn2_WndCharmSpace",WZUIButton) --个人空间

	if data.photoUrl == "" and data.sex == 0 then
		imgHead:setVisible(true)
		local con = GetElement(self.m_root,"conHead_WndCharmSpace",WZUIContainer)
		if con:getChildByTag(99) then
 			con:removeChildByTag(99,true)
 		end
		imgHead:setFile("ui/space/common_icon_renxiangnan.png")
		self.currentPhoto = "ui/space/common_icon_renxiangnan.png"
	elseif data.photoUrl == "" and data.sex == 1 then
		imgHead:setVisible(true)
		local con = GetElement(self.m_root,"conHead_WndCharmSpace",WZUIContainer)
		if con:getChildByTag(99) then
 			con:removeChildByTag(99,true)
 		end
		imgHead:setFile("ui/space/common_icon_renxiangnv.png")
		self.currentPhoto = "ui/space/common_icon_renxiangnv.png"
	elseif data.photoUrl ~= "" then
		local path = CCFileUtils:sharedFileUtils():getTmpWritablePath()..data.photoUrl
		-- local bExist = WZFileUtil:isFileExist(path)
		-- if bExist then
		-- 	imgHead:setVisible(true)
		-- 	local con = GetElement(self.m_root,"conHead_WndCharmSpace",WZUIContainer)
		-- 	if con:getChildByTag(99) then
 	-- 			con:removeChildByTag(99,true)
 	-- 		end
		-- 	imgHead:setFile(path)
		-- else
			--下载头像
		    --添加下载图片Cell
			local con = GetElement(self.m_root,"conHead_WndCharmSpace",WZUIContainer)
			if con:getChildByTag(99) then
 				con:removeChildByTag(99,true)
 			end
 			imgHead:setVisible(false)
			local celElement,tCell = CellDownloadImg:createElement()
			con:addChild(celElement)
			self:addDownloadFileList(data.photoUrl, tCell, nil, 125)
		--end
		self.currentPhoto = path
		--WZLog("---path---",path)
	end
	--WZLog("---photoUrl---",data.photoUrl)

	txtLevel:setText("Lv"..data.level)
	txtID:setText("ID:"..data.playerId)
	txtServer:setText(LocalStrings.CHARM_SERVER..":"..data.server)

	if data.partner == "" then
		txtPartner:setText(LocalStrings.RANK_KING_DESC8..LocalStrings.CHARM_SINGLE)
	elseif data.partner ~= "" then
		txtPartner:setText(LocalStrings.RANK_KING_DESC8..data.partner)
	end

	if data.community == "" then
		txtCommunity:setText(LocalStrings.CHARM_COMMUNITY..LocalStrings.SHOP_NOGONGHUI)
	elseif data.community ~= "" then
		txtCommunity:setText(LocalStrings.CHARM_COMMUNITY..data.community)
	end

	if data.sex == 0 then
		imgBoy:setVisible(true)
		imgGirl:setVisible(false)
	elseif data.sex == 1 then
		imgBoy:setVisible(false)
		imgGirl:setVisible(true)
	end

	if data.cross == "0" then --本服
		imgCross:setVisible(false)
		txtName2:setVisible(true)
		txtName2:setText(data.playerName)
		txtName1:setVisible(false)
	elseif data.cross == "1" then --跨服
		imgCross:setVisible(true)
		txtName1:setVisible(true)
		txtName1:setText(data.playerName)
		txtName2:setVisible(false)
	end

	self.currentCross = data.cross
	self.currentPlayerId = tonumber(data.playerId)
	--WZLog("--self.currentPlayerId1--",data.photoUrl,data.sex)

end

--@brief	点击信息按钮进入玩家信息事件
function WndCharmSpace:onIntoInformation( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	--WZLog("--self.currentPlayerId2--",self.currentPlayerId,self.currentCross)
	WndCheckOther:show(self.currentPlayerId)
end

--@brief	点击空间按钮进入玩家空间事件
function WndCharmSpace:onIntoSpace( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	--WZLog("--self.currentPlayerId3--",self.currentPlayerId,self.currentCross)
	WndSpaceMain:show(self.currentPlayerId)
end

--@brief	根据玩家ID搜索玩家
function WndCharmSpace:onResearch( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local edit = GetElement(self.m_root,"edit_WndCharmSpace",WZUIEditBox)
    local searchID = edit:getText()
    --WZLog("--onResearch--",tonumber(searchID)==nil)
    if searchID=="" then
    	MsgBoxManager:showTipBox(LocalStrings.TOUCH_TO_INPUT)
	elseif tonumber(searchID) ~= nil then
		if self.m_nInterfaceType == 0 then 
			ProtocolProcessorWndSpace:send_SPACE_SearchPlayer(tonumber(searchID))
		elseif self.m_nInterfaceType == 1 then 
			ProtocolProcessorWndSpace:send_SPACE_SearchFashionPlayer(tonumber(searchID))
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO22)
	end
end

--@brief	点击进入收花记录界面
function WndCharmSpace:onSendFlower( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local wnd = WndSpaceRecord:createElement()
	WindowManager:addWindow(wnd, WndSpaceRecord, true, nil, nil, true)
	WndSpaceRecord.m_nType = 2
	WndSpaceRecord.pageNumber = 1
	ProtocolProcessorWndSpace:send_SPACE_GetFlowersList(CacheCenter:getPlayerInfo().id)
end

--@brief	点击放大图像
function WndCharmSpace:onScaleHead( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local wnd = WndSpaceView:createElement()
	WindowManager:addWindow(wnd, WndSpaceView, true, nil, nil, true)
	GetElement(wnd,"imgWndSpaceView",WZUIImage):setFile(self.currentPhoto)
end

--@brief	规则详细
function WndCharmSpace:onDescription( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	if self.m_nInterfaceType == 1 then 
		WndSingleMapDesc:showInterface(LocalStrings.CHARM_LIFT32)
	else
		WndSingleMapDesc:showInterface(LocalStrings.CHARM_DES)
	end
end

--@brief 	点击报名按钮回调
function WndCharmSpace:onClickApply(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断有没有报名
	if self.m_tMyFashionData.applyState == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT10)
		return
	end
	--幻化不让参加比赛
	if CacheCenter:getPlayerInfo().showShape == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT30)
		return 
	end
	--判断有没有穿戴时装
	local tEquip = CacheCenter:getEquipedDecorationList()
	if tEquip == nil or #tEquip == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT11)
		return 
	end
	MsgBoxManager:showConfirmBox(LocalStrings.CHARM_LIFT12, self, self.sureToApply)
end

--@brief 	确定报名
function WndCharmSpace:sureToApply()
	--body
	ProtocolProcessorWndSpace:send_SPACE_Operation(1)
end

--@brief 	点击报名界面推荐按钮回调
function WndCharmSpace:onFashionRecommend(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndCharmSpace:onFashionRecommend", self.m_tMyFashionData.recommendTime)
	--判断是否已报名
	if self.m_tMyFashionData.applyState == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT22)
		return 
	end
	--判断有没有推荐
	if self.m_tMyFashionData.recommendTime > 0 then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT13)
		return
	end

	local sContent = string.format(LocalStrings.CHARM_LIFT20, self.m_fashionRecommendCost[2], GDatatab_item["id_" .. self.m_fashionRecommendCost[1]].icon, self.m_nFashionRecommendConfigTime/3600)
	MsgBoxManager:showConfirmBox(sContent, self, self.sureToRecommend)
end

--@brief 	确定推荐
function WndCharmSpace:sureToRecommend()
	--body
	if not JudgeMoneyIsEnough(self.m_fashionRecommendCost[1], self.m_fashionRecommendCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiamondToRecommend) then
		return 
	end
	self:sureUseDiamondToRecommend()
end

function WndCharmSpace:sureUseDiamondToRecommend()
	ProtocolProcessorWndSpace:send_SPACE_Operation(2)
end

--@brief 	点赞
function WndCharmSpace:onGiveGoodCallBack(tCell, tData)
	-- body
	WZLog("WndCharmSpace:onGiveGoodCallBack")
	if self.m_tCellSelRecommendPlayer then 
		WZLog("self.m_tCellSelRecommendPlayer", self.m_tCellSelRecommendPlayer:getPlayerId(), tData.id)
		if self.m_tCellSelRecommendPlayer:getPlayerId() ~= tData.id then 
			self.m_tCellSelRecommendPlayer:setBottomBtnVisible(false)
		end
	end
	self.m_tCellSelRecommendPlayer = tCell 
	tCell:_showBottomBtn()
end

--@brief 	点击点赞按钮回调
function WndCharmSpace:onClickGood(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tRankRoleInfo.id == CacheCenter:getPlayerInfo().id then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT29)
		return 
	end

	ProtocolProcessorWndSpace:send_SPACE_GiveLike(self.m_tRankRoleInfo.id)
end

--@brief 	点击查看按钮回调
function  WndCharmSpace:onClickCheck(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndCheckOther:show(self.m_tRankRoleInfo.id)
end

-------------------------------------公有方法模块End----------------------------------------
--@brief 	添加时装套装入口
function WndCharmSpace:_addDressSuit(element)
	-- body
	if CheckButtonOpen(144, false) then
		local conForDressSuit = GetElement(element, "conForDressSuit_WndCharmSpace", WZUIContainer)
		if conForDressSuit then
			conForDressSuit:removeAllChildrenWithCleanup(true)
			self.m_tCellDressSuit = nil 
			if self.m_tMyFashionData.applyState == 0 then 
				local wndDress, tCell = WndDressSuit:createElement()
				if wndDress and tCell then
					tCell:setType(5)
					self.m_tCellDressSuit = tCell
					conForDressSuit:addChild(wndDress)
				end
			end
		end
	end
end

--@brief 	显示报名界面
function WndCharmSpace:_showMyFashionInfo()
	-- body
	self:_setFashionContentVisible(false, false, false, false, true, false)

	local conSignupRole = GetElement(self.m_root, "conSignupRole_WndCharmSpace", WZUIContainer)
	conSignupRole:removeAllChildrenWithCleanup(true)

	self.m_tMyRole = {} 
	local element, tNewObj = CellDressGoodSeat:createElement2()
	if element and tNewObj then 
		tNewObj:setData2(self.m_tMyFashionData, 0)
		conSignupRole:addChild(element)

		self.m_tMyRole = {element, tNewObj}
	end
	self:_addDressSuit(self.m_root)
	self:_showLeftRecommendTime()
	if self.m_tMyFashionData.recommendTime > 0 then 
		GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):enableSchedule("_setTimeCaculate", 1)
	end
end

--@brief 	设置各界面内容的显示与否
function WndCharmSpace:_setFashionContentVisible(bVisible1, bVisible2, bVisible3, bVisible4, bVisible5, bVisible6)
	-- body
	--报名
	GetElement(self.m_root, "conSignup_WndCharmSpace", WZUIContainer):setVisible(bVisible5)
	GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):setVisible(bVisible5)

	GetElement(self.m_root, "conHistoryFirst_WndCharmSpace", WZUIContainer):setVisible(bVisible6)
	GetElement(self.m_root, "conFashionRecommend_WndCharmSpace", WZUIContainer):setVisible(bVisible1)
	GetElement(self.m_root, "conRecommend1_WndCharmSpace", WZUIContainer):setVisible(bVisible1)
	GetElement(self.m_root, "conFlower_WndCharmSpace", WZUIContainer):setVisible(bVisible2 or bVisible3)
	GetElement(self.m_root, "conReward_WndCharmSpace", WZUIContainer):setVisible(bVisible4 or bVisible6)
	GetElement(self.m_root, "conRank_WndCharmSpace", WZUIContainer):setVisible(bVisible2 or bVisible3)
	GetElement(self.m_root, "conRecommend_WndCharmSpace", WZUIContainer):setVisible(bVisible4)
	GetElement(self.m_root, "conButton_WndCharmSpace", WZUIContainer):setVisible(bVisible2)
	GetElement(self.m_root, "btnBigCheck_WndCharmSpace", WZUIContainer):setVisible(bVisible3)

	self:_showFashionTopTab()
end

--@brief 	显示剩余推荐时间
function WndCharmSpace:_showLeftRecommendTime()
	-- body
	if self.m_tMyFashionData.recommendTime > 0 then 
		local sTime = returnToTimeFormat(self.m_tMyFashionData.recommendTime)
		GetElement(self.m_root, "txtRecommendTime_WndCharmSpace", WZUILabelTTF):setText(sTime)

		GetElement(self.m_root, "txtWordRecommend_WndCharmSpace", WZUILabelTTF):setVisible(true)
	else
		GetElement(self.m_root, "txtWordRecommend_WndCharmSpace", WZUILabelTTF):setVisible(false)
	end
end

--@brief 	显示时间倒计时
function WndCharmSpace:_setTimeCaculate()
	-- body
	if self.m_tMyFashionData.recommendTime > 0 then 
		self.m_tMyFashionData.recommendTime = self.m_tMyFashionData.recommendTime - 1
		local sTime = returnToTimeFormat(self.m_tMyFashionData.recommendTime)
		GetElement(self.m_root, "txtRecommendTime_WndCharmSpace", WZUILabelTTF):setText(sTime)
	else
		self.m_tMyFashionData.recommendState = 0
		if self.m_tMyRole[2] then 
			self.m_tMyRole[2]:_setRecommendIconVisible(self.m_tMyFashionData.recommendState)
		end
		GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):disableSchedule()
		GetElement(self.m_root, "txtWordRecommend_WndCharmSpace", WZUILabelTTF):setVisible(false)
	end
end

--@brief 	显示时装推荐列表
function WndCharmSpace:_showFashionRecommendList()
	-- body
	self:_setFashionContentVisible(true, false, false, false, false, false)
	local tbRecommend = GetElement(self.m_root, "tbRecommend_WndCharmSpace", WZUITableContainer)
	tbRecommend:cleanTable()
	self.m_tCellSelRecommendPlayer = nil 
	self.m_tCellRecommendList = {}
	--显示剩余点赞数
	self:_showLeftGoodNum()

	local conFashionRecommend = GetElement(self.m_root, "conFashionRecommend_WndCharmSpace", WZUIContainer)
	if self.m_tFashionRecommendData == nil or #self.m_tFashionRecommendData == 0 then 
		ShowPanelNullTip(conFashionRecommend, LocalStrings.CHARM_LIFT31)
		return 
	end
	removeShowPanelNullTip(conFashionRecommend)

	for i = 1, #self.m_tFashionRecommendData do
		local element, tNewObj = CellDressGoodSeat:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tFashionRecommendData[i], 1)

			tbRecommend:setCellElement(element)
			table.insert(self.m_tCellRecommendList, tNewObj)
		end
	end
end

--@brief 	取消所有的推荐玩家的选中状态
function WndCharmSpace:_cancelFashionRecommendSel(pt)
	-- body
	if self.m_tCellRecommendList == nil or #self.m_tCellRecommendList == 0 then return end 

	for i = 1, #self.m_tCellRecommendList do
		if self.m_tCellRecommendList[i]:getBottomBtnVisible() then 
			if not self.m_tCellRecommendList[i]:checkPointInBtn(pt) then 
				self.m_tCellRecommendList[i]:setBottomBtnVisible(false)
			end
		end
	end
end

--@brief 	显示时装历届冠军列表
function WndCharmSpace:_showFashionPeriodList()
	-- body
	self:_setFashionContentVisible(false, false, false, false, false, true)
	local tabHistoryFirst = GetElement(self.m_root, "tabHistoryFirst_WndCharmSpace", WZUITableContainer)
	tabHistoryFirst:cleanTable()

	local conHistoryFirst = GetElement(self.m_root, "conHistoryFirst_WndCharmSpace", WZUIContainer)
	if self.m_tFashionPeriodData == nil or #self.m_tFashionPeriodData == 0 then 
		ShowPanelNullTip( conHistoryFirst, LocalStrings.CHARM_LIFT21)
		return 
	end
	removeShowPanelNullTip(conHistoryFirst)
	
	for i = 1, #self.m_tFashionPeriodData do
		local element, tNewObj = CellDressGoodSeat:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tFashionPeriodData[i], 2)

			tabHistoryFirst:setCellElement(element)
		end
	end
	
end

--@brief 	更新玩家的点赞数
function WndCharmSpace:_updatePlayerGoodNum(playerId)
	-- body
	WZLog("WndCharmSpace:_updatePlayerGoodNum", playerId)
	if self.m_tCellRecommendList then 
		for i = 1, #self.m_tCellRecommendList do
			local id = self.m_tCellRecommendList[i]:getPlayerId()
			if id == playerId then 
				self.m_tCellRecommendList[i]:updateGoodNum()
				break 
			end
		end
	end
end

--@brief 	显示标签
function WndCharmSpace:_showFashionTopTab()
	-- body
	for i = 1, 6 do
		GetElement(self.m_root, "conLife" .. i .. "_WndCharmSpace", WZUIContainer):setVisible(i == self.tag)
	end
end
-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	显示剩余点赞次数
function WndCharmSpace:_showLeftGoodNum()
	-- body
	GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(true)
	local txtGoodNum = GetElement(self.m_root, "txtGoodNum_WndCharmSpace", WZUILabelTTF)
	if txtGoodNum then 
		txtGoodNum:setText(self.m_nLeftOperateTimes .. "/" .. CacheCenter:getGameParam().glamourfashionUp)
	end
end

--@brief 	根据类型，显示或隐藏一些内容
function WndCharmSpace:_setContentByType()
	-- body
	WZLog("WndCharmSpace:_setContentByType", self.m_nInterfaceType)
	if self.m_nInterfaceType == 0 then 
		GetElement(self.m_root, "conSignup_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionRecommend_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conHistoryFirst_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conForCharmSpace_WndCharmSpace", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conForCharmLife_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(false)
		GetElement(self.m_root, "txt6Reward_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_SEND_REWRAD")
		GetElement(self.m_root,"txtFlower1_WndCharmSpace",WZUILabelTTF):setTextKey("CHARM_FLOWER_NUM")
	elseif self.m_nInterfaceType == 1 then 
		GetElement(self.m_root, "conForCharmSpace_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(true)
		GetElement(self.m_root, "conForCharmLife_WndCharmSpace", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txt6Reward_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_LIFT23")
		GetElement(self.m_root,"txtFlower1_WndCharmSpace",WZUILabelTTF):setTextKey("CHARM_LIFT26")
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function WndCharmSpace:_adaptLanguage_en(  )
	for i=1,4 do
		local txt = GetElement(self.m_root,"txtCheck"..i.."_WndCharmSpace",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(110,0))
		txt:setFontSize(12)
	end

	for i=1,4 do
		local txt = GetElement(self.m_root,"txtCheckSel"..i.."_WndCharmSpace",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(110,0))
		txt:setFontSize(12)
	end
	GetElement(self.m_root,"txt2_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt3_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	
	GetElement(self.m_root,"conReward1_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.48))
	GetElement(self.m_root,"txtMale_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtMaleSel_WndCharmSpace",WZUILabelTTF):setFontSize(18)

	--GetElement(self.m_root,"txtGirl_WndCharmSpace",WZUILabelTTF):setScale(0.8)
	--GetElement(self.m_root,"txtGirlSel_WndCharmSpace",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRecFem_WndCharmSpace",WZUILabelTTF):setScale(0.55)
	GetElement(self.m_root,"txtRecFemSel_WndCharmSpace",WZUILabelTTF):setScale(0.55)

	GetElement(self.m_root,"imgArrow1_WndCharmSpace",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.36,0.409091))
	GetElement(self.m_root,"imgArrow2_WndCharmSpace",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.64,0.409091))
end

function WndCharmSpace:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtCheck2_WndCharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCheckSel2_WndCharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCheck3_WndCharmSpace",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheckSel3_WndCharmSpace",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheck4_WndCharmSpace",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheckSel4_WndCharmSpace",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtAll_WndCharmSpace",WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root,"txtAllSel_WndCharmSpace",WZUILabelTTF):setFontSize(14)
end

function WndCharmSpace:_adaptLanguage_vn(  )
	for i=1,4 do
		local txt = GetElement(self.m_root,"txtCheck"..i.."_WndCharmSpace",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(100,0))
		txt:setFontSize(16)
	end

	for i=1,4 do
		local txt = GetElement(self.m_root,"txtCheckSel"..i.."_WndCharmSpace",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(110,0))
		txt:setFontSize(16)
	end
	GetElement(self.m_root,"txtAll_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtAllSel_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"conReward1_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.48))
	GetElement(self.m_root,"txtCommunity_WndCharmSpace",WZUILabelTTF):setFontSize(15)
	GetElement(self.m_root,"txtSpace_WndCharmSpace",WZUILabelTTF):setFontSize(15)
	GetElement(self.m_root,"edit_WndCharmSpace",WZUIEditBox):setRelativeSize(GlobalMethod:CCSize(0.8,1))
	GetElement(self.m_root,"txtPartner_WndCharmSpace",WZUILabelTTF):setFontSize(16)
end

function WndCharmSpace:_adaptLanguage_pt(  )
	for i=1,4 do
		local txt = GetElement(self.m_root,"txtCheck"..i.."_WndCharmSpace",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(100,0))
		txt:setScale(0.8)
	end
	for i=1,4 do
		local txt = GetElement(self.m_root,"txtCheckSel"..i.."_WndCharmSpace",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(100,0))
		txt:setScale(0.8)
	end

	GetElement(self.m_root,"txtAll_WndCharmSpace",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtAllSel_WndCharmSpace",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtMale_WndCharmSpace",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtMaleSel_WndCharmSpace",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtRecFem_WndCharmSpace",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtRecFemSel_WndCharmSpace",WZUILabelTTF):setScale(0.6)
	
	GetElement(self.m_root,"conFlower3_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.83,0.5))

	local conReward1 = GetElement(self.m_root,"conReward1_WndCharmSpace",WZUIContainer)
	conReward1:setRelativePosition(GlobalMethod:ccp(0.25,0.48))
	conReward1:setScale(0.78)
	local txt1 = GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF)
	txt1:setDimensions(GlobalMethod:CCSize(400,0))
	txt1:setFontSize(18)
	GetElement(self.m_root,"txt2_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt3_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"conFlower6_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.13,0.5))
	GetElement(self.m_root,"conFlower1_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.13,0.5))
	local txt6 = GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF)
	txt6:setFontSize(18)
	txt6:setDimensions(GlobalMethod:CCSize(300,0))
	GetElement(self.m_root,"txt5_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt4_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtInformation1_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtInformation2_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	-- GetElement(self.m_root,"txtGirl_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	-- GetElement(self.m_root,"txtGirlSel_WndCharmSpace",WZUILabelTTF):setFontSize(16)

	GetElement(self.m_root,"txtRank_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtPlayer1_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtID1_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtServer1_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtFlower1_WndCharmSpace",WZUILabelTTF):setFontSize(16)


	GetElement(self.m_root,"imgWeek_WndCharmSpace",WZUI9Image):setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	GetElement(self.m_root,"imgTotal_WndCharmSpace",WZUI9Image):setRelativePosition(GlobalMethod:ccp(0.35,0.5))

	local edit = GetElement(self.m_root,"edit_WndCharmSpace",WZUIEditBox)
	edit:setRelativeSize(GlobalMethod:CCSize(0.7,1))
	edit:setRelativePosition(GlobalMethod:ccp(0.423,0.5))
end

function WndCharmSpace:_adaptLanguage_es(  )
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndCharmSpace",WZUILabelTTF)
	txtCheck1:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheck1:setFontSize(16)
	local txtCheckSel1 = GetElement(self.m_root,"txtCheckSel1_WndCharmSpace",WZUILabelTTF)
	txtCheckSel1:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckSel1:setFontSize(16)
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndCharmSpace",WZUILabelTTF)
	txtCheck2:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheck2:setFontSize(11)
	local txtCheckSel2 = GetElement(self.m_root,"txtCheckSel2_WndCharmSpace",WZUILabelTTF)
	txtCheckSel2:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckSel2:setFontSize(11)
	local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndCharmSpace",WZUILabelTTF)
	txtCheck3:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheck3:setFontSize(16)
	local txtCheckSel3 = GetElement(self.m_root,"txtCheckSel3_WndCharmSpace",WZUILabelTTF)
	txtCheckSel3:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckSel3:setFontSize(16)
	local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndCharmSpace",WZUILabelTTF)
	txtCheck4:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheck4:setFontSize(16)
	local txtCheckSel4 = GetElement(self.m_root,"txtCheckSel4_WndCharmSpace",WZUILabelTTF)
	txtCheckSel4:setDimensions(GlobalMethod:CCSize(100,0))
	txtCheckSel4:setFontSize(16)
	local edit = GetElement(self.m_root,"edit_WndCharmSpace",WZUIEditBox)
	edit:setRelativeSize(GlobalMethod:CCSize(0.7,1))
	edit:setRelativePosition(GlobalMethod:ccp(0.423,0.5))
	GetElement(self.m_root,"txtAll_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtAllSel_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	local conReward1 = GetElement(self.m_root,"conReward1_WndCharmSpace",WZUIContainer)
	conReward1:setRelativePosition(GlobalMethod:ccp(0.25,0.48))

	local txt1 = GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF)
	txt1:setDimensions(GlobalMethod:CCSize(400,0))
	txt1:setFontSize(18)

	GetElement(self.m_root,"txt2_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt3_WndCharmSpace",WZUILabelTTF):setFontSize(18)

	local txt6 = GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF)
	txt6:setFontSize(18)
	txt6:setDimensions(GlobalMethod:CCSize(300,0))

	GetElement(self.m_root,"txt5_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt4_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtInformation1_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtInformation2_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	
	GetElement(self.m_root,"conFlower6_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.12,0.5))
	GetElement(self.m_root,"conFlower1_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.12,0.5))
	GetElement(self.m_root,"conFlower2_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.62,0.5))
	GetElement(self.m_root,"conFlower3_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.91,0.5))
end

function WndCharmSpace:_adaptLanguage_tr(  )
	for i=1,4 do
		local txt = GetElement(self.m_root,"txtCheck"..i.."_WndCharmSpace",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(110,0))
		txt:setFontSize(12)
	end

	for i=1,4 do
		local txt = GetElement(self.m_root,"txtCheckSel"..i.."_WndCharmSpace",WZUILabelTTF)
		txt:setDimensions(GlobalMethod:CCSize(110,0))
		txt:setFontSize(12)
	end
	GetElement(self.m_root,"txtRecFem_WndCharmSpace",WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root,"txtRecFemSel_WndCharmSpace",WZUILabelTTF):setFontSize(14)
	local conReward1 = GetElement(self.m_root,"conReward1_WndCharmSpace",WZUIContainer)
	conReward1:setRelativePosition(GlobalMethod:ccp(0.25,0.48))
	conReward1:setScale(0.78)
	GetElement(self.m_root,"txtAll_WndCharmSpace",WZUILabelTTF):setFontSize(12)
	GetElement(self.m_root,"txtAllSel_WndCharmSpace",WZUILabelTTF):setFontSize(12)
	local txt1 = GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF)
	txt1:setDimensions(GlobalMethod:CCSize(400,0))
	txt1:setFontSize(18)
	GetElement(self.m_root,"txt2_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt3_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"conFlower6_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.13,0.5))
	GetElement(self.m_root,"conFlower1_WndCharmSpace",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.13,0.5))
	local txt6 = GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF)
	txt6:setFontSize(18)
	txt6:setDimensions(GlobalMethod:CCSize(300,0))
	GetElement(self.m_root,"txt5_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txt4_WndCharmSpace",WZUILabelTTF):setFontSize(18)
	--GetElement(self.m_root,"txtInformation_WndCharmSpace",WZUILabelTTF):setFontSize(17)
	GetElement(self.m_root,"txtMale_WndCharmSpace",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtMaleSel_WndCharmSpace",WZUILabelTTF):setFontSize(16)

	local edit = GetElement(self.m_root,"edit_WndCharmSpace",WZUIEditBox)
	if edit  then
		edit:setRelativeSize(GlobalMethod:CCSize(0.88,1))
		edit:setRelativePosition(GlobalMethod:ccp(0.43,0.5))
	end
end
-------------------------------------语言适配End------------------------------------------