--WndKidServantData.lua
--@brief	WndKidServant的数据模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小孩雇佣佣人界面

WndKidServant = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidServant:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCost = nil 					--雇佣消耗
	self.m_tAddTimeCost = nil 			--增加时长消耗
	self.m_nLeftTime = 0 				--佣人倒計時
	self.m_tClickCell = nil 
	self.m_tClickData = nil 
	self.m_nMaxHour = nil 				--佣人最大时间上限
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidServant:_unInit()
	self.m_root = nil
	self.m_tCost = nil 
	self.m_tAddTimeCost = nil 			--增加时长消耗
	self.m_nLeftTime = nil 				--佣人倒計時
	self.m_tClickCell = nil 
	self.m_tClickData = nil 
	self.m_nMaxHour = nil 				--佣人最大时间上限
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidServant:createElement()
	if WndKidServant.m_root ~= nil then
		WindowManager:removeWindow(WndKidServant.m_root, WndKidServant, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidServant")
	assert(element, "WndKidServant create element failed!")
	self:_init()
	return element
end

--@brief 	雇佣佣人成功
function WndKidServant:servantSuccess(lastTime)
	-- body
	SceneKidHome:_stopLoading()
	MsgBoxManager:showTipBox(LocalStrings.KID_TEXT40)
	WZLog("WndKidServant:servantSuccess")
	if SceneKidHome.m_root then
		SceneKidHome.m_bHavedServant = 1
		SceneKidHome.m_nServantTime = lastTime
	end
	if self.m_root == nil then return end 
	self.m_nLeftTime = lastTime
	self:_setShowContent()
end

--@brief 	增加佣人时长成功
function WndKidServant:addServantTimeOK(lastTime, bearLastTime, childId, childStatus, growthValue)
	-- body
	SceneKidHome:_stopLoading()
	MsgBoxManager:showTipBox(LocalStrings.KID_TEXT41)

	local bSetSchedule = false 
	if SceneKidHome.m_nServantTime <= 0 then
		bSetSchedule = true
	end
	SceneKidHome.m_nServantTime = lastTime
	if self.m_root then
		self.m_nLeftTime = lastTime
		self:_showTime()
	end
	if bSetSchedule then
		if self.m_root then
			self.m_root:enableSchedule("_showTime", 1)
		end
		SceneKidHome:createServant()
	end

	SceneKidHome:updateKidDataWithServant(bearLastTime, childId, childStatus, growthValue)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
