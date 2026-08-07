--CellFamilyWorker.lua
--@brief	CellFamilyWorker的UI模块
--@date		2017/07/26
--@author	Tianxiang_Xu
--@note		家园打工宠物或守卫兽节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFamilyWorker:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFamilyWorker:onExit(element)
    local conOutSide = self:_createOutSideCon() 
    conOutSide:disableSchedule()
    
	self:_unInit()
end

--@brief    点击头像回调
function CellFamilyWorker:onClickHead(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tData.leftTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.FAMILY_TEXT80)
        return 
    end
    if self.m_tBackFun then
        self.m_tBackFun[2](self.m_tBackFun[1], self, self.m_tData)
    end
end

--@brief    创建根容器节点
function CellFamilyWorker:_createOutSideCon()
    -- body
    local conOutSide = self.m_root:getChildByTag(90)

    if not conOutSide then 
        local nConWidth = 65
        local nConHeight = 75

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

--@brief    设置宠物的朝向
function CellFamilyWorker:setPetDirector(bFlipX)
    -- body
    local conOutSide = self:_createOutSideCon() 
    local element = conOutSide:getChildByTag(55)
    if element then
        element:setFlipX(bFlipX)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellFamilyWorker:_update()
    -- body
    local conOutSide = self:_createOutSideCon() 
    if self.m_nType == 1 then
        --宠物形象
        local petAni, backFire = CreatePetAni(conOutSide, nil, self.m_tData.animation, self.m_tData.advancedLevel)
        local animNode = petAni:getAnimNode()
        animNode:setScale(0.3)
        animNode:setTag(55)
        if backFire then
            backFire:setVisible(false)
        end

        local tWorker = json.decode(CacheCenter:getGameParam().servantWorkEfficiency)
        local stringEffect = tWorker[self.m_tData.effectType].name
        if self.m_tData.leftTime > 0 then
            --打工倒计时
            self:_createName(returnToTimeFormat(self.m_tData.leftTime), GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 1), 22)
            conOutSide:enableSchedule("_caculateTime", 1)
        else
            stringEffect = LocalStrings.FAMILY_TEXT77
            if SceneFamily.m_nPlayerId ~= CacheCenter:getPlayerInfo().id and self.m_tData.canSteal == 1 then
                self:_createGoldIcon("shopitems/gold_bag_003.png", GlobalMethod:ccp(0.5,1.2), 44)
            elseif SceneFamily.m_nPlayerId == CacheCenter:getPlayerInfo().id then
                self:_createGoldIcon("shopitems/gold_bag_003.png", GlobalMethod:ccp(0.5,1.2), 44)
            end
        end

        --名字（效率）
        self:_createName(self.m_tData.name .. "(" .. stringEffect .. ")", GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 0.8), 11)

        self:_createBtnBuilding()
    else
        --名字（状态）
        local stringState = LocalStrings.FAMILY_TEXT78
        if SceneFamily.m_nLeftProtectTime > 0 then
            stringState = LocalStrings.FAMILY_TEXT60
        end
        conOutSide:enableSchedule("_caculateTime", 1)

        self:_createName(self.m_tData.name .. "(" .. stringState .. ")", GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 0.8), 11)
        self:_createShadow(conOutSide, "ui/common/common_icon_xhd.png", GlobalMethod:ccp(0.5, 0), 0.4)
        self:_createMountAni(conOutSide, self.m_tData)
    end

end

--@brief    创建名字
function CellFamilyWorker:_createName(text, anchorPt, relativePt, nTag)
    -- body
    local conOutSide = self:_createOutSideCon() 

    local txtName = conOutSide:getChildByTag(nTag)
    if txtName then 
        txtName = WZUILabelTTF:luaTo(txtName)
        txtName:setText(text)
    else
        local txtName = WZUILabelTTF:create()
        txtName:setColor(GlobalMethod:ccc3(255,255,255))
        txtName:setStrokeColor(GlobalMethod:ccc3(105,65,46))
        txtName:setFontSize(14)
        txtName:setEnableStroke(true)
        txtName:setStrokeSize(2)
        txtName:setAnchorPoint(anchorPt)
        txtName:setRelativePosition(relativePt)
        txtName:setText(text)
        txtName:setZOrder(3)
        txtName:setTag(nTag)
        conOutSide:addChild(txtName)
    end
end

--@brief    创建完成打工图标
function CellFamilyWorker:_createGoldIcon(imgPath, relativePt, nTag)
    -- body
    local conOutSide = self:_createOutSideCon() 

    local imgGold = conOutSide:getChildByTag(nTag)
    if not imgGold then 
        local imgGold = WZUIImage:create()
        imgGold:setRelativePosition(relativePt)
        imgGold:setFile(imgPath)
        imgGold:setZOrder(3)
        imgGold:setTag(nTag)
        imgGold:setScale(0.6)
        conOutSide:addChild(imgGold)
    end
end

--@brief    移除金币图标
function CellFamilyWorker:removeGoldIcon()
    -- body
    local conOutSide = self:_createOutSideCon() 

    if conOutSide:getChildByTag(44) then
        conOutSide:removeChildByTag(44, true)
    end
end


--@brief    创建宠物点击按钮
function CellFamilyWorker:_createBtnBuilding()
    -- body
    WZLog("CellFamilyWorker:_createBtnBuilding")
    local conOutSide = self:_createOutSideCon() 

    btnBuilding = WZUIButton:create()
    btnBuilding:setName("btnHead_CellFamilyWorker")
    btnBuilding:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    btnBuilding:setRelativePosition(GlobalMethod:ccp(0.5, 0))
    btnBuilding:setUseAbsSize(true)
    btnBuilding:setAbsContentSize(GlobalMethod:CCSize(65,100))
    btnBuilding:setLuaDoneFunctionName("onClickHead")
    btnBuilding:setZOrder(3)
    btnBuilding:setTag(91)

    conOutSide:addChild(btnBuilding)
end

--@brief    倒计时
function CellFamilyWorker:_caculateTime()
    -- body
    local conOutSide = self:_createOutSideCon() 
    if self.m_nType == 1 then
        if self.m_tData.leftTime > 0 then
            self.m_tData.leftTime = self.m_tData.leftTime - 1 

            local txtTime = conOutSide:getChildByTag(22)
            txtTime = WZUILabelTTF:luaTo(txtTime)
            if txtTime then
                txtTime:setText(returnToTimeFormat(self.m_tData.leftTime))
            end
        else
            self.m_root:disableSchedule()
            if conOutSide:getChildByTag(22) then
                conOutSide:removeChildByTag(22, true)
            end
            --创建金币图标
            self:_createGoldIcon("shopitems/gold_bag_003.png", GlobalMethod:ccp(0.5,1.2), 44)

            local txtName = conOutSide:getChildByTag(11)
            txtName = WZUILabelTTF:luaTo(txtName)
            if txtName then
                txtName:setText(self.m_tData.name .. "(" .. LocalStrings.FAMILY_TEXT77 .. ")")
            end
            --停掉所有的action
            SceneFamily:dealwithFinishWork(self.m_tData.playerPetId)
        end
    else
        local stringState = LocalStrings.FAMILY_TEXT78
        if SceneFamily.m_nLeftProtectTime > 0 then
            stringState = LocalStrings.FAMILY_TEXT60
        end
        
        self:_createName(self.m_tData.name .. "(" .. stringState .. ")", GlobalMethod:ccp(0.5, 0), GlobalMethod:ccp(0.5, 0.9), 11)
    end
end

-- 坐骑动画
function CellFamilyWorker:_createMountAni(con, info)
    local sex = CacheCenter:getPlayerInfo().sex == 1 and true or false
    if con:getChildByTag(33) then con:removeChildByTag(33,true) end

    local head,body = CacheCenter:getHeadAndBodyColor()
    local ani = CreatePlayerFigure(sex, nil, "mount_show", nil, nil, nil, nil, nil, nil, nil, head, body, false)
    ani:setMount(info.basicInfo.animation_index_code)

    local node = ani:getAnimNode()
    node:setScale(0.2)
    con:addChild(node, 0, 33)
end

--@brief    创建阴影
function CellFamilyWorker:_createShadow(parentNode, imgPath, relativePt, nScale)
    -- body
    local imgGold = WZUIImage:create()
    imgGold:setUseOriginSize(true)
    imgGold:setRelativePosition(relativePt)
    imgGold:setFile(imgPath)
    imgGold:setScale(nScale)
    parentNode:addChild(imgGold)
end
-------------------------------------私有方法模块End----------------------------------------
