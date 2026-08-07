--WndKidSchoolInfo.lua
--@brief	WndKidSchoolInfo的UI模块
--@date		2021/04/23
--@author	yrd
--@note		孩子学校信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidSchoolInfo:onEnter(element)
    WZLog("WndKidSchoolInfo:onEnter")
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidSchoolInfo:onExit(element)
	self:_unInit()
end

--@brief    点击关闭按钮回调
function WndKidSchoolInfo:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    更新界面
function WndKidSchoolInfo:updateUI()
    GetElement(self.m_root,"txtSchoolName_WndKidSchoolInfo",WZUILabelTTF):setText(self.m_schoolName)
    GetElement(self.m_root,"txtSchoolId_WndKidSchoolInfo",WZUILabelTTF):setText("("..self.m_schoolId..")")
    GetElement(self.m_root,"conSchoolLock_WndKidSchoolInfo",WZUIContainer):setVisible(self.m_needPassword)

    GetElement(self.m_root,"txtSchoolLv_WndKidSchoolInfo",WZUILabelTTF):setText(self.m_level)
    GetElement(self.m_root,"txtSchoolPrincipal_WndKidSchoolInfo",WZUILabelTTF):setText(self.m_masterName)
    GetElement(self.m_root,"txtSchoolNum_WndKidSchoolInfo",WZUILabelTTF):setText(self.m_num)

    local strDec = self.m_declaration ~= "" and self.m_declaration or LocalStrings.BAGTIP1
    GetElement(self.m_root,"txtDeclaration_WndKidSchoolInfo",WZUILabelTTF):setText(LocalStrings.KID_TEXT251..strDec)

    local btnApply = GetElement(self.m_root,"btnApply_WndKidSchoolInfo",WZUIButton)
    btnApply:setVisible(false)
    if WndKidSchoolList:getType() == 2 then
        btnApply:setVisible(true)
    end
end

--@brief    点击申请按钮回调
function WndKidSchoolInfo:onClickApply(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_needPassword == true then
    	WndKidSchoolPassword:showInterface(self.m_schoolId,self.m_schoolName)
	else
        ProtocolProcessorKidSchool:send_SCHOOL_ApplySchool(self.m_schoolId, "")
    end

end

--@brief    点击查看按钮回调
function WndKidSchoolInfo:onClickPlayerInfo(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_masterId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
