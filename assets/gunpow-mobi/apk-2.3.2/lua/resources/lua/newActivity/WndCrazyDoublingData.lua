--WndCrazyDoublingData.lua
--@brief	WndCrazyDoubling的数据模块
--@date		2020/07/30
--@author	yrd
--@note		疯狂翻倍

WndCrazyDoubling = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCrazyDoubling:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_activityId = nil
	self.m_content = nil
	self.m_tips = nil
	self.m_startTime = nil
	self.m_endTime = nil
	self.m_serverTime = nil
	self.m_rewardId = nil 				--固定8个 下标:1~5为任务id 6~8为骰子点数 9倒计时
	self.m_status = nil					--固定5个 下标:1~5为任务状态
	self.m_rewardItems = nil
	self.m_rewardItemsParamCount = nil
	self.m_rewardCounts = nil
	self.m_count = nil 					--骰子总数
	self.m_maxCount = nil 				--充值id
	self.m_target = nil					--固定20个 1~5任务需要完成数 6~10任务可翻倍数 11~15已翻倍次数 16~20任务已完成数

	self.m_tTaskData = nil				--存放5个任务数据
	self.m_tTaskObj = nil
	self.m_nSelIndex = 1				--当前选中的任务下标

	self.nDayCountDown = nil 				--倒计时用来跨天刷新
	self.nDiceCountDown = nil 				--倒计时用来播放骰子动画

	self.tDice = nil 					--翻倍后3个骰子点数
	self.tItemId = nil 					--翻倍后奖励id
	self.nItemNum = nil 				--翻倍后奖励数

	self.m_tDicePoints = {}				--每个任务翻过的点数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCrazyDoubling:_unInit()
	self.m_root = nil

	self.m_activityId = nil
	self.m_content = nil
	self.m_tips = nil
	self.m_startTime = nil
	self.m_endTime = nil
	self.m_serverTime = nil
	self.m_rewardId = nil
	self.m_status = nil
	self.m_rewardItems = nil
	self.m_rewardItemsParamCount = nil
	self.m_rewardCounts = nil
	self.m_count = nil
	self.m_maxCount = nil
	self.m_target = nil

	self.m_tTaskData = nil
	self.m_tTaskObj = nil
	self.m_nSelIndex = nil

	self.nDayCountDown = nil
	self.nDiceCountDown = nil

	self.tDice = nil
	self.tItemId = nil
	self.nItemNum = nil

	self.m_tDicePoints = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCrazyDoubling:createElement()
	if WndCrazyDoubling.m_root ~= nil then
		WindowManager:removeWindow(WndCrazyDoubling.m_root, WndCrazyDoubling, true)
	end
	if WZFileUtil:isFileExist("pack/taboo/pack_taboo_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/taboo/pack_taboo_0.plist")
    end
	if WZFileUtil:isFileExist("pack/taboo/pack_taboo_1.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile("pack/taboo/pack_taboo_1.plist")
    end
	local element = WZUISystem:getInstance():createElement("WndCrazyDoubling")
	assert(element, "WndCrazyDoubling create element failed!")
	self:_init()
	return element
end

function WndCrazyDoubling:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	self.m_activityId = activityId
	self.m_content = content
	self.m_tips = tips
	self.m_startTime = startTime
	self.m_endTime = endTime
	self.m_serverTime = serverTime
	self.m_rewardId = rewardId
	self.m_status = status
	self.m_rewardItems = rewardItems
	self.m_rewardItemsParamCount = rewardItemsParamCount
	self.m_rewardCounts = rewardCounts
	self.m_count = count
	self.m_maxCount = maxCount
	self.m_target = target

	self.m_tDicePoints = {}

	self.m_tTaskData = {}
	local nIndex = 1
	for i=1,5 do
		local tTemp = {}
		tTemp.tips = tips[i]
		tTemp.taskId = rewardId[i]
		tTemp.taskStatus = status[i]
		tTemp.reward = {}	
		for j = 1, rewardCounts[i] do
			if rewardItems[nIndex] ~= -1 then
				table.insert(tTemp.reward, {rewardItems[nIndex], rewardItemsParamCount[nIndex]})
			end
			nIndex = nIndex + 1
		end
		tTemp.taskTatolFinish = target[i] 		--任务需要完成数
		tTemp.taskTatolDoubling = target[5+i] 	--任务可翻倍数
		tTemp.taskCurDoubling = target[10+i] 	--已翻倍次数
		tTemp.taskCurFinish = target[15+i]		--任务已完成数
		table.insert(self.m_tTaskData, tTemp)

		--每个任务的翻倍点数
		local tempDicePoints = {}
		table.insert(tempDicePoints,rewardId[5+(i-1)*3+1])
		table.insert(tempDicePoints,rewardId[5+(i-1)*3+2])
		table.insert(tempDicePoints,rewardId[5+(i-1)*3+3])
		self.m_tDicePoints[i] = tempDicePoints
	end
	self.nDayCountDown = self.m_rewardId[21]
end

function WndCrazyDoubling:getCrazyDoubleRewrad(taskId, dice, itemId, itemNum)
	self.tDice = dice
	self.tItemId = itemId
	self.nItemNum = itemNum

	if taskId == 0 then
		local num = 1
		WndDoublingReward:showInterface(itemId, itemNum, num)
	else
		WndCrazyDoubling:playDiceAni()
	end

	if WndCrazyDoubling.m_root ~= nil then
		WndCrazyDoubling:sendProtocolActivityInfo()
	end
end

-- 重新发协议获取活动信息
function WndCrazyDoubling:sendProtocolActivityInfo()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetActivityInfo(g_cityExtenInfo.CDStatus, g_tGameActivityTypes.ACTIVITY_CRAZY_DOUBLING)
end

--@brief 	获取其他活动数据
function WndCrazyDoubling:_onGetOtherData(activityId, doType, result, jsonData)
	if self.m_root == nil then return end 
	-- if result == 1 then --刷新开宝藏进度
	-- 	--订单
	-- 	local tRechargeData = GDatatab_recharge["id_" .. self.m_maxCount]
	-- 	local sdkData = {}
	--     sdkData.id = tRechargeData.id
	--     sdkData.price = tRechargeData.price
	--     sdkData.productName = tRechargeData.name
	--     sdkData.payCode = GetPayCodeIdByChannelId(tRechargeData)
	--     sdkData.quantifier = LocalStrings.DRAW_COUNT
	--     sdkData.number = "1"
	--     sdkData.giftNumber = "0"
	--     sdkData.productDesc = tRechargeData.name
	--     PassportSdkManager:getOrderNum(sdkData)
	-- elseif result == 2 then 
	-- 	MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_YEAR_END)
	-- 	WndFrameActivity:closeWin()
	-- elseif result == 4 or result == 5 then 
	-- 	MsgBoxManager:showTipBox(LocalStrings.BREAK_TEXT1[8])

	-- 	self:sendProtocolActivityInfo()
	-- end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
