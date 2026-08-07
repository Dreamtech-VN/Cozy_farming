--WndZongZiData.lua
--@brief	WndZongZi的数据模块
--@date		2023/05/30
--@author	XTX
--@note		粽有不同活动主界面

WndZongZi = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndZongZi:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = false 
	self.m_tOpenResult = nil 
	self.m_nCoinId = 160456
	self.m_nMaxLotteryCount = 20    --最大抽奖次数
	self.m_nCalabashType = nil 			--当前选中的阵营2：甜粽；1：咸粽
	self.m_nTempChooseType = nil 		--当前选中的阵营
	self.m_nRechargeId = nil 			--解锁的重置Id
	self.m_nNeedUnLock = -1 				--  -1需要解锁；0已经解锁
	self.m_tDayReward = nil 			--
	self.m_tCellDay = nil 
	self.m_nSweetValue = 0 				--甜粽对抗值
	self.m_nSaltyValue = 0 				--咸粽对抗值
	self.m_nAgainstValue = 0 			--对抗值
	self.m_tResignCost = nil 
	self.m_nAniType = 1
	self.m_tBallAniName = {"duel", "duel2", "wait"} --端午节
	-- self.m_tBallAniName = {"wait_2", "wait_3", "wait_1"}	--中秋节
	-- self.m_tBallAniName = {"wait2_1", "wait2_2", "wait2"}	--圣诞节
	-- self.m_tBallAniName = {"wait2", "wait3", "wait1"}		--元宵节
	self.m_tLastContent = nil 
	self.m_nLastTurnCamp = nil 			--上一轮阵营
	self.m_nWinCamp = nil 	
	self.m_strEffectPath = "activity/hd_pic_duanwujie01" --"activity/hd_pic_duanwujie01" --hd_pic_tanguodaz --hd_pic_zqj --hd_pic_yuanxiao
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndZongZi:_unInit()
	self.m_root = nil
	self.m_nStartTime = nil 
	self.m_nEndTime = nil 
	self.m_tContent = nil 
	self.m_nActivityId = nil
	self.m_tBigRewardList = nil 		--大奖和特奖奖励
	self.m_bOpenState = nil 
	self.m_tOpenResult = nil 
	self.m_nCoinId = nil
	self.m_nMaxLotteryCount = nil    --最大抽奖次数
	self.m_nCalabashType = nil 			--当前选中的阵营0：甜粽；1：咸粽
	self.m_nTempChooseType = nil 		--当前选中的阵营
	self.m_nRechargeId = nil 			--解锁的重置Id
	self.m_nNeedUnLock = nil 
	self.m_tDayReward = nil 			--
	self.m_tCellDay = nil 
	self.m_nSweetValue = nil 				--甜粽对抗值
	self.m_nSaltyValue = nil 				--咸粽对抗值
	self.m_nAgainstValue = nil 
	self.m_tResignCost = nil 
	self.m_nAniType = nil 
	self.m_tBallAniName = nil 
	self.m_tLastContent = nil 
	self.m_nLastTurnCamp = nil 			--上一轮阵营
	self.m_nWinCamp = nil
	self.m_strEffectPath = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndZongZi:createElement()
	if WndZongZi.m_root ~= nil then
		WindowManager:removeWindow(WndZongZi.m_root, WndZongZi, true)
	end
	local element = WZUISystem:getInstance():createElement("WndZongZi")
	assert(element, "WndZongZi create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndZongZi:showInterface()
	LoadNewActivityRes(true)
	local wndWater = WndZongZi:createElement()
	if wndWater then 
		g_nLastChannelId_ShootArrow = GlobalGame.g_nCurrentUIChannelId
		WindowManager:addWindow(wndWater, WndZongZi, false)
	end
end

--@brief 	获取活动详情成功
function WndZongZi:GetActivityInfoOK(activityId,maxCount,count,status, rewardCounts, rewardItems, rewardItemsParamCount, startTime, endTime, content, rewardId, finishCondition, tips)
	-- body
	WZLog("WndZongZi:GetActivityInfoOK", activityId)
	if g_cityExtenInfo.activity7079 == activityId then 
		self.m_tContent = json.decode(content)
		self.m_nStartTime = startTime 
		self.m_nEndTime = endTime 
		self.m_nActivityId = activityId
		WZLog("self.m_tContentself.m_tContent", Serialize(self.m_tContent))
		self.m_nCalabashType = self.m_tContent.camp 
		self.m_nNeedUnLock = self.m_tContent.assistanceStatus
		self.m_nSweetValue = self.m_tContent.sweetValue 				--甜粽对抗值
		self.m_nSaltyValue = self.m_tContent.saltyValue 				--咸粽对抗值
		self.m_nAgainstValue = self.m_tContent.value 					--对抗值

		if self.m_tLastContent == nil then 
			self.m_tLastContent = CopyTable(self.m_tContent)
		end
		if self.m_nLastTurnCamp == nil and self.m_nCalabashType > 0 then 
			self.m_nLastTurnCamp = self.m_nCalabashType
		end

		self:_analyzeBigReward()
		local bCanLock = self:_getLockState()
		if bCanLock and self.m_nNeedUnLock == 0 then 
			self.m_nNeedUnLock = -1
			for i = 1, #self.m_tDayReward do
				self.m_tDayReward[i].status = 2
			end
		end
		self:_update()
	end
end

--@brief 	获取其他活动数据
function WndZongZi:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 

	if doType == 1 then --阵营选择
		local tResult = json.decode(jsonData)
		WZLog("WndZongZi:_onGetOtherData 111", Serialize(tResult))
		if result == 1 then 
			self.m_nCalabashType = tResult.camp
			self.m_nSweetValue = tResult.sweetValue 				--甜粽对抗值
			self.m_nSaltyValue = tResult.saltyValue 				--咸粽对抗值
			if self.m_nLastTurnCamp == nil and self.m_nCalabashType > 0 then 
				self.m_nLastTurnCamp = self.m_nCalabashType
			end

			self:_showAgainstValue()
			self:_setSelCamp()
		end
	elseif doType == 2 then --每日应援物领取
		local tResult = json.decode(jsonData)
		WZLog("WndZongZi:_onGetOtherData 222", Serialize(tResult))
		if result == 1 then 
			local tReward = {}
			for id, num in pairs(tResult.reward) do
				local tItem = {}
				tItem.itemId = tonumber(id)
				tItem.itemNum = num
				tItem.type = 8
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				table.insert(tReward, tItem)
			end

			WndHoraryBigReward:showInterface(8, tReward)
			self.m_tContent.dailyStatus = 1
			self:_setDaylyBtnState()
		end
	elseif doType == 3 then --开启结果
		local tResult = json.decode(jsonData)
		WZLog("WndZongZi:_onGetOtherData 333", Serialize(tResult))
		self.m_tOpenResult = {}
		self.m_tOpenResult.normalRewards = {} --常规奖

		local rewardType = 8 
		if tResult.itemIds then 
			for i = 1, #tResult.itemIds do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.nums[i]
				tItem.type = rewardType
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				table.insert(self.m_tOpenResult.normalRewards, tItem)
			end
		end

		if result == 1 then 
			self.m_tOpenResult.addExp = tResult.score
			self.m_nSweetValue = tResult.sweetValue 				
			self.m_nSaltyValue = tResult.saltyValue 
			self.m_nWinCamp = tResult.winCamp
			if tResult.winCamp == 1 then 
				MsgBoxManager:showTipBox(string.format(LocalStrings.ZONGZI_TEXT1[23], LocalStrings.ZONGZI_TEXT1[5]))
			elseif tResult.winCamp == 2 then 				
				MsgBoxManager:showTipBox(string.format(LocalStrings.ZONGZI_TEXT1[23], LocalStrings.ZONGZI_TEXT1[6]))
			elseif tResult.winCamp == 3 then 				
				MsgBoxManager:showTipBox(LocalStrings.ZONGZI_TEXT1[24])
			end

			self:showOpenAction()
			self:_setFreeBtnText()
			self:_showAgainstValue()
		else
			self:setOpenState(false)
		end
	elseif doType == 4 then --领取第几天奖励
		local tResult = json.decode(jsonData)
		WZLog("WndZongZi:_onGetOtherData 444", Serialize(tResult))
		if result == 1 then 
			local tReward = {}
			for i = 1, #tResult.itemIds do
				local tItem = {}
				tItem.itemId = tResult.itemIds[i]
				tItem.itemNum = tResult.nums[i]
				tItem.type = 8
				tItem.imgRewardTitle = "ui/newActivity/bt_text_gxhd_2.png"
				tItem.titlePt = GlobalMethod:ccp(0.5, 0.982)
				table.insert(tReward, tItem)
			end

			WndHoraryBigReward:showInterface(8, tReward)
			self.m_tDayReward[tResult.index].status = 1
			self.m_tCellDay[tResult.index]:updateStatue(1)
			local bCanLock = self:_getLockState() 
			if bCanLock and self.m_nNeedUnLock == 0 then 
				self.m_nNeedUnLock = -1

				for i = 1, #self.m_tDayReward do
					self.m_tDayReward[i].status = 2
				end
				self:_setUnlockBtnState()
				self:_createDayRewardList()
			end
		end
	elseif doType == 5 then --解锁成功，刷新领取状态
		local tResult = json.decode(jsonData)
		WZLog("WndZongZi:_onGetOtherData 555", Serialize(tResult))
		self.m_nNeedUnLock = tResult.assistanceStatus
		local tBigReward = tResult.assistanceMap
		local nSex = CacheCenter:getPlayerInfo().sex

		self.m_tDayReward = {}
		for i = 1, #tBigReward.days do
			local tItem = {}
			tItem.rewardId = tBigReward.days[i]
			tItem.status = tBigReward.status[i]
			tItem.reward = {}

			local array = SplitStringWithSeparator(tBigReward.rewards[i], "&")
			for j = 1, #array do
				local strItem = string.sub(array[j], 2, -2) 
				local id = tonumber(SplitStringWithSeparator(strItem,",")[1])
				local num = tonumber(SplitStringWithSeparator(strItem,",")[2])

				table.insert(tItem.reward, {id, num})
			end

			table.insert(self.m_tDayReward, tItem)
		end

		self:_setUnlockBtnState()
		self:_createDayRewardList()
	elseif doType == 6 then --本轮结束
		local tResult = json.decode(jsonData)
		WZLog("WndZongZi:_onGetOtherData 666", Serialize(tResult))
		if result == 1 then 
			if tResult.winCamp and (self.m_nWinCamp == nil or self.m_nWinCamp <= 0) and self.m_nCalabashType > 0 then 
				self.m_nWinCamp = tResult.winCamp
				self:_showTurnResult()
			end
		end
	end
end

--@brief	缓存推送更新物品时调用的函数
function WndZongZi:updatePlayerItemData()
	WZLog("WndZongZi:updatePlayerItemData")
	if self.m_root ~= nil then
		self:_updateLightNum()
	end
end

--@brief 	设置射箭的状态
function WndZongZi:setOpenState(state)
	-- body
	if self.m_root == nil then return end 

	self.m_bOpenState = state
end

--@brief 	获取补领消耗
function WndZongZi:getResignCost()
	return self.m_tResignCost
end

--@brief 	解锁成功回调
function WndZongZi:_onRechargeSuccessResult()
	--刷新领取状态
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_nActivityId, 5, "")
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	关闭抽奖奖励展示界面回调
function WndZongZi:_afterCloseReward()
	if self.m_root == nil then return end 

	if self.m_tOpenResult.normalRewards and #self.m_tOpenResult.normalRewards > 0 then 
		WndHoraryBigReward:showInterface(8, self.m_tOpenResult.normalRewards)
		if self.m_nWinCamp > 0 then 
			WndHoraryBigReward:setCallback(self, self._showTurnResult)
		end
	end
end

--@brief 	解析7日应援物奖励数据
function WndZongZi:_analyzeBigReward()
	-- body
	local tBigReward = self.m_tContent.assistanceMap
	local nSex = CacheCenter:getPlayerInfo().sex

	self.m_tDayReward = {}
	for i = 1, #tBigReward.days do
		local tItem = {}
		tItem.rewardId = tBigReward.days[i]
		tItem.status = tBigReward.status[i]
		tItem.reward = {}

		local array = SplitStringWithSeparator(tBigReward.rewards[i], "&")
		for j = 1, #array do
			local strItem = string.sub(array[j], 2, -2) 
			local id = tonumber(SplitStringWithSeparator(strItem,",")[1])
			local num = tonumber(SplitStringWithSeparator(strItem,",")[2])

			table.insert(tItem.reward, {id, num})
		end

		table.insert(self.m_tDayReward, tItem)
	end

	local strTemp = string.sub(self.m_tContent.bukaCost, 2, -2) 
	local id = tonumber(SplitStringWithSeparator(strTemp,",")[1])
	local num = tonumber(SplitStringWithSeparator(strTemp,",")[2])
	self.m_tResignCost = {id, num}

	strTemp = string.sub(self.m_tContent.recharge[1], 2, -2) 
	local nType = tonumber(SplitStringWithSeparator(strTemp,",")[1])
	local nSort = tonumber(SplitStringWithSeparator(strTemp,",")[2])
	_, self.m_nRechargeId = WndEveryDayBuy:getBuyMoney(nType, nSort)

end

function WndZongZi:_getLockState()
	local bCanLock = true
	for i = 1, #self.m_tDayReward do
		if self.m_tDayReward[i].status == -1 or self.m_tDayReward[i].status == 0 or self.m_tDayReward[i].status == 3 then 
			bCanLock = false 
			break 
		end
	end

	return bCanLock 
end
-------------------------------------私有方法模块End----------------------------------------
CellZongZiItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellZongZiItem:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil
	self.m_bIsLoaded = false
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellZongZiItem:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bIsLoaded = nil 
end

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellZongZiItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellZongZiItem table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellZongZiItem")
	element:setAbsContentSize(GlobalMethod:CCSize(178,353))
	element:setLuaObjectIndex(tNewObj)
	return element,tNewObj
end

--@brief 	 设置数据
function CellZongZiItem:setData(tData)
	-- body
	self.m_tData = tData 
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellZongZiItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellZongZiItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellZongZiItem:onExit(element)
	self:_unInit()
end

--@brief 加载
function CellZongZiItem:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellZongZiItem")
	celElement:setVisible(true)
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true 
    self:_update()
end

--@brief 	点击打卡按钮回调
function CellZongZiItem:onClickSign(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

	local nActivityId = WndZongZi.m_nActivityId
	
	local tData = {}
	tData.index = self.m_tData.rewardId

	local stringData = json.encode(tData)
	if self.m_tData.status == 0 then 
		ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(nActivityId, 4, stringData)
	else
		WZLog("CellZongZiItem:onClickSign")
		local strContent = LocalStrings.ZONGZI_TEXT1[19]
		local costFormat = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="22" P="1">*%d</T>]]
		local resignCost = WndZongZi:getResignCost()

		local basicInfo = GDatatab_item["id_" .. resignCost[1]]
		local tempStr = string.format(costFormat, basicInfo.icon, resignCost[2])

		strContent = strContent .. tempStr

		strContent = strContent .. LocalStrings.ZONGZI_TEXT1[20]
		local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.ZONGZI_TEXT1[18], bShowClose = true}
		MsgBoxManager:showConfirmBox(strContent, self, self.sureToResign, nil, tCustomUIConfig, true)
	end
end

--@brief 	点击打卡按钮回调
function CellZongZiItem:sureToResign(element)
	local resignCost = WndZongZi:getResignCost()
	if not JudgeMoneyIsEnough(resignCost[1], resignCost[2], nil, nil, nil, nil, nil, nil, nil, self, self.sureToUseBlueDia) then 
		return 
	end
	self:sureToUseBlueDia()
end

--@brief 	确定购买
function CellZongZiItem:sureToUseBlueDia()
	-- body
	WZLog("CellZongZiItem:sureToUseDiamond")
	local nActivityId = WndZongZi.m_nActivityId
	local tData = {}
	tData.index = self.m_tData.rewardId
	
	local stringData = json.encode(tData)
	ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(nActivityId, 4, stringData)
end

--@brief    刷新
function CellZongZiItem:_update()
	WZLog("CellZongZiItem:_update", Serialize(self.m_tData))
	--body
	local ftxtDay = GetElement(self.m_root, "ftxtDay_CellZongZiItem", WZUIFreeTextBox)

	local bIsCurDay = false 
	if ftxtDay then 
		if self.m_tData.status == 0 then 
			GetElement(self.m_root, "imgBk_CellZongZiItem", WZUIImage):setFile("ui/specialBg/common_dwj_di_02.png")
			local strFormat = LocalStrings.ZONGZI_TEXT1[2]--string.gsub(LocalStrings.ZONGZI_TEXT1[2], "0,108,3", "198,55,36")
			ftxtDay:setShowText(string.format(strFormat, self.m_tData.rewardId))
			bIsCurDay = true 
		else
			local strNewFormat = LocalStrings.ZONGZI_TEXT1[2]
			ftxtDay:setShowText(string.format(strNewFormat, self.m_tData.rewardId))
		end
	end
	self:updateStatue()
	--奖励
	local conReward = GetElement(self.m_root, "conReward_CellZongZiItem", WZUIContainer)
	conReward:removeAllChildrenWithCleanup(true)
	local nStartX = 0.7 
	local nStartY = 0.5 
	local nGappingY = 0.5
	local nScale = 1

	local nCount = #self.m_tData.reward
	if nCount ~= 1 then 
	 	nStartY = nStartX
	end

	for i = 1, #self.m_tData.reward do
		local element, tNewObj = CellGoodItem:createElement()
		if element and tNewObj then 
			tNewObj:setCellGoodLocalId(self.m_tData.reward[i][1], self.m_tData.reward[i][2], 17)
			tNewObj:setItemClickFun(self, self.onItemClick)
			element:setRelativePosition(GlobalMethod:ccp(0.5, nStartY - (i - 1)*nGappingY))
			if bIsCurDay then 
				tNewObj:setBackImgFile("ui/newActivity/common_7zn_tbd_02.png", nil, nil, GlobalMethod:ccp(0.55, 0.43))
			else
				tNewObj:setBackImgFile("ui/newActivity/common_dwj_tbd.png", nil, nil, GlobalMethod:ccp(0.55, 0.43))
			end
			tNewObj:setQualityFrameVisible(false)
			element:setScale(nScale)
			conReward:addChild(element)
		end
	end
end

function CellZongZiItem:onItemClick(tCell,tag,tData)
	if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    local rootTemp = WndZongZi.m_root

   	WndItemInfo:showInfo(tCell.m_root, rootTemp,1,tData,false,nil,true)
end

--@brief 	修改奖励状态
function CellZongZiItem:updateStatue(status)
	if status then
		self.m_tData.status = status
	end
	if self.m_bIsLoaded == false then return end 

	local conDone = GetElement(self.m_root, "conDone_CellZongZiItem", WZUIContainer)
	local btnReward = GetElement(self.m_root, "btnSign_CellZongZiItem", WZUIButton)
	if self.m_tData.status == 2 or self.m_tData.status == 3 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(false)
	elseif self.m_tData.status == 0 then 
		btnReward:setVisible(true)
		btnReward:setTouchEnable(true)
		GetElement(self.m_root, "txtBtnSign_CellZongZiItem", WZUILabelTTF):setText(LocalStrings.INVITE_RECEIVE)
		GetElement(self.m_root, "txtBtnSignSel_CellZongZiItem", WZUILabelTTF):setText(LocalStrings.INVITE_RECEIVE)
	elseif self.m_tData.status == 1 then 
		btnReward:setTouchEnable(false)
		conDone:setVisible(true)
	elseif self.m_tData.status == -1 then 
		btnReward:setTouchEnable(true)
		GetElement(self.m_root, "imgBtnSign_CellZongZiItem", WZUIImage):setFile("ui/common/common_btn_06_1.png")
		GetElement(self.m_root, "imgBtnSignSel_CellZongZiItem", WZUIImage):setFile("ui/common/common_btn_06_1.png")
		GetElement(self.m_root, "txtBtnSign_CellZongZiItem", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[18])
		GetElement(self.m_root, "txtBtnSign_CellZongZiItem", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(0,112,202))
		GetElement(self.m_root, "txtBtnSignSel_CellZongZiItem", WZUILabelTTF):setText(LocalStrings.ZONGZI_TEXT1[18])
		GetElement(self.m_root, "txtBtnSignSel_CellZongZiItem", WZUILabelTTF):setStrokeColor(GlobalMethod:ccc3(0,112,202))
	end
end