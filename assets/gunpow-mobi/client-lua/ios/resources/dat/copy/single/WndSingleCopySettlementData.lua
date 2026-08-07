--WndSingleCopySettlementData.lua
--@brief	WndSingleCopySettlement的数据模块
--@date		2015/05/22
--@author	xiaoyu_wu
--@note		单人副本结算窗口

WndSingleCopySettlement = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSingleCopySettlement:_init()
	self.m_root = nil	 	  			--场景根节点
    
    self.m_tData = nil                  --数据表
    self.isWin = nil
    self.m_nCountdown = 0               --倒计时

    self.dtTime = 0                     --定时器
    self.cellList = nil                 --任务子容器
    self.n_Tag = nil                    --当前的动画顺序的执行id
    self.n_moveTime = 0.25              --移动动画时间
    self.n_yanchi = 0.30
    self.n_scaleTime = 0.20             --按钮缩放大小的时间
    self.n_waitTime = {}                --延迟时间，0-发射特效，1-落下特效，2-加载奖励动画， 3-返回按钮特效
    self.b_doBack = false               --是否可以按返回键

    self.needAddExp = 0
    self.curLv = 0
    self.curExp = 0
    self.leftExp = 0
    self.failUiData = {}                 --失败的UI跳转相关信息
    self.isVideo = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSingleCopySettlement:_unInit()
	self.m_root = nil
    
    self.m_tData = nil
    self.isWin = nil
    self.m_nCountdown = 0

    self.dtTime = nil                     
    self.cellList = nil
    self.n_Tag = nil
    self.n_moveTime = nil
    self.n_yanchi =nil         
    self.n_scaleTime = nil
    self.n_waitTime = nil
    self.b_doBack = nil

    self.needAddExp = nil
    self.curLv = nil
    self.curExp = nil
    self.leftExp = nil
    self.failUiData = nil
    self.isVideo = false
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSingleCopySettlement:createElement()
	local element = WZUISystem:getInstance():createElement("WndSingleCopySettlement")
	assert(element, "WndSingleCopySettlement create element failed!")
	self:_init()
	return element
end

--@brief    显示普通竞技场结算窗口
--@param    tData, 数据表, 包含以下数据
-- pointId : 小关卡ID
-- passTimes : 当日通关次数
-- factor : 通关条件状态1位条件一，2位条件二，3位条件三
-- rewardId : 奖励物品id
-- rewardCount : 奖励物品数量
-- playerData = "sex,lv,exp,faceId,headId,bodyId,wingId,weaponId"
-- playerData = {sex = sex,level = level,exp = exp,equip = {faceId,headId,bodyId,wingId,weaponId}}
function WndSingleCopySettlement:showWindow(isWin,tData)
    local wnd = self:createElement()
    if tData == nil then
        WZLog("WndSingleCopySettlement:showWindow:   eeee")
    end
    self.m_tData = tData
    self.isVideo = tData.isVideo
    WZLog("WndSingleCopySettlement:showWindow:",tData.factor)
    WZLog("----------------------777---------------------",tData.pointId)
    for k,v in pairs(tData.playerData) do
        WZLog("---------k,v-----------",k,v)
    end


    self.isWin = isWin
    WindowManager:addWindow(wnd, self, false)

    g_copyET = os.time()
    local resultType = 0
    if isWin then resultType = 1 end
    local eventData = {stageType = 1,stageId = 2,subStageId = 1,stageCount = 1,
        startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = resultType}
    PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    是否有已完成的任务
--@return   #1,是否有已完成的任务
function WndSingleCopySettlement:_hasCompletedTask()
    if PrefetchCache:hasTaskList() then
        local tTaskList = PrefetchCache:getTaskList()
        if #tTaskList.tDailyTask.tToSubmit > 0 then
            return true
        end
        for i = 1, #tTaskList.tMainTask do
            if tTaskList.tMainTask[i].nTaskStatus == TASKSTATUS_TOSUBMIT then
                return true
            end
        end
        for i = 1, #tTaskList.tBranchTask do
            if tTaskList.tBranchTask[i].nTaskStatus == TASKSTATUS_TOSUBMIT then
                return true
            end
        end
    end
    return false
end




-------------------------------------私有方法模块End----------------------------------------
