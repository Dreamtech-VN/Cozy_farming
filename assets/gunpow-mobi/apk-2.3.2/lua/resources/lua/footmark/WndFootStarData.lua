--WndFootStarData.lua
--@brief	WndFootStar的数据模块
--@date		2022/08/18
--@author	yrd
--@note		足迹星辰

WndFootStar = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootStar:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStarMapNum = 12 			--星座数
	self.m_nCurStarMap = g_nFootStarMapIndex 				--当前星座
	self.m_nSelStarHoleIndex = 0 		--当前星座选中的孔位 0没有选中孔位

	self.m_nMaxGridsNum = 100 			--背包宝石数量上限 策划说写死

	self.m_tAllStarMapData = nil 		--全部星座孔位数据
	self.m_tAllStarUnlock = nil 		--全部星座解锁状态

	self.m_nWin2GemType = -1 			--窗口2背包宝石类型 -1表示全部 1~7对应物品表子类型
	self.m_tWin2GemShowList = nil 		--窗口2背包格子数据
	self.m_tWin2GemCellList = nil 		--窗口2背包格子对象

	self.m_nWin3GemType = -1 			--窗口3背包宝石类型 -1表示全部 1~7对应物品表子类型
	self.m_tWin3GemShowList = nil 		--窗口3背包格子数据
	self.m_tWin3GemCellList = nil 		--窗口3背包格子对象
	self.m_nWin3OpenHoldIndex = 0 		--窗口3 在主界面通过已镶嵌宝石的孔位点开合成界面时,记录这个孔位位置
	self.m_nWin3DepositedList = {0,0,0,0} 	--窗口3合成窗口放入宝石id列表 有4个合成格子
	self.m_tWin3SynthesisCost = nil 	--窗口3合成消耗 {id,num} 为nil不消耗

	self.m_tOperationParam = nil 			--用于镶嵌拆卸合成成功后,客户端手动更新数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootStar:_unInit()
	self.m_root = nil
	self.m_nStarMapNum = nil
	self.m_nCurStarMap = nil
	self.m_nSelStarHoleIndex = nil

	self.m_nMaxGridsNum = nil

	self.m_tAllStarMapData = nil
	self.m_tAllStarUnlock = nil

	self.m_nWin2GemType = nil
	self.m_tWin2GemShowList = nil
	self.m_tWin2GemCellList = nil

	self.m_nWin3GemType = nil
	self.m_tWin3GemShowList = nil
	self.m_tWin3GemCellList = nil
	self.m_nWin3OpenHoldIndex = nil
	self.m_nWin3DepositedList = nil
	self.m_tWin3SynthesisCost = nil

	self.m_tOperationParam = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootStar:createElement()
	if WndFootStar.m_root ~= nil then
		WindowManager:removeWindow(WndFootStar.m_root, WndFootStar, true)
	end
	if WZFileUtil:isFileExist("pack/footmark/pack_footmark_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/footmark/pack_footmark_0.plist")
    end
    if WZFileUtil:isFileExist("pack/footmark/pack_footmark_1.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/footmark/pack_footmark_1.plist")
    end
	local element = WZUISystem:getInstance():createElement("WndFootStar")
	assert(element, "WndFootStar create element failed!")
	self:_init()
	return element
end

--@brief	获取所有足迹星辰数据成功
function WndFootStar:getFootmarkStarsAllInfoOk(starsId, posInfo, unLock)
	self.m_tAllStarMapData = {}
	self.m_tAllStarUnlock = {}
	for i=1,#starsId do
		self.m_tAllStarUnlock[starsId[i]] = unLock[i]
		self.m_tAllStarMapData[starsId[i]] = {}
		local tPosInfo = json.decode(posInfo[i])
		for j = 1, #tPosInfo do
			self.m_tAllStarMapData[starsId[i]][j] = tonumber(tPosInfo[j]) or 0
		end
	end
	self:updateAllStarMapUI()
end

--@brief    设置装备界面显示类型数据
function WndFootStar:setShowSubType(nSubType)
	self.m_nWin2GemType = nSubType
end

--@brief	更新装备界面显示列表数据
function WndFootStar:updateWin2BagShowData()
	if self.m_nWin2GemType == nil or self.m_nWin2GemType == -1 then
		self.m_tWin2GemShowList = CopyTable(CacheCenter:getFootStarMapGemList())
	else
		self.m_tWin2GemShowList = self:getBagDataBySubType(self.m_nWin2GemType)
	end

	table.sort(self.m_tWin2GemShowList,function(a,b)
		if a.basicInfo.quality ~= b.basicInfo.quality then
			return a.basicInfo.quality > b.basicInfo.quality
		else
			if a.basicInfo.value ~= b.basicInfo.value then
				return a.basicInfo.value > b.basicInfo.value
			else
				if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
					return a.basicInfo.sub_type > b.basicInfo.sub_type
				else
					return a.basicInfo.id > b.basicInfo.id
				end
			end
		end
	end)
end

--@brief	更新装备界面显示列表数据
function WndFootStar:updateWin3BagShowData()
	if self.m_nWin3GemType == nil or self.m_nWin3GemType == -1 then
		self.m_tWin3GemShowList = CopyTable(CacheCenter:getFootStarMapGemList())
	else
		self.m_tWin3GemShowList = self:getBagDataBySubType(self.m_nWin3GemType)
	end

	--去掉不可合成
	for i=#self.m_tWin3GemShowList,1,-1 do
		if self:getNextQualityGemId(self.m_tWin3GemShowList[i].basicInfo.id) == 0 then
			table.remove(self.m_tWin3GemShowList,i)
		end
	end

	--减去加到合成列表的数量
	local nListCount, nGemItemId, nEmptyIndex = self:getSynthesisListCount()
	if self.m_nWin3OpenHoldIndex ~= 0 then
		nListCount = nListCount - 1
	end
	for i=1,#self.m_tWin3GemShowList do
		if self.m_tWin3GemShowList[i].basicInfo.id == nGemItemId then
			self.m_tWin3GemShowList[i].lastNum = self.m_tWin3GemShowList[i].lastNum - nListCount
			if self.m_tWin3GemShowList[i].lastNum == 0 then
				table.remove(self.m_tWin3GemShowList,i)
			end
			break
		end
	end

	table.sort(self.m_tWin3GemShowList,function(a,b)
		if a.basicInfo.quality ~= b.basicInfo.quality then
			return a.basicInfo.quality > b.basicInfo.quality
		else
			if a.basicInfo.value ~= b.basicInfo.value then
				return a.basicInfo.value > b.basicInfo.value
			else
				if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
					return a.basicInfo.sub_type > b.basicInfo.sub_type
				else
					return a.basicInfo.id > b.basicInfo.id
				end
			end
		end
	end)
end

--@brief	根据子类型获取背包数据
function WndFootStar:getBagDataBySubType(nSubType)
	local tData = {}
	local tFootStarMapGemList = CopyTable(CacheCenter:getFootStarMapGemList())
	for i=1,#tFootStarMapGemList do
		if tFootStarMapGemList[i].basicInfo.sub_type == nSubType then
			table.insert(tData,tFootStarMapGemList[i])
		end
	end
	return tData
end

--@brief	根据类型选中一个格子,优先选中空格子
function WndFootStar:getEmptyGemGrid(nSubType)
	local tHoleSite = self.m_tAllStarMapData[self.m_nCurStarMap]

	local tempPosotion = 0
	local tStarMapInfo = GDatatab_footmark_starmap["id_"..self.m_nCurStarMap]
	for i = 1, #tStarMapInfo.position[1] do
		if nSubType == tStarMapInfo.position[1][i] then
			if tHoleSite[i] ~= 0 and tempPosotion == 0 then
				tempPosotion = i
			elseif tHoleSite[i] == 0 and tempPosotion == 0 then
				tempPosotion = i
				break
			elseif tHoleSite[i] == 0 and tempPosotion ~= 0 then
				tempPosotion = i
				break
			end
		end
	end

	return tempPosotion
end

--@brief	获取星座已镶嵌孔位的最高品质
--@param    nStarMapId : 星座id
function WndFootStar:getStarMapMaxQuality(nStarMapId)
	local nQuality = 0
	local tHoleInfo = self.m_tAllStarMapData[nStarMapId]
	for i=1,#tHoleInfo do
		if tHoleInfo[i] == 0 then
			nQuality = 0
			break
		else
			local tGemInfo = GDatatab_item["id_"..tHoleInfo[i]]
			if nQuality == 0 then
				nQuality = tGemInfo.quality
			else
				nQuality = math.min(nQuality, tGemInfo.quality)
			end
		end
	end
	return nQuality
end

--@brief	镶嵌宝石返回
function WndFootStar:getFootmarkStarsStoneMosaicOK(code, nextStarsId)
	if code == 0 then
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[1])
		self.m_tAllStarUnlock[nextStarsId] = 1
		self.m_tAllStarMapData[self.m_tOperationParam[1]][self.m_tOperationParam[2]] = self.m_tOperationParam[3]
		self:updateAllStarMapUI()
	else
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[2])
	end
	self:showWin2BagList(self.m_nWin2GemType)
	-- ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsAllInfo()
end

--@brief	拆卸宝石返回
function WndFootStar:getFootmarkStarsStoneDownOK(code)
	if code == 0 then
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[3])
		self.m_tAllStarMapData[self.m_tOperationParam[1]][self.m_tOperationParam[2]] = 0
		self:updateAllStarMapUI()
	else
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[4])
	end
	conStarMapWin2 = GetElement(self.m_root,"conStarMapWin2_WndFootStar",WZUIContainer)
	if conStarMapWin2:isVisible() then
		self:showWin2BagList(self.m_nWin2GemType)
	end
	-- ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsAllInfo()
end

--@brief	合成宝石返回
function WndFootStar:getFootmarkStarsStoneMergeOK(code, itemId, num, nextStarsId)
	if code == 0 then
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[12])
		self.m_tAllStarUnlock[nextStarsId] = 1
		if self.m_tOperationParam then
			local nextGemId = self:getNextQualityGemId(self.m_tOperationParam[3])
			self.m_tAllStarMapData[self.m_tOperationParam[1]][self.m_tOperationParam[2]] = nextGemId
		end
		self:updateAllStarMapUI()
	else
		MsgBoxManager:showTipBox(LocalStrings.FOOT_STAR_TEXT2[13])
		if self.m_tOperationParam then
			self.m_tAllStarMapData[self.m_tOperationParam[1]][self.m_tOperationParam[2]] = itemId
		end
		self:updateAllStarMapUI()
	end

	if itemId > 0 then
		WndRewardShow:showById({itemId}, {itemNum})
	end

	self:_initWin3Data()
	self:showWin3BagList(self.m_nWin3GemType)
	-- ProtocolProcessorFootMark:send_FOOTMARK_FootmarkStarsAllInfo()
end


--@brief	初始化数据
function WndFootStar:_initWin3Data()
	self.m_nWin3OpenHoldIndex = 0
	for i = 1 , 4 do
		self.m_nWin3DepositedList[i] = 0
	end
end

--@brief	合成列表是否已满
--@return	nListCount : 合成列表数量
--@return	nGemItemId : 宝石id
--@return	nEmptyIndex : 返回第一个空位置,没有空位置返回0
function WndFootStar:getSynthesisListCount()
	local nListCount = 0
	local nGemItemId = 0
	local nEmptyIndex = 0
	for i = 1, #self.m_nWin3DepositedList do
		if self.m_nWin3DepositedList[i] == 0 then
			if nEmptyIndex == 0 then
				nEmptyIndex = i
			end
		else
			nGemItemId = self.m_nWin3DepositedList[i]
			nListCount = nListCount + 1
		end
	end
	return nListCount, nGemItemId, nEmptyIndex
end

--@brief	判断星座是否解锁,并弹提示语
--@param    nStarMapId : 星座id
function WndFootStar:checkStarMapUnlock(nStarMapId)
	local bIsUnlock = self.m_tAllStarUnlock[nStarMapId] == 1

	--提示语处理
	if self.m_tAllStarUnlock[nStarMapId] ~= 1 then
		local tStarMapInfo = GDatatab_footmark_starmap["id_"..nStarMapId]
		local strTips = ""
		local strStarMapName = ""
		local strStarMapColor = ""
		for i=1,#tStarMapInfo.unlock do
			--提示语处理
			local strTempName = GDatatab_footmark_starmap["id_"..tStarMapInfo.unlock[i][1]].name
			if i == 1 then
				strStarMapName = strTempName
			else
				strStarMapName = strStarMapName .. "、" .. strTempName
			end
			strStarMapColor = LocalStrings.FOOT_STAR_TEXT3[tStarMapInfo.unlock[i][2]]
		end
		strTips = string.format(LocalStrings.FOOT_STAR_TEXT2[14],strStarMapName,strStarMapColor)
		MsgBoxManager:showTipBox(strTips)
	end

	return bIsUnlock
end

--@brief	获取当前坑位可镶嵌宝石类型
--@param    starMapId : 星座id
--@param    holeIndex : 坑位下标
function WndFootStar:getHoleGemType(starMapId,holeIndex)
	local nHoleType = GDatatab_footmark_starmap["id_"..starMapId].position[1][holeIndex]
	return nHoleType or -1
end

--@brief	获得合成宝石下一品质宝石id
--@param    gemId : 宝石id
function WndFootStar:getNextQualityGemId(gemId)
	local nextGemId = 0
	for k,v in pairs(GDatatab_footmark_merge) do
		if gemId == v.scrap then
			nextGemId = v.items
			break
		end
	end
	return nextGemId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
