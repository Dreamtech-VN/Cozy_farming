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
	local conSubWin = GetElement(WndBagMain.m_root, "conSubWin", WZUIContainer)
	if conSubWin then
		local wndBlessBag = WndBlessBag:createElement()
	    if wndBlessBag then 
	        conSubWin:addChild(wndBlessBag)
	    end
	end
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
