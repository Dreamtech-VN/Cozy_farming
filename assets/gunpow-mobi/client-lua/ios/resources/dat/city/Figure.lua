--Figure.lua
--@brief	Figure
--@date		2015/3/9
--@author	莫剑峰
--@note		主城的人物

--@brief	角色数据表
Figure =
{
    
    m_nTouchKeepTime = 0,       --持续按住的时间
    m_bIsMove = nil,            --是否正在移动
    m_tIsMoveToPos = nil,       --是否正在向着某点移动
    m_bIsCanControl = nil,      --能否控制
    m_anim = nil,               --人物动画
    m_tEquipList = nil,         --装备列表
    m_nSex = 0,                 --性别
    m_tPet = nil,               --宠物信息
    m_tPetAnim = nil,           --宠物动画
    m_sName = "",               --名字
    m_nFigureType = -1,         --人物类型
    m_nFigureId = -1,           --人物Id
    m_bIsMount = nil,           --是否乘坐坐骑
    m_tPetPos = nil,            --宠物位置
    m_tNameContainer = nil,     --名字容器
    m_tEtcAnim = nil,           --附加动画
    m_nRunTime = -1,            --经过了的时间
    m_nRunTimePre = -1,         --上次经过了的时间
    m_nIntervalTime = -1,       --每帧间隔时间
    m_nActionPreTime = nil,     --上次行动的时间
    m_nActionIntervalTime = 3,  --行动的间隔时间
    m_tPlayerInfo = nil,        --人物信息
    m_nSpeed = 0.0,             --移动速度(越小越快)
    m_nSpeedMount = 0.0,        --乘坐坐骑的移动速度(越小越快)
    m_bIsHaveAnim = nil,        --是否有动画
    m_tScene = nil,             --所属场景
    m_tUINode = nil,            --UINode(触摸用)
    m_nFaceDisplayIndex = 0,    --脸换装索引
    m_nMountDisplayIndex = 0,   --坐骑换装索引
    m_nDire = -1,               --移动方向,0向左,1向右
    m_nLv = 0,
    m_tLvLabel = nil,
    m_nOffset = 33,
    m_nOffsetMe = 0,
    m_nMountOffset = 45,
    m_tNameLabel = nil,
    m_sTitle = nil,
    m_tShadow = nil,
    m_nNameOffsetYBoy = 2.5,
    m_nNameOffsetYGirl = 2.5,
    m_nNameOffsetYChangeMonster = 2.5,
    m_nNameOffsetXChangeMonster = 0.45,
    m_nNameOffsetYMonster = 2.5,
    m_nNameOffsetXMonster = 0.45,
	m_bArrival = true,
	m_nStandTime = 0,			--在公会中站立的时间
	m_nTotalTime = 0,           --在公会中一次停留的总时间
	m_bStanding = false, 		--是否正在公会中站立
	m_bAction = 1, 				--行动类型，0站立，1跑步
    m_bIsMonster = false,
    m_bMountEffect = false,
    m_bIsChangeToMonster = false,
    m_nMountEffectTime = 0,
    m_animMountEffect = nil,
    m_tOldFootPos = nil,
    m_nFootId = nil,
    m_tKidAni = nil,             --小孩动画
}

--@brief	人物类型
FigureType = {
    Myself  = 0, 				--自己
    Other = 1, 					--其他玩家
    Npc = 2,                    --NPC
    Lover = 3,                  --伴侣
    Statue = 4,                 --雕像
    Score = 5,                 --积分雕像
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建人物
function Figure:create(equipList, sex, figureType, name, figureId, isArmature, isHaveAnim,lv, title, equips,footId)
    --WZLog("Figure:create one", figureId, figureType, name, Serialize(equipList))

    local figure = Figure:new()
    if equipList and type(equipList) == "table" then
        figure.m_tPlayerInfo = equipList
    elseif equipList and type(equipList) == "number" then
        figure.m_nAnimId = equipList
    end

    figure.m_tEquips = equips
    figure.m_nSex = sex
    figure.m_sName = name
    figure.m_nFigureType = figureType
    figure.m_nFigureId = figureId
    figure.m_bIsArmature = isArmature

    figure.m_sTitle = title

    figure.m_nActionIntervalTime = math.random(3,15)
    figure.m_nSpeed = 0.12
    figure.m_nSpeedMount = 0.078
    figure.m_tPetPos = BattleCommon:getPointTable(0,190)
    figure.m_nLv = lv
    figure.m_nFootId = footId

    if figure.m_nFigureType == FigureType.Myself then
        figure.m_tPlayerInfo = CacheCenter:getPlayerInfo()
        local colour,bodyColour = CacheCenter:getHeadAndBodyColor()
        figure.m_tPlayerInfo.colour = colour
        figure.m_tPlayerInfo.bodyColour = bodyColour
        figure.m_bIsCanControl = true
        --WZLog("Figure:create three", tostring(figure.m_tPlayerInfo))
    end

    if isHaveAnim == true then
        figure:createFigureAnim(equipList, sex, isArmature, true, nil)
    end
    --WZLog("Figure:create two")
    return figure
end

--@brief    改变人物动画
function Figure:changeFigureAnim()
    WZLog("Figure:changeFigureAnim one")
    local pos = self:getPosition()
    self.m_tNameLabel = nil

    if self.m_tNameContainer ~= nil then
        self.m_tNameContainer:removeFromParentAndCleanup(true)
        self.m_tNameContainer = nil
    end

    if self.m_tPetAnim ~= nil then
        if self.m_tPetAnim:getAnimNode():getParent() ~= nil then
            self.m_tPetAnim:getAnimNode():removeFromParentAndCleanup(true)
        end
        --self.m_tPetAnim:getAnimNode():release()
        self.m_tPetAnim = nil
    end

    if self.m_anim ~= nil then
        if self.m_anim:getAnimNode():getParent() ~= nil then
            self.m_anim:getAnimNode():removeFromParentAndCleanup(true)
        end
    end
    if self.m_tUINode ~= nil then
        if self.m_tUINode:getParent() ~= nil then
            self.m_tUINode:removeFromParentAndCleanup(true)
        end
    end

    local sceneManager = FigureSceneManager:getInstance()
    self:createFigureAnim(self.m_tPlayerInfo, self.m_nSex, self.m_bIsArmature, true, nil)

    if self.m_bIsMonster then
        self.m_bIsChangeToMonster = true
    else
        self.m_bIsChangeToMonster = false
    end
    if GlobalGame.g_nFigureSceneId == Chat_Channel_Guild_Scene then
        sceneManager.m_tFigureLayer:addChild(self.m_tUINode,2)
    else
        sceneManager.m_tFigureLayer:addChild(self.m_tUINode,3)
    end

    self.m_anim:getAnimNode():setVisible(true)
    self.m_tUINode:setContentSize(GlobalMethod:CCSize(63 ,135))
    self.m_anim:setPosition(Vector2:create(25, -12))

    self:createName()
    self.m_anim:getAnimNode():setScale(self.m_nScale)
    self:setPet()
    self:setPosition(pos)
    self:setKid()
end
--@brief    创建人物动画
function Figure:createFigureAnim(equipList, sex, isArmature, isReal, isOther)
    --WZLog("Figure:createFigureAnim zero-2", tostring(sex), tostring(isArmature), tostring(isReal), tostring(isOther), CacheCenter:getPlayerInfo().sex)
    self.m_nSex = sex
  
    if self.m_nFigureType ~= FigureType.Npc then
        WZLog("Figure:createFigureAnim three", self.m_tPlayerInfo.name,self.m_tPlayerInfo.colour,self.m_tPlayerInfo.bodyColour)
		WZLog("主城幻化",Serialize(self.m_tEquips))
        if self.m_nFigureType == FigureType.Myself then
            self.m_anim, _x, _y, self.m_bIsMonster = CreatePlayerFigure(self.m_nSex,nil,nil,nil,nil,nil,nil,nil,nil,nil,self.m_tPlayerInfo.colour,self.m_tPlayerInfo.bodyColour)
        else
            self.m_anim, _x, _y, self.m_bIsMonster = CreatePlayerFigure(self.m_nSex, self.m_tEquips,nil,nil,nil,nil,nil,nil,nil,nil,self.m_tPlayerInfo.colour,self.m_tPlayerInfo.bodyColour)
        end

        self:setKid()
        --self.m_anim:setWing()

    else
        WZLog("Figure:createFigureAnim four", self.m_nAnimId)
        if self.m_nAnimId == 1 then
            self.m_anim = BattleAnimation:createAnimation("instructor",false,"city")
        elseif self.m_nAnimId == 2 then
            self.m_anim = BattleAnimation:createAnimation("master",false,"city")
        else
            self.m_anim = BattleAnimation:createAnimation("city_businessman",false,"city")
        end
    end

    self.m_anim:getAnimNode():setTouchEnable(false)
    --self.m_anim:getAnimNode():retain()

    local scale = 0.60
    if self.m_nFigureType == FigureType.Score then
        scale = 0.75
    elseif self.m_nFigureType ~= FigureType.Npc then

    else
        if self.m_nAnimId == 1 then
            scale = 0.6
        else
            scale = 0.6
        end

    end
    self.m_nScale = scale
    if self.m_nFigureType == FigureType.Npc and self.m_nAnimId == 3 then
        self.m_anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.3,0.0))
    else
        self.m_anim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0.0))
    end
    self.m_bIsHaveAnim = true

    if true then
        self.m_tUINode = WZUINode:create()
        self.m_tUINode:setChildNode(self.m_anim:getAnimNode())
        self.m_tUINode:setDrawElementInfo(false)
        self.m_tUINode:setTouchEnable(true)

        if self.m_nFigureType == FigureType.Other then
            self.m_tUINode:setClickCallback("onOtherClick")
        elseif self.m_nFigureType == FigureType.Npc then
            self.m_tUINode:setClickCallback("onNpcClick")
        elseif self.m_nFigureType == FigureType.Statue then
            self.m_tUINode:setClickCallback("onStatueClick")
        elseif self.m_nFigureType == FigureType.Score then
            self.m_tUINode:setClickCallback("onScoreClick")
        end

        if self.m_nFigureType ~= FigureType.Npc then
            self.m_anim:getAnimNode():setVisible(false)
        end
        self.m_tUINode:setLuaObjectIndex(self)
    end



    if self.m_nFigureType == FigureType.Statue then
        local name = "ui/city/beta/main_icon_phsgj.png"
        local pos = BattleCommon:getPointTable(20,197)
        local img = CCSprite:create(name)
        img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        img = img
        img:setPositionX(pos.x)
        img:setPositionY(pos.y)
        img:setScale(0.82)
        self.m_tUINode:addChild(img,1)

        -- local name = "ui/city/newMainScene/mainscene_1/mainscene_1_8.png"
        -- local pos = BattleCommon:getPointTable(30,-33)
        -- local img = CCSprite:create(name)
        -- img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        -- img = img
        -- img:setPositionX(pos.x)
        -- img:setPositionY(pos.y)
        -- self.m_tUINode:addChild(img,1)

        local img = CCSprite:create("ui/city/newUI/player_shadow.png")
        img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_tShadow = img
        self.m_tShadow:setPosition(GlobalMethod:ccp(30,0))

        local img = CCSprite:create("ui/city/newUI/mount_shadow.png")
        img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_tMountShadow = img

        local pos = BattleCommon:getPointTable(60,0)
        self.m_tMountShadow:setPositionX(pos.x)
        self.m_tMountShadow:setPositionY(pos.y)

        self.m_tUINode:addChild(self.m_tShadow,0)
        self.m_tUINode:addChild(self.m_tMountShadow,0)
    elseif self.m_nFigureType == FigureType.Score then
        --积分雕像底座
        -- local imgDown = CCSprite:create("ui/city/newUI/city_score_down.png")
        -- imgDown:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        -- imgDown:setPosition(GlobalMethod:ccp(30,0))
        -- imgDown:setScale(0.55)

        local img = CCSprite:create("ui/city/newUI/player_shadow.png")
        img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_tShadow = img
        self.m_tShadow:setPosition(GlobalMethod:ccp(30,0))

        local img = CCSprite:create("ui/city/newUI/mount_shadow.png")
        img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_tMountShadow = img

        local pos = BattleCommon:getPointTable(60,0)
        self.m_tMountShadow:setPositionX(pos.x)
        self.m_tMountShadow:setPositionY(pos.y)

    --    self.m_tUINode:addChild(imgDown,0)
        self.m_tUINode:addChild(self.m_tShadow,0)
        self.m_tUINode:addChild(self.m_tMountShadow,0)
        
    elseif self.m_nFigureType ~= FigureType.Npc then
        local img = CCSprite:create("ui/city/newUI/player_shadow.png")
        img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_tShadow = img
        self.m_tShadow:setPosition(GlobalMethod:ccp(30,0))

        local img = CCSprite:create("ui/city/newUI/mount_shadow.png")
        img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_tMountShadow = img

        local pos = BattleCommon:getPointTable(60,0)
        self.m_tMountShadow:setPositionX(pos.x)
        self.m_tMountShadow:setPositionY(pos.y)

        if true then
            self.m_tUINode:addChild(self.m_tShadow,0)
            self.m_tUINode:addChild(self.m_tMountShadow,0)
        else
            self.m_tNode:addChild(self.m_tShadow,0)
            self.m_tNode:addChild(self.m_tMountShadow,0)
        end
    else
        local img1 = CCSprite:create("ui/city/newUI/player_shadow.png")
        img1:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_tShadow = img1

        local name
        local pos,pos2
        if self.m_nAnimId == 1 then
            name = "ui/city/beta/main_icon_ddxlg.png"
            pos = BattleCommon:getPointTable(28,180)
            pos2 = GlobalMethod:ccp(30,-3)
        elseif self.m_nAnimId == 2 then
            name = "ui/city/beta/main_icon_stgly.png"
            pos = BattleCommon:getPointTable(25,197)
            pos2 = GlobalMethod:ccp(20,0)
        elseif self.m_nAnimId == 3 then
            name = "ui/city/beta/main_icon_stgly.png"
            pos = BattleCommon:getPointTable(25,197)
            pos2 = GlobalMethod:ccp(60,0)

            --self.m_tUINode:setContentSize(GlobalMethod:CCSize(63 ,135))
        end
        local img = CCSprite:create(name)
        img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        img = img
        img:setPositionX(pos.x)
        img:setPositionY(pos.y)
        img:setScale(0.82)
        if self.m_nAnimId ~= 3 then
            self.m_tUINode:addChild(img,1)
        end

        
        self.m_tShadow:setPosition(pos2)
        self.m_tUINode:addChild(self.m_tShadow,0)

        local img2 = CCSprite:create("ui/city/newUI/mount_shadow.png")
        img2:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        self.m_tMountShadow = img2

        local pos = BattleCommon:getPointTable(60,0)
        self.m_tMountShadow:setPositionX(pos.x)
        self.m_tMountShadow:setPositionY(pos.y)
        self.m_tUINode:addChild(self.m_tMountShadow,0)

    end

end

--@brief    点击排位雕像
function Figure:onStatueClick()
    WZLog("Figure:onStatueClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndPvpRankKing:showWindow(99)
end

--@brief    点击积分雕像
function Figure:onScoreClick()
    -- body
    WZLog("Figure:onScoreClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndPvpRankKing:showWindow(98)
end

--@brief    点击其他玩家
function Figure:onOtherClick()
    --WZLog("Figure:onOtherClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    FigureSceneManager:getInstance().m_bIsClickOther = true
    local collisionOtherId = self.m_nFigureId
    WndOwnCity:showOtherHead(collisionOtherId)
end

--@brief    点击Npc
function Figure:onNpcClick()
    --WZLog("Figure:onNpcClick")
	local openLv = GDatatab_button_info["id_30"].open_level
	local msg = GDatatab_button_info["id_30"].feedback_info

    if WindowManager:isHaveTeachTouchLayer() == true or WndTeachTalk.m_root ~= nil then
        return
    end
    

    SoundManager:stopEffectSound(self.sound or 0)
    self.sound = 0
    if self.m_nAnimId == 2 then
        self.sound = SoundManager:playEffectSound(getSoundByType(2))
        CreateJumpStoryTalkGroup(6)
    elseif self.m_nAnimId == 1 then
        self.sound = SoundManager:playEffectSound(getSoundByType(1))
        CreateJumpStoryTalkGroup(10)
    else
        self.sound = SoundManager:playEffectSound(SoundDefine.E_S_BUILDING_BTN)
        WndStore:showStoreByType(1)
    end

    WZLog("Figure:onNpcClick two", self.sound)
end

--@brief    设置当前场景
function Figure:setScene(scene)
    self.m_tScene = scene
end

--@brief    转换装备格式
function Figure:hastEquip(tCell,index)
    if tCell[index] == nil or tCell[index].basicInfo == nil or tCell[index].basicInfo.animationIndexCode == nil then
        return
    end
    return tCell[index].basicInfo.animationIndexCode
end

--@brief	上下马
function Figure:mount()

    local isMount = self.m_bIsMount
    WZLog("Figure:update play four", tostring(isMount))
    self:play(self:getStandbyAnimName(), true)
    if self.m_bIsMount == true and self.m_bIsMonster ~= true then
        self.m_tUINode:setContentSize(GlobalMethod:CCSize(150 ,160))
        if self.m_bIsMountPre == true then
            self.m_anim:setPosition(Vector2:create(60, -10))
        else
            self.m_anim:setPosition(Vector2:create(60, -10))
        end
        self.m_tPetPos = BattleCommon:getPointTable(-60,300)
        --WZLog("Figure:mount two", tostring(isMount))
        if self.m_tPetAnim ~= nil then
            self.m_tPetAnim:setPosition(Vector2:create(self.m_tPetPos.x, self.m_tPetPos.y))
        end
    else
        if self.m_nFigureType ~= FigureType.Npc then
            self.m_tUINode:setContentSize(GlobalMethod:CCSize(63 ,135))
            local x, y = 25,-12
            if self.m_bIsMountPre == true then
                self.m_anim:setPosition(Vector2:create(x, y))
            else
                self.m_anim:setPosition(Vector2:create(x, y))
            end
        end
        self.m_tPetPos = BattleCommon:getPointTable(-60,240)
        --WZLog("Figure:mount four", tostring(isMount))
        if self.m_tPetAnim ~= nil then
            self.m_tPetAnim:setPosition(Vector2:create(self.m_tPetPos.x, self.m_tPetPos.y))
        end
    end
end

--@brief	创建名称
function Figure:createName()

    local name = self.m_sName
    if self.m_tPlayerInfo ~= nil then
        name = self.m_tPlayerInfo.name
        self.m_sName = self.m_tPlayerInfo.name
        self.m_sTitle = self.m_tPlayerInfo.title
        --WZLog("Figure:createName one", self.m_tPlayerInfo.name, self.m_tPlayerInfo.title)
    end

    local titleY = 1.32
    if self.m_tNameLabel ~= nil then
        self.m_tNameLabel:setText(name)
        local title = "";
        if self.m_sTitle and self.m_sTitle ~= "" then
            local sTitleName = SplitStringWithSeparator(self.m_sTitle,"&")
            title = self.m_sTitle
        end
        --Modify By Tianxiang_Xu
        self.m_tNameLabel:setRelativePositionLuaTo(0.5, -0.5)
        WZLog("Figure:createName **********", titleY)
        CreateDesiSpine(self.m_tNameContainer, self.m_tLvLabel, title, GlobalMethod:ccp(0.5,titleY), false)
        return
    end

    --self.m_sTitle = ""
    ---[[
    local ttf = WZUILabelTTF:create()
    
    ttf:setText(name)
    ttf:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

    --Modify By Tianxiang_Xu
    ttf:setRelativePositionLuaTo(0.5, -0.5)

    ttf:setBoldFont(true)
    ttf:setEnableStroke(true)
    ttf:setStrokeColor(GlobalMethod:ccc3(62,34,8))
    ttf:setStrokeSize(4)
    ttf:setFontSize(18)

    if self.m_nFigureType == FigureType.Myself then
        ttf:setColor(GlobalMethod:ccc3(99,255,95))
    elseif self.m_nFigureType == FigureType.Other then
        ttf:setColor(GlobalMethod:ccc3(255,255,255))
    elseif self.m_nFigureType == FigureType.Npc then
        ttf:setColor(GlobalMethod:ccc3(255,227,116))
        ttf:setStrokeColor(GlobalMethod:ccc3(62,34,8))
        ttf:setFontSize(22)

        if self.m_nAnimId == 1 then
            ttf:setRelativePositionLuaTo(0.5, 0.1)
        end
    end


    local nameLength = ttf:getWordCount()
    local strLen = string.len(name)
    local width, height = 100, 36
    if strLen / nameLength == 1 then
        if nameLength <= 3 then
            width = 100
        elseif nameLength == 4 then
            width= 100
        elseif nameLength == 5 then
            width= 120
        elseif nameLength == 6 then
            width= 120
        elseif nameLength >= 7 then
            width= 140
        end
    else
        if nameLength <= 3 then
            width = 100
        elseif nameLength == 4 then
            width= 130
        elseif nameLength == 5 then
            width= 150
        elseif nameLength == 6 then
            width= 170
        elseif nameLength >= 7 then
            width= 190
        end
    end

    local title = "";
    if self.m_sTitle and self.m_sTitle ~= "" then
        -- local titleName = SplitStringWithSeparator(self.m_sTitle,"&")
        -- local titleLen = string.len(titleName[1])
        -- title = titleName[1]
        title = self.m_sTitle
    end

    local ttfLv = WZUILabelTTF:create()
    ttfLv:setFontSize(22)
--    ttfLv:setText(title)
    ttfLv:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    --Modify By Tianxiang_Xu
    ttfLv:setRelativePositionLuaTo(0.5, 0.27)
    ttfLv:setBoldFont(true)
    ttfLv:setEnableStroke(true)
    ttfLv:setStrokeColor(GlobalMethod:ccc3(62,34,8))
    ttfLv:setStrokeSize(4)
    ttfLv:setColor(GlobalMethod:ccc3(255,121,31))
    --]]

    --WZLog("Figure:createName two", name, self.m_sTitle)

    local imgContainer = WZUIContainer:create()
    imgContainer:setUseAbsSize(true)
    --imgContainer:setAbsContentSize(GlobalMethod:CCSize(width,height))
    imgContainer:setAbsContentSize(GlobalMethod:CCSize(100,40))

    self.m_tNameLabel = ttf
    self.m_tLvLabel = ttfLv

    imgContainer:addChild(ttf)
    imgContainer:addChild(ttfLv)

    if self.m_sTitle and self.m_sTitle ~= "" then
        CreateDesiSpine(imgContainer, ttfLv, self.m_sTitle, GlobalMethod:ccp(0.5,titleY), false)
    end

    WZLog("Figure:createName two", self.m_bIsMonster)
    if self.m_nFigureType == FigureType.Npc then
        if self.m_nAnimId == 1 then
            imgContainer:setRelativePositionLuaTo(0.5, 1.8)
        else
            imgContainer:setRelativePositionLuaTo(0.5, 1.85)
        end
    elseif self.m_bIsChangeToMonster then
        imgContainer:setRelativePositionLuaTo(self.m_nNameOffsetXChangeMonster, self.m_nNameOffsetYChangeMonster)
    elseif self.m_bIsMonster then
        imgContainer:setRelativePositionLuaTo(self.m_nNameOffsetXMonster, self.m_nNameOffsetYMonster)
    elseif self.m_nSex == 0 then
        imgContainer:setRelativePositionLuaTo(0.45, self.m_nNameOffsetYBoy)
    else
        imgContainer:setRelativePositionLuaTo(0.45, self.m_nNameOffsetYGirl)
    end
    imgContainer:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    if self.m_anim:getAnimNode():getChildByTag(100) ~= nil then
        self.m_anim:getAnimNode():removeChildByTag(100,true)
    end
    self.m_anim:getAnimNode():addChild(imgContainer, 100,-1)
    local scale = 1

    if self.m_nFigureType == FigureType.Npc then
        if self.m_nAnimId == 1 then
            scale = 1.4
        else
            scale = 1.4
        end
    elseif self.m_bIsArmature == true then
        scale = 1.7
    end

    imgContainer:setScale(scale)
    self.m_tNameContainer = imgContainer

    if self.m_nFigureType == FigureType.Other then
        imgContainer:setVisible(false)
    end

    self:changeMount()
end

--@brief	添加附加动画
function Figure:addEtcAnim(isLoop)
    self.m_tEtcAnim = BattleAnimation:createAnimation("ui_main_teleport",false,"city")

    self.m_tEtcAnim:getAnimNode():setUseAbsCoordinate(true)
    if self.m_bIsMount ~= true then
        bornAnimPos = GlobalMethod:ccp(35,330)
    else
        bornAnimPos = GlobalMethod:ccp(70,330)
    end
    self.m_tEtcAnim:getAnimNode():setAbsPosition(bornAnimPos)
    self.m_tEtcAnim:getAnimNode():setAnimationName("1")
    self.m_tEtcAnim:getAnimNode():setLoop(false)
    self.m_tUINode:addChild(self.m_tEtcAnim:getAnimNode())

end


--@brief	播放动画
function Figure:play(actionName, isLoop, boneName, bMove)
--    WZLog("Figure:play", actionName, self:getMoveAnimName(), self:getStandbyAnimName())
    self:getAnimation():play(actionName, isLoop, boneName)

    --小孩动作
    if self.m_tKidAni and #self.m_tKidAni > 0 then
        for i = 1, #self.m_tKidAni do
            if bMove or self.m_bIsMove then
                self.m_tKidAni[i]:play("walk", true)
            else
                self.m_tKidAni[i]:play("wait", true)
            end
        end
    end
end

--@brief    播放小孩走路动作
function Figure:playKidAni(actionName)
    -- body
    if self.m_tKidAni and #self.m_tKidAni > 0 then
        for i = 1, #self.m_tKidAni do
            self.m_tKidAni[i]:play(actionName, true)
        end
    end
end

--@brief	更换坐骑
function Figure:changeMount(isMount)
    --WZLog("Figure:changeMount one", tostring(self.m_tPlayerInfo), tostring(self.m_tPlayerInfo and self.m_tPlayerInfo.mountsId), tostring(isMount))

    if self.m_tPlayerInfo and self.m_tPlayerInfo.mountsId ~= nil and self.m_tPlayerInfo.mountsId ~= 0 and isMount ~= false then

        WZLog("Figure:changeMount two", self.m_tPlayerInfo.mountsId)
        if self.m_tPlayerInfo.mountsId == 16 then
            self.m_bMountEffect = true
            self.m_tMountEffectList = {}
        else
            self.m_bMountEffect = false
            if self.m_tMountEffectList then
                for k,v in ipairs(self.m_tMountEffectList) do
                    v:getAnimNode():removeFromParentAndCleanup(true)
                    v = nil
                end
            end
            self.m_tMountEffectList = nil
        end

        self.m_bIsMount = true
        self.m_anim:setMount(self.m_tPlayerInfo.mountsId)
        if self.m_tNameContainer ~= nil then

            if self.m_nFigureType == FigureType.Npc then
                if self.m_nAnimId == 1 then
                    self.m_tNameContainer:setRelativePositionLuaTo(0.5, 1.15)
                else
                    self.m_tNameContainer:setRelativePositionLuaTo(0.5, 1.3)
                end
            elseif self.m_bIsChangeToMonster then
                self.m_tNameContainer:setRelativePositionLuaTo(self.m_nNameOffsetXChangeMonster, self.m_nNameOffsetYChangeMonster)
            elseif self.m_bIsMonster then
                self.m_tNameContainer:setRelativePositionLuaTo(self.m_nNameOffsetXMonster, self.m_nNameOffsetYMonster)
            elseif self.m_nSex == 0 then
                self.m_tNameContainer:setRelativePositionLuaTo(0.55, self.m_nNameOffsetYBoy + 0.5)
            else
                self.m_tNameContainer:setRelativePositionLuaTo(0.45, self.m_nNameOffsetYGirl + 0.4)
            end
        end
        if self.m_tShadow ~= nil then
            self.m_tShadow:setVisible(false)
            self.m_tMountShadow:setVisible(true)
        end
        self:mount()
        self.m_bIsMountPre = true
    else
        self.m_bIsMount = false
        if self.m_tNameContainer ~= nil then
            if self.m_nFigureType == FigureType.Npc then
                if self.m_nAnimId == 1 then
                    self.m_tNameContainer:setRelativePositionLuaTo(0.5, 1.12)
                else
                    self.m_tNameContainer:setRelativePositionLuaTo(0.5, 1.27)
                end
            elseif self.m_bIsChangeToMonster then
                self.m_tNameContainer:setRelativePositionLuaTo(self.m_nNameOffsetXChangeMonster, self.m_nNameOffsetYChangeMonster)
            elseif self.m_bIsMonster then
                self.m_tNameContainer:setRelativePositionLuaTo(self.m_nNameOffsetXMonster, self.m_nNameOffsetYMonster)
            elseif self.m_nSex == 0 then
                self.m_tNameContainer:setRelativePositionLuaTo(0.45, self.m_nNameOffsetYBoy)
            else
                self.m_tNameContainer:setRelativePositionLuaTo(0.45, self.m_nNameOffsetYGirl)
            end
        end
        if self.m_tShadow ~= nil then
            self.m_tShadow:setVisible(true)
            self.m_tMountShadow:setVisible(false)
        end
        self:mount()
        self.m_bIsMountPre = false
    end

end

--@brief	获取待机动画名称
function Figure:getStandbyAnimName()
    local name
    if self.m_bIsArmature == nil then
        if self.m_bIsMount ~= true then
            name = "stand"
        else
            name = "mounts_stand"
        end
    else
        if self.m_nFigureType ~= FigureType.Npc then
            if self.m_bIsMount ~= true or self.m_bIsMonster then
                name = "wait0"
            elseif self.m_tPlayerInfo and self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 3 then
                name = "walk3"
            else
                name = "wait"
            end
        else

            name = "wait"

        end
    end
    ----WZLog("Figure:getStandbyAnimName", self.m_sName, name, tostring(self.m_bIsMount), tostring(isMount))
    return name
end

--@brief	获取移动动画名称
function Figure:getMoveAnimName()
    local name
    if self.m_bIsArmature == nil then
        if self.m_bIsMount ~= true then
            name = "move"
        else
            name = "mounts_move"
        end
    else
        if self.m_nFigureType ~= FigureType.Npc then
            if self.m_bIsMount ~= true or self.m_bIsMonster then
                name = "run"
            else
                if self.m_tPlayerInfo and self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 1 then
                    --WZLog("Figure:getMoveAnimName 1", self.m_sName, name)
                    name = "wait"
                elseif self.m_tPlayerInfo and self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 2 then
                    --WZLog("Figure:getMoveAnimName 2", self.m_sName, name)
                    name = "walk2"
                elseif self.m_tPlayerInfo and self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 3 then
                    --WZLog("Figure:getMoveAnimName 2", self.m_sName, name)
                    name = "walk3"
                elseif self.m_tPlayerInfo and self.m_tPlayerInfo.mountsType and self.m_tPlayerInfo.mountsType == 4 then
                    --WZLog("Figure:getMoveAnimName 2", self.m_sName, name)
                    name = "walk4"
                else
                    name = "walk"
                end
            end
        else
            name = "wait"
        end
    end
    --WZLog("Figure:getMoveAnimName", self.m_sName, name, tostring(self.m_bIsMount), self.m_tPlayerInfo and self.m_tPlayerInfo.mountsType)
    return name

end

--@brief	获取移动动画名称
function Figure:getRelaxAnimName()
    local name
    if self.m_nFigureType ~= FigureType.Npc then
        if self.m_bIsMount ~= true or self.m_bIsMonster then
            name = "wait0"
        else
            name = "wait"
        end
    else
        name = "1"
    end
    ----WZLog("Figure:getRelaxAnimName", self.m_sName, name)
    return name
end

--@brief	检查碰撞
function Figure:checkCollision(point)
    local posCur = BattleCommon:getPointTable(self:getPositionX(), self:getPositionX() + 0)
    local distanceX = math.abs(point.x - posCur.x)
    local distanceY = point.y - posCur.y

    local isCollision = false

    if self.m_nFigureType == FigureType.Other and self.m_bIsMount == true then
        if distanceX <= 60 and (distanceY >= 0 and distanceY <= 200) then
            isCollision = true
        end
    elseif self.m_nFigureType == FigureType.Other and self.m_bIsMount == false then
        if distanceX <= 60 and (distanceY >= 0 and distanceY <= 175) then
            isCollision = true
        end
    elseif self.m_nFigureType == FigureType.Npc then
        if distanceX <= 60 and (distanceY >= 0 and distanceY <= 120) then
            isCollision = true
        end
    end

    ----WZLog("Figure:checkCollision", self.m_sName, distanceX, distanceY, tostring(isCollision), posCur.x, posCur.y, point.x, point.y)
    return isCollision
end

--@brief	显示宠物
function Figure:showPet()
    if self.m_anim:getAnimNode():getChildByTag(99) ~= nil then
        self.m_anim:getAnimNode():removeChildByTag(99,true)
    end
    WZLog("Figure:showPet", Serialize(self.m_tPlayerInfo.petInfo))
    local petAnim = self.m_tPlayerInfo.petInfo.animation
    --
    if self.m_tPlayerInfo.petInfo.petSkinItemId and self.m_tPlayerInfo.petInfo.petSkinItemId > 0 then
        local tempAnimation = GetPetAnimation(self.m_tPlayerInfo.petInfo.petSkinItemId, self.m_tPlayerInfo.petInfo.advancedLevel)
        petAnim = tempAnimation
    end
    self.m_tPetAnim = self:createPlayerPet(petAnim, self.m_tPlayerInfo.petInfo.advancedLevel)
    if self.m_tPetAnim ~= nil then
        --self.m_tPetAnim:getAnimNode():retain()
        self.m_tPetAnim:setPosition(Vector2:create(self.m_tPetPos.x, self.m_tPetPos.y))
    end
end

function Figure:getPetWaitAnimName()
    if self.m_bIsNewPetAnim then
        return "wait"
    else
        return "0"
    end
end

--@brief    创建宠物
function Figure:createPlayerPet(nPetId, advanceLevel)
    local str = string.find(nPetId, "_")
    local boolNewPet = (str ~= nil)
    self.m_bIsNewPetAnim = boolNewPet
    local petAnim = BattleAnimation:createAnimation(nPetId, not boolNewPet)
    local petSprite = petAnim:getAnimNode()

    self.m_anim:getAnimNode():addChild(petSprite, 1, 99)
    petAnim:play(self:getPetWaitAnimName(),true)
    petAnim:getAnimNode():setScale(GlobalGame.g_nPetScaleInCity/0.6)

    local size = petSprite:getContentSize()
    WZLog("Figure:createPlayerPet", nPetId, advanceLevel, size.width/2, size.height/2)
    local backFire = nil
    if advanceLevel and tonumber(advanceLevel) >= 6 then
        backFire = CCParticleSystemQuad:create("particle/pet_max_lizi.plist")
        backFire:setPositionType(kCCPositionTypeRelative)
        backFire:setAutoRemoveOnFinish(true)
        backFire:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
        backFire:setPosition(size.width/2 ,size.height/2)
        petAnim:getAnimNode():addChild(backFire)
    end

    return petAnim
end

--@brief	宠物数据
function Figure:setPet()
    --WZLog("Figure:setPet one", tostring(self.m_tPlayerInfo))
    if self.m_tPlayerInfo.petInfo == nil then
        if self.m_tPetAnim ~= nil then
            if self.m_tPetAnim:getAnimNode():getParent() ~= nil then
                self.m_tPetAnim:getAnimNode():removeFromParentAndCleanup(true)
            end
            --self.m_tPetAnim:getAnimNode():release()
            self.m_tPetAnim = nil
        end
        return
    end
    self:showPet()
end

--@brief	翻转
function Figure:isFlipX()
    return self.m_bIsFlipX
end

--@brief	翻转
function Figure:setFlipX(isFlip)
    self.m_bIsFlipX = isFlip
    local bodyFlip = isFlip
    if self.m_bIsArmature ~= nil then
        bodyFlip = not bodyFlip
    end

    if self.m_tNameLabel == nil or (not isFlip) == self:getAnimation():isFlipX() then
        return
    end

    WZLog("Figure:setFlipX", tostring(isFlip), tostring(bodyFlip))
    if isFlip == true then
        if self.m_bIsMount == true then
            self.m_anim:setPosition(Vector2:create(60, -10))

            local pos = BattleCommon:getPointTable(80,0)
            self.m_tMountShadow:setPositionX(pos.x)
            self.m_tMountShadow:setPositionY(pos.y)
        end

        self:getAnimation():setFlipX(bodyFlip)
        self.m_tNameLabel:setScaleX(1)
        self.m_tLvLabel:setScaleX(1)

        if self.m_tShadow ~= nil then
            self.m_tShadow:setScaleX(1)
        end
    else
        if self.m_bIsMount == true then
            self.m_anim:setPosition(Vector2:create(60, -10))

            local pos = BattleCommon:getPointTable(80,0)
            self.m_tMountShadow:setPositionX(pos.x)
            self.m_tMountShadow:setPositionY(pos.y)
        end

        self:getAnimation():setFlipX(bodyFlip)
        self.m_tNameLabel:setScaleX(-1)
        self.m_tLvLabel:setScaleX(-1)
        if self.m_tShadow ~= nil then
            self.m_tShadow:setScaleX(-1)
        end
    end
end

--@brief	播放移动
function Figure:playMove(isMove)
    WZLog("Figure:playMove", isMove, self:getMoveAnimName(), self:getStandbyAnimName())
    if isMove == true then
        if self:getAnimation():isPlaying(self:getMoveAnimName()) == false or (self.m_tKidAni and self.m_tKidAni[1] and self.m_tKidAni[1]:isPlaying("walk") == false) then
            self:play(self:getMoveAnimName(), true, nil, true)
            WZLog("Figure:playMove 1")
        end
    else
        self:play(self:getStandbyAnimName(), true)
        WZLog("Figure:update play five")
    end
end

--@brief	播放移动
function Figure:getOffset()
    if self.m_nFigureType == FigureType.Myself then
        if self.m_bIsMount == true then
            return self.m_nMountOffset + self.m_nOffsetMe
        else
            return self.m_nOffset + self.m_nOffsetMe
        end
    end

    if self.m_bIsMount == true then
        return self.m_nMountOffset
    else
        return self.m_nOffset
    end
end

--@brief    移动
function Figure:moveLine(dire, randomPos, posy)
    --do return end
    if self.m_bIsDestroy == true then
        return
    end

    if dire == nil then
        dire = self.m_nDire
    end
       self.m_nRandomPosX = self.m_nRandomPosX or math.random(-150,150)

    if dire ~= -1 then
        --WZLog("Figure:moveLine zero-0", self:getPositionX(), tostring(randomPos), dire, FigureSceneManager:getInstance().m_tMoveEndPointX - FigureSceneManager:getInstance().m_tWinSize.width / 2, self:getPositionX(), tostring(self.m_nRandomPosX))
    end
    if randomPos ~= nil then
        --WZLog("Figure:moveLine zero-0", self.m_sName, dire, self:getPositionX(), tostring(randomPos))
        if self:getPositionX() <= randomPos + 20 and self:getPositionX() >= randomPos - 20 then
            --WZLog("Figure:moveLine zero-1", self.m_sName, self:getPositionX(), randomPos)
            self.m_nDire = -1
        elseif self.m_nDire == 1 and self:getPositionX() >= randomPos + 5 then
            --WZLog("Figure:moveLine zero-2")
            self.m_nDire = -1
        elseif self.m_nDire == 0 and self:getPositionX() <= randomPos - 5 then
            --WZLog("Figure:moveLine zero-3")
            self.m_nDire = -1
        end
    elseif dire ~= -1 and (math.abs(FigureSceneManager:getInstance().m_tMoveEndPointX - FigureSceneManager:getInstance().m_tWinSize.width / 2 - self:getPositionX()) <= self.m_nRandomPosX
        or (dire == 1 and self:getPositionX() - (FigureSceneManager:getInstance().m_tMoveEndPointX - FigureSceneManager:getInstance().m_tWinSize.width / 2) > 0 )
        or (dire == 0 and self:getPositionX() - (FigureSceneManager:getInstance().m_tMoveEndPointX - FigureSceneManager:getInstance().m_tWinSize.width / 2) < 0 )
        )
     then
        --WZLog("Figure:moveLine zero-2", self:getPositionX(),FigureSceneManager:getInstance().m_tMoveEndPointX - FigureSceneManager:getInstance().m_tWinSize.width / 2, dire)
        --self.m_nDire = -1

    end
    if self.m_nDire == -1 then
        self.m_nMountEffectTime = 0
        return
    end 

    local posCur = self:getPosition()
    local posTaget = {x=posCur.x, y=posCur.y}
    
    local speed = self.m_nSpeed * 1 
    if self.m_bIsMount == true then
        speed = self.m_nSpeedMount
    end

    speed = speed / (self.m_nIntervalTime / 0.0333)
    local distance = 0
    local movePos,x,y = nil

    local scene = FigureSceneManager:getInstance().m_tScene.m_tSceneLayer
    local element = scene:getMoveElement()
    local pos = element:getRelativePosition()
    if self.m_nFigureType == FigureType.Myself then
        --WZLog("Figure:moveLine", dire, tostring(randomPos), tostring(self.m_nRandomPos), self:getPositionX(), pos.x)
    end
    self:setFlipX(dire == 1)

    local offset = 0
    if posCur.x <= 300 + offset then
        dire = 1
        self.m_nDire = 1
        posTaget.x = 301 + offset
        distance = BattleCommon:pointDis({x=posCur.x,y=0}, {x=posTaget.x,y=0}) * speed
        x = (posTaget.x - posCur.x) / distance
        --y = 108 + self:getOffset()
        if posy then
            if posy - posCur.y >= 1 then
                y = posCur.y + 1
            elseif posy - posCur.y <= -1 then
                y = posCur.y - 1
            else
                y=posCur.y
            end
        else
            y =  108 + self:getOffset()
        end
    elseif posCur.x <= 2180 + offset and posCur.x > 300 then
        if dire == 1 then 
            posTaget.x = 2181 + offset
        else
            posTaget.x = 299
        end
        distance = BattleCommon:pointDis({x=posCur.x,y=0}, {x=posTaget.x,y=0}) * speed
        x = (posTaget.x - posCur.x) / distance
        --y = 108 + self:getOffset()
        if posy then
            if posy - posCur.y >= 1 then
                y = posCur.y + 1
            elseif posy - posCur.y <= -1 then
                y = posCur.y - 1
            else
                y=posCur.y
            end
        else
            y =  108 + self:getOffset()
        end
    else
        x = -2
        y = posCur.y
        self.m_nDire = 0
    end
    --WZLog("Figure:moveLine two", dire, posCur.x, x, posCur.y, posy, y)

    if math.abs(x) < 2 then
        x=0
        y=posCur.y
    end

    movePos = BattleCommon:getPointTable(x, y)
    self:setPosition(BattleCommon:getPointTable(posCur.x + movePos.x, movePos.y))

    if self:getAnimation():isPlaying(self:getMoveAnimName()) == false or (self.m_tKidAni and self.m_tKidAni[1] and self.m_tKidAni[1]:isPlaying("walk") == false) then
        self:play(self:getMoveAnimName(), true, nil, true)
    end

    if self.m_bMountEffect then
        --WZLog("Figure:moveLine", self.dt, self.m_nMountEffectTime)
        self.m_nMountEffectTime = self.m_nMountEffectTime + self.dt
        local timePlayMountEffect = 0.5
        if self.m_nMountEffectTime >= timePlayMountEffect then
            self.m_nMountEffectTime = 0

            animMountEffect = BattleAnimation:createAnimation("mount_001",false,"city")
            FigureSceneManager:getInstance().m_tFigureLayer:addChild(animMountEffect:getAnimNode(), 1000, 1000)
            animMountEffect:getAnimNode():setScale(3)
            animMountEffect:play("mount_001", false)
            local pos
            if dire == 1 then
                pos = {x=posCur.x + movePos.x + 80, y=movePos.y - 80}
            else
                pos = {x=posCur.x + movePos.x - 100, y=movePos.y - 80}
            end
            animMountEffect:setPosition(Vector2:create(pos.x, pos.y))
            table.insert(self.m_tMountEffectList, animMountEffect)
        end
    end
end

--@brief	在公会场景里移动的范围
function Figure:moveArea(dire, randomPos)
	
	--self.isRunning = false
	local speed = 3
	local random = math.random(0,1000)
	local dire
	if random < 500 then dire = -1 else dire = 1 end
    
	local rightDeviation = 210
	local posX = math.random(200+rightDeviation,800+rightDeviation)
	local posY = 50

    --WZLog("Figure:moveArea one", random, posX, dire, tostring(self.isRunning), tostring(self.m_bArrival), tostring(self.m_bStanding), tostring(self.m_bAction))

	if self.m_bArrival then
		--到达目的地后决定下一步行动
		if self.m_bStanding == false then
			--local action = math.random(0,1)
			if self.m_bAction == 0 then
				self.m_bAction = 1
				--站立初始化
				self.m_bStanding = true
				self.m_nTotalTime = math.random(60,150)
				self.m_nTotalTime = self.m_nTotalTime + tonumber(self.m_nFigureId)%60
				self.m_nStandTime = 0
			else
				self.m_bAction = 0
				--跑向下一个目的地,跑步初始化
				self.m_bArrival = false
				--获得下一个目标地点
				self.destination = self:getNextDestination(posX)
			end
		else
			--原地待命
    		if self:getAnimation():isPlaying(self:getStandbyAnimName()) == false or (self.m_tKidAni and self.m_tKidAni[1] and self.m_tKidAni[1]:isPlaying("wait") == false) then
    		    self:play(self:getStandbyAnimName(), true)
    		end
			self.m_nStandTime = self.m_nStandTime + 1
			if self.m_nStandTime > self.m_nTotalTime then
				self.m_bStanding = false
			end
		end
	else
		--每步移动
		local destination = {BattleCommon:getPointTable(301+rightDeviation,101),
			BattleCommon:getPointTable(501+rightDeviation,50),
			BattleCommon:getPointTable(701+rightDeviation,180),
			BattleCommon:getPointTable(901+rightDeviation,80)}
		if self.destination == nil then self.destination = destination[(math.random(1,50)+tonumber(self.m_nFigureId))%4+1] end
		dire = (self.destination.x - self:getPositionX())/math.abs(self.destination.x - self:getPositionX())
		if math.abs(self.destination.x - self:getPositionX()) <= (speed + 1) then
			self.m_bArrival = true
			dire = 1
		end
    	self:setFlipX(dire == 1)
		local direY
		if self.destination.y ~= self:getPositionY() then
			direY = (self.destination.y - self:getPositionY())/math.abs(self.destination.y - self:getPositionY())
		else
			direY = 0
		end
		if math.abs(self.destination.y - self:getPositionY()) <= 2.5 then
			direY = 0	
		end
		if direY == nil then direY = 1 end
		if self.isRunning then
			--移动
    		posX = self:getPositionX() + speed*dire
    		posY = self:getPositionY() + speed*direY
		else
			--初始化位置
			posX = 400
			posY = 100
			self.isRunning = true
		end
		if posY == nil then posY = self.destination.y end
    	self:setPosition(BattleCommon:getPointTable(posX, posY))
		if math.abs(self.destination.x - self:getPositionX()) < 3 then
			self.m_bArrival = true
		end

    	if self:getAnimation():isPlaying(self:getMoveAnimName()) == false or (self.m_tKidAni and self.m_tKidAni[1] and self.m_tKidAni[1]:isPlaying("walk") == false) then
    	    self:play(self:getMoveAnimName(), true, nil, true)
    	end
	end

	self.m_nDire = 0


	--WZLog("Figure:moveArea two 当前位置",self:getPositionX(),self:getPositionY())
	--WZLog("Figure:moveArea three 目标位置",self.destination.x,self.destination.y,self.m_bArrival)
end

--@brief	获得公会人物移动的下一个目的地
function Figure:getNextDestination(posX)
    local posCur = self:getPosition()
	local posY = math.random(75,200)
	return BattleCommon:getPointTable(posX,posY)
end

--@brief    是否移动
function Figure:isMove(point)
    local isMove = false
    local x = point.x
    local y = point.y

    if y <= 80 and x > 0 and x <= 2180 then
        isMove = true
    elseif x <= 100 then
        if y <= 120 or (y-120)/x <= 3/10 then
            isMove = true
        end
    elseif x <= 600 then
        if y <= 80 or (y-80)/(700-x-100) <= 7/50 then
            isMove = true
        end
    elseif x <= 700 then
        if y <= 80 or (y-80)/(x-600) <= 5/10 then
            isMove = true
        end
    elseif x <= 1260 then
        if y <= 85 or (y-85)/(1960-x-700) <= 45/560 then
            isMove = true
        end
    elseif x <= 1760 then
        if y <= 85 then
            isMove = true
        end
    elseif x <= 2180 then
        if y <= 85 or (y-85)/(x-1760) <= 10/410 then
            isMove = true
        end
    end


    return isMove
end

--@brief 	根据位置X获取人物当前的位置Y
--@param 	tPos 当前位置
function Figure:getPositionOffset(posX)
    local posCur = {x=posX}
    local posx, posy = posX, nil
    local offset = 0

    if false then
        if posCur.x <= 2180 + offset then
            posy = 108 + self:getOffset()
        end
        if posy == nil then
            posx, posy = self:getPositionX(), 85 + self:getOffset()
        end
        return posx, posy

    else
        local x = posX
        local y = 80 + self:getOffset()
        local y0 = 50 + self:getOffset()
        if x <= 100 then
            y = 30/100 * x + 120
            y = y == y0 and y or y > y0 and math.random(y0, y) or math.random(y, y0)
        elseif x <= 600 then
            y = 70/500 * ((700-x)-100) + 80
            y = y == y0 and y or y > y0 and math.random(y0, y) or math.random(y, y0)
        elseif x <= 700 then
            y = 50/100 * (x-600) + 80
            y = y == y0 and y or y > y0 and math.random(y0, y) or math.random(y, y0)
        elseif x <= 1260 then
            y = 50/560 * ((1960-x)-700) + 80
            y = y == y0 and y or y > y0 and math.random(y0, y) or math.random(y, y0)
        elseif x <= 1760 then
            y = y
            y = y == y0 and y or y > y0 and math.random(y0, y) or math.random(y, y0)
        elseif x <= 2180 then
            y = 20/420 * (x-1760) + 80
            y = y == y0 and y or y > y0 and math.random(y0, y) or math.random(y, y0)
        elseif x <= 2500 then
            y=100
        else
            y=y-50
        end

        y=y + 50

        WZLog("Figure:getPositionOffset", self.m_sName,x,y)
        return x, y
    end
end

--@brief	移动结束
function Figure:moveEnd()
    WZLog("Figure:update play six")
    self.m_bIsMove = nil
    self.m_tIsMoveToPos = nil
    self.m_tPosTarget = nil
    self:play(self:getStandbyAnimName(), true)
end

--@brief	随机行动
function Figure:randomActionOther(screenLeft, screenRight)
    --do return end
    if self.m_nActionPreTime == nil then
        self.m_nActionPreTime = self.m_nRunTime
    end
    ----WZLog("Figure:randomActionOther one", self.m_nRunTime, self.m_nActionPreTime,self.m_nRunTime - self.m_nActionPreTime, self.m_nActionIntervalTime)

    if (self.m_nRunTime - self.m_nActionPreTime >= self.m_nActionIntervalTime) or screenLeft ~= nil then
        self.m_nActionPreTime = self.m_nRunTime
        self.m_nActionIntervalTime = math.random(3,7)

        self.m_bIsRelax = nil
        local list = FigureSceneManager:getInstance().m_tFigureList

        local pos = self:getPositionX()
        local posy = self:getPositionY()
        --WZLog("Figure:randomActionOther s1-1", self.m_sName, pos)

        screenLeft, screenRight = FigureSceneManager:getInstance().m_nScreenLeft, FigureSceneManager:getInstance().m_nScreenRight
        local posLeft, posRight, posCenter = nil, nil, nil

        if pos < screenLeft or pos > screenRight then
            local screenFigureCount = 0
            if FigureSceneManager:getInstance().m_tFigureList ~= nil then
                for id, figure in pairs(FigureSceneManager:getInstance().m_tFigureList) do
                    if figure.m_nFigureType == FigureType.Other then

                        local pos = figure.m_nRandomPos or figure:getPositionX()

                        if pos >= FigureSceneManager:getInstance().m_nScreenLeft and pos <= FigureSceneManager:getInstance().m_nScreenRight then
                            screenFigureCount = screenFigureCount + 1
                        end
                        --WZLog("FigureSceneManager:updateControl three", figure.m_sName, GlobalGame.g_nMoveEndPointXNowMoveElement, screenLeft, screenRight, pos, screenFigureCount)
                    end
                end
            end

            if screenFigureCount >= 2 then
                return
            end
            local disa = math.abs(pos - screenLeft)
            local disb = math.abs(pos - screenRight)
            if disa <= disb then
                pos = screenLeft - math.random(50,150)
            else
                pos = screenRight + math.random(50,150)
            end
            pos, posy = self:getPositionOffset(pos)
            self:setPosition(BattleCommon:getPointTable(pos, posy))
            posLeft = screenLeft <= 300 and math.random(300,820) or nil
            posRight = screenRight >= 2180 and math.random(1800,2180) or nil
            if math.max(screenLeft,820) < math.min(screenRight,1560) then
                posCenter = (screenLeft > 300 or screenRight < 2180) and math.random(math.max(screenLeft,820),math.min(screenRight,1560)) or nil
            else
                posCenter = math.random(1160, 1440)
            end
            local rand = math.random(1,100) % 2
            if posLeft and posRight and posCenter then
                local dis1 = posLeft and math.abs(pos - posLeft) or 9999
                local dis2 = posRight and math.abs(pos - posRight) or 9999
                local dis3 = posCenter and math.abs(pos - posCenter) or 9999
                if dis1 <= dis2 and dis1 <= dis3 then
                    self.m_nRandomPos = posLeft
                elseif dis2 >= dis1 and dis2 >= dis3 then
                    self.m_nRandomPos = posRight
                else
                    self.m_nRandomPos = posCenter
                end
            else
                self.m_nRandomPos = posLeft or posRight or posCenter
            end
        else
            posLeft = (screenLeft <= 300 or screenRight < 2180) and math.random(math.max(screenRight,1800),2180) or nil
            posRight = (screenRight >= 2180 or screenLeft > 300) and math.random(300,math.min(screenRight,820)) or nil
            local rand = math.random(1,100) % 2
            if posLeft and posRight then
                local dis1 = math.abs(pos - posLeft)
                local dis2 = math.abs(pos - posRight)
                if dis1 <= dis2 then
                    self.m_nRandomPos = posLeft
                else
                    self.m_nRandomPos = posRight
                end
            else
                self.m_nRandomPos = posLeft or posRight
            end

        end
        --WZLog("Figure:randomActionOther s1-2", self.m_sName, self.m_nRandomPos, screenLeft, screenRight, tostring(posLeft), tostring(posRight), tostring(posCenter))
        if self.m_nRandomPos - self:getPositionX() < 100 and self.m_nRandomPos - self:getPositionX() >= 0  then
            self.m_nRandomPos = self:getPositionX() + 100
        elseif self.m_nRandomPos - self:getPositionX() > -100 and self.m_nRandomPos - self:getPositionX() < 0  then
            self.m_nRandomPos = self:getPositionX() - 100
        end

        if self.m_nRandomPos >= 2180 then
            self.m_nRandomPos = 2180 - math.random(40,100)
        elseif self.m_nRandomPos <= 300 then
            self.m_nRandomPos = 300 + math.random(40,100)
        end

        if self.m_nRandomPos <= 300 then
            self.m_nRandomPos = 400 + 60 * (math.random(0,10) > 5 and 1 or -1)
        elseif self.m_nRandomPos >= 500 and self.m_nRandomPos <= 600 then
            self.m_nRandomPos = 550 + 60 * (math.random(0,10) > 5 and 1 or -1)
        elseif self.m_nRandomPos >= 790 and self.m_nRandomPos <= 1180 then
            self.m_nRandomPos = 985 + 205 * (math.random(0,10) > 5 and 1 or -1)
        elseif self.m_nRandomPos >= 1420 and self.m_nRandomPos <= 1620 then
            self.m_nRandomPos = 1520 + 110 * (math.random(0,10) > 5 and 1 or -1)
        elseif self.m_nRandomPos >= 1800 and self.m_nRandomPos <= 2100 then
            self.m_nRandomPos = 1900 + 160 * (math.random(0,10) > 5 and 1 or -1)
        end

        if self.m_nRandomPos <= 1100 then
            self.m_nRandomPos = 340
        end

        if self.m_nRandomPos >= self:getPositionX() then
            self.m_nDire = 1
        else
            self.m_nDire = 0
        end
        _,self.m_nRandomPosY = self:getPositionOffset(self.m_nRandomPos)
                    
        --WZLog("Figure:randomActionOther two", self.m_sName, self.m_nDire, self.m_nRandomPos, self:getPositionX())
        self:moveLine(self.m_nDire, self.m_nRandomPos, self.m_nRandomPosY)
    elseif self.m_nDire ~= -1 then
        self:moveLine(self.m_nDire, self.m_nRandomPos, self.m_nRandomPosY)
        self.m_nActionPreTime = self.m_nRunTime
    elseif self.m_nDire == -1 and self.m_nRunTime - self.m_nActionPreTime >= self.m_nActionIntervalTime / 2 and (self.m_nRunTime - self.m_nActionPreTime) % 2 == 0 and self.m_nActionIntervalTime % 2 == 0 and self.m_bIsRelax == nil then
        --WZLog("Figure:randomActionOther three", self.m_nFigureId)
        self.m_bIsRelax = true
        self:play(self:getRelaxAnimName(), false)
    end
end

--@brief	随机行动
function Figure:randomActionNpc()
    ----WZLog("Figure:randomActionNpc")
    do return end
    if self:getAnimation():isPlaying(self:getMoveAnimName()) == false then
        if self.m_nRunTime - self.m_nActionPreTime >= self.m_nActionIntervalTime then
            self.m_nActionPreTime = self.m_nRunTime
            self.m_nActionIntervalTime = math.random(8,20)
            self:play(self:getMoveAnimName(), false)
            self:addEtcAnim(false)
        end
    end
end

--@brief	行动模式
function Figure:chooseActionMode()
    if self.m_bIsDestroy == true then
        return
    end

    if GlobalGame.g_nFigureSceneId == Chat_Channel_Island then
        if self.m_nFigureType == FigureType.Myself then
            if self.m_nRandomPos ~= nil and self.m_nDire ~= -1 then
                self:moveLine(self.m_nDire, self.m_nRandomPos, self.m_nRandomPosY)
            else
                --self:moveLine()
            end
        elseif self.m_nFigureType == FigureType.Other then
            self:randomActionOther()
        elseif self.m_nFigureType == FigureType.Npc then
            self:randomActionNpc()
        end
    elseif GlobalGame.g_nFigureSceneId == Chat_Channel_Guild_Scene then
        if self.m_nFigureType == FigureType.Myself then
            self:moveArea()
        elseif self.m_nFigureType == FigureType.Other then
            self:moveArea()
        end
        ---[[
        local posY = 5000 - math.floor(self:getPositionY())
        if math.abs(posY - self:getAnimation():getAnimNode():getZOrder()) > 1 then

            self.m_tUINode:setZOrder(posY)
            --WZLog("Figure:update one-1", self.m_sName, self:getPositionY(), posY, self.m_tUINode:getZOrder())
        end
        --]]

    end
end

function Figure:remove()
    local figureIndex = -1
    for index, figure in pairs (FigureSceneManager:getInstance().m_tFigureList) do
        if figure.m_tPlayerInfo ~= nil and self.m_tPlayerInfo.id == figure.m_tPlayerInfo.id then
            figureIndex = index
        end
    end
    table.remove(FigureSceneManager:getInstance().m_tFigureList, figureIndex)
end

--@brief	定时更新函数
--@param	dt:距离上一次调用的时间（秒）
--@note		由定时器调用
function Figure:update(dt, intervalTime)
    ----WZLog("Figure:update zero",self.m_sName , self.m_tUINode:getContentSize().width, self.m_tUINode:getContentSize().height)
    --do return end
    if self.m_bIsHaveAnim == nil then
        return
    end

    self.m_nIntervalTime = intervalTime
    if self.m_tBornAnim and self.m_tBornAnim:isPlaying("2") and self.m_tBornAnim:isCurrentAnimationDone() == true and self.m_tBornAnim:getAnimNode():isVisible() == true then
        --WZLog("Figure:update born one",self.m_sName)
        self.m_tBornAnim:getAnimNode():setVisible(false)
    end

    if self.m_tBornAnim and self.m_tBornAnim:isPlaying("1") and self.m_tBornAnim:isCurrentAnimationDone() == true then
        --WZLog("Figure:update born two",self.m_sName)
        self.m_anim:getAnimNode():setVisible(true)
        --self.m_tBornAnim:getAnimNode():setVisible(false)
        self.m_tBornAnim:play("2",false)
    end

    if self.m_bIsDestroy == true then

        if self.m_tEtcAnim and self.m_tEtcAnim:isPlaying("2") and self.m_tEtcAnim:isCurrentAnimationDone() == true then
            --WZLog("Figure:update destroy two",self.m_sName)
            self:remove()
            self:destroy()

            return
        end

        if self.m_tEtcAnim and self.m_tEtcAnim:isPlaying("1") and self.m_tEtcAnim:isCurrentAnimationDone() == true then
            --WZLog("Figure:update destroy one",self.m_sName)
            self.m_tEtcAnim:play("2",false)
            self.m_anim:getAnimNode():setVisible(false)
        end
    end

    if self.m_tEtcAnim and self.m_bIsDestroy ~= true and self.m_tEtcAnim:isPlaying("0") == true and self.m_tEtcAnim:isCurrentAnimationDone() == true then
        --WZLog("Figure:update destroy zero",self.m_sName)
        self.m_tEtcAnim:getAnimNode():removeFromParentAndCleanup(true)
        self.m_tEtcAnim = nil
    end

    if self.m_nDire == -1 then
        self.m_nRandomPosX = nil
        self.m_nRandomPos = nil
        if self.m_nFigureType ~= FigureType.Statue and self:getAnimation():isPlaying(self:getStandbyAnimName()) == false and self:getAnimation():isPlaying(self:getRelaxAnimName()) == false or (self.m_tKidAni and self.m_tKidAni[1] and self.m_tKidAni[1]:isPlaying("wait") == false) then
            WZLog("Figure:update play one",self.m_sName)
            self:play(self:getStandbyAnimName(), true)
        end
    end 

    if self.m_tPetAnim and self.m_tPetAnim:isCurrentAnimationDone() == true then
        local nPetId = self.m_tPlayerInfo.petInfo.animation
        self.m_tPetAnim:play(self:getPetWaitAnimName(),true)
    end

    if self.m_nFigureType == FigureType.Myself then
        GlobalGame.g_tMoveEndPointXNowPlayer[GlobalGame.g_nFigureSceneId] = {id=GlobalGame.g_nFigureSceneId, pos=self:getPosition(),flip=self:isFlipX()}
    end

    if true or self.m_nFigureType == FigureType.Myself or self.m_nDire == -1 then
        self.m_nRunTimePre = self.m_nRunTime
        self.m_nRunTime = dt
    end
    dt = self.m_nRunTime - self.m_nRunTimePre
    self.dt = intervalTime
    self:chooseActionMode()

    --完成其他动作后返回待机状态
    if true or self:getAnimation():isPlaying(self:getStandbyAnimName()) == false or (self.m_tKidAni and self.m_tKidAni[1] and self.m_tKidAni[1]:isPlaying("wait") == false) then
        if self:getAnimation():isCurrentAnimationDone() == true then
            self:play(self:getStandbyAnimName(), true)
            --WZLog("Figure:update play two", self.m_sName, self:getStandbyAnimName())
        end
    end

    local posY = 5000 - math.floor(self:getPositionY())
    if math.abs(posY - self:getAnimation():getAnimNode():getZOrder()) > 1 and self.m_nFigureType ~= FigureType.Statue and self.m_nFigureType ~= FigureType.Npc then
        self.m_tUINode:setZOrder(posY)
        self.m_tUINode:setScale(1 - (self:getPositionY()-(80+self:getOffset())) * 0.0015)
    end
    --足迹
    self:updateFootEffect()
    
end

--@brief 足迹刷新
function Figure:updateFootEffect()
    if  not FootEffectManager:getInstance().m_bIsCityLayer then
        return
    end
    if not CacheCenter.m_tPlayerInfo then return end
    --玩家自己的id
    if self.m_nFigureId == CacheCenter.m_tPlayerInfo.id then
        self.m_nFootId = CacheCenter:getUsingFootMarkId()
    end
    if self.m_nFootId and self.m_nFootId > 0 and self:isVisible() then
        local pos = self:getPosition()
        if not self.m_tOldFootPos then
            self.m_tOldFootPos = pos
        end
        local distance = GDatatab_footmark["id_" .. self.m_nFootId] and GDatatab_footmark["id_" .. self.m_nFootId].distance or 40
        if  BattleCommon:pointDis(self.m_tOldFootPos,pos) > distance then
            self.m_tOldFootPos = pos
            FootEffectManager:getInstance():addEffect(self.m_nFootId,pos,-25,self.m_anim:getAnimNode():getScaleX(),self.m_anim:getAnimNode():getScaleY())
        end
    end
end

--@brief	销毁动画
function Figure:destroyAnim()
    WZLog("Figure:update play three", self.m_sName)
    self.m_tEtcAnim = nil
    self.m_bIsDestroy = true
    self.m_nDire = -1
    self:play(self:getStandbyAnimName(), true)
    self:addEtcAnim(false)
end

--@brief	销毁
function Figure:destroy()
    --WZLog("Figure:destroy one")

    if self.m_tNameLabel ~= nil and self.m_tNameLabel.release ~= nil then
        --self.m_tNameLabel:release()
    end

    if self.m_tNameContainer ~= nil then
        self.m_tNameContainer:removeFromParentAndCleanup(true)
    end

    if self.m_tPetAnim ~= nil then
        if self.m_tPetAnim:getAnimNode():getParent() ~= nil then
            self.m_tPetAnim:getAnimNode():removeFromParentAndCleanup(true)
        end
        --self.m_tPetAnim:getAnimNode():release()
        self.m_tPetAnim = nil
    end

    --WZLog("Figure:destroy two")
    if self.m_tEtcAnim ~= nil then
        if self.m_tEtcAnim:getAnimNode():getParent() ~= nil then
            self.m_tEtcAnim:getAnimNode():removeFromParentAndCleanup(true)
        end
        --self.m_tEtcAnim:getAnimNode():release()
        self.m_tEtcAnim = nil
    end

    if self.m_anim ~= nil then
        if self.m_anim:getAnimNode():getParent() ~= nil then
            self.m_anim:getAnimNode():removeFromParentAndCleanup(true)
        end
    end

    if self.m_tUINode ~= nil then
        if self.m_tUINode:getParent() ~= nil then
            self.m_tUINode:removeFromParentAndCleanup(true)
        end
    end

    --WZLog("Figure:destroy four")
    self.m_tScene = nil
    self.m_tUINode = nil
end

--@brief 	设置人物当前的位置
--@param 	tPos 当前位置
function Figure:setPosition(tPos)
    --WZLog("Figure:setPosition", tPos.x, tPos.y)
    if self.m_tNode ~= nil then
        self.m_tNode:setPositionX(tPos.x)
        self.m_tNode:setPositionY(tPos.y)
    elseif self.m_tUINode ~= nil then
        self.m_tUINode:setPositionX(tPos.x)
        self.m_tUINode:setPositionY(tPos.y)
        --WZLog("Figure:setPosition", tPos.x, tPos.y)
    else
        self.m_anim:setPosition(Vector2:create(tPos.x,tPos.y))
    end
end

--@brief 	获取人物当前的位置
--@return 	tPos 当前位置
function Figure:getPosition()
    local tPos = {}
    if self.m_tNode ~= nil then
        tPos.x, tPos.y = self.m_tNode:getPositionX(), self.m_tNode:getPositionY()
    elseif self.m_tUINode ~= nil then
        tPos.x, tPos.y = self.m_tUINode:getPositionX(), self.m_tUINode:getPositionY()
    else
        tPos = self.m_anim:getPosition()
    end
    return tPos
end

--@brief 	获取人物当前的位置
--@return 	tPos 当前位置
function Figure:getPositionX()
    local tPos = {}
    if self.m_tNode ~= nil then
        tPos.x, tPos.y = self.m_tNode:getPositionX(), self.m_tNode:getPositionY()
    elseif self.m_tUINode ~= nil then
        tPos.x, tPos.y = self.m_tUINode:getPositionX(), self.m_tUINode:getPositionY()
    else
        tPos = self.m_anim:getPosition()
    end
    return tPos.x
end

--@brief 	获取人物当前的位置
--@return 	tPos 当前位置
function Figure:getPositionY()
    local tPos = {}
    if self.m_tNode ~= nil then
        tPos.x, tPos.y = self.m_tNode:getPositionX(), self.m_tNode:getPositionY()
    elseif self.m_tUINode ~= nil then
        tPos.x, tPos.y = self.m_tUINode:getPositionX(), self.m_tUINode:getPositionY()
    else
        tPos = self.m_anim:getPosition()
    end
    return tPos.y
end

--@brief	获取动画控制对象
--@return	#1:BattleAnimation动画控制对象
function Figure:getAnimation()
    return self.m_anim
end

--@brief	设置可见
function Figure:setVisible(isVisible)
    --WZLog("Figure:setVisible", tostring(isVisible))
    self.m_tUINode:setVisible(isVisible)
end

--@brief    设置可见
function Figure:isVisible()
    --WZLog("Figure:setVisible", tostring(isVisible))
    return self.m_tUINode:isVisible()
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function Figure:new()
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end

--@brief    小孩数据
function Figure:setKid()
    self:showKids()
end

--@brief    显示小孩
function Figure:showKids()
    if self.m_anim:getAnimNode():getChildByTag(111) ~= nil then
        self.m_anim:getAnimNode():removeChildByTag(111,true)
    end
    if self.m_anim:getAnimNode():getChildByTag(112) ~= nil then
        self.m_anim:getAnimNode():removeChildByTag(112,true)
    end

    self.m_tKidAni = {}
    if self.m_tPlayerInfo.showMes then
        local tBits = self:_NumberToBits(self.m_tPlayerInfo.showMes, 4) 
        if tBits[4] == 0 then
            return 
        end
    end 

    local kidMes = self.m_tPlayerInfo.childMes
--    WZLog("Figure:showKids", type(kidMes), kidMes)
    if kidMes == nil or kidMes == "" or kidMes == "[]" then return end 

    local tKidData = json.decode(self.m_tPlayerInfo.childMes)
    --
    for i = 1, #tKidData do
        local tEquip = {}

        table.insert(tEquip, tKidData[i].headId)
        table.insert(tEquip, tKidData[i].faceId)
        table.insert(tEquip, tKidData[i].bodyId)

        local conKid = CreatePlayerBabyFigure(tKidData[i].sex, tEquip, "wait")
        self.m_anim:getAnimNode():addChild(conKid:getAnimNode(), 1, 110 + i)
        self.m_tKidAni[i] = conKid
        if conKid ~= nil then
            conKid:setPosition(Vector2:create(-20 + (-80) * (i-1), 0))
        end
    end
    
end

function Figure:_NumberToBits(n, nCount)
    local tBits = {}

    while n >= 0 and #tBits < nCount do
        table.insert(tBits, math.mod(n, 2))
        n = math.floor(n/2)
    end

    return tBits
end
-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
