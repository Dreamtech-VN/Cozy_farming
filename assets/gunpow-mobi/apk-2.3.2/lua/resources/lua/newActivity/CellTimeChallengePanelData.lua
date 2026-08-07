--CellTimeChallengePanelData.lua
--@brief	CellTimeChallengePanel的数据模块
--@date		2017/08/24
--@author	Tianxiang_Xu
--@note		开服活动-限时挑战

CellTimeChallengePanel = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTimeChallengePanel:_init()
	self.m_root = nil  			--Cell的根节点
	self.startTime = nil 
	self.endTime = nil 
	self.m_nActivityId = nil 
	self.m_tRewardId = nil 
	self.m_tRewardList = nil 
	self.m_nActivityType = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTimeChallengePanel:_unInit()
	self.m_root = nil
	self.startTime = nil 
	self.endTime = nil 
	self.m_nActivityId = nil 
	self.m_tRewardId = nil 
	self.m_tRewardList = nil 
	self.m_nActivityType = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTimeChallengePanel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTimeChallengePanel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellTimeChallengePanel")
	assert(element, "CellTimeChallengePanel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置活动数据
function CellTimeChallengePanel:setMessage(activityId, startTime, endTime, rewardId, status, rewardItems, rewardItemsParamCount,target, nActivityType)
	-- body
	self.m_nActivityId = activityId
	self.startTime = startTime 
	self.endTime = endTime 
	self.m_nActivityType = nActivityType 
	
	self.m_tRewardList = {} 
	for i = 1, #rewardId do
		local tItem = {}
		tItem.id = rewardItems[i]
		tItem.num = rewardItemsParamCount[i]
		tItem.state = status[i]
		tItem.rewardId = rewardId[i]
		tItem.starNum = target[i]
		tItem.section = target[3 + i]
		tItem.content = LocalStrings.NEWACTIVITY_TEXT10[tItem.starNum]

		table.insert(self.m_tRewardList, tItem)
	end

	local function getSortValue(a)
		-- body
		if a.state == 1 then 
			return -2 
		else
			return a.state
		end
	end
	table.sort(self.m_tRewardList, function (a, b)
		-- body
		local sortValueA = getSortValue(a)
		local sortValueB = getSortValue(b)

		if sortValueA ~= sortValueB then
			return sortValueA > sortValueB
		else
			return a.rewardId < b.rewardId
		end
	end)
end

--@brief 	领取奖励成功
function CellTimeChallengePanel:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
	-- body
	MsgBoxManager:stopLoadingBoxByMsgId(CellTimeChallengePanel.m_current.m_nloadingId)
	--设置领取后的奖励项的状态
	CellTimeChallengeItem.m_current_click:setRewardState(1)
	--展示购买的物品数量
	WndRewardShow:showById(rewardItems,rewardCount)
	WndRewardShow:closeCallBack(CellTimeChallengePanel.m_current,CellTimeChallengePanel.m_current._GetRewardOk, _G, pushEquipInList)

end

--@brief 	关闭奖励窗口回调
function CellTimeChallengePanel:_GetRewardOk()
	-- body
	if CellTimeChallengeItem.m_current_click == nil or CellTimeChallengeItem.m_current_click.m_tData == nil then
		return
	end
	local rewardId = CellTimeChallengeItem.m_current_click:getRewardId()
	for i = 1, #self.m_tRewardList do 
		if self.m_tRewardList[i].rewardId == rewardId then 
			self.m_tRewardList[i].state = 1 
			break 
		end
	end

	local function getSortValue(a)
		-- body
		if a.state == 1 then 
			return -2 
		else
			return a.state
		end
	end
	table.sort(self.m_tRewardList, function (a, b)
		-- body
		local sortValueA = getSortValue(a)
		local sortValueB = getSortValue(b)
		if sortValueA ~= sortValueB then
			return sortValueA > sortValueB
		else
			return a.rewardId < b.rewardId
		end
	end)

	self:_showRewardList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTimeChallengePanel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellTimeChallengePanel.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
