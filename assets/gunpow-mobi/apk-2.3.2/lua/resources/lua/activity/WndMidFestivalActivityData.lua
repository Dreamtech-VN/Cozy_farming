--WndMidFestivalActivityData.lua
--@brief	WndMidFestivalActivity的数据模块
--@date		2021/08/18
--@author	hyx
--@note		中秋活动主界面

WndMidFestivalActivity = {
	--请不要在这里定义变量
}
WndMidFestivalActivity.Panel = {
	[7025] = "CellMidFestival1", --中秋佳节
	[7026] = "CellMidFestival2", --花好月圆
	[7027] = "CellMidFestival3", --中秋豪礼
}
--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMidFestivalActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTitleIndex = 0
	self.m_bIsData = {} --是否存在
	self.m_tMidFestivalActivityData = {}
	self.m_nSelectIndex = nil
	self.m_tTitleItem = {}
	self.m_sCurMidFestivalActivityPanel = nil
	self.m_tMidFestivalActivityPanel = {}
	self.m_tSetTitleRedPoint = {} --标签的红点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMidFestivalActivity:_unInit()
	self.m_root = nil
	self.m_nTitleIndex = 0
	self.m_bIsData = {}
	self.m_tMidFestivalActivityData = {}
	self.m_nSelectIndex = nil
	self.m_tTitleItem = {}
	self.m_sCurMidFestivalActivityPanel = nil
	self.m_tMidFestivalActivityPanel = {}
	self.m_tSetTitleRedPoint = {}
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMidFestivalActivity:createElement()
	if WndMidFestivalActivity.m_root ~= nil then
		WindowManager:removeWindow(WndMidFestivalActivity.m_root, WndMidFestivalActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMidFestivalActivity")
	assert(element, "WndMidFestivalActivity create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
