--CellBattleTeachDialog.lua
--@brief	CellBattleTeachDialog的UI模块
--@date		2015/09/18
--@author	莫剑峰
--@note		对话框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBattleTeachDialog:onEnter(element)
    WZLog("CellBattleTeachDialog:onEnter")
	self.m_root = element
	--设置图片
	local bg = WZUIImage:create()
	bg:setUseOriginSize(true)
	if self.m_nDir == CellBattleTeachDialog.DIR_DOWN  or self.m_nDir == CellBattleTeachDialog.DIR_LEFTDOWN  then
		bg:setFlipY(true)
		bg:setFile(CellBattleTeachDialog.DIMG)
        WZLog("CellBattleTeachDialog:onEnter 1")
	elseif self.m_nDir == CellBattleTeachDialog.DIR_UP then
		bg:setFile(CellBattleTeachDialog.DIMG)
        WZLog("CellBattleTeachDialog:onEnter 2")
	elseif self.m_nDir == CellBattleTeachDialog.DIR_RIGHT then
		bg:setFlipX(true)
		bg:setFile(CellBattleTeachDialog.RIMG)
        WZLog("CellBattleTeachDialog:onEnter 3")
	elseif self.m_nDir == CellBattleTeachDialog.DIR_LEFT then
		bg:setFile(CellBattleTeachDialog.RIMG)
        WZLog("CellBattleTeachDialog:onEnter 4")
	elseif self.m_nDir == CellBattleTeachDialog.DIR_CENTER then
		bg:setFile(CellBattleTeachDialog.CIMG)
        WZLog("CellBattleTeachDialog:onEnter 5")
	end
	self.m_root:addChild(bg)
    bg:setVisible(false)
    
	local size = bg:getContentSize()
	if self.m_nDir == CellBattleTeachDialog.DIR_CENTER then
		bg:setScale(CellBattleTeachDialog.CENTER_SCALE)
		self.m_nMaxWidth = size.width * bg:getScale()
		self.m_nMaxHeight = size.height * bg:getScale()
	end
	
	self.m_nMaxWidth = self.m_nMaxWidth  or size.width * bg:getScale()
	
	local xScale = self.m_nMaxWidth/size.width
	
	local ttf = WZUILabelTTF:create()
	
	local widthDis = 16
	local widthArrow = 20
	if self.m_nDir == CellBattleTeachDialog.DIR_UP or self.m_nDir == CellBattleTeachDialog.DIR_DOWN or self.m_nDir == CellBattleTeachDialog.DIR_LEFTDOWN  then
		ttf:setDimensions( CCSize(self.m_nMaxWidth - widthDis * xScale , 0 ) )
	elseif self.m_nDir == CellBattleTeachDialog.DIR_CENTER then
		ttf:setDimensions( CCSize(self.m_nMaxWidth - 105 * xScale , 0 ) )
	else
		ttf:setDimensions( CCSize(self.m_nMaxWidth - (widthDis + widthArrow) * xScale , 0 ) )
	end
	
	ttf:setAlignment(kCCTextAlignmentLeft)
	if self.m_tTxtColor then
		ttf:setColor(ccc3(self.m_tTxtColor.r or 58 , self.m_tTxtColor.g or 0 ,self.m_tTxtColor.b or 0 ) )
	else
		ttf:setColor(ccc3(58 , 0 , 0 ) )
	end
	if self.m_nDir == CellBattleTeachDialog.DIR_CENTER then
		ttf:setAnchorPoint(ccp(0,0.5))
	else
		ttf:setAnchorPoint(ccp(0.5,0.5))
	end
	WZLog("CellBattleTeachDialog:onEnter")
	ttf:setFontSize(22)
	ttf:setZOrder(1)
	ttf:setName("txtContent_CellBattleTeachDialog")
	ttf:setText(self.m_sText)
	self.m_root:addChild(ttf)

	local heightDis = 20
	local heightArrow = 40
	local heightLimit = 50
	if self.m_nDir ~= CellBattleTeachDialog.DIR_CENTER then
		if self.m_nDir == CellBattleTeachDialog.DIR_DOWN or self.m_nDir == CellBattleTeachDialog.DIR_UP or self.m_nDir == CellBattleTeachDialog.DIR_LEFTDOWN  then
			heightDis = heightDis + heightArrow
			heightLimit = heightLimit + heightArrow
		end
		
		if heightDis + ttf:getContentSize().height < heightLimit then
			heightDis = heightLimit - ttf:getContentSize().height
		end
		self.m_nMaxHeight = heightDis + ttf:getContentSize().height
	end
	
	self.m_root:setContentSize(CCSize(self.m_nMaxWidth,self.m_nMaxHeight))
	
	local imgContainer
	local yScale = self.m_nMaxHeight/size.height
	local imgScale = self.m_nMaxHeight/size.height
	if self.m_nDir ~= CellBattleTeachDialog.DIR_CENTER then
		imgContainer = WZUIContainer:create()
		self.m_root:addChild(imgContainer)
		imgContainer:setContentSize(CCSize(self.m_nMaxWidth/imgScale,self.m_nMaxHeight/imgScale))
		imgContainer:setScale(imgScale)
	end
	
	local adjustX,adjustY
	if self.m_nDir == CellBattleTeachDialog.DIR_CENTER then
		adjustX = 70 * bg:getScaleX() /self.m_nMaxWidth
		adjustY = 0.5
	else
		adjustX = 0.5
		adjustY = 0.5
	end
	
	local startX = 0
	local startY = 0
	if self.m_tSender then
		startX = self.m_tSender:getPositionX()
		startY = self.m_tSender:getPositionY()
	end
	if self.m_nDir == CellBattleTeachDialog.DIR_DOWN or self.m_nDir == CellBattleTeachDialog.DIR_LEFTDOWN  then
	
		adjustY = adjustY - heightArrow * yScale * 0.5 /self.m_nMaxHeight
		
		self.m_root:setAnchorPoint(ccp(0.7,1))
		
		if self.m_tSender then
			startY = startY - self.m_tSender:getContentSize().height/2
		end
		
	elseif self.m_nDir == CellBattleTeachDialog.DIR_UP then
	
		adjustY = adjustY + heightArrow * yScale * 0.5 /self.m_nMaxHeight
	
		self.m_root:setAnchorPoint(ccp(0.7,0))
		
		if self.m_tSender then
			startY = startY + self.m_tSender:getContentSize().height/2
		end
		
	elseif self.m_nDir == CellBattleTeachDialog.DIR_RIGHT then
	
		adjustX = adjustX + widthArrow * xScale * 0.5 /self.m_nMaxWidth
		
		self.m_root:setAnchorPoint(ccp(0,0.7))
		
		if self.m_tSender then
			startX = startX + self.m_tSender:getContentSize().width/2
		end
		
	elseif self.m_nDir == CellBattleTeachDialog.DIR_LEFT then
		
		adjustX = adjustX - widthArrow * xScale * 0.5 /self.m_nMaxWidth
		
		self.m_root:setAnchorPoint(ccp(1,0.7))
		
		if self.m_tSender then
			startX = startX - self.m_tSender:getContentSize().width/2
		end
	elseif self.m_nDir == CellBattleTeachDialog.DIR_CENTER then
	
		self.m_root:setAnchorPoint(ccp(0.5,0.5))
		
	end
	
	ttf:setRelativePosition(ccp(adjustX, adjustY))
	
	local _9img = WZUI9Image:create()
	if self.m_nDir == CellBattleTeachDialog.DIR_DOWN then
		_9img:setCapInsets(CCRectMake(40,100,40,40))
		_9img:setScaleY(-1)
		_9img:setFile(CellBattleTeachDialog.DIMG)
	elseif self.m_nDir == CellBattleTeachDialog.DIR_UP then
		_9img:setCapInsets(CCRectMake(40,100,40,40))
		_9img:setFile(CellBattleTeachDialog.DIMG)
	elseif self.m_nDir == CellBattleTeachDialog.DIR_RIGHT then
		_9img:setCapInsets(CCRectMake(40,100,40,40))
		_9img:setScaleX(-1)
		_9img:setFile(CellBattleTeachDialog.RIMG)
	elseif self.m_nDir == CellBattleTeachDialog.DIR_LEFT then
		_9img:setCapInsets(CCRectMake(40,100,40,40))
		_9img:setFile(CellBattleTeachDialog.RIMG)
	elseif self.m_nDir == CellBattleTeachDialog.DIR_LEFTDOWN then
		_9img:setCapInsets(CCRectMake(40,100,40,40))
		_9img:setScaleY(-1)
		_9img:setScaleX(-1)
		_9img:setFile(CellBattleTeachDialog.DIMG)
	end
	--[[
	local _9img 
	if self.m_nDir == CellBattleTeachDialog.DIR_DOWN then
	
		_9img = CCScale9Sprite:create(CellBattleTeachDialog.DIMG,  imgContainer:getContentSize(), CCRectMake(40,100,40,40))
		_9img:setScaleY(-1)
		
	elseif self.m_nDir == CellBattleTeachDialog.DIR_UP then
	
		_9img = CCScale9Sprite:create(CellBattleTeachDialog.DIMG,  imgContainer:getContentSize(), CCRectMake(40,100,40,40))
		
	elseif self.m_nDir == CellBattleTeachDialog.DIR_RIGHT then
	
		_9img = CCScale9Sprite:create(CellBattleTeachDialog.RIMG,  imgContainer:getContentSize(), CCRectMake(40,100,40,40))
		_9img:setScaleX(-1)
		
	elseif self.m_nDir == CellBattleTeachDialog.DIR_LEFT then
	
		_9img = CCScale9Sprite:create(CellBattleTeachDialog.RIMG,  imgContainer:getContentSize(), CCRectMake(40,100,40,40))
		
	end
	]]
	if self.m_nDir == CellBattleTeachDialog.DIR_CENTER then
		self.m_root:addChild(bg)
	else
		imgContainer:addChild(_9img)
	end
	
	local point = ccp(startX + self.m_nOffsetX, startY + self.m_nOffsetY)
	
	if self.m_tSender then
		point = self.m_tSender:getParent():convertToWorldSpace(point)

		point = self.m_tParent:convertToNodeSpace(point)
	end
	self.m_root:setPosition(ccp(0,0))
	
	self:playScaleAction()
	
    WZLog("CellBattleTeachDialog:onEnter two", startX + self.m_nOffsetX, startY + self.m_nOffsetY)
    if self.m_bIsUpdatePos == true then
        self.m_tFollowObjOriginalPos = ccp(self.m_tFollowObj:getPosition().x, self.m_tFollowObj:getPosition().y)
        self.m_tOriginalPos = point
       self.m_root:enableSchedule("updatePos", 0) 
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBattleTeachDialog:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	更新函数
function CellBattleTeachDialog:updatePos(element,dt)
    --WZLog("CellBattleTeachDialog:updatePos",dt,  tostring(self.m_tFollowObj:getPosition().x), tostring(self.m_tFollowObj:getPosition().y), self.m_tOriginalPos.x, self.m_tOriginalPos.y, self.m_tFollowObj.m_sPlayerName, self.m_tFollowObj.m_nBattleId)
    
end

function CellBattleTeachDialog:playScaleAction()
	
	local ttf = self.m_root:getChildElement("txtContent_CellBattleTeachDialog")
	
	ttf:setVisible(true)
	
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

function CellBattleTeachDialog:scaleCallBack(element)
	local ttf = self.m_root:getChildElement("txtContent_CellBattleTeachDialog")
	
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

function CellBattleTeachDialog:timeCallBack(element,dt)
	self:removeDialog(true)
end

--@brief	移除对话框
function CellBattleTeachDialog:removeDialog(bClean)

	if self.m_tBackSender and self.m_tBackFunction then
		self.m_tBackFunction(self.m_tBackSender)
	end
	
	if bClean and self.m_root then
		self.m_root:removeFromParentAndCleanup(true)
	elseif self.m_root then
		self.m_root:setVisible(true)
		self.m_root:enableSchedule("timeCallBack",0.5)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
