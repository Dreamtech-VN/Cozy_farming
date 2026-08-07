--WndFightActivity1.lua
--@brief	WndFightActivity1的UI模块
--@date		2021/06/21
--@author	hyx
--@note		战力提升


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFightActivity1:onEnter(element)
	self.m_root = element
	self:register()
	ProtocolProcessorFestivalActivity:regAll6()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFightActivity1:onExit(element)
	self:_unInit()
	self:unregister()
	ProtocolProcessorWndBag:unregAll1()
end

function WndFightActivity1:showInterface()
	local wndFight = WndFightActivity1:createElement()
	if wndFight ~= nil then
	    WindowManager:addWindow(wndFight,WndFightActivity1,nil,false)
	end
end

function WndFightActivity1:register()
	LoadActivityWordsRes(true)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetFightInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndFightActivity1:unregister()
	LoadActivityWordsRes(false)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetFightInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndFightActivity1:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFightActivity1:actionCallback()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7200, 7200)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(g_cityExtenInfo.activity7200, 1)

	local status = false
	if GlobalGame.g_tRedPointTypeList then
		status = GlobalGame.g_tRedPointTypeList[127200] or GlobalGame.g_tRedPointTypeList[117200]
	end
    self:setFightTaskPoint(status)
end

function WndFightActivity1:setFightTaskPoint(visible)
	if not self.m_root then return end
	visible = visible or false
	GetElement(self.m_root,"fightTaskRedPoint",WZUIImage):setVisible(visible)
end
function WndFightActivity1:onBtnRole()
	if not self.m_tRoleData then return end
	ProtocolProcessorWndBag:regAll1()
	ProtocolProcessorWndBag:send_PLAYER_GetPlayerInfo(self.m_tRoleData.playerId)
end
function WndFightActivity1:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarRuleDesc:showInterface(LocalStrings.ACTIVITY_TEXT51)
end
function WndFightActivity1:onBtnTask()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFightTask1:showInterface()
end
function WndFightActivity1:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	红点
function WndFightActivity1:showRedDot()
	-- body
	local status = GlobalGame.g_tRedPointTypeList[127200] or GlobalGame.g_tRedPointTypeList[117200]
    self:setFightTaskPoint(status)

    WndFightTask1:setDayRedPoint(GlobalGame.g_tRedPointTypeList[127200])
    WndFightTask1:setGroupRedPoint(GlobalGame.g_tRedPointTypeList[117200])
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFightActivity1:_onGetFightInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == tonumber(g_cityExtenInfo.activity7200) then
		local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
		local _start = SystemTime:getTimeConverLocal6(startTime)
   		local _end = SystemTime:getTimeConverLocal6(endTime)
   		txtActivityTime:setText(_start.."-".._end)
	end
end
function WndFightActivity1:_onGetRankResultInfo(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, 
	headColors, faceIds, sexs, vipLevel, level, bodyIds, windIds, title)
	if activityId == tonumber(g_cityExtenInfo.activity7200) then
		rewardConfig = json.decode(rewardConfig)
		if not rewardConfig then return end
		local fightFreeList = GetElement(self.m_root,"fightFreeList",WZUIFreeListContainer)
		if next(playerIds) == nil then
			ShowPanelNullTip(fightFreeList, LocalStrings.CHARM_RESULT, ccc3(255,255,255))
			return
		end
	
		local tData, myCurRank, _myPoint = WndShopRank:setRankData(rewardConfig, playerIds, level, points, nickname, faceIds, headIds, headColors, sexs, bodyIds, 
			windIds,title, nil, 3)--此处3只是为了获取并列名字，没有实际意义
		local my_rank = GetElement(self.m_root,"txtMyRank",WZUILabelTTF)
		if myCurRank < 0 then
			my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
		else
			my_rank:setText(myCurRank)
		end
		GetElement(self.m_root,"txtMyFight",WZUILabelTTF):setText(myPoint)

		fightFreeList:removeAll()
		for i = 1, #tData do
			local element, tLuaObj = CellFightItem1:createElement()
			fightFreeList:pushBack(WZUIContainer:luaTo(element))
			fightFreeList:getMoveElement():setPositionY(fightFreeList:getMinPosition().y)
			tLuaObj:setFightItemData(tData[i])
		end

		local showRoleCon = GetElement(self.m_root,"showRoleCon",WZUIContainer)
		local role_data = tData[1]
		local roleConPlayer = YDPlayerAnimation:createAnimation(role_data.sex == 0)
		roleConPlayer:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
		roleConPlayer:getAnimNode():setTouchEnable(false)
		showRoleCon:addChild(roleConPlayer:getAnimNode())

		self.m_tRoleData = role_data
		-- 称号
	    local conTitle = GetElement(self.m_root, "conTitle", WZUIContainer)
	    local txtTitle = GetElement(self.m_root, "txtPlayerTitle", WZUILabelTTF)
	    CreateDesiSpine(conTitle, txtTitle, role_data.title)

		GetElement(self.m_root,"txtFirstRankName",WZUILabelTTF):setText(role_data.name)
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



-------------------------------------私有方法模块End----------------------------------------
