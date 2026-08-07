--WndMatchmaking.lua
--@brief	WndMatchmaking的UI模块
--@date		2018/06/20
--@author	Tianxiang_Xu
--@note		征婚中心


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMatchmaking:onEnter(element)
	self.m_root = element
	ChangeChatChannel(Chat_Channel_Matchmaking)
	ProtocolProcessorMatchmaking:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMatchmaking:onExit(element)
	ProtocolProcessorMatchmaking:unregAll()
	self:_unInit()
end

--@brief    加载界面完成回调
function WndMatchmaking:onEnterTransitionDidFinish(element)
    -- body
    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(), self.m_root)
    self.m_tMatchConfig = json.decode(CacheCenter:getGameParam().datingServiceConfig)
    
    local string = string.sub(self.m_tMatchConfig.recommendCost, 2, -2) 
	local id = SplitStringWithSeparator(string,",")[1]
	local num = SplitStringWithSeparator(string,",")[2]
    self.m_tRecommendCost = {}
    self.m_tRecommendCost[1] = tonumber(id)
    self.m_tRecommendCost[2] = tonumber(num)

    self.m_nCurSex = CacheCenter:getPlayerInfo().sex + 1
    self.m_nCurSex = self.m_nCurSex%2

    WZLog("WndMatchmaking:onEnterTransitionDidFinish", Serialize(self.m_tMatchConfig))

    self:setCheckType()
    self:setNextBtnText(LocalStrings.MASTERINFO25, "NORMAL_GREEN_BTN")
    self:_addTop()

    self:_createLoading()
    ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfo()
    ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfoList(self.m_nCurSex)
end

--@brief    退出界面回调
function WndMatchmaking:onClickClose()
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击查看男生、查看女生按钮回调
function WndMatchmaking:onClickSex(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_nCurSex = self.m_nCurSex + 1
    self.m_nCurSex = self.m_nCurSex%2
    self:setCheckType()

    self:_createLoading()
    ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfoList(self.m_nCurSex)
end

--@brief 	点击下一批按钮回调
function WndMatchmaking:onClickNext(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self:_createLoading()
    ProtocolProcessorMatchmaking:send_WEDDING_GetDatingServiceInfoList(self.m_nCurSex)

    self.m_nNextCountTime = 3 
    local btnNext = GetElement(self.m_root, "btnNext_WndMatchmaking", WZUIButton)
    btnNext:setTouchEnable(false)
    self:setNextBtnText(self.m_nNextCountTime .. "S", "NORMAL_GRAY_BTN")

    btnNext:enableSchedule("_timeCount", 1)
end

--@brief 	点击推荐按钮回调
function WndMatchmaking:onClickRecommend(element)
	-- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_nRegisterState == 0 then
    	MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT4)
    else
    	if self.m_nRecommendState == 0 then
    		--弹推荐消耗确认框
    		local tBasicData = GDatatab_item["id_" .. self.m_tRecommendCost[1]]
    		local sContent = string.format(LocalStrings.MATCHMAKE_TEXT2, self.m_tRecommendCost[2], tBasicData.icon)
    		MsgBoxManager:showConfirmBox(sContent, self, self.sureToRecommend)
	    else
    		MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT3)
	    end
    end
end

--@brief 	确定推荐
function WndMatchmaking:sureToRecommend()
	-- body
	if not JudgeMoneyIsEnough(self.m_tRecommendCost[1], self.m_tRecommendCost[2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.useDiamondInstead) then
		return
	end

	self:useDiamondInstead()
end

--@brief 	使用钻石替换消费
function WndMatchmaking:useDiamondInstead()
	-- body
	--发送推荐协议
	self:_createLoading()
	ProtocolProcessorMatchmaking:send_WEDDING_DatingServiceRecommend()
end

--@brief 	点击登记按钮回调
function WndMatchmaking:onClickRegister(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	-- if CacheCenter:getPlayerInfo().mateName and CacheCenter:getPlayerInfo().mateName ~= "" then
	-- 	MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT1)
	-- 	return
	-- end

	if self.m_nRegisterState == 0 then
		WndMatchDeclare:showInterface(1)
	else
		WndMatchDeclare:showInterface(2)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	金币栏
function WndMatchmaking:_addTop()
	-- body
	local celElement, tNewObj = CellTopHandle:createElement()
	tNewObj:setTopData("ui/common/matchmaking_icon_zhzx.png", WndMatchmaking, WndMatchmaking.onClickClose, true, 1, true,nil, {goldType = 1})
    self.m_root:addChild(celElement)
end

--@brief 	查看女生、查看男生按钮
function WndMatchmaking:setCheckType()
	-- body
	local txtSexName = GetElement(self.m_root, "txtSexName_WndMatchmaking", WZUILabelTTF)
	if self.m_nCurSex == 1 then
		txtSexName:setText(LocalStrings.MATCHMAKE_TEXT9)
	else
		txtSexName:setText(LocalStrings.MATCHMAKE_TEXT8)
	end
end

--@brief 	设置换一批按钮的文字
function WndMatchmaking:setNextBtnText(text, style)
	-- body
	local txtNextWord = GetElement(self.m_root, "txtNextWord_WndMatchmaking", WZUILabelTTF)
	if txtNextWord then
		txtNextWord:setText(text)
		txtNextWord:setLabelStyleKey(style)
	end
end

--@brief 	换一批按钮倒计时
function WndMatchmaking:_timeCount(element)
	-- body
	element = WZUIButton:luaTo(element)
	self.m_nNextCountTime = self.m_nNextCountTime - 1
	if self.m_nNextCountTime >= 0 then
		self:setNextBtnText(self.m_nNextCountTime .. "S", "NORMAL_GRAY_BTN")
	else
		element:disableSchedule()
		element:setTouchEnable(true)
		self:setNextBtnText(LocalStrings.MASTERINFO25, "NORMAL_GREEN_BTN")
	end
end

--@brief 	设置登记按钮
function WndMatchmaking:setRegisterBtn()
	-- body
	local img9Register1 = GetElement(self.m_root, "img9Register1_WndMatchmaking", WZUI9Image)
	local img9Register2 = GetElement(self.m_root, "img9Register2_WndMatchmaking", WZUI9Image)
	local img9Register3 = GetElement(self.m_root, "img9Register3_WndMatchmaking", WZUI9Image)
	local txtRegister = GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF)

	-- if CacheCenter:getPlayerInfo().mateName ~= nil and CacheCenter:getPlayerInfo().mateName ~= "" then
	-- 	txtRegister:setText(LocalStrings.MATCHMAKE_TEXT6)
	-- 	txtRegister:setLabelStyleKey("NORMAL_ORANGE_BTN")
	-- 	img9Register1:setFile("ui/common/common_btn_anniu3_1.png")
	-- 	img9Register2:setFile("ui/common/common_btn_anniu3_1_sel.png")
	-- 	img9Register3:setFile("ui/common/common_btn_anniu3_1.png")
	-- else
		if self.m_nRegisterState == 0 then
			txtRegister:setText(LocalStrings.MATCHMAKE_TEXT6)
			txtRegister:setLabelStyleKey("NORMAL_GREEN_BTN")
			img9Register1:setFile("ui/common/common_btn_anniu10_0.png")
			img9Register2:setFile("ui/common/common_btn_anniu10_0_sel.png")
			img9Register3:setFile("ui/common/common_btn_anniu10_0.png")
		else
			txtRegister:setText(LocalStrings.CHANGE)
			txtRegister:setLabelStyleKey("NORMAL_ORANGE_BTN")
			img9Register1:setFile("ui/common/common_btn_anniu3_1.png")
			img9Register2:setFile("ui/common/common_btn_anniu3_1_sel.png")
			img9Register3:setFile("ui/common/common_btn_anniu3_1.png")
		end

	AdaptLanguage(self)
--	end
end

--@brief 	创建列表
function WndMatchmaking:_createPlayerList()
	-- body
	local tableList = GetElement(self.m_root, "tableList_WndMatchmaking", WZUITableContainer)
	tableList:cleanTable()
	self.m_tShowPlayerCell = {}
	local conForList = GetElement(self.m_root, "conForList_WndMatchmaking", WZUIContainer)
	if self.m_tPlayerList == nil or #self.m_tPlayerList == 0 then
		ShowPanelNullTip(conForList, LocalStrings.MATCHMAKE_TEXT5)
		return 
	end
	removeShowPanelNullTip(conForList)

	for i = 1, #self.m_tPlayerList do
		local element, tNewObj = CellMatchMaking:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			tableList:setCellElement(element)
			tNewObj:setData(self.m_tPlayerList[i])
			table.insert(self.m_tShowPlayerCell, tNewObj)
		end
	end
end

--@brief 	设置按钮的显示与否
function WndMatchmaking:setBtnVisible()
	-- body
	local btnCheckSex = GetElement(self.m_root, "btnCheckSex_WndMatchmaking", WZUIButton)
	local btnNext = GetElement(self.m_root, "btnNext_WndMatchmaking", WZUIButton)
	local btnRegister = GetElement(self.m_root, "btnRegister_WndMatchmaking", WZUIButton)
	local btnRecommend = GetElement(self.m_root, "btnRecommend_WndMatchmaking", WZUIButton)

	if self.m_tPlayerList == nil or #self.m_tPlayerList == 0 then
		btnNext:setVisible(false)
	else
		btnNext:setVisible(true)
	end
end

--@brief 	登记时间倒计时
function WndMatchmaking:countTime(element)
	-- body
	if self.m_root == nil then return end 

	if self.m_nRegisterLeftTime > 0 then
		self.m_nRegisterLeftTime = self.m_nRegisterLeftTime - 1

		WndMatchDeclare:setLeftTime()
	else
		self.m_root:disableSchedule()
		self.m_nRegisterState = 0
		self:setRegisterBtn()

		WndMatchDeclare:countTime()
	end
end

--@brief    显示改名结果
--@param    #1返回的结果result : 1、成功，2、重名，3、非法字符，4、名字不能为空，5、名字太长, 6、名字太短,7、纯数字
function WndMatchmaking:displayResult(result)
    --WZLog("************** WndMatchDeclare:displayResult **************** ", result,type(result),result+1)
	local result = tonumber(result)
    if result == 1 then
	    MsgBoxManager:showTipBox(LocalStrings.MATCHMAKE_TEXT16)
    elseif result == 2 then
        MsgBoxManager:showTipBox(LocalStrings.NAME_HAVED_EXIST)
    elseif result == 3 then
        MsgBoxManager:showTipBox(LocalStrings.COMMUNITYINFO3)
    elseif result == 4 then
        MsgBoxManager:showTipBox(LocalStrings.ISBLANKKEY)
    elseif result == 5 then
        MsgBoxManager:showTipBox(string.format(LocalStrings.MATCHMAKE_TEXT19, self.m_tMatchConfig.len))
    elseif result == 6 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_TOO_SHOOT)
    elseif result == 7 then 
        MsgBoxManager:showTipBox(LocalStrings.NAME_CANT_BE_NUMBER)
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndMatchmaking:_adaptLanguage_th(  )
	if self.m_nRegisterState == 0 then
		GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF):setScale(0.65)
	else
		GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF):setScale(1)
	end
end

function WndMatchmaking:_adaptLanguage_en(  )
	if self.m_nRegisterState == 0 then
		GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF):setScale(0.65)
	else
		GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF):setScale(1)
	end
	GetElement(self.m_root, "txtSexName_WndMatchmaking", WZUILabelTTF):setScale(0.7)
end

function WndMatchmaking:_adaptLanguage_pt(  )
	if self.m_nRegisterState == 0 then
		GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF):setScale(0.65)
	else
		GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF):setScale(1)
	end
	GetElement(self.m_root, "txtSexName_WndMatchmaking", WZUILabelTTF):setScale(0.7)
end

function WndMatchmaking:_adaptLanguage_es(  )
	if self.m_nRegisterState == 0 then
		GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF):setScale(0.65)
	else
		GetElement(self.m_root, "txtRegister_WndMatchmaking", WZUILabelTTF):setScale(1)
	end
	GetElement(self.m_root, "txtSexName_WndMatchmaking", WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配End----------------------------------------
