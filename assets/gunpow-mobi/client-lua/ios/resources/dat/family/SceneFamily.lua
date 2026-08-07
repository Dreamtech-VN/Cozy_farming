--SceneFamily.lua
--@brief	SceneFamily的UI模块
--@date		2017/07/25
--@author	Tianxiang_Xu
--@note		家园系统场景


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneFamily:onEnter(element)
	self.m_root = element
    self.m_createFlag = false
    ProtocolProcessorFamily:regAll()

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
    WZLog("SceneFamily:onEnter", isEndTeach, finishStep)
    if isEndTeach ~= true and TeachGroup1:isTeach() then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999, 0 )
        WZLog("SceneFamily:onEnter2")
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneFamily:onExit(element)
    if self.m_root then
        self.m_root:disableSchedule()
    end
    ProtocolProcessorFamily:unregAll()
    if not self.m_createFlag then 
	   self:_unInit()
    end
    if WZFileUtil:isFileExist("pack/family/pack_family_0.plist") and not self.m_createFlag then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/family/pack_family_0.plist")
    end
end

--@brief    场景加载完成回调
function SceneFamily:onEnterTransitionDidFinish(element)
    -- body
    ChangeChatChannel(Chat_Channel_Family)
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_FAMILY)
    
    self:initScene()
    self:createOperateWin()
    WZLog("SceneFamily:onEnterTransitionDidFinish")
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_GetPlayerHomeInfo(self.m_nPlayerId)
end

--@brief    显示操作窗口
function SceneFamily:createOperateWin()
    -- body
    --添加操作窗口
    local multiTouchPanel = GetElement(self.m_root, "multiTouchPanel_SceneFamily", WZUIMultiTouchPanel)
    multiTouchPanel:addChild(WndFamilyOperate:createElement())
end

--@brief    退出按钮回调
function SceneFamily:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    replaceScene(SceneCity:createElement())
end

--@brief    点击建筑物回调
function SceneFamily:onClickBuildingCallBack(element, tCell, tData)
    -- body
    if self.m_bIsNewBuilding then return end 
    if self.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then return end 
    --如果点中的是奇石或圣水生产器，则收集
    if tData.basicData.type == 1 and (tData.basicData.sub_type == 1 or tData.basicData.sub_type == 2) and tData.currentNum >= 50 then 
        if self:_judgeWareHouseCanCollect(tData) then 
            if self.m_clickInfo then 
                self.m_clickInfo.tCell:setArrowVisible(false)
            end
            self.m_clickInfo = nil 
            WndFamilyOperate:onClickBuildingCallBack()
            self:toCollect(tData)
            return 
        else
            if tCell:getCollectIcon() then 
                tCell:playMakeBuildingCollectState(false)
                MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT27)
                return 
            end
        end
    end
    if self.m_clickInfo then
    WZLog("SceneFamily:onClickBuildingCallBack", self.m_clickInfo.tData.configId , tData.configId , self.m_clickInfo.tData.indexX , tData.indexX , self.m_clickInfo.tData.indexY , tData.indexY)
        
        if self.m_clickInfo.tData.configId == tData.configId and self.m_clickInfo.tData.indexX == tData.indexX and self.m_clickInfo.tData.indexY == tData.indexY then
            --判断当前位置是否可以放置建筑，不能放置，则回到原来的位置
            local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
            if bCanPut then 
                self.m_clickInfo.tCell:setArrowVisible(false)
                self:_createOneBuildingLawn(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tCell)
                self.m_clickInfo = nil 
                WZLog("0000000000000000000000000000000")
                WndFamilyOperate:onClickBuildingCallBack()
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
                self.m_clickInfo.element:setZOrder(self:getBuildZPoint(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData))
            end
        end
    else
        self.m_clickInfo = {}
    end

    self.m_clickInfo.element = element
    self.m_clickInfo.tCell = tCell
    self.m_clickInfo.tData =tData
    tCell:setArrowVisible(true)
    self:cleanBuildingLawn(tData.indexX, tData.indexY, self.m_clickInfo.tCell)
    self.m_nTouchInBuildingState = 4
    WZLog("1111111111111111111111")
    WndFamilyOperate:onClickBuildingCallBack()
end 

--@brief    触摸开始回调
function SceneFamily:onTouchBegin(element, pt, nIdx)
    -- body
    if WndDressUp.m_root ~= nil and (not WndDressUp:checkPoint(pt)) then
        WndDressUp:onCloseClick()
    end
    if not WndFamilyOperate:checkPointInBtn(pt) then
        WndFamilyOperate:hideRankList()
    end
    
    if not WindowManager:getActiveWindow() then 
        WndFamilyOperate.m_bIsClickFunc = false
    end
    self.m_startPoint = {} 
    self.m_startPoint.x = pt.x 
    self.m_startPoint.y = pt.y 
    self.m_nTouchInBuildingState = 0 
    if self.m_tTouchPoint == nil then 
        self.m_tTouchPoint = {}
    end
--    WZLog("SceneFamily:onTouchBegin", nIdx)
    if self.m_tTouchPoint[nIdx + 1] == nil then 
        self.m_tTouchPoint[nIdx + 1] = {}
        self.m_tTouchPoint[nIdx + 1].x = pt.x
        self.m_tTouchPoint[nIdx + 1].y = pt.y
    end

    if self.m_bIsInTeach then 
        return 
    end 

    if self.m_tTouchPoint[1] and self.m_tTouchPoint[2] then
        self.m_nOldLength = self:pointDis(self.m_tTouchPoint[1], self.m_tTouchPoint[2])
        self.m_nOldScale = self.m_tSceneLayer:getMoveElement():getScale()
        if self.m_tOldPosition == nil then 
            self.m_tOldPosition = {}
        end
        self.m_tOldPosition.x,self.m_tOldPosition.y = self.m_tSceneLayer:getMoveElement():getPosition()
        -- local pos = self:midPoint(self.m_tTouchPoint[1], self.m_tTouchPoint[2])
        -- local p = self.m_tSceneLayer:getMoveElement():convertToNodeSpaceAuto(CCAutoPoint:create(pos.x,pos.y))
        -- if self.m_tFirstTouchPoint == nil then 
        --     self.m_tFirstTouchPoint = {}
        -- end
        -- self.m_tFirstTouchPoint.x, self.m_tFirstTouchPoint.y = p.x ,p.y 

        self:setSceneMove(false)
    else
        if self.m_clickInfo then
            local bIsInRect = self.m_bIsPtInBuilding
            WZLog("SceneFamily:onTouchBegin *****", bIsInRect, pt.x, pt.y)
            if bIsInRect and self.m_clickInfo.tData.basicData.type ~= 3 then 
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
function SceneFamily:onTouchMove(element, pt, nIdx)
    -- body
--    WZLog("SceneFamily:onTouchMove", nIdx)
    if self.m_bIsInTeach then return end 

    if self.m_tTouchPoint[nIdx + 1] ~= nil then 
        self.m_tTouchPoint[nIdx + 1].x = pt.x
        self.m_tTouchPoint[nIdx + 1].y = pt.y
    end
    if self.m_tTouchPoint[1] and self.m_tTouchPoint[2] then
    --    WZLog("SceneFamily:onTouchMove 111")
        local length = self:pointDis(self.m_tTouchPoint[1], self.m_tTouchPoint[2])
        local nNewScale = self.m_nOldScale + (length - self.m_nOldLength)/200 
        if nNewScale > self.m_nMaxScaleValue then
            nNewScale = self.m_nMaxScaleValue
        elseif nNewScale < self.m_nMinScaleValue then 
            nNewScale = self.m_nMinScaleValue
        end
        self.m_tSceneLayer:getMoveElement():setScale(nNewScale)

        -- local curScale = self.m_tSceneLayer:getMoveElement():getScale()
        -- local diffScale = self.m_nOldScale - nNewScale
        -- local prePos = {x = self.m_tFirstTouchPoint.x,y = self.m_tFirstTouchPoint.y}
        -- local pos = self:pointMult(prePos,diffScale)
        -- pos = self:pointAdd(pos,self.m_tOldPosition)
        -- WZLog("SceneFamily:onTouchMove 222", self.m_tOldPosition.x, self.m_tOldPosition.y, pos.x, pos.y, diffScale, prePos.x, prePos.y)
        -- self:updatePosition(pos)
    --    self:centerOnPoint(self:getCurScreenCenter())
    else
        if self.m_nTouchInBuildingState == 2 then 
            self:_refreshOperateBuildingState(pt)
        end
    end
end

--@brief    触摸结束回调
function SceneFamily:onTouchEnd(element, pt, nIdx)
    -- body
    local bIsInRect = self.m_bIsPtInBuilding
    self.m_bIsPtInBuilding = false
    if self.m_tTouchPoint[1] and self.m_tTouchPoint[2] then 
         WZLog("SceneFamily:onTouchEnd 222")
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
                    WZLog("SceneFamily:onTouchEnd 111")
                    if not WndFamilyOperate.m_bIsClickFunc then 
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
                            self.m_clickInfo.element:setZOrder(self:getBuildZPoint(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData))
                        end
                        self.m_clickInfo = nil 
                        WZLog("2222222222222222222222")
                        WndFamilyOperate:onClickBuildingCallBack()
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

--@brief    放大begin
--@param    tPoint1 触摸点1
--@param    tPoint2 触摸点2
function SceneFamily:beginZoom(tPoint1,tPoint2)
    self.m_nFirstDistance = SceneFamily:pointDis(tPoint1,tPoint2)
    self.m_nOldScale = self.m_tSceneLayer:getMoveElement():getScaleX()
    self.m_tOldCenter = self:getCurScreenCenter()
    self.m_tOldPosition.x,self.m_tOldPosition.y = self.m_tSceneLayer:getMoveElement():getPosition()
    local pos = self:midPoint(tPoint1,tPoint2)
    local p = self.m_tSceneLayer:getMoveElement():convertToNodeSpaceAuto(CCAutoPoint:create(pos.x,pos.y))
    self.m_tFirstTouchPoint.x , self.m_tFirstTouchPoint.y = p.x ,p.y 
end

--@brief    放大move
--@param    tPoint1 触摸点1
--@param    tPoint2 触摸点2
function SceneFamily:moveZoom(tPoint1,tPoint2)
    local length = SceneFamily:pointDis(tPoint1,tPoint2)
    local diff = length - self.m_nFirstDistance
    WZLog("SceneFamily:moveZoom 00000000******", diff)
    if math.abs(diff) < self.m_nPinchDistanceThreshold then
        return
    end
    local factor = diff*self.m_nZoomRate*self.m_nPinchDamping
    local scale = self.m_nOldScale + factor
    WZLog("SceneFamily:moveZoom", scale)
    self.m_tSceneLayer:getMoveElement():setScale(scale)
    self:boundScale()
    local curScale = self.m_tSceneLayer:getMoveElement():getScaleX()
    local diffScale = self.m_nOldScale - curScale
    local prePos = {x = self.m_tFirstTouchPoint.x,y = self.m_tFirstTouchPoint.y}
    local pos = SceneFamily:pointMult(prePos,diffScale)
    pos = SceneFamily:pointAdd(pos,self.m_tOldPosition)
    self:updatePosition(pos)
    self:centerOnPoint(self:getCurScreenCenter())
end

--@brief    把位置tPos设置为中心位置
--@param    tPos 坐标
--@param    nDamping 矫正值
--@return   #1, true 如果移动距离小于1.5个像素 否则 false
function SceneFamily:centerOnPoint(tPos,nDamping,isNoLimit)
    WZLog("SceneFamily:centerOnPoint", tPos.x, tPos.y)
    if nDamping == nil then
        nDamping = 1.0
    end
    if nDamping > 1.0 then 
        nDamping = 0.95
    end 
    self:boundScale(isNoLimit)

    local mid = self:midPoint(self.m_tWinTopRight, self.m_tWinBottomLeft)
    mid = CCPointApplyAffineTransformAuto(CCAutoPoint:create(mid.x,mid.y), self.m_tSceneLayer:getMoveElement():parentToNodeTransformAuto())
    local diff = self:pointMult(self:pointSub(mid, tPos), nDamping)
    local prePos = {x = 0, y = 0}
    prePos.x,prePos.y = self.m_tSceneLayer:getMoveElement():getPosition()
    if self:pointDis(prePos,tPos) < 1.5 then
        return true
    end
    self:updatePosition(self:pointAdd(prePos, diff))
    local curPos = {x = 0,y = 0}
    curPos.x,curPos.y = self.m_tSceneLayer:getMoveElement():getPosition()
    if self:pointDis(prePos,curPos) < 1.5 then
        return true
    end
    return false
end

--@brief    获得当前屏幕中心点再地图里面的坐标
--@param    #1, 返回当前屏幕中心再地图里面的坐标
function SceneFamily:getCurScreenCenter()
    local mid = self:midPoint(self.m_tWinTopRight,self.m_tWinBottomLeft)
    local cpp = CCPointApplyAffineTransformAuto(CCAutoPoint:create(mid.x,mid.y),self.m_tSceneLayer:getMoveElement():parentToNodeTransformAuto())
    return {x = cpp.x,y = cpp.y}
end

--@brief    更新节点的坐标到tPos'
--@param    tPos 要更新到的坐标
function SceneFamily:updatePosition(tPos)
--    tPos = self:boundPos(tPos);
    self.m_tSceneLayer:getMoveElement():setPosition(tPos.x,tPos.y)
end

--@brief    限定坐标在允许的范围内 bound 内'
--@param    tPos 要限定的坐标值
--@return   #1, 限定后的坐标值
function SceneFamily:boundPos(tPos)
    -- Correct for anchor
    local scale = self.m_tSceneLayer:getMoveElement():getScale()
    local size = self.m_tSceneLayer:getMoveElement():getContentSize()
    local anchorPoint = self.m_tSceneLayer:getMoveElement():getAnchorPoint()
    local anchor = {x = size.width*anchorPoint.x,y = size.height*anchorPoint.y}
    anchor = self:pointMult(anchor,1.0 - scale)
    -- Calculate corners
    local topRight = self:pointAdd(self:pointSub(self:pointMult(self.m_tTopRight, scale), self.m_tWinTopRight), anchor)
    local bottomLeft = self:pointSub(self:pointAdd(self:pointMult(self.m_tBottomLeft, scale), self.m_tWinBottomLeft), anchor)
    
    -- bound x
    if tPos.x > bottomLeft.x then
        tPos.x = bottomLeft.x
    elseif tPos.x < -topRight.x then
        tPos.x = -topRight.x
    end
    
    -- bound y
    if tPos.y > bottomLeft.y then
        tPos.y = bottomLeft.y
    elseif tPos.y < -topRight.y then
        tPos.y = -topRight.y
    end
    
    return tPos;
end


--@brief    限定放大缩小在一定的范围内
function SceneFamily:boundScale()
    if self.m_tSceneLayer:getMoveElement() == nil  then
        return
    end

    if self.m_tSceneLayer:getMoveElement():getScale() > self.m_nMaxScaleValue then
        self.m_tSceneLayer:getMoveElement():setScale(self.m_nMaxScaleValue)
    elseif self.m_tSceneLayer:getMoveElement():getScale() < self.m_nMinScaleValue then
        self.m_tSceneLayer:getMoveElement():setScale(self.m_nMinScaleValue)
    end
end


--@brief    设置场景的可移动性
function SceneFamily:setSceneMove(bEnable)
    -- body
    local conBgLayer = GetElement(self.m_root, "conBgLayer_SceneFamily", WZUIScene)
    if conBgLayer then 
        conBgLayer:setEnableMoveHorizontal(bEnable)
        conBgLayer:setEnableMoveVertical(bEnable)
    end
end

--@brief    设置Logo的可见性
function SceneFamily:setLogoVisible(bVisible)
    -- body
    local imgLogo = GetElement(self.m_root, "imgLogo_SceneFamily", WZUIImage)
    if imgLogo then 
        imgLogo:setVisible(bVisible)
    end
end

--@brief    新建建筑
function SceneFamily:tobuildNewBuilding(tData)
    -- body
    WZLog("SceneFamily:tobuildNewBuilding", tData.basicData.id, self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, tData.flipStatus)
    local nFreeButlerNum = self:getFreeButlerNum()
    WZLog("SceneFamily:tobuildNewBuilding two", nFreeButlerNum, self:getButlerNum())
    if nFreeButlerNum <= 0 then 
        MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT28)
        return 
    end
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_AddBuilding(tData.basicData.id, self.m_clickInfo.tData.tempIndexX - 1, self.m_clickInfo.tData.tempIndexY - 1, tData.flipStatus)
end

--@brief    新建建筑
function SceneFamily:cancelTobuildNewBuilding()
    -- body
    self.m_clickInfo = nil 
    self:_cleanBuildingInNewLayer()
end

--@brief    点击加速按钮回调
function SceneFamily:_toSpeedUp(tData)
    -- body
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_SpeedUp(tData.indexX - 1, tData.indexY - 1, tData.buildingStatus )
end

--@brief    点击升级按钮回调
function SceneFamily:_toUpgrade(tData)
    -- body
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_LevelUp(tData.indexX - 1, tData.indexY - 1)
end

--@brief    点击升级按钮回调
function SceneFamily:_toRemoveBuilding(tData)
    -- body
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_RemoveBuilding(tData.indexX - 1, tData.indexY - 1)
end

--@brief    移动建筑回调
function SceneFamily:_toMoveBuilding(tData)
    -- body
    local xOrigin = WZLuaVector_int_:create()
    local yOrigin = WZLuaVector_int_:create()
    local xTarget = WZLuaVector_int_:create()
    local yTarget = WZLuaVector_int_:create()
    local flipStatus = WZLuaVector_byte_:create()
    for i = 1, #tData do
        xOrigin:push(tData[i].indexX - 1)
        yOrigin:push(tData[i].indexY - 1)
        xTarget:push(tData[i].tempIndexX - 1)
        yTarget:push(tData[i].tempIndexY - 1)
        flipStatus:push(tData[i].flipStatus)
    end
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_MoveBuilding(xOrigin, yOrigin, xTarget, yTarget, flipStatus)
end

--@brief    请求数据刷新
--@note     当有生产建筑倒计时为0时候触发
function SceneFamily:toRequestUpdate()
    -- body
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_GetMapUpdate()
end

--@brief    请求取消正在进行的操作
--@note     
function SceneFamily:toCancel(tData)
    -- body
    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_Cancel(tData.indexX - 1, tData.indexY - 1, tData.buildingStatus)
end

--@brief    收集
--@note     
function SceneFamily:toCollect(tData)
    -- body
    if not self:_judgeWareHouseCanCollect(tData) then 
        MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT27)
        return 
    end
    if tData.currentNum <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT29)
        return 
    end

    self:_createLoading()
    ProtocolProcessorFamily:send_HOME_Collect(tData.indexX - 1, tData.indexY - 1)
end

--@brief    翻转
--@note     
function SceneFamily:toFlip(tData)
    -- body
    local tItem = {}
    table.insert(tItem, tData)
    self:_toMoveBuilding(tItem)
end

--@brief    更新佣人数量
function SceneFamily:refreshButlerNum()
    -- body
    WZLog("SceneFamily:refreshButlerNum", nState, countDown, self.m_nInUseButlerNum)
    local nButlerNum = self:getButlerNum()
    WndFamilyOperate:showButlerNum()
    self:_setOneButlerRoomState()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    初始化场景
--@note
function SceneFamily:initScene()
    local scene = WZUIScene:luaTo(self.m_root:getChildElement("conBgLayer_SceneFamily"))
    -- local sceneSize = scene:getMoveElement():getContentSize()
    -- if self.m_tTopRight == nil then
    --     self.m_tTopRight = {}
    -- end
    -- self.m_tTopRight.x, self.m_tTopRight.y = sceneSize.width, sceneSize.height
    -- if self.m_tWinTopRight == nil then 
    --     self.m_tWinTopRight = {x = 960, y = 640}
    -- end
    -- if self.m_tWinBottomLeft == nil then 
    --     self.m_tWinBottomLeft = {x = 0, y = 0}
    -- end
    -- if self.m_tBottomLeft == nil then 
    --     self.m_tBottomLeft = {x = 0, y = 0}
    -- end
    -- local size = CCEGLView:sharedOpenGLView():getFrameSize()
    -- local scaleX = size.width / self.m_tWinTopRight.x
    -- local scaleY = size.height / self.m_tWinTopRight.y
    -- if scaleX > scaleY then
    --     local diff = scaleX - scaleY
    --     diff = diff/scaleX
    --     diff = self.m_tWinTopRight.y * diff
    --     self.m_tWinTopRight.y = self.m_tWinTopRight.y - diff/2
    --     self.m_tWinBottomLeft.y = diff/2
    -- elseif scaleY > scaleX then
    --     local diff = scaleY - scaleX
    --     diff = diff/scaleY
    --     diff = self.m_tWinTopRight.x * diff
    --     self.m_tWinTopRight.x = self.m_tWinTopRight.x - diff / 2
    --     self.m_tWinBottomLeft.x = diff / 2
    -- end
    -- WZLog("SceneFamily:initScene Zero", sceneSize.width, sceneSize.height)
    ---[[
    self.m_tWinSize = CCEGLView:sharedOpenGLView():getFrameSize()
    local scaleY = self.m_tWinSize.height/640
    local scaleX = self.m_tWinSize.width/960
    local realScale = scaleY/scaleX
    
    scene:setResistance(0.8)
    scene:setScaleX(realScale)
    if scaleX < scaleY then
        local diff = 960*scaleY-self.m_tWinSize.width
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(960-diff,640))
        print("SceneFamily:initScene one", scaleY, scaleX, diff)
    else
        local diff = self.m_tWinSize.width - 960*scaleY
        diff = diff/scaleY
        scene:setContentSize(CCSizeMake(960+diff,640))
        print("SceneFamily:initScene TWO", scaleY, scaleX, diff)
    end
    --]]
    local playerLayer = scene:getPlayerLayer()
    self.m_tSceneLayer = scene
    self.m_tPlayerLayer = playerLayer
    playerLayer:setDrawInfo(false)
    playerLayer:setStartMoveCallback("startMoveCallback")
    playerLayer:setEndMoveCallback("endMoveCallback")
    playerLayer:setNextMoveCellCallback("nextMoveCellCallback")

    FigureSceneManager:getInstance():setCurrentScene(self,Chat_Channel_Family)
    FigureSceneManager:getInstance():setFigureLayer(self.m_tPlayerLayer)

    self:_initMap()
end

--@brief    初始化家园底图
function SceneFamily:_initMap()
    -- body
    WZLog("SceneFamily:_initMap")
    local conForMap = GetElement(self.m_root, "conForMap_familySceneMap", WZUIContainer)
    conForMap:removeAllChildrenWithCleanup(true)

    local gapX = MAP_SIZEX / 2 
    local gapY = MAP_SIZEY / 2 
    for i = 1, MAP_ROW do
        local startX = 0 + (i - 1) * gapX
        local startY = MAP_HEIGHT / 2 - (i - 1) * gapY
        for j = 1, MAP_ROW do
            local imgMap = WZUIImage:create()
            imgMap:setUseOriginSize(true)
            imgMap:setUseAbsCoordinate(true)
            if math.mod(i + j, 2) == 0 then
                imgMap:setFile("ui/family/other/map/caodi01.png")
            else
                imgMap:setFile("ui/family/other/map/caodi02.png")
            end
            imgMap:setOpacity(100)
            imgMap:setAbsPosition(GlobalMethod:ccp(startX + j * gapX, startY + (j - 1) * gapY))
        --    WZLog("SceneFamily:_initMap   position(%d, %d)-(%d, %d)", i, j, startX + j * gapX, startY + (j - 1) * gapY)
            conForMap:addChild(imgMap)
        end
    end
end

--@brief    开始移动
function SceneFamily:startMoveCallback(element,node,x,y)
    FigureSceneManager:getInstance():startMoveCallback(element,node,x,y)
end

--@brief    移动中
function SceneFamily:nextMoveCellCallback(element,node,x,y,index)
    FigureSceneManager:getInstance():nextMoveCellCallback(element,node,x,y,index)
end

--@brief    结束移动
function SceneFamily:endMoveCallback(element,node)
    FigureSceneManager:getInstance():endMoveCallback(element,node)
end

--@brief    创建家园建筑
function SceneFamily:_createBuilding()
    -- body
    local conForBuilding = GetElement(self.m_root, "conForBuilding_familySceneMap", WZUIContainer)
    conForBuilding:removeAllChildrenWithCleanup(true)

    for i = 1, #self.m_tGridList do
        for j = 1, #self.m_tGridList[i] do 
            --建筑底部草地
            self:_createOneBuildingLawn(i, j)
            --建筑
            self:_createOneBuilding(i, j, -1,conForBuilding)
        end
    end
    
    --设置佣人房的状态
    self:_setAllButlerRoomState()
end

--@brief    创建某一建筑底部草地
function SceneFamily:_createOneBuildingLawn(indexX, indexY, tNewObj)
    -- body
    local conForMap = GetElement(self.m_root, "conForMap_familySceneMap", WZUIContainer)
    local nTag = (indexX - 1) * MAP_ROW + indexY
    if conForMap:getChildByTag(nTag) then 
        conForMap:removeChildByTag(nTag, true)
    end
    if tNewObj then 
        tNewObj:setBuildingBG(-1)
    end

    if self.m_tGridList[indexX][indexY].configId > 0 then
        local celElement, tNewObj = CellFamilyBuildingLawn:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(self.m_tGridList[indexX][indexY])
            celElement:setUseAbsCoordinate(true)
            local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, self.m_tGridList[indexX][indexY].basicData)
            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
            celElement:setZOrder(self:getBuildZPoint(indexX, indexY, self.m_tGridList[indexX][indexY].basicData))
            celElement:setTag((indexX - 1) * MAP_ROW + indexY)
            conForMap:addChild(celElement)
        end
    end
end

--@brief    创建某一建筑
--@brief    lawnState:-1不显示建筑本身的草地，其他显示
function SceneFamily:_createOneBuilding(indexX, indexY, lawnState,con)
    -- body
    local conForBuilding = con 
    if self.m_tCellListForButler == nil then
        self.m_tCellListForButler = {}
    end

    if self.m_tGridList[indexX][indexY].configId > 0 then
        local celElement, tNewObj = CellFamilyBuilding:createElement()
        if celElement and tNewObj then
            tNewObj:setBuildingData(self.m_tGridList[indexX][indexY])
            celElement:setUseAbsCoordinate(true)
            local nTempX, nTempY = self:_getAbsPosition(indexX, indexY, self.m_tGridList[indexX][indexY].basicData)
            celElement:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
            celElement:setZOrder(self:getBuildZPoint(indexX, indexY, self.m_tGridList[indexX][indexY].basicData))
            if lawnState == -1 then 
                tNewObj:setBuildingBG(lawnState)
            end
            --保存佣人房的表结构
            if self.m_tGridList[indexX][indexY].basicData.type == 1 and self.m_tGridList[indexX][indexY].basicData.sub_type == 4 then
                table.insert(self.m_tCellListForButler, tNewObj)
            elseif self.m_tGridList[indexX][indexY].basicData.type == 1 and self.m_tGridList[indexX][indexY].basicData.sub_type == 7 then
                self.m_tWorkSpaceCell = tNewObj 
            end

            celElement:setTag((indexX - 1) * MAP_ROW + indexY)
            conForBuilding:addChild(celElement)
        end
    end
end

--@brief    清楚某一建筑底部草地
function SceneFamily:cleanBuildingLawn(indexX, indexY, tNewObj)
    -- body
    local conForMap = GetElement(self.m_root, "conForMap_familySceneMap", WZUIContainer)
    local nTag = (indexX - 1) * MAP_ROW + indexY
    if conForMap:getChildByTag(nTag) then 
        conForMap:removeChildByTag(nTag, true)
    end
    if tNewObj then 
        tNewObj:setBuildingBG(0)
    end
end

--@brief    设置佣人房的状态
function SceneFamily:_setAllButlerRoomState()
    -- body
    for i = 1, self.m_nInUseButlerNum do
        if self.m_tCellListForButler[i] then
            local tData = self.m_tCellListForButler[i]:getData()
            if tData.countdown == 0 then 
                self.m_tCellListForButler[i]:resetButlerRoomAni(100)
            end
        end
    end
end

--@brief    设置某一个佣人房的状态
--@param    countDown:0释放一个佣人房；>0使用一个佣人房
function SceneFamily:_setOneButlerRoomState()
    -- body
    -- if countDown == 0 then 
    --     for i = 1, #self.m_tCellListForButler do
    --         local tData = self.m_tCellListForButler[i]:getData()
    --         if tData.countdown > 0 then 
    --             self.m_tCellListForButler[i]:resetButlerRoomAni(countDown)
    --             break 
    --         end
    --     end
    -- else
    --     for i = 1, #self.m_tCellListForButler do
    --         local tData = self.m_tCellListForButler[i]:getData()
    --         if tData.countdown == 0 then 
    --             self.m_tCellListForButler[i]:resetButlerRoomAni(countDown)
    --             break 
    --         end
    --     end
    -- end
    local nInUsingNum = self:getUsingButlerNum()
    for i = 1, #self.m_tCellListForButler do
        if i <= nInUsingNum then 
            self.m_tCellListForButler[i]:resetButlerRoomAni(50)
        else
            self.m_tCellListForButler[i]:resetButlerRoomAni(0)
        end
    end
end

--@brief    移动建筑时候，刷新临时位置，刷新底的颜色
--@param    bIsTouchEnd:move是否结束
function SceneFamily:_refreshOperateBuildingState(pt, bIsTouchEnd)
    -- body
    if self.m_clickInfo == nil or self.m_clickInfo == {} then return end

    local nMoveX, nMoveY = self:_caculateChangeGridNum(pt)

    self.m_clickInfo.tData.tempIndexX = self.m_clickInfo.tData.tempIndexX + nMoveX
    if self.m_clickInfo.tData.tempIndexX < 1 then 
        self.m_clickInfo.tData.tempIndexX = 1
    elseif self.m_clickInfo.tData.tempIndexX + self.m_clickInfo.tData.basicData.size[1][1] - 1 > MAP_ROW then
        self.m_clickInfo.tData.tempIndexX = MAP_ROW - (self.m_clickInfo.tData.basicData.size[1][1] - 1)
    end
    self.m_clickInfo.tData.tempIndexY = self.m_clickInfo.tData.tempIndexY + nMoveY
    if self.m_clickInfo.tData.tempIndexY < 1 then 
        self.m_clickInfo.tData.tempIndexY = 1
    elseif self.m_clickInfo.tData.tempIndexY + self.m_clickInfo.tData.basicData.size[1][2] - 1 > MAP_ROW then
        self.m_clickInfo.tData.tempIndexY = MAP_ROW - (self.m_clickInfo.tData.basicData.size[1][2] - 1)
    end

    local nTempX, nTempY = self:_getAbsPosition(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData)
    self.m_clickInfo.element:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
    self.m_clickInfo.element:setZOrder(2000)

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
                self.m_clickInfo.element:setZOrder(self:getBuildZPoint(self.m_clickInfo.tData.indexX, self.m_clickInfo.tData.indexY, self.m_clickInfo.tData.basicData))
            else
                self.m_clickInfo.tCell:setBuildingBG(2)
            end
        end
    end
end

--@brief    计算移动了几个格子
function SceneFamily:_caculateChangeGridNum(pt)
    -- body
    local nAddX = 0
    local nAddY = 0
--    WZLog("SceneFamily:_caculateChangeGridNum 00000", self.m_startPoint.x, self.m_startPoint.y, pt.x, pt.y)
    local deltaX = (pt.x - self.m_startPoint.x)
    local deltaY = (pt.y - self.m_startPoint.y)
    local nSineValue = MAP_SIZEY/2/MAP_REAL_WIDTH
    local nCosineValue = MAP_SIZEX/2/MAP_REAL_WIDTH
    self.m_nMoveX = self.m_nMoveX + deltaX * nCosineValue
    self.m_nMoveX = self.m_nMoveX + deltaY * nSineValue
    self.m_nMoveY = self.m_nMoveY - deltaX * nSineValue
    self.m_nMoveY = self.m_nMoveY + deltaY * nCosineValue
    if math.abs(self.m_nMoveX/MAP_REAL_WIDTH) >= 1 then 
        nAddY = math.floor(self.m_nMoveX/MAP_REAL_WIDTH)
        self.m_nMoveX = self.m_nMoveX - nAddY * MAP_REAL_WIDTH
    end
    if math.abs(self.m_nMoveY/MAP_REAL_WIDTH) >= 1 then 
        nAddX = math.floor(self.m_nMoveY/MAP_REAL_WIDTH)
        self.m_nMoveY = self.m_nMoveY - nAddX * MAP_REAL_WIDTH
        nAddX = -1 * nAddX
    end
    self.m_startPoint.x = pt.x
    self.m_startPoint.y = pt.y
--    WZLog("SceneFamily:_caculateChangeGridNum 11111", nAddX, nAddY)
    return nAddX, nAddY 
end

--@brief    默认建筑回到原可放置的位置
function SceneFamily:canClickOperateFunc()
    -- body
    if self.m_clickInfo then 
        --判断当前位置是否可以放置建筑，不能放置，则回到原来的位置
        local bCanPut = self:_judgeCanPutBuilding(self.m_clickInfo.tData.tempIndexX, self.m_clickInfo.tData.tempIndexY, self.m_clickInfo.tData.basicData, self.m_clickInfo.tData)
        if not bCanPut then 
            MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT33)
        end
        return bCanPut 
    end

    return true 
end

--@brief    守护倒计时
function SceneFamily:_caculateTime()
    -- body
    if self.m_nLeftProtectTime > 0 then
        self.m_nLeftProtectTime = self.m_nLeftProtectTime - 1
    else
        self.m_root:disableSchedule()
    end

    WndFamilyProduce:_showLeftProtectTime()
end
-------------------------------------私有方法模块End----------------------------------------
