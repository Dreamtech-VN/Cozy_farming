--CellReturnActivity3Data.lua
--@brief	CellReturnActivity3的数据模块
--@date		2021/05/19
--@author	hyx
--@note		回归活动6元特惠

CellReturnActivity3 = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellReturnActivity3:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nChargeId = nil
	self.m_sCellItem1 = nil
	self.m_sCellItem2 = nil
	self.m_sCellItem3 = nil
	self.m_nCurDay = nil
	self.m_tReturnChargeData = {}
	self.m_bIsGetStatus = false
	self.m_sCellItem = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellReturnActivity3:_unInit()
	self.m_root = nil
	self.m_nChargeId = nil
	self.m_sCellItem1 = nil
	self.m_sCellItem2 = nil
	self.m_sCellItem3 = nil
	self.m_nCurDay = nil
	self.m_tReturnChargeData = {}
	self.m_bIsGetStatus = false
	self.m_sCellItem = {}
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellReturnActivity3:createElement()
	if CellReturnActivity3.m_root ~= nil then
		WindowManager:removeWindow(CellReturnActivity3.m_root, CellReturnActivity3, true)
	end

	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellReturnActivity3")
	assert(element, "CellReturnActivity3 create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end
function CellReturnActivity3:setActivityIdORType(activityId, _type)
	self.m_nActivityId = activityId
	self.m_nActivityType = _type
end

function CellReturnActivity3:setRewardData(rewardId,status,rewardItems,rewardItemsParamCount,rewardCounts)
	if next(rewardId) ~= nil then
		local index = 1
		for i=1,#rewardId do
			local tab = {}
			tab.id = rewardId[i]
			tab.status = status[i]
			local reward_id = {}
			local reward_num = {}
			for m=1,rewardCounts[i] do
				table.insert(reward_id,rewardItems[index])
				table.insert(reward_num,rewardItemsParamCount[index])
				index = index + 1
			end
			tab.reward_id = reward_id
			tab.reward_num = reward_num
			self.m_tReturnChargeData[i] = tab
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellReturnActivity3:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
