--CellFootballShootRank.lua
--@brief	CellFootballShootRank的UI模块
--@date		2018/06/05
--@author	Tianxiang_Xu
--@note		点球排名界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFootballShootRank:onEnter(element)
	local elementName = element:getName()
	WZLog("elementName = ",elementName)
	if elementName == "CellFireworksAnnRankList" or elementName == "conRankListReward_CellFootballShootRank" then return end
	self.m_root = element

	self:initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFootballShootRank:onExit(element)
	self:_unInit()
end

function CellFootballShootRank:initUI()
	WZLog("CellFootballShootRank:initUI")
	if self.m_tRankInfo ~= nil then
		local conRankList = GetElement(self.m_root,"conRankList_CellFootballShootRank",WZUIContainer)
		local tabRankList = GetElement(conRankList,"tabRankList_CellFootballShootRank",WZUITableContainer)
		local txtRankMySelf = GetElement(self.m_root,"txtRankMySelf_CellFootballShootRank",WZUILabelTTF)
		if self.m_nMyRank == -1 then
			txtRankMySelf:setText(LocalStrings.COMMUNITY_COMPETE_TEXT43 .. "" ..LocalStrings.RANK)
		else
			txtRankMySelf:setText(LocalStrings.PLAYER_RANK_SCENEWORLDBOSS .. "" .. self.m_nMyRank)
		end
		
		tabRankList:cleanTable()

		if #self.m_tRankInfo > 0  then
			removeShowPanelNullTip(conRankList)
			for i,v in ipairs(self.m_tRankInfo) do
				local element = WZUIContainer:create()
				element:setUseAbsSize(true)
				element:setName("CellFireworksAnnRankList")
				element:setAbsContentSize(GlobalMethod:CCSize(420,65))
				element:setLuaObjectIndex(self)
				element:setTag(i-1)
				tabRankList:setCellElement(element)
		    end
		else
			ShowPanelNullTip(conRankList)
		end
		
	end
	
	self:_footballReward()
end

function CellFootballShootRank:onClickGet(tCell, tag, tData)
	WZLog("CellFootballShootRank:onClickGet =")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root, WndFootballActivity.m_root, 1, tData, false)
end

function CellFootballShootRank:onClickBack(element)
	WZLog("CellFootballShootRank:onClickBack")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	IS_FOOTBALL_RANK = false
	local parent = self.m_root:getParent()
	local childNode = parent:getChildByTag(122)
	if childNode then
		childNode:setVisible(true)
	end
	self.m_root:removeFromParentAndCleanup(true)
end

function CellFootballShootRank:onClickPlayer(element)
	WZLog("CellFootballShootRank:onClickPlayer")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent = element:getParent()
	local tag = parent:getTag()+1
	if self.m_tRankInfo[tag][2] then
		local playerId = self.m_tRankInfo[tag][2]
		WndCheckOther:show(playerId)
	end
end

function CellFootballShootRank:onLoadData(element)
	if element:getName() ~= "CellFireworksAnnRankList" then return end
	element:removeAllChildrenWithCleanup(true)
    local v = self.m_tRankInfo[element:getTag()+1]
	local cellNode = CreateElement("conRankListItem_CellFootballShootRank")
	cellNode:setTag(element:getTag())
	cellNode:setVisible(true)
	local conHead = GetElement(cellNode,"conHead_CellFootballShootRank",WZUIContainer)
	local headNode,headLua = CellHead:show(conHead,v[5],v[4],v[6],nil,GlobalMethod:ccp(0.52,0.3),v[8],v[9],nil,nil,0.45)
	
	local imgRank = GetElement(cellNode,"imgRank_CellFootballShootRank",WZUIImage)
	if v[1] == 1 then
		imgRank:setFile("ui/common/common_icon_1st.png")
	elseif v[1] == 2 then
		imgRank:setFile("ui/common/common_icon_2nd.png")
	elseif v[1] == 3 then
		imgRank:setFile("ui/common/common_icon_3rd.png")
	else
		local lafTxt = GetElement(cellNode,"lafTxt_CellFootballShootRank",WZUILabelAtlasFont)
		lafTxt:setText(v[1])
	end
	local txtPlayerName = GetElement(cellNode,"txtPlayerName_CellFootballShootRank",WZUILabelTTF)
	txtPlayerName:setText(v[3])

	local txtPlayerLevel = GetElement(cellNode,"txtPlayerLevel_CellFootballShootRank",WZUILabelTTF)
	txtPlayerLevel:setText("Lv"..v[7])

	local txtIntegralValue = GetElement(cellNode,"txtIntegralValue_CellFootballShootRank",WZUILabelTTF)
	txtIntegralValue:setText(v[10])

	if v[11] == 1 then
		GetElement(cellNode,"imgTag_CellFootballShootRank",WZUIImage):setVisible(true)
	end
	element:addChild(cellNode)		
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	點球排行榜獎勵
function CellFootballShootRank:_footballReward(  )
	--GetElement(conRankListReward,"imgRewardLine_CellFootballShootRank",WZUIImage):setFile("ui/football/football_pattern_002.png")
	local tabRewardList = GetElement(self.m_root,"tabRewardList_CellFootballShootRank",WZUITableContainer)
	tabRewardList:cleanTable()

	local sItemFormat = [[<T C="255,227,116" P="1" S="22" SC="105,65,46" SE="1" SS="4">%s </T>]]

	for i=1,#self.footballReward do
		local conFootballReward = CreateElement("conRankListReward_CellFootballShootRank")
		conFootballReward:setTag(i-1)
		conFootballReward:setVisible(true)

		local tItemString = SplitStringWithSeparator(self.footballReward[i].rank, "+")
		WZLog("--dsgaagagag---",Serialize(tItemString))
		local imgRank = GetElement(conFootballReward,"imgRank_conRankListReward",WZUIImage)
		if tItemString[1] == "1" then
			imgRank:setFile("ui/common/common_icon_1st.png")
		elseif tItemString[1] == "2" then
			imgRank:setFile("ui/common/common_icon_2nd.png")
		elseif tItemString[1] == "3" then
			imgRank:setFile("ui/common/common_icon_3rd.png")
		else
			GetElement(conFootballReward, "fxtRank_conRankListReward", WZUIFreeTextBox):setShowText(string.format(sItemFormat, tItemString[1]))
		end
		local itemList = self.footballReward[i].m_tData
		local nItemindex = 0
		for j = 1, #itemList do
			if tonumber(itemList[j].id) ~= -1 then
				local key = "id_"..itemList[j].id
				local num = itemList[j].num
				nItemindex = nItemindex + 1
				local conItem = GetElement(conFootballReward,"con"..nItemindex.."_CellFootballShootRank",WZUIContainer)
				conItem:removeAllChildrenWithCleanup(true)
				conItem:setVisible(true)
				local celElement,tLuaObj = CellGoodItem:createElement()
				if celElement ~= nil then 
					celElement = WZUIContainer:luaTo(celElement)
					local itemInfo = {id = itemList[j].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=itemList[j].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
					--WZLog("-dgag-a-----235345",Serialize(itemInfo))
					tLuaObj:setCellGoodItem(itemInfo,4)
					celElement:setTag(i-1)
					celElement:setScale(0.7)
					tLuaObj:setItemClickFun(self, self.onClickGet)
					conItem:addChild(celElement)
				end
		    end
		end
		tabRewardList:setCellElement(conFootballReward)
	end
end




-------------------------------------私有方法模块End----------------------------------------
