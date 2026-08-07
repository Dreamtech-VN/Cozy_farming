--WndVipWebData.lua
--@brief	WndVipWeb的数据模块
--@date		2017-1-13
--@author	mjf
--@note		VIP模块

WndVipWeb = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndVipWeb:_init()
	self.m_root = nil	 	  	 --场景根节点
    self.m_tData = nil
    self.sdkData = nil
    self.m_nCount = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndVipWeb:_unInit()
	self.m_root = nil
    self.m_tData = nil
    self.sdkData = nil
    self.m_nCount = 1
end

function WndVipWeb:setData(count)
    self.m_nCount = count + 1
    local data = GDatatab_webpage_recharge["id_" .. (count + 1)]
    WZLog("WndVipWeb:setData", Serialize(data))
    self.m_tData = data
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndVipWeb:createElement()
	local element = WZUISystem:getInstance():createElement("WndVipWeb")
	assert(element, "WndVipWeb create element failed!")
    Teach.PreUIChannelId = GlobalGame.g_nCurrentUIChannelId
	self:_init()
	return element
end

---------------------------------------------------------------------------------------------------------------------------
