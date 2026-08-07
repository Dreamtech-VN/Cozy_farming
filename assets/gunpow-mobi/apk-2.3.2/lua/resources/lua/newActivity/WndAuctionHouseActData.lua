--WndAuctionHouseActData.lua
--@brief	WndAuctionHouseAct的数据模块
--@date		2020/08/03
--@author	yrd
--@note		拍卖行活动主界面

WndAuctionHouseAct = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAuctionHouseAct:_init()
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
function WndAuctionHouseAct:_unInit()
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
function WndAuctionHouseAct:createElement()
	if WndAuctionHouseAct.m_root ~= nil then
		WindowManager:removeWindow(WndAuctionHouseAct.m_root, WndAuctionHouseAct, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAuctionHouseAct")
	assert(element, "WndAuctionHouseAct create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
--@param 	activityType: 活动类型
function WndAuctionHouseAct:showInterface(activityType)
	if g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE == activityType then 
		if g_cityExtenInfo == nil or g_cityExtenInfo.auction == nil or g_cityExtenInfo.auction == 0 then 
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
			return 
		end
	end
	local wndActivity = WndAuctionHouseAct:createElement()
	if wndActivity then 
		self.m_nCurrentSelectTypeId = activityType
		WindowManager:addWindow(wndActivity, WndAuctionHouseAct, nil, nil, nil, true)
	end
end

--@brief  获得活动内容成功
function WndAuctionHouseAct:GetActivityInfoOK(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts,count,maxCount,target)
	self:_closeLoading()
    WZLog("********* WndAuctionHouseAct:GetActivityInfoOK *****")
    self.m_nStartTime = startTime 
    self.m_nEndTime = endTime 
	self:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
end

--@brief 获取奖励成功
function WndAuctionHouseAct:GetRewardOk(rewardItems, rewardCount, ntype)
    if self.m_root == nil then return end

	WZLog("WndAuctionHouseAct:GetRewardOk types="..ntype)
	if ntype == g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE then 
		WndInvestRebate:showRewardBox(rewardItems, rewardCount)
	end
end

--@brief 	获取触摸开始的时间
function WndAuctionHouseAct:getTouchBeginTime()
	-- body
	return self.m_nStartTouchTime
end

--@brief    获取拍卖行活动详情数据
function WndAuctionHouseAct:GetManyCollectDataOK(activityId, startTime, endTime, status, auctions, auction, initPrice, price, name, totalTime, time, weekName, bidInfo, auctionStartTime)
    self:_closeLoading()
	WZLog("WndAuctionHouseAct::GetManyCollectDataOK")
	local conActivityC = GetElement(self.m_root,"conActivityC_WndAuctionHouseAct",WZUIContainer)
    if conActivityC == nil then
        return
    end

    WZLog("WndAuctionHouseAct.m_nCurrentSelectTypeId="..self.m_nCurrentSelectTypeId)
	if g_tGameActivityTypes.ACTIVITY_AUCTION_HOUSE == self.m_nCurrentSelectTypeId then 
		WZLog("WndAuctionHouseAct:_updateActivityContext|| 拍卖行")
		local NodeTag = 1
        local bRet = true
        self.m_tCommonPanelElement = conActivityC:getChildByTag(NodeTag)
        if self.m_tCommonPanelElement ~= nil then
            self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)
            self.m_tCommonPanelLuaObj = CellAuctionHouse
            bRet = false
        else
            bRet = true
            self.m_tCommonPanelElement = CellAuctionHouse:createElement()
            self.m_tCommonPanelLuaObj = CellAuctionHouse
        end
        if bRet then
            conActivityC:addChild(self.m_tCommonPanelElement, 0, NodeTag)
        end
        self.m_tCommonPanelLuaObj:setMessage(activityId, startTime, endTime, status, auctions, auction, initPrice, price, name, totalTime, time, weekName, bidInfo, auctionStartTime)
    end 
    
	if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndAuctionHouseAct:_createLoading()
	if self.m_nLoadingId == nil then 
		self.m_nLoadingId = MsgBoxManager:showLoadingBox()
	end
end

--@brief   关闭加载框
function WndAuctionHouseAct:_closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil 
	end
end




-------------------------------------私有方法模块End----------------------------------------
