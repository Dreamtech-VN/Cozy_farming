--WndPastureMount.lua
--@brief	WndPastureMount的UI模块
--@date		2021/04/17
--@author	hyx
--@note		牧场坐骑


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPastureMount:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPastureMount:onExit(element)
	self:unregister()
	self:_unInit()
end
function WndPastureMount:register()
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_CollectMountInfo,self._onGetCollectMountInfo,self)
	GlobalGame:getGameEventDispathcer():Add(PastureEvent.PastureEvent_MountCollectFinish,self._onCollectMountResult,self)
end
function WndPastureMount:unregister()
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_CollectMountInfo,self._onGetCollectMountInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(PastureEvent.PastureEvent_MountCollectFinish,self._onCollectMountResult,self)
end
--打开界面
function WndPastureMount:showInterface()   
	local wndMount = WndPastureMount:createElement()
	if wndMount ~= nil then
	    WindowManager:addWindow(wndMount,WndPastureMount,nil,false)
	end
end

function WndPastureMount:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPastureMount:actionCallback()
	self:initShow()
	ProtocolProcessorFamily:send_MOUNTSPASTURE_GetPastureCollectInfo()
end
function WndPastureMount:initShow()
	
end

function WndPastureMount:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPastureMount:_onGetCollectMountInfo(collectId, progress, status)
    local temp_data = {}
	for i=1,#collectId do
		local tab = {}
		tab.collectId = collectId[i]
		tab.progress = progress[i]
		tab.status = status[i]
		self.m_tCollectData[tab.collectId] = tab
	end
    self:createCellTask()
end
--每一次合成之后需要判断是否有新的任务插入
function WndPastureMount:createCellTask()
	local data = self:setCollectMountData()
    local mountFreeListContainer = GetElement(self.m_root,"mountFreeListContainer",WZUIFreeListContainer)
	mountFreeListContainer:removeAll()
	for i = 1, #data do
		local element, tLuaObj = PastureMountItem:createElement()
		mountFreeListContainer:pushBack(WZUIContainer:luaTo(element))
		mountFreeListContainer:getMoveElement():setPositionY(mountFreeListContainer:getMinPosition().y)
		tLuaObj:setMountCellItem(data[i])
	end
end
function WndPastureMount:_onCollectMountResult(collectId)
	MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT39)
	for i=1,#self.m_tCollectData do
		if self.m_tCollectData[i].collectId == collectId then
			self.m_tCollectData[i].status = 1
			break
		end
	end
	local info = GDatatab_pasture_collect["id_"..collectId]
	if info and info.effect and info.effect[1][1] == -1 then
		WndPastureBusiness:setCollectTime(true, info.effect[1][2])
		WndPastureBusiness:setWorkerMakeTime( )
		WndPastureBusiness:setCollectTime(false)
	end
	self:createCellTask()
end

-------------------------------------私有方法模块End----------------------------------------
