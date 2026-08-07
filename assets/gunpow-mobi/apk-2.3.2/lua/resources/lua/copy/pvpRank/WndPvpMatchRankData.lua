--WndPvpMatchRankData.lua
--@brief	WndPvpMatchRank的数据模块
--@date		2016-3-30
--@author	binshao
--@note		排位赛赛季奖励

WndPvpMatchRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPvpMatchRank:_init()
	self.m_root = nil	 	  			--场景根节点
    self.loadingId = nil
    self.rankFlag1 = false      -- 是否创建赛季排名列表
    self.rankFlag2 = false      -- 是否创建历史排名列表
    self.historyRank = nil      -- 历史排行数据
    self.titleIndex = 1         -- 标签index

    self.matchReward = nil 
    self.m_tRankReward = nil 
    self.m_nMyRank = nil 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndPvpMatchRank:_unInit()
    self.m_root = nil
    self.loadingId = nil
    self.rankFlag1 = false
    self.rankFlag2 = false
    self.historyRank = nil

    self.matchReward = nil 
    self.m_tRankReward = nil 
    self.m_nMyRank = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPvpMatchRank:createElement()
	local element = WZUISystem:getInstance():createElement("WndPvpMatchRank")
	assert(element, "WndPvpMatchRank create element failed!")
	self:_init()
	return element
end

function WndPvpMatchRank:setHistoryData(data)
    WZLog("----------set history data--------------")
    self.historyRank = data
    if self.titleIndex == 2 then
        self:createMatchRank2()
    end
end


-- 初始化周奖励
function WndPvpMatchRank:initMatchReward()
    self.matchReward = {}
    local tOtherRewardList = {}
    for k,v in pairs(GDatatab_trio_rank_match_config) do
        if v.reward ~= -1 and v.reward2 ~= -1 then
            local copyV = CopyTable(v)
            if v.id == 1 or v.id == 999 then
                v.text = string.format(LocalStrings.PVP_RANK_TEXT7, v.dan)
            else
                v.text = string.format(LocalStrings.PVP_RANK_TEXT7, v.dan .. v.level2)
            end

            table.insert(self.matchReward,v)
            --奖励3
            if copyV.reward3 ~= -1 then
                copyV.text = string.format(LocalStrings.PVP_RANK_TEXT8, copyV.dan)
                copyV.reward = copyV.reward3
                copyV.reward2 = copyV.reward3
                table.insert(tOtherRewardList, copyV)
            end
        elseif v.id == 17 then
            local copyV = CopyTable(v)
            if copyV.reward3 ~= -1 then
                copyV.text = string.format(LocalStrings.PVP_RANK_TEXT8, copyV.dan)
                copyV.reward = copyV.reward3
                copyV.reward2 = copyV.reward3
                table.insert(tOtherRewardList, copyV)
            end
        end
    end
    local function sort(r1,r2)
        return r1.id < r2.id
    end
    table.sort(self.matchReward,sort)
    table.sort(tOtherRewardList,sort)
    --第一条奖励系统配置表配置记录
    local tItemTemp = {}
    local sFirstReward = CacheCenter:getGameParam()["trioRankFirstSeasonReward"]
    WZLog("WndPvpMatchRank:initMatchReward", sFirstReward)
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
    for i = 1, #tOtherRewardList do
        table.insert(self.matchReward, tOtherRewardList[i])
    end
end

--@brief    初始化排名奖励列表
function WndPvpMatchRank:initRankReward()
    -- body
    self.m_tRankReward = {}
    local tPlayerInfo = CacheCenter:getPlayerInfo()

    for i, value in pairs(GDatatab_trio_rank_season_reward) do
        local tItem = {}
        if tPlayerInfo.sex == 0 then
            tItem.reward = value.reward
        else
            tItem.reward = value.reward2
        end
        if value.id <= 3 then
            tItem.rank = value.rank[1][1]
        else
            tItem.rank = string.gsub(string.format(LocalStrings.RANK_TIPS_3, value.rank[1][1], value.rank[1][2]) .. LocalStrings.ATH_REWARD_CHECK, "~", "-") 
        end
        tItem.sortNum = tonumber(value.rank[1][1])

        table.insert(self.m_tRankReward, tItem)
    end

    table.sort(self.m_tRankReward, function (a,b)
        -- body
        return a.sortNum < b.sortNum
    end)
end

function WndPvpMatchRank:setMyRankData(nMyRank)
    --body
    self:closeLoadingBox()
    self.m_nMyRank = nMyRank

    self:createMatchRank2()
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------