--SceneFamilyData.lua
--@brief	SceneFamily的数据模块
--@date		2017/07/25
--@author	Tianxiang_Xu
--@note		家园系统场景

MAP_SIZEX = 46
MAP_SIZEY = 35
MAP_REAL_WIDTH = math.ceil(math.sqrt(MAP_SIZEX*MAP_SIZEX/4 + MAP_SIZEY * MAP_SIZEY/4))
MAP_WIDTH = 2024
MAP_HEIGHT = 1540
MAP_ROW = 44

SceneFamily = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneFamily:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tWinSize = nil 
	self.m_tSceneLayer = nil 
	self.m_tPlayerLayer = nil 
	self.m_sFamilyName = nil  			--家园的名字
	self.m_nFamilyLevel = nil 			--家园的等级
	self.m_nFamilyExp = nil 			--家园当前经验
	self.m_nFamilySheerLuxury = nil 	--家园豪华度
	self.m_tGridList = nil 				--格子数据
	self.m_clickInfo = nil 				--点击的建筑的信息
	self.m_startPoint = {} 
	self.m_nMoveX = 0 
	self.m_nMoveY = 0 
	self.m_nLoadingId = nil 
	self.m_nTouchInBuildingState = 0 	--不在点击的建筑上
	self.m_bIsNewBuilding = false 		--是否处于新建建筑中
	self.m_nStoneBuyTimes = 0 			--购买奇石的次数
	self.m_nWaterBuyTimes = 0 			--购买圣水的次数
	self.m_tTouchPoint = {}
	self.m_bIsPtInBuilding = false 		--判断触摸点是否在建筑上
	self.m_nInUseButlerNum = 0 			--在使用的佣人的数目
	self.m_tCellListForButler = nil 	--佣人房建筑的表结构
	self.m_bIsInTeach = false 			--是否在教学
	-- self.m_nPinchDistanceThreshold = 3
 --    self.m_nZoomRate = 1.0/200
 --    self.m_nPinchDamping = 0.9
    self.m_nMaxScaleValue = 1.75
    self.m_nMinScaleValue = 0.5
    self.m_tFirstTouchPoint = {}
    self.m_tOldPosition = {}
    self.m_tTopRight = {}
	self.m_tBottomLeft = {}
	self.m_tWinTopRight = {x = 1136, y = 640}
	self.m_tWinBottomLeft = {x = 0, y = 0}
	self.m_nRecoverTime = nil 			--受伤恢复时间
	self.m_tWorkerData = nil 			--打工仔数据
	self.m_nProtectMountId = nil 		--守护兽ID
	self.m_nLeftProtectTime = 0 		--剩余守护时间
	self.m_nCanOwnPetNum = 2 			--可以拥有的打工仔数量
	self.m_tWorkSpaceCell = nil 		--打工所的cell
	self.m_tWaterAndStoneUpdateMark = {} --圣水和奇石生产刷新标记，防止后期一次性会请求好多次26-19协议造成断线重连的问题
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneFamily:_unInit()
	self.m_root = nil
	self.m_tWinSize = nil 
	self.m_tSceneLayer = nil 
	self.m_tPlayerLayer = nil 
	self.m_sFamilyName = nil  			--家园的名字
	self.m_nFamilyLevel = nil 			--家园的等级
	self.m_nFamilyExp = nil 			--家园当前经验
	self.m_nFamilySheerLuxury = nil 	--家园豪华度
	self.m_tGridList = nil 				--格子数据
	self.m_clickInfo = nil 
	self.m_startPoint = nil 
	self.m_nMoveX = nil
	self.m_nMoveY = nil
	self.m_nLoadingId = nil 
	self.m_nTouchInBuildingState = nil 	--不在点击的建筑上
	self.m_bIsNewBuilding = nil 
	self.m_nStoneBuyTimes = nil 			--购买奇石的次数
	self.m_nWaterBuyTimes = nil  			--购买圣水的次数
	self.m_bIsPtInBuilding = nil 		--判断触摸点是否在建筑上
	self.m_nInUseButlerNum = nil 			--在使用的佣人的数目
	self.m_tCellListForButler = nil
	self.m_bIsInTeach = nil 			--是否在教学
	-- self.m_nPinchDistanceThreshold = nil
 --    self.m_nZoomRate = nil
 --    self.m_nPinchDamping = nil
    self.m_nMaxScaleValue = nil
    self.m_nMinScaleValue = nil 
 --    self.m_tTopRight = nil
	-- self.m_tBottomLeft = nil
	-- self.m_tWinTopRight = nil
	-- self.m_tWinBottomLeft = nil
	self.m_tTouchPoint = nil 
	self.m_nRecoverTime = nil 			--受伤恢复时间
	self.m_tWorkerData = nil
	self.m_nProtectMountId = nil 		--守护兽ID
	self.m_nLeftProtectTime = nil 
	self.m_nCanOwnPetNum = nil
	self.m_tWorkSpaceCell = nil 
	self.m_tWaterAndStoneUpdateMark = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneFamily:createElement()
    if WZFileUtil:isFileExist("pack/family/pack_family_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/family/pack_family_0.plist")
    end
    self.m_createFlag = true
	local element = WZUISystem:getInstance():createElement("SceneFamily")
	assert(element, "SceneFamily create element failed!")
	self:_init()
	return element
end


--@brief 	外部接口
function SceneFamily:showInterface(playerId)
	-- body
	if CacheCenter:getPlayerInfo().homeLevel < 1 then 
        WndCreateFamily:showInterface()
    else
		local sceneFamily = SceneFamily:createElement()
		if sceneFamily then
			self.m_nPlayerId = playerId or CacheCenter:getPlayerInfo().id
			replaceScene(sceneFamily)
		end
	end
end

--@brief 	设置家园数据
function SceneFamily:setData(hostPlayerId, homeName, homeLevel, homeExp, sheerLuxury, configId, buildingStatus, countdown, productItemId, flipStatus, indexX, indexY, currentNum, buyWaterTimes, buyStoneTimes, servrantId, servrantItemId, servrantEfficient, servrantEndTime, maxServrantNum, canSteal, hurtEndTime, guardromonId, guardEndTime, icon, animation, advancedLevel)
	-- body
	self:_stopLoading()
	self.m_sFamilyName = homeName  			--家园的名字
	self.m_nFamilyLevel = homeLevel 			--家园的等级
	self.m_nFamilyExp = homeExp 			--家园当前经验
	self.m_nFamilySheerLuxury = sheerLuxury 	--家园豪华度
	self.m_nStoneBuyTimes = buyStoneTimes 			--购买奇石的次数
	self.m_nWaterBuyTimes = buyWaterTimes  			--购买圣水的次数
	WZLog("SceneFamily:setData *****", self.m_nFamilyLevel, self.m_nFamilyExp, self.m_nFamilySheerLuxury)

	self.m_tGridList = {} 				--格子数据
	for i = 1, MAP_ROW do 
		self.m_tGridList[i] = {}
		for j = 1, MAP_ROW do
			local tItem = {}
			tItem.configId = -1     --标记：-1->表示可以使用；0->表示不能使用；>0表示建筑物 
			tItem.buildingStatus = -1 
			tItem.countdown = 0 
			tItem.productItemId = 0 
			tItem.currentNum = 0 
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

	for i = 1, #configId do
		self:setOneBuildingData(configId[i], buildingStatus[i], countdown[i], productItemId[i], flipStatus[i], indexX[i], indexY[i], currentNum[i])
	end
	self.m_nInUseButlerNum = self:getUsingButlerNum()
	--打工仔数据
	self.m_tWorkerData = {}
	for i = 1, #servrantId do
		local tItem = {}
		tItem.playerPetId = servrantId[i]
		tItem.itemId = servrantItemId[i]
		tItem.effectType = servrantEfficient[i]
		tItem.leftTime = servrantEndTime[i]
		tItem.canSteal = canSteal[i]
		tItem.icon = icon[i]
		tItem.animation = animation[i]
		tItem.advancedLevel = advancedLevel[i]
		tItem.name = self:getPetName(tItem.itemId, tItem.advancedLevel)

		table.insert(self.m_tWorkerData, tItem)
	end
	WZLog("SceneFamily:setData", Serialize(self.m_tWorkerData), guardEndTime)
	self:setMaxPetNum(maxServrantNum) 
	self.m_nRecoverTime = hurtEndTime
	self.m_nProtectMountId = guardromonId
	self.m_nLeftProtectTime = guardEndTime
	if self.m_nProtectMountId > 0 and self.m_nLeftProtectTime > 0 then
		self.m_root:enableSchedule("_caculateTime", 1)
	end
	--创建家园中的建筑
	self:_createBuilding()
	--显示操作界面
	WndFamilyOperate:showOtherInfo()
end

--@brief 	设置某一格数据
function SceneFamily:setOneBuildingData(configId, buildingStatus, countdown, productItemId, flipStatus, indexX, indexY, currentNum)
	-- body
	local tBasicData = GDatatab_home_building["id_" .. configId]
	local tBasicInfo = GDatatab_item["id_" .. configId]
	
	self.m_tGridList[indexX + 1][indexY + 1].configId = configId 
	self.m_tGridList[indexX + 1][indexY + 1].flipStatus = flipStatus or 0
	self.m_tGridList[indexX + 1][indexY + 1].buildingStatus = buildingStatus or 0
	self.m_tGridList[indexX + 1][indexY + 1].countdown = countdown or 0
	self.m_tGridList[indexX + 1][indexY + 1].productItemId = productItemId or 0
	self.m_tGridList[indexX + 1][indexY + 1].currentNum = currentNum or 0
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

--@brief 	清楚某一格子建筑数据
function SceneFamily:cleanOneGridData(indexX, indexY)
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
	self.m_tGridList[indexX + 1][indexY + 1].buildingStatus = -1 
	self.m_tGridList[indexX + 1][indexY + 1].countdown = 0 
	self.m_tGridList[indexX + 1][indexY + 1].productItemId = 0 
	self.m_tGridList[indexX + 1][indexY + 1].currentNum = 0 
	self.m_tGridList[indexX + 1][indexY + 1].flipStatus = 0 
	self.m_tGridList[indexX + 1][indexY + 1].basicData = nil  	--建筑表数据
	self.m_tGridList[indexX + 1][indexY + 1].basicInfo = nil 	--物品表数据
	self.m_tGridList[indexX + 1][indexY + 1].indexX = indexX + 1
	self.m_tGridList[indexX + 1][indexY + 1].indexY = indexY + 1
	self.m_tGridList[indexX + 1][indexY + 1].tempIndexX = indexX + 1
	self.m_tGridList[indexX + 1][indexY + 1].tempIndexY = indexY + 1
end

--@brief 	更新建筑一些数据
function SceneFamily:updateOneBuildingData(configId, buildingStatus, countdown, indexX, indexY)
	--body
	local tBasicData = GDatatab_home_building["id_" .. configId]
	local tBasicInfo = GDatatab_item["id_" .. configId]
	
	self.m_tGridList[indexX][indexY].configId = configId 
	self.m_tGridList[indexX][indexY].buildingStatus = buildingStatus
	self.m_tGridList[indexX][indexY].countdown = countdown 

	self.m_tGridList[indexX][indexY].basicData = tBasicData
	self.m_tGridList[indexX][indexY].basicInfo = tBasicInfo
end

--@brief 	获取主人房等级
function SceneFamily:getMainRoomLevel()
	-- body
	local nLevel = 0 
	local bIsFind = false 

	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].configId > 0 and self.m_tGridList[i][j].basicData.type == 0 and self.m_tGridList[i][j].basicData.sub_type == 0 then
				if self.m_tGridList[i][j].basicData.level > nLevel then 
					nLevel = self.m_tGridList[i][j].basicData.level
					bIsFind = true 
					break 
				end
			end
		end
		if bIsFind then 
			break 
		end
	end

	return nLevel 
end

--@brief 	获取打工坊的等级等级
function SceneFamily:getBuildingLevel(nType, subType)
	-- body
	local nLevel = 0 
	local bIsFind = false 

	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].configId > 0 and self.m_tGridList[i][j].basicData.type == nType and self.m_tGridList[i][j].basicData.sub_type == subType then
				if self.m_tGridList[i][j].basicData.level > nLevel then 
					nLevel = self.m_tGridList[i][j].basicData.level
					bIsFind = true 
					break 
				end
			end
		end
		if bIsFind then 
			break 
		end
	end

	return nLevel 
end

--@brief 	获取佣人房的数量
function SceneFamily:getButlerNum()
	-- body
	local nButlerNum = 0 

	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].configId == 40509 then
				nButlerNum = nButlerNum + 1
			end
		end
	end

	return nButlerNum 
end

--@brief 	在用的佣人数量
function SceneFamily:getUsingButlerNum()
	-- body
	local nUsingButlerNum = 0 

	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].configId > 0 and self.m_tGridList[i][j].buildingStatus ~= 0 and self.m_tGridList[i][j].countdown ~= 0 and self.m_tGridList[i][j].buildingStatus ~= 5 then
				nUsingButlerNum = nUsingButlerNum + 1
			end
		end
	end

	return nUsingButlerNum 
end

--@brief 	判断是否有可用的佣人
function SceneFamily:getFreeButlerNum()
	-- body
	local nTotalButlerNum = self:getButlerNum()
	self.m_nInUseButlerNum = self:getUsingButlerNum()

	return nTotalButlerNum - self.m_nInUseButlerNum
end

--@brief 	获取当前在用的佣人的最短时间
function SceneFamily:getMinCDTimeBuildingData()
	-- body
	local tData
	local nMinTime = 0 
	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].buildingStatus > 0 and self.m_tGridList[i][j].countdown > 0 then 
				if nMinTime == 0 then
					nMinTime = self.m_tGridList[i][j].countdown
					tData = self.m_tGridList[i][j]
				elseif nMinTime > self.m_tGridList[i][j].countdown then
					nMinTime = self.m_tGridList[i][j].countdown
					tData = self.m_tGridList[i][j]
				end
			end
		end
	end

	return tData 
end

--@brief 	根据建筑Id获取达到该等级的同类建筑的数量
function SceneFamily:getBuildingNumById(buildingId)
	-- body
	local tBuildingBasicData = GDatatab_home_building["id_" .. buildingId] 
	local nBuildingNum = 0 
	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].configId > 0 and (self.m_tGridList[i][j].configId == buildingId or (self.m_tGridList[i][j].basicData.type == tBuildingBasicData.type and self.m_tGridList[i][j].basicData.sub_type == tBuildingBasicData.sub_type and self.m_tGridList[i][j].basicData.level >= tBuildingBasicData.level)) then 
				nBuildingNum = nBuildingNum + 1
			end
		end
	end

	return nBuildingNum 
end

--@brief 	新建建筑
--@param 	buildingId:建筑ID
function SceneFamily:buildNewBuilding(buildingId)
	-- body
	WZLog("SceneFamily:buildNewBuilding", buildingId)
	local conForNewBuild = GetElement(self.m_root, "conForNewBuild_familySceneMap", WZUIContainer)
	self.m_bIsNewBuilding = true 
	--新建建筑的时候，如果之前选中了某个建筑，则取消选中
	if self.m_clickInfo then 
		self.m_clickInfo.tCell:setArrowVisible(false)
		self.m_clickInfo = nil 
		WZLog("3333333333333333333333333")
	    WndFamilyOperate:onClickBuildingCallBack()
	end
	conForNewBuild:removeAllChildrenWithCleanup(true)

	local tGridData = {}
	local tBasicData = GDatatab_home_building["id_" .. buildingId]
	local tBasicInfo = GDatatab_item["id_" .. buildingId]
	local nIndexX, nIndexY = self:_getCanUseGridIndex(tBasicData)
	tGridData.configId = configId 
	tGridData.flipStatus = 0
	tGridData.buildingStatus = 0
	tGridData.countdown =  0
	tGridData.productItemId = 0
	tGridData.currentNum = 0
	tGridData.basicData = tBasicData
	tGridData.basicInfo = tBasicInfo
	tGridData.indexX = nIndexX 
	tGridData.indexY = nIndexY
	tGridData.tempIndexX = nIndexX
	tGridData.tempIndexY = nIndexY

	local bCanPut = self:_judgeCanPutBuilding(nIndexX, nIndexY, tBasicData)
	if conForNewBuild then
		local celElement, tNewObj = CellFamilyBuilding:createElement()
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
            local nTempX, nTempY = self:_getAbsPosition(tGridData.indexX, tGridData.indexY, tGridData.basicData)
            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
            celElement:setZOrder(self:getBuildZPoint(tGridData.indexX, tGridData.indexY, tGridData.basicData))
            conForNewBuild:addChild(celElement)
            --创建牧场的时候
            if tBasicData.type == 1 and tBasicData.sub_type == 8 then
            	celElement:setScale(0.9)
            end
            local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
		    WZLog("SceneFamily:buildNewBuilding two", buildingId, tostring(isEndTeach), finishStep)
			if isEndTeach ~= true then
		        local buildingCK = SceneFamily:getBuildingCellById(40300)
		        local buildingSS = SceneFamily:getBuildingCellById(40100)
		        WZLog("WndFamilyShop:buildNewBuilding three", tostring(buildingCK), tostring(buildingSS))
		        if buildingCK == nil then
		        	TeachGroup1:endTeachStep({45,2})
		            TeachGroup1:startGroup({45,3,self.m_root})
		        elseif buildingCK and buildingSS == nil then
		            TeachGroup1:endTeachStep({45,5})
		            TeachGroup1:startGroup({45,6,self.m_root})
		        else
		        	TeachGroup1:removeTeach()
		        end
		    end
		    -- if isEndTeach ~= true and finishStep < 3 then
		    --     TeachGroup1:endTeachStep({45,2})
		    --     TeachGroup1:startGroup({45,3,self.m_root})
		    -- elseif isEndTeach ~= true and finishStep >= 3 then
		    --     TeachGroup1:endTeachStep({45,5})
		    --     TeachGroup1:startGroup({45,6,self.m_root})
		    -- end
        end
	end
end

--@brief 	清除掉新建层中的建筑
function SceneFamily:_cleanBuildingInNewLayer()
	-- body
	local conForNewBuild = GetElement(self.m_root, "conForNewBuild_familySceneMap", WZUIContainer)
	conForNewBuild:removeAllChildrenWithCleanup(true)
	self.m_bIsNewBuilding = false 
end

--@brief 	新建建筑成功
function SceneFamily:buildNewBuildingOK(configId, x, y, flipStatus)
	--body
	self:_stopLoading()
	--清除掉新建层的临时建筑
	self:_cleanBuildingInNewLayer()
	self.m_clickInfo = nil 
	--将新建的建筑添加到建筑层
	local tBasicData = GDatatab_home_building["id_" .. configId]
	local buildingStatus = 1 
	if tBasicData.build_time == 0 then 
		buildingStatus = 0
	end
	WZLog("SceneFamily:buildNewBuildingOK", configId, x, y, flipStatus, buildingStatus)
	self:setOneBuildingData(configId, buildingStatus, tBasicData.build_time, nil, flipStatus, x, y, 0)
	--建筑底部草地
    self:_createOneBuildingLawn(x + 1, y + 1)
	--将创建的建筑显示到地图上
	local conForBuilding = GetElement(self.m_root, "conForBuilding_familySceneMap", WZUIContainer)
	self:_createOneBuilding(x + 1, y + 1, -1, conForBuilding)
	--如果建造时间大于0，则消耗一个佣人
	self:refreshButlerNum()
	--如果建造的是傭人房，刷新佣人房的数量
	if tBasicData.type == 1 and tBasicData.sub_type == 4 then 
		WndFamilyOperate:showButlerNum()
	end
end

--@brief 	加速成功
function SceneFamily:buildingSpeedUpOK(indexX, indexY, speedType)
	-- body
	WZLog("SceneFamily:buildingSpeedOK")
	self:_stopLoading()
	self.m_tGridList[indexX + 1][indexY + 1].buildingStatus = 0
	self.m_tGridList[indexX + 1][indexY + 1].countdown = 0
	if speedType == 3 then  	--移除
		--清除建筑，清除数据
		self:cleanOneGridData(indexX, indexY)
		--清楚建筑草地节点
		self:cleanBuildingLawn(indexX, indexY)
		--如果是移除操作，则清掉建筑
		if self.m_clickInfo and self.m_clickInfo.element then 
			self.m_clickInfo.element:removeFromParentAndCleanup(true)
		end
		self.m_clickInfo = nil 
	elseif speedType == 2 then  --升级
		local nextConFigId = self.m_tGridList[indexX + 1][indexY + 1].basicData.post_id
		self.m_tGridList[indexX + 1][indexY + 1].configId = nextConFigId
		self.m_tGridList[indexX + 1][indexY + 1].basicData = GDatatab_home_building["id_" .. nextConFigId]
		self.m_tGridList[indexX + 1][indexY + 1].basicInfo = GDatatab_item["id_" .. nextConFigId]
	elseif speedType == 1 then  --建造
	end
	--刷新该建筑的状态
	if self.m_clickInfo and self.m_clickInfo.tCell then 
		self.m_clickInfo.tCell:setBuildingData(self.m_tGridList[indexX + 1][indexY + 1])
		self.m_clickInfo.tData = self.m_tGridList[indexX + 1][indexY + 1]
	end
	WndFamilyOperate.m_bIsClickFunc = false
	--加速，释放一个佣人
	self:refreshButlerNum()
	--重新生成按钮类型
	WZLog("44444444444444444444444")
    WndFamilyOperate:onClickBuildingCallBack()
end

--@brief 	确认升级成功
function SceneFamily:buildingUpgradeOK(indexX, indexY, countDown)
	-- body
	WZLog("SceneFamily:buildingUpgradeOK", indexX, indexY, countDown)
	self:_stopLoading()
	self.m_tGridList[indexX + 1][indexY + 1].buildingStatus = 2
	self.m_tGridList[indexX + 1][indexY + 1].countdown = countDown
	if countDown <= 0 then 
		self.m_tGridList[indexX + 1][indexY + 1].buildingStatus = 0
	end
	--刷新该建筑的状态
	if self.m_clickInfo and self.m_clickInfo.tCell then 
		self.m_clickInfo.tCell:setBuildingData(self.m_tGridList[indexX + 1][indexY + 1])
		self.m_clickInfo.tData = self.m_tGridList[indexX + 1][indexY + 1]
	end
	WndFamilyOperate.m_bIsClickFunc = false
	--升级，消耗一个佣人
	self:refreshButlerNum()
	--重新生成按钮类型
	WZLog("5555555555555555555555")
    WndFamilyOperate:onClickBuildingCallBack()
end

--@brief 	确认移除
function SceneFamily:buildingRemoveOK(indexX, indexY, countDown)
	-- body
	WZLog("SceneFamily:buildingRemoveOK")
	self:_stopLoading()
	self.m_tGridList[indexX + 1][indexY + 1].buildingStatus = 3
	self.m_tGridList[indexX + 1][indexY + 1].countdown = countDown
	if countDown <= 0 then 
		self.m_tGridList[indexX + 1][indexY + 1].buildingStatus = 0
	end
	--刷新该建筑的状态
	if self.m_clickInfo and self.m_clickInfo.tCell then 
		self.m_clickInfo.tCell:setBuildingData(self.m_tGridList[indexX + 1][indexY + 1])
		self.m_clickInfo.tData = self.m_tGridList[indexX + 1][indexY + 1]
	end
	WndFamilyOperate.m_bIsClickFunc = false
	--移除，消耗一个佣人
	self:refreshButlerNum()
	--重新生成按钮类型
	WZLog("666666666666666666666666666")
    WndFamilyOperate:onClickBuildingCallBack()
end

--@brief 	移动建筑成功
function SceneFamily:buildingMoveOK(xOrigin, yOrigin, xTarget, yTarget, flipStatus)
	-- body
	WZLog("SceneFamily:buildingMoveOK",Serialize(xOrigin), Serialize(yOrigin), Serialize(xTarget), Serialize(yTarget), Serialize(flipStatus))
	self:_stopLoading()
	WndFamilyOperate.m_bIsClickFunc = false
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
	--清楚原来格子数据
	for i = 1, #xOrigin do
		self:cleanOneGridData(xOrigin[i], yOrigin[i])
	end
	--更新新数据
	for i = 1, #tOriginData do
		self:setOneBuildingData(tOriginData[i].configId, tOriginData[i].buildingStatus, tOriginData[i].countdown, tOriginData[i].productItemId, tOriginData[i].flipStatus, tOriginData[i].indexX - 1, tOriginData[i].indexY - 1, tOriginData[i].currentNum)
		if self.m_clickInfo and #tOriginData == 1 then 
			self.m_clickInfo.tCell:resetBuildingData(self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY])
			self.m_clickInfo.element:setZOrder(self:getBuildZPoint(tOriginData[i].indexX, tOriginData[i].indexY, tOriginData[i].basicData))
			self.m_clickInfo.element:setTag((tOriginData[i].indexX - 1) * MAP_ROW + tOriginData[i].indexY)
			WZLog("SceneFamily:buildingMoveOK 99999", Serialize(self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY]))
			self.m_clickInfo.tData = self.m_tGridList[tOriginData[i].indexX][tOriginData[i].indexY]
			--针对围栏刷新建筑物的形态
			if self.m_clickInfo.tData.basicData.type == 2 and self.m_clickInfo.tData.basicData.sub_type == 5 then 
				self.m_clickInfo.tCell:redrawBuilding()
			end
		end
	end
end

--@brief 	更新地图数据
function SceneFamily:updateHomeData(currentLevel, currentExp, currentSheerLuxury, x, y, configId, flipStatus, buildingStatus, countdown, productItemId, currentNum)
	-- body
	if self.m_root == nil then return end 
	if self.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then return end 
	WZLog("SceneFamily:updateHomeData", currentLevel, currentExp, self.m_nPlayerId, CacheCenter:getPlayerInfo().id)
	self:_stopLoading()
	self.m_nFamilyLevel = currentLevel 			--家园的等级
	self.m_nFamilyExp = currentExp 			--家园当前经验
	self.m_nFamilySheerLuxury = currentSheerLuxury 	--家园豪华度
	self.m_tWaterAndStoneUpdateMark = {}

	local conForBuilding = GetElement(self.m_root, "conForBuilding_familySceneMap", WZUIContainer)
	for i = 1, #configId do
		if buildingStatus[i] > 0 and countdown[i] == 0 then 
			WZLog("SceneFamily:updateHomeData 111", configId[i], buildingStatus[i], countdown[i])
		end
		--如果操作是移除，倒计时为0，则清楚该建筑
		if buildingStatus[i] == 3 and countdown[i] == 0 then 
			--目前是不会有这个数据的，所以暂不做处理
		else
			WZLog("SceneFamily:updateHomeData 000", buildingStatus[i], countdown[i])
			self:setOneBuildingData(configId[i], buildingStatus[i], countdown[i], productItemId[i], flipStatus[i], x[i], y[i], currentNum[i])
			local element = conForBuilding:getChildByTag(x[i] * MAP_ROW + y[i] + 1)
			element = WZUIContainer:luaTo(element)
        	local cellObj = element:getLuaObjectIndex()
        	if cellObj then 
        		cellObj:setBuildingData(self.m_tGridList[x[i] + 1][y[i] + 1])
        	end
		end
	end
	self:refreshButlerNum()
	--刷新家园经验、等级、豪华度
	WndFamilyOperate:refreshInfoShow()
end

--@brief 	收集奇石或圣水成功
function SceneFamily:collectWaterOrStoneOK(indexX, indexY, num)
	--body
	self:_stopLoading()
	local conForBuilding = GetElement(self.m_root, "conForBuilding_familySceneMap", WZUIContainer)
	for i = 1, #indexX do
		local element = conForBuilding:getChildByTag(indexX[i] * MAP_ROW + indexY[i] + 1)
		element = WZUIContainer:luaTo(element)
    	local cellObj = element:getLuaObjectIndex()
    	if cellObj then 
    		cellObj:playCollectAni(num[i])
    	end
	end
	WndFamilyOperate.m_bIsClickFunc = false
end

--@brief 	取消操作（建造、升级、拆除）成功
function SceneFamily:cancelOperateOK(indexX, indexY, cancelType, result)
	-- body
	self:_stopLoading()
	WndFamilyOperate.m_bIsClickFunc = false
	WZLog("SceneFamily:cancelOperateOK", indexX, indexY, cancelType, result)
	if result == 0 then 
		self.m_tGridList[indexX + 1][indexY + 1].buildingStatus = 0
		self.m_tGridList[indexX + 1][indexY + 1].countdown = 0
		if cancelType == 1 then 
			--清除建筑，清除数据
			self:cleanOneGridData(indexX, indexY)
			--如果是移除操作，则清掉建筑
			if self.m_clickInfo and self.m_clickInfo.element then 
				self.m_clickInfo.element:removeFromParentAndCleanup(true)
			end
			self.m_clickInfo = nil 
			--重新生成按钮类型
			WZLog("777777777777777777777777777")
    		WndFamilyOperate:onClickBuildingCallBack()
    	elseif cancelType == 2 then 
    		if self.m_clickInfo then
    			if self.m_clickInfo.tData.basicData.post_id ~=-1 then
    				self.m_clickInfo.tCell:setBuildingData(self.m_tGridList[indexX + 1][indexY + 1])
					self.m_clickInfo.tData = self.m_tGridList[indexX + 1][indexY + 1]
					--重新生成按钮类型
					WZLog("88888888888888888888888888")
    				WndFamilyOperate:onClickBuildingCallBack()
    			end
    		end
    	elseif cancelType == 3 then 
    		if self.m_clickInfo then
    			if self.m_clickInfo.tData.basicData.type == 2 or self.m_clickInfo.tData.basicData.type == 3 then
    				self.m_clickInfo.tCell:setBuildingData(self.m_tGridList[indexX + 1][indexY + 1])
					self.m_clickInfo.tData = self.m_tGridList[indexX + 1][indexY + 1]
					--重新生成按钮类型
					WZLog("999999999999999999999")
    				WndFamilyOperate:onClickBuildingCallBack()
    			end
    		end
		end
		--取消耗时操作，释放一个佣人
		self:refreshButlerNum()
	else
		if cancelType == 1 then 
			MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT30)
		elseif cancelType == 2 then
			MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT31)
		elseif cancelType == 3 then
			MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT32)
		end
	end
end

--@brief 	购买圣水、奇石成功
function SceneFamily:buyWaterAndStoneOK()
	-- body
	local buyTimes = 0 
	if WndBuyActivity.m_tBaseData.nType == 16 then
		self.m_nWaterBuyTimes = self.m_nWaterBuyTimes + #WndBuyActivity.m_tResultAddNum
		buyTimes = self.m_nWaterBuyTimes
	elseif WndBuyActivity.m_tBaseData.nType == 17 then
		self.m_nStoneBuyTimes = self.m_nStoneBuyTimes + #WndBuyActivity.m_tResultAddNum
		buyTimes = self.m_nStoneBuyTimes
	end
	WndBuyActivity:setBuyResultData(TableToVector(WndBuyActivity.m_tResultAddNum,WZLuaVector_int_), TableToVector({1,1,1,1,1},WZLuaVector_int_), WndBuyActivity.m_tBaseData.nType, nil, buyTimes)
end

--@brief 	返回某一格子围栏所用动画的false：正常状态；true则用十字的
function SceneFamily:judgeEnclosureAniState(nIndexX, nIndexY)
	-- body
	local bIsLeftUp = false 
	local bIsRightUp = false 
	local bIsRightDown = false 
	local bIsLeftDown = false 

	local tLeftData = nil 
	local tUpData = nil 
	local tRightData = nil 
	local tDownData = nil 
	if nIndexY > 1 then 
		tLeftData = self.m_tGridList[nIndexX][nIndexY - 1]
	end
	if nIndexX > 1 then 
		tUpData = self.m_tGridList[nIndexX - 1][nIndexY]
	end
	if nIndexY < MAP_ROW then 
		tRightData = self.m_tGridList[nIndexX][nIndexY + 1]
	end
	if nIndexX < MAP_ROW then 
		tDownData = self.m_tGridList[nIndexX + 1][nIndexY]
	end

	--左上
	if tLeftData and tUpData and tLeftData.configId > 0 and tUpData.configId > 0 and tLeftData.basicData.type == 2 and tLeftData.basicData.sub_type == 5 and tUpData.basicData.type == 2 and tUpData.basicData.sub_type == 5 and tLeftData.flipStatus ~= tUpData.flipStatus then
		return true 
	end
	--右上
	if tRightData and tUpData and tRightData.configId > 0 and tUpData.configId > 0  and tRightData.basicData.type == 2 and tRightData.basicData.sub_type == 5 and tUpData.basicData.type == 2 and tUpData.basicData.sub_type == 5 and tRightData.flipStatus ~= tUpData.flipStatus then
		return true 
	end
	--右下
	if tRightData and tDownData and tRightData.configId > 0 and tDownData.configId > 0  and tRightData.basicData.type == 2 and tRightData.basicData.sub_type == 5 and tDownData.basicData.type == 2 and tDownData.basicData.sub_type == 5 and tRightData.flipStatus ~= tDownData.flipStatus then
		return true 
	end
	--右上
	if tLeftData and tDownData and tLeftData.configId > 0 and tDownData.configId > 0  and tLeftData.basicData.type == 2 and tLeftData.basicData.sub_type == 5 and tDownData.basicData.type == 2 and tDownData.basicData.sub_type == 5 and tLeftData.flipStatus ~= tDownData.flipStatus then
		return true 
	end

	return false 
end

--@brief 	获取仓库总容量
function SceneFamily:getWarehouseTotalNum()
	-- body
	local stoneNum = 0
	local waterNum = 0
	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].configId > 0 then
				if self.m_tGridList[i][j].basicData.type == 1 and self.m_tGridList[i][j].basicData.sub_type == 3 then
					local tFunction = self.m_tGridList[i][j].basicData.functions
					for k = 1, #tFunction do
						if tFunction[k][2] == 66 then
							waterNum = waterNum + tFunction[k][3]
						elseif tFunction[k][2] == 67 then
							stoneNum = stoneNum + tFunction[k][3]
						end
					end
					
				end
			end
		end
	end

	return waterNum, stoneNum
end

--@brief 	根据建筑Id获取相应的cell
--@param 	是否获取新建的建筑，bIsNew=true，头顶有勾叉按钮
function SceneFamily:getBuildingCellById(configId, bIsNew)
	-- body
	local bIsFound = false 
	local tCell 
	local tTempData = GDatatab_home_building["id_" .. configId]
	if bIsNew then 
		tCell = self.m_clickInfo.tCell 
	else
		for i = 1, #self.m_tGridList do
			for j = 1, #self.m_tGridList[i] do
				if (self.m_tGridList[i][j].configId == configId) or (self.m_tGridList[i][j].configId > 0 and self.m_tGridList[i][j].basicData.type == tTempData.type and self.m_tGridList[i][j].basicData.sub_type == tTempData.sub_type) then
					bIsFound = true
					local conForBuilding = GetElement(self.m_root, "conForBuilding_familySceneMap", WZUIContainer)
					local element = conForBuilding:getChildByTag((self.m_tGridList[i][j].indexX - 1) * MAP_ROW + self.m_tGridList[i][j].indexY)
					element = WZUIContainer:luaTo(element)
		        	local cellObj = element:getLuaObjectIndex()
		        	if cellObj then 
		        		tCell = cellObj
		        	end
					break 
				end
			end
			if bIsFound then 
				break 
			end
		end
	end

	return tCell 
end

--@brief 	设置教学不可移动和缩放
--@param 	bInTeach:是否正在教学
function SceneFamily:setCantMoveAndScale(bInTeach)
	-- body
	WZLog("SceneFamily:setCantMoveAndScale", bInTeach)
	self.m_bIsInTeach = bInTeach
	if self.m_bIsInTeach then 
		self:setSceneMove(false)
	else
		self:setSceneMove(true)
	end
end

--@brief 	开始打工成功
function SceneFamily:startToWorkOk(servrantId, servrantItemId, servrantEfficient, servrantEndTime, icon, animation, advancedLevel)
	-- body
	local tItem = {}
	tItem.playerPetId = servrantId
	tItem.itemId = servrantItemId
	tItem.effectType = servrantEfficient
	tItem.leftTime = servrantEndTime
	tItem.canSteal = 0
	tItem.icon = icon
	tItem.animation = animation
	tItem.advancedLevel = advancedLevel
	tItem.name = self:getPetName(tItem.itemId, tItem.advancedLevel)

	table.insert(self.m_tWorkerData, tItem)
	--创建新的宠物形象
	if self.m_tWorkSpaceCell then 
		self.m_tWorkSpaceCell:addNewWorkPet(tItem)
	end
	--重新设置打工宠物数据
	WndFamilyProduce:resetSelPet()
end

--@brief 	设置可拥有的打工宠物的数量
function SceneFamily:setMaxPetNum(num)
	-- body
	self.m_nCanOwnPetNum = num 
end

--@brief 	获取可拥有的打工宠物的数量
function SceneFamily:getMaxPetNum()
	-- body
	return self.m_nCanOwnPetNum
end

--@brief 	喂食成功返回
function SceneFamily:feedProtectRoleOK(nLeftTime)
	-- body
	if self.m_nLeftProtectTime <= 0 and self.m_nProtectMountId > 0 then
		self.m_root:enableSchedule("_caculateTime", 1)
	end
	self.m_nLeftProtectTime = nLeftTime
	WZLog("SceneFamily:feedProtectRoleOK", nLeftTime)
	WndFamilyProduce:_showLeftProtectTime()
end

--@brief 	开始守护成功回调
function SceneFamily:startToProtectOk(id)
	-- body
	self.m_nProtectMountId = id 

	MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT72)
	if self.m_nLeftProtectTime > 0 then
		self.m_root:enableSchedule("_caculateTime", 1)
	end
	--添加看守兽形象
	if self.m_tWorkSpaceCell then 
		self.m_tWorkSpaceCell:addProtectMount()
	end
	--更新相应的看守兽的状态
	WndFamilyProduce:resetProtectMountData()
end

--@brief 	偷取别人果实结果
function SceneFamily:stealResult(itemId, num, status, time, id)
	-- body
	WZLog("SceneFamily:stealResult", Serialize(itemId), Serialize(num))

	if status == 1 then
		WndRewardShow:showById(itemId, num)
		WndRewardShow:showExtendWord(LocalStrings.FAMILY_TEXT54)
	elseif status == 2 then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT73)
	elseif status == 3 then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT74)
	elseif status == 4 then
		if time <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT75)
		else
			MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT76)
		end
	elseif status == 5 then
		MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT83)
		self:_removeWorkDataById(id)
		self:_removePetAnimation(id, 1)
		return 
	end

	--受伤的话，开启恢复倒计时
	if time > 0 then
		self.m_nRecoverTime = time 
		WndFamilyOperate:setRecoverTimeCaculate()
	end
	--偷取后去掉对应宠物头上的可偷取标记
	self:_removePetAnimation(id, 2)
end

--@brief 	收取果实结果
function SceneFamily:receiveResult(itemId, num, stealTimes, id)
	-- body
	WZLog("SceneFamily:receiveResult")
	
	WndRewardShow:showById(itemId, num)
	local text = LocalStrings.FAMILY_TEXT52
	if stealTimes > 0 then
		text = string.format(LocalStrings.FAMILY_TEXT53, stealTimes)
	end
	WndRewardShow:showExtendWord(text)
	--收取成果后，移除掉对应的宠物
	self:_removeWorkDataById(id)
	self:_removePetAnimation(id, 1)
end

--@brief 	宠物状态由打工改为完成后的处理
function SceneFamily:dealwithFinishWork(id)
	-- body
	if self.m_tWorkSpaceCell == nil then return end 

	self.m_tWorkSpaceCell:petFinishWork(id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	根据格子X,Y索引，计算绝对坐标
--@param 	tBasicData:建筑表数据
function SceneFamily:_getAbsPosition(indexX, indexY, tBasicData)
	-- body
	local gapX = MAP_SIZEX / 2 
    local gapY = MAP_SIZEY / 2 

    local tData = tBasicData
    local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEX
    local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEY
    local startX = 0 + (indexX - 1) * gapX
    local startY = MAP_HEIGHT / 2 - (indexX - 1) * gapY

    local nAbsPointX = startX + indexY * gapX - gapX + nConWidth/2
    local nAbsPointY = startY + (indexY - 1) * gapY

    return nAbsPointX, nAbsPointY
end


--@brief 	判断当前移动所在的位置范围内是否有已经被占用的格子
--@param 	indexX:格子横向索引
--@param 	indexY:格子纵向索引
--@param 	tBasicData:建筑表数据
--@brief 	tData:建筑数据
function SceneFamily:_judgeCanPutBuilding(indexX, indexY, tBasicData, tData)
	-- body
	local bCanPut = true 

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

	return bCanPut
end

--@brief    数据加载动画
function SceneFamily:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function SceneFamily:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 	将坐标转化为格子所引
function SceneFamily:convertToGridIndex(pt)
	-- body
	local nIndexY = math.floor(pt.x/MAP_SIZEX) + 1 
	local nIndexX = math.floor(pt.y/MAP_SIZEY) + 1

	return nIndexX, nIndexY
end

--@brief 	获取主人房所在的格子的索引
function SceneFamily:_getMainRoomIndex()
	-- body
	for i = 1, #self.m_tGridList do
		for j = 1, #self.m_tGridList[i] do
			if self.m_tGridList[i][j].configId > 0 and self.m_tGridList[i][j].basicData.type == 0 and self.m_tGridList[i][j].basicData.sub_type == 0 then 
				return i, j 
			end
		end
	end

	return MAP_ROW/2, MAP_ROW/2
end

--@brief 	新建时候，返回离主人房最近的可用的格子
function SceneFamily:_getCanUseGridIndex(tBasicData)
	-- body
	local mainIndexX, mainIndexY = self:_getMainRoomIndex()
	local tMainSize = GDatatab_home_building["id_40000"].size

	local bIsFound = false 
	local nIndexX = nil 
	local nIndexY = nil 
	local nAdditionNum = 0 

	while not bIsFound do
		--上
		local nStartFindX = mainIndexX - (tBasicData.size[1][1] + nAdditionNum)
		if nStartFindX > 0 then 
			local nStartFindY = mainIndexY
			local nMaxY = mainIndexY + tMainSize[1][2] + nAdditionNum
			if nMaxY > MAP_ROW then 
				nMaxY = MAP_ROW 
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
		nStartFindX = mainIndexX + (tMainSize[1][1] + nAdditionNum)
		if nStartFindX + tBasicData.size[1][1] <= MAP_ROW then 
			local nStartFindY = mainIndexY - (1 + nAdditionNum)
			if nStartFindY < 1 then 
				nStartFindY = 1 
			end
			for i = nStartFindY, nStartFindY + tMainSize[1][2] - 1 do
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
			for i = nStartFindX, nStartFindX + tMainSize[1][1] do
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
		local nStartFindY = mainIndexY + (tMainSize[1][2] + nAdditionNum)
		if nStartFindY + tBasicData.size[1][2] - 1 <= MAP_ROW then 
			nStartFindX = mainIndexX
			local nMaxX = mainIndexX + tMainSize[1][1] + nAdditionNum
			if nMaxX > MAP_ROW then 
				nMaxX = MAP_ROW 
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
		if nAdditionNum >= MAP_ROW/2 + 1 then 
			break
		end
	end

	if not nIndexX or not nIndexY then 
		nIndexX = MAP_ROW/2
		nIndexY = MAP_ROW/2
	end

	return nIndexX,nIndexY
end

--@brief 	根据格子索引，计算层级
function SceneFamily:getBuildZPoint(nIndexX, nIndexY, tBasicData)
	-- body
	local nTempIndexX = nIndexX + tBasicData.size[1][1] - 1
	local nTempIndexY = nIndexY + tBasicData.size[1][2] - 1
	return (nTempIndexX - 1) * MAP_ROW + (MAP_ROW - nTempIndexY)
end

--@brief 	重新设置选中的建筑的数据
function SceneFamily:resetClickBuildingAfterFinish(nIndexX, nIndexY, nBuildingStatus)
	-- body
	if self.m_bIsNewBuilding then return end  
	if self.m_clickInfo then 
		if self.m_clickInfo.tData.indexX == nIndexX and self.m_clickInfo.tData.indexY == nIndexY then 
			if nBuildingStatus == 3 then 
				self.m_clickInfo = nil 
			else
				self.m_clickInfo.tData = self.m_clickInfo.tCell:getData()
			end
		end
	end

--	WZLog("1010101010101011010")
	WndFamilyOperate:onClickBuildingCallBack()
end

--@brief 	判断触摸点是否在建筑内
function SceneFamily:judgePtInBuilding(tData)
	-- body
	if self.m_clickInfo and self.m_clickInfo.tData.configId == tData.configId and self.m_clickInfo.tData.indexX == tData.indexX and self.m_clickInfo.tData.indexY == tData.indexY then
		self.m_bIsPtInBuilding = true
	end
	WZLog("SceneFamily:judgePtInBuilding", self.m_bIsPtInBuilding)
end

--@brief 	计算两点之间的距离
function SceneFamily:pointDis(tPoint1,tPoint2)
    if tPoint1 == nil or tPoint2 == nil then
        return nil
    end
	return math.sqrt( (tPoint1.x - tPoint2.x) * (tPoint1.x - tPoint2.x ) + (tPoint1.y - tPoint2.y) * (tPoint1.y - tPoint2.y ) )
end

--@brief    计算点乘以一个常量
--@param    tPoint 点
--@param    fFactor 数值
--@return   #1, 乘后的结果
function SceneFamily:pointMult(tPoint,fFactor)
    return {x = tPoint.x*fFactor,y = tPoint.y * fFactor}
end


--@brief    求两个点相加的结果
--@param    tPoint1 点1
--@param    tPoint2 点2
--@return   #1, 两个点相加后的结果 
function  SceneFamily:pointAdd(tPoint1,tPoint2)
    return {x = tPoint1.x + tPoint2.x,y = tPoint1.y + tPoint2.y}
end

--@brief    求两个点的中间点
--@param    tPoint1 点1
--@param    tPoint2 点2
--@return   #1, 两个点的中间点 
function SceneFamily:midPoint(tPoint1,tPoint2)
    return {x = (tPoint1.x + tPoint2.x)/2,y = (tPoint1.y + tPoint2.y)/2}
end

--@brief    求两个点相减的结果
--@param    tPoint1 点1
--@param    tPoint2 点2
--@return   #1, 两个点相减后的结果  
function SceneFamily:pointSub(tPoint1,tPoint2)
    return {x = tPoint1.x - tPoint2.x,y = tPoint1.y - tPoint2.y}
end

--@brief 	判断是否仓库容量充足
function SceneFamily:_judgeWareHouseCanCollect(tData)
	-- body
	local waterNum, stoneNum = self:getWarehouseTotalNum()
    if tData.basicData.type == 1 and tData.basicData.sub_type == 1 then --圣水
        local curWaterNum = CacheCenter:getPlayerItemCountById(66)
        if curWaterNum + tData.currentNum > waterNum then 
            return false
        end
    elseif tData.basicData.type == 1 and tData.basicData.sub_type == 2 then --奇石
        local curStoneNum = CacheCenter:getPlayerItemCountById(67)
        if curStoneNum + tData.currentNum > stoneNum then 
            return false
        end
    end

    return true 
end

--@brief 	获取宠物的名字
function SceneFamily:getPetName(itemId, advancedLevel)
	-- body
	local petName = GDatatab_item["id_"..itemId].name
	for k,v in pairs(GDatatab_pet_advanced) do
		if v.item_id == itemId and v.level == advancedLevel then
			petName = v.evo_name 
			break 
		end
	end

	return petName
end

--@brief 	移除已经领取了奖励的到概念股宠物形象
--@param 	nType: 1->收取;2->偷取
function SceneFamily:_removePetAnimation(id, nType)
	-- body
	if self.m_tWorkSpaceCell == nil then return end 
	if nType == 1 then
		self.m_tWorkSpaceCell:removeWorkPet(id)
	else
		self.m_tWorkSpaceCell:removeWorkPetGoldIcon(id)
	end
end

--@brief 	移除掉已经收获的打工宠物的数据
function SceneFamily:_removeWorkDataById(id)
	-- body
	for i = 1, #self.m_tWorkerData do
		if self.m_tWorkerData[i].playerPetId == id then
			table.remove(self.m_tWorkerData, i)
			break 
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
