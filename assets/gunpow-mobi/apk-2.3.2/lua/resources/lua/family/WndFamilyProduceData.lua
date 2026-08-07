--WndFamilyProduceData.lua
--@brief	WndFamilyProduce的数据模块
--@date		2018/02/06
--@author	Tianxiang_Xu
--@note		家园打工和看守界面

WndFamilyProduce = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFamilyProduce:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLeftTabIndex = nil 
	self.m_tFoodData = nil 				--食物Id
	self.m_tFoodPosition = {{0.5,0.87}, {0.5,0.635}, {0.5,0.395}, {0.5,0.155}}
	self.m_tEffectPosition = {{0.5,0.87}, {0.5,0.635}, {0.5,0.395}, {0.5,0.155}}
	self.m_nFoodSelIndex = 1
	self.m_tWorkEffect = nil 
	self.m_nProtectIndex = 1 	--看守界面看守兽特性和喂食界面标记：1->特性;2->喂食
	self.m_nCurWorkEffectIndex = 1 		--下一个开始打工的宠物的打工效率
	self.m_nCurLuckyValue = 0 			--当前幸运值
	self.m_nMaxLuckyValue = 100 
	self.m_nCurUpEffectCount = 1 		--当前提高效率次数
	self.m_nMaxEffectCostCount = 1 		--配置的最大的提升效率次数
	self.m_tMountsList = nil 			--守卫兽列表
	self.m_nMountSelId = nil 				--选中的守卫兽的Id
	self.m_tClickMountCell = nil 		--选中的守卫兽Cell
	self.m_tClickPetCell = nil 		--选中的宠物Cell
	self.m_nPetSelId = nil 			--选中的宠物标识
	self.m_tAddMorePetData = nil 	--更多打工宠物配置
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFamilyProduce:_unInit()
	self.m_root = nil
	self.m_nLeftTabIndex = nil 
	self.m_tFoodData = nil 
	self.m_tFoodPosition = nil 
	self.m_nFoodSelIndex = nil 
	self.m_tWorkEffect = nil 
	self.m_nProtectIndex = nil 
	self.m_nCurWorkEffectIndex = nil 
	self.m_nCurLuckyValue = nil 
	self.m_nMaxLuckyValue = nil 
	self.m_nCurUpEffectCount = nil 
	self.m_nMaxEffectCostCount = nil 
	self.m_tMountsList = nil 			--守卫兽列表
	self.m_nMountSelId = nil 
	self.m_tClickMountCell = nil 
	self.m_tClickPetCell = nil
	self.m_nPetSelId = nil
	self.m_tAddMorePetData = nil 	--更多打工宠物配置
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFamilyProduce:createElement()
	if WndFamilyProduce.m_root ~= nil then
		WindowManager:removeWindow(WndFamilyProduce.m_root, WndFamilyProduce, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFamilyProduce")
	assert(element, "WndFamilyProduce create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndFamilyProduce:showInterface(nTab)
	-- body
	local wndProduce = WndFamilyProduce:createElement()
	if wndProduce then
		self.m_nLeftTabIndex = nTab or 0
		WindowManager:addWindow(wndProduce, WndFamilyProduce, nil, nil, nil, true)
	end
end

--@brief 	守卫兽列表
function WndFamilyProduce:setMountData()
	-- body
	self.m_tMountsList = {}

	self.m_nMountSelId = SceneFamily.m_nProtectMountId > 0 and SceneFamily.m_nProtectMountId or nil 
	for i, v in pairs(GDatatab_guardromon) do
		local tItem = {}
		tItem.id = v.id
		tItem.item_id = v.item_id
		tItem.name = v.name
		tItem.type = v.type
		tItem.value = v.value
		tItem.time = v.time
		tItem.zoom = v.zoom
		tItem.basicInfo = GDatatab_item["id_" .. tItem.item_id]
		if self.m_nMountSelId == nil then
			self.m_nMountSelId = tItem.id
		end

		table.insert(self.m_tMountsList, tItem)
	end

	local buildingLevel = SceneFamily:getBuildingLevel(1, 7)
	local function getMountState(a)
		-- body
		if a.id == SceneFamily.m_nProtectMountId then
			return 1
		elseif a.type > buildingLevel then
			return 2
		else
			return 0
		end
	end

	table.sort(self.m_tMountsList, function (a,b)
		-- body
		local stateA = getMountState(a)
		local stateB = getMountState(b)
		if stateA ~= stateB then
			return stateA < stateB
		else
			if a.type ~= b.type then
				return a.type < b.type
			elseif a.basicInfo.quality ~= b.basicInfo.quality then
				return a.basicInfo.quality < b.basicInfo.quality
			else
				return a.id < b.id
			end
		end
	end)
end
function WndFamilyProduce:GetAllPetListOk(itemId, name, icon, animation, advancedLevel, upgradeLevel, property, giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId, num, petExp, fighting, birthSkill, skill, petSkinItemId, fetterStatus)
	SceneFamily:_stopLoading()

	if playerPetId ~= nil and #playerPetId > 0 then
        CacheCenter:clearPlayerPetInfo()
        for i = 1, #playerPetId do
           CacheCenter:addPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill[i], petSkinItemId[i], fetterStatus[i])
        end
	end

	if self.m_nLeftTabIndex == 0 then
    	self:generalPetList()
    	WZLog("WndFamilyProduce:GetAllPetListOk", Serialize(self.m_tPetsList))
    	self:_showPetList()
    end
end

--@brief 	提高打工效率结果
function WndFamilyProduce:changeEffectOK(nCurWorkEffectIndex, nCurLuckyValue, nCount)
	-- body
	self.m_nCurUpEffectCount = nCount + 1
	self.m_nCurLuckyValue = nCurLuckyValue
	if nCurWorkEffectIndex > self.m_nCurWorkEffectIndex then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT58)
	else
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT59)
	end
	self.m_nCurWorkEffectIndex = nCurWorkEffectIndex

	self:setWorkEffect()
end

--@brief 	物品数据更新
function WndFamilyProduce:updatePlayerItemData()
	--body
	if self.m_root == nil then return end

	self:_showFood()
end

--@brief 	增加打工宠物上限成功
function WndFamilyProduce:addMaxPetNumOK(num)
	-- body
	SceneFamily:_stopLoading()
	SceneFamily:setMaxPetNum(num)

	--更新数量
	self:setPetUseNum()
end

--@brief 	获取打工效率数据成功
function WndFamilyProduce:getWorkDataOK(status, efficiency, bless, refreshTime)
	-- body
	WZLog("WndFamilyProduce:getWorkDataOK", refreshTime, efficiency, bless, status)
	self.m_nCurUpEffectCount = refreshTime + 1
	self.m_nCurWorkEffectIndex = efficiency
	self.m_nCurLuckyValue = bless 

	if status == 1 then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT58)
	elseif status == 2 then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT59)
	elseif status == 3 then
	elseif status == 4 then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT41)
	end

	self:setWorkEffect()
end

--@brief 	开始打工成功返回后重新设置选中的打工宠物
function WndFamilyProduce:resetSelPet()
	-- body
	if self.m_root == nil then return end 

	self.m_nPetSelId = nil
	self.m_tClickPetCell = nil 

	self:generalPetList()
	WZLog("WndFamilyProduce:resetSelPet", Serialize(self.m_tPetsList))
	self:_showPetList()
end

--@brief 	看守成功后重新设置看守兽数据
function WndFamilyProduce:resetProtectMountData()
	-- body
	if self.m_root == nil then return end 
	
	self:setMountData()

	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	从物品表中获取喂食看守兽的粮食Id
function WndFamilyProduce:_getFoodData()
	-- body
	local nCount = 0 
	if self.m_tFoodData == nil then
		self.m_tFoodData = {}
		for i, value in pairs(GDatatab_item) do
			if value.main_type == 2 and value.sub_type == 20 then
				table.insert(self.m_tFoodData, value)

				nCount = nCount + 1
			end

			if nCount >= 4 then
				break 
			end
		end
	end

	table.sort(self.m_tFoodData, function (a,b)
		-- body
		return a.value < b.value
	end)
end

--@brief 获取提高效率花费
function WndFamilyProduce:_getUpEffectCost()
	-- body
	local nCount = self.m_nCurUpEffectCount
	if nCount > self.m_nMaxEffectCostCount then
		nCount = self.m_nMaxEffectCostCount
	end

	for i, value in pairs(GDatatab_vip_restriction) do
		if value.type == 25 and value.count == nCount then
			return value.cost[1]
		end
	end
end

--@brief 	提高效率的最大次数
function WndFamilyProduce:_getUpEffectMaxCount()
	-- body
	local nMaxCount = 0

	for i, value in pairs(GDatatab_vip_restriction) do
		if value.type == 25 and value.count > nMaxCount then
			nMaxCount = value.count
		end
	end

	return nMaxCount
end

--@brief 	根据id获取守护兽数据
function WndFamilyProduce:_getProtectMountData(id)
	-- body
	for i = 1, #self.m_tMountsList do
		if self.m_tMountsList[i].id == id then
			return self.m_tMountsList[i]
		end
	end

	return nil
end

--@brief 	根据坐骑物品id获取守护兽数据
function WndFamilyProduce:_getProtectMountDataByItemId(itemId)
	-- body
	for i = 1, #self.m_tMountsList do
		if self.m_tMountsList[i].item_id == itemId then
			return self.m_tMountsList[i]
		end
	end

	return nil
end

--@brief 	获取开启下一个打工宠物的配置数据
function WndFamilyProduce:getNextMorePetNumData(nCurNum)
	-- body
	for i = 1, #self.m_tAddMorePetData do
		if self.m_tAddMorePetData[i].num == nCurNum + 1 then
			return self.m_tAddMorePetData[i]
		end
	end

	return nil 
end

--@brief 	生成打工宠物列表
function WndFamilyProduce:generalPetList()
	-- body
	self.m_tPetsList = {}
	local tTempData = CopyTable(CacheCenter:getPlayerPetInfo())

	for i = 1, #tTempData do
		local tItem = {}

		tItem.playerPetId = tTempData[i].playerPetId
		tItem.itemId = tTempData[i].itemId
		tItem.effectType = 1
		tItem.leftTime = 0
		tItem.canSteal = 0
		tItem.icon = tTempData[i].icon
		tItem.animation = tTempData[i].animation
		tItem.advancedLevel = tTempData[i].advancedLevel
		tItem.name = tTempData[i].name
		tItem.useIndex = 0 			--0:空闲;1：使用中

		table.insert(self.m_tPetsList, tItem)
	end

	for i = 1, #SceneFamily.m_tWorkerData do
		local bFind = false 
		for j = 1, #self.m_tPetsList do
			if SceneFamily.m_tWorkerData[i].playerPetId == self.m_tPetsList[j].playerPetId then
				self.m_tPetsList[j].useIndex = 1
				bFind = true
				break 
			end
		end

		if not bFind then
			local tItem = CopyTable(SceneFamily.m_tWorkerData[i])
			tItem.useIndex = 1
			table.insert(self.m_tPetsList, tItem)
		end
	end

	table.sort(self.m_tPetsList, function (a,b)
		-- body
		if a.useIndex ~= b.useIndex then
			return a.useIndex < b.useIndex 
		else
			return a.itemId > b.itemId
		end
	end)
end
-------------------------------------私有方法模块End----------------------------------------
