--WndMsgConfirmBox.lua
--@brief	WndMsgConfirmBox的UI模块
--@date		2014/9/1
--@author	hugo.zheng
--@note		确认取消框模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMsgConfirmBox:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
	WZLog("WndMsgConfirmBox:onEnter")
	self:_update()
	--多语言描边字
	self:_moreLanguageForStroke()
	WZLog(LocalStrings.SELL_CONFIRM)
	--确认出售物品提示文字
	self:_sellConfirmWordsDisplay()
end

--@brief	加载动画
function WndMsgConfirmBox:onEnterTransitionDidFinish(element)
    WZLog("WndMsgConfirmBox:onEnterTransitionDidFinish")
    WindowManagerAni:createAction(self.m_root)
end

--@brief	关闭整个窗口的动画效果
function WndMsgConfirmBox:onCloseActionCallback(elem,data)
   WindowManager:removeWindow(self.m_root, self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMsgConfirmBox:onExit(element)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
	end
	self:_unInit()
end

--@brief	点击关闭或者取消按钮后的响应方法
--@param	element:表绑定的UI节点引用
--@note		回调给消息数据里的回调方法并且移出窗口
function WndMsgConfirmBox:onCancel(element)
	if self.m_root == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndSellList:reduceRef()
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		--self:_msgCallBack(MSGBOXRESTYPE_CANCEL)
	end
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
--	WindowManager:removeWindow(self.m_root, self)
	WZLog("function onCacel finish!")
end

--@brief	点击确认按钮后的响应方法
--@param	element:表绑定的UI节点引用
--@note		回调给消息数据里的回调方法并且移出窗口
function WndMsgConfirmBox:onConfirm(element)
	if self.m_root == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		self:_msgCallBack(MSGBOXRESTYPE_CONFIRM)
	end
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	WZLog("function onConfirm finish!")
end

--@brief	定时器回调方法
--@param	element:表绑定的UI节点引用
--@param	delta:定时器触发间隔
--@note		超时后回调，并且移出窗口
function WndMsgConfirmBox:scheduleTimeout(element, delta)
	WZLog("WndMsgConfirmBox:scheduleTimeout")
	element:disableSchedule()
	if self.m_root == nil then
		return
	end
	
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		self:_msgCallBack(MSGBOXRESTYPE_TIMEOUT)
	end
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	--WindowManager:removeWindow(self.m_root, self)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	界面更新函数
--@note		根据消息数据生成确认框
function WndMsgConfirmBox:_update()
	if self.m_root == nil or self.m_tMsgData == nil then
		return
	end
	
	self:_updateContent()
	
	if self.m_tMsgData.tCustomUIConfig ~= nil then
        if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_FONTSIZE] ~= nil then
            local txtContent = GetElement(self.m_root, "txtContent_WndMsgConfirmBox", WZUILabelTTF)
			txtContent:setFontSize(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_FONTSIZE])
        end
		if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM] ~= nil then
			WZLog("WndMsgConfirmBox:_update")
			local txtConfirm = GetElement(self.m_root, "txtConfirm_WndMsgConfirmBox", WZUILabelTTF)
			txtConfirm:setText(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM])
		end
		if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CANCEL] ~= nil then
			--local txtCancel = GetElement(self.m_root, "txtCancel_WndMsgConfirmBox", WZUILabelTTF)
			--txtCancel:setText(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CANCEL])
		end
	end

	--设置文本提示
	local txtSellConfirm = GetElement(self.m_root, "txtSellConfirm_WndMsgConfirmBox", WZUILabelTTF)
	if txtSellConfirm then
		txtSellConfirm = WZUILabelTTF:luaTo(txtSellConfirm)
		txtSellConfirm:setText(self.m_tMsgData.sMsgBody)
		txtSellConfirm:setVisible(true)
	end
	
	if self.m_tMsgData.nTimeout > 0 then
		self.m_root:enableSchedule("scheduleTimeout", self.m_tMsgData.nTimeout)
	end
end

--@brief	更新消息内容
--@note		根据配置判断是普通文本还是使用富文本框
function WndMsgConfirmBox:_updateContent()
	do return end

    local txtContent = GetElement(self.m_root, "txtContent_WndMsgConfirmBox", WZUILabelTTF)
 --   local freetxtContent = GetElement(self.m_root, "freetxtContent_WndMsgConfirmBox", WZUIFreeTextBox)
    
    --local btnOK = GetElement(self.m_root, "btnOK_WndMsgConfirmBox", WZUIButton)
    --local btnCancel = GetElement(self.m_root, "btnCancel_WndMsgConfirmBox", WZUIButton)
    local btnOK = self.m_root:getChildElement("btnOK_WndMsgConfirmBox")
    btnOK = WZUIContainer:luaTo(btnOK)
    local btnCancel = self.m_root:getChildElement("btnCancel_WndMsgConfirmBox")
    btnCancel = WZUIContainer:luaTo(btnCancel)
    if self.m_tMsgData.nLevel ~= nil then
        btnCancel:setVisible(false)
        btnOK:setRelativePosition(ccp(0.5,0.0907104))
    else
        btnCancel:setVisible(true)
        btnCancel:setRelativePosition(ccp(0.7,0.0907104))
        btnOK:setRelativePosition(ccp(0.3,0.0907104))
    end
--    if self.m_tMsgData.tCustomUIConfig ~= nil and self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_USEFREETXT] == true then
--        freetxtContent:setVisible(true)
--        freetxtContent:setShowText(self.m_tMsgData.sMsgBody)
--    else
--        txtContent:setText(self.m_tMsgData.sMsgBody)
--    end
end

--@brief 	多语言描边字
function WndMsgConfirmBox:_moreLanguageForStroke()
	if self.m_root == nil  then
		return
	end
	WZLog("WndMsgConfirmBox:_moreLanguageForStroke")
	--确定按钮
	local txtConfirm = self.m_root:getChildElement("txtConfirm_WndMsgConfirmBox")
	if txtConfirm then
		txtConfirm = WZUILabelTTF:luaTo(txtConfirm)
		if self.m_tMsgData.tCustomUIConfig == nil or (self.m_tMsgData.tCustomUIConfig ~= nil and self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM] == nil) then
			txtConfirm:setText(LocalStrings.CONFIRM)
			txtConfirm:setVisible(true)
		end
	end
  --取消按钮
	local txtConfirm = self.m_root:getChildElement("txtCancel_WndMsgConfirmBox")
	if txtConfirm then
		txtConfirm = WZUILabelTTF:luaTo(txtConfirm)
		txtConfirm:setText(LocalStrings.BACK)
		txtConfirm:setVisible(true)
	end

end

--@brief	确认出售提示文字
--@note		确认出售提示文字
function WndMsgConfirmBox:_sellConfirmWordsDisplay()
	--文本提示：本次出售列表中拥有高品质道具\n请确认是否继续出售？
	--local txtSellConfirm = GetElement(self.m_root, "txtSellConfirm_WndMsgConfirmBox", WZUILabelTTF)
	--if txtSellConfirm then
	--	txtSellConfirm = WZUILabelTTF:luaTo(txtSellConfirm)
	--	txtSellConfirm:setText(LocalStrings.SELL_CONFIRM)
	--	txtSellConfirm:setVisible(true)
	--end
end

--@brief	葡语适配函数
--@note		葡语适配函数
function WndMsgConfirmBox:_adaptLanguage_pt()
    WZLog("WndMsgConfirmBox:_adaptLanguage_pt")
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtConfirm_WndMsgConfirmBox")):setFontSize(24)
    WZUILabelTTF:luaTo(self.m_root:getChildElement("txtCancel_WndMsgConfirmBox")):setFontSize(24)
end
-------------------------------------私有方法模块End----------------------------------------
