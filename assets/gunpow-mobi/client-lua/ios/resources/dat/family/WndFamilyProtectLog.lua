--WndFamilyProtectLog.lua
--@brief	WndFamilyProtectLog的UI模块
--@date		2018/02/06
--@author	Tianxiang_Xu
--@note		家园偷盗日志


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFamilyProtectLog:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFamilyProtectLog:onExit(element)
	self:_unInit()
end

function WndFamilyProtectLog:onEnterTransitionDidFinish(element)
	-- body
    SceneFamily:_createLoading()
    ProtocolProcessorFamily:send_HOME_GetStealLog()
end

--@brief 	点击关闭按钮回调
function WndFamilyProtectLog:onBackClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	查看日志玩家信息
function CellFamilyProtectLog:onClickCheck(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCheckOther:show(self.m_tData.playerId)
end

--@brief 	开始加载
function CellFamilyProtectLog:onLoadData(element)
	-- body
	local ftxtLog = WZUIFreeTextBox:create()
	ftxtLog:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    ftxtLog:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
    ftxtLog:setMaxWidth(460)
    element:addChild(ftxtLog)

    local sFormatLog = {LocalStrings.FAMILY_TEXT63, LocalStrings.FAMILY_TEXT64, LocalStrings.FAMILY_TEXT65, LocalStrings.FAMILY_TEXT66, LocalStrings.FAMILY_TEXT67, LocalStrings.FAMILY_TEXT68}
    sTime = self:rtnTimeString()

    if self.m_tData.type == 2 and self.m_tData.defend == 0 then
    	ftxtLog:setShowText(string.format(sFormatLog[1], sTime, self.m_tData.playerName, self.m_tData.petName))
    elseif self.m_tData.type == 2 and self.m_tData.defend == 1 and self.m_tData.hurt == 0 then
    	local basicInfo = GDatatab_guardromon["id_" .. self.m_tData.protectItemId]
    	ftxtLog:setShowText(string.format(sFormatLog[2], sTime, self.m_tData.playerName, basicInfo.name))
    elseif self.m_tData.type == 2 and self.m_tData.defend == 1 and self.m_tData.hurt == 1 then
    	local basicInfo = GDatatab_guardromon["id_" .. self.m_tData.protectItemId]
    	ftxtLog:setShowText(string.format(sFormatLog[3], sTime, self.m_tData.playerName, basicInfo.name))
    elseif self.m_tData.type == 1 and self.m_tData.defend == 0 then
    	ftxtLog:setShowText(string.format(sFormatLog[4], sTime, self.m_tData.playerName, self.m_tData.petName))
    elseif self.m_tData.type == 1 and self.m_tData.defend == 1 and self.m_tData.hurt == 0 then
    	local basicInfo = GDatatab_guardromon["id_" .. self.m_tData.protectItemId]
    	ftxtLog:setShowText(string.format(sFormatLog[5], sTime, self.m_tData.playerName, basicInfo.name))
    elseif self.m_tData.type == 1 and self.m_tData.defend == 1 and self.m_tData.hurt == 1 then
    	local basicInfo = GDatatab_guardromon["id_" .. self.m_tData.protectItemId]
    	ftxtLog:setShowText(string.format(sFormatLog[6], sTime, self.m_tData.playerName, basicInfo.name))
    end

    btnBuilding = WZUIButton:create()
    btnBuilding:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    btnBuilding:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    btnBuilding:setLuaDoneFunctionName("onClickCheck")
    element:addChild(btnBuilding)

    if ProjConfig.LANGUAGE == "vn" then
    	ftxtLog:setMaxWidth(430)
    elseif ProjConfig.LANGUAGE == "th" then
    	ftxtLog:setMaxWidth(430)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndFamilyProtectLog:_update()
	-- body
	local txtTitleName = GetElement(self.m_root, "txtTitleName_WndFamilyProtectLog", WZUILabelTTF)
	if txtTitleName then
		txtTitleName:setText(LocalStrings.FAMILY_TEXT62)
	end
	local tbconLog = GetElement(self.m_root, "tbconLog_WndFamilyProtectLog", WZUITableContainer)
	tbconLog:cleanTable()
	local conInvitedMsg = GetElement(self.m_root, "conInvitedMsg_WndFamilyProtectLog", WZUIContainer)
	if self.m_tLogData == nil or #self.m_tLogData == 0 then
		ShowPanelNullTip(conInvitedMsg, LocalStrings.DIGGEM_TEXT21)
		return 
	end
	removeShowPanelNullTip(conInvitedMsg)

	--日志列表
	for i = 1, #self.m_tLogData do
		local element, tNewObj = CellFamilyProtectLog:createElement()
		if element and tNewObj then
			tNewObj:setData(self.m_tLogData[i])
			element:setTag(i - 1)
			tbconLog:setCellElement(element)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
