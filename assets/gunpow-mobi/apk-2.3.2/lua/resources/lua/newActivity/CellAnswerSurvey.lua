--CellAnswerSurvey.lua
--@brief	CellAnswerSurvey的UI模块
--@date		2019/12/12
--@author	Tianxiang_Xu
--@note		问题调研-问题


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAnswerSurvey:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAnswerSurvey:onExit(element)
	self:_unInit()
end

--@brief 	点击回调
function CellAnswerSurvey:onClickCheck(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	WZLog("CellAnswerSurvey:onClickCheck", nTag, self.m_tData.choose)
	if self.m_tData.choose == 1 then 
		for i = 1, 8 do 
			if i ~= nTag then 
				GetElement(self.m_root, "imgSel" .. i .. "_CellAnswerSurvey", WZUI9Image):setVisible(false)
			end
		end
		GetElement(self.m_root, "imgSel" .. nTag .. "_CellAnswerSurvey", WZUI9Image):setVisible(true)

		WndAnswerSurvey:answerCallback(self.m_tData, nTag, true)
	else
		local imgSel = GetElement(self.m_root, "imgSel" .. nTag .. "_CellAnswerSurvey", WZUI9Image)
		imgSel:setVisible(not imgSel:isVisible())

		if imgSel:isVisible() then 
			WndAnswerSurvey:answerCallback(self.m_tData, nTag, true)
		elseif not imgSel:isVisible() then 
			WndAnswerSurvey:answerCallback(self.m_tData, nTag, false)
		end
	end
end

--@brief 加载
function CellAnswerSurvey:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellAnswerSurvey")
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()
	AdaptLanguage(self)
end

--@brief 	点击下拉按钮回调
function CellAnswerSurvey:onClickChoose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	GetElement(self.m_root, "imgArrow_CellAnswerSurvey", WZUIImage):setFlipX(true)
	local tData = {}
	tData.type = 11
	tData.answer = self.m_tAnswerList
	tData.tCell = self

	local pt = GlobalMethod:ccp(300,160)
	WndTips:show(element, WndAnswerSurvey.m_root, 75, tData, pt, true)
end

--@brief 	选择列表答案回调
function CellAnswerSurvey:chooseAnswerCallBack(nTag)
	GetElement(self.m_root, "imgArrow_CellAnswerSurvey", WZUIImage):setFlipX(false)
	if nTag then 
		GetElement(self.m_root, "txtAnswerSel_CellAnswerSurvey", WZUILabelTTF):setText(self.m_tAnswerList[nTag])

		WndAnswerSurvey:answerCallback(self.m_tData, nTag, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellAnswerSurvey:_update()
	--body
	local txtQuestion = GetElement(self.m_root, "txtQuestion_CellAnswerSurvey", WZUILabelTTF)
	if txtQuestion then 
		if self.m_tData.choose == 1 then 
			txtQuestion:setText(self.m_tData.turn .. "." .. self.m_tData.question .. LocalStrings.ANSWER_TEXT9)
		else
			txtQuestion:setText(self.m_tData.turn .. "." .. self.m_tData.question .. LocalStrings.ANSWER_TEXT10)
		end
	end
	--
	local answer = SplitStringWithSeparator(self.m_tData.answer, "|")
	local tAnswerIndex = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J"}
	self.m_tAnswerList = answer
	if self.m_tData.choose == 1 and #answer > 8 then 
		GetElement(self.m_root, "btnChoose_CellAnswerSurvey", WZUIButton):setVisible(true)
		GetElement(self.m_root, "txtAnswerSel_CellAnswerSurvey", WZUILabelTTF):setText(LocalStrings.ALCHEMY_TEXT1[24])
	else
		GetElement(self.m_root, "conCheckGroup_CellAnswerSurvey", WZUIContainer):setVisible(true)
		for i = 1, #answer do
			if answer[i] ~= "" and i < 9 then 
				GetElement(self.m_root, "checkBox" .. i .. "_CellAnswerSurvey", WZUIButton):setVisible(true)
				GetElement(self.m_root, "txtAnswer" .. i .. "_CellAnswerSurvey", WZUILabelTTF):setText(tAnswerIndex[i] .. " " .. answer[i])
			end
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function CellAnswerSurvey:_adaptLanguage_vn()
	for i = 1, 8 do
		local txtAnswer = GetElement(self.m_root, "txtAnswer" .. i .. "_CellAnswerSurvey", WZUILabelTTF)
		txtAnswer:setScale(0.65)
		txtAnswer:setDimensions(GlobalMethod:CCSize(220))
	end
end

-------------------------------------语言适配end----------------------------------------
