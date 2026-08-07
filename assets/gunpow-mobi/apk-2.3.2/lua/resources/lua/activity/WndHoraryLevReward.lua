--WndHoraryLevReward.lua
--@brief	WndHoraryLevReward的UI模块
--@date		2021/07/19
--@author	hyx
--@note		占卜等级奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHoraryLevReward:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHoraryLevReward:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndHoraryLevReward:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetLevelRewardResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onHoraryLevelResult,self)
end
function WndHoraryLevReward:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetLevelRewardResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onHoraryLevelResult,self)
end
--默认是占卜的  1:房产活动
function WndHoraryLevReward:showInterface(_type)
	local wndLevReward = WndHoraryLevReward:createElement()
	if wndLevReward ~= nil then
	    WindowManager:addWindow(wndLevReward,WndHoraryLevReward,nil,false)
	end
	self:setData(_type)
end

function WndHoraryLevReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndHoraryLevReward:actionCallback()
	local txtTitle = GetElement(self.m_root,"txtTitle",WZUILabelTTF)
	if self.m_nRewardType == 1 then
		txtTitle:setText(LocalStrings.ACTIVITY_TEXT191)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7029, 10, "")
	else
		txtTitle:setText(LocalStrings.ACTIVITY_TEXT84)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7023, 2, "")
	end
end

function WndHoraryLevReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndHoraryLevReward:_onGetLevelRewardResult(activityId, doType, result, msg)
	if (activityId == tonumber(g_cityExtenInfo.activity7023) or activityId == tonumber(g_cityExtenInfo.activity7029)) and (doType == 2 or doType == 10) then
		msg = json.decode(msg)
		self.m_tLevelRewardData = self:setLevelRewardData(msg)
		local rewardFreeList = GetElement(self.m_root,"rewardFreeList",WZUIFreeListContainer)
		rewardFreeList:removeAll()
		WndDollMachineTask:taskTableSort(self.m_tLevelRewardData)
		for i = 1, #self.m_tLevelRewardData do
			local element, tLuaObj = HoraryLevelRewardItem:createElement()
			self.m_tCellLevelItem[i] = tLuaObj
			rewardFreeList:pushBack(WZUIContainer:luaTo(element))
			rewardFreeList:getMoveElement():setPositionY(rewardFreeList:getMinPosition().y)
			tLuaObj:setRewardData(i,self.m_tLevelRewardData[i], self.m_nRewardType)
		end
	end
end

function WndHoraryLevReward:_onHoraryLevelResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	if self.m_tLevelRewardData then
		for i=1, #self.m_tLevelRewardData do
			if rewardId == self.m_tLevelRewardData[i].id then
				self.m_tLevelRewardData[i].status = 1
				break
			end
		end
		WndDollMachineTask:taskTableSort(self.m_tLevelRewardData)
		for i,v in ipairs(self.m_tCellLevelItem) do
			if v then
				v:setLevelItemMessage(i, self.m_tLevelRewardData[i], self.m_nRewardType)
			end
		end

		local status = false
		for i,v in pairs(self.m_tLevelRewardData) do
			if v.status == 0 then
				status = true
				break
			end
		end
		if self.m_nRewardType == 1 then
			GlobalGame.g_tRedPointTypeList[27029] = status
			WndHouseMain:setLevelRewardRedPoint()
			local red_point = GlobalGame.g_tRedPointTypeList[27029] or GlobalGame.g_tRedPointTypeList[17029]
    		SceneCity:setSceneMainIconRedPoint(HOUSEINVEST_ACTIVITY, red_point)
		else
			GlobalGame.g_tRedPointTypeList[17023] = status
			WndMainHorary:setLevelRedPoint()
			local red_point = GlobalGame.g_tRedPointTypeList[117023] or GlobalGame.g_tRedPointTypeList[127023] or GlobalGame.g_tRedPointTypeList[17023]
	    	SceneCity:setSceneMainIconRedPoint(HORARY_ACTIVITY, red_point)
	    end
	end
end


-------------------------------------私有方法模块End----------------------------------------
