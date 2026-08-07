--WndSellData.lua
--@brief	WndSell的数据模块
--@date		2015/07/03
--@author	zsq
--@note		出售背包

WndSell = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSell:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nIndex = nil
	self.m_tData = nil
	self.m_tSellList = {}		--出售物品列表
	self.m_tSellList_Huanhua = {}	--出售物品列表-幻化装备
	self.m_tGridList = nil
	self.m_nTag = nil
	self.m_sConGoods_WndEquip = nil
	self.m_sNodeContainer = nil
	self.m_nMaxCount = 100 --回收的个数

	--皮肤装备
	self.m_nShapeId = nil 				--使用中的皮肤id
	self.m_nQuality = nil 				--品质开放限制
	self.m_nUIType = 1					--界面类型 1主界面 2合成 3重铸
	self.m_nMaxGridsNum = nil 			--格子最大格子数

	self.m_tEquipmentList = {}			--装备中的装备
	self.m_tBagList = {}				--背包中的装备
	self.m_tAlbumList = {}				--图鉴列表

	self.m_tEquipmentDataList = {} 		--装备界面背包数据列表
	self.m_tEquipmentCellList = {}		--装备界面背包对象列表
	self.m_tEquipGridList = nil 		--装备界面6个格子对象列表
	self.m_nShowSubType = -1 			--装备界面背包显示类型 -1:全部显示
	self.m_tEquipmentShowList = {} 		--装备界面背包显示列表

	self.m_tSynthesisDataList = {} 		--合成界面背包数据列表
	self.m_tSynthesisCellList = {}		--合成界面背包对象列表
	self.m_tSynthesisSelectList = {}	--合成界面勾选的装备列表
	self.m_tRSynthesisCost = nil 		--合成消耗

	self.m_tRecastDataList = {} 		--重铸界面背包数据列表
	self.m_tRecastCellList = {}			--重铸界面背包对象列表
	self.m_tRecastSelectList = {}		--重铸界面勾选的装备列表
	self.m_tRecastCost = nil 			--重铸消耗
	self.m_nRecastMaxCount = 3 			--重铸最多可放入数量

	self.m_tPastEquipList = {} 			--图鉴界面获得过的装备列表

	self.m_tMountStoneBaseData = nil     --基础数据
	self.m_tStoneBagData = nil           --灵石在背包的数据
	self.m_tStoneSourceBagData = nil     --灵石之源在背包的数据
	self.m_tUseAccStoneData = nil		--已经使用的副石

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSell:_unInit()
	self.m_root = nil
	self.m_nIndex = nil
	self.m_tData = nil
	self.m_tSellList = nil		--出售物品列表
	self.m_tSellList_Huanhua = nil	--出售物品列表-幻化装备
	self.m_tGridList = nil
	self.m_nTag = nil
	self.m_sConGoods_WndEquip = nil
	self.m_sNodeContainer = nil
	self.m_nMaxCount = 100

	--皮肤装备
	self.m_nShapeId = nil 				--使用中的皮肤id
	self.m_nQuality = nil 				--品质开放限制
	self.m_nUIType = nil				--界面类型 1主界面 2合成 3重铸
	self.m_nMaxGridsNum = nil 			--格子最大格子数

	self.m_tEquipmentList = nil			--装备中的装备
	self.m_tBagList = nil				--背包中的装备
	self.m_tAlbumList = nil				--图鉴列表

	self.m_tEquipmentDataList = nil 	--装备界面背包数据列表
	self.m_tEquipmentCellList = nil		--装备界面背包对象列表
	self.m_tEquipGridList = nil 		--装备界面6个格子对象列表
	self.m_nShowSubType = nil 			--装备界面背包显示类型 -1:全部显示
	self.m_tEquipmentShowList = nil		--装备界面背包显示列表

	self.m_tSynthesisDataList = nil 	--合成界面背包数据列表
	self.m_tSynthesisCellList = nil		--合成界面背包对象列表
	self.m_tSynthesisSelectList = nil	--合成界面勾选的装备列表
	self.m_tRSynthesisCost = nil 		--合成消耗

	self.m_tRecastDataList = nil 		--重铸界面背包数据列表
	self.m_tRecastCellList = nil		--重铸界面背包对象列表
	self.m_tRecastSelectList = nil		--重铸界面勾选的装备列表
	self.m_tRecastCost = nil 			--重铸消耗
	self.m_nRecastMaxCount = nil 		--重铸最多可放入数量

	self.m_tPastEquipList = nil 		--图鉴界面获得过的装备列表

	self.m_tMountStoneBaseData = nil     --基础数据
	self.m_tStoneBagData = nil           --灵石在背包的数据
	self.m_tStoneSourceBagData = nil     --灵石之源在背包的数据
	self.m_tUseAccStoneData = nil		--已经使用的副石
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSell:createElement()
	local element = WZUISystem:getInstance():createElement("WndSell")
	assert(element, "WndSell create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获取当前数据列表
function WndSell:getCurData()
	local tempList
	if self.m_nIndex == 1 then
		tempList = CacheCenter:getAllList()
	elseif self.m_nIndex == 2 then
		tempList = CacheCenter:getEquipList()
	elseif self.m_nIndex == 3 then
		tempList = CacheCenter:getPropList()
	elseif self.m_nIndex == 4 then
		tempList = CacheCenter:getBagMaterialList()
	elseif self.m_nIndex == 5 then
		tempList = CacheCenter:getPlayerAndPetGemList()
	elseif self.m_nIndex == 6 then
		tempList = {}
		--tempList = CacheCenter:getBagOthersListOfSale()
		--WZLog("WndSell:getCurData #tempList 0", Serialize(tempList))
	end

	--WZLog("WndSell:getCurData #tempList 1", #tempList)
	local tDataList = {}
	for k,v in pairs(tempList) do
		if self:_checkSellData(v) then
			table.insert(tDataList,CopyTable(v))
		end
	end
	table.sort(tDataList , _sortItem)
	--WZLog("WndSell:getCurData #tDataList 1", #tDataList)
	if self.m_nIndex == 5 then
		table.sort(tDataList , sortGem1)
	elseif self.m_nIndex == 6 then
		local temp_bagList = self:getBagOthersListOfSale()
		for k,v in pairs(temp_bagList) do
			if self:_checkSellData(v) then
				table.insert(tDataList,CopyTable(v))
			end
		end
		table.sort(tDataList , _sortTab6)
	end
	--WZLog("WndSell:getCurData #tDataList 2", #tDataList)
	return tDataList
end


--@brief    发送17-19协议 刷新数据
function WndSell:sendEquipInfoProtocol()
	ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo()
end

--@brief    发送17-19协议 刷新数据
function WndSell:sendMountStoneInfoProtocol()
	ProtocolProcessorScenePets:send_MOUNTS_GetSpriteStoneData()
end

--@brief	获取当前数据列表
function WndSell:getBagOthersListOfSale()
	WZLog("WndSell:getBagOthersListOfSale")
	local tDataList = {}
	local tTempList = {}--CacheCenter:getBagOthersListOfSale()
	--local tTempList_37 = CacheCenter:getBagListWithType(37)
	--local tTempList_38 = CacheCenter:getBagListWithType(38)
	--local tTempList_47 = CacheCenter:getBagListWithType(47)

	if self.m_tEquipmentDataList then
		for k,v in pairs(self.m_tEquipmentDataList) do
			if v and v.basicInfo then
				table.insert(tTempList,CopyTable(v))
			end
		end
	else
		--发送协议获取幻化装备列表信息
		self:sendEquipInfoProtocol()
	end

	tDataList = CopyTable(CacheCenter:getFootStarMapGemList())--足迹星辰
	for k,v in pairs(tDataList) do
		if v and v.basicInfo then
			table.insert(tTempList,CopyTable(v))
		end
	end

	--if self.m_tStoneBagData == nil then
		self.m_tStoneBagData = CacheCenter:getMountStoneList()
	--end
	for k,v in pairs(self.m_tStoneBagData) do
		if v and v.basicInfo then
			table.insert(tTempList,CopyTable(v))
		end
	end
	
	if self.m_tStoneSourceBagData then
		for k,v in pairs(self.m_tStoneSourceBagData) do
			if v and v.basicInfo then
				table.insert(tTempList,CopyTable(v))
			end
		end
	else
		self:sendMountStoneInfoProtocol()
	end

	return tTempList
end

function sortGem1(a,b)
	if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
		return a.basicInfo.sub_type < b.basicInfo.sub_type 
	else
		if a.basicInfo.quality ~= b.basicInfo.quality then
			return a.basicInfo.quality < b.basicInfo.quality
		else
			return a.id < b.id 
		end
	end
end

--@brief	检查物品是否可以出售
function WndSell:_checkSellData(data)
	WZLog("检查物品是否可以出售:",data.basicInfo.name,data.isUse,data.expired)
	--if data.basicInfo.can_recycle == 1 and data.recyclePrice ~= -1 and usdata ~= -1 and data.isUse == false and data.expired == false then
	local usdata = -1
	local notTimeLimit = (data.basicInfo.time_limit == -1)
	local bCanSell = self:whetherImproveOrIntensify(data)
	if data.basicInfo.use_type == 0 then
		usdata = data.lastNum
	else
		usdata = data.lastTime
	end
	--WZLog("检查物品是否可以出售:", usdata, notTimeLimit, bCanSell, data.basicInfo.recycle)
	if data.basicInfo.recycle > 0 and usdata ~= -1 and data.isUse == false and notTimeLimit and bCanSell then
		return true 
	end
	WZLog("检查物品不可以出售:", data.basicInfo.name)
	return false 
end

--@brief	把物品按品质排序
function _sortItem(a,b)
	if WndSell:getPriority(a) ~= WndSell:getPriority(b) then
		return WndSell:getPriority(a) > WndSell:getPriority(b)
	elseif a.extraInfo.strongLevel ~= nil and b.extraInfo.strongLevel ~= nil and a.extraInfo.strongLevel ~= b.extraInfo.strongLevel then
		return a.extraInfo.strongLevel <= b.extraInfo.strongLevel
	elseif a.extraInfo.starLevel ~= nil and b.extraInfo.starLevel ~= nil and a.extraInfo.starLevel ~= b.extraInfo.starLevel then
		return a.extraInfo.starLevel <= b.extraInfo.starLevel
	elseif a.basicInfo.quality ~= b.basicInfo.quality then
		return a.basicInfo.quality <= b.basicInfo.quality
	elseif WndSell:getPositionPriority(a) ~= WndSell:getPositionPriority(b) then
		return WndSell:getPositionPriority(a) > WndSell:getPositionPriority(b)
	end
end

function _sortTab6(a,b)
	if WndSell:getStoneQuality(a) ~= WndSell:getStoneQuality(b) then
		return WndSell:getStoneQuality(a) < WndSell:getStoneQuality(b)
	-- if a.basicInfo.quality ~= b.basicInfo.quality then
	-- 	return a.basicInfo.quality < b.basicInfo.quality
	else
		return _sortTab6_1(a,b)
	end
end 

function _sortTab6_1(a, b)
	if a.extraInfo and b.extraInfo and a.extraInfo.spriteStoneQuality and b.extraInfo.spriteStoneQuality then
		if a.id == b.id then
			return a.extraInfo.spriteStoneQuality < b.extraInfo.spriteStoneQuality
		else
			return a.id < b.id
		end
	else
		return a.id < b.id
	end
end

function WndSell:getSourceStoneData()
	local data = CacheCenter:getMountStoneSourceList()
	--筛选已经安装的
	local temp_data = {}
	for i, v in pairs(data) do
		if self.m_tUseAccStoneData[v.playerItemId] == nil then
			table.insert(temp_data, v)
		end
	end
	return temp_data
end

--@brief	获得部位优先级
function WndSell:getStoneQuality(tData)
	local main_type = tData.basicInfo.main_type
	local sub_type = tData.basicInfo.sub_type
	if main_type ~= 38 then
		return tData.basicInfo.quality
	end
	if sub_type < 9 or sub_type > 13 then
		return tData.basicInfo.quality
	end
	if not tData.extraInfo or not tData.extraInfo.spriteStoneQuality then
		return tData.basicInfo.quality
	end
	local index = 1
	local quality_score = tData.extraInfo.spriteStoneQuality
    if quality_score >= 1 and quality_score <= 49 then
        index = 1
    elseif quality_score >= 50 and quality_score <= 79 then
        index = 2
    elseif quality_score >= 80 and quality_score <= 94 then
        index = 3
    elseif quality_score >= 95 and quality_score <= 100 then
        index = 4
    end
	return index
end

--@brief	获得部位优先级
function WndSell:getPriority(tData)
	local main_type = tData.basicInfo.main_type
	local priority = 0
	if main_type == 4 or main_type == 5 then
		priority = 3
	end
	if main_type == 7 then
		priority = 2
	end
	if main_type == 6 then
		priority = 1
	end
	return priority
end

--@brief	获得部位优先级
function WndSell:getPositionPriority(tData)
		local subtype = tData.basicInfo.sub_type
		local priority = 0
		if subtype == 0 then
			priority = 10
		end
		if subtype == 1 then
			priority = 9
		end
		if subtype == 2 then
			priority = 5
		end
		if subtype == 3 then
			priority = 7
		end
		if subtype == 4 then
			priority = 8
		end
		if subtype == 5 then
			priority = 6
		end
		if subtype == 6 then
			priority = 4
		end
		if subtype == 7 then
			priority = 3
		end
		if subtype == 8 then
			priority = 2
		end
	return priority
end

--@brief 	检测如果是装备，是否升星或强化过
function WndSell:whetherImproveOrIntensify(tData)
	-- body
--	WZLog("检查物品是否装备，是否强化过或升星过:",tData.basicInfo.name,tData.isUse,tData.expired)
	if tData.basicInfo.main_type == 4 then 
		if tData.extraInfo and (tData.extraInfo.starLevel > 0 or tData.extraInfo.strongLevel > 0) then 
			return false
		end
	end

	return true 
end

--@brief	设置装备信息数据
function WndSell:setEquipInfoData(shapeId, eId, bId, bItemId, gId, status, quality, pastEquip)
	self.m_nShapeId = shapeId
	self.m_nQuality = quality
	self.m_tPastEquipList = pastEquip

	self.m_tEquipmentList = {}
	for i=1,#eId do
		self.m_tEquipmentList[i] = {}
		self.m_tEquipmentList[i].playerItemId = eId[i]
		self.m_tEquipmentList[i].id = 0
		self.m_tEquipmentList[i].basicInfo = nil
		for j=1,#bId do
			if eId[i] == bId[j] then
				self.m_tEquipmentList[i].id = bItemId[j]
				self.m_tEquipmentList[i].basicInfo = CopyTable(GDatatab_item["id_"..bItemId[j]])
			end
		end
		self.m_tEquipmentList[i].lastNum = 1
		self.m_tEquipmentList[i].type = 1
		self.m_tEquipmentList[i].isUse = true
		self.m_tEquipmentList[i].isHuanhua = true
	end
	
	self.m_tBagList = {}
	for i=1,#bId do
		self.m_tBagList[i] = {}
		self.m_tBagList[i].playerItemId = bId[i]
		self.m_tBagList[i].id = bItemId[i]
		self.m_tBagList[i].basicInfo = CopyTable(GDatatab_item["id_"..bItemId[i]])
		self.m_tBagList[i].lastNum = 1
		self.m_tBagList[i].type = 1
		self.m_tBagList[i].isHuanhua = true
	end

	self.m_tAlbumList = {}
	for i=1,#gId do
		self.m_tAlbumList[i] = {}
		self.m_tAlbumList[i].gId = gId[i]
		self.m_tAlbumList[i].status = status[i]
	end

	self:initEquipmentDataList()
	self:initSynthesisDataList()
	self:initRecastDataList()

	self:updateTempPlayerItemData()
	--合并背包
end

--@brief	获取已装备列表
function WndSell:getEquipmentList()
	return self.m_tEquipmentList
end

--@brief	获取图鉴奖励状态列表
function WndSell:getAlbumList()
	return self.m_tAlbumList
end

--@brief	获取图鉴拥有过的装备列表
function WndSell:getPastEquipList()
	return self.m_tPastEquipList
end

--@brief    初始化装备界面背包数据列表
function WndSell:initEquipmentDataList()
	WZLog("WndSell:initEquipmentDataList")
	self.m_tEquipmentDataList = {} 		--装备界面背包数据列表
	local tTempList = CacheCenter:getBagListWithType(37)
	WZLog("WndSell:initEquipmentDataList 1", #tTempList, #self.m_tBagList)
	--if not tTempList or not self.m_tBagList or #tTempList ~= #self.m_tBagList then return end
	--WZLog("WndSell:initEquipmentDataList 1", #tTempList)

	--WZLog("WndSell:initEquipmentDataList 1 tTempList", Serialize(tTempList))
	--WZLog("WndSell:initEquipmentDataList 1 self.m_tBagList", Serialize(self.m_tBagList))

	--装备界面背包数据列表
	self.m_tEquipmentDataList = CopyTable(self.m_tBagList)
	-- self.m_tEquipmentDataList = CopyTable(tTempList)
	for i=1,#self.m_tEquipmentDataList do
		self.m_tEquipmentDataList[i].isUse = false
		--self.m_tEquipmentDataList[i].basicInfo.recycle = 1
		--self.m_tEquipmentDataList[i].basicInfo.recycleMess = {{2,10000}}--{{2,10000}}{[1]={[1]=2,[2]=10000,}}
		for j=1,#self.m_tEquipmentList do
			if self.m_tEquipmentDataList[i].playerItemId == self.m_tEquipmentList[j].playerItemId then
				self.m_tEquipmentDataList[i].isUse = true --正在使用装备标识
				--删除正在使用的装备
				--table.remove(self.m_tEquipmentDataList, self.m_tEquipmentDataList[i])
			end
		end
	end

	self.m_tEquipmentDataList = self:_checkRecommend(self.m_tEquipmentDataList) --加上推荐标识
	-- 装备中 > 推荐 > 不是晶石 > 品质高 > 部位小 > 类型小 > 玩家物品id小
	table.sort( self.m_tEquipmentDataList, function(a,b)
		if a.isUse ~= b.isUse then
			if a.isUse == true then
				return true
			elseif b.isUse == true then
				return false
			end
		else
			if a.recommended ~= b.recommended then
				if a.recommended == true then
					return true
				elseif b.recommended == true then
					return false
				end
			else
				if a.basicInfo.sub_type ~= b.basicInfo.sub_type and (a.basicInfo.sub_type == 6 or b.basicInfo.sub_type == 6) then
					if a.basicInfo.sub_type == 6 then
						return false
					elseif b.basicInfo.sub_type == 6 then
						return true
					end
				else
					if a.basicInfo.quality ~= b.basicInfo.quality then
						return a.basicInfo.quality > b.basicInfo.quality
					else
						if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
							return a.basicInfo.sub_type < b.basicInfo.sub_type
						else
							if a.basicInfo.value ~= b.basicInfo.value then
								return a.basicInfo.value < b.basicInfo.value
							else
								if a.playerItemId ~= b.playerItemId then
									return a.playerItemId < b.playerItemId
								else
								end
							end
						end
					end
				end
			end
		end
	end )
end

--@brief    初始化合成界面背包数据列表
function WndSell:initSynthesisDataList()

	self.m_tSynthesisCost = nil --合成消耗
	
	self.m_tSynthesisDataList = {} 		--合成界面背包数据列表
	self.m_tSynthesisSelectList = {}	--合成界面勾选的装备列表

	--合成界面背包数据列表
	self.m_tSynthesisDataList = CopyTable(self.m_tBagList)
	for i=1,#self.m_tSynthesisDataList do
		self.m_tSynthesisDataList[i].isUse = false
		for j=1,#self.m_tEquipmentList do
			if self.m_tSynthesisDataList[i].playerItemId == self.m_tEquipmentList[j].playerItemId then
				self.m_tSynthesisDataList[i].isUse = true --正在使用装备标识
			end
		end
		self.m_tSynthesisDataList[i].sellHook = false
		self.m_tSynthesisDataList[i].lock = false
	end
	self.m_tSynthesisDataList = self:getSynthesisLockList(self.m_tSynthesisDataList,{})
	-- 不是晶石 > 品质高 > 部位小 > 类型小 > 玩家物品id小
	table.sort( self.m_tSynthesisDataList, function(a,b)
		if a.basicInfo.sub_type ~= b.basicInfo.sub_type and (a.basicInfo.sub_type == 6 or b.basicInfo.sub_type == 6) then
			if a.basicInfo.sub_type == 6 then
				return false
			elseif b.basicInfo.sub_type == 6 then
				return true
			end
		else
			if a.basicInfo.quality ~= b.basicInfo.quality then
				return a.basicInfo.quality > b.basicInfo.quality
			else
				if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
					return a.basicInfo.sub_type < b.basicInfo.sub_type
				else
					if a.basicInfo.value ~= b.basicInfo.value then
						return a.basicInfo.value < b.basicInfo.value
					else
						if a.playerItemId ~= b.playerItemId then
							return a.playerItemId < b.playerItemId
						else
						end
					end
				end
			end
		end
	end )
end

--@brief    初始化重铸界面背包数据列表
function WndSell:initRecastDataList()

	self.m_tRecastCost = nil --重铸消耗

	self.m_tRecastDataList = {} 		--重铸界面背包数据列表
	self.m_tRecastSelectList = {}		--重铸界面勾选的装备列表

	--重铸界面背包数据列表
	self.m_tRecastDataList = CopyTable(self.m_tBagList)
	for i=1,#self.m_tRecastDataList do
		self.m_tRecastDataList[i].isUse = false
		for j=1,#self.m_tEquipmentList do
			if self.m_tRecastDataList[i].playerItemId == self.m_tEquipmentList[j].playerItemId then
				self.m_tRecastDataList[i].isUse = true --正在使用装备标识
			end
		end
		self.m_tRecastDataList[i].sellHook = false
		self.m_tRecastDataList[i].lock = false
	end
	self.m_tRecastDataList = self:getRecastLockList(self.m_tRecastDataList,{})
	-- 不是晶石 > 品质高 > 部位小 > 类型小 > 玩家物品id小
	table.sort( self.m_tRecastDataList, function(a,b)
		if a.basicInfo.sub_type ~= b.basicInfo.sub_type and (a.basicInfo.sub_type == 6 or b.basicInfo.sub_type == 6) then
			if a.basicInfo.sub_type == 6 then
				return false
			elseif b.basicInfo.sub_type == 6 then
				return true
			end
		else
			if a.basicInfo.quality ~= b.basicInfo.quality then
				return a.basicInfo.quality > b.basicInfo.quality
			else
				if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
					return a.basicInfo.sub_type < b.basicInfo.sub_type
				else
					if a.basicInfo.value ~= b.basicInfo.value then
						return a.basicInfo.value < b.basicInfo.value
					else
						if a.playerItemId ~= b.playerItemId then
							return a.playerItemId < b.playerItemId
						else
						end
					end
				end
			end
		end
	end )
end

--@brief    检查物品的推荐，如果存在同类型高品质，就换成新的推荐
function WndSell:_checkRecommend(tData)
	WZLog("WndSell:_checkRecommend")
	if tData == nil or #tData == 0 then
		return {}
	end

	local maxQuality = {-1,-1,-1,-1,-1,-1} 
	local maxTag = {-1,-1,-1,-1,-1,-1} --未穿上的装备品质最高的index
	local equipedQuality = {-1,-1,-1,-1,-1,-1} --已穿上装备的品质
	for i,data in pairs(tData) do
		data.recommended = false
		local subtype = data.basicInfo.sub_type
		if subtype ~= 6 then
			if data.isUse == false and data.basicInfo.quality > maxQuality[subtype+1] and data.basicInfo.quality <= self.m_nQuality then
				maxQuality[subtype+1] = data.basicInfo.quality
				maxTag[subtype+1] = i
			end
			--记录已装备物品的品质
			if data.isUse == true then
				equipedQuality[subtype+1] = data.basicInfo.quality
			end
		end
	end
	for i=1,6 do
		if maxTag[i] ~= -1 then 
			local subtype = tData[maxTag[i]].basicInfo.sub_type
			if tData[maxTag[i]].isUse == false and tData[maxTag[i]].basicInfo.quality > equipedQuality[subtype+1] then
				tData[maxTag[i]].recommended = true
			end
		end
	end

	return tData
end

--@brief    发送17-19协议 刷新数据
function WndSell:sendEquipInfoProtocol()
	ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo()
end

--@brief    检测皮肤装备合成表是否有这个物品
function WndSell:checkCanSynthetic(itemId)
	local bCanSynthetic = false
	for key,value in pairs(GDatatab_skinequip_mix) do
		if value.scrap == itemId then
			bCanSynthetic = true
			break
		end
	end
	return bCanSynthetic
end

--@brief    获取合成界面选中列表中一个不是晶石的装备子类型 -1表示选中列表没有装备,可能有晶石
--@note		列表为空也返回-1,需要提前判断是否为空列表
function WndSell:getSynthesisSelectSubtype()
	local subtype = -1
	for i=1,#self.m_tSynthesisSelectList do
		if self.m_tSynthesisSelectList[i].basicInfo.sub_type ~= 6 then
			subtype = self.m_tSynthesisSelectList[i].basicInfo.sub_type
			break
		end
	end
	return subtype
end

--@brief    合成界面 根据子类型设置锁定标识 晶石默认不锁
--@prama    tData:合成界面背包列表,与选中列表不同类型品质的装备需要加上锁
--@prama    tSelectList:选中的列表
function WndSell:getSynthesisLockList(tData,tSelectList)
	--获取选中列表中一个不是晶石的装备子类型 -1表示选中列表为空或没有装备只有晶石
	local subtype = self:getSynthesisSelectSubtype()

	for i=1,#tData do
		tData[i].lock = false
		--合成表中没有的装备
		if self:checkCanSynthetic(tData[i].id) ~= true and tData[i].basicInfo.sub_type ~= 6 then
			tData[i].lock = true
		end
		--选中列表有装备
		if #tSelectList ~= 0 and subtype ~= -1 and (tData[i].basicInfo.quality ~= tSelectList[1].basicInfo.quality or ((tData[i].basicInfo.value ~= tSelectList[1].basicInfo.value or tData[i].basicInfo.sub_type ~= subtype) and tData[i].basicInfo.sub_type ~= 6)) then
			tData[i].lock = true
		end
		--选中列表只有晶石
		if #tSelectList ~= 0 and subtype == -1 and (tData[i].basicInfo.quality ~= tSelectList[1].basicInfo.quality) then
			tData[i].lock = true
		end
	end
	return tData
end

--@brief    重铸界面 根据子类型设置锁定标识 晶石默认加锁
--@prama    tData:合成界面背包列表,与选中列表不同类型品质的装备需要加上锁
--@prama    tSelectList:选中的列表
function WndSell:getRecastLockList(tData,tSelectList)
	for i=1,#tData do
		tData[i].lock = false
		--晶石加锁
		if tData[i].basicInfo.sub_type == 6 then
			tData[i].lock = true
		end
		if #tSelectList ~= 0 and (tData[i].basicInfo.quality ~= tSelectList[1].basicInfo.quality or tData[i].basicInfo.sub_type ~= tSelectList[1].basicInfo.sub_type) then
			tData[i].lock = true
		end
	end
	return tData
end
-------------------------------------私有方法模块End----------------------------------------
