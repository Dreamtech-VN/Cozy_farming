--CellHead.lua
--@brief	CellHead的UI模块
--@date		2015/09/22
--@author	zsq
--@note		显示带遮罩的人物头像


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHead:onEnter(element)
	self.m_root = element
	self.m_tBackFun = nil  --回调函数列表
end

--@brief	加载动画
function CellHead:onEnterTransitionDidFinish(element)
	if type(self.m_bGrayRender) == "number" then
		self.m_bGrayRender = nil
	end
	WZLog("CellHead:onEnterTransitionDidFinish", self.m_bIsKid)
	if self.m_bIsKid then
		self:setKidHead(self.m_nHeadId ,self.m_nFaceId,self.m_nSex,self.m_bGrayRender, nil, self.m_nHeadEffectId)
	else
		self:setHead(self.m_nHeadId ,self.m_nFaceId,self.m_nSex,self.m_bGrayRender, self.m_nHeadColor, self.m_nHeadEffectId)
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHead:onExit(element)
	self:_unInit()
	self.m_tBackFun = nil  --回调函数列表
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   玩家人物
function CellHead:setHead(headId,faceId,sex,grayRender,headColor, headEffectId)
	WZLog("CellHead:setHead",headId,faceId,sex,headEffectId)

	--是否显示vip
	if self.m_nVipLevel == nil then
		GetElement(self.m_root,"conVip",WZUIContainer):setVisible(false)
	elseif tonumber(self.m_nVipLevel) == 0 then
		GetElement(self.m_root,"conVip",WZUIContainer):setVisible(false)
	elseif tonumber(self.m_nVipLevel) ~= nil then
		GetElement(self.m_root,"conVip",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"labelVip",WZUILabelAtlasFont):setText(self.m_nVipLevel)
		if tonumber(self.m_nVipLevel) >= 10 then
			GetElement(self.m_root,"imgVip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.37,0.28))
			GetElement(self.m_root,"labelVip",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.56,0.27))
		else
			GetElement(self.m_root,"imgVip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.45,0.28))
			GetElement(self.m_root,"labelVip",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.65,0.27))
		end
		local imgVipIcon = GetElement(self.m_root, "imgVipIcon_CellHead", WZUIImage)
		setVipIconByVipLevel(imgVipIcon, tonumber(self.m_nVipLevel))
	end

	if self.m_sZheZhaoFile ~= nil then
		GetElement(self.m_root,"imgZheZhao_CellHead",WZUIImage):setFile(self.m_sZheZhaoFile)
		GetElement(self.m_root,"imgZheZhao_CellHead",WZUIImage):setScale(self.m_nZheZhaoScale)
		GetElement(self.m_root,"imgZheZhaoYuan_CellHead",WZUIImage):setVisible(false)
	end

	if headEffectId and headEffectId > 0 then 
		local spineEffect = GetElement(self.m_root, "spineEffect_CellHead", WZUISpine)
		local basicInfo = GDatatab_item["id_" .. headEffectId]
		if spineEffect and basicInfo and basicInfo.value > 0 then
			local effectFile = "checkother/ui_playerhead_effect" .. basicInfo.value
			local existSpine = CheckEffectFile(effectFile)
			if existSpine then 
				spineEffect:setFileAtlas(effectFile .. ".atlas")
				spineEffect:setFileJson(effectFile .. ".json")

				spineEffect:play("wait_1", true)

				--调整头像特效框大小位置
				local conEffect = GetElement(self.m_root,"conEffect_CellHead",WZUIContainer)
				local nScale = 1
				local nPosX = 0.5
				local nPosY = 0.5
				if basicInfo.power_skill ~= -1 then
					local tmpScale = tonumber(spineEffect:getScale())
					tmpScale = math.floor(tmpScale*10)/10
					if tmpScale == 1.2 then
						nScale = basicInfo.power_skill[1][7]
						nPosX = basicInfo.power_skill[1][8]
						nPosY = basicInfo.power_skill[1][9]
					else
						nScale = basicInfo.power_skill[1][1]
						nPosX = basicInfo.power_skill[1][2]
						nPosY = basicInfo.power_skill[1][3]
					end
				end
				conEffect:setScale(nScale)
				conEffect:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
			else
				local sIndex = string.format("%04d", basicInfo.value)
	            local downloadInfo = GetDownloadInfo(sIndex, "playerhead_effect")
	            if downloadInfo == nil then return end 

	            DownloadManager:addDownloadTask(7000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex,"DownloadResourceCallback", _G)
			end

			--调整头像特效框大小位置
			local conEffect = GetElement(self.m_root,"conEffect_CellHead",WZUIContainer)
			local nScale = 1
			local nPosX = 0.5
			local nPosY = 0.5
			if basicInfo.power_skill ~= -1 then
				local tmpScale = tonumber(spineEffect:getScale())
				tmpScale = math.floor(tmpScale*10)/10
				if tmpScale == 1.2 then
					nScale = basicInfo.power_skill[1][7]
					nPosX = basicInfo.power_skill[1][8]
					nPosY = basicInfo.power_skill[1][9]
				else
					nScale = basicInfo.power_skill[1][1]
					nPosX = basicInfo.power_skill[1][2]
					nPosY = basicInfo.power_skill[1][3]
				end
			end
			conEffect:setScale(nScale)
			conEffect:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
		end
	end

	local grayRender = grayRender or false
	if headId == nil or faceId == nil then return end
	local sex = sex or 0--玩家性别
	local bBoy
	if sex == 0 then bBoy = true else bBoy = false end
	local gameParam = CacheCenter:getGameParam()
	if sex == 1 then
		if headId == nil or headId == 0 then
			headId = gameParam.defaultWomanHeadId or 4906
		end

		if faceId == nil or faceId == 0 then
			faceId = gameParam.defaultWomanFaceId or 4905
		end
		
	else
		if headId == nil or headId == 0 then
			headId = gameParam.defaultManHeadId or 4903
		end

		if faceId == nil or faceId == 0 then
			faceId = gameParam.defaultManFaceId or 4902
		end
	end

	local conPlayerAni = GetElement(self.m_root,"conHead_CellHead",WZUIContainer)
	if conPlayerAni:getChildByTag(50) then
		conPlayerAni:removeChildByTag(50,true)
	end

	local conPlayer = YDPlayerHeadAnimation:createAnimation(bBoy)

	conPlayer:getAnimNode():setTag(50)
	local animNode = conPlayer:getAnimNode()
	conPlayerAni:addChild(animNode)
	animNode:setTouchEnable(false)
	WZLog("头像大小",animNode:getContentSize().width,animNode:getContentSize().height)
	if tostring(sex) == "0" then
		animNode:setScale(0.5)
	end


	local bIsHavedValue = false 
	if self.m_nHeadScale and self.m_nHeadScale < 0.5 then
		animNode:setScale(self.m_nHeadScale)
		bIsHavedValue = true
	else
		animNode:setScale(0.5)
	end

	if GDatatab_item["id_"..headId].animation_index_code == 425 and GDatatab_item["id_"..faceId].animation_index_code == 425 then 
		animNode:setScale(0.55)
	elseif GDatatab_item["id_"..headId].animation_index_code > 410 and not bIsHavedValue then 
		animNode:setScale(0.68)
	end
	
	if GDatatab_item["id_"..headId] then
		conPlayer:setHead(GDatatab_item["id_"..headId].animation_index_code, headColor or self.m_nHeadColor or 0)
	end
	if GDatatab_item["id_"..faceId] then
		conPlayer:setFace(GDatatab_item["id_"..faceId].animation_index_code)	
	end
	conPlayer:play("avatar",true)
	
	if self.m_tOffset ~= nil then
		animNode:setRelativePosition(GlobalMethod:ccp(self.m_tOffset.x,self.m_tOffset.y))
	end

	animNode:setGrayRender(grayRender)
    self.m_tAnimNode = animNode
end

--@brief   小孩头像
function CellHead:setKidHead(headId,faceId,sex,grayRender,headColor, headEffectId)
	WZLog("CellHead:setKidHead",headId,faceId,sex)

	--是否显示vip
	GetElement(self.m_root,"conVip",WZUIContainer):setVisible(false)

	if self.m_sZheZhaoFile ~= nil then
		GetElement(self.m_root,"imgZheZhao_CellHead",WZUIImage):setFile(self.m_sZheZhaoFile)
		GetElement(self.m_root,"imgZheZhao_CellHead",WZUIImage):setScale(self.m_nZheZhaoScale)
		GetElement(self.m_root,"imgZheZhaoYuan_CellHead",WZUIImage):setVisible(false)
	end

	if headEffectId and headEffectId > 0 then 
		local spineEffect = GetElement(self.m_root, "spineEffect_CellHead", WZUISpine)
		local basicInfo = GDatatab_item["id_" .. headEffectId]
		if spineEffect and basicInfo and basicInfo.value > 0 then
			local sIndex = string.format("%04d", basicInfo.value)
			local effectFile = "checkother/ui_babyhead_effect" .. sIndex
			local existSpine = CheckEffectFile(effectFile)
			if existSpine then 
				spineEffect:setFileAtlas(effectFile .. ".atlas")
				spineEffect:setFileJson(effectFile .. ".json")

				spineEffect:play("wait_1", true)

				--调整头像特效框大小位置
				local conEffect = GetElement(self.m_root,"conEffect_CellHead",WZUIContainer)
				local nScale = 1
				local nPosX = 0.5
				local nPosY = 0.5
				if basicInfo.power_skill ~= -1 then
					nScale = basicInfo.power_skill[1][1]
					nPosX = basicInfo.power_skill[1][2]
					nPosY = basicInfo.power_skill[1][3]
				end
				conEffect:setScale(nScale)
				conEffect:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
			else
	            local downloadInfo = GetDownloadInfo(sIndex, "babyhead_effect")
	            if downloadInfo ~= nil then 
	            	DownloadManager:addDownloadTask(7000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex,"DownloadResourceCallback", _G)
	            end
			end
		end
	end


	local grayRender = grayRender or false
	if headId == nil or faceId == nil then return end
	local sex = sex or 0--玩家性别
	local bBoy
	if sex == 0 then bBoy = true else bBoy = false end
	local gameParam = CacheCenter:getGameParam()
	if sex == 1 then
		if headId == nil or headId == 0 then
			headId = gameParam.defaultfemaleHeadId or 51100
		end

		if faceId == nil or faceId == 0 then
			faceId = gameParam.defaultfemaleFaceId or 51300
		end
		
	else
		if headId == nil or headId == 0 then
			headId = gameParam.defaultmaleHeadId or 51000
		end

		if faceId == nil or faceId == 0 then
			faceId = gameParam.defaultmaleFaceId or 51200
		end
	end

	local conPlayerAni = GetElement(self.m_root,"conHead_CellHead",WZUIContainer)
	if conPlayerAni:getChildByTag(50) then
		conPlayerAni:removeChildByTag(50,true)
	end

	local conPlayer = YDBabyAnimation:createAnimation(bBoy)
	--conPlayer:play("sit")
	conPlayer:getAnimNode():setTag(50)
	local animNode = conPlayer:getAnimNode()
	conPlayerAni:addChild(animNode)
	animNode:setTouchEnable(false)
	WZLog("头像大小",animNode:getContentSize().width,animNode:getContentSize().height)
	if tostring(sex) == "0" then
		animNode:setScale(0.5)
	end

	
	if self.m_nHeadScale and self.m_nHeadScale < 0.5 then
		animNode:setScale(self.m_nHeadScale)
	else
		animNode:setScale(0.55)
	end
	
	
	conPlayer:setHead(GDatatab_item["id_"..headId].animation_index_code,headColor or self.m_nHeadColor)
	conPlayer:setFace(GDatatab_item["id_"..faceId].animation_index_code)	
	conPlayer:play("avatar",true)
	
	if self.m_tOffset ~= nil then
		animNode:setRelativePosition(GlobalMethod:ccp(self.m_tOffset.x,self.m_tOffset.y))
	end

	animNode:setGrayRender(grayRender)
    self.m_tAnimNode = animNode
end

--@brief	item点击回调
--@param tCell:父节点
--@param backFun：回调函数
-- function CellHead:setHeadClickFun(tCell,backFun)
-- 	if tCell and backFun then
-- 		self.m_tBackFun = {}  --回调函数列表
-- 		table.insert(self.m_tBackFun,tCell)
-- 		table.insert(self.m_tBackFun,backFun)
-- 	end
-- end

function CellHead:setHideBg()
	-- local imgBg = GetElement(self.m_root,"imgZheZhaoDi_CellHead",WZUIImage)
	-- imgBg:setVisible(false)

	local imgBar = GetElement(self.m_root,"imgZheZhaoYuan_CellHead",WZUIImage)
	imgBar:setVisible(false)
end

--@brief 	刷新头像特效
function CellHead:resetHeadEffect(headEffectId)
	-- body
	WZLog("CellHead:resetHeadEffect", tostring(self.m_nHeadEffectId), headEffectId)
	if self.m_nHeadEffectId == nil or (self.m_nHeadEffectId and self.m_nHeadEffectId ~= headEffectId) then 
		self.m_nHeadEffectId = headEffectId

		if headEffectId and headEffectId > 0 then 
			local spineEffect = GetElement(self.m_root, "spineEffect_CellHead", WZUISpine)
			local basicInfo = GDatatab_item["id_" .. headEffectId]
			local effectFile1 = "checkother/ui_playerhead_effect" .. basicInfo.value
			local existSpine = CheckEffectFile(effectFile1)
			if existSpine then 
				if spineEffect and basicInfo and basicInfo.value > 0 then
					spineEffect:setFileJson("")
					spineEffect:setFileAtlas("")
					spineEffect:setFileAtlas(effectFile1 .. ".atlas")
					spineEffect:setFileJson(effectFile1 .. ".json")

					spineEffect:play("wait_1", true)

					--调整头像特效框大小位置
					local conEffect = GetElement(self.m_root,"conEffect_CellHead",WZUIContainer)
					local nScale = 1
					local nPosX = 0.5
					local nPosY = 0.5
					if basicInfo.power_skill ~= -1 then
						local tmpScale = tonumber(spineEffect:getScale())
						tmpScale = math.floor(tmpScale*10)/10
						if tmpScale == 1.2 then
							nScale = basicInfo.power_skill[1][7]
							nPosX = basicInfo.power_skill[1][8]
							nPosY = basicInfo.power_skill[1][9]
						else
							nScale = basicInfo.power_skill[1][1]
							nPosX = basicInfo.power_skill[1][2]
							nPosY = basicInfo.power_skill[1][3]
						end
					end
					conEffect:setScale(nScale)
					conEffect:setRelativePosition(GlobalMethod:ccp(nPosX,nPosY))
				end
			else
				local sIndex = string.format("%04d", basicInfo.value)
	            local downloadInfo = GetDownloadInfo(sIndex, "playerhead_effect")
	            if downloadInfo == nil then return end 

	            DownloadManager:addDownloadTask(7000 + tonumber(sIndex),downloadInfo.url,downloadInfo.md5,sIndex,"DownloadResourceCallback", _G)
			end
		else
			local spineEffect = GetElement(self.m_root, "spineEffect_CellHead", WZUISpine)
			if spineEffect then 
				spineEffect:setFileJson("")
				spineEffect:setFileAtlas("")
			end
		end
	elseif self.m_nHeadEffectId == 0 then 
		local spineEffect = GetElement(self.m_root, "spineEffect_CellHead", WZUISpine)
		if spineEffect then 
			spineEffect:setFileJson("")
			spineEffect:setFileAtlas("")
		end
	end
end

--@brief 	设置头像框特效缩放
function CellHead:setHeadEffectScale(nScale)
	local spineEffect = GetElement(self.m_root, "spineEffect_CellHead", WZUISpine)
	spineEffect:setScale(nScale)

	local headEffectId = self.m_nHeadEffectId
	self.m_nHeadEffectId = nil
	self:resetHeadEffect(headEffectId)
end


--@brief	回调函数
-- function CellHead:onBackClick(element)
--     WZLog("********************* CellHead:onBackClick ********************* ")
-- 	if self.m_tBackFun then
-- 		self.m_tBackFun[2](self.m_tBackFun[1])
-- 	end
-- end

--@brief	窗口显示奖励内容
--@param    con:父容器
--@param    headId:头id
--@param    faceId:脸id
--@param    sex:性别
--@param    grayRender:是否灰化
--@param    offset:偏移
--@param 	bIsKid:是否小孩头像
--@param 	headEffectId: 头像特效物品Id
function CellHead:show(con,headId,faceId,sex,grayRender,offset,vipLevel,headColor, zheZhaoFile, zheZhaoScale,headScale, bIsKid, headEffectId)
	if headId == nil or faceId == nil or sex == nil then
		return
	end

 	local celElement,tLuaObj = CellHead:createElement()
 	tLuaObj.m_nHeadId = headId
	tLuaObj.m_nFaceId = faceId
	tLuaObj.m_nSex = sex
	tLuaObj.m_oCon = con
	tLuaObj.m_bGrayRender = grayRender
	tLuaObj.m_tOffset = offset or GlobalMethod:ccp(0.54,0.29)
	tLuaObj.m_nVipLevel = vipLevel
	tLuaObj.m_nHeadColor = headColor
	tLuaObj.m_sZheZhaoFile = zheZhaoFile
	tLuaObj.m_nZheZhaoScale = zheZhaoScale
	tLuaObj.m_nHeadScale = headScale
	tLuaObj.m_bIsKid = bIsKid
	tLuaObj.m_nHeadEffectId = headEffectId
    if celElement ~= nil then 
     	celElement = WZUIContainer:luaTo(celElement)
        --tLuaObj:setHead(headId,faceId,sex)

        celElement:setTag(50)

        if con then
            if con:getChildByTag(50) then
                con:removeChildByTag(50,true)
            end
            con:addChild(celElement)
        end
		return celElement, tLuaObj
    end
end
-------------------------------------私有方法模块End----------------------------------------
