--WndHoraryBigRewardData.lua
--@brief	WndHoraryBigReward的数据模块
--@date		2021/07/30
--@author	hyx
--@note		占星大奖

WndHoraryBigReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHoraryBigReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nBigType = nil
	self.m_sBigRewardItem = nil
	self.m_bDoubleBigRewardType = nil 
	self.m_sFishSpine = nil
	self.m_tOtherBigReward = nil 
	self.m_tSpecialReward = nil 
	self.m_tCallBackFun = nil 			--回调
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHoraryBigReward:_unInit()
	self.m_root = nil
	self.m_nBigType = nil
	self.m_sBigRewardItem = nil
	self.m_bDoubleBigRewardType = nil
	self.m_sFishSpine = nil
	self.m_tOtherBigReward = nil 
	self.m_tSpecialReward = nil 
	self.m_tCallBackFun = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHoraryBigReward:createElement()
	if WndHoraryBigReward.m_root ~= nil then
		WindowManager:removeWindow(WndHoraryBigReward.m_root, WndHoraryBigReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHoraryBigReward")
	assert(element, "WndHoraryBigReward create element failed!")
	self:_init()
	return element
end

--@brief 	设置关闭界面回调方法
function WndHoraryBigReward:setCallback(tCell, func)
	self.m_tCallBackFun = {}

	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
