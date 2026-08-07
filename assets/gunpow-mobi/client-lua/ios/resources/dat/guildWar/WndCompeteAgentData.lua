-- WndCompeteAgent
-- @brief: 公会战设置代理人 数据部分
-- @date: 2017-02-24 09:51:15
-- @author: zhenwei_jian
-- @note: 公会战设置代理人


local WndCompeteAgent = {}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCompeteAgent:_init()
	self.m_root 		= nil	 	  			--场景根节点
	self.m_tCellList 	= {}					--cell列表 
	self.m_tMemberList 	= {} 					--会员数据

	self.m_nSendingAgentId = nil 				--当前设置的代理人ID
	WndCompeteAgent.PreSelCell = nil 			--上次选中的会员Cell
	self.m_nTempPlaceIndex = nil 				--设置的位置
	self.m_nClickPlaceIndex = nil 				--设置界面点击的位置
	self.m_nOperateType = nil 					--1：设置；2：取消
	--过滤会员列表条件设置
	self.m_memberRemoveConditions = {
		["position"]	= COMMUNITY_PRESIDENT,		--职位是会长的去掉
	}

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCompeteAgent:_unInit()
	self.m_root 		= nil
	self.m_tCellList 	= nil 
	self.m_tMemberList 	= nil 					--会员数据

	self.m_nSendingAgentId = nil 				--当前设置的代理人ID
	WndCompeteAgent.PreSelCell = nil 			--上次选中的会员Cell
	self.m_nTempPlaceIndex = nil 
	self.m_nClickPlaceIndex = nil
	self.m_nOperateType = nil 

	self.m_memberRemoveConditions = nil
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCompeteAgent:createElement()
	local element = WZUISystem:getInstance():createElement("WndCompeteAgent")
	assert(element, "WndCompeteAgent create element failed!")
	self:_init()
	return element, self
end

--@brief  添加过滤成员列表的条件
--@param  k:过滤的属性名字
--@param  v:过滤的属性对应的值
function WndCompeteAgent:addMemberListFilterCondition(k, v)
	self.m_memberRemoveConditions[k] = v
end

--@brief 移除过滤成员列表的条件
--@param  key:过滤的属性名字
function WndCompeteAgent:removeMemberListFilterCondition(key)
	self.m_memberRemoveConditions[key] = nil
end

--@brief 收到服务端设置代理人消息回调
--@param agent:代理人ID 列表
function WndCompeteAgent:onRecvData(agent)
	MsgBoxManager:showTipBox(LocalStrings.SET_SUCCESS)
	WndCompeteAgentSetting:showWnd()
	WindowManager:removeWindow(self.m_root, self, true)
	-- self:removeMemberListFilterCondition()
	-- local tFilterIDMap = {}
	-- for i, agentId in ipairs(agent) do
	-- 	tFilterIDMap[agentId] = true
	-- end
	-- self:addMemberListFilterCondition("playerId", tFilterIDMap)
	--self:refresh()
end

function WndCompeteAgent:setCommunityMemberList(guildId, guildName, guildLevel, prestige, members, desc, setting, totemLevel, schoolLevel, storeLevel, newApply, id, headId, faceId, name, level, post, donate, totalDonate, loginTime, isOnline, buyDonate, totemPayTime, sex, weekDonate, lastDonate, allDonate, vipLevel, fireNum, headColor)
	self.m_nPageNumber 	= 1            	--当前页
	self.m_nTotalNumber = 1           	--总页数

	self.m_nGuildId 	= guildId
	self.m_sGuildName 	= guildName
	self.m_nGuildLevel 	= guildLevel
	self.m_nPrestige 	= prestige
	self.m_nMembers 	= members
	self.m_sDesc 		= desc
	self.m_nSetting 	= setting

	self.m_nTotemLevel 	= totemLevel
	self.m_nSchoolLevel = schoolLevel
	self.m_nStoreLevel 	= storeLevel
	self.m_nNewApply 	= newApply
	self.m_nFireNum 	= fireNum

	local tAgentData = WndCompeteAgentSetting:getAgentData()
	WZLog("11111111111111", Serialize(tAgentData))

	self.m_tMemberList 	= {}
	for i = 1, #id do
		local tempList 		= {}
		tempList.playerName = name[i]
		tempList.position 	= post[i]
		tempList.playerContribution = totalDonate[i]
		tempList.onLine 	= loginTime[i]
		tempList.rank 		= ""
		tempList.playerId 	= id[i]
		tempList.playerLevel = level[i]
		tempList.onLineState = isOnline[i]  --1在线，0不在线
		tempList.todayContribution = donate[i]
		tempList.headId 	= headId[i]
		tempList.faceId 	= faceId[i]
		tempList.headColor 	= headColor[i]
		tempList.sex = sex[i]
		tempList.weekDonate = weekDonate[i]
		tempList.lastDonate = lastDonate[i]
		tempList.allDonate 	= allDonate[i]
		tempList.vipLevel 	= vipLevel[i]
		tempList.zsLevel 	= -1
		if tostring(id[i]) == tostring(CacheCenter:getPlayerInfo().id) then
			tempList.oneself = 1
		else
			tempList.oneself = 0
		end

		local bIsAgent = false 
		for j = 1, #tAgentData.agent do
			if tAgentData.agent[j] ~= -1 and tAgentData.agent[j] == tempList.playerId then
				bIsAgent = true
				break 
			end
		end
		if bIsAgent then
			tempList.agentMark = 1
		else
			tempList.agentMark = 0
		end
		-- --开始过滤列表
		-- local bIsPass = false
		-- for k, v in pairs(self.m_memberRemoveConditions) do
		-- 	local sConditionType = type(v)
		-- 	local val = tempList[k]
		-- 	if "table" == sConditionType then
		-- 		if v[val] then--table 中有该值存在就过滤掉( 黑名单 )
		-- 			bIsPass = true
		-- 			break
		-- 		end
		-- 	else
		-- 		if val == v then
		-- 			bIsPass = true
		-- 			break
		-- 		end	
		-- 	end
		-- end
		-- if not bIsPass then
		-- end
		if tonumber(tempList.position) ~= COMMUNITY_PRESIDENT then
			table.insert(self.m_tMemberList, tempList)
		end

	end
	--排序
	table.sort(self.m_tMemberList , _sortMemberAgent)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 成员按职位排序
function _sortMemberAgent(a,b)
	--职位
	if a.agentMark ~= b.agentMark then
		return a.agentMark > b.agentMark
	elseif a.position ~= b.position then
		return a.position >= b.position
	--贡献
	elseif a.todayContribution ~= b.todayContribution then
		return a.todayContribution >= b.todayContribution
	--ID
	else
		return a.playerId < b.playerId
	end
end

--@brief 	如果在列表界面点中的人是已经设置为代理人的，则取消该代理人，否则替换原代理人成为新代理人
function WndCompeteAgent:_judgeWhetherAgent(playerId)
	-- body
	local tAgentData = WndCompeteAgentSetting:getAgentData()
	local nPlaceIndex = 0
	local bIsCancel = false 
	for i = 1, #tAgentData.agent do
		if tAgentData.agent[i] == playerId then
			bIsCancel = true
			nPlaceIndex = i 

			break 
		end
	end

	return nPlaceIndex, bIsCancel
end
-------------------------------------私有方法模块End--------------------------------------



rawset(_G, "WndCompeteAgent", WndCompeteAgent)

