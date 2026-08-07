--SceneThrowingEggsData.lua
--@brief	SceneThrowingEggs的数据模块
--@date		2014/02/23
--@author	孙珊珊
--@note		副本战斗结束砸蛋功能

SceneThrowingEggs = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneThrowingEggs:_init()
	self.m_root = nil	 	  			--场景根节点
	self.nTag = -1                      --记录当前砸的蛋的索引
	self.nFreeTime = 0                  --规定的免费砸蛋时间
	self.nPayTime = 0                   --规定的付费砸蛋时间
	self.m_animationSprite1 = {}        --蛋蛋动画1，圆圆的蛋蛋
	self.m_animationSprite2 = {}        --蛋蛋动画2，砸开的动画
	self.m_animationSprite3 = {}        --蛋蛋动画3，裂开后的蛋蛋
	self.nEggAniType = {}               --记录蛋蛋动画类型
	self.m_nFreeThrowEggTimes = 0       --免费砸蛋的次数（也是当前所砸的免费蛋的索引）
	self.m_nPayThrowEggTimes = 2        --付费砸蛋的次数（也是当前所砸的付费蛋的索引）
    self.m_nEggType = 0                 --蛋蛋的类型
	--
	self.m_tPoint = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	
	self.m_nOtherplayerId = 0
	self.m_nAlreadyDiamodTime = 1       --已经成功钻石砸蛋的次数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneThrowingEggs:_unInit()
	self.m_root = nil
	self.nTag = nil
	self.tDate = nil
	self.nFreeTime = nil
	self.nPayTime = nil
	self.m_tEggIcon = nil
	self.m_tEggNum = nil
	self.m_animationSprite1 = nil
	self.m_animationSprite2 = nil
	self.m_animationSprite3 = nil
	self.nEggAniType = nil
	self.m_nFreeThrowEggTimes = nil
	self.m_nPayThrowEggTimes = nil
	self.m_nEggType = nil
	self.m_nDataA = nil
	self.m_nDataB = nil
	self.m_nDataC = nil
	self.m_tPoint = nil
	self.m_nHadThrowingEggCount = nil
	self.m_tPlayerOrderId = nil
	self.m_nOtherplayerId = nil
	self.m_tPlayerEggs = nil
	self.m_nShowDiaond = nil          
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneThrowingEggs:createElement()
	local element = WZUISystem:getInstance():createElement("SceneThrowingEggs")
	assert(element, "SceneThrowingEggs create element failed!")
	self:_init()
	return element
end

function SceneThrowingEggs:gameOver(battleId, firstHurtPlayerId, winCamp, playerCount, playerIds, shootRate, totalHurt, killCount, beKilledCount, addExp, Exp, upgradeExp, nextUpgradeExp, star, eggCount, egg_playeId, egg_Item_Name, egg_item_icon, egg_ItemNum, pices,playerId,playerName)

	--装蛋的数据表
	self.m_tData = {battleId=battleId, firstHurtPlayerId=firstHurtPlayerId, winCamp=winCamp, playerCount=playerCount, playerIds=playerIds, shootRate=shootRate, totalHurt=totalHurt, killCount=killCount, beKilledCount=beKilledCount,addExp=addExp ,Exp=Exp, upgradeExp=upgradeExp, nextUpgradeExp=nextUpgradeExp, star=star, egg_playeId=egg_playeId,egg_Item_Name=egg_Item_Name, egg_item_icon=egg_item_icon,egg_ItemNum = egg_ItemNum,eggCount=eggCount,pices=pices,playerId=playerId,playerName = playerName, }
	
	WZLog("##########################################")
	
	
	--存储对应的蛋蛋信息到玩家手中
	self.m_tPlayerEggs = {}
	for i=1,eggCount do
		if self.m_tPlayerEggs[egg_playeId[i]] == nil then
			self.m_tPlayerEggs[egg_playeId[i]] = {}
		end
		table.insert(self.m_tPlayerEggs[egg_playeId[i]],i)
	end
	
	--
	local tIndex = {3,6,15,4,7,16,18,1,14,2,8,17,5,11,9,10,12,13}
	self.m_tEggIcon = {} --打乱的蛋蛋图片
	self.m_tEggNum = {}  --打乱的蛋蛋数量
	for i=1,self.m_tData.eggCount do
		self.m_tEggIcon[i] = self.m_tData.egg_item_icon[tIndex[i]]
		self.m_tEggNum[i] = self.m_tData.egg_ItemNum[tIndex[i]]
	end
end

--@brief	其他人砸蛋成功回调
function SceneThrowingEggs:otherRewardOk(playerId)
	-----
	self.m_nOtherplayerId = playerId
	-----
	self:_palyOtherThrowEgg()
end

function SceneThrowingEggs:_palyOtherThrowEgg()
	--收到后就自爆别人的蛋蛋
	--self.m_nHadThrowingEggCount = self.m_nHadThrowingEggCount + 1
	local tag = self:getRandomEggTag()
	self:_startLottery(self.m_tPoint[tag],self.m_nOtherplayerId)
	table.remove(self.m_tPoint,tag)

end

--@brief	生成随机的砸蛋tag值
function SceneThrowingEggs:getRandomEggTag()
	--math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	local tag = math.random(1,#self.m_tPoint)
	--self.nTag = tag
	return tag
end

--@brief	通过玩家id获取玩家名称
--@param	nPlayerId:玩家id
function SceneThrowingEggs:getPlayerNameByPlayerId(nPlayerId)
	local index
	for i=1,#self.m_tData.playerId do
		if nPlayerId==self.m_tData.playerId[i] then
			index = i
		end
	end
	return self.m_tData.playerName[index]
end

--@brief	自己砸蛋成功回调
function SceneThrowingEggs:rewardOk()
	WZLog("SceneThrowingEggs:rewardOk()")
	if self.m_root == nil then 
		return 
	end 
	GlobalGame.g_tPlayerInfo.nTickets = GlobalGame.g_tPlayerInfo.nTickets - 
										self.m_tData.pices[self.m_nAlreadyDiamodTime]
	
	WZLog("#self.m_tData.pices = ",#self.m_tData.pices)
	for var = 1, #self.m_tData.pices do 
		WZLog("self.m_tData.pices[var] = ",self.m_tData.pices[var])
	end 
	if self.m_nAlreadyDiamodTime ~= 4 then 
		self.m_nAlreadyDiamodTime = self.m_nAlreadyDiamodTime + 1
	end 
	local txtZuan = self.m_root:getChildElement("txtZuan_SceneThrowingEggs")
	if txtZuan ~= nil then 
		WZUILabelTTF:luaTo(txtZuan):setText(tostring(self.m_tData.pices[self.m_nAlreadyDiamodTime]))
	end 
	
end 

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
