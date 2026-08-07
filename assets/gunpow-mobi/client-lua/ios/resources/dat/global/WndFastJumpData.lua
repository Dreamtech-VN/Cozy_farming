--WndFastJumpData.lua
--@brief	WndFastJump的数据模块
--@date		2017/09/08
--@author	 
--@note		快速跳转

WndFastJump = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFastJump:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nOpenLevel = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFastJump:_unInit()
	self.m_root = nil
	self.m_nOpenLevel = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFastJump:createElement()
	if WndFastJump.m_root ~= nil then
		WindowManager:removeWindow(WndFastJump.m_root, WndFastJump, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFastJump")
	assert(element, "WndFastJump create element failed!")
	self:_init()
	return element
end

--@brief 添加到当前的场景
function WndFastJump:addParentRoot(level)
	WZLog("WndFastJump:addParentRoot")
	local element = self:createElement()
	self.m_nOpenLevel = level
	WindowManager:addWindow(element, self, true,nil,nil,true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
