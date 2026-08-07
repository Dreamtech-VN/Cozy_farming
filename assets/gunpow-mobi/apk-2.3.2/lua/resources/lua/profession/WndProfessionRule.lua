--WndProfessionRule.lua
--@brief	WndProfessionRule的UI模块
--@date		2019/11/14
--@author	Tianxiang_Xu
--@note		职业说明、预览、重置、转职界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndProfessionRule:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndProfessionRule:onExit(element)
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndProfessionRule:onEnterTransitionDidFinish(element)
	--body
	self:getCanPreviewProfession()

	self:_showContent(self.m_nParamDesc)
end

function WndProfessionRule:onCloseClick( element )
	WZLog("WndProfessionRule:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
    WindowManager:removeWindow(self.m_root, WndProfessionRule, true)	
end

--@brief 	选择职业
function WndProfessionRule:onClickChoose(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()

	self.m_nProfessionSel = nTag

	GetElement(self.m_root, "img9Sel1_WndProfessionRule", WZUI9Image):setVisible(false)
	GetElement(self.m_root, "img9Sel2_WndProfessionRule", WZUI9Image):setVisible(false)
	
	GetElement(self.m_root, "img9Sel" .. nTag .. "_WndProfessionRule", WZUI9Image):setVisible(true)
end

--@brief 	点击取消、转职按钮回调
function WndProfessionRule:onClickLeft(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nType == 1 then 
		local sConfig = CacheCenter:getGameParam().occupationalresetTransfer
		local string = string.sub(sConfig,2,-2) 
		local id = SplitStringWithSeparator(string,",")[1]
		local num = SplitStringWithSeparator(string,",")[2]
		local icon = GDatatab_item["id_" .. id].icon

		local returnPercentConfig = CacheCenter:getGameParam().occupationalsystemSecendRe
		string = string.sub(returnPercentConfig,2,-2) 
		local returnPercent1 = tonumber(SplitStringWithSeparator(string,",")[1])
		local returnPercent2 = tonumber(SplitStringWithSeparator(string,",")[2])
		local content = string.format(LocalStrings.PROFESSION_TEXT17, tonumber(num), icon, returnPercent1, GDatatab_item["id_85"].icon, GDatatab_item["id_85"].name, returnPercent1, GDatatab_item["id_95"].icon, GDatatab_item["id_95"].name)
		if WndProfession.m_nProfessionChangeTimes <= 1 then 
			content = string.format(LocalStrings.PROFESSION_TEXT26, 100)
		end
		MsgBoxManager:showConfirmBox(content, self, self.sureToChangeProfession)

		WindowManager:removeWindow(self.m_root, WndProfessionRule, true)
	else
		WindowManager:removeWindow(self.m_root, WndProfessionRule, true)
	end
end

--@brief 	确定转职
function WndProfessionRule:sureToChangeProfession()
	-- body
	local sConfig = CacheCenter:getGameParam().occupationalresetTransfer
	local string = string.sub(sConfig,2,-2) 
	local id = tonumber(SplitStringWithSeparator(string,",")[1])
	local num = tonumber(SplitStringWithSeparator(string,",")[2])

	if WndProfession.m_nProfessionChangeTimes <= 1 then 
		self:sureToUseDiamond()
	else
		if not JudgeMoneyIsEnough(id, num, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamond) then
			return 
		end

		self:sureToUseDiamond()
	end
end

--@brief 	确定用蓝钻代替粉钻转职
function WndProfessionRule:sureToUseDiamond()
	-- body
	WndProfession:_createLoading()

	ProtocolProcessorProfession:send_PROFESSION_Choose(0)
end

--@brief 	点击确定、预览按钮回调
function WndProfessionRule:onClickRight(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 1 then 
		WndProfessionRule:showInterface(2)
	else
		if self.m_nProfessionSel == nil then 
			MsgBoxManager:showTipBox(LocalStrings.PROFESSION_TEXT5)
		else
			WndProfession:_showPreview(self.m_tLeftProfession[self.m_nProfessionSel][1])

			WindowManager:removeWindow(self.m_root, WndProfessionRule, true)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	显示
function WndProfessionRule:_showContent(desc)
	-- body
	if self.m_nType == 1 then 
		GetElement(self.m_root, "conMid_WndProfessionRule", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "conPreview_WndProfessionRule", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "txtBtnLeft_WndProfessionRule", WZUILabelTTF):setText(LocalStrings.PROFESSION_TEXT16)
		GetElement(self.m_root, "txtBtnRight_WndProfessionRule", WZUILabelTTF):setText(LocalStrings.PETSHOW)
		GetElement(self.m_root, "txtTitle_WndProfessionRule", WZUILabelTTF):setText(LocalStrings.INTRODUCTION)

		if string.find(desc,"<T") == nil then
			--使用普通标签
			self.m_sDesc = self:_changeDesc(desc)
			--	更新函数
			self:_update()
		else
			--使用富文本
	    	GetElement(self.m_root, "txtDesc_WndProfessionRule", WZUILabelTTF):setVisible(false)
	    	GetElement(self.m_root, "txtDesc1_WndProfessionRule", WZUIFreeTextBox):setVisible(true)
	    	GetElement(self.m_root, "txtDesc1_WndProfessionRule", WZUIFreeTextBox):setShowText(desc)
			--	更新滚动容器内部布局函数
			self:_upMoveContainerLayer1()
	    end
	else
		GetElement(self.m_root, "conMid_WndProfessionRule", WZUIContainer):setVisible(false)
		GetElement(self.m_root, "conPreview_WndProfessionRule", WZUIContainer):setVisible(true)
		GetElement(self.m_root, "txtBtnLeft_WndProfessionRule", WZUILabelTTF):setText(LocalStrings.CANCEL)
		GetElement(self.m_root, "txtBtnRight_WndProfessionRule", WZUILabelTTF):setText(LocalStrings.CONFIRM)
		GetElement(self.m_root, "txtTitle_WndProfessionRule", WZUILabelTTF):setText(LocalStrings.PROFESSION_TEXT13)

		for i = 1, #self.m_tLeftProfession do
			local imgProfession = GetElement(self.m_root, "imgProfession" .. i .. "_WndProfessionRule", WZUIImage)
			imgProfession:setFile(self.m_tLeftProfession[i][2])
		end
	end
end

--@brief 	更新函数
function WndProfessionRule:_update()
	WZLog("WndProfessionRule:_update")
	if self.m_root == nil then
		return
	end
	--	更新规则说明内容函数
	self:_setRuleDesc(self.m_sDesc)
	--	更新滚动容器内部布局函数
	self:_upMoveContainerLayer()
end

--@brief 	更新规则说明内容函数
function WndProfessionRule:_setRuleDesc( desc )
	WZLog("WndProfessionRule:_setRuleDesc")
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
function WndProfessionRule:_upMoveContainerLayer()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtSize = self:_getRuleDescSize()
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndProfessionRule")
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
function WndProfessionRule:_upMoveContainerLayer1()
	WZLog("self:_upMoveContainerLayer()")
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "txtDesc1_WndProfessionRule", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0,1))
	txtExplanation:setPositionY(txtSize.height-5)
	WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
--
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndProfessionRule")
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

--@brief    获取规则说明内容文本的大小函数
--@return   size :返回说明文本的size
function WndProfessionRule:_getRuleDescSize()
	if self.m_root == nil then
		return
	end
	local txtExplanation = self.m_root:getChildElement("txtDesc_WndProfessionRule")
	if txtExplanation == nil then
		return
	end
	txtExplanation = WZUILabelTTF:luaTo(txtExplanation)	
	local size = txtExplanation:getLabelContentSize()	
	return size
end
-------------------------------------私有方法模块End----------------------------------------
