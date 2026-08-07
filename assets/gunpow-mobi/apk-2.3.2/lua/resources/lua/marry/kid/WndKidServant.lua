--WndKidServant.lua
--@brief	WndKidServant的UI模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小孩雇佣佣人界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidServant:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidServant:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidServant:onEnterTransitionDidFinish(element)
    -- body
    WZLog("WndKidServant:onEnterTransitionDidFinish", CacheCenter:getGameParam().nannyConfig)
    local tTempConfig = json.decode(CacheCenter:getGameParam().nannyConfig)
    local nannyInfo = string.gsub(tTempConfig.nannyInfo, "'", "\"")
    local tNannyInfo = json.decode(nannyInfo)
    WZLog("WndKidServant:onEnterTransitionDidFinish", Serialize(tNannyInfo))
    self.m_nMaxHour = tTempConfig.maxNannyHour
    local string = string.sub(tTempConfig.hireNannyCost, 2, -2) 
	local id = SplitStringWithSeparator(string, ",")[1]
	local num = SplitStringWithSeparator(string, ",")[2]
    self.m_tCost = {}
    self.m_tCost[1] = tonumber(id)
    self.m_tCost[2] = tonumber(num)

    self.m_tAddTimeCost = tNannyInfo
    self.m_nLeftTime = SceneKidHome.m_nServantTime
    self:_update()
end

--@brief 	点击雇佣按钮回调
function WndKidServant:onClickServant(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	WZLog("WndKidServant:onClickServant", nTag)
	if nTag == 1 then --雇佣处理
		if not JudgeMoneyIsEnough(self.m_tCost[1], self.m_tCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamond) then
			return
		end

		self:sureToUseDiamond()
	elseif nTag == 2 then --加时处理
		if self.m_nLeftTime >= self.m_nMaxHour * 3600 then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT72)
			return 
		end
		local string = string.sub(self.m_tClickData.cost, 2, -2) 
		local id = SplitStringWithSeparator(string, ",")[1]
		local num = SplitStringWithSeparator(string, ",")[2]

		if not JudgeMoneyIsEnough(tonumber(id), tonumber(num), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToAddTime) then
			return
		end

		self:sureToAddTime()
	end
end

--@brief 	确定使用钻石雇佣
function WndKidServant:sureToUseDiamond()
	-- body
	--发送雇佣协议
	SceneKidHome:_createLoading()
	ProtocolProcessorKid:send_WEDDING_HireNanny(1, 0)
end

--@brief 	确定使用钻石雇佣
function WndKidServant:sureToAddTime()
	-- body
	--发送加时协议
	SceneKidHome:_createLoading()
	ProtocolProcessorKid:send_WEDDING_HireNanny(2, self.m_tClickData.id)
end

--@brief 	点击不同时间回调
function WndKidServant:onClickTimeItemCallBack(tCell, tData)
	-- body
	if self.m_tClickCell then
		self.m_tClickCell:setSelState(false)
	end

	self.m_tClickCell = tCell
	self.m_tClickData = tData
	self.m_tClickCell:setSelState(true)
end

--@brief    规则按钮回调
function WndKidServant:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.KID_TEXT108)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndKidServant:_update()
	-- body
	self:_setShowContent()
	self:setStaticText()
	self:createServantAni()
	self:createAddTimeList()
end

--@brief 	设置显示的内容
function WndKidServant:_setShowContent()
	-- body
	local conNoServant = GetElement(self.m_root, "conNoServant_WndKidServant", WZUIContainer)
	local conHaveServant = GetElement(self.m_root, "conHaveServant_WndKidServant", WZUIContainer)
	if SceneKidHome.m_bHavedServant == 1 then
		self:_showTime()
		self.m_root:enableSchedule("_showTime", 1)
		conNoServant:setVisible(false)
		conHaveServant:setVisible(true)
	else
		conNoServant:setVisible(true)
		conHaveServant:setVisible(false)
	end
end

--@brief 	设置文本
function WndKidServant:setStaticText()
	-- body
	local txtTitle1 = GetElement(self.m_root, "txtTitle1_WndKidServant", WZUILabelTTF)
	if txtTitle1 then
		txtTitle1:setText(LocalStrings.KID_TEXT14)
	end

	local txtTitle2 = GetElement(self.m_root, "txtTitle2_WndKidServant", WZUILabelTTF)
	if txtTitle2 then
		txtTitle2:setText(LocalStrings.KID_TEXT14)
	end

	local txtDesc1 = GetElement(self.m_root, "txtDesc1_WndKidServant", WZUILabelTTF)
	if txtDesc1 then
		txtDesc1:setText(LocalStrings.KID_TEXT15)
	end

	local txtDesc2 = GetElement(self.m_root, "txtDesc2_WndKidServant", WZUILabelTTF)
	if txtDesc2 then
		txtDesc2:setText(LocalStrings.KID_TEXT15)
	end

	local txtChooseAtt = GetElement(self.m_root, "txtChooseAtt_WndKidServant", WZUILabelTTF)
	if txtChooseAtt then
		txtChooseAtt:setText(LocalStrings.KID_TEXT17)
	end 

	--雇佣消耗
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndKidServant", WZUIFreeTextBox)
	if ftxtCost then
		local sFormat = [[<T C="255,250,236" S="22" P="1" SC="0,108,3" SS="4" SE="1">%d</T><I Z="0.5">%s</I><T C="255,250,236" S="22" P="1" SC="0,108,3" SS="4" SE="1">%s</T>]]
		local basicData = GDatatab_item["id_" .. self.m_tCost[1]]
		ftxtCost:setShowText(string.format(sFormat, self.m_tCost[2], basicData.icon, LocalStrings.KID_TEXT16))
	end
end

--@brief 	创建佣人形象
function WndKidServant:createServantAni()
	-- body
	local conForAni1 = GetElement(self.m_root, "conForAni1_WndKidServant", WZUIContainer)
	local conForAni2 = GetElement(self.m_root, "conForAni2_WndKidServant", WZUIContainer)

	local petId = 11011
	local animation = nil
	local petAnimation,par = CreatePetAni(conForAni1, petId, animation)
    petAnimation:setScale(1.6)
	if par then par:setScale(1.6) end
    petAnimation:getAnimNode():setTouchEnable(false)

    petAnimation,par = CreatePetAni(conForAni2, petId, animation)
    petAnimation:setScale(1.6)
	if par then par:setScale(1.6) end
    petAnimation:getAnimNode():setTouchEnable(false)
end

--@brief 	创建时长列表
function WndKidServant:createAddTimeList()
	-- body
	for i = 1, #self.m_tAddTimeCost do
		local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndKidServant", WZUIContainer)
		if conItem then
			local element, tNewObj = CellServantTime:createElement()
			if element and tNewObj then
				tNewObj:setData(self.m_tAddTimeCost[i])
				if self.m_tClickCell == nil then
					self.m_tClickCell = tNewObj
					self.m_tClickData = self.m_tAddTimeCost[i]
					self.m_tClickCell:setSelState(true)
				end
				conItem:addChild(element)
			end
		end
	end
end

--@brief 	展示佣人剩余时间
function WndKidServant:_showTime()
	-- body
	if self.m_root == nil then return end 
	
	local ftxtLeftTime = GetElement(self.m_root, "ftxtLeftTime_WndKidServant", WZUIFreeTextBox)
	if ftxtLeftTime then
		self.m_nLeftTime = self.m_nLeftTime - 1
		if self.m_nLeftTime > 0 then
			local hours = math.floor(self.m_nLeftTime/3600)
	    	local minutes = math.floor((self.m_nLeftTime%3600)/60)
	    	local seconds = self.m_nLeftTime%60
	    	local sFormat = [[<T C="99,255,95" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s:%d:%02d:%02d</T>]]
	    	ftxtLeftTime:setShowText(string.format(sFormat, LocalStrings.KID_TEXT18, hours, minutes, seconds))
	    else
	    	self.m_root:disableSchedule()
	    	local sFormat = [[<T C="99,255,95" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s</T>]]
	    	ftxtLeftTime:setShowText(string.format(sFormat, LocalStrings.KID_TEXT19))
	    end
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function WndKidServant:_adaptLanguage_th(  )	
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndKidServant", WZUIFreeTextBox)
	ftxtCost:setMaxWidth(200)
	ftxtCost:setScale(0.8)
end

function WndKidServant:_adaptLanguage_tr(  )	
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndKidServant", WZUIFreeTextBox)
	ftxtCost:setMaxWidth(200)
	ftxtCost:setScale(0.8)
end

function WndKidServant:_adaptLanguage_en(  )	
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndKidServant", WZUIFreeTextBox)
	ftxtCost:setMaxWidth(200)
	ftxtCost:setScale(0.8)
end

function WndKidServant:_adaptLanguage_pt(  )	
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndKidServant", WZUIFreeTextBox)
	ftxtCost:setMaxWidth(200)
	ftxtCost:setScale(0.75)

	local txtChooseAtt = GetElement(self.m_root, "txtChooseAtt_WndKidServant", WZUILabelTTF)
	txtChooseAtt:setScale(0.7)
end

function WndKidServant:_adaptLanguage_es(  )	
	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndKidServant", WZUIFreeTextBox)
	ftxtCost:setMaxWidth(200)
	ftxtCost:setScale(0.8)

	local txtChooseAtt = GetElement(self.m_root, "txtChooseAtt_WndKidServant", WZUILabelTTF)
	txtChooseAtt:setScale(0.7)
end
function WndKidServant:_adaptLanguage_ug(  )	
	local txtDesc1 = GetElement(self.m_root, "txtDesc1_WndKidServant", WZUILabelTTF)
	txtDesc1:setScale(0.8)	
	txtDesc1:setDimensions(GlobalMethod:CCSize(860))

	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndKidServant", WZUIFreeTextBox)
	ftxtCost:setMaxWidth(200)
	ftxtCost:setScale(0.8)

	GetElement(self.m_root, "txtGiveup_WndParentsCare", WZUIFreeTextBox):setScale(0.7)
end
-------------------------------------语言适配End----------------------------------------