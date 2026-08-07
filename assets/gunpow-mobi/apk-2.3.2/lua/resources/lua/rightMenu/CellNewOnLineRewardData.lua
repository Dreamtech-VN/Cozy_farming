--CellOnLineRewardData.lua
--@brief	CellOnLineReward的数据模块
--@date		2016/07/20
--@author	maopeiting
--@note		在线奖励

CellNewOnLineReward = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellNewOnLineReward:_init()
	self.m_root = nil  			--Cell的根节点
	self.OnlineTime = nil		--在线时间
	self.leaveTime = nil	--剩余时间
	self.num = nil		--领取的物品数量
	self.itemId = {}	--领取的物品Id
	self.rewardId = {}	--已领取的奖励Id
	self.time = nil 		--领取奖励的时间
	self.state = nil	--时间为天：1，反之为0
	self.rewardList = {} 	--奖励列表
	self.length = 0  	--计算在线奖励表长度
	self.id = 0 		--记录领取的奖励ID个数
	self.reward = {}	--存放未领取的奖励和已领取的奖励数据
	self.reward1 = {}	--存放已领取的奖励数据
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellNewOnLineReward:_unInit()
	self.m_root = nil
	self.leaveTime = nil
	self.num = nil
	self.itemId = {}
	self.rewardId = nil
	self.time = nil
	self.state = nil
	self.rewardList = nil
	self.length = nil
	self.id = nil
	self.reward = nil 
	self.reward1 = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellNewOnLineReward:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellNewOnLineReward table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellNewOnLineReward")
	assert(element, "CellNewOnLineReward element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellNewOnLineReward:showWindow()

end
									
function CellNewOnLineReward:setMessage(activityId,startTime,endTime, rewardId, rewardItems, rewardItemsParamCount, rewardCounts, count, target, status)
	WZLog("CellNewOnLineReward:setMessage在线:"..count.."分钟",Serialize(rewardItems))
	self.OnlineTime = count * 60
	self.rewardId = {}
 	self.reward = {}
	self.length = #target

	local totalIndex = 1
	for i=1,#target do
		local temp = {}
		temp.text = target[i]..LocalStrings.MINUTE1..LocalStrings.ATH_REWARD_CHECK
		temp.time = target[i] * 60
		temp.id = rewardId[i]
		if status[i] == 1 then
			table.insert(self.rewardId, rewardId[i])
		end
		temp.activityId = activityId
		temp.reward = {}
		for j=1,rewardCounts[i] do
			temp.reward[j] = {}
			temp.reward[j][1] = rewardItems[totalIndex]
			temp.reward[j][2] = rewardItemsParamCount[totalIndex]
			totalIndex = totalIndex + 1
		end
		temp.reward2 = temp.reward
		if status[i] == 1 or status[i] == 2 then
			temp.sortIndex = 0
		else
			temp.sortIndex = 1
		end
		self.reward[i] = temp
	end

	local _sort = function(a,b)
		if a.sortIndex ~= b.sortIndex then
			return a.sortIndex > b.sortIndex
		else
			return a.id < b.id
		end
	end

	table.sort(self.reward, _sort)

	self:_setRewardsList()
end

function CellNewOnLineReward:ACTIVITY_ReceiveRewardOk(rewardItems,rewardCount)
	WZLog("CellNewOnLineReward:ACTIVITY_ReceiveRewardOk", Serialize(rewardItems))
	--if self.m_root == nil then return end

    WndRewardShow:showById(rewardItems,rewardCount)
    WndRewardShow:closeCallBack(self,self._GetRewardOk, _G, pushEquipInList)
end

--@brief    奖励获取成功回调  
function CellNewOnLineReward:_GetRewardOk()
	WndGameActivity:refreshActivityContext()
end

--把秒 转化成XX时XX分XX秒
function CellNewOnLineReward:formatTime(time)
	local hour = math.floor(time/3600)
	local minute = math.fmod(math.floor(time/60),60)
	local second = math.fmod(time,60)
	if hour >= 24 then
		local day = math.floor(hour/24)
		hour = hour - 24*day
		local rtTime = string.format("%s"..LocalStrings.DAY.."%d"..LocalStrings.HOUR,day,hour)
		self.state = 1
		--WZLog("CellNewOnLineReward:formatTime1",rtTime)
		return rtTime
	elseif hour < 24 and hour >= 1 then 
		local rtTime = string.format("%s"..LocalStrings.HOUR.."%s"..LocalStrings.MINUTE,hour,minute)
		self.state = 1
		--WZLog("CellNewOnLineReward:formatTime2",rtTime)
		return rtTime
	elseif minute < 60 and minute >= 1 then
		local rtTime = string.format("%s"..LocalStrings.MINUTE.."%s"..LocalStrings.SECOND,minute,second)
		self.state = 1
		--WZLog("CellNewOnLineReward:formatTime3",rtTime)
		return rtTime
	elseif second < 60 and second >=1 then
		local rtTime = string.format("%s"..LocalStrings.SECOND,second)
		self.state = 0
		--WZLog("CellNewOnLineReward:formatTime4",rtTime)
		return rtTime
	end
end

--@brief 	根据id获取奖励在线时间
function CellNewOnLineReward:getDataById(id)
	-- body
	for i = 1, #self.reward do
		if self.reward[i].id == id then
			return self.reward[i].time
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellNewOnLineReward:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellNewOnLineReward.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
