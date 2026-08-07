--WndDailyCopySettlementData.lua
--@brief	WndDailyCopySettlement的数据模块
--@date		2015-7-25
--@author	binshao
--@note		日常副本结算窗口

WndDailyCopySettlement = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDailyCopySettlement:_init()
	self.m_root = nil	 	  			--场景根节点
    self.tData = nil                  --数据表
    self.descTime = 0                 -- 倒计时
    self.isDescFrame = false          -- 是否显示结算框
    self.isDescAni = false            -- 是否显示结算动画
    self.needAddExp = 0
    self.curLv = 0
    self.curExp = 0
    self.leftExp = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDailyCopySettlement:_unInit()
	self.m_root = nil
    self.tData = nil
    self.descTime = nil
    self.isDescFrame = nil
    self.isDescAni = nil
    self.needAddExp = 0
    self.curLv = 0
    self.curExp = 0
    self.leftExp = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDailyCopySettlement:createElement()
	local element = WZUISystem:getInstance():createElement("WndDailyCopySettlement")
	assert(element, "WndDailyCopySettlement create element failed!")
	self:_init()
	return element
end

-- mapId 表示当前战斗地图的ID
-- fightId 表示当前的战斗类型 1表示金币副本，2表示经验副本 3宠物夺宝
-- fightData 表示战斗里面的数据
-- 当fightId = 1 时，  胜利：fightData = {伤害总量int，大金币个数int，小金币个数int，boss是否死亡int 1表示死亡 0 表示没死亡,boss总血量}
-- 当fightId = 2 时， 胜利：fightData = {击杀小怪数量int，击杀精英怪数量int，击杀boss数量int，遗漏怪物数量int}
-- 当fightId = 3 时， 胜利：fightData = {击蛋分，出手次数，是否击杀boss(1击杀boss,0没有打死boss)，自己打了多少伤害}
-- {mapId = 1000, fightId = 1, fightData = {2,5,6,100,0},isWin = false,expInfo = {expLv = 5, exp = 5000}}
function WndDailyCopySettlement:showWindow(tData)
    WZLog("WndDailyCopySettlement:showWindow")
    local wnd = WndDailyCopySettlement:createElement()
    WindowManager:addWindow(wnd, self,false)
    self.tData = tData

    self.curExp = tData.expInfo.exp
    self.curLv = tData.expInfo.expLv
    -- 如果胜利就发送消息给服务器
    if self.tData.isWin then
        local data
        if self.tData.fightId == 1 then
            self:_initAddGold()
        elseif self.tData.fightId == 2 then
            self:_initExpData()
        elseif self.tData.fightId == 3 then
            
        end
    end
    self:_update()

    g_copyET = os.time()
    local resultType = 0
    if self.tData.isWin then resultType = 1 end
    local eventData = {stageType = 1,stageId = 1,subStageId = self.tData.fightId,stageCount = 1,
        startTime = g_copyST,endTime = g_copyET,playTime = g_copyET-g_copyST,resultType = resultType}
    PostPlayerEvent:postEvent(PostPlayerEvent.event_playerstage, eventData)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 获取日常经验副本的经验加成
function WndDailyCopySettlement:_initExpData()
    self.needAddExp = 0
    --WZLog("------_initExpData------self.tData.rewardId,self.tData.rewardCount---",#self.tData.rewardId, #self.tData.rewardCount)
    if self.tData.rewardId and self.tData.rewardCount then
        local rewardId = self.tData.rewardId
        local rewardCnt = self.tData.rewardCount
        for i = 1, #rewardId do
            if rewardId[i] == 3 then
                self.needAddExp = rewardCnt[i]
            end
        end
    end
    self.leftExp = self.needAddExp
    self.tData.fightData[4] = self.needAddExp
    WZLog("---------------add exp-----------------",self.needAddExp)

end

-- 获取日常副本的金币加成
function WndDailyCopySettlement:_initAddGold()
    self.tData.fightData[5] = self.tData.fightData[4]
    self.tData.fightData[4] = 0
    WZLog("-----_initAddGold-------self.tData.rewardId,self.tData.rewardCount----------",self.tData.rewardId, self.tData.rewardCount)
    if self.tData.rewardId and self.tData.rewardCount then
        local rewardId = self.tData.rewardId
        local rewardCnt = self.tData.rewardCount
        for i = 1, #rewardId do
            if rewardId[i] == 2 then
                self.tData.fightData[4] = rewardCnt[i]
            end
        end
    end
    WZLog("-----------------get gold data-------------------",self.tData.fightData[5])
end




-------------------------------------私有方法模块End----------------------------------------
