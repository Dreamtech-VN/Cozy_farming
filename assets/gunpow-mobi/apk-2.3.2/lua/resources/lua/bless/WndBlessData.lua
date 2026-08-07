--WndBlessData.lua
--@brief	WndBless的数据模块
--@date		2016/03/25
--@author	Tianxiang_Xu
--@note		祈福屋界面

WndBless = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndBless:_init()
	self.m_root = nil  			--Cell的根节点
    self.m_tBlessedMenData = nil -- 祈福师数据
    self.m_tBlessHallList = nil     --祈福屋中的祝福列表
    self.m_tBlessBagList = nil      --祈福背包祝福列表
    self.m_tEquipList = nil         --祈福栏中的数据
    self.m_nLoadingIndex = nil  --异步加载索引
    self.m_nLoadingId = nil        --loadingId
    self.m_nBlessFighting = nil     -- 祈福战力
    self.m_nBlessMenId = nil        --当前激活的祈福师Id(0,...,5)
    self.m_nSummonNum = nil         --当天召唤次数
    self.m_nMaxBlessNum = 18        --祈福屋容量
    self.m_bIsFlyIn     = false     --是否从祈福师处飞进
    self.m_tNewBlessMenId = nil     --新的祈福师Id
    self.m_nNewBlessMenIndex = nil  --新祈福师索引
    self.m_tPickUpList = nil        --拾取的祝福的数据
    self.m_nPickUpIndex = nil       --拾取索引
    self.m_tSellOutList = nil        --拾取的祝福的数据
    self.m_nSellOutIndex = nil       --拾取索引
    self.m_goldNode = nil           --顶部金币栏的节点
    self.m_nCreateActionNum = 0         --创建动画的数目
    self.m_topCellLua = nil
    self.m_nPickupEffectId = nil        --拾取音效ID
	self.m_nTotal = nil

    self.m_nTime = nil                  --距离下次免费抽奖时间（秒）
    self.m_tDisplayBless = nil          --祈福成功获得的祈福
    self.m_nCurDrawType = nil           --当前抽奖类型
    self.m_nAutoDevourAll = nil         --自动吞噬 0否 1是
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBless:_unInit()
	self.m_root = nil
    self.m_tBlessedMenData = nil -- 祈福师数据
    self.m_tBlessHallList = nil     --祈福屋中的祝福列表
    self.m_tBlessBagList = nil      --祈福背包祝福列表
    self.m_tEquipList = nil         --祈福栏中的数据
    self.m_nLoadingIndex = nil  --异步加载索引
    self.m_nLoadingId = nil        --loadingId
    self.m_nBlessFighting = nil     -- 祈福战力
    self.m_nBlessMenId = nil        --当前激活的祈福师Id(0,...,5)
    self.m_nSummonNum = nil         --当天召唤次数
    self.m_nMaxBlessNum = nil        --祈福屋容量
    self.m_tNewBlessMenId = nil     --新的祈福师Id
    self.m_bIsFlyIn     = nil       --是否从祈福师处飞进
    self.m_nNewBlessMenIndex = nil  --新祈福师索引
    self.m_tPickUpList = nil        --拾取的祝福的数据
    self.m_nPickUpIndex = nil       --拾取索引
    self.m_tSellOutList = nil        --拾取的祝福的数据
    self.m_nSellOutIndex = nil       --拾取索引
    self.m_goldNode = nil           --顶部金币栏的节点
    self.m_nCreateActionNum = nil   
    self.m_topCellLua = nil
    self.m_nPickupEffectId = nil
	self.m_nTotal = nil

    self.m_nTime = nil                 --距离下次免费抽奖时间（秒）
    self.m_tDisplayBless = nil         --祈福成功获得的祈福
    self.m_nCurDrawType = nil          --当前抽奖类型
    self.m_nAutoDevourAll = nil         --自动吞噬 0否 1是
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndBless:createElement()
	local element = WZUISystem:getInstance():createElement("WndBless")
	assert(element, "WndBless element create failed!")
	self:_init()
	return element
end

-- function WndBless:setData(debris, blessMenId, summonNum, bagIds, bagExps, bagPrayIds, roomIds, roomExps, roomPrayIds, prayNum, equipPrayId, equipId, equipExp, blessFighting, equipRectId, openlevel)
--     -- body
--     self.m_nBlessMenId = blessMenId         --当前激活的祈福师Id
--     self.m_nSummonNum = summonNum           --当天已经召唤的次数
--     self.m_nBlessFighting = blessFighting   --当前祈福战力
--     WZLog("WndBless:setData", self.m_nBlessMenId, self.m_nSummonNum, self.m_nBlessFighting)
--     --背包中的祝福
--     local tBagList = {}
--     for i = 0, bagIds:size() - 1 do
--         local tTemp = {}
--         tTemp.id = bagPrayIds:get(i)
--         tTemp.blessId = bagIds:get(i)
--         tTemp.curExp = bagExps:get(i)

--         table.insert(tBagList, tTemp)
--     end
--     WndBless:setBlessBagList(2, tBagList)
--     --祈福屋中的祝福
--     local tBlessHallList = {}
--     for j = 0, roomIds:size() - 1 do
--         local tTemp = {}
--         tTemp.id = roomPrayIds:get(j)
--         tTemp.blessId = roomIds:get(j)
--         tTemp.curExp = roomExps:get(j)

--         table.insert(tBlessHallList, tTemp)
--     end
--     --装备栏的数据
--     if self.m_tEquipList == nil then
--         self.m_tEquipList = {}
--     end
--     WZLog("WndBless:setData 111",equipRectId:size(), openlevel:size(), prayNum:size())
--     for k = 0, equipRectId:size() - 1 do
--         local tTemp = {}
--         tTemp.openLevel = openlevel:get(k)
--         --判断该装备栏是否开启
--         if tTemp.openLevel <= CacheCenter:getPlayerInfo().level then
--             tTemp.status = 0
--         else
--             tTemp.status = -1
--         end
--         for l = 0, prayNum:size() - 1 do 
--             local id = equipPrayId:get(l)
--             local tData = CopyTable(GDatatab_pray["id_"..id])
--             tData.basicInfo = CopyTable(GDatatab_item["id_"..tData.item_id])
--             tData.userType = 3
--             tData.curExp = equipExp:get(l)
--             tData.blessId = equipId:get(l)
-- 			tData.name = tData.basicInfo.name
--             if equipRectId:get(k) == prayNum:get(l) then
--                 tTemp.status = 1
--                 tTemp.tData = tData
--             end
--         end

--         table.insert(self.m_tEquipList, tTemp)
--     end

--     self:_stopLoading()
--     WZLog("WndBless:setData ****", Serialize(self.m_tEquipList), equipRectId:size())

--     --祈福师
--     WndBless:setBlessedMenData(self.m_nBlessMenId)
--     --祈福屋中的祝福
--     WndBless:setBlessData( 1, tBlessHallList)
--     --召唤师红点
--     self:_setBlessMenRedDot()
-- end

function WndBless:setData(time, bagIds, bagExps, bagPrayIds, prayNum, equipPrayId, equipId, equipExp, fightNum, num, openlevel)
    self:_stopLoading()

    self.m_nBlessFighting = fightNum   --当前祈福战力
    self.m_nTime = time

    self:_showFreeTime()

    -- --背包中的祝福
    -- local tBagList = {}
    -- for i = 0, bagIds:size() - 1 do
    --     local tTemp = {}
    --     tTemp.id = bagPrayIds:get(i)
    --     tTemp.blessId = bagIds:get(i)
    --     tTemp.curExp = bagExps:get(i)

    --     table.insert(tBagList, tTemp)
    -- end
    -- WndBless:setBlessBagList(2, tBagList)
    -- -- --祈福屋中的祝福
    -- -- local tBlessHallList = {}
    -- -- for j = 0, roomIds:size() - 1 do
    -- --     local tTemp = {}
    -- --     tTemp.id = roomPrayIds:get(j)
    -- --     tTemp.blessId = roomIds:get(j)
    -- --     tTemp.curExp = roomExps:get(j)

    -- --     table.insert(tBlessHallList, tTemp)
    -- -- end
    -- --装备栏的数据
    -- if self.m_tEquipList == nil then
    --     self.m_tEquipList = {}
    -- end

    -- local equipRectId = num
    -- WZLog("WndBless:setData 111",equipRectId:size(), openlevel:size(), prayNum:size())
    -- for k = 0, equipRectId:size() - 1 do
    --     local tTemp = {}
    --     tTemp.openLevel = openlevel:get(k)
    --     --判断该装备栏是否开启
    --     if tTemp.openLevel <= CacheCenter:getPlayerInfo().level then
    --         tTemp.status = 0
    --     else
    --         tTemp.status = -1
    --     end
    --     for l = 0, prayNum:size() - 1 do 
    --         local id = equipPrayId:get(l)
    --         local tData = CopyTable(GDatatab_pray["id_"..id])
    --         tData.basicInfo = CopyTable(GDatatab_item["id_"..tData.item_id])
    --         tData.userType = 3
    --         tData.curExp = equipExp:get(l)
    --         tData.blessId = equipId:get(l)
    --         tData.name = tData.basicInfo.name
    --         if equipRectId:get(k) == prayNum:get(l) then
    --             tTemp.status = 1
    --             tTemp.tData = tData
    --         end
    --     end

    --     table.insert(self.m_tEquipList, tTemp)
    -- end

    -- self:_stopLoading()
    -- WZLog("WndBless:setData ****", Serialize(self.m_tEquipList), equipRectId:size())

    -- --祈福师
    -- WndBless:setBlessedMenData(self.m_nBlessMenId)
    -- --祈福屋中的祝福
    -- WndBless:setBlessData( 1, tBlessHallList)
    -- --召唤师红点
    -- self:_setBlessMenRedDot()
end

--@brief    设置祈福师数据
--@param    nIndex:当前激活的祈福师索引
function WndBless:setBlessedMenData(nIndex, ... )
    -- body
    if self.m_tBlessedMenData == nil then
        self.m_tBlessedMenData = {}
    end

    for i, value in pairs(GDatatab_pray_button) do
        if value.id == nIndex or (value.id == 3 and nIndex == 5) then
            value.active = true
        else
            value.active = false
        end
        table.insert(self.m_tBlessedMenData, value)
    end
    table.sort(self.m_tBlessedMenData, function (a, b) return a.id < b.id end)

    self:_addBlessedMen()
end

--@brief     设置祝福数据
--@param     userType : 用户定义的类型：1：在祈福屋；...
--@param     tDataList:服务器传过来的数据
function WndBless:setBlessData( userType, tDataList, ... )
    -- body
    if self.m_tBlessHallList == nil then
        self.m_tBlessHallList = {}
    end

    for i = 1, #tDataList do
        local tTemp = CopyTable(GDatatab_pray["id_"..tDataList[i].id])
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id]) 
        tTemp.userType = userType
        tTemp.blessId = tDataList[i].blessId
        tTemp.curExp = tDataList[i].curExp
		tTemp.name = tTemp.basicInfo.name
        if tTemp then
            table.insert(self.m_tBlessHallList, tTemp)
        end
    end

    WZLog("WndBless:setBlessData", Serialize(self.m_tBlessHallList))

    self.m_nLoadingIndex = 0

    local conBlessList = GetElement(self.m_root, "tableconBlessList_WndBless", WZUITableContainer)
    conBlessList:enableSchedule("onShowBless")
end

--@brief    设置背包祈福数据
--@param    userType :用户定义的类型：2：在背包
--@param    tDataList:服务器传过来的数据
function WndBless:setBlessBagList(userType, tDataList)
    -- body
    if self.m_tBlessBagList == nil then
        self.m_tBlessBagList = {}
    end

    for i = 1, #tDataList do
        local tTemp = CopyTable(GDatatab_pray["id_"..tDataList[i].id])
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id])
        tTemp.userType = userType
        tTemp.blessId = tDataList[i].blessId
        tTemp.curExp = tDataList[i].curExp
		tTemp.name = tTemp.basicInfo.name
        if tTemp then
            table.insert(self.m_tBlessBagList, tTemp)
        end
    end

    WZLog("WndBless:setBlessBagList", Serialize(self.m_tBlessBagList))
end

--@brief    跨天重置召唤次数
--@param    nSummonNum : 召唤次数
function WndBless:resetSummonNum(nSummonNum)
    -- body
    if self.m_root then
        self.m_nSummonNum = nSummonNum
        self:_setBlessMenRedDot()
    end
end

--@brief    重新设置战力
function WndBless:resetFighting(nFighting)
    -- body
    self.m_nBlessFighting = nFighting
end

--@brief    祈福外部接口
function WndBless:showInterface()
    -- body
    -- if self.m_root then
    --     WindowManager:removeWindow(self.m_root, self, true)
    -- end
    if CheckButtonOpen(BLESS_LUCKY_DRAW) then
        -- local wndBless = WndBless:createElement()
        -- if wndBless ~= nil then
        --     WindowManager:addWindow(wndBless,WndBless)
        --     return
        -- end
        WndSummonEntrance:showInterface(3)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置召唤的祈福师红点消失
function WndBless:_setBlessMenRedDot()
    -- body
    local imgRedDot = GetElement(self.m_root, "imgRedDot_WndBless", WZUIImage)
    if self.m_nSummonNum > 0 then
        imgRedDot:setVisible(false)
    else
        imgRedDot:setVisible(true)
    end
end


-------------------------------------私有方法模块End----------------------------------------
