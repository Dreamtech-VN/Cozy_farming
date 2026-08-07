--WndSetEnemyCommunityData.lua
--@brief	WndSetEnemyCommunity的数据模块
--@date		2017/3/27
--@author	zsq

WndSetEnemyCommunity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSetEnemyCommunity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLv = nil
	self.m_nVipLevel = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSetEnemyCommunity:_unInit()
	self.m_root = nil
	self.m_nLv = nil
	self.m_nVipLevel = nil
end

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSetEnemyCommunity:createElement()
	local element = WZUISystem:getInstance():createElement("WndSetEnemyCommunity")
	assert(element, "WndSetEnemyCommunity create element failed!")
	self:_init()
	return element
end

--@brief	从服务器返回设置敌对公会不成功的函数
function WndSetEnemyCommunity:setEnemyCommunityError(sMessage)
	MsgBoxManager:showTipBox(sMessage)
end 

-------------------------------------公有方法模块End----------------------------------------
