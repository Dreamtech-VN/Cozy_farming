--WndKidBorn.lua
--@brief	WndKidBorn的UI模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		生育小孩界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidBorn:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidBorn:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidBorn:onEnterTransitionDidFinish(element)
    -- body
    local tTempConfig = json.decode(CacheCenter:getGameParam().bearConfig)
    self.m_tBornConfig = tTempConfig
    WZLog("WndKidBorn:onEnterTransitionDidFinish", Serialize(tTempConfig))

    self.m_nBornLevel = tTempConfig.bearLoveLvel
    self.m_nBornPercent = tTempConfig.bearRate

    SceneKidHome:_createLoading()
    ProtocolProcessorKid:send_WEDDING_WEDDING_BearChild(3)
end

--@brief 	点击生育、领养按钮回调
function WndKidBorn:onClickBorn(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	local playerInfo = CacheCenter:getPlayerInfo()
	if nTag == 1 then 	--领养
		if playerInfo.mateName ~= nil and playerInfo.mateName ~= "" then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT22)
			return 
		end
		--判断是否还能领养
		if SceneKidHome.m_nConceiveTime > 0 then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT64)
			return
		end
		local babyNum = #SceneKidHome.m_tKidData
		if babyNum >= 1 then 
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT26)
			return 
		end
		--判断物品是否足够
		local string = string.sub(self.m_tBornConfig.adoptCost, 2, -2) 
		local id = SplitStringWithSeparator(string, ",")[1]
		local num = SplitStringWithSeparator(string, ",")[2]

		if not JudgeMoneyIsEnough(tonumber(id), tonumber(num), nil, nil, GlobalGame.g_nCurrentUIChannelId) then
			return 
		end
		--发送领养协议1
		SceneKidHome:_createLoading()
		ProtocolProcessorKid:send_WEDDING_WEDDING_BearChild(2)
	elseif nTag == 2 then 	--生育
		if playerInfo.mateName == nil or playerInfo.mateName == "" then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT23)
			return 
		end
		if playerInfo.loveLevel < self.m_nBornLevel then
			MsgBoxManager:showTipBox(string.format(LocalStrings.KID_TEXT25, self.m_nBornLevel))
			return 
		end
		--怀孕中，不能继续怀孕
		if SceneKidHome.m_nConceiveTime > 0 then
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT63)
			return
		end
		--判断是否还能再生育（是否怀孕中、数量是否超了）
		local babyNum = #SceneKidHome.m_tKidData
		if babyNum >= 2 then 
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT27)
			return 
		end
		--判断物品是否足够
		local string = string.sub(self.m_tBornConfig.bearCost, 2, -2) 
		local id = SplitStringWithSeparator(string, ",")[1]
		local num = SplitStringWithSeparator(string, ",")[2]

		if not JudgeMoneyIsEnough(tonumber(id), tonumber(num), nil, nil, GlobalGame.g_nCurrentUIChannelId) then
			return 
		end
		--发送生育协议1
		SceneKidHome:_createLoading()
		ProtocolProcessorKid:send_WEDDING_WEDDING_BearChild(1)
	elseif nTag == 3 then 	--选择性别界面中的领养或生育按钮
		if not self.m_bCanClickBorn then return end

		local string = string.sub(self.m_tBornConfig.transsexCost, 2, -2) 
		local id = SplitStringWithSeparator(string, ",")[1]
		local num = SplitStringWithSeparator(string, ",")[2]

		if self.m_nSexSelIndex ~= self.m_nBabyAutoSex then
			if not JudgeMoneyIsEnough(tonumber(id), tonumber(num), nil, nil, GlobalGame.g_nCurrentUIChannelId) then
				return 
			end
		end
		self:dealWithName()
	end
end

--@brief 	点击选择性别
function WndKidBorn:onClickSex(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag - 1 == self.m_nSexSelIndex then return end
	self.m_nSexSelIndex = nTag - 1

	self:setSexState()
	self:setSexBtnText()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndKidBorn:_update()
	-- body
	self:setStaticText()
	self:showContent()
	self:setSexBtnText()
end
--@brief 	设置标题和按钮字
function WndKidBorn:setStaticText()
	-- body
	WZLog("WndKidBorn:setStaticText")
	--领养证和生育单的数量
	self:setGoodsNum()
	--
	GetElement(self.m_root, "txtDesc2_WndKidBorn", WZUILabelTTF):setText(string.format(LocalStrings.KID_TEXT31, self.m_nBornLevel))
	self:_setBornPercent()

	local playerInfo = CacheCenter:getPlayerInfo()
	local txtTitle3 = GetElement(self.m_root, "txtTitle3_WndKidBorn", WZUILabelTTF)
	if playerInfo.mateName == nil or playerInfo.mateName == "" then
		txtTitle3:setText(LocalStrings.KID_TEXT28)
	else
		txtTitle3:setText(LocalStrings.KID_TEXT29)
	end
	
	local txtDesc3 = GetElement(self.m_root, "txtDesc3_WndKidBorn", WZUILabelTTF)
	if txtDesc3 then
		if self.m_nBabyAutoSex == 0 then
			txtDesc3:setText(LocalStrings.KID_TEXT35)
		else
			txtDesc3:setText(LocalStrings.KID_TEXT36)
		end
	end

	--
	local edit = GetElement(self.m_root,"editBox_WndKidBorn", WZUIEditBox)
    edit:setPlaceHolder(LocalStrings.KID_TEXT39)
end

--@brief 	设置怀孕概率
function WndKidBorn:_setBornPercent()
	-- body
	GetElement(self.m_root, "txtBornPercent_WndKidBorn", WZUILabelTTF):setText(string.format(LocalStrings.KID_TEXT32, self.m_nBornPercent))
end

--@brief 	设置领养证和怀孕丹的数量
function WndKidBorn:setGoodsNum()
	-- body
	--领养证
	local string = string.sub(self.m_tBornConfig.adoptCost, 2, -2) 
	local id = SplitStringWithSeparator(string, ",")[1]
	local num = SplitStringWithSeparator(string, ",")[2]
	
	local basicInfo = GDatatab_item["id_" .. id]
	local nHaveNum = CacheCenter:getPlayerItemCountById(tonumber(id))
	local sFormat = [[<T C="105,65,46" S="20" P="1" SC="0,72,3" SS="4" SE="0">%s%s:</T><T C="105,65,46" S="20" P="1" SC="127,70,26" SS="4" SE="0">%d</T>]]
	GetElement(self.m_root,"ftxtOwn1_WndKidBorn",WZUIFreeTextBox):setShowText(string.format(sFormat, LocalStrings.OWN, basicInfo.name, nHaveNum))
	--生育丹
	string = string.sub(self.m_tBornConfig.bearCost, 2, -2) 
	id = SplitStringWithSeparator(string, ",")[1]
	num = SplitStringWithSeparator(string, ",")[2]

	basicInfo = GDatatab_item["id_" .. id]
	nHaveNum = CacheCenter:getPlayerItemCountById(tonumber(id))
	GetElement(self.m_root, "ftxtOwn2_WndKidBorn", WZUIFreeTextBox):setShowText(string.format(sFormat, LocalStrings.OWN, basicInfo.name, nHaveNum))

	--改变性别消耗
	local ftxtSexCost = GetElement(self.m_root, "ftxtSexCost_WndKidBorn", WZUIFreeTextBox)
	if ftxtSexCost then
		local sFormat = [[<T C="105,65,46" S="22" P="1" SC="0,72,3" SS="4" SE="0">%s%s</T><I Z="0.5">%s</I><T C="105,65,46" S="20" P="1" SC="127,70,26" SS="4" SE="0">X%d(%s%d)</T>]]
		local string = string.sub(self.m_tBornConfig.transsexCost, 2, -2) 
		local id = SplitStringWithSeparator(string, ",")[1]
		local num = SplitStringWithSeparator(string, ",")[2]
		local basicData = GDatatab_item["id_" .. id]
		nHaveNum = CacheCenter:getPlayerItemCountById(tonumber(id))
		ftxtSexCost:setShowText(string.format(sFormat, LocalStrings.PETUSE, basicData.name, basicData.icon, tonumber(num), LocalStrings.PETHAS, nHaveNum))
	end
end

--@brief 	选择性别界面按钮文字随机应变
function WndKidBorn:setSexBtnText()
	-- body
	local txtBtnText = GetElement(self.m_root, "txtBtnText_WndKidBorn", WZUILabelTTF)
	local ftxtSexCost = GetElement(self.m_root, "ftxtSexCost_WndKidBorn", WZUIFreeTextBox)
	local playerInfo = CacheCenter:getPlayerInfo()

	if self.m_nBabyAutoSex == self.m_nSexSelIndex then
		ftxtSexCost:setVisible(false)
		if playerInfo.mateName == nil or playerInfo.mateName == "" then
			txtBtnText:setText(LocalStrings.KID_TEXT20)
		else
			txtBtnText:setText(LocalStrings.KID_TEXT21)
		end
	else
		ftxtSexCost:setVisible(true)
		txtBtnText:setText(LocalStrings.CHANGE)
	end
end

--@brief 	小孩名字的处理
function WndKidBorn:dealWithName()
	-- body
	local text = WZUIEditBox:luaTo(GetElement(self.m_root,"editBox_WndKidBorn")):getText()
	if text == "" then
		MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
		return
	elseif Regexp:isAllBlankChar(text) == true then--全部是空白键
		MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
		return 
	end

    if self:_checkName() then
    	--弹二次确认框
    	local sMsgBox = LocalStrings.KID_TEXT37
    	if self.m_nSexSelIndex == 1 then
    		sMsgBox = LocalStrings.KID_TEXT38
    	end
    	MsgBoxManager:showConfirmBox(sMsgBox, self, self.sureToBorn)
    end
end

--@brief 	确定生育或领养当前选中的性别的孩子
function WndKidBorn:sureToBorn()
	-- body
	--发送生育协议，生育成功返回关闭界面，刷新怀孕或领取状态
	self:setTouchLimit(false)
	local text = WZUIEditBox:luaTo(GetElement(self.m_root,"editBox_WndKidBorn")):getText()
	SceneKidHome:_createLoading()
	WZLog("WndKidBorn:sureToBorn", self.m_nKidId, self.m_nSexSelIndex, text)
	ProtocolProcessorKid:send_WWEDDING_DecideChildSex(self.m_nKidId, self.m_nSexSelIndex, text)
end

--@brief 	检查小孩的名字
function WndKidBorn:_checkName()
    local editInputName = GetElement(self.m_root,"editBox_WndKidBorn",WZUIEditBox)
    local txtName = editInputName:getText()

    -- 空或者不是字符串
    if type(txtName) ~= "string" or "" == txtName then
        MsgBoxManager:showTipBox(LocalStrings.KID_TEXT39, nil, nil, nil, nil)
        return false
    end

    WZLog("********** WndKidBorn:_checkName **************", txtName)
    local nInputTextLen, spaceCnt = WndBag:_checkInputTxtLen(txtName)
    -- 不能存在空格，长度不超过6个字符
    if spaceCnt > 0 then
        MsgBoxManager:showTipBox(LocalStrings.LEAGUE61)
        return false
    elseif nInputTextLen > 8 then
        MsgBoxManager:showTipBox(LocalStrings.DRESSSUIT_TEXT1)
        return false
    end

    return true
end

--@brief 	根据阶段，显示相应的内容
function WndKidBorn:showContent()
	-- body
	WZLog("WndKidBorn:showContent")
	local conCouple = GetElement(self.m_root, "conCouple_WndKidBorn", WZUIContainer)
	local conChooseSex = GetElement(self.m_root, "conChooseSex_WndKidBorn", WZUIContainer)
	if self.m_nBornState == 1 then
		conCouple:setVisible(false)
		conChooseSex:setVisible(true)
		self:setSexState()
	else
		conCouple:setVisible(true)
		conChooseSex:setVisible(false)
	end
end

--@brief 	性别选中状态
function WndKidBorn:setSexState()
	-- body
	GetElement(self.m_root, "imgGou1_WndKidBorn", WZUIImage):setVisible(false)
	GetElement(self.m_root, "imgGou2_WndKidBorn", WZUIImage):setVisible(false)
	
	local nIndex = (self.m_nSexSelIndex + 1)
	GetElement(self.m_root, "imgGou" .. nIndex .. "_WndKidBorn", WZUIImage):setVisible(true)
end

--@brief    显示改名结果
--@param    #1返回的结果result : 1、成功，2、重名，3、非法字符，4、名字不能为空，5、名字太长, 6、名字太短,7、纯数字
function WndKidBorn:displayResult(result)
    WZLog("************** WndKidBorn:displayResult **************** ", result)

    if result == 1 then
	    MsgBoxManager:showTipBox(LocalStrings.DRESSSUIT_TEXT2)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.NAME_HAVED_EXIST)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO3)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
    elseif result == 10 or result == 5 then
        MsgBoxManager:showTipBox(LocalStrings.DRESSSUIT_TEXT1)
    elseif result == 6 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_TOO_SHOOT)
    elseif result == 7 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_CANT_BE_NUMBER)
    elseif result == 8 then 
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO5)
    end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function WndKidBorn:_adaptLanguage_en( )
	GetElement(self.m_root, "txtTitle1_WndKidBorn", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtTitle2_WndKidBorn", WZUILabelTTF):setScale(0.8)

	local txtDesc1 = GetElement(self.m_root, "txtDesc1_WndKidBorn", WZUILabelTTF)
	txtDesc1:setScale(0.7)
	txtDesc1:setDimensions(GlobalMethod:CCSize(460))
	local txtDesc2 = GetElement(self.m_root, "txtDesc2_WndKidBorn", WZUILabelTTF)
	txtDesc2:setScale(0.7)
	txtDesc2:setDimensions(GlobalMethod:CCSize(460))

	local txtBtn1 = GetElement(self.m_root, "txtBtn1_WndKidBorn", WZUILabelTTF)
	txtBtn1:setScale(0.75)
	local txtBtn2 = GetElement(self.m_root, "txtBtn2_WndKidBorn", WZUILabelTTF)
	txtBtn2:setScale(0.75)
	
	local txtTitle3 = GetElement(self.m_root, "txtTitle3_WndKidBorn", WZUILabelTTF)
	txtTitle3:setScale(0.8)
	local txtBtnText = GetElement(self.m_root, "txtBtnText_WndKidBorn", WZUILabelTTF)
	txtBtnText:setScale(0.7)
end

function WndKidBorn:_adaptLanguage_th( )
	local txtDesc1 = GetElement(self.m_root, "txtDesc1_WndKidBorn", WZUILabelTTF)
	txtDesc1:setScale(0.7)
	txtDesc1:setDimensions(GlobalMethod:CCSize(460))
	local txtDesc2 = GetElement(self.m_root, "txtDesc2_WndKidBorn", WZUILabelTTF)
	txtDesc2:setScale(0.7)
	txtDesc2:setDimensions(GlobalMethod:CCSize(460))
end

function WndKidBorn:_adaptLanguage_tr( )
	GetElement(self.m_root, "txtTitle1_WndKidBorn", WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root, "txtTitle2_WndKidBorn", WZUILabelTTF):setScale(0.8)

	local txtDesc1 = GetElement(self.m_root, "txtDesc1_WndKidBorn", WZUILabelTTF)
	txtDesc1:setScale(0.7)
	txtDesc1:setDimensions(GlobalMethod:CCSize(460))
	local txtDesc2 = GetElement(self.m_root, "txtDesc2_WndKidBorn", WZUILabelTTF)
	txtDesc2:setScale(0.7)
	txtDesc2:setDimensions(GlobalMethod:CCSize(460))

	local txtBtn1 = GetElement(self.m_root, "txtBtn1_WndKidBorn", WZUILabelTTF)
	txtBtn1:setScale(0.75)
	local txtBtn2 = GetElement(self.m_root, "txtBtn2_WndKidBorn", WZUILabelTTF)
	txtBtn2:setScale(0.75)
	
	local txtTitle3 = GetElement(self.m_root, "txtTitle3_WndKidBorn", WZUILabelTTF)
	txtTitle3:setScale(0.8)
	local txtBtnText = GetElement(self.m_root, "txtBtnText_WndKidBorn", WZUILabelTTF)
	txtBtnText:setScale(0.8)
end

function WndKidBorn:_adaptLanguage_pt( )
	local img9icon1 = GetElement(self.m_root, "img9icon1_WndKidBorn", WZUI9Image)
	img9icon1:setScaleX(2)
	img9icon1:setRelativePosition(GlobalMethod:ccp(1,0.5))

	local txtDesc1 = GetElement(self.m_root, "txtDesc1_WndKidBorn", WZUILabelTTF)
	txtDesc1:setScale(0.7)
	txtDesc1:setDimensions(GlobalMethod:CCSize(460))
	local txtDesc2 = GetElement(self.m_root, "txtDesc2_WndKidBorn", WZUILabelTTF)
	txtDesc2:setScale(0.7)
	txtDesc2:setDimensions(GlobalMethod:CCSize(460))

	GetElement(self.m_root, "txtDesc3_WndKidBorn", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(0,0))

	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo.mateName == nil or playerInfo.mateName == "" then
		local img9icon3 = GetElement(self.m_root, "img9icon3_WndKidBorn", WZUI9Image)
		img9icon3:setScaleX(2)
		img9icon3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		img9icon3:setRelativePosition(GlobalMethod:ccp(0,0.5))
	end
end

function WndKidBorn:_adaptLanguage_es( )
	local img9icon1 = GetElement(self.m_root, "img9icon1_WndKidBorn", WZUI9Image)
	img9icon1:setScaleX(2)
	img9icon1:setRelativePosition(GlobalMethod:ccp(1,0.5))

	local txtDesc1 = GetElement(self.m_root, "txtDesc1_WndKidBorn", WZUILabelTTF)
	txtDesc1:setScale(0.7)
	txtDesc1:setDimensions(GlobalMethod:CCSize(460))
	local txtDesc2 = GetElement(self.m_root, "txtDesc2_WndKidBorn", WZUILabelTTF)
	txtDesc2:setScale(0.7)
	txtDesc2:setDimensions(GlobalMethod:CCSize(460))
	
	local playerInfo = CacheCenter:getPlayerInfo()
	if playerInfo.mateName == nil or playerInfo.mateName == "" then
		local img9icon3 = GetElement(self.m_root, "img9icon3_WndKidBorn", WZUI9Image)
		img9icon3:setScaleX(2)
		img9icon3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		img9icon3:setRelativePosition(GlobalMethod:ccp(0,0.5))
	end
end
-------------------------------------语言适配End----------------------------------------