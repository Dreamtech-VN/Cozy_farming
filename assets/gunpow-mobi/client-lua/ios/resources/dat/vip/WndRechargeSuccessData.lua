--WndRechargeSuccessData.lua
--@brief	WndRechargeSuccess的数据模块
--@date		2015-9-15
--@author	binshao
--@note		充值成功模块

WndRechargeSuccess = {
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRechargeSuccess:_init()
	self.m_root = nil	 	  	 --场景根节点
    self.data = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRechargeSuccess:_unInit()
	self.m_root = nil
    self.data = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRechargeSuccess:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root,WndRechargeSuccess)
    end
	local element = WZUISystem:getInstance():createElement("WndRechargeSuccess")
	assert(element, "WndRechargeSuccess create element failed!")
    Teach.PreUIChannelId = GlobalGame.g_nCurrentUIChannelId
	self:_init()
	return element
end

function WndRechargeSuccess:showWndUI(data)
    local wnd = WndRechargeSuccess:createElement()
    WindowManager:addWindow( wnd ,WndRechargeSuccess,true)
    self:setData(data)
end
---------------------------------------------------------------------------------------------------------------------------

-- 获取最大的VIP等级表
function WndRechargeSuccess:_getMaxLevel()
    local maxLv = 0
    for k,v in pairs(GDatatab_vip) do
        maxLv = maxLv + 1
    end
    return maxLv
end


--count	int	获得钻石数量
--isUp	boolean	vip是否升级
--vipLevel	int	当前vip等级
function WndRechargeSuccess:setData(data)
    self.data = data
    self:_update()
end