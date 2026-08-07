--CellTimeFirstRechargeData.lua
--@brief	CellTimeFirstRecharge的数据模块
--@date		2015/11/09
--@author	Tianxiang_Xu
--@note		活动-限时首充

CellTimeFirstRecharge = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTimeFirstRecharge:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nActivityId = nil 	--活动Id
	self.m_nRewardId = nil 
	self.m_nStatus = nil 		--状态
	self.m_nServerTime = nil 	--服务器时间
	self.m_tRewardItems = nil 	--
	self.m_tRewardItemsParamCount = nil --
	self.m_nLeftTime = nil 		--活动剩余时间
	self.m_nloadingId = nil 
	self.startTime = nil 
	self.endTime = nil 
	self.m_nActivityType = nil 
	self.content = nil 
	self.tips = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellTimeFirstRecharge:_unInit()
	self.m_root = nil
	self.m_nActivityId = nil 	--活动Id
	self.m_nRewardId = nil 
	self.m_nStatus = nil 		--状态
	self.m_nServerTime = nil 	--服务器时间
	self.m_tRewardItems = nil 	--
	self.m_tRewardItemsParamCount = nil --
	self.m_nLeftTime = nil 		--活动剩余时间
	self.m_nloadingId = nil 
	self.startTime = nil 
	self.endTime = nil 
	self.m_nActivityType = nil 
	self.content = nil 
	self.tips = nil 
end

--@brief 	设置各种数据
function CellTimeFirstRecharge:setMessage(activityId, status, serverTime, rewardItems, rewardItemsParamCount, startTime, endTime, rewardId, content, tips, activityType)
	-- body
	self.m_nActivityId = activityId
	self.m_nStatus = status
	self.m_nServerTime = serverTime
	self.m_tRewardItems = rewardItems
	self.m_tRewardItemsParamCount = rewardItemsParamCount
	self.m_nRewardId = rewardId
	self.m_nLeftTime = endTime - serverTime
	self.startTime = startTime 
	self.endTime = endTime 
	self.m_nActivityType = activityType
	self.content = content
	self.tips = tips

	WZLog("********* CellTimeFirstRecharge:setMessage *********", self.m_nLeftTime, self.m_nStatus)
end

--@brief 	领取奖励成功回调
function CellTimeFirstRecharge:ACTIVITY_ReceiveActivityRewardOk(rewardItems, rewardCount, activityType)
	-- body
	if CellTimeFirstRecharge.m_current_click.m_root == nil then
    	WZLog("self.m_root is nil!")
        return
    end
    MsgBoxManager:removeMsgById(CellTimeFirstRecharge.m_current_click.m_nloadingId)
    WndRewardShow:showById(rewardItems,rewardCount)
    WndRewardShow:closeCallBack(CellTimeFirstRecharge.m_current_click,CellTimeFirstRecharge.m_current_click._GetRewardOk, _G, pushEquipInList)
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTimeFirstRecharge:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTimeFirstRecharge table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellTimeFirstRecharge")
	assert(element, "CellTimeFirstRecharge element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTimeFirstRecharge:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
