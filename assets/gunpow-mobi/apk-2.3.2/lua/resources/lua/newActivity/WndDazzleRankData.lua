--WndDazzleRankData.lua
--@brief	WndDazzleRank的数据模块
--@date		2023/03/23
--@author	XTX
--@note		耀眼榜活动主界面

WndDazzleRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDazzleRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRoleData = nil 
	self.m_nTabIndex = 1
	self.m_nActivityId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDazzleRank:_unInit()
	self.m_root = nil
	self.m_tRoleData = nil 
	self.m_nTabIndex = nil 
	self.m_nActivityId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDazzleRank:createElement()
	if WndDazzleRank.m_root ~= nil then
		WindowManager:removeWindow(WndDazzleRank.m_root, WndDazzleRank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDazzleRank")
	assert(element, "WndDazzleRank create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndDazzleRank:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndDazzleRank:createElement()
	if wndWater then 
		WindowManager:addWindow(wndWater, WndDazzleRank, false)
	end
end

function WndDazzleRank:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == tonumber(g_cityExtenInfo.activity7071) then
		self.m_nActivityId = activityId

		local txtActivityTime = GetElement(self.m_root,"txtActivityTime_WndDazzleRank",WZUILabelTTF)
		local _start = SystemTime:getTimeConverLocal6(startTime)
   		local _end = SystemTime:getTimeConverLocal6(endTime)
   		txtActivityTime:setText(_start.."-".._end)
	end
end

function WndDazzleRank:_onGetRankResultInfo(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, 
	headColors, faceIds, sexs, vipLevel, level, bodyIds, windIds, title, serverId, session, settlementDate, headEffectId, qqInfo)
	if activityId == tonumber(g_cityExtenInfo.activity7071) then
		WZLog("WndDazzleRank:_onGetRankResultInfo", Serialize(playerIds), Serialize(json.decode(rewardConfig)))
		rewardConfig = json.decode(rewardConfig)
		if not rewardConfig then return end
		local fightFreeList = GetElement(self.m_root,"fightFreeList_WndDazzleRank",WZUIFreeListContainer)
		if fightFreeList:size() > 0 then 
			fightFreeList:removeAll()
		end
		local showRoleCon = GetElement(self.m_root,"showRoleCon_WndDazzleRank",WZUIContainer)
		if showRoleCon:getChildByTag(22) then 
			showRoleCon:removeChildByTag(22, true)
		end
		local conTitle = GetElement(self.m_root, "conTitle_WndDazzleRank", WZUIContainer)
	    local txtTitle = GetElement(self.m_root, "txtPlayerTitle_WndDazzleRank", WZUILabelTTF)
		local my_rank = GetElement(self.m_root,"txtMyRank_WndDazzleRank",WZUILabelTTF)
		local txtFirstRankName = GetElement(self.m_root,"txtFirstRankName_WndDazzleRank",WZUILabelTTF)
		if next(playerIds) == nil then
			ShowPanelNullTip(fightFreeList, LocalStrings.CHARM_RESULT, ccc3(138,122,106))
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
			GetElement(self.m_root,"txtMyFight_WndDazzleRank",WZUILabelTTF):setText(myPoint)
			txtTitle:setText("")
			txtFirstRankName:setText("")
			conTitle:removeAllChildrenWithCleanup(true)
			return
		end
		
		removeShowPanelNullTip(fightFreeList)
		local tData, myCurRank, _myPoint = WndShopRank:setRankData(rewardConfig, playerIds, level, points, nickname, faceIds, headIds, headColors, sexs, bodyIds, 
			windIds,title, nil, 3, rankingType, serverId, headEffectId, qqInfo)--此处3只是为了获取并列名字，没有实际意义
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		GetElement(self.m_root,"txtMyFight_WndDazzleRank",WZUILabelTTF):setText(myPoint)

		for i = 1, #tData do
			local element, tLuaObj = CellFightItem:createElement()
			fightFreeList:pushBack(WZUIContainer:luaTo(element))
			fightFreeList:getMoveElement():setPositionY(fightFreeList:getMinPosition().y)
			tLuaObj:setFightItemData(tData[i], 3)
		end

		local role_data = tData[1]
		local roleConPlayer = YDPlayerAnimation:createAnimation(role_data.sex == 0)
		roleConPlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
		roleConPlayer:getAnimNode():setTouchEnable(false)
		showRoleCon:addChild(roleConPlayer:getAnimNode(), 0, 22)

		self.m_tRoleData = role_data
		-- 称号
	    CreateDesiSpine(conTitle, txtTitle, role_data.title)

		txtFirstRankName:setText(role_data.name)
		if role_data.headId and GDatatab_item["id_"..role_data.headId] then
			local head = GDatatab_item["id_"..role_data.headId].animation_index_code
			roleConPlayer:setHead(head)
		end
		if role_data.faceId and GDatatab_item["id_"..role_data.faceId] then
			local face = GDatatab_item["id_"..role_data.faceId].animation_index_code
			roleConPlayer:setFace(face)
		end
		if role_data.bodyId and GDatatab_item["id_"..role_data.bodyId] then
			local body = GDatatab_item["id_"..role_data.bodyId].animation_index_code
			roleConPlayer:setBody(body)
		end
		if role_data.windId and GDatatab_item["id_"..role_data.windId] then
			local wing = GDatatab_item["id_"..role_data.windId].animation_index_code
			roleConPlayer:setWing(wing)
		end
		roleConPlayer:play("wait0",true)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
