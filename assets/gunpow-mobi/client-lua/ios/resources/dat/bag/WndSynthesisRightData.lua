--WndSynthesisRightData.lua
--@brief	WndSynthesisRight的数据模块
--@date		2015/07/17
--@author	zsq
--@note		合成系统右侧窗口
--@刷新右侧窗口流程
--updateRightList()
--_updateItemList()
--_updateList()
--_createCellGoodItem()

WndSynthesisRight = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSynthesisRight:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nInitIndex = 3               --初始显示的序号
    self.m_nSelectedIndex = 0           --当前显示的序号
    
    self.m_tItemDataList = nil          --道具数据列表
    self.m_tEquipDataList = nil         --装备数据列表
	self.m_tGemDataList = nil			--宝石数据列表
    self.m_tDressDataList = nil         --时装数据列表
    self.m_tSkinDataList = nil          --皮肤数据列表
    self.m_tItemObjList = nil           --道具节点绑定的lua对象列表
    self.m_tGemObjList = nil           --道具节点绑定的lua对象列表
    self.m_tEquipObjList = nil          --装备节点绑定的lua对象列表
    self.m_tDressObjList = nil          --时装节点绑定的lua对象列表
    self.m_tSkinObjList = nil           --皮肤节点绑定的lua对象列表
    
    self.m_tSuccessItemInfo = nil       --合成成功后的物品信息

	self.m_nTag = nil
	self.m_tData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSynthesisRight:_unInit()
	self.m_root = nil
    self.m_nInitIndex = 3              
    self.m_nSelectedIndex = 0
    
    self.m_tItemDataList = nil
	self.m_tGemDataList = nil			--宝石数据列表
    self.m_tSkinDataList = nil          --皮肤数据列表
    self.m_tEquipDataList = nil
    self.m_tDressDataList = nil
    self.m_tItemObjList = nil
    self.m_tGemObjList = nil           --道具节点绑定的lua对象列表
    self.m_tEquipObjList = nil
    self.m_tDressObjList = nil
    self.m_tSkinObjList = nil           --皮肤节点绑定的lua对象列表
    
    self.m_tSuccessItemInfo = nil

	self.m_nTag = nil
	self.m_tData = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSynthesisRight:createElement()
	local element = WZUISystem:getInstance():createElement("WndSynthesisRight")
	assert(element, "WndSynthesisRight create element failed!")
	self:_init()
	return element
end

--@brief	合成成功后的回调
--@note     由协议层回调
function WndSynthesisRight:synthesisSuccess()
	if self.m_root == nil then return end
    WZLog("WndSynthesisRight:synthesisSuccess")
    --self.m_tSuccessItemInfo = nil
    --if self.m_tResultItem then
    --    self.m_tSuccessItemInfo = {}
    --    self.m_tSuccessItemInfo.id = self.m_tResultItem:getData().id
    --    self.m_tSuccessItemInfo.count = self.m_tResultItem:getData().lastNum
    --end
    --self:_showSuccessAnimation()
end

--@brief	更新玩家物品数据
--@note		从CacheCenter更新玩家数据
function WndSynthesisRight:updatePlayerItemData()
	WZLog("WndSynthesisRight:updatePlayerItemData")
	if WndBag.m_bOpenStrengthen == true then return end
	if self.m_root == nil then return end


	self:updateRightList()


	WZLog("上次合成的物品tag",WndSynthesisLeft.m_nTag)
	if WndSynthesisLeft.m_tData ~= nil then
		WZLog("上次合成的物品名字",WndSynthesisLeft.m_tData.basicInfo.name)
	end
	if WndSynthesisLeft.m_nTag ~= nil and WndSynthesisLeft.m_tData ~= nil then
		WndSynthesisLeft:_putItem(WndSynthesisLeft.m_nTag, WndSynthesisLeft.m_tData, nil, false, true)
	end
end

--@brief	更新右侧界面
function WndSynthesisRight:updateRightList()
	WZLog("WndSynthesisRight:updateRightList")

    if CacheCenter:hasPlayerItems() ~= true then return end

	if self.m_nSelectedIndex == 1 then
        self.m_tEquipDataList = CacheCenter:getEquipChipList()
    	self:_updateEquipList()
	elseif self.m_nSelectedIndex == 2 then
        self.m_tDressDataList = CacheCenter:getDecorationChipList()
    	self:_updateDressList()
	elseif self.m_nSelectedIndex == 3 then
        self.m_tGemDataList = CacheCenter:getSyntheticGemList()
		table.sort(self.m_tGemDataList, sortGem1)
    	self:_updateGemList()
	elseif self.m_nSelectedIndex == 4 then
        self.m_tItemDataList = CacheCenter:getSyntheticMaterialList()
		table.sort(self.m_tItemDataList, sortGem)
    	self:_updateItemList()
	elseif self.m_nSelectedIndex == 5 then
        self.m_tSkinDataList = CacheCenter:getSyntheticSkinList()
		table.sort(self.m_tSkinDataList, sortGem1)
    	self:_updateSkinList()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新皮肤列表界面
function WndSynthesisRight:_updateSkinList()
    if self.m_tSkinDataList == nil then
        return
    end
    self.m_tSkinObjList = {}
    local tbconItem = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
    self:_updateList(tbconItem, self.m_tSkinDataList, function(nTag, tItem)
        local tData = self.m_tSkinDataList[nTag+1]
        if tData then
            tItem:setCellGoodItem(tData, 10)
        end
        table.insert(self.m_tSkinObjList, nTag+1, tItem)
    end)
end

--@brief    更新宝石列表界面
function WndSynthesisRight:_updateGemList()
    if self.m_tGemDataList == nil then
        return
    end
    self.m_tGemObjList = {}
    local tbconItem = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
    self:_updateList(tbconItem, self.m_tGemDataList, function(nTag, tItem)
        local tData = self.m_tGemDataList[nTag+1]
        if tData then
            tItem:setCellGoodItem(tData, 10)
        end
        table.insert(self.m_tGemObjList, nTag+1, tItem)
    end)
end

--@brief    更新道具列表界面
function WndSynthesisRight:_updateItemList()
    if self.m_tItemDataList == nil then
        return
    end
    self.m_tItemObjList = {}
    local tbconItem = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
    self:_updateList(tbconItem, self.m_tItemDataList, function(nTag, tItem)
        local tData = self.m_tItemDataList[nTag+1]
        if tData then
            tItem:setCellGoodItem(tData, 10)
        end
        table.insert(self.m_tItemObjList, nTag+1, tItem)
    end)
end

--@brief    更新装备列表界面
function WndSynthesisRight:_updateEquipList()
    if self.m_tEquipDataList == nil then
        return
    end
    self.m_tEquipObjList = {}
    local tbconEquip = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
    self:_updateList(tbconEquip, self.m_tEquipDataList, function(nTag, tItem)
        local tData = self.m_tEquipDataList[nTag+1]
        if tData then
            tItem:setCellGoodItem(tData, 10)
        end
        table.insert(self.m_tEquipObjList, nTag+1, tItem)
    end)
end

--@brief    更新时装列表界面
function WndSynthesisRight:_updateDressList()
    if self.m_tDressDataList == nil then
        return
    end
    self.m_tDressObjList = {}
    local tbconDress = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
    self:_updateList(tbconDress, self.m_tDressDataList, function(nTag, tItem)
        local tData = self.m_tDressDataList[nTag+1]
        if tData then
            tItem:setCellGoodItem(tData, 10)
        end
        table.insert(self.m_tDressObjList, nTag+1, tItem)
    end)
end

--@brief    创建一个物品格子
--@param    nTag，序号
--@param    tData，物品数据表
function WndSynthesisRight:_createCellGoodItem(nTag, fSetCellData)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nTag)
    tItem:setFromTag(nTag)
    if fSetCellData then
        fSetCellData(nTag, tItem)
    end
    return eItem, tItem
end

--@brief    更新列表
--@param    tbcon，WZUITableContainer元素节点
--@param    tDataList， 数据表
--@param    fSetCellData，设置单元格数据回调方法
function WndSynthesisRight:_updateList(tbcon, tDataList, fSetCellData)
    local tbconList = GetElement(self.m_root, "tableCon_WndSynthesisRight", WZUITableContainer)
    local nCurPositionY = tbconList:getMoveElement():getPositionY()
    local tLastSize = tbconList:getMoveElement():getContentSize()

    local nMinCellCount = 20
    tbcon:cleanTable()
    for i=1, math.max(#tDataList, nMinCellCount) do
        local eItem, tItem = self:_createCellGoodItem(i-1, fSetCellData)
        --eItem:setScale(0.9)
        tbcon:setCellElement(eItem)
        if i > #tDataList then
            eItem:setTouchEnable(false)
        end
        tItem:setItemClickFun(self, self.onClickListItem)
    end

    --重新设置列表的位置
    local tCurSize = tbconList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tbconList:getMaxPosition().y then
        nTempPositionY = tbconList:getMaxPosition().y
    end
    tbconList:getMoveElement():setPositionY(nTempPositionY)
end

function WndSynthesisRight:autoPutItem() 
    local tListArray = {self.m_tEquipDataList, self.m_tDressDataList, self.m_tGemDataList, self.m_tItemDataList, self.m_tSkinDataList}
    local tDataList = tListArray[self.m_nSelectedIndex]
	for i=1,#tDataList do
		if WndBag.synId == tDataList[i].basicInfo.id then
			self.m_nTag = i-1
			self.m_tData = tDataList[i]
			WndSynthesisLeft:_putItem(i-1,tDataList[i])
		end
	end
end

--@brief    根据序号获取物品绑定的lua对象
--@param    nTag:序号
--@return   #1:物品绑定的lua对象
function WndSynthesisRight:_getItemByTag(nTag)
	WZLog("WndSynthesisRight:_getItemByTag",nTag,self.m_nSelectedIndex)
    if nTag == nil then
        return
    end
    local tListArray = {self.m_tEquipObjList, self.m_tDressObjList, self.m_tGemObjList, self.m_tItemObjList, self.m_tSkinObjList}
    local tList = tListArray[self.m_nSelectedIndex]
    if tList then
        return tList[nTag+1]
    end
end

--@brief	根据playerItemId获得物品数据表
--@param	playerItemId:物品的playerItemId
function WndSynthesisRight:_getItemByPlayerItemId(playerItemId)
	WZLog("WndSynthesisRight:_getItemByPlayerItemId")
	if playerItemId == nil then return end

    local tListArray = {self.m_tEquipDataList, self.m_tDressDataList, self.m_tGemDataList, self.m_tItemDataList, self.m_tSkinDataList}
    local tList = tListArray[self.m_nSelectedIndex]
	for i=1,#tList do
		if tList[i].playerItemId == playerItemId then
			return tList[i]
		end
	end
end
-------------------------------------私有方法模块End----------------------------------------
