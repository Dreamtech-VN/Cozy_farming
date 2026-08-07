--CellTeachDialog.lua
--@brief	CellTeachDialog的UI模块
--@date		2014/09/17
--@author	莫剑峰
--@note		对话框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTeachDialog:onEnter(element)
    
	self.m_root = element
    local len = string.len(self.m_sText)
	local xScale = self.m_nTextLength or
    len >  21 and (25 * (21/3+1) / 82) or
    len <= 21 and (25 * (len/3+1) / 82);

    if "en" == ProjConfig.LANGUAGE then
    	--xScale = self.m_nTextLength or (13 * (len) / 82);

    	xScale = self.m_nTextLength or
    	len >  25 and (13 * (25) / 82) or
    	len <= 6 and (13 * (7) / 82) or
    	len == 7 and (13 * (8) / 82) or
    	len == 11 and (13 * (13) / 82) or len == 13 and (13 * (13) / 82) or
    	len <= 25 and (13 * (len+1) / 82)
    elseif ProjConfig.LANGUAGE == "tr" then
    	xScale = self.m_nTextLength or
    	len >  25 and (13 * (25) / 100) or
    	len <= 6 and (13 * (7) / 100) or
    	len == 7 and (13 * (8) / 100) or
    	len == 11 and (13 * (13) / 100) or len == 13 and (13 * (13) / 100) or
    	len <= 25 and (13 * (len+1) / 100)
    end

    WZLog("CellTeachDialog:onEnter", self.m_sText, len, xScale, self.m_nTextLength)

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

	local bg = WZUIImage:create()
	bg:setUseOriginSize(true)
    bg:setFile(CellTeachDialog.DIMG)
    self.m_root:addChild(bg)
    bg:setVisible(false)
	
	local size = GlobalMethod:CCSize(82,70)--bg:getContentSize()
	local ttf = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtDesc_CellTeachDialog")) 
	ttf:setText(self.m_sText)

	if "vn" == ProjConfig.LANGUAGE then
        xScale = ttf:getLabelContentSize().width <= 176 and (ttf:getLabelContentSize().width + 24) / 82 or 10 * 25 /82
    elseif "pt" == ProjConfig.LANGUAGE then
    	heightDis = 0
    	xScale = ttf:getLabelContentSize().width <= 176 and (ttf:getLabelContentSize().width + 22) / 82 or 10 * 22 /82
 	elseif ProjConfig.LANGUAGE == "es" then
 		ttf:setScale(0.7)
 		heightDis = 0
 		xScale = ttf:getLabelContentSize().width <= 155 and (ttf:getLabelContentSize().width + 20) / 90 or 10 * 20 /90
    elseif "tr" == ProjConfig.LANGUAGE then
    	heightDis = 0
    	--xScale = ttf:getLabelContentSize().width <= 176 and (ttf:getLabelContentSize().width + 22) / 82 or 10 * 22 /82
    	--ttf:setDimensions( GlobalMethod:CCSize(self.m_nMaxWidth - 50 - widthDis * xScale , 0 ) )
    end
	self.m_nMaxWidth = size.width * xScale
    local ttfClick = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtClick_CellTeachDialog"))
    ttfClick:setVisible(self.m_bIsNeedClick == true)
    ttfClick:setText("")
	if self.m_nDir == CellTeachDialog.DIR_UP or self.m_nDir == CellTeachDialog.DIR_DOWN then
		if ProjConfig.LANGUAGE == "es" then
			ttf:setDimensions( GlobalMethod:CCSize(self.m_nMaxWidth - widthDis * xScale , 0 ) )
		else
			ttf:setDimensions( GlobalMethod:CCSize(self.m_nMaxWidth - 24 - widthDis * xScale , 0 ) )
		end
		if ProjConfig.LANGUAGE == "tr" then
			ttf:setDimensions( GlobalMethod:CCSize(self.m_nMaxWidth - widthDis * xScale - 10 , 0 ) )
		end
	elseif self.m_nDir == CellTeachDialog.DIR_LEFT or self.m_nDir == CellTeachDialog.DIR_RIGHT then
		if ProjConfig.LANGUAGE == "es" then
			ttf:setDimensions( GlobalMethod:CCSize(self.m_nMaxWidth - widthDis * xScale , 0 ) )
		else
			ttf:setDimensions( GlobalMethod:CCSize(self.m_nMaxWidth - 24 - widthDis * xScale , 0 ) )
		end
		if ProjConfig.LANGUAGE == "tr" then
			ttf:setDimensions( GlobalMethod:CCSize(self.m_nMaxWidth - widthDis * xScale - 10 , 0 ) )
		end
	end
    
    self.m_nMaxHeight = heightDis + ttf:getContentSize().height 
	self.m_root:setContentSize(GlobalMethod:CCSize(self.m_nMaxWidth,self.m_nMaxHeight))
	
	if self.m_nDir == CellTeachDialog.DIR_DOWN then
		adjustX = adjustX + widthArrow * xScale * scaleOffset1 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(GlobalMethod:ccp(0.5,1))
		if self.m_tSender then
			startY = startY - self.m_tSender:getContentSize().height/2
		end
	elseif self.m_nDir == CellTeachDialog.DIR_UP then
		adjustX = adjustX + widthArrow * xScale * scaleOffset1 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(GlobalMethod:ccp(0.5,0))
		if self.m_tSender then
			startY = startY + self.m_tSender:getContentSize().height/2
		end
	elseif self.m_nDir == CellTeachDialog.DIR_RIGHT then
		if ProjConfig.LANGUAGE == "es" then
			adjustX = adjustX + widthArrow * xScale * scaleOffset2 - 10 /self.m_nMaxWidth
		else
			adjustX = adjustX + widthArrow * xScale * scaleOffset2 /self.m_nMaxWidth
		end
		self.m_root:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		if self.m_tSender then
			startX = startX + self.m_tSender:getContentSize().width/2 - 40
			startY = startY - self.m_tSender:getContentSize().height/2 - self.m_nMaxHeight / 2
		end
	elseif self.m_nDir == CellTeachDialog.DIR_LEFT then
		adjustX = adjustX + widthArrow * xScale * scaleOffset3 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(GlobalMethod:ccp(1,0.5))
		
		if self.m_tSender then
			startX = startX - self.m_tSender:getContentSize().width/2
		end
	end

	ttf:setRelativePosition(GlobalMethod:ccp(adjustX, adjustY))
    
    --WZLog("CellTeachDialog:onEnter zero", self.m_sText, adjustX, adjustY, string.len(self.m_sText), xScale, size.width, self.m_nMaxWidth, self.m_nMaxWidth - widthDis * xScale)

    ttfClick:setRelativePosition(GlobalMethod:ccp(adjustX, -0.2))

	local _9img = WZUI9Image:create()
    _9img:setCapInsets(CCRectMake(0,0,0,0))
    _9img:setFile(CellTeachDialog.DIMG)

    local imgContainer = WZUIContainer:create()
    self.m_root:addChild(imgContainer)
    imgContainer:setContentSize(GlobalMethod:CCSize(self.m_nMaxWidth,self.m_nMaxHeight))
    imgContainer:addChild(_9img)

    local point = GlobalMethod:ccp(startX + self.m_nOffsetX, startY + self.m_nOffsetY)

    local arrowX,arrowY = 0.5,0.5
    if self.m_nDir == CellTeachDialog.DIR_RIGHT then
        arrowX = -28
        arrowY = 0.5 * imgContainer:getContentSize().height * imgContainer:getScale()
        point.x = point.x + 25
    elseif self.m_nDir == CellTeachDialog.DIR_LEFT then
        arrowX = 28 + imgContainer:getContentSize().width * imgContainer:getScale()
        arrowY = 0.5 * imgContainer:getContentSize().height * imgContainer:getScale()
        point.x = point.x - 25
    elseif self.m_nDir == CellTeachDialog.DIR_UP then
        arrowX = 0.5 * imgContainer:getContentSize().width * imgContainer:getScale()
        arrowY = -30
        point.x = point.x + 43
        point.y = point.y + 60
    elseif self.m_nDir == CellTeachDialog.DIR_DOWN then
        arrowX = 0.5 * imgContainer:getContentSize().width * imgContainer:getScale()
        arrowY = imgContainer:getContentSize().height * imgContainer:getScale() + 30
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
	--WZLog("CellTeachDialog_onEnter one", self.m_sText, tostring(self.m_bIsOriScale),scaleX,scaleY, self.m_nMaxWidth, self.m_nMaxHeight, startX, startY, point.x, point.y, adjustX, adjustY, tostring(self.m_nOffsetX), tostring(self.m_nOffsetY))

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTeachDialog:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	更新函数
function CellTeachDialog:updatePos(element,dt)
    --WZLog("CellTeachDialog:updatePos",dt,  tostring(self.m_tFollowObj:getPosition().x), tostring(self.m_tFollowObj:getPosition().y), self.m_tOriginalPos.x, self.m_tOriginalPos.y, self.m_tFollowObj.m_sPlayerName, self.m_tFollowObj.m_nBattleId)
    
end

function CellTeachDialog:playScaleAction()
	
	local ttf = self.m_root:getChildElement("txtContent_CellTeachDialog")
	
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

function CellTeachDialog:scaleCallBack(element)
	local ttf = self.m_root:getChildElement("txtContent_CellTeachDialog")
	
	ttf:setVisible(true)
	
	if self.m_nShowTime >= 0 then
		self.m_root:enableSchedule("timeCallBack",self.m_nShowTime)
	end
	
	if self.m_bJump then
		local jumpTo = WZUIActionJumpTo:create()
		jumpTo:setPosition( GlobalMethod:ccp( element:getPositionX(),element:getPositionY() ) )
		jumpTo:setHeight(40)
		jumpTo:setJumps(10000)
		jumpTo:setDuration(10000)
		element:runUIAction(jumpTo)
	end
end

function CellTeachDialog:timeCallBack(element,dt)
	self:removeDialog(true)
end

--@brief	移除对话框
function CellTeachDialog:removeDialog(bClean)

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
