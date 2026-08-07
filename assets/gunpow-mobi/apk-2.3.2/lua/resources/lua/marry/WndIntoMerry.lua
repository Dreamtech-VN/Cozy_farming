--WndIntoMerry.lua
--@brief	WndIntoMerry的UI模块
--@date		2014/08/16
--@author	fanchao
--@note		GetIntoMerry


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndIntoMerry:onEnter(element)
	self.m_root = element
  WZLog("WndIntoMerry:onEnter")
  self:_setPassWord()
   AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndIntoMerry:onExit(element)
	self:_unInit()
end

function WndIntoMerry:onCloseClick(element)
    WZLog("WndIntoMerry:onCloseClick(element)")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)
    if SceneWeddingChurch.m_tData and SceneWeddingChurch.m_tData.manName == GlobalGame.g_tPlayerInfo.sPlayerName or SceneWeddingChurch.m_tData.womanName == GlobalGame.g_tPlayerInfo.sPlayerName then
        WndGuest:_setPassWordStatic()
        WndGuest:_setpassWordBtnStaic()
    end
end


function WndIntoMerry:onOkClick(element)
    WZLog("WndIntoMerry:onOkClick(element)")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local editRoomPassword = self.m_root:getChildElement("editRoomPassword_WndIntoMerry")
    editRoomPassword = WZUIEditBox:luaTo(editRoomPassword)
    local passWord = editRoomPassword:getText()
    if editRoomPassword then
        WZLog("passWord:",passWord)
        --新郎新娘点击确定
        if GlobalGame.g_manName == GlobalGame.g_tPlayerInfo.sPlayerName or GlobalGame.g_womanName == GlobalGame.g_tPlayerInfo.sPlayerName then
            WZLog("结婚对象点击了确定")
            if passWord ~="" and not Regexp:isAllBlankChar(passWord) then
                ProtocolProcessorSceneWeddingChurch:send_WEDDING_SetPassword(true, passWord, SceneWeddingChurch.m_nWeddingNo)
            else
               WZLog("passWord-------nil")
               ProtocolProcessorSceneWeddingChurch:send_WEDDING_SetPassword(false, passWord, SceneWeddingChurch.m_nWeddingNo)
               WndGuest:_setPassWordStatic()
               WndGuest:_setpassWordBtnStaic( )
            end
        else  
           --宾客点击确定
           WZLog("宾客点击确定.......")
           ProtocolProcessorGlobal:send_WEDDING_JoinWedding(GlobalGame.g_sWenddingNum,passWord)
        end
    end
    WindowManager:removeWindow(self.m_root, self, true)
end


function WndIntoMerry:_setPassWord()
    WZLog("WndIntoMerry:_setPassWord = ",self.m_sHallPass)
    local editRoomPassword = self.m_root:getChildElement("editRoomPassword_WndIntoMerry")
    if editRoomPassword and self.m_sHallPass  ~= nil then
       editRoomPassword = WZUIEditBox:luaTo(editRoomPassword)
       editRoomPassword:setText(self.m_sHallPass)
   end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin--------------------------------------
function WndIntoMerry:_adaptLanguage_en()
    WZLog("WndIntoMerry:_adaptLanguage_en")
    local btnSetPasspordBtn = GetElement(self.m_root,"btnSetPasspordBtn_WndGuest",WZUIButton)
    btnSetPasspordBtn:setAbsContentSize(GlobalMethod:CCSize(156,62))
    btnSetPasspordBtn:updateRelativeSize()
    btnSetPasspordBtn:setRelativePosition(GlobalMethod:ccp(0.363454,0.548984))
end

function WndIntoMerry:_adaptLanguage_pt(  )
    local btnSetPasspordBtn = GetElement(self.m_root,"btnSetPasspordBtn_WndGuest",WZUIButton)
    btnSetPasspordBtn:setAbsContentSize(GlobalMethod:CCSize(156,62))
    btnSetPasspordBtn:updateRelativeSize()
    btnSetPasspordBtn:setRelativePosition(GlobalMethod:ccp(0.363454,0.548984))
end

function WndIntoMerry:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtPassWord_WndIntoMerry",WZUILabelTTF):setFontSize(18)
end

function WndIntoMerry:_adaptLanguage_es(  )
    local txtPass = GetElement(self.m_root,"txtPassWord_WndIntoMerry",WZUILabelTTF)
    txtPass:setFontSize(16)
end
-------------------------------------语言适配模块End----------------------------------------
