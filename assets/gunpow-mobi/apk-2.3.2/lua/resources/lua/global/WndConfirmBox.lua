--WndConfirmBox.lua
--@brief	WndConfirmBox的UI模块
--@date		2013/12/19
--@author	xiaoyu_wu
--@note		确认框模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndConfirmBox:onEnter(element)
	self.m_root = element
    
    local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmBox", WZUILabelTTF)
	txtConfirm:setText(LocalStrings.CONFIRM)
	
	self:_update()

    WZLog("WndConfirmBox:onEnter")

    if TeachGroup1 and TeachGroup1.SCHEDULE then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TeachGroup1.SCHEDULE)
    end
    WindowManager:removeTeachShelterLayer()
    if TeachGroup1 then
    	TeachGroup1:removeTeachAnim()
	end

    if WndTeachTalk then
        WndTeachTalk:removeWindow()
    end
	
	AdaptLanguage(self)

	--如果bIsManualConfirm为true，则默认倒计时内变灰不可点击，倒计时后变为可点击
	if self.m_tMsgData ~= nil and self.m_tMsgData.bIsManualConfirm then
		local btnConfirm = GetElement(self.m_root, "btnConfirm_WndConfirmBox", WZUIButton)
		local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmBox", WZUILabelTTF)
		if btnConfirm ~= nil then
			btnConfirm:setTouchEnable(false)
		end
		if txtConfirm then 
			txtConfirm:setLabelStyleKey("SMALL_GRAY_BTN")
		end
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndConfirmBox:onExit(element)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
	end
	self:_unInit()
end

--@brief	加载动画
function WndConfirmBox:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true)
end

--@brief	关闭整个窗口的动画效果
function WndConfirmBox:onCloseActionCallback(elem,data)
    if self.m_action == MSGBOXRESTYPE_CONFIRM and self.m_tMsgData ~= nil then 
        self:_msgCallBack(MSGBOXRESTYPE_CONFIRM)
        if self.m_tMsgData.tCustomUIConfig ~= nil and not self.m_tMsgData.tCustomUIConfig.bIsItemEnough and self.m_tMsgData.tCustomUIConfig.bIsItemEnough ~= nil then
        	return 
        end
    end
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief	点击关闭按钮后的响应方法
--@param	element:表绑定的UI节点引用
--@note		回调给消息数据里的回调方法并且移出窗口
function WndConfirmBox:onCancel(element)
	WZLog("WndConfirmBox:onCancel")
	if self.m_root == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		--self:_msgCallBack(MSGBOXRESTYPE_CANCEL)
        self.m_action = MSGBOXRESTYPE_CANCEL
		WZLog("WndConfirmBox:onCancel1",type(self.m_tMsgData.tCallbackLuaObj),type(self.m_tMsgData.fCallbackCancel))
        if self.m_tMsgData.tCallbackLuaObj and self.m_tMsgData.fCallbackCancel then
		  self.m_tMsgData.fCallbackCancel(self.m_tMsgData.tCallbackLuaObj)
        end
	end
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	--WindowManager:removeWindow(self.m_root, self)
end

--@brief	点击确认按钮后的响应方法
--@param	element:表绑定的UI节点引用
--@note		回调给消息数据里的回调方法并且移出窗口
function WndConfirmBox:onConfirm(element)
	if self.m_root == nil then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		--self:_msgCallBack(MSGBOXRESTYPE_CONFIRM)
        self.m_action = MSGBOXRESTYPE_CONFIRM
	end
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	--WindowManager:removeWindow(self.m_root, self)
end

--@brief	定时器回调方法
--@param	element:表绑定的UI节点引用
--@param	delta:定时器触发间隔
--@note		超时后回调，并且移出窗口
function WndConfirmBox:scheduleTimeout(element, delta)
	WZLog("WndConfirmBox:scheduleTimeout")
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
function WndConfirmBox:_update()
	if self.m_root == nil or self.m_tMsgData == nil then
		return
	end
	WZLog("self.m_tMsgData.tCustomUIConfig: ", self.m_tMsgData.tCustomUIConfig, Serialize(self.m_tMsgData.tCustomUIConfig))
	GetElement(self.m_root, "txtCancel_WndConfirmBox", WZUILabelTTF):setText(LocalStrings.BACK)
	local img9Bg = GetElement(self.m_root, "img9Bg_WndConfirmBox", WZUI9Image)
    self:_updateContent()
	
	if self.m_tMsgData.tCustomUIConfig ~= nil then
   --      if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_FONTSIZE] ~= nil then
   --          local txtContent = GetElement(self.m_root, "txtContent_WndConfirmBox", WZUILabelTTF)
			-- txtContent:setFontSize(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_FONTSIZE])
   --      end
		if self.m_tMsgData.tCustomUIConfig["MSGBOXUICFG_CANCEL"] ~= nil then
			local txt = GetElement(self.m_root, "txtCancel_WndConfirmBox", WZUILabelTTF)
			txt:setText(self.m_tMsgData.tCustomUIConfig["MSGBOXUICFG_CANCEL"])
		end
		if self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM] ~= nil then
			local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmBox", WZUILabelTTF)
			txtConfirm:setText(self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_CONFIRM])
			if ProjConfig.LANGUAGE == "tr" then
				local txt = GetElement(self.m_root, "txtCancel_WndConfirmBox", WZUILabelTTF)
				txt:setDimensions(GlobalMethod:CCSize(140,0))
				txt:setScale(0.7)
				txtConfirm:setDimensions(GlobalMethod:CCSize(140,0))
				txtConfirm:setScale(0.7)
			end
		end

		if self.m_tMsgData.tCustomUIConfig.bgPath then 
			img9Bg:setFile(self.m_tMsgData.tCustomUIConfig.bgPath)
		end
		if self.m_tMsgData.tCustomUIConfig.bShowClose then 
			GetElement(self.m_root, "btnClose_WndConfirmBox", WZUIButton):setVisible(self.m_tMsgData.tCustomUIConfig.bShowClose)
		end
		if self.m_tMsgData.tCustomUIConfig.strTitle then 
			GetElement(self.m_root, "txtTitle_WndConfirmBox", WZUILabelTTF):setText(self.m_tMsgData.tCustomUIConfig.strTitle)
		end
	end

	local btnConfirm = GetElement(self.m_root, "btnConfirm_WndConfirmBox", WZUIButton)
	local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmBox", WZUILabelTTF)
	if self.m_tMsgData.nTime and self.m_tMsgData.nTime>0 then
		txtConfirm:setText(self.m_tMsgData.nTime.."s "..LocalStrings.CONFIRM)
		btnConfirm:enableSchedule("scheduleConfirm", 1)
	end
	
	if self.m_tMsgData.nTimeout > 0 then
		self.m_root:enableSchedule("scheduleTimeout", self.m_tMsgData.nTimeout)
	end
end

function WndConfirmBox:scheduleConfirm(element)
	local btnConfirm = GetElement(self.m_root, "btnConfirm_WndConfirmBox", WZUIButton)
	local txtConfirm = GetElement(self.m_root, "txtConfirm_WndConfirmBox", WZUILabelTTF)

	self.m_tMsgData.nTime = self.m_tMsgData.nTime - 1
	if self.m_tMsgData.nTime > 0 then
		txtConfirm:setText(self.m_tMsgData.nTime.."s "..LocalStrings.CONFIRM)
	else
		btnConfirm:disableSchedule()
		if self.m_tMsgData ~= nil and self.m_tMsgData.bIsManualConfirm then
			btnConfirm:setTouchEnable(true)
			txtConfirm:setLabelStyleKey("")
			txtConfirm:setText(LocalStrings.CONFIRM)
			return
		end
		self:onConfirm()
	end
end

--@brief	更新消息内容
--@note		根据配置判断是普通文本还是使用富文本框
function WndConfirmBox:_updateContent()
--    local txtContent = GetElement(self.m_root, "txtContent_WndConfirmBox", WZUILabelTTF)
    -- local freetxtContent = GetElement(self.m_root, "txtFreeBox_WndConfirmBox", WZUIFreeTextBox)
    -- freetxtContent = WZUIFreeTextBox:luaTo(freetxtContent)
    
    -- if self.m_tMsgData.tCustomUIConfig ~= nil and self.m_tMsgData.tCustomUIConfig[MSGBOXUICFG_USEFREETXT] == true then
    --     WZLog("************* WndConfirmBox:_updateContent 111111********** ", self.m_tMsgData.sMsgBody)
    --     freetxtContent:setVisible(true)
    --     freetxtContent:setShowText(self.m_tMsgData.sMsgBody)
    -- else
    --     WZLog("************* WndConfirmBox:_updateContent 222222********** ", self.m_tMsgData.sMsgBody)
    --     freetxtContent:setVisible(true)
    --     freetxtContent:setShowText(self.m_tMsgData.sMsgBody)
    -- --    txtContent:setText(self.m_tMsgData.sMsgBody)
    -- end
    local txtContext= GetElement(self.m_root, "txtContext_WndConfirmBox", WZUILabelTTF)
    if txtContext then
    	txtContext:setText("")
    end

    local txtFreeBox  = GetElement(self.m_root, "txtFreeBox_WndConfirmBox", WZUIFreeTextBox)
    if txtFreeBox then
    	txtFreeBox:setShowText("")
    end

    local findIndex = string.find(self.m_tMsgData.sMsgBody,"<T")
    if findIndex == nil  then
    	txtContext:setText(self.m_tMsgData.sMsgBody)
    else
    	--local strContent = string.format([[<T S="24" C="62,34,8" P="0">%s</T>]], self.m_tMsgData.sMsgBody)
        txtFreeBox:setShowText(self.m_tMsgData.sMsgBody)
    end
    

    if self.m_tMsgData.bIsOnlyOneButton == true then
        GetElement(self.m_root, "btnCancel_WndConfirmBox", WZUIButton):setVisible(false)
        GetElement(self.m_root, "btnConfirm_WndConfirmBox", WZUIButton):setRelativePosition(ccp(0.5,0.17))
    end

	--离线重连不显示返回按钮
	if self.m_tMsgData.sMsgBody == LocalStrings.NETWORK_UNAVAILABLE then
		GetElement(self.m_root, "btnCancel_WndConfirmBox", WZUIButton):setVisible(false)
		GetElement(self.m_root, "btnConfirm_WndConfirmBox", WZUIButton):setRelativePosition(ccp(0.5,0.17))
	end

    --红色提示语
    if self.m_tMsgData.RedAttText then
        txtFreeBox:setRelativePosition(ccp(0.5, 0.63))
        txtContext:setRelativePosition(ccp(0.5, 0.63))
        local txtRedAtt = GetElement(self.m_root, "txtRedAtt_WndConfirmBox", WZUILabelTTF)
        txtRedAtt:setVisible(true)
        txtRedAtt:setText(self.m_tMsgData.RedAttText)
    end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndConfirmBox:_adaptLanguage_en()
	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBox",WZUILabelTTF)
	txtContext:setFontSize(20)
	txtContext:setDimensions(GlobalMethod:CCSize(380))
	--txt:setDimensions(GlobalMethod:CCSize(280,0))
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndConfirmBox",WZUIFreeTextBox)
	txtFreeBox:setScale(0.8)
	txtFreeBox:setMaxWidth(420)
end

function WndConfirmBox:_adaptLanguage_pt(  )
	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBox",WZUILabelTTF)
	txtContext:setFontSize(20)
	txtContext:setDimensions(GlobalMethod:CCSize(380))
	local txtFree = GetElement(self.m_root,"txtFreeBox_WndConfirmBox",WZUIFreeTextBox)
	txtFree:setMaxWidth(500)
	txtFree:setAbsContentSize(GlobalMethod:CCSize(330,100))
	txtFree:setUseAbsSize(true)
	txtFree:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	txtFree:setRelativePosition(GlobalMethod:ccp(0.01,0.5))
	txtFree:setScale(0.8)
end

function WndConfirmBox:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtContext_WndConfirmBox",WZUILabelTTF):setFontSize(20)
	
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndConfirmBox",WZUIFreeTextBox)
	txtFreeBox:setMaxWidth(800)
	txtFreeBox:setScale(0.8)
	if WndPetExchange == self.m_tMsgData.tCallbackLuaObj then
		txtFreeBox:setRelativePosition(GlobalMethod:ccp(1.15,0.5))
	end
end

function WndConfirmBox:_adaptLanguage_vn()
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndConfirmBox",WZUIFreeTextBox)
	txtFreeBox:setMaxWidth(400)
	txtFreeBox:setScale(0.8)

	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBox",WZUILabelTTF)
	txtContext:setScale(0.8)
	txtContext:setDimensions(GlobalMethod:CCSize(460))

	local txtCancel = GetElement(self.m_root, "txtCancel_WndConfirmBox", WZUILabelTTF)
	txtCancel:setDimensions(GlobalMethod:CCSize(140,0))
	txtCancel:setFontSize(20)
	local txtConfirm = GetElement(self.m_root,"txtConfirm_WndConfirmBox",WZUILabelTTF)
	txtConfirm:setDimensions(GlobalMethod:CCSize(140,0))
	txtConfirm:setFontSize(20)
end

function WndConfirmBox:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtContext_WndConfirmBox",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtFreeBox_WndConfirmBox",WZUIFreeTextBox):setMaxWidth(380)
end

function WndConfirmBox:_adaptLanguage_es()
	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBox",WZUILabelTTF)
	txtContext:setFontSize(18)
	txtContext:setDimensions(GlobalMethod:CCSize(380))
	local txtFreeBox = GetElement(self.m_root,"txtFreeBox_WndConfirmBox",WZUIFreeTextBox)
	txtFreeBox:setMaxWidth(400)
	txtFreeBox:setScale(0.8)
end

function WndConfirmBox:_adaptLanguage_ug(  )
	local txtCancel = GetElement(self.m_root, "txtCancel_WndConfirmBox", WZUILabelTTF)
	txtCancel:setDimensions(GlobalMethod:CCSize(170,0))
	txtCancel:setScale(0.6)
	local txtConfirm = GetElement(self.m_root,"txtConfirm_WndConfirmBox",WZUILabelTTF)
	txtConfirm:setDimensions(GlobalMethod:CCSize(170,0))
	txtConfirm:setScale(0.6)
	local txtContext = GetElement(self.m_root,"txtContext_WndConfirmBox",WZUILabelTTF)
	txtContext:setFontSize(18)
	txtContext:setDimensions(GlobalMethod:CCSize(380))
end


-------------------------------------语言适配模块End--------------------------------------
