--WndWelcomeBackDesc.lua
--@brief	WndWelcomeBackDesc的UI模块
--@date		2023/03/09
--@author	yrd
--@note		欢迎回来活动说明


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWelcomeBackDesc:onEnter(element)
	self.m_root = element
end

function WndWelcomeBackDesc:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWelcomeBackDesc:onExit(element)
	self:_unInit()
end

--@brief	点击关闭
function WndWelcomeBackDesc:onClickClose( element )
	WZLog("WndWelcomeBackDesc:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManagerAni:createCloseAction(self.m_root,"oncloseani",self)
end


function WndWelcomeBackDesc:actionCallback( )
end

function WndWelcomeBackDesc:oncloseani( )
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root, self, true)	
end

--@brief	外部接口函数
--@param    #1 desc:规则说明内容
--@param 	bAddBuyBtn : 增加购买纪念币购买按钮
function WndWelcomeBackDesc:showInterface(desc)
	WZLog("WndWelcomeBackDesc:showInterface")
	if desc == nil or desc == "" then return end
	if self.m_root == nil then
		local WndWelcomeBackDescElement= WndWelcomeBackDesc:createElement()
		if WndWelcomeBackDescElement == nil then
			return
		end
		WindowManager:addWindow( WndWelcomeBackDescElement , WndWelcomeBackDesc ,nil ,nil ,nil ,false)
	end
	
	if string.find(desc,"<T") == nil then
		--使用普通标签
		self.m_sDesc =  self:_changeDesc( desc )
		--	更新函数
		self:_update()
	else
		--使用富文本
    	GetElement(self.m_root, "txtDesc", WZUILabelTTF):setVisible(false)
    	GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setVisible(true)
    	GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setShowText(desc)
		--	更新滚动容器内部布局函数
		self:_upMoveContainerLayer1()
    end
end

--@brief  	更新滚动容器内部布局函数
function WndWelcomeBackDesc:_upMoveContainerLayer()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtSize = self:_getRuleDescSize()
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndWelcomeBackDesc")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize( size.width , (txtSize.height+5) / rollSize.height ) )
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
end

--@brief  	更新滚动容器内部布局函数
function WndWelcomeBackDesc:_upMoveContainerLayer1()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0.5,1))
	txtExplanation:setPositionY(txtSize.height)
	WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
--
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndWelcomeBackDesc")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1 , (txtSize.height+5) / rollSize.height ) )
	--moveElement:setContentSize(txtSize)
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
	WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

--@brief 	更新函数
function WndWelcomeBackDesc:_update()
	WZLog("WndWelcomeBackDesc:_update")
	if self.m_root == nil then
		return
	end
	--	更新规则说明内容函数
	self:_setRuleDesc( self.m_sDesc )
	--	更新滚动容器内部布局函数
	self:_upMoveContainerLayer()
end

--@brief 	更新规则说明内容函数
function WndWelcomeBackDesc:_setRuleDesc( desc )
	WZLog("WndWelcomeBackDesc:_setRuleDesc")
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

--@brief    获取规则说明内容文本的大小函数
--@return   size :返回说明文本的size
function WndWelcomeBackDesc:_getRuleDescSize()
	if self.m_root == nil then
		return
	end
	local txtExplanation = self.m_root:getChildElement("txtDesc")
	if txtExplanation == nil then
		return
	end
	txtExplanation = WZUILabelTTF:luaTo(txtExplanation)	
	local size = txtExplanation:getLabelContentSize()	
	return size
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
