--WndMasterChooseSKill.lua
--@brief	WndMasterChooseSKill的UI模块
--@date		2021/08/17
--@author	hyx
--@note		师门选择技能


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMasterChooseSKill:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMasterChooseSKill:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndMasterChooseSKill:showInterface()
	local wndskill = WndMasterChooseSKill:createElement()
	if wndskill ~= nil then
	    WindowManager:addWindow(wndskill,WndMasterChooseSKill,nil,false)
	end
end
function WndMasterChooseSKill:register()
	GlobalGame:getGameEventDispathcer():Add(FriendEvent.FriendEvent_SetMasterSkill,self._onSetMasterSkillResult,self)
end
function WndMasterChooseSKill:unregister()
	GlobalGame:getGameEventDispathcer():Remove(FriendEvent.FriendEvent_SetMasterSkill,self._onSetMasterSkillResult,self)
end
function WndMasterChooseSKill:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndMasterChooseSKill:actionCallback()
	local skillFreeList = GetElement(self.m_root,"skillFreeList",WZUIFreeListContainer)
	skillFreeList:removeAll()
	local tData = CacheCenter:getSkill()
    if next(tData.unlockSkill) == nil then
    	ShowPanelNullTip(skillFreeList, LocalStrings.OPTIMIZE_TEXT68, ccc3(127,70,26))
    else
		for i = 1, GetTableLen(tData.unlockSkill) do
			local element, tLuaObj = MasterChooseSKillItem:createElement()
			self.m_tChooseItem[i] = tLuaObj
			skillFreeList:pushBack(WZUIContainer:luaTo(element))
			skillFreeList:getMoveElement():setPositionY(skillFreeList:getMinPosition().y)
			tLuaObj:setChooseSkill(i, tData.unlockSkill[i])
			tLuaObj:setChooseFunc(function(index, id)
				self:setChooseSelect(index, id)
			end)
		end
	end
end
function WndMasterChooseSKill:setChooseSelect(index, id)
	if self.m_nChooseIndex == index then
		return
	end
	if self.m_nChooseIndex then
		self.m_tChooseItem[self.m_nChooseIndex]:setImageChooseStatus(false)
	end
	self.m_tChooseItem[index]:setImageChooseStatus(true)
	self.m_nChooseSelectID = id
	self.m_nChooseIndex = index
end
function WndMasterChooseSKill:onBtnSure()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nChooseSelectID then
		ProtocolProcessorWndMaster:send_MENTORING_SetMentorSkill(self.m_nChooseSelectID)
	end
end
function WndMasterChooseSKill:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndMasterChooseSKill:_onSetMasterSkillResult(skillId, result)
	if result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.SET_SUCCESS)
		WndMasterMember:setMasterSkillId(skillId)
		WndMasterMember:setMasterSkillInfo(skillId)
		WindowManager:removeWindow(WndMasterChooseSKill.m_root, WndMasterChooseSKill, true)
	else
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT75)
	end
end


-------------------------------------私有方法模块End----------------------------------------
