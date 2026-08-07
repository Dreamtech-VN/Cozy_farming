--WndFindRoom.lua
--@brief	WndFindRoom的UI模块
--@date		2015-7-20
--@author	binshao
--@note		查找房间窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFindRoom:onEnter(element)
	self.m_root = element
	--设置静态UI文字
	self:_setStatiUiText()

	--多语言版本界面适配
	AdaptLanguage(self)
end
--@brief onEnter函数执行完成回调
function WndFindRoom:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndFindRoom:actionCallback(element, data)
    self.m_root:enableSchedule("scheduleLoadUI", 0)
    self:_setOkTouch(false)
end

--@brief    加载界面元素定时器
function WndFindRoom:scheduleLoadUI()
    self.m_root:disableSchedule()
end
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFindRoom:onExit(element)
	self:_unInit()
end



--@brief	关闭窗口的函数
--@param	element:表绑定的UI节点引用
function WndFindRoom:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		--音效
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 
--@brief	退出场景时被调用的函数
function WndFindRoom:onCloseActionCallback(elem,data)
    WZLog("WndFindRoom:onCloseActionCallback",elem,data)
    WindowManager:removeWindow(self.m_root, self, true)
    
end

--@brief	关闭查找房间按钮的函数
--@param	element:表绑定的UI节点引用
function WndFindRoom:onFindRoomBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local inputText = self:_getInputIdEditBox():getText()

	local editPassword_WndFindRoom = self.m_root:getChildElement("editPassword_WndFindRoom")
	if editPassword_WndFindRoom ~= nil then 
		WZUIEditBox:luaTo(editPassword_WndFindRoom)
	end 
	local inputPassword = editPassword_WndFindRoom:getText()
	
	if self.m_findBtnCallBack ~= nil then 
		self.m_findBtnCallBack(self.m_tCallBackLuaObject,inputText,inputPassword)
	end 
end 

--@brief	设置点击查找按钮回调的函数
--@param#1 	fun  传入的函数
--@param#2 	obj  传入的对象
function WndFindRoom:setFindBtnCallBack(fun,obj)
	self.m_findBtnCallBack = fun        
	self.m_tCallBackLuaObject = obj  
end 


function WndFindRoom:onChangeEdit( element )
	WZLog("WndFindRoom:onChangeEdit")
	element = WZUIEditBox:luaTo(element)
	local txt = element:getText()
	if txt == "" then
		self:_setOkTouch(false)
	else
		self:_setOkTouch(true)
	end
	local isIntNumber = false 
	if string.find(txt,"^[+-]?%d+$") then 
		isIntNumber = true 
	else 
		isIntNumber = false 
	end 
	if isIntNumber then 
		if tonumber(txt) <1 or tonumber(txt)>9999 then 
			--MsgBoxManager:showTipBox(LocalStrings.ROOM_FIND_TIPS) 
			self:_setOkTouch(true) 
		else 
			self:_setOkTouch(true)
		end 
	else 
		self:_setOkTouch(true)
		--MsgBoxManager:showTipBox(LocalStrings.ROOM_FIND_TIPS)
	end
end

function WndFindRoom:_setOkTouch( bState )
	local btnOk = self.m_root:getChildElement("btnFindRoom_WndFindRoom")
	if btnOk then
		btnOk = WZUIButton:luaTo(btnOk)
		btnOk:setTouchEnable(bState)
	end
end
-------------------------------------公有方法模块End----------------------------------------


--@brief	设置静态UI文字的函数
function WndFindRoom:_setStatiUiText()
	--房间ID
	local txtRoomId = GetElement(self.m_root,"txtRoomId_WndFindRoom",WZUILabelTTF)
    txtRoomId:setText(LocalStrings.ROOM_ID)

    --点击输入房间ID
    local editRoomId = GetElement(self.m_root,"editRoomId_WndFindRoom",WZUIEditBox)
    editRoomId:setPlaceHolder(LocalStrings.CLICK_TO_INPUT_ID)

	--密码
    local txtPass = GetElement(self.m_root,"txtRoomPass_WndFindRoom",WZUILabelTTF)
    txtPass:setText(LocalStrings.PASSWORD)

    local editPass = GetElement(self.m_root,"editPassword_WndFindRoom",WZUIEditBox)
    editPass:setPlaceHolder(LocalStrings.CLICK_TO_INPUT_PASSWORD)
end 



--@brief	取得编辑框控件对象的函数
--@return   编辑框控件本身
function WndFindRoom:_getInputIdEditBox()
	if self.m_root == nil then 
		WZLog("WndFindRoom:getInputIdEditBox() self.m_root is nil ")
		return 
	end 
	
	local editRoomId = self.m_root:getChildElement("editRoomId_WndFindRoom")
	if editRoomId ~= nil then 
		return WZUIEditBox:luaTo(editRoomId)
	end 
end 


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配器模块Begin--------------------------------------
--@brief	英文适配函数
--@note		英文适配函数
function WndFindRoom:_adaptLanguage_en()
	local txtCopyHall = self.m_root:getChildElement("txtFindRoom_WndFindRoom")
	if txtCopyHall ~= nil then 
		WZUILabelTTF:luaTo(txtCopyHall):setFontSize(26)
	end	
end 


function WndFindRoom:_adaptLanguage_vn(  )
	local txtCopyHall = self.m_root:getChildElement("txtFindRoom_WndFindRoom")
	if txtCopyHall ~= nil then 
		WZUILabelTTF:luaTo(txtCopyHall):setFontSize(26)
	end

	local imgFindRoom_1_WndFindRoom = self.m_root:getChildElement("imgFindRoom_1_WndFindRoom")
	local imgFindRoom_2_WndFindRoom = self.m_root:getChildElement("imgFindRoom_2_WndFindRoom")

	if imgFindRoom_1_WndFindRoom ~= nil then
		WZUI9Image:luaTo(imgFindRoom_1_WndFindRoom):setRelativeSize(CCSize(1.2,1))
	end

	if imgFindRoom_2_WndFindRoom ~= nil then
		WZUI9Image:luaTo(imgFindRoom_2_WndFindRoom):setRelativeSize(CCSize(1.2,1))
	end
end

--@brief	葡语适配函数
--@note		葡语适配函数
function WndFindRoom:_adaptLanguage_pt()
	local txtRoomId = self.m_root:getChildElement("txtRoomId_WndEditBox")
	if txtRoomId ~= nil then 
		WZUILabelTTF:luaTo(txtRoomId):setRelativePosition(ccp(0.08125,0.5))
	end 

	GetElement(self.m_root,"txtConfirm_WndFindRoom",WZUILabelTTF):setFontSize(23)
end 

function WndFindRoom:_adaptLanguage_es(  )
	local txtRoomId = GetElement(self.m_root,"txtRoomId_WndFindRoom",WZUILabelTTF)
	txtRoomId:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root,"txtConfirm_WndFindRoom",WZUILabelTTF):setScale(0.9)
end

function WndFindRoom:_adaptLanguage_ug(  )
	GetElement(self.m_root,"txtRoomId_WndFindRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.95,0.5))
	GetElement(self.m_root,"txtRoomPass_WndFindRoom",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.95,0.5))
	GetElement(self.m_root,"conRoomId_WndFindRoom",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.32,0.5))
	GetElement(self.m_root,"conRoomPass_WndFindRoom",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.32,0.5))

	local txtCancel = GetElement(self.m_root,"txtCancel_WndFindRoom",WZUILabelTTF)
	txtCancel:setScale(0.7)
	txtCancel:setDimensions(GlobalMethod:CCSize(150))
	GetElement(self.m_root,"txtConfirm_WndFindRoom",WZUILabelTTF):setScale(0.55)
end
-------------------------------------语言适配器模块End----------------------------------------
