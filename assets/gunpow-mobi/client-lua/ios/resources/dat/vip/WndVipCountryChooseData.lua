--WndVipCountryChooseData.lua
--@brief	WndVipCountryChoose的数据模块
--@date		2017-1-13
--@author	mjf
--@note		VIP模块

WndVipCountryChoose = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndVipCountryChoose:_init()
	self.m_root = nil	 	  	 --场景根节点
    self.m_nCountry = 1
    self.m_sName = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndVipCountryChoose:_unInit()
	self.m_root = nil
    self.m_nCountry = 1
    self.m_sName = nil
end

function WndVipCountryChoose:setData(country)
    local name = GDatatab_payment_method["id_" .. country].name
    WZLog("WndVipCountryChoose:setData", country, name)
    self.m_nCountry = country
    self.m_sName = name
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndVipCountryChoose:createElement()
	local element = WZUISystem:getInstance():createElement("WndVipCountryChoose")
	assert(element, "WndVipCountryChoose create element failed!")
    Teach.PreUIChannelId = GlobalGame.g_nCurrentUIChannelId
	self:_init()
	return element
end

---------------------------------------------------------------------------------------------------------------------------
