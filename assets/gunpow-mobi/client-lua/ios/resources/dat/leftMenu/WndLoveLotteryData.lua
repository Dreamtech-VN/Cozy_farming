--WndLoveLotteryData.lua
--@brief	WndLoveLottery的数据模块
--@date		2015/04/02
--@author	qixiang_xie
--@note		爱心许愿

WndLoveLottery = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLoveLottery:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = 0       --加载物品列表id
	self.m_nid = 1              --记录中奖变化id                  
	self.m_tGiftName = {}       --物品名称表
	self.m_tGiftIcon = {}       --物品图标表
	self.m_tGiftNum = {}        --物品数量表
	self.m_tGiftId = {}         --物品ID表
	self.m_nRewardId = 0        --获得奖品id
	self.m_ncount = 1           --记录旋转到哪个位置
	self.m_nStartPs = 1         --旋转起点位置

	self.m_temrRecord = 0       --临时记录
	self.m_isShowCellLotteryList = false --是否正在抽奖
	self.m_curCircle = 1        --纪录循环了多少圈
	self.m_sPrizeId = nil   
	self.m_sPrizeCount = nil      
	self.m_bRaffling = false    --是否正在进行抽奖中     
	self.m_sStartTime = nil
	self.m_sEndTime = nil
	self.m_nPrice = nil
	self.m_bTenTakeOut = false
	self.m_tItemList = nil
	self.m_tItemNumList = nil
	self.m_nSendGold = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLoveLottery:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil
	self.m_nid = nil
	self.m_tGiftName = nil       
	self.m_tGiftIcon = nil       
	self.m_tGiftNum = nil   
	self.m_tGiftId = nil              
	self.m_nRewardId = nil      
	self.m_ncount = nil
	self.m_temrRecord = nil
	self.m_isShowCellLotteryList = nil  
	self.m_curCircle = nil
	self.m_sPrizeId = nil   
	self.m_sPrizeCount = nil    
	self.m_bRaffling = nil   
	self.m_sStartTime = nil
	self.m_sEndTime = nil
	self.m_nPrice = nil
	self.m_bTenTakeOut = nil
	self.m_tItemList = nil
	self.m_tItemNumList = nil
	self.m_nSendGold = nil
	self.m_nStartPs = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLoveLottery:createElement()
	WZLog("WndLoveLottery:createElement")
	local element = WZUISystem:getInstance():createElement("WndLoveLottery")
	assert(element, "WndLoveLottery create element failed!")
	self:_init()
	return element
end

--@brief 添加到当前的场景
function WndLoveLottery:addParentRoot()
	WZLog("WndLoveLottery:addParentRoot")
	local element = self:createElement()
	WindowManager:addWindow(element, WndLoveLottery, false)
end

--设置爱心许愿抽奖数据
function WndLoveLottery:setLotteryInfo(startTime,endTime,price,costType)
	WZLog("WndLoveLottery:setLotteryInfo ",startTime,endTime,price,costType)
	self.m_sStartTime = startTime
	self.m_sEndTime = endTime
	self.m_nPrice = price
	self.m_nCostType = costType

	local gainGold = tonumber(CacheCenter:getGameParam().luckyLotteryGainGold)
	self.m_nSendGold = gainGold
end

-------------------------------------公有方法模块End----------------------------------------



-------------------------------------私有方法模块Begin--------------------------------------

--@brief  获取中奖信息成功回调的函数
--@param  itemId 格子里的物品Id
--@param  gridId 选中的格子编号
--@param  num 物品数量
function WndLoveLottery:ReceiveRewardOk(gridId, itemId, num)
	WZLog("WndLoveLottery:ReceiveRewardOK ",gridId)
	WZLog("获得的物品名字是",self.m_tGiftName[gridId])
	WZLog("获得的物品ID是",self.m_tGiftId[gridId])
	self.m_tItemList = itemId
	self.m_tItemNumList = num
	
	self.m_isShowCellLotteryList = true
	
	self.m_nRewardId = gridId
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
	self.m_nLoadingId = nil

    self:setBtnLotteryEnable(false)
    local loveWishVip =  CacheCenter:getGameParam().luckyLotteryGainGold
    loveWishVip = tonumber(loveWishVip)
   
    self.m_root:enableSchedule("_scheduleSetCellState",0)
	
	self.m_bRaffling = true
end

--@brief	获得奖励列表错误处理
--@param	sMessage:错误信息
function WndLoveLottery:getRewardListErrorProcess(sMessage)
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
	MsgBoxManager:showTipBox(sMessage)
end



-------------------------------------私有方法模块End----------------------------------------
