--WndActivityRankListData.lua
--@brief	WndActivityRankList的数据模块
--@date		2016/07/11
--@author	Tianxiang_Xu
--@note		活动夫妻战和工会战排行榜

WndActivityRankList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndActivityRankList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nLoadingId = nil 
	self.m_nRankType = nil 		--榜单类型
    self.m_tRankListData = nil
    self.m_nMyRank = nil        --我的排名
    self.m_nMyWinCount = nil    --我的胜场次数

	--11每个排行榜对应的排行榜信息标签
    self.m_tRankTypeInfoName = {}
    self.m_tRankTypeInfoName[g_tGameActivityTypes.ACTIVITY_COUPLEFIGHTING]  = {1,3,4,5}
    self.m_tRankTypeInfoName[g_tGameActivityTypes.ACTIVITY_COMMUNITYFIGHTING]  = {1,2,5,6}
	--标签信息
	self.m_tInfoItemName = {}
    self.m_tInfoItemName[1]  = LocalStrings.RANK                --排名
    self.m_tInfoItemName[2]  = LocalStrings.PLAYER     			--玩家
    self.m_tInfoItemName[3]  = LocalStrings.RANKLIST_LAOGONG    --老公
    self.m_tInfoItemName[4]  = LocalStrings.RANKLIST_LAOPO      --老婆
    self.m_tInfoItemName[5]  = LocalStrings.ACTIVITY_WINWORDS   --胜场
    self.m_tInfoItemName[6]  = LocalStrings.COMMUNITY         	--公会
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndActivityRankList:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil 
	self.m_nRankType = nil 		--榜单类型
	self.m_tRankTypeInfoName = nil 
	self.m_tInfoItemName = nil 
    self.m_tRankListData = nil
    self.m_nMyRank = nil        --我的排名
    self.m_nMyWinCount = nil    --我的胜场次数
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndActivityRankList:createElement()
	local element = WZUISystem:getInstance():createElement("WndActivityRankList")
	assert(element, "WndActivityRankList element create failed!")
	self:_init()
	return element,tNewObj
end

--@brief 	外部接口
--@param 	nRankType:榜单类型
function WndActivityRankList:showInterface(nRankType)
	-- body
	local wndRankList = WndActivityRankList:createElement()
	if wndRankList then
		self.m_nRankType = nRankType
		WindowManager:addWindow(wndRankList, WndActivityRankList)
	end
end

function WndActivityRankList:setRankListData(rankType, ranking, playerId, name, faceId, headId, sex, level, vipLevel, winCount, guildName, param1, param2, param3, param5, param6, param7, myRanking, myCount, headColor, param8)
    WZLog("WndActivityRankList:setRankListData",rankType)
    if self.m_tRankListData == nil then
        self.m_tRankListData = {}
    end

    self.m_nMyRank = myRanking
    self.m_nMyWinCount = myCount
    
    for i = 0,ranking:size()-1 do
        local temp = {}
        temp.ranking   = ranking:get(i)
        temp.playerId   = playerId:get(i)
        temp.name     = name:get(i)
        temp.faceId   = faceId:get(i)
        temp.headId  = headId:get(i)
        temp.sex    = sex:get(i)
        temp.level   = level:get(i)
        temp.winCount = winCount:get(i)
        temp.guildName = guildName:get(i)
        temp.param1   = param1:get(i)
        temp.param2   = param2:get(i)
        temp.param3   = param3:get(i)
        temp.param5   = param5:get(i)
        temp.param6   = param6:get(i)
        temp.param7   = param7:get(i)
        temp.vipLevel = vipLevel:get(i)
        temp.headColor = headColor:get(i)
        temp.param8 = param8:get(i)

        table.insert(self.m_tRankListData,temp)
    end
    self:_closeLoading()
    WZLog("#self.m_tRankListData===",#self.m_tRankListData, self.m_nMyRank, self.m_nMyWinCount, Serialize(self.m_tRankListData))
    WndActivityRankList:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
