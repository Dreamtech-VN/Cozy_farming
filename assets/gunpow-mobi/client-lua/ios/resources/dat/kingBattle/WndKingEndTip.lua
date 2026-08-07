--WndKingEndTip.lua
--@brief	WndKingEndTip的UI模块
--@date		2015/5/12
--@author	Zjh
--@note

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKingEndTip:onEnter(element)
	self.m_root = element

	self:_updateUI_static_txt()
	self:_testInit()
	self:_updateUI_dynamic()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKingEndTip:onExit(element)
	self:_unInit()
end

function WndKingEndTip:onSure(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local scene = SceneKingEntrance:createElement()
	replaceScene(scene)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndKingEndTip:_testInit()

	self.m_nBattleTimes = 50
	self.m_nWinTimes = 25

	self.m_nMaxWinningStreak = 15
	self.m_nTodayScore = 999
	self.m_nTodayMoney = 391
	self.m_nKingRank = 21
end

function WndKingEndTip:_updateUI_dynamic()
	GetElement(self.m_root,"txtResultC_WndKingEndTip"  			,WZUIFreeTextBox):setShowText(string.format([[
	<T C="0,255,0" S="22">%d</T>
	<T C="255,255,255" S="22">战 </T>
	<T C="0,255,0" S="22">%d</T>
	<T C="255,255,255" S="22">胜</T>]] ,self.m_nBattleTimes, self.m_nWinTimes))
	GetElement(self.m_root,"txtMaxWinningStreakC_WndKingEndTip" ,WZUIFreeTextBox):setShowText(string.format([[
	<T C="0,255,0" S="22">%d</T>
	<T C="255,255,255" S="22">场</T>]] ,self.m_nMaxWinningStreak))
	GetElement(self.m_root,"txtTodayScoreC_WndKingEndTip"  		,WZUIFreeTextBox):setShowText(string.format([[
	<T C="0,255,0" S="22">%d</T>
	<T C="255,255,255" S="22">分</T>]] ,self.m_nTodayScore))
	GetElement(self.m_root,"txtTodayMoneyC_WndKingEndTip"  		,WZUIFreeTextBox):setShowText(string.format([[
	<T C="0,255,0" S="22">%d</T>
	<T C="255,255,255" S="22">个</T>]] ,self.m_nTodayMoney))
	GetElement(self.m_root,"txtKingRankC_WndKingEndTip"  		,WZUIFreeTextBox):setShowText(string.format([[
	<T C="255,255,255" S="22">第</T>
	<T C="0,255,0" S="22"> %d </T>
	<T C="255,255,255" S="22">名</T>]] ,self.m_nKingRank))
	
	GetElement(self.m_root,"conDetail_WndKingEndTip"):setVisible(true)
end

function WndKingEndTip:_updateUI_static_txt()
	GetElement(self.m_root, "txtTitle_WndKingEndTip"			,WZUILabelTTF):setText( LocalStrings.KING_END )
	GetElement(self.m_root,"txtSubTitle_WndKingEndTip"			,WZUILabelTTF):setText( LocalStrings.KING_END_TODAY )

	GetElement(self.m_root,"txtResult_WndKingEndTip"			,WZUILabelTTF):setText( LocalStrings.KING_END_BATTLE_RESULT )
	GetElement(self.m_root,"txtMaxWinningStreak_WndKingEndTip"	,WZUILabelTTF):setText( LocalStrings.KING_END_HIGHEST_WINNING_STREAK )
	GetElement(self.m_root,"txtTodayScore_WndKingEndTip"		,WZUILabelTTF):setText( LocalStrings.KING_END_TODAY_SCORE )
	GetElement(self.m_root,"txtTodayMoney_WndKingEndTip"		,WZUILabelTTF):setText( LocalStrings.KING_END_TODAY_MONEY )
	GetElement(self.m_root,"txtKingRank_WndKingEndTip"			,WZUILabelTTF):setText( LocalStrings.NOW_RANK )
	GetElement(self.m_root,"txtSure_WndKingEndTip"  			,WZUILabelTTF):setText( LocalStrings.CONFIRM)

end
-------------------------------------私有方法模块End----------------------------------------
