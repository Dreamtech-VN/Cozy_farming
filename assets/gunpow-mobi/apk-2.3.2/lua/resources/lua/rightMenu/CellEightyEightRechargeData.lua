--CellEightyEightRechargeData.lua
--@brief	CellEightyEightRecharge的数据模块
--@date		2015/11/09
--@author	Tianxiang_Xu
--@note		活动-限时首充

CellEightyEightRecharge = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellEightyEightRecharge:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nloadingId = nil

	self.activityId = nil
	self.content = nil
	self.tips = nil
	self.startTime = nil
	self.endTime = nil
	self.serverTime = nil
	self.rewardId = nil
	self.status = nil
	self.rewardItems = nil
	self.rewardItemsParamCount = nil
	self.rewardCounts = nil
	self.count = nil
	self.maxCount = nil
	self.target = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellEightyEightRecharge:_unInit()
	self.m_root = nil
	self.m_nloadingId = nil

	self.activityId = nil
	self.content = nil
	self.tips = nil
	self.startTime = nil
	self.endTime = nil
	self.serverTime = nil
	self.rewardId = nil
	self.status = nil
	self.rewardItems = nil
	self.rewardItemsParamCount = nil
	self.rewardCounts = nil
	self.count = nil
	self.maxCount = nil
	self.target = nil
end

--@brief 	设置各种数据
function CellEightyEightRecharge:setMessage(activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count, maxCount, target)
	self.activityId = activityId
	self.content = content
	self.tips = tips
	self.startTime = startTime
	self.endTime = endTime
	self.serverTime = serverTime
	self.rewardId = rewardId
	self.status = status
	self.rewardItems = rewardItems
	self.rewardItemsParamCount = rewardItemsParamCount
	self.rewardCounts = rewardCounts
	self.count = count
	self.maxCount = maxCount
	self.target = target
end

--@brief 	领取奖励成功回调
function CellEightyEightRecharge:ACTIVITY_ReceiveActivityRewardOk(rewardItems, rewardCount, activityType)
	-- body
	if CellEightyEightRecharge.m_current_click.m_root == nil then
    	WZLog("self.m_root is nil!")
        return
    end
    MsgBoxManager:removeMsgById(CellEightyEightRecharge.m_current_click.m_nloadingId)
    WndRewardShow:showById(rewardItems,rewardCount)
    WndRewardShow:closeCallBack(CellEightyEightRecharge.m_current_click,CellEightyEightRecharge.m_current_click._GetRewardOk, _G, pushEquipInList)
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellEightyEightRecharge:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellEightyEightRecharge table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellEightyEightRecharge")
	assert(element, "CellEightyEightRecharge element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellEightyEightRecharge:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
