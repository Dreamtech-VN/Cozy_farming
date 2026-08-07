--WndSingleInfo.lua
--@brief	WndSingleInfo的UI模块
--@date		2016-12-6
--@author	binshao
--@note		隐私说明


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSingleInfo:onEnter(element)
	self.m_root = element
end

function WndSingleInfo:onEnterTransitionDidFinish(element)
	--多语言版本界面适配
	AdaptLanguage(self)
	WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleInfo:onExit(element)
	self:_unInit()
end


function WndSingleInfo:onCloseClick( element )
	WZLog("WndSingleInfo:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WindowManagerAni:createCloseAction(self.m_root,"oncloseani",self)
end

function WndSingleInfo:oncloseani( )
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root , WndSingleInfo , true)	
end

--@brief	外部接口函数
--@param    #1 desc:规则说明内容
function WndSingleInfo:showInterface(desc,btnInfo)
	WZLog("WndSingleInfo:showInterface")
	if self.m_root == nil then
		local WndSingleInfoElement= WndSingleInfo:createElement()
		if WndSingleInfoElement == nil then
			return
		end
		WindowManager:addWindow( WndSingleInfoElement , WndSingleInfo ,nil ,nil ,nil ,false)
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

    self:_createBtn(btnInfo)
end

--@brief	外部接口函数,设置富文本框
--@param    #1 desc:规则说明内容
function WndSingleInfo:showInterface1(desc)
	WZLog("WndSingleInfo:showInterface1")
	if self.m_root == nil then
		local WndSingleInfoElement= WndSingleInfo:createElement()
		if WndSingleInfoElement == nil then
			return
		end
		WindowManager:addWindow( WndSingleInfoElement , WndSingleInfo,nil ,nil ,nil ,false )
	end

    GetElement(self.m_root, "txtDesc", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setVisible(true)
    GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setShowText(desc)
	--	更新滚动容器内部布局函数
	self:_upMoveContainerLayer1()
    self:_createBtn()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	更新函数
function WndSingleInfo:_update()
	WZLog("WndSingleInfo:_update")
	if self.m_root == nil then
		return
	end
	--	更新规则说明内容函数
	self:_setRuleDesc( self.m_sDesc )
	--	更新滚动容器内部布局函数
	self:_upMoveContainerLayer()
end

--@brief 	更新规则说明内容函数
function WndSingleInfo:_setRuleDesc( desc )
	WZLog("WndSingleInfo:_setRuleDesc")
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
function WndSingleInfo:_getRuleDescSize()
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

--@brief  	更新滚动容器内部布局函数
function WndSingleInfo:_upMoveContainerLayer()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtSize = self:_getRuleDescSize()
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndSingleMap")
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

--@brief  	更新滚动容器内部布局函数
function WndSingleInfo:_upMoveContainerLayer1()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0,1))
	txtExplanation:setPositionY(txtSize.height)
	WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
--
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndSingleMap")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1 , txtSize.height / rollSize.height ) )
	--moveElement:setContentSize(txtSize)
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
	WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

function WndSingleInfo:OnLeftBtn()
    if not self.callFunc[1] then
        self:onCloseClick()
    else
        self.callFunc[1][2](self.callFunc[1][1])
    end
end

function WndSingleInfo:OnRightBtn()
    if not self.callFunc[2] then
        self:onCloseClick()
    else
        self.callFunc[2][2](self.callFunc[2][1])
    end
end

-- btnInfo = {{txt = "123", callFunc = {tableName,callBack},{}}
function WndSingleInfo:_createBtn(btnInfo)
    local singleCon = GetElement(self.m_root,"conSingleBtn_WndSingleInfo",WZUIContainer)
    local doubleCon = GetElement(self.m_root,"conDoubleBtn_WndSingleInfo",WZUIContainer)
    local state = not btnInfo and true or false
    singleCon:setVisible(state)
    doubleCon:setVisible(not state)

    if btnInfo then
        for i = 1, 2 do
            local txt = GetElement(self.m_root,"txtBtn"..i.."_WndSingleInfo",WZUILabelTTF)
            txt:setText(btnInfo[i].txt)
            self.callFunc[i] = btnInfo[i].callFunc
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Began----------------------------------------
--@beief    泰语适配
function WndSingleInfo:_adaptLanguage_th( )
    GetElement(self.m_root,"txtDesc1",WZUIFreeTextBox):setMaxWidth(400)
end
-------------------------------------语言适配模块End----------------------------------------
