--WndEditBox.lua
--@brief	WndEditBox的UI模块
--@date		2015-7-31
--@author	binshao
--@note		EditBox输入窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEditBox:onEnter(element)
	self.m_root = element
    self:_policy()
    self:_update()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEditBox:onExit(element)
	self:_unInit()
end

--@brief	加载动画
function WndEditBox:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root,true,"actionCallback",self)
end

--@brief	动画加载完成回调
function WndEditBox:actionCallback(elem,data)
end

--@brief	关闭按钮点击回调
--@param	element:表绑定的UI节点引用
function WndEditBox:onCloseClick(element)
    WZLog("WndEditBox:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

function WndEditBox:onCloseActionCallback(element,data)
	 WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	编辑框改变回调函数
function WndEditBox:onChangeEdit(element)
	element = WZUIEditBox:luaTo(element)
	local txt = element:getText()
    local state = txt ~= self.m_tData.placeHolder and true or false
    self:_setOkTouch(state)
end

--@brief	确定按钮点击回调
--@param	element:表绑定的UI节点引用
function WndEditBox:onOkClick(element)
    WZLog("WndEditBox:onOkClick")
	
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local text = WZUIEditBox:luaTo(GetElement(self.m_root,"editBox_WndEditBox")):getText()
	if text == "" then
		MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
		return
	elseif Regexp:isAllBlankChar(text) == true then--全部是空白键
		MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
		return 
	end

    if self:_checkName() then
    	if self.m_lpOkCallBack then
    		self.m_lpOkCallBack(self.m_tCallbackTable,text, unpack(self.m_tCallbackArg),self.m_tOther)
    	end
    	WindowManager:removeWindow(self.m_root, self, true)
    end
end

function WndEditBox:_checkName()
    local editInputName = GetElement(self.m_root,"editBox_WndEditBox",WZUIEditBox)
    local txtName = editInputName:getText()

    local tip = {
        {LocalStrings.PLEASE_INPUT_ACTORNAME,LocalStrings.ACTOR_NAME_ERROR},
        {LocalStrings.PLEASE_INPUT_PSW,LocalStrings.NO_CONTROLCHAR}
    }

    -- 空或者不是字符串
    if type(txtName) ~= "string" or "" == txtName then
        MsgBoxManager:showTipBox(tip[self.editType][1], nil, nil, nil, nil)
        return false
    end

    WZLog("********** WndEditBox:_checkName **************", txtName)
    local nInputTextLen, spaceCnt = WndBag:_checkInputTxtLen(txtName)
    -- 不能存在空格，长度不超过6个字符
    if spaceCnt > 0 then
        MsgBoxManager:showTipBox(tip[self.editType][2])
        return false
    elseif nInputTextLen > 12 then
        if self.m_tOther then
            if self.m_tOther.main_type == 2 and self.m_tOther.sub_type == 0 then--使名笔
                MsgBoxManager:showTipBox(string.format(LocalStrings.ACTOR_MAX_NAME,6))
                return false
            elseif nInputTextLen > 16 and self.m_tOther.main_type == 2 and self.m_tOther.sub_type == 1 then -- 使用公会改名笔
                MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO5)
                return false
            end
        end
    end

    return true
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	WndEditBox更新函数
--@note 	实际上的初始化函数
function WndEditBox:_update()
    if not self.m_root then return end

    local txtTitle = GetElement(self.m_root,"txtTitle_WndEditBox", WZUILabelTTF)
    txtTitle:setText(self.m_tData.title)

    local txtEditStr = GetElement(self.m_root,"txtEditStr_WndEditBox", WZUILabelTTF)
    txtEditStr:setText(self.m_tData.editStr)

    local edit = GetElement(self.m_root,"editBox_WndEditBox", WZUIEditBox)
    edit:setPlaceHolder(self.m_tData.placeHolder)

    if ProjConfig.LANGUAGE == "pt" then
        if self.m_tData.placeHolder == LocalStrings.CLICK_TO_INPUT_NAME then
            edit:setScale(0.5)
            edit:setRelativePosition(GlobalMethod:ccp(0.3,0.45))
            --edit:setRelativeSize(GlobalMethod:CCSize(1,1))
        end
    end
end

--@brief	确定按钮是否可点
function WndEditBox:_setOkTouch(bTouch)
	local btnOk = GetElement(self.m_root,"btnOk_WndEditBox", WZUIButton)
	btnOk:setTouchEnable(bTouch)
end
-------------------------------------私有方法模块End----------------------------------------
--------------------------------------语言适配Begin-----------------------------------------
function WndEditBox:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtOk_WndEditBox",WZUILabelTTF):setScale(0.8)
end

function WndEditBox:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtOk_WndEditBox",WZUILabelTTF):setScale(0.8)
end
--------------------------------------语言适配End-------------------------------------------