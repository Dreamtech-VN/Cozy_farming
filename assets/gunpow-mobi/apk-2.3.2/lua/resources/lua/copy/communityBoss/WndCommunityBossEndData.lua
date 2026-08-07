--WndCommunityBossEndData.lua
--@brief	WndCommunityBossEnd的数据模块
--@date		2017-01-19
--@note		公会boss活动结束界面

WndCommunityBossEnd = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityBossEnd:_init()
	self.m_root = nil	 	  			--场景根节点
    self.data = nil
    self.isDesc = nil                   -- 是否显示结算动画
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityBossEnd:_unInit()
	self.m_root = nil
    self.data = nil
    self.isDesc = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityBossEnd:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityBossEnd")
	assert(element, "WndCommunityBossEnd create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------