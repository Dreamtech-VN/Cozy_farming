--CellSevenDayTask.lua
--@brief	CellSevenDayTask的UI模块
--@date		2017/12/19
--@author	Tianxiang_Xu
--@note		七天乐活动-任务奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSevenDayTask:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSevenDayTask:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellSevenDayTask:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellSevenDayTask")
	self.m_root:addChild(celElement)
	self.m_bIsLoaded = true

	self:_update()
end

--@brief 	点击物品回调
function CellSevenDayTask:onCLickItem(tCell, tag, tData)
	-- body
	WndItemInfo:showInfo(tCell.m_root, WndSevenDayActivity.m_root, 1, tData, false)
end

--@brief 	点击领取奖励按钮回调
function CellSevenDayTask:onClickGetReward(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tData.state == 1 then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetOpenServerReward(self.m_tData.id)
	else
		if self.m_tData.script[1][1] ~= 0 then
			local bJump
			if self.m_tData.script[1][2] == 2 then
				bJump = JumpByUIId(self.m_tData.script[1][1], self.m_tData.script[1][2], nil, 2)
			else
				bJump = JumpByUIId(self.m_tData.script[1][1], self.m_tData.script[1][2])
			end
			if bJump then 
				if WndSevenDayActivity.m_root then 
					WindowManager:removeWindow(WndSevenDayActivity.m_root , WndSevenDayActivity , true)
				end
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellSevenDayTask:_update()
	-- body
	local tData = self.m_tData

	--奖励
	for i = 1, #tData.reward do
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_CellSevenDayTask", WZUIContainer)
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(tData.reward[i][1], tData.reward[i][2], 4)
			tNewObj:setItemClickFun(self, self.onCLickItem)
			conItem:addChild(element)
		end
	end

	--描述
	local  strFormat = [[<T C="127,70,26" S="18" P="0">%s</T><T C="229,105,22" S="18" P="0">%s</T>]]
	local ftbDesc = GetElement(self.m_root, "ftbDesc_CellSevenDayTask", WZUIFreeTextBox)
	if ftbDesc then
		local nCurComplete = tData.complete
		if nCurComplete > tData.target then 
			nCurComplete = tData.target
		end
		ftbDesc:setShowText(string.format(strFormat, tData.desc, "("..nCurComplete.."/"..tData.target..")"))
	end

	--状态
	local btnGetReward = GetElement(self.m_root, "btnGetReward_CellSevenDayTask", WZUIButton)
	local imgState = GetElement(self.m_root, "imgState_CellSevenDayTask", WZUIImage)
	local txtButton = GetElement(self.m_root, "txtButton_CellSevenDayTask", WZUILabelTTF)
	local imgBtn1 = GetElement(self.m_root, "imgBtn1_CellSevenDayTask", WZUI9Image)
	local imgBtn2 = GetElement(self.m_root, "imgBtn2_CellSevenDayTask", WZUI9Image)
	local imgBtn3 = GetElement(self.m_root, "imgBtn3_CellSevenDayTask", WZUI9Image)
	if tData.state == 1 then 
		txtButton:setText(LocalStrings.GET_REWARD)
		btnGetReward:setVisible(true)
		imgState:setVisible(false)
		if ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "es" then
			txtButton:setScale(0.7)
			txtButton:setDimensions(GlobalMethod:CCSize(110))
		end
	elseif tData.state == 0 then 
		if tData.script[1][1] ~= 0 then
			btnGetReward:setVisible(true)
			imgBtn1:setFile("ui/common/common_btn_05.png")
			imgBtn2:setFile("ui/common/common_btn_05.png")
			imgBtn3:setFile("ui/common/common_btn_05.png")
			txtButton:setText(LocalStrings.ACTIVE_BTN_GO)
			txtButton:setColor(GlobalMethod:ccc3(255,236,193))
			txtButton:setStrokeColor(GlobalMethod:ccc3(163,74,20))
			imgState:setVisible(false)
		else
			btnGetReward:setVisible(false)
			imgState:setVisible(true)
			imgState:setFile("ui/common/commom_icon_wdc.png")
		end
	elseif tData.state == 2 then 
		btnGetReward:setVisible(false)
		imgState:setVisible(true)
		imgState:setFile("ui/common/commom_icon_ylq.png")
	end
end




-------------------------------------私有方法模块End----------------------------------------
