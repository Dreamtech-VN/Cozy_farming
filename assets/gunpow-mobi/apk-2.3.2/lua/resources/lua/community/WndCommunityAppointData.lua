--WndCommunityAppointData.lua
--@brief	WndCommunityAppoint的数据模块
--@date		2016/08/30
--@author	zsq
--@note		职位任命

WndCommunityAppoint = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityAppoint:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil
	self.m_nTag = nil
	self.m_nNumber = nil
	self.m_nTotal = nil
	self.m_tChangeList = nil
	self.m_bLoding = nil
	self.m_nCurrentCellIndex = nil
	self.m_bIsShowSortList = false 
	self.m_nSortTypeSel = 1 
	self.m_nWinType = nil --0=公会；1=联盟
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityAppoint:_unInit()
	self.m_root = nil
	self.m_tDataList = nil
	self.m_nTag = nil
	self.m_nNumber = nil
	self.m_nTotal = nil
	self.m_tChangeList = nil
	self.m_bLoding = nil
	self.m_nCurrentCellIndex = nil
	self.m_bIsShowSortList = nil 
	self.m_nSortTypeSel = nil 
	self.m_nWinType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityAppoint:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityAppoint")
	assert(element, "WndCommunityAppoint create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCommunityAppoint:showInterface(nWinType)
	local wnd = WndCommunityAppoint:createElement()
	if wnd then 
		self.m_nWinType = nWinType or 0
		WindowManager:addWindow(wnd, WndCommunityAppoint, true, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
