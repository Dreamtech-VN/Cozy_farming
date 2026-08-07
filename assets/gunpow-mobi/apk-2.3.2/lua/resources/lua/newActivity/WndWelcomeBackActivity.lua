--WndWelcomeBackActivity.lua
--@brief	WndWelcomeBackActivity的UI模块
--@date		2023/03/06
--@author	yrd
--@note		欢迎回来活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWelcomeBackActivity:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:initUI()
	self:_showUI()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWelcomeBackActivity:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndWelcomeBackActivity:onEnterTransitionDidFinish(element)
    WZLog("WndWelcomeBackActivity:onEnterTransitionDidFinish")

    self:startLoading()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7068, 7068)
end

--@brief	开始加载
--@note 	显示加载对话框
function WndWelcomeBackActivity:startLoading()
	self.m_nLoadingBoxID = MsgBoxManager:showLoadingBox(60)
end

--@brief	停止加载
--@note 	关闭加载对话框
function WndWelcomeBackActivity:stopLoading()
	if self.m_nLoadingBoxID ~= nil then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingBoxID)
		self.m_nLoadingBoxID = nil
	end
end

function WndWelcomeBackActivity:initUI()
	self:initStaticText()

	local cbAtt = GetElement(self.m_root, "cbAtt_WndWelcomeBackActivity", WZUICheckBox)
	local nValue = self:getAutoActivity()
	cbAtt:setCheckIndex(nValue)
end
--@brief 界面显示
function WndWelcomeBackActivity:_showUI()
	for i = 1, 2 do
		GetElement(self.m_root, "conContent" .. i .. "_WndWelcomeBackActivity", WZUIContainer):setVisible(i == self.m_nInterfaceIndex)
	end
end

--@brief 界面2显示
function WndWelcomeBackActivity:_showCheckUI()
	if self.m_nInterfaceIndex == 2 then
		GetElement(self.m_root,"cbgBtn_WndWelcomeBackActivity",WZUICheckBoxGroup):setCheckIndex(self.m_nSelectedIndex)

		local conC2Clock = GetElement(self.m_root,"conC2Clock_WndWelcomeBackActivity",WZUIContainer)
		local txtDayRecharge = GetElement(self.m_root,"txtDayRecharge_WndWelcomeBackActivity",WZUILabelTTF)
		if self.m_nSelectedIndex == 0 then
			conC2Clock:setVisible(false)
			txtDayRecharge:setText("")
			self:updateT1UI()
		elseif self.m_nSelectedIndex == 1 then
			conC2Clock:setVisible(true)
			txtDayRecharge:setText(LocalStrings.RECHARGE_TODAY..":"..self.m_tOtherData.dayRecharge)
			self:updateT2UI()
		end
	end
end

--@brief    更新"专属坐骑"界面
function WndWelcomeBackActivity:updateT1UI()
	WZLog("WndWelcomeBackActivity:updateT1UI")
	if self.m_tSignRewards == nil then
		return
	end

	local tbList = GetElement(self.m_root,"tbList_WndWelcomeBackActivity",WZUITableContainer)
	tbList:cleanTable()
	self.m_tT1CellObjs = {}
	for i = 1, #self.m_tSignRewards do
		local element, tNewObj = CellWelcomeBackItem:createElement()
		element:setTag(i - 1)
		local tData = {}
		tData.index = i
		tData.type = 1
		tData.activityId = self.m_nActivityId
		tData.day = self.m_tOtherData.day
		tData.items = self.m_tSignRewards[i]
		tData.status = self.m_tOtherData.signStatus[i]
		tData.signConfig = self.m_tSignConfig
		tNewObj:setData(tData)
		tbList:setCellElement(element)
		table.insert(self.m_tT1CellObjs, tNewObj)
	end

	local cellWidth = 194
	local nCurDayIndex = self.m_tOtherData.day
	if nCurDayIndex > 4 then 
		local nCurPositionX = tbList:getMaxPosition().x - (nCurDayIndex - 4) * cellWidth
		if nCurPositionX < tbList:getMinPosition().x then 
			nCurPositionX = tbList:getMinPosition().x
		end
		tbList:getMoveElement():setPositionX(nCurPositionX)
	end
end

--@brief    更新"我要变强"界面
function WndWelcomeBackActivity:updateT2UI()
	WZLog("WndWelcomeBackActivity:updateT2UI")

	local tbList = GetElement(self.m_root,"tbList_WndWelcomeBackActivity",WZUITableContainer)
	tbList:cleanTable()
	self.m_tT2CellObjs = {}

	local nIndex = 0

	-- 打卡
	for i = 1, #self.m_tDaKaRewards do
		local element, tNewObj = CellWelcomeBackItem:createElement()
		element:setTag(nIndex)
		local tData = {}
		tData.index = i
		tData.type = 2
		tData.activityId = self.m_nActivityId
		tData.day = self.m_tOtherData.day
		tData.items = self.m_tDaKaRewards[i]
		tData.status = self.m_tOtherData.daKaStatus[i]
		tData.signConfig = self.m_tDaKaConfig
		-- tData.recharge = self.m_tOtherData.recharge
		tData.rechargeNum = self.m_tRechargeNum[i]
		tData.recharge = self.m_tOtherData.recharge[i]
		tNewObj:setData(tData)
		tbList:setCellElement(element)
		table.insert(self.m_tT2CellObjs, tNewObj)
		nIndex = nIndex + 1

		-- 礼包
		for j = 1, #self.m_tRechargeShowConfig do
			if i == self.m_tRechargeShowConfig[j] then
				local element, tNewObj = CellWelcomeBackItem:createElement()
				element:setTag(nIndex)
				local tData = {}
				tData.index = j
				tData.type = 3
				tData.activityId = self.m_nActivityId
				tData.day = self.m_tOtherData.day
				tData.rechargeConfig = self.m_tRechargeConfig[j]
				tData.rechargeRewards = self.m_tRechargeRewards[j]
				tData.rechargeBuyNum = self.m_tOtherData.rechargeBuyNum[j]
				tData.rechargePrice = self.m_tRechargePrice[j]
				tData.rechargeLimit = self.m_tRechargeLimit[j]
				
				tNewObj:setData(tData)
				tbList:setCellElement(element)
				table.insert(self.m_tT2CellObjs, tNewObj)
				nIndex = nIndex + 1
			end
		end
	end

	if self.m_tbConMove2PosX then
		tbList:getMoveElement():setPositionX(self.m_tbConMove2PosX)
	end

	self:updateT2BoxProgress()
end

--@brief    更新"我要变强"界面 箱子进度
function WndWelcomeBackActivity:updateT2BoxProgress()
	local txtC2ProgVal = GetElement(self.m_root,"txtC2ProgVal_WndWelcomeBackActivity",WZUILabelTTF)
	txtC2ProgVal:setText(self.m_tOtherData.giftCount.."/"..#self.m_tDaKaRewards)
	local progClock = GetElement(self.m_root,"progClock_WndWelcomeBackActivity",WZUIProgress)
	progClock:setPercentage(self.m_tOtherData.giftCount/#self.m_tDaKaRewards*100)

	local fileName = {"common_icon_lan","common_icon_zi","common_icon_huang","common_icon_zis","common_icon_hong"}
	for i=1,#self.m_tGiftConfig do
		local btnClockBox = GetElement(self.m_root,"btnClockBox"..i.."_WndWelcomeBackActivity",WZUIButton)
		btnClockBox:setRelativePosition(GlobalMethod:ccp(self.m_tGiftConfig[i]/#self.m_tDaKaRewards,0.67))

		local status
		if self.m_tOtherData.giftStatus[i] == -1 then
			status = 1
		elseif self.m_tOtherData.giftStatus[i] == 0 then
			status = 2
		elseif self.m_tOtherData.giftStatus[i] == 1 then
			status = 3
		end
		local imgClockBox = GetElement(self.m_root,"imgClockBox"..i.."_WndWelcomeBackActivity",WZUIImage)
		imgClockBox:setFile("ui/common/"..fileName[i]..status..".png")

		local txtClockBox = GetElement(self.m_root,"txtClockBox"..i.."_WndWelcomeBackActivity",WZUILabelTTF)
		txtClockBox:setText(self.m_tGiftConfig[i])

		local armBox = GetElement(self.m_root,"armBox"..i.."_WndWelcomeBackActivity",WZUISpine)
		armBox:setVisible(self.m_tOtherData.giftStatus[i] == 0)
	end
	--策划说把第一个箱子往前一点的,为了好看
	GetElement(self.m_root,"btnClockBox1_WndWelcomeBackActivity",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.15,0.67))

end

--@brief    关闭窗口
function WndWelcomeBackActivity:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    GlobalGame.g_autoWelcomeBack = false 
    local bIsCheck = false 
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
        bIsCheck = true
    end
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
    --继续检测后续弹窗
    if bIsCheck then 
		SceneCity:aloneActivityWinCheck()
    end
end

--@brief	初始化静态文本
function WndWelcomeBackActivity:initStaticText()
	GetElement(self.m_root,"txtCheckBox_WndWelcomeBackActivity",WZUILabelTTF):setText(LocalStrings.ACITVITY_WELCOME_BACK[2])
	GetElement(self.m_root,"txtCheckBoxSel_WndWelcomeBackActivity",WZUILabelTTF):setText(LocalStrings.ACITVITY_WELCOME_BACK[2])

	GetElement(self.m_root,"check1Nor_WndWelcomeBackActivity",WZUILabelTTF):setText(LocalStrings.ACITVITY_WELCOME_BACK[3])
	GetElement(self.m_root,"check1Sel_WndWelcomeBackActivity",WZUILabelTTF):setText(LocalStrings.ACITVITY_WELCOME_BACK[3])
	GetElement(self.m_root,"check2Nor_WndWelcomeBackActivity",WZUILabelTTF):setText(LocalStrings.ACITVITY_WELCOME_BACK[4])
	GetElement(self.m_root,"check2Sel_WndWelcomeBackActivity",WZUILabelTTF):setText(LocalStrings.ACITVITY_WELCOME_BACK[4])

	GetElement(self.m_root,"txtC2ProgWord_WndWelcomeBackActivity",WZUILabelTTF):setText(LocalStrings.ACITVITY_WELCOME_BACK[5])

end

--@brief 	点击继续按钮回调
function WndWelcomeBackActivity:onClickContinue(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_nInterfaceIndex = 2
	self:_showUI()
	self:_showCheckUI()
end

--@brief 	点击复选框回调
function WndWelcomeBackActivity:onClickCheckBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local cbAtt = GetElement(self.m_root, "cbAtt_WndWelcomeBackActivity", WZUICheckBox)
	local nValue = cbAtt:getCheckIndex()
	self:saveAutoActivity(nValue)
end

--@brief 	初始化活动时间
function WndWelcomeBackActivity:_initActivityTime()
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local timeFormat = "%02d.%02d-%02d.%02d"
    local needDay_str = string.format(timeFormat, DayStartTab.month, DayStartTab.day, DayEndTab.month, DayEndTab.day)
    local txtActivityTime1 = GetElement(self.m_root, "txtActivityTime1_WndWelcomeBackActivity", WZUILabelTTF)
    if txtActivityTime1 then 
    	txtActivityTime1:setText(needDay_str)
    end
end

--@brief 	刷新
function WndWelcomeBackActivity:_update()
	self:_initActivityTime()
	self:_showCheckUI()
end

--@brief 	点击切换"专属坐骑","我要变强"按钮
function WndWelcomeBackActivity:onClickM2Check(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nSelectedIndex = element:getTag()
	self.m_tbConMove2PosX = nil
	self:_showCheckUI()
end

--@brief 	点击进度礼包箱子
function WndWelcomeBackActivity:onClickClockBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if self.m_tOtherData.giftStatus[tag] == -1 or self.m_tOtherData.giftStatus[tag] == 1 then
		local tData = {}
		tData.ids = {}
		tData.nums = {}
		for i=1,#self.m_tGiftRewards[tag] do
			table.insert(tData.ids, self.m_tGiftRewards[tag][i][1])
			table.insert(tData.nums, self.m_tGiftRewards[tag][i][2])
		end
		WndTips:show(element,self.m_root,10,tData,GlobalMethod:ccp(200,60), true)
	elseif self.m_tOtherData.giftStatus[tag] == 0 then
		local tData = {}
		tData.gift = tag - 1
		stringData = json.encode(tData)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, stringData)
	end
end

--@brief 	点击活动规则
function WndWelcomeBackActivity:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndWelcomeBackDesc:showInterface(LocalStrings.ACITVITY_WELCOME_BACK2)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


----------------------------------------语言适配Begin---------------------------------------

function WndWelcomeBackActivity:_adaptLanguage_vn(  )
	GetElement(self.m_root,"check1Nor_WndWelcomeBackActivity",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"check1Sel_WndWelcomeBackActivity",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"check2Nor_WndWelcomeBackActivity",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"check2Sel_WndWelcomeBackActivity",WZUILabelTTF):setScale(0.8)
end

---------------------------------------语言适配End-----------------------------------------
