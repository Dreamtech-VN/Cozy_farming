--WndSingleCopyMyIslandData.lua
--@brief	WndSingleCopyMyIsland的数据模块
--@date		2018/06/14
--@author	Tianxiang_Xu
--@note		我的小岛界面

WndSingleCopyMyIsland = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSingleCopyMyIsland:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tIslandHostId = nil  --已占岛Id
	self.m_tIslandAssistId = nil 		--助战岛id
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSingleCopyMyIsland:_unInit()
	self.m_root = nil
	self.m_tIslandHostId = nil  --已占岛Id
	self.m_tIslandAssistId = nil 		--助战岛id
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSingleCopyMyIsland:createElement()
	if WndSingleCopyMyIsland.m_root ~= nil then
		WindowManager:removeWindow(WndSingleCopyMyIsland.m_root, WndSingleCopyMyIsland, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSingleCopyMyIsland")
	assert(element, "WndSingleCopyMyIsland create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndSingleCopyMyIsland:showInterface(hostId,assistId)
	-- body
	local wndMyIsland = WndSingleCopyMyIsland:createElement()
	if wndMyIsland then
		self.m_tIslandHostId = hostId  --已占岛Id
		self.m_tIslandAssistId = assistId 	--助战岛id

    	WindowManager:addWindow(wndMyIsland, WndSingleCopyMyIsland)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
