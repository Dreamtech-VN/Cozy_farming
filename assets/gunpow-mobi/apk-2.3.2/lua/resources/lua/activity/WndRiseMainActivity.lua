--WndRiseMainActivity.lua
--@brief	WndRiseMainActivity的UI模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRiseMainActivity:onEnter(element)
	self.m_root = element
	ProtocolProcessorFestivalActivity:regAll6()
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRiseMainActivity:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndRiseMainActivity:showInterface()
	local wndRise = WndRiseMainActivity:createElement()
	if wndRise ~= nil then
	    WindowManager:addWindow(wndRise,WndRiseMainActivity,nil,false)
	end
end
function WndRiseMainActivity:register()
	LoadActivityWordsRes(true)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetRiseInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetGiftRewardResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GiftItemChoose,self._onChooseGiftItem,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetRewardRiseResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_BuyGiftResult,self._onBuyGiftResult,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onRiseGetBoxResult,self)
end
function WndRiseMainActivity:unregister()
	LoadActivityWordsRes(false)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetRiseInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetGiftRewardResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GiftItemChoose,self._onChooseGiftItem,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetRewardRiseResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_BuyGiftResult,self._onBuyGiftResult,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onRiseGetBoxResult,self)
end
function WndRiseMainActivity:onEnterTransitionDidFinish(element)
	self:_setBallAni()
	WindowManagerAni:createAppearAction(self.m_root,false,"actionCallback",self)
end
function WndRiseMainActivity:actionCallback()
	--选择的数据，每次关闭界面需要保存
	if not g_tRiseChooseGifyData then
		g_tRiseChooseGifyData = {}
	end
	for i=1,4 do
		local tab = {}
		tab.btnReward = GetElement(self.m_root,"btnReward"..i,WZUIButton)
		tab.goods_con = GetElement(self.m_root,"goods_con"..i,WZUIContainer)
		self.m_tRewardChooseItem[i] = tab
	end

	local box_container = GetElement(self.m_root,"boxContainer",WZUIContainer)
	local data = {}
	data.title = LocalStrings.ACTIVITY_TEXT58
	local box_common, box_common_obj = CellCommonBox:createElement(data, g_cityExtenInfo.activity7019, 2)
	box_container:addChild(box_common)
	self.m_sBoxCommonObj = box_common_obj
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7019, 7019)
end
function WndRiseMainActivity:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    if self.m_tChooseCountData[self.m_nCurChooseType] and self.m_tChooseCountData[self.m_nCurChooseType][tag] then
    	self.m_tChooseCountData[self.m_nCurChooseType][tag] = nil
    	g_tRiseChooseGifyData[self.m_nCurChooseType][tag] = nil
    	self.m_tRewardChooseItem[tag].btnReward:setVisible(true)
		self.m_tRewardChooseItem[tag].goods_con:setVisible(false)
		self:setBuyButton(self.m_nCurChooseType)
    	return
    end
   	if self.m_tRiseData[tag] then
   		self.m_nChooseGiftType = tag
   		WndRiseReward:showInterface(self.m_root, tCell.m_root, self.m_tRiseData[self.m_nCurChooseType], self.m_tChooseCountData[self.m_nCurChooseType])
   	end
end
--选择礼包的类型
function WndRiseMainActivity:onBtnChooseType(element)
	local tag
	if element == nil then
		element = 1
	end
	if type(element) == "number" then
		tag = element
	else
		tag = element:getTag()
	end
	if type(element) ~= "number" and self.m_nCurChooseType == tag then
		return
	end
	local box_str = {"ui/dailyCopy/common_icon_jiandan.png","ui/dailyCopy/common_icon_pt.png","ui/dailyCopy/common_icon_kunan.png","ui/dailyCopy/common_icon_jingying_02.png"}
	GetElement(self.m_root,"imgChooseBoxReward",WZUIImage):setFile(box_str[tag])

	local txtDayLimit = GetElement(self.m_root,"txtDayLimit",WZUIFreeTextBox)
	if self.m_tRiseData[tag].buyLimit == -1 then
		txtDayLimit:setVisible(false)
	else
		txtDayLimit:setVisible(true)
		txtDayLimit:setShowText(string.format([[<T C="255,236,193" S="20" P="1">%s%d/%d</T>]],LocalStrings.ACTIVITY_TEXT61, self.m_tRiseData[tag].buyCount, self.m_tRiseData[tag].buyLimit))
	end
	
	for i=1,4 do
		self.m_tRewardChooseItem[i].btnReward:setVisible(false)
		self.m_tRewardChooseItem[i].goods_con:setVisible(false)
		local data = nil
		if g_tRiseChooseGifyData[tag] then
			data = g_tRiseChooseGifyData[tag][i]
		end
		if self.m_tChooseCountData[tag] == nil then
			self.m_tChooseCountData[tag] = {}
			self.m_tChooseGiftIndex[tag] = {}
		end
		if data then
			for k=1, #self.m_tRiseData[tag].itemId do
				if data.basicInfo.id == self.m_tRiseData[tag].itemId[k] then
					self.m_tChooseCountData[tag][i] = data.basicInfo.id
					self.m_tChooseGiftIndex[tag][i] = self.m_tRiseData[tag].itemIndex[k]
					break
				end
			end

			self.m_tRewardChooseItem[i].goods_con:setVisible(true)
			self.m_tRewardChooseItem[i].btnReward:setVisible(false)
			if self.m_tChooseCellItem[i] == nil then
				local celElement,tLuaObj = CellGoodItem:createElement()
				celElement:setTag(i)
				self.m_tChooseCellItem[i] = tLuaObj
				self.m_tRewardChooseItem[i].goods_con:addChild(celElement)
			end
			local itemInfo = {lastTime=data.lastNum,lastNum=data.lastNum,basicInfo=CopyTable(GDatatab_item["id_"..data.basicInfo.id])}
			self.m_tChooseCellItem[i]:setCellGoodItem(itemInfo, 17)
			self.m_tChooseCellItem[i]:setItemClickFun(WndRiseMainActivity,self.onItemClick)
		else
			self.m_tRewardChooseItem[i].btnReward:setVisible(true)
			self.m_tRewardChooseItem[i].goods_con:setVisible(false)
		end
	end
	self:setBuyButton(tag)
	self.m_nCurChooseType = tag
end
--购买按钮变灰
function WndRiseMainActivity:setBuyButton(_type)
	local btnBuy = GetElement(self.m_root,"btnBuy",WZUIButton)
	local txtBuyMoney = GetElement(btnBuy,"txtBuyMoney",WZUILabelTTF)
	txtBuyMoney:setText(self.m_tRiseData[_type].money)
	local imgBuy = GetElement(btnBuy,"imgBuy",WZUIImage)
	local status = nil
	if self.m_tRiseData[_type].buyCount >= self.m_tRiseData[_type].buyLimit then
		status = true
	end
	local temp_status = nil
	if not status then
		if g_tRiseChooseGifyData[_type] == nil then
		else
			if GetTableLen(g_tRiseChooseGifyData[_type]) >= 4 then
				temp_status = true
			end
		end
	end
	if temp_status then
		imgBuy:setGrayRender(false)
		txtBuyMoney:setColor(GlobalMethod:ccc3(255,255,255))
		txtBuyMoney:setStrokeColor(GlobalMethod:ccc3(80,61,50))
	else
		imgBuy:setGrayRender(true)
		txtBuyMoney:setColor(GlobalMethod:ccc3(255,250,236))
		txtBuyMoney:setStrokeColor(GlobalMethod:ccc3(163,74,20))
	end
	btnBuy:setTouchEnable(not status)
end
--选择礼包的
function WndRiseMainActivity:onBtnReward(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	if not self.m_tRiseData then return end
	self.m_nChooseGiftType = tag
	WndRiseReward:showInterface(self.m_root, element, self.m_tRiseData[self.m_nCurChooseType], self.m_tChooseCountData[self.m_nCurChooseType])
end

function WndRiseMainActivity:onBtnShop()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndRiseShop:showInterface()
end
function WndRiseMainActivity:onBtnRule()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndFourStarRuleDesc:showInterface(LocalStrings.ACTIVITY_TEXT55)
end
function WndRiseMainActivity:onBtnBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.m_tRiseData[self.m_nCurChooseType] then
		return
	end
	if g_tRiseChooseGifyData[self.m_nCurChooseType] == nil or GetTableLen(g_tRiseChooseGifyData[self.m_nCurChooseType]) < 4 then
		MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT60)
		return
	end

	local tab = {}
	tab.refreshTime = self.m_tRiseData[self.m_nCurChooseType].refreshTime
	tab.giftId = self.m_nCurChooseType - 1
	tab.itemIndex = self.m_tChooseGiftIndex[self.m_nCurChooseType]
	tab.rechargeId = self.m_tRiseData[self.m_nCurChooseType].change_id
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7019, 2, tab)
end
function WndRiseMainActivity:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndRiseMainActivity:_onGetRiseInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	if activityId == tonumber(g_cityExtenInfo.activity7019) then
		local txtActivityTime = GetElement(self.m_root,"txtActivityTime",WZUILabelTTF)
		local _startTime = SystemTime:getTimeConverLocal(startTime)
		local _endTime = SystemTime:getTimeConverLocal(endTime)
		txtActivityTime:setText(LocalStrings.PEOPLE_SHOP_TEXT1.._startTime.."-".._endTime)
		self.m_tBoxData = self:setBoxProgressData(status,rewardItems,rewardItemsParamCount,rewardCounts,finishCondition)
		if self.m_sBoxCommonObj then
			self.m_sBoxCommonObj:setInitBoxStatus(count,self.m_tBoxData, g_cityExtenInfo.activity7019)
		end
	end
end
--礼包返回
function WndRiseMainActivity:_onGetGiftRewardResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7019) then
		msg = json.decode(msg)
		if msg and doType == 1 then
			self:setRiseData(msg)
			if self.m_nCurChooseType then
				self.m_tChooseCountData[self.m_nCurChooseType] = {}
				self.m_tChooseGiftIndex[self.m_nCurChooseType] = {}
				g_tRiseChooseGifyData[self.m_nCurChooseType] = {}
			end
			local index = nil
			for i=1,4 do
				if self.m_tRiseData[i].buyLimit == -1 then --不限购
					index = 1
					break
				else
					if self.m_tRiseData[i].buyCount < self.m_tRiseData[i].buyLimit then
						index = i
						break
					end
				end
			end
			self:onBtnChooseType(index)
		end
	end
end
--礼包的物品选择
--index: 选择的物品序号
function WndRiseMainActivity:_onChooseGiftItem(data, index)
	if not index then return end
	local chooseType = self.m_nCurChooseType
	local giftType = self.m_nChooseGiftType
	if g_tRiseChooseGifyData[chooseType] == nil then
		g_tRiseChooseGifyData[chooseType] = {}
	end
	if self.m_tChooseCountData[chooseType] == nil then
		self.m_tChooseCountData[chooseType] = {}
		self.m_tChooseGiftIndex[chooseType] = {}
	end
	g_tRiseChooseGifyData[chooseType][giftType] = data
	if data then
		self.m_tChooseGiftIndex[chooseType][giftType] = self.m_tRiseData[chooseType].itemIndex[index]
		self.m_tChooseCountData[chooseType][giftType] = data.basicInfo.id
		self.m_tRewardChooseItem[giftType].btnReward:setVisible(false)
		self.m_tRewardChooseItem[giftType].goods_con:setVisible(true)
		if self.m_tChooseCellItem[giftType] == nil then
			local celElement,tLuaObj = CellGoodItem:createElement()
			self.m_tChooseCellItem[giftType] = tLuaObj
			celElement:setTag(giftType)
			self.m_tRewardChooseItem[giftType].goods_con:addChild(celElement)
		end
		local itemInfo = {lastTime=data.lastNum,lastNum=data.lastNum,basicInfo=CopyTable(GDatatab_item["id_"..data.basicInfo.id])}
		self.m_tChooseCellItem[giftType]:setCellGoodItem(itemInfo, 17)
		self.m_tChooseCellItem[giftType]:setItemClickFun(WndRiseMainActivity,self.onItemClick)
	else
		self.m_tChooseGiftIndex[chooseType][giftType] = nil
		self.m_tChooseCountData[chooseType][giftType] = nil
		self.m_tRewardChooseItem[giftType].btnReward:setVisible(true)
		self.m_tRewardChooseItem[giftType].goods_con:setVisible(false)
	end
	self:setBuyButton(chooseType)
end
--充值返回
function WndRiseMainActivity:_onGetRewardRiseResult(activityId, doType, result, msg)
	if activityId == tonumber(g_cityExtenInfo.activity7019) then
		msg = json.decode(msg)
		if msg and doType == 2 then
			local data = GDatatab_recharge["id_" .. msg.rechargeId]
			if data then
				setRiseChooseGiftData(self.m_nCurChooseType)
				local tab = {}
				tab.id = data.id
				tab.price = data.price
				tab.number = 1
				tab.productName = data.name
				tab.payCode = GetPayCodeIdByChannelId(data)
				PassportSdkManager:getOrderNum(tab)
			end
		end
	end
end
--购买礼包的返回
function WndRiseMainActivity:_onBuyGiftResult(itemIds, itemNums)
	if self.m_nCurChooseType then
		self.m_tChooseCountData[self.m_nCurChooseType] = {}
	end
	for i=1,4 do
		self.m_tRewardChooseItem[i].btnReward:setVisible(true)
		self.m_tRewardChooseItem[i].goods_con:setVisible(false)
	end
end
--宝箱领取成功
function WndRiseMainActivity:_onRiseGetBoxResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)
	if self.m_tBoxData then
		for i=1, #self.m_tBoxData do
			if rewardId == self.m_tBoxData[i].id then
				self.m_tBoxData[i].status = 1
				break
			end
		end
		if self.m_sBoxCommonObj then
			self.m_sBoxCommonObj:setBoxStatus()
		end
		local status = false
		for i,v in pairs(self.m_tBoxData) do
			if v.status == 0 then
				status = true
				break
			end
		end
		SceneCity:setSceneMainIconRedPoint(RISE_ACTIVITY, status)
	end
end

--@brief 	设置待机特效
function WndRiseMainActivity:_setBallAni()
	local spinePath = "activity/ui_common_jqzlbx"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineWait = GetElement(self.m_root, "spineWait_WndRiseMainActivity", WZUISpine)
		if spineWait then 
			spineWait:setFileJson(spinePath .. ".json")
			spineWait:setFileAtlas(spinePath .. ".atlas")
			spineWait:play("wait_1", true)
		end
	else
		local _sIndex = "ui_common_jqzlbx"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7019, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndRiseMainActivity)
        end
	end
end

function WndRiseMainActivity:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndRiseMainActivity:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end
-------------------------------------私有方法模块End----------------------------------------
