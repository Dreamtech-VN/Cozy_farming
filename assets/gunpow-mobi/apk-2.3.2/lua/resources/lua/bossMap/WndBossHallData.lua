--WndBossHallData.lua
--@brief	WndBossHall的数据模块
--@date		2024/11/05
--@author	XTX
--@note		游戏内边玩边下进度窗口

WndBossHall = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBossHall:_init()
	self.m_root = nil	 	  			--场景根节点
	
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBossHall:_unInit()
	self.m_root = nil
	
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBossHall:createElement()
	local element = WZUISystem:getInstance():createElement("WndBossHall")
	assert(element, "WndBossHall create element failed!")
	self:_init()
	return element
end


--@brief	提供给外部的函数
function WndBossHall:showInterface()
	local  wndBossHall =  WndBossHall:createElement()
	if wndBossHall ~= nil then 
		WindowManager:addWindow(wndBossHall, WndBossHall, nil, nil, nil, true)
	end 
end 

--@brief 	下载完成回调
function WndBossHall:_downloadFinish()
	if self.m_root == nil then return end 
	
	self:_setDynamicUiText2()
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
