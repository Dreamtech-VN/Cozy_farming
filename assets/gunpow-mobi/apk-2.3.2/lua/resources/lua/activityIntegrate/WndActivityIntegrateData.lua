--WndActivityIntegrateData.lua
--@brief	WndActivityIntegrate的数据模块
--@date		2020/07/16
--@author	hyx
--@note		活动整合模块

WndActivityIntegrate = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndActivityIntegrate:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nFirstCurIndex = nil --大标题
	self.integerInterfacePanel = {}
	self.m_sTouchCurrentFace = nil
	self.m_btnRule = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndActivityIntegrate:_unInit()
	self.m_root = nil
	self.m_nFirstCurIndex = nil
	self.integerInterfacePanel = {}
	self.m_sTouchCurrentFace = nil
	self.m_btnRule = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndActivityIntegrate:createElement()
	if WndActivityIntegrate.m_root ~= nil then
		WindowManager:removeWindow(WndActivityIntegrate.m_root, WndActivityIntegrate, true)
	end
	local element = WZUISystem:getInstance():createElement("WndActivityIntegrate")
	assert(element, "WndActivityIntegrate create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------