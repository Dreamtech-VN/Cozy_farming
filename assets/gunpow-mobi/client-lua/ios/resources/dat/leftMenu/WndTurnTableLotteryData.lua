--WndTurnTableLotteryData.lua
--@brief	WndTurnTableLottery的数据模块
--@date		2015/04/02
--@author	qixiang_xie
--@note		爱心许愿

WndTurnTableLottery = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTurnTableLottery:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = 0       --加载物品列表id
	self.m_nid = 1              --记录中奖变化id                  
	self.m_tGiftId = {}         --物品ID表
	self.m_tGiftIndex = {}          --物品索引表
	self.m_tGiftNum = {}
	self.m_nRewardId = 0        --获得奖品id
	self.m_ncount = 1           --记录旋转到哪个位置
	self.m_temrRecord = 0       --临时记录
	self.m_isShowCellLotteryList = false --是否正在抽奖
	self.m_curCircle = 1        --纪录循环了多少圈
	self.m_sPrizeId = nil   
	self.m_sPrizeCount = nil      
	self.m_nPrice = nil
	self.m_tItemList = nil
	self.m_tItemNumList = nil
	self.m_nCostType = 1
	self.m_nLeftTime = nil     --抽奖剩余次数
	self.m_nCostType = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTurnTableLottery:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil
	self.m_nid = nil
	self.m_tGiftId = {}         --物品ID表
	self.m_tGiftIndex = {}          --物品索引表
	self.m_tGiftNum = nil
	self.m_nRewardId = nil      
	self.m_ncount = nil
	self.m_temrRecord = nil
	self.m_isShowCellLotteryList = nil  
	self.m_curCircle = nil
	self.m_sPrizeId = nil   
	self.m_sPrizeCount = nil      
	self.m_nPrice = nil
	self.m_tItemList = nil
	self.m_tItemNumList = nil
	self.m_nCostType = nil
	self.m_nLeftTime = nil     --抽奖剩余次数
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTurnTableLottery:createElement()
	WZLog("WndTurnTableLottery:createElement")
	local element = WZUISystem:getInstance():createElement("WndTurnTableLottery")
	assert(element, "WndTurnTableLottery create element failed!")
	self:_init()
	return element
end

--@brief 添加到当前的场景
function WndTurnTableLottery:addParentRoot()
	WZLog("WndTurnTableLottery:addParentRoot")
	local element = self:createElement()
	WindowManager:addWindow(element, WndTurnTableLottery, false)
end

--设置钻石抽奖数据
function WndTurnTableLottery:setLotteryInfo(leftTimes,cost,index,reward)
	WZLog("WndTurnTableLottery:setLotteryInfo ",cost,Serialize(reward))
	if self.m_root == nil then return end
	local tempp = SplitTeachTalkStringWithSeparator(cost)
	tempp = SplitStringWithSeparator(tempp[1],",")
	self.m_nCostType = tonumber(tempp[1])
	self.m_nPrice =  tonumber(tempp[2])
	self.m_nLeftTime = leftTimes
	
	self.m_tGiftId = {} 
	self.m_tGiftNum = {}        
	self.m_tGiftIndex = index  
	local temp = nil   
	for i,v in ipairs(reward) do
		temp =  SplitTeachTalkStringWithSeparator(v)
		temp = SplitStringWithSeparator(temp[1],",")
		table.insert(self.m_tGiftId,tonumber(temp[1]))
		table.insert(self.m_tGiftNum,tonumber(temp[2]))
	end

	local time1,time2 = WndGameActivity:getActivityTime(g_tGameActivityTypes.ACTIVITY_NEWSERVER_DIAMONDROUND)
    self.m_sStartTime = time1
    self.m_sEndTime = time2
	self.m_ncount = #reward
    self:_updateTable()
    self:_setData()

    self:setBtnLotteryEnable(true)  
end

-------------------------------------公有方法模块End----------------------------------------



-------------------------------------私有方法模块Begin--------------------------------------

--@brief  获取中奖信息成功回调的函数
--@param  itemId 格子里的物品Id
--@param  gridId 选中的格子编号
--@param  num 物品数量
function WndTurnTableLottery:ReceiveRewardOk(gridId, itemId, num)
	WZLog("WndTurnTableLottery:ReceiveRewardOK ",gridId)
	if self.m_root == nil then return end
	WZLog("获得的物品ID是",self.m_tGiftId[gridId])
	self.m_tItemList = itemId
	self.m_tItemNumList = num
	self.m_nLeftTime = self.m_nLeftTime -1
	if self.m_nLeftTime < 0 then
		self.m_nLeftTime = 0
	end

	local txtCount = GetElement(self.m_root,"txtCount_WndTurnTableLottery",WZUILabelTTF)
	local tempCount = string.format(LocalStrings.CUR_TURN_COUNT,self.m_nLeftTime)
	txtCount:setText(tempCount)

	self.m_nRewardId = gridId
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
	self.m_nLoadingId = nil

    self:_setBackBtnEnable(false)
   
    self.m_root:enableSchedule("_scheduleSetCellState",0)
end

--@brief	获得奖励列表错误处理
--@param	sMessage:错误信息
function WndTurnTableLottery:getRewardListErrorProcess(sMessage)
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
	MsgBoxManager:showTipBox(sMessage)
end



-------------------------------------私有方法模块End----------------------------------------
