--BattleKidName.lua
--@brief    人物信息
--@date     2014/01/20
--@author   TaoYinqing


BattleKidName = {
    m_tHero = nil,      --英雄信息
    m_tNameLayer = nil,
    m_hp = nil,
    m_point = nil,
    m_tLayer = nil,
    m_nOpecity = nil,
    m_curHp = nil,
    m_curPos = nil,
    m_hpBg = nil,
}


function BattleKidName:create(tHero, tLayer, bTeam, zOrder)
    local obj = {}
    setmetatable(obj,{__index = BattleKidName})

    obj.m_tHero = tHero
    obj.m_bIsOffSort = false
    obj.m_nOpecity = 255
    obj.m_curHp = 0
    obj.m_curPos = {x = 0, y = 0}
    obj.m_tNameLayer = CCLayer:create()
    obj.m_tNameLayer:setAnchorPoint(GlobalMethod:ccp(0,0))
    obj.m_tNameLayer:setScale(0.75)
    tLayer:addChild(obj.m_tNameLayer,zOrder or 1)

    local posHp       = BattleCommon:getPointTable(23,-27) --HP
    local posHpBottom = BattleCommon:getPointTable(23,-27) --HP底

    local color
    -- show name and hp
    WZLog("BattleKidName:create", tostring(tHero:getPlayerName()))

    if bTeam == true then
        obj.m_hpBg = CCSprite:create("ui/combat/progress_hzfz_01.png")
        obj.m_hpBg:setPosition(posHpBottom.x,posHpBottom.y)--.HP底
        obj.m_hpBg:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        obj.m_tNameLayer:addChild(obj.m_hpBg,0)
        obj.m_hp = CCProgressTimer:create(CCSprite:create("ui/combat/progress_hzfz_02.png"))
        obj.m_tNameLayer:addChild(obj.m_hp,0)

        if WBattleGlobal:getCurrent():getMyHero():getBattleId() == tHero:getOwner():getBattleId() then
            color = GlobalMethod:ccc3(99,255,95)
        else
            color = GlobalMethod:ccc3(255,255,255)
        end
    else
        obj.m_hpBg = CCSprite:create("ui/combat/progress_hzfz_01.png")
        obj.m_hpBg:setPosition(posHpBottom.x,posHpBottom.y)--.HP底
        obj.m_hpBg:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        obj.m_tNameLayer:addChild(obj.m_hpBg,0)
        
        obj.m_hp = CCProgressTimer:create(CCSprite:create("ui/combat/progress_hzfz_02.png"))
        obj.m_tNameLayer:addChild(obj.m_hp,0)

        color = GlobalMethod:ccc3(255,255,255)
    end

    local name = WZUILabelTTF:create()
    name:setColor(color)
    name:setFontSize(24)
    name:setText(tHero:getPlayerName())
    name:setBoldFont(true)
    name:setTouchEnable(false)
    name:setEnableStroke(true)
    name:setStrokeSize(4)
    name:setStrokeColor(GlobalMethod:ccc3(62, 34, 8))
    name:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    name:setAlignment(kCCTextAlignmentCenter)
    name:setRelativePositionLuaTo(0.022, 0.21)
    obj.m_tNameLayer:addChild(name,3)
    obj.m_nameLabel = name

    obj.m_hp:setMidpoint(GlobalMethod:ccp(0,0.5))
    obj.m_hp:setType(kCCProgressTimerTypeBar)
    obj.m_hp:setBarChangeRate(GlobalMethod:ccp(1, 0))
    local prec = tHero:getKidCurCDTime()/tHero:getKidMaxCDTime()*100
    obj.m_hp:setPercentage(prec)
    -- WZLog("BattleKidName:setPrec",tHero:getKidCurCDTime(),tHero:getKidMaxCDTime(),tHero:getKidCurCDTime()/tHero:getKidMaxCDTime()*100)
    obj.m_hp:setPosition(posHp.x,posHp.y)--.HP量
    obj.m_hp:setAnchorPoint(GlobalMethod:ccp(0.5,0))

    --蓄力中。。。
    if tHero:getIsKid() then 
        local imgPowerWord = WZUIImage:create()
        imgPowerWord:setFile("ui/combat/commom_text_xlz.png")
        imgPowerWord:setUseOriginSize(true)
        imgPowerWord:setRelativePositionLuaTo(0.022, 0.007)
        obj.m_tNameLayer:addChild(imgPowerWord)

        --小孩对应的技能图标
        local skill = WBattleGlobal:getCurrent():getKMSkillById(tHero.m_nSkillId)
        if skill then
            obj:addHeroUseCell({x = 0.022, y = 0.3}, BattleHeroUse.USE_SKILL_SUB, tHero.m_nSkillId, skill.icon, skill.lv, skill.skillType)
        end
    elseif tHero:getIsSoulHero() then --灵魂分身
        obj.m_hp:setVisible(false)
        obj.m_hpBg:setVisible(false)
    elseif tHero.getSubType and (tHero:getSubType() == 2 or tHero:getSubType() == 3) then --棋圣-棋子分身
        obj.m_hp:setVisible(false)
        obj.m_hpBg:setVisible(false)
    end

    if ProjConfig.DEBUG == 1 then
        local label = WZUILabelTTF:create()
        label:setColor(GlobalMethod:ccc3(255,0,0))
        label:setFontSize(26)
        label:setText("")
        label:setBoldFont(true)
        label:setTouchEnable(false)
        label:setEnableStroke(true)
        label:setStrokeSize(4)
        label:setStrokeColor(GlobalMethod:ccc3(62, 34, 8))
        label:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        label:setAlignment(kCCTextAlignmentCenter)
        label:setRelativePositionLuaTo(0.022,-0.055)

        obj.m_tNameLayer:addChild(label,3)
        obj.m_debugLabel = label

        if tHero:getIsSoulHero() then --灵魂分身
            obj.m_hp:setVisible(true)
            obj.m_hpBg:setVisible(true)
        elseif tHero.getSubType and (tHero:getSubType() == 2 or tHero:getSubType() == 3) then --棋圣-棋子分身
            obj.m_hp:setVisible(true)
            obj.m_hpBg:setVisible(true)
        end
    end

    obj.m_tLayer = tLayer
    obj.m_tLayer:retain()

    return obj
end

function BattleKidName:getNameNode()
    return self.m_tNameLayer
end

function BattleKidName:update(isPos)
    self:updateHp()
    if isPos ~= false then
        self:updatePosition()
    end
end

function BattleKidName:releaseTransform()
    if BattleKidName.g_nodeTransform ~= nil then
        BattleKidName.g_nodeTransform:release()
        BattleKidName.g_nodeTransform = nil
    end
    if BattleKidName.g_worldTransform ~= nil then
        BattleKidName.g_worldTransform:release()
        BattleKidName.g_worldTransform = nil
    end
end

function BattleKidName:updatePosition()
--    WZLog("BattleKidName:updatePosition")
    if self.m_tHero:getAnimation():getAnimNode():getParent() then
        local pos = self.m_tHero:getPosition()
        local offset = self.m_tHero:getNameLayerOffset()
        local point = CCAutoPoint:create(pos.x-20,pos.y-10)

        if self.m_tHero.m_tNamePosOffset ~= nil then
            point = CCAutoPoint:create(pos.x + self.m_tHero.m_tNamePosOffset.x,pos.y + self.m_tHero.m_tNamePosOffset.y)
        end

        if BattleKidName.g_worldTransform == nil then
            BattleKidName.g_worldTransform = self.m_tHero:getAnimation():getAnimNode():getParent():nodeToWorldTransformAuto()
            BattleKidName.g_worldTransform:retain()
        end
        if BattleKidName.g_nodeTransform == nil then
            BattleKidName.g_nodeTransform = self.m_tLayer:worldToNodeTransformAuto()
            BattleKidName.g_nodeTransform:retain()
        end
        point = CCPointApplyAffineTransformAuto(point,BattleKidName.g_worldTransform)
        point = CCPointApplyAffineTransformAuto(point,BattleKidName.g_nodeTransform)
        if BattleCommon:pointDis(self.m_curPos,point) > 1 then
            self.m_curPos.x,self.m_curPos.y = point.x + offset.x,point.y + offset.y
            self.m_tNameLayer:setPosition(point.x ,point.y)
        end
    end
end

function BattleKidName:updateHp()
    --WZLog("BattleKidName:updateHp", self.m_tHero:getBattleId(),self.m_tHero:getKidCurCDTime(),self.m_tHero:getKidMaxCDTime(),self.m_tHero:getKidCurCDTime()/self.m_tHero:getKidMaxCDTime()*100, self.m_hp:getPercentage())

    local hp = self.m_tHero:getKidCurCDTime()
    if self.m_tHero:getKidCurCDTime() <= 0 then
        hp = 0
    end

    if ProjConfig.DEBUG == 1 then
        local pos = self.m_tHero:getPosition()
        self.m_debugLabel:setText(hp)
    end

    local hpNow = hp/self.m_tHero:getKidMaxCDTime()*100
    hpNow = hpNow > 100 and 100 or hpNow
    hpNow = hpNow < 0 and 0 or hpNow
    
    local perNow = self.m_hp:getPercentage()
    local perTo = 0
    local speed = 6.167
    if perNow ~= hpNow then
        self.m_bIsHpActionDone = false
        if hpNow > perNow then
            perTo = (perNow + speed >= hpNow) and hpNow or perNow + speed
        else
            perTo = (perNow - speed <= hpNow) and hpNow or perNow - speed
        end

        if self.m_bisReborn then
            WZLog("BattleKidName:updateHp three")
            perTo = 100
            self.m_bisReborn = nil
        end
        self.m_hp:setPercentage(perTo)
        self.m_curHp = self.m_tHero:getKidCurCDTime()
        if math.abs(perNow - hpNow) <= 0.0001 then
            --WZLog("BattleKidName:updateHp three", self.m_tHero:getBattleId(), perNow, self.m_hp:getPercentage())
            self.m_bIsHpActionDone = nil
        else
            --WZLog("BattleKidName:updateHp one", self.m_tHero:getBattleId(),hp, self.m_tHero:getKidMaxCDTime(), self.m_hp:getPercentage(), hpNow)
        end
    else
        self.m_bIsHpActionDone = nil
        --WZLog("BattleKidName:updateHp two", self.m_tHero:getBattleId(), perNow, self.m_hp:getPercentage())
    end
end

function BattleKidName:destroy()
    WZLog("BattleKidName:destroy")
    self.m_tLayer:removeChild(self.m_tNameLayer,true)
    self.m_tLayer:release()
    
    self.m_point = nil
end

--@brief    隐藏名字
--@param    nOpecity 255 显示  小于255 隐藏
function BattleKidName:setOpecity(nOpecity)
    self.m_nOpecity = nOpecity
    if self.m_nOpecity <= 0 then
        self.m_tNameLayer:setVisible(false)
    else
        self.m_tNameLayer:setVisible(true)
    end
    if self.m_useContainer then 
        WndBattleHud:_setContainerOpacity(self.m_useContainer, nOpecity)
    end
end

--@brief    获得当前Opecity值
--@return   #1,当前Opecity值
function BattleKidName:getOpecity()
    return self.m_nOpecity
end

--@brief    隐藏血量
function BattleKidName:setHpVisible(bVisible)
    -- body
    self.m_hp:setVisible(bVisible)
    self.m_hpBg:setVisible(bVisible)
end

--@brief    增加一个英雄使用显示栏Cell
--@param    heroPos:英雄位置
--@brief    useType:使用类型
--@brief    useId:道具或技能ID，大招为大招类型
--@brief    usePng:对应的图片路径
--@note
function BattleKidName:addHeroUseCell(tPos,useType,useId,usePng,lv, skillType)
    if self.m_useContainer == nil then
        self.m_useContainer = WZUIContainer:create()

        self.m_tNameLayer:addChild(self.m_useContainer)
        self.m_useContainer:setContentSize(GlobalMethod:CCSize(BattleShowHeroUse.CELL_WIDTH,BattleShowHeroUse.CELL_HEIGHT))
        self.m_tInfo = {}
    else
        local size = self.m_useContainer:getContentSize()
        self.m_useContainer:setContentSize(GlobalMethod:CCSize(size.width + BattleShowHeroUse.CELL_WIDTH + BattleShowHeroUse.CELL_DIS , BattleShowHeroUse.CELL_HEIGHT))
    end

    table.insert(self.m_tInfo,{useType = useType , useId = useId , usePng = usePng })

    local pic = self:_createCell(usePng,lv, useType, skillType)
    self.m_useContainer:setRelativePositionLuaTo(tPos.x, tPos.y)
    self.m_useContainer:addChild(pic)

    local hero = self.m_tHero:getOwner()
    WZLog("BattleKidName:addHeroUseCell one", tostring(lv))
    if hero:isHide() == true then
        if WBattleGlobal:getCurrent():isReplayGame() or WBattleGlobal:getCurrent():isMyTeam(hero:getId()) then
            WndBattleHud:_setContainerOpacity(self.m_useContainer,128)
        else
            WndBattleHud:_setContainerOpacity(self.m_useContainer,0)
        end
    end
end

--@brief    创建一个显示栏Cell
--@param    usePng:Cell的图片路径
--@note     增加Cell时候使用
function BattleKidName:_createCell(usePng,lvIcon, useType, skillType)
    local cell = WZUIContainer:create()
    cell:setUseAbsSize(true)
    cell:setAbsContentSize(GlobalMethod:CCSize(BattleShowHeroUse.CELL_WIDTH,BattleShowHeroUse.CELL_HEIGHT))

    local bg = WZUIImage:create()
    if skillType == 6 then 
        bg:setFile("ui/common/common_zd_dk_ww.png")
    elseif skillType == 7 then 
        bg:setFile("ui/common/common_zd_dk_zq.png")
    end
    local img = WZUIImage:create()
    img:setFile(usePng)
    img:setScale(0.8)
    img:setUseOriginSize(true)
    img:setName("imgShowHeroUse"..(#self.m_tInfo).."_SceneBattle")
    if useType ~= BattleHeroUse.USE_CTB then        
        cell:addChild(bg)
    end
    cell:addChild(img)

    if lvIcon and lvIcon ~= "" then
        local x,y = 0.7,0.2

        local lv = WZUIImage:create()
        lv:setUseOriginSize(true)
        lv:setFile(lvIcon)
        lv:setRelativePositionLuaTo(x,y)
        cell:addChild(lv,10)
    end

    cell:setTag(#self.m_tInfo)
    return cell
end

