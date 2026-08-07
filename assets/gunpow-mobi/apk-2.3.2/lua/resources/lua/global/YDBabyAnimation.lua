--YDBabyAnimation.lua
--@brief	人物动画封装 主要是为了换装方便
--@date  	2015/06/09
--@author 	TaoYinqing
--@note 	人物动画封装对象

local g_YDBabyAnimation_Configs = {
	boy = {
		action = {
			["sit"]={zDefault=2,head=0,face=2},
			["sleep"]={zDefault=3,head=0,face=3},
			["wait"]={zDefault=0,head=0,face=0},
			["walk"]={zDefault=1,head=0,face=1},
			["sit_cry"]={zDefault=2,head=0,face=5},
			["sleep_cry"]={zDefault=3,head=0,face=5},
			["wait_cry"]={zDefault=0,head=0,face=5},
			["walk_cry"]={zDefault=1,head=0,face=5},
			["sit_happy"]={zDefault=2,head=0,face=4},
			["sleep_happy"]={zDefault=3,head=0,face=4},
			["wait_happy"]={zDefault=0,head=0,face=4},
			["walk_happy"]={zDefault=1,head=0,face=4},
			["avatar"]={zDefault=4,head=1,face=6},
			["ride"]={zDefault=5,head=0,face=7,mount_body=0,mount_head=0},
			["bomb_1"]={zDefault=6,head=0,face=0,body=6},
			["bomb_2"]={zDefault=7,head=0,face=0,body=7},
			["bomb_3"]={zDefault=8,head=0,face=0,body=8},
			["gun_1"]={zDefault=9,head=0,face=0,body=9},
			["gun_2"]={zDefault=10,head=0,face=0,body=10},
			["gun_3"]={zDefault=11,head=0,face=0,body=11},
        },
        bone = {
			weapon_gun = {"baby_boy_gun"},
			weapon_bomb = {"baby_boy_bomb"},
		},
	},
	girl = {
		action = {
			["sit"]={zDefault=2,head=0,face=2},
			["sleep"]={zDefault=3,head=0,face=3},
			["wait"]={zDefault=0,head=0,face=0},
			["walk"]={zDefault=1,head=0,face=1},
			["sit_cry"]={zDefault=2,head=0,face=5},
			["sleep_cry"]={zDefault=3,head=0,face=5},
			["wait_cry"]={zDefault=0,head=0,face=5},
			["walk_cry"]={zDefault=1,head=0,face=5},
			["sit_happy"]={zDefault=2,head=0,face=4},
			["sleep_happy"]={zDefault=3,head=0,face=4},
			["wait_happy"]={zDefault=0,head=0,face=4},
			["walk_happy"]={zDefault=1,head=0,face=4},
			["avatar"]={zDefault=4,head=1,face=6},
			["ride"]={zDefault=5,head=0,face=7,mount_body=0,mount_head=0},
			["bomb_1"]={zDefault=6,head=0,face=0,body=6},
			["bomb_2"]={zDefault=7,head=0,face=0,body=7},
			["bomb_3"]={zDefault=8,head=0,face=0,body=8},
			["gun_1"]={zDefault=9,head=0,face=0,body=9},
			["gun_2"]={zDefault=10,head=0,face=0,body=10},
			["gun_3"]={zDefault=11,head=0,face=0,body=11},
        },
        bone = {
			weapon_gun = {"baby_girl_gun"},
			weapon_bomb = {"baby_girl_bomb"},
		},
	},
}

YDBabyAnimation = {
	m_sAninName = nil,  		--动画名字
	m_tLoadArmature = nil, 		--额外加载的骨骼动画名字
    m_tLoadPlist = nil
}

-------------------------------------公有方法模块Begin--------------------------------------


--@brief	创建骨骼动画实例
--@param 	bBoy  是否是男孩
--return    新的实例
function YDBabyAnimation:createAnimation(bBoy)
	local obj = {}
	setmetatable(obj,{__index = YDBabyAnimation})
	if bBoy == true then
        obj.m_sAninName = "boy"
	else 
        obj.m_sAninName = "girl"
	end
    --bMonster = bMonster or false
	obj.m_isMonster = bMonster
    obj.m_monsterName = ""
    obj.m_tLoadArmature = {}
    obj.m_tLoadPlist = {}
    obj.m_bBoy = bBoy
    if obj.m_bBoy == nil then 
        obj.m_bBoy = true
    end
    if obj.m_isMonster == nil then 
        obj.m_isMonster = false
    end
    obj.m_node = WZArmature:create()
	obj.m_node:setLuaObjectIndex(obj)
    obj.m_node:setContentSize(GlobalMethod:CCSize(150,150))
    if obj.m_node.setUseABSSize ~= nil then 
        obj.m_node:setUseABSSize(true)
        obj.m_node:setAbsSize(150,150)
    else
        obj.m_node:setContentSize(GlobalMethod:CCSize(150,150))
    end
	
	obj.m_bodyIndex = 1
	obj.m_faceIndex = 1
	obj.m_headIndex = 1
	obj.m_mountIndex = 0
	obj.m_currentBodyIndex = 0
	obj.m_currentFaceIndex = 0
	obj.m_currentHeadIndex = 0
	obj.m_currentMountIndex = 0
	obj.m_bLoadGhost = false
	obj.m_bLoadGunBigSkill = false
    obj.m_bLoadWeaponBigSkill = false
    obj.m_weaponGunIndex = 0
	obj.m_weaponBombIndex = 0
    
	obj.m_running = false
	obj.m_playName = nil
	obj.m_isLoop = false
	obj.m_flipX = false
	obj.m_flipY = false
    obj.m_rotation = 0
    obj.m_pos = {x = 0,y = 0}
    obj.m_scale = {x = 1,y = 1}
    obj.m_loadEffect = false
	obj.m_currentAction = ""
	obj:setArmatureName(obj.m_sAninName,obj.m_bodyIndex)
	return obj
end

function YDBabyAnimation:setArmatureName(sName,_index)
	if self.m_node == nil then return end
	if self.m_running ~= true then return end
	local anchorPoint = {x = self.m_node:getAnchorPoint().x,y = self.m_node:getAnchorPoint().y}
    local position = {x = self.m_node:getPositionX(),y = self.m_node:getPositionY()}
    local index = _index or 1
	local sIndex = self:_formatIndex(tonumber(index))
	self.m_sAninName = sName
    self.m_bodyIndex = tonumber(index)
    local animName = "baby" .. self.m_sAninName .. "_body_" .. sIndex
	
	local pathName = "baby/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
	print(pathName,animName)
	--self.m_node:setConfigFile(spinePathName .. ".json",atlasPathName .. ".atlas")
    self.m_node:setArmatureFile(pathName .. ".xml")
	self.m_node:setPlistFile(pathName .. ".plist")
	self.m_node:setArmatureName(animName)
	self.m_loadEffect = false
    --self.m_node:setGrayRender(true);
	self.m_currentBodyIndex = 0
	self.m_currentFaceIndex = 0
	self.m_currentHeadIndex = 0
	self.m_node:setPositionX(position.x)
    self.m_node:setPositionY(position.y) 
    --self:loadEffect()
end


function YDBabyAnimation:updateAnimAnchor()
    if not self:isMonster() then return end
    local node = self.m_node:getChildNode()
    if node ~= nil then 
        node:setAnchorPoint(GlobalMethod:ccp(0,0))
        node:setPositionY(15)
        node:setScaleX(-1)
    end
    if GDatatab_shape_skins == nil then return end
    if self.m_monsterId == nil then return end
    if GDatatab_shape_skins["id_" .. self.m_monsterId] == nil then return end
    local skins = GDatatab_shape_skins["id_" .. self.m_monsterId]
    local flipX = true
    if skins.flipx ~= nil and skins.flipx == "false" then 
        flipX = false
    end
    local shopScale = 1
    if skins.scale ~= nil then 
        shopScale = skins.scale/100
    end
    local battleScale = 1
    if skins.battle_scale ~= nil then 
        battleScale = skins.battle_scale/100
    end
    if node ~= nil then
        if self.m_bShop ~= true then
            node:setScaleX(battleScale)
            node:setScaleY(battleScale)
        else 
            node:setScaleX(shopScale)
            node:setScaleY(shopScale)
        end 
        if flipX == true then 
            node:setScaleX(node:getScaleX()*-1)
        end
    end
end

function YDBabyAnimation:onEnter(element)
	-- self.m_node:setContentSize(GlobalMethod:CCSize(150,150))
	
end


function YDBabyAnimation:onEnterTransitionDidFinish(element)
	self.m_running = true
	if self.m_bodyIndex > 0 then 
		self:setBody(self.m_bodyIndex)
	end
    self:loadEffect()
	self:setFlipX(self.m_flipX)
	self:setFlipY(self.m_flipY)
    if self.m_pos.x ~= 0 or self.m_pos.y ~= 0 then 
        self:setPosition(self.m_pos)
    end
    if self.m_rotation ~= 0 then 
        self:setRotate(self.m_rotation)
    end
    if self.m_scale.x ~= 1 then 
        self:setScaleX(self.m_scale.x)
    end
    if self.m_scale.y ~= 1 then 
        self:setScaleY(self.m_scale.y)
    end
    if self.m_playName ~= nil then 
		self:play(self.m_playName,self.m_isLoop)
	end
    -- self.m_node:setContentSize(GlobalMethod:CCSize(150,150))
    -- self:updateAnimAnchor()
	-- local node = self.m_node:getChildNode()
	-- if node then 
		-- node:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	-- end
end

function YDBabyAnimation:onExit(element)
	--print("YDBabyAnimation:onExit(element)")
	--self.m_node = nil
    self.m_currentBodyIndex = 0
	self.m_currentFaceIndex = 0
	self.m_currentHeadIndex = 0
    
    for i,v in ipairs(self.m_tLoadPlist)
    do 
        WZDataFile:getInstance():unloadTexturePackFile(v .. ".plist",v .. ".png")
    end
    for i,v in ipairs(self.m_tLoadArmature)
    do 
       if WZDataFile:getInstance().unloadArmatureFile ~= nil then
            WZDataFile:getInstance():unloadArmatureFile(v .. ".xml");
        end
    end
    
    self.m_tLoadArmature = {}
    self.m_tLoadPlist = {}
    self.m_running = false
end
--@brief    判断目前是否是幻化成怪物的模型
function YDBabyAnimation:isMonster() 
    return self.m_isMonster ~= false
end

--@brief    加载人物特效
function YDBabyAnimation:loadEffect()
end

--@brief	设置头的显示索引
--@param	sIndex 索引值
function YDBabyAnimation:setHead(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
    self.m_headIndex = tonumber(sIndex)
    self.m_d_headIndex = tonumber(sIndex)
	if self.m_running ~= true then 
		return
	end
	if self.m_currentHeadIndex == self.m_headIndex then 
		return 
	end    
    local totalHeadName = "baby" .. self.m_sAninName .. "_head_" .. _sIndex

    local path = "baby/" .. self.m_sAninName .. "/" .. _sIndex 
    local pathName = path .. "/" .. totalHeadName
    local existArmature = CheckEffectFile(pathName, true)
    if existArmature then 
    	self:_setHead(sIndex)
    	return 
    end

    self:_setHead(1)

    local downloadInfo = self:getDownloadInfo(_sIndex)
    if downloadInfo == nil then return end 

	DownloadManager:addDownloadTask(3000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,_sIndex,"downloadHeadCallback",self)
end

function YDBabyAnimation:downloadHeadCallback(taskId, extraData, failed)
    WZLog("YDBabyAnimation:downloadHeadCallback",taskId,extraData,failed)
    WZLog("YDBabyAnimation:downloadHeadCallback_1",self.m_d_headIndex)
    WZLog("YDBabyAnimation:downloadHeadCallback_2",failed)
    if failed == 0 then 
		self:_setHead(self.m_d_headIndex)
		self:play(self.m_playName, self.m_isLoop)
    end
end

function YDBabyAnimation:_setHead(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
    self.m_headIndex = tonumber(sIndex)
	if self.m_running ~= true then 
		return
	end
	if self.m_currentHeadIndex == self.m_headIndex then 
		return 
	end    
    local totalHeadName = "baby" .. self.m_sAninName .. "_head_" .. _sIndex

    local path = "baby/" .. self.m_sAninName .. "/" .. _sIndex 
    self:_checkArmature(totalHeadName,_sIndex,path .. "/" .. totalHeadName)

	local bones = {	{["b"] = "baby_" .. self.m_sAninName .. "_head_1",["a"] = "baby" .. self.m_sAninName .. "_head_1"},
					{["b"] = "baby_" .. self.m_sAninName .. "_head_2",["a"] = "baby" .. self.m_sAninName .. "_head_2"},
					{["b"] = "baby_" .. self.m_sAninName .. "_head_3",["a"] = "baby" .. self.m_sAninName .. "_head_3"},}
	
    for i,v in ipairs(bones) do
		local bone = self.m_node:getArmature():getBone(v.b)
        if bone ~= nil then            
            bone = tolua.cast(bone,"CCNode")
            local name = v.a .. "_" ..  _sIndex
            bone:setVisible(true)
            if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(name) ~= nil then
                self.m_node:setDisplayData(0,v.b,name)
            end
            
        end
	end
	self.m_currentHeadIndex = self.m_headIndex
end

function YDBabyAnimation:setMount(_sIndex)
	local sIndex = self:_formatIndex(_sIndex)
	self.m_mountIndex = tonumber(_sIndex)
	if self.m_running ~= true then 
		return
	end
	if self.m_currentMountIndex == self.m_mountIndex then 
		return 
	end
	
	local totalHeadName = "babymount_" .. sIndex --babymount_001
	local path = "baby/mount"
	self:_checkArmature(totalHeadName,sIndex,path .. "/" .. totalHeadName)
	local bones = {	{["b"] = "baby_mount_body",["a"] = "babymount_body_" .. sIndex},
					{["b"] = "baby_mount_head",["a"] = "babymount_head_" .. sIndex},}
	
    for i,v in ipairs(bones) do
		local bone = self.m_node:getArmature():getBone(v.b)
        if bone ~= nil then            
            bone = tolua.cast(bone,"CCNode")
            local name = v.a
            bone:setVisible(true)
            if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(name) ~= nil then
                self.m_node:setDisplayData(0,v.b,name)
            end
        end
	end
	self.m_currentMountIndex = self.m_mountIndex
end
--@brief	设置身体的显示索引
--@param	sIndex 索引值
function YDBabyAnimation:setBody(sIndex,bBoy)
	self.m_bodyIndex = tonumber(sIndex)
	self.m_d_bodyIndex = tonumber(sIndex)
	if self.m_running ~= true then
		return
	end 
	if self.m_currentBodyIndex == self.m_bodyIndex and bBoy == nil then 
		return 
	end 	
	--self.m_bodyIndex = 0
	local _sIndex = self:_formatIndex(sIndex)
	local bodyName = "baby" .. self.m_sAninName .. "_body_" .. _sIndex

    local path = "baby/" .. self.m_sAninName .. "/" .. _sIndex
    local pathName = path .. "/" .. bodyName
    local existArmature = CheckEffectFile(pathName, true)
    if existArmature then 
    	self:_setBody(sIndex, bBoy)
    	return 
    end

    self:_setBody(1, bBoy)
    local downloadInfo = self:getDownloadInfo(_sIndex)
    if downloadInfo == nil then return end 

	DownloadManager:addDownloadTask(3000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,_sIndex,"downloadBodyCallback",self)
end

function YDBabyAnimation:downloadBodyCallback(taskId,extraData,failed)
    WZLog("YDBabyAnimation:downloadBodyCallback",taskId,extraData,failed)
    WZLog("YDBabyAnimation:downloadBodyCallback_1",self.m_d_bodyIndex)
    if failed == 0 then 
		self:_setBody(self.m_d_bodyIndex, bBoy)
		self:play(self.m_playName, self.m_isLoop)
    end
end

function YDBabyAnimation:_setBody(sIndex,bBoy)
	self.m_bodyIndex = tonumber(sIndex)
	if self.m_running ~= true then
		return
	end 
	if self.m_currentBodyIndex == self.m_bodyIndex and bBoy == nil then 
		return 
	end 	
	--self.m_bodyIndex = 0
	local _sIndex = self:_formatIndex(sIndex)
	if bBoy ~= nil then 
		if bBoy == true then
			self.m_sAninName = "boy"
			self.m_bBoy = true
		else 
			self.m_sAninName = "girl"
			self.m_bBoy = false
		end
	end
	self:setArmatureName(self.m_sAninName,_sIndex)
	
	if self.m_weaponGunIndex ~= nil and self.m_weaponGunIndex > 0 then
		self:setWeaponGun(self.m_weaponGunIndex)
	end 
	
	if self.m_weaponBombIndex ~= nil and self.m_weaponBombIndex > 0 then 
		self:setWeaponBomb(self.m_weaponBombIndex)
	end 

	if self.m_faceIndex ~= nil and self.m_faceIndex > 0 then 
		self.m_currentFaceIndex = 0
		self:setFace(self.m_faceIndex)
	end 
	
	if self.m_headIndex ~= nil and self.m_headIndex > 0 then 
		self.m_currentHeadIndex = 0
		self:setHead(self.m_headIndex,self.m_headRanSeIndex)
	end 
	
	if self.m_mountIndex ~= nil and self.m_mountIndex > 0 then 
		self.m_currentMountIndex = 0
		self:setMount(self.m_mountIndex)
	end
	
	if self.m_bLoadGhost == true then self:setGhost() end
    if self.m_bLoadGunBigSkill == true then self:setGunBigSkill() end
    if self.m_bLoadWeaponBigSkill == true then self:setWeaponBigSkill() end
	self.m_currentBodyIndex = self.m_bodyIndex
end

function YDBabyAnimation:setFace(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
    self.m_faceIndex = tonumber(sIndex)
    self.m_d_faceIndex = tonumber(sIndex)
	if self.m_running ~= true then
		return
	end 
    local faceName = "baby" .. self.m_sAninName .. "_face_" .. _sIndex

    local path = "baby/" .. self.m_sAninName .. "/" .. _sIndex
    local pathName = path .. "/" .. faceName
    local existArmature = CheckEffectFile(pathName, true)
    if existArmature then 
    	self:_setFace(sIndex)
    	return 
    end

    self:_setFace(1)
    local downloadInfo = self:getDownloadInfo(_sIndex)
    if downloadInfo == nil then return end 

	DownloadManager:addDownloadTask(3000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,_sIndex,"downloadFaceCallback",self)
end

function YDBabyAnimation:downloadFaceCallback(taskId,extraData,failed)
    WZLog("YDBabyAnimation:downloadFaceCallback",taskId,extraData,failed)
    WZLog("YDBabyAnimation:downloadFaceCallback_1",self.m_d_faceIndex)
    if failed == 0 then 
		self:_setFace(self.m_d_faceIndex)
		self:play(self.m_playName, self.m_isLoop)
    end
end

function YDBabyAnimation:_setFace(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
    self.m_faceIndex = tonumber(sIndex)
	if self.m_running ~= true then
		return
	end 
    local faceName = "baby" .. self.m_sAninName .. "_face_" .. _sIndex

    local path = "baby/" .. self.m_sAninName .. "/" .. _sIndex
    self:_checkArmature(faceName,_sIndex,path .. "/" .. faceName)
	local boneName = "baby_" .. self.m_sAninName .. "_face"
	local bone = self.m_node:getArmature():getBone(boneName)
	if bone ~= nil then            
		bone = tolua.cast(bone,"CCNode")
		local name = faceName
		bone:setVisible(true)
		if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(name) ~= nil then
			self.m_node:setDisplayData(0,boneName,name)
		end
	end
    self.m_currentFaceIndex = self.m_faceIndex
end


--@brief	设置头的显示索引
--@param	sActionName 动作名称 例如: walk wait run等
--@param	bLoop 是否循环播放
function YDBabyAnimation:play(sActionName,bLoop)
--    WZLog("YDBabyAnimation:play", tostring(self:getAnimNode()), sActionName, tostring(bLoop))
    --如果处于被冰冻状态，不换动画

	self.m_playName = sActionName
	self.m_isLoop = bLoop
	if self.m_running ~= true then	
		return
	end
	local nLoop = 0
	if bLoop then 
		nLoop = 1
	end

	local config = g_YDBabyAnimation_Configs[self.m_sAninName]
	local actionInfo = config.action[sActionName]

	self:_playIndex(actionInfo["zDefault"],"",nLoop)
	
	self:_playIndex(actionInfo["face"],"baby_" .. self.m_sAninName .. "_face",nLoop)
	self:_playIndex(actionInfo["head"],"baby_" .. self.m_sAninName .. "_head_1",nLoop)
	self:_playIndex(actionInfo["head"],"baby_" .. self.m_sAninName .. "_head_2",nLoop)
	self:_playIndex(actionInfo["head"],"baby_" .. self.m_sAninName .. "_head_3",nLoop)
	if sActionName == "ride" then 
		self:_playIndex(actionInfo["mount_body"],"baby_mount_body",nLoop)
		self:_playIndex(actionInfo["mount_head"],"baby_mount_head",nLoop)
	end
	self.m_currentAction = sActionName
end


function YDBabyAnimation:_playEffect(sActionName,bLoop)
	-- local config = g_YDBabyAnimation_Configs[self.m_sAninName]
	-- local actionInfo = config.action[sActionName]
	-- if actionInfo == nil then return end
	-- local nLoop = 0
	-- if bLoop == true then nLoop = 1 end
	-- local frontName = self.m_sAninName .. "_effect_1"
	-- local backName = self.m_sAninName .. "_effect_2"
	-- local actionName = actionInfo["effect"]
	-- if actionName == nil then return end 
	-- local bodyNode = self:_getBodyNode()
	-- self:_playSpineAction(bodyNode:getBindNode(frontName),actionName,bLoop)
	-- self:_playSpineAction(bodyNode:getBindNode(backName),actionName,bLoop)
end


--@brief	获取骨骼动画的节点
--@return   返回绑定的骨骼动画实例
function YDBabyAnimation:getAnimNode()
	return self.m_node
end

--@brief    判断当前是否在播放某个动画
--@param    sActionName 动画名字
--@return   #1, true 在播放 false 没有
function YDBabyAnimation:isPlaying(sActionName)
    if self.m_running ~= true or self.m_node == nil then 
        return false
    end
    return self.m_currentAction == sActionName
    -- if self:isMonster() then
        -- local monsterAnim = self:getMonsterAnimName(sActionName)
        -- local animId = self.m_node:getAnimationName()
        -- return monsterAnim == animId
    -- end
	-- local config = g_YDBabyAnimation_Config[self.m_sAninName]
	-- local actionInfo = config.action[sActionName]
	-- if actionInfo == nil then return false end 
	-- if actionInfo["zDefault"] == nil then return false end 
	-- if self.m_hasMount then
		-- if self.m_currentAction == "ride" or self.m_currentAction == "mount_wait" or self.m_currentAction == "mount_show" then 
			-- return self.m_node:getAnimationName() == actionInfo["mount"]
		-- end
		-- local bodyNode = self:_getBodyNode()
	
		-- return bodyNode:getCurrentAnimationName() == actionInfo["zDefault"]
	-- else 
		-- return self.m_node:getAnimationName() == actionInfo["zDefault"]
	-- end
end

--@brief 判断当前动画是否播放结束
--@return #1, true 播放结束 false 正在播放中
function YDBabyAnimation:isCurrentAnimationDone()
    if self.m_running ~= true then 
        return true
    end
    
    if self.m_currentBone == nil then
		return self.m_node:isCurrentDone("")
	else
		return self.m_node:isCurrentDone(self.m_currentBone)
	end
end

--@brief 	X轴翻转
--@param	bValue 是否X轴翻转
function YDBabyAnimation:setFlipX(bValue)
    --self.m_node:setFlipX(bValue)
	
	self.m_flipX = bValue
	if self.m_running ~= true then 
        return
    end
	if bValue == true  and self.m_node:getScaleX() > 0 then 
		self.m_node:setScaleX(0-self.m_node:getScaleX())
	end 
	if bValue ~= true  and self.m_node:getScaleX() < 0 then 
		self.m_node:setScaleX(0-self.m_node:getScaleX())
	end
    --self:loadParticle()
end

--@brief 	判断是否X轴翻转
--@return	true X轴翻转 false 没有翻转
function YDBabyAnimation:isFlipX()
    if self.m_running ~= true then 
        return self.m_flipX
    end
    -- if self:isMonster() then 
        -- return self.m_node:getScaleX() > 0
    -- end
	return self.m_node:getScaleX() < 0
end

--@brief 	Y轴翻转
--@param	bValue 是否Y轴翻转
function YDBabyAnimation:setFlipY(bValue)
	self.m_flipY = bValue
    if self.m_running ~= true then 
        return
    end
	self.m_node:setFlipY(bValue)
end

--@brief 	判断是否Y轴翻转
--@return	true Y轴翻转 false 没有翻转
function YDBabyAnimation:isFlipY()
    if self.m_running ~= true then 
        return self.m_flipY
    end
	if self.m_node:getArmature() == nil then return false end
	return self.m_node:getArmature():getScaleY() < 0
end

--@brief 	设置X轴缩放
--@param	nScale 缩放值
function YDBabyAnimation:setScaleX(nScale)
    if nScale == nil then 
        return
    end
    self.m_scale.x = nScale
    if self.m_running ~= true then 
        return
    end
    local baseScale = 1
    if self.m_node:getScaleX() < 0 then
		self.m_node:setScaleX(nScale*baseScale * -1)
	else
		self.m_node:setScaleX(nScale*baseScale)
	end
end

--@brief	设置Y轴缩放
--@param	nScale  缩放值
function YDBabyAnimation:setScaleY(nScale)
    if nScale == nil then 
        return;
    end
    self.m_scale.y = nScale
    if self.m_running ~= true then 
        return
    end
    local baseScale = 1
	self.m_node:setScaleY(nScale*baseScale)
end

function YDBabyAnimation:setScale(nScale)
	self:setScaleX(nScale)
	self:setScaleY(nScale)
end

--@brief	设置坐标值
--@param	tPos	坐标点的值可以通过x y访问
function YDBabyAnimation:setPosition(tPos)
    self.m_pos.x = tPos.x
    self.m_pos.y = tPos.y
    if self.m_running ~= true then 
        return
    end
    self.m_node:setUseAbsCoordinate(true)
    self.m_node:setAbsPosition(GlobalMethod:ccp(tPos.x,tPos.y))
end


--@brief	获取坐标值
--@param	#1, 返回坐标值 格式是{x = 0,y = 0}
function YDBabyAnimation:getPosition()
	local pos = {x = 0, y = 0}
    if self.m_running ~= true then
        return self.m_pos
    end
	pos.x , pos.y = self.m_node:getPosition()
	return pos
end

--@brief	设置旋转角度
--@param	nAngle 旋转角度
function YDBabyAnimation:setRotate(nAngle)
    --WZLog("BattleAnimation:setRotate", self.m_node:getArmature(), self.m_bUseDragonBone, nAngle)
	self.m_rotation = nAngle
    if self.m_rotation > 360 then 
        self.m_rotation = self.m_rotation - 360
    end
    if self.m_rotation < -360 then 
        self.m_rotation = self.m_rotation + 360
    end
    if self.m_running == true then	
		self.m_node:setRotation(self.m_rotation)
	end
end

--@brief    获得旋转角度
--@return   #1, 返回旋转角度
function YDBabyAnimation:getRotate()
    if self.m_running ~= true then	
		return self.m_rotation
	end
    return self.m_node:getRotationX()
end

function YDBabyAnimation:getActionName(sAnimName,isShop)
	--if sAnimName == nil or g_YDBabyAnimation_Config[sAnimName] == nil then return {} end 

	local action = g_YDBabyAnimation_Configs[sAnimName].action
	if action == nil then return {} end 
	local actionNames = {}
	for k,v in pairs(action) do
		table.insert(actionNames,k)
	end 
	return actionNames
end

--@brief   删除节点  如果节点已经加入场景了
--@param   bValue 是否移除节点
function YDBabyAnimation:removeFromParentAndCleanup(bValue)
    if self.m_running ~= true then	
		return
	end
    self.m_node:removeFromParentAndCleanup(bValue)
end

-------------------------------------私有方法模块Begin--------------------------------------

function YDBabyAnimation:_getDisplayName(sBone,sIndex)
	if sBone == nil or sIndex == nil then 
		return nil
	end 
	local str_tmp = string.reverse(sBone)
	local bone = sBone
	if string.find(str_tmp, "kcab_") == 1 then
		local length = string.len(sBone)
		bone = string.sub(sBone, 1,length-5)
	end
	local name = bone .. "_" .. sIndex
	return name
end

function YDBabyAnimation:_changeSpineWeaponDisplay(sName,sIndex)
end

function YDBabyAnimation:_changeBodyDisplay(sName,sIndex)
	local displayName = self:_getDisplayName(sName,sIndex)
	if displayName == nil then return end 
	displayName = self.m_sAninName .. "_parts-" .. displayName .. ".png"
	local name = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. self.m_sAninName .. "_body_" .. sIndex
	
	if self:_contains(self.m_tLoadArmature,name) == false then 
		CCArmatureDataManager:sharedArmatureDataManager():addSpriteFrameFromFile(name .. ".plist",name .. ".png")
		table.insert(self.m_tLoadArmature,name);
	end 
	self.m_node:setDisplayData(0,sName,displayName)
end

function YDBabyAnimation:_contains(tArr,sValue)
	for i,v in ipairs(tArr) do 
		if v == sValue then 
			return true
		end 
	end 
	return false
end

function YDBabyAnimation:_formatIndex(sIndex)
	local index = tonumber(sIndex)
	return string.format("%03d",sIndex)	
end 


function YDBabyAnimation:_playIndex(nIndex,sBone,nLoop)
	if self.m_running ~= true then return end 
	
	local armature = self.m_node:getArmature()
	if armature == nil then return end
	
	if sBone ~= nil and string.len(sBone) ~= 0 then
		local bone = armature:getBoneRecursively(sBone)
		if bone == nil then return end
		bone = tolua.cast(bone,"CCBone")
		armature = bone:getChildArmature()
	end
	if armature == nil then return end
	armature:getAnimation():playByIndex(nIndex,-1,-1,nLoop);
end 


function YDBabyAnimation:_getChildBone(sBone)
	if self.m_running ~= true then return nil end 
	local armature = self.m_node:getArmature()
	if armature == nil then return nil end
	
	if sBone ~= nil and string.len(sBone) ~= 0 then
		local bone = armature:getBoneRecursively(sBone)
		if bone == nil then return nil end
		bone = tolua.cast(bone,"CCBone")
		return bone
	end
	return nil
end

function YDBabyAnimation:_playSpineAction(node,sActionName,bLoop)
	if node == nil then return end
	local spine = tolua.cast(node,"SkeletonAnimation")
	if spine == nil then return end
	spine:play(sActionName,bLoop)
end 

function YDBabyAnimation:_getBodyNode()
	if not self.m_hasMount then 
		return self.m_node
	end
	local node = self.m_node:getBindNode("ride_node")
	if node == nil then return nil end 
	return tolua.cast(node,"SkeletonAnimation")
end

function YDBabyAnimation:pause()
    if self.m_running ~= true then	
		return
	end
    self.m_bIsStopFaceAndWindAnim = true
    self:getAnimNode():pause()
end

function YDBabyAnimation:resume()
    if self.m_running ~= true then	
		return
	end
    self.m_bIsStopFaceAndWindAnim = false
    self:getAnimNode():resume()
end

function YDBabyAnimation:_checkArmature(sName,sIndex,sPathName)
	
	local pathName = ""
	if sPathName == nil then 
		pathName = "baby/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. sName
	else 
		pathName = sPathName
	end 
	CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo(pathName .. ".png",pathName .. ".plist",pathName .. ".xml")
	if self.m_node and self.m_node.addManageTextureFile ~= nil then 
        self.m_node:addManageTextureFile(pathName .. ".png")
    end
    table.insert(self.m_tLoadArmature,sName)
    table.insert(self.m_tLoadPlist,pathName)
end

--@brief	设置枪的显示索引
--@param	sIndex 索引值
function YDBabyAnimation:setWeaponGun(sIndex)
	--self:_changeDisplay("weapon_gun",sIndex)
	self.m_weaponGunIndex = tonumber(sIndex)
	if self.m_running ~= true then
		return
	end 
	
	self:_setArmatureWeaponGun(sIndex)
end

function YDBabyAnimation:_setArmatureWeaponGun(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local config = g_YDBabyAnimation_Configs[self.m_sAninName]
	local bones = config.bone
	local bone = bones["weapon_gun"]
	for i,v in ipairs(bone) do 
		self:_changeWeaponDisplay(v,_sIndex)
	end 
	
	if self.m_node == nil or self.m_node:getArmature() == nil then 
		return 
	end 
	
	for i,v in ipairs(bone) do 
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		if bone ~= nil then 
			bone:setVisible(true)  
			bone:setScale(0.7)
		end 
	end 
	bone = bones["weapon_bomb"]
	for i,v in ipairs(bone) do 
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		if bone ~= nil then bone:setVisible(false)  end 
	end 	
end

function YDBabyAnimation:_changeWeaponDisplay(sName,sIndex)
	local displayName = self:_getWeaponDisplayName(sName,sIndex)
	WZLog("YDBabyAnimation:_changeWeaponDisplay", displayName)
	if displayName == nil then return end 
	displayName = "player/combat" .. self.m_sAninName .. "/weapon/combat" .. self.m_sAninName .. "_parts-" .. displayName .. ".png"
	self.m_node:setDisplayData(0,sName,displayName)
end 

--@brief	设置炸弹的显示索引
--@param	sIndex 索引值
function YDBabyAnimation:setWeaponBomb(sIndex)
	self.m_weaponBombIndex = tonumber(sIndex)
	if self.m_running ~= true then 
		return
	end

	self:_setArmatureWeaponBomb(sIndex)
end

function YDBabyAnimation:_setArmatureWeaponBomb(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	local config = g_YDBabyAnimation_Configs[self.m_sAninName]
	local bones = config.bone
	local bone = bones["weapon_bomb"]
	for i,v in ipairs(bone) do 
		self:_changeWeaponDisplay(v,_sIndex)
	end 
	
	if self.m_node == nil or self.m_node:getArmature() == nil then 
		return 
	end 
	
	for i,v in ipairs(bone) do 
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		if bone ~= nil then 
			bone:setVisible(true)  
			bone:setScale(0.7)
		end
	end 
	bone = bones["weapon_gun"]
	for i,v in ipairs(bone) do 
		local bone = self.m_node:getArmature():getBone(v)
		bone = tolua.cast(bone,"CCNode")
		if bone ~= nil then bone:setVisible(false)  end 
	end 
end

function YDBabyAnimation:_getWeaponDisplayName(sBone,sIndex)
	if sBone == nil or sIndex == nil then 
		return nil
	end 
	local bone = sBone
	local nStart, nEnd = string.find(bone, "baby_")
	WZLog("YDBabyAnimation:_getWeaponDisplayName", bone)
	if nStart and nStart > 0 then
		local length = string.len(sBone)
		bone = string.gsub(sBone, "baby_", "combat")
	end
	WZLog("YDBabyAnimation:_getWeaponDisplayName", bone, sIndex)
	local name = bone .. "_" .. sIndex
	return name
end

function YDBabyAnimation:getDownloadInfo(sIndex)
	WZLog("YDBabyAnimation:getDownloadInfo", sIndex)
	local path = CCFileUtils:sharedFileUtils():getTmpWritablePath().."DressAniDownloadConfig.xml"
    local ConfigExist = WZDataFile:getInstance():checkFileExist(path)
	if ConfigExist then
		local xmlDoc = WZDataFile:getInstance():createXmlDocument(path)
		--没有下载配置文件成功，直接返回
		if not xmlDoc then return nil end
    	local rootElement = xmlDoc:getRootElement()
    	local xmlName = "File"
    	local element = rootElement:findChildElement(xmlName)
		while element do
    	    local index = element:attributeString("index")
    	    local sex = element:attributeString("sex")
		--	WZLog("YDBabyAnimation:getDownloadInfo_1", index, index == tostring(sIndex), sex == self.m_sAninName)
			if index == tostring(sIndex) and sex == self.m_sAninName then
				local downloadInfo = {}
    	        downloadInfo.url = element:attributeString("url")
    	        downloadInfo.md5 = element:attributeString("md5")
    	        WZLog("下载时装配置",downloadInfo.url,downloadInfo.md5,index)
				return downloadInfo
			end
    	    element = element:nextSiblingElement(xmlName)
    	end
	end
	return nil
end