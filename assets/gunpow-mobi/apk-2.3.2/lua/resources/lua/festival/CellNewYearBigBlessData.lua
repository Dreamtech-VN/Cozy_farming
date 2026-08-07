--CellNewYearBigBlessData.lua
--@brief	CellNewYearBigBless的数据模块
--@date		2021/01/08
--@author	hyx
--@note		祈福大奖

CellNewYearBigBless = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearBigBless:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBigBlessReward = {}
	self.m_nFirePlayNum = 0 			--烟花播放的次数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearBigBless:_unInit()
	self.m_root = nil
	self.m_tBigBlessReward = {}
	self.m_nFirePlayNum = nil 			--烟花播放的次数
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearBigBless:createElement(reward)
	if CellNewYearBigBless.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearBigBless.m_root, CellNewYearBigBless, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewYearBigBless")
	assert(element, "CellNewYearBigBless create element failed!")
	self:_init()
	self.m_tBigBlessReward = reward
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
