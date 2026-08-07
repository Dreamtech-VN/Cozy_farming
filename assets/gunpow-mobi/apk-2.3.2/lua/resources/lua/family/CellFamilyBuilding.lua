--CellFamilyBuilding.lua
--@brief	CellFamilyBuilding的UI模块
--@date		2017/07/26
--@author	Tianxiang_Xu
--@note		家园建筑节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFamilyBuilding:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFamilyBuilding:onExit(element)
	self:_unInit()
end

--@brief    点击建筑回调
function CellFamilyBuilding:onClickBuilding(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneFamily:onClickBuildingCallBack(self.m_root, self, self.m_tData)

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
    WZLog("CellFamilyBuilding:onClickBuilding")
    if isEndTeach ~= true then
        TeachGroup1:endTeachStep({45,7})
        TeachGroup1:startGroup({45,8,WndFamilyOperate.m_root})
    end
end

--@brief    触摸点是否在建筑上
function CellFamilyBuilding:ptInBtnCallBack(element)
    -- body
    WZLog("CellFamilyBuilding:ptInBtnCallBack")
    SceneFamily:judgePtInBuilding(self.m_tData)
end

--@brief    点击建造按钮回调
function CellFamilyBuilding:onClickSure(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneFamily:tobuildNewBuilding(self.m_tData)

    local isEndTeach, finishStep = TeachGroup1:isTeachFinish(45)
    if isEndTeach ~= true then
        TeachGroup1:removeTeach()
        WindowManager:addTeachShelterLayer( 999999 )
    end
    TeachGroup1.CELL = self.m_root
end

--@brief    点击建造按钮回调
function CellFamilyBuilding:onClickCancel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    SceneFamily:cancelTobuildNewBuilding()
end

--@brief    检测是否点在按钮区域
function CellFamilyBuilding:checkPointInBtn(pt)
    -- body
    if self.m_root == nil then return false end
    local btnBuilding = self:_createBtnBuilding()
    if btnBuilding == nil then return false end

    local btnSize2 = btnBuilding:getContentSize()
    local ptB = btnBuilding:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("CellFamilyBuilding:checkPointInBtn", pt.x, pt.y, ptB.x, ptB.y, btnSize2.width, btnSize2.height)
    if (pt.x > ptB.x and pt.x < ptB.x + btnSize2.width) and (pt.y > ptB.y and pt.y < ptB.y + btnSize2.height) then
        return true
    end

    return false
end

--@brief    设置建筑是否可点击
function CellFamilyBuilding:setBuildingTouch(bEnable)
    -- body
    local btnBuilding = self:_createBtnBuilding()
    if btnBuilding then 
        btnBuilding:setTouchEnable(bEnable)
    end
end

--@brief    设置建筑的翻转
function CellFamilyBuilding:setBuildFlipX(flipStatus)
    -- body
    if self.m_root == nil then return end 

    self.m_tData.flipStatus = flipStatus
    local spineBuilding 
    if (self.m_tData.basicData.type == 3 and self.m_tData.basicData.sub_type == 0) or (self.m_tData.basicData.type == 2 and self.m_tData.basicData.sub_type == 6) then 
        spineBuilding = self:_createBuildingImageNode()
    else
        spineBuilding = self:_createBuildingSpineNode()
    end
    if spineBuilding then 
        if self.m_tData.flipStatus == 0 then 
            spineBuilding:setFlipX(false)
        elseif self.m_tData.flipStatus == 1 then 
            spineBuilding:setFlipX(true)
        end
    end
end

--@brief    重画建筑
function CellFamilyBuilding:redrawBuilding()
    -- body
    if self.m_root == nil then return end 
    self:_drawBuilding()
end

--@brief    重新设置佣人房的待机动画
function CellFamilyBuilding:resetButlerRoomAni(countDown)
    -- body
    if self.m_tData.basicData.type == 1 and self.m_tData.basicData.sub_type == 4 then --佣人房特效
        self.m_tData.countdown = countDown
        self:playButlerAni()
    end
end

--@brief    获取可收集标记
function CellFamilyBuilding:getCollectIcon()
    --body
    local conForBuilding = self:_createConForBuilding()
    return conForBuilding:getChildByTag(333)
end
    
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellFamilyBuilding:_update()
    -- body
    WZLog("CellFamilyBuilding:_update", self.m_tData.basicData.id)
    --设置相应容器大小
    self:_setContainerSize()
    --设置建筑底部草地
--    self:setBuildingBG()
    --显示建筑
    self:_drawBuilding()
    --按钮
    self:_createBtnBuilding()
    --显示时间进度条
    if SceneFamily.m_nPlayerId == CacheCenter:getPlayerInfo().id then
        self:showPrgForTime()
    end
    --升水萃取器进度
    self:showWaterProgress()
    --倒计时
    if not (self.m_tData.basicData.type == 1 and self.m_tData.basicData.sub_type == 4) then
        if SceneFamily.m_nPlayerId == CacheCenter:getPlayerInfo().id then
            self:setTimeCaculate()
        end
    end
    --名字和等级
    self:_updateNameAndLevel()
end

--@brief    设置Cell容器大小
function CellFamilyBuilding:_setContainerSize()
    -- body
    local tData = self.m_tData.basicData
    local element = WZUIContainer:luaTo(self.m_root)
    --计算容器大小
    local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEX
    local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEY

    element:setContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
    element:setRelativeSize(GlobalMethod:CCSize(1,1))
    element:updateRelativeSize()
end

--@brief    设置建筑底部草地
--@brief    state:默认显示草地；1->显示绿色；2->显示红色
function CellFamilyBuilding:setBuildingBG(state)
    -- body
    local tData = self.m_tData.basicData

    local conForBG = self:_createConForBG()
    conForBG = WZUIContainer:luaTo(conForBG)

    local gapX = MAP_SIZEX / 2 
    local gapY = MAP_SIZEY / 2 

    if conForBG then
        conForBG:removeAllChildrenWithCleanup(true)
        if state == -1 then return end 
        if (state == 0 or state == nil) and tData.size[1][1] == tData.size[1][2] and not (tData.id == 40408 or tData.id == 40409) and not (tData.type == 1 and tData.sub_type == 7) then 
            local imgMap = WZUIImage:create()
            imgMap:setUseOriginSize(true)
            if tData.type == 1 and (tData.sub_type == 1 or tData.sub_type == 2 or tData.sub_type == 3) and tData.size[1][1] == 2 then 
                imgMap:setFile("ui/family/other/map/di05.png")
            else
                imgMap:setFile("ui/family/other/map/di0" .. (tData.size[1][1]) .. ".png")
            end
            imgMap:setScale(1)
            conForBG:addChild(imgMap)
        else
            for i = 1, tData.size[1][1] do
                local startX = 0 + (i - 1) * gapX
                local startY = tData.size[1][1] * 0.5 * MAP_SIZEY - (i - 1) * gapY
                for j = 1, tData.size[1][2] do
                    local imgMap = WZUIImage:create()
                    imgMap:setUseOriginSize(true)
                    imgMap:setUseAbsCoordinate(true)
                    if state == 1 then 
                        imgMap:setFile("ui/family/other/map/lvgezi01.png")
                    elseif state == 2 then 
                        imgMap:setFile("ui/family/other/map/lvgezi01.png")
                        imgMap:setColor(GlobalMethod:ccc3(255,0,0))
                    else
                        imgMap:setFile("ui/family/other/map/caodi01.png")
                    end
                    imgMap:setAbsPosition(GlobalMethod:ccp(startX + j * gapX, startY + (j - 1) * gapY))
                    
                    conForBG:addChild(imgMap)
                end
            end
        end
    end
end

--@brief    显示建筑
function CellFamilyBuilding:_drawBuilding()
    -- body
    local tData = self.m_tData.basicData
    
    local animation = SplitStringWithSeparator(tData.animation, ",")
    if (tData.type == 3 and tData.sub_type == 0) or (tData.type == 2 and tData.sub_type == 6) or (tData.type == 1 and tData.sub_type == 7) then 
        local imgBuilding = self:_createBuildingImageNode()
        if imgBuilding then
            imgBuilding:setFile(animation[1] .. animation[2] .. ".png")
            imgBuilding:setRelativePosition(GlobalMethod:ccp(tData.position[1][1], tData.position[1][2]))
            imgBuilding:setScale(0.5)
        end
    else
        local spineBuilding = self:_createBuildingSpineNode()
        spineBuilding = WZUISpine:luaTo(spineBuilding)
        WZLog("CellFamilyBuilding:_drawBuilding", animation[1], animation[2], type(spineBuilding))
        if spineBuilding then
            spineBuilding:setVisible(true)
            spineBuilding:setFileJson("ui/family/building/" .. animation[1] .. ".json")
            spineBuilding:setFileAtlas("ui/family/building/" .. animation[1] .. ".atlas")
            spineBuilding:setScale(0.5)
            --围栏特殊处理
            if tData.type == 2 and tData.sub_type == 5 then 
                local bOtherAniName = SceneFamily:judgeEnclosureAniState(self.m_tData.indexX, self.m_tData.indexY)
                if bOtherAniName then 
                    spineBuilding:play(animation[2] .. "A", true)
                else
                    spineBuilding:play(animation[2], true)
                end
            elseif tData.type == 0 and tData.sub_type == 0 then 
                spineBuilding:setScale(1)
                spineBuilding:play(animation[2], false)
            else
                spineBuilding:play(animation[2], true)
            end
        end
    end

    --如果是主人房，显示主人房特有的特效
    if tData.type == 0 and tData.sub_type == 0 then 
        self:playMainRoomAni()
    elseif tData.type == 1 and tData.sub_type == 4 then --佣人房特效
        self:playButlerAni()
    elseif tData.type == 1 and (tData.sub_type == 1 or tData.sub_type == 2) then
        self:playMakeBuildingCollectState()
    elseif tData.type == 1 and (tData.sub_type == 5 or tData.sub_type == 6) then 
        self:playDoorRewardState()
    elseif tData.type == 1 and tData.sub_type == 7 then
        self:showWorkPetAndMount()
    elseif tData.type == 1 and tData.sub_type == 8 then
        self:playPastureAni()
    end
    --翻转的状态
    self:setBuildFlipX(self.m_tData.flipStatus)
end

--@brief    设置移动箭头的可见
function CellFamilyBuilding:setArrowVisible(bVisible)
    -- body
    local tData = self.m_tData.basicData
    if tData.type ~= 3 then 
        self:_createBuildingArrow(bVisible)
    end

    self:_createBuildingNameAndLevel(bVisible)
end

--@brief    设置时间进度条
--buildingStatus : 建筑状态(0:无；1:建造中；2:升级中；3:拆除中)
function CellFamilyBuilding:showPrgForTime()
    -- body
    if self.m_nType == 1 then return end 
    
    local tData = self.m_tData
--    WZLog("CellFamilyBuilding:showPrgForTime", tData.buildingStatus, tData.countdown)
    local conForBuilding = self:_createConForBuilding()
    if tData.buildingStatus ~= 0 and tData.countdown > 0 then
        local nTotalTime 
        if tData.buildingStatus == 1 then
            nTotalTime = tData.basicData.build_time
        elseif tData.buildingStatus == 2 then
            nTotalTime = tData.basicData.upgrade_time
        elseif tData.buildingStatus == 3 then
            nTotalTime = tData.basicData.remove_time
        end
        if nTotalTime == nil or nTotalTime == -1 then 
            self:_createTimeProgress(false)
            return 
        end 

        self:_createTimeProgress(true)
        local conForTime = conForBuilding:getChildByTag(94)
        if not conForTime then return end 
        conForTime = WZUIContainer:luaTo(conForTime)
        local prgLeftTime = conForTime:getChildByTag(22)
        if not prgLeftTime then return end 
        prgLeftTime = WZUIProgress:luaTo(prgLeftTime) 
        if prgLeftTime then
            prgLeftTime:setPercentage(math.floor(100 * (nTotalTime-tData.countdown)/nTotalTime))
        end
        local txtLeftTime = conForTime:getChildByTag(23)
        if not txtLeftTime then return end 
        txtLeftTime = WZUILabelTTF:luaTo(txtLeftTime) 
        local sTimeContent  
        local nDay = math.floor(tData.countdown/(3600 * 24))
        local nHour = math.floor((tData.countdown - nDay * 3600 * 24)/3600)
        local nMinute = math.floor((tData.countdown - nHour * 3600)/60)
        local nSecond = tData.countdown - nHour * 60 - nMinute * 60
        if tData.countdown < 60 then 
            sTimeContent = tData.countdown .. LocalStrings.SECOND
        elseif tData.countdown < 3600 then 
            sTimeContent = nMinute .. LocalStrings.MINUTE1 .. nSecond .. LocalStrings.SECOND
        elseif tData.countdown < 3600 * 24 then 
            sTimeContent = nHour .. LocalStrings.HOUR1 .. nMinute .. LocalStrings.MINUTE1
        else
            sTimeContent = nDay .. LocalStrings.DAY .. nHour .. LocalStrings.HOUR1
        end
        if txtLeftTime then
            txtLeftTime:setText(sTimeContent)
        end
        --升级特效
        self:_setUpgradeSpineInfo(true)
    else
--        WZLog("CellFamilyBuilding:showPrgForTime  000")
        self:_createTimeProgress(false)
        self:_setUpgradeSpineInfo(false)
    end
end

--@brief    升水生产器进度条
function CellFamilyBuilding:showWaterProgress()
    -- body
    if self.m_nType == 1 then return end 
    
    local tData = self.m_tData.basicData
    local conForBuilding = self:_createConForBuilding()
    if tData.type == 1 and tData.sub_type == 1 then
        local spineWellWater = conForBuilding:getChildByTag(101)
        if not spineWellWater then 
            spineWellWater = WZUISpine:create()
            spineWellWater:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
            spineWellWater:setRelativePosition(GlobalMethod:ccp(0.5, 0))
            spineWellWater:setTouchEnable(false)
            local spineFilePath  = "ui/family/building/well_water"
            spineWellWater:setFileJson(spineFilePath .. ".json")
            spineWellWater:setFileAtlas(spineFilePath .. ".atlas")
            spineWellWater:setTag(101)
            spineWellWater:setZOrder(1)

            conForBuilding:addChild(spineWellWater)
        else
            spineWellWater = WZUISpine:luaTo(spineWellWater)
        end

        local nPercent = math.floor(100 * self.m_tData.currentNum/tData.functions[1][4])
        spineWellWater:setScale(0.5)
        if nPercent < 5 then 
            spineWellWater:setVisible(false)
        elseif nPercent < 35 then
            spineWellWater:setVisible(true)
            spineWellWater:play("well_water01", true)
        elseif nPercent < 70 then
            spineWellWater:setVisible(true)
            spineWellWater:play("well_water02", true)
        elseif nPercent < 90 then
            spineWellWater:setVisible(true)
            spineWellWater:play("well_water03", true)
        else
            spineWellWater:setVisible(true)
            spineWellWater:play("well_water04", true)
        end
    end
end

--@brief    设置升级动画的可见与大小
function CellFamilyBuilding:_setUpgradeSpineInfo(bVisible)
    -- body
    local conForBuilding = self:_createConForBuilding()

    if bVisible then 
        local spineUpgrade = conForBuilding:getChildByTag(100)
        if not spineUpgrade then 
            local tData = self.m_tData.basicData
            local houseData = GDatatab_home_building["id_40000"]
            spineUpgrade = WZUISpine:create()
            if tData.type == 1 and tData.sub_type == 7 then
                spineUpgrade:setScale(1.1)
                spineUpgrade:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
                spineUpgrade:setRelativePosition(GlobalMethod:ccp(0.3, 0.5))
            else
                spineUpgrade:setScale(tData.size[1][1]/houseData.size[1][1])
                spineUpgrade:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
                spineUpgrade:setRelativePosition(GlobalMethod:ccp(0.5, 0.45))
            end
            spineUpgrade:setTouchEnable(false)
            local spineFilePath  = "ui/family/building/jiayuan_smoke"
            spineUpgrade:setFileJson(spineFilePath .. ".json")
            spineUpgrade:setFileAtlas(spineFilePath .. ".atlas")
            spineUpgrade:play("animation", true)
            spineUpgrade:setTag(100)
            spineUpgrade:setZOrder(2)

            conForBuilding:addChild(spineUpgrade)
        end
    else
--        WZLog("CellFamilyBuilding:_setUpgradeSpineInfo 000")
        if conForBuilding:getChildByTag(100) then 
            conForBuilding:removeChildByTag(100, true)
        end
    end
end

--@brief    设置新建按钮是否可见
function CellFamilyBuilding:setBuildNewBtnVisible(bVisible)
    -- body
    if self.m_root == nil then return end 
    self:_createBuildMenu(bVisible)
end

--@brief    设置新建按钮状态
function CellFamilyBuilding:setSureState(bTouchEnable)
    -- body
    if self.m_root == nil then return end 
    local conOutSide = self:_createOutSideCon()
    local conBtnBuild = conOutSide:getChildByTag(95)
    if conBtnBuild == nil then return end 
    conBtnBuild = WZUIContainer:luaTo(conBtnBuild)
    local btnSure = conBtnBuild:getChildByTag(11)
    if btnSure == nil then return end 
    btnSure = WZUIButton:luaTo(btnSure)
    if btnSure then 
        btnSure:setTouchEnable(bTouchEnable)
    end
end

--@brief    设计计时器
function CellFamilyBuilding:setTimeCaculate()
    -- body
    if self.m_nType == 1 then return end 
    local tData = self.m_tData
    WZLog("CellFamilyBuilding:setTimeCaculate", tData.buildingStatus, tData.countdown)
    local conForBuilding = self:_createConForBuilding()
    if tData.countdown > 0 then
        conForBuilding:enableSchedule("setCaculate", 1)
    else
        conForBuilding:disableSchedule()
    end
end

--@brief    计时器
function CellFamilyBuilding:setCaculate()
    --body
    local conForBuilding = self:_createConForBuilding()
    if self.m_tData.countdown > 0 then 
        self.m_tData.countdown = self.m_tData.countdown - 1
        self:showPrgForTime()
    else
        conForBuilding:disableSchedule()
        if self.m_tData.buildingStatus == 0 then 
            SceneFamily:updateOneBuildingData(self.m_tData.configId, self.m_tData.buildingStatus, self.m_tData.countdown, self.m_tData.indexX, self.m_tData.indexY)
            --刷新底部按钮类型
            SceneFamily:resetClickBuildingAfterFinish(self.m_tData.indexX, self.m_tData.indexY, 0)
            --请求数据刷新
            local tBasicData = GDatatab_home_building["id_" .. self.m_tData.configId]
            if tBasicData and (tBasicData.sub_type == 1 or tBasicData.sub_type == 2) then 
                if SceneFamily.m_tWaterAndStoneUpdateMark and SceneFamily.m_tWaterAndStoneUpdateMark[tBasicData.sub_type] == nil then 
                    SceneFamily.m_tWaterAndStoneUpdateMark[tBasicData.sub_type] = true
                    SceneFamily:toRequestUpdate()
                end
            else
                SceneFamily:toRequestUpdate()
            end
            self:showPrgForTime()
        elseif self.m_tData.buildingStatus == 1 then    --建造
            self.m_tData.buildingStatus = 0 
            SceneFamily:updateOneBuildingData(self.m_tData.configId, self.m_tData.buildingStatus, self.m_tData.countdown, self.m_tData.indexX, self.m_tData.indexY)
            --刷新底部按钮类型
            SceneFamily:resetClickBuildingAfterFinish(self.m_tData.indexX, self.m_tData.indexY, 1)
            --请求数据刷新
            SceneFamily:toRequestUpdate()
            self:showPrgForTime()
        elseif self.m_tData.buildingStatus == 2 then    --升级
            self.m_tData.buildingStatus = 0
            SceneFamily:updateOneBuildingData(self.m_tData.basicData.post_id, self.m_tData.buildingStatus, self.m_tData.countdown, self.m_tData.indexX, self.m_tData.indexY)
            WZLog("CellFamilyBuilding:setCaculate", Serialize(SceneFamily.m_tGridList[self.m_tData.indexX][self.m_tData.indexY]))
            self:setBuildingData(SceneFamily.m_tGridList[self.m_tData.indexX][self.m_tData.indexY])
            self:_updateNameAndLevel()
            --刷新底部按钮类型
            SceneFamily:resetClickBuildingAfterFinish(self.m_tData.indexX, self.m_tData.indexY, 2)
            --请求数据刷新
            SceneFamily:toRequestUpdate()
        elseif self.m_tData.buildingStatus == 3 then    --移除
            self.m_tData.buildingStatus = 0
            --清楚建筑草地
            SceneFamily:cleanBuildingLawn(self.m_tData.indexX, self.m_tData.indexY)
            --清空相应地图数据
            SceneFamily:cleanOneGridData(self.m_tData.indexX - 1, self.m_tData.indexY - 1)
            --请求数据刷新
            SceneFamily:toRequestUpdate()
            --刷新底部按钮类型
            SceneFamily:resetClickBuildingAfterFinish(self.m_tData.indexX, self.m_tData.indexY, 3)
            self.m_root:removeFromParentAndCleanup(true)
        elseif self.m_tData.buildingStatus == 4 then  --研究
            self.m_tData.buildingStatus = 5
            SceneFamily:updateOneBuildingData(self.m_tData.configId, self.m_tData.buildingStatus, self.m_tData.countdown, self.m_tData.indexX, self.m_tData.indexY)
            --请求数据刷新
            SceneFamily:toRequestUpdate()
        end 
        --倒计时结束，释放一个佣人
        WZLog("CellFamilyBuilding:setCaculate  END" )
    end
end

--@brief    播放收集动画
--@param    num:收集到的数量
function CellFamilyBuilding:playCollectAni(num)
    --body
    local conForBuilding = self:_createConForBuilding()
    local tBasicData = self.m_tData.basicData
    if conForBuilding then
        local spineGet = WZUISpine:create()
        spineGet:setScale(0.5)
        spineGet:setRelativePosition(GlobalMethod:ccp(0.5, 0.7))
        spineGet:setVisible(true)
        spineGet:setTouchEnable(false)
        local spineFilePath 
        if tBasicData.type == 1 and tBasicData.sub_type == 1 then --圣水
            spineFilePath = "ui/family/building/family_shengshui"
        elseif tBasicData.type == 1 and tBasicData.sub_type == 2 then --奇石
            spineFilePath = "ui/family/building/family_kuangshi"
        end
        spineGet:setFileJson(spineFilePath .. ".json")
        spineGet:setFileAtlas(spineFilePath .. ".atlas")
        spineGet:play("animation", false)

        local txtNumAtlas = WZUILabelAtlasFont:create()
        txtNumAtlas:setCharMapFileName("ui/common_num/common_num_vip.png")
        txtNumAtlas:setHeight(40)
        txtNumAtlas:setWidth(22)
        txtNumAtlas:setUseOriginSize(true)
        txtNumAtlas:setUseOriginSizeProportion(false)
        txtNumAtlas:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        txtNumAtlas:setRelativePosition(GlobalMethod:ccp(0.5,0.6))
        txtNumAtlas:setText(num)
        spineGet:addChild(txtNumAtlas)
        local actMoveBy = CCMoveBy:create(0.5,GlobalMethod:ccp(0,60))
        txtNumAtlas:runAction(actMoveBy)
        
        conForBuilding:addChild(spineGet, 10, 444)
        self.m_root:enableSchedule("collectFinish", 0.8)
    end
end

--@brief    收集动画完成后，清楚特效动画
function CellFamilyBuilding:collectFinish(element)
    --body
    local conForBuilding = self:_createConForBuilding()
    self.m_root:disableSchedule()
    self.m_tData.currentNum = 0 
    WZLog("CellFamilyBuilding:collectFinish", type(conForBuilding))
    if conForBuilding then
        if conForBuilding:getChildByTag(444) then
            conForBuilding:removeChildByTag(444,true)
        end
    end
    --如果有领取标记，则去掉
    self:playMakeBuildingCollectState()
    --如果是圣水，则进度条重置
    self:showWaterProgress()
end

--@brief    播放主人房待机额外的特效
function CellFamilyBuilding:playMainRoomAni()
    --body
    local conForBuilding = self:_createConForBuilding()
    if conForBuilding:getChildByTag(111) then 
        conForBuilding:removeChildByTag(111, true)
    end
    if conForBuilding then
        local spineGet = WZUISpine:create()
        spineGet:setScale(1)
        spineGet:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        spineGet:setRelativePosition(GlobalMethod:ccp(0.5, 0))
        spineGet:setVisible(true)
        spineGet:setTouchEnable(false)
        local spineFilePath  = "ui/family/building/family_masterroomfx"
        spineGet:setFileJson(spineFilePath .. ".json")
        spineGet:setFileAtlas(spineFilePath .. ".atlas")
        spineGet:play("family_masterroomfx", true)
        spineGet:setTag(111)

        conForBuilding:addChild(spineGet)
    end
end
--@brief    牧场特效
function CellFamilyBuilding:playPastureAni()
    --body
    local conForBuilding = self:_createConForBuilding()
    if conForBuilding:getChildByTag(111) then 
        conForBuilding:removeChildByTag(111, true)
    end
    if conForBuilding then
        local spineGet = WZUISpine:create()
        spineGet:setScale(1)
        spineGet:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        spineGet:setRelativePosition(GlobalMethod:ccp(0.5, 0))
        spineGet:setVisible(true)
        spineGet:setTouchEnable(false)
        local spineFilePath  = "ui/family/building/family_pasture"
        spineGet:setFileJson(spineFilePath .. ".json")
        spineGet:setFileAtlas(spineFilePath .. ".atlas")
        spineGet:play("wait", true)
        spineGet:setTag(111)

        conForBuilding:addChild(spineGet)
    end
end
--@brief    播放佣人房待机额外的特效
function CellFamilyBuilding:playButlerAni()
    --body
    local conForBuilding = self:_createConForBuilding()
    if conForBuilding:getChildByTag(222) then 
        conForBuilding:removeChildByTag(222, true)
    end
    if self.m_nType == 1 then return end 

    if conForBuilding then
        local spineGet = WZUISpine:create()
        spineGet:setScale(0.5)
        spineGet:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        spineGet:setVisible(true)
        spineGet:setTouchEnable(false)
        local spineFilePath  = "ui/family/building/family_maidroomfx"
        if self.m_tData.countdown > 0 then
            spineFilePath  = "ui/family/building/family_doorfx"
        end
        spineGet:setFileJson(spineFilePath .. ".json")
        spineGet:setFileAtlas(spineFilePath .. ".atlas")
        if self.m_tData.countdown > 0 then
            spineGet:setRelativePosition(GlobalMethod:ccp(0.5, 0.15))
            spineGet:play("open", true)
        else
            spineGet:setRelativePosition(GlobalMethod:ccp(0.45, 0.25))
            spineGet:play("stand", true)
        end
        spineGet:setTag(222)
        conForBuilding:addChild(spineGet)
    end
end

--@brief    显示收集器可以收集的状态
--@param    bVisible:false为不可见    
function CellFamilyBuilding:playMakeBuildingCollectState(bVisible)
    --body
    local conForBuilding = self:_createConForBuilding()
    if conForBuilding:getChildByTag(333) then 
        conForBuilding:removeChildByTag(333, true)
    end
    if self.m_nType == 1 then return end 
    if self.m_tData.currentNum < 50 then return end   
    if bVisible == false then return end 
    if conForBuilding then
        local imgCollectState = WZUIImage:create()
        imgCollectState:setScale(1)
        imgCollectState:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        imgCollectState:setVisible(true)
        imgCollectState:setUseOriginSize(true)
        imgCollectState:setTouchEnable(false)
        local spineFilePath = "ui/family/other/mainBtn/family_06.png"
        imgCollectState:setFile(spineFilePath)
        imgCollectState:setRelativePosition(GlobalMethod:ccp(0.5, 0.8))
        --收集的物品图标
        local imgIcon = WZUIImage:create()
        imgIcon:setScale(0.5)
        imgIcon:setAnchorPoint(GlobalMethod:ccp(0.5, 1))
        imgIcon:setVisible(true)
        imgIcon:setUseOriginSize(true)
        imgIcon:setTouchEnable(false)
        spineFilePath = GDatatab_item["id_" .. self.m_tData.basicData.functions[1][2]].icon
        imgIcon:setFile(spineFilePath)
        imgIcon:setRelativePosition(GlobalMethod:ccp(0.5, 0.96))
        imgIcon:setZOrder(1)
        imgCollectState:addChild(imgIcon)

        imgCollectState:setTag(333)
        conForBuilding:addChild(imgCollectState)
    end
end

--@brief    创建建筑spine动画节点
function CellFamilyBuilding:_createBuildingSpineNode()
    -- body
    local conForBuilding = self:_createConForBuilding()
    local spineBuilding = conForBuilding:getChildByTag(99) 
    if not spineBuilding then 
        local tData = self.m_tData.basicData
        spineBuilding = WZUISpine:create()
        spineBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        spineBuilding:setRelativePosition(GlobalMethod:ccp(tData.position[1][1], tData.position[1][2]))
        spineBuilding:setTouchEnable(false)
        spineBuilding:setTag(99)
        spineBuilding:setZOrder(0)

        conForBuilding:addChild(spineBuilding)
    else
        spineBuilding = WZUISpine:luaTo(spineBuilding)
    end

    return spineBuilding
end

--@brief    创建建筑Image节点
function CellFamilyBuilding:_createBuildingImageNode()
    -- body
    local conForBuilding = self:_createConForBuilding()
    local imgBuilding = conForBuilding:getChildByTag(98) 
    if not imgBuilding then 
        imgBuilding = WZUIImage:create()
        imgBuilding:setUseOriginSize(true)
        imgBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        imgBuilding:setTouchEnable(false)
        imgBuilding:setTag(98)
        imgBuilding:setZOrder(0)

        conForBuilding:addChild(imgBuilding)
    else
        imgBuilding = WZUIImage:luaTo(imgBuilding)
    end

    return imgBuilding
end

--@brief    创建建筑的等级和名字
function CellFamilyBuilding:_createBuildingNameAndLevel(bVisible)
    -- body
    local conForBuilding = self:_createConForBuilding()
    if conForBuilding:getChildByTag(97) then
        conForBuilding:removeChildByTag(97, true)
    end
    if bVisible then
        local conForName = WZUIContainer:create()
        conForName:setTouchContainerEnable(false)
        conForName:setTouchEnable(false)
        conForName:setZOrder(3)
        conForName:setTag(97)

        conForBuilding:addChild(conForName)
        --建筑名字
        local txtName = WZUILabelTTF:create()
        txtName:setColor(GlobalMethod:ccc3(255,236,193))
        txtName:setStrokeColor(GlobalMethod:ccc3(127,70,26))
        txtName:setFontSize(16)
        txtName:setEnableStroke(true)
        txtName:setStrokeSize(4)
        txtName:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        txtName:setRelativePosition(GlobalMethod:ccp(0.5, 1))
        txtName:setText(self.m_tData.basicInfo.name)
        txtName:setTag(11)
        conForName:addChild(txtName)
        --建筑等级
        local txtLevel = WZUILabelTTF:create()
        txtLevel:setColor(GlobalMethod:ccc3(255,236,193))
        txtLevel:setStrokeColor(GlobalMethod:ccc3(127,70,26))
        txtLevel:setFontSize(16)
        txtLevel:setEnableStroke(true)
        txtLevel:setStrokeSize(4)
        txtLevel:setAnchorPoint(GlobalMethod:ccp(0.5, 1))
        txtLevel:setRelativePosition(GlobalMethod:ccp(0.5, 0))
        txtLevel:setText("Lv" .. self.m_tData.basicData.level)
        txtLevel:setTag(12)
        txtName:addChild(txtLevel)
    end
end

--@brief    更新名字等级
function CellFamilyBuilding:_updateNameAndLevel()
    -- body
--    WZLog("CellFamilyBuilding:_updateNameAndLevel", Serialize(self.m_tData))
    local conForBuilding = self:_createConForBuilding()
    local conForName = conForBuilding:getChildByTag(97)
    if not conForName then return end 
    local txtName = conForName:getChildByTag(11)
    if txtName == nil then return end
    txtName = WZUILabelTTF:luaTo(txtName)
    txtName:setText(self.m_tData.basicInfo.name)
    local txtLevel = txtName:getChildByTag(12)
    if txtLevel == nil then return end
    txtLevel = WZUILabelTTF:luaTo(txtLevel)
    txtLevel:setText("Lv" .. self.m_tData.basicData.level)
end

--@brief    创建建筑的箭头
function CellFamilyBuilding:_createBuildingArrow(bVisible)
    -- body
    local conOutSide = self:_createOutSideCon()
    if conOutSide:getChildByTag(96) then
        conOutSide:removeChildByTag(96, true)
    end

    if bVisible then
        local tData = self.m_tData.basicData
        local nConWidth = tData.size[1][2] * MAP_REAL_WIDTH
        local nConHeight = tData.size[1][1] * MAP_REAL_WIDTH

        local conForArrow = WZUIContainer:create()
        conForArrow:setTouchContainerEnable(false)
        conForArrow:setTouchEnable(false)
        conForArrow:setUseAbsSize(true)
        conForArrow:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conForArrow:setZOrder(1)
        conForArrow:setTag(96)

        conOutSide:addChild(conForArrow)

        local conTemp1 = WZUIContainer:create()
        conTemp1:setTouchContainerEnable(false)
        conTemp1:setTouchEnable(false)
        conTemp1:setUseAbsSize(true)
        conTemp1:setRotation(38)
        conTemp1:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))

        conForArrow:addChild(conTemp1)
        --右箭头
        local imgRightArrow = WZUIImage:create()
        imgRightArrow:setFile("ui/common/battle_icon_shangsheng.png")
        imgRightArrow:setUseOriginSize(true)
        imgRightArrow:setTouchEnable(false)
        imgRightArrow:setRotation(90)
        imgRightArrow:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        imgRightArrow:setRelativePosition(GlobalMethod:ccp(1,0.5))
        conTemp1:addChild(imgRightArrow)
        --左箭头
        local imgLeftArrow = WZUIImage:create()
        imgLeftArrow:setFile("ui/common/battle_icon_shangsheng.png")
        imgLeftArrow:setUseOriginSize(true)
        imgLeftArrow:setTouchEnable(false)
        imgLeftArrow:setRotation(-90)
        imgLeftArrow:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        imgLeftArrow:setRelativePosition(GlobalMethod:ccp(0,0.5))
        conTemp1:addChild(imgLeftArrow)

        local conTemp2 = WZUIContainer:create()
        conTemp2:setTouchContainerEnable(false)
        conTemp2:setTouchEnable(false)
        conTemp2:setUseAbsSize(true)
        conTemp2:setRotation(52)
        conTemp2:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))

        conForArrow:addChild(conTemp2)
        --下箭头
        local imgDownArrow = WZUIImage:create()
        imgDownArrow:setFile("ui/common/battle_icon_shangsheng.png")
        imgDownArrow:setUseOriginSize(true)
        imgDownArrow:setTouchEnable(false)
        imgDownArrow:setRotation(0)
        imgDownArrow:setFlipY(true)
        imgDownArrow:setAnchorPoint(GlobalMethod:ccp(0.5,1))
        imgDownArrow:setRelativePosition(GlobalMethod:ccp(0.5,0))
        conTemp2:addChild(imgDownArrow)
        --上箭头
        local imgUpArrow = WZUIImage:create()
        imgUpArrow:setFile("ui/common/battle_icon_shangsheng.png")
        imgUpArrow:setUseOriginSize(true)
        imgUpArrow:setTouchEnable(false)
        imgUpArrow:setRotation(0)
        imgUpArrow:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        imgUpArrow:setRelativePosition(GlobalMethod:ccp(0.5,1))
        conTemp2:addChild(imgUpArrow)
    end
end

--@brief    创建顶部的勾叉按钮
function CellFamilyBuilding:_createBuildMenu(bVisible)
    -- body
    local conOutSide = self:_createOutSideCon()

    if bVisible then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEX
        local conBuildBtn = WZUIContainer:create()
        conBuildBtn:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        conBuildBtn:setRelativePosition(GlobalMethod:ccp(0.5,1.1))
        conBuildBtn:setUseAbsSize(true)
        conBuildBtn:setAbsContentSize(GlobalMethod:CCSize(nConWidth, 60))
        conBuildBtn:setZOrder(4)
        conBuildBtn:setTag(95)

        conOutSide:addChild(conBuildBtn)
        --确认按钮
        local btnSure = WZUIButton:create()
        btnSure:setName("btnSure_CellFamilyBuilding")
        btnSure:setUseAbsSize(true)
        btnSure:setAbsContentSize(GlobalMethod:CCSize(50,60))
        btnSure:setRelativePosition(GlobalMethod:ccp(1,0.5))
        local imgNor = WZUIImage:create()
        imgNor:setUseOriginSize(true)
        imgNor:setFile("ui/common/common_icon_gou.png")
        local imgSel = WZUIImage:create()
        imgSel:setUseOriginSize(true)
        imgSel:setFile("ui/common/common_icon_gou.png")
        local imgNot = WZUIImage:create()
        imgNot:setUseOriginSize(true)
        imgNot:setGrayRender(true)
        imgNot:setFile("ui/common/common_icon_gou.png")
        btnSure:setNormalElement(imgNor)
        btnSure:setSelectElement(imgSel)
        btnSure:setDisableElement(imgNot)
        btnSure:setTag(11)
        btnSure:setLuaDoneFunctionName("onClickSure")
        conBuildBtn:addChild(btnSure)
        --取消按钮
        local btnCancel = WZUIButton:create()
        btnCancel:setName("btnCancel_CellFamilyBuilding")
        btnCancel:setUseAbsSize(true)
        btnCancel:setAbsContentSize(GlobalMethod:CCSize(50,60))
        btnCancel:setRelativePosition(GlobalMethod:ccp(0,0.5))
        local imgNor2 = WZUIImage:create()
        imgNor2:setUseOriginSize(true)
        imgNor2:setFile("ui/common/common_icon_guanbi.png")
        local imgSel2 = WZUIImage:create()
        imgSel2:setUseOriginSize(true)
        imgSel2:setFile("ui/common/common_icon_guanbi.png")
        btnCancel:setNormalElement(imgNor2)
        btnCancel:setSelectElement(imgSel2)
        btnCancel:setLuaDoneFunctionName("onClickCancel")
        conBuildBtn:addChild(btnCancel)
    end
end

--@brief    创建时间进度条
function CellFamilyBuilding:_createTimeProgress(bVisible)
    -- body
    local conForBuilding = self:_createConForBuilding()

    if bVisible then 
        if conForBuilding:getChildByTag(94) then return end 

        local tData = self.m_tData.basicData
        local conForTime = WZUIContainer:create()
        conForTime:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conForTime:setRelativePosition(GlobalMethod:ccp(0.5,0.85))
        conForTime:setUseAbsSize(true)
        conForTime:setTouchEnable(false)
        conForTime:setAbsContentSize(GlobalMethod:CCSize(130, 18))
        conForTime:setZOrder(4)
        conForTime:setTag(94)

        conForBuilding:addChild(conForTime)
        --确认按钮
        local imgBG = WZUIImage:create()
        imgBG:setUseOriginSize(true)
        imgBG:setFile("ui/family/other/mainBtn/progress_di.png")
        imgBG:setScale(0.75)
        conForTime:addChild(imgBG)
        --进度条
        local prgLeftTime = WZUIProgress:create()
        prgLeftTime:setBgPicture("ui/family/other/mainBtn/progress_blue.png")
        prgLeftTime:setUseOriginSize(true)
        prgLeftTime:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        prgLeftTime:setTag(22)
        prgLeftTime:setScale(0.75)
        conForTime:addChild(prgLeftTime)
        --时间
        local txtLeftTime = WZUILabelTTF:create()
        txtLeftTime:setColor(GlobalMethod:ccc3(255,255,255))
        txtLeftTime:setStrokeColor(GlobalMethod:ccc3(105,65,46))
        txtLeftTime:setFontSize(16)
        txtLeftTime:setEnableStroke(true)
        txtLeftTime:setStrokeSize(4)
        txtLeftTime:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        txtLeftTime:setRelativePosition(GlobalMethod:ccp(0.5, 0.66667))
        txtLeftTime:setTag(23)
        conForTime:addChild(txtLeftTime)
    else
--        WZLog("CellFamilyBuilding:_createTimeProgress 0000")
        if conForBuilding:getChildByTag(94) then
            conForBuilding:removeChildByTag(94, true)
        end
    end
end

--@brief    创建背景容器节点
function CellFamilyBuilding:_createConForBG()
    -- body
    local conOutSide = self:_createOutSideCon()
    local conForBG = conOutSide:getChildByTag(93)

    if not conForBG then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEY

        conForBG = WZUIContainer:create()
        conForBG:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conForBG:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        conForBG:setTouchEnable(false)
        conForBG:setUseAbsSize(true)
        conForBG:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conForBG:setZOrder(0)
        conForBG:setTag(93)

        conOutSide:addChild(conForBG)
    end

    return conForBG
end

--@brief    创建建筑物容器节点
function CellFamilyBuilding:_createConForBuilding()
    -- body
    local conOutSide = self:_createOutSideCon()

    local conForBuilding = conOutSide:getChildByTag(92)

    if not conForBuilding then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEY

        conForBuilding = WZUIContainer:create()
        conForBuilding:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        conForBuilding:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        conForBuilding:setTouchEnable(false)
        conForBuilding:setUseAbsSize(true)
        conForBuilding:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conForBuilding:setZOrder(2)
        conForBuilding:setTag(92)

        conOutSide:addChild(conForBuilding)
    else
        conForBuilding = WZUIContainer:luaTo(conForBuilding)
    end

    return conForBuilding
end

--@brief    创建建筑物容器节点
function CellFamilyBuilding:_createBtnBuilding()
    -- body
    local conOutSide = self:_createOutSideCon()

    local btnBuilding = conOutSide:getChildByTag(91)

    if not btnBuilding then 
        local tData = self.m_tData.basicData
        local nConWidth = tData.size[1][2] * MAP_REAL_WIDTH
        local nConHeight = tData.size[1][1] * MAP_REAL_WIDTH

        btnBuilding = WZUIButton:create()
        btnBuilding:setName("btnBuilding_CellFamilyBuilding")
        btnBuilding:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        btnBuilding:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        btnBuilding:setUseAbsSize(true)
        btnBuilding:setRotation(-45)
        btnBuilding:setLuaDoneFunctionName("onClickBuilding")
        btnBuilding:setLuaPushFunctionName("ptInBtnCallBack")
        btnBuilding:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        btnBuilding:setZOrder(3)
        btnBuilding:setTag(91)

        conOutSide:addChild(btnBuilding)
    else
        btnBuilding = WZUIButton:luaTo(btnBuilding)
    end

    return btnBuilding
end

--@brief    创建根容器节点
function CellFamilyBuilding:_createOutSideCon()
    -- body
    local conOutSide = self.m_root:getChildByTag(90)

    if not conOutSide then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * MAP_SIZEY

        conOutSide = WZUIContainer:create()
        conOutSide:setUseAbsSize(true)
        conOutSide:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conOutSide:setTag(90)

        self.m_root:addChild(conOutSide)
    else
        conOutSide = WZUIContainer:luaTo(conOutSide)
    end

    return conOutSide
end

--@brief    显示异界传送门有奖励可以领取的状态
--@param    bVisible:false为不可见    
function CellFamilyBuilding:playDoorRewardState(bVisible)
    --body
    local conForBuilding = self:_createConForBuilding()
    if conForBuilding:getChildByTag(89) then 
        conForBuilding:removeChildByTag(89, true)
    end
    if self.m_nType == 1 then return end 
    if self.m_tData.buildingStatus <= 4 then return end   
    if bVisible == false then return end 
    if conForBuilding then
        local spineRewardBox = WZUISpine:create()
        spineRewardBox:setScale(0.5)
        spineRewardBox:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        spineRewardBox:setVisible(true)
        spineRewardBox:setTouchEnable(false)
        local spineFilePath  = "ui/family/building/family_chest"
        spineRewardBox:setFileJson(spineFilePath .. ".json")
        spineRewardBox:setFileAtlas(spineFilePath .. ".atlas")
        if self.m_tData.buildingStatus == 5 then
            spineRewardBox:setRelativePosition(GlobalMethod:ccp(0.15, 0.55))
            spineRewardBox:play("wait", true)
            spineRewardBox:setTag(89)
            conForBuilding:addChild(spineRewardBox)
        end

    end
end

--@brief    创建打工中的宠物和看守兽形象
function CellFamilyBuilding:showWorkPetAndMount()
    -- body
    local conOutSide = self:_createOutSideCon()

    local nIndex = 1 
    local bWorking = false 
    for i = 1, #SceneFamily.m_tWorkerData do
        if conOutSide:getChildByTag(89 - i) then
            conOutSide:removeChildByTag(89 - i, true)
        end
        local element, tNewObj = CellFamilyWorker:createElement()
        if element and tNewObj then
            tNewObj:setData(SceneFamily.m_tWorkerData[i], 1)
            tNewObj:setItemClickFun(self, self.receiveWorkReward)
            if SceneFamily.m_tWorkerData[i].leftTime <= 0 then
                element:setRelativePosition(GlobalMethod:ccp(self.m_tPetPosition[i][1], self.m_tPetPosition[i][2]))
            else
                element:setPosition(CellFamilyBuilding.m_tTargetPoint2[1][1], CellFamilyBuilding.m_tTargetPoint2[1][2])
                local nDelayTime = math.floor(math.random(2,8))
                local conTemp = self:_createTempPetCon(i)
                element:setVisible(false)
                WZLog("CellFamilyBuilding:showWorkPetAndMount", nDelayTime)
                if nIndex == 1 then 
                    nDelayTime = 0 
                    nIndex = 2
                end
                bWorking = true
                conTemp:enableSchedule("showPetByTime", nDelayTime)
            end
            element:setZOrder(4)
            element:setTag(89 - i)
            conOutSide:addChild(element)
        end
    end
    --打工特效
    if bWorking then
        self:playWorkSpaceAni(true)
    end
    --守护兽
    self:addProtectMount()
end

--@brief    创建临时容器节点
function CellFamilyBuilding:_createTempPetCon(i)
    -- body
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

--@brief    间隔显示宠物，不要一块显示出来
function CellFamilyBuilding:showPetByTime(element)
    -- body
    WZLog("CellFamilyBuilding:showPetByTime")
    element:disableSchedule()
    local nTag = 69 - element:getTag()
    local conOutSide = self:_createOutSideCon()
    celElement = conOutSide:getChildByTag(89 - nTag)
    celElement:setVisible(true)
    element:removeFromParentAndCleanup(true)

    self:_createPetMoveLine(celElement)
end

--@brief    点击打工完成的宠物回调
function CellFamilyBuilding:receiveWorkReward(tCell, tData)
    -- body
    if SceneFamily.m_nPlayerId ~= CacheCenter:getPlayerInfo().id and SceneFamily.m_nRecoverTime > 0 then
        WndFamilyOperate:onClickHurt()
        return 
    end
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if SceneFamily.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then
        ProtocolProcessorFamily:send_HOME_StealWorkReward(tData.playerPetId, SceneFamily.m_nPlayerId)
    else
        ProtocolProcessorFamily:send_HOME_ReceieveWorkReward(tData.playerPetId)
    end
end

--@brief    移除掉某一个打工宠物
function CellFamilyBuilding:removeWorkPet(id)
    -- body
    local conOutSide = self:_createOutSideCon()
    local nNum = SceneFamily:getMaxPetNum()
    for i = 1, nNum do
        local element = conOutSide:getChildByTag(89 - i) 
        if element then
            element = WZUIContainer:luaTo(element)
            local tNewObj = element:getLuaObjectIndex()
            if tNewObj then
                local tData = tNewObj:getData()
                if tData and tData.playerPetId == id then
                    element:removeFromParentAndCleanup(true)
                    break 
                end
            end
        end
    end
end

--@brief    移除掉某一个打工宠物
function CellFamilyBuilding:removeWorkPetGoldIcon(id)
    -- body
    local conOutSide = self:_createOutSideCon()
    local nNum = SceneFamily:getMaxPetNum()
    for i = 1, nNum do
        local element = conOutSide:getChildByTag(89 - i) 
        if element then
            element = WZUIContainer:luaTo(element)
            local tNewObj = element:getLuaObjectIndex()
            if tNewObj then
                local tData = tNewObj:getData()
                if tData and tData.playerPetId == id then
                    tNewObj:removeGoldIcon()
                    break 
                end
            end
        end
    end
end


--@brief    添加新的打工宠物形象
function CellFamilyBuilding:addNewWorkPet(tData)
    -- body
    local conOutSide = self:_createOutSideCon()

    local nNum = SceneFamily:getMaxPetNum()
    local nIndex = 1
    for i = 1, nNum do
        local element = conOutSide:getChildByTag(89 - i) 
        if not element then
            nIndex = i
            break 
        end
    end

    WZLog("CellFamilyBuilding:addNewWorkPet", nIndex)
    local element, tNewObj = CellFamilyWorker:createElement()
    if element and tNewObj then
        tNewObj:setData(tData, 1)
        tNewObj:setItemClickFun(self, self.receiveWorkReward)

        element:setPosition(CellFamilyBuilding.m_tTargetPoint2[1][1], CellFamilyBuilding.m_tTargetPoint2[1][2])
        self:_createPetMoveLine(element)
        element:setZOrder(4)
        element:setTag(89 - nIndex)
        conOutSide:addChild(element)
    end
    --有打工中的宠物，添加打工特效
    self:playWorkSpaceAni(true)
end

--@brief    添加守护兽形象
function CellFamilyBuilding:addProtectMount()
    -- body
    local conOutSide = self:_createOutSideCon()
    WZLog("CellFamilyBuilding:addProtectMount")
    if conOutSide:getChildByTag(79) then
        conOutSide:removeChildByTag(79, true)
    end
    if SceneFamily.m_nProtectMountId > 0 then
        local element, tNewObj = CellFamilyWorker:createElement()
        if element and tNewObj then
            local tData = CopyTable(GDatatab_guardromon["id_" .. SceneFamily.m_nProtectMountId])
            tData.basicInfo = GDatatab_item["id_" .. tData.item_id]
            tNewObj:setData(tData, 2)
            element:setZOrder(5)
            element:setRelativePosition(GlobalMethod:ccp(0.68,0.32))
            element:setTag(79)
            conOutSide:addChild(element)
        end
    end
end

--@brief    添加新的打工宠物形象
function CellFamilyBuilding:petFinishWork(id)
    -- body
    local conOutSide = self:_createOutSideCon()

    local nNum = SceneFamily:getMaxPetNum()
    local bIsWorking = false 
    for i = 1, nNum do
        local element = conOutSide:getChildByTag(89 - i) 
        if element then
            element = WZUIContainer:luaTo(element)
            local tCell = element:getLuaObjectIndex()
            if tCell then
                local tData = tCell:getData()
                if tData.leftTime > 0 then
                    bIsWorking = true 
                end
                if tData.playerPetId == id then
                    element:stopAllActions()
                    element:setVisible(true)
                    element:setRelativePosition(GlobalMethod:ccp(self.m_tPetPosition[i][1], self.m_tPetPosition[i][2]))
                end
            end
        end
    end

    if not bIsWorking then
        self:playWorkSpaceAni(false)
    end
end

--@brief    宠物到达终点，隐藏
local function petHide(element)
    -- body
    element:setVisible(false)
end

--@brief    延时后，反向运动
local function petShow(element)
    -- body
    element:setVisible(true)
end

--@brief    发转宠物朝向
local function petFlipX1(element)
    -- body
    local tCell = element:getLuaObjectIndex()
    if tCell then
        tCell:setPetDirector(true)
    end
end

--@brief    宠物不反转
local function petFlipX2(element)
    -- body
    local tCell = element:getLuaObjectIndex()
    if tCell then
        tCell:setPetDirector(false)
    end
end

--@brief    创建宠物运行路线
function CellFamilyBuilding:_createPetMoveLine(element)
    -- body
    local nLineIndex = math.floor(math.random(1,3))
    local arrayAni = CCArray:create()

    local moveTo
    local moveTo2
    if nLineIndex == 1 then
        moveTo = CCMoveTo:create(10, ccp(CellFamilyBuilding.m_tTargetPoint1[1][1], CellFamilyBuilding.m_tTargetPoint1[1][2]))
    elseif nLineIndex == 2 then
        moveTo = CCMoveTo:create(9, ccp(CellFamilyBuilding.m_tSecondPoint[1][1], CellFamilyBuilding.m_tSecondPoint[1][2]))
        moveTo2 = CCMoveTo:create(9, ccp(CellFamilyBuilding.m_tTargetPoint1[1][1], CellFamilyBuilding.m_tTargetPoint1[1][2]))
    else
        moveTo = CCMoveTo:create(10, ccp(CellFamilyBuilding.m_tThirdPoint[1][1], CellFamilyBuilding.m_tThirdPoint[1][2]))
        moveTo2 = CCMoveTo:create(10, ccp(CellFamilyBuilding.m_tTargetPoint1[1][1], CellFamilyBuilding.m_tTargetPoint1[1][2]))
    end
    local functionAni1 = CCCallFuncN:create(petHide)
    local functionAni2 = CCCallFuncN:create(petShow)
    local functionAni3 = CCCallFuncN:create(petShow)
    local functionAni4 = CCCallFuncN:create(petHide)
    local functionAni5 = CCCallFuncN:create(petFlipX1)
    local functionAni6 = CCCallFuncN:create(petFlipX2)
    local nDelayTime = math.floor(math.random(3,15))
    local delayAni5 = CCDelayTime:create(nDelayTime)
    local moveReverse1 
    local moveReverse2 
    if nLineIndex == 1 then
        moveReverse1 = CCMoveTo:create(10, ccp(CellFamilyBuilding.m_tTargetPoint2[1][1], CellFamilyBuilding.m_tTargetPoint2[1][2]))
    elseif nLineIndex == 2 then
        moveReverse1 = CCMoveTo:create(9, ccp(CellFamilyBuilding.m_tSecondPoint[1][1], CellFamilyBuilding.m_tSecondPoint[1][2]))
        moveReverse2 = CCMoveTo:create(9, ccp(CellFamilyBuilding.m_tTargetPoint2[1][1], CellFamilyBuilding.m_tTargetPoint2[1][2]))
    else
        moveReverse1 = CCMoveTo:create(10, ccp(CellFamilyBuilding.m_tThirdPoint[1][1], CellFamilyBuilding.m_tThirdPoint[1][2]))
        moveReverse2 = CCMoveTo:create(10, ccp(CellFamilyBuilding.m_tTargetPoint2[1][1], CellFamilyBuilding.m_tTargetPoint2[1][2]))
    end
    nDelayTime = math.floor(math.random(3,15))
    local delayAni6 = CCDelayTime:create(nDelayTime)

    arrayAni:addObject(functionAni5)
    arrayAni:addObject(moveTo)
    if moveTo2 then
        arrayAni:addObject(moveTo2)
    end
    arrayAni:addObject(functionAni1)
    arrayAni:addObject(delayAni5)
    arrayAni:addObject(functionAni2)
    arrayAni:addObject(functionAni6)
    arrayAni:addObject(moveReverse1)
    if moveReverse2 then
        arrayAni:addObject(moveReverse2)
    end
    arrayAni:addObject(functionAni4)
    arrayAni:addObject(delayAni6)
    arrayAni:addObject(functionAni3)

    local sequence = CCSequence:create(arrayAni)
    local repeatAni = CCRepeatForever:create(sequence)
    element:runAction(repeatAni)
end

--@brief    播放打工房待机的特效
--@param    bAddAni:true添加特效;false移除特效
function CellFamilyBuilding:playWorkSpaceAni(bAddAni)
    --body
    WZLog("CellFamilyBuilding:playWorkSpaceAni")
    --房顶冒烟
    local conForBuilding = self:_createConForBuilding()
    if bAddAni then
        if conForBuilding and not conForBuilding:getChildByTag(59) then 
            local spineGet = WZUISpine:create()
            spineGet:setScale(1)
            spineGet:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
            spineGet:setRelativePosition(GlobalMethod:ccp(0.05, 0.7))
            spineGet:setVisible(true)
            spineGet:setTouchEnable(false)
            local spineFilePath  = "ui/family/building/family_work_qipao"
            spineGet:setFileJson(spineFilePath .. ".json")
            spineGet:setFileAtlas(spineFilePath .. ".atlas")
            spineGet:play("wait", true)
            spineGet:setTag(59)

            conForBuilding:addChild(spineGet)
        end

        --矿洞闪光
        if conForBuilding and not conForBuilding:getChildByTag(58) then
            local spineGet = WZUISpine:create()
            spineGet:setScale(1)
            spineGet:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
            spineGet:setRelativePosition(GlobalMethod:ccp(0.73, 0.46))
            spineGet:setVisible(true)
            spineGet:setTouchEnable(false)
            local spineFilePath  = "ui/family/building/family_work_light"
            spineGet:setFileJson(spineFilePath .. ".json")
            spineGet:setFileAtlas(spineFilePath .. ".atlas")
            spineGet:play("animation", true)
            spineGet:setTag(58)

            conForBuilding:addChild(spineGet)
        end
    else
        if conForBuilding:getChildByTag(59) then
            conForBuilding:removeChildByTag(59, true)
        end

        if conForBuilding:getChildByTag(58) then
            conForBuilding:removeChildByTag(58, true)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
