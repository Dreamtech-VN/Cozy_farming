--WndDazzleHistory.lua
--@brief	WndDazzleHistory的UI模块
--@date		2023/03/24
--@author	XTX
--@note		耀眼榜活动-历届榜首界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDazzleHistory:onEnter(element)
	self.m_root = element

	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetHistoryRankResult,self.onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_WorshipHistoryRankResult,self.worshipOK,self)
	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDazzleHistory:onExit(element)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetHistoryRankResult,self.onGetOtherData,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_WorshipHistoryRankResult,self.worshipOK,self)

	self:_unInit()
end

--@brief    onenter函数已执行
function WndDazzleHistory:onEnterTransitionDidFinish(element)
    WZLog("WndDazzleHistory:onEnterTransitionDidFinish")
    GetElement(self.m_root, "txtTitle_WndDazzleHistory", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[9])
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingTopList(self.m_nActivityId, self.m_nTabIndex)
end

--@brief    关闭窗口
function WndDazzleHistory:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击切换标签回调
function WndDazzleHistory:onClickTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

	local nTag = element:getTag()
	if nTag == self.m_nTabIndex then return end 
	self.m_nTabIndex = nTag 
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingTopList(self.m_nActivityId, self.m_nTabIndex)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化静态文本
function WndDazzleHistory:_initStaticText()
	GetElement(self.m_root, "txtCheck1_WndDazzleHistory", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[7])
	GetElement(self.m_root, "txtCheckSel1_WndDazzleHistory", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[7])
	GetElement(self.m_root, "txtCheck2_WndDazzleHistory", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[8])
	GetElement(self.m_root, "txtCheckSel2_WndDazzleHistory", WZUILabelTTF):setText(LocalStrings.DAZZLERANK_TEXT1[8])
end




-------------------------------------私有方法模块End----------------------------------------

function WndDazzleHistory:_adaptLanguage_vn()
	GetElement(self.m_root, "txtCheck1_WndDazzleHistory", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtCheckSel1_WndDazzleHistory", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtCheck2_WndDazzleHistory", WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root, "txtCheckSel2_WndDazzleHistory", WZUILabelTTF):setScale(0.6)
end
