--WndPvpRankListData.lua
--@brief	WndPvpRankList的数据模块
--@date		2016-3-30
--@author	binshao
--@note		排位赛赛季奖励

WndPvpRankList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPvpRankList:_init()
	self.m_root = nil	 	  			--场景根节点
    self.matchReward = nil               -- 赛季奖励
    self.matchGoal = nil               -- 赛季目标
    self.cellData = {}
    self.getRewardData = nil    -- 保存领取的奖励
    self.loadingId = nil
    self.m_nMyRank = nil 
    self.m_tData = nil 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndPvpRankList:_unInit()
    self.m_root = nil
    self.matchReward = nil
    self.matchGoal = nil
    self.cellData = nil
    self.getRewardData = nil    -- 保存领取的奖励
    self.loadingId = nil
    self.m_nMyRank = nil 
    self.m_tData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPvpRankList:createElement()
	local element = WZUISystem:getInstance():createElement("WndPvpRankList")
	assert(element, "WndPvpRankList create element failed!")
	self:_init()
	return element
end

-- 设置目标的数据
function WndPvpRankList:setMatchReward(data)
    self.matchGoal = data
    self:createMatchGoal()
end

-- 设置cell的信息
function WndPvpRankList:setCellData(tag,cell,tcell)
    if not self.cellData then self.cellData = {} end
    if not self.cellData[tag] then self.cellData[tag] = {} end
    self.cellData[tag].cell = cell
    self.cellData[tag].tcell = tcell
end

-- 初始化周奖励
function WndPvpRankList:initMatchReward()
    self.matchReward = {}
    for k,v in pairs(GDatatab_trio_rank_match_config) do
        if v.reward ~= -1 and v.reward2 ~= -1 then
            if v.id == 1 or v.id == 999 then
                v.text = string.format(LocalStrings.PVP_RANK_TEXT7, v.dan)
            else
                v.text = string.format(LocalStrings.PVP_RANK_TEXT7, v.dan .. v.level2)
            end
            table.insert(self.matchReward,v)
        end
    end
    local function sort(r1,r2)
        return r1.id < r2.id
    end
    table.sort(self.matchReward,sort)
    --第一条奖励系统配置表配置记录
    local tItemTemp = {}
    local sFirstReward = CacheCenter:getGameParam()["trioRankFirstSeasonReward"]
    WZLog("WndPvpRankList:initMatchReward", sFirstReward)
    local tIds,tNums = SplitItemString(sFirstReward)
    tItemTemp.text = LocalStrings.PVP_RANK_TEXT6
    tItemTemp.reward = {}
    tItemTemp.reward2 = {}
    for i = 1, #tIds do
        local tBasicInfo = GDatatab_item["id_" .. tIds[i]]
        if tBasicInfo then
            local tItem = {}
            if tBasicInfo.sex == 0 then
                tItem[1] = tIds[i]
                tItem[2] = tNums[i]

                table.insert(tItemTemp.reward, tItem)
            elseif tBasicInfo.sex == 1 then
                tItem[1] = tIds[i]
                tItem[2] = tNums[i]

                table.insert(tItemTemp.reward2, tItem)
            else
                tItem[1] = tIds[i]
                tItem[2] = tNums[i]

                table.insert(tItemTemp.reward, tItem)
                table.insert(tItemTemp.reward2, tItem)
            end
        end
    end

    table.insert(self.matchReward, 1, tItemTemp)
end

-- 设置领取的奖励数据
function WndPvpRankList:setGetRewardData(data)
    self.getRewardData = data
end


--@brief    设置赛季排行数据
function WndPvpRankList:setRankData(rank, serverId, playerId, name, faceId, headId, headColor, sex, level, vipLevel, matchLevel, matchScore, matchConfigId, battleTimes, winTimes, playerRank, playerMatchLevel, playerMatchSocre, playerMatchConfigId)
    -- body
    if self.matchGoal == nil then
        self.matchGoal = {}
    end

    for i = 0, rank:size() - 1 do
        local tItem = {}
        tItem.rank = rank:get(i)
        tItem.id = playerId:get(i)
        tItem.name = name:get(i)
        tItem.faceId = faceId:get(i)
        tItem.headId = headId:get(i)
        tItem.sex = sex:get(i)
        tItem.vipLevel = vipLevel:get(i)
        tItem.matchLevel = matchLevel:get(i)
        tItem.matchScore = matchScore:get(i)
        tItem.matchConfigId = matchConfigId:get(i)
        tItem.level = level:get(i)
        tItem.serverId = serverId:get(i)
        tItem.headColor = headColor:get(i)
        tItem.attendNum = battleTimes:get(i)
        tItem.winNum = winTimes:get(i)

        table.insert(self.matchGoal, tItem)
    end
    table.sort(self.matchGoal, function (a,b)
        -- body
        return a.rank < b.rank 
    end)
    self.m_nMyRank = playerRank 

    self:createMatchGoal()
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------