--CellNewYearTaskGrowupData.lua
--@brief	CellNewYearTaskGrowup的数据模块
--@date		2020/12/01
--@author	hyx
--@note		元旦每日任务

CellNewYearTaskGrowup = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearTaskGrowup:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTaskGrowupData = {}
	self.m_tGrowupTaskItemCell = {}
	self.m_nType = nil 
	self.m_tOtherData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearTaskGrowup:_unInit()
	self.m_root = nil
	self.m_tTaskGrowupData = nil 
	self.m_tGrowupTaskItemCell = nil 
	self.m_nType = nil 
	self.m_tOtherData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearTaskGrowup:createElement(data, nType, otherData)
	if CellNewYearTaskGrowup.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearTaskGrowup.m_root, CellNewYearTaskGrowup, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewYearTaskGrowup")
	assert(element, "CellNewYearTaskGrowup create element failed!")
	self:_init()
	self.m_tTaskGrowupData = data
	self.m_nType = nType
	self.m_tOtherData = otherData 
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
