--WndSellListData.lua
--@brief	WndSellList的数据模块
--@date		2015/07/03
--@author	zsq
--@note		出售物品列表

WndSellList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSellList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLeft = nil
    self.m_vItemID = nil
    self.m_vItemNum = nil
    self.m_nLoadingID = nil
	self.m_tGetList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSellList:_unInit()
	self.m_root = nil
	self.m_tLeft = nil
    self.m_vItemID = nil
    self.m_vItemNum = nil
    self.m_nLoadingID = nil
	self.m_tGetList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSellList:createElement()
	local element = WZUISystem:getInstance():createElement("WndSellList")
	assert(element, "WndSellList create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获得出售列表内同类型装备个数
function WndSellList:getInSaleNum(itemId) 
	if self.m_tLeft == nil then return 0 end
	local num = 0
	local tData = GDatatab_item["id_"..itemId]
	--武器
	if tData.main_type == 4 and (tData.sub_type == 0 or tData.sub_type == 1) then
		for i=1,#self.m_tLeft do
			local tItem = self.m_tLeft[i].basicInfo
			if tItem.main_type == 4 and (tItem.sub_type == 0 or tItem.sub_type == 1) then 
				num = num + 1
			end
		end
		return num
	else
		for i=1,#self.m_tLeft do
			local tItem = self.m_tLeft[i].basicInfo
			if tItem.main_type == 4 and tItem.sub_type == tData.sub_type then 
				num = num + 1
			end
		end
		return num
	end
end

--@brief	获得拥有的同类型装备个数
function WndSellList:getOwnNum(itemId) 
	local tDataList = CacheCenter:getPlayerItems()
	local num = 0
	local tData = GDatatab_item["id_"..itemId]
	--武器
	if tData.main_type == 4 and (tData.sub_type == 0 or tData.sub_type == 1) then
		for i=1,#tDataList do
			local tItem = tDataList[i].basicInfo
			if tItem.main_type == 4 and (tItem.sub_type == 0 or tItem.sub_type == 1) then 
				num = num + 1
			end
		end
		return num
	else
		for i=1,#tDataList do
			local tItem = tDataList[i].basicInfo
			if tItem.main_type == 4 and tItem.sub_type == tData.sub_type then 
				num = num + 1
			end
		end
		return num
	end
end

--@brief	获得拥有的同类型体验装备个数
function WndSellList:getOwnLimitNum(itemId) 
	local tDataList = CacheCenter:getPlayerItems()
	local num = 0
	local tData = GDatatab_item["id_"..itemId]
	--武器
	if tData.main_type == 4 and (tData.sub_type == 0 or tData.sub_type == 1) then
		for i=1,#tDataList do
			local tItem = tDataList[i].basicInfo
			if tItem.main_type == 4 and (tItem.sub_type == 0 or tItem.sub_type == 1) and tItem.time_limit ~= -1 then 
				num = num + 1
			end
		end
		return num
	else
		for i=1,#tDataList do
			local tItem = tDataList[i].basicInfo
			if tItem.main_type == 4 and tItem.sub_type == tData.sub_type and tItem.time_limit ~= -1 then 
				num = num + 1
			end
		end
		return num
	end
end
-------------------------------------私有方法模块End----------------------------------------
