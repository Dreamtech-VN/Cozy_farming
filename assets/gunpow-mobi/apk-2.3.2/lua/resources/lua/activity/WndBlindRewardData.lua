--WndBlindRewardData.lua
--@brief	WndBlindReward的数据模块
--@date		2021/03/30
--@author	hyx
--@note		盲盒获取奖励

WndBlindReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBlindReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRewardData = {}
	self.m_nType = 0 					--0：盲盒奖励；1:射箭大奖
	self.m_tCallBackFun = nil 			--关闭回调
	self.m_tOtherData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBlindReward:_unInit()
	self.m_root = nil
	self.m_tRewardData = nil
	self.m_nType = nil 
	self.m_tCallBackFun = nil 			--关闭回调
	self.m_tOtherData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBlindReward:createElement(data)
	if WndBlindReward.m_root ~= nil then
		WindowManager:removeWindow(WndBlindReward.m_root, WndBlindReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBlindReward")
	assert(element, "WndBlindReward create element failed!")
	self:_init()
	self:setRewardData(data)
	return element
end

function WndBlindReward:setRewardData(data)
	data = data or {}
	self.m_tRewardData = data
end

--@brief 	设置关闭回调
function WndBlindReward:setCallFunc(tCell, func)
	-- body
	self.m_tCallBackFun = {}
	self.m_tCallBackFun[1] = tCell
	self.m_tCallBackFun[2] = func
end

--@brief 	外部接口
function WndBlindReward:showInterface(tData, nType, otherData)
	-- body
	local wndBlind = WndBlindReward:createElement(tData)
	if wndBlind then 
		self.m_nType = nType or 0
		self.m_tOtherData = otherData
		WindowManager:addWindow(wndBlind, WndBlindReward, nil, false)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
