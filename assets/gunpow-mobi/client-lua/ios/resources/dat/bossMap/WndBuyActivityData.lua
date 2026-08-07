--WndBuyActivityData.lua
--@brief	WndBuyActivity的数据模块
--@date		2014/08/21
--@author	hugozheng
--@note		购买活力面板

WndBuyActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBuyActivity:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_data = nil                   --数据
    self.m_price = nil                  --购买价格
    self.m_vigor = nil                  --获得活力
	self.m_tGold = nil 					--金币
	self.m_tPricrResult = nil 			--获取当前购买信息

    self.m_tBaseData = nil              --界面的基础数据
    self.m_UsedCount = nil                    --已经使用的次数
    self.m_tBuyResult = nil             --购买成功后返回的结果
    self.m_nFullReSeconds = nil         --完全恢复所用的秒数
    self.m_nNextReSeconds = nil         --下点恢复所用的秒数
    self.m_bIsSendAgain = true          --用于标记获取剩余时间成功后，是否再次发送获取使用次数的协议
    self.m_nCountTimeID = nil           --计时器ID
    self.m_sLanguage = nil              --当前语言
    self.m_nCostCurDay = 0              --当天消耗的钻石
    self.m_nCousumeMax = nil            --返还的消耗额度
    self.m_nReturnNum = nil 
    self.m_nTotalCost = 0 
    self.m_nTempCost = 0 
    self.m_tResultAddNum = nil          --矿晶购买的结果
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndBuyActivity:_unInit()
    self.m_root = nil
    self.m_data = nil
    self.m_price = nil 
    self.m_vigor = nil 
    self.m_tGold = nil 
    self.m_tPricrResult = nil 

    self.m_tBaseData = nil              --界面的基础数据
    self.m_UsedCount = nil                    --已经使用的次数
    self.m_tBuyResult = nil             --购买成功后返回的结果
    self.m_nFullReSeconds = nil         --完全恢复所用的秒数
    self.m_nNextReSeconds = nil         --下点恢复所用的秒数
    self.m_bIsSendAgain = nil           --用于标记获取剩余时间成功后，是否再次发送获取使用次数的协议
    self.m_nCountTimeID = nil           --计时器ID
    self.m_sLanguage = nil 
    self.m_nCostCurDay = nil              --当天消耗的钻石
    self.m_nCousumeMax = nil 
    self.m_nReturnNum = nil 
    self.m_nTotalCost = nil 
    self.m_nTempCost = nil 
    self.m_tResultAddNum = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBuyActivity:createElement()
	local element = WZUISystem:getInstance():createElement("WndBuyActivity")
	assert(element, "WndBuyActivity create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------
--@brief	初始化数据
--@param	nowAct：当前活力
--@param	totalAct：总活力
--@param	nowCout：剩余购买次数
--@note		
function WndBuyActivity:initData(nowAct,totalAct,nowCout)
    self.m_data = {}
    self.m_data.nowActivity = nowAct
    self.m_data.totalActivity = totalAct
    self.m_data.count = nowCout
	self:_setImgTitle(true,false)
end

--@brief 	确认缓存数据是否来到更新界面
function WndBuyActivity:getStartInfoList()
	local  bIsHasInfo = CacheCenter:hasPlayerInfo()
	if bIsHasInfo == true then
		WZLog("缓存数据已经到来直接更新界面")
		--玩家信息
		self:_recvGold(CacheCenter:getMoneyList())
	else
    	WZLog("等待缓存数据到来")
	end
end

--@brief	接收缓存信息
function WndBuyActivity:_recvGold(tData)
	self.m_tGold = {} --获取玩家信息列表
	self.m_tGold = tData
end

--@brief     获取服务器发过来的数据
--@param    #1购买的类型：1金币；2体力
--@param    #2用户已经使用了的次数
function WndBuyActivity:getDataFromServer(nType, nUsedCount, costCurDay)
    -- body
    self:closeLoading()

    self.m_UsedCount = nUsedCount 
    self.m_nCostCurDay = costCurDay
    self:setBaseInfo(nType - 1, CacheCenter:getPlayerInfo().vipLevel)
    self:getBaseInfo(nType - 1, CacheCenter:getPlayerInfo().vipLevel)
end

--@brief    设置相应Vip等级下的最大限购次数：购买金币或购买钻石,消耗的钻石，获得的结果值
--@param    #1购买的类型：1-1:金币；2-1:体力(要跟本地数据表中的类型匹配，所以要减1)
--@param    #2用户vip等级
function WndBuyActivity:setBaseInfo(nType, nVipLevel)
    -- body
    WZLog("********* WndBuyActivity:setBaseInfo *********", nType, nVipLevel)
    local nMaxCount = 0
    local tMaxIndex = nil
    local tCurIndex = nil 

    for k, v in pairs(GDatatab_vip_restriction) do 
        if v.type == nType and v.vip_level <= nVipLevel then 
            if v.count > nMaxCount and (tMaxIndex == nil or tMaxIndex.vip_level <= v.vip_level) then
                nMaxCount = v.count 
                tMaxIndex = { id = v.id, ntype = v.type, parameter = v.parameter, vip_level = v.vip_level, count = v.count, cost = v.cost,result = v.result}
            end
        end
        if v.type == nType and v.count - 1 == self.m_UsedCount then 
            tCurIndex = { id = v.id, ntype = v.type, parameter = v.parameter, vip_level = v.vip_level, count = v.count, cost = v.cost,result = v.result}
        end
    end

    if self.m_UsedCount == nMaxCount then
        tCurIndex = tMaxIndex
    end

    WZLog("WndBuyActivity:getBaseInfo 11111111  ", tCurIndex.cost[1][1], tCurIndex.cost[1][2], tCurIndex.result[1][1], tCurIndex.result[1][2])
    if self.m_tBaseData == nil then
        self.m_tBaseData = {}
    end
    self.m_tBaseData.nType = nType              --购买的类型：0：购买金币； 1：购买活力
    self.m_tBaseData.nVipLevel = nVipLevel      --vip等级
    self.m_tBaseData.nMaxCount = nMaxCount      --最大限购次数
    self.m_tBaseData.nLeftCount = self.m_tBaseData.nMaxCount - self.m_UsedCount  -- 剩余可购买次数
    self.m_tBaseData.nCostType = tCurIndex.cost[1][1]              --消耗的货币类型
    self.m_tBaseData.nCostValue = tCurIndex.cost[1][2]             --消耗的货币数量
    self.m_tBaseData.nResultType = tCurIndex.result[1][1]          --获得的结果类型
    self.m_tBaseData.nResultValue = tCurIndex.result[1][2]         --获得的结果数量
end

--@brief    从服务器获取购买的结果
--@param    #1购买后增加的结果数量addNum{}
--@param    #2相应的暴击倍数multiple{}
--@param    #3购买类型：1：金币；2：活力
function WndBuyActivity:setBuyResultData(addNum, multiple, limitItem, costCurDay, returnNum)
    --body
    self:closeLoading()
    WZLog("*************** WndBuyActivity:setBuyResultData **************",addNum:size())

    self.m_tBuyResult = {}
    for i = 0, addNum:size() - 1 do
        local tResult = {}
        tResult.nLimitItem = limitItem
        tResult.nAddNum = addNum:get(i)
        tResult.nMultiple = multiple:get(i)

        WZLog("****************************", limitItem, addNum:get(i), multiple:get(i))

        table.insert(self.m_tBuyResult, tResult)
    end
    if self.m_tBaseData.nType ~= 13 and self.m_tBaseData.nType ~= 15 and self.m_tBaseData.nType ~= 16 and self.m_tBaseData.nType ~= 17 then
        local eachRtnNum = self:getReturnData()
        self.m_nReturnNum = returnNum
        self.m_nTempCost = self.m_nCostCurDay   --保存上次的进度
        self.m_nTotalCost = (self.m_nReturnNum/eachRtnNum) * self.m_nCousumeMax + costCurDay - self.m_nCostCurDay    --计算本次总进度
        self.m_nCostCurDay = costCurDay 
        WZLog("*********** setBuyResultData 11111**********", eachRtnNum, self.m_nReturnNum, self.m_nTempCost, self.m_nTotalCost, self.m_nCousumeMax)
        self:showProgress()
        self.m_UsedCount = self.m_UsedCount +  addNum:size()
    else
        self.m_UsedCount = returnNum
    end

    self:setBaseInfo(self.m_tBaseData.nType, CacheCenter:getPlayerInfo().vipLevel)
    self:action3()
    self.m_root:enableSchedule("action3", 0.8)
    self:updateLeftCount()
    --如果是购买了活力重新获取恢复时间
    if limitItem == 2 then
        WZLog("******** 11111 ***********")
        ProtocolProcessorWndShop:send_MALL_GetLimitedTime(2)
    end
end

--@brief    从服务器获取的完全恢复体力所需的时间
--@param    #1类型：1：金币；2：体力
--@param    #2剩余时间
function WndBuyActivity:setLeftTime(nType, nLeftTime, nFullTime)
    -- body
    WZLog("******** WndBuyActivity:setLeftTime ***********")
    self:closeLoading()
    self.m_nFullReSeconds = nFullTime
    self.m_nNextReSeconds = nLeftTime

    self:updateLeftTime(self.m_nFullReSeconds, self.m_nNextReSeconds)
end

--@brief    为WndBuyFiveAttention 返回显示所需的数据
function WndBuyActivity:returnAttData()
    -- body
    local nCount = 2
    if self.m_tBaseData.nLeftCount > 5 then 
        nCount = 5
    else
        nCount = self.m_tBaseData.nLeftCount
    end

    if self.m_tBaseData.nType == 15 then
        local nLeftNum = tonumber(CacheCenter:getTabooCoinMaxNum()) - tonumber(CacheCenter:getPlayerItemCountById(60))
        if nCount > nLeftNum and nLeftNum > 0 then
            nCount = nLeftNum
        end
    end

    local nUseCountIndex = self.m_UsedCount
    local nCostDiamond = 0 
    local nGainValue = 0 
    local nCostId 
    self.m_tResultAddNum = {}

    for i = 1, nCount do
        for k, v in pairs(GDatatab_vip_restriction) do 
            if v.type == self.m_tBaseData.nType and v.count - 1 == nUseCountIndex then 
                nCostDiamond = nCostDiamond + v.cost[1][2]
                nGainValue = nGainValue + v.result[1][2]
                nCostId = v.cost[1][1]

                table.insert(self.m_tResultAddNum, v.result[1][2])
                break
            end
        end
        nUseCountIndex = nUseCountIndex + 1
    end

    return nCount, nCostDiamond, nGainValue, nCostId
end

--@brief    设置self.m_price的值
function WndBuyActivity:setPriceValue(nType, nCostDias, nLeftCount)
    -- body
    local nNeedNum = CacheCenter:getMoneyList().blueDiamond
    if self.m_tBaseData.nCostType == 70 then
        nNeedNum = CacheCenter:getMoneyList().ticket
    end
    
    if nLeftCount == 0 then 
        self.m_price = -1 
    elseif nCostDias > nNeedNum then 
        self.m_price = -2 
    elseif nType == 1 and CacheCenter:getPlayerInfo().vigor >= 999 then  --活力达到上限，不可购买
        self.m_price = -3
    else
        self.m_price = nLeftCount
    end
end

--@brief    当充值vip等级提升时，刷新vip相关信息
function WndBuyActivity:updateVipInfo()
    -- body
    if self.m_root == nil then return end 

    self:setBaseInfo(self.m_tBaseData.nType, CacheCenter:getPlayerInfo().vipLevel)
    self:getBaseInfo(self.m_tBaseData.nType, CacheCenter:getPlayerInfo().vipLevel)
end
-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function WndBuyActivity:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndBuyActivity:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end

--@brief    获取相应vip等级的返还数据
function WndBuyActivity:getReturnData()
    -- body
    local vipLevel = CacheCenter:getPlayerInfo().vipLevel

    for i, value in pairs(GDatatab_consume_return_diamond) do
        if value.vip_level == vipLevel then
            if self.m_tBaseData.nType == 0 then
                return value.plutus_cat_return
            elseif self.m_tBaseData.nType == 1 then
                return value.buy_vigor_return
            end
        end
    end

    return 0 
end

--@brief    滚动显示消耗进度
function WndBuyActivity:showProgress()
    -- body
    local conConsume = GetElement(self.m_root, "conConsume_WndBuyActivity", WZUIContainer)
    if conConsume then
        WZLog("WndBuyActivity:showProgress")
        conConsume:enableSchedule("displayPrg", 0.008)
    end
end

function WndBuyActivity:displayPrg()
    -- body
    WZLog("WndBuyActivity:displayPrg", self.m_nTempCost, self.m_nTotalCost)
    local conConsume = GetElement(self.m_root, "conConsume_WndBuyActivity", WZUIContainer)
    self.m_nTempCost = self.m_nTempCost + 2 
    if self.m_nTempCost >= self.m_nCousumeMax then
        self.m_nTempCost = 0 
    end
    self.m_nTotalCost = self.m_nTotalCost - 2
    if self.m_nTotalCost <= 0 then
        self.m_nTotalCost = 0 
        conConsume:disableSchedule()
        self.m_nTempCost = self.m_nCostCurDay
    end
    self:_updateConsumePrg(self.m_nTempCost)
end
-------------------------------------私有方法模块End----------------------------------
