--WndCircleReportData.lua
--@brief	WndCircleReport的数据模块
--@date		2020/07/07
--@author	XTX
--@note		好友圈举报界面

WndCircleReport = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCircleReport:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCircleId = nil 
	self.m_tReason = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCircleReport:_unInit()
	self.m_root = nil
	self.m_nCircleId = nil 
	self.m_tReason = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCircleReport:createElement()
	if WndCircleReport.m_root ~= nil then
		WindowManager:removeWindow(WndCircleReport.m_root, WndCircleReport, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCircleReport")
	assert(element, "WndCircleReport create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCircleReport:showInterface(circleId)
	-- body
	local wndReport = WndCircleReport:createElement()
	if wndReport then 
		self.m_nCircleId = circleId
		WindowManager:addWindow(wndReport, WndCircleReport, false, nil, nil, true)
	end
end

--@brief 	举报成功
function WndCircleReport:reportSuccess()
	-- body
	if self.m_root == nil then return end 

	MsgBoxManager:showTipBox(LocalStrings.CHAT_REPORT_TEXT1)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
