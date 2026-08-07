--WndInvestRebate.lua
--@brief	WndInvestRebate的UI模块
--@date		2020/05/15
--@author	XTX
--@note		投资返利活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndInvestRebate:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndInvestRebate:onExit(element)
    if self.m_root then 
        self.m_root:disableSchedule()
    end
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndInvestRebate:onEnterTransitionDidFinish(element)
	-- body
    self.m_root:enableSchedule("_caculateLeftTime", 1)
end

--@brief 	显示
function WndInvestRebate:showWindow()
	-- body
	self:_initUIText()
	self:_updateCountAndProgress()
	self:showReward()
	WZLog("WndInvestRebate:showWindow33")
end

--@brief 	点击宝箱回调
function WndInvestRebate:onClickBox(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()
	local tData = self.m_tBoxData[nTag]

	if tData.status == 0 then 
		--领取宝箱奖励
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(g_cityExtenInfo.IRStatus, tData.rewardId)
	else
		--弹宝箱tips
		local rewardData = {}
        rewardData.coinId = tData.coinId
        rewardData.nType = 6
        rewardData.strartNum = self.m_nCount
        rewardData.endNum = tData.target
        rewardData.icon = {}
        rewardData.id = {}
        rewardData.num = {}
        for i = 1, #tData.reward do
            local icon = GDatatab_item["id_" .. tData.reward[i][1]].icon
            table.insert(rewardData.icon, icon)
            table.insert(rewardData.id, tData.reward[i][1])
            table.insert(rewardData.num, tData.reward[i][2])
        end
        WndTips:show(element, self.m_root, 3, rewardData, GlobalMethod:ccp(160,130))
        WndTips.m_root:setShowAll(true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化UI文本
function WndInvestRebate:_initUIText()
	-- body
	local txtTimeWords = GetElement(self.m_root, "txtTimeWords_WndInvestRebate", WZUILabelTTF)
	if txtTimeWords then 
		txtTimeWords:setText(LocalStrings.ACTIVITY_TIME_KEY .. ":")
	end
	--活动时间
	local DayStartTab = os.date("*t", self.m_nStartTime)
    local DayEndTab = os.date("*t", self.m_nEndTime)
    
    local needDay_str = string.format(LocalStrings.ACTIVITYTIME_FORMAT, DayStartTab.month, DayStartTab.day, DayStartTab.hour, DayStartTab.min, DayEndTab.month, DayEndTab.day, DayEndTab.hour, DayEndTab.min)
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_WndInvestRebate", WZUILabelTTF)
    if txtTimeValue then 
    	txtTimeValue:setText(needDay_str)
    end
end

--@brief 	更新累计购买次数和进度
function WndInvestRebate:_updateCountAndProgress()
	-- body
	local txtBuyTimes = GetElement(self.m_root, "txtBuyTimes_WndInvestRebate", WZUILabelTTF)
	if txtBuyTimes then 
		txtBuyTimes:setText(self.m_nCount .. LocalStrings.SHOP_CISHU)
	end

	local nCurNum = self.m_nCount
	local prgTotalReward = GetElement(self.m_root, "prgTotalReward_WndInvestRebate", WZUIProgress)
	if prgTotalReward then 
		if nCurNum <= self.m_tBoxData[1].target then 
            prgTotalReward:setPercentage(math.floor(nCurNum * 20/self.m_tBoxData[1].target))
        elseif nCurNum <= self.m_tBoxData[2].target then 
            local nTempNum = self.m_tBoxData[2].target - self.m_tBoxData[1].target
            prgTotalReward:setPercentage(20 + math.floor((nCurNum - self.m_tBoxData[1].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tBoxData[3].target then 
            local nTempNum = self.m_tBoxData[3].target - self.m_tBoxData[2].target
            prgTotalReward:setPercentage(40 + math.floor((nCurNum - self.m_tBoxData[2].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tBoxData[4].target then 
            local nTempNum = self.m_tBoxData[4].target - self.m_tBoxData[3].target
            prgTotalReward:setPercentage(60 + math.floor((nCurNum - self.m_tBoxData[3].target) * 20/nTempNum))
        elseif nCurNum <= self.m_tBoxData[5].target then 
            local nTempNum = self.m_tBoxData[5].target - self.m_tBoxData[4].target
            prgTotalReward:setPercentage(80 + math.floor((nCurNum - self.m_tBoxData[4].target) * 20/nTempNum))
        else
            prgTotalReward:setPercentage(100)
        end
	end

	self:setBoxState()
end

--@brief 	设置宝箱的状态
function WndInvestRebate:setBoxState()
	-- body
	--宝箱数据
    local closeBox = {"ui/common/common_icon_djbx1.png","ui/common/common_icon_lan1.png","ui/common/common_icon_zi1.png","ui/common/common_icon_huang1.png","ui/common/common_icon_zis1.png"}
    local openBox = {"ui/common/common_icon_djbx2.png","ui/common/common_icon_lan2.png","ui/common/common_icon_zi2.png","ui/common/common_icon_huang2.png","ui/common/common_icon_zis2.png"}
    local nullBox = {"ui/common/common_icon_djbx3.png","ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png","ui/common/common_icon_zis3.png"}

	for i = 1, 5 do
        local imgBox = GetElement(self.m_root, "imgBtn" .. i .. "_WndInvestRebate", WZUIImage)
        local txtTimes = GetElement(self.m_root, "txtTimes" .. i .. "_WndInvestRebate", WZUILabelTTF)
        local armBox = GetElement(self.m_root, "armBox" .. i .. "_WndInvestRebate", WZArmature)

        local tData = self.m_tBoxData[i]
        if tData.status == -1 and self.m_nCount >= tData.target then 
            tData.status = 0 
        end
        if tData.status == -1 then 
            imgBox:setFile(closeBox[i])
            armBox:setVisible(false)
        elseif tData.status == 0 then 
            imgBox:setFile(openBox[i])
            armBox:setVisible(true)
        elseif tData.status == 1 then 
            imgBox:setFile(nullBox[i])
            armBox:setVisible(false)
        end
        txtTimes:setText(tData.target .. LocalStrings.SHOP_CISHU)
    end
end

--@brief 	展示奖励
function WndInvestRebate:showReward()
	-- body
	WZLog("WndInvestRebate:showReward", #self.m_tRewardData)
    self.m_tAllCell = {}

    local nServerTime = SystemTime:getServerTime()
    local nTimeLeft = self.m_nEndTime - nServerTime

	for i = 1, #self.m_tRewardData do
		local conSeat = GetElement(self.m_root, "conSeat" .. i .. "_WndInvestRebate", WZUIContainer)
		conSeat:removeAllChildrenWithCleanup(true)

		local element, tNewObj = CellInvestRebate:createElement()
		if element and tNewObj then 
			element:setVisible(true)
			tNewObj:setData(self.m_tRewardData[i])

            if self.m_tRewardData[i].status == -1 and nTimeLeft <= (self.m_tRewardData[i].tips - 1) * 24 * 3600 then 
                tNewObj:setBuyBtnEnable()
            end
            table.insert(self.m_tAllCell, tNewObj)
			conSeat:addChild(element)
		end
	end
end

--@brief    计算距离活动结束还剩下多久
--@note     活动结束时间必须是凌晨
function WndInvestRebate:_caculateLeftTime(element, delta)
    -- body
    local nServerTime = SystemTime:getServerTime()
    local nTimeLeft = self.m_nEndTime - nServerTime
    if self.m_tRewardData == nil then return end 

    for i = 1, #self.m_tRewardData do
        if self.m_tRewardData[i].status == -1 and nTimeLeft <= (self.m_tRewardData[i].tips - 1) * 24 * 3600 + 3 then 
            if self.m_tAllCell and self.m_tAllCell[i] then 
                self.m_tAllCell[i]:setBuyBtnEnable()

                table.remove(self.m_tAllCell, i)
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
