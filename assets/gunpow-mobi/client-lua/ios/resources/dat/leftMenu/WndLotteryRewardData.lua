--WndLotteryRewardData.lua
--@brief	WndLotteryReward的数据模块
--@date		2014/09/20
--@author	张盛强
--@note		爱心许愿礼盒奖励框

WndLotteryReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLotteryReward:_init()
	WZLog("call _init()")
	self.m_root = nil	 	  			--场景根节点
    self.m_nId = nil
    self.m_nTag = nil
	self.backFunc = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLotteryReward:_unInit()
	self.m_root = nil
    self.m_nId = nil
    self.m_nTag = nil
	self.backFunc = nil
end

--@brief   设置关闭回调
function WndLotteryReward:closeCallBack(tcell,backFunc)
	if tcell and backFunc then
		self.backFunc = {}
		self.backFunc[1] = tcell
		self.backFunc[2] = backFunc
	end
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLotteryReward:createElement()
    local element = WZUISystem:getInstance():createElement("WndLotteryReward")
    assert(element, "WndLotteryReward create element failed!")
    self:_init()
    return element
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------
