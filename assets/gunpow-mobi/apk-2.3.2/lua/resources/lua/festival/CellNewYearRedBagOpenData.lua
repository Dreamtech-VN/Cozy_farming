--CellNewYearRedBagOpenData.lua
--@brief	CellNewYearRedBagOpen的数据模块
--@date		2021/01/07
--@author	hyx
--@note		新年红包开启

CellNewYearRedBagOpen = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearRedBagOpen:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tOpenReward = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearRedBagOpen:_unInit()
	self.m_root = nil
	self.m_tOpenReward = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearRedBagOpen:createElement(reward)
	if CellNewYearRedBagOpen.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearRedBagOpen.m_root, CellNewYearRedBagOpen, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewYearRedBagOpen")
	assert(element, "CellNewYearRedBagOpen create element failed!")
	self:_init()
	self.m_tOpenReward = reward
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
