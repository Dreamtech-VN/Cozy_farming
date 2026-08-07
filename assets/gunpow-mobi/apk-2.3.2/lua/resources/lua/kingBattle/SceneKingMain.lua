--SceneKingMain.lua
--@brief	SceneKingMain 的UI模块
--@date		2015/05/08
--@author	Zjh
--@note		弹王界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneKingMain:onEnter(element)

    WZLog("SceneKingMain:onEnter")
	self.m_root = element

	ProtocolProcessorSceneKing:regAll()

	self:_initUI()
	self:_testInit()
	self:_updateUI_dynamic()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneKingMain:onExit(element)
    WZLog("SceneKingMain:onExit")
	ProtocolProcessorSceneKing:unregAll()

	self:_unInit()
end

--@brief	关闭按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onClose(element)
    WZLog("SceneKingMain:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local sceneCity = SceneCity:createElement()
	replaceScene(sceneCity)
end

--@brief	弹王名人按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onFamousKing(element)
    WZLog("SceneKingMain:onFamousKing")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wnd = WndKingFamous:createElement()
	WindowManager:addWindow(wnd, WndKingFamous)
end

--@brief	积分排名按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onRank(element)
    WZLog("SceneKingMain:onRank")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wnd = WndKingRank:createElement()
	WindowManager:addWindow(wnd, WndKingRank)
end

--@brief	查看奖励按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onShowAward(element)
    WZLog("SceneKingMain:onShowAward")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wnd = WndKingShowAward:createElement()
	WindowManager:addWindow(wnd, WndKingShowAward)
end

--@brief	商城按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onShop(element)
    WZLog("SceneKingMain:onShop")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wnd = WndKingShop:createElement()
	WindowManager:addWindow(wnd, WndKingShop)
end

--@brief	开始战斗按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onBattle(element)
    WZLog("SceneKingMain:onBattle")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:startMatch()
end

--@brief	今日奖励按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onShowDayAward(element)
    WZLog("SceneKingMain:onShowDayAward")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:_showDayAward()
end

--@brief	终止匹配按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onStopMatch(element)
    WZLog("SceneKingMain:onStopMatch")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:stopMatch()
end

--@brief	取消匹配按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onCancelMatch(element)
    WZLog("SceneKingMain:onCancelMatch")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:stopMatch()
end

--@brief	重新匹配按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingMain:onMatchAgain(element)
    WZLog("SceneKingMain:onMatchAgain")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:startMatch()
end

function SceneKingMain:onDayAwardBg(element)
    WZLog("SceneKingMain:onDayAwardBg")
	element:getParent():removeFromParentAndCleanup(true)
end

function SceneKingMain:onBuyTimes(element)
    WZLog("SceneKingMain:onBuyTimes")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:buyTimesSuccess()
end

--@brief	开始匹配
function SceneKingMain:startMatch()
    WZLog("SceneKingMain:startMatch")

	--设置最大匹配时间
	self.m_nWaitTime = self.MAX_WAIT_TIME

	--UI配置
	self:_MatchStartUI()

	local conMatch = GetElement(self.m_root,"conMatching_SceneKingMain")
	conMatch:enableSchedule("updateWaitTime",0)
	conMatch:setVisible(true)
end

--@brief	停止匹配
function SceneKingMain:stopMatch()
	local conMatch = GetElement(self.m_root,"conMatching_SceneKingMain")
	conMatch:disableSchedule()
	conMatch:setVisible(false)
end

--@brief	购买次数
function SceneKingMain:buyTimesSuccess()
    WZLog("SceneKingMain:buyTimesSuccess")

	self.m_nRestTimes = self.m_nMaxTimes
	self:_updateRestTimes()
end

--@brief	更新匹配时间
function SceneKingMain:updateWaitTime(element,dt)

	self.m_nWaitTime = self.m_nWaitTime - dt

	if self.m_nWaitTime > 0 then
		--更新UI时间
		GetElement(element,"txtWaitTime_SceneKingMain",WZUILabelAtlasFont):setText(string.format("%02d",math.ceil(self.m_nWaitTime)))
	else
		self:_MatchTimeOutUI()
		element:disableSchedule()
	end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function SceneKingMain:_initUI()
	self:_updateUI_static_txt()

	--底部菜单
	local wndBottomBar,wndBottomBarObj = WndBottomBar:createElement()
    GetElement(self.m_root,"conUI_SceneKingMain"):addChild(wndBottomBar)
    wndBottomBarObj:setNeedMoveVerticalBar(true)

    --初始化玩家财富
    local playerGold = GetElementWithoutAssert(self.m_root, "CellGold")
    if playerGold == nil then
       local playerGoldElement, tPlayerGold = CellGold:createElement()
	   GetElement(self.m_root, "conGold_SceneKingMain", WZUIContainer):addChild(playerGoldElement)
    end

	--玩家UI
	local tPlayerInfo = CacheCenter:getPlayerInfo()
	local conPlayer = CreatePlayerFigure( tPlayerInfo.sex , CacheCenter:getEquipmentList() )
	local con = GetElement(self.m_root, "conHero_SceneKingMain")
	con:addChild(conPlayer:getAnimNode())
	conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.16))
	--conPlayer:play("wait0",true)
	--[[do

		local tPlayerEquip = CacheCenter:getEquipmentList()
		local tEquip = ConvertEquipmentList(tPlayerEquip)
		local nSex = tPlayerInfo.sex
		local tWeaponInfo = nil
		local nPetId = nil

		if CacheCenter:hasPlayerPetInfo() then
			for k,v in pairs(CacheCenter:getPlayerPetInfo() ) do
				if v.isInUsed == true then
					nPetId = v.itemId
				end
			end

			if nPetId then
				nPetId = GDatatab_item["id_"..nPetId].animation_index_code
			end
		end

		local con = GetElement(self.m_root, "conHero_SceneKingMain")

		local anim = CreataAPlayerAnimation( nSex , tEquip , nil , tWeaponInfo , nPetId , nil , con)
		anim:setScale(1.2)
	end]]


	GetElement(self.m_root, "txtHeroName_SceneKingMain",WZUIFreeTextBox):setShowText(string.format([[
	<T C="255,238,144" S="20">Lv.%s   </T>
	<T C="255,255,255" S="20">%s</T>]] ,tPlayerInfo.level ,tPlayerInfo.name ))
end

function SceneKingMain:_updateUI_static_txt()

	GetElement(self.m_root,"txtTitle_SceneKingMain"			,WZUILabelTTF):setText( LocalStrings.KING_BATTLE)

	GetElement(self.m_root,"txtFamousButton_SceneKingMain"	,WZUILabelTTF):setText( LocalStrings.KING_FAMOUS )
	GetElement(self.m_root,"txtRankButton_SceneKingMain"  	,WZUILabelTTF):setText( LocalStrings.KING_SCORE_RANK)
	GetElement(self.m_root,"txtAwardButton_SceneKingMain" 	,WZUILabelTTF):setText( LocalStrings.CHECK_REWARD)
	GetElement(self.m_root,"txtShopButton_SceneKingMain"  	,WZUILabelTTF):setText( LocalStrings.KING_SHOP)


	GetElement(self.m_root,"txtBattle_SceneKingMain" 		,WZUILabelTTF):setText( LocalStrings.START_FIGHTING )

	GetElement(self.m_root,"txtBattleMatch_SceneKingMain"	,WZUILabelTTF):setText( LocalStrings.KING_BATTLE_MATCH_OTHER)
	GetElement(self.m_root,"txtStopMatch_SceneKingMain"		,WZUILabelTTF):setText( LocalStrings.KING_STOP )
	GetElement(self.m_root,"txtCancelMatch_SceneKingMain"	,WZUILabelTTF):setText( LocalStrings.CANCEL )
	GetElement(self.m_root,"txtMatchAgain_SceneKingMain"	,WZUILabelTTF):setText( LocalStrings.KING_GO_ON_MATCHING )
end

function SceneKingMain:_updateUI_dynamic()

	local tempElement = nil
	tempElement = GetElement(self.m_root,"txtScore_SceneKingMain",WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_SEASONSCORE..self.m_nKingScore)
	tempElement:setVisible(true)

	tempElement = GetElement(self.m_root,"txtRank_SceneKingMain" ,WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_SEASONRANK..self.m_nKingRank)
	tempElement:setVisible(true)

	tempElement = GetElement(self.m_root,"txtMoney_SceneKingMain",WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_MONEY.."："..self.m_nKingMoney)
	tempElement:setVisible(true)

	tempElement = GetElement(self.m_root,"txtResetDiamond_SceneKingMain",WZUILabelTTF)
	tempElement:setText( self.m_nResetDiamond )

	tempElement = GetElement(self.m_root,"txtSeasonResult_SceneKingMain",WZUIFreeTextBox)
	tempElement:setShowText(string.format( [[<T C="255,255,255" S="20">%s：</T>
	<T C="255,238,144" S="20">]]..LocalStrings.KING_RANK_BATTLERESULT..[[ (%s)</T>]],LocalStrings.QUALIFYING_SEASON ,self.m_nBattleTimes, self.m_nWinTimes , math.floor(100 * self.m_nWinTimes / self.m_nBattleTimes) .."%" ))
	if ProjConfig.LANGUAGE == "en" then
		tempElement:setShowText(string.format( [[<T C="255,255,255" S="20">%s：</T>
	<T C="255,238,144" S="20">]]..LocalStrings.KING_RANK_BATTLERESULT..[[ (%s)</T>]],LocalStrings.QUALIFYING_SEASON ,self.m_nWinTimes, self.m_nBattleTimes , math.floor(100 * self.m_nWinTimes / self.m_nBattleTimes) .."%" ))
	end
	
	tempElement:setVisible(true)

	self:_updateRestTimes()
	self:_updateTodayScore()
end

function SceneKingMain:_updateRestTimes()

	local tempElement = GetElement(self.m_root,"txtRestTimes_SceneKingMain",WZUIFreeTextBox)

	local timesColor = "255,238,144"

	if self.m_nRestTimes <= 0 then
		timesColor = "255,0,0"
	end

	tempElement:setShowText(string.format([[
	<T C="255,255,255" S="20">]]..LocalStrings.KING_REST_TIMES..[[：</T>
	<T C="%s" S="20">%s</T>]] , timesColor ,self.m_nRestTimes.."/"..self.m_nMaxTimes ))
	tempElement:setVisible(true)

	if self.m_nRestTimes > 0 then
		GetElement(self.m_root,"conBuyTimes_SceneKingMain"):setVisible(false)
	else
		GetElement(self.m_root,"conBuyTimes_SceneKingMain"):setVisible(true)
	end
end

function SceneKingMain:_updateTodayScore()

	local tempElement = GetElement(self.m_root,"txtTodayScore_SceneKingMain",WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_TODAY_SCORE..self.m_nTodayScore)
	tempElement:setVisible(true)


	tempElement = GetElement(self.m_root,"txtDayAward_SceneKingMain",WZUIFreeTextBox)
	for i=1,#self.m_tDayAward do

		local startRange = self.m_tDayAward[i].score[1][1]
		local endRange = self.m_tDayAward[i].score[1][2]

		if (startRange <= self.m_nTodayScore or startRange == -1 ) and (endRange > self.m_nTodayScore or endRange == -1 ) then
			local txt = [[<T P="1" C="0,255,0" S="24">(]]..LocalStrings.KING_WILL_AWARD..[[：</T>]]
			for j=1,#self.m_tDayAward[i].reward do
				local icon = GDatatab_item["id_"..self.m_tDayAward[i].reward[j][1]].icon
				local awardValue = self.m_tDayAward[i].reward[j][2]
				txt = txt..string.format( [[<I Z="0.4">%s</I><T P="1" C="0,255,0" S="24">%s</T>]] , icon , awardValue )
			end
			txt = txt..[[<T P="1" C="0,255,0" S="24">)</T>]]
			tempElement:setShowText(txt)
		end
	end
end

function SceneKingMain:_MatchStartUI()
	local parent = GetElement(self.m_root,"conMatching_SceneKingMain")

	local tempElement
	GetElement(parent,"txtMatchTip_SceneKingMain",WZUILabelTTF):setText( LocalStrings.KING_MATCHING )
	GetElement(parent,"txtWaitTime_SceneKingMain",WZUILabelAtlasFont):setText(string.format("%02d",math.ceil(self.m_nWaitTime)))
	GetElement(parent,"conStopMatch_SceneKingMatch"):setVisible(true)
	GetElement(parent,"conCancelMatch_SceneKingMain"):setVisible(false)
	GetElement(parent,"conMatchAgain_SceneKingMain"):setVisible(false)

end

function SceneKingMain:_MatchTimeOutUI()
	local parent = GetElement(self.m_root,"conMatching_SceneKingMain")

	GetElement(parent,"txtMatchTip_SceneKingMain",WZUILabelTTF):setText( LocalStrings.KING_NO_MATCH )
	GetElement(parent,"txtWaitTime_SceneKingMain",WZUILabelAtlasFont):setText("00")
	GetElement(parent,"conStopMatch_SceneKingMatch"):setVisible(false)
	GetElement(parent,"conCancelMatch_SceneKingMain"):setVisible(true)
	GetElement(parent,"conMatchAgain_SceneKingMain"):setVisible(true)
end

function SceneKingMain:_showDayAward()
	local wnd = WZUIWindow:create()
	wnd:setVisible(false)

	--接收点击事情
	local img = WZUIImage:create()
	img:setFile("ui/common/transparent_bg.png")
	img:setLuaTouchBeganFunction("onDayAwardBg")
	wnd:addChild(img)

	local uiCon = WZUIContainer:create()
	uiCon:setShowAll(true)
	uiCon:setAnchorPoint(GlobalMethod:ccp(0.5,1))

	--背景
	local image = WZUI9Image:create()
	image:setScale(1.18)
	image:setFile("ui/kingBattle/307.png")
	uiCon:addChild(image)

	local TOP_HEIGHT = 40
	local LEFT_WIDTH = 135
	local RIGHT_WIDTH = 200

	--标题
	local topCon = WZUIContainer:create()
	topCon:setAnchorPointLuaTo(0.5,1)
	topCon:setRelativePositionLuaTo(0.5,1)
	topCon:setAbsContentSize(CCSize( LEFT_WIDTH + RIGHT_WIDTH , TOP_HEIGHT ))
	topCon:setUseAbsSize(true)
	uiCon:addChild(topCon)

	local title = WZUILabelTTF:create()
	title:setFontSize(24)
	title:setColor(GlobalMethod:ccc3(255,238,144))
	title:setText( LocalStrings.KING_DAYAWARD_TITLE )
	topCon:addChild(title)

	--积分范围
	local leftText = WZUIFreeTextBox:create()
	leftText:setMaxWidth(LEFT_WIDTH)
	leftText:setAnchorPointLuaTo(0,0)
	leftText:setRelativePositionLuaTo(0,0)
	local sLeft = ""
	for i=1,#self.m_tDayAward do

		local startRange = self.m_tDayAward[i].score[1][1]
		local endRange = self.m_tDayAward[i].score[1][2]

		local rangeTxt = LocalStrings.INTEGRATION
		if startRange~=-1 and endRange~=-1 then
			rangeTxt =  startRange.."~"..endRange..rangeTxt
		elseif startRange~=-1 then
			rangeTxt =  startRange.."+"..rangeTxt
		end

		sLeft = sLeft..string.format( [[<T C="255,255,255" S="20">%s</T>]] , rangeTxt  )

		sLeft = sLeft.."<BR/>"
	end
	leftText:setShowText(sLeft)
	uiCon:addChild(leftText)

	--奖励
	local rightText = WZUIFreeTextBox:create()
	rightText:setMaxWidth(RIGHT_WIDTH)
	rightText:setAnchorPointLuaTo(1,0)
	rightText:setRelativePositionLuaTo(1,0)
	local sRight = ""
	for i=1,#self.m_tDayAward do
		for j=1,#self.m_tDayAward[i].reward do
			local name = GDatatab_item["id_"..self.m_tDayAward[i].reward[j][1]].name
			local awardValue = self.m_tDayAward[i].reward[j][2]
			sRight = sRight..string.format( [[<T C="255,238,144" S="20">%s%s  </T>]] , awardValue ,name  )
		end
		sRight = sRight.."<BR/>"
	end
	rightText:setShowText(sRight)
	uiCon:addChild(rightText)

	--高度计算
	local height = math.max(leftText:getContentSize().height , rightText:getContentSize().height)
	uiCon:setAbsContentSize(CCSize( LEFT_WIDTH + RIGHT_WIDTH , height + TOP_HEIGHT ))
	uiCon:setUseAbsSize(true)
	wnd:addChild(uiCon)

	self.m_root:addChild(wnd)

	local sender = GetElement(self.m_root,"btnShowDayAward_SceneKingMain")
	if sender then
		point = sender:getParent():convertToWorldSpace(GlobalMethod:ccp(sender:getPosition()))

		point = uiCon:getParent():convertToNodeSpace(point)
	end
	uiCon:setPosition(point.x - 35,point.y - 35)

	wnd:setVisible(true)
end

function SceneKingMain:_testInit()

	self.m_nKingScore = 123456
	self.m_nKingMoney = 391
	self.m_nKingRank = 21

	self.m_nRestTimes = 0
	self.m_nMaxTimes = 10

	self.m_nBattleTimes = 50
	self.m_nWinTimes = 25

	self.m_nTodayScore = 145

	self.m_tDayAward = {}
	for i,v in pairs(GDatatab_king_day_reward) do
		self.m_tDayAward[v.id] = v
	end

	self.m_nResetDiamond = 20

end
-------------------------------------私有方法模块End----------------------------------------
