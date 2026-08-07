--CellChristmasConsumptionList.lua
--@brief	CellChristmasConsumptionList的UI模块
--@date		2020/12/08
--@author	hyc
--@note		圣诞排行榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellChristmasConsumptionList:onEnter(element)
	self.m_root = element
	self:register()
	ProtocolProcessorFestivalActivity:regAll5()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellChristmasConsumptionList:onExit(element)
	self:_unInit()
	self:unregister()
	ProtocolProcessorFestivalActivity:unregAll()
end

function CellChristmasConsumptionList:register()
	GlobalGame:getGameEventDispathcer():Add(WndPeopleShopEvent.WndPeopleShopEvent_ChristmasRank,self._onChristmasRankReward,self)
end
function CellChristmasConsumptionList:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndPeopleShopEvent.WndPeopleShopEvent_ChristmasRank,self._onChristmasRankReward,self)
end

function CellChristmasConsumptionList:showWindow()
	-- body
	WZLog("CellChristmasConsumptionList:showWindow")
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_activityId,1)
	local timeNum = GetElement(self.m_root,"time_CellChristmasConsumptionList",WZUILabelTTF)
	local DayStartTab = os.date("*t",self.m_startime)
    local DayEndTab = os.date("*t",self.m_endtime)
    local sTimeValue = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    timeNum:setText(sTimeValue)
	local btn1 = GetElement(self.m_root,"btn1_CellChristmasConsumptionList",WZUIButton)
	local text1 = GetElement(self.m_root,"text1_CellChristmasConsumptionList",WZUILabelTTF)
	btn1:setTouchEnable(false)
	text1:setColor(GlobalMethod:ccc3(158,0,0))
end

function CellChristmasConsumptionList:onClickRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.CHRISTMAS_CONSUMPTION_EXPLAIN)
end

function CellChristmasConsumptionList:event_getRank(element)
	-- body
	local tag = element:getTag()	--1蓝钻消费榜/2粉钻消费榜
	if tag == 1 then
		local btn1 = GetElement(self.m_root,"btn1_CellChristmasConsumptionList",WZUIButton)
		local text1 = GetElement(self.m_root,"text1_CellChristmasConsumptionList",WZUILabelTTF)
		btn1:setTouchEnable(false)
		text1:setColor(GlobalMethod:ccc3(158,0,0))
		local btn2 = GetElement(self.m_root,"btn2_CellChristmasConsumptionList",WZUIButton)
		local text2 = GetElement(self.m_root,"text2_cellChristmasConsumptionList",WZUILabelTTF)
		btn2:setTouchEnable(true)
		text2:setColor(GlobalMethod:ccc3(255,255,255))
	end
	if tag == 2 then
		local btn2 = GetElement(self.m_root,"btn2_CellChristmasConsumptionList",WZUIButton)
		local text2 = GetElement(self.m_root,"text2_cellChristmasConsumptionList",WZUILabelTTF)
		btn2:setTouchEnable(false)
		text2:setColor(GlobalMethod:ccc3(158,0,0))
		local btn1 = GetElement(self.m_root,"btn1_CellChristmasConsumptionList",WZUIButton)
		local text1 = GetElement(self.m_root,"text1_CellChristmasConsumptionList",WZUILabelTTF)
		btn1:setTouchEnable(true)
		text1:setColor(GlobalMethod:ccc3(255,255,255))
	end
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetRankingList(self.m_activityId,tag)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


function CellChristmasConsumptionList:_onChristmasRankReward(activityId,activityType,rankingType,myPoint,myRank,rewardConfig,playerIds,ranks,points,nickname,headIds,headColors,faceIds,sexs,vipLevels,levels)
	rewardConfig = json.decode(rewardConfig)
	if not rewardConfig then return end
	local shopItemFreeList = GetElement(self.m_root,"rankItem_WZUIFreeListContainer",WZUIFreeListContainer)
	shopItemFreeList:removeAll()
	removeShowPanelNullTip(shopItemFreeList)

	local tData, myCurRank = self:setChristmasRankData(rewardConfig, playerIds, levels, points, nickname, faceIds, headIds, headColors, sexs)
	local my_rank = GetElement(self.m_root,"rank_CellChristmasConsumptionList",WZUILabelTTF)
	if myCurRank < 0 then
		my_rank:setText(LocalStrings.NOT_IN_RANKLIST)
	else
		my_rank:setText(myCurRank)
	end
	local my_score = GetElement(self.m_root,"integral_CellChristmasConsumptionList",WZUILabelTTF)
	my_score:setText(myPoint)
	WZLog("排行榜Item的数量",#tData)
	for i = 1, #tData do
		local element, tLuaObj = cellChristmasConsumptionItem:createElement()
		shopItemFreeList:pushBack(WZUIContainer:luaTo(element))
		shopItemFreeList:getMoveElement():setPositionY(shopItemFreeList:getMinPosition().y)
		tLuaObj:setChristmasRankMessage(i,tData[i])
	end

	if next(playerIds) == nil then
		ShowPanelNullTip(shopItemFreeList, LocalStrings.CHARM_RESULT)
		return
	end
end



-------------------------------------私有方法模块End----------------------------------------
