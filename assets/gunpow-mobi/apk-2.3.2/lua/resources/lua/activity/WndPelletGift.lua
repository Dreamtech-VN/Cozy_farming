--WndPelletGift.lua
--@brief	WndPelletGift的UI模块
--@date		2021/09/13
--@author	hyx
--@note		童年礼物


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPelletGift:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPelletGift:onExit(element)
	self:_unInit()
	self:unregister()
end
function WndPelletGift:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetGiftResult,self)
end
function WndPelletGift:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetGiftResult,self)
end
function WndPelletGift:showInterface(gift_data, light_data, photo_data)
	local wndGift = WndPelletGift:createElement(gift_data, light_data, photo_data)
	if wndGift ~= nil then
	    WindowManager:addWindow(wndGift,WndPelletGift,nil,nil)
	end
end
function WndPelletGift:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPelletGift:actionCallback()
	if self.m_tGiftData then
		local sex = CacheCenter:getPlayerInfo().sex
		local data = {}
		for i=1,#self.m_tGiftData do
			local ids,nums = SplitItemString(self.m_tGiftData[i], sex)
			local tab = {}
			tab.index = self.m_tPhotoId[i]
			tab.lightStatus = self.m_tLightStatus[i]
			tab.ids = ids
			tab.nums = nums
			data[i] = tab
		end
		self.m_tShowGiftRewardData = data
	end
	local giftList = GetElement(self.m_root,"giftFreeList",WZUIFreeListContainer)
	giftList:removeAll()
	self:taskTableSort(self.m_tShowGiftRewardData)
	for i = 1, #self.m_tShowGiftRewardData do
		local element, tLuaObj = PelletGiftItem:createElement()
		self.m_tGiftItem[i] = tLuaObj
		giftList:pushBack(WZUIContainer:luaTo(element))
		giftList:getMoveElement():setPositionY(giftList:getMinPosition().y)
		tLuaObj:setRewardData(i,self.m_tShowGiftRewardData[i])
	end

end
--排序
function WndPelletGift:taskTableSort(data_sort)
	local temp = {
		[0] = 2, --未点亮
		[1] = 1, --已点亮
		[2] = 3, --已领取
	}
	local function testFunc(a,b)
		if a.lightStatus ~= b.lightStatus then
			if temp[a.lightStatus] and temp[b.lightStatus] then
				return temp[a.lightStatus] < temp[b.lightStatus]
			else
				return false
			end
		else
			return a.index < b.index
		end
	end
	table.sort(data_sort, testFunc)
	self:setRedpoint()
end
--入口红点
function WndPelletGift:setRedpoint()
	local status = false
	for i,v in pairs(self.m_tShowGiftRewardData) do
		if v and v.lightStatus == 1 then
			status = true
			break
		end
	end
	GlobalGame.g_tRedPointTypeList[27028] = status
	WndPelletChip:setGiftRedPoint()
	local red_point = GlobalGame.g_tRedPointTypeList[127028] or GlobalGame.g_tRedPointTypeList[27028] or GlobalGame.g_tRedPointTypeList[37028]
	SceneCity:setSceneMainIconRedPoint(FISH_ACTIVITY, red_point)
end
function WndPelletGift:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPelletGift:_onGetGiftResult(activityId, doType, result, msg)
	if doType == 5 then
		if result == 1 then
			msg = json.decode(msg)
			local sex = CacheCenter:getPlayerInfo().sex
			local ids,nums = SplitItemString(msg.rewards, sex)
			WndRewardShow:showById(ids, nums)

			for i=1,#self.m_tShowGiftRewardData do
				if msg.photoId and self.m_tShowGiftRewardData[i].index == msg.photoId then
					self.m_tShowGiftRewardData[i].lightStatus = 2
					WndPelletChip:setRewardGiftState(msg.photoId)
					break
				end
			end
			self:taskTableSort(self.m_tShowGiftRewardData)
			for i,v in ipairs(self.m_tGiftItem) do
				if v then
					local index = self.m_tShowGiftRewardData[i].index
					v:setLevelItemMessage(i, index, self.m_tShowGiftRewardData[i])
				end
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT163[result])
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
