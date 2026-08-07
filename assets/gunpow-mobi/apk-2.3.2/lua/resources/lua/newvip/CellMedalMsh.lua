--CellMedalMsh.lua
--@brief	CellMedalMsh的UI模块
--@date		2021/04/08
--@author	hyx
--@note		徽章描述


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMedalMsh:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMedalMsh:onExit(element)
	self:_unInit()
	self:unregister()
end

function CellMedalMsh:register()
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_GetMedalItemInfo,self._onGetMedalInfo,self)
end
function CellMedalMsh:unregister()
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_GetMedalItemInfo,self._onGetMedalInfo,self)
end

function CellMedalMsh:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function CellMedalMsh:actionCallback()
	ProtocolProcessorWndRankList:send_PLAYER2_ReceiveVipMedalStage(self.m_nType )
	GetElement(self.m_root,"name",WZUILabelTTF):setText(self.m_sTitle)
	GetElement(self.m_root,"medal_desc",WZUILabelTTF):setText(self.m_sSubsubtitle)
end

function CellMedalMsh:onBtnClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellMedalMsh:_onGetMedalInfo(medalStageIds, medalStageStatus, medalStageProgress, medalStageTargets)
	self:setCurMedalProgress(medalStageIds, medalStageStatus, medalStageProgress, medalStageTargets)
	local itemMedalFreeList = GetElement(self.m_root,"itemMedalFreeList",WZUIFreeListContainer)
	itemMedalFreeList:removeAll()
	for i = 1, #self.m_tCurMedalData do
		local element, tLuaObj = MedalMsgItem:createElement()
		itemMedalFreeList:pushBack(WZUIContainer:luaTo(element))
		itemMedalFreeList:getMoveElement():setPositionX(itemMedalFreeList:getMaxPosition().x)
		tLuaObj:setData(self.m_tCurMedalData[i],i,#self.m_tCurMedalData)
	end
end


-------------------------------------私有方法模块End----------------------------------------
