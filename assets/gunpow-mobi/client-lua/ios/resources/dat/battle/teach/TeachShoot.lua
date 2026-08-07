--TeachShoot.lua
--@brief	玩家射击消息
--@date		2013/3/3
--@author	Zjh
--@note

--@brief	消息数据表
TeachShoot = {
	m_nSpeedx = 0, 					--发射速度
	m_nSpeedy = 0, 					--发射速度
	m_nLeftRight = 0, 				--1：左 0：右（向左还是向右）
	m_nStartX = 0, 					--发射初始位置
	m_nStartY = 0, 					--发射初始位置
-------------------------------------处理逻辑使用的变量--------------------------------------
	m_tStepFunction = nil,			--步骤函数
	m_tScreenSpring = nil,			--屏幕是否在震动
    m_tHero = nil,                  --角色
}

-------------------------------------公有方法模块--------------------------------------

function TeachShoot:startShoot(nSpeedX,nSpeedY,nLeftRight,nStartX,nStartY, hero)
    WZLog("TeachShoot:startShoot", nSpeedX, nSpeedY)
    if hero ~= nil then
        self.m_tHero = hero
    else
        self.m_tHero = TeachBattle:getMyHero()
    end

	self.m_nSpeedx = nSpeedX
	self.m_nSpeedy = nSpeedY
	self.m_nLeftRight = nLeftRight 
	self.m_nStartX = nStartX
	self.m_nStartY = nStartY
	self.m_tScreenSpring = nil
	hero = self.m_tHero
	
	if self.m_nLeftRight == 1 then
		hero:getAnimation():setFlipX(true)
	else
		hero:getAnimation():setFlipX(false)
	end

	self.m_tStepFunction = {}
	if hero and hero:getUseBigSkill() then
		table.insert(self.m_tStepFunction,self._readyShowBigSkill)
		table.insert(self.m_tStepFunction,self._showBigSkill)
	end
	table.insert(self.m_tStepFunction,self._playShootAnim)
	table.insert(self.m_tStepFunction,self._readyShoot)
	table.insert(self.m_tStepFunction,self._repeatShoot)
	table.insert(self.m_tStepFunction,self._shooting)
	table.insert(self.m_tStepFunction,self._waitForBulletAndHurt)
end

function TeachShoot:shoot()
	WZLog("TeachShoot:shoot")
	--更新子弹状态
	self:_updateBullet()

	--子弹跟随
	self:_followBullet()

	--屏幕震动
	self:_updateScene()

	if #self.m_tStepFunction > 0 then
		local res = self.m_tStepFunction[1](self)
		if res == true or res == nil then
			table.remove(self.m_tStepFunction,1)
		end
		return false
	else
		return true
	end

	return true
end

-------------------------------------私有方法模块--------------------------------------
--@brief	播放射击动画
function TeachShoot:_playShootAnim()
    WZLog("TeachShoot:_playShootAnim")
	self.m_tHero:playReadyShootAnim()
	return true
end

--@brief	播放准备射击动画
function TeachShoot:_readyShoot()
    WZLog("TeachShoot:_readyShoot")
	local hero = self.m_tHero
	if hero:getAnimation():isCurrentAnimationDone() == true then
		self:_repeatShoot()
		return true
	else
		return false
	end
end

--@brief	播放重复射击动画
function TeachShoot:_repeatShoot()
    WZLog("TeachShoot:_repeatShoot")
	local hero = self.m_tHero
	local attTimes = hero:getAttTimes()
	if attTimes <= 0 then
		hero:playEndShootAnim()
		return true
	end
	if hero:getAnimation():isCurrentAnimationDone() == true then
		self:_createBullet(hero:getAttScatterNum())
		if attTimes <=  1 then
			hero:playEndShootAnim()
			hero:setAttTimes(attTimes-1)
			return true
		else
			hero:playRepeatShootAnim(1)
			hero:setAttTimes(attTimes-1)
			return false
		end
	else
		return false
	end
end

--@brief	播放正在射击动画
function TeachShoot:_shooting()
    WZLog("TeachShoot:_shooting")
	local hero = self.m_tHero
	if hero:getAnimation():isCurrentAnimationDone() == true then
		hero:getAnimation():play("standby1",true)
		return true
	else
		return false
	end
end  

--@brief	等待子弹消失和英雄受伤
function TeachShoot:_waitForBulletAndHurt()
	WZLog("TeachShoot:_waitForBulletAndHurt")
	if self:_waitForBullet() and self:_waitForHurtNum() then
		return true
	else
		return false
	end
end

--@brief	等待子弹消失
function TeachShoot:_waitForBullet()
	WZLog("TeachShoot:_waitForBullet",self:_isHaveBullet())
	if self:_isHaveBullet() == false then
		return true
	else
		return false
	end
end

--@brief	等待伤害数字消失
function TeachShoot:_waitForHurtNum()
	WZLog("TeachShoot:_waitForHurtNum",TeachBattle:getBoss():getMarkHurt())
	return not TeachBattle:getBoss():getMarkHurt()
end

--@brief	更新子弹状态
function TeachShoot:_updateBullet()
	WZLog("TeachShoot:_updateBullet")
	local bullets = TeachBattle:getBulletsList()
	for i=#bullets,1,-1 do
		if bullets[i]:getStatus() == BulletStatus.DEF_ST_FLY then
			bullets[i]:updatePosition()
			--碰撞检测
			if bullets[i]:checkCollision() then
				bullets[i]:explode()

				local charas,values,tDistance, tCritType,tHurtRatio = bullets[i]:checkHurt()
				charas,values = self:_charaAddHurtValue(charas,values,tHurtRatio)
				--屏幕震动
				self:_setSceneSpring(bullets[i]:getMover():getMoverPosition())
			end
		end
		--移除子弹
		if self:_canRemoveBullet(bullets[i]) then
			bullets[i]:destroy()
			TeachBattle:removeBulletByIndex(i)
		end
	end
end

--@brief	对英雄添加受伤数字(除零)
--@param	charas:英雄列表
--@param	hurtValue:受伤数字
--@return	#1:需要发送协议的英雄列表
--@return	#2:需要发送协议的伤害列表
function TeachShoot:_charaAddHurtValue(charas,hurtValue,tHurtRatio)
    WZLog("TeachShoot:_charaAddHurtValue")
	local newCharas = {}
	local newValue = {}
	for id,chara in pairs(charas) do
		if hurtValue[id] > 0 then
			chara:markHurt(hurtValue[id],self.m_tHero,nil,nil,nil,tHurtRatio[id])
			newCharas[id] = chara
			newValue[id] = hurtValue[id]
		end
	end
	return newCharas,newValue
end

--@brief	是否可以移除子弹
--@param	tBullet:检测的子弹
--@return	#1:true,false
function TeachShoot:_canRemoveBullet(tBullet)
    WZLog("TeachShoot:_canRemoveBullet")
	--飞出屏外
	if tBullet:checkOutOfScene() then
		return true
	end
	--爆炸动画播放完毕
	if tBullet:explodeIsEnd() then
		return true
	end
	--再次确认是否爆炸完毕
	if tBullet:getStatus() == BulletStatus.DEF_ST_END_EXPLODE then
		return true
	end
	return false
end

--@brief	更新屏幕(主要是屏幕震动)
function TeachShoot:_updateScene()
	if self.m_tScreenSpring ~= nil then
		BattleScreen:setSpring(self.m_tScreenSpring)
		if BattleScreen:screenSpring() == true then
			self.m_tScreenSpring = nil
		end
	end
end

--@brief	设置屏幕震动
--@param	tPos:震动时的位置
function TeachShoot:_setSceneSpring(tPos)
	self.m_tScreenSpring = {x=tPos.x,y=tPos.y}
end

--@brief	判断是否屏幕震动
--@return	＃1:true/false
function TeachShoot:_getIsSceneSpring()
	return self.m_tScreenSpring ~= nil
end


--@brief	屏幕跟踪子弹
function TeachShoot:_followBullet()
    WZLog("TeachShoot:_followBullet")
	local bullet = TeachBattle:getBulletByIndex(1)
	if bullet ~= nil then
		if self._followBullet_time_ == nil then
			self._followBullet_time_ = 0
		else
			self._followBullet_time_ = self._followBullet_time_ + SceneTeachBattle:getBattleLoop():getBattleDeltaTime()
		end
		--if self:_getIsSceneSpring() == false then
		BattleScreen:followBullet(bullet:getMover():getMoverPosition(),self._followBullet_time_)
		--end
	end
end

--@brief	是否还有子弹
--@return	#1：true：是，false：否
function TeachShoot:_isHaveBullet()
	local bullet = TeachBattle:getBulletByIndex(1)
	if bullet ~= nil then
		return true
	end
	return false
end

--@brief	创建子弹
--@param	nScatterNum:散射数量
function TeachShoot:_createBullet(nScatterNum)
    WZLog("TeachShoot:_createBullet")
	SoundManager:playEffectSound(SoundDefine.E_S_SHOOT)
	local startAngle = 0
	if self.m_nLeftRight == 0 then
		startAngle = BattleConstants.g_fWB_SCATTER_ANGLE * (math.floor(nScatterNum / 2) - (nScatterNum+1)%2/2)
	else
		startAngle = -1 * BattleConstants.g_fWB_SCATTER_ANGLE * (math.floor(nScatterNum / 2) - (nScatterNum+1)%2/2)
	end
	local speedVec = BattleCommon:vectorWithAngle({x=self.m_nSpeedx,y=self.m_nSpeedy},startAngle)
	for i=1,nScatterNum do
    local bullet = TeachBattle:buildBullet(self.m_nStartX,self.m_nStartY,speedVec.x,speedVec.y, self.m_tHero:getId())
		SceneTeachBattle:getFrontLayer():addChild(bullet:getAnimation():getAnimNode())
		speedVec = BattleCommon:vectorWithAngle(speedVec,BattleConstants.g_fWB_SCATTER_ANGLE)
	end
end

--@brief	创建大招动画
function TeachShoot:_readyShowBigSkill()
	BattlePlayerBigSkillAnim:readyShow(self.m_tHero, true)
	return true
end

--@brief	播放大招动画
function TeachShoot:_showBigSkill()
	if BattlePlayerBigSkillAnim:process() then
		return true
	end
	return false
end
