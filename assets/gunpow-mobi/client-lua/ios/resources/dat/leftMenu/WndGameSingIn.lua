--WndGameSingIn.lua
--@brief	WndGameSingIn的UI模块
--@date		2015/04/29
--@author	weidong_wu
--@note		签到


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameSingIn:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndGameSingIn:regAll()
	self:_initStaticTxt()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameSingIn:onExit(element)

	ProtocolProcessorWndGameSingIn:unregAll()

	self:_unInit()
end

--@brief    onenter函数已执行
function WndGameSingIn:onEnterTransitionDidFinish(element)
    WZLog("WndGameSingIn:onEnterTransitionDidFinish", WndGameSingIn.m_bNeedSendProtocol)
    --弹窗动画
--    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
    self:actionCallback(element)
end

--@brief    弹窗动画完成后的回调
function WndGameSingIn:actionCallback(element, data)
	if WndGameSingIn.m_bNeedSendProtocol then 
    	ProtocolProcessorWndGameSingIn:send_TASK_GetSignStatus( )
    	self:_startLoading()
	end 
end

--@brief    弹窗动画完成后的回调
function WndGameSingIn:actionCallback_close(element,data)
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief 	关闭窗口
function WndGameSingIn:onCloseClick(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end


--@brief 	查看规则
function WndGameSingIn:onEventExplain(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--[[local color = GlobalMethod:ccc3(36,0,0)
    WndExplain:showWndExplain(LocalStrings.VIP_NOTLEVEL)
    WndExplain:setColor(color)]]
    WndSingleMapDesc:showInterface(LocalStrings.SingInDesc)
end

--@brief    事件
function WndGameSingIn:onTouchBegan(element,pt)
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt,dir)
    WZLog("开始按下回调函数:",bPoint)
    if bPoint == true then
        WZLog("回调函数1:",type(bPoint),bPoint)
    else 
        WZLog("回调函数12:",type(bPoint),bPoint)
        WndItemInfo:onCloseClick()
    end
end

--@brief	补签
function WndGameSingIn:onReissue(element)
	WZLog("WndGameSingIn:onReissue")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--补签次数为0
	--local day = os.date("%d", SystemTime:getServerTime())
	local showNum = self.dayOfMonth - self.days - 1
	if self.b_sign then
		showNum = showNum + 1
	end
	if (showNum) <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.NEWSINGIN6)
		return
	end
	--判断vip等级
    if CacheCenter:getPlayerInfo().vipLevel < 3 then
    	local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, 3)
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
		return
	end

	local replenishSignCost = CacheCenter:getGameParam().replenishSignCost
	if replenishSignCost == nil or replenishSignCost == "" then
		replenishSignCost = "[70,10]&[70,20]&[70,30]&[70,40]&[70,50]"
	end
	local ids, nums = SplitItemString(replenishSignCost)
	if not JudgeMoneyIsEnough(tonumber(ids[self.reissueTimes+1]), tonumber(nums[self.reissueTimes+1]), nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.onReissueCall) then 
		return 
	end
	self:onReissueCall()
end

function WndGameSingIn:onReissueCall()
	self.m_nSignType = 2
	ProtocolProcessorWndGameSingIn:send_TASK_Sign(2)
end

--@brief	提示框的回调
function WndGameSingIn:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

--@brief	领取满签
function WndGameSingIn:onGet(element)
	WZLog("WndGameSingIn:onGet")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nSignType = 3
	ProtocolProcessorWndGameSingIn:send_TASK_Sign(3)
end

function WndGameSingIn:GameSignOk(days)
	if self.m_root == nil then return end
	local reward
	local needVip
	if self.m_nSignType == 3 then
		reward = self.tReward
	elseif self.m_nSignType == 2 then
		local m = os.date("%m", SystemTime:getServerTime())
		for k,v in pairs(GDatatab_sign_reward) do
			if v.totaled == days and v.month == tonumber(m) then
				reward = CopyTable(v.reward)
				needVip = v.vip_level
			end
		end
	end

	if reward == nil or #reward == 0 then return end

	--显示奖励
	WZLog("WndGameSingIn:GameSignOk", days, Serialize(reward))
	local showId = {}
	local showNum = {}
	for i=1,#reward do
		showId[i] = reward[i][1]
		showNum[i] = reward[i][2]
		if self.m_nSignType == 2 and CacheCenter:getPlayerInfo().vipLevel >= needVip then
			showNum[i] = reward[i][2] * 2
		end
	end
	WndRewardShow:showById(showId, showNum)
	self.m_nSignType = nil

	ProtocolProcessorWndGameSingIn:send_TASK_GetSignStatus( )
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	初始化静态数据
function WndGameSingIn:_initStaticTxt(  )
--	local txtWndTitleName_WndGameSingIn = GetElement(self.m_root,"txtWndTitleName_WndGameSingIn",WZUILabelTTF)
--	txtWndTitleName_WndGameSingIn:setText(LocalStrings.SingInTitle)
	--5月累计签到天数:3
	local txtSingInlable_WndGameSingIn = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable_WndGameSingIn:setShowText("")
end

function WndGameSingIn:_setSignDays( days )
	local month = GDatatab_sign_reward["id_"..self.m_currentDay].month
	--local daysStr = string.format("%d月累计签到天数:%d",month,days)

	local daysStr = string.format(LocalStrings.NEWSINGIN2, tostring(days))
	local txtSingInlable_WndGameSingIn = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable_WndGameSingIn:setShowText(daysStr)

	--可补签次数
	local day = os.date("%d", SystemTime:getServerTime())
	local showNum = day - days - 1
	if self.b_sign then
		showNum = showNum + 1
	end
	if showNum < 0 then showNum = 0 end
	GetElement(self.m_root,"text4_WndGameSingIn",WZUIFreeTextBox):setShowText(string.format(LocalStrings.NEWSINGIN4, tostring(showNum)))
end

function WndGameSingIn:_update()
	WZLog("WndGameSingIn:_update")
	local DayCount = 0
	local leapYear={31,29,31,30,31,30,31,31,30,31,30,31}
	local commonYear={31,28,31,30,31,30,31,31,30,31,30,31}
	local templateYear
	if (self.m_currentYear%4==0 and not (self.m_currentYear%100==0)) or (self.m_currentYear%400==0) then 
		templateYear=leapYear
	else 
		templateYear=commonYear
	end 
	local month = GDatatab_sign_reward["id_"..self.m_currentDay].month
	DayCount = templateYear[month]
	local CellCount = templateYear[month]/4
	local flCalendarSingIn_WndGameSingIn = GetElement(self.m_root,"flCalendarSingIn_WndGameSingIn",WZUIFreeListContainer)
	if flCalendarSingIn_WndGameSingIn == nil then 
		WZLog("flCalendarSingIn_WndGameSingIn is nil")
		return 
	end 
	if flCalendarSingIn_WndGameSingIn:size() > 0  then 
		flCalendarSingIn_WndGameSingIn:removeAll()
 	end
	CellCount = math.ceil(CellCount)
	local DayListStart = 0
	local NeedIndex = month-1
	for i=1,NeedIndex do
		DayListStart = DayListStart + templateYear[i]
	end
	for i=1,CellCount do
		local m_tDate = {}
		local AllMonthDays = DayListStart + templateYear[month]
		for j=1,4 do
			local idKey = j+(i-1)*4+DayListStart
			if idKey <= AllMonthDays then
				table.insert(m_tDate,GDatatab_sign_reward["id_"..idKey])
			end 
		end
		--WZLog("CellDayCount = "..#m_tDate)
		local cellElement,newLuaObj = CellGameSingInItem:createElement()
        cellElement = WZUIContainer:luaTo(cellElement)
        newLuaObj:setTabDate(i,m_tDate,self.b_sign,self.b_vipSign,self.days)
        cellElement:setTag(i-1)
        cellElement:setContentSize(GlobalMethod:CCSize(850,140))
        cellElement:setRelativeSize(GlobalMethod:CCSize(1,140/460))
        flCalendarSingIn_WndGameSingIn:pushBack(cellElement)
	end
	flCalendarSingIn_WndGameSingIn:update()
	local nCurPositionY = flCalendarSingIn_WndGameSingIn:getMinPosition().y
	local nRow = math.ceil(self.days/4)
	if nRow > 2 then 
		nCurPositionY = nCurPositionY + (nRow - 2) * 120
		if nCurPositionY > flCalendarSingIn_WndGameSingIn:getMaxPosition().y then 
			nCurPositionY = flCalendarSingIn_WndGameSingIn:getMaxPosition().y
		end
	end
	flCalendarSingIn_WndGameSingIn:getMoveElement():setPositionY(nCurPositionY)

	--满签到奖励
	local m = os.date("%m", SystemTime:getServerTime())
	local reward = {}
	local dayNum = 0
	for k,v in pairs(GDatatab_sign_reward) do
		if v.totaled == 0 and v.month == tonumber(m) then
			reward = CopyTable(v.reward)
		end
		if v.month == tonumber(m) then
			dayNum = dayNum + 1
		end
	end
	self.tReward = CopyTable(reward)
	for i=1,3 do
		local con = GetElement(self.m_root,"conTopCell"..i,WZUIContainer)
		con:removeAllChildrenWithCleanup(true)

		local id = reward[i][1]
		WZLog("WndGameSingIn:_updateid", id)
        if id ~= nil then 
			local celElement,tLuaObj = CellGoodItem:createElement()
		 	local tItem = {
         	    id = id,
         	    lastNum = reward[i][2],
         	    lastTime = reward[i][2],
         	    data = "",
         	    playerItemId = -1,
         	    basicInfo = GetItemLocalData(id)
         	}
		 	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setCellGoodItem(tItem, 2)
            tLuaObj:setItemClickFun(self, self.onItem2)
		 	celElement:setScale(1)
		 	con:addChild(celElement)
        end
	end
	local replenishSignCost = CacheCenter:getGameParam().replenishSignCost
	if replenishSignCost == nil or replenishSignCost == "" then
		replenishSignCost = "[70,10]&[70,20]&[70,30]&[70,40]&[70,50]"
	end
	local ids, nums = SplitItemString(replenishSignCost)
	WZLog("WndGameSingIn:_update_1", Serialize(ids), Serialize(nums), self.reissueTimes)
	GetElement(self.m_root,"text1_WndGameSingIn",WZUIFreeTextBox):setShowText(string.format(LocalStrings.NEWSINGIN1, tostring(dayNum-1)))
	GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox):setShowText(string.format(LocalStrings.NEWSINGIN3, 
		tostring(nums[self.reissueTimes+1]), GetItemLocalData(tonumber(ids[self.reissueTimes+1])).icon ))

	--签到次数没满
	GetElement(self.m_root,"imgGet",WZUIImage):setVisible(false)
	if self.days < (dayNum - 1) then
		GetElement(self.m_root,"btnCant",WZUIButton):setVisible(true)
		GetElement(self.m_root,"btnGet",WZUIButton):setVisible(false)
	else
		--签到次数已满，并且还没有领取月奖励，显示领取按钮
		if self.monthReward == true then
			GetElement(self.m_root,"btnCant",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnGet",WZUIButton):setVisible(false)
			GetElement(self.m_root,"imgGet",WZUIImage):setVisible(true)
		else
			GetElement(self.m_root,"btnCant",WZUIButton):setVisible(false)
			GetElement(self.m_root,"btnGet",WZUIButton):setVisible(true)
		end
	end
end

function WndGameSingIn:onItem2(tCell,tag,tData,conItem) 
	WZLog("WndGameSingIn:onItem2")
	WndItemInfo:showInfo(tCell.m_root,WndGameSingIn.m_root,1,tData,false)
end

function WndGameSingIn:show(tMsg)
    -- body
    local wndSignIn = WndGameSingIn:createElement()
    WindowManager:addWindow(wndSignIn , WndGameSingIn, nil, nil, true)
    self:setMsgData(tMsg)
end


--@brief	开始加载
--@note		开始（协议）信息的加载，显示加载框
function WndGameSingIn:_startLoading()
	--弹出加载框
	self.m_nLoadingID = MsgBoxManager:showLoadingBox(nil, nil, nil, nil)
end

--@brief	完成加载
--@note		完成（协议）信息的加载，关闭加载框
function WndGameSingIn:_finishedLoading()
	--关闭加载框
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingID)
end
-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndGameSingIn:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.6)
	GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF):setScale(0.65)

	GetElement(self.m_root,"text1_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
	GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
	GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
	GetElement(self.m_root,"text4_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
end

function WndGameSingIn:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.6)
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	GetElement(self.m_root,"text1_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
	GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
	GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
	GetElement(self.m_root,"text4_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
end

function WndGameSingIn:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.6)
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	local text1 = GetElement(self.m_root,"text1_WndGameSingIn",WZUIFreeTextBox)
	text1:setScale(0.8)
	text1:setMaxWidth(200)
	local txtSingInlable = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable:setScale(0.8)
	local text3 = GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox)
	text3:setScale(0.6)
	text3:setMaxWidth(560)
	GetElement(self.m_root,"text4_WndGameSingIn",WZUIFreeTextBox):setScale(0.6)
end

function WndGameSingIn:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.6)
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	local text1 = GetElement(self.m_root,"text1_WndGameSingIn",WZUIFreeTextBox)
	text1:setScale(0.8)
	local txtSingInlable = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable:setScale(0.8)
	local text3 = GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox)
	text3:setScale(0.6)
	text3:setMaxWidth(560)
	GetElement(self.m_root,"text4_WndGameSingIn",WZUIFreeTextBox):setScale(0.6)
end

function WndGameSingIn:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.38)
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	local text3 = GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox)
	text3:setScale(0.8)
	local text4 = GetElement(self.m_root,"text4_WndGameSingIn",WZUIFreeTextBox)
	text4:setScale(0.8)
end
---------------------------------------语言适配End------------------------------------------