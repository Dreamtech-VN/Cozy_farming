--WndExtractionData.lua
--@brief	WndExtraction的数据模块
--@date		2017/05/25
--@author	Tianxiang_Xu
--@note		萃取模块

WndExtraction = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndExtraction:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tAppraiseList = nil          --待萃取的物品以及数量
    self.m_nTotalCost = 0               --总共的萃取费用
    self.m_tBagList = nil               --萃取背包
    self.m_tCellList = nil  
    self.m_nClickItemTag = nil 
    self.m_tTempResult = nil            --保存萃取完成后的结果
    self.m_nLeftTopIndex = 1 			--
    self.m_nLoadingId = nil 
    self.m_tKeepExtractionData = nil 	--用于清理背包
    self.m_bIsCanExtraction = true      --是否可以萃取
	self.m_tPutItem = nil


    self.m_nSelectedIndex = 0           --当前显示的序号
    self.m_tItemDataList = nil          --道具数据列表
    self.m_tItemObjList = nil           --道具节点绑定的lua对象列表
    self.m_tSuccessItemInfo = nil       --合成成功后的物品信息

	self.m_nTag = nil
	self.m_tData = nil

    self.m_tResultItem = nil            --合成结果道具lua对象
    self.m_tMergeInfo = nil             --当前道具合成信息表（从LocalData读取）
	self.m_nMId = nil
	self.m_nMergeNum = nil
	self.m_nMergeMax = nil
	self.m_bHasSkin = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndExtraction:_unInit()
	self.m_root = nil
	self.m_tAppraiseList = nil          --待萃取的物品以及数量
    self.m_nTotalCost = 0               --总共的萃取费用
    self.m_tBagList = nil               --萃取背包
    self.m_tCellList = nil  
    self.m_nClickItemTag = nil 
    self.m_tTempResult = nil            --保存萃取完成后的结果
    self.m_nLeftTopIndex = nil 
    self.m_nLoadingId = nil 
    self.m_tKeepExtractionData = nil 	--用于清理背包
    self.m_bIsCanExtraction = false      --是否可以萃取
	self.m_tPutItem = nil


    self.m_nSelectedIndex = 0           --当前显示的序号
    self.m_tItemDataList = nil          --道具数据列表
    self.m_tItemObjList = nil           --道具节点绑定的lua对象列表
    self.m_tSuccessItemInfo = nil       --合成成功后的物品信息

	self.m_nTag = nil
	self.m_tData = nil

    self.m_tResultItem = nil            --合成结果道具lua对象
    self.m_tMergeInfo = nil             --当前道具合成信息表（从LocalData读取）
	self.m_nMId = nil
	self.m_nMergeNum = nil
	self.m_nMergeMax = nil
	self.m_bHasSkin = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndExtraction:createElement()
	if WndExtraction.m_root ~= nil then
		WindowManager:removeWindow(WndExtraction.m_root, WndExtraction, true)
	end
	local element = WZUISystem:getInstance():createElement("WndExtraction")
	assert(element, "WndExtraction create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndExtraction:showInterface()
	-- body
	local wndExtraction = WndExtraction:createElement()
	if wndExtraction then
		WindowManager:addWindow(wndExtraction, WndExtraction, nil, nil, nil, true)
	end
end

--@brief 	设置符文数据
function WndExtraction:setRuneData(itemIds, itemNums)
	-- body
	self.m_tBagList = {} 

	self:_stopLoading()
	for i = 1, #itemIds do
        local tTemp = {}
        tTemp.id = itemIds[i]
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..itemIds[i]])
        tTemp.lastNum = itemNums[i]
        tTemp.maintype = tTemp.basicInfo.main_type
        tTemp.subtype = tTemp.basicInfo.sub_type
		tTemp.name = tTemp.basicInfo.name

		local tCostData = GDatatab_awake_extract["id_" .. itemIds[i]]
		if tCostData then
        	table.insert(self.m_tBagList, tTemp)
        end
    end
    local runeSort = function (a,b)
    	-- body
    	if a.basicInfo.quality == b.basicInfo.quality then
    		return a.id > b.id
    	else
    		return a.basicInfo.quality < b.basicInfo.quality
    	end
    end
    table.sort(self.m_tBagList, runeSort)

	self:_update()
end

--@brief 	设置装备数据
function WndExtraction:setEquipData()
	-- body
	self.m_tBagList = {} 

	local tTempList = CacheCenter:getNoUseEquipList()

	for i = 1, #tTempList do
		if tTempList[i].basicInfo.quality < 4 and tTempList[i].extraInfo.starLevel == 0 and tTempList[i].extraInfo.starExp == 0 and tTempList[i].extraInfo.strongLevel == 0 and tTempList[i].extraInfo.defendStone == 0 and tTempList[i].extraInfo.attackStone == 0 and tTempList[i].extraInfo.hpStone == 0 then
			local tCostData = GDatatab_awake_extract["id_" .. tTempList[i].id]
            local tTempEquipData = CopyTable(tTempList[i])
			if tCostData then
		    	table.insert(self.m_tBagList, tTempEquipData)
		    end
		end
	end

	local equipSort = function (a,b)
    	-- body
    	if a.basicInfo.quality == b.basicInfo.quality then
    		if a.subtype == b.subtype then
    			return a.id > b.id
    		else
    			return a.subtype > b.subtype
    		end
    	else
    		return a.basicInfo.quality < b.basicInfo.quality
    	end
    end
    table.sort(self.m_tBagList, equipSort)

end

--@brief 	设置祝福数据
function WndExtraction:setBlessData(bagIds, bagExps, bagPrayIds)
	-- body
	self.m_tBagList = {} 
	self:_stopLoading()

	--背包中的祝福
    local tDataList = {}
    for i = 0, bagIds:size() - 1 do
        local tTemp = {}
        tTemp.id = bagPrayIds:get(i)
        tTemp.blessId = bagIds:get(i)
        tTemp.curExp = bagExps:get(i)

        table.insert(tDataList, tTemp)
    end
    for i = 1, #tDataList do
        local tTemp = CopyTable(GDatatab_pray["id_"..tDataList[i].id]) 
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id])
        tTemp.userType = 7
        tTemp.blessId = tDataList[i].blessId
        tTemp.curExp = tDataList[i].curExp
		tTemp.name = tTemp.basicInfo.name
		tTemp.lastNum = 1

        local tCostData = GDatatab_awake_extract["id_" .. tTemp.item_id]
		if tCostData and tTemp.curExp == 0 and tTemp.level == 1 and tTemp.basicInfo.quality < 4 then
        	table.insert(self.m_tBagList, tTemp)
        end
    end

    local blessSort = function (a,b)
    	-- body
    	if a.basicInfo.quality == b.basicInfo.quality then
    		if a.basicInfo.sub_type == b.basicInfo.sub_type then
    			return a.basicInfo.id > b.basicInfo.id
    		else
    			return a.basicInfo.sub_type > b.basicInfo.sub_type
    		end
    	else
    		return a.basicInfo.quality < b.basicInfo.quality
    	end
    end
    table.sort(self.m_tBagList, blessSort)

	self:_update()
end

--@brief 	设置宠物数据
function WndExtraction:setPetData(itemId, name, icon, animation, advancedLevel, upgradeLevel, property, giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId, num, petExp, fighting, birthSkill, skill, petSkinItemId, fetterStatus)
	-- body
	WZLog("WndExtraction:setPetData", Serialize(itemId), Serialize(name), Serialize(icon), Serialize(animation), Serialize(advancedLevel), Serialize(upgradeLevel), Serialize(property), Serialize(giftSkill),Serialize(isInUsed), Serialize(playerPetId), Serialize(num), Serialize(petExp), Serialize(fighting), Serialize(birthSkill), Serialize(skill))
	self.m_tBagList = {} 
	self:_stopLoading()
	for i = 1, #itemId do
		local tTemp = json.decode(property[i])
        tTemp.id = itemId[i]
        tTemp.itemId = itemId[i]
        tTemp.playerPetId = playerPetId[i]
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..itemId[i]])
        tTemp.lastNum = 1
        tTemp.upgradeLevel = upgradeLevel[i]
        tTemp.icon = icon[i]
        tTemp.quality = tTemp.basicInfo.quality
        tTemp.advancedLevel = advancedLevel[i]
        tTemp.fighting = fighting[i]
        tTemp.name = name[i]
        tTemp.gift = giftSkill[i]
        tTemp.skill = skill[i]
        tTemp.petSkinItemId = petSkinItemId[i]
        tTemp.fetterStatus = fetterStatus[i]

        if tTemp.advancedLevel == 0 and tTemp.upgradeLevel == 1 and isInUsed[i] == false and tTemp.basicInfo.quality < 4 then
			local tCostData = GDatatab_awake_extract["id_" .. itemId[i]]
			if tCostData then
	        	table.insert(self.m_tBagList, tTemp)
	        end
		end
	end

	local petSort = function (a,b)
    	-- body
    	if a.quality == b.quality then
    		return a.id > b.id
    	else
    		return a.quality < b.quality
    	end
    end
    table.sort(self.m_tBagList, petSort)

	self:_update()
end

--@brief    设置宠物数据
function WndExtraction:setData()
    -- body
    self.m_tAppraiseList = {}
    self.m_tAppraiseList[1] = {}
    self.m_tAppraiseList[2] = {}
    self.m_tAppraiseList[3] = {}
    self.m_tAppraiseList[4] = {}
    self.m_tAppraiseList[5] = {}
    self.m_tAppraiseList[6] = {}

    if self.m_nLeftTopIndex == 1 then
    	self:_createLoading()
    	ProtocolProcessorWakeup:send_RUNE_GetRuneInfo()
    	return 
    elseif self.m_nLeftTopIndex == 2 then
    	self:setEquipData(tEquipData)
    elseif self.m_nLeftTopIndex == 3 then
    	self:_createLoading()
    	ProtocolProcessorWakeup:send_PET_GetAllPetList( )
    	return 
    elseif self.m_nLeftTopIndex == 4 then
    	self:_createLoading()
    	ProtocolProcessorWakeup:send_PRAY_GetPrayMess( )
    	return 
    end
    
    self:_update()
end

--@brief    设置特效可见
function WndExtraction:setSpineVisible(nIndex, nSpineType)
    -- body
    WZLog("WndExtraction:setSpineVisible", nIndex)
    if nSpineType == 1 then
        local spine = GetElement(self.m_root, "spine" .. nIndex .. "_WndExtraction", WZUISpine)
        if spine then
            spine:setVisible(true)
            spine:play("animation", false)
        end
    elseif nSpineType == 2 then
        local spine = GetElement(self.m_root, "spineTail" .. nIndex .. "_WndExtraction", WZUISpine)
        if spine then
            spine:setVisible(true)
            spine:play("animation", false)
        end
    end
end

--@brief    设置特效不可见
function WndExtraction:setSpineUnVisible(nIndex, nSpineType)
    -- body
    WZLog("WndExtraction:setSpineUnVisible", nIndex)
    if nSpineType == 1 then
        GetElement(self.m_root, "spine" .. nIndex .. "_WndExtraction", WZUISpine):setVisible(false)
    elseif nSpineType == 2 then
        GetElement(self.m_root, "spineTail" .. nIndex .. "_WndExtraction", WZUISpine):setVisible(false)
    end
end

--@brief    特效播放一半，情掉鉴定格的物品
function WndExtraction:_cleanAppgraiseGrid(nIndex)
    -- body
    --移出掉鉴定栏的宝物图标
    local conItem = GetElement(self.m_root, "conItem" .. nIndex .. "_WndExtraction", WZUIContainer)
    if conItem:getChildByTag(999) then
        conItem:removeChildByTag(999, true)
    end
    --清楚掉移出鉴定栏的数据
    self.m_tAppraiseList[nIndex] = {}
    --刷新费用
    self:_updateCostNum()
end

--@brief    播放特效
function WndExtraction:displaySuccessSpine()
    -- body
    local nTotalNum = #self.m_tAppraiseList - self:_getLeftGridNum()

    local nTempCaculate = 0 
    for i = 1, #self.m_tAppraiseList do
        local array = CCArray:create()
        if self.m_tAppraiseList[i].id ~= nil then
            array:addObject(CCCallFuncN:create(function ()
                self:setSpineVisible(i, 1)
            end))
            array:addObject(CCDelayTime:create(0.4))
            array:addObject(CCCallFuncN:create(function ()
                self:_cleanAppgraiseGrid(i)
            end))
            array:addObject(CCCallFuncN:create(function ()
                self:setSpineUnVisible(i, 1)
            end))
            array:addObject(CCCallFuncN:create(function ()
                self:setSpineVisible(i, 2)
            end))
            array:addObject(CCDelayTime:create(0.4))
            array:addObject(CCCallFuncN:create(function ()
                self:setSpineUnVisible(i, 2)
            end))
            nTempCaculate = nTempCaculate + 1
            if nTempCaculate == nTotalNum then
                array:addObject(CCCallFuncN:create(function ()
                    self:_onFinishEachAni()
                end))
                array:addObject(CCDelayTime:create(0.4))
                array:addObject(CCCallFuncN:create(function ()
                    self:_onFinishActionBack()
                end))
            end
            local action = CCSequence:create(array)

            local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndExtraction", WZUIContainer)
            conItem:runAction(action)
        end
    end 
end

--@brief    播放中间散开动画
function WndExtraction:_onFinishEachAni()
    -- body
    local spineCenter = GetElement(self.m_root, "spineCenter_WndExtraction", WZUISpine)
    if spineCenter then
        spineCenter:setVisible(true)
        spineCenter:play("animation", false)
    end
end

--@brief    动画特效播放完了之后
function WndExtraction:_onFinishActionBack()
    -- body
    WZLog("WndExtraction:_onFinishActionBack")
    GetElement(self.m_root, "spineCenter_WndExtraction", WZUISpine):setVisible(false)
    GetElement(self.m_root, "imgLimiteTouch_WndExtraction", WZUI9Image):setVisible(false)
    if self.m_tTempResult then
        WndRewardShow:showById(self.m_tTempResult.item, self.m_tTempResult.num)
        --更新背包数据
        self:_cleanBagData(self.m_tTempResult.item, self.m_tTempResult.num)
        --移除触摸层
        self:removeTouchBg()
    end
end

--@brief    萃取成功
function WndExtraction:extractionOK(item, num)
    -- body
    self.m_tTempResult = {}
    self.m_tTempResult.item = item
    self.m_tTempResult.num = num 
    self:_stopLoading()
    --播放特效的时候，不让触摸
    GetElement(self.m_root, "imgLimiteTouch_WndExtraction", WZUI9Image):setVisible(true)
    self.m_tKeepExtractionData = CopyTable(self.m_tAppraiseList)
    self:displaySuccessSpine()
end

--@brief    移除屏蔽触摸层
function WndExtraction:removeTouchBg()
    -- body
    if self.m_root == nil then return end 

    if self.m_root:getChildByTag(888) then 
        self.m_root:removeChildByTag(888, true)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    计算鉴萃取用
function WndExtraction:_caculateTotalCost()
    -- body
    local tTotalCost = {}
    if self.m_tAppraiseList == nil then return tTotalCost end

    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id ~= nil then
            local tCurCost = CopyTable(GDatatab_awake_extract["id_" .. self.m_tAppraiseList[i].itemId].cost[1])
            local bIsExist = false 
            for j = 1, #tTotalCost do
            	if tTotalCost[j][1] == tCurCost[1] then
            		bIsExist = true 
            		local nTotal = tTotalCost[j][2] + tCurCost[2] * self.m_tAppraiseList[i].num
            		tTotalCost[j][2] = nTotal
            		break 
            	end
            end
            if not bIsExist then
            	local tItem = {}
            	tItem[1] = tCurCost[1]
            	tItem[2] = tCurCost[2] * self.m_tAppraiseList[i].num

            	table.insert(tTotalCost, tItem)
            end
        end
    end

    
    return tTotalCost
end

--@brief    获取剩余的存放萃取物品的格数
function WndExtraction:_getLeftGridNum()
    -- body
    local m_nLeftGridNum = 0 

    for i = 1, #self.m_tAppraiseList do
        if self.m_tAppraiseList[i].id == nil then
            m_nLeftGridNum = m_nLeftGridNum + 1
        end
    end

    return m_nLeftGridNum
end

--@brief    清掉萃取栏数据
function WndExtraction:cleanAppraiseData()
    -- body
    for i = 1, #self.m_tAppraiseList do
        local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndExtraction", WZUIContainer)
        if conItem:getChildByTag(999) then
            conItem:removeChildByTag(999, true)
        end
        self.m_tAppraiseList[i] = {}
    end

    self.m_nTotalCost = 0
    --刷新费用
    self:_updateCostNum()
end

--@brief    刷新背包数据
function WndExtraction:_cleanBagData()
    -- body
    --清除萃取栏数据
    self:cleanAppraiseData()
    for i = 1, #self.m_tKeepExtractionData do 
    	for j = 1, #self.m_tBagList do
    		local nTempId
    		if self.m_nLeftTopIndex == 1 then
    			nTempId = self.m_tBagList[j].id
    		elseif self.m_nLeftTopIndex == 2 then
    			nTempId = self.m_tBagList[j].playerItemId
    		elseif self.m_nLeftTopIndex == 3 then
    			nTempId = self.m_tBagList[j].playerPetId
    		elseif self.m_nLeftTopIndex == 4 then
    			nTempId = self.m_tBagList[j].blessId
    		end
    		if self.m_tKeepExtractionData[i] and self.m_tKeepExtractionData[i].id == nTempId then
    			if self.m_nLeftTopIndex == 1 then
    				if self.m_tKeepExtractionData[i].num >= self.m_tBagList[j].lastNum then
    					table.remove(self.m_tBagList, j)
    				else
    					self.m_tBagList[j].lastNum = self.m_tBagList[j].lastNum - self.m_tKeepExtractionData[i].num
    				end
    			else
    				table.remove(self.m_tBagList, j)
    			end
    			break 
    		end
    	end
    end
    self.m_tKeepExtractionData = nil 
    --更新背包数据
    self:_createBagList()
    self.m_bIsCanExtraction = true
end

--@brief    数据加载动画
function WndExtraction:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndExtraction:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 	根据blessId返回相应的数据
function WndExtraction:_getBlessDataById(blessId)
	-- body
	for i = 1, #self.m_tBagList do
		if self.m_tBagList[i].blessId == blessId then
			return self.m_tBagList[i]
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
