--CellBreakEggsPanelData.lua
--@brief	CellBreakEggsPanel的数据模块
--@date		2017/08/23
--@author	Tianxiang_Xu
--@note		砸金蛋活动

CellBreakEggsPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBreakEggsPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tRewardId = nil 
	self.m_nActivityId = nil 
	self.m_nActivityType = nil 
	self.m_tStatus = nil 
	self.m_nTotalDiamond = nil 
	self.m_needDiamond = nil 
	self.m_nHummerNum = nil 	--锤子的数量
	self.m_tEggsCell = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBreakEggsPanel:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tRewardId = nil 
	self.m_nActivityId = nil 
	self.m_nActivityType = nil 
	self.m_tStatus = nil 
	self.m_nTotalDiamond = nil 
	self.m_needDiamond = nil 
	self.m_nHummerNum = nil 	--锤子的数量
	self.m_tEggsCell = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellBreakEggsPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellBreakEggsPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellBreakEggsPanel")
	assert(element, "CellBreakEggsPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据
function CellBreakEggsPanel:setMessage(activityId, startTime, endTime, rewardId, status, maxCount, count, content, nActivityType)
	-- body
	self.m_nActivityId = activityId
	self.m_nStartTime = startTime 
	self.m_nEndTime = endTime 
	self.m_nActivityType = nActivityType 
	self.m_nHummerNum = maxCount 	--锤子的数量
	self.m_content = content 

	self.m_tRewardId = rewardId
	self.m_tStatus = status
	self.m_nTotalDiamond = count 
	self.m_needDiamond = tonumber(CacheCenter:getGameParam()["goldenEggNeedRecharge"]) or 2000
end

--@brief 	砸蛋成功，更新数据
function CellBreakEggsPanel:updateEggsData(rewardId, status)
	-- body
	for i = 1, #CellBreakEggsPanel.m_current.m_tRewardId do
		if CellBreakEggsPanel.m_current.m_tRewardId[i] == rewardId then 
			CellBreakEggsPanel.m_current.m_tStatus[i] = status
			break 
		end
	end

	if CellBreakEggsPanel.m_current.m_nHummerNum > 0 then 
		CellBreakEggsPanel.m_current.m_nHummerNum = CellBreakEggsPanel.m_current.m_nHummerNum - 1
	end
	if CellBreakEggsPanel.m_current.m_nHummerNum == 0 then 
		WndGameActivity:removeRedDot(g_tGameActivityTypes.ACTIVITY_NEWSERVER_BREAKEGGS)
	end
	CellBreakEggsPanel.m_current:_showAttAndHummerNum()
	--改变未砸的金蛋的状态
	for i = 1, #CellBreakEggsPanel.m_current.m_tEggsCell do
		CellBreakEggsPanel.m_current.m_tEggsCell[i]:changeEggType()
	end
	--砸完6个，重刷界面
	if CellBreakEggsPanel.m_current:getBreakTimes() == 7 then 
		WndGameActivity:refreshActivityContext()
	end
end

--@brief 	获取当前是第几次砸蛋
function CellBreakEggsPanel:getBreakTimes()
	-- body
	local nNum = 0 
	for i = 1, #self.m_tStatus do
		if self.m_tStatus[i] == 1 then 
			nNum = nNum + 1
		end
	end

	return nNum + 1
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBreakEggsPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellBreakEggsPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
