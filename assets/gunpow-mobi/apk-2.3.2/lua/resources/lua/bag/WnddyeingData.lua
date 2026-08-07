--WnddyeingData.lua
--@brief	Wnddyeing的数据模块
--@date		2016/08/17
--@author	zsq
--@note		染色

Wnddyeing = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function Wnddyeing:_init()
	self.m_root = nil	 	  			--场景根节点
	self.conPlayer = nil
	self.m_tDressGrid = nil
	self.m_tDress = nil
	self.m_nHeadIndex = nil
	self.m_nBodyIndex = nil
	self.m_nCostId = nil
	self.m_nCost = nil
	self.m_tempElement = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function Wnddyeing:_unInit()
	self.m_root = nil
	self.conPlayer = nil
	self.m_tDressGrid = nil
	self.m_tDress = nil
	self.m_nHeadIndex = nil
	self.m_nBodyIndex = nil
	self.m_nCostId = nil
	self.m_nCost = nil
	self.m_tempElement = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function Wnddyeing:createElement()
	local element = WZUISystem:getInstance():createElement("Wnddyeing")
	assert(element, "Wnddyeing create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function Wnddyeing:updatePlayerItemData()
	self:updateCost()
end




-------------------------------------私有方法模块End----------------------------------------
