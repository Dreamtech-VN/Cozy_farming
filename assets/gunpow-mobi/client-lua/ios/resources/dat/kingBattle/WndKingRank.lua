--WndKingRank.lua
--@brief	WndKingRank的UI模块
--@date		2015/5/12
--@author	Zjh
--@note

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKingRank:onEnter(element)
	self.m_root = element

	ProtocolProcessorSceneKing:send_KING_GetRank( )

	self:_updateUI_static_txt()
end

----@brief onEnter函数执行完成回调
function WndKingRank:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndKingRank:actionCallback(element, data)
	--初始化界面
	--self:_testInit()
	--self:_updateUI_dynamic()
end

----@brief    获取根节点
function WndKingRank:getRoot()
	return self.m_root
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKingRank:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndKingRank:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndKingRank:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndKingRank:_testInit()
	self.m_tData = {}
	local tData
	tData = {m_nRank = 1 , m_sName = "弹弹岛数百年名人" , m_sServerName="S.2-霸气冲天" , m_nScore = 123456 , m_nBattleTimes="9999" , m_nWinTimes = "9999" }
	table.insert(self.m_tData,tData)
	tData = {m_nRank = 2 , m_sName = "弹弹岛数百年名人" , m_sServerName="S.2-霸气冲天" , m_nScore = 123456 , m_nBattleTimes="9999" , m_nWinTimes = "9998" }
	table.insert(self.m_tData,tData)
	tData = {m_nRank = 3 , m_sName = "弹弹岛数百年名人" , m_sServerName="S.2-霸气冲天" , m_nScore = 123456 , m_nBattleTimes="9999" , m_nWinTimes = "9990" }
	table.insert(self.m_tData,tData)
	tData = {m_nRank = 4 , m_sName = "弹弹岛数百年名人" , m_sServerName="S.2-霸气冲天" , m_nScore = 123456 , m_nBattleTimes="9999" , m_nWinTimes = "9989" }
	table.insert(self.m_tData,tData)
	tData = {m_nRank = 5 , m_sName = "弹弹岛数百年名人" , m_sServerName="S.2-霸气冲天" , m_nScore = 123456 , m_nBattleTimes="9999" , m_nWinTimes = "9980" }
	table.insert(self.m_tData,tData)
	tData = {m_nRank = 6 , m_sName = "弹弹岛数百年名人" , m_sServerName="S.2-霸气冲天" , m_nScore = 123456 , m_nBattleTimes="9999" , m_nWinTimes = "9899" }
	table.insert(self.m_tData,tData)
	tData = {m_nRank = 7 , m_sName = "弹弹岛数百年名人" , m_sServerName="S.2-霸气冲天" , m_nScore = 123456 , m_nBattleTimes="9999" , m_nWinTimes = "8999" }
	table.insert(self.m_tData,tData)
	tData = {m_nRank = 8 , m_sName = "弹弹岛数百年名人" , m_sServerName="S.2-霸气冲天" , m_nScore = 123456 , m_nBattleTimes="9999" , m_nWinTimes = "5999" }
	table.insert(self.m_tData,tData)


	self.m_nMyRank = 17

	self.m_nMyScore = 10000

	self.m_nBattleTimes = 50

	self.m_nWinTimes = 25
end

function WndKingRank:_updateUI_dynamic()
	self:_initTable()

	GetElement(self.m_root,"txtMyRank_WndKingRank"		,WZUILabelTTF):setText( LocalStrings.KING_RANK_MY_RANK..self.m_nMyRank)
	GetElement(self.m_root,"txtMyScore_WndKingRank"		,WZUILabelTTF):setText(self.m_nMyScore)
	GetElement(self.m_root,"txtMyResult_WndKingRank"	,WZUILabelTTF):setText( string.format( LocalStrings.KING_RANK_BATTLERESULT , self.m_nBattleTimes , self.m_nWinTimes))
	if ProjConfig.LANGUAGE == "en" then
		GetElement(self.m_root,"txtMyResult_WndKingRank",WZUILabelTTF):setText( string.format( LocalStrings.KING_RANK_BATTLERESULT , self.m_nWinTimes , self.m_nBattleTimes))
	end
end

function WndKingRank:_initTable()
	if self.m_tData and #self.m_tData>0 then
		local tabElement = GetElement(self.m_root,"tabRank_WndKingRank",WZUITableContainer)
		--默认显示十条
		for i=1,math.min(10,#self.m_tData) do
			local data = self.m_tData[i]
			local element = WZUISystem:getInstance():createElement("CellKingRank")
			element:setTag(i-1)
			tabElement:setCellElement(element)

			if data.m_nRank <= 5 then
				--GetElement(element,"imgBg1_CellKingRank"):setVisible(true)
			end

			GetElement(element,"txtContent1_CellKingRank",WZUILabelTTF):setText(data.m_nRank)
			GetElement(element,"txtContent2_CellKingRank",WZUILabelTTF):setText(data.m_sName)
			GetElement(element,"txtContent3_CellKingRank",WZUILabelTTF):setText(data.m_sServerName)
			GetElement(element,"txtContent4_CellKingRank",WZUILabelTTF):setText(data.m_nScore)
			GetElement(element,"txtContent5_CellKingRank",WZUILabelTTF):setText(string.format(LocalStrings.KING_RANK_BATTLERESULT,data.m_nBattleTimes,data.m_nWinTimes))
			if ProjConfig.LANGUAGE == "en" then
				GetElement(element,"txtContent5_CellKingRank",WZUILabelTTF):setText(string.format(LocalStrings.KING_RANK_BATTLERESULT,data.m_nWinTimes,data.m_nBattleTimes))
			end
		end
		tabElement:setVisible(true)
		GetElement(self.m_root,"txtEmpty_WndKingRank"):setVisible(false)
	else
		GetElement(self.m_root,"txtEmpty_WndKingRank"):setVisible(true)
		GetElement(self.m_root,"tabRank_WndKingRank"):setVisible(false)
	end
end

function WndKingRank:_updateUI_static_txt()
	local tempElement = nil

	tempElement = GetElement(self.m_root,"txtTitle_WndKingRank",WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_RANK_TITLE )

	tempElement = GetElement(self.m_root,"txtEmpty_WndKingRank",WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_RANK_NO_PLAYER )

	tempElement = GetElement(self.m_root,"txtSubTitle_WndKingRank",WZUIFreeTextBox)
	tempElement:setShowText( LocalStrings.KING_RANK_SUB_TITLE )

	local tabTitle = {
	LocalStrings.RANK,
	LocalStrings.PLAYER_NAME,
	LocalStrings.INVITE_SERVER,
	LocalStrings.INTEGRATION,
	LocalStrings.BATTLE_RESULT,
	}
	for i=1,#tabTitle do
		tempElement = GetElement(self.m_root,"txtTabTitle"..i.."_WndKingRank",WZUILabelTTF)
		tempElement:setText(tabTitle[i])
	end

	GetElement(self.m_root,"txtMyScoreName_WndKingRank"	,WZUILabelTTF):setText( LocalStrings.KING_RANK_MY_SCORE )
end
-------------------------------------私有方法模块End----------------------------------------
