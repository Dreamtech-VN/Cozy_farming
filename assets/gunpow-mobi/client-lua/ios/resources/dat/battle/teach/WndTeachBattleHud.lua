--WndTeachBattleHud.lua
--@brief	WndTeachBattleHud的UI模块
--@date		2013/2/24
--@author	Zjh
--@note		战斗教学Hud界面

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTeachBattleHud:onEnter(element)
	self.m_root = element

    --多语言版本界面适配
    AdaptLanguage(self)
    
	GetElement(self.m_root,"conMyHud_WndTeachBattleHud"):setRelativePosition(GlobalMethod:ccp(0.5,0.2))

	self:createAngerAnim()

	if PlatformInfo:getCurrentPlatform() == PlatformInfo.type.PLATFORM_WIN32 then
		--GetElement(self.m_root,"btnAddScale_WndTeachBattleHud"):setVisible(true)
		--GetElement(self.m_root,"btnMinusScale_WndTeachBattleHud"):setVisible(true)
	end
	
	self:initBossHead()
	
	self:setMyFlyEnable(bEnable)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTeachBattleHud:onExit(element)
	self:_unInit()
end

--Test
function WndTeachBattleHud:onAddScale()
	if SceneTeachBattle:getFrontLayer():getScale() + 0.05 <= 1.2 then
		SceneTeachBattle:getFrontLayer():setScale(SceneTeachBattle:getFrontLayer():getScale() + 0.05)
		SceneTeachBattle:getFrontLayer():setPosition(GlobalMethod:ccp(SceneTeachBattle:getFrontLayer():getPositionX()-0.05*SceneTeachBattle:getFrontLayer():getContentSize().width/2 , SceneTeachBattle:getFrontLayer():getPositionY()-0.05*SceneTeachBattle:getFrontLayer():getContentSize().height/2 ))
		BattleMapManager:getFrontControl():centerOnPoint(BattleMapManager:getFrontControl():getCurScreenCenter())
	end
end

--Test
function WndTeachBattleHud:onMinusScale()
	if SceneTeachBattle:getFrontLayer():getScale() - 0.05 >= 0.65 then
		SceneTeachBattle:getFrontLayer():setScale(SceneTeachBattle:getFrontLayer():getScale() - 0.05)
		SceneTeachBattle:getFrontLayer():setPosition(GlobalMethod:ccp(SceneTeachBattle:getFrontLayer():getPositionX()+0.05*SceneTeachBattle:getFrontLayer():getContentSize().width/2 , SceneTeachBattle:getFrontLayer():getPositionY()+0.05*SceneTeachBattle:getFrontLayer():getContentSize().height/2 ))
		BattleMapManager:getFrontControl():centerOnPoint(BattleMapManager:getFrontControl():getCurScreenCenter())
	end
end

------Fly

--@brief	获取飞行按钮
--@return	element:飞行按钮
--@note
function WndTeachBattleHud:getFlyButton()
	return GetElement(self.m_root,"btnFly_WndTeachBattleHud",WZUIButton)
end

--@brief	是否可点击Fly按钮
--@param	bEnable:是否可点击
--@note
function WndTeachBattleHud:setMyFlyEnable(bEnable)
	self:getFlyButton():setTouchEnable(bEnable)
end

--@brief	增加飞行引导效果
--@note
function WndTeachBattleHud:addFlyGuide()
	local img = self:getFlyButton()
	
	local img1 = WZUIImage:create()
	img1:setUseOriginSize(true)
	img1:setScale(1)
	img1:setFile("common/animation/fly_player_1_an.png")
	img1:setRelativePosition(GlobalMethod:ccp(0.525,0.56))
	img1:setTag(0)
	
	local actionFadeTo1 = WZUIActionFadeTo:create()
	actionFadeTo1:setOpacity(50)
	actionFadeTo1:setDuration(0.5)
	local actionFadeTo2 = WZUIActionFadeTo:create()
	actionFadeTo2:setOpacity(255)
	actionFadeTo2:setDuration(0.5)
	sequence = WZUIActionSequence:create()
	sequence:setIsLoop(true)

	sequence:setChildAction(actionFadeTo1)
	sequence:setChildAction(actionFadeTo2)

	img:addChild(img1,-1)
	img1:runUIAction(sequence)
	
end

--@brief	移除飞行道具引导效果
--@note
function WndTeachBattleHud:removeFlyGuide()
	local tSender = self:getFlyButton()
	local img = tSender:getChildByTag(0)
	if img then
		img:removeFromParentAndCleanup(true)
	end
end
------Wind

--@brief	是否显示风力
--@param	bVisible:是否可见
--@note
function WndTeachBattleHud:setWindVisible(bVisible)
	GetElement(self.m_root,"conWind_WndTeachBattleHud"):setVisible(bVisible)
end

--@brief	设置风力等级
--@param	tLevel:风力等级
--@note
function WndTeachBattleHud:setWindLevel(tLevel)
	local xLevel = tLevel.x
	if xLevel >= 0 then
		WZUIImage:luaTo(GetElement(self.m_root,"imgWind_WndTeachBattleHud")):setFlipX(false)
	else
		WZUIImage:luaTo(GetElement(self.m_root,"imgWind_WndTeachBattleHud")):setFlipX(true)
		xLevel = xLevel * -1
	end
	WZUILabelAtlasFont:luaTo(GetElement(self.m_root,"txtWind_WndTeachBattleHud")):setText(xLevel)
end

------MyHud

--@brief	是否显示MyHud
--@param	bVisible:是否显示
--@note
function WndTeachBattleHud:setMyHudShow(bVisible)
	local flip = bVisible
	GetElement(self.m_root,"conMyHud_WndTeachBattleHud"):stopAllActions()
	local moveTo = WZUIActionMoveTo:create()
	moveTo:setMoveX(0.5)
	if bVisible then
		moveTo:setMoveY(0.5)
	else
		moveTo:setMoveY(0.2)
	end
	moveTo:setDuration(0.25)
	moveTo:setFinishLuaFunction("showingMyHudEnd")
	moveTo:setFinishLuaTable(self)
	GetElement(self.m_root,"conMyHud_WndTeachBattleHud"):runUIAction(moveTo)
	self.m_bShowingMyHud = true
	self.m_bMyHudShow = bVisible
end

--@brief	MyHud动画播放是否结束
function WndTeachBattleHud:isShowingMyHudEnd()
	return not self.m_bShowingMyHud
end

--@brief	MyHud动画播放回调
function WndTeachBattleHud:showingMyHudEnd()
	self.m_bShowingMyHud = false
end
------BigSkill

--@brief	获取大招元素
--@return	element,大招元素
function WndTeachBattleHud:getBigSkillContainer()
	return GetElement(self.m_root,"conBigSkill_WndTeachBattleHud",WZUIContainer)
end

--@brief	创建怒气动画
--@note
function WndTeachBattleHud:createAngerAnim()
	self.m_angerAnim = BattleAnimation:createAnimation(IWCO_SHOPEFFICIENTS)
	self.m_angerAnim:addAnimation("vs2",{}, 0.2, true)
	local power = BattleAnimation:createAnimation(IWCO_SHOPEFFICIENTS)
	power:addAnimation("power",{}, 0.2, true)
	power:play("power",true)
	self.m_angerAnim:play("vs2",true)
	local node = self.m_angerAnim:getAnimNode()
	self.m_angerAnim:setPosition(GlobalMethod:ccp(60.5,0))
	power:setPosition(GlobalMethod:ccp(64,0))
	node:setVisible(false)
	node:addChild(power:getAnimNode())
	self:getBigSkillContainer():addChild(node)
end

--@brief	设置大招的百分率
--@param	nPer:大招的百分率
--@note
function WndTeachBattleHud:setBigSkillPer(nPer)
	WZUIProgress:luaTo(GetElement(self.m_root,"progBigSkill_WndTeachBattleHud")):setPercentage(nPer*0.75)
	if nPer >=100 then
		self.m_angerAnim:getAnimNode():setVisible(true)
	else
		self.m_angerAnim:getAnimNode():setVisible(false)
	end
end

--@brief	是否可点击大招按钮
--@param	bEnable:是否可点击
--@note
function WndTeachBattleHud:setBigSkillEnable(bEnable)
	self:getBigSkillContainer():setTouchEnable(bEnable)
end

--@brief	BigSkill的回调
--@param	sender:BigSkill按钮元素
--@note
function WndTeachBattleHud:onBigSkill(sender)
	if self.m_tMyHero:getSp()>=100 then

		self.m_angerAnim:getAnimNode():setVisible(false)

		self:setMyHudShow(false)
		
		self.m_tMyHero:setUseBigSkill(true)
		
		self.m_tMyHero:setSp(0)
	end
end

------BossAPI
--@brief	更新Boss血量
--@note
function WndTeachBattleHud:updateBossHP()
	local myHP = TeachBattle:getBoss():getHp()
	local myMaxHP = TeachBattle:getBoss():getMaxHp()
	if self.m_root then
		WZUIProgress:luaTo(GetElement(self.m_root,"progBossHp_WndTeachBattleHud")):setPercentage(100*myHP/myMaxHP)
	end
end

--@brief	更新Boss头像
--@note
function WndTeachBattleHud:initBossHead()
	local path = TeachBattle:getBoss():getHeadPath()

    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtName_WndTeachBattleHud")):setText(LocalStrings.TEACH_BOSS_NAME)
end
------HeroAPI

--@brief	设置自己的英雄
--@param	tHero:英雄表
--@note
function WndTeachBattleHud:setMyHero(tHero)
	self.m_tMyHero = tHero
	self:_updateMyHP()
	self:_updateMyPF()
end

--@brief	更新英雄血量
--@param	nPlayerId:玩家ID
--@note
function WndTeachBattleHud:updatePlayerHP(nPlayerId)
	if self.m_tMyHero and nPlayerId == self.m_tMyHero:getId() then
		self:_updateMyHP()
	end
end

--@brief	更新英雄体力
--@param	nPlayerId:玩家ID
--@note
function WndTeachBattleHud:updatePlayerPF(nPlayerId)

	if self.m_tMyHero and nPlayerId == self.m_tMyHero:getId() then
		self:_updateMyPF()

		if self.m_tMyHero:getPF() < 50 then
			self:setMyFlyEnable(false)
		end
	end
end

--@brief	更新英雄怒气
--@param	nPlayerId:玩家ID
--@note
function WndTeachBattleHud:updatePlayerSp(nPlayerId)

	if self.m_tMyHero and nPlayerId == self.m_tMyHero:getId() then
		self:setBigSkillPer(self.m_tMyHero:getSp())
	end
end
------Skill

--@brief	获取技能栏元素
--@param	nTag,第几个技能栏元素
--@note
function WndTeachBattleHud:getSkillCell(nTag)
	return WZUIImage:luaTo(GetElement(self.m_root,"imgSkill"..nTag.."_WndTeachBattleHud"))
end

--@brief	清除技能栏
--@note
function WndTeachBattleHud:cleanSkill()
	for i=1,4 do
		tempElement = self:getSkillCell(i)
		tempElement:setVisible(false)
	end
end

--@brief	增加技能引导效果
--@param	nTag,第几个技能栏元素
--@note
function WndTeachBattleHud:addSkillGuide(nTag)
	local img = self:getSkillCell(nTag)
	
	self:_addSkillORItemGuide(img)
end

--@brief	移除技能引导效果
--@param	nTag,第几个技能栏元素
--@note
function WndTeachBattleHud:removeSkillGuide(nTag)
	local img = self:getSkillCell(nTag)
	
	self:_removeSkillORItemGuide(img)
end
------Item

--@brief	获取道具栏元素
--@param	nTag,第几个道具元素
--@note
function WndTeachBattleHud:getItemCell(nTag)
	return WZUIImage:luaTo(GetElement(self.m_root,"imgItem"..nTag.."_WndTeachBattleHud"))
end

--@brief	清除道具栏
--@note
function WndTeachBattleHud:cleanItem()
	for i=1,4 do
		tempElement = self:getItemCell(i)
		tempElement:setVisible(false)
	end
end

--@brief	增加道具引导效果
--@param	nTag,第几个道具栏元素
--@note
function WndTeachBattleHud:addItemGuide(nTag)
	local img = self:getItemCell(nTag)
	
	self:_addSkillORItemGuide(img)
end

--@brief	移除道具引导效果
--@param	nTag,第几个道具元素
--@note
function WndTeachBattleHud:removeItemGuide(nTag)
	local img = self:getItemCell(nTag)
	
	self:_removeSkillORItemGuide(img)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	刷新自己HP相关控件
--@note
function WndTeachBattleHud:_updateMyHP()
	if self.m_root == nil then
		return
	end

	local myHP = self.m_tMyHero:getHp()
	local myMaxHP = self.m_tMyHero:getMaxHp()

	WZUIProgress:luaTo(GetElement(self.m_root,"progMyHP_WndTeachBattleHud")):setPercentage(100*myHP/myMaxHP)
	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMyHP_WndTeachBattleHud")):setText(myHP.."/"..myMaxHP)

end

--@brief	刷新自己PF相关控件
--@note
function WndTeachBattleHud:_updateMyPF()
	if self.m_root == nil then
		return
	end

	local myPF = self.m_tMyHero:getPF()
	local myMaxPF = self.m_tMyHero:getMaxPF()

	WZUIProgress:luaTo(GetElement(self.m_root,"progMyPF_WndTeachBattleHud")):setPercentage(100*myPF/myMaxPF)
	WZUILabelTTF:luaTo(GetElement(self.m_root,"txtMyPF_WndTeachBattleHud")):setText(myPF.."/"..myMaxPF)

end

--@brief	增加技能道具引导效果
--@note
function WndTeachBattleHud:_addSkillORItemGuide(tSender)
	local img = tSender
	
	local img1 = WZUIImage:create()
	img1:setUseOriginSize(true)
	img1:setScale(0.41)
	img1:setFile("common/animation/7_an.png")
	img1:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	img1:setTag(1)
	
	local actionFadeTo1 = WZUIActionFadeTo:create()
	actionFadeTo1:setOpacity(50)
	actionFadeTo1:setDuration(0.5)
	local actionFadeTo2 = WZUIActionFadeTo:create()
	actionFadeTo2:setOpacity(255)
	actionFadeTo2:setDuration(0.5)
	sequence = WZUIActionSequence:create()
	sequence:setIsLoop(true)

	sequence:setChildAction(actionFadeTo1)
	sequence:setChildAction(actionFadeTo2)

	img:addChild(img1,-1)
	img1:runUIAction(sequence)
	
	local bg = WZUIImage:create()
	bg:setUseOriginSize(true)
	bg:setFile("battle/hud/battle_hud_playericon_bg.png")
	bg:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	bg:setTag(2)
	img:addChild(bg,-1)
end

--@brief	移除技能道具引导效果
--@note
function WndTeachBattleHud:_removeSkillORItemGuide(tSender)
	
	local img = tSender:getChildByTag(1)
	if img then
		img:removeFromParentAndCleanup(true)
	end
	local bg = tSender:getChildByTag(2)
	if bg then
		bg:removeFromParentAndCleanup(true)
	end
	
end
-------------------------------------私有方法模块End----------------------------------------

--@brief    英文适配函数
--@note     英文适配函数
function WndTeachBattleHud:_adaptLanguage_en()
    WZLog("WndTeachBattleHud:_adaptLanguage_en")
    
    local ttf = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtName_WndTeachBattleHud"))
    ttf:setRelativePosition(GlobalMethod:ccp(0.78,1.75))
    
end

--@brief    越南语适配函数
--@note     越南语适配函数
function WndTeachBattleHud:_adaptLanguage_vn()
    WZLog("WndTeachBattleHud:_adaptLanguage_vn")
    
    local ttf = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtName_WndTeachBattleHud"))
    ttf:setRelativePosition(GlobalMethod:ccp(0.80,1.75))
    
end

--@brief    葡语适配函数
--@note     葡语适配函数
function WndTeachBattleHud:_adaptLanguage_pt()
    WZLog("WndTeachBattleHud:_adaptLanguage_pt")
    
    local ttf = WZUILabelTTF:luaTo(GetElement(self.m_root,"txtName_WndTeachBattleHud"))
    ttf:setRelativePosition(GlobalMethod:ccp(0.82,1.75))
    
end