--WndCardData.lua
--@brief	WndCard的数据模块
--@date		2016/07/25
--@author	Tianxiang_Xu
--@note		卡牌系统

WndCard = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCard:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nTabIndex = nil
    self.m_nTime = nil 
    self.m_nLeftListIndex = nil         --卡牌选项卡索引
    self.m_nCollectCardNum = 0        --已收集的卡牌数量
    self.m_nUnCollectCardNum = 0        --未收集的卡牌数量
    self.m_nListTag = 0
    self.m_tActiveCardList = nil        --已经激活的卡
    self.m_tUnActiveCardList = nil      --未激活的卡
    self.m_tCardBoxList = nil           --卡套列表
    self.m_nLeftOpenTimes = nil         --当天剩余打开次数
    self.m_nTotalOpenTimes = nil        --一共可以打开次数
    self.m_topCellLua = nil 
    self.m_tAllCardList = nil           --物品表中所有的卡牌
    self.m_tClickCell = nil             --点击的Cell的表结构
    self.m_nLoadingId = nil 
    self.m_nOperateType = 0             --操作状态值99：凌晨商店刷新；0：进入界面；1：升级；2：点击卡套标签；3：点击商店标签；4：购买卡牌; 5:点击卡魂标签
    self.m_nServerTime = nil            --进入界面获取服务器的时间
    self.m_nCaculateTime = 0          --用于计时
    self.m_tAllCardCell = nil           --所有卡牌的cell
    self.m_tCardDataSel = nil           --选中的卡牌的数据
    self.m_tGetCardResult = nil         --获得卡牌的时候是否弹数量增加提示语
    self.m_tCDTimePrice = nil           --cd时间的价格
    self.m_bUpgradeSuccess = false 
    self.m_index = -1
    self.m_AllCardBox = {}
    self.m_cardNum = nil

    self.m_nCardSoulId = 161020         --卡魂碎片id
    self.m_nCardSoulStartIndex = 1      --加载卡魂时的索引
    self.m_tCardSoulData = {}           --卡魂数据
    self.m_tCardSoulObj = {}            --卡魂对象
    self.m_nSelectCardNum = 1           --卡魂界面选中卡牌数量
    self.m_nSelectCardIndex = 1         --卡魂界面选中卡牌索引
    self.m_nCardSoulBuffTime = 0        --卡魂瞻仰buf剩余秒数
end
 
 
--@brief	反初始化表的成员变量 
--@note		在退出场景时回调的onExit函数里面必须调用本函数 
function WndCard:_unInit() 
	self.m_root = nil 
    self.m_nTabIndex = nil 
    self.m_nTime = nil  
    self.m_nLeftListIndex = nil         --卡牌选项卡索引 
    self.m_nCollectCardNum = 0        --已收集的卡牌数量 
    self.m_nUnCollectCardNum = 0      --未收集的卡牌数量 
    self.m_nListTag = nil  
    self.m_tActiveCardList = nil        --已经激活的卡 
    self.m_tUnActiveCardList = nil      --未激活的卡 
    self.m_tCardBoxList = nil           -- 
    self.m_nLeftOpenTimes = nil         --当天剩余打开次数 
    self.m_nTotalOpenTimes = nil        --一共可以打开次数 
    self.m_topCellLua = nil  
    self.m_tAllCardList = nil           --物品表中所有的卡牌 
    self.m_tClickCell = nil             --点击的Cell的表结构 
    self.m_nLoadingId = nil  
    self.m_nOperateType = nil             --操作状态值 
    self.m_nServerTime = nil            --进入界面获取服务器的时间 
    self.m_nCaculateTime = nil  
    self.m_tAllCardCell = nil           --所有卡牌的cell 
    self.m_tCardDataSel = nil           --选中的卡牌的数据 
    self.m_tGetCardResult = nil      --获得卡牌的时候是否弹数量增加提示语 
    self.m_tCDTimePrice = nil           --cd时间的价格 
    self.m_bUpgradeSuccess = nil  
    self.m_index = nil  
    self.m_AllCardBox = nil 
    self.m_cardNum = nil 
 
    self.m_nCardSoulId = nil            --卡魂碎片id
    self.m_nCardSoulStartIndex = nil    --加载卡魂时的索引
    self.m_tCardSoulData = nil          --卡魂数据 
    self.m_tCardSoulObj = nil           --卡魂对象 
    self.m_nSelectCardNum = nil         --卡魂界面选中卡牌数量
    self.m_nSelectCardIndex = nil       --卡魂界面选中卡牌索引
    self.m_nCardSoulBuffTime = nil      --卡魂瞻仰buf剩余秒数
end 
 
 
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCard:createElement()
	local element = WZUISystem:getInstance():createElement("WndCard")
	assert(element, "WndCard create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
--@param    nTabIndex: 顶部标签索引：1->卡牌；2->卡套；3->卡魂
--@param    卡牌系统的外部接口
function WndCard:showInterface(nTabIndex)
    --body
    if self.m_root then
        self.m_root:removeFromParentAndCleanup(true)
    end

    local wndCard = WndCard:createElement()
    if wndCard then
        self.m_nTabIndex = nTabIndex
        WindowManager:addWindow(wndCard, WndCard)
    end
end

--@brief    设置数据
function WndCard:setData(itemId, level, num, lookItemId, cardSoulBuffTime)
    --卡魂倒计时
    self:updateCardSoulCountdown(cardSoulBuffTime)
    --已激活的卡牌
    WndCard:setActiveCardData(itemId, level, num, lookItemId)
    --卡魂标签
    if self.m_tCardSoulData and #self.m_tCardSoulData > 0 then
        GetElement(self.m_root,"checkbox3_WndCard",WZUICheckBox):setVisible(true)
    else
        GetElement(self.m_root,"checkbox3_WndCard",WZUICheckBox):setVisible(false)
    end
    --关闭加载动画
    self:_stopLoading()
    --加载界面
    if self.m_nTabIndex == 1 then 
        if self.m_nOperateType ~= 99 then
            if self.m_nOperateType == 1 then
                for i = 1, #self.m_tActiveCardList do
                    for k = 1, #self.m_tAllCardCell do
                        local tempData = self.m_tAllCardCell[k]:getData() 
                        if self.m_tActiveCardList[i].item_id == tempData.item_id then
                            self.m_tAllCardCell[k]:updateAfterUpgrade(self.m_tActiveCardList[i])
                            break 
                        end
                    end
                end
                --刷新升级卡牌显示的详细信息
                if self.m_tCardDataSel then
                    for i = 1, #self.m_tActiveCardList do
                        if self.m_tActiveCardList[i].item_id == self.m_tCardDataSel.item_id then
                            self:_showCardDetail(self.m_tActiveCardList[i])
                            break 
                        end
                    end
                else
                    self:_showCardDetail(self.m_tActiveCardList[1])
                end
            else
                self:_drawCard()
            end
        end
    end
end

--@brief    设置已经激活的卡的数据
function WndCard:setActiveCardData(itemId, level, num, lookItemId)
    -- body
    self.m_tActiveCardList = {}
    self.m_tCardSoulData = {}

    for i = 1, #itemId do
        local id = self:_getCardId(itemId[i], level[i])
        WZLog("WndCard:setActiveCardData", itemId[i], level[i])
        local tItem = CopyTable(GDatatab_card_property["id_" .. id])
        tItem.item_id = itemId[i]
        tItem.level = level[i]
        tItem.curNum = num[i]
        tItem.state = 1
        tItem.useType = 1 
        tItem.bIsNew = true
        --是否為新激活的
        for j = 1, #lookItemId do
            if tItem.item_id == lookItemId[j] then 
                tItem.bIsNew = false 
                break 
            end
        end

        tItem.basicInfo = CopyTable(GDatatab_item["id_" .. tItem.item_id])
        tItem.upgradeNum = tItem.cost[2][2]

        table.insert(self.m_tActiveCardList, tItem)

        --卡魂数据
        local cardSoulRatio = tonumber(CacheCenter:getGameParam().cardSoulRatio) or 40
        if level[i] >= cardSoulRatio then
            table.insert(self.m_tCardSoulData, tItem)
        end
    end
    --WZLog("WndCard:setActiveCardData", Serialize(self.m_tActiveCardList))
    table.sort(self.m_tActiveCardList, sortActiveCard)
    table.sort(self.m_tCardSoulData, sortActiveCard)
    --未激活的卡牌
    self:setUnActiveCardData()
    --已激活和未激活的卡牌数
    self.m_nCollectCardNum = #self.m_tActiveCardList
    self.m_nUnCollectCardNum = #self.m_tUnActiveCardList
end

--@brief    设置未激活的卡的数据
function WndCard:setUnActiveCardData()
    -- body
    self.m_tUnActiveCardList = {}

    for idx = 1, #self.m_tAllCardList do
        local bIsActive = false 
        for i = 1, #self.m_tActiveCardList do
            if self.m_tActiveCardList[i].item_id == self.m_tAllCardList[idx].id then
                bIsActive = true
                break
            end
        end
        if bIsActive == false then
            local id = self:_getCardId(self.m_tAllCardList[idx].id, 1)
            local tItem = CopyTable(GDatatab_card_property["id_"..id])
            tItem.item_id = self.m_tAllCardList[idx].id
            tItem.basicInfo = CopyTable(GDatatab_item["id_" .. tItem.item_id])
            tItem.curNum = 0
            tItem.upgradeNum = 1
            tItem.level = 0 
            tItem.state = 0
            tItem.useType = 1 
            tItem.bIsNew = false

            table.insert(self.m_tUnActiveCardList, tItem)
        end
    end

    table.sort(self.m_tUnActiveCardList, sortUnActiveCard)
end

--@brief    设置卡套数据
function WndCard:setCardBoxData(cardSetId, count, cdTime, openNum)
    WZLog("WndCard:setCardBoxData", Serialize(cardSetId),Serialize(count),cdTime,openNum)
    -- body
    self.m_nTime = cdTime
    self.m_nLeftOpenTimes = self.m_nTotalOpenTimes - openNum
    
    self.m_tCardBoxList = {}

    for i = 1, #cardSetId do
        if count[i] > 0 then
            local id = self:_getCardBoxId(cardSetId[i])
            local tItem = CopyTable(GDatatab_card_set["id_"..id])
            tItem.basicInfo = CopyTable(GDatatab_item["id_" .. tItem.item_id])
            tItem.number = count[i]
            if tItem.copy <= -1 then
                tItem.section = -1
            else
                tItem.section = GDatatab_single_map["id_"..tItem.copy].section
            end

            table.insert(self.m_tCardBoxList, tItem)
        end
    end

    table.sort(self.m_tCardBoxList, sortCardBox)
    self:_stopLoading()

    if self.m_nTabIndex == nil then 
        if self.m_nTime <= 0 then
            if self.m_tCardBoxList and #self.m_tCardBoxList > 0 then
                self.m_nTabIndex = 2
                self:_setContainerVisible(false, true)
                GetElement(self.m_root, "checkGroup_WndCard", WZUICheckBoxGroup):setCheckIndex(self.m_nTabIndex - 1)
            else
                self.m_nTabIndex = 1
                GetElement(self.m_root, "checkGroup_WndCard", WZUICheckBoxGroup):setCheckIndex(self.m_nTabIndex - 1)
            end
        else
            self.m_nTabIndex = 1
            GetElement(self.m_root, "checkGroup_WndCard", WZUICheckBoxGroup):setCheckIndex(self.m_nTabIndex - 1)
        end
    end

    if self.m_nOperateType == 0 then
        if self.m_nTabIndex == 1 then 
            self:_drawCard()
        end
    end

    if self.m_nTabIndex == 1 then
        self:_refreshCDTime()

        local isFinish44, finishStep44 = TeachGroup1:isTeachFinish(44)
        if isFinish44 ~= true and finishStep44 >= 0 and CacheCenter:getPlayerInfo().level == 17 then
            TeachGroup1:startGroup({44,4,self.m_root})
        end
        return
    end

    self:_initCardBox()

end

--@brief    升级成功返回
function WndCard:upgradeSuccess()
    -- body
    WZLog("WndCard:upgradeSuccess")
    self:_stopLoading()
    self.m_bUpgradeSuccess = true
    SoundManager:playEffectSound(SoundDefine.E_MUSIC_ISUPGRADE)
    --提示升级成功
    PopupResult("ui/common/common_icon_sjz.png")
end

--@brief    播放升级特效
function WndCard:playUpgradeSpine()
    -- body
    if self.m_tClickCell then
        self.m_tClickCell:playUpgradeSpine("lvlup")
    end
end

function WndCard:getCardList()
    -- body
    WZLog("WndCard:getCardList")
    if self.m_root == nil then return end
    ProtocolProcessorCard:send_CARD_GetCardMes()
end

--@brief    激活卡牌成功返回
function WndCard:activeCardSuccess(itemId)
    -- body
    WZLog("WndCard:activeCardSuccess")
    MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_TEXT21, GDatatab_item["id_" .. itemId].name))
end

--@brief    刷新卡牌数据
--@param    operateData:打开的卡套的数据
function WndCard:refreshCardDataAndInfo(itemId, itemNum, cdTime, openNum, operateData, batch, isOrange)
    -- body
    WZLog("刷新卡牌数据",openNum,cdTime)
    self.m_nTime = cdTime
    if batch == 1 then
        self.m_nLeftOpenTimes = self.m_nLeftOpenTimes - openNum + isOrange
    end
    --刷新时间
    self:_refreshCDTime()
    --剩余次数
    local txtLeftTimes = GetElement(self.m_root, "txtLeftTimes_WndCard", WZUIFreeTextBox)
    local str = string.format(LocalStrings.OPTIMIZE_TEXT2, self.m_nLeftOpenTimes, self.m_nTotalOpenTimes)
    txtLeftTimes:setShowText(str)
    --更新卡套界面相应的卡套的数量
    -- for k = 1, #self.m_tCardBoxList do
    --     if self.m_tCardBoxList[k].id == operateData.id then
    --         self.m_tCardBoxList[k].number = self.m_tCardBoxList[k].number - 1 
    --         self:resetCoarBoxList(self.m_tCardBoxList[k])
    --         if self.m_tCardBoxList[k].number == 0 then
    --             table.remove(self.m_tCardBoxList, k)
    --             table.remove(self.m_AllCardBox, k)
    --             if self.m_tCardBoxList and next(self.m_tCardBoxList) then
    --                 self:onClickCardBox(self.m_AllCardBox[1],0,self.m_tCardBoxList[1])
    --             end               
    --         end
    --         break
    --     end
    -- end
    for k = #self.m_tCardBoxList,1,-1 do
        if self.m_tCardBoxList[k].id == operateData.id then

            self.m_tCardBoxList[k].number = self.m_tCardBoxList[k].number - openNum

            self:resetCoarBoxList(self.m_tCardBoxList[k])
            if self.m_tCardBoxList[k].number <= 0 then
                table.remove(self.m_tCardBoxList, k)
                table.remove(self.m_AllCardBox, k)
                if self.m_tCardBoxList and next(self.m_tCardBoxList) then
                    self.m_index = -1
                    self:onClickCardBox(self.m_AllCardBox[1],0,self.m_tCardBoxList[1])
                end               
            end
            break
        end
    end

    --判断卡套列表是否为空
    local conCardBox = GetElement(self.m_root, "conCardBox_WndCard", WZUIContainer)
    local conBox = GetElement(self.m_root,"conBox_WndCard",WZUIContainer)
    if self.m_tCardBoxList == nil or #self.m_tCardBoxList == 0 then
        ShowPanelNullTip(conCardBox, LocalStrings.CARD_TEXT33, GlobalMethod:ccc3(255,236,193),nil,nil,ccp(0.35,0.5))
        -- ShowPanelNullTip(conBox, LocalStrings.CARD_TEXT33, GlobalMethod:ccc3(255,236,193))
        conBox:removeAllChildrenWithCleanup(true)
        return
    end
end

--@brief    开启卡套后，刷新卡套数据
function WndCard:resetCoarBoxList(operateData)
    -- body
    local tbBoxList = GetElement(self.m_root, "tbBoxList_WndCard", WZUITableContainer)

    local nTag = 0 
    local celElement = tbBoxList:getCellElement(nTag)
    while celElement do
        celElement = WZUIContainer:luaTo(celElement)
        local cellItem = celElement:getChildElement("__CellCardBoxItem")
--        WZLog("555555555555", type(cellItem))
        local cellObj = WZUIContainer:luaTo(cellItem):getLuaObjectIndex()
        if cellObj then
            local id = cellObj:getCardBoxId()
            if id == operateData.id then
                if operateData.number == 0 then
                    tbBoxList:removeCellElementByReset(nTag)
                else
                    cellObj:setNumber(operateData.number)
                end
                break 
            end
        end
        nTag = nTag + 1
        celElement = tbBoxList:getCellElement(nTag)
    end

end

--@brief    激活的卡牌的排序函数
function sortActiveCard(a, b)
    -- body
    if a.basicInfo.quality ~= b.basicInfo.quality then
        return a.basicInfo.quality > b.basicInfo.quality
    else
        return a.item_id > b.item_id
    end
end

--@brief    未激活的卡牌的排序函数
function sortUnActiveCard(a, b)
    -- body
    if a.basicInfo.quality ~= b.basicInfo.quality then
        return a.basicInfo.quality < b.basicInfo.quality
    else
        return a.item_id < b.item_id
    end
end

--@brief    卡套的排序函数
function sortCardBox(a, b)
    -- body
    if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
        return a.basicInfo.sub_type > b.basicInfo.sub_type
    elseif a.basicInfo.quality ~= b.basicInfo.quality then
        return a.basicInfo.quality > b.basicInfo.quality
    else
        return a.copy < b.copy
    end
end

--@brief    加速成功
function WndCard:speedUpOK(result, cdTime)
    -- body
    WZLog("WndCard:speedUpOK", result, cdTime)
    if result ~= 0 then 
        MsgBoxManager:showTipBox(LocalStrings.TOPGOLD_TEXT4)
        self.m_nTime = cdTime
        --刷新时间
        self:_refreshCDTime()
        if WndOpenCardBox.m_root then 
            WndOpenCardBox:speedUpOk(cdTime)
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    获取当前类型的卡牌最高等级
function WndCard:_getMaxLevel(itemId)
    -- body
    local nLevel = 0

    local basicInfo = GDatatab_item["id_" .. itemId]
    for i, value in pairs(GDatatab_card_property) do
        if value.level > nLevel and basicInfo.value == value.type then
            nLevel = value.level
        end
    end

    return nLevel
end

--@brief    获取相应卡牌的下一级数据
function WndCard:_getNextData(itemId, curLevel)
    -- body
    local basicInfo = GDatatab_item["id_" .. itemId]
    for i, value in pairs(GDatatab_card_property) do
        if value.level == curLevel + 1 and basicInfo.value == value.type then
            return value
        end
    end

    return nil 
end

--@brief    根据属性表，计算战力
--@param    tProperty:属性表
function WndCard:_caculateFighting(tProperty)
    -- body
    if tProperty == nil or #tProperty == 0 then return 0 end

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


--@brief    返回物品道具表中所有的卡牌
function WndCard:_getAllCards()
    -- body
    if self.m_tAllCardList == nil then
        self.m_tAllCardList = {}
    end

    for idx, value in pairs(GDatatab_item) do
        if value.main_type == 8 then
            table.insert(self.m_tAllCardList, value)
        end
    end
end

--@brief    数据加载动画
function WndCard:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndCard:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief    计算当前购买所需加个
--@param    startPrice:初始的价格
--@param    number:剩余的购买次数
--@param    step:价格步长
--@param    buyType:1->购买一张；2->购买全部
--@param    count:总购买次数
--@param    maxPrice:单次购买最高价格
function WndCard:_getPrice(startPrice, number, step, buyType, count, maxPrice)
    -- body
    local price = 0
    if buyType == 1 then
        price = startPrice + (count - number) * step
        if price > maxPrice then
            price = maxPrice
        end
    else
        local tempPrice
        for i = 1, number do
            if i == 1 then
                tempPrice = startPrice + (count - number) * step
            else 
                tempPrice = tempPrice + step 
            end

            if tempPrice > maxPrice then
                tempPrice = maxPrice
            end
            price = price + tempPrice
        end
    end
    WZLog("WndCard:_getPrice", price)
    return price 
end

--@brief    根据item_id 和等级获取卡牌id
function WndCard:_getCardId(itemId, level)
    -- body
    local basicInfo = GDatatab_item["id_" .. itemId]
    for idx, value in pairs(GDatatab_card_property) do
        if value.level == level and basicInfo.value == value.type then
            return value.id
        end
    end

    return nil 
end

--@brief    根据item_id获取卡套id
function WndCard:_getCardBoxId(itemId)
    -- body
    for idx, value in pairs(GDatatab_card_set) do
        if value.item_id == itemId then
            return value.id
        end
    end

    return nil 
end

--@brief    根据item_id获取商品卡牌id
function WndCard:_getShopCardId(itemId)
    -- body
    for idx, value in pairs(GDatatab_card_shop) do
        if value.item_id == itemId then
            return value.id
        end
    end

    return nil 
end

--@brief    判断是否新激活的卡牌还是只是数量增加
function WndCard:_judgeNewCard(tData)
    -- body
    local bIsShowNumTips = true 

    for i = 1, #self.m_tUnActiveCardList do
        if self.m_tUnActiveCardList[i].item_id == tData.item_id then
            bIsShowNumTips = false
            break
        end
    end

    return bIsShowNumTips 
end

--@brief    判断是否有卡包
function WndCard:_judgeHaveCardBag()
    -- body
    if self.m_tCardBoxList == nil or #self.m_tCardBoxList == 0 then 
        return false
    end

    local bHaveCardBag = false 
    for i = 1, #self.m_tCardBoxList do
        if self.m_tCardBoxList[i].basicInfo.sub_type == 1 then
            bHaveCardBag = true
            break 
        end
    end

    return bHaveCardBag
end

--@brief    兑换卡魂协议回调
function WndCard:exchangeCardSoulOk(result, cardSetId, changeNum, cardSoulNum)
    if result == 0 then
        MsgBoxManager:showTipBox(LocalStrings.AUCTION_HOUSE_TEXT35)
    elseif result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT50)
        return
    end

    for i=1,#self.m_tActiveCardList do
        if self.m_tActiveCardList[i].item_id == cardSetId then
            self.m_tActiveCardList[i].curNum = self.m_tActiveCardList[i].curNum - changeNum
        end
    end
    self:_drawCardSoul()
    WndRewardShow:showById({self.m_nCardSoulId}, {cardSoulNum})

end

--@brief    瞻仰卡魂协议回调
function WndCard:revereCardSoulOk(buffTime, result)
    if result == 0 then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT48)
    elseif result == 1 then
        MsgBoxManager:showTipBox(LocalStrings.CARD_TEXT49)
    end
    WndCard:getCardList()
end

-------------------------------------私有方法模块End----------------------------------------
