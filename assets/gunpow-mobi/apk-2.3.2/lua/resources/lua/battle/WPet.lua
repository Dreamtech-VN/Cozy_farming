--WPet.lua
--@brief    宠物数据信息
--@date     2014/01/21
--@author   TaoYinqing

--@brief    宠物状态
PetStatus = {
    DEF_ST_NORMAL = 0,          --黏人状态
    DEF_ST_ATTACK = 1,          --攻击状态
    DEF_ST_NONE = -1,           --空的状态,用于转换状态时
}

--@brief    攻击类型
PetAttackType = {
    Type_Melee = 0,     --近攻类型宠物
    Type_Plane = 1,     --飞机(投弹)类型宠物
    Type_Shoot = 2,     --远攻类型宠物
}

--@brief    宠物
WPet = {
    m_tHero = nil ,     --宠物对应英雄的信息
    m_tPetInfo = nil,  --宠物一些基本的信息
    m_tAnim = nil,   --宠物动画
    m_bAdded = false, -- 是否添加到场景中去了
    m_nCurrentStatus = nil, -- 宠物当前状态
    m_tTrackNode = nil,   -- 调节位置节点
    m_tPetDragonBone = {
        ["pet0001"] = {"pet0001_tail"},
        ["pet0002"] = {"pet0002_tail"},
        ["pet0003"] = {"pet0003_tail"},
        ["pet0004"] = {},
        ["pet0005"] = {},
        ["pet0006"] = {"pet0006_headwear"},
        ["pet0007"] = {"pet0007_chibang3"},
        ["pet0008"] = {"pet0008_chibang4","pet0008_texiao"},
        ["pet0009"] = {"pet0009_chibang1","pet0009_chibang2","pet0009_weiba1","pet0009_texiao1"},
        ["pet0010"] = {"pet0010_chibang1","pet0010_chibang2","pet0010_weiba1","pet0010_texiao"},
        ["pet0011"] = {},
        ["pet0012"] = {"pet0012_texiao","pet0012_huo"},
        ["pet0013"] = {"pet0013_chibang1","pet0013_chibang2","pet0013_weiba","pet0013_guang"},
        ["pet0014"] = {"pet0014_weiba","pet0014_chibang2","pet0014_chibang1","pet0014_texiao"},
        ["pet0015"] = {"pet0015_weiba"},
        ["pet0016"] = {"pet0016_weiba","pet0016_yun","pet0016_gongji"},
        ["pet0017"] = {"pet0017_texiao1","pet0017_texiao2","pet0017_weiba"},
        ["pet0018"] = {"pet0018_texiao","pet0018_texiao2","pet0018_weiba","pet0018_yifu1","pet0018_yifu2"},
        ["pet0019"] = {"pet0019_gongji"},
        ["pet0020"] = {"pet0020_texiao","pet0020_qun"},
        ["pet0021"] = {"pet0021_huo"},
        ["pet0022"] = {"pet0022_huo","pet0022_huoqiu_1","pet0022_huoqiu_2"},
        ["pet0023"] = {"pet0023_texiao","pet0023_weiba"},
        ["pet0024"] = {"pet0024_xu","pet0024_texiao","pet0024_wei","pet0024_chibang"},
        ["pet0025"] = {"pet0025_02","pet0025_03","pet0025_04"},
        ["pet0026"] = {"pet0026_01","pet0026_04"},
        ["pet0027"] = {"pet0027_04","pet0027_gongji","pet0027_zidan","pet0027_weiba"},
        ["pet0028"] = {"pet0028_tail1","pet0028_tail2","pet0028_tail3","pet0028_tail4","pet0028_01","pet0028_04"},
    }
}

--@brief    创建一个宠物
--@param    tHero 英雄信息
--@return   #1,返回一个宠物的信息
function  WPet:create(tHero,tPet)
    local obj = {}
    setmetatable(obj,{__index = WPet})
    --init
    --obj:_init(tHero,tPet)
    obj.m_tHero = tHero
    obj.m_tPetInfo = tPet
    return obj
end

--@brief    销毁一个角色
function WPet:destroy()
    WZLog("WPet:destroy")
    if self.m_tBackFire ~= nil then
        self.m_tBackFire:stopSystem()
        self.m_tBackFire:release()
        self.m_tBackFire = nil
    end
end

--@brief    获取宠物类型
--@return   #1,返回宠物类型
function WPet:getPetType()
    return self.m_tPetInfo.petType
end

function WPet:getPetId()
    return self.m_tPetInfo.petId
end

function WPet:getAnimation() 
    return self.m_tAnim
end

--@brief    设置宠物状态
function WPet:setStatus(status)
    self.m_nCurrentStatus = status
end

--@brief    获取宠物状态
function WPet:getStatus()
    return self.m_nCurrentStatus
end

--@brief    设置是否自动调整位置
function WPet:setTrackable(bTrack)
    if self.m_tTrackNode ~= nil then
        self.m_tTrackNode:setTrackable(bTrack)
    end
end

function WPet:update()
    if self.m_tAnim == nil then
        self:_init()
        SceneBattle:getFrontLayer():addChild(self.m_tAnim:getAnimNode(),5)
        if self:getAnimation():isCurrentAnimationDone() == true then
            self.m_tAnim:play(self:getPetWaitAnimName(),true)
        end
        self.m_bAdded = true
        --[[
        self.m_tTrackNode = TrackNode:create(self.m_tAnim:getAnimNode())
        self.m_tTrackNode:setPreAdd(Vector2:create(60,60))
        self.m_tTrackNode:setTrackFlip(true)
        self.m_tHero:getMover():addTrackNode(self.m_tTrackNode)
        --]]

        local advanceLevel = self.m_nLevel
        local petSprite = self:getAnimation():getAnimNode()
        local size = petSprite:getContentSize()
        WZLog("WPet:update", advanceLevel, size.width/2, size.height/2)
        local backFire = nil
        if advanceLevel and tonumber(advanceLevel) >= 6 then
            backFire = CCParticleSystemQuad:create("particle/pet_max_lizi.plist")
            backFire:setPositionType(kCCPositionTypeRelative)
            backFire:setAutoRemoveOnFinish(true)
            backFire:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
            backFire:setPosition(size.width/2 ,size.height/2)
            petSprite:addChild(backFire)
            self.m_tBackFire = backFire
            self.m_tBackFire:retain()
        end
    end
    if  self.m_nCurrentStatus == PetStatus.DEF_ST_NORMAL then
        ---[[
        local pos = self.m_tHero:getPosition()
        local anim = self.m_tHero:getAnimation()
        pos.y = pos.y + 90
        local size = self:getAnimation():getAnimNode():getContentSize()

        local offset = 70
        if anim:isFlipX() then
            pos.x = pos.x + offset
            self.m_tAnim:setFlipX(true)
        else
            self.m_tAnim:setFlipX(false)
            pos.x = pos.x - offset
        end
        self.m_tAnim:setPosition(pos)
        --]]

        --[[
        local anim = self.m_tHero:getAnimation()
        if anim:isFlipX() then
            self.m_tAnim:setFlipX(true)
        else
            self.m_tAnim:setFlipX(false)
        end
        --]]

        if self:getAnimation():isCurrentAnimationDone() == true then
            self:getAnimation():play(self:getPetWaitAnimName(), true)
        end

    end
end

--@brief    获取中心位置
--@return   #1:中心位置
function WPet:getCenterPos()
    local anchor = self:getAnimation():getAnimNode():getAnchorPoint()
    local size = self:getAnimation():getAnimNode():getContentSize()
    local heroCenter = CCPointMake(anchor.x*size.width, anchor.y*size.height)

    local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
    heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)
    return heroCenter
end

--@brief    获取动画中心位置
--@return   #1:动画中心位置
function WPet:getAnimationCenterPos()
    local size = self:getAnimation():getAnimNode():getContentSize()
    local heroCenter = CCPointMake(0.5*size.width, 0.5*size.height)

    local toParentTranf = self:getAnimation():getAnimNode():nodeToParentTransform()
    heroCenter=CCPointApplyAffineTransform(heroCenter,toParentTranf)
    return heroCenter
end

function WPet:getPetWaitAnimName()
    if self.m_bIsNewPetAnim then
        return "wait"
    else
        return "0"
    end
end

function WPet:getPetAtkAnimName()
    if self.m_bIsNewPetAnim then
        return "attack"
    else
        return "1"
    end
end

--@brief    事件函数
function WPet:event(animation, name, eventName)
    WZLog("WPet:event", animation, name, tostring(eventName))
    if SceneBattle:getBattleLoop():getBattleStatus() == BattleLoop.S_PET_SHOOT and name == "event" and eventName == "attack" then
        self.m_bIsAtk = true
        WZLog("WPet:event 2")
    end
end
-------------------------------------私有方法模块--------------------------------------
--@brief    初始化宠物信息
function WPet:_init()

     --2.0风格骨骼动画

    self.m_npetAnimId = self.m_tPetInfo.petId
    self.m_nLevel = self.m_tPetInfo.petLevel

    for i, info in pairs (GDatatab_pet_advanced) do
        if self.m_npetAnimId == info.animation then
            self.m_sAtkSound = info.atk_name .. ".mp3"
            self.m_bIsRange = info.remote or 0
        end
    end


    --self.m_npetAnimId = "pet_0102"
    WZLog("WPet:_init",self.m_tPetInfo.petId, self.m_tPetInfo.petLevel, self.m_sAtkSound,self.m_tPetInfo.petSkillId,self.m_tPetInfo.petType)

    nPetId = self.m_npetAnimId
    local str = string.find(nPetId, "_")
    local boolNewPet = (str ~= nil)
    self.m_bIsNewPetAnim = boolNewPet
    self.m_tAnim = BattleAnimation:createAnimation(nPetId, not boolNewPet,nil,self)
    self.m_tAnim:getAnimNode():setScale(GlobalGame.g_nPetScaleInBattle)
    self.m_tAnim:play(self:getPetWaitAnimName(),true)
    self.m_nCurrentStatus = PetStatus.DEF_ST_NORMAL
end



