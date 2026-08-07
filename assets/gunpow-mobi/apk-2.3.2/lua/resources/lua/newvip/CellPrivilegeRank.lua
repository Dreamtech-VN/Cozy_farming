--CellPrivilegeRank.lua
--@brief	CellPrivilegeRank的UI模块
--@date		2021/04/07
--@author	hyx
--@note		名人榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPrivilegeRank:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPrivilegeRank:onExit(element)
	self:unregister()
	self:_unInit()
end
function CellPrivilegeRank:register()
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_VipRankInfo,self._onGetVipRankInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
end

function CellPrivilegeRank:unregister()
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_VipRankInfo,self._onGetVipRankInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetRankResult,self._onGetRankResultInfo,self)
end

function CellPrivilegeRank:onEnterTransitionDidFinish(element)	
	ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(54)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPrivilegeRank:_onGetVipRankInfo(rankType, playerId, ranking, name, level, faceId, headId, sex, param1, param3, bodyId, windId, headColor,bodyColor,worship,title, vipLevel, headEffectId, qqHallInfo)
	if rankType == 54 then
		local data = self:setRankData( playerId, ranking, name, level, faceId, headId, sex, param1, param3, vipLevel, headColor, headEffectId, qqHallInfo)
		local privilegeRankList = GetElement(self.m_root,"privilegeRankList",WZUIFreeListContainer)
		privilegeRankList:removeAll()

		if next(data) == nil then
			ShowPanelNullTip( privilegeRankList, LocalStrings.CHARM_RESULT,ccc3(255,255,255))
			return
		end

		local txtEndTime = GetElement(self.m_root,"txtEndTime",WZUILabelTTF)
		local day = tonumber(os.date("%d"))
		local month = tonumber(os.date("%m"))
		if day > 15 then
			month = month + 1
		end
		if month > 12 then
			month = 1
		end
		txtEndTime:setText(string.format(LocalStrings.NEWVIP_TEXT20,month,15))
		if ProjConfig.LANGUAGE == "vn" then
			local tempMonth = tonumber(os.date("%m",SystemTime:getServerTime()))
			tempMonth = tempMonth + 1
			if tempMonth > 12 then
				tempMonth = 1
			end
			txtEndTime:setText(string.format(LocalStrings.NEWVIP_TEXT20,tempMonth,1))
		end
		for i=1, #data do
			local element, tLuaObj = PrivilegeRankItem:createElement()
			privilegeRankList:pushBack(WZUIContainer:luaTo(element))
			privilegeRankList:getMoveElement():setPositionY(privilegeRankList:getMinPosition().y)
			tLuaObj:setRankItemData(1, data[i])
		end
	end
end
function CellPrivilegeRank:_onGetRankResultInfo(activityId, activityType, rankingType, myPoint, myRanking, rewardConfig, playerIds, ranks, points, nickname, headIds, headColors, faceIds, sexs, vipLevel, level)
	if self.m_root then
		if myRanking <= 0 then
			myRanking = 0
		end
		self:setMyRank(myRanking)
		GetElement(self.m_root,"txtMyRank",WZUILabelTTF):setText(myRanking)
		GetElement(self.m_root,"txtMyExper",WZUILabelTTF):setText(myPoint)
	end
end
-------------------------------------私有方法模块End----------------------------------------
