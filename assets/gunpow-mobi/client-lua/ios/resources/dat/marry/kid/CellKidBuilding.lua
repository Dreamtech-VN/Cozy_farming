--CellKidBuilding.lua
--@brief	CellKidBuilding的UI模块
--@date		2017/07/26
--@author	Tianxiang_Xu
--@note		家园建筑节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidBuilding:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidBuilding:onExit(element)
	self:_unInit()
end

--@brief    点击建筑回调
function CellKidBuilding:onClickBuilding(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneKidHome:onClickBuildingCallBack(self.m_root, self, self.m_tData)
end

--@brief    触摸点是否在建筑上
function CellKidBuilding:ptInBtnCallBack(element)
    -- body
    WZLog("CellKidBuilding:ptInBtnCallBack")
    SceneKidHome:judgePtInBuilding(self.m_tData)
end

--@brief    点击建造按钮回调
function CellKidBuilding:onClickSure(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    SceneKidHome:tobuildNewBuilding(self.m_tData)
end

--@brief    点击建造按钮回调
function CellKidBuilding:onClickCancel(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    SceneKidHome:cancelTobuildNewBuilding()
end

--@brief    检测是否点在按钮区域
function CellKidBuilding:checkPointInBtn(pt)
    -- body
    if self.m_root == nil then return false end
    local btnBuilding = self:_createBtnBuilding()
    if btnBuilding == nil then return false end

    local btnSize2 = btnBuilding:getContentSize()
    local ptB = btnBuilding:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("CellKidBuilding:checkPointInBtn", pt.x, pt.y, ptB.x, ptB.y, btnSize2.width, btnSize2.height)
    if (pt.x > ptB.x and pt.x < ptB.x + btnSize2.width) and (pt.y > ptB.y and pt.y < ptB.y + btnSize2.height) then
        return true
    end

    return false
end

--@brief    设置建筑是否可点击
function CellKidBuilding:setBuildingTouch(bEnable)
    -- body
    local btnBuilding = self:_createBtnBuilding()
    if btnBuilding then 
        btnBuilding:setTouchEnable(bEnable)
    end
end

--@brief    设置建筑的翻转
function CellKidBuilding:setBuildFlipX(flipStatus)
    -- body
    if self.m_root == nil then return end 

    self.m_tData.flipStatus = flipStatus
    local spineBuilding 
    if self.m_tData.basicData.type == 1 then 
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
function CellKidBuilding:redrawBuilding()
    -- body
    if self.m_root == nil then return end 
    self:_drawBuilding()
end

--@brief    获取可收集标记
function CellKidBuilding:getCollectIcon()
    --body
    local conForBuilding = self:_createConForBuilding()
    return conForBuilding:getChildByTag(333)
end
    
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellKidBuilding:_update()
    -- body
    WZLog("CellKidBuilding:_update", self.m_tData.basicData.id)
    --设置相应容器大小
    self:_setContainerSize()
    --显示建筑
    self:_drawBuilding()
    --按钮
    self:_createBtnBuilding()
end

--@brief    设置Cell容器大小
function CellKidBuilding:_setContainerSize()
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
function CellKidBuilding:setBuildingBG(state)
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
function CellKidBuilding:_drawBuilding()
    -- body
    local tData = self.m_tData.basicData

    if tData.type == 3 or tData.type == 2 or tData.type == 1 then 
        if tData.id == 50012 then 
            self:_createBuildingArmatureNode()
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

--@brief    设置移动箭头的可见
function CellKidBuilding:setArrowVisible(bVisible)
    -- body
    local tData = self.m_tData.basicData
    if tData.type == 1 then 
        self:_createBuildingArrow(bVisible)
    end

    self:_createBuildingNameAndLevel(bVisible)
end

--@brief    设置新建按钮是否可见
function CellKidBuilding:setBuildNewBtnVisible(bVisible)
    -- body
    if self.m_root == nil then return end 
    self:_createBuildMenu(bVisible)
end

--@brief    设置新建按钮状态
function CellKidBuilding:setSureState(bTouchEnable)
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

--@brief    创建建筑骨骼动画节点
function CellKidBuilding:_createBuildingArmatureNode()
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
function CellKidBuilding:_createBuildingImageNode()
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
function CellKidBuilding:_createBuildingNameAndLevel(bVisible)
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
function CellKidBuilding:_createBuildingArrow(bVisible)
    -- body
    local conOutSide = self:_createOutSideCon()
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
function CellKidBuilding:_createBuildMenu(bVisible)
    -- body
    local conOutSide = self:_createOutSideCon()

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
        btnSure:setName("btnSure_CellKidBuilding")
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
        btnCancel:setName("btnCancel_CellKidBuilding")
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
function CellKidBuilding:_createConForBG()
    -- body
    local conOutSide = self:_createOutSideCon()
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
function CellKidBuilding:_createConForBuilding()
    -- body
    local conOutSide = self:_createOutSideCon()

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
function CellKidBuilding:_createBtnBuilding()
    -- body
    local conOutSide = self:_createOutSideCon()

    local btnBuilding = conOutSide:getChildByTag(91)

    if not btnBuilding then 
        local tData = self.m_tData.basicData
        local nConWidth = tData.size[1][2] * KIDMAP_REAL_WIDTH
        local nConHeight = tData.size[1][1] * KIDMAP_REAL_WIDTH

        btnBuilding = WZUIButton:create()
        btnBuilding:setName("btnBuilding_CellKidBuilding")
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
function CellKidBuilding:_createOutSideCon()
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

--@brief    点击打工完成的宠物回调
function CellKidBuilding:receiveWorkReward(tCell, tData)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if SceneKidHome.m_nPlayerId ~= CacheCenter:getPlayerInfo().id then
        ProtocolProcessorFamily:send_HOME_StealWorkReward(tData.playerPetId, SceneKidHome.m_nPlayerId)
    else
        ProtocolProcessorFamily:send_HOME_ReceieveWorkReward(tData.playerPetId)
    end
end
-------------------------------------私有方法模块End----------------------------------------
