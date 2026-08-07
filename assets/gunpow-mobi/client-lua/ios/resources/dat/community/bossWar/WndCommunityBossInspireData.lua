--WndCommunityBossInspireData.lua
--@brief	WndCommunityBossInspire的数据模块
--@date		2017-01-19
--@note		公会boss活动结束界面

WndCommunityBossInspire = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityBossInspire:_init()
	self.m_root = nil	 	  			--场景根节点
    self.data = nil
    self.m_bInspireClick = nil
    self.m_nInspireNum = nil 
    self.isUseTicket = nil 		--是否使用双货币
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityBossInspire:_unInit()
	self.m_root = nil
    self.data = nil
    self.m_bInspireClick = nil
    self.m_nInspireNum = nil 
    self.isUseTicket = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityBossInspire:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityBossInspire")
	assert(element, "WndCommunityBossInspire create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------
--@brief   创建加载框
function WndCommunityBossInspire:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndCommunityBossInspire:closeLoading()
	if self.m_nLoadingId then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
		self.m_nLoadingId = nil
	end
end
-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------