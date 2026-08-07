--WndActivitySpecificSales.lua
--@brief	WndActivitySpecificSales的UI模块
--@date		2023/05/30
--@author	nijinlin
--@note		限定活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndActivitySpecificSales:onEnter(element)
	-- WZResourceManager:getInstance():executeLuaFile("LocalData.lua")
	-- WZResourceManager:getInstance():executeLuaFile("LocalData2.lua")
	--WZResourceManager:getInstance():executeLuaFile("LocalStrings.lua")
	--WZResourceManager:getInstance():executeLuaFile("LocalData6.lua")
	--WZResourceManager:getInstance():executeLuaFile("protocol/ProtocolProcessorFestivalActivity.lua")
	WZLog("WndActivitySpecificSales:onEnter")
	self.m_root = element
	--充值消耗以及获取状态
	self.m_vnNums = {}
	--子元素集合
	self.m_tCellList = {}
	self.m_nTag = 1
	--当前选中的子元素索引
	self.m_nTagItemSelect = 1
	self:register()
	
	self:onClickTab(1)
	if g_cityExtenInfo then
		self:_createLoading()
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7080, 7080)
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7080, 1, "")
	end
	--[[
		txtPet1_WndActivitySpecificSales
		txtPet2_WndActivitySpecificSales
		txtPet3_WndActivitySpecificSales
		txtEquip1_WndActivitySpecificSales
		txtEquip2_WndActivitySpecificSales
		txtEquipStatus1_WndActivitySpecificSales
		txtEquipStatus2_WndActivitySpecificSales
		txtEquipStatus3_WndActivitySpecificSales
		txtEquipStatus4_WndActivitySpecificSales
		freetxt1_WndActivitySpecificSales
		btnGet_WndActivitySpecificSales
		conLeft_WndActivitySpecificSales
		tableConGoods_WndActivitySpecificSales
		btnPet_WndActivitySpecificSales
		btnEquip_WndActivitySpecificSales
		txtBtnEquip_WndActivitySpecificSales
		txtBtnPet_WndActivitySpecificSales
		haveGet_WndActivitySpecificSales
		tableSpe_WndActivitySpecificSales
	]]

	self:_initStaticText()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndActivitySpecificSales:onExit(element)
	self:_unInit()
	self:unregister()
	LoadNewActivityRes(false)
end
function WndActivitySpecificSales:register()
	Protocol:reg( Protocol.MAIN_ACTIVITY, Protocol.ACTIVITY_GetActivityListInfoOK, "ProtocolProcessorWndActivityOnLine:parse_ACTIVITY_GetActivityListInfoOK", "vivsviviivivivivsvivsvii")
	Protocol:reg( Protocol.MAIN_ACTIVITY2, Protocol.ACTIVITY2_ActivityDoOk, "ProtocolProcessorFestivalActivity:parse_ACTIVITY2_ActivityDoOk", "iiiis")
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGet108Result,self)
end
function WndActivitySpecificSales:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGet108Result,self)
end

--@brief	初始化静态文本
function WndActivitySpecificSales:_initStaticText()
	-- GetElement(self.m_root,"txtEquipGem1_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.ATTACK_STONE_1)
	-- GetElement(self.m_root,"txtEquipGem2_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.DEFENSE_STONE_1)
	-- GetElement(self.m_root,"txtEquipGem3_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.HP_STONE)
	-- GetElement(self.m_root,"txtEquipGem4_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.NEWSTONE2)
	GetElement(self.m_root,"txtEquipStatus1_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.UNMOUNTED)
	GetElement(self.m_root,"txtEquipStatus2_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.UNMOUNTED)
	GetElement(self.m_root,"txtEquipStatus3_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.UNMOUNTED)
	GetElement(self.m_root,"txtEquipStatus4_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.UNMOUNTED)
	-- GetElement(self.m_root,"txtPet3_WndActivitySpecificSales",WZUILabelTTF):setText(LocalStrings.PET_1..":")
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    点击关闭按钮回调
function WndActivitySpecificSales:onClose(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManagerAni:createDisappearAction(self.m_root, "closeCallBack", self)
end

--@brief    关闭动画完成后回调
function WndActivitySpecificSales:closeCallBack()
	-- body
	WindowManager:removeWindow(self.m_root, self, true)
end

--点击规则按钮
function WndActivitySpecificSales:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local conRule = GetElement(self.m_root,"conRule_WndActivitySpecificSales", WZUIContainer)
	if conRule then
		conRule:setVisible(true)
	end
end

--点击规则关闭按钮
function WndActivitySpecificSales:onClickRuleClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local conRule = GetElement(self.m_root,"conRule_WndActivitySpecificSales", WZUIContainer)
	if conRule then
		conRule:setVisible(false)
	end
end

--点击标签栏
function WndActivitySpecificSales:onClickTab(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag
	if type(element) == "number" then
		tag = element
	else
		tag = element:getTag()
	end
	WZLog("WndActivitySpecificSales:onClickTab", tag)

	self.m_nTag = tag
	self.m_nTagItemSelect = 1
	local btnEquip = GetElement(self.m_root,"btnEquip_WndActivitySpecificSales", WZUIButton)
	local btnPet = GetElement(self.m_root,"btnPet_WndActivitySpecificSales", WZUIButton)
	local conEquip = GetElement(self.m_root,"conEquip_WndActivitySpecificSales", WZUIContainer)
	local conPet = GetElement(self.m_root,"conPet_WndActivitySpecificSales", WZUIContainer)
	
	if btnEquip and btnPet then
		local normal_1 = GetElement(btnEquip,"normal", WZUIImage)
		local select_1 = GetElement(btnEquip,"select", WZUIImage)
		local name_1 = GetElement(btnEquip,"name", WZUILabelTTF)
		local normal_2 = GetElement(btnPet,"normal", WZUIImage)
		local select_2 = GetElement(btnPet,"select", WZUIImage)
		local name_2 = GetElement(btnPet,"name", WZUILabelTTF)
		if normal_1 and select_1 and name_1 and normal_2 and select_2 and name_2 then
			name_1:setText(LocalStrings.SPECIFICSALES_TEXT1[2])
			name_2:setText(LocalStrings.SPECIFICSALES_TEXT1[3])
			if tag == 1 then
				--武器
				select_1:setVisible(true)
				select_2:setVisible(false)
				conEquip:setVisible(true)
				conPet:setVisible(false)
			else
				--宠物
				select_1:setVisible(false)
				select_2:setVisible(true)
				conEquip:setVisible(false)
				conPet:setVisible(true)
			end
		end
	end
	self:updateTableContainer()
end

--点击获取按钮
function WndActivitySpecificSales:onClickGet(element)
	WZLog("WndActivitySpecificSales::onClickGet()")	
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--已领取过弹框确认是否继续领取
	if self.m_nOwnFlag < 0 then
		self:onClickIsGetSure()
	else
		MsgBoxManager:showConfirmCancelBox(LocalStrings.SPECIFICSALES_TEXT1[7] or "", self, self.onClickIsGet, nil)
	end
end

function WndActivitySpecificSales:onClickIsGet(nId, nResType)
	WZLog("WndActivitySpecificSales::onClickGet()", nId, nResType)	
	if nResType == MSGBOXRESTYPE_CONFIRM then
		self:onClickIsGetSure()
	end
end

function WndActivitySpecificSales:onClickIsGetSure()
	WZLog("WndActivitySpecificSales::onClickIsGetSure()")	
	local data = {}
	data["rewardType"] = self.m_nTag - 1
	data["rewardId"] = self.m_nTagItemSelect - 1
	data = json.encode(data)
	WZLog("WndActivitySpecificSales::onClickIsGetSure()", data)
	if g_cityExtenInfo and g_cityExtenInfo.activity7080 then
		self:_createLoading()
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7080, 2, data)
	end
end

--点击获取按钮
function WndActivitySpecificSales:onClickNotGet(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndActivitySpecificSales::onClickNotGet()")	
	WndNewVip:showInterface(1)
	--WindowManager:removeWindow(WndMidFestivalActivity.m_root, WndMidFestivalActivity, true)
end

--@brief	Item点击回调
function WndActivitySpecificSales:onItemClick(luaTable,tag,tData)	
	WZLog("WndActivitySpecificSales::onItemClick()", tag)
	--WZLog("WndActivitySpecificSales::onItemClick() 11111", tag, Serialize(tData.basicInfo))
	if not self.m_sContent or not self.m_vnNums then
		return
	end
	-- --[[
	-- 	content:
	-- 		{
	-- 			weaponRewards	: '武器配置奖励 [\[男物品id,女物品id,数量]&[]\,\[男物品id,女物品id,数量]&[]\]',
	-- 			weaponConfig	: '武器目标进度 int[[充值,消耗],..]',
	-- 			petRewards	: '宠物配置奖励 [\[男物品id,女物品id,数量]&[]\,\[男物品id,女物品id,数量]&[]\]',
	-- 			petConfig	: '宠物目标进度 int[[充值,消耗],..]'
	-- 		}
	-- 	status:
	-- 		{
	-- 			day	: int周年庆签到第几天,
	-- 			weaponStatus	: int[]武器领取状态 ：-1=不可领取,0=,可领取,1=,已领取,
	-- 			petStatus	: int[]宠物领取状态 ：-1=不可领取,0=,可领取,1=,已领取,
	-- 			rechargeNum	: int充值钻石数量,
	-- 			costNum	: int今日消耗钻石数量
	-- 		}

	-- ]]
	self.m_nTagItemSelect = tag + 1
	--设置高亮选择
	if self.m_tCellList and #(self.m_tCellList) >= self.m_nTagItemSelect then
		for i=1,#(self.m_tCellList) do
			tCell = self.m_tCellList[i]
			if tCell then
				tCell:setHighLight(false)
			end
		end
		self.m_tCellList[self.m_nTagItemSelect]:setHighLight(true)
	end


	self:updateMainUI(tData)	
end

--点击获取按钮
function WndActivitySpecificSales:updateStatus(tResult, doType)
	WZLog("WndActivitySpecificSales::updateStatus()")
	if not tResult then
		return
	end
	WZLog("WndActivitySpecificSales::updateStatus() doType", doType)
	WZLog("WndActivitySpecificSales::updateStatus()", Serialize(tResult))
	--{"costNum":171,"weaponStatus":[1,1,1,0],"petStatus":[0,0,0,0,0],"rechargeNum":120,"weaponOwn":[0,0,0,0],"petOwn":[0,0,0,0]}
	local costNum = tResult["costNum"]
	local weaponStatus = tResult["weaponStatus"]
	local petStatus = tResult["petStatus"]
	local rechargeNum = tResult["rechargeNum"]
	local weaponOwn = tResult["weaponOwn"]
	local petOwn = tResult["petOwn"]
	self.m_vnNums = {}
	self.m_vnNums["costNum"] = costNum
	self.m_vnNums["rechargeNum"] = rechargeNum
	self.m_vnNums["weaponStatus"] = weaponStatus
	self.m_vnNums["petStatus"] = petStatus
	self.m_vnNums["weaponOwn"] = weaponOwn
	self.m_vnNums["petOwn"] = petOwn

	-- if doType == 1 then
		WZLog("WndActivitySpecificSales::updateUI() updateTableContainer self.m_tCellList")
		local itemTag = self.m_nTagItemSelect or 1
		if self.m_tCellList and #(self.m_tCellList) >= itemTag and self.m_tCellList[itemTag] then
			WZLog("WndActivitySpecificSales::updateUI() updateTableContainer self.m_tCellList:onBackClick()")
			self.m_tCellList[itemTag]:onBackClick()
			--self.m_tCellList[itemTag]:setHighLight(true)
		end
	-- elseif doType == 2 then
	-- 	self:updateMainUI()
	-- end
end

--更新右边面板内容
function WndActivitySpecificSales:updateMainUI(tData)
	WZLog("WndActivitySpecificSales::updateMainUI()")
	--初始化左侧容器
	--设置展示容器物品
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	if conLeft then				
		--conLeft:setScale(1.5)	
		conLeft:disableSchedule()
		--conLeft:setAnchorPoint(GlobalMethod:ccp(0.5,0))
		--conLeft:setRelativePosition(GlobalMethod:ccp(0.4,0.2))
		conLeft:setTouchEnable(false)
		conLeft:removeAllChildrenWithCleanup(true)
		local tElement,tCell = CellGoodItem:createElement()
	--     --tCell:setItemClickFun(self,self.onWeaponClicked)
		if tElement ~= nil and tCell ~= nil then
			conLeft:addChild(tElement)
	--         --tElement:setScale(0.9)
			local goodsData = CopyTable(tData)
			tCell:setCellGoodItem(goodsData,15)
			GetElement(tElement, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
			GetElement(tElement, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
			GetElement(tElement, "btnImg1_CellGoodItem", WZUI9Image):setVisible(false)
			GetElement(tElement, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
		end
	end
	if not self.m_sContent or not self.m_vnNums or not self.m_vnNums["costNum"] then
		return
	end

	--设置标题栏活动时间
	local txtActivityTime = GetElement(self.m_root,"txtActivityTime_WndActivitySpecificSales", WZUILabelTTF)
	if self.m_nStartTime and self.m_nEndTime and txtActivityTime then
		local start_time = SystemTime:getTimeConverLocal6(self.m_nStartTime)
		local end_time = SystemTime:getTimeConverLocal6(self.m_nEndTime)
		WZLog("WndActivitySpecificSales::updateMainUI() 1", start_time, end_time)
		txtActivityTime:setText(""..start_time.."-"..end_time)
	end

	--规则描述
	local txtDescRule = GetElement(self.m_root,"txtDescRule_WndActivitySpecificSales", WZUILabelTTF)
	if txtDescRule then
		txtDescRule:setText(LocalStrings.SPECIFICSALES_TEXT1[5])
	end

	--8888/8888 充值消耗进度数组
	local nums = {}
	local content = json.decode(self.m_sContent)
	--奖励、充值消耗目标配置
	local rewards, config
	--是否可领取状态
	local status = -1
	--是否已领取过该索引的物品标记
	local ownFlag = -1
	if self.m_nTag == 1 then
		rewards = content["weaponRewards"]
		if type(rewards) == "string" then
			rewards = json.decode(rewards)
		end		
		config = content["weaponConfig"]
		if type(config) == "string" then
			config = json.decode(config)
		end			
		if self.m_vnNums["weaponStatus"] then
			status = tonumber(self.m_vnNums["weaponStatus"][self.m_nTagItemSelect])
		end	
		if self.m_vnNums["weaponOwn"] then
			ownFlag = tonumber(self.m_vnNums["weaponOwn"][self.m_nTagItemSelect])
		end
	else
		rewards = content["petRewards"]
		if type(rewards) == "string" then
			rewards = json.decode(rewards)
		end		
		config = content["petConfig"]
		if type(config) == "string" then
			config = json.decode(config)
		end		
		if self.m_vnNums["petStatus"] then
			status = tonumber(self.m_vnNums["petStatus"][self.m_nTagItemSelect])
		end
		if self.m_vnNums["petOwn"] then
			ownFlag = tonumber(self.m_vnNums["petOwn"][self.m_nTagItemSelect])
		end
	end

	--是否已领取过该索引的物品标记
	self.m_nOwnFlag = ownFlag

	if self.m_vnNums["rechargeNum"] then
		nums[1] = self.m_vnNums["rechargeNum"]
	end
	if self.m_vnNums["costNum"] then
		nums[3] = self.m_vnNums["costNum"]
	end
	if config and config[self.m_nTagItemSelect] then
		nums[2] = config[self.m_nTagItemSelect][1]
		nums[4] = config[self.m_nTagItemSelect][2]
	end

	WZLog("WndActivitySpecificSales::updateMainUI() nums = ", Serialize(nums))
	if #nums >= 4 then
		local activityType = 7080
		--local taskData = GDatatab_new_activity_task["id_"..activityType.."01"]
		local freetxt1 = GetElement(self.m_root,"freetxt1_WndActivitySpecificSales", WZUIFreeTextBox)
		--WZLog("WndActivitySpecificSales:updateMainUI", Serialize(taskData))
		if freetxt1 then
			freetxt1:setMaxWidth(250)
			-- taskData.param1 = 9
			local str1 = nums[1].."/"..nums[2]
			local str2 = nums[3].."/"..nums[4]			
			--freetxt1:setShowText(string.format(taskData.desc, str1, str2))
			freetxt1:setShowText(string.format(LocalStrings.SPECIFICSALES_TEXT1[6], str1, str2))
		end
	end

	--设置获取按钮的状态
	-- -1:不可领取 0：可领取 1：已领取
	--status = 0
	local btnGet = GetElement(self.m_root,"btnGet_WndActivitySpecificSales", WZUIButton)
	local btnNotGet = GetElement(self.m_root,"btnNotGet_WndActivitySpecificSales", WZUIButton)
	local haveGet = GetElement(self.m_root,"haveGet_WndActivitySpecificSales", WZUIImage)
	if btnGet and btnNotGet and haveGet then
		btnGet:setVisible(false)
		btnNotGet:setVisible(false)		
		if status == -1 then
			btnGet:setVisible(true)
			btnGet:setTouchEnable(false)
			btnNotGet:setVisible(true)	
			btnNotGet:setTouchEnable(true)	
			haveGet:setVisible(false)
		elseif status == 0 then
			btnGet:setVisible(true)
			btnGet:setTouchEnable(true)
			btnNotGet:setVisible(false)	
			--btnNotGet:setTouchEnable(false)
			haveGet:setVisible(false)
		else
			btnGet:setVisible(false)
			btnNotGet:setVisible(false)
			haveGet:setVisible(true)
		end
	end

	local conPet = GetElement(self.m_root,"conPet_WndActivitySpecificSales", WZUIContainer)
	local conEquip = GetElement(self.m_root,"conEquip_WndActivitySpecificSales", WZUIContainer)
	local txtTitle = GetElement(self.m_root,"txtTitle_WndActivitySpecificSales", WZUILabelTTF)
	local txtDesc = GetElement(self.m_root,"txtDesc_WndActivitySpecificSales", WZUILabelTTF)
	txtTitle:setText("")
	txtDesc:setText("")
	--右面板信息更新
	if not tData or not tData.basicInfo or not conEquip or not conPet then 
		return
	end
	conPet:setVisible(false)
	conEquip:setVisible(false)
	self.m_tEquip = tData--CopyTable(tData)
	local property_items = self:_getPropertyData()--self:_getItemExplain()--self:_getPropertyData()

	local name = tData.basicInfo.name
	if txtTitle then		
		txtTitle:setText(name)
	end	

	local desc = tData.basicInfo.desc
	if txtDesc then		
		txtDesc:setText(desc)
	end	

	--自选礼包列表默认隐藏
	local tableSpe = GetElement(self.m_root,"tableSpe_WndActivitySpecificSales",WZUITableContainer)
	--tableSpe:setLoadCountPerFrame(4)
	if tableSpe then
		tableSpe:cleanTable()
		tableSpe:setVisible(false)
	end

	if not property_items and not (tData.basicInfo.main_type == 3 or tData.basicInfo.main_type == 2 and tData.basicInfo.sub_type == 11) then
		WZLog("WndActivitySpecificSales::updateMainUI() property_item nil")
		return
	end
	WZLog("WndActivitySpecificSales::updateMainUI() tData.id = ", tData.basicInfo.id)
	--WZLog("WndActivitySpecificSales::updateMainUI() #property_item = ", property_items and #property_items or 0)
	--WZLog("WndActivitySpecificSales::updateMainUI() property_item = ", Serialize(VectorToTable(property_items)))
	local property = tData.basicInfo.property
	if not property then
		WZLog("WndActivitySpecificSales::updateMainUI() property nil")
		conPet:setVisible(false)
		conEquip:setVisible(false)
		return
	end
	WZLog("WndActivitySpecificSales::updateMainUI() property = ", Serialize(property))

	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
		return
	end

	local tDataCopy = CopyTable(tData)
	if self.m_tEquip.basicInfo.main_type == 9 then --碎片
		local basicInfo = GDatatab_item["id_"..GDatatab_itemmerge["id_"..self.m_tEquip.basicInfo.id].items[1][1]]
		tDataCopy.basicInfo = CopyTable(basicInfo)
		local tempData = GDatatab_item["id_"..self.m_tEquip.basicInfo.id]
		tDataCopy.basicInfo.name = tempData.name
		tDataCopy.basicInfo.desc = tempData.desc
	end

	if tDataCopy.basicInfo.main_type == 10 then--宠物
		self:setPetUI(tDataCopy, property_items)
	elseif tDataCopy.basicInfo.main_type == 3 then--自选礼包(展示物品格子列表)
		self:setSpecificGiftsUI(tDataCopy, property_items)
	elseif tDataCopy.basicInfo.main_type == 11 or tDataCopy.basicInfo.main_type == 2 and tDataCopy.basicInfo.sub_type == 11 then --坐骑
		self:setMountUI(tDataCopy, property_items)
	elseif tDataCopy.basicInfo.main_type == 20 then --皮肤
		self:setSkinUI(tDataCopy, property_items)
	elseif tDataCopy.basicInfo.main_type == 23 then --足迹
		self:setFootUI(tDataCopy, property_items)
	elseif tDataCopy.basicInfo.main_type == 25 and tDataCopy.basicInfo.sub_type == 3 then --背景卡
		self:setBgCardUI(tDataCopy, property_items)
	elseif tDataCopy.basicInfo.main_type == 14 and tDataCopy.basicInfo.sub_type == 16 then --称号
		self:setTitleUI(tDataCopy, property_items)
	elseif tDataCopy.basicInfo.main_type == 50 then --度假村建筑
		self:setHVBuildUI(tDataCopy, property_items)
	else
		self:setEquipUI(tDataCopy, property_items)
	end
end

-- 设置度假村建筑界面
function WndActivitySpecificSales:setHVBuildUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setHVBuildUI()")
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	conLeft:disableSchedule()
	conLeft:setTouchEnable(false)
	conLeft:removeAllChildrenWithCleanup(true)

	local nCurTime = SystemTime:getServerTime()
	local dayCur = os.date("*t", nCurTime)
	local nSceneState = 0 
	if tonumber(dayCur.hour) >= 17 or tonumber(dayCur.hour) <= 6 then 
		nSceneState = 1
	end

	if tData.basicInfo.animation_index_code ~= -1 then
		local ptCon = GlobalMethod:ccp(0.5,0.5)
		local nConfigid = 0
		local nScale = 1
		if tData.basicInfo.main_type == 50 then
			if tData.basicInfo.sub_type == 3 then
				nConfigid = 22
				nScale = 0.7
			elseif tData.basicInfo.sub_type == 4 then
				nConfigid = 25
				nScale = 1
			end
		end

		local conHvBuild = WZUIContainer:create()
		conHvBuild:setRelativePosition(GlobalMethod:ccp(0.5,0.25))
		conHvBuild:setScale(nScale)
		conLeft:addChild(conHvBuild)
		for i, value in pairs(GDatatab_holiday_position) do
			if value.configid == nConfigid then
				local nConWidth = (value.buildingsize[1][1] + value.buildingsize[1][2]) * 0.5 * HVMAP_SIZEX
				local nConHeight = (value.buildingsize[1][1] + value.buildingsize[1][2]) * 0.5 * HVMAP_SIZEY
				conHvBuild:setUseAbsSize(true)
				conHvBuild:setAbsContentSize(GlobalMethod:CCSize(nConWidth, nConHeight))
				conHvBuild:updateRelativeSize()
			end
		end

		local tConfigPath = SplitStringWithSeparator(tData.basicInfo.animation_index_code, ",")
		local nStart, nEnd = string.find(tConfigPath[1], ".png")
		local strName = "ui/holidayVillage/" .. tConfigPath[1]
		if not (nStart and nEnd) then
			local spineBuild = WZUISpine:create()
			spineBuild:setUseOriginSize(true)
			spineBuild:setAnchorPoint(GlobalMethod:ccp(0.5, 0))
			spineBuild:setFileAtlas(strName .. ".atlas")
			spineBuild:setFileJson(strName .. ".json")
			if nSceneState == 1 then
				spineBuild:play(tConfigPath[3], true)
			else
				spineBuild:play(tConfigPath[2], true)
			end
			spineBuild:setRelativePosition(GlobalMethod:ccp(tonumber(tConfigPath[4]), tonumber(tConfigPath[5])))
			spineBuild:setScale(tonumber(tConfigPath[6]))
			conHvBuild:addChild(spineBuild)
		-- else
		-- 	local imgBuild = WZUIImage:create()
		-- 	imgBuild:setUseOriginSize(true)
		-- 	if nSceneState == 1 then
		-- 		strName = string.gsub(strName, ".png", "_1.png")
		-- 	end
		-- 	imgBuild:setFile(strName)
		-- 	imgBuild:setScale(tonumber(tConfigPath[6]))
		-- 	conHvBuild:addChild(imgBuild)
		end
	end

	if property_items then
		self:_showRightProperty(property_items)
	end
end

-- 设置称号界面
function WndActivitySpecificSales:setTitleUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setTitleUI()")
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	conLeft:disableSchedule()
	conLeft:setTouchEnable(false)
	conLeft:removeAllChildrenWithCleanup(true)

	local strTitle = ""
	for k,v in pairs(GDatatab_achievement) do
		if v.script ~= -1 then
			local _, _, itemId, _ = string.find(v.script, "gdwp%*(%d+)=(%d+)")
			if tonumber(itemId) == tData.basicInfo.id then
				strTitle = v.name
			end
		end
	end
	local conTitle = WZUIContainer:create()
	conTitle:setUseAbsSize(true)
	conTitle:setAbsContentSize(GlobalMethod:CCSize(100,40))
	conTitle:setRelativePosition(ccp(0.5,0.6))
	conLeft:addChild(conTitle)
	local txtTitle = WZUILabelTTF:create()
	txtTitle:setFontSize(22)
	txtTitle:setRelativePosition(ccp(0.5,0))
	txtTitle:setColor(GlobalMethod:ccc3(255,236,193))
	txtTitle:setStrokeColor(GlobalMethod:ccc3(132,66,29))
	txtTitle:setEnableStroke(true)
	txtTitle:setStrokeSize(4)
	conTitle:addChild(txtTitle)
	local tempPoint = GlobalMethod:ccp(0.5,1)
	CreateDesiSpine(conTitle, txtTitle, strTitle, tempPoint, true)

	if property_items then
		self:_showRightProperty(property_items)
	end
end

-- 设置背景卡界面
function WndActivitySpecificSales:setBgCardUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setBgCardUI()")
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	conLeft:disableSchedule()
	conLeft:setTouchEnable(false)
	conLeft:removeAllChildrenWithCleanup(true)

	local conBgCard = WZUIContainer:create()
	conBgCard:setUseAbsSize(true)
	conBgCard:setAbsContentSize(GlobalMethod:CCSize(1136,640))
	conLeft:addChild(conBgCard)
	local clipCon = WZUIClippingContainer:create()
	clipCon:setScale(0.3)
	conBgCard:addChild(clipCon)
	local subCon = WZUIContainer:create()
	subCon:setUseAbsSize(true)
	subCon:setAbsContentSize(GlobalMethod:CCSize(1136,640))
	clipCon:setStencil(subCon)
	local img1 = WZUIImage:create()
	img1:setFile("ui/common/common_black_bg.png")
	subCon:addChild(img1)

	if tData.basicInfo.animation_index_code == -1 then 
		local sFilePath = string.gsub(tData.basicInfo.icon, "player_bg2", "player_bg")
		local sFileJsonPath = string.gsub(sFilePath, ".png", ".json")
		local sFileAtlasPath = string.gsub(sFilePath, ".png", ".atlas")
		local bExistSpine1 = WZFileUtil:isFileExist(sFileJsonPath)
		local bExistSpine2 = WZFileUtil:isFileExist(sFileAtlasPath)
		if bExistSpine1 and bExistSpine2 then 
			local spineBg = WZUISpine:create()
			spineBg:setUseOriginSize(true)
			spineBg:setFileJson(sFileJsonPath)
			spineBg:setFileAtlas(sFileAtlasPath)
			spineBg:play("animation", true)
			clipCon:addChild(spineBg)
		else
			local imgTemp = WZUIImage:create()
			imgTemp:setFile(icon)
			imgTemp:setUseOriginSize(true)
			clipCon:addChild(imgTemp)
		end
	else
		local tTempArray = SplitStringWithSeparator(tData.basicInfo.animation_index_code, "&")
		for i = 1, #tTempArray do
			local strTemp = tTempArray[i]
			local tConfig = SplitStringWithSeparator(strTemp, ",")
			local nStartIndex, nEndIndex = string.find(tConfig[1], ".png")
			local effectFile = "ui/checkother/" .. tConfig[1]
			if nStartIndex and nEndIndex then 
				local imgTemp = createImage(effectFile, GlobalMethod:ccp(tonumber(tConfig[2]), tonumber(tConfig[3])), nil, true, GlobalMethod:ccp(0.5,0.5))
				clipCon:addChild(imgTemp)
			else
				local bExistEffect = CheckEffectFile(effectFile)
				if bExistEffect then 
					local data = {}
					data.path = effectFile
					data.play = tConfig[4]
					data.loop = true
					data.ccp = GlobalMethod:ccp(tonumber(tConfig[2]), tonumber(tConfig[3]))
					createEffectSpine(clipCon, data)
				end
			end
		end
	end

	if property_items then
		self:_showRightProperty(property_items)
	end
end

-- 设置坐骑界面
function WndActivitySpecificSales:setMountUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setMountUI()")
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	conLeft:disableSchedule()
	conLeft:setTouchEnable(false)
	conLeft:removeAllChildrenWithCleanup(true)
	local sex = CacheCenter:getPlayerInfo().sex
	local ani = CreatePlayerFigure(sex, nil, "mount_show", nil,nil,nil,nil,nil,nil,nil,nil,nil,false)
	local animation_index_code = GDatatab_item["id_"..tData.basicInfo.id].animation_index_code
	if tData.basicInfo.main_type == 2 and tData.basicInfo.sub_type == 11 then
		for k,v in pairs(GDatatab_mounts) do
			if v.way ~= -1 and v.way[1][2] == 2 and v.way[2][2] == tData.basicInfo.id then
				animation_index_code = GDatatab_item["id_"..v.item_id].animation_index_code
				break
			end
		end
	end
	ani:setMount(animation_index_code)
	local node = ani:getAnimNode()
	node:setScale(0.6)
	node:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
	conLeft:addChild(node)

	if property_items then
		self:_showRightProperty(property_items)
	end
end

-- 设置皮肤界面
function WndActivitySpecificSales:setSkinUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setSkinUI()")
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	conLeft:disableSchedule()
	conLeft:setTouchEnable(false)
	conLeft:removeAllChildrenWithCleanup(true)
	local sex = CacheCenter:getPlayerInfo().sex
	local showId = tData.basicInfo.property[1][1]
	local ani = CreatePlayerFigure(sex, nil, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, showId)
	local node = ani:getAnimNode()
	node:setScale(0.6)
	node:setRelativePosition(GlobalMethod:ccp(0.5,0.2))
	conLeft:addChild(node)

	self:_showRightProperty(property_items)
end

-- 设置足迹界面
function WndActivitySpecificSales:setFootUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setFootUI()")
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	conLeft:disableSchedule()
	conLeft:setTouchEnable(false)
	conLeft:removeAllChildrenWithCleanup(true)
	for k,v in pairs(GDatatab_footmark) do
		if v.item_id == tData.basicInfo.id then
			local m_sRoleSpine = FootEffectManager:addEffect1(conLeft, v.id, {x=0,y=0}, true)
			m_sRoleSpine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
			break 
		end
	end

	self:_showRightProperty(property_items)
end

function WndActivitySpecificSales:setEquipUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setEquipUI()")
	local conPet = GetElement(self.m_root,"conPet_WndActivitySpecificSales", WZUIContainer)
	local conEquip = GetElement(self.m_root,"conEquip_WndActivitySpecificSales", WZUIContainer)
	--设置左侧展示容器物品
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	if conLeft then				
		--conLeft:setScale(1.5)
		conLeft:disableSchedule()	
		--conLeft:setAnchorPoint(GlobalMethod:ccp(0.5,0))
		--conLeft:setRelativePosition(GlobalMethod:ccp(0.4,0.2))
		conLeft:setTouchEnable(false)
		conLeft:removeAllChildrenWithCleanup(true)
		local tElement,tCell = CellGoodItem:createElement()
	--     --tCell:setItemClickFun(self,self.onWeaponClicked)
		if tElement ~= nil and tCell ~= nil then
			conLeft:addChild(tElement)
	--         --tElement:setScale(0.9)
			local goodsData = CopyTable(tData)
			tCell:setCellGoodItem(goodsData,15)
			GetElement(tElement, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
			GetElement(tElement, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
			GetElement(tElement, "btnImg1_CellGoodItem", WZUI9Image):setVisible(false)
			GetElement(tElement, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
		end
	end

	--设置右侧展示容器物品
	conEquip:setVisible(true)
	local conEquip1 = GetElement(self.m_root,"conEquip1_WndActivitySpecificSales", WZUIContainer)
	if not conEquip1 then
		return
	end
	for i = 1, 4 do
		local conEquip1_1 = GetElement(self.m_root,"conEquip1_"..i.."_WndActivitySpecificSales", WZUIContainer)
		if conEquip1_1 then
			conEquip1_1:setVisible(false)
		end
	end
	local conEquip2 = GetElement(self.m_root,"conEquip2_WndActivitySpecificSales", WZUIContainer)
	if conEquip2 then
		conEquip2:setVisible(false)
		local isWeapon = self:_checkEquipType()
		if isWeapon and #property_items <= 4 then
			conEquip2:setVisible(true)
		end
		conEquip2:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
		if #property_items <= 2 then
			conEquip2:setRelativePosition(GlobalMethod:ccp(0.5, 0.55))
		end
	end
	if conEquip1.removeAllChildrenWithCleanup then
		conEquip1:removeAllChildrenWithCleanup(true)
	end
	--武器
	-- local XYPos = {{0.5,0.638}, {0.55,0.638}, {0.5,0.578}, {0.55,0.578}}--pos初始值
	local XYPos = {{0.3,0.638}, {0.75,0.638}, {0.3,0.578}, {0.75,0.578}}--pos初始值
	local XYAnc = {{1,0.5}, {0,0.5}, {1,0.5}, {0,0.5}}--anchor初始值
	local aWidth = 0.05
	local aHeight = 0.06
	--txtName:setShowText(string.format([[<I Z="1">ui/common/title_frame_20.png</I><T C="163,73,20" S="18" P="1">%s</T><T C="230,105,23" S="18" P="1">%s</T>]],self.m_tNoticeData.name))
	local tempstr = [[<I Z="1">ui/common/title_frame_20.png</I><T C="163,73,20" S="18" P="1" Z="0.8">%s</T><T C="230,105,23" S="18" P="1" Z="0.8">%s</T>]]
	--tempstr = string.format(tempstr,fontSize,fontColor,sc,ss,se,str)
	--local PosWidth = 0.05--每个动态添加的containner的高度差
	--local PosHeight = 0.06--每个动态添加的containner的高度差
	for i = 1, #property_items do
		--if i <= 4 then
			local ii = i % 2
			if ii == 0 then
				ii = 2
			end
			--WZLog("WndActivitySpecificSales::setEquipUI() 1-2 property_item... ", i, ii)
			local property_item = property_items[i]
			--WZLog("WndActivitySpecificSales::setEquipUI() 1-2 property_item... ", Serialize(property_item))
			-- if property_item and property_item["value1"] and property_item["value2"] then
			-- 	local txt = WZUIFreeTextBox:create()
			-- 	WZLog("WndActivitySpecificSales:_createFreeText 0001")
			-- 	--txt:setName(sName)
			-- 	txt:setMaxWidth(130)
			-- 	WZLog("WndActivitySpecificSales:_createFreeText 0003")
			-- 	txt:setShowText(string.format(tempstr,property_item["value1"],property_item["value2"]))
			-- 	WZLog("WndActivitySpecificSales:_createFreeText 0002")
			-- 	--txt:setAnchorPoint(anchor)
			-- 	txt:setRelativePosition(GlobalMethod:ccp(XYPos[i][1], XYPos[i][2]))
			-- 	WZLog("WndActivitySpecificSales:_createFreeText 0004")
			-- 	conEquip1:addChild(txt)					
			-- 	WZLog("WndActivitySpecificSales:_createFreeText 0005")
			-- end

			local celElement = WZUISystem:getInstance():createElement("conItem_WndActivitySpecificSales")--GetElement(self.m_root,"conEquip1_"..i.."_WndActivitySpecificSales", WZUIContainer)
			if celElement and conEquip1 then		
				WZLog("WndActivitySpecificSales::setEquipUI() 1-3 property_item... ", Serialize(property_item))		
				local cel_txtItem0 = GetElement(celElement,"txtItem0_WndActivitySpecificSales", WZUILabelTTF)
				local cel_txtItem1 = GetElement(celElement,"txtItem1_WndActivitySpecificSales", WZUILabelTTF)
				if cel_txtItem0 and cel_txtItem1 and property_item and property_item["value1"] and property_item["value2"] then
					cel_txtItem0:setText(property_item["value1"])
					cel_txtItem1:setText(property_item["value2"])
				end
				celElement:setRelativePosition(GlobalMethod:ccp(XYPos[ii][1] , XYPos[ii][2] - aHeight * (math.floor((i-1)/2))))
				--celElement:setAnchorPoint(GlobalMethod:ccp(XYAnc[i][1], XYAnc[i][2]))
				celElement:setVisible(true)
				conEquip1:addChild(celElement)
			end
		--end
	end


	-- local txtEquip1 = GetElement(self.m_root,"txtEquip1_WndActivitySpecificSales", WZUILabelTTF)
	-- if txtEquip1 then		
	-- 	txtEquip1:setText(property[1][2])
	-- end
	-- local txtEquip2 = GetElement(self.m_root,"txtEquip2_WndActivitySpecificSales", WZUILabelTTF)
	-- if txtEquip2 then		
	-- 	txtEquip2:setText(property[2][2])
	-- end
end

function WndActivitySpecificSales:setPetUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setPetUI()")
	local conPet = GetElement(self.m_root,"conPet_WndActivitySpecificSales", WZUIContainer)
	local conEquip = GetElement(self.m_root,"conEquip_WndActivitySpecificSales", WZUIContainer)
	--设置展示容器物品
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	if conLeft then				
		--conLeft:setScale(1.5)	
		conLeft:disableSchedule()
		--conLeft:setAnchorPoint(GlobalMethod:ccp(0.5,0))
		--conLeft:setRelativePosition(GlobalMethod:ccp(0.4,0.2))
		conLeft:setTouchEnable(false)
		conLeft:removeAllChildrenWithCleanup(true)
		self.petAni = CreatePetAni(conLeft, tData.basicInfo.id)
		--self.petAni:setScale(1)
		self:playAttackAni()
	end

	conPet:setVisible(true)
	--宠物
	-- local txtPet1 = GetElement(self.m_root,"txtPet1_WndActivitySpecificSales", WZUILabelTTF)
	-- if txtPet1 then		
	-- 	txtPet1:setText(property[1][2])
	-- end
	-- local txtPet2 = GetElement(self.m_root,"txtPet2_WndActivitySpecificSales", WZUILabelTTF)
	-- if txtPet2 then		
	-- 	txtPet2:setText(property[2][2])
	-- end
	-- local txtPet3 = GetElement(self.m_root,"txtPet3_WndActivitySpecificSales", WZUILabelTTF)
	-- if txtPet3 then		
	-- 	txtPet3:setText(property[3][2])
	-- end
	--设置右侧展示容器物品
	local conPet1 = GetElement(self.m_root,"conPet1_WndActivitySpecificSales", WZUIContainer)
	if not conPet1 then
		return
	end
	if conPet1.removeAllChildrenWithCleanup then
		conPet1:removeAllChildrenWithCleanup(true)
	end
	-- local XYPos = {{0.5,0.638}, {0.55,0.638}, {0.5,0.578}, {0.55,0.578}}--pos初始值
	local XYPos = {{0.3,0.638}, {0.75,0.638}, {0.3,0.578}, {0.75,0.578}}--pos初始值
	local XYAnc = {{1,0.5}, {0,0.5}, {1,0.5}, {0,0.5}}--anchor初始值
	local aWidth = 0.05
	local aHeight = 0.07
	for i = 1, #property_items do
		local ii = 1
		local iii = 1
		if #property_items >= 5 then
			ii = i % 2
			if ii == 0 then
				ii = 2
			end
			iii = 2
		end
		--WZLog("WndActivitySpecificSales::setPetUI() 1-2 property_item... ", i, ii)
		local property_item = property_items[i]
		--WZLog("WndActivitySpecificSales::setPetUI() 1-2 property_item... ", Serialize(property_item))

		local celElement = WZUISystem:getInstance():createElement("conItem_WndActivitySpecificSales")--GetElement(self.m_root,"conEquip1_"..i.."_WndActivitySpecificSales", WZUIContainer)
		if celElement and conPet1 then		
			WZLog("WndActivitySpecificSales::setPetUI() 1-3 property_item... ", Serialize(property_item))		
			local cel_txtItem0 = GetElement(celElement,"txtItem0_WndActivitySpecificSales", WZUILabelTTF)
			local cel_txtItem1 = GetElement(celElement,"txtItem1_WndActivitySpecificSales", WZUILabelTTF)
			if cel_txtItem0 and cel_txtItem1 and property_item and property_item["value1"] and property_item["value2"] then
				cel_txtItem0:setText(property_item["value1"])
				cel_txtItem1:setText(property_item["value2"])
			end
			celElement:setRelativePosition(GlobalMethod:ccp(XYPos[ii][1] , XYPos[ii][2] - aHeight * (math.floor((i-1)/iii))))
			--celElement:setAnchorPoint(GlobalMethod:ccp(XYAnc[i][1], XYAnc[i][2]))
			celElement:setVisible(true)
			conPet1:addChild(celElement)
		end
	end

	--资质
	--显示资质
	local minGift,maxGift
	for k,v in pairs(GDatatab_pet) do
		if v.item_id == tData.basicInfo.id then
			minGift = v.gift[1][1]
			maxGift = v.gift[1][2]
			break
		end
	end

	local txtPet4 = GetElement(self.m_root,"txtPet4_WndActivitySpecificSales", WZUILabelTTF)
	if txtPet4 then		
		txtPet4:setText("("..minGift.."-"..maxGift..")")
	end
 --  	local text1 = [[<T C="127,70,26" S="20" >%s:</T><T C="127,70,26" S="20" > %s</T><T C="127,70,26" S="20" >(%d-%d)</T>]]
	-- GetElement(self.m_root,"txt6Type23_WndTips",WZUIFreeTextBox):setMaxWidth(350)
	-- if tData.gift ~= nil then
	-- 	GetElement(self.m_root,"txt6Type23_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.PET_1,tostring(math.ceil(tonumber(tData.gift)/100)),minGift,maxGift))
	-- else
	-- 	GetElement(self.m_root,"txt6Type23_WndTips",WZUIFreeTextBox):setShowText(string.format(text1,LocalStrings.PET_1,"",minGift,maxGift))
	-- end
end

--自选礼包UI(展示物品格子列表)
function WndActivitySpecificSales:setSpecificGiftsUI(tData, property_items)
	WZLog("WndActivitySpecificSales::setSpecificGiftsUI()")
	local conPet = GetElement(self.m_root,"conPet_WndActivitySpecificSales", WZUIContainer)
	local conEquip = GetElement(self.m_root,"conEquip_WndActivitySpecificSales", WZUIContainer)
	--设置左侧展示容器物品
	local conLeft = GetElement(self.m_root,"conLeft_WndActivitySpecificSales", WZUIContainer)
	if conLeft then				
		--conLeft:setScale(1.5)
		conLeft:disableSchedule()	
		--conLeft:setAnchorPoint(GlobalMethod:ccp(0.5,0))
		--conLeft:setRelativePosition(GlobalMethod:ccp(0.4,0.2))
		conLeft:setTouchEnable(false)
		conLeft:removeAllChildrenWithCleanup(true)


		local head_index,face_index,body_index,wing_index
		local giftItems = getItemsInGift(tData.basicInfo.id)
		for j = 1, #giftItems do
			local itemInfo = GDatatab_item["id_" .. giftItems[j].id]
			if itemInfo.main_type == 5 and itemInfo.sub_type == 0 then --头部
				head_index = giftItems[j].id
			elseif itemInfo.main_type == 5 and itemInfo.sub_type == 1 then --脸部
				face_index = giftItems[j].id
			elseif itemInfo.main_type == 5 and itemInfo.sub_type == 2 then --衣服
				body_index = giftItems[j].id
			elseif itemInfo.main_type == 5 and itemInfo.sub_type == 3 then --翅膀
				wing_index = giftItems[j].id
			end
		end
		if head_index or face_index or body_index or wing_index then
			local roleConPlayer = YDPlayerAnimation:createAnimation(CacheCenter:getPlayerInfo().sex == 0)
			roleConPlayer:getAnimNode():setTouchEnable(false)
			conLeft:addChild(roleConPlayer:getAnimNode())
			roleConPlayer:setFlipX(true)
			if head_index then
				local head = GDatatab_item["id_"..head_index].animation_index_code
				roleConPlayer:setHead(head)
			end
			if face_index then
				local face = GDatatab_item["id_"..face_index].animation_index_code
				roleConPlayer:setFace(face)
			end
			if body_index then
				local body = GDatatab_item["id_"..body_index].animation_index_code
				roleConPlayer:setBody(body)
			end
			if wing_index then
				local wing = GDatatab_item["id_"..wing_index].animation_index_code
				roleConPlayer:setWing(wing)
			end
			roleConPlayer:play("wait0",true)
		else
			local tElement,tCell = CellGoodItem:createElement()
		--     --tCell:setItemClickFun(self,self.onWeaponClicked)
			if tElement ~= nil and tCell ~= nil then
				conLeft:addChild(tElement)
		--         --tElement:setScale(0.9)
				local goodsData = CopyTable(tData)
				tCell:setCellGoodItem(goodsData,15)
				GetElement(tElement, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
				GetElement(tElement, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
				GetElement(tElement, "btnImg1_CellGoodItem", WZUI9Image):setVisible(false)
				GetElement(tElement, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
			end
		end
	end

	--设置右侧展示容器物品
	conEquip:setVisible(true)
	local conEquip1 = GetElement(self.m_root,"conEquip1_WndActivitySpecificSales", WZUIContainer)
	if not conEquip1 then
		return
	end
	for i = 1, 4 do
		local conEquip1_1 = GetElement(self.m_root,"conEquip1_"..i.."_WndActivitySpecificSales", WZUIContainer)
		if conEquip1_1 then
			conEquip1_1:setVisible(false)
		end
	end
	local conEquip2 = GetElement(self.m_root,"conEquip2_WndActivitySpecificSales", WZUIContainer)
	if conEquip2 then
		conEquip2:setVisible(false)		
	end
	if conEquip1.removeAllChildrenWithCleanup then
		conEquip1:removeAllChildrenWithCleanup(true)
	end
	
	--展示自选礼包物品格子列表
	self:_showPacks()
end

--@brief	礼包可获得物品
function WndActivitySpecificSales:_showPacks()
	WZLog("WndActivitySpecificSales::_showPacks()")
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.main_type ~= 3 and self.m_tEquip.basicInfo.main_type ~= 17 then return end
	if self.m_tEquip.basicInfo.main_type == 17 and self.m_tEquip.basicInfo.sub_type ~= 5 then return end
	if self.m_tEquip.basicInfo.main_type == 3 and self.m_tEquip.basicInfo.sub_type == 4 then return end

	local desc = {LocalStrings.BAGTIP7,LocalStrings.BAGTIP8,LocalStrings.BAGTIP7,LocalStrings.BAGTIP8}
	local sub_type = self.m_tEquip.basicInfo.sub_type

	local sex = CacheCenter:getPlayerInfo().sex
	local giftList = {}
	local sexIndex = {"man_item_id","woman_item_id"}
	local quality = g_tQualityRect
	local countLimit = {}
	for k,v in pairs(GDatatab_gifts) do
		if v.item_id ==  self.m_tEquip.basicInfo.id then
			local temp = {}
			temp.id = v[sexIndex[sex+1]]
			temp.count = v["count"]
			temp.quality = GDatatab_item["id_"..v[sexIndex[sex+1]]].quality
			temp.main_type = GDatatab_item["id_"..v[sexIndex[sex+1]]].main_type
			temp.sub_type = GDatatab_item["id_"..v[sexIndex[sex+1]]].sub_type
			if sub_type == 0 or sub_type == 2 and temp.id ~= 1 and temp.id ~= 2 then
				WZLog("显示礼包",v.id,temp.id)
				table.insert(giftList,temp)
			else
				--如果礼包没重复才显示
				local reapeat = false
				local maintype_subtype_count = temp.main_type.."-"..temp.sub_type.."-"..temp.count
				if countLimit[maintype_subtype_count] == nil then countLimit[maintype_subtype_count] = 0 end
				for k=1,#giftList do
					if giftList[k].id == temp.id and temp.main_type ~= 5 then
						reapeat = true
					end
				end
				if reapeat == false then
					if (temp.main_type == 5 and countLimit[maintype_subtype_count] < 2) then
						table.insert(giftList,temp)
						--countLimit[maintype_subtype_count] = countLimit[maintype_subtype_count] + 1
					end
					if temp.main_type ~= 5 then
						table.insert(giftList,temp)
					end
				end
			end
		end
	end
	table.sort(giftList,sortGift)
	if #giftList == 0 then return end

	local tableSpe = GetElement(self.m_root,"tableSpe_WndActivitySpecificSales",WZUITableContainer)
	--tableSpe:setLoadCountPerFrame(4)
	if tableSpe then
		tableSpe:cleanTable()
		tableSpe:setVisible(true)
		for i=1,#giftList do
			local reward = giftList[i]			
			if type(reward) == "string" then
				reward = json.decode(reward)
			end		
			WZLog("WndActivitySpecificSales::_showPacks() 限定活动 reward_"..i, Serialize(reward))
			local celElement,tCell = CellGoodItem:createElement()
			if celElement and tCell then
				celElement:setTag(i-1)
				tableSpe:setCellElement(celElement)
				tCell:setCellGoodLocalId(reward.id, reward.count, 17)
				--tCell:clearItemQualityPic()
				tCell:setItemClickFun(self,self.clickGift)
				celElement:setScale(0.8)
				--table.insert(self.m_tCellList, tCell)
			end
		end
	end
end

function WndActivitySpecificSales:clickGift(tCell,tag,tData)
	WZLog("WndActivitySpecificSales:clickGift", tCell:getTag())
	-- local itemId = tonumber(element:getTag())
	-- local tData = {id=itemId,basicInfo=GDatatab_item["id_"..itemId]}
	-- WndActiVitySpecificSales:_onCloseClick()
	-- WndActiVitySpecificSales.m_root = nil

	-- WndActiVitySpecificSales:showInfo(self.m_tLua[1],self.m_tLua[2],1, tData, false)

	WndItemInfo:onCloseClick()
	WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)	
end

--@brief  礼包按品质排序
function sortGift(a,b)
	if type(a) == "number" then return false end
	if a.quality ~= b.quality then
		return a.quality >= b.quality
	elseif a.count ~= b.count then
		return a.count < b.count
	else
		return a.id < b.id 
	end
end


function WndActivitySpecificSales:playAttackAni(itemId)
	if not itemId then return end
	local conPet = GetElement(self.m_root,"conLeft_WndActivitySpecificSales",WZUIContainer)
	conPet:disableSchedule()

	local bExpPet = self:isExpPet(itemId)
	if bExpPet then return end

	self.petAni:play("attack",false)
	conPet:enableSchedule("_updateWaitAni")
end


function WndActivitySpecificSales:_updateWaitAni(element)
	local isEnd = self.petAni:isCurrentAnimationDone()
	if isEnd then
	local conPet = GetElement(self.m_root,"conLeft_WndActivitySpecificSales",WZUIContainer)
	conPet:disableSchedule()
	self.petAni:play("wait",true)
	end
end

--@brief 判断是否是经验宝宝
--@param petId 宠物的id
function WndActivitySpecificSales:isExpPet(petId)
  if GDatatab_item["id_"..petId].sub_type == 0 then
	return true
  end
  return false
end


--更新Table容器内容
function WndActivitySpecificSales:updateTableContainer()
	WZLog("WndActivitySpecificSales::updateTableContainer()")
	if not self.m_sContent then
		return
	end
	-- --[[
	-- 	content:
	-- 		{
	-- 			weaponRewards	: '武器配置奖励 [\[男物品id,女物品id,数量]&[]\,\[男物品id,女物品id,数量]&[]\]',
	-- 			weaponConfig	: '武器目标进度 int[[充值,消耗],..]',
	-- 			petRewards	: '宠物配置奖励 [\[男物品id,女物品id,数量]&[]\,\[男物品id,女物品id,数量]&[]\]',
	-- 			petConfig	: '宠物目标进度 int[[充值,消耗],..]'
	-- 		}
	-- 	status:
	-- 		{
	-- 			day	: int周年庆签到第几天,
	-- 			weaponStatus	: int[]武器领取状态 ：-1=不可领取,0=,可领取,1=,已领取,
	-- 			petStatus	: int[]宠物领取状态 ：-1=不可领取,0=,可领取,1=,已领取,
	-- 			rechargeNum	: int充值钻石数量,
	-- 			costNum	: int今日消耗钻石数量
	-- 		}

	-- ]]
	local content = json.decode(self.m_sContent)
	local rewards, config
	if self.m_nTag == 1 then
		rewards = content["weaponRewards"]
		if type(rewards) == "string" then
			rewards = json.decode(rewards)
		end
		config = content["weaponConfig"]
	else
		rewards = content["petRewards"]		
		if type(rewards) == "string" then
			rewards = json.decode(rewards)
		end
		config = content["petConfig"]
	end

	WZLog("WndActivitySpecificSales::updateTableContainer() 限定活动", Serialize(content))
	--WZLog("WndActivitySpecificSales::updateTableContainer() 限定活动 rewards", rewards)
	--WZLog("WndActivitySpecificSales::updateTableContainer() 限定活动 #rewards", #rewards)
	--WZLog("WndActivitySpecificSales::updateTableContainer() 限定活动 rewards[1]", rewards[1])

	--self.m_vnCounts[1] 

	local player = CacheCenter:getPlayerInfo()
	local sex = 0
	if player and player.sex then
		sex = player.sex
	end
	WZLog("WndActivitySpecificSales::updateTableContainer() 限定活动 sex", sex)
	self.m_tCellList = {}
	local tableConGoods = GetElement(self.m_root,"tableConGoods_WndActivitySpecificSales",WZUITableContainer)
	--tableConGoods:setLoadCountPerFrame(4)
	if tableConGoods then
		tableConGoods:cleanTable()
		for i=1,#rewards do
			local reward = rewards[i]			
			if type(reward) == "string" then
				reward = json.decode(reward)
			end		
			WZLog("WndActivitySpecificSales::updateTableContainer() 限定活动 reward_"..i, Serialize(reward))
			if #reward >= 3 then
				local celElement,tCell = CellGoodItem:createElement()
				if celElement and tCell then
					celElement:setTag(i-1)
					tableConGoods:setCellElement(celElement)
					tCell:setCellGoodLocalId(reward[sex+1], reward[3], 17)
					--tCell:clearItemQualityPic()
					tCell:setItemClickFun(self,self.onItemClick)
					celElement:setScale(0.95)
					table.insert(self.m_tCellList, tCell)
				end
			end
		end
	end


	WZLog("WndActivitySpecificSales::updateUI() updateTableContainer self.m_tCellList")
	local itemTag = self.m_nTagItemSelect or 1
	if self.m_tCellList and #(self.m_tCellList) >= itemTag and self.m_tCellList[itemTag] then
		WZLog("WndActivitySpecificSales::updateUI() updateTableContainer self.m_tCellList:onBackClick()")
		self.m_tCellList[itemTag]:onBackClick()
		--self.m_tCellList[itemTag]:setHighLight(true)
	end
end

--更新UI内容
function WndActivitySpecificSales:updateUI()
	WZLog("WndActivitySpecificSales::updateUI()")	
	self:updateTableContainer()
	self:updateMainUI()
end

--@brief 	设置面板内容
function WndActivitySpecificSales:_updateActivityContext(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	WZLog("WndActivitySpecificSales::_updateActivityContext()", activityId)
	if g_cityExtenInfo == nil or activityId == nil or tonumber(activityId) ~= tonumber(g_cityExtenInfo.activity7080) then
		WZLog("WndActivitySpecificSales::_updateActivityContext() 错误的活动id")
		return
	end
	WZLog("WndActivitySpecificSales::_updateActivityContext() 限定活动", activityId)
	self.m_sContent = content
	self.m_nStartTime = startTime 
	self.m_nEndTime = endTime 
	self:updateUI()
end

function WndActivitySpecificSales:_onGet108Result(activityId, activityIdType, doType, result, strJson)
	WZLog("WndActivitySpecificSales::_onGet108Result()", activityId)
	self:_closeLoading()
	if activityId ~= tonumber(g_cityExtenInfo.activity7080) then
		return
	end
	if doType == 1 then
		--{"costNum":171,"weaponStatus":[1,1,1,0],"petStatus":[0,0,0,0,0],"rechargeNum":120,"weaponOwn":[0,0,0,0],"petOwn":[0,0,0,0]}
		local tResult = json.decode(strJson)
		self:updateStatus(tResult, doType)
	elseif doType == 2 then
		--{"rewardId":3,"itemIds":[7918],"rewardType":0,"itemNums":[1],"status":1}
		local tResult = json.decode(strJson)
		local itemIds = tResult["itemIds"]
		local itemNums = tResult["itemNums"]
		WZLog("WndActivitySpecificSales::_onGet108Result() 2", #itemIds, #itemNums)
		--if self.m_nTag == 2 and itemIds and itemIds then
		--显示奖励物品
		WndRewardShow:showById(itemIds,itemNums)
		--end
		if g_cityExtenInfo then
			self:_createLoading()
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7080, 1, "")
		end
	end
end

-- 显示右边属性
function WndActivitySpecificSales:_showRightProperty(property_items)
	local conEquip = GetElement(self.m_root,"conEquip_WndActivitySpecificSales", WZUIContainer)
	conEquip:setVisible(true)
	local conEquip1 = GetElement(self.m_root,"conEquip1_WndActivitySpecificSales", WZUIContainer)
	if not conEquip1 then
		return
	end
	for i = 1, 4 do
		local conEquip1_1 = GetElement(self.m_root,"conEquip1_"..i.."_WndActivitySpecificSales", WZUIContainer)
		if conEquip1_1 then
			conEquip1_1:setVisible(false)
		end
	end
	local conEquip2 = GetElement(self.m_root,"conEquip2_WndActivitySpecificSales", WZUIContainer)
	if conEquip2 then
		conEquip2:setVisible(false)
		local isWeapon = self:_checkEquipType()
		if isWeapon and #property_items <= 4 then
			conEquip2:setVisible(true)
		end
		conEquip2:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
		if #property_items <= 2 then
			conEquip2:setRelativePosition(GlobalMethod:ccp(0.5, 0.55))
		end
	end
	if conEquip1.removeAllChildrenWithCleanup then
		conEquip1:removeAllChildrenWithCleanup(true)
	end
	--武器
	local XYPos = {{0.3,0.638}, {0.75,0.638}, {0.3,0.578}, {0.75,0.578}}--pos初始值
	local XYAnc = {{1,0.5}, {0,0.5}, {1,0.5}, {0,0.5}}--anchor初始值
	local aWidth = 0.05
	local aHeight = 0.06
	--txtName:setShowText(string.format([[<I Z="1">ui/common/title_frame_20.png</I><T C="163,73,20" S="18" P="1">%s</T><T C="230,105,23" S="18" P="1">%s</T>]],self.m_tNoticeData.name))
	local tempstr = [[<I Z="1">ui/common/title_frame_20.png</I><T C="163,73,20" S="18" P="1" Z="0.8">%s</T><T C="230,105,23" S="18" P="1" Z="0.8">%s</T>]]
	--tempstr = string.format(tempstr,fontSize,fontColor,sc,ss,se,str)
	--local PosWidth = 0.05--每个动态添加的containner的高度差
	--local PosHeight = 0.06--每个动态添加的containner的高度差
	for i = 1, #property_items do
		local ii = i % 2
		if ii == 0 then
			ii = 2
		end

		local property_item = property_items[i]

		local celElement = WZUISystem:getInstance():createElement("conItem_WndActivitySpecificSales")--GetElement(self.m_root,"conEquip1_"..i.."_WndActivitySpecificSales", WZUIContainer)
		if celElement and conEquip1 then		
			WZLog("WndActivitySpecificSales::setEquipUI() 1-3 property_item... ", Serialize(property_item))		
			local cel_txtItem0 = GetElement(celElement,"txtItem0_WndActivitySpecificSales", WZUILabelTTF)
			local cel_txtItem1 = GetElement(celElement,"txtItem1_WndActivitySpecificSales", WZUILabelTTF)
			if cel_txtItem0 and cel_txtItem1 and property_item and property_item["value1"] and property_item["value2"] then
				cel_txtItem0:setText(property_item["value1"])
				cel_txtItem1:setText(property_item["value2"])
			end
			celElement:setRelativePosition(GlobalMethod:ccp(XYPos[ii][1] , XYPos[ii][2] - aHeight * (math.floor((i-1)/2))))
			--celElement:setAnchorPoint(GlobalMethod:ccp(XYAnc[i][1], XYAnc[i][2]))
			celElement:setVisible(true)
			conEquip1:addChild(celElement)
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------

function WndActivitySpecificSales:_adaptLanguage_vn()
	GetElement(self.m_root,"txtTitle_WndActivitySpecificSales", WZUILabelTTF):setScale(0.7)
	local btnEquip = GetElement(self.m_root,"btnEquip_WndActivitySpecificSales",WZUIButton)
	GetElement(btnEquip,"name",WZUILabelTTF):setScale(0.7)
end

-------------------------------------语言适配End----------------------------------------
