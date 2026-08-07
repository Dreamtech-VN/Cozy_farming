--WndVipData.lua
--@brief	WndVip的数据模块
--@date		2015-9-15
--@author	binshao
--@note		VIP模块

WndVip = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndVip:_init()
	self.m_root = nil	 	  	 --场景根节点
    self.rechargeData = nil
    self.btnState = 0
    self.powerDescIndex = 1
    self.loadingId = nil
	self.m_tDataList = nil
    self.TabState = 1
    self.m_tGiftId = nil
    self.m_tGiftNum = nil
    self.m_bIsOpenWeb = false
    self.m_nWebCount = 0
    self.m_nCardActivityState = nil  --月卡打折活动状态：0存在，1不存在
    self.m_nBuyCardTimes = nil      --活动期间已经购买的次数
    self.m_nCardActivityEndTime = nil  --活动结束时间
    self.m_conMid = nil 
    self.m_isNoWnd = false 
    self.m_needUpdate = nil 
    self.m_TempRoot = nil 
    self.m_bIsFirstTime = true 
    self.m_tWeekPackageList = nil   --周礼包列表
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndVip:_unInit()
    self.m_root = nil
    self.rechargeData = nil
    self.btnState = nil
    self.powerDescIndex = nil
    self.loadingId = nil
    self.m_tDataList = nil
    self.TabState = 1
    self.m_tGiftId = nil
    self.m_tGiftNum = nil
    self.m_bIsOpenWeb = false
    self.m_nWebCount = 0
    self.m_nCardActivityState = nil  --月卡活动状态：0存在，1不存在
    self.m_nBuyCardTimes = nil      --活动期间已经购买的次数
    self.m_nCardActivityEndTime = nil  --活动结束时间
    self.m_conMid = nil 
    self.m_isNoWnd = nil  
    self.m_needUpdate = nil 
    self.m_TempRoot = nil 
    self.m_bIsFirstTime = nil 
    self.m_tWeekPackageList = nil 
end

function WndVip:setGiftList(ids, icons, number, giftNumber, price, payCodeId, flag, name, remark,showPrice,itemId,sortId,leftTimes, limitType, needVipLv)
    
    self.m_tGiftList = {}
    for i = 1, #ids do
        local info = {
            ids = ids[i],
            icons = "ui/vip/payment_7_shengxing.png",--icons[i],
            number = number[i],
            giftNumber = giftNumber[i],
            price = price[i],
            payCodeId = payCodeId[i],
            flag = flag[i],
            name = name[i],
            remark = remark[i],
            showPrice = showPrice[i],
            itemId = itemId[i],
            sortId = sortId[i],
            leftTimes = leftTimes[i],
            limitType = limitType[i],
            needVipLv = needVipLv[i],
        }
        table.insert(self.m_tGiftList,info)
    end
    local function sort(v1,v2)
        return v1.sortId < v2.sortId
    end
    table.sort(self.m_tGiftList, sort)
    WZLog("WndVip:setGiftList", Serialize(self.m_tGiftList))
	
	if self.TabState == 2 then
		WndVip:_createGiftList()
	end

    --WndVip:setRebateList()
end

function WndVip:setRebateList(id, name, reward, state, complete, total)
    -- id = {1,2,3}
    -- name = {"累计充值200钻石", "累计充值320钻石", "累计充值640钻石"}
    -- reward = {"[165,10]&[110,5]&[165,10]", "[102,1]&[108,20]&[2,200000]&[23,50]", "[102,10]&[108,200]&[2,200000]&[23,50]"}
    -- state = {3,2,1}
    -- complete = {100,100,250}
    -- total = {100,100,300}

    self.m_tRebateList0 = {}
    self.m_tRebateList1 = {}
    self.m_tRebateList2 = {}
    for i = 1, #name do
        local info = {
            id = id[i],
            name = name[i],
            reward = reward[i],
            state = state[i], -- 未完成,可领取,已领取
            complete = complete,
            total = total[i],
        }
        if state[i] == 1 then
            table.insert(self.m_tRebateList0,info)
        elseif state[i] == 0 then
            table.insert(self.m_tRebateList1,info)
        elseif state[i] == 2 then
            table.insert(self.m_tRebateList2,info)
        end
    end
    local function sort(v1,v2)
        return v1.id < v2.id
    end
    table.sort(self.m_tRebateList0, sort)
    table.sort(self.m_tRebateList1, sort)
    table.sort(self.m_tRebateList2, sort)
    --WZLog("WndVip:setRebateList", Serialize(self.m_tRebateList0), Serialize(self.m_tRebateList1), Serialize(self.m_tRebateList2))
end

--@brief    设置周礼包数据
function WndVip:setWeekPackageList(id, reward, state, needVip, originPrice, curPrice, buytype, num)
    -- id = {1,2,3}
    -- reward = {"[165,10]&[110,5]&[165,10]", "[102,1]&[108,20]&[2,200000]", "[102,10]&[108,200]&[2,200000]"}
    -- state = {0,1,0}
    -- needVip = {0,1,4}
    -- originPrice = {"[70,100]", "[70,50]", "[1,100]"}
    -- curPrice = {"[70,90]", "[70,40]", "[1,90]"}
    -- buytype = {1,1,1}
    -- num = {1,1,1}
    self:closeLoadingUI()
    self.m_tWeekPackageList = {}
    for i = 1, #id do
        local info = {
            id = id[i],
            reward = reward[i],
            state = state[i], -- 购买,已购买(0:购买；1：已购买)
            needVip = needVip[i],
            originPrice = originPrice[i],
            curPrice = curPrice[i],
            buytype = buytype[i],
            totalNum = num[i],
        }
        table.insert(self.m_tWeekPackageList, info)
    end
    local function sort(v1, v2)
        if v1.state ~= v2.state then 
            return v1.state < v2.state 
        else
            return v1.id < v2.id
        end
    end
    table.sort(self.m_tWeekPackageList, sort)
    WZLog("WndVip:setWeekPackageList", Serialize(self.m_tWeekPackageList))

    self:_createWeekPackageList()
end

function WndVip:setWebState(open, count)
    self.m_bIsOpenWeb = open
    self.m_nWebCount = count
    if self.m_root then
        GetElement(self.m_root, "btnWeb2_WndVip", WZUIButton):setVisible(open)
    end
end

--@brief    获取月卡折扣活动信息成功
function WndVip:GetCardActivityInfoOK(progress, num, endTime)
    --body
    WZLog("WndVip:GetCardActivityInfoOK", progress, num, endTime)
    self.m_nCardActivityState = progress 
    self.m_nBuyCardTimes = num 
    self.m_nCardActivityEndTime = endTime 

    self:_createRechargeList()

    if self.m_conMid == nil then 
        self.m_conMid = GetElement(self.m_root, "conMid_WndVip", WZUIContainer)
        if self.m_nCardActivityState == 0 and self.m_nBuyCardTimes <= 0 then 
            self.m_conMid:enableSchedule("_caculateTime", 1)
        end
    else
        if self.m_nCardActivityState == 1 or self.m_nBuyCardTimes > 0 then 
            self.m_conMid:disableSchedule()
        end
    end
end

--计算时间
function WndVip:_caculateTime()
    -- body
    local nCurTime = SystemTime:getServerTime()

    if self.m_nCardActivityState == 0 and self.m_nCardActivityEndTime and nCurTime >= self.m_nCardActivityEndTime then 
        self.m_conMid:disableSchedule()
        ProtocolProcessorWndVip:send_ACTIVITY_GetWelfareCardActivityInfo(g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT)
    end
end

--@brief    在充值界面购买成功后，刷新月卡的价格，恢复原价
function WndVip:resetMonthCardPrice()
    -- body
    WZLog("WndVip:resetMonthCardPrice", self.m_nCardActivityState, self.m_nBuyCardTimes)
    if self.m_root == nil then return end 
    if self.m_nCardActivityState == 0 and self.m_nBuyCardTimes <= 0 then
        self.m_nBuyCardTimes = self.m_nBuyCardTimes + 1
        if self.m_conMid then 
            self.m_conMid:disableSchedule()
        end
        self:_createRechargeList()
    end
end

--@brief    购买周礼包成功
function WndVip:buyWeekPackageOK(giftId)
    -- body
    self:closeLoadingUI()
    
    for i = 1, #self.m_tWeekPackageList do
        if self.m_tWeekPackageList[i].id == giftId then 
            self.m_tWeekPackageList[i].state = self.m_tWeekPackageList[i].state + 1
            local id, num = SplitItemString(self.m_tWeekPackageList[i].reward)
            WndRewardShow:showById(id, num)
            break 
        end
    end

    local function sort(v1, v2)
        if v1.state ~= v2.state then 
            return v1.state < v2.state 
        else
            return v1.id < v2.id
        end
    end
    table.sort(self.m_tWeekPackageList, sort)

    self:_createWeekPackageList()
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndVip:createElement()
	local element = WZUISystem:getInstance():createElement("WndVip")
	assert(element, "WndVip create element failed!")
    Teach.PreUIChannelId = GlobalGame.g_nCurrentUIChannelId
	self:_init()
	return element
end

--@brief    显示VIP礼包窗口
--@param    nTag:右侧标签tag
function WndVip:showInterface(nTag)
    if not CheckButtonOpen(ISLAND_UP_RECHARGE) then
        return
    end

    self.m_TempRoot = WndVip.m_root
    self.m_isNoWnd = false  
    self.m_needUpdate = needUpdate 
    if not WndVip.m_root then
        self.m_isNoWnd = true
        local wndVip = WndVip:createElement()
        WindowManager:addWindow( wndVip , WndVip)
    end
    self.btnState = 0
    local vipLevel = CacheCenter:getPlayerInfo().vipLevel
    self.powerDescIndex = vipLevel >= 1 and vipLevel or 1
    WZLog("--------------self.powerDescIndex-------------",self.powerDescIndex, tostring(CacheCenter:getVipList()))
    self.rechargeData = CacheCenter:getVipList()

    GetElement(self.m_root, "checkGroup_TempLeftTab", WZUICheckBoxGroup):setCheckIndex(nTag - 1)
    self:setConVisible(nTag)
end
---------------------------------------------------------------------------------------------------------------------------
-- 获取最大的VIP等级表
function WndVip:_getMaxLevel()
    local maxLv = 0
    for k,v in pairs(GDatatab_vip) do
        maxLv = maxLv + 1
    end
    return maxLv
end

-- 判断永久福利卡状态
function WndVip:judgeJYFLK()
    local buyFlag = false
    local taskSub = PrefetchCache:getTaskList().tDailyTask.tToSubmit
    if #taskSub > 0 then
        for i = 1, #taskSub do
            local nTask_sub_type = GDatatab_task["id_"..taskSub[i].nId].sub_type
            if nTask_sub_type == 30018 and taskSub[i].nTaskStatus >= TASKSTATUS_TOSUBMIT then
                buyFlag = true
            end
        end
    end
    return buyFlag
end

-- 判断永久至尊卡状态
function WndVip:judgeYJZZ()
    local buyFlag = false
	local tData = CacheCenter:getPlayerItemById(56)
	if tData ~= nil and tData.lastTime == -1 then
        buyFlag = true
	end
    return buyFlag
end

function WndVip:setData(vipLevel, gift, limitGood, currentVipLevel)
	WZLog("WndVip:setData", Serialize(VectorToTable(vipLevel)), Serialize(VectorToTable(gift)), Serialize(VectorToTable(limitGood)), currentVipLevel)
	vipLevel = VectorToTable(vipLevel)
	gift = VectorToTable(gift)
	limitGood = VectorToTable(limitGood)

	self.m_tDataList = {}
	for i=1,#vipLevel do
		local tempTable = {}
		tempTable.vipLevel = vipLevel[i]
		tempTable.gift = gift[i]
		tempTable.limitGood = limitGood[i]
		table.insert(self.m_tDataList,tempTable)
	end

    self:_update()
end
