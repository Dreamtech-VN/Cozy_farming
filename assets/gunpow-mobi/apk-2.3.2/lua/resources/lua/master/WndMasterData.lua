--WndMasterData.lua
--@brief	WndMaster的数据模块
--@date		2015/05/27
--@author	zsq
--@note		师徒大厅

WndMaster = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMaster:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = 1 				--当前页签下标
	self.m_tCheckElement = {} 			--存放子对象
	self.m_bIsMasterUpgrade = nil
	self.m_tTarget = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMaster:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_tCheckElement = {}
	self.m_bIsMasterUpgrade = nil
	self.m_tTarget = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMaster:createElement()
	if WndMaster.m_root ~= nil then
		WindowManager:removeWindow(WndMaster.m_root, WndMaster, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMaster")
	assert(element, "WndMaster create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndMaster:showInterface()
	local wnd = WndMaster:createElement()
	WindowManager:addWindow(wnd, WndMaster)
end

function WndMaster:setMasterUpgrade(bBool)
	self.m_bIsMasterUpgrade = bBool
end

function WndMaster:getMasterUpgrade()
	return self.m_bIsMasterUpgrade
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
