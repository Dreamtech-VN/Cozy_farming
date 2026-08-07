--WndAuctionRank.lua
--@brief	WndAuctionRank的UI模块
--@date		2020/08/04
--@author	yrd
--@note		竞拍榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAuctionRank:onEnter(element)
	self.m_root = element
	ProtocolProcessorNewActivity:regAll()

	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAuctionRank:onExit(element)
	self:_unInit()
end

--@brief	关闭界面
function WndAuctionRank:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	刷新界面
function WndAuctionRank:updateUI()
	if self.m_nType == 1 then
		local con1 = GetElement(self.m_root,"con1_WndAuctionRank",WZUIContainer)
		con1:setVisible(true)

		GetElement(self.m_root,"txtTitle_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT23)
		GetElement(self.m_root,"txtMyAuctionPW_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT14)
		GetElement(self.m_root,"txtWord1_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.RANK)
		GetElement(self.m_root,"txtWord2_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT12)
		GetElement(self.m_root,"txtWord3_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT13)
		GetElement(self.m_root,"txtWord4_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
		GetElement(self.m_root,"txtDesc1_WndAuctionRank",WZUILabelTTF):setText("")

		GetElement(self.m_root,"cbgPage_WndAuctionRank",WZUICheckBoxGroup):setCheckIndex(0)

		local rankType = 1
		if self.m_tData and self.m_tData[rankType] then
			self:updateRankUI()
		else
			ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionRank(rankType)
		end
	elseif self.m_nType == 2 then
		local con2 = GetElement(self.m_root,"con2_WndAuctionRank",WZUIContainer)
		con2:setVisible(true)

		GetElement(self.m_root,"txtTitle_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT22)

		local tconAuctionItem = GetElement(self.m_root,"tconAuctionItem_WndAuctionRank",WZUITableContainer)
		tconAuctionItem:cleanTable()
		for i=1,#self.m_tData do
        	local cellElement, tCell = CellAuctionTodayItem:createElement()
            cellElement:setTag(i-1)
            tconAuctionItem:setCellElement(cellElement)
            tCell:setData(self.m_tData[i])
		end
	elseif self.m_nType == 3 then
		local con1 = GetElement(self.m_root,"con1_WndAuctionRank",WZUIContainer)
		con1:setVisible(true)

		GetElement(self.m_root,"txtTitle_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.ACTIVITY_TEXT6)
		GetElement(self.m_root,"txtMyAuctionPW_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[22]..":")
		GetElement(self.m_root,"txtWord1_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.RANK)
		GetElement(self.m_root,"txtWord2_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT12)
		GetElement(self.m_root,"txtWord3_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[2])
		GetElement(self.m_root,"txtWord4_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
		GetElement(self.m_root,"txtDesc1_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[23])

		GetElement(self.m_root,"cbgPage_WndAuctionRank",WZUICheckBoxGroup):setCheckIndex(1)

		local rankType = 2
		if self.m_tData and self.m_tData[rankType] then
			self:updateRankUI()
		else
			ProtocolProcessorNewActivity:send_ACTIVITY2_GetAuctionRank(rankType)
		end
	end
end

--@brief	刷新竞拍榜界面
function WndAuctionRank:updateRankUI()
	local rankType
	if self.m_nType == 1 then
		rankType = 1
	elseif self.m_nType == 3 then
		rankType = 2
	end
	-- 我的积分
	local txtMyAuctionPoints = GetElement(self.m_root,"txtMyAuctionPoints_WndAuctionRank",WZUILabelTTF)
	txtMyAuctionPoints:setText(self.m_myScore[rankType])
	-- 我的排名
	local txtMyRanking = GetElement(self.m_root,"txtMyRanking_WndAuctionRank",WZUILabelTTF)
	txtMyRanking:setText(self.m_myRank[rankType]==-1 and LocalStrings.WNDCHECKOTHER46 or self.m_myRank[rankType])

	local rankType = 1
	if self.m_nType == 1 then
		rankType = 1
	elseif self.m_nType == 3 then
		rankType = 2
	end
	
	local tconPlayer = GetElement(self.m_root,"tconPlayer_WndAuctionRank",WZUITableContainer)
	tconPlayer:cleanTable()
	local conPlayers = GetElement(self.m_root,"conPlayers_WndAuctionRank",WZUIContainer)
	if #self.m_tData[rankType] == 0 then
		ShowPanelNullTip(conPlayers, LocalStrings.EMPTY_INFO)
		return
	end
	removeShowPanelNullTip(conPlayers)

	for i=1,#self.m_tData[rankType] do
		local cellElement, tCell = CellAuctionRank:createElement()
        cellElement:setTag(i-1)
        tconPlayer:setCellElement(cellElement)
        tCell:setData(self.m_tData[rankType][i])
	end
end

-- 今日拍品物品点击回调
function WndAuctionRank:addTips(tCell)
	local tData = {}
	tData.id = tCell.m_tData[1]
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData, false)
end

-- 排行榜物品点击回调
function WndAuctionRank:addRankTips(tItem, nTag, tData)
	WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

-- 点击页签
function WndAuctionRank:onClickPage(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if tag == 1 then
		self.m_nType = 1
	elseif tag == 2 then
		self.m_nType = 3
	end
	self:updateUI()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 设置静态文本
function WndAuctionRank:_initStaticText()
	GetElement(self.m_root,"txtCheck1C1_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT23)
	GetElement(self.m_root,"txtCheck1C2_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT23)
	GetElement(self.m_root,"txtCheck2C1_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[21])
	GetElement(self.m_root,"txtCheck2C2_WndAuctionRank",WZUILabelTTF):setText(LocalStrings.AUCTION_HOUSE_TEXT37[21])
end



-------------------------------------私有方法模块End----------------------------------------

-- 设置静态文本
function WndAuctionRank:_adaptLanguage_vn()
	GetElement(self.m_root,"txtCheck1C1_WndAuctionRank",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCheck1C2_WndAuctionRank",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCheck2C1_WndAuctionRank",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtCheck2C2_WndAuctionRank",WZUILabelTTF):setScale(0.7)
end
