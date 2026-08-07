--WndTowerSweepResultData.lua
--@brief	WndTowerSweepResult的数据模块
--@date		2015/04/29
--@author	xiaoyu_wu
--@note		爬塔副本扫荡结果窗口

WndTowerSweepResult = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTowerSweepResult:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil                  --数据表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTowerSweepResult:_unInit()
	self.m_root = nil
    self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTowerSweepResult:createElement()
	local element = WZUISystem:getInstance():createElement("WndTowerSweepResult")
	assert(element, "WndTowerSweepResult create element failed!")
	self:_init()
	return element
end

--@brief	显示窗口
--@note		调用此接口显示爬塔副本排行窗口
function WndTowerSweepResult:showWindow()
    local wndTowerSweepResult = self:createElement()
    WindowManager:addWindow(wndTowerSweepResult, self, nil, true)
end

--@brief	设置数据
--@param    startFloor : 开始扫荡层数
--@param    endFloor : 结束扫荡层数
--@param    rewardId : 奖励物品id
--@param    rewardCount : 奖励物品数量
function WndTowerSweepResult:setData(startFloor, endFloor, rewardId, rewardCount)
    WZLog("WndTowerSweepResult:setData ",startFloor,endFloor,rewardId,rewardCount)
    self.m_tData = {
        startFloor = startFloor,
        endFloor = endFloor,
        rewardId = {},
        rewardCount = {},
        gold = 0,
        exp = 0,
    }
    for i,v in ipairs(rewardId) do
        if v == 2 then --金币
            self.m_tData.gold = self.m_tData.gold + rewardCount[i]
        elseif v == 3 then --经验
            self.m_tData.exp = self.m_tData.exp + rewardCount[i]
        else
            local isExistIndex = 0
            for o,p in ipairs(self.m_tData.rewardId) do
                if p == v then
                    isExistIndex = o
                end
            end
            if isExistIndex ~=0 then
                self.m_tData.rewardCount[isExistIndex] = self.m_tData.rewardCount[isExistIndex] + rewardCount[i]
            else
                table.insert(self.m_tData.rewardId, v)
                table.insert(self.m_tData.rewardCount, rewardCount[i])
            end
        end
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
