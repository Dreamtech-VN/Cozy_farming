--WndNewYearSignRewardData.lua
--@brief	WndNewYearSignReward的数据模块
--@date		2020/12/14
--@author	hyx
--@note		求签获取的奖励

WndNewYearSignReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNewYearSignReward:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nSignResult = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNewYearSignReward:_unInit()
	self.m_root = nil
	self.m_nSignResult = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNewYearSignReward:createElement()
	if WndNewYearSignReward.m_root ~= nil then
		WindowManager:removeWindow(WndNewYearSignReward.m_root, WndNewYearSignReward, true)
	end
	local element = WZUISystem:getInstance():createElement("WndNewYearSignReward")
	assert(element, "WndNewYearSignReward create element failed!")
	self:_init()
	return element
end

function WndNewYearSignReward:setResultData(result, itemId, itemNum)
	self.m_nSignResult = result
	self.m_tSignItemId = itemId
	self.m_tItemNum = itemNum
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
