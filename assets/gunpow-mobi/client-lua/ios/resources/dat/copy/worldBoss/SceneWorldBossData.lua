--SceneWorldBossData.lua
--@brief	SceneWorldBoss的数据模块
--@date		2015-9-16
--@author	binshao
--@note		世界BOSS模块

SceneWorldBoss = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneWorldBoss:_init()
	self.m_root = nil	 	  			--场景根节点
    self.bRewardRank = nil      -- 奖励排行是否创建，防止重复创建
    self.checkIndex = 1         -- 当前选中的checkbox下标 1为伤害排行，2位奖励排行
    self.selBossId = 0 			-- 选择的Boss id
    self.bossRoomInfo = nil     -- boss房间信息
    self.killInfo = nil         -- 击杀奖励
    self.rankInfo = nil         -- 击杀奖励
    self.hurtInfo = nil         -- 伤害信息
    self.lastInspire = nil
    self.inspireData = {}   -- 鼓舞标志
    self.resultData = nil
    self.openTime = nil     -- 开启剩余时间
    self.m_tReturnCallBack = nil 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function SceneWorldBoss:_unInit()
    self.m_root = nil
    self.bRewardRank = nil
    self.checkIndex = nil
    self.selBossId = nil            --选择的Boss id
    self.bossRoomInfo = nil
    self.killInfo = nil             -- 击杀奖励
    self.rankInfo = nil             -- 击杀奖励
    self.hurtInfo = nil             -- 伤害信息
    self.lastInspire = nil
    self.inspireData = nil
    self.resultData = nil
    self.openTime = nil
    self.m_tReturnCallBack = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneWorldBoss:createElement()
	local element = WZUISystem:getInstance():createElement("SceneWorldBoss")
	assert(element, "SceneWorldBoss create element failed!")
	self:_init()
	return element
end

--mapId	int	地图id
--bossBloodMax	int	boss总血量
--bossBloodCurrent	int	boss当前血量
--rankPlayerId	int[]	排行榜玩家ID
--rankPlayerName	String[]	排行榜玩家名字
--rankHurt	int[]	排位赛伤害输出
--hurt	int	自己对boss造成的伤害合计值
--cdTime	int	冷却时间(秒)
--accelerateCost	int	加速所需钻石
--inspire	int	当前鼓舞值（最大10000）
--bossLevel	int	世界BOSS等级
--myRank	int	我的伤害排名（0表示没有伤害）
--dimaCDTime	int	钻石鼓舞冷却时间(秒)
--goldCDTime	int	金币鼓舞冷却时间(秒)
--bossState	    int	BOSS状态 1 活着， 2死亡  3逃走
function SceneWorldBoss:setEnterRoomData( mapId, bossBloodMax, bossBloodCurrent, rankPlayerId,rankPlayerName, rankHurt, hurt, cdTime,
                                            accelerateCost, inspire, bossLevel, myRank, dimaCDTime, goldCDTime,bossState,openTime)
    self:closeLoading()
	if not self.m_root then return end
	self.bossRoomInfo = {}
	self.bossRoomInfo.mapId = mapId 				     	--房间地图id
	self.bossRoomInfo.bossBloodMax = bossBloodMax	 		--boss总血量
	self.bossRoomInfo.bossBloodCurrent = bossBloodCurrent	--boss当前血量
	self.bossRoomInfo.rankPlayerId = {}					    --排行榜玩家ID
	self.bossRoomInfo.rankPlayerName = {}					--排行榜玩家名字
	self.bossRoomInfo.rankHurt = {}							--排位赛伤害输出
	self.bossRoomInfo.hurt = hurt							--自己对boss造成的伤害合计值
	self.bossRoomInfo.cdTime = math.ceil(cdTime/1000) 		--冷却时间(秒)
	self.bossRoomInfo.accelerateCost = accelerateCost		--加速所需钻石
    self.bossRoomInfo.inspire = inspire  				    --当前鼓舞值
    self.bossRoomInfo.myRank = myRank 					    --玩家的伤害排名
    self.bossRoomInfo.bossLevel = bossLevel 			    --世界Boss的等级
    self.bossRoomInfo.diamondCDTime = dimaCDTime            -- 钻石鼓舞CD
    self.bossRoomInfo.goldCDTime = goldCDTime               -- 金币鼓舞CD
    self.bossRoomInfo.bossState = bossState                 -- boss状态
    self.bossRoomInfo.openTime = openTime                   -- 开启时间
	for i = 0 , rankPlayerName:size() - 1 do
		table.insert( self.bossRoomInfo.rankPlayerId  , rankPlayerId:get(i) )
		table.insert( self.bossRoomInfo.rankPlayerName  , rankPlayerName:get(i) )
		table.insert( self.bossRoomInfo.rankHurt  , rankHurt:get(i))
    end

    for k, v in pairs(self.bossRoomInfo) do
        if type(v) ~= "table" then
            WZLog("--------------world boss-------------",k,v)
        end
    end


    -- 设置鼓舞状态、
    SceneWorldBoss:_setCurInspireState(inspire)

	self:_updateRoomInfo()
end

-- 开始挑战
function SceneWorldBoss:receiveStartOk(
    battleId, mapId, playerCount, playerId, playerName, playerTitle, playerGuild, playerLevel, playerSex,
    maxHP, maxPF, maxSP, attack, critRate, defence, injuryFree, wreckDefense, reduceCrit, power, armor,
    constitution, agility, lucky, insptre, headId, faceId, bodyId, weaponId, wingId, item_id, playerBuffCount,
    buffId, petId, petSkill, petParam, guaiBattleId, guaiId, guaiMaxHP, guaiNowHP,guaiAtk,guaiLv,weaponSkill,petLevel, colour, bodyColour,footmark)
	WZLog("SceneWorldBoss:receiveStartOk")


    for i , v in pairs( attack ) do
		WZLog("SceneWorldBoss:receiveStartOk attack = " , v )
	end
    WBattleGlobal:getCurrent():destroy()
	WBattleGlobal:getCurrent().m_tMakePairOk ={
        battleId=battleId,battleMode=BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS, battleMull=false, battleChannle=-1,
        mapId=mapId,playerCount=playerCount,playerId=playerId,playerName=playerName,playerTitle=playerTitle,playerCommunity=playerGuild,
        playerLevel=playerLevel,playerSex=playerSex,maxHP=maxHP,maxPF=maxPF,maxSP=maxSP,attack=attack,critRate=critRate,defence=defence,
        injuryFree=injuryFree,wreckDefense=wreckDefense,reduceCrit=reduceCrit,power=power,armor=armor,constitution=constitution,agility=agility,
        lucky=lucky,insptre=insptre,headId=headId,faceId=faceId,bodyId=bodyId,weaponId=weaponId,wingId=wingId,item_id=item_id,playerBuffCount,
        buffId=buffId,petId=petId,petSkill = petSkill,petLevel=petLevel,petSkillId=petId,petParam=petParam,guaiBattleId=guaiBattleId,guaiId=guaiId,guaiMaxHP=guaiMaxHP,guaiNowHP=guaiNowHP,guaiAtk=guaiAtk,guaiLv = guaiLv,weaponSkill=weaponSkill, 
        colour=colour, bodyColour=bodyColour,footmark = footmark
    }
	WBattleGlobal:getCurrent().m_nBattleType = BattleConstants.g_nBATTLE_TYPE_BOSS
    WBattleGlobal:getCurrent().battleMode = BattleConstants.g_tBossBattleMode.MODE_WORLDBOSS
	replaceScene(SceneBattleLoading:createElement())
	--@brief   关闭加载框
	self:closeLoading()
end

-- 世界boss战斗结束
function SceneWorldBoss:setResultInfo(data)
    if not self.m_root then return end
    if data.isWin then
        self.bossRoomInfo.bossState = 2
    else
        self.bossRoomInfo.bossState = 3
    end
    self.resultData = data
    self:_initBtnInfo()
end

--@brief    设置退出世界boss回调
function SceneWorldBoss:setCallBackFun(tCell, func)
    -- body
    self.m_tReturnCallBack = {}
    self.m_tReturnCallBack[1] = tCell
    self.m_tReturnCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 初始化排行榜奖励的信息和击杀信息
function SceneWorldBoss:initRewardRankInfo()
    local killInfo = {} -- 击杀信息
    local rankInfo = {} -- 排行榜信息
    -- type = 1 表示击杀奖励，type = 2 表示排行奖励
    for k,v in pairs(GDatatab_world_boss_reward) do
        local mapId = v.map_id
        if v.type == 1 then
            if not killInfo[mapId] then killInfo[mapId] = {} end
            table.insert(killInfo[mapId],v)
        elseif v.type == 2 then
            if not rankInfo[mapId] then rankInfo[mapId] = {} end
            table.insert(rankInfo[mapId],v)
        end
    end

    -- 根据id排序
    local function sort(info1,info2)
        if info1.id < info2.id then return true end
        return false
    end

    for k,v in pairs(killInfo) do
        table.sort(v,sort)
    end

    for k,v in pairs(rankInfo) do
        table.sort(v,sort)
    end

    self.killInfo = killInfo       -- 击杀奖励
    self.rankInfo = rankInfo       -- 击杀奖励
end

-- 伤害排行榜
function SceneWorldBoss:_initHurtRankInfo()
    local myName = CacheCenter:getPlayerInfo().name
    self.hurtInfo = {}
    local rankInfo = {}
    for i = 1 , #self.bossRoomInfo.rankPlayerName do
        local info = {id = self.bossRoomInfo.rankPlayerId[i],name = self.bossRoomInfo.rankPlayerName[i], hurt = self.bossRoomInfo.rankHurt[i] }
        table.insert(rankInfo,info)
    end

    -- 按伤害排名
    local function sort(info1,info2)
        if info1.hurt > info2.hurt then return true end
        return false
    end
    table.sort(rankInfo,sort)

    -- 除自己以外的排行信息放到排行榜中
    WZLog("--------------fight person cnt----------",#rankInfo)
    for i = 1, #rankInfo do
        if rankInfo[i].name ~= myName then
            rankInfo[i].rank = i
            table.insert(self.hurtInfo,rankInfo[i])
        end
    end

    -- 插入自己的信息,放在第一位(参加过战斗)
    if self.bossRoomInfo.hurt > 0 then
        WZLog("---------insert my info----------",myName,self.bossRoomInfo.hurt,self.bossRoomInfo.myRank)
        local myInfo = {id = CacheCenter:getPlayerInfo().id,name = myName, hurt = self.bossRoomInfo.hurt, rank = self.bossRoomInfo.myRank}
        table.insert(self.hurtInfo,1,myInfo)
    end
end

-- 初始化当前鼓舞状态
-- startP 开始鼓舞值
-- endP 结束鼓舞值
-- bFlag 是否处于鼓舞状态
function SceneWorldBoss:_initInspireState()
    self.inspireData = {startP = 0, endP = 0, bFlag = false}
end

function SceneWorldBoss:_setCurInspireState(inspire)
    if self.inspireData.bFlag then
        self.inspireData.endP = self.bossRoomInfo.inspire
    else
        self.inspireData.startP = self.bossRoomInfo.inspire
    end
end
-------------------------------------私有方法模块End----------------------------------------