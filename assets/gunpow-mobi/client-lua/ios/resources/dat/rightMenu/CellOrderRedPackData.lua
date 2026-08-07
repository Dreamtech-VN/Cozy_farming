--CellOrderRedPackData.lua
--@brief	CellOrderRedPack的数据模块
--@date		2018/06/02
--@author	Tianxiang_Xu
--@note		口令红包-代言人模板

CellOrderRedPack = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellOrderRedPack:_init()
	self.m_root = nil	 	  			--场景根节点
	self.startTime = nil
	self.endTime = nil 
	self.tips = nil
	self.count = nil 
	self.maxCount = nil
	self.rewardCounts = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellOrderRedPack:_unInit()
	self.m_root = nil
	self.startTime = nil
	self.endTime = nil
	self.tips = nil
	self.count = nil
	self.maxCount = nil
	self.rewardCounts = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellOrderRedPack:createElement()
	local element = WZUISystem:getInstance():createElement("CellOrderRedPack")
	assert(element, "CellOrderRedPack create element failed!")
	self:_init()
	return element
end

--@brief 	设置数据
function CellOrderRedPack:setMessage(startTime, endTime, tips, count, maxCount, rewardCounts)
	-- body
	WZLog("CellOrderRedPack:setMessage")
	self.startTime = startTime
	self.endTime = endTime 
	self.tips = tips
	self.count = count 
	self.maxCount = maxCount
	self.rewardCounts = rewardCounts

	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
