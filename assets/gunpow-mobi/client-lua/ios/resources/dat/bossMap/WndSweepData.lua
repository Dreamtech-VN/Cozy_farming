--WndSweepData.lua
--@brief	WndSweep2的数据模块
--@date		2014/08/21
--@author	hugozheng
--@note		购买活力面板

WndSweep = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSweep:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_data = nil                   --扫荡数据
    self.m_currentTime = nil            --扫荡次数
    self.m_needActivity = nil           --所需活力
    self.m_starting = nil               --已经开始扫荡
    self.m_stepTime = nil               --扫荡间隔时间
    self.m_timeCounter = nil            --扫荡时间
    self.m_exp = nil                    --奖励经营
    self.m_reward = nil                 --奖励物品
    self.m_reeardGolds = nil            --奖励金币
    self.m_nCanBuyTimes = nil           --购买次数
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSweep:_unInit()
	self.m_root = nil
    self.m_data = nil
    self.m_currentTime = nil
    self.m_needActivity = nil
    self.m_starting = nil
    self.m_stepTime = nil
    self.m_timeCounter = nil
    self.m_exp = nil                   
    self.m_reward = nil
    self.m_nCanBuyTimes = nil
    self.m_reeardGolds = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSweep:createElement()
	local element = WZUISystem:getInstance():createElement("WndSweep")
	assert(element, "WndSweep create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------

--@brief	刷新扫荡画面调用的函数
--@param	pointId:小关卡ID
--@param	useVigor:消耗活力值
--@param	vigor:剩余活力值
--@param	maxVigor:最大活力值
--@param	passTime:已挑战次数
--@param	totalTime:总挑战次数
--@note		
function WndSweep:updateData(name,pointId,useVigor,vigor,maxVigor,passTime,totalTime)
    self.m_data = {}
    self.m_data.name = name
	self.m_data.pointId = pointId
    self.m_data.useVigor = useVigor
    self.m_data.vigor = vigor
    self.m_data.maxVigor = maxVigor
    self.m_data.passTime = passTime
    if totalTime == -1 then
        self.m_data.totalTime = totalTime
    else
        self.m_data.totalTime = (totalTime - passTime)
    end
    self.m_currentTime = 1
    self.m_needActivity = useVigor
    --self.m_nCanBuyTimes = nCanBuyTimes
    WndSweep:updateSweepPanel()
end
-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
