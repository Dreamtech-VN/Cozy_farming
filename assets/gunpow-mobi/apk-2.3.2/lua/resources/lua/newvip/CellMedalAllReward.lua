--CellMedalAllReward.lua
--@brief	CellMedalAllReward的UI模块
--@date		2021/04/08
--@author	hyx
--@note		徽章所有奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMedalAllReward:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMedalAllReward:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellMedalAllReward:register()
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_GetMedalRewardResult,self._onGetRewardResult,self)
end
function CellMedalAllReward:unregister()
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_GetMedalRewardResult,self._onGetRewardResult,self)
end
function CellMedalAllReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function CellMedalAllReward:actionCallback()
	self:setShowRewardItem()
end
function CellMedalAllReward:setShowRewardItem()
	local allRewardFreeList = GetElement(self.m_root,"allRewardFreeList",WZUIFreeListContainer)
	allRewardFreeList:removeAll()

	self:taskTableSort(self.m_data)
	for i = 1, #self.m_data do
		if self.m_data[i].reward[1][1] ~= 160061 then 
			local element, tLuaObj = AllRewardItem:createElement()
			allRewardFreeList:pushBack(WZUIContainer:luaTo(element))
			allRewardFreeList:getMoveElement():setPositionY(allRewardFreeList:getMinPosition().y)
			tLuaObj:setAllRewardData(self.m_data[i])
		end
	end
end

function CellMedalAllReward:onBtnClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMedalAllReward:_onGetRewardResult(result, medalLevelId, rewardItemIds, rewardItemNums)
	if result == 1 then
		WndRewardShow:showById(rewardItemIds, rewardItemNums)
		if self.m_data then
			for i=1,#self.m_data do
				if self.m_data[i].id == medalLevelId then
					self.m_data[i].status = 1
					CellNewVipMedal:setChangeRewardStatus(medalLevelId)
					break
				end
			end
			self:setShowRewardItem()
		end
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT26)
	end
end


-------------------------------------私有方法模块End----------------------------------------
