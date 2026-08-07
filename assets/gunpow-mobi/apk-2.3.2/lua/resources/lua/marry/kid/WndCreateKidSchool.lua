--WndCreateKidSchool.lua
--@brief	WndCreateKidSchool的UI模块
--@date		2013/12/26
--@author	林庆凯
--@note		创建公会窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCreateKidSchool:onEnter(element)
	self.m_root = element
	self:_policy()
	--彩色喇叭
	ChangeChatChannel(Chat_Channel_Guild_Create)
	--初始化UI静态文字
	self:_initUiStaticText()
	--多语言描边字
	self:_moreLanguageForStroke()
	WindowManagerAni:createAction(element,true)
	--多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	加载完成
function WndCreateKidSchool:onEnterTransitionDidFinish(element)

	local schoolConsumeForCreate = CacheCenter:getGameParam().schoolConsumeForCreate
	local ids, num = SplitItemString(schoolConsumeForCreate)

	local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndCreateKidSchool", WZUIImage)
	local cost = GetElement(self.m_root,"cost_WndCreateKidSchool",WZUILabelTTF)
	if self.m_nType == 1 then
		imgCostIcon:setFile(GDatatab_item["id_"..ids[1]].icon)
		imgCostIcon:setScale(0.6)
		cost:setText(num[1])
	elseif self.m_nType == 2 then
		imgCostIcon:setFile(GDatatab_item["id_"..ids[2]].icon)
		imgCostIcon:setScale(0.6)
		cost:setText(num[2])
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCreateKidSchool:onExit(element)
	self:_unInit()
end

function WndCreateKidSchool:onActionCallBack()
	if self.m_root ~= nil then 
		WindowManager:removeWindow(WndCreateKidSchool.m_root, WndCreateKidSchool, true)
	end 
end

function WndCreateKidSchool:onCloseActionCallback()
	WindowManager:removeWindow(WndCreateKidSchool.m_root, WndCreateKidSchool, true)
end

--@brief	关闭整个窗口的函数
function WndCreateKidSchool:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		--音效
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	点击创建公会按钮的函数
function WndCreateKidSchool:onCreateCommunityBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local sInputName = nil 
	local editBoxInputName = self.m_root:getChildElement("editBoxInputName_WndCreateKidSchool")
	if editBoxInputName ~= nil then 
		editBoxInputName =	WZUIEditBox:luaTo(editBoxInputName)
		sInputName = editBoxInputName:getText()
		local _, isMingan = CheckYellow(sInputName)
	    if isMingan then
	        MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
	        return false
	    end
	end 

	local sInputPassword = ""
	local editBoxInputPassword = self.m_root:getChildElement("editBoxInputPassword_WndCreateKidSchool")
	if editBoxInputPassword ~= nil then 
		editBoxInputPassword =	WZUIEditBox:luaTo(editBoxInputPassword)
		sInputPassword = editBoxInputPassword:getText()
	end 

	if self.m_ClickBtnCallBackFun ~= nil then 
		self.m_ClickBtnCallBackFun(self.m_tCallBackLuaOjbect,sInputName,sInputPassword)
	end 
	WindowManager:removeWindow(self.m_root,WndCreateKidSchool)
end 

--@brief	设置点击按钮选中时回调函数
--@param	fun:函数的变量,obj:表对象
function WndCreateKidSchool:setBtnCallBack(fun,obj)
	self.m_ClickBtnCallBackFun = fun
	self.m_tCallBackLuaOjbect = obj 
end 

--@brief	提供给外部调用创建公会的函数
--@param	fun:函数的变量,obj:表对象
function WndCreateKidSchool:showInterface(nType,fun,obj)
	local wnd = WndCreateKidSchool:createElement()
	if wnd ~= nil then 
		self.m_nType = nType
		WindowManager:addWindow(wnd, WndCreateKidSchool)
	end
	self:setBtnCallBack(fun,obj)
end 
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置点击输入名字编辑框状态的函数
function WndCreateKidSchool:_setEditBoxInPutIdState()
	if self.m_root == nil then 
		WZLog(" WndCreateKidSchool:setEditBoxInPutId(element) is nil ")
	end 
	local editBoxInputName = self.m_root:getChildElement("editBoxInputName_WndCreateKidSchool")
	if editBoxInputName ~= nil then 
		editBoxInputName = WZUIEditBox:luaTo(editBoxInputName)
		if editBoxInputName ~= nil then 
			editBoxInputName:setPlaceHolder(LocalStrings.CLICK_INPUT_NAME)
		end 
	end 

	local editBoxInputPassword = self.m_root:getChildElement("editBoxInputPassword_WndCreateKidSchool")
	if editBoxInputPassword ~= nil then 
		editBoxInputPassword = WZUIEditBox:luaTo(editBoxInputPassword)
		if editBoxInputPassword ~= nil then 
			editBoxInputPassword:setPlaceHolder(LocalStrings.NO_PASSWORD)
		end 
	end 
end 

--@brief	初始化UI静态文字函数
function WndCreateKidSchool:_initUiStaticText()
	if self.m_root == nil then 
		WZLog("WndCreateKidSchool::_initUiStaticText() self.m_root is nil")
		return 
	end 
	
	--公会名称
	local txtCommunityName = self.m_root:getChildElement("txtCommunityName_WndCreateKidSchool")
	if txtCommunityName ~= nil then 
		WZUILabelTTF:luaTo(txtCommunityName):setText(LocalStrings.COMMUNITY_NAME)
	end 
	
	--设置编辑框默认文字（点击输入名字）
	self:_setEditBoxInPutIdState()
end 

--@brief 	多语言描边字
function WndCreateKidSchool:_moreLanguageForStroke()
	if self.m_root == nil  then
		return
	end
		--按钮上的字“创建公会”
	local txtCreateCommunity = self.m_root:getChildElement("txtCreateCommunity_WndCreateKidSchool")
	if txtCreateCommunity then
		txtCreateCommunity = WZUILabelTTF:luaTo(txtCreateCommunity)
		txtCreateCommunity:setText(LocalStrings.CONFIRM)
		txtCreateCommunity:setVisible(true)
	end

	local txtTitle = GetElement(self.m_root,"txtTitle_WndCreateKidSchool",WZUILabelTTF)
	if self.m_nType == 1 then
		txtTitle:setText(LocalStrings.KID_TEXT159)
	elseif self.m_nType == 2 then
		txtTitle:setText(LocalStrings.KID_TEXT172)
	end


end 
-------------------------------------私有方法模块End------------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function WndCreateKidSchool:_adaptLanguage_es()
	local txt = GetElement(self.m_root,"txtCommunityName_WndCreateKidSchool",WZUILabelTTF)
	txt:setFontSize(22)
	txt:setRelativePosition(GlobalMethod:ccp(0.157,0.7))
	local txtCost = GetElement(self.m_root,"txtCost_WndCreateKidSchool",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.31,0.5))
end
------------------------------------语言适配End----------------------------------------------