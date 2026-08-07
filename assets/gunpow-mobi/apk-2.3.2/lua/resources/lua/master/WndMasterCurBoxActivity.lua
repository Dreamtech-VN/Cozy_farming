--WndMasterCurBoxActivity.lua
--@brief	WndMasterCurBoxActivity的UI模块
--@date		2021/08/17
--@author	hyx
--@note		师门宝箱当前活跃度


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterCurBoxActivity:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterCurBoxActivity:onExit(element)
	self:_unInit()
	self:unregister()
end
function WndMasterCurBoxActivity:showInterface(playerid)
	local wndCurActivity = WndMasterCurBoxActivity:createElement()
	if wndCurActivity ~= nil then
	    WindowManager:addWindow(wndCurActivity,WndMasterCurBoxActivity,nil,false)
	end
	self:setData(playerid)
end
function WndMasterCurBoxActivity:register()
	GlobalGame:getGameEventDispathcer():Add(FriendEvent.FriendEvent_TeachActivityBox,self._onGetDiscipleInfo,self)
end
function WndMasterCurBoxActivity:unregister()
	GlobalGame:getGameEventDispathcer():Remove(FriendEvent.FriendEvent_TeachActivityBox,self._onGetDiscipleInfo,self)
end
function WndMasterCurBoxActivity:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndMasterCurBoxActivity:actionCallback()
	ProtocolProcessorWndMaster:send_MENTORING_GetBagInfo(self.m_nPlayerId)
end

function WndMasterCurBoxActivity:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMasterCurBoxActivity:_onGetDiscipleInfo(playerId, progress, bagType, status)
	if not self.m_root then return end

	if playerId ~= 0 then
		local str_box = {"ui/task/task_activity_close3.png","ui/task/task_activity_close4.png","ui/task/task_activity_close5.png"}
		GetElement(self.m_root,"imgChooseBox",WZUIImage):setFile(str_box[bagType])
		GetElement(self.m_root,"txtCurActivityCount",WZUILabelTTF):setText(progress)
		
		local curTaskFreeList = GetElement(self.m_root,"curTaskFreeList",WZUIFreeListContainer)
		curTaskFreeList:removeAll()
		local data = self:setRewardData(bagType, true)
		for i = 1, #data do
			local element, tLuaObj = BoxCurActivityTaskItem:createElement()
			curTaskFreeList:pushBack(WZUIContainer:luaTo(element))
			curTaskFreeList:getMoveElement():setPositionY(curTaskFreeList:getMinPosition().y)
			tLuaObj:setCurActivityData(data[i])
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
