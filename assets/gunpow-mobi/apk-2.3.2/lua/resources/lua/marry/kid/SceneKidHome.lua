--SceneKidHome.lua
--@brief	SceneKidHome的UI模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小孩雇佣佣人界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneKidHome:onEnter(element)
	self.m_root = element
    self.m_createFlag = false
	ProtocolProcessorKid:regAll()
    ProtocolProcessorKidSchool:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneKidHome:onExit(element)
	ProtocolProcessorKid:unregAll()
    if self.m_root then 
        self.m_root:disableSchedule()
    end

    if not self.m_createFlag then 
       self:_unInit()
    end
    if WZFileUtil:isFileExist("pack/family/pack_family_0.plist") and not self.m_createFlag and not SceneKidSchoolHome.m_createFlag then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/family/pack_family_0.plist")
        --163在主城添加了学校入口,所以不注销学校协议
        -- ProtocolProcessorKidSchool:unregAll()
    end
    if WZFileUtil:isFileExist("pack/kid/pack_kid_0.plist") and not self.m_createFlag and not SceneKidSchoolHome.m_createFlag then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/kid/pack_kid_0.plist")
        --163在主城添加了学校入口,所以不注销学校协议
        -- ProtocolProcessorKidSchool:unregAll()
    end
end

--@brief    场景加载完成回调
function SceneKidHome:onEnterTransitionDidFinish(element)
    -- body
    ChangeChatChannel(Chat_Channel_KidHome)
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_FAMILY)
    self.m_tRandomTime = GetRandomNum(6, 10, 3)

    self:createOperateWin()
    WZLog("SceneKidHome:onEnterTransitionDidFinish")
    if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
    	ProtocolProcessorKid:send_WEDDING_GetHouseItemCache()
    end
    self:_createLoading()
    ProtocolProcessorKid:send_WEDDING_GetHouseInfo(self.m_nPlayerId)

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)

    WndChat:addChatWindowToCurScene()

    judgeHavedRecordString(LocalStrings.KID_TEXT69, true)
    
end

--@brief    退出按钮回调
function SceneKidHome:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    replaceScene(SceneCity:createElement())
    -- SceneCity.m_bFromChurch = true
end

--@brief 	点击壁画按钮回调
function SceneKidHome:onClickWindow(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("SceneKidHome:onClickWindow")
end

--@brief 	点击壁画按钮回调
function SceneKidHome:onClickPicture(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("SceneKidHome:onClickPicture")

end

--@brief    显示操作窗口
function SceneKidHome:createOperateWin()
    -- body
    --添加操作窗口
    local multiTouchPanel = GetElement(self.m_root, "multiTouchPanel_SceneKidHome", WZUIMultiTouchPanel)
    multiTouchPanel:addChild(WndKidOperate:createElement())
end

--@brief    初始化场景
--@note
function SceneKidHome:initScene()
    local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneKidHome"))

    self.m_tWinSize = CCEGLView:sharedOpenGLView():getFrameSize()
    local scaleY = self.m_tWinSize.height/640
    local scaleX = self.m_tWinSize.width/1136
    local realScale = scaleY/scaleX
    
    scene:setResistance(0.8)
    scene:setScaleX(realScale)
    if scaleX < scaleY then
        local diff = 1136*scaleY-self.m_tWinSize.width
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(1136-diff,640))
        print("SceneKidHome:initScene one", scaleY, scaleX, diff)
    else
        local diff = self.m_tWinSize.width - 1136*scaleY
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(1136+diff,640))
        print("SceneKidHome:initScene TWO", scaleY, scaleX, diff)
    end
    --]]
    local playerLayer = scene:getPlayerLayer()
    self.m_tSceneLayer = scene
    self.m_tPlayerLayer = playerLayer
    playerLayer:setDrawInfo(false)
    playerLayer:setStartMoveCallback("startMoveCallback")
    playerLayer:setEndMoveCallback("endMoveCallback")
    playerLayer:setNextMoveCellCallback("nextMoveCellCallback")

    FigureSceneManager:getInstance():setCurrentScene(self, Chat_Channel_KidHome)
    FigureSceneManager:getInstance():setFigureLayer(self.m_tPlayerLayer)

    self:_initMap()
end

--@brief    初始化家园底图
function SceneKidHome:_initMap(itemId)
    -- body
    WZLog("SceneKidHome:_initMap")
    local conForMap = GetElement(self.m_root, "conForMap_kidSceneMap", WZUIContainer)
    conForMap:removeAllChildrenWithCleanup(true)

    local gapX = KID_MAP_SIZEX / 2 
    local gapY = KID_MAP_SIZEY / 2 

    local floorPath = GDatatab_house_building["id_" .. (itemId or 50034)].animation
   
    for i = 1, KID_MAP_ROW do
        local startX = 0 + (i - 1) * gapX
        local startY = KID_MAP_HEIGHT / 2 - (i - 1) * gapY
        for j = 1, KID_MAP_ROW do
            local imgMap = WZUIImage:create()
            imgMap:setUseOriginSize(true)
            imgMap:setUseAbsCoordinate(true)
            if math.fmod(i + j, 2) == 0 then
                imgMap:setFile(floorPath)
            else
                imgMap:setFile(floorPath)
            end
        --    imgMap:setOpacity(100)
            imgMap:setAbsPosition(GlobalMethod:ccp(startX + j * gapX, startY + (j - 1) * gapY))
        --    WZLog("SceneKidHome:_initMap   position(%d, %d)-(%d, %d)", i, j, startX + j * gapX, startY + (j - 1) * gapY)
            conForMap:addChild(imgMap)
        end
    end
end

--@brief    开始移动
function SceneKidHome:startMoveCallback(element,node,x,y)
    FigureSceneManager:getInstance():startMoveCallback(element,node,x,y)
end

--@brief    移动中
function SceneKidHome:nextMoveCellCallback(element,node,x,y,index)
    FigureSceneManager:getInstance():nextMoveCellCallback(element,node,x,y,index)
end

--@brief    结束移动
function SceneKidHome:endMoveCallback(element,node)
    FigureSceneManager:getInstance():endMoveCallback(element,node)
end


--@brief    触摸开始回调
function SceneKidHome:onTouchBegin(element, pt, nIdx)
    -- body
    if not WndKidOperate:checkPointInBtn(pt) then
        WndKidOperate:hideRankList()
    end
    
    if not WindowManager:getActiveWindow() then 
        WndKidOperate.m_bIsClickFunc = false
    end
    self.m_startPoint = {} 
    self.m_startPoint.x = pt.x 
    self.m_startPoint.y = pt.y 
    self.m_nTouchInBuildingState = 0 
    if self.m_tTouchPoint == nil then 
        self.m_tTouchPoint = {}
    end
--    WZLog("SceneKidHome:onTouchBegin", nIdx)
    if self.m_tTouchPoint[nIdx + 1] == nil then 
        self.m_tTouchPoint[nIdx + 1] = {}
        self.m_tTouchPoint[nIdx + 1].x = pt.x
        self.m_tTouchPoint[nIdx + 1].y = pt.y
    end

    if self.m_tTouchPoint[1] and self.m_tTouchPoint[2] then
        self.m_nOldLength = self:pointDis(self.m_tTouchPoint[1], self.m_tTouchPoint[2])
        self.m_nOldScale = self.m_tSceneLayer:getMoveElement():getScale()
        if self.m_tOldPosition == nil then 
            self.m_tOldPosition = {}
        end
        self.m_tOldPosition.x,self.m_tOldPosition.y = self.m_tSceneLayer:getMoveElement():getPosition()

        self:setSceneMove(false)
    else
        if self.m_clickInfo then
            local bIsInRect = self.m_bIsPtInBuilding
            WZLog("SceneKidHome:onTouchBegin *****", bIsInRect, pt.x, pt.y)
            if bIsInRect and self.m_clickInfo.tData.basicData.type ~= 2 then 
                self.m_nTouchInBuildingState = 2
                self:setSceneMove(false)
            else 
                self.m_nTouchInBuildingState = 3 
            end
        else
            self.m_nTouchInBuildingState = 1 
        end
    end
end

--@brief    触摸移动回调
function SceneKidHome:onTouchMove(element, pt, nIdx)
    -- body
    if self.m_bIsInTeach then return end 

    if self.m_tTouchPoint[nIdx + 1] ~= nil then 
        self.m_tTouchPoint[nIdx + 1].x = pt.x
        self.m_tTouchPoint[nIdx + 1].y = pt.y
    end
    if self.m_tTouchPoint[1] and self.m_tTouchPoint[2] then
    --    WZLog("SceneKidHome:onTouchMove 111")
        local length = self:pointDis(self.m_tTouchPoint[1], self.m_tTouchPoint[2])
        local nNewScale = self.m_nOldScale + (length - self.m_nOldLength)/200 
        if nNewScale > self.m_nMaxScaleValue then
            nNewScale = self.m_nMaxScaleValue
        elseif nNewScale < self.m_nMinScaleValue then 
            nNewScale = self.m_nMinScaleValue
        end
        self.m_tSceneLayer:getMoveElement():setScale(nNewScale)
    else
        if self.m_nTouchInBuildingState == 2 then 
            self:_refreshOperateBuildingState(pt)
        end
    end
end

--@brief    触摸结束回调
function SceneKidHome:onTouchEnd(element, pt, nIdx)
    -- body
    local bIsInRect = self.m_bIsPtInBuilding
    self.m_bIsPtInBuilding = false
    if self.m_tTouchPoint[1] and self.m_tTouchPoint[2] then 
         WZLog("SceneKidHome:onTouchEnd 222")
        self.m_tTouchPoint[nIdx + 1] = nil
        if not self.m_bIsInTeach then
            self:setSceneMove(true)
        end
        return 
    end
    self.m_tTouchPoint[nIdx + 1] = nil
    if self.m_bIsInTeach then return end 

    if self.m_clickInfo then
        if not self.m_bIsNewBuilding then 
            if self.m_nTouchInBuildingState == 3 then
                if math.abs(pt.x - self.m_startPoint.x) <= 10 and math.abs(pt.y - self.m_startPoint.y) <= 10 then
                    WZLog("SceneKidHome:onTouchEnd 111")
                    if not WndKidOperate.m_bIsClickFunc then 
                        if self.m_clickInfo.tData.basicData.type == 1 then
                            --判断当前位置是否可以放置建筑，不能放置，则回到原来的位置
                            local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
                            --如果不能放置，则直接返回
                            if bIsInRect and not bCanPut then return end 
                            self.m_clickInfo.tCell:setArrowVisible(false)
                            self:_createOneBuildingLawn(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tCell)
                            if not bCanPut then 
                                self.m_clickInfo.tData.tempIndexX = self.m_clickInfo.tData.indexX
                                self.m_clickInfo.tData.tempIndexY = self.m_clickInfo.tData.indexY
                                local nTempX, nTempY = self:_getAbsPosition(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData)
                                self.m_clickInfo.element:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
                                self:sortBuilding()
                            --    self.m_clickInfo.element:setZOrder(self:getBuildZPoint(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData))
                            end
                    	elseif self.m_clickInfo.tData.basicData.type == 2 or self.m_clickInfo.tData.basicData.type == 3 or self.m_clickInfo.tData.basicData.type == 4 or self.m_clickInfo.tData.basicData.type == 5 then  --窗户和装饰
                            self.m_clickInfo.tCell:setArrowVisible(false)
	                    end
                        self.m_clickInfo = nil 
                        WZLog("2222222222222222222222")
                        WndKidOperate:onClickBuildingCallBack()
                    end
                end
            end
        end 
    end
    if self.m_nTouchInBuildingState == 2 then 
        self:setSceneMove(true)
        self:_refreshOperateBuildingState(pt, true)
    end
end

--@brief    设置场景的可移动性
function SceneKidHome:setSceneMove(bEnable)
    -- body
    local conBgLayer = GetElement(self.m_root, "conBgLayer_SceneKidHome", WZUIScene)
    if conBgLayer then 
        conBgLayer:setEnableMoveHorizontal(bEnable)
        conBgLayer:setEnableMoveVertical(bEnable)
    end
end

--@brief    新建建筑
function SceneKidHome:tobuildNewBuilding(tData)
    -- body
    WZLog("SceneKidHome:tobuildNewBuilding", tData.basicData.id, tData.flipStatus)
    --新建建筑，停掉角色和孩子的跑动动画
    self:stopRoleRun(1)

    self:_createLoading()
    if tData.basicData.type == 2 or tData.basicData.type == 3 or tData.basicData.type == 4 or tData.basicData.type == 5 or tData.basicData.type == 6 then 
        ProtocolProcessorKid:send_WEDDING_AddHouseBuilding(tData.fromSource, tData.basicData.id, -1, -1, tData.flipStatus)
    else
        ProtocolProcessorKid:send_WEDDING_AddHouseBuilding(tData.fromSource, tData.basicData.id, self.m_clickInfo.tData.tempIndexX - 1, self.m_clickInfo.tData.tempIndexY - 1, tData.flipStatus)
    end
end

--@brief    新建建筑
function SceneKidHome:cancelTobuildNewBuilding(tData)
    -- body
    self.m_clickInfo = nil 
    self:_cleanBuildingInNewLayer(tData)
end

--@brief    点击建筑物回调
function SceneKidHome:onClickBuildingCallBack(element, tCell, tData)
    -- body
    if self.m_bIsNewBuilding then return end 
    if self.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then return end 
    
    if self.m_clickInfo and self.m_clickInfo.tData.basicData.type == 1 then
    	WZLog("SceneKidHome:onClickBuildingCallBack", self.m_clickInfo.tData.configId , tData.configId , self.m_clickInfo.tData.indexX , tData.indexX , self.m_clickInfo.tData.indexY , tData.indexY)
        
        if self.m_clickInfo.tData.configId == tData.configId and self.m_clickInfo.tData.indexX == tData.indexX and self.m_clickInfo.tData.indexY == tData.indexY then
            --判断当前位置是否可以放置建筑，不能放置，则回到原来的位置
            local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
            if bCanPut then 
                self.m_clickInfo.tCell:setArrowVisible(false)
                self:_createOneBuildingLawn(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tCell)
                self.m_clickInfo = nil 
                WndKidOperate:onClickBuildingCallBack()
            end
            return 
        else
            --判断当前位置是否可以放置建筑，不能放置，则回到原来的位置
            local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
            self.m_clickInfo.tCell:setArrowVisible(false)
            self:_createOneBuildingLawn(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tCell)
            if not bCanPut then 
                self.m_clickInfo.tData.tempIndexX = self.m_clickInfo.tData.indexX
                self.m_clickInfo.tData.tempIndexY = self.m_clickInfo.tData.indexY
                local nTempX, nTempY = self:_getAbsPosition(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData)
                self.m_clickInfo.element:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
                self:sortBuilding()
            --    self.m_clickInfo.element:setZOrder(self:getBuildZPoint(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData))
            end
        end
    elseif self.m_clickInfo and (self.m_clickInfo.tData.basicData.type == 2 or self.m_clickInfo.tData.basicData.type == 3 or self.m_clickInfo.tData.basicData.type == 4 or self.m_clickInfo.tData.basicData.type == 5) then
        if self.m_clickInfo.tData.configId == tData.configId then
            self.m_clickInfo.tCell:setArrowVisible(false)
            self.m_clickInfo = nil 
            WndKidOperate:onClickBuildingCallBack()
            return 
        else
            self.m_clickInfo.tCell:setArrowVisible(false)
        end
    else
        self.m_clickInfo = {}
    end

    self.m_clickInfo.element = element
    self.m_clickInfo.tCell = tCell
    self.m_clickInfo.tData =tData
    tCell:setArrowVisible(true)
    if tData.basicData.type == 1 then
    	self:cleanBuildingLawn(tData.indexX, tData.indexY, self.m_clickInfo.tCell)
    end
    self.m_nTouchInBuildingState = 4

    WndKidOperate:onClickBuildingCallBack()
end 

--@brief    默认建筑回到原可放置的位置
function SceneKidHome:canClickOperateFunc()
    -- body
    if self.m_clickInfo then 
        --判断当前位置是否可以放置建筑，不能放置，则回到原来的位置
        local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
        if not bCanPut then 
        --    MsgBoxManager:showTipBox("")
        end
        return bCanPut 
    end

    return true 
end

--@brief    点击回收按钮回调
function SceneKidHome:_toRemoveBuilding(tData)
    -- body
    self:_createLoading()
    if tData.basicData.type == 2 or tData.basicData.type == 3 then
    	ProtocolProcessorKid:send_WEDDING_RemoveHouseBuilding(0, 0, tData.configId)
    else
    	ProtocolProcessorKid:send_WEDDING_RemoveHouseBuilding(tData.indexX - 1, tData.indexY - 1, tData.configId)
    end
end

--@brief    翻转
--@note     
function SceneKidHome:toFlip(tData)
    -- body
    local tItem = {}
    table.insert(tItem, tData)
    self:_toMoveBuilding(tItem)
end

--@brief 	创建夫妻双方、创建佣人、创建小孩形象
function SceneKidHome:createAni()
	-- body
	--显示夫妻形象
	self:createCouple()
	--显示佣人
	self:createServant()
    --创建孩子
    self:createKidAni()
    --显示拜访者形象
    self:createVisiting()

    self:sortBuilding()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	显示饰品
function SceneKidHome:_createOrnaments()
    local winPosX, winPosY = 716, 415   --窗户
    local accPosX, accPosY = 583, 511   --饰品
    if self.m_nExpansionStatus == 1 then
        winPosX, winPosY = 1356, 815
        accPosX, accPosY = 1233, 911
    end
	
    local nOrnamentTag1 = 200000
    local nOrnamentTag2 = 200001

	local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
	if conForBuilding:getChildByTag(nOrnamentTag1) then
		conForBuilding:removeChildByTag(nOrnamentTag1, true)
	end
	if conForBuilding:getChildByTag(nOrnamentTag2) then
		conForBuilding:removeChildByTag(nOrnamentTag2, true)
	end
	
	for i = 1, #self.m_tUsingOrnaments do
		if self.m_tUsingOrnaments[i] > 0 then
			local tBuildingData = {}
			local tBasicData = GDatatab_house_building["id_" .. self.m_tUsingOrnaments[i]]
			local tBasicInfo = GDatatab_item["id_" .. self.m_tUsingOrnaments[i]]
			
            if tBasicData.type == 2 or tBasicData.type == 3 then 
    			tBuildingData.configId = self.m_tUsingOrnaments[i] 
    			tBuildingData.flipStatus = 0
    			tBuildingData.basicData = tBasicData
    			tBuildingData.basicInfo = tBasicInfo

    			local celElement, tNewObj = CellKidBuilding:createElement()
    	        if celElement and tNewObj then
    	            tNewObj:setBuildingData(tBuildingData)
    	            celElement:setUseAbsCoordinate(true)
    	           
    	            tNewObj:setBuildingBG(-1)

                    celElement:setScaleY(1.1)
    				if tBasicInfo.sub_type == 3 then    --窗户
    	            	celElement:setTag(nOrnamentTag1)
                        celElement:setAbsPosition(GlobalMethod:ccp(winPosX, winPosY))
    				elseif tBasicInfo.sub_type == 4 then --饰品
    	            	celElement:setTag(nOrnamentTag2)
    	            	celElement:setAbsPosition(GlobalMethod:ccp(accPosX, accPosY))
    				end

    	            conForBuilding:addChild(celElement)
    	        end
            elseif tBasicData.type == 4 or tBasicData.type == 5 then 
                self:_updateGrassAndWall(self.m_tUsingOrnaments[i])
            elseif tBasicData.type == 6 then
                self:_initMap(self.m_tUsingOrnaments[i])
            end
		end
	end
end
--@brief    创建家园建筑
function SceneKidHome:_createBuilding()
    -- body
    local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
    conForBuilding:removeAllChildrenWithCleanup(true)

    for i = 1, #self.m_tGridList do
        for j = 1, #self.m_tGridList[i] do 
            --建筑底部草地
            self:_createOneBuildingLawn(i, j)
            --建筑
            self:_createOneBuilding(i, j, -1,conForBuilding)
        end
    end

    self:sortBuilding()
end


--@brief    创建某一建筑底部草地
function SceneKidHome:_createOneBuildingLawn(indexX, indexY, tNewObj)
    -- body
    local conForMap = GetElement(self.m_root, "conForMap_kidSceneMap", WZUIContainer)
    local nTag = (indexX - 1) * KID_MAP_ROW + indexY
    if conForMap:getChildByTag(nTag) then 
        conForMap:removeChildByTag(nTag, true)
    end
    if tNewObj then 
        tNewObj:setBuildingBG(-1)
    end

    if self.m_tGridList[indexX][indexY].configId > 0 then
        local celElement, tNewObj = CellKidBuildingLawn:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(self.m_tGridList[indexX][indexY])
            celElement:setUseAbsCoordinate(true)
            local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, self.m_tGridList[indexX][indexY].basicData)
            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
            celElement:setZOrder(self:getBuildZPoint(indexX, indexY, self.m_tGridList[indexX][indexY].basicData))
            celElement:setTag((indexX - 1) * KID_MAP_ROW + indexY)
            conForMap:addChild(celElement)
        end
    end
end

--@brief    创建某一建筑
--@brief    lawnState:-1不显示建筑本身的草地，其他显示
function SceneKidHome:_createOneBuilding(indexX, indexY, lawnState,con)
    -- body
    local conForBuilding = con 

    if self.m_tGridList[indexX][indexY].configId > 0 then
        local celElement, tNewObj = CellKidBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(self.m_tGridList[indexX][indexY])
            celElement:setUseAbsCoordinate(true)
            local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, self.m_tGridList[indexX][indexY].basicData)
            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
        --    celElement:setZOrder(self:getBuildZPoint(indexX, indexY, self.m_tGridList[indexX][indexY].basicData))
            if lawnState == -1 then 
                tNewObj:setBuildingBG(lawnState)
            end
            

            celElement:setTag((indexX - 1) * KID_MAP_ROW + indexY)
            conForBuilding:addChild(celElement)
        end
    end
end

--@brief    移动建筑时候，刷新临时位置，刷新底的颜色
--@param    bIsTouchEnd:move是否结束
function SceneKidHome:_refreshOperateBuildingState(pt, bIsTouchEnd)
    -- body
    if self.m_clickInfo == nil or self.m_clickInfo == {} then return end
    if self.m_clickInfo.tData.basicData.type == 2 or self.m_clickInfo.tData.basicData.type == 3 or self.m_clickInfo.tData.basicData.type == 4 or self.m_clickInfo.tData.basicData.type == 5 then return end

    local nMoveX, nMoveY = self:_caculateChangeGridNum(pt)

    self.m_clickInfo.tData.tempIndexX = self.m_clickInfo.tData.tempIndexX + nMoveX
    if self.m_clickInfo.tData.tempIndexX < 1 then 
        self.m_clickInfo.tData.tempIndexX = 1
    elseif self.m_clickInfo.tData.tempIndexX + self.m_clickInfo.tData.basicData.size[1][1] - 1 > KID_MAP_ROW then
        self.m_clickInfo.tData.tempIndexX = KID_MAP_ROW - (self.m_clickInfo.tData.basicData.size[1][1] - 1)
    end
    self.m_clickInfo.tData.tempIndexY = self.m_clickInfo.tData.tempIndexY + nMoveY
    if self.m_clickInfo.tData.tempIndexY < 1 then 
        self.m_clickInfo.tData.tempIndexY = 1
    elseif self.m_clickInfo.tData.tempIndexY + self.m_clickInfo.tData.basicData.size[1][2] - 1 > KID_MAP_ROW then
        self.m_clickInfo.tData.tempIndexY = KID_MAP_ROW - (self.m_clickInfo.tData.basicData.size[1][2] - 1)
    end

    local nTempX, nTempY = self:_getAbsPosition(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData)
    self.m_clickInfo.element:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
    self.m_clickInfo.element:setZOrder(10000)

    local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
    if bCanPut then
        if bIsTouchEnd then 
            if self.m_bIsNewBuilding then
                self.m_clickInfo.tCell:setSureState(true)
                self.m_clickInfo.tCell:setBuildingBG(1)
            else
                self.m_clickInfo.tCell:setBuildingBG(0)
                local tItem = {}
                table.insert(tItem, self.m_clickInfo.tData)
                self:_toMoveBuilding(tItem)
            end
        else
            self.m_clickInfo.tCell:setBuildingBG(1)
            if self.m_bIsNewBuilding then
                self.m_clickInfo.tCell:setSureState(true)
            end
        end
    else
        --是否创建的建筑
        if self.m_bIsNewBuilding then 
            self.m_clickInfo.tCell:setSureState(false)            
            self.m_clickInfo.tCell:setBuildingBG(2)
        else
            if self.m_clickInfo.tData.tempIndexX == self.m_clickInfo.tData.indexX and self.m_clickInfo.tData.tempIndexY == self.m_clickInfo.tData.indexY then
                self.m_clickInfo.tCell:setBuildingBG(0)
                self:sortBuilding()
            --    self.m_clickInfo.element:setZOrder(self:getBuildZPoint(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData))
            else
                self.m_clickInfo.tCell:setBuildingBG(2)
            end
        end
    end
end


--@brief    计算移动了几个格子
function SceneKidHome:_caculateChangeGridNum(pt)
    -- body
    local nAddX = 0
    local nAddY = 0
--    WZLog("SceneKidHome:_caculateChangeGridNum 00000", self.m_startPoint.x, self.m_startPoint.y, pt.x, pt.y)
    local deltaX = (pt.x - self.m_startPoint.x)
    local deltaY = (pt.y - self.m_startPoint.y)
    local nSineValue = KID_MAP_SIZEY/2/KIDMAP_REAL_WIDTH
    local nCosineValue = KID_MAP_SIZEX/2/KIDMAP_REAL_WIDTH
    self.m_nMoveX = self.m_nMoveX + deltaX * nCosineValue
    self.m_nMoveX = self.m_nMoveX + deltaY * nSineValue
    self.m_nMoveY = self.m_nMoveY - deltaX * nSineValue
    self.m_nMoveY = self.m_nMoveY + deltaY * nCosineValue
    if math.abs(self.m_nMoveX/KIDMAP_REAL_WIDTH) >= 1 then 
        nAddY = math.floor(self.m_nMoveX/KIDMAP_REAL_WIDTH)
        self.m_nMoveX = self.m_nMoveX - nAddY * KIDMAP_REAL_WIDTH
    end
    if math.abs(self.m_nMoveY/KIDMAP_REAL_WIDTH) >= 1 then 
        nAddX = math.floor(self.m_nMoveY/KIDMAP_REAL_WIDTH)
        self.m_nMoveY = self.m_nMoveY - nAddX * KIDMAP_REAL_WIDTH
        nAddX = -1 * nAddX
    end
    self.m_startPoint.x = pt.x
    self.m_startPoint.y = pt.y
--    WZLog("SceneKidHome:_caculateChangeGridNum 11111", nAddX, nAddY)
    return nAddX, nAddY 
end

--@brief 	创建自己和伴侣的形象
function SceneKidHome:createCouple()
    local nRoleTag1 = 300000
    local nRoleTag2 = 300001
	local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
	if conForBuilding:getChildByTag(nRoleTag1) then
		conForBuilding:removeChildByTag(nRoleTag1, true)
	end
	if conForBuilding:getChildByTag(nRoleTag2) then
		conForBuilding:removeChildByTag(nRoleTag2, true)
	end

	local tBasicData = {}
	tBasicData.size = {{1,1}}
    local tPlayerGrid = {}
    table.insert(tPlayerGrid, self.m_tRandomGrid[1])
    table.insert(tPlayerGrid, self.m_tRandomGrid[2])
	local tCellTempTime
	if self.m_nPlayerId == CacheCenter:getPlayerInfo().id then
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
    		tNewObj:setData(tData, 2)
            element:setUseAbsCoordinate(true)
            local tGridBySex = tPlayerGrid[1]
            tNewObj:setRoleGridData(tGridBySex)
            local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tBasicData)
            element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
			element:setTag(nRoleTag1)
            element:setZOrder((tGridBySex[1] - 1) + (KID_MAP_ROW - tGridBySex[2]) * KID_MAP_ROW)
    		conForBuilding:addChild(element)
    		self.m_tCellHost = tNewObj
    	end
    	WZLog("SceneKidHome:createCouple")
    	tCellTempTime = self.m_tCellHost
		if CacheCenter:getPlayerInfo().mateName and CacheCenter:getPlayerInfo().mateName ~= "" then
			local nSex = 0
			if CacheCenter:getPlayerInfo().sex == 0 then
				nSex = 1
			end
            local tData = {}
            tData.sex = nSex
            tData.tEquip = {}
            tData.headColor = self.m_tMateData.headColor
            tData.bodyColor = self.m_tMateData.bodyColor
            table.insert(tData.tEquip, self.m_tMateData.headId)
            table.insert(tData.tEquip, self.m_tMateData.faceId)
            table.insert(tData.tEquip, self.m_tMateData.bodyId)
            table.insert(tData.tEquip, self.m_tMateData.wingId)
            
			local element, tNewObj = CellKidRole:createElement()
	    	if element and tNewObj then
	    		tNewObj:setData(tData, 2)
                element:setUseAbsCoordinate(true)
                local tGridBySex = tPlayerGrid[2]
                tNewObj:setRoleGridData(tGridBySex)
                local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tBasicData)
				element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				element:setTag(nRoleTag2)
                element:setZOrder((tGridBySex[1] - 1) + (KID_MAP_ROW - tGridBySex[2]) * KID_MAP_ROW)
	    		conForBuilding:addChild(element)
	    		self.m_tCellMate = tNewObj
	    	end

	    	if nSex == 1 then
	    		tCellTempTime = self.m_tCellMate
	    	end
		end
		self.m_tCellShowTimePlayer = tCellTempTime
		tCellTempTime:setShowConceiveTime()
	else
		local tEquip = {}
	    table.insert(tEquip, self.m_tHostData.headId)
	    table.insert(tEquip, self.m_tHostData.faceId)
	    table.insert(tEquip, self.m_tHostData.bodyId)
	    table.insert(tEquip, self.m_tHostData.wingId)

		local tData = {}
		tData.sex = self.m_tHostData.sex
		tData.tEquip = tEquip
		tData.headColor = self.m_tHostData.headColor
		tData.bodyColor = self.m_tHostData.bodyColor
		local element, tNewObj = CellKidRole:createElement()
    	if element and tNewObj then
    		tNewObj:setData(tData, 2)
			element:setUseAbsCoordinate(true)
            local tGridBySex = tPlayerGrid[1]
            tNewObj:setRoleGridData(tGridBySex)
            local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tBasicData)
            element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

			element:setTag(nRoleTag1)
            element:setZOrder((tGridBySex[1] - 1) + (KID_MAP_ROW - tGridBySex[2]) * KID_MAP_ROW)
    		conForBuilding:addChild(element)
    		self.m_tCellHost = tNewObj
    	end

    	tCellTempTime = self.m_tCellHost
		if self.m_tMateData and GetTableLen(self.m_tMateData) > 0 then
			tEquip = {}
		    table.insert(tEquip, self.m_tMateData.headId)
		    table.insert(tEquip, self.m_tMateData.faceId)
		    table.insert(tEquip, self.m_tMateData.bodyId)
		    table.insert(tEquip, self.m_tMateData.wingId)

		    local tData = {}
			tData.sex = self.m_tMateData.sex
			tData.tEquip = tEquip
			tData.headColor = self.m_tMateData.headColor
			tData.bodyColor = self.m_tMateData.bodyColor
			local element, tNewObj = CellKidRole:createElement()
	    	if element and tNewObj then
	    		tNewObj:setData(tData, 2)
				element:setUseAbsCoordinate(true)
                local tGridBySex = tPlayerGrid[2]
                tNewObj:setRoleGridData(tGridBySex)
                local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tBasicData)
                element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
				element:setTag(nRoleTag2)
                element:setZOrder((tGridBySex[1] - 1) + (KID_MAP_ROW - tGridBySex[2]) * KID_MAP_ROW)
	    		conForBuilding:addChild(element)
	    		self.m_tCellMate = tNewObj
	    	end

	    	if self.m_tMateData.sex == 1 then
	    		tCellTempTime = self.m_tCellMate
	    	end
		end

		tCellTempTime:setShowConceiveTime()
	end
end

--@brief 	创建佣人
function SceneKidHome:createServant()
	-- body
    if self.m_root == nil then return end 
    local nRoleTag3 = 300003
    --显示佣人
    WZLog("WndKidServant:addServantTimeOK", self.m_bHavedServant, self.m_nServantTime)
    if self.m_bHavedServant == 1 and self.m_nServantTime > 0 then
    	local conForServant = GetElement(self.m_root, "conForServant_kidSceneMap", WZUIContainer)
    	if conForServant:getChildByTag(nRoleTag3) then
    		conForServant:removeChildByTag(nRoleTag3, true)
    	end

    	local tData = {}
    	tData.petId = 11011
    	local element, tNewObj = CellKidRole:createElement()
    	if element and tNewObj then
    		tNewObj:setData(tData, 1)
            element:setUseAbsCoordinate(true)
			element:setAbsPosition(GlobalMethod:ccp(1090, 365))
			element:setTag(nRoleTag3)
            element:setZOrder(3)
    		conForServant:addChild(element)
    		self.m_tCellServant = tNewObj

            self:_createServantMoveLine(element)
    	end
    end
end

--@brief    创建拜访者形象
function SceneKidHome:createVisiting()
    -- body
    if self.m_root == nil then return end

    WZLog("WndKidServant:createVisiting", Serialize(self.m_tVisitorData))
    local nVisitorInitTag = 100000 --拜访者初始tag 范围[100000,100001,100002]

    local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
    for i=1,self.m_nMaxVisitorCount do
        local tempTag = nVisitorInitTag+i-1
        if conForBuilding:getChildByTag(tempTag) then
            conForBuilding:removeChildByTag(tempTag, true)
        end
    end

    self.m_tCellVisitorRole = {}
    self.m_tIsRoleMove[5] = false
    self.m_tIsRoleMove[6] = false
    self.m_tIsRoleMove[7] = false

    local tVisitorGrid = {}
    table.insert(tVisitorGrid, self.m_tRandomGrid[5])
    table.insert(tVisitorGrid, self.m_tRandomGrid[6])
    table.insert(tVisitorGrid, self.m_tRandomGrid[7])
    for i=1,#self.m_tVisitorData do
        local tempTag = nVisitorInitTag+i-1

        local tEquip = {}
        table.insert(tEquip, self.m_tVisitorData[i].headId)
        table.insert(tEquip, self.m_tVisitorData[i].faceId)
        table.insert(tEquip, self.m_tVisitorData[i].bodyId)
        table.insert(tEquip, self.m_tVisitorData[i].wingId)

        local tData = {}
        tData.name = self.m_tVisitorData[i].name
        tData.sex = self.m_tVisitorData[i].sex
        tData.tEquip = tEquip
        tData.headColor = self.m_tVisitorData[i].headColor
        tData.bodyColor = self.m_tVisitorData[i].bodyColor
        tData.visitorTimes = self.m_tVisitorData[i].visitorTimes
        local element, tNewObj = CellKidRole:createElement()
        if element and tNewObj then
            tNewObj:setData(tData, 4)
            element:setUseAbsCoordinate(true)
            local tGridBySex = tVisitorGrid[i]
            tNewObj:setRoleGridData(tGridBySex)
            local tTempData = {}
            tTempData.size = {{1,1}}
            local nAbsX, nAbsY = self:_getAbsPosition(tGridBySex[1], tGridBySex[2], tTempData)
            element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

            element:setTag(tempTag)
            element:setZOrder((tGridBySex[1] - 1) + (KID_MAP_ROW - tGridBySex[2]) * KID_MAP_ROW)
            conForBuilding:addChild(element)

            --拜访时间
            tNewObj:setShowConceiveTime()

            self.m_tCellVisitorRole[i] = tNewObj
        end
    end
end

--@brief    发转宠物朝向
local function petFlipX1(element)
    -- body
    local tCell = element:getLuaObjectIndex()
    if tCell then
        tCell:setServantDirector(true)
    end
end

--@brief    发转宠物朝向
local function petFlipX2(element)
    -- body
    local tCell = element:getLuaObjectIndex()
    if tCell then
        tCell:setServantDirector(false)
    end
end

--@brief    创建佣人运行路线
function SceneKidHome:_createServantMoveLine(element)
    -- body
    local nLineIndex = math.floor(math.random(1,3))
    local arrayAni = CCArray:create()

    local functionAni1 = CCCallFuncN:create(petFlipX1)
    local moveTo = CCMoveTo:create(20, ccp(580, 630))
    local moveTo2 = CCMoveTo:create(20, ccp(90, 370))
    local functionAni3 = CCCallFuncN:create(petFlipX2)
    local moveTo3 = CCMoveTo:create(20, ccp(560, 110))
    local moveTo4 = CCMoveTo:create(20, ccp(1090, 370))
    local functionAni2 = CCCallFuncN:create(petFlipX1)

    arrayAni:addObject(functionAni1)
    arrayAni:addObject(moveTo)
    arrayAni:addObject(moveTo2)
    arrayAni:addObject(functionAni3)
    arrayAni:addObject(moveTo3)
    arrayAni:addObject(moveTo4)
    arrayAni:addObject(functionAni2)
    
    local sequence = CCSequence:create(arrayAni)
    local repeatAni = CCRepeatForever:create(sequence)
    element:runAction(repeatAni)
end

--@brief 	创建小孩形象
function SceneKidHome:createKidAni()
    local nKidTag1 = 400000  --孩子初始tag 范围[400000,400001]
	local conForServant = GetElement(self.m_root, "conForBuilding_kidSceneMap", WZUIContainer)
    for i = 1, #self.m_tKidData do
        if conForServant:getChildByTag(nKidTag1 + i - 1) then
            conForServant:removeChildByTag((nKidTag1 + i - 1), true)
        end
    end

	self.m_tCellKidRole = {}
    self.m_tIsRoleMove[3] = false
    self.m_tIsRoleMove[4] = false

    local tKidGridIndex = {} 
    table.insert(tKidGridIndex, self.m_tRandomGrid[3])
    table.insert(tKidGridIndex, self.m_tRandomGrid[4])
	for i = 1, #self.m_tKidData do
		local element, tNewObj = CellKidRole:createElement()
    	if element and tNewObj then
    		tNewObj:setData(self.m_tKidData[i], 3)
			element:setUseAbsCoordinate(true)
            tNewObj:setRoleGridData(tKidGridIndex[i])
            local tTempData = {}
            tTempData.size = {{1,1}}
            local nAbsX, nAbsY = self:_getAbsPosition(tKidGridIndex[i][1], tKidGridIndex[i][2], tTempData)
            element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
            element:setZOrder((tKidGridIndex[i][1] - 1) + (KID_MAP_ROW - tKidGridIndex[i][2]) * KID_MAP_ROW)

			element:setTag(nKidTag1 + i - 1)

			tNewObj:playKidState(true)
    		conForServant:addChild(element)

            if self.m_tKidData[i].nextCheckTime > 0 then
                tNewObj:setShowConceiveTime()
            end
    		self.m_tCellKidRole[i] = tNewObj
    	end
	end
end

--@brief    清楚某一建筑底部草地
function SceneKidHome:cleanBuildingLawn(indexX, indexY, tNewObj)
    -- body
    local conForMap = GetElement(self.m_root, "conForMap_kidSceneMap", WZUIContainer)
    local nTag = (indexX - 1) * KID_MAP_ROW + indexY
    if conForMap:getChildByTag(nTag) then 
        conForMap:removeChildByTag(nTag, true)
    end
    if tNewObj then 
        tNewObj:setBuildingBG(0)
    end
end

--@brief    移动建筑回调
function SceneKidHome:_toMoveBuilding(tData)
    -- body
    --移动建筑，停掉角色和孩子的跑动动画
    self:stopRoleRun(1)

    self:_createLoading()
    ProtocolProcessorKid:send_WEDDING_MoveHouseBuilding(tData[1].indexX - 1, tData[1].indexY - 1, tData[1].tempIndexX - 1, tData[1].tempIndexY - 1, tData[1].flipStatus)
end

--@brief    检测移动间隔时间,为了确保只有一个小孩开始移动,因为多个小孩一起移动比较卡
function SceneKidHome:checkMoveRandomTime()
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

--@brief    角色小孩移动
function SceneKidHome:roleAndKidMove(element, delta)
    -- body
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
                    elseif i == 2 and self.m_tCellMate then 
                        bFindPath = true
                        tCellRoleObj = self.m_tCellMate
                    elseif i == 3 and self.m_tCellKidRole and self.m_tCellKidRole[1] then 
                        bFindPath = true
                        tCellRoleObj = self.m_tCellKidRole[1]
                    elseif i == 4 and self.m_tCellKidRole and self.m_tCellKidRole[2] then 
                        bFindPath = true
                        tCellRoleObj = self.m_tCellKidRole[2]
                    elseif i == 5 and self.m_tCellVisitorRole and self.m_tCellVisitorRole[1] then 
                        bFindPath = true
                        tCellRoleObj = self.m_tCellVisitorRole[1]
                    elseif i == 6 and self.m_tCellVisitorRole and self.m_tCellVisitorRole[2] then 
                        bFindPath = true
                        tCellRoleObj = self.m_tCellVisitorRole[2]
                    elseif i == 7 and self.m_tCellVisitorRole and self.m_tCellVisitorRole[3] then 
                        bFindPath = true
                        tCellRoleObj = self.m_tCellVisitorRole[3]
                    end
                    if bFindPath then 
                        local tTargetGrid = self:reGenerateOneGrid(tCellRoleObj)
                        self:startFindPath(tTargetGrid[1], tTargetGrid[2], i)
                    end
                end
            end
        end
    end
    --自己的跑动
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
    --伴侣的跑动
    nPlayerIndex = 2
    if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellMate then
        local tGridData = self.m_tCellMate:getRoleGridData()
        local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
        local step = 1
        if nGridNum > 0 and tGridData then 
            if self.m_tCellMate:getAnimationName() ~= "run" then 
                self.m_tCellMate:playAnimationByName("run")
            end
            local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
            if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                step = 0
            end
            
            self:_addBySpeed(self.m_tCellMate, step, tGridData, tNextGridData, nPlayerIndex)
        else
            self.m_tIsRoleMove[nPlayerIndex] = false 
            if self.m_tCellMate:getAnimationName() ~= "wait0" then 
                self.m_tCellMate:playAnimationByName("wait0")
            end
        end
    end
    --小孩跑动
    if self.m_tCellKidRole == nil then return end 

    nPlayerIndex = 3
    if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellKidRole[1] then
        local tGridData = self.m_tCellKidRole[1]:getRoleGridData()
        local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
        local step = 1
        if self.m_tCellKidRole[1]:getAnimationName() == "ride" or self.m_tCellKidRole[1]:getAnimationName() == "wait_happy" then 
            self.m_tIsRoleMove[nPlayerIndex] = false 
        else
            if nGridNum > 0 and tGridData then 
                if self.m_tCellKidRole[1]:getAnimationName() ~= "walk" then 
                    self.m_tCellKidRole[1]:playAnimationByName("walk")
                end
                local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
                if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                    step = 0
                end
                
                self:_addBySpeed(self.m_tCellKidRole[1], step, tGridData, tNextGridData, nPlayerIndex)
            else
                self.m_tIsRoleMove[nPlayerIndex] = false 
                if self.m_tCellKidRole[1]:getAnimationName() ~= "wait" then 
                    self.m_tCellKidRole[1]:playAnimationByName("wait")
                end
            end
        end
    end

    nPlayerIndex = 4
    if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellKidRole[2] then
        local tGridData = self.m_tCellKidRole[2]:getRoleGridData()
        local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
        local step = 1
        if self.m_tCellKidRole[2]:getAnimationName() == "ride" or self.m_tCellKidRole[2]:getAnimationName() == "wait_happy" then 
            self.m_tIsRoleMove[nPlayerIndex] = false 
        else
            if nGridNum > 0 and tGridData then 
                if self.m_tCellKidRole[2]:getAnimationName() ~= "walk" then 
                    self.m_tCellKidRole[2]:playAnimationByName("walk")
                end
                local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
                if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                    step = 0
                end
                
                self:_addBySpeed(self.m_tCellKidRole[2], step, tGridData, tNextGridData, nPlayerIndex)
            else
                self.m_tIsRoleMove[nPlayerIndex] = false 
                if self.m_tCellKidRole[2]:getAnimationName() ~= "wait" then 
                    self.m_tCellKidRole[2]:playAnimationByName("wait")
                end
            end
        end
    end

    nPlayerIndex = 5
    if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellVisitorRole[1] then
        local tGridData = self.m_tCellVisitorRole[1]:getRoleGridData()
        local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
        local step = 1
        if nGridNum > 0 and tGridData then 
            if self.m_tCellVisitorRole[1]:getAnimationName() ~= "run" then 
                self.m_tCellVisitorRole[1]:playAnimationByName("run")
            end
            local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
            if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                step = 0
            end
            
            self:_addBySpeed(self.m_tCellVisitorRole[1], step, tGridData, tNextGridData, nPlayerIndex)
        else
            self.m_tIsRoleMove[nPlayerIndex] = false 
            if self.m_tCellVisitorRole[1]:getAnimationName() ~= "wait0" then 
                self.m_tCellVisitorRole[1]:playAnimationByName("wait0")
            end
        end
    end

    nPlayerIndex = 6
    if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellVisitorRole[2] then
        local tGridData = self.m_tCellVisitorRole[2]:getRoleGridData()
        local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
        local step = 1
        if nGridNum > 0 and tGridData then 
            if self.m_tCellVisitorRole[2]:getAnimationName() ~= "run" then 
                self.m_tCellVisitorRole[2]:playAnimationByName("run")
            end
            local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
            if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                step = 0
            end
            
            self:_addBySpeed(self.m_tCellVisitorRole[2], step, tGridData, tNextGridData, nPlayerIndex)
        else
            self.m_tIsRoleMove[nPlayerIndex] = false 
            if self.m_tCellVisitorRole[2]:getAnimationName() ~= "wait0" then 
                self.m_tCellVisitorRole[2]:playAnimationByName("wait0")
            end
        end
    end

    nPlayerIndex = 7
    if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellVisitorRole[3] then
        local tGridData = self.m_tCellVisitorRole[3]:getRoleGridData()
        local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
        local step = 1
        if nGridNum > 0 and tGridData then 
            if self.m_tCellVisitorRole[3]:getAnimationName() ~= "run" then 
                self.m_tCellVisitorRole[3]:playAnimationByName("run")
            end
            local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
            if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                step = 0
            end
            
            self:_addBySpeed(self.m_tCellVisitorRole[3], step, tGridData, tNextGridData, nPlayerIndex)
        else
            self.m_tIsRoleMove[nPlayerIndex] = false 
            if self.m_tCellVisitorRole[3]:getAnimationName() ~= "wait0" then 
                self.m_tCellVisitorRole[3]:playAnimationByName("wait0")
            end
        end
    end
end

--@brief    移动计算
function SceneKidHome:_addBySpeed(tCell, step, tGridData, tNextGridData, roleIndex)
    -- body
    local speed = 6
    local tTempData = {}
    tTempData.size = {{1,1}}
    local nAbsX1, nAbsY1 = self:_getAbsPosition(tGridData[1], tGridData[2], tTempData)
    local nAbsX2, nAbsY2 = self:_getAbsPosition(tNextGridData[1], tNextGridData[2], tTempData)
    local ptDis = math.sqrt((nAbsX2-nAbsX1) * (nAbsX2-nAbsX1) + (nAbsY2-nAbsY1) * (nAbsY2-nAbsY1))
    local angelValue = math.asin((nAbsY2 - nAbsY1) / ptDis)

    local originPositionX = tCell.m_root:getAbsPosition().x
    local originPositionY = tCell.m_root:getAbsPosition().y
--    WZLog("SceneKidHome:_addBySpeed 000", originPositionX, originPositionY)
    local nCurPositionX, nCurPositionY
    if step == 0 then --向右移动
        nCurPositionX = originPositionX + speed * math.cos(angelValue)
        if tCell:getPlayer():isFlipX() == true then
            WZLog("tCell:getPlayer():setFlipY(false)")
            tCell:getPlayer():setFlipX(false)
        end
    elseif step == 1 then --向左移动
        nCurPositionX = originPositionX - speed * math.cos(angelValue)
        if tCell:getPlayer():isFlipX() == false then
            WZLog("tCell:getPlayer():setFlipY(true)")
            tCell:getPlayer():setFlipX(true)
        end
    end

    nCurPositionY = originPositionY + speed * math.sin(angelValue)
    local bNextGrid = false 
    if tGridData[1] > tNextGridData[1] and tGridData[2] == tNextGridData[2] then --向上
        if nCurPositionX <= nAbsX2 then 
            nCurPositionX = nAbsX2
            bNextGrid = true
        end
        if nCurPositionY >= nAbsY2 + KID_MAP_SIZEY then 
            nCurPositionY = nAbsY2 + KID_MAP_SIZEY
            bNextGrid = true
        end
    elseif tGridData[1] < tNextGridData[1] and tGridData[2] == tNextGridData[2] then --向下
        if nCurPositionX >= nAbsX2 then 
            nCurPositionX = nAbsX2
            bNextGrid = true
        end
        if nCurPositionY <= nAbsY2 + KID_MAP_SIZEY then 
            nCurPositionY = nAbsY2 + KID_MAP_SIZEY
            bNextGrid = true
        end
    elseif tGridData[1] == tNextGridData[1] and tGridData[2] > tNextGridData[2] then --向左
        if nCurPositionX <= nAbsX2 then 
            nCurPositionX = nAbsX2
            bNextGrid = true
        end
        if nCurPositionY <= nAbsY2 + KID_MAP_SIZEY then 
            nCurPositionY = nAbsY2 + KID_MAP_SIZEY
            bNextGrid = true
        end
    elseif tGridData[1] == tNextGridData[1] and tGridData[2] < tNextGridData[2] then --向右
        if nCurPositionX >= nAbsX2 then 
            nCurPositionX = nAbsX2
            bNextGrid = true
        end
        if nCurPositionY >= nAbsY2 + KID_MAP_SIZEY then 
            nCurPositionY = nAbsY2 + KID_MAP_SIZEY
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
--    WZLog("SceneKidHome:_addBySpeed 000", nCurPositionX, nCurPositionY)

    tCell.m_root:setAbsPosition(GlobalMethod:ccp(nCurPositionX, nCurPositionY))
end

--@brief    当移动建筑，新建建筑停掉所有的跑动
--@param    nType : 1->新建和移动；2->抚摸和摇摇车
--@param    childId : 小孩Id
--@note     小孩做摇摇车，抚摸小孩 时候，停掉相应的小孩跑动
function SceneKidHome:stopRoleRun(nType, childId)
    -- body 
    if self.m_root == nil then return end 

    if nType == 1 then --移动、新建
        for i = 1, #self.m_tIsRoleMove do
            if self.m_tIsRoleMove[i] then 
                if i == 1 then 
                    if self.m_tCellHost then 
                        --停掉跑动，位置重置回当前格子
                        self.m_tCellHost:setRoleGridData(self.m_tRandomGrid[i])
                        local tTempData = {}
                        tTempData.size = {{1,1}}
                        local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[i][1], self.m_tRandomGrid[i][2], tTempData)
                        self.m_tCellHost.m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
                        --动作设为站立
                        if self.m_tCellHost:getAnimationName() ~= "wait0" then 
                            self.m_tCellHost:playAnimationByName("wait0")
                        end
                    end
                elseif i == 2 then 
                    if self.m_tCellMate then 
                        self.m_tCellMate:setRoleGridData(self.m_tRandomGrid[i])
                        local tTempData = {}
                        tTempData.size = {{1,1}}
                        local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[i][1], self.m_tRandomGrid[i][2], tTempData)
                        self.m_tCellMate.m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                        --动作设为站立
                        if self.m_tCellMate:getAnimationName() ~= "wait0" then 
                            self.m_tCellMate:playAnimationByName("wait0")
                        end
                    end
                elseif i == 3 then 
                    if self.m_tCellKidRole and self.m_tCellKidRole[1] then 
                        self.m_tCellKidRole[1]:setRoleGridData(self.m_tRandomGrid[i])
                        local tTempData = {}
                        tTempData.size = {{1,1}}
                        local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[i][1], self.m_tRandomGrid[i][2], tTempData)
                        self.m_tCellKidRole[1].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                        --动作设为站立
                        if self.m_tCellKidRole[1]:getAnimationName() ~= "wait" then 
                            self.m_tCellKidRole[1]:playAnimationByName("wait")
                        end
                    end
                elseif i == 4 then 
                    if self.m_tCellKidRole and self.m_tCellKidRole[2] then 
                        self.m_tCellKidRole[2]:setRoleGridData(self.m_tRandomGrid[i])
                        local tTempData = {}
                        tTempData.size = {{1,1}}
                        local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[i][1], self.m_tRandomGrid[i][2], tTempData)
                        self.m_tCellKidRole[2].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                        --动作设为站立
                        if self.m_tCellKidRole[2]:getAnimationName() ~= "wait" then 
                            self.m_tCellKidRole[2]:playAnimationByName("wait")
                        end
                    end
                elseif i == 5 then 
                    if self.m_tCellVisitorRole and self.m_tCellVisitorRole[1] then 
                        self.m_tCellVisitorRole[1]:setRoleGridData(self.m_tRandomGrid[i])
                        local tTempData = {}
                        tTempData.size = {{1,1}}
                        local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[i][1], self.m_tRandomGrid[i][2], tTempData)
                        self.m_tCellVisitorRole[1].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                        --动作设为站立
                        if self.m_tCellVisitorRole[1]:getAnimationName() ~= "wait" then 
                            self.m_tCellVisitorRole[1]:playAnimationByName("wait")
                        end
                    end
                elseif i == 6 then 
                    if self.m_tCellVisitorRole and self.m_tCellVisitorRole[2] then 
                        self.m_tCellVisitorRole[2]:setRoleGridData(self.m_tRandomGrid[i])
                        local tTempData = {}
                        tTempData.size = {{1,1}}
                        local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[i][1], self.m_tRandomGrid[i][2], tTempData)
                        self.m_tCellVisitorRole[2].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                        --动作设为站立
                        if self.m_tCellVisitorRole[2]:getAnimationName() ~= "wait" then 
                            self.m_tCellVisitorRole[2]:playAnimationByName("wait")
                        end
                    end
                elseif i == 7 then 
                    if self.m_tCellVisitorRole and self.m_tCellVisitorRole[3] then 
                        self.m_tCellVisitorRole[3]:setRoleGridData(self.m_tRandomGrid[i])
                        local tTempData = {}
                        tTempData.size = {{1,1}}
                        local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[i][1], self.m_tRandomGrid[i][2], tTempData)
                        self.m_tCellVisitorRole[3].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                        --动作设为站立
                        if self.m_tCellVisitorRole[3]:getAnimationName() ~= "wait" then 
                            self.m_tCellVisitorRole[3]:playAnimationByName("wait")
                        end
                    end
                end
            end
            self.m_tIsRoleMove[i] = false 
        end
        self.m_tRolePathNode = nil 
    elseif nType == 2 then --摇摇车,抚摸
        if self.m_tCellKidRole == nil then return end 
        --孩子1
        local nRoleIndex = 3
        if self.m_tIsRoleMove[nRoleIndex] and self.m_tCellKidRole[1] then 
            local tData = self.m_tCellKidRole[1]:getData()
            if tData.id == childId then 
                self.m_tCellKidRole[1]:setRoleGridData(self.m_tRandomGrid[nRoleIndex])
                local tTempData = {}
                tTempData.size = {{1,1}}
                local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[nRoleIndex][1], self.m_tRandomGrid[nRoleIndex][2], tTempData)
                self.m_tCellKidRole[1].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                --动作设为站立
                if self.m_tCellKidRole[1]:getAnimationName() ~= "wait" then 
                    self.m_tCellKidRole[1]:playAnimationByName("wait")
                end

                if self.m_tRolePathNode then 
                    self.m_tRolePathNode[nRoleIndex] = nil 
                end
                self.m_tIsRoleMove[nRoleIndex] = false
            end
        end
        --孩子2
        local nRoleIndex = 4
        if self.m_tIsRoleMove[nRoleIndex] and self.m_tCellKidRole[2] then 
            local tData = self.m_tCellKidRole[2]:getData()
            if tData.id == childId then 
                self.m_tCellKidRole[2]:setRoleGridData(self.m_tRandomGrid[nRoleIndex])
                local tTempData = {}
                tTempData.size = {{1,1}}
                local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[nRoleIndex][1], self.m_tRandomGrid[nRoleIndex][2], tTempData)
                self.m_tCellKidRole[2].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                --动作设为站立
                if self.m_tCellKidRole[2]:getAnimationName() ~= "wait" then 
                    self.m_tCellKidRole[2]:playAnimationByName("wait")
                end

                if self.m_tRolePathNode then 
                    self.m_tRolePathNode[nRoleIndex] = nil 
                end
                self.m_tIsRoleMove[nRoleIndex] = false
            end
        end
    end
end

--@brief    刷新花坛和墙壁
function SceneKidHome:_updateGrassAndWall(itemId)
    --body
    local imgWallRight1 = GetElement(self.m_root, "imgWallRight1_kidSceneMap", WZUIImage)
    local imgWallLeft1 = GetElement(self.m_root, "imgWallLeft1_kidSceneMap", WZUIImage)
    local imgWallRight2 = GetElement(self.m_root, "imgWallRight2_kidSceneMap", WZUIImage)
    local imgWallLeft2 = GetElement(self.m_root, "imgWallLeft2_kidSceneMap", WZUIImage)

    local imgGrassLeft1 = GetElement(self.m_root, "imgGrassLeft1_kidSceneMap", WZUIImage)
    local imgGrassRight1 = GetElement(self.m_root, "imgGrassRight1_kidSceneMap", WZUIImage)
    local imgGrassLeft2 = GetElement(self.m_root, "imgGrassLeft2_kidSceneMap", WZUIImage)
    local imgGrassRight2 = GetElement(self.m_root, "imgGrassRight2_kidSceneMap", WZUIImage)

    local tBasicData = GDatatab_house_building["id_" .. itemId]
    if tBasicData.type == 4 then        --花坛
        imgGrassRight1:setFile(tBasicData.animation)
        imgGrassLeft1:setFile(tBasicData.animation)
        imgGrassRight2:setFile(tBasicData.animation)
        imgGrassLeft2:setFile(tBasicData.animation)
    elseif tBasicData.type == 5 then    --墙壁
        imgWallLeft1:setFile(tBasicData.animation)
        imgWallRight1:setFile(tBasicData.animation)
        imgWallLeft2:setFile(tBasicData.animation)
        imgWallRight2:setFile(tBasicData.animation)
    end
end

--@brief    显示主人形象
function SceneKidHome:showHostRole()
    --拜访中的话就隐藏主人
    local nRemainingTime = SceneKidHome.m_nSingleVisitTime - (SystemTime:getServerTime() - SceneKidHome.m_tVisitingTime)
    if nRemainingTime <= 0 then
        self.m_tCellHost.m_root:setVisible(true)
    else
        self.m_tCellHost.m_root:setVisible(false)
    end
end
-------------------------------------私有方法模块End----------------------------------------
