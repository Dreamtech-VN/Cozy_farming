--WndPastureBusiness.lua
--@brief	WndPastureBusiness的UI模块
--@date		2021/04/17
--@author	hyx
--@note		牧场
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPastureBusiness:onEnter(element)
	self.m_root = element
	self:register()
	ProtocolProcessorFamily:regAll1()
	ChangeChatChannel(Chat_Channel_Pasture)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPastureBusiness:onExit(element)
	ChangeChatChannel(Chat_Channel_Pasture_Exit)
	self:_unInit()
	self:unregister()
end
function WndPastureBusiness:register()
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_MountUpgrade,self._onPastureLevelUpgradeResult,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_ItemChanged,self._onPastureItemChangeResult,self)
end
function WndPastureBusiness:unregister()
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_MountUpgrade,self._onPastureLevelUpgradeResult,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_ItemChanged,self._onPastureItemChangeResult,self)
end
--打开界面
function WndPastureBusiness:showInterface(m_nPlayerId,index)   
	local wndBusiness = WndPastureBusiness:createElement()
	if wndBusiness ~= nil then
	    WindowManager:addWindow(wndBusiness,WndPastureBusiness,nil,false)
	end
	self.m_nPlayerId = m_nPlayerId
	self.m_nCurIndex = index or 1
end
function WndPastureBusiness:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
	ProtocolProcessorFamily:send_MOUNTSPASTURE_PasturelandUpgrade(CacheCenter:getPlayerInfo().id)
end
function WndPastureBusiness:actionCallback()
	self:initShow()
end
function WndPastureBusiness:initShow()
	self:setPastureLevelExp()
	local itemContainer = GetElement(self.m_root,"itemContainer",WZUIContainer)
	local element, tObj = CellPastureAnimal:createElement(self.m_nPlayerId)
	itemContainer:addChild(element)
	self.m_isOpenView[1] = tObj
end

function WndPastureBusiness:createWorker()
	local element, tObj = CellPastureWorker:createElement()
	self.m_root:addChild(element, 10)
	self.m_isOpenView[2] = tObj
end
--牧场升级
function WndPastureBusiness:_onPastureLevelUpgradeResult(exp, level)
	if level < 2 then
		level = 2
	end
	WndPastureUpGrade:showInterface(level)
	if self.m_isOpenView[1] and self.m_isOpenView[1].setPastureLevelORExp then
		self.m_isOpenView[1]:setPastureLevel(level)
		self.m_isOpenView[1]:setPastureLevelORExp( exp, level )
	end
end

function WndPastureBusiness:updatePlayerItemData(num)
	if self.m_isOpenView[1] and self.m_isOpenView[1].updatePastureItemData then
		self.m_isOpenView[1]:updatePastureItemData(num)
	end
end

--工坊的进度条
function WndPastureBusiness:setWorkerBaseInfo( )
	if self.m_isOpenView[2] and self.m_isOpenView[2].setWorkerBaseInfo then
		self.m_isOpenView[2]:setWorkerBaseInfo()
	end
end
--工坊的制作时间
function WndPastureBusiness:setWorkerMakeTime( )
	if self.m_isOpenView[2] and self.m_isOpenView[2].setMakeShowTime then
		self.m_isOpenView[2]:setMakeShowTime()
	end
end
--工坊的精华数量
function WndPastureBusiness:setWorkerCreamNum( num )
	if self.m_isOpenView[2] and self.m_isOpenView[2].setWorkerCreamNum then
		self.m_isOpenView[2]:setWorkerCreamNum(num)
	end
end

function WndPastureBusiness:_onPastureItemChangeResult(key, num)
	for i=1,#key do
		if key[i] == 97 then
			WndPastureBusiness:setCoinNumber(num[i])
			self:updatePlayerItemData(num[i])
		elseif key[i] == 99 then
			WndPastureBusiness:setWorkerNumber(num[i])
			self:setWorkerCreamNum( num[i] )
		end
	end
end

-- -------------------------------------私有方法模块End----------------------------------------
