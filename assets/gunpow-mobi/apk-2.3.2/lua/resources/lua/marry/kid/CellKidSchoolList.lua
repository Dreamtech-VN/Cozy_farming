--CellKidSchoolList.lua
--@brief	CellKidSchoolList的UI模块
--@date		2021/04/21
--@author	yrd
--@note		孩子学校列表子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellKidSchoolList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellKidSchoolList:onExit(element)
	self:_unInit()
end

--@brief	onEnter函数执行完成回调
function CellKidSchoolList:onEnterTransitionDidFinish(element)
	self:updateUI()
end

--@brief	更新界面
function CellKidSchoolList:updateUI()
	local txt1ID = GetElement(self.m_root,"txt1ID_CellKidSchoolList",WZUILabelTTF)
	local ftb1Name = GetElement(self.m_root,"ftb1Name_CellKidSchoolList",WZUIFreeTextBox)
	local txt1Efficiency = GetElement(self.m_root,"txt1Efficiency_CellKidSchoolList",WZUILabelTTF)
	local txt1Num = GetElement(self.m_root,"txt1Num_CellKidSchoolList",WZUILabelTTF)
	local btn1Apply = GetElement(self.m_root,"btn1Apply_CellKidSchoolList",WZUIButton)

	local con2Head = GetElement(self.m_root,"con2Head_CellKidSchoolList",WZUIContainer)
	local txt2CName = GetElement(self.m_root,"txt2CName_CellKidSchoolList",WZUILabelTTF)
	local ftb2Name1 = GetElement(self.m_root,"ftb2Name1_CellKidSchoolList",WZUIFreeTextBox)
	local ftb2Name2 = GetElement(self.m_root,"ftb2Name2_CellKidSchoolList",WZUIFreeTextBox)
	local txt2Donate = GetElement(self.m_root,"txt2Donate_CellKidSchoolList",WZUILabelTTF)
	local img2Donate = GetElement(self.m_root,"img2Donate_CellKidSchoolList",WZUIImage)
	local txt2OnLine = GetElement(self.m_root,"txt2OnLine_CellKidSchoolList",WZUILabelTTF)
	local btn2Fire = GetElement(self.m_root,"btn2Fire_CellKidSchoolList",WZUIButton)


	local conType1 = GetElement(self.m_root,"conType1_CellKidSchoolList",WZUIContainer)
	local conType2 = GetElement(self.m_root,"conType2_CellKidSchoolList",WZUIContainer)
	conType1:setVisible(false)
	conType2:setVisible(false)
	if self.m_nType == 1 then
		conType1:setVisible(true)

		--学校id
		txt1ID:setText(self.m_tData.schoolId)
		txt1ID:setRelativePosition(GlobalMethod:ccp(0.115,0.5))
		--学校名
		local strFormat = [[<T C="229,105,22" S="20" P="0">Lv%s </T><T C="127,70,26" S="20" P="1"> %s</T>]]
		ftb1Name:setShowText(string.format(strFormat,self.m_tData.schoolLevel,self.m_tData.schoolName))
		ftb1Name:setRelativePosition(GlobalMethod:ccp(0.357,0.5))
		--学习效率
		txt1Efficiency:setText(self.m_tData.schoolEffectId)
		txt1Efficiency:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
		--人数
		txt1Num:setText(self.m_tData.schoolNum.."/"..self.m_tData.schoolMaxNum)
		txt1Num:setRelativePosition(GlobalMethod:ccp(0.888,0.5))
		--申请按钮
		btn1Apply:setVisible(false)

	elseif self.m_nType == 2 then
		conType1:setVisible(true)

		--学校id
		txt1ID:setText(self.m_tData.schoolId)
		txt1ID:setRelativePosition(GlobalMethod:ccp(0.07,0.5))
		--学校名
		local strFormat = [[<T C="229,105,22" S="20" P="0">Lv%s </T><T C="127,70,26" S="20" P="1"> %s</T>]]
		ftb1Name:setShowText(string.format(strFormat,self.m_tData.schoolLevel,self.m_tData.schoolName))
		ftb1Name:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
		--学习效率
		txt1Efficiency:setText(self.m_tData.schoolEffectId)
		txt1Efficiency:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		--人数
		txt1Num:setText(self.m_tData.schoolNum.."/"..self.m_tData.schoolMaxNum)
		txt1Num:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
		--申请按钮
		btn1Apply:setVisible(true)


	elseif self.m_nType == 3 then
		conType2:setVisible(true)

		--背景
		local imgBg = GetElement(self.m_root,"imgBg_CellKidSchoolList",WZUI9Image)
		if SceneKidSchoolHome:isMyChild(self.m_tData.id) then
			imgBg:setFile("ui/common/frame_lieb_01.png")
		end

		--孩子头像
		local imgHead = CellHead:show(con2Head, self.m_tData.cheadId, self.m_tData.cfaceId, self.m_tData.csex, nil, nil, nil, nil, nil, nil, nil, true, self.m_tData.headEffectId)
		con2Head:setRelativePosition(GlobalMethod:ccp(0.07,0.5))
		txt2CName:setText(self.m_tData.cname)
		--父母
		local strParent = {[0]=LocalStrings.KID_TEXT119,LocalStrings.KID_TEXT120}
		local strFormat = [[<T C="229,105,22" S="20" P="0">%s: </T><T C="127,70,26" S="20" P="1">%s</T>]]
		if #self.m_tData.parents == 1 then
			ftb2Name1:setShowText(string.format(strFormat, strParent[self.m_tData.parents[1].sex], self.m_tData.parents[1].name))
			ftb2Name1:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
		elseif #self.m_tData.parents == 2 then
			ftb2Name1:setShowText(string.format(strFormat, strParent[self.m_tData.parents[1].sex], self.m_tData.parents[1].name))
			ftb2Name2:setShowText(string.format(strFormat, strParent[self.m_tData.parents[2].sex], self.m_tData.parents[2].name))
			ftb2Name1:setRelativePosition(GlobalMethod:ccp(0.27,0.72))
			ftb2Name2:setRelativePosition(GlobalMethod:ccp(0.27,0.28))
		end
		--捐赠
		txt2Donate:setText("")
		img2Donate:setFile("")
		if self.m_tData.donateTime == 0 then
			txt2Donate:setText(LocalStrings.KID_TEXT176)
		elseif self.m_tData.donateTime == 1 then
			img2Donate:setFile("ui/common/common_hzxx_jz.png")
		elseif self.m_tData.donateTime == 2 then
			img2Donate:setFile("ui/common/common_hzxx_cjjz.png")
		end
		txt2Donate:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		img2Donate:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		--在线
		if self.m_tData.status == 0 then
			local leftTime = 0
			local nTime = SystemTime:getServerTime() - self.m_tData.loginTime
			if self.m_tData.loginTime ~= 0 and nTime > 0 then
				local strTime,color = self:getTimeFormat(nTime)
				txt2OnLine:setText(strTime)
				txt2OnLine:setColor(color)
			end
		elseif self.m_tData.status == 1 then
			txt2OnLine:setText(LocalStrings.REWARD_BTN_ONLINE)
			txt2OnLine:setColor(GlobalMethod:ccc3(127,70,26))
		end
		txt2OnLine:setRelativePosition(GlobalMethod:ccp(0.7,0.5))
		--开除按钮
		btn2Fire:setVisible(true)
		if SceneKidSchoolHome:isMyChild(self.m_tData.id) then
			btn2Fire:setTouchEnable(false)
		end
	elseif self.m_nType == 4 then
		conType2:setVisible(true)

		--背景
		local imgBg = GetElement(self.m_root,"imgBg_CellKidSchoolList",WZUI9Image)
		if SceneKidSchoolHome:isMyChild(self.m_tData.id) then
			imgBg:setFile("ui/common/frame_lieb_01.png")
		end

		--孩子头像
		local imgHead = CellHead:show(con2Head, self.m_tData.cheadId, self.m_tData.cfaceId, self.m_tData.csex, nil, nil, nil, nil, nil, nil, nil, true, self.m_tData.headEffectId)
		con2Head:setRelativePosition(GlobalMethod:ccp(0.07,0.5))
		txt2CName:setText(self.m_tData.cname)
		--父母
		local strParent = {[0]=LocalStrings.KID_TEXT119,LocalStrings.KID_TEXT120}
		local strFormat = [[<T C="229,105,22" S="20" P="0">%s: </T><T C="127,70,26" S="20" P="1">%s</T>]]
		if #self.m_tData.parents == 1 then
			ftb2Name1:setShowText(string.format(strFormat, strParent[self.m_tData.parents[1].sex], self.m_tData.parents[1].name))
			ftb2Name1:setRelativePosition(GlobalMethod:ccp(0.27,0.5))
		elseif #self.m_tData.parents == 2 then
			ftb2Name1:setShowText(string.format(strFormat, strParent[self.m_tData.parents[1].sex], self.m_tData.parents[1].name))
			ftb2Name2:setShowText(string.format(strFormat, strParent[self.m_tData.parents[2].sex], self.m_tData.parents[2].name))
			ftb2Name1:setRelativePosition(GlobalMethod:ccp(0.27,0.72))
			ftb2Name2:setRelativePosition(GlobalMethod:ccp(0.27,0.28))
		end
		--捐赠
		txt2Donate:setText("")
		img2Donate:setFile("")
		if self.m_tData.donateTime == 0 then
			txt2Donate:setText(LocalStrings.KID_TEXT176)
		elseif self.m_tData.donateTime == 1 then
			img2Donate:setFile("ui/common/common_hzxx_jz.png")
		elseif self.m_tData.donateTime == 2 then
			img2Donate:setFile("ui/common/common_hzxx_cjjz.png")
		end
		txt2Donate:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
		img2Donate:setRelativePosition(GlobalMethod:ccp(0.66,0.5))
		--在线
		if self.m_tData.status == 0 then
			local leftTime = 0
			local nTime = SystemTime:getServerTime() - self.m_tData.loginTime
			if self.m_tData.loginTime ~= 0 and nTime > 0 then
				local strTime,color = self:getTimeFormat(nTime)
				txt2OnLine:setText(strTime)
				txt2OnLine:setColor(color)
			end
		elseif self.m_tData.status == 1 then
			txt2OnLine:setText(LocalStrings.REWARD_BTN_ONLINE)
			txt2OnLine:setColor(GlobalMethod:ccc3(127,70,26))
		end
		txt2OnLine:setRelativePosition(GlobalMethod:ccp(0.888,0.5))
		--开除按钮
		btn2Fire:setVisible(false)

	end

end

--@brief    获得剩余时间文本格式 : "在线","刚刚","x分钟前","x小时前","x天前"
--@param	nTime:剩余时间
function CellKidSchoolList:getTimeFormat(nTime)
	local strTime = ""
	local color = GlobalMethod:ccc3(127,70,26)
	if nTime < 0 then --在线
		strTime = LocalStrings.REWARD_BTN_ONLINE
		color = GlobalMethod:ccc3(127,70,26)
	elseif nTime >= 0 and nTime < 60 then --刚刚
		strTime = LocalStrings.DIGGEM_TEXT55[1]
		color = GlobalMethod:ccc3(138,122,106)
	elseif nTime < 3600 then --分钟前
		strTime = string.format(LocalStrings.DIGGEM_TEXT55[2],math.floor(nTime/60))
		color = GlobalMethod:ccc3(138,122,106)
	elseif nTime < 86400 then --小时前
		strTime = string.format(LocalStrings.DIGGEM_TEXT55[3],math.floor(nTime/3600))
		color = GlobalMethod:ccc3(138,122,106)
	else --天前
		strTime = string.format(LocalStrings.DIGGEM_TEXT55[4],math.floor(nTime/86400))
		color = GlobalMethod:ccc3(138,122,106)
	end
	return strTime,color
end

--@brief    点击头像按钮回调
function CellKidSchoolList:onClickHead2(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.parents[1].pid)
end

--@brief    点击列表项
function CellKidSchoolList:onClickCell(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nType == 1 then
        ProtocolProcessorKidSchool:send_SCHOOL_GetSchoolInfo(self.m_tData.schoolId)
    end
end

--@brief    开除按钮回调
function CellKidSchoolList:onClickFire(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    MsgBoxManager:showConfirmBox(LocalStrings.KID_TEXT188, self, self.sureFire)
end

--@brief	确认开除
function CellKidSchoolList:sureFire(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		local childIds = WZLuaVector_int_:create()
		childIds:push(self.m_tData.id)
		ProtocolProcessorKidSchool:send_SCHOOL_ClearChild(childIds)
	end
end

--@brief    申请按钮回调
function CellKidSchoolList:onClickApply(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorKidSchool:send_SCHOOL_ApplySchool(self.m_tData.schoolId, "")
	element:setTouchEnable(false)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
