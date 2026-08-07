--SceneWorldTeamBossData.lua
--@brief	SceneWorldTeamBoss的数据模块
--@date		2018/07/10
--@author	Tianxiang_Xu
--@note		世界组队boss界面

SceneWorldTeamBoss = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneWorldTeamBoss:_init()
	self.m_root = nil	 	  			--场景根节点
	self.bRewardRank = nil      -- 奖励排行是否创建，防止重复创建
    self.checkIndex = 1         -- 当前选中的checkbox下标 1为伤害排行，2为房间，3位奖励排行
    self.bossRoomInfo = {}     -- boss房间信息
    self.rankInfo = nil         -- 击杀奖励
    self.hurtInfo = nil         -- 伤害信息
    self.lastInspire = nil
    self.inspireData = {}   -- 鼓舞标志
    self.resultData = nil
    self.openTime = nil     -- 开启剩余时间
    self.m_tReturnCallBack = nil 
    self.m_tRoomList = nil 
    self.loadingId = nil 
    self.m_nCount = 0
    self.m_tSearchRoomData = nil 
    self.m_tSysConfig = nil 	--系统配置
    self.m_nMonsterAniIndex = 1     --怪物动作索引
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneWorldTeamBoss:_unInit()
	self.m_root = nil
	self.bRewardRank = nil
    self.checkIndex = nil
    self.bossRoomInfo = nil
    self.rankInfo = nil             -- 击杀奖励
    self.hurtInfo = nil             -- 伤害信息
    self.lastInspire = nil
    self.inspireData = nil
    self.resultData = nil
    self.openTime = nil
    self.m_tReturnCallBack = nil 
    self.m_tRoomList = nil 
    self.loadingId = nil 
    self.m_nCount = nil 
    self.m_tSearchRoomData = nil 
    self.m_tSysConfig = nil 	--系统配置
    self.m_nMonsterAniIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneWorldTeamBoss:createElement()
	if SceneWorldTeamBoss.m_root ~= nil then
		WindowManager:removeWindow(SceneWorldTeamBoss.m_root, SceneWorldTeamBoss, true)
	end
	local element = WZUISystem:getInstance():createElement("SceneWorldTeamBoss")
	assert(element, "SceneWorldTeamBoss create element failed!")
	self:_init()
	return element
end

--@brief   外部接口
function SceneWorldTeamBoss:showInterface()
    local scene = SceneWorldTeamBoss:createElement()
    replaceScene( scene )
end

--mapId	int	地图id
--maxHp	int	boss总血量
--bossBloodCurrent	int	boss当前血量
--inspire	int	当前鼓舞值（最大10000）
--myRank	int	我的伤害排名（0表示没有伤害）
--dimaCDTime	int	钻石鼓舞冷却时间(秒)
--goldCDTime	int	金币鼓舞冷却时间(秒)
--bossState	    int	BOSS状态 1 活着， 2死亡  3逃走
function SceneWorldTeamBoss:setEnterRoomData( mapId, bossBloodCurrent, inspire, dimaCDTime, goldCDTime, bossState, openTime, challengeNum, leaveNum, maxHp)
    self:closeLoading()
	if not self.m_root then return end
    if self.bossRoomInfo == nil then self.bossRoomInfo = {} end

	self.bossRoomInfo.mapId = mapId 				     	--房间地图id
	local bossData = GDatatab_team_world_boss_map["id_" .. mapId]
	self.bossRoomInfo.bossBloodMax = maxHp	 		--boss总血量
	self.bossRoomInfo.bossBloodCurrent = bossBloodCurrent	--boss当前血量
	
    self.bossRoomInfo.inspire = inspire  				    --当前鼓舞值
    self.bossRoomInfo.bossLevel = GDatatab_monster["id_" .. bossData.monster[1][1]].level 			    --Boss的等级
    self.bossRoomInfo.diamondCDTime = dimaCDTime            -- 钻石鼓舞CD
    self.bossRoomInfo.goldCDTime = goldCDTime               -- 金币鼓舞CD
    self.bossRoomInfo.bossState = bossState                 -- boss状态
    self.bossRoomInfo.openTime = openTime                   -- 开启时间
    self.bossRoomInfo.totalNum = challengeNum                   -- 总挑战次数
    self.bossRoomInfo.leftNum = leaveNum                   -- 剩余挑战次数
    WZLog("SceneWorldTeamBoss:setEnterRoomData", self.bossRoomInfo.totalNum, self.bossRoomInfo.leftNum, self.bossRoomInfo.openTime, self.bossRoomInfo.bossState, self.bossRoomInfo.bossBloodCurrent)
    -- 设置鼓舞状态、
    self:_setCurInspireState(inspire)

	self:_updateRoomInfo()
end

-- 世界boss战斗结束
function SceneWorldTeamBoss:setResultInfo(data)
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
function SceneWorldTeamBoss:setCallBackFun(tCell, func)
    -- body
    self.m_tReturnCallBack = {}
    self.m_tReturnCallBack[1] = tCell
    self.m_tReturnCallBack[2] = func
end

--@brief 	设置伤害榜数据
function SceneWorldTeamBoss:setHurtList(rankPlayerCount, rankPlayerId,rankPlayerName, rankPlayerSex, rankPlayerHeadId, rankPlayerFaceId, rankPlayerHeadColor, rankPlayerVipLevel, rankHurt, level, myRank, myHurt)
	-- body
	self:closeLoading()
	local nIndex = 1
    self.hurtInfo = {}
    for i = 1, #rankPlayerCount do
    	local tItem = {}
    	tItem.rank = i
    	tItem.count = rankPlayerCount[i]
    	tItem.hurt = rankHurt[i]
    	tItem.player = {}
    	for k = 1, rankPlayerCount[i] do
    		local tempPlayer = {}
    		tempPlayer.playerId = rankPlayerId[nIndex]
    		tempPlayer.name = rankPlayerName[nIndex]
    		tempPlayer.sex = rankPlayerSex[nIndex]
    		tempPlayer.headId = rankPlayerHeadId[nIndex]
    		tempPlayer.faceId = rankPlayerFaceId[nIndex]
    		tempPlayer.headColor = rankPlayerHeadColor[nIndex]
    		tempPlayer.vipLevel = rankPlayerVipLevel[nIndex]
    		tempPlayer.level = level[nIndex]

    		table.insert(tItem.player, tempPlayer)

    		nIndex = nIndex + 1
    	end
    	table.insert(self.hurtInfo, tItem)
    end

    self.bossRoomInfo.myRank = myRank
    self.bossRoomInfo.hurt = myHurt
    WZLog("SceneWorldTeamBoss:setHurtList", Serialize(self.hurtInfo), self.bossRoomInfo.myRank, self.bossRoomInfo.hurt)

    self:_createHurtRank()
end

--@brief 	获取房间数据成功
function SceneWorldTeamBoss:getRoomListOk(roomId, passWord, playerCount, state, roomName, playerId, playerName, sex, headId, faceId, headColor, vipLevel, maxNum)
	-- body
	self:closeLoading()
	self.m_tRoomList = {}

	local nIndex = 1
	for i = 1, #roomId do
		local tItem = {}

		tItem.roomId = roomId[i]
		tItem.passWord = passWord[i]
		tItem.count = playerCount[i]
		tItem.state = state[i]
		tItem.roomName = roomName[i]
		tItem.maxNum = maxNum[i]
		tItem.player = {}
		for k = 1, playerCount[i] do
			local tPlayer = {}

			tPlayer.playerId = playerId[nIndex]
			tPlayer.name = playerName[nIndex]
			tPlayer.sex = sex[nIndex]
			tPlayer.headId = headId[nIndex]
			tPlayer.faceId = faceId[nIndex]
			tPlayer.headColor = headColor[nIndex]
			tPlayer.vipLevel = vipLevel[nIndex]

			table.insert(tItem.player, tPlayer)	

			nIndex = nIndex + 1	
		end

		table.insert(self.m_tRoomList, tItem)
	end

	table.sort(self.m_tRoomList, function (a,b)
		-- body
		return a.state < b.state
	end)

	WZLog("SceneWorldTeamBoss:getRoomListOk", Serialize(self.m_tRoomList))
	
	self:_createRoomList()
end


--@brief	找到房间，但需要密码
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneWorldTeamBoss:receiveSelectRoomOk(roomId, password)
    WZLog("SceneWorldTeamBoss:receiveSelectRoomOk")
    if self.m_root == nil then return end
    self:closeLoadingBox()
	self.m_tSearchRoomData = {roomId=roomId, password=password}
	self:enterRoomPassword()
end

--@brief	查找房间失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneWorldTeamBoss:receiveSelectRoomFail()
    WZLog("SceneWorldTeamBoss:receiveSelectRoomFail")
    self:closeLoadingBox()
end

--@brief	快速游戏错误
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneWorldTeamBoss:receiveQuickGameFail()
	WZLog("SceneWorldTeamBoss:receiveQuickGameFail")
    self:closeLoadingBox()
end

--@brief	创建房间失败
--@param	入参与服务端发送给客户端的协议回调方法参数相同
function SceneWorldTeamBoss:receiveCreateRoomFail(nFlag, sMessage)
    WZLog("SceneWorldTeamBoss:receiveCreateRoomFail")
    self:closeLoadingBox()
end

--@brief 	鼓舞结果
function SceneWorldTeamBoss:inspireResult(inspire, goldCDTime, diamondCDTime)
	-- body
	WZLog("SceneWorldTeamBoss:inspireResult", inspire, goldCDTime, diamondCDTime)
    if self.m_root == nil then return end 
    
	self.bossRoomInfo.diamondCDTime = diamondCDTime         -- 钻石鼓舞CD
    self.bossRoomInfo.goldCDTime = goldCDTime               -- 金币鼓舞CD
    self.bossRoomInfo.inspire = inspire 
	-- 设置鼓舞状态、
    self:_setCurInspireState(inspire)

	self:_updateRoomInfo(true)
end

--@brief    更新挑战次数
function SceneWorldTeamBoss:updateChallengeTimes(times)
    -- body
    self:closeLoadingBox()

    self.bossRoomInfo.leftNum = times
    self:_setLeftTimes()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 初始化排行榜奖励的信息和击杀信息
function SceneWorldTeamBoss:initRewardRankInfo()
    local rankInfo = {} -- 排行榜信息
    -- type = 1 表示击杀奖励，type = 2 表示排行奖励
    for k,v in pairs(GDatatab_team_world_boss_reward) do
        local mapId = v.map_id
        
        if not rankInfo[mapId] then rankInfo[mapId] = {} end
        table.insert(rankInfo[mapId],v)
    end

    -- 根据id排序
    local function sort(info1,info2)
        if info1.id < info2.id then return true end
        return false
    end

    for k,v in pairs(rankInfo) do
        table.sort(v,sort)
    end

    self.rankInfo = rankInfo       -- 击杀奖励
end

-- 初始化当前鼓舞状态
-- startP 开始鼓舞值
-- endP 结束鼓舞值
-- bFlag 是否处于鼓舞状态
function SceneWorldTeamBoss:_initInspireState()
    self.inspireData = {startP = 0, endP = 0, bFlag = false}
end

function SceneWorldTeamBoss:_setCurInspireState(inspire)
    if self.inspireData.bFlag then
        self.inspireData.endP = self.bossRoomInfo.inspire
    else
        self.inspireData.startP = self.bossRoomInfo.inspire
    end
end

function SceneWorldTeamBoss:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(10,self,self.closeLoadingBox)
    end
end

function SceneWorldTeamBoss:closeLoadingBox()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end

--@brief    挑战次数判断
function SceneWorldTeamBoss:_challengeTimesJudge()
    -- body
 --   do return true end 
    if self.bossRoomInfo.leftNum <= 0 then
        local num = self.bossRoomInfo.totalNum - self.m_tSysConfig.freeNum
        local buyData = self:getVipLimitData(num + 1)
        if buyData == nil then
            MsgBoxManager:showTipBox(LocalStrings.CHALLEGE_OVER)
        else
            local playerInfo = CacheCenter:getPlayerInfo()
            if playerInfo.vipLevel >= buyData.vip_level then
                local basicData = GDatatab_item["id_" .. buyData.cost[1][1]]
                local sContent = string.format(LocalStrings.TEAMBOSS_TEXT14, buyData.cost[1][2], basicData.icon)
                MsgBoxManager:showConfirmBox(sContent, self, self.sureToBuyTimes)
            else
                local sContent = string.format(LocalStrings.TEAMBOSS_TEXT15, buyData.vip_level)
                MsgBoxManager:showConfirmBox(sContent, self, self.sureToRecharge)
            end
        end
        return false
    else
        return true
    end
end

--@brief    挑战状态判断
function SceneWorldTeamBoss:_challengeStateJudge()
    -- body
    -- boss存活 boss死亡2 boss逃跑3 不能鼓舞
    if self.bossRoomInfo.bossState == 1 and self.bossRoomInfo.openTime > 0 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT21)
        return false 
    elseif self.bossRoomInfo.bossState == 2 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT22)
        return false
    elseif self.bossRoomInfo.bossState == 3 then
        MsgBoxManager:showTipBox(LocalStrings.TEAMBOSS_TEXT20)
        return false
    end

    return true
end

--@brief    确定购买次数
function SceneWorldTeamBoss:sureToBuyTimes()
    -- body
    local num = self.bossRoomInfo.totalNum - self.m_tSysConfig.freeNum
    local buyData = self:getVipLimitData(num + 1)
    if buyData == nil then return end 

    if not JudgeMoneyIsEnough(buyData.cost[1][1], buyData.cost[1][2], nil, nil, Chat_Channel_WorldTeam_Boss, nil, nil, nil, nil, self, self.sureToUseDiaInstead) then
        return
    end

    self:sureToUseDiaInstead()
end

--@brief    确定使用蓝钻代替粉钻购买
function SceneWorldTeamBoss:sureToUseDiaInstead()
    -- body
    self:createLoadingBox()
    ProtocolProcessorWorldTeamBossRoom:send_TEAMWORLDBOSS_BuyChallengeNum()
end

--@brief    确定充值
function SceneWorldTeamBoss:sureToRecharge()
    --body
    PassportSdkManager:gotoPaymentPage()
end

--@brief    根据购买次数获取限购数据
function SceneWorldTeamBoss:getVipLimitData(times)
    -- body
    for i, value in pairs(GDatatab_vip_restriction) do
        if value.type == 26 and value.count == times then
            return value
        end
    end

    return nil 
end
-------------------------------------私有方法模块End----------------------------------------
