--WndTeamCopySweepData.lua
--@brief	WndTeamCopySweep的数据模块
--@date		2017/02/17
--@author	qixiang
--@note		组队副本扫荡

WndTeamCopySweep = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTeamCopySweep:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nDiff = 1
	self.m_elementSel = nil
	self.m_nCopyId = nil
	self.m_nDifficulty = nil
	self.m_nCopyId1 = nil  --简单难度的副本ID
	self.m_nCopyId2 = nil  --困难难度的副本ID
	self.m_nCopyId3 = nil  --地狱难度的副本ID
	self.m_nRaidsTimes = nil
	self.m_nLoadingTag = nil

	self.m_nSweepCostItemId = nil
	self.m_nSweepCostNum = nil
	self.m_bSweeping = nil
	self.m_nPassTime = nil 
	self.m_nMaxTime = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTeamCopySweep:_unInit()
	self.m_root = nil
	self.m_nDiff = nil
	self.m_nCopyId = nil
	self.m_nDifficulty = nil
	self.m_nCopyId1 = nil  --简单难度的副本ID
	self.m_nCopyId2 = nil  --困难难度的副本ID
	self.m_nCopyId3 = nil  --地狱难度的副本ID
	self.m_nRaidsTimes = nil
	self.m_nLoadingTag = nil
	self.m_nSweepCostItemId = nil
	self.m_nSweepCostNum = nil
	self.m_bSweeping = nil
	self.m_nPassTime = nil 
	self.m_nMaxTime = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTeamCopySweep:createElement()
	local element = WZUISystem:getInstance():createElement("WndTeamCopySweep")
	assert(element, "WndTeamCopySweep create element failed!")
	self:_init()
	return element
end

-- teamCopyId : 组队副本章节ID
-- difficulty : 最高的困系数 普通 1 困难 2 地狱 3
-- passTime : 已经使用的次数
-- maxTime : 最大次数
function WndTeamCopySweep:show(teamCopyId,difficulty, passTime, maxTime)
	-- body
	local element = self:createElement()
	self.m_nCopyId = teamCopyId
	self.m_nDifficulty = difficulty
	self.m_nPassTime = passTime 
	self.m_nMaxTime = maxTime 
	local tempInfo = GDatatab_team_map["id_" .. teamCopyId]
	if tempInfo.difficulty == 1 then
		self.m_nCopyId1 = teamCopyId 
		self.m_nCopyId2 = teamCopyId + 1  
		self.m_nCopyId3 = teamCopyId + 2  
	elseif tempInfo.difficulty == 2 then
		self.m_nCopyId1 = teamCopyId -1
		self.m_nCopyId2 = teamCopyId 
		self.m_nCopyId3 = teamCopyId + 1  
	elseif tempInfo.difficulty == 3 then
		self.m_nCopyId1 = teamCopyId -2
		self.m_nCopyId2 = teamCopyId -1
		self.m_nCopyId3 = teamCopyId
	end

	WindowManager:addWindow(element,self,nil,true,nil,true)
end

function WndTeamCopySweep:setSweepStats(bSweeping)
	-- body
	if self.m_root == nil then return end
	self.m_bSweeping = bSweeping
end

function WndTeamCopySweep:setSweepInfo(sweepCount)
	-- body
	WZLog("WndTeamCopySweep:setSweepInfo")
	if not self.m_root then return end
	self:closeLoadingB()
	self.m_nRaidsTimes = sweepCount
	self:initUI()
end

function WndTeamCopySweep:sweepSuccess(pointId, rewardNum, rewardId, rewardCount,flopId,flopCount, times, flopRebate)
	WZLog("WndTeamCopySweep:sweepSuccess ",pointId)
	if not self.m_root then return end
	self:closeLoadingB()
	self.m_bSweeping = false
	local nType = 1
	if times > 1 then
		nType = 2 
	end
	WndSweepResult:showWindow2({
        pointId = pointId,
        rewardNum = rewardNum,
        rewardId = rewardId,
        rewardCount = rewardCount,
        flopId = flopId,
        flopCount = flopCount,
        sweepTimes = times,
        flopRebate = flopRebate,
    }, nType)
end


function WndTeamCopySweep:showLoadingB()
	WZLog("WndTeamCopySweep:showLoadingB")
	self.m_nLoadingTag = MsgBoxManager:showLoadingBox()
end

function WndTeamCopySweep:closeLoadingB()
	WZLog("WndTeamCopySweep:closeLoadingB")
	if self.m_nLoadingTag then
		MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingTag)
		self.m_nLoadingTag = nil
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
