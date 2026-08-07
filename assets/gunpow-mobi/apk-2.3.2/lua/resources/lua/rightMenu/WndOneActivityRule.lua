--WndOneActivityRule.lua
--@brief	WndOneActivityRule的UI模块
--@date		2020/07/05
--@author	yrd
--@note		一元充活动规则


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndOneActivityRule:onEnter(element)
	self.m_root = element
	ProtocolProcessorNewActivity:regAll()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndOneActivityRule:onExit(element)
	doStopAllActions(self.m_sRootWnd)
	self:_unInit()
end

--@brief	关闭窗口
function WndOneActivityRule:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root ~= nil then 
		WindowManager:removeWindow(self.m_root, self, true)
	end 
end

--@brief	初始化界面
function WndOneActivityRule:_initUI()
	self.m_sRootWnd = GetElement(self.m_root,"root_wnd",WZUIContainer)
	local conType1 = GetElement(self.m_root,"conType1_WndOneActivityRule",WZUIContainer)
	local conType2 = GetElement(self.m_root,"conType2_WndOneActivityRule",WZUIContainer)
	local conType3 = GetElement(self.m_root,"conType3_WndOneActivityRule",WZUIContainer)
	local conType4 = GetElement(self.m_root,"conType4_WndOneActivityRule",WZUIContainer)
	conType1:setVisible(false)
	conType2:setVisible(false)
	conType3:setVisible(false)
	conType4:setVisible(false)

	local txtTitle = GetElement(self.m_root,"txtTitle_WndOneActivityRule",WZUILabelTTF)
	txtTitle:setText(self.m_sTitle)
	if self.m_nType == 1 then
		conType1:setVisible(true)

		local txtDesc1 = GetElement(self.m_root,"txtDesc1_WndOneActivityRule",WZUIFreeTextBox)
		txtDesc1:setShowText(self.m_sDesc)
	elseif self.m_nType == 2 then
		conType2:setVisible(true)

		local btnConfirm = GetElement(self.m_root,"btnConfirm_WndOneActivityRule",WZUIButton)
		local txtDesc2 = GetElement(self.m_root,"txtDesc2_WndOneActivityRule",WZUIFreeTextBox)
		btnConfirm:setVisible(true)
		txtDesc2:setShowText(self.m_sDesc)
	elseif self.m_nType == 3 then
		conType3:setVisible(true)

		ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanMyLuckyCode( )

	elseif self.m_nType == 4 then
		conType4:setVisible(true)

		ProtocolProcessorNewActivity:send_ACTIVITY2_GetOneYuanLuckyWinRecord( )

	end

end

--@brief	type3显示我的幸运码界面
function WndOneActivityRule:_showMyCode(luckyCode)


	local txtDesc3 = GetElement(self.m_root,"txtDesc3_WndOneActivityRule",WZUILabelTTF)
	local btnConfirm3 = GetElement(self.m_root,"btnConfirm3_WndOneActivityRule",WZUIButton)
	if #luckyCode>0 then
		txtDesc3:setText(LocalStrings.ACTIVITY_TEXT_DESC_19.."("..#luckyCode..")")
		txtDesc3:setRelativePosition(GlobalMethod:ccp(0.5,0.735))
		btnConfirm3:setVisible(false)
		
	else
		txtDesc3:setText(LocalStrings.ACTIVITY_TEXT_DESC_26)
		txtDesc3:setRelativePosition(GlobalMethod:ccp(0.5,0.6))
		btnConfirm3:setVisible(true)
	end

	local tconCode = GetElement(self.m_root,"tconCode_WndOneActivityRule",WZUITableContainer)
	tconCode:cleanTable()
	for i=1,#luckyCode do
		local conCode = WZUIContainer:create()
		conCode = WZUIContainer:luaTo(conCode)
        conCode:setTag(i-1)
        conCode:setUseAbsSize(true)
        conCode:setAbsContentSize(GlobalMethod:CCSize(90,30))
        tconCode:setCellElement(conCode)
        local img9Code = WZUI9Image:create()
        img9Code:setCapInsets(CCRectMake(15,15,1,1))
    	img9Code:setFile("ui/common/common_scale9_di8.png")
		conCode:addChild(img9Code)
        local txtCode = WZUILabelTTF:create()
        txtCode:setColor(GlobalMethod:ccc3(255,236,193))
        txtCode:setFontSize(18)
        txtCode:setEnableStroke(true)
		txtCode:setStrokeColor(GlobalMethod:ccc3(79,60,48))
    	txtCode:setStrokeSize(4)
		txtCode:setText(luckyCode[i])
		conCode:addChild(txtCode)
	end
	tconCode:getMoveElement():setPositionY(tconCode:getMinPosition().y)
end

--@brief	type4显示往期回顾界面
function WndOneActivityRule:_showWinnerLog()
	local tData = self.m_tData
	local tconWinnerRecordLog = GetElement(self.m_root,"tconWinnerRecordLog_WndOneActivityRule",WZUITableContainer)
	tconWinnerRecordLog:cleanTable()
	for i=1,#tData do
		delayRun(self.m_sRootWnd, i / DEFAULT_FPS, function()
			local conWinnerLogSub = CreateElement("conWinnerLogSub_WndOneActivityRule")
			conWinnerLogSub = WZUIContainer:luaTo(conWinnerLogSub)
			conWinnerLogSub:setVisible(true)
			conWinnerLogSub:setTag(i-1)
			tconWinnerRecordLog:setCellElement(conWinnerLogSub)

			local btnWinnerHead = GetElement(conWinnerLogSub,"btnWinnerHead_WndOneActivityRule",WZUIButton)
			btnWinnerHead:setTag(i-1)

			--头像
			local conHead = GetElement(conWinnerLogSub,"conWinnerHead_WndOneActivityRule",WZUIContainer)
			local cell,tcell = CellHead:show(conHead, tData[i].headId, tData[i].faceId, tData[i].sex, nil, nil, nil, tData[i].headColor)

			local txtLotteryTime = GetElement(conWinnerLogSub,"txtLotteryTime_WndOneActivityRule",WZUILabelTTF)
			local txtRewardName = GetElement(conWinnerLogSub,"txtRewardName_WndOneActivityRule",WZUILabelTTF)
			local txtWinnerName = GetElement(conWinnerLogSub,"txtWinnerName_WndOneActivityRule",WZUILabelTTF)
			local txtLuckyCode = GetElement(conWinnerLogSub,"txtLuckyCode_WndOneActivityRule",WZUILabelTTF)
			--开奖时间
			local strDate = os.date("%m-%d %H:%M", tData[i].date)
			txtLotteryTime:setText(LocalStrings.ACTIVITY_TEXT_DESC_21..": "..strDate)
			--奖励
			local num = tostring(tData[i].item[1].num)
			if tData[i].itemNum == -1 then
				num = LocalStrings.YJ
			end
			local itemInfo = GDatatab_item["id_"..tData[i].item[1].id]
			txtRewardName:setText(LocalStrings.ATH_REWARD_CHECK..": "..itemInfo.name.."("..num..")")
			--获奖者
			txtWinnerName:setText(LocalStrings.ACTIVITY_TEXT_DESC_22..": "..tData[i].nickname)
			--幸运码
			txtLuckyCode:setText(LocalStrings.ACTIVITY_TEXT_DESC_9..": "..tData[i].luckyCode)
			tconWinnerRecordLog:getMoveElement():setPositionY(tconWinnerRecordLog:getMinPosition().y)
		end)
	end
	-- tconWinnerRecordLog:getMoveElement():setPositionY(tconWinnerRecordLog:getMinPosition().y)
end

--@brief	type4点击获奖者头像回调
function WndOneActivityRule:onClickWinnerHead(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()

    WndCheckOther:show(self.m_tData[tag+1].playerId)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
