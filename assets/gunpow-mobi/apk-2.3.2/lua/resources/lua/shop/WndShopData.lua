--WndShopData.lua
--@brief	WndShop的数据模块
--@date		2015-5-25
--@author	binshao
--@note		商城

WndShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndShop:_init()
	self.m_root = nil	 	  	    -- 场景根节点
	self.selectDress = {}			-- 当前装扮物品列表1头，2脸，3衣服，4翅膀
    self.tryDress = {}              -- 当前穿着身上的时装
    self.propData = {}              -- 道具原生总列表
    self.propDescData = {}          -- 存放当前的道具数据，方便显示
    self.conPlayer = nil
    self.loadingId = nil
    self.selSex = nil               -- 当前选择的性别
    self.sexFlag = false            -- 是否切换过性别，用于是否更新缓存的数据

    self.leftIndex = nil

    -- 对应tab的cell
    self.hotCellData = {}       -- 热卖道具的cell信息
    self.dressCellData = {}     -- 时装道具的cell信息
    self.propCellData = {}      -- 道具的cell信息
    self.limitCellData = {}      -- 道具的cell信息
    self.giveCellData = {}      -- 赠送的cell信息
    self.oldCellData = {}       -- 折扣商品
    self.newCellData = {}       -- 新品商品
	self.CellData6 = {}
	self.CellData8 = {}

    -- 对应的上面标题
    self.dressTopIndex = 1
    self.propTopIndex = 1
    self.limitTopIndex = 1
    self.giveTopIndex = 1
	self.top5Index = 1
	self.m_nTag7 = 2			--当前抽奖tag
	self.top8Index = 1

    self.newDataFlag = false   -- 是否重新获取了数据

	self.m_tHotItems = {} -- 热销商品
    self.oldProp = {} -- 折扣商品
    self.oldPageAdd = true      -- index 是否需要增加
    self.newPageIndex = 0
    self.newPageAdd = true
    self.oldExistCnt = 0    -- 折扣商品存着的数量
    self.newExistCnt = 0    -- 新品图片存着的数量

	self.m_tNewGoods = {}    	--标签一新品推荐
	--self.m_nNewTime = 0   	    --新品推荐剩余秒数

	--self.m_tPromotion = {}		--标签三道具促销
	self.m_tItem4 = {}			--标签四特价限购
	self.sendDress = {}			--当前待赠送/索要 物品列表1头，2脸，3衣服，4翅膀
    self.m_nodeConLeft5 = nil 
    self.m_sTxtCheckLeft = nil
end

--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndShop:_unInit()
    self.m_root = nil
    self.selectDress = nil
    self.tryDress = nil
    self.curSelTag = nil
    self.maxTag = nil
    self.propDescData = nil
    self.propData = nil

    self.conPlayer = nil
    self.loadingId = nil
    self.selSex = nil
    self.sexFlag = false


    self.leftIndex = nil

    self.m_tHotItems = {}
    self.oldProp = {} -- 折扣商品
    self.m_nodeConLeft5 = nil 
    self.m_sTxtCheckLeft = nil
end
-------------------------------------公有方法模块Begin--------------------------------------
--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function WndShop:createElement()
    if self.m_root then
        WindowManager:removeWindow(self.m_root,WndShop)
    end
    local element = WZUISystem:getInstance():createElement("WndShop")
    assert(element, "WndShop create element failed!")
    self:_init()
    return element
end

--@brief    更新购买的相应的时装的状态
function WndShop:updatePlayerItemData()
    if self.m_root == nil then return end 
    self:_updateDressState()
	self:_update5Cost()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 根据一级标题给数据分类，以一级标题的数据作为下标来获取
function WndShop:InitShopList(list)
    WZLog("----------------enter init list---------------")
    -- 给道具显示列表进行排序
    self.propDescData = {}
	local tSuitList2 = {}
	local tSuitList6 = {}

    for i = 1, #list do
        if list[i].isOnSale then
            local curType = json.decode(list[i].mainType)
            for k,v in pairs(curType) do
                local mainType = tonumber(k)
                local subType = tonumber(v)
                local newData = {}
                newData.initData = list[i]
                newData.mainType = mainType
                newData.subType = subType

                -- 对应数据放到对应的位置，时装2，道具3，限购4,装备7
                if self.propDescData[mainType] == nil then self.propDescData[mainType] = {} end
				if mainType == 2 then
                	if self.propDescData[mainType][subType+1] == nil then self.propDescData[mainType][subType+1] = {} end
					local suit = list[i].suit
                	table.insert(self.propDescData[mainType][subType+1],newData)

					local sub_type = newData.initData.basicInfo.sub_type
					if suit ~= nil and suit ~= 0 and suit ~= -1 and suit ~= 255 and sub_type ~= 3 then
						--装备套装列表
						if self.propDescData[mainType][6] == nil then self.propDescData[mainType][6] = {} end
						if tSuitList2[tostring(suit)] == nil then
							tSuitList2[tostring(suit)] = {}
						end
						--套装列表下标要对应时装子类型
						tSuitList2[tostring(suit)][sub_type+1] = newData
					end
				else
					local changeMainType = mainType
					if changeMainType == 6 then changeMainType = 7 end
                	if self.propDescData[changeMainType] == nil then self.propDescData[changeMainType] = {} end
                    if mainType ~= 7 then 
                    	if self.propDescData[changeMainType][subType] == nil then self.propDescData[changeMainType][subType] = {} end
                    	table.insert(self.propDescData[changeMainType][subType],newData)
                    end
				end

                -- 赠送道具特殊处理，时装数据都要赋值过去 transaction == -1 不可以交易   赠送6
                if list[i].transaction ~= -1 and (mainType == 2 or mainType == 3) then
                    local subIndex = subType
                    if mainType == 3 then subIndex = 6 end
                    if self.propDescData[6] == nil then self.propDescData[6] = {} end
                    if self.propDescData[6][subIndex] == nil then self.propDescData[6][subIndex] = {} end
                    local tTempData = CopyTable(newData)
                    tTempData.initData.moneyId = tTempData.initData.moneyId2
                    table.insert(self.propDescData[6][subIndex],tTempData)
					--处理套装标签数据
					local suit = list[i].suit
					local sub_type = newData.initData.basicInfo.sub_type
					if mainType == 2 and suit ~= nil and suit ~= 0 and suit ~= -1 and sub_type ~= 3 then
						--装备套装列表
						if self.propDescData[6][5] == nil then self.propDescData[6][5] = {} end
						if tSuitList6[tostring(suit)] == nil then
							tSuitList6[tostring(suit)] = {}
						end
						--套装列表下标要对应时装子类型
                    	local tTempData = CopyTable(newData)
                    	tTempData.initData.moneyId = tTempData.initData.moneyId2
						tSuitList6[tostring(suit)][sub_type+1] = tTempData
					end
                end

                -- 推荐数据，特殊处理,放在mianType == 1 ,subType == 1
                if list[i].isHot then
                    if self.propDescData[1] == nil then self.propDescData[1] = {} end
                    if self.propDescData[1][1] == nil then self.propDescData[1][1] = {} end
                    table.insert(self.propDescData[1][1],newData)
                end

                --if list[i].ad and tostring(list[i].ad) ~= "0" and tostring(list[i].ad) ~= "-1" then
				--	WZLog("广告商品", Serialize(list[i]))
				--end
                -- 打折广告商品
                if list[i].ad and tostring(list[i].ad) ~= "0" and tostring(list[i].ad) ~= "-1" and tostring(list[i].newad) == "0" then
                    WZLog("-----------list[i].ad-------------",list[i].ad,list[i].newad)
					newData.jumpType = 1
                    table.insert(self.oldProp,newData)
                end
                if list[i].ad and tostring(list[i].ad) ~= "0" and tostring(list[i].ad) ~= "-1" and tostring(list[i].newad) == "1" then
                    WZLog("-----------list[i].ad1-------------",list[i].ad,list[i].newad)
					newData.jumpType = 2
                    table.insert(self.oldProp,newData)
                end
            end
        end
    end

    WZLog("--------------old cnt------------",#self.oldProp)
    --WZLog("--------------hahhaaha------------",Serialize(self.propDescData[6]))

    -- 推荐类排序
    local function sortRecommend(s1,s2)
        local info1 =  self:getPriorityLevel(s1.initData)
        local info2 =  self:getPriorityLevel(s2.initData)

        if info1.quality ~= info2.quality then return info1.quality > info2.quality end
        if info1.priLv ~= info2.priLv then return info1.priLv > info2.priLv end
        if info1.subType ~= info2.subType then return info1.subType > info2.subType end
        return info1.id > info2.id
    end

	--装备类排序
    local function sortEquip(s1,s2)
        local info1 =  self:getPriorityLevel(s1.initData)
        local info2 =  self:getPriorityLevel(s2.initData)

        if info1.quality ~= info2.quality then return info1.quality > info2.quality end
        return info1.id < info2.id
    end

    for i = 1, #self.propDescData do
        local data = self.propDescData[i]
		if data ~= nil then
        	for k,v in pairs(data) do
        	    table.sort(v,sortRecommend)
        	end
		end
    end

	--排序装备
	for k,v in pairs(self.propDescData[7]) do
	    table.sort(v,sortEquip)
	end

	--所有时装
	local sortAllDress = {4,2,3,5}
	if self.propDescData ~= nil and self.propDescData[2] ~= nil then
		self.propDescData[2][1] = {}
		local maxLen = math.max(#self.propDescData[2][2],#self.propDescData[2][3],#self.propDescData[2][4],#self.propDescData[2][5])
		for i=1,maxLen do
			for j=1,4 do
				if self.propDescData[2][sortAllDress[j]][i] ~= nil then
					table.insert(self.propDescData[2][1], self.propDescData[2][sortAllDress[j]][i])
				end
			end
		end
	end

	--tSuitList2["suit_1"] = {self.propDescData[2][1][2],self.propDescData[2][1][3],self.propDescData[2][1][1],}
	local sortSuit = function(a, b)
		return a.suitId > b.suitId
	end

	--套装列表下标要对应时装子类型
	if self.propDescData[2] == nil then self.propDescData[2] = {} end
	self.propDescData[2][6] = {}
	for k,v in pairs(tSuitList2) do
		if type(v) == "table" then
			v.isSuit = true
			v.suitId = tonumber(k)
			table.insert(self.propDescData[2][6], v)
		end
	end
	table.sort(self.propDescData[2][6], sortSuit)

	self.propDescData[6][5] = {}
	for k,v in pairs(tSuitList6) do
		if type(v) == "table" then
			v.isSuit = true
			v.suitId = tonumber(k)
			table.insert(self.propDescData[6][5], v)
		end
	end
	table.sort(self.propDescData[6][5], sortSuit)

    table.sort(self.propDescData[5][3], function (a,b)
        -- body
        if a.initData.discountTime == b.initData.discountTime then
            return sortRecommend(a,b)
        else
            return a.initData.discountTime > b.initData.discountTime
        end
    end)
end

-- 判断表中是否不存在某个值
function WndShop:JudgeTwoTitleIsNotExist(kind,v)
    for i = 1, #kind do
         if kind[i] == v then  return false end
    end
    return true
end

-- 判断当前商品是否处于穿戴状态
function WndShop:_judgePropIsSel(data)
    --WZLog("-----------_judgePropIsSel---------1",Serialize(data))
	local dressList = self.selectDress
	if self.leftIndex == 6 then
		dressList = self.sendDress
	end

	local shopId

    for i = 1, 4 do
    	--WZLog("-----------_judgePropIsSel---------2",Serialize(dressList[i]))
		if data.isSuit then
			if data[i] ~= nil then
				shopId = data[i].initData.id
			else
				return false
			end
		else
			shopId = data.initData.id
		end
        if dressList[i] and dressList[i].initData and dressList[i].initData.id == shopId then
            return true
        end
    end
    return false
end

-- 购买限制次数的商品后更新界面和数据
-- payID,payCount 购买的商城ID和数量
function WndShop:UpdatePropLimitCount(payId, payCount)
    WZLog("-------------------payid-------------------",payId,payCount)
    if not self.propData then 
		self.propData = CacheCenter.m_tShopItems 
	end
    -- 改变propData里面的数据
    for i = 1, #self.propData do
        if payId == self.propData[i].id then
            -- 不是限购商品的话直接返回
            if self.propData[i].limitLeave == -1 then return end
            self.propData[i].limitLeave =   self.propData[i].limitLeave - payCount
        end
    end

    -- 如果切换过性别，同时需要更新缓存中心表，没有切换的话，当前数据即为缓存数据
    WZLog("---------------is need update cache --------------",self.sexFlag)
    if self.sexFlag then
        local cacheData = CacheCenter.m_tShopItems
        for i = 1, #cacheData do
            if payId == cacheData[i].id then
                if cacheData[i].limitLeave == -1 then return end
                cacheData[i].limitLeave = cacheData[i].limitLeave - payCount
            end
        end
    end
	if self.m_root == nil then return end
    self:printCacheLimitCnt()
    self:_updataLimitCount()
end

-- 获取商城的根节点
function WndShop:getRoot()
    return self.m_root
end
-------------------------------------私有方法模块End----------------------------------------
--获得热销商品
function WndShop:updateHotShopItems(id, itemId, isNew, isVip, discount, mainType, moneyId, floorPrice, price, limitLeave, moneyId2)
    self.m_tHotItems = {}
    for i=0,id:size()-1 do
        local tTempItem = {}
        tTempItem.id = id:get(i)
        tTempItem.shopItemId = itemId:get(i)
        tTempItem.isNew = isNew:get(i)
        tTempItem.isPrivilege = isVip:get(i)
        tTempItem.discount = discount:get(i)
        tTempItem.mainType = mainType:get(i)
        tTempItem.moneyId = moneyId:get(i)
        tTempItem.floorPrice = floorPrice:get(i)
        tTempItem.price = price:get(i)
        tTempItem.limitLeave = limitLeave:get(i)
        tTempItem.moneyId2 = moneyId2:get(i)
        
        local key = "id_"..itemId:get(i)
        tTempItem.basicInfo = GDatatab_item[key]
        if tTempItem.basicInfo then
			local tData = {}
			tData.initData = tTempItem
			tData.mainType = 1
			tData.subType = 1
            table.insert(self.m_tHotItems,tData)
        end
    end
	--WZLog("进入商城消耗时间4", (WZThread:getUTickCount()-self.startTime)/1000000 , "秒")
	--WZLog("WndShop:updateHotShopItems", Serialize(self.m_tHotItems))
	self.newDataFlag = true
    self:onTempTab(1)
end

-- 改变性别时商品数据更新
function WndShop:updateShopItems(id, itemId, itemName, isHot, isNew, isVip, discount, mainType, moneyId, floorPrice, agingPrice, limitLeave,isOnSale,transaction,ad,newad, moneyId2, suit)
    WZLog("----------------receive shop info---------------")
	--WZLog("切换标签消耗时间1", (WZThread:getUTickCount()-self.startTime)/1000000 , "秒")
    self:closeLoadingBox()
    self.newDataFlag = true
    self.propData = {}
    for i=0,id:size()-1 do
        local tTempItem = {}
        tTempItem.id = id:get(i)
        tTempItem.shopItemId = itemId:get(i)
        tTempItem.shopItemName = itemName:get(i)
        tTempItem.isHot = isHot:get(i)
        tTempItem.isNew = isNew:get(i)
        tTempItem.isPrivilege = isVip:get(i)
        tTempItem.discount = discount:get(i)
        tTempItem.mainType = mainType:get(i)
        tTempItem.moneyId = moneyId:get(i)
        tTempItem.floorPrice = floorPrice:get(i)
        tTempItem.agingPrice = agingPrice:get(i)
        tTempItem.limitLeave = limitLeave:get(i)
        tTempItem.isOnSale = isOnSale:get(i)
        tTempItem.transaction = transaction:get(i)
        tTempItem.ad = ad:get(i)
        tTempItem.newad = newad:get(i)
        tTempItem.moneyId2 = moneyId2:get(i)
        tTempItem.suit = suit:get(i)

        local key = "id_"..itemId:get(i)
        tTempItem.basicInfo = GDatatab_item[key]
        if tTempItem.basicInfo then
            table.insert(self.propData,tTempItem)
        end
    end
    self:InitShopList(self.propData)
	if self.leftIndex ~= 1 then
    	self:onTempTab(self.leftIndex)
	else
		self:showNewDiscount()
	end
end

-- 改变性别时商品限购信息更新
function WndShop:updateShopItemsLimitLeave(id, limitLeave)
    WZLog("----------------receive limit info---------------")
    for i=1,#id do
        for k,v in pairs(self.propData) do
            if v.id == id[i] then
                v.limitLeave = limitLeave[i]
            end
        end
    end
    self:_updataLimitCount()

    WZLog("-----------------------process enter-----------------")
    self:printCacheLimitCnt()
end

-- 判断性别是否一样
function WndShop:selSexIsSame()
    return self.selSex == CacheCenter:getPlayerInfo().sex
end

-- 判断性别是否一样
function WndShop:getShopSelSex()
    return self.selSex
end

-- 获取排序的优先级(针对推荐系列)
function WndShop:getPriorityLevel(data)
    local basicInfo = data.basicInfo
    local priLv = 0
    if basicInfo.main_type == 4 then        -- 装备
        priLv = 10
    elseif basicInfo.main_type == 5 then    -- 时装
        priLv = 9
    elseif basicInfo.main_type == 7 then    -- 材料
        priLv = 8
    elseif basicInfo.main_type == 6 then    -- 宝石
        priLv = 7
    elseif basicInfo.main_type == 3 then    -- 宝箱
        priLv = 6
    elseif basicInfo.main_type == 2 then    -- 道具
        priLv = 5
    elseif basicInfo.main_type == 9 then    -- 碎片
        priLv = 4
    end
    local info = {
        priLv = priLv,
        quality = basicInfo.quality,
        mainType = basicInfo.main_type,
        subType =  basicInfo.sub_type,
        id = data.id
    }

    return info
end

-- 判断商品是否为时装
function WndShop:judgePropIsDress(data)
	--WZLog("WndShop:judgePropIsDress",debug.traceback())
    local info = data.initData
    if info.basicInfo.main_type == 5 then return true end
    return false
end

-- 打印限购信息
function WndShop:printCacheLimitCnt()
	do return end
    for i = 1, #CacheCenter.m_tShopItems do
        if CacheCenter.m_tShopItems[i].limitLeave ~= -1 then
            WZLog("---------------cache limit data------------",CacheCenter.m_tShopItems[i].id,CacheCenter.m_tShopItems[i].limitLeave)
        end
    end

    for i = 1, #self.propData do
        if self.propData[i].limitLeave ~= -1 then
            WZLog("---------------shop limit data------------",self.propData[i].id,self.propData[i].limitLeave)
        end
    end
end

-- 记录当前不同tab容器的cell数据
function WndShop:saveCellData(tab,cell,tcell,index)
    if tab == nil then tab = {} end
    tab[index] = {cell = cell, tcell = tcell}
end


function WndShop:getCellShowType()
    local type = 1  -- 1 = 试穿和购买 ， 2 == 试穿和赠送  3 = 赠送， 4 = 购买
    if self.leftIndex == 2 then
        type = 1
    elseif self.leftIndex == 5 and self.giveTopIndex <= 4 then
        type = 2
    elseif self.leftIndex == 5 and self.giveTopIndex <= 5 then
        type = 3
    else
        type = 4
    end

    return type
end

--@param    mainTab:主标签 subTab:子标签  从1开始
function WndShop:jumpTab(mainTab, subTab)
	WZLog("WndShop:jumpTab",mainTab,subTab,WndFastGetItems.m_nShopTipItemId)
    -- body
    local wndShop = WndShop:createElement()
	WndShop.jumpMain = mainTab
	WndShop.jumpSub = subTab
	if mainTab == 5 then WndShop.jumpSub = 1 end
    WindowManager:addWindow(wndShop, WndShop)
end

function WndShop:jumpTab1(mainTab, subTab)
    local jumpMethod = {"none","onTopDressTitle","onTopPropTitle","onTopLimitTitle","","onTopGiveTitle","onCheck7","onTop8Title"}
    WZLog("WndShop:jumpTab---------",mainTab, subTab)
    WndShop:onTempTab(mainTab)
    if WndShop[jumpMethod[mainTab]] then
        WndShop[jumpMethod[mainTab]](WndShop, subTab)
    end
end

--@brief    刷新商店数据
function WndShop:updateExchangeGoodsData(shopItemList)
    -- body
    if self.m_root == nil then return end 

    self.propData = shopItemList
    self:InitShopList(shopItemList)
end