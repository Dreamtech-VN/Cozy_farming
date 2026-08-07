--WndTransactionOperateData.lua
--@brief	WndTransactionOperate的数据模块
--@date		2017/03/15
--@author	zsq
--@note		交易行操作

WndTransactionOperate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTransactionOperate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCost = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTransactionOperate:_unInit()
	self.m_root = nil
	self.m_nCost = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTransactionOperate:createElement()
	local element = WZUISystem:getInstance():createElement("WndTransactionOperate")
	assert(element, "WndTransactionOperate create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
