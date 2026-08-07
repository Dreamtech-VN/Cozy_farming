--WndFirstReCharge.lua
--@brief	WndFirstReCharge的UI模块
--@date		2021/05/06
--@author	hyx
--@note		新版首冲


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFirstReCharge:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFirstReCharge:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndFirstReCharge:showInterface(index)
	local wndRechaege = WndFirstReCharge:createElement()
	if wndRechaege ~= nil then
		WindowManager:addWindow(wndRechaege,WndFirstReCharge,nil,false)
	end
	self.m_nCurIndex = index or 1
end
function WndFirstReCharge:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetRechargeRewardInfo,self)
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetRewardResult,self)
	GlobalGame:getGameEventDispathcer():Add(Independent_Activity.ActivityReddot, self.showRedDot, self)
end
function WndFirstReCharge:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_FestivalLogin,self._onGetRechargeRewardInfo,self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetInfo,self._onGetRewardResult,self)
	GlobalGame:getGameEventDispathcer():Remove(Independent_Activity.ActivityReddot, self.showRedDot, self)
end

function WndFirstReCharge:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFirstReCharge:actionCallback()
	self:initShow()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.activity7012, 7012)
end
function WndFirstReCharge:initShow()
	for i=1,3 do
		local tab = {}
		local btn = GetElement(self.m_root,"btn"..i,WZUIButton)
		tab.normal = GetElement(btn,"normal",WZUIImage)
		tab.select = GetElement(btn,"select",WZUIImage)
		tab.name = GetElement(btn,"name",WZUILabelTTF)
		tab.name:setText(LocalStrings.NEWFIRSTCHARGE_TEXT1[i])
		self.m_tBtnChangeTitle[i] = tab
	end
	self.m_tBtnChangeTitle[self.m_nCurIndex].normal:setVisible(false)
	self.m_tBtnChangeTitle[self.m_nCurIndex].select:setVisible(true)
	self.m_tBtnChangeTitle[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(255,255,194))
	self:showRedDot()
end

function WndFirstReCharge:onBtnChangeTitle(element)
	local tag = element:getTag()

	if tag == self.m_nCurIndex then return end
	if self.m_tBtnChangeTitle[self.m_nCurIndex] then
		self.m_tBtnChangeTitle[self.m_nCurIndex].normal:setVisible(true)
		self.m_tBtnChangeTitle[self.m_nCurIndex].select:setVisible(false)
		self.m_tBtnChangeTitle[self.m_nCurIndex].name:setColor(GlobalMethod:ccc3(155,171,234))
	end
	if self.m_tBtnChangeTitle[tag] then
		self.m_tBtnChangeTitle[tag].normal:setVisible(false)
		self.m_tBtnChangeTitle[tag].select:setVisible(true)
		self.m_tBtnChangeTitle[tag].name:setColor(GlobalMethod:ccc3(255,255,194))
	end

	self:setVisibleView(tag)
	self.m_nCurIndex = tag
end

function WndFirstReCharge:setVisibleView(tag)
	if not self.m_root then return end

	GetElement(self.m_root,"first1_con",WZUIContainer):setVisible(tag == 1)
	GetElement(self.m_root,"first2_con",WZUIContainer):setVisible(tag == 2)
	GetElement(self.m_root,"first3_con",WZUIContainer):setVisible(tag == 3)

	if self.m_tTouchView[tag] == true then return end
	self.m_tTouchView[tag] = true
	if tag == 2 or tag == 3 then
		if self.m_tChargeNumData[tag] then
			local freeTxtChargeDesc = GetElement(self.m_root,"freeTxtChargeDesc"..tag,WZUIFreeTextBox)
			freeTxtChargeDesc:setShowText(string.format(LocalStrings.NEWFIRSTCHARGE_TEXT3,self.m_tChargeNumData[tag].progress))

			local txtChargeProgressNum = GetElement(self.m_root,"txtChargeProgressNum"..tag, WZUILabelTTF)
			if txtChargeProgressNum then
				txtChargeProgressNum:setText(self.m_tChargeNumData[tag].progress.."/"..self.m_tChargeNumData[tag].target)
			end
			local chargeProgress = GetElement(self.m_root,"chargeProgress"..tag,WZUIProgress)
			local count = self.m_tChargeNumData[tag].progress / self.m_tChargeNumData[tag].target * 100
			if count >= 100 then
				count = 100
			end
			chargeProgress:setPercentage(count)
		end
	end
	if self.m_tChargeNumData[tag] then
		local btnRecharge = GetElement(self.m_root,"btnRecharge",WZUIButton)
		if self.m_tChargeNumData[tag].progress >= self.m_tChargeNumData[tag].target then
			btnRecharge:setVisible(false)
		else
			btnRecharge:setVisible(true)
		end
	end

	self:createCellFirstItem(tag)
end
function WndFirstReCharge:createCellFirstItem(tag)
	if not self.m_root then return end

	local data = self:getRechargeRewardData(tag)
	--WZLog("WndFirstReCharge:createCellFirstItem tag", tag)
	--WZLog("WndFirstReCharge:createCellFirstItem", Serialize(data))
	self:taskTableSort(data)
	local firstFreeList = nil
	if tag == 1 then
		firstFreeList = GetElement(self.m_root,"first1FreeList",WZUIFreeListContainer)
		firstFreeList:removeAll()

		self:showDress(1)
	elseif tag == 2 then
		firstFreeList = GetElement(self.m_root,"first2FreeList",WZUIFreeListContainer)
		firstFreeList:removeAll()

		self:showDress(2)
	elseif tag == 3 then
		firstFreeList = GetElement(self.m_root,"first3FreeList",WZUIFreeListContainer)
		firstFreeList:removeAll()

		self:showDress(3)
	end
	if firstFreeList then
		for i = 1, #data do
			local element, tLuaObj = CellFirstItem:createElement()
			firstFreeList:pushBack(WZUIContainer:luaTo(element))
			firstFreeList:getMoveElement():setPositionX(firstFreeList:getMaxPosition().x)
			tLuaObj:setCellItemData(tag, data[i], self.m_tChargeNumData[tag])
		end
	end
end

--时装展示
function WndFirstReCharge:showDress(tag)
	local itemId
	local conDress
	if tag == 1 then
		itemId = self.m_nDressGiftId1
		conDress = GetElement(self.m_root,"fashionCon1",WZUIContainer)
	elseif tag == 2 then
		itemId = self.m_nWingId
		conDress = GetElement(self.m_root,"wingCon",WZUIContainer)
	elseif tag == 3 then
		itemId = self.m_nDressGiftId
		conDress = GetElement(self.m_root,"fashionCon",WZUIContainer)
	end

	-- xml中写死了显示武器图片
	if tag == 2 then
		local itemInfo = GDatatab_item["id_"..itemId]
		if itemInfo.main_type == 4 and (itemInfo.sub_type == 0 or itemInfo.sub_type == 1) then -- 武器
			return
		end 
	end
		
	local nSex = CacheCenter:getPlayerInfo().sex
	local roleConPlayer = YDPlayerAnimation:createAnimation(nSex == 0)
	roleConPlayer:getAnimNode():setTag(50)
	roleConPlayer:getAnimNode():setTouchEnable(false)
	conDress:addChild(roleConPlayer:getAnimNode())

	local head, face, body, wing = nil, nil, nil, nil
	--设置默认显示
	local gameParam = CacheCenter:getGameParam()
	if nSex == 0 then
		if head == nil then
			head = GDatatab_item["id_"..(gameParam.defaultManHeadId or 4903)].animation_index_code
		end
		if face == nil then
			face = GDatatab_item["id_"..(gameParam.defaultManFaceId or 4902)].animation_index_code
		end
		if body == nil then
			body = GDatatab_item["id_"..(gameParam.defaultManBodyId or 4901)].animation_index_code
		end
	else
		if head == nil then
			head = GDatatab_item["id_"..(gameParam.defaultWomanHeadId or 4906)].animation_index_code
		end
		if face == nil then
			face = GDatatab_item["id_"..(gameParam.defaultWomanFaceId or 4905)].animation_index_code
		end
		if body == nil then
			body = GDatatab_item["id_"..(gameParam.defaultWomanBodyId or 4904)].animation_index_code
		end
	end

	local itemInfo = GDatatab_item["id_"..itemId]
	if itemInfo.main_type == 3 then --礼包里的时装
		local giftItems = getItemsInGift(itemId)
		for j = 1, #giftItems do
			local itemInfo2 = GDatatab_item["id_" .. giftItems[j].id]
			if itemInfo2.main_type == 5 and itemInfo2.sub_type == 0 then --头部
				head = GDatatab_item["id_"..giftItems[j].id].animation_index_code
			elseif itemInfo2.main_type == 5 and itemInfo2.sub_type == 1 then --脸部
				face = GDatatab_item["id_"..giftItems[j].id].animation_index_code
			elseif itemInfo2.main_type == 5 and itemInfo2.sub_type == 2 then --衣服
				body = GDatatab_item["id_"..giftItems[j].id].animation_index_code
			elseif itemInfo2.main_type == 5 and itemInfo2.sub_type == 3 then --翅膀
				wing = GDatatab_item["id_"..giftItems[j].id].animation_index_code
			end
		end
	elseif itemInfo.main_type == 5 and itemInfo.sub_type == 3 then --翅膀
		wing = GDatatab_item["id_" .. itemId].animation_index_code
	end 

	roleConPlayer:setHead(head)		
	roleConPlayer:setFace(face)
	roleConPlayer:setBody(body)
	if wing then
		roleConPlayer:setWing(wing)
	end
	roleConPlayer:play("wait0",true)
	roleConPlayer:setScale(1.3)
end

--排序
function WndFirstReCharge:taskTableSort(data_sort)
	local temp = {
		[-1] = 2, --未领取
		[0] = 1, --可领取
		[1] = 3, --已领取
	}
	local function testFunc(a,b)
		if a.status ~= b.status then
			if temp[a.status] and temp[b.status] then
				return temp[a.status] < temp[b.status]
			else
				return false
			end
		else
			return a.id < b.id
		end
	end
	table.sort(data_sort, testFunc)
end
function WndFirstReCharge:setVisibleRedpoint(index,visible)
	if not self.m_root then return end
	local redpoint = GetElement(self.m_root,"redpoint"..index,WZUIImage)
	if redpoint then
		redpoint:setVisible(visible)
	end
end

function WndFirstReCharge:onBtnRecharge()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndNewVip:showInterface(1)
	WindowManager:removeWindow(WndFirstReCharge.m_root, WndFirstReCharge, true)
end
function WndFirstReCharge:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	红点
function WndFirstReCharge:showRedDot()
	-- body
	if self.m_root == nil then return end 

	self:setVisibleRedpoint(1,GlobalGame.g_tRedPointList.first1_redpoint)
	self:setVisibleRedpoint(2,GlobalGame.g_tRedPointList.first2_redpoint)
	self:setVisibleRedpoint(3,GlobalGame.g_tRedPointList.first3_redpoint)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFirstReCharge:_onGetRechargeRewardInfo(activityId,maxCount,count,status, rewardCounts, rewardItems,rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	for i=1, #rewardId do
		self.m_tGetStatusIds[rewardId[i]] = status[i]
	end
	for i=1, #rewardItems do
		local tab = {}
		tab.progress = rewardItems[i]
		tab.target = rewardCounts[i]
		self.m_tChargeNumData[i] = tab
	end
	self:setRechargeRewardData(content)
	self:setVisibleView(self.m_nCurIndex)
end
function WndFirstReCharge:_onGetRewardResult(itemsId, count, _type, rewardId)
	WndRewardShow:showById(itemsId, count)

	local index = nil
	for i=1,3 do
		for m=1, #self.m_tFirstRechargeData[i] do
			if self.m_tFirstRechargeData[i][m].id == rewardId then
				index = self.m_tFirstRechargeData[i][m].grade
				self.m_tFirstRechargeData[i][m].status = 1
				break
			end
		end
	end
	if index then
		self:createCellFirstItem(index)
	end
end

-------------------------------------私有方法模块End----------------------------------------
