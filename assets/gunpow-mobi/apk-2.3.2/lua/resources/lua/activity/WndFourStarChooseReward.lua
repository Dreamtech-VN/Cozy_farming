--WndFourStarChooseReward.lua
--@brief	WndFourStarChooseReward的UI模块
--@date		2021/02/23
--@author	hyx
--@note		奖励选择模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFourStarChooseReward:onEnter(element)
	self.m_root = element
	self:register()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFourStarChooseReward:onExit(element)
	self:_unInit()
	self:unregister()
end

function WndFourStarChooseReward:register()
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetChooseRewardInfo,self)

end
function WndFourStarChooseReward:unregister()
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetChooseRewardInfo,self)

end

function WndFourStarChooseReward:showInterface()
	local wndReward = WndFourStarChooseReward:createElement()
	if wndReward ~= nil then
	    WindowManager:addWindow(wndReward,WndFourStarChooseReward,nil,false)
	end
end

function WndFourStarChooseReward:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndFourStarChooseReward:actionCallback()
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7008, 1, "" )
end

--重选
function WndFourStarChooseReward:onBtnReset()
	if not self.m_nVersion then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if next(self.m_tASelectChooseIndex) == nil and next(self.m_tSSelectChooseIndex) == nil then
		return
	end

	local tab = {}
	tab.version = self.m_nVersion
	tab.itemIndexA = {-1,-1}
	tab.itemIndexS = {-1,-1}
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7008, 6, tab)
end
--确定
function WndFourStarChooseReward:onBtnSure()
	if not self.m_nVersion then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tab_A = self:getTableData(self.m_tASelectChooseIndex)
	local tab_S = self:getTableData(self.m_tSSelectChooseIndex, true)
	if #tab_A < 2 or #tab_S < 2 then
		MsgBoxManager:showTipBox(LocalStrings.FOURSTAR_TEXT13)
		return
	end
	local tab = {}
	tab.version = self.m_nVersion
	tab.itemIndexA = tab_A
	tab.itemIndexS = tab_S
	tab = json.encode(tab)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7008, 6, tab)
end
--isChange 转化，比如有些数字>10需要-10处理
function WndFourStarChooseReward:getTableData(data, isChange)
	local tab = {}
	isChange = isChange or nil
	for i,v in pairs(data) do
		if isChange == true then
			i = i - 10
		end
		table.insert(tab,i)
	end
	return tab
end
--刷新
function WndFourStarChooseReward:onBtnRefresh()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local moneyNum =  CacheCenter:getPlayerItemCountById(self.m_nRefreshItem) 
	if moneyNum >= self.m_nRefreshCount then
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7008, 2, "")
	else
		local function clickSureMoney()
			WndApartmentAct:showInterface()
		end
		MsgBoxManager:showConfirmBox(LocalStrings.FOURSTAR_TEXT32, self, clickSureMoney)
	end
end

function WndFourStarChooseReward:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndFourStarChooseReward:_onGetChooseRewardInfo(activityId, doType, result, msg)
	--获取奖池信息
	msg = json.decode(msg)
	if msg then
		self.m_nVersion = msg.version	
		if doType == 1 then	
			self:setASRewardData(msg)
			self:setRefreshData(msg)
		elseif doType == 6 then --保存奖励和重选时候
			--重选
			if msg.selectAs and msg.selectAs[1] == -1 then
				self:setResetChooseData()
				local goods_reward1 = GetElement(self.m_root,"goods_reward1",WZUIContainer)
				self:showChooseReward(goods_reward1, self.m_tAReward, self.m_tASelectReward, 0, self.m_tASelectChooseIndex)
				local goods_reward2 = GetElement(self.m_root,"goods_reward2",WZUIContainer)
				self:showChooseReward(goods_reward2, self.m_tSReward, self.m_tSSelectReward, 10, self.m_tSSelectChooseIndex)
			else--保存
				MsgBoxManager:showTipBox(LocalStrings.FOURSTAR_TEXT14)	
				WindowManager:removeWindow(WndFourStarChooseReward.m_root, WndFourStarChooseReward, true)
			end
		elseif doType == 2 then --刷新
			self:setResetChooseData()
			self:setASRewardData(msg)
			self:setRefreshData(msg)
			WndFourStar:setTxtSummonCount(msg.zhl)
		end
	end
end
--重选之后的返回
function WndFourStarChooseReward:setResetChooseData()
	for i, v in pairs(self.m_tSelectChooseItem) do
		if v then
			v:removeFromParentAndCleanup(true)
		end
	end
	self.m_tASelectChooseIndex = {}
	self.m_tSSelectChooseIndex = {}
	self.m_tASelectReward = {}
	self.m_tSSelectReward = {}
end
--刷新
function WndFourStarChooseReward:setRefreshData(data)
	GetElement(self.m_root,"txtRefreshCount",WZUILabelTTF):setText(data.refreshCount.."/"..data.refreshLimit)
	local freeTxtConsume = GetElement(self.m_root,"freeTxtConsume",WZUIFreeTextBox)
	self.m_nRefreshItem = data.refreshItem
	self.m_nRefreshCount = data.refreshPrice
	local tabItem = GDatatab_item["id_"..data.refreshItem]
	if tabItem then
		local str = string.format([[<T C="255,236,193" S="18" P="1">%s</T><I Z="0.5" P="1">%s</I><T C="255,255,255" S="18" P="1">%s</T>]],LocalStrings.CONSUME,tabItem.icon,self.m_nRefreshCount)
		freeTxtConsume:setShowText(str)
	end
	local goods_reward1 = GetElement(self.m_root,"goods_reward1",WZUIContainer)
	self:showChooseReward(goods_reward1, self.m_tAReward, self.m_tASelectReward, 0, self.m_tASelectChooseIndex)
	local goods_reward2 = GetElement(self.m_root,"goods_reward2",WZUIContainer)
	self:showChooseReward(goods_reward2, self.m_tSReward, self.m_tSSelectReward, 10, self.m_tSSelectChooseIndex)
end


-------------------------------------私有方法模块End----------------------------------------
