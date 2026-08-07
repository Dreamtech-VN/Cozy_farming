--CellBattleDialog.lua
--@brief	CellBattleDialog的UI模块
--@date		2014/09/17
--@author	莫剑峰
--@note		对话框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBattleDialog:onEnter(element)
    
	self.m_root = element
	-- local ttf = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtDesc_CellBattleDialog")) 
	-- ttf:setText(self.m_sText)
	local ttf = WZUIFreeTextBox:luaTo(self.m_root:getChildElement("freetxt_CellBattleDialog"))
    ttf:setShowText(ToChangeFreeText(self.m_sText, "62,34,8", nil, nil, nil, 24))
    local len = string.len(self.m_sText)
	local xScale = (ttf:getContentSize().width + 76) / 38
	local min = 2.7
	xScale = xScale < min and min or xScale

	WZLog("CellBattleDialog:onEnter one", len, ttf:getContentSize().width, xScale, self.m_nDir, CellBattleDialog.DIMG, CellBattleDialog.AIMGL)

	local scaleOffset1, scaleOffset2, scaleOffset3 = 0.4, 0.3, 0.55
	local widthDis = 0
	local heightDis = 24
	local widthArrow = 0
	local adjustX,adjustY = 0.5, 0.5

	local startX = 0
	local startY = 0
	if self.m_tSender then
		startX = self.m_tSender:getPositionX()
		startY = self.m_tSender:getPositionY()
	end
	
	local size = CCSize(38,38)--bg:getContentSize()
	self.m_nMaxWidth = size.width * xScale
	-- local ttf = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtDesc_CellBattleDialog")) 
	-- ttf:setText(self.m_sText)

    local ttfClick = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtClick_CellBattleDialog"))
    ttfClick:setVisible(self.m_bIsNeedClick == true)
    ttfClick:setText("")
	if self.m_nDir == CellBattleDialog.DIR_UP or self.m_nDir == CellBattleDialog.DIR_DOWN then
		--ttf:setDimensions( CCSize(self.m_nMaxWidth - 24 - widthDis * xScale , 0 ) )
	elseif self.m_nDir == CellBattleDialog.DIR_LEFT or self.m_nDir == CellBattleDialog.DIR_RIGHT then
		--ttf:setDimensions( CCSize(self.m_nMaxWidth - 24 - widthDis * xScale , 0 ) )
	end
    
    self.m_nMaxHeight = heightDis + ttf:getContentSize().height 
	self.m_root:setContentSize(CCSize(self.m_nMaxWidth,self.m_nMaxHeight))
	
	if self.m_nDir == CellBattleDialog.DIR_DOWN then
		adjustX = adjustX + widthArrow * xScale * scaleOffset1 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(ccp(0.5,1))
		if self.m_tSender then
			startY = startY - self.m_tSender:getContentSize().height/2
		end
	elseif self.m_nDir == CellBattleDialog.DIR_UP then
		adjustX = adjustX + widthArrow * xScale * scaleOffset1 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(ccp(0.5,0))
		if self.m_tSender then
			startY = startY + self.m_tSender:getContentSize().height/2
		end
	elseif self.m_nDir == CellBattleDialog.DIR_RIGHT then
		adjustX = adjustX + widthArrow * xScale * scaleOffset2 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(ccp(0,0.5))
		if self.m_tSender then
			startX = startX + self.m_tSender:getContentSize().width/2 - 40
			startY = startY - self.m_tSender:getContentSize().height/2 - self.m_nMaxHeight / 2
		end
	elseif self.m_nDir == CellBattleDialog.DIR_LEFT then
		adjustX = adjustX + widthArrow * xScale * scaleOffset3 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(ccp(1,0.5))
		
		if self.m_tSender then
			startX = startX - self.m_tSender:getContentSize().width/2
		end
	end

	ttf:setRelativePosition(ccp(adjustX, adjustY-0.1))

    --WZLog("CellBattleDialog:onEnter zero", self.m_sText, adjustX, adjustY, string.len(self.m_sText), xScale, size.width, self.m_nMaxWidth, self.m_nMaxWidth - widthDis * xScale)

    ttfClick:setRelativePosition(ccp(adjustX, -0.2))

 --    local bg = WZUIImage:create()
	-- bg:setUseOriginSize(true)
 --    bg:setFile(CellBattleDialog.AIMG)
  
  	--WZLog("CellBattleDialog:onEnter one", self.m_root:getContentSize().width)

	local _9img = WZUI9Image:create()
    --_9img:setCapInsets(CCRectMake(12,12,12,12))
    _9img:setCapInsets(CCRectMake(70,42,2,2))
    _9img:setFile(CellBattleDialog.DIMG)

    local imgContainer = WZUIContainer:create()
    self.m_root:addChild(imgContainer)
    imgContainer:setContentSize(CCSize(self.m_nMaxWidth,self.m_nMaxHeight))
    imgContainer:addChild(_9img)
    -- imgContainer:addChild(bg,100)
    self.m_tImgContainer = imgContainer

    local point = ccp(startX + self.m_nOffsetX, startY + self.m_nOffsetY)
    if self.m_nDir == CellBattleDialog.DIR_RIGHT then
        point.x = point.x + 25
    elseif self.m_nDir == CellBattleDialog.DIR_LEFT then
        point.x = point.x - 25
    elseif self.m_nDir == CellBattleDialog.DIR_UP then
        point.x = point.x + 43
        point.y = point.y + 60
    elseif self.m_nDir == CellBattleDialog.DIR_DOWN then
        point.x = point.x + 50
        point.y = point.y - 60
    end

	if self.m_tSender then
		point = self.m_tSender:getParent():convertToWorldSpace(point)
		point = self.m_tParent:convertToNodeSpace(point)
	end
	self.m_root:setPosition(point)

	if self.m_bIsScaleAction then
		self:playScaleAction()
	end
	
    local scaleX = self.m_root:getScaleX()
    local scaleY = self.m_root:getScaleY()
    if self.m_bIsOriScale then
        self.m_root:setScaleX(0.9)
        self.m_root:setScaleY(0.9)
    end
	--WZLog("CellBattleDialog_onEnter one", self.m_sText, tostring(self.m_bIsOriScale),scaleX,scaleY, self.m_nMaxWidth, self.m_nMaxHeight, startX, startY, point.x, point.y, adjustX, adjustY, tostring(self.m_nOffsetX), tostring(self.m_nOffsetY))

end

--@brief	更新函数
function CellBattleDialog:updateTalkPos(heroPos, point0)
	--do return end
	local offset = {x=0, y=0}
	local x, y = self.m_root:getPosition()
	x = math.floor(x)
	y = math.floor(y)
	local point = SceneBattle:getFrontLayer():convertToWorldSpace(GlobalMethod:ccp(heroPos.x+offset.x,heroPos.y+offset.y))
	point = SceneBattle:getInfoLayer():convertToNodeSpace(point)
	point.x = math.floor(point.x)
	point.y = math.floor(point.y)
	
	local arrow = WZUIImage:create()
	arrow:setAnchorPoint(GlobalMethod:ccp(0.5,1))
	arrow:setUseOriginSize(true)
    self.m_tImgContainer:addChild(arrow,100)
    arrow:setUseAbsCoordinate(true)

    WZLog("CellBattleDialog:updateTalkPo_zero", x, y, point.x, point.y, self.m_root:getContentSize().width)

    local width = self.m_root:getContentSize().width
    local posx, posy = 0,2
 --    CellBattleDialog:updateTalkPos 479 424 479  360 216
	-- CellBattleDialog:updateTalkPos 924	351	1059	256	169	0

	if point.y >= 640 then
		posx = width / 2
			posy = self.m_root:getContentSize().height + 4
			arrow:setFile(CellBattleDialog.AIMGD)
			arrow:setFlipY(true)
			WZLog("CellBattleDialog:updateTalkPos 0")
	elseif math.abs(x - point.x) < 10 then
		if point.y > y then
			posx = width / 2
			posy = self.m_root:getContentSize().height + 4
			arrow:setFile(CellBattleDialog.AIMGD)
			arrow:setFlipY(true)
			WZLog("CellBattleDialog:updateTalkPos 1")
		else
			posx = width / 2
			posy = posy +5
			arrow:setFile(CellBattleDialog.AIMGD)
			WZLog("CellBattleDialog:updateTalkPos 2")
		end
	elseif point.x > 0 and point.x < 960 then
		if x > point.x and x - point.x < width then --对话框比人远,但没超出框
			posx = 40 --width / 2 - (x - point.x)
			posy = posy +5
			arrow:setFile(CellBattleDialog.AIMGD)
			WZLog("CellBattleDialog:updateTalkPos 3")
		elseif x < point.x and point.x - x < width then --对话框比人近,但没超出框
			posx = width - 40 --width / 2 + (point.x - x)
			posy = posy +5
			arrow:setFile(CellBattleDialog.AIMGD)
			WZLog("CellBattleDialog:updateTalkPos 4")
		elseif x > point.x and x - point.x >= width then --对话框比人远,而且超出框
			posx = 40
			posy = posy + 5
			arrow:setFile(CellBattleDialog.AIMGL)
			arrow:setFlipX(true)
			WZLog("CellBattleDialog:updateTalkPos 5")
		elseif x < point.x and point.x - x >= width then --对话框比人近,而且超出框
			posx = width - 40
			posy = posy + 5
			arrow:setFile(CellBattleDialog.AIMGL)
			WZLog("CellBattleDialog:updateTalkPos 6")
		else
			arrow:setFile(CellBattleDialog.AIMGD)
			WZLog("CellBattleDialog:updateTalkPos 7")
		end
	elseif point.x <= 0 then
		posx = 40
		posy = posy + 5
		arrow:setFile(CellBattleDialog.AIMGL)
		arrow:setFlipX(true)
		WZLog("CellBattleDialog:updateTalkPos 8")
	elseif point.x >= 960 then
		posx = width - 40
		posy = posy + 5
		arrow:setFile(CellBattleDialog.AIMGL)
		WZLog("CellBattleDialog:updateTalkPos 9")
	else
		arrow:setFile(CellBattleDialog.AIMGD)
		WZLog("CellBattleDialog:updateTalkPos 10")
	end

    arrow:setAbsPosition(GlobalMethod:ccp(posx,posy))
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBattleDialog:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	更新函数
function CellBattleDialog:updatePos(element,dt)
    --WZLog("CellBattleDialog:updatePos",dt,  tostring(self.m_tFollowObj:getPosition().x), tostring(self.m_tFollowObj:getPosition().y), self.m_tOriginalPos.x, self.m_tOriginalPos.y, self.m_tFollowObj.m_sPlayerName, self.m_tFollowObj.m_nBattleId)
    
end

function CellBattleDialog:playScaleAction()
	
	local ttf = self.m_root:getChildElement("txtContent_CellBattleDialog")
	
	ttf:setVisible(false)
	
	local scaleX = self.m_root:getScaleX()
	local scaleY = self.m_root:getScaleY()
	
	self.m_root:setScaleX(0.1 * self.m_nScale * scaleX)
	self.m_root:setScaleY(0.1 * self.m_nScale * scaleY)
	
	local scale1 = WZUIActionScaleTo:create()
	scale1:setScaleX(0.7 * self.m_nScale * scaleX)
	scale1:setScaleY(0.7 * self.m_nScale * scaleY)
	scale1:setDuration(0.1)
	
	local scale2 = WZUIActionScaleTo:create()
	scale2:setScaleX(0.9 * self.m_nScale * scaleX)
	scale2:setScaleY(0.9 * self.m_nScale * scaleY)
	scale2:setDuration(0.1)
	
	local scale3 = WZUIActionScaleTo:create()
	scale3:setScaleX(1.1 * self.m_nScale * scaleX)
	scale3:setScaleY(1.1 * self.m_nScale * scaleY)
	scale3:setDuration(0.1)
	
	local scale4 = WZUIActionScaleTo:create()
	scale4:setScaleX(1 * self.m_nScale * scaleX)
	scale4:setScaleY(1 * self.m_nScale * scaleY)
	scale4:setDuration(0.1)
	scale4:setFinishLuaFunction("scaleCallBack")
	scale4:setFinishLuaTable(self)
	
	local sequence = WZUIActionSequence:create()
	sequence:setChildAction(scale1)
	sequence:setChildAction(scale2)
	sequence:setChildAction(scale3)
	sequence:setChildAction(scale4)
	
	self.m_root:runUIAction(sequence)
end

function CellBattleDialog:scaleCallBack(element)
	local ttf = self.m_root:getChildElement("txtContent_CellBattleDialog")
	
	ttf:setVisible(true)
	
	if self.m_nShowTime >= 0 then
		self.m_root:enableSchedule("timeCallBack",self.m_nShowTime)
	end
	
	if self.m_bJump then
		local jumpTo = WZUIActionJumpTo:create()
		jumpTo:setPosition( ccp( element:getPositionX(),element:getPositionY() ) )
		jumpTo:setHeight(40)
		jumpTo:setJumps(10000)
		jumpTo:setDuration(10000)
		element:runUIAction(jumpTo)
	end
end

function CellBattleDialog:timeCallBack(element,dt)
	self:removeDialog(true)
end

--@brief	移除对话框
function CellBattleDialog:removeDialog(bClean)

	if self.m_tBackSender and self.m_tBackFunction then
		self.m_tBackFunction(self.m_tBackSender)
	end
	
	if bClean and self.m_root then
		self.m_root:removeFromParentAndCleanup(true)
	elseif self.m_root then
		self.m_root:setVisible(false)
		self.m_root:enableSchedule("timeCallBack",0.5)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
