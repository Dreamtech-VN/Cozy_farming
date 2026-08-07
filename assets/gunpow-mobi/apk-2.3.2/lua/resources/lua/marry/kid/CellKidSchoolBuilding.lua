--CellKidSchoolBuilding.lua
--@brief	CellKidSchoolBuilding的UI模块
--@date     2021/5/10
--@author   yrd
--@note		家园建筑节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidSchoolBuilding:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidSchoolBuilding:onExit(element)
	self:_unInit()
end

--@brief    点击建筑回调
function CellKidSchoolBuilding:onClickBuilding(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneKidSchoolHome:onClickBuildingCallBack(self.m_root, self, self.m_tData)
end

--@brief    触摸点是否在建筑上
function CellKidSchoolBuilding:ptInBtnCallBack(element)
    -- body
    WZLog("CellKidSchoolBuilding:ptInBtnCallBack")
    SceneKidSchoolHome:judgePtInBuilding(self.m_tData)
end

--@brief    点击建造按钮回调
function CellKidSchoolBuilding:onClickSure(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneKidSchoolHome:tobuildNewBuilding(self.m_tData)
end

--@brief    点击建造按钮回调
function CellKidSchoolBuilding:onClickCancel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    SceneKidSchoolHome:cancelTobuildNewBuilding(self.m_tData)
end

--@brief    检测是否点在按钮区域
function CellKidSchoolBuilding:checkPointInBtn(pt)
    -- body
    if self.m_root == nil then return false end
    local btnBuilding = self:_createBtnBuilding()
    if btnBuilding == nil then return false end

    local btnSize2 = btnBuilding:getContentSize()
    local ptB = btnBuilding:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("CellKidSchoolBuilding:checkPointInBtn", pt.x, pt.y, ptB.x, ptB.y, btnSize2.width, btnSize2.height)
    if (pt.x > ptB.x and pt.x < ptB.x + btnSize2.width) and (pt.y > ptB.y and pt.y < ptB.y + btnSize2.height) then
        return true
    end

    return false
end

--@brief    设置建筑是否可点击
function CellKidSchoolBuilding:setBuildingTouch(bEnable)
    -- body
    local btnBuilding = self:_createBtnBuilding()
    if btnBuilding then 
        btnBuilding:setTouchEnable(bEnable)
    end
end

--@brief    设置建筑的翻转
function CellKidSchoolBuilding:setBuildFlipX(flipStatus)
    -- body
    if self.m_root == nil then return end 

    self.m_tData.flipStatus = flipStatus
    local spineBuilding 
    if self.m_tData.basicData.type == 13 then 
        if self.m_tData.basicData.id == 50012 then 
            spineBuilding = self:_createBuildingArmatureNode()
            if flipStatus == 1 then 
                spineBuilding:setRelativePosition(GlobalMethod:ccp(-0.05, self.m_tData.basicData.position[1][2]))
            else
                spineBuilding:setRelativePosition(GlobalMethod:ccp(self.m_tData.basicData.position[1][1], self.m_tData.basicData.position[1][2]))
            end
        else
            spineBuilding = self:_createBuildingImageNode()
        end
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
function CellKidSchoolBuilding:redrawBuilding()
    -- body
    if self.m_root == nil then return end 
    self:_drawBuilding()
end

--@brief    获取可收集标记
function CellKidSchoolBuilding:getCollectIcon()
    --body
    local conForBuilding = self:_createConForBuilding()
    return conForBuilding:getChildByTag(333)
end
    
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellKidSchoolBuilding:_update()
    -- body
    WZLog("CellKidSchoolBuilding:_update", self.m_tData.basicData.id)

    --设置相应容器大小
    self:_setContainerSize()
    --显示建筑
    self:_drawBuilding()
    --按钮
    self:_createBtnBuilding()
end

--@brief    设置Cell容器大小
function CellKidSchoolBuilding:_setContainerSize()
    -- body
    local tData = self.m_tData.basicData
    local element = WZUIContainer:luaTo(self.m_root)
    --计算容器大小
    local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEX
    local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEY

    element:setContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
    element:setRelativeSize(GlobalMethod:CCSize(1,1))
    element:updateRelativeSize()
end

--@brief    设置建筑底部草地
--@brief    state:默认显示草地；1->显示绿色；2->显示红色
function CellKidSchoolBuilding:setBuildingBG(state)
    -- body
    local tData = self.m_tData.basicData

    local conForBG = self:_createConForBG()
    conForBG = WZUIContainer:luaTo(conForBG)

    local gapX = KID_MAP_SIZEX / 2 
    local gapY = KID_MAP_SIZEY / 2 
--    if state == -1 then state = 1 end

    if conForBG then
        conForBG:removeAllChildrenWithCleanup(true)
        if state == -1 then return end 
        for i = 1, tData.size[1][1] do
            local startX = 0 + (i - 1) * gapX
            local startY = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEY / 2 - (i - 1) * gapY--tData.size[1][1] * 0.5 * KID_MAP_SIZEY - (i - 1) * gapY
            for j = 1, tData.size[1][2] do
                local imgMap = WZUIImage:create()
                imgMap:setUseOriginSize(true)
                imgMap:setUseAbsCoordinate(true)
                if state == 1 then 
                    imgMap:setFile("ui/kid/kidicon/kid_sel.png")
                elseif state == 2 then 
                    imgMap:setFile("ui/kid/kidicon/kid_sel.png")
                    imgMap:setColor(GlobalMethod:ccc3(255,0,0))
                end
                imgMap:setAbsPosition(GlobalMethod:ccp(startX + j * gapX, startY + (j - 1) * gapY))
                
                conForBG:addChild(imgMap)
            end
        end
    end
end

--@brief    显示建筑
function CellKidSchoolBuilding:_drawBuilding()
    -- body
    local tData = self.m_tData.basicData

    if tData.type == 12 or tData.type == 13 or tData.type == 7 or tData.type == 8 or tData.type == 9 or tData.type == 10 or tData.type == 11 then
        if tData.id == 50039 then
            self:_createLibraryAreaBuildingNode()
        elseif tData.id == 50040 then
            self:_createRestAreaBuildingNode()
        elseif tData.id == 50041 then
            self:_createTechnologyAreaBuildingNode()
        elseif tData.id == 50042 then
            self:_createSportsAreaBuildingNode()
        elseif tData.id == 50043 then
            self:_createStudyAreaBuildingNode()
        else
            local imgBuilding = self:_createBuildingImageNode()
            if imgBuilding then
                imgBuilding:setFile(tData.animation)
                imgBuilding:setRelativePosition(GlobalMethod:ccp(tData.position[1][1], tData.position[1][2]))
                if self.m_tData.basicInfo.main_type == 30 and self.m_tData.basicInfo.sub_type == 2 then
                    imgBuilding:setScale(0.6)
                end
            end
        end
    end

    --翻转的状态
    self:setBuildFlipX(self.m_tData.flipStatus)
end

--@brief    创建小孩形象
function CellKidSchoolBuilding:updateKidsRole()
    self:removeAllKid()

    if self.m_tAreaData.areaType == 1 then
        self:showKidStudy()
    elseif self.m_tAreaData.areaType == 2 then
        self:showKidSleep()
    elseif self.m_tAreaData.areaType == 3 then
        self:showKidRun()
    elseif self.m_tAreaData.areaType == 4 then
        self:showKidResearch()
    end
end

--@brief    移除全部小孩形象
function CellKidSchoolBuilding:removeAllKid()
    local conOutSide = self:createOutSideCon()
    for i=1,self.m_nMaxKidCount do
        if conOutSide:getChildByTag(89 - i) then
            conOutSide:removeChildByTag(89 - i, true)
        end
    end
end

--@brief    移除一个小孩形象根据id
function CellKidSchoolBuilding:removeKidAniById(nId)
    local conOutSide = self:createOutSideCon()
    for i=#self.m_tKidObjList,1,-1 do
        if next(self.m_tKidObjList[i]) and self.m_tKidObjList[i]:getData().id == nId then
            if conOutSide:getChildByTag(89 - i) then
                conOutSide:removeChildByTag(89 - i, true)
            end
            self.m_tKidObjList[i] = {}
        end
    end
end

--@brief    创建一个小孩形象
function CellKidSchoolBuilding:createOneKidAni(tKidData)

    local conOutSide = self:createOutSideCon()
    if next(tKidData) then
        local element, tNewObj = CellKidSchoolRole:createElement()
        if element and tNewObj then
            tNewObj:setData(tKidData)
            tNewObj:setItemClickFun(self, self.onClickBuildingKid)
            if self.m_tAreaData.areaType == 1 then
                element:setRelativePosition(GlobalMethod:ccp(self.m_tStudyAreaPos[tKidData.position][1], self.m_tStudyAreaPos[tKidData.position][2]))
                element:setZOrder(4)
                tNewObj:playKidAni("sit",true)
                tNewObj:setKidDirector(false)
            elseif self.m_tAreaData.areaType == 2 then
                element:setRelativePosition(GlobalMethod:ccp(self.m_tRestAreaPos[tKidData.position][1], self.m_tRestAreaPos[tKidData.position][2]))
                element:setZOrder(4)
                tNewObj:playKidAni("sleep",true)
                element:setRotation(30)
                tNewObj:setKidDirector(true)
            elseif self.m_tAreaData.areaType == 3 then
                local conTemp = self:_createTempPetCon(tKidData.position)
                element:setVisible(false)
                conTemp:enableSchedule("showKidByTime")
                element:setZOrder(4+1+#tKidData-tKidData.position)
            elseif self.m_tAreaData.areaType == 4 then
                element:setRelativePosition(GlobalMethod:ccp(self.m_tTechnologyAreaPos[tKidData.position][1], self.m_tTechnologyAreaPos[tKidData.position][2]))
                element:setZOrder(4)
                tNewObj:playKidAni("gun_1",true)
                if tKidData.position % 2 == 0 then
                    tNewObj:setKidDirector(true)
                end
            end
            element:setTag(89 - tKidData.position)
            conOutSide:addChild(element)
            self.m_tKidObjList[tKidData.position] = tNewObj
            -- table.insert(self.m_tKidObjList,tNewObj)
        end
    end

end

--@brief    创建孩子在学习区学习形象
function CellKidSchoolBuilding:showKidStudy()
    local conOutSide = self:createOutSideCon()

    local tKidData = self.m_tKidsData
    for i = 1, #tKidData do
        if next(tKidData[i]) then
            local element, tNewObj = CellKidSchoolRole:createElement()
            if element and tNewObj then
                tNewObj:setData(tKidData[i])
                tNewObj:setItemClickFun(self, self.onClickBuildingKid)
                element:setRelativePosition(GlobalMethod:ccp(self.m_tStudyAreaPos[tKidData[i].position][1], self.m_tStudyAreaPos[tKidData[i].position][2]))
                element:setZOrder(4)
                element:setTag(89 - i)
                conOutSide:addChild(element)

                tNewObj:playKidAni("sit",true)
                tNewObj:setKidDirector(false)
                self.m_tKidObjList[i] = tNewObj
            end
        else
            self.m_tKidObjList[i] = {}
        end
    end
end

--@brief    创建孩子在休息区睡觉形象
function CellKidSchoolBuilding:showKidSleep()
    local conOutSide = self:createOutSideCon()

    local tKidData = self.m_tKidsData
    for i = 1, #tKidData do
        if next(tKidData[i]) then
            local element, tNewObj = CellKidSchoolRole:createElement()
            if element and tNewObj then
                tNewObj:setData(tKidData[i])
                tNewObj:setItemClickFun(self, self.onClickBuildingKid)
                element:setRelativePosition(GlobalMethod:ccp(self.m_tRestAreaPos[tKidData[i].position][1], self.m_tRestAreaPos[tKidData[i].position][2]))
                element:setZOrder(4)
                element:setTag(89 - i)
                conOutSide:addChild(element)

                tNewObj:playKidAni("sleep",true)
                element:setRotation(30)
                tNewObj:setKidDirector(true)
                self.m_tKidObjList[i] = tNewObj
            end
        else
            self.m_tKidObjList[i] = {}
        end
    end
end

--@brief    创建孩子在科技区研究形象
function CellKidSchoolBuilding:showKidResearch()
    local conOutSide = self:createOutSideCon()

    local tKidData = self.m_tKidsData
    for i = 1, #tKidData do
        if next(tKidData[i]) then
            local element, tNewObj = CellKidSchoolRole:createElement()
            if element and tNewObj then
                tNewObj:setData(tKidData[i])
                tNewObj:setItemClickFun(self, self.onClickBuildingKid)
                element:setRelativePosition(GlobalMethod:ccp(self.m_tTechnologyAreaPos[tKidData[i].position][1], self.m_tTechnologyAreaPos[tKidData[i].position][2]))
                element:setZOrder(4)
                element:setTag(89 - i)
                conOutSide:addChild(element)

                tNewObj:playKidAni("gun_1",true)
                if i % 2 == 0 then
                    tNewObj:setKidDirector(true)
                end
                self.m_tKidObjList[i] = tNewObj
            end
        else
            self.m_tKidObjList[i] = {}
        end
    end
end

--@brief    创建孩子在运动区跑步形象
function CellKidSchoolBuilding:showKidRun()
    local conOutSide = self:createOutSideCon()

    local tKidData = self.m_tKidsData
    for i = 1, #tKidData do
        if next(tKidData[i]) then
            local element, tNewObj = CellKidSchoolRole:createElement()
            if element and tNewObj then
                tNewObj:setData(tKidData[i])
                tNewObj:setItemClickFun(self, self.onClickBuildingKid)
                local conTemp = self:_createTempPetCon(i)
                element:setVisible(false)
                conTemp:enableSchedule("showKidByTime")
                element:setZOrder(4+#tKidData-i)
                element:setTag(89 - i)
                conOutSide:addChild(element)
                self.m_tKidObjList[i] = tNewObj
            end
        else
            self.m_tKidObjList[i] = {}
        end
    end
end

--@brief    间隔显示小孩，不要一块显示出来
function CellKidSchoolBuilding:showKidByTime(element)
    -- body
    WZLog("CellKidSchoolBuilding:showPetByTime")
    element:disableSchedule()
    local nTag = 69 - element:getTag()
    local conOutSide = self:createOutSideCon()
    celElement = conOutSide:getChildByTag(89 - nTag)

    self:_createKidMoveLine(celElement,nTag)
end

--@brief    小孩停
local function kidPlayRunAni(element)
    element:getLuaObjectIndex():playKidAni("walk",true)
end

--@brief    小孩停止
local function kidPlayWaitAni(element)
    element:getLuaObjectIndex():playKidAni("wait",true)
end

--@brief    宠物到达终点，隐藏
local function petHide(element)
    element:setVisible(false)
end

--@brief    延时后，反向运动
local function petShow(element)
    element:setVisible(true)
end

--@brief    发转宠物朝向
local function petFlipX1(element)
    local tCell = element:getLuaObjectIndex()
    if tCell then
        tCell:setKidDirector(true)
    end
end

--@brief    宠物不反转
local function petFlipX2(element)
    local tCell = element:getLuaObjectIndex()
    if tCell then
        tCell:setKidDirector(false)
    end
end

--@brief    创建小孩运行路线
function CellKidSchoolBuilding:_createKidMoveLine(element,nTag)
    element:setAbsPosition(GlobalMethod:ccp(self.m_tTargetPoint2[nTag][1], self.m_tTargetPoint2[nTag][2]))
    element:setUseAbsCoordinate(true)
    element:setVisible(true)
    kidPlayRunAni(element)

    local arrayAni = CCArray:create()

    local moveTo = CCMoveTo:create(3, ccp(self.m_tTargetPoint1[nTag][1], self.m_tTargetPoint1[nTag][2]))
    local functionAni1 = CCCallFuncN:create(kidPlayWaitAni)
    local functionAni2 = CCCallFuncN:create(kidPlayRunAni)
    local functionAni3 = CCCallFuncN:create(kidPlayRunAni)
    local functionAni4 = CCCallFuncN:create(kidPlayWaitAni)
    local functionAni5 = CCCallFuncN:create(petFlipX1)
    local functionAni6 = CCCallFuncN:create(petFlipX2)
    local nDelayTime = math.floor(math.random(1,3))
    local delayAni5 = CCDelayTime:create(nDelayTime)
    local moveReverse1 = CCMoveTo:create(3, ccp(self.m_tTargetPoint2[nTag][1], self.m_tTargetPoint2[nTag][2]))
    nDelayTime = math.floor(math.random(1,3))
    local delayAni6 = CCDelayTime:create(nDelayTime)

    arrayAni:addObject(functionAni5)
    arrayAni:addObject(moveTo)
    arrayAni:addObject(functionAni1)
    arrayAni:addObject(delayAni5)
    arrayAni:addObject(functionAni2)
    arrayAni:addObject(functionAni6)
    arrayAni:addObject(moveReverse1)
    arrayAni:addObject(functionAni4)
    arrayAni:addObject(delayAni6)
    arrayAni:addObject(functionAni3)

    local sequence = CCSequence:create(arrayAni)
    local repeatAni = CCRepeatForever:create(sequence)
    element:runAction(repeatAni)
end

--@brief    创建临时容器节点
function CellKidSchoolBuilding:_createTempPetCon(i)
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

--@brief    设置移动箭头的可见
function CellKidSchoolBuilding:setArrowVisible(bVisible)
    -- body
    local tData = self.m_tData.basicData
    if tData.type == 1 then 
        self:_createBuildingArrow(bVisible)
    end

    self:_createBuildingNameAndLevel(bVisible)
end

--@brief    设置新建按钮是否可见
function CellKidSchoolBuilding:setBuildNewBtnVisible(bVisible)
    -- body
    if self.m_root == nil then return end 
    self:_createBuildMenu(bVisible)
end

--@brief    设置新建按钮状态
function CellKidSchoolBuilding:setSureState(bTouchEnable)
    -- body
    if self.m_root == nil then return end 
    local conOutSide = self:createOutSideCon()
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

--@brief    创建建筑骨骼动画节点
function CellKidSchoolBuilding:_createBuildingArmatureNode()
    -- body
    local conForBuilding = self:_createConForBuilding()
    local equipArmature = conForBuilding:getChildByTag(98) 
    if not equipArmature then 
        local tData = self.m_tData.basicData

        -- equipArmature = CreatePlayerBabyFigure(tData.sex, nil, "ride")
        -- equipArmature:setMount(self.m_tData.basicInfo.animation_index_code)
        -- equipArmature:getAnimNode():setRelativePosition(GlobalMethod:ccp(tData.position[1][1], tData.position[1][2]))
        -- equipArmature:getAnimNode():setTag(98)
        -- conForBuilding:addChild(equipArmature:getAnimNode())

        local equipArmature = WZArmature:create()
        equipArmature:setTouchEnable(false)
        equipArmature:setArmatureName( "babymount_002" )
        equipArmature:setUseOriginSize(true)
        equipArmature:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        equipArmature:setRelativePosition(GlobalMethod:ccp(tData.position[1][1], tData.position[1][2]))
        local file = "baby/mount/" .. "babymount_002" .. ".xml"
        equipArmature:setArmatureFile(file)
        equipArmature:setTag(98)
        equipArmature:setZOrder(0)
        conForBuilding:addChild(equipArmature)
    else
        equipArmature = WZArmature:luaTo(equipArmature)
    end

    return equipArmature
end

--@brief    创建建筑Image节点
function CellKidSchoolBuilding:_createBuildingImageNode()
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

--@brief    创建学校图书角节点 对应id=50039
function CellKidSchoolBuilding:_createLibraryAreaBuildingNode()
    local conForBuilding = self:_createConForBuilding()
    local conBuilding = conForBuilding:getChildByTag(98)
    if not conBuilding then
        conBuilding = WZUIContainer:create()
        conBuilding:setUseAbsSize(true)
        conBuilding:setTouchEnable(false)
        conBuilding:setTag(98)
        conBuilding:setZOrder(0)
        conBuilding:setAbsContentSize(GlobalMethod:CCSize(100, 100))
        conBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        conForBuilding:addChild(conBuilding)

        imgBuilding1 = WZUIImage:create()
        imgBuilding1:setUseOriginSize(true)
        imgBuilding1:setRelativePosition(GlobalMethod:ccp(-0.2, 0.7))
        imgBuilding1:setFile("ui/kid/kidicon/kid_yueduqu1.png")
        imgBuilding1:setTouchEnable(false)
        conBuilding:addChild(imgBuilding1)

        imgBuilding2 = WZUIImage:create()
        imgBuilding2:setUseOriginSize(true)
        imgBuilding2:setRelativePosition(GlobalMethod:ccp(1.5, 0.2))
        imgBuilding2:setFile("ui/kid/kidicon/kid_yueduqu4.png")
        imgBuilding2:setTouchEnable(false)
        conBuilding:addChild(imgBuilding2)

        imgBuilding3 = WZUIImage:create()
        imgBuilding3:setUseOriginSize(true)
        imgBuilding3:setRelativePosition(GlobalMethod:ccp(1, -0.1))
        imgBuilding3:setFile("ui/kid/kidicon/kid_yueduqu2.png")
        imgBuilding3:setTouchEnable(false)
        conBuilding:addChild(imgBuilding3)

        imgBuilding4 = WZUIImage:create()
        imgBuilding4:setUseOriginSize(true)
        imgBuilding4:setRelativePosition(GlobalMethod:ccp(0.5, -0.4))
        imgBuilding4:setFile("ui/kid/kidicon/kid_yueduqu3.png")
        imgBuilding4:setTouchEnable(false)
        conBuilding:addChild(imgBuilding4)
    else
        conBuilding = WZUIContainer:luaTo(conBuilding)
    end
    return conBuilding
end

--@brief    创建学校休息区节点 对应id=50040
function CellKidSchoolBuilding:_createRestAreaBuildingNode()
    local conForBuilding = self:_createConForBuilding()
    local conBuilding = conForBuilding:getChildByTag(98)
    if not conBuilding then
        conBuilding = WZUIContainer:create()
        conBuilding:setUseAbsSize(true)
        conBuilding:setTouchEnable(false)
        conBuilding:setTag(98)
        conBuilding:setZOrder(0)
        conBuilding:setAbsContentSize(GlobalMethod:CCSize(100, 100))
        conBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        conForBuilding:addChild(conBuilding)

        imgBuilding1 = WZUIImage:create()
        imgBuilding1:setUseOriginSize(true)
        imgBuilding1:setRelativePosition(GlobalMethod:ccp(-1.2, 0.2))
        imgBuilding1:setFile("ui/kid/kidicon/kid_chuang.png")
        imgBuilding1:setTouchEnable(false)
        conBuilding:addChild(imgBuilding1)

        imgBuilding2 = WZUIImage:create()
        imgBuilding2:setUseOriginSize(true)
        imgBuilding2:setRelativePosition(GlobalMethod:ccp(0.4, -0.65))
        imgBuilding2:setFile("ui/kid/kidicon/kid_chuang.png")
        imgBuilding2:setTouchEnable(false)
        conBuilding:addChild(imgBuilding2)

        imgBuilding3 = WZUIImage:create()
        imgBuilding3:setUseOriginSize(true)
        imgBuilding3:setRelativePosition(GlobalMethod:ccp(2, -1.5))
        imgBuilding3:setFile("ui/kid/kidicon/kid_chuang.png")
        imgBuilding3:setTouchEnable(false)
        conBuilding:addChild(imgBuilding3)
    else
        conBuilding = WZUIContainer:luaTo(conBuilding)
    end
    return conBuilding
end

--@brief    创建学校科技区节点 对应id=50041
function CellKidSchoolBuilding:_createTechnologyAreaBuildingNode()
    local conForBuilding = self:_createConForBuilding()
    local conBuilding = conForBuilding:getChildByTag(98)
    if not conBuilding then
        conBuilding = WZUIContainer:create()
        conBuilding:setUseAbsSize(true)
        conBuilding:setTouchEnable(false)
        conBuilding:setTag(98)
        conBuilding:setZOrder(0)
        conBuilding:setAbsContentSize(GlobalMethod:CCSize(100, 100))
        conBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        conForBuilding:addChild(conBuilding)

        imgBuilding1 = WZUIImage:create()
        imgBuilding1:setUseOriginSize(true)
        imgBuilding1:setRelativePosition(GlobalMethod:ccp(0.5, 0.7))
        imgBuilding1:setFile("ui/kid/kidicon/kid_kexuequ.png")
        imgBuilding1:setTouchEnable(false)
        conBuilding:addChild(imgBuilding1)
    else
        conBuilding = WZUIContainer:luaTo(conBuilding)
    end
    return conBuilding
end

--@brief    创建学校运动区节点 对应id=50042
function CellKidSchoolBuilding:_createSportsAreaBuildingNode()
    local conForBuilding = self:_createConForBuilding()
    local conBuilding = conForBuilding:getChildByTag(98)
    if not conBuilding then
        conBuilding = WZUIContainer:create()
        conBuilding:setUseAbsSize(true)
        conBuilding:setTouchEnable(false)
        conBuilding:setTag(98)
        conBuilding:setZOrder(0)
        conBuilding:setAbsContentSize(GlobalMethod:CCSize(100, 100))
        conBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        conForBuilding:addChild(conBuilding)

        imgBuilding1 = WZUIImage:create()
        imgBuilding1:setUseOriginSize(true)
        imgBuilding1:setRelativePosition(GlobalMethod:ccp(0.5, -0.5))
        imgBuilding1:setFile("ui/kid/kidicon/kid_paodao.png")
        imgBuilding1:setTouchEnable(false)
        conBuilding:addChild(imgBuilding1)
    else
        conBuilding = WZUIContainer:luaTo(conBuilding)
    end
    return conBuilding
end

--@brief    创建学校学习区节点 对应id=50043
function CellKidSchoolBuilding:_createStudyAreaBuildingNode()
    local conForBuilding = self:_createConForBuilding()
    local conBuilding = conForBuilding:getChildByTag(98)
    if not conBuilding then
        conBuilding = WZUIContainer:create()
        conBuilding:setUseAbsSize(true)
        conBuilding:setTouchEnable(false)
        conBuilding:setTag(98)
        conBuilding:setZOrder(0)
        conBuilding:setAbsContentSize(GlobalMethod:CCSize(100, 100))
        conBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
        conForBuilding:addChild(conBuilding)

        imgBuilding1 = WZUIImage:create()
        imgBuilding1:setUseOriginSize(true)
        imgBuilding1:setRelativePosition(GlobalMethod:ccp(0.5, 0.7))
        imgBuilding1:setFile("ui/kid/kidicon/kid_yizi.png")
        imgBuilding1:setTouchEnable(false)
        conBuilding:addChild(imgBuilding1)

        imgBuilding2 = WZUIImage:create()
        imgBuilding2:setUseOriginSize(true)
        imgBuilding2:setRelativePosition(GlobalMethod:ccp(-0.4, 0.2))
        imgBuilding2:setFile("ui/kid/kidicon/kid_yizi.png")
        imgBuilding2:setTouchEnable(false)
        conBuilding:addChild(imgBuilding2)

        imgBuilding3 = WZUIImage:create()
        imgBuilding3:setUseOriginSize(true)
        imgBuilding3:setRelativePosition(GlobalMethod:ccp(1.4, 0.2))
        imgBuilding3:setFile("ui/kid/kidicon/kid_yizi.png")
        imgBuilding3:setTouchEnable(false)
        conBuilding:addChild(imgBuilding3)

        imgBuilding4 = WZUIImage:create()
        imgBuilding4:setUseOriginSize(true)
        imgBuilding4:setRelativePosition(GlobalMethod:ccp(0.5, -0.3))
        imgBuilding4:setFile("ui/kid/kidicon/kid_yizi.png")
        imgBuilding4:setTouchEnable(false)
        conBuilding:addChild(imgBuilding4)
    else
        conBuilding = WZUIContainer:luaTo(conBuilding)
    end
    return conBuilding
end

--@brief    创建建筑的等级和名字
function CellKidSchoolBuilding:_createBuildingNameAndLevel(bVisible)
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
    end
end

--@brief    创建建筑的箭头
function CellKidSchoolBuilding:_createBuildingArrow(bVisible)
    -- body
    local conOutSide = self:createOutSideCon()
    if conOutSide:getChildByTag(96) then
        conOutSide:removeChildByTag(96, true)
    end

    if bVisible then
        local tData = self.m_tData.basicData
        local nConWidth = tData.size[1][2] * KIDMAP_REAL_WIDTH
        local nConHeight = tData.size[1][1] * KIDMAP_REAL_WIDTH

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
function CellKidSchoolBuilding:_createBuildMenu(bVisible)
    -- body
    local conOutSide = self:createOutSideCon()

    if bVisible then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEX
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
        btnSure:setName("btnSure_CellKidSchoolBuilding")
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
        btnCancel:setName("btnCancel_CellKidSchoolBuilding")
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

--@brief    创建背景容器节点
function CellKidSchoolBuilding:_createConForBG()
    -- body
    local conOutSide = self:createOutSideCon()
    local conForBG = conOutSide:getChildByTag(93)

    if not conForBG then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEY

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
function CellKidSchoolBuilding:_createConForBuilding()
    -- body
    local conOutSide = self:createOutSideCon()

    local conForBuilding = conOutSide:getChildByTag(92)

    if not conForBuilding then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEY

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
function CellKidSchoolBuilding:_createBtnBuilding()
    -- body
    local conOutSide = self:createOutSideCon()

    local btnBuilding = conOutSide:getChildByTag(91)

    if not btnBuilding then 
        local tData = self.m_tData.basicData
        local nConWidth = tData.size[1][2] * KIDMAP_REAL_WIDTH
        local nConHeight = tData.size[1][1] * KIDMAP_REAL_WIDTH

        btnBuilding = WZUIButton:create()
        btnBuilding:setName("btnBuilding_CellKidSchoolBuilding")
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
--@note     tag等于(89-self.m_nMaxKidCount)到89,被占用为小孩形象
function CellKidSchoolBuilding:createOutSideCon()
    -- body
    local conOutSide = self.m_root:getChildByTag(90)

    if not conOutSide then 
        local tData = self.m_tData.basicData
        local nConWidth = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEX
        local nConHeight = (tData.size[1][1] + tData.size[1][2]) * 0.5 * KID_MAP_SIZEY

        conOutSide = WZUIContainer:create()
        conOutSide:setUseAbsSize(true)
        conOutSide:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
        conOutSide:setTag(90)
    --    BattleAnimation:addRect({x=nConWidth/2, y=nConHeight/2, w=nConWidth, h=nConHeight},{r = 255,g = 255,b = 255,a = 1.0}, conOutSide)
        self.m_root:addChild(conOutSide)
    else
        conOutSide = WZUIContainer:luaTo(conOutSide)
    end

    return conOutSide
end

--@brief    点击建筑中的小孩回调
function CellKidSchoolBuilding:onClickBuildingKid(tCell, tData)
    -- body
    -- SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    -- WndKidSchoolKidInfo:showInterface()
end
-------------------------------------私有方法模块End----------------------------------------
