--SceneHolidayVillageData.lua
--@brief	SceneHolidayVillage的数据模块
--@date		2022/05/16
--@author	XTX
--@note		度假村场景界面

HVMAP_SIZEX = 45
HVMAP_SIZEY = 22
HVMAP_ROW = 50
HVMAP_REAL_WIDTH = math.ceil(math.sqrt(HVMAP_SIZEX*HVMAP_SIZEX/4 + HVMAP_SIZEY * HVMAP_SIZEY/4))
HVMAP_WIDTH = HVMAP_SIZEX * HVMAP_ROW
HVMAP_HEIGHT = HVMAP_SIZEY * HVMAP_ROW

PLANT_STATUS = {SEED = 0, SEEDLING = 1, MATURITY = 2} --分别为：种子；幼苗；成熟

SceneHolidayVillage = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneHolidayVillage:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nPlayerId = nil 				--农场主Id
	self.m_tHostInfo = nil 				--农场主信息
	self.m_tVisitorsList = nil 			--访问者信息
	self.m_nMaxVisitorCount = 10			--拜访最大人数
	self.m_tRandomGrid = nil 			--随机格子用于放置生成的拜访玩家
	self.m_tSpiritList = nil 			--精灵信息
	self.m_nMaxSpiritCount = 10			--精灵最大人数
	self.m_tIsRoleMove = nil 			--是否在移动
	self.m_tGridList = nil 				--格子数据
	self.m_tRandomTime = nil 			--随机时间走动
	self.m_nTimeCaculate = 0 			--计时
	self.m_tRolePathNode = nil 			--路径点
	self.m_bIsPtInBuilding = false 		--判断触摸点是否在建筑上
	self.m_clickInfo = nil 				--点击的建筑的信息
	self.m_tConfigId = nil --1=土坑；2=水坑；22=房子；23=小石头；24=大石头
	self.m_tFieldPos = nil   --所在地图位置最近房子的是27-17
	self.m_tBuildingSize = nil     --建筑占格子数大小
	self.m_tBuildingPosition = nil      --地块位置偏移大小
	self.m_tBuildingAnimation = nil  --默认图标
	self.m_tStoreData = nil 			--仓库数据
	self.m_nSceneState = -1 				--0=白天；1=傍晚
	self.m_nOperateType = 0 			--操作类型
	self.m_nUpdatePlantTime = 0 		--更新作物状态时间累积
	self.m_tCellExtendField = nil 		--待扩展的土坑  用于度假村等级变化时候，更新木牌上的提示语
	self.m_tCellExtendField2 = nil 		--待扩展的水坑  用于度假村等级变化时候，更新木牌上的提示语
	self.m_scheduleId = -1  			--延时刷新界面
	self.m_scheduleId2 = -1  			--延时显示偷取奖励
	self.m_scheduleId3 = -1  			--延时显示松土奖励
	self.m_tHarvestField = nil 			--收获的土坑数据,用于获取地块，展示收获后的固定奖励
	self.m_tOperateReward = {} 			--操作奖励
	self.m_nSleepValue = 50 			--精灵饱食度少于这个值播放睡觉动作
	self.m_tSleepPosition = {{28,32}}		--精灵睡眠时位置
	self.m_tCellHouse = nil 			--小屋buildCell
	self.m_tCellRightHouse = nil 		--水车边上房子
	self.m_tDivineTreeInfo = nil 		--神树信息
	self.m_tCellFieldObjList = {}		--存放土坑水坑对象列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneHolidayVillage:_unInit()
	self.m_root = nil
	self.m_nPlayerId = nil 				--农场主Id
	self.m_tHostInfo = nil 				--农场主信息
	self.m_tVisitorsList = nil 			--访问者信息
	self.m_nMaxVisitorCount = nil			--拜访最大人数
	self.m_tRandomGrid = nil 
	self.m_tSpiritList = nil 			--精灵信息
	self.m_nMaxSpiritCount = nil			--精灵最大人数
	self.m_tIsRoleMove = nil 			--是否在移动
	self.m_tGridList = nil 				--格子数据
	self.m_tRandomTime = nil 			--随机时间走动
	self.m_nTimeCaculate = nil 			--计时
	self.m_tRolePathNode = nil 			--路径点
	self.m_bIsPtInBuilding = nil 		--判断触摸点是否在建筑上
	self.m_clickInfo = nil 				--点击的建筑的信息
	self.m_tConfigId = nil
	self.m_tFieldPos = nil 
	self.m_tBuildingSize = nil 
	self.m_tBuildingPosition = nil 
	self.m_tBuildingAnimation = nil 
	self.m_tStoreData = nil 			--仓库数据
	self.m_nSceneState = nil 				--0=白天；1=傍晚
	self.m_nOperateType = nil 
	self.m_nUpdatePlantTime = nil 		--更新作物状态时间累积
	self.m_tCellExtendField = nil 		--待扩展的地块
	self.m_tCellExtendField2 = nil 		--待扩展的水坑
	self.m_scheduleId = nil  			--延时刷新界面
	self.m_scheduleId2 = nil 
	self.m_scheduleId3 = nil 
	self.m_tHarvestField = nil 		
	self.m_tOperateReward = nil 	
	self.m_nSleepValue = nil
	self.m_tSleepPosition = nil
	self.m_tCellHouse = nil 
	self.m_tCellRightHouse = nil 
	self.m_tDivineTreeInfo = nil 
	self.m_tCellFieldObjList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneHolidayVillage:createElement()
	self.m_createFlag = true 
	local element = WZUISystem:getInstance():createElement("SceneHolidayVillage")
	assert(element, "SceneHolidayVillage create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function SceneHolidayVillage:showInterface(playerId)
	if not CheckButtonOpen(ISLAND_BUILDING_HOLIDAYVILLAGE) then return end 
	local nTempId = playerId or CacheCenter:getPlayerInfo().id 
	if self.m_root and self.m_nPlayerId == nTempId then return end 
	if self.m_root then 
		WZLog("SceneHolidayVillage:showInterface", self.m_nPlayerId)
		ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_HolidayVillageOp(false, self.m_nPlayerId)
	end

	local scene = SceneHolidayVillage:createElement()
	if scene then 
		self.m_nPlayerId = playerId or CacheCenter:getPlayerInfo().id
	    replaceScene(scene)
	end
end

--@brief 	设置度假村数据
--@param 	fieldStatus:1可种植；0可扩建；-1尚未扩建；
--@param 	plantStatus:0还没有播种；1种子阶段；2嫩苗阶段；3成熟阶段
--@param 	plantPests:害虫数量
function SceneHolidayVillage:setHostData(hostPlayerId, hostName, hostHeadId, hostFaceId, hostHeadColor, hostHeadEffectId, hostSex, hostVipLevel, hostServerId, hostLvel, hvLevel, hvExp, hvCurEnergy, achieId, hvCoolValue, houseId, waterWheelId)
	--农场主信息
	self.m_tHostInfo = {}
	self.m_tHostInfo.playerId = self.m_nPlayerId
	self.m_tHostInfo.name = hostName
	self.m_tHostInfo.sex = hostSex
	self.m_tHostInfo.headId = hostHeadId
	self.m_tHostInfo.faceId = hostFaceId
	self.m_tHostInfo.headColor = hostHeadColor
	self.m_tHostInfo.headEffectId = hostHeadEffectId
	self.m_tHostInfo.level = hostLvel
	self.m_tHostInfo.serverId = hostServerId
	self.m_tHostInfo.headEffectId = hostHeadEffectId
	self.m_tHostInfo.vipLevel = hostVipLevel
	--更新待扩展地块木牌上的文字，位置必须在hvLevel赋值之前
	self:_updateExtendFieldWords(hvLevel)

	self.m_tHostInfo.hvLevel = hvLevel
	self.m_tHostInfo.hvExp = hvExp
	self.m_tHostInfo.hvCurEnergy = hvCurEnergy
	self.m_tHostInfo.achieId = achieId
	self.m_tHostInfo.hvCoolValue = hvCoolValue
	self.m_tHostInfo.houseId = houseId
	self.m_tHostInfo.waterWheelId = waterWheelId

	WZLog("SceneHolidayVillage:setHostData", Serialize(self.m_tHostInfo))
	WndHVOperate:_showPlayerInfo()
	self:updateWaterWheel(1)
end

--@brief 	设置土坑、作物数据
--@param 	synType : 同步类型，0-全部，1-增，2-更新，3-删
function SceneHolidayVillage:setFieldAndPlantData(playerId, synType,fieldPos, fieldStatus, fieldLv, plantId, plantStatus, plantPests, plantGroupTime, leftNum, extraInfo, totalNum, refines, waterings, digs, exps, fertilizerIds, reduceNumes, opType, flowerpotIds)
	WZLog("SceneHolidayVillage:setFieldAndPlantData", self.m_nPlayerId, playerId, synType, Serialize(fieldPos), Serialize(fieldStatus), Serialize(fieldLv), Serialize(extraInfo), opType)
	if self.m_nPlayerId == playerId then 
		WZLog("SceneHolidayVillage:setFieldAndPlantData Zero", SystemTime:getServerTime())
		if synType == 0 then 
			for i = 1, #fieldPos do
				WZLog("SceneHolidayVillage:setFieldAndPlantData one", plantId[i], plantStatus[i], plantGroupTime[i], plantPests[i], leftNum[i], totalNum[i], exps[i], fertilizerIds[i], waterings[i], digs[i], reduceNumes[i])
				if fieldPos[i] < 15 then 
					self:setOneBuildingData(plantId[i], plantStatus[i], plantPests[i], fieldStatus[i], fieldPos[i] + 1, fieldLv[i], plantGroupTime[i], leftNum[i], extraInfo[i], totalNum[i], refines[i], waterings[i], digs[i], exps[i], fertilizerIds[i], reduceNumes[i], flowerpotIds[i])
				end
			end
			--设置待开垦的土坑
			self:setNextExtendField()
			--创建土坑以及植物
			self:_createBuilding()
		elseif synType == 2 then 
			for i = 1, #fieldPos do
				WZLog("SceneHolidayVillage:setFieldAndPlantData two", plantId[i], plantStatus[i], plantGroupTime[i], plantPests[i], leftNum[i], totalNum[i], exps[i], fertilizerIds[i], waterings[i], digs[i], reduceNumes[i])
				if fieldPos[i] < 15 then 
					self:setOneBuildingData(plantId[i], plantStatus[i], plantPests[i], fieldStatus[i], fieldPos[i] + 1, fieldLv[i], plantGroupTime[i], leftNum[i], extraInfo[i], totalNum[i], refines[i], waterings[i], digs[i], exps[i], fertilizerIds[i], reduceNumes[i], flowerpotIds[i])
					local indexX = self.m_tFieldPos[fieldPos[i] + 1][1]
					local indexY = self.m_tFieldPos[fieldPos[i] + 1][2]
					if WndHVField.m_root and self.m_tGridList[indexX + 1][indexY + 1] then 
						if self.m_tGridList[indexX + 1][indexY + 1].fieldId == WndHVField.m_tData.fieldId then 
							GlobalGame:getGameEventDispathcer():Dispatch(HolidayVillageEvent.HolidayVillageEvent_Field, self.m_tGridList[indexX + 1][indexY + 1])
						end
					end
					--如果操作按钮和信息详情Tips存在，则更新按钮和详情
	                self:_updatePlantBtnAndDetail(self.m_tGridList[indexX + 1][indexY + 1])
	            end
			end
			--设置待开垦的土坑
			self:setNextExtendField()
			if opType == 2 then 
				if self.m_scheduleId == -1 then
			        self.m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.delayCreateBuilding, 0.6, false)
			    end
			elseif opType == 4 then 
				if self.m_scheduleId == -1 then
			        self.m_scheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.delayCreateBuilding, 0.6, false)
			    end
			else
				--创建土坑以及植物
				self:_createBuilding()
			end
		end
	end
end

--@brief 	访客数据
function SceneHolidayVillage:setVisitorsData(visitorIds, visitorSexs, visitorNames, visitorFaceIds, visitorHeadIds, visitorHeadColors, visitorBodyIds, visitorBodyColors, visitorWingIds, visitorServerIds, visitorLevels, visitorVipLevels, visitorTitle, visitorFootMark, visitorBlueVipInfo, spirits, synType)
	if synType == 0 then 
		self.m_tVisitorsList = {}
	end
	if synType == 0 or self.m_tSpiritList == nil then
		self.m_tSpiritList = {}
	end
	if self.m_tCellSpiritRoles == nil then
		self.m_tCellSpiritRoles = {}
	end
	WZLog("SceneHolidayVillage:setVisitorsData one", synType)
	if synType == 3 then 
		for i = 1, #visitorIds do
			if visitorIds[i] == self.m_nPlayerId then 
				self:createHostRole(true)
			else
				--隐藏离开的玩家形象显示
				if self.m_tCellVisitorRole then 
					for j = 1, #self.m_tCellVisitorRole do
						local tItem = self.m_tCellVisitorRole[j]:getData()
						if tItem and tItem.playerId == visitorIds[i] then 
							WZLog("SceneHolidayVillage:setVisitorsData two")
							self.m_tIsRoleMove[j + 1] = false
							self.m_tCellVisitorRole[j]:setRoleVisible(false)
							break 
						end
					end
				end
			end
		end
	else
		for i = 1, #visitorIds do
			local tItem = {}
			tItem.playerId = visitorIds[i]
			tItem.sex 	   = visitorSexs[i]
			tItem.name 	   = visitorNames[i]
			tItem.faceId   = visitorFaceIds[i]
			tItem.headId   = visitorHeadIds[i]
			tItem.headColor = visitorHeadColors[i]
			tItem.bodyId   = visitorBodyIds[i]
			tItem.bodyColor = visitorBodyColors[i]
			tItem.wingId = visitorWingIds[i]
			tItem.serverId = visitorServerIds[i]
			tItem.level = visitorLevels[i]
			tItem.vipLevel = visitorVipLevels[i]
			tItem.title = visitorTitle[i]
			tItem.footMark = visitorFootMark[i]
			if visitorBlueVipInfo and visitorBlueVipInfo[i] and visitorBlueVipInfo[i] ~= "" then 
				tItem.qqHallData = json.decode(visitorBlueVipInfo[i])
			end
			if tItem.playerId == self.m_nPlayerId then 
			--	WZLog("SceneHolidayVillage:setVisitorsData five")
				self:createHostRole(nil, tItem)
			else
				if synType == 2 then --新增
					--已存在并显示的角色不再重复创建出来
					local bDisplayedRole = false
					if self.m_tCellVisitorRole then
						for j = 1, #self.m_tCellVisitorRole do
							local tRoleData = self.m_tCellVisitorRole[j]:getData()
							local bVisible = self.m_tCellVisitorRole[j]:getRoleVisible()
							if tRoleData.playerId == tItem.playerId and bVisible then
								bDisplayedRole = true
								break
							end
						end
					end
					if not bDisplayedRole then
						local bAddNew = true 
						if self.m_tCellVisitorRole then --如果原来有隐藏的，则使用原来隐藏的玩家的形象，不用重新创建
							for j = 1, #self.m_tCellVisitorRole do
								local bVisible = self.m_tCellVisitorRole[j]:getRoleVisible()
								if not bVisible then 
									local tEquip = {}
									table.insert(tEquip, tItem.headId)
									table.insert(tEquip, tItem.faceId)
									table.insert(tEquip, tItem.bodyId)
									table.insert(tEquip, tItem.wingId)

									local tData = {}
									tData.name = tItem.name
									tData.sex = tItem.sex
									tData.tEquip = tEquip
									tData.headColor = tItem.headColor
									tData.bodyColor = tItem.bodyColor
									tData.playerId = tItem.playerId
									self.m_tIsRoleMove[j + 1] = false
									self.m_tCellVisitorRole[j]:setData(tData, 5)
									self.m_tCellVisitorRole[j]:setRoleVisible(true)
									self.m_tVisitorsList[j] = tItem
									bAddNew = false 
									WZLog("SceneHolidayVillage:setVisitorsData three")
									break 
								end
							end
						end
						if bAddNew then --需新创建一个形象
							WZLog("SceneHolidayVillage:setVisitorsData four")
							if self.m_tVisitorsList == nil then self.m_tVisitorsList = {} end 
							table.insert(self.m_tVisitorsList, tItem)
							local nIndex = #self.m_tVisitorsList
							self:_createOneVisitor(nIndex, self.m_tVisitorsList[nIndex])
						end
					end
				else
					table.insert(self.m_tVisitorsList, tItem)
				end
			end
		end
	end


	--精灵
	local spiritIds = {}
	local spiritSteps = {}
	local spiritLevels = {}
	local spiritSatietys = {}
	for i=1,#visitorIds do
		if visitorIds[i] == self.m_nPlayerId then
			if spirits[i] ~= "" then
				local tempSpirits = json.decode(spirits[i])
				for j=1,#tempSpirits do
					if tempSpirits[j] ~= "" then
						local tSpiritData = SplitStringWithSeparator(tempSpirits[j],",")
						table.insert(spiritIds, tonumber(tSpiritData[1]))
						table.insert(spiritLevels, tonumber(tSpiritData[2]))
						table.insert(spiritSteps, tonumber(tSpiritData[3]))
						table.insert(spiritSatietys, tonumber(tSpiritData[4]))
					end
				end
			end
			if synType == 0 then
				for j=1,#spiritIds do
					local tData = {}
					tData.spiritId = spiritIds[j]
					tData.spiritLevel = spiritLevels[j]
					tData.spiritStep = spiritSteps[j]
					tData.spiritSatiety = spiritSatietys[j]
					table.insert(self.m_tSpiritList, tData)
				end
			else
				for j=1,#spiritIds do
					local tData = {}
					tData.spiritId = spiritIds[j]
					tData.spiritLevel = spiritLevels[j]
					tData.spiritStep = spiritSteps[j]
					tData.spiritSatiety = spiritSatietys[j]
					local bAddNew = true
					if self.m_tCellSpiritRoles then
						for k = 1, #self.m_tCellSpiritRoles do
							local tItem = self.m_tCellSpiritRoles[k]:getData()
							if tItem and tItem.spiritId == spiritIds[j] then --找到相同的更新
								WZLog("SceneHolidayVillage:setVisitorsData spirit_update")
								self.m_tIsRoleMove[k + self.m_nMaxVisitorCount + 1] = false
								self.m_tCellSpiritRoles[k]:setData(tData, 6)
								self.m_tCellSpiritRoles[k]:setRoleVisible(true)
								self.m_tSpiritList[k] = tData
								bAddNew = false
								self:updateSpiritSleep(k) --更新精灵睡觉状态
								break 
							end
						end
					end
					if bAddNew then --没找到就新创建一个
						WZLog("SceneHolidayVillage:setVisitorsData spirit_Add")
						table.insert(self.m_tSpiritList, tData)
						local nIndex = #self.m_tSpiritList
						self:_createOneSpirit(nIndex, self.m_tSpiritList[nIndex])
					end
				end
				if self.m_tCellSpiritRoles then
					for j = 1, #self.m_tCellSpiritRoles do
						local bDelOld = true
						local tItem = self.m_tCellSpiritRoles[j]:getData()
						for k=1,#spiritIds do
							if tItem and tItem.spiritId == spiritIds[k] then
								bDelOld = false
								break
							end
						end
						if bDelOld then
							WZLog("SceneHolidayVillage:setVisitorsData spirit_Delect")
							self.m_tIsRoleMove[j + self.m_nMaxVisitorCount + 1] = false
							self.m_tCellSpiritRoles[j]:setRoleVisible(false)
						end
					end
				end
			end
		end
	end



	if synType == 0 then 
		self:createAni()

		self.m_root:enableSchedule("roleAndKidMove",0)
	end
	
    --显示夫妻互动动画
    self:showCoupleAnimation()
end

--@brief 	获取度假村主人信息
function SceneHolidayVillage:getHostInfo()
	return self.m_tHostInfo
end

--@brief 	判断触摸点是否在建筑内
function SceneHolidayVillage:judgePtInBuilding(tData)
	-- body
	if self.m_clickInfo and self.m_clickInfo.tData.configId == tData.configId and self.m_clickInfo.tData.indexX == tData.indexX and self.m_clickInfo.tData.indexY == tData.indexY then
		self.m_bIsPtInBuilding = true
	end
	WZLog("SceneHolidayVillage:judgePtInBuilding", self.m_bIsPtInBuilding)
end

--@brief 	设置某一格数据
function SceneHolidayVillage:setOneBuildingData(plantId, plantStatus, plantPests, fieldStatus, fieldId, fieldLv, plantGroupTime, leftNum, extraInfo, totalNum, refine, waterings, digs, exp, fertilizerId, reduceNumes, flowerpotId)
	-- body
	local tPlantInfo = GDatatab_item["id_" .. plantId]
	local indexX = self.m_tFieldPos[fieldId][1]
	local indexY = self.m_tFieldPos[fieldId][2]
	
	if not self.m_tGridList[indexX + 1] then
		return
	end

	self.m_tGridList[indexX + 1][indexY + 1].plantId = plantId
	self.m_tGridList[indexX + 1][indexY + 1].fieldId = fieldId
	self.m_tGridList[indexX + 1][indexY + 1].plantStatus = plantStatus
	self.m_tGridList[indexX + 1][indexY + 1].plantPests = plantPests
	self.m_tGridList[indexX + 1][indexY + 1].fieldLv = fieldLv
	self.m_tGridList[indexX + 1][indexY + 1].fieldStatus = fieldStatus or 0
	self.m_tGridList[indexX + 1][indexY + 1].plantInfo = tPlantInfo
	self.m_tGridList[indexX + 1][indexY + 1].plantGroupTime = plantGroupTime
	self.m_tGridList[indexX + 1][indexY + 1].leftNum = leftNum
	self.m_tGridList[indexX + 1][indexY + 1].extraInfo = extraInfo and extraInfo ~= "" and json.decode(extraInfo) or {}
	self.m_tGridList[indexX + 1][indexY + 1].totalNum = totalNum
	self.m_tGridList[indexX + 1][indexY + 1].refine = refine
	self.m_tGridList[indexX + 1][indexY + 1].bIsWater = waterings
	self.m_tGridList[indexX + 1][indexY + 1].bIsDig = digs
	self.m_tGridList[indexX + 1][indexY + 1].plantExp = exp
	self.m_tGridList[indexX + 1][indexY + 1].fertilizerIncr = fertilizerId --增产化肥Id
	self.m_tGridList[indexX + 1][indexY + 1].reduceNumes = reduceNumes --减产数量
	self.m_tGridList[indexX + 1][indexY + 1].flowerpotId = flowerpotId --花盆Id

	self:_updatePlantBtnAndDetail(self.m_tGridList[indexX + 1][indexY + 1])
end

--@brief 	只设置一个未开垦的土坑为待开垦坑
function SceneHolidayVillage:setNextExtendField()
	--初始化土地块数据
	local bIsSet = false 
	local bIsSet2 = false 
	for i = 1, #self.m_tConfigId do
		local indexX = self.m_tFieldPos[i][1]
		local indexY = self.m_tFieldPos[i][2]
		if self.m_tConfigId[i] == 1 then 
			if self.m_tGridList[indexX + 1][indexY + 1].fieldStatus <= 0 then 
				if not bIsSet then 
					self.m_tGridList[indexX + 1][indexY + 1].fieldStatus = 0
					bIsSet = true 
				else
					self.m_tGridList[indexX + 1][indexY + 1].fieldStatus = -1
				end
			end
		elseif self.m_tConfigId[i] == 2 then 
			if self.m_tGridList[indexX + 1][indexY + 1].fieldStatus <= 0 then 
				if not bIsSet2 then 
					self.m_tGridList[indexX + 1][indexY + 1].fieldStatus = 0
					bIsSet2 = true 
				else
					self.m_tGridList[indexX + 1][indexY + 1].fieldStatus = -1
				end
			end
		end
	end
	if not bIsSet then 
		self.m_tCellExtendField = nil 
	end
	if not bIsSet2 then 
		self.m_tCellExtendField2 = nil 
	end
end

--@brief 	获取仓库数据
function SceneHolidayVillage:setStoreData(warehouseType, itemIds, nums, synType)
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
function SceneHolidayVillage:getItemCountByItemId(id)
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

--@brief 	根据仓库中的肥料数据
function SceneHolidayVillage:getFertilizerData()
	local tData = {} 
	if self.m_tStoreData == nil then return tData end 

	for i = 1, #self.m_tStoreData do
		local basicData = GDatatab_item["id_" .. self.m_tStoreData[i].id]
		if basicData.main_type == 45 and (basicData.sub_type == 3 or basicData.sub_type == 4) then
			table.insert(tData, self.m_tStoreData[i])
		end
	end

	return tData
end

--@brief 	获取选中的土坑信息
function SceneHolidayVillage:getClickFieldData()
	return self.m_clickInfo
end

--@brief 	获取度假村主人Id
function SceneHolidayVillage:getHostId()
	return self.m_nPlayerId
end

--@brief 	获取场景状态
function SceneHolidayVillage:getSceneState()
	return self.m_nSceneState
end

--@brief 	设置操作类型
function SceneHolidayVillage:setOperateType(operateType, seedData, fieldData)
	self.m_nOperateType = operateType
	if operateType == 1 then --播种
		self.m_tSeedData = seedData
		SceneHolidayVillage:sowCallBack(self.m_clickInfo.tData)
	--	self:_createOperateIcon(operateType, seedData)
	elseif operateType == 2 then --肥料
	 	self.m_tSeedData = seedData
	 	if fieldData.plantId > 0 and fieldData.bIsWater then 
            SceneHolidayVillage:fertilizerCallBack(fieldData)
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[61])
        end
    elseif operateType == 5 then --采摘
		self:_createOperateIcon(operateType)
	elseif operateType == 6 then --偷取
		self:_createOperateIcon(operateType)
	elseif operateType == 0 then 
		self:_createOperateIcon(operateType)
	end
end

--@brief 	获取操作类型
function SceneHolidayVillage:getOperateType()
	return self.m_nOperateType
end

--@brief 	操作结果
function SceneHolidayVillage:operateResult(opType, result, itemIds, nums)
	if result == 0 then 
		if opType == 1 then --播种
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[47])
			--恢复正常状态
			self:setOperateType(0)
		elseif opType == 2 then --施肥
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[60])
			--恢复正常状态
			self:setOperateType(0)
		elseif opType == 3 then --浇水
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[51])
			--恢复正常状态
			self:setOperateType(0)
		elseif opType == 4 then --捕捉
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[56])
			if #itemIds > 0 then 
				WndRewardShow:showById(itemIds, nums)
			end
			--恢复正常状态
			self:setOperateType(0)
		elseif opType == 5 then --采摘
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[57])
			local tExtraData = {id = 0, itemIds = {}, itemNums = {}}
			local seedData = nil 
			for i = 1, #itemIds do
				local basicData = GDatatab_item["id_" .. itemIds[i]]
				if basicData and basicData.main_type == 45 and basicData.sub_type == 1 then 
					seedData = WndHVLibrary:getSeedDataByItemId(itemIds[i])
					tExtraData.id = itemIds[i]
					break 
				end
			end
			--检测是否有额外奖励
			local bHaveExtraReward = false --是否有额外奖励
			if seedData then 
				for i= 1, #itemIds do
					if itemIds[i] > 0 then 
						for j = 1, #seedData.item_reward do
							if itemIds[i] == seedData.item_reward[j][1] then 
								table.insert(tExtraData.itemIds, itemIds[i])
								table.insert(tExtraData.itemNums, nums[i])

								bHaveExtraReward = true 
							end
						end
					end
				end
				--原来的奖励数据，剔除掉额外奖励
				for i = 1, #tExtraData.itemIds do
					for j = 1, #itemIds do
						if tExtraData.itemIds[i] == itemIds[j] then 
							table.remove(itemIds, j)
							table.remove(nums, j)
							break 
						end
					end
				end

			end
			if self.m_tHarvestField then 
				self.m_tHarvestField.fixedReward = {itemIds = {}, nums = {}}
				for i = 1, #itemIds do
					if nums[i] ~= 0 then 
						table.insert(self.m_tHarvestField.fixedReward.itemIds, itemIds[i])
						table.insert(self.m_tHarvestField.fixedReward.nums, nums[i])
					end
				end
			end

			if bHaveExtraReward then 
				WndHVExtraReward:showInterface(tExtraData)
			end
			--显示采摘固定奖励
			if self.m_tHarvestField then 
				--没有额外奖励，直接显示固定奖励
				if not bHaveExtraReward then 
					self:showFixedReward()
			    end
			end
			--恢复正常状态
			self:setOperateType(0)
			--刷新一下订单状态，获取红点
			ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetFlowerOrder(0, -1)
		elseif opType == 6 then --偷取
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[58])
			if self.m_scheduleId2 == -1 then
				if #itemIds > 0 then 
					self.m_tOperateReward = {stealReward = {itemIds = itemIds, nums = nums}}
		        	self.m_scheduleId2 = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.delayShowReward, 0.6, false)
		        end
		    end
			--恢复正常状态
			self:setOperateType(0)
		elseif opType == 8 then --松土
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[50])
			if #itemIds > 0 then 
				self.m_tOperateReward = {looseReward = {itemIds = itemIds, nums = nums}}
				if self.m_scheduleId3 == -1 then
		        	self.m_scheduleId3 = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(self.delayShowLooseReward, 0.6, false)
		        end
			end
			--恢复正常状态
			self:setOperateType(0)
		elseif opType == 9 then --开垦
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[76])
			--恢复正常状态
			self:setOperateType(0)
		end
	else
		if result == -1007 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[62])
		elseif result == -1009 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[63])
		elseif result == -1010 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[64])
		elseif result == -1011 or result == -1012 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[55])
		elseif result == -1013 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[54])
		elseif result == -1014 then 
		elseif result == -1015 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[83])
		elseif result == -1018 then 
			MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT4[23])
		end
		--恢复正常状态
		self:setOperateType(0)
	end
end

--@brief 	延时显示偷取奖励
function SceneHolidayVillage:delayShowReward()
	local self = SceneHolidayVillage

	if self.m_scheduleId2 ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId2)
        self.m_scheduleId2 = -1
    end

    if self.m_tOperateReward.stealReward == nil then return end 

    WndRewardShow:showById(self.m_tOperateReward.stealReward.itemIds, self.m_tOperateReward.stealReward.nums)
    self.m_tOperateReward.stealReward = nil 
end

--@brief 	延时显示松土奖励
function SceneHolidayVillage:delayShowLooseReward()
	local self = SceneHolidayVillage
	
	if self.m_scheduleId3 ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId3)
        self.m_scheduleId3 = -1
    end

    if self.m_tOperateReward.looseReward == nil then return end 

    WndRewardShow:showById(self.m_tOperateReward.looseReward.itemIds, self.m_tOperateReward.looseReward.nums)
    self.m_tOperateReward.looseReward = nil 
end

--@brief 	设置待扩展地块Cell值
function SceneHolidayVillage:setExtendFieldCell(tCell, tCell2)
	if self.m_root == nil then return end 

	if tCell then 
		self.m_tCellExtendField = tCell
	end
	if tCell2 then 
		self.m_tCellExtendField2 = tCell2
	end
end

--@brief 	是否自己的度假村
function SceneHolidayVillage:isMyHolidayVillage()
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then 
		return true 
	end

	return false 
end

--@brief 	显示收获固定奖励
function SceneHolidayVillage:showFixedReward()
	if self.m_root == nil then return end 
	if self.m_tHarvestField == nil then return end 
	--获取收获的土坑
	local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
	local indexX, indexY = self.m_tHarvestField.indexX, self.m_tHarvestField.indexY
	local nTag = (indexX - 1) * HVMAP_ROW + indexY
    if conForBuilding:getChildByTag(nTag) then 
        local element = conForBuilding:getChildByTag(nTag)
        element = WZUIContainer:luaTo(element)
        local tCell = element:getLuaObjectIndex()
        if tCell then 
            tCell:createReward(self.m_tHarvestField.fixedReward.itemIds, self.m_tHarvestField.fixedReward.nums)
        end
    end
end

--@brief 	切换装饰物结果
function SceneHolidayVillage:operateDecorationResult(opType, updateId)
	if opType == 3 then 
		self.m_tHostInfo.houseId = updateId
		self:updateWaterWheel(2)
	elseif opType == 4 then 
		self.m_tHostInfo.waterWheelId = updateId
		self:updateWaterWheel(1, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	生成四个随机的格子，不重复，格子上面没有物品
function SceneHolidayVillage:generateRandomGrid()
	-- body
	self.m_tRandomGrid = {}
	local mMaxNum = self.m_nMaxVisitorCount + 1 + self.m_nMaxSpiritCount
	while #self.m_tRandomGrid < mMaxNum do 
		local nIndexX = math.random(1, HVMAP_ROW)
		local nIndexY = math.random(1, HVMAP_ROW)
		local bFind = false 
		while not bFind do
			if self.m_tGridList[nIndexX] and self.m_tGridList[nIndexX][nIndexY] and self.m_tGridList[nIndexX][nIndexY].configId == -1 then 
				bFind = true 
				for i = 1, #self.m_tRandomGrid do
					if self.m_tRandomGrid[i][1] == nIndexX and self.m_tRandomGrid[i][2] == nIndexY then 
						bFind = false 
						break 
					end
				end
			end
			if bFind then 
				table.insert(self.m_tRandomGrid, {nIndexX, nIndexY})
			else
				nIndexX = math.random(1, HVMAP_ROW)
				nIndexY = math.random(1, HVMAP_ROW)
			end
		end
	end

	WZLog("SceneHolidayVillage:generateRandomGrid", Serialize(self.m_tRandomGrid))
end

--@brief 	根据格子X,Y索引，计算绝对坐标
--@param 	tBasicData:建筑表数据
function SceneHolidayVillage:_getAbsPosition(indexX, indexY, tBasicData)	-- body
	local gapX = HVMAP_SIZEX / 2 
    local gapY = HVMAP_SIZEY / 2 

    local tData = tBasicData
    local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * HVMAP_SIZEX
    local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * HVMAP_SIZEY
    local startX = 0 + (indexX - 1) * gapX
    local startY = HVMAP_HEIGHT / 2 - (indexX - 1) * gapY
    local nAbsPointX = startX + indexY * gapX - gapX + nConWidth/2
    local nAbsPointY = startY + (indexY - 1) * gapY

    return nAbsPointX, nAbsPointY
end

--@brief 	初始化格子数据
function SceneHolidayVillage:_initGridData()
	--初始化格子数据
	self.m_tGridList = {} 	
	local gapX = HVMAP_SIZEX / 2 
    local gapY = HVMAP_SIZEY / 2 			--格子数据
	for i = 1, HVMAP_ROW do 
		self.m_tGridList[i] = {}
		local startX = 0 + (i - 1) * gapX
        local startY = HVMAP_HEIGHT / 2 - (i - 1) * gapY
		for j = 1, HVMAP_ROW do
			local tItem = {}
			local nPosX = startX + j * gapX
			local nPosY = startY + (j - 1) * gapY
			if nPosY > HVMAP_HEIGHT*9/16 + HVMAP_SIZEY then --上部不可跑动
				tItem.configId = 0
			elseif nPosY < 23*gapY then --下部不可跑动
				tItem.configId = 0
			elseif nPosX < 21*gapX then --左边
				tItem.configId = 0
			elseif nPosX > HVMAP_WIDTH - 21*gapX then --右边
				tItem.configId = 0
			else
				tItem.configId = -1     --标记：-1->表示可以使用；0->表示不能使用；>0表示建筑物 
			end
			tItem.basicData = nil  	--建筑表数据
			tItem.plantInfo = nil 	--物品表数据
			tItem.indexX = i 
			tItem.indexY = j

			self.m_tGridList[i][j] = tItem 
		end
	end
	--初始化土地块数据
	for i = 1, #self.m_tConfigId do
		local indexX = self.m_tFieldPos[i][1]
		local indexY = self.m_tFieldPos[i][2]
		self.m_tGridList[indexX + 1][indexY + 1].configId = self.m_tConfigId[i]
		WZLog("SceneHolidayVillage:_initGridData", self.m_tConfigId[i], indexX, indexY)
		local tBasicData = nil 
		if self.m_tConfigId[i] > 0 and self.m_tConfigId[i] < 20 then 
			tBasicData = {animation = self.m_tBuildingAnimation[i], size = {self.m_tBuildingSize[i]}, position = {self.m_tBuildingPosition[i]}}

			self.m_tGridList[indexX + 1][indexY + 1].plantId = 0
			self.m_tGridList[indexX + 1][indexY + 1].fieldId = i
			self.m_tGridList[indexX + 1][indexY + 1].plantStatus = 0
			self.m_tGridList[indexX + 1][indexY + 1].plantPests = 0
			self.m_tGridList[indexX + 1][indexY + 1].fieldLv = 0
			self.m_tGridList[indexX + 1][indexY + 1].fieldStatus = -1
			self.m_tGridList[indexX + 1][indexY + 1].basicData = tBasicData
			self.m_tGridList[indexX + 1][indexY + 1].bIsWater = false 
			self.m_tGridList[indexX + 1][indexY + 1].bIsDig = false 
		elseif self.m_tConfigId[i] > 0 then 
			tBasicData = {animation = self.m_tBuildingAnimation[i], size = {self.m_tBuildingSize[i]}, position = {self.m_tBuildingPosition[i]}}
			self.m_tGridList[indexX + 1][indexY + 1].plantId = 0
			self.m_tGridList[indexX + 1][indexY + 1].basicData = tBasicData
		end
		if self.m_tConfigId[i] > 0 then
			for k = indexX + 1, indexX + tBasicData.size[1][1] do
				for j = indexY + 1, indexY + tBasicData.size[1][2] do
					if k == indexX + 1 and j == indexY + 1 then
					else
						if self.m_tGridList[k] and self.m_tGridList[k][j] then
							self.m_tGridList[k][j].configId = 0
						end
					end
				end
			end
		end
	end
end

--@brief    检测移动间隔时间,为了确保只有一个小孩开始移动,因为多个小孩一起移动比较卡
function SceneHolidayVillage:checkMoveRandomTime()
    local bIsSomeoneMove = false --是否有人要移动
    local tMoveCount = {} --要移动人下标的列表
    for i=1,#self.m_tRandomTime do
        if self.m_tRandomTime[i] <= 0 then
            table.insert(tMoveCount,i)
        end
    end
    if #tMoveCount > 0 then
        local randIndex = math.random(#tMoveCount) --选出一个用来移动,其他都不移动
        for i=1,#tMoveCount do
            if randIndex ~= i then
                self.m_tRandomTime[tMoveCount[i]] = self.m_tRandomTime[tMoveCount[i]] + math.random(5, 15)
            end
        end
    end
end

--@brief 	当所站位置被家具占用后，重新随机一个位置
function SceneHolidayVillage:reGenerateOneGrid(tCellRoleObj)
	-- body
	local nIndexX = math.random(1, HVMAP_ROW)
	local nIndexY = math.random(1, HVMAP_ROW)
	
	local offset = 8
	if tCellRoleObj then
		local tGridData = tCellRoleObj:getRoleGridData()
		nIndexX = math.random(math.max(tGridData[1]-offset,0), math.min(tGridData[1]+offset,HVMAP_ROW))
		nIndexY = math.random(math.max(tGridData[2]-offset,0), math.min(tGridData[2]+offset,HVMAP_ROW))
	end

	local bFind = false 
	while not bFind do
		if self.m_tGridList[nIndexX] and self.m_tGridList[nIndexX][nIndexY] and self.m_tGridList[nIndexX][nIndexY].configId == -1 then 
			bFind = true 
			for i = 1, #self.m_tRandomGrid do
				if self.m_tRandomGrid[i][1] == nIndexX and self.m_tRandomGrid[i][2] == nIndexY then 
					bFind = false 
					break 
				end
			end
		end
		if bFind then 
			break 
		else
			nIndexX = math.random(1, HVMAP_ROW)
			nIndexY = math.random(1, HVMAP_ROW)
			if tCellRoleObj then
				local tGridData = tCellRoleObj:getRoleGridData()
				nIndexX = math.random(math.max(tGridData[1]-offset,0), math.min(tGridData[1]+offset,HVMAP_ROW))
				nIndexY = math.random(math.max(tGridData[2]-offset,0), math.min(tGridData[2]+offset,HVMAP_ROW))
			end
		end
	end

	return {nIndexX, nIndexY}
end

--@brief 	获取格子信息
function SceneHolidayVillage:GetGroundInfo(indexX, indexY)
	-- body
	local cellFloor = nil 
	if self.m_tGridList[indexX] and self.m_tGridList[indexX][indexY] then 
		cellFloor = {}
		cellFloor.isGoods = false 
		if self.m_tGridList[indexX][indexY].configId >= 0 then 
			cellFloor.isGoods = true
		end
	end

	return cellFloor
end

--@brief 	寻路
--@param 	nIndex : 1->Host, 2->Mate, 3->Kid1, 4->Kid2, 5->Visitor1, 6->Visitor2, 7->Visitor3
function SceneHolidayVillage:findPathFinish(tPathNode, nIndex)
	-- body
	if self.m_tRolePathNode == nil then self.m_tRolePathNode = {} end

	if tPathNode then 
		self.m_tRolePathNode[nIndex] = CopyTable(tPathNode)
		self.m_tIsRoleMove[nIndex] = true
--		WZLog("SceneHolidayVillage:findPathFinish", Serialize(tPathNode))
	end
end

--@brief 	开始寻路
function SceneHolidayVillage:startFindPath(targetX, targetY, roleIndex)
	-- body
	AStarPathfinding:SetRowAndColumnAmount(HVMAP_ROW, HVMAP_ROW)
	AStarPathfinding:SetTargetRowAndColumn(targetX, targetY)
	local tStartGrid = self.m_tRandomGrid[roleIndex]
	AStarPathfinding:SetStartPoint(tStartGrid[1], tStartGrid[2], roleIndex)
	AStarPathfinding:SetFunTable(SceneHolidayVillage)
	AStarPathfinding:SetFindFinishCallback(self, self.findPathFinish)
	AStarPathfinding:StartFindPath()
end

--@brief 	排序建筑，根据排序设置Z坐标
function SceneHolidayVillage:sortBuilding()
	-- body
	local tGridData = {}
	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].configId > 0 then 
				local tItem = {}
				local tBuildData = self.m_tGridList[i][j]
				tItem.configId = tBuildData.configId
				tItem.indexX = tBuildData.indexX
				tItem.indexY = tBuildData.indexY

				local nTempIndexX = tBuildData.indexX + tBuildData.basicData.size[1][1] - 1
				local nTempIndexY = tBuildData.indexY + tBuildData.basicData.size[1][2] - 1

				tItem.listSortIdMin = HVMAP_ROW - nTempIndexY
				tItem.lineSortIdMin = tItem.indexX
				tItem.listSortIdMax = HVMAP_ROW - tItem.indexY
				tItem.lineSortIdMax = nTempIndexX

				table.insert(tGridData, tItem)
			end
		end
	end
	--获取玩家和小孩的格子
--	WZLog("SceneHolidayVillage:sortBuilding", type(self.m_tCellHost))
	if self.m_tCellHost then
		local tItem = {}
		local tRoleGridData = self.m_tCellHost:getRoleGridData()
		if tRoleGridData then 
			tItem.configId = 9999999
			tItem.indexX = tRoleGridData[1]
			tItem.indexY = tRoleGridData[2]

			local nTempIndexX = tItem.indexX
			local nTempIndexY = tItem.indexY

			tItem.listSortIdMin = HVMAP_ROW - nTempIndexY
			tItem.lineSortIdMin = tItem.indexX
			tItem.listSortIdMax = HVMAP_ROW - tItem.indexY
			tItem.lineSortIdMax = nTempIndexX

			table.insert(tGridData, tItem)
		end
	end
	
	for i = 1, self.m_nMaxVisitorCount do
		if self.m_tCellVisitorRole and self.m_tCellVisitorRole[i] then
			local tItem = {}
			local tRoleGridData = self.m_tCellVisitorRole[i]:getRoleGridData()
			if tRoleGridData then 
				tItem.configId = 9999999 - i
				tItem.indexX = tRoleGridData[1]
				tItem.indexY = tRoleGridData[2]

				local nTempIndexX = tItem.indexX
				local nTempIndexY = tItem.indexY

				tItem.listSortIdMin = HVMAP_ROW - nTempIndexY
				tItem.lineSortIdMin = tItem.indexX
				tItem.listSortIdMax = HVMAP_ROW - tItem.indexY
				tItem.lineSortIdMax = nTempIndexX

				table.insert(tGridData, tItem)
			end
		end
	end
	
	for i = 1, self.m_nMaxSpiritCount do
		if self.m_tCellSpiritRoles and self.m_tCellSpiritRoles[i] then
			local tItem = {}
			local tRoleGridData = self.m_tCellSpiritRoles[i]:getRoleGridData()
			if tRoleGridData then 
				tItem.configId = 9999999 - self.m_nMaxVisitorCount - i
				tItem.indexX = tRoleGridData[1]
				tItem.indexY = tRoleGridData[2]

				local nTempIndexX = tItem.indexX
				local nTempIndexY = tItem.indexY

				tItem.listSortIdMin = HVMAP_ROW - nTempIndexY
				tItem.lineSortIdMin = tItem.indexX
				tItem.listSortIdMax = HVMAP_ROW - tItem.indexY
				tItem.lineSortIdMax = nTempIndexX

				table.insert(tGridData, tItem)
			end
		end
	end
	
--	WZLog("SceneHolidayVillage:sortBuilding", Serialize(tGridData))
	SceneHolidayVillage:FurnitureSort2(tGridData)
end

--对所有的物品排序显示
function SceneHolidayVillage:FurnitureSort2(cellList)
	local temp = {}
	for i, v in ipairs(cellList) do
		local tempTT = {}
		table.insert(tempTT,v.listSortIdMin)
		table.insert(tempTT,v.lineSortIdMin)
		table.insert(tempTT,v.listSortIdMax)
		table.insert(tempTT,v.lineSortIdMax)
		table.insert(temp,tempTT)
	end
	if #temp == 0 then
--		LogDebug("SceneHolidayVillage:FurnitureSort temp is nil 000000000000")
		return
	end
	table.sort(temp,function (a,b)
		for i,v in ipairs(temp) do
			if a[2] < b[2] then
				return true
			end
			return false
	    end
	end)

	table.sort(temp,function (a,b)
		for i,v in ipairs(temp) do
			if a[1] < b[1] then
				return true
			end
			return false
	    end
	end)

	--LogDebug("AAAAAAAAAAAAAAAAAAAAAA")
	BubbleSort(temp,function (a,b)
			local up = false
			local down = false
			local left = false 
			local right = false

			local aMinColumn = a[1]
			local aMaxColumn = a[3]
			local aMinRow = a[2]
			local aMaxRow = a[4]

			local bMinColumn = b[1]
			local bMaxColumn = b[3]
			local bMinRow = b[2]
			local bMaxRow = b[4]

			if aMinColumn > bMaxColumn then
				if aMaxRow <= bMaxRow and (aMaxRow <= bMaxRow and aMaxRow >= bMinRow) then --右上
				    right = true
				elseif aMinRow >= bMinRow and ( aMinRow >= bMinRow and  aMinRow <= bMaxRow ) then --右下
					right = true
				elseif aMaxRow >= bMaxRow and aMinRow <= bMinRow then 
					right = true
				end
			end

		    if aMaxColumn < bMinColumn  then
		    	if aMaxRow <= bMaxRow and (aMaxRow <= bMaxRow and aMaxRow >= bMinRow) then --左上
				    left = true
				elseif aMinRow >= bMinRow and ( aMinRow >= bMinRow and  aMinRow <= bMaxRow ) then --左下
					left = true
				elseif aMaxRow >= bMaxRow and aMinRow <= bMinRow then 
					left = true
				end
			end

			if aMaxRow < bMinRow and ((aMinColumn <= bMaxColumn and aMaxColumn >= bMinColumn ) or (aMinColumn > bMinColumn and aMaxColumn < bMaxColumn)) then
				up = true
			end

			if aMinRow > bMaxRow and ((aMinColumn <= bMaxColumn and aMaxColumn >= bMinColumn ) or (aMinColumn > bMinColumn and aMaxColumn < bMaxColumn)) then
				down = true
			end

			if up then
				--LogDebug("3334444444444444444444444up = " .. tostring(right) .. ":" ..tostring(left) .. ":" ..tostring(up)  .. ":" .. tostring(down) .. ":" .. a[5] .. aMinColumn .. aMinRow..aMaxColumn ..aMaxRow..  ":" .. b[5] .. bMinColumn .. bMinRow..bMaxColumn ..bMaxRow)
				return true
			end

			if down then
				--LogDebug("3334444444444444444444444down = " .. tostring(right) .. ":" ..tostring(left) .. ":" ..tostring(up)  .. ":" .. tostring(down) .. ":" .. a[5] .. aMinColumn .. aMinRow..aMaxColumn ..aMaxRow..  ":" .. b[5] .. bMinColumn .. bMinRow..bMaxColumn ..bMaxRow)
				return false
			end

			if left then
				--LogDebug("3334444444444444444444444left = " .. tostring(right) .. ":" ..tostring(left) .. ":" ..tostring(up)  .. ":" .. tostring(down) .. ":" .. a[5] .. aMinColumn .. aMinRow..aMaxColumn ..aMaxRow..  ":" .. b[5] .. bMinColumn .. bMinRow..bMaxColumn ..bMaxRow)
				return true
			end

			if right then
				--LogDebug("3334444444444444444444444right = " .. tostring(right) .. ":" ..tostring(left) .. ":" ..tostring(up)  .. ":" .. tostring(down) .. ":" .. a[5] .. aMinColumn .. aMinRow..aMaxColumn ..aMaxRow..  ":" .. b[5] .. bMinColumn .. bMinRow..bMaxColumn ..bMaxRow)
				return false
			end

			-- if aMinColumn >= bMaxColumn then
			-- 	return false
			-- else 
			-- 	return true
			-- end

			if aMinRow >= bMaxRow then --下方
				--LogDebug("3334444444444444444444444down = " .. tostring(right) .. ":" ..tostring(left) .. ":" ..tostring(up)  .. ":" .. tostring(down) .. ":" .. a[5] .. aMinColumn .. aMinRow..aMaxColumn ..aMaxRow..  ":" .. b[5] .. bMinColumn .. bMinRow..bMaxColumn ..bMaxRow)
				return false
			elseif aMaxRow <= bMinRow then --上方
				if aMaxColumn <= bMinColumn then --左上
					--LogDebug("3334444444444444444444444leftUp = " .. tostring(right) .. ":" ..tostring(left) .. ":" ..tostring(up)  .. ":" .. tostring(down) .. ":" .. a[5] .. aMinColumn .. aMinRow..aMaxColumn ..aMaxRow..  ":" .. b[5] .. bMinColumn .. bMinRow..bMaxColumn ..bMaxRow)
					return true
				else
					--LogDebug("3334444444444444444444444lup2 = " .. tostring(right) .. ":" ..tostring(left) .. ":" ..tostring(up)  .. ":" .. tostring(down) .. ":" .. a[5] .. aMinColumn .. aMinRow..aMaxColumn ..aMaxRow..  ":" .. b[5] .. bMinColumn .. bMinRow..bMaxColumn ..bMaxRow)
					return false
				end
			end
			return true
	    end)

	--LogDebug("kkkkkssssssssssssssssssssss = " .. Table2String(temp))
	--重新设置层级
	local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)

	for i,v in ipairs(temp) do
		for j,k in ipairs(cellList) do
			if k.listSortIdMin == v[1] and k.lineSortIdMin == v[2] and  k.listSortIdMax == v[3] and k.lineSortIdMax == v[4] then
				if k.configId > 0 then 
					if k.configId >= 9999999 - self.m_nMaxVisitorCount - self.m_nMaxSpiritCount and k.configId <= 9999999 then 
						if k.configId == 9999999 then 
							if self.m_tCellHost and self.m_tCellHost.m_root then
								self.m_tCellHost.m_root:setZOrder(i)
							end
						else
							local nIndexTemp = 9999999 - k.configId
							if nIndexTemp <= self.m_nMaxVisitorCount then
								if self.m_tCellVisitorRole and self.m_tCellVisitorRole[nIndexTemp] and self.m_tCellVisitorRole[nIndexTemp].m_root then
									self.m_tCellVisitorRole[nIndexTemp].m_root:setZOrder(i)
								end
							elseif nIndexTemp <= self.m_nMaxVisitorCount + self.m_nMaxSpiritCount then
								if self.m_tCellSpiritRoles and self.m_tCellSpiritRoles[nIndexTemp] and self.m_tCellSpiritRoles[nIndexTemp].m_root then
									self.m_tCellSpiritRoles[nIndexTemp].m_root:setZOrder(i)
								end
							end
						end
					else
						local nTag = (k.indexX - 1) * HVMAP_ROW + k.indexY
						local building = conForBuilding:getChildByTag(nTag)
						if building then 
							building:setZOrder(i)
						end
					end
				end
			end
		end
	end
end

--@brief 	获取一块可播种的土坑
function SceneHolidayVillage:getNullField()
	--初始化土地块数据
	for i = 1, #self.m_tConfigId do
		local indexX = self.m_tFieldPos[i][1]
		local indexY = self.m_tFieldPos[i][2]
		if self.m_tConfigId[i] == 1 then 
			if self.m_tGridList[indexX + 1][indexY + 1].fieldStatus > 0 and self.m_tGridList[indexX + 1][indexY + 1].plantId == 0 then 
				return indexX + 1, indexY + 1, self.m_tGridList[indexX + 1][indexY + 1]
			end
		end
	end
end

--@brief 	初始化数据
function SceneHolidayVillage:_initFieldData()
	self.m_tConfigId = {}
	self.m_tFieldPos = {} 
	self.m_tBuildingSize = {} 
	self.m_tBuildingPosition = {} 
	self.m_tBuildingAnimation = {} 

	local nIndex = 1
	for i, value in pairs(GDatatab_holiday_position) do
		if value.id < 16 then 
			self.m_tConfigId[value.id] = value.configid
			self.m_tFieldPos[value.id] = value.fieldpos[1]
			self.m_tBuildingSize[value.id] = value.buildingsize[1]
			self.m_tBuildingPosition[value.id] = value.buildingposition[1]
			self.m_tBuildingAnimation[value.id] = value.buildinganimation
		elseif value.id > 24 then 
			self.m_tConfigId[value.id - 9] = value.configid
			self.m_tFieldPos[value.id - 9] = value.fieldpos[1]
			self.m_tBuildingSize[value.id - 9] = value.buildingsize[1]
			self.m_tBuildingPosition[value.id - 9] = value.buildingposition[1]
			self.m_tBuildingAnimation[value.id - 9] = value.buildinganimation
		end
	end
end

--@brief 	获取神树信息
function SceneHolidayVillage:_getDivineInfo(lvl, exp, index, ids, endTimes)
	local bIsNeedUpdate = false 
	if self.m_tDivineTreeInfo then 
		if lvl ~= self.m_tDivineTreeInfo.level then 
			local curLvConfig = self:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
			local nextLvConfig = self:getDivineTreeConfigByLv(lvl)
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
end

--@brief 	获取神树等级配置
function SceneHolidayVillage:getDivineTreeConfigByLv(level)
	for i, value in pairs(GDatatab_holiday_tree_lvl) do
		if value.lvl == level then 
			return value
		end
	end
end

--@brief 	选择果实回调
function SceneHolidayVillage:_chooseFruit(opType, fruitId, index, itemId, num)
	if opType == 1 then 
		local fruitData = GDatatab_holiday_tree_fruit["id_" .. fruitId]
		self.m_tDivineTreeInfo.fruits[index + 1].fruitId = fruitId
		self.m_tDivineTreeInfo.fruits[index + 1].endTime = SystemTime:getServerTime() + fruitData.time
	elseif opType == 2 then 
		self.m_tDivineTreeInfo.fruits[index + 1].fruitId = 0
		self.m_tDivineTreeInfo.fruits[index + 1].endTime = 0
	end
end

--@brief 	加速果实/果树回调
function SceneHolidayVillage:_speedFruit(opType, itemId, itemNum, index)
	local basicData = GDatatab_item["id_" .. itemId]
	if opType == 1 then 
		-- local curLvConfig = self:getDivineTreeConfigByLv(self.m_tDivineTreeInfo.level)
		-- local addExp = math.floor(basicData.value * 1000/curLvConfig.exp[1][1]) * curLvConfig.exp[1][2]
		-- self.m_tDivineTreeInfo.curExp = self.m_tDivineTreeInfo.curExp + addExp 
		-- local maxLevel = WndHVDivineTree:getDivineTreeMaxLv()
		-- if self.m_tDivineTreeInfo.level < maxLevel and self.m_tDivineTreeInfo.curExp >= curLvConfig.max then 
		-- 	self.m_tDivineTreeInfo.level = self.m_tDivineTreeInfo.level + 1
		-- 	self.m_tDivineTreeInfo.curExp = self.m_tDivineTreeInfo.curExp - curLvConfig.max
		-- end
	elseif opType == 2 then 
	--	self.m_tDivineTreeInfo.fruits[index + 1].endTime = self.m_tDivineTreeInfo.fruits[index + 1].endTime - basicData.value
	end
end
-------------------------------------私有方法模块End----------------------------------------
