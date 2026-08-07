--WndStore.lua
--@brief	WndStore的UI模块
--@date		2016/11/29
--@author	qixiang
--@note		商店模块(竞技商店、宠物商店、黑市商店、公会商店、祈福商店)


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndStore:onEnter(element)
	self.m_root = element
	if self.m_nStoreType ~= 6  then --打开的不是黑市商店才需要请求
		ProtocolProcessorStore:send_MALL_GetBlackMarketInfo()
	end
	ProtocolProcessorSceneCommunity:send_GUILD_GetGuildHall()
	CacheCenter:registerUpatePlayerItemObserver(self)
	CacheCenter:registerUpateMoneyObserver(self)
	
	self:setCurSelT()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndStore:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	CacheCenter:unregisterUpateMoneyObserver(self)
	self:_unInit()
end

--玩家物品更新
function WndStore:receivePlayerItemData()
	WZLog("WndStore:receivePlayerItemData")
	self:setTopInfo()
end

--玩家物品更新
function WndStore:updateMoneyData()
	WZLog("WndStore:updateMoneyData") 
	self:setTopInfo()
end

--@brief onEnter函数执行完成回调
function WndStore:onEnterTransitionDidFinish(element)
    WZLog("WndStore:onEnterTransitionDidFinish")
    local getElement =GetElement
    local conSupriseStore = getElement(self.m_root,"conSupriseStore_WndStore",WZUIContainer)
    local parent = WZUIContainer:luaTo(conSupriseStore:getParent())
    self.m_cellSurprise = conSupriseStore
    local tblFightStore = getElement(parent,"tblFightStore_WndStore",WZUITableContainer)
    local tblCommunityStore = getElement(parent,"tblCommunityStore_WndStore",WZUITableContainer)
	local tblPetStore = getElement(parent,"tblPetStore_WndStore",WZUITableContainer)
	local tblBlessStore = getElement(parent,"tblBlessStore_WndStore",WZUITableContainer)
	local tblSupriseStore = getElement(parent,"tblSupriseStore_WndStore",WZUITableContainer)
	local tblCardStore = getElement(parent,"tblCardStore_WndStore",WZUITableContainer)
	local tblRuneStore = getElement(parent,"tblRuneStore_WndStore",WZUITableContainer)
	local tblEquipStore = getElement(parent,"tblEquipStore_WndStore",WZUITableContainer)
	local tblAdventureStore = getElement(parent,"tblAdventureStore_WndStore",WZUITableContainer)
	local tblPvpRankStore = getElement(parent, "tblPvpRankStore_WndStore", WZUITableContainer)
    local tblAssistStore = getElement(parent, "tblAssistStore_WndStore", WZUITableContainer)
    local tblLotteryStore = GetElement(parent, "tblLotteryStore_WndStore", WZUITableContainer)
    local tblFansStore = GetElement(parent, "tblFansStore_WndStore", WZUITableContainer)
    local tblVIPStore = GetElement(parent, "tblVIPStore_WndStore", WZUITableContainer)
    local tblFlowerStore = GetElement(parent, "tblFlowerStore_WndStore", WZUITableContainer)
    local tblRankStore = GetElement(parent, "tblRankStore_WndStore", WZUITableContainer)
    local conEnergyStore = GetElement(parent, "conEnergyStore_WndStore", WZUIContainer)

	self.m_rootFightTable = tblFightStore
	self.m_rootCommunityTable = tblCommunityStore
	self.m_rootPetTable = tblPetStore
	self.m_rootSurprisedTable = tblSupriseStore
	self.m_rootBlessTable = tblBlessStore
	self.m_rootCardTable = tblCardStore
	self.m_rootRuneTable = tblRuneStore
	self.m_rootEquipTable = tblEquipStore
	self.m_rootAdventureTable = tblAdventureStore
	self.m_rootPvpRankTable = tblPvpRankStore
	self.m_rootAssistTable = tblAssistStore
	self.m_rootLotteryTable = tblLotteryStore
	self.m_rootFansTable = tblFansStore
	self.m_rootVIPTable = tblVIPStore
	self.m_rootFlowerTable = tblFlowerStore
	self.m_rootRankTable = tblRankStore
	self.m_rootEnergy = conEnergyStore
    
    
    self.m_bAdventureOpen = false
    if CheckButtonOpen(ISLAND_BUILDING_ESCAPE,false) then
    	self.m_bAdventureOpen = true
    end

	self:setTopInfo()
	self:_initVipLimit()
	self:showStoreTableByType()
	self:sendProtocl()
	
end

--是否需要发协议获取商店相关列表
function WndStore:sendProtocl(temp)
	WZLog("WndStore:sendProtocl ",self.m_nStoreType)
	local bShowLoading = false
	local tempType = nil
	if temp == nil then
		tempType = self.m_nStoreType
	else
		tempType = temp
	end
	
    if tempType == 1 then  --显示竞技商店
    	if self.m_tFightShopData == nil then
    		ProtocolProcessorStore:send_ROOM_GetArenaStore()
    		bShowLoading = true
    	end
    elseif tempType == 2 then  --公会商店
    	if self.m_tCommunityShopData == nil then
    		ProtocolProcessorStore:send_GUILD_GetGuildStore()
    		bShowLoading = true
    	end
   	elseif tempType == 3 then   --宠物商店
   		if self.m_tPetShopData == nil then
    		ProtocolProcessorStore:send_PET_GetPetStore()
    		bShowLoading = true
    	end
   	elseif tempType == 4 then   --祈福商店
   		if self.m_tBlessShopData == nil then
    		ProtocolProcessorStore:send_PRAY_GetPrayShop()
    		bShowLoading = true
    	end
    elseif tempType == 5 then   --卡牌商店
   		if self.m_tCardShopData == nil then
    		ProtocolProcessorStore:send_CARD_GetCardMes()
    		bShowLoading = true
    	end
    elseif tempType == 6 then  --黑市商店
    	if self.m_tSurprisedShopData == nil then
    		ProtocolProcessorStore:send_MALL_GetBlackMarketInfo()
    		bShowLoading = true
    	end
    elseif tempType == 7 then  --符文商店
    	if self.m_tRuneShopData == nil then
    		ProtocolProcessorStore:send_RUNE_GetRuneStore()
    		bShowLoading = true
    	end
    elseif tempType == 8 then --装备商店
    	if self.m_tEquipmentData == nil then
    		ProtocolProcessorStore:send_EQUIP_GetEquipStore()
    		bShowLoading = true
    	end
    elseif tempType == 9 then --冒险商店
    	if self.m_tAdventureData == nil then
    		ProtocolProcessorStore:send_MALL_GetArenaStore()
    		bShowLoading = true
    	end
    elseif tempType == 10 then --排位商店
    	if self.m_tPvpRankData == nil then
    		ProtocolProcessorStore:send_PLAYER_GetTrioRankMatchShop()
    		bShowLoading = true
    	end
    elseif tempType == 11 then --助战商店
    	if self.m_tAssistData == nil then
    		ProtocolProcessorStore:send_ROOM_GetAssistStore()
    		bShowLoading = true
    	end
    elseif tempType == 12 then --召唤商店
    	if self.m_tLotteryData == nil then
    		ProtocolProcessorStore:send_PLAYER2_GetCallStoreInfo()
    		bShowLoading = true
    	end
    elseif tempType == 13 then --能源商店
    	local dayTab = os.date("*t", SystemTime:getServerTime())
    	if self.m_tEnergyData == nil or (self.m_nEnterDay ~= nil and self.m_nEnterDay ~= dayTab.day) then 
    		self.m_nEnterDay = dayTab.day
    		ProtocolProcessorStore:send_PLAYER2_BreachLevelStore()
    		bShowLoading = true
    	end
    elseif tempType == 14 then --粉丝商店
    	if self.m_tFansData == nil then
    		ProtocolProcessorStore:send_MALL_GetShopNewGoods(41)
    		bShowLoading = true
    	end
    elseif tempType == 15 then --VIP商店
    	if self.m_tVIPData == nil then
    		ProtocolProcessorStore:send_MALL_GetShopNewGoods(42)
    		bShowLoading = true
    	end
    elseif tempType == 16 then --鲜花商店
    	if self.m_tFlowerData == nil then
    		ProtocolProcessorStore:send_MALL_GetShopNewGoods(43)
    		bShowLoading = true
    	end
    elseif tempType == 17 then --排位商店
    	if self.m_tRankData == nil then
    		ProtocolProcessorStore:send_MALL_GetShopNewGoods(44)
    		bShowLoading = true
    	end
    end
    if bShowLoading then
    	self:showLoadingB()
    	return true
    else
    	self:showStoreList()
    end
    return false
end


function WndStore:showLoadingB()
	WZLog("WndStore:showLoadingB")
	self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
end

function WndStore:closeLoadingB()
	WZLog("WndStore:closeLoadingB")
	if self.m_nLoadingTag then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)
		self.m_nLoadingTag = nil
	end
end

function WndStore:onCheckBoxTemp(element)
	
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local checkType = element:getTag()
	WZLog("WndStore:onCheckBoxTemp ",checkType)
	if checkType == 5 then
		self:onCheck1(element)
	elseif checkType == 9 then
		self:onCheck2(element)
	elseif  checkType == 88 then
		self:onCheck3(element)
	elseif checkType == 64 then
		self:onCheck4(element)
	elseif checkType == 76 then
		self:onCheck5(element)
	elseif checkType == -1 then
		self:onCheck6(element)
	elseif checkType == 116 then
		self:onCheck7(element)
	elseif checkType == 11 then
		self:onCheck8(element)
	elseif checkType == 98 then
		self:onCheck9(element)
	elseif checkType == 23 then
		self:onCheck10(element)
	elseif checkType == 1 then
		self:onCheck11(element)
	elseif checkType == 206 then
		self:onCheck12(element)
	elseif checkType == 218 then
		self:onCheck13(element)
	elseif checkType == -2 then
		self:onCheck14(element)
	elseif checkType == -3 then
		self:onCheck15(element)
	elseif checkType == -4 then
		self:onCheck16(element)
	elseif checkType == -5 then
		self:onCheck17(element)
	end
	self:setCurSelT()
end

--选中竞技商店
function WndStore:onCheck1(element)
	WZLog("WndStore:onCheck1")
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 1
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中公会商店
function WndStore:onCheck2(element)
	WZLog("WndStore:onCheck2")
	if not self:communityStoreIsOpen() then
		return
	end
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 2
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

function WndStore:communityStoreIsOpen()
	-- body
	WZLog("WndStore:communityStoreIsOpen")
	if CheckButtonOpen(ISLAND_BUILDING_COMMUNITY) then
		if CacheCenter:getPlayerInfo().guildId <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.TXT_NOSOCISY_FREND)
			return false
		end
		if CacheCenter:getPlayerInfo().guildId > 0 and CacheCenter:getPlayerInfo().guildLevel < 2 then
			local tip = string.format(LocalStrings.GUILD_SKILL_OPEN_TIP,2)
			MsgBoxManager:showTipBox(tip)
			return false
	    end
	    return true
	else
	    return  false
	end
end

--选中宠物商店
function WndStore:onCheck3(element)
	WZLog("WndStore:onCheck3")
	if not self:petStoreIsOpen() then
	    return
	end
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 3
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

function WndStore:petStoreIsOpen()
	-- body
	WZLog("WndStore:petStoreIsOpen")
	if not CheckButtonOpen(88) then
	    return false
	end
	return true
end

--选中召唤商店
function WndStore:onCheck12(element)
	-- body
	if not self:LotteryStoreIsOpen() then
		return 
	end
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 12
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

function WndStore:LotteryStoreIsOpen()
	-- body
	WZLog("WmdStore:LotteryStoreIsOpen")
	if not CheckButtonOpen(206) then
		return false
	end
	return true
end

function WndStore:blessStoreIsOpen()
	-- body
	WZLog("WndStore:blessStoreIsOpen")
	if not CheckButtonOpen(64) then
	    return false
	end
	return true
end

--选中祈福商店
function WndStore:onCheck4(element)
	WZLog("WndStore:onCheck4")
	if not self:blessStoreIsOpen() then
	    return
	end
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 4
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

function WndStore:cardStoreIsOpen()
	-- body
	WZLog("WndStore:cardStoreIsOpen")
	if not CheckButtonOpen(76) then
	    return false
	end
	return true
end

--选中卡牌商店
function WndStore:onCheck5(element)
	WZLog("WndStore:onCheck5")
	if not self:cardStoreIsOpen() then
	    return
	end
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 5
	self:showStoreTableByType()
	self:sendProtocl()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中黑市商店
function WndStore:onCheck6(element)
	WZLog("WndStore:onCheck6")
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 6
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

function WndStore:checkRuneStoreIsOpen()
	-- body
	WZLog("WndStore:checkRuneStoreIsOpen")
	if not CheckButtonOpen(116) then
	    return false
	end
	return true
end

--装备商店开放等级
function WndStore:checkEquipStoreIsOpen()
	-- body
	WZLog("WndStore:checkEquipStoreIsOpen")
	if not CheckButtonOpen(11) then
	    return false
	end
	return true
end

--冒险商店开放等级
function WndStore:checkAdventureStoreIsOpen()
	-- body
	WZLog("WndStore:checkAdventureStoreIsOpen")
	if not CheckButtonOpen(ISLAND_BUILDING_ESCAPE) then
	    return false
	end
	return true
end


--选中符文商店
function WndStore:onCheck7(element)
	WZLog("WndStore:onCheck7")
	if not self:checkRuneStoreIsOpen() then
	    return
	end
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 7
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中装备商店
function WndStore:onCheck8(element)
	WZLog("WndStore:onCheck8")
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 8
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中冒险商店
function WndStore:onCheck9(element)
	WZLog("WndStore:onCheck9")
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 9
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--@brief 	选中排位商店
function WndStore:onCheck10(element)
	WZLog("WndStore:onCheck10")
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 10
	local bSendProtocl self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中竞技商店
function WndStore:onCheck11(element)
	WZLog("WndStore:onCheck11")
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 11
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中粉丝商店
function WndStore:onCheck14(element)
	-- body
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 14
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中粉丝商店
function WndStore:onCheck15(element)
	-- body
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 15
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中鲜花商店
function WndStore:onCheck16(element)
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 16
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--选中鲜花商店
function WndStore:onCheck17(element)
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 17
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--公会商店升级
function WndStore:onClickCommunityShopUpdate(element)
	WZLog("WndStore:onClickCommunityShopUpdate")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local guildInfo = CacheCenter:getGuildInfo()
	if GUILDMAXLEVEL == nil then
		GUILDMAXLEVEL = GetMaxGuildLevel()
	end
	--公会商店已是最高等级
	if guildInfo.storeLevel >= GUILDMAXLEVEL then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO39)
		return
	end

	--公会商店等级和公会等级相同
	if guildInfo.guildLevel == guildInfo.storeLevel then
		MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO30)
		return
	end

	local cost = 0
	for k,v in pairs(GDatatab_guild_building) do
		if v.type == 3 and v.level == (guildInfo.storeLevel + 1) then
			cost = v.cost[1][2]
		end
	end 
	WndCommunityUpgrade:showShopUpgrade() 
	WndCommunityUpgrade.m_nCost = cost
end

function WndStore:onCloseCommunityLogCall()
	WZLog("WndStore:onCloseCommunityLogCall")
	if self.m_root == nil then return end
	self.m_root:setVisible(true)
end

--公会商店日志
function WndStore:onClickCommunityShopLog(element)
	WZLog("WndStore:onClickCommunityShopLog")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_root:setVisible(false)
	WndCommunityShopLog:show(self,self.onCloseCommunityLogCall)
end

--公会商店说明
function WndStore:onClickCommunityShopExplain(element)
	WZLog("WndStore:onClickCommunityShopExplain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.CommunityExplain3)
end

--根据商店类型显示相应的table
function WndStore:showStoreTableByType(storeType)
	WZLog("WndStore:showStoreTableByType",self.m_nStoreType)
	local tempType = nil
	if storeType == nil then
		tempType = self.m_nStoreType
	else
		tempType = storeType
	end
	self.m_rootFightTable:setVisible(false)
	self.m_rootCommunityTable:setVisible(false)
	self.m_rootPetTable:setVisible(false)
	self.m_rootBlessTable:setVisible(false)
	self.m_cellSurprise:setVisible(false)
	self.m_rootCardTable:setVisible(false)
	self.m_rootRuneTable:setVisible(false)
	self.m_rootEquipTable:setVisible(false)
	self.m_rootAdventureTable:setVisible(false)
	self.m_rootPvpRankTable:setVisible(false)
	self.m_rootAssistTable:setVisible(false)
	self.m_rootLotteryTable:setVisible(false)
	self.m_rootEnergy:setVisible(false)
	self.m_rootFansTable:setVisible(false)
	self.m_rootVIPTable:setVisible(false)
	self.m_rootFlowerTable:setVisible(false)
	self.m_rootRankTable:setVisible(false)
	if tempType == 1 then
		self.m_rootFightTable:setVisible(true)
	elseif tempType == 2 then
		self.m_rootCommunityTable:setVisible(true)
	elseif tempType == 3 then
		self.m_rootPetTable:setVisible(true)
	elseif tempType == 5 then
		self.m_rootCardTable:setVisible(true)
	elseif tempType == 4 then
		self.m_rootBlessTable:setVisible(true)
	elseif tempType == 6 then
		self.m_cellSurprise:setVisible(true)
	elseif tempType == 7 then
		self.m_rootRuneTable:setVisible(true)
	elseif tempType == 8 then
		self.m_rootEquipTable:setVisible(true)
	elseif tempType == 9 then
		self.m_rootAdventureTable:setVisible(true)
	elseif tempType == 10 then
		self.m_rootPvpRankTable:setVisible(true)
	elseif tempType == 11 then
		self.m_rootAssistTable:setVisible(true)
	elseif tempType == 12 then
		self.m_rootLotteryTable:setVisible(true)
	elseif tempType == 13 then
		self.m_rootEnergy:setVisible(true)
	elseif tempType == 14 then
		self.m_rootFansTable:setVisible(true)
	elseif tempType == 15 then
		self.m_rootVIPTable:setVisible(true)
	elseif tempType == 16 then
		self.m_rootFlowerTable:setVisible(true)
	elseif tempType == 17 then
		self.m_rootRankTable:setVisible(true)
	end
end

function WndStore:showStoreList(storeType)
	WZLog("WndStore:showStoreList")
	local temp = nil
	local tempType = nil
	if storeType == nil then
		tempType = self.m_nStoreType
	else
		tempType = storeType
	end
	if tempType == 1 and self.m_tFightShopData ~= nil then
		temp = self.m_rootFightTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tFightShopData) do
				local cell,tcell = CellAthShop:createElement()
			    cell:setTag(i-1)
			    tcell:SetData(v)
				self.m_rootFightTable:setCellElement(cell)
			end
		end
	elseif tempType == 2 and self.m_tCommunityShopData ~= nil then
		temp = self.m_rootCommunityTable:getCellElement(0)
		if temp == nil then
			local guildInfo = CacheCenter:getGuildInfo()
			if guildInfo == nil then return end
			local discount = nil
			for k,v in pairs(GDatatab_guild_store_discount) do
				if v.store_level == guildInfo.storeLevel then
					discount = (v.discount/1000)
					break
				end
			end

			for i,v in ipairs(self.m_tCommunityShopData) do
				local celElement,tCell =  CellCommunityShop:createElement()
				celElement:setVisible(true)
				local costID = v.cost[1][1]
				local costNum = v.cost[1][2]

				tCell:setCellShop(v,v.id,v.store,v.itemNum,costNum,costID,discount)
				celElement:setTag(i - 1)
				self.m_rootCommunityTable:setCellElement(celElement)
			end
		end
	elseif tempType == 3 and self.m_tPetShopData ~= nil then
		temp = self.m_rootPetTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tPetShopData.shopList) do
				local cell,tcell = CellPetExchange:createElement()
			    cell:setTag(i-1)
			    tcell:SetData(v)
				self.m_rootPetTable:setCellElement(cell)
			end
		end
	elseif tempType == 5 and  self.m_tCardShopData ~= nil then
		temp = self.m_rootCardTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tCardShopData) do
				local celElement, tNewObj = CellCardShopItem:createElement()
		        tNewObj:setData(v)
		        celElement:setTag(i - 1)
				self.m_rootCardTable:setCellElement(celElement)
			end
		end
		
	elseif tempType == 4 and self.m_tBlessShopData ~= nil then
		temp = self.m_rootBlessTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tBlessShopData) do
				local cellElement,tCell = CellBlessShop:createElement()
			    cellElement:setTag(i - 1)
			    tCell:setData(v, self.m_root)
			    tCell:setCallBackFun(self, self.buyBlessStoreItemCallback)
				self.m_rootBlessTable:setCellElement(cellElement)
			end
		end
	elseif tempType == 6 and self.m_tSurprisedShopData ~= nil then
		temp = self.m_rootSurprisedTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tSurprisedShopData) do
				local celElement,tCell = CellGangsterInn:createElement()
				celElement = WZUIContainer:luaTo(celElement)
				tCell:setData(v)
				celElement:setTag(i-1)
				celElement:setScale(1)

				self.m_rootSurprisedTable:setCellElement(celElement)
			end
		end
	elseif tempType == 7 and self.m_tRuneShopData ~= nil then
		for i,v in ipairs(self.m_tRuneShopData) do
			local celElement,tCell = CellRuneStoreItem:createElement()
			celElement = WZUIContainer:luaTo(celElement)
			tCell:setData(v)
			celElement:setTag(i-1)
			self.m_rootRuneTable:setCellElement(celElement)
		end
	elseif tempType == 8 and self.m_tEquipmentData ~= nil then
		temp = self.m_rootEquipTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tEquipmentData) do
				local cell,tcell = CellEquipStore:createElement()
			    cell:setTag(i-1)
			    tcell:SetData(v, tempType)
				self.m_rootEquipTable:setCellElement(cell)
			end
		end
	elseif tempType == 9 and self.m_tAdventureData ~= nil  then
		temp = self.m_rootAdventureTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tAdventureData) do
				local cell,tcell = CellAdventure:createElement()
			    cell:setTag(i-1)
			    tcell:SetData(v)
				self.m_rootAdventureTable:setCellElement(cell)
			end
		end
	elseif tempType == 10 and self.m_tPvpRankData ~= nil  then
		temp = self.m_rootPvpRankTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tPvpRankData) do
				local cell,tcell = CellEquipStore:createElement()
			    cell:setTag(i-1)
			    tcell:SetData(v, tempType)
				self.m_rootPvpRankTable:setCellElement(cell)
			end
		end
	elseif tempType == 11 and self.m_tAssistData ~= nil  then
		temp = self.m_rootAssistTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tAssistData) do
				local cell,tcell = CellAthShop:createElement()
			    cell:setTag(i-1)
			    tcell:SetData(v)
				self.m_rootAssistTable:setCellElement(cell)
			end
		end
	elseif tempType == 12 and self.m_tLotteryData ~= nil then
		temp = self.m_rootLotteryTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tLotteryData) do
				local cell,tCell = CellLotteryShop:createElement()
				cell:setTag(i - 1)
				tCell:setData(v)
				self.m_rootLotteryTable:setCellElement(cell)
			end
		end
	elseif tempType == 13 and self.m_tEnergyData ~= nil then 
		self:showEnergyContent()
	elseif tempType == 14 and self.m_tFansData ~= nil then
		temp = self.m_rootFansTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tFansData) do
				local cell,tcell = CellEquipStore:createElement()
				cell:setTag(i-1)
				tcell:SetData(v, tempType)
				self.m_rootFansTable:setCellElement(cell)
			end
		end
	elseif tempType == 15 and self.m_tVIPData ~= nil then
		temp = self.m_rootVIPTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tVIPData) do
				local cell,tcell = CellEquipStore:createElement()
				cell:setTag(i-1)
				tcell:SetData(v, tempType)
				self.m_rootVIPTable:setCellElement(cell)
			end
		end
	elseif tempType == 16 and self.m_tFlowerData ~= nil then
		temp = self.m_rootFlowerTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tFlowerData) do
				local cell,tcell = CellEquipStore:createElement()
				cell:setTag(i-1)
				tcell:SetData(v, tempType)
				self.m_rootFlowerTable:setCellElement(cell)
			end
		end
	elseif tempType == 17 and self.m_tRankData ~= nil then
		temp = self.m_rootRankTable:getCellElement(0)
		if temp == nil then
			for i,v in ipairs(self.m_tRankData) do
				local cell,tcell = CellEquipStore:createElement()
				cell:setTag(i-1)
				tcell:SetData(v, tempType)
				self.m_rootRankTable:setCellElement(cell)
			end
		end
	end
end


function WndStore:buyBlessStoreItemCallback(tData)
	WZLog("WndStore:buyBlessStoreItemCallback")
	-- 需要判断祈福背包是否已满
	--if #tBagList + tData.itemid_num[2] > nMaxBagGridsNum then
    --     MsgBoxManager:showTipBox(LocalStrings.BLESS_BAG_FULL2)
    --     return 
    --end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if JudgeMoneyIsEnough(tData.cost[1],tData.cost[2],nil,nil,43) then
		self:showLoadingB()
        ProtocolProcessorStore:send_PRAY_buy(tData.shopId)
    end
end

--设置底部显示的信息
function WndStore:setButtomInfo()
	WZLog("WndStore:setButtomInfo ",self.m_nStoreType)
	local getElement = GetElement
	local localStrings = LocalStrings
	local curSystemTime = SystemTime:getServerTime()
	local conButtom = getElement(self.m_root,"conButtom_WndStore",WZUIContainer)
	conButtom:setVisible(true)
	conButtom:disableSchedule()
	local conRefush = getElement(conButtom,"conRefush_WndStore",WZUIContainer)
	local txtCostCount = getElement(conButtom,"txtCostCount_WndStore",WZUILabelTTF)
	local txtAutoRefush2 = getElement(conButtom,"txtAutoRefush2_WndStore",WZUILabelTTF)
	local txtAutoRefush = getElement(conButtom,"txtAutoRefush_WndStore",WZUILabelTTF)
	local imgCostType = getElement(conButtom,"imgCostType_WndStore",WZUIImage)
	local txtRefresh = getElement(conButtom,"txtRefresh_WndStore",WZUILabelTTF)
	local txtCost = getElement(conButtom,"txtCost_WndStore",WZUILabelTTF)
	local txtAutoRefreshTips = getElement(conButtom,"txtAutoRefreshTips_WndStore",WZUILabelTTF)
    local frbText =	getElement(conButtom,"frbText_WndStore",WZUIFreeTextBox)
    local conBlack = getElement(conButtom,"conBlack_WndStore",WZUIContainer)
    local conStoreExplain = getElement(conButtom,"conStoreExplain_WndStore",WZUIContainer)
    local txtExplain = getElement(conStoreExplain,"txtExplain_WndStore",WZUILabelTTF)
    local frbTextForCardShop = getElement(conButtom,"frbTextForCardShop_WndStore",WZUIFreeTextBox)
    local conCommunityUpdate = getElement(conButtom,"conCommunityUpdate_WndStore",WZUIContainer)
    local conCommunityLog = getElement(conButtom,"conCommunityLog_WndStore",WZUIContainer)
    local conCommunityExplain = getElement(conButtom,"conCommunityExplain_WndStore",WZUIContainer)


    getElement(conButtom,"txtRefushCount_WndStore",WZUILabelTTF):setText(LocalStrings.REFRESH_COUNT..":")

    conBlack:setVisible(false)
	txtCost:setText(localStrings.PETUSE)
	imgCostType:setVisible(true)
	txtCostCount:setText("")
	txtAutoRefush:setText("")
	txtAutoRefush2:setText("")
	frbText:setShowText("")
	conStoreExplain:setVisible(false)
	txtExplain:setText("")
	txtAutoRefreshTips:setText(localStrings.AUTO_REFRESH_COUNT_DOWN)
	conRefush:setVisible(true)
	frbTextForCardShop:setShowText("")
	conCommunityUpdate:setVisible(false)
	conCommunityLog:setVisible(false)
	conCommunityExplain:setVisible(false)
	if self.m_nStoreType == 1  then
		if self.m_tFightShopData == nil then return end
		local bRefresh,refreshCount = self:_getCostByFight()
		local tem = refreshCount - self.m_nFightrefreshCount
		local temp = tem .. "/" .. refreshCount
		txtRefresh:setText(temp)
		
		local itemId,costCount = self:_curRefreshCostByFight()
		if itemId then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		
		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))
		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 2 then
		txtAutoRefush2:setText("")
		txtAutoRefush:setText("")
		txtAutoRefreshTips:setText("")
		conRefush:setVisible(false)
		conCommunityLog:setVisible(true)
		conCommunityExplain:setVisible(true)
		self:showCommunityShopLevel()
	elseif self.m_nStoreType == 3 then
		if self.m_tPetShopData == nil then return end
		local temp = self.m_tPetShopData.leftRefreshTimes .. "/" .. self.m_tPetShopData.totalRefreshTimes
		txtRefresh:setText(temp)
		local icon = GDatatab_item["id_" .. self.m_tPetShopData.refreshCostId].icon
		if self.m_tPetShopData.refreshCostId == 1 then
			imgCostType:setScale(0.35)
		end
		imgCostType:setFile(icon)
		txtCostCount:setText(self.m_tPetShopData.refreshCostNum)
		
		txtAutoRefush2:setText(string.format(LocalStrings.EVERYDAY_REFRESH_TIME,"00:00"))
        local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 5 then
		conRefush:setVisible(true)
		local bRefresh,refreshCount = self:_getCostByCardStore()
		local tem = refreshCount - self.m_nCardRefreshCount
		local temp = tem .. "/" .. refreshCount
		txtRefresh:setText(temp)

		local itemId,costCount = self:_curRefreshCostByCard()
		if itemId then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end

		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))

		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)

		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 4 then
		if self.m_tBlessShopData == nil then return end
		local bRefresh,refreshCount = self:_getCostByBless()

		local temp = refreshCount - self.m_blessRefreshCount .. "/" .. refreshCount
		txtRefresh:setText(temp)
		
		local itemId,costCount = self:_getCostByBlessRefresh()
		WZLog("祈福商店刷新所需",itemId,costCount)
		if itemId ~= nil and itemId ~= 0 then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		
		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))
		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 6 then
		if self.m_tSurprisedShopData == nil then return end
		conRefush:setVisible(false)
		txtAutoRefreshTips:setText("")
		local time = self.m_nSurpriseLeftSecond
		local min = math.floor(time / 60)
		local sec = time % 60
		if min < 10 then min = "0"..min end
		if sec < 10 then sec = "0"..sec end
		frbText:setShowText(string.format(localStrings.INN8,min..":"..sec))
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
		conBlack:setVisible(true)
		conStoreExplain:setVisible(true)
		txtExplain:setText(localStrings.GAME_ACTIVITY_TITLE39 .. LocalStrings.INTRODUCTION)
	elseif self.m_nStoreType == 7 then
		if self.m_tRuneShopData == nil then return end
		local bRefresh,refreshCount = self:_getCostByRune()
		local tem = refreshCount - self.m_nRuneStoreRefreshCount
		local temp = tem .. "/" .. refreshCount
		txtRefresh:setText(temp)
		local itemId,costCount = self:_curRefreshCostByRune()
		if itemId then
			local icon = GDatatab_item["id_" .. itemId].icon
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		txtAutoRefush2:setText(string.format(LocalStrings.EVERYDAY_REFRESH_TIME,"00:00"))
        local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 8 then
		if self.m_tEquipmentData == nil then return end
		local bRefresh,refreshCount = self:_getCostByEquip()
		local temp = self.m_nEqiopfreshCount .. "/" .. refreshCount
		txtRefresh:setText(temp)
		
		local itemId,costCount = self:_getCostByEquipment()
		if itemId ~= nil and itemId ~= 0 then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		
		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))
		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 9 then
		if self.m_tAdventureData == nil then return end
		local bRefresh,refreshCount = self:_getCostByAdventure()
		local tem = refreshCount - self.m_nAdventurefreshCount
		local temp = tem .. "/" .. refreshCount
		txtRefresh:setText(temp)
		
		local itemId,costCount = self:_curRefreshCostByAdventure()
		if itemId then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		
		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))
		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 10 then
		if self.m_tPvpRankData == nil then return end
		local bRefresh,refreshCount = self:_getCostByAdventure()
		local tem = refreshCount - self.m_nPvpRankRefreshCount
		local temp = tem .. "/" .. refreshCount
		txtRefresh:setText(temp)
		
		local itemId,costCount = self:_curRefreshCostByAdventure()
		if itemId then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		
		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))
		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 11  then
		if self.m_tAssistData == nil then return end
		local bRefresh,refreshCount = self:_getCostByAssist()
		local tem = refreshCount - self.m_nAssistrefreshCount
		local temp = tem .. "/" .. refreshCount
		txtRefresh:setText(temp)
		
		local itemId,costCount = self:_curRefreshCostByAssist()
		if itemId then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		
		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))
		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 12 then
		if self.m_tLotteryData == nil then return end
		local bRefresh,refreshCount = self:_getCostByLottery()

		local temp = refreshCount - self.m_LotteryRefreshCount .. "/" .. refreshCount
		txtRefresh:setText(temp)
		
		local itemId,costCount = self:_getCostByLotteryRefresh()
		WZLog("召唤商店刷新所需",itemId,costCount)
		if itemId ~= nil and itemId ~= 0 then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		
		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))
		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	elseif self.m_nStoreType == 13 then
		conButtom:setVisible(false)
	elseif self.m_nStoreType == 14 or self.m_nStoreType == 15 or self.m_nStoreType == 16 or self.m_nStoreType == 17 then
		if self.m_nStoreType == 14 and self.m_tFansData == nil then return end
		if self.m_nStoreType == 15 and self.m_tVIPData == nil then return end
		if self.m_nStoreType == 16 and self.m_tFlowerData == nil then return end
		if self.m_nStoreType == 17 and self.m_tRankData == nil then return end
		local bRefresh,refreshCount = self:_getCostByAdventure()
		local tem = refreshCount - self.m_nfreshCount[self.m_nStoreType]
		local temp = tem .. "/" .. refreshCount
		txtRefresh:setText(temp)
		
		local itemId,costCount = self:_curRefreshCostByAdventure()
		if itemId then
			local icon = GDatatab_item["id_" .. itemId].icon
			if itemId == 1 then
				imgCostType:setScale(0.35)
			end
			imgCostType:setFile(icon)
			txtCostCount:setText(costCount)
		else
			imgCostType:setFile("")
			txtCostCount:setText("")
			txtCost:setText("")
		end
		
		txtAutoRefush2:setText(string.format(localStrings.EVERYDAY_REFRESH_TIME,"00:00"))
		local timeTemp = os.date("*t",curSystemTime)
		local timeT = {}
		timeT.year = timeTemp.year 
		timeT.month = timeTemp.month
		timeT.day = timeTemp.day
		timeT.hours = 0
		timeT.minute = 0
		timeT.second = 0
		local temppppp = os.time(timeT)
		temppppp = temppppp + 43200
        --计算当天已经过了多少秒
		local curPastSecond = temppppp - curSystemTime
		local temp = self:_initTime(curPastSecond)
		txtAutoRefush:setText(temp)
		txtAutoRefush:setTag(curPastSecond)
		conButtom:disableSchedule()
		conButtom:enableSchedule("scheduleRefreshTime",1)
	end
end

--点击了说明
function WndStore:onClickExplain(element)
	WZLog("WndStore:onClickExplain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nStoreType == 6 then
		WndSingleMapDesc:showInterface(LocalStrings.INN11)
	end
end

function WndStore:onClickBlessItem(element)
	WZLog("WndStore:onClickBlessItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndClownTreasure:showInterface(true)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndStore:onClickTicket(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(70)
end

function WndStore:onClickFightItem(element)
	WZLog("WndStore:onClickFightItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(11)
end

function WndStore:onClickAdvItem(element)
	WZLog("WndStore:onClickFightItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nStoreType == 9 then
		WndFastGetItems:show(30)
	elseif self.m_nStoreType == 10 then
		WndFastGetItems:show(10)
	end
end

function WndStore:onClickPetItem(element)
	WZLog("WndStore:onClickPetItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(316)
end

function WndStore:onClickSurpriseItem(element)
	WZLog("WndStore:onClickSurpriseItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local itemInfo = GDatatab_item["id_" .. 2]
	WndItemInfo:showInfo(element,self.m_root,3,itemInfo.name,false)
end

function WndStore:onClickCommunityItem(element)
	WZLog("WndStore:onClickCommunityItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(27)
end

function WndStore:onClickMedal(element)
	-- body
	WZLog("WndStore:onClickMedal")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(23)
end

function WndStore:onClickCard(element)
	WZLog("WndStore:onClickCard")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(26)
end

function WndStore:onClickRuneItem(element)
	WZLog("WndStore:onClickRuneItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(59)
end

function WndStore:onClickEquipIngotsItem(element)
	WZLog("WndStore:onClickEquipIngotsItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(68)
end

function WndStore:onClickAssistItem(element)
	WZLog("WndStore:onClickAssistItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nStoreType == 1 then
		WndFastGetItems:show(160985)
	elseif self.m_nStoreType == 11 then
		WndFastGetItems:show(859)
	elseif self.m_nStoreType == 10 then
		WndFastGetItems:show(160984)
	elseif self.m_nStoreType == 16 or self.m_nStoreType == 17 then
		WndFastGetItems:show(160986)
	end
end

function WndStore:onClickLotteryItem(element)
	WZLog("WndStore:onClickLotteryItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFastGetItems:show(284)
end

function WndStore:onClickTop14(element)
	WZLog("WndStore:onClickEquipIngotsItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nStoreType == 14 then
		WndFastGetItems:show(746)
	elseif self.m_nStoreType == 16 then
		WndFastGetItems:show(160988)
	elseif self.m_nStoreType == 17 then
		WndFastGetItems:show(163025)
	end
end

function WndStore:onClickTop15(element)
	WZLog("WndStore:onClickEquipIngotsItem")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nStoreType == 15 then
		WndFastGetItems:show(747)
	elseif self.m_nStoreType == 16 then
		WndFastGetItems:show(160987)
	elseif self.m_nStoreType == 17 then
		WndFastGetItems:show(163026)
	end
end

--刷新倒计时
function WndStore:scheduleRefreshTime(element)
	WZLog("WndStore:scheduleRefreshTime")
	local txtAutoRefush = GetElement(element,"txtAutoRefush_WndStore",WZUILabelTTF)
	local refreshTime = txtAutoRefush:getTag()
	if self.m_nStoreType ~= 6 then
		if refreshTime - 1 <= 0 then
			if self.m_nStoreType == 1 then
				ProtocolProcessorStore:send_ROOM_GetArenaStore()
			elseif self.m_nStoreType == 2 then
				ProtocolProcessorStore:send_GUILD_GetGuildStore()
			elseif self.m_nStoreType == 3 then
				ProtocolProcessorStore:send_PET_GetPetStore()
			elseif self.m_nStoreType == 9 then
				ProtocolProcessorStore:send_MALL_GetArenaStore()
			elseif self.m_nStoreType == 10 then
				ProtocolProcessorStore:send_PLAYER_GetTrioRankMatchShop()
			elseif self.m_nStoreType == 11 then
				ProtocolProcessorStore:send_ROOM_GetAssistStore()
			elseif self.m_nStoreType == 14 then
	    		ProtocolProcessorStore:send_MALL_GetShopNewGoods(41)
			elseif self.m_nStoreType == 15 then
	    		ProtocolProcessorStore:send_MALL_GetShopNewGoods(42)
			elseif self.m_nStoreType == 16 then
	    		ProtocolProcessorStore:send_MALL_GetShopNewGoods(43)
			elseif self.m_nStoreType == 17 then
	    		ProtocolProcessorStore:send_MALL_GetShopNewGoods(44)
			end
			self:showLoadingB()
			element:disableSchedule()
			txtAutoRefush:setText("00:00:00")
			txtAutoRefush:setTag(0)
		else
			refreshTime = refreshTime - 1
			local temp = self:_initTime(refreshTime)
			txtAutoRefush:setText(temp)
			txtAutoRefush:setTag(refreshTime)
		end
	else --黑市商店另外处理
		local frbText = GetElement(element,"frbText_WndStore",WZUIFreeTextBox)
		self.m_nSurpriseLeftSecond = self.m_nSurpriseLeftSecond -1
		local time = self.m_nSurpriseLeftSecond
		if time <= 0 then
			element:disableSchedule()
			frbText:setShowText("")
			ProtocolProcessorStore:send_MALL_CloseBlackMarket()
			MsgBoxManager:showTipBox(LocalStrings.INN12)
			if self.m_root ~= nil then
			    WindowManager:removeWindow(self.m_root, self, true)
		    end
			return 
		end
		local min = math.floor(time / 60)
		local sec = time % 60
		if min < 10 then min = "0"..min end
		if sec < 10 then sec = "0"..sec end
		frbText:setShowText(string.format(LocalStrings.INN8,min..":"..sec))
	end
end

--@brief	关闭黑店
function WndStore:onCloseInn()
	WZLog("WndStore:onCloseInn")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	MsgBoxManager:showConfirmBox(LocalStrings.INN10, self, self.onCloseInnCall, MSGBOXLEVEL_HIGH, nil)
end

function WndStore:onCloseInnCall()
	WZLog("WndStore:onCloseInnCall")
	ProtocolProcessorStore:send_MALL_CloseBlackMarket()
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndStore:setTopInfo()
	WZLog("WndStore:setTopInfo")
	local getElement = GetElement
    local conTop = getElement(self.m_root,"conTop_WndStore",WZUIContainer)
    local conFight = getElement(conTop,"conFight_WndStore",WZUIContainer)
    local conBless = getElement(conTop,"conBless_WndStore",WZUIContainer)
    local conPet = getElement(conTop,"conPet_WndStore",WZUIContainer)
    local conSuprise = getElement(conTop,"conSuprise_WndStore",WZUIContainer)
    local conCommunity = getElement(conTop,"conCommunity_WndStore",WZUIContainer)
    local conDiamond = getElement(conTop,"conDiamond_WndStore",WZUIContainer)
    local conCard = getElement(conTop,"conCard_WndStore",WZUIContainer)
    local txtDiamond = getElement(conDiamond,"txtDiamond_WndStore",WZUILabelTTF)
    local txtTicke = getElement(self.m_root,"txtTicket_WndStore",WZUILabelTTF)
    local conRune = getElement(conTop,"conRune_WndStore",WZUIContainer)
    local ftbCommunityShopDiscount = getElement(conTop,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
    local imgTicketIcon = getElement(conTop,"imgTicketIcon_WndStore",WZUIImage)
    local conTicket = getElement(conTop,"conTicket_WndStore",WZUIContainer)
    local conEquip = getElement(conTop,"conEquip_WndStore",WZUIContainer)
    local conAdventure = getElement(conTop,"conAdventure_WndStore",WZUIContainer)
    local conAssist = getElement(conTop,"conAssist_WndStore",WZUIContainer)
    local conMedal = getElement(conTop,"conMedal_WndStore",WZUIContainer)
    local conLottery = getElement(conTop,"conLottery_wndStore",WZUIContainer)
    local conTop14 = getElement(conTop,"conTop14_WndStore",WZUIContainer)
    local conTop15 = getElement(conTop,"conTop15_WndStore",WZUIContainer)

    conBless:setVisible(false)
    conFight:setVisible(false)
    conPet:setVisible(false)
    conSuprise:setVisible(false)
    conCommunity:setVisible(false)
    conCard:setVisible(false)
    conRune:setVisible(false)
    conDiamond:setVisible(true)
    conEquip:setVisible(false)
    conAdventure:setVisible(false)
    conAssist:setVisible(false)
    conMedal:setVisible(false)
    conLottery:setVisible(false)
    conTop14:setVisible(false)
	conTop15:setVisible(false)
    ftbCommunityShopDiscount:setShowText("")
    imgTicketIcon:setScale(0.6)
    conTicket:setRelativePosition(GlobalMethod:ccp(0.388877,0.45))
    if CacheCenter:getGameParam().isUseTicket == "0" then
    	conTicket:setVisible(true)
    	imgTicketIcon:setFile(GDatatab_item["id_70"].icon)
    else
    	conTicket:setVisible(false)
    	-- conDiamond:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    end

    local diamondCount = CacheCenter:getPlayerItemCountById(1)
    txtDiamond:setText(diamondCount)
    txtTicke:setText(CacheCenter:getMoneyList().ticket)

    if self.m_nStoreType == 1  then
    	conFight:setVisible(true)
		local fightCount = CacheCenter:getPlayerItemCountById(11)
		local txtFight = getElement(conFight,"txtFight_WndStore",WZUILabelTTF)
		txtFight:setText(fightCount)

		local itemId = 160985
		conAssist:setRelativePosition(GlobalMethod:ccp(0.6615,0.5))
		conAssist:setVisible(true)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(conAssist,"txtAssist_WndStore",WZUILabelTTF):setText(count)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgAssistCoin_WndStore", WZUIImage):setFile(basicInfo.icon)
	elseif self.m_nStoreType == 2 then
		conCommunity:setVisible(true)
		local communityCount = CacheCenter:getPlayerItemCountById(27)
		local txtCommunity = getElement(conCommunity,"txtCommunity_WndStore",WZUILabelTTF)
		txtCommunity:setText(communityCount)
		self:showCommunityShopLevel()
		conDiamond:setVisible(false)
        conTicket:setVisible(false)

		local guildInfo = CacheCenter:getGuildInfo()
		local storeLevel = guildInfo.storeLevel
		local discount = 0
		for k,v in pairs(GDatatab_guild_store_discount) do
			if v.store_level == storeLevel then
				discount = v.discount
				break
			end
		end
		if discount ~= 0 then
			discount = discount / 1000
		end
		
		if discount < 10 then
			local temp
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
				ProjConfig.LANGUAGE == "es" then
				temp = string.format(LocalStrings.COMMUNITY_STORE_DISCOUNT,(100-discount*10).."%")
			else
				temp = string.format(LocalStrings.COMMUNITY_STORE_DISCOUNT,discount)
			end
			ftbCommunityShopDiscount:setShowText(temp)
		end
	elseif self.m_nStoreType == 3 then
		conPet:setVisible(true)
		local petCount = CacheCenter:getPlayerItemCountById(316)
		local txtPet = getElement(conPet,"txtPet_WndStore",WZUILabelTTF)
		txtPet:setText(petCount)
	elseif self.m_nStoreType == 5 then
		conCard:setVisible(true)
		local cardCount = CacheCenter:getPlayerItemCountById(26)
		local txtCard = getElement(conCard,"txtCard_WndStore",WZUILabelTTF)
		txtCard:setText(cardCount)
	elseif self.m_nStoreType == 4 then
		conBless:setVisible(true)
		local petCount = CacheCenter:getPlayerItemCountById(22)
		local txtBless = getElement(conBless,"txtBless_WndStore",WZUILabelTTF)
		txtBless:setText(petCount)
		conMedal:setVisible(true)
		conDiamond:setVisible(false)
		local blessCount = CacheCenter:getPlayerItemCountById(23)
		local txtDiamond = GetElement(conMedal,"txtMedal_WndStore",WZUILabelTTF)
		txtDiamond:setText(blessCount)
		conTicket:setRelativePosition(GlobalMethod:ccp(0.056,0.45))
		conMedal:setRelativePosition(GlobalMethod:ccp(0.388877,0.45))
	elseif self.m_nStoreType == 6 or self.m_nStoreType == 13 then
		conSuprise:setVisible(true)
		local goldCount = CacheCenter:getPlayerItemCountById(2)
		local txtSuprise = getElement(conSuprise,"txtSuprise_WndStore",WZUILabelTTF)
		txtSuprise:setText(goldCount)
	elseif self.m_nStoreType == 7 then
		conRune:setVisible(true)
		local txtRune = getElement(conRune,"txtRune_WndStore",WZUILabelTTF)
		local runeCount = CacheCenter:getPlayerItemCountById(59)
		txtRune:setText(runeCount)
	elseif self.m_nStoreType == 8 then
		conEquip:setVisible(true)
		local txtEquip = getElement(conEquip,"txtEquip_WndStore",WZUILabelTTF)
		local equipCount = CacheCenter:getPlayerItemCountById(68)
		txtEquip:setText(equipCount)
	elseif self.m_nStoreType == 9 then
		conAdventure:setVisible(true)
		local txtAdvent = getElement(conAdventure,"txtAdvent_WndStore",WZUILabelTTF)
		local adventCount = CacheCenter:getPlayerItemCountById(30)
		txtAdvent:setText(adventCount)
		GetElement(self.m_root, "imgAdvCoin_WndStore", WZUIImage):setFile("shopitems/adventure_01.png")
	elseif self.m_nStoreType == 10 then
		conAdventure:setVisible(true)
		local basicInfo = GDatatab_item["id_" .. 10]
		GetElement(self.m_root, "imgAdvCoin_WndStore", WZUIImage):setFile(basicInfo.icon)
		local txtAdvent = getElement(conAdventure,"txtAdvent_WndStore",WZUILabelTTF)
		local adventCount = CacheCenter:getPlayerItemCountById(10)
		txtAdvent:setText(adventCount)
		conAssist:setRelativePosition(GlobalMethod:ccp(0.667,0.5))
		conAssist:setVisible(true)
		local basicInfo = GDatatab_item["id_" .. 160984]
		GetElement(self.m_root, "imgAssistCoin_WndStore", WZUIImage):setFile(basicInfo.icon)
		local coinCount = CacheCenter:getPlayerItemCountById(160984)
		GetElement(conAssist,"txtAssist_WndStore",WZUILabelTTF):setText(coinCount)
	elseif self.m_nStoreType == 11 then
		conAssist:setRelativePosition(GlobalMethod:ccp(0.99,0.5))
		conAssist:setVisible(true)
		local assistCount = CacheCenter:getPlayerItemCountById(859)
		local txtAssist = getElement(conAssist,"txtAssist_WndStore",WZUILabelTTF)
		txtAssist:setText(assistCount)
		local basicInfo = GDatatab_item["id_" .. 859]
		if basicInfo then 
			GetElement(self.m_root, "imgAssistCoin_WndStore", WZUIImage):setFile(basicInfo.icon)
		end
	elseif self.m_nStoreType == 12 then
		conLottery:setVisible(true)
		local lotteryNum = CacheCenter:getPlayerItemCountById(284)
		local txtLottery = getElement(conLottery,"txtLottery_WndStore",WZUILabelTTF)
		txtLottery:setText(lotteryNum)
		local basicInfo = GDatatab_item["id_".. 284]
		if basicInfo then
			getElement(self.m_root, "imgLotteryCoin_WndStore",WZUIImage):setFile(basicInfo.icon)
		end
	elseif self.m_nStoreType == 14 then
		local itemId = 746
		conTop14:setRelativePosition(GlobalMethod:ccp(0.99,0.5))
		conTop14:setVisible(true)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgTop14_WndStore", WZUIImage):setFile(basicInfo.icon)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(self.m_root,"txtTop14_WndStore",WZUILabelTTF):setText(count)
	elseif self.m_nStoreType == 15 then
		local itemId = 747
		conTop15:setRelativePosition(GlobalMethod:ccp(0.99,0.5))
		conTop15:setVisible(true)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(self.m_root,"txtTop15_WndStore",WZUILabelTTF):setText(count)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgTop15_WndStore", WZUIImage):setFile(basicInfo.icon)
	elseif self.m_nStoreType == 16 then
	    conDiamond:setVisible(false)
		
		local itemId = 160988
		conTop14:setRelativePosition(GlobalMethod:ccp(0.99,0.5))
		conTop14:setVisible(true)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(conTop14,"txtTop14_WndStore",WZUILabelTTF):setText(count)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgTop14_WndStore", WZUIImage):setFile(basicInfo.icon)

		local itemId = 160987
		conTop15:setRelativePosition(GlobalMethod:ccp(0.6615,0.5))
		conTop15:setVisible(true)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(self.m_root,"txtTop15_WndStore",WZUILabelTTF):setText(count)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgTop15_WndStore", WZUIImage):setFile(basicInfo.icon)

		local itemId = 160986
		conAssist:setRelativePosition(GlobalMethod:ccp(0.333,0.5))
		conAssist:setVisible(true)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(conAssist,"txtAssist_WndStore",WZUILabelTTF):setText(count)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgAssistCoin_WndStore", WZUIImage):setFile(basicInfo.icon)
	elseif self.m_nStoreType == 17 then
		conDiamond:setVisible(false)

		local itemId = 163025
		conTop14:setRelativePosition(GlobalMethod:ccp(0.6615,0.5))
		conTop14:setVisible(true)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(conTop14,"txtTop14_WndStore",WZUILabelTTF):setText(count)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgTop14_WndStore", WZUIImage):setFile(basicInfo.icon)

		local itemId = 163026
		conTop15:setRelativePosition(GlobalMethod:ccp(0.99,0.5))
		conTop15:setVisible(true)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(self.m_root,"txtTop15_WndStore",WZUILabelTTF):setText(count)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgTop15_WndStore", WZUIImage):setFile(basicInfo.icon)

		local itemId = 160986
		conAssist:setRelativePosition(GlobalMethod:ccp(0.333,0.5))
		conAssist:setVisible(true)
		local count = CacheCenter:getPlayerItemCountById(itemId)
		GetElement(conAssist,"txtAssist_WndStore",WZUILabelTTF):setText(count)
		local basicInfo = GDatatab_item["id_" .. itemId]
		GetElement(self.m_root, "imgAssistCoin_WndStore", WZUIImage):setFile(basicInfo.icon)
	end
end



--@brief	点击添加钻石按钮调用函数
--@param	element:说明按钮的UI节点引用
function WndStore:onAddDiamond(element)
	WZLog("WndStore:onAddDiamond")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_34"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_34"].feedback_info)
		return
	end
	--跳转到充值界面
	PassportSdkManager:gotoPaymentPage()
end

--@brief	点击添加金币按钮调用函数
--@param	element:说明按钮的UI节点引用
function WndStore:onAddGold(element)
	WZLog("WndStore:onAddGold")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CacheCenter:getPlayerInfo().level < GDatatab_button_info["id_35"].open_level then
        MsgBoxManager:showTipBox(GDatatab_button_info["id_35"].feedback_info)
		return
	end
	WndBuyActivity:showBuyInterface(26)
end

function WndStore:onTempClose(element)
	WZLog("WndStore:onTempClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	if self.m_callbackLua and self.m_callbackFun then
		self.m_callbackFun(self.m_callbackLua,self.m_bBuy)
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--点击刷新
function WndStore:onClickRefresh(element)
	WZLog("WndStore:onClickRefresh")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nStoreType == 1 then
		local bRefresh ,count = self:_getCostByFight()
		if bRefresh then
			local itemId,costCount = self:_curRefreshCostByFight()
			
            if not JudgeMoneyIsEnough(itemId,costCount,nil, nil,8, nil, nil, nil, nil, self, self.clickSureMoney) then
                return
            end
			self:clickSureMoney()
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 2 then
		if self.m_nCommunityRefreshCount > 0 then --可以进行免费刷新
			self:clickSureMoney()
		else
			local itemId,costCont = self:_curRefreshCostByCommunity()
			if JudgeMoneyIsEnough(itemId,costCont,nil,nil,43, nil, nil, nil, nil, self, self.clickSureMoney) then
				self:clickSureMoney()
			end
		end
	elseif self.m_nStoreType == 3 then
		if self.m_tPetShopData.leftRefreshTimes > 0 then
			local diamondCount = CacheCenter:getPlayerItemCountById(self.m_tPetShopData.refreshCostId)
			local itenName = GDatatab_item["id_" .. self.m_tPetShopData.refreshCostId].name
			if diamondCount >= self.m_tPetShopData.refreshCostNum then
				self:showLoadingB()
		        ProtocolProcessorStore:send_PET_RefreshStore()
		    else
		    	if not JudgeMoneyIsEnough(self.m_tPetShopData.refreshCostId, self.m_tPetShopData.refreshCostNum,nil, nil, 211, nil, nil, nil, nil, self, self.clickSureMoney) then
	                return
	            end
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 7 then
		local bRefresh ,count = self:_getCostByRune()
		if bRefresh then
			local itemId,costCount = self:_curRefreshCostByRune()
			local diamondCount = CacheCenter:getPlayerItemCountById(itemId)
			if diamondCount >= costCount then
				self:showLoadingB()
		        ProtocolProcessorStore:send_RUNE_RefreshRuneStore()
		    else
		    	if not JudgeMoneyIsEnough(itemId,costCount,nil, nil, 212, nil, nil, nil, nil, self, self.clickSureMoney) then
	                return
	            end
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 8  then
		local bRefresh ,count = self:_getCostByEquip()
		if bRefresh then
			local itemId = self.m_nEqiopfreshCostId
			local costCount = self.m_nEqiopfreshCostCount
			
            if not JudgeMoneyIsEnough(itemId,costCount,nil, nil,8, nil, nil, nil, nil, self, self.clickSureMoney) then
                return
            end
			self:clickSureMoney()
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 9 then
		local bRefresh ,count = self:_getCostByAdventure()
		if bRefresh then
			local itemId,costCount = self:_curRefreshCostByAdventure()
			
            if not JudgeMoneyIsEnough(itemId,costCount,nil, nil,8, nil, nil, nil, nil, self, self.clickSureMoney) then
                return
            end
			self:clickSureMoney()
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 5 then
		local bRefresh ,count = self:_getCostByCardStore()
		if bRefresh then
			local itemId,costCount = self:_curRefreshCostByCard()
			
            if not JudgeMoneyIsEnough(itemId,costCount,nil, nil,8, nil, nil, nil, nil, self, self.clickSureMoney) then
                return
            end
			self:clickSureMoney()
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 10 then
		local bRefresh ,count = self:_getCostByAdventure()
		if bRefresh then
			local itemId,costCount = self:_curRefreshCostByAdventure()
			
            if not JudgeMoneyIsEnough(itemId,costCount,nil, nil,8, nil, nil, nil, nil, self, self.clickSureMoney) then
                return
            end
			self:clickSureMoney()
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 11 then
		local bRefresh ,count = self:_getCostByAssist()
		if bRefresh then
			local itemId,costCount = self:_curRefreshCostByAssist()
			
            if not JudgeMoneyIsEnough(itemId, costCount,nil, nil,8, nil, nil, nil, nil, self, self.clickSureMoney) then
                return
            end
			self:clickSureMoney()
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 4 then
		local bRefresh,count = self:_getCostByBless()
		if bRefresh then
			local itemId,costCount = self:_getCostByBlessRefresh()

			if not JudgeMoneyIsEnough(itemId, costCount,nil, nil,8, nil, nil, nil, nil, self,self.clickSureMoney) then
				return
			end
			self:clickSureMoney()
		else 
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 12 then
		local bRefresh,count = self:_getCostByLottery()
		if bRefresh then
			local itemId,costCount = self:_getCostByLotteryRefresh()

			if not JudgeMoneyIsEnough(itemId, costCount,nil,nil,8,nil,nil,nil,nil,self,self.clickSureMoney) then
				MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
				return
			end
			self:clickSureMoney()
		else 
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	elseif self.m_nStoreType == 14 or self.m_nStoreType == 15 or self.m_nStoreType == 16 or self.m_nStoreType == 17 then
		local bRefresh ,count = self:_getCostByAdventure()
		if bRefresh then
			local itemId,costCount = self:_curRefreshCostByAdventure()
			
            if not JudgeMoneyIsEnough(itemId,costCount,nil, nil,8, nil, nil, nil, nil, self, self.clickSureMoney) then
                return
            end
			self:clickSureMoney()
		else
			MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT)
		end
	end
end

function WndStore:clickSureMoney()
	if self.m_nStoreType == 1 then
        self:showLoadingB()
        ProtocolProcessorStore:send_ROOM_RefreshArenaStore()
    elseif self.m_nStoreType == 2 then
        self:showLoadingB()
        ProtocolProcessorStore:send_GUILD_RefreshGuildStore()
    elseif  self.m_nStoreType == 8 then
    	self:showLoadingB()
        ProtocolProcessorStore:send_EQUIP_RefreshEquipStore()
    elseif self.m_nStoreType == 9 then
    	self:showLoadingB()
        ProtocolProcessorStore:send_MALL_RefreshArenaStore()
    elseif self.m_nStoreType == 5 then
    	self:showLoadingB()
        ProtocolProcessorStore:send_CARD_RefreshCardStore()
    elseif self.m_nStoreType == 10 then
    	self:showLoadingB()
    	ProtocolProcessorStore:send_PLAYER_RefreshTrioRankMatchShop()
    elseif self.m_nStoreType == 11 then
    	self:showLoadingB()
    	ProtocolProcessorStore:send_ROOM_RefreshAssistStore()
    elseif self.m_nStoreType == 4 then
    	self:showLoadingB()
    	ProtocolProcessorBless:send_PRAY_RePrayShop()
    elseif self.m_nStoreType == 12 then
    	self:showLoadingB()
    	ProtocolProcessorStore:send_PLAYER2_ReCallStoreInfo()
    elseif self.m_nStoreType == 7 then
    	self:showLoadingB()
		ProtocolProcessorStore:send_RUNE_RefreshRuneStore()
    elseif self.m_nStoreType == 3 then
    	self:showLoadingB()
		ProtocolProcessorStore:send_PET_RefreshStore()
	elseif self.m_nStoreType == 14 then
		self:showLoadingB()
		ProtocolProcessorStore:send_MALL_RefreshShopNewGoods(41)
	elseif self.m_nStoreType == 15 then
		self:showLoadingB()
		ProtocolProcessorStore:send_MALL_RefreshShopNewGoods(42)
	elseif self.m_nStoreType == 16 then
		self:showLoadingB()
		ProtocolProcessorStore:send_MALL_RefreshShopNewGoods(43)
	elseif self.m_nStoreType == 17 then
		self:showLoadingB()
		ProtocolProcessorStore:send_MALL_RefreshShopNewGoods(44)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 初始化VIP限购
function WndStore:_initVipLimit()
    self.vipLimit = {}
    self.vipLimit2 = {}
    self.vipLimit3 = {}
    self.vipLimit4 = {}
    self.vipLimit5 = {}
    self.vipLimit10 = {}
    self.vipLimit11 = {} --装备商店刷新消耗
    self.vipLimit29 = {}
    self.vipLimit30 = {} --召唤商店刷新消耗
    self.vipLimitList = {} --刷新消耗 [14]:粉丝商店 [15]:VIP商店
    for k,v in pairs(GDatatab_vip_restriction) do
        if v.type == 3 then
            table.insert(self.vipLimit,v)
        elseif v.type == 8 then
        	table.insert(self.vipLimit2,v)
        elseif  v.type == 14 then
        	table.insert(self.vipLimit3,v)
        elseif v.type == 20 then
        	table.insert(self.vipLimit4,v)
        elseif v.type == 2 then
        	table.insert(self.vipLimit5,v)
        elseif v.type == 24 then
        	table.insert(self.vipLimit10,v)
        elseif v.type == 19 then
        	table.insert(self.vipLimit11,v)
        elseif v.type == 29 then
        	table.insert(self.vipLimit29,v)
        elseif v.type == 30 then
        	table.insert(self.vipLimit30,v)
        elseif v.type == 41 then
        	self.vipLimitList[14] = self.vipLimitList[14] or {}
        	table.insert(self.vipLimitList[14], v)
        elseif v.type == 42 then
        	self.vipLimitList[15] = self.vipLimitList[15] or {}
        	table.insert(self.vipLimitList[15], v)
        elseif v.type == 43 then
        	self.vipLimitList[16] = self.vipLimitList[16] or {}
        	table.insert(self.vipLimitList[16], v)
        elseif v.type == 44 then
        	self.vipLimitList[17] = self.vipLimitList[17] or {}
        	table.insert(self.vipLimitList[17], v)
        end
    end

    local function sort(v1,v2)
        return v1.count > v2.count
    end

    table.sort(self.vipLimit,sort)
    table.sort(self.vipLimit2,sort)
    table.sort(self.vipLimit3,sort)
    table.sort(self.vipLimit4,sort)
    table.sort(self.vipLimit5,sort)
    table.sort(self.vipLimit10,sort)
    table.sort(self.vipLimit11,sort)
    table.sort(self.vipLimit29,sort)
    table.sort(self.vipLimit30,sort)
    for k,v in pairs(self.vipLimitList) do
    	table.sort(v, sort)
	end
end

-- 获取竞技商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByFight()
	WZLog("WndStore:_getCostByFight")
    local curLv = CacheCenter:getPlayerInfo().vipLevel
    local nextCount = self.m_nFightrefreshCount + 1

    -- 先判断刷新次数是否达到当前最大值
    local countt = nil
    local bRefresh = true
    for i = 1, #self.vipLimit do
        if self.vipLimit[i].vip_level == curLv then
            if nextCount > self.vipLimit[i].count then
            	bRefresh = false
                countt = self.vipLimit[i].count
                break
            else
                countt = self.vipLimit[i].count
                break
            end
        end
    end

    return bRefresh,countt
end

-- 寻找竞技商店当前刷新需要的消耗
function WndStore:_getCostByEquipment()
	WZLog("WndStore:_getCostByEquipment")
	local nextCount = self.m_nEqiopfreshCount + 1
	local bRefresh , totalCount = self:_getCostByEquip()
	nextCount = totalCount - self.m_nEqiopfreshCount + 1
    for i = 1, #self.vipLimit11 do
        if self.vipLimit11[i].count == nextCount then
            return self.vipLimit11[i].cost[1][1],self.vipLimit11[i].cost[1][2]
        end
    end
end

-- 寻找祈福商店当前刷新需要的消耗
function WndStore:_getCostByBlessRefresh()
	WZLog("WndStore:_getCostByBlessRefresh")
	local nextCount = self.m_blessRefreshCount + 1
	local bRefresh , totalCount = self:_getCostByBless()
    for i = 1, #self.vipLimit29 do
        if self.vipLimit29[i].count == nextCount then
            return self.vipLimit29[i].cost[1][1],self.vipLimit29[i].cost[1][2]
        end
    end
end

-- 寻找召唤商店当前刷新需要的消耗
function WndStore:_getCostByLotteryRefresh()
	WZLog("WndStore:_getCostByLotteryRefresh")
	local nextCount = self.m_LotteryRefreshCount + 1
	local bRefresh , totalCount = self:_getCostByLottery()
    for i = 1, #self.vipLimit30 do
        if self.vipLimit30[i].count == nextCount then
            return self.vipLimit30[i].cost[1][1],self.vipLimit30[i].cost[1][2]
        end
    end
end

-- 获取冒险或排位商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByAdventure()
	WZLog("WndStore:_getCostByAdventure")
    local curLv = CacheCenter:getPlayerInfo().vipLevel
    local nextCount 
    local tVipLimit
    if self.m_nStoreType == 9 then
    	nextCount = self.m_nAdventurefreshCount + 1
    	tVipLimit = self.vipLimit4
    elseif self.m_nStoreType == 10 then
    	nextCount = self.m_nPvpRankRefreshCount + 1
    	tVipLimit = self.vipLimit10
    elseif self.m_nStoreType == 14 or self.m_nStoreType == 15 or self.m_nStoreType == 16 or self.m_nStoreType == 17 then
    	nextCount = self.m_nfreshCount[self.m_nStoreType] + 1
    	tVipLimit = self.vipLimitList[self.m_nStoreType]
    end

    -- 先判断刷新次数是否达到当前最大值
    local countt = nil
    local bRefresh = true
    for i = 1, #tVipLimit do
        if tVipLimit[i].vip_level == curLv then
            if nextCount > tVipLimit[i].count then
            	bRefresh = false
                countt = tVipLimit[i].count
                break
            else
                countt = tVipLimit[i].count
                break
            end
        end
    end

    return bRefresh,countt
end

-- 获取卡牌商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByCardStore()
	WZLog("WndStore:_getCostByCardStore")
    local curLv = CacheCenter:getPlayerInfo().vipLevel
    local nextCount = self.m_nCardRefreshCount + 1

    -- 先判断刷新次数是否达到当前最大值
    local countt = nil
    local bRefresh = true
    for i = 1, #self.vipLimit5 do
        if self.vipLimit5[i].vip_level == curLv then
            if nextCount > self.vipLimit5[i].count then
            	bRefresh = false
                countt = self.vipLimit5[i].count
                break
            else
                countt = self.vipLimit5[i].count
                break
            end
        end
    end

    return bRefresh,countt
end

-- 获取装备商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByEquip()
	WZLog("WndStore:_getCostByEquip")
	local curLv = CacheCenter:getPlayerInfo().vipLevel
    local totalCount = 0

    -- 先判断刷新次数是否达到当前最大值
    local countt = nil
    local bRefresh = true
    for i = 1, #self.vipLimit11 do
        if self.vipLimit11[i].vip_level == curLv then
            if self.vipLimit11[i].count > totalCount then
                totalCount = self.vipLimit11[i].count
            end
        end
    end
    if self.m_nEqiopfreshCount <= 0 then
    	bRefresh = false
    end
    return bRefresh,totalCount
end

-- 获取祈福商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByBless()
	WZLog("WndStore:_getCostByBless")
	local curLv = CacheCenter:getPlayerInfo().vipLevel
    local totalCount = 0
    -- 先判断刷新次数是否达到当前最大值
    local countt = nil
    local bRefresh = true
    for i = 1, #self.vipLimit29 do
        if self.vipLimit29[i].vip_level == curLv then
            if self.vipLimit29[i].count > totalCount then
                totalCount = self.vipLimit29[i].count
            end
        end
    end
    if totalCount - self.m_blessRefreshCount <= 0 then
    	bRefresh = false
    end
    return bRefresh,totalCount
end

-- 获取召唤商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByLottery()
	WZLog("WndStore:_getCostByLottery")
	local curLv = CacheCenter:getPlayerInfo().vipLevel
    local totalCount = 0
    -- 先判断刷新次数是否达到当前最大值
    local countt = nil
    local bRefresh = true
    for i = 1, #self.vipLimit30 do
        if self.vipLimit30[i].vip_level == curLv then
            if self.vipLimit30[i].count > totalCount then
                totalCount = self.vipLimit30[i].count
            end
        end
    end
    if totalCount - self.m_LotteryRefreshCount <= 0 then
    	bRefresh = false
    end
    return bRefresh,totalCount
end

-- 获取符文商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByRune()
	WZLog("WndStore:_getCostByRune =",self.m_nRuneStoreRefreshCount)
    local curLv = CacheCenter:getPlayerInfo().vipLevel
    local nextCount = self.m_nRuneStoreRefreshCount + 1

    -- 先判断刷新次数是否达到当前最大值
    local countt = 0
    local bRefresh = true
    for i = 1, #self.vipLimit3 do
        if self.vipLimit3[i].vip_level == curLv then
            if self.vipLimit3[i].count > countt  then
                countt = self.vipLimit3[i].count
            end
        end
    end
    if countt < nextCount then
    	bRefresh = false
    end
    return bRefresh,countt
end


-- 获取公会商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByCommunityStore()
    local curLv = CacheCenter:getPlayerInfo().vipLevel
    local nextCount = self.m_nCommunityRefreshCount + 1
    -- 先判断刷新次数是否达到当前最大值
    local countt = nil
    local bRefresh = true
    for i = 1, #self.vipLimit2 do
        if self.vipLimit2[i].vip_level == curLv then
            if nextCount > self.vipLimit2[i].count then
            	bRefresh = false
                countt = self.vipLimit2[i].count
                break
            else
                countt = self.vipLimit2[i].count
                break
            end
        end
    end
    return bRefresh,countt
end

-- 寻找竞技商店当前刷新需要的消耗
function WndStore:_curRefreshCostByFight()
	WZLog("WndStore:_curRefreshCost")
	local nextCount = self.m_nFightrefreshCount + 1
    for i = 1, #self.vipLimit do
        if self.vipLimit[i].count == nextCount then
            return self.vipLimit[i].cost[1][1],self.vipLimit[i].cost[1][2]
        end
    end
end

-- 寻找卡牌商店当前刷新需要的消耗
function WndStore:_curRefreshCostByCard()
	WZLog("WndStore:_curRefreshCostByCard")
	local nextCount = self.m_nCardRefreshCount + 1
    for i = 1, #self.vipLimit5 do
        if self.vipLimit5[i].count == nextCount then
            return self.vipLimit5[i].cost[1][1],self.vipLimit5[i].cost[1][2]
        end
    end
end

--@brief 	
-- 寻找冒险商店当前刷新需要的消耗
function WndStore:_curRefreshCostByAdventure()
	WZLog("WndStore:_curRefreshCostByAdventure")
	local nextCount 
	local tVipLimit 
	if self.m_nStoreType == 9 then
		nextCount = self.m_nAdventurefreshCount + 1
		tVipLimit = self.vipLimit4
	elseif self.m_nStoreType == 10 then
		nextCount = self.m_nPvpRankRefreshCount + 1
		tVipLimit = self.vipLimit10
    elseif self.m_nStoreType == 14 or self.m_nStoreType == 15 or self.m_nStoreType == 16 or self.m_nStoreType == 17 then
    	nextCount = self.m_nfreshCount[self.m_nStoreType] + 1
    	tVipLimit = self.vipLimitList[self.m_nStoreType]
	end
    for i = 1, #tVipLimit do
        if tVipLimit[i].count == nextCount then
            return tVipLimit[i].cost[1][1],tVipLimit[i].cost[1][2]
        end
    end
end

-- 寻找符文商店当前刷新需要的消耗
function WndStore:_curRefreshCostByRune()
	WZLog("WndStore:_curRefreshCostByRune")
	local nextCount = self.m_nRuneStoreRefreshCount + 1
    for i = 1, #self.vipLimit3 do
        if self.vipLimit3[i].count == nextCount then
            return self.vipLimit3[i].cost[1][1],self.vipLimit3[i].cost[1][2]
        end
    end
end

-- 寻找公会商店当前刷新需要的消耗
function WndStore:_curRefreshCostByCommunity()
	WZLog("WndStore:_curRefreshCostByCommunity")
	--是否花费%d贡献刷新？
	local costType = nil
	local costCount = nil
	for k,v in pairs(GDatatab_vip_restriction) do
		if v.type == 8 and v.parameter == 2 then
			costType = v.cost[1][1]
			costCount = v.cost[1][2]
			break
		end
	end
	return costType,costCount
end

--@brief 	获取助战商店可以刷新多少次和是否可以进行刷新
function WndStore:_getCostByAssist()
	WZLog("WndStore:_getCostByAssist")
    local nextCount = self.m_nAssistrefreshCount + 1
    local costConfig = CacheCenter:getGameParam().assistinShopPrice
    local ids, nums = SplitItemString(costConfig)
    -- 先判断刷新次数是否达到当前最大值
    local countt = #ids 
    local bRefresh = true
    if nextCount > countt then 
    	bRefresh = false 
    end

    return bRefresh,countt
end

--@brief 	寻找助战商店当前刷新需要的消耗
function WndStore:_curRefreshCostByAssist()
	WZLog("WndStore:_curRefreshCost")
	local nextCount = self.m_nAssistrefreshCount + 1

	local costConfig = CacheCenter:getGameParam().assistinShopPrice
    local ids, nums = SplitItemString(costConfig)

    return tonumber(ids[nextCount]), tonumber(nums[nextCount])
end

--@brief 	能源商店是否开启
function WndStore:energyStoreIsOpen()
	-- body
	WZLog("WmdStore:energyStoreIsOpen")
	if not CheckButtonOpen(218) then
		return false
	end
	return true
end

--@brief 	点击兑换按钮回调
function WndStore:onClickExchange(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local dayTab = os.date("*t", SystemTime:getServerTime())
	if dayTab.day ~= self.m_nEnterDay then 
		self.m_nEnterDay = dayTab.day
    	ProtocolProcessorStore:send_PLAYER2_BreachLevelStore()
    	MsgBoxManager:showTipBox(LocalStrings.BREAK_TEXT1[9])
    	return 
	end

	if self.m_tEnergyData.leftNum < self.m_nNum then 
		MsgBoxManager:showTipBox(LocalStrings.BREAK_TEXT1[7])
		return 
	end
	local costNum = self.m_tEnergyData.priceNum * self.m_nNum
	if not JudgeMoneyIsEnough(self.m_tEnergyData.priceId, costNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureUseDiaInstead, nil, nil) then 
		return 
	end

	self:sureUseDiaInstead()
end

--@brief 	确定用蓝钻代替
function WndStore:sureUseDiaInstead()
	ProtocolProcessorStore:send_PLAYER2_BuyBreachLevel(self.m_nNum, self.m_tEnergyData.priceId)
end

--一次减十个
function WndStore:onMutiReduce(element)
	WZLog("WndStore:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 10 then
		self.m_nNum = self.m_nNum - 10
	elseif self.m_nNum > 1 then
		self.m_nNum = 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNumEnergy_WndStore",WZUILabelTTF):setText(self.m_nNum)
end

--一次减一个
function WndStore:onReduce(element)
	WZLog("WndStore:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNumEnergy_WndStore",WZUILabelTTF):setText(self.m_nNum)
end

--一次加一个
function WndStore:onAdd(element)
	WZLog("WndStore:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local useNumEnergy = GetElement(self.m_root,"useNumEnergy_WndStore",WZUILabelTTF)
	local max = self.m_limitNum
	if self.m_nNum + 1 <= max then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	useNumEnergy:setText(self.m_nNum)
end

--@brief	增加10个
function WndStore:onMutiAdd(element)
	WZLog("WndStore:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local max = self.m_limitNum
	if self.m_nNum + 10 <= max then
		self.m_nNum = self.m_nNum + 10
	else
		if self.m_nNum >= max then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
			return
		else
			self.m_nNum = max
		end
	end
	GetElement(self.m_root,"useNumEnergy_WndStore",WZUILabelTTF):setText(self.m_nNum)
end

--选中召唤商店
function WndStore:onCheck13(element)
	-- body
	if not self:energyStoreIsOpen() then
		return 
	end
	if self.m_noteCurShowBtn then
		self.m_noteCurShowBtn:setTouchEnable(true)
	end
	self.m_noteCurShowBtn = element
	element:setTouchEnable(false)
	self.m_nStoreType = 13
	self:sendProtocl()
	self:showStoreTableByType()
	self:setTopInfo()
	self:setButtomInfo()
	self.m_tCurBuyTable = nil
	self.m_tCurBuyCell = nil
end

--@brief 	显示能源商店内容
function WndStore:showEnergyContent()
	local tData = self.m_tEnergyData

	GetElement(self.m_root, "txtEnergyAtt_WndStore", WZUILabelTTF):setText(LocalStrings.BREAK_TEXT1[5])
	GetElement(self.m_root, "txtLeftWord_WndStore", WZUILabelTTF):setText(LocalStrings.BREAK_TEXT1[6])
	GetElement(self.m_root, "txtPriceWord_WndStore", WZUILabelTTF):setText(LocalStrings.UNIT_PRICE .. ":")
	GetElement(self.m_root, "useNumEnergy_WndStore", WZUILabelTTF):setText(self.m_nNum)

	--能源晶石图标
	local conItem = GetElement(self.m_root, "conItem_Energy", WZUIContainer)
	conItem:removeAllChildrenWithCleanup(true)
	local element, tNewObj = CellGoodItem:createElement()
	if element and tNewObj then 
		tNewObj:setCellGoodLocalId(tData.goodId, 1, 4)
		tNewObj:_setItemVisible(false)
		element:setScale(0.85)
		tNewObj:setItemClickFun(self, self.onItemClick)

		conItem:addChild(element)
	end
	--库存
	GetElement(self.m_root, "txtLeftNum_WndStore", WZUILabelTTF):setText(tData.leftNum)
	--价格
	GetElement(self.m_root, "imgPriceEnergy_WndStore", WZUIImage):setFile(GDatatab_item["id_" .. tData.priceId].icon)
	GetElement(self.m_root, "txtPriceNum_WndStore", WZUILabelTTF):setText(tData.priceNum)
	--
	local imgDiscount = GetElement(self.m_root, "imgDiscount_WndStore", WZUIImage)
	local txtDiscount = GetElement(self.m_root, "txtDiscount_WndStore", WZUILabelTTF)
	if tData.discount >= 0 then 
		imgDiscount:setFile("ui/common/common_btn_jiant_ss.png")
		imgDiscount:setRotation(0)
	else
		imgDiscount:setFile("ui/common/common_btn_jiant_06.png")
		imgDiscount:setRotation(90)
	end

	txtDiscount:setText(math.abs(tData.discount) .. "%")
end

function WndStore:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false,nil,true)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndStore:_adaptLanguage_th()
	GetElement(self.m_root, "txtRefushCount_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-1.33333,0.744444))
	GetElement(self.m_root, "txtAutoRefush_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.354673,0.706417))
	local ftb = GetElement(self.m_root,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
	ftb:setScale(0.8)
	ftb:setMaxWidth(400)
	ftb:setRelativePosition(GlobalMethod:ccp(0.32,0.466405))
	local txt = GetElement(self.m_root,"txtCommunityExplain_WndStore",WZUILabelTTF)
	txt:setRelativePosition(GlobalMethod:ccp(1.5,0.5))
	GetElement(self.m_root,"txtExplain_WndStore",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120))
end

function WndStore:_adaptLanguage_en()
	GetElement(self.m_root, "txtRefushCount_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-1.15556,0.744444))
	GetElement(self.m_root, "txtAutoRefush_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.178604,0.706417))
	GetElement(self.m_root, "txtRefresh1_WndStore", WZUILabelTTF):setScale(0.9)
	GetElement(self.m_root, "txtRefresh2_WndStore", WZUILabelTTF):setScale(0.9)
	local txt = GetElement(self.m_root,"txtCommunityExplain_WndStore",WZUILabelTTF)
	txt:setRelativePosition(GlobalMethod:ccp(1.5,0.5))
	local ftb = GetElement(self.m_root,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
	ftb:setScale(0.8)

	for i=1,2 do
		local txtBlack = GetElement(self.m_root,"txtBlack"..i.."_WndStore",WZUILabelTTF)
		txtBlack:setDimensions(GlobalMethod:CCSize(90,0))
		txtBlack:setScale(0.7)
	end

	local imgBlack = GetElement(self.m_root,"imgBlack_WndStore",WZUIImage)
	imgBlack:setRelativePosition(GlobalMethod:ccp(-2,0.455556))
end

function WndStore:_adaptLanguage_vn()
	local txtCommunityE = GetElement(self.m_root,"txtCommunityE_WndStore",WZUILabelTTF)
	txtCommunityE:setRelativePosition(GlobalMethod:ccp(0.83,0.5))
	local txtCommunityExplain = GetElement(self.m_root,"txtCommunityExplain_WndStore",WZUILabelTTF)
	txtCommunityExplain:setRelativePosition(GlobalMethod:ccp(1.7,0.5))
	local ftbCommunityShopDiscount = GetElement(self.m_root,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
	ftbCommunityShopDiscount:setRelativePosition(GlobalMethod:ccp(0.22,0.46))

	GetElement(self.m_root,"txtExplain_WndStore",WZUILabelTTF):setScale(0.7)
	local frbText = GetElement(self.m_root,"frbText_WndStore",WZUIFreeTextBox)
	frbText:setScale(0.7)
	frbText:setMaxWidth(250)

	GetElement(self.m_root, "txtEnergyAtt_WndStore", WZUILabelTTF):setFontSize(14)
	GetElement(self.m_root, "txtLeftNum_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.54,0.35))
	
	GetElement(self.m_root, "txtRefushCount_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.77,0.64))
end

function WndStore:_adaptLanguage_pt()
	GetElement(self.m_root, "txtAutoRefush_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.329032,0.706417))
	GetElement(self.m_root, "txtAutoRefush2_WndStore", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(240))
	GetElement(self.m_root, "txtRefushCount_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-1.36667,0.744444))

	GetElement(self.m_root, "txtRefresh1_WndStore", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtRefresh2_WndStore", WZUILabelTTF):setScale(0.8)

	local ftbCommunityShopDiscount = GetElement(self.m_root,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
	ftbCommunityShopDiscount:setScale(0.8)
	ftbCommunityShopDiscount:setRelativePosition(GlobalMethod:ccp(0.385,0.466405))
	
	local txtCommunityE = GetElement(self.m_root,"txtCommunityE_WndStore",WZUILabelTTF)
	txtCommunityE:setRelativePosition(GlobalMethod:ccp(0.89,0.5))
	local txtCommunityExplain = GetElement(self.m_root,"txtCommunityExplain_WndStore",WZUILabelTTF)
	txtCommunityExplain:setRelativePosition(GlobalMethod:ccp(1.6,0.5))

	-- GetElement(self.m_root,"txtBlackmarket1_WndStore",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))
	-- GetElement(self.m_root,"txtBlackmarket2_WndStore",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))
	
    local txtExplain = GetElement(self.m_root,"txtExplain_WndStore",WZUILabelTTF)
    txtExplain:setDimensions(GlobalMethod:CCSize(140))

	local frbText = GetElement(self.m_root,"frbText_WndStore",WZUIFreeTextBox)
	frbText:setScale(0.85)
	frbText:setRelativePosition(GlobalMethod:ccp(0.467751,0.5))
end

function WndStore:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtAutoRefush_WndStore",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.31,0.706417))
	GetElement(self.m_root,"frbTextForCardShop_WndStore",WZUIFreeTextBox):setMaxWidth(330)
	GetElement(self.m_root, "txtAutoRefush2_WndStore", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(240))

	local txtRefushC = GetElement(self.m_root, "txtRefushCount_WndStore", WZUILabelTTF)
	txtRefushC:setRelativePosition(GlobalMethod:ccp(-1.33,0.744444))
	txtRefushC:setFontSize(16)

	GetElement(self.m_root,"txtRefresh_WndStore",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtRefresh1_WndStore",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtRefresh2_WndStore",WZUILabelTTF):setScale(0.8)

	local frbText = GetElement(self.m_root,"frbText_WndStore",WZUIFreeTextBox)
	frbText:setScale(0.7)
	frbText:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	frbText:setMaxWidth(330)

	local txtBlack1 = GetElement(self.m_root,"txtBlack1_WndStore",WZUILabelTTF)
	txtBlack1:setDimensions(GlobalMethod:CCSize(130,0))
	txtBlack1:setScale(0.7)

	local txtBlack2 = GetElement(self.m_root,"txtBlack2_WndStore",WZUILabelTTF)
	txtBlack2:setDimensions(GlobalMethod:CCSize(130,0))
	txtBlack2:setScale(0.7)

	local txtCommunityE = GetElement(self.m_root,"txtCommunityE_WndStore",WZUILabelTTF)
	txtCommunityE:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
	txtCommunityE:setFontSize(16)

	local txtCommunityExplain = GetElement(self.m_root,"txtCommunityExplain_WndStore",WZUILabelTTF)
	txtCommunityExplain:setRelativePosition(GlobalMethod:ccp(1.75,0.5))
	txtCommunityExplain:setFontSize(16)

	local ftbCommunityShopDiscount = GetElement(self.m_root,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
	ftbCommunityShopDiscount:setScale(0.6)
	ftbCommunityShopDiscount:setRelativePosition(GlobalMethod:ccp(0.37,0.466405))

	GetElement(self.m_root,"txtCurSel_WndStore",WZUILabelTTF):setScale(0.8)

	local txtExplain = GetElement(self.m_root,"txtExplain_WndStore",WZUILabelTTF)
    txtExplain:setDimensions(GlobalMethod:CCSize(140,0))
    txtExplain:setFontSize(14)

    local txtCommunityUpdate = GetElement(self.m_root,"txtCommunityUpdate_WndStore",WZUILabelTTF)
    txtCommunityUpdate:setDimensions(GlobalMethod:CCSize(120,0))
    txtCommunityUpdate:setScale(0.8)
end

function WndStore:_adaptLanguage_tr()
	GetElement(self.m_root, "txtAutoRefush_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.329032,0.706417))
	GetElement(self.m_root, "txtAutoRefush2_WndStore", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(240))
	GetElement(self.m_root, "txtRefushCount_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-1.43,0.744444))

	GetElement(self.m_root, "txtRefresh1_WndStore", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtRefresh2_WndStore", WZUILabelTTF):setScale(0.8)

	local ftbCommunityShopDiscount = GetElement(self.m_root,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
	ftbCommunityShopDiscount:setScale(0.8)
	ftbCommunityShopDiscount:setRelativePosition(GlobalMethod:ccp(0.385,0.466405))
	
	local txtCommunityE = GetElement(self.m_root,"txtCommunityE_WndStore",WZUILabelTTF)
	txtCommunityE:setRelativePosition(GlobalMethod:ccp(0.89,0.5))
	local txtCommunityExplain = GetElement(self.m_root,"txtCommunityExplain_WndStore",WZUILabelTTF)
	txtCommunityExplain:setRelativePosition(GlobalMethod:ccp(1.6,0.5))

	--GetElement(self.m_root,"txtBlackmarket1_WndStore",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))
	--GetElement(self.m_root,"txtBlackmarket2_WndStore",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(200))
	
    local txtExplain = GetElement(self.m_root,"txtExplain_WndStore",WZUILabelTTF)
    txtExplain:setDimensions(GlobalMethod:CCSize(140))

	local frbText = GetElement(self.m_root,"frbText_WndStore",WZUIFreeTextBox)
	frbText:setScale(0.85)
	frbText:setRelativePosition(GlobalMethod:ccp(0.467751,0.5))

	local txtBlack1 = GetElement(self.m_root,"txtBlack1_WndStore",WZUILabelTTF)
	txtBlack1:setDimensions(GlobalMethod:CCSize(130,0))
	txtBlack1:setScale(0.7)
	local txtBlack2 = GetElement(self.m_root,"txtBlack2_WndStore",WZUILabelTTF)
	txtBlack2:setDimensions(GlobalMethod:CCSize(130,0))
	txtBlack2:setScale(0.7)
end


function WndStore:_adaptLanguage_ug()
	local txtAutoRefush = GetElement(self.m_root,"txtAutoRefush_WndStore",WZUILabelTTF)
	txtAutoRefush:setScale(0.7)
	txtAutoRefush:setFontSize(18)
	txtAutoRefush:setRelativePosition(GlobalMethod:ccp(0.0179209,0.706417))
	local txtAutoRefreshTips = GetElement(self.m_root,"txtAutoRefreshTips_WndStore",WZUILabelTTF)
	txtAutoRefreshTips:setScale(0.7)
	txtAutoRefreshTips:setFontSize(18)
	txtAutoRefreshTips:setRelativePosition(GlobalMethod:ccp(0.103562,0.706417))
	local frbTextForCardShop = GetElement(self.m_root,"frbTextForCardShop_WndStore",WZUIFreeTextBox)
	frbTextForCardShop:setScale(0.7)
	frbTextForCardShop:setRelativePosition(GlobalMethod:ccp(0.0127857,0.484008))

    local txtCommunityUpdate = GetElement(self.m_root,"txtCommunityUpdate_WndStore",WZUILabelTTF)
    txtCommunityUpdate:setDimensions(GlobalMethod:CCSize(150,0))
    txtCommunityUpdate:setScale(0.7)

	local txtRefushCount = GetElement(self.m_root, "txtRefushCount_WndStore", WZUILabelTTF)
	txtRefushCount:setRelativePosition(GlobalMethod:ccp(-0.800002,0.744444))
	txtRefushCount:setScale(0.7)
	local txtRefresh = GetElement(self.m_root,"txtRefresh_WndStore",WZUILabelTTF)
	txtRefresh:setRelativePosition(GlobalMethod:ccp(-1.66667,0.744444))
	txtRefresh:setScale(0.7)
	local txtCost = GetElement(self.m_root,"txtCost_WndStore",WZUILabelTTF)
	txtCost:setScale(0.7)
	txtCost:setRelativePosition(GlobalMethod:ccp(-0.14444,0.277777))
	local imgCostType = GetElement(self.m_root,"imgCostType_WndStore",WZUIImage)
	imgCostType:setRelativePosition(GlobalMethod:ccp(-1.02222,0.277777))
	local txtCostCount = GetElement(self.m_root,"txtCostCount_WndStore",WZUILabelTTF)
	txtCostCount:setScale(0.7)
	txtCostCount:setRelativePosition(GlobalMethod:ccp(-1.25556,0.277777))
end
-------------------------------------语言适配End--------------------------------------------
