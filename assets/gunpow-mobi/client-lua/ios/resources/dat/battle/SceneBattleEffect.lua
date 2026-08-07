--SceneBattleEffect.lua
--@brief    场景特效
--@date     2015/10/19

--@brief    场景特效数据表
BattleEffectType = {
    PARTICLE = 1,
    ANIMATION = 2,
    ANIMATION_SPINE = 3,
}

BattleEffectLayerType = {
    FRONT = 1,
    BG = 2,
    MIN = 3,
}

SceneBattleEffect = {
    m_nNeedCommonEffect = 1,
    m_tTypeList = nil,
    m_tLayerList = nil,
    m_tPosList = nil,
    m_tAnimationNameList = nil,
    m_tActionNameList = nil,
    m_tScaleList = nil,
    m_tFlipList = nil,
    m_tRotateList = nil,
    
}

GDatatab_map_effect_test = 
{
    id_1 = { id = 1,mapId = 69,needCommonEffect = 1,type = 2,scale = 150,position = {{1720,335}},actionName = 0,layer = 1,animationName = "skills_lsk_01"},
    id_2 = { id = 2,mapId = 83,needCommonEffect = 0,type = {{2,1}},scale = {{100,100}},position = {{{1565,255},{700,400}}},actionName = {{0,0}},layer = {{1,1}},animationName = "monsterskill_zuduiboss3_cjfz , scene_battle_yinghuochong_01"},
}
-------------------------------------公有方法模块--------------------------------------
function SceneBattleEffect:initMapEffect()
    local mapId = tonumber(WBattleGlobal:getCurrent().m_tMakePairOk.battleMap:match("%d+")) --  69 --
    if GDatatab_map_effect == nil then
        GDatatab_map_effect = GDatatab_map_effect_test
    end

    self:initMapData(mapId)
    if self.m_nNeedCommonEffect == 1 then
        self:initCommonEffect()
    end
    for index = 1, #self.m_tTypeList do
        if self.m_tTypeList[index] == BattleEffectType.ANIMATION then
            self:initMapAnimationEffect(index)
        elseif self.m_tTypeList[index] == BattleEffectType.ANIMATION_SPINE then
            self:initMapAnimationEffectII(index)
        else
            self:initMapParticleEffect(index)
        end
    end

end

--@brief 初始化data
function SceneBattleEffect:initMapData(mapId)
    self.m_tNeedCommonEffectList = {}
    self.m_tTypeList = {}
    self.m_tLayerList = {}
    self.m_tPosList = {}
    self.m_tAnimationNameList = {}
    self.m_tActionNameList = {}
    self.m_tScaleList = {}
    self.m_tFlipList = {}
    self.m_tRotateList = {}
    for id, info in pairs (GDatatab_map_effect) do
        WZLog("SceneBattleEffect:initMapData one",id,mapId,info.mapId)
        if mapId == info.mapId then
            WZLog("SceneBattleEffect:initMapData two",id)
            if type(info.type) == "number" then
                WZLog("SceneBattleEffect:initMapData three-1",id)
                index = 1
                self.m_nNeedCommonEffect = info.needCommonEffect
                self.m_tTypeList[index] = info.type
                self.m_tLayerList[index] = info.layer
                self.m_tPosList[index] = {x=info.position[index][1],y=info.position[index][2]}
                self.m_tAnimationNameList[index] = info.animationName
                self.m_tActionNameList[index] = info.actionName
                self.m_tScaleList[index] = info.scale / 100
                self.m_tFlipList[index] = info.flip and info.flip == 1 or false
                self.m_tRotateList[index] = info.rotate
            elseif type(info.type) == "table" then
                for index = 1, #info.type[1] do
                    WZLog("SceneBattleEffect:initMapData three-2",id,index)
                    self.m_nNeedCommonEffect = info.needCommonEffect
                    self.m_tTypeList[index] = info.type[1][index]
                    self.m_tLayerList[index] = info.layer[1][index]
                    self.m_tPosList[index] = {x=info.position[1][index][1],y=info.position[1][index][2]}
                    local animationName = string.gsub(info.animationName, " ", "")
                    local animNameList = SplitStringWithSeparator(animationName, ",")
                    self.m_tAnimationNameList[index] = animNameList[index]
                    if type(info.actionName) == "table" then
                        self.m_tActionNameList[index] = info.actionName[1][index]
                    else
                        local animationName = string.gsub(info.actionName, " ", "")
                        local animNameList = SplitStringWithSeparator(animationName, ",")
                        self.m_tActionNameList[index] = animNameList[index]
                    end

                    if type(info.rotate) == "table" then
                        self.m_tRotateList[index] = info.rotate[1][index]
                    elseif type(info.rotate) == "string" then
                        local rotate = string.gsub(info.rotate, " ", "")
                        local rotateList = SplitStringWithSeparator(rotate, ",")
                        self.m_tRotateList[index] = tonumber(rotateList[index])
                    end

                    self.m_tScaleList[index] = info.scale[1][index] / 100
                    self.m_tFlipList[index] = info.flip and info.flip[1][index] and info.flip[1][index] == 1 or false
                end
            end
        end
    end 

    WZLog("SceneBattleEffect:initMapData end"
        , "\nm_nNeedCommonEffect", Serialize(self.m_nNeedCommonEffect)
        , "\nm_tTypeList", Serialize(self.m_tTypeList)
        , "\nm_tLayerList", Serialize(self.m_tLayerList)
        , "\nm_tPosList", Serialize(self.m_tPosList)
        , "\nm_tAnimationNameList", Serialize(self.m_tAnimationNameList)
        , "\nm_tActionNameList", Serialize(self.m_tActionNameList)
        , "\nm_tScaleList", Serialize(self.m_tScaleList)
        )
end

--@brief 动画特效
function SceneBattleEffect:initMapAnimationEffect(index)
    WZLog("SceneBattleEffect:initMapAnimationEffect",index)
    local anim = BattleAnimation:createAnimation(self.m_tAnimationNameList[index],true)
    anim:setScale(self.m_tScaleList[index])
    if self.m_tLayerList[index] == BattleEffectLayerType.FRONT then
        SceneBattle:getFrontLayer():addChild(anim:getAnimNode(),1)
    elseif self.m_tLayerList[index] == BattleEffectLayerType.BG then
        SceneBattle:getBgLayer():addChild(anim:getAnimNode(),1)
    else
        SceneBattle:getMidLayer():addChild(anim:getAnimNode(),1)
    end

    if self.m_tFlipList[index] then
        anim:setFlipX(true)
    end

    if self.m_tRotateList[index] and self.m_tRotateList[index] ~= 0 then
        anim:setRotate(self.m_tRotateList[index])
    end

    anim:getAnimNode():setPositionX(self.m_tPosList[index].x)
    anim:getAnimNode():setPositionY( self.m_tPosList[index].y)
    anim:play(self.m_tActionNameList[index],true)
end

--@brief 动画特效
function SceneBattleEffect:initMapAnimationEffectII(index)
    local anim = BattleAnimation:createAnimation(self.m_tAnimationNameList[index],false)
    anim:setScale(self.m_tScaleList[index])
    if self.m_tLayerList[index] == BattleEffectLayerType.FRONT then
        SceneBattle:getFrontLayer():addChild(anim:getAnimNode(),1)
    elseif self.m_tLayerList[index] == BattleEffectLayerType.BG then
        SceneBattle:getBgLayer():addChild(anim:getAnimNode(),1)
    else
        SceneBattle:getMidLayer():addChild(anim:getAnimNode(),1)
    end

    if self.m_tFlipList[index] then
        anim:setFlipX(true)
    end

    if self.m_tRotateList[index] and self.m_tRotateList[index] ~= 0 then
        anim:setRotate(self.m_tRotateList[index])
    end

    anim:getAnimNode():setPositionX(self.m_tPosList[index].x)
    anim:getAnimNode():setPositionY( self.m_tPosList[index].y)
    local name = self.m_tActionNameList[index] == 0 and "wait"or self.m_tActionNameList[index]
    anim:play(name,true)
    WZLog("SceneBattleEffect:initMapAnimationEffectII",index, self.m_tActionNameList[index], name)
    
end

--@brief 粒子特效
function SceneBattleEffect:initMapParticleEffect(index)
    WZLog("SceneBattleEffect:initMapParticleEffect",index)
    local backFire = CCParticleSystemQuad:create("battle/particle/".. self.m_tAnimationNameList[index] ..".plist")
    backFire:setDuration(kCCParticleDurationInfinity)
    backFire:retain()
    backFire:setPositionType(kCCPositionTypeRelative)
    backFire:setAutoRemoveOnFinish(true)
    backFire:setPosition(self.m_tPosList[index].x, self.m_tPosList[index].y)

    local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
    particle:addChild(backFire)
    if self.m_tLayerList[index] == BattleEffectLayerType.FRONT then
        SceneBattle:getFrontLayer():addChild(particle)
    elseif self.m_tLayerList[index] == BattleEffectLayerType.BG then
        SceneBattle:getBgLayer():addChild(particle)
    else
        SceneBattle:getMidLayer():addChild(particle) 
    end
    particle:setScale(self.m_tScaleList[index])
    backFire:release()

end

--@brief 通用特效
function SceneBattleEffect:initCommonEffect()
    WZLog("SceneBattleEffect:initCommonEffect")

    local backFire = CCParticleSystemQuad:create("battle/particle/scene_battle_yinghuochong_01.plist")
    backFire:setDuration(kCCParticleDurationInfinity)
    backFire:retain()
    backFire:setPositionType(kCCPositionTypeRelative)
    backFire:setAutoRemoveOnFinish(true)
    backFire:setPosition(700,400)

    local particle = CCParticleBatchNode:createWithTexture(backFire:getTexture())
    particle:addChild(backFire)
    SceneBattle:getFrontLayer():addChild(particle)
    backFire:release()
end
