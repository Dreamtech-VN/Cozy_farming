--WndSingleMapDesc.lua
--@brief	WndSingleMapDesc的UI模块
--@date		2014/04/28
--@author	LYQ
--@note		单人副本说明


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSingleMapDesc:onEnter(element)
	self.m_root = element
end

function WndSingleMapDesc:onEnterTransitionDidFinish(element)
	--多语言版本界面适配
	AdaptLanguage(self)
	WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSingleMapDesc:onExit(element)
	self:_unInit()
end


function WndSingleMapDesc:onCloseClick( element )
	WZLog("WndSingleMapDesc:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
    WindowManagerAni:createCloseAction(self.m_root,"oncloseani",self)
end

function WndSingleMapDesc:oncloseani( )
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root , WndSingleMapDesc , true)	
end

--@brief	外部接口函数
--@param    #1 desc:规则说明内容
--@param 	bAddBuyBtn : 增加购买纪念币购买按钮
function WndSingleMapDesc:showInterface(desc,btnInfo, bAddBuyBtn)
	WZLog("WndSingleMapDesc:showInterface")
	if desc == nil or desc == "" then return end
	if self.m_root == nil then
		local WndSingleMapDescElement= WndSingleMapDesc:createElement()
		if WndSingleMapDescElement == nil then
			return
		end
		self.m_bIsAddBuyBtn = bAddBuyBtn
		WindowManager:addWindow( WndSingleMapDescElement , WndSingleMapDesc ,nil ,nil ,nil ,false)
	end
	
	self:_resetScrollContainerSize()
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
--@param 	bAddBuyBtn : 增加购买纪念币购买按钮
function WndSingleMapDesc:showInterface1(desc, bAddBuyBtn)
	WZLog("WndSingleMapDesc:showInterface1")
	if self.m_root == nil then
		local WndSingleMapDescElement= WndSingleMapDesc:createElement()
		if WndSingleMapDescElement == nil then
			return
		end
		self.m_bIsAddBuyBtn = bAddBuyBtn
		WindowManager:addWindow( WndSingleMapDescElement , WndSingleMapDesc,nil ,nil ,nil ,false )
	end

	self:_resetScrollContainerSize()

    GetElement(self.m_root, "txtDesc", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setVisible(true)
    GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox):setShowText(desc)
	--	更新滚动容器内部布局函数
	self:_upMoveContainerLayer1()
    self:_createBtn()
end

--@brief 	点击购买按钮回调
function WndSingleMapDesc:onClickBuy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndVip:showInterface(2)
	self:oncloseani()
	-- local tData = CacheCenter:getMarkCoinRechargeData() 
	-- if tData == nil then return end 
	-- if tData.leftTimes == 0 then
 --        MsgBoxManager:showTipBox(LocalStrings.NEWACTIVITY_TEXT3)
 --        return 
 --    end
 --    --背包已满提示
 --    if CacheCenter:getRemainAmount() <= 0 then
 --        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
 --        return
 --    end
 --    self:oncloseani( )
    
	-- WndVip:createLoadingUI()
	-- PostPlayerEvent:postEvent(PostPlayerEvent.event_clickPay)
 --    local sdkData = {}
 --    local vipData = GDatatab_recharge["id_" .. tData.ids]
 --    sdkData.id = tData.ids
 --    sdkData.price = vipData.price
 --    sdkData.productName = vipData.name
 --    sdkData.payCode = vipData.pay_code_id
 --    sdkData.quantifier = LocalStrings.SHOP_IND
 --    sdkData.number = "1"
 --    sdkData.giftNumber = "0"
 --    sdkData.productDesc = vipData.name

 --    PassportSdkManager:getOrderNum(sdkData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	更新函数
function WndSingleMapDesc:_update()
	WZLog("WndSingleMapDesc:_update")
	if self.m_root == nil then
		return
	end
	--	更新规则说明内容函数
	self:_setRuleDesc( self.m_sDesc )
	--	更新滚动容器内部布局函数
	self:_upMoveContainerLayer()
end

--@brief 	更新规则说明内容函数
function WndSingleMapDesc:_setRuleDesc( desc )
	WZLog("WndSingleMapDesc:_setRuleDesc")
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
function WndSingleMapDesc:_getRuleDescSize()
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
function WndSingleMapDesc:_upMoveContainerLayer()
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
function WndSingleMapDesc:_upMoveContainerLayer1()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0,1))
	txtExplanation:setPositionY(txtSize.height-5)
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

function WndSingleMapDesc:OnLeftBtn()
    if not self.callFunc[1] then
        self:onCloseClick()
    else
        self.callFunc[1][2](self.callFunc[1][1])
    end
end

function WndSingleMapDesc:OnRightBtn()
    if not self.callFunc[2] then
        self:onCloseClick()
    else
        self.callFunc[2][2](self.callFunc[2][1])
    end
end

-- btnInfo = {{txt = "123", callFunc = {tableName,callBack},{}}
function WndSingleMapDesc:_createBtn(btnInfo)
    local singleCon = GetElement(self.m_root,"conSingleBtn_WndSingleMapDesc",WZUIContainer)
    local doubleCon = GetElement(self.m_root,"conDoubleBtn_WndSingleMapDesc",WZUIContainer)
    local state = not btnInfo and true or false
    singleCon:setVisible(state)
    doubleCon:setVisible(not state)

    if btnInfo then
        for i = 1, 2 do
            local txt = GetElement(self.m_root,"txtBtn"..i.."_WndSingleMapDesc",WZUILabelTTF)
            txt:setText(btnInfo[i].txt)
            self.callFunc[i] = btnInfo[i].callFunc
        end
    end
end

--@brief 	重新设置说明内容容器的大小
function WndSingleMapDesc:_resetScrollContainerSize()
	-- body
	if self.m_bIsAddBuyBtn then 
		GetElement(self.m_root, "conBuyBtn_WndSingleMapDesc", WZUIContainer):setVisible(true)
		local conRuleDetail = GetElement(self.m_root, "conRuleDetail_WndSingleMapDesc", WZUIContainer)
		if conRuleDetail then 
			conRuleDetail:setRelativeSize(GlobalMethod:CCSize(0.9, 0.58))
			conRuleDetail:updateRelativeSize()
		end
	else
		GetElement(self.m_root, "conBuyBtn_WndSingleMapDesc", WZUIContainer):setVisible(false)
	end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Began----------------------------------------
--@beief    泰语适配
function WndSingleMapDesc:_adaptLanguage_th( )
    GetElement(self.m_root,"txtDesc1",WZUIFreeTextBox):setMaxWidth(400)

    GetElement(self.m_root,"imgArrow1_WndSingleMapDesc",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.3,0.908))
    GetElement(self.m_root,"imgArrow2_WndSingleMapDesc",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.7,0.908))
end

function WndSingleMapDesc:_adaptLanguage_en( )
    GetElement(self.m_root,"imgArrow1_WndSingleMapDesc",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.3,0.908))
    GetElement(self.m_root,"imgArrow2_WndSingleMapDesc",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.7,0.908))
end

function WndSingleMapDesc:_adaptLanguage_pt( )
	GetElement(self.m_root,"imgArrow1_WndSingleMapDesc",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.3,0.908))
    GetElement(self.m_root,"imgArrow2_WndSingleMapDesc",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.7,0.908))

    for i = 1, 3 do
    	GetElement(self.m_root, "txtConfirm"..i.."_WndSingleMapDesc", WZUILabelTTF):setScale(0.9)
    end
end

function WndSingleMapDesc:_adaptLanguage_es( )
    GetElement(self.m_root,"imgArrow1_WndSingleMapDesc",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.908))
    GetElement(self.m_root,"imgArrow2_WndSingleMapDesc",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.72,0.908))
end
-------------------------------------语言适配模块End----------------------------------------
