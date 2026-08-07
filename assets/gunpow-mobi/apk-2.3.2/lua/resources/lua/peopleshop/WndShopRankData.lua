--WndShopRankData.lua
--@brief	WndShopRank的数据模块
--@date		2020/09/28
--@author	hyx
--@note		购物界面的达人榜

WndShopRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndShopRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nRankType = nil
	self.m_tTeamData = nil 				--射箭队伍信息
	self.m_tInvestData = nil --投资排行数据
	self.m_tSingleArrowList = nil 		--单人射箭榜
	self.m_tTeamArrowList = nil 		--组队射箭榜
	self.m_nTabIndex = 1 				--选中的标签 (射箭榜1单人榜，2组队榜)(组队参赛1邀请列表，2邀请通知)
	self.m_tTeamReward = nil 			--组队射箭奖励数据
	self.m_tSelFriends = nil 			--选中的好友Id
	self.m_tNoteList = nil 
	self.m_tCellClick = nil 
	self.m_tCellData = nil 
	self.m_sSettlementDate = nil 
	self.m_tDefaultType = nil 
	self.m_tOtherData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndShopRank:_unInit()
	self.m_root = nil
	self.m_nRankType = nil
	self.m_tTeamData = nil 				--射箭队伍信息
	self.m_tInvestData = nil
	self.m_tSingleArrowList = nil 		--单人射箭榜
	self.m_tTeamArrowList = nil 		--组队射箭榜
	self.m_nTabIndex = nil 				--选中的标签
	self.m_tTeamReward = nil 			--组队射箭奖励数据
	self.m_tSelFriends = nil 			--选中的好友Id
	self.m_tNoteList = nil 
	self.m_tCellClick = nil 
	self.m_tCellData = nil 
	self.m_sSettlementDate = nil 
	self.m_tDefaultType = nil 
	self.m_tOtherData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndShopRank:createElement(_type, activityId, activityType)
	if WndShopRank.m_root ~= nil then
		WindowManager:removeWindow(WndShopRank.m_root, WndShopRank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndShopRank")
	assert(element, "WndShopRank create element failed!")
	self:_init()
	--默认是全民购物季的排行榜 1:藏宝图 2:元旦求签 3:新年活动的祈福排行榜 4:盲盒 5:娃娃机 6:占星 7:钓鱼 10:射箭活动队伍信息 11:射箭榜 12 射箭组队邀请 13:水之国度榜 14：张灯结彩榜 15:年兽勇士榜 16:愿望榜 17:暴揍策划榜 18:丹道修真榜 19:欢乐地鼠榜 20:房产排行榜 21:套圈圈榜 22：小岛果园榜 23:咖啡大师 24:保龄球 25:年度玩家 26:度假村 27:夏日西瓜 28:秘境闯塔榜 29:摇钱树榜 30:台无止境榜 31:疯狂扭蛋榜 32:深夜食堂榜 33:全垒打榜 34:修仙传奇榜 35:修仙-飞升仙界榜 36:修仙-最强宗门 37:拜财神 38:度假村-订单大亨 39:葫芦娃榜 40:春游踏青榜 41:打气球榜 42:航海之路榜 43：攀爬榜 44:夏日冲浪榜 45:行星探索榜 46:欢乐蹦床榜 47高尔夫赛事 48许愿瓶 49贝克侦探所 50:锣鼓先天榜 51黄金矿工 52深海寻宝 53粽有不同打Call榜 54奕仙棋 55热血篮球榜 56秋日露营 57放风筝 58投壺 59捕鱼大王 60自行车赛 61抽陀螺 62踢毽子 63踢毽子 64魔法课堂 65堆雪人 66钢琴演奏家 67陶艺工坊 68举重比赛 69极地探险 70拼装积木 71拼装积木 72铸剑神匠 73铸剑神匠 74泛舟游湖 75吹泡泡 90通用榜(通过传递参数实现)
	self.m_nRankType = _type or nil 
	self.m_nActivityId = tonumber(activityId) or nil
	self.m_nActivityType = activityType or nil
	return element
end

--@brief 	外部接口
--param 	otherData: {} 其他配置数据
--[[
			rankBg:背景素材
			titleBg:顶部栏背景素材
			imgBtnClose:关闭按钮素材
			countLabelColor：显示玩家数两提示语颜色
			myRankColor：我的排名颜色
			myScoreColor：我的积分颜色
			scoreTitleColor：我的积分文字颜色
			rankTitleColor：我的排名文字颜色
			strRankTitleName：标题
			strCountLabel：显示排名数量
			strChangeTitle：顶部第三个文字内容
			strScoreTitle：我的积分相应内容
			bConGroupVisible：是否显示两个标签true/false
			tTabStrList：标签内容{}
			type:1普通排行榜；需要其他自己加
			itemImg9Bg:每个小格子颜色
]]
function WndShopRank:showInterface(_type, activityId, activityType, nTabIndex, otherData)
	-- body
	local wndRank = WndShopRank:createElement(_type, activityId, activityType)
	if wndRank then 
		if nTabIndex then 
			self.m_nTabIndex = nTabIndex
		end
		if otherData then 
			self.m_tOtherData = otherData
		end
		WindowManager:addWindow(wndRank, WndShopRank, nil, false, nil, true)
	end
end

--排行榜数据
function WndShopRank:setRankData(data, playerId, level, point, nickname, faceId, headId, headColor, sex, bodyIds, windIds, title, vipLevel, nRankType, rankingType, serverId, headEffectId, qqHallInfo)
	if not data then
		return {}, -1
	end
	local table_insert = table.insert
	local temp = nil
	if nRankType == 38 then 
		local nPeriods = WndHVFlowerOrder:getPeriods()
		temp = {}
		for i, value in pairs(GDatatab_holiday_order_reward) do
			if value.season == nPeriods then
				local tItem = {}
				tItem.rank1 = value.rank[1][1]
				tItem.rank2 = value.rank[1][2]
				tItem.ids = {}
				tItem.nums = {}
				for j = 1, #value.reward do
					table.insert(tItem.ids, value.reward[j][1])
					table.insert(tItem.nums, value.reward[j][2])
				end

				table.insert(temp, tItem)
			end
		end
	else
		temp = analyzeActivityReward(data)
	end
	local index, myCurRank, myPoint = 1, -1, 0
	local tData, ids, nums = {}, {}, {}
	local my_id = CacheCenter:getPlayerInfo().id
	if nRankType == 36 or nRankType == 63 or nRankType == 71 or nRankType == 73 then
		my_id = CacheCenter:getPlayerInfo().guildId and CacheCenter:getPlayerInfo().guildId or 0
	end
	local nCount = #playerId
	if nRankType and (nRankType == 11 or nRankType == 20 or nRankType == 19 or nRankType == 32 or nRankType == 36 or nRankType == 63 or nRankType == 71 or nRankType == 73) then
		if (nRankType == 20 or nRankType == 19) and rankingType == 1 then
			self.m_tInvestData = CopyTable(temp)
		elseif nRankType == 36 or nRankType == 63 or nRankType == 71 or nRankType == 73 then 
			self.m_tTeamReward = CopyTable(temp)
		elseif rankingType and rankingType == 2 then 
			nCount = nCount/2
			self.m_tTeamReward = CopyTable(temp)
		end
	end
	local rankDataIndex = 0 
	local nRankIndex = 0
	local nCurScore = 0 
	for i = 1, nCount do
		local nIndex = i
		if nRankType and (nRankType == 11 or nRankType == 20 or nRankType == 32) and rankingType and rankingType == 2 then 
			nIndex = (i - 1)*2 + 1
			myPoint = point[i]
		end
		rankDataIndex = i
		if my_id == playerId[nIndex] then
			myCurRank = nIndex
		end
		if ProjConfig.LANGUAGE == "vn" then 
			if nRankType and nRankType <= 2 then 
				if nRankIndex == 0 and nCurScore ~= point[nIndex] then 
					nRankIndex = nRankIndex + 1
					nCurScore = point[nIndex]
				elseif nCurScore ~= point[nIndex] then 
					nRankIndex = nRankIndex + 1
				end
				if my_id == playerId[nIndex] then
					myCurRank = nRankIndex
				end
			else
				nRankIndex = nIndex
			end
		else
			if nRankType and nRankType > 2 then 
				if nRankIndex == 0 and nCurScore ~= point[nIndex] then 
					nRankIndex = nRankIndex + 1
					nCurScore = point[nIndex]
				elseif nCurScore ~= point[nIndex] then 
					nRankIndex = nRankIndex + 1
				end
				if my_id == playerId[nIndex] then
					myCurRank = nRankIndex
				end
			else
				nRankIndex = nIndex
			end
		end

		local tab = {}
		tab.rank_index = nRankIndex
		tab.playerId = playerId[nIndex]
		tab.level = level[nIndex]
		tab.point = point[nIndex]
		tab.name = nickname[nIndex]
		tab.faceId = faceId[nIndex]
		tab.headId = headId[nIndex]
		tab.headColor = headColor[nIndex]
		tab.sex = sex[i]
		if bodyIds then
			tab.bodyId = bodyIds[nIndex]
		end
		if windIds then
			tab.windId = windIds[nIndex]
		end
		if title then
			tab.title = title[nIndex]
		end
		if vipLevel then 
			tab.vipLevel = vipLevel[nIndex]
		end
		if serverId then 
			tab.serverId = serverId[nIndex]
		end
		if headEffectId then 
			tab.headEffectId = headEffectId[nIndex]
		end
		if qqHallInfo and qqHallInfo[nIndex] ~= "" then 
			tab.qqHallData = json.decode(qqHallInfo[nIndex])
		end
		--玩家2数据
		if nRankType and (nRankType == 11 or nRankType == 20 or nRankType == 32) and rankingType and rankingType == 2 then 
			nIndex = nIndex + 1
			tab.playerId2 = playerId[nIndex]
			tab.level2 = level[nIndex]
			tab.point2 = point[nIndex]
			tab.name2 = nickname[nIndex]
			tab.faceId2 = faceId[nIndex]
			tab.headId2 = headId[nIndex]
			tab.headColor2 = headColor[nIndex]
			tab.sex2 = sex[nIndex]
			if bodyIds then
				tab.bodyId2 = bodyIds[nIndex]
			end
			if windIds then
				tab.windId2 = windIds[nIndex]
			end
			if vipLevel then 
				tab.vipLevel2 = vipLevel[nIndex]
			end
			if serverId then 
				tab.serverId2 = serverId[nIndex]
			end
			if my_id == playerId[nIndex] then
				myCurRank = nRankIndex
			end
		end

		ids,nums = {},{}
		if nRankType and nRankType > 2 then 
			for k = 1, #temp do
				if temp[k] and tab.rank_index >= tonumber(temp[k].rank1) and tab.rank_index <= tonumber(temp[k].rank2) then
					index = k
				end
			end
		else
			for k = 1, #temp do
				if temp[k] and rankDataIndex >= tonumber(temp[k].rank1) and rankDataIndex <= tonumber(temp[k].rank2) then
					index = k
				end
			end
		end
		if temp[index] then
			ids = temp[index].ids
			nums = temp[index].nums
		end
		tab.reward_id = ids
		tab.reward_num = nums
		tData[rankDataIndex] = tab
	end
	return tData, myCurRank, myPoint
end

--@brief 	获取射箭组队邀请数据
--@param 	1:邀请好友组队射箭; 2:获取邀请组队通知; 3:发出邀请; 4:同意邀请; 5:拒绝邀请
function WndShopRank:_onGetArrowResult(activityId, doType, result, msg)
	msg = json.decode(msg)
	WZLog("WndShopRank:_onGetArrowResult", doType, Serialize(msg))
	if msg then
		if doType == 1 then --邀请好友组队射箭
			self:setArrowTeamInviteData(msg)
		elseif doType >= 2 and doType <= 5 then --获取邀请组队通知
			if result == 1 then 
				if doType == 3 then 
					self.m_tSelFriends = {}
					MsgBoxManager:showTipBox(LocalStrings.BOSSROOM_INVITATION_HAS_BEEN_SENT)
				elseif doType == 4 then 
					MsgBoxManager:showTipBox(LocalStrings.SHOOTARROW_TEXT26)
				elseif doType == 5 then 
					MsgBoxManager:showTipBox(LocalStrings.SHOOTARROW_TEXT27)
				end
			elseif result == 2 then 
				if doType == 4 then 
					MsgBoxManager:showTipBox(LocalStrings.SHOOTARROW_TEXT28)
				end
			elseif result == 3 then 
				if doType == 4 then 
					MsgBoxManager:showTipBox(LocalStrings.FRIENDS_BESTFRIEND12)
				end
			elseif result == 5 then 
				if doType == 4 then 
					MsgBoxManager:showTipBox(LocalStrings.SHOOTARROW_TEXT25)
				end
			end
			self:setArrowTeamInviteNote(msg, doType)
		end
	end
end

--@brief 	度假村-订单大亨数据
function WndShopRank:setOrderRankData(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, 
								   headColors, faceIds, sexs, vipLevel, level, bodyIds, wingIds, title, serverId, session, settlementDate, headEffectId, qqHallInfo)
	self:setRankListData(activityId,myPoint,rewardConfig,playerIds,level,points,nickname,faceIds,headIds, headColors, sexs, title, vipLevel, rankingType, 
		myRanking, serverId, session, settlementDate, headEffectId, qqHallInfo)
end

--************** 排行榜item *******************
CellShopRankItem = {}
function CellShopRankItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sShopRankData = {}
	self.index = 0
	self.m_bIsLoaded = false 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellShopRankItem:_unInit()
	self.m_root = nil
	self.m_sShopRankData = nil
	self.index = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
function CellShopRankItem:createElement(rankType, nTabIndex, nAddNum)
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	if rankType and (rankType == 12 or rankType == 29) then 
		element:setAbsContentSize(GlobalMethod:CCSize(822, 92))
	elseif (rankType == 46 or rankType == 54) and nTabIndex and nTabIndex == 2 then 
		element:setAbsContentSize(GlobalMethod:CCSize(822, 96 + nAddNum * 26))
	elseif (rankType == 47 or rankType == 51 or rankType == 71 or rankType == 73) and nTabIndex and nTabIndex == 2 then 
		element:setAbsContentSize(GlobalMethod:CCSize(822, 96))
	else
		element:setAbsContentSize(GlobalMethod:CCSize(822, 82))
	end
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellShopRankItem:setShopRankMessage(index, data, _type, otherData)
	self.index = index
	self.m_sShopRankData = data
	self.m_nRankType = _type or 1
	self.m_tOtherData = otherData
end
--@brief 	开始加载
function CellShopRankItem:onLoadData(element)
	local strName = self.m_nRankType == 12 and "inviteShootItem" or "shopRankItem"
	if WndShopRank.m_nTabIndex == 2 then
		if self.m_nRankType == 46 or self.m_nRankType == 54 then
			strName = "shopRankMasterItem"
		elseif self.m_nRankType == 71 or self.m_nRankType == 73 then
			strName = "shopRankCoupleItem"
		end
	end
	local celElement = WZUISystem:getInstance():createElement(strName)
	celElement:setVisible(true)
	element:addChild(celElement)
	self.m_bIsLoaded = true 

	self:setShopRankItemData()
end

--@brief 	点击点赞按钮回调
function CellShopRankItem:onClickGood(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_sShopRankData.playerId == CacheCenter:getPlayerInfo().id then 
		MsgBoxManager:showTipBox(LocalStrings.CHARM_LIFT29)
		return 
	end

	WndShopRank:onClickGoodCallBack(self, self.m_sShopRankData)
end

function CellShopRankItem:setShopRankItemData()
	if not self.m_sShopRankData then return end

	if self.m_nRankType ~= 12 then 
		local img_rank = GetElement(self.m_root, "img_rank", WZUIImage)
		img_rank:setVisible(false)
		local txt_rank = GetElement(self.m_root,"txt_rank",WZUILabelTTF)
		local rank_name = {"ui/common/common_icon_1st_1.png","ui/common/common_icon_2nd_1.png","ui/common/common_icon_3rd_1.png"}
		txt_rank:setVisible(false)
		if self.m_nRankType and self.m_nRankType > 2 then 
			WZLog("dlkjaslfkdaslk", Serialize(self.m_sShopRankData))
			local nIndex = self.m_sShopRankData.rank_index or self.index
			if nIndex <= 3 and self.m_nRankType ~= 10 then
				img_rank:setVisible(true)
				img_rank:setFile(rank_name[nIndex])
			else
				txt_rank:setVisible(true)
				txt_rank:setText(tostring(nIndex))
			end
		else
			if self.index <= 3 and self.m_nRankType ~= 10 then
				img_rank:setVisible(true)
				img_rank:setFile(rank_name[self.index])
			else
				txt_rank:setVisible(true)
				txt_rank:setText(tostring(self.index))
			end
		end

		local rankItemImg = GetElement(self.m_root,"rankItemImg",WZUI9Image)
		if self.m_nRankType == 4 or self.m_nRankType == 5 or self.m_nRankType == 24 or self.m_nRankType == 25 or self.m_nRankType == 31 or self.m_nRankType == 55 then
			rankItemImg:setFile("ui/common/frame_lieb_03.png")
		elseif self.m_nRankType == 64 or self.m_nRankType == 65 or self.m_nRankType == 68 or self.m_nRankType == 69 or self.m_nRankType == 75 then
			rankItemImg:setFile("ui/common/frame_lieb_10.png")
		elseif self.m_tOtherData and self.m_tOtherData.itemImg9Bg then
			rankItemImg:setFile(self.m_tOtherData.itemImg9Bg)
		end
		if self.m_sShopRankData.playerId == tonumber(CacheCenter:getPlayerInfo().id) then
			rankItemImg:setFile("ui/common/frame_lieb_01.png")
		end
		local txt_rankScore = GetElement(self.m_root,"txt_rankScore",WZUILabelTTF)
		txt_rankScore:setText(self.m_sShopRankData.point)
	end
	if self.m_nRankType == 71 or self.m_nRankType == 73 then
		local tCoupleInfo = json.decode(self.m_sShopRankData.title)
		for i=1,2 do
			local conHead = GetElement(self.m_root,"conHead"..i,WZUIContainer)
			conHead:setVisible(true)
			CellHead:show(conHead, tCoupleInfo.headIds[i], tCoupleInfo.faceIds[i], tCoupleInfo.sexs[i], false, nil, tCoupleInfo.vipLevels[i], tCoupleInfo.headColors[i])
		end
		local strNameFormat = [[<T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">&</T><T C="127,70,26" S="20" P="1">%s</T>]]
		GetElement(self.m_root,"ftbName",WZUIFreeTextBox):setShowText(string.format(strNameFormat, tCoupleInfo.names[1], tCoupleInfo.names[2]))
		local nScore = tCoupleInfo.scores[1] + tCoupleInfo.scores[2]
		GetElement(self.m_root,"txt_rankScore",WZUILabelTTF):setText(nScore)
	else
		GetElement(self.m_root,"txt_name",WZUILabelTTF):setText(self.m_sShopRankData.name)
		GetElement(self.m_root,"txt_lv",WZUILabelTTF):setText(self.m_sShopRankData.level)
		if self.m_sShopRankData.serverId and self.m_sShopRankData.serverId ~= CacheCenter:getPlayerInfo().serverId then
			GetElement(self.m_root, "imgKuafu_inviteShootItem", WZUIImage):setVisible(true)
		end


		local head_contianer = GetElement(self.m_root,"head_contianer",WZUIContainer)
		if self.m_nRankType ~= 36 and self.m_nRankType ~= 46 and self.m_nRankType ~= 47 and self.m_nRankType ~= 51 and self.m_nRankType ~= 54 and self.m_nRankType ~= 63 and self.m_nRankType ~= 71 and self.m_nRankType ~= 73 then 
			CellHead:show(head_contianer, self.m_sShopRankData.headId, self.m_sShopRankData.faceId, self.m_sShopRankData.sex, false, nil, self.m_sShopRankData.vipLevel, self.m_sShopRankData.headColor)
		elseif (self.m_nRankType == 46 or self.m_nRankType == 47 or self.m_nRankType == 51 or self.m_nRankType == 54) and WndShopRank.m_nTabIndex == 1 then 
			CellHead:show(head_contianer, self.m_sShopRankData.headId, self.m_sShopRankData.faceId, self.m_sShopRankData.sex, false, nil, self.m_sShopRankData.vipLevel, self.m_sShopRankData.headColor)
		elseif (self.m_nRankType == 46 or self.m_nRankType == 54) and WndShopRank.m_nTabIndex == 2 then 
			GetElement(self.m_root,"txt_lv",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"txt_name",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"txtLevelWords_CellShopRankItem",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"txt_Id_shopRankItem",WZUILabelTTF):setVisible(false)
			local conForName = GetElement(self.m_root, "conForName_shopRankItem", WZUIContainer)
			local tPlayerInfo = json.decode(self.m_sShopRankData.title)
			local strNameFormat = [[<T C="127,70,26" S="20" P="1">%s(</T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1">)</T>]]
			local strKuafuFormat = [[<I Z="1" P="1">ui/common/common_icon_kuafu.png</I>]]
			local nNameCount = #tPlayerInfo.playerIds
			if nNameCount > 3 then 
				local nAddNum = nNameCount - 3
				local conBg = GetElement(self.m_root, "conBg_shopRankItem", WZUIContainer)
				conBg:setAbsContentSize(GlobalMethod:CCSize(822, 96 + nAddNum * 26))
				conBg:updateRelativeSize()
			end
			local nPaddingY = 0.26
			local nStartY = 0.5 + (nNameCount - 1) * nPaddingY/2
			local nStartX = 0.2
			for i = 1, nNameCount do
				local desc = ""
				if tPlayerInfo.types[i] == 0 then 
					desc = string.format(strNameFormat, tPlayerInfo.names[i], LocalStrings.MASTER)
				else
					desc = string.format(strNameFormat, tPlayerInfo.names[i], LocalStrings.APPRENTICE)
				end
				if tPlayerInfo.serverIds[i] and tPlayerInfo.serverIds[i] ~= CacheCenter:getPlayerInfo().serverId then 
					desc = strKuafuFormat .. desc 
				end
			--	WZLog("LLLLLLLLLLLLL", i, nStartY, nStartY - (i - 1) * nPaddingY)
				local ftxtName = createFreeTextBox(desc, GlobalMethod:ccp(nStartX, nStartY - (i - 1) * nPaddingY), GlobalMethod:ccp(0, 0.5))
				conForName:addChild(ftxtName)
			end
		elseif (self.m_nRankType == 47 or self.m_nRankType == 51) and WndShopRank.m_nTabIndex == 2 then 
			local conBg = GetElement(self.m_root, "conBg_shopRankItem", WZUIContainer)
			conBg:setAbsContentSize(GlobalMethod:CCSize(822, 96))
			conBg:updateRelativeSize()
			head_contianer:setVisible(false)
			GetElement(self.m_root,"txt_lv",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"txt_name",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"txtLevelWords_CellShopRankItem",WZUILabelTTF):setVisible(false)
			GetElement(self.m_root,"txt_Id_shopRankItem",WZUILabelTTF):setVisible(false)
			local tPlayerInfo = json.decode(self.m_sShopRankData.title)
			local strNameFormat = [[<T C="127,70,26" S="20" P="1">%s</T>]]
			local strKuafuFormat = [[<I Z="1" P="1">ui/common/common_icon_kuafu.png</I>]]
			local nNameCount = #tPlayerInfo.playerIds
			local nPaddingY = 0.26
			local nStartY = 0.5 + (nNameCount - 1) * nPaddingY/2
			local nStartX = 0.18
			for i = 1, nNameCount do
				local desc = string.format(strNameFormat, tPlayerInfo.names[i])
				if tPlayerInfo.serverIds[i] and tPlayerInfo.serverIds[i] ~= CacheCenter:getPlayerInfo().serverId then 
					desc = strKuafuFormat .. desc 
				end
				local ftxtName = createFreeTextBox(desc, GlobalMethod:ccp(nStartX, nStartY - (i - 1) * nPaddingY), GlobalMethod:ccp(0, 0.5))
				self.m_root:addChild(ftxtName)
			end
		else
			GetElement(self.m_root, "imgKuafu_inviteShootItem", WZUIImage):setVisible(false)
			head_contianer:setVisible(false)
			GetElement(self.m_root, "txtLevelWords_CellShopRankItem", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.42,0.282))
			GetElement(self.m_root, "txt_name", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.42,0.636))
			GetElement(self.m_root, "txt_lv", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.462,0.282))
			GetElement(self.m_root, "txt_Id_shopRankItem", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.282))
			GetElement(self.m_root, "txt_Id_shopRankItem", WZUILabelTTF):setText("ID:" .. self.m_sShopRankData.playerId)
		end
		local reward_container = GetElement(self.m_root,"reward_container",WZUIContainer)
		if self.m_sShopRankData.reward_id then
			for i, v in ipairs(self.m_sShopRankData.reward_id) do
				local key = "id_"..v
				if GDatatab_item[key] then
				    local name = GDatatab_item[key].name
				    local path = GDatatab_item[key].icon
				    local quality = GDatatab_item[key].quality
				    local num = self.m_sShopRankData.reward_num[i]
					local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
				    local celElement,tLuaObj = CellGoodItem:createElement()
				    tLuaObj:setCellGoodItem(itemInfo, 17)
				    celElement:setScale(0.8)
					reward_container:addChild(celElement)
					if self.m_nRankType == 29 then 
						tLuaObj:setItemClickFun(WndMoneyTree,WndMoneyTree.onClickItem)
					else
						tLuaObj:setItemClickFun(WndShopRank,self.onShopRankRewardItemClick)
					end

					celElement:setUseAbsCoordinate(true)
					celElement:setAbsPosition(GlobalMethod:ccp(260-(i-1)*70,40))
				end
			end
		end
		--组队另一个玩家信息
		if self.m_nRankType == 10 then 
			local txt_rankScore = GetElement(self.m_root,"txt_rankScore",WZUILabelTTF)
			txt_rankScore:setRelativePosition(GlobalMethod:ccp(0.83, 0.5))
			self:showOtherPlayerInfo()
		elseif (self.m_nRankType == 11 or self.m_nRankType == 20 or self.m_nRankType == 32) and self.m_sShopRankData.playerId2 then 
			local txt_rankScore = GetElement(self.m_root,"txt_rankScore",WZUILabelTTF)
			txt_rankScore:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			reward_container:setVisible(false)
			self:showOtherPlayerInfo()
		elseif self.m_nRankType == 12 then 
			self:showSpecifyInfo()
		elseif self.m_nRankType == 26 then 
			self:showAchieAndGoodNum()
		elseif self.m_nRankType == 36 or self.m_nRankType == 63 or self.m_nRankType == 71 or self.m_nRankType == 73 then 
			local txt_rankScore = GetElement(self.m_root,"txt_rankScore",WZUILabelTTF)
			txt_rankScore:setRelativePosition(GlobalMethod:ccp(0.88, 0.5))
			reward_container:setVisible(false)
		end
	end
end
function CellShopRankItem:onClickShopRankHead(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if not self.m_sShopRankData then return end
	if (self.m_nRankType == 46 or self.m_nRankType == 47 or self.m_nRankType == 51 or self.m_nRankType == 54) and WndShopRank.m_nTabIndex == 2 then return end 
	
	local nTag = element:getTag()

	if self.m_nRankType == 71 or self.m_nRankType == 73 then
		local tCoupleInfo = json.decode(self.m_sShopRankData.title)
		WndCheckOther:show(tCoupleInfo.playerIds[nTag])
		return
	end

	if nTag == 2 and self.m_sShopRankData.playerId2 then 
		WndCheckOther:show(self.m_sShopRankData.playerId2)
		return 
	end

	WndCheckOther:show(self.m_sShopRankData.playerId)
end
--@brief	点击物品弹出对应的tips
function CellShopRankItem:onShopRankRewardItemClick(tCell,tag,tData)
   if tData == nil then
      return
   end
   WndItemInfo:onCloseClick()
   WndItemInfo:showInfo(tCell.m_root,WndShopRank.m_root,1,tData,false,nil,true)
end

--@return	新建的表实例对象
function CellShopRankItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief 显示另一个玩家的信息
function CellShopRankItem:showOtherPlayerInfo()
	-- body
	GetElement(self.m_root, "conPlayerInfo2_WndShopRank", WZUIContainer):setVisible(true)
	GetElement(self.m_root,"txt_name2_WndShopRank",WZUILabelTTF):setText(self.m_sShopRankData.name2)
	GetElement(self.m_root,"txt_lv2_WndShopRank",WZUILabelTTF):setText(self.m_sShopRankData.level2)
	if self.m_sShopRankData.serverId2 and self.m_sShopRankData.serverId2 ~= CacheCenter:getPlayerInfo().serverId then
		GetElement(self.m_root, "imgKuafu2_inviteShootItem", WZUIImage):setVisible(true)
	end
	
	local imgPlayer2 = GetElement(self.m_root, "imgPlayer2", WZUIImage)
	if self.m_nRankType == 20 or self.m_nRankType == 32 then
		imgPlayer2:setFile("ui/activityWords/common_fcdh_td.png")
	else
		imgPlayer2:setFile("ui/newActivity/common_sj_zd.png")
	end
	local head_contianer = GetElement(self.m_root,"head_contianer2_WndShopRank",WZUIContainer)
	CellHead:show(head_contianer, self.m_sShopRankData.headId2, self.m_sShopRankData.faceId2, self.m_sShopRankData.sex2, false, nil, self.m_sShopRankData.vipLevel2, self.m_sShopRankData.headColor2)
end

--@brief 	点击选中复选框回调
function CellShopRankItem:onClickFriend(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	WndShopRank:saveInviteFriends(self.m_sShopRankData.id)
end

--@brief 	显示特有的数据信息、
function CellShopRankItem:showSpecifyInfo()
	-- body
	if WndShopRank.m_nTabIndex == 1 then 
		if self.m_sShopRankData.inviteState == 2 then 
			GetElement(self.m_root, "txtHavedInvited_inviteShootItem", WZUILabelTTF):setVisible(true)
			GetElement(self.m_root, "checkBoxSel_inviteShootItem", WZUICheckBox):setVisible(false)
		elseif self.m_sShopRankData.inviteState == 0 then 
			GetElement(self.m_root, "txtHavedInvited_inviteShootItem", WZUILabelTTF):setVisible(false)
			GetElement(self.m_root, "checkBoxSel_inviteShootItem", WZUICheckBox):setVisible(true)
		end
	elseif WndShopRank.m_nTabIndex == 2 then 
		local ftxtMessage = GetElement(self.m_root, "ftxtMessage_inviteShootItem", WZUIFreeTextBox)
		local conBtn = GetElement(self.m_root, "conBtn_inviteShootItem", WZUIContainer)
		if self.m_sShopRankData.operateType == 1 then --待操作
			GetElement(self.m_root, "txtLevel_inviteShootItem", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.37,0.636))
			GetElement(self.m_root, "txt_name", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.7,0.636))
			ftxtMessage:setRelativePosition(GlobalMethod:ccp(0.11, 0.282))
			local sFormat = [[<T C="127,70,26" S="20" P="1">%s</T>]]
			ftxtMessage:setShowText(string.format(sFormat, self.m_sShopRankData.log))
			conBtn:setVisible(true)
		elseif self.m_sShopRankData.operateType == 2 then 	--玩家拒绝
			GetElement(self.m_root, "rankItemImg", WZUI9Image):setFile("ui/common/frame_lieb_01.png")	
			GetElement(self.m_root, "head_contianer", WZUIContainer):setVisible(false)
			ftxtMessage:setShowText(string.format(LocalStrings.SHOOTARROW_TEXT23, self.m_sShopRankData.name))	
			GetElement(self.m_root, "txtLevel_inviteShootItem", WZUILabelTTF):setVisible(false)
			GetElement(self.m_root, "txt_name", WZUILabelTTF):setVisible(false)
		elseif self.m_sShopRankData.operateType == 3 then 	--玩家同意
			GetElement(self.m_root, "rankItemImg", WZUI9Image):setFile("ui/common/frame_lieb_01.png")	
			GetElement(self.m_root, "head_contianer", WZUIContainer):setVisible(false)
			ftxtMessage:setShowText(string.format(LocalStrings.SHOOTARROW_TEXT24, self.m_sShopRankData.name))
			GetElement(self.m_root, "txtLevel_inviteShootItem", WZUILabelTTF):setVisible(false)
			GetElement(self.m_root, "txt_name", WZUILabelTTF):setVisible(false)
		end
	end
end

--@brief 	获取Id
function CellShopRankItem:getData()
	-- body
	return self.m_sShopRankData
end

--@brief 	更新状态
function CellShopRankItem:updateInviteState(state)
	-- body
	self.m_sShopRankData.inviteState = state
	if self.m_nRankType == 12 then 
		self:showSpecifyInfo()
	end
end

--@brief 	点击拒绝和统一按钮回调
function CellShopRankItem:onOperate(element)
	-- body
	local nTag = element:getTag()
	if nTag == 0 then 
		WndShopRank:onClickRefuse(self.m_sShopRankData.id)
	elseif nTag == 1 then 
		WndShopRank:onClickAccept(self.m_sShopRankData.id)
	end
end

--@brief 	显示成就、点赞数据、
function CellShopRankItem:showAchieAndGoodNum(tTempData)
	if tTempData then 
		self.m_sShopRankData = tTempData
	end
	if self.m_bIsLoaded == false then return end 

	GetElement(self.m_root, "conHVInfo_shopRankItem", WZUIContainer):setVisible(true)
	local tData = self.m_sShopRankData

	local spineAchie = GetElement(self.m_root, "spineAchie_shopRankItem", WZUISpine)
	local achieData = GDatatab_holiday_achievement["id_" .. tData.achieId]
	if achieData then
		local bIsFileExist = CheckEffectFile(achieData.icon)
		if spineAchie and bIsFileExist then 
			spineAchie:setFileAtlas(achieData.icon .. ".atlas")
			spineAchie:setFileJson(achieData.icon .. ".json")

			spineAchie:play("wait_1", true)
		end
	end

	GetElement(self.m_root, "txtGoodNum_shopRankItem", WZUILabelTTF):setText(tData.goodNums)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取射箭队伍数据成功
function WndShopRank:_onArrowTeamInfo(activityId, activityType, doType, result, msg)
	--body
	if doType == 6 then 
		self.m_tTeamData = {}
		local tTempData = json.decode(msg)
		WZLog("WndShopRank:_onArrowTeamInfo", Serialize(tTempData), msg)
		--解析礼包奖励
		local array = SplitStringWithSeparator(tTempData.reward, "&")
		local nSex = CacheCenter:getPlayerInfo().sex
		local rewardId = {}
		local rewardNum = {}
		for i = 1, #array do
			WZLog("WndShopRank:_onArrowTeamInfo", string.sub(array[i], 2, -2))
			local string = string.sub(array[i], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
			local num = tonumber(SplitStringWithSeparator(string,",")[3])

			table.insert(rewardId, id)
			table.insert(rewardNum, num)
		end
		for i = 1, #tTempData.sns do
			local tItem = {}
			tItem.rank = tTempData.sns[i]
			tItem.point = tTempData.scores[i]
			tItem.reward_id = rewardId
			tItem.reward_num = rewardNum

			local nIndex = (i - 1)*2 + 1
			tItem.playerId = tTempData.playerIds[nIndex]
			tItem.level = tTempData.levels[nIndex]
			tItem.sex = tTempData.sexs[nIndex]
			tItem.vipLevel = tTempData.vipLevels[nIndex]
			tItem.headId = tTempData.headIds[nIndex]
			tItem.headColor = tTempData.headColors[nIndex]
			tItem.name = tTempData.names[nIndex]
			tItem.faceId = tTempData.faceIds[nIndex]
			tItem.serverId = tTempData.serverIds[nIndex]

			nIndex = nIndex + 1
			tItem.playerId2 = tTempData.playerIds[nIndex]
			tItem.level2 = tTempData.levels[nIndex]
			tItem.sex2 = tTempData.sexs[nIndex]
			tItem.vipLevel2 = tTempData.vipLevels[nIndex]
			tItem.headId2 = tTempData.headIds[nIndex]
			tItem.headColor2 = tTempData.headColors[nIndex]
			tItem.name2 = tTempData.names[nIndex]
			tItem.faceId2 = tTempData.faceIds[nIndex]
			tItem.serverId = tTempData.serverIds[nIndex]

			table.insert(self.m_tTeamData, tItem)
		end

		self:showList(self.m_tTeamData)
	end
end

--@brief 	设置组队射箭邀请的好友数据
function WndShopRank:setArrowTeamInviteData(tData)
	-- body
	local tFriends = CacheCenter:getCurrentFriendList()
	WZLog("WndShopRank:setArrowTeamInviteData", Serialize(tData))
	local tTempInviteFriends = {}
	for i = 1, #tData.ids do
		for j = 1, #tFriends do
			if tFriends[j].id == tData.ids[i] then 
				if tData.status[i] ~= 1 then 
					local tItem = {}
					tItem.id = tFriends[j].id
					tItem.name = tFriends[j].name
					tItem.level = tFriends[j].level
					tItem.sex = tFriends[j].sex
					tItem.faceId = tFriends[j].faceItemId
					tItem.headId = tFriends[j].headItemId
			        tItem.vipLevel = tFriends[j].vipLevel
			        tItem.serverId = tFriends[j].serverId
			        tItem.headColor = tFriends[j].headColor
					tItem.inviteState = tData.status[i]
					tItem.playerId = tItem.id

					table.insert(tTempInviteFriends, tItem)
				end
				break 
			end
		end
	end

	self:showList(tTempInviteFriends)
end

--@brief 	保存选中的好友的Id
function WndShopRank:saveInviteFriends(id)
	-- body
	if self.m_tSelFriends == nil then 
		self.m_tSelFriends = {}
	end

	local nIndex = 0 
	for i = 1, #self.m_tSelFriends do
		if self.m_tSelFriends[i] == id then 
			nIndex = i
			break 
		end
	end

	if nIndex > 0 then 
		table.remove(self.m_tSelFriends, nIndex)
	else
		table.insert(self.m_tSelFriends, id)
	end
end

--@brief 	设置射箭组队邀请通知
--tData数据格式{
--type	: int[]1待操作|2拒绝|3同意,
--desc	: String[]邀请描述语,
--ids	: int[]好友id,
--headIds	: int[]头id,
--headColors	: int[]头颜色,
--vipLevels	: int[]vip等级,
--levels	: int[]等级,
--sexs	: int[]性别,
--faceIds	: int[]脸id,
--names	: String[]玩家名字
--}
function WndShopRank:setArrowTeamInviteNote(tData, doType)
	-- body
	if doType == 2 then 
		self.m_tNoteList = {}
		WZLog("WndShopRank:setArrowTeamInviteNote", Serialize(tData))
		for i = 1, #tData.ids do
			local tItem = {}
			tItem.id = tData.ids[i]
			tItem.playerId = tData.ids[i]
			tItem.log = tData.desc[i]
			tItem.headId = tData.headIds[i]
			tItem.headColor = tData.headColors[i]
			tItem.vipLevel = tData.vipLevels[i]
			tItem.level = tData.levels[i]
			tItem.sex = tData.sexs[i]
			tItem.faceId = tData.faceIds[i]
			tItem.name = tData.names[i]
			tItem.operateType = tData.type[i]
			tItem.serverId = tData.serverIds[i]

			table.insert(self.m_tNoteList, tItem)
		end

		self:showList(self.m_tNoteList)
	elseif doType == 3 then 
		local  flList =  GetElement(self.m_root, "shopItemFreeListContainer", WZUIFreeListContainer)
		for j = 1, #tData.ids do
	        local tNewObj = self:getCellById(tData.ids[j])
	        if tNewObj then
	            tNewObj:updateInviteState(2)
	        end
		end
	elseif doType == 4 then 
	    self:getCellById(tData.id, 1)
	elseif doType == 5 then 
	    self:getCellById(tData.id, 1)
	end
end

--@brief 	获取相应的Cell
function WndShopRank:getCellById(playerId, operateType)
	-- body
	local flList =  GetElement(self.m_root, "shopItemFreeListContainer", WZUIFreeListContainer)
	local nCount = flList:size()
    for i = 1, nCount do
        local element               
         element =  flList:getAt(i-1)    
        if element == nil then
            return
        end
        element = WZUIContainer:luaTo(element)
        local tNewObj = element:getLuaObjectIndex()
        local tData = tNewObj:getData()
        if tData.id == playerId then
        	if operateType then 
        		if tData.operateType == operateType then 
        			flList:removeAt(i - 1)
        			if nCount == 1 then 
        				local conInterface = GetElement(self.m_root, "conInterface_WndShopRank", WZUIContainer)
						ShowPanelNullTip(conInterface, LocalStrings.CHARM_RESULT)
        			end
            		return true 
            	end
        	else
            	return tNewObj
            end
        end
    end

    return nil 
end

--@brief 	获取射箭任务列表
function WndShopRank:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.m_nActivityId then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
--		WZLog("WndShopRank:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))
		if taskType == -1 then
			if self.m_nRankType == 36 or self.m_nRankType == 63 or self.m_nRankType == 71 or self.m_nRankType == 73 then 
				self.m_tSingleArrowList= tab
				self:_showTaskContent()
			end
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
