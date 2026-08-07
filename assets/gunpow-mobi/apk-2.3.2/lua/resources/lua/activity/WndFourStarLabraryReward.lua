--WndFourStarLabraryReward.lua
--@brief	WndFourStarLabraryReward的UI模块
--@date		2021/02/24
--@author	hyx
--@note		图鉴奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFourStarLabraryReward:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFourStarLabraryReward:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndFourStarLabraryReward:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetFourLibraryListInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetResult,self._onGetRewardResult,self)
end
function WndFourStarLabraryReward:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetTaskList,self._onGetFourLibraryListInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetResult,self._onGetRewardResult,self)
end
function WndFourStarLabraryReward:showInterface()
	local wndLibraryReward = WndFourStarLabraryReward:createElement()
	if wndLibraryReward ~= nil then
	    WindowManager:addWindow(wndLibraryReward,WndFourStarLabraryReward,nil,false)
	end
end

function WndFourStarLabraryReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFourStarLabraryReward:actionCallback()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_GetTaskList(g_cityExtenInfo.activity7008, 1)
end

function WndFourStarLabraryReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFourStarLabraryReward:_onGetFourLibraryListInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime)
	if taskType == 1 then
		self:setLibraryTaskListData(id, status)
		self:setShowRewardList()
	end
end
function WndFourStarLabraryReward:_onGetRewardResult(activityId,taskId)
	if self.m_tLibraryRewardData then
		for i,v in pairs(self.m_tLibraryRewardData) do
			if v.id == taskId then
				v.status = 1
				break
			end
		end
		self:taskTableSort(self.m_tLibraryRewardData)
		self:setShowRewardList()
	end
end
--由于存在量少，可以直接采用删除方法
function WndFourStarLabraryReward:setShowRewardList()
	local status = false
	WndFourStar.m_sTaskRedPoint = false
	if self.m_tLibraryRewardData then
		for i,v in pairs(self.m_tLibraryRewardData) do
			if v.status == 0 then
				status = true
				WndFourStar.m_sTaskRedPoint = true
				break
			end
		end
		WndFourStarLabrary:setRewardRedPoint(status)
		WndFourStar:setImgLibraryRedPoint(status)
	end
	local rewardFreeList = GetElement(self.m_root,"rewardFreeListContainer",WZUIFreeListContainer)
	rewardFreeList:removeAll()
	for i = 1, #self.m_tLibraryRewardData do
		local element, tLuaObj = CellLibraryRewardTaskItem:createElement()
		rewardFreeList:pushBack(WZUIContainer:luaTo(element))
		rewardFreeList:getMoveElement():setPositionY(rewardFreeList:getMinPosition().y)
		tLuaObj:setLibraryTaskMessage(i, self.m_tLibraryRewardData[i])
	end
end



-------------------------------------私有方法模块End----------------------------------------
