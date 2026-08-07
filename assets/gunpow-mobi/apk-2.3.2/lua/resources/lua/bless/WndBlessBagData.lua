--WndBlessBagData.lua
--@brief	WndBlessBag的数据模块
--@date		2016/03/29
--@author	Tianxiang_Xu
--@note		祈福背包

WndBlessBag = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndBlessBag:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nMaxGridsNum = nil 	--背包最大格子数
	self.m_tCellGridsList = nil --格子对象
	self.m_tBlessItemList = nil --背包中的祝福
	self.m_tEquipList = nil 	--装备栏数据
	self.m_nBlessFighting = nil 	--祈福战力
	self.m_nLoadingId = nil 	--网络连接动画Id
	self.m_nOperateType = nil 	--操作类型：1：装备；2：卸下
	self.m_tDressUpData = nil 	--装备的祝福数据
	self.m_tTakeOffData = nil 	--卸下的祝福数据或者被挤掉的祝福数据
	self.m_nEquipRectIndex = nil 	--即将操作的装备栏的索引
	self.m_tRoleAni = nil 
	self.m_bIsPlaying = false 	--是否正在播放點擊產生的動畫
	self.m_topCellLua = nil 
	self.m_tCellDressSuit = nil 
	self.m_tDressSuit = nil 

	--164
	self.m_tBlessDataList = nil 	--祈福数据列表
	self.m_tBlessObjList = nil 		--祈福对象列表
	self.m_nSelectedBless = nil 	--选中的祈福

	self.m_tDevourList = {}			--吞噬区祈福数据
	self.m_tBlessList = {} 			--吞噬区祈福对象
	self.m_tChooseList = {} 		--吞噬区选中的祈福数据
	self.m_nTotalExp = 0			--吞噬区选中的祈福总经验

end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBlessBag:_unInit()
	self.m_root = nil
	self.m_nMaxGridsNum = nil 	--背包最大格子数
	self.m_tCellGridsList = nil --格子对象
	self.m_tBlessItemList = nil --背包中的祝福
	self.m_tEquipList = nil 	--装备栏数据
	self.m_nBlessFighting = nil 	--祈福战力
	self.m_nLoadingId = nil 	--网络连接动画Id
	self.m_nOperateType = nil 	--操作类型：1：装备；2：卸下
	self.m_tDressUpData = nil 	--装备的祝福数据
	self.m_tTakeOffData = nil 	--卸下的祝福数据或者被挤掉的祝福数据
	self.m_nEquipRectIndex = nil 	--即将操作的装备栏的索引
	self.m_tRoleAni = nil 
	self.m_bIsPlaying = false 	--是否正在播放點擊產生的動畫
	self.m_topCellLua = nil 
	self.m_tCellDressSuit = nil 
	self.m_tDressSuit = nil 

	--164
	self.m_tBlessDataList = nil 	--祈福数据列表
	self.m_tBlessObjList = nil 		--祈福对象列表
	self.m_nSelectedBless = nil 	--选中的祈福

	self.m_tDevourList = nil		--吞噬区祈福数据
	self.m_tBlessList = nil 		--吞噬区祈福对象
	self.m_tChooseList = nil 		--吞噬区选中的祈福
	self.m_nTotalExp = nil			--吞噬区选中的祈福总经验
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndBlessBag:createElement()
	local element = WZUISystem:getInstance():createElement("WndBlessBag")
	assert(element, "WndBlessBag element create failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndBlessBag:showWin()
	-- body
	local conSubWin = GetElement(WndBagMain.m_root, "conSubWin_1", WZUIContainer)
	if conSubWin then
		local wndBlessBag = WndBlessBag:createElement()
	    if wndBlessBag then 
	        conSubWin:addChild(wndBlessBag)
	    end
	end
end

function WndBlessBag:devourAllOK(devourId, exp, prayId, ids)
	ProtocolProcessorBless:send_PRAY_GetPrayMess()
end

-- 发送协议刷新界面数据
function WndBlessBag:sendPRAYProtocol()
    ProtocolProcessorBless:send_PRAY_GetPrayMess()
end

function WndBlessBag:setData(bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, blessFighting, equipRectId, openlevel)
    -- body
    --背包中的祝福
    local tBagList = {}
    for i = 0, bagIds:size() - 1 do
        local tTemp = {}
        tTemp.id = bagPrayIds:get(i)
        tTemp.blessId = bagIds:get(i)
        tTemp.curExp = bagExps:get(i)

        table.insert(tBagList, tTemp)
    end
    local tBlessBagList = WndBlessBag:setBlessBagList(2, tBagList)
    --装备栏的数据
    local tEquipList = {}
    WZLog("WndBlessBag:setData 111",equipRectId:size(), openlevel:size(), prayNum:size())
    for k = 0, equipRectId:size() - 1 do
        local tTemp = {}
        tTemp.openLevel = openlevel:get(k)
        --判断该装备栏是否开启
        if tTemp.openLevel <= CacheCenter:getPlayerInfo().level then
            tTemp.status = 0
        else
            tTemp.status = -1
        end
        for l = 0, prayNum:size() - 1 do 
            local id = equipPrayId:get(l)
            local tData = CopyTable(GDatatab_pray["id_"..id])
            tData.basicInfo = CopyTable(GDatatab_item["id_"..tData.item_id])
            tData.userType = 3
            tData.curExp = equipExp:get(l)
            tData.blessId = equipId:get(l)
			tData.name = tData.basicInfo.name
            if equipRectId:get(k) == prayNum:get(l) then
                tTemp.status = 1
                tTemp.tData = tData
            end
        end

        table.insert(tEquipList, tTemp)
    end
    self:_stopLoading()

    WndBlessBag:setBlessItemList(blessFighting, tBlessBagList, tEquipList)
end
--@brief    设置背包祈福数据
--@param    userType :用户定义的类型：2：在背包
--@param    tDataList:服务器传过来的数据
function WndBlessBag:setBlessBagList(userType, tDataList)
    -- body
    local tBlessBagList = {}

    for i = 1, #tDataList do
        local tTemp = CopyTable(GDatatab_pray["id_"..tDataList[i].id])
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id])
        tTemp.userType = userType
        tTemp.blessId = tDataList[i].blessId
        tTemp.curExp = tDataList[i].curExp
		tTemp.name = tTemp.basicInfo.name
        if tTemp then
            table.insert(tBlessBagList, tTemp)
        end
    end

    WZLog("WndBlessBag:setBlessBagList", Serialize(tBlessBagList))
    return tBlessBagList
end

--@brief 	设置背包祝福数据
--@param 	userType: 用户定义的类型  2：在背包中；3：已经装备
function WndBlessBag:setBlessItemList( nFighting, tDataList, tEquipList)
	-- body
	self.m_tBlessItemList = tDataList
    for i = 1, #self.m_tBlessItemList do 
        self.m_tBlessItemList[i].userType = 2
    end

    for i = 1, #tEquipList do
        if tEquipList[i].tData then 
            tEquipList[i].tData.userType = 3
        end
    end
	
    --清空原格子的东西
    for i = 1, #self.m_tCellGridsList do
        self.m_tCellGridsList[i]:setData(nil, 1)
    end
	--对背包中的祝福进行排序
	if self.m_tBlessItemList then
		table.sort(self.m_tBlessItemList, sortBlessItem)

		for i = 1, #self.m_tBlessItemList do
			if self.m_tCellGridsList[i] then
				self.m_tCellGridsList[i]:setCallBackFun(self, self.onClickDevour, self.onClickEquip, self.onClickTakeOff)
				self.m_tCellGridsList[i]:setData(self.m_tBlessItemList[i], 4, self.m_root)
			end
		end
	end
	--背包底部数值
	self:_updateGridsNum()
	--设置装备栏数据
	self:setEquipData(nFighting, tEquipList)
end

--@brief	设置装备栏数据，祈福战力
--@param 	nFighting: 祈福战力
--@param 	tEquipList: 装备栏相关数据
--@param 	userType: 3:已经装备
function WndBlessBag:setEquipData(nFighting, tEquipList)
	-- body
	--祈福战力
	self.m_nBlessFighting = nFighting
	self.m_tEquipList = tEquipList

	self:_updateLeftInfo()
end

--@brief 	背包祝福排序函数
function sortBlessItem(a, b)
	-- body
	if a.quality ~= b.quality then
		return a.quality > b.quality
	elseif a.id ~= b.id then
		return a.id > b.id
	elseif a.level ~= b.level then
		return a.level > b.level
	elseif a.curExp ~= b.curExp then
		return a.curExp > b.curExp
	else
		return false
	end
end


--@brief 	计算穿着身上的祝福的个属性的值
function WndBlessBag:caculateProperty()
	-- body
	tEquipProperty = {{1, 0}, {3, 0}, {4, 0}, {5, 0}, {7, 0}, {9, 0}, {10, 0}, {11, 0}, {12, 0}, {13, 0}, {19, 0}, {20, 0}}

	local tBagList, tEquipList = WndBlessBag:getBagList()
	local equipBlessNum = 0
	for i = 1, #tEquipList do
		if tEquipList[i].status == 1 then
			for j = 1, #tEquipList[i].tData.property do
				local tItem = tEquipList[i].tData.property[j]
				for k = 1, #tEquipProperty do
					if tItem[1] == tEquipProperty[k][1] then      	
						tEquipProperty[k][2] = tEquipProperty[k][2] + tItem[2]
						break 
					end
				end
			end
		end
	end

	return tEquipProperty
end

--@brief 	设置保存的套装数据
function WndBlessBag:setDressSuitData(id, suitName, bIsUsed)
	-- body
	if self.m_root == nil then return end 

	self.m_tDressSuit = {}

	for i = 1, #id do
		local tItem = {}

		tItem.id = id[i]
		tItem.name = suitName[i]
		tItem.bIsUsed = bIsUsed[i] 

		table.insert(self.m_tDressSuit, tItem)
	end

	local function getUseValue(a)
		-- body
		if a.bIsUsed == true then
			return 0
		else
			return 1
		end
	end

	table.sort(self.m_tDressSuit, function (a, b)
		-- body
		return a.id < b.id
	end)

	WZLog("WndBlessBag:setDressSuitData", Serialize(self.m_tDressSuit))
end

--@brief 	新增套装
function WndBlessBag:addNewDressSuit(id, name)
	-- body
	if self.m_tDressSuit == nil then
		self.m_tDressSuit = {}
	end

	local tItem = {}

	tItem.id = id
	tItem.name = name
	tItem.bIsUsed = false

	table.insert(self.m_tDressSuit, tItem)
end

--@brief    更新多套时装数据
function WndBlessBag:updateDressSuitData(nType)
    -- body
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
        self.m_tCellDressSuit:changeDressSuitOK()
    else
        self.m_tCellDressSuit:setSuitData(self.m_tDressSuit)
    end
end

--@brief 	套装改名
function WndBlessBag:dressSuitRename(id, newName)
	-- body
	if self.m_tDressSuit == nil then return end 
	for i = 1, #self.m_tDressSuit do
		if self.m_tDressSuit[i].id == id then
			self.m_tDressSuit[i].name = newName

			break 
		end
	end
end


--@brief    设置祈福数据
function WndBlessBag:setBlessData(bagIds, bagExps, bagPrayIds, bagPrayNum, prayNum, equipPrayId, equipId, equipExp, fightNum)
    self.m_tBlessBagList = {}
    for i = 0, bagIds:size() - 1 do
    	local temppray = GDatatab_pray["id_"..bagPrayIds:get(i)]
        local tData = {}
        tData = CopyTable(temppray)
    	tData.blessId = bagIds:get(i)
        tData.bGray = false
        tData.curExp = bagExps:get(i)
        tData.num = bagPrayNum:get(i)
        tData.tabBlessing = self:getBlessInfoByItemId(temppray.item_id)
        tData.basicInfo = GDatatab_item["id_"..temppray.item_id]
        table.insert(self.m_tBlessBagList, CopyTable(tData))
    end

    --全部祈福
    self.m_tBlessDataList = {}
    for k,v in pairs(GDatatab_blessing) do
        local tData = {}
        tData = CopyTable(self:getPrayInfoByItemId(v.item_id,1))
        tData.curExp = 0
        tData.bGray = true
        tData.tabBlessing = CopyTable(v)
        tData.basicInfo = CopyTable(GDatatab_item["id_"..v.item_id])
        table.insert(self.m_tBlessDataList,tData)
    end
    for i = 0, equipPrayId:size() - 1 do
        for j = 1, #self.m_tBlessDataList do
            local temppray = GDatatab_pray["id_"..equipPrayId:get(i)]
            if temppray and self.m_tBlessDataList[j].item_id == temppray.item_id then
                self.m_tBlessDataList[j] = CopyTable(temppray)
                self.m_tBlessDataList[j].blessId = equipId:get(i)
                self.m_tBlessDataList[j].bGray = false
                self.m_tBlessDataList[j].curExp = equipExp:get(i)
                self.m_tBlessDataList[j].tabBlessing = self:getBlessInfoByItemId(temppray.item_id)
                self.m_tBlessDataList[j].basicInfo = GDatatab_item["id_"..temppray.item_id]
            end
        end
    end
    table.sort( self.m_tBlessDataList, function(a,b)
        if self:isMaxLevel(a) == true and self:isMaxLevel(b) == false then
            return false
        elseif self:isMaxLevel(a) == false and self:isMaxLevel(b) == true then
            return true
        elseif a.bGray == true and b.bGray == false then
            return false
        elseif a.bGray == false and b.bGray == true then
            return true
        elseif a.bGray == true and b.bGray == true then
            if self:isActivatable(a) == true and self:isActivatable(b) == false then
                return true
            elseif self:isActivatable(a) == false and self:isActivatable(b) == true then
                return false
            end
        end
        return a.tabBlessing.id < b.tabBlessing.id
    end )

    self:updateBlessList()

    if self.m_nSelectedBless == nil then
        self:selectBless(self.m_tBlessDataList[1])
    else
        self:selectBless(self.m_nSelectedBless)
    end

	self:updateBlessDetails()

    --祈福战力
    self.m_nBlessFighting = fightNum

end

--@brief 	激活祈福成功
function WndBlessBag:activateBlessOk(id)
	MsgBoxManager:showTipBox(LocalStrings.NEWSKILL15)

    for i=1,#self.m_tBlessDataList do
        if self.m_tBlessDataList[i].tabBlessing.id == id then
        	self.m_tBlessDataList[i].bGray = false
            -- self.m_tBlessDataList[i].blessId = blessId
            self.m_tBlessObjList[i]:setData(self.m_tBlessDataList[i])
        end

        self:setBlessRedDot(self.m_tBlessObjList[i]) --红点
    end

	self:updateBlessDetails()
end

--@brief    根据物品id获取tab_pray对应信息
function WndBlessBag:getPrayInfoByItemId(itemId,nLevel)
	nLevel = nLevel or 1
    for k,v in pairs(GDatatab_pray) do
        if v.item_id == itemId and v.level == nLevel then
            return v
        end
    end
end

function WndBlessBag:getBlessInfoByItemId(itemId)
	for k,v in pairs(GDatatab_blessing) do
        if v.item_id == itemId then
            return v
        end
    end
end

--@brief    吞噬成功后的处理
function WndBlessBag:onceDevourOk(devourId, exp, prayId, ids, fighting)
    --清理掉已经被吞噬掉的祝福（包括当前界面和来源界面（祈福屋或背包））
    WZLog("WndDevour:onceDevourOk")
    --清空选中祈福和可得经验
    self.m_tChooseList = {}
    self.m_nTotalExp = 0
    --清掉被吞噬的祝福
    self:_cleanBeDevourBless(ids)
    --更新吞噬的祝福的信息数据（包括当前和来源）
    self:_updateTheBlessItemInfo(devourId, exp, prayId)
    --如果操作的是装备栏的祝福    
    self:_stopLoading()

    --更新祈福右侧详情
    self:updateBlessDetails()
end

--@brief    清除掉被吞噬的祝福
--param     tBeDevourBless: 被吞噬掉的祝福的Id
function WndBlessBag:_cleanBeDevourBless(tBeDevourIds)
    --移除可吞噬列表中已经被吞噬的祝福
    for i = 1, #tBeDevourIds do
        for j = #self.m_tBlessBagList, 1, -1 do
            if self.m_tBlessBagList[j].blessId == tBeDevourIds[i] then
                self.m_tBlessBagList[j].num = self.m_tBlessBagList[j].num - 1
                if self.m_tBlessBagList[j].num == 0 then
                    table.remove(self.m_tBlessBagList, j)
                    break
                end
            end
        end
    end
end

--@brief    更新吞噬后，节点的数据更新显示
function WndBlessBag:_updateTheBlessItemInfo(devourId, exp, prayId)
    local nIndex = self:getBlessDataIndex(self.m_nSelectedBless.item_id)
    local curBless = self.m_tBlessDataList[nIndex]
    local tPrayInfo = GDatatab_pray["id_"..prayId]
    if curBless.item_id == tPrayInfo.item_id then
        local tData = CopyTable(tPrayInfo)
        tData.index = curBless.index
        tData.tabBlessing = curBless.tabBlessing
        tData.basicInfo = curBless.basicInfo
        tData.userType = curBless.userType
        tData.blessId = curBless.blessId
        tData.bGray = curBless.bGray
        tData.curExp = exp

        self.m_tBlessDataList[nIndex] = tData
        local nMaxLevel = self:_getMaxLevel(tData.item_id)
        local nCurExp = tData.curExp
        local nTotalExp = tData.total_exp
        if tData.level == nMaxLevel then
            local nTempId = self:_getSecondMaxLevel(nMaxLevel, tData.item_id)
            local tTempData = GDatatab_pray["id_"..nTempId]
            nCurExp = tTempData.total_exp
            nTotalExp = tTempData.total_exp
        end

        self.m_tBlessObjList[nIndex]:setData(self.m_tBlessDataList[nIndex])
        -- self:_update(prayId)
        -- --更新来源处的相应祝福
        -- WndBlessBag:updateTheBlessItemInfo(tData)
        self:updateExpTxt()
    end

end

--@brief    获取当前类型的祝福的第二高等级的id
function WndBlessBag:_getSecondMaxLevel(nMaxLevel, itemId)
    -- body
    local id = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level == nMaxLevel - 1 then
            id = value.id
        end
    end

    return id
end

--@brief    根据物品id找到祈福列表数据的下标
function WndBlessBag:getBlessDataIndex(itemId)
    for i=1,#self.m_tBlessDataList do
        if self.m_tBlessDataList[i].item_id == itemId then
            return i
        end
    end
end

--@brief    判断祈福是否满级
function WndBlessBag:isMaxLevel(tBless)
    if tBless.level >= self:_getMaxLevel(tBless.item_id) then
        return true 
    end
    return false
end

--@brief    判断祈福是否满足激活条件
function WndBlessBag:isActivatable(tBless)
    if CacheCenter:getPlayerInfo().level < tBless.tabBlessing.lv then
        return false
    end

    local tCondition = tBless.tabBlessing.condition
    for i=1,#tCondition do
        if CacheCenter:getPlayerItemCountById(tCondition[i][1]) < tCondition[i][2] then
            return false
        end
    end

    return true
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    根据属性表，计算战力
--@param    tProperty:属性表
function WndBlessBag:_caculateFighting(tProperty)
    -- body
    if tProperty == nil or #tProperty == 0 or tProperty == 0 or tProperty == -1 then return 0 end

    local extraInfo = {}
    extraInfo["12"] = 0 
    extraInfo["13"] = 0
    extraInfo["10"] = 0
    extraInfo["11"] = 0
    extraInfo["9"] = 0 
    extraInfo["1"] = 0
    extraInfo["3"] = 0
    extraInfo["4"] = 0
    extraInfo["5"] = 0
    extraInfo["7"] = 0
    extraInfo["19"] = 0
    extraInfo["20"] = 0
    extraInfo["18"] = 0

    for i = 1, #tProperty do
        local sIndex = tostring(tProperty[i][1])
        extraInfo[sIndex] = tProperty[i][2]
    end

    local nFighting = caculateClothesFighting(extraInfo)

    return nFighting
end

-------------------------------------私有方法模块End----------------------------------------
