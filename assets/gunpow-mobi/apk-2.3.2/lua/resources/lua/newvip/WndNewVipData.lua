--WndNewVipData.lua
--@brief	WndNewVip的数据模块
--@date		2021/03/18
--@author	hyx
--@note		vip升级版本界面

WndNewVip = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndNewVip:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCurIndex = nil
	self.m_nSecIndex = nil
	self.m_tTitleData = {} --标题
	self.m_tBigView = {}
	self.m_sChildContainer = nil
	self.m_sTouchCurView = nil
	self.m_bIsJumpToFamous = false 		--是否跳转到名人榜
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndNewVip:_unInit()
	self.m_root = nil
	self.m_nCurIndex = nil
	self.m_nSecIndex = nil
	self.m_tTitleData = {}
	self.m_tBigView = {}
	self.m_sChildContainer = nil
	self.m_sTouchCurView = nil
	self.m_bIsJumpToFamous = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndNewVip:createElement()
	if WndNewVip.m_root ~= nil then
		WindowManager:removeWindow(WndNewVip.m_root, WndNewVip, true)
	end
	local element = WZUISystem:getInstance():createElement("WndNewVip")
	assert(element, "WndNewVip create element failed!")
	self:_init()
	return element
end

---------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
