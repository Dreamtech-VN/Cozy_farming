--ScenePvpRankData.lua
--@brief	ScenePvpRank的数据模块
--@date		2016-3-30
--@author	binshao
--@note		排位赛赛季奖励

ScenePvpRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function ScenePvpRank:_init()
	self.m_root = nil	 	  			--场景根节点
    self.singleInfo = nil               -- 个人信息
    self.rankInfo = nil                 -- 排行榜信息
    self.myRankInfo = nil               -- 自己的排行信息
    self.selBoxData = nil               -- 保存当前宝箱的信息
    self.markTime = 0                  -- 匹配倒计时
    self.loadingId = nil
    self.conPlayer = nil
    self.data = nil 
    self.m_tInitDate = nil 
    self.matchMode = 1          -- 比赛模式， 1 匹配赛 2 组队赛 
    self.personCnt = 3          -- 人数 1v1 = 1, 2v2 = 2, 3v3 = 3
    self.channel = 3       -- 排位赛频道
    self.m_tCallBack = nil 
    self.m_bIsStartMatch = false
    self.m_nCount = 0
    self.matchGoal = nil                --季赛排名
    self.m_bIsStartMove = nil               --是否开始移动
    self.firstPost = nil                    --移动前的坐标
    self.curPost = nil                      --当前移动的坐标
    self.m_bIsMoveAni = nil                 --是否播放移动动画
    self.m_tOldFootPos = nil                --旧的足迹位置
    self.petFirstPost = nil                 --宠物移动前的坐标
    self.petCurPost = nil                   --宠物当前移动的坐标
    self.nStartMathIndex = nil
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function ScenePvpRank:_unInit()
    self.m_root = nil
    self.singleInfo = nil
    self.rankInfo = nil
    self.myRankInfo = nil
    self.markTime = nil
    self.selBoxData = nil
    self.loadingId = nil
    self.conPlayer = nil
    self.data = nil 
    self.m_tInitDate = nil 
    self.matchType = nil          -- 比赛类型， 1 积分赛 2 练习赛 
    self.matchMode = nil          -- 比赛模式， 1 匹配赛 2 组队赛  3 混战赛
    self.personCnt = nil          -- 人数 1v1 = 1, 2v2 = 2, 3v3 = 3, 混战6
    self.channel = nil       -- 排位赛频道
    self.m_tCallBack = nil 
    self.m_bIsStartMatch = nil 
    self.m_nCount = nil
    self.matchGoal = nil
    self.m_bIsStartMove = nil               --是否开始移动
    self.firstPost = nil                    --移动前的坐标
    self.curPost = nil                      --当前移动的坐标
    self.m_bIsMoveAni = nil                 --是否播放移动动画
    self.m_tOldFootPos = nil                --旧的足迹位置
    self.petFirstPost = nil                 --宠物移动前的坐标
    self.petCurPost = nil                   --宠物当前移动的坐标
    self.nStartMathIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function ScenePvpRank:createElement()
	local element = WZUISystem:getInstance():createElement("ScenePvpRank")
	assert(element, "ScenePvpRank create element failed!")
	self:_init()
	return element
end

function ScenePvpRank:updateBoxState(type,index)
    if type == 1 then
        self.singleInfo.boxStatus[index] = 1
    else
        self.singleInfo.seasonboxStatu[index] = 1
    end
end

function ScenePvpRank:initData(seasonNum, startDate, endDate, openFlag, pvpLevel, pvpScore,startTime, endTime, dropCoinNum, playerProtectTimes, dayLimit)
    self:_closeLoadingBox()
    WZLog("ScenePvpRank:initData", startDate, endDate, pvpLevel)
    local data = {}
    data.seasonNum = seasonNum
    data.openFlag = openFlag
    data.pvpLevel = pvpLevel
    data.pvpScore = pvpScore
    local sYear,sMonth,sDay,eYear,eMonth,eDay = self:parseTime(startDate, endDate)
    data.sYear = sYear
    data.sMonth = sMonth
    data.sDay = sDay
    data.eYear = eYear
    data.eMonth = eMonth
    data.eDay = eDay
    data.startTime = startTime
    data.endTime = endTime
    data.dropCoinNum = dropCoinNum
    data.playerProtectTimes = playerProtectTimes
    data.dayLimit = dayLimit

    self.data = data

    self:update()
end


--@brief    排位赛外部接口
function ScenePvpRank:showInterface()
    -- body
    if GlobalGame.g_nRankOpenDay == 0 then
        if CheckButtonOpen(ISLAND_UP_QUALIFYING) then
            local scene = ScenePvpRank:createElement()
            replaceScene(scene)
        end
    else
        MsgBoxManager:showTipBox(string.format(LocalStrings.MASTEROPENTIPS,GlobalGame.g_nRankOpenDay))
    end
end

--@brief    设置退出界面回调
function ScenePvpRank:setReturnCallBack(tCell, func)
    -- body
    self.m_tCallBack = {}
    self.m_tCallBack[1] = tCell
    self.m_tCallBack[2] = func
end

--@brief    判断是否开始快速匹配
function ScenePvpRank:getMatchState()
    -- body
    if self.m_root == nil then return false end

    return self.m_bIsStartMatch 
end

--@brief    设置赛季排行数据
function ScenePvpRank:setRankData(rank, serverId, playerId, name, faceId, headId, headColor, sex, level, vipLevel, matchLevel, matchScore, matchConfigId, battleTimes, winTimes, playerRank, playerMatchLevel, playerMatchSocre, playerMatchConfigId)
    self.matchGoal = {}
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
        return a.rank < b.rank 
    end)

    self:createMatchGoal()
end
-------------------------------------公有方法模块End--------------------------------------


-------------------------------------私有方法模块块Begin----------------------------------
function ScenePvpRank:parseTime(startDate, endDate)
    local sDate = os.date("*t",startDate)
    local eDate = os.date("*t",endDate)
    local sYear = sDate.year
    local sMonth = sDate.month
    local sDay = sDate.day
    local eYear = eDate.year
    local eMonth = eDate.month
    local eDay = eDate.day
    WZLog("-------------pvp time------------",sYear, sMonth,sDay,eYear, eMonth,eDay)
    return sYear,sMonth,sDay,eYear,eMonth,eDay
end
-------------------------------------私有方法模块End--------------------------------------
