--SceneKingEntrance.lua
--@brief	SceneKingEntrance 的UI模块
--@date		2015/05/06
--@author	Zjh
--@note		弹王入口界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneKingEntrance:onEnter(element)

    WZLog("SceneKingEntrance:onEnter")
	self.m_root = element
	
	ProtocolProcessorSceneKing:regAll()

	self:_updateUI_static_txt()
	self:_testInit()
	self:_updateUI_dynamic()

	self.m_root:enableSchedule("update",0)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneKingEntrance:onExit(element)
    WZLog("SceneKingEntrance:onExit")
	ProtocolProcessorSceneKing:unregAll()
	
	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief	关闭按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingEntrance:onClose(element)
    WZLog("SceneKingEntrance:onClose")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local sceneCity = SceneCity:createElement()
	replaceScene(sceneCity)
end

--@brief	关于按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingEntrance:onAbout(element)
    WZLog("SceneKingEntrance:onAbout")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self:_showAbout()
end

--@brief	弹王名人按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingEntrance:onFamousKing(element)
    WZLog("SceneKingEntrance:onFamousKing")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wnd = WndKingFamous:createElement()
	WindowManager:addWindow(wnd, WndKingFamous)
end

--@brief	积分排名按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingEntrance:onRank(element)
    WZLog("SceneKingEntrance:onRank")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wnd = WndKingRank:createElement()
	WindowManager:addWindow(wnd, WndKingRank)
end

--@brief	查看奖励按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingEntrance:onShowAward(element)
    WZLog("SceneKingEntrance:onShowAward")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wnd = WndKingShowAward:createElement()
	WindowManager:addWindow(wnd, WndKingShowAward)
end

--@brief	商城按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingEntrance:onShop(element)
    WZLog("SceneKingEntrance:onShop")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local wnd = WndKingShop:createElement()
	WindowManager:addWindow(wnd, WndKingShop)
end

--@brief	参与战斗按钮回调
--@param	element:表绑定的UI节点引用
function SceneKingEntrance:onJoinBattle(element)
    WZLog("SceneKingEntrance:onJoinBattle")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local scene = SceneKingMain:createElement()
	replaceScene(scene)
end

function SceneKingEntrance:onAboutBg(element)
    WZLog("SceneKingEntrance:onAboutBg")
	element:getParent():removeFromParentAndCleanup(true)
end

--每帧更新函数
function SceneKingEntrance:update(element,dt)
	self.m_nRestTime = self.m_nRestTime - dt
	self:_checkTime()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function SceneKingEntrance:_updateUI_static_txt()

	GetElement(self.m_root,"txtFamousButton_SceneKingEntrance",WZUILabelTTF):setText( LocalStrings.KING_FAMOUS )
	GetElement(self.m_root,"txtRankButton_SceneKingEntrance"  ,WZUILabelTTF):setText( LocalStrings.KING_SCORE_RANK )
	GetElement(self.m_root,"txtAwardButton_SceneKingEntrance" ,WZUILabelTTF):setText( LocalStrings.CHECK_REWARD )
	GetElement(self.m_root,"txtShopButton_SceneKingEntrance"  ,WZUILabelTTF):setText( LocalStrings.KING_SHOP )
	
	GetElement(self.m_root,"txtMoneyTitle_SceneKingEntrance"  ,WZUILabelTTF):setText( LocalStrings.KING_MONEY.."：" )
	GetElement(self.m_root,"txtScoreTitle_SceneKingEntrance"  ,WZUILabelTTF):setText( LocalStrings.KING_SEASONSCORE )
	GetElement(self.m_root,"txtRankTitle_SceneKingEntrance"   ,WZUILabelTTF):setText( LocalStrings.KING_SEASONRANK )
	
	GetElement(self.m_root,"txtJoinBattle_SceneKingEntrance"  ,WZUILabelTTF):setText( LocalStrings.KING_JOIN_BATTLE )
end

function SceneKingEntrance:_updateUI_dynamic()

	local tempElement = nil
	
	GetElement(self.m_root,"txtMoneyTitle_SceneKingEntrance"	):setVisible(true)
	GetElement(self.m_root,"txtScoreTitle_SceneKingEntrance"	):setVisible(true)
	GetElement(self.m_root,"txtRankTitle_SceneKingEntrance"		):setVisible(true)
	
	tempElement = GetElement(self.m_root,"txtMoney_SceneKingEntrance",WZUILabelTTF)
	tempElement:setText( self.m_nKingMoney )
	tempElement:setVisible(true)

	tempElement = GetElement(self.m_root,"txtScore_SceneKingEntrance",WZUILabelTTF)
	tempElement:setText( self.m_nKingScore )
	tempElement:setVisible(true)

	tempElement = GetElement(self.m_root,"txtRank_SceneKingEntrance" ,WZUILabelTTF)
	tempElement:setText( self.m_nKingRank )
	tempElement:setVisible(true)

	self:_updateOpenStatus()
end

--更新时间
function SceneKingEntrance:_checkTime()
	if self.m_nRestTime < 0 then
		if self.m_bStart == false then
			self.m_bStart = true
			self.m_nRestTime = self.m_nNextCloseTime
		else
			self.m_bStart = false
			self.m_nRestTime = self.m_nNextStartTime
		end
		self:_updateOpenStatus()
		return
	end

	local tempElement = GetElement(self.m_root,"txtRestTime_SceneKingEntrance" ,WZUILabelTTF)
	tempElement:setText( self:_getRestTimeFormat() )
end

--将剩余时间转成可视化格式
function SceneKingEntrance:_getRestTimeFormat()
	local restTime = math.floor(self.m_nRestTime)

	local nHour = math.floor(restTime/3600)
    local nMinute = math.floor(math.mod(restTime, 3600)/60)
    local nSecond = math.mod(restTime, 60)
    return string.format("%02d:%02d:%02d", nHour, nMinute, nSecond)
end

function SceneKingEntrance:_updateOpenStatus()

	local tempElement = nil

	if self.m_bStart == false then
		tempElement = GetElement(self.m_root,"txtRestTimeTitle_SceneKingEntrance",WZUILabelTTF)
		tempElement:setText( LocalStrings.KING_REST_OPEN_TIME )
		tempElement:setVisible(true)

		tempElement = GetElement(self.m_root,"txtRestTime_SceneKingEntrance" ,WZUILabelTTF)
		tempElement:setText( self:_getRestTimeFormat() )
		tempElement:setVisible(true)

		tempElement = GetElement(self.m_root,"txtOpenTime_SceneKingEntrance",WZUIFreeTextBox)
		tempElement:setShowText( LocalStrings.KING_BATTLE_OPENTIME )
		tempElement:setVisible(true)

		tempElement = GetElement(self.m_root,"conJoinBattle_SceneKingEntrance")
		tempElement:setVisible(false)
	else
		tempElement = GetElement(self.m_root,"txtRestTimeTitle_SceneKingEntrance",WZUILabelTTF)
		tempElement:setText( LocalStrings.KING_REST_CLOSE_TIME )
		tempElement:setVisible(true)

		tempElement = GetElement(self.m_root,"txtRestTime_SceneKingEntrance" ,WZUILabelTTF)
		tempElement:setText( self:_getRestTimeFormat() )
		tempElement:setVisible(true)

		tempElement = GetElement(self.m_root,"txtOpenTime_SceneKingEntrance")
		tempElement:setVisible(false)

		tempElement = GetElement(self.m_root,"conJoinBattle_SceneKingEntrance")
		tempElement:setVisible(true)
	end
end

function SceneKingEntrance:_showAbout()
	local wnd = WZUIWindow:create()
	wnd:setVisible(false)

	--接收点击事情
	local img = WZUIImage:create()
	img:setFile("ui/common/transparent_bg.png")
	img:setLuaTouchBeganFunction("onAboutBg")
	wnd:addChild(img)

	local uiCon = WZUIContainer:create()
	uiCon:setShowAll(true)
	uiCon:setAnchorPoint(GlobalMethod:ccp(1,1))

	local TOP_HEIGHT = 40
	local BOTTOM_WIDTH = 460

	--[[local introText = WZUIFreeTextBox:create()
	introText:setMaxWidth(BOTTOM_WIDTH)
	introText:setAnchorPointLuaTo(0,0)
	introText:setRelativePositionLuaTo(0,0)
	local sText = string.format( <T C="255,255,255" S="20">%s</T> , LocalStrings.SINGLEMAP_DESC  )
	introText:setShowText(sText)
	uiCon:addChild(introText)]]
	local introText = WZUILabelTTF:create()
	introText:setDimensions(GlobalMethod:CCSize(BOTTOM_WIDTH,0))
	introText:setAnchorPointLuaTo(0,0)
	introText:setRelativePositionLuaTo(0,0)
	introText:setColor(GlobalMethod:ccc3(255,255,255))
	introText:setFontSize(20)
	introText:setAlignment(kCCTextAlignmentLeft)
	introText:setText(LocalStrings.SINGLEMAP_DESC)
	uiCon:addChild(introText)
	wnd:addChild(uiCon)
	self.m_root:addChild(wnd)

	--高度计算
	local height = introText:getContentSize().height
	uiCon:setContentSize(CCSize( BOTTOM_WIDTH , height + TOP_HEIGHT ))
	
	--背景
	local image = WZUI9Image:create()
	image:setScale(1.1)
	image:setFile("ui/kingBattle/307.png")
	uiCon:addChild(image,-1)

	--标题
	local topCon = WZUIContainer:create()
	topCon:setAnchorPointLuaTo(0.5,1)
	topCon:setRelativePositionLuaTo(0.5,1)
	topCon:setAbsContentSize(CCSize( BOTTOM_WIDTH , TOP_HEIGHT ))
	topCon:setUseAbsSize(true)
	uiCon:addChild(topCon)

	local title = WZUILabelTTF:create()
	title:setFontSize(24)
	title:setColor(GlobalMethod:ccc3(255,238,144))
	title:setText( LocalStrings.KING_BATTLE_INTRODUCE )
	topCon:addChild(title)

	local sender = GetElement(self.m_root,"btnAbout_SceneKingEntrance")
	if sender then
		point = sender:getParent():convertToWorldSpace(GlobalMethod:ccp(sender:getPosition()))

		point = uiCon:getParent():convertToNodeSpace(point)
	end
	uiCon:setPosition(point.x - 50,point.y - 50)

	wnd:setVisible(true)
end

function SceneKingEntrance:_testInit()
	self.m_nKingScore = 123456
	self.m_nKingMoney = 391
	self.m_nKingRank = 21
	self.m_bStart = false
	self.m_nRestTime = 1
	self.m_nNextStartTime = 100
	self.m_nNextCloseTime = 220
end
-------------------------------------私有方法模块End----------------------------------------
