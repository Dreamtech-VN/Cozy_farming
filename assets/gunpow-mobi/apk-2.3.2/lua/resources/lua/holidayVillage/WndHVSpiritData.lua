--WndHVSpiritData.lua
--@brief	WndHVSpirit的数据模块
--@date		2023/01/03
--@author	yrd
--@note		度假村-精灵界面

WndHVSpirit = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVSpirit:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nWinType = 1					--界面类型 1主界面 2升级界面 3进阶界面
	self.m_tStoreData = nil 			--仓库数据
	self.m_nW1SpiritHunger = 50 		--常量,小于值时显示饥饿对话框

	self.m_nW1CurPage = 1				--当前页数
	self.m_nW1CurSel = 1				--当前选中
	self.m_nW1ShowNum = 5				--一页显示精灵栏数量

	self.m_nW2CostSelIdx = 1 			--升级时选中的消耗物品索引
	self.m_tW2CostObjList = nil 		--升级界面消耗物品对象
	self.m_tW2CostDataList = nil 		--升级界面消耗物品数据
	self.m_nW2QuickUpgrade = 0			--升级界面是否勾选"训练至升级" 0未勾选 1勾选

end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVSpirit:_unInit()
	self.m_root = nil
	self.m_nWinType = nil				--界面类型 1主界面 2升级界面 3进阶界面
	self.m_tStoreData = nil 			--仓库数据
	self.m_nW1SpiritHunger = nil 		--常量,小于值时显示饥饿对话框

	self.m_nW1CurPage = nil				--当前页数
	self.m_nW1CurSel = nil				--当前选中
	self.m_nW1ShowNum = nil				--一页显示精灵栏数量

	self.m_nW2CostSelIdx = nil 			--升级时选中的消耗物品索引
	self.m_tW2CostObjList = nil 		--升级界面消耗物品对象
	self.m_tW2CostDataList = nil 		--升级界面消耗物品数据
	self.m_nW2QuickUpgrade = nil		--升级界面是否勾选"训练至升级" 0未勾选 1勾选
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVSpirit:createElement()
	if WndHVSpirit.m_root ~= nil then
		WindowManager:removeWindow(WndHVSpirit.m_root, WndHVSpirit, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVSpirit")
	assert(element, "WndHVSpirit create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVSpirit:showInterface()
	local wndhv = WndHVSpirit:createElement()
	if wndhv then 
		WindowManager:addWindow(wndhv, WndHVSpirit, false, nil, nil, true)
	end
end



--@brief 	获取仓库数据
function WndHVSpirit:setStoreData(warehouseType, itemIds, nums, synType)
	if not self.m_root then return end

	if warehouseType == 2 then 
		if synType == 0 then 
			self.m_tStoreData = {}
			for i = 1, #itemIds do
				local tItem = {}
				tItem.id = itemIds[i]
				tItem.num = nums[i]

				table.insert(self.m_tStoreData, tItem)
			end
		elseif synType == 1 or synType == 2 then 
			if self.m_tStoreData == nil then self.m_tStoreData = {} end 

			for i = 1, #itemIds do
				local bExist = false 
				for j = 1, #self.m_tStoreData do
					if self.m_tStoreData[j].id == itemIds[i] then 
						self.m_tStoreData[j].num = nums[i]
						bExist = true 
						break 
					end
				end
				if not bExist then 
					local tItem = {}
					tItem.id = itemIds[i]
					tItem.num = nums[i]

					table.insert(self.m_tStoreData, tItem)
				end
			end
		elseif synType == 3 then 
			if self.m_tStoreData == nil then self.m_tStoreData = {} return end 

			for i = 1, #itemIds do
				for j = 1, #self.m_tStoreData do
					if self.m_tStoreData[j].id == itemIds[i] then 
						table.remove(self.m_tStoreData, j)
						break 
					end
				end
			end
		end
	end
end

--@brief 	根据物品id获取仓库中物品数量
function WndHVSpirit:getItemCountByItemId(id)
	local nNum = 0 
	if self.m_tStoreData == nil then return nNum end 

	for i = 1, #self.m_tStoreData do
		if self.m_tStoreData[i].id == id then
			nNum = self.m_tStoreData[i].num 
			break 
		end
	end

	return nNum
end


--@brief 	精灵详细数据
function WndHVSpirit:getSpiritDetailOK(synType, playerId, index, status, spiritId, satiety, level, exp, step)
	if self.m_root == nil then
		return
	end

	self.playerId = playerId

	if self.m_nWinType == 2 then
		local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
		for i=1,#index do
			if spiritId[i] == self.m_tData[nDataIdx].spiritId then
				self.m_nW2FinalyLevel = level[i]
				self.m_nW2FinalyExp = exp[i]
				self.m_nW2AddTotalExp = self:getExpGap(self.m_tData[nDataIdx].spiritId, self.m_tData[nDataIdx].level, self.m_tData[nDataIdx].exp, level[i], exp[i])
				if self.m_nW2AddTotalExp > 0 then
					self:showW2Progress()
					return
				end
				break
			end
		end
	end

	if synType == 0 then
		self.m_tData = {}
		for i=1,#index do
			local tempData = {}
			tempData.status = status[i]
			tempData.spiritId = spiritId[i]
			tempData.satiety = satiety[i]
			tempData.level = level[i]
			tempData.exp = exp[i]
			tempData.step = step[i]
			self.m_tData[index[i]+1] = tempData
		end
	elseif synType == 2 then
		local tempData = {}
		tempData.status = status[1]
		tempData.spiritId = spiritId[1]
		tempData.satiety = satiety[1]
		tempData.level = level[1]
		tempData.exp = exp[1]
		tempData.step = step[1]
		self.m_tData[index[1]+1] = tempData
	end

	self:updateWin1()
	if self.m_nWinType == 2 then
		self:updateWin2()
	elseif self.m_nWinType == 3 then
		self:updateWin3()
	end
end


--@brief 	获取等级信息
function WndHVSpirit:getSpiritLevel(nSpiritId,nLevel)
	local tSpiritLevel = nil
	for k,v in pairs(GDatatab_holiday_spirit_upgrade) do
		if v.spirit_id == nSpiritId and v.level == nLevel then
			tSpiritLevel = CopyTable(v)
			break
		end
	end
	return tSpiritLevel
end

--@brief 	获取进阶信息
function WndHVSpirit:getSpiritStep(nSpiritId,nStep)
	local tSpiritStep = nil
	for k,v in pairs(GDatatab_holiday_spirit_step) do
		if v.spirit_id == nSpiritId and v.step == nStep then
			tSpiritStep = CopyTable(v)
			break
		end
	end
	return tSpiritStep
end

--@brief 	进阶界面选中的
function WndHVSpirit:getW4RecoveryItem()
	local nDataIdx = self.m_nW1ShowNum * (self.m_nW1CurPage - 1) + self.m_nW1CurSel
	local tItemList = {}
	--本身
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tData[nDataIdx].spiritId]
	table.insert(tItemList, {tSpiritInfo.item_id, 1})
	--进阶消耗
	for key,value in pairs(GDatatab_holiday_spirit_step) do
		if value.spirit_id == self.m_tData[nDataIdx].spiritId and value.step < self.m_tData[nDataIdx].step then
			if type(value.cost) == "table" then
				for i=1,#value.cost do
					table.insert(tItemList, value.cost[i])
				end
			end
			if type(value.cost1) == "table" then
				for i=1,#value.cost1 do
					table.insert(tItemList, value.cost1[i])
				end
			end
		end
	end
	--升级消耗
	local nTotalExp = self.m_tData[nDataIdx].exp
	for key,value in pairs(GDatatab_holiday_spirit_upgrade) do
		if value.spirit_id == self.m_tData[nDataIdx].spiritId and value.level < self.m_tData[nDataIdx].level then
			nTotalExp = nTotalExp + value.exp
		end
	end

	nTotalExp = math.floor(nTotalExp * tonumber(CacheCenter:getGameParam().holidaySpiritExpReturn) / 100)
	--升级道具 返回一定百分比
	if self.m_tW2CostDataList == nil then
		self:initW2CostData()
	end
	local tCostList = self.m_tW2CostDataList

	for i=#tCostList,1,-1 do
		local tempNum = math.floor(nTotalExp / tCostList[i].value)
		if tempNum > 0 then
			local tempData = {}
			tempData[1] = tCostList[i].id
			tempData[2] = tempNum
			table.insert(tItemList, tempData)
			nTotalExp = nTotalExp % tCostList[i].value
		end
	end
	-- if nTotalExp > 0 then
	-- 	table.insert(tItemList, {tCostList[1].id, 1})
	-- end
	tItemList = consolidateItemData(tItemList)
	return tItemList
end

function WndHVSpirit:spiritUpgradeOK()
	-- MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[20])
end

function WndHVSpirit:spiritStepOK()
	-- MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[21])
end

function WndHVSpirit:spiritFeedOK()
	-- MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[22])
end

function WndHVSpirit:recoverySpiritOK(itemIds, itemNums)
	-- MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[16])
	if self.m_root == nil then
		return
	end
	if itemIds and itemNums then
		WndRewardShow:showById(itemIds, itemNums)
	end
end

function WndHVSpirit:activationSpiritSlotOK()
	MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[17])
end

function WndHVSpirit:activationSpiritOK()
	MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[18])
end


--@brief 	计算相差多少经验
function WndHVSpirit:getExpGap(spiritId, curLvl, curExp, nextLvl, nextExp)
	local nTotalExp = 0
	for i = curLvl, nextLvl-1 do
		for k,v in pairs(GDatatab_holiday_spirit_upgrade) do
			if v.spirit_id == spiritId and v.level == i then
				nTotalExp = nTotalExp + v.exp
				break
			end
		end
	end
	nTotalExp = nTotalExp + nextExp - curExp
	return nTotalExp
end

--@brief 	获取精灵数据
function WndHVSpirit:getSpiritData()
	return self.m_tData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------
