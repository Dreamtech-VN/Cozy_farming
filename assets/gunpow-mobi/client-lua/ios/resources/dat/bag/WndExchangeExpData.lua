--WndExchangeExpData.lua
--@brief	WndExchangeExp的数据模块
--@date		2016/12/06
--@author	Tianxiang_Xu
--@note		兑换经验窗口

WndExchangeExp = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndExchangeExp:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nExchangeTimes = nil         --今日已经转化的次数
    self.m_nCurSpillExp = nil           --当前溢出的经验
    self.m_nCostExp = nil               --消耗的溢出经验
    self.m_nGainRewards = nil           --获得的物品数量
    self.m_nTotalCostExp = nil               --快速消耗的溢出经验
    self.m_nTotalGainRewards = nil           --快速获得的物品数量
    self.m_nGainId = nil                --转化获得的物品ID
    self.m_nLoadingId = nil             
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndExchangeExp:_unInit()
    self.m_root = nil
    self.m_nExchangeTimes = nil         --今日已经转化的次数
    self.m_nCurSpillExp = nil           --当前溢出的经验
    self.m_nCostExp = nil               --消耗的溢出经验
    self.m_nGainRewards = nil           --获得的物品数量
    self.m_nTotalCostExp = nil               --快速消耗的溢出经验
    self.m_nTotalGainRewards = nil           --快速获得的物品数量
    self.m_nGainId = nil                --转化获得的物品ID
    self.m_nLoadingId = nil             
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndExchangeExp:createElement()
	local element = WZUISystem:getInstance():createElement("WndExchangeExp")
	assert(element, "WndExchangeExp create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndExchangeExp:showInterface()
    -- body
    local wndExp = WndExchangeExp:createElement()
    if wndExp then
        WindowManager:addWindow(wndExp, WndExchangeExp,nil,nil,nil,true)
    end
end

--@brief    设置数据
function WndExchangeExp:setData(status, overflowExp, exchangeTimes, costExp, gainReward, autoExchangeCostNum, autoExchangeGainNum)
    -- body
    self:_closeLoading()

    self.m_nExchangeTimes = exchangeTimes         --今日已经转化的次数
    self.m_nCurSpillExp = overflowExp           --当前溢出的经验
    self.m_nCostExp = costExp               --消耗的溢出经验
    self.m_nGainRewards = gainReward           --获得的物品数量
    self.m_nTotalCostExp = autoExchangeCostNum               --快速消耗的溢出经验
    self.m_nTotalGainRewards = autoExchangeGainNum           --快速获得的物品数量

    self:_update()
end

--@brief    转化成功处理
function WndExchangeExp:exchangeSuccess(gainNum)
    -- body
    self:_closeLoading()
    
    WndRewardShow:showById({self.m_nGainId},{gainNum})
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    网络连接loading
function WndExchangeExp:_createLoading()
    -- body
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief    关闭网络连接loading
function WndExchangeExp:_closeLoading()
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end




-------------------------------------私有方法模块End----------------------------------------
