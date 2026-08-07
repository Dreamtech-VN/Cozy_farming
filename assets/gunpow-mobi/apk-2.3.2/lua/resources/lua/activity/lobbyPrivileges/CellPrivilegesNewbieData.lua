--CellPrivilegesNewbieData.lua
--@brief	CellPrivilegesNewbie的数据模块
--@date		2022/03/22
--@author	yrd
--@note		大厅特权-新手礼包

CellPrivilegesNewbie = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPrivilegesNewbie:_init()
	self.m_root = nil  			--Cell的根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPrivilegesNewbie:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPrivilegesNewbie:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPrivilegesNewbie table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellPrivilegesNewbie")
	assert(element, "CellPrivilegesNewbie element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	初始化数据信息
function CellPrivilegesNewbie:setMessage(activityType, activityId, content, tips, startTime, endTime, serverTime, rewardId, status, rewardItems, rewardItemsParamCount, rewardCounts, count ,maxCount, finishCondition)
	self.activityType = activityType
	self.activityId = activityId 
	self.content = json.decode(content)
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
	self.finishCondition = finishCondition

	local tRewardItems = {}
    local rewardItems = json.decode(self.content.rewardItems)
    rewardItems = SplitStringWithSeparator(rewardItems[1],"&")
    for i = 1, #rewardItems do
        local rewardItem = string.sub(rewardItems[i],2,-2)
        local tItem = SplitStringWithSeparator(rewardItem,",")
        table.insert(tRewardItems,tItem)
    end
    self.content.rewardItems = tRewardItems

	WZLog("CellPrivilegesNewbie:setMessage",Serialize(self.content),Serialize(self.content.rewardItems))
end

--@brief 	收到领取返回协议
function CellPrivilegesNewbie:getActivityDoOk(activityId, activityType, doType, result, strjson)
	if result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.VIP_RECVSUCCESS)
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.NEWFIRSTCHARGE_TEXT5)
	elseif result == 3 then
		MsgBoxManager:showTipBox(LocalStrings.NEWVIP_TEXT26)
	end

	if not self.m_root then
		return
	end

	--刷新数据和界面
	local content = json.decode(strjson)
    self.content.rewardItems = content.rewards
    if result == 1 then
    	self.content.giftState = 1

		if content.rewards then
			local tItemIds = {}
			local tItemCount = {}
			for i=1,#content.rewards do
				local itemId = content.rewards[i][1]
		        if CacheCenter:getPlayerInfo().sex == 1 then
		            itemId = content.rewards[i][2]
		        end
		        local itemCount = content.rewards[i][3]

		        table.insert(tItemIds,itemId)
		        table.insert(tItemCount,itemCount)
		    end
			WndRewardShow:showById(tItemIds,tItemCount)	
		end
	end

    self:updateRewardList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPrivilegesNewbie:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
