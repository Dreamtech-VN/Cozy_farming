--WndKidFeedData.lua
--@brief	WndKidFeed的数据模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小孩喂食界面

WndKidFeed = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidFeed:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nNum = 1
	self.m_nMaxNum = nil 				--一次最大开启数量
	self.m_tData = nil 					--选中的食物数据
	self.m_tKidData = nil 				--进行喂食的小孩
	self.m_tFoodsList = nil 			--所有食物数据列表
	self.m_tClickCell = nil 
	self.m_nType = nil 				--1->喂食;2->换尿布
	self.m_bIsOpenList = false 			--是否展开孩子列表
	self.m_nodeKidSel = nil 
	self.m_nKidIndex = 1 				--当前展示的孩子索引
	self.m_nMaxGrowValue = 100 			--最大成长值
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidFeed:_unInit()
	self.m_root = nil
	self.m_nNum = nil 
	self.m_nMaxNum = nil 				--一次最大开启数量
	self.m_tData = nil 	
	self.m_tKidData = nil 
	self.m_tFoodsList = nil 			--所有食物数据列表
	self.m_tClickCell = nil 
	self.m_nType = nil 				--1->喂食;2->换尿布
	self.m_bIsOpenList = nil 			--是否展开孩子列表
	self.m_nodeKidSel = nil 
	self.m_nKidIndex = nil 				--当前展示的孩子索引
	self.m_nMaxGrowValue = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidFeed:createElement()
	if WndKidFeed.m_root ~= nil then
		WindowManager:removeWindow(WndKidFeed.m_root, WndKidFeed, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidFeed")
	assert(element, "WndKidFeed create element failed!")
	self:_init()
	return element
end

--@brief 	外部调用接口
function WndKidFeed:showInterface(kidData, nType)
	-- body
	local wndKid = WndKidFeed:createElement()
	self.m_tKidData = kidData
	self.m_nType = nType
	WindowManager:addWindow(wndKid, WndKidFeed, nil, nil, nil, true)
end

--@brief	食物数量变化后，刷新数量
function WndKidFeed:updatePlayerHomeItemData()
	--body
	WZLog("WndKidFeed:updatePlayerHomeItemData")
	if self.m_tClickCell then
		local number = CacheCenter:getPlayerHomeItemCountById(self.m_tData.basicInfo.id)
		self.m_tClickCell:setItemNumber(number)
		self.m_tClickCell:_setItemVisible(true)
	end
end

--@brief 	刷新成长值
function WndKidFeed:updateGrowValue(kidId, nIndex)
	-- body
	if self.m_root == nil then return end 

	if self.m_nKidIndex == nIndex then
		self:setGrowValue()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获取所有的食物列表
function WndKidFeed:getFoodList()
	-- body
	self.m_tFoodsList = {}
	for i, v in pairs(GDatatab_item) do
		if v.main_type == 32 then
			if self.m_nType == 1 and v.sub_type == 1 then
				table.insert(self.m_tFoodsList, CopyTable(v))
			elseif self.m_nType == 2 and v.sub_type == 2 then
				table.insert(self.m_tFoodsList, CopyTable(v))
			end
		end
	end
end

--@brief 	返回当前喂食的孩子
function WndKidFeed:getKidIndexById(tData)
	-- body
	for i = 1, #SceneKidHome.m_tKidData do
		if SceneKidHome.m_tKidData[i].id == tData.id then
			return i
		end
	end

	return 1
end

--@brief 	获取使用后的成长值是否超上限
function WndKidFeed:getGrowValueAfterUse()
	-- body
	local nValue = self.m_tData.basicInfo.value * self.m_nNum
	local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]

	if nValue + tCurKidData.happiness >= self.m_nMaxGrowValue then
		return false
	else
		return true
	end
end

--@brief 	获取最多还能添加的数量
function WndKidFeed:getExdAddNum()
	-- body
	local nValue = self.m_tData.basicInfo.value * self.m_nNum
	local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]

	local nLeftNum = math.ceil((self.m_nMaxGrowValue - nValue - tCurKidData.happiness)/self.m_tData.basicInfo.value)

	return nLeftNum
end
-------------------------------------私有方法模块End----------------------------------------
