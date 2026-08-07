--WndCommunityLogData.lua
--@brief	WndCommunityLog的数据模块
--@date		2015/04/28
--@author	zsq
--@note		入会限制

WndCommunityLog = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityLog:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLv = nil 
	self.m_nVipLevel = nil 
	self.m_nFighting = nil 
	self.m_nWinType = nil 				--0=公会；1=联盟
	self.m_nFightStep = 50000 			--战力调整步长
	self.m_nMinLv = nil 				--最小等级限制
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityLog:_unInit()
	self.m_root = nil
	self.m_nLv = nil 
	self.m_nVipLevel = nil 
	self.m_nFighting = nil 
	self.m_nWinType = nil 
	self.m_nFightStep = nil 
	self.m_nMinLv = nil 				--最小等级限制
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityLog:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityLog")
	assert(element, "WndCommunityLog create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndCommunityLog:showInterface(nWinType)
	-- body
	local wndSetting = WndCommunityLog:createElement()
	if wndSetting then 
		self.m_nWinType = nWinType or 0
		WindowManager:addWindow(wndSetting, WndCommunityLog, nil, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
--@brief	英文包适配函数
function WndCommunityLog:_adaptLanguage_en()
	if self.m_root == nil then
		return
	end
end

function WndCommunityLog:_adaptLanguage_pt(  )
	if self.m_root == nil then
		return
	end
end

--@brief	泰文包适配函数
function WndCommunityLog:_adaptLanguage_th()
	if self.m_root == nil then
		return
	end
end
