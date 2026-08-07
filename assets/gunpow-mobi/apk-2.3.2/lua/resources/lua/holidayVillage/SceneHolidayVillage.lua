--SceneHolidayVillage.lua
--@brief	SceneHolidayVillage的UI模块
--@date		2022/05/16
--@author	XTX
--@note		度假村场景界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneHolidayVillage:onEnter(element)
	self.m_root = element
	ChangeChatChannel(Chat_Channel_HOLIDAYVILLAGE)
	ProtocolProcessorHolidayVillage:regAll()
    self.m_createFlag = false
    self:_initFieldData()
    GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_GetDivineTreeInfo,self._getDivineInfo,self)
    GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_ChooseFruit,self._chooseFruit,self)
    GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_SpeedFruit,self._speedFruit,self)
    GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_HostInfo,self.setHostData,SceneHolidayVillage)
    GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_AllPits,self.setFieldAndPlantData,SceneHolidayVillage)
    GlobalGame:getGameEventDispathcer():Add(HolidayVEvent.HolidayVEvent_PitOpResult,self.operateResult,SceneHolidayVillage)
    GlobalGame:getGameEventDispathcer():Add(HolidayVillageEvent.HolidayVillageEvent_Visitors,self.setVisitorsData,SceneHolidayVillage)
    GlobalGame:getGameEventDispathcer():Add(HolidayVillageEvent.HolidayVillageEvent_Store,self.setStoreData,SceneHolidayVillage)
	-- WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
	-- WndChat:addChatWindowToCurScene()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneHolidayVillage:onExit(element)
    if self.m_tHostInfo and not self.m_createFlag then
        WZLog("SceneHolidayVillage:onExit", self.m_tHostInfo.playerId, self.m_nPlayerId) 
	   ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_HolidayVillageOp(false, self.m_tHostInfo.playerId)
    end
	ProtocolProcessorHolidayVillage:unregAll()
    if self.m_root then 
	   self.m_root:disableSchedule()
    end
    if self.m_scheduleId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
        self.m_scheduleId = -1
    end
    if self.m_scheduleId2 ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId2)
        self.m_scheduleId2 = -1
    end
    if self.m_scheduleId3 ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId3)
        self.m_scheduleId3 = -1
    end
    if not self.m_createFlag then 
        GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_GetDivineTreeInfo,self._getDivineInfo,self)
        GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_ChooseFruit,self._chooseFruit,self)
        GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_SpeedFruit,self._speedFruit,self)
        GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_HostInfo,self.setHostData,self)
        GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_AllPits,self.setFieldAndPlantData,self)
        GlobalGame:getGameEventDispathcer():Remove(HolidayVEvent.HolidayVEvent_PitOpResult,self.operateResult,self)
        GlobalGame:getGameEventDispathcer():Remove(HolidayVillageEvent.HolidayVillageEvent_Visitors,self.setVisitorsData,self)
        GlobalGame:getGameEventDispathcer():Remove(HolidayVillageEvent.HolidayVillageEvent_Store,self.setStoreData,SceneHolidayVillage)
	   self:_unInit()
    end
end

function SceneHolidayVillage:onEnterTransitionDidFinish(element)
    self.m_tDivineTreeInfo = nil 
    self:_setSceneState()
	self.m_tRandomTime = GetRandomNum(21, 30, 1)
	self:_initData()
    self:generateRandomGrid()

	local playerInfo = CacheCenter:getPlayerInfo()
	ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_HolidayVillageOp(true, self.m_nPlayerId)
    if playerInfo.id == self.m_nPlayerId then 
    --    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_TreeDetails()
        ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WarehouseOp(2)
    end
	self:createOperateWin()
--	self:_initMap()
end

--@brief 关闭界面
function SceneHolidayVillage:onClickClose()
    WZLog("SceneHolidayVillage:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    local scene = SceneCity:createElement()
    replaceScene(scene)
end

--@brief    触摸开始回调
function SceneHolidayVillage:onTouchBegin(element, pt, nIdx)
    -- body
    if not WndHVOperate:checkPointInBtn(pt) then
        WndHVOperate:hideRankList()
    end
    if not self:checkPointInBtn(pt) then 
        WndHVOperate:_hideOperateBtn()
    end
    if WndHVOperate.m_topCellLua then
        WndHVOperate.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

--@brief    点击建筑物回调
function SceneHolidayVillage:onClickBuildingCallBack(element, tCell, tData)
    -- body
    if self.m_clickInfo then
        self.m_clickInfo.tCell:setArrowVisible(false)
    else
        self.m_clickInfo = {}
    end

    self.m_clickInfo.element = element
    self.m_clickInfo.tCell = tCell
    self.m_clickInfo.tData =tData
    tCell:setArrowVisible(true)

    WndHVOperate:onClickBuildingCallBack()
    if tData.plantId > 0 and tData.plantStatus == PLANT_STATUS.MATURITY then 
        if self:isMyHolidayVillage() then 
            self:setOperateType(5)
        else
            self:setOperateType(6)
        end
    else
        self:setOperateType(0)
    end
end 

--@brief    挖坑回调
function SceneHolidayVillage:digCallBack(tGridData)
    WZLog("SceneHolidayVillage:digCallBack", self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1)
    self:_createOperateAni(self.m_nOperateType)
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, 0)
end

--@brief    播种回调
function SceneHolidayVillage:sowCallBack(tGridData)
    WZLog("SceneHolidayVillage:sowCallBack", self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, self.m_tSeedData.basicInfo.id)
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, self.m_tSeedData.basicInfo.id)
end

--@brief    浇水回调
function SceneHolidayVillage:waterCallBack(tGridData)
    WZLog("SceneHolidayVillage:waterCallBack", self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1)
    self:_createOperateAni(self.m_nOperateType, tGridData)
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, 0)
end

--@brief    捕捉回调
function SceneHolidayVillage:catchCallBack(tGridData)
    WZLog("SceneHolidayVillage:catchCallBack", self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1)
    self:_createOperateAni(self.m_nOperateType, tGridData)
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, 0)
end

--@brief    收获/偷取回调
function SceneHolidayVillage:collectCallBack(tGridData)
    WZLog("SceneHolidayVillage:collectCallBack", self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1)
    self:_createOperateAni(self.m_nOperateType)
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, 0)
end

--@brief    施肥回调
function SceneHolidayVillage:fertilizerCallBack(tGridData)
    WZLog("SceneHolidayVillage:fertilizerCallBack", self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, self.m_tSeedData.basicInfo.id)
    self:_createOperateAni(self.m_nOperateType)
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, self.m_tSeedData.basicInfo.id)
end

--@brief    扩展回调
function SceneHolidayVillage:extendFieldCallBack(tGridData)
    WZLog("SceneHolidayVillage:extendFieldCallBack", self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1)
    self:_createOperateAni(self.m_nOperateType)
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_PitOp(self.m_nPlayerId, self.m_nOperateType, tGridData.fieldId - 1, 0)
end

--@brief    点击度假村土坑按钮回调
function SceneHolidayVillage:onClickHVBtn(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    WZLog("SceneHolidayVillage:onClickHVBtn", nTag)
    WndHVOperate:onClickOperateCallBack(nTag, element)
    WndHVOperate:_hideOperateBtn()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化数据
function SceneHolidayVillage:_initData()
	self.m_tIsRoleMove = {}
    for i = 1, self.m_nMaxVisitorCount + 1 + self.m_nMaxSpiritCount do
        self.m_tIsRoleMove[i] = false
    end

	--初始化格子数据
	self:_initGridData()
end

--@brief 	创建夫妻双方、创建佣人、创建小孩形象
function SceneHolidayVillage:createAni()
	-- body
	--显示夫妻形象
    if self:isMyHolidayVillage() then 
	   self:createHostRole()
    end
    --显示拜访者形象
    self:createVisiting()
    --显示精灵形象
    self:createSpirit()

    self:sortBuilding()
end

--@brief    显示操作窗口
function SceneHolidayVillage:createOperateWin()
    -- body
    --添加操作窗口
    local multiTouchPanel = GetElement(self.m_root, "multiTouchPanel_SceneHolidayVillage", WZUIMultiTouchPanel)
    local element = WndHVOperate:createElement()
    WndHVOperate:setWinType(0)
    multiTouchPanel:addChild(element)
end

--@brief    延时创建建筑
function SceneHolidayVillage:delayCreateBuilding()
    local self = SceneHolidayVillage

    if self.m_scheduleId ~= -1 then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_scheduleId)
        self.m_scheduleId = -1
    end

    self:_createBuilding()
end

--@brief    创建家园建筑
function SceneHolidayVillage:_createBuilding()
    -- body
    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)

    for i = 1, #self.m_tGridList do
        for j = 1, #self.m_tGridList[i] do 
            --建筑
            self:_createOneBuilding(i, j, conForBuilding)
        end
    end

    self:sortBuilding()

    --精灵守护自动操作
    conForBuilding:enableSchedule("updateBuildingSchedule", 1)
end

--@brief    创建某一建筑
function SceneHolidayVillage:updateBuildingSchedule(element,dt)
    
    local bOpen1 = false --是否自动挖坑
    local bOpen2 = false --是否自动浇水
    if self.m_tSpiritList then
        for i=1,#self.m_tSpiritList do
            local effect_id = GDatatab_holiday_spirit["id_"..self.m_tSpiritList[i].spiritId].effect_id
            local tEffectInfo = GDatatab_holiday_spirit_effect["id_"..effect_id]
            if tEffectInfo.type == 5 and self.m_tSpiritList[i].spiritSatiety >= tEffectInfo.satiety then
                bOpen1 = true
            end
            if tEffectInfo.type == 6 and self.m_tSpiritList[i].spiritSatiety >= tEffectInfo.satiety then
                bOpen2 = true
            end
        end 
    end
    if bOpen1 or bOpen2 or bOpen3 then
        for i=1,#self.m_tCellFieldObjList do
            if bOpen1 then
                self.m_tCellFieldObjList[i]:autoOperateBuild1()
            end
            if bOpen2 then
                self.m_tCellFieldObjList[i]:autoOperateBuild2()
            end
        end
    end
end

--@brief    创建某一建筑
function SceneHolidayVillage:_createOneBuilding(indexX, indexY,con)
    -- body
    local conForBuilding = con 

    if self.m_tGridList[indexX][indexY].configId > 0 then
    	WZLog("SceneHolidayVillage:_createOneBuilding", self.m_tGridList[indexX][indexY].configId, indexX, indexY)
        local nTag = (indexX - 1) * HVMAP_ROW + indexY
        if conForBuilding:getChildByTag(nTag) then 
            local element = conForBuilding:getChildByTag(nTag)
            element = WZUIContainer:luaTo(element)
            local tCell = element:getLuaObjectIndex()
            if tCell then 
                tCell:setBuildingData(self.m_tGridList[indexX][indexY])
                return 
            else
                conForBuilding:removeChildByTag(nTag, true)
            end
        end
        local celElement, tNewObj = CellHVBuilding:createElement(0)
        if celElement and tNewObj then
            celElement:setTag(nTag)
            conForBuilding:addChild(celElement)
            tNewObj:setBuildingData(self.m_tGridList[indexX][indexY])
            celElement:setUseAbsCoordinate(true)
            local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, self.m_tGridList[indexX][indexY].basicData)
            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
            if self.m_tGridList[indexX][indexY].configId == 22 then 
                self.m_tCellHouse = tNewObj
                self:updateWaterWheel(2)
            elseif self.m_tGridList[indexX][indexY].configId == 25 then 
                self.m_tCellRightHouse = tNewObj
                self:updateWaterWheel(1)
            end
            if self.m_tGridList[indexX][indexY].configId > 0 and self.m_tGridList[indexX][indexY].configId < 20 then
                table.insert(self.m_tCellFieldObjList, tNewObj)
            end
        end

    end
end

--@brief    初始化家园底图
function SceneHolidayVillage:_initMap()
    -- body
    WZLog("SceneHolidayVillage:_initMap")
    local conForMap = GetElement(self.m_root, "conForMap_holidayVillageMap", WZUIContainer)
--    conForMap:removeAllChildrenWithCleanup(true)

    local gapX = HVMAP_SIZEX / 2 
    local gapY = HVMAP_SIZEY / 2 

    local floorPath = "ui/kid/kidicon/kid_floor07.png"
    local floorPath2 = "ui/kid/kidicon/kid_floor01.png"
   
    for i = 1, HVMAP_ROW do
        local startX = 0 + (i - 1) * gapX
        local startY = HVMAP_HEIGHT / 2 - (i - 1) * gapY
        for j = 1, HVMAP_ROW do
            local imgMap = WZUIImage:create()
            imgMap:setUseOriginSize(true)
            imgMap:setUseAbsCoordinate(true)
            if self.m_tGridList[i][j].configId >= 0 then 
            	imgMap:setFile(floorPath2)
            -- else
            -- 	if math.fmod(i + j, 2) == 0 then
            -- 		imgMap:setFile(floorPath)
            -- 	else
            -- 		imgMap:setFile(floorPath2)
            -- 	end
            end
            imgMap:setOpacity(100)
            imgMap:setAbsPosition(GlobalMethod:ccp(startX + j * gapX, startY + (j - 1) * gapY))
            conForMap:addChild(imgMap)
        end
    end
end

--@brief 	创建度假村主人的形象
function SceneHolidayVillage:createHostRole(bRemove, hostData)
    local nRoleTag1 = 300000
	local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
	if conForBuilding:getChildByTag(nRoleTag1) then
        if bRemove then 
            self.m_tIsRoleMove[1] = false
	       	conForBuilding:removeChildByTag(nRoleTag1, true)
            self.m_tCellHost = nil 
        end
        return 
	end

	local tBasicData = {}
	tBasicData.size = {{1,1}}
    local tPlayerGrid = {}
    table.insert(tPlayerGrid, self.m_tRandomGrid[1])
	local tCellTempTime
	if self:isMyHolidayVillage() then
		local tItems = CacheCenter:getPlayerItems()
		local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
		local tEquip = {}
		for k,v in pairs(tItems) do
			if v.isUse == true then
				table.insert(tEquip, v)
			end
		end

		local tData = {}
		tData.sex = CacheCenter:getPlayerInfo().sex 
		tData.tEquip = tEquip
		tData.headColor = headColor
		tData.bodyColor = bodyColor
		local element, tNewObj = CellKidRole:createElement()
    	if element and tNewObj then
    		tNewObj:setData(tData, 5)
            element:setUseAbsCoordinate(true)
            local tGridBySex = tPlayerGrid[1]
            tNewObj:setRoleGridData(tGridBySex)
            local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tBasicData)
            element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + HVMAP_SIZEY))
			element:setTag(nRoleTag1)
            element:setShowAll(true)
            element:setZOrder((tGridBySex[1] - 1) + (HVMAP_ROW - tGridBySex[2]) * HVMAP_ROW)
    		conForBuilding:addChild(element)
    		self.m_tCellHost = tNewObj
    	end
    else
        if hostData then 
        	local tEquip = {}
    	    table.insert(tEquip, hostData.headId)
    	    table.insert(tEquip, hostData.faceId)
    	    table.insert(tEquip, hostData.bodyId)
    	    table.insert(tEquip, hostData.wingId)

    		local tData = {}
    		tData.sex = hostData.sex
    		tData.tEquip = tEquip
    		tData.headColor = hostData.headColor
    		tData.bodyColor = hostData.bodyColor
    		local element, tNewObj = CellKidRole:createElement()
        	if element and tNewObj then
        		tNewObj:setData(tData, 5)
    			element:setUseAbsCoordinate(true)
                local tGridBySex = tPlayerGrid[1]
                tNewObj:setRoleGridData(tGridBySex)
                local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tBasicData)
                element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + HVMAP_SIZEY))

    			element:setTag(nRoleTag1)
                element:setShowAll(true)
                element:setZOrder((tGridBySex[1] - 1) + (HVMAP_ROW - tGridBySex[2]) * HVMAP_ROW)
        		conForBuilding:addChild(element)
        		self.m_tCellHost = tNewObj
        	end
        end
	end
end

--@brief    创建拜访者形象
function SceneHolidayVillage:createVisiting()
    -- body
    if self.m_root == nil then return end

    WZLog("WndKidServant:createVisiting", Serialize(self.m_tVisitorsList))
    local nVisitorInitTag = 100000 --拜访者初始tag 范围[100000,100001,100002]

    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    for i=1,self.m_nMaxVisitorCount do
        local tempTag = nVisitorInitTag+i-1
        if conForBuilding:getChildByTag(tempTag) then
            conForBuilding:removeChildByTag(tempTag, true)
        end
    end

    self.m_tCellVisitorRole = {}
    local tVisitorGrid = {}
    for i = 1, self.m_nMaxVisitorCount do
    	self.m_tIsRoleMove[i + 1] = false    --第一个留给主人
    	table.insert(tVisitorGrid, self.m_tRandomGrid[i + 1])
    end

    for i=1,#self.m_tVisitorsList do
        self:_createOneVisitor(i, self.m_tVisitorsList[i])
    end
end

--@brief    创建一个访客玩家
function SceneHolidayVillage:_createOneVisitor(i, visitorData)
    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    local tVisitorGrid = {}
    for j = 1, self.m_nMaxVisitorCount do
        table.insert(tVisitorGrid, self.m_tRandomGrid[j + 1])
    end
    local nVisitorInitTag = 100000 --拜访者初始tag 范围[100000,100001,100002]

    local tempTag = nVisitorInitTag+i-1

    local tEquip = {}
    table.insert(tEquip, visitorData.headId)
    table.insert(tEquip, visitorData.faceId)
    table.insert(tEquip, visitorData.bodyId)
    table.insert(tEquip, visitorData.wingId)

    local tData = {}
    tData.name = visitorData.name
    tData.sex = visitorData.sex
    tData.tEquip = tEquip
    tData.headColor = visitorData.headColor
    tData.bodyColor = visitorData.bodyColor
    tData.playerId = visitorData.playerId
    local element, tNewObj = CellKidRole:createElement()
    if element and tNewObj then
        tNewObj:setData(tData, 5)
        element:setUseAbsCoordinate(true)
        local tGridBySex = tVisitorGrid[i]
        tNewObj:setRoleGridData(tGridBySex)
        local tTempData = {}
        tTempData.size = {{1,1}}
        local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tTempData)
        element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + HVMAP_SIZEY))

        element:setTag(tempTag)
        element:setShowAll(true)
        element:setZOrder((tGridBySex[1] - 1) + (HVMAP_ROW - tGridBySex[2]) * HVMAP_ROW)
        conForBuilding:addChild(element)

        self.m_tCellVisitorRole[i] = tNewObj
    end
end


--@brief    创建精灵形象
function SceneHolidayVillage:createSpirit()
    if self.m_root == nil then return end

    WZLog("SceneHolidayVillage:createSpirit", Serialize(self.m_tSpiritList))
    local nSpiritInitTag = 200000 --精灵初始tag 范围[200000,200001,200002]

    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    for i=1,self.m_nMaxSpiritCount do
        local tempTag = nSpiritInitTag+i-1
        if conForBuilding:getChildByTag(tempTag) then
            conForBuilding:removeChildByTag(tempTag, true)
        end
    end

    self.m_tCellSpiritRoles = {}
    local tVisitorGrid = {}
    for i = 1, self.m_nMaxSpiritCount do
        self.m_tIsRoleMove[i + 1 + self.m_nMaxVisitorCount] = false

        --精灵睡眠时,放置在固定位置
        if self.m_tSpiritList[i] then
            if self.m_tSpiritList[i].spiritSatiety < self.m_nSleepValue then
                self.m_tRandomGrid[i + self.m_nMaxVisitorCount + 1] = {self.m_tSleepPosition[1][1]+(i-1)*2,self.m_tSleepPosition[1][2]+(i-1)*2}
            end
        end
    end

    for i=1,#self.m_tSpiritList do
        self:_createOneSpirit(i, self.m_tSpiritList[i])
    end
end

--@brief    创建一个精灵
function SceneHolidayVillage:_createOneSpirit(i, visitorData)
    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    local tSpiritGrid = {}
    for j = 1, self.m_nMaxSpiritCount do
        table.insert(tSpiritGrid, self.m_tRandomGrid[j + self.m_nMaxVisitorCount + 1])
    end
    local nSpiritInitTag = 200000 --精灵初始tag 范围[200000,200001,200002]

    local tempTag = nSpiritInitTag+i-1

    local tData = {}
    tData.spiritId = visitorData.spiritId
    tData.spiritStep = visitorData.spiritStep
    tData.spiritLevel = visitorData.spiritLevel
    tData.spiritSatiety = visitorData.spiritSatiety
    local element, tNewObj = CellKidRole:createElement()
    if element and tNewObj then
        tNewObj:setData(tData, 6)
        element:setUseAbsCoordinate(true)
        local tGridBySex = tSpiritGrid[i]
        tNewObj:setRoleGridData(tGridBySex)
        local tTempData = {}
        tTempData.size = {{1,1}}
        local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tTempData)
        element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + HVMAP_SIZEY))

        element:setTag(tempTag)
        element:setShowAll(true)
        element:setZOrder((tGridBySex[1] - 1) + (HVMAP_ROW - tGridBySex[2]) * HVMAP_ROW)
        conForBuilding:addChild(element)

        self.m_tCellSpiritRoles[i] = tNewObj

        if visitorData.spiritSatiety < self.m_nSleepValue then
            if tNewObj:getAnimationName() ~= "sleep" then 
                tNewObj:playAnimationByName("sleep")
            end
            tNewObj:showHungerStatus(true)
        else
            tNewObj:showHungerStatus(false)
        end
    end
end

--@brief    角色小孩移动
function SceneHolidayVillage:roleAndKidMove(element, delta)
    self:_setSceneState()
    self:_updatePlantTime(delta)
    if self.m_tIsRoleMove == nil then return end 

    self.m_nTimeCaculate = self.m_nTimeCaculate + delta
    if self.m_nTimeCaculate >= 1 and self.m_tRandomTime then 
        self.m_nTimeCaculate = self.m_nTimeCaculate - 1

        self:checkMoveRandomTime()
        for i = 1, #self.m_tRandomTime do
            if self.m_tRandomTime[i] > 0 then 
                self.m_tRandomTime[i] = self.m_tRandomTime[i] - 1
            else
                self.m_tRandomTime[i] = math.random(5, 15)
                if self.m_tIsRoleMove[i] == false then 
                    local bFindPath = false 
                    local tCellRoleObj = nil
                    if i == 1 and self.m_tCellHost then 
                        bFindPath = true
                        tCellRoleObj = self.m_tCellHost
                    elseif (i - 1 <= self.m_nMaxVisitorCount) and self.m_tCellVisitorRole and self.m_tCellVisitorRole[i - 1] then
                        bFindPath = true
                        tCellRoleObj = self.m_tCellVisitorRole[i - 1]
                        --如果已经隐藏，不再寻路
                        if not tCellRoleObj:getRoleVisible() then 
                            bFindPath = false 
                        end
                    elseif (i - self.m_nMaxVisitorCount - 1 <= self.m_nMaxSpiritCount) and self.m_tCellSpiritRoles and self.m_tCellSpiritRoles[i - self.m_nMaxVisitorCount - 1] then
                        bFindPath = true
                        tCellRoleObj = self.m_tCellSpiritRoles[i - self.m_nMaxVisitorCount - 1]
                        --如果已经隐藏，不再寻路
                        if not tCellRoleObj:getRoleVisible() then 
                            bFindPath = false 
                        end
                        --精灵睡眠时,不寻路
                        if tCellRoleObj:getData().spiritSatiety < self.m_nSleepValue then
                            bFindPath = false
                        end
                    end
                    if bFindPath then 
                        local tTargetGrid = self:reGenerateOneGrid(tCellRoleObj)
                        self:startFindPath(tTargetGrid[1], tTargetGrid[2], i)
                    end
                end
            end
        end
    end
    --度假村主的跑动
    local nPlayerIndex = 1
    if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellHost then
        local tGridData = self.m_tCellHost:getRoleGridData()
        local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
        local step = 1
        if nGridNum > 0 and tGridData then 
            if self.m_tCellHost:getAnimationName() ~= "run" then 
                self.m_tCellHost:playAnimationByName("run")
            end
            local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
            if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                step = 0
            end
            
            self:_addBySpeed(self.m_tCellHost, step, tGridData, tNextGridData, nPlayerIndex)
        else
            self.m_tIsRoleMove[nPlayerIndex] = false 
            if self.m_tCellHost:getAnimationName() ~= "wait0" then 
                self.m_tCellHost:playAnimationByName("wait0")
            end
        end
    end
    --访问者跑动
    for i = 1, self.m_nMaxVisitorCount do
        if self.m_tIsRoleMove[nPlayerIndex + i] and self.m_tCellVisitorRole[i] then
            local tGridData = self.m_tCellVisitorRole[i]:getRoleGridData()
            local nGridNum = #self.m_tRolePathNode[nPlayerIndex + i]
            local step = 1
            if nGridNum > 0 and tGridData then 
                if self.m_tCellVisitorRole[i]:getAnimationName() ~= "run" then 
                    self.m_tCellVisitorRole[i]:playAnimationByName("run")
                end
                local tNextGridData = self.m_tRolePathNode[nPlayerIndex + i][nGridNum]
                if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                    step = 0
                end
                
                self:_addBySpeed(self.m_tCellVisitorRole[i], step, tGridData, tNextGridData, nPlayerIndex + i)
            else
                self.m_tIsRoleMove[nPlayerIndex + i] = false 
                if self.m_tCellVisitorRole[i]:getAnimationName() ~= "wait0" then 
                    self.m_tCellVisitorRole[i]:playAnimationByName("wait0")
                end
            end
        end
    end
    --精灵跑动
    nPlayerIndex = nPlayerIndex + self.m_nMaxVisitorCount
    for i = 1, self.m_nMaxSpiritCount do
        if self.m_tIsRoleMove[nPlayerIndex + i] and self.m_tCellSpiritRoles[i] then
            local tGridData = self.m_tCellSpiritRoles[i]:getRoleGridData()
            local nGridNum = #self.m_tRolePathNode[nPlayerIndex + i]
            local step = 1
            if nGridNum > 0 and tGridData then 
                if self.m_tCellSpiritRoles[i]:getAnimationName() ~= "run" then
                    self.m_tCellSpiritRoles[i]:playAnimationByName("run")
                end
                local tNextGridData = self.m_tRolePathNode[nPlayerIndex + i][nGridNum]
                if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                    step = 0
                end
                
                self:_addBySpeed(self.m_tCellSpiritRoles[i], step, tGridData, tNextGridData, nPlayerIndex + i)
            else
                self.m_tIsRoleMove[nPlayerIndex + i] = false 
                if self.m_tCellSpiritRoles[i]:getAnimationName() ~= "wait" then
                    self.m_tCellSpiritRoles[i]:playAnimationByName("wait")
                end
            end
        end
    end
end

--@brief    移动计算
function SceneHolidayVillage:_addBySpeed(tCell, step, tGridData, tNextGridData, roleIndex)
    -- body
    if tCell.m_root == nil then return end 
    
    local speed = 6
    local tTempData = {}
    tTempData.size = {{1,1}}
    local nAbsX1, nAbsY1 = self:_getAbsPosition(tGridData[1], tGridData[2], tTempData)
    local nAbsX2, nAbsY2 = self:_getAbsPosition(tNextGridData[1], tNextGridData[2], tTempData)
    local ptDis = math.sqrt((nAbsX2-nAbsX1) * (nAbsX2-nAbsX1) + (nAbsY2-nAbsY1) * (nAbsY2-nAbsY1))
    local angelValue = math.asin((nAbsY2 - nAbsY1) / ptDis)

    local originPositionX = tCell.m_root:getAbsPosition().x
    local originPositionY = tCell.m_root:getAbsPosition().y
--    WZLog("SceneHolidayVillage:_addBySpeed 000", originPositionX, originPositionY)
    local nCurPositionX, nCurPositionY
    if step == 0 then --向右移动
        nCurPositionX = originPositionX + speed * math.cos(angelValue)
        if tCell.m_nType == 6 then
            if tCell:getPlayer():getScaleX() < 0 then
                WZLog("tCell:getPlayer():setFlipY(false)")
                tCell:getPlayer():setScaleX(1)
            end
        else
            if tCell:getPlayer():isFlipX() == true then
                WZLog("tCell:getPlayer():setFlipY(false)")
                tCell:getPlayer():setFlipX(false)
            end
        end
    elseif step == 1 then --向左移动
        nCurPositionX = originPositionX - speed * math.cos(angelValue)
        if tCell.m_nType == 6 then
            if tCell:getPlayer():getScaleX() >= 0 then
                WZLog("tCell:getPlayer():setFlipY(true)")
                tCell:getPlayer():setScaleX(-1)
            end
        else
            if tCell:getPlayer():isFlipX() == false then
                WZLog("tCell:getPlayer():setFlipY(true)")
                tCell:getPlayer():setFlipX(true)
            end
        end
    end

    nCurPositionY = originPositionY + speed * math.sin(angelValue)
    local bNextGrid = false 
    if tGridData[1] > tNextGridData[1] and tGridData[2] == tNextGridData[2] then --向上
        if nCurPositionX <= nAbsX2 then 
            nCurPositionX = nAbsX2
            bNextGrid = true
        end
        if nCurPositionY >= nAbsY2 + HVMAP_SIZEY then 
            nCurPositionY = nAbsY2 + HVMAP_SIZEY
            bNextGrid = true
        end
    elseif tGridData[1] < tNextGridData[1] and tGridData[2] == tNextGridData[2] then --向下
        if nCurPositionX >= nAbsX2 then 
            nCurPositionX = nAbsX2
            bNextGrid = true
        end
        if nCurPositionY <= nAbsY2 + HVMAP_SIZEY then 
            nCurPositionY = nAbsY2 + HVMAP_SIZEY
            bNextGrid = true
        end
    elseif tGridData[1] == tNextGridData[1] and tGridData[2] > tNextGridData[2] then --向左
        if nCurPositionX <= nAbsX2 then 
            nCurPositionX = nAbsX2
            bNextGrid = true
        end
        if nCurPositionY <= nAbsY2 + HVMAP_SIZEY then 
            nCurPositionY = nAbsY2 + HVMAP_SIZEY
            bNextGrid = true
        end
    elseif tGridData[1] == tNextGridData[1] and tGridData[2] < tNextGridData[2] then --向右
        if nCurPositionX >= nAbsX2 then 
            nCurPositionX = nAbsX2
            bNextGrid = true
        end
        if nCurPositionY >= nAbsY2 + HVMAP_SIZEY then 
            nCurPositionY = nAbsY2 + HVMAP_SIZEY
            bNextGrid = true
        end
    end
    --去掉当前格子
    if bNextGrid then 
        self.m_tRandomGrid[roleIndex] = tNextGridData
        tCell:setRoleGridData(tNextGridData)
        table.remove(self.m_tRolePathNode[roleIndex])
        self:sortBuilding()
    end
--    WZLog("SceneHolidayVillage:_addBySpeed 000", nCurPositionX, nCurPositionY)

    tCell.m_root:setAbsPosition(GlobalMethod:ccp(nCurPositionX, nCurPositionY))
end

--@brief    根据时间设置场景白天和黄昏状态
function SceneHolidayVillage:_setSceneState()
    if self.m_root == nil then return end 

    local nCurTime = SystemTime:getServerTime()
    local dayCur = os.date("*t", nCurTime)
    local nNewState = 0 
    if tonumber(dayCur.hour) >= 17 or tonumber(dayCur.hour) <= 6 then 
        nNewState = 1
    end

    if self.m_nSceneState == nNewState then return end 
    self.m_nSceneState = nNewState
    local imgSky = GetElement(self.m_root, "imgSky_holidayVillageMap", WZUIImage)
    local imgGround = GetElement(self.m_root, "imgGround_holidayVillageMap", WZUIImage)
    local spineWindMill = GetElement(self.m_root, "spineWindMill_holidayVillageMap", WZUISpine)

    self:updateWaterWheel(1)
    if self.m_nSceneState == 0 then 
        imgSky:setFile("ui/holidayVillage/djc_bg_02.png")
        imgGround:setFile("ui/holidayVillage/djc_bg_01.png")
        spineWindMill:setAnimationName("wait")
    elseif self.m_nSceneState == 1 then 
        imgSky:setFile("ui/holidayVillage/djc_bg_02_1.png")
        imgGround:setFile("ui/holidayVillage/djc_bg_01_1.png")
        spineWindMill:setAnimationName("wait2")
    end

    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    for i = 1, #self.m_tConfigId do
        if self.m_tConfigId[i] >= 20 then 
            local indexX = self.m_tFieldPos[i][1] + 1
            local indexY = self.m_tFieldPos[i][2] + 1
            local nTag = (indexX - 1) * HVMAP_ROW + indexY
            if conForBuilding:getChildByTag(nTag) then 
                local element = conForBuilding:getChildByTag(nTag)
                element = WZUIContainer:luaTo(element)
                local tCell = element:getLuaObjectIndex()
                if tCell then 
                    tCell:resetBuildingImg()
                    return 
                end
            end
        end
    end
end

--@brief    创建种子图标
function SceneHolidayVillage:_createOperateIcon(operateType, tData)
    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    local nTag = 99999
    local element = conForBuilding:getChildByTag(nTag)
    if not element then 
        element = WZUIImage:create()
        element:setUseOriginSize(true)
        element:setVisible(false)
        element:setTouchEnable(false)
        element:setTag(nTag)

        conForBuilding:addChild(element)
    else
        element = WZUIImage:luaTo(element)
    end

    local extrPoint = {0, 0}
    if self.m_clickInfo and self.m_clickInfo.tData then 
        if self.m_clickInfo.tData.flowerpotId and self.m_clickInfo.tData.flowerpotId > 0 then 
            local flowerpotData = GDatatab_item["id_" .. self.m_clickInfo.tData.flowerpotId]
            if flowerpotData then
                local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
                extrPoint[1] = tonumber(tTmepArray1[4])
                extrPoint[2] = tonumber(tTmepArray1[5])
            end
        end
    end
    if operateType == 1 then --播种
        if tData then 
            local indexX, indexY = nil, nil  
            local fieldData = nil 
            if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId == 0 then 
                fieldData = self.m_clickInfo.tData
                indexX, indexY = fieldData.indexX, fieldData.indexY
            else
                indexX, indexY, fieldData = self:getNullField()
            end

            local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
            element:setVisible(true)
            element:setScale(0.5)
            element:setFile(tData.basicInfo.icon)
            element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 60 + extrPoint[2]))
            element:setZOrder(nTag)
        end
        return 
    elseif operateType == 2 then --施肥
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 and self.m_clickInfo.tData.bIsWater then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setScale(0.5)
        element:setFile(tData.basicInfo.icon)
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 60 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 3 then --浇水
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 and not self.m_clickInfo.tData.bIsWater then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setScale(0.5)
        element:setFile("ui/holidayVillage/otherImg/djc_ssh.png")
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 60 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 4 then --抓虫
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 and self.m_clickInfo.tData.plantPests > 0 then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setScale(0.5)
        element:setFile("ui/holidayVillage/otherImg/djc_byw.png")
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 60 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 5 then --采摘
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 and self.m_clickInfo.tData.plantStatus == PLANT_STATUS.MATURITY then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setScale(0.5)
        element:setFile("ui/holidayVillage/otherImg/djc_st.png")
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 6 then --偷取
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 and self.m_clickInfo.tData.plantStatus == PLANT_STATUS.MATURITY then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setScale(0.5)
        element:setFile("ui/holidayVillage/otherImg/djc_st.png")
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 8 then --挖坑
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId == 0 and not self.m_clickInfo.tData.bIsDig then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setScale(0.5)
        element:setFile("ui/holidayVillage/otherImg/djc_ct.png")
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 60 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    end

    element:setVisible(false)
end

--@brief    创建可用肥料列表
function SceneHolidayVillage:_createFertilizerList(operateType, bAdd, gridData)
    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    local nTag = 99990
    local element = conForBuilding:getChildByTag(nTag)
    if not bAdd then 
        if element then 
            conForBuilding:removeChildByTag(nTag, true)
        end
        return 
    end
    if not element and bAdd then 
        element = WndHVFertilizerList:createElement()
        element:setTag(nTag)
        WndHVFertilizerList:setData(gridData, SceneHolidayVillage)

        conForBuilding:addChild(element)
    end
    if operateType == 2 and bAdd then --施肥
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY + 100))
        element:setZOrder(nTag)
        return 
    end
end

--@brief    创建挖坑、浇水、施肥、、捕捉、采摘、偷取动作
function SceneHolidayVillage:_createOperateAni(operateType, tGridData)
    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    local nTag = 99991
    local element = conForBuilding:getChildByTag(nTag)
    if not element then 
        element = WZUISpine:create()
        element:setUseOriginSize(true)
        element:setVisible(false)
        element:setTouchEnable(false)
        element:setTag(nTag)
        element:setFileAtlas("ui/holidayVillage/ui_djc_daoju1.atlas")
        element:setFileJson("ui/holidayVillage/ui_djc_daoju1.json")

        conForBuilding:addChild(element)
    else
        element = WZUISpine:luaTo(element)
        element:setFileAtlas("")
        element:setFileJson("")
        element:setFileAtlas("ui/holidayVillage/ui_djc_daoju1.atlas")
        element:setFileJson("ui/holidayVillage/ui_djc_daoju1.json")
    end

    local extrPoint = {0, 0}
    if operateType == 1 then --播种
        return 
    elseif operateType == 2 then --施肥
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 and self.m_clickInfo.tData.bIsWater then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
            if fieldData.flowerpotId and fieldData.flowerpotId > 0 then 
                local flowerpotData = GDatatab_item["id_" .. fieldData.flowerpotId]
                if flowerpotData then
                    local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
                    extrPoint[1] = tonumber(tTmepArray1[4])
                    extrPoint[2] = tonumber(tTmepArray1[5])
                end
            end
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)   
        if self.m_tSeedData.basicInfo.id == 55202 then 
            element:setFileAtlas("")
            element:setFileJson("")
            element:setFileAtlas("ui/holidayVillage/ui_djc_daoju2.atlas")
            element:setFileJson("ui/holidayVillage/ui_djc_daoju2.json")
            element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 80 + extrPoint[2]))
            element:setAnimationName("wait_4") 
        elseif self.m_tSeedData.basicInfo.id == 55203 then 
            element:setFileAtlas("")
            element:setFileJson("")
            element:setFileAtlas("ui/holidayVillage/ui_djc_daoju2.atlas")
            element:setFileJson("ui/holidayVillage/ui_djc_daoju2.json")
            element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 80 + extrPoint[2]))
            element:setAnimationName("wait_1") 
        elseif self.m_tSeedData.basicInfo.id == 55301 then 
            element:setAnimationName("wait_9") 
            element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        elseif self.m_tSeedData.basicInfo.id == 55302 then 
            element:setFileAtlas("")
            element:setFileJson("")
            element:setFileAtlas("ui/holidayVillage/ui_djc_daoju2.atlas")
            element:setFileJson("ui/holidayVillage/ui_djc_daoju2.json")
            element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 80 + extrPoint[2]))
            element:setAnimationName("wait_3") 
        elseif self.m_tSeedData.basicInfo.id == 55303 then 
            element:setFileAtlas("")
            element:setFileJson("")
            element:setFileAtlas("ui/holidayVillage/ui_djc_daoju2.atlas")
            element:setFileJson("ui/holidayVillage/ui_djc_daoju2.json")
            element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 80 + extrPoint[2]))
            element:setAnimationName("wait_2") 
        else
            element:setAnimationName("wait_3") 
            element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        end
        element:setZOrder(nTag)
        return 
    elseif operateType == 3 then --浇水 
        local fieldData = tGridData 
        local indexX, indexY = fieldData.indexX, fieldData.indexY
        if fieldData.flowerpotId and fieldData.flowerpotId > 0 then 
            local flowerpotData = GDatatab_item["id_" .. fieldData.flowerpotId]
            if flowerpotData then
                local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
                extrPoint[1] = tonumber(tTmepArray1[4])
                extrPoint[2] = tonumber(tTmepArray1[5])
            end
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setAnimationName("wait_4") 
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 4 then --抓虫
        local fieldData = tGridData 
        local indexX, indexY = fieldData.indexX, fieldData.indexY
        if fieldData.flowerpotId and fieldData.flowerpotId > 0 then 
            local flowerpotData = GDatatab_item["id_" .. fieldData.flowerpotId]
            if flowerpotData then
                local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
                extrPoint[1] = tonumber(tTmepArray1[4])
                extrPoint[2] = tonumber(tTmepArray1[5])
            end
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setAnimationName("wait_8") 
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 5 then --采摘
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 and self.m_clickInfo.tData.plantStatus == PLANT_STATUS.MATURITY then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
            if fieldData.flowerpotId and fieldData.flowerpotId > 0 then 
                local flowerpotData = GDatatab_item["id_" .. fieldData.flowerpotId]
                if flowerpotData then
                    local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
                    extrPoint[1] = tonumber(tTmepArray1[4])
                    extrPoint[2] = tonumber(tTmepArray1[5])
                end
            end
        end

        self.m_tHarvestField = CopyTable(fieldData)
        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setAnimationName("wait_2") 
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 6 then --偷取
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId > 0 and self.m_clickInfo.tData.plantStatus == PLANT_STATUS.MATURITY then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
            if fieldData.flowerpotId and fieldData.flowerpotId > 0 then 
                local flowerpotData = GDatatab_item["id_" .. fieldData.flowerpotId]
                if flowerpotData then
                    local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
                    extrPoint[1] = tonumber(tTmepArray1[4])
                    extrPoint[2] = tonumber(tTmepArray1[5])
                end
            end
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setAnimationName("wait_2") 
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    elseif operateType == 8 or operateType == 9 then --挖坑
        local indexX, indexY = nil, nil  
        local fieldData = nil 
        if self.m_clickInfo and self.m_clickInfo.tCell and self.m_clickInfo.tData.plantId == 0 and not self.m_clickInfo.tData.bIsDig then 
            fieldData = self.m_clickInfo.tData
            indexX, indexY = fieldData.indexX, fieldData.indexY
            if fieldData.flowerpotId and fieldData.flowerpotId > 0 then 
                local flowerpotData = GDatatab_item["id_" .. fieldData.flowerpotId]
                if flowerpotData then
                    local tTmepArray1 = SplitStringWithSeparator(flowerpotData.animation_index_code, ",") 
                    extrPoint[1] = tonumber(tTmepArray1[4])
                    extrPoint[2] = tonumber(tTmepArray1[5])
                end
            end
        end

        local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, fieldData.basicData)
        element:setVisible(true)
        element:setAnimationName("wait_1") 
        element:setAbsPosition(GlobalMethod:ccp(nTempX + extrPoint[1], nTempY + 40 + extrPoint[2]))
        element:setZOrder(nTag)
        return 
    end

    element:setVisible(false)
end

--@brief    检测触摸点
function SceneHolidayVillage:checkPointInBtn(pt)
    if self.m_root == nil then return end
    local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    local nTag = 99989
    local element = conForBuilding:getChildByTag(nTag)
    local btn = nil 
    if element and element:isVisible() then 
        btn = WZUIContainer:luaTo(element)
    else
        return 
    end
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    else
        return false 
    end 
end

--@brief    自动计算作物的成长剩余时间
function SceneHolidayVillage:_updatePlantTime(delta)
    if self.m_root == nil then return end 

    self.m_nUpdatePlantTime = self.m_nUpdatePlantTime + delta
    if self.m_nUpdatePlantTime >= 1 then 
        self.m_nUpdatePlantTime = self.m_nUpdatePlantTime - 1

        local nCurTime = SystemTime:getServerTime()
        for i = 1, #self.m_tConfigId do
            local indexX = self.m_tFieldPos[i][1]
            local indexY = self.m_tFieldPos[i][2] 
            if self.m_tConfigId[i] > 0 and self.m_tConfigId[i] < 20 then 
                local fieldData = self.m_tGridList[indexX + 1][indexY + 1]
                local plantId = fieldData.plantId
                local bIsWater = fieldData.bIsWater
                local plantStatus = fieldData.plantStatus
                local plantGroupTime = fieldData.plantGroupTime
                if plantId > 0 and bIsWater then 
                    if plantStatus < PLANT_STATUS.MATURITY and nCurTime >= plantGroupTime and plantGroupTime > 0 then 
                        fieldData.plantStatus = fieldData.plantStatus + 1
                        local seedData = WndHVLibrary:getSeedDataByItemId(plantId)
                        if fieldData.plantStatus == PLANT_STATUS.SEED then 
                            fieldData.plantGroupTime = seedData.time1 + nCurTime
                        elseif fieldData.plantStatus == PLANT_STATUS.SEEDLING then
                            fieldData.plantGroupTime = seedData.time2 + nCurTime
                        elseif fieldData.plantStatus == PLANT_STATUS.MATURITY then
                            fieldData.plantGroupTime = 0
                            ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetAllPits(-1)
                            return 
                        end
                        --更新地块的作物状态
                        local nTag = indexX * HVMAP_ROW + indexY + 1
                        local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
                        if conForBuilding:getChildByTag(nTag) then 
                            local element = conForBuilding:getChildByTag(nTag)
                            element = WZUIContainer:luaTo(element)
                            local tCell = element:getLuaObjectIndex()
                            if tCell then 
                                tCell:setBuildingData(fieldData)
                            end
                        end
                    end
                    if plantStatus < PLANT_STATUS.MATURITY and plantGroupTime > 0 then 
                        --如果操作按钮和信息详情Tips存在，则更新按钮和详情
                        self:_updatePlantBtnAndDetail(fieldData)
                    end
                end
            end
        end
    end
end

--@brief    更新待扩展地块牌子上的文字
function SceneHolidayVillage:_updateExtendFieldWords(hvLevel)
    if self.m_tCellExtendField == nil or self.m_tCellExtendField2 == nil then return end 
    if self.m_tHostInfo.hvLevel == nil then return end 

    local fieldData = self.m_tCellExtendField:getData()
    local fieldConfig = WndHVField:getFieldLevelData(fieldData)
    if self.m_tHostInfo.hvLevel < fieldConfig.need_lv and hvLevel >= fieldConfig.need_lv then 
        self.m_tCellExtendField:_createExtendNode()
    end

    local fieldData = self.m_tCellExtendField2:getData()
    local fieldConfig = WndHVField:getFieldLevelData(fieldData)
    if self.m_tHostInfo.hvLevel < fieldConfig.need_lv and hvLevel >= fieldConfig.need_lv then 
        self.m_tCellExtendField2:_createExtendNode()
    end
end

--@brief    更新作物操作按钮和tips详情
function SceneHolidayVillage:_updatePlantBtnAndDetail(fieldData)
    if self.m_clickInfo and self.m_clickInfo.tData and self.m_clickInfo.tData.fieldId == fieldData.fieldId then 
        self.m_clickInfo.tData = CopyTable(fieldData)
        local conForBuilding = GetElement(self.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
        local nTagTips = 99989
        local element = conForBuilding:getChildByTag(nTagTips)
        if element and element:isVisible() then 
            WndHVOperate:onClickBuildingCallBack()
        end
    end
end

--@brief    显示自己和伴侣互动动画
function SceneHolidayVillage:showCoupleAnimation()
    local nCoupleId = 0
    local coupleMes = CacheCenter:getPlayerInfo().coupleMes
    if coupleMes and coupleMes ~= "" then 
        local tIdList = SplitStringWithSeparator(coupleMes, "|", nil, true)
        if tIdList and tIdList[7] then 
            nCoupleId = tIdList[7]
        end
    end
    local bExist = false
    if self.m_nPlayerId == nCoupleId and self.m_tCellHost and self.m_tCellHost:getRoleVisible() then
        bExist = true
    else
        if nCoupleId > 0 and self.m_tCellVisitorRole then
            for i, v in pairs (self.m_tCellVisitorRole) do
                if self.m_tCellVisitorRole[i] and self.m_tCellVisitorRole[i].getData and self.m_tCellVisitorRole[i]:getData() and self.m_tCellVisitorRole[i]:getData().playerId == nCoupleId and self.m_tCellVisitorRole[i]:getRoleVisible() then
                    bExist = true
                    break
                end
            end
        end
    end

    if self.m_tCellHost and self.m_tCellHost.m_root then
        if bExist and self.m_tCellHost:getRoleVisible() and (self.m_nPlayerId == nCoupleId or self.m_nPlayerId == CacheCenter:getPlayerInfo().id) then
            ShowCoupleAni(self.m_tCellHost.m_root, true, GlobalMethod:ccp(0.5,2.2), 0.65)
        else
            ShowCoupleAni(self.m_tCellHost.m_root, false)
        end
    end
    if self.m_tCellVisitorRole then
        for i , v in pairs (self.m_tCellVisitorRole) do
            if self.m_tCellVisitorRole[i].m_root then
                if bExist and self.m_tCellVisitorRole[i]:getRoleVisible() and (self.m_tCellVisitorRole[i]:getData().playerId == nCoupleId or self.m_tCellVisitorRole[i]:getData().playerId == CacheCenter:getPlayerInfo().id) then
                    ShowCoupleAni(self.m_tCellVisitorRole[i].m_root, true, GlobalMethod:ccp(0.5,2.2), 0.65)
                else
                    ShowCoupleAni(self.m_tCellVisitorRole[i].m_root, false)
                end
            end
        end
    end
end

--@brief    更新精灵睡眠状态
function SceneHolidayVillage:updateSpiritSleep(nIdx)
    if self.m_tSpiritList[nIdx].spiritSatiety < self.m_nSleepValue then
        if self.m_tCellSpiritRoles[nIdx]:getAnimationName() ~= "sleep" then 
            self.m_tCellSpiritRoles[nIdx]:playAnimationByName("sleep")
        end
        self.m_tCellSpiritRoles[nIdx]:showHungerStatus(true)

        --精灵睡眠时,放置在固定位置
        self.m_tRandomGrid[nIdx + self.m_nMaxVisitorCount + 1] = {self.m_tSleepPosition[1][1]+(nIdx-1)*2, self.m_tSleepPosition[1][2]+(nIdx-1)*2}
        local tTempData = {}
        tTempData.size = {{1,1}}
        local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[nIdx + self.m_nMaxVisitorCount + 1][1], self.m_tRandomGrid[nIdx + self.m_nMaxVisitorCount + 1][2], tTempData)
        self.m_tCellSpiritRoles[nIdx].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + HVMAP_SIZEY))
    else
        self.m_tCellSpiritRoles[nIdx]:showHungerStatus(false)
    end
end

--@brief    切换水车饰品
--@param    doType:1=更新水车动画；2=更新小屋
function SceneHolidayVillage:updateWaterWheel(doType, bSet)
    if self.m_tHostInfo == nil then return end 
    if doType == 1 then 
        local spineWater = GetElementWithoutAssert(self.m_root, "spineWater_holidayVillageMap", WZUISpine)

        local waterWheelId = self.m_tHostInfo.waterWheelId
        local defaultAni = {"wait3", "wait4"} 
        if waterWheelId > 0 and self.m_tCellRightHouse then 
            spineWater:setVisible(false)
        --    spineWater:setOpacity(0)
            self.m_tCellRightHouse:resetBuildingImg(waterWheelId)
        elseif waterWheelId == 0 and self.m_tCellRightHouse and bSet then 
        --    spineWater:setOpacity(255)
            spineWater:setVisible(true)
            self.m_tCellRightHouse:resetBuildingImg(waterWheelId)
        else
            spineWater:setVisible(true)
            spineWater:setAnimationName(defaultAni[self.m_nSceneState + 1])
        end
    elseif doType == 2 then 
        if self.m_tCellHouse then 
            local houseId = self.m_tHostInfo.houseId

            self.m_tCellHouse:resetBuildingImg(houseId)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
