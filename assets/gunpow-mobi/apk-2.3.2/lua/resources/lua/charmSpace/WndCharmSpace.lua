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

	GetElement(self.m_root, "checkGroupBoxLeft_WndCharmSpace", WZUICheckBoxGroup):setCheckIndex(self.m_nInterfaceType)
	GetElement(self.m_root,"con_WndCharmSpace",WZUIContainer):enableSchedule("downloadFile",0.01)
	self:_setContentByType()

	self:showTitleList(self.m_nInterfaceType+1,self.tag)

	self:_addTop()
	local tConfigCost = CacheCenter:getGameParam().glamourfashionConsume
	local string = string.sub(tConfigCost,2,-2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]
	self.m_fashionRecommendCost = {tonumber(id), tonumber(num)}
	self.m_nFashionRecommendConfigTime = tonumber(CacheCenter:getGameParam().glamourfashionRecommendtinme)
	if self.m_nInterfaceType == 0 then 
		ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2)
	elseif self.m_nInterfaceType == 1 then 
		ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo(1)
	elseif self.m_nInterfaceType == 2 then 
		ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2, 1)
	elseif self.m_nInterfaceType == 4 then
		ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo(2)
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

function WndCharmSpace:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_mlrs.png",WndCharmSpace,WndCharmSpace.onClose,true,false,false,"WndCharmSpace")
end

--@brief 	显示标题标签
--@param 	title1Tag : 选中大标签的tag
--@param 	title2Tag : 选中小标签的tag
function WndCharmSpace:showTitleList(title1Tag,title2Tag)
	WZLog("WndCharmSpace:showTitleList ",title1Tag,title2Tag)
	local tTitleBtn = {}
	--大标题
	if CheckButtonShow(217) then
		tTitleBtn.tabMainTitleStr = {LocalStrings.CHARM_LIFT4,LocalStrings.UGLY_SHOW,LocalStrings.CHARM_SPACE,LocalStrings.CHARMSPACE_TEXT1,LocalStrings.CHARM_LIFT33}
		tTitleBtn.tabMainTitleTag = {2,5,1,3,4}
		--小标题
		-- tTitleBtn.tabSubTitleStr = {{LocalStrings.CHARM_LIFT1,LocalStrings.CHARM_RANK_RELOAD,LocalStrings.CHARM_LIFT2,LocalStrings.CHARM_LIFT3,LocalStrings.RANK_REWARD,LocalStrings.CHARM_LIFT14},
		-- 					{LocalStrings.CHARM_RANK_RELOAD,LocalStrings.CHARM_RECOMMEND,LocalStrings.CHARM_TOTAL_RANK,LocalStrings.CHARM_RANK_RELOAD,LocalStrings.CHARM_LIFT14},
		-- 					{LocalStrings.CHARM_RANK_RELOAD,LocalStrings.CHARMSPACE_TEXT2,LocalStrings.CHARMSPACE_TEXT3,LocalStrings.RANK_REWARD,LocalStrings.CHARM_LIFT14},
		-- 					{LocalStrings.CHARM_LIFT14}}
		-- tTitleBtn.tabSubTitleTag = {{5,1,2,3,4,6},{1,2,3,4,5},{1,2,3,4,5},{1}}
		tTitleBtn.tabSubTitleStr = {{LocalStrings.COMMUNITY_COMPETE_TEXT7,LocalStrings.SHOP_RECOMMEND,LocalStrings.RANK,LocalStrings.ATH_REWARD_CHECK},
							{LocalStrings.COMMUNITY_COMPETE_TEXT7,LocalStrings.SHOP_RECOMMEND,LocalStrings.RANK,LocalStrings.ATH_REWARD_CHECK},
							{LocalStrings.SHOP_RECOMMEND,LocalStrings.RANK,LocalStrings.ATH_REWARD_CHECK},
							{LocalStrings.SHOP_RECOMMEND,LocalStrings.RANK,LocalStrings.ATH_REWARD_CHECK},
							{LocalStrings.RANK}}
		tTitleBtn.tabSubTitleTag = {{5,1,6,4},{5,1,6,4},{1,5,4},{1,5,4},{1}}
	else 
		tTitleBtn.tabMainTitleStr = {LocalStrings.CHARM_LIFT4,LocalStrings.CHARM_SPACE,LocalStrings.CHARMSPACE_TEXT1,LocalStrings.CHARM_LIFT33}
		tTitleBtn.tabMainTitleTag = {2,1,3,4}
		--小标题
		-- tTitleBtn.tabSubTitleStr = {{LocalStrings.CHARM_LIFT1,LocalStrings.CHARM_RANK_RELOAD,LocalStrings.CHARM_LIFT2,LocalStrings.CHARM_LIFT3,LocalStrings.RANK_REWARD,LocalStrings.CHARM_LIFT14},
		-- 					{LocalStrings.CHARM_RANK_RELOAD,LocalStrings.CHARM_RECOMMEND,LocalStrings.CHARM_TOTAL_RANK,LocalStrings.CHARM_RANK_RELOAD,LocalStrings.CHARM_LIFT14},
		-- 					{LocalStrings.CHARM_RANK_RELOAD,LocalStrings.CHARMSPACE_TEXT2,LocalStrings.CHARMSPACE_TEXT3,LocalStrings.RANK_REWARD,LocalStrings.CHARM_LIFT14},
		-- 					{LocalStrings.CHARM_LIFT14}}
		-- tTitleBtn.tabSubTitleTag = {{5,1,2,3,4,6},{1,2,3,4,5},{1,2,3,4,5},{1}}
		tTitleBtn.tabSubTitleStr = {{LocalStrings.COMMUNITY_COMPETE_TEXT7,LocalStrings.SHOP_RECOMMEND,LocalStrings.RANK,LocalStrings.ATH_REWARD_CHECK},
							{LocalStrings.SHOP_RECOMMEND,LocalStrings.RANK,LocalStrings.ATH_REWARD_CHECK},
							{LocalStrings.SHOP_RECOMMEND,LocalStrings.RANK,LocalStrings.ATH_REWARD_CHECK},
							{LocalStrings.RANK}}
		tTitleBtn.tabSubTitleTag = {{5,1,6,4},{1,5,4},{1,5,4},{1}}
	end

	--"周榜"和"总榜"整合到"历届"界面里
	if title1Tag == 3 then --2魅力时装
		if title2Tag == 2 or title2Tag == 3 then --2周榜,3总榜
			title2Tag = 5 --6历届
		end
	elseif title1Tag == 1 then --1魅力空间
		if title2Tag == 2 or title2Tag == 3 then --2周榜,3总榜
			title2Tag = 5 --5历届
		end
	elseif title1Tag == 4 then --3魅力人气
		if title2Tag == 2 or title2Tag == 3 then --2周榜,3总榜
			title2Tag = 5 --5历届
		end
	elseif title1Tag == 5 then --2丑人秀
		if title2Tag == 2 or title2Tag == 3 then --2周榜,3总榜
			title2Tag = 6 --6历届
		end
	elseif title1Tag == 2 then 
		if title2Tag == 2 or title2Tag == 3 then --2周榜,3总榜
			title2Tag = 6 --6历届
		end
	end

	local title1Index = 1
	for i=1,#tTitleBtn.tabMainTitleTag do
		if title1Tag and title1Tag == tTitleBtn.tabMainTitleTag[i] then
			title1Index = i
		end
	end
	local title2Index = 1
	for j=1,#tTitleBtn.tabSubTitleTag[title1Index] do
		if title2Tag and title2Tag == tTitleBtn.tabSubTitleTag[title1Index][j] then
			title2Index = j
		end
	end
	--创建大小标题
	local flconTitleCheck = GetElement(self.m_root,"flconTitleCheck_WndCharmSpace",WZUIFreeListContainer)
	flconTitleCheck:removeAll()

	local nIndex = 0
	for i=1,#tTitleBtn.tabMainTitleStr do
		local conLevel1Title = CreateElement("conLevel1Title_WndCharmSpace")
		conLevel1Title = WZUIContainer:luaTo(conLevel1Title)
		conLevel1Title:setTag(nIndex)
		conLevel1Title:setVisible(true)
		flconTitleCheck:pushBack(conLevel1Title)
		nIndex = nIndex + 1

		local txtLevel1Title1 = GetElement(conLevel1Title,"txtLevel1Title1_WndCharmSpace",WZUILabelTTF)
		local txtLevel1Title2 = GetElement(conLevel1Title,"txtLevel1Title2_WndCharmSpace",WZUILabelTTF)
		local txtLevel1Title3 = GetElement(conLevel1Title,"txtLevel1Title3_WndCharmSpace",WZUILabelTTF)
		txtLevel1Title1:setText(tTitleBtn.tabMainTitleStr[i])
		txtLevel1Title2:setText(tTitleBtn.tabMainTitleStr[i])
		txtLevel1Title3:setText(tTitleBtn.tabMainTitleStr[i])

		local btnLevel1Title = GetElement(conLevel1Title,"btnLevel1Title_WndCharmSpace",WZUIButton)
		btnLevel1Title:setTag(tTitleBtn.tabMainTitleTag[i])
		btnLevel1Title:setLuaDoneFunctionName("onClickLeftBox")
		if i == title1Index then
			btnLevel1Title:setTouchEnable(false)

			for j=1,#tTitleBtn.tabSubTitleStr[i] do
				local conLevel2Title = CreateElement("conLevel2Title_WndCharmSpace")
				conLevel2Title = WZUIContainer:luaTo(conLevel2Title)
				conLevel2Title:setTag(nIndex)
				conLevel2Title:setVisible(true)
				flconTitleCheck:pushBack(conLevel2Title)
				nIndex = nIndex + 1

				local txtLevel2Title1 = GetElement(conLevel2Title,"txtLevel2Title1_WndCharmSpace",WZUILabelTTF)
				local txtLevel2Title2 = GetElement(conLevel2Title,"txtLevel2Title2_WndCharmSpace",WZUILabelTTF)
				local txtLevel2Title3 = GetElement(conLevel2Title,"txtLevel2Title3_WndCharmSpace",WZUILabelTTF)
				txtLevel2Title1:setText(tTitleBtn.tabSubTitleStr[i][j])
				txtLevel2Title2:setText(tTitleBtn.tabSubTitleStr[i][j])
				txtLevel2Title3:setText(tTitleBtn.tabSubTitleStr[i][j])

				local btnLevel2Title = GetElement(conLevel2Title,"btnLevel2Title_WndCharmSpace",WZUIButton)
				btnLevel2Title:setTag(tTitleBtn.tabSubTitleTag[i][j])
				btnLevel2Title:setLuaDoneFunctionName("onCheckBox")
				if j == title2Index then
					btnLevel2Title:setTouchEnable(false)
				else
					btnLevel2Title:setTouchEnable(true)
				end

			end
		else
			btnLevel1Title:setTouchEnable(true)
		end
	end

	flconTitleCheck:getMoveElement():setPositionY(flconTitleCheck:getMinPosition().y)
end

--@brief 	点击切换类型
function WndCharmSpace:onClickLeftBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("点击切换类型",self.m_nInterfaceType,element:getTag())
	--推荐消耗
	if self.m_nInterfaceType == 1 then
		local tConfigCost = CacheCenter:getGameParam().glamourfashionConsume
		local string = string.sub(tConfigCost,2,-2) 
		local id = SplitStringWithSeparator(string,",")[1]
		local num = SplitStringWithSeparator(string,",")[2]
		self.m_fashionRecommendCost = {tonumber(id), tonumber(num)}
		self.m_nFashionRecommendConfigTime = tonumber(CacheCenter:getGameParam().glamourfashionRecommendtinme)
	elseif self.m_nInterfaceType == 4 then
		local tConfigCost = CacheCenter:getGameParam().uglyShowConsume
		local string = string.sub(tConfigCost,2,-2) 
		local id = SplitStringWithSeparator(string,",")[1]
		local num = SplitStringWithSeparator(string,",")[2]
		self.m_fashionRecommendCost = {tonumber(id), tonumber(num)}
		self.m_nFashionRecommendConfigTime = tonumber(CacheCenter:getGameParam().uglyShowRecommendtinme)
	end

	local nTag = element:getTag()
	if nTag == 5 then
		if not CheckButtonOpen(217) then
			return
		end
	end
	-- WZLog("点击切换类型",self.tag)
	if self.m_nInterfaceType == nTag - 1 then return end 
	if self.m_nInterfaceType == 0 then 
		self.m_nSpaceTag = self.tag 
	elseif self.m_nInterfaceType == 1 then 
		self.m_nFashionTag = self.tag 
	elseif self.m_nInterfaceType == 2 then 
		self.m_nFootTag = self.tag
	elseif self.m_nInterfaceType == 3 then 
		self.m_nKingTag = self.tag
	end

	if nTag == 5 then
		self.m_nUglyTag = nTag
	end
	self.m_nInterfaceType = nTag - 1

	self:_setContentByType()
	WZLog("WndCharmSpace:onClickLeftBox", self.m_nInterfaceType, self.m_nUglyTag)
	if self.m_nInterfaceType == 0 then 
		self:exchangeTopTab(self.m_nSpaceTag)
	elseif self.m_nInterfaceType == 1 then 
		self:exchangeTopTab(self.m_nFashionTag)
	elseif self.m_nInterfaceType == 2 then 
		self:exchangeTopTab(self.m_nFootTag)
	elseif self.m_nInterfaceType == 3 then 
		self:exchangeTopTab(self.m_nKingTag)
	elseif self.m_nInterfaceType == 4 then
		self:exchangeTopTab(self.m_nUglyTag)
	end
end

--@brief	标签的点击事件
function WndCharmSpace:onCheckBox( element )
	WZLog("点击大标签",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()

	if self.tag == tag then return end 

	self:exchangeTopTab(tag)
end

--@brief	切换顶部标签
function WndCharmSpace:exchangeTopTab(tag)
	-- body
	self.tag = tag
	WZLog("切换顶部标签",self.m_nInterfaceType,tag,self.currentTag)
	local nBtnTag = 1
	if self.m_nInterfaceType == 0 then
		if self.tag == 2 then
			nBtnTag = 2
		elseif self.tag == 3 then
			nBtnTag = 3
		elseif self.tag == 5 then
			nBtnTag = 1
		end
	elseif self.m_nInterfaceType == 1 then
		if self.tag == 2 then
			nBtnTag = 2
		elseif self.tag == 3 then
			nBtnTag = 3
		elseif self.tag == 6 then
			nBtnTag = 1
		end
	elseif self.m_nInterfaceType == 2 then
		if self.tag == 2 then
			nBtnTag = 2
		elseif self.tag == 3 then
			nBtnTag = 3
		elseif self.tag == 5 then
			nBtnTag = 1
		end
	elseif self.m_nInterfaceType == 4 then
		if self.tag == 2 then
			nBtnTag = 2
		elseif self.tag == 3 then
			nBtnTag = 3
		elseif self.tag == 5 then
			nBtnTag = 1
		end
	end
	if self.m_nInterfaceType == 4 then 
		for i = 1,5 do
			local common_bg = GetElement(self.m_root,"common_bg"..i.."_WndCharmSpace",WZUI9Image)
			common_bg:setFile("ui/common_bg/common_bg_10.png")
		end
	else 
		for i = 1,5 do
			local common_bg = GetElement(self.m_root,"common_bg"..i.."_WndCharmSpace",WZUI9Image)
			common_bg:setFile("ui/common_bg/common_bg_08.png")
		end
	end
	self:_updateSwitch(nBtnTag)
	-- if self.m_nInterfaceType ~= 4 then
		self:showTitleList(self.m_nInterfaceType+1,self.tag)
	-- else 
	-- 	self:showTitleList(self.m_nInterfaceType-3,self.tag)
	-- end
	-- WZLog("WndCharmSpace:exchangeTopTab", type(self.preTag), self.preTag, self.currentTag)
	if self.m_nInterfaceType == 0 then 
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
		elseif tag == 5 then
			ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList(2)
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
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,2)
				elseif self.currentTag == 2 then
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,0)
				elseif self.currentTag == 3 then
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,1)
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
			ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo(1)
		elseif tag == 6 then 	--历届冠军
			ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList(1)
		end
	elseif self.m_nInterfaceType == 2 then 
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
					ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2, 1)
				elseif self.currentTag == 2 then
					ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(0, 1)
				elseif self.currentTag == 3 then
					ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(1, 1)
				end
			elseif tag == 2 then
				ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(50) --踩一踩周榜的总排行榜
				ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(50) --踩一踩周榜的个人排行榜
			elseif tag == 3 then
				ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(51) --踩一踩总榜的总排行榜
				ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(51) --踩一踩总榜的个人排行榜
			end
		elseif tag == 5 then
			ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList(3)
		end
	elseif self.m_nInterfaceType == 3 then 
		if tag == 1 then
			ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList(4)
			self:setCharmKingReward()
		end
	elseif self.m_nInterfaceType == 4 then
		-- WZLog("__________________________",tag)
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
				-- if 
				if self.currentTag == 1 then
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,2)
				elseif self.currentTag == 2 then
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,0)
				elseif self.currentTag == 3 then
					ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,1)
				end
			elseif tag == 2 then
				self.m_nWeekListPositionY = nil 
				self.m_nBeGoodPlayerId = nil 

				ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(57) --点赞周榜的总排行榜
				ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(57) --点赞周榜的个人排行榜
			elseif tag == 3 then
				ProtocolProcessorWndCharmRank:send_RANK_GetRankRecord(58) --点赞总榜的总排行榜
				ProtocolProcessorWndCharmRank:send_RANK_GetPlayerRank(58) --点赞总榜的个人排行榜
			end
		elseif tag == 5 then 	--报名
			ProtocolProcessorWndSpace:send_SPACE_GetCharmFashionInfo(2)
		elseif tag == 6 then 	--历届冠军
			ProtocolProcessorWndSpace:send_SPACE_GetFashionPreviousList(5)
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
-- WZLog("点击奖励是否进来2",self.m_nInterfaceType)
	tab3:cleanTable()
	tab1:cleanTable()
	tab2:cleanTable()

	if self.m_nInterfaceType == 0 then 
		self:_showSpaceTopTab()
	elseif self.m_nInterfaceType == 1 or self.m_nInterfaceType == 4 then 
		self:_showFashionTopTab()
	elseif self.m_nInterfaceType == 2 then 
		self:_showFootTopTab()
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
		if self.m_nInterfaceType == 0 or self.m_nInterfaceType == 1 or self.m_nInterfaceType == 2 or self.m_nInterfaceType then 
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
		if self.m_nInterfaceType == 0 or self.m_nInterfaceType == 1 or self.m_nInterfaceType == 2 or self.m_nInterfaceType == 4 then 
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
			self:_setFashionContentVisible(false, false, false, true, false, false)
		elseif self.m_nInterfaceType == 1 or self.m_nInterfaceType == 4 then 
			-- WZLog("点击奖励是否进来2")
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
		elseif self.m_nInterfaceType == 2 then 
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
	-- WZLog("推荐按钮点击事件",self.m_nInterfaceType,self.currentTag)
	if self.m_nInterfaceType == 1 then 
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,2)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,0)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,1)
		end
	elseif self.m_nInterfaceType == 2 then 
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2, 1)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(0, 1)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(1, 1)
		end
	elseif self.m_nInterfaceType == 4 then 
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,2)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,0)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,1)
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
	elseif self.m_nInterfaceType == 2 then 
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(2, 1)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(0, 1)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetRecommendList(1, 1)
		end
	elseif self.m_nInterfaceType == 1 then
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,2)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,0)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(1,1)
		end
	elseif self.m_nInterfaceType == 4 then
		if self.currentTag == 1 then --不限性别推荐
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,2)
		elseif self.currentTag == 2 then --推荐男性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,0)
		elseif self.currentTag == 3 then --推荐女性玩家
			ProtocolProcessorWndSpace:send_SPACE_GetFashionRecommendList(2,1)
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


--@brief	历届,本周,历史 单选按钮点击事件
function WndCharmSpace:onSwitchCheck( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local btnTag = element:getTag()
	-- WZLog("历届，本周，历史",btnTag,self.m_nInterfaceType)
	-- if btnTag == 4 then btnTag = btnTag - 3 end
	self:_updateSwitch(btnTag)

	local tagList = {{5,2,3},{6,2,3},{5,2,3},{5,2,3},{6,2,3}}-- 原界面WZUICheckBox的tag值 {{空间历届,空间周榜,空间总榜},{时装历届,时装周榜,时装总榜},{人气历届,人气周榜,人气总榜}}
	local tag = 0
	-- if self.m_nInterfaceType ~= 4 then 
		tag = tagList[self.m_nInterfaceType+1][btnTag]
	-- else 
		-- tag = tagList[self.m_nInterfaceType-3][btnTag]
	-- end
	self:exchangeTopTab(tag)

end

--@brief	历届,本周,历史 单选按钮点亮状态
function WndCharmSpace:_updateSwitch(tag)
	for i=1,3 do
		GetElement(self.m_root,"con"..(i+17).."_WndCharmSpace",WZUIContainer):setVisible(i==tag)
	end
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
			self:_setFashionContentVisible(true, false, false, false, false, false)

			-- GetElement(self.m_root,"conRecommend_WndCharmSpace",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(false)
			local tab = GetElement(self.m_root,"tab3_WndCharmSpace",WZUITableContainer)
			for i=1,#self.playerId do
				-- WZLog("--WndCharmSpace1--")
				local celElement,tCell = CellCharmRecommend:createElement()
				if celElement and tCell then
					-- WZLog("---WndCharmSpace2---")
					celElement:setTag(i-1)
					tCell:setData(self.playerId[i],self.playerName[i],self.photoUrl[i],self.sex[i],self.cross[i],self.level[i])
					tab:setCellElement(celElement)
				end
			end
		elseif self.m_nInterfaceType == 1 then 
			self:_showFashionRecommendList()
		elseif self.m_nInterfaceType == 2 then 
			self:_setFashionContentVisible(true, false, false, false, false, false)

			-- GetElement(self.m_root,"conRecommend_WndCharmSpace",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(false)
			local tab = GetElement(self.m_root,"tab3_WndCharmSpace",WZUITableContainer)
			for i=1,#self.playerId do
				-- WZLog("--WndCharmSpace1--")
				local celElement,tCell = CellCharmRecommend:createElement()
				if celElement and tCell then
					-- WZLog("---WndCharmSpace2---")
					celElement:setTag(i-1)
					tCell:setData(self.playerId[i],self.playerName[i],self.photoUrl[i],self.sex[i],self.cross[i],self.level[i])
					tab:setCellElement(celElement)
				end
			end
		end
	elseif tag == 2 then --周鲜花榜
		GetElement(self.m_root,"conRecommend_WndCharmSpace",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(true)
		local conList = GetElement(self.m_root,"conList_WndCharmSpace",WZUIContainer) --鲜花榜单
		local conDetail = GetElement(self.m_root,"conDetail_WndCharmSpace",WZUIContainer) --人物详情
		conDetail:setVisible(false)
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
					elseif self.m_nInterfaceType == 2 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(50)
					elseif self.m_nInterfaceType == 0 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(26)
					elseif self.m_nInterfaceType == 4 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(57)
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
					elseif self.m_nInterfaceType == 2 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(50)
					elseif self.m_nInterfaceType == 0 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(26)
					elseif self.m_nInterfaceType == 4 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(57)
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
			conFashionDetail:setVisible(false)
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
		conDetail:setVisible(false)
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
					elseif self.m_nInterfaceType == 2 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(51)
					elseif self.m_nInterfaceType == 0 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(27)
					elseif self.m_nInterfaceType == 4 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(58)
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
					elseif self.m_nInterfaceType == 2 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(51)
					elseif self.m_nInterfaceType == 0 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(27)
					elseif self.m_nInterfaceType == 4 then 
						tCell:setRoleInfo(self.m_tOtherInfo[i])
						tCell:setRankType(58)
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
			conFashionDetail:setVisible(false)
			txtMessage:setText(LocalStrings.CHARM_RESULT)
		end

		tab:getMoveElement():setPositionY(tab:getMinPosition().y)

	elseif tag == 4 then --排名奖励
		WZLog("显示排名奖励",self.m_nInterfaceType)
		local conRecommend = GetElement(self.m_root, "conRecommend_WndCharmSpace", WZUIContainer)
		removeShowPanelNullTip(conRecommend)
		conRecommend:setVisible(true)
		GetElement(self.m_root,"conRank_WndCharmSpace",WZUIContainer):setVisible(false)

		--WZLog("--WndCharmSpace:_update4--")
		local m = 0
		local num = 0
		local sex = CacheCenter:getPlayerInfo().sex

		local tab = GetElement(self.m_root,"tab1_WndCharmSpace",WZUITableContainer)
		local tTableReward = GDatatab_charm_rank_reward
		if self.m_nInterfaceType == 1 then 
			tTableReward = GDatatab_glamour_fashion
		elseif self.m_nInterfaceType == 2 then 
			tTableReward = GDatatab_charm2_rank_reward
		elseif self.m_nInterfaceType == 4 then
			tTableReward = GDatatab_uglyshow_rank_raward
		end
		if tTableReward then
			for k,v in pairs(tTableReward) do
				num = num + 1
			end
		end
		if sex == 0 then --男性玩家
			for i=1,num do
				if self.m_nInterfaceType == 2 then 
					m = m + 1
					local celElement,tCell = CellCharmReward:createElement()
					if celElement and tCell then
						celElement:setTag(m-1)
						tCell:setData(tTableReward["id_"..i].rank,tTableReward["id_"..i].reward_boy,m)
						--WZLog("---reward----",Serialize(tTableReward["id_"..i].reward_boy))
						tab:setCellElement(celElement)
					end
				elseif self.m_nInterfaceType == 1 or self.m_nInterfaceType == 0 then
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
				elseif self.m_nInterfaceType == 4 then
					local currentMonth = os.date("*t", SystemTime:getServerTime()).month
					-- WZLog("服务器时间",currentMonth)
					if tTableReward["id_"..i].month == currentMonth then
						m = m+1
						local celElement,tCell = CellCharmReward:createElement()
						if celElement and tCell then
							celElement:setTag(m-1)
							tCell:setData(tTableReward["id_"..i].rank,tTableReward["id_"..i].reward_boy,m)
							tab:setCellElement(celElement)
						end
					end
				end
			end

		elseif sex == 1 then --女性玩家
			for i=1,num do
				if self.m_nInterfaceType == 2 then 
					m = m + 1
					local celElement,tCell = CellCharmReward:createElement()
					if celElement and tCell then
						celElement:setTag(m-1)
						--WZLog("---reward----",Serialize(tTableReward["id_"..i].reward_girl))
						tCell:setData(tTableReward["id_"..i].rank,tTableReward["id_"..i].reward_girl,m)
						tab:setCellElement(celElement)
					end
				elseif  self.m_nInterfaceType == 1 or self.m_nInterfaceType == 0 then
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
				elseif self.m_nInterfaceType == 4 then
					local currentMonth = os.date("*t", SystemTime:getServerTime()).month
					-- WZLog("服务器时间",currentMonth)
					if tTableReward["id_"..i].month == currentMonth then
						m = m+1
						local celElement,tCell = CellCharmReward:createElement()
						if celElement and tCell then
							celElement:setTag(m-1)
							tCell:setData(tTableReward["id_"..i].rank,tTableReward["id_"..i].reward_girl,m)
							tab:setCellElement(celElement)
						end
					end
				end
			end

		end
		tab:getMoveElement():setPositionY(tab:getMinPosition().y)
	end
end

function WndCharmSpace:_update2( tag )
	-- WZLog("WndCharmSpace:_update2( tag )",tag)
	if self.m_root == nil then return end 
	WZTempLog("tag....: ",tag, self.m_nInterfaceType)
	-- GetElement(self.m_root,"imgWeek_WndCharmSpace",WZUI9Image):setVisible(true)
	-- GetElement(self.m_root,"imgTotal_WndCharmSpace",WZUI9Image):setVisible(false)
	GetElement(self.m_root,"conWeek_WndCharmSpace",WZUIContainer):setVisible(true)
	GetElement(self.m_root,"conTotal_WndCharmSpace",WZUIContainer):setVisible(false)
	local txtRank1 = GetElement(self.m_root,"txt3_WndCharmSpace",WZUILabelTTF) --我的排名
	local txtRank2 = GetElement(self.m_root,"txt5_WndCharmSpace",WZUILabelTTF)
	local txtFlowerNum1 = GetElement(self.m_root,"txtNum1_WndCharmSpace",WZUILabelTTF) --我的周鲜花数量
	local txtFlowerNum2 = GetElement(self.m_root,"txtNum2_WndCharmSpace",WZUILabelTTF) --我的总鲜花数量
	if self.m_nInterfaceType == 1 then 
		GetElement(self.m_root, "txtWeekWord_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_LIFT27")
		GetElement(self.m_root, "txtTotalWord_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_LIFT28")
		txtFlowerNum1 = GetElement(self.m_root,"txtGoodNum1_WndCharmSpace",WZUILabelTTF) --我的周点赞数量
		txtFlowerNum2 = GetElement(self.m_root,"txtGoodNum2_WndCharmSpace",WZUILabelTTF) --我的总点赞数量
	elseif self.m_nInterfaceType == 2 then 
		GetElement(self.m_root, "txtWeekWord_WndCharmSpace", WZUILabelTTF):setTextKey("CHARMSPACE_TEXT8")
		GetElement(self.m_root, "txtTotalWord_WndCharmSpace", WZUILabelTTF):setTextKey("CHARMSPACE_TEXT9")
		txtFlowerNum1 = GetElement(self.m_root,"txtGoodNum1_WndCharmSpace",WZUILabelTTF) --我的周点赞数量
		txtFlowerNum2 = GetElement(self.m_root,"txtGoodNum2_WndCharmSpace",WZUILabelTTF) --我的总点赞数量
	elseif self.m_nInterfaceType == 4 then
		GetElement(self.m_root, "txtWeekWord_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_LIFT36")
		GetElement(self.m_root, "txtTotalWord_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_LIFT28")
		txtFlowerNum1 = GetElement(self.m_root,"txtGoodNum1_WndCharmSpace",WZUILabelTTF) --我的周点赞数量
		txtFlowerNum2 = GetElement(self.m_root,"txtGoodNum2_WndCharmSpace",WZUILabelTTF) --我的总点赞数量
	end

	--WZLog("---WndCharmSpace:getMyRankListInfo--",Serialize(CacheCenter:getMyRankListInfo()))
	local myRankList = CacheCenter:getMyRankListInfo()

	if tag == 2 then
		-- WZLog("---playerSpaceWeeklyRec---",CacheCenter:getGameParam().playerSpaceWeeklyRec)
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
		elseif self.m_nInterfaceType == 2 then 
			local sConfig = CacheCenter:getGameParam().conditional
			local string = string.sub(sConfig, 2, -2) 
			local weekMin = tonumber(SplitStringWithSeparator(string,",")[1])
			local totalMin = tonumber(SplitStringWithSeparator(string,",")[2])

			GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conFlower3_WndCharmSpace", WZUIContainer):setVisible(false)
			GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setText(string.format(LocalStrings.CHARMSPACE_TEXT6, weekMin))
			GetElement(self.m_root,"txtWeekWord_WndCharmSpace",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root,"txtTotalWord_WndCharmSpace",WZUILabelTTF):setVisible(false)
		elseif self.m_nInterfaceType == 4 then
			GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conFlower3_WndCharmSpace", WZUIContainer):setVisible(false)
			GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setText(string.format(LocalStrings.CHARM_LIFT37,CacheCenter:getGameParam().uglyShowWeeklyRec))
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
		elseif self.m_nInterfaceType == 2 then 
			rank = myRankList[50].myRank
			flowerNum = myRankList[50].rankValue
		elseif self.m_nInterfaceType == 4 then
			rank = myRankList[57].myRank or -1
			flowerNum = myRankList[57].rankValue or 0
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
		-- WZLog("---playerSpaceTotalRec---",CacheCenter:getGameParam().playerSpaceTotalRec)
		-- GetElement(self.m_root,"imgWeek_WndCharmSpace",WZUI9Image):setVisible(false)
		-- GetElement(self.m_root,"imgTotal_WndCharmSpace",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"conWeek_WndCharmSpace",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conTotal_WndCharmSpace",WZUIContainer):setVisible(true)
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
		elseif self.m_nInterfaceType == 2 then 
			local sConfig = CacheCenter:getGameParam().conditional
			local string = string.sub(sConfig, 2, -2) 
			local weekMin = tonumber(SplitStringWithSeparator(string,",")[1])
			local totalMin = tonumber(SplitStringWithSeparator(string,",")[2])
			GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF):setText(string.format(LocalStrings.CHARMSPACE_TEXT7, totalMin))
			GetElement(self.m_root,"txtWeekWord_WndCharmSpace",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"txtTotalWord_WndCharmSpace",WZUILabelTTF):setVisible(true)
			GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(true)
			GetElement(self.m_root, "conFlower3_WndCharmSpace", WZUIContainer):setVisible(false)
		elseif self.m_nInterfaceType == 4 then
			GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF):setText(string.format(LocalStrings.CHARM_LIFT25,CacheCenter:getGameParam().uglyShowTotalRec))
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
		elseif self.m_nInterfaceType == 2 then  
			rank = myRankList[51].myRank
			flowerNum = myRankList[51].rankValue
		elseif self.m_nInterfaceType == 4 then
			rank = myRankList[58].myRank or -1
			flowerNum = myRankList[58].rankValue or 0
		else
			rank = myRankList[27].myRank
			flowerNum = myRankList[27].rankValue
		end
		-- WZLog("---WndCharmSpace2:rank,flowerNum---",rank,flowerNum)
		if rank == -1 then
			txtRank2:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			txtRank2:setText(rank)
		end
		txtFlowerNum2:setText(flowerNum)
	end

	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" then
		local conFlower1 = GetElement(self.m_root,"conFlower1_WndCharmSpace",WZUIContainer)
		conFlower1:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
		GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setFontSize(16)
		local conFlower6 = GetElement(self.m_root,"conFlower6_WndCharmSpace",WZUIContainer)
		conFlower6:setRelativePosition(GlobalMethod:ccp(0.12,0.5))
		GetElement(self.m_root,"txt6_WndCharmSpace",WZUILabelTTF):setFontSize(20)
	end
end

--@brief	点击奖励物品时显示tips
function WndCharmSpace:onOthersClick( tCell,tag,tData )
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false,nil,true)
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
	if self.m_nInterfaceType == 1 or self.m_nInterfaceType == 0 or self.m_nInterfaceType == 2 or self.m_nInterfaceType == 4 then 
		self.m_tRankRoleInfo = roleInfo

		GetElement(self.m_root, "conDetail_WndCharmSpace", WZUIContainer):setVisible(false)
		local conFashionDetail = GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer)
		conFashionDetail:setVisible(true)
		if conFashionDetail:getChildByTag(11) then 
			conFashionDetail:removeChildByTag(11, true)
		end
		if roleInfo ~=nil or roleInfo ~= {} then
			GetElement(self.m_root, "txtFashionPlayerName_WndCharmSpace", WZUILabelTTF):setText(roleInfo.playerName)

			local tEquip = {}
		    table.insert(tEquip, roleInfo.headId)
		    table.insert(tEquip, roleInfo.faceId)
		    table.insert(tEquip, roleInfo.bodyId)
		    table.insert(tEquip, roleInfo.wingId)

			local conPlayer = CreatePlayerFigure(roleInfo.sex, tEquip, "wait0", nil, nil, ccp(-0.4,1.5), nil, nil, nil, nil,roleInfo.headColor, roleInfo.bodyColor)
			conPlayer:getAnimNode():setTouchEnable(false)
	        conFashionDetail:addChild(conPlayer:getAnimNode(), 0, 11)
	    end
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
    -- WZLog("根据玩家ID搜索玩家",self.m_nInterfaceType)
    if searchID=="" then
    	MsgBoxManager:showTipBox(LocalStrings.TOUCH_TO_INPUT)
	elseif tonumber(searchID) ~= nil then
		if self.m_nInterfaceType == 0 then 
			ProtocolProcessorWndSpace:send_SPACE_SearchPlayer(tonumber(searchID))
		elseif self.m_nInterfaceType == 1 then 
			ProtocolProcessorWndSpace:send_SPACE_SearchFashionPlayer(1,tonumber(searchID))
		elseif self.m_nInterfaceType == 2 then 
			ProtocolProcessorWndSpace:send_SPACE_SearchPlayer(tonumber(searchID), 1)
		elseif self.m_nInterfaceType == 4 then
			ProtocolProcessorWndSpace:send_SPACE_SearchFashionPlayer(2,tonumber(searchID))
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
	local imgSpaceView = GetElement(wnd,"imgWndSpaceView",WZUIImage)
	imgSpaceView:setFile(self.currentPhoto)
	adaptPhoto(imgSpaceView)
end

--@brief	规则详细
function WndCharmSpace:onDescription( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	if self.m_nInterfaceType == 1 then 
		WndSingleMapDesc:showInterface(LocalStrings.CHARM_LIFT32)
	elseif self.m_nInterfaceType == 2 then 
		WndSingleMapDesc:showInterface(LocalStrings.CHARMSPACE_TEXT10)
	elseif self.m_nInterfaceType == 4 then
		WndSingleMapDesc:showInterface(LocalStrings.CHARM_LIFT38)
	else
		WndSingleMapDesc:showInterface(LocalStrings.CHARM_DES)
	end
end

--@brief 	点击报名按钮回调
function WndCharmSpace:onClickApply(element)
	-- body
	-- WZLog("点击报名按钮回调",self.m_tMyFashionData.applyState,self.m_oType)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--判断有没有报名
	if (self.m_tMyFashionData.applyState == 1 and self.m_oType == 1) or (self.m_tMyFashionData.applyState == 1 and self.m_oType == 2) then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT10)
		return
	end

	--幻化不让参加比赛
	if CacheCenter:getPlayerInfo().shapeId > 0 then 
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
	if self.m_nInterfaceType == 1 then
		ProtocolProcessorWndSpace:send_SPACE_Operation(1,1)
	elseif self.m_nInterfaceType == 4 then 
		ProtocolProcessorWndSpace:send_SPACE_Operation(2,1)
	end
end

--@brief 	点击报名界面推荐按钮回调
function WndCharmSpace:onFashionRecommend(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- WZLog("WndCharmSpace:onFashionRecommend", self.m_tMyFashionData.recommendTime)
	--判断是否已报名
	if (self.m_tMyFashionData.applyState == 0 and self.m_oType == 1) or (self.m_tMyFashionData.applyState == 0 and self.m_oType == 2) then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT22)
		return 
	end
	--判断有没有推荐
	if (self.m_tMyFashionData.recommendTime > 0 and self.m_oType == 1) or (self.m_tMyFashionData.recommendTime > 0 and self.m_oType == 2) then 
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
	if self.m_nInterfaceType == 1 then
		ProtocolProcessorWndSpace:send_SPACE_Operation(1,2)
	elseif self.m_nInterfaceType == 4 then
		ProtocolProcessorWndSpace:send_SPACE_Operation(2,2)
	end
end

--@brief 	点赞
function WndCharmSpace:onGiveGoodCallBack(tCell, tData)
	-- body
	-- WZLog("WndCharmSpace:onGiveGoodCallBack")
	if self.m_tCellSelRecommendPlayer then 
		-- WZLog("self.m_tCellSelRecommendPlayer", self.m_tCellSelRecommendPlayer:getPlayerId(), tData.id)
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
	if self.m_tRankRoleInfo == nil or self.m_tRankRoleInfo == {} then
		MsgBoxManager:showTipBox(LocalStrings.FRIENDS_SEND_TIP_3)
		return
	end
	if self.m_tRankRoleInfo.id == CacheCenter:getPlayerInfo().id then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT29)
		return 
	end
	-- WZLog("点击点赞按钮回调",self.m_tRankRoleInfo.id)
	if self.m_nInterfaceType == 1 then
		ProtocolProcessorWndSpace:send_SPACE_GiveLike(1,self.m_tRankRoleInfo.id)
	elseif self.m_nInterfaceType == 4 then
		ProtocolProcessorWndSpace:send_SPACE_GiveLike(2,self.m_tRankRoleInfo.id)
	end
end

--@brief 	点击查看按钮回调
function  WndCharmSpace:onClickCheck(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tRankRoleInfo == nil or self.m_tRankRoleInfo == {} then
		MsgBoxManager:showTipBox(LocalStrings.FRIENDS_SEND_TIP_3)
		return
	end
	WndCheckOther:show(self.m_tRankRoleInfo.id)
end

-------------------------------------公有方法模块End----------------------------------------
--@brief 	添加时装套装入口
function WndCharmSpace:_addDressSuit(element)
	-- body
	-- WZLog("添加时装套装入口",self.m_tMyFashionData.applyState,self.m_tMyFashionData.oType )
	if CheckButtonOpen(144, false) then
		local conForDressSuit = GetElement(element, "conForDressSuit_WndCharmSpace", WZUIContainer)
		if conForDressSuit then
			conForDressSuit:removeAllChildrenWithCleanup(true)
			self.m_tCellDressSuit = nil 
			if self.m_tMyFashionData.applyState == 0 and self.m_tMyFashionData.oType == 1 then 
				local wndDress, tCell = WndDressSuit:createElement()
				if wndDress and tCell then
					tCell:setType(5)
					self.m_tCellDressSuit = tCell
					conForDressSuit:addChild(wndDress)
				end
			end
			if self.m_tMyFashionData.applyState == 0 and self.m_tMyFashionData.oType == 2 then 
				local wndDress, tCell = WndDressSuit:createElement()
				if wndDress and tCell then
					tCell:setType(9)
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
--@param 	bVisible1 : 随机推荐
--@param 	bVisible2 : 周榜
--@param 	bVisible3 : 总榜
--@param 	bVisible4 : 排名奖励
--@param 	bVisible5 : 我的报名
--@param 	bVisible6 : 历届排名
function WndCharmSpace:_setFashionContentVisible(bVisible1, bVisible2, bVisible3, bVisible4, bVisible5, bVisible6)
	-- body
	--报名
	GetElement(self.m_root, "conSignup_WndCharmSpace", WZUIContainer):setVisible(bVisible5)
	GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):setVisible(bVisible5)

	GetElement(self.m_root, "conHistoryFirst_WndCharmSpace", WZUIContainer):setVisible(bVisible6)
	GetElement(self.m_root, "conFashionRecommend_WndCharmSpace", WZUIContainer):setVisible((self.m_nInterfaceType==1 or self.m_nInterfaceType == 4) and bVisible1) --时装推荐
	GetElement(self.m_root, "conRecommend1_WndCharmSpace", WZUIContainer):setVisible(bVisible1)
	GetElement(self.m_root, "conFlower_WndCharmSpace", WZUIContainer):setVisible(bVisible2 or bVisible3)
	GetElement(self.m_root, "conReward_WndCharmSpace", WZUIContainer):setVisible(bVisible4 or bVisible6)
	GetElement(self.m_root, "conRank_WndCharmSpace", WZUIContainer):setVisible(bVisible2 or bVisible3)
	GetElement(self.m_root, "conRecommend_WndCharmSpace", WZUIContainer):setVisible(bVisible1 or bVisible4)
	GetElement(self.m_root, "conButton_WndCharmSpace", WZUIContainer):setVisible(bVisible2)
	GetElement(self.m_root, "btnBigCheck_WndCharmSpace", WZUIContainer):setVisible(bVisible3)

	GetElement(self.m_root, "con17_WndCharmSpace", WZUIContainer):setVisible( self.m_nInterfaceType~=3 and (bVisible6 or bVisible2 or bVisible3) ) --历届,本周,历史 3个单选按钮
	WZLog("设置各界面内容的显示与否",self.m_nInterfaceType)
	if self.m_nInterfaceType == 4 then
		GetElement(self.m_root,"txtWeek1_CharmSpace",WZUILabelTTF):setTextKey("THIS_MONTH")
		GetElement(self.m_root,"txtWeek2_CharmSpace",WZUILabelTTF):setTextKey("THIS_MONTH")
		GetElement(self.m_root,"txtWeek3_CharmSpace",WZUILabelTTF):setTextKey("THIS_MONTH")
	else 
		GetElement(self.m_root,"txtWeek1_CharmSpace",WZUILabelTTF):setTextKey("THIS_WEEK")
		GetElement(self.m_root,"txtWeek2_CharmSpace",WZUILabelTTF):setTextKey("THIS_WEEK")	
		GetElement(self.m_root,"txtWeek3_CharmSpace",WZUILabelTTF):setTextKey("THIS_WEEK")
	end 	
	
	GetElement(self.m_root, "conTotalRankReward_WndCharmSpace", WZUIContainer):setVisible(self.m_nInterfaceType==3 and bVisible6) --魅力之王历届奖励

	self:_showFashionTopTab()
	self:_showSpaceTopTab()
	self:_showFootTopTab()
end

--@brief	设置魅力之王奖励
function WndCharmSpace:setCharmKingReward()
	-- WZLog("WndCharmSpace:setCharmKingReward",CacheCenter:getGameParam().KJReward)
	local KJReward = CacheCenter:getGameParam().KJReward
	if KJReward == nil then return end
	local string = string.sub(KJReward, 2, -2) 
    local id = SplitStringWithSeparator(string,",")[1]
    local num = SplitStringWithSeparator(string,",")[2]

	local conTotalRankReward = GetElement(self.m_root,"conTotalRankReward_WndCharmSpace",WZUIContainer)
	conTotalRankReward:removeAllChildrenWithCleanup(true)
	local celElement,tLuaObj = CellGoodItem:createElement()
	celElement:setScale(0.8)
    tLuaObj:setCellGoodLocalId(id, num, 17)
    tLuaObj:setItemClickFun(self, self.onClickKingReward)
    conTotalRankReward:addChild(celElement)
end

--@brief	点击魅力之王奖励后的回调
function WndCharmSpace:onClickKingReward(tItem, nTag, tData)
    -- WZLog("WndCharmSpace:onClickKingReward")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false,nil,true)
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
		ShowPanelNullTip(conFashionRecommend, LocalStrings.CHARM_LIFT31, nil, nil, nil, nil, nil, false)
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
		ShowPanelNullTip( conHistoryFirst, LocalStrings.CHARM_LIFT21, nil, nil, nil, nil, nil, false)
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

--@brief 	显示标签
function WndCharmSpace:_showFootTopTab()
	-- body
	for i = 1, 5 do
		GetElement(self.m_root, "conFoot" .. i .. "_WndCharmSpace", WZUIContainer):setVisible(i == self.tag)
	end
end

--@brief 	显示标签
function WndCharmSpace:_showSpaceTopTab()
	-- body
	for i = 1, 5 do
		GetElement(self.m_root, "con" .. i .. "_WndCharmSpace", WZUIContainer):setVisible(i == self.tag)
	end
end
-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	显示剩余点赞次数
function WndCharmSpace:_showLeftGoodNum()
	-- body
	GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(true)
	local txtGoodNum = GetElement(self.m_root, "txtGoodNum_WndCharmSpace", WZUILabelTTF)
	WZLog("显示剩余点赞次数",self.m_oType,self.m_nLeftOperateTimes,self.m_nTotalTimes)
	if txtGoodNum then 
		txtGoodNum:setText(self.m_nLeftOperateTimes .. "/" .. self.m_nTotalTimes)
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
		-- GetElement(self.m_root, "conForCharmSpace_WndCharmSpace", WZUIContainer):setVisible(true)
		-- GetElement(self.m_root, "conForCharmLife_WndCharmSpace", WZUIContainer):setVisible(false)
		-- GetElement(self.m_root, "conForCharmFoot_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(false)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setVisible(true)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setTextKey("EVERY_WEEKDAY")
		GetElement(self.m_root, "txt6Reward_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_SEND_REWRAD")
		GetElement(self.m_root, "ftbKingReward_WndCharmSpace", WZUIFreeTextBox):setShowText("")
		GetElement(self.m_root,"txtFlower1_WndCharmSpace",WZUILabelTTF):setTextKey("CHARM_FLOWER_NUM")
	elseif self.m_nInterfaceType == 1 then 
		-- GetElement(self.m_root, "conForCharmSpace_WndCharmSpace", WZUIContainer):setVisible(false)
		-- GetElement(self.m_root, "conForCharmFoot_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(true)
		-- GetElement(self.m_root, "conForCharmLife_WndCharmSpace", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setVisible(true)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setTextKey("EVERY_WEEKDAY")
		GetElement(self.m_root, "txt6Reward_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_LIFT23")
		GetElement(self.m_root, "ftbKingReward_WndCharmSpace", WZUIFreeTextBox):setShowText("")
		GetElement(self.m_root,"txtFlower1_WndCharmSpace",WZUILabelTTF):setTextKey("CHARM_LIFT26")
	elseif self.m_nInterfaceType == 2 then 
		GetElement(self.m_root, "conSignup_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionRecommend_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conHistoryFirst_WndCharmSpace", WZUIContainer):setVisible(false)
		-- GetElement(self.m_root, "conForCharmSpace_WndCharmSpace", WZUIContainer):setVisible(false)
		-- GetElement(self.m_root, "conForCharmLife_WndCharmSpace", WZUIContainer):setVisible(false)
		-- GetElement(self.m_root, "conForCharmFoot_WndCharmSpace", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(false)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setVisible(true)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setTextKey("EVERY_WEEKDAY")
		GetElement(self.m_root, "txt6Reward_WndCharmSpace", WZUILabelTTF):setTextKey("CHARMSPACE_TEXT4")
		GetElement(self.m_root, "ftbKingReward_WndCharmSpace", WZUIFreeTextBox):setShowText("")
		GetElement(self.m_root,"txtFlower1_WndCharmSpace",WZUILabelTTF):setTextKey("CHARMSPACE_TEXT5")
	elseif self.m_nInterfaceType == 3 then 
		GetElement(self.m_root, "conSignup_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conSignupBottom_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionRecommend_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conHistoryFirst_WndCharmSpace", WZUIContainer):setVisible(true)
		-- GetElement(self.m_root, "conForCharmSpace_WndCharmSpace", WZUIContainer):setVisible(false)
		-- GetElement(self.m_root, "conForCharmLife_WndCharmSpace", WZUIContainer):setVisible(false)
		-- GetElement(self.m_root, "conForCharmFoot_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionRank_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conFashionDetail_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(false)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setVisible(false)
		GetElement(self.m_root, "ftbKingReward_WndCharmSpace", WZUIFreeTextBox):setShowText(LocalStrings.CHARM_KING_SEND_REWARD)
		GetElement(self.m_root,"txtFlower1_WndCharmSpace",WZUILabelTTF):setTextKey("CHARM_FLOWER_NUM")
	elseif self.m_nInterfaceType == 4 then
		-- GetElement(self.m_root, "conForCharmSpace_WndCharmSpace", WZUIContainer):setVisible(false)
		-- GetElement(self.m_root, "conForCharmFoot_WndCharmSpace", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtGoodWord_WndCharmSpace", WZUILabelTTF):setVisible(true)
		-- GetElement(self.m_root, "conForCharmLife_WndCharmSpace", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setVisible(true)
		GetElement(self.m_root, "txt4Reward_WndCharmSpace", WZUILabelTTF):setTextKey("EVERY_MONTHDAY")
		GetElement(self.m_root, "txt6Reward_WndCharmSpace", WZUILabelTTF):setTextKey("CHARM_LIFT23")
		GetElement(self.m_root, "ftbKingReward_WndCharmSpace", WZUIFreeTextBox):setShowText("")
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


	local txtCheckLife1 = GetElement(self.m_root,"txtCheckLife1_WndCharmSpace",WZUILabelTTF)
	txtCheckLife1:setScale(0.7)
	txtCheckLife1:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLife1:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLife2 = GetElement(self.m_root,"txtCheckLife2_WndCharmSpace",WZUILabelTTF)
	txtCheckLife2:setScale(0.7)
	txtCheckLife2:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLife2:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLife3 = GetElement(self.m_root,"txtCheckLife3_WndCharmSpace",WZUILabelTTF)
	txtCheckLife3:setScale(0.7)
	txtCheckLife3:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLife3:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLife4 = GetElement(self.m_root,"txtCheckLife4_WndCharmSpace",WZUILabelTTF)
	txtCheckLife4:setScale(0.7)
	txtCheckLife4:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLife4:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLife5 = GetElement(self.m_root,"txtCheckLife5_WndCharmSpace",WZUILabelTTF)
	txtCheckLife5:setScale(0.7)
	txtCheckLife5:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLife5:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLife6 = GetElement(self.m_root,"txtCheckLife6_WndCharmSpace",WZUILabelTTF)
	txtCheckLife6:setScale(0.7)
	txtCheckLife6:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLife6:setDimensions(GlobalMethod:CCSize(140))

	local txtCheckLifeSel1 = GetElement(self.m_root,"txtCheckLifeSel1_WndCharmSpace",WZUILabelTTF)
	txtCheckLifeSel1:setScale(0.7)
	txtCheckLifeSel1:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLifeSel1:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLifeSel2 = GetElement(self.m_root,"txtCheckLifeSel2_WndCharmSpace",WZUILabelTTF)
	txtCheckLifeSel2:setScale(0.7)
	txtCheckLifeSel2:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLifeSel2:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLifeSel3 = GetElement(self.m_root,"txtCheckLifeSel3_WndCharmSpace",WZUILabelTTF)
	txtCheckLifeSel3:setScale(0.7)
	txtCheckLifeSel3:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLifeSel3:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLifeSel4 = GetElement(self.m_root,"txtCheckLifeSel4_WndCharmSpace",WZUILabelTTF)
	txtCheckLifeSel4:setScale(0.7)
	txtCheckLifeSel4:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLifeSel4:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLifeSel5 = GetElement(self.m_root,"txtCheckLifeSel5_WndCharmSpace",WZUILabelTTF)
	txtCheckLifeSel5:setScale(0.7)
	txtCheckLifeSel5:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLifeSel5:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckLifeSel6 = GetElement(self.m_root,"txtCheckLifeSel6_WndCharmSpace",WZUILabelTTF)
	txtCheckLifeSel6:setScale(0.7)
	txtCheckLifeSel6:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckLifeSel6:setDimensions(GlobalMethod:CCSize(140))

	

	local txtCheckFoot1 = GetElement(self.m_root,"txtCheckFoot1_WndCharmSpace",WZUILabelTTF)
	txtCheckFoot1:setScale(0.7)
	txtCheckFoot1:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckFoot1:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckFoot2 = GetElement(self.m_root,"txtCheckFoot2_WndCharmSpace",WZUILabelTTF)
	txtCheckFoot2:setScale(0.7)
	txtCheckFoot2:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckFoot2:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckFoot3 = GetElement(self.m_root,"txtCheckFoot3_WndCharmSpace",WZUILabelTTF)
	txtCheckFoot3:setScale(0.7)
	txtCheckFoot3:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckFoot3:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckFoot4 = GetElement(self.m_root,"txtCheckFoot4_WndCharmSpace",WZUILabelTTF)
	txtCheckFoot4:setScale(0.7)
	txtCheckFoot4:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckFoot4:setDimensions(GlobalMethod:CCSize(140))

	local txtCheckFootSel1 = GetElement(self.m_root,"txtCheckFootSel1_WndCharmSpace",WZUILabelTTF)
	txtCheckFootSel1:setScale(0.7)
	txtCheckFootSel1:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckFootSel1:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckFootSel2 = GetElement(self.m_root,"txtCheckFootSel2_WndCharmSpace",WZUILabelTTF)
	txtCheckFootSel2:setScale(0.7)
	txtCheckFootSel2:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckFootSel2:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckFootSel3 = GetElement(self.m_root,"txtCheckFootSel3_WndCharmSpace",WZUILabelTTF)
	txtCheckFootSel3:setScale(0.7)
	txtCheckFootSel3:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckFootSel3:setDimensions(GlobalMethod:CCSize(140))
	local txtCheckFootSel4 = GetElement(self.m_root,"txtCheckFootSel4_WndCharmSpace",WZUILabelTTF)
	txtCheckFootSel4:setScale(0.7)
	txtCheckFootSel4:setRelativePosition(GlobalMethod:ccp(0.5,0.48))
	txtCheckFootSel4:setDimensions(GlobalMethod:CCSize(140))
	
	GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.05,1))
	GetElement(self.m_root,"txt1_WndCharmSpace",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(600))

	GetElement(self.m_root,"txt4Reward_WndCharmSpace",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"txtWeek1_CharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtWeek2_CharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtWeek3_CharmSpace",WZUILabelTTF):setScale(0.7)
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

function WndCharmSpace:_adaptLanguage_ug(  )
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndCharmSpace",WZUILabelTTF)
	txtCheck1:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheck1:setScale(0.6)
	local txtCheckSel1 = GetElement(self.m_root,"txtCheckSel1_WndCharmSpace",WZUILabelTTF)
	txtCheckSel1:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheckSel1:setScale(0.6)
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndCharmSpace",WZUILabelTTF)
	txtCheck2:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheck2:setScale(0.6)
	local txtCheckSel2 = GetElement(self.m_root,"txtCheckSel2_WndCharmSpace",WZUILabelTTF)
	txtCheckSel2:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheckSel2:setScale(0.6)
	local txtCheck3 = GetElement(self.m_root,"txtCheck3_WndCharmSpace",WZUILabelTTF)
	txtCheck3:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheck3:setScale(0.6)
	local txtCheckSel3 = GetElement(self.m_root,"txtCheckSel3_WndCharmSpace",WZUILabelTTF)
	txtCheckSel3:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheckSel3:setScale(0.6)
	local txtCheck4 = GetElement(self.m_root,"txtCheck4_WndCharmSpace",WZUILabelTTF)
	txtCheck4:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheck4:setScale(0.6)
	local txtCheckSel4 = GetElement(self.m_root,"txtCheckSel4_WndCharmSpace",WZUILabelTTF)
	txtCheckSel4:setDimensions(GlobalMethod:CCSize(160,0))
	txtCheckSel4:setScale(0.6)

	GetElement(self.m_root,"txtAll_WndCharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtAllSel_WndCharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtMale_WndCharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtMaleSel_WndCharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRecFem_WndCharmSpace",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtRecFemSel_WndCharmSpace",WZUILabelTTF):setScale(0.7)

	local conFlower = GetElement(self.m_root,"conFlower_WndCharmSpace",WZUIContainer)
	local txt1 = GetElement(conFlower,"txt1_WndCharmSpace",WZUILabelTTF)
	txt1:setScale(0.7)
	txt1:setDimensions(GlobalMethod:CCSize(380))
	local txt2 = GetElement(conFlower,"txt2_WndCharmSpace",WZUILabelTTF)
	txt2:setScale(0.7)
	txt2:setRelativePosition(GlobalMethod:ccp(-0.47,0.5))
	local txt3 = GetElement(conFlower,"txt3_WndCharmSpace",WZUILabelTTF)
	txt3:setRelativePosition(GlobalMethod:ccp(1.01,0.5))
	local txt4 = GetElement(conFlower,"txt4_WndCharmSpace",WZUILabelTTF)
	txt4:setScale(0.7)
	txt4:setRelativePosition(GlobalMethod:ccp(-0.085,0.5))
	local txt5 = GetElement(conFlower,"txt5_WndCharmSpace",WZUILabelTTF)
	txt5:setRelativePosition(GlobalMethod:ccp(1.01,0.5))
	local txt6 = GetElement(conFlower,"txt6_WndCharmSpace",WZUILabelTTF)
	txt6:setScale(0.7)
	txt6:setDimensions(GlobalMethod:CCSize(350))
	txt6:setRelativePosition(GlobalMethod:ccp(-0.25,0.5))

	local conReward1 = GetElement(self.m_root,"conReward1_WndCharmSpace",WZUIContainer)
	conReward1:setScale(0.7)
	conReward1:setRelativePosition(GlobalMethod:ccp(0.3,0.48))

end
-------------------------------------语言适配End------------------------------------------