--CellFootballGameData.lua
--@brief	CellFootballGame的数据模块
--@date		2018/05/16
--@author	peiting_mao
--@note		点球大战

CellFootballGame = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellFootballGame:_init()
	self.m_root = nil	 	  			--场景根节点
	self.aniPlayer = nil
	self.animNode = nil
	self.pos = {}
	self.rewardId = nil
	self.rank = nil
	self.rewardItemNum = nil
	self.rewardCount = nil
	self.m_tRewardList = {}
	--self.addScore = nil 	--进球成功加分数
	--self.failAddScore = nil --进球失败加分数
	self.costNum = nil --踢球消耗的物品数量
	self.costId = nil 	--踢球消耗的物品id
	self._isFootBall = 0 	--判断是排行榜界面还是踢球界面，0：踢球界面，1：排行榜界面
	self.rankTop = nil 	--前三名的排名信息
	self.myRank = nil 	--我的排名信息
	self.myScore = nil 	--我的积分
	self._monstPos = nil 	--进球失败，球落点的位置
	--self.isDoor = nil 	--判断球是否进框
	--self.m_touch = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellFootballGame:_unInit()
	self.m_root = nil
	self.aniPlayer = nil
	self.animNode = nil
	self.pos = nil
	self.rewardId = nil
	self.rank = nil
	self.rewardItemNum = nil
	self.rewardCount = nil
	self.m_tRewardList = nil
	--self.addScore = nil
	--self.failAddScore = nil
	self.costNum = nil
	self.costId = nil
	self._isFootBall = nil
	self.rankTop = nil
	self.myRank = nil
	self.myScore = nil
	self.m_tLine = nil
	self._monstPos = nil
	--self.isDoor = nil
	--self.m_touch = nil
	--self.m_pointsLine = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellFootballGame:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellFootballGame table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellFootballGame")
	assert(element, "CellFootballGame element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	获得排行榜奖励
function CellFootballGame:_createRewardList( )
	local itemIndex = 1
    for i = 1, #self.rewardCount do
        local item_data = {}
        item_data.rank = self.rank[i]
        WZLog("CellFootballGame:_createRewardList",item_data.rank)
        local itemCount = self.rewardCount[i]
        local tData = {}
        for j = 1, itemCount do
            local t_item = {id = self.rewardId[itemIndex], num = self.rewardItemNum[itemIndex]}
            table.insert(tData, t_item)
            itemIndex = itemIndex + 1
        end
        item_data.m_tData = tData
        table.insert(self.m_tRewardList, item_data)
    end
    WZLog("-dgagad-----235345---",Serialize(self.m_tRewardList))
end

function CellFootballGame:setMessage(rank,rewardId,rewardItemNum,rewardCount, count)
	--WZLog("--dgadga-----233545",Serialize(rank),Serialize(rewardId),Serialize(rewardItemNum),Serialize(rewardCount))
	self.rank = rank
	self.rewardId = rewardId
	self.rewardItemNum = rewardItemNum
	self.rewardCount = rewardCount
	WndFootballActivity.m_nPreResult = count
	self:_createRewardList()

	WZLog("CellFootballGame:setMessage", WndFootballActivity.m_nPreResult, Serialize(self.rank))
	--self.m_touch = BattleTouch:create()	
end

--@brief	获取前三名的积分情况和自己的排名积分情况
function CellFootballGame:getPlayerScore( status, ranking,name,score,myRank )
	WZLog("-dg-aga-----111",Serialize(ranking),Serialize(name),Serialize(score),myRank,status)
	self.rankTop = {}

	if #ranking > 0 then
		for i=1,#ranking do
			if i > 3 then
				break
			end
			local tData = {rank = ranking[i],name = name[i],score = score[i]}
			table.insert(self.rankTop,tData)
		end
	end
	WZLog("-d-gag-----3334",Serialize(self.rankTop))
	self.myRank = myRank
	self.myScore = status
	self:_initUI()
end

function CellFootballGame:_monstRun1(  )
	local spine = GetElement(CellFootballGame.m_current.m_root,"spineMonster_CellFootballGame",WZUISpine)
	spine:play("wait",true)

	local conMonster = GetElement(CellFootballGame.m_current.m_root,"conMonster_CellFootballGame",WZUIContainer)
	local monstPos = CCPoint(CellFootballGame.m_current._monstPos.x,CellFootballGame.m_current._monstPos.y)
	
	--WZLog("-d-gag------35454",monstPos.x,monstPos.y)
	
	local move = CCMoveTo:create(0, CCPoint(monstPos.x,monstPos.y))
	conMonster:runAction(move)
end

function CellFootballGame:_monstRun2(  )
	local spine = GetElement(CellFootballGame.m_current.m_root,"spineMonster_CellFootballGame",WZUISpine)
	spine:play("wait",true)

	local conMonster = GetElement(CellFootballGame.m_current.m_root,"conMonster_CellFootballGame",WZUIContainer)
	local move = WZUIActionMoveTo:create()
	move:setMoveX(CellFootballGame.m_current.pos.monsterX)
	move:setMoveY(CellFootballGame.m_current.pos.monsterY)
	move:setDuration(0.2)
	conMonster:runUIAction(move)
end

-- function CellFootballGame:_monstWait(  )
-- 	local spine = GetElement(CellFootballGame.m_current.m_root,"spineMonster_CellFootballGame",WZUISpine)
-- 	spine:play("wait",true)
-- end

--@brief 	进球成功提示语
function CellFootballGame:_isDoorTure(  )
	local penaltyConfig = json.decode(CacheCenter:getGameParam()["penaltyConfig"])
	local addScore = penaltyConfig.addScore
	local tips = string.format(LocalStrings.FOOTBALL_SUCCESS,tonumber(addScore))
	MsgBoxManager:showTipBox(tips)
end

--@brief 	进球失败提示语
function CellFootballGame:_isDoorFalse(  )
	local penaltyConfig = json.decode(CacheCenter:getGameParam()["penaltyConfig"])
	local failAddScore = penaltyConfig.failAddScore
	local tips = string.format(LocalStrings.FOOTBALL_FAIL,tonumber(failAddScore))
	MsgBoxManager:showTipBox(tips)
end

--@brief	接收踢球后的协议返回数据
--@brief 	status：1 进球成功，2 进球失败
function CellFootballGame:getResult(status, goal)
	WZLog("--dagagfa---35",status)
	if CellFootballGame.m_current.m_root == nil then return end 

	if goal then
		WndFootballActivity.m_nPreResult = goal
		WZLog("CellFootballGame:getResult", WndFootballActivity.m_nPreResult)
		return 
	end

	local conMonster = GetElement(CellFootballGame.m_current.m_root,"conMonster_CellFootballGame",WZUIContainer)
	local monstPos = CCPoint(CellFootballGame.m_current._monstPos.x,CellFootballGame.m_current._monstPos.y)
	local touch = BattleTouch:create()
	local pos = touch:pointWorldToNode(conMonster,monstPos)

	local array = nil
	local action = nil

	if status == 1 then	--播放进球成功特效
		array = CCArray:create()

		if pos.x <= 50 and pos.y <=50 then --球落点的位置和怪物接近时
			array:addObject(CCCallFuncN:create(self._moveMonsterPos)) --怪物返回原点
			array:addObject(CCDelayTime:create(0.2))
			array:addObject(CCCallFuncN:create(self._monstRun2))
		end
		array:addObject(CCCallFuncN:create(self._isDoorTure))
		array:addObject(CCDelayTime:create(0.5))
		array:addObject(CCCallFuncN:create(self._playerRun2))
		array:addObject(CCDelayTime:create(0.5))
		array:addObject(CCCallFuncN:create(self._playerWait))
		array:addObject(CCDelayTime:create(0.5))
		array:addObject(CCCallFuncN:create(self._isImgTrue))

		action = CCSequence:create(array)
		CellFootballGame.m_current.m_root:runAction(action)
	elseif status == 2 then 
		array = CCArray:create()
		array:addObject(CCCallFuncN:create(self._monstRun1)) --怪物拦截
		--array:addObject(CCDelayTime:create(0.2))
		--array:addObject(CCCallFuncN:create(self._monstWait))

		array:addObject(CCDelayTime:create(0.2))
		array:addObject(CCCallFuncN:create(self._isDoorFalse)) --弹进球失败提示框
		array:addObject(CCDelayTime:create(0.3))

		array:addObject(CCCallFuncN:create(self._playerRun2)) 	--人物返回原点
		array:addObject(CCDelayTime:create(0.5))
		array:addObject(CCCallFuncN:create(self._isImgTrue))
		array:addObject(CCDelayTime:create(0.5))
		array:addObject(CCCallFuncN:create(self._playerWait))
		array:addObject(CCDelayTime:create(0.1))

		array:addObject(CCCallFuncN:create(self._monstRun2)) --怪物返回原点
		--array:addObject(CCDelayTime:create(0.5))
		--array:addObject(CCCallFuncN:create(self._monstWait))

		action = CCSequence:create(array)
		CellFootballGame.m_current.m_root:runAction(action)
	end
end

--@brief	人物回到原点
function CellFootballGame:_playerBack(  )
	local conPlayer = GetElement(CellFootballGame.m_current.m_root,"conPlayer_CellFootballGame",WZUIContainer)
	local arrayP = CCArray:create() --人物返回起始位置
	arrayP:addObject(CCCallFuncN:create(self._playerRun2))
	arrayP:addObject(CCDelayTime:create(0.5))
	arrayP:addObject(CCCallFuncN:create(self._isImgTrue))
	arrayP:addObject(CCDelayTime:create(0.2))
	arrayP:addObject(CCCallFuncN:create(self._playerWait))
	local actionP = CCSequence:create(arrayP)
	conPlayer:runAction(actionP)
end

--@brief	球进时，位置和怪物位置接近的话，移动怪物位置
function CellFootballGame:_moveMonsterPos( )
	local conMonster = GetElement(CellFootballGame.m_current.m_root,"conMonster_CellFootballGame",WZUIContainer)
	local monstPos = CCPoint(CellFootballGame.m_current._monstPos.x,CellFootballGame.m_current._monstPos.y+120)
	local move = CCMoveTo:create(0.3, monstPos)
	conMonster:runAction(move)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellFootballGame:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellFootballGame.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
