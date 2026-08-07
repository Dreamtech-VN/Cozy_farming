--WndFourStarRuleDesc.lua
--@brief	WndFourStarRuleDesc的UI模块
--@date		2021/02/26
--@author	hyx
--@note		规则说明


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFourStarRuleDesc:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFourStarRuleDesc:onExit(element)
	self:_unInit()
end
function WndFourStarRuleDesc:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

function WndFourStarRuleDesc:onBtnClose( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.func then
		self.func()
	end
	WindowManager:removeWindow(self.m_root , self , true)	
end

--@brief	外部接口函数
--@param    #1 desc:规则说明内容
function WndFourStarRuleDesc:showInterface(desc, func, otherInfo)
	if desc == nil or desc == "" then return end
	if self.m_root == nil then
		local wndRuleDesc = WndFourStarRuleDesc:createElement()
		if wndRuleDesc == nil then
			return
		end
		WindowManager:addWindow( wndRuleDesc , WndFourStarRuleDesc ,nil ,nil ,nil ,false)
	end
	
	self.func = func
	if otherInfo then 
		if otherInfo.imgBg then 
			GetElement(self.m_root, "img9Bg_WndFourStarRuleDesc", WZUI9Image):setFile(otherInfo.imgBg)
		end
		if otherInfo.imgClose then 
			GetElement(self.m_root, "imgClose_WndFourStarRuleDesc", WZUIImage):setFile(otherInfo.imgClose)
		end
	end
	if string.find(desc,"<T") == nil then
		--使用普通标签
		self.m_sDesc =  WndSingleMapDesc:_changeDesc( desc )
		--	更新函数
		self:_update()
	else
		--使用富文本
    	GetElement(self.m_root, "txtDesc", WZUILabelTTF):setVisible(false)
    	GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setVisible(true)
    	GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setShowText(desc)
		--	更新滚动容器内部布局函数
		self:_upMoveContainerLayer()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	更新函数
function WndFourStarRuleDesc:_update()
	if self.m_root == nil then
		return
	end
	--	更新规则说明内容函数
	self:_setRuleDesc( self.m_sDesc )
	--	更新滚动容器内部布局函数
	

	--获取规则说明内容文本的大小
	local txtExplanation = self.m_root:getChildElement("txtDesc")
	if txtExplanation == nil then
		return
	end
	txtExplanation = WZUILabelTTF:luaTo(txtExplanation)	
	local txtSize = txtExplanation:getLabelContentSize()	
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndFourStarRuleDesc")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize( size.width , txtSize.height / rollSize.height ) )
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
end
--@brief 	更新规则说明内容函数
function WndFourStarRuleDesc:_setRuleDesc( desc )
	if self.m_root == nil then
		return
	end
	local txtExplanation = self.m_root:getChildElement("txtDesc")
	if txtExplanation == nil then
		return
	end
	txtExplanation = WZUILabelTTF:luaTo(txtExplanation)
	txtExplanation:setText( desc )
end

--@brief  	更新滚动容器内部布局函数
function WndFourStarRuleDesc:_upMoveContainerLayer()
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(GlobalMethod:ccp(0,1))
	txtExplanation:setPositionY(txtSize.height-5)
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndFourStarRuleDesc")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1, txtSize.height / rollSize.height ) )
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
end

-------------------------------------私有方法模块End----------------------------------------
