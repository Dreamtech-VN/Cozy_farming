--CellDialog.lua
--@brief	CellDialog的UI模块
--@date		2014/09/17
--@author	莫剑峰
--@note		对话框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDialog:onEnter(element)
    
	self.m_root = element
    local len = string.len(self.m_sText)
	local xScale = self.m_nTextLength or (24 * (len/3+1) / 188)

	if self.m_bIsTalkMode then
		len = len > 90 and 90 or len 
		xScale = (25 * (len/3+1) / 188)
		
		WZLog("CellDialog:onEnter one", len, xScale)
	end

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
    bg:setFile(CellDialog.DIMG)
    self.m_root:addChild(bg)
    bg:setVisible(false)
	
	local size = CCSize(188,70)--bg:getContentSize()
	
	local ttf = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtDesc_CellDialog")) 
	ttf:setText(self.m_sText)
	if "th" == ProjConfig.LANGUAGE or "tr" == ProjConfig.LANGUAGE then
    	xScale = ttf:getLabelContentSize().width <= 176 and (ttf:getLabelContentSize().width + 24) / 188 or 13 * 25 /188
    elseif "vn" == ProjConfig.LANGUAGE then
        xScale = ttf:getLabelContentSize().width <= 176 and (ttf:getLabelContentSize().width + 24) / 188 or 10 * 25 /188
    elseif "es" == ProjConfig.LANGUAGE or "pt" == ProjConfig.LANGUAGE or "en" == ProjConfig.LANGUAGE then
        xScale = ttf:getLabelContentSize().width <= 176 and (ttf:getLabelContentSize().width + 24) / 188 or 13 * 25 /188
    end
    self.m_nMaxWidth = size.width * xScale

    local ttfClick = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtClick_CellDialog"))
    ttfClick:setVisible(self.m_bIsNeedClick == true)
    ttfClick:setText("")
	if self.m_nDir == CellDialog.DIR_UP or self.m_nDir == CellDialog.DIR_DOWN then
		ttf:setDimensions( CCSize(self.m_nMaxWidth - 24 - widthDis * xScale , 0 ) )
	elseif self.m_nDir == CellDialog.DIR_LEFT or self.m_nDir == CellDialog.DIR_RIGHT then
		ttf:setDimensions( CCSize(self.m_nMaxWidth - 24 - widthDis * xScale , 0 ) )
	end
    
    self.m_nMaxHeight = heightDis + ttf:getContentSize().height 
	self.m_root:setContentSize(CCSize(self.m_nMaxWidth,self.m_nMaxHeight))
	
	if self.m_nDir == CellDialog.DIR_DOWN then
		adjustX = adjustX + widthArrow * xScale * scaleOffset1 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(ccp(0.5,1))
		if self.m_tSender then
			startY = startY - self.m_tSender:getContentSize().height/2
		end
	elseif self.m_nDir == CellDialog.DIR_UP then
		adjustX = adjustX + widthArrow * xScale * scaleOffset1 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(ccp(0.5,0))
		if self.m_tSender then
			startY = startY + self.m_tSender:getContentSize().height/2
		end
	elseif self.m_nDir == CellDialog.DIR_RIGHT then
		adjustX = adjustX + widthArrow * xScale * scaleOffset2 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(ccp(0,0.5))
		if self.m_tSender then
			startX = startX + self.m_tSender:getContentSize().width/2 - 40
			startY = startY - self.m_tSender:getContentSize().height/2 - self.m_nMaxHeight / 2
		end
	elseif self.m_nDir == CellDialog.DIR_LEFT then
		adjustX = adjustX + widthArrow * xScale * scaleOffset3 /self.m_nMaxWidth
		self.m_root:setAnchorPoint(ccp(1,0.5))
		
		if self.m_tSender then
			startX = startX - self.m_tSender:getContentSize().width/2
		end
	end

	ttf:setRelativePosition(ccp(adjustX, adjustY))

    --WZLog("CellDialog:onEnter zero", self.m_sText, adjustX, adjustY, string.len(self.m_sText), xScale, size.width, self.m_nMaxWidth, self.m_nMaxWidth - widthDis * xScale)

    ttfClick:setRelativePosition(ccp(adjustX, -0.2))

	local _9img = WZUI9Image:create()
    _9img:setCapInsets(CCRectMake(0,0,0,0))
    _9img:setFile(CellDialog.DIMG)

    local imgContainer = WZUIContainer:create()
    self.m_root:addChild(imgContainer)
    imgContainer:setContentSize(CCSize(self.m_nMaxWidth,self.m_nMaxHeight))
    imgContainer:addChild(_9img)

    local point = ccp(startX + self.m_nOffsetX, startY + self.m_nOffsetY)

    local arrowX,arrowY = 0.5,0.5
    if self.m_nDir == CellDialog.DIR_RIGHT then
        arrowX = -28
        arrowY = 0.5 * imgContainer:getContentSize().height * imgContainer:getScale()
        point.x = point.x + 25
    elseif self.m_nDir == CellDialog.DIR_LEFT then
        arrowX = 28 + imgContainer:getContentSize().width * imgContainer:getScale()
        arrowY = 0.5 * imgContainer:getContentSize().height * imgContainer:getScale()
        point.x = point.x - 25
    elseif self.m_nDir == CellDialog.DIR_UP then
        arrowX = 0.5 * imgContainer:getContentSize().width * imgContainer:getScale()
        arrowY = -30
        point.x = point.x + 43
        point.y = point.y + 60
    elseif self.m_nDir == CellDialog.DIR_DOWN then
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
	--WZLog("CellDialog_onEnter one", self.m_sText, tostring(self.m_bIsOriScale),scaleX,scaleY, self.m_nMaxWidth, self.m_nMaxHeight, startX, startY, point.x, point.y, adjustX, adjustY, tostring(self.m_nOffsetX), tostring(self.m_nOffsetY))

end

--@brief 反方向设置
function CellDialog:setDirBack()
	if self.m_nDir == CellDialog.DIR_RIGHT then
		self.m_root:setAnchorPoint(ccp(1,0.5))
		self.m_nDir = CellDialog.DIR_LEFT
	elseif self.m_nDir == CellDialog.DIR_LEFT then
		self.m_root:setAnchorPoint(ccp(0,0.5))
		self.m_nDir = CellDialog.DIR_RIGHT
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDialog:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	更新函数
function CellDialog:updatePos(element,dt)
    --WZLog("CellDialog:updatePos",dt,  tostring(self.m_tFollowObj:getPosition().x), tostring(self.m_tFollowObj:getPosition().y), self.m_tOriginalPos.x, self.m_tOriginalPos.y, self.m_tFollowObj.m_sPlayerName, self.m_tFollowObj.m_nBattleId)
    
end

function CellDialog:playScaleAction()
	WZLog("removeDialog4")
	
	local ttf = self.m_root:getChildElement("txtContent_CellDialog")
	
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

function CellDialog:scaleCallBack(element)
	WZLog("removeDialog3")
	local ttf = self.m_root:getChildElement("txtContent_CellDialog")
	
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

function CellDialog:timeCallBack(element,dt)
	self:removeDialog(true)
	WZLog("removeDialog1")
end

--@brief	移除对话框
function CellDialog:removeDialog(bClean)
	WZLog("removeDialog0")

	if self.m_tBackSender and self.m_tBackFunction then
		self.m_tBackFunction(self.m_tBackSender)
	end
	
	if bClean and self.m_root then
		if self.m_tFollowObj and self.m_tFollowObj.m_mover then
			self.m_tFollowObj.m_mover:removeTrackNode(self.m_trackNode)
		end
		self.m_tFollowObj.m_tDialogElement = nil
		self.m_root:removeFromParentAndCleanup(true)
	elseif self.m_root then
		self.m_root:setVisible(false)
		self.m_root:enableSchedule("timeCallBack",0.5)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
