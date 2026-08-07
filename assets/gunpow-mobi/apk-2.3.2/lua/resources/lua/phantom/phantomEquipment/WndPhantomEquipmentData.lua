--WndPhantomEquipmentData.lua
--@brief	WndPhantomEquipment的数据模块
--@date		2021/05/06
--@author	yrd
--@note		幻化装备

WndPhantomEquipment = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPhantomEquipment:_init()
	self.m_root = nil	 	  			--场景根节点
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

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPhantomEquipment:_unInit()
	self.m_root = nil	 	  			--场景根节点
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
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPhantomEquipment:createElement()
	if WndPhantomEquipment.m_root ~= nil then
		WindowManager:removeWindow(WndPhantomEquipment.m_root, WndPhantomEquipment, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPhantomEquipment")
	assert(element, "WndPhantomEquipment create element failed!")
	self:_init()
	return element
end

--@brief	设置装备信息数据
function WndPhantomEquipment:setEquipInfoData(shapeId, eId, bId, bItemId, gId, status, quality, pastEquip)
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
		self.m_tEquipmentList[i].lastNum = 0
		self.m_tEquipmentList[i].type = 1
		self.m_tEquipmentList[i].isUse = true
	end
	
	self.m_tBagList = {}
	for i=1,#bId do
		self.m_tBagList[i] = {}
		self.m_tBagList[i].playerItemId = bId[i]
		self.m_tBagList[i].id = bItemId[i]
		self.m_tBagList[i].basicInfo = CopyTable(GDatatab_item["id_"..bItemId[i]])
		self.m_tBagList[i].lastNum = 0
		self.m_tBagList[i].type = 1
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

	self:updateUI()
end

--@brief	获取已装备列表
function WndPhantomEquipment:getEquipmentList()
	return self.m_tEquipmentList
end

--@brief	获取图鉴奖励状态列表
function WndPhantomEquipment:getAlbumList()
	return self.m_tAlbumList
end

--@brief	获取图鉴拥有过的装备列表
function WndPhantomEquipment:getPastEquipList()
	return self.m_tPastEquipList
end

--@brief    检查物品的推荐，如果存在同类型高品质，就换成新的推荐
function WndPhantomEquipment:_checkRecommend(tData)
	WZLog("WndPhantomEquipment:_checkRecommend")
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
function WndPhantomEquipment:sendEquipInfoProtocol()
	ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo()
end

--@brief    检测皮肤装备合成表是否有这个物品
function WndPhantomEquipment:checkCanSynthetic(itemId)
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
function WndPhantomEquipment:getSynthesisSelectSubtype()
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
function WndPhantomEquipment:getSynthesisLockList(tData,tSelectList)
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
function WndPhantomEquipment:getRecastLockList(tData,tSelectList)
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

--@brief    初始化装备界面背包数据列表
function WndPhantomEquipment:initEquipmentDataList()

	self.m_tEquipmentDataList = {} 		--装备界面背包数据列表

	--装备界面背包数据列表
	self.m_tEquipmentDataList = CopyTable(self.m_tBagList)
	for i=1,#self.m_tEquipmentDataList do
		self.m_tEquipmentDataList[i].isUse = false
		for j=1,#self.m_tEquipmentList do
			if self.m_tEquipmentDataList[i].playerItemId == self.m_tEquipmentList[j].playerItemId then
				self.m_tEquipmentDataList[i].isUse = true --正在使用装备标识
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
function WndPhantomEquipment:initSynthesisDataList()

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
function WndPhantomEquipment:initRecastDataList()

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

--@brief    设置装备界面显示类型数据
function WndPhantomEquipment:setShowSubType(nSubType)
	self.m_nShowSubType = nSubType
end

--@brief	更新装备界面显示列表数据
function WndPhantomEquipment:updateBagShowData()
	if self.m_nShowSubType == nil or self.m_nShowSubType == -1 then
		self.m_tEquipmentShowList = self.m_tEquipmentDataList
	else
		self.m_tEquipmentShowList = self:getBagDataBySubType(self.m_nShowSubType)
	end
end

--@brief	根据子类型获取背包数据
function WndPhantomEquipment:getBagDataBySubType(nSubType)
	local tData = {}
	for i=1,#self.m_tEquipmentDataList do
		if self.m_tEquipmentDataList[i].basicInfo.sub_type == nSubType then
			table.insert(tData,self.m_tEquipmentDataList[i])
		end
	end
	return tData
end

--@brief	获取可以快速选择合成的皮肤装备数据列表
function WndPhantomEquipment:getCanSynthesisList()
	local tCanSynthesisList = {}
	local nNeedNum = 3 --合成需要装备件数
	for i=#self.m_tSynthesisDataList,nNeedNum,-1 do
		local qualityI = self.m_tSynthesisDataList[i].basicInfo.quality
		local sub_typeI = self.m_tSynthesisDataList[i].basicInfo.sub_type
		local valueI = self.m_tSynthesisDataList[i].basicInfo.value
		local itemId = self.m_tSynthesisDataList[i].basicInfo.id
		if sub_typeI ~= 6 and self:checkCanSynthetic(itemId) then
			for j=i-1,nNeedNum-1,-1 do
				local qualityJ = self.m_tSynthesisDataList[j].basicInfo.quality
				local sub_typeJ = self.m_tSynthesisDataList[j].basicInfo.sub_type
				local valueJ = self.m_tSynthesisDataList[j].basicInfo.value
				if sub_typeJ ~= 6 and sub_typeJ == sub_typeI and valueJ == valueI and qualityJ == qualityI then
					for k=j-1,nNeedNum-2,-1 do
						local qualityK = self.m_tSynthesisDataList[k].basicInfo.quality
						local sub_typeK = self.m_tSynthesisDataList[k].basicInfo.sub_type
						local valueK = self.m_tSynthesisDataList[k].basicInfo.value
						if sub_typeK ~= 6 and sub_typeK == sub_typeJ and valueK == valueJ and qualityK == qualityJ then
							table.insert(tCanSynthesisList,self.m_tSynthesisDataList[i])
							table.insert(tCanSynthesisList,self.m_tSynthesisDataList[j])
							table.insert(tCanSynthesisList,self.m_tSynthesisDataList[k])
							return tCanSynthesisList
						end
					end
				end
			end
		end
	end
	return tCanSynthesisList
end

--@brief	获取合成界面红点列表
function WndPhantomEquipment:getSynthesisRedDotList()
	local tabSynthesisList = {}
	for i=1,#self.m_tSynthesisDataList do
		local quality = self.m_tSynthesisDataList[i].basicInfo.quality
		local sub_type = self.m_tSynthesisDataList[i].basicInfo.sub_type
		local value = self.m_tSynthesisDataList[i].basicInfo.value
		local itemId = self.m_tSynthesisDataList[i].basicInfo.id
		if sub_type ~= 6 and self:checkCanSynthetic(itemId) then
			local key = quality.."_"..sub_type.."_"..value
			if tabSynthesisList[key] == nil then
				tabSynthesisList[key] = {}
			end
			table.insert(tabSynthesisList[key], self.m_tSynthesisDataList[i])
		end
	end

	local tSynthesisRedDotList = {}
	local nNeedNum = 3 --合成需要装备件数
	for k,v in pairs(tabSynthesisList) do
		if #v >= nNeedNum then
			for i=1,#v do
				table.insert(tSynthesisRedDotList,v[i])
			end
		end
	end

	return tSynthesisRedDotList
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
