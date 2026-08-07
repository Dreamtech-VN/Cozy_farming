--WndCommunityTaskReleaseData.lua
--@brief	WndCommunityTaskRelease的数据模块
--@date		2016/06/17
--@author	zsq
--@note		公会发布任务界面

WndCommunityTaskRelease = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCommunityTaskRelease:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tSelectedCell = nil
	self.m_tID = nil
	self.m_nCost = nil
	self.m_nCostId = nil
	self.m_nTopTabIndex = 1 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCommunityTaskRelease:_unInit()
	self.m_root = nil
	self.m_tSelectedCell = nil
	self.m_tID = nil
	self.m_nCost = nil
	self.m_nCostId = nil
	self.m_nTopTabIndex = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCommunityTaskRelease:createElement()
	local element = WZUISystem:getInstance():createElement("WndCommunityTaskRelease")
	assert(element, "WndCommunityTaskRelease create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置标签数量
function WndCommunityTaskRelease:setTopTabVisible()
	-- body
	WZLog("WndCommunityTaskRelease:setTopTabVisible", type(CacheCenter:getPlayerInfo().position))
	if tonumber(WndCommunityTask.m_bJurisdiction) == 1 then 
		for i = 1, 3 do
			GetElement(self.m_root, "checkbox" .. i .. "_WndCommunityTaskRelease", WZUICheckBox):setVisible(true)
		end
	else
		for i = 1, WndCommunityTask.m_nTaskDayIndex do
			GetElement(self.m_root, "checkbox" .. i .. "_WndCommunityTaskRelease", WZUICheckBox):setVisible(true)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
