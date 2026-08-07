--BattleHeroName.lua
--@brief    人物信息
--@date     2014/01/20
--@author   TaoYinqing


BattleHeroName = {
    m_tHero = nil,      --英雄信息
    m_tNameLayer = nil,
    m_hp = nil,
    m_sp = nil,
    m_point = nil,
    m_tLayer = nil,
    m_nOpecity = nil,
    m_shine = nil,
    m_curHp = nil,
    m_curPos = nil,
    m_hpBg = nil,
}


function BattleHeroName:create(tHero,tLayer,bTeam, zOrder)
    if tHero:getLevel() == -1 then
        return nil
    end
    local obj = {}
    setmetatable(obj,{__index = BattleHeroName})

    obj.m_tHero = tHero
    --过滤排序
    if tHero:isOffSortName() then
        obj.m_bIsOffSort = true
    else
        obj.m_bIsOffSort = false
    end
    obj.m_nOpecity = 255
    obj.m_curHp = 0
    obj.m_curPos = {x = 0, y = 0}
    obj.m_tNameLayer = CCLayer:create()
    if (WBattleGlobal:getCurrent():isWorldBossStage()) and tHero:getType() ~= 0 then 
        obj.m_tNameLayer:setVisible(false)
    end
    obj.m_tNameLayer:setAnchorPoint(GlobalMethod:ccp(0,0))
    obj.m_tNameLayer:setScale(0.75)
    tLayer:addChild(obj.m_tNameLayer,zOrder or 1)

    -- show title
    local sTitle = tHero:getTitle()
    local icon = nil
    local stringStart = nil
    local stringEnd = nil
    if sTitle ~= nil and string.len(sTitle) > 0 then
        stringStart,stringEnd = string.find(sTitle,"%[")
        if stringStart ~= nil and stringStart >0 then
            icon = string.sub(sTitle,2,2)
            sTitle = string.sub(sTitle,4)
        end
    end

    if icon ~= nil and string.len(icon) > 0 then
        local iconPath = "image/ui/bottomMenu/player/property_"..icon..".png"
        local iconImg = CCSprite:create(iconPath)
        if iconImg ~= nil then
            iconImg:setPosition(-40,-40)
            obj.m_tNameLayer:addChild(iconImg)
        end
    end

    local posHp       = BattleCommon:getPointTable(15,-43) --HP
    local posHpBottom = BattleCommon:getPointTable(15,-45) --HP底

    -- show level
    local sLevel = tHero:getLevel()

    local color
    -- show name and hp
    WZLog("BattleHeroName:create",sLevel,tHero:getPlayerName(),sTitle)

    if bTeam == true then
        obj.m_hpBg = CCSprite:create("ui/combat/common_progress_zhandou_bg2.png")
        obj.m_hpBg:setPosition(posHpBottom.x,posHpBottom.y)--.HP底
        obj.m_hpBg:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        obj.m_tNameLayer:addChild(obj.m_hpBg,0)
        obj.m_hp = CCProgressTimer:create(CCSprite:create("ui/combat/common_progress_zhandou_fore2.png"))
        obj.m_tNameLayer:addChild(obj.m_hp,0)

        if WBattleGlobal:getCurrent():getMyHero():getBattleId() == tHero:getBattleId() then
            color = GlobalMethod:ccc3(99,255,95)
        else
            color = GlobalMethod:ccc3(255,255,255)
        end

    else
        obj.m_hpBg = CCSprite:create("ui/combat/common_progress_zhandou_bg2.png")
        obj.m_hpBg:setPosition(posHpBottom.x,posHpBottom.y)--.HP底
        obj.m_hpBg:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        obj.m_tNameLayer:addChild(obj.m_hpBg,0)
        
        obj.m_hp = CCProgressTimer:create(CCSprite:create("ui/combat/common_progress_zhandou_fore.png"))
        obj.m_tNameLayer:addChild(obj.m_hp,0)

        color = GlobalMethod:ccc3(255,255,255)


    end
    local  spBg = nil
    if tHero:getType() == 1 and tHero.m_sAniFileId == "boss_1011" then 
        spBg = CCSprite:create("ui/combat/common_progress_zhandou_bg2.png")
        spBg:setPosition(posHpBottom.x,posHpBottom.y - 20)--.HP底
        spBg:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        obj.m_tNameLayer:addChild(spBg,0)
        
        obj.m_sp = CCProgressTimer:create(CCSprite:create("ui/combat/common_progress_nuqi01.png"))
        obj.m_tNameLayer:addChild(obj.m_sp,0)

        obj.m_sp:setMidpoint(GlobalMethod:ccp(0,0.5))
        obj.m_sp:setType(kCCProgressTimerTypeBar)
        obj.m_sp:setBarChangeRate(GlobalMethod:ccp(1, 0))
        local prec = tHero:getSp()/tHero.m_nMaxSP*100
        obj.m_sp:setPercentage(prec)
        -- WZLog("BattleHeroName:setPrec",tHero:getHp(),tHero:getMaxHp(),tHero:getHp()/tHero:getMaxHp()*100)
        obj.m_sp:setPosition(posHp.x,posHp.y - 20)--.HP量
        obj.m_sp:setAnchorPoint(GlobalMethod:ccp(0.5,0))
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
    name:setRelativePositionLuaTo(0.01,-0.05)
    obj.m_tNameLayer:addChild(name,3)
    obj.m_nameLabel = name

    if WBattleGlobal:getCurrent():getMyHero().serverId ~= tHero.serverId and tHero:getType() == 0 then
        local mark = CCSprite:create("ui/chat/chat_common_icon_kuafu.png")
        mark:setPosition(-20,15)
        mark:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        name:addChild(mark,0)
    end

    if tHero.m_bIsCaptain == true then
        local resName = "shopitems/zd_duizhangdf.png"
        if WBattleGlobal:getCurrent():isMyTeam(tHero:getId()) then
            resName = "shopitems/zd_duizhangjf.png"
        end
        local mark = CCSprite:create(resName)
        mark:setPosition(-44,0)
        mark:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        obj.m_hp:addChild(mark,0)
    end


    obj.m_hp:setMidpoint(GlobalMethod:ccp(0,0.5))
    obj.m_hp:setType(kCCProgressTimerTypeBar)
    obj.m_hp:setBarChangeRate(GlobalMethod:ccp(1, 0))
    local prec = tHero:getHp()/tHero:getMaxHp()*100
    obj.m_hp:setPercentage(prec)
    -- WZLog("BattleHeroName:setPrec",tHero:getHp(),tHero:getMaxHp(),tHero:getHp()/tHero:getMaxHp()*100)
    obj.m_hp:setPosition(posHp.x,posHp.y)--.HP量
    obj.m_hp:setAnchorPoint(GlobalMethod:ccp(0.5,0))


    --称号
    if false and sTitle ~= nil and string.len(sTitle) > 0 then
        local name = WZUILabelTTF:create()
        name:setColor(GlobalMethod:ccc3(255,121,31))
        name:setFontSize(24)
        name:setText("<"..sTitle..">")
        name:setBoldFont(true)
        name:setTouchEnable(false)
        name:setEnableStroke(true)
        name:setStrokeSize(4)
        name:setStrokeColor(GlobalMethod:ccc3(62, 34, 8))
        name:setAnchorPoint(GlobalMethod:ccp(0.5,0))
        name:setAlignment(kCCTextAlignmentCenter)
        name:setRelativePositionLuaTo(0.01,-0.01)
        obj.m_tNameLayer:addChild(name,3)
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
        if obj.m_sp then
            label:setRelativePositionLuaTo(0.01,-0.20)
        else
            label:setRelativePositionLuaTo(0.01,-0.16)
        end
        obj.m_tNameLayer:addChild(label,3)
        obj.m_debugLabel = label
    end
    if WBattleGlobal:getCurrent():isFlyCopy() and bTeam ~= true then
        obj.m_hpBg:setVisible(false)
        obj.m_hp:setVisible(false)
        if obj.m_debugLabel then
            obj.m_debugLabel:setVisible(false)
        end
        obj.m_tNameLayer:setAnchorPoint(GlobalMethod:ccp(0.03,0.6))
    end

    --obj.m_point:retain()
    obj.m_tLayer = tLayer
    obj.m_tLayer:retain()

    return obj
end


function BattleHeroName:update(isPos)
    
    self:updateHp()
    if isPos ~= false then
        self:updatePosition()
    end
    --WZLog(point.x,point.y)
end

function BattleHeroName:releaseTransform()
    if BattleHeroName.g_nodeTransform ~= nil then
        BattleHeroName.g_nodeTransform:release()
        BattleHeroName.g_nodeTransform = nil
    end
    if BattleHeroName.g_worldTransform ~= nil then
        BattleHeroName.g_worldTransform:release()
        BattleHeroName.g_worldTransform = nil
    end
end

function BattleHeroName:getNameNode()
    return self.m_tNameLayer;
end

function BattleHeroName:updatePosition()
    if self.m_tHero:getAnimation():getAnimNode():getParent() then
        local pos = self.m_tHero:getPosition()
        local offset = self.m_tHero:getNameLayerOffset()
        local point = CCAutoPoint:create(pos.x-20,pos.y-10)

        if self.m_tHero.m_tNamePosOffset ~= nil then
            point = CCAutoPoint:create(pos.x + self.m_tHero.m_tNamePosOffset.x,pos.y + self.m_tHero.m_tNamePosOffset.y)
        end

        if BattleHeroName.g_worldTransform == nil then
            BattleHeroName.g_worldTransform = self.m_tHero:getAnimation():getAnimNode():getParent():nodeToWorldTransformAuto()
            BattleHeroName.g_worldTransform:retain()
        end
        if BattleHeroName.g_nodeTransform == nil then
            BattleHeroName.g_nodeTransform = self.m_tLayer:worldToNodeTransformAuto()
            BattleHeroName.g_nodeTransform:retain()
        end
        point = CCPointApplyAffineTransformAuto(point,BattleHeroName.g_worldTransform)
        point = CCPointApplyAffineTransformAuto(point,BattleHeroName.g_nodeTransform)
        if BattleCommon:pointDis(self.m_curPos,point) > 1 then
            self.m_curPos.x,self.m_curPos.y = point.x + offset.x,point.y + offset.y
            self.m_tNameLayer:setPosition(point.x ,point.y)
        end
    end
end

function BattleHeroName:updateHp()
    --WZLog("BattleHeroName:updateHp", self.m_tHero:getBattleId(),self.m_tHero:getHp(),self.m_tHero:getMaxHp(),self.m_tHero:getHp()/self.m_tHero:getMaxHp()*100, self.m_hp:getPercentage())

    local hp = self.m_tHero:getHp()
    if self.m_tHero:getHp() <= 0 then
        hp = 0
    end

    if ProjConfig.DEBUG == 1 then
        local pos = self.m_tHero:getPosition()
        self.m_debugLabel:setText(hp .. "\n("..math.floor(pos.x)..","..math.floor(pos.y)..")")
    end

    local hpNow = hp/self.m_tHero:getMaxHp()*100
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
            WZLog("BattleHeroName:updateHp three")
            perTo = 100
            self.m_bisReborn = nil
        end
        self.m_hp:setPercentage(perTo)
        self.m_curHp = self.m_tHero:getHp()
        if math.abs(perNow - hpNow) <= 0.0001 then
            --WZLog("BattleHeroName:updateHp three", self.m_tHero:getBattleId(), perNow, self.m_hp:getPercentage())
            self.m_bIsHpActionDone = nil
        else
            --WZLog("BattleHeroName:updateHp one", self.m_tHero:getBattleId(),hp, self.m_tHero:getMaxHp(), self.m_hp:getPercentage(), hpNow)
        end
    else
        self.m_bIsHpActionDone = nil
        --WZLog("BattleHeroName:updateHp two", self.m_tHero:getBattleId(), perNow, self.m_hp:getPercentage())
    end

    if self.m_sp then
        local prec = self.m_tHero:getSp()/self.m_tHero.m_nMaxSP*100
        self.m_sp:setPercentage(prec)
    end
end

function BattleHeroName:destroy()
    WZLog("BattleHeroName:destroy")
    self.m_tLayer:removeChild(self.m_tNameLayer,true)
    self.m_tLayer:release()
    
    self.m_point = nil
end

--@brief    隐藏名字
--@param    nOpecity 255 显示  小于255 隐藏
function BattleHeroName:setOpecity(nOpecity)
    self.m_nOpecity = nOpecity
    if self.m_nOpecity < 255 then
        self.m_tNameLayer:setVisible(false)
    else
        self.m_tNameLayer:setVisible(true)
    end
end

--@brief    获得当前Opecity值
--@return   #1,当前Opecity值
function BattleHeroName:getOpecity()
    return self.m_nOpecity
end

--@brief    隐藏血量
function BattleHeroName:setHpVisible(bVisible)
    -- body
    self.m_hp:setVisible(bVisible)
    self.m_hpBg:setVisible(bVisible)
end
