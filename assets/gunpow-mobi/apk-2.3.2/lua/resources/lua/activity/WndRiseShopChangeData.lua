--WndRiseShopChangeData.lua
--@brief	WndRiseShopChange的数据模块
--@date		2021/06/25
--@author	hyx
--@note		崛起之路商店兑换

WndRiseShopChange = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRiseShopChange:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tChangeData = {}
	self.m_nCount = 1
	self.m_nMaxCount = nil
	self.m_nHsaMoney = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRiseShopChange:_unInit()
	self.m_root = nil
	self.m_tChangeData = {}
	self.m_nCount = 1
	self.m_nMaxCount = nil
	self.m_nHsaMoney = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRiseShopChange:createElement(data, refreshTime)
	if WndRiseShopChange.m_root ~= nil then
		WindowManager:removeWindow(WndRiseShopChange.m_root, WndRiseShopChange, true)
	end
	local element = WZUISystem:getInstance():createElement("WndRiseShopChange")
	assert(element, "WndRiseShopChange create element failed!")
	self:_init()
	self.m_tChangeData = data or {}
	self.m_nRefreshTime = refreshTime or 0
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
