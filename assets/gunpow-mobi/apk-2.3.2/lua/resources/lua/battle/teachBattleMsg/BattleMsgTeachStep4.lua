--BattleMsgTeachStep4.lua
--@brief	教学步骤消息
--@date		2015/9/17
--@author	莫剑峰
--@note

--@brief	消息数据表
BattleMsgTeachStep4 = {
	m_sName = "BattleMsgTeachStep4",

	m_nStep = nil,
	m_tStepFunction = nil,		--步骤函数

	m_tDialog = nil,			--对话框

    m_nPointX = 850,
    m_nPointY = 750,
    m_nMoveState = 1,
    m_bShowEnd = false,
    m_nOffset =700,
    m_bIsDoing = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgTeachStep4:init()
	WZLog("BattleMsgTeachStep4:init", self.m_nStep)

	for i, guai in pairs (WBattleGlobal:getCurrent():getGuaiList()) do
		local bossAi = guai:getAI()
		bossAi.m_tBoss.m_bActiveAttack = false
	    bossAi.m_tBoss.m_tActiveAttackPos = {}
	    bossAi.m_tBoss.m_tActiveAttackHero = {}

	    bossAi.m_tBoss.m_tActiveSkillList = {}
	    bossAi.m_tBoss.m_tPassiveSkillList = {}
	    bossAi.m_tBoss:getRandomPlayer()
	end

	BattleMsgTeachStep4.m_bIsDoing = true
	self.teachChat = nil
	self.bossShoot = nil
	self.m_tFinger = nil
	self.m_tDialog = nil
	self.heroShoot = nil
	self.skillEffect = nil
	self.skill = nil
	self.move = nil
	self.m_bSkillGet = nil
	self.m_bSkillMove = nil
	if self.m_tLine then
	    self.m_tLine:destroy()
	    self.m_tLine = nil
	end
	self.m_bIsWeaponAppearOk = nil
	self.m_tWeaponAnim = nil
	BattleMsgTeachStep4.teachShow = nil
	BattleMsgTeachStep4.talk = nil
	BattleMsgTeachStep4.skillUse = nil
	TeachGroup1.ISATTACK = nil
	TeachGroup1.ISSKILL = nil
	TeachGroup1.ISFLY = nil
	TeachGroup1.attackRound = nil
	TeachGroup1.ISTALK = nil
	TeachGroup1.ISMOVING = nil
	TeachGroup1.WEAPONGET = nil
	TeachGroup1.ISSHOW = nil
	BattleMsgTeachStep4.m_tLine = nil

	self.m_tStepFunction = {}

	table.insert(self.m_tStepFunction,{self._waitShowingHud})
	if self.m_nStep == 1 then
		table.insert(self.m_tStepFunction,{self._teachChat,nil,102,4})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._postTeach,nil,"1-7"})
		table.insert(self.m_tStepFunction,{self._skillUse,nil,1,6,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUseOk,nil,4})
		table.insert(self.m_tStepFunction,{self._noShowHud})

		-- table.insert(self.m_tStepFunction,{self._postTeach,nil,"1-8"})
		-- table.insert(self.m_tStepFunction,{self._show,nil,30,8,WndBattleHud.m_root})
		-- table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_oneLvFlyGuide})
		-- table.insert(self.m_tStepFunction,{self._showOk})

		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,14,BattleCommon:getPointTable(50,120),0, nil,BattleCommon:getPointTable(-15, 0),"fly"})
		table.insert(self.m_tStepFunction,{self._showZipper,nil,BattleCommon:getPointTable(1120,1094)})
		table.insert(self.m_tStepFunction,{self._readyFly})
		table.insert(self.m_tStepFunction,{self._readyFlyFinish,nil,BattleCommon:getPointTable(28,13.5)})
		table.insert(self.m_tStepFunction,{self._postTeach,nil,"1-9"})
		table.insert(self.m_tStepFunction,{self._fly})
		table.insert(self.m_tStepFunction,{self._msgOver})
	elseif self.m_nStep == 2 then
		table.insert(self.m_tStepFunction,{self._teachChat,nil,103,4})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._postTeach,nil,"1-11"})
		table.insert(self.m_tStepFunction,{self._skillUse,nil,1,7,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUseOk,nil,1,1})

		table.insert(self.m_tStepFunction,{self._postTeach,nil,"1-12"})
		-- table.insert(self.m_tStepFunction,{self._show,nil,30,3,WndBattleHud.m_root, true})
		-- table.insert(self.m_tStepFunction,{self._showOk})

		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,6,BattleCommon:getPointTable(30, 180),-90,true,BattleCommon:getPointTable(10, 0)})
		table.insert(self.m_tStepFunction,{self._readyShoot,nil,2,BattleCommon:getPointTable(-47,8)})
		table.insert(self.m_tStepFunction,{self._startShoot,nil,2,BattleCommon:getPointTable(-47,8)})
		table.insert(self.m_tStepFunction,{self._postTeach,nil,"1-13"})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_oneLvAttackMonster})
		table.insert(self.m_tStepFunction,{self._shootOk})
		
		table.insert(self.m_tStepFunction,{self._msgOver})
		table.insert(self.m_tStepFunction,{self._gameOver})
	elseif self.m_nStep == 3 then
		table.insert(self.m_tStepFunction,{self._teachChat,nil,104,4})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._postTeach,nil,"1-15"})
		table.insert(self.m_tStepFunction,{self._skillUse,nil,1,8,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUseOk,nil,1,1})

		-- table.insert(self.m_tStepFunction,{self._show,nil,30,3,WndBattleHud.m_root, true})
		-- table.insert(self.m_tStepFunction,{self._showOk})

		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,6,BattleCommon:getPointTable(30, 180),-90,true,BattleCommon:getPointTable(10, 0)})
		table.insert(self.m_tStepFunction,{self._readyShoot,nil,2,BattleCommon:getPointTable(-29,14)})
		table.insert(self.m_tStepFunction,{self._startShoot,nil,2,BattleCommon:getPointTable(-29,14)})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_oneLvAttackMonster2})
		table.insert(self.m_tStepFunction,{self._shootOk})

		-- table.insert(self.m_tStepFunction,{self._teachChat,nil,105,4})
		-- table.insert(self.m_tStepFunction,{self._cleanChat})
		table.insert(self.m_tStepFunction,{self._msgOver})
		table.insert(self.m_tStepFunction,{self._gameOver})
	elseif self.m_nStep == 4 then
		table.insert(self.m_tStepFunction,{self._show,nil,30,9,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._showOk})

		table.insert(self.m_tStepFunction,{self._msgOver})
		table.insert(self.m_tStepFunction,{self._teachOver})

	elseif self.m_nStep == 5 then
		-- table.insert(self.m_tStepFunction,{self._show,nil,30,10,WndBattleHud.m_root})
		-- table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_twoLvOperateShow})
		-- table.insert(self.m_tStepFunction,{self._showOk})

		table.insert(self.m_tStepFunction,{self._msgOver})
		table.insert(self.m_tStepFunction,{self._teachOver})
	elseif self.m_nStep == 7 then
		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,4,BattleCommon:getPointTable(90, 210),-90,true,nil,"attack"})
		table.insert(self.m_tStepFunction,{self._readyShoot,nil,1,BattleCommon:getPointTable(-18,25)})
		table.insert(self.m_tStepFunction,{self._startShoot,nil,1,BattleCommon:getPointTable(-18,25)})
		table.insert(self.m_tStepFunction,{self._shootOk})
		table.insert(self.m_tStepFunction,{self._msgOver})
	elseif self.m_nStep == 8 then
		table.insert(self.m_tStepFunction,{self._teachChat,nil,111,6})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._skillUse,nil,6,1,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUseOk,nil,2,31})

		table.insert(self.m_tStepFunction,{self._skillUse,nil,6,2,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUseOk,nil,3,nil})

		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,4,BattleCommon:getPointTable(30, 180),-90,true,BattleCommon:getPointTable(10, 0),"attack"})
		table.insert(self.m_tStepFunction,{self._readyShoot,nil,2,BattleCommon:getPointTable(-14,23),BattleCommon:getPointTable(900,780)})
		table.insert(self.m_tStepFunction,{self._startShoot,nil,2,BattleCommon:getPointTable(-14,23),BattleCommon:getPointTable(900,780)})
		table.insert(self.m_tStepFunction,{self._shootOk})

		table.insert(self.m_tStepFunction,{self._teachChat,nil,112,4})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._msgOver})
		--table.insert(self.m_tStepFunction,{self._gameOver})
	elseif self.m_nStep == 9 then
		table.insert(self.m_tStepFunction,{self._teachChat,nil,114,21})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._skillUse,nil,21,1,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUseOk,nil,1,1})

		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,16,BattleCommon:getPointTable(30, 180),-90,true,BattleCommon:getPointTable(10, 0)})
		table.insert(self.m_tStepFunction,{self._readyShoot,nil,1,BattleCommon:getPointTable(-11,10),BattleCommon:getPointTable(1364.9360351562,702.22808837891)})
		table.insert(self.m_tStepFunction,{self._startShoot,nil,1,BattleCommon:getPointTable(-11,10),BattleCommon:getPointTable(1364.9360351562,702.22808837891)})
		table.insert(self.m_tStepFunction,{self._shootOk})
		table.insert(self.m_tStepFunction,{self._msgOver})
		--table.insert(self.m_tStepFunction,{self._gameOver})

	elseif self.m_nStep == 10 then
		-- table.insert(self.m_tStepFunction,{self._teachChat,nil,202,25})
		-- table.insert(self.m_tStepFunction,{self._cleanChat})

		--table.insert(self.m_tStepFunction,{self._skillUse,nil,25,2,WndBattleHud.m_root})
		--table.insert(self.m_tStepFunction,{self._skillUseOk,nil,1,1})

		-- table.insert(self.m_tStepFunction,{self._show,nil,30,1,WndBattleHud.m_root})
		-- table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossAttackShow})
		-- table.insert(self.m_tStepFunction,{self._showOk})

		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,4,BattleCommon:getPointTable(-355, 350),0,false,nil,"attack"})
		table.insert(self.m_tStepFunction,{self._readyShoot,nil,1,BattleCommon:getPointTable(28,28)})
		table.insert(self.m_tStepFunction,{self._startShoot,nil,1,BattleCommon:getPointTable(28,28)})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossPlayerAttack})
		table.insert(self.m_tStepFunction,{self._shootOk})
		table.insert(self.m_tStepFunction,{self._msgOver})

	elseif self.m_nStep == 11 then
		-- table.insert(self.m_tStepFunction,{self._teachChat,nil,204,25})
		-- table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossWeaponAppear})
		table.insert(self.m_tStepFunction,{self._weaponAppear,nil})
		table.insert(self.m_tStepFunction,{self._weaponAppearOk,nil})

		table.insert(self.m_tStepFunction,{self._teachChat,nil,205,25})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		-- table.insert(self.m_tStepFunction,{self._show,nil,30,2,WndBattleHud.m_root})
		-- table.insert(self.m_tStepFunction,{self._showOk})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossMoveGuide})
		local posX, posY = 700, 650
		table.insert(self.m_tStepFunction,{self._showZipper,nil,BattleCommon:getPointTable(posX + 20,posY -85)})
		table.insert(self.m_tStepFunction,{self._showFinger,nil,15,BattleCommon:getPointTable(520, 5),-60, true,BattleCommon:getPointTable(posX + 50, posY-0), "move"})
		table.insert(self.m_tStepFunction,{self._move,nil,posX-30,BattleCommon:getPointTable(posX-30,posY-55)})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossPickupWeapon})
		table.insert(self.m_tStepFunction,{self._weaponGet,nil})
		table.insert(self.m_tStepFunction,{self._weaponGetOk,nil})

		-- table.insert(self.m_tStepFunction,{self._teachChat,nil,206,25})
		-- table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._showFinger2,nil,25,2,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUse,nil,25,2,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossChooseShoot})
		table.insert(self.m_tStepFunction,{self._skillUseOk,nil,1,1})

		-- table.insert(self.m_tStepFunction,{self._show,nil,30,3,WndBattleHud.m_root, true})
		-- table.insert(self.m_tStepFunction,{self._showOk})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossSkillAni})


		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,4,BattleCommon:getPointTable(-435, 350),0,false,nil,"attack"})
		table.insert(self.m_tStepFunction,{self._readyShoot,nil,2,BattleCommon:getPointTable(20,30)})
		table.insert(self.m_tStepFunction,{self._startShoot,nil,2,BattleCommon:getPointTable(20,30)})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossAttackBoss})
		table.insert(self.m_tStepFunction,{self._shootOk})


		table.insert(self.m_tStepFunction,{self._msgOver})

	elseif self.m_nStep == 12 then
		table.insert(self.m_tStepFunction,{self._teachChat,nil,208,25})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._showFinger2,nil,25,3,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUse,nil,25,3,WndBattleHud.m_root})
		table.insert(self.m_tStepFunction,{self._skillUseOk,nil,3,nil})

		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossChooseSp})
		-- table.insert(self.m_tStepFunction,{self._show,nil,30,7,WndBattleHud.m_root})
		-- table.insert(self.m_tStepFunction,{self._showOk})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossBigSkillGuide})

		table.insert(self.m_tStepFunction,{self._waitShowingMyHudEnd,nil,4,BattleCommon:getPointTable(-485, 350),0,false,nil,"attack"})
		table.insert(self.m_tStepFunction,{self._readyShoot,nil,2,BattleCommon:getPointTable(23,25)})
		table.insert(self.m_tStepFunction,{self._startShoot,nil,2,BattleCommon:getPointTable(23,25)})
		table.insert(self.m_tStepFunction,{self._shootOk})
		table.insert(self.m_tStepFunction,{self._postEvent,nil, PostPlayerEvent.event_teachBossKillBoss})

		table.insert(self.m_tStepFunction,{self._teachChat,nil,209,25})
		table.insert(self.m_tStepFunction,{self._cleanChat})

		table.insert(self.m_tStepFunction,{self._msgOver,nil,true})
		table.insert(self.m_tStepFunction,{self._gameOver})
	elseif self.m_nStep == 13 then
		
	elseif self.m_nStep == 14 then
		-- table.insert(self.m_tStepFunction,{self._teachChat,nil,203,25})
		-- table.insert(self.m_tStepFunction,{self._cleanChat})
		table.insert(self.m_tStepFunction,{self._msgOver,nil,true})
	elseif self.m_nStep == 15 then
		-- table.insert(self.m_tStepFunction,{self._teachChat,nil,207,25})
		-- table.insert(self.m_tStepFunction,{self._cleanChat})
		table.insert(self.m_tStepFunction,{self._msgOver,nil,true})
	end

	
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgTeachStep4:process()
	--WZLog("BattleMsgTeachStep4:process", #self.m_tStepFunction)
	if #self.m_tStepFunction > 0 then
		local ower = self.m_tStepFunction[1][2] or self
		local res = self.m_tStepFunction[1][1](ower,self.m_tStepFunction[1][3],self.m_tStepFunction[1][4],self.m_tStepFunction[1][5],self.m_tStepFunction[1][6],self.m_tStepFunction[1][7],self.m_tStepFunction[1][8],self.m_tStepFunction[1][9],self.m_tStepFunction[1][10])
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
		return false
	else
		return true
	end
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgTeachStep4:done()
	WZLog("BattleMsgTeachStep4:done")
end

-------------------------------------私有方法模块--------------------------------------

function BattleMsgTeachStep4:_postTeach(tag)
	WZLog("BattleMsgTeachStep4:_postTeach", tag)
	PostPlayerEvent:postTeach(tag)
end

function BattleMsgTeachStep4:_show(groupId,stepId,scene,isSkill)
	WZLog("BattleMsgTeachStep4:_show", groupId, stepId)

	TeachGroup1.ISSHOW = true

	local skillId = 3
	if isSkill and TeachGroup1.SKILLID ~= nil then		
		if TeachGroup1.SKILLID <= 5 and TeachGroup1.SKILLID >= 1 then
			skillId = 3
		elseif TeachGroup1.SKILLID <= 10 and TeachGroup1.SKILLID >= 6 then
			skillId = 4
		elseif TeachGroup1.SKILLID <= 15 and TeachGroup1.SKILLID >= 11 then
			skillId = 5
		elseif TeachGroup1.SKILLID <= 67 and TeachGroup1.SKILLID >= 63 then
			skillId = 6
		end
	end
	TeachGroup1:start(groupId,isSkill and skillId or stepId,scene,nil,true)
end

function BattleMsgTeachStep4:_showOk()
	if TeachGroup1.ISSHOW == nil and BattleMsgTeachStep4.teachShow ~= true then
		BattleMsgTeachStep4.teachShow = true
		TeachGroup1:onShowTouchBegan()
		WZLog("BattleMsgTeachStep4:_showOk one")
	end
	if BattleMsgTeachStep4.teachShow == true then
		BattleMsgTeachStep4.teachShow = nil
		TeachGroup1.ISSHOW = nil
		WZLog("BattleMsgTeachStep4:_showOk")
		return true
	end
	return false
end

function BattleMsgTeachStep4:_weaponAppear()
	local anim = BattleAnimation:createAnimation("ui_danrenfuben_box_01",true,"ui")
    anim:setScale(1)
    SceneBattle:getFrontLayer():addChild(anim:getAnimNode(),1)

    anim:getAnimNode():setPosition(GlobalMethod:ccp(730, 1070))
    anim:play("0",true)

    local bg = WZUIImage:create()
	bg:setUseOriginSize(true)
	bg:setName("skill_teach")
	bg:setFile("ui/common/common_icon_zi2.png")
	anim:getAnimNode():addChild(bg)
	bg:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	bg:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))

	local act1=CCMoveBy:create(1,GlobalMethod:ccp(0,-520))
    local array = CCArray:create()
    array:addObject(act1)
    array:addObject(CCCallFunc:create(function() self.m_bIsWeaponAppearOk = true end))
    anim:getAnimNode():runAction(CCSequence:create(array))
    self.m_tWeaponAnim = anim
end

function BattleMsgTeachStep4:_weaponAppearOk()
	if self.m_bIsWeaponAppearOk then
		return true
	end

	return false
end

function BattleMsgTeachStep4:_weaponGet()
	local weaponId = 4900

	local novice = CacheCenter:getGameParam().novice
	if novice then
		local sex = CacheCenter:getPlayerInfo().sex
		local array = SplitStringWithSeparator(novice,"&")
		if array and array[sex+1] then
			local tFashion = {}
			local _string = string.sub(array[sex+1],2,-2)
			tFashion = SplitStringWithSeparator(_string,",")
			if tonumber(tFashion[1]) ~= -1 then
				weaponId = tonumber(tFashion[1])
			end
		end
	end

	WndRewardShow:showById({weaponId},{1},nil,-3)
	TeachGroup1.WEAPONGET = nil

end

function BattleMsgTeachStep4:_weaponGetOk()
	WZLog("BattleMsgTeachStep4:_weaponGetOk")
	
	if TeachGroup1.WEAPONGET == nil then
		return false
    elseif self.m_tWeaponAnim == nil then
        return
	end

	local weaponId = 4900
	local  hero = WBattleGlobal:getCurrent():getMyHero()
	hero.m_sWeaponName = GDatatab_item["id_".. weaponId].animation_index_code
	hero.m_nWeaponType = 1
	local anim = WBattleGlobal:getCurrent():getMyHero().m_anim 
	anim:setWeaponGun(GDatatab_item["id_".. weaponId].animation_index_code)

	local novice = CacheCenter:getGameParam().novice
	if novice then
		local sex = CacheCenter:getPlayerInfo().sex
		local array = SplitStringWithSeparator(novice,"&")
		if array and array[sex+1] then
			local tFashion = {}
			local _string = string.sub(array[sex+1],2,-2)
			tFashion = SplitStringWithSeparator(_string,",")
			if tonumber(tFashion[1]) ~= -1 then
				weaponId = tonumber(tFashion[1])
				local weaponInfo = GDatatab_item["id_".. weaponId]
				local  hero = WBattleGlobal:getCurrent():getMyHero()
				hero.m_sWeaponName = weaponInfo.animation_index_code
				hero.m_nWeaponType = weaponInfo.sub_type
				local anim = WBattleGlobal:getCurrent():getMyHero().m_anim
				if weaponInfo.sub_type == 0 then
					anim:setWeaponBomb(weaponInfo.animation_index_code)
				elseif weaponInfo.sub_type == 1 then
					anim:setWeaponGun(weaponInfo.animation_index_code)
				end
			end
			if tonumber(tFashion[2]) ~= -1 then
				anim:setHead(GDatatab_item["id_".. tFashion[2]].animation_index_code)
			end
			if tonumber(tFashion[3]) ~= -1 then
				anim:setFace(GDatatab_item["id_".. tFashion[3]].animation_index_code)
			end
			if tonumber(tFashion[4]) ~= -1 then
				anim:setBody(GDatatab_item["id_".. tFashion[4]].animation_index_code)
			end
			if tonumber(tFashion[5]) ~= -1 then
				anim:setWing(GDatatab_item["id_".. tFashion[5]].animation_index_code)
			end
		end
	end

	self.m_tWeaponAnim:getAnimNode():removeFromParentAndCleanup(true)
    self.m_tWeaponAnim = nil
	if true then
		local id={}
        local name={}
        local icon={}
        local lv={}
        local priceCostGold={}
        local desc={}
        local itemMainType={}
        local itemSubType={}
        local param1={}
        local param2={}
        local tireValue={}
        local consumePower={}
        local specialAttackType={}
        local specialAttackParam={}
        local effectId={}
        local coolSkillTime = {}
        local startCoolSkillTime = {}

        
        local weaponInfo = {1,6,11}--GDatatab_item["id_"..weaponId].power_skill[1]

        for i, v in ipairs (weaponInfo) do
            local isTeach = nil
            local isEndTeach1, step1 = TeachGroup1:isTeachFinish(1)
            if false or (TeachGroup1:isTeach() and WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_SINGLE) and ( isEndTeach1 == false and CacheCenter:getPlayerInfo().level <= 3)) then
                isTeach = true
            end
            if (i ~= 7 and isTeach) or isTeach ~= true then
                local itemId = v
                if itemId == 0 then
                    table.insert(id,0)
                elseif itemId == -1 then
                    table.insert(id,-1)
                else
                    table.insert(id,itemId)
                end

                local itemInfo = {name = 0, icon = 0, lv = 0, desc = 0, type = 0, subType = 0, parm1 = 0, parm2 = 0, consume = 0, specialAttackType = 0, specialAttackParam = 0, effect_id = {{-1}},cooling_time = 0,start_time=0,}
                if itemId > 0 and GDatatab_skill["id_"..itemId] then
                    itemInfo = GDatatab_skill["id_"..itemId]
                end
                table.insert(name,itemInfo.name)
                table.insert(icon,itemInfo.icon == -1 and "battleitems/pound.png" or itemInfo.icon)
                table.insert(lv,itemInfo.lv_icon == -1 and "battleitems/battle_icon_jnl1.png" or itemInfo.lv_icon)
                table.insert(priceCostGold,0)
                table.insert(consumePower,itemInfo.consume)
                table.insert(specialAttackType,itemInfo.specialAttackType)
                table.insert(specialAttackParam,itemInfo.specialAttackParam)
                table.insert(effectId,itemInfo.effect_id[1][1])
                table.insert(coolSkillTime,itemInfo.cooling_time)
                table.insert(startCoolSkillTime,itemInfo.start_time)
                WZLog("SceneBattleLoading:_getPlayerSkill two", tostring(itemInfo.name), tostring(itemInfo.cooling_time), tostring(itemInfo.effect_id[1][1]))
			end
		end

		WBattleGlobal:getCurrent().m_tMySkill_Beginning = {count=5, id=id, name=name, icon=icon,lv=lv, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}

	    WZLog("SceneBattleLoading:_getPlayerSkill three-1", weaponId, Serialize(WBattleGlobal:getCurrent().m_tMySkill_Beginning))
	    WBattleGlobal:getCurrent().m_tSkillList = {}
	    for i,v in pairs(GDatatab_skill) do
	        if v.skill_type == 0 or v.skill_type == -1 or v.skill_type == 2 then
	            WZLog("SceneBattleLoading:_getPlayerSkill three-2",v.name,v.id)
	            local skillList = { name=v.name, icon=v.icon, lv=v.lv_icon, itemSubType= v.id, param1=5, param2=5, coolSkillTime = v.cooling_time,damageRange = v.specialAttackType ,consumePower=v.consume, specialAttackType=v.specialAttackType, specialAttackParam=v.specialAttackParam, effectId=v.effect_id[1][1], startCoolSkillTime = v.start_time}
	            WBattleGlobal:getCurrent().m_tSkillList[ v.id ] = skillList
	        end
	    end
        hero.m_nBigSkillType = GDatatab_item["id_"..weaponId].value
        --[[
        if hero:getBigSkillType() == 2 then
            hero:getAnimation():setWeaponBigSkill(3)
        elseif hero:getBigSkillType() == 0 then
            hero:getAnimation():setWeaponBigSkill(2)
        else
            hero:getAnimation():setGunBigSkill()
        end
        --]]
        local skillList = {count=5, id=id, name=name, icon=icon, lv=lv, priceCostGold=priceCostGold, desc=desc, itemMainType=itemMainType, itemSubType=itemSubType, param1=param1, param2=param2, tireValue=tireValue, consumePower=consumePower, specialAttackType=specialAttackType, specialAttackParam=specialAttackParam, effectId=effectId, coolSkillTime=coolSkillTime, startCoolSkillTime=startCoolSkillTime}

        for index, id in pairs (skillList.id) do
            if id ~= -1 and id ~= 0 then
                hero.m_tSkillCdList[id] = 0
                WZLog("ProtocolProcessorSceneBattle:parse_BATTLE_GotoBattle one-1",index,id)
            end
        end
        WndBattleHud:reset(WndBattleHud.m_tMyHero:getId())
	end
end

function BattleMsgTeachStep4:_showLine(speed,pos)
	--do return end
	WZLog("BattleMsgTeachStep4:_showLine zero", self.m_tLine)
	if self.m_tLine == nil then

		self.m_tLine = BattlePointsLine:create(SceneBattle:getFrontLayer(), 20, nil, nil, nil, nil, nil, nil, ePos)
		--self.m_tLine = BattlePointsLine:create(SceneBattle:getTopInfoLayer(), 20)
		self.m_tLine:setVisible(false)
		BattleMsgTeachStep4.m_tLine = self.m_tLine
	end

	WZLog("BattleMsgTeachStep4:_showLine one", self.m_tLine)
	if self.m_tLine:isVisible() ~= true then
		local aimHero = WBattleGlobal:getCurrent():getGuaiSortList()[1]
	    if aimHero == nil then
	        WZLog("BattleMsgTeachStep4:_showLine No aimHero,use myHero instead")
	        aimHero = WBattleGlobal:getCurrent():getMyHero()
	    end

	    local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId

	    local offset = {x=0,y=0}
	    if mapId == 9999 then
	    	offset.x = offset.x -0
	    	offset.y = offset.y + 170
	    end
	    local ePos = BattleCommon:getPointTable(aimHero:getPosition().x+ offset.x, aimHero:getPosition().y + 50 + offset.y)

	    local hero = WBattleGlobal:getCurrent():getMyHero()
	    if mapId == 10101 and hero.m_nMyTurnCount == 1 then
	    	ePos = BattleCommon:getPointTable(1120,1094)
	    end
	    self.m_tLine:setTarget(ePos)
		self.m_tLine:setVisible(true)
		local acceleration = BattleCommon:pointAdd(BattleConstants.g_nFlyGravity,WBattleGlobal:getCurrent():getWind())
		self.m_tLine:update(pos,speed,acceleration, 1.5)
	end
	
	local sp1 = SceneBattle.m_pointsLine.m_tSpeed
	if sp1 then
		local sp2 = self.m_tLine.m_tSpeed
		local x = math.abs(sp1.x - sp2.x) 
		local y = math.abs(sp1.y - sp2.y) 
		local mapId = WBattleGlobal:getCurrent().m_tMakePairOk.mapId
		local hero = WBattleGlobal:getCurrent():getMyHero()
		--print("BattleMsgTeachStep4:_showLine", tostring(SceneBattle.m_pointsLine.m_bisWrong), x, y, sp1.x, sp2.x, sp1.y, sp2.y)
		if (x < 7 and y < 7) or (mapId == 10101 and hero.m_nMyTurnCount == 2 and x < 14 and y < 7) then
			SceneBattle.m_pointsLine.m_bisWrong = false
		else
			SceneBattle.m_pointsLine.m_bisWrong = true
		end
	end
end

function BattleMsgTeachStep4:_waitShowingHud()
	WZLog("BattleMsgTeachStep4:_waitShowingHud", tostring(WndBattleHud:isShowingMyHudEnd()))
	if WndBattleHud:isShowingMyHudEnd() then
		return true
	else
		return false
	end
end


function BattleMsgTeachStep4:_teachChat(index, groupId, stepId)
	WZLog("BattleMsgTeachStep4:_teachChat", index, tostring(self.teachChat))
	if self.teachChat == nil then
		self.teachChat = true
    	CreateStoryTalkGroup(index,nil,groupId, stepId)
    elseif self.teachChat == true and WndTeachTalk.m_root then
    	self.teachChat = nil
    	return true
    end
    return false
end

function BattleMsgTeachStep4:_cleanChat()

	if WndTeachTalk.m_root == nil then
    	return true
    end
    
	return false
end

function BattleMsgTeachStep4:_bossShoot(id,skillId)
	WZLog("BattleMsgTeachStep4:_bossShoot", id)
	if self.bossShoot == nil then
		self.bossShoot = true
		WBattleGlobal:getCurrent():getCharacterWithId(id):getAI():doAction(AiActionConfig.SKILL,{[1] = {actionParm1 = skillId}},nil,nil,nil,true)
	elseif self.bossShoot == true and WBattleGlobal:getCurrent():getBossBulletsList() and #WBattleGlobal:getCurrent():getBossBulletsList() > 0 then
		self.bossShoot = nil
		return true
	end
	return false
end

function BattleMsgTeachStep4:_bossShootOk()
	local isEnd = false 
	if WBattleGlobal:getCurrent():getBossBulletsList() == nil or #WBattleGlobal:getCurrent():getBossBulletsList() == 0 then
		isEnd = true
	end
	WZLog("BattleMsgTeachStep4:_bossShootOk", tostring(isEnd))
	return isEnd
end

function BattleMsgTeachStep4:_waitShowingMyHudEnd(index, textOffset, rotation, isFlip, animOffset, sound)
	
	if WndBattleHud:isShowingMyHudEnd() then
		WZLog("BattleMsgTeachStep4:_waitShowingMyHudEnd", tostring(sound))
		self:_buildShootDialog(index, textOffset, sound)
		--创建手指动画
		animOffset = animOffset or {x=0,y=0}
		local animPos = GlobalMethod:ccp(WBattleGlobal:getCurrent():getMyHero():getPosition().x,WBattleGlobal:getCurrent():getMyHero():getPosition().y)
		animPos = SceneBattle:getFrontLayer():convertToWorldSpaceAR(animPos)
    	animPos = SceneBattle:getTopInfoLayer():convertToNodeSpace(animPos)
    	animPos = GlobalMethod:ccp(animPos.x + animOffset.x, animPos.y + animOffset.y)
    	self.m_tFinger = TeachBattleCommon:showFingerAnimation(SceneBattle:getTopInfoLayer(), animPos, rotation, 0, isFlip)
		return true
	else
		return false
	end
end

function BattleMsgTeachStep4:_showFinger(index, textOffset, rotation, isFlip, animOffset, sound)
	WZLog("BattleMsgTeachStep4:_showFinger", tostring(sound))
	if ProjConfig.LANGUAGE == "ug" then
		if index == 15 then
			textOffset = BattleCommon:getPointTable(520, 300)
		end
	end
	self:_buildShootDialog(index, textOffset, sound)
	--创建手指动画
	animOffset = animOffset or {x=0,y=-110}
	self.m_tFinger = TeachBattleCommon:showFinger(SceneBattle:getFrontLayer(), animOffset, rotation, 0, isFlip, nil, nil, 1)
	return true
end

function BattleMsgTeachStep4:_buildShootDialog(index,offset, sound)
	WZLog("BattleMsgTeachStep4:_buildShootDialog",index,tostring(sound))
	self:_removeDialog()
	local strText = LocalStrings["TEACH_" .. index]
    if isChannelPC() then 
        if tonumber(index) == 4 then 
            strText = LocalStrings.QQHALL_TEXT1[3]
        elseif tonumber(index) == 107 then 
            strText = LocalStrings.QQHALL_TEXT1[4]
        elseif tonumber(index) == 113 then 
            strText = LocalStrings.QQHALL_TEXT1[5]
        end
    end
	_,self.m_tDialog = Teach:showDialog( WBattleGlobal:getCurrent():getMyHero():getAnimation():getAnimNode(),SceneBattle:getTopInfoLayer(), strText, 4 , offset or GlobalMethod:ccp(0,0), 1 )
	if sound then
		SoundManager:playEffectSound(GetRoleSound() .. "/" .. sound..".mp3")
	end
end

function BattleMsgTeachStep4:_removeDialog()
	if self.m_tDialog then
		self.m_tDialog:removeDialog(true)
		self.m_tDialog = nil
	end
end

function  BattleMsgTeachStep4:_readyFly()
	TeachGroup1.ISFLY = true
	local offset
	local hero = WBattleGlobal:getCurrent():getMyHero()

	local start
	if TeachGroup1.ISFIRSTBATTLE then
		if hero:getUseBigSkill() then
			offset = {x=0,y=0}
		end
		start = start or BattleCommon:getShootPos(false,hero,offset)
	else
		if hero:getUseBigSkill() then
			offset = {x=130,y=80}
		end
		start = start or BattleCommon:getShootPos(true,hero,offset)
	end
	self:_showLine(BattleCommon:getPointTable(30,16),start)
	--WZLog("BattleMsgTeachStep4:_readyShoot one", tostring(TeachBattleCommon:readyFlyOrShoot()))
	if TeachBattleCommon:readyFlyOrShoot() and SceneBattle.m_pointsLine.m_bisWrong == false then
		self:_removeDialog()
		self.m_tFinger:removeFromParentAndCleanup(true)
		self.m_tFinger = nil
		TeachGroup1.ISFLY= false
		return true
	end
	local touch = SceneBattle:getBattleTouch()
	--WZLog("BattleMsgTeachStep4:_readyShoot two", touch:getTouchStatus(1))
	if touch:getTouchStatus(1) == BattleTouch.TOUCH_BEGIN then
		--self:_removeDialog()
	elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_END then
		--self:_buildShootDialog()
		touch:update()
	end
	return false
end

function  BattleMsgTeachStep4:_readyShoot(count,speed,start)

	local offset
	local hero = WBattleGlobal:getCurrent():getMyHero()

	if TeachGroup1.ISFIRSTBATTLE then
		if hero:getUseBigSkill() then
			offset = {x=0,y=0}
		end
		start = start or BattleCommon:getShootPos(false,hero,offset)
	else
		if hero:getUseBigSkill() then
			offset = {x=130,y=80}
		end
		start = start or BattleCommon:getShootPos(true,hero,offset)
	end

	self:_showLine(speed,start)
	TeachGroup1.ISATTACK = true
	WZLog("BattleMsgTeachStep4:_readyShoot one", tostring(TeachBattleCommon:readyFlyOrShoot()), SceneBattle.m_pointsLine.m_bisWrong)
	if TeachBattleCommon:readyFlyOrShoot() then
		if SceneBattle.m_pointsLine.m_bisWrong == false then
			self:_removeDialog()
			self.m_tFinger:removeFromParentAndCleanup(true)
			self.m_tFinger = nil
			TeachGroup1.ISATTACK = false
			BattleShowHeroUse:removeHeroUse()
			return true
		else
			hero.m_bIsReadyShoot = nil
        	hero:playEndShootAnim()
		end

	end
	local touch = SceneBattle:getBattleTouch()
	--WZLog("BattleMsgTeachStep4:_readyShoot two", touch:getTouchStatus(1))
	if touch:getTouchStatus(1) == BattleTouch.TOUCH_BEGIN then
		--self:_removeDialog()
	elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_END then
		--self:_buildShootDialog()
		touch:update()
	end
	return false
end

function BattleMsgTeachStep4:_startShoot(count, speed,start)

	if self.heroShoot == nil then
		local hero = WBattleGlobal:getCurrent():getMyHero()

		self.heroShoot = true
		--WZLog("BattleMsgTeachStep4:_startShoot one", count)
		TeachGroup1.attackRound = count
		GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.PALYER_ATT_ROUND_UPDATE)
		local msg = MsgManager:createMsg(BattleMsgPlayerShoot)
		msg.m_nBattleId = WBattleGlobal:getCurrent().m_tMakePairOk.battleId
		msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
		msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
		msg.m_nSpeedx = speed.x
		msg.m_nSpeedy = speed.y
		local startPos
		local offset
		local hero = WBattleGlobal:getCurrent():getMyHero()

		

		if TeachGroup1.ISFIRSTBATTLE then
			if hero:getUseBigSkill() then
				offset = {x=0,y=0}
				hero:getAnimation():setRotate(15)
			end
			msg.m_nLeftRight = 0
			startPos = BattleCommon:getShootPos(false,hero,offset)
		else
			if hero:getUseBigSkill() then
				offset = {x=130,y=80}
				hero:getAnimation():setRotate(20)
			end
			msg.m_nLeftRight = 1
			startPos = BattleCommon:getShootPos(true,hero,offset)
		end

		if start == nil then
			msg.m_nStartX = startPos.x
			msg.m_nStartY = startPos.y
		else
			msg.m_nStartX = start.x
			msg.m_nStartY = start.y
		end
		WZLog("BattleMsgTeachStep4:_startShoot two", count, msg.m_nSpeedx,msg.m_nSpeedy,msg.m_nStartX,msg.m_nStartY)
		MsgManager:pushNonBlockMsg(msg)

		if self.m_tLine then
			self.m_tLine:setVisible(false)
		end
	elseif self.heroShoot == true and TeachGroup1.ISSHOOT == true then
		self.heroShoot = nil
		return true
	end

	return false
end

function BattleMsgTeachStep4:_shootOk()
	local isEnd = false 
	if TeachGroup1.ISSHOOT == nil and WBattleGlobal:getCurrent():getMyHero().m_faceAnim == nil then
		isEnd = true
	end

	WZLog("BattleMsgTeachStep4:_shootOk", tostring(isEnd))
	return isEnd
end

function BattleMsgTeachStep4:_talk(groupId,stepId,scene)
	WZLog("BattleMsgTeachStep4:_talk", groupId, stepId, scene)

	TeachGroup1.ISTALK = true
	TeachGroup1:start(groupId,stepId,scene)
end

function BattleMsgTeachStep4:_talkOk()
	if TeachGroup1.ISTALK == nil and BattleMsgTeachStep4.talk ~= true then
		BattleMsgTeachStep4.talk = true
		TeachGroup1:onTouchEnd(nil,nil,true)
		WZLog("BattleMsgTeachStep4:_talkOk one")
	end
	if BattleMsgTeachStep4.talk == true then
		BattleMsgTeachStep4.talk = nil
		TeachGroup1.ISTALK = nil
		WZLog("BattleMsgTeachStep4:_talkOk")
		return true
	end
	return false
end

-- 显示指引手指移动到引导区域
function BattleMsgTeachStep4:_showFinger2(groupId,stepId,scene)
	WZLog("BattleMsgTeachStep4:_showFinger2", groupId, stepId, scene)

	if scene:getChildByTag(110011) then
		return false
	else
		if self.bIsFingerEnd == true then
			self.bIsFingerEnd = false
			return true
		end
	end

	--获取指引区域坐标
	local CenterPt = ccp(568,320) --中心坐标
	local ctwsar = CenterPt --指引区域坐标
    local tStepList = {}
    for i = 1 ,TeachGroup1.COUNT do
	    local group = {}
	    for key, value in pairs(GDatatab_Teach) do
	        if value and value.group == i then
	            table.insert(group, value)
	        end
	    end

	    table.sort(group,function(a,b) return a.step<b.step end) 
	    table.insert(tStepList, {groupId = i, info = group})
    end
    for id, group in pairs (tStepList) do
        if groupId == group.groupId then
            local infoGroup = group.info
            for index, info in ipairs (infoGroup) do
            	local isBtnTask = info.btnTask and info.btnTask == 1 and (GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.type == 2 and GlobalGame.g_tWndBottomBarObj.m_nMoveDirection == 0 or GlobalGame.g_tWndBottomBarObj == nil and SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.type == 2 and SceneCity.m_tWndBottomBarObj.m_nMoveDirection == 0)
                local isBtnTask2 = info.btnTask and info.btnTask == 2 and (GlobalGame.g_tWndBottomBarObj and GlobalGame.g_tWndBottomBarObj.type == 2 or GlobalGame.g_tWndBottomBarObj == nil and SceneCity.m_tWndBottomBarObj and SceneCity.m_tWndBottomBarObj.type == 2)
                if ((isBtnTask ~= true and info.step == stepId) or (isBtnTask2 == true and info.step == stepId+1) or (isBtnTask2 == true and info.step == stepId+2)) and (info.force >= CacheCenter:getPlayerInfo().level or info.force == -1 or TeachGroup1.ISTEACHMODE) then

	                local param1 = isBtnTask2 and info.param1_2 or info.param1
	                local param2 = isBtnTask2 and info.param2_2 or info.param2
	                local elementType = isBtnTask2 and info.elementType_2 or info.elementType
	                local node = TeachGroup1:getElement(param1, param2, elementType, scene)

	                local nodeWorldPt = node:convertToWorldSpaceAR(ccp(0,0))
	                ctwsar = scene:convertToNodeSpace(nodeWorldPt)
	            end
            end
        end
    end

    --创建手指
	local imgFinger = WZUIImage:create()
	imgFinger:setShowAll(true)
	imgFinger:setUseOriginSize(true)
	imgFinger:setFile("ui/common/zhiyin_shouzhi.png")
	imgFinger:setAnchorPoint(GlobalMethod:ccp(0,1))
	imgFinger:setUseAbsCoordinate(true)
	imgFinger:setAbsPosition(CenterPt)
	scene:addChild(imgFinger,99,110011)
    local act1=CCMoveTo:create(1.4,ctwsar)
    local act2=CCDelayTime:create(1)
    local act3=CCCallFuncN:create(function (sender)
    	sender:removeFromParentAndCleanup(true)
    	self.bIsFingerEnd = true
    end)
    local array = CCArray:create()
    array:addObject(act1)
    array:addObject(act2)
    array:addObject(act3)
    imgFinger:runAction(CCSequence:create(array))

    return false
end

function BattleMsgTeachStep4:_skillUse(groupId,stepId,scene)
	WZLog("BattleMsgTeachStep4:_skillUse", groupId, stepId, scene)

	TeachGroup1.ISSKILL = true

	TeachGroup1:start(groupId,stepId,scene)
end

function BattleMsgTeachStep4:_skillUseOk(type,id)
	if TeachGroup1.ISSKILL == nil and BattleMsgTeachStep4.skillUse ~= true then
		BattleMsgTeachStep4.skillUse = true
		TeachGroup1:onTouchEnd(nil,nil,true)
		WZLog("BattleMsgTeachStep4:_skillUseOk one")
	end
	if BattleMsgTeachStep4.skillUse == true then
		WZLog("BattleMsgTeachStep4:_skillUseOk", tostring(type), tostring(id))
		--BattleMsgTeachStep4.skillUse = nil
		if type == 4 then
			local element = GetElement(WndBattleHud.m_root, "btnFly_WndBattleHud", WZUIButton)
			WndBattleHud:onReadyFly(element, true)
		elseif type == 3 then
			BattleHeroUse:heroUse(WBattleGlobal:getCurrent():getMyHero():getId(),type,id, nil)
		end
		return true
	end
	return false
end

function  BattleMsgTeachStep4:_noShowHud()
	WndBattleHud:setMyHudSwitchEnable(false)
	WndBattleHud:setMyHudShow(false)
end

function  BattleMsgTeachStep4:_showHud()
	WndBattleHud:setMyHudSwitchEnable(false)
	WndBattleHud:setMyHudShow(true)
end

function  BattleMsgTeachStep4:_showHudOk()
	return WndBattleHud:isShowingMyHudEnd()
end

function BattleMsgTeachStep4:_startMyRound()

	SceneBattle:playTurnShow( false , true )

end

function BattleMsgTeachStep4:_waitRound()

	return not SceneBattle:isRunningTurnShow()

end

function BattleMsgTeachStep4:_msgOver(myTurn)
    self.teachChat = nil
    self.bossShoot = nil
    self.m_tFinger = nil
    self.m_tDialog = nil
    self.heroShoot = nil
    self.skillEffect = nil
    self.skill = nil
    self.move = nil
    self.m_backFire = nil
    self.m_bSkillGet = nil
    self.m_bSkillMove = nil
    if self.m_tLine then
    	WZLog("BattleMsgTeachStep4:_msgOver one")
	    self.m_tLine:destroy()
	    self.m_tLine = nil
	end
    self.m_bIsWeaponAppearOk = nil
    self.m_tWeaponAnim = nil
    BattleMsgTeachStep4.teachShow = nil
    BattleMsgTeachStep4.skillUse = nil
    BattleMsgTeachStep4.talk = nil
    TeachGroup1.ISATTACK = nil
    TeachGroup1.ISSKILL = nil
    TeachGroup1.ISFLY = nil
    TeachGroup1.attackRound = nil
    TeachGroup1.ISTALK = nil
    TeachGroup1.ISMOVING = nil
    TeachGroup1.WEAPONGET = nil
    TeachGroup1.ISSHOW = nil
    BattleMsgTeachStep4.m_bIsDoing = nil
    BattleMsgTeachStep4.m_tLine = nil
    if myTurn then
    	TeachGroup1.ISBATTLE_MYTURN = false
	end

end

function BattleMsgTeachStep4:_gameOver()
    WBattleGlobal:getCurrent():testCopyEnd(true)
end

function BattleMsgTeachStep4:_teachOver()
	TeachGroup1.ISBATTLE = nil
	TeachGroup1.ISBATTLE_MYTURN = nil
end

function BattleMsgTeachStep4:_gameOverOk()

	return false
end

function  BattleMsgTeachStep4:_showZipper(pos)
	local front = SceneBattle:getFrontLayer()

	if CCArmatureDataManager:sharedArmatureDataManager():getTextureData("teach012") == nil then
		CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("armatures/teach.png","armatures/teach.plist","armatures/teach.xml")
	end

	self.m_tZipper = BattleAnimation:createAnimation("zhiyin_yidong_tishi_01",true,"teach")
	self.m_tZipper:getAnimNode():setRelativePosition(GlobalMethod:ccp( pos.x /front:getContentSize().width , pos.y/front:getContentSize().height ))
	front:addChild(self.m_tZipper:getAnimNode(),0)
	self.m_tZipper:play("0",true)
end

function  BattleMsgTeachStep4:_readyFlyFinish(speed)
	WZLog("BattleMsgTeachStep4:_readyFlyFinish")
	local hero = WBattleGlobal:getCurrent():getMyHero()

	SoundManager:playEffectSound(SoundDefine.E_S_FLY)

	--CCDirector:sharedDirector():setAnimationInterval(1.0/21)
	local msg = MsgManager:createMsg(BattleMsgPlayerFly)
	msg.m_nBattleId = 1
	msg.m_nPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
	msg.m_nCurrentPlayerId = WBattleGlobal:getCurrent():getMyBattleId()
	msg.m_nSpeedx = speed.x
	msg.m_nSpeedy = speed.y
	msg.m_nIsEquip = 1

	local startPos
	local offset
	local hero = WBattleGlobal:getCurrent():getMyHero()

	msg.m_nLeftRight = 0
	startPos = BattleCommon:getShootPos(false,hero,offset)

	msg.m_nStartX = 550
	msg.m_nStartY = 1150
	MsgManager:pushNonBlockMsg(msg)

	self:_postEvent(PostPlayerEvent.event_oneLvDoFly)
	if self.m_tLine then
		self.m_tLine:setVisible(false)
	end
end

function  BattleMsgTeachStep4:_fly()
	local hero = WBattleGlobal:getCurrent():getMyHero()
	WZLog("BattleMsgTeachStep4:_fly", tostring(TeachGroup1.ISFLY))
	if TeachGroup1.ISFLY == nil then
		--BattleScreen:followHero(hero:getMover():getMoverPosition())
		--hero:getAnimation():setRotate(0)
		return false
	end

	hero:getAnimation():setRotate(0)

	self.m_tZipper:getAnimNode():removeFromParentAndCleanup(true)
	self.m_tZipper = nil
	BattleShowHeroUse:removeHeroUse()
end

function BattleMsgTeachStep4:_move(point,pointEnd)
	local touch = SceneBattle:getBattleTouch()
	local anim = WBattleGlobal:getCurrent():getMyHero():getAnimation()
	

	--[[
	if touch:getTouchStatus(1) == BattleTouch.TOUCH_BEGIN then

		local touchPoint = GlobalMethod:ccp( touch:getTouchPoint(1).x,touch:getTouchPoint(1).y )
		touchPoint = touch:pointWorldToNode( anim:getAnimNode() , touchPoint )
		if anim:getPosition().x - touchPoint.x  > 15 then
            WZLog("TeachBattleMsg_Step2:_move", WBattleGlobal:getCurrent():getMyHero():getPosition().x, WBattleGlobal:getCurrent():getMyHero():getPosition().y)

            self.move = true
		end
	elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_HOLD then
		WZLog("TeachBattleMsg_Step2:_move", WBattleGlobal:getCurrent():getMyHero():getPosition().x, WBattleGlobal:getCurrent():getMyHero():getPosition().y)

		if self.move == true then
			self.move = nil
	        anim:getAnimNode():stopAllActions()
	        local moveTo = CCRepeatForever:create(CCMoveBy:create(0.1,GlobalMethod:ccp(-15,0)))
	        anim:getAnimNode():runAction(moveTo)
	        anim:setFlipX(true)
	        anim:play("move",true)
	    end

		if anim:isPlaying("move") then
			WBattleGlobal:getCurrent():getMyHero():setPF(WBattleGlobal:getCurrent():getMyHero():getPF() - 1)
		end
	elseif touch:getTouchStatus(1) == BattleTouch.TOUCH_END then
		if WBattleGlobal:getCurrent():getMyHero():getPosition().x > point then
			touch:update()
			anim:getAnimNode():stopAllActions()
			anim:play("standby1",true)
		end
	end
	--]]

	--WZLog("BattleMsgTeachStep4:_move one",touch:getTouchStatus(1),WBattleGlobal:getCurrent():getMyHero():getPosition().x, point)
	if  WBattleGlobal:getCurrent():getMyHero():getPosition().x > point then
		TeachGroup1.ISMOVING = nil
	elseif WBattleGlobal:getCurrent():getMyHero():getPosition().x <= point then
		TeachGroup1.ISMOVING = true
	end

	if WBattleGlobal:getCurrent():getMyHero():getPosition().x > point then
		WZLog("BattleMsgTeachStep4:_move two")
		anim:play("standby1",true)
		anim:getAnimNode():stopAllActions()
		self.m_tZipper:getAnimNode():removeFromParentAndCleanup(true)
		self.m_tZipper = nil

		self:_removeDialog()
		self.m_tFinger:removeFromParentAndCleanup(true)
		self.m_tFinger = nil
		WBattleGlobal:getCurrent():getMyHero():setPosition(GlobalMethod:ccp(pointEnd.x,pointEnd.y) or GlobalMethod:ccp(1010,920))
		return true
	end

	return false
end

function BattleMsgTeachStep4:_setBigSkill()
	WBattleGlobal:getCurrent():getMyHero():setSp(100)
end

function BattleMsgTeachStep4:_checkUseBigSkill()
    if self.m_tDialog == nil then
        WndTeachBattleHud:setBigSkillEnable(true)
        _,self.m_tDialog = CellBattleTeachDialog:addDialog(WndTeachBattleHud:getBigSkillContainer(),SceneBattle:getTopInfoLayer(),LocalStrings.TEACH_GUIDE_BIGSKILL,CellBattleTeachDialog.DIR_UP,-1,nil,nil,-30,40,nil,nil,true)
    end

	return WBattleGlobal:getCurrent():getMyHero():getUseBigSkill()
end

function BattleMsgTeachStep4:_useBigSkill()

	self:_removeDialog()

	TeachBattleCommon:showUseName(WBattleGlobal:getCurrent():getMyHero():getPosition(),LocalStrings.BATTLE_USE_BIGSKILL)
	BattleShowHeroUse:runUseAnim(WBattleGlobal:getCurrent():getMyHero(),"use",SceneBattle:getFrontLayer())

	self:_buildShootDialog()
	self.m_tFinger =TeachBattleCommon:showFingerAnimation(SceneBattle:getFrontLayer(),{ x = WBattleGlobal:getCurrent():getMyHero():getPosition().x  , y = WBattleGlobal:getCurrent():getMyHero():getPosition().y  },20)
end

function BattleMsgTeachStep4:_startBigShoot()
	WBattleGlobal:getCurrent():getMyHero():setAttack(9999)
	WBattleGlobal:getCurrent():getMyHero():setAttTimes(7)
	WBattleGlobal:getCurrent():getMyHero():setAttScatterNum(1)
	TeachShoot:startShoot(18,13.5,0,WBattleGlobal:getCurrent():getMyHero():getPosition().x,WBattleGlobal:getCurrent():getMyHero():getPosition().y + 50)
end

--@brief 	创建新手皮肤帮手
function BattleMsgTeachStep4:_skinHelperAppear()
	-- body
	local suit_head, suit_face, suit_body, suit_weapon, suit_wing
	
	local suit_info = {}
	
	suit_info.head = "id_4903"
	suit_info.face = "id_4902"
	suit_info.body = "id_4901"
    suit_info.monster = -1105
    suit_info.bMonsterMode = false
	suit_info.weapon = "id_4900"
	suit_info.wing = ""
    suit_info.colour = 0
    suit_info.bodyColour = 0
    suit_info.footId = 0

    suit_head = [[bhead = "bhead8"]]
    suit_face = [[bface = "bface8"]]
    suit_body = [[bbody = "bbody8"]]

    suit_weapon = string.gsub(GDatatab_item["id_4900"].weaponblastinganimation,"c","a")
   

    WZLog("BattleMsgTeachStep4:_skinHelperAppear", tostring(suit_head), tostring(suit_face), tostring(suit_body), tostring(suit_weapon), tostring(suit_wing))

	local tEquipList = {}
	StringIntsertToTable(tEquipList,suit_head)
	StringIntsertToTable(tEquipList,suit_face)
	StringIntsertToTable(tEquipList,suit_body)
	StringIntsertToTable(tEquipList,suit_weapon)
	StringIntsertToTable(tEquipList,suit_wing)

    local weapon = {animation_index_code=1,sub_type=1}
	local hero = WHero:buildHero(tEquipList, 0, suit_info)
    --英雄武器类型
    hero.suit_info = suit_info
    hero.m_nTournamentLevel = nil

	--英雄id
	hero.m_nPlayerId = 123456789
	--英雄战斗id
	hero.m_nBattleId = hero.m_nPlayerId
	WBattleGlobal:getCurrent().m_tAIControlList = WBattleGlobal:getCurrent().m_tAIControlList or {}
    table.insert(WBattleGlobal:getCurrent().m_tAIControlList, hero.m_nPlayerId)
    
    hero.m_bCanControl = true
    hero.m_nAiCtrlId = 1
    hero:buildAiCombination()

	--英雄名字
	hero.m_sPlayerName = LocalStrings.HELPER_NAME
	--英雄等级
	hero.m_nLevel = CacheCenter:getPlayerInfo().level
    --英雄真实等级
    hero.m_nRealLevel = CacheCenter:getPlayerInfo().level
	--英雄性别
	hero.m_nBoyOrGirl = 0
	--英雄阵型
	hero.m_nCamp = 0
	--英雄阵型位置
	hero.m_nCampPosition = 0
	--英雄最大HP
	hero.m_nMaxHP = CacheCenter:getPlayerInfo().hp
    hero.m_nHPPre = hero.m_nMaxHP
	--英雄最大PF
	hero.m_nMaxPF = 100
	--英雄最大SP
	hero.m_nMaxSP = 100
	--英雄HP
	hero.m_nHP = hero.m_nMaxHP * 10
	hero.m_nHP_Encrypt = BattleCommon:intEncrypt(hero.m_nHP)
	--英雄PF
	hero.m_nPF = hero.m_nMaxPF
	hero.m_nPF_Encrypt = BattleCommon:intEncrypt(hero.m_nPF)
	--英雄SP
	hero.m_nSP = 100
	hero.m_nSP_Encrypt = BattleCommon:intEncrypt(hero.m_nSP)
	--英雄称号
	hero.m_sTitle = ""
	--英雄公会
	hero.m_sCommunity = ""
	--英雄攻击力
	hero.m_nAttack = CacheCenter:getPlayerInfo().attack * 10
	hero.m_nAttack_Encrypt = BattleCommon:intEncrypt(hero.m_nAttack)
	--英雄暴击倍率
	hero.m_nCriticalhitAttackRate = CacheCenter:getPlayerInfo().critRate
	hero.m_nCriticalhitAttackRate_Encrypt = BattleCommon:intEncrypt(hero.m_nCriticalhitAttackRate)
	--英雄防御
	hero.m_nDefence = CacheCenter:getPlayerInfo().defend * 5
	hero.m_nDefence_Encrypt = BattleCommon:intEncrypt(hero.m_nDefence)
	--英雄免伤
	hero.m_nInjuryFree = CacheCenter:getPlayerInfo().injuryFree
	hero.m_nInjuryFree_Encrypt = BattleCommon:intEncrypt(hero.m_nInjuryFree)
	--英雄破防
	hero.m_nWreckDefense = CacheCenter:getPlayerInfo().wreckDefense
	hero.m_nWreckDefense_Encrypt = BattleCommon:intEncrypt(hero.m_nWreckDefense)
	--英雄免暴
	hero.m_nReduceCrit = CacheCenter:getPlayerInfo().reduceCrit
	hero.m_nReduceCrit_Encrypt = BattleCommon:intEncrypt(hero.m_nReduceCrit)
	--英雄免坑
	hero.m_nReduceBury = 0
	hero.m_nReduceBury_Encrypt = BattleCommon:intEncrypt(hero.m_nReduceBury)
	--英雄大招类型
	hero.m_nBigSkillType = GDatatab_item["id_4900"].power_skill
	--英雄转生等级
	hero.m_nZSLevel = GlobalGame:checkGlobalPlayerZsleve(hero.m_nLevel)

	--武器熟练度
	hero.m_nSkillfull = 0
	hero.m_nSkillfull_Encrypt = BattleCommon:intEncrypt(hero.m_nSkillfull)

    hero.m_nPower = CacheCenter:getPlayerInfo().force
    hero.m_nArmor = CacheCenter:getPlayerInfo().armor
    
    hero.m_nConstitution = CacheCenter:getPlayerInfo().physique
    hero.m_nAgility = CacheCenter:getPlayerInfo().agility
    hero.m_nLucky = CacheCenter:getPlayerInfo().luck

    hero.serverId = CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().serverId or 0
    hero.teamId = 0
    hero.teamName = ""
    hero.teamUrl = ""
    hero.m_bIsCaptain = false
    hero.professionId = 0
    hero.m_nBigSkillType = GDatatab_item["id_4900"].value
    hero.m_nBigSkinSkillType = 3030
    hero:setNowCtb(10000)

    WBattleGlobal:getCurrent().m_tHeros[hero.m_nPlayerId] = hero

    WBattleGlobal:getCurrent().m_tCharacterAttributeList[hero.m_nBattleId] = {battleId=hero.m_nBattleId, atk=hero.m_nAttack}
    hero:getAnimation():play(hero:getActionName(23),true)
    
    local playerName = BattleHeroName:create(hero, SceneBattle:getInfoLayer(), true)
    hero:setPlayerNameIcon(playerName)
    playerName:update()

    SceneBattle:getFrontLayer():addChild(hero:getAnimation():getAnimNode(), 0)
    WBattleGlobal:getCurrent().m_tMakePairOk.playerCount = 2
    BattleCtbManager:addCellBattleCtb(hero.m_nBattleId)
    BattleCtbManager:setCtb(hero.m_nBattleId,10000)

    local skinBigSkill = hero:getSkinBigSkill()
    if skinBigSkill and skinBigSkill > 0 then
        local tempShapeData = WBattleGlobal:getCurrent():getSkinBigSkillShape(skinBigSkill)
        hero.m_skinBigSkillAnim = BattleAnimation:createAnimation(tempShapeData.animation, false)
        hero.m_skinBigSkillAnim:getAnimNode():retain()

        SceneBattle:getFrontLayer():addChild(hero.m_skinBigSkillAnim:getAnimNode())
        hero.m_skinBigSkillAnim:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5,0))
        hero.m_skinBigSkillAnim:getAnimNode():setUseAbsCoordinate(true)
        hero.m_skinBigSkillAnim:getAnimNode():setScale(0.7)
        hero.m_skinBigSkillAnim:getAnimNode():setAnimationName("wait")
        hero.m_skinBigSkillAnim:getAnimNode():setLoop(true)
        hero.m_skinBigSkillAnim:getAnimNode():setVisible(false)
    end
    hero:setPosition(Vector2:create(1500, 520))

    WndBattleHud:_skinHelperOk(hero)
    PostPlayerEvent:postEvent(PostPlayerEvent.event_twoLvCreatePartner)
    
    return true
end

function BattleMsgTeachStep4:_postEvent(eventKey)
	PostPlayerEvent:postEvent(eventKey)
end