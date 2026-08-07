--WndKidSchoolKidInfo.lua
--@brief	WndKidSchoolKidInfo的UI模块
--@date		2021/05/27
--@author	yrd
--@note		孩子学校-孩子信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidSchoolKidInfo:onEnter(element)
	self.m_root = element
	ProtocolProcessorKidSchool:send_SCHOOL_GetChildInfo(self.m_tData.id)
	self:_updateStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidSchoolKidInfo:onExit(element)
	self:_unInit()
end

--@brief    点击关闭按钮回调
function WndKidSchoolKidInfo:onClickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    界面加载完成回调
function WndKidSchoolKidInfo:onEnterTransitionDidFinish(element)
	
end

--@brief    更新静态文本
function WndKidSchoolKidInfo:_updateStaticText()
	GetElement(self.m_root,"txtKidWord1_WndKidSchoolKidInfo",WZUILabelTTF):setText(LocalStrings.KID_TEXT183..":")
	GetElement(self.m_root,"txtKidWord2_WndKidSchoolKidInfo",WZUILabelTTF):setText(LocalStrings.KID_TEXT184..":")
	GetElement(self.m_root,"txtKidWord3_WndKidSchoolKidInfo",WZUILabelTTF):setText(LocalStrings.KID_TEXT185..":")
end

--@brief    更新界面
function WndKidSchoolKidInfo:updateUI()
	--小孩形象
    local tEquip = {}
    table.insert(tEquip,self.m_tData.headId)
    table.insert(tEquip,self.m_tData.faceId)
    table.insert(tEquip,self.m_tData.bodyId)
    local conKid = CreatePlayerBabyFigure(self.m_tData.sex, tEquip, "wait")
    local animNode = conKid:getAnimNode()
	local conKidRole = GetElement(self.m_root,"conKidRole_WndKidSchoolKidInfo",WZUIContainer)
    conKidRole:addChild(conKid:getAnimNode())
	--小孩名字
	local txtTitle = GetElement(self.m_root,"txtTitle_WndKidSchoolKidInfo",WZUILabelTTF)
	txtTitle:setText(self.m_tData.name)
	--小孩状态
	local strAreaStatus1 = {[0]=LocalStrings.KID_TEXT192,LocalStrings.KID_TEXT193,LocalStrings.KID_TEXT194,LocalStrings.KID_TEXT195,LocalStrings.KID_TEXT196}
	local txtKidStatus = GetElement(self.m_root,"txtKidStatus_WndKidSchoolKidInfo",WZUILabelTTF)
	txtKidStatus:setText(strAreaStatus1[self.m_tData.area])
	local strAreaStatus2 = {[0]=LocalStrings.KID_TEXT197,LocalStrings.KID_TEXT198,LocalStrings.KID_TEXT199,LocalStrings.KID_TEXT200,LocalStrings.KID_TEXT201}
	local txtKidArea1 = GetElement(self.m_root,"txtKidArea1_WndKidSchoolKidInfo",WZUILabelTTF)
	txtKidArea1:setText(strAreaStatus2[self.m_tData.area])
	if self.m_tData.areaTime ~= 0 then
		local nTime = SystemTime:getServerTime() - self.m_tData.areaTime
		local txtKidArea2 = GetElement(self.m_root,"txtKidArea2_WndKidSchoolKidInfo",WZUILabelTTF)
		txtKidArea2:setText(returnToTimeFormat(nTime))
		txtKidArea2:enableSchedule("_updateTimeSchedule",1)
	end
	--小孩属性-智慧
	local txtKidValue1 = GetElement(self.m_root,"txtKidValue1_WndKidSchoolKidInfo",WZUILabelTTF)
	txtKidValue1:setText(LocalStrings.LV..self.m_tChildInfo.learnLevel)
	local progKidExp1 = GetElement(self.m_root,"progKidExp1_WndKidSchoolKidInfo",WZUIProgress)
	local nProgValue1 = math.floor(self.m_tChildInfo.learnExp/self.m_tChildInfo.learnMaxExp*100)
	progKidExp1:setPercentage(nProgValue1)
	local txtprogKidExp1 = GetElement(self.m_root,"txtprogKidExp1_WndKidSchoolKidInfo",WZUILabelTTF)
	txtprogKidExp1:setText(self.m_tChildInfo.learnExp.."/"..self.m_tChildInfo.learnMaxExp)
	--小孩属性-精神
	local txtKidValue2 = GetElement(self.m_root,"txtKidValue2_WndKidSchoolKidInfo",WZUILabelTTF)
	txtKidValue2:setText(LocalStrings.LV..self.m_tChildInfo.restLevel)
	local progKidExp2 = GetElement(self.m_root,"progKidExp2_WndKidSchoolKidInfo",WZUIProgress)
	local nProgValue2 = math.floor(self.m_tChildInfo.restExp/self.m_tChildInfo.restMaxExp*100)
	progKidExp2:setPercentage(nProgValue2)
	local txtprogKidExp2 = GetElement(self.m_root,"txtprogKidExp2_WndKidSchoolKidInfo",WZUILabelTTF)
	txtprogKidExp2:setText(self.m_tChildInfo.restExp.."/"..self.m_tChildInfo.restMaxExp)
	--小孩属性-体能
	local txtKidValue3 = GetElement(self.m_root,"txtKidValue3_WndKidSchoolKidInfo",WZUILabelTTF)
	txtKidValue3:setText(LocalStrings.LV..self.m_tChildInfo.appreciateLevel)
	local progKidExp3 = GetElement(self.m_root,"progKidExp3_WndKidSchoolKidInfo",WZUIProgress)
	local nProgValue3 = math.floor(self.m_tChildInfo.appreciateExp/self.m_tChildInfo.appreciateMaxExp*100)
	progKidExp3:setPercentage(nProgValue3)
	local txtprogKidExp3 = GetElement(self.m_root,"txtprogKidExp3_WndKidSchoolKidInfo",WZUILabelTTF)
	txtprogKidExp3:setText(self.m_tChildInfo.appreciateExp.."/"..self.m_tChildInfo.appreciateMaxExp)
	--属性
	local txtKidValue4 = GetElement(self.m_root,"txtKidValue4_WndKidSchoolKidInfo",WZUILabelTTF)
	txtKidValue4:setText(self.m_tChildInfo.attack.."/"..self.m_tChildInfo.maxAttack)
	local txtKidValue5 = GetElement(self.m_root,"txtKidValue5_WndKidSchoolKidInfo",WZUILabelTTF)
	txtKidValue5:setText(self.m_tChildInfo.hp.."/"..self.m_tChildInfo.maxHp)
	local txtKidValue6 = GetElement(self.m_root,"txtKidValue6_WndKidSchoolKidInfo",WZUILabelTTF)
	txtKidValue6:setText(self.m_tChildInfo.def.."/"..self.m_tChildInfo.maxDef)

	--按钮
	if SceneKidSchoolHome:isMyChild(self.m_tData.id) == true and #SceneKidSchoolHome:getMyChildId() > 1 then
		local btnSwitchKid = GetElement(self.m_root,"btnSwitchKid_WndKidSchoolKidInfo",WZUIButton)
		btnSwitchKid:setVisible(true)
	end
	--剩余操作时长
	local txtLeftTime1 = GetElement(self.m_root,"txtLeftTime1_WndKidSchoolKidInfo",WZUILabelTTF)
	txtLeftTime1:setText(returnToTimeFormat(self.m_tChildInfo.learnRemainTime))
	if self.m_tData.area == 1 or self.m_tData.area == 2 or self.m_tData.area == 3 then
		txtLeftTime1:enableSchedule("_leftTimeSchedule1",1)
	end
	local txtLeftTime2 = GetElement(self.m_root,"txtLeftTime2_WndKidSchoolKidInfo",WZUILabelTTF)
	txtLeftTime2:setText(returnToTimeFormat(self.m_tChildInfo.scienceRemainTime))
	if self.m_tData.area == 4 then
		txtLeftTime2:enableSchedule("_leftTimeSchedule2",1)
	end
	

end

--@brief    点击切换孩子按钮
function WndKidSchoolKidInfo:onClickSwitchKid(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	MsgBoxManager:showConfirmBox(LocalStrings.KID_TEXT209, self, self.sureSwitchKid)
end

--@brief    确认解散学校操作
function WndKidSchoolKidInfo:sureSwitchKid(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
	    ProtocolProcessorKidSchool:send_SCHOOL_ChangeChild()
	    self:onClickClose()
	end
end

--@brief    点击"叹号"按钮
function WndKidSchoolKidInfo:onClickRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.KID_TEXT243)
end

--@brief    计时器
function WndKidSchoolKidInfo:_updateTimeSchedule(element)
	local txtKidArea2 = GetElement(self.m_root,"txtKidArea2_WndKidSchoolKidInfo",WZUILabelTTF)
	if self.m_tData.areaTime ~= 0 then
		local nTime = SystemTime:getServerTime() - self.m_tData.areaTime
		txtKidArea2:setText(returnToTimeFormat(nTime))
	else
		txtKidArea2:setText("")
		txtKidArea2:disableSchedule()
	end
end

--@brief    成长区剩余时间计时器
function WndKidSchoolKidInfo:_leftTimeSchedule1(element)
	local txtLeftTime1 = GetElement(self.m_root,"txtLeftTime1_WndKidSchoolKidInfo",WZUILabelTTF)
	self.m_tChildInfo.learnRemainTime = self.m_tChildInfo.learnRemainTime - 1
	if self.m_tChildInfo.learnRemainTime <= 0 then
		self.m_tChildInfo.learnRemainTime = 0
		txtLeftTime1:disableSchedule()
	end
	txtLeftTime1:setText(returnToTimeFormat(self.m_tChildInfo.learnRemainTime))
end

--@brief    科学区剩余时间计时器
function WndKidSchoolKidInfo:_leftTimeSchedule2(element)
	local txtLeftTime2 = GetElement(self.m_root,"txtLeftTime2_WndKidSchoolKidInfo",WZUILabelTTF)
	self.m_tChildInfo.scienceRemainTime = self.m_tChildInfo.scienceRemainTime - 1
	if self.m_tChildInfo.scienceRemainTime <= 0 then
		self.m_tChildInfo.scienceRemainTime = 0
		txtLeftTime2:disableSchedule()
	end
	txtLeftTime2:setText(returnToTimeFormat(self.m_tChildInfo.scienceRemainTime))
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin---------------------------------------------

function WndKidSchoolKidInfo:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtKidWord1_WndKidSchoolKidInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtKidWord2_WndKidSchoolKidInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtKidWord3_WndKidSchoolKidInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtKidWord4_WndKidSchoolKidInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtKidWord5_WndKidSchoolKidInfo",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtKidWord6_WndKidSchoolKidInfo",WZUILabelTTF):setScale(0.8)
end

-------------------------------------语言适配End---------------------------------------------------
