--WndFamilyTrainData.lua
--@brief	WndFamilyTrain的数据模块
--@date		2017/09/15
--@author	Tianxiang_Xu
--@note		家园饲养探险界面

WndFamilyTrain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFamilyTrain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRewardList = nil 	
	self.m_nLeftSeconds = nil 				--剩余时间
	self.m_nTotalTimes = nil 			--总次数
	self.m_nUsedTimes = nil 			--已使用次数
	self.m_tBuildingData = nil 			--建筑数据
	self.m_conReward = nil 		
	self.m_nLoadingId = nil 	
	self.m_nMaxTotalTimes = nil 		--最大的次数	
	self.m_nOperateType = 0 			--标记获取建筑信息的类型
	self.m_nSpeedPriceId = nil 
	self.m_nSpeedPriceValue = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFamilyTrain:_unInit()
	self.m_root = nil
	self.m_tRewardList = nil 	
	self.m_nLeftSeconds = nil 
	self.m_nTotalTimes = nil 			--总次数
	self.m_nUsedTimes = nil 
	self.m_tBuildingData = nil 			--建筑数据 
	self.m_conReward = nil 		
	self.m_nLoadingId = nil 
	self.m_nMaxTotalTimes = nil		
	self.m_nOperateType = nil
	self.m_nSpeedPriceId = nil 
	self.m_nSpeedPriceValue = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFamilyTrain:createElement()
	if WndFamilyTrain.m_root ~= nil then
		WindowManager:removeWindow(WndFamilyTrain.m_root, WndFamilyTrain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFamilyTrain")
	assert(element, "WndFamilyTrain create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--@param 	tBuildingData:建筑数据
function WndFamilyTrain:showInterface(tBuildingData)
	-- body
	local wndFamilyTrain = WndFamilyTrain:createElement()
	if wndFamilyTrain then
		self.m_tBuildingData = CopyTable(tBuildingData) 
		WindowManager:addWindow(wndFamilyTrain, WndFamilyTrain, nil, nil, nil, true)
	end
end

--@brief 	设置数据
function WndFamilyTrain:setTrainData(x, y, info)
	-- body
	self:_stopLoading()

	local tInfo = json.decode(info)
	WZLog("WndFamilyTrain:setTrainData", Serialize(tInfo))
	self.m_nLeftSeconds = tInfo.countdown  	--饲养剩余时间
	self.m_nUsedTimes = tInfo.times 	--已使用次数
	--设置奖励数据
	self:setRewardData(tInfo.item, tInfo.num)

	if self.m_nOperateType == 0 then
		self.m_nOperateType = 1
		self:_update()
	else
		self.m_tBuildingData.buildingStatus = tInfo.status
		self:_setStaticText()
		if self.m_conReward:isVisible() then 
			self:_showRewardList()
		end
		if self.m_nOperateType == 2 then 
			self.m_nOperateType = 1
			if self.m_nLeftSeconds > 0 then 
		        self.m_root:enableSchedule("_caculateTime", 1)
		    end
		end
	end
end

--@brief 	设置奖励数据
function WndFamilyTrain:setRewardData(id, num)
	-- body
	self.m_tRewardList = {}

	for i = 1, #id do
		local tItem = {}
		tItem.id = id[i]
		tItem.num = num[i]

		table.insert(self.m_tRewardList, tItem)
	end
end

--@brief 	开始饲养或探索成功
function WndFamilyTrain:startToFeedOrSearchOK()
	-- body
	self:_stopLoading()
	WZLog("WndFamilyTrain:startToFeedOrSearchOK", self.m_nLeftSeconds, self.m_tBuildingData.buildingStatus)
	SceneFamily:resetClickBuildingAfterFinish(self.m_tBuildingData.indexX, self.m_tBuildingData.indexY, self.m_tBuildingData.buildingStatus)
end

--@brief 	加速饲养或探索成功
function WndFamilyTrain:speedupFeedOK()
	-- body
	self:_stopLoading()
	WZLog("WndFamilyTrain:speedupFeedOK")
	--刷新状态和奖励列表
	self:_setStaticText()
end


--@brief 	领取奖励成功
function WndFamilyTrain:reveiveRewardOK(id, num)
	-- body
	self:_stopLoading()
	WndRewardShow:showById(id, num)
	--刷新界面信息
	self.m_tRewardList = {}
	self:_setStaticText()
	--更新建筑操作按钮
	WZLog("WndFamilyTrain:reveiveRewardOK", self.m_tBuildingData.buildingStatus)
	SceneFamily:resetClickBuildingAfterFinish(self.m_tBuildingData.indexX, self.m_tBuildingData.indexY, self.m_tBuildingData.buildingStatus)
end

--@brief 	获取每日可使用的总次数
function WndFamilyTrain:getDailyTotalTimes()
	-- body
	local tData = self.m_tBuildingData.basicData 
	local tTempData 
	if tData.sub_type == 5 then 
		tTempData = CacheCenter:getGameParam()["homeFeedingFarmTimelimit"]
	elseif tData.sub_type == 6 then 
		tTempData = CacheCenter:getGameParam()["homeWarpGateTimeLimit"]
	end

	WZLog("WndFamilyTrain:getDailyTotalTimes", tTempData)
	local tLevel, tTimes = SplitItemString(tTempData)
	local nMainRoomLeve = SceneFamily:getMainRoomLevel()

	local nMaxTimes = 0 
	for i = 1, #tLevel do
		if tonumber(tLevel[i]) == nMainRoomLeve then 
			self.m_nTotalTimes = tonumber(tTimes[i])
		end
		if tonumber(tTimes[i]) > nMaxTimes then 
			nMaxTimes = tonumber(tTimes[i])
		end
	end

	self.m_nMaxTotalTimes = nMaxTimes
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	返回饲养或探险状态
--@retuen 	0:空闲中；4:饲养或探险中；5:完成（可以领取奖励）
function WndFamilyTrain:_getTrainState()
	-- body
	local nState = self.m_tBuildingData.buildingStatus

	return nState 
end

--@brief    数据加载动画
function WndFamilyTrain:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndFamilyTrain:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end
-------------------------------------私有方法模块End----------------------------------------
