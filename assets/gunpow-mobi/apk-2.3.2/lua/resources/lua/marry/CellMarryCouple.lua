--CellMarryCouple.lua
--@brief	CellMarryCouple的UI模块
--@date		2021/02/23
--@author	yrd
--@note		夫妻人物形象


-------------------------------------公有方法模块Begin--------------------------------------
-- --玩家随机移动的位置
-- local randomPos = {
-- 	{0.140782,1.37168},{0.235585,1.35349},{0.223452,0.977735},{0.430065,1.36545},{0.269247,0.763605},
-- 	{0.138179,0.832316},{0.485603,1.20341},{0.32883,1.37224},{0.461476,0.701223},{0.582915,0.874857},
-- 	{0.371506,0.723206},{0.323597,0.95489},{0.524743,0.771982},{0.863637,0.817184},{0.767882,0.864999},
-- 	{0.633442,1.39447},{0.559835,1.40865},{0.632514,0.895687},{0.71558,1.22557},{0.822478,1.32233},
-- }
local tBoyStepPos = {{0.16,0.5},{0.48,0.5},{0.66,0.96},{0.74,0.96}}
local tGirlStepPos = {{0.115,0.5},{0.48,0.5},{0.66,0.96},{0.74,0.96}}

local moveWidth = 1136
local moveHeigth = 130

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMarryCouple:onEnter(element)
	self.m_root = element
	GetElement(self.m_root, "conShow_CellMarryCouple", WZUIContainer):enableSchedule("ScheduleShowPlayer",0.3)
    self:setArmGuestInfo()
    GetElement(self.m_root,"spineEnterOrExit_CellMarryCouple",WZUISpine):setVisible(true)
    CacheCenter:registerUpatePlayerInfoObserver(self)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMarryCouple:onExit(element)
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief  进场或退场时播放动画完毕
function CellMarryCouple:armPlayFinish()
	GetElement(self.m_root,"spineEnterOrExit_CellMarryCouple",WZArmature):setVisible(false)
end

--@监听到玩家信息更新
function CellMarryCouple:updatePlayerInfoData()
	local playerInfo = CacheCenter:getPlayerInfo()
	if self.m_nPlayerId == playerInfo.id then
		local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellMarryCouple",WZUILabelTTF)
	    txtPlayerName:setText(playerInfo.name)
	end
end


--@brief 设置骨骼动画相关
--@param #1 sArmName 名字
function CellMarryCouple:setArmGuestInfo()
	WZLog("CellMarryCouple:setArmGuestInfo")
	local conPlayer = GetElement(self.m_root, "conPlayer_CellMarryCouple", WZUIContainer)
	local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellMarryCouple",WZUILabelTTF)
	txtPlayerName:setText(self.m_sPlayerName)
	txtPlayerName:enableSchedule("_scheduleDisplayName",2)
	if self.m_nServerId ~= CacheCenter:getPlayerInfo().serverId then 
		GetElement(self.m_root, "imgKuafuIcon_CellMarryCouple", WZUIImage):setVisible(true)
	end
	
	if self.m_nPlayerId == GlobalGame.g_tPlayerInfo.nPlayerId then
		txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
	end
	self.m_tConPlayer = conPlayer
	                                           
	-- self.m_tPlayerAni  = CreatePlayerFigure(self.m_nSex, self.m_tEquipment,nil,nil,nil,nil,nil,nil,nil,nil,self.m_tEquipment[4],self.m_tEquipment[5])
	self.m_tPlayerAni = GetElement(self.m_root,"spPlayer_CellMarryCouple",WZUISpine)
	if self.m_nWeddingType == 1 then
		if self.m_nSex == 0 then
			self.m_tPlayerAni:setFileJson("ui/dress_03.json")
			self.m_tPlayerAni:setFileAtlas("ui/dress_03.atlas")
		elseif self.m_nSex == 1 then
			self.m_tPlayerAni:setFileJson("ui/weddingdress_03.json")
			self.m_tPlayerAni:setFileAtlas("ui/weddingdress_03.atlas")
		end
	elseif self.m_nWeddingType == 2 then
		if self.m_nSex == 0 then
			self.m_tPlayerAni:setFileJson("ui/dress_02.json")
			self.m_tPlayerAni:setFileAtlas("ui/dress_02.atlas")
		elseif self.m_nSex == 1 then
			self.m_tPlayerAni:setFileJson("ui/weddingdress_02.json")
			self.m_tPlayerAni:setFileAtlas("ui/weddingdress_02.atlas")
		end
	elseif self.m_nWeddingType == 3 then
		if self.m_nSex == 0 then
			self.m_tPlayerAni:setFileJson("ui/dress_01.json")
			self.m_tPlayerAni:setFileAtlas("ui/dress_01.atlas")
		elseif self.m_nSex == 1 then
			self.m_tPlayerAni:setFileJson("ui/weddingdress_01.json")
			self.m_tPlayerAni:setFileAtlas("ui/weddingdress_01.atlas")
		end
	end
	self.m_tPlayerAni:setScale(0.64)
	self.m_tPlayerAni:setVisible(false)
	
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	local tStepPos = tBoyStepPos
	if self.m_nSex == 1 then
		tStepPos = tGirlStepPos
	end
	local absX = moveWidth * tStepPos[self.m_nMoveIndex][1]
	local absY = moveHeigth * tStepPos[self.m_nMoveIndex][2]
	self.m_tMoveDest.x = absX
    self.m_tMoveDest.y = absY
	self.m_root:setRelativePosition(GlobalMethod:ccp(tStepPos[self.m_nMoveIndex][1],tStepPos[self.m_nMoveIndex][2]))

end

--@brief  
function CellMarryCouple:_scheduleDisplayName(element)
	element:disableSchedule()
	element:setVisible(false)
end

--@brief  设置祝福语
function CellMarryCouple:setBlessings(txtBlessings)
	WZLog("CellMarryCouple:setBlessings")
	self.m_oConBlessing  = GetElement(self.m_root,"conBlessings_CellMarryCouple",WZUIContainer)
	self.m_oConBlessing:setVisible(true)
	local txtBlessing =  WZUILabelTTF:luaTo(self.m_oConBlessing:getChildElement("txtBlessings_CellMarryCouple"))
	txtBlessing:setText(txtBlessings)
	self.m_oConBlessing:enableSchedule("removeBlessings",3)
end

--@brief  删除祝福语
function CellMarryCouple:removeBlessings(element,de)
	WZLog("CellMarryCouple:removeBlessings")
	element:disableSchedule()
	if self.m_oConBlessing then
		self.m_oConBlessing:setVisible(false)
		local txtBlessing =  WZUILabelTTF:luaTo(self.m_oConBlessing:getChildElement("txtBlessings_CellMarryCouple"))
		txtBlessing:setText("")
	end
end

--@brief  延迟显示嘉宾
function CellMarryCouple:ScheduleShowPlayer(element)
	if self.m_tPlayerAni ~= nil then
		element:disableSchedule()
		self.m_tPlayerAni:setVisible(true)
		-- self.m_nMoveIndex =  math.random(20)
		-- self.m_root:enableSchedule("schedulePlayerMoving",1)
		self:schedulePlayerMoving()
	end
end

--@brief  控制玩家移动
function CellMarryCouple:schedulePlayerMoving(element)
	self.m_nMoveIndex = self.m_nMoveIndex + 1

	-- 女方到位时出现神父祝福语
	if self.m_nSex == 1 then
		if self.m_nMoveIndex == 3 then
			SceneWeddingChurch:showPriestTalk1()
		elseif self.m_nMoveIndex == 5 then
			SceneWeddingChurch:showPriestTalk2()
		end
	end

	local tStepPos = tBoyStepPos
	if self.m_nSex == 1 then
		tStepPos = tGirlStepPos
	end
	if self.m_nMoveIndex <= #tStepPos then
		local absX = moveWidth * tStepPos[self.m_nMoveIndex][1]
		local absY = moveHeigth * tStepPos[self.m_nMoveIndex][2]

		if absX < self.m_tMoveDest.x then
			self.m_tConPlayer:setScaleX(-1)
		else
			if self.m_tConPlayer:getScaleX() < 0 then
				self.m_tConPlayer:setScaleX(1)
			end
		end
		self.m_tMoveDest.x = absX
	    self.m_tMoveDest.y = absY

		self:_playerMoveTo()
	else
		GetElement(self.m_root,"txtPlayerName_CellMarryCouple",WZUILabelTTF):setVisible(true)
	end
end

--@brief  每帧更新下玩家位置
function CellMarryCouple:scheduleUpdatePlayer(element,delta)
	if self.m_tMoveDest == nil then
        element:disableSchedule()
        self.m_tPlayerAni:play("wait", true)
        return
    end

    local nSpeed = 1
    local nX, nY = self.m_root:getPosition()
    local nDistance =  math.sqrt((nX-self.m_tMoveDest.x)*(nX-self.m_tMoveDest.x) + (nY-self.m_tMoveDest.y)*(nY-self.m_tMoveDest.y))
    if nDistance < 1 then
        element:disableSchedule()
        self.m_tPlayerAni:play("wait", true)
        -- self.m_root:enableSchedule("schedulePlayerMoving",1)

		local tStepPos = tBoyStepPos
		if self.m_nSex == 1 then
			tStepPos = tGirlStepPos
		end
        if self.m_nMoveIndex <= #tStepPos then
	        self:schedulePlayerMoving()
	    end
        return
    end
    local nDeltaX = (self.m_tMoveDest.x-nX)*math.min(nSpeed/nDistance,1)
    local nDeltaY = (self.m_tMoveDest.y-nY)*math.min(nSpeed/nDistance,1)
    self.m_root:setPositionX(nX+nDeltaX)
    self.m_root:setPositionY(nY+nDeltaY)

    self:updateFootEffect(nX, nY)
end

--@brief 足迹刷新
function CellMarryCouple:updateFootEffect(nX, nY)
    local pos = {x = nX,y = nY}
    if not self.m_tOldFootPos then
    	self.m_tOldFootPos  = pos
    end
    if self.m_nFootId and self.m_nFootId > 0 then
     	local distance = GDatatab_footmark["id_" .. self.m_nFootId] and GDatatab_footmark["id_" .. self.m_nFootId].distance or 40
        if  BattleCommon:pointDis(self.m_tOldFootPos,pos) > distance then
	        self.m_tOldFootPos = pos
	        FootEffectManager:getInstance():addEffect(self.m_nFootId,pos,-25,self.m_tPlayerAni:getScaleX(),self.m_tPlayerAni:getScaleY())
	    end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置宾客动画朝向
--@param	nDir:宾客动画朝向（0-2：右朝向，3-5：左朝向）
--@note		设置宾客动画朝向
function CellMarryCouple:_setFaceTo(nDir)
	WZLog("CellMarryCouple:_setFaceTo")
	--右朝向
	-- if nDir >= 0 and nDir < 3 then
	-- 	local scaleX = self.m_tPlayerAni:getAnimNode():getScaleX()
	-- 	if scaleX >= -1 then
	-- 		self.m_tPlayerAni:getAnimNode():setScaleX(1)
	-- 	end
	-- --左朝向
	-- elseif nDir >= 3 and nDir <= 5 then
	-- 	local scaleX = self.m_tPlayerAni:getAnimNode():getScaleX()
	-- 	if scaleX >= 1 then
	-- 		self.m_tPlayerAni:getAnimNode():setScaleX(-1)
	-- 	end
	-- end
end
 
function CellMarryCouple:_playerMoveTo()
	self.m_tPlayerAni:play("walk", true)
	self.m_tConPlayer:enableSchedule("scheduleUpdatePlayer")
end




-------------------------------------私有方法模块End----------------------------------------
