--WndChatReportMenuData.lua
--@brief	WndChatReportMenu的数据模块
--@date		2019/08/14
--@author	Tianxiang_Xu
--@note		举报按钮

WndChatReportMenu = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChatReportMenu:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tClickMsgData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChatReportMenu:_unInit()
	self.m_root = nil
	self.m_tClickMsgData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChatReportMenu:createElement()
	if WndChatReportMenu.m_root ~= nil then
		WndChatReportMenu.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndChatReportMenu")
	assert(element, "WndChatReportMenu create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndChatReportMenu:showInterface(parentNode, tData)
	-- body
	if self.m_root then 
		self.m_root:removeFromParentAndCleanup(true)
	end
	local wndChatReport = WndChatReportMenu:createElement()
	if wndChatReport then 
		self.m_tClickMsgData = tData
		wndChatReport:setRelativePosition(GlobalMethod:ccp(0.98, 0.5))
		parentNode:addChild(wndChatReport)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
