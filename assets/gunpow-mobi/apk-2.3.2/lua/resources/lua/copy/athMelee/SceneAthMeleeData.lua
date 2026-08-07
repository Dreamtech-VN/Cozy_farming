--SceneAthMeleeData.lua
--@brief	SceneAthMelee的数据模块
--@date		2016-10-17
--@author	binshao
--@note		大乱斗

SceneAthMelee = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneAthMelee:_init()
	self.m_root = nil	 	  			--场景根节点
    self.singleInfo = nil               -- 个人信息
    self.rankInfo = nil                 -- 排行榜信息
    self.myRankInfo = nil               -- 自己的排行信息
    self.selBoxData = nil               -- 保存当前宝箱的信息
    self.markTime = 0                  -- 匹配倒计时
    self.loadingId = nil
    self.conPlayer = nil

    self.reward = {}        -- 奖励
    self.fightData = {}     -- 战斗数据
    self.timeDown = 0
    self.descCnt = nil

    self.m_nType = nil   --1、乱斗模式、2绝地冒险、3怪兽模式
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneAthMelee:_unInit()
	self.m_root = nil
    self.singleInfo = nil
    self.rankInfo = nil
    self.myRankInfo = nil
    self.markTime = nil
    self.selBoxData = nil
    self.loadingId = nil
    self.conPlayer = nil

    self.reward = nil
    self.fightData = nil
    self.timeDown = nil
    self.descCnt = nil
     self.m_nType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneAthMelee:createElement()
	local element = WZUISystem:getInstance():createElement("SceneAthMelee")
	assert(element, "SceneAthMelee create element failed!")
	self:_init()
	return element
end

--@brief    排位赛外部接口
function SceneAthMelee:showInterface(nType)
    -- body
    local benter = true
    if (nType == nil or nType == 1) and not CheckButtonOpen(84)   then
         benter = false
    end
    if benter then
        local scene = SceneAthMelee:createElement()
        replaceScene(scene)
        if nType == nil then
            nType = 1
        end
        self.m_nType = nType
    end
end

--
function SceneAthMelee:initGoalReward(id, process, status, killTimes, winTimes, joinTimes, countDown)
    for i = 1, #id do
        WZLog("----------goalR----------",id[i],process[i],status[i],winTimes,joinTimes,countDown)
    end

    local goal = {}
    for i = 1, #id do
        local index = id[i]
        goal[index] = {id = index, process = process[i], status = status[i],killCnt = killTimes,winCnt = winTimes,joinCnt = joinTimes}
    end

    self.reward = {}
    for k,v in pairs(GDatatab_melee_reward) do
        v.process = goal[v.id].process
        v.status = goal[v.id].status
        v.killCnt = killTimes
        v.winCnt = winTimes
        v.joinCnt = joinTimes
        table.insert(self.reward,v)
    end

    self:sortRewardList()

    self.fightData = {killCnt = killTimes, winCnt = winTimes, joinCnt = joinTimes }

    self:initGoalDesc(id, process, status)
end

function SceneAthMelee:initGoalDesc()
    -- 对应数据分类
    local joinTab = {}
    local winTab = {}
    local killTab = {}

    for k,v in pairs(self.reward) do
        if v.fight_num > 0 then
            table.insert(joinTab,v)
        elseif v.win_num > 0 then
            table.insert(winTab,v)
        elseif v.kill_num > 0 then
            table.insert(killTab,v)
        end
    end

    local function sortJoin(v1,v2)
        return v1.fight_num <  v2.fight_num
    end

    local function sortWin(v1,v2)
        return v1.win_num <  v2.win_num
    end

    local function sortKill(v1,v2)
        return v1.kill_num <  v2.kill_num
    end

    table.sort(joinTab,sortJoin)
    table.sort(winTab,sortWin)
    table.sort(killTab,sortKill)

    -- 获取当前已完成任务的最小次数作为显示次数,0为已经完成
    local tabLen = #joinTab
    local joinDescCnt = joinTab[1].fight_num
    local joinMax = joinTab[tabLen].fight_num
    if self.fightData.joinCnt >= joinMax then joinDescCnt = 0 end
    for i = 1, tabLen do
        local data = joinTab[i]
        if data.status == 0 or data.status == 2 then
            joinDescCnt = data.fight_num
            break
        end
    end

    local tabLen = #winTab
    local winDescCnt = winTab[1].win_num
    local winMax = winTab[tabLen].win_num
    if self.fightData.winCnt >= winMax then winDescCnt = 0 end
    for i = 1, tabLen do
        local data = winTab[i]
        if data.status == 0 or data.status == 2 then
            winDescCnt = data.win_num
            break
        end
    end

    local tabLen = #killTab
    local killDescCnt = killTab[1].kill_num
    local killMax = killTab[tabLen].kill_num
    if self.fightData.killCnt >= killMax then killDescCnt = 0 end
    for i = 1, tabLen do
        local data = killTab[i]
        if data.status == 0 or data.status == 2 then
            killDescCnt = data.kill_num
            break
        end
    end

    WZLog("----------get min cnt-------------",joinDescCnt,winDescCnt,killDescCnt)
    self.descCnt = {joinDescCnt,winDescCnt,killDescCnt }

    self:updateFightData()
end

function SceneAthMelee:sortRewardList()
    local sortIndex = {1,3,2}
    local function sort(v1,v2)
        if v1.status ~= v2.status then
            return sortIndex[v1.status+1] < sortIndex[v2.status+1]
        else
            return v1.num < v2.num
        end
        return false
    end
    table.sort(self.reward,sort)
end
-------------------------------------公有方法模块End--------------------------------------


-------------------------------------私有方法模块块Begin----------------------------------

-------------------------------------私有方法模块End--------------------------------------
