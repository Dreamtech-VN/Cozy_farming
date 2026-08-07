--CellLoveLotteryBoxData.lua
--@brief	CellLoveLotteryBox的数据模块
--@date		2017/10/20
--@author	Tianxiang_Xu
--@note		幸运转盘保底奖励进度

CellLoveLotteryBox = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellLoveLotteryBox:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tData = nil 
	self.m_nCurTimes = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellLoveLotteryBox:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nCurTimes = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellLoveLotteryBox:createElement()
	local element = WZUISystem:getInstance():createElement("CellLoveLotteryBox")
	assert(element, "CellLoveLotteryBox create element failed!")
	self:_init()
	return element
end

--@brief 	设置奖励宝箱数据
--@param 	bUpdatePrg:用于延迟更新进度
function CellLoveLotteryBox:setData(luckNum, rewardSet, bUpdatePrg)
	-- body
	if self.m_root == nil then return end 
	WndGameActivity:_closeLoading()
	 
	if self.m_tData == nil then 
		local tempTable = CacheCenter:getLotteryItems()
		if tempTable == nil or tempTable.lotteryCount == nil then return end
		self.m_tData = {}
		self.m_tData.curTimes = luckNum
		self.m_tData.firstTimes = tempTable.lotteryCount[1]
		self.m_tData.secondTimes = tempTable.lotteryCount[2]
		self.m_tData.thirdTimes = tempTable.lotteryCount[3]
		self.m_tData.lotteryReward = tempTable.lotteryReward
		self.m_tData.lotteryCount = tempTable.lotteryCount

		self:_update()
	else
		if bUpdatePrg and luckNum then 
			self.m_tData.curTimes = luckNum
			self.m_nCurTimes = nil 
			self:_update()
		else
			self.m_nCurTimes = luckNum 
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
