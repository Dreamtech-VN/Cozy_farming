--WndTreasureData.lua
--@brief	WndTreasure的数据模块
--@date		2020/10/31
--@author	hyx
--@note		寻宝主界面

WndTreasure = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTreasure:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sTreasureInitData = nil
	self.treasureCellContainer = nil
	self.m_tMapCellData = {} --格子的数据
	self.m_nMapCellNum = 0 --格子数量
	self.m_nTreasureCost = 0 --寻宝价格
	self.m_nTreasureGetGold = 0 --寻宝一次的金币
	self.m_nCurTaskBoxPoint = 0
	self.m_tScoreBoxMessage = {}
	self.m_tScoreBoxMessageData = {}
	self.m_bBosInitPos = nil
	self.m_nJoinRewardStatus = nil --参与奖励
	self.m_tItemIdBigReward = {} --大奖的奖励id与数量
	self.m_tItemNumBigReward = {}
	self.m_nFinishMapRewardNum = 0
	self.m_tPointTaskRewardStatus = {} --宝箱的状态
	self.m_nTreasureScheduleId = nil
	self.m_tJoinRewardData = {} --参与奖励
	self.m_tAllServerRewardData = {} --全服奖励
	self.m_nAllServerRewardCount = 0 --抽奖几次可以领取全服奖励
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTreasure:_unInit()
	self.m_root = nil
	self.m_sTreasureInitData = nil
	self.treasureCellContainer = nil
	self.m_tMapCellData = {}
	self.m_nMapCellNum = 0
	self.m_nTreasureCost = 0
	self.m_nCurTaskBoxPoint = 0
	self.m_nTreasureGetGold = 0
	self.m_tScoreBoxMessage = {}
	self.m_tScoreBoxMessageData = {}
	self.m_bBosInitPos = nil
	self.m_nJoinRewardStatus = nil
	self.m_tItemIdBigReward = {}
	self.m_tItemNumBigReward = {}
	self.m_nFinishMapRewardNum = 0
	self.m_tPointTaskRewardStatus = {}
	self.m_nTreasureScheduleId = nil
	self.m_tJoinRewardData = {}
	self.m_tAllServerRewardData = {}
	self.m_nAllServerRewardCount = 0
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTreasure:createElement()
	if WndTreasure.m_root ~= nil then
		WindowManager:removeWindow(WndTreasure.m_root, WndTreasure, true)
	end
	local element = WZUISystem:getInstance():createElement("WndTreasure")
	assert(element, "WndTreasure create element failed!")
	self:_init()
	return element
end

function WndTreasure:initSystemData()
	local treasureActivityConfig = CacheCenter:getGameParam().treasureActivityConfig
	if treasureActivityConfig then
	 	self.m_sTreasureInitData = json.decode(treasureActivityConfig)
	 	if self.m_sTreasureInitData then
	 		self.m_nMapCellNum = self.m_sTreasureInitData.cellNum or 80
	 		self.m_nTreasureCost = self.m_sTreasureInitData.cost or 1
	 		self.m_nTreasureGetGold = self.m_sTreasureInitData.gold or 1
	 		
	 		local join_data = self.m_sTreasureInitData.joinReward or {}
	 		self.m_tJoinRewardData = self:setResolveRewardData(join_data)

	 		self.m_nAllServerRewardCount = self.m_sTreasureInitData.finishedRewardTarget
	 		local server_data = self.m_sTreasureInitData.finishedMapReward or {}
	 		self.m_tAllServerRewardData = self:setResolveRewardData(server_data) 		

	 		local data = self.m_sTreasureInitData.taskReward or {}
	 		self:setBoxData(data)
	 	end
	 end
end
--解析宝箱的数据
function WndTreasure:setBoxData(data)
	local sex = CacheCenter:getPlayerInfo().sex
	local table_insert = table.insert
	if data then
		for i=1,#data do
			local tab = {}
			tab.icon = {}
			tab.num = {}
			tab.index = i
			tab.count = data[i]["num"]
			local array = SplitStringWithSeparator(data[i].reward,"&")
			for k=1, #array do
				local _string = string.sub(array[k],2,-2)
				if sex == 0 then --男
					local id = SplitStringWithSeparator(_string,",")[1]
					table.insert(tab.icon, GDatatab_item["id_" .. id].id)
				else
					local id = SplitStringWithSeparator(_string,",")[2]
					table.insert(tab.icon, GDatatab_item["id_" .. id].id)
				end
				local count = SplitStringWithSeparator(_string,",")[3]
				table.insert(tab.num, count)

				self.m_tScoreBoxMessageData[i] = tab
			end
		end
		table.sort( self.m_tScoreBoxMessageData, function(a,b) return a.index < b.index end)
	end
end
--奖励的解析
function WndTreasure:setResolveRewardData(data)
	if data == nil then return {} end

	local rewardList = {}
    rewardList.icon = {}   
    rewardList.num = {}

	local sex = CacheCenter:getPlayerInfo().sex
	local array = SplitStringWithSeparator(data,"&")
	local ids = {}
	local nums = {}
	for i=1,#array do
		local _string = string.sub(array[i],2,-2) 
		local id = 1
		if sex == 0 then
			id = SplitStringWithSeparator(_string,",")[1]
		else
			id = SplitStringWithSeparator(_string,",")[2]
		end
		local num = SplitStringWithSeparator(_string,",")[3]
		table.insert(rewardList.icon, GDatatab_item["id_" .. id].icon)
        table.insert(rewardList.num, num)
	end
	return rewardList
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
TreasureCellItem = {}
function TreasureCellItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function TreasureCellItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function TreasureCellItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellGoodItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("treasure_item")
	assert(element, "CellGoodItem element create failed!")
	element:setVisible(true)
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end
function TreasureCellItem:setCellNormal()
	GetElement(self.m_root,"normal_img",WZUIImage):setVisible(true)
	GetElement(self.m_root,"select_img",WZUIContainer):setVisible(false)
end
function TreasureCellItem:setCellSelect(id, num)
	GetElement(self.m_root,"normal_img",WZUIImage):setVisible(false)
	GetElement(self.m_root,"select_img",WZUIContainer):setVisible(true)

	local tabItem = GDatatab_item["id_"..id]
	if tabItem then
		GetElement(self.m_root,"good_img",WZUIImage):setFile(tabItem.icon)
		if tabItem.main_type == 8 and tabItem.sub_type == 0 then 
			GetElement(self.m_root,"good_img",WZUIImage):setScale(0.4)
		end
		GetElement(self.m_root,"good_num",WZUILabelTTF):setText(math.abs(num))
	end
end
--@return	新建的表实例对象
function TreasureCellItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
