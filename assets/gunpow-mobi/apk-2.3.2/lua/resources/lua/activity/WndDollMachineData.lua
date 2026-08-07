--WndDollMachineData.lua
--@brief	WndDollMachine的数据模块
--@date		2021/04/29
--@author	hyx
--@note		娃娃机

WndDollMachine = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDollMachine:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nDollMachineNum = nil --娃娃币数量
	self.m_nFreeCount = 0 --免费次数
	self.m_tBigRewardIds = {}
	self.m_tBigRewardNums = {}
	self.m_tBigReward1Ids = {}
	self.m_tBigReward1Nums = {}
	self.m_sImgDollHook = nil
	self.m_sImgGift = nil
	self.m_bLotterying = nil
	self.m_nChooseReward = 0 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nActivityId = nil 
	self.m_tBigRewards = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDollMachine:_unInit()
	self.m_root = nil
	self.m_nDollMachineNum = nil
	self.m_nFreeCount = 0
	self.m_tBigRewardIds = {}
	self.m_tBigRewardNums = {}
	self.m_tBigReward1Ids = {}
	self.m_tBigReward1Nums = {}
	self.m_sImgDollHook = nil
	self.m_sImgGift = nil
	self.m_bLotterying = nil
	self.m_nChooseReward = nil 		--选择奖励状态0：弹出预览界面；1：不弹
	self.m_nActivityId = nil 
	self.m_tBigRewards = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDollMachine:createElement()
	if WndDollMachine.m_root ~= nil then
		WindowManager:removeWindow(WndDollMachine.m_root, WndDollMachine, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDollMachine")
	assert(element, "WndDollMachine create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
