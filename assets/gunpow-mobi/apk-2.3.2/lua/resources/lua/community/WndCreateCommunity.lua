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
	local guildCreateCost = CacheCenter:getGameParam().guildCreateCost or "[70,300]"
	if self.m_nWinType == 1 then 
		guildCreateCost = CacheCenter:getGameParam().leagueCreateCost
	end
	local ids,nums = SplitItemString(guildCreateCost)
	local strFormat1 = [[<T C="255,227,116" S="24" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	local strFormat2 = [[<I Z="0.6" P="1">%s</I><T C="255,227,116" S="24" P="1" SC="79,60,48" SS="4" SE="1">%d</T>]]
	local strFormat3 = [[<T C="255,227,116" S="24" P="1" SC="132,66,29" SS="4" SE="1">, </T>]]
	local strContent = string.format(strFormat1, LocalStrings.ATH_SHOP_COST)
	for i = 1, #ids do
		local icon = GDatatab_item["id_"..ids[i]].icon
		if i > 1 then 
			strContent = strContent .. strFormat3 
		end
		local strTemp = string.format(strFormat2, icon, nums[i])
		strContent = strContent .. strTemp
	end
	GetElement(self.m_root,"ftxtCost_WndCreateCommunity", WZUIFreeTextBox):setShowText(strContent)

	if self.m_nWinType == 1 then 
		GetElement(self.m_root, "txtTitle_WndCreateCommunity", WZUILabelTTF):setText(LocalStrings.UNION_TEXT1[2])
	elseif self.m_nWinType == 0 then 
		GetElement(self.m_root, "txtTitle_WndCreateCommunity", WZUILabelTTF):setText(LocalStrings.CREATE_COMMUNITY)
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
		local _, isMingan = CheckYellow(sInputName)
	    if isMingan then
	        MsgBoxManager:showTipBox(LocalStrings.NON_COMPLIANT)
	        return false
	    end
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
--@param 	nWinType: nil或0创建公会；1创建联盟
function WndCreateCommunity:onJumpToWndCreateCommunity(fun,obj, nWinType)
	local wndCreateCommunity = WndCreateCommunity:createElement()
	if wndCreateCommunity ~= nil then 
		self.m_nWinType = nWinType or 0
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

function WndCreateCommunity:_adaptLanguage_ug()
	GetElement(self.m_root,"txtCommunityName_WndCreateCommunity",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.8,0.7))
	GetElement(self.m_root,"EditContainer_WndCreateCommunity",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.4,0.7))

	GetElement(self.m_root,"txtCost_WndCreateCommunity",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.824444,0.5))
	GetElement(self.m_root,"cost_WndCreateCommunity",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.352614,0.5))

	GetElement(self.m_root,"txtCreateCommunity_WndCreateCommunity",WZUILabelTTF):setScale(0.6)
end
------------------------------------语言适配End----------------------------------------------