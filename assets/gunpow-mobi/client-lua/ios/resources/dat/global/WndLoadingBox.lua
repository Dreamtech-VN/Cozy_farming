--WndLoadingBox.lua
--@brief	WndLoadingBox的UI模块
--@date		2013/12/19
--@author	xiaoyu_wu
--@note		加载框模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndLoadingBox:onEnter(element)
	self.m_root = element
    g_tLoadingBox = self
    self.m_createTime = os.time()
	WZLog("WndLoadingBox:onEnter", tostring(SceneBattle and SceneBattle.m_root),self.m_tMsgData.nTimeout, tostring(self.m_tMsgData.bIsNoSwallowTouch))
	if self.m_tMsgData.nTimeout > 0 then
		self.m_root:enableSchedule("scheduleTimeout", 1)
	end

    self.m_root:setTouchEnable(self.m_tMsgData.bIsNoSwallowTouch ~= true)

    if SceneBattle and SceneBattle.m_root and self.m_tMsgData.bIsNoChangeWifi == nil and WBattleGlobal:getCurrent():isGameOver() ~= true then
        if  WBattleGlobal:getCurrent().m_nRelinkLoading == -1 then
            GetElement(self.m_root,"conWifiOut_WndLoadingBox"):setVisible(true)
            GetElement(self.m_root,"conLoading_WndLoadingBox"):setVisible(false)
            GetElement(self.m_root,"txtWifiOut_WndLoadingBox",WZUILabelTTF):setText(self.m_tMsgData.sText)
            self.m_nShowNetLostTime = 999999

            if WndSingleCopySettlement.m_root then
                MsgBoxManager:stopLoadingBoxByMsgId(self.m_tMsgData.nId)
            end
        end
    else
        GetElement(self.m_root,"conWifiOut_WndLoadingBox"):setVisible(false)
        GetElement(self.m_root,"conLoading_WndLoadingBox"):setVisible(true)
    end

    self.m_nLoadingTimer = os.time()
    local function WindowManager_update()
    if os.time() - self.m_nLoadingTimer >= 15 and self.m_bLoadingTimerStop ~= true then
        self.m_bLoadingTimerStop = true
        MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, self, self.reStrartLoadingTimer, MSGBOXLEVEL_NORMAL, nil,true)
    end
    end
    --self.m_nLoadingTimerScheduleId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(WindowManager_update, 0, false)


end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndLoadingBox:onExit(element)
    if self.m_nLoadingTimerScheduleId ~= nil then
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.m_nLoadingTimerScheduleId)
        self.m_nLoadingTimerScheduleId = nil
    end
    if self.m_tMsgData ~= nil then
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
	end
	self:_unInit()
    g_tLoadingBox = nil
end

--@brief loading计时
function WndLoadingBox:reStrartLoadingTimer()
    WZLog("WndLoadingBox:reStrartLoadingTimer", self.m_nLoadingTimer, os.time())
    self.m_nLoadingTimer = os.time()
    self.m_bLoadingTimerStop = nil
end

--@brief	定时器回调方法
--@param	element:表绑定的UI节点引用
--@param	delta:定时器触发间隔
--@note		超时后回调，并且移出窗口
function WndLoadingBox:scheduleTimeout(element, delta)
	--element:disableSchedule()
    self:updateNetLost()
    if os.time() - self.m_createTime < self.m_tMsgData.nTimeout then
        return
    end
    if self.m_root == nil then
		return
	elseif self.m_tMsgData then--回调函数
		self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
		self:_msgCallBack(MSGBOXRESTYPE_TIMEOUT)
	end
	--如果是添加子类，其它可触摸
	if self.m_tMsgData and self.m_tMsgData.bChild == true then
		self:closeLoading()
	else--添加屏幕loading，其它不能触摸
		WindowManager:removeWindow(self.m_root, self)
	end
end

--@brief	停止加载
--@note		停止加载,移出窗口
function WndLoadingBox:stopLoading()
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root, self)
end

--@note		创建加载框 
function WndLoadingBox:createLoading(element,t)
	if self.m_root == nil and element then
		t = t or 15
		self.m_tMsgData = self.m_tMsgData or {}
		self.m_tMsgData.nTimeout = t
		self.m_tMsgData.bChild = true
		local tCell,luaTable = WndLoadingBox:createElement()
		element:addChild(tCell)
	end
end

--@note		关闭加载框
function WndLoadingBox:closeLoading()
	if self.m_root then
		if self.m_tClose then
			self.m_tClose[2](self.m_tClose[1],self)
		end
		WZLog("关闭加载框")
		self.m_root:removeFromParentAndCleanup(true)
		self.m_root = nil 
	end
end

--@brief	动画完成时的回调方法
function WndLoadingBox:onFinish(element)
	GetElement(self.m_root,"spine1",WZUISpine):setVisible(true)
	GetElement(self.m_root,"spine2",WZUISpine):setVisible(true)
	GetElement(self.m_root,"imgBg_WndLoadingBox",WZUI9Image):setVisible(true)
end

--@brief 掉线定时器
function WndLoadingBox:updateNetLost()
    if self.m_nShowNetLostTime > 0 and self.m_nShowNetLost == nil then
        self.m_nShowNetLostTime = self.m_nShowNetLostTime - 1
        WZLog("WndLoadingBox:updateNetLost", self.m_nShowNetLostTime)
        self.m_nShowNetLost = true
        local con = GetElement(self.m_root,"conWifiOut_WndLoadingBox",WZUIContainer)
        local img = GetElement(self.m_root,"imgWifiOut_WndLoadingBox",WZUIImage)
        con:setVisible(true)
        local time = 0.7
        local actionSeq = WZUIActionSequence:create()
        local action1 = WZUIActionFadeTo:create()
        action1:setDuration(time)
        action1:setOpacity(255)
        local action2 = WZUIActionFadeTo:create()
        action2:setDuration(time)
        action2:setOpacity(125)
        action2:setFinishLuaTable(self)
        action2:setFinishLuaFunction("nextNetLost")
        actionSeq:setChildAction(action1)
        actionSeq:setChildAction(action2)
        img:runUIAction(actionSeq)
    end
end

--@brief 掉线循环
function WndLoadingBox:nextNetLost()
    WZLog("WndLoadingBox:nextNetLost", self.m_nShowNetLostTime)
    self.m_nShowNetLost = nil
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
