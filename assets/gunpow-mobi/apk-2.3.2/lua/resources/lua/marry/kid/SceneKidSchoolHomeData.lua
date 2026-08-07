--SceneKidSchoolHomeData.lua
--@brief	SceneKidSchoolHome的数据模块
--@date		2021/5/10
--@author	yrd
--@note		小孩雇佣佣人界面

KID_MAP_SIZEX = 45 --一块草皮宽
KID_MAP_SIZEY = 24 --一块草皮高
KID_SCHOOL_MAP_ROW = 42 --草皮行数(列数也相同)
KID_SCHOOL_MAP_WIDTH = KID_SCHOOL_MAP_ROW * KID_MAP_SIZEX --1890
KID_SCHOOL_MAP_HEIGHT = KID_SCHOOL_MAP_ROW * KID_MAP_SIZEY --1008
KIDMAP_REAL_WIDTH = math.ceil(math.sqrt(KID_MAP_SIZEX*KID_MAP_SIZEX/4 + KID_MAP_SIZEY * KID_MAP_SIZEY/4))

SceneKidSchoolHome = {
	--请不要在这里定义变量
}


--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneKidSchoolHome:_init()
	self.m_root = nil	 	  			--场景根节点
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
    self.m_nMoveX = 0 
	self.m_nMoveY = 0 
	self.m_tUsingOrnaments = nil 		--使用中的饰品Id(窗户、地板、墙纸)
	self.m_nTimeCaculate = 0 			--计时
	self.m_tKidRideData = nil 			--保存小孩骑摇摇车数据，用于排序
	self.m_tFloorData = nil 			--地板数据

	self.m_tCellKidRole = {} 			--小孩形象
	self.m_tRandomGrid = nil 			--随机格子。用于随机角色，孩子的随机位置
	self.m_tIsRoleMove = {} 			--是否在移动
	self.m_tRandomTime = nil 			--随机时间走动
	self.m_tRolePathNode = nil 			--路径点

	self.m_nShoolId = 0					--学校id 0表示自己
	self.m_nShoolLevel = 1 				--学校等级
	self.m_nMasterId = nil 				--校长id
	self.m_tMyChildId = {}				--我的小孩id
	self.m_tMyChildName = nil 			--我的小孩名字
	self.m_nSchoolName = nil 			--学校名字
	self.m_nSchoolEffectId = nil 		--学校效率
	self.m_sMasterName = nil 			--校长名字
	self.m_nEffectId = nil 				--学生获得的效率
	self.m_tAreaDataList = {}			--学校区域数据列表
	self.m_tKidsDataList = nil			--学校小孩数据列表
	self.m_tKidData = {} 				--空闲小孩
	self.m_tAreaObjList = {} 			--存放各区域对象 下标:1学习区,2休息区,3运动区,4科技区
	self.m_tAreaKidList = {} 			--存放各区域小孩数据 下标:1学习区,2休息区,3运动区,4科技区
	self.m_nMyKidArea = 0 				--我的孩子所在区域
	self.m_bIsBuildingCreated = false 	--建筑是否已创建
	self.m_nMaxKidCount = 20			--最大孩子数
	-- self.m_tKidStop = {} 				--是否停止随机移动,走向特定位置
	self.m_tKidNextArea = {} 			--将要移动到的下一个区域
	self.bIsFindCompleted = false 		--是否成功获取空闲区到目标位置
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneKidSchoolHome:_unInit()
	self.m_root = nil	 	  			--场景根节点
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
    self.m_nMoveX = nil 
	self.m_nMoveY = nil 
	self.m_tUsingOrnaments = nil 		--使用中的饰品Id(窗户、地板、墙纸)
	self.m_nTimeCaculate = nil 			--计时
	self.m_tKidRideData = nil 			--保存小孩骑摇摇车数据，用于排序
	self.m_tFloorData = nil 			--地板数据

	self.m_tCellKidRole = nil 			--小孩形象
	self.m_tRandomGrid = nil 			--随机格子。用于随机角色，孩子的随机位置
	self.m_tIsRoleMove = nil 			--是否在移动
	self.m_tRandomTime = nil 			--随机时间走动
	self.m_tRolePathNode = nil 			--路径点

	self.m_nShoolId = nil				--学校id 0表示自己
	self.m_nShoolLevel = nil 			--学校等级
	self.m_nMasterId = nil 				--校长id
	self.m_tMyChildId = nil				--我的小孩id
	self.m_tMyChildName = nil 			--我的小孩名字
	self.m_nSchoolName = nil 			--学校名字
	self.m_nSchoolEffectId = nil 		--学校效率
	self.m_sMasterName = nil 			--校长名字
	self.m_nEffectId = nil 				--学生获得的效率
	self.m_tAreaDataList = nil			--学校区域数据列表
	self.m_tKidsDataList = nil			--学校小孩数据列表
	self.m_tKidData = nil 				--空闲小孩
	self.m_tAreaObjList = nil 			--存放各区域对象 下标:1学习区,2休息区,3运动区,4科技区
	self.m_tAreaKidList = nil 			--存放各区域小孩数据 下标:1学习区,2休息区,3运动区,4科技区
	self.m_nMyKidArea = nil 			--我的孩子所在区域
	self.m_bIsBuildingCreated = nil 	--建筑是否已创建
	self.m_nMaxKidCount = nil			--最大孩子数
	-- self.m_tKidStop = nil 				--是否停止随机移动,走向特定位置
	self.m_tKidNextArea = nil 			--将要移动到的下一个区域
	self.bIsFindCompleted = nil 		--是否成功获取空闲区到目标位置
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneKidSchoolHome:createElement()
	if WZFileUtil:isFileExist("pack/family/pack_family_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/family/pack_family_0.plist")
    end
    self.m_createFlag = true

	local element = WZUISystem:getInstance():createElement("SceneKidSchoolHome")
	assert(element, "SceneKidSchoolHome create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口 先发协议30-5让服务端判断学校时候是否已解散
function SceneKidSchoolHome:showInterface1()
	local kidMes = CacheCenter:getPlayerInfo().childMes
	if kidMes == nil or kidMes == "[]" then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT130)
        return
    end

    ProtocolProcessorKidSchool:send_SCHOOL_EntrySchool(0)
end

--@brief 	内部接口 由30-35协议调用
function SceneKidSchoolHome:showInterface()
	-- body
	if self.m_root then 
		self.m_root:disableSchedule()
	end

	if not CheckButtonOpen(199) then
		return
	end

	--主城学校建筑进来,退出时不显示结婚界面
	if SceneCity.m_root then
		self.m_bOpenChurch = false
	else
		self.m_bOpenChurch = true
	end

	local sceneHome = SceneKidSchoolHome:createElement()
	if sceneHome then
		replaceScene(sceneHome)
	end
end

--@brief	设置学校状况数据
function SceneKidSchoolHome:setSchoolStateData(myChildId, areaType, areaNum, areaMaxNum, level, masterId, masterName, effectId, myChildName, schoolName, schoolEffectId)
	WZLog("SceneKidSchoolHome:setSchoolStateData")
	self.m_tMyChildId = myChildId
	self.m_nShoolLevel = level
	self.m_nMasterId = masterId
	self.m_sMasterName = masterName
	self.m_nEffectId = effectId
	self.m_tMyChildName = myChildName
	self.m_nSchoolName = schoolName
	self.m_nSchoolEffectId = schoolEffectId

	self.m_tAreaDataList = {}
	for i=1,#areaType do
		local tTempData = {}
		tTempData.areaType = areaType[i]
		tTempData.areaNum = areaNum[i]
		tTempData.areaMaxNum = areaMaxNum[i]
		self.m_tAreaDataList[areaType[i]] = tTempData
	end
	self:updateShoolArea()
end

--@brief	设置学校小孩数据
function SceneKidSchoolHome:setSchoolChildStateData(ids, levels, faceIds, headIds, sexs, bodyIds, areas, areaTime, positions, rewards, learnTimes, status, names, scienceTimes)
	--因为服务端只下发有更新的小孩数据
	if self.m_tKidsDataList == nil then
		self.m_tKidsDataList = {}

		self.m_tKidData = {}

		self.m_tAreaKidList = {}
		self.m_tAreaKidList[1] = {}
		for i=1,self.m_tAreaDataList[1].areaMaxNum do
			self.m_tAreaKidList[1][i] = {}
		end
		self.m_tAreaKidList[2] = {}
		for i=1,self.m_tAreaDataList[2].areaMaxNum do
			self.m_tAreaKidList[2][i] = {}
		end
		self.m_tAreaKidList[3] = {}
		for i=1,self.m_tAreaDataList[3].areaMaxNum do
			self.m_tAreaKidList[3][i] = {}
		end
		self.m_tAreaKidList[4] = {}
		for i=1,self.m_tAreaDataList[4].areaMaxNum do
			self.m_tAreaKidList[4][i] = {}
		end

		for i=1,#ids do
			local tTempData = {}
			tTempData.id = ids[i]
			tTempData.level = levels[i]
			tTempData.faceId = faceIds[i]
			tTempData.headId = headIds[i]
			tTempData.sex = sexs[i]
			tTempData.bodyId = bodyIds[i]
			tTempData.area = areas[i]
			tTempData.areaTime = areaTime[i]
			tTempData.position = positions[i]
			tTempData.reward = rewards[i]
			tTempData.learnTime = learnTimes[i]
			tTempData.status = status[i]
			tTempData.name = names[i]
			tTempData.scienceTime = scienceTimes[i]
			if status[i] == 1 then
				local bHasThisKid = false
				for j=1,#self.m_tKidsDataList do
					if ids[i] == self.m_tKidsDataList[j].id then
						bHasThisKid = true
						self.m_tKidsDataList[j] = CopyTable(tTempData)
					end
				end
				if bHasThisKid == false then
					table.insert(self.m_tKidsDataList,tTempData)
				end
			elseif status[i] == 0 then
				tTempData.status = 1
				table.insert(self.m_tKidsDataList,tTempData)
			elseif status[i] == -1 then
				for j=#self.m_tKidsDataList,1,-1 do
					if ids[i] == self.m_tKidsDataList[j].id then
						table.remove(self.m_tKidsDataList,j)
					end
				end
			end
		end

		for i=1,#self.m_tKidsDataList do
			if self.m_tKidsDataList[i].area == 0 then
				table.insert(self.m_tKidData,self.m_tKidsDataList[i])
			elseif self.m_tKidsDataList[i].area == 1 or self.m_tKidsDataList[i].area == 2 or self.m_tKidsDataList[i].area == 3 or self.m_tKidsDataList[i].area == 4 then
				self.m_tAreaKidList[self.m_tKidsDataList[i].area][self.m_tKidsDataList[i].position] = self.m_tKidsDataList[i]
			end

			-- if self.m_tKidsDataList[i].id == self.m_tMyChildId[1] then
			-- 	self.m_nMyKidArea = self.m_tKidsDataList[i].area
			-- end
		end


		self:updateChildrenArea()

	else

		for i=1,#ids do
			local tTempData = {}
			tTempData.id = ids[i]
			tTempData.level = levels[i]
			tTempData.faceId = faceIds[i]
			tTempData.headId = headIds[i]
			tTempData.sex = sexs[i]
			tTempData.bodyId = bodyIds[i]
			tTempData.area = areas[i]
			tTempData.areaTime = areaTime[i]
			tTempData.position = positions[i]
			tTempData.reward = rewards[i]
			tTempData.learnTime = learnTimes[i]
			tTempData.status = status[i]
			tTempData.name = names[i]
			tTempData.scienceTime = scienceTimes[i]

			
			if status[i] == 1 then
				local bIsFind = false
				--原位置在空闲区,移动到其他操作区
				for j=#self.m_tKidData,1,-1 do --空闲区
					if ids[i] == self.m_tKidData[j].id then
						bIsFind = true
						if self.m_tKidData[j].area ~= areas[i] then --检测孩子空闲区变化到其他区
							--小孩对象 删
							self:removeKidAniById(self.m_tKidData[j].id)
							--小孩对象 增
					        self:createOneKidAni(tTempData)

							--[[--移动空闲区角色到目标位置后再删除角色.然后在指定操作区新建角色
							self.m_tKidNextArea[j] = areas[i] --将要移动到下一个区域
							local conTemp = self:_createTempPetCon(j)
							conTemp:enableSchedule("moveKidSchedule")--]]
			            else
			            	--小孩对象 改
			            	self:setOneKidData(tTempData)
						end
					end
				end
				--原位置在其中一个操作区
				if bIsFind ~= true  then
					for j=1,4 do --4个操作区
						for k=#self.m_tAreaKidList[j],1,-1 do
							if next(self.m_tAreaKidList[j][k]) then
								if ids[i] == self.m_tAreaKidList[j][k].id then
									if self.m_tAreaKidList[j][k].area ~= areas[i] then --检测孩子区域变化
										--小孩对象 删
										self:removeKidAniById(self.m_tAreaKidList[j][k].id)
										--小孩对象 增
										self:createOneKidAni(tTempData)
									else
										--小孩对象 改
						            	self:setOneKidData(tTempData)
									end
								end
							end
						end
					end
				end
			elseif status[i] == 0 then
				tTempData.status = 1

				--小孩对象 增
				self:createOneKidAni(tTempData)
			elseif status[i] == -1 then
				--小孩对象 删
				self:removeKidAniById(ids[i])
			end

		end
		
	end

end


--@brief    创建临时容器节点
function SceneKidSchoolHome:_createTempPetCon(i)
    local conTemp = self.m_root:getChildByTag(69 - i)

    if not conTemp then 
        conTemp = WZUIContainer:create()
        conTemp:setUseAbsSize(true)
        conTemp:setAbsContentSize(GlobalMethod:CCSize(10, 10))
        conTemp:setTag(69 - i)

        self.m_root:addChild(conTemp)
    else
        conTemp = WZUIContainer:luaTo(conTemp)
    end

    return conTemp
end

function SceneKidSchoolHome:getShoolLevel()
	return self.m_nShoolLevel
end

--@brief	获得学生当前获取的效率
function SceneKidSchoolHome:getEffectId()
	return self.m_nEffectId
end

--@brief	获得学校最大效率
function SceneKidSchoolHome:getSchoolEffectId()
	return self.m_nSchoolEffectId
end

--@brief	获得学校名字
function SceneKidSchoolHome:getSchoolName()
	return self.m_nSchoolName
end

--@brief	获得自己孩子所在区域
function SceneKidSchoolHome:getMyKidArea()
	for i=1,#self.m_tKidData do
		if self.m_tMyChildId[1] == self.m_tKidData[i].id then
			self.m_nMyKidArea = self.m_tKidData[i].area
			break
		end
	end
	for i=1,4 do
		for j=#self.m_tAreaKidList[i],1,-1 do
			if next(self.m_tAreaKidList[i][j]) then
				if self.m_tMyChildId[1] == self.m_tAreaKidList[i][j].id then
					self.m_nMyKidArea = self.m_tAreaKidList[i][j].area
					break
				end
			end
		end
	end
	return self.m_nMyKidArea
end

--@brief	获得自己孩子id
function SceneKidSchoolHome:getMyChildId()
	return self.m_tMyChildId
end

--@brief	获得自己孩子名字
function SceneKidSchoolHome:getMyChildName()
	return self.m_tMyChildName
end

--@brief	判断是否是自己的孩子
function SceneKidSchoolHome:isMyChild(id)
	for i=1, #self.m_tMyChildId do
	 	if id == self.m_tMyChildId[i] then
	 		return true
	 	end
	end
	return false
end

--@brief	判断自己是否是校长
function SceneKidSchoolHome:isPrincipal()
	return self.m_nMasterId == CacheCenter:getPlayerInfo().id
end

--@brief	找出自己孩子obj
function SceneKidSchoolHome:getMayChildRole()
	local kidObj = nil
	for i=1,#self.m_tCellKidRole do
		local tKidData = self.m_tCellKidRole[i]:getData()
		local nMyChildId = SceneKidSchoolHome:getMyChildId()[1]
		if tKidData.id == nMyChildId then
			kidObj = self.m_tCellKidRole[i]
		end
	end
	for i=1,#self.m_tAreaObjList do
        local tBuildKid = self.m_tAreaObjList[i]:getKidObjList()
        for j=1,#tBuildKid do
        	if next(tBuildKid[j]) then
        		local tKidData = tBuildKid[j]:getData()
        		local nMyChildId = SceneKidSchoolHome:getMyChildId()[1]
        		if tKidData.id == nMyChildId then
					kidObj = self.m_tCellKidRole[i]
				end
        	end
        end
    end
    return kidObj
end

--@brief	更新小孩状态
function SceneKidSchoolHome:updateChildrenArea()
	self:updateFreeKids()
	self:updateBuildKid()
end

--@brief	更新空闲小孩
function SceneKidSchoolHome:updateFreeKids()
	--生成随机位置
	for i=1,#self.m_tKidData do
		self.m_tIsRoleMove[i] = false
	end
	self:generateRandomGrid()
	--创建孩子形象
	self:createAni()

    -- self.m_tRandomTime = GetRandomNum(#self.m_tKidData, 10, 3)
    self:initRandomTime(#self.m_tKidData)

	--小孩跑动
	self.m_root:enableSchedule("roleAndKidMove",0)
end

--@brief	初始化走动间隔时间 随机时间
--@param	nCount : 需要多少个随即将时间
function SceneKidSchoolHome:initRandomTime(nCount)
	self.m_tRandomTime = {}
    for i=1,nCount do
    	self.m_tRandomTime[i] = math.random(5, 15)
    end
end

--@brief	更新学校区域
function SceneKidSchoolHome:updateShoolArea()
	WZLog("SceneKidSchoolHome:updateShoolArea")
	self:initGridList()


	self.m_tUsingOrnaments = {50044,50045,50049,50050}
	local tSchoolBuildList = {
		configId = {50039,50040,50041,50042,50043,50046,50047,50051,50052,50053,50054,50055,50056,},
		indexX = {35,0,16,28,0,0,0,35,8,6,12,13,30,}, 
        indexY = {0,0,16,36,17,39,37,17,30,30,39,36,28,}, 
        flipStatus = {0,0,0,0,0,0,0,0,0,0,0,0,0,}
	}

	for i = 1, #tSchoolBuildList.configId do
		self:setOneBuildingData(tSchoolBuildList.configId[i], tSchoolBuildList.flipStatus[i], tSchoolBuildList.indexX[i], tSchoolBuildList.indexY[i])
	end

	--再出创建会把孩子刷没到,所以只一开始创建一次
	if self.m_bIsBuildingCreated ~= true then
		self.m_bIsBuildingCreated = true
		--创建房子的物品
		self:_createBuilding()
		--创建装饰品
		self:_createOrnaments()
	end
	self:updateBuildArea()

	--显示操作界面
	WndKidSchoolOperate:showOtherInfo()
end

--@brief 	初始化格子数据
function SceneKidSchoolHome:initGridList()
	self.m_tGridList = {} 				--格子数据
	for i = 1, KID_SCHOOL_MAP_ROW do 
		self.m_tGridList[i] = {}
		for j = 1, KID_SCHOOL_MAP_ROW do
			local tItem = {}
			tItem.configId = -1     --标记：-1表示可以使用；0表示不能使用；>0表示建筑物 
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
end

--@brief 	设置某一格数据
function SceneKidSchoolHome:setOneBuildingData(configId, flipStatus, indexX, indexY)
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

--@brief 	清楚某一格子建筑数据
function SceneKidSchoolHome:cleanOneGridData(indexX, indexY)
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

--@brief 	判断触摸点是否在建筑内
function SceneKidSchoolHome:judgePtInBuilding(tData)
	-- body
	if self.m_clickInfo and self.m_clickInfo.tData.configId == tData.configId and self.m_clickInfo.tData.indexX == tData.indexX and self.m_clickInfo.tData.indexY == tData.indexY then
		self.m_bIsPtInBuilding = true
	end
	WZLog("SceneKidSchoolHome:judgePtInBuilding", self.m_bIsPtInBuilding)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	根据格子X,Y索引，计算绝对坐标
--@param 	tBasicData:建筑表数据
function SceneKidSchoolHome:_getAbsPosition(indexX, indexY, tBasicData)
	-- body
	local gapX = KID_MAP_SIZEX / 2 
    local gapY = KID_MAP_SIZEY / 2 

    local tData = tBasicData
    local nConWidth = (tData.size[1][1] + tData.size[1][2]) * gapX
    local nConHeight = (tData.size[1][1] + tData.size[1][2]) * gapY
    local nAbsPointX = (indexX - 1 + indexY - 1) * gapX + nConWidth/2
    local nAbsPointY = KID_SCHOOL_MAP_HEIGHT / 2 + (indexY - indexX) * gapY

    return nAbsPointX, nAbsPointY
end

--@brief 	根据格子索引，计算层级
function SceneKidSchoolHome:getBuildZPoint(nIndexX, nIndexY, tBasicData)
	local nTempIndexX = nIndexX + tBasicData.size[1][1] - 1
	local nTempIndexY = nIndexY + tBasicData.size[1][2] - 1
	WZLog("SceneKidSchoolHome:getBuildZPoint", tBasicData.name, nIndexX, nIndexY, nTempIndexX, nTempIndexY)
	return  nTempIndexX + (KID_SCHOOL_MAP_ROW - nTempIndexY) * 100
end

--@brief 	计算两点之间的距离
function SceneKidSchoolHome:pointDis(tPoint1, tPoint2)
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
function SceneKidSchoolHome:_judgeCanPutBuilding(indexX, indexY, tBasicData, tData)
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
	-- 				WndKidSchoolOperate.m_bIsClickFunc = false
	-- 				return bCanPut 
	-- 			end
	-- 		end
	-- 	end
	-- end

	return bCanPut
end

--@brief    数据加载动画
function SceneKidSchoolHome:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function SceneKidSchoolHome:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief 	清除掉新建层中的建筑
function SceneKidSchoolHome:_cleanBuildingInNewLayer(tData)
	-- body
	local conForNewBuild = GetElement(self.m_root, "conForNewBuild_kidSchoolSceneMap", WZUIContainer)
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
function SceneKidSchoolHome:_getCanUseGridIndex(tBasicData)
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
			if nMaxY > KID_SCHOOL_MAP_ROW then 
				nMaxY = KID_SCHOOL_MAP_ROW 
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
		if nStartFindX + tBasicData.size[1][1] <= KID_SCHOOL_MAP_ROW then 
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
		if nStartFindY + tBasicData.size[1][2] - 1 <= KID_SCHOOL_MAP_ROW then 
			nStartFindX = mainIndexX
			local nMaxX = mainIndexX + nAdditionNum
			if nMaxX > KID_SCHOOL_MAP_ROW then 
				nMaxX = KID_SCHOOL_MAP_ROW 
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
		if nAdditionNum >= KID_SCHOOL_MAP_ROW/2 + 1 then 
			break
		end
	end

	if not nIndexX or not nIndexY then 
		nIndexX = KID_SCHOOL_MAP_ROW/2
		nIndexY = KID_SCHOOL_MAP_ROW/2
	end

	return nIndexX,nIndexY
end

--@brief 	刷新装饰数据
function SceneKidSchoolHome:_updateUsingOrnamentsData(configId, bAdd)
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

--@brief 	将一个整数转化为位数组
function SceneKidSchoolHome:_NumberToBits(n, nCount)
    local tBits = {}

    while n >= 0 and #tBits < nCount do
        table.insert(tBits, math.fmod(n, 2))
        n = math.floor(n/2)
    end

    return tBits
end

--@brief 	判断墙上是否存在相同的饰品
function SceneKidSchoolHome:bIsExistTheSameOrnaments(itemId)
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
function SceneKidSchoolHome:FurnitureSort2(cellList)
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
--		LogDebug("SceneKidSchoolHome:FurnitureSort temp is nil 000000000000")
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
	local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSchoolSceneMap", WZUIContainer)

	for i,v in ipairs(temp) do
		for j,k in ipairs(cellList) do
			if k.listSortIdMin == v[1] and k.lineSortIdMin == v[2] and  k.listSortIdMax == v[3] and k.lineSortIdMax == v[4] then
				if k.configId > 0 then 
					if k.configId >= (9999999-#self.m_tCellKidRole+1) and k.configId <= 9999999 then 
						for index=1,#self.m_tCellKidRole do
							if k.configId == 9999999-index+1 then 
								if self.m_tCellKidRole and self.m_tCellKidRole[index] and self.m_tCellKidRole[index].m_root then
									self.m_tCellKidRole[index].m_root:setZOrder(i)
								end
							end
						end
					else
						local nTag = (k.indexX - 1) * KID_SCHOOL_MAP_ROW + k.indexY
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
function SceneKidSchoolHome:sortBuilding()
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

				tItem.listSortIdMin = KID_SCHOOL_MAP_ROW - nTempIndexY
				tItem.lineSortIdMin = tItem.indexX
				tItem.listSortIdMax = KID_SCHOOL_MAP_ROW - tItem.indexY
				tItem.lineSortIdMax = nTempIndexX

				table.insert(tGridData, tItem)
			end
		end
	end
	--获取玩家和小孩的格子
	WZLog("SceneKidSchoolHome:sortBuilding", type(self.m_tCellKidRole))

	for i=1,#self.m_tCellKidRole do
		if self.m_tCellKidRole and self.m_tCellKidRole[i] then
			local bIsFound = false
			if self.m_tKidRideData and #self.m_tKidRideData > 0 then
				local tTempData = self.m_tCellKidRole[i]:getData()
				for k = 1, #self.m_tKidRideData do
					if tTempData and self.m_tKidRideData[k][1] == tTempData.id then 
						bIsFound = true
						local tItem = {}
						tItem.configId = 9999999-i+1
						tItem.indexX = self.m_tKidRideData[k][2]
						tItem.indexY = self.m_tKidRideData[k][3]

						local nTempIndexX = tItem.indexX + self.m_tKidRideData[k][4].size[1][1] - 1
						local nTempIndexY = tItem.indexY + self.m_tKidRideData[k][4].size[1][2] - 1

						tItem.listSortIdMin = KID_SCHOOL_MAP_ROW - nTempIndexY
						tItem.lineSortIdMin = tItem.indexX
						tItem.listSortIdMax = KID_SCHOOL_MAP_ROW - tItem.indexY
						tItem.lineSortIdMax = nTempIndexX

						table.insert(tGridData, tItem)
						break
					end
				end
			end
			if not bIsFound then 
				local tItem = {}
				local tRoleGridData = self.m_tCellKidRole[i]:getRoleGridData()
				if tRoleGridData then 
					tItem.configId = 9999999-i+1
					tItem.indexX = tRoleGridData[1]
					tItem.indexY = tRoleGridData[2]

					local nTempIndexX = tItem.indexX
					local nTempIndexY = tItem.indexY

					tItem.listSortIdMin = KID_SCHOOL_MAP_ROW - nTempIndexY
					tItem.lineSortIdMin = tItem.indexX
					tItem.listSortIdMax = KID_SCHOOL_MAP_ROW - tItem.indexY
					tItem.lineSortIdMax = nTempIndexX

					table.insert(tGridData, tItem)
				end
			end
		end
	end
	-- WZLog("SceneKidSchoolHome:sortBuilding", Serialize(tGridData))
	SceneKidSchoolHome:FurnitureSort2(tGridData)
end

--@brief 	寻路
--@param 	nIndex : kid
function SceneKidSchoolHome:findPathFinish(tPathNode, nIndex)
	-- body
	if self.m_tRolePathNode == nil then self.m_tRolePathNode = {} end
	if tPathNode then 
		self.m_tRolePathNode[nIndex] = CopyTable(tPathNode)
		self.m_tIsRoleMove[nIndex] = true
		WZLog("SceneKidSchoolHome:findPathFinish", Serialize(tPathNode))
	end
end

--@brief 	开始寻路
function SceneKidSchoolHome:startFindPath(targetX, targetY, roleIndex)
	-- body
	AStarPathfinding:SetRowAndColumnAmount(KID_SCHOOL_MAP_ROW, KID_SCHOOL_MAP_ROW)
	AStarPathfinding:SetTargetRowAndColumn(targetX, targetY)
	local tStartGrid = self.m_tRandomGrid[roleIndex]
	AStarPathfinding:SetStartPoint(tStartGrid[1], tStartGrid[2], roleIndex)
	AStarPathfinding:SetFunTable(SceneKidSchoolHome)
	AStarPathfinding:SetFindFinishCallback(self, self.findPathFinish)
	AStarPathfinding:StartFindPath()
end

--@brief 	寻路
--@param 	nIndex : kid
function SceneKidSchoolHome:findDestinationFinish(tPathNode, nIndex)
	-- body
	if self.m_tRolePathNode == nil then self.m_tRolePathNode = {} end
	if tPathNode then 
		self.m_tRolePathNode[nIndex] = CopyTable(tPathNode)
		self.m_tIsRoleMove[nIndex] = true
		WZLog("SceneKidSchoolHome:findDestinationFinish", Serialize(tPathNode))
	end
end

--@brief 	开始寻路2
function SceneKidSchoolHome:startFindDestination(targetX, targetY, roleIndex)
	-- body
	AStarPathfinding:SetRowAndColumnAmount(KID_SCHOOL_MAP_ROW, KID_SCHOOL_MAP_ROW)
	AStarPathfinding:SetTargetRowAndColumn(targetX, targetY)
	local tStartGrid = self.m_tRandomGrid[roleIndex]
	AStarPathfinding:SetStartPoint(tStartGrid[1], tStartGrid[2], roleIndex)
	AStarPathfinding:SetFunTable(SceneKidSchoolHome)
	AStarPathfinding:SetFindFinishCallback(self, self.findDestinationFinish)
	AStarPathfinding:StartFindPath()
end

--@brief 	获取格子信息
function SceneKidSchoolHome:GetGroundInfo(indexX, indexY)
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

--@brief 	生成几个随机的格子，不重复，格子上面没有物品
function SceneKidSchoolHome:generateRandomGrid()
	-- body
	self.m_tRandomGrid = {}
	while #self.m_tRandomGrid < #self.m_tKidData do 
		local nIndexX = math.random(1, KID_SCHOOL_MAP_ROW)
		local nIndexY = math.random(1, KID_SCHOOL_MAP_ROW)
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
				nIndexX = math.random(1, KID_SCHOOL_MAP_ROW)
				nIndexY = math.random(1, KID_SCHOOL_MAP_ROW)
			end
		end
	end

	WZLog("SceneKidSchoolHome:generateRandomGrid", Serialize(self.m_tRandomGrid))
end

--@brief 	不重置旧格子 多生成一个随机的格子，不重复，格子上面没有物品
function SceneKidSchoolHome:generateRandomGrid2()
	-- body
	if self.m_tRandomGrid == nil then
		self.m_tRandomGrid = {}
	end
	while #self.m_tRandomGrid < #self.m_tCellKidRole + 1 do 
		local nIndexX = math.random(1, KID_SCHOOL_MAP_ROW)
		local nIndexY = math.random(1, KID_SCHOOL_MAP_ROW)
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
				nIndexX = math.random(1, KID_SCHOOL_MAP_ROW)
				nIndexY = math.random(1, KID_SCHOOL_MAP_ROW)
			end
		end
	end

	WZLog("SceneKidSchoolHome:generateRandomGrid", Serialize(self.m_tRandomGrid))
end

--@brief 	当所站位置被家具占用后，重新随机一个位置 新位置为小孩位置半径5格之内
function SceneKidSchoolHome:reGenerateOneGrid(tCellKidRole)
	-- body
	local nIndexX = math.random(1, KID_SCHOOL_MAP_ROW)
	local nIndexY = math.random(1, KID_SCHOOL_MAP_ROW)

	local offset = 8
	if tCellKidRole then
		local tGridData = tCellKidRole:getRoleGridData()
		nIndexX = math.random(math.max(tGridData[1]-offset,0), math.min(tGridData[1]+offset,KID_SCHOOL_MAP_ROW))
		nIndexY = math.random(math.max(tGridData[2]-offset,0), math.min(tGridData[2]+offset,KID_SCHOOL_MAP_ROW))
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
			nIndexX = math.random(1, KID_SCHOOL_MAP_ROW)
			nIndexY = math.random(1, KID_SCHOOL_MAP_ROW)
			if tCellKidRole then
				local tGridData = tCellKidRole:getRoleGridData()
				nIndexX = math.random(math.max(tGridData[1]-offset,0), math.min(tGridData[1]+offset,KID_SCHOOL_MAP_ROW))
				nIndexY = math.random(math.max(tGridData[2]-offset,0), math.min(tGridData[2]+offset,KID_SCHOOL_MAP_ROW))
			end
		end
	end

	return {nIndexX, nIndexY}
end

--@brief 	当所站位置被家具占用后，重新随机一个位置 新位置为小孩位置半径5格之内
function SceneKidSchoolHome:reGenerateDestination(tCellKidRole,nTag)
	-- body

	local tGridData = tCellKidRole:getRoleGridData()
	local nIndexX = tGridData[1]
	local nIndexY = tGridData[2]
	if self.m_tKidNextArea[nTag] == 1 then
		nIndexX = 9
		nIndexY = math.random(18, 25)
	elseif self.m_tKidNextArea[nTag] == 2 then
		nIndexX = math.random(7, 13)
		nIndexY = 6
	elseif self.m_tKidNextArea[nTag] == 3 then
		nIndexX = math.random(34, 42)
		nIndexY = 36
	elseif self.m_tKidNextArea[nTag] == 4 then
		nIndexX = math.random(24, 28)
		nIndexY = math.random(15, 19)
	else
		nIndexX = tGridData[1]
		nIndexY = tGridData[2]
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
			if self.m_tKidNextArea[nTag] == 1 then
				nIndexX = 9
				nIndexY = math.random(18, 25)
			elseif self.m_tKidNextArea[nTag] == 2 then
				nIndexX = math.random(7, 13)
				nIndexY = 6
			elseif self.m_tKidNextArea[nTag] == 3 then
				nIndexX = math.random(34, 42)
				nIndexY = 35
			elseif self.m_tKidNextArea[nTag] == 4 then
				nIndexX = math.random(23, 27)
				nIndexY = math.random(15, 19)
			else
				nIndexX = tGridData[1]
				nIndexY = tGridData[2]
			end
		end
	end

	return {nIndexX, nIndexY}
end

--@brief 	摇摇车结束，删除为排序保存的数据
function SceneKidSchoolHome:deleteKidRideData(kidId)
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
function SceneKidSchoolHome:toBuyFloorAndUse()
	-- body
	local tData = self.m_tFloorData
	self:stopRoleRun(1)

    self:_createLoading()
    ProtocolProcessorKid:send_WEDDING_AddHouseBuilding(tData.fromSource, tData.basicData.id, -1, -1, tData.flipStatus)
end

--@brief 	取消购买或使用新地板
function SceneKidSchoolHome:cancelToBuyOrUseFloor()
	-- body
	self:cancelTobuildNewBuilding(self.m_tFloorData)
end

--@brief 	领取孩子奖励协议返回
function SceneKidSchoolHome:receiveRewardOk(rType, rId, rNum)

	-- if rType[1] == 1 or rType[1] == 2 or rType[1] == 3 then
	-- 	local kidObj = SceneKidSchoolHome:getMayChildRole()
	-- 	if kidObj then
	-- 		kidObj:showFloatWord(rType, rId, rNum)
	-- 	end
	-- end

	if rType[1] == 1 then
    	MsgBoxManager:showTipBox(string.format(LocalStrings.KID_TEXT239,rNum[1]))
	elseif rType[1] == 2 then
    	MsgBoxManager:showTipBox(string.format(LocalStrings.KID_TEXT240,rNum[1]))
	elseif rType[1] == 3 then
    	MsgBoxManager:showTipBox(string.format(LocalStrings.KID_TEXT241,rNum[1]))
	elseif rType[1] == 4 then
		WndRewardShow:showById(rId, rNum, nil, nil, nil, nil, nil, nil, nil, nil, true)
	end
end

--@brief 	更新学校相关红点
function SceneKidSchoolHome:updateRedDot()
    WndKidSchoolList:updateRedDot()
    WndKidSchoolOperate:updateRedDot()
	WndKidOperate:updateRedDot()
end
-------------------------------------私有方法模块End----------------------------------------
