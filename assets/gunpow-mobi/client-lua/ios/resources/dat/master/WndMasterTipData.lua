--WndMasterTipData.lua
--@brief	WndMasterTip的数据模块
--@date		2015/05/29
--@author	zsq
--@note		师徒系统弹框

WndMasterTip = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterTip:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.m_bReceivedRequest = nil
	self.m_tCurID = nil
	self.m_tCurText = nil
	self.m_tCurName = nil
	self.m_tChatInfo = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterTip:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bReceivedRequest = nil
	self.m_tCurID = nil
	self.m_tCurText = nil
	self.m_tCurName = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterTip:createElement()
	local element = WZUISystem:getInstance():createElement("WndMasterTip")
	assert(element, "WndMasterTip create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
