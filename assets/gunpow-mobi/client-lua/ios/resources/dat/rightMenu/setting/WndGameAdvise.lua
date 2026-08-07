--WndGameAdvise.lua
--@brief	WndGameAdvise的UI模块
--@date		2015/04/30
--@author	binshao
--@note		游戏建议


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameAdvise:onEnter(element)
    WZLog("WndGameAdvise:onEnter")

	self.m_root = element
	self:_initMoreLanguage()
    --英雄官网包的单独处理
    local packName = WGameCmUtil:GetBundleIdentifier()
    if packName == "com.wyd.dandandao.hero" or packName == "com.wyd.hero.dandandao.hero" then 
        GetElement(self.m_root, "conHeroAdvise_WndGameAdvise",WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conAdvise_WndGameAdvise",WZUIContainer):setVisible(false)
        if packName == "com.wyd.dandandao.hero" then
            GetElement(self.m_root, "txthero1_WndGameAdvise",WZUILabelTTF):setText(LocalStrings.ADVISE_HERO_DESC2)
            GetElement(self.m_root, "txthero2_WndGameAdvise",WZUILabelTTF):setText(LocalStrings.CONFIRM)
        else
            GetElement(self.m_root, "txthero1_WndGameAdvise",WZUILabelTTF):setText(LocalStrings.ADVISE_HERO_DESC)
            GetElement(self.m_root, "txthero2_WndGameAdvise",WZUILabelTTF):setText(LocalStrings.ADVISE_HERO)
        end
    end  
	AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function WndGameAdvise:actionCallback(element, data)
end

--@brief onEnter函数执行完成回调
function WndGameAdvise:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameAdvise:onExit(element)
    WZLog("WndGameAdvise:onExit")
	self:_unInit()
end

function WndGameAdvise:normalClose(  )
	WindowManager:removeWindow(self.m_root , WndGameAdvise , true)--关闭设置窗口
end


-- @brief  关闭公告界面Btn
function WndGameAdvise:onBtnClose( )
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root then WindowManagerAni:createCloseAction(self.m_root,"normalClose",self) end
end

-- @brief  关闭公告界面Btn
function WndGameAdvise:onTypeChoice(element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:setChoiceState(not self.b_typeState)
    
end

-- @brief  关闭公告界面Btn
function WndGameAdvise:onBtnType( element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    self.n_type = tag
	local title = {LocalStrings.SUGGESTTYPE_SUGGEST, LocalStrings.SUGGESTTYPE_QUESTIONASK, LocalStrings.SUGGESTTYPE_PAYASK}
	local txtSend2 = self.m_root:getChildElement("typeSet_WndGameAdvise")
    if txtSend2 then WZUILabelTTF:luaTo(txtSend2):setText(title[tag]) end
    self:setChoiceState(false)
end

-- @brief  关闭公告界面Btn
function WndGameAdvise:setChoiceState(bool)
    self.b_typeState = bool
    local con = GetElement(self.m_root, "conType_WndGameAdvise",WZUIContainer)
    con:setVisible(bool)
end

-- @brief  前往英雄官方论坛
function WndGameAdvise:onHeroWeb( element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local packName = WGameCmUtil:GetBundleIdentifier()
    if packName == "com.wyd.dandandao.hero" then
        if self.m_root then WindowManagerAni:createCloseAction(self.m_root,"normalClose",self) end
        return
    end
    WZPush:openURL("http://kf.yingxiong.com/Mobile/checkOption?Gid=73")
end

function WndGameAdvise:onBtnSend( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("sun_WndGameAdvise---",self.m_sAdvise,type(self.m_sAdvise))
    local editContentMail = WZUIEditBox:luaTo(self.m_root:getChildElement("editBox_WndGameAdvise"))
    local content = editContentMail:getText()
	if content == nil or content == "" then
		MsgBoxManager:showTipBox(LocalStrings.EDITMAILCONTENT)
		return
	end
	 WZLog("sun_WndGameAdvise222---",content)
    local tag = self.n_type -1 
     WZLog("sun_WndGameAdvise222---",tag)
    ProtocolProcessorWndMail:send_MAIL_SendSuggestion(tag, content )
    if self.m_root then WindowManagerAni:createCloseAction(self.m_root,"normalClose",self) end
end

--@brief	账号编辑框编辑开始时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndGameAdvise:onEditAdviseBegin(element)
end

--@brief	账号编辑框编辑结束时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndGameAdvise:onEditAdviseEnd(element)
end

--@brief	账号编辑框文本改变时被调用的函数
--@param	element:账号编辑框的UI节点引用
--@note		在这里做相应的事件响应操作
function WndGameAdvise:onEditAdviseTextChanged(element)
    WZLog("WndGameAdvise:onEditAdviseTextChanged")
	local editWord = WZUIEditBox:luaTo(element)
	if editWord then self.m_sAdvise = editWord:getText() end
end


--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndGameAdvise:_initMoreLanguage()
	local txtSend2 = self.m_root:getChildElement("typeSet_WndGameAdvise")
    if txtSend2 then WZUILabelTTF:luaTo(txtSend2):setText(LocalStrings.SUGGESTCLICK) end
    local txtSend = self.m_root:getChildElement("txtSend_WndGameAdvise")
    if txtSend then WZUILabelTTF:luaTo(txtSend):setText(LocalStrings.SEND) end
    GetElement(self.m_root,"editBox_WndGameAdvise",WZUIEditBox):setPlaceHolder(LocalStrings.INPUTDETAIL)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndGameAdvise:_adaptLanguage_vn()
	-- GetElement(self.m_root,"txtChoiceType2_WndGameAdvise",WZUILabelTTF):setFontSize(16)
 --    GetElement(self.m_root,"txtChoiceType3_WndGameAdvise",WZUILabelTTF):setFontSize(19)
    -- GetElement(self.m_root,"img1_WndGameAdvise",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.72,0.5))
    -- GetElement(self.m_root,"img2_WndGameAdvise",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.5))

    -- GetElement(self.m_root,"txtBtn1_WndGameAdvise",WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root,"txtBtn2_WndGameAdvise",WZUILabelTTF):setFontSize(14)
    GetElement(self.m_root,"txtBtn3_WndGameAdvise",WZUILabelTTF):setFontSize(18)
    
end

function WndGameAdvise:_adaptLanguage_pt(  )
    GetElement(self.m_root,"typeSet_WndGameAdvise",WZUILabelTTF):setFontSize(16)
    -- GetElement(self.m_root,"img1_WndGameAdvise",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.72,0.5))
    -- GetElement(self.m_root,"img2_WndGameAdvise",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.5))
end

function WndGameAdvise:_adaptLanguage_tr()
    -- GetElement(self.m_root,"txtChoiceType1_WndGameAdvise",WZUILabelTTF):setFontSize(20)
    -- GetElement(self.m_root,"txtChoiceType3_WndGameAdvise",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"typeSet_WndGameAdvise",WZUILabelTTF):setFontSize(22)

    GetElement(self.m_root,"txtBtn3_WndGameAdvise",WZUILabelTTF):setScale(0.7)
    -- GetElement(self.m_root,"img1_WndGameAdvise",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.72,0.5))
    -- GetElement(self.m_root,"img2_WndGameAdvise",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.5))
end

function WndGameAdvise:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtChoiceType1_WndGameAdvise",WZUILabelTTF):setFontSize(20)
end

function WndGameAdvise:_adaptLanguage_es()
    GetElement(self.m_root,"txtBtn1_WndGameAdvise",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtBtn2_WndGameAdvise",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"typeSet_WndGameAdvise",WZUILabelTTF):setFontSize(16)

    -- GetElement(self.m_root,"img1_WndGameAdvise",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.72,0.5))
    -- GetElement(self.m_root,"img2_WndGameAdvise",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.28,0.5))
end
-------------------------------------语言适配模块End--------------------------------------
