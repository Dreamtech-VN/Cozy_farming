--WndTowerSettlementData.lua
--@brief	WndTowerSettlement的数据模块
--@date		2015/05/07
--@author	xiaoyu_wu
--@note		爬塔副本结算窗口

WndTowerSettlement = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTowerSettlement:_init()
	self.m_root = nil	 	  			--场景根节点
    self.data = nil                  --数据表
    self.staticData = nil
    self.m_nCountdown = 0               --倒计时
    
    self.m_nAddExp = 0                  --增加的总经验            
    self.m_nCurAddExp = 0               --当前显示的已经增加的经验，动画用
    self.m_nAddExpStep = 0              --每次经验增加的数值，动画用
    self.m_nCurLevel = 0                --当前显示的等级，动画用
    self.m_nCurExp = 0                  --当前显示的经验，动画用
    self.dtTime = 0                     --定时器
    self.cellList = nil                 --任务子容器
    self.n_Tag = nil                    --当前的动画顺序的执行id
    self.n_moveTime = 0.25              --移动动画时间
    self.n_yanchi = 0.30
    self.n_scaleTime = 0.20             --按钮缩放大小的时间
    self.n_waitTime = {}                --延迟时间，0-发射特效，1-落下特效，2-加载奖励动画， 3-返回按钮特效
    self.b_doBack = false               --是否可以按返回键

    self.levelId = nil

    self.needAddExp = 0
    self.curLv = 0
    self.curExp = 0
    self.leftExp = 0
    self.failUiData = {}                 --失败的UI跳转相关信息
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTowerSettlement:_unInit()
	self.m_root = nil
    self.data = nil
    self.staticData = nil
    self.m_nCountdown = 0
    
    self.m_nAddExp = 0                         
    self.m_nCurAddExp = 0  
    self.m_nAddExpStep = 0     
    self.m_nCurLevel = 0              
    self.m_nCurExp = 0
    self.dtTime = 0                     
    self.cellList = nil                
    self.n_Tag = nil                   
    self.n_moveTime = nil
    self.n_yanchi = nil
    self.n_scaleTime = nil
    self.n_waitTime = nil               
    self.b_doBack = nil         

    self.levelId = nil

    self.needAddExp = nil
    self.curLv = nil
    self.curExp = nil
    self.leftExp = nil
    self.failUiData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTowerSettlement:createElement()
	local element = WZUISystem:getInstance():createElement("WndTowerSettlement")
	assert(element, "WndTowerSettlement create element failed!")
	self:_init()
	return element
end

--@brief    显示爬塔副本结算窗口
-- tData = {levelId = 40001, curHpPer = 40, curRoundCnt = 20}
-- levelId 关卡ID
-- curHpPer 当前HP剩余百分比
-- curRoundCnt 当前战斗的回合数
function WndTowerSettlement:showWindow(tData)
    --tData = {levelId = 40001, curHpPer = 40, curRoundCnt = 5}
    local wnd = WndTowerSettlement:createElement()
    self.data = tData
    WZLog("WndTowerSettlement:showWindow", Serialize(tData))
    if WBattleGlobal:getCurrent():isSingleStage(COPYTYPE_TOWER) then 
        self.staticData = GDatatab_tower_map["id_"..self.data.levelId]
    end
    WindowManager:addWindow(wnd, self, false)

    g_copyET = os.time()
    local resultType = 0
    if WBattleGlobal:getCurrent():isHeroTowerStage() then 
        if self.data.nHp > 0 then resultType = 1 end
        local eventData = {stageType = 1,stageId = 5,subStageId = 1,stageCount = 1,
            startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = resultType}
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
    else
        if self:_getFightResult() == 1 then resultType = 1 end
        local eventData = {stageType = 1,stageId = 4,subStageId = 1,stageCount = 1,
            startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = resultType}
        PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
    end
end

-- 获取战斗结果
-- 返回结果1表示战斗成功，2表示未达到条件失败，3表示死亡失败
function WndTowerSettlement:_getFightResult()
    local hp = self.staticData.pass_hp
    local cnt = self.staticData.pass_round
    local curHp = self.data.curHpPer
    local curCnt = self.data.curRoundCnt

    if curHp >= hp and curCnt <= cnt then
        return 1
    elseif curHp > 0 then
        return 2
    else
        return 3
    end

    return 1
end

--@brief    返回结果
function WndTowerSettlement:returnResult()
    -- body
    if WBattleGlobal:getCurrent():isHeroTowerStage() then 
        if self.data.nHp > 0 then
            return true
        end
    else
        if self:_getFightResult() == 1 then 
            return true
        end
    end

    return false 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
