--WndFlyUp.lua
--@brief	WndFlyUp的UI模块
--@date		2022/12/06
--@author	XTX
--@note		飞升仙界


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFlyUp:onEnter(element)
	self.m_root = element

	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	GlobalGame:getGameEventDispathcer():Add(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFlyUp:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	GlobalGame:getGameEventDispathcer():Remove(WndNationalEvent.WndNationalEvent_GetProtocal108Result,self._onGetOtherData,self)

	self:_unInit()
end

--@brief    onenter函数已执行
function WndFlyUp:onEnterTransitionDidFinish(element)
    WZLog("WndDecorations:onEnterTransitionDidFinish")
    self:_initStaticText()
    ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 1, "")
end

--@brief    关闭窗口
function WndFlyUp:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	点击目标按钮回调
function WndFlyUp:onClickRank(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	if nTag == 1 then 
		WndShopRank:showInterface(35, self.m_nActivityId) 
	elseif nTag == 2 then
		WndFlyUpFirst:showInterface(self.m_nActivityId)
	end
end

function WndFlyUp:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	WndItemInfo:showInfo(tCell.m_root, self.m_root, 1, tData, false, nil, true)
end

--@brief 	点击飞升按钮回调
function WndFlyUp:onClickFlyUp(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    if self.m_bOpenState then return end 

	local nArrowNum = CacheCenter:getPlayerItemCountById(self.m_nCoinId)
	WZLog("WndFlyUp:onClickFlyUp", nArrowNum)
	if nArrowNum <= 0 then 
		local basicData = GDatatab_item["id_" .. self.m_nCoinId]
		MsgBoxManager:showTipBox(LocalStrings.BEINGIMMORTAL_TEXT1[26])
		return 
	end

	local indexId = nil 
	for i = 1, #self.m_tAcuPointData do
		if self.m_tAcuPointData[i].id == self.m_nCoinId then 
			indexId = self.m_tAcuPointData[i].indexId
			break 
		end
	end
    local tData = {}
	tData.id = indexId

	local stringData = json.encode(tData)

	self:setOpenState(true)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 4, stringData)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	更新
function WndFlyUp:_update()
	self:_createItemList()
end

--@brief 	初始化静态文本
function WndFlyUp:_initStaticText()
	self:_setBallAni()
	
	GetElement(self.m_root, "txtRewardT_WndFlyUp", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[25])
	GetElement(self.m_root, "txtRank_WndFlyUp", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[14])
	GetElement(self.m_root, "txtRankFirst_WndFlyUp", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[16])
	GetElement(self.m_root, "txtLeftT_WndFlyUp", WZUILabelTTF):setText(LocalStrings.BEINGIMMORTAL_TEXT1[17])

	local sBigReward = WndBeingImmortal.m_tContent.flyUpReward
	local array = SplitStringWithSeparator(sBigReward, "&")
	local nSex = CacheCenter:getPlayerInfo().sex
	local reward_ids1, reward_nums1 = {}, {}
	for i = 1, #array do
		local string = string.sub(array[i], 2, -2) 
		local id = tonumber(SplitStringWithSeparator(string,",")[nSex + 1])
		local num = tonumber(SplitStringWithSeparator(string,",")[3])

		table.insert(reward_ids1, id)
		table.insert(reward_nums1, num)
	end

	self.m_tFlyupRewards = {}
	self.m_tFlyupRewards.ids = reward_ids1
	self.m_tFlyupRewards.nums = reward_nums1

	self:_showExtralReward()
end

--@brief 	创建左边丹药列表
function WndFlyUp:_createItemList(bUpdateNum)
	if bUpdateNum then 
		for i = 1, #self.m_tItemIdList do
			local num = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[i])
			local tNewObj = self.m_tItemCell[i]
			if tNewObj then 
				tNewObj:setItemNumber(num)
				local nNeedNum = self:_getNeedNum(self.m_tItemIdList[i])
				tNewObj:_setItemCountText(num, nNeedNum)
			end
		end
	else
		local tbElixirs = GetElement(self.m_root, "tbElixirs_WndFlyUp", WZUITableContainer)
		tbElixirs:cleanTable()
		self.m_tItemCell = {}

		for i = 1, #self.m_tItemIdList do
			local num = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[i])
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then 
				element:setTag(i - 1)
				tNewObj:setCellGoodLocalId(self.m_tItemIdList[i], num, 4, true)
				tNewObj:setItemNumber(num)
				tNewObj:_setItemVisible(true)
				tNewObj:setItemClickFun(self, self.onItemClick)
				local nNeedNum = self:_getNeedNum(self.m_tItemIdList[i])
				tNewObj:_setItemCountText(num, nNeedNum)

				tbElixirs:setCellElement(element)
				table.insert(self.m_tItemCell, tNewObj)
			end
		end
	end


	self:_setFreeBtnText()
end

--@brief 	显示穴位数据
function WndFlyUp:_drawAcupoint()
	for i = 1, #self.m_tAcuPointData do
		local imgIcon = GetElement(self.m_root, "imgIcon" .. i .. "_WndFlyUp", WZUIImage)
		local basicData = GDatatab_item["id_" .. self.m_tAcuPointData[i].id]
		imgIcon:setFile(basicData.icon)
		if self.m_tAcuPointData[i].progress >= self.m_tAcuPointData[i].target then 
			imgIcon:setGrayRender(false)
		else
			imgIcon:setGrayRender(true)
		end
	end

	self:_setFreeBtnText()
end

--@brief 	设置免费丢
function WndFlyUp:_setFreeBtnText()
	local txtFlyUp = GetElement(self.m_root, "txtFlyUp_WndFlyUp", WZUILabelTTF)
	if self.m_tAcuPointData == nil then return end 
	local nLightNum = 0
	local nTempCostId = nil 
	self.m_nCoinId = nil 
	
	for i = 1, #self.m_tItemIdList do
		local num = CacheCenter:getPlayerItemCountById(self.m_tItemIdList[i])
		local needNum = self:_getNeedNum(self.m_tItemIdList[i])
		if needNum > 0 then 
			nTempCostId = self.m_tItemIdList[i]
			if num > 0 then 
				if num >= needNum then 
					nLightNum = needNum > self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or needNum
				else
					nLightNum = num > self.m_nMaxLotteryCount and self.m_nMaxLotteryCount or num 
				end
				self.m_nCoinId = self.m_tItemIdList[i]
				break 
			end
		end
	end

	if nLightNum == 0 then 
		nLightNum = 1
		self.m_nCoinId = nTempCostId
	end

	txtFlyUp:setText(string.format(LocalStrings.BEINGIMMORTAL_TEXT1[24], nLightNum))
end

--@brief 	显示额外奖励
function WndFlyUp:_showExtralReward()
	local tbFlyUpReward = GetElement(self.m_root, "tbFlyUpReward_WndFlyUp", WZUITableContainer)
	tbFlyUpReward:cleanTable()

	for i = 1, #self.m_tFlyupRewards.ids do
		local num = self.m_tFlyupRewards.nums[i]
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			element:setScale(0.8)
			tNewObj:setCellGoodLocalId(self.m_tFlyupRewards.ids[i], num, 4)
			tNewObj:setItemClickFun(self, self.onItemClick)

			tbFlyUpReward:setCellElement(element)
		end
	end
end

--@brief 	显示开启动画
function WndFlyUp:showOpenAction()
	-- body
	self:showShootReward()
end

--@brief 	显示开启奖励
function WndFlyUp:showShootReward()
	-- body

	self:setOpenState(false)
	self:_afterCloseReward()
end

--@brief 	设置待机特效
function WndFlyUp:_setBallAni()
	local spinePath = "activity/hd_pic_feisheng"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineOpen = GetElement(self.m_root, "spineOpen_WndFlyUp", WZUISpine)
		if spineOpen then 
			spineOpen:setFileJson(spinePath .. ".json")
			spineOpen:setFileAtlas(spinePath .. ".atlas")
			self:_setBowlingPlayAni(1, true)
		end
	else
		local _sIndex = "hd_pic_feisheng"
        local downloadInfo = GetDownloadInfo(_sIndex, "activityEffect")
        if downloadInfo then 
        	DownloadManager:addDownloadTask(7055, downloadInfo.url, downloadInfo.md5, _sIndex, "downloadEffectCallback", WndBeingImmortal)
        end
	end
end

function WndFlyUp:downloadEffectCallback(taskId,extraData,failed)
    WZLog("WndFlyUp:downloadEffectCallback",taskId,extraData,failed)
    self:_setBallAni()
end

--@brief 	设置播放的保龄球的动画
--@param 	aniIndex:1待机；2击球
function WndFlyUp:_setBowlingPlayAni(aniIndex, bLoop)
	local spineOpen = GetElement(self.m_root, "spineOpen_WndFlyUp", WZUISpine)
	aniIndex = aniIndex or 1
	WZLog("WndFlyUp:_setBowlingPlayAni", aniIndex, bLoop)
	if spineOpen then 
		spineOpen:play(self.m_tBallAniName[aniIndex], bLoop ~= nil and bLoop or true)
	end
end
-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------

function WndFlyUp:_adaptLanguage_vn(  )
	local txtLeftT = GetElement(self.m_root, "txtLeftT_WndFlyUp", WZUILabelTTF)
	txtLeftT:setScale(0.7)
	txtLeftT:setDimensions(GlobalMethod:CCSize(120,0))
end

---------------------------------------语言适配End------------------------------------------