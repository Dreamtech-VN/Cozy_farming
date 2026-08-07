--YDPlayerHeadAnimation.lua
--@brief	人物头像动画封装 主要是为了换装方便
--@date  	2016/04/07
--@author 	TaoYinqing
--@note 	人物头像动画封装对象
YDPlayerHeadAnimation = {
	m_sAninName = nil,  		--动画名字
	m_tLoadArmature = nil, 		--额外加载的骨骼动画名字
    m_tLoadPlist = nil
}

local g_YDPlayerHeadAnimation_Config = {
	combatboy = {
		action = {
			["avatar"]={zDefault=0,combatboy_head_1=1,combatboy_head_2=1,combatboy_head_3=1,combatboy_face=24},
		},
		bone = {
			head = {"combatboy_head_1","combatboy_head_2","combatboy_head_3"},
			face = {"combatboy_face"},
		}
	},
	combatgirl = {
		action = {
			["avatar"]={zDefault=0,combatgirl_head_1=1,combatgirl_head_2=1,combatgirl_head_3=1,combatgirl_face=24,combatgirl_clothes=0,combatgirl_wing_R=1,combatgirl_wing_L=1},
		},
		bone = {
			head = {"combatgirl_head_1","combatgirl_head_2","combatgirl_head_3"},
			face = {"combatgirl_face"},
		}
	}
}

-------------------------------------公有方法模块Begin--------------------------------------


--@brief	创建骨骼动画实例
--@param 	bBoy  是否是男孩
--return    新的实例
function YDPlayerHeadAnimation:createAnimation(bBoy,bMonster)
	local obj = {}
	setmetatable(obj,{__index = YDPlayerHeadAnimation})
	if bBoy == true then 
		obj.m_sAninName = "combatboy"
	else 
		obj.m_sAninName = "combatgirl"
	end
    obj.m_isMonster = bMonster
	obj.m_tLoadArmature = {}
    obj.m_tLoadPlist = {}
    if obj.m_isMonster == nil then 
        obj.m_isMonster = false
    end
    if obj.m_isMonster ~= false then 
        obj.m_node = WZUIImage:create()
    else
        obj.m_node = WZArmature:create()
    end
	--obj.m_node = WZArmature:create()
	--obj.m_node:setVisible(false)
    
	--obj.m_node:setArmatureFile("player/" .. obj.m_sAninName .. "/" .. obj.m_sAninName .. ".xml")	
	obj.m_node:setUseOriginSize(true)
	obj.m_node:setLuaObjectIndex(obj)
    --obj.m_node:setDrawElementInfo(true)
    --obj.m_node:setContentSize(CCSizeMake(150,150))
    if obj.m_node.setUseABSSize ~= nil then 
        obj.m_node:setUseABSSize(true)
        obj.m_node:setAbsSize(150,150)
    else
        obj.m_node:setContentSize(CCSizeMake(150,150))
    end
	obj.m_faceIndex = 2
	obj.m_headIndex = 2
    obj.m_headRanSeIndex = 0
	obj.m_currentFaceIndex = 0
	obj.m_currentHeadIndex = 0
    obj.m_currentHeadRanSeIndex = 0
    
	obj.m_running = false
	obj.m_flipX = false
	obj.m_flipY = false
	obj:setArmatureName(obj.m_sAninName,obj.m_headIndex,obj.m_headRanSeIndex)
	
	return obj
end

function YDPlayerHeadAnimation:setMonsterId(sId)
    if sId == nil or "" == sId then 
        return 
    end
    self.m_monsterId = "" .. sId
    if not self:isMonster() then return end
    if GDatatab_shape_skins == nil then return end
    if GDatatab_shape_skins["id_" .. self.m_monsterId] == nil then return end
    local skins = GDatatab_shape_skins["id_" .. self.m_monsterId]
    local file = "battle/head/" .. skins.head .. ".png"
    self.m_node:setFile(file)
    self.m_node:setUseOriginSize(true)
end

function YDPlayerHeadAnimation:setArmatureName(sName,_index,_ranSeIndex)
	if self.m_node == nil then return end
	if self.m_running ~= true then return end
    if self:isMonster() then return end
	local anchorPoint = {x = self.m_node:getAnchorPoint().x,y = self.m_node:getAnchorPoint().y}
    local position = {x = self.m_node:getPositionX(),y = self.m_node:getPositionY()}
    local index = _index or 1
    local ranSeIndex = _ranSeIndex or 0
	local sIndex = self:_formatIndex(tonumber(index))
	self.m_sAninName = sName --combatboy_head_001
    self.m_headRanSeIndex = tonumber(ranSeIndex)
	local animName = self.m_sAninName .. "_head_" .. sIndex 
    if self.m_headRanSeIndex > 0 then 
        animName = animName .. "_hs" .. self:_formatIndex(self.m_headRanSeIndex)
    end
	local path = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
	self.m_node:setArmatureFile(path .. ".xml")	
	self.m_node:setArmatureName(animName)
	self.m_currentFaceIndex = 0
	self.m_currentHeadIndex = tonumber(_index)
    self.m_currentHeadRanSeIndex = self.m_headRanSeIndex
    self.m_node:setAnchorPoint(ccp(anchorPoint.x,anchorPoint.y))
    self.m_node:setPositionX(position.x)
    self.m_node:setPositionY(position.y) 
end


function YDPlayerHeadAnimation:onEnter(element)
	self.m_running = true
    if not self:isMonster() then 
        self.m_node:setContentSize(CCSizeMake(150,150))
    end
end


function YDPlayerHeadAnimation:onEnterTransitionDidFinish(element)
	
    if self.m_headIndex ~= nil and  self.m_headIndex > 0 then 
		self:setHead(self.m_headIndex,self.m_headRanSeIndex)
	end 
	self:setFlipX(self.m_flipX)
	self:setFlipY(self.m_flipY)
    if self.m_playName ~= nil then 
		self:play(self.m_playName,self.m_isLoop)
	end
end

function YDPlayerHeadAnimation:onExit(element)
	--print("YDPlayerAnimation:onExit(element)")
	--self.m_node = nil
	self.m_currentFaceIndex = 0
	self.m_currentHeadIndex = 0
    
    for i,v in ipairs(self.m_tLoadPlist)
    do 
        WZDataFile:getInstance():unloadTexturePackFile(v .. ".plist",v .. ".png")
        if WZDataFile:getInstance().unloadArmatureFile ~= nil then
            WZDataFile:getInstance():unloadArmatureFile(v .. ".xml");
        end 
    end
    
    self.m_tLoadArmature = {}
    self.m_tLoadPlist = {}
    self.m_running = false
end

--@brief    判断目前是否是幻化成怪物的模型
function YDPlayerHeadAnimation:isMonster() 
    return self.m_isMonster ~= false
end

function YDPlayerHeadAnimation:setHead(nIndex, sRanSeIndex_)
	WZLog("YDPlayerHeadAnimation:setHead", nIndex, sRanSeIndex_)
    local sRanSeIndex = sRanSeIndex_ or 0
    self.m_headRanSeIndex = tonumber(sRanSeIndex)
	self.m_headIndex = tonumber(nIndex)
	self.m_d_headIndex = tonumber(nIndex)

    local sIndex = YDPlayerAnimation:_formatIndex(tonumber(nIndex))
    local animName = self.m_sAninName .. "_head_" .. sIndex
    local pathName = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
    local existArmature = false 
    if self.m_headRanSeIndex > 0 then 
    	local totalHeadName = pathName .. "_hs" .. YDPlayerAnimation:_formatIndex(self.m_headRanSeIndex)
    	existArmature = CheckEffectFile(pathName, true)
    else
    	existArmature = CheckEffectFile(pathName, true)
    end
    if existArmature then 
        WZLog("YDPlayerHeadAnimation:setHead exist",nIndex)
		self:_setHead(nIndex, sRanSeIndex_)
        return
    end
    WZLog("YDPlayerHeadAnimation:setHead not exist",nIndex) 
	self:_setHead(11, 0)

	local downloadInfo = self:getDownloadInfo(sIndex)
    if downloadInfo == nil then return end 

	DownloadManager:addDownloadTask(nIndex,downloadInfo.url,downloadInfo.md5,sIndex,"downloadHeadCallback",self)
end

function YDPlayerHeadAnimation:downloadHeadCallback(taskId,extraData,failed)
    print("YDPlayerHeadAnimation:downloadHeadCallback",taskId,extraData,failed)
    if failed == 0 then 
		self:_setHead(self.m_d_headIndex, self.m_headRanSeIndex)
    end
end

--@brief	设置头的显示索引
--@param	sIndex 索引值
function YDPlayerHeadAnimation:_setHead(sIndex,sRanSeIndex_)
	local _sIndex = self:_formatIndex(sIndex) 
    local sRanSeIndex = sRanSeIndex_ or 0
	self.m_headIndex = tonumber(sIndex)
    self.m_headRanSeIndex = tonumber(sRanSeIndex)
	if self.m_running ~= true then
		return
	end
    if self:isMonster() then return end
	if self.m_currentHeadIndex == self.m_headIndex and self.m_currentHeadRanSeIndex == self.m_headRanSeIndex then 
		return 
	end 
	self:setArmatureName(self.m_sAninName,_sIndex,sRanSeIndex)
    
    if self.m_faceIndex ~= nil and self.m_faceIndex > 0 then 
		self.m_currentFaceIndex = 0
		self:setFace(self.m_faceIndex)
	end 
       
    self.m_currentHeadIndex = self.m_headIndex
    self.m_currentHeadRanSeIndex = self.m_headRanSeIndex
end

function YDPlayerHeadAnimation:setFace(nIndex)
	WZLog("YDPlayerHeadAnimation:setFace", nIndex)
	self.m_faceIndex = tonumber(nIndex)
	self.m_d_faceIndex = tonumber(nIndex)

    local sIndex = YDPlayerAnimation:_formatIndex(tonumber(nIndex))
    local animName = self.m_sAninName .. "_face_" .. sIndex
    local pathName = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. animName
    local existArmature = CheckEffectFile(pathName, true)
    if existArmature then 
        WZLog("YDPlayerHeadAnimation:setFace exist",nIndex)
		self:_setFace(nIndex)
        return
    end
    WZLog("YDPlayerHeadAnimation:setFace not exist",nIndex) 
	self:_setFace(11)

	local downloadInfo = self:getDownloadInfo(sIndex)
    if downloadInfo == nil then return end 

	DownloadManager:addDownloadTask(nIndex,downloadInfo.url,downloadInfo.md5,sIndex,"downloadFaceCallback",self)
end

function YDPlayerHeadAnimation:downloadFaceCallback(taskId,extraData,failed)
    print("YDPlayerHeadAnimation:downloadFaceCallback",taskId,extraData,failed)
    if failed == 0 then 
		self:_setFace(self.m_d_faceIndex)
    end
end

--@brief	设置脸谱的显示索引
--@param	sIndex 索引值
function YDPlayerHeadAnimation:_setFace(sIndex)
	local _sIndex = self:_formatIndex(sIndex)
	self.m_faceIndex = tonumber(sIndex)
	if self.m_running ~= true then 
		return
	end
    if self:isMonster() then return end
	if self.m_currentFaceIndex == self.m_faceIndex then 
		return
	end 
	
	self:_changeDisplay("face",_sIndex)
	self.m_currentFaceIndex = self.m_faceIndex
end

--@brief	设置头的显示索引
--@param	sActionName 动作名称 例如: walk wait run等
--@param	bLoop 是否循环播放
function YDPlayerHeadAnimation:play(sActionName,bLoop)
    WZLog("YDPlayerAnimation:play", tostring(self:getAnimNode()), sActionName, tostring(bLoop))

    --如果处于被冰冻状态，不换动画
    if self.m_bIsStopFaceAndWindAnim then
        return
    end

	self.m_playName = sActionName
	self.m_isLoop = bLoop
	if self.m_running ~= true then	
		return
	end
    if self:isMonster() then return end    
	local nLoop = 0
	if bLoop == true then nLoop = 1 end
	--self.m_playName = nil
	--self.m_isLoop = false
	local config = g_YDPlayerHeadAnimation_Config[self.m_sAninName]
	local actionInfo = config.action[sActionName]
	if actionInfo == nil then return end 
	if actionInfo["zDefault"] == nil then return end 
	
	self:_playIndex(actionInfo["zDefault"],"",nLoop)
    for k,v in pairs(actionInfo) do
		if k ~= "zDefault" then
			self:_playIndex(v,k,nLoop)
		end
	end 
end

--@brief	获取骨骼动画的节点
--@return   返回绑定的骨骼动画实例
function YDPlayerHeadAnimation:getAnimNode()
	return self.m_node
end

--@brief    判断当前是否在播放某个动画
--@param    sActionName 动画名字
--@return   #1, true 在播放 false 没有
function YDPlayerHeadAnimation:isPlaying(sActionName)
    if self:isMonster() then return true end
	local config = g_YDPlayerHeadAnimation_Config[self.m_sAninName]
	local actionInfo = config.action[sActionName]
	if actionInfo == nil then return end 
	if actionInfo["zDefault"] == nil then return end 
	local index = actionInfo["zDefault"]
	return self.m_node:isPlayIndex(index)
end

--@brief 判断当前动画是否播放结束
--@return #1, true 播放结束 false 正在播放中
function YDPlayerHeadAnimation:isCurrentAnimationDone()
    if self:isMonster() then return true end
    if self.m_currentBone == nil then
		return self.m_node:isCurrentDone("")
	else
		return self.m_node:isCurrentDone(self.m_currentBone)
	end
end

--@brief 	X轴翻转
--@param	bValue 是否X轴翻转
function YDPlayerHeadAnimation:setFlipX(bValue)
    --self.m_node:setFlipX(bValue)
	
	self.m_flipX = bValue
	
	if bValue == true  and self.m_node:getScaleX() > 0 then 
		self.m_node:setScaleX(0-self.m_node:getScaleX())
	end 
	if bValue ~= true  and self.m_node:getScaleX() < 0 then 
		self.m_node:setScaleX(0-self.m_node:getScaleX())
	end
end

--@brief 	判断是否X轴翻转
--@return	true X轴翻转 false 没有翻转
function YDPlayerHeadAnimation:isFlipX()
	return self.m_node:getScaleX() < 0
end

--@brief 	Y轴翻转
--@param	bValue 是否Y轴翻转
function YDPlayerHeadAnimation:setFlipY(bValue)
	self.m_flipY = bValue
	self.m_node:setFlipY(bValue)
end

--@brief 	判断是否Y轴翻转
--@return	true Y轴翻转 false 没有翻转
function YDPlayerHeadAnimation:isFlipY()
	if self.m_node:getArmature() == nil then return false end
	return self.m_node:getArmature():getScaleY() < 0
end

--@brief 	设置X轴缩放
--@param	nScale 缩放值
function YDPlayerHeadAnimation:setScaleX(nScale)
    if self.m_node:getScaleX() < 0 then
		self.m_node:setScaleX(nScale * -1)
	else
		self.m_node:setScaleX(nScale)
	end
end

--@brief	设置Y轴缩放
--@param	nScale  缩放值
function YDPlayerHeadAnimation:setScaleY(nScale)
	self.m_node:setScaleY(nScale)
end

function YDPlayerHeadAnimation:setScale(nScale)
	self:setScaleX(nScale)
	self:setScaleY(nScale)
end

--@brief	设置坐标值
--@param	tPos	坐标点的值可以通过x y访问
function YDPlayerHeadAnimation:setPosition(tPos)
    self.m_node:setUseAbsCoordinate(true)
    self.m_node:setAbsPosition(ccp(tPos.x,tPos.y))
end


--@brief	获取坐标值
--@param	#1, 返回坐标值 格式是{x = 0,y = 0}
function YDPlayerHeadAnimation:getPosition()
	local pos = {x = 0, y = 0}
	pos.x , pos.y = self.m_node:getPosition()
	return pos
end

--@brief	设置旋转角度
--@param	nAngle 旋转角度
function YDPlayerHeadAnimation:setRotate(nAngle)
    --WZLog("BattleAnimation:setRotate", self.m_node:getArmature(), self.m_bUseDragonBone, nAngle)
	 self.m_node:setRotation(nAngle)
end

--@brief    获得旋转角度
--@return   #1, 返回旋转角度
function YDPlayerHeadAnimation:getRotate()
    return self.m_node:getRotation()
end

function YDPlayerHeadAnimation:getActionName(sAnimName)
	if sAnimName == nil or g_YDPlayerHeadAnimation_Config[sAnimName] == nil then return {} end 
	local action = g_YDPlayerHeadAnimation_Config[sAnimName].action
	if action == nil then return {} end 
	local actionNames = {}
	for k,v in pairs(action) do
		table.insert(actionNames,k)
	end 
	return actionNames
end

-------------------------------------私有方法模块Begin--------------------------------------

function YDPlayerHeadAnimation:_getDisplayName(sBone,sIndex)
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

function YDPlayerHeadAnimation:_checkArmature(sName,sIndex,sPathName)
	--if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(sName) ~= nil then 
	--	return 
	--end
	-- if self:_contains(self.m_tLoadArmature,sName) == true then 
		-- return
	-- end
	
	local pathName = ""
	if sPathName == nil then 
		pathName = "player/" .. self.m_sAninName .. "/" .. sIndex .. "/" .. sName
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

function YDPlayerHeadAnimation:_changeDisplay(sName,sIndex)
	local config = g_YDPlayerHeadAnimation_Config[self.m_sAninName]
	local bones = config.bone
	local bone = bones[sName]
	local nTempIndex = tonumber(sIndex)
	for i,v in ipairs(bone) do
		local displayName = self:_getDisplayName(v,sIndex)
		local bone1 = self.m_node:getArmature():getBone(v)
		if bone1 ~= nil then            
			if self.m_currentHeadIndex < 410 then 
				if nTempIndex and nTempIndex == 425 then 
		            bone1 = tolua.cast(bone1,"CCNode")
		            bone1:setScale(1.4)
			    end
			elseif self.m_currentHeadIndex == 425 then 
				if nTempIndex and nTempIndex ~= 425 then           
		            bone1 = tolua.cast(bone1,"CCNode")
		            bone1:setScale(0.8)
			    end
			else
				if nTempIndex and nTempIndex == 425 then           
		            bone1 = tolua.cast(bone1,"CCNode")
		            bone1:setScale(1.15)
		        elseif nTempIndex and nTempIndex <= 410 then 
		        	bone1 = tolua.cast(bone1,"CCNode")
		            bone1:setScale(0.8)
			    end
			end
		end
		if displayName ~= nil then 
			self:_checkArmature(displayName,sIndex)
			self.m_node:setDisplayData(0,v,displayName)
		end
		--setDisplayData( int index, const std::string& bone, const std::string& image )
	end
end

function YDPlayerHeadAnimation:_changeBodyDisplay(sName,sIndex)
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

function YDPlayerHeadAnimation:_changeExtendDisplay(sIndex,extendName)
	local boneName = self.m_sAninName .. extendName --combatboy_skirt
	local bone = self.m_node:getArmature():getBone(boneName)
	bone = tolua.cast(bone,"CCNode")
	if bone == nil then return end
	local displayName = self:_getDisplayName(boneName,sIndex)
	self:_checkArmature(displayName,sIndex)
	if CCArmatureDataManager:sharedArmatureDataManager():getArmatureData(displayName) == nil then 
		bone:setVisible(false)
	else 
		bone:setVisible(true)
		self.m_node:setDisplayData(0,boneName,displayName)
	end
	
end 

function YDPlayerHeadAnimation:_getNonBodyBone()
	local nonBody = {}
	return nonBody
end

function YDPlayerHeadAnimation:_contains(tArr,sValue)
	for i,v in ipairs(tArr) do 
		if v == sValue then 
			return true
		end 
	end 
	return false
end

function YDPlayerHeadAnimation:_formatIndex(sIndex)
	local index = tonumber(sIndex)
	return string.format("%03d",sIndex)	
end 


function YDPlayerHeadAnimation:_playIndex(nIndex,sBone,nLoop)
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

function YDPlayerHeadAnimation:pause()
    self.m_bIsStopFaceAndWindAnim = true
    self:getAnimNode():pause()
end

function YDPlayerHeadAnimation:resume()
    self.m_bIsStopFaceAndWindAnim = false
    self:getAnimNode():resume()
end

function YDPlayerHeadAnimation:getDownloadInfo(sIndex)
	WZLog("YDPlayerHeadAnimation:getDownloadInfo", sIndex)
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
		--	WZLog("YDPlayerHeadAnimation:getDownloadInfo_1", index, index == tostring(sIndex), sex == self.m_sAninName)
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
