--WndAthRankData.lua
--@brief	WndAthRank的数据模块
--@date		2015-6-6
--@author	binshao
--@note		竞技场奖励

WndAthRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAthRank:_init()
	self.m_root = nil	 	    -- 场景根节点
    self.checkIndex = 1         -- 右边标题index
    self.topIndex = 4           -- 上面的标题index
    self.rankType = 1           -- 1：本服  2：全服
    self.rankLvLimit = {}
    self.myRankIndex = 0


    -- 排行榜数据
    self.rankInfo = {}         -- 竞技场排行榜排行信息
    self.rankIndex = 1          -- 竞技排行榜加载cell的index

    -- 历史排行数据
    self.lastInfo = {}         -- 竞技场昨日排行信息
    self.rankIndex = 1          -- 竞技场昨日排行加载cell的index
    self.lastFlag = true        -- 竞技场昨日排行是否创建

    -- 奖励
    self.rewardInfo = {}       -- 竞技场排行榜奖励信息
    self.rewardIndex = 1        -- 竞技奖励加载cell的index
    self.rewardFlag = true      -- 奖励界面是否创建

    -- 排行榜个人数据
    self.myRank = nil

    self.tab_SendRecord = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAthRank:_unInit()
    self.m_root = nil	 	    -- 场景根节点
    self.checkIndex = 1         -- 右边标题index
    self.topIndex = nil           -- 上面的标题index
    self.rankLvLimit = nil
    self.rankType = nil
    -- 排行榜数据
    self.rankInfo = nil         -- 竞技场排行榜排行信息
    self.rankIndex = 1          -- 竞技排行榜加载cell的index
    self.rankFlag = {}        -- 竞技排行榜是否创建

    -- 历史排行数据
    self.lastInfo = nil         -- 竞技场昨日排行信息
    self.lastIndex = 1          -- 竞技场昨日排行加载cell的index
    self.lastFlag = {}        -- 竞技场昨日排行是否创建

    -- 奖励
    self.rewardInfo = nil       -- 竞技场排行榜奖励信息
    self.rewardIndex = 1        -- 竞技奖励加载cell的index
    self.rewardFlag = {}      -- 奖励界面是否创建

    -- 排行榜个人数据
    self.myRank = nil
    self.myRankIndex = nil

    self.tab_SendRecord = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAthRank:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
	local element = WZUISystem:getInstance():createElement("WndAthRank")
	assert(element, "WndAthRank create element failed!")
	self:_init()
	return element
end

function WndAthRank:showAthRank()
    -- body
    WZLog("WndAthRank:showAthRank")
    if WndAthRank and WndAthRank.m_root == nil then
        local wnd = WndAthRank:createElement()
        WindowManager:addWindow(wnd, WndAthRank,false,false,nil,true)
    end
end

function WndAthRank:initRewardData()
    for k,v in pairs(GDatatab_pk_rank_reward) do
        self.rewardInfo[v.type] = {}
    end
    for k,v in pairs(GDatatab_pk_rank_reward) do
        table.insert(self.rewardInfo[v.type],v)
    end

    local function sort(r1,r2)
        return r1.id < r2.id
    end

    for i = 1, #self.rewardInfo do
        table.sort(self.rewardInfo[i],sort)
    end
end

-- 设置排行数据
function WndAthRank:setRankData(rank,playerId,name,faceId,headId,sex,level,athScore,athCnt,athWinCnt,serverId,vipLv,headColor,index)
    self.rankInfo[index] = {}
    for i = 0, playerId:size()-1 do
        local info = {}
        info.rank = rank:get(i)
        info.playerId = playerId:get(i)
        info.name = name:get(i)
        info.faceId = faceId:get(i)
        info.headId = headId:get(i)
        info.sex = sex:get(i)
        info.level = level:get(i)
        info.athScore = athScore:get(i)
        info.athCnt = athCnt:get(i)
        info.athWinCnt = athWinCnt:get(i)
        info.serverId = serverId:get(i)
        info.vipLv = vipLv:get(i)
        info.headColor = headColor:get(i)
        table.insert(self.rankInfo[index],info)
    end
    
    local indexx = self.topIndex
    if self.rankType == 1 then
        indexx = indexx + 4
    end
    WZLog("---------rankInfo----------",index,indexx)
    -- if index == indexx then
    --     self:update()
    -- end
    self:update()
end

-- 设置排行数据
function WndAthRank:setLastData(rank,playerId,name,faceId,headId,sex,level,athScore,athCnt,athWinCnt,serverId,vipLv,headColor,index)
    self.lastInfo[index] = {}
    for i = 0, playerId:size()-1 do
        local info = {}
        info.rank = rank:get(i)
        info.playerId = playerId:get(i)
        info.name = name:get(i)
        info.faceId = faceId:get(i)
        info.headId = headId:get(i)
        info.sex = sex:get(i)
        info.level = level:get(i)
        info.athScore = athScore:get(i)
        info.athCnt = athCnt:get(i)
        info.athWinCnt = athWinCnt:get(i)
        info.serverId = serverId:get(i)
        info.vipLv = vipLv:get(i)
        info.headColor = headColor:get(i)
        table.insert(self.lastInfo[index],info)
    end
    -- if index == self.topIndex then
    --     self:update()
    -- end
    self:update()
    WZLog("---------lastInfo----------",index,#self.lastInfo[index])
end

-- 设置我的排名
function WndAthRank:setMyRankData(cnt,winCnt,score,rank)
    WZLog("------------my info-----------",cnt,winCnt,score,rank)
    self.myRank = {cnt = cnt, winCnt = winCnt, rank = rank, score = score }
    --self:initMyRankIndex(rank)
    self:updateMyRank()
end

-- 初始化每个等级排行的等级限制
function WndAthRank:initRankLvLimit()
    WZLog("WndAthRank:initRankLvLimit")
    local lvLimit = CacheCenter:getGameParam().dailyWictoryLevelRange
    
    self.rankLvLimit = SplitStringWithSeparator(lvLimit, ",")
    local tournamentLevel = CacheCenter:getPlayerInfo().tournamentLevel
    for i = 1, 3 do
        local index = 2*(i-1) + 1
        if tournamentLevel >= tonumber(self.rankLvLimit[index]) and tournamentLevel <= tonumber(self.rankLvLimit[index+1]) then
            -- self.topIndex = i
            self.myRankIndex = i
        end
    end
    local cbgRankType = GetElement(self.m_root,"cbgRankType_WndAthRank",WZUICheckBoxGroup)
    if GlobalMethod:crossServiceOpen() == 0 then
        cbgRankType:setVisible(false)
    end
    WZLog("----------init topIndex-------------",self.topIndex)
    WZLog("---------------self.myRankIndex--------------",self.myRankIndex)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------