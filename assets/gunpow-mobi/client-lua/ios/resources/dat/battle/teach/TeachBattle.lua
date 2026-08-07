--TeachBattle.lua
--@brief	教学战斗
--@date		2013/2/25
--@author	Zjh
--@note		教学战斗


--@brief	数据表
TeachBattle = {
	m_tMyHero = nil,
	m_tBoss = nil,
	m_nStep = nil,
	m_tBullets = nil,
	TOTAL_STEP = 20,
	ID_BATTLE = 1,
    TEACH_TYPE = 2,     --1,黑龙教学;2,蘑菇教学
}

TeachBattleIcon =
{
	SKILL =
	{
		"battleitems/dividto3_1.png",
		"battleitems/power50_1.png",
		"battleitems/timesadd1_1.png",
	},
	ITEM =
	{
		"battleitems/bloodsingle_1.png",
	},
}

-------------------------------------公有方法模块--------------------------------------

--@brief	开始战斗教学
--@param	nStep:步骤数
function TeachBattle:startTeach(nStep,nId)
	WZLog("TeachBattle",nStep,nId)

	nStep = nStep or 0

	TeachBattle.ID_BATTLE = 1

	self.m_nStep = nStep + 1

	self.m_tBullets = {}
end

------英雄和BOSS

--@brief	获取自己的英雄
--@return	TeachHero
function TeachBattle:getMyHero()
	return self.m_tMyHero
end

--@brief	设置自己的英雄
--@param	tHero,TeachHero类
function TeachBattle:setMyHero(tHero)
	self.m_tMyHero = tHero
end

--@brief	初始化英雄
function TeachBattle:initHero(sHeroName)

    local pos = {x=890 , y=150}
    if TeachBattle.TEACH_TYPE == 2 then
        pos.x = 1150
        pos.y = 750
    end
	self.m_tMyHero:setPosition( pos )

	self.m_tMyHero.m_nMaxHP = 10000
	self.m_tMyHero:setHp(10000)
	self.m_tMyHero:setSp(0)
	self.m_tMyHero.m_nMaxPF = 100
	self.m_tMyHero:setPF(100)

	self.m_tMyHero.m_nPlayerId = 0

	self.m_tMyHero:getAnimation():play("standby1",true)

    if TeachBattle.TEACH_TYPE == 2 then
        self.m_tMyHero:addRectCollision(self.m_tMyHero:getAnimation():getAnimNode():getContentSize().width * 0.8,self.m_tMyHero:getAnimation():getAnimNode():getContentSize().height * 0.8,0,0)
    end

	self.m_tMyHero:setPlayerName(sHeroName)
end

--@brief	初始化BOSS
function TeachBattle:initBoss(sBossName)

    local pos = {x=1300 , y=170}
    if TeachBattle.TEACH_TYPE == 2 then
        pos.x = 1500
        pos.y = 990
    end
	self.m_tBoss:setPosition( pos )

    if TeachBattle.TEACH_TYPE == 1 then
        self.m_tBoss.m_nMaxHP = 75000
        self.m_tBoss:setHp(75000)
    elseif TeachBattle.TEACH_TYPE == 2 then
        self.m_tBoss.m_nMaxHP = 95000
        self.m_tBoss:setHp(95000)
    end

	self.m_tBoss:getAnimation():play("stand",true)

	self.m_tBoss.m_nId = -1

    if TeachBattle.TEACH_TYPE == 1 then
        self.m_tBoss:addRectCollision(self.m_tBoss:getAnimation():getAnimNode():getContentSize().width -60,self.m_tBoss:getAnimation():getAnimNode():getContentSize().height,0,0)
        self.m_tBoss:setName(sBossName)
    elseif TeachBattle.TEACH_TYPE == 2 then
        self.m_tBoss:addRectCollision(self.m_tBoss:getAnimation():getAnimNode():getContentSize().width -0,self.m_tBoss:getAnimation():getAnimNode():getContentSize().height * 0.8,0,0)

        self.m_tBoss.m_nAttScatterNum = 1
        self.m_tBoss:setName(LocalStrings.TEACH_BOSS_NAME)
    end

end

--@brief	设置BOSS
--@param	tBoss:boss表
function TeachBattle:setBoss(tBoss)
	self.m_tBoss = tBoss
end

--@brief	获取BOSS
--@return	TeachBoss
function TeachBattle:getBoss()
	return self.m_tBoss
end

--@brief	开始创建战斗教学消息
function TeachBattle:startTeachStep()
    local msgPrefix = "TeachBattleMsgStep"
    if TeachBattle.TEACH_TYPE == 2 then
        msgPrefix = "TeachBattleMsg_Step"
    end

    WZLog("TeachBattle:startTeachStep", self.m_nStep, msgPrefix..self.m_nStep)
	local msg = MsgManager:createMsg(loadstring("return "..msgPrefix..self.m_nStep)())
	msg.m_bStart = true
	MsgManager:pushBlockMsg(msg)



    if TeachBattle.TEACH_TYPE == 1 then
        self:syncStep()
        TeachBattle:getBoss():createBoss5Anim()
    elseif TeachBattle.TEACH_TYPE == 2 then
        self:syncStep2()
    end

end

------教学相关

--@brief	进入教学下一步
function TeachBattle:doNextTeach()
    self.m_nStep = self.m_nStep + 1
    local msgPrefix = "TeachBattleMsgStep"
    if TeachBattle.TEACH_TYPE == 2 then
        msgPrefix = "TeachBattleMsg_Step"
    end

    WZLog("TeachBattle:doNextTeach", self.m_nStep, msgPrefix..self.m_nStep)
	local msg = MsgManager:createMsg(loadstring("return "..msgPrefix..self.m_nStep)())
	MsgManager:pushBlockMsg(msg)
end

--@brief	进入教学组下一步
function TeachBattle:doGourpTeach()
    local msgPrefix = "TeachBattleMsg_Step"

    WZLog("TeachBattle:doGourpTeach", self.m_nStep, msgPrefix..self.m_nStep.."_2")
    local msg = MsgManager:createMsg(loadstring("return "..msgPrefix..self.m_nStep.."_2")())
    MsgManager:pushBlockMsg(msg)
end

--@brief	教学每帧更新的内容
--@param	帧间时间
function TeachBattle:updateDt(nDt)
	if self.m_tMyHero then
		self.m_tMyHero:update()
	end
	if self.m_tBoss then
		self.m_tBoss:update()
	end
end

--@brief	结束教学
function TeachBattle:endTeach()
	if self.m_tMyHero then
		self.m_tMyHero:destroy()
		self.m_tMyHero = nil
	end
	if self.m_tBoss then
		self.m_tBoss:destroy()
		self.m_tBoss = nil
	end
	self.m_nStep = nil
	if self.m_tBullets then
		for i,bullet in pairs(self.m_tBullets) do
			bullet:destroy()
		end
		self.m_tBullets = nil
	end
end

function TeachBattle:startMyTurn(tSender,tFunction)

	TeachBattle:getMyHero():updateByTurn()
	MsgBoxManager:showTipBox(LocalStrings.START_MY_TURN,nil,tSender,tFunction)
	--self:syncStep()
end

function TeachBattle:startBossTurn(tSender,tFunction)

	MsgBoxManager:showTipBox(LocalStrings.START_OTHER_TURN,nil,tSender,tFunction)
	--self:syncStep()
end

function TeachBattle:syncStep()

	if self.m_nStep > 2 then
		self.m_tMyHero:setHp(10000 - 4000)
	end
	if self.m_nStep > 3 then
		self.m_tBoss:setHp(100000 - 5150 * 3)
	end
	if self.m_nStep > 6 then
		self.m_tMyHero:setPosition( {x=450 , y=150} )
	end
	if self.m_nStep > 9 then
		self.m_tMyHero:setHp(10000 - 4000 * 2)
	end
	if self.m_nStep > 10 then
		self.m_tMyHero:setHp(10000)
		self.m_tBoss:setHp(100000 - 5150 * 3 - 7320 * 2)
	end
	if self.m_nStep > 13 then
		self.m_tMyHero:setPosition( {x=640,y=440} )
	end
	if self.m_nStep > 16 then
		self.m_tMyHero:setHp(10000 - 4000)
	end
end

function TeachBattle:syncStep2()
    WZLog("TeachBattle:syncStep2", self.m_nStep)
    if self.m_nStep > 1 then
    self.m_tMyHero:setHp(10000 - 2000)
    end
    if self.m_nStep > 2 then
    self.m_tMyHero:setPosition( {x=TeachBattleMsg_Step2.m_nPointX,y=TeachBattleMsg_Step2.m_nPointY} )
    end
    if self.m_nStep > 3 then
    self.m_tMyHero:setHp(10000 - 2000 - 2000)
    self.m_tBoss:setHp(75000 - 25100)
    end
    if self.m_nStep > 4 then
    self.m_tMyHero:setHp(10000 - 2000 - 2000 - 2000)
    self.m_tMyHero:setPosition( {x=450,y=980} )
    self.m_tMyHero:setSp(100)
    end
end

------子弹

--@brief	创建一个子弹爆炸的控件
--@param	tBullet:子弹的表
--@return	#1:爆炸控件
function TeachBattle:buildWeaponExplodeElement(tBullet,sWeaponName)
	local sElementName = WeaponExplodeAnimation[sWeaponName]
	if sElementName ~= nil then
		local element = WZUISystem:getInstance():createElement(sElementName)
        if tBullet ~= nil then
            element:setLuaObjectIndex(tBullet)
        end
		return element
	end
	return nil
end

--@brief	创建一个新的子弹
--@param	nStartX:子弹开始位置
--@param	nStartY:子弹开始位置
--@param	fSpeedX:子弹速度
--@param	fSpeedY:子弹速度
--@return	#1:创建的子弹表
function TeachBattle:buildBullet(nStartX,nStartY,fSpeedX,fSpeedY,id)
	local hero = self:getMyHero()
    if id == self:getBoss():getId() then
        hero = self:getBoss()
    end

	local accele = {x=BattleConstants.g_nFlyGravity.x,y=BattleConstants.g_nFlyGravity.y}
	local bullet = TeachBullet:buildBullet({x=nStartX,y=nStartY},{x=fSpeedX,y=fSpeedY},accele,hero)

	if hero:getUseBigSkill() then
		bullet:getAnimation():play("fly2",true)
	else
		bullet:getAnimation():play("fly1",true)
	end

    WZLog("TeachBattle:buildBullet", tostring(self:getBoss():getId()))

    if TeachBattle.TEACH_TYPE == 1 then
        bullet:addCollisionCharas({[self:getBoss():getId()] = self:getBoss()})
    elseif TeachBattle.TEACH_TYPE == 2 then
        if id == self:getBoss():getId() then
            bullet:addCollisionCharas({[self:getMyHero():getId()] = self:getMyHero()})
        else
            bullet:addCollisionCharas({[self:getBoss():getId()] = self:getBoss()})
        end
    end

	-------------------------------------后添加的效果会先作用，依次往前作用--------------------------------------

	table.insert(self.m_tBullets,bullet)

	return bullet
end


--@brief	获取子弹列表
--@return	#1:子弹列表
function TeachBattle:getBulletsList()
	return self.m_tBullets
end

--@brief	通过表下标获取子弹
--@param	nIndex:表下标
--@return	#1:子弹
function TeachBattle:getBulletByIndex(nIndex)
	return self.m_tBullets[nIndex]
end

--@brief	通过表下标移除子弹
--@param	nIndex:表下标
function TeachBattle:removeBulletByIndex(nIndex)
	if nIndex <= #self.m_tBullets then
		table.remove(self.m_tBullets,nIndex)
	end
end

--@brief	清空子弹列表
function TeachBattle:clearBulletsList()
	self.m_tBullets = {}
end
-------------------------------------私有方法模块--------------------------------------
