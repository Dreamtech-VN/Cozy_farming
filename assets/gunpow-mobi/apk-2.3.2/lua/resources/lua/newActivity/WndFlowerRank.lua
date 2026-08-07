--WndFlowerRank.lua
--@brief	WndFlowerRank的UI模块
--@date		2025/04/07
--@author	yrd
--@note		鲜花榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFlowerRank:onEnter(element)
	WZLog("WndFlowerRank:onEnter")

	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)

    WndMarryManager:createLoading()
    WndMarryManager:initManager()

	self:setU2Visible(false)
	self:setU3Visible(false)
	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFlowerRank:onExit(element)
	self:_unInit()

    ProtocolProcessorWndRankList:regAll()

	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end

--@brief    onenter函数已执行
function WndFlowerRank:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(6)
	ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(42)
	-- ProtocolProcessorBase:send_ACTIVITY_GetFlowerActivityInfo() --赠送记录
	ProtocolProcessorWndActivityOnLine:send_RANK_GetRankingTopList(42, 1)
	ProtocolProcessorWndActivityOnLine:send_RANK_GetRankingTopList(43, 1)
end

--@brief    关闭窗口
function WndFlowerRank:onClickClose(element)
    ProtocolProcessorWndRankList:unregAll()

	local eleType = type(element)
	if eleType ~= "number" then 
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	初始化静态文本
function WndFlowerRank:_initStaticText()
	GetElement(self.m_root, "txtU1Tab1Nor", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[2])
	GetElement(self.m_root, "txtU1Tab1Sel", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[2])
	GetElement(self.m_root, "txtU1Tab2Nor", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[3])
	GetElement(self.m_root, "txtU1Tab2Sel", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[3])
	GetElement(self.m_root, "txtU1Operate1", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[4])
	GetElement(self.m_root, "txtU1Operate2", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[5])
	GetElement(self.m_root, "txtU1TitleWord1", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[6])
	GetElement(self.m_root, "txtU1TitleWord2", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[7])
	GetElement(self.m_root, "txtU1TitleWord3", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[8])
	GetElement(self.m_root, "txtU1TitleWord4", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[9])

	GetElement(self.m_root, "txtU2Title", WZUILabelTTF):setText(LocalStrings.GENERAL_LIST)
	GetElement(self.m_root, "txtU2TitleWord1", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[6])
	GetElement(self.m_root, "txtU2TitleWord2", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[7])
	GetElement(self.m_root, "txtU2TitleWord3", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[8])

	GetElement(self.m_root, "txtU3Title", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[5])
	GetElement(self.m_root, "txtU3Tab1Nor", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[2])
	GetElement(self.m_root, "txtU3Tab1Sel", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[2])
	GetElement(self.m_root, "txtU3Tab2Nor", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[3])
	GetElement(self.m_root, "txtU3Tab2Sel", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[3])

	GetElement(self.m_root, "txtU4Title", WZUILabelTTF):setText(LocalStrings.FLOWER_RANK_TEXT1[12])
	local ftbU4Desc = GetElement(self.m_root,"ftbU4Desc",WZUIFreeTextBox)
	ftbU4Desc:setShowText(LocalStrings.FLOWER_LIST_RULE)
	ftbU4Desc:setPositionY(ftbU4Desc:getContentSize().height)
	local scU4Desc = GetElement(self.m_root,"scU4Desc",WZUIScrollContainer)
	local moveElement = scU4Desc:getMoveElement()
	moveElement:setRelativeSize( CCSize( moveElement:getRelativeSize().width , (ftbU4Desc:getContentSize().height + 10) / scU4Desc:getContentSize().height ) )
	scU4Desc:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(scU4Desc:getMinPosition().y)
end

--@brief	更新我的排名
function WndFlowerRank:updateMyRank()
	local strFormat = [[<T C="127,70,26" S="18" P="1">%s</T><T C="229,105,22" S="18" P="1">%s</T>]]
	local ftbU1RankDesc1 = GetElement(self.m_root,"ftbU1RankDesc1",WZUIFreeTextBox)
	local ftbU1RankDesc2 = GetElement(self.m_root,"ftbU1RankDesc2",WZUIFreeTextBox)
	local strRank = self.m_tMyRank.myRank
	if self.m_tMyRank.myRank == -1 then
		strRank = LocalStrings.NOT_IN_RANKLIST
	end
	ftbU1RankDesc1:setShowText(string.format(strFormat, LocalStrings.DOUBLE_SEVEN_TEXT14, strRank))
	ftbU1RankDesc2:setShowText(string.format(strFormat, LocalStrings.FLOWER_RANK_TEXT1[10], self.m_tMyRank.rankValue))

	local ftbU2RankDesc1 = GetElement(self.m_root,"ftbU2RankDesc1",WZUIFreeTextBox)
	local ftbU2RankDesc2 = GetElement(self.m_root,"ftbU2RankDesc2",WZUIFreeTextBox)
	local tData = self.m_tU1RankData[2]
	local strRank = LocalStrings.NOT_IN_RANKLIST
	for i=1,#tData do
		if tData[i].playerId == CacheCenter:getPlayerInfo().id then
			strRank = i
			break
		end
	end
	ftbU2RankDesc1:setShowText(string.format(strFormat, LocalStrings.DOUBLE_SEVEN_TEXT14, strRank))
	ftbU2RankDesc2:setShowText(string.format(strFormat, LocalStrings.FLOWER_RANK_TEXT1[10], self.m_tMyRank.rankValue))
end


--@brief 	点击切换排行榜类型
function WndFlowerRank:onClickU1SwitchRank(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nIndex = GetElement(self.m_root, "cbgU1Rank", WZUICheckBoxGroup):getCheckIndex()
	if self.m_nU1RankType == nIndex then
		return
	end

	self.m_nU1RankType = nIndex
	-- self:sendProtocolGetRankingList()
	self.m_bU1First = true
	self:updateUI1()
end

--@brief 	更新排行榜
function WndFlowerRank:updateUI1()
	local ftbU1RankDesc1 = GetElement(self.m_root,"ftbU1RankDesc1",WZUIFreeTextBox)
	local ftbU1RankDesc2 = GetElement(self.m_root,"ftbU1RankDesc2",WZUIFreeTextBox)
	local ftbU1RankDesc3 = GetElement(self.m_root,"ftbU1RankDesc3",WZUIFreeTextBox)
	ftbU1RankDesc1:setVisible(self.m_nU1RankType == CacheCenter:getPlayerInfo().sex)
	ftbU1RankDesc2:setVisible(self.m_nU1RankType == CacheCenter:getPlayerInfo().sex)
	ftbU1RankDesc3:setShowText(string.format(LocalStrings.FLOWER_RANK_TEXT1[11], 50))

	self:showU1RankList()
	self:showU1TopPlayer()
end

--@brief	显示男女榜
function WndFlowerRank:showU1RankList()
	local flcU1Rank = GetElement(self.m_root,"flcU1Rank",WZUIFreeListContainer)

	local oldPosY = flcU1Rank:getMoveElement():getPositionY()

	local cnt = #self.m_tU1RankObj
	local cellHeight = 82
	local itemInterval = 4
	
	local tData = self.m_tU1RankData[self.m_nU1RankType]
	if #self.m_tU1RankObj > 0 then
		for i=#self.m_tU1RankObj, #tData, -1 do
			if self.m_tU1RankObj[i] and self.m_tU1RankObj[i].m_root then
				self.m_tU1RankObj[i].m_root:removeAllChildrenWithCleanup(true)
			end
			self.m_tU1RankObj[i] = nil
			flcU1Rank:removeAt(i-1)
		end
	end

	for i=1,#tData do
		if self.m_tU1RankObj[i] == nil then
			local celElement, tLuaObj = CellConcertedRankU1:createElement()
			celElement:setTag(i-1)
			flcU1Rank:pushBack(celElement)
			self.m_tU1RankObj[i] = tLuaObj
		end
		self.m_tU1RankObj[i]:setData(tData[i])
	end

	if self.m_bU1First == true then
		self.m_bU1First = false
		flcU1Rank:getMoveElement():setPositionY(flcU1Rank:getMinPosition().y)
	else
		local curPosY = oldPosY - (cellHeight + itemInterval) / 2 * (#self.m_tU1RankObj - cnt)
		flcU1Rank:getMoveElement():setPositionY(curPosY)
	end
end

--@brief	显示榜一玩家形象
function WndFlowerRank:showU1TopPlayer()
	local conU1Portrayal = GetElement(self.m_root,"conU1Portrayal",WZUIContainer)
	conU1Portrayal:removeChildByTag(50,true)
	-- local conU1PTitle = GetElement(self.m_root,"conU1PTitle",WZUIContainer)
	-- conU1PTitle:removeChildByTag(60,true)
	-- local txtU1PTitle = GetElement(self.m_root,"txtU1PTitle",WZUILabelTTF)
	-- txtU1PTitle:setText("")
	local txtU1PName = GetElement(self.m_root,"txtU1PName",WZUILabelTTF)

	local tData = self.m_tU1RankData[self.m_nU1RankType]
	if tData[1] == nil then
		return
	end

	local sex = tData[1].sex
	local headId = tData[1].headId
	local faceId = tData[1].faceId
	local bodyId = tData[1].bodyId
	local wingId = tData[1].wingId
	local headColor = tData[1].headColor
	local bodyColor = tData[1].bodyColor
	local title = tData[1].title
	local name = tData[1].nickname

	local tPortrayal = {headId,faceId,bodyId,wingId}

	local conPlayer = CreatePlayerFigure(sex,tPortrayal,nil,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
	conPlayer:setFlipX(false)
	local animNode = conPlayer:getAnimNode()
	animNode:setTouchEnable(false)
	animNode:setTag(50)
	animNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	animNode:setRelativePosition(GlobalMethod:ccp(0.5,-0.02))
	animNode:setScale(1)
	conU1Portrayal:addChild(animNode)

	-- CreateDesiSpine(conU1PTitle, txtU1PTitle, title, GlobalMethod:ccp(0.5,1.3))

	txtU1PName:setText(name)
end


--@brief	点击打开总榜按钮
function WndFlowerRank:onClickU1Operate1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:setU2Visible(true)
end

--@brief	设置总榜界面显示
function WndFlowerRank:setU2Visible(bVisible)
	GetElement(self.m_root,"conInterface2",WZUIContainer):setVisible(bVisible)
end

--@brief	点击关闭总榜按钮
function WndFlowerRank:onClickU2Close(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:setU2Visible(false)
end

--@brief	刷新总榜界面数据
function WndFlowerRank:updateUI2()
	local ftbU2RankDesc1 = GetElement(self.m_root,"ftbU2RankDesc1",WZUIFreeTextBox)
	local ftbU2RankDesc2 = GetElement(self.m_root,"ftbU2RankDesc2",WZUIFreeTextBox)
	local ftbU2RankDesc3 = GetElement(self.m_root,"ftbU2RankDesc3",WZUIFreeTextBox)
	ftbU2RankDesc1:setShowText("")
	ftbU2RankDesc2:setShowText("")
	ftbU2RankDesc3:setShowText(string.format(LocalStrings.FLOWER_RANK_TEXT1[11], 100))

	self:showU2RankList()
end

--@brief	显示男女榜
function WndFlowerRank:showU2RankList()
	local flcU2Rank = GetElement(self.m_root,"flcU2Rank",WZUIFreeListContainer)

	local oldPosY = flcU2Rank:getMoveElement():getPositionY()

	local cnt = #self.m_tU2RankObj
	local cellHeight = 82
	local itemInterval = 4
	
	local tData = self.m_tU1RankData[2]
	if #self.m_tU2RankObj > 0 then
		for i=#self.m_tU2RankObj, #tData, -1 do
			if self.m_tU2RankObj[i] and self.m_tU2RankObj[i].m_root then
				self.m_tU2RankObj[i].m_root:removeAllChildrenWithCleanup(true)
			end
			self.m_tU2RankObj[i] = nil
			flcU2Rank:removeAt(i-1)
		end
	end

	for i=1,#tData do
		if self.m_tU2RankObj[i] == nil then
			local celElement, tLuaObj = CellConcertedRankU2:createElement()
			celElement:setTag(i-1)
			flcU2Rank:pushBack(celElement)
			self.m_tU2RankObj[i] = tLuaObj
		end
		self.m_tU2RankObj[i]:setData(tData[i])
	end

	if self.m_bU2First == true then
		self.m_bU2First = false
		flcU2Rank:getMoveElement():setPositionY(flcU2Rank:getMinPosition().y)
	else
		local curPosY = oldPosY - (cellHeight + itemInterval) / 2 * (#self.m_tU2RankObj - cnt)
		flcU2Rank:getMoveElement():setPositionY(curPosY)
	end
end


--@brief	点击打开"历届榜"按钮
function WndFlowerRank:onClickU1Operate2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:setU3Visible(true)
	self.m_bU3First = true
	self:updateUI3()
end

--@brief	设置历届榜界面显示
function WndFlowerRank:setU3Visible(bVisible)
	GetElement(self.m_root,"conInterface3",WZUIContainer):setVisible(bVisible)
end

--@brief	点击关闭"历届榜"按钮
function WndFlowerRank:onClickU3Close(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:setU3Visible(false)
end

--@brief	点击切换"历届榜"男女标签
function WndFlowerRank:onClickU3SwitchRank(element)
	local tag = element:getTag()

	if self.m_nU3RankType == tag then
		return
	end

	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nU3RankType = tag

	self.m_bU3First = true
	self:updateUI3()
end

--@brief	刷新"历届榜"界面
function WndFlowerRank:updateUI3()
	local tData = self.m_tU3RankData[self.m_nU3RankType]

	local conU3List = GetElement(self.m_root,"conU3List",WZUIContainer)
	if #tData > 0 then
		removeShowPanelNullTip(conU3List)
	else
		ShowPanelNullTip(conU3List, LocalStrings.COMMUNITY_COMPETE_TEXT43)
	end

	local flcU3Rank = GetElement(self.m_root,"flcU3Rank",WZUIFreeListContainer)

	local oldPosX = flcU3Rank:getMoveElement():getPositionX()

	local cnt = #self.m_tU3RankObj
	local cellWidth = 246
	local itemInterval = 20
	
	if #self.m_tU3RankObj > 0 then
		for i=#self.m_tU3RankObj, #tData, -1 do
			if self.m_tU3RankObj[i] and self.m_tU3RankObj[i].m_root then
				self.m_tU3RankObj[i].m_root:removeAllChildrenWithCleanup(true)
			end
			self.m_tU3RankObj[i] = nil
			flcU3Rank:removeAt(i-1)
		end
	end

	for i=1,#tData do
		if self.m_tU3RankObj[i] == nil then
			local celElement, tLuaObj = CellConcertedRankU3:createElement()
			celElement:setTag(i-1)
			flcU3Rank:pushBack(celElement)
			self.m_tU3RankObj[i] = tLuaObj
		end
		self.m_tU3RankObj[i]:setData(tData[i])
	end

	if self.m_bU3First == true then
		self.m_bU3First = false
		flcU3Rank:getMoveElement():setPositionX(flcU3Rank:getMaxPosition().x)
	else
		local oldPosX = oldPosX + (cellWidth + itemInterval) / 2 * (#self.m_tU3RankObj - cnt)
		flcU3Rank:getMoveElement():setPositionX(oldPosX)
	end
end



--@brief	点击打开"规则"按钮
function WndFlowerRank:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:setU4Visible(true)
end

--@brief	设置历届榜界面显示
function WndFlowerRank:setU4Visible(bVisible)
	GetElement(self.m_root,"conInterface4",WZUIContainer):setVisible(bVisible)
end

--@brief	点击关闭"规则"按钮
function WndFlowerRank:onClickU4Close(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self:setU4Visible(false)
end

-- -------------------------------------公有方法模块End----------------------------------------


-- -------------------------------------私有方法模块Begin--------------------------------------





-- -------------------------------------私有方法模块End----------------------------------------

--@brief  越南语适配函数
function WndFlowerRank:_adaptLanguage_vn()
	GetElement(self.m_root, "txtU1Operate1", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtU1Operate2", WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root, "txtU3Tab1Nor", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtU3Tab1Sel", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtU3Tab2Nor", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "txtU3Tab2Sel", WZUILabelTTF):setScale(0.7)
end
