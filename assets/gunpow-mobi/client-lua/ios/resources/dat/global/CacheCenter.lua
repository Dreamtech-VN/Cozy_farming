--CacheCenter.lua
--@brief	客户端缓存中心
--@date		2014/8/20
--@author	刘凑贵
--@note     定义客户端缓存中心的变量与方法

-------------------------------------公有方法模块Begin--------------------------------------
--缓存更新观察者机制
--例子:更新物品变化数据
--CacheCenter:_updatePlayerItemData()
--收到物品变化缓存推送后,调用self:_updatePlayerItemData()
--在方法中调用已注册观察者的updatePlayerItemData()函数

--@brief	获取背包玩家缓存信息
function CacheCenter:getPlayerInfo() 
	return self.m_tPlayerInfo
end

--@brief	获取背包玩家物品列表缓存信息
function CacheCenter:getPlayerItems()
	return self.m_tPlayerItemList
end

--@brief	获取已装备时装列表
function CacheCenter:getEquipedDecorationList()
	if self.m_tPlayerItemList == nil then return end
	local tEquipmentList = {}
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 5 and self.m_tPlayerItemList[i].isUse then
			table.insert(tEquipmentList, self.m_tPlayerItemList[i])
		end
	end
	return tEquipmentList
end

--@brief	是否时装红点
function CacheCenter:isEquipedDecorationRedPoint()
	--do return false end
	local isRed = false
	local isDress, isBadge, isPractice, isRune
	WZLog("isEquipedDecorationRedPoint zero", CacheCenter:hasExpiredDress(), GlobalGame.g_ClickedDress)
	if CacheCenter:hasExpiredDress() and GlobalGame.g_ClickedDress ~= true then
		isDress = true
	end

	isBadge = g_bHaveRedPointForAchieEntry or GlobalGame.g_tRedPointList.badge
	isPractice = CacheCenter:getRedState("btnPractice_ExtendUp")
	isRune = CacheCenter:getRedState("btnRune")

	isRed = isDress or isBadge or isPractice or isRune

	WZLog("isEquipedDecorationRedPoint three", tostring(isRed), tostring(isDress), tostring(isBadge), tostring(isPractice), tostring(isRune))
	return isRed
end

--@brief	获取已装备列表
function CacheCenter:getEquipedList()
	if self.m_tPlayerItemList == nil then return end
	local tEquipmentList = {}
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 4 and self.m_tPlayerItemList[i].isUse then
			table.insert(tEquipmentList, self.m_tPlayerItemList[i])
		end
	end
	return tEquipmentList
end

--@brief	获取当前已装备武器
function CacheCenter:getWeapon()
	if self.m_tPlayerItemList == nil then return end
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 4 and (self.m_tPlayerItemList[i].subtype == 0 or self.m_tPlayerItemList[i].subtype == 1) 
			and self.m_tPlayerItemList[i].isUse then
			return self.m_tPlayerItemList[i]
		end
	end
end

--@brief	获取背包全部列表
function CacheCenter:getEquipAllList(sub_type)
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	if sub_type == nil then
		for i=1,#self.m_tPlayerItemList do
			local mainType = self.m_tPlayerItemList[i].maintype
			local isUse = self.m_tPlayerItemList[i].isUse
			if mainType == 4 then
				table.insert(tTempList, self.m_tPlayerItemList[i])
			end
		end
	elseif sub_type == 1 then
		for i=1,#self.m_tPlayerItemList do
			local mainType = self.m_tPlayerItemList[i].maintype
			local isUse = self.m_tPlayerItemList[i].isUse
			if mainType == 4 and (self.m_tPlayerItemList[i].subtype == 0 or self.m_tPlayerItemList[i].subtype == 1) then
				table.insert(tTempList, self.m_tPlayerItemList[i])
			end
		end
	else
		for i=1,#self.m_tPlayerItemList do
			local mainType = self.m_tPlayerItemList[i].maintype
			local isUse = self.m_tPlayerItemList[i].isUse
			if mainType == 4 and self.m_tPlayerItemList[i].subtype == sub_type then
				table.insert(tTempList, self.m_tPlayerItemList[i])
			end
		end
	end
	self:_checkWeaponRecommend(tTempList)
	return tTempList
end

--@brief	获取武器列表
function CacheCenter:getWeaponList()
	if self.m_tPlayerItemList == nil then return end
	local tWeapon = {}
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 4 and (self.m_tPlayerItemList[i].subtype == 0 or self.m_tPlayerItemList[i].subtype == 1) then
			table.insert(tWeapon, self.m_tPlayerItemList[i])
		end
	end
	return tWeapon
end

--@brief	获取防具列表
function CacheCenter:getDefendList()
	if self.m_tPlayerItemList == nil then return end
	local tDefend = {}
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 4 and (self.m_tPlayerItemList[i].subtype ~= 0 and self.m_tPlayerItemList[i].subtype ~= 1) then
			table.insert(tDefend, self.m_tPlayerItemList[i])
		end
	end
	return tDefend
end

--@brief	全身装备是否镶嵌满宝石
function CacheCenter:weaponMountFull()
	if self.m_tPlayerItemList == nil then return end
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 4 --and (self.m_tPlayerItemList[i].subtype == 0 or self.m_tPlayerItemList[i].subtype == 1) 
			and self.m_tPlayerItemList[i].isUse then
			local tData = self.m_tPlayerItemList[i]
			if tData.extraInfo.hpStone == nil or tData.extraInfo.attackStone == nil or tData.extraInfo.defendStone == nil then
				return false
			end
			--if tData.extraInfo.hpStone > 0 and tData.extraInfo.attackStone > 0 and tData.extraInfo.defendStone > 0  then
			--	return true
			--end
		end
	end
	return true
end

--@brief	获取装扮(时装)列表
function CacheCenter:getDecorationList()
	local tDecorationList = {}
	if self.m_tPlayerItemList == nil then return tDecorationList end
	for i=1,#self.m_tPlayerItemList do
		local maintype = self.m_tPlayerItemList[i].maintype
		if maintype == 5 then
			table.insert(tDecorationList, self.m_tPlayerItemList[i])
		end
	end
	return tDecorationList
end

--@brief	是否有过期时装
--有过期时装返回true,没有返回false
function CacheCenter:hasExpiredDress()
	if self.m_tPlayerItemList == nil then return false end
	for i=1,#self.m_tPlayerItemList do
		local maintype = self.m_tPlayerItemList[i].maintype
		if maintype == 5 then
			if self.m_tPlayerItemList[i].lastTime == 0 then
				return true
			end
		end
	end
	return false
end

--@brief	获取其他物品表
function CacheCenter:getOtherItemList()
	if self.m_tPlayerItemList == nil then return end
	local tOtherItemList = {}
	for i=1,#self.m_tPlayerItemList do
		local maintype = self.m_tPlayerItemList[i].main_type
		local subtype = self.m_tPlayerItemList[i].sub_type
		if maintype == 2 or maintype == 7 then 
			table.insert(tOtherItemList, self.m_tPlayerItemList[i])
		end
	end
	return tOtherItemList
end

--@brief	获得装备，道具，材料列表
--@brief	修改类型时，要同时修改CacheCenter:getRemainAmount() 函数
function CacheCenter:getAllList()
	WZLog("CacheCenter:getAllList")
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local subType = self.m_tPlayerItemList[i].subtype
		local isUse = self.m_tPlayerItemList[i].isUse
		if CacheCenter:showInAll(mainType, subType) then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	self:_checkWeaponRecommend(tTempList)
	return tTempList
end

--@brief	获取背包剩余格子数
function CacheCenter:getRemainAmount()
	WZLog("CacheCenter:getRemainAmount")
	if self.m_tPlayerItemList == nil then return end
	local number = 0
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local subType = self.m_tPlayerItemList[i].subtype
		if CacheCenter:showInAll(mainType, subType) then
			number = number + 1
		end
	end
	return (CacheCenter:getGameParam().gridNum - number)
end

function CacheCenter:showInAll(mainType, subType)
	local show = false
	if (mainType == 2 or mainType == 4 or mainType == 6 or mainType == 7 or mainType == 12 or mainType == 3 or (mainType == 9 and subType ==0) or (mainType == 9 and subType ==1) or (mainType == 9 and subType ==2) or (mainType == 9 and subType ==3) or (mainType == 13 and subType ==2) or mainType == 20 or mainType == 23 or mainType == 24) or (mainType == 25 and subType ==2) then
		show = true
	end
	return show
end

--@brief	获取道具列表
function CacheCenter:getPropList()
	WZLog("CacheCenter:getPropList",#self.m_tPlayerItemList)
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local subType = self.m_tPlayerItemList[i].subtype
		if mainType == 2 or mainType == 12 or mainType == 3 or (mainType == 13 and subType ==2) or mainType == 24 or (mainType == 25 and subType ==2) then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	return tTempList
end

--@brief	获取装备列表
function CacheCenter:getEquipList()
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local isUse = self.m_tPlayerItemList[i].isUse
		if mainType == 4 then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	self:_checkWeaponRecommend(tTempList)
	return tTempList
end

--@brief	获取未装备的装备列表
function CacheCenter:getNoUseEquipList()
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local isUse = self.m_tPlayerItemList[i].isUse
		if mainType == 4 and not isUse then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	self:_checkWeaponRecommend(tTempList)
	return tTempList
end

--@brief	获取宝石列表
function CacheCenter:getGemList()
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		if mainType == 6 then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	return tTempList
end

--@brief	获取皮肤列表
function CacheCenter:getSkinList()
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local subType = self.m_tPlayerItemList[i].subtype
		if mainType == 20 or (mainType == 9 and subType ==3) then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	return tTempList
end

--@brief	获取皮肤和足迹列表
function CacheCenter:getSkinAndFootList()
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local subType = self.m_tPlayerItemList[i].subtype
		if mainType == 20 or (mainType == 9 and subType ==3) or mainType == 23 then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	return tTempList
end

--@brief 获取足迹列表
function CacheCenter:getFootMarkList()
	if self.m_tPlayerItemList == nil then return {} end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local tTempItem = self.m_tPlayerItemList[i]
		local mainType = self.m_tPlayerItemList[i].maintype
		if mainType == 23 then
			local data = GDatatab_item["id_"..tTempItem.id]
			if data and data.property and data.property[1][2] == -1 then
				table.insert(tTempList, self.m_tPlayerItemList[i])
			end
		end
	end
	return tTempList
end


--@brief	获取背包材料列表
function CacheCenter:getBagMaterialList()
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local subType = self.m_tPlayerItemList[i].subtype
		if mainType == 7 or (mainType == 9 and subType ==0) or (mainType == 9 and subType ==1) or (mainType == 9 and subType ==2) then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	return tTempList
end

--@brief	获取材料列表
function CacheCenter:getMaterialList()
	if self.m_tPlayerItemList == nil then return end
	local tTempList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		local subType = self.m_tPlayerItemList[i].subtype
		if mainType == 6 or mainType == 7 or (mainType == 9 and subType ==1) or (mainType == 9 and subType ==2) then
			table.insert(tTempList, self.m_tPlayerItemList[i])
		end
	end
	return tTempList
end

--@brief	获取卡牌列表
function CacheCenter:getCardItemList()
	if self.m_tPlayerItemList == nil then return end
	local tCardItemList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		if self.m_tPlayerItemList[i].maintype == 15 then
			table.insert(tCardItemList, self.m_tPlayerItemList[i])
		end
	end
	return tCardItemList
end

--@brief	获取卡牌碎片列表
function CacheCenter:getCardChipList()
	local tCardChipList = {}
	for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		if self.m_tPlayerItemList[i].maintype == 14 then
			table.insert(tCardChipList, self.m_tPlayerItemList[i])
		end
	end
	return tCardChipList
end

--@brief	获取萃取合成列表
function CacheCenter:getWakeupSyntheticMaterialList()
	if self.m_tPlayerItemList == nil then return end
    local tMaterialList = {}
    for i=1,#self.m_tPlayerItemList do
		local itemId = self.m_tPlayerItemList[i].id
		if itemId == 500 or itemId == 501 or itemId == 502 or itemId == 503 then
			local tItemInfo = GetItemLocalData(itemId)
            if tItemInfo and tItemInfo.mix == 1 then
                table.insert(tMaterialList, CopyTable(self.m_tPlayerItemList[i]))
            end
		end
	end
    return tMaterialList
end

--@brief	获取合成材料列表
function CacheCenter:getSyntheticMaterialList()
	if self.m_tPlayerItemList == nil then return end
    local tMaterialList = {}
    for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 7 then
			local tItemInfo = GetItemLocalData(self.m_tPlayerItemList[i].id)
            if tItemInfo and tItemInfo.mix == 1 then
                table.insert(tMaterialList, CopyTable(self.m_tPlayerItemList[i]))
            end
		end
		if self.m_tPlayerItemList[i].maintype == 9 and self.m_tPlayerItemList[i].subtype == 0 then
			local tItemInfo = GetItemLocalData(self.m_tPlayerItemList[i].id)
            if tItemInfo and tItemInfo.mix == 1 then
                table.insert(tMaterialList, CopyTable(self.m_tPlayerItemList[i]))
            end
		end
	end
    return tMaterialList
end

--@brief	获取合成宝石列表
function CacheCenter:getSyntheticGemList()
	if self.m_tPlayerItemList == nil then return end
    local tMaterialList = {}
    for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 6 then
			local tItemInfo = GetItemLocalData(self.m_tPlayerItemList[i].id)
            if tItemInfo and tItemInfo.mix == 1 then
                table.insert(tMaterialList, CopyTable(self.m_tPlayerItemList[i]))
            end
		end
	end
    return tMaterialList
end

--@brief	获取合成皮肤列表
function CacheCenter:getSyntheticSkinList()
	if self.m_tPlayerItemList == nil then return end
    local tMaterialList = {}
    --for i=1,#self.m_tPlayerItemList do
	--	if self.m_tPlayerItemList[i].maintype == 9 and self.m_tPlayerItemList[i].subtype == 3 then
	--		local tItemInfo = GetItemLocalData(self.m_tPlayerItemList[i].id)
    --        if tItemInfo and tItemInfo.mix == 1 then
    --            table.insert(tMaterialList, CopyTable(self.m_tPlayerItemList[i]))
    --        end
	--	end
	--end
    return tMaterialList
end

--@brief	获取装备碎片列表
function CacheCenter:getEquipChipList()
	if self.m_tPlayerItemList == nil then return end
    local tEquipChipList = {}
    for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 9 and self.m_tPlayerItemList[i].subtype == 1 then
			table.insert(tEquipChipList, CopyTable(self.m_tPlayerItemList[i]))
		end
	end
    return tEquipChipList
end

--@brief	获取时装碎片列表
function CacheCenter:getDecorationChipList()
	if self.m_tPlayerItemList == nil then return end
    local  tDecorationChipList = {}
    for i=1,#self.m_tPlayerItemList do
		local mainType = self.m_tPlayerItemList[i].maintype
		if self.m_tPlayerItemList[i].maintype == 9 and self.m_tPlayerItemList[i].subtype == 2 then
			table.insert(tDecorationChipList, CopyTable(self.m_tPlayerItemList[i]))
		end
	end
	return tDecorationChipList
end

--@brief 	獲取可赠送物品列表，从物品道具表中
function CacheCenter:getFriendGiftList()
	-- body
	local  tFriendGiftList = {}
    for i,value in pairs(GDatatab_item) do
		if value.main_type == 15 and value.sub_type == 1 then
			table.insert(tFriendGiftList, value)
		end
	end
	return tFriendGiftList
end

--@brief	获取玩家物品个数
function CacheCenter:getPlayerItemCount(mainType, subType)
	if self.m_tPlayerItemList == nil then
		return nil
	end
	
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == mainType and self.m_tPlayerItemList[i].subtype == subType then
			do return self.m_tPlayerItemList[i].lastNum end
		end
	end

	return 0
end

--@brief	通过物品Id获取玩家物品个数
--@return   玩家物品个数
function CacheCenter:getPlayerItemCountById(itemId)
	WZLog("CacheCenter:getPlayerItemCountById =",itemId)
	if self.m_tPlayerItemList == nil or itemId == nil then
		return 0
	end
	for i,data in pairs(self.m_tPlayerItemList) do
		local key = "id_" .. itemId 
		if GDatatab_item[key] ~= nil and GDatatab_item[key].main_type == 5 or GDatatab_item[key].main_type == 13 then
			if data.basicInfo ~= nil and tonumber(data.basicInfo.id) == tonumber(itemId) then
				return data.lastTime
			end
		end
		if data.basicInfo ~= nil and tonumber(data.basicInfo.id) == tonumber(itemId) then
			WZLog("--CacheCenter:getPlayerItemCountById--",itemId,data.lastNum)
			return data.lastNum
		end
	end
	return 0 

end

--@brief	通过物品Id获取玩家物品个数
--@param    itemId 玩家物品个数
--@param 	value 改变数量
function CacheCenter:changePlayerItemCountById(itemId,value)
	if self.m_tPlayerItemList == nil or itemId == nil then
		return
	end
	for i,data in pairs(self.m_tPlayerItemList) do
		local key = "id_" .. itemId 
		if GDatatab_item[key] ~= nil and GDatatab_item[key].main_type == 5 or GDatatab_item[key].main_type == 13 then
			if data.basicInfo ~= nil and tonumber(data.basicInfo.id) == tonumber(itemId) then
				data.lastNum = data.lastNum + value
				return
			end
		end
		if data.basicInfo ~= nil and tonumber(data.basicInfo.id) == tonumber(itemId) then
			WZLog("--CacheCenter:getPlayerItemCountById--",itemId,data.lastNum)
			data.lastNum = data.lastNum + value
			return
		end
	end
end

--@brief	通过物品Id获取玩家物品
--@return   玩家物品
function CacheCenter:getPlayerItemById(itemId)
    if self.m_tPlayerItemList == nil or itemId == nil then
        return nil
    end
    for i,data in pairs(self.m_tPlayerItemList) do
        if data.basicInfo ~= nil and tonumber(data.basicInfo.id) == tonumber(itemId) then
            return data
        end
    end
    return nil
end

--@brief	获取已装备物品列表
function CacheCenter:getEquipmentList()
	if self.m_tPlayerItemList == nil then return end
	local tEquipmentList = {}
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 4 and self.m_tPlayerItemList[i].isUse then
			table.insert(tEquipmentList, self.m_tPlayerItemList[i])
		end
		if self.m_tPlayerItemList[i].maintype == 5 and self.m_tPlayerItemList[i].isUse then
			table.insert(tEquipmentList, self.m_tPlayerItemList[i])
		end
	end
	return tEquipmentList
end

--@brief	获取已装备物品id列表
function CacheCenter:getEquipmentIdList()
	if self.m_tPlayerItemList == nil then return end
	local idList = {}
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].maintype == 4 and self.m_tPlayerItemList[i].isUse then
			idList[self.m_tPlayerItemList[i].basicInfo.id] = true
		end
		if self.m_tPlayerItemList[i].maintype == 5 and self.m_tPlayerItemList[i].isUse then
			idList[self.m_tPlayerItemList[i].basicInfo.id] = true
		end
	end
	return idList
end

--@brief	获取已拥有物品id列表
function CacheCenter:getOwnIdList()
	if self.m_tPlayerItemList == nil then return end
	local idList = {}
	for i=1,#self.m_tPlayerItemList do
		idList[self.m_tPlayerItemList[i].basicInfo.id] = true
	end
	return idList
end


--@brief	获取玩家财富列表信息
function CacheCenter:getMoneyList()
	return self.m_tMoneyList
end

--@brief	判断缓存中是否有玩家基础数据
--return    true:已有数据，false: 没有数据
function CacheCenter:hasPlayerInfo()
	if self.m_tPlayerInfo == nil then
		return false
	else
		return true
	end
end

--note 		返回签到缓存数据
function CacheCenter:getSignCacheData()
	return self.m_tSignCacheData
end

--@brief	判断缓存中是否有玩家物品列表数据
--return    true:已有数据，false: 没有数据
function CacheCenter:hasPlayerItems()
	if self.m_tPlayerItemList == nil then
		return false
	else
		return true
	end
end

--@brief	切换到主城界面
function CacheCenter:jumpToIsland()
 	replaceScene(SceneCity:createElement())
end

--@brief	更新玩家基础缓存信息
--@param    key:属性key值列表，value:属性更新的值列表
function CacheCenter:updatePlayerInfo(key, value)
	WZLog("CacheCenter:updatePlayerInfo",Serialize(key), Serialize(value))
	local bFighting = false
	local bUpLevel = false
	if key ~= nil and value ~= nil and self.m_tPlayerInfo ~= nil then
		for i=1,#key do
			local valueA = self:_transferValueByString(value[i])
			self:upgradePlayerPro(self.m_tPlayerInfo,key[i],valueA)
			if bFighting == false then--只检查一次
				bFighting = self:_checkHasPlayerFighting(key[i],valueA)--检查战斗力
			end
			if key[i] == "level" then
				GlobalGame:putSecretData("player_level",value[i])
			end
			--判断是否退出公会，在公会场景退出公会，返回主城
			if key[i] == "guildName" then
				if self.m_tPlayerInfo.guildName ~= "" and value[i] == "" then
					WZLog("更新公会名",self.m_tPlayerInfo.guildName,value[i])
					if SceneCommunityMain.m_root ~= nil then
						DelayCallFunction(self.jumpToIsland,self,1.5)
					end
				end
			end
			--更新排位等级
			if key[i] == "segmentLevel" then
				if tonumber(valueA) < GlobalGame.g_tPlayerInfo.nPvpRankLevel then
					WZLog("update segmentLevel:", tonumber(valueA), GlobalGame.g_tPlayerInfo.nPvpRankLevel)
					GlobalGame.g_tPlayerInfo.nPvpRankLevel = tonumber(valueA)
				end
			end

			-----------------------------------------   更新直接赋值属性   -------------------------------------------------
			if key[i] ~= "allMountsMessage" and key[i] ~= "footMark" then
				self.m_tPlayerInfo[key[i]] = self:_checkHasPlayerLevel(key[i],valueA)
			end
			-----------------------------------------   更新直接赋值属性   -------------------------------------------------

			if key[i] == "property" then
				local tProperty = json.decode(valueA)
				for k,v in pairs(tProperty) do
					self.m_tPlayerInfo[ATTR_PARAM_NAME[tonumber(k)]] = v
				end
			end

			WZLog("CacheCenter:updatePlayerInfo",key[i],Serialize(key[i]),Serialize(value[i]))

            if key[i] == "petMessage" then
                if value[i] ~= "" then
                    self.m_tPlayerInfo.petInfo = json.decode(value[i])
                else
                    self.m_tPlayerInfo.petInfo = nil
                end
                local figure = FigureSceneManager:getInstance().m_tFigure
                if figure then
                    figure.m_tPlayerInfo.petInfo = self.m_tPlayerInfo.petInfo
                    figure:setPet()
                end
            end
            --个性展示
            if key[i] == "showMes" then
            	self.m_tPlayerInfo.showMes = tonumber(value[i])
            	local figure = FigureSceneManager:getInstance().m_tFigure

            	if figure then
            		figure.m_tPlayerInfo.showMes = self.m_tPlayerInfo.showMes
            		figure:setKid()
            	end
            end
            --主城小孩跟随
            if key[i] == "childMes" then
            	self.m_tPlayerInfo.childMes = value[i]
            	local figure = FigureSceneManager:getInstance().m_tFigure
                if figure then
                    figure.m_tPlayerInfo.childMes = self.m_tPlayerInfo.childMes
                    figure:setKid()
                end
            end
			--更新坐骑
			if key[i] == "allMountsMessage" then
				if type(self.m_tPlayerInfo.allMountsMessage) == "table" then
					self.m_tPlayerInfo.allMountsMessage[#self.m_tPlayerInfo.allMountsMessage+1] = value[i]
					WZLog("更新坐骑",Serialize(self.m_tPlayerInfo.allMountsMessage))
				end
			end
			--今天是否关爱
			if key[i] == "careToday" then
				self.m_tPlayerInfo.careToday = tonumber(value[i])
			end
			--更新足迹
			if key[i] == "footMark" then
				if type(self.m_tPlayerInfo.footMark) == "table" then
					local addNew = true
					local tAdd = json.decode(value[i]) 
					local index = 1
					for i=1,#self.m_tPlayerInfo.footMark do
						local t = json.decode(self.m_tPlayerInfo.footMark[i])
						if tAdd.footmarkId == t.footmarkId then
							addNew = false
							index = i
							break
						end
					end
					if addNew then
						self.m_tPlayerInfo.footMark[#self.m_tPlayerInfo.footMark+1] = value[i]
					else
						self.m_tPlayerInfo.footMark[index] = value[i]
					end
					WZLog("更新足迹",Serialize(self.m_tPlayerInfo.footMark))
				end
			end
			--更新修炼id和经验
			if key[i] == "xlId" then
				local list = SplitStringWithSeparator(value[i], ",")
				self.m_tPlayerInfo.xlId = CopyTable(list)
			end
			if key[i] == "xlExp" then
				local list = SplitStringWithSeparator(value[i], ",")
				self.m_tPlayerInfo.xlExp = CopyTable(list)
			end

			if bUpLevel == false then
				bUpLevel = self:_checkHasUpdatePlayerLevel(key[i])--检查等级更新
				GlobalGame.g_tInfo.bUpLevel = bUpLevel
			end
			--更新头像状态
			if key[i] == "headSculStatus" then
				self.m_tPlayerInfo.headSculStatus = tonumber(value[i])
				WndCheckOther:updateHeadImgState()
			end
			--
			if key[i] == "headScul" then
				self.m_tPlayerInfo.headScul = value[i]
				WndCheckOther:updateHeadImg()
			end
		end

		if bFighting == false then--如果没有更新战斗力，就默认0
			--WZLog("战斗力差值设置为0")
			--GlobalGame.g_tInfo.m_nFighting = 0
		else
			local beforeLevel = GlobalGame.g_upgradePro.level or 1 
			local afterLevel = CacheCenter:getPlayerInfo().level or 1
			local curAthLv = CacheCenter:getPlayerInfo().tournamentLevel or 1
			local athLv = GlobalGame.g_tPlayerInfo.nAthLevel or 1
            local curPvpLv = CacheCenter:getPlayerInfo().segmentLevel or 1
            local pvpLv = GlobalGame.g_tPlayerInfo.nPvpRankLevel or 1
			if tonumber(pvpLv) == 0 then pvpLv = 1 end
			WZLog("不弹战斗力1:",beforeLevel,afterLevel,athLv,curAthLv,pvpLv,curPvpLv)
			if beforeLevel >= afterLevel and athLv >= curAthLv  and pvpLv >= curPvpLv then
				WZLog("不弹战斗力2:",beforeLevel,afterLevel,athLv,curAthLv,pvpLv,curPvpLv)
				if pvpLv ~= curPvpLv then
					WZLog("排位赛不弹战斗力:",beforeLevel,afterLevel,athLv,curAthLv,pvpLv,curPvpLv)
					if tonumber(pvpLv) == 1 and tonumber(curPvpLv) == 0 then
						upPlayerFightingAni()
					else
						WZLog("战斗力变化1",GlobalGame.g_tInfo.m_nFighting)
						GlobalGame.g_tInfo.nFighting = GlobalGame.g_tInfo.m_nFighting
					end
				elseif WndLoveLottery.m_root == nil then  --已打开爱心许愿界面则延迟显示战斗力提升特效
					WZLog("不弹战斗力3:",beforeLevel,afterLevel,athLv,curAthLv,pvpLv,curPvpLv)
					if SceneBattle.m_root == nil then
						upPlayerFightingAni()
					end
				elseif WndLoveLottery.m_root ~= nil and ( WndLoveLottery.m_bRaffling == nil or WndLoveLottery.m_bRaffling == false) then
					WZLog("不弹战斗力4:",beforeLevel,afterLevel,athLv,curAthLv,pvpLv,curPvpLv)
				    upPlayerFightingAni()
				else
					WZLog("不弹战斗力5:",beforeLevel,afterLevel,athLv,curAthLv,pvpLv,curPvpLv)
					GlobalGame.g_bFightRage = true
				end
			else
				WZLog("不弹战斗力6:",beforeLevel,afterLevel,athLv,curAthLv,pvpLv,curPvpLv)
				WZLog("战斗力变化2",GlobalGame.g_tInfo.m_nFighting)
				GlobalGame.g_tInfo.nFighting = GlobalGame.g_tInfo.m_nFighting
				if pvpLv ~= curPvpLv then
					WZLog("排位赛不弹战斗力1:",beforeLevel,afterLevel,athLv,curAthLv,pvpLv,curPvpLv)
					if tonumber(pvpLv) == 1 and tonumber(curPvpLv) == 0 then
						upPlayerFightingAni()
					else
						WZLog("战斗力变化k",GlobalGame.g_tInfo.m_nFighting)
						GlobalGame.g_tInfo.nFighting = GlobalGame.g_tInfo.m_nFighting
					end
				else
					WZLog("不弹战斗力7:",SceneBattle.m_root == nil)
					if SceneBattle.m_root == nil then
						WZLog("不弹战斗力8:",SceneBattle.m_root == nil)
						upPlayerFightingAni()
					end
				end
			end
		end

		--更新玩家信息
		if self.m_nUpdatePlayerInfo == nil then self.m_nUpdatePlayerInfo = 0 end
		self.m_nUpdatePlayerInfo = self.m_nUpdatePlayerInfo + 1
		--DelayCallFunction(self._updatePlayerInfoData,self,0.5)
		self:_updatePlayerInfoData()

		--更新钻石、金币数据
		self:_setMoneyList()
		if self.m_bStopUpdateNewData == nil or not self.m_bStopUpdateNewData then
			self:_updateMoneyData()
		end

		--检查玩家是否升级
		self:_checkPlayerUpgrade(GlobalGame.g_tInfo.bUpLevel)

		if CacheCenter:isEquipedDecorationRedPoint() then
			CacheCenter:setRedState("btnBag",true)
			GlobalGame:getBtnRedPointEvent():dispatcher()
		end
	end
end

--@brief	添加物品列表缓存信息
function CacheCenter:addPlayerItem(itemId, lastNum, lastTime, isUse, data, playerItemId, disappearTime)
	WZLog ("*********** CacheCenter:addPlayerItem ***************", itemId:size())
	if self.m_tPlayerItemList == nil then
		self.m_tPlayerItemList = {}
	end
	
	local receiveTime = SystemTime:getServerTime()

	--NOTRECYCLEIDS = {}
	for i=0,itemId:size() - 1 do
		WZLog ("CacheCenter:addPlayerItem",itemId:get(i),isUse:get(i),lastTime:get(i),lastNum:get(i))
		local tTempItem = {}
		tTempItem.id = itemId:get(i)
		tTempItem.lastTime = lastTime:get(i)
		tTempItem.lastNum = tonumber(lastNum:get(i))
		tTempItem.isUse = isUse:get(i)
		tTempItem.playerItemId = playerItemId:get(i)
		tTempItem.disappearTime = disappearTime:get(i)
		tTempItem.color = 0
		tTempItem.receiveTime = receiveTime

		--物品基础数据
		local key = "id_"..itemId:get(i)
		tTempItem.basicInfo = GDatatab_item[key]
		tTempItem.maintype = tTempItem.basicInfo.main_type
		tTempItem.subtype = tTempItem.basicInfo.sub_type
		--WZLog("CacheCenter:setPlayerItems",Serialize(tTempItem.basicInfo))
			if tTempItem.basicInfo.use_type == 0 then--num 
				if tTempItem.maintype ~= 4 then
					tTempItem.lastTime = tTempItem.lastNum
				else
					tTempItem.lastNum = 1
				end
			else
				tTempItem.lastNum = tTempItem.lastTime
			end

		--物品附加数据
		tTempItem.extraInfo = json.decode(data:get(i)) 
		if tTempItem.maintype == 5 then
			local nFighting = caculateClothesFighting(tTempItem.extraInfo)
			tTempItem.extraInfo.fighting = nFighting
		end
		if tTempItem.maintype == 5 then
			WZLog("检查1", type(tTempItem.lastTime), tTempItem.lastTime)
			if tonumber(tTempItem.lastTime) == -1 then
				table.insert(NOTRECYCLEIDS, tTempItem.basicInfo.id)
			end
		end
		table.insert(self.m_tPlayerItemList, tTempItem)

		--装备物品窗
		WZLog("显示装备物品窗口",tTempItem.maintype, tTempItem.subtype, tTempItem.id, #self.m_tPlayerItemList)

		if tTempItem.maintype == 5 and CacheCenter:isEquipedDecorationRedPoint() then
			CacheCenter:setRedState("btnBag",true)
			GlobalGame:getBtnRedPointEvent():dispatcher()
		end

		local bHavedEquipSameSubtype = false 	--标记该主类中的子类没有装备，还是空的
		if tTempItem.maintype == 4 then
            WZLog("显示装备物品窗口11")
            for j = 1, #self.m_tPlayerItemList do 
            	if self.m_tPlayerItemList[j].maintype == tTempItem.maintype and tTempItem.subtype == self.m_tPlayerItemList[j].subtype and tTempItem.subtype ~= 0 and tTempItem.subtype ~= 1 then
            		if self.m_tPlayerItemList[j].isUse == true then
            			bHavedEquipSameSubtype = true 	--表示该子类装备已经有物品装备了，进行替换
						WZLog("比较战斗力",g_bIsShowWndDressUp,tTempItem.extraInfo.fighting,self.m_tPlayerItemList[j].extraInfo.fighting)
            			if tTempItem.extraInfo.fighting > self.m_tPlayerItemList[j].extraInfo.fighting then
            				local nTempFighting = tTempItem.extraInfo.fighting - self.m_tPlayerItemList[j].extraInfo.fighting

            				tTempItem.nRiseFighting = nTempFighting
            				if g_bIsShowWndDressUp == true then
	            				MsgBoxManager:showEquipDressUp(tTempItem)
	            			else
	            				table.insert(g_tTempItemForLaterShow, tTempItem)
	            			end
            				break	
            			end
            		end
            	elseif self.m_tPlayerItemList[j].maintype == tTempItem.maintype and (tTempItem.subtype == 0 or tTempItem.subtype == 1) and (self.m_tPlayerItemList[j].subtype == 1 or self.m_tPlayerItemList[j].subtype == 0) then
            		if self.m_tPlayerItemList[j].isUse == true then
            			bHavedEquipSameSubtype = true 	--表示该子类装备已经有物品装备了，进行替换
            			if tTempItem.extraInfo.fighting > self.m_tPlayerItemList[j].extraInfo.fighting then
            				local nTempFighting = tTempItem.extraInfo.fighting - self.m_tPlayerItemList[j].extraInfo.fighting

            				tTempItem.nRiseFighting = nTempFighting
            				if g_bIsShowWndDressUp == true then
	            				MsgBoxManager:showEquipDressUp(tTempItem)
	            			else
	            				table.insert(g_tTempItemForLaterShow, tTempItem)
	            			end
            				break	
            			end
            		end
            	end 
            end
			if bHavedEquipSameSubtype == false then 	--表示该类的装备栏是空的，可以显示装备窗口
				tTempItem.nRiseFighting = tTempItem.extraInfo.fighting
				if g_bIsShowWndDressUp == true then
    				MsgBoxManager:showEquipDressUp(tTempItem)
    			else
    				table.insert(g_tTempItemForLaterShow, tTempItem)
    			end
			end
        end
		--判断是否达到等级
		local level = CacheCenter:getPlayerInfo().level
		WZLog("******** 弹礼包条件 ********", tTempItem.maintype, tTempItem.subtype, level, tTempItem.basicInfo.use_level, g_bIsShowWndDressUp)
		if tTempItem.maintype == 3 and (tTempItem.subtype == 0 or tTempItem.subtype == 1) and tonumber(level) >= tonumber(tTempItem.basicInfo.use_level) then
			--爱心许愿界面这里先不弹礼包打开提示
			if g_bIsShowWndDressUp == true then
				tTempItem.nRiseFighting = -1
				MsgBoxManager:showEquipDressUp(tTempItem)
			else
				tTempItem.nRiseFighting = -1
				table.insert(g_tTempItemForLaterShow, tTempItem)
			end
		end
		--时装的弹快捷装备窗口
		bHavedEquipSameSubtype = false
		if tTempItem.maintype == 5 then
			for j = 1, #self.m_tPlayerItemList do 
            	if self.m_tPlayerItemList[j].maintype == tTempItem.maintype and tTempItem.subtype == self.m_tPlayerItemList[j].subtype then
            		if self.m_tPlayerItemList[j].isUse == true then
            			bHavedEquipSameSubtype = true 	--表示角色已经穿上该时装了，进行替换
                        local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
            			if tTempItem.extraInfo.fighting > self.m_tPlayerItemList[j].extraInfo.fighting or (isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level <= 10) then
            				local nTempFighting = tTempItem.extraInfo.fighting - self.m_tPlayerItemList[j].extraInfo.fighting

            				tTempItem.nRiseFighting = nTempFighting
            				if g_bIsShowWndDressUp == true then
	            				MsgBoxManager:showEquipDressUp(tTempItem)
	            			else
	            				table.insert(g_tTempItemForLaterShow, tTempItem)
	            			end
            				break	
            			end
            		end
           		end
            end
            if bHavedEquipSameSubtype == false then 	--表示角色该时装栏是空的，可以显示快捷装备窗口
				tTempItem.nRiseFighting = tTempItem.extraInfo.fighting
				if g_bIsShowWndDressUp == true then
    				MsgBoxManager:showEquipDressUp(tTempItem)
    			else
    				table.insert(g_tTempItemForLaterShow, tTempItem)
    			end
			end
		end
	end
	
	--保存系统时间
	SETITEMSTIME = os.time()

	--更新钻石、金币数据
	self:_setMoneyList()
	if self.m_bStopUpdateNewData == nil or not self.m_bStopUpdateNewData then
		self:_updateMoneyData()
	end

	--更新物品列表数据
	if self.m_nUpdatePlayerItem == nil then self.m_nUpdatePlayerItem = 0 end
	self.m_nUpdatePlayerItem = self.m_nUpdatePlayerItem + 1
	--DelayCallFunction(self._updatePlayerItemData,self,0.1)
	self:_updatePlayerItemData()
end

--@brief	删除物品列表缓存信息
--@param    tPlayerItemId:被删除玩家物品id列表, tId: 物品id列表
function CacheCenter:removePlayerItems(tPlayerItemId, tId)
	if tPlayerItemId == nil or tId == nil then
		return
	end

	for i=1,#tPlayerItemId do
		self:_removePlayerItem(tPlayerItemId[i])
		local key = "id_"..tId[i]
	end
	
	--保存系统时间
	SETITEMSTIME = os.time()

	--删除物品列表数据
	if self.m_nUpdatePlayerItem == nil then self.m_nUpdatePlayerItem = 0 end
	self.m_nUpdatePlayerItem = self.m_nUpdatePlayerItem + 1
	--DelayCallFunction(self._updatePlayerItemData,self,0.1)
	self:_updatePlayerItemData()

	--删除装扮数据
	--if bUpdateDecorationFlag then
	--	self:_updateDecorationData()
	--end
	WndOwnCity:updateMonthCardRedPoint()
end

--@brief	更新物品列表缓存信息
--@param    playerItemId:物品唯一id，tKey:属性列表，tValue：属性值列表
function CacheCenter:updatePlayerItems(playerItemId, tKey, tValue)
	if playerItemId == nil or tKey == nil or tValue == nil then
		return
	end

	local mainType
	local tTempItem = nil 
	local bIsIncrease = false --道具数量是增加的还是减少的

	WZLog("CacheCenter:updatePlayerItems zero",playerItemId)
	NOTRECYCLEIDS = {}
	for i=1,#self.m_tPlayerItemList do
		if self.m_tPlayerItemList[i].playerItemId == playerItemId then
			tTempItem = self.m_tPlayerItemList[i]
			mainType = self.m_tPlayerItemList[i].maintype
			WZLog("CacheCenter:updatePlayerItems one", self.m_tPlayerItemList[i].id, self.m_tPlayerItemList[i].lastTime)

			for j=1,#tKey do
				WZLog("CacheCenter:updatePlayerItems", playerItemId, tKey[j], tValue[j], self.m_tPlayerItemList[i][tKey[j]], self.m_tPlayerItemList[i].basicInfo.name)
				if self.m_tPlayerItemList[i].basicInfo.main_type == 5 then
					WZLog("gsldfjmlslkkkk",self.m_tPlayerItemList[i][tKey[j]],type(tValue[j]))
					if tonumber(self.m_tPlayerItemList[i][tKey[j]]) ~= -1 and tonumber(tValue[j]) == -1 then
						WZLog("增加NOTRECYCLEIDS",self.m_tPlayerItemList[i].basicInfo.id)
						table.insert(NOTRECYCLEIDS, self.m_tPlayerItemList[i].basicInfo.id)
					end
				end
				--更新字段列表
				if self.m_tPlayerItemList[i][tKey[j]] ~= nil then
					WZLog("*********** 123123123 **********", tKey[j], self:_transferValueByString(tValue[j]), self.m_tPlayerItemList[i][tKey[j]])
					if tKey[j] == "lastNum" and self:_transferValueByString(tValue[j]) > self.m_tPlayerItemList[i][tKey[j]] then
						bIsIncrease = true
					end
					if tKey[j] == "lastTime" then
						self.m_tPlayerItemList[i].receiveTime = SystemTime:getServerTime()
					end
					self.m_tPlayerItemList[i][tKey[j]] = self:_transferValueByString(tValue[j])
				else
					--如果在升阶界面，获得升阶物品
					if tKey[j] == "itemId" then
						self.m_tPlayerItemList[i]["id"] = self:_transferValueByString(tValue[j])
						--物品基础数据
						local key = "id_"..tValue[j]
						self.m_tPlayerItemList[i].basicInfo = GDatatab_item[key]

						if WndAscending.m_root ~= nil and WndAscending.m_nCurTab ~= 2 then
							WndRewardShow:showById({tValue[j]},{1})
						end
					else
						self.m_tPlayerItemList[i].extraInfo[tKey[j]] = self:_transferValueByString(tValue[j])
					end
				end
			end
			
			----更新卡牌数据
			if mainType == 15 then
			----更新武器数据
			--elseif mainType == 0 or mainType == 1 then
			--	self:_updateWeaponData()
			----更新装扮数据
			elseif mainType == 5 then
				self:_updateDecorationData()
			----更新其他数据
			--elseif mainType >= 5 and mainType <= 14 then
			--	self:_updateOtherData()
			----更新材料数据
			--elseif mainType == 6 or mainType == 7 or (mainType >= 11 and mainType <= 13) then
			--	self:_updateMaterialData()
			end
		end
	end
	WZLog("sssdffsd", Serialize(NOTRECYCLEIDS))

	local level = CacheCenter:getPlayerInfo().level
	if tTempItem ~= nil and tTempItem.maintype == 3 and (tTempItem.subtype == 0 or tTempItem.subtype == 1) and tonumber(level) >= tonumber(tTempItem.basicInfo.use_level) then
		--爱心许愿界面这里先不弹礼包打开提示
		WZLog("*********** 444444444 **********", g_bIsShowWndDressUp, bIsIncrease)
		if g_bIsShowWndDressUp == true and bIsIncrease == true then
            tTempItem.nRiseFighting = -1
            MsgBoxManager:showEquipDressUp(tTempItem)
		else
			if bIsIncrease == true then
				tTempItem.nRiseFighting = -1
				table.insert(g_tTempItemForLaterShow, tTempItem)
			end
		end
	end

	--更新钻石、金币数据
	self:_setMoneyList()
	if self.m_bStopUpdateNewData == nil or not self.m_bStopUpdateNewData then
		self:_updateMoneyData()
	end
    
	--货币类型不更新物品
	if mainType ~= 1 or (tTempItem ~= nil and (tTempItem.basicInfo.id == 62 or tTempItem.basicInfo.id == 75 or tTempItem.basicInfo.id == 78 or tTempItem.basicInfo.id == 80)) then
		if self.m_nUpdatePlayerItem == nil then self.m_nUpdatePlayerItem = 0 end
		self.m_nUpdatePlayerItem = self.m_nUpdatePlayerItem + 1
		--DelayCallFunction(self._updatePlayerItemData,self,0.1)
    	self:_updatePlayerItemData()
	end

    WndOwnCity:updateMonthCardRedPoint()

 --    if CacheCenter:getPlayerInfo().level == 10 then
 --    	local isEndTeach, teachStep = TeachGroup1:isTeachFinish(26)
 --    	WZLog("CacheCenter:updatePlayerItems two",teachStep)
 --    	if isEndTeach ~= true and teachStep >= 6 and GlobalGame.g_tWndBottomBarObj then
 --            TeachGroup1:startGroupLevelUp(false, false, true, {26,9,GlobalGame.g_tWndBottomBarObj.m_root})

 --    	end
	-- end
end

--更新玩家宠物列表信息
function CacheCenter:updatePlayerPetInfo(petId, key, value)

   for k1,v1 in pairs(petId) do
   	 for k2,v2 in pairs(self.m_tPlayerPetInfo) do
   	 	if v1==self.m_tPlayerPetInfo[k2].playerPetId then
   	 		self.m_tPlayerPetInfo[k2][key] = value[k1]
   	 	end
   	 end
   end

    --WZLog("CacheCenter:updatePlayerPetInfo", self.m_tPlayerInfo.petMessage,Serialize(petId), Serialize(value),Serialize(self.m_tPlayerPetInfo))
	self:_updatePlayerPetInfoData()
end

--@brief  删除玩家宠物
--@param  petsId : 宠物id
function CacheCenter:removePets(petsId)
	WZLog("CacheCenter:updatePlayerPetInfo = ",#petsId)
    for k1,v1 in pairs(petsId) do
    	for k2,v2 in pairs(self.m_tPlayerPetInfo) do
    		if self.m_tPlayerPetInfo[k2].playerPetId == petsId[k1] then
				table.remove(self.m_tPlayerPetInfo,k2)
			end
    	end
    end
end


--@brief  更新玩家宠物列表信息
function CacheCenter:updatePlayerPetInfoAll(itemId, name, icon,animation,advancedLevel,upgradeLevel ,property,giftSkill, commonSkill1, commonSkill2, isInUsed, playerPetId,num,petExp,fighting,birthSkill,skill, petSkinItemId, fetterStatus)
	WZLog("CacheCenter:updatePlayerPetInfoAll ")

   for k1,v1 in pairs(playerPetId) do
   	 for k2,v2 in pairs(self.m_tPlayerPetInfo) do
   	 	if v1==self.m_tPlayerPetInfo[k2].playerPetId then
   	 		self.m_tPlayerPetInfo[k2].itemId = itemId[k1]
   	 		self.m_tPlayerPetInfo[k2].name = GetPetNameById(itemId[k1],advancedLevel[k1])
   	 		self.m_tPlayerPetInfo[k2].icon = icon[k1]
   	 		self.m_tPlayerPetInfo[k2].animation = animation[k1]
   	 		self.m_tPlayerPetInfo[k2].advancedLevel = advancedLevel[k1]
   	 		self.m_tPlayerPetInfo[k2].upgradeLevel = upgradeLevel[k1]
   	 		self.m_tPlayerPetInfo[k2].property = property[k1]
   	 		self.m_tPlayerPetInfo[k2].giftSkill = giftSkill[k1]
   	 		self.m_tPlayerPetInfo[k2].commonSkill1 = commonSkill1[k1]
   	 		self.m_tPlayerPetInfo[k2].commonSkill2 = commonSkill2[k1]
   	 		self.m_tPlayerPetInfo[k2].isInUsed = isInUsed[k1]
   	 		self.m_tPlayerPetInfo[k2].num = num[k1]
   	 		self.m_tPlayerPetInfo[k2].petExp = petExp[k1]
            self.m_tPlayerPetInfo[k2].fighting = fighting[k1]
            self.m_tPlayerPetInfo[k2].birthSkill = birthSkill[k1]
            self.m_tPlayerPetInfo[k2].skill = skill[k1]
            self.m_tPlayerPetInfo[k2].petSkinItemId = petSkinItemId[k1]
            self.m_tPlayerPetInfo[k2].fetterStatus = fetterStatus[k1]
   	 	end
   	 end
   end
end

--@brief	获取商城商品列表缓存信息
function CacheCenter:getShopItems(fCallback,tData)
    -- 如果数据存在，那么就本地拿数据，否则向服务器发消息获取
	if self.m_tShopItems ~= nil and #self.m_tShopItems > 0 then
		fCallback(tData,self.m_tShopItems)
	else
		if self.m_tShopItemsCallBack == nil then self.m_tShopItemsCallBack = {} end
		table.insert(self.m_tShopItemsCallBack,{fCallback,tData}) 
		if self.m_tShopItemsSended == nil or self.m_tShopItemsSended == false then
			--self.m_tShopItemsSended = true
			ProtocolProcessorWndShop:send_MALL_GetMallList()
        end
	end
end

function CacheCenter:getPriceByItemId(itemId)
	if self.m_tShopItems == nil then
		return -1
	end
	for k,v in pairs(self.m_tShopItems) do
		if v.shopItemId == itemId and (CacheCenter:getGameParam().isUseTicket == "1" and v.moneyId == 1 or v.moneyId == 70) then
			return v.floorPrice
		end
	end
	return -1
end

--@brief 	根据商品id获取商品信息
function CacheCenter:getShopGoodData(shopId)
	if self.m_tShopItems == nil then
		return -1
	end
	--WZLog("--&&&&&&&&&&000---",Serialize(self.m_tShopItems))
	for k,v in pairs(self.m_tShopItems) do
		if v.id == shopId then
			return v
		end
	end
	return -1
end
function CacheCenter:getPriceCostId(itemId)
	if self.m_tShopItems == nil then
		return -1
	end
	for k,v in pairs(self.m_tShopItems) do
		if v.shopItemId == itemId and (CacheCenter:getGameParam().isUseTicket == "1" and v.moneyId == 1 or v.moneyId == 70) then
			return v.moneyId
		end
	end
	return -1
end

--@brief 	根据商品id获取商品信息
function CacheCenter:getShopGoodData(shopId)
	if self.m_tShopItems == nil then
		return -1
	end
	for k,v in pairs(self.m_tShopItems) do
		if v.id == shopId then
			return v
		end
	end
	return -1
end

--@brief    获得成就系统成就界面列表缓存信息
function CacheCenter:getAchieList(fCallback,tData)
	-- body
	WZLog("CacheCenter:getAchieList")
	if self.m_tAchieList ~= nil and #self.m_tAchieList > 0 then
		fCallback(tData,self.m_tAchieList)
	else
		if self.m_tAchieListCallBack == nil then self.m_tAchieListCallBack = {} end
		table.insert(self.m_tAchieListCallBack,{fCallback,tData})
		if self.m_tAchieListSender == nil or self.m_tAchieListSender == false then
			 	self.m_tAchieListSender = true
			 	ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementList()
		end
	end
end

--@brief 更新成就系统成就界面列表缓存信息
--@param  id   子分类属性id
--@param  status  领取按钮的状态
--@param  target  目标数量
--@param  complete  完成数量
--@测试数据	     CacheCenter:updateAchieList( TableToVector({11021, 11022, 11026}, WZLuaVector_int_), TableToVector({1, 1, 1}, WZLuaVector_int_), TableToVector({1, 1, 1}, WZLuaVector_int_), TableToVector({1, 1, 1}, WZLuaVector_int_), TableToVector({1, 1, 1}, WZLuaVector_int_) )
function  CacheCenter:updateAchieList( id, status, count, target, complete )
	-- body
	--系统在玩家完成某项成就之后推过来的
	--更新缓存数据
	if self.m_tAchieList == nil then return end
	local nTargetIndex = 0
	local bIsShowRedDot = false 
	WZLog("CacheCenter:updateAchieList", id:size())
	for k = 0, id:size() - 1 do
		nTargetIndex = nTargetIndex + count:get(k)
		local bIsDealwith = false 
	    --扫描那些不显示但可以获得称号的成就
		for i,value in pairs(self.m_tAchieNotViewList) do
			if id:get(k) == value.id and value.status == 0 then 
				bIsDealwith = true
				local nRealTargetIndex = nTargetIndex - count:get(k)
				value.status  = status:get(k)
				value.target  = target:get(nRealTargetIndex)
				value.complete = complete:get(nRealTargetIndex)
				--Add By Tianxiang_Xu 
				if value.count == 2 then 
					nRealTargetIndex = nRealTargetIndex + 1
					value.target2  = target:get(nRealTargetIndex)
					value.complete2 = complete:get(nRealTargetIndex)
				end
				--End Add
				if value.status == 1 then
					WZLog("id -----------", id:get(k))
					bIsShowRedDot = true
					popupAchie(id:get(k), GDatatab_achievement["id_"..id:get(k)].name)
				end
				--Modified By Tianxiang_Xu
	            if value.complete >= value.target then
	            	if value.count == 1 then
	                	value.complete = value.complete  + 1
	                elseif value.count == 2 and value.complete2  >= value.target2 then 
	                	value.complete = value.complete  + 1
	                end
	            end

	            if WndBag.m_root then
	            	--如果在背包界面，显示成就入口红点
	            	if value.status == 1 then
	                	WndBagMain:setAchieEntryRedPointVisible(true)
	                end
	            end
	            break 
			end
		end
		--扫描那些显示出来的成就
		if not bIsDealwith then
			for i,value in pairs(self.m_tAchieList) do
				for j=1,#value.childList do
					if id:get(k) == value.childList[j].id and value.childList[j].status == 0 then 
						local nRealTargetIndex = nTargetIndex - count:get(k)
						value.childList[j].status  = status:get(k)
						value.childList[j].target  = target:get(nRealTargetIndex)
						value.childList[j].complete = complete:get(nRealTargetIndex)
						
						--Add By Tianxiang_Xu 
						if value.childList[j].count == 2 then 
							nRealTargetIndex = nRealTargetIndex + 1
							value.childList[j].target2  = target:get(nRealTargetIndex)
							value.childList[j].complete2 = complete:get(nRealTargetIndex)
						end
						--End Add
						if value.childList[j].status == 1 then
							value.statusNum = value.statusNum + 1
							bIsShowRedDot = true
							popupAchie(id:get(k), GDatatab_achievement["id_"..id:get(k)].name)
		                    WZLog("statusNum===",value.statusNum)
						end
						--Modified By Tianxiang_Xu
		                if value.childList[j].complete >= value.childList[j].target then
		                	if value.childList[j].count == 1 then
		                    	value.complete = value.complete  + 1
		                    elseif value.childList[j].count == 2 and value.childList[j].complete2  >= value.childList[j].target2 then 
		                    	value.complete = value.complete  + 1
		                    end
		                end
		                --重新排序子成就列表
		                table.sort(value.childList, sortSubAchiList)
		                
		                if WndDesignationMain.m_root then 
		                	--如果是在成就界面，则刷新该界面
		                	WndDesignationMain:resetSubTableInfo(value.childList[j])
		                	WndDesignationMain:updateAchieUI( )
		                end
		                if WndBag.m_root then
		                	--如果在背包界面，显示成就入口红点
		                	if value.childList[j].status == 1 then
		                		WZLog("背包称号红点的显示 222 ")
			                	WndBagMain:setAchieEntryRedPointVisible(true)
			                end
		                end
		                break 
					end
				end
			end
		end
	end
	if bIsShowRedDot then
		CacheCenter:setRedState("btnBag",true)
		GlobalGame:getBtnRedPointEvent():dispatcher()
	end
end

--@brief  设置成就系统称号面板列表数据
function CacheCenter:getDesiList( fCallback , tData )
	-- body

	if self.m_tDesiList ~= nil and #self.m_tDesiList > 0 then
		fCallback(tData, self.m_tDesiList)
	else
		if self.m_tDesiListCallBack == nil then self.m_tDesiListCallBack = {} end
		table.insert(self.m_tDesiListCallBack,{fCallback,tData})
		if self.m_tDesiListSender == nil or self.m_tDesiListSender == false then
			self.m_tDesiListSender = true
			ProtocolProcessorDesignation:send_TITLE_GetTitleList()
		end
	end
end
--@brief  更新成就系统称号面板列表数据
function CacheCenter:updateDesiList(id, sort, name, remain, status)
	-- body
    WZLog("CacheCenter:updateDesiList")
    --Add By Tianxiang_Xu
    --新称号，设置背包红点
    --设置成就入口红点
    local basicData = GDatatab_achievement["id_" .. id]
    if status == 3 and basicData and basicData.view == 0 then
	    g_bHaveNewDesi = true
	    WZLog("****** 成就称号入口红点 000 ******")
	    g_bHaveRedPointForAchieEntry = true
	    CacheCenter:setRedState("btnBag",true)
		GlobalGame:getBtnRedPointEvent():dispatcher()
	end
	--End Add
	local  owned  = false
	if self.m_tDesiList == nil then return end
	for i=1,#self.m_tDesiList do
		if self.m_tDesiList[i].id == id then
			owned = true
			self.m_tDesiList[i].sort     = sort
			self.m_tDesiList[i].name     = name
			self.m_tDesiList[i].remain   = remain
			--Add By Tianxiang_Xu
			--当选中的称号状态变为不可用时，称号变为：暂无称号
			if self.m_tDesiList[i].status == 2 and status == 0 then
				self.m_sDesignationShow = LocalStrings.DESIGNATION_NO
				self.m_nDesignationShowId = nil 
				self:_updateDeShowData()
				WndDesignationMain:updateDesilist()
			end
			--End Add
			self.m_tDesiList[i].status   = status
			table.sort(self.m_tDesiList, sortDesig)
			if self.m_tDesiList[i].status == 2  then
				self.m_sDesignationShow = self.m_tDesiList[i].name
				self.m_nDesignationShowId = self.m_tDesiList[i].id 
				self:_updateDeShowData()
				WndDesignationMain:updateDesilist()
			end
			break
		end
	end
	--还未拥有该称号
	if owned == false then
		local temp_desig = {}
		temp_desig.id  = id
		temp_desig.sort = sort
		temp_desig.name = name
		temp_desig.remain = remain
		temp_desig.status = status
		local tTempData = GDatatab_achievement["id_" .. temp_desig.id]
		if tTempData then 
			temp_desig.view = tTempData.view
			temp_desig.desc = tTempData.desc
		else
			temp_desig.view = 0
			temp_desig.desc = ""
		end
		table.insert(self.m_tDesiList, temp_desig)
		table.sort(self.m_tDesiList, sortDesig)
		if temp_desig.status == 2 then
			self.m_sDesignationShow = temp_desig.name
			self.m_nDesignationShowId = temp_desig.id
			self:_updateDeShowData()
			table.sort(self.m_tDesiList,sortDesig)
			WndDesignationMain:updateDesilist()
		end
	end

	if WndDesignationMain.m_root then 
    	--如果是在称号界面，则刷新称号列表
    	WndDesignationMain:updateDesilist( )
    end
end

--@brief  更新成就系统的显示称号
function CacheCenter:updateShowDesi( id )
	-- body
    WZLog("CacheCenter:updateShowDesi",id,#self.m_tDesiList)
	for i=1,#self.m_tDesiList do
        WZLog("i===",i)
		if self.m_tDesiList[i].id == id then
            if self.m_tDesiList[i].status == 1 or self.m_tDesiList[i].status == 3 then
                self.m_tDesiList[i].status = 2
                self.m_sDesignationShow = self.m_tDesiList[i].name
                self.m_nDesignationShowId = self.m_tDesiList[i].id
            elseif self.m_tDesiList[i].status == 2 then
                self.m_tDesiList[i].status = 1
                self.m_sDesignationShow = LocalStrings.DESIGNATION_NO
                self.m_nDesignationShowId = nil
            end
			
			self:_updateDeShowData()
        else
            if self.m_tDesiList[i].status == 2 then
                self.m_tDesiList[i].status = 1
            end
		end
	end
end

--@brief 	获取缓存当中的剩余成就点数
function CacheCenter:getLeftAchiePoints()
	-- body
	return self.m_nLeftAchiePoints
end

--@brief 	获取缓存当中的剩余成就点数
function CacheCenter:setLeftAchiePoints(nLeftAchievePoint)
	-- body
	self.m_nLeftAchiePoints = nLeftAchievePoint
end

--@brief	获取爱心许愿物品列表缓存信息
function CacheCenter:getLotteryItems()
	return self.m_tLotteryItems
end

--@brief	获取爱心许愿礼盒物品列表缓存信息
function CacheCenter:getZflhItems()
	return self.m_tGiftList
end

--@brief	获取公会信息
function CacheCenter:getGuildInfo()
	return self.m_tGuildInfo
end

--@brief	获取游戏参数
function CacheCenter:getGameParam()
	return self.m_tGameParam
end

--@brief	获取邮件列表
function CacheCenter:getMailList()
	return self.m_tMailList or {}
end

--@brief 	获取已购买活力的次数
function CacheCenter:getActivityUsedTimes()
	-- body
	return self.m_tPlayerInfo.buyTimesPS
end

--@brief	获取单人副本信息
function CacheCenter:getSingleCopyData()
    if self.m_tSingleCopyData == nil then
        ProtocolProcessorGlobal:send_SINGLEMAP_GetPoints(0)
        return
    end
    return self.m_tSingleCopyData
end

--@brief	获取多人副本信息
function CacheCenter:getMultiCopyData()
    if self.m_tMultiCopyData == nil then
        ProtocolProcessorGlobal:send_BOSSMAPROOM_GetBossMapList()
        return
    end
    return self.m_tMultiCopyData
end

--@brief	获取日常副本信息
function CacheCenter:getDailyCopyData()
    if self.m_tDailyCopyData == nil then
        ProtocolProcessorSingleMap:send_SINGLEMAP_GetDailyMap()
        return
    end
    return self.m_tDailyCopyData
end

-- 获取爬塔副本的信息
function CacheCenter:getTowerCopyData()
    if not self.m_tTowerCopyData then
        ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo()
        return nil
    end
    if self.m_tTowerCopyData.timeStr then
    	local strTime = self.m_tTowerCopyData.timeStr
    	local timeStruct = os.date("*t",os.time())
	    local timeStr = string.format("%d%d%02d",timeStruct.year,timeStruct.month,timeStruct.day)
	    if timeStr > strTime then
	    	ProtocolProcessorSingleMap:send_SINGLEMAP_GetTowerInfo()
	    	return nil
	    end
    end
    return self.m_tTowerCopyData
end

-- 初始化坐骑信息
function CacheCenter:getAllMountsData()
	self.m_tMounts = {}
    -- 遍历坐骑获取方式表，初始化
	for i,data in pairs(GDatatab_mounts) do 
		if data.way ~= -1 then
		local temp = {}
		temp.id = data.id
		temp.upgradeLevel = 0
		temp.advancedLevel = 0
		temp.blessingValue = 0
		temp.isPlay = false
		temp.isHave = false
		temp.basicInfo = GDatatab_item["id_"..tostring(data.item_id)]
		temp.property = temp.basicInfo.property
		temp.tItem = data
		table.insert(self.m_tMounts,temp)
		end
	end
end

-- 检查玩家拥有的坐骑数据列表
function CacheCenter:_checkOwnMounts(id,mountsId)
	for i=0,mountsId:size() - 1 do 
		--if tonumber(id) == tonumber(mountsId:get(i)) then return true,i,id end
		if self:getOriginalMount(tonumber(id)) == self:getOriginalMount(tonumber(mountsId:get(i))) then return true,i,id end
	end
	return false
end

function CacheCenter:getOriginalMount(mountsId)
	local curItemID = GDatatab_mounts["id_"..mountsId].item_id
	while self:notOriginalMount(curItemID) do
		for k,v in pairs(GDatatab_mounts_quality_upgrade) do
			if v.id1 == curItemID then
				curItemID = v.id
			end
		end
	end
	WZLog("CacheCenter:getOriginalMount", mountsId, curItemID)
	return curItemID
end

function CacheCenter:notOriginalMount(itemID)
	for k,v in pairs(GDatatab_mounts_quality_upgrade) do
		if v.id1 == itemID then
			return true
		end
	end
	return false
end

-- 坐骑是否显示红点
function CacheCenter:mountDescRedPoint()
	local isOpen = CheckButtonOpen(ISLAND_RIGHT_MOUNT,false)
	for k,v in pairs(self.m_tMounts) do
        local tData = v.tItem.way
        if #tData == 2 then
            local curType = tData[1][2]
            local needLevel = tData[2][2]
            local lv1 = CacheCenter:getPlayerInfo().level
            local lv5 = CacheCenter:getPlayerInfo().tournamentLevel
            local lv6 = CacheCenter:getPlayerInfo().loveLevel
            local lv7 = CacheCenter:getPlayerInfo().guildLevel
            local lv8 = CacheCenter:getPlayerInfo().segmentLevel
            local curLv = {lv1,nil,nil,nil,lv5,lv6,lv7,lv8}
            if needLevel and curLv[curType] >= needLevel and not v.isHave and isOpen then
                CacheCenter:setRedState("btnMount",true)
                return
            end
        elseif #tData == 1 then
            if v.state == false and isOpen then
                CacheCenter:setRedState("btnMount",true)
                return
			end
		elseif #tData == 3 then
			local costId,costCnt = tData[2][2],tData[3][2]

			if costId ~= 1 and CacheCenter:getPlayerItemCountById(costId) >= costCnt and isOpen and not v.isHave then
				CacheCenter:setRedState("btnMount",true)
				return
			end
        end
    end
    CacheCenter:setRedState("btnMount",false)
end

--@brief  拥有战马的数据列表
function CacheCenter:setMountsData(mountsId, upgradeLevel, advancedLevel, blessingValue, property, isPlay, state,upgradeBlessingValue)
	WZLog("CacheCenter:setMountsData",Serialize(VectorToTable(property)))
    -- 如果坐骑列表未初始化，先初始化
	if not self.m_tMounts then  CacheCenter:getAllMountsData() end

    -- 如果当前坐骑，直接返回
    if mountsId:size() == 0 then
        CacheCenter:mountDescRedPoint()
        if WndMounts.m_root then WndMounts:initAllMountsData() end
        return
    end
    -- 同步服务器的坐骑最新信息
	for i,data in pairs(self.m_tMounts) do 
		local isHave,nIndex = self:_checkOwnMounts(data.id,mountsId)
		data.isHave = isHave
		data.isPlay = false 
		if isHave then
			WZLog("华丽恐惧石", data.id, mountsId:get(nIndex))
			data.id = mountsId:get(nIndex)
			data.item_id = GDatatab_mounts["id_"..data.id].item_id
			data.upgradeLevel = upgradeLevel:get(nIndex)
			data.advancedLevel = advancedLevel:get(nIndex)
			data.blessingValue = blessingValue:get(nIndex)
			data.upgradeBless = upgradeBlessingValue:get(nIndex)
			data.isPlay = isPlay:get(nIndex)
			data.property = json.decode(property:get(nIndex))
            data.state = state:get(nIndex)
			data.basicInfo = GDatatab_item["id_"..tostring(data.item_id)]
		end
    end
    CacheCenter:mountDescRedPoint()
	if WndMounts.m_root then WndMounts:initAllMountsData() end
end

--@brief	坐骑成功信息（激活、升级、进阶）
function CacheCenter:updateMountsInfoOK(mountsId, upgradeLevel,advancedLevel, blessingValue, property, isPlay,originType,isResult,state,upgradeBlessingValue)
    WZLog("CacheCenter:updateMountsInfoOK", mountsId, isPlay,upgradeBlessingValue)
	for i,data in pairs(self.m_tMounts) do
		if tonumber(data.id) == tonumber(mountsId) then
			data.upgradeLevel = upgradeLevel
			data.advancedLevel = advancedLevel
			data.blessingValue = blessingValue
			data.upgradeBless = upgradeBlessingValue
			data.isHave = true
			data.isPlay = isPlay
            data.state = state
			data.property = json.decode(property)
            break
		end
    end
    CacheCenter:mountDescRedPoint()
end

--@brief	坐骑改变状态成功信息
function CacheCenter:setAlterMountsStatus(mountsId,isPlay)
    local figureMountId, mountsType = 0, 0
    local figure = FigureSceneManager:getInstance().m_tFigure

	for i,data in pairs(self.m_tMounts) do 
		local isHave,nIndex,mountId = self:_checkOwnMounts(data.id,mountsId)
		data.isPlay = false
		if isHave then data.isPlay = isPlay:get(nIndex) end
        if data.isPlay then
            figureMountId = GDatatab_item["id_"..GDatatab_mounts["id_"..mountId].item_id].animation_index_code
            mountsType = GDatatab_item["id_"..GDatatab_mounts["id_"..mountId].item_id].sub_type
        end
	end

    WZLog("CacheCenter:setAlterMountsStatus",figureMountId, tostring(figure))
    if figure and figureMountId > 0 then

        CacheCenter:getPlayerInfo().mountsId = figureMountId
        CacheCenter:getPlayerInfo().mountsType= mountsType
        local list = FigureSceneManager:getInstance().m_tFigureList
        local index = 0
        for i, v in pairs (list) do
            if v == figure then
                index = i
            end
        end

        table.remove(FigureSceneManager:getInstance().m_tFigureList, index)
        figure:remove()
        figure:destroy()
        FigureSceneManager:getInstance().m_tFigure = nil
        FigureSceneManager:getInstance():initFigure()
    elseif figureMountId > 0 then
        CacheCenter:getPlayerInfo().mountsId = figureMountId
        CacheCenter:getPlayerInfo().mountsType= mountsType
    elseif figure then

        CacheCenter:getPlayerInfo().mountsId = nil
        local list = FigureSceneManager:getInstance().m_tFigureList
        local index = 0
        for i, v in pairs (list) do
            if v == figure then
                index = i
            end
        end
        table.remove(FigureSceneManager:getInstance().m_tFigureList, index)
        figure:remove()
        figure:destroy()
        FigureSceneManager:getInstance().m_tFigure = nil
        FigureSceneManager:getInstance():initFigure()
    else
        CacheCenter:getPlayerInfo().mountsId = nil
    end
end

--@brief	获取战马信息列表
function CacheCenter:getMountInfo()
	if not self.m_tMounts then
        CacheCenter:getAllMountsData()
        ProtocolProcessorWndMounts:send_MOUNTS_GetAllMountsList()
        return false
    end
	return self.m_tMounts
end

function CacheCenter:fightMountMaxUpOrStar()
	-- 判断当前坐骑是否可以继续提升
	for i,data in pairs(self.m_tMounts) do
		if data.isPlay then
			local upgradeLevel = data.upgradeLevel
			local advancedLevel = data.advancedLevel
			return upgradeLevel == CacheCenter:getPlayerInfo(), advancedLevel == 10
		end
	end
	return false,false
end


--@brief  设置活跃系统缓存信息
function CacheCenter:setActiveCacehInfo(awardInfo,activityInfo)
    self.m_tActiveInfoList = {}
    self.m_tActiveInfoList.awardInfo = CopyTable(awardInfo)
    self.m_tActiveInfoList.activityInfo = CopyTable(activityInfo)

end

--@brief  获取活跃值缓存信息
function CacheCenter:getActiveCacheInfo()
    return self.m_tActiveInfoList
end

--@brief    获取排行榜数据
function CacheCenter:getRankListInfo()
    return self.m_tRankListInfo
end

--@brief    获取我自己的排行榜数据
function CacheCenter:getMyRankListInfo()
    return self.m_tMyRankListInfo
end

--@brief	获取师徒数据
function CacheCenter:getMasterInfo()
	return self.m_tMasterInfo
end

--@brief	获取联赛信息
function CacheCenter:getLeagueInfo()
	return self.m_tLeagueInfo
end

--@brief	获取广告信息
function CacheCenter:getAdMessage()
	--self.m_tAdMessage = {
	--		{imgUrl="http://touxiang.qqzhi.com/uploads/2012-11/1111120115826.jpg",params=59,sort=99},
	--		{imgUrl="http://touxiang.qqzhi.com/uploads/2012-11/1111101855912.jpg",params=43,sort=98},
	--		{imgUrl="http://touxiang.qqzhi.com/uploads/2012-11/1111014459644.jpg",params=45,sort=97},
	--		{imgUrl="http://touxiang.qqzhi.com/uploads/2012-11/1111135438547.jpg",params=67,sort=96},
	--}
	return self.m_tAdMessage
end
-------------------------------------注册、反注册数据观察函数Begin--------------------------------------

--@brief	注册更新好友列表(结婚，邮件，私聊)数据回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerFriendListObserver(tObserver)
	if self.m_tFriendListObservers == nil then
		self.m_tFriendListObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tFriendListObservers do
		if self.m_tFriendListObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tFriendListObservers, tObserver)
end

--@brief	取消注册更新好友列表(结婚，邮件，私聊)数据回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterFriendListObserver(tObserver)
	if self.m_tFriendListObservers == nil then
		return 
	end	
	for i,data in pairs(self.m_tFriendListObservers) do
		if data == tObserver then
			table.remove(self.m_tFriendListObservers,i)
		end
		WZLog("unregisterFriendListObserver:i:B:",i,data,tObserver)		
	end
end

--@brief	注册更新玩家数据回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpatePlayerInfoObserver(tObserver)
	if self.m_tPlayerInfoObservers == nil then
		self.m_tPlayerInfoObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tPlayerInfoObservers do
		if self.m_tPlayerInfoObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tPlayerInfoObservers, tObserver)
end

--@brief	取消注册更新玩家数据回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpatePlayerInfoObserver(tObserver)
	if self.m_tPlayerInfoObservers ~= nil then
		for i=1,#self.m_tPlayerInfoObservers do
			if self.m_tPlayerInfoObservers[i] == tObserver then
				table.remove(self.m_tPlayerInfoObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册物品列表更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpatePlayerItemObserver(tObserver)
	if self.m_tPlayerItemObservers == nil then
		self.m_tPlayerItemObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tPlayerItemObservers do
		if self.m_tPlayerItemObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tPlayerItemObservers, tObserver)
end

--@brief	取消注册物品列表更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpatePlayerItemObserver(tObserver)
	if self.m_tPlayerItemObservers ~= nil then
		for i=1,#self.m_tPlayerItemObservers do
			if self.m_tPlayerItemObservers[i] == tObserver then
				table.remove(self.m_tPlayerItemObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册更新玩家宠物数据回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpatePlayerPetInfoObserver(tObserver)
	WZLog("CacheCenter:registerUpatePlayerPetInfoObserver")
	if self.m_tPlayerPetInfoObservers == nil then
		self.m_tPlayerPetInfoObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tPlayerPetInfoObservers do
		if self.m_tPlayerPetInfoObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tPlayerPetInfoObservers, tObserver)
end

--@brief	取消注册更新玩家宠物数据回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpatePlayerPetInfoObserver(tObserver)
	WZLog("CacheCenter:unregisterUpatePlayerPetInfoObserver")
	if self.m_tPlayerPetInfoObservers ~= nil then
		for i=1,#self.m_tPlayerPetInfoObservers do
			if self.m_tPlayerPetInfoObservers[i] == tObserver then
				table.remove(self.m_tPlayerPetInfoObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册货币更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpateMoneyObserver(tObserver)
	if self.m_tMoneyObservers == nil then
		self.m_tMoneyObservers = {}
	end
	table.insert(self.m_tMoneyObservers, tObserver)
end

--@brief	取消注册货币更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpateMoneyObserver(tObserver)
	if self.m_tMoneyObservers ~= nil then
		for i=1,#self.m_tMoneyObservers do
			if self.m_tMoneyObservers[i] == tObserver then
				table.remove(self.m_tMoneyObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册武器更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpdateWeaponObserver(tObserver)
	if self.m_tWeaponObservers == nil then
		self.m_tWeaponObservers = {}
	end
	table.insert(self.m_tWeaponObservers, tObserver)
end

--@brief	取消注册武器更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpateWeaponObserver(tObserver)
	if self.m_tWeaponObservers ~= nil then
		for i=1,#self.m_tWeaponObservers do
			if self.m_tWeaponObservers[i] == tObserver then
				table.remove(self.m_tWeaponObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册装扮更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpdateDecorationObserver(tObserver)
	if self.m_tDecorationObservers == nil then
		self.m_tDecorationObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tDecorationObservers do
		if self.m_tDecorationObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tDecorationObservers, tObserver)
end

--@brief	取消注册装扮更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpateDecorationObserver(tObserver)
	if self.m_tDecorationObservers ~= nil then
		for i=1,#self.m_tDecorationObservers do
			if self.m_tDecorationObservers[i] == tObserver then
				table.remove(self.m_tDecorationObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册其他更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpdateOtherObserver(tObserver)
	if self.m_tOtherObservers == nil then
		self.m_tOtherObservers = {}
	end
	for i,data in pairs(self.m_tOtherObservers) do 
		if data == tObserver then
			return
		end
	end
	table.insert(self.m_tOtherObservers, tObserver)
end

--@brief	取消注册其他更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpateOtherObserver(tObserver)
	if self.m_tOtherObservers ~= nil then
		for i=1,#self.m_tOtherObservers do
			if self.m_tOtherObservers[i] == tObserver then
				table.remove(self.m_tOtherObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册材料更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpdateMaterialObserver(tObserver)
	if self.m_tMaterialObservers == nil then
		self.m_tMaterialObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tMaterialObservers do
		if self.m_tMaterialObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tMaterialObservers, tObserver)
end

--@brief	取消注册材料更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpateMaterialObserver(tObserver)
	if self.m_tMaterialObservers ~= nil then
		for i=1,#self.m_tMaterialObservers do
			if self.m_tMaterialObservers[i] == tObserver then
				table.remove(self.m_tMaterialObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册更新显示称号回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpatemDeShowObservers(tObserver)
	if self.m_sDeShowObservers == nil then
		self.m_sDeShowObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_sDeShowObservers do
		if self.m_sDeShowObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_sDeShowObservers, tObserver)
end

--@brief	取消注册更新显示称号回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpatemDeShowObservers(tObserver)
	if self.m_sDeShowObservers ~= nil then
		for i=1,#self.m_sDeShowObservers do
			if self.m_sDeShowObservers[i] == tObserver then
				table.remove(self.m_sDeShowObservers, i)
				do return end
			end
		end
	end
end

--@brief  初始化跨天的状态
function CacheCenter:initNewDayState()
	if self.m_tNextDay == nil then 
		self.m_tNextDay = {
			SignIn = {state=false,time=0},
		}
	end 
end

--@brief 	获得跨天信息
function CacheCenter:isNewDay( Key )
	if self.m_tNextDay == nil then 
		self:initNewDayState()
	end 
	return self.m_tNextDay[tostring(Key)]
end

--@brief  设置跨天状态
function CacheCenter:setIsNewDayState( nTime )
	self:initNewDayState()
	for i,v in pairs(self.m_tNextDay)  do
		v.state = true 
		v.time = nTime
	end
end

--@brief  重置跨天状态
function CacheCenter:resetNewDayState( Key )
	self.m_tNextDay[tostring(Key)].state = false 
	self.m_tNextDay[tostring(Key)].time = 0 
end

--@brief  更新技能道具信息
--@param  skillId : 技能ID
--@param  skillExp : 技能经验
function CacheCenter:updateSkillList(skillId,skillExp)
	WZLog("CacheCenter:updateSkillList =",Serialize(skillId))
	self.m_tSkillList = {} 
	self.m_tSkillList.itemId = skillId
	self.m_tSkillList.expv = skillExp
end

--@brief  更新玩家技能列表信息
--@param  skillId：技能ID
--@param  unlockRemark:未解锁的格子说明
function CacheCenter:updatePlayerSkill(skillId,unlockRemark)
	WZLog("CacheCenter:updatePlayerSkill")
	self.m_tPlayerSkill = {}
	self.m_tPlayerSkill.skillId = skillId
	self.m_tPlayerSkill.skillExplain = unlockRemark
end

--@brief  获取玩家技能信息
function CacheCenter:getPlayerSkill()
	WZLog("CacheCenter:getPlayerSkill", Serialize(self.m_tPlayerSkill))
	return self.m_tPlayerSkill
end

--@brief 获取技能道具列表
function CacheCenter:getSkillList()
	WZLog("CacheCenter:getSkillList", Serialize(self.m_tSkillList))
	return self.m_tSkillList
end

--@brief 	获取邀请码好友列表
function CacheCenter:getInviteFriendList()
	-- body
	return self.m_tInviteFriends
end

--@brief 	获取邀请码任务列表
function CacheCenter:getInviteTaskList()
	-- body
	return self.m_tInviteTaskList
end

--@brief 	获取我的邀请码列表
function CacheCenter:getMyInviteCode()
	-- body
	return self.m_sMyInviteCode
end

--@brief 	获取邀请码提交状态列表
function CacheCenter:getInviteCodeState()
	-- body
	if self.m_nInviteState == nil then 
		return 0 
	end
	return self.m_nInviteState
end

--@brief 	获取密友数量
function CacheCenter:getBestFriendNum()
	-- body
	local nBestFriendNum = 0 
	if self.m_tFriend == nil then 
		return nBestFriendNum
	end

	for i = 1, #self.m_tFriend do
		if self.m_tFriend[i].bBestFriend == 1 then
			nBestFriendNum = nBestFriendNum + 1
		end
	end

	return nBestFriendNum
end

--@brief 	根据id获取好友名字
function CacheCenter:getFriendNameById(id)
	-- body
	local name = "" 
	if self.m_tFriend == nil then
		return name
	end

	for i = 1, #self.m_tFriend do
		if self.m_tFriend[i].id == id then
			name = self.m_tFriend[i].name
			break 
		end
	end

	return name 
end

--@brief 	根据id检测是否为蜜友
function CacheCenter:judgeWhetherBestFriend(id)
	-- body
	local bBestFriend = false

	for i = 1, #self.m_tFriend do
		if self.m_tFriend[i].id == id and self.m_tFriend[i].bBestFriend == 1 then
			bBestFriend = true
			break
		end
	end

	return bBestFriend 
end

--@brief 	根据id检测是否为蜜友或师徒或夫妻
function CacheCenter:judgeWhetherHaveRelation(id)
	-- body
	local bHave = false

	for i = 1, #self.m_tFriend do
		if self.m_tFriend[i].id == id then
			WZLog("CacheCenter:judgeWhetherHaveRelation", self.m_tFriend[i].bBestFriend, self.m_tFriend[i].isMentoring, self.m_tFriend[i].relation)
			if self.m_tFriend[i].bBestFriend == 1 then
				bHave = true
			elseif self.m_tFriend[i].relation > 0 then
				bHave = true
			end
			break
		end
	end

	return bHave 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新 好友列表(结婚，邮件，私聊)数据回调函数
function CacheCenter:_receiveFriendListData()
	if self.m_tFriendListObservers == nil then
		return
	end
	for i,data in pairs(self.m_tFriendListObservers) do 
		if data.m_root and data.receiveFriendListData then
			data:receiveFriendListData()
		end
	end
end

--@brief	删除物品列表缓存信息
function CacheCenter:_removePlayerItem(playerItemId)
	if self.m_tPlayerItemList ~= nil then
		for i=1,#self.m_tPlayerItemList do
			if self.m_tPlayerItemList[i].playerItemId == playerItemId then
				table.remove(self.m_tPlayerItemList, i)
				do return end
			end
		end
	end
end

--@brief	接收到玩家物品数据回调
function CacheCenter:_receivePlayerItemData()
	WZLog("CacheCenter:_receivePlayerItemData")
	if self.m_tPlayerItemObservers ~= nil then
		for i=1,#self.m_tPlayerItemObservers do
			if self.m_tPlayerItemObservers[i].receivePlayerItemData ~= nil then
				self.m_tPlayerItemObservers[i]:receivePlayerItemData()
			end
		end
	end
end

--@brief	更新玩家基础缓存数据变化
function CacheCenter:_updatePlayerInfoData()
	self.m_nUpdatePlayerInfo = self.m_nUpdatePlayerInfo - 1
	if self.m_nUpdatePlayerInfo < 0 then self.m_nUpdatePlayerInfo = 0 end
	if self.m_nUpdatePlayerInfo ~= 0 then return end
	WZLog("CacheCenter:_updatePlayerInfoData")

	if self.m_tPlayerInfoObservers ~= nil then
		for i=1,#self.m_tPlayerInfoObservers do
			if self.m_tPlayerInfoObservers[i].updatePlayerInfoData ~= nil then
				self.m_tPlayerInfoObservers[i]:updatePlayerInfoData()
			end
		end
	end

	--Add By Tianxiang_Xu
    if g_tTempSignData ~= nil then
        --WZLog("******* 123123 *******", Serialize(g_tTempSignData))
        if g_tTempSignData.sign == true and g_tTempSignData.vipSign == false and g_tTempSignData.isVip == true and g_tTempSignData.vip_level <= CacheCenter:getPlayerInfo().vipLevel then
            CacheCenter:setRedState("btnSign",true) 
            GlobalGame:getBtnRedPointEvent():dispatcher("Sign",true)
            --WZLog("******* 123123 111*******", Serialize(g_tTempSignData))
        end
    end
    --Vip升级后，如果在好友界面，刷新界面的好友数量
    if WndFriends then
    	if WndFriends.m_root ~= nil then
    		WndFriends:updateFriendsNum()
    	end
	end
    --End Add
end

--@brief	更新物品变化数据
function CacheCenter:_updatePlayerItemData()
	WZLog("CacheCenter:_updatePlayerItemData",self.m_nUpdating)
	self.m_nUpdatePlayerItem = self.m_nUpdatePlayerItem - 1
	if self.m_nUpdatePlayerItem < 0 then self.m_nUpdatePlayerItem = 0 end
	--if self.m_nUpdatePlayerItem ~= 0 then return end
	--if self.m_nUpdating == true then return end
	if self.m_tPlayerItemObservers ~= nil then
		self.m_nUpdating = true
		for i=1,#self.m_tPlayerItemObservers do
			WZLog("CacheCenter:_updatePlayerItemData1",#self.m_tPlayerItemObservers,i)
			--local tableName = ""
			--for k,v in pairs(_G) do
			--	if v == self.m_tPlayerItemObservers[i] then
			--		tableName = k
			--	end
			--end
    		--local startTime = WZThread:getUTickCount()
			--出错self.m_nUpdating不会设置回false
			if self.m_tPlayerItemObservers[i].updatePlayerItemData ~= nil then
				self.m_tPlayerItemObservers[i]:updatePlayerItemData()
			end
    		--local endTime = WZThread:getUTickCount()
			--WZLog(tableName.."消耗时间",endTime-startTime,"微秒")
		end
		self.m_nUpdating = false
	end

    WndOwnCity:updateMonthCardRedPoint()
    WndOwnCity:updateCardWelfare()
    CacheCenter:updateFootMarkRedPoint()
end

--@brief	更新玩家宠物缓存数据变化
function CacheCenter:_updatePlayerPetInfoData()
	WZLog("CacheCenter:_updatePlayerPetInfoData ", #self.m_tPlayerPetInfoObservers)
	if self.m_tPlayerPetInfoObservers ~= nil then
		for i=1,#self.m_tPlayerPetInfoObservers do
			if self.m_tPlayerPetInfoObservers[i].updatePlayerPetInfoData ~= nil then
				self.m_tPlayerPetInfoObservers[i]:updatePlayerPetInfoData()
			end
		end
	end
end

--@brief	更新玩家基础缓存数据变化
function CacheCenter:_updateMoneyData()
	WZLog("CacheCenter:_updateMoneyData", self.m_tMoneyObservers)
	if self.m_tMoneyObservers ~= nil then
		for i=1,#self.m_tMoneyObservers do
			if self.m_tMoneyObservers[i].updateMoneyData ~= nil then
				self.m_tMoneyObservers[i]:updateMoneyData()
			end
		end
	end
end

--@brief	更新武器列表缓存数据变化
function CacheCenter:_updateWeaponData()
	WZLog("CacheCenter:_updateWeaponData")
	if self.m_tWeaponObservers ~= nil then
		for i=1,#self.m_tWeaponObservers do
			if self.m_tWeaponObservers[i].updateWeaponData ~= nil then
				self.m_tWeaponObservers[i]:updateWeaponData()
			end
		end
	end
end

--@brief	更新装扮列表缓存数据变化
function CacheCenter:_updateDecorationData()
	WZLog("CacheCenter:_updateDecorationData")
	if self.m_tDecorationObservers ~= nil then
		for i=1,#self.m_tDecorationObservers do
			if self.m_tDecorationObservers[i].updateDecorationData ~= nil then
				self.m_tDecorationObservers[i]:updateDecorationData()
			end
		end
	end
end

--@brief	更新其他列表缓存数据变化
function CacheCenter:_updateOtherData()
	WZLog("CacheCenter:_updateOtherData")
	if self.m_tOtherObservers ~= nil then
		for i=1,#self.m_tOtherObservers do
			if self.m_tOtherObservers[i].updateOtherData ~= nil then
				self.m_tOtherObservers[i]:updateOtherData()
			end
		end
	end
end

--@brief	判断缓存中是否有宠物数据
--return    true:已有数据，false: 没有数据
function CacheCenter:hasPlayerPetInfo()
	if self.m_tPlayerPetInfo == nil or #self.m_tPlayerPetInfo == 0 then
		return false
	else
		return true
	end
end


--@brief	更新材料列表缓存数据变化
function CacheCenter:_updateMaterialData()
	WZLog("CacheCenter:_updateMaterialData")
	if self.m_tMaterialObservers ~= nil then
		for i=1,#self.m_tMaterialObservers do
			if self.m_tMaterialObservers[i].updateMaterialData ~= nil then
				self.m_tMaterialObservers[i]:updateMaterialData()
			end
		end
	end
end

--@brief	获取玩家宠物信息
function CacheCenter:getPlayerPetInfo()
	return self.m_tPlayerPetInfo
end

--@brief 	获取星魂缓存数据
function CacheCenter:getStarSoulList()
	--body
	if self.m_tStarSoulList == nil then
		self:setStarSoulList()
	end
	return self.m_tStarSoulList
end

--@brief	更新显示称号缓存数据变化
function CacheCenter:_updateDeShowData()
	WZLog("CacheCenter:_updateDeShowData")
	if self.m_sDeShowObservers ~= nil then
        WZLog("#self.m_sDeShowObservers===",#self.m_sDeShowObservers)
		for i=1,#self.m_sDeShowObservers do
			if self.m_sDeShowObservers[i].updateDesiShow ~= nil then
				if self.m_sDesignationShow == nil then
					self.m_sDesignationShow = LocalStrings.DESIGNATION_NO
					self.m_nDesignationShowId = nil 
				end
				self.m_sDeShowObservers[i]:updateDesiShow(self.m_nDesignationShowId)
			end
		end
	end
end

--@brief	转换字符串为真正值类型
--@param	text 待转换的字符串
function CacheCenter:_transferValueByString(sText)
	local nType = type(sText)
	if nType ~= "string" then
		return sText
	end

	local sValue = tonumber(sText)

	if string.lower(sText) == "true" then
		return true
	elseif string.lower(sText) == "false" then
		return false
	elseif sValue ~= nil then
		return sValue
	else
		return sText
	end
end

function CacheCenter:_checkHasPlayerLevel(key,value)
	if tostring(key) == "level" then
		return GlobalGame:checkGlobalPlayerLevel(value)
	else
		return value
	end
end

--@brief    检查等级更新
function CacheCenter:_checkHasUpdatePlayerLevel(key)
	if tostring(key) == "level" then
		return true
	else
		return false
	end
end

--@brief    检查战斗力
function CacheCenter:_checkHasPlayerFighting(key,value)
	if tostring(key) == "fighting" then
		WZLog("当前战斗力",self.m_tPlayerInfo.fighting,value)
		if tonumber(value) - tonumber(self.m_tPlayerInfo.fighting) == 0 then 
			WZLog("战斗力数值没变")
			return false
		end
		GlobalGame.g_tInfo.m_nFighting = tonumber(value) - tonumber(self.m_tPlayerInfo.fighting)
		return true
	end
	return false
end

--@brief    判断table中是否含有某元素
--@param    tDestTable  目标table  value 需要判断的元素值
function CacheCenter:_isInTable(tDestTable, value)
	if tDestTable == nil then
		return false
	end

	for i=1,#tDestTable do
		if tDestTable[i] == value then
			return true
		end
	end

	return false
end

--@brief    检查武器物品的推荐，如果存在同类型的推荐，就换成新的推荐
function CacheCenter:_checkWeaponRecommend(tData)
	WZLog("CacheCenter:_checkWeaponRecommend", #tData)
	if tData == nil or #tData == 0 then
		return
	end
	local maxFighting = {0,0,0,0,0,0,0,0}
	local maxTag = {0,0,0,0,0,0,0,0} --未穿上的装备战斗力最高的index
	--已装备物品的战斗力
	local equipedFighting = {0,0,0,0,0,0,0,0}
	for i,data in pairs(tData) do 
		data.recommended = false 
		if data.maintype == 4 then
			if data.subtype == 0 or data.subtype == 1 then
				local fight = data.extraInfo.fighting or 0 
				fight = tonumber(fight) or 0
				if data.isUse == false and fight > maxFighting[1] then
					maxFighting[1] = fight
					maxTag[1] = i
				end
				--记录已装备物品的战斗力
				if data.isUse == true then
					equipedFighting[1] = fight
				end
			else
				local fight = data.extraInfo.fighting or 0 
				fight = tonumber(fight) or 0
				if data.isUse == false and fight > maxFighting[data.subtype] then
					maxFighting[data.subtype] = fight
					maxTag[data.subtype] = i
				end
				--记录已装备物品的战斗力
				if data.isUse == true then
					equipedFighting[data.subtype] = fight
				end
			end
		end
	end

	for i=1,8 do
		if maxTag[i] ~= 0 then 
			--WZLog("CacheCenter:_checkWeaponRecommend1", tData[maxTag[i]].extraInfo.fighting, equipedFighting[tData[maxTag[i]].subtype])
			--WZLog("CacheCenter:_checkWeaponRecommend2", Serialize(tData[maxTag[i]]))
			local index = tData[maxTag[i]].subtype
			if index == 0 then index = 1 end
			if tData[maxTag[i]].isUse == false and tData[maxTag[i]].extraInfo.fighting > equipedFighting[index] then
				tData[maxTag[i]].recommended = true
			end
		end
	end
end

function CacheCenter:getHeadAndBodyColor()
    if self.m_tPlayerItemList == nil then return end
	local list = self.m_tPlayerItemList
	local head,body = 0,0
	if list == nil then return 0,0 end
	for i=1,#list do
		if list[i].maintype == 5 and list[i].subtype == 0 and list[i].isUse then
			head = list[i].color
		end
		if list[i].maintype == 5 and list[i].subtype == 2 and list[i].isUse then
			body = list[i].color
		end
	end

	return head,body
end

--@brief  	获取物品是否上架
function CacheCenter:itemIsOnSale(id)
	-- body
	local isOnSale = false
	if self.m_tShopItems == nil or #self.m_tShopItems == 0 then 
		return isOnSale
	end
	
    for k,v in pairs(self.m_tShopItems) do
        if v.shopItemId == id then
            isOnSale = v.isOnSale
            break
        end
    end

    return isOnSale
end

-- 获取月卡天数
function CacheCenter:getMouthCardDays()
	local day = 0
	local tPlayerItemsList = CacheCenter:getPlayerItems()
	for i = 1, #tPlayerItemsList do
		if tPlayerItemsList[i].id == 50 or tPlayerItemsList[i].id == 51 then
			day =day + tPlayerItemsList[i].lastTime
		end
	end

	day = math.floor(day/3600/24)
	return day
end

-- 获取月卡是否可购买
function CacheCenter:canBuyMouthCard()
	local day = CacheCenter:getMouthCardDays()
	local limitDay = CacheCenter:getGameParam().limitMonthlyCardDay
	WZLog("--------card day----------",day,CacheCenter:getGameParam().limitMonthlyCardDay)
	if day >= tonumber(limitDay) then
		return true
	end
	return false
end

--获取私聊缓存
function CacheCenter:getChatCache()
	WZLog("CacheCenter:getChatCache")
	return self.m_tChatCache
end

--重置私聊缓存
function CacheCenter:resetChatCache()
	WZLog("CacheCenter:resetChatCache")
	self.m_tChatCache = {}
end

--@brief 	获取公会战目标数据
function CacheCenter:getGuildWarTargetData()
	-- body
	return self.m_tGuildWarTargetData
end

--@brief 	判断某一Id的称号是否使用
function CacheCenter:judgeWhetherDesiUsed(id)
	-- body
	if self.m_tDesiList == nil or #self.m_tDesiList == 0 then return false end

	for i = 1, #self.m_tDesiList do
		if self.m_tDesiList[i].id == id and self.m_tDesiList[i].status == 2 then
			return true
		end
	end

	return false 
end

--@brief 	成就是否有红点
function CacheCenter:whetherAchieHaveRedDot()
	-- body
	local bHave = false

	if self.m_tAchieList == nil then return bHave end 
	
	for i = 1, #self.m_tAchieList do
		if self.m_tAchieList[i].statusNum > 0 then
			bHave = true 
			break 
		end
	end

	return bHave 
end

--@brief 	获取新手定推已经触发的礼包
function CacheCenter:getNewUserPackageList()
	-- body
	-- if self.m_tNewUserPackageList == nil then 
		-- self.m_tNewUserPackageList = {}
		-- local nCurTime = SystemTime:getServerTime()
		-- self.m_tNewUserPackageList[1] = {pushInfo = "[1,179]", funcId = 11, lastNum = 1, endTime = nCurTime + 100, originPrice = "[0,$70]"}
		-- self.m_tNewUserPackageList[2] = {pushInfo = "[2,4004]", funcId = 27, lastNum = 1, endTime = nCurTime + 10000000, originPrice = "[1,70]"}
		-- self.m_tNewUserPackageList[3] = {pushInfo = "[1,179]", funcId = 41, lastNum = 1, endTime = nCurTime + 10000000, originPrice = "[1,70]"}
		-- self.m_tNewUserPackageList[4] = {pushInfo = "[1,179]", funcId = 43, lastNum = 1, endTime = nCurTime + 10000000, originPrice = "[1,70]"}
		-- self.m_tNewUserPackageList[5] = {pushInfo = "[1,179]", funcId = 64, lastNum = 1, endTime = nCurTime + 10000000, originPrice = "[1,70]"}
		-- self.m_tNewUserPackageList[6] = {pushInfo = "[1,179]", funcId = 131, lastNum = 1, endTime = nCurTime + 10000000, originPrice = "[1,70]"}
		-- self.m_tNewUserPackageList[7] = {pushInfo = "[1,179]", funcId = 28, lastNum = 1, endTime = nCurTime + 10000000, originPrice = "[1,70]"}
		-- self.m_tNewUserPackageList[8] = {pushInfo = "[1,179]", funcId = 76, lastNum = 1, endTime = nCurTime + 10000000, originPrice = "[1,70]"}
	-- end
	return self.m_tNewUserPackageList
end

--@brief 	获取登录定推已经触发的礼包
function CacheCenter:getLimitPackageList()
	-- self.m_tLimitPackageList={}
	-- local nCurTime = SystemTime:getServerTime()
	-- self.m_tLimitPackageList[1] = {pushInfo = "[1,12]", lastNum = 1, endTime = nCurTime + 100, originPrice = "[0,$70]"}
	-- self.m_tLimitPackageList[2] = {pushInfo = "[2,4004]", lastNum = 1, endTime = nCurTime + 10000000, originPrice = "[1,70]"}

	return self.m_tLimitPackageList
end

--@brief	获取足迹信息列表
function CacheCenter:getFootMarkInfo()
	if not self.m_tFootMarkList then
        CacheCenter:getAllFootMarkData()
        ProtocolProcessorFootMark:send_FOOTMARK_GetFootmark()
        return false
    end
	return self.m_tFootMarkList
end

--@brief 	初始化所有足迹
function CacheCenter:getAllFootMarkData()
	self.m_tFootMarkList = {}
    -- 遍历坐骑获取方式表，初始化
	for i, data in pairs(GDatatab_footmark) do 
		if data.way ~= -1 then
			local temp = {}
			temp.id = data.id
			temp.upgradeLevel = 0
			temp.advancedLevel = 0
			temp.blessingValue = 0
			temp.remainTime = 0 
			temp.isHave = false
			temp.basicInfo = GDatatab_item["id_" .. tostring(data.item_id)]
			temp.property = data.property
			temp.tItem = data
			temp.item_id = data.item_id
			table.insert(self.m_tFootMarkList, temp)
		end
	end
end

--@brief 	获取当前正在使用的足迹的ID
function CacheCenter:getUsingFootMarkId()
	-- body
	return self.m_nUseFootMarkId
end

--@brief 	是否已经拥有该类型永久的足迹
--@note 	itemId : 使用的足迹物品id
function CacheCenter:wetherActiveForever(itemId)
	-- body
	if self.m_tFootMarkList == nil or #self.m_tFootMarkList == 0 then return false end

	for i = 1, #self.m_tFootMarkList do
		local tTempData = GDatatab_item["id_" .. itemId]
		if tTempData.sub_type == self.m_tFootMarkList[i].basicInfo.sub_type and self.m_tFootMarkList[i].remainTime == -1 then 
			return true
		end
	end

	return false 
end

--@brief 	获取觉醒之技的等级
function CacheCenter:getAwakeSkillLevel()
	-- body
	if self.m_tPlayerInfo.awakeSkillId == nil or self.m_tPlayerInfo.awakeSkillId == "" then 
		return 1
	end

	local tAwakeSkillId = SplitStringWithSeparator(self.m_tPlayerInfo.awakeSkillId, "|", nil, true)

	local tBasicData = GDatatab_skill["id_" .. tAwakeSkillId[1]]
	local nAwakeSkillLevel = tBasicData.specialAttackParam 

	return nAwakeSkillLevel 
end

--@brief 	获取玩家保存的套装数据
function CacheCenter:getDressSuitData()
	-- body
	return self.m_tDressSuit
end

--@brief	注册玩家套装更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpateDressSuitObserver(tObserver)
	if self.m_tDressSuitObservers == nil then
		self.m_tDressSuitObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tDressSuitObservers do
		if self.m_tDressSuitObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tDressSuitObservers, tObserver)
end

--@brief	取消注册玩家套装更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpateDressSuitObserver(tObserver)
	if self.m_tDressSuitObservers ~= nil then
		for i=1,#self.m_tDressSuitObservers do
			if self.m_tDressSuitObservers[i] == tObserver then
				table.remove(self.m_tDressSuitObservers, i)
				do return end
			end
		end
	end
end

--@brief 多套时装回调
--@param 	nType : 1->收起列表;其他更新列表
function CacheCenter:updateDressSuitData(nType)
	-- body
	if self.m_tDressSuitObservers ~= nil then
		for i=1,#self.m_tDressSuitObservers do
			if self.m_tDressSuitObservers[i].updateDressSuitData ~= nil then
				self.m_tDressSuitObservers[i]:updateDressSuitData(nType)
			end
		end
	end
end

--@brief	批量更新物品列表缓存信息
--@param    playerItemId:物品唯一id，tValue：属性值列表
function CacheCenter:batchUpdatePlayerItems(playerItemId, tValue)
	if playerItemId == nil or tValue == nil then
		return
	end

	local tTempItem = nil 

	WZLog("CacheCenter:batchUpdatePlayerItems zero", #playerItemId, Serialize(playerItemId))
	NOTRECYCLEIDS = {}
	for k = 1, #playerItemId do
		for i=1,#self.m_tPlayerItemList do
			if self.m_tPlayerItemList[i].playerItemId == playerItemId[k] then
				tTempItem = self.m_tPlayerItemList[i]
				mainType = self.m_tPlayerItemList[i].maintype
				WZLog("CacheCenter:batchUpdatePlayerItems one", self.m_tPlayerItemList[i].id, self.m_tPlayerItemList[i].lastTime)
				local tKey = json.decode(tValue[k])
				for key, v in pairs(tKey) do
					WZLog("CacheCenter:batchUpdatePlayerItems", key, v)
					if self.m_tPlayerItemList[i].basicInfo.main_type == 5 then
						if tonumber(self.m_tPlayerItemList[i][key]) ~= -1 and tonumber(v) == -1 then
							WZLog("增加NOTRECYCLEIDS",self.m_tPlayerItemList[i].basicInfo.id)
							table.insert(NOTRECYCLEIDS, self.m_tPlayerItemList[i].basicInfo.id)
						end
					end
					--更新字段列表
					if self.m_tPlayerItemList[i][key] ~= nil then
						if key == "lastTime" then
							self.m_tPlayerItemList[i].receiveTime = SystemTime:getServerTime()
						end
						self.m_tPlayerItemList[i][key] = self:_transferValueByString(v)
					else
						--如果在升阶界面，获得升阶物品
						if key == "itemId" then
							self.m_tPlayerItemList[i]["id"] = self:_transferValueByString(v)
							--物品基础数据
							local key = "id_"..v
							self.m_tPlayerItemList[i].basicInfo = GDatatab_item[key]

							if WndAscending.m_root ~= nil and WndAscending.m_nCurTab ~= 2 then
								WndRewardShow:showById({v},{1})
							end
						else
							self.m_tPlayerItemList[i].extraInfo[key] = self:_transferValueByString(v)
						end
					end
				end

				if mainType == 5 then
					self:_updateDecorationData()
				end
				break 
			end
		end
	end
	

	--货币类型不更新物品
	if self.m_nUpdatePlayerItem == nil then self.m_nUpdatePlayerItem = 0 end
	self.m_nUpdatePlayerItem = self.m_nUpdatePlayerItem + 1
	self:_updatePlayerItemData()
end

--@brief 	获取黑名单列表
function CacheCenter:getFriendBlacklist()
	-- body
	return self.m_tFriendBlacklist
end

--@brief	添加小家物品列表缓存信息
function CacheCenter:addPlayerHomeItem(itemId, lastNum, lastTime, isUse, playerItemId, ownerId, childId)
	WZLog ("*********** CacheCenter:addPlayerHomeItem ***************", itemId:size())
	if self.m_tPlayerHomeItemList == nil then
		self.m_tPlayerHomeItemList = {}
	end
	
	local receiveTime = SystemTime:getServerTime()

	--NOTRECYCLEIDS = {}
	for i=0,itemId:size() - 1 do
		WZLog ("CacheCenter:addPlayerHomeItem",itemId:get(i),isUse:get(i),lastTime:get(i),lastNum:get(i))
		local tTempItem = {}
		tTempItem.id = itemId:get(i)
		tTempItem.lastTime = lastTime:get(i)
		tTempItem.lastNum = lastNum:get(i)
		tTempItem.isUse = isUse:get(i)
		tTempItem.playerItemId = playerItemId:get(i)
		tTempItem.ownerId = ownerId:get(i)
		tTempItem.receiveTime = receiveTime
		tTempItem.childId = childId:get(i)

		--物品基础数据
		local key = "id_"..itemId:get(i)
		tTempItem.basicInfo = GDatatab_item[key]
		tTempItem.maintype = tTempItem.basicInfo.main_type
		tTempItem.subtype = tTempItem.basicInfo.sub_type
		--WZLog("CacheCenter:setPlayerItems",Serialize(tTempItem.basicInfo))
		if tTempItem.basicInfo.use_type == 0 then--num 
			if tTempItem.maintype ~= 4 then
				tTempItem.lastTime = tTempItem.lastNum
			else
				tTempItem.lastNum = 1
			end
		else
			tTempItem.lastNum = tTempItem.lastTime
		end

		--物品附加数据
		-- tTempItem.extraInfo = json.decode(data:get(i)) 
		-- if tTempItem.maintype == 5 then
		-- 	local nFighting = caculateClothesFighting(tTempItem.extraInfo)
		-- 	tTempItem.extraInfo.fighting = nFighting
		-- end
		if tTempItem.maintype == 31 then
			WZLog("检查1", type(tTempItem.lastTime), tTempItem.lastTime)
			if tonumber(tTempItem.lastTime) == -1 then
				table.insert(NOTRECYCLEIDS, tTempItem.basicInfo.id)
			end
		end
		table.insert(self.m_tPlayerHomeItemList, tTempItem)

		--装备物品窗
		WZLog("显示装备物品窗口",tTempItem.maintype, tTempItem.subtype, tTempItem.id, #self.m_tPlayerHomeItemList)

		-- if tTempItem.maintype == 31 and CacheCenter:isEquipedDecorationRedPoint() then
		-- 	CacheCenter:setRedState("btnBag",true)
		-- 	GlobalGame:getBtnRedPointEvent():dispatcher()
		-- end

		
		--时装的弹快捷装备窗口
	-- 	local bHavedEquipSameSubtype = false
	-- 	if tTempItem.maintype == 31 then
	-- 		for j = 1, #self.m_tPlayerHomeItemList do 
 --            	if self.m_tPlayerHomeItemList[j].maintype == tTempItem.maintype and tTempItem.subtype == self.m_tPlayerHomeItemList[j].subtype then
 --            		if self.m_tPlayerHomeItemList[j].isUse == true then
 --            			bHavedEquipSameSubtype = true 	--表示角色已经穿上该时装了，进行替换
 --                        local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
 --            			if tTempItem.extraInfo.fighting > self.m_tPlayerHomeItemList[j].extraInfo.fighting or (isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level <= 10) then
 --            				local nTempFighting = tTempItem.extraInfo.fighting - self.m_tPlayerHomeItemList[j].extraInfo.fighting

 --            				tTempItem.nRiseFighting = nTempFighting
 --            				if g_bIsShowWndDressUp == true then
	--             				MsgBoxManager:showEquipDressUp(tTempItem)
	--             			else
	--             				table.insert(g_tTempItemForLaterShow, tTempItem)
	--             			end
 --            				break	
 --            			end
 --            		end
 --           		end
 --            end
 --            if bHavedEquipSameSubtype == false then 	--表示角色该时装栏是空的，可以显示快捷装备窗口
	-- 			tTempItem.nRiseFighting = tTempItem.extraInfo.fighting
	-- 			if g_bIsShowWndDressUp == true then
 --    				MsgBoxManager:showEquipDressUp(tTempItem)
 --    			else
 --    				table.insert(g_tTempItemForLaterShow, tTempItem)
 --    			end
	-- 		end
	-- 	end
	end
	
	--保存系统时间
	SETITEMSTIME = os.time()

	--更新物品列表数据
	if self.m_nUpdatePlayerHomeItem == nil then self.m_nUpdatePlayerHomeItem = 0 end
	self.m_nUpdatePlayerHomeItem = self.m_nUpdatePlayerHomeItem + 1
	self:_updatePlayerHomeItemData()
end

--@brief	更新小家物品列表缓存信息
--@param    playerItemId:玩家物品ID,除了时装其它为0，tKey:属性列表，tValue：属性值列表
function CacheCenter:updatePlayerHomeItems(playerItemId, itemId, tKey, tValue)
	if playerItemId == nil or tKey == nil or tValue == nil then
		return
	end
	if self.m_tPlayerHomeItemList == nil then return end 

	local mainType
	local tTempItem = nil 
	local bIsIncrease = false --道具数量是增加的还是减少的

	WZLog("CacheCenter:updatePlayerHomeItems zero",playerItemId)
	--NOTRECYCLEIDS = {}
	for i=1,#self.m_tPlayerHomeItemList do
		if self.m_tPlayerHomeItemList[i].maintype == 31 then
			if self.m_tPlayerHomeItemList[i].playerItemId == playerItemId then
				tTempItem = self.m_tPlayerHomeItemList[i]
				mainType = self.m_tPlayerHomeItemList[i].maintype
				WZLog("CacheCenter:updatePlayerHomeItems one", self.m_tPlayerHomeItemList[i].id, self.m_tPlayerHomeItemList[i].lastTime)

				for j = 1, #tKey do
					WZLog("CacheCenter:updatePlayerHomeItems", playerItemId, tKey[j], tValue[j], self.m_tPlayerHomeItemList[i][tKey[j]], self.m_tPlayerHomeItemList[i].basicInfo.name)
					if self.m_tPlayerHomeItemList[i].basicInfo.main_type == 31 then
						if tonumber(self.m_tPlayerHomeItemList[i][tKey[j]]) ~= -1 and tonumber(tValue[j]) == -1 then
							WZLog("增加NOTRECYCLEIDS",self.m_tPlayerHomeItemList[i].basicInfo.id)
							table.insert(NOTRECYCLEIDS, self.m_tPlayerHomeItemList[i].basicInfo.id)
						end
					end
					--更新字段列表
					if self.m_tPlayerHomeItemList[i][tKey[j]] ~= nil then
						if tKey[j] == "lastNum" and self:_transferValueByString(tValue[j]) > self.m_tPlayerHomeItemList[i][tKey[j]] then
							bIsIncrease = true
						end
						if tKey[j] == "lastTime" then
							self.m_tPlayerHomeItemList[i].receiveTime = SystemTime:getServerTime()
						end
						self.m_tPlayerHomeItemList[i][tKey[j]] = self:_transferValueByString(tValue[j])
					else
						--如果在升阶界面，获得升阶物品
						if tKey[j] == "itemId" then
							self.m_tPlayerHomeItemList[i]["id"] = self:_transferValueByString(tValue[j])
							--物品基础数据
							local key = "id_"..tValue[j]
							self.m_tPlayerHomeItemList[i].basicInfo = GDatatab_item[key]
						else
							self.m_tPlayerHomeItemList[i].extraInfo[tKey[j]] = self:_transferValueByString(tValue[j])
						end
					end
				end
				
				if mainType == 31 then
					self:_updateKidDecorationData()
				end
			end
		else
			if self.m_tPlayerHomeItemList[i].id == itemId then
				tTempItem = self.m_tPlayerHomeItemList[i]
				mainType = self.m_tPlayerHomeItemList[i].maintype
				WZLog("CacheCenter:updatePlayerHomeItems one", self.m_tPlayerHomeItemList[i].id, self.m_tPlayerHomeItemList[i].lastTime)

				for j = 1, #tKey do
					WZLog("CacheCenter:updatePlayerHomeItems", itemId, tKey[j], tValue[j], self.m_tPlayerHomeItemList[i][tKey[j]], self.m_tPlayerHomeItemList[i].basicInfo.name)
					--更新字段列表
					if self.m_tPlayerHomeItemList[i][tKey[j]] ~= nil then
						if tKey[j] == "lastNum" and self:_transferValueByString(tValue[j]) > self.m_tPlayerHomeItemList[i][tKey[j]] then
							bIsIncrease = true
						end
						if tKey[j] == "lastTime" then
							self.m_tPlayerHomeItemList[i].receiveTime = SystemTime:getServerTime()
						end
						self.m_tPlayerHomeItemList[i][tKey[j]] = self:_transferValueByString(tValue[j])
					else
						--如果在升阶界面，获得升阶物品
						if tKey[j] == "itemId" then
							self.m_tPlayerHomeItemList[i]["id"] = self:_transferValueByString(tValue[j])
							--物品基础数据
							local key = "id_"..tValue[j]
							self.m_tPlayerHomeItemList[i].basicInfo = GDatatab_item[key]
						else
							self.m_tPlayerHomeItemList[i].extraInfo[tKey[j]] = self:_transferValueByString(tValue[j])
						end
					end
				end
			end
		end
	end
	WZLog("CacheCenter:updatePlayerHomeItems 999", Serialize(NOTRECYCLEIDS))

    
	--货币类型不更新物品
	if self.m_nUpdatePlayerHomeItem == nil then self.m_nUpdatePlayerHomeItem = 0 end
	self.m_nUpdatePlayerHomeItem = self.m_nUpdatePlayerHomeItem + 1

	self:_updatePlayerHomeItemData()
end

--@brief	删除小家物品列表缓存信息
--@param    tPlayerItemId:被删除玩家物品id列表, tId: 物品id列表
function CacheCenter:removePlayerHomeItems(tPlayerItemId, tId)
	if tPlayerItemId == nil or tId == nil then
		return
	end

	for i = 1, #tPlayerItemId do
		self:_removePlayerHomeItem(tPlayerItemId[i], tId[i])
	end
	
	--保存系统时间
	SETITEMSTIME = os.time()

	--删除物品列表数据
	if self.m_nUpdatePlayerHomeItem == nil then self.m_nUpdatePlayerHomeItem = 0 end
	self.m_nUpdatePlayerHomeItem = self.m_nUpdatePlayerHomeItem + 1
	self:_updatePlayerHomeItemData()
end

--@brief	删除小家物品列表缓存信息
function CacheCenter:_removePlayerHomeItem(playerItemId, itemId)
	if self.m_tPlayerHomeItemList ~= nil then
		for i=1,#self.m_tPlayerHomeItemList do
			if self.m_tPlayerHomeItemList[i].maintype == 31 then
				if self.m_tPlayerHomeItemList[i].playerItemId == playerItemId then
					table.remove(self.m_tPlayerHomeItemList, i)
					do return end
				end
			else
				if self.m_tPlayerHomeItemList[i].id == itemId then
					table.remove(self.m_tPlayerHomeItemList, i)
					do return end
				end
			end
		end
	end
end

--@brief	更新小家物品变化数据
function CacheCenter:_updatePlayerHomeItemData()
	WZLog("CacheCenter:_updatePlayerHomeItemData")
	self.m_nUpdatePlayerHomeItem = self.m_nUpdatePlayerHomeItem - 1
	if self.m_nUpdatePlayerHomeItem < 0 then self.m_nUpdatePlayerHomeItem = 0 end

	if self.m_tPlayerHomeItemObservers ~= nil then
		for i=1,#self.m_tPlayerHomeItemObservers do
			WZLog("CacheCenter:_updatePlayerHomeItemData1",#self.m_tPlayerHomeItemObservers,i)

			if self.m_tPlayerHomeItemObservers[i].updatePlayerHomeItemData ~= nil then
				self.m_tPlayerHomeItemObservers[i]:updatePlayerHomeItemData()
			end
		end
	end
end

--@brief	注册小家物品列表更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpatePlayerHomeItemObserver(tObserver)
	if self.m_tPlayerHomeItemObservers == nil then
		self.m_tPlayerHomeItemObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tPlayerHomeItemObservers do
		if self.m_tPlayerHomeItemObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tPlayerHomeItemObservers, tObserver)
end

--@brief	取消注册小家物品列表更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpatePlayerHomeItemObserver(tObserver)
	if self.m_tPlayerHomeItemObservers ~= nil then
		for i=1,#self.m_tPlayerHomeItemObservers do
			if self.m_tPlayerHomeItemObservers[i] == tObserver then
				table.remove(self.m_tPlayerHomeItemObservers, i)
				do return end
			end
		end
	end
end

--@brief	注册小孩装扮更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:registerUpdateKidDecorationObserver(tObserver)
	if self.m_tKidDecorationObservers == nil then
		self.m_tKidDecorationObservers = {}
	end
	--已经注册,直接返回
	for i=1,#self.m_tKidDecorationObservers do
		if self.m_tKidDecorationObservers[i] == tObserver then
			do return end
		end
	end
	table.insert(self.m_tKidDecorationObservers, tObserver)
end

--@brief	取消注册小孩装扮更新回调函数
--@param  tObserver：被注册观察者表对象
function CacheCenter:unregisterUpateKidDecorationObserver(tObserver)
	if self.m_tKidDecorationObservers ~= nil then
		for i=1,#self.m_tKidDecorationObservers do
			if self.m_tKidDecorationObservers[i] == tObserver then
				table.remove(self.m_tKidDecorationObservers, i)
				do return end
			end
		end
	end
end

--@brief	更新小孩装扮列表缓存数据变化
function CacheCenter:_updateKidDecorationData()
	WZLog("CacheCenter:_updateKidDecorationData")
	if self.m_tKidDecorationObservers ~= nil then
		for i=1,#self.m_tKidDecorationObservers do
			if self.m_tKidDecorationObservers[i].updateDecorationData ~= nil then
				self.m_tKidDecorationObservers[i]:updateDecorationData()
			end
		end
	end
end

--@brief	通过物品Id获取玩家小家物品个数
--@return   玩家物品个数
function CacheCenter:getPlayerHomeItemCountById(itemId)
	WZLog("CacheCenter:getPlayerHomeItemCountById =",itemId)
	if self.m_tPlayerHomeItemList == nil or itemId == nil then
		return 0
	end
	for i, data in pairs(self.m_tPlayerHomeItemList) do
		local key = "id_" .. itemId 
		if GDatatab_item[key] ~= nil and GDatatab_item[key].main_type == 31 then
			if data.basicInfo ~= nil and tonumber(data.basicInfo.id) == tonumber(itemId) then
				return data.lastTime
			end
		end
		if data.basicInfo ~= nil and tonumber(data.basicInfo.id) == tonumber(itemId) then
			WZLog("--CacheCenter:getPlayerHomeItemCountById--",itemId,data.lastNum)
			return data.lastNum
		end
	end
	return 0 
end

--@brief 	获取小家背包中的物品（非时装）
function CacheCenter:getHomeBagData()
	-- body
	if self.m_tPlayerHomeItemList == nil then return {} end

	local tTempList = {}
	for i = 1, #self.m_tPlayerHomeItemList do
		if self.m_tPlayerHomeItemList[i].maintype ~= 31 then
			table.insert(tTempList, self.m_tPlayerHomeItemList[i])
		end
	end

	return tTempList
end

--@brief	获取某个特定的孩子已装备的时装物品列表
function CacheCenter:getKidEquipmentDressList(nKidSex, kidId)
	if self.m_tPlayerHomeItemList == nil then return {} end
	local tEquipmentList = {}
	for i=1,#self.m_tPlayerHomeItemList do
		if self.m_tPlayerHomeItemList[i].maintype == 31 and self.m_tPlayerHomeItemList[i].isUse and self.m_tPlayerHomeItemList[i].basicInfo.sex == nKidSex and self.m_tPlayerHomeItemList[i].childId == kidId then
			table.insert(tEquipmentList, self.m_tPlayerHomeItemList[i])
		end
	end

	return tEquipmentList
end

--@brief	获取当前小孩已经拥有(时装)列表
function CacheCenter:getKidDecorationList(nKidSex, kidId)
	local tDecorationList = {}
	if self.m_tPlayerHomeItemList == nil then return tDecorationList end
	for i = 1, #self.m_tPlayerHomeItemList do
		local maintype = self.m_tPlayerHomeItemList[i].maintype
		if maintype == 31 and self.m_tPlayerHomeItemList[i].basicInfo.sex == nKidSex and (self.m_tPlayerHomeItemList[i].childId == 0 or (self.m_tPlayerHomeItemList[i].isUse and self.m_tPlayerHomeItemList[i].childId == kidId)) then
			table.insert(tDecorationList, self.m_tPlayerHomeItemList[i])
		end
	end

	return tDecorationList
end

--@brief	获取当前性别小孩已经拥有(时装)列表
function CacheCenter:getKidDecorationListBySex(nKidSex)
	local tDecorationList = {}
	if self.m_tPlayerHomeItemList == nil then return tDecorationList end
	for i = 1, #self.m_tPlayerHomeItemList do
		local maintype = self.m_tPlayerHomeItemList[i].maintype
		if maintype == 31 and self.m_tPlayerHomeItemList[i].basicInfo.sex == nKidSex then
			table.insert(tDecorationList, self.m_tPlayerHomeItemList[i])
		end
	end

	return tDecorationList
end

function CacheCenter:_NumberToBits(n, nCount)
    local tBits = {}

    while n >= 0 and #tBits < nCount do
        table.insert(tBits, math.mod(n, 2))
        n = math.floor(n/2)
    end

    return tBits
end

--@brief 	获取纪念币的充值数据
function CacheCenter:getMarkCoinRechargeData()
	-- body
	return self.m_tMarkCoinData
end

--@brief 	获取同物品Id的宠物
function CacheCenter:getPlayerPetByItemId(petItemId)
	-- body
	local tPetList = {}
	if self.m_tPlayerPetInfo == nil then return tPetList end 

	for i=1,#(self.m_tPlayerPetInfo) do
		if self.m_tPlayerPetInfo[i].itemId == petItemId then 
			table.insert(tPetList, self.m_tPlayerPetInfo[i])
		end
	end

	table.sort(tPetList, function (a,b)
		-- body
		if a.upgradeLevel ~= b.upgradeLevel then 
			return a.upgradeLevel > b.upgradeLevel
		else
			if a.upgradeLevel ~= b.upgradeLevel then 
				return a.upgradeLevel > b.upgradeLevel
			else
				return a.playerPetId < b.playerPetId
			end
		end
	end)

	return tPetList
end