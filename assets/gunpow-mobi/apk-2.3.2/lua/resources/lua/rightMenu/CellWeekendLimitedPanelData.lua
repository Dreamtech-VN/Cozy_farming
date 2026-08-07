--CellWeekendLimitedPanelData.lua
--@brief	CellWeekendLimitedPanel的数据模块
--@date		2020/10/13
--@author	yrd
--@note		周末限定活动

CellWeekendLimitedPanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellWeekendLimitedPanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tTaskItemCell = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellWeekendLimitedPanel:_unInit()
	self.m_root = nil
	self.m_tTaskItemCell = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellWeekendLimitedPanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellWeekendLimitedPanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellWeekendLimitedPanel")
	assert(element, "CellWeekendLimitedPanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellWeekendLimitedPanel:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
	WZLog("CellWeekendLimitedPanel:ACTIVITY_ReceiveRewardOk", Serialize(rewardItems))
	--if self.m_root == nil then return end

    WndRewardShow:showById(rewardItems,rewardCount)
    WndRewardShow:closeCallBack(self,self._GetRewardOk, _G, pushEquipInList)
end

--@brief    奖励获取成功回调  
function CellWeekendLimitedPanel:_GetRewardOk()
	WndGameActivity:refreshActivityContext()
end

--@brief 	获取射箭任务列表
function CellWeekendLimitedPanel:_onGetTaskInfo(activityId, activityType, taskType, id, status, target, progress, progressCount, refreshTime, taskGroup)
	if activityId == self.activityId then 
		local tab = CellNewYearTask:setTaskData(id, status, target, progress, activityId)
		WZLog("CellWeekendLimitedPanel:_onGetTaskInfo", taskType, taskGroup, Serialize(tab))
		self.reward = tab
		taskTableSort(self.reward)

		self:showWindow()
	end
end

--@brief 	射箭任务奖励
function CellWeekendLimitedPanel:_onGetTaskResult(activityId, id)
--	WZLog("CellWeekendLimitedPanel:_onGetTaskResult", self.m_nActivityId, activityId, id)
	if self.activityId ~= activityId then
		MsgBoxManager:showTipBox(LocalStrings.RETURNEE_TEXT28)
		return
	end
	
	local taskData = GDatatab_new_activity_task["id_" .. id]
	self:setTeskGetResult(id)
end

function CellWeekendLimitedPanel:setTeskGetResult(id)
	if self.m_tTaskItemCell then
		for i,v in pairs(self.reward) do
			if v and v.id == id then
				self.reward[i].status = 2	
				break
			end
		end
		taskTableSort(self.reward)
		for i,v in ipairs(self.m_tTaskItemCell) do
			if v then
				v:setTaskItemMessage(self.reward[i])
			end
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellWeekendLimitedPanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellWeekendLimitedPanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
