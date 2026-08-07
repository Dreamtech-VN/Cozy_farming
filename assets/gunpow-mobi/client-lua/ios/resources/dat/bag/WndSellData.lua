--WndSellData.lua
--@brief	WndSell的数据模块
--@date		2015/07/03
--@author	zsq
--@note		出售背包

WndSell = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSell:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nIndex = nil
	self.m_tData = nil
	self.m_tSellList = {}		--出售物品列表
	self.m_tGridList = nil
	self.m_nTag = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSell:_unInit()
	self.m_root = nil
	self.m_nIndex = nil
	self.m_tData = nil
	self.m_tSellList = nil		--出售物品列表
	self.m_tGridList = nil
	self.m_nTag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSell:createElement()
	local element = WZUISystem:getInstance():createElement("WndSell")
	assert(element, "WndSell create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获取当前数据列表
function WndSell:getCurData()
	local tempList
	if self.m_nIndex == 1 then
		tempList = CacheCenter:getAllList()
	elseif self.m_nIndex == 2 then
		tempList = CacheCenter:getEquipList()
	elseif self.m_nIndex == 3 then
		tempList = CacheCenter:getPropList()
	elseif self.m_nIndex == 4 then
		tempList = CacheCenter:getBagMaterialList()
	elseif self.m_nIndex == 5 then
		tempList = CacheCenter:getGemList()
	end

	local tDataList = {}
	for k,v in pairs(tempList) do
		if self:_checkSellData(v) then
			table.insert(tDataList,CopyTable(v))
		end
	end
	table.sort(tDataList , _sortItem)
	if self.m_nIndex == 5 then
		table.sort(tDataList , sortGem1)
	end
	return tDataList
end

function sortGem1(a,b)
	if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
		return a.basicInfo.sub_type < b.basicInfo.sub_type 
	else
		if a.basicInfo.quality ~= b.basicInfo.quality then
			return a.basicInfo.quality < b.basicInfo.quality
		else
			return a.id < b.id 
		end
	end
end

--@brief	检查物品是否可以出售
function WndSell:_checkSellData(data)
	WZLog("检查物品是否可以出售:",data.basicInfo.name,usdata,data.isUse,data.expired)
	--if data.basicInfo.can_recycle == 1 and data.recyclePrice ~= -1 and usdata ~= -1 and data.isUse == false and data.expired == false then
	local usdata = -1
	local notTimeLimit = (data.basicInfo.time_limit == -1)
	if data.basicInfo.use_type == 0 then
		usdata = data.lastNum
	else
		usdata = data.lastTime
	end
	if data.basicInfo.recycle > 0 and usdata ~= -1 and data.isUse == false and notTimeLimit then
		return true 
	end
	return false 
end

--@brief	把物品按品质排序
function _sortItem(a,b)
	if WndSell:getPriority(a) ~= WndSell:getPriority(b) then
		return WndSell:getPriority(a) > WndSell:getPriority(b)
	elseif a.extraInfo.strongLevel ~= nil and b.extraInfo.strongLevel ~= nil and a.extraInfo.strongLevel ~= b.extraInfo.strongLevel then
		return a.extraInfo.strongLevel <= b.extraInfo.strongLevel
	elseif a.extraInfo.starLevel ~= nil and b.extraInfo.starLevel ~= nil and a.extraInfo.starLevel ~= b.extraInfo.starLevel then
		return a.extraInfo.starLevel <= b.extraInfo.starLevel
	elseif a.basicInfo.quality ~= b.basicInfo.quality then
		return a.basicInfo.quality <= b.basicInfo.quality
	elseif WndSell:getPositionPriority(a) ~= WndSell:getPositionPriority(b) then
		return WndSell:getPositionPriority(a) > WndSell:getPositionPriority(b)
	end
end

--@brief	获得部位优先级
function WndSell:getPriority(tData)
	local main_type = tData.basicInfo.main_type
	local priority = 0
	if main_type == 4 or main_type == 5 then
		priority = 3
	end
	if main_type == 7 then
		priority = 2
	end
	if main_type == 6 then
		priority = 1
	end
	return priority
end

--@brief	获得部位优先级
function WndSell:getPositionPriority(tData)
		local subtype = tData.basicInfo.sub_type
		local priority = 0
		if subtype == 0 then
			priority = 10
		end
		if subtype == 1 then
			priority = 9
		end
		if subtype == 2 then
			priority = 5
		end
		if subtype == 3 then
			priority = 7
		end
		if subtype == 4 then
			priority = 8
		end
		if subtype == 5 then
			priority = 6
		end
		if subtype == 6 then
			priority = 4
		end
		if subtype == 7 then
			priority = 3
		end
		if subtype == 8 then
			priority = 2
		end
	return priority
end
-------------------------------------私有方法模块End----------------------------------------
