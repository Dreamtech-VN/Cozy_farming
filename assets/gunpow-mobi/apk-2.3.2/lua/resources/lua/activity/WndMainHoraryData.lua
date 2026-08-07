--WndMainHoraryData.lua
--@brief	WndMainHorary的数据模块
--@date		2021/07/19
--@author	hyx
--@note		占卜主界面

WndMainHorary = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMainHorary:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGetCardData = {}
	self.n_BigReward = nil --大奖奖励
	self.m_nVersion = nil
	self.m_nHoraryNumber = nil
	self.m_nFreeTimes = -1 --免费次数
	self.m_nCardSelect = -1 --选择骨牌
	self.m_nRewardIndex = -1--结束的时候选择今日奖励
	self.m_tChooseItemCell = nil
	self.m_bIsOpenCard = nil --开牌
	self.m_sHorarySpine = nil
	self.m_nHoraryType = nil
	self.m_sChooseTypeSpine = nil
	self.m_nCurMultiple = 0
	self.m_bIsFirstComeIn = nil
	self.n_tGxReward = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMainHorary:_unInit()
	self.m_root = nil
	self.m_tGetCardData = {}
	self.n_BigReward = nil
	self.m_nVersion = nil
	self.m_nHoraryNumber = nil
	self.m_nFreeTimes = -1
	self.m_nCardSelect = -1
	self.m_nRewardIndex = -1
	self.m_tChooseItemCell = nil
	self.m_bIsOpenCard = nil
	self.m_sHorarySpine = nil
	self.m_nHoraryType = nil
	self.m_sChooseTypeSpine = nil
	self.m_nCurMultiple = 0
	self.m_bIsFirstComeIn = nil
	self.n_tGxReward = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMainHorary:createElement()
	if WndMainHorary.m_root ~= nil then
		WindowManager:removeWindow(WndMainHorary.m_root, WndMainHorary, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMainHorary")
	assert(element, "WndMainHorary create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
