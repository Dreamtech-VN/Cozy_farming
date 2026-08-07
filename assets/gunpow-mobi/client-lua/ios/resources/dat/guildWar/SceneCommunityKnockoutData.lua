--SceneCommunityKnockoutData.lua
--@brief	SceneCommunityKnockout的数据模块
--@date		2017/02/22
--@author	zsq
--@note		公会战淘汰赛房间

SceneCommunityKnockout = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunityKnockout:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tRoomMemberList = nil
    self.m_tRightList = nil
	self.m_nTab = nil
	self.m_nAdmin = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunityKnockout:_unInit()
	self.m_root = nil
    self.m_tRoomMemberList = nil
    self.m_tRightList = nil
	self.m_nTab = nil
	self.m_nAdmin = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunityKnockout:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunityKnockout")
	assert(element, "SceneCommunityKnockout create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置房间参战会员数据
function SceneCommunityKnockout:setRoomData(id, name, sex, level, vipLevel, fighting, headId, faceId, headColor, teamId, teamPosition, entryGuild, position, state, donate, agent)
    -- body
    if self.m_root == nil then return end
    
    self.m_tRoomMemberList = {}
    local nCurTime = SystemTime:getServerTime()
	self.m_nAdmin = -1

	--id = {14430,17646,14430,17646,14430,17646}
	--name = {"he82","he70","he82","he70","he82","he70"}
	--sex = {1,0,1,0,1,0}
	--level = {30,22,30,22,30,22}
	--vipLevel = {5,6,5,6,5,6}
	--fighting = {13729,17646,13729,17646,13729,17646}
	--headId = {4906,4903,4906,4903,4906,4903}
	--faceId = {4905,4902,4905,4902,4905,4902}
	--headColor = {0,0,0,0,0,0}
	--teamId = {0,0,1,1,2,2}
	--teamPosition = {0,1,0,2,1,2}
	--entryGuild = {nCurTime,nCurTime,nCurTime,nCurTime,nCurTime,nCurTime}
	--position = {1,1,1,1,1,1}
	--state = {1,2,3,1,2,3} 
	--donate = {1,1,1,1,1,1}
	--agent = {12233,14430,12345}

	--确定当前有权限设置的玩家
	for i=1,#agent do
		for j=1,#id do
			if id[j] == agent[i] and state[j] == 2 then
				self.m_nAdmin = id[j]
				break
			end
		end
		if self.m_nAdmin ~= -1 then
			break
		end
	end

    for i = 1, #id do
        local tItem = {}
        tItem.id = id[i]
        tItem.name = name[i]
        tItem.sex = sex[i]
        tItem.level = level[i]
        tItem.vipLevel = vipLevel[i]
        tItem.fighting = fighting[i]
        tItem.headId = headId[i]
        tItem.faceId = faceId[i]
        tItem.headColor = headColor[i]
        tItem.teamId = teamId[i] + 1
        tItem.teamPosition = teamPosition[i] + 1
        tItem.joinTime = nCurTime - math.floor(tonumber(entryGuild[i])/1000) 
        tItem.position = position[i]
        tItem.state = state[i]
        tItem.donate = donate[i]
        --tItem.agent = agent[i]
        WZLog("******************  ", tItem.joinTime, nCurTime, tonumber(entryGuild[i]) )
		
		if position[i] == COMMUNITY_PRESIDENT and state[i] == 2 then
			self.m_nAdmin = id[i]
		end

		--在线但不能被邀请，设置为状态10
		if state[i] == 4 then
			tItem.state = 10
		end

		if state[i] == 2 and (tItem.teamId == 1 or tItem.teamId == 2 or tItem.teamId == 3) then
			tItem.state = 4
		end
		
        table.insert(self.m_tRoomMemberList, tItem)
    end

    WZLog("SceneCommunityKnockout:setRoomData",Serialize(agent),self.m_nAdmin, Serialize(self.m_tRoomMemberList))
    --如果房间列表打开，刷新房间会员数据
    if WndCompeteMember.m_root then
		if CacheCenter:getPlayerInfo().id == self.m_nAdmin then
        	WndCompeteMember:resetData(self.m_tRoomMemberList)
		else
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITYWAR_TEXT38)
			WindowManager:removeWindow(WndCompeteMember.m_root, WndCompeteMember, true)
		end
    end

    --self:_stopLoading()
    --创建参战队伍成员列表
    self:_createTeamList()

	local sort = function(a, b)
		if a.fighting ~= b.fighting then
			return a.fighting > b.fighting
		else
			if a.level ~= b.level then
				return a.level > b.level
			else
				if a.position ~= b.position then
					return a.position > b.position
				else
					if a.donate ~= b.donate then
						return a.donate > b.donate
					else
						return a.id > b.id
					end
				end
			end
		end
	end

	table.sort(self.m_tRoomMemberList, sort)

	--创建右侧房间内成员列表
	self:_updateRight()

    WndCurrentChat:addWndCurrentChatToCurScene(self.m_root:getLuaObjectName(),self.m_root)
end

function SceneCommunityKnockout:onInfo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local sRule = string.gsub(LocalStrings.KNOCKOUT_DESC, "255,236,193", "127,70,26")
    WndSingleMapDesc:showInterface1(sRule)
end

--@brief    接受公会战房间邀请
function SceneCommunityKnockout:receiveInvite(playerName)
	--if self.m_root == nil then return end
    WndInvited:showInterface(SceneCommunityKnockout, SceneCommunityKnockout.onAcceptInvite, nil, nil,nil, string.format(LocalStrings.COMMUNITY_COMPETE_TEXT53, playerName),playerName)
end

function SceneCommunityKnockout:onAcceptInvite()
	SceneCommunityKnockout:showScene()
end

--@brief    公会战结束，提示房间中的人退出房间
function SceneCommunityKnockout:showExitRoomAtt()
    -- body
    WZLog("SceneCommunityKnockout:showExitRoomAtt")

    MsgBoxManager:showConfirmBox(LocalStrings.COMMUNITY_COMPETE_TEXT58, self, self.onSure, nil, nil, true)
end

--@brief    点击提示框确认按钮回调
function SceneCommunityKnockout:onSure(element)
    WZLog("SceneCommunityKnockout:onSure")
    -- body
    self:onTempClose() 
end
-------------------------------------私有方法模块End----------------------------------------
