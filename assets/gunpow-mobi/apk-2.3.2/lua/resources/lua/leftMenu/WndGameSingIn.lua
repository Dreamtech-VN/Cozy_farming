--WndGameSingIn.lua
--@brief	WndGameSingIn的UI模块
--@date		2015/04/29
--@author	weidong_wu
--@note		签到


-------------------------------------公有方法模块Begin--------------------------------------
--宝箱数据
local closeBox = {"ui/common/common_icon_lan1.png","ui/common/common_icon_zi1.png","ui/common/common_icon_huang1.png"}
local openBox = {"ui/common/common_icon_lan2.png","ui/common/common_icon_zi2.png","ui/common/common_icon_huang2.png"}
local nullBox = {"ui/common/common_icon_lan3.png","ui/common/common_icon_zi3.png","ui/common/common_icon_huang3.png"}
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGameSingIn:onEnter(element)
	self.m_root = element
	ProtocolProcessorWndGameSingIn:regAll()
	self:register()
	self:_initStaticTxt()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGameSingIn:onExit(element)
	ProtocolProcessorWndGameSingIn:unregAll()
	self:unregister()
	self:_unInit()
end
function WndGameSingIn:register()
	GlobalGame:getBattleEventDispatcher():Add("GAMESINGIN_TOTLE_GET",self._onTotleGetResult,self)
end
function WndGameSingIn:unregister()
	GlobalGame:getBattleEventDispatcher():Remove("GAMESINGIN_TOTLE_GET",self._onTotleGetResult,self)
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
	local day = os.date("%d", SystemTime:getServerTime())
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

function WndGameSingIn:onClickBox(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = tonumber(element:getTag())
	self.cur_day = tonumber(self.cur_day)
	if self.cur_day and self.cur_day >= tonumber(self.m_tBoxDays[tag]) and self.m_tBoxStatus[tonumber(self.m_tBoxDays[tag])] == 0 then
		local get_day = tonumber(self.m_tBoxDays[tag])
		ProtocolProcessorWndGameSingIn:send_TASK_ReceiveSignTotaReward(get_day)
		self.touchBoxItem = self.m_tBoxStatusMessage[tag]
		return
	end

	local winsize = CCDirector:sharedDirector():getWinSize()
	local container = WZUIContainer:create()
	container:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	container:setUseAbsSize(true)
	container:setAbsContentSize(winsize)
	self.m_root:addChild(container)


	self.m_btnBoxItem = WZUIButton:create()
	self.m_btnBoxItem:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    self.m_btnBoxItem:setUseAbsSize(true)
    self.m_btnBoxItem:setAbsContentSize(winsize)
    self.m_btnBoxItem:setZOrder(0)
    self.m_btnBoxItem:setAbsPosition(GlobalMethod:ccp(winsize.width*0.5, winsize.height*0.5))
    container:addChild(self.m_btnBoxItem)
    self.m_btnBoxItem:setLuaDoneFunctionName("onClickBoxItem")

 
	local celElement,tCell = CellGoodItem:createElement()		
	container:addChild(celElement)
	celElement:setAnchorPoint(GlobalMethod:ccp(0.5,0))
	celElement:setUseAbsCoordinate(true)
	self.m_celElementTotleItem = celElement

	self.m_celElementTotleItem:setZOrder(999999)
	self.m_celElementTotleItem:setAbsPosition(GlobalMethod:ccp(430+(tag*100),530))
	local itemInfo = {}
	itemInfo.lastNum = self.m_tBoxNumbers[tag] or 1
	local id = self.m_tBoxItemIds[tag] or 1
	itemInfo.basicInfo = CopyTable(GDatatab_item["id_"..id])
	tCell:setCellGoodItem(itemInfo, 2)
	tCell:setItemClickFun(self,self.onItemClick)
end
--@brief	点击物品弹出对应的tips
function WndGameSingIn:onItemClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndGameSingIn.m_root,1,tData,false)
end
function WndGameSingIn:onClickBoxItem()
	self:removeTip()
end
function WndGameSingIn:removeTip()
	if self.m_btnBoxItem then
		self.m_btnBoxItem:removeFromParentAndCleanup(true)
	end
	if self.m_celElementTotleItem then
		self.m_celElementTotleItem:removeFromParentAndCleanup(true)
	end
end
--解析宝箱的奖励
function WndGameSingIn:getBoxReward()
	local answer = CacheCenter:getGameParam().signreward
	local array = SplitStringWithSeparator(answer,"&")

	local ids = {}
	local nums = {}
	local days = {}
	if array then
		for i=1,#array do
			local string = string.sub(array[i],2,-2)
			local day = SplitStringWithSeparator(string,",")[1]
			local id = SplitStringWithSeparator(string,",")[2]
			local num = SplitStringWithSeparator(string,",")[3]
			table.insert(ids,id)
			table.insert(nums,num)
			table.insert(days,day)
		end
	end
	self.m_tBoxItemIds = ids
	self.m_tBoxNumbers = nums
	self.m_tBoxDays = days
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief 	初始化静态数据
function WndGameSingIn:_initStaticTxt(  )
	--5月累计签到天数:3
	local txtSingInlable_WndGameSingIn = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable_WndGameSingIn:setShowText("")
	--宝箱进度条
	self.getSignInProgress = GetElement(self.m_root,"getSignInProgress",WZUIProgress)
	self.getSignInProgress:setPercentage(0)

    self:getBoxReward()
    self.m_tBoxStatusMessage = {}
	for i = 1, 3 do
		local tab = {}
        tab.imgBox = GetElement(self.m_root, "imgBtn"..i.."_WndSingIn", WZUIImage)
        tab.imgBox:setVisible(false)
        tab.txtTimes = GetElement(self.m_root, "txtTimes"..i.."_WndSingIn", WZUILabelTTF)
        tab.armBox = GetElement(self.m_root, "armBox"..i.."_WndSingIn", WZArmature)
        tab.armBox:setVisible(false)

	    tab.txtTimes:setText((self.m_tBoxDays[i] or "").. LocalStrings.DAY)
	    tab.day = self.m_tBoxDays[i]
	    self.m_tBoxStatusMessage[i] = tab
    end
end
--签到累计奖励结果
function WndGameSingIn:_onTotleGetResult(day)
	if not self.m_tBoxStatus then return end
	self.m_tBoxStatus[day] = 1
	local index = 1
	if self.m_tBoxStatusMessage then
		for i,v in ipairs(self.m_tBoxStatusMessage) do
			if tonumber(v.day) == day then
				index = i
				break
			end
		end
	end

	WndRewardShow:showById({self.m_tBoxItemIds[index]}, {self.m_tBoxNumbers[index]})
	if self.touchBoxItem then
		self.touchBoxItem.imgBox:setFile(nullBox[index])
	    self.touchBoxItem.armBox:setVisible(false)
	end
end
function WndGameSingIn:_setSignDays( days )
	self.cur_day = days
	local NEW_ACTIVITY_TEXT_3 = LocalStrings.NEW_ACTIVITY_TEXT_3
	if ProjConfig.LANGUAGE == "vn" then
		NEW_ACTIVITY_TEXT_3 = [[<T C="149,98,57" S="20" P="1" SE="0">Tích lũy</T><BR>-5</BR><T C="149,98,57" S="20" P="1" SE="0"> điểm danh </T><BR>-5</BR><T C="240,103,122" S="22" P="1" SC="240,103,122" SE="1" SS="1"> %s</T><T C="149,98,57" S="20" P="1" SE="0">  ngày</T>]]
	end
	 local daysStr = string.format(NEW_ACTIVITY_TEXT_3, tostring(days))
	local txtSingInlable_WndGameSingIn = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable_WndGameSingIn:setShowText(daysStr)
	if self.getSignInProgress then
		-- 7、15、31
		if days <= 7 then
			self.getSignInProgress:setPercentage(((33/7) * days))
		elseif days > 7 and days <= 15 then
			self.getSignInProgress:setPercentage(33 + ((33/8) * (days-7)))
		elseif days > 15 then
			self.getSignInProgress:setPercentage(66 + ((33/15) * (days-15)))
		end 
	end

	if self.m_tBoxStatusMessage then
		for i,v in ipairs(self.m_tBoxStatusMessage) do
			self.m_tBoxStatusMessage[i].imgBox:setVisible(true)
			if tonumber(v.day) == days and self.m_tBoxStatus[tonumber(v.day)] ~= 1 then
				self.m_tBoxStatusMessage[i].imgBox:setFile(openBox[2])
	            self.m_tBoxStatusMessage[i].armBox:setVisible(true)
			else
				if self.m_tBoxStatus[tonumber(v.day)] == -1 then --不可领取
					self.m_tBoxStatusMessage[i].imgBox:setFile(closeBox[1])
	            	self.m_tBoxStatusMessage[i].armBox:setVisible(false)
				elseif self.m_tBoxStatus[tonumber(v.day)] == 0 then --可领取
					self.m_tBoxStatusMessage[i].imgBox:setFile(openBox[2])
	            	self.m_tBoxStatusMessage[i].armBox:setVisible(true)
				elseif self.m_tBoxStatus[tonumber(v.day)] == 1 then --已领取
					self.m_tBoxStatusMessage[i].imgBox:setFile(nullBox[3])
	            	self.m_tBoxStatusMessage[i].armBox:setVisible(false)
				end
			end
		end
	end

	--可补签次数
	local day = os.date("%d", SystemTime:getServerTime())
	local showNum = day - days - 1
	if self.b_sign then
		showNum = showNum + 1
	end
	if showNum < 0 then showNum = 0 end
end

function WndGameSingIn:_update()
	WZLog("WndGameSingIn:_update")
	local DayCount = 0
	local leapYear={31,29,31,30,31,30,31,31,30,31,30,31}
	local commonYear={31,28,31,30,31,30,31,31,30,31,30,31}
	local templateYear
	local tempDayOffset = 0 	--日期修正，对于2月配置了29天奖励的，又不是闰年的，如果self.m_currentYear 大于 一月天数+二月天数的，要多加1天，修正奖励显示
	if (self.m_currentYear%4==0 and not (self.m_currentYear%100==0)) or (self.m_currentYear%400==0) then 
		templateYear=leapYear
	else 
		templateYear=commonYear
		if self.m_currentDay > commonYear[1] + commonYear[2] then 
			tempDayOffset = 1
		end
	end 
	local tempDayIndex = self.m_currentDay + tempDayOffset
	if not GDatatab_sign_reward["id_" .. tempDayIndex] then return end

	local month = GDatatab_sign_reward["id_" .. tempDayIndex].month
	DayCount = templateYear[month]
	local CellCount = templateYear[month]/5
	local flCalendarSingIn = GetElement(self.m_root,"flCalendarSingIn_WndGameSingIn",WZUIFreeListContainer)
	if flCalendarSingIn == nil then 
		WZLog("flCalendarSingIn is nil")
		return 
	end 
	if self.m_tSignCell == nil then self.m_tSignCell = {} end 

	CellCount = math.ceil(CellCount)
	local DayListStart = tempDayOffset
	local NeedIndex = month-1
	for i=1,NeedIndex do
		DayListStart = DayListStart + templateYear[i]
	end
	for i=1,CellCount do
		local m_tDate = {}
		local AllMonthDays = DayListStart + templateYear[month]
		for j=1,5 do
			local idKey = j+(i-1)*5+DayListStart
			if idKey <= AllMonthDays then
				table.insert(m_tDate,GDatatab_sign_reward["id_"..idKey])
			end 
		end
		if self.m_tSignCell[i] == nil then 
			local cellElement,newLuaObj = CellGameSingInItem:createElement()
	        cellElement = WZUIContainer:luaTo(cellElement)
	        newLuaObj:setTabDate(i,m_tDate,self.b_sign,self.b_vipSign,self.days)
	        cellElement:setTag(i-1)
	        flCalendarSingIn:pushBack(cellElement)

	        self.m_tSignCell[i] = {cellElement, newLuaObj}
	    else
	    	local cellElement, newLuaObj = self.m_tSignCell[i][1], self.m_tSignCell[i][2]
	        cellElement = WZUIContainer:luaTo(cellElement)
	        newLuaObj:resetTabDate(i,m_tDate,self.b_sign,self.b_vipSign,self.days)
	    end
	end
	flCalendarSingIn:update()
	local nCurPositionY = flCalendarSingIn:getMinPosition().y
	local nRow = math.ceil(self.days/5)
	if nRow > 2 then 
		nCurPositionY = nCurPositionY + (nRow - 2) * 120
		if nCurPositionY > flCalendarSingIn:getMaxPosition().y then 
			nCurPositionY = flCalendarSingIn:getMaxPosition().y
		end
	end
	flCalendarSingIn:getMoveElement():setPositionY(nCurPositionY)

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
	local replenishSignCost = CacheCenter:getGameParam().replenishSignCost
	if replenishSignCost == nil or replenishSignCost == "" then
		replenishSignCost = "[70,10]&[70,20]&[70,30]&[70,40]&[70,50]"
	end
	local ids, nums = SplitItemString(replenishSignCost)
	local text3_WndGameSingIn = GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox)
	text3_WndGameSingIn:setShowText(string.format(LocalStrings.NEW_ACTIVITY_TEXT_4, GetItemLocalData(tonumber(ids[self.reissueTimes+1])).icon,tostring(nums[self.reissueTimes+1])))
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

--@brief    签到成功事件
function WndGameSingIn:_postSignInEvent()
    -- body
    local level = CacheCenter:getPlayerInfo().level
    if level >= 6 and level <= 10 then 
        local eventKey = PostPlayerEvent["event_gameSignIn" .. level]
        if eventKey then 
            PostPlayerEvent:postEvent(eventKey)    
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function WndGameSingIn:_adaptLanguage_vn(  )
	local txtIncomplete = GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF)
	if txtIncomplete then
		txtIncomplete:setScale(0.6)
	end
	GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF):setScale(0.65)

	GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox):setScale(0.75)
end

function WndGameSingIn:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.6)
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
	GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox):setScale(0.7)
end

function WndGameSingIn:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.6)
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	text1:setScale(0.8)
	text1:setMaxWidth(200)
	local txtSingInlable = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable:setScale(0.8)
	local text3 = GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox)
	text3:setScale(0.6)
	text3:setMaxWidth(560)
end

function WndGameSingIn:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.6)
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	text1:setScale(0.8)
	local txtSingInlable = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable:setScale(0.8)
	local text3 = GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox)
	text3:setScale(0.6)
	text3:setMaxWidth(560)
end

function WndGameSingIn:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF):setScale(0.38)
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	local text3 = GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox)
	text3:setScale(0.8)
end

function WndGameSingIn:_adaptLanguage_ug(  )
	local txtIncomplete = GetElement(self.m_root,"txtIncomplete_WndGameSingIn",WZUILabelTTF)
	txtIncomplete:setScale(0.45)
	txtIncomplete:setDimensions(GlobalMethod:CCSize(140))
	local txtReissue = GetElement(self.m_root,"txtReissue_WndGameSingIn",WZUILabelTTF)
	txtReissue:setScale(0.6)
	txtReissue:setDimensions(GlobalMethod:CCSize(110,0))

	local text1 = GetElement(self.m_root,"text1_WndGameSingIn",WZUIFreeTextBox)
	text1:setScale(0.55)
	local txtSingInlable = GetElement(self.m_root,"txtSingInlable_WndGameSingIn",WZUIFreeTextBox)
	txtSingInlable:setScale(0.55)
	txtSingInlable:setMaxWidth(600)
	local text3 = GetElement(self.m_root,"text3_WndGameSingIn",WZUIFreeTextBox)
	text3:setScale(0.6)
	text3:setMaxWidth(560)
	GetElement(self.m_root,"text4_WndGameSingIn",WZUIFreeTextBox):setScale(0.6)
end

---------------------------------------语言适配End------------------------------------------