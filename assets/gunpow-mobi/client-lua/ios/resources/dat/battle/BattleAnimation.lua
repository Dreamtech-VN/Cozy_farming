--BattleAnimation.lua
--@brief	战斗动画封装 主要是为了换装以及以后切换到dragon bones 方便
--@date  	2014/01/3
--@author 	TaoYinqing
--@note 	战斗动画封装对象


G_tDragonBone_Config = {
     kill01 = {
        path = "image/animations/kill/",
        action = {
            ["normal"] = 0,
        },
     },
	 kill02 = {
        path = "image/animations/kill/",
        action = {
            ["normal"] = 0,
        },
     },
	 kill05 = {
        path = "image/animations/kill/",
        action = {
            ["kill03"] = 1,
			["kill04"] = 0,
        },
     },
     boss7 = {
        action = {
            ["stand"] = 0,
        },
     },
     boss08 = {
        action = {
            ["stand"] = 0,
        },
     },
     battleboy = {
        action = {
            ["standby1"] 		= 0,
			--["standby2"]		= 1,
			["standby3"] 		= 2,
			["itemskill"] 		= 3,
			["move"] 			= 4,
			["attackstart1-s"] 	= 5,
			["attackstart1-s2"] = 6,
			["attack1-s"] 		= 7,
			["attackstart2-s"] 	= 8,
			["attackstart2-s2"] = 9,
			["attack2-s"] 		= 10,
			["attackstart1-t"] 	= 11,
			["attackstart1-t2"] = 12,
			["attack1-t"]		= 13,
			["attackstart2-t"]	= 14,
			["attackstart2-t2"] = 15,
			["attack2-t"] 		= 16,
			["fly"] 			= 17,
			["injured"] 		= 18,
			["ghost"] 			= 19,
        },
     },
	 battlegirl = {
        action = {
            ["standby1"] 		= 0,
			--["standby2"]		= 1,
			["standby3"] 		= 2,
			["itemskill"] 		= 3,
			["move"] 			= 4,
			["attackstart1-s"] 	= 5,
			["attackstart1-s2"] = 6,
			["attack1-s"] 		= 7,
			["attackstart2-s"] 	= 8,
			["attackstart2-s2"] = 9,
			["attack2-s"] 		= 10,
			["attackstart1-t"] 	= 11,
			["attackstart1-t2"] = 12,
			["attack1-t"]		= 13,
			["attackstart2-t"]	= 14,
			["attackstart2-t2"] = 15,
			["attack2-t"] 		= 16,
			["fly"] 			= 17,
			["injured"] 		= 18,
			["ghost"] 			= 19,
        },
     },
	 combatboy = {
        action = {
            ["standby1"] 		= 0,
			--["standby2"]		= 1,
			["standby3"] 		= 2,
			["itemskill"] 		= 3,
			["move"] 			= 4,
			["attackstart1-s"] 	= 5,
			["attackstart1-s2"] = 6,
			["attack1-s"] 		= 7,
			["attackstart2-s"] 	= 8,
			["attackstart2-s2"] = 9,
			["attack2-s"] 		= 10,
			["attackstart1-t"] 	= 11,
			["attackstart1-t2"] = 12,
			["attack1-t"]		= 13,
			["attackstart2-t"]	= 14,
			["attackstart2-t2"] = 15,
			["attack2-t"] 		= 16,
			["fly"] 			= 17,
			["injured"] 		= 18,
			["ghost"] 			= 19,
        },
     },
}

ArmaturesFolderConfig =
{
    [1]={monsterskill = "battle/monsterSkill"},
    [2]={skill = "battle/skill"},
    [3]={skills = "battle/skill"},
    [4]={pet0 = "pet"},
    [5]={monster_bullet_ = "battle/bullet"},
    [6]={monster_bomb = "battle/bullet"},
    [7]={boss_bullet_ = "battle/bullet"},
    [8]={bullet_ = "battle/bullet"},
    [9]={face = "battle/face"},
    [10]={monster = "battle/monster"},
    [11]={boss = "battle/monster"},
    [12]={pao = "battle/monster"},
    [13]={pet_0 = "pet"},
    [14]={scene_city = "ui/city/newMainScene/armature"},
    [15]={scene = "battle/sceneBattle"},
    [16]={particle_pet_0 = "pet_particle"},
}

BattleAnimation = {}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建动画实例
--@param	sAninName 动画名称
--@param    bUseDragonBone 是否使用的是DragonBone动画
--@return	#1,返回一个动画封装的实例
--@note		根据指定的动画名称 创建一个动画
function BattleAnimation:createAnimation(sAninName,bUseDragonBone,folder,eventLuaObject)
    WZLog("BattleAnimation:createAnimation",sAninName,tostring(bUseDragonBone))
	local obj = {}
    if bUseDragonBone == nil then
        bUseDragonBone = false
    end
	setmetatable(obj,{__index = BattleAnimation})
    obj:init(sAninName,bUseDragonBone,folder,eventLuaObject)
    return obj
end

function BattleAnimation:init(sAninName,bUseDragonBone,folder,eventLuaObject)
    self.m_bIsFrozen = nil
    self.m_sAninName = sAninName
    self.m_nAninIdSeed = 0
    self.m_tAnimMap = {}
    self.m_currentSequence = {}
    self.m_bUseDragonBone = bUseDragonBone
    self.m_running = false
    self.m_eventLuaObject = eventLuaObject
    --boss特效优先查找
    if folder == nil and string.find(sAninName,"boss_") and string.find(sAninName,"_effect") then
        folder = "battle/monsterSkill"
    end

    if folder == nil then 
        for index,config in ipairs (ArmaturesFolderConfig) do
            for name,folderName in pairs (config) do
                if string.sub(sAninName, 1, string.len(name)) == name then
                    WZLog("BattleAnimation:createAnimation two", name, sAninName,  string.sub(sAninName, 1, string.len(name)))
                    folder = folderName
                end
            end
            if folder ~= nil then
                break
            end
        end
    end

    if bUseDragonBone == true then
        --TODO
        --if G_tDragonBone_Config[sAninName] == nil then
        --    return nil
        --end
        --WZLog("BattleAnimation:createAnimation one", self.m_sAninName, tostring(folder))
        local info = G_tDragonBone_Config[self.m_sAninName]
        self.m_currentBone = nil
        self.m_node = WZArmature:create()
        self.m_node:setArmatureName(self.m_sAninName)

        --folder = nil

        if folder == nil then
            folder = "old"
        end
        if folder then
            local file = folder.."/"..self.m_sAninName .. ".xml"
            --WZLog("BattleAnimation:createAnimation three", folder, file)
            self.m_node:setArmatureFile(file)
        end
        self.m_node:setUseOriginSize(true)
    else
        self.m_node = WZUISpine:create()
        local file = self.m_sAninName

        if folder == nil then
            folder = "old"
        end

        if folder ~= nil then
            file = folder .. "/" .. self.m_sAninName
        end
        self.m_node:setFileJson(file .. ".json")
        self.m_node:setFileAtlas(file .. ".atlas")
    end
    if self.m_node then 
        self.m_node:setLuaObjectIndex(self)
    end
    if eventLuaObject and self.m_node.setLuaSpineEventFunc then
        self.m_node:setLuaSpineEventFunc("event")
    end

    if folder == "pet" then
        --添加例子动作特效
          WZLog("BattleAnimation:init1",sAninName)
          local particleAniName = "particle_"..sAninName
          if WZDataFile:getInstance():checkFileExist("pet_particle/"..particleAniName .. ".json") then
            WZLog("BattleAnimation:init2",sAninName)
            local petAnimation2 = BattleAnimation:createAnimation(particleAniName, false)
            local animNode2 = petAnimation2:getAnimNode()
            animNode2:setRelativePosition(ccp(0.5,0.5))
            animNode2:setAnchorPoint(ccp(0.5,0.5))
            animNode2:setUseOriginSize(true)
            self.m_node:addChild(animNode2,1)
            --petAnimation2:play("wait",true)
            self.m_effectAnim = petAnimation2
            self.m_effectNode = animNode2
          end
    end
end

--@brief    事件函数
function BattleAnimation:event(animation, name, eventName)
    WZLog("BattleAnimation:event", tostring(self.m_eventLuaObject), animation, name, eventName)
    if self.m_eventLuaObject then
        self.m_eventLuaObject:event(animation, name, eventName)
    end
end

function BattleAnimation:onEnter(element)
	--WZLog("BattleAnimation:onEnter(element)",self.m_sAninName)
	self.m_running = true
	
end

function BattleAnimation:onExit(element)
	--WZLog("BattleAnimation:onExit(element)",self.m_sAninName)
	self.m_running = false
    --self.m_node = nil 
end

--@brief	添加一个套装动画动画
--@param	sAnimationName，动作名称
--@param	tEquip，装备表，key和value都为字符串，如果没有可赋空
--@param    fDelay  延迟
--@param	bDefault，是否过滤？可赋空，默认为true
--@param    sAnim  动画名称
--@note		创建指定的套装
function BattleAnimation:addAnimation(sActionName, tEquip,fDelay,bDefault,sAnim)
    do return end
    if self.m_tAnimMap[sActionName] then
        return
    end
	local aniPool=cwSngAnimationPool:sharedAnimationPool()
    local desc = TableToMap(tEquip or {})
    sAnim = sAnim or self.m_sAninName
	if bDefault == nil then
		bDefault = true
	end
    local ani = aniPool:animation(sAnim, sActionName, desc, bDefault)

    if ani == nil then
        WZLog("BattleAnimation:addAnimation",tostring(sAnim), tostring(sActionName), tostring(desc), tostring(bDefault))
    end
    if fDelay ~= nil and fDelay > 0 then
        ani:setDelayPerUnit(fDelay)
    end

    self.m_node:addAnimationToDict(self.m_nAninIdSeed,ani)
    if self.m_nAninIdSeed == 0 then
    	self.m_node:setAnimation(self.m_nAninIdSeed)
    end
    self.m_tAnimMap[sActionName] = self.m_nAninIdSeed
    self.m_nAninIdSeed = self.m_nAninIdSeed + 1
end

--@brief	播放动作
--@param	sActionName 动作名称
--@param	bLoop 是否循环播放
--@return  	#1,true 切换成功 false 切换失败
--@note		将动画切换到指定的动作上面去
function BattleAnimation:play(sActionName,bLoop,sBoneName)
    -- WZLog("BattleAnimation:play", sActionName, tostring(self), tostring(self.m_bIsFrozen))
    if sActionName == nil or self.m_bIsFrozen then
        return false
    end
    if self.m_effectAnim then 
        self.m_effectAnim:play(sActionName,bLoop,sBoneName)
    end
	if self.m_bUseDragonBone == true then
        local action = WZUIArmatureAnimationById:create()
        local info = G_tDragonBone_Config[self.m_sAninName]
        --if info == nil or info.action[sActionName] == nil then
        --    return false
        --end
        if info ~= nil and info.action[sActionName] ~= nil then
            action:setAnimationId(info.action[sActionName])
        else
            action:setAnimationId(tonumber(sActionName))
        end
        self.m_currentBone = sBoneName
        if sBoneName ~= nil then
            action:setBone(sBoneName)
        end
        if bLoop ~= nil then
            if bLoop == true then
                action:setLoop(1)
            else
                action:setLoop(0)
            end
        end
        self.m_node:runUIAction(action)
		
		if self:getAnimNode():getArmatureName() == "combatboy" and sBoneName == nil then
			self:play(sActionName,true,"combatboy_face")
		end
		
    else
        --self.m_node:setLoop(bLoop == true)
		self.m_node:play(sActionName,bLoop == true);
		return true
    end
	return false
end

--@brief    播放动作
--@param    sActionName 动作名称
--@param    nTime 播放多少次
--@return   #1,true 切换成功 false 切换失败
function BattleAnimation:playTimes(sActionName,nTime)
    self:play(sActionName,false)
    return true
end

--@brief    播放动作序列
--@param    sActionSequence动作序列  第一次传非空  后面传空
--@return   #1,true 播放结束 false 播放没有结束
function BattleAnimation:playSequence(sActionSequence)
    self:play(sActionName,false)
    return true
end

--@brief    判断当前是否在播放某个动画
--@param    sActionName 动画名字
--@return   #1, true 在播放 false 没有
function BattleAnimation:isPlaying(sActionName)
    -- WZLog("BattleAnimation:isPlaying", self.m_sAninName, sActionName)
    if sActionName == nil then
        return false
    end
    if self.m_running == false then return false end
    if self.m_bUseDragonBone == true then
        local info = G_tDragonBone_Config[self.m_sAninName]
        --if info == nil or info.action[sActionName] == nil then
        --    return false
        --end
        local index = 0
        if info ~= nil and info.action[sActionName] ~= nil then
            --action:setAnimationId(info.action[sActionName])
            index = info.action[sActionName]
        else
            --action:setAnimationId(tonumber(sActionName))
            index = tonumber(sActionName)
        end
        --local index = info.action[sActionName]
        return self.m_node:isPlayIndex(index)
    else
        local animId = self.m_node:getAnimationName()
        return sActionName == animId
    end
end

--@brief 判断当前动画是否播放结束
--@return #1, true 播放结束 false 正在播放中
function BattleAnimation:isCurrentAnimationDone()
    if self.m_node == nil then
       return true
    end
    if self.m_running == false then return true end
    --WZLog("BattleAnimation:isCurrentAnimationDone", self.m_sAninName)
    if self.m_bUseDragonBone == true then
        if self.m_currentBone == nil then
            return self.m_node:isCurrentDone("")
        else
            return self.m_node:isCurrentDone(self.m_currentBone)
        end
    else
        return self.m_node:isCurrentAnimationDone()
    end
end

--@brief	获得动画节点
--@return  	#1,动画节点
--@note		获得动画节点
function BattleAnimation:getAnimNode()
    --if self.m_running == false then return nil end
	return self.m_node
end

--@brief    获得特效动画节点
--@return   #1,特效动画节点
--@note     获得特效动画节点
function BattleAnimation:getEffectAnimNode()
    --if self.m_running == false then return nil end
    return self.m_effectNode
end

--@brief    获得特效动画
--@return   #1,特效动画
--@note     获得特效动画
function BattleAnimation:getEffectAnim()
    --if self.m_running == false then return nil end
    return self.m_effectAnim
end

--@brief    当前结点是否是在场景里面
function BattleAnimation:isRunning()
    return self.m_running
end 

--@brief 	X轴翻转
--@param	bValue 是否X轴翻转
function BattleAnimation:setFlipX(bValue)
    --WZLog("BattleAnimation:setFlipX", tostring(bValue))
    --[[
    if self.m_bUseDragonBone == true then
        if bValue == true then
            self.m_node:setScaleX(math.abs(self.m_node:getScaleX()) * -1)
        else
            self.m_node:setScaleX(math.abs(self.m_node:getScaleX()))
        end
    else
        self.m_node:setFlipX(bValue)
    end
    --]]
    if bValue == true then
        self.m_node:setScaleX(math.abs(self.m_node:getScaleX()) * -1)
    else
        self.m_node:setScaleX(math.abs(self.m_node:getScaleX()))
    end
end

--@brief 	判断是否X轴翻转
--@return	true X轴翻转 false 没有翻转
function BattleAnimation:isFlipX()
    --[[
    if self.m_bUseDragonBone == true then
        return self.m_node:getScaleX() < 0
    else
        return self.m_node:getFlipX()
    end
	--]]
    return self.m_node:getScaleX() < 0
end

--@brief 	Y轴翻转
--@param	bValue 是否Y轴翻转
function BattleAnimation:setFlipY(bValue)
	--self.m_node:setFlipY(bValue)
    if bValue == true then
        self.m_node:setScaleY(math.abs(self.m_node:getScaleY()) * -1)
    else
        self.m_node:setScaleY(math.abs(self.m_node:getScaleY()))
    end
end

--@brief 	判断是否Y轴翻转
--@return	true Y轴翻转 false 没有翻转
function BattleAnimation:isFlipY()
	return self.m_node:getScaleY() < 0
end

--@brief 	设置X轴缩放
--@param	nScale 缩放值
function BattleAnimation:setScaleX(nScale)
    if self.m_bUseDragonBone == true then
        if self.m_node:getScaleX() < 0 then
            self.m_node:setScaleX(nScale * -1)
        else
            self.m_node:setScaleX(nScale)
        end
    else
        self.m_node:setScaleX(nScale)
    end
end

--@brief	设置Y轴缩放
--@param	nScale  缩放值
function BattleAnimation:setScaleY(nScale)
	if self.m_bUseDragonBone == true then
        if self.m_node:getScaleY() < 0 then
            self.m_node:setScaleY(nScale * -1)
        else
            self.m_node:setScaleY(nScale)
        end
    else
        self.m_node:setScaleY(nScale)
    end
end

function BattleAnimation:setScale(nScale)
    --WZLog("BattleAnimation:setScale", tostring(self), nScale)
	self:setScaleX(nScale)
	self:setScaleY(nScale)
end

function BattleAnimation:getScale()
    return self.m_node:getScale()
end

--@brief	设置坐标值
--@param	tPos	坐标点的值可以通过x y访问
function BattleAnimation:setPosition(tPos)
    if self.m_node.setUseAbsCoordinate then
        self.m_node:setUseAbsCoordinate(true)
        self.m_node:setAbsPosition(GlobalMethod:ccp(tPos.x,tPos.y))
    end
    self.m_node:setPositionX(tPos.x)
    self.m_node:setPositionY(tPos.y)
end


--@brief	获取坐标值
--@param	#1, 返回坐标值 格式是{x = 0,y = 0}
function BattleAnimation:getPosition()
	local pos = {x = 0, y = 0}
	pos.x , pos.y = self.m_node:getPosition()
	return pos
end

--@brief	设置旋转角度
--@param	nAngle 旋转角度
function BattleAnimation:setRotate(nAngle)
    WZLog("BattleAnimation:setRotate", self, nAngle)
    if nAngle > 360 then
       nAngle = nAngle - 360 
    end
	if nAngle < -360 then
       nAngle = nAngle + 360 
    end
    if self.m_bUseDragonBone == true and self.m_node:getArmature() ~= nil then
        self.m_node:setRotation(nAngle)
    else
        self.m_node:setRotation(nAngle)
    end
end

--@brief    获得旋转角度
--@return   #1, 返回旋转角度
function BattleAnimation:getRotate()
    if self.m_bUseDragonBone == true and self.m_node:getArmature() ~= nil then
        return self.m_node:getRotation()
    end
    return self.m_node:getRotation()
end


function BattleAnimation:showAnchor(bShow)
    if self.m_bUseDragonBone == false then
        --self.m_node:setIsShowAchorPoint(bShow)
    else
        self.m_node:getArmature():setShowAnchor(bShow)
    end
end

--@brief    设置zorder
--@param    nOrder order值
function BattleAnimation:setZOrder(nOrder)
    if self.m_bUseDragonBone == false then
        self.m_node:setZOrder(nOrder)
    end
end

--@brief    获取当前的order值
--@return   #1, 当前的order值
function BattleAnimation:getZOrder()
    if self.m_bUseDragonBone == false then
        return self.m_node:getZOrder()
    end
    return 0
end
--@brief    在节点附近画一个圆
--@param    tCenter2 圆心
--@param    nRadius 半径
--@param    tColor 颜色
function BattleAnimation:addCircle(tCenter2,nRadius,tColor,tNode)
    tColor = tColor or {r = 2.0,g = 190,b = 200,a = 1.0}
    local drawNode = CCDrawNode:create()
    local p1 = GlobalMethod:ccp(0,0)
    local p2 = GlobalMethod:ccp(0,0)
    local color = ccc4f(tColor.r, tColor.g, tColor.b, tColor.a)
    --for (float angle = 0; angle <= 2 * M_PI; angle += 0.01)
    --{
    local angle = 0
    repeat
        p2.x = nRadius * math.cos(angle)
        p2.y = nRadius * math.sin(angle)
        --WZLog(p2.x,p2.y)
        drawNode:drawDot(p2, 1, color)
        angle = angle + 0.01
    until angle > 2*math.pi
    drawNode:setPosition(tCenter2.x,tCenter2.y)
    if tNode ~= nil then
        tNode:addChild(drawNode,99)
    else
       self.m_node:addChild(drawNode)
    end
    return drawNode
end

function BattleAnimation:isDragonBone()
    return self.m_bUseDragonBone
end

function BattleAnimation:setSkin(skin)
	if self.m_bUseDragonBone ~= true then 
		self.m_node:setSkin(skin)
	end 
end

--@brief    暂停动画播放
function BattleAnimation:pause()
    if self.m_node.pause ~= nil then 
        WZLog("BattleAnimation:pause")
        self.m_node:pause()
    end 
end

--@brief    继续动画播放
function BattleAnimation:resume()
    if self.m_node.resume ~= nil then 
        WZLog("BattleAnimation:resume")
        self.m_node:resume()
    end
end
--@brief    在节点上面画一个矩形
--@param    tRect 矩形 {x = 0 , y = 0 , w = 1 , h = 1}
function BattleAnimation:addRect(tRect,tColor,tNode)
    tColor = tColor or {r = 20.0,g = 190,b = 200,a = 1.0}
    local drawNode = CCDrawNode:create()
    local x = 0
    local y = 0
    local p1 = GlobalMethod:ccp(0,0)
    local color = ccc4f(tColor.r, tColor.g, tColor.b, tColor.a)
    repeat
        p1.y = 0
        p1.x = x
        drawNode:drawDot(p1, 1, color)
        
        p1.y = tRect.h
        p1.x = x
        drawNode:drawDot(p1, 1, color)
        x = x + 1
    until x >= tRect.w
    
    y = 0
    repeat
        p1.y = y
        p1.x = 0
        drawNode:drawDot(p1, 1, color)
        
        p1.y = y
        p1.x = tRect.w
        drawNode:drawDot(p1, 1, color)
        y = y + 1
    until y >= tRect.h
    drawNode:setPosition(tRect.x-tRect.w*0.5,tRect.y-tRect.h*0.5)
    if tNode ~= nil then
        tNode:addChild(drawNode,1000)
    else
       self.m_node:addChild(drawNode)
    end
    return drawNode
end


--@brief    改变透明度
function BattleAnimation:setOpacity(opacity)
    self:getAnimNode():setOpacity(opacity)
    if self.m_effectAnim then 
        self.m_effectAnim:getAnimNode():setOpacity(opacity)
    end
end