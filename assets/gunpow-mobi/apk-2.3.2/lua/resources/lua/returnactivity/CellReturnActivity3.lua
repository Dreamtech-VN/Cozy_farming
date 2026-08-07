--CellReturnActivity3.lua
--@brief	CellReturnActivity3的UI模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动6元特惠


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellReturnActivity3:onEnter(element)
	self.m_root = element
	self:register()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellReturnActivity3:onExit(element)
	self:_unInit()
	self:unregister()
end
function CellReturnActivity3:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetReturnActivity3Info,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetRewardResult,self)
end
function CellReturnActivity3:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetReturnActivity3Info,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetRewardResult,self)
end
function CellReturnActivity3:onEnterTransitionDidFinish(element)
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(self.m_nActivityId,self.m_nActivityType)
end

function CellReturnActivity3:onBtnBuy()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nChargeId then
		local data = GDatatab_recharge["id_" .. self.m_nChargeId]
		--必带。id：产品id，price:价格；productName:商品名称；payCode:商品号
		if data then
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
function CellReturnActivity3:onBtnGet()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurDay then
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId, self.m_nCurDay)
	end
end

function CellReturnActivity3:setVisibleStatus(bool)
	bool = bool or false
	if self.m_root then
		self.m_root:setVisible(bool)
	end
end
function CellReturnActivity3:onBtnLeft()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurDay <= 1 then
		return
	end
	self.m_nCurDay = self.m_nCurDay - 1
	self:showDayReward(self.m_nCurDay)
end
function CellReturnActivity3:onBtnRight()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nCurDay >= #self.m_tReturnChargeData then
		return
	end
	self.m_nCurDay = self.m_nCurDay + 1
	self:showDayReward(self.m_nCurDay)
end
function CellReturnActivity3:showDayReward(day)
	GetElement(self.m_root,"btnLeft",WZUIButton):setVisible(true)
	GetElement(self.m_root,"btnRight",WZUIButton):setVisible(true)
	if day <= 1 then
		GetElement(self.m_root,"btnLeft",WZUIButton):setVisible(false)
	end
	if day >= #self.m_tReturnChargeData then
		GetElement(self.m_root,"btnRight",WZUIButton):setVisible(false)
	end

	GetElement(self.m_root,"txtDay",WZUILabelTTF):setText(string.format(LocalStrings.SingInDAYS, day))
	local data = self.m_tReturnChargeData[day]
	for i=1,2 do
		local good_con = GetElement(self.m_root,"good_con"..i,WZUIContainer)
		good_con:setVisible(false)
	end
	self:setCellGoodCon(data)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellReturnActivity3:_onGetReturnActivity3Info(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips )
	if activityId == self.m_nActivityId then
		local txtActivity3Time = GetElement(self.m_root,"txtActivity3Time",WZUIFreeTextBox)
		if txtActivity3Time then
			local time = SystemTime:getTimeConverLocal(endTime)
			local str = string.format([[%s<T C="255,236,193" S="18" P="1" SC="132,66,29" SE="1" SS="4"> %s</T>]],LocalStrings.SEVENDAY_TEXT4, time)
			txtActivity3Time:setShowText(str)
		end

		content = tonumber(content)
		self:setRewardData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts)
		local data = self.m_tReturnChargeData

		self.m_nCurDay = content
		self.m_nChargeId = maxCount

		self.m_bIsGetStatus = tips[1]

		GetElement(self.m_root,"txtOldPrice",WZUILabelTTF):setText(tips[2]..LocalStrings.MONEY_UNIT)
		GetElement(self.m_root,"txtNewPrice",WZUILabelTTF):setText(tips[3]..LocalStrings.MONEY_UNIT)
		local txtGetDesc = GetElement(self.m_root,"txtGetDesc",WZUILabelTTF)
		txtGetDesc:setText(string.format(LocalStrings.ACTIVITY_TEXT41, content, #rewardId))

		local reward_data = data[content]
		self:showDayReward(self.m_nCurDay)
	end
end

function CellReturnActivity3:setCellGoodCon(reward_data)
	if not self.m_root then return end
	local btnBuy = GetElement(self.m_root,"btnBuy",WZUIButton)
	btnBuy:setVisible(false)
	local btnGet = GetElement(self.m_root,"btnGet",WZUIButton)
	btnGet:setVisible(false)
	local imgAlreadyBuy = GetElement(self.m_root,"imgAlreadyBuy",WZUIImage)
	imgAlreadyBuy:setVisible(false)
	if self.m_bIsGetStatus == "false" then
		btnBuy:setVisible(true)
	else
		if reward_data and reward_data.status == 0 then
			btnGet:setVisible(true)
		else
			imgAlreadyBuy:setVisible(true)
			btnGet:setVisible(false)
		end
	end
	if reward_data then
		--必有
		local good_con = GetElement(self.m_root,"good_con",WZUIContainer)
		GetElement(good_con,"imgGet",WZUI9Image):setVisible(reward_data.status == 1)
		self:cerateCellItem(1, good_con, reward_data.reward_id[1],reward_data.reward_num[1], reward_data.status)
		local imgIcon = GetElement(self.m_root, "imgIcon_CellReturnActivity3", WZUIImage)
		local basicData = GDatatab_item["id_" .. reward_data.reward_id[1]]
		if basicData then 
			WZLog("KKKKKKKKKKKKKKK", basicData.icon, basicData.main_type)
			if basicData.main_type == 23 then 
				local newIcon = string.gsub(basicData.icon, ".png", "_1.png")
				imgIcon:setFile(newIcon)
			elseif basicData.main_type == 9 then 
				local mergeItem = GDatatab_itemmerge["id_" .. reward_data.reward_id[1]]
				if mergeItem and mergeItem.items then 
					local basicInfo = GDatatab_item["id_" .. mergeItem.items[1][1]]
					if basicInfo then 
						if basicInfo.main_type == 23 then
							local newIcon = string.gsub(basicInfo.icon, ".png", "_1.png")
							imgIcon:setFile(newIcon)
						else
							imgIcon:setFile(basicInfo.icon)
						end
					end
				end
			else
				imgIcon:setFile(basicData.icon)
			end
		end
		--选取
		if reward_data.reward_id[2] then
			local good_con1 = GetElement(self.m_root,"good_con1",WZUIContainer)
			good_con1:setVisible(true)
			GetElement(good_con1,"imgGet1",WZUI9Image):setVisible(reward_data.status == 1)
			self:cerateCellItem(2, good_con1, reward_data.reward_id[2],reward_data.reward_num[2], reward_data.status)
		end
		if reward_data.reward_id[3] then
			local good_con2 = GetElement(self.m_root,"good_con2",WZUIContainer)
			good_con2:setVisible(true)
			GetElement(good_con2,"imgGet2",WZUI9Image):setVisible(reward_data.status == 1)
			self:cerateCellItem(3, good_con2, reward_data.reward_id[3],reward_data.reward_num[3], reward_data.status)
		end
	end
end
function CellReturnActivity3:cerateCellItem(index, node, id, num, status)
	if not id then return end

	if self.m_sCellItem[index] == nil then
		local celElement, tNewObj = CellGoodItem:createElement()
		node:addChild(celElement)
		self.m_sCellItem[index] = tNewObj
	end
	local items = GDatatab_item["id_".. id]
    local itemInfo = {id=i, name=items.name,icon=items.icon,lastNum=num,quality=items.quality,basicInfo=CopyTable(items)}
   	self.m_sCellItem[index]:setCellGoodItem(itemInfo,17)
    self.m_sCellItem[index]:setItemClickFun(WndReturnActivityMain,self.onItemClick)

    if status == 0 then
    	if node:getChildByTag(index) then
	        node:removeChildByTag(index,true)
	    end

	    local spine = WZUISpine:create()
	   	spine:setTouchEnable(false)
	   	spine:setFileJson("ui/ui_common_JJLQ.json")
	   	spine:setFileAtlas("ui/ui_common_JJLQ.atlas")
	   	spine:setUseOriginSize(true)
	   	spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		spine:play("wait_1",true)
	   	node:addChild(spine,1, index)
	else
		if node:getChildByTag(index) then
	        node:removeChildByTag(index,true)
	    end
	end
end

function CellReturnActivity3:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root,WndReturnActivityMain.m_root,1,tData,false,nil,true)
end

function CellReturnActivity3:_onGetRewardResult(itemsId, count, _type, rewardId)
	if self.m_nActivityType == _type then
		WndRewardShow:showById(itemsId, count)
		if self.m_tReturnChargeData[rewardId] then
			self.m_tReturnChargeData[rewardId].status = 1
			self:setCellGoodCon(self.m_tReturnChargeData[rewardId])
			local redpoint_status = false
			for i,v in pairs(self.m_tReturnChargeData) do
				if v.status == 0 then
					redpoint_status = true
					break
				end
			end
			WndReturnActivityMain:setReturnRedPointStatus(self.m_nActivityType, redpoint_status)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块begin--------------------------------------
function CellReturnActivity3:_adaptLanguage_vn()
	GetElement(self.m_root,"txtActivity3Time",WZUIFreeTextBox):setMaxWidth(800)
end
-------------------------------------语言适配模块end--------------------------------------
