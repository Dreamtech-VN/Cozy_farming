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
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndShopLottery:_unInit()
	self.m_root = nil
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

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
