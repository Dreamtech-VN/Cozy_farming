--WndMatchDeclare.lua
--@brief	WndMatchDeclare的UI模块
--@date		2018/06/20
--@author	Tianxiang_Xu
--@note		征婚中心-宣言


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMatchDeclare:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMatchDeclare:onExit(element)
	self:_unInit()
end

--@brief    加载界面完成回调
function WndMatchDeclare:onEnterTransitionDidFinish(element)
    -- body
    local string = string.sub(WndMatchmaking.m_tMatchConfig.cost, 2, -2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]
    self.m_tCost = {}
    self.m_tCost[1] = tonumber(id)
    self.m_tCost[2] = tonumber(num)
    self.m_nRegisterDays = WndMatchmaking.m_tMatchConfig.lastDay 			--登记有效时间
    local editBox = GetElement(self.m_root, "editBox_WndMatchDeclare", WZUIEditBox)
    if editBox then
    	if WndMatchmaking.m_sLastDeclare == nil or WndMatchmaking.m_sLastDeclare == "" then
    		editBox:setText(LocalStrings.BAGTIP1)
    	else
    		editBox:setText(WndMatchmaking.m_sLastDeclare)
    	end
    end
	
    self:_update()
end

--@brief 	点击取消按钮回调
function WndMatchDeclare:onCancelClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nType == 1 then
		WindowManager:removeWindow(self.m_root, self, true)
	else
		MsgBoxManager:showConfirmBox(LocalStrings.MATCHMAKE_TEXT7, self, self.sureToCancel)
	end
end

--@brief 	点击确认按钮回调
function WndMatchDeclare:onOkClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndMatchDeclare:onOkClick", self.m_nType)

	local text = WZUIEditBox:luaTo(GetElement(self.m_root,"editBox_WndMatchDeclare")):getText()
	if text == "" then
		MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
		return
	elseif Regexp:isAllBlankChar(text) == true then--全部是空白键
		MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
		return 
	end

	if self:_checkName() then
		if self.m_nType == 1 then
			if not JudgeMoneyIsEnough(self.m_tCost[1], self.m_tCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToRegister) then
				return 
			end
			self:sureToRegister()
		else
			--发送修改协议
			self:sureToRegister()
		end
	end
end

--@brief 	确定撤销登记
function WndMatchDeclare:sureToCancel()
	-- body
	--发送撤销协议
	WndMatchmaking:_createLoading()
	ProtocolProcessorMatchmaking:send_WEDDING_CancelDatingServiceSign()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	确定登记
function WndMatchDeclare:sureToRegister()
	-- body
	--发送登记协议
	WndMatchmaking:_createLoading()
	local text = GetElement(self.m_root,"editBox_WndMatchDeclare", WZUIEditBox):getText()
	ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceSign(text)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击空白区域
function WndMatchDeclare:onClickOther(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndMatchDeclare:_update()
	-- body
	self:setLeftTime()
	self:setBtn()

	AdaptLanguage(self)
end

--@brief 	设置按钮
function WndMatchDeclare:setBtn()
	-- body
	local btnCancel = GetElement(self.m_root, "btnCancel_WndMatchDeclare", WZUIButton)
	local btnOk = GetElement(self.m_root, "btnOk_WndMatchDeclare", WZUIButton)
	local ftxtOk = GetElement(self.m_root, "ftxtOk_WndMatchDeclare", WZUIFreeTextBox)
	local txtCancel = GetElement(self.m_root, "txtCancel_WndMatchDeclare", WZUILabelTTF)

	if self.m_nType == 1 then
		local sFormat = [[<I Z="0.5">%s</I><T C="255,236,193" S="20" P="1" SC="0,72,3" SS="4" SE="1">%d%s</T>]]
		local basicData = GDatatab_item["id_" .. self.m_tCost[1]]
		ftxtOk:setShowText(string.format(sFormat, basicData.icon, self.m_tCost[2], LocalStrings.MATCHMAKE_TEXT6))
		txtCancel:setText(LocalStrings.BACK)
		
		btnOk:setVisible(true)
		btnCancel:setVisible(true)
	else
		btnCancel:setVisible(true)
		btnOk:setVisible(true)
		local sFormat = [[<T C="255,236,193" S="20" P="1" SC="0,72,3" SS="4" SE="1">%s</T>]]

		ftxtOk:setShowText(string.format(sFormat, LocalStrings.MATCHMAKE_TEXT15))
		txtCancel:setText(LocalStrings.MATCHMAKE_TEXT14)
	end
end

--@brief 	设置剩余时间
function WndMatchDeclare:setLeftTime()
	-- body
	if self.m_root == nil then return end 

	local txtTimeAtt = GetElement(self.m_root, "txtTimeAtt_WndMatchDeclare", WZUILabelTTF)
	if txtTimeAtt then
		if self.m_nType == 1 then
			txtTimeAtt:setText(string.format(LocalStrings.MATCHMAKE_TEXT12, self.m_nRegisterDays))
		else
			local sContent = ""
			if WndMatchmaking.m_nRegisterLeftTime >= 24 * 3600 then
				local nDays = math.floor(WndMatchmaking.m_nRegisterLeftTime/(24 * 3600))
				local nHours = math.ceil((WndMatchmaking.m_nRegisterLeftTime - nDays * 24 * 3600)/3600)
				sContent = nDays .. LocalStrings.DAY .. nHours .. LocalStrings.HOUR1
			else
				local nHours = math.floor(WndMatchmaking.m_nRegisterLeftTime/3600)
				local nMinutes = math.ceil((WndMatchmaking.m_nRegisterLeftTime - nHours * 3600)/60)
				sContent = nHours .. LocalStrings.HOUR1 .. nMinutes .. LocalStrings.MINUTE1
			end
			txtTimeAtt:setText(LocalStrings.MATCHMAKE_TEXT13 .. sContent)
		end
	end 
end

--@brief 	倒计时
function WndMatchDeclare:countTime()
	-- body
	if self.m_root == nil then return end 
	if self.m_nType == 1 then return end

	if WndMatchmaking.m_nRegisterLeftTime >= 0 then
		self:setLeftTime()
		if WndMatchmaking.m_nRegisterLeftTime == 0 then
			self.m_nType = 1
			self:_update()
		end
	end
end

function WndMatchDeclare:_checkName()
    local editInputName = GetElement(self.m_root,"editBox_WndMatchDeclare",WZUIEditBox)
    local txtName = editInputName:getText()

    -- 空或者不是字符串
    if type(txtName) ~= "string" or "" == txtName then
        MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT20)
        return false
    end

    WZLog("********** WndMatchDeclare:_checkName **************", txtName)
    local nInputTextLen, spaceCnt = WndBag:_checkInputTxtLen(txtName)

    if nInputTextLen > WndMatchmaking.m_tMatchConfig.len * 2 then
        MsgBoxManager:showTipBox(string.format(LocalStrings.MATCHMAKE_TEXT19, WndMatchmaking.m_tMatchConfig.len))
        return false
    end

    return true
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------私有方法模块End----------------------------------------
function WndMatchDeclare:_adaptLanguage_vn( )
	local ftxtOk = GetElement(self.m_root, "ftxtOk_WndMatchDeclare", WZUIFreeTextBox)
	if self.m_nType == 1 then
		ftxtOk:setScale(0.7)
		ftxtOk:setMaxWidth(160)
	else
		ftxtOk:setScale(1)
		ftxtOk:setMaxWidth(160)
	end

	local txtTimeAtt = GetElement(self.m_root, "txtTimeAtt_WndMatchDeclare", WZUILabelTTF)
	if txtTimeAtt then
		txtTimeAtt:setScale(0.9)
	end
end

function WndMatchDeclare:_adaptLanguage_th( )
	local ftxtOk = GetElement(self.m_root, "ftxtOk_WndMatchDeclare", WZUIFreeTextBox)
	ftxtOk:setScale(0.65)
	ftxtOk:setMaxWidth(160)
	local txtCancel = GetElement(self.m_root, "txtCancel_WndMatchDeclare", WZUILabelTTF)
	txtCancel:setScale(0.8)
	txtCancel:setDimensions(GlobalMethod:CCSize(120))

	local txtTimeAtt = GetElement(self.m_root, "txtTimeAtt_WndMatchDeclare", WZUILabelTTF)
	if txtTimeAtt then
		txtTimeAtt:setScale(0.9)
	end
end

function WndMatchDeclare:_adaptLanguage_en( )
	local ftxtOk = GetElement(self.m_root, "ftxtOk_WndMatchDeclare", WZUIFreeTextBox)
	ftxtOk:setScale(0.55)
	ftxtOk:setMaxWidth(200)
	local txtCancel = GetElement(self.m_root, "txtCancel_WndMatchDeclare", WZUILabelTTF)
	txtCancel:setScale(0.8)
	txtCancel:setDimensions(GlobalMethod:CCSize(120))

	local txtTimeAtt = GetElement(self.m_root, "txtTimeAtt_WndMatchDeclare", WZUILabelTTF)
	if txtTimeAtt then
		txtTimeAtt:setScale(0.65)
	end
end

function WndMatchDeclare:_adaptLanguage_pt( )
	local ftxtOk = GetElement(self.m_root, "ftxtOk_WndMatchDeclare", WZUIFreeTextBox)
	ftxtOk:setScale(0.8)
	ftxtOk:setMaxWidth(120)
	local txtCancel = GetElement(self.m_root, "txtCancel_WndMatchDeclare", WZUILabelTTF)
	txtCancel:setScale(0.8)
	txtCancel:setDimensions(GlobalMethod:CCSize(120))

	local txtTimeAtt = GetElement(self.m_root, "txtTimeAtt_WndMatchDeclare", WZUILabelTTF)
	if txtTimeAtt then
		txtTimeAtt:setDimensions(GlobalMethod:CCSize(380))
	end
end

function WndMatchDeclare:_adaptLanguage_es( )
	local ftxtOk = GetElement(self.m_root, "ftxtOk_WndMatchDeclare", WZUIFreeTextBox)
	ftxtOk:setScale(0.8)
	ftxtOk:setMaxWidth(120)
	local txtCancel = GetElement(self.m_root, "txtCancel_WndMatchDeclare", WZUILabelTTF)
	txtCancel:setScale(0.8)
	txtCancel:setDimensions(GlobalMethod:CCSize(120))

	local txtTimeAtt = GetElement(self.m_root, "txtTimeAtt_WndMatchDeclare", WZUILabelTTF)
	if txtTimeAtt then
		txtTimeAtt:setDimensions(GlobalMethod:CCSize(380))
	end
end

function WndMatchDeclare:_adaptLanguage_tr( )
	local ftxtOk = GetElement(self.m_root, "ftxtOk_WndMatchDeclare", WZUIFreeTextBox)
	ftxtOk:setScale(0.8)
	ftxtOk:setMaxWidth(120)
	local txtCancel = GetElement(self.m_root, "txtCancel_WndMatchDeclare", WZUILabelTTF)
	txtCancel:setScale(0.8)
	txtCancel:setDimensions(GlobalMethod:CCSize(120))

	local txtTimeAtt = GetElement(self.m_root, "txtTimeAtt_WndMatchDeclare", WZUILabelTTF)
	if txtTimeAtt then
		txtTimeAtt:setScale(0.7)
	end
end
-------------------------------------私有方法模块End----------------------------------------