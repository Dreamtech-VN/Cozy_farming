--WndMatchDeclareData.lua
--@brief	WndMatchDeclare的数据模块
--@date		2018/06/20
--@author	Tianxiang_Xu
--@note		征婚中心-宣言

WndMatchDeclare = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMatchDeclare:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nType = nil 					--1:登记；2:修改
	self.m_tCost = nil					--登记消耗
	self.m_nRegisterDays = nil 			--登记有效时间
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMatchDeclare:_unInit()
	self.m_root = nil
	self.m_nType = nil 					--1:登记；2:修改
	self.m_tCost = nil					--登记消耗
	self.m_nRegisterDays = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMatchDeclare:createElement()
	if WndMatchDeclare.m_root ~= nil then
		WindowManager:removeWindow(WndMatchDeclare.m_root, WndMatchDeclare, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMatchDeclare")
	assert(element, "WndMatchDeclare create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
--@param    征婚系统的外部接口
function WndMatchDeclare:showInterface(nType)
    --body
    local wndMatch = WndMatchDeclare:createElement()
    if wndMatch then
    	self.m_nType = nType
        WindowManager:addWindow(wndMatch, WndMatchDeclare, nil, nil, nil, true)
    end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
