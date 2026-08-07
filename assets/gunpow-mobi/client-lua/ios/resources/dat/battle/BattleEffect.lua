--BattleAnimation.lua
--@brief    战斗特效
--@date     2015/05/28

BattleEffect = {
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief    创建动画实例
--@param    effectId 动画id
--@param    bUseDragonBone 是否使用的是DragonBone动画
--@param    isAutoRemove 自动移除
--@return   #1,返回一个动画封装的实例
--@note     根据指定的动画id 创建一个动画
function BattleEffect:createAnimation(effectId)

    if bUseDragonBone == nil then
        bUseDragonBone = false
    end

    setmetatable(BattleEffect,{__index = BattleAnimation})
    local obj = {}
    setmetatable(obj, {__index = BattleEffect})
    obj:prepareConfig(obj,effectId)

    if obj.m_bIsProgram then 
        obj:createProgramEffect()
    else
        -- obj:createEffect()
        WZLog("BattleEffect:createEffect",obj.m_sAninName)
        obj:init(obj.m_sAninName,obj.m_bUseDragonBone)
    end

    obj:initWithConfig()

    if obj.m_bIsAutoRemove then
        BattleEffectManager:getInstance():addEffect(obj)
    end

    obj.m_tCallBack = {}
    obj:setPosition(BattleCommon:getPointTable(0,0))
    if not obj.m_bUseDragonBone then
        obj:continue()
    end
    return obj
end

--@brief    创建特效
function BattleEffect:createEffect()
    -- self.m_nAninIdSeed = 0
    -- self.m_tAnimMap = {}
    -- self.m_currentSequence = {}
    -- local sAninName = self.m_sAninName
    -- local folder = nil
    
    -- for index,config in ipairs (ArmaturesFolderConfig) do
    --     for name,folderName in pairs (config) do
    --         if string.sub(sAninName, 1, string.len(name)) == name then
    --             WZLog("BattleAnimation:createAnimation two", name, sAninName,  string.sub(sAninName, 1, string.len(name)))
    --             folder = folderName
    --         end
    --     end
    --     if folder ~= nil then
    --         break
    --     end
    -- end

    -- if self.m_bUseDragonBone == true then
    --     WZLog("BattleAnimation:createAnimation one", self.m_sAninName, tostring(folder))
    --     local info = G_tDragonBone_Config[self.m_sAninName]
    --     self.m_currentBone = nil
    --     self.m_node = WZArmature:create()
    --     self.m_node:setArmatureName(self.m_sAninName)

    --     --folder = nil

    --     if folder == nil then
    --         folder = "old"
    --     end
    --     if folder then
    --         local file = folder.."/"..self.m_sAninName .. ".xml"
    --         WZLog("BattleAnimation:createAnimation three", folder, file)
    --         self.m_node:setArmatureFile(file)
    --     end
    --     self.m_node:setUseOriginSize(true)
    -- else
    --     self.m_node = WZUISpine:create()
    --     local file = self.m_sAninName

    --     if folder == nil then
    --         folder = "old"
    --     end

    --     if folder ~= nil then
    --         file = folder .. "/" .. self.m_sAninName
    --     end
    --     self.m_node:setFileJson(file .. ".json")
    --     self.m_node:setFileAtlas(file .. ".atlas")
    -- end
end

--@brief    初始化特效
function BattleEffect:initWithConfig()
    if not self.m_bIsProgram then
        for i = 1, #self.m_tActionNames do
            self:addAnimation(self.m_tActionNames[i],{}, 0.1, true)
        end
    end

    self.m_node:setPositionX(0)
    self.m_node:setPositionY(0)

    local size = SceneBattle:getFrontLayer():getContentSize()
    if self.m_bIsHorizon then
        self.m_tScalePos.x = math.ceil(size.width / self.m_node:getContentSize().width)
    end

    if self.m_bIsVertical then 
        self.m_tScalePos.y = math.ceil((size.height / self.m_node:getContentSize().height) * 10)/10
    end

    --self:setScaleX(self.m_tScalePos.x)
    --self:setScaleY(self.m_tScalePos.y)
    --self:setRotation(self.m_nRotation)
end

--@brief     特效size
--@param
function BattleEffect:getEffectSize()
    return self:getAnimNode():getArmature():boundingBox().size
end

--@brief     特效角度
--@param
function BattleEffect:setRotation(val)
    if not val then
        return
    end

    self:getAnimNode():getArmature():setRotation(val)
end

--@brief    设置X轴缩放
--@param    nScale 缩放值
function BattleEffect:setScaleX(nScale)
     if not nScale then
        return
    end
    self:getAnimNode():getArmature():setScaleX(nScale)
end

--@brief    设置Y轴缩放
--@param    nScale 缩放值
function BattleEffect:setScaleY(nScale)
     if not nScale then
        return
    end
    self:getAnimNode():getArmature():setScaleY(nScale)
end

--@brief    设置缩放
--@param    nScale 缩放值
function BattleEffect:setScale(nScale)
     if not nScale then
        return
    end
    self:getAnimNode():getArmature():setScale(nScale)
end

--@brief     添加特效结束回调函数
--@param
function BattleEffect:setStepCallBack(callBack)
    self.m_tCallBack = callBack
end

function BattleEffect:addEndCallBack(callBack)
    self.m_endEffectCB = callBack
end

--@brief    处理特效节点回调
--@param
function BattleEffect:doneEffect()
    --[[
    if not self.m_nIndex then
        self.m_nIndex = 1
    else
        self.m_nIndex = self.m_nIndex + 1
    end
    ]]
    --self:doneStepEffect()
end

function BattleEffect:doneStepEffect()
    --特效回调 修改在播放时候触发 
    if not self.m_nIndex then
        self.m_nIndex = 1
    else
        self.m_nIndex = self.m_nIndex + 1
    end

    if self.m_tDoneList[self.m_nIndex] and self.m_tDoneList[self.m_nIndex] ~= -1 and self.m_tCallBack then
        --WZLog("BattleEffect:doneEffect",self.m_nIndex)
        self.m_tCallBack(self.m_tDoneList[self.m_nIndex],self:getIsSpringByIndex(self.m_nIndex))
    end
end

--@brief    播放特效
--@param
function BattleEffect:playEffect(actionName)
    if self.m_bIsProgram then
        return
    end
    local actionName = actionName or self:getCurActionName()
    WZLog("BattleEffect:playEffect",actionName)
    if actionName then
        self:play(actionName,false)
        self:doneStepEffect()
    end
end

--@brief    继续播放
function BattleEffect:continue()
    local  actionName = self:getCurActionName()
    if actionName then
        self:playEffect(actionName)
        return true
    end
    if self.m_endEffectCB then
        self.m_endEffectCB()
    end
    return false
end

--@brief    从特效列表里 抽取特效名字 并在 列表中移除
function BattleEffect:getCurActionName()
    if #self.m_tActionNames <= 0 then
        return nil
    end
    local actionName = self.m_tActionNames[1]
    table.remove(self.m_tActionNames,1)
    return actionName
end

--@brief 是否震动屏幕特效节点
function BattleEffect:getIsSpringByIndex(index)
    if self.m_tScreenSpring[index] then
        return tonumber(self.m_tScreenSpring[index]) == 1
    end
    return false
end

--@brief    设置坐标值
--@param    tPos    坐标点的值可以通过x y访问
function BattleEffect:setPosition(tPos)
    local tx = tPos.x + self.m_tOfferPos.x
    local ty = tPos.y + self.m_tOfferPos.y
    -- tPos.x = tPos.x + self.m_tOfferPos.x
    -- tPos.y = tPos.y + self.m_tOfferPos.y

    -- if self.m_bUseDragonBone == true then
        self.m_node:setUseAbsCoordinate(true)
        self.m_node:setAbsPosition(GlobalMethod:ccp(tx,ty))
    -- else
        -- self.m_node:setPosition(tx,ty)
    -- end
end

--@brief    获取运动坐标值（忽略偏移量）
--@param    tPos    坐标点的值可以通过x y访问
function BattleEffect:getMovePosition(tPos)
    local pos = self:getPosition()
    pos.x = pos.x - self.m_tOfferPos.x
    pos.y = pos.y - self.m_tOfferPos.y
    return pos
end

--@brief    是否阻塞消息
function BattleEffect:getIsBlockMsg()
    return self.m_bIsBlockMsg
end

--@brief    获取特效表配置
function BattleEffect:_getEffectInfoData(id)
    return EffectInfoConfig["id_"..id]
end

--@brief    解析配置
function BattleEffect:prepareConfig(obj,effectId)
    local config = self:_getEffectInfoData(effectId)
    --local paramList = self:splitStringWithSeparator(config)
    obj.m_effectId = effectId
    obj.m_bIsProgram = config.isCode == 1 and true or false         --paramList[1][1] == "1" and true or false
    obj.m_bIsAutoRemove = config.isTmp == 1 and true or false      --paramList[1][2] == "1" and true or false
    obj.m_bIsBlockMsg = config.isBlock == 1 and true or false       --paramList[1][3] == "1" and true or false
    obj.m_sAninName = config.source                                 --paramList[2][1]
    obj.m_bUseDragonBone = config.isArmature == 1 and true or false
    obj.m_tActionNames = {}
    
    if config.actions ~= -1 then
        local actions = self:splitStringWithSeparator(config.actions)[1]
        for i = 1,#actions do
            table.insert(obj.m_tActionNames,actions[i])
        end
    end

    obj.m_tDoneList = {}
    -- if config.doEffects ~= -1 then
    --     local doEffects = self:splitStringWithSeparator(config.doEffects)[1]
    --     for i = 1,#doEffects do
    --         table.insert(obj.m_tDoneList,doEffects[i])
    --     end
    -- end

    obj.m_tScreenSpring = {}
    if config.screenSprings and config.screenSprings ~= -1 then
        local screenSprings = self:splitStringWithSeparator(config.screenSprings)[1]
        for i = 1,#screenSprings do
            table.insert(obj.m_tScreenSpring,screenSprings[i])
        end
    end

    if #obj.m_tDoneList > 0 then
        self.m_bIsOnStep = true
    else
        self.m_bIsOnStep = false
    end
   
    obj.m_tOfferPos = BattleCommon:getPointTable(config.offsetX, config.offsetY)  --BattleCommon:getPointTable(tonumber(paramList[4][1]) or 0, tonumber(paramList[4][2]) or 0)
    obj.m_tScalePos = BattleCommon:getPointTable(config.scaleX/100, config.scaleY/100)    --BattleCommon:getPointTable(tonumber(paramList[5][1]) or 1, tonumber(paramList[5][2]) or 1)
    obj.m_nRotation = config.rotation                     --tonumber(paramList[6][1]) or 0
    if config.tiledType == 1 then
        obj.m_bIsHorizon = true
    elseif config.tiledType == 2 then
        obj.m_bIsVertical = true
    end
    --WZLog("BattleEffect:prepareConfig",obj.m_bIsProgram,obj.m_bIsAutoRemove,obj.m_bIsBlockMsg,obj.m_sAninName, Serialize(obj.m_tActionNames),self.m_bIsOnStep,Serialize(obj.m_tDoneList))
    --obj.m_bIsHorizon = paramList[7][1] == "1" and true or false
    --obj.m_bIsVertical = paramList[7][2] == "1" and true or false
end

--@brief    根据分隔符拆分字符串"
--@param    s:要分隔的字符串
function BattleEffect:splitStringWithSeparator(s)
    --WZLog("BattleEffect:splitStringWithSeparator", s)
    if not s then
        return {}
    end
    
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    local sChange = "%],%["
    local sChanged = " | "
    s = string.gsub(s, " ", "")
    s = string.gsub(s, sChange, sChanged)
    s = string.gsub(s, "%[", "")
    s = string.gsub(s, "%]", "")
   
    nSplitArray = SplitStringWithSeparator(s, sChanged)
    
    for i, v in pairs(nSplitArray) do
        if v == nil or v == "" then
            break
        end
        nSplitArray[i] = SplitStringWithSeparator(v, ",")
    end
    
    --WZLog("BattleEffect:splitStringWithSeparator one", s,Serialize(nSplitArray))
    return nSplitArray
end

--@brief    创建程序特效
function BattleEffect:createProgramEffect()
    self.m_node = CCSprite:create()
    if self.m_sAninName == "5001" or  self.m_sAninName == "5002" then
        self:createBoss5Warn()
     else
        self:createBoss5Warn()
    end
end

function BattleEffect:createBoss5Warn()
   -- WZLog("BattleEffect:createBoss5Warn")
    self.child = {}
    for i = 1, 3 do
        local sp = CCSprite:create()
        local array = CCArray:create()
        array:addObject(CCSprite:create("common/animation/boss/boss5_mark.png"):displayFrame())
        array:addObject(CCSprite:create():displayFrame())
        array:addObject(CCSprite:create("common/animation/boss/boss5_mark1.png"):displayFrame())
        array:addObject(CCSprite:create():displayFrame())
        local anim = CCAnimation:createWithSpriteFrames(array, 0.4)
        local action =  CCRepeatForever:create(CCAnimate:create(anim))
        sp:runAction(action)
        sp:setAnchorPoint(GlobalMethod:ccp(0,0))
        self.m_node:addChild(sp)
        table.insert(self.child, sp)
    end
    self.m_node:setContentSize(GlobalMethod:CCSize(32, 32))
end

