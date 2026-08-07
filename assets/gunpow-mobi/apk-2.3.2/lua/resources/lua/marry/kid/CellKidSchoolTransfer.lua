--CellKidSchoolTransfer.lua
--@brief	CellKidSchoolTransfer的UI模块
--@date		2021/05/27
--@author	yrd
--@note		孩子学校-转让子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidSchoolTransfer:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidSchoolTransfer:onExit(element)
	self:_unInit()
end

--@brief    点击关闭按钮回调
function CellKidSchoolTransfer:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    界面加载完成回调
function CellKidSchoolTransfer:onEnterTransitionDidFinish(element)
	self:updateUI()
end

--@brief    更新界面
function CellKidSchoolTransfer:updateUI()
	--父母头像
	local conHead1 = GetElement(self.m_root,"conHead1_CellKidSchoolTransfer",WZUIContainer)
	local imgHead = CellHead:show(conHead1, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, nil, nil, self.m_tData.headColor)
	--父母名字
	local strFormat = [[><T C="127,70,26" S="20" P="1">%s</T>]]
	local ftbName = GetElement(self.m_root,"ftbName_CellKidSchoolTransfer",WZUIFreeTextBox)
	ftbName:setShowText(string.format(strFormat,self.m_tData.name))
	--孩子头像
	local conHead2 = GetElement(self.m_root,"conHead2_CellKidSchoolTransfer",WZUIContainer)
	local imgHead = CellHead:show(conHead2, self.m_tData.childId, self.m_tData.cfaceId, self.m_tData.csex, nil, nil, nil, nil, nil, nil, nil, true)
	--孩子名字
	local txtCName = GetElement(self.m_root,"txtCName_CellKidSchoolTransfer",WZUILabelTTF)
	txtCName:setText(self.m_tData.cname)
end

--@brief    点击父母头像
function CellKidSchoolTransfer:onClickHead()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.pid)
end

--@brief    点击转让按钮
function CellKidSchoolTransfer:onClickTransferPlayer()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    MsgBoxManager:showConfirmBox(LocalStrings.KID_TEXT206, self, self.sureTransfer)
end

--@brief	确认转让
function CellKidSchoolTransfer:sureTransfer(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
	    ProtocolProcessorKidSchool:send_SCHOOL_ChangeSchoolMaster(self.m_tData.pid)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
