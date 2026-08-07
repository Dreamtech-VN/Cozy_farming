--WndKidSchoolList.lua
--@brief	WndKidSchoolList的UI模块
--@date		2021/04/21
--@author	yrd
--@note		孩子学校列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidSchoolList:onEnter(element)
    WZLog("WndKidSchoolList:onEnter",self.m_nType)
	self.m_root = element

	if self.m_nType == 1 then
		ProtocolProcessorKidSchool:send_SCHOOL_GetMySchoolInfo()
		ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolChildren()
		ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolList()
	elseif self.m_nType == 2 then
		ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolList()
	end

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidSchoolList:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidSchoolList:onEnterTransitionDidFinish(element)
	self:updateUI()
end

--@brief    点击关闭按钮回调
function WndKidSchoolList:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    更新界面
function WndKidSchoolList:updateUI()
	self:_initStaticText()
	self:updateTitleList()
	self:updateRedDot()
end

--@brief    更新红点
function WndKidSchoolList:updateRedDot()
	if self.m_root == nil then
		return
	end
    if GlobalGame.g_tRedPointList.schoolApplyWaiting then
        GetElement(self.m_root,"imgRedDot2_WndKidSchoolList",WZUIImage):setVisible(true)
        GetElement(self.m_root,"imgStudentRedDot_WndKidSchoolList",WZUIImage):setVisible(true)
    else
        GetElement(self.m_root,"imgRedDot2_WndKidSchoolList",WZUIImage):setVisible(false)
        GetElement(self.m_root,"imgStudentRedDot_WndKidSchoolList",WZUIImage):setVisible(false)
    end
end

--@brief    初始化静态文本
function WndKidSchoolList:_initStaticText()
	--界面标题
	local strTitle = LocalStrings.KID_TEXT129
	if SceneKidSchoolHome:getMyChildName() and SceneKidSchoolHome:getMyChildName()[1] then
		strTitle = SceneKidSchoolHome:getMyChildName()[1]
	end
	GetElement(self.m_root,"txtTitle_WndKidSchoolList",WZUILabelTTF):setText(strTitle)
	--界面1
	GetElement(self.m_root,"txt1Word1_WndKidSchoolList",WZUILabelTTF):setText(LocalStrings.TEAMBOSS_TEXT3)
	-- GetElement(self.m_root,"txt1Word2_WndKidSchoolList",WZUILabelTTF):setText(LocalStrings.NEWCOMMUNITY1)
	GetElement(self.m_root,"txt1Word3_WndKidSchoolList",WZUILabelTTF):setText(LocalStrings.KID_TEXT150)
	GetElement(self.m_root,"txt1Word4_WndKidSchoolList",WZUILabelTTF):setText(LocalStrings.KID_TEXT131..":")
	GetElement(self.m_root,"txt1Word5_WndKidSchoolList",WZUILabelTTF):setText(LocalStrings.KID_TEXT136..":")
	GetElement(self.m_root,"txt1Word6_WndKidSchoolList",WZUILabelTTF):setText(LocalStrings.PEOPLE_NUM)
	GetElement(self.m_root,"txt1Word7_WndKidSchoolList",WZUILabelTTF):setText(LocalStrings.KID_TEXT251)
end

--@brief    初始化界面左侧标题列表
function WndKidSchoolList:updateTitleList()
	local cbgTitle = GetElement(self.m_root,"cbgTitle_WndKidSchoolList",WZUICheckBoxGroup)
	local cbTitle1 = GetElement(self.m_root,"cbTitle1_WndKidSchoolList",WZUICheckBox)
	local cbTitle2 = GetElement(self.m_root,"cbTitle2_WndKidSchoolList",WZUICheckBox)
	local cbTitle3 = GetElement(self.m_root,"cbTitle3_WndKidSchoolList",WZUICheckBox)

	if self.m_nType == 1 then
		cbgTitle:setCheckIndex(0)
		cbTitle1:setVisible(true)
		cbTitle2:setVisible(true)
		cbTitle3:setVisible(true)
		cbTitle1:setRelativePosition(GlobalMethod:ccp(0.5,0.92))
		cbTitle2:setRelativePosition(GlobalMethod:ccp(0.5,0.77))
		cbTitle3:setRelativePosition(GlobalMethod:ccp(0.5,0.62))
		self:showContent(1)
	elseif self.m_nType == 2 then
		cbgTitle:setCheckIndex(2)
		cbTitle1:setVisible(false)
		cbTitle2:setVisible(false)
		cbTitle3:setVisible(true)
		-- cbTitle1:setRelativePosition(GlobalMethod:ccp(0.5,0.92))
		-- cbTitle2:setRelativePosition(GlobalMethod:ccp(0.5,0.77))
		cbTitle3:setRelativePosition(GlobalMethod:ccp(0.5,0.92))
		self:showContent(3)
	end
end

--@brief    显示内容
function WndKidSchoolList:showContent(nType)
	local conRight1 = GetElement(self.m_root,"conRight1_WndKidSchoolList",WZUIContainer)
	local conRight2 = GetElement(self.m_root,"conRight2_WndKidSchoolList",WZUIContainer)
	local conRight3 = GetElement(self.m_root,"conRight3_WndKidSchoolList",WZUIContainer)
	conRight1:setVisible(false)
	conRight2:setVisible(false)
	conRight3:setVisible(false)

	if nType == 1 then
		conRight1:setVisible(true)
		-- self:updateContent1()
	elseif nType == 2 then
		conRight2:setVisible(true)
		-- self:updateContent2()
	elseif nType == 3 then
		conRight3:setVisible(true)
		-- self:updateContent3()
	end
end

--@brief    更新界面1 学校基础
function WndKidSchoolList:updateContent1()
	--学校名
	local txt1SchoolName = GetElement(self.m_root,"txt1SchoolName_WndKidSchoolList",WZUILabelTTF)
	txt1SchoolName:setText(self.m_tMySchoolInfo.schoolName)
	local txt1SchoolLevel = GetElement(self.m_root,"txt1SchoolLevel_WndKidSchoolList",WZUILabelTTF)
	txt1SchoolLevel:setText(LocalStrings.LV..self.m_tMySchoolInfo.level)
	--改名
	local btnChangeName = GetElement(self.m_root,"btnChangeName_WndKidSchoolList",WZUIButton)
	if self.m_tMySchoolInfo.masterId == CacheCenter:getPlayerInfo().id then
		btnChangeName:setVisible(true)
	else
		btnChangeName:setVisible(false)
	end
	--学校id
	local txt1Id = GetElement(self.m_root,"txt1Value1_WndKidSchoolList",WZUILabelTTF)
	txt1Id:setText(self.m_tMySchoolInfo.schoolId)
	--锁按钮
	local btnLock = GetElement(self.m_root,"btnLock_WndKidSchoolList",WZUIButton)
	if SceneKidSchoolHome:isPrincipal() then
		btnLock:setVisible(true)
	else
		btnLock:setVisible(false)
	end
	local imgLock = GetElement(self.m_root,"imgLock_WndKidSchoolList",WZUIImage)
	if self.m_tMySchoolInfo.hasHide == true then
		imgLock:setFile("ui/common/common_icon_suo.png")
	else
		imgLock:setFile("ui/common/common_icon_suo_1.png")
	end
	-- --等级
	-- GetElement(self.m_root,"txt1Value2_WndKidSchoolList",WZUILabelTTF):setText(self.m_tMySchoolInfo.level)
	--人数
	GetElement(self.m_root,"txt1Value6_WndKidSchoolList",WZUILabelTTF):setText(self.m_tMySchoolInfo.inSchoolNum.."/"..self.m_tMySchoolInfo.num)
	--校长
	GetElement(self.m_root,"txt1Value3_WndKidSchoolList",WZUILabelTTF):setText(self.m_tMySchoolInfo.masterName)
	--学习效率
	GetElement(self.m_root,"txt1Value4_WndKidSchoolList",WZUILabelTTF):setText(SceneKidSchoolHome:getEffectId().."/"..SceneKidSchoolHome:getSchoolEffectId())
	--学校经验
	local exp = math.floor(self.m_tMySchoolInfo.schoolExp/self.m_tMySchoolInfo.maxExp*100)
	GetElement(self.m_root,"prog1Value5_WndKidSchoolList",WZUIProgress):setPercentage(exp)
	GetElement(self.m_root,"txt1Value5_WndKidSchoolList",WZUILabelTTF):setText(self.m_tMySchoolInfo.schoolExp.."/"..self.m_tMySchoolInfo.maxExp)
	--宣言
	self:setDeclaration(self.m_tMySchoolInfo.declaration)
	--捐赠消耗
	local strFormat = [[<I Z="0.4">%s</I><T C="255,250,236" S="22" P="1" SC="163,74,20" SE="1" SS="4">%s</T>]]
	local ftb1Donate1 = GetElement(self.m_root,"ftb1Donate1_WndKidSchoolList",WZUIFreeTextBox)
	local ftb1Donate2 = GetElement(self.m_root,"ftb1Donate2_WndKidSchoolList",WZUIFreeTextBox)
	for _,v in pairs(GDatatab_scdonate) do
		if v.type == 1 then
			local strCost = ""
			for i=1,#v.consume do
				local iteminfo = GDatatab_item["id_"..v.consume[i][1]]
				strCost = strCost .. string.format(strFormat,iteminfo.icon,v.consume[i][2])
			end
			ftb1Donate1:setShowText(strCost)
		elseif v.type == 2 then
			local strCost = ""
			for i=1,#v.consume do
				local iteminfo = GDatatab_item["id_"..v.consume[i][1]]
				strCost = strCost .. string.format(strFormat,iteminfo.icon,v.consume[i][2])
			end
			ftb1Donate2:setShowText(strCost)
		end
	end
	
	-- GetElement(self.m_root,"txt1Time2_WndKidSchoolList",WZUILabelTTF):setText(returnToTimeFormat(self.m_tMySchoolInfo.donateTime))
	local txt1Time2 = GetElement(self.m_root,"txt1Time2_WndKidSchoolList",WZUILabelTTF)
	txt1Time2:setText(returnToTimeFormat(self.m_tMySchoolInfo.donateTime))
	txt1Time2:enableSchedule("effectSchedule",1)
end

--@brief	编辑结束返回回调函数
function WndKidSchoolList:onReturn(element)
	WZLog("WndKidSchoolList:onReturn(element)::")
	element = WZUIEditBox:luaTo(element)
	local txt = element:getText()
	local subTxt = utf8sub(txt,1,30)
    element:setText(subTxt)
	checkEditLenovoWord(element)
end

--@brief	设置改变回调函数
function WndKidSchoolList:onChangeSignature(element)
	WZLog("WndKidSchoolList:onChangeSignature")
	element = WZUIEditBox:luaTo(element)
	local txt = element:getText()
	for k,v in pairs(ChatKeyWords) do
		local s,e = string.find(txt,v)
		if s and e and e > 0 then
			txt = string.gsub(txt,v,"x")
		end
	end
	element:setText(txt)
	if txt ~= self.m_strDeclaration then
		self:_sureBtnTouch(true)
		self.sureBtnState = "save"
		self:setSaveBtnText(LocalStrings.SAVE)
	end
end

--@brief	修改宣言内容
function WndKidSchoolList:setDeclaration( strDeclaration )
    local strDec = strDeclaration ~= "" and strDeclaration or LocalStrings.BAGTIP1
	GetElement(self.m_root,"editSign_WndKidSchoolList",WZUIEditBox):setText(strDec)
end

--@brief	保存按钮是否可触摸
function WndKidSchoolList:_sureBtnTouch(bTouch)
	GetElement(self.m_root,"btnSave_WndKidSchoolList",WZUIButton):setTouchEnable(bTouch)
end

--@brief	设置保存按钮上的文字
function WndKidSchoolList:setSaveBtnText(txt)
	local img = GetElement(self.m_root,"imgSave_WndKidSchoolList",WZUI9Image)
	if txt == LocalStrings.SAVE then
		img:setFile("ui/bag/common_icon_bcz.png")
	else
		img:setFile("ui/bag/common_icon_xf.png")
	end
end

--@brief	保存按钮回调函数
function WndKidSchoolList:onSaveClick()
	WZLog("WndKidSchoolList保存按钮回调函数")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.sureBtnState == "save" then
		--获取签名
		self.m_strDeclaration = tostring(GetElement(self.m_root,"editSign_WndKidSchoolList",WZUIEditBox):getText())
		self:_sureBtnTouch(true)
		self.sureBtnState = "change"
		self:setSaveBtnText(LocalStrings.CHANGE)

		ProtocolProcessorKidSchool:send_SCHOOL_EditSchoolDeclaration(self.m_strDeclaration)
	else
	--按钮是修改状态时的功能
		local editBox = GetElement(self.m_root,"editSign_WndKidSchoolList",WZUIEditBox)
		editBox:openInputKeyBoard()
		self.sureBtnState = "save"
		self:setSaveBtnText(LocalStrings.SAVE)
	end
end

--@brief    效率时间倒计时
function WndKidSchoolList:effectSchedule(element)
	local txt1Time2 = GetElement(self.m_root,"txt1Time2_WndKidSchoolList",WZUILabelTTF)
	self.m_tMySchoolInfo.donateTime = self.m_tMySchoolInfo.donateTime - 1
	if self.m_tMySchoolInfo.donateTime <= 0 then
		self.m_tMySchoolInfo.donateTime = 0
		txt1Time2:disableSchedule()
	end
	txt1Time2:setText(returnToTimeFormat(self.m_tMySchoolInfo.donateTime))
end

--@brief    更新界面2 学生
function WndKidSchoolList:updateContent2()
	--标题
	local conR2Title1 = GetElement(self.m_root,"conR2Title1_WndKidSchoolList",WZUIContainer)
	local conR2Title2 = GetElement(self.m_root,"conR2Title2_WndKidSchoolList",WZUIContainer)
	local btnStudentManage = GetElement(self.m_root,"btnStudentManage_WndKidSchoolList",WZUIButton)
	local btnDropOut = GetElement(self.m_root,"btnDropOut_WndKidSchoolList",WZUIButton)
	local btnTransfer = GetElement(self.m_root,"btnTransfer_WndKidSchoolList",WZUIButton)
	local btnDisband = GetElement(self.m_root,"btnDisband_WndKidSchoolList",WZUIButton)

	conR2Title1:setVisible(false)
	conR2Title2:setVisible(false)
	btnStudentManage:setVisible(false)
	btnDropOut:setVisible(false)
	btnTransfer:setVisible(false)
	btnDisband:setVisible(false)
	if SceneKidSchoolHome:isPrincipal() == true then
		conR2Title1:setVisible(true)
		btnStudentManage:setVisible(true)

		if self:isOnlyMyChild() then
			btnDisband:setVisible(true)
		else
			btnTransfer:setVisible(true)
		end
	else
		conR2Title2:setVisible(true)
		btnDropOut:setVisible(true)
	end

	local tconStudentList = GetElement(self.m_root,"tconStudentList_WndKidSchoolList",WZUITableContainer)
	tconStudentList:cleanTable()
	local conStudentList = GetElement(self.m_root, "conStudentList_WndKidSchoolList", WZUIContainer)
    if self.m_tSchoolChildren == nil or #self.m_tSchoolChildren == 0 then
        ShowPanelNullTip( conStudentList, LocalStrings.CHARM_RESULT, GlobalMethod:ccc3(195,171,148))
        return 
    end
    removeShowPanelNullTip(conStudentList)

	for i=1,#self.m_tSchoolChildren do
	    self.m_nStudentStartIndex = 1
	    tconStudentList:enableSchedule("_addStudentSchedule")
	end

end

--@brief    更新界面3 列表
function WndKidSchoolList:updateContent3()

	local conR3Title1 = GetElement(self.m_root,"conR3Title1_WndKidSchoolList",WZUIContainer)
	local conR3Title2 = GetElement(self.m_root,"conR3Title2_WndKidSchoolList",WZUIContainer)
	local btnCreateScool = GetElement(self.m_root,"btnCreateScool_WndKidSchoolList",WZUIButton)
	local btnRefreshScool = GetElement(self.m_root,"btnRefreshScool_WndKidSchoolList",WZUIButton)

	conR3Title1:setVisible(false)
	conR3Title2:setVisible(false)
	if self.m_nType == 1 then
		conR3Title1:setVisible(true)
	elseif self.m_nType == 2 then
		conR3Title2:setVisible(true)
		btnCreateScool:setVisible(true)
		btnRefreshScool:setVisible(true)
	end

	local tconSchoolList = GetElement(self.m_root,"tconSchoolList_WndKidSchoolList",WZUITableContainer)
	tconSchoolList:cleanTable()

	local conSchoolList = GetElement(self.m_root, "conSchoolList_WndKidSchoolList", WZUIContainer)
    if self.m_tSchoolDataList == nil or #self.m_tSchoolDataList == 0 then
        ShowPanelNullTip( conSchoolList, LocalStrings.CHARM_RESULT, GlobalMethod:ccc3(195,171,148))
        return 
    end
    removeShowPanelNullTip(conSchoolList)

	for i=1,#self.m_tSchoolDataList do
	    self.m_nSchoolStartIndex = 1
	    tconSchoolList:enableSchedule("_addSchoolSchedule")
	end

	-- 设置搜索的默认提示
	local editFind = GetElement(self.m_root,"editFind_WndKidSchoolList",WZUIEditBox)
	if editFind then
		editFind:setPlaceHolder(LocalStrings.KID_TEXT145)
	end

end


--@brief  每帧加载学生
function WndKidSchoolList:_addStudentSchedule(element)
    local tconStudentList = GetElement(self.m_root,"tconStudentList_WndKidSchoolList",WZUITableContainer)
    
    -- local endIndex = math.min(self.m_nStudentStartIndex+2,#self.m_tSchoolChildren)
    for i=self.m_nStudentStartIndex,#self.m_tSchoolChildren do
        local celElement, tNewObj = CellKidSchoolList:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            local ntype = nil
            if SceneKidSchoolHome:isPrincipal() then
            	ntype = 3
            else
            	ntype = 4
            end
            tNewObj:setData(ntype,self.m_tSchoolChildren[i])
            tconStudentList:setCellElement(celElement)
        end
        self.m_nStudentStartIndex = self.m_nStudentStartIndex + 1
    end
    if self.m_nStudentStartIndex > #self.m_tSchoolChildren then
        tconStudentList:disableSchedule()
    end
end


--@brief  每帧加载学校
function WndKidSchoolList:_addSchoolSchedule(element)
    local tconSchoolList = GetElement(self.m_root,"tconSchoolList_WndKidSchoolList",WZUITableContainer)
    
    -- local endIndex = math.min(self.m_nSchoolStartIndex+2,#self.m_tSchoolDataList)
    for i=self.m_nSchoolStartIndex,#self.m_tSchoolDataList do
        local celElement, tNewObj = CellKidSchoolList:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            local ntype = nil
            if self.m_nType == 1 then
            	ntype = 1
            elseif self.m_nType == 2 then
            	ntype = 2
            end
            tNewObj:setData(ntype,self.m_tSchoolDataList[i])
            tconSchoolList:setCellElement(celElement)
        end
        self.m_nSchoolStartIndex = self.m_nSchoolStartIndex + 1
    end
    if self.m_nSchoolStartIndex > #self.m_tSchoolDataList then
        tconSchoolList:disableSchedule()
    end
end


--@brief    界面2 列表是否只有自己的小孩
function WndKidSchoolList:isOnlyMyChild()
	for i=1,#self.m_tSchoolChildren do
		if SceneKidSchoolHome:isMyChild(self.m_tSchoolChildren[i].id) == false then
			return false
		end
	end
	return true
end

--@brief    点击标题按钮回调
function WndKidSchoolList:onClickTitle(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local nTag = element:getTag()

    self:showContent(nTag)
end

--@brief    点击搜索按钮回调
function WndKidSchoolList:onClickFineSchool(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local editFind = GetElement(self.m_root,"editFind_WndKidSchoolList",WZUIEditBox)
    local txtFind = editFind:getText()

    -- 空或者不是字符串
    if type(txtFind) ~= "string" or "" == txtFind then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT146)
        return
    end
    --只能输入数字
    local nTempNum = string.find(txtFind, "%D")
    if nTempNum then 
        MsgBoxManager:showTipBox(LocalStrings.MANYCOLLECT_TEXT11)
        return
    end

    ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolInfo(tonumber(txtFind))
end

--@brief    点击"会员管理"按钮回调
function WndKidSchoolList:onClickManage(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndKidSchoolApprove:showInterface()
end

--@brief    点击"退学操作"按钮回调
function WndKidSchoolList:onClickDropOut(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	MsgBoxManager:showConfirmBox(LocalStrings.KID_TEXT189, self, self.sureDropOut)
end

--@brief    确认退学操作
function WndKidSchoolList:sureDropOut(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
	  --   local childIds = WZLuaVector_int_:create()
	  --   local tMyChild = SceneKidSchoolHome:getMyChildId()
	  --   for i=1,#tMyChild do
			-- childIds:push(tMyChild[i])
	  --   end
	    ProtocolProcessorKidSchool:send_SCHOOL_QuitSchool()
		-- ProtocolProcessorKidSchool:send_SCHOOL_ClearChild(childIds)
	end
end

--@brief    点击"创建学校"按钮回调
function WndKidSchoolList:onClickCreateSchool(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCreateKidSchool:showInterface(1,self.createSchoolCallback,self)
end

--@brief    创建学校事件回调
function WndKidSchoolList:createSchoolCallback(name,password)
	ProtocolProcessorKidSchool:send_SCHOOL_CreateSchool(password, name)
end

--@brief    点击"学校改名"按钮回调
function WndKidSchoolList:onClickChangeName(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCreateKidSchool:showInterface(2,self.changeSchoolCallback,self)
end

--@brief    学校改名事件回调
function WndKidSchoolList:changeSchoolCallback(name,password)
	ProtocolProcessorKidSchool:send_SCHOOL_EditSchool(password, name)
end

--@brief    点击"捐赠"按钮回调
function WndKidSchoolList:onClickDonate(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.m_nDonateTag = element:getTag()
    local strTips = ""
    if self.m_nDonateTag == 1 then
		strTips = LocalStrings.KID_TEXT213
	elseif self.m_nDonateTag == 2 then
		strTips = LocalStrings.KID_TEXT214
    end
    --消耗
    for _,v in pairs(GDatatab_scdonate) do
		if v.type == self.m_nDonateTag then
			for i=1,#v.consume do
				if not JudgeMoneyIsEnough(v.consume[i][1],v.consume[i][2],nil,nil,GlobalGame.g_nCurrentUIChannelId) then
					return
				end
			end
		end
	end

	MsgBoxManager:showConfirmBox(strTips, self, self.sureDonate)
end

--@brief    确认解散学校操作
function WndKidSchoolList:sureDonate(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
	    ProtocolProcessorKidSchool:send_SCHOOL_DonateSchool(self.m_nDonateTag)
	    self.m_nDonateTag = nil
	end
end

--@brief    点击"锁"按钮回调
function WndKidSchoolList:onClickLockSchool(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local status = 0
    if self.m_tMySchoolInfo.hasHide ~= true then
    	status = 1
    end
    ProtocolProcessorKidSchool:send_SCHOOL_HideSchool(status)
end

--@brief    点击"放大镜"按钮回调
function WndKidSchoolList:onClickPlayerInfo(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tMySchoolInfo.masterId)
end

--@brief    点击"叹号"按钮回调
function WndKidSchoolList:onClickRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.KID_TEXT175)
end

--@brief    点击"转让"按钮回调
function WndKidSchoolList:onClickTransfer(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndKidSchoolTransfer:showInterface(self.m_tSchoolParent)
end

--@brief    点击"刷新学校"按钮回调
function WndKidSchoolList:onClickRefreshSchool(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolList()
end

--@brief    点击"解散学校"按钮回调
function WndKidSchoolList:onClickDisband(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	MsgBoxManager:showConfirmBox(LocalStrings.KID_TEXT190, self, self.sureDisband)
end

--@brief    确认解散学校操作
function WndKidSchoolList:sureDisband(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
    	ProtocolProcessorKidSchool:send_SCHOOL_DismissSchool()
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndKidSchoolList:_adaptLanguage_vn()
	GetElement(self.m_root,"txt1Word1_WndKidSchoolList",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt1Word2_WndKidSchoolList",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt1Word3_WndKidSchoolList",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt1Word4_WndKidSchoolList",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt1Word5_WndKidSchoolList",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt1Word6_WndKidSchoolList",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txt1Word7_WndKidSchoolList",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.08,0.5))
end
-------------------------------------语言适配end----------------------------------------
