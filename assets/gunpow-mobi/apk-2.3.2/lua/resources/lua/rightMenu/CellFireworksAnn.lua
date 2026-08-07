--CellFireworksAnn.lua
--@brief	CellFireworksAnn的UI模块
--@date		2017/05/26
--@author	 
--@note		烟花排行榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFireworksAnn:onEnter(element)
	local elementName = element:getName()
	WZLog("elementName = ",elementName)
	if elementName == "CellFireworksAnnRankList" or elementName == "conRankListReward_CellFireworksAnn" then return end
	self.m_root = element
	self:_adjustUIPos()
	self:initUI()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFireworksAnn:onExit(element)
	self:_unInit()
end

function CellFireworksAnn:initUI()
	WZLog("CellFireworksAnn:initUI")
	if self.m_tRankInfo ~= nil then
		local conRankList = GetElement(self.m_root,"conRankList_CellFireworksAnn",WZUIContainer)
		local tabRankList = GetElement(conRankList,"tabRankList_CellFireworksAnn",WZUITableContainer)
		local txtRankMySelf = GetElement(self.m_root,"txtRankMySelf_CellFireworksAnn",WZUILabelTTF)
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
				if self.m_tRankInfo.type == g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT then --点球大战
					element:setAbsContentSize(GlobalMethod:CCSize(440,70))
				else
					element:setAbsContentSize(GlobalMethod:CCSize(350,70))
				end
				element:setLuaObjectIndex(self)
				element:setTag(i-1)
				tabRankList:setCellElement(element)
		    end
		else
			ShowPanelNullTip(conRankList)
		end
		
	end

	if self.m_tRankInfo.type == g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT then --点球大战
		self:_footballReward()
		return
	end

	local tempppp = {}
	for k,v in pairs(GDatatab_activity_reward) do
		table.insert(tempppp,v)
	end
	table.sort(tempppp,function (a,b)
		if a.id < b.id then
			return true
		end
		return false
	end)
	local tabRewardList = GetElement(self.m_root,"tabRewardList_CellFireworksAnn",WZUITableContainer)
	tabRewardList:cleanTable()
	
	local playerInfo = CacheCenter:getPlayerInfo()
	local temppT = GDatatab_activity_reward
	for i,v in ipairs(tempppp) do

		local conRankListReward = CreateElement("conRankListReward_CellFireworksAnn")
		conRankListReward:setTag(i-1)
		conRankListReward:setVisible(true)

		local imgBox = GetElement(conRankListReward,"imgBox_CellFireworksAnn",WZUIImage)
		local imgBox1 = GetElement(conRankListReward,"imgBox1_CellFireworksAnn",WZUIImage)
		local tempInfo = temppT["id_" ..i]
		local tData = nil
		if playerInfo.sex == 0 then --男
			tData = tempInfo.reward_boy
		else
			tData = tempInfo.reward_girl
		end
	    tData = GDatatab_item["id_"..tData[1][1]]
	    imgBox:setFile(tData.icon)
	    imgBox1:setFile(tData.icon)
		if i == 1 then
			local imgRank = GetElement(conRankListReward,"imgRank_conRankListReward",WZUIImage)
			imgRank:setFile("ui/common/common_icon_1st.png")
		elseif i == 2 then
			local imgRank = GetElement(conRankListReward,"imgRank_conRankListReward",WZUIImage)
			imgRank:setFile("ui/common/common_icon_2nd.png")
		elseif i == 3 then
			local imgRank = GetElement(conRankListReward,"imgRank_conRankListReward",WZUIImage)
			imgRank:setFile("ui/common/common_icon_3rd.png")
		else
			local txtRank = GetElement(conRankListReward,"txtRank_conRankListReward",WZUILabelTTF)
			local temp = v.rank
			txtRank:setText(temp[1][1] .. "-" .. temp[1][2] )
		end
		tabRewardList:setCellElement(conRankListReward)
	end
end

--@brief 	點球排行榜獎勵
function CellFireworksAnn:_footballReward(  )
	--GetElement(conRankListReward,"imgRewardLine_CellFireworksAnn",WZUIImage):setFile("ui/common/football_pattern_002.png")
	local tabRewardList = GetElement(self.m_root,"tabRewardList_CellFireworksAnn",WZUITableContainer)
	tabRewardList:cleanTable()
	
	local sItemFormat = [[<T C="255,227,116" P="1" S="22" SC="105,65,46" SE="1" SS="4">%s </T>]]
    
	for i=1,#self.footballReward do
		local conFootballReward = CreateElement("conFootballReward_CellFireworksAnn")
		conFootballReward:setTag(i-1)
		conFootballReward:setVisible(true)

		local tItemString = SplitStringWithSeparator(self.footballReward[i].rank, "+")
		--WZLog("--dsgaagagag---",Serialize(tItemString))
		if tItemString[1] == "1" then
			local imgRank = GetElement(conFootballReward,"imgRank_conRankListReward",WZUIImage)
			imgRank:setFile("ui/common/common_icon_1st.png")
		elseif tItemString[1] == "2" then
			local imgRank = GetElement(conFootballReward,"imgRank_conRankListReward",WZUIImage)
			imgRank:setFile("ui/common/common_icon_2nd.png")
		elseif tItemString[1] == "3" then
			local imgRank = GetElement(conFootballReward,"imgRank_conRankListReward",WZUIImage)
			imgRank:setFile("ui/common/common_icon_3rd.png")
		else
			GetElement(conFootballReward,"fxtRank_conRankListReward",WZUIFreeTextBox):setShowText(string.format(sItemFormat, tItemString[1]))
		end

		local itemList = self.footballReward[i].m_tData
		for j=1,#itemList do
			local key = "id_"..itemList[j].id
			local num = itemList[j].num
			local conItem = GetElement(conFootballReward,"con"..j.."_CellFireworksAnn",WZUIContainer)
			local celElement,tLuaObj = CellGoodItem:createElement()
        	if celElement ~= nil then 
            	celElement = WZUIContainer:luaTo(celElement)
            	local itemInfo = {id = itemList[j].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=itemList[j].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            	--WZLog("-dgag-a-----235345",Serialize(itemInfo))
            	tLuaObj:setCellGoodItem(itemInfo,4)
            	celElement:setTag(i-1)
            	celElement:setScale(0.7)
           	 	tLuaObj:setItemClickFun(self,self.onOthersClick)
           	 	conItem:addChild(celElement)
        	end
		end
		tabRewardList:setCellElement(conFootballReward)
	end
end

--@brief    其它Item点击回调
function CellFireworksAnn:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndFootballActivity.m_root,1,tData,false)
end

function CellFireworksAnn:onClickGet(element)
	WZLog("CellFireworksAnn:onClickGet =",element:getTag())
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getParent():getTag()
	local tempInfo = nil
	local tData = nil
	-- if self.m_tRankInfo.type == g_tGameActivityTypes.ACTIVITY_FIRSTRECHARGE then --点球大战
	-- 	tempInfo = self.footballReward[tag+1].id
	-- 	tData = GDatatab_item["id_" ..tempInfo]
	-- 	WndItemInfo:onCloseClick()
 --    	WndItemInfo:showInfo(element,WndFootballActivity.m_root,1,tData,false)
	-- else
		tempInfo = GDatatab_activity_reward["id_" .. tag+ 1]
		local playerInfo = CacheCenter:getPlayerInfo()
		
		if playerInfo.sex == 0 then --男
			tData = tempInfo.reward_boy
		else
			tData = tempInfo.reward_girl
		end
		tData = GDatatab_item["id_" ..tData[1][1] ]
		WndItemInfo:onCloseClick()
		WndItemInfo:showInfo(element,WndApartmentAct.m_root,1,tData,false)
	--end
end

function CellFireworksAnn:onClickBack(element)
	WZLog("CellFireworksAnn:onClickBack")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	IS_FOOTBALL_RANK = false
	local parent = self.m_root:getParent()
	local childNode = parent:getChildByTag(122)
	if childNode then
		childNode:setVisible(true)
	end
	ISFIREWORKRANK = false
	self.m_root:removeFromParentAndCleanup(true)
end

function CellFireworksAnn:onClickPlayer(element)
	WZLog("CellFireworksAnn:onClickPlayer")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local parent = element:getParent()
	local tag = parent:getTag()+1
	if self.m_tRankInfo[tag][2] then
		local playerId = self.m_tRankInfo[tag][2]
		WndCheckOther:show(playerId)
	end
end

function CellFireworksAnn:onLoadData(element)
	if element:getName() ~= "CellFireworksAnnRankList" then return end
	element:removeAllChildrenWithCleanup(true)
    local v = self.m_tRankInfo[element:getTag()+1]
	local cellNode = CreateElement("conRankListItem_CellFireworksAnn")
	cellNode:setTag(element:getTag())
	cellNode:setVisible(true)
	local conHead = GetElement(cellNode,"conHead_CellFireworksAnn",WZUIContainer)
	local headNode,headLua = CellHead:show(conHead,v[5],v[4],v[6],nil,GlobalMethod:ccp(0.52,0.3),v[8],v[9],nil,nil,0.45)
	
	local imgRank = GetElement(cellNode,"imgRank_CellFireworksAnn",WZUIImage)
	local lafTxt = GetElement(cellNode,"lafTxt_CellFireworksAnn",WZUILabelAtlasFont)
	if v[1] == 1 then
		imgRank:setFile("ui/common/common_icon_1st.png")
	elseif v[1] == 2 then
		imgRank:setFile("ui/common/common_icon_2nd.png")
	elseif v[1] == 3 then
		imgRank:setFile("ui/common/common_icon_3rd.png")
	else
		lafTxt:setText(v[1])
	end
	local txtPlayerName = GetElement(cellNode,"txtPlayerName_CellFireworksAnn",WZUILabelTTF)
	txtPlayerName:setText(v[3])

	local txtPlayerLevel = GetElement(cellNode,"txtPlayerLevel_CellFireworksAnn",WZUILabelTTF)
	txtPlayerLevel:setText("Lv"..v[7])

	local txtIntegralValue = GetElement(cellNode,"txtIntegralValue_CellFireworksAnn",WZUILabelTTF)
	txtIntegralValue:setText(v[10])

	if v[11] == 1 then
		GetElement(cellNode,"imgTag_CellFireworksAnn",WZUIImage):setVisible(true)
	end
	if self.m_tRankInfo.type == g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT then --点球大战
		local imgItemLine = GetElement(cellNode,"imgItemLine_CellFireworksAnn",WZUIImage)
		imgItemLine:setFile("ui/common/football_pattern_002.png")
		imgItemLine:setScale(1)
		conHead:setRelativePosition(GlobalMethod:ccp(-0.1,0.528571))
		imgRank:setRelativePosition(GlobalMethod:ccp(0.18,0.5))
		txtPlayerLevel:setRelativePosition(GlobalMethod:ccp(0.34,0.637647))
		txtPlayerName:setRelativePosition(GlobalMethod:ccp(0.34,0.325))
		txtIntegralValue:setRelativePosition(GlobalMethod:ccp(0.82,0.5))
		GetElement(cellNode,"imgTag_CellFireworksAnn",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.29,0.325017))
		lafTxt:setRelativePosition(GlobalMethod:ccp(0.18,0.5))
	end
	element:addChild(cellNode)		
end

function CellFireworksAnn:_adjustUIPos(  )
	WZLog("--dga-----dfasf3455---",self.m_tRankInfo.type)
	if self.m_tRankInfo ~= nil and self.m_tRankInfo.type == g_tGameActivityTypes.ACTIVITY_FOOTBALL_SHOOT then --点球大战

		local conAnn = GetElement(self.m_root,"conAnn_CellFireworkAnn",WZUIContainer)
		conAnn:setAbsContentSize(GlobalMethod:CCSize(800,400))
		conAnn:updateRelativeSize()
		conAnn:setRelativePosition(GlobalMethod:ccp(0.5,0.5))

		GetElement(self.m_root,"imgBg_CellFireworksAnn",WZUIImage):setVisible(true)
		GetElement(self.m_root,"imgLeft_CellFireworksAnn",WZUIImage):setVisible(false)
		GetElement(self.m_root,"imgRight_CellFireworksAnn",WZUIImage):setVisible(false)
		GetElement(self.m_root,"btnFireBack_CellFireworksAnn",WZUIButton):setVisible(false)

		local btnBallBack = GetElement(self.m_root,"btnBallBack_CellFireworksAnn",WZUIButton)
		btnBallBack:setVisible(true)
		btnBallBack:setRelativePosition(GlobalMethod:ccp(0.88,1.2))

		local imgLine = GetElement(self.m_root,"imgLine_CellFireworksAnn",WZUIImage)
		imgLine:setFile("ui/common/football_pattern_002.png")
		imgLine:setRotation(90)

		local conLine = GetElement(self.m_root,"conLine_CellFireworksAnn",WZUIContainer)
		conLine:setRelativePosition(GlobalMethod:ccp(0.578125,0.483871))

		GetElement(self.m_root,"txtTitle1_CellFireworksAnn",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.179206,0.44))
		GetElement(self.m_root,"txtTitle2_CellFireworksAnn",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.423783,0.44))
		GetElement(self.m_root,"txtTitle3_CellFireworksAnn",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.814822,0.44))
		GetElement(self.m_root,"txtTitle4_CellFireworksAnn",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,1.2))
		GetElement(self.m_root,"txtRankMySelf_CellFireworksAnn",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.02,1.05))

		local txtTitle5 = GetElement(self.m_root,"txtTitle5_CellFireworksAnn",WZUILabelTTF)
		txtTitle5:setRelativePosition(GlobalMethod:ccp(0.7,1.2))
		txtTitle5:setVisible(true)

		local conRankList = GetElement(self.m_root,"conRankList_CellFireworksAnn",WZUIContainer)
		conRankList:setAbsContentSize(GlobalMethod:CCSize(440,318))
		conRankList:updateRelativeSize()
		conRankList:setRelativePosition(GlobalMethod:ccp(0.03,0.04))

		local tabRewardList = GetElement(self.m_root,"tabRewardList_CellFireworksAnn",WZUITableContainer)
		tabRewardList:setAbsContentSize(GlobalMethod:CCSize(340,280))
		tabRewardList:updateRelativeSize()
		tabRewardList:setRelativePosition(GlobalMethod:ccp(0.5,0.06))
		tabRewardList:setCellElementHeight(0.26)

		local conLineH = GetElement(self.m_root,"conLineH_CellFireworksAnn",WZUIContainer)
		conLineH:setVisible(true)
		conLineH:setRelativePosition(GlobalMethod:ccp(0.5,0.88))

		local tabRankList = GetElement(self.m_root,"tabRankList_CellFireworksAnn",WZUITableContainer)
		tabRankList:setCellElementHeight(0.25)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

function CellFireworksAnn:_adaptLanguage_vn( )
	GetElement(self.m_root,"txtTitle1_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTitle2_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTitle3_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	
	local txtTitle4 = GetElement(self.m_root,"txtTitle4_CellFireworksAnn",WZUILabelTTF)
	txtTitle4:setScale(0.6)
	--txtTitle4:setRelativePosition(GlobalMethod:ccp(0.358974,0.924938))
	
	GetElement(self.m_root,"txtBack1_CellFireworksAnn",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtBack2_CellFireworksAnn",WZUILabelTTF):setScale(0.7)
end

function CellFireworksAnn:_adaptLanguage_pt( )
	GetElement(self.m_root,"txtTitle1_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTitle2_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTitle3_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	
	local txtTitle4 = GetElement(self.m_root,"txtTitle4_CellFireworksAnn",WZUILabelTTF)
	txtTitle4:setScale(0.5)
	--txtTitle4:setRelativePosition(GlobalMethod:ccp(0.346154,0.924938))
	
	GetElement(self.m_root,"txtBack1_CellFireworksAnn",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtBack2_CellFireworksAnn",WZUILabelTTF):setScale(0.6)
end

function CellFireworksAnn:_adaptLanguage_es( )
	GetElement(self.m_root,"txtTitle1_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTitle2_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTitle3_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	
	local txtTitle4 = GetElement(self.m_root,"txtTitle4_CellFireworksAnn",WZUILabelTTF)
	txtTitle4:setScale(0.6)
	txtTitle4:setDimensions(GlobalMethod:CCSize(200))
	--txtTitle4:setRelativePosition(GlobalMethod:ccp(0.346154,0.924938))
	
	GetElement(self.m_root,"txtBack1_CellFireworksAnn",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtBack2_CellFireworksAnn",WZUILabelTTF):setScale(0.6)
end

function CellFireworksAnn:_adaptLanguage_en( )
	GetElement(self.m_root,"txtTitle1_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTitle2_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtTitle3_CellFireworksAnn",WZUILabelTTF):setScale(0.8)
	
	local txtTitle4 = GetElement(self.m_root,"txtTitle4_CellFireworksAnn",WZUILabelTTF)
	txtTitle4:setScale(0.6)
	txtTitle4:setDimensions(GlobalMethod:CCSize(200))
	--txtTitle4:setRelativePosition(GlobalMethod:ccp(0.346154,0.924938))
	
	GetElement(self.m_root,"txtBack1_CellFireworksAnn",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtBack2_CellFireworksAnn",WZUILabelTTF):setScale(0.6)
end