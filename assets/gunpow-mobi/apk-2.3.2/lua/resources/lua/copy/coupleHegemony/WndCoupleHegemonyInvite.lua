--WndCoupleHegemonyInvite.lua
--@brief	WndCoupleHegemonyInvite的UI模块
--@date		2020/05/11
--@author	XTX
--@note		世界组队Boss邀请界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCoupleHegemonyInvite:onEnter(element)
	self.m_root = element
	CacheCenter:registerFriendListObserver(self)
	self:createLoading()
    ProtocolProcessorWndFriends:send_FRIEND_GetFriend(19,1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCoupleHegemonyInvite:onExit(element)
	CacheCenter:unregisterFriendListObserver(self)
	self:_unInit()
end

--@brief	加载动画
function WndCoupleHegemonyInvite:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAction(self.m_root,true,"onActionFinish",self)
    AdaptLanguage(self)
end

--@brief	动画完成
function WndCoupleHegemonyInvite:onActionFinish()
    self:_showMultiLanguage()
end

--@brief   创建加载框
function WndCoupleHegemonyInvite:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(nil,nil,nil,nil,nil,nil,nil,true)
end

--@brief   关闭加载框
function WndCoupleHegemonyInvite:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief	关闭按钮回调事件
function WndCoupleHegemonyInvite:onBackClick(element)
	WZLog("关闭按钮回调事件")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
	WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

--@brief	关闭按钮回调事件
function WndCoupleHegemonyInvite:onCloseActionCallback(element,data)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	好友点击回调
function WndCoupleHegemonyInvite:onFriendClick(element)
    WZLog("WndCoupleHegemonyInvite:onFriendClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tBack and self.m_tBack[1] and self.m_tBack[2] then
        self.m_tBack[2](self.m_tBack[1])
    end
    
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


function WndCoupleHegemonyInvite:updateUI()
	if self.m_root == nil then
		return
    end

    local conType1 = GetElement(self.m_root,"conType1_WndCoupleHegemonyInvite",WZUIContainer)
    local conType2 = GetElement(self.m_root,"conType2_WndCoupleHegemonyInvite",WZUIContainer)
    conType1:setVisible(false)
    conType2:setVisible(false)
    if self.m_tCouple then
        conType1:setVisible(true)

        local imgCoupleName = GetElement(self.m_root,"imgCoupleName_WndCoupleHegemonyInvite",WZUIImage)
        local conCoupleHead = GetElement(self.m_root,"conCoupleHead_WndCoupleHegemonyInvite",WZUIContainer)
        local txtLvValue = GetElement(self.m_root,"txtLvValue_WndCoupleHegemonyInvite",WZUILabelTTF)
        local txtName = GetElement(self.m_root,"txtName_WndCoupleHegemonyInvite",WZUILabelTTF)
        local txtFightValue = GetElement(self.m_root,"txtFightValue_WndCoupleHegemonyInvite",WZUILabelTTF)

        if CacheCenter:getPlayerInfo().sex == 0 then
            imgCoupleName:setFile("ui/marrige/text_fqzb_lp.png")
        else
            imgCoupleName:setFile("ui/marrige/text_fqzb_lg.png")
        end
        txtLvValue:setText(self.m_tCouple.level)
        txtName:setText(self.m_tCouple.name)
        txtFightValue:setText(self.m_tCouple.fighting)

        local headAnim, headObj = CellHead:show(conCoupleHead,self.m_tCouple.headItemId,self.m_tCouple.faceItemId,self.m_tCouple.sex,false,nil,nil,self.m_tCouple.headColor)
    else
        conType2:setVisible(true)
    end
end

--@note		多语言文本
function WndCoupleHegemonyInvite:_showMultiLanguage()
    local txtLvWord = GetElement(self.m_root,"txtLvWord_WndCoupleHegemonyInvite",WZUILabelTTF)
    txtLvWord:setText(LocalStrings.LV..".")

    local txtFightWord = GetElement(self.m_root,"txtFightWord_WndCoupleHegemonyInvite",WZUILabelTTF)
    txtFightWord:setText(LocalStrings.BATTLE..":")
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------

-------------------------------------语言适配End--------------------------------------------
