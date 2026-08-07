--CellNewVipBuy.lua
--@brief	CellNewVipBuy的UI模块
--@date		2021/03/22
--@author	hyx
--@note		钻石购买


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewVipBuy:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewVipBuy:onExit(element)
	if self.m_root then 
        self.m_root:disableSchedule()
    end
	self:_unInit()
	self:unregister()
end

function CellNewVipBuy:register()
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_ChargeListData,self._onGetRechargeInfo,self)
	GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_WelfareCardResult,self._onWelfareResult,self)
    GlobalGame:getGameEventDispathcer():Add(NewVipEvent.NewVipEvent_ChargeSuccessResult,self._onRechargeSuccessResult,self)
end
function CellNewVipBuy:unregister()
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_ChargeListData,self._onGetRechargeInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_WelfareCardResult,self._onWelfareResult,self)
    GlobalGame:getGameEventDispathcer():Remove(NewVipEvent.NewVipEvent_ChargeSuccessResult,self._onRechargeSuccessResult,self)
end
function CellNewVipBuy:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndVip:send_ACTIVITY_GetWelfareCardActivityInfo(g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT)
	self.rechargeTableContainer = GetElement(self.m_root,"rechargeTableContainer",WZUITableContainer)
	self.rechargeTableContainer:cleanTable()

    self:setNextVipMsg()
    
	self.m_tRechargeData = CacheCenter:getVipList()
	if not self.m_tRechargeData then
		self:createLoadingUI()
		return
	end
end

function CellNewVipBuy:setNextVipMsg()
    if not self.m_root then return end

    local medalContainer = GetElement(self.m_root,"medalContainer",WZUIContainer)
    local chargeProgress = GetElement(medalContainer,"chargeProgress",WZUIProgress)
    local txtNextCharge = GetElement(medalContainer,"txtNextCharge",WZUIFreeTextBox)
    local txtNextTitle = GetElement(medalContainer,"txtNextTitle",WZUILabelTTF)
    local imgVipLevel = GetElement(self.m_root,"imgVipLevel",WZUIImage)
    local pInfo = CacheCenter:getPlayerInfo()
    if pInfo then
        if pInfo.vipLevel <= 15 then
            imgVipLevel:setFile("ui/newvip/icon_vip_hgg.png")
        elseif pInfo.vipLevel >= 16 and pInfo.vipLevel <= 19 then
            imgVipLevel:setFile("ui/newvip/icon_vip_hgg_1.png")
        elseif pInfo.vipLevel > 19 and pInfo.vipLevel <= 22 then 
            imgVipLevel:setFile("ui/newvip/icon_vip_hgg_2.png")
        elseif pInfo.vipLevel > 22 then 
            imgVipLevel:setFile("ui/newvip/icon_vip_hgg_3.png")
        end
        if pInfo.vipLevel == WndVip:_getMaxLevel() then
            chargeProgress:setPercentage(100)
            txtNextCharge:setShowText(LocalStrings.NEWVIP_TEXT8)
        else
            --说明
            local nextVipLv = pInfo.vipLevel+1
            if GDatatab_vip then
                local vipData = GDatatab_vip["id_"..nextVipLv]
                txtNextCharge:setShowText(string.format(LocalStrings.NEWVIP_TEXT19,tonumber(vipData.exp-pInfo.vipExp)))
                -- 进度条
                chargeProgress:setPercentage(math.floor(pInfo.vipExp/vipData.exp*100))
                txtNextTitle:setText(LocalStrings.NEWVIP_TEXT6..nextVipLv)
            end
        end
    end
    --qq大厅提示语
    local txtQQHallAtt = GetElement(self.m_root, "txtQQHallAtt_CellNewVipBuy", WZUILabelTTF)
    if isChannelPC() then 
        txtQQHallAtt:setText(LocalStrings.QQHALL_TEXT1[10])
    end
end

function CellNewVipBuy:createLoadingUI()
    if not self.loadingId_CellBuy then
    	self.loadingId_CellBuy = MsgBoxManager:showLoadingBox(5,self,self.closeLoadingUI)
    end
end
function CellNewVipBuy:closeLoadingUI()
    if self.loadingId_CellBuy then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId_CellBuy)
        self.loadingId_CellBuy = nil
    end
end

function CellNewVipBuy:_onWelfareResult(progress, num, endTime)
	self.m_nCardActivityState = progress 
    self.m_nBuyCardTimes = num 
    self.m_nCardActivityEndTime = endTime 

    if self.m_sCountDownTime == nil then
    	self.m_sCountDownTime = true
        if self.m_nCardActivityState == 0 and self.m_nBuyCardTimes <= 0 then 
            self.m_root:enableSchedule("_caculateTime", 1)
        end
    else
        if self.m_nCardActivityState == 1 or self.m_nBuyCardTimes > 0 then 
            self.m_root:disableSchedule()
        end
    end
    --显示充值的item
    self:setShowRecharge(self.m_tRechargeData)
end
--计算时间
function CellNewVipBuy:_caculateTime()
    -- body
    local nCurTime = SystemTime:getServerTime()
    if self.m_nCardActivityState == 0 and self.m_nCardActivityEndTime and nCurTime >= self.m_nCardActivityEndTime then 
        self.m_root:disableSchedule()
        ProtocolProcessorWndVip:send_ACTIVITY_GetWelfareCardActivityInfo(g_tGameActivityTypes.ACIVIITY_MONTHCARD_DISCOUNT)
    end
end

function CellNewVipBuy:_onGetRechargeInfo()
	self:closeLoadingUI()
	self.m_tRechargeData = CacheCenter:getVipList()
	self:setShowRecharge(self.m_tRechargeData)
end

function CellNewVipBuy:setShowRecharge(data)
	if not data then return end
	if not self.rechargeTableContainer then return end
	
    -- 永久福利卡买过不显示
    local tTempData = CopyTable(data)
    local table_insert = table.insert
    local temp_data = {}

    --幻石进阶购买点不显示
    local sConfig = CacheCenter:getGameParam().stonemoney
    local string = string.sub(sConfig, 2, -2) 
    local nType = SplitStringWithSeparator(string, ",")[1]
    local nSort = SplitStringWithSeparator(string, ",")[2]
    --国庆签到去除
    local rechargeSignIn = CacheCenter:getGameParam().rechargeSignIn
    local rechargeType = -1
    local rechargeSort = -1
    if rechargeSignIn then
        --获取充值类型和商品排序
        rechargeSignIn = json.decode(rechargeSignIn)
        rechargeType = rechargeSignIn.rechargeType
        rechargeSort = rechargeSignIn.rechargeSort
    end
    for i = 1, #tTempData do
        local rData = tTempData[i]
        local tRechargeData = GDatatab_recharge["id_" .. rData.ids]
        -- 一次or的表示   永久福利卡状态   永久至尊卡买过不显示  娄艺潇礼包买过不显示  未知  幻石进阶购买点不显示  周一计划卡不显示  国庆签到去除
        if (rData.itemId == 52 and WndVip:judgeJYFLK()) or (rData.itemId == 56 and WndVip:judgeYJZZ()) or (rData.itemId == 1283 or rData.itemId == 1257)
        	or (tRechargeData and rData.itemId == 50 and tRechargeData.type == 105) or (tRechargeData and tRechargeData.type == tonumber(nType) and tonumber(tRechargeData.sort) == tonumber(nSort)) 
        	or (tRechargeData and tRechargeData.item_id == 259) or (tRechargeData and tonumber(tRechargeData.sort) == tonumber(rechargeSort) and tonumber(tRechargeData.type) == tonumber(rechargeType)) then
        
        else
            if self.m_nType == 1 and rData.itemId ~= 177 then
            	table_insert(temp_data, rData)
            elseif self.m_nType == 2 and rData.itemId == 177 then
                table_insert(temp_data, rData)
            end
        end
       	--是否显示折扣的月卡
	    local bDiscountMonthCard = false  
	    local nCurTime = SystemTime:getServerTime()
	    if self.m_nCardActivityState and self.m_nCardActivityState == 0 and self.m_nBuyCardTimes <= 0 and nCurTime < self.m_nCardActivityEndTime then
	        bDiscountMonthCard = true
	    end
        --如果月卡打折活动存在，移除掉没打折的月卡
    	local nTempDiscountType = tonumber(CacheCenter:getGameParam().monthCardDiscountRechargeType)
        for j = 1, #temp_data do
            if temp_data[j].itemId == 50 then 
                local tRechargeData = GDatatab_recharge["id_" .. temp_data[j].ids]
                if bDiscountMonthCard then
                	if tRechargeData and tRechargeData.type ~= nTempDiscountType then  
	                    table.remove(temp_data, j)
	                    break 
	                end
                else
	                if tRechargeData and tRechargeData.type == nTempDiscountType then  
	                    table.remove(temp_data, j)
	                    break 
	                end
	            end
            end
        end
    	
	    table.sort(temp_data, function(a,b)
	    	return a.sortId < b.sortId
		end)

        self.rechargeTableContainer:cleanTable()
        for i = 1, #temp_data do
	        temp_data[i].showType = 0
	        local cell,tcell = CellVipPowerList:createElement()
	        cell:setTag(i-1)
	        self.rechargeTableContainer:setCellElement(cell)
	        tcell:setData(temp_data[i])
	    end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellNewVipBuy:_onRechargeSuccessResult(isUp, vipLevel)
    WndNewVip:setShowDiamondNum()
    self:setNextVipMsg()
    CellNewVipPrivilege:initShow()
    CellNewVipPrivilege:setChangeAdvancedVipReward(index)
end




-------------------------------------私有方法模块End----------------------------------------
