--WndMasterImpartData.lua
--@brief	WndMasterImpart的数据模块
--@date		2016/07/23
--@author	zsq
--@note		师傅授业

WndMasterImpart = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterImpart:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nExp = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterImpart:_unInit()
	self.m_root = nil
	self.m_nExp = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterImpart:createElement()
	local element = WZUISystem:getInstance():createElement("WndMasterImpart")
	assert(element, "WndMasterImpart create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    外部调用创建此窗口
function WndMasterImpart:show()
	WZLog("WndMasterImpart:show")
	if self.m_root ~= nil then return end
	local wnd = WndMasterImpart:createElement()
	WindowManager:addWindow(wnd, WndMasterImpart, nil, nil, true)
	
	self:update()
end

function WndMasterImpart:setData(taskId, progress, giveTaskId, num, lastTime, alltaskId)
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	masterInfo.honorTime = num
	masterInfo.lastTime = lastTime
	masterInfo.moralityExp = masterInfo.moralityExp + self.m_nExp
	MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO75,tonumber(self.m_nExp)))
	self.m_nExp = 0

	self:update()
end


-------------------------------------私有方法模块End----------------------------------------
