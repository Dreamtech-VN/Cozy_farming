--WndCreateCommunity.lua
--@brief	WndCreateCommunity的UI模块
--@date		2013/12/26
--@author	林庆凯
--@note		创建公会窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCreateCommunity:onEnter(element)
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
function WndCreateCommunity:onEnterTransitionDidFinish(element)

	local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndCreateCommunity", WZUIImage)
	if imgCostIcon then
		if CacheCenter:getGameParam().isUseTicket == "0" then
			imgCostIcon:setFile(GDatatab_item["id_70"].icon)
		else
			imgCostIcon:setFile(GDatatab_item["id_1"].icon)
		end
		imgCostIcon:setScale(0.6)
	end
	if CacheCenter:getGameParam().guildCreateDiam ~= nil then
		GetElement(self.m_root,"cost_WndCreateCommunity",WZUILabelTTF):setText(CacheCenter:getGameParam().guildCreateDiam)
	else
		GetElement(self.m_root,"cost_WndCreateCommunity",WZUILabelTTF):setText("500")
	end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCreateCommunity:onExit(element)
	self:_unInit()
end

function WndCreateCommunity:onActionCallBack()
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, WndCreateCommunity, true)
	end 
end

function WndCreateCommunity:onCloseActionCallback()
	WindowManager:removeWindow(self.m_root, WndCreateCommunity, true)
end

--@brief	关闭整个窗口的函数
function WndCreateCommunity:onCloseWindowBtn(element)
	if self.m_root ~= nil then 
		--音效
		SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
		WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
	end 
end 

--@brief	点击创建公会按钮的函数
function WndCreateCommunity:onCreateCommunityBtn(element)
	--音效
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local sInputName = nil 
	local editBoxInputName = self.m_root:getChildElement("editBoxInputName_WndCreateCommunity")
	if editBoxInputName ~= nil then 
		editBoxInputName =	WZUIEditBox:luaTo(editBoxInputName)
		sInputName = editBoxInputName:getText()
	end 
	if self.m_ClickBtnCallBackFun ~= nil then 
		self.m_ClickBtnCallBackFun(self.m_tCallBackLuaOjbect,sInputName)
	end 
	WindowManager:removeWindow(self.m_root,WndCreateCommunity)
end 

--@brief	设置点击按钮选中时回调函数
--@param	fun:函数的变量,obj:表对象
function WndCreateCommunity:setBtnCallBack(fun,obj)
	self.m_ClickBtnCallBackFun = fun
	self.m_tCallBackLuaOjbect = obj 
end 

--@brief	提供给外部调用创建公会的函数
--@param	fun:函数的变量,obj:表对象
function WndCreateCommunity:onJumpToWndCreateCommunity(fun,obj)
	local wndCreateCommunity = WndCreateCommunity:createElement()
	if wndCreateCommunity ~= nil then 
		WindowManager:addWindow(wndCreateCommunity, WndCreateCommunity)
	end 	
	self:setBtnCallBack(fun,obj)
end 
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置点击输入名字编辑框状态的函数
function WndCreateCommunity:_setEditBoxInPutIdState()
	if self.m_root == nil then 
		WZLog(" WndCreateCommunity:setEditBoxInPutId(element) is nil ")
	end 
	local editBoxInputName = self.m_root:getChildElement("editBoxInputName_WndCreateCommunity")
	if editBoxInputName ~= nil then 
		editBoxInputName = WZUIEditBox:luaTo(editBoxInputName)
		if editBoxInputName ~= nil then 
			editBoxInputName:setPlaceHolder(LocalStrings.CLICK_INPUT_NAME)
		end 
	end 
end 

--@brief	初始化UI静态文字函数
function WndCreateCommunity:_initUiStaticText()
	if self.m_root == nil then 
		WZLog("WndCreateCommunity::_initUiStaticText() self.m_root is nil")
		return 
	end 
	
	--公会名称
	local txtCommunityName = self.m_root:getChildElement("txtCommunityName_WndCreateCommunity")
	if txtCommunityName ~= nil then 
		WZUILabelTTF:luaTo(txtCommunityName):setText(LocalStrings.COMMUNITY_NAME)
	end 
	
	--设置编辑框默认文字（点击输入名字）
	self:_setEditBoxInPutIdState()
end 

--@brief 	多语言描边字
function WndCreateCommunity:_moreLanguageForStroke()
	if self.m_root == nil  then
		return
	end

	--按钮上的字“创建公会”
	local txtCreateCommunity = self.m_root:getChildElement("txtCreateCommunity_WndCreateCommunity")
	if txtCreateCommunity then
		txtCreateCommunity = WZUILabelTTF:luaTo(txtCreateCommunity)
		txtCreateCommunity:setText(LocalStrings.CONFIRM)
		txtCreateCommunity:setVisible(true)
	end
end 
-------------------------------------私有方法模块End------------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function WndCreateCommunity:_adaptLanguage_es()
	local txt = GetElement(self.m_root,"txtCommunityName_WndCreateCommunity",WZUILabelTTF)
	txt:setFontSize(22)
	txt:setRelativePosition(GlobalMethod:ccp(0.157,0.7))
	local txtCost = GetElement(self.m_root,"txtCost_WndCreateCommunity",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.31,0.5))
end
------------------------------------语言适配End----------------------------------------------