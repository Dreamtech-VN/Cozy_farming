--WndHVDivineTreeData.lua
--@brief	WndHVDivineTree的数据模块
--@date		2023/06/06
--@author	XTX
--@note		度假村-精灵神树

WndHVDivineTree = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVDivineTree:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tItemIdList = {161079, 161080, 161081}
	self.m_tItemCell = nil 
	self.m_tDivineTreeInfo = nil 
	self.m_nMaxLevel = nil 
	self.m_tSelCell = nil 
	self.m_nClickPos = nil 		--点击的果实坑
	self.m_tCurLvConfig = nil 	--当前等级配置
	self.m_nLeftSeconds = nil 	--神树离下一次升级还剩多少时间
	self.m_nUseItemIndex = 0 	--
	self.m_nTouchStartTime = nil 
	self.m_nodeImage = nil 
	self.m_nodeTreeCon = nil 
	self.m_tRectRange = nil 	--果实坑位；树根矩形
	self.m_tFruitPos = {{{0.364,0.68}}, {{0.211,0.635}, {0.4,0.8}, {0.59,0.706}}, {{0.211,0.635}, {0.339,0.794}, {0.51,0.693}, {0.66,0.76}, {0.771,0.606}}}
	self.m_tTouchStartPos = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVDivineTree:_unInit()
	self.m_root = nil
	self.m_tItemIdList = nil 
	self.m_tItemCell = nil 
	self.m_tDivineTreeInfo = nil 
	self.m_nMaxLevel = nil 
	self.m_tSelCell = nil 
	self.m_nClickPos = nil 
	self.m_tCurLvConfig = nil 
	self.m_nLeftSeconds = nil 
	self.m_nUseItemIndex = nil 
	self.m_nTouchStartTime = nil 
	self.m_nodeImage = nil 
	self.m_nodeTreeCon = nil 
	self.m_tRectRange = nil 	--果实坑位；树根矩形
	self.m_tFruitPos = nil
	self.m_tTouchStartPos = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVDivineTree:createElement()
	if WndHVDivineTree.m_root ~= nil then
		WindowManager:removeWindow(WndHVDivineTree.m_root, WndHVDivineTree, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVDivineTree")
	assert(element, "WndHVDivineTree create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVDivineTree:showInterface()
	local wndWater = WndHVDivineTree:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndHVDivineTree, false, nil, nil, true)
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndHVDivineTree:updatePlayerItemData()
	WZLog("WndHVDivineTree:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_createItemList(true)
	end
end

--@brief 	选中列表某项回调
function WndHVDivineTree:selectCallBack(tCell)
	-- body
	if self.m_tSelCell == nil then 
		self.m_tSelCell = tCell
	else
		self.m_tSelCell:setSelectState(false)
		self.m_tSelCell = tCell
	end

	self.m_tSelCell:setSelectState(true)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取神树信息
function WndHVDivineTree:_getDivineInfo(lvl, exp, index, ids, endTimes)
	local bIsNeedUpdate = false 
	if self.m_tDivineTreeInfo then 
		if lvl ~= self.m_tDivineTreeInfo.level then 
			local curLvConfig = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
			local nextLvConfig = SceneHolidayVillage:getDivineTreeConfigByLv(lvl)
			if curLvConfig.action ~= nextLvConfig.action then 
				bIsNeedUpdate = true 
			end
		end
	else
		bIsNeedUpdate = true
	end
	self.m_tDivineTreeInfo = {}
	self.m_tDivineTreeInfo.level = lvl
	self.m_tDivineTreeInfo.curExp = exp 
	self.m_tDivineTreeInfo.fruits = {}
	for i = 1, #index do
		local tItem = {}
		tItem.posIndex = index[i]
		tItem.fruitId = ids[i]
		tItem.endTime = endTimes[i]

		table.insert(self.m_tDivineTreeInfo.fruits, tItem)
	end

	local spineTree = GetElement(self.m_root, "spineTree_WndHVDivineTree", WZUISpine)
	if bIsNeedUpdate then 
		local levelConfig = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
		if levelConfig then 
			local actionName = levelConfig.action
			spineTree:play(actionName, true)
			local nIndexPos = 1
			if actionName == "Ss1_wait_1" then 
				nIndexPos = 1
			elseif actionName == "Ss2_wait_1" then 
				nIndexPos = 2
			elseif actionName == "Ss3_wait_1" then 
				nIndexPos = 3
			end

			local tTempPos = self.m_tFruitPos[nIndexPos]
			local posCount = #tTempPos
			for i = 1, 5 do
				local conFruit = GetElement(self.m_root, "conFruit" .. i .. "_WndHVDivineTree", WZUIContainer)
				if i > posCount then 
					conFruit:setVisible(false)
				else
					conFruit:setVisible(true)
					conFruit:setRelativePosition(GlobalMethod:ccp(tTempPos[i][1], tTempPos[i][2]))
				end
			end
			self:getCollectRect()
		end
	end

	self:_update()
end

--@brief 	获取某个坑开启等级
function WndHVDivineTree:getOpenLevel(posIndex)
	local level = nil 
	for i, value in pairs(GDatatab_holiday_tree_lvl) do
		if level == nil and value.num >= posIndex then 
			level = value.lvl
		elseif value.num >= posIndex and level > value.lvl then 
			level = value.lvl
		end
	end

	return level
end

--@brief 	获取神树最高等级
function WndHVDivineTree:getDivineTreeMaxLv()
	local level = 0 
	for i, value in pairs(GDatatab_holiday_tree_lvl) do
		if level < value.lvl then 
			level = value.lvl
		end
	end

	return level
end

--@brief 	获取神树当前等级升到下一级的经验上限
function WndHVDivineTree:getUpgradeExp()
	local level = self.m_tDivineTreeInfo.level 
	for i, value in pairs(GDatatab_holiday_tree_lvl) do
		if level == value.lvl then 
			return value
		end
	end
end

--@brief 	选择果实回调
function WndHVDivineTree:_chooseFruit(opType, fruitId, index, itemId, num)
	local conFruit = GetElement(self.m_root, "conFruit" .. (index + 1) .. "_WndHVDivineTree", WZUIContainer)
	local txtFruitState = GetElement(self.m_root, "txtFruitState" .. (index + 1) .. "_WndHVDivineTree", WZUILabelTTF)
	if opType == 1 then 
		local fruitData = GDatatab_holiday_tree_fruit["id_" .. fruitId]
		self.m_tDivineTreeInfo.fruits[index + 1].fruitId = fruitId
		local tCurLvData = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
		local nSeconds = math.ceil(fruitData.time * (1 - tCurLvData.addition/10000))
		self.m_tDivineTreeInfo.fruits[index + 1].endTime = SystemTime:getServerTime() + nSeconds
		-- if conFruit:getChildByTag(11) then 
		-- 	conFruit:removeChildByTag(11, true)
		-- end
		txtFruitState:setColor(GlobalMethod:ccc3(255,236,193))
		local strTime = returnToTimeFormat_Day(nSeconds, true)
		txtFruitState:setText(strTime .. "\n" .. LocalStrings.HOLIDAYVILLAGE_TEXT2[14])
		-- local element, tNewObj = CellGoodItem:createElement()
		-- if element and tNewObj then 
		-- 	element:setTag(11)
		-- 	element:setScale(0.5)
		-- 	tNewObj:setCellGoodLocalId(fruitData.itemId, fruitData.num, 15)
		-- 	tNewObj:setItemNumber(fruitData.num)
		-- 	conFruit:addChild(element)
		-- end
	elseif opType == 2 then 
		WndRewardShow:showById(itemId, num)

		if conFruit:getChildByTag(11) then 
			conFruit:removeChildByTag(11, true)
		end
		txtFruitState:setText("")
		self.m_tDivineTreeInfo.fruits[index + 1].fruitId = 0
		self.m_tDivineTreeInfo.fruits[index + 1].endTime = 0
	end
end

--@brief 	加速果实/果树回调
function WndHVDivineTree:_speedFruit(opType, itemId, itemNum, index)
	local basicData = GDatatab_item["id_" .. itemId]
	WZLog("WndHVDivineTree:_speedFruit", opType, itemId, itemNum, index)
	if opType == 1 then 
		local spineTree = GetElement(self.m_root, "spineTree_WndHVDivineTree", WZUISpine)
		local levelConfig = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
		if levelConfig then 
			local actionName = string.gsub(levelConfig.action, "_1", "_2")
			spineTree:play(actionName, false)
			spineTree:enableSchedule("switchTreeAni", 1)
		end

		local curLvConfig = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
		local addExp = math.floor(basicData.value * 1000/curLvConfig.exp[1][1]) * curLvConfig.exp[1][2]
	--	self.m_tDivineTreeInfo.curExp = self.m_tDivineTreeInfo.curExp + addExp 
		WZLog("WndHVDivineTree:_speedFruit", self.m_tDivineTreeInfo.curExp, addExp)
		if self.m_tDivineTreeInfo.level < self.m_nMaxLevel and self.m_tDivineTreeInfo.curExp >= curLvConfig.max then 
			-- self.m_tDivineTreeInfo.level = self.m_tDivineTreeInfo.level + 1
			-- self.m_tDivineTreeInfo.curExp = self.m_tDivineTreeInfo.curExp - curLvConfig.max
			-- ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_TreeDetails()
		elseif self.m_tDivineTreeInfo.curExp < curLvConfig.max then 
			-- local needExp = curLvConfig.max - self.m_tDivineTreeInfo.curExp
			-- self.m_nLeftSeconds = math.ceil(needExp/curLvConfig.exp[1][2]) * curLvConfig.exp[1][1]/1000
			-- self:_showTime()
		end
	elseif opType == 2 then 
		local txtFruitState = GetElement(self.m_root, "txtFruitState" .. (index + 1) .. "_WndHVDivineTree", WZUILabelTTF)
		local nCurTime = SystemTime:getServerTime()
	--	self.m_tDivineTreeInfo.fruits[index + 1].endTime = self.m_tDivineTreeInfo.fruits[index + 1].endTime - basicData.value
		if nCurTime >= self.m_tDivineTreeInfo.fruits[index + 1].endTime then 
			txtFruitState:setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[13])
			txtFruitState:setColor(GlobalMethod:ccc3(99,255,95))
		else
			local seconds = self.m_tDivineTreeInfo.fruits[index + 1].endTime - nCurTime
			local strTime = returnToTimeFormat_Day(seconds, true)
			txtFruitState:setColor(GlobalMethod:ccc3(255,236,193))
			txtFruitState:setText(strTime .. "\n" .. LocalStrings.HOLIDAYVILLAGE_TEXT2[14])
		end
	end
end

--@brief 	加速后切换会待机动作
function WndHVDivineTree:switchTreeAni(element)
	local spineTree = GetElement(self.m_root, "spineTree_WndHVDivineTree", WZUISpine)
	spineTree:disableSchedule()
	local levelConfig = SceneHolidayVillage:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
	if levelConfig then 
		local actionName = levelConfig.action
		spineTree:play(actionName, true)
	end

end
-------------------------------------私有方法模块End----------------------------------------
