--CellNewYearTaskOtherData.lua
--@brief	CellNewYearTaskOther的数据模块
--@date		2022/03/04
--@author	XTX
--@note		任务面板

CellNewYearTaskOther = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewYearTaskOther:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTaskOtherData = {}
	self.m_tOtherTaskItemCell = {}
	self.m_nType = nil 
	self.m_tOtherData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewYearTaskOther:_unInit()
	self.m_root = nil
	self.m_tTaskGrowupData = nil 
	self.m_tOtherTaskItemCell = nil 
	self.m_nType = nil 
	self.m_tOtherData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewYearTaskOther:createElement(data, nType, otherData)
	if CellNewYearTaskOther.m_root ~= nil then
		WindowManager:removeWindow(CellNewYearTaskOther.m_root, CellNewYearTaskOther, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewYearTaskOther")
	assert(element, "CellNewYearTaskOther create element failed!")
	self:_init()
	self.m_tTaskOtherData = data
	self.m_nType = nType
	self.m_tOtherData = otherData 
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
