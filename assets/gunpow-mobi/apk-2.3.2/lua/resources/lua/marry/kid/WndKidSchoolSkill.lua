--WndKidSchoolSkill.lua
--@brief	WndKidSchoolSkill的UI模块
--@date		2021/05/27
--@author	yrd
--@note		孩子学校-技能


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidSchoolSkill:onEnter(element)
	self.m_root = element
	ProtocolProcessorKidSchool:send_SCHOOL_GetChildSkillInfo()
	self:_updateStaticText()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidSchoolSkill:onExit(element)
	self:_unInit()
end

--@brief    点击关闭按钮回调
function WndKidSchoolSkill:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WndKidSchoolOperate.m_bIsClickFunc = false
    WindowManager:removeWindow(self.m_root, self, true)
end


--@brief    更新静态文本
function WndKidSchoolSkill:_updateStaticText()
	GetElement(self.m_root,"txtKidWord1_WndKidSchoolSkill",WZUILabelTTF):setText(LocalStrings.KID_TEXT183..":")
	GetElement(self.m_root,"txtKidWord2_WndKidSchoolSkill",WZUILabelTTF):setText(LocalStrings.KID_TEXT184..":")
	GetElement(self.m_root,"txtKidWord3_WndKidSchoolSkill",WZUILabelTTF):setText(LocalStrings.KID_TEXT185..":")
end

--@brief    更新界面
function WndKidSchoolSkill:updateUI()
	self:showKidInfo()
	self:showSkillList()
	self:showSkillDetails()
end

--@brief    显示小孩信息
function WndKidSchoolSkill:showKidInfo()
	--小孩属性-智慧
	local txtKidValue1 = GetElement(self.m_root,"txtKidValue1_WndKidSchoolSkill",WZUILabelTTF)
	txtKidValue1:setText(LocalStrings.LV..self.m_tChildInfo.learnLevel)
	local progKidExp1 = GetElement(self.m_root,"progKidExp1_WndKidSchoolSkill",WZUIProgress)
	local nProgValue1 = math.floor(self.m_tChildInfo.learnExp/self.m_tChildInfo.learnMaxExp*100)
	progKidExp1:setPercentage(nProgValue1)
	local txtprogKidExp1 = GetElement(self.m_root,"txtprogKidExp1_WndKidSchoolSkill",WZUILabelTTF)
	txtprogKidExp1:setText(self.m_tChildInfo.learnExp.."/"..self.m_tChildInfo.learnMaxExp)
	--小孩属性-精神
	local txtKidValue2 = GetElement(self.m_root,"txtKidValue2_WndKidSchoolSkill",WZUILabelTTF)
	txtKidValue2:setText(LocalStrings.LV..self.m_tChildInfo.restLevel)
	local progKidExp2 = GetElement(self.m_root,"progKidExp2_WndKidSchoolSkill",WZUIProgress)
	local nProgValue2 = math.floor(self.m_tChildInfo.restExp/self.m_tChildInfo.restMaxExp*100)
	progKidExp2:setPercentage(nProgValue2)
	local txtprogKidExp2 = GetElement(self.m_root,"txtprogKidExp2_WndKidSchoolSkill",WZUILabelTTF)
	txtprogKidExp2:setText(self.m_tChildInfo.restExp.."/"..self.m_tChildInfo.restMaxExp)
	--小孩属性-体能
	local txtKidValue3 = GetElement(self.m_root,"txtKidValue3_WndKidSchoolSkill",WZUILabelTTF)
	txtKidValue3:setText(LocalStrings.LV..self.m_tChildInfo.appreciateLevel)
	local progKidExp3 = GetElement(self.m_root,"progKidExp3_WndKidSchoolSkill",WZUIProgress)
	local nProgValue3 = math.floor(self.m_tChildInfo.appreciateExp/self.m_tChildInfo.appreciateMaxExp*100)
	progKidExp3:setPercentage(nProgValue3)
	local txtprogKidExp3 = GetElement(self.m_root,"txtprogKidExp3_WndKidSchoolSkill",WZUILabelTTF)
	txtprogKidExp3:setText(self.m_tChildInfo.appreciateExp.."/"..self.m_tChildInfo.appreciateMaxExp)
end

--@brief    显示技能列表
function WndKidSchoolSkill:showSkillList()
	--技能列表
	self.m_tCellSkill = {}
	local tcSkills = GetElement(self.m_root,"tcSkills_WndKidSchoolSkill",WZUITableContainer)
	tcSkills:cleanTable()
	for i=1,#self.m_tSkillInfo do
		local conSkillInfo = WZUISystem:getInstance():createElement("conSkillInfo_WndKidSchoolSkill")
		conSkillInfo = WZUIContainer:luaTo(conSkillInfo)
		conSkillInfo:setTag(i-1)
		conSkillInfo:setVisible(true)
		tcSkills:setCellElement(conSkillInfo)
		self.m_tCellSkill[i] = conSkillInfo

		local skillInfo = GDatatab_skill["id_" .. self.m_tSkillInfo[i].id]

		GetElement(conSkillInfo,"gridId",WZUILabelTTF):setText(skillInfo.id)
		local imgSkillBg = GetElement(conSkillInfo,"imgSkillBg_WndKidSchoolSkill",WZUIImage)
		imgSkillBg:setFile("ui/common/common_zd_dk_ww.png")
		local imgSkill = GetElement(conSkillInfo,"imgSkill_WndKidSchoolSkill",WZUIImage)
		imgSkill:setFile(skillInfo.icon)
        local imgSkillLevel = GetElement(conSkillInfo,"imgSkillLevel_WndKidSchoolSkill",WZUIImage)
		if skillInfo.lv_icon ~= nil and type(skillInfo.lv_icon) == "string" then
			imgSkillLevel:setFile(skillInfo.lv_icon)
		end
		local imgSkillStats = GetElement(conSkillInfo,"imgSkillStats_WndKidSchoolSkill",WZUIImage)
		imgSkillStats:setVisible(false)
		if self.m_tSkillInfo[i].isUse then
			imgSkillStats:setVisible(true)
		end

		local txtSkillNum = GetElement(conSkillInfo,"txtSkillNum_WndKidSchoolSkill",WZUILabelTTF)
		txtSkillNum:setText(self.m_tSkillInfo[i].num.."/"..skillInfo.param3)
	end
end

--@brief    显示技能详情
function WndKidSchoolSkill:showSkillDetails()

	local skillInfo1 = GDatatab_skill["id_" .. self.m_tSkillInfo[self.m_nCurShowSkillId].id]
	local skillInfo2 = GDatatab_skill["id_"..skillInfo1.upgrade_id]

	--图标
	local imgSkillPg = GetElement(self.m_root,"imgSkillPg_WndKidSchoolSkill",WZUIImage)
	imgSkillPg:setFile(skillInfo1.icon)
	local imgSkillLv = GetElement(self.m_root,"imgSkillLv_WndKidSchoolSkill",WZUIImage)
	imgSkillLv:setFile(skillInfo1.lv_icon)
	--标题
	local txtSkillTitle1 = GetElement(self.m_root,"txtSkillTitle1_WndKidSchoolSkill",WZUILabelTTF)
	txtSkillTitle1:setText(skillInfo1.name)
	local txtSkillTitle2 = GetElement(self.m_root,"txtSkillTitle2_WndKidSchoolSkill",WZUILabelTTF)
	txtSkillTitle2:setText(LocalStrings.NEWSKILL5)
	--说明
	local txtSkillCurDesc1 = GetElement(self.m_root,"txtSkillCurDesc1_WndKidSchoolSkill",WZUILabelTTF)
	txtSkillCurDesc1:setText(skillInfo1.tool_desc)
	local strValue = LocalStrings.NEWSKILL11
	local tempAlignment = kCCTextAlignmentCenter
	if skillInfo2 then
		strValue = skillInfo2.tool_desc
		tempAlignment = kCCTextAlignmentLeft
	end
	local txtSkillCurDesc2 = GetElement(self.m_root,"txtSkillCurDesc2_WndKidSchoolSkill",WZUILabelTTF)
	txtSkillCurDesc2:setText(strValue)
	txtSkillCurDesc2:setAlignment(tempAlignment)
	--等级
	local txtLeftNum1 = GetElement(self.m_root,"txtLeftNum1_WndKidSchoolSkill",WZUILabelTTF)
	txtLeftNum1:setText(skillInfo1.specialAttackParam)
	--消耗
	local txtLeftNum2 = GetElement(self.m_root,"txtLeftNum2_WndKidSchoolSkill",WZUILabelTTF)
	txtLeftNum2:setText(math.ceil(skillInfo1.consume/1000))
	--冷却
	local strValue1 = ""
	if skillInfo1.cooling_time >= 1000 then
		strValue1 = skillInfo1.cooling_time / 1000
	end
	local txtLeftNum3 = GetElement(self.m_root,"txtLeftNum3_WndKidSchoolSkill",WZUILabelTTF)
	txtLeftNum3:setText(strValue1)
	--初始
	local strValue1 = ""
    if skillInfo1.start_time >= 1000 then
    	strValue1 = skillInfo1.start_time / 1000
    end
	local txtLeftNum4 = GetElement(self.m_root,"txtLeftNum4_WndKidSchoolSkill",WZUILabelTTF)
	txtLeftNum4:setText(strValue1)
	--下一级
	local imgSkillArrow1 = GetElement(self.m_root,"imgSkillArrow1_WndKidSchoolSkill",WZUIImage)
	local imgSkillArrow2 = GetElement(self.m_root,"imgSkillArrow2_WndKidSchoolSkill",WZUIImage)
	local imgSkillArrow3 = GetElement(self.m_root,"imgSkillArrow3_WndKidSchoolSkill",WZUIImage)
	local imgSkillArrow4 = GetElement(self.m_root,"imgSkillArrow4_WndKidSchoolSkill",WZUIImage)
	local conRightSkillPoints1 = GetElement(self.m_root,"conRightSkillPoints1_WndKidSchoolSkill",WZUIContainer)
	local conRightSkillPoints2 = GetElement(self.m_root,"conRightSkillPoints2_WndKidSchoolSkill",WZUIContainer)
	local conRightSkillPoints3 = GetElement(self.m_root,"conRightSkillPoints3_WndKidSchoolSkill",WZUIContainer)
	local conRightSkillPoints4 = GetElement(self.m_root,"conRightSkillPoints4_WndKidSchoolSkill",WZUIContainer)
	imgSkillArrow1:setVisible(false)
	imgSkillArrow2:setVisible(false)
	imgSkillArrow3:setVisible(false)
	imgSkillArrow4:setVisible(false)
	conRightSkillPoints1:setVisible(false)
	conRightSkillPoints2:setVisible(false)
	conRightSkillPoints3:setVisible(false)
	conRightSkillPoints4:setVisible(false)
	if skillInfo2 then
		imgSkillArrow1:setVisible(true)
		imgSkillArrow2:setVisible(true)
		imgSkillArrow3:setVisible(true)
		imgSkillArrow4:setVisible(true)
		conRightSkillPoints1:setVisible(true)
		conRightSkillPoints2:setVisible(true)
		conRightSkillPoints3:setVisible(true)
		conRightSkillPoints4:setVisible(true)
		--等级
		local txtRightNum1 = GetElement(self.m_root,"txtRightNum1_WndKidSchoolSkill",WZUILabelTTF)
		txtRightNum1:setText(skillInfo2.specialAttackParam)
		--消耗
		local txtRightNum2 = GetElement(self.m_root,"txtRightNum2_WndKidSchoolSkill",WZUILabelTTF)
		txtRightNum2:setText(math.ceil(skillInfo2.consume/1000))
		--冷却
		local strValue2 = ""
		if skillInfo2.cooling_time >= 1000 then
			strValue2 = skillInfo2.cooling_time / 1000
		end
		local txtRightNum3 = GetElement(self.m_root,"txtRightNum3_WndKidSchoolSkill",WZUILabelTTF)
		txtRightNum3:setText(strValue2)
		--初始
		local strValue2 = ""
		if skillInfo2.start_time >= 1000 then
			strValue2 = skillInfo2.start_time / 1000
		end
		local txtRightNum4 = GetElement(self.m_root,"txtRightNum4_WndKidSchoolSkill",WZUILabelTTF)
		txtRightNum4:setText(strValue2)
		--升级条件
		if skillInfo1.tj_desc ~= -1 then
			local conSkillDetails3 = GetElement(self.m_root,"conSkillDetails3_WndKidSchoolSkill",WZUIContainer)
			conSkillDetails3:setVisible(true)
			local txtSkillCurDesc3 = GetElement(self.m_root,"txtSkillCurDesc3_WndKidSchoolSkill",WZUILabelTTF)
			txtSkillCurDesc3:setText(skillInfo1.tj_desc)
		end
	end
end

--@brief	点击"技能"
function WndKidSchoolSkill:onClickSkill(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local elementParent = element:getParent():getParent()
    elementParent = WZUIContainer:luaTo(elementParent)
    local tag = elementParent:getTag()

	self.m_nCurShowSkillId = tag + 1
	self:showSkillDetails()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
