--CellPrivilegeRankChanpion.lua
--@brief	CellPrivilegeRankChanpion的UI模块
--@date		2021/04/07
--@author	hyx
--@note		名人榜历届冠军


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPrivilegeRankChanpion:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndRankList:regAll1()
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPrivilegeRankChanpion:onExit(element)
	self:_unInit()
	Protocol:unreg( Protocol.MAIN_RANK, Protocol.RANK_WorshipOK, "ProtocolProcessorWndRankList:parse_RANK_WorshipOK", "iii")
	self:unregister()
end
function CellPrivilegeRankChanpion:register()
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_VipRankInfo,self._onGetChanpionRankInfo,self)
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_VipRankWorshipResult,self._onGetWorshipResult,self)
end

function CellPrivilegeRankChanpion:unregister()
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_VipRankInfo,self._onGetChanpionRankInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_VipRankWorshipResult,self._onGetWorshipResult,self)
end
function CellPrivilegeRankChanpion:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_RANK_GetRankRecord(55)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPrivilegeRankChanpion:_onGetChanpionRankInfo(rankType, playerId, ranking, name, level, faceId, headId, sex, param1, param3, bodyId, windId,headColor,bodyColor,worship,title,vipLevel, headEffectId, qqHallInfo)
	if rankType == 55 then
		self:setChanpionRankData(playerId, ranking, name, level, faceId, headId, sex, param1, param3,bodyId, windId,headColor,bodyColor,worship,title, qqHallInfo)
		local chanpionFreeList = GetElement(self.m_root,"chanpionFreeList",WZUIFreeListContainer)
		chanpionFreeList:removeAll()

		if next(self.m_tRankChanpionData) == nil then
			ShowPanelNullTip( chanpionFreeList, LocalStrings.CHARM_RESULT,ccc3(255,255,255))
			return
		end

		for i=1, #self.m_tRankChanpionData do
			local element, tLuaObj = PrivilegeChanpionRankItem:createElement()
			chanpionFreeList:pushBack(WZUIContainer:luaTo(element))
			chanpionFreeList:getMoveElement():setPositionX(chanpionFreeList:getMaxPosition().x)
			tLuaObj:setRankItemData(self.m_tRankChanpionData[i])
			self.m_tRankChanpionItem[i] = tLuaObj
		end
	end
end
function CellPrivilegeRankChanpion:_onGetWorshipResult(result, worshipId, vigor)
	if result == 0 then
		MsgBoxManager:showTipBox(LocalStrings.HAVED_WORSHIP_TODAY)
	elseif result == 1 then
		local sWorshipResult = string.format(LocalStrings.WORSHIP_SUCCESS, vigor)
        MsgBoxManager:showTipBox(sWorshipResult)
		for i=1, #self.m_tRankChanpionData do
			if self.m_tRankChanpionData[i].playerId == worshipId and self.m_tRankChanpionItem[i] then
				self.m_tRankChanpionItem[i]:setWorshipNum(tonumber(self.m_tRankChanpionData[i].worship)+1)
			end
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------
