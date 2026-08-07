--WndWorldBossEndRewardData.lua
--@brief	WndWorldBossEndReward的数据模块
--@date		2015-9-22
--@author	binshao
--@note		世界boss结束奖励界面

WndWorldBossEndReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWorldBossEndReward:_init()
	self.m_root = nil	 	 --场景根节点
    self.data = nil
    self.killInfo = {}       -- 击杀奖励
    self.rankInfo = {}       -- 排行奖励
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWorldBossEndReward:_unInit()
	self.m_root = nil
    self.data = nil
    self.killInfo = nil
    self.rankInfo = nil
end

-- 对外接口
--hurtValue	int	总伤害输出
--hurtRank	int	输出排名
--hurtPercent	int	伤害所占百分比
--isWin	boolean	是否赢了
--killerId	long	击杀玩家id
--killerName	String	击杀玩家名称
-- bossId = 1
function WndWorldBossEndReward:showWnd(data)
    local wnd = WndWorldBossEndReward:createElement()
    WindowManager:addWindow( wnd ,WndWorldBossEndReward,false)

    self.data = data
    self:_update()
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWorldBossEndReward:createElement()
	local element = WZUISystem:getInstance():createElement("WndWorldBossEndReward")
	assert(element, "WndWorldBossEndReward create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------
------------------------------------私有方法模块Begin--------------------------------------

-- 初始化排行榜奖励的信息和击杀信息
function WndWorldBossEndReward:initRewardRankInfo()
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
        return info1.id < info2.id
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

-- 获取当前的排名奖励
function WndWorldBossEndReward:getRewardRank(rank)
    local data = self.data
    for i = 1, #self.rankInfo[data.bossId] do
        local startR = self.rankInfo[data.bossId][i].rank[1][1]
        local endR = self.rankInfo[data.bossId][i].rank[1][2]
        if rank >= startR and rank <= endR then
            return self.rankInfo[data.bossId][i].reward
        end
    end
    return false
end

-------------------------------------私有方法模块End----------------------------------------