--WndBossRoomSetting.lua
--@brief	WndBossRoomSetting的UI模块
--@date		2015-7-30
--@author	binshao
--@note		副本房间设置窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBossRoomSetting:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief onEnter函数执行完成回调
function WndBossRoomSetting:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndBossRoomSetting:actionCallback(element, data)
	--初始化界面
	self:_initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBossRoomSetting:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndBossRoomSetting:onClose(element)
    WZLog("WndSingleCopyInfo:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndBossRoomSetting:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击复选框回调
function WndBossRoomSetting:onClickCheck(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.m_nPlayerNumMode = element:getTag()
end

--@brief  保存房间设置
function WndBossRoomSetting:onClickSure(element)
	WZLog("WndBossRoomSetting:onClickSure")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tBack and self.m_tBack[1] and self.m_tBack[2] then
		local sRoomName = WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomName_WndBossRoomSetting")):getText()
		local sRoomPass = WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomPass_WndBossRoomSetting")):getText()
		local _, isMingan = CheckYellow(sRoomName)
	    if isMingan then
	        MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
	        return false
	    end
	    
		if sRoomPass == "" or sRoomPass == LocalStrings.NO_PASSWORD then
			self.m_sRoomPass = ""
		else
			local passLength = ChineseStringLen(sRoomPass)
			local matchPass = string.match(sRoomPass, "%w+")

			local matchLength =0
			if matchPass then matchLength = ChineseStringLen(matchPass) end
			if passLength ~= matchLength then
				MsgBoxManager:showTipBox(LocalStrings.ROOM_PASS_ERROR)
				return
			elseif matchLength > 8 then
				MsgBoxManager:showTipBox(LocalStrings.ROOM_PASS_ERROR2)
				return
			end
            self.m_sRoomPass = sRoomPass
        end

		if sRoomName ~= "" then
			local roomName = string.match(sRoomName," ")
            local nameLength = ChineseStringLen(sRoomName)
            local roomNameLen = 0
            if roomName  then
                roomNameLen = ChineseStringLen(roomName)
            end
            if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "tr" then
            	if roomNameLen > 0 then
	                MsgBoxManager:showTipBox(LocalStrings.ROOM_NAME_ERROR2)
	                return
	            elseif nameLength > 12 then
	                MsgBoxManager:showTipBox(LocalStrings.ROOM_NAME_ERROR)
	                return
	            end
            else
	            if roomNameLen > 0 then
	                MsgBoxManager:showTipBox(LocalStrings.ROOM_NAME_ERROR2)
	                return
	            elseif nameLength > 8 then
	            	if SceneWorldTeamBossRoom.m_root or SceneCoupleHegemonyRoom.m_root then
	            		if nameLength > 9 then 
	                		MsgBoxManager:showTipBox(LocalStrings.TEAMBOSSROOM_NAME_ERROR)
	            			return 
	            		end
	            	else
	                	MsgBoxManager:showTipBox(LocalStrings.ROOM_NAME_ERROR)
	                	return
	                end
	            end
	        end
			sRoomName = CheckYellow(sRoomName)
            self.m_sRoomName = sRoomName
		end
		if self.m_nWinType == 1 or self.m_nWinType == 2 then 
			if self.m_sRoomPass == "" then 
				self.m_sRoomPass = "-1"
			end
			self.m_tBack[2](self.m_tBack[1], self.m_sRoomName, self.m_sRoomPass, self.m_iRoomMap, self.m_iStartMode, self.m_iBattleMode, self.m_nPlayerNumMode)
		else
			self.m_tBack[2](self.m_tBack[1],self.m_sRoomName,self.m_sRoomPass)
		end
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化界面
function WndBossRoomSetting:_initUI()
    local sRoomPass = WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomPass_WndBossRoomSetting")):getText()
    local sRoomPass = GetElement(self.m_root,"editRoomPass_WndBossRoomSetting",WZUIEditBox)
    sRoomPass:setPlaceHolder(LocalStrings.CLICK_INPUT_PASSWORD)
end


--@brief  展示房间信息
function WndBossRoomSetting:_updateRoomInfo()
	WZLog("WndBossRoomSetting:_updateRoomInfo")
	if self.m_root == nil then
		return
	end
	local editRoomName = WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomName_WndBossRoomSetting"))
	local editRoomPass = WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomPass_WndBossRoomSetting"))
    editRoomName:setText(self.m_sRoomName)
    if self.m_sRoomPass == "-1" or self.m_sRoomPass == "" then
    	editRoomPass:setText(LocalStrings.NO_PASSWORD)
    else
    	editRoomPass:setText(self.m_sRoomPass)
    end
    if self.m_nWinType == 1 then 
    	GetElement(self.m_root, "conName_WndBossRoomSetting", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.62))
    	GetElement(self.m_root, "conNumMode_WndBossRoomSetting", WZUIContainer):setVisible(true)
    	GetElement(self.m_root, "groupcheck_WndBossRoomSetting", WZUICheckBoxGroup):setCheckIndex(self.m_nPlayerNumMode - 1)
    else
    	GetElement(self.m_root, "conNumMode_WndBossRoomSetting", WZUIContainer):setVisible(false)
    end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndBossRoomSetting:_adaptLanguage_es(  )
	local txtName = GetElement(self.m_root,"txtName_WndBossRoomSetting",WZUILabelTTF)
	txtName:setDimensions(GlobalMethod:CCSize(110,0))
	txtName:setFontSize(18)

	local txtPsw = GetElement(self.m_root,"txtPsw_WndBossRoomSetting",WZUILabelTTF)
	txtPsw:setDimensions(GlobalMethod:CCSize(100,0))
	txtPsw:setFontSize(17)
end

function WndBossRoomSetting:_adaptLanguage_ug(  )
	local txtName = GetElement(self.m_root,"txtName_WndBossRoomSetting",WZUILabelTTF)
	txtName:setDimensions(GlobalMethod:CCSize(160,0))
	txtName:setScale(0.7)
	txtName:setRelativePosition(GlobalMethod:ccp(0.95,0.5))
	local txtPsw = GetElement(self.m_root,"txtPsw_WndBossRoomSetting",WZUILabelTTF)
	txtPsw:setDimensions(GlobalMethod:CCSize(160,0))
	txtPsw:setScale(0.7)
	txtPsw:setRelativePosition(GlobalMethod:ccp(0.95,0.5))
	GetElement(self.m_root,"conName_WndBossRoomSetting",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.5))
	GetElement(self.m_root,"conPsw_WndBossRoomSetting",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.5))

	local txtCancel1 = GetElement(self.m_root,"txtCancel1_WndBossRoomSetting",WZUILabelTTF)
	txtCancel1:setDimensions(GlobalMethod:CCSize(170,0))
	txtCancel1:setScale(0.7)
	local txtCancel2 = GetElement(self.m_root,"txtCancel2_WndBossRoomSetting",WZUILabelTTF)
	txtCancel2:setDimensions(GlobalMethod:CCSize(170,0))
	txtCancel2:setScale(0.7)
	local txtConfirm1 = GetElement(self.m_root,"txtConfirm1_WndBossRoomSetting",WZUILabelTTF)
	txtConfirm1:setDimensions(GlobalMethod:CCSize(170,0))
	txtConfirm1:setScale(0.7)
	local txtConfirm2 = GetElement(self.m_root,"txtConfirm2_WndBossRoomSetting",WZUILabelTTF)
	txtConfirm2:setDimensions(GlobalMethod:CCSize(170,0))
	txtConfirm2:setScale(0.7)
end

function WndBossRoomSetting:_adaptLanguage_vn(  )

end
-------------------------------------语言适配End-------------------------------------------