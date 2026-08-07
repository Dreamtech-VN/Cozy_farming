--WndTowerRankData.lua
--@brief	WndTowerRank的数据模块
--@date		2015/04/28
--@author	xiaoyu_wu
-- modify   2015-7-3 binshao
--@modify   qixiang_xie
--@note		爬塔副本排名窗口

WndTowerRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTowerRank:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil                  --数据表
    self.m_bEnterAnimation = false      --是否正在播放进入动画
    self.m_nLoadListIndex = 0           --当前加载的页数
    self.m_nRankListCount = 0
    self.m_nLoadCurIndex = 0
    self.m_oRankTableList = nil
    self.m_fTableCurMaxPsY = nil
    self.m_nTotalPage = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTowerRank:_unInit()
	self.m_root = nil
    self.m_tData = nil
    self.m_bEnterAnimation = nil
    self.m_nLoadListCount = nil
    self.m_nRankListCount = nil
    self.m_nLoadCurIndex = nil
    self.m_oRankTableList = nil
    self.m_fTableCurMaxPsY = nil
    self.m_nTotalPage = nil
    self.m_nLoadListIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTowerRank:createElement()
	local element = WZUISystem:getInstance():createElement("WndTowerRank")
	assert(element, "WndTowerRank create element failed!")
	self:_init()
	return element
end

--@brief  返回根节点
function WndTowerRank:getRoot()
    return self.m_root
end

--@brief	显示窗口
--@note		调用此接口显示爬塔副本排行窗口
function WndTowerRank:showWindow()
    --防止打开多个
    if self.m_root then return end

    local wndTowerRank = self:createElement()
    WindowManager:addWindow(wndTowerRank,self, true,nil,nil, true)
end

--@brief	获取爬塔副本排名
--@param    topFloor : 我的最高记录层数
--@param    myRank : 我的排名
--@param    playerId : 玩家id
--@param    playerLevel : 玩家等级
--@param    playerSex : 玩家性别（0男，1女）
--@param    playerName : 玩家名称
--@param    playerGuild : 玩家公会
--@param    playerFloor : 玩家最高记录层数
--@param    headId : 玩家头部Id
--@param    faceId : 玩家脸部Id
--@note		由协议层回调
function WndTowerRank:getTowerRankOk(topFloor, myRank, playerId, playerLevel, playerSex, playerName, playerGuild, playerFloor, headId, faceId,vipLevel,headColors)
    self.m_tData = {}
    self.m_tData.topFloor = topFloor
    self.m_tData.myRank = myRank

    self.m_tData.playerInfo = {}
    for i = 1, #playerId do
        local info = {}
        info.playerId = playerId[i]
        info.playerLevel = playerLevel[i]
        info.playerSex = playerSex[i]
        info.playerName = playerName[i]
        info.playerGuild = playerGuild[i]
        info.playerFloor = playerFloor[i]
        info.headId = headId[i]
        info.faceId = faceId[i]
        info.vipLevel = vipLevel[i]
        info.headColor = headColors[i]
        table.insert(self.m_tData.playerInfo,info)
    end
    self.m_nRankListCount = #self.m_tData.playerInfo
    self.m_nTotalPage = math.ceil(self.m_nRankListCount/10)
    
    self:_update()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
