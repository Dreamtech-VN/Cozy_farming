-- BattleMsgAssistedBoss4_2.lua
--@brief    狂风暴雪
--@date     2015/9/15
--@author   zsq
--@note

--@brief    消息数据表
BattleMsgAssistedBoss4_2 = {
    m_sName = "BattleMsgAssistedBoss4_2",
    m_tSkillShowMsg = nil,      --调用者（BattleMsgShow）
    m_tTargetList = nil,
	m_nLen = 300,
	m_nWind = 2,
	m_backFire = nil,
	m_backFire1 = nil,
}

-------------------------------------公有方法模块--------------------------------------

--@brief    消息初始化函数
--@note     消息系统第一次调用process函数前调用
function BattleMsgAssistedBoss4_2:init()
    WZLog("BattleMsgAssistedBoss4_2:init")
	--self:addStorm()
    self.m_tTargetList = {}
    local list = WBattleGlobal:getCurrent():getHeroList()
    for i,target in pairs(list) do
        table.insert(self.m_tTargetList,target)
    end

	--获得配置的吹动距离
	self.m_nLen = 0

	--风向
    local wind = type(WBattleGlobal:getCurrent():getWindLevel()) == "table" and WBattleGlobal:getCurrent():getWindLevel().x or WBattleGlobal:getCurrent():getWindLevel()
	if wind > 0 then self.m_nWind = 4 else self.m_nWind = -4 end

	--添加粒子效果
	if wind <= 0 then
    	self.m_backFire = WBulletBackFire:create(BattleCommon:getPointTable(1700,800), BulletEffectId.BOSS4_WIND)
		SceneBattle:getFrontLayer():addChild(self.m_backFire:getElement():getParent(),99)

    	self.m_backFire1 = WBulletBackFire:create(BattleCommon:getPointTable(1700,800), BulletEffectId.BOSS4_WIND1)
		SceneBattle:getFrontLayer():addChild(self.m_backFire1:getElement():getParent(),99)
	else
    	self.m_backFire = WBulletBackFire:create(BattleCommon:getPointTable(0,800), BulletEffectId.BOSS4_WIND2)
		SceneBattle:getFrontLayer():addChild(self.m_backFire:getElement():getParent(),99)

    	self.m_backFire1 = WBulletBackFire:create(BattleCommon:getPointTable(0,800), BulletEffectId.BOSS4_WIND3)
		SceneBattle:getFrontLayer():addChild(self.m_backFire1:getElement():getParent(),99)
	end
end

--@brief    消息处理过程函数
--@return   #1,nil或true表示消息处理结束，否则返回false
--@note     未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgAssistedBoss4_2:process(dt)
	WZLog("BattleMsgAssistedBoss4_2:process",dt)
    local isLoop = self:updatePosition()
    return not isLoop
end

--@brief 移动玩家位置
function BattleMsgAssistedBoss4_2:updatePosition()
	self.m_nLen = self.m_nLen + 2
    for i,target in pairs(self.m_tTargetList) do
        if not target:isDead() then
            local outScene,_ = target:checkIsOutOfScene()
            if outScene then
                target:setMoveUpdatable(false)
            else
                local pos = target:getPosition()
                --local tPos = BattleCommon:getPointTable(pos.x + self.m_nWind,pos.y)
                --target:setPosition(tPos)
                target:setPosition({x = pos.x ,y = pos.y + 2})
                target:setMoveUpdatable(true)
                --target:getMover():setMoveAcceleration(self.m_nWind,-1)
                target:getMover():setMoveAcceleration(self.m_nWind,2)

    		  -- WZLog("玩家位置",pos.x,pos.y)
            end
        end
    end
	if self.m_nLen > self.m_tSkillShowMsg.m_skillParam1 then
    	return false
	else
    	return true
	end
end

--@brief	添加风暴效果
function BattleMsgAssistedBoss4_2:addStorm()
	WZLog("BattleMsgAssistedBoss4_2:addStorm")
    local effectBoom  = BattleEffect:createAnimation(1011)
    --local effectBoom  = BattleAnimation:createAnimation("skills_cj_sjbs_01",true)
    effectBoom:setPosition(BattleCommon:getPointTable(480,300))
    SceneBattle:getFrontLayer():addChild(effectBoom:getAnimNode(),100)
end

--@brief 镜头控制
function BattleMsgAssistedBoss4_2:isCanCtrlCamera()
    return self.m_tSkillShowMsg:isCanCtrlCamera()
end

--@brief 获得技能所有者
function BattleMsgAssistedBoss4_2:getOwner()
    return self.m_tSkillShowMsg.m_tOwner
end

--@brief 获得owner坐标
function BattleMsgAssistedBoss4_2:getOwnerPos()
    return self.m_tSkillShowMsg.m_tOwner:getPosition()
end

--@brief 获得目标列表
function BattleMsgAssistedBoss4_2:getMsgTargetList()
    return self.m_tSkillShowMsg.m_tTargetList
end

--@brief 添加表演
function BattleMsgAssistedBoss4_2:msgDoAction(config)
    self.m_tSkillShowMsg:doAction(config,config.isWait)
end

--@brief    消息处理完成函数
--@note     消息系统最后一次调用process函数后调用
function BattleMsgAssistedBoss4_2:done()
    WZLog("BattleMsgAssistedBoss4_2:done")
	--删除粒子
    if self.m_backFire then
        self.m_backFire:removeElement()
    	self.m_backFire = nil
	end
    if self.m_backFire1 then
        self.m_backFire1:removeElement()
    	self.m_backFire1 = nil
	end

    self.m_tSkillShowMsg:reduceWait(BattleSkillType.CREATE_ASSISTED_MSG)
end

-------------------------------------私有方法模块--------------------------------------

