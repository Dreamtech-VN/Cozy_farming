--WndPvpSegmentRewardData.lua
--@brief	WndPvpSegmentReward的数据模块
--@date		2016-3-29
--@author	binshao
--@note		排位赛段位奖励

WndPvpSegmentReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPvpSegmentReward:_init()
	self.m_root = nil	 	  			--场景根节点
    self.weekReward = nil               -- 周奖励
    self.playerRank = nil               -- 玩家排名
    self.segmentReward = nil            -- 段位奖励
    self.myRank = nil                   -- 我的排名
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPvpSegmentReward:_unInit()
	self.m_root = nil
    self.weekReward = nil
    self.playerRank = nil
    self.segmentReward = nil
    self.myRank = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPvpSegmentReward:createElement()
	local element = WZUISystem:getInstance():createElement("WndPvpSegmentReward")
	assert(element, "WndPvpSegmentReward create element failed!")
	self:_init()
	return element
end


-- 初始化段位奖励
function WndPvpSegmentReward:initSegmentReward()
    self.segmentReward = {}
    for k,v in pairs(GDatatab_rank_segment) do
        if v.unlock ~= -1 then
            table.insert(self.segmentReward,v)
        end
    end
    local function sort(r1,r2)
        return r1.id < r2.id
    end
    table.sort(self.segmentReward,sort)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------