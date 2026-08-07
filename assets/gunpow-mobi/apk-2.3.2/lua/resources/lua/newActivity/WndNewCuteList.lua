--WndNewCuteList.lua
--@brief	WndNewCuteList的UI模块
--@date		2022/10/31
--@author	XTX
--@note		新萌榜活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndNewCuteList:onEnter(element)
	self.m_root = element

	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndNewCuteList:onExit(element)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndNewCuteList:onEnterTransitionDidFinish(element)
    WZLog("WndNewCuteList:onEnterTransitionDidFinish")
    self:_initStaticText()

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7060, 7060)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7060, self.m_nTabIndex)
end

--@brief    关闭窗口
function WndNewCuteList:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndNewCuteList:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.GOPHERBALL_TEXT3) 
end

function WndNewCuteList:onBtnRole()
	if not self.m_tRoleData then return end

	WndCheckOther:show(self.m_tRoleData.playerId)
end

--@brief 	点击切换标签
function WndNewCuteList:onClickTab(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = element:getTag()
    if self.m_nTabIndex == nTag then return end 

    self.m_nTabIndex = nTag 
    self:_setDynamicText()
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7060, self.m_nTabIndex)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化静态文本
function WndNewCuteList:_initStaticText()
	GetElement(self.m_root, "txtCheckBox1_WndNewCuteList", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[17])
	GetElement(self.m_root, "txtCheckBoxSel1_WndNewCuteList", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[17])
	GetElement(self.m_root, "txtCheckBox2_WndNewCuteList", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[6])
	GetElement(self.m_root, "txtCheckBoxSel2_WndNewCuteList", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[6])

	self:_setDynamicText()
end

--@brief 	设置动态文本
function WndNewCuteList:_setDynamicText()
	if self.m_nTabIndex == 1 then 
		GetElement(self.m_root, "txtBottom3_WndNewCuteList", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[19])
		GetElement(self.m_root, "txtBottom4_WndNewCuteList", WZUILabelTTF):setText(string.format(LocalStrings.FOURSTAR_TEXT28, 100))
		GetElement(self.m_root, "txtTop3_WndNewCuteList", WZUILabelTTF):setText(LocalStrings.GOPHERBALL_TEXT1[18])
	else
		GetElement(self.m_root, "txtBottom3_WndNewCuteList", WZUILabelTTF):setText(LocalStrings.KING_RANK_MY_SCORE)
		GetElement(self.m_root, "txtBottom4_WndNewCuteList", WZUILabelTTF):setText(string.format(LocalStrings.FOURSTAR_TEXT28, 100))
		GetElement(self.m_root, "txtTop3_WndNewCuteList", WZUILabelTTF):setText(LocalStrings.INTEGRATION)
	end
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndNewCuteList:_adaptLanguage_vn()
	GetElement(self.m_root, "txtBottom3_WndNewCuteList", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.2,0.048))
end

-------------------------------------语言适配End----------------------------------------
