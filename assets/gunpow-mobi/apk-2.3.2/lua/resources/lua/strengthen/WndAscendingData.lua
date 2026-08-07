--WndAscendingData.lua
--@brief	WndAscending的数据模块
--@date		2016/09/13
--@author	zsq
--@note		升阶系统

WndAscending = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAscending:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurTab = nil 
	self.m_nRightTab = 1
	self.m_tEquipBefore = nil
	self.m_tEquipAfter = nil
	self.m_tSelectedCell = nil
	self.m_bChecked = nil
	self.m_tAscending = nil
	self.m_tNeedM = nil
	self.m_tOwnM = nil
	self.m_tMId = nil
	self.m_nOwnM = nil
	self.m_bRunning = nil
	self.m_tBlessBagList = nil 
	self.m_tEquipList = nil 
	self.m_nLoadingId = nil 
	self.m_tFuseCellList = nil 
	self.m_tSelectedData = nil 
	self.m_tBeFusedId = nil 
    --self.m_nTempCurTab = nil 
	self.evoOrangePetNeedPetLevel = nil          --进化橙宠需要宠物等级
	self.evoOrangePetNeedAdLevel = nil           --进化橙宠需要宠物进阶等级
	self.m_tPet = nil							 --待进化的宠物
	self.m_nAfterPetId = nil 					 --宠物进化后的id
	self.m_tGetPetID = nil						--进化成功获得的宠物
	self.m_bPetInConfig = nil					 --宠物是否配置可进化
	self.m_tPet1 = nil				
	self.m_tPet2 = nil				
	self.m_tPet3 = nil				
	self.m_tPet4 = nil				
	self.m_tSelectedPet = nil

	self.m_nMountNeedUpgradeLv = nil
	self.m_nMountNeedAdvanceLv = nil
	self.m_tMount = nil
	self.m_tGetMountID = nil						--进化后的坐骑
	self.m_tSelectedMount = nil
    self.m_nCostId = nil 

    self.m_tPhantomList = nil 			--皮肤列表
    self.m_tPhantomData = nil 			--当前的皮肤数据
    self.m_tSelectedPhantom = nil

    self.m_tTitleBtn = {}				--左边标题按钮数据
    self.m_nCurUIId = 80 				--本界面对应功能开放表的id
    self.m_nMainIndex = 1
    self.m_nSubIndex = 1

    self.m_tEquiplObj = {}			--存放装备项

    self.m_tPetCellList = {} 					--宠物列表项对象
    self.m_tMountCellList = {} 					--坐骑列表项对象
    self.m_tPhantomCellList = {} 				--皮肤列表项对象

    self.m_tDressList = nil 			--时装列表
    self.m_tDressData = nil 			--当前的时装数据
    self.m_tDressCellList = {} 			--时装列表项对象
    self.m_tSelectedDress = nil 		--当前选中的时装
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAscending:_unInit()
	self.m_root = nil
	self.m_nCurTab = nil
	self.m_nRightTab = nil
	self.m_tEquipBefore = nil
	self.m_tEquipAfter = nil
	self.m_tSelectedCell = nil
	self.m_bChecked = nil
	self.m_tAscending = nil
	self.m_tNeedM = nil
	self.m_tOwnM = nil
	self.m_tMId = nil
	self.m_nOwnM = nil
	self.m_bRunning = nil
	self.m_tBlessBagList = nil 
	self.m_tEquipList = nil 
	self.m_nLoadingId = nil 
	self.m_tFuseCellList = nil 
	self.m_tSelectedData = nil 
	self.m_tBeFusedId = nil 
    self.m_nTempCurTab = nil 
	self.evoOrangePetNeedPetLevel = nil          --进化橙宠需要宠物等级
	self.evoOrangePetNeedAdLevel = nil           --进化橙宠需要宠物进阶等级
	self.m_tPet = nil							 --待进化的宠物
	self.m_nAfterPetId = nil 					 --宠物进化后的id
	self.m_tGetPetID = nil						--进化成功获得的宠物
	self.m_bPetInConfig = nil					 --宠物是否配置可进化
	self.m_tPet1 = nil				
	self.m_tPet2 = nil				
	self.m_tPet3 = nil				
	self.m_tPet4 = nil				
	self.m_tSelectedPet = nil

	self.m_nMountNeedUpgradeLv = nil
	self.m_nMountNeedAdvanceLv = nil
	self.m_tMount = nil
	self.m_tGetMountID = nil						--进化后的坐骑
	self.m_tSelectedMount = nil
    self.m_nCostId = nil 

    self.m_tPhantomList = nil
    self.m_tPhantomData = nil 
    self.m_tSelectedPhantom = nil 

    self.m_tTitleBtn = nil
    self.m_nCurUIId = nil
    self.m_nMainIndex = nil
    self.m_nSubIndex = nil

    self.m_tEquiplObj = nil

    self.m_tPetCellList = nil
    self.m_tMountCellList = nil
    self.m_tPhantomCellList = nil
    
    self.m_tDressList = nil 			--时装列表
    self.m_tDressData = nil 			--当前的时装数据
    self.m_tDressCellList = nil 		--时装列表项对象
    self.m_tSelectedDress = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAscending:createElement()
	local element = WZUISystem:getInstance():createElement("WndAscending")
	assert(element, "WndAscending create element failed!")
	self:_init()
	return element
end

-- time, bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel
function WndAscending:setData(time, bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel)
	local blessFighting = fightNum
	local equipRectId = num
    -- body
    --背包中的祝福
    local tBagList = {}
    for i = 0, bagIds:size() - 1 do
        local tTemp = {}
        tTemp.id = bagPrayIds:get(i)
        tTemp.blessId = bagIds:get(i)
        tTemp.curExp = bagExps:get(i)

        table.insert(tBagList, tTemp)
    end
    WndAscending:setBlessBagList(6, tBagList)
    --装备栏的数据
--    if self.m_tEquipList == nil then
        self.m_tEquipList = {}
--    end
--    WZLog("WndAscending:setData 111",equipRectId:size(), openlevel:size(), prayNum:size())
    for k = 0, equipRectId:size() - 1 do
        local tTemp = {}
        tTemp.openLevel = openlevel:get(k)
        --判断该装备栏是否开启
        if tTemp.openLevel <= CacheCenter:getPlayerInfo().level then
            tTemp.status = 0
        else
            tTemp.status = -1
        end
        for l = 0, prayNum:size() - 1 do 
            local id = equipPrayId:get(l)
            local tData = CopyTable(GDatatab_pray["id_"..id])
            tData.basicInfo = CopyTable(GDatatab_item["id_"..tData.item_id])
            tData.userType = 6
            tData.curExp = equipExp:get(l)
            tData.blessId = equipId:get(l)
            if equipRectId:get(k) == prayNum:get(l) then
                tTemp.status = 1
                tTemp.tData = tData
            end
        end

        table.insert(self.m_tEquipList, tTemp)
    end

    self:_stopLoading()
--    WZLog("WndAscending:setData ****", #self.m_tEquipList, Serialize(self.m_tEquipList), equipRectId:size())

    self:_initEquipListByTag(nil, 1)
end

function WndAscending:setResetData(bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum)
	self:_stopLoading()
    self:playSound()
	GetElement(self.m_root,"ani3",WZUISpine):setVisible(true)
	GetElement(self.m_root,"ani3",WZUISpine):play("3", false)
	
	--背包中的祝福
    local tBagList = {}
    for i = 0, bagIds:size() - 1 do
        local tTemp = {}
        tTemp.id = bagPrayIds:get(i)
        tTemp.blessId = bagIds:get(i)
        tTemp.curExp = bagExps:get(i)

        table.insert(tBagList, tTemp)
    end
    WndAscending:setBlessBagList(6, tBagList)

--    WZLog("WndAscending:setResetData ****", #self.m_tEquipList, Serialize(self.m_tEquipList))
    for k = 1, #self.m_tEquipList do
        --判断该装备栏是否开启
        if self.m_tEquipList[k].status >= 0 then
            self.m_tEquipList[k].status = 0
        end
        for l = 0, prayNum:size() - 1 do 
            local id = equipPrayId:get(l)
            local tData = CopyTable(GDatatab_pray["id_"..id])
            tData.basicInfo = CopyTable(GDatatab_item["id_"..tData.item_id])
            tData.userType = 6
            tData.curExp = equipExp:get(l)
            tData.blessId = equipId:get(l)
            if k == prayNum:get(l) then
                self.m_tEquipList[k].status = 1
                self.m_tEquipList[k].tData = tData
                break
            end
        end
    end

    --如果背包打开，刷新背包数据
    if WndBlessBag.m_root then 
        WndBlessBag:setBlessItemList( fightNum, CopyTable(self.m_tBlessBagList), CopyTable(self.m_tEquipList))
    end
    self.m_root:enableSchedule("sendProtocol3", 1.5)
end

--@brief	发送协议
function WndAscending:sendProtocol3()
	self.m_root:disableSchedule()

	self:_cleanFuseGrid()
    self:_initEquipListByTag()
end
--@brief    设置背包祈福数据
--@param    userType :用户定义的类型：2：在背包
--@param    tDataList:服务器传过来的数据
function WndAscending:setBlessBagList(userType, tDataList)
    -- body
    self.m_tBlessBagList = {}

    for i = 1, #tDataList do
        local tTemp = CopyTable(GDatatab_pray["id_"..tDataList[i].id])
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id])
        tTemp.userType = userType
        tTemp.blessId = tDataList[i].blessId
        tTemp.curExp = tDataList[i].curExp
        if tTemp then
            table.insert(self.m_tBlessBagList, tTemp)
        end
    end

--    WZLog("WndAscending:setBlessBagList", Serialize(self.m_tBlessBagList))
end

--@brief     获取宠物列表成功
function WndAscending:GetAllPetListOk(itemId, name, icon,animation, advancedLevel, upgradeLevel, property, giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
	if self.m_root == nil then return end 
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
  	WZLog("WndAscending:GetAllPetListOk:",Serialize(itemId))
	if playerPetId ~= nil and #playerPetId > 0 then
        CacheCenter:clearPlayerPetInfo()
        for i=1,#playerPetId do
           CacheCenter:addPlayerPetInfo(itemId[i], name[i], icon[i],animation[i],advancedLevel[i],upgradeLevel[i] ,property[i],giftSkill[i], commonSkill1[i], commonSkill2[i], isInUsed[i], playerPetId[i],num[i],petExp[i],fighting[i],birthSkill[i],skill[i], petSkinItemId[i], fetterStatus[i])
        end
        table.sort(CacheCenter:getPlayerPetInfo(),sortPets)
	end

	--如果在宠物进化界面，刷新列表
	WndAscending:updatePetList()
end

--@brief 	获取皮肤列表数据成功
function WndAscending:updatePhantomData()
	-- body
	if self.m_root == nil then return end 

	self.m_tPhantomList = {}
	local needAdvancedLevel = tonumber(CacheCenter:getGameParam()["skinQualityNeedAdvanceLv"]) or 6

	for i = 1, #WndPhantom.m_tDataList do
		local tData1 = GDatatab_shape_skins["id_" .. WndPhantom.m_tDataList[i].shapeId]
		tData1.own = true
		tData1.remainTime = WndPhantom.m_tDataList[i].remainTime
		tData1.curProperty = WndPhantom.m_tDataList[i].curProperty
		tData1.advancedLevel = WndPhantom.m_tDataList[i].advancedLevel
		tData1.blessingValue = WndPhantom.m_tDataList[i].blessingValue
		tData1.fighting = WndPhantom.m_tDataList[i].fighting
		tData1.activeRefineStatus = WndPhantom.m_tDataList[i].activeRefineStatus
		tData1.refineStatus = WndPhantom.m_tDataList[i].refineStatus
		tData1.refineProperty = WndPhantom.m_tDataList[i].refineProperty
		tData1.refinePropertySum = WndPhantom.m_tDataList[i].refinePropertySum
		if tData1.id == CacheCenter:getPlayerInfo().shapeId then
			tData1.use = true
		end
		if tData1.quality == 4 and tData1.advancedLevel >= needAdvancedLevel and tData1.sp_cost ~= -1 then 
			table.insert(self.m_tPhantomList, tData1)
		end
	end

--	WZLog("WndPhantom:setData", Serialize(self.m_tPhantomList))

	self:updatePhantomList()
end

--@brief 	设置可进阶的时装列表数据
function WndAscending:setDressData()
	-- body
	if self.m_root == nil then return end 
	if self.m_nCurTab ~= 7 then return end 

	self.m_tDressList = {}

	local havedAdvanceIds = CacheCenter:getDressAdvanceId()
	local configIds = CacheCenter:getAllConfigDressAdvanceIds()
	local nSex = CacheCenter:getPlayerInfo().sex
	--根据property3和cost字段取配置了非-1的数据
	--同时要拥有整套时装所有部件的永久时效才可显示在进阶列表
	for i = 1, #configIds do
		local value = GDatatab_enchanting["id_" .. configIds[i]]
		if not utilsValueInTable(value.id, havedAdvanceIds) then 
			local itemIds = value.item_id1[1] 
			if nSex == 1 then 
				itemIds = value.item_id2[1]
			end
			local bAdd = true 
			local copyValue = CopyTable(value)
			for j = 1, #itemIds do
				local lastTime = CacheCenter:getPlayerItemCountById(itemIds[j])
				if lastTime >= 0 then 
					bAdd = false 
					break 
				end
				local basicInfo = GDatatab_item["id_" .. itemIds[j]]
				if basicInfo and basicInfo.sub_type == 2 then 
					copyValue.bodyId = itemIds[j]
					copyValue.bodyQuality = basicInfo.quality
					copyValue.subType = basicInfo.sub_type
					break 
				end
			end
			if bAdd then 
				table.insert(self.m_tDressList, copyValue)
			end
		end
	end
	--排序 品质降序，id降序
	table.sort(self.m_tDressList, function (a, b) if a.bodyQuality ~= b.bodyQuality then return a.bodyQuality > b.bodyQuality else return a.bodyId > b.bodyId end end )
	--可进阶的翅膀
	local havedAdvanceWingIds = CacheCenter:getWingAdvanceId()
	local configWingIds = CacheCenter:getAllConfigWingAdvanceIds()
	local tTempWingsList = {}
	--根据wing_property和wing_cost字段取配置了非-1的数据
	--同时要拥有整套时装所有部件的永久时效才可显示在进阶列表
	for i = 1, #configWingIds do
		local value = GDatatab_enchanting["id_" .. configWingIds[i]]
		if not utilsValueInTable(value.id, havedAdvanceWingIds) then 
			local itemId = value.item_id3
			local bAdd = true 
			local copyValue = CopyTable(value)
			
			local lastTime = CacheCenter:getPlayerItemCountById(itemId)
			if lastTime >= 0 then 
				bAdd = false 
			end
			
			local basicInfo = GDatatab_item["id_" .. itemId]
			if basicInfo then 
				copyValue.quality = basicInfo.quality
				copyValue.subType = basicInfo.sub_type
			end
			if bAdd then 
				copyValue.property = value.property2
				copyValue.property3 = value.wing_property
				copyValue.cost = value.wing_cost
				table.insert(tTempWingsList, copyValue)
			end
		end
	end
	--排序 品质降序，id降序
	table.sort(tTempWingsList, function (a, b) if a.quality ~= b.quality then return a.quality > b.quality else return a.item_id3 > b.item_id3 end end )
	for i = 1, #tTempWingsList do
		table.insert(self.m_tDressList, tTempWingsList[i])
	end
	WZLog("WndAscending:setDressData", Serialize(self.m_tDressList))

	self:updateDressList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	检测某橙色祝福是否已经存在背包或装备栏
--@param 	itemId:祝福Id
function WndAscending:_checkBlessExist(itemId)
	-- body
	local bExist = false
	local level = 1 
	for i = 1, #self.m_tEquipList do
		if self.m_tEquipList[i].status == 1 and self.m_tEquipList[i].tData ~= nil and self.m_tEquipList[i].tData.item_id == itemId then
			bExist = true
			level = self.m_tEquipList[i].tData.level 
			break 
		end
	end

	if not bExist then
		for i = 1, #self.m_tBlessBagList do
			if self.m_tBlessBagList[i].item_id == itemId then
				bExist = true
				level = self.m_tBlessBagList[i].level
				break 
			end
		end
	end

	return bExist, level
end

--@brief    获取当前类型的祝福最高等级
function WndAscending:_getMaxLevel(itemId)
    -- body
    local nLevel = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level > nLevel then
            nLevel = value.level
        end
    end

    return nLevel
end

--@brief 	根据itemId和等级获取相应的祝福数据
function WndAscending:_getPrayInfo(itemId, level)
	-- body
	for i, value in pairs(GDatatab_pray) do
		if value.item_id == itemId and value.level == level then
			return value 
		end
	end

	return nil 
end

--@brief 	计算拥有符合要求的数量
function WndAscending:_getCanFuseNum(tScrap)
	-- body
	local nHaveNum = 0 

 	for j = 1, #tScrap do
 		local bAdd = false
		for i = 1, #self.m_tEquipList do
			if self.m_tEquipList[i].tData ~= nil and tScrap[j][1] == self.m_tEquipList[i].tData.item_id and self.m_tEquipList[i].status == 1 and self.m_tEquipList[i].tData.level >= self:_getMaxLevel(self.m_tEquipList[i].tData.item_id) then
				nHaveNum = nHaveNum + 1
				bAdd = true
				break 
			end
		end

		if not bAdd then
			for i = 1, #self.m_tBlessBagList do
				if tScrap[j][1] == self.m_tBlessBagList[i].item_id and self.m_tBlessBagList[i].level >= self:_getMaxLevel(self.m_tBlessBagList[i].item_id) then
					nHaveNum = nHaveNum + 1
					bAdd = true
					break 
				end
			end
		end
	end

	return nHaveNum 
end

--@brief 	获取祝福数据
--@param 	nLevel:获取的等级数据
function WndAscending:_getFuseBlessData(itemId, nLevel)
	-- body
	local nType = 3
	local tData = nil 
	local level = 0
	for i = 1, #self.m_tEquipList do
		if self.m_tEquipList[i].tData ~= nil and itemId == self.m_tEquipList[i].tData.item_id and self.m_tEquipList[i].status == 1 and self.m_tEquipList[i].tData.level > level  then
			tData = self.m_tEquipList[i].tData
			level = self.m_tEquipList[i].tData.level

			if level >= self:_getMaxLevel(itemId) then
				nType = 1
			else
				nType = 2
			end
		end
	end

	for i = 1, #self.m_tBlessBagList do
		if itemId == self.m_tBlessBagList[i].item_id and self.m_tBlessBagList[i].level > level then
			level = self.m_tBlessBagList[i].level
			tData = self.m_tBlessBagList[i]
			if level >= self:_getMaxLevel(itemId) then
				nType = 1
			else
				nType = 2
			end
		end
	end

	if nType == 3 then
		local nNeedLevel = nLevel or self:_getMaxLevel(itemId)
		local tTemp = self:_getPrayInfo(itemId, nNeedLevel)
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id])
        tTemp.userType = 6
       	
		tData = tTemp
	end

	if self.m_nRightTab == 2 and nLevel == nil then
		local tTemp = self:_getPrayInfo(itemId, self:_getMaxLevel(itemId))
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id])
        tTemp.userType = 6
       	nType = 1

		tData = tTemp
	end
	return nType, tData  
end

--@brief    数据加载动画
function WndAscending:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndAscending:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 	装备排序函数
function _sortAscendingEquip(a, b)
	--已装备优先
	if a.isUse == b.isUse then
		--升星等级
		if a.extraInfo.starLevel ~= nil and b.extraInfo.starLevel ~= nil and a.extraInfo.starLevel == b.extraInfo.starLevel then 
			--强化等级
			if a.extraInfo.strongLevel ~= nil and b.extraInfo.strongLevel ~= nil and a.extraInfo.strongLevel == b.extraInfo.strongLevel then 
				--品质从高到低
				if a.basicInfo.quality == b.basicInfo.quality then
    			    --部位
    			    if a.basicInfo.sub_type == b.basicInfo.sub_type then
    			        --装备ID从低到高
    			        return a.id < b.id
    			    else
    			        return a.basicInfo.sub_type < b.basicInfo.sub_type
    			    end
				else
					return a.basicInfo.quality > b.basicInfo.quality
				end
			else
				return a.extraInfo.strongLevel > b.extraInfo.strongLevel
			end
		else
			return a.extraInfo.starLevel > b.extraInfo.starLevel
		end
	else
		return a.isUse
	end
end

--@brief	点击升阶按钮
function WndAscending:onAscend()
	WZLog("WndAscending:onAscend")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--是否选中装备
	if self.m_tEquipBefore == nil then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
		return
	end
	--材料是否足够
	if self:isMaterialEnough() == false then
		--MsgBoxManager:showTipBox(LocalStrings.ASCENDING19)
		return
	end
	--是否保留强化等级
	if self.m_bChecked == true then
		local cost = GetElement(self.m_root,"txtCost",WZUILabelTTF):getText()
        if not JudgeMoneyIsEnough(self.m_nCostId, tonumber(cost), nil, nil, nWindowId, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then 
            return 
        end
	end
	--紫装
	--MsgBoxManager:showTipBox(tostring(self.m_bChecked))
	self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券
function WndAscending:sureUseDiamondInstead()
    -- body
	-- GetElement(self.m_root,"ani1",WZUISpine):setVisible(true)
	-- GetElement(self.m_root,"ani1",WZUISpine):play("2", false)
	self.m_root:enableSchedule("sendProtocol", 1)
end

--@brief	发送协议
function WndAscending:sendProtocol()
	self.m_root:disableSchedule()
	-- GetElement(self.m_root,"ani1",WZUISpine):setVisible(false)
	if self.m_tEquipBefore.basicInfo.main_type == 43 then
		if self.m_tEquipBefore.basicInfo.quality == 2 then
			ProtocolProcessorScenePets:send_PET_PetUpEquip(self.m_tEquipBefore.playerItemId, 3, self.m_bChecked, 0)
		end
		if self.m_tEquipBefore.basicInfo.quality == 3 then
			ProtocolProcessorScenePets:send_PET_PetUpEquip(self.m_tEquipBefore.playerItemId, 3, false, 0)
		end
	else
		if self.m_tEquipBefore.basicInfo.quality == 2 then
			ProtocolProcessorWndAscending:send_ADVANCED_MakePurpleEqui(self.m_tEquipBefore.playerItemId, self.m_bChecked )
		end
		if self.m_tEquipBefore.basicInfo.quality == 3 then
			ProtocolProcessorWndAscending:send_ADVANCED_MakeOrangeEqui(self.m_tEquipBefore.playerItemId )
		end
	end
end

--@brief	制作成功
function WndAscending:onAscendFinish()
	self:cleanWnd()
end

--@brief	判断材料是否足够
function WndAscending:isMaterialEnough()
	if self.m_tOwnM[1] >= self.m_tNeedM[1] and self.m_tOwnM[2] >= self.m_tNeedM[2] and self.m_tOwnM[3] >= self.m_tNeedM[3] and self.m_tOwnM[4] >= self.m_tNeedM[4] then
	return true
	else
		for i=1,4 do
			if self.m_tOwnM[i] < self.m_tNeedM[i] then
				local limitLeave = -1
				--判断物品是否限购
				CacheCenter:getShopItems(function(t,shopItemList)
					for k,v in pairs(shopItemList)	do
						if v.shopItemId == self.m_tMId[i] and v.isOnSale == true then
							limitLeave = v.limitLeave
							break
						end
					end
				end)
				WZLog("限购数"..limitLeave)
				if limitLeave == -1 then
					--不限购
					--checkIsOnSale(self.m_tMId[i],LocalStrings.ASCENDING19)	
					WndFastGetItems:show(self.m_tMId[i])
				elseif limitLeave == 0 then
					--限购且购买次数已经用完
					WndFastGetItems:show(self.m_tMId[i])
				else
					--限购且购买次数没有用完
					--checkIsOnSale(self.m_tMId[i],LocalStrings.ASCENDING19)	
					WndFastGetItems:show(self.m_tMId[i])
				end
				return false
			end
		end
		return false
	end
end

--@brief	点击确定充值回调
function WndAscending:clickSureMoney()
	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2, Chat_Channel_WndAscending_Tab2)
	PassportSdkManager:gotoPaymentPage()
end

--@brief	点击调品按钮
function WndAscending:onSure()
	WZLog("WndAscending:onSure")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--是否选中装备
	if self.m_tEquipBefore == nil then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
		return
	end
	--材料是否足够
	local needNum = tonumber(GetElement(self.m_root,"cost",WZUILabelTTF):getText())
	local ownNum = self.m_nOwnM or 0
	if ownNum < needNum then
		MsgBoxManager:showTipBox(LocalStrings.ASCENDING19)
		return
	end
	--调品箱是否足够
	local num1 = CacheCenter:getPlayerItemCountById(ORANGECHANGEGRADEMATERIAL)
	if num1 < 1 then
        MsgBoxManager:showConfirmBox(LocalStrings.ASCENDING21, self, self.buy, nil, nil)
		return
	end

	if self.m_bRunning == true then return end
	self.m_bRunning = true
	self.m_root:enableSchedule("sendProtocol2", 1.5)
	GetElement(self.m_root,"ani2",WZUISpine):setVisible(true)
	GetElement(self.m_root,"ani2",WZUISpine):play("1", false)
end

--@brief	购买调品箱
function WndAscending:buy(btnTag)
	WZLog("WndAscending:buy",btnTag == MSGBOXTYPE_CONFIRM)
    --if btnTag == MSGBOXTYPE_CONFIRM then
        --checkIsOnSale(ORANGECHANGEGRADEMATERIAL)
		WndFastGetItems:show(ORANGECHANGEGRADEMATERIAL)
    --end
end

--@brief	发送协议
function WndAscending:sendProtocol2()
	self.m_root:disableSchedule()
	GetElement(self.m_root,"ani2",WZUISpine):setVisible(false)
	ProtocolProcessorWndAscending:send_ADVANCED_AdjustQuality(self.m_tEquipBefore.playerItemId )
end

function WndAscending:playSound()
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
end

--@brief	调品完成
function WndAscending:onSureFinish()
	--self:cleanWnd()

    local wnd = WndAscendingTip:createElement()
    WindowManager:addWindow(wnd, WndAscendingTip, false)
end

--@brief 	点击融合回调
function WndAscending:onFuse(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WZLog("WndAscending:onFuse", type(self.m_tSelectedData))
	if self.m_tSelectedData == nil then return end 

	local tMergeInfo = self.m_tSelectedData.mergeInfo
	local nType1 = self:_getFuseBlessData(tMergeInfo.scrap[1][1])
	local nType2 = self:_getFuseBlessData(tMergeInfo.scrap[2][1])
	if nType1 ~= 1 or nType2 ~= 1 then
		MsgBoxManager:showTipBox(LocalStrings.ASCENDING_FUSE5)
		return 
	end

	local tCost = self.m_tSelectedData.mergeInfo.cost
	if tCost[1][2] > CacheCenter:getPlayerItemCountById(tCost[1][1]) then
		local isOnSale = CacheCenter:itemIsOnSale(tCost[1][1])
		if isOnSale then
			local sAtt = string.format(LocalStrings.ASCENDING_FUSE15, GDatatab_item["id_" .. tCost[1][1]].name)
			MsgBoxManager:showConfirmBox(sAtt, self, self.buyItem1, nil, nil)
		else
			MsgBoxManager:showTipBox(LocalStrings.ASCENDING_FUSE14)
		end
		return 
	end
	if tCost[2][2] > CacheCenter:getPlayerItemCountById(tCost[2][1]) then
		local isOnSale = CacheCenter:itemIsOnSale(tCost[2][1])
		if isOnSale then
			local sAtt = string.format(LocalStrings.ASCENDING_FUSE15, GDatatab_item["id_" .. tCost[2][1]].name)
			MsgBoxManager:showConfirmBox(sAtt, self, self.buyItem2, nil, nil)
		else
			MsgBoxManager:showTipBox(LocalStrings.ASCENDING_FUSE14)
		end
		return 
	end
	local vBeFusedId = WZLuaVector_int_:create()
	for i = 1, #self.m_tBeFusedId do
    	vBeFusedId:push(self.m_tBeFusedId[i])
    end
    WZLog("WndAscending:onFuse 111", Serialize(self.m_tBeFusedId), tMergeInfo.items[1][1])

    self:_createLoading()
	ProtocolProcessorWndAscending:send_PRAY_MergePray(vBeFusedId, tMergeInfo.items[1][1])
end

--@brief 	购买跳转
function WndAscending:buyItem1(element)
	-- body
	local tCost = self.m_tSelectedData.mergeInfo.cost

	--WndPurchase:showBuyInterface(6,tCost[1][1])
	--checkIsOnSale(tCost[1][1])
	WndFastGetItems:show(tCost[1][1])
end

--@brief 	购买跳转
function WndAscending:buyItem2(element)
	-- body
	local tCost = self.m_tSelectedData.mergeInfo.cost

	--WndPurchase:showBuyInterface(6,tCost[2][1])
	--checkIsOnSale(tCost[2][1])
	WndFastGetItems:show(tCost[2][1])
end

--@brief	如果祈福背包或装备栏的数据更新，则刷新融合界面祈福背包和装备列表的数据
function WndAscending:resetBagAndEquipList(tBagList, tEquipList)
	-- body
	if self.m_root == nil then return end
	if self.m_nCurTab ~= 3 then return end
	
    if tBagList ~= nil then
    	local tTempBagList = CopyTable(tBagList)
    	self.m_tBlessBagList = {}
    	for i = 1, #tTempBagList do
    		tTempBagList[i].userType = 6
    		table.insert(self.m_tBlessBagList, tTempBagList[i])
    	end
    end

    if tEquipList ~= nil then
    	local tTempEquipList = CopyTable(tEquipList) 
        for i = 1, #tTempEquipList do
        	if tTempEquipList[i].tData ~= nil then
    			tTempEquipList[i].tData.userType = 6
    		end
    		table.insert(self.m_tEquipList, tTempEquipList[i])
    	end
    end

    -- if self.m_tFuseCellList then
    -- 	for i = 1, #self.m_tFuseCellList do
    -- 		self.m_tFuseCellList[i]:_showState()
    -- 	end
    -- end
    self:_initEquipListByTag(nil, 2)

    if self.m_tSelectedData == nil then return end
    -- if self.m_tFuseCellList then
    -- 	for i = 1, #self.m_tFuseCellList do
    -- 		local tItem = self.m_tFuseCellList[i]:getData()
    -- 		WZLog("WndAscending:resetBagAndEquipList", tItem.mergeInfo.id, self.m_tSelectedData.mergeInfo.id)
    -- 		if tItem.mergeInfo.id == self.m_tSelectedData.mergeInfo.id then
    -- 			self.m_tFuseCellList[i]:setHightLightVisible(true)
    -- 		end
    -- 	end
    -- end

    self:_takeonBless(self.m_tSelectedData)
end

--@brief 	返回选中的数据
function WndAscending:getSelectedData()
	-- body
	return self.m_tSelectedData
end

--@brief 	获取羁绊属性
function WndAscending:getPetFetterPropertyValue(petData, proType)
	-- body
	local fetterConfig = WndPetFetter:_getFetterConfig(petData.itemId)
	local value = 0 
	if fetterConfig == nil then 
		return value 
	end
	WZLog("WndAscending:getPetFetterPropertyValue")
	local tFetterState = SplitStringWithSeparator(petData.fetterStatus, "|", nil, true) --
	for j = 1, 6 do
		local attribute = fetterConfig["attribute" .. j]
		if tFetterState[j] ~= 0 and type(attribute) == "table" then 
			for i = 1, #attribute do
				if attribute[i][1] == proType then 
					value = value + attribute[i][2]
				end
			end
		end
	end

	WZLog("WndAscending:getPetFetterPropertyValue one", value)
	return value
end
-------------------------------------私有方法模块End----------------------------------------
