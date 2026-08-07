--WndShopLotteryData.lua
--@brief	WndShopLottery的数据模块
--@date		2017/09/04
--@author	zsq
--@note		商城抽奖

WndShopLottery = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndShopLottery:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList7 = {}      --抽奖数据
	self.m_tCellList7 = {}      --抽奖Cell
	self.m_nPosition7 = 1       --抽奖位置
	self.m_nEndPosition7 = 1	--停止位置
	self.m_nRound7 = 3			--抽奖转的圈数
	self.m_nLucky = nil         --抽奖幸运值
	self.m_tRewardId = {}		--奖励物品
	self.m_tRewardNum = {}		--奖励数量
	self.m_nTime7 = 1			--当前抽奖次数
	self.m_bRunning7 = false
	self.m_bCloseAni = false 	--是否跳过动画
	self.m_nUpdateRewardTime = 0 	--距离更新奖池时间
	self.m_nType = 2 
	self.m_nLotteryNum = 0 		--总抽奖次数
	self.m_tExtendReward = nil 	--额外奖励数据
	self.m_bIsUpdate = false 	
	self.m_nodeLuckyTime = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndShopLottery:_unInit()
	self.m_root = nil
	self.m_bCloseAni = nil 
	self.m_nUpdateRewardTime = nil 	--距离更新奖池时间
	self.m_nType = nil 
	self.m_nLotteryNum = nil 		--总抽奖次数
	self.m_tExtendReward = nil 	--额外奖励数据
	self.m_bIsUpdate = nil 
	self.m_nodeLuckyTime = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndShopLottery:createElement()
	if WndShopLottery.m_root ~= nil then
		WindowManager:removeWindow(WndShopLottery.m_root, WndShopLottery, true)
	end
	local element = WZUISystem:getInstance():createElement("WndShopLottery")
	assert(element, "WndShopLottery create element failed!")
	self:_init()
	return element
end

--@brief 	获取额外奖励状态
function WndShopLottery:getExtendRewardState()
	-- body
	local bHaveNoFinish = false
	local bHaveReward = false 
	local nTimes = 0  
	for i = 1, #self.m_tExtendReward do
		if not bHaveNoFinish and self.m_tExtendReward[i].status == 0 then 
			bHaveNoFinish = true
			nTimes = self.m_tExtendReward[i].targetTimes - self.m_nLotteryNum
		end
		if self.m_tExtendReward[i].status == 1 then 
			bHaveReward = true
		end
	end

	return bHaveReward, bHaveNoFinish, nTimes
end

--@brief 	领取额外奖励
function WndShopLottery:getExtendRewardOK(itemId, itemNum, extId)
	-- body
	pushEquipInList()

	WndRewardShow:showById(itemId, itemNum)
	if self.m_root == nil then return end 

	for i = 1, #self.m_tExtendReward do
		if self.m_tExtendReward[i].extId == extId then 
			self.m_tExtendReward[i].status = 2
			break 
		end
	end
	--设置额外奖励按钮红点
	self:setExtendRewardBtnRedDot()
	
	if WndEquipReward and WndEquipReward.m_root then 
		WndEquipReward:setRewardData(self.m_tExtendReward, nil, self.m_nLotteryNum)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
