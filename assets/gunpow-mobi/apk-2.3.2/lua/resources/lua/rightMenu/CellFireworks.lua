--CellFireworks.lua
--@brief	CellFireworks的UI模块
--@date		2016/08/11
--@author	Tianxiang_Xu
--@note		限时折扣活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFireworks:onEnter(element)
	WZLog("CellFireworks:onEnter")
	self.m_root = element
	AdaptLanguage(self)
end

function CellFireworks:onEnterTransitionDidFinish(element)
	self.cost1 = 100
	self.cost2 = 200
	self.cost3 = 300
	--self.m_root:enableSchedule("countTime",1)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFireworks:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellFireworks:showWindow()

end

function CellFireworks:setMessage(activityId,startTime,endTime, rewardCounts, rewardId, count)
	WZLog("CellFireworks:setMessage",count,startTime,endTime)
	self.m_nStartTime = startTime
	self.m_nEndTime = endTime
	self.cost = rewardCounts
	self.count = count
	self:_showTime()
	local GetElement = GetElement
	GetElement(self.m_root,"cost1",WZUILabelTTF):setText(rewardCounts[1])
	GetElement(self.m_root,"cost2",WZUILabelTTF):setText(rewardCounts[2])
	GetElement(self.m_root,"cost3",WZUILabelTTF):setText(rewardCounts[3])

	--GetElement(self.m_root,"countDown",WZUILabelTTF):setText("00:00")

	local gameParam = CacheCenter:getGameParam()
	local score = gameParam.yanHuaNum
	local tempT = SplitStringWithSeparator(score,",")
	local tempStr = LocalStrings.INTEGRATION
	for i=1,3 do
		local txtScore = GetElement(self.m_root,"txtScore" .. i .. "_CellFireworks",WZUILabelTTF)

		txtScore:setText(tempStr .. "" .. tempT[i])
	end
	self.countDown = count

	--设置是否勾选
	local selCheckBox = GetElement(self.m_root,"checkBox",WZUICheckBox)
    if SETSHOWFIREWORK == 1 then
		selCheckBox:setCheckIndex(0)
	else
		selCheckBox:setCheckIndex(1)
	end
end

--@brief    设置活动时间
function CellFireworks:_showTime()
    -- body
    --消耗货币图标
    local sCostIcon 
    if CacheCenter:getGameParam().isUseTicket == "0" then
    	sCostIcon= GDatatab_item["id_70"].icon
    else
    	sCostIcon= GDatatab_item["id_1"].icon
    end
    for i = 1, 3 do
        local imgCostIcon = GetElement(self.m_root, "imgCostIcon" .. i .. "_CellFireworks", WZUIImage)
        if imgCostIcon then
            imgCostIcon:setFile(sCostIcon)
            imgCostIcon:setScale(0.4)
        end
    end
    --字“活动时间”
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellFireworks", WZUILabelTTF)
    if txtTimeWord then
        txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    --活动时间
    local txtTime = GetElement(self.m_root, "txtTime_CellFireworks", WZUILabelTTF)
    if txtTime then
    	local sStartDate = SystemTime:getTimeConverLocal1(self.m_nStartTime)
        local sEndDate = SystemTime:getTimeConverLocal1(self.m_nEndTime)
        txtTime:setText(sStartDate.."-"..sEndDate)--string.format(LocalStrings.ACTIVITYTIME_FORMAT, sStartDate.month, sStartDate.day, sStartDate.hour, sStartDate.min, sEndDate.month, sEndDate.day, sEndDate.hour, sEndDate.min))
    end
end

--查看排行榜
function CellFireworks:onClickRank(element)
	WZLog("CellFireworks:onClickRank")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not ISFIREWORKRANK then
		ISFIREWORKRANK = true
		ProtocolProcessorWndRankList:send_RANK_GetFireworkRank()
	end
end



function CellFireworks:onFire(element)
	WZLog("CellFireworks:onFire",self.m_nEndTime)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local gameParam = CacheCenter:getGameParam()
	local fireLimitTime = tonumber(gameParam.fireworkLimitTime)
	
    local tempppppEndTime = self.m_nEndTime - 3600 * fireLimitTime

    local serverTime = SystemTime:getServerTime()
    serverTime = SystemTime:convertToLocalTimestamp(serverTime)

    local timeTemp = os.date("*t",serverTime)
    local timeT2 = {}
    timeT2.year = timeTemp.year 
    timeT2.month = timeTemp.month
    timeT2.day = timeTemp.day
    timeT2.hour = timeTemp.hour
    timeT2.min = timeTemp.min
    timeT2.sec = timeTemp.sec
    local temppppp = os.time(timeT2)
    if temppppp > tempppppEndTime then
    	MsgBoxManager:showTipBox(LocalStrings.PLAY_FIREWORKS_CLOSE)
    	return
    end

    if FIREWORKTIME > 0 then
    	MsgBoxManager:showTipBox(LocalStrings.SEND_FIREWORK_TIP)
    	return
    end

    --判断钻石是否足够
	self.m_nTag = tonumber(element:getTag())
    local costZuan = self.cost[tonumber(self.m_nTag)]
    if CacheCenter:getGameParam().isUseTicket == "0" then
    	if not JudgeMoneyIsEnough(70,costZuan,nil,nil,43, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then return end
    else
    	if not JudgeMoneyIsEnough(1,costZuan,nil,nil,43, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then return end
    end
    self:sureUseDiamondInstead()
end

--@brief    确认用钻石代替礼券购买烟花
function CellFireworks:sureUseDiamondInstead()
    -- body
    --self.m_nEndTime
    local costZuan = self.cost[tonumber(self.m_nTag)]
    --判断vip等级
    local needVip = nil
    if CacheCenter:getGameParam().activityFireworkNeedVipLevel then
        needVip = tonumber(CacheCenter:getGameParam().activityFireworkNeedVipLevel) 
    end
    WZLog("VIP等级限制", needVip)
    if needVip ~= nil and  CacheCenter:getPlayerInfo().vipLevel < needVip then
        local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, needVip)
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
        return
    end
    
    --if self.countDown == nil or self.countDown > 0 then return end
    MsgBoxManager:showConfirmBox(LocalStrings.YES_OR_NO_SPEND..costZuan..LocalStrings.NEWYEARTIP10.."?", self, self.onFireCall, MSGBOXLEVEL_HIGH,nil)
end

function CellFireworks:onFireCall(nId, nResType)
	--self.countDown = self.count or 5
	--GetElement(self.m_root,"countDown",WZUILabelTTF):setText("00:0"..self.count)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		ProtocolProcessorRedPack:send_ACTIVITY_UseFirework(self.m_nTag)
	end
end

--@brief	提示框的回调
function CellFireworks:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

function CellFireworks:countTime()
	if self.countDown == nil or self.countDown <= 0 then return end
	self.countDown = self.countDown - 1
	local time = GetElement(self.m_root,"countDown",WZUILabelTTF)
	local min = math.floor(self.countDown / 60)
	local sec = self.countDown % 60
	if min < 10 then min = "0"..min end
	if sec < 10 then sec = "0"..sec end

	local text = min..":"..sec
	time:setText(text)
end

--@brief	设置是否显示烟花
function CellFireworks:onCheck()
	WZLog("CellFireworks:onCheck")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local selCheckBox = GetElement(self.m_root,"checkBox",WZUICheckBox)
    if selCheckBox:getCheckIndex() == 1 then
		SETSHOWFIREWORK = 1
		--MsgBoxManager:showTipBox("显示烟花")
	elseif selCheckBox:getCheckIndex() == 0 then
		SETSHOWFIREWORK = 0
		--MsgBoxManager:showTipBox("不显示烟花")
    end
	WZLog("设置是否显示烟花",SETSHOWFIREWORK)
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellFireworks:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtItem1_CellFireworks",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtItem2_CellFireworks",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtItem3_CellFireworks",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"imgFireworks_CellFireworks",WZUIImage):setScale(0.5)

	local txtTip1 = GetElement(self.m_root,"txtTip1_CellFireworks",WZUILabelTTF)
	txtTip1:setLabelStyleKey("C18_F18")
	txtTip1:setScale(0.65)
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.36,-0.165))
	local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellFireworks", WZUILabelTTF)
	txtTimeWord:setLabelStyleKey("C18_F18")
	txtTimeWord:setScale(0.65)
	txtTimeWord:setRelativePosition(GlobalMethod:ccp(0.0821917,-0.09))
	local txtTime = GetElement(self.m_root, "txtTime_CellFireworks", WZUILabelTTF)
	txtTime:setLabelStyleKey("C18_F18")
	txtTime:setScale(0.65)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.14019,-0.09))
	local txtTip2 = GetElement(self.m_root,"txtTip2_CellFireworks",WZUILabelTTF)
	txtTip2:setScale(0.9)
	txtTip2:setDimensions(GlobalMethod:CCSize(170))

	local txtName1 = GetElement(self.m_root, "txtName1_CellFireworks", WZUILabelTTF)
	txtName1:setScale(0.6)
	txtName1:setDimensions(GlobalMethod:CCSize(200))
	local txtName2 = GetElement(self.m_root, "txtName2_CellFireworks", WZUILabelTTF)
	txtName2:setScale(0.6)
	txtName2:setDimensions(GlobalMethod:CCSize(200))
	local txtName3 = GetElement(self.m_root, "txtName3_CellFireworks", WZUILabelTTF)
	txtName3:setScale(0.6)
	txtName3:setDimensions(GlobalMethod:CCSize(200))

	local imgTitle = GetElement(self.m_root,"imgTitle_CellFireworks",WZUIImage)
	imgTitle:setRelativePosition(GlobalMethod:ccp(0.4,0.87))
	imgTitle:setScale(0.6)
end

function CellFireworks:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtItem1_CellFireworks",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtItem2_CellFireworks",WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root,"txtItem3_CellFireworks",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"imgFireworks_CellFireworks",WZUIImage):setScale(0.55)

	local txtTip1 = GetElement(self.m_root,"txtTip1_CellFireworks",WZUILabelTTF)
	txtTip1:setLabelStyleKey("C18_F18")
	txtTip1:setScale(0.7)
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.37,-0.165))
	local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellFireworks", WZUILabelTTF)
	txtTimeWord:setLabelStyleKey("C18_F18")
	txtTimeWord:setScale(0.7)
	txtTimeWord:setRelativePosition(GlobalMethod:ccp(0.0821917,-0.09))
	local txtTime = GetElement(self.m_root, "txtTime_CellFireworks", WZUILabelTTF)
	txtTime:setLabelStyleKey("C18_F18")
	txtTime:setScale(0.7)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.14019,-0.09))
	local txtTip2 = GetElement(self.m_root,"txtTip2_CellFireworks",WZUILabelTTF)
	txtTip2:setScale(0.7)
	txtTip2:setRelativePosition(GlobalMethod:ccp(0.82,-0.13))

	local txtName1 = GetElement(self.m_root, "txtName1_CellFireworks", WZUILabelTTF)
	txtName1:setScale(0.6)
	txtName1:setDimensions(GlobalMethod:CCSize(200))
	local txtName2 = GetElement(self.m_root, "txtName2_CellFireworks", WZUILabelTTF)
	txtName2:setScale(0.6)
	txtName2:setDimensions(GlobalMethod:CCSize(200))
	local txtName3 = GetElement(self.m_root, "txtName3_CellFireworks", WZUILabelTTF)
	txtName3:setScale(0.6)
	txtName3:setDimensions(GlobalMethod:CCSize(200))

	local imgTitle = GetElement(self.m_root,"imgTitle_CellFireworks",WZUIImage)
	imgTitle:setRelativePosition(GlobalMethod:ccp(0.4,0.87))
end

function CellFireworks:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtItem1_CellFireworks",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtItem2_CellFireworks",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtItem3_CellFireworks",WZUILabelTTF):setScale(0.8)

	GetElement(self.m_root,"imgFireworks_CellFireworks",WZUIImage):setScale(0.8)

	local txtTip1 = GetElement(self.m_root,"txtTip1_CellFireworks",WZUILabelTTF)
	txtTip1:setLabelStyleKey("C18_F18")
	txtTip1:setScale(0.65)
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.38,-0.165))
	txtTip1:setDimensions(GlobalMethod:CCSize(500))
	local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellFireworks", WZUILabelTTF)
	txtTimeWord:setLabelStyleKey("C18_F18")
	txtTimeWord:setScale(0.65)
	txtTimeWord:setRelativePosition(GlobalMethod:ccp(0.1,-0.085))
	local txtTime = GetElement(self.m_root, "txtTime_CellFireworks", WZUILabelTTF)
	txtTime:setLabelStyleKey("C18_F18")
	txtTime:setScale(0.65)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.175,-0.085))
	local txtTip2 = GetElement(self.m_root,"txtTip2_CellFireworks",WZUILabelTTF)
	txtTip2:setDimensions(GlobalMethod:CCSize(160))
	txtTip2:setRelativePosition(GlobalMethod:ccp(0.853547,-0.109653))
end

	
function CellFireworks:_adaptLanguage_vn( )
	local txtName1 = GetElement(self.m_root, "txtName1_CellFireworks", WZUILabelTTF)
	txtName1:setScale(0.6)
	txtName1:setDimensions(GlobalMethod:CCSize(200))
	local txtName2 = GetElement(self.m_root, "txtName2_CellFireworks", WZUILabelTTF)
	txtName2:setScale(0.6)
	txtName2:setDimensions(GlobalMethod:CCSize(200))
	local txtName3 = GetElement(self.m_root, "txtName3_CellFireworks", WZUILabelTTF)
	txtName3:setScale(0.6)
	txtName3:setDimensions(GlobalMethod:CCSize(200))

	local txtTime = GetElement(self.m_root, "txtTime_CellFireworks", WZUILabelTTF)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.2,1.52))
end

function CellFireworks:_adaptLanguage_tr(  )
	local txtTip1 = GetElement(self.m_root,"txtTip1_CellFireworks",WZUILabelTTF)
	txtTip1:setRelativePosition(GlobalMethod:ccp(0.5,0.22))
	local txtTip2 = GetElement(self.m_root,"txtTip2_CellFireworks",WZUILabelTTF)
	txtTip2:setRelativePosition(GlobalMethod:ccp(0.4,0.106))
	
	GetElement(self.m_root,"countDown",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.627809,0.345))
end
---------------------------------------语言适配End------------------------------------------