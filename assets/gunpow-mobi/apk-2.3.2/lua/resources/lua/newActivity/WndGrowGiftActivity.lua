--WndGrowGiftActivity.lua
--@brief	WndGrowGiftActivity的UI模块
--@date		2024/08/01
--@author	yrd
--@note		成长活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGrowGiftActivity:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
	g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_ChargeSuccessResult,self._onRechargeSuccessResult,self)
	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGrowGiftActivity:onExit(element)
	g_bIsShowWndDressUp = true
	g_tTempItemForLaterShow = {}
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_ChargeSuccessResult,self._onRechargeSuccessResult,self)

	self:_unInit()
	LoadActivityWordsRes(false)
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndGrowGiftActivity:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7134, 7134)
end

--@brief    点击关闭窗口按钮
function WndGrowGiftActivity:showInterface()
	LoadActivityWordsRes(true)
	LoadNewActivityRes(true)
	local wnd = WndGrowGiftActivity:createElement()
	WindowManager:addWindow(wnd, WndGrowGiftActivity, false)
end

--@brief    点击关闭窗口按钮
function WndGrowGiftActivity:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    初始化静态文本
function WndGrowGiftActivity:_initStaticText()
	GetElement(self.m_root,"txtTab1T1",WZUILabelTTF):setText(LocalStrings.GROW_GIFT_TEXT1[2])
	GetElement(self.m_root,"txtTab1T2",WZUILabelTTF):setText(LocalStrings.GROW_GIFT_TEXT1[2])
	GetElement(self.m_root,"txtTab2T1",WZUILabelTTF):setText(LocalStrings.GROW_GIFT_TEXT1[3])
	GetElement(self.m_root,"txtTab2T2",WZUILabelTTF):setText(LocalStrings.GROW_GIFT_TEXT1[3])
end

--@brief    点击页签
function WndGrowGiftActivity:onClickTab()
	local cbgTab = GetElement(self.m_root,"cbgTab",WZUICheckBoxGroup)
	local tab = cbgTab:getCheckIndex()
	if self.m_nCheckIndex == tab then
		return
	end

	self.m_nCheckIndex = tab

	local paths = {"ui/activityWords/bt_text_czlb_cz.png", "ui/activityWords/bt_text_czlb_zx.png"}
	local imgActTitle = GetElement(self.m_root,"imgActTitle",WZUIImage)
	imgActTitle:setFile(paths[self.m_nCheckIndex+1])

	self:updateUI()
end

--@brief    更新界面
function WndGrowGiftActivity:updateUI()
	self.m_tRewardsObj = {}
	local flcGiftList = GetElement(self.m_root,"flcGiftList",WZUIFreeListContainer)
	flcGiftList:removeAll()
	local tData = self.m_tRewardsData[self.m_nCheckIndex+1]
	for i=1,#tData do
		local celElement, tLuaObj = CellGrowGiftActivity:createElement()
		celElement:setTag(i-1)
		flcGiftList:pushBack(celElement)
		tLuaObj:setData(tData[i])
		table.insert(self.m_tRewardsObj, tLuaObj)
	end
	flcGiftList:getMoveElement():setPositionX(flcGiftList:getMaxPosition().x)

	local tRechargeData = self:getRechargeData()
	local bShow = self.m_tStatus[self.m_nCheckIndex+1] ~= 1
	GetElement(self.m_root,"btnOpen",WZUIButton):setVisible(bShow)
	GetElement(self.m_root,"txtOpen",WZUILabelTTF):setText(tRechargeData.unit..LocalStrings.BUY)
end

--@brief    点击解锁按钮
function WndGrowGiftActivity:onClickOpen()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tRechargeData = self:getRechargeData()

	if tRechargeData then
		local sjson = {}
		sjson.giftId = self.m_nCheckIndex
		sjson.rechargeId = tRechargeData.id
		sjson = json.encode(sjson)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 3, sjson )
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


--@brief    语言适配
function WndGrowGiftActivity:_adaptLanguage_vn()
	GetElement(self.m_root,"txtOpen",WZUILabelTTF):setScale(0.8)
end
