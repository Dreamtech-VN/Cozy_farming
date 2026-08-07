--CellMondayPlanCardData.lua
--@brief	CellMondayPlanCard的数据模块
--@date		2020/07/07
--@author	yrd
--@note		周一计划卡

CellMondayPlanCard = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellMondayPlanCard:_init()
	self.m_root = nil	 	  			--场景根节点
	self.progress = nil
	self.num = nil
	self.endTime = nil
	self.rewardStatus = nil
	self.itemId = nil
	self.itemNum = nil
	self.activityId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellMondayPlanCard:_unInit()
	self.m_root = nil
	self.progress = nil
	self.num = nil
	self.endTime = nil
	self.rewardStatus = nil
	self.itemId = nil
	self.itemNum = nil
	self.activityId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellMondayPlanCard:createElement()
	if CellMondayPlanCard.m_root ~= nil then
		WindowManager:removeWindow(CellMondayPlanCard.m_root, CellMondayPlanCard, true)
	end
	local element = WZUISystem:getInstance():createElement("CellMondayPlanCard")
	assert(element, "CellMondayPlanCard create element failed!")
	self:_init()
	return element
end


function CellMondayPlanCard:setMessage(progress, num, endTime, rewardStatus, itemId, itemNum, activityId)
	self.progress = progress
	self.num = num
	self.endTime = endTime
	self.rewardStatus = rewardStatus
	self.itemId = itemId
	self.itemNum = itemNum
	self.activityId = activityId
end

function CellMondayPlanCard:getRewardOk(rewardItems,rewardCount,type)
	if rewardItems ~= nil and #rewardItems > 0 and  rewardItems[1] > 0 then
        WndRewardShow:showById(rewardItems,rewardCount)
        self:sendMondayCardProtocol()
    end
end

function CellMondayPlanCard:sendMondayCardProtocol()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetWelfareCardActivityInfo(g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD)
	WndFreeca:refreshActivityContext(g_tGameActivityTypes.ACTIVITY_MONDAY_PLAN_CARD)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
