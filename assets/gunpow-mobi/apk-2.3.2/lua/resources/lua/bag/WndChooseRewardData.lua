--WndChooseRewardData.lua
--@brief	WndChooseReward的数据模块
--@date		2021/05/14
--@author	hyc
--@note		自选礼包选择奖励

WndChooseReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChooseReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_data = {}
	self.m_chooseData = {}				--选中的物品
	self.m_tabList = {}					--所有自选奖励item
	self.m_nMaxNum = nil 				--最大的数量
	self.m_nNum = 1
	self.m_nWinType = nil 				--窗口类型 0：默认自选礼包界面；1兑换
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChooseReward:_unInit()
	self.m_root = nil
	self.m_data = nil
	self.m_chooseData = nil				--选中的物品
	self.m_tabList = nil
	self.m_nMaxNum = nil 				--最大的数量
	self.m_nNum = nil 
	self.m_nWinType = nil 				--窗口类型 0：默认自选礼包界面；1兑换
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChooseReward:createElement()
	if WndChooseReward.m_root ~= nil then
		WindowManager:removeWindow(WndChooseReward.m_root, WndChooseReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndChooseReward")
	assert(element, "WndChooseReward create element failed!")
	self:_init()
	return element
end

--设置数据
function WndChooseReward:setData(tData, winType)
	self.m_data = tData
	self.m_nWinType = winType or 0
	self.m_nNum = 1
	if self.m_nWinType == 0 then 
		local nOwnNum = CacheCenter:getPlayerItemCountById(self.m_data.id)
		self.m_nMaxNum = math.min(100, nOwnNum)
		self:onUpdateUi()
	elseif self.m_nWinType == 1 then 
		self.m_nMaxNum = tData.maxNum
		self:onUpdateUiExchange()
	end
	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
