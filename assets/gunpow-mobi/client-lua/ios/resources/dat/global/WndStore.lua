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
	elseif checkType == 115 then
		self:onCheck7(element)
	elseif checkType == 11 then
		self:onCheck8(element)
	elseif checkType == -2 then
		self:onCheck9(element)
	elseif checkType == 23 then
		self:onCheck10(element)
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
	if not CheckButtonOpen(115) then
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
	WZLog("WndStore:showStoreTableByType")
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
		conButtom:setVisible(false)
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
    ftbCommunityShopDiscount:setShowText("")
    imgTicketIcon:setScale(0.6)

    if CacheCenter:getGameParam().isUseTicket == "0" then
    	conTicket:setVisible(true)
    	imgTicketIcon:setFile(GDatatab_item["id_70"].icon)
    else
    	conTicket:setVisible(false)
    	conDiamond:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    end

    local diamondCount = CacheCenter:getPlayerItemCountById(1)
    txtDiamond:setText(diamondCount)
    txtTicke:setText(CacheCenter:getMoneyList().ticket)

    if self.m_nStoreType == 1  then
    	conFight:setVisible(true)
		local fightCount = CacheCenter:getPlayerItemCountById(11)
		local txtFight = getElement(conFight,"txtFight_WndStore",WZUILabelTTF)
		txtFight:setText(fightCount)
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
	elseif self.m_nStoreType == 6 then
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
		    	local tempStr = string.format(LocalStrings.COST_ITEM_NOTENOUGH,itenName)
		    	MsgBoxManager:showTipBox(tempStr)
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
		    	local itenName = GDatatab_item["id_" .. itemId].name
		    	local temp = string.format(LocalStrings.BUY_RUNE_STORE_NOT_ENOUGTH,itenName,costCount)
		    	MsgBoxManager:showTipBox(temp)
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
	GetElement(self.m_root, "txtRefushCount_WndStore", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-1.32222,0.744444))
	local txtCommunityE = GetElement(self.m_root,"txtCommunityE_WndStore",WZUILabelTTF)
	txtCommunityE:setRelativePosition(GlobalMethod:ccp(0.83,0.5))
	local txtCommunityExplain = GetElement(self.m_root,"txtCommunityExplain_WndStore",WZUILabelTTF)
	txtCommunityExplain:setRelativePosition(GlobalMethod:ccp(1.7,0.5))
	local ftbCommunityShopDiscount = GetElement(self.m_root,"ftbCommunityShopDiscount_WndStore",WZUIFreeTextBox)
	ftbCommunityShopDiscount:setScale(0.75)
	ftbCommunityShopDiscount:setRelativePosition(GlobalMethod:ccp(0.36,0.466405))
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
-------------------------------------语言适配End--------------------------------------------
