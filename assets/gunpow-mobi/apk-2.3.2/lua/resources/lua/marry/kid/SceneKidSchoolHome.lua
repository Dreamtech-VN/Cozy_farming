--SceneKidSchoolHome.lua
--@brief	SceneKidSchoolHome的UI模块
--@date     2021/5/10
--@author   yrd
--@note		小孩雇佣佣人界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneKidSchoolHome:onEnter(element)
	self.m_root = element
    self.m_createFlag = false
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneKidSchoolHome:onExit(element)
    if self.m_root then 
        self.m_root:disableSchedule()
    end
    ProtocolProcessorKidSchool:send_SCHOOL_LeaveSchool(self.m_nShoolId)

    if not self.m_createFlag then 
       self:_unInit()
    end
    if WZFileUtil:isFileExist("pack/family/pack_family_0.plist") and not self.m_createFlag and not SceneKidHome.m_createFlag then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/family/pack_family_0.plist")
        --163在主城添加了学校入口,所以不注销学校协议
        -- ProtocolProcessorKidSchool:unregAll()
    end
end

--@brief    场景加载完成回调
function SceneKidSchoolHome:onEnterTransitionDidFinish(element)
    -- body
    ChangeChatChannel(Chat_Channel_KidHome)
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_FAMILY)

    self:initScene()
    self:createOperateWin()
    WZLog("SceneKidSchoolHome:onEnterTransitionDidFinish")

    ProtocolProcessorKidSchool:send_SCHOOL_GetState(self.m_nShoolId)

    self:_createLoading()

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)

    WndChat:addChatWindowToCurScene()
    
end

--@brief    发送协议刷新学校数据
function SceneKidSchoolHome:requestSchoolData()
    if self.m_root == nil then
        return
    end
    if self.m_nShoolId == nil then
        return
    end
    ProtocolProcessorKidSchool:send_SCHOOL_GetState(self.m_nShoolId)
end

--@brief    退出按钮回调
function SceneKidSchoolHome:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    replaceScene(SceneCity:createElement())
    if self.m_bOpenChurch == true then
        SceneCity.m_bFromChurch = true
    end
end

--@brief    显示操作窗口
function SceneKidSchoolHome:createOperateWin()
    -- body
    --添加操作窗口
    local multiTouchPanel = GetElement(self.m_root, "multiTouchPanel_SceneKidSchoolHome", WZUIMultiTouchPanel)
    multiTouchPanel:addChild(WndKidSchoolOperate:createElement())
end

--@brief    初始化场景
--@note
function SceneKidSchoolHome:initScene()
    local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneKidSchoolHome"))

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
        print("SceneKidSchoolHome:initScene one", scaleY, scaleX, diff)
    else
        local diff = self.m_tWinSize.width - 1136*scaleY
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(1136+diff,640))
        print("SceneKidSchoolHome:initScene TWO", scaleY, scaleX, diff)
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

--@brief    初始化学校底图
function SceneKidSchoolHome:_initMap(itemId)
    -- body
    WZLog("SceneKidSchoolHome:_initMap")
    local conForMap = GetElement(self.m_root, "conForMap_kidSchoolSceneMap", WZUIContainer)
    conForMap:removeAllChildrenWithCleanup(true)

    local gapX = KID_MAP_SIZEX / 2 
    local gapY = KID_MAP_SIZEY / 2 

    local floorPath = GDatatab_house_building["id_" .. (itemId or 50048)].animation
   
    for i = 1, KID_SCHOOL_MAP_ROW do
        local startX = 0 + (i - 1) * gapX
        local startY = KID_SCHOOL_MAP_HEIGHT / 2 - (i - 1) * gapY
        for j = 1, KID_SCHOOL_MAP_ROW do
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
        --    WZLog("SceneKidSchoolHome:_initMap   position(%d, %d)-(%d, %d)", i, j, startX + j * gapX, startY + (j - 1) * gapY)
            conForMap:addChild(imgMap)
        end
    end
end

--@brief    开始移动
function SceneKidSchoolHome:startMoveCallback(element,node,x,y)
    FigureSceneManager:getInstance():startMoveCallback(element,node,x,y)
end

--@brief    移动中
function SceneKidSchoolHome:nextMoveCellCallback(element,node,x,y,index)
    FigureSceneManager:getInstance():nextMoveCellCallback(element,node,x,y,index)
end

--@brief    结束移动
function SceneKidSchoolHome:endMoveCallback(element,node)
    FigureSceneManager:getInstance():endMoveCallback(element,node)
end


--@brief    触摸开始回调
function SceneKidSchoolHome:onTouchBegin(element, pt, nIdx)
    -- body
    if not WndKidSchoolOperate:checkPointInBtn(pt) then
        WndKidSchoolOperate:hideRankList()
    end
    
    if not WindowManager:getActiveWindow() then 
        WndKidSchoolOperate.m_bIsClickFunc = false
    end
    self.m_startPoint = {} 
    self.m_startPoint.x = pt.x 
    self.m_startPoint.y = pt.y 
    self.m_nTouchInBuildingState = 0 
    if self.m_tTouchPoint == nil then 
        self.m_tTouchPoint = {}
    end
--    WZLog("SceneKidSchoolHome:onTouchBegin", nIdx)
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
            WZLog("SceneKidSchoolHome:onTouchBegin *****", bIsInRect, pt.x, pt.y)
            -- if bIsInRect and self.m_clickInfo.tData.basicData.type ~= 2 then 
            --     self.m_nTouchInBuildingState = 2
            --     self:setSceneMove(false)
            -- else 
            --     self.m_nTouchInBuildingState = 3 
            -- end
            self.m_nTouchInBuildingState = 3
        else
            self.m_nTouchInBuildingState = 1 
        end
    end

end

--@brief    触摸移动回调
function SceneKidSchoolHome:onTouchMove(element, pt, nIdx)
    -- body
    if self.m_bIsInTeach then return end 

    if self.m_tTouchPoint[nIdx + 1] ~= nil then 
        self.m_tTouchPoint[nIdx + 1].x = pt.x
        self.m_tTouchPoint[nIdx + 1].y = pt.y
    end
    if self.m_tTouchPoint[1] and self.m_tTouchPoint[2] then
    --    WZLog("SceneKidSchoolHome:onTouchMove 111")
        local length = self:pointDis(self.m_tTouchPoint[1], self.m_tTouchPoint[2])
        local nNewScale = self.m_nOldScale + (length - self.m_nOldLength)/200 
        if nNewScale > self.m_nMaxScaleValue then
            nNewScale = self.m_nMaxScaleValue
        elseif nNewScale < self.m_nMinScaleValue then 
            nNewScale = self.m_nMinScaleValue
        end
        self.m_tSceneLayer:getMoveElement():setScale(nNewScale)
    else
        -- if self.m_nTouchInBuildingState == 2 then 
        --     self:_refreshOperateBuildingState(pt)
        -- end
    end

end

--@brief    触摸结束回调
function SceneKidSchoolHome:onTouchEnd(element, pt, nIdx)
    local bIsInRect = self.m_bIsPtInBuilding
    self.m_bIsPtInBuilding = false
    if self.m_tTouchPoint[1] and self.m_tTouchPoint[2] then 
         WZLog("SceneKidSchoolHome:onTouchEnd 222")
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
                    WZLog("SceneKidSchoolHome:onTouchEnd 111")
                    if not WndKidSchoolOperate.m_bIsClickFunc then 
                     --    if self.m_clickInfo.tData.basicData.type == 12 or self.m_clickInfo.tData.basicData.type == 7 or self.m_clickInfo.tData.basicData.type == 8 or self.m_clickInfo.tData.basicData.type == 9 or self.m_clickInfo.tData.basicData.type == 10 or self.m_clickInfo.tData.basicData.type == 11 then
                     --        --判断当前位置是否可以放置建筑，不能放置，则回到原来的位置
                     --        local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
                     --        --如果不能放置，则直接返回
                     --        if bIsInRect and not bCanPut then return end 
                     --        self.m_clickInfo.tCell:setArrowVisible(false)
                     --        self:_createOneBuildingLawn(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tCell)
                     --        if not bCanPut then 
                     --            self.m_clickInfo.tData.tempIndexX = self.m_clickInfo.tData.indexX
                     --            self.m_clickInfo.tData.tempIndexY = self.m_clickInfo.tData.indexY
                     --            local nTempX, nTempY = self:_getAbsPosition(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData)
                     --            self.m_clickInfo.element:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
                     --            self:sortBuilding()
                     --        --    self.m_clickInfo.element:setZOrder(self:getBuildZPoint(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData))
                     --        end
                    	-- elseif self.m_clickInfo.tData.basicData.type == 13 then  --窗户和装饰
                     --        self.m_clickInfo.tCell:setArrowVisible(false)
	                    -- end

                        self.m_clickInfo.tCell:setArrowVisible(false)
                        self.m_clickInfo = nil 
                        WZLog("2222222222222222222222")
                        WndKidSchoolOperate:onClickBuildingCallBack()
                    end
                end
            end
        end 
    end
    -- if self.m_nTouchInBuildingState == 2 then 
    --     self:setSceneMove(true)
    --     self:_refreshOperateBuildingState(pt, true)
    -- end
end

--@brief    设置场景的可移动性
function SceneKidSchoolHome:setSceneMove(bEnable)
    -- body
    local conBgLayer = GetElement(self.m_root, "conBgLayer_SceneKidSchoolHome", WZUIScene)
    if conBgLayer then 
        conBgLayer:setEnableMoveHorizontal(bEnable)
        conBgLayer:setEnableMoveVertical(bEnable)
    end
end

--@brief    新建建筑
function SceneKidSchoolHome:tobuildNewBuilding(tData)
    -- body
    WZLog("SceneKidSchoolHome:tobuildNewBuilding", tData.basicData.id, tData.flipStatus)
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
function SceneKidSchoolHome:cancelTobuildNewBuilding(tData)
    -- body
    self.m_clickInfo = nil 
    self:_cleanBuildingInNewLayer(tData)
end

--@brief    点击建筑物回调
function SceneKidSchoolHome:onClickBuildingCallBack(element, tCell, tData)
    -- body
    if self.m_bIsNewBuilding then return end 
    
    if self.m_clickInfo and (self.m_clickInfo.tData.basicData.type == 12 or self.m_clickInfo.tData.basicData.type == 7 or self.m_clickInfo.tData.basicData.type == 8 or self.m_clickInfo.tData.basicData.type == 9 or self.m_clickInfo.tData.basicData.type == 10 or self.m_clickInfo.tData.basicData.type == 11) then
    	WZLog("SceneKidSchoolHome:onClickBuildingCallBack", self.m_clickInfo.tData.configId , tData.configId , self.m_clickInfo.tData.indexX , tData.indexX , self.m_clickInfo.tData.indexY , tData.indexY)
        
        if self.m_clickInfo.tData.configId == tData.configId and self.m_clickInfo.tData.indexX == tData.indexX and self.m_clickInfo.tData.indexY == tData.indexY then
            --判断当前位置是否可以放置建筑，不能放置，则回到原来的位置
            local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
            if bCanPut then 
                self.m_clickInfo.tCell:setArrowVisible(false)
                self:_createOneBuildingLawn(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tCell)
                self.m_clickInfo = nil 
                WndKidSchoolOperate:onClickBuildingCallBack()
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
    elseif self.m_clickInfo and (self.m_clickInfo.tData.basicData.type == 13) then
        if self.m_clickInfo.tData.configId == tData.configId then
            self.m_clickInfo.tCell:setArrowVisible(false)
            self.m_clickInfo = nil 
            WndKidSchoolOperate:onClickBuildingCallBack()
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

    WndKidSchoolOperate:onClickBuildingCallBack()
end

--@brief    默认建筑回到原可放置的位置
function SceneKidSchoolHome:canClickOperateFunc()
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


--@brief    创建夫妻双方、创建佣人、创建小孩形象
function SceneKidSchoolHome:createAni()
    --创建孩子
    self:createKidAni()

    self:sortBuilding()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	显示饰品
function SceneKidSchoolHome:_createOrnaments()
	-- body
	local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSchoolSceneMap", WZUIContainer)
	if conForBuilding:getChildByTag(1111) then
		conForBuilding:removeChildByTag(1111, true)
	end
    if conForBuilding:getChildByTag(1112) then
        conForBuilding:removeChildByTag(1112, true)
    end
    if conForBuilding:getChildByTag(1113) then
        conForBuilding:removeChildByTag(1113, true)
    end
    if conForBuilding:getChildByTag(1114) then
        conForBuilding:removeChildByTag(1114, true)
    end
	
	for i = 1, #self.m_tUsingOrnaments do
		if self.m_tUsingOrnaments[i] > 0 then
			local tBuildingData = {}
			local tBasicData = GDatatab_house_building["id_" .. self.m_tUsingOrnaments[i]]
			local tBasicInfo = GDatatab_item["id_" .. self.m_tUsingOrnaments[i]]
			
            if tBasicData.type == 13 then 
                tBuildingData.configId = self.m_tUsingOrnaments[i] 
                tBuildingData.flipStatus = 0
                tBuildingData.basicData = tBasicData
                tBuildingData.basicInfo = tBasicInfo

                local celElement, tNewObj = CellKidSchoolBuilding:createElement()
                if celElement and tNewObj then
                    tNewObj:setBuildingData(tBuildingData)
                    celElement:setUseAbsCoordinate(true)
                   
                    tNewObj:setBuildingBG(-1)

                    if tBasicData.id == 50044 then    --大黑板
                        celElement:setTag(1111)
                        celElement:setAbsPosition(GlobalMethod:ccp(450, 800))
                    elseif tBasicData.id == 50045 then --小黑板
                        celElement:setTag(1112)
                        celElement:setAbsPosition(GlobalMethod:ccp(550, 860))
                    elseif tBasicData.id == 50049 then --学校窗户
                        celElement:setTag(1113)
                        celElement:setAbsPosition(GlobalMethod:ccp(1416, 790))
                    elseif tBasicData.id == 50050 then --学校窗户
                        celElement:setTag(1114)
                        celElement:setAbsPosition(GlobalMethod:ccp(1630, 730))
                    end

                    conForBuilding:addChild(celElement)
                end
            end
		end
	end
end

--@brief    创建家园建筑
function SceneKidSchoolHome:_createBuilding()
    -- body
    local conForBuilding = GetElement(self.m_root, "conForBuilding_kidSchoolSceneMap", WZUIContainer)
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
function SceneKidSchoolHome:_createOneBuildingLawn(indexX, indexY, tNewObj)
    -- body
    local conForMap = GetElement(self.m_root, "conForMap_kidSchoolSceneMap", WZUIContainer)
    local nTag = (indexX - 1) * KID_SCHOOL_MAP_ROW + indexY
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
            celElement:setTag((indexX - 1) * KID_SCHOOL_MAP_ROW + indexY)
            conForMap:addChild(celElement)
        end
    end
end

--@brief    创建某一建筑
--@brief    lawnState:-1不显示建筑本身的草地，其他显示
function SceneKidSchoolHome:_createOneBuilding(indexX, indexY, lawnState,con)
    -- body
    local conForBuilding = con 

    if self.m_tGridList[indexX][indexY].configId > 0 then
        local celElement, tNewObj = CellKidSchoolBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(self.m_tGridList[indexX][indexY])
            celElement:setUseAbsCoordinate(true)
            local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, self.m_tGridList[indexX][indexY].basicData)
            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
        --    celElement:setZOrder(self:getBuildZPoint(indexX, indexY, self.m_tGridList[indexX][indexY].basicData))
            if lawnState == -1 then 
                tNewObj:setBuildingBG(lawnState)
            end

            --保存相关建筑结构
            if self.m_tGridList[indexX][indexY].basicData.type == 8 then --休息区
                self.m_tAreaObjList[2] = tNewObj
            elseif self.m_tGridList[indexX][indexY].basicData.type == 9 then --科技区
                self.m_tAreaObjList[4] = tNewObj
            elseif self.m_tGridList[indexX][indexY].basicData.type == 10 then --运动区
                self.m_tAreaObjList[3] = tNewObj
            elseif self.m_tGridList[indexX][indexY].basicData.type == 11 then --学习区
                self.m_tAreaObjList[1] = tNewObj
            end

            -- -- 临时显示占地面积
            -- tNewObj:setBuildingBG(1)

            celElement:setTag((indexX - 1) * KID_SCHOOL_MAP_ROW + indexY)
            conForBuilding:addChild(celElement)
        end
    end
end

--@brief    更新建筑中区域数据
function SceneKidSchoolHome:updateBuildArea()
    self.m_tAreaObjList[1]:setAreaData(self.m_tAreaDataList[1])
    self.m_tAreaObjList[2]:setAreaData(self.m_tAreaDataList[2])
    self.m_tAreaObjList[3]:setAreaData(self.m_tAreaDataList[3])
    self.m_tAreaObjList[4]:setAreaData(self.m_tAreaDataList[4])
end

--@brief    更新建筑中小孩
function SceneKidSchoolHome:updateBuildKid()
    self.m_tAreaObjList[1]:setKidData(self.m_tAreaKidList[1])
    self.m_tAreaObjList[2]:setKidData(self.m_tAreaKidList[2])
    self.m_tAreaObjList[3]:setKidData(self.m_tAreaKidList[3])
    self.m_tAreaObjList[4]:setKidData(self.m_tAreaKidList[4])
end

--@brief    移动建筑时候，刷新临时位置，刷新底的颜色
--@param    bIsTouchEnd:move是否结束
function SceneKidSchoolHome:_refreshOperateBuildingState(pt, bIsTouchEnd)
    -- body
    if self.m_clickInfo == nil or self.m_clickInfo == {} then return end
    if self.m_clickInfo.tData.basicData.type == 2 or self.m_clickInfo.tData.basicData.type == 3 or self.m_clickInfo.tData.basicData.type == 4 or self.m_clickInfo.tData.basicData.type == 5 then return end

    local nMoveX, nMoveY = self:_caculateChangeGridNum(pt)

    self.m_clickInfo.tData.tempIndexX = self.m_clickInfo.tData.tempIndexX + nMoveX
    if self.m_clickInfo.tData.tempIndexX < 1 then 
        self.m_clickInfo.tData.tempIndexX = 1
    elseif self.m_clickInfo.tData.tempIndexX + self.m_clickInfo.tData.basicData.size[1][1] - 1 > KID_SCHOOL_MAP_ROW then
        self.m_clickInfo.tData.tempIndexX = KID_SCHOOL_MAP_ROW - (self.m_clickInfo.tData.basicData.size[1][1] - 1)
    end
    self.m_clickInfo.tData.tempIndexY = self.m_clickInfo.tData.tempIndexY + nMoveY
    if self.m_clickInfo.tData.tempIndexY < 1 then 
        self.m_clickInfo.tData.tempIndexY = 1
    elseif self.m_clickInfo.tData.tempIndexY + self.m_clickInfo.tData.basicData.size[1][2] - 1 > KID_SCHOOL_MAP_ROW then
        self.m_clickInfo.tData.tempIndexY = KID_SCHOOL_MAP_ROW - (self.m_clickInfo.tData.basicData.size[1][2] - 1)
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
function SceneKidSchoolHome:_caculateChangeGridNum(pt)
    -- body
    local nAddX = 0
    local nAddY = 0
--    WZLog("SceneKidSchoolHome:_caculateChangeGridNum 00000", self.m_startPoint.x, self.m_startPoint.y, pt.x, pt.y)
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
--    WZLog("SceneKidSchoolHome:_caculateChangeGridNum 11111", nAddX, nAddY)
    return nAddX, nAddY 
end

--@brief    设置一个小孩数据
function SceneKidSchoolHome:setOneKidData(tKidData)
    --空闲区
    if tKidData.area == 0 then
        for i=1,#self.m_tCellKidRole do
            if self.m_tCellKidRole[i]:getData().id == tKidData.id then
                self.m_tCellKidRole[i]:setData(tKidData)
                return
            end
        end
    end
    --操作区:1学习区,2休息区,3运动区,4科技区
    for i=1,#self.m_tAreaObjList do
        local tKidObjList = self.m_tAreaObjList[i]:getKidObjList()
        for j=#tKidObjList,1,-1 do
            if next(tKidObjList[j]) then
                if tKidObjList[j]:getData().id == tKidData.id then
                    tKidObjList[j]:setData(tKidData)
                end
            end
        end
    end
end

--@brief    创建小孩形象
function SceneKidSchoolHome:createKidAni()
    -- body
    local conForServant = GetElement(self.m_root, "conForBuilding_kidSchoolSceneMap", WZUIContainer)
    --tag值777~796被占用,不知道孩子会有多少了,但最多不会超过20个
    for i=1,self.m_nMaxKidCount do
        if conForServant:getChildByTag(777+i-1) then
            conForServant:removeChildByTag(777+i-1, true)
        end
    end

    self.m_tCellKidRole = {}
    for i=1,#self.m_tKidData do
        self.m_tIsRoleMove[i] = false
    end

    local tKidGridIndex = self.m_tRandomGrid
    for i = 1, #self.m_tKidData do
        local element, tNewObj = CellKidSchoolRole:createElement()
        if element and tNewObj then
            tNewObj:setData(self.m_tKidData[i])
            element:setUseAbsCoordinate(true)
            tNewObj:setRoleGridData(tKidGridIndex[i])
            local tTempData = {}
            tTempData.size = {{1,1}}
            local nAbsX, nAbsY = self:_getAbsPosition(tKidGridIndex[i][1], tKidGridIndex[i][2], tTempData)
            element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
            element:setZOrder((tKidGridIndex[i][1] - 1) + (KID_SCHOOL_MAP_ROW - tKidGridIndex[i][2]) * KID_SCHOOL_MAP_ROW)

            element:setTag(777 + i - 1)
            conForServant:addChild(element)

            -- if self.m_tKidData[i].nextCheckTime > 0 then
            --     tNewObj:setShowConceiveTime()
            -- end
            self.m_tCellKidRole[i] = tNewObj
        end
    end
end

--@brief    移除一个小孩形象根据id
function SceneKidSchoolHome:removeKidAniById(nId)
    --空闲区
    for i=#self.m_tCellKidRole,1,-1 do
        if self.m_tCellKidRole[i]:getData() and self.m_tCellKidRole[i]:getData().id == nId then
            local conForServant = GetElement(self.m_root, "conForBuilding_kidSchoolSceneMap", WZUIContainer)
            if conForServant:getChildByTag(self.m_tCellKidRole[i].m_root:getTag()) then
                conForServant:removeChildByTag(self.m_tCellKidRole[i].m_root:getTag(), true)
            end
            self:initRandomTime(#self.m_tCellKidRole - 1)
            table.remove(self.m_tCellKidRole,i)
            table.remove(self.m_tIsRoleMove,i)
            table.remove(self.m_tRandomGrid,i)
            table.remove(self.m_tKidNextArea,i)
            table.remove(self.m_tKidData,i)
        end
    end
    --操作区:1学习区,2休息区,3运动区,4科技区
    for i=1,#self.m_tAreaObjList do
        local tKidObjList = self.m_tAreaObjList[i]:getKidObjList()
        for j=#tKidObjList,1,-1 do
            if next(tKidObjList[j]) then
                if tKidObjList[j]:getData().id == nId then
                    self.m_tAreaObjList[i]:removeKidAniById(nId)
                    self.m_tAreaKidList[i][j] = {}
                end
            end
        end
    end
end

--@brief    创建一个小孩形象到特定区域
--@param    nArea : 0空闲区,1学习区,2休息区,3运动区,4科技区
--@param    tKidData : 小孩数据
function SceneKidSchoolHome:createOneKidAni(tKidData)
    if tKidData.area == 0 then
        local nIndex = #self.m_tCellKidRole + 1
        self:initRandomTime(nIndex)
        local conForServant = GetElement(self.m_root, "conForBuilding_kidSchoolSceneMap", WZUIContainer)
        local nTag = 0
        for i=1,self.m_nMaxKidCount do
            if not conForServant:getChildByTag(777+i-1) then
                nTag = 777+i-1
                break
            end
        end
        if nTag ~= 0 then
            --设置数据
            table.insert(self.m_tKidData,tKidData)
            self.m_tIsRoleMove[nIndex] = false
            self:generateRandomGrid2()
            local tKidGridIndex = self.m_tRandomGrid
            --创建
            local element, tNewObj = CellKidSchoolRole:createElement()
            if element and tNewObj then
                tNewObj:setData(tKidData)
                element:setUseAbsCoordinate(true)
                tNewObj:setRoleGridData(tKidGridIndex[nIndex])
                local tTempData = {}
                tTempData.size = {{1,1}}
                local nAbsX, nAbsY = self:_getAbsPosition(tKidGridIndex[nIndex][1], tKidGridIndex[nIndex][2], tTempData)
                element:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))
                element:setZOrder((tKidGridIndex[nIndex][1] - 1) + (KID_SCHOOL_MAP_ROW - tKidGridIndex[nIndex][2]) * KID_SCHOOL_MAP_ROW)

                element:setTag(nTag)
                conForServant:addChild(element)
                self.m_tCellKidRole[nIndex] = tNewObj

                self:sortBuilding()
            end
        end
    elseif tKidData.area == 1 then
        self.m_tAreaKidList[tKidData.area][tKidData.position] = CopyTable(tKidData)
        self.m_tAreaObjList[1]:createOneKidAni(tKidData)
    elseif tKidData.area == 2 then
        self.m_tAreaKidList[tKidData.area][tKidData.position] = CopyTable(tKidData)
        self.m_tAreaObjList[2]:createOneKidAni(tKidData)
    elseif tKidData.area == 3 then
        self.m_tAreaKidList[tKidData.area][tKidData.position] = CopyTable(tKidData)
        self.m_tAreaObjList[3]:createOneKidAni(tKidData)
    elseif tKidData.area == 4 then
        self.m_tAreaKidList[tKidData.area][tKidData.position] = CopyTable(tKidData)
        self.m_tAreaObjList[4]:createOneKidAni(tKidData)
    end
end


--@brief    清楚某一建筑底部草地
function SceneKidSchoolHome:cleanBuildingLawn(indexX, indexY, tNewObj)
    -- body
    local conForMap = GetElement(self.m_root, "conForMap_kidSchoolSceneMap", WZUIContainer)
    local nTag = (indexX - 1) * KID_SCHOOL_MAP_ROW + indexY
    if conForMap:getChildByTag(nTag) then 
        conForMap:removeChildByTag(nTag, true)
    end
    if tNewObj then 
        tNewObj:setBuildingBG(0)
    end
end

--@brief    检测移动间隔时间,为了确保只有一个小孩开始移动,因为多个小孩一起移动比较卡
function SceneKidSchoolHome:checkMoveRandomTime()
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
function SceneKidSchoolHome:moveKidSchedule(element, delta)

    local nTag = 69 - element:getTag()
    if self.bIsFindCompleted ~= true then
        self.bIsFindCompleted = true
        local tTargetGrid = self:reGenerateDestination(self.m_tCellKidRole[nTag],nTag)
        self:startFindDestination(tTargetGrid[1], tTargetGrid[2], nTag)
    end

    local nPlayerIndex = nTag
    if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellKidRole[nPlayerIndex] and self.m_tRolePathNode[nPlayerIndex] then
        local tGridData = self.m_tCellKidRole[nPlayerIndex]:getRoleGridData()
        local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
        local step = 1
        if self.m_tCellKidRole[nPlayerIndex]:getAnimationName() == "ride" or self.m_tCellKidRole[nPlayerIndex]:getAnimationName() == "wait_happy" then 
            self.m_tIsRoleMove[nPlayerIndex] = false
        else
            if nGridNum > 0 and tGridData then 
                if self.m_tCellKidRole[nPlayerIndex]:getAnimationName() ~= "walk" then 
                    self.m_tCellKidRole[nPlayerIndex]:playAnimationByName("walk")
                end
                local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
                if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                    step = 0
                end
                
                self:_addBySpeed(self.m_tCellKidRole[nPlayerIndex], step, tGridData, tNextGridData, nPlayerIndex)
            else
                self.m_tIsRoleMove[nPlayerIndex] = false 
                if self.m_tCellKidRole[nPlayerIndex]:getAnimationName() ~= "wait" then 
                    self.m_tCellKidRole[nPlayerIndex]:playAnimationByName("wait")
                end
            end
        end
    end

    if not self.m_tIsRoleMove[nPlayerIndex] then
        element:disableSchedule()
        self.bIsFindCompleted = false

        local newRole = {}
        for j=1,4 do --4个操作区
            for k=#self.m_tAreaKidList[j],1,-1 do
                if next(self.m_tAreaKidList[j][k]) then
                    if self.m_tKidData[nTag].id == self.m_tAreaKidList[j][k].id then
                        newRole = self.m_tAreaKidList[j][k]
                    end
                end
            end
        end
        self:removeKidAniById(self.m_tKidData[nTag].id)
        self:createOneKidAni(newRole)
    end
end

--@brief    角色小孩移动
function SceneKidSchoolHome:roleAndKidMove(element, delta)
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
                    if self.m_tCellKidRole and self.m_tCellKidRole[i] and self.m_tKidNextArea[i] == nil then
                        local tTargetGrid = self:reGenerateOneGrid(self.m_tCellKidRole[i])
                        self:startFindPath(tTargetGrid[1], tTargetGrid[2], i)
                    end
                end
            end
        end
    end
    --小孩跑动
    if self.m_tCellKidRole == nil then return end 

    for i=1,#self.m_tCellKidRole do
        local nPlayerIndex = i
        if self.m_tIsRoleMove[nPlayerIndex] and self.m_tCellKidRole[i] and self.m_tRolePathNode[nPlayerIndex] then
            local tGridData = self.m_tCellKidRole[i]:getRoleGridData()
            local nGridNum = #self.m_tRolePathNode[nPlayerIndex]
            local step = 1
            if self.m_tCellKidRole[i]:getAnimationName() == "ride" or self.m_tCellKidRole[i]:getAnimationName() == "wait_happy" then 
                self.m_tIsRoleMove[nPlayerIndex] = false 
            else
                if nGridNum > 0 and tGridData then 
                    if self.m_tCellKidRole[i]:getAnimationName() ~= "walk" then 
                        self.m_tCellKidRole[i]:playAnimationByName("walk")
                    end
                    local tNextGridData = self.m_tRolePathNode[nPlayerIndex][nGridNum]
                    if tNextGridData[1] > tGridData[1] or tNextGridData[2] > tGridData[2] then 
                        step = 0
                    end
                    
                    self:_addBySpeed(self.m_tCellKidRole[i], step, tGridData, tNextGridData, nPlayerIndex)
                else
                    self.m_tIsRoleMove[nPlayerIndex] = false 
                    if self.m_tCellKidRole[i]:getAnimationName() ~= "wait" then 
                        self.m_tCellKidRole[i]:playAnimationByName("wait")
                    end
                end
            end
        end
    end
end

--@brief    移动计算
function SceneKidSchoolHome:_addBySpeed(tCell, step, tGridData, tNextGridData, roleIndex)
    -- body
    local speed = 1
    local tTempData = {}
    tTempData.size = {{1,1}}
    local nAbsX1, nAbsY1 = self:_getAbsPosition(tGridData[1], tGridData[2], tTempData)
    local nAbsX2, nAbsY2 = self:_getAbsPosition(tNextGridData[1], tNextGridData[2], tTempData)
    local ptDis = math.sqrt((nAbsX2-nAbsX1) * (nAbsX2-nAbsX1) + (nAbsY2-nAbsY1) * (nAbsY2-nAbsY1))
    local angelValue = math.asin((nAbsY2 - nAbsY1) / ptDis)

    local originPositionX = tCell.m_root:getAbsPosition().x
    local originPositionY = tCell.m_root:getAbsPosition().y
    -- WZLog("SceneKidSchoolHome:_addBySpeed 000", originPositionX, originPositionY)
    local nCurPositionX, nCurPositionY
    if step == 0 then --向右移动
        nCurPositionX = originPositionX + speed * math.cos(angelValue)
        if tCell:getPlayer():isFlipX() == true then
            -- WZLog("tCell:getPlayer():setFlipY(false)")
            tCell:getPlayer():setFlipX(false)
        end
    elseif step == 1 then --向左移动
        nCurPositionX = originPositionX - speed * math.cos(angelValue)
        if tCell:getPlayer():isFlipX() == false then
            -- WZLog("tCell:getPlayer():setFlipY(true)")
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
    -- WZLog("SceneKidSchoolHome:_addBySpeed 000", nCurPositionX, nCurPositionY)

    tCell.m_root:setAbsPosition(GlobalMethod:ccp(nCurPositionX, nCurPositionY))
end

--@brief    移动建筑回调
function SceneKidSchoolHome:_toMoveBuilding(tData)
    -- body
    --移动建筑，停掉角色和孩子的跑动动画
    self:stopRoleRun(1)

    self:_createLoading()
    ProtocolProcessorKid:send_WEDDING_MoveHouseBuilding(tData[1].indexX - 1, tData[1].indexY - 1, tData[1].tempIndexX - 1, tData[1].tempIndexY - 1, tData[1].flipStatus)
end

--@brief    当移动建筑，新建建筑停掉所有的跑动
--@param    nType : 1->新建和移动；2->抚摸和摇摇车
--@param    childId : 小孩Id
--@note     小孩做摇摇车，抚摸小孩 时候，停掉相应的小孩跑动
function SceneKidSchoolHome:stopRoleRun(nType, childId)
    -- body 
    if self.m_root == nil then return end 

    if nType == 1 then --移动、新建
        for i = 1, #self.m_tIsRoleMove do
            if self.m_tIsRoleMove[i] then 
                if self.m_tCellKidRole and self.m_tCellKidRole[i] then 
                    self.m_tCellKidRole[i]:setRoleGridData(self.m_tRandomGrid[i])
                    local tTempData = {}
                    tTempData.size = {{1,1}}
                    local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[i][1], self.m_tRandomGrid[i][2], tTempData)
                    self.m_tCellKidRole[i].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                    --动作设为站立
                    if self.m_tCellKidRole[i]:getAnimationName() ~= "wait" then 
                        self.m_tCellKidRole[i]:playAnimationByName("wait")
                    end
                end
            end
            self.m_tIsRoleMove[i] = false 
        end
        self.m_tRolePathNode = nil 
    elseif nType == 2 then --摇摇车,抚摸
        if self.m_tCellKidRole == nil then return end 
        --孩子
        for i=1,#self.m_tCellKidRole do
            local nRoleIndex = i
            if self.m_tIsRoleMove[nRoleIndex] and self.m_tCellKidRole[i] then 
                local tData = self.m_tCellKidRole[i]:getData()
                if tData.id == childId then 
                    self.m_tCellKidRole[i]:setRoleGridData(self.m_tRandomGrid[nRoleIndex])
                    local tTempData = {}
                    tTempData.size = {{1,1}}
                    local nAbsX, nAbsY = self:_getAbsPosition(self.m_tRandomGrid[nRoleIndex][1], self.m_tRandomGrid[nRoleIndex][2], tTempData)
                    self.m_tCellKidRole[i].m_root:setAbsPosition(GlobalMethod:ccp(nAbsX, nAbsY + KID_MAP_SIZEY))

                    --动作设为站立
                    if self.m_tCellKidRole[i]:getAnimationName() ~= "wait" then 
                        self.m_tCellKidRole[i]:playAnimationByName("wait")
                    end

                    if self.m_tRolePathNode then 
                        self.m_tRolePathNode[nRoleIndex] = nil 
                    end
                    self.m_tIsRoleMove[nRoleIndex] = false
                end
            end
        end
    end
end

--@brief    刷新花坛和墙壁
function SceneKidSchoolHome:_updateGrassAndWall(itemId)
    --body
    local imgWallRight = GetElement(self.m_root, "imgWallRight_kidSchoolSceneMap", WZUIImage)
    local imgWallLeft = GetElement(self.m_root, "imgWallLeft_kidSchoolSceneMap", WZUIImage)
    local imgGrassRight = GetElement(self.m_root, "imgGrassRight_kidSchoolSceneMap", WZUIImage)
    local imgGrassLeft = GetElement(self.m_root, "imgGrassLeft_kidSchoolSceneMap", WZUIImage)

    local tBasicData = GDatatab_house_building["id_" .. itemId]
    if tBasicData.type == 4 then        --花坛
        imgGrassRight:setFile(tBasicData.animation)
        imgGrassLeft:setFile(tBasicData.animation)
    elseif tBasicData.type == 5 then    --墙壁
        imgWallRight:setFile(tBasicData.animation)
        imgWallLeft:setFile(tBasicData.animation)
    end
end

-------------------------------------私有方法模块End----------------------------------------
