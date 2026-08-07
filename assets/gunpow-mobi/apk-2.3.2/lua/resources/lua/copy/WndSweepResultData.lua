--WndSweepResultData.lua
--@brief	WndSweepResult的数据模块
--@date		2015/04/15
--@author	xiaoyu_wu
--@note		扫荡结果页面

WndSweepResult = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSweepResult:_init()
	self.m_root = nil	 	  			--场景根节点
    
    self.m_tData = nil                  --数据表
    self.m_tRewardList = nil            --奖励列表，key为当前挑战序号，value为奖励物品列表
    self.m_nCurrendIndex = 0            --当前已经显示的序号
    self.m_nCreateCellSweep = 0         --创建cell的数量
    self.m_nCreateCellItem = 0
    self.m_nCreateCellItemCount = 0 
    self.m_bActionPlayFinish = false
    self.m_oCurPlayAnim = nil
    self.m_nCellPlayAnim = -1
    self.m_nCellPlayCount = 0
    self.m_bSweepFlag = false           --扫荡状态
    self.m_nSweepType = nil
    self.m_tCallback = nil
    self.m_tCallbackFun = nil
    self.m_oImage = nil
    self.m_nClearIndexCount = nil --扫荡次数，主要是用于计算每一次扫荡不同关卡的时候的重置
    self.m_nWinType = 0     --1:英雄塔扫荡 2:获取途径一键扫荡
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSweepResult:_unInit()
	self.m_root = nil
    
    self.m_tData = nil
    self.m_tRewardList = nil
    self.m_nCurrendIndex = 0
    self.m_nCreateCellItem = nil
    self.m_nCreateCellSweep = nil
    self.m_nCreateCellItemCount = nil 
    self.m_bActionPlayFinish = nil
    self.m_oCurPlayAnim = nil
    self.m_nCellPlayAnim = nil
    self.m_bSweepFlag = false
    self.m_nCellPlayCount = nil
    self.m_nSweepType = nil
    self.m_tCallback = nil
    self.m_tCallbackFun = nil
    self.m_oImage = nil
    self.m_nClearIndexCount = nil
    self.m_nWinType = nil     --1:英雄塔扫荡
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSweepResult:createElement()
	local element = WZUISystem:getInstance():createElement("WndSweepResult")
	assert(element, "WndSweepResult create element failed!")
	self:_init()
	return element
end

--@brief	显示窗口
--@param type : 扫荡类型1:一次扫荡 2 ：多次扫荡
--@param    nWinType : 1:英雄塔扫荡；0默认
--@note		调用此接口显示扫荡窗口
function WndSweepResult:showWindow(tData,ttype, nWinType)
    WZLog("WndSweepResult:showWindow")
    local wndSweepResult = nil
    if self.m_root == nil then
        wndSweepResult = self:createElement()
    else
        self.m_tData = nil                  
        self.m_tRewardList = nil            
        self.m_nCurrendIndex = 0            
        self.m_nCreateCellSweep = 0         
        self.m_nCreateCellItem = 0
        self.m_nCreateCellItemCount = 0 
        self.m_bActionPlayFinish = false
        self.m_oCurPlayAnim = nil
        self.m_nCellPlayAnim = -1
        self.m_nCellPlayCount = 0
        self.m_bSweepFlag = false          
        self.m_nSweepType = nil
        self.m_tCallback = nil
        self.m_tCallbackFun = nil
        self.m_bSweeping = false
        self.m_bClose = true
    end
    self.m_bSweepFlag = false
    self.m_nSweepType = ttype
    self.m_nWinType = nWinType or 0
    self.m_tData = tData
    self:_parseData()
    if self.m_root == nil then
        WindowManager:addWindow(wndSweepResult, self, nil, true)
    else
        self:_initUI()
    end
end

--@brief    显示窗口
--@param type : 扫荡类型1:一次扫荡 2 ：多次扫荡
--@note     调用此接口显示扫荡窗口
function WndSweepResult:showWindow2(tData,ttype)
    WZLog("WndSweepResult:showWindow2")
    local wndSweepResult = self:createElement()
    self.m_bSweepFlag = false
    self.m_nSweepType = ttype
    self.m_tData = tData
    self:_parseData()
    WindowManager:addWindow(wndSweepResult, self, nil, true)
end

--@brief 设置再次扫荡回调函数
function WndSweepResult:setSweepCallback(tab,tabFunc)
    self.m_tCallback = tab
    self.m_tCallbackFun = tabFunc
end

--@brief	获取数据表
--@return   #1,数据表
function WndSweepResult:getData()
    return self.m_tData
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	解析数据表
--@note     将数据表解析为奖励列表，将每次挑战的奖励物品拆分开来
function WndSweepResult:_parseData()
    WZLog("WndSweepResult:_parseData", self.m_nWinType, Serialize(self.m_tData.rewardNum))
    self.m_tRewardList = {}
    local nCursor = 1

    local id_index = 1 --获取到关卡的id
    local totle = 0
    if self.m_nWinType == 2 then
        totle = self.m_tData.raidsNum[id_index]
    end
    for i,nCount in ipairs(self.m_tData.rewardNum) do --[1]=2,[2]=2,[3]=3,[4]=3,[5]=2,
        local tRewardList = {}
        WZLog("nCursor+nCount-1..... ",nCursor+nCount-1, nCursor, nCount)
        for j=nCursor,nCursor+nCount-1 do
            local tReward = {
                rewardId = self.m_tData.rewardId[j],
                rewardCount = self.m_tData.rewardCount[j],
                rewardIndex = i,
            }
            table.insert(tRewardList, tReward)
            nCursor = j
        end
        nCursor = nCursor+1
        self.m_tRewardList[i] = tRewardList

        if self.m_nWinType == 2 then --获取途径一键扫荡时
            if self.m_tData.pointId and self.m_tData.pointId[id_index] then
                self.m_tRewardList[i].level_id = self.m_tData.pointId[id_index]
                if i == totle then
                    id_index = id_index + 1
                    if self.m_tData.raidsNum and self.m_tData.raidsNum[id_index] then
                        totle = totle + self.m_tData.raidsNum[id_index]
                    end
                end
            end
        end
    end
    self:_mergeData()
end

--@brief  相同层，有相同的奖品则进行合并
function WndSweepResult:_mergeData()
    WZLog("WndSweepResult:_mergeData")
    for i,v in ipairs(self.m_tRewardList) do
        local itemIds = {}
        local exitInfo= {}
        for j,k in ipairs(v) do
            local isExit = false
            local exitIndex = nil
            local exitItemId = nil
            local preIndex = nil
            local exitRewardIndex = nil
            for q,p in ipairs(itemIds) do
                if p[2] == k.rewardId then
                    isExit = true
                    exitIndex = j
                    exitItemId = p[2]
                    preIndex = p[1]
                    exitRewardIndex = k.rewardIndex
                end
            end
            if isExit then
                local tempMsg = {}
                table.insert(tempMsg,exitIndex)
                table.insert(tempMsg,exitItemId)
                table.insert(tempMsg,preIndex)
                table.insert(tempMsg,exitRewardIndex)
                table.insert(exitInfo,tempMsg)
            else
                local notExitInfo = {}
                table.insert(notExitInfo,j)
                table.insert(notExitInfo,k.rewardId)
                table.insert(itemIds,notExitInfo)
            end
        end
        if #exitInfo >0 then
            for r,u in ipairs(exitInfo) do
                local index = nil
                local count = 0
                local preIndex = nil
                for i,q in ipairs(v) do
                    if u[4] == q.rewardIndex and u[2] == q.rewardId then
                        count = count + 1
                        if count == 1 then
                            preIndex = i
                        end
                        if count == 2 then
                            index = i
                        end
                    end
                end
                if index ~= nil and preIndex ~= nil then
                    v[preIndex].rewardCount = v[preIndex].rewardCount + v[index].rewardCount
                    table.remove(v,index)
                end
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
