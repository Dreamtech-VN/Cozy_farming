--CellWeekendLimitedItem.lua
--@brief	CellWeekendLimitedItem的UI模块
--@date		2020/10/13
--@author	yrd
--@note		周末限定格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellWeekendLimitedItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellWeekendLimitedItem:onExit(element)
	self:_unInit()
end

function CellWeekendLimitedItem:update()
	local btn_GetReward = GetElement(self.m_root,"btn_GetReward",WZUIButton)
	local btn_DoTask = GetElement(self.m_root,"btn_DoTask",WZUIButton)
	local img_get = GetElement(self.m_root,"img_get",WZUIImage)


	local txt_buttonName = GetElement(self.m_root,"txt_buttonName",WZUILabelTTF)

	if self.m_data.rewardId == 1 then
		if self.m_data.status == -1 then
			btn_GetReward:setVisible(true)
			btn_GetReward:setTouchEnable(false)
			txt_buttonName:setLabelStyleKey("NORMAL_GRAY_BTN")
			txt_buttonName:setScale(0.846)
		elseif self.m_data.status == 0 then
			btn_GetReward:setVisible(true)
		elseif self.m_data.status == 1 then
			img_get:setVisible(true)
		end
	elseif self.m_data.rewardId == 7 or self.m_data.rewardId == 8 then
		if self.m_data.status == -1 then
			if SceneCity:isLouyixiao() then
				btn_DoTask:setVisible(true)
			else
				btn_GetReward:setVisible(true)
				btn_GetReward:setTouchEnable(false)
				txt_buttonName:setLabelStyleKey("NORMAL_GRAY_BTN")
				txt_buttonName:setScale(0.846)
			end
		elseif self.m_data.status == 0 then
			btn_GetReward:setVisible(true)
		elseif self.m_data.status == 1 then
			img_get:setVisible(true)
		end

	else
		if self.m_data.status == -1 then
			btn_DoTask:setVisible(true)
		elseif self.m_data.status == 0 then
			btn_GetReward:setVisible(true)
		elseif self.m_data.status == 1 then
			img_get:setVisible(true)
		end
	end

	local ftbTitle = GetElement(self.m_root,"ftbTitle_conItem",WZUIFreeTextBox)
	if self.m_data.rewardId == 1 then --累计登陆
		local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0">%s</T><T C="127,70,26" S="20" P="0">%s</T>]]
		ftbTitle:setShowText(string.format(strFormat,LocalStrings.GAMEACTIVITY_CUMULATIVELOGIN2,self.m_data.target,LocalStrings.DAY))
	elseif self.m_data.rewardId >= 2 and self.m_data.rewardId <= 6 then --累计充值?/?钻石
		local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0">%s</T><I Z="0.6">ui/common/common_icon_zuanshi.png</I>]]
		ftbTitle:setShowText(string.format(strFormat,LocalStrings.ACTIVITY_TOTAL_RECHARGE,self.m_data.tips.."/"..self.m_data.target))
	elseif self.m_data.rewardId == 7 or self.m_data.rewardId == 8 then --累计购买礼包
		local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0">%s</T>]]
		ftbTitle:setShowText(string.format(strFormat,LocalStrings.CUMULATIVE_PURCHASE_PACKAGE,self.m_data.tips.."/"..self.m_data.target))
	elseif self.m_data.rewardId == 9 then --累计消耗钻石
		local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0">%s</T>]]
		ftbTitle:setShowText(string.format(strFormat,LocalStrings.CUMULATIVE_CONSUMPTION_DIAMONDS,self.m_data.tips.."/"..self.m_data.target))
	elseif self.m_data.rewardId == 10 then --累计完成排位战斗胜利
		local strFormat = [[<T C="127,70,26" S="20" P="0">%s</T><T C="229,105,22" S="20" P="0">%s</T>]]
		ftbTitle:setShowText(string.format(strFormat,LocalStrings.CUMULATIVE_VICTORY_BATTLE,self.m_data.tips.."/"..self.m_data.target))
	end

	for i=1,#self.m_data.item do
        local conItem = GetElement(self.m_root,"ConItem_"..i,WZUIContainer)

	    local celElement,tLuaObj = CellGoodItem:createElement()
        tLuaObj:setCellGoodLocalId(self.m_data.item[i].id,self.m_data.item[i].num,17)
        tLuaObj:setItemClickFun(self, self.onClickItem)
        conItem:addChild(celElement)
	end

end

--@brief	点击宝箱
function CellWeekendLimitedItem:onClickItem(luaTable,tag,tData)
    CellWeekendLimitedPanel:addTips(luaTable,tag,tData)
end

function CellWeekendLimitedItem:onClickGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nActivityType and self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_WEEKEND_LIMITED_NEW then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.activityId, self.m_nTaskRewardId)
	else
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId, self.m_data.rewardId, 0)
	end
end

function CellWeekendLimitedItem:onClickGoto(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nActivityType and self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_WEEKEND_LIMITED_NEW then 
		local data = self.m_data
		if data and data.script and type(data.script) == "table" and data.script[1][1] > 0 then 
			local mainId = data.script[1][1]
			if mainId == 27 then --公会
	        	SceneCommunity:onJumpToCommunity()
			elseif mainId == 192 and CacheCenter:getPlayerInfo() and CacheCenter:getPlayerInfo().guildId == 0 then --公会副本
				SceneCommunity:onJumpToCommunity()
			elseif mainId > 0 then
				if self.m_nType == 14 then 
					WindowManager:removeWindow(WndActivityIntegrate.m_root, WndActivityIntegrate, true)
				end
				JumpByUIId(mainId)
			end
		else
			WindowManager:removeWindow(WndActivityIntegrate.m_root, WndActivityIntegrate, true)
		end
	else
		if self.m_data.rewardId == 1 then

		elseif self.m_data.rewardId >= 2 and self.m_data.rewardId <= 6 then
			JumpByUIId(116)
		elseif self.m_data.rewardId == 7 or self.m_data.rewardId == 8 then
		    if SceneCity:isLouyixiao() then
		        WndApartmentAct:showInterface()
		    end
		elseif self.m_data.rewardId == 9 then
			JumpByUIId(43)
		elseif self.m_data.rewardId == 10 then
			JumpByUIId(118)
		end
	end
	WindowManager:removeWindow(WndActivityIntegrate.m_root, WndActivityIntegrate, true)
end

function CellWeekendLimitedItem:setTaskItemMessage(data)
	--0=不可领取|1=可领取|2=已领取
	self.m_tTaskItemData = data
	
	GetElement(self.m_root,"btn_DoTask",WZUIButton):setVisible(data.status == 0)
	GetElement(self.m_root,"btn_GetReward",WZUIButton):setVisible(data.status == 1)
	GetElement(self.m_root,"img_get",WZUIImage):setVisible(data.status == 2)
	local txtDescTitle = GetElement(self.m_root,"txtDescTitle_CellWeekendLimitedItem",WZUILabelTTF)
	local ftbTitle = GetElement(self.m_root, "ftbTitle_conItem", WZUIFreeTextBox)
	if string.find(data.desc, "<T") == nil then
		txtDescTitle:setText(data.desc)
	else
		ftbTitle:setShowText(data.desc)
	end

	self.m_nTaskRewardId = data.id
	for i = 1, 5 do --最大5个奖励
		if self.m_tGoodItemCell and self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement then
			self.m_tGoodItemCell[i].celElement:setVisible(false)
		end
	end
	WZLog("CellWeekendLimitedItem:setTaskItemMessage", Serialize(data.ids))
	for i=1, #data.ids do
		local key = "id_"..data.ids[i]
		local tabItem = GDatatab_item[key]
		local num = data.nums[i]
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		if self.m_tGoodItemCell == nil or self.m_tGoodItemCell[i] == nil then
			if self.m_tGoodItemCell == nil then 
				self.m_tGoodItemCell = {}
			end
			local conItem = GetElement(self.m_root,"ConItem_"..i,WZUIContainer)
			local celElement,tLuaObj = CellGoodItem:createElement()
			conItem:addChild(celElement)
			celElement:setScale(0.85)
			local tab = {}
			tab.celElement = celElement
			tab.tLuaObj = tLuaObj
			self.m_tGoodItemCell[i] = tab
		end
		if self.m_tGoodItemCell[i] and self.m_tGoodItemCell[i].celElement and self.m_tGoodItemCell[i].tLuaObj then
			local celElement = self.m_tGoodItemCell[i].celElement
			local tLuaObj = self.m_tGoodItemCell[i].tLuaObj
			tLuaObj:setCellGoodItem(itemInfo, 17)
			tLuaObj:setItemClickFun(self, self.onClickItem)
			celElement:setVisible(true)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
