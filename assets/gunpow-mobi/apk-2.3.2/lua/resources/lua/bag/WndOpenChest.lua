--WndOpenChest.lua
--@brief	WndOpenChest的UI模块
--@date		2015/09/17
--@author	zsq
--@note		开启宝箱


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndOpenChest:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndOpenChest:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end

--@brief	关闭
function WndOpenChest:onClose(element)
	WZLog("WndOpenChest:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	打开宝箱
function WndOpenChest:onClick(element)
	WZLog("WndOpenChest:onClick",self.playerItemId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCallBackFun and self.m_tCallBackFun[1] and self.m_tCallBackFun[2] then
		self.m_tCallBackFun[2](self.m_tCallBackFun[1], self.m_nNum)
		self:onClose()
		return
	end

	if self.m_nNum <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.CHESTTITLE)
		return
	end
	
	local tData = self.m_tData
	local level = CacheCenter:getPlayerInfo().level
	--兑换活动
	if self.exchange then
    	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(WndApartmentAct.activityId, tData.rewardId, self.m_nNum)
		self:onClose()
		return
	end

	if self.m_nWinType == 1 then --度假村能量
		WZLog("fdshfshfdshf", self.playerItemId, self.m_nNum)
		if self.playerItemId == 0 then
			MsgBoxManager:showTipBox(LocalStrings.TRANSACTION49)
			return
		end
		ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(self.playerItemId, self.m_nNum, "" )
		self:onClose()
		return 
	elseif self.m_nWinType == 2 then --祈福
		if self.m_tCellGrid then
			WndBlessBag:changeBlessNum(self.m_nNum,tData,self.m_tCellGrid)
		end
		self:onClose()
		return
	elseif self.m_nWinType == 3 then --宠物
		if self.m_tCellGrid then
			WndPetsUpgrade:changePetNum(self.m_nNum,self.tag,tData)
		end
		self:onClose()
		return
	end

	--用甜甜圈
	if tData.basicInfo.main_type == 2 and tData.basicInfo.sub_type == 2 then
		ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(self.playerItemId, self.m_nNum, "" )
		self:onClose()
		return
	end
	--用技能卡
	if tData.basicInfo.main_type == 2 and tData.basicInfo.sub_type == 14 then
		USESKILLBOOK = true
		ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(self.playerItemId, self.m_nNum, "" )
		self:onClose()
		return
	end
	--空间礼物
	if tData.basicInfo.main_type == 2 and tData.basicInfo.sub_type == 46 then
		ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(self.playerItemId, self.m_nNum, "" )
		self:onClose()
		return
	end
	--皮肤体验卡
	if tData.basicInfo.main_type == 20 and tData.basicInfo.sub_type == 1 then
		ProtocolProcessorPhantom:send_SHAPE_UseItem(self.playerItemId, self.m_nNum)
		self:onClose()
		return
	end
	--竞技加速
	if tData.basicInfo.main_type == 2 and (tData.basicInfo.sub_type == 12 or tData.basicInfo.sub_type == 13) then
		ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(self.playerItemId, self.m_nNum, "" )

		local exp = tData.basicInfo.property[1][2]
		local count = tData.basicInfo.value
		WZLog("WndOpenChest:onClick2",exp)
		local str = LocalStrings.ARENA_CARD_TIME_TIP
		if tData.basicInfo.sub_type == 12 then
			str = LocalStrings.ARENA_CARD_DAY_TIP
			count = math.ceil(count / 1440)
		end

		MsgBoxManager:showTipBox(string.format(str,exp,self.m_nNum*count), nil, nil, nil, nil)
		self:onClose()
		return
	end
	--判断是否达到等级
	if tonumber(level) < tonumber(tData.basicInfo.use_level) then
		MsgBoxManager:showTipBox(LocalStrings.OPENGIFTLEVEL)
		return
	end
	if tData.basicInfo.sub_type == 4 then
		--宝箱不足
		if self.m_nNum > self.m_nChestNum then
			MsgBoxManager:showTipBox(LocalStrings.NOTENOUTH2)
        	--checkIsOnSale(self.m_tChest.basicInfo.id,LocalStrings.CHESTNOKEY)--打开购买窗口
			WndFastGetItems:show(self.m_tChest.basicInfo.id,LocalStrings.CHESTNOKEY)
			return
		end
		--钥匙不足
		if self.m_nNum > self.m_nKeyNum then
			MsgBoxManager:showTipBox(LocalStrings.NOTENOUTH3)
        	--checkIsOnSale(self.m_tKey.basicInfo.id,LocalStrings.CHESTNOKEY)--打开购买窗口
			WndFastGetItems:show(self.m_tKey.basicInfo.id,LocalStrings.CHESTNOKEY)
			return
		end
	elseif tData.basicInfo.sub_type == 2 or tData.basicInfo.sub_type == 3 then
		WZLog("WndOpenChest:onClick_2", self.m_nNum, self.m_nChestNum)
		--宝箱不足
		if self.m_nNum > self.m_nChestNum then
			MsgBoxManager:showTipBox(LocalStrings.NOTENOUTH2)
        	--checkIsOnSale(self.m_tChest.basicInfo.id,LocalStrings.CHESTNOKEY)--打开购买窗口
			WndFastGetItems:show(self.m_tChest.basicInfo.id,LocalStrings.CHESTNOKEY)
			return
		end
		--钥匙不足
		if self.m_nNum > self.m_nKeyNum then
			MsgBoxManager:showTipBox(LocalStrings.NOTENOUTH3)
        	--checkIsOnSale(self.m_tKey.basicInfo.id,LocalStrings.CHESTNOKEY)--打开购买窗口
			WndFastGetItems:show(self.m_tKey.basicInfo.id,LocalStrings.CHESTNOKEY)
			return
		end
	elseif tData.basicInfo.sub_type == 0 or tData.basicInfo.sub_type == 1 then
		--礼包不足
		if self.m_nNum > self.m_nGiftNum then
			MsgBoxManager:showTipBox(LocalStrings.NOTENOUTH1)
			return
		end
	end
	ProtocolProcessorRecycling:send_PLAYERITEM_OpenGift(self.playerItemId, self.m_nNum )
	self:onClose()
end

--@brief	减少10个
function WndOpenChest:onMutiReduce(element)
	WZLog("WndOpenChest:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 10 then
		self.m_nNum = self.m_nNum - 10
	else
		self.m_nNum = 1
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	if self.exchange then
		self.m_tData.lastNum = self.m_nGridNum * self.m_nNum
		self.m_tGrid:setCellGoodItem(self.m_tData, 4)
	end
end

--@brief	减少1个
function WndOpenChest:onReduce(element)
	WZLog("WndOpenChest:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	if self.exchange then
		self.m_tData.lastNum = self.m_nGridNum * self.m_nNum
		self.m_tGrid:setCellGoodItem(self.m_tData, 4)
	end
end

--@brief	增加10个
function WndOpenChest:onMutiAdd(element)
	WZLog("WndOpenChest:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

		--经验宠物
	if self.m_nWinType == 3 then
		local curPetInfo = WndPets:getCurPetInfo()
		--使用经验宠物，判断是否达到上限
		local nextExp = self:getNextPetExp(curPetInfo)
		--单个宠物增加的经验
		local canExp = self.m_tData.giftSkill
		if canExp *(self.m_nNum + 10) > nextExp then
			MsgBoxManager:showTipBox(LocalStrings.PETUPTOLEVEL)
		end
		if self.m_nNum + 10 <= self.m_nMaxNum then
			self.m_nNum = self.m_nNum + 10
		else
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		end
		if self.m_nNum == 0 then self.m_nNum = 1 end
		GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
		return
	end
	--使用加体力物品，要判断是否达到上限
	local tData = self.m_tData
	if (not self.exchange) and tData.basicInfo and tData.basicInfo.main_type == 2 and tData.basicInfo.sub_type == 2 then
		if CacheCenter:getPlayerInfo().vigor + tData.basicInfo.value*10*(self.m_nNum + 1) > 1000 then
			MsgBoxManager:showTipBox(LocalStrings.VIGOR_MAX)
			return
		end
	end
	if self.m_nNum < self.m_nMaxNum - 10 then
		self.m_nNum = self.m_nNum + 10
	else
		self.m_nNum = self.m_nMaxNum
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	if self.exchange then
		self.m_tData.lastNum = self.m_nGridNum * self.m_nNum
		self.m_tGrid:setCellGoodItem(self.m_tData, 4)
	end
end

--@brief 从当前宠物等级到角色玩家等级锁需要的经验
function WndOpenChest:getNextPetExp(petInfo)
	local curLv = petInfo.upgradeLevel
	local curExp = petInfo.petExp
	local paleyLv =  math.min(CacheCenter:getPlayerInfo().level, tonumber(CacheCenter:getGameParam().gameMaxLevel))
	local quality = GDatatab_item["id_"..petInfo.itemId].quality
	local hasExp = 0
	if  curLv == 1 then
		hasExp = 0 + curLv
	else
		local id = curLv - 1
		hasExp = self:getTotalExp(id, quality).total_exp + curExp
	end
	local nextExp = math.max(self:getTotalExp(paleyLv-1,quality).total_exp-hasExp,0)
	return nextExp
end

function WndOpenChest:getTotalExp(level,quality)
	for  k,v in pairs(GDatatab_pet_upgrade) do
      if v.quality == quality and v.level ==  level then
          return v
      end
    end
    return {total_exp=999999999999}
end

--@brief	增加1个
function WndOpenChest:onAdd(element)
	WZLog("WndOpenChest:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--经验宠物
	if self.m_nWinType == 3 then
		local curPetInfo = WndPets:getCurPetInfo()
		--使用经验宠物，判断是否达到上限
		local nextExp = self:getNextPetExp(curPetInfo)
		--单个宠物增加的经验
		local canExp = self.m_tData.giftSkill
		if canExp *(self.m_nNum + 1) > nextExp then
			MsgBoxManager:showTipBox(LocalStrings.PETUPTOLEVEL)
		end
		WZLog("增加一个",self.m_nNum,self.m_nMaxNum)
		if self.m_nNum + 1 <= self.m_nMaxNum then
			self.m_nNum = self.m_nNum + 1
		else
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
		end
		if self.m_nNum == 0 then self.m_nNum = 1 end
		GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
		return
	end
	--使用加体力物品，要判断是否达到上限
	local tData = self.m_tData
	if (not self.exchange) and tData.basicInfo and tData.basicInfo.main_type == 2 and tData.basicInfo.sub_type == 2 then
		if CacheCenter:getPlayerInfo().vigor + tData.basicInfo.value*(self.m_nNum + 1) > 1000 then
			MsgBoxManager:showTipBox(LocalStrings.VIGOR_MAX)
			return
		end
	end
	if self.m_nNum + 1 <= self.m_nMaxNum then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	if self.exchange then
		self.m_tData.lastNum = self.m_nGridNum * self.m_nNum
		self.m_tGrid:setCellGoodItem(self.m_tData, 4)
	end
end

--@brief	点击宝箱
function WndOpenChest:onClickChest()
    WndItemInfo:showInfo(GetElement(self.m_root,"con1_WndOpenChest",WZUIContainer),self.m_root,1,self.m_tChest,false)
end

--@brief	点击钥匙
function WndOpenChest:onClickKey()
    WndItemInfo:showInfo(GetElement(self.m_root,"con2_WndOpenChest",WZUIContainer),self.m_root,1,self.m_tKey,false)
end

--@brief	点击礼包
function WndOpenChest:onClickGift()
    WndItemInfo:showInfo(GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer),self.m_root,1,self.m_tGift,false)
end

--@brief	点击窗口
function WndOpenChest:onTouchBegan()
	if WndItemInfo then
		WndItemInfo:onCloseClick()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置数据
function WndOpenChest:setData(tData)
	if tData == nil then return end
	self.exchange = false
	self.m_tData = tData
	self.playerItemId = tData.playerItemId
	
	local maxNum = 1000
	local tPetEggIds = {118,207,208,209,210,211,212,299,320} --宠物蛋 越南要求最大开启100个
	for i=1,#tPetEggIds do
		if tPetEggIds[i] == self.m_tData.basicInfo.id then
			maxNum = 100
			break
		end
	end
	local num = math.min(maxNum, tData.lastNum)
	self.m_nNum = num
	if tData.basicInfo.number and tData.basicInfo.number ~= 0 then
		self.m_nNum = tData.basicInfo.number or self.m_nNum
	end
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	WZLog("WndOpenChest:setData", num, self.m_nNum, Serialize(self.m_tData))
	self:update()
	local txtExplanation_WndOpenChest = GetElement(self.m_root,"txtExplanation_WndOpenChest",WZUILabelTTF)
	if txtExplanation_WndOpenChest then
		txtExplanation_WndOpenChest:setText(LocalStrings.OPENCHEST1)
	end
end

--@brief 	设置按钮回调
function WndOpenChest:setCallback(tCell, func)
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief 	设置神秘商店活动数据
-- tOther maxNum:最大数量 title:标题 btnText:按钮字
function WndOpenChest:setMysteriousShopData(tData, tOther)
	if tData == nil then return end
	self.m_nWinType = 4
	self.m_tData = tData
	self.playerItemId = tData.itemId
	self.m_tOther = tOther
	self.m_nNum = 1
	self.m_nMaxNum = tOther.maxNum

	local strContent = self.m_tOther.strExplanation or string.format(LocalStrings.PETNOTUPONE3, self.m_nMaxNum)
	GetElement(self.m_root,"txtExplanation_WndOpenChest",WZUILabelTTF):setText(strContent)

	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	GetElement(self.m_root,"title_WndOpenChest",WZUILabelTTF):setText(tOther.title)
	GetElement(self.m_root,"txtApplyAttendCommunity_WndOpenChest",WZUILabelTTF):setText(tOther.btnText)

	GetElement(self.m_root,"imgAdd_WndOpenChest",WZUIImage):setVisible(false)
    local celElement,tLuaObj = CellGoodItem:createElement()
    tLuaObj:setCellGoodLocalId(tData.itemId, tData.itemNum, 17)
	tLuaObj:setItemClickFun(self, self.onClickItem)
    GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
	GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):addChild(celElement)
end

--@brief 	设置宠物数据
function WndOpenChest:setPetData(tData,tag, tCell, nMaxNum)
	if tData == nil then return end
	self.m_nWinType = 3
	self.m_tCellGrid = tCell
	self.tag = tag
	self.exchange = false
	self.m_tData = tData
	self.playerItemId = tData.itemId
	local num = math.min(1000, nMaxNum)
	self.m_nNum = num
	self.m_nMaxNum = num
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	self:updateView()
	GetElement(self.m_root,"txtExplanation_WndOpenChest",WZUILabelTTF):setText(string.format(LocalStrings.PETNOTUPONE3, self.m_nMaxNum))
end

--@brief 	设置宠物数据
function WndOpenChest:setBlessData(tData, tCell, nMaxNum)
	if tData == nil then return end
	self.m_nWinType = 2
	self.m_tCellGrid = tCell
	self.m_tData = tData
	self.playerItemId = tData.item_id
	local num = math.min(1000, nMaxNum)
	self.m_nNum = num
	self.m_nMaxNum = num
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	self:updateBlessView()
	GetElement(self.m_root,"txtExplanation_WndOpenChest",WZUILabelTTF):setText(string.format(LocalStrings.PETNOTUPONE3, self.m_nMaxNum))
end

--@brief	设置兑换数据
function WndOpenChest:setExchangeData(tData)
	if tData == nil then return end
	self.exchange = true
	self.m_tData = tData
	self.playerItemId = tData.playerItemId
	self.m_nNum = 1
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	WZLog("WndOpenChest:setData", num, self.m_nNum, Serialize(self.m_tData))
	self:showExchange()
end

--@brief 	设置度假村能量数据
function WndOpenChest:setHVEnergyData(tData, luaTable)
	if tData == nil then return end
	self.m_tLuaTable = luaTable
	self.m_nWinType = 1
	self.m_tData = tData
	local itemData = CacheCenter:getPlayerItemById(tData[1])
	if itemData == nil then
		itemData = {playerItemId = 0}
	end
	self.playerItemId = itemData.playerItemId
	local ownNum = self.m_tLuaTable:getItemCountByItemId(tData[1])
	local num = math.min(100, ownNum)
	self.m_nNum = 1
	self.m_nMaxNum = num
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	self:updateHVView()
	GetElement(self.m_root,"txtExplanation_WndOpenChest",WZUILabelTTF):setText(string.format(LocalStrings.PETNOTUPONE3, self.m_nMaxNum))
end

--@brief 	设置标题和按钮字
function WndOpenChest:setStaticText()
	-- body
	if self.m_tData.basicInfo.main_type == 2 then
		GetElement(self.m_root,"title_WndOpenChest",WZUILabelTTF):setText(LocalStrings.USE_THINGS)
		GetElement(self.m_root, "txtApplyAttendCommunity_WndOpenChest", WZUILabelTTF):setText(LocalStrings.USE)
	else
		GetElement(self.m_root,"title_WndOpenChest",WZUILabelTTF):setText(LocalStrings.OPENGIFT)
		GetElement(self.m_root, "txtApplyAttendCommunity_WndOpenChest", WZUILabelTTF):setText(LocalStrings.MAP_EVENT_ON)
	end
end

function WndOpenChest:updateBlessView()
	WZLog("显示经验祈福item")
	GetElement(self.m_root,"imgAdd_WndOpenChest",WZUIImage):setVisible(false)
	GetElement(self.m_root,"title_WndOpenChest",WZUILabelTTF):setText(LocalStrings.USE_THINGS)
	GetElement(self.m_root, "txtApplyAttendCommunity_WndOpenChest", WZUILabelTTF):setText(LocalStrings.CONFIRM)
	local itemid = self.playerItemId
	local key = "id_"..itemid
	if GDatatab_item[key] then
	    local name = GDatatab_item[key].name
	    local path = GDatatab_item[key].icon
	    local quality = GDatatab_item[key].quality
	    local num = self.m_tData.num
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
	    local celElement,tLuaObj = CellGoodItem:createElement()
	    tLuaObj:setCellGoodItem(itemInfo, 17)

		tLuaObj:setItemClickFun(self, self.onClickPet)
	    GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
		GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):addChild(celElement)
	end
end

function WndOpenChest:updateView()
	local itemid = self.playerItemId
	local key = "id_"..itemid
	WZLog("经验宠物分类",key,GDatatab_item[key].main_type,GDatatab_item[key].sub_type)
	if GDatatab_item[key].main_type == 10 and GDatatab_item[key].sub_type == 0 then
		self:showPet()
		return
	end
end

function WndOpenChest:showPet()
	-- body
	-- 	WZLog("WndOpenChest:showGift", Serialize(self.m_tData))
	-- GetElement(self.m_root,"imgAdd_WndOpenChest",WZUIImage):setVisible(false)
	-- self:setStaticText()
	-- local giftNum = 0
	-- local dataList = CacheCenter:getPropList()
	-- for i=1,#dataList do
	-- 	if dataList[i].basicInfo.id == self.m_tData.basicInfo.id then
	-- 	    local celElement,tLuaObj = CellGoodItem:createElement()
 --            tLuaObj:setCellGoodItem(dataList[i], 4)
 --            tLuaObj:setItemClickFun(self, self.onClickGift)
	-- 		GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
	-- 		GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):addChild(celElement)
	-- 		giftNum = dataList[i].lastNum
	-- 		self.playerItemId = dataList[i].playerItemId
	-- 		self.m_tGift = dataList[i]
	-- 	end
	-- end

	-- self.m_nGiftNum = giftNum
	-- --计算可以打开的礼包的最大个数
	-- self.m_nMaxNum = math.min(100,giftNum)
	-- if giftNum <= 0 then
	-- 	WindowManager:removeWindow(self.m_root, self, true)
	-- end
	WZLog("显示经验宠物item")
	GetElement(self.m_root,"imgAdd_WndOpenChest",WZUIImage):setVisible(false)
	GetElement(self.m_root,"title_WndOpenChest",WZUILabelTTF):setText(LocalStrings.USE_THINGS)
	GetElement(self.m_root, "txtApplyAttendCommunity_WndOpenChest", WZUILabelTTF):setText(LocalStrings.CONFIRM)
	local itemid = self.playerItemId
	local key = "id_"..itemid
	if GDatatab_item[key] then
	    local name = GDatatab_item[key].name
	    local path = GDatatab_item[key].icon
	    local quality = GDatatab_item[key].quality
	    local num = self.m_tData.num
		local itemInfo = {name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
	    local celElement,tLuaObj = CellGoodItem:createElement()
	    tLuaObj:setCellGoodItem(itemInfo, 17)

		tLuaObj:setItemClickFun(self, self.onClickPet)
	    GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
		GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):addChild(celElement)
	end
end

--@brief 点击宠物
function WndOpenChest:onClickPet(tCell,tag,tData)
	-- body
	WZLog("经验宠物数据",Serialize(tData))
	WndItemInfo:showInfo(GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer),self.m_root,1,tData,false)
end

--@brief 更新界面
function WndOpenChest:update()

	local tData = self.m_tData
	local keyID, chestID

	--甜甜圈
	if tData.basicInfo.main_type == 2 then
		self:showGift()
		return
	end
	if tData.basicInfo.sub_type == 4 then
		--钥匙
		keyID = tData.basicInfo.id
		chestID = tData.basicInfo.value
		self:showChestAndKey(chestID,keyID)
	elseif tData.basicInfo.sub_type == 2 or tData.basicInfo.sub_type == 3 then
		--宝箱
		keyID = tData.basicInfo.value
		chestID = tData.basicInfo.id
		self:showChestAndKey(chestID,keyID)
	elseif tData.basicInfo.sub_type == 0 or tData.basicInfo.sub_type == 1 or tData.basicInfo.sub_type == 5 or tData.basicInfo.sub_type == 6 then
		self:showGift()
	end
end

--@brief	显示宝箱和钥匙
function WndOpenChest:showChestAndKey(chestID,keyID)
	GetElement(self.m_root,"imgAdd_WndOpenChest",WZUIImage):setVisible(true)
	self:setStaticText()
	local keyNum = 0
	local chestNum = 0
	local dataList = CacheCenter:getPropList()
	for i=1,#dataList do
		if dataList[i].basicInfo.id == chestID then
		    local celElement,tLuaObj = CellGoodItem:createElement()
            tLuaObj:setCellGoodItem(dataList[i], 4)
            tLuaObj:setItemClickFun(self, self.onClickChest)
			GetElement(self.m_root,"con1_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
			GetElement(self.m_root,"con1_WndOpenChest",WZUIContainer):addChild(celElement)
			chestNum = dataList[i].lastNum
			self.playerItemId = dataList[i].playerItemId
			self.m_tChest = dataList[i]
		end
		if dataList[i].basicInfo.id == keyID then
		    local celElement,tLuaObj = CellGoodItem:createElement()
            tLuaObj:setCellGoodItem(dataList[i], 4)
            tLuaObj:setItemClickFun(self, self.onClickKey)
			GetElement(self.m_root,"con2_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
			GetElement(self.m_root,"con2_WndOpenChest",WZUIContainer):addChild(celElement)
			keyNum = dataList[i].lastNum
			self.m_tKey = dataList[i]
		end
	end
	local num = math.min(keyNum, chestNum)
	self.m_nNum = num
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)

	--没有宝箱显示0个宝箱
	if chestNum == 0 then
        local key = "id_"..chestID
        if GDatatab_item[key] ~= nil then
            local name = GDatatab_item[key].name
            local path = GDatatab_item[key].icon
            local num = 0
            local quality = GDatatab_item[key].quality
            local itemInfo = {name=name,icon=path,isZero=true,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
            tLuaObj:setCellGoodItem(itemInfo, 4)
            tLuaObj:setItemClickFun(self, self.onClickChest)
			GetElement(self.m_root,"con1_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
			GetElement(self.m_root,"con1_WndOpenChest",WZUIContainer):addChild(celElement)
			self.m_tChest = itemInfo
		end
	end
	--没有钥匙显示0个钥匙
	if keyNum == 0 then
        local key = "id_"..keyID
        if GDatatab_item[key] ~= nil then
            local name = GDatatab_item[key].name
            local path = GDatatab_item[key].icon
            local num = 0
            local quality = GDatatab_item[key].quality
            local itemInfo = {name=name,icon=path,isZero=true,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key])}
		    local celElement,tLuaObj = CellGoodItem:createElement()
            tLuaObj:setCellGoodItem(itemInfo, 4)
            tLuaObj:setItemClickFun(self, self.onClickKey)
			GetElement(self.m_root,"con2_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
			GetElement(self.m_root,"con2_WndOpenChest",WZUIContainer):addChild(celElement)
			self.m_tKey = itemInfo
		end
	end

	self.m_nChestNum = chestNum
	self.m_nKeyNum = keyNum
	--计算可以打开的宝箱的最大个数
	self.m_nMaxNum = math.min(1000,chestNum)
	if chestNum <= 0 then
		--WindowManager:removeWindow(self.m_root, self, true)
		GetElement(self.m_root, "txtApplyAttendCommunity_WndOpenChest", WZUILabelTTF):setText(LocalStrings.GET)
	end
end

--@brief	显示礼包
function WndOpenChest:showGift()
	WZLog("WndOpenChest:showGift", Serialize(self.m_tData))
	GetElement(self.m_root,"imgAdd_WndOpenChest",WZUIImage):setVisible(false)
	self:setStaticText()
	local giftNum = 0
	local dataList = CacheCenter:getPropList()
	for i=1,#dataList do
		if dataList[i].basicInfo.id == self.m_tData.basicInfo.id then
		    local celElement,tLuaObj = CellGoodItem:createElement()
            tLuaObj:setCellGoodItem(dataList[i], 4)
            tLuaObj:setItemClickFun(self, self.onClickGift)
			GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
			GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):addChild(celElement)
			giftNum = dataList[i].lastNum
			self.playerItemId = dataList[i].playerItemId
			self.m_tGift = dataList[i]
		end
	end

	self.m_nGiftNum = giftNum
	--计算可以打开的礼包的最大个数
	local maxNum = 1000
	local tPetEggIds = {118,207,208,209,210,211,212,299,320} --宠物蛋 越南要求最大开启100个
	for i=1,#tPetEggIds do
		if tPetEggIds[i] == self.m_tData.basicInfo.id then
			maxNum = 100
			break
		end
	end
	self.m_nMaxNum = math.min(maxNum,giftNum)
	if giftNum <= 0 then
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief	显示兑换
function WndOpenChest:showExchange()
	WZLog("WndOpenChest:showExchange", Serialize(self.m_tData))
	GetElement(self.m_root,"imgAdd_WndOpenChest",WZUIImage):setVisible(false)
	GetElement(self.m_root,"title_WndOpenChest",WZUILabelTTF):setText(LocalStrings.EXCHANGE1)
	GetElement(self.m_root, "txtApplyAttendCommunity_WndOpenChest", WZUILabelTTF):setText(LocalStrings.duihuan)

	local maxNum = 0
		    local celElement,tLuaObj = CellGoodItem:createElement()
            tLuaObj:setCellGoodItem(self.m_tData, 4)
            tLuaObj:setItemClickFun(self, self.onClickGift)
			GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):removeAllChildrenWithCleanup(true)
			GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer):addChild(celElement)
			maxNum = self.m_tData.maxNum
			self.playerItemId = self.m_tData.playerItemId
			self.m_tGift = self.m_tData
			self.m_tGrid = tLuaObj
			self.m_nGridNum = self.m_tData.unitNum

	self.m_nGiftNum = maxNum
	--计算可以打开的礼包的最大个数
	self.m_nMaxNum = math.min(1000,maxNum)
	GetElement(self.m_root,"txtExplanation_WndOpenChest",WZUILabelTTF):setText(string.format(LocalStrings.EXCHANGE2, tostring(self.m_nMaxNum)))
	if maxNum <= 0 then
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--@brief 	显示使用能量药水
function WndOpenChest:updateHVView()
	GetElement(self.m_root,"imgAdd_WndOpenChest",WZUIImage):setVisible(false)
	GetElement(self.m_root,"title_WndOpenChest",WZUILabelTTF):setText(LocalStrings.USE_THINGS)
	GetElement(self.m_root, "txtApplyAttendCommunity_WndOpenChest", WZUILabelTTF):setText(LocalStrings.USE)

	local itemNum = #self.m_tData
	if itemNum == 1 then 
		local celElement,tLuaObj = CellGoodItem:createElement()
		local ownNum = self.m_tLuaTable:getItemCountByItemId(self.m_tData[1])
	    tLuaObj:setCellGoodLocalId(self.m_tData[1], ownNum, 4)
	    tLuaObj:setItemClickFun(self, self.onClickItem)

		local con3 = GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer)
		con3:removeAllChildrenWithCleanup(true)
		con3:addChild(celElement)
	elseif itemNum == 2 then 
		for i = 1, itemNum do
			local celElement,tLuaObj = CellGoodItem:createElement()
			local ownNum = self.m_tLuaTable:getItemCountByItemId(self.m_tData[i])
			local info = GDatatab_item["id_" .. self.m_tData[i]]
			local itemInfo = {id=self.m_tData[i], name=info.name,icon=info.icon,lastNum=ownNum,basicInfo=CopyTable(info), rootNode = self.m_root, bShowAll = false}
		    tLuaObj:setCellGoodItem(itemInfo, 31)
		    tLuaObj:setItemClickFun(self, self.onClickItem2)

			local con = GetElement(self.m_root,"con" .. i .. "_WndOpenChest",WZUIContainer)
			con:removeAllChildrenWithCleanup(true)
			con:addChild(celElement)
			if self.m_tSelItem == nil then 
				tLuaObj:setItemSelState(true)
				self.m_tSelItem = tLuaObj
			end
		end
	elseif itemNum == 3 then 
		for i = 1, itemNum do
			local celElement,tLuaObj = CellGoodItem:createElement()
			local ownNum = self.m_tLuaTable:getItemCountByItemId(self.m_tData[i])
			local info = GDatatab_item["id_" .. self.m_tData[i]]
			local itemInfo = {id=self.m_tData[i], name=info.name,icon=info.icon,lastNum=ownNum,basicInfo=CopyTable(info), rootNode = self.m_root, bShowAll = false, isZero = true}
		    tLuaObj:setCellGoodItem(itemInfo, 31)
		    tLuaObj:setItemClickFun(self, self.onClickItem2)

			local con = GetElement(self.m_root,"con1_WndOpenChest",WZUIContainer)
			if i == 2 then 
				con = GetElement(self.m_root,"con3_WndOpenChest",WZUIContainer)
			elseif i == 3 then 
				con = GetElement(self.m_root,"con2_WndOpenChest",WZUIContainer)
			end
			con:removeAllChildrenWithCleanup(true)
			con:addChild(celElement)
			if self.m_tSelItem == nil then 
				tLuaObj:setItemSelState(true)
				self.m_tSelItem = tLuaObj
			end
		end
	end
end

--@brief 	点击物品图标回调
function WndOpenChest:onClickItem(tItem, nTag, tData)
	WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root, self.m_root, 1,tData, false)
end

--@brief 	点击物品图标回调
function WndOpenChest:onClickItem2(tItem, nTag, tData)
	if self.m_tSelItem then 
		local selData = self.m_tSelItem:getData()
		if selData.id == tData.id then return end 
		self.m_tSelItem:setItemSelState(false)
	end

	self.m_tSelItem = tItem 
	self.m_tSelItem:setItemSelState(true)
	local itemData = CacheCenter:getPlayerItemById(tData.id)
	if itemData == nil then
		itemData = {playerItemId = 0}
	end
	self.playerItemId = itemData.playerItemId
	local ownNum = self.m_tLuaTable:getItemCountByItemId(tData.id)
	local num = math.min(100, ownNum)
	self.m_nNum = 1
	self.m_nMaxNum = num
	GetElement(self.m_root,"useNum_WndOpenChest",WZUILabelTTF):setText(self.m_nNum)
	GetElement(self.m_root,"txtExplanation_WndOpenChest",WZUILabelTTF):setText(string.format(LocalStrings.PETNOTUPONE3, self.m_nMaxNum))
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------语言适配Begin---------------------------------------------
function WndOpenChest:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtApplyAttendCommunity_WndOpenChest",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "txtExplanation_WndOpenChest", WZUILabelTTF):setFontSize(18)
end

function WndOpenChest:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtApplyAttendCommunity_WndOpenChest",WZUILabelTTF):setScale(0.8)
	local txtExplanation = GetElement(self.m_root, "txtExplanation_WndOpenChest", WZUILabelTTF)
	txtExplanation:setFontSize(18)
	txtExplanation:setDimensions(GlobalMethod:CCSize(330,0))
end

function WndOpenChest:_adaptLanguage_ug(  )
    GetElement(self.m_root, "txtExplanation_WndOpenChest", WZUILabelTTF):setDimensions(GlobalMethod:CCSize(360))
end
--------------------------------语言适配End------------------------------------------
