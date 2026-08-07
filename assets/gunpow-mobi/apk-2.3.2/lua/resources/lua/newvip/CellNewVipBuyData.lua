--CellNewVipBuyData.lua
--@brief	CellNewVipBuy的数据模块
--@date		2021/03/22
--@author	hyx
--@note		钻石购买

CellNewVipBuy = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellNewVipBuy:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tRechargeData = nil
	self.rechargeTableContainer = nil
	self.loadingId_CellBuy = nil
	self.m_nCardActivityState = nil 
    self.m_nBuyCardTimes = nil 
    self.m_nCardActivityEndTime = nil 
    self.m_sCountDownTime = nil

end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewVipBuy:_unInit()
	self.m_root = nil
	self.m_tRechargeData = nil
	self.rechargeTableContainer = nil
	self.loadingId_CellBuy = nil
	self.m_nCardActivityState = nil 
    self.m_nBuyCardTimes = nil 
    self.m_nCardActivityEndTime = nil 
    self.m_sCountDownTime = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellNewVipBuy:createElement(nType)
	if CellNewVipBuy.m_root ~= nil then
		WindowManager:removeWindow(CellNewVipBuy.m_root, CellNewVipBuy, true)
	end
	local element = WZUISystem:getInstance():createElement("CellNewVipBuy")
	assert(element, "CellNewVipBuy create element failed!")
	self:_init()
	self:setBuyType(nType)
	return element
end

--@brief	设置购买类型 1钻石类型(默认为1) 2新货币id_177类型
function CellNewVipBuy:setBuyType(nType)
	nType = nType or 1
	self.m_nType = nType
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
