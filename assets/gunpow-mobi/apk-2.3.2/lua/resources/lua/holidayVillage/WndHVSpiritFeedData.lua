--WndHVSpiritFeedData.lua
--@brief	WndHVSpiritFeed的数据模块
--@date		2023/01/04
--@author	yrd
--@note		度假村-精灵喂养

WndHVSpiritFeed = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVSpiritFeed:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nNum = 1
	self.m_nMaxGrowValue = 100 			--最大成长值
	self.m_tCallBack = nil				--回调方法
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVSpiritFeed:_unInit()
	self.m_root = nil
	self.m_nNum = nil
	self.m_nMaxGrowValue = nil
	self.m_tCallBack = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVSpiritFeed:createElement()
	if WndHVSpiritFeed.m_root ~= nil then
		WindowManager:removeWindow(WndHVSpiritFeed.m_root, WndHVSpiritFeed, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVSpiritFeed")
	assert(element, "WndHVSpiritFeed create element failed!")
	self:_init()
	return element
end

--@brief 	外部调用接口
function WndHVSpiritFeed:showInterface(tData,tLuaObj,tLuaFunc)
	local wnd = WndHVSpiritFeed:createElement()
	self.m_tTargetData = tData
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..tData.spiritId]
	self.m_nMaxGrowValue = tSpiritInfo.satiety
	if tLuaObj and tLuaFunc then
		self.m_tCallBack = {}
		self.m_tCallBack[1] = tLuaObj
		self.m_tCallBack[2] = tLuaFunc
	end
	WindowManager:addWindow(wnd, WndHVSpiritFeed, nil, nil, nil, true)
end

--@brief	获取所有的食物列表
function WndHVSpiritFeed:getFoodList()
	self.m_tFoodsList = {}
	for i, v in pairs(GDatatab_item) do
		if v.main_type == 45 and v.sub_type == 6 then
			table.insert(self.m_tFoodsList, CopyTable(v))
		end
	end
	table.sort(self.m_tFoodsList, function(a,b)
		return a.value < b.value
	end)
end

--@brief	食物数量变化后，刷新数量
function WndHVSpiritFeed:updatePlayerItemData()
	WZLog("WndHVSpiritFeed:updatePlayerItemData")
	if self.m_tClickCell then
		local number = WndHVSpirit:getItemCountByItemId(self.m_tData.basicInfo.id)
		self.m_tClickCell:setItemNumber(number)
		self.m_tClickCell:_setItemVisible(true)
	end
end

--@brief 	获取使用后的成长值是否超上限
function WndHVSpiritFeed:getGrowValueAfterUse()
	local nValue = self.m_tData.basicInfo.value * self.m_nNum
	local tSpiritInfo = GDatatab_holiday_spirit["id_"..self.m_tTargetData.spiritId]
	if nValue + self.m_tTargetData.satiety >= self.m_nMaxGrowValue then
		return false
	else
		return true
	end
end

--@brief 	获取最多还能添加的数量
function WndHVSpiritFeed:getExdAddNum()
	-- body
	local nValue = self.m_tData.basicInfo.value * self.m_nNum
	local nLeftNum = math.ceil((self.m_nMaxGrowValue - nValue - self.m_tTargetData.satiety)/self.m_tData.basicInfo.value)

	return nLeftNum
end


--@brief 	获取最多能添加的数量
function WndHVSpiritFeed:getCanUseMaxNum()
	local nCanUseMaxNum = 0
	if self.m_nMaxGrowValue > self.m_tTargetData.satiety then
		nCanUseMaxNum = math.ceil((self.m_nMaxGrowValue - self.m_tTargetData.satiety)/self.m_tData.basicInfo.value)
	end

	local nMyCount = WndHVSpirit:getItemCountByItemId(self.m_tData.basicInfo.id)
	nCanUseMaxNum = math.min(nCanUseMaxNum, nMyCount)

	return nCanUseMaxNum
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
