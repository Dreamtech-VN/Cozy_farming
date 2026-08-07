--WndFlowerRankData.lua
--@brief	WndFlowerRank的数据模块
--@date		2025/04/07
--@author	yrd
--@note		鲜花榜

WndFlowerRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFlowerRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nU1RankType = 0 				--排行榜类型 0男榜 1女榜
	self.m_nU3RankType = 0 				--历届榜类型 0男榜 1女榜

	self.m_tMyRank = {}

	self.m_tU1RankData = {}				--排行榜数据列表 : 0男榜 1女榜 2总榜
	self.m_tU1RankObj = {}				--排行榜对象列表 男女榜
	self.m_tU2RankObj = {}				--排行榜对象列表 总榜

	self.m_tU3RankData = {}				--历届榜数据列表 0男榜 1女榜
	self.m_tU3RankObj = {}				--历届榜对象列表 0男榜 1女榜

	self.m_bU1First = true
	self.m_bU2First = true
	self.m_bU3First = true
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFlowerRank:_unInit()
	self.m_root = nil
	self.m_nU1RankType = nil
	self.m_nU3RankType = nil

	self.m_tMyRank = nil

	self.m_tU1RankData = nil
	self.m_tU1RankObj = nil
	self.m_tU2RankObj = nil

	self.m_tU3RankData = nil
	self.m_tU3RankObj = nil

	self.m_bU1First = nil
	self.m_bU2First = nil
	self.m_bU3First = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFlowerRank:createElement()
	if WndFlowerRank.m_root ~= nil then
		WindowManager:removeWindow(WndFlowerRank.m_root, WndFlowerRank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFlowerRank")
	assert(element, "WndFlowerRank create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFlowerRank:showInterface()
	LoadNewActivityRes(true)
	local wnd = WndFlowerRank:createElement()
	if wnd then 
		WindowManager:addWindow(wnd, WndFlowerRank, false, nil, nil, true)
	end
end

--@brief    获取总榜数据
function WndFlowerRank:GetFightingKingInfoOk(session, playerId, rank, worshipTimes, totlaWorshipTimes, fighting, name, faceId, headId, sex, level, vipLevel, headColor, bodyId, bodyColor, windId, crossServer, rewardRank, reward)
    WZLog("WndFlowerRank:GetFightingKingInfoOk")
    
	self.m_tU1RankData[0] = {} --男榜
	self.m_tU1RankData[1] = {} --女榜
	self.m_tU1RankData[2] = {} --总榜

	-- rewardRank[排名][第几个奖励][id,数量]
	-- reward[排名][性别][第几个奖励][id,数量]
	for i=1,#rewardRank do
		rewardRank[i] = SplitStringWithSeparator(rewardRank[i],"&",nil,true)
		reward[i] = SplitStringWithSeparator(reward[i],"_")
		for j=1,#reward[i] do
			reward[i][j] = SplitStringWithSeparator(reward[i][j],"&")
			for k=1,#reward[i][j] do
				reward[i][j][k] = SplitStringWithSeparator(reward[i][j][k],",",nil,true)
			end
		end
	end

	for i=1,#playerId do
		local item = {}
		item.session = session
		item.playerId = playerId[i]
		item.rank = rank[i]
		item.worshipTimes = worshipTimes[i]
		item.totlaWorshipTimes = totlaWorshipTimes[i]
		item.fighting = fighting[i]
		item.name = name[i]
		item.faceId = faceId[i]
		item.headId = headId[i]
		item.sex = sex[i]
		item.level = level[i]
		item.vipLevel = vipLevel[i]
		item.headColor = headColor[i]
		item.bodyId = bodyId[i]
		item.bodyColor = bodyColor[i]
		item.windId = windId[i]
		item.crossServer = crossServer[i]

		item.rankingType = 2

		table.insert(self.m_tU1RankData[item.rankingType], item)

		if sex[i] == 0 then
			local item2 = CopyTable(item)

			item.rankingType = 0

			table.insert(self.m_tU1RankData[item.rankingType], item2)
		elseif sex[i] == 1 then
			local item3 = CopyTable(item)

			item.rankingType = 1

			table.insert(self.m_tU1RankData[item.rankingType], item3)
		end
	end

	table.sort( self.m_tU1RankData[2], function(a, b)
		if a.fighting ~= b.fighting then
			return a.fighting > b.fighting
		else
			return a.rank < b.rank
		end
	end )
	local tempRank = 0
	for i=1,#self.m_tU1RankData[2] do
		tempRank = tempRank + 1
		self.m_tU1RankData[2][i].rank = tempRank
	end

	table.sort( self.m_tU1RankData[0], function(a, b)
		return a.fighting > b.fighting
	end )

	table.sort( self.m_tU1RankData[1], function(a, b)
		return a.fighting > b.fighting
	end )

	-- 男榜
	local nPrevRank2 = 0
	for i=1,#self.m_tU1RankData[0] do
		local item = self.m_tU1RankData[0][i]
		--排名 第一名可以并列
		if item.sex == 0 then
			nPrevRank2 = nPrevRank2 +1
		end
		item.rank = nPrevRank2

		--奖励
		local tmpReward = {}
		for j=1,#rewardRank do
			if #rewardRank[j] == 1 then
				if rewardRank[j][1] == nPrevRank2 then
					tmpReward = reward[j][1]
				end
			elseif #rewardRank[j] == 2 then
				if rewardRank[j][1] <= nPrevRank2 and rewardRank[j][2] >= nPrevRank2 then
					tmpReward = reward[j][1]
				end
			end
		end
		item.reward = tmpReward
	end

	-- 女榜
	local nPrevRank3 = 0
	for i=1,#self.m_tU1RankData[1] do
		local item = self.m_tU1RankData[1][i]
		--排名 第一名可以并列
		if item.sex == 1 then
			nPrevRank3 = nPrevRank3 +1
		end
		item.rank = nPrevRank3

		--奖励
		local tmpReward = {}
		for j=1,#rewardRank do
			if #rewardRank[j] == 1 then
				if rewardRank[j][1] == nPrevRank3 then
					tmpReward = reward[j][2]
				end
			elseif #rewardRank[j] == 2 then
				if rewardRank[j][1] <= nPrevRank3 and rewardRank[j][2] >= nPrevRank3 then
					tmpReward = reward[j][2]
				end
			end
		end
		item.reward = tmpReward
	end

	self:updateUI1()
	self:updateUI2()
end

--@brief	获取个人排行榜数据
function WndFlowerRank:GetPlayerRankOK(myRank, rankValue, rankExp, myTrendRank, rankType, canWorship)
	self.m_tMyRank = {}
	self.m_tMyRank.myRank = myRank
	self.m_tMyRank.rankValue = rankValue
	self:updateMyRank()
end

--@brief    获取历届榜数据
function WndFlowerRank:GetRankingTopListOk(rankingType, playerIds, points, nicknames, headIds, headColors, faceIds, sexs, vipLevels, levels, bodyIds, bodyColors, windIds, title, serverId, seasonNum, blueVip, sessions)
	if not self.m_root then
		return
	end

	local nType
	if rankingType == 42 then
		nType = 0
	elseif rankingType == 43 then
		nType = 1
	end
	self.m_tU3RankData[nType] = {}
	for i=1,#playerIds do
		local tData = {}
		tData.playerId = playerIds[i]
		tData.point = points[i]
		tData.nickname = nicknames[i]
		tData.headId = headIds[i]
		tData.headColor = headColors[i]
		tData.faceId = faceIds[i]
		tData.sex = sexs[i]
		tData.vipLevel = vipLevels[i]
		tData.level = levels[i]
		tData.bodyId = bodyIds[i]
		tData.bodyColor = bodyColors[i]
		tData.windId = windIds[i]
		tData.title = title[i]
		tData.serverId = serverId[i]
		tData.seasonNum = seasonNum[i]
		tData.blueVip = blueVip[i]
		tData.sessions = sessions[i]
		table.insert(self.m_tU3RankData[nType], tData)
	end

	self:updateUI3()
end

--@brief    赠送鲜花成功
function WndFlowerRank:GiveFlowerOk()
	if not self.m_root then
		return
	end

	--刷新界面
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetFightingKingInfo(6)
	ProtocolProcessorWndActivityOnLine:send_RANK_GetPlayerRank(42)
end

-------------------------------------公有方法模块End----------------------------------------


-- -------------------------------------私有方法模块Begin--------------------------------------

CellConcertedRankU1 = {}
function CellConcertedRankU1:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsLoaded = false
	self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellConcertedRankU1:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil
	self.m_tData = nil
end

--@brief	创建控件
function CellConcertedRankU1:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(698,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellConcertedRankU1:setData(data)
	self.m_tData = data
	self:updateUI()
end

--@brief 	获取数据
function CellConcertedRankU1:getData()
	return self.m_tData
end

--@brief 	开始加载
function CellConcertedRankU1:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellConcertedRankU1_WndFlowerRank")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:updateUI()
end

function CellConcertedRankU1:updateUI()
	if not self.m_bIsLoaded then
		return
	end

	local imgRank = GetElement(self.m_root,"imgRank_CellU1Rank",WZUIImage)
	local txtRank = GetElement(self.m_root,"txtRank_CellU1Rank",WZUILabelTTF)
	local tImgPath = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	if self.m_tData.rank <= 3 then
		imgRank:setFile(tImgPath[self.m_tData.rank])
		txtRank:setText("")
	else
		imgRank:setFile("")
		txtRank:setText(self.m_tData.rank)
	end

	local img9BG = GetElement(self.m_root,"img9BG_CellU1Rank",WZUI9Image)
	if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then
		img9BG:setFile("ui/common/frame_lieb_01.png")
	end

	local conHead = GetElement(self.m_root,"conHead_CellU1Rank",WZUIContainer)
	conHead:setVisible(true)
	local btnHead = GetElement(self.m_root,"btnHead_CellU1Rank",WZUIButton)
	btnHead:setTag(self.m_tData.playerId)

	local headAnim, headObj = CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, false, nil, nil, self.m_tData.headColor)

	local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellU1Rank",WZUILabelTTF)
	txtPlayerName:setText(self.m_tData.name)

	local strFormat = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%s</T>]]
	local ftbLevel = GetElement(self.m_root,"ftbLevel_CellU1Rank",WZUIFreeTextBox)
	ftbLevel:setShowText(string.format(strFormat, LocalStrings.LV, self.m_tData.level))

	local txtScore = GetElement(self.m_root,"txtScore_CellU1Rank",WZUILabelTTF)
	txtScore:setText(self.m_tData.fighting)

	local conRewards = GetElement(self.m_root,"conRewards_CellU1Rank",WZUIContainer)
	conRewards:removeAllChildrenWithCleanup(true)
	for i=1,#self.m_tData.reward do
		local celElement,tLuaObj = CellGoodItem:createElement()
		tLuaObj:setCellGoodLocalId(self.m_tData.reward[i][1], self.m_tData.reward[i][2], 17)
		tLuaObj:setItemClickFun(WndFlowerRank, self.onClickItem)
		celElement:setScale(0.9)
		celElement:setRelativePosition(GlobalMethod:ccp(0.125+(i-1)*0.25,0.5))
		conRewards:addChild(celElement)
	end
end

--@brief	点击玩家头像
function CellConcertedRankU1:onClickU1Head(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tag = element:getTag()
	ProtocolProcessorWndBag:regAll1()
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(tag)
end

--@brief	点击物品弹出对应的tips
function CellConcertedRankU1:onClickItem(tCell,tag,tData)
	if tData == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief	点击送鲜花
function CellConcertedRankU1:onClickU1Give(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then
		return
	end

	WndSpaceSendFlower:showInterface(1, self.m_tData.playerId)
end

--@return	新建的表实例对象
function CellConcertedRankU1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-- -------------------------------------分割线----------------------------------------

CellConcertedRankU2 = {}
function CellConcertedRankU2:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsLoaded = false
	self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellConcertedRankU2:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil
	self.m_tData = nil
end

--@brief	创建控件
function CellConcertedRankU2:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(648,82))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellConcertedRankU2:setData(data)
	self.m_tData = data
	self:updateUI()
end

--@brief 	获取数据
function CellConcertedRankU2:getData()
	return self.m_tData
end

--@brief 	开始加载
function CellConcertedRankU2:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellConcertedRankU2_WndFlowerRank")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:updateUI()
end

function CellConcertedRankU2:updateUI()
	if not self.m_bIsLoaded then
		return
	end

	local imgRank = GetElement(self.m_root,"imgRank_CellU2Rank",WZUIImage)
	local txtRank = GetElement(self.m_root,"txtRank_CellU2Rank",WZUILabelTTF)
	local tImgPath = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
	if self.m_tData.rank <= 3 then
		imgRank:setFile(tImgPath[self.m_tData.rank])
		txtRank:setText("")
	else
		imgRank:setFile("")
		txtRank:setText(self.m_tData.rank)
	end

	local img9BG = GetElement(self.m_root,"img9BG_CellU2Rank",WZUI9Image)
	if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then
		img9BG:setFile("ui/common/frame_lieb_01.png")
	end

	local conHead = GetElement(self.m_root,"conHead_CellU2Rank",WZUIContainer)
	conHead:setVisible(true)
	local btnHead = GetElement(self.m_root,"btnHead_CellU2Rank",WZUIButton)
	btnHead:setTag(self.m_tData.playerId)

	local headAnim, headObj = CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, false, nil, nil, self.m_tData.headColor)

	local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellU2Rank",WZUILabelTTF)
	txtPlayerName:setText(self.m_tData.name)

	local strFormat = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%s</T>]]
	local ftbLevel = GetElement(self.m_root,"ftbLevel_CellU2Rank",WZUIFreeTextBox)
	ftbLevel:setShowText(string.format(strFormat, LocalStrings.LV, self.m_tData.level))

	local txtScore = GetElement(self.m_root,"txtScore_CellU2Rank",WZUILabelTTF)
	txtScore:setText(self.m_tData.fighting)
end

--@brief	点击玩家头像
function CellConcertedRankU2:onClickU1Head(element)
	local tag = element:getTag()

	ProtocolProcessorWndBag:regAll1()
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(tag)
end

--@brief	点击物品弹出对应的tips
function CellConcertedRankU2:onClickItem(tCell,tag,tData)
	if tData == nil then
		return
	end
	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end

--@brief	点击送鲜花
function CellConcertedRankU2:onClickU2Give(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tData.playerId == CacheCenter:getPlayerInfo().id then
		return
	end

	WndSpaceSendFlower:showInterface(1, self.m_tData.playerId)
end

--@return	新建的表实例对象
function CellConcertedRankU2:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-- -------------------------------------分割线----------------------------------------

CellConcertedRankU3 = {}
function CellConcertedRankU3:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_bIsLoaded = false
	self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellConcertedRankU3:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil
	self.m_tData = nil
end

--@brief	创建控件
function CellConcertedRankU3:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(246,426))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellConcertedRankU3:setData(data)
	self.m_tData = data
	self:updateUI()
end

--@brief 	获取数据
function CellConcertedRankU3:getData()
	return self.m_tData
end

--@brief 	开始加载
function CellConcertedRankU3:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellConcertedRankU3_WndFlowerRank")
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:updateUI()
end

function CellConcertedRankU3:updateUI()
	if not self.m_bIsLoaded then
		return
	end

	local txtSession = GetElement(self.m_root,"txtSession_CellU3Rank",WZUILabelTTF)
	txtSession:setText(string.format(LocalStrings.COMMONITY_DESC11, self.m_tData.seasonNum))

	local txtPName = GetElement(self.m_root,"txtPName_CellU3Rank",WZUILabelTTF)
	txtPName:setText(self.m_tData.nickname)

	local conPAni = GetElement(self.m_root,"conPAni_CellU3Rank",WZUIContainer)
	conPAni:removeAllChildrenWithCleanup(true)
	local sex = self.m_tData.sex
	local headId = self.m_tData.headId
	local faceId = self.m_tData.faceId
	local bodyId = self.m_tData.bodyId
	local wingId = self.m_tData.windId
	local headColor = self.m_tData.headColor
	local bodyColor = self.m_tData.bodyColor
	local tPortrayal = {headId, faceId, bodyId, wingId}
	local conPlayer = CreatePlayerFigure(sex,tPortrayal,nil,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor)
	conPlayer:setFlipX(false)
	local animNode = conPlayer:getAnimNode()
	animNode:setTouchEnable(false)
	animNode:setTag(50)
	animNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	animNode:setRelativePosition(GlobalMethod:ccp(0.5,-0.02))
	conPAni:addChild(animNode)

	local strFormat = [[<T C="255,236,193" S="18" P="0" SC="132,66,29" SE="1" SS="4">%s</T><T C="255,227,116" S="18" P="0" SC="132,66,29" SE="1" SS="4">%s</T>]]
	local ftbScore = GetElement(self.m_root,"ftbScore_CellU3Rank",WZUIFreeTextBox)
	ftbScore:setShowText(string.format(strFormat, LocalStrings.FLOWER_RANK_TEXT1[8], self.m_tData.point))

	local title = self.m_tData.title
	local conPTitle = GetElement(self.m_root,"conPTitle_CellU3Rank",WZUIContainer)
	conPTitle:removeChildByTag(60,true)
	local txtPTitle = GetElement(self.m_root,"txtPTitle_CellU3Rank",WZUILabelTTF)
	txtPTitle:setText("")
	CreateDesiSpine(conPTitle, txtPTitle, title, GlobalMethod:ccp(0.5,1.3))
end

--@brief	点击历届榜查看
function CellConcertedRankU3:onClickU3CheckRole(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not self.m_tData then return end

	ProtocolProcessorWndBag:regAll1()
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_tData.playerId)
end


--@return	新建的表实例对象
function CellConcertedRankU3:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-- -------------------------------------私有方法模块End----------------------------------------