--CellGuestList.lua
--@brief	CellGuestList的UI模块
--@date		2014/04/15
--@author	林庆凯
--@modify   qixiang_xie
--@note		宾客列表


-------------------------------------公有方法模块Begin--------------------------------------
--玩家随机移动的位置
local randomPos = {
	{0.140782,1.37168},{0.235585,1.35349},{0.223452,0.977735},{0.430065,1.36545},{0.269247,0.763605},
	{0.138179,0.832316},{0.485603,1.20341},{0.32883,1.37224},{0.461476,0.701223},{0.582915,0.874857},
	{0.371506,0.723206},{0.323597,0.95489},{0.524743,0.771982},{0.863637,0.817184},{0.767882,0.864999},
	{0.633442,1.39447},{0.559835,1.40865},{0.632514,0.895687},{0.71558,1.22557},{0.822478,1.32233},
}

local moveWidth = 1136
local moveHeigth = 130

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGuestList:onEnter(element)
	self.m_root = element
	GetElement(self.m_root, "conShow_CellGuestList", WZUIContainer):enableSchedule("ScheduleShowPlayer",0.3)
    self:setArmGuestInfo()
    GetElement(self.m_root,"spineEnterOrExit_CellGuestList",WZUISpine):setVisible(true)
    CacheCenter:registerUpatePlayerInfoObserver(self)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGuestList:onExit(element)
	if self.m_oConBlessing then
		self.m_oConBlessing:disableSchedule()
	end
	CacheCenter:unregisterUpatePlayerInfoObserver(self)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief  进场或退场时播放动画完毕
function CellGuestList:armPlayFinish()
	GetElement(self.m_root,"spineEnterOrExit_CellGuestList",WZArmature):setVisible(false)
end

--@监听到玩家信息更新
function CellGuestList:updatePlayerInfoData()
	local playerInfo = CacheCenter:getPlayerInfo()
	if self.m_nPlayerId == playerInfo.id then
		local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellGuestList",WZUILabelTTF)
	    txtPlayerName:setText(playerInfo.name)
	end
end


--@brief 设置骨骼动画相关
--@param #1 sArmName 名字
function CellGuestList:setArmGuestInfo()
	WZLog("CellGuestList:setArmGuestInfo")
	local conPlayer = GetElement(self.m_root, "conPlayer_CellGuestList", WZUIContainer)
	local txtPlayerName = GetElement(self.m_root,"txtPlayerName_CellGuestList",WZUILabelTTF)
	txtPlayerName:setText(self.m_sPlayerName)
	
	if self.m_nPlayerId == GlobalGame.g_tPlayerInfo.nPlayerId then
		txtPlayerName:setColor(GlobalMethod:ccc3(99,255,95))
	end
	self.m_tConPlayer = conPlayer
	                                           
	self.m_tPlayerAni  = CreatePlayerFigure(self.m_nSex, self.m_tEquipment,nil,nil,nil,nil,nil,nil,nil,nil,self.m_tEquipment[4],self.m_tEquipment[5])
	local pIndex = math.random(20)
	local node = self.m_tPlayerAni:getAnimNode()
	self.m_tPlayerAni:setScale(0.64)
	node:setVisible(false)
	
	local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
	local absX = moveWidth * randomPos[pIndex][1]
	local absY = moveHeigth * randomPos[pIndex][2]
	self.m_tMoveDest.x = absX
    self.m_tMoveDest.y = absY
	self.m_root:setRelativePosition(GlobalMethod:ccp(randomPos[pIndex][1],randomPos[pIndex][2]))
	conPlayer:addChild(node)
end

--@brief  设置祝福语
function CellGuestList:setBlessings(txtBlessings)
	WZLog("CellGuestList:setBlessings")
	self.m_oConBlessing  = GetElement(self.m_root,"conBlessings_CellGuestList",WZUIContainer)
	self.m_oConBlessing:setVisible(true)
	local txtBlessing =  WZUILabelTTF:luaTo(self.m_oConBlessing:getChildElement("txtBlessings_CellGuestList"))
	txtBlessing:setText(txtBlessings)
	self.m_oConBlessing:enableSchedule("removeBlessings",10)
end

--@brief 10秒钟后删除祝福语
function CellGuestList:removeBlessings(element,de)
	WZLog("CellGuestList:removeBlessings")
	element:disableSchedule()
	if self.m_oConBlessing then
		self.m_oConBlessing:setVisible(false)
		local txtBlessing =  WZUILabelTTF:luaTo(self.m_oConBlessing:getChildElement("txtBlessings_CellGuestList"))
		txtBlessing:setText("")
	end
end

--@brief  延迟显示嘉宾
function CellGuestList:ScheduleShowPlayer(element)
	if self.m_tPlayerAni ~= nil then
		element:disableSchedule()
		self.m_tPlayerAni:getAnimNode():setVisible(true)
		self.m_nRandomIndex =  math.random(20)
		self.m_root:enableSchedule("schedulePlayerMoving",1)
	end
end

--@brief  控制玩家移动
function CellGuestList:schedulePlayerMoving(element)
	self.m_nSchedulCount = self.m_nSchedulCount + 1
	if self.m_nSchedulCount >= self.m_nStopSecond then
		element:disableSchedule()
		self.m_nSchedulCount = 0
		local index = math.random(2)
		if index == 1 then
			self.m_nStopSecond = 3
		else
			self.m_nStopSecond = 6
		end
		--播放人物移动
		local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
		local absX = moveWidth * randomPos[self.m_nRandomIndex][1]
		local absY = moveHeigth * randomPos[self.m_nRandomIndex][2]
		if absX == self.m_tMoveDest.x and absY == self.m_tMoveDest.y then
			local ind = math.random(20)
			absX = moveWidth * randomPos[ind][1]
		    absY = moveHeigth * randomPos[ind][2]
		else
			if absX < self.m_tMoveDest.x then
				self.m_tConPlayer:setScaleX(-1)
			else
				if self.m_tConPlayer:getScaleX() < 0 then
					self.m_tConPlayer:setScaleX(1)
				end
			end
			self.m_tMoveDest.x = absX
		    self.m_tMoveDest.y = absY
		end
		self:_playerMoveTo()
		self.m_nRandomIndex =  math.random(20)
	end
end

--@brief  每帧更新下玩家位置
function CellGuestList:scheduleUpdatePlayer(element,delta)
	if self.m_tMoveDest == nil then
        element:disableSchedule()
        self.m_tPlayerAni:play("wait0", true)
        return
    end
    local nSpeed = 6
    local nX, nY = self.m_root:getPosition()
    local nDistance =  math.sqrt((nX-self.m_tMoveDest.x)*(nX-self.m_tMoveDest.x) + (nY-self.m_tMoveDest.y)*(nY-self.m_tMoveDest.y))
    if nDistance < 1 then
        element:disableSchedule()
        self.m_tPlayerAni:play("wait0", true)
        self.m_root:enableSchedule("schedulePlayerMoving",1)
        return
    end
    local nDeltaX = (self.m_tMoveDest.x-nX)*math.min(nSpeed/nDistance,1)
    local nDeltaY = (self.m_tMoveDest.y-nY)*math.min(nSpeed/nDistance,1)
    self.m_root:setPositionX(nX+nDeltaX)
    self.m_root:setPositionY(nY+nDeltaY)

    self:updateFootEffect(nX, nY)
end

--@brief 足迹刷新
function CellGuestList:updateFootEffect(nX, nY)
    local pos = {x = nX,y = nY}
    if not self.m_tOldFootPos then
    	self.m_tOldFootPos  = pos
    end
    if self.m_nFootId and self.m_nFootId > 0 then
     	local distance = GDatatab_footmark["id_" .. self.m_nFootId] and GDatatab_footmark["id_" .. self.m_nFootId].distance or 40
        if  BattleCommon:pointDis(self.m_tOldFootPos,pos) > distance then
	        self.m_tOldFootPos = pos
	        FootEffectManager:getInstance():addEffect(self.m_nFootId,pos,-25,self.m_anim:getAnimNode():getScaleX(),self.m_anim:getAnimNode():getScaleY())
	    end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置宾客动画朝向
--@param	nDir:宾客动画朝向（0-2：右朝向，3-5：左朝向）
--@note		设置宾客动画朝向
function CellGuestList:_setFaceTo(nDir)
	WZLog("CellGuestList:_setFaceTo")
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
 
function CellGuestList:_playerMoveTo()
	self.m_tPlayerAni:play("run", true)
	self.m_tConPlayer:enableSchedule("scheduleUpdatePlayer")
end

function CellGuestList:_adaptLanguage_en()
    WZLog("CellGuestList:_adaptLanguage_en")
    local conBlessings = GetElement(self.m_root,"conBlessings_CellGuestList",WZUIContainer)
    conBlessings:setAbsContentSize(GlobalMethod:CCSize(266,154))
    
    conBlessings:updateRelativeSize()

    local txtBlessings = GetElement(conBlessings,"txtBlessings_CellGuestList",WZUILabelTTF)
    txtBlessings:setDimensions(GlobalMethod:CCSize(245,0))
    txtBlessings:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txtBlessings:setMaxLength(120)
    txtBlessings:setRelativePosition(GlobalMethod:ccp(0.498931,0.583518))
    txtBlessings:setFontSize(18)
end

function CellGuestList:_adaptLanguage_pt(  )
	local conBlessings = GetElement(self.m_root,"conBlessings_CellGuestList",WZUIContainer)
    conBlessings:setAbsContentSize(GlobalMethod:CCSize(266,154))
    
    conBlessings:updateRelativeSize()

    local txtBlessings = GetElement(conBlessings,"txtBlessings_CellGuestList",WZUILabelTTF)
    txtBlessings:setDimensions(GlobalMethod:CCSize(245,0))
    txtBlessings:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txtBlessings:setMaxLength(120)
    txtBlessings:setRelativePosition(GlobalMethod:ccp(0.498931,0.583518))
    txtBlessings:setFontSize(18)
end

function CellGuestList:_adaptLanguage_th()
    WZLog("CellGuestList:_adaptLanguage_th")
    local conBlessings = GetElement(self.m_root,"conBlessings_CellGuestList",WZUIContainer)
   
    local txtBlessings = GetElement(conBlessings,"txtBlessings_CellGuestList",WZUILabelTTF)
    txtBlessings:setMaxLength(30)
    txtBlessings:setRelativePosition(GlobalMethod:ccp(0.5,1.58849))
end

-------------------------------------私有方法模块End----------------------------------------
