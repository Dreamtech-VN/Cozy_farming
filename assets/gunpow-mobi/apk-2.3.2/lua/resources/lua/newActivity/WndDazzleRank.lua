--WndDazzleRank.lua
--@brief	WndDazzleRank的UI模块
--@date		2023/03/23
--@author	XTX
--@note		耀眼榜活动主界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDazzleRank:onEnter(element)
	self.m_root = element

	ProtocolProcessorFestivalActivity:regAll6()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDazzleRank:onExit(element)
	ProtocolProcessorFestivalActivity:unregAll6()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self.GetActivityInfoOK,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)

	self:_unInit()
	LoadNewActivityRes(false)
end

--@brief    onenter函数已执行
function WndDazzleRank:onEnterTransitionDidFinish(element)
    WZLog("WndDazzleRank:onEnterTransitionDidFinish")
    self:_initStaticText()

	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7071, 7071)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7071, self.m_nTabIndex)
end

--@brief    关闭窗口
function WndDazzleRank:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮回调
function WndDazzleRank:onRuleClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
 
    WndSingleMapDesc:showInterface1(LocalStrings.DAZZLERANK_TEXT2, false, 1) 
end

function WndDazzleRank:onBtnRole()
	if not self.m_tRoleData then return end

	WndCheckOther:show(self.m_tRoleData.playerId)
end

--@brief 	点击切换标签
function WndDazzleRank:onClickTab(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = element:getTag()
    if self.m_nTabIndex == nTag then return end 

    self.m_nTabIndex = nTag 
    self:_setDynamicText()
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7071, self.m_nTabIndex)
end

--@brief 	点击历届榜按钮回调
function WndDazzleRank:onClickHistory(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndDazzleHistory:showInterface(self.m_nActivityId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化静态文本
function WndDazzleRank:_initStaticText()
	GetElement(self.m_root, "txtCheckBox1_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[1])
	GetElement(self.m_root, "txtCheckBoxSel1_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[1])
	GetElement(self.m_root, "txtCheckBox2_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[2])
	GetElement(self.m_root, "txtCheckBoxSel2_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[2])
	GetElement(self.m_root, "txtHistoryFirst_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[9])

	self:_setDynamicText()
end

--@brief 	设置动态文本
function WndDazzleRank:_setDynamicText()
	if self.m_nTabIndex == 1 then 
		GetElement(self.m_root, "txtBottom3_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[5])
		GetElement(self.m_root, "txtBottom4_WndDazzleRank", WZUILabelTTF):setText(string.format(LocalStrings.FOURSTAR_TEXT28, 100))
		GetElement(self.m_root, "txtTop3_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[3])
	else
		GetElement(self.m_root, "txtBottom3_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[6])
		GetElement(self.m_root, "txtBottom4_WndDazzleRank", WZUILabelTTF):setText(string.format(LocalStrings.FOURSTAR_TEXT28, 100))
		GetElement(self.m_root, "txtTop3_WndDazzleRank", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[4])
	end
end




-------------------------------------私有方法模块End----------------------------------------
