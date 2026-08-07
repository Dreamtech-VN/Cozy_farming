--WndPvpRankKingData.lua
--@brief	WndPvpRankKing的数据模块
--@date		2015-11-12
--@author	bishao
--@note		竞技之王

WndPvpRankKing = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPvpRankKing:_init()
	self.m_root = nil	 	  			--场景根节点
    self.logData = nil
    self.playerInfo = nil
    self.loadingId = nil
    self.descLog = false
    self.m_tRoleAniList = nil 
    self.m_nType = 98                   -- 98:积分，99:排位
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPvpRankKing:_unInit()
	self.m_root = nil
    self.logData = nil
    self.playerInfo = nil
    self.loadingId = nil
    self.descLog = nil
    self.m_tRoleAniList = nil 
    self.m_nType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPvpRankKing:createElement()
	local element = WZUISystem:getInstance():createElement("WndPvpRankKing")
	assert(element, "WndPvpRankKing create element failed!")
	self:_init()
	return element
end

--@brief    显示窗口
function WndPvpRankKing:showWindow(nType)
    local wnd = self:createElement()
    self.m_nType = nType
    WindowManager:addWindow(wnd, self)
end

-- 设置膜拜日志
function WndPvpRankKing:setLogData(log)
    self:_closeLoadingBox()
    for k,v in pairs(log) do
        WZLog("--------------------log-------------",k,v)
        if type(v) == "table" then
            WZLog("--------------------len-------------",#v)
            for i,j in pairs(v) do
                WZLog("--------------------i,j-------------",i,j)
            end
        end
    end

    self.logData = log
    local worshipLog = {}
    for i = 1, #log.playerName do
        local nServerId = CacheCenter:getPlayerInfo().serverId
        if self.m_nType == 99 then
            nServerId = log.serverId[i]
        end
        local info = {playerName = log.playerName[i], serverId = nServerId, worshipDate = log.worshipDate[i], beWorshipName = log.beWorshipName[i]}

        table.insert(worshipLog, info)
    end
    local function sort(l1,l2)
        return l1.worshipDate < l2.worshipDate
    end
    table.sort(worshipLog,sort)
    self.logData.log = worshipLog
    self:_updateLog()
end

function WndPvpRankKing:setPlayerInfo(info)
    WndPvpRankKing:_closeLoadingBox()
    for k,v in pairs(info) do
        WZLog("--------------------info-------------",k,v)
    end
    self.playerInfo = info
    self:showPlayer(info)
end

--@brief    获取排位数据
function WndPvpRankKing:initData(seasonNum, startDate, endDate, openFlag, pvpLevel, pvpScore,startTime, endTime)
    self:_closeLoadingBox()
    WZLog("WndPvpRankKing:initData", startDate, endDate, pvpLevel)
    local data = {}
    data.seasonNum = seasonNum
    data.openFlag = openFlag
    data.pvpLevel = pvpLevel
    data.pvpScore = pvpScore
    local sYear,sMonth,sDay,eYear,eMonth,eDay = ScenePvpRank:parseTime(startDate, endDate)
    data.sYear = sYear
    data.sMonth = sMonth
    data.sDay = sDay
    data.eYear = eYear
    data.eMonth = eMonth
    data.eDay = eDay
    data.startTime = startTime
    data.endTime = endTime

    WndPvpRankList:showWndUI(1, data)
end

function WndPvpRankKing:receiveGoldOk()
    --body
    self.logData.gold = 0 

    local cntG = GetElement(self.m_root,"ftbGold_WndPvpRankKing",WZUIFreeTextBox)
    cntG:setShowText(string.format(LocalStrings.RANK_KING_GOLD_CNT, self.logData.gold)) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPvpRankKing:_createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(10,self,self._closeLoadingBox) --超时40s
    end
end

function WndPvpRankKing:_closeLoadingBox()
    MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    self.loadingId = nil
end
-------------------------------------私有方法模块End----------------------------------------