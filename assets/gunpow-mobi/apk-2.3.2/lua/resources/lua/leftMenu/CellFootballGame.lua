--CellFootballGame.lua
--@brief	CellFootballGame的UI模块
--@date		2018/05/16
--@author	peiting_mao
--@note		点球大战


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFootballGame:onEnter(element)
	self.m_root = element
	--注册缓存中心数据监听
    CacheCenter:registerUpatePlayerItemObserver(self)
    IS_FOOTBALL_RANK = false
    ProtocolProcessorWndRankList:send_RANK_GetFireworkRank(2)

	self.m_tLine = BattleOtherPointsLine:create(self:getFrontLayer(), 20, nil, nil, nil, nil, nil, nil, GlobalMethod:ccp(480,320), self, 
            {x1=0,x2=760,y1=10,y2=640}, {x1=700,x2=760,y1=30,y2=300})
    self.m_root:enableSchedule("loop",0)
    AdaptLanguage(self)
end

--@brief    发球成功
function CellFootballGame:shootOk()
	WZLog("CellFootballGame:shootOk")
	
	--self:onBtnKick()
end

--@brief    球未朝向球框发射时，发球失败
function CellFootballGame:shootFail()
	WZLog("CellFootballGame:shootFail")

	MsgBoxManager:showTipBox(LocalStrings.FOOTBALL_SHOOT_FAIL)
	--ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall(false)
	--ProtocolProcessorWndRankList:send_RANK_GetFireworkRank(2)
	--self:_updateCostItem()	
end

--@brief    射球出界
function CellFootballGame:shootOut(pos)
	WZLog("CellFootballGame:shootOut")

	local penaltyConfig = json.decode(CacheCenter:getGameParam()["penaltyConfig"])
	local failAddScore = penaltyConfig.failAddScore
	MsgBoxManager:showTipBox(string.format(LocalStrings.FOOTBALL1, failAddScore))
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ShootBall(false, WndFootballActivity.m_nPreResult)	
	ProtocolProcessorWndRankList:send_RANK_GetFireworkRank(2)
	self:_updateCostItem()

	self:_playerBack()	--人物回到原点
end

--@brief    射球进门
function CellFootballGame:shootIn(pos)
	WZLog("CellFootballGame:shootIn")
	self._monstPos = pos
	--MsgBoxManager:showTipBox("射球进门")
	self:getResult(WndFootballActivity.m_nPreResult)

	ProtocolProcessorWndRankList:send_RANK_GetFireworkRank(2)
	self:_updateCostItem()
end

--@brief    触摸面板Began回调
function CellFootballGame:onTouchBegan(element, point)
	WZLog("CellFootballGame:onTouchBegan")
	local conBall = GetElement(CellFootballGame.m_current.m_root,"conBall_CellFootballGame",WZUIContainer)
	if conBall:isVisible() then
    	if self.m_tLine then
        	self.m_tLine:onTouchBegan(element, point)
    	end
    end
end

--@brief    触摸面板Moved回调
function CellFootballGame:onTouchMoved(element, point)
	WZLog("CellFootballGame:onTouchMoved")
    if self.m_tLine then
        self.m_tLine:onTouchMoved(element, point)
    end
end

--@brief    触摸面板End回调
function CellFootballGame:onTouchEnd(element, point)
	if CacheCenter:getPlayerItemCountById(self.costId[1]) < tonumber(self.costNum[1]) then --需要消耗物品不足时弹出购买框
		for i = 1,#self.m_tLine.m_tPoints  do
			self.m_tLine.m_tPoints[i]:setVisible(false)
		end
		MsgBoxManager:showTipBox(LocalStrings.FOOTBALL_TEXT6)
	--	WndFastGetItems:show(self.costId[1])
		return
	end
    if self.m_tLine then
        self.m_tLine:onTouchEnd(element, point)
    end
end

--@brief    每帧调用
function CellFootballGame:loop()
    if self.m_tLine then
        self.m_tLine:loop()
    end
end

--@brief    获取前景Layer
function CellFootballGame:getFrontLayer()
    if self.m_root then
        local layer = GetElement(self.m_root,"conFrontLayer",WZUIContainer)
        return layer
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFootballGame:onExit(element)
	 --反注册缓存中心数据监听
    CacheCenter:unregisterUpatePlayerItemObserver(self)
    self.m_root:disableSchedule()
	self:_unInit()
end

function CellFootballGame:showWindow(  )
	local conRole = GetElement(CellFootballGame.m_current.m_root,"conRole_CellFootballGame",WZUIContainer)

	CellFootballGame.m_current.aniPlayer,self.animNode = self:_createPlayerFigure()
	if conRole ~= nil then
		conRole:addChild(self.animNode)
	end

	self:_recordPos()
end

--@brief	点击排行榜
function CellFootballGame:onClickRank( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	--发送协议
	IS_FOOTBALL_RANK = true
	ProtocolProcessorWndRankList:send_RANK_GetFireworkRank(2)
end

--@brief	人物动作
function CellFootballGame:_playerRun1(  )
	CellFootballGame.m_current.aniPlayer:play("run",true)

	local conPlayer = GetElement(CellFootballGame.m_current.m_root,"conPlayer_CellFootballGame",WZUIContainer)
	local move = WZUIActionMoveTo:create()
	move:setMoveX(CellFootballGame.m_current.pos.ballX-0.05)
	move:setMoveY(CellFootballGame.m_current.pos.ballY)
	move:setDuration(0.5)
	conPlayer:runUIAction(move)
end

--@brief	人物动作
function CellFootballGame:_playerRun2(  )
	CellFootballGame.m_current.aniPlayer:play("run",true)

	local conPlayer = GetElement(CellFootballGame.m_current.m_root,"conPlayer_CellFootballGame",WZUIContainer)
	local move = WZUIActionMoveTo:create()
	move:setMoveX(CellFootballGame.m_current.pos.playerX)
	move:setMoveY(CellFootballGame.m_current.pos.playerY)
	move:setDuration(0.5)
	conPlayer:runUIAction(move)
end

--@brief	人物踢球动作
function CellFootballGame:_playerKick(  )
	CellFootballGame.m_current.aniPlayer:play("kick",true)
end

--@brief	人物休息动作
function CellFootballGame:_playerWait(  )
	CellFootballGame.m_current.aniPlayer:play("wait0",true)
end

--@brief	射门时隐藏足球图片
function CellFootballGame:_isImgFalse(  )
	GetElement(CellFootballGame.m_current.m_root,"conBall_CellFootballGame",WZUIContainer):setVisible(false)
	CellFootballGame.m_current.m_tLine:buildBullet()
end

--@brief	射门时隐藏足球图片
function CellFootballGame:_isImgTrue(  )
	GetElement(CellFootballGame.m_current.m_root,"conBall_CellFootballGame",WZUIContainer):setVisible(true)
end

--@brief	点击踢球
function CellFootballGame:onBtnKick( )
	local conPlayer = GetElement(CellFootballGame.m_current.m_root,"conPlayer_CellFootballGame",WZUIContainer)
	local array = CCArray:create()
	array:addObject(CCCallFuncN:create(self._playerRun1))
	--array:addObject(CCDelayTime:create(1))
	array:addObject(CCCallFuncN:create(self._playerKick))
	array:addObject(CCDelayTime:create(0.5))
	array:addObject(CCCallFuncN:create(self._isImgFalse))
	array:addObject(CCDelayTime:create(0.2))
	array:addObject(CCCallFuncN:create(self._playerWait))

	local action = CCSequence:create(array)
	conPlayer:runAction(action)
end

function CellFootballGame:_createPlayerFigure(  )
	local sex = CacheCenter:getPlayerInfo().sex
	local tEquip = nil
	if tonumber(sex) == 0 then --男性
		--tEquip = {faceId, headId, bodyId, wingId, weaponId}
		tEquip = {4867, 4866, 4868, nil, nil}
	else
		--tEquip = {faceId, headId, bodyId, wingId, weaponId}
		tEquip = {4870, 4869, 4871, nil, nil}
	end
	
    local aniPlayer = CreatePlayerFigure(sex, tEquip, "wait0",nil,nil,nil,nil,nil,nil,nil,nil,nil)
    local animNode = aniPlayer:getAnimNode()

    return aniPlayer,animNode
end

--@brief	初始化界面
function CellFootballGame:_initUI(  )
	local txtCost = GetElement(CellFootballGame.m_current.m_root,"txtCost_CellFootballGame",WZUILabelTTF)

	local penaltyConfig = json.decode(CacheCenter:getGameParam()["penaltyConfig"])

	--WZLog("--gagads---454",Serialize(penaltyConfig))

	self.costId, self.costNum = SplitItemString(penaltyConfig.cost)
	
	local hasItemNum = CacheCenter:getPlayerItemCountById(self.costId[1])
	--WZLog("--dgagfa----",hasItemNum,self.costNum[1],#self.rankTop)
	if txtCost ~= nil then
 		txtCost:setText(self.costNum[1].."/"..hasItemNum)
 	end

    local sTxtColor = [[<T C="255,236,193" S="18" P="0">NO.%d </T><T C="255,236,193" S="18" P="0">%s </T><T C="5,180,0" S="18" P="0">%d</T>]]
   	local sMyColor = [[<T C="255,236,193" S="18" P="0">%s</T><T C="5,180,0" S="18" P="0">%d </T><T C="255,236,193" S="18" P="0">%s</T><T C="5,180,0" S="18" P="0">%s</T>]]
    
    if #self.rankTop > 0 then
    	for i=1,#self.rankTop do
    		GetElement(CellFootballGame.m_current.m_root,"fxtRank"..i.."_CellFootballGame",WZUIFreeTextBox):setShowText(string.format(sTxtColor,i,self.rankTop[i].name,tonumber(self.rankTop[i].score)))
    	end
    end

    local fxtMyRank = GetElement(CellFootballGame.m_current.m_root,"fxtMyRank_CellFootballGame",WZUIFreeTextBox)
    if self.myRank ~= -1 then
    	fxtMyRank:setShowText(string.format(sMyColor,LocalStrings.KING_RANK_MY_SCORE,self.myScore,LocalStrings.NEWLEAGUE1,tostring(self.myRank)))
    else
    	if self.myScore == nil then 
    		self.myScore = 0
    	end
    	fxtMyRank:setShowText(string.format(sMyColor,LocalStrings.KING_RANK_MY_SCORE,self.myScore,LocalStrings.NEWLEAGUE1,LocalStrings.NONE))
    end
end

--@brief 	更新玩家拥有的消耗物品个数
function CellFootballGame:_updateCostItem(  )
	local hasItemNum = CacheCenter:getPlayerItemCountById(self.costId[1])
	GetElement(CellFootballGame.m_current.m_root,"txtCost_CellFootballGame",WZUILabelTTF):setText(self.costNum[1].."/"..hasItemNum)
end

--@brief	记录角色，球，守门员的原始位置
function CellFootballGame:_recordPos(  )
	local conPlayer = GetElement(CellFootballGame.m_current.m_root,"conPlayer_CellFootballGame",WZUIContainer)
	local conBall = GetElement(CellFootballGame.m_current.m_root,"conBall_CellFootballGame",WZUIContainer)
	local conMonster = GetElement(CellFootballGame.m_current.m_root,"conMonster_CellFootballGame",WZUIContainer)
	self.pos.playerX = conPlayer:getRelativePosition().x
	self.pos.playerY = conPlayer:getRelativePosition().y

	self.pos.ballX = conBall:getRelativePosition().x
	self.pos.ballY = conBall:getRelativePosition().y

	self.pos.monsterX = conMonster:getRelativePosition().x
	self.pos.monsterY = conMonster:getRelativePosition().y
	--WZLog("--dgadg-----3-5555",Serialize(self.pos))
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellFootballGame:_adaptLanguage_vn(  )
	local txtCost = GetElement(CellFootballGame.m_current.m_root,"txtCost_CellFootballGame",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.663333,1))
end
-------------------------------------语言适配End-----------------------------------------