--WndTransactionData.lua
--@brief	WndTransaction的数据模块
--@date		2017/03/15
--@author	zsq
--@note		交易行窗口

WndTransaction = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTransaction:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nRightTag = nil
	self.m_tDataList = nil
	self.m_tDataList1 = nil
	self.m_tDataList2 = nil
	self.m_tDataList3 = nil
	self.m_tDataList4 = nil
	self.m_nCountDown = nil
	self.m_nLogType = nil
	self.m_nTodaySaleCount = nil 		--玩家今日已售出商品数量
	self.m_nDayOfMonth = nil 			--一个月的几号,用来判断是否跨天
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTransaction:_unInit()
	self.m_root = nil
	self.m_nRightTag = nil
	self.m_tDataList = nil
	self.m_tDataList1 = nil
	self.m_tDataList2 = nil
	self.m_tDataList3 = nil
	self.m_tDataList4 = nil
	self.m_nCountDown = nil
	self.m_nLogType = nil
	self.m_nTodaySaleCount = nil
	self.m_nDayOfMonth = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTransaction:createElement()
	local element = WZUISystem:getInstance():createElement("WndTransaction")
	assert(element, "WndTransaction create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndTransaction:setMyGem(item, num)
    if self.m_root == nil then return end
    self.m_tDataList = {}
	
	local function sort(a, b)
		local t1 = GDatatab_item["id_"..a.itemIds]
		local t2 = GDatatab_item["id_"..b.itemIds]
		if t1.quality ~= t2.quality then
			return t1.quality > t2.quality
		elseif t1.num ~= t2.num then
			return t1.num > t2.num
		else
			return t1.id < t2.id
		end
	end

	local function sort1(a, b)
		local t1 = GDatatab_item["id_"..a.itemIds]
		local t2 = GDatatab_item["id_"..b.itemIds]
		if t1.quality ~= t2.quality then
			return t1.quality < t2.quality
		elseif t1.num ~= t2.num then
			return t1.num > t2.num
		else
			return t1.id < t2.id
		end
	end

	local maxItemNum = 99
    
	local itemTag = 1
    for i = 1, #item do
        --local tItem = {}
        --tItem.itemIds = item[i]
        --tItem.num = num[i]
		
        local nTemuNum = num[i]
        while nTemuNum > 0 do
            local tItem = {}
			tItem.itemTag = itemTag
            tItem.itemIds = item[i]
			maxItemNum = GDatatab_item["id_"..item[i]].stack
            if nTemuNum > maxItemNum then
                tItem.num = maxItemNum

                nTemuNum = nTemuNum - maxItemNum
            else
                tItem.num = nTemuNum

                nTemuNum = 0
            end
            
            table.insert(self.m_tDataList, tItem)
			itemTag = itemTag + 1
        end

        --table.insert(self.m_tDataList, tItem)
    end

	if self.m_nRightTag == 2 then
		table.sort(self.m_tDataList, sort)
	end
	if self.m_nRightTag == 3 then
		table.sort(self.m_tDataList, sort1)
	end
	WZLog("WndTransaction:setMyGem", Serialize(self.m_tDataList))

	self:updateBag()
	if self.m_nRightTag == 3 then
		WndTransaction:updateRight3()
	end
end

function WndTransaction:setData1(commodityIds, itemIds, quantitys, prices)
    if self.m_root == nil then return end
    self.m_tDataList1 = {}
    
	--commodityIds = {1,2,3,4,5,6}
	--itemIds = {401,402,403,404,405,406}
	--quantitys = {1,2,3,4,5,6}
	--prices = {500,200,300,400,500,600}

    for i = 1, #commodityIds do
        local tItem = {}
        tItem.commodityIds = commodityIds[i]
        tItem.itemIds = itemIds[i]
        tItem.quantitys = quantitys[i]
        tItem.prices = prices[i]
		
        table.insert(self.m_tDataList1, tItem)
    end
	WZLog("WndTransaction:setData1", Serialize(self.m_tDataList1))

	self:update()
end

function WndTransaction:setData2(commodityIds, itemIds, quantitys, saleNums, saleTime, todaySaleCount)
    if self.m_root == nil then return end
    self.m_nTodaySaleCount = todaySaleCount
    self.m_nDayOfMonth = os.date("%d")
    self.m_tDataList2 = {}
    
	--commodityIds = {1,2,3,4,5,6}
	--itemIds = {401,402,403,404,405,406}
	--quantitys = {1,2,3,4,5,6}
	--saleNums = {1,2,3,4,5,6}
	--saleTime = {1,2,3,4,5,6}

    for i = 1, #commodityIds do
        local tItem = {}
        tItem.commodityIds = commodityIds[i]
        tItem.itemIds = itemIds[i]
        tItem.quantitys = quantitys[i]
        tItem.saleNums = saleNums[i]
        tItem.saleTime = saleTime[i]
		
        table.insert(self.m_tDataList2, tItem)
    end

	self:update()
end

function WndTransaction:setData4(logType, itemIds, itemNums, prices, addSpar, commodityTime, authenticateNum, authenticateItemId, authenticateItemNum)
    if self.m_root == nil then return end
    self.m_tDataList4 = {}
    
	--logType = {1,0,1,0,1,0}
	--itemIds = {401,402,403,404,405,406}
	--itemNums = {1,2,3,4,5,6}
	--prices = {1,2,3,4,5,6}
	--addSpar = {1,2,3,4,5,6}
	--commodityTime = {"2017-3-13 00:01","2017-3-13 00:02","2017-3-13 00:03","2017-3-13 00:04","2017-3-13 00:05","2017-3-13 00:06"}

	-- authenticateNum, authenticateItemId, authenticateItemNum
	local authenticateIndex = 1
    for i = 1, #itemIds do
        local tItem = {}
        tItem.logType = logType[i]
        tItem.itemIds = itemIds[i]
        tItem.itemNums = itemNums[i]
        tItem.prices = prices[i]
        tItem.addSpar = addSpar[i]
        tItem.commodityTime = commodityTime[i]
        tItem.authenticateItems = {}
        for j=1,authenticateNum[i] do
        	local tempItem = {}
        	tempItem.id = authenticateItemId[authenticateIndex]
        	tempItem.num = authenticateItemNum[authenticateIndex]
        	table.insert(tItem.authenticateItems,tempItem)
        	authenticateIndex = authenticateIndex + 1
        end
		
        table.insert(self.m_tDataList4, tItem)
    end

	self:update()
end


-------------------------------------私有方法模块End----------------------------------------
