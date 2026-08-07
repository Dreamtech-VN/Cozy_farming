--WndBlindData.lua
--@brief	WndBlind的数据模块
--@date		2021/03/22
--@author	hyx
--@note		弹弹盲盒

WndBlind = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBlind:_init()
	self.m_root = nil	 	  			--场景根节点
	self.main_container = nil
	self.m_sBoxCommonObj = nil
	self.m_nBlindScheduleId = nil
	self.m_tBoxRewardData = {}
	self.m_tBoxActivateData = {}
	self.m_tOpenORActiveData = {} --购买的开启的数据
	self.m_tShowReward = nil 			--显示奖励
	self.m_tOpenTimesSel = {1, 1, 1}
	self.m_nMaxTimes = 5   	      --最大购买次数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBlind:_unInit()
	self.m_root = nil
	self.main_container = nil
	self.m_sBoxCommonObj = nil
	self.m_nBlindScheduleId = nil
	self.m_tBoxRewardData = {}
	self.m_tBoxActivateData = {}
	self.m_tOpenORActiveData = {}
	self.m_tShowReward = nil
	self.m_tOpenTimesSel = nil
	self.m_nMaxTimes = nil   	      --最大购买次数
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBlind:createElement()
	if WndBlind.m_root ~= nil then
		WindowManager:removeWindow(WndBlind.m_root, WndBlind, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBlind")
	assert(element, "WndBlind create element failed!")
	self:_init()
	return element
end

--
function WndBlind:setOpenORActiveteData(data)
	for i=1,#data.openMaxs do
		local tab = {}
		tab.activeCount = data.openMaxs[i] --激活
		tab.buyCount = data.buyMaxs[i] --购买
		tab.openTime = data.openTimes[i] --开启次数，当为0购买激活
		tab.canBuy = data.canBuys[i] --可购买次数
		tab.rechargeId = data.recharges[i] --计费点
		self.m_tOpenORActiveData[i] = tab
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
