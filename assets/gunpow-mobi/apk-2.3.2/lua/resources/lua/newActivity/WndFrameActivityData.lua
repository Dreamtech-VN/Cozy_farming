--WndFrameActivityData.lua
--@brief	WndFrameActivity的数据模块
--@date		2020/05/15
--@author	XTX
--@note		独立框架活动

WndFrameActivity = {
	--请不要在这里定义变量
}



--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFrameActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurrentSelectTypeId = nil 
	self.m_tCommonPanelElement = nil
    self.m_tCommonPanelLuaObj = nil
    self.m_nStartTime = nil 
    self.m_nEndTime = nil 
    self.m_nLoadingId = nil 
    self.m_nStartTouchTime = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFrameActivity:_unInit()
	self.m_root = nil
	self.m_nCurrentSelectTypeId = nil 
	self.m_tCommonPanelElement = nil
    self.m_tCommonPanelLuaObj = nil
    self.m_nStartTime = nil 
    self.m_nEndTime = nil 
    self.m_nLoadingId = nil 
    self.m_nStartTouchTime = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFrameActivity:createElement()
	if WndFrameActivity.m_root ~= nil then
		WindowManager:removeWindow(WndFrameActivity.m_root, WndFrameActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFrameActivity")
	assert(element, "WndFrameActivity create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--@param 	activityType: 活动类型
function WndFrameActivity:showInterface(activityType)
	-- body
	if g_tGameActivityTypes.ACTIVITY_INVESTREBATE == activityType then 
		if g_cityExtenInfo == nil or g_cityExtenInfo.IRStatus and g_cityExtenInfo.IRStatus == 0 then 
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
			return 
		end
	elseif g_tGameActivityTypes.ACTIVITY_HAPPYSHAKE == activityType then
		if g_cityExtenInfo == nil or g_cityExtenInfo.activityPokerStatus and g_cityExtenInfo.activityPokerStatus == 0 then 
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
			return 
		end
	elseif g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING == activityType then
		if g_cityExtenInfo == nil or g_cityExtenInfo.CDStatus and g_cityExtenInfo.CDStatus == 0 then 
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
			return 
		end
	end
	local wndActivity = WndFrameActivity:createElement()
	if wndActivity then 
		self.m_nCurrentSelectTypeId = activityType
		WindowManager:addWindow(wndActivity, WndFrameActivity, nil, nil, nil, true)
	end
end

--@brief  获得活动内容成功
function WndFrameActivity:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self:_closeLoading()
    WZLog("********* WndFrameActivity:GetActivityInfoOK *****")
    self.m_nStartTime = startTime 
    self.m_nEndTime = endTime 
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
end

--@brief 获取奖励成功
function WndFrameActivity:GetRewardOk(rewardItems, rewardCount, ntype)
    if self.m_root == nil then return end

	WZLog("WndFrameActivity:GetRewardOk types="..ntype)
	if ntype == g_tGameActivityTypes.ACTIVITY_INVESTREBATE then 
		WndInvestRebate:showRewardBox(rewardItems, rewardCount)
	elseif ntype == g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING then
		WndCrazyDoubling:getCrazyDoubleRewrad(0,{1,1,1},rewardItems,rewardCount)
	end
end

--@brief 	获取触摸开始的时间
function WndFrameActivity:getTouchBeginTime()
	-- body
	return self.m_nStartTouchTime
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndFrameActivity:_createLoading()
	if self.m_nLoadingId == nil then 
		self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	end
end

--@brief   关闭加载框
function WndFrameActivity:_closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil 
	end
end




-------------------------------------私有方法模块End----------------------------------------
