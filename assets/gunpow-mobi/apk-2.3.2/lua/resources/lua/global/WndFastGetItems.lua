--WndFastGetItems.lua
--@brief	WndFastGetItems的UI模块
--@date		2016/01/21
--@author	qixiang_xie
--@note		快速跳转到相应场景获取相应物品


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFastGetItems:onEnter(element)
	self.m_root = element
	self:initUI()
	self:showItemInfo()
	ProtocolProcessorSingleMap:regAll()
	self:register()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFastGetItems:onExit(element)
	self:_unInit()
	self:unregister()
end

--@brief  关闭当前窗口
function WndFastGetItems:onClikClose(element)
	WZLog("WndFastGetItems:onClikClose")
	g_fastGetItemId = nil
	WindowManager:removeWindow(self.m_root, self, true)
end
--注册监听
function WndFastGetItems:register()
	--一键扫荡结果
	GlobalGame:getBattleEventDispatcher():Add("CLEAR_RESULT_EVENT",self._onClearResult,self)
	GlobalGame:getBattleEventDispatcher():Add("CLEAR_NOT_POWER_EVENT",self._onClearNotPower,self)
	--购买之后的数据变化
	GlobalGame:getBattleEventDispatcher():Add("CLEAR_BUY_RESET_EVENT",self._onClearBuyReset,self)
end
--移除监听
function WndFastGetItems:unregister()
	GlobalGame:getBattleEventDispatcher():Remove("CLEAR_RESULT_EVENT",self._onClearResult,self)
	GlobalGame:getBattleEventDispatcher():Remove("CLEAR_NOT_POWER_EVENT",self._onClearNotPower,self)
	GlobalGame:getBattleEventDispatcher():Remove("CLEAR_BUY_RESET_EVENT",self._onClearBuyReset,self)
end

--@brief  显示物品名字
function WndFastGetItems:showItemName(element)
	element:setText(self.m_itemInfo.name)
end

--@brief  显示物品图片
function WndFastGetItems:showItemIcon(element)
	element:setFile(self.m_itemInfo.icon)
	if self.m_itemInfo.main_type == 25 and self.m_itemInfo.sub_type == 4 then 
		element:setScaleX(0.5)
	elseif self.m_itemInfo.main_type == 9 and self.m_itemInfo.sub_type == 4 then 
		element:setScaleX(0.5)
	end
end

--@brief  显示拥有的数量
function WndFastGetItems:showPossessCount(element)
	element:setText(self.m_nPossessCount .. "/" .. self.m_nNeedCount)
end

--@brief  显示物品信息
function WndFastGetItems:showItemInfo()
	WZLog("WndFastGetItems:showItemInfo")
	if self.m_itemInfo then
		local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
	    self:showItemName(txtItemName)

		local imgItemIcon = GetElement(self.m_root,"imgItemIcon_WndFastGetItems",WZUIImage)
		self:showItemIcon(imgItemIcon)

        local tableHurdlesList = GetElement(self.m_root,"tableHurdlesList_WndFastGetItems",WZUIFreeListContainer)
	    tableHurdlesList:removeAll()
		self:showGetItemHurdles(tableHurdlesList)
	end

	GetElement(self.m_root,"txtItem_WndFastGetItems",WZUILabelTTF):setText("")
	if self.m_itemInfo.id >= 7800 and self.m_itemInfo.id <= 7807 then
		GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtItem_WndFastGetItems",WZUILabelTTF):setText(LocalStrings["EQUIPTYPETIP"..(self.m_itemInfo.sub_type)])
	end
end

--@brief 	将字符串转化为表
function WndFastGetItems:exchangeToTable(channel)
	-- body
	local sTarget = SplitStringWithSeparator(channel,"&")
	local nStart, nEnd = string.find(channel, ",")
	local tTempChannel = {}
	
	if #sTarget == 1 and nStart == nil  then
		local tItem = {}
		tItem[1] = 4
		tItem[2] = sTarget[1]
		table.insert(tTempChannel, tItem)
	else
		for i,v in ipairs(sTarget) do
			local tTempItem = SplitStringWithSeparator(v, ",")
			if #tTempItem == 2 then
				local tItem = {}
				tItem[1] = tonumber(tTempItem[1])
				tItem[2] = tonumber(tTempItem[2]) or tTempItem[2]
				table.insert(tTempChannel, tItem)
			elseif #tTempItem == 3 then
				local tItem = {}
				tItem[1] = tonumber(tTempItem[1])
				tItem[2] = tonumber(tTempItem[2]) or tTempItem[2]
				tItem[3] = tonumber(tTempItem[3]) or tTempItem[3]
				table.insert(tTempChannel, tItem)
			end
		end
	end

	return tTempChannel
end
--@brief  展示可以获取到物品的关卡信息
function WndFastGetItems:showGetItemHurdles(tableElement)
	WZLog("WndFastGetItems:showGetItemHurdle=",self.m_itemInfo.channel)
	local channel = self.m_itemInfo.channel
	
	local temp = self:exchangeToTable(channel)
	
	self.m_tTempTable = {}
	
	local isAllClearCount = 0 --判断是否还有可扫荡次数(全部可扫荡的情况下)
	local isPartClearCount = 0 --存在一些可以扫荡一些不可以扫荡的情况下进行重置
	if temp ~= nil and  #temp > 0 then
		tableElement:setVisible(true)
	    for i,v in ipairs(temp) do
	    	if v[1] == 1 then  --单人副本
	            local nChallengeCount = CopyManager:findSCopyChallengeN(v[2])
	            if nChallengeCount == nil then nChallengeCount = 0 end
	    		table.insert(v,nChallengeCount)
	    	else
	    		table.insert(v,0)
	    	end
	    	table.insert(self.m_tTempTable,v)
	    end
	    
	    table.sort(self.m_tTempTable,function (a,b)
	    	if a[3] < 3 and b[3] == 3 then
	    		return true
	    	end
	    	return false
	    end)


	    table.sort(self.m_tTempTable,function (a,b)
	    	if a[3] == 3 and b[3] == 3 then
	    		if type(a[2]) ~= "string" and type(b[2]) ~= "string" and  a[2] < b[2] then
	    			return true
	    		end
	    	elseif a[3] ~= 3 and b[3] ~=  3 then
	    		if type(a[2]) ~= "string" and type(b[2]) ~= "string" then
	    			if a[2] < b[2]  then
	    				return true
	    			end
	    		end
	    	end
	    	return false
	    end)
	    WZLog("WndFastGetItems:showGetItemHurdle = ",Serialize(self.m_tTempTable))
	    for i,v in ipairs(self.m_tTempTable) do
	    	local cellFastJump =WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump"))
	    	cellFastJump:setVisible(true)
	    	cellFastJump:setTag(i-1)
	    	
	    	cellFastJump:setRelativeSize(GlobalMethod:CCSize(1,90/274))
	    	local txtChaptersName = GetElement(cellFastJump,"txtChaptersName_WndFastGetItems",WZUILabelTTF)
	    	local txtChaptersDesc = GetElement(cellFastJump,"txtChaptersDesc_WndFastGetItems",WZUILabelTTF)
	    	local txtInterfaceName = GetElement(cellFastJump,"txtInterfaceName_WndFastGetItems",WZUILabelTTF)
	    	local imgTag = GetElement(cellFastJump,"imgTag_WndFastGetItem",WZUIImage)
	    	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "ug" then
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersName:setScale(0.7)
	    		txtChaptersDesc:setScale(0.62)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    		txtInterfaceName:setScale(0.7)
	    		txtInterfaceName:setDimensions(GlobalMethod:CCSize(340))
	    	elseif ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "vn" then
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersName:setScale(0.75)
	    		txtChaptersDesc:setScale(0.75)
	    		txtInterfaceName:setScale(0.75)
	    	elseif ProjConfig.LANGUAGE == "pt" then
	    		txtChaptersName:setScale(0.68)
	    		txtChaptersDesc:setScale(0.62)
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    		txtInterfaceName:setScale(0.68)
	    		txtInterfaceName:setDimensions(GlobalMethod:CCSize(340))
	    	elseif ProjConfig.LANGUAGE == "es" then
	    		txtChaptersName:setScale(0.6)
	    		txtChaptersName:setDimensions(GlobalMethod:CCSize(400))
	    		txtChaptersDesc:setScale(0.6)
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    		txtInterfaceName:setScale(0.6)
	    		txtInterfaceName:setDimensions(GlobalMethod:CCSize(400))
	    	elseif ProjConfig.LANGUAGE == "tr" then	    		
	    		txtInterfaceName:setScale(0.6)
	    		txtInterfaceName:setDimensions(GlobalMethod:CCSize(320))
	    		txtChaptersName:setScale(0.7)
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersDesc:setScale(0.62)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    	elseif ProjConfig.LANGUAGE == "hk" then
	    		txtChaptersName:setRelativePosition(GlobalMethod:ccp(0.03,0.763043))
	    		txtChaptersDesc:setMaxLength(0)
	    		txtChaptersDesc:setScale(0.7)
	    		txtChaptersDesc:setDimensions(GlobalMethod:CCSize(400))
	    		txtChaptersDesc:setRelativePosition(GlobalMethod:ccp(0.02,0.33))
	    		imgTag:setRelativePosition(GlobalMethod:ccp(0.9,0.5))
	    	end
	    	local itemInfo = nil
	    	imgTag:setFile("")
	    	if v[1] ~= 4 then
	    		imgTag:setFile("ui/common/common_icon_go.png")
	    	end
	    	if v[1] == 1 then  --单人副本
	    		itemInfo = GDatatab_single_map["id_"..v[2]]
	    		local section_name = itemInfo.section_name
	            if itemInfo.map_type == 1 then
	            	section_name = section_name  .. " " .. LocalStrings.NORMAL
	            elseif itemInfo.map_type == 2 then
	            	section_name = section_name  .. " " .. LocalStrings.PICK 
	            end

	            local nChallengeCount = v[3]
	            local nEnabledChallengeCount = itemInfo.pass_times

                if nChallengeCount == nil then nChallengeCount = 0 end
                nChallengeCount = nEnabledChallengeCount - nChallengeCount
                isAllClearCount = nChallengeCount + isAllClearCount

                local temp_section_name = section_name --用于保存数据的（现在是一键扫荡）hyx
                section_name = section_name .. "(" .. nChallengeCount .. "/" .. nEnabledChallengeCount .. ")"

                --存储板块信息
                local tab = {}
                tab.desc = txtChaptersName --面板
                tab.section_name = temp_section_name --字体
                tab.totle = nEnabledChallengeCount --总数
                tab.challengeCount = nChallengeCount --剩余次数
                tab.level_id = v[2] --关卡id
                

	    		txtChaptersName:setText(section_name)

	    		local nStarNum = WndSingleCopy:getStarNumById(v[2])
				--是否通关可以扫荡
				local str = ""
				local is_clear = (nStarNum < 3)
				if is_clear == true then
					str = LocalStrings.CLEAR_RESULT1
				else
					isPartClearCount = nChallengeCount + isPartClearCount
				end
				-- tab.clear_label = str
				self.m_sCellChaptersName[i] = tab
	    		txtChaptersDesc:setText(itemInfo.map_name..str)
	    		tableElement:pushBack(cellFastJump)
	    	elseif v[1] == 2 then  --组队副本
	    		itemInfo = GDatatab_team_map["id_"..v[2]]
	    		txtChaptersName:setText(itemInfo.map_name)
	    		txtChaptersDesc:setText(itemInfo.map_desc)
	    		tableElement:pushBack(cellFastJump)
	    	elseif v[1] == 3 then
	    		local interfaceNaem = GDatatab_interface["id_" .. v[2] ]
	    		txtInterfaceName:setText(interfaceNaem.name)
	    		if tonumber(v[2]) == 200 then
	    			txtInterfaceName:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	    			txtInterfaceName:setRelativePosition(GlobalMethod:ccp(0.5, 0.7))
	    			txtChaptersName:setText(string.format(LocalStrings.SECTION_WORD, v[3]))
	    			txtChaptersName:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	    			txtChaptersName:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
	    		end
	    		if interfaceNaem.id == 182 or interfaceNaem.id == 183 or interfaceNaem.id == 184 or interfaceNaem.id == 43 then
	    			imgTag:setFile("ui/common/common_icon_buy.png") --商城购买
	    		end
	    		tableElement:pushBack(cellFastJump)
	    	elseif v[1] == 4 then
	    		local cellFastJump2 = WZUIContainer:luaTo(WZUISystem:getInstance():createElement("CellFastJump2"))
		    	cellFastJump2:setVisible(true)
		    	cellFastJump2:setTag(i-1)
		    	cellFastJump2:setRelativeSize(GlobalMethod:CCSize(1,90/274))
		    	local txtInterfaceName = GetElement(cellFastJump2,"txtInterfaceName_WndFastGetItems",WZUILabelTTF)
				txtInterfaceName:setText(v[2])

				tableElement:pushBack(cellFastJump2)
				if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" then
					txtInterfaceName:setDimensions(GlobalMethod:CCSize(320))
		    	end
			elseif v[1] == 5 then
				tableElement:pushBack(cellFastJump)
				local itemInfo = GDatatab_item["id_" .. v[2]]
			    temp = LocalStrings.USE .. itemInfo.name
			    txtInterfaceName:setText(temp)
	    	end
	    end
	else
		tableElement:setVisible(false)
		if channel ~= nil and type(channel) == "string" then
			local txtGetItemDescribe = GetElement(self.m_root,"txtGetItemDescribe_WndFastGetItems",WZUILabelTTF)
		    txtGetItemDescribe:setText(channel)
		end
	end
	--是否存在副本可以扫荡
	self.m_nTableClearMopup = {}
	for i,v in pairs(self.m_tTempTable) do
		if v and v[1] == 1 then --单人副本
			local tab = {}
			tab.id = v[2]

			local challengeCount = v[3]
			local itemInfo = GDatatab_single_map["id_"..v[2]]
	        local totleCount = itemInfo.pass_times
			if challengeCount == nil then challengeCount = 0 end

			tab.count = totleCount - challengeCount--存在次数
			local nStarNum = WndSingleCopy:getStarNumById(v[2])
			tab.is_clear = (nStarNum >= 3) --是否通关可以扫荡
			table.insert(self.m_nTableClearMopup, tab)
		end
	end
	local openConfig = GDatatab_button_info["id_169"]
	local openStatus = false
	if openConfig then
		if CacheCenter:getPlayerInfo().level >= openConfig.show_level then
			openStatus = true
		end
	end
	
	self.m_nPartClearCount = isPartClearCount
	WZLog("self.m_nPartClearCount.....: ",self.m_nPartClearCount)
	if next(self.m_nTableClearMopup) ~= nil then
		local status = true
		WZLog("isAllClearCount....: ",isAllClearCount)
		if isAllClearCount == 0 then
			status = false
		end
		self.m_btnClearMopup:setVisible(openStatus and status)

	else
		self.m_btnClearMopup:setVisible(false)
	end

	local minPs= tableElement:getMinPosition()
	tableElement:getMoveElement():setPositionY(minPs.y)
end

function WndFastGetItems:initUI()
	local itemType = self.m_itemInfo.main_type
	local property =self.m_itemInfo.property
	if itemType ~= 4 then
		local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
        txtItemCountS:setText(LocalStrings.NUM1 .. ":")

        local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
		self:showPossessCount(txtItemCountN)
	else
		local propertyName =ATTR_TITLE[property[1][1]]
		local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
        txtItemCountS:setText(propertyName .. ":")

        local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
        txtItemCountN:setText(property[1][2])
	end
	self.m_btnClearMopup = GetElement(self.m_root,"ClearMopup",WZUIButton)
	self.m_btnClearMopup:setVisible(false)
	local txtMopUp = GetElement(self.m_root,"MopUpLabel",WZUILabelTTF)
    txtMopUp:setText(LocalStrings.CLEAR_RESULT)
end
--@brief  是否购买扫荡卷回调
function WndFastGetItems:needMoreSweep(id,nResType)
    WZLog("WndFastGetItems:needMoreSweep")
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndPurchase:showBuyInterface(6,106)      
    end
end
--一键扫荡
function WndFastGetItems:onMopUpClick()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	-- vip等级限制现在写死（策划需求）
	if CacheCenter:getPlayerInfo().vipLevel >= 2 or whetherHaveWelfareCard() then
	    local nButtonId = 180   --功能开放表对应id
	    local tBtnsInfo = GDatatab_button_info["id_"..nButtonId]
	    if CacheCenter:getPlayerInfo().vipLevel < 3 and not whetherHaveWelfareCard() and CacheCenter:getPlayerInfo().level < tBtnsInfo.open_level then
	        MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.WELFARECARD_VIP_TIP, tBtnsInfo.open_level, 3), self, self._gotoEventToVIP, MSGBOXLEVEL_NORMAL, nil)
	        return
	    end
	    if CacheCenter:getPlayerItemCountById(106) <= 0 then
	    	MsgBoxManager:showConfirmCancelBox(LocalStrings.WIPEOUTNUM,self,self.needMoreSweep, nil, nil)
	    	return
	    end
	 	if self.m_nTableClearMopup and next(self.m_nTableClearMopup) ~= nil then
	 		WZLog("开始发送一键扫荡的协议....",Serialize(self.m_nTableClearMopup))
	 		local tab_clear = {}
	 		local tab_reset = {}
	 		local isClearNotChange = nil --是否存在有未扫荡但是可以挑战的
	 		for i,v in pairs(self.m_nTableClearMopup) do
	 			if not isClearNotChange then
		 			if v.count > 0 then
		 				isClearNotChange = true
		 			end
		 		end
		 		if v and v.is_clear == true then
		 			if v.count > 0 then
		 				table.insert(tab_clear, v.id)
		 			else
		 				table.insert(tab_reset, v.id)
		 			end
		 		end
	 		end
	 		if self.m_nPartClearCount == 0 then
	 			WZLog("tab.. 重置的时候 ...: ", #tab_reset, Serialize(tab_reset))
	 			--扫荡每一个副本不会超过4
	 			self.m_nTotleDiamond = 0 --花费的钻石
	 			for i,v in pairs(tab_reset) do
		 			local count = WndSingleCopyInfo:getResertTime(v)
		 			local diamond = self:getVipSingleCopyCost(count)
		 			if count < 4 then
			 			self.m_nTotleDiamond = self.m_nTotleDiamond + diamond
			 		end
			 		WZLog(".....: ",v,count,diamond, self.m_nTotleDiamond)
		 		end
		 		self.m_tResetLevelID = tab_reset
		 		if self.m_nTotleDiamond == 0 then
		 			if isClearNotChange then
		 				MsgBoxManager:showTipBox(LocalStrings.CELAR_RESULT_TEXT1)
		 			else
			 			MsgBoxManager:showTipBox(LocalStrings.CELAR_RESULT_TEXT3)
			 		end
		 		else
		 			MsgBoxManager:showConfirmBox(string.format(LocalStrings.CELAR_RESULT_TEXT2, self.m_nTotleDiamond),self, self.needResetLevel,nil, nil)
		 		end
	 		else
		 		WZLog("tab.. 扫荡的时候...: ",Serialize(tab_clear))
				if next(tab_clear) == nil then
					MsgBoxManager:showTipBox(LocalStrings.CELAR_RESULT_TEXT1)
				else
					ProtocolProcessorSingleMap:send_MAP_StartRaidsBatch(TableToVector(tab_clear, WZLuaVector_int_))
				end
			end
		end
	else 
		MsgBoxManager:showTipBox(LocalStrings.CANSWEEPT)
		return
	end
end
--@brief  是否进行重置回调
function WndFastGetItems:needResetLevel(id,nResType)
    local monNum =  CacheCenter:getPlayerItemCountById(70) 
    WZLog("WndFastGetItems:needResetLevel === ",monNum)
    if monNum >= self.m_nTotleDiamond then
    	self:createLoading()
    	ProtocolProcessorSingleMap:send_MAP_ResetSingleMapBatch(TableToVector(self.m_tResetLevelID, WZLuaVector_int_))
    else
    	MsgBoxManager:showConfirmBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE, self,self.clickSureMoney)
    end
end
--@brief	点击确定充值回调
function WndFastGetItems:clickSureMoney()
	PostPlayerEvent:postEvent(PostPlayerEvent.event_payStep2, Chat_Channel_Guild_Shop)
	PassportSdkManager:gotoPaymentPage()
end

function WndFastGetItems:_onClearBuyReset()
	self:closeLoading()
	WindowManager:removeWindow(self.m_root,WndFastGetItems,true)
	MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)
end

--@brief  获取单人副本重置花费
--@param  resertCount : 重置次数
function WndFastGetItems:getVipSingleCopyCost(resertCount)
	if not self.m_nResetVipData then
		self.m_nResetVipData = {}
	    for k ,v in pairs(GDatatab_vip_restriction) do
	        if v.type == 6 then
	           table.insert(self.m_nResetVipData,v)
	        end
	    end
	end
    for k,v in pairs(self.m_nResetVipData) do
        if v.count == (resertCount+1) then
            return v.cost[1][2]
        end
    end
end

--@brief    前往vip充值
function WndFastGetItems:_gotoEventToVIP( nId, nResType )
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndVip:showWndUI(0)
    end
end

--一键扫荡之后的数据变化 
--pointIds:关数
--raidsNum:扫荡几次
function WndFastGetItems:_onClearChangeData(pointIds, raidsNum)
	if not self.m_tTempTable or next(self.m_tTempTable) == nil then return end
	if not self.m_sCellChaptersName or next(self.m_sCellChaptersName) == nil then return end

 	local number = {}
 	for i,v in ipairs(pointIds) do
 		number[v] = raidsNum[i]
 	end
 	for i,v in ipairs(self.m_sCellChaptersName) do
 		local changeCount = v.challengeCount
 		if number[v.level_id] then
 			changeCount = v.totle - number[v.level_id]
 			if changeCount <= 0 then
 				changeCount = 0
 			end
 		end
 		local item = self.m_sCellChaptersName[i]
		if item then
			item.section_name = item.section_name .. "(" .. changeCount .. "/" .. item.totle .. ")"
			item.desc:setText(item.section_name)
		end
 	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--一键扫荡成功后返回刷新界面
function WndFastGetItems:_onClearResult(pointIds, raidsNum, rewardNum, rewardId, rewardCount)
	WindowManager:removeWindow(self.m_root,WndFastGetItems,true)
	if next(VectorToTable(raidsNum)) ~= nil then
		local pointIds = VectorToTable(pointIds)
		local raidsNum = VectorToTable(raidsNum)
		self:_onClearChangeData(pointIds, raidsNum)

		WndSweepResult:showWindow({
	        pointId = pointIds,
	        raidsNum = raidsNum,
	        rewardNum = VectorToTable(rewardNum),
	        rewardId = VectorToTable(rewardId),
	        rewardCount = VectorToTable(rewardCount),
	    },nil,2)
	end
end
--没有体力值的时候
function WndFastGetItems:_onClearNotPower()
	judgeNotEnoughJump(self, self.needMoreEnergy)
end
--@brief   是否补充活力值回调
function WndFastGetItems:needMoreEnergy(id,nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(1056) 
    end
end
--@brief  跳转到相应场景
function WndFastGetItems:onClickJump(element)
	WZLog("WndFastGetItems:onClickJump")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local parentNode = element:getParent()
	parentNode = WZUIContainer:luaTo(parentNode)
	local tag = parentNode:getTag()
	local channel = self.m_itemInfo.channel
	local temp = self.m_tTempTable
	local hurdlesInfo = temp[tag+1]
	local hurdlesType = hurdlesInfo[1]
	local hurdlesId = hurdlesInfo[2]
	local hurdlesId3 = hurdlesInfo[3]
	local bCanJump= false
	WZLog("hurdlesId = ",hurdlesType,hurdlesId,hurdlesId3)
	
	if hurdlesType == 1 then -- 单人副本
		if CopyManager:bJumpToSingleCopy(hurdlesId) then
			bCanJump = true
			if SceneRoom.m_root ~= nil then
    		    SceneRoom:exitRoom()
    	    end
			SceneCopy:showScene(1, nil, hurdlesId,false)
		end
	elseif hurdlesType == 2 then --组队副本
		if CheckButtonOpen(ISLAND_BUILDING_BOSSMAP) then
			bCanJump = true
			if SceneRoom.m_root ~= nil then
    		    SceneRoom:exitRoom()
    	    end
			SceneCopy:showScene(2, nil, nil,nil)
		end
	elseif hurdlesType == 5 then
		local tempKey = "id_" .. hurdlesId
		local itemInfo = GDatatab_item[tempKey]
		
		if itemInfo ~= nil then
			local itemCount = CacheCenter:getPlayerItemCountById(hurdlesId) 
			if itemInfo.sub_type == 0 or itemInfo.sub_type == 1 or itemInfo.main_type == 2 then
				if itemCount <= 0 then
					MsgBoxManager:showTipBox(LocalStrings.NOT_GOODS_TIP)
					return
				end
		    end
            local name = itemInfo.name
            local path = itemInfo.icon
            local num =  itemCount
            local quality = itemInfo.quality
            local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(itemInfo)}
            
            local wndOpenChest = WndOpenChest:createElement()
		    WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
            WndOpenChest:setData(itemInfo)
            bCanJump = true
        end
        
	elseif hurdlesType == 4 then

	else
	   	if hurdlesId == 182 or hurdlesId == 183 or hurdlesId == 184 or hurdlesId == 186 or hurdlesId == 43 
	   	or hurdlesId == 213 or hurdlesId == 214 or hurdlesId == 215 or hurdlesId == 216 or hurdlesId == 217 
	   	or hurdlesId == 223 or hurdlesId == 224 or hurdlesId == 225 or hurdlesId == 226 then
			WndFastGetItems.m_nShopTipItemId = WndFastGetItems.m_itemInfo.id
			--如果是技能点，换成中级技能书
			if WndFastGetItems.m_nShopTipItemId == 63 then
				WndFastGetItems.m_nShopTipItemId = 551
			end
			local jumpBuyInfo 
			if hurdlesId == 182 then 
				jumpBuyInfo = {4, 1}
			elseif hurdlesId == 183 then 
				jumpBuyInfo = {3, 1}
			elseif hurdlesId == 184 then 
				jumpBuyInfo = {3, 2}
			elseif hurdlesId == 186 then 
				jumpBuyInfo = {3, 3}
			elseif hurdlesId >= 213 and hurdlesId <= 217 then 
				jumpBuyInfo = {2, hurdlesId - 212}
			elseif hurdlesId == 223 then 
				jumpBuyInfo = {3, 4}
			elseif hurdlesId == 224 then 
				jumpBuyInfo = {3, 5}
			elseif hurdlesId == 225 then 
				jumpBuyInfo = {3, 7}
			elseif hurdlesId == 226 then 
				jumpBuyInfo = {3, 6}
			end
			WndPurchase:showBuyInterface(6,WndFastGetItems.m_nShopTipItemId,nil,nil,nil,nil,nil,nil,true, nil, nil, nil, jumpBuyInfo)
		else
			JumpByUIId(hurdlesId,hurdlesId3)
		end
		bCanJump = true
	end
    if bCanJump then
    	WindowManager:removeWindow(self.m_root,WndFastGetItems,true)
		if WndSkillContainer and WndSkillContainer.m_root then
			WindowManager:removeWindow(WndSkillContainer.m_root,WndSkillContainer,true)
		end
		if WndStore and WndStore.m_root then
			if hurdlesId ~= 8 and hurdlesId ~= 39 and hurdlesId ~= 147 and hurdlesId ~= 180 and hurdlesId ~= 209 and hurdlesId ~= 211 and hurdlesId ~= 212 and hurdlesId ~= 228 and hurdlesId ~= 238 and hurdlesId ~= 239 and hurdlesId ~= 287 and hurdlesId ~= 294 then 
				WindowManager:removeWindow(WndStore.m_root , WndStore , true)
			end
		end
    end
end

function WndFastGetItems:_adaptLanguage_vn()
    local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(20)
    local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
    txtItemCountS:setFontSize(19)
    local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
    txtItemCountN:setFontSize(19)
    txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.52,0.366667))

    GetElement(self.m_root,"MopUpLabel",WZUILabelTTF):setScale(0.7)
end

function WndFastGetItems:_adaptLanguage_th()
    WZLog("WndFastGetItems:_adaptLanguage_th ")
    local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
    txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.555291,0.366667))
    local txtItem = GetElement(self.m_root,"txtItem_WndFastGetItems",WZUILabelTTF)
    txtItem:setFontSize(16)
end

function WndFastGetItems:_adaptLanguage_en()
    WZLog("WndFastGetItems:_adaptLanguage_en")
	local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
	txtItemCountS:setScale(0.8)
	local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
	txtItemCountN:setScale(0.8)
	txtItemCountN:setDimensions(GlobalMethod:CCSize(250))
	txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.495,0.366667))
    local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(18)
    txtItemName:setDimensions(GlobalMethod:CCSize(250))

    local txtItem = GetElement(self.m_root,"txtItem_WndFastGetItems",WZUILabelTTF)
    txtItem:setDimensions(GlobalMethod:CCSize(240,0))
end

function WndFastGetItems:_adaptLanguage_pt(  )
	local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
	txtItemCountS:setFontSize(16)
	local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
	txtItemCountN:setFontSize(16)
	txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.497355,0.366667))
	local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(18)
    txtItemName:setDimensions(GlobalMethod:CCSize(250))
end

function WndFastGetItems:_adaptLanguage_tr(  )
	local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
	txtItemCountS:setScale(0.8)
	local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
	txtItemCountN:setScale(0.8)
	txtItemCountN:setDimensions(GlobalMethod:CCSize(250))
	txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.45,0.366667))

	local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(22)

	local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(22)

	local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(22)
end

function WndFastGetItems:_adaptLanguage_es()
	local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
	txtItemCountS:setFontSize(16)
	local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
	txtItemCountN:setFontSize(16)
	txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.497355,0.366667))

    local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setFontSize(18)
    txtItemName:setDimensions(GlobalMethod:CCSize(250))

    GetElement(self.m_root,"txtGetItemDescribe_WndFastGetItems",WZUILabelTTF):setFontSize(18)
end

function WndFastGetItems:_adaptLanguage_ug()
    local txtItemName = GetElement(self.m_root,"txtItemName_WndFastGetItems",WZUILabelTTF)
    txtItemName:setScale(0.8)
    txtItemName:setDimensions(GlobalMethod:CCSize(320))
    txtItemName:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtItemName:setRelativePosition(GlobalMethod:ccp(0.98,0.633333))
    local txtItemCountS = GetElement(self.m_root,"txtItemCountS_WndFastGetItems",WZUILabelTTF)
    txtItemCountS:setScale(0.8)
    txtItemCountS:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtItemCountS:setRelativePosition(GlobalMethod:ccp(0.96,0.335))
    local txtItemCountN = GetElement(self.m_root,"txtItemCountN_WndFastGetItems",WZUILabelTTF)
    txtItemCountN:setScale(0.8)
    txtItemCountN:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtItemCountN:setRelativePosition(GlobalMethod:ccp(0.84,0.335))
end
-------------------------------------私有方法模块End----------------------------------------
