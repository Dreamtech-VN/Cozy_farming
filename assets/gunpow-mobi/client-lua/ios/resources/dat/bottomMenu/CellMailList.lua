--CellMailList.lua
--@brief	CellMailList的UI模块
--@date		2013/12/06
--@author	liangguang_long
--@note     邮件模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMailList:onEnter(element)
	self.m_root = element
	--self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMailList:onExit(element)  
	self:unInit()
end

--@brief	按钮点击时被调用的函数
--@param	element:按下当前邮件列表的节点
function CellMailList:onClickCurCell(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_root == nil or self.m_tCellData == nil then
        return
    end
	local nTag = self.m_root:getTag()
    local nMailId = self.m_tCellData.mailId
    WndMail:onCellClick(self.m_tCellData, self)--打开邮件 
    GetElement(self.m_root,"imgCellBg_CellMailList",WZUI9Image):setFile("ui/common/common_scale9_beibaodi_sel.png")
end

--@brief 是否显示被选中的按钮
function CellMailList:setChoiceState(state)
	local element = GetElement(self.m_root,"imgCellBg_CellMailList",WZUI9Image)
	if state then
		element:setFile("ui/common/common_scale9_beibaodi_sel.png")
	else
		element:setFile("ui/common/common_scale9_di18.png")
	end
end

--@brief 是否显示可勾选的状态
function CellMailList:setCheckState(state)
	self.b_checkstate = state
	local element = GetElement(self.m_root, "imgMailIcon_CellMaiList", WZUIImage)
	if element == nil then return end
	GetElement(self.m_root, "imgMailIcon_CellMaiList", WZUIImage):setVisible(state) 
    GetElement(self.m_root, "conCheckBoxMail_CellMaiList", WZUIContainer):setVisible(not state) 
	GetElement(self.m_root,"conGou_CellMailList",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conHasGet_CellMaiList",WZUIContainer):setVisible(state)
end

--@brief 设置邮箱的icon图像显示图片
function CellMailList:setIconState(state)
	-- 邮件图标
	if self.m_root == nil or self.m_tCellData == nil then
        return
    end
	WZLog("CellMailList:setIconState:", self.m_tCellData.mailType, state)
    local imgMailIcon = GetElement(self.m_root,"imgMailIcon_CellMaiList",WZUIImage)
    if imgMailIcon == nil then
    	self.m_tCellData.isRead = state
    	return
    end
    if self.m_tCellData.mailType == 1 then
    	GetElement(self.m_root,"imgIsNew_CellMailList",WZUIImage):setVisible(state == 0)
		if state == 0 then --未打开
			if self.m_tCellData.attachment == 0 then
				imgMailIcon:setFile("ui/mail/email_icon_guan.png")
			else
				imgMailIcon:setFile("ui/mail/email_icon_liwu.png")
			end
		elseif state == 1 then --有附件
			imgMailIcon:setFile("ui/mail/email_icon_liwu.png")
		elseif state == 2 then --有附件
			imgMailIcon:setFile("ui/mail/email_icon_kai.png")
			if self.m_tCellData.attachment ~= 0 then
				GetElement(self.m_root,"imgHasGet_CellMaiList",WZUIImage):setVisible(true)
			end
		elseif state == 8 then --领了附件，未读
			GetElement(self.m_root,"imgIsNew_CellMailList",WZUIImage):setVisible(state == 8)
			imgMailIcon:setFile("ui/mail/email_icon_guan.png")
		end
	elseif self.m_tCellData.mailType == 2 then
		imgMailIcon:setFile("ui/mail/email_icon_youxinde.png")
	elseif self.m_tCellData.mailType == WndMail.n_editMailId then
		imgMailIcon:setFile("ui/mail/email_icon_xie.png")
	end
end

--@brief	CheckBoxl按钮点击时被调用的函数
--@param	element:复选框控件的节点
function CellMailList:onSelBtnClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then 
		return 
	end
	self.m_checkState = self.m_checkState == 0 and 1 or 0
	if self.m_checkState == 0 then
		GetElement(self.m_root,"conGou_CellMailList",WZUIContainer):setVisible(false)
	else
		GetElement(self.m_root,"conGou_CellMailList",WZUIContainer):setVisible(true)
	end
    WndMail:selCheckNumCounter(0,self.m_checkState) 
    self:onClickCurCell()
	--WndMail:countSelCheckNum(element)

end

--@brief	获取邮件类型
function CellMailList:getCheckState()
	return self.m_checkState
end

--@brief	获取邮件类型
function CellMailList:getMailType()
	return self.m_nMailType
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	界面更新函数
--@note		更新邮件图标,主题,发送者,时间
function CellMailList:_update()
	if self.m_root == nil then 
		return 
	end
    --邮件数据
    local nMailReadTag = self.m_tCellData.isRead --邮件是否读标志：0，1，2
    local sMailTheme = self.m_tCellData.theme --邮件主题
    local nMailType = self.m_tCellData.mailType
	local isSys = self.m_tCellData.sendId < 10
    if nMailType == WndMail.n_editMailId then
        sMailTheme = LocalStrings.EDIT_MAIL
    end
    local sMailTime = string.sub(self.m_tCellData.time,6,11) --邮件时间
    if 	nMailType == 3 then --商务箱的
    	self:setMailHead()
    else
		self:setIconState(nMailReadTag)
	end
	self:setChoiceState(self.m_tCellData.choiceState)
	--主题
    local txtMailTheme = GetElement(self.m_root,"txtMailTheme_CellMailList",WZUILabelTTF)
	txtMailTheme:setText(sMailTheme)
	if isSys then
		GetElement(self.m_root,"imgType_CellMailList",WZUIImage):setVisible(true)
		txtMailTheme:setRelativePosition(GlobalMethod:ccp(0.275054,0.3375))
	end
	--时间
    GetElement(self.m_root,"txtMailData_CellMaiList",WZUILabelTTF):setText(sMailTime)
    self:_setCheckBoxStatic(self.m_checkState)
    self:setCheckState(self.b_checkstate)
end

--设置玩家头像
function CellMailList:setMailHead()
	WZLog("CellMailList:setMailHead:", self.m_tCellData.headId, self.m_tCellData.faceId)
	local element = GetElement(self.m_root,"conHead_CellMaiList",WZUIContainer)
	element:setVisible(true)
	CellHead:show(element, self.m_tCellData.headId, self.m_tCellData.faceId, self.m_tCellData.sexs,nil,nil,nil,self.m_tCellData.color)
end

--@brief	设置邮件图标
function CellMailList:setMailIcon(path)
	if path == nil or path == "" then
		return
	end
	GetElement(self.m_root,"imgMailIcon_CellMaiList",WZUIImage):setFile(path)
end

--@brief	设置checkBox状态
function CellMailList:_setCheckBoxStatic(index)
	self.m_checkState = index
	local element = GetElement(self.m_root, "conGou_CellMailList", WZUIContainer)
	if element == nil then return end
	GetElement(self.m_root,"conGou_CellMailList",WZUIContainer):setVisible(index == 1)
end

-------------------------------------私有方法模块End----------------------------------------










