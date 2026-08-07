--SceneCommunityShopData.lua
--@brief	SceneCommunityShop的数据模块
--@date		2015/04/24
--@author	zsq
--@note		公会商店

SceneCommunityShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunityShop:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tShopList = nil
	self.m_nStoreID = nil
	self.m_nID = nil
	self.m_nNum = nil
	self.m_nCost = nil
	self.refreshCount = nil
	self.nextRefreshTime = nil
	self.m_nCostId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunityShop:_unInit()
	self.m_root = nil
	self.m_tShopList = nil
	self.m_nStoreID = nil
	self.m_nID = nil
	self.m_nNum = nil
	self.m_nCost = nil
	self.refreshCount = nil
	self.nextRefreshTime = nil
	self.m_nCostId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunityShop:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunityShop")
	assert(element, "SceneCommunityShop create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获得公会商品列表
function SceneCommunityShop:setShopList(storeId, store, cost, status, guildLevel, refreshCount, nextRefreshTime)
	WZLog("SceneCommunityShop:setShopList",refreshCount)
	self.m_tShopList = {}
	for i=1,#storeId do
		local temp
		local tempTable = {}
		tempTable.storeId = storeId[i]
		tempTable.store = store[i]
		tempTable.cost = cost[i]
		tempTable.status = status[i]
		tempTable.guildLevel = guildLevel[i]

        temp = SplitTeachTalkStringWithSeparator(store[i])
        temp = SplitStringWithSeparator(temp[1],",")
        tempTable.propId = tonumber(temp[1])
        tempTable.propNum = tonumber(temp[2])
        temp = SplitTeachTalkStringWithSeparator(cost[i])
        temp = SplitStringWithSeparator(temp[1],",")
        tempTable.costId = tonumber(temp[1])
        tempTable.costNum = tonumber(temp[2])
        tempTable.status = status[i]
        --物品基础数据
        local key = "id_"..tempTable.propId
        tempTable.basicInfo = GDatatab_item[key]

		table.insert(self.m_tShopList,tempTable)
	end

	self.refreshCount = refreshCount
	self.nextRefreshTime = nextRefreshTime

	self:_update()
end




-------------------------------------私有方法模块End----------------------------------------
