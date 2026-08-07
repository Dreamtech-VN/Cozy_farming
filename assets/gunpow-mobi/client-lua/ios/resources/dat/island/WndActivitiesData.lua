--WndActivitiesData.lua
--@brief	WndActivities的数据模块
--@date		2014/01/08
--@author	liangguang_long
--@note		活动广场模块

WndActivities = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndActivities:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sSqureUrl = nil    			--网址
	self.m_nLoadingId = nil      		--加载框ID
	self.extendParameters = ""          --额外参数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndActivities:_unInit()
	self.m_root = nil
	self.m_sSqureUrl = nil    	--网址
	self.m_nLoadingId = nil      --加载框ID
	self.extendParameters = nil
end


-------------------------------------公有方法模块Begin--------------------------------------
function WndActivities:showView()
	WZLog("WndActivities:showView:")
	local wndActivitiesElement = WndActivities:createElement()
     WindowManager:addWindow( wndActivitiesElement,WndActivities,nil,false )
end

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndActivities:createElement()
	local element = WZUISystem:getInstance():createElement("WndActivities")
	assert(element, "WndActivities create element failed!")
	self:_init()
	return element
end

--@brief	获活动广场数据函数
--@param	#1 squreUrl : 网址
function WndActivities:setActivitiesList( squreUrl )
	if self.m_root == nil then 
		return 
	end
	self.m_sSqureUrl = squreUrl		--网址
	--更新函数
	self:_update()
	WZLog("Url::::::::::::::1" , squreUrl)
end	
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
