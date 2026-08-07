--WndDressCastSoulData.lua
--@brief	WndDressCastSoul的数据模块
--@date		2020/05/20
--@author	XTX
--@note		时装铸魂界面

WndDressCastSoul = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDressCastSoul:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_topCellLua = nil 
	self.conPlayer = nil 
	self.m_nSuitIndex = 1
	self.m_nWingIndex = 1 
	self.m_nTitleIndex = 1 
	self.m_tSuitList = nil 			--时装套装数据
	self.m_tWingList = nil 			--翅膀数据
	self.m_tTitleList = nil 		--Vip称号数据
	self.m_nTabIndex = 1
	self.m_tSuitOpenLevel = nil 		--时装铸魂格子开启等级
	self.m_tWingOpenLevel = nil 		--翅膀铸魂格子开启等级
	self.m_tTitleOpenLevel = nil 		--Vip称号铸魂格子开启等级
	self.m_tSuitSoulList = nil 			--时装魂石
	self.m_tWingSoulList = nil 			--翅膀魂石
	self.m_tTitleSoulList = nil 		--Vip称号魂石
	self.m_tCurSelCell = nil 				--当前选中的套装cell
	self.m_tSuitResponseList = nil 		--时装共鸣元魂
	self.m_tWingResponseList = nil 		--翅膀共鸣元魂
	self.m_tTitleResponseList = nil 	--Vip称号共鸣元魂
	self.m_tSuitGMOpenLevel = nil 		--时装共鸣元魂格子开启等级
	self.m_tWingGMOpenLevel = nil 		--翅膀共鸣元魂格子开启等级
	self.m_tTitleGMOpenLevel = nil 		--Vip称号共鸣元魂格子开启等级

	self.m_nMoveElementPosX = nil       --保存元魂列表移动位置
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDressCastSoul:_unInit()
	self.m_root = nil
	self.m_topCellLua = nil 
	self.conPlayer = nil 
	self.m_nSuitIndex = nil 
	self.m_nWingIndex = nil  
	self.m_nTitleIndex = nil  
	self.m_tSuitList = nil 			--时装套装数据
	self.m_tWingList = nil 			--翅膀数据
	self.m_tTitleList = nil 		--Vip称号数据
	self.m_nTabIndex = nil 
	self.m_tSuitOpenLevel = nil 		--时装铸魂格子开启等级
	self.m_tWingOpenLevel = nil 		--翅膀铸魂格子开启等级
	self.m_tTitleOpenLevel = nil 		--Vip称号铸魂格子开启等级
	self.m_tSuitSoulList = nil 			--时装魂石
	self.m_tWingSoulList = nil 			--翅膀魂石
	self.m_tTitleSoulList = nil 		--Vip称号魂石
	self.m_tCurSelCell = nil 				--当前选中的套装cell
	self.m_tSuitResponseList = nil 		--时装共鸣元魂
	self.m_tWingResponseList = nil 		--翅膀共鸣元魂
	self.m_tTitleResponseList = nil 	--Vip称号共鸣元魂
	self.m_tSuitGMOpenLevel = nil 		--时装共鸣元魂格子开启等级
	self.m_tWingGMOpenLevel = nil 		--翅膀共鸣元魂格子开启等级
	self.m_tTitleGMOpenLevel = nil 		--Vip称号共鸣元魂格子开启等级

	self.m_nMoveElementPosX = nil       --保存元魂列表移动位置
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDressCastSoul:createElement()
	if WndDressCastSoul.m_root ~= nil then
		WindowManager:removeWindow(WndDressCastSoul.m_root, WndDressCastSoul, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDressCastSoul")
	assert(element, "WndDressCastSoul create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndDressCastSoul:showInterface()
	-- body
	local wndSoul = WndDressCastSoul:createElement()
	if wndSoul then 
		WindowManager:addWindow(wndSoul, WndDressCastSoul)
	end
end

--@brief 	获取套装数据、翅膀数据
function WndDressCastSoul:setSuitAndWingData()
	-- body
	self.m_tSuitList = {}
	self.m_tWingList = {}
	self.m_tTitleList = {}
	local sex = CacheCenter:getPlayerInfo().sex

	for i, v in pairs(GDatatab_enchanting) do
		local tItem = {}

		if v.display ~= -1 then 
			local tSuit 
			if sex == 0 then 
				tSuit = v.item_id1[1]
			else
				tSuit = v.item_id2[1]
			end
			local nCount = 0 
			local tLastTime = {0, 0, 0}
			local tColor = {0,0,0}
			for j = 1, #tSuit do
				local lastTime = CacheCenter:getPlayerItemCountById(tSuit[j])
				if lastTime == -1 or lastTime > 0 then 
					nCount = nCount + 1
					tLastTime[j] = lastTime
					tColor[j] = CacheCenter:getColorById(tSuit[j])
				end
			end

			tItem.suitId = tSuit
			tItem.lastTime = tLastTime
			tItem.id = v.id
			tItem.display = v.display
			tItem.suit = v.suit 
			tItem.count = nCount
			tItem.color = tColor
				
			if v.display == 1 or (v.display == 2 and nCount > 0) then  
				table.insert(self.m_tSuitList, tItem)
			end
		end

		--翅膀数据
		if v.item_id3 > 0 then 
			local tWing = {}

			tWing.count = 0
			local lastTime = CacheCenter:getPlayerItemCountById(v.item_id3)
			if lastTime == -1 or lastTime > 0 then 
				tWing.count = 1
			end

			tWing.lastTime = lastTime
			tWing.suitId = v.item_id3
			tWing.id = v.id
			tWing.display = v.display2
			tWing.suit = v.suit 
			if v.display2 == 1 or (v.display2 == 2 and tWing.count > 0) then 
				table.insert(self.m_tWingList, tWing)
			end
		end
	end

	local tVipTitle = CacheCenter:getPlayerVipTitle()
	if tVipTitle then 
		for i = 1, #tVipTitle do 
			if tVipTitle[i].id ~= 11301 and tVipTitle[i].id ~= 11302 and tVipTitle[i].id ~= 11303 then
				tTitle = {}

				tTitle.count = 0 
				tTitle.lastTime = 0
				if tVipTitle[i].status and tVipTitle[i].status > 0 then 
					tTitle.count = 1
					tTitle.lastTime = -1
				end
				local nStarIndex1, _ = string.find(tVipTitle[i].script, "*")
				local nStarIndex2, _ = string.find(tVipTitle[i].script, "=")
				if nStarIndex1 then
					local itemId = string.sub(tVipTitle[i].script, nStarIndex1 + 1, nStarIndex2 - 1)
					tTitle.suitId = tonumber(itemId)
					tTitle.id = tVipTitle[i].id
					tTitle.name = tVipTitle[i].name
					tTitle.display = 1
					tTitle.suit = i

					table.insert(self.m_tTitleList, tTitle)
				end
			end
		end
	end

	local function sortSuit(a, b)
		-- body
		local function getSortValue(c)
			-- body
			if c.count == 3 then 
				return 3
			elseif c.count > 0 then 
				return 1 
			elseif c.count == 0 then 
				return 2
			end
		end

		local tempA = getSortValue(a)
		local tempB = getSortValue(b)
		if tempA ~= tempB then 
			return tempA < tempB
		else
			return a.suit < b.suit
		end
	end

	table.sort(self.m_tSuitList, sortSuit)
	table.sort(self.m_tWingList, function (a, b)
		-- body
		if a.count ~= b.count then 
			return a.count < b.count
		else
			return a.suit < b.suit
		end
	end)
	table.sort(self.m_tTitleList, function (a, b)
		-- body
		if a.count ~= b.count then 
			return a.count < b.count
		else
			return a.suit > b.suit
		end
	end)
end

--@brief 	设置元魂数据
function WndDressCastSoul:setSoulData(suitType, gridId, soulId, soulLuck, fashionGongming, wingGongming, fGongmingSpiritId, wGongmingSpiritId, fashionLuck, wingLuck, titleGongming, tGongmingSpiritId, titleLuck)
	-- body
	WZLog("WndDressCastSoul:setSoulData", Serialize(suitType), Serialize(gridId), Serialize(soulId), Serialize(soulLuck), Serialize(fashionGongming), Serialize(wingGongming), Serialize(fGongmingSpiritId), Serialize(wGongmingSpiritId), Serialize(fashionLuck), Serialize(wingLuck), Serialize(titleGongming), Serialize(tGongmingSpiritId), Serialize(titleLuck))
	self.m_tSuitSoulList = {}
	self.m_tWingSoulList = {}
	self.m_tTitleSoulList = {}
	self.m_tSuitResponseList = {} 		--时装共鸣元魂
	self.m_tWingResponseList = {} 		--翅膀共鸣元魂
	self.m_tTitleResponseList = {} 		--Vip称号共鸣元魂

	for i = 1, #suitType do
		local tItem = {}
		tItem.lucky = soulLuck[i]
		tItem.soulId = soulId[i]
		if suitType[i] == 1 then 
			self.m_tSuitSoulList[gridId[i] + 1] = tItem
		elseif suitType[i] == 2 then 
			self.m_tWingSoulList[gridId[i] + 1] = tItem
		elseif suitType[i] == 5 then 
			self.m_tTitleSoulList[gridId[i] + 1] = tItem
		end
	end

	for i = 1, #fashionGongming do
		local tItem = {}
		tItem.lucky = fashionLuck[i]
		tItem.soulId = fGongmingSpiritId[i]

		self.m_tSuitResponseList[fashionGongming[i] + 1] = tItem
	end

	for i = 1, #wingGongming do
		local tItem = {}
		tItem.lucky = wingLuck[i]
		tItem.soulId = wGongmingSpiritId[i]

		self.m_tWingResponseList[wingGongming[i] + 1] = tItem
	end

	if titleGongming then 
		for i = 1, #titleGongming do
			local tItem = {}
			tItem.lucky = titleLuck[i]
			tItem.soulId = tGongmingSpiritId[i]

			self.m_tTitleResponseList[titleGongming[i] + 1] = tItem
		end
	end

	self:_update()
end

--@brief	缓存推送更新物品时调用的函数
function WndDressCastSoul:updatePlayerItemData()
	WZLog("WndDressCastSoul:updatePlayerItemData")
	if self.m_root ~= nil then
		
	end
end

-- 监听时装改变
function WndDressCastSoul:updateDecorationData()
    if self.m_root then 
    	self:setSuitAndWingData()
		self:_update()
    end
end

--@brief 	操作元魂返回
function WndDressCastSoul:operateSoulResult(suitType, gridId, soulId, num, lucky, result)
	-- body
	if num == 1 and result[1] == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.STAR_SOUL_LIGHT_FAIL)
	end
	if suitType == 1 then 
		self.m_tSuitSoulList[gridId + 1].soulId = soulId
		self.m_tSuitSoulList[gridId + 1].lucky = lucky
	elseif suitType == 2 then 
		self.m_tWingSoulList[gridId + 1].soulId = soulId
		self.m_tWingSoulList[gridId + 1].lucky = lucky
	elseif suitType == 3 then --时装共鸣元魂
		self.m_tSuitResponseList[gridId + 1].soulId = soulId
		self.m_tSuitResponseList[gridId + 1].lucky = lucky
	elseif suitType == 4 then --翅膀共鸣元魂
		self.m_tWingResponseList[gridId + 1].soulId = soulId
		self.m_tWingResponseList[gridId + 1].lucky = lucky
	elseif suitType == 5 then --Vip称号终极元魂
		self.m_tTitleSoulList[gridId + 1].soulId = soulId
		self.m_tTitleSoulList[gridId + 1].lucky = lucky
	elseif suitType == 6 then --Vip称号共鸣元魂
		self.m_tTitleResponseList[gridId + 1].soulId = soulId
		self.m_tTitleResponseList[gridId + 1].lucky = lucky
	end

	if not (suitType == 4 and num == 1 and result[1] == 1) then
		self:showGridList()
	end
	--如果升级界面存在
	if WndCastSoulUpgrade.m_root then 
		WndCastSoulUpgrade:updateData(gridId + 1, soulId, self.m_nTabIndex, num, result, lucky)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取收集的套数
function WndDressCastSoul:getCollectSuitNum(nTabIndex)
	-- body
	local num = 0
	local nCurIndex = nTabIndex or self.m_nTabIndex
	if nCurIndex == 1 then 
		for i = 1, #self.m_tSuitList do
			if self.m_tSuitList[i].count >= 3 then 
				num = num + 1 
			end
		end
	elseif nCurIndex == 2 then 
		for i = 1, #self.m_tWingList do
			if self.m_tWingList[i].count >= 1 then 
				num = num + 1 
			end
		end
	elseif nCurIndex == 3 then 
		for i = 1, #self.m_tTitleList do
			if self.m_tTitleList[i].count >= 1 then 
				num = num + 1 
			end
		end
	end

	return num 
end

--@brief 	计算穿着身上的祝福的个属性的值
function WndDressCastSoul:caculateProperty()
	-- body
	local tEquipProperty = {{1, 0}, {3, 0}, {4, 0}}

	local tEquipList 
	local tGMList 
	local tGridLevel
	if self.m_nTabIndex == 1 then 
		tEquipList = self.m_tSuitSoulList
		tGMList = self.m_tSuitResponseList
		tGridLevel = self.m_tSuitOpenLevel
	elseif self.m_nTabIndex == 2 then 
		tEquipList = self.m_tWingSoulList
		tGMList = self.m_tWingResponseList
		tGridLevel = self.m_tWingOpenLevel
	elseif self.m_nTabIndex == 3 then 
		tEquipList = self.m_tTitleSoulList
		tGMList = self.m_tTitleResponseList
		tGridLevel = self.m_tTitleOpenLevel
	end
	local nHaveNum = self:getCollectSuitNum()

	for i = 1, #tGridLevel do
		if tEquipList[i] and tEquipList[i].soulId and tEquipList[i].soulId > 0 and nHaveNum >= tGridLevel[i] then
			local tData = CopyTable(GDatatab_spirit["id_" .. tEquipList[i].soulId])
			if tData then 
				-- 第9个以后的普通元魂和第3个以后的共鸣元魂选用另一套配置
				if i > 9 then
					tData.exp = tData.exp2
					tData.property = tData.property2
					tData.rate = tData.rate2
					tData.luckeylimit = tData.luckeylimit2
				end
				tData.exp2 = nil
				tData.property2 = nil
				tData.rate2 = nil
				tData.luckeylimit2 = nil

				local nGMIndex = math.floor((i - 1)/3) + 1
				local addRate = 0
				if tGMList[nGMIndex] and tGMList[nGMIndex].soulId and tGMList[nGMIndex].soulId > 0 then 
					local tempData = GDatatab_spirit["id_" .. tGMList[nGMIndex].soulId]
					if nGMIndex > 3 then -- 第9个以后的普通元魂和第3个以后的共鸣元魂选用另一套配置
						addRate = tempData.property2
					else
						addRate = tempData.property
					end
				end
				for j = 1, #tData.property do
					local tItem = CopyTable(tData.property[j])
					tItem[2] = tItem[2] + (tItem[2] * addRate / 10000)
					local bExist = false 
					for k = 1, #tEquipProperty do
						if tItem[1] == tEquipProperty[k][1] then      	
							tEquipProperty[k][2] = tEquipProperty[k][2] + tItem[2]
							bExist = true
							break 
						end
					end

					if not bExist then 
						table.insert(tEquipProperty, tItem)
					end
				end
			end
		end
	end
	for i = 1, #tEquipProperty do
		tEquipProperty[i][2] = math.ceil(tEquipProperty[i][2])
	end

	table.sort(tEquipProperty, function (a,b)
		-- body
		return a[1] < b[1]
	end)

	return tEquipProperty
end

--@brief 	获取某一种宝石最大等级
function WndDressCastSoul:getMaxLevelByItemId(itemId)
	-- body
	local maxLevel = 0
	local nType = 0
	if self.m_nTabIndex == 3 then 
		nType = 1
	end
	for i, value in pairs(GDatatab_spirit) do
		if value.type == nType and value.item_id == itemId and value.level > maxLevel then 
			maxLevel = value.level 
		end
	end

	return maxLevel 
end

--@brief 	获取某列元魂的等级
function WndDressCastSoul:judgeOpenResponseGrid(index, openConfig)
	local tGridSoul = nil 
	if self.m_nTabIndex == 1 then 
		tGridSoul = self.m_tSuitSoulList
	elseif self.m_nTabIndex == 2 then 
		tGridSoul = self.m_tWingSoulList
	elseif self.m_nTabIndex == 3 then 
		tGridSoul = self.m_tTitleSoulList
	end

	local bIsOpen = true 
	for i = 1, 3 do
		local nIndex = (index - 1) * 3 + i 
		if tGridSoul[nIndex] and tGridSoul[nIndex].soulId and tGridSoul[nIndex].soulId > 0 then 
			local levelInfo = GDatatab_spirit["id_" .. tGridSoul[nIndex].soulId]
			if levelInfo == nil or levelInfo.level < openConfig then 
				bIsOpen = false 
				break 
			end
		else
			bIsOpen = false 
			break 
		end
	end

	return bIsOpen 
end
-------------------------------------私有方法模块End----------------------------------------
