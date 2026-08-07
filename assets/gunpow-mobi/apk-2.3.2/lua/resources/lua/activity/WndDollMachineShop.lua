--WndDollMachineShop.lua
--@brief	WndDollMachineShop的UI模块
--@date		2021/04/29
--@author	hyx
--@note		娃娃机商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDollMachineShop:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDollMachineShop:onExit(element)
	self:_unInit()
	self:unregister()
end
-- _type  默认是娃娃机的  1:钓鱼 2:年兽商店 3:欢乐打地鼠商店 4:套圈圈屋 5：保龄球俱乐部 6:台无止境商店 7:葫芦娃-爷爷宝屋 8蹦床商店 9心愿商店 10深海商店 11投篮商店 12投壶商店 13抽陀螺 14踢毽子 15钢琴演奏家 16举重比赛 17铸剑神匠 18吹泡泡 90通用商店
--@param 	otherData:
--[[	otherData = {}
		otherData.title = LocalStrings.CATHOUSE_TEXT1[3] --标题
		otherData.doType_get = 6 --获取商店数据的doType值
		otherData.doType_buy = 7 --购买的doType值
		otherData.showBuyReward = true --购买后是否显示所得的奖励
		otherData.coinId = 160566      --商店货币Id
		otherData.chipPt = GlobalMethod:ccp(0.034,0.95) --货币数量显示位置
		otherData.img9_bg = "ui/common/frame_tc_xiao.png" --背景素材
		otherData.imgClose = "ui/common/common_top_btn_guanbi_zi.png" --关闭按钮素材
		otherData.item_bg = "ui/common/common_pic_di_03.png" --商品底图
]]
function WndDollMachineShop:showInterface(_type, nActivityId, otherData)
	local wndShop = WndDollMachineShop:createElement(_type)
	if wndShop ~= nil then
		self.m_nActivityId = nActivityId
		self.m_tOtherData = otherData
	    WindowManager:addWindow(wndShop, WndDollMachineShop, nil, false)
	end
end
function WndDollMachineShop:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetDollMachineShopInfo,self)
end
function WndDollMachineShop:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetDollMachineShopInfo,self)
end
function WndDollMachineShop:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndDollMachineShop:actionCallback()
	self:initShow()
end
function WndDollMachineShop:initShow()
	local txtTitleName = GetElement(self.m_root,"txtTitleName",WZUILabelTTF)
	local img9_bg = GetElement(self.m_root,"img9_bg",WZUI9Image)
	img9_bg:setFile("ui/common/frame_tc_xiao.png")
	if self.m_nType == 1 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
		txtTitleName:setText(LocalStrings.ACTIVITY_TEXT117)
	elseif self.m_nType == 2 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
		txtTitleName:setText(LocalStrings.YEARMONSTER_TEXT1[3])
	elseif self.m_nType == 3 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
		txtTitleName:setText(LocalStrings.BEATMICE_TEXT1[3])
	elseif self.m_nType == 4 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
		txtTitleName:setText(LocalStrings.SETCIRCLE_TEXT1[3])
	elseif self.m_nType == 5 then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
		txtTitleName:setText(LocalStrings.BOWLING_TEXT1[11])
		img9_bg:setFile("ui/common/frame_tc_xiao_zi.png")
		GetElement(self.m_root, "imgClose_WndDollMachineShop", WZUIImage):setFile("ui/common/common_top_btn_guanbi_zi.png")
	elseif self.m_nType == 6 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
		txtTitleName:setText(LocalStrings.BILLIARDBALL_TEXT1[10])
	elseif self.m_nType == 7 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
		txtTitleName:setText(LocalStrings.CALABASH_TEXT1[4])
	elseif self.m_nType == 8 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)

		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
		txtTitleName:setText(LocalStrings.TRAMPOLINE_TEXT1[5])
	elseif self.m_nType == 9 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.WISHING_BOTTLE_TEXT1[14])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	elseif self.m_nType == 10 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.DEEPSEA_TEXT1[8])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	elseif self.m_nType == 11 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.HOTBASKETBALL_TEXT1[8])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
		img9_bg:setFile("ui/common/frame_tc_xiao_zi.png")
		GetElement(self.m_root, "imgClose_WndDollMachineShop", WZUIImage):setFile("ui/common/common_top_btn_guanbi_zi.png")
	elseif self.m_nType == 12 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.THROWPOT_TEXT1[8])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	elseif self.m_nType == 13 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.LASHTOP_TEXT1[2])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	elseif self.m_nType == 14 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.KICKING_BIRDIE_TEXT1[6])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	elseif self.m_nType == 15 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.PIANIST_TEXT1[11])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, "")
	elseif self.m_nType == 16 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.WEIGHTLIFTING_TEXT1[5])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
		img9_bg:setFile("ui/common/frame_tc_xiao_lan.png")
		GetElement(self.m_root, "imgClose_WndDollMachineShop", WZUIImage):setFile("ui/newvip/common_top_btn_guanbi_lan.png")
	elseif self.m_nType == 17 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.CASTING_MASTER_ACTIVITY_TEXT1[22])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
	elseif self.m_nType == 18 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		txtTitleName:setText(LocalStrings.BLOW_BUBBLES_TEXT1[4])
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 6, "")
		img9_bg:setFile("ui/common/frame_tc_xiao_lan.png")
		GetElement(self.m_root, "imgClose_WndDollMachineShop", WZUIImage):setFile("ui/newvip/common_top_btn_guanbi_lan.png")
	elseif self.m_nType == 90 then
		local chipTableContainer = GetElement(self.m_root, "chipTableContainer", WZUITableContainer)
		chipTableContainer:setAbsContentSize(GlobalMethod:CCSize(810,440))
		chipTableContainer:updateRelativeSize()
		chipTableContainer:setCellElementHeight(0.44)
		if self.m_tOtherData then 
			if self.m_tOtherData.title then 
				txtTitleName:setText(self.m_tOtherData.title)
			end
			if self.m_tOtherData.doType_get then 
				ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, self.m_tOtherData.doType_get, "")
			end
			if self.m_tOtherData.img9_bg then 
				img9_bg:setFile(self.m_tOtherData.img9_bg)
			end
			if self.m_tOtherData.imgClose then 
				GetElement(self.m_root, "imgClose_WndDollMachineShop", WZUIImage):setFile(self.m_tOtherData.imgClose)
			end
		end
	else
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 2, "")
		txtTitleName:setText(LocalStrings.ACTIVITY_TEXT5)
		img9_bg:setFile("ui/common/frame_tc_xiao_zi.png")
	end
end

function WndDollMachineShop:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 2 then 
		WndYearMonster:setUpdateInterval()
	end
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndDollMachineShop:_onGetDollMachineShopInfo(activityId, doType, result, msg)
	msg = json.decode(msg)
	
	if activityId == tonumber(g_cityExtenInfo.activity7024) then
		self:setFishResult(msg, doType, result)
	elseif activityId == tonumber(g_cityExtenInfo.activity7035) then
		self:setYearMonsterResult(msg, doType, result)
	elseif activityId == tonumber(g_cityExtenInfo.activity7037) then
		self:setBeatMiceResult(msg, doType, result)
	elseif activityId == tonumber(g_cityExtenInfo.activity7046) or activityId == tonumber(g_cityExtenInfo.activity7049) or activityId == tonumber(g_cityExtenInfo.activity7055) or activityId == tonumber(g_cityExtenInfo.activity7063) or activityId == tonumber(g_cityExtenInfo.activity7081) or activityId == tonumber(g_cityExtenInfo.activity7083) or activityId == tonumber(g_cityExtenInfo.activity7089) or activityId == tonumber(g_cityExtenInfo.activity7091) or activityId == tonumber(g_cityExtenInfo.activity7093) or activityId == tonumber(g_cityExtenInfo.activity7096) or activityId == tonumber(g_cityExtenInfo.activity7097) or activityId == tonumber(g_cityExtenInfo.activity7100) or activityId == tonumber(g_cityExtenInfo.activity7102) or activityId == tonumber(g_cityExtenInfo.activity7105) or activityId == tonumber(g_cityExtenInfo.activity7107) then
		self:setYearMonsterResult(msg, doType, result)
	elseif activityId == tonumber(g_cityExtenInfo.activity7010) then
		if msg then
			if doType == 2 then
				self:setChipShopData(msg.shopIds, msg.itemIds, msg.itemNums, msg.costItemIds, msg.costItemNums, msg.canBuys, msg.todayLimit, 
									 msg.totalLimit, msg.limitType)
				self.m_nChipNum = msg.pieceNum
				self:setChipNum()
				local chipTableContainer = GetElement(self.m_root,"chipTableContainer",WZUITableContainer)
				chipTableContainer:cleanTable()
				for i = 1, #self.m_tChipShopData do
			        local celElement,tCell = CellChipShopItem:createElement()
			        self.m_tCellItemChip[i] = tCell
					celElement:setTag(i-1)
			        chipTableContainer:setCellElement(celElement)
			        tCell:setChipShopItemData(self.m_tChipShopData[i])
				end
			elseif doType == 3 then
				if result == 1 then
					self.m_nChipNum = msg.pieceNum
					self:setChipNum()
					WndRewardShow:showById(msg.itemIds, msg.itemNums)
					self:setBuyChipResetData(msg.shopId, msg.canBuys)
				else
					MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT16[result])
				end
			end
		end
	elseif self.m_nType == 90 then 
		self:setCommonResult(msg, doType, result)
	end
end
--钓鱼的
function WndDollMachineShop:setFishResult(data, doType, result)
	if not data then return end

	self.m_nChipNum = data.scaleNum or 0
	self:setChipNum(self.m_nType)
	if doType == 2 then
		self.m_tChipShopData = self:setChipShopFishData(data)
		local chipTableContainer = GetElement(self.m_root,"chipTableContainer",WZUITableContainer)
		chipTableContainer:cleanTable()
		for i = 1, #self.m_tChipShopData do
	        local celElement,tCell = CellChipShopItem:createElement()
	        self.m_tCellItemChip[i] = tCell
			celElement:setTag(i-1)
	        chipTableContainer:setCellElement(celElement)
	        tCell:setChipShopItemData(self.m_tChipShopData[i], 1, self.m_nChipNum)
		end
	elseif doType == 3 then --购买返回
		if result == 0 then
			MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT35)
			if self.m_nActivityId == tonumber(g_cityExtenInfo.activity7035) then 
				WndRewardShow:showById(data.itemIds, data.itemNums)
			end
			for i=1,#self.m_tChipShopData do
				if self.m_tChipShopData[i].id == data.id then
					self.m_tChipShopData[i].soldNum = data.soldNum
					if self.m_tCellItemChip[i] then
						self.m_tCellItemChip[i]:setFishBuyData(self.m_tChipShopData[i].soldNum, self.m_tChipShopData[i].limitNum, self.m_nChipNum, 
												self.m_tChipShopData[i].dailyLimit, data.dailyBuyNum)
					end
					break
				end
			end
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT132)
		end
	end
end
--年兽的
function WndDollMachineShop:setYearMonsterResult(data, doType, result)
	if not data then return end

	self.m_nChipNum = data.scaleNum or 0
	self:setChipNum(self.m_nType)
	if doType == 4 or (self.m_nActivityId == tonumber(g_cityExtenInfo.activity7081) and doType == 6) or (self.m_nActivityId == tonumber(g_cityExtenInfo.activity7083) and doType == 6) or ((self.m_nActivityId == tonumber(g_cityExtenInfo.activity7091) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7093) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7097) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7102) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7105) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7107)) and doType == 6) then
		self.m_tChipShopData = self:setChipShopFishData(data)
		local chipTableContainer = GetElement(self.m_root,"chipTableContainer",WZUITableContainer)
		chipTableContainer:cleanTable()
		for i = 1, #self.m_tChipShopData do
	        local celElement,tCell = CellChipShopItem:createElement()
	        self.m_tCellItemChip[i] = tCell
			celElement:setTag(i-1)
	        chipTableContainer:setCellElement(celElement)
	        tCell:setChipShopItemData(self.m_tChipShopData[i], 1, self.m_nChipNum)
		end
	elseif doType == 5 or (self.m_nActivityId == tonumber(g_cityExtenInfo.activity7081) and doType == 7) or (self.m_nActivityId == tonumber(g_cityExtenInfo.activity7083) and doType == 7) or ((self.m_nActivityId == tonumber(g_cityExtenInfo.activity7091) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7093) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7097) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7102) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7105) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7107)) and doType == 7) then --购买返回
		if result == 0 then
			MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT35)
			if self.m_nActivityId == tonumber(g_cityExtenInfo.activity7035) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7046) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7049) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7055) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7063) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7081) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7083) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7089) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7091) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7093) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7096) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7097) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7100) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7102) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7105) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7107) then 
				WndRewardShow:showById(data.itemIds, data.itemNums, nil, nil, nil, nil, nil, nil, nil, nil, nil, data.playerItemIds)
			end
			if self.m_nActivityId == tonumber(g_cityExtenInfo.activity7055) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7063) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7081) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7083) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7089) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7091) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7093) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7096) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7097) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7100) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7102) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7105) or self.m_nActivityId == tonumber(g_cityExtenInfo.activity7107) then 
				for j = 1, #data.id do
					for i=1,#self.m_tChipShopData do
						if self.m_tChipShopData[i].id == data.id[j] then
							self.m_tChipShopData[i].soldNum = data.soldNum[j]
							self.m_tChipShopData[i].dailyBuyNum = data.dailyBuyNum[j]
							if self.m_tCellItemChip[i] then
								self.m_tCellItemChip[i]:setFishBuyData(self.m_tChipShopData[i].soldNum, self.m_tChipShopData[i].limitNum, self.m_nChipNum, 
														self.m_tChipShopData[i].dailyLimit, data.dailyBuyNum[j])
							end
							break
						end
					end
				end
			else
				for i=1,#self.m_tChipShopData do
					if self.m_tChipShopData[i].id == data.id then
						self.m_tChipShopData[i].soldNum = data.soldNum
						if self.m_tCellItemChip[i] then
							WZLog("WndDollMachineShop:setYearMonsterResult", self.m_tChipShopData[i].soldNum, self.m_tChipShopData[i].limitNum, self.m_nChipNum, 
													self.m_tChipShopData[i].dailyLimit, data.dailyBuyNum)
							self.m_tCellItemChip[i]:setFishBuyData(self.m_tChipShopData[i].soldNum, self.m_tChipShopData[i].limitNum, self.m_nChipNum, 
													self.m_tChipShopData[i].dailyLimit, data.dailyBuyNum)
						end
						break
					end
				end
			end
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT132)
		end
	end
end

--欢乐地鼠的
function WndDollMachineShop:setBeatMiceResult(data, doType, result)
	if not data then return end

	self.m_nChipNum = data.scaleNum or 0
	self:setChipNum(self.m_nType)
	if doType == 2 then
		self.m_tChipShopData = self:setChipShopFishData(data)
		local chipTableContainer = GetElement(self.m_root,"chipTableContainer",WZUITableContainer)
		chipTableContainer:cleanTable()
		for i = 1, #self.m_tChipShopData do
	        local celElement,tCell = CellChipShopItem:createElement()
	        self.m_tCellItemChip[i] = tCell
			celElement:setTag(i-1)
	        chipTableContainer:setCellElement(celElement)
	        tCell:setChipShopItemData(self.m_tChipShopData[i], 1, self.m_nChipNum)
		end
	elseif doType == 3 then --购买返回
		if result == 0 then
			MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT35)
			if self.m_nActivityId == tonumber(g_cityExtenInfo.activity7037) then 
				WndRewardShow:showById(data.itemIds, data.nums)
			end
			for i=1,#self.m_tChipShopData do
				if self.m_tChipShopData[i].id == data.id then
					self.m_tChipShopData[i].soldNum = data.soldNum
					if self.m_tCellItemChip[i] then
						self.m_tCellItemChip[i]:setFishBuyData(self.m_tChipShopData[i].soldNum, self.m_tChipShopData[i].limitNum, self.m_nChipNum, 
												self.m_tChipShopData[i].dailyLimit, data.dailyBuyNum)
					end
					break
				end
			end
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT132)
		end
	end
end

--碎片数量
function WndDollMachineShop:setChipNum(_type, bIsSetPos)
	if not self.m_root then return end

	local txtChipNum = GetElement(self.m_root,"txtChipNum",WZUIFreeTextBox)
	if txtChipNum then
		local id = -1
		local strName = LocalStrings.ACTIVITY_TEXT9
		if _type == 1 then
			id = 160139
		elseif _type == 2 or _type == 3 or _type == 4 or _type == 5 or _type == 6 or _type == 7 or _type == 8 or _type == 9 or _type == 10 or _type == 11 or _type == 12 or _type == 13 or _type == 14 or _type == 15 or _type == 16 or _type == 17 or _type == 18 then 
			if _type == 2 then 
				id = 160186
			elseif _type == 3 then 
				id = 160227
			elseif _type == 4 then 
				id = 160240
			elseif _type == 5 then 
				id = 160259
			elseif _type == 6 then 
				id = 171420
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 7 then 
				id = 160407
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 8 then 
				id = 160464
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 9 then
				id = WndWishingBottle.m_nCoin2Id --160470
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 10 then 
				id = 160493
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 11 then 
				id = 160504
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 12 then 
				id = 160514
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 13 then 
				id = 160518
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 14 then 
				id = 160536
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 15 then 
				id = 160540
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 16 then 
				id = 160552
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 17 then 
				id = 160563
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			elseif _type == 18 then 
				id = 160566
				txtChipNum:setRelativePosition(GlobalMethod:ccp(0.034,0.95))
			end
			self.m_nChipNum = CacheCenter:getPlayerItemCountById(id)
			strName = GDatatab_item["id_" .. id].name .. ":"
		elseif _type == 90 then 
			WZLog("lllllllllllllllllllllll", type(self.m_tOtherData.chipPt))
			id = self.m_tOtherData.coinId
			if self.m_tOtherData.chipPt and bIsSetPos then 
				txtChipNum:setRelativePosition(self.m_tOtherData.chipPt)
			end
			self.m_nChipNum = CacheCenter:getPlayerItemCountById(id)
			strName = GDatatab_item["id_" .. id].name .. ":"
		else
			id = 160077
		end

		if _type == 1 then
			local itemInfo = GDatatab_item["id_"..id]
			if itemInfo then
				local str = [[<I Z="0.4" P="1">%s</I><T C="229,105,22" S="20" P="1">%d</T>]]
				txtChipNum:setShowText(string.format(str,itemInfo.icon,self.m_nChipNum))
			end
		else
			local str = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1">%s</T><T C="229,105,22" S="20" P="1">%d</T>]]
			if _type == 5 then 
				str = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1">%s</T><T C="255,255,255" S="20" P="1">%d</T>]]
			elseif _type == 6 then 
				str = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SS="4" SC="132,66,29" SE="1">%s</T><T C="255,236,193" S="20" P="1" SS="4" SC="132,66,29" SE="1">%d</T>]]
			end
			if type(id) == "table" then 
				local strContent = ""
				for i = 1, #id do
					self.m_nChipNum = CacheCenter:getPlayerItemCountById(id[i])
					local itemInfo = GDatatab_item["id_"..id[i]]
					if itemInfo then 
						strName = itemInfo.name .. ":"
						if i > 1 then 
							strContent = strContent .. [[<BL>20</BL>]]
						end
						strContent = strContent .. string.format(str, itemInfo.icon, strName, self.m_nChipNum)
					end
				end

				txtChipNum:setShowText(strContent)
			else
				local itemInfo = GDatatab_item["id_"..id]
				if itemInfo then
					txtChipNum:setShowText(string.format(str, itemInfo.icon, strName, self.m_nChipNum))
				end
			end
		end
	end
end
function WndDollMachineShop:setBuyChipResetData(id, todayBuy)
	local sort_id = nil
	for i=1, #self.m_tChipShopData do
		if self.m_tChipShopData[i].shopId == id then
			self.m_tChipShopData[i].canBuys = todayBuy
			sort_id = i
			break
		end
	end
	if sort_id and self.m_tCellItemChip[sort_id] then
		self.m_tCellItemChip[sort_id]:setDayLimit(todayBuy, self.m_tChipShopData[sort_id].todayLimit, self.m_tChipShopData[sort_id].totalLimit,
												  self.m_tChipShopData[sort_id].limitType)
	end
end

--@brief 	通用的商店函数
function WndDollMachineShop:setCommonResult(data, doType, result)
	if not data then return end

	self.m_nChipNum = data.scaleNum or 0
	if doType == self.m_tOtherData.doType_get then
		self.m_tChipShopData = self:setChipShopFishData(data)
		local chipTableContainer = GetElement(self.m_root,"chipTableContainer",WZUITableContainer)
		chipTableContainer:cleanTable()
		for i = 1, #self.m_tChipShopData do
	        local celElement,tCell = CellChipShopItem:createElement()
	        self.m_tCellItemChip[i] = tCell
			celElement:setTag(i-1)
	        chipTableContainer:setCellElement(celElement)
	        tCell:setChipShopItemData(self.m_tChipShopData[i], 1, self.m_nChipNum, self.m_tOtherData)
		end
		self:setChipNum(self.m_nType, true)
	elseif doType == self.m_tOtherData.doType_buy then --购买返回
		self:setChipNum(self.m_nType)
		if result == 0 then
			MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT35)
			if self.m_tOtherData.showBuyReward then 
				WndRewardShow:showById(data.itemIds, data.itemNums, nil, nil, nil, nil, nil, nil, nil, nil, nil, data.playerItemIds)
			end

			local strType = type(data.id)
			if strType == "table" then 
				for j = 1, #data.id do
					for i=1,#self.m_tChipShopData do
						if self.m_tChipShopData[i].id == data.id[j] then
							self.m_tChipShopData[i].soldNum = data.soldNum[j]
							self.m_tChipShopData[i].dailyBuyNum = data.dailyBuyNum[j]
							if self.m_tCellItemChip[i] then
								self.m_tCellItemChip[i]:setFishBuyData(self.m_tChipShopData[i].soldNum, self.m_tChipShopData[i].limitNum, self.m_nChipNum, 
														self.m_tChipShopData[i].dailyLimit, data.dailyBuyNum[j])
							end
							break
						end
					end
				end
			else
				for i=1,#self.m_tChipShopData do
					if self.m_tChipShopData[i].id == data.id then
						self.m_tChipShopData[i].soldNum = data.soldNum
						if self.m_tCellItemChip[i] then
							WZLog("WndDollMachineShop:setYearMonsterResult", self.m_tChipShopData[i].soldNum, self.m_tChipShopData[i].limitNum, self.m_nChipNum, 
													self.m_tChipShopData[i].dailyLimit, data.dailyBuyNum)
							self.m_tCellItemChip[i]:setFishBuyData(self.m_tChipShopData[i].soldNum, self.m_tChipShopData[i].limitNum, self.m_nChipNum, 
													self.m_tChipShopData[i].dailyLimit, data.dailyBuyNum)
						end
						break
					end
				end
			end
		elseif result == 4 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT132)
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
