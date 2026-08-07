--WndMonthFightingData.lua
--@brief	WndMonthFighting的数据模块
--@date		2017/08/30
--@author	Tianxiang_Xu
--@note		开服活动-月战力榜

WndMonthFighting = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMonthFighting:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRankReward = nil 
	self.m_tRankList = nil 
	self.m_nLoadingId = nil 
	self.m_nMyRank = nil
    self.activityId = nil           --活动类型
    self.rewardRank = nil           --排名奖励名次
    self.reward = nil               --排名奖励内容
    self.nFlowerSex = nil         --5019鲜花榜用到
    self.tabFlowerRecord = nil    --鲜花榜记录
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMonthFighting:_unInit()
	self.m_root = nil
	self.m_tRankReward = nil 
	self.m_tRankList = nil 
	self.m_nLoadingId = nil 
	self.m_nMyRank = nil 
    self.activityId = nil
    self.rewardRank = nil           --排名奖励名次
    self.reward = nil               --排名奖励内容
    self.nFlowerSex = nil
    self.tabFlowerRecord = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMonthFighting:createElement()
	if WndMonthFighting.m_root ~= nil then
		WindowManager:removeWindow(WndMonthFighting.m_root, WndMonthFighting, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMonthFighting")
	assert(element, "WndMonthFighting create element failed!")
	self:_init()
	return element
end

-- 显示UI
function WndMonthFighting:showWndUI(tag,activityId,rewardRank,reward,flowerSex)
    local wnd = WndMonthFighting:createElement()
    WindowManager:addWindow(wnd, WndMonthFighting, nil, nil, nil, true)

    self.nFlowerSex = flowerSex
    self.activityId = activityId
    self.rewardRank = rewardRank
    self.reward = reward
    self:setCheckBoxAndCon(tag)
    if tag == 1 then
        self:createMatchRank1()
    elseif tag == 2 then
        self:createMatchRank2()
    end
end

--@brief 	设置排名数据
function WndMonthFighting:setRankListData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9)
	-- body
	self:_stopLoading()

    self.m_tRankList = {}
    for i = 0, ranking:size() - 1 do
        local temp = {}
        temp.ranking   = ranking:get(i)
        temp.playerId   = playerId:get(i)
        temp.name     = name:get(i)
        temp.faceId   = faceId:get(i)
        temp.headId  = headId:get(i)
        temp.sex 	= sex:get(i)
        temp.level   = level:get(i)
        temp.param1   = param1:get(i)
        temp.param2   = param2:get(i)
        temp.param3   = param3:get(i)
        temp.param4   = param4:get(i)
        temp.param5   = param5:get(i)
        temp.param6   = param6:get(i)
        temp.param7   = param7:get(i)
        temp.vipLevel = vipLevel:get(i)
        temp.param8 = param8:get(i)
        temp.headColor = headColor:get(i)
        temp.param9 = param9:get(i)
        temp.trendRank     = trendRank:get(i)

        table.insert(self.m_tRankList,temp)
    end

    table.sort(self.m_tRankList, function (a,b)
    	-- body
    	return a.ranking < b.ranking
    end)

    self:createMatchRank1()
end

function WndMonthFighting:setFlowerRecordData(playerId, name, sex, level, headScul, cross, num, time, total)
    self.tabFlowerRecord = {}
    self.tabFlowerRecord.time = time
    self.tabFlowerRecord.total = total
    self.tabFlowerRecord.playerData = {}
    for i = 0, playerId:size() - 1 do
        temp = {}
        temp.playerId = playerId:get(i)
        temp.name = name:get(i)
        temp.level = level:get(i)
        temp.headScul = headScul:get(i)
        temp.cross = cross:get(i)
        temp.num = num:get(i)

        table.insert(self.tabFlowerRecord.playerData,temp)
    end
    table.sort(self.tabFlowerRecord.playerData,function(a,b)
            return a.num > b.num
        end)
    self:createMatchRank3()
end

--@brief 	自己的排名
function WndMonthFighting:setMyRankData(myRank)
	-- body
	self:_stopLoading()
	self.m_nMyRank = myRank

	self:createMatchRank1()
end

--@brief    初始化排名奖励列表
function WndMonthFighting:initRankReward()
    -- body
    self.m_tRankReward = {}
    local tPlayerInfo = CacheCenter:getPlayerInfo()

    for i, value in pairs(GDatatab_att_rank_reward) do
        local tItem = {}
        if tPlayerInfo.sex == 0 then
            tItem.reward = value.reward_boy
        else
            tItem.reward = value.reward_girl
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

--@brief   本服、跨服的充值、消费排名奖励内容
function WndMonthFighting:initRankReward1(  )
    self.m_tRankReward = {}
    --WZLog("--**********************--11111",Serialize(self.reward),Serialize(self.rewardRank))
    if self.rewardRank and self.reward then
        for i=1,#self.reward do
            local tItem = {}
            local item = {}
            if i <= 3 then
                tItem.rank = tonumber(self.rewardRank[i])
                tItem.sortNum = tonumber(self.rewardRank[i])
            else
                local sTarget = SplitStringWithSeparator(self.rewardRank[i],"&")
                --WZLog("--&&&&&&&&&&&&&&0000===",Serialize(sTarget))
                if #sTarget == 2 then
                    tItem.rank = string.gsub(string.format(LocalStrings.RANK_TIPS_3, tonumber(sTarget[1]), tonumber(sTarget[2])) .. LocalStrings.ATH_REWARD_CHECK, "~", "-") 
                end
                tItem.sortNum = tonumber(sTarget[1])
            end
            local target = SplitStringWithSeparator(self.reward[i],"&")
            for i=1,#target do
                --tItem.reward = tonumber(target[i])
                local target1 = SplitStringWithSeparator(target[i],",")
                local reward = {}
                reward[1] = tonumber(target1[1])
                reward[2] = tonumber(target1[2])
                table.insert(item,reward)
                --WZLog("--&&&&&&&&&&&&&&11111===",#target1,Serialize(target1),Serialize(item))
            end
            --WZLog("--*************---1111111111",Serialize(item))
            tItem.reward = item
            
            table.insert(self.m_tRankReward,tItem)
        end
        table.sort(self.m_tRankReward,function ( a,b )
            return a.sortNum < b.sortNum
        end)
    end
 end 
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    数据加载动画
function WndMonthFighting:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndMonthFighting:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end




-------------------------------------私有方法模块End----------------------------------------
