--CellOnLineRewardData.lua
--@brief	CellOnLineReward的数据模块
--@date		2016/07/20
--@author	maopeiting
--@note		在线奖励

CellOnLineReward = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellOnLineReward:_init()
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
	self.m_tRewardData = nil 	--奖励数据
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellOnLineReward:_unInit()
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
	self.m_tRewardData = nil 	--奖励数据
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellOnLineReward:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellOnLineReward table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellOnLineReward")
	assert(element, "CellOnLineReward element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

function CellOnLineReward:setData( online,reward, config)
	self.OnlineTime = online
	self.rewardId = reward
	WZLog("CellOnLineReward:setData", online, Serialize(reward), Serialize(config))
	self.m_tRewardData = {}
	for i = 1, #config do
		local tItem = {}
		local tConfig = json.decode(config[i])
		WZLog("CellOnLineReward:setData", Serialize(tConfig))
		tItem.id = tConfig.id
		tItem.time = tConfig.time
		local id, num = SplitItemString(tConfig.reward)
		local reward1 = {}
		for j = 1, #id do
			local tempItem = {}
			tempItem[1] = tonumber(id[j])
			tempItem[2] = tonumber(num[j])

			table.insert(reward1, tempItem)
		end
		tItem.reward = reward1
		id, num = SplitItemString(tConfig.reward2)
		local reward2 = {}
		for j = 1, #id do
			local tempItem = {}
			tempItem[1] = tonumber(id[j])
			tempItem[2] = tonumber(num[j])

			table.insert(reward2, tempItem)
		end
		tItem.reward2 = reward2
		if tConfig.time < 3600 then
			tItem.text = math.ceil(tConfig.time/60) .. LocalStrings.MINUTE1 .. LocalStrings.ATH_REWARD_CHECK
		else
			tItem.text = math.ceil(tConfig.time/3600) .. LocalStrings.HOUR1 .. LocalStrings.ATH_REWARD_CHECK
		end

		table.insert(self.m_tRewardData, tItem)
	end
	table.sort(self.m_tRewardData, function (a,b)
		-- body
		return a.id < b.id
	end)
	self.length = #config
	self:_sortRewardList()
	self:_setRewardsList()
end

--把秒 转化成XX时XX分XX秒
function CellOnLineReward:formatTime(time)
	local hour = math.floor(time/3600)
	local minute = math.fmod(math.floor(time/60),60)
	local second = math.fmod(time,60)
	if hour >= 24 then
		local day = math.floor(hour/24)
		hour = hour - 24*day
		local rtTime = string.format("%s"..LocalStrings.DAY.."%d"..LocalStrings.HOUR,day,hour)
		self.state = 1
		--WZLog("CellOnLineReward:formatTime1",rtTime)
		return rtTime
	elseif hour < 24 and hour >= 1 then 
		local rtTime = string.format("%s"..LocalStrings.HOUR.."%s"..LocalStrings.MINUTE,hour,minute)
		self.state = 1
		--WZLog("CellOnLineReward:formatTime2",rtTime)
		return rtTime
	elseif minute < 60 and minute >= 1 then
		local rtTime = string.format("%s"..LocalStrings.MINUTE.."%s"..LocalStrings.SECOND,minute,second)
		self.state = 1
		--WZLog("CellOnLineReward:formatTime3",rtTime)
		return rtTime
	elseif second < 60 and second >=1 then
		local rtTime = string.format("%s"..LocalStrings.SECOND,second)
		self.state = 0
		--WZLog("CellOnLineReward:formatTime4",rtTime)
		return rtTime
	end
end

--@brief	领取奖励
function CellOnLineReward:getRewardOk(itemId,num,online,reward)
	if self.m_root == nil then
        return
    end
    self.OnlineTime = online
    self.rewardId = reward
    WndRewardShow:showById(itemId,num)
    WndRewardShow:closeCallBack(self,self._GetRewardOk, _G, pushEquipInList)
end

--@brief	计算在线奖励表长度
function CellOnLineReward:_getLength(  )
	for k,v in pairs(GDatatab_online_reward) do
		self.length = self.length + 1
	end
end

--@brief	将已领取的物品放到末尾
function CellOnLineReward:_sortRewardList(  )
 	self.reward1 = {}
 	self.reward = {}
	for k,v in pairs(self.m_tRewardData) do
		local count = 0
		if #self.rewardId > 0 then
			for i=1,#self.rewardId do
				if v.id == self.rewardId[i] then
					table.insert(self.reward1,v)
				else
					count = count + 1
				end
				if count == #self.rewardId then
					table.insert(self.reward,v)
				end
			end
		else
			table.insert(self.reward,v)
		end
	end

	local function sort( v1,v2 )
		return tonumber(v1.id) < tonumber(v2.id)
	end
	table.sort(self.reward,sort)
	table.sort(self.reward1,sort)
	
	if #self.reward1 > 0 then
		for i=1,#self.reward1 do
			table.insert(self.reward,self.reward1[i])
		end
	end
	WZLog("---_sortRewardList--1111",Serialize(self.reward1),Serialize(self.reward))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellOnLineReward:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellOnLineReward.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
