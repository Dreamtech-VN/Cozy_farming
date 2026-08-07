--SceneKidHomeData.lua
--@brief	SceneKidHome的数据模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小孩雇佣佣人界面

KID_MAP_SIZEX = 45
KID_MAP_SIZEY = 24
KID_MAP_ROW = 21
KID_MAP_WIDTH = KID_MAP_ROW * KID_MAP_SIZEX --21格子:945 42格子:1890
KID_MAP_HEIGHT = KID_MAP_ROW * KID_MAP_SIZEY --21格子:504  42格子:1008
KIDMAP_REAL_WIDTH = math.ceil(math.sqrt(KID_MAP_SIZEX*KID_MAP_SIZEX/4 + KID_MAP_SIZEY * KID_MAP_SIZEY/4))

SceneKidHome = {
	--请不要在这里定义变量
}


--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneKidHome:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sHomeName = nil  			--名字
	self.m_nComfirtValue = 0 			--舒适度
	self.m_nPlayerId = nil 
	self.m_tKidData = nil 				--孩子信息
	self.m_tTouchPoint = {} 
	self.m_startPoint = {}  
	self.m_nMaxScaleValue = 1.75
    self.m_nMinScaleValue = 1
    self.m_tOldPosition = {}
    self.m_tSceneLayer = nil 
    self.m_tPlayerLayer = nil 
    self.m_tGridList = nil 				--格子数据
    self.m_nTouchInBuildingState = 0 	--不在点击的建筑上
    self.m_clickInfo = nil 				--点击的建筑的信息
    self.m_bIsPtInBuilding = false 		--判断触摸点是否在建筑上
    self.m_bIsNewBuilding = false 		--是否处于新建建筑中
    self.m_nLoadingId = nil 
    self.m_nConceiveTime = 0			--怀孕剩余时间
    self.m_nServantTime = 0 			--佣人剩余时间
    self.m_tMateData = {} 				--伴侣形象数据
    self.m_tHostData = {} 				--主机的形象数据
    self.m_tCellHost = nil 				--主人节点表对象
    self.m_tCellMate = nil 		 		--伴侣节点表对象
    self.m_tCellShowTimePlayer = nil 		--显示怀孕时间的形象
    self.m_tCellServant = nil 			--佣人节点表对象
    self.m_bHavedServant = 0 		--是否有用人
    self.m_nMoveX = 0 
	self.m_nMoveY = 0 
	self.m_tShopData = nil 				--家具饰品商店数据
	self.m_tShopCallBack = nil 			--商店数据回调
	self.m_tUsingOrnaments = nil 		--使用中的饰品Id(窗户、地板、墙纸)
	self.m_nBorningKidId = nil 			--怀孕中或领养中的孩子Id
	self.m_nCareBuffToday = nil 		--今天是否获取过关爱buff 0否 1是
	self.m_tCellKidRole = nil 			--小孩形象
	self.m_tRandomGrid = nil 			--随机格子。用于随机角色，孩子的随机位置
	self.m_tIsRoleMove = {false, false, false, false, false, false} 			--是否在移动
	self.m_tRolePathNode = nil 			--路径点
	self.m_tRandomTime = nil 			--随机时间走动
	self.m_nTimeCaculate = 0 			--计时
	self.m_tKidRideData = nil 			--保存小孩骑摇摇车数据，用于排序
	self.m_tFloorData = nil 			--地板数据

	self.m_nMaxVisitorCount = 3			--拜访屋主的人最大数量
	self.m_tVisitorData = {} 			--拜访屋主的人数据
	self.m_tVisitingId = nil 			--屋主拜访的人id
	self.m_tVisitingTime = nil 			--屋主正在拜访时间
	self.m_tVisitorChild = {} 			--屋主拜访的人小孩数据
	self.m_tCellVisitorRole = {}		--拜访者形象
	self.m_nSingleVisitTime = 82800 	--单次拜访时长为23小时(82800秒)
	self.m_sIsChangeName = nil
	self.m_nExpansionStatus = 0			--扩建状态 0为扩建 1扩建到42
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneKidHome:_unInit()
	self.m_root = nil
	self.m_sHomeName = nil  			--名字
	self.m_nComfirtValue = nil 			--舒适度
	self.m_tKidData = nil 				--孩子信息
	self.m_tTouchPoint = nil
	self.m_startPoint = nil  
	self.m_nMaxScaleValue = nil
    self.m_nMinScaleValue = nil 
    self.m_tOldPosition = nil 
    self.m_tSceneLayer = nil 
    self.m_tPlayerLayer = nil 
    self.m_tGridList = nil 				--格子数据
    self.m_nTouchInBuildingState = nil 	--不在点击的建筑上
    self.m_clickInfo = nil 				--点击的建筑的信息
    self.m_bIsPtInBuilding = nil 		--判断触摸点是否在建筑上
    self.m_bIsNewBuilding = nil 		--是否处于新建建筑中
    self.m_nLoadingId = nil 
    self.m_nConceiveTime = nil			--怀孕剩余时间
    self.m_nServantTime = nil 			--佣人剩余时间
    self.m_tMateData = nil 				--伴侣形象数据
    self.m_tHostData = nil 				--主机的形象数据
    self.m_conHostPlayer = nil 			--男主人形象
    self.m_conMatePlayer = nil 	
    self.m_tCellShowTimePlayer = nil 		--显示怀孕时间的形象
    self.m_bHavedServant = nil 
    self.m_tCellServant = nil 			
    self.m_nMoveX = nil  
	self.m_nMoveY = nil  
	self.m_tShopData = nil 
	self.m_tShopCallBack = nil
	self.m_tUsingOrnaments = nil 
	self.m_nBorningKidId = nil 
	self.m_nCareBuffToday = nil
	self.m_tCellKidRole = nil
	self.m_tRandomGrid = nil 
	self.m_tIsRoleMove = nil 			--是否在移动
	self.m_tRolePathNode = nil 			--路径点
	self.m_tRandomTime = nil 			--随机时间走动
	self.m_nTimeCaculate = nil 
	self.m_tKidRideData = nil
	self.m_tFloorData = nil 

	self.m_nMaxVisitorCount = nil		--拜访屋主的人最大数量
	self.m_tVisitorData = nil 			--拜访屋主的人数据
	self.m_tVisitingId = nil 			--屋主拜访的人id
	self.m_tVisitingTime = nil 			--屋主正在拜访时间
	self.m_tVisitorChild = nil 			--屋主拜访的人小孩数据
	self.m_tCellVisitorRole = nil		--拜访者形象
	self.m_nSingleVisitTime = nil 		--单次拜访时长为23小时(82800秒)
	self.m_sIsChangeName = nil
	self.m_nExpansionStatus = nil		--扩建状态 0为扩建 1扩建到42
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneKidHome:createElement()
	if WZFileUtil:isFileExist("pack/family/pack_family_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/family/pack_family_0.plist")
    end
    if WZFileUtil:isFileExist("pack/kid/pack_kid_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/kid/pack_kid_0.plist")
    end
    self.m_createFlag = true

	local element = WZUISystem:getInstance():createElement("SceneKidHome")
	assert(element, "SceneKidHome create element failed!")
	self:_init()
	return element
end


--@brief 	外部接口
-- isChangeName: 是否跳入时装进行改性别和名字
function SceneKidHome:showInterface(playerId, isChangeName)
	-- body
	if self.m_root then 
		self.m_root:disableSchedule()
	end
	if playerId == nil or playerId == CacheCenter:getPlayerInfo().id then 
		if not CheckButtonOpen(145) then
			return
		end
	end
	local sceneHome = SceneKidHome:createElement()
	if sceneHome then
		self.m_nPlayerId = playerId or CacheCenter:getPlayerInfo().id
		replaceScene(sceneHome)
	end
	self.m_sIsChangeName = isChangeName or nil
end

--@brief 	设置家园数据
function SceneKidHome:setData(hostPlayerId, homeName, comfirtValue, nConceiveTime, nServantTime, bHavedServant, configId, flipStatus, indexX, indexY, decoration, playerId, playerName, sex, headId, faceId, bodyId
	, wingId, headColor, bodyColor, kidId, kidName, kidState, kidSex, kidLevel, kidHeadId, kidFaceId, kidBodyId, kidGrowValue, kidCareValue, kidPlayCar, kidNextCheckTime, careBuffToday, bearChildId, kidFight, kidProp, touch
	, visitorIds, visitorSexs, visitorNames, visitorFaceIds, visitorHeadIds, visitorHeadColors, visitorBodyIds, visitorBodyColors, visitorWingIds, visitorTimes, visitingId, visitingTime, visitingChildIds, visitingChildNames
	, visitingChildSexs, visitingChildLevels, visitingChildHeadIds, visitingChildFaceIds, visitingChildBodyIds, visitingChildFight, expansionStatus, kidHeadEffectId, visitorChildHeadEffectId)

	-- body
	self:_stopLoading()
	self.m_sHomeName = homeName  			--名字
	self.m_nComfirtValue = comfirtValue 			--舒适度
	self.m_nConceiveTime = nConceiveTime			--怀孕剩余时间
    self.m_nServantTime = nServantTime 			--佣人剩余时间
    self.m_bHavedServant = bHavedServant
    self.m_nCareBuffToday = careBuffToday 
    self.m_nBorningKidId = bearChildId

    --设置场景
    self.m_nExpansionStatus = expansionStatus
	self:setSceneUI()
    self:initScene()
	
	WZLog("SceneKidHome:setData *****", self.m_sHomeName, self.m_nComfirtValue, self.m_nConceiveTime, self.m_nServantTime, self.m_bHavedServant, Serialize(decoration), Serialize(configId), Serialize(visitorChildHeadEffectId))
	self.m_tUsingOrnaments = decoration
	self.m_tGridList = {} 				--格子数据
	for i = 1, KID_MAP_ROW do 
		self.m_tGridList[i] = {}
		for j = 1, KID_MAP_ROW do
			local tItem = {}
			tItem.configId = -1     --标记：-1->表示可以使用；0->表示不能使用；>0表示建筑物 
			tItem.flipStatus = 0 
			tItem.basicData = nil  	--建筑表数据
			tItem.basicInfo = nil 	--物品表数据
			tItem.indexX = i 
			tItem.indexY = j
			tItem.tempIndexX = i
			tItem.tempIndexY = j

			self.m_tGridList[i][j] = tItem 
		end
	end
	--设置角色站立区域为不能使用
--	self:setRoleStandArea(15, 0)
	
	for i = 1, #configId do
		self:setOneBuildingData(configId[i], flipStatus[i], indexX[i], indexY[i])
	end
	--主人数据
	for i = 1, #playerId do
		if playerId[i] == self.m_nPlayerId then
    		self.m_tHostData = {id = playerId[i], name = playerName[i], sex = sex[i], headId = headId[i], faceId = faceId[i], bodyId = bodyId[i], headColor = headColor[i], bodyColor = bodyColor[i], wingId = wingId[i]}
		else
			self.m_tMateData = {id = playerId[i], name = playerName[i], sex = sex[i], headId = headId[i], faceId = faceId[i], bodyId = bodyId[i], headColor = headColor[i], bodyColor = bodyColor[i], wingId = wingId[i]}
		end
	end
	WZLog("SceneKidHome:setData 2222222", Serialize(self.m_tHostData), Serialize(self.m_tMateData))
	--小孩数据
	self.m_tKidData = {}
	for i = 1, #kidId do
		local tItem = {}
		tItem.id = kidId[i]
		tItem.name = kidName[i]
		tItem.state = kidState[i]
		tItem.headId = kidHeadId[i]
		tItem.faceId = kidFaceId[i]
		tItem.bodyId = kidBodyId[i]
		tItem.sex = kidSex[i]
		tItem.level = kidLevel[i]
		tItem.happiness = kidGrowValue[i]
		tItem.careValue = kidCareValue[i]
		tItem.playCar = kidPlayCar[i]
		tItem.nextCheckTime = kidNextCheckTime[i]
		tItem.fighting = kidFight[i]
		tItem.property = kidProp[i]
		tItem.touch = touch[i]
		tItem.headEffectId = kidHeadEffectId[i]
	
		table.insert(self.m_tKidData, tItem)
	end
	table.sort(self.m_tKidData, function (a,b)
		-- body
		return a.id < b.id
	end)
	WZLog("SceneKidHome:setData 333333", Serialize(self.m_tKidData))

	--拜访屋主的人数据
	self.m_tVisitorData = {}
	for i=1,#visitorIds do
		local tVisitorData = {}
		tVisitorData.id = visitorIds[i]
		tVisitorData.sex = visitorSexs[i]
		tVisitorData.name = visitorNames[i]
		tVisitorData.faceId = visitorFaceIds[i]
		tVisitorData.headId = visitorHeadIds[i]
		tVisitorData.headColor = visitorHeadColors[i]
		tVisitorData.bodyId = visitorBodyIds[i]
		tVisitorData.bodyColor = visitorBodyColors[i]
		tVisitorData.wingId = visitorWingIds[i]
		tVisitorData.visitorTimes = visitorTimes[i]

		table.insert(self.m_tVisitorData, tVisitorData)
	end
	--屋主拜访的人数据
	self.m_tVisitingId = visitingId
	self.m_tVisitingTime = visitingTime
	--屋主拜访的人小孩数据
	self.m_tVisitorChild = {}
	for i=1,#visitingChildIds do
		local tVisitorChild = {}
		tVisitorChild.id = visitingChildIds[i]
		tVisitorChild.name = visitingChildNames[i]
		tVisitorChild.sex = visitingChildSexs[i]
		tVisitorChild.level = visitingChildLevels[i]
		tVisitorChild.headId = visitingChildHeadIds[i]
		tVisitorChild.faceId = visitingChildFaceIds[i]
		tVisitorChild.bodyId = visitingChildBodyIds[i]
		tVisitorChild.fighting = visitingChildFight[i]
		tVisitorChild.headEffectId = visitorChildHeadEffectId[i]

		table.insert(self.m_tVisitorChild, tVisitorChild)
	end
	table.sort(self.m_tVisitorChild, function (a,b)
		-- body
		return a.fighting > b.fighting
	end)


	--创建房子的物品
	self:_createBuilding()
	--创建装饰品
	self:_createOrnaments()
	--生成随机位置
	self.m_tIsRoleMove = {false, false, false, false, false, false}
	self:generateRandomGrid()
	--创建孩子、父母、佣人形象
	self:createAni()
	--显示操作界面
	WndKidOperate:showOtherInfo()
	--主人是否显示
	SceneKidHome:showHostRole()

	self.m_root:enableSchedule("roleAndKidMove",0)

	if self.m_sIsChangeName == true then
		WndKidManager:showInterface(6)
	end
end

--@brief 	获取当前数据索引
function SceneKidHome:getKidDataIndex(tData)
	-- body
	for i = 1, #self.m_tKidData do
		if self.m_tKidData[i] .id == tData.id then
			return i 
		end
	end
end

--@brief 	设置人物站立区域为占用区域
function SceneKidHome:setRoleStandArea(indexX, indexY)
	-- body
	self.m_tGridList[indexX + 1][indexY + 1].configId = 0 
	for k = indexX + 1, indexX + 6 do
		for j = indexY + 1, indexY + 6 do
			if k == indexX + 1 and j == indexY + 1 then
			else
				if self.m_tGridList[k] and self.m_tGridList[k][j] then
					self.m_tGridList[k][j].configId = 0
				end
			end
		end
	end
end


--@brief 	设置某一格数据
function SceneKidHome:setOneBuildingData(configId, flipStatus, indexX, indexY)
	-- body
	local tBasicData = GDatatab_house_building["id_" .. configId]
	local tBasicInfo = GDatatab_item["id_" .. configId]
	
	if not self.m_tGridList[indexX + 1] then
		return
	end

	self.m_tGridList[indexX + 1][indexY + 1].configId = configId 
	self.m_tGridList[indexX + 1][indexY + 1].flipStatus = flipStatus or 0
	self.m_tGridList[indexX + 1][indexY + 1].basicData = tBasicData
	self.m_tGridList[indexX + 1][indexY + 1].basicInfo = tBasicInfo
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


--@brief 	新建建筑成功
function SceneKidHome:buildNewBuildingOK(configId, x, y, flipStatus, fromSource)
	--body
	if self.m_root == nil then return end 

	self:_stopLoading()
	--更新该类建筑的数量
    -- if fromSource == 1 then
    -- 	self:updateBuildingNum(configId)
    -- end
	--清除掉新建层的临时建筑
	local tBasicData = GDatatab_house_building["id_" .. configId]
	if tBasicData.type == 4 then 
		local tData = {}
		tData.basicData = tBasicData
		self:_cleanBuildingInNewLayer(tData)
	else
		self:_cleanBuildingInNewLayer()
	end
	self.m_clickInfo = nil 
	--将新建的建筑添加到建筑层
	--如果是装饰
	if tBasicData.type == 2 or tBasicData.type == 3 or tBasicData.type == 4 or tBasicData.type == 5 or tBasicData.type == 6 then
		WZLog("SceneKidHome:buildNewBuildingOK 0000")
		self:_updateUsingOrnamentsData(configId, true)
		self:_createOrnaments()
		return 
	end
	
	WZLog("SceneKidHome:buildNewBuildingOK", configId, x, y, flipStatus)
	self:setOneBuildingData(configId, flipStatus, x, y)
	--建筑底部草地
    self:_createOneBuildingLawn(x + 1, y + 1)
	--将创建的建筑显示到地图上
	local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
	self:_createOneBuilding(x + 1, y + 1, -1, conForBuilding)

	self:resetRoleAndKidPos()
	self:sortBuilding()
end

--@brief 	移动建筑成功
function SceneKidHome:buildingMoveOK(xOrigin, yOrigin, xTarget, yTarget, flipStatus)
	-- body
	WZLog("SceneKidHome:buildingMoveOK",Serialize(xOrigin), Serialize(yOrigin), Serialize(xTarget), Serialize(yTarget), Serialize(flipStatus))
	if self.m_root == nil then return end 

	self:_stopLoading()
	WndKidOperate.m_bIsClickFunc = false

	--保存原数据
	local tOriginData = {}
	for i = 1, #xOrigin do
		local tTempData = CopyTable(self.m_tGridList[xOrigin[i] + 1][yOrigin[i] + 1])
		tTempData.flipStatus = flipStatus[i]
		tTempData.indexX = xTarget[i] + 1 
		tTempData.indexY = yTarget[i] + 1
		tTempData.tempIndexX = xTarget[i] + 1
		tTempData.tempIndexY = yTarget[i] + 1
		table.insert(tOriginData, tTempData)
	end

	local tCopyClickData
	if self.m_clickInfo and #tOriginData == 1 then
		tCopyClickData = CopyTable(self.m_clickInfo.tData)
	end
	--清楚原来格子数据
	local tTempCell
	local tBuildData 
	for i = 1, #xOrigin do
		if #tOriginData == 1 then
			local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
			local nTag = xOrigin[i] * KID_MAP_ROW + yOrigin[i] + 1
			local element = conForBuilding:getChildByTag(nTag)
			if element then
				tTempCell = element:getLuaObjectIndex()
				if tTempCell then
					tBuildData = CopyTable(tTempCell:getData())
				end
			end
		end
		self:cleanOneGridData(xOrigin[i], yOrigin[i])
	end
	--更新新数据
	for i = 1, #tOriginData do
		self:setOneBuildingData(tOriginData[i].configId, tOriginData[i].flipStatus, tOriginData[i].indexX - 1, tOriginData[i].indexY - 1)
		if self.m_clickInfo and #tOriginData == 1 and tCopyClickData and tCopyClickData.configId == tOriginData[i].configId then 
			self.m_clickInfo.tCell:resetBuildingData(self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY])
			local nTempX, nTempY = self:_getAbsPosition(tOriginData[i].indexX, tOriginData[i].indexY, self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY].basicData)
			self.m_clickInfo.tCell:setBuildFlipX(tOriginData[i].flipStatus)
            self.m_clickInfo.element:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
		--	self.m_clickInfo.element:setZOrder(self:getBuildZPoint(tOriginData[i].indexX, tOriginData[i].indexY, tOriginData[i].basicData))
			self.m_clickInfo.element:setTag((tOriginData[i].indexX - 1) * KID_MAP_ROW + tOriginData[i].indexY)
			WZLog("SceneKidHome:buildingMoveOK 99999", Serialize(self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY]))
			self.m_clickInfo.tData = self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY]
		elseif #tOriginData == 1 then
			if tTempCell then
				WZLog("buildingMoveOK UUUUUUU", tBuildData.configId, tOriginData[i].configId)
				if tBuildData and tBuildData.configId == tOriginData[i].configId then
					tTempCell:resetBuildingData(self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY])
					local nTempX, nTempY = self:_getAbsPosition(tOriginData[i].indexX, tOriginData[i].indexY, self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY].basicData)
					tTempCell:setBuildFlipX(tOriginData[i].flipStatus)
            		tTempCell.m_root:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
				--	tTempCell.m_root:setZOrder(self:getBuildZPoint(tOriginData[i].indexX, tOriginData[i].indexY, tOriginData[i].basicData))
					tTempCell.m_root:setTag((tOriginData[i].indexX - 1) * KID_MAP_ROW + tOriginData[i].indexY)
					WZLog("SceneKidHome:buildingMoveOK fffff", Serialize(self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY]))
				end
			end
		end
	end

	self:resetRoleAndKidPos()
	self:sortBuilding()
end

--@brief 	确认移除
function SceneKidHome:buildingRemoveOK(indexX, indexY, itemId)
	-- body
	WZLog("SceneKidHome:buildingRemoveOK")
	if self.m_root == nil then return end 
	self:_stopLoading()
	
	local tTempData = GDatatab_house_building["id_" .. itemId]

	local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
	local nTag = indexX * KID_MAP_ROW + indexY + 1
	local element = conForBuilding:getChildByTag(nTag)
	if element then
		tTempCell = element:getLuaObjectIndex()
		if tTempCell then
			tBuildData = CopyTable(tTempCell:getData())
			if tBuildData.configId == itemId then
				tTempCell.m_root:removeFromParentAndCleanup(true)
			end
		end
	end
	--刷新该建筑的状态
	if self.m_clickInfo and self.m_clickInfo.tCell then 
		if self.m_clickInfo.tData.configId == itemId then
			self.m_clickInfo = nil 
		end
	end
	WndKidOperate.m_bIsClickFunc = false

	if tTempData and tTempData.type == 1 then
		SceneKidHome:cleanBuildingLawn(indexX + 1, indexY + 1)
	    --清空相应地图数据
	    SceneKidHome:cleanOneGridData(indexX, indexY)
	else
		self:_updateUsingOrnamentsData(itemId, false)
		self:_createOrnaments()
	end
	--重新生成按钮类型
    WndKidOperate:onClickBuildingCallBack()
end

--@brief 	清楚某一格子建筑数据
function SceneKidHome:cleanOneGridData(indexX, indexY)
	-- body
	local tBasicData = self.m_tGridList[indexX + 1][indexY + 1].basicData
	if tBasicData then 
		for k = indexX + 1, indexX + tBasicData.size[1][1] do
			for j = indexY + 1, indexY + tBasicData.size[1][2] do
				self.m_tGridList[k][j].configId = -1
			end
		end
	end
	self.m_tGridList[indexX + 1][indexY + 1].configId = -1     --标记：-1->表示可以使用；0->表示不能使用；>0表示建筑物 
	self.m_tGridList[indexX + 1][indexY + 1].flipStatus = 0 
	self.m_tGridList[indexX + 1][indexY + 1].basicData = nil  	--建筑表数据
	self.m_tGridList[indexX + 1][indexY + 1].basicInfo = nil 	--物品表数据
	self.m_tGridList[indexX + 1][indexY + 1].indexX = indexX + 1
	self.m_tGridList[indexX + 1][indexY + 1].indexY = indexY + 1
	self.m_tGridList[indexX + 1][indexY + 1].tempIndexX = indexX + 1
	self.m_tGridList[indexX + 1][indexY + 1].tempIndexY = indexY + 1
end


--@brief 	新建建筑
--@param 	buildingId:建筑ID
--@param 	fromSource : 1->商店;2->背包
function SceneKidHome:buildNewBuilding(buildingId, fromSource)
	-- body
	WZLog("SceneKidHome:buildNewBuilding", buildingId)
	local conForNewBuild = GetElement(self.m_root, "conForNewBuild_kidSceneMap", WZUIContainer)
	self.m_bIsNewBuilding = true 
	--新建建筑的时候，如果之前选中了某个建筑，则取消选中
	if self.m_clickInfo then 
		self.m_clickInfo.tCell:setArrowVisible(false)
		self.m_clickInfo = nil 
	    WndKidOperate:onClickBuildingCallBack()
	end
	conForNewBuild:removeAllChildrenWithCleanup(true)

	local tGridData = {}
	local tBasicData = GDatatab_house_building["id_" .. buildingId]
	local tBasicInfo = GDatatab_item["id_" .. buildingId]
	local nIndexX, nIndexY = self:_getCanUseGridIndex(tBasicData)
	tGridData.configId = configId 
	tGridData.flipStatus = 0
	tGridData.basicData = tBasicData
	tGridData.basicInfo = tBasicInfo
	tGridData.indexX = nIndexX 
	tGridData.indexY = nIndexY
	tGridData.tempIndexX = nIndexX
	tGridData.tempIndexY = nIndexY
	tGridData.fromSource = fromSource

	--地砖
	if tBasicData.type == 6 then 
		self:_initMap(buildingId)
		self.m_tFloorData = tGridData
		MsgBoxManager:showConfirmBox(string.format(LocalStrings.KID_HOME_TEXT1, tBasicData.name), self, self.toBuyFloorAndUse, nil, nil, nil, nil, nil, self.cancelToBuyOrUseFloor)
		return 
	end

	local bCanPut = self:_judgeCanPutBuilding(nIndexX, nIndexY, tBasicData)
	if conForNewBuild then
		local celElement, tNewObj = CellKidBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(tGridData)
            tNewObj:setBuildNewBtnVisible(true)
            tNewObj:setArrowVisible(true)
            if not bCanPut then 
            	tNewObj:setSureState(false)
            	tNewObj:setBuildingBG(2)
            else
            	tNewObj:setBuildingBG(1)
            end

            self.m_clickInfo = {}
            self.m_clickInfo.element = celElement
		    self.m_clickInfo.tCell = tNewObj
		    self.m_clickInfo.tData = tGridData

            celElement:setUseAbsCoordinate(true)
		    if tBasicInfo.sub_type == 3 then  --窗户
		    	tGridData.indexX = 0 
				tGridData.indexY = 0
				tGridData.tempIndexX = 0
				tGridData.tempIndexY = 0
				local nTempX, nTempY = 716,415
			    if self.m_nExpansionStatus == 1 then
			        nTempX, nTempY = 1356, 815
			    end
				tNewObj:setBuildingBG(-1)
				tNewObj:setSureState(true)
	            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
		    elseif tBasicInfo.sub_type == 4 then --饰品
		    	tGridData.indexX = 0 
				tGridData.indexY = 0
				tGridData.tempIndexX = 0
				tGridData.tempIndexY = 0
				local nTempX, nTempY = 600, 480
			    if self.m_nExpansionStatus == 1 then
			        nTempX, nTempY = 1233, 911
			    end
				tNewObj:setBuildingBG(-1)
				tNewObj:setSureState(true)
	            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
		    elseif tBasicInfo.sub_type == 5 then --墙壁
		    	tGridData.indexX = 0 
				tGridData.indexY = 0
				tGridData.tempIndexX = 0
				tGridData.tempIndexY = 0
				local nTempX, nTempY = 150, 380
			    if self.m_nExpansionStatus == 1 then
			        nTempX, nTempY = 500, 900
			    end
				tNewObj:setBuildingBG(-1)
				tNewObj:setSureState(true)
	            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
	            self:_updateGrassAndWall(buildingId)
		    elseif tBasicInfo.sub_type == 6 then --花坛
		    	tGridData.indexX = 0 
				tGridData.indexY = 0
				tGridData.tempIndexX = 0
				tGridData.tempIndexY = 0
				local nTempX, nTempY = 700, 400
			    if self.m_nExpansionStatus == 1 then
			        nTempX, nTempY = 480, 300
			    end
				tNewObj:setBuildingBG(-1)
				tNewObj:setSureState(true)
	            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
	            self:_updateGrassAndWall(buildingId)
	            local background = GetElement(self.m_root, "background", WZUIContainer)
	            if background:getChildByTag(1155) then 
	            	background:removeChildByTag(1155, true)
	            end
	            celElement:setZOrder(2)
	            celElement:setTag(1155)
	            background:addChild(celElement)
	            return 
			else
	            local nTempX, nTempY = self:_getAbsPosition(tGridData.indexX, tGridData.indexY, tGridData.basicData)
	            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
	            celElement:setZOrder(self:getBuildZPoint(tGridData.indexX, tGridData.indexY, tGridData.basicData))
		    end
	        conForNewBuild:addChild(celElement)
        end
	end
end

--@brief 	判断触摸点是否在建筑内
function SceneKidHome:judgePtInBuilding(tData)
	-- body
	if self.m_clickInfo and self.m_clickInfo.tData.configId == tData.configId and self.m_clickInfo.tData.indexX == tData.indexX and self.m_clickInfo.tData.indexY == tData.indexY then
		self.m_bIsPtInBuilding = true
	end
	WZLog("SceneKidHome:judgePtInBuilding", self.m_bIsPtInBuilding)
end

--@brief 	佣人或怀孕或领养倒计时完成后的处理
function SceneKidHome:dealwithFinishTime(nType)
	-- body
	if self.m_root == nil then return end 

	--佣人倒计时用完，移除佣人
	if nType == 1 then --佣人
		local conForServant = GetElement(self.m_root, "conForServant_kidSceneMap", WZUIContainer)
		if conForServant then 
    		conForServant:removeAllChildrenWithCleanup(true)
    	end
	else
		--怀孕倒计时完成，获取小孩数据，显示小孩
		self:_createLoading()
		ProtocolProcessorKid:send_WEDDING_GetChildStatus(self.m_nBorningKidId)
	end
end

--@brief 	获取建筑和饰品商店数据成功
function SceneKidHome:getBuildingsAndOrnaments(itemId, cost, buyNum, limitNum)
	-- body
	WZLog("SceneKidHome:getBuildingsAndOrnaments", Serialize(cost))
	self:_stopLoading()

	self.m_tShopData = {}
	for i = 1, #itemId do
		local tItem = {}

		tItem.itemId = itemId[i]
		tItem.cost = cost[i]
		tItem.buyNum = buyNum[i]
		tItem.limitNum = limitNum[i]
		tItem.buildingData = GDatatab_house_building["id_" .. tItem.itemId]

		table.insert(self.m_tShopData, tItem)
	end

	if self.m_tShopCallBack then
		if self.m_tShopCallBack[1] then
			self.m_tShopCallBack[2](self.m_tShopCallBack[1], self.m_tShopData, self.m_tShopCallBack[3])
			self.m_tShopCallBack = {}
		end
	end
end

--@brief 	获取家具饰品商店数据
function SceneKidHome:getBuildingAndOrnamentsData(tCell, func, nType)
	-- body
	self.m_tShopCallBack = {}
	self.m_tShopCallBack[1] = tCell
	self.m_tShopCallBack[2] = func
	self.m_tShopCallBack[3] = nType

	self.m_tShopData = nil 
	if self.m_tShopData == nil or #self.m_tShopData == 0 then
		self:_createLoading()
		ProtocolProcessorKid:send_WEDDING_GetHouseBuildingStore( )
	else
		self.m_tShopCallBack[2](self.m_tShopCallBack[1], self.m_tShopData, self.m_tShopCallBack[3])
		self.m_tShopCallBack = {}
	end
end

--@brief	刷新建筑购买数量
function SceneKidHome:updateBuildingNum(configId)
	-- body
	if self.m_tShopData == nil then return end 
	for i = 1, #self.m_tShopData do
		if self.m_tShopData[i].itemId == configId then
			self.m_tShopData[i].buyNum = self.m_tShopData[i].buyNum + 1
			break 
		end
	end
end

--@brief 	怀孕或领养成功后显示倒计时
function SceneKidHome:showBornTime(leftTime, kidId)
	-- body
	if self.m_root == nil then return end 

	self.m_nConceiveTime = leftTime
	self.m_nBorningKidId = kidId
	if self.m_tCellShowTimePlayer then
		self.m_tCellShowTimePlayer:setShowConceiveTime()
	end
end

--@brief 	雇佣佣人后更新孩子数据
function SceneKidHome:updateKidDataWithServant(bearLastTime, childId, childStatus, growthValue)
	-- body
	if self.m_root == nil then return end 

	if self.m_nConceiveTime > 0 and bearLastTime <= 0 then
		--怀孕会领养倒计时完成，发送获取孩子数据协议
		self:_createLoading()
		ProtocolProcessorKid:send_WEDDING_GetChildStatus(self.m_nBorningKidId)
	elseif bearLastTime > 0 then
		self.m_nConceiveTime = bearLastTime
	end
	if self.m_tKidData and #self.m_tKidData > 0 then
		for i = 1, #self.m_tKidData do
			for k = 1, #childId do
				if self.m_tKidData[i].id == childId[k] then
					self.m_tKidData[i].state = childStatus[k]
					self.m_tKidData[i].happiness = growthValue[k]

					break 
				end
			end
		end
	end
	--更新孩子数据显示

end

--@brief 	雇佣佣人后更新孩子数据
function SceneKidHome:updateKidData(childId, childName, childStatus, childSex, childLevel, childHeadId, childFaceId, childBodyId, growthValue, careValue, playCar, nextCheckTime, childFight, childProp, touch, headEffectId)
	-- body
	if self.m_root == nil then return end 

	local bExist = false 
	self:_stopLoading()
	if self.m_tKidData == nil then return end 

	for i = 1, #self.m_tKidData do
		if self.m_tKidData[i].id == childId then
			if childName then
				self.m_tKidData[i].name = childName
			end
			if childStatus then
				self.m_tKidData[i].state = childStatus
				if self.m_tCellKidRole and self.m_tCellKidRole[i] then
					self.m_tCellKidRole[i]:setKidState(childStatus)
				end
			end

			if childHeadId then
				self.m_tKidData[i].headId = childHeadId
				if self.m_tCellKidRole and self.m_tCellKidRole[i] then
					self.m_tCellKidRole[i]:resetDress(childHeadId)
				end
			end
			if childFaceId then
				self.m_tKidData[i].faceId = childFaceId
				if self.m_tCellKidRole and self.m_tCellKidRole[i] then
					self.m_tCellKidRole[i]:resetDress(childFaceId)
				end
			end
			if childBodyId then
				self.m_tKidData[i].bodyId = childBodyId
				if self.m_tCellKidRole and self.m_tCellKidRole[i] then
					self.m_tCellKidRole[i]:resetDress(childBodyId)
				end
			end
			if childSex then
				self.m_tKidData[i].sex = childSex
			end
			if childLevel then
				self.m_tKidData[i].level = childLevel
			end
			if growthValue then
				self.m_tKidData[i].happiness = growthValue
			end
			if careValue then
				self.m_tKidData[i].careValue = careValue
			end
			if playCar then
				self.m_tKidData[i].playCar = playCar
			end
			if nextCheckTime then
				self.m_tKidData[i].nextCheckTime = nextCheckTime
			end
			if childFight then
				self.m_tKidData[i].fighting = childFight
			end
			if childProp then
				self.m_tKidData[i].property = childProp
			end
			if touch then
				self.m_tKidData[i].touch = touch
			end
			if headEffectId then
				self.m_tKidData[i].headEffectId = headEffectId
			end

			bExist = true
			WndKidOperate:updateKidInfoShow(self.m_tKidData[i], i)
			WndParentsCare:updateKidInfoShow(self.m_tKidData[i], i)
			WndKidFeed:updateGrowValue(self.m_tKidData[i], i)
			WndKidDress:updateKidDressAni()
			if self.m_tCellKidRole and self.m_tCellKidRole[i] then
				self.m_tCellKidRole[i]:resetData(self.m_tKidData[i])
			end
			break 
		end
	end

	if not bExist then
		local tItem = {}
		tItem.id = childId
		tItem.name = childName
		tItem.state = childStatus
		tItem.headId = childHeadId
		tItem.faceId = childFaceId
		tItem.bodyId = childBodyId
		tItem.sex = childSex
		tItem.level = childLevel
		tItem.happiness = growthValue
		tItem.careValue = careValue
		tItem.playCar = playCar
		tItem.nextCheckTime = nextCheckTime
		tItem.fighting = childFight
		tItem.property = childProp
		tItem.touch = touch
		tItem.headEffectId = headEffectId or 0
	
		table.insert(self.m_tKidData, tItem)

		WndKidOperate:createKidInfo(tItem, #self.m_tKidData)
		--创建新小孩形象
		SceneKidHome:createKidAni()
		self:sortBuilding()
	end
end

--@brief 	更新舒适度
function SceneKidHome:updateComfirtValue(comfirtValue)
	-- body
	if self.m_root == nil then return end 

	self.m_nComfirtValue = comfirtValue 			--舒适度

	WndKidOperate:showComfirtValue()
end

--@brief 	哭，饿、尿裤子
function SceneKidHome:kidStateOperateSuccess(childId, actionType, childStatus, growthValue)
	-- body
	SceneKidHome:_stopLoading()
	
	WZLog("SceneKidHome:kidStateOperateSuccess", childId, actionType, childStatus, growthValue)
	if actionType == 1 then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT101)
		SceneKidHome:updateKidData(childId, nil, childStatus, nil, nil, nil, nil, nil, growthValue, nil, nil, nil)
	elseif actionType == 2 then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT102)
		SceneKidHome:updateKidData(childId, nil, childStatus, nil, nil, nil, nil, nil, growthValue, nil, nil, nil)
	elseif actionType == 3 then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT103)
		SceneKidHome:updateKidData(childId, nil, childStatus, nil, nil, nil, nil, nil, growthValue, nil, nil, nil)
	elseif actionType == 4 then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT248)
		SceneKidHome:updateKidData(childId, nil, childStatus, nil, nil, nil, nil, nil, growthValue, nil, nil, nil)
		--刷新场景
		ProtocolProcessorKid:send_WEDDING_GetHouseInfo(self.m_nPlayerId)
	end
end

--@brief 	播放骑马动画
function SceneKidHome:playKidMount(childId, actionType, careValue, nIndexX, nIndexY)
	-- body
	if self.m_root == nil then return end 
	if self.m_tCellKidRole == nil then return end 

	--隐藏底部功能按钮
	if self.m_clickInfo and self.m_clickInfo.tData.configId == 50003 and self.m_clickInfo.tData.indexX == nIndexX and self.m_clickInfo.tData.indexY == nIndexY then
        self.m_clickInfo.tCell:setArrowVisible(false)
        self:_createOneBuildingLawn(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tCell)
        self.m_clickInfo = nil 
        WndKidOperate:onClickBuildingCallBack()
    end

	for i = 1, #self.m_tCellKidRole do
		local tData = self.m_tCellKidRole[i]:getData()
		if tData.id == childId then
			local tGridData = self.m_tGridList[nIndexX][nIndexY]
			local flipStatus = 1
			if tGridData then
				flipStatus = tGridData.flipStatus
			end

			local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)

			local nTag = (nIndexX -1) * KID_MAP_ROW + nIndexY
			local element = conForBuilding:getChildByTag(nTag)
			local tTempCellCur 
			if element then
				local tTempCell = element:getLuaObjectIndex()
				if tTempCell then
					local tBuildData = CopyTable(tTempCell:getData())
					if tBuildData.configId == 50003 then
						tTempCellCur = tTempCell
						element:setVisible(false)
					end
				end
			end
			self.m_tCellKidRole[i]:playMountAni(flipStatus, tTempCellCur)
			--将位置设置到所选摇摇车的位置
			local tTempData = GDatatab_house_building["id_50003"]

            local nAbsX, nAbsY = self:_getAbsPosition(nIndexX, nIndexY, tTempData)
            self.m_tCellKidRole[i].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY - tTempData.size[1][2]*KID_MAP_SIZEY/2 + 10))

            if self.m_tKidRideData == nil then 
            	self.m_tKidRideData = {}
            end
            table.insert(self.m_tKidRideData, {childId, nIndexX, nIndexY, tTempData})
			break 
		end
	end

	self:sortBuilding()
end

--@brief 	抚摸成功
function SceneKidHome:touchKidSuccess(childId, actionType, careValue, nIndexX, nIndexY, playCar, touch)
	-- body
	if self.m_root == nil then return end 

	SceneKidHome:_stopLoading()
	if actionType == 1 then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT117)
		self:updateKidData(childId, nil, nil, nil, nil, nil, nil, nil, nil, careValue, playCar, nil, nil, nil, touch)
		self:playKidTouchAni(childId)
	end
end

--@brief 	抚摸后回调
function SceneKidHome:playKidTouchAni(childId)
	-- body
	if self.m_root == nil then return end 
	if self.m_tCellKidRole == nil then return end 

	for i = 1, #self.m_tCellKidRole do
		local tData = self.m_tCellKidRole[i]:getData()
		if tData.id == childId then
			self.m_tCellKidRole[i]:playSmileAfterTouch()
			break 
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	根据格子X,Y索引，计算绝对坐标
--@param 	tBasicData:建筑表数据
function SceneKidHome:_getAbsPosition(indexX, indexY, tBasicData)	-- body
	local gapX = KID_MAP_SIZEX / 2 
    local gapY = KID_MAP_SIZEY / 2 

    local tData = tBasicData
    local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEX
    local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEY
    local startX = 0 + (indexX - 1) * gapX
    local startY = KID_MAP_HEIGHT / 2 - (indexX - 1) * gapY
    local nAbsPointX = startX + indexY * gapX - gapX + nConWidth/2
    local nAbsPointY = startY + (indexY - 1) * gapY

    return nAbsPointX, nAbsPointY
end

--@brief 	根据格子索引，计算层级
function SceneKidHome:getBuildZPoint(nIndexX, nIndexY, tBasicData)
	-- body
	-- local nTempX, nTempY = self:_getAbsPosition(nIndexX, nIndexY, tBasicData)
	-- return math.floor(KID_MAP_HEIGHT * 2 - nTempY - nTempX/KID_MAP_SIZEX)

	-- local nTempIndexX = nIndexX + tBasicData.size[1][1] - 1
	-- local nTempIndexY = nIndexY
	-- WZLog("SceneKidHome:getBuildZPoint", tBasicData.name, nIndexX, nIndexY, nTempIndexX, nTempIndexY)
	-- return 2000 - (KID_MAP_ROW - nTempIndexX )*100 - (nTempIndexY)
	local nTempIndexX = nIndexX + tBasicData.size[1][1] - 1
	local nTempIndexY = nIndexY + tBasicData.size[1][2] - 1
	WZLog("SceneKidHome:getBuildZPoint", tBasicData.name, nIndexX, nIndexY, nTempIndexX, nTempIndexY)
	return  nTempIndexX + (KID_MAP_ROW - nTempIndexY) * 100
end

--@brief 	计算两点之间的距离
function SceneKidHome:pointDis(tPoint1, tPoint2)
    if tPoint1 == nil or tPoint2 == nil then
        return nil
    end
	return math.sqrt( (tPoint1.x - tPoint2.x) * (tPoint1.x - tPoint2.x ) + (tPoint1.y - tPoint2.y) * (tPoint1.y - tPoint2.y ) )
end

--@brief 	判断当前移动所在的位置范围内是否有已经被占用的格子
--@param 	indexX:格子横向索引
--@param 	indexY:格子纵向索引
--@param 	tBasicData:建筑表数据
--@brief 	tData:建筑数据
function SceneKidHome:_judgeCanPutBuilding(indexX, indexY, tBasicData, tData)
	-- body
	local bCanPut = true 
	if tBasicData.type == 2 or tBasicData.type == 3 or tBasicData.type == 4 or tBasicData.type == 5 or tBasicData.type == 6 then return end 

	for i = indexX, indexX + tBasicData.size[1][1] - 1 do
		for j = indexY, indexY + tBasicData.size[1][2] - 1 do
			if self.m_tGridList == nil or self.m_tGridList[i] == nil or self.m_tGridList[i][j] == nil then
				bCanPut = false 
				break 
			elseif self.m_tGridList[i][j].configId >= 0 then 
				if tData and not self.m_bIsNewBuilding then 
					if i >= tData.indexX and i <= tData.indexX + tBasicData.size[1][1] - 1 and j >= tData.indexY and j <= tData.indexY + tBasicData.size[1][2] - 1 then 
						--如果占用的是原来所在的区域，不处理
					else
						bCanPut = false 
						break 
					end
				else
					bCanPut = false 
					break 
				end
			end
		end
		if not bCanPut then 
			break 
		end
	end

	-- if bCanPut then
	-- 	for i = indexX, indexX + tBasicData.size[1][1] - 1 do
	-- 		for j = indexY, indexY + tBasicData.size[1][2] - 1 do
	-- 			if i >= 16 and j <= 6 then 
	-- 				bCanPut = false 
	-- 				WndKidOperate.m_bIsClickFunc = false
	-- 				return bCanPut 
	-- 			end
	-- 		end
	-- 	end
	-- end

	return bCanPut
end

--@brief    数据加载动画
function SceneKidHome:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function SceneKidHome:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 	清除掉新建层中的建筑
function SceneKidHome:_cleanBuildingInNewLayer(tData)
	-- body
	local conForNewBuild = GetElement(self.m_root, "conForNewBuild_kidSceneMap", WZUIContainer)
	conForNewBuild:removeAllChildrenWithCleanup(true)
	self.m_bIsNewBuilding = false 
	if tData then 
		if tData.basicData.type == 4 then --花坛
			local background = GetElement(self.m_root, "background", WZUIContainer)
			if background:getChildByTag(1155) then 
				background:removeChildByTag(1155, true)
			end

			local itemId = 50023 

			for i = 1, #self.m_tUsingOrnaments do
				if self.m_tUsingOrnaments[i] > 0 then
					local tBasicData2 = GDatatab_house_building["id_" .. self.m_tUsingOrnaments[i]]
					if tData.basicData.type == tBasicData2.type then
						itemId = self.m_tUsingOrnaments[i]
						break 
					end
				end
			end

			self:_updateGrassAndWall(itemId)
		elseif tData.basicData.type == 5 then --墙壁
			local itemId = 50019 

			for i = 1, #self.m_tUsingOrnaments do
				if self.m_tUsingOrnaments[i] > 0 then
					local tBasicData2 = GDatatab_house_building["id_" .. self.m_tUsingOrnaments[i]]
					if tData.basicData.type == tBasicData2.type then
						itemId = self.m_tUsingOrnaments[i]
						break 
					end
				end
			end

			self:_updateGrassAndWall(itemId)
		elseif tData.basicData.type == 6 then --地板
			local itemId = 50034 

			for i = 1, #self.m_tUsingOrnaments do
				if self.m_tUsingOrnaments[i] > 0 then
					local tBasicData2 = GDatatab_house_building["id_" .. self.m_tUsingOrnaments[i]]
					if tData.basicData.type == tBasicData2.type then
						itemId = self.m_tUsingOrnaments[i]
						break 
					end
				end
			end

			self:_initMap(itemId)
		end
	end
end

--@brief 	新建时候，返回离中间最近的可用的格子
function SceneKidHome:_getCanUseGridIndex(tBasicData)
	-- body
	local mainIndexX, mainIndexY = 10, 10
	local bIsFound = false 
	local nIndexX = nil 
	local nIndexY = nil 
	local nAdditionNum = 0 

	while not bIsFound do
		--上
		local nStartFindX = mainIndexX - (tBasicData.size[1][1] + nAdditionNum)
		if nStartFindX > 0 then 
			local nStartFindY = mainIndexY
			local nMaxY = mainIndexY + nAdditionNum
			if nMaxY > KID_MAP_ROW then 
				nMaxY = KID_MAP_ROW 
			end
			for i = nStartFindY, nMaxY do
				local bCanPut = self:_judgeCanPutBuilding(nStartFindX, i, tBasicData)
				if bCanPut then 
					nIndexX = nStartFindX
					nIndexY = i
					bIsFound = true
					break 
				end
			end
		end
		--下
		nStartFindX = mainIndexX + (nAdditionNum)
		if nStartFindX + tBasicData.size[1][1] <= KID_MAP_ROW then 
			local nStartFindY = mainIndexY - (1 + nAdditionNum)
			if nStartFindY < 1 then 
				nStartFindY = 1 
			end
			for i = nStartFindY, nStartFindY - 1 do
				local bCanPut = self:_judgeCanPutBuilding(nStartFindX, i, tBasicData)
				if bCanPut then 
					nIndexX = nStartFindX
					nIndexY = i
					bIsFound = true
					break 
				end
			end
		end
		--左
		local nStartFindY = mainIndexY - (tBasicData.size[1][2] + nAdditionNum)
		if nStartFindY > 0 then 
			nStartFindX = mainIndexX - (1 + nAdditionNum)
			if nStartFindX < 1 then 
				nStartFindX = 1 
			end
			for i = nStartFindX, nStartFindX do
				local bCanPut = self:_judgeCanPutBuilding(i, nStartFindY, tBasicData)
				if bCanPut then 
					nIndexX = i
					nIndexY = nStartFindY
					bIsFound = true
					break 
				end
			end
		end
		--右
		local nStartFindY = mainIndexY + (nAdditionNum)
		if nStartFindY + tBasicData.size[1][2] - 1 <= KID_MAP_ROW then 
			nStartFindX = mainIndexX
			local nMaxX = mainIndexX + nAdditionNum
			if nMaxX > KID_MAP_ROW then 
				nMaxX = KID_MAP_ROW 
			end
			for i = nStartFindX, nMaxX do
				local bCanPut = self:_judgeCanPutBuilding(i, nStartFindY, tBasicData)
				if bCanPut then 
					nIndexX = i
					nIndexY = nStartFindY
					bIsFound = true
					break 
				end
			end
		end
		nAdditionNum = nAdditionNum + 1
		if nAdditionNum >= KID_MAP_ROW/2 + 1 then 
			break
		end
	end

	if not nIndexX or not nIndexY then 
		nIndexX = KID_MAP_ROW/2
		nIndexY = KID_MAP_ROW/2
	end

	return nIndexX,nIndexY
end

--@brief 	刷新装饰数据
function SceneKidHome:_updateUsingOrnamentsData(configId, bAdd)
	-- body
	if self.m_tUsingOrnaments == nil then self.m_tUsingOrnaments = {} end

	local tBasicData = GDatatab_house_building["id_" .. configId]
	if bAdd then
		local bExist = false 
		for i = 1, #self.m_tUsingOrnaments do
			if self.m_tUsingOrnaments[i] > 0 then
				local tBasicData2 = GDatatab_house_building["id_" .. self.m_tUsingOrnaments[i]]
				if tBasicData.type == tBasicData2.type then
					bExist = true
					self.m_tUsingOrnaments[i] = configId
					break 
				end
			end
		end
		if not bExist then
			table.insert(self.m_tUsingOrnaments, configId)
		end
	else
		for i = 1, #self.m_tUsingOrnaments do
			if self.m_tUsingOrnaments[i] > 0 then
				local tBasicData2 = GDatatab_house_building["id_" .. self.m_tUsingOrnaments[i]]
				if tBasicData.type == tBasicData2.type then
					table.remove(self.m_tUsingOrnaments, i)
					break 
				end
			end
		end
	end
end

--@brief 	将一个证书转化为位数组
function SceneKidHome:_NumberToBits(n, nCount)
    local tBits = {}

    while n >= 0 and #tBits < nCount do
        table.insert(tBits, math.fmod(n, 2))
        n = math.floor(n/2)
    end

    return tBits
end

--@brief 	判断墙上是否存在相同的饰品
function SceneKidHome:bIsExistTheSameOrnaments(itemId)
	-- body
	local bIsExist = false 
	if self.m_tUsingOrnaments == nil or GetTableLen(self.m_tUsingOrnaments) == 0 then return bIsExist end

	for i, value in pairs(self.m_tUsingOrnaments) do
		if self.m_tUsingOrnaments[i] == itemId then
			bIsExist = true
			break 
		end
	end

	return bIsExist
end

--对所有的物品排序显示
function SceneKidHome:FurnitureSort2(cellList)
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
--		LogDebug("SceneKidHome:FurnitureSort temp is nil 000000000000")
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
	local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)

	for i,v in ipairs(temp) do
		for j,k in ipairs(cellList) do
			if k.listSortIdMin == v[1] and k.lineSortIdMin == v[2] and  k.listSortIdMax == v[3] and k.lineSortIdMax == v[4] then
				if k.configId > 0 then 
					if k.configId >= 9999993 and k.configId <= 9999999 then 
						if k.configId == 9999999 then 
							if self.m_tCellHost and self.m_tCellHost.m_root then
								self.m_tCellHost.m_root:setZOrder(i)
							end
						elseif k.configId == 9999998 then 
							if self.m_tCellMate and self.m_tCellMate.m_root then
								self.m_tCellMate.m_root:setZOrder(i)
							end
						elseif k.configId == 9999997 then 
							if self.m_tCellKidRole and self.m_tCellKidRole[1] and self.m_tCellKidRole[1].m_root then
								self.m_tCellKidRole[1].m_root:setZOrder(i)
							end
						elseif k.configId == 9999996 then 
							if self.m_tCellKidRole and self.m_tCellKidRole[2] and self.m_tCellKidRole[2].m_root then
								self.m_tCellKidRole[2].m_root:setZOrder(i)
							end
						elseif k.configId == 9999995 then 
							if self.m_tCellVisitorRole and self.m_tCellVisitorRole[1] and self.m_tCellVisitorRole[1].m_root then
								self.m_tCellVisitorRole[1].m_root:setZOrder(i)
							end
						elseif k.configId == 9999994 then 
							if self.m_tCellVisitorRole and self.m_tCellVisitorRole[2] and self.m_tCellVisitorRole[2].m_root then
								self.m_tCellVisitorRole[2].m_root:setZOrder(i)
							end
						elseif k.configId == 9999993 then 
							if self.m_tCellVisitorRole and self.m_tCellVisitorRole[3] and self.m_tCellVisitorRole[3].m_root then
								self.m_tCellVisitorRole[3].m_root:setZOrder(i)
							end
						end
					else
						local nTag = (k.indexX - 1) * KID_MAP_ROW + k.indexY
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

--@brief 	排序建筑，根据排序设置Z坐标
function SceneKidHome:sortBuilding()
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

				tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
				tItem.lineSortIdMin = tItem.indexX
				tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
				tItem.lineSortIdMax = nTempIndexX

				table.insert(tGridData, tItem)
			end
		end
	end
	--获取玩家和小孩的格子
--	WZLog("SceneKidHome:sortBuilding", type(self.m_tCellHost), type(self.m_tCellMate), type(self.m_tCellKidRole))
	if self.m_tCellHost then
		local tItem = {}
		local tRoleGridData = self.m_tCellHost:getRoleGridData()
		if tRoleGridData then 
			tItem.configId = 9999999
			tItem.indexX = tRoleGridData[1]
			tItem.indexY = tRoleGridData[2]

			local nTempIndexX = tItem.indexX
			local nTempIndexY = tItem.indexY

			tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
			tItem.lineSortIdMin = tItem.indexX
			tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
			tItem.lineSortIdMax = nTempIndexX

			table.insert(tGridData, tItem)
		end
	end
	if self.m_tCellMate then
		local tItem = {}
		local tRoleGridData = self.m_tCellMate:getRoleGridData()
		if tRoleGridData then 
			tItem.configId = 9999998
			tItem.indexX = tRoleGridData[1]
			tItem.indexY = tRoleGridData[2]

			local nTempIndexX = tItem.indexX
			local nTempIndexY = tItem.indexY

			tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
			tItem.lineSortIdMin = tItem.indexX
			tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
			tItem.lineSortIdMax = nTempIndexX

			table.insert(tGridData, tItem)
		end
	end
	if self.m_tCellKidRole and self.m_tCellKidRole[1] then
		local bIsFound = false
		if self.m_tKidRideData and #self.m_tKidRideData > 0 then
			local tTempData = self.m_tCellKidRole[1]:getData()
			for k = 1, #self.m_tKidRideData do
				if tTempData and self.m_tKidRideData[k][1] == tTempData.id then 
					bIsFound = true
					local tItem = {}
					tItem.configId = 9999997
					tItem.indexX = self.m_tKidRideData[k][2]
					tItem.indexY = self.m_tKidRideData[k][3]

					local nTempIndexX = tItem.indexX + self.m_tKidRideData[k][4].size[1][1] - 1
					local nTempIndexY = tItem.indexY + self.m_tKidRideData[k][4].size[1][2] - 1

					tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
					tItem.lineSortIdMin = tItem.indexX
					tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
					tItem.lineSortIdMax = nTempIndexX

					table.insert(tGridData, tItem)
					break
				end
			end
		end
		if not bIsFound then 
			local tItem = {}
			local tRoleGridData = self.m_tCellKidRole[1]:getRoleGridData()
			if tRoleGridData then 
				tItem.configId = 9999997
				tItem.indexX = tRoleGridData[1]
				tItem.indexY = tRoleGridData[2]

				local nTempIndexX = tItem.indexX
				local nTempIndexY = tItem.indexY

				tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
				tItem.lineSortIdMin = tItem.indexX
				tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
				tItem.lineSortIdMax = nTempIndexX

				table.insert(tGridData, tItem)
			end
		end
	end
	if self.m_tCellKidRole and self.m_tCellKidRole[2] then
		local bIsFound = false
		if self.m_tKidRideData and #self.m_tKidRideData > 0 then
			local tTempData = self.m_tCellKidRole[2]:getData()
			for k = 1, #self.m_tKidRideData do
				if tTempData and self.m_tKidRideData[k][1] == tTempData.id then 
					bIsFound = true
					local tItem = {}
					tItem.configId = 9999996
					tItem.indexX = self.m_tKidRideData[k][2]
					tItem.indexY = self.m_tKidRideData[k][3]

					local nTempIndexX = tItem.indexX + self.m_tKidRideData[k][4].size[1][1] - 1
					local nTempIndexY = tItem.indexY + self.m_tKidRideData[k][4].size[1][2] - 1

					tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
					tItem.lineSortIdMin = tItem.indexX
					tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
					tItem.lineSortIdMax = nTempIndexX

					table.insert(tGridData, tItem)
					break
				end
			end
		end
		if not bIsFound then 
			local tItem = {}
			local tRoleGridData = self.m_tCellKidRole[2]:getRoleGridData()
			if tRoleGridData then 
				tItem.configId = 9999996
				tItem.indexX = tRoleGridData[1]
				tItem.indexY = tRoleGridData[2]

				local nTempIndexX = tItem.indexX
				local nTempIndexY = tItem.indexY

				tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
				tItem.lineSortIdMin = tItem.indexX
				tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
				tItem.lineSortIdMax = nTempIndexX

				table.insert(tGridData, tItem)
			end
		end
	end
	if self.m_tCellVisitorRole and self.m_tCellVisitorRole[1] then
		local tItem = {}
		local tRoleGridData = self.m_tCellVisitorRole[1]:getRoleGridData()
		if tRoleGridData then 
			tItem.configId = 9999995
			tItem.indexX = tRoleGridData[1]
			tItem.indexY = tRoleGridData[2]

			local nTempIndexX = tItem.indexX
			local nTempIndexY = tItem.indexY

			tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
			tItem.lineSortIdMin = tItem.indexX
			tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
			tItem.lineSortIdMax = nTempIndexX

			table.insert(tGridData, tItem)
		end
	end
	if self.m_tCellVisitorRole and self.m_tCellVisitorRole[2] then
		local tItem = {}
		local tRoleGridData = self.m_tCellVisitorRole[2]:getRoleGridData()
		if tRoleGridData then 
			tItem.configId = 9999994
			tItem.indexX = tRoleGridData[1]
			tItem.indexY = tRoleGridData[2]

			local nTempIndexX = tItem.indexX
			local nTempIndexY = tItem.indexY

			tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
			tItem.lineSortIdMin = tItem.indexX
			tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
			tItem.lineSortIdMax = nTempIndexX

			table.insert(tGridData, tItem)
		end
	end
	if self.m_tCellVisitorRole and self.m_tCellVisitorRole[3] then
		local tItem = {}
		local tRoleGridData = self.m_tCellVisitorRole[3]:getRoleGridData()
		if tRoleGridData then 
			tItem.configId = 9999993
			tItem.indexX = tRoleGridData[1]
			tItem.indexY = tRoleGridData[2]

			local nTempIndexX = tItem.indexX
			local nTempIndexY = tItem.indexY

			tItem.listSortIdMin = KID_MAP_ROW - nTempIndexY
			tItem.lineSortIdMin = tItem.indexX
			tItem.listSortIdMax = KID_MAP_ROW - tItem.indexY
			tItem.lineSortIdMax = nTempIndexX

			table.insert(tGridData, tItem)
		end
	end
	
--	WZLog("SceneKidHome:sortBuilding", Serialize(tGridData))
	SceneKidHome:FurnitureSort2(tGridData)
end

--@brief 	寻路
--@param 	nIndex : 1->Host, 2->Mate, 3->Kid1, 4->Kid2, 5->Visitor1, 6->Visitor2, 7->Visitor3
function SceneKidHome:findPathFinish(tPathNode, nIndex)
	-- body
	if self.m_tRolePathNode == nil then self.m_tRolePathNode = {} end

	if tPathNode then 
		self.m_tRolePathNode[nIndex] = CopyTable(tPathNode)
		self.m_tIsRoleMove[nIndex] = true
		WZLog("SceneKidHome:findPathFinish", Serialize(tPathNode))
	end
end

--@brief 	开始寻路
function SceneKidHome:startFindPath(targetX, targetY, roleIndex)
	-- body
	AStarPathfinding:SetRowAndColumnAmount(KID_MAP_ROW, KID_MAP_ROW)
	AStarPathfinding:SetTargetRowAndColumn(targetX, targetY)
	local tStartGrid = self.m_tRandomGrid[roleIndex]
	AStarPathfinding:SetStartPoint(tStartGrid[1], tStartGrid[2], roleIndex)
	AStarPathfinding:SetFunTable(SceneKidHome)
	AStarPathfinding:SetFindFinishCallback(self, self.findPathFinish)
	AStarPathfinding:StartFindPath()
end

--@brief 	获取格子信息
function SceneKidHome:GetGroundInfo(indexX, indexY)
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

--@brief 	生成四个随机的格子，不重复，格子上面没有物品
function SceneKidHome:generateRandomGrid()
	-- body
	self.m_tRandomGrid = {}
	while #self.m_tRandomGrid < 7 do 
		local nIndexX = math.random(1, KID_MAP_ROW)
		local nIndexY = math.random(1, KID_MAP_ROW)
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
				nIndexX = math.random(1, KID_MAP_ROW)
				nIndexY = math.random(1, KID_MAP_ROW)
			end
		end
	end

	WZLog("SceneKidHome:generateRandomGrid", Serialize(self.m_tRandomGrid))
end

--@brief 	当所站位置被家具占用后，重新随机一个位置
function SceneKidHome:reGenerateOneGrid(tCellRoleObj)
	-- body
	local nIndexX = math.random(1, KID_MAP_ROW)
	local nIndexY = math.random(1, KID_MAP_ROW)
	
	local offset = 8
	if tCellRoleObj then
		local tGridData = tCellRoleObj:getRoleGridData()
		nIndexX = math.random(math.max(tGridData[1]-offset,0), math.min(tGridData[1]+offset,KID_MAP_ROW))
		nIndexY = math.random(math.max(tGridData[2]-offset,0), math.min(tGridData[2]+offset,KID_MAP_ROW))
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
			nIndexX = math.random(1, KID_MAP_ROW)
			nIndexY = math.random(1, KID_MAP_ROW)
			if tCellRoleObj then
				local tGridData = tCellRoleObj:getRoleGridData()
				nIndexX = math.random(math.max(tGridData[1]-offset,0), math.min(tGridData[1]+offset,KID_MAP_ROW))
				nIndexY = math.random(math.max(tGridData[2]-offset,0), math.min(tGridData[2]+offset,KID_MAP_ROW))
			end
		end
	end

	return {nIndexX, nIndexY}
end

--@brief 	当移动或新建建筑时候，检测角色和小孩是否在建筑所在的位置，在则重新设置其位置
function SceneKidHome:resetRoleAndKidPos()
	-- body
	if self.m_tRandomGrid == nil then return end 

	local tBasicData = {}
	tBasicData.size = {{1,1}}
	for i = 1, #self.m_tRandomGrid do 
		if self.m_tGridList[self.m_tRandomGrid[i][1]][self.m_tRandomGrid[i][2]].configId >= 0 then 
			local tTempGrid = self:reGenerateOneGrid()
			if self.m_tCellHost then
				local tRoleGridData = self.m_tCellHost:getRoleGridData()
				if tRoleGridData[1] == self.m_tRandomGrid[i][1] and tRoleGridData[2] == self.m_tRandomGrid[i][2] then 
					self.m_tRandomGrid[i] = tTempGrid

					self.m_tCellHost:setRoleGridData(tTempGrid)
		            local nAbsX, nAbsY = self:_getAbsPosition(tTempGrid[1], tTempGrid[2], tBasicData)
		            self.m_tCellHost.m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				end
			end
			if self.m_tCellMate then
				local tRoleGridData = self.m_tCellMate:getRoleGridData()
				if tRoleGridData[1] == self.m_tRandomGrid[i][1] and tRoleGridData[2] == self.m_tRandomGrid[i][2] then 
					self.m_tRandomGrid[i] = tTempGrid

					self.m_tCellMate:setRoleGridData(tTempGrid)
		            local nAbsX, nAbsY = self:_getAbsPosition(tTempGrid[1], tTempGrid[2], tBasicData)
		            self.m_tCellMate.m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				end
			end
			if self.m_tCellKidRole and self.m_tCellKidRole[1] then 
				local tRoleGridData = self.m_tCellKidRole[1]:getRoleGridData()
				if tRoleGridData[1] == self.m_tRandomGrid[i][1] and tRoleGridData[2] == self.m_tRandomGrid[i][2] then 
					self.m_tRandomGrid[i] = tTempGrid

					self.m_tCellKidRole[1]:setRoleGridData(tTempGrid)
		            local nAbsX, nAbsY = self:_getAbsPosition(tTempGrid[1], tTempGrid[2], tBasicData)
		            self.m_tCellKidRole[1].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				end
			end
			if self.m_tCellKidRole and self.m_tCellKidRole[2] then 
				local tRoleGridData = self.m_tCellKidRole[2]:getRoleGridData()
				if tRoleGridData[1] == self.m_tRandomGrid[i][1] and tRoleGridData[2] == self.m_tRandomGrid[i][2] then 
					self.m_tRandomGrid[i] = tTempGrid

					self.m_tCellKidRole[2]:setRoleGridData(tTempGrid)
		            local nAbsX, nAbsY = self:_getAbsPosition(tTempGrid[1], tTempGrid[2], tBasicData)
		            self.m_tCellKidRole[2].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				end
			end
			if self.m_tCellVisitorRole and self.m_tCellVisitorRole[1] then 
				local tRoleGridData = self.m_tCellVisitorRole[1]:getRoleGridData()
				if tRoleGridData[1] == self.m_tRandomGrid[i][1] and tRoleGridData[2] == self.m_tRandomGrid[i][2] then 
					self.m_tRandomGrid[i] = tTempGrid

					self.m_tCellVisitorRole[1]:setRoleGridData(tTempGrid)
		            local nAbsX, nAbsY = self:_getAbsPosition(tTempGrid[1], tTempGrid[2], tBasicData)
		            self.m_tCellVisitorRole[1].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				end
			end
			if self.m_tCellVisitorRole and self.m_tCellVisitorRole[2] then 
				local tRoleGridData = self.m_tCellVisitorRole[2]:getRoleGridData()
				if tRoleGridData[1] == self.m_tRandomGrid[i][1] and tRoleGridData[2] == self.m_tRandomGrid[i][2] then 
					self.m_tRandomGrid[i] = tTempGrid

					self.m_tCellVisitorRole[2]:setRoleGridData(tTempGrid)
		            local nAbsX, nAbsY = self:_getAbsPosition(tTempGrid[1], tTempGrid[2], tBasicData)
		            self.m_tCellVisitorRole[2].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				end
			end
			if self.m_tCellVisitorRole and self.m_tCellVisitorRole[3] then 
				local tRoleGridData = self.m_tCellVisitorRole[3]:getRoleGridData()
				if tRoleGridData[1] == self.m_tRandomGrid[i][1] and tRoleGridData[2] == self.m_tRandomGrid[i][2] then 
					self.m_tRandomGrid[i] = tTempGrid

					self.m_tCellVisitorRole[3]:setRoleGridData(tTempGrid)
		            local nAbsX, nAbsY = self:_getAbsPosition(tTempGrid[1], tTempGrid[2], tBasicData)
		            self.m_tCellVisitorRole[3].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				end
			end
		end
	end
end

--@brief 	摇摇车结束，删除为排序保存的数据
function SceneKidHome:deleteKidRideData(kidId)
	-- body
	if self.m_root == nil or self.m_tKidRideData == nil or # self.m_tKidRideData == 0 then return end 

	for i = 1, #self.m_tKidRideData do
		if self.m_tKidRideData[i][1] == kidId then 
			table.remove(self.m_tKidRideData, i)
			break 
		end
	end

	self:sortBuilding()
end

--@brief 	确认购买或使用新地板
function SceneKidHome:toBuyFloorAndUse()
	-- body
	local tData = self.m_tFloorData
	self:stopRoleRun(1)

    self:_createLoading()
    ProtocolProcessorKid:send_WEDDING_AddHouseBuilding(tData.fromSource, tData.basicData.id, -1, -1, tData.flipStatus)
end

--@brief 	取消购买或使用新地板
function SceneKidHome:cancelToBuyOrUseFloor()
	-- body
	self:cancelTobuildNewBuilding(self.m_tFloorData)
end

--@brief 	设置场景大小
function SceneKidHome:setSceneUI()
	if self.m_nExpansionStatus == 0 then
		KID_MAP_ROW = 21
		KID_MAP_WIDTH = KID_MAP_ROW * KID_MAP_SIZEX --21格子:945 42格子:1890
		KID_MAP_HEIGHT = KID_MAP_ROW * KID_MAP_SIZEY --21格子:504  42格子:1008

	    local imgWallLeft1 = GetElement(self.m_root, "imgWallLeft1_kidSceneMap", WZUIImage)
	    local imgWallRight1 = GetElement(self.m_root, "imgWallRight1_kidSceneMap", WZUIImage)
	    local imgWallLeft2 = GetElement(self.m_root, "imgWallLeft2_kidSceneMap", WZUIImage)
	    local imgWallRight2 = GetElement(self.m_root, "imgWallRight2_kidSceneMap", WZUIImage)

	    local imgGrassLeft1 = GetElement(self.m_root, "imgGrassLeft1_kidSceneMap", WZUIImage)
	    local imgGrassRight1 = GetElement(self.m_root, "imgGrassRight1_kidSceneMap", WZUIImage)
	    local imgGrassLeft2 = GetElement(self.m_root, "imgGrassLeft2_kidSceneMap", WZUIImage)
	    local imgGrassRight2 = GetElement(self.m_root, "imgGrassRight2_kidSceneMap", WZUIImage)

	    imgWallLeft1:setAbsPosition(GlobalMethod:ccp(808,901))
		imgWallRight1:setAbsPosition(GlobalMethod:ccp(1292,901))
	    imgWallLeft2:setAbsPosition(GlobalMethod:ccp(-600,901))
		imgWallRight2:setAbsPosition(GlobalMethod:ccp(2700,901))

		imgGrassLeft1:setAbsPosition(GlobalMethod:ccp(765.5,525))
		imgGrassRight1:setAbsPosition(GlobalMethod:ccp(1334.5,525))
		imgGrassLeft2:setAbsPosition(GlobalMethod:ccp(-600,525))
		imgGrassRight2:setAbsPosition(GlobalMethod:ccp(2700,525))

		local conForMap = GetElement(self.m_root, "conForMap_kidSceneMap", WZUIContainer)
		local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
		local conForNewBuild = GetElement(self.m_root, "conForNewBuild_kidSceneMap", WZUIContainer)
		conForMap:setAbsContentSize(GlobalMethod:CCSize(945,504))
		conForBuilding:setAbsContentSize(GlobalMethod:CCSize(945,504))
		conForNewBuild:setAbsContentSize(GlobalMethod:CCSize(945,504))
		conForMap:updateRelativeSize()
		conForBuilding:updateRelativeSize()
		conForNewBuild:updateRelativeSize()
	elseif self.m_nExpansionStatus == 1 then
		KID_MAP_ROW = 42
		KID_MAP_WIDTH = KID_MAP_ROW * KID_MAP_SIZEX --21格子:945 42格子:1890
		KID_MAP_HEIGHT = KID_MAP_ROW * KID_MAP_SIZEY --21格子:504  42格子:1008

	    local imgWallLeft1 = GetElement(self.m_root, "imgWallLeft1_kidSceneMap", WZUIImage)
	    local imgWallRight1 = GetElement(self.m_root, "imgWallRight1_kidSceneMap", WZUIImage)
	    local imgWallLeft2 = GetElement(self.m_root, "imgWallLeft2_kidSceneMap", WZUIImage)
	    local imgWallRight2 = GetElement(self.m_root, "imgWallRight2_kidSceneMap", WZUIImage)

	    local imgGrassLeft1 = GetElement(self.m_root, "imgGrassLeft1_kidSceneMap", WZUIImage)
	    local imgGrassRight1 = GetElement(self.m_root, "imgGrassRight1_kidSceneMap", WZUIImage)
	    local imgGrassLeft2 = GetElement(self.m_root, "imgGrassLeft2_kidSceneMap", WZUIImage)
	    local imgGrassRight2 = GetElement(self.m_root, "imgGrassRight2_kidSceneMap", WZUIImage)

	    imgWallLeft1:setAbsPosition(GlobalMethod:ccp(808,1154))
		imgWallRight1:setAbsPosition(GlobalMethod:ccp(1292,1154))
	    imgWallLeft2:setAbsPosition(GlobalMethod:ccp(337.5,901))
		imgWallRight2:setAbsPosition(GlobalMethod:ccp(1762.5,901))

		imgGrassLeft1:setAbsPosition(GlobalMethod:ccp(288,525))
		imgGrassRight1:setAbsPosition(GlobalMethod:ccp(1812,525))
		imgGrassLeft2:setAbsPosition(GlobalMethod:ccp(765.5,268))
		imgGrassRight2:setAbsPosition(GlobalMethod:ccp(1334.5,268))

		local conForMap = GetElement(self.m_root, "conForMap_kidSceneMap", WZUIContainer)
		local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
		local conForNewBuild = GetElement(self.m_root, "conForNewBuild_kidSceneMap", WZUIContainer)
		conForMap:setAbsContentSize(GlobalMethod:CCSize(1890,1008))
		conForBuilding:setAbsContentSize(GlobalMethod:CCSize(1890,1008))
		conForNewBuild:setAbsContentSize(GlobalMethod:CCSize(1890,1008))
		conForMap:updateRelativeSize()
		conForBuilding:updateRelativeSize()
		conForNewBuild:updateRelativeSize()
	end
end

-------------------------------------私有方法模块End----------------------------------------
