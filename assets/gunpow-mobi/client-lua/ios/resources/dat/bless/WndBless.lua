--WndBless.lua
--@brief	WndBless的UI模块
--@date		2016/03/25
--@author	Tianxiang_Xu
--@note		祈福屋界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBless:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    ProtocolProcessorBless:regAll()

    local isEndTeach, teachStep = TeachGroup1:isTeachFinish(42)

    if isEndTeach ~= true then
        TeachGroup1:startGroup({42,4,self.m_root})
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBless:onExit(element)
    if WndBlessBag.m_root == nil then
        ProtocolProcessorBless:unregAll()
    end
	self:_unInit()
end

function WndBless:onEnterTransitionDidFinish(element)
    -- body
    ChangeChatChannel(Chat_Channel_Bless)
    self.m_nMaxBlessNum = tonumber(CacheCenter:getGameParam()["prayRoomSize"]) or 18 
    local llll = tonumber(CacheCenter:getGameParam()["prayRoomSize"])
    WZLog("****** WndBless:onEnterTransitionDidFinish ******", llll)
    self.m_nBlessCoinNum = CacheCenter:getMoneyList().bless
    --iphoneX适配
    if IsIphoneX() then
        GetElement(self.m_root, "conRight", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.95,1))
    end
    --添加钻石金币栏
    self:_addTop()
    --发送协议，获取数据
    self:_createLoading()
    g_blessDataGetIndex = 1
    ProtocolProcessorBless:send_PRAY_GetPrayMess() 
    self:setFyberTime() 
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndBless:setFyberTime()
    if NeedFyber(3) then    
        local conFyber = self.m_root:getChildElement("conFyber_WndBless")
        conFyber:setVisible(true)
        GetElement(self.m_root,"txtFyber_WndBless",WZUILabelTTF):setText(LocalStrings.ATH_REWARD_CHECK)
    end 
end

function WndBless:onFunctionClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    DoFyberReward(3)
end

--@brief    觸摸開始
function WndBless:onTouchBegan(element, pt)
    -- body
    if WndTips.m_root ~= nil and not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end

    if WndItemInfo.m_root then
        WndItemInfo:onCloseClick()
    end

    if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

--@brief    关闭界面按钮点击相应
function WndBless:onCloseClick(element)
    -- body
    --播放点击音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    -- if self.m_nPickupEffectId then
    --     SoundManager:stopEffectSound(self.m_nPickupEffectId)
    --     self.m_nPickupEffectId = nil 
    -- end
    if WndBlessBag.m_root and WndBagMain.m_root then
        WndBlessBag:setBlessItemList( self.m_nBlessFighting, self.m_tBlessBagList, self.m_tEquipList)
    end

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击规则按钮
function WndBless:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.BLESS_RULE)    
end

--@brief    点击祈福一次按钮回调
function WndBless:onClickBlessOnce(element)
    -- body
    --播放音效
    WZLog("WndBless:onClickBlessOnce")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local quickPray = GetElement(WndBless.m_root,"quickPray",WZUICheckBox)
    if quickPray:getCheckIndex() == 1 then
		WndBless:onClickBlessQuick(element)
		return
    end

    if #self.m_tBlessHallList >= self.m_nMaxBlessNum then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_HOUSE_FULL)
        return
    end
    --祈福勋章不足时
    if CacheCenter:getMoneyList().blessMedal < self.m_tBlessedMenData[self.m_nBlessMenId + 1].cost[1][2] then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_MEDAL_NOT_ENOUGH)
        return
    end

    --发送祈福一次请求
    self:_createLoading()
    ProtocolProcessorBless:send_PRAY_Pray(1)
    TeachGroup1:endTeachStep({42,4})
end 

--@brief    点击快速祈福按钮回调
function WndBless:onClickBlessQuick(element)
    -- body
    WZLog("WndBless:onClickBlessQuick")
    --播放音效
    --SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if #self.m_tBlessHallList >= self.m_nMaxBlessNum then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_HOUSE_FULL)
        return
    end
    --祈福勋章不足时
    if CacheCenter:getMoneyList().blessMedal < self.m_tBlessedMenData[self.m_nBlessMenId + 1].cost[1][2] then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_MEDAL_NOT_ENOUGH)
        return
    end

    --发送一键祈福请求
    self:_createLoading()
    ProtocolProcessorBless:send_PRAY_Pray(2)
end 

--@brief    快速购买金币框
function WndBless:buyGold(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        WndBuyActivity:showBuyInterface(26)
    end
end

--@brief    点击一键吞噬按钮回调
function WndBless:onClickDevourAll(element)
    -- body
    --播放音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --提示
    local bCanPickup = self:_checkBlessItemForPickup(2)
    if self.m_tBlessHallList == nil or #self.m_tBlessHallList <= 1 then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_HOUSE_NIL)
        return
    end
    if not bCanPickup then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_NEED_DEVOUR)
        return 
    end
    --找出当前最高品质的祝福
    local tDevourItem, bIsCanDevourAll = self:_findTheHeightestBlessItem()
    WZLog("WndBless:onClickDevourAll", Serialize(tDevourItem), bIsCanDevourAll)
    if tDevourItem.level < self:_getMaxLevel(tDevourItem.item_id) and bIsCanDevourAll then
        local name = "Lv" .. tDevourItem.level .. tDevourItem.basicInfo.name
        local sAtt = string.format(LocalStrings.DEVOUR_ATT, name)
        MsgBoxManager:showConfirmBox(sAtt, self,self.sureToDevourAll, nil, nil)
        return 
    elseif tDevourItem.level >= self:_getMaxLevel(tDevourItem.item_id) then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_NEED_DEVOUR)
        return
    elseif not bIsCanDevourAll then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_TO_DEVOUR)
        return
    end
end 

--@brief    一键吞噬提示确定回调
function WndBless:sureToDevourAll(element, btnTag)
    -- body
    if btnTag == MSGBOXTYPE_CONFIRM then
        self:_createLoading()
        ProtocolProcessorBless:send_PRAY_FastDevour(1)
    end
end

--@brief    点击一键出售按钮回调
function WndBless:onClickSellAll(element)
    -- body
    --播放音效
    WZLog("WndBless:onClickSellAll")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local vBeSellId = WZLuaVector_int_:create()
    for i = 1, #self.m_tBlessHallList do
        if self.m_tBlessHallList[i].basicInfo.sub_type == 31 then 
            vBeSellId:push(self.m_tBlessHallList[i].blessId)
        end
    end
    if vBeSellId:size() == 0 then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_TOSELL)
        return
    end
    
    self:_createLoading()
    ProtocolProcessorBless:send_PRAY_Sell(vBeSellId)
end 

--@brief    点击一键出售按钮回调
function WndBless:onClickSellAll1(element)
    WZLog("WndBless:onClickSellAll1")
    local vBeSellId = WZLuaVector_int_:create()
    for i = 1, #self.m_tBlessHallList do
        if self.m_tBlessHallList[i].basicInfo.sub_type == 31 then 
            vBeSellId:push(self.m_tBlessHallList[i].blessId)
        end
    end
    if vBeSellId:size() == 0 then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_TOSELL)
        return
    end
    
    self:_createLoading()
    ProtocolProcessorBless:send_PRAY_Sell(vBeSellId)
end 

--@brief    点击一键拾取按钮回调
function WndBless:onClickPickAll(element)
    -- body
    --播放音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBless:onClickPickAll")
    --判断背包是否已满，满则提示清理
    local nBagMaxNum = tonumber(CacheCenter:getGameParam()["prayBagSize"]) or 20
    local bCanPickup = self:_checkBlessItemForPickup(1)
    if self.m_tBlessHallList == nil or #self.m_tBlessHallList == 0 or not bCanPickup then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESS_TOPICK)
        local isEndTeach, step = TeachGroup1:isTeachFinish(42)
        if isEndTeach ~= true  then
            TeachGroup1:setTeachFinish(42, -1, true)
            ProtocolProcessorTeach:send_TASK_TiroStep(42, -1)
            TeachGroup1:removeTeach()
        end
        return
    end
    if #self.m_tBlessBagList >= nBagMaxNum then
        local isEndTeach, step = TeachGroup1:isTeachFinish(42)
        if isEndTeach ~= true  then
            TeachGroup1:startGroup({42,6,self.m_root})
        end
        MsgBoxManager:showTipBox(LocalStrings.BLESS_BAG_FULL3)
        return
    end
    --发送拾取协议拾取选中的祝福
    self:_createLoading()
    local vBePickId = WZLuaVector_int_:create()
    ProtocolProcessorBless:send_PRAY_ChangeBag(1, vBePickId)
    TeachGroup1:endTeachStep({42,5})
end 

--@brief    点击祈福背包按钮回调
function WndBless:onClickBlessBag(element)
    -- body
    --播放音效
    TeachGroup1:endTeachStep({42,6})
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if WndAscending.m_root then
        WindowManager:removeWindow(WndAscending.m_root, WndAscending, true)
    end
    --创建祈福背包界面
    if WndBlessBag.m_root and WndBagMain.m_root then
        WndBlessBag:setBlessItemList( self.m_nBlessFighting, self.m_tBlessBagList, self.m_tEquipList)
        WindowManager:removeWindow(WndBless.m_root, WndBless, true)
        return 
    end
    WndBagMain:showBagBless()
end 

--@brief    显示祈福屋祝福列表
function WndBless:onShowBless(element)
    -- body
    if self.m_tBlessHallList == nil or #self.m_tBlessHallList == 0 then
        element:disableSchedule()
        self.m_bIsFlyIn = false

        WZLog("WndBless:onShowBless one", CacheCenter:getPlayerItemCountById(23))
        local isEndTeach, step = TeachGroup1:isTeachFinish(42)
        if isEndTeach ~= true then
            if CacheCenter:getPlayerItemCountById(23) >= 1 and CacheCenter:getMoneyList().blessMedal >= self.m_tBlessedMenData[self.m_nBlessMenId + 1].cost[1][2] then
                TeachGroup1:startGroup({42,4,self.m_root})
            else
                TeachGroup1:setTeachFinish(42, -1, true)
                ProtocolProcessorTeach:send_TASK_TiroStep(42, -1)
                TeachGroup1:removeTeach()
            end
        end
        return
    end

    local nMaxBlessNum = #self.m_tBlessHallList
    if self.m_nLoadingIndex >= nMaxBlessNum then
        element:disableSchedule()
        self.m_bIsFlyIn = false

        WZLog("WndBless:onShowBless two")
        local isEndTeach, step = TeachGroup1:isTeachFinish(42)
        if isEndTeach ~= true then
            TeachGroup1:startGroup({42,5,self.m_root})
        --[[
        else
            TeachGroup1:startGroup({42,6,self.m_root})--]]
        end
        return
    end

    --创建祝福节点
    local cellElement, tNewObj = CellBlessItem:createElement()
    if cellElement and tNewObj then
        cellElement:setTag(self.m_nLoadingIndex)
        element = WZUITableContainer:luaTo(element)
        element:setCellElement(cellElement)
        tNewObj:setCallBackFun(self, self.onClickDevour, self.onClickPick, self.onClickSell)
        tNewObj:setData(self.m_tBlessHallList[self.m_nLoadingIndex + 1], 2, self.m_root)
        WZLog("WndBless:onShowBless", self.m_tBlessHallList[self.m_nLoadingIndex + 1].blessId, self.m_nLoadingIndex + 1)
        if self.m_bIsFlyIn then
            --对于祈福得到的祝福，先设置为不可见，等到从祈福师飞到相应位置的时候才设置可见
            cellElement:setVisible(false)
            --产生该祝福的祈福师
            local nCurBlessMenId = self.m_tNewBlessMenId[self.m_nNewBlessMenIndex]
            if nCurBlessMenId == 5 then  --5和3都是同一个祈福师
                nCurBlessMenId = 3
            end
            local conBlessedMen = GetElement(self.m_root, string.format("conBlessedMen%d_WndBless", nCurBlessMenId + 1), WZUIContainer)
            local conSize = conBlessedMen:getAbsContentSize()
            local conPtX = conBlessedMen:getPositionX()
            local conPtY = conBlessedMen:getPositionY()
            WZLog("WndBless:onShowBless 222 ", conPtX, conPtY, nCurBlessMenId)
            local tempElement, tempNewObj = CellBlessItem:createElement()
            tempElement:setScale(0.2)
            tempNewObj:setData(self.m_tBlessHallList[self.m_nLoadingIndex + 1], 7, self.m_root)
            local conForNewItem = GetElement(self.m_root, "conForNewItem_WndBless", WZUIContainer)
            local actPt = conForNewItem:convertToNodeSpace(GlobalMethod:ccp(conPtX,conPtY))
            WZLog("WndBless:onShowBless 444", actPt.x, actPt.y)
            conForNewItem:addChild(tempElement)
            tempElement:setPosition(GlobalMethod:ccp(actPt.x + conSize.width/2, actPt.y + conSize.height/2))
    		element:getMoveElement():setPositionY(element:getMaxPosition().y)
            self:_createMoveAction(tempElement, cellElement, 2)
        end

        self.m_nLoadingIndex = self.m_nLoadingIndex + 1
    end
end

--@brief    tips吞噬按钮点击响应事件
function WndBless:onClickDevour(tData)
    -- body
    WZLog("WndBless:onClickDevour")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --判断是否为最高等级，已经最高，则不能再吞噬升级
    local nMaxLevel = self:_getMaxLevel(tData.item_id)
    if tData.level >= nMaxLevel then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_LEVEL_MAX)
        return
    end

    local wndDevour = WndDevour:createElement()
    if wndDevour then
        WindowManager:addWindow(wndDevour, WndDevour)
        local tDevourList = self:_generalBlessItemsForDevour(tData)
        WndDevour:setData(tData, tDevourList, true)
    end
end

--@brief    tips拾取按钮点击响应事件
function WndBless:onClickPick(tData)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndBless:onClickPick")
    --判断背包是否已满，满则提示清理
    local nBagMaxNum = tonumber(CacheCenter:getGameParam()["prayBagSize"]) or 20
    if #self.m_tBlessBagList >= nBagMaxNum then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_BAG_FULL3)
        return
    end
    --发送拾取协议拾取选中的祝福
    local vBePickId = WZLuaVector_int_:create()
    vBePickId:push(tData.blessId)

    self:_createLoading()
    ProtocolProcessorBless:send_PRAY_ChangeBag(2, vBePickId)
end

--@brief    tips出售按钮点击相应事件
function WndBless:onClickSell(tData)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --单次出售垃圾祝福
    WZLog("WndBless:onClickSell")
    local vBeSellId = WZLuaVector_int_:create()
    vBeSellId:push(tData.blessId)
    self:_createLoading()
    ProtocolProcessorBless:send_PRAY_Sell(vBeSellId)
end

--@brief    召唤按钮回调
function WndBless:onClickCall(element)
    -- body
    WZLog("WndBless:onClickCall")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if #self.m_tBlessHallList >= self.m_nMaxBlessNum then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_HOUSE_FULL2)
        return
    end

    if self.m_nBlessMenId >= 3 then 
        local nTempId 
        if self.m_nBlessMenId == 5 then
            nTempId = self.m_nBlessMenId - 1
        else
            nTempId = self.m_nBlessMenId + 1
        end
        local sAtt = string.format(LocalStrings.BLESSEDMEN_LEVEL_ATT, nTempId)
        MsgBoxManager:showConfirmCancelBox(sAtt, self,self.clickSureBack, nil, nil)
        return
    end

    self:_callMsgBox()
end

--@brief 继续召唤
function WndBless:clickSureBack(element, btnTag)
    -- body
    WZLog("WndBless:clickSureBack")
    if btnTag == MSGBOXTYPE_CONFIRM then
        self:_callMsgBox()
    end
end

--@brief    祈福成功返回处理
function WndBless:blessSuccess(id, prayId, exp, prayerId)
	local id = VectorToTable(id)
	local prayId = VectorToTable(prayId)
	local exp = VectorToTable(exp)
	local prayerId = VectorToTable(prayerId)
	self.m_nTotal = #id
	if self.m_nTotal > self.m_nMaxBlessNum then
		self.m_nTotal = self.m_nMaxBlessNum
	end

	--local n = #id
	--for i=1,15 do
	--	id[n+i] = id[i]
	--	prayId[n+i] = prayId[i]
	--	exp[n+i] = exp[i]
	--	prayerId[n+i] = prayerId[i]
	--end
    --body
    self.m_nLoadingIndex = #self.m_tBlessHallList
    WZLog("WndBless:blessSuccess", #id)
    self.m_tNewBlessMenId = {}
    --标记得到的是否有非碎片的祝福
    local bIsNeedCreateAction = false

    for i = 0, #id - 1  do
        local nId = prayId[i+1]
        WZLog("WndBless:blessSuccess", nId)
        local tTemp = CopyTable(GDatatab_pray["id_"..nId])
        tTemp.basicInfo = CopyTable(GDatatab_item["id_"..tTemp.item_id]) 
        tTemp.blessId = id[i+1]
        tTemp.curExp = exp[i+1]
        tTemp.userType = 1
		tTemp.name = tTemp.basicInfo.name
        if tTemp.blessId ~= -1 then
            bIsNeedCreateAction = true
            table.insert(self.m_tBlessHallList, tTemp)
        else
            --得到的是碎片
            self.m_nBlessCoinNum = self.m_nBlessCoinNum + 1
            WZLog("WndBless:blessSuccess 11111 祈福币", self.m_nBlessCoinNum)
            MsgBoxManager:showTipBox(LocalStrings.GET_BLESS_COIN)
        end
        if i == 0 then
            self.m_tNewBlessMenId[i + 1] = self.m_nBlessMenId
            self:_createBlessMenTalk(self.m_nBlessMenId, prayerId[i+1], tTemp)
        else
            self.m_tNewBlessMenId[i + 1] = prayerId[i]
            self:_createBlessMenTalk(prayerId[i], prayerId[i+1], tTemp)
        end
    end
    --祈福获得的祝福要从祈福师处飞进来
    self.m_bIsFlyIn = true
    self.m_nNewBlessMenIndex = 1
    --停掉圈圈
    self:_stopLoading()
    if bIsNeedCreateAction then
        self:_createUnvisibleImage()
    end
    --祈福师切换
    local nextBlessMenId = prayerId[#id]
    WZLog("WndBless:blessSuccess 0000 ", nextBlessMenId)
    self:_updateBlessMen(nextBlessMenId)

    local conBlessList = GetElement(self.m_root, "tableconBlessList_WndBless", WZUITableContainer)
    conBlessList:enableSchedule("onShowBless")
end

--@brief    清理掉被吞噬或拾取或出售掉的祝福
--@param    被清理的祝福的Id
--@param    operateType : 1->为在拾取成功后调用，2->出售
function WndBless:cleanBeDevourBless(tBeDevourIds, operateType)
    --body
    if self.m_root == nil then return end
    --移除祈福屋中被吞噬或拾取掉或出售掉的祝福节点
    local conBlessList = GetElement(self.m_root, "tableconBlessList_WndBless", WZUITableContainer)
    local btnBlessBag = GetElement(self.m_root, "btnBlessBag_WndBless", WZUIButton)
    
    for i = 1, #tBeDevourIds do
        local tagIndex = 0
        local element = conBlessList:getCellElement(tagIndex) 
        while element do
            local cellElement = element:getChildElement("CellBlessItem")
            local tNewObj = WZUIContainer:luaTo(cellElement):getLuaObjectIndex()
            local tData = tNewObj:getData()
            if tData.blessId == tBeDevourIds[i] then
                if operateType == 1 then
                    if self.m_tPickUpList == nil then 
                        self.m_tPickUpList = {}
                    end
                    local conPtX = cellElement:getPositionX()
                    local conPtY = cellElement:getPositionY()
                    local ppp = element:convertToWorldSpace(GlobalMethod:ccp(conPtX,conPtY))
                    WZLog("cleanBeDevourBless 333 ", ppp.x, ppp.y)
                    
                    local conForNewItem = GetElement(self.m_root, "conForNewItem_WndBless", WZUIContainer)
                    local actPt = conForNewItem:convertToNodeSpace(GlobalMethod:ccp(ppp.x,ppp.y))
                    WZLog("cleanBeDevourBless 444", actPt.x, actPt.y)
                    tData.actPt = actPt
                    
                    table.insert(self.m_tPickUpList, tData)
                elseif operateType == 2 then
                    if self.m_tSellOutList == nil then 
                        self.m_tSellOutList = {}
                    end
                    -- local conPtX = cellElement:getPositionX()
                    -- local conPtY = cellElement:getPositionY()
                    -- local ppp = element:convertToWorldSpace(GlobalMethod:ccp(conPtX,conPtY))
                    -- WZLog("cleanBeDevourBless 333 ", ppp.x, ppp.y)
                    
                    -- local conForNewItem = GetElement(self.m_root, "conForNewItem_WndBless", WZUIContainer)
                    -- local actPt = conForNewItem:convertToNodeSpace(GlobalMethod:ccp(ppp.x,ppp.y))
                    -- WZLog("cleanBeDevourBless 444", actPt.x, actPt.y)
                    -- tData.actPt = actPt
                    
                    table.insert(self.m_tSellOutList, tData)
                    conBlessList:removeCellElementByReset(tagIndex)
                else
                    conBlessList:removeCellElementByReset(tagIndex)
                end
                break
            end
            tagIndex = tagIndex + 1
            element = conBlessList:getCellElement(tagIndex) 
        end
    end
    local conForNewItem = GetElement(self.m_root, "conForNewItem_WndBless", WZUIContainer)
    if operateType == 1 then
        self.m_nPickUpIndex = 1
        conForNewItem:enableSchedule("onPickUpAnimation", 0.1)
    elseif operateType == 2 then
        -- self.m_nSellOutIndex = 1
        -- conForNewItem:enableSchedule("onSellOutAnimation", 0.1)
    end
    --移除祈福屋祝福列表中已经被吞噬或拾取或出售掉的祝福
    for i = 1, #tBeDevourIds do
        for j = 1, #self.m_tBlessHallList do
            if self.m_tBlessHallList[j].blessId == tBeDevourIds[i] then
                table.remove(self.m_tBlessHallList, j)
                break
            end
        end
    end
end

--@brief    祝福吞噬后，更新数据信息
--@param    tData: 吞噬后的新数据
function WndBless:updateTheBlessItemInfo(tData)
    --body
    WZLog("WndBless:updateTheBlessItemInfo")
    local conBlessList = GetElement(self.m_root, "tableconBlessList_WndBless", WZUITableContainer)

    for j = 1, #self.m_tBlessHallList do
        if self.m_tBlessHallList[j].blessId == tData.blessId then
            self.m_tBlessHallList[j] = tData
            local tagIndex = 0
            local element = conBlessList:getCellElement(tagIndex) 
            while element do
                local cellElement = element:getChildElement("CellBlessItem")
                local tNewObj = WZUIContainer:luaTo(cellElement):getLuaObjectIndex()
                local tDataTemp = tNewObj:getData()
                if tDataTemp.blessId == tData.blessId then
                    tNewObj:resetData(tData)
                    break
                end
                tagIndex = tagIndex + 1
                element = conBlessList:getCellElement(tagIndex) 
            end
            break
        end
    end
end

--@brief    拾取成功
function WndBless:pickupOK(blessId)
    -- body
    WZLog("WndBless:pickupOK")
    self:_stopLoading()

--    self.m_nPickupEffectId = SoundManager:playEffectSound(SoundDefine.E_S_KILL_SHIQU,true)
    self:_createUnvisibleImage()
    --将拾取的祝福转移到背包中
    for i = 1, #blessId do
        for j = 1, #self.m_tBlessHallList do
            if blessId[i] == self.m_tBlessHallList[j].blessId then
                local tTemp = self.m_tBlessHallList[j]
                tTemp.userType = 2

                table.insert(self.m_tBlessBagList, tTemp)
                break
            end
        end
    end
    --如果是用来被融合的祝福升级，则更新数据
    WndAscending:resetBagAndEquipList(self.m_tBlessBagList)
    --将祈福屋中已经转移的祝福清理掉
    self:cleanBeDevourBless(blessId, 1)
    local isEndTeach, step = TeachGroup1:isTeachFinish(42)
    if isEndTeach ~= true and CacheCenter:getPlayerInfo().level == 24 then
        TeachGroup1:startGroup({42,6,self.m_root})
    end
end

--@brief    出售成功
function WndBless:sellOutOK(blessId)
    -- body
    WZLog("WndBless:sellOutOK")
    self:_stopLoading()
    self:_createUnvisibleImage()
    self:cleanBeDevourBless(blessId, 2)
    --提示获得金币数量动画
    self:_gainGoldCoins()
end

--@brief    成功召唤祈福师
function WndBless:callBlessMenOK(nextBlessMenId)
    -- body
    WZLog("WndBless:callBlessMenOK", nextBlessMenId)
    self:_stopLoading()
    self.m_nSummonNum = self.m_nSummonNum + 1
    self:_setBlessMenRedDot()  --设置祈福师红点不可见
    self:_updateBlessMen(nextBlessMenId)
    g_bIsCallBlessMen = true

    local tBlessMenData = self.m_tBlessedMenData[nextBlessMenId + 1]
    --随机一条提示语
    local txtMonologue = SplitStringWithSeparator(tBlessMenData.monologue, "|")
    local nRandom = 1
    if txtMonologue ~= nil and #txtMonologue > 1 then
        nRandom = #txtMonologue
    end
    local tRandomList = GetRandomNum(1, nRandom)
    local nRandomValue
    if tRandomList ~= nil and tRandomList ~= {} then
        nRandomValue = math.floor(tRandomList[1])
        if nRandomValue <= 0 then 
            nRandomValue = 1 
        end
    end
    self:_createBlessMenTalk(nextBlessMenId, nextBlessMenId, nil, txtMonologue[nRandomValue])

end

--@brief    一键吞噬成功
function WndBless:devourAllOK(devourId, exp, prayId, tBeDevourIds)
    --body
    WZLog("WndBless:devourAllOK")
  --   if WndBlessBag.m_root then
  --       WndBlessBag:cleanBeDevourBless(tBeDevourIds)
  --       local tData =  CopyTable(GDatatab_pray["id_"..prayId])
  --       tData.basicInfo = CopyTable(GDatatab_item["id_"..tData.item_id])
  --       tData.userType = 2
  --       tData.blessId = devourId
  --       tData.curExp = exp
		-- tData.name = tData.basicInfo.name
  --       WndBlessBag:updateTheBlessItemInfo(tData)
  --       --同步背包中的祝福到祈福屋
  --       local tBagList, tEquipList = WndBlessBag:getBagList()
  --       self.m_tBlessBagList = CopyTable(tBagList)
  --       WndBlessBag:_stopLoading()
  --   else
        self:cleanBeDevourBless(tBeDevourIds)

        local tData = {}
        for i = 1, #self.m_tBlessHallList do
            if devourId == self.m_tBlessHallList[i].blessId then
                tData =  CopyTable(GDatatab_pray["id_"..prayId])
                tData.basicInfo = self.m_tBlessHallList[i].basicInfo
                tData.userType = self.m_tBlessHallList[i].userType
                tData.blessId = self.m_tBlessHallList[i].blessId
                tData.curExp = exp
				tData.name = tData.basicInfo.name
            end
        end
        self:updateTheBlessItemInfo(tData)
--    end

    --停掉圈圈
    self:_stopLoading()
end

--@brief    重新设置祈福屋中背包和装备栏的数据
--@param    tBagList: 背包祝福列表
--@param    tEquipList: 装备栏祝福列表
function WndBless:resetBagAndEquipList(tBagList, tEquipList)
    --body
    if self.m_root == nil then return end
    WZLog("WndBless:resetBagAndEquipList")
    if tBagList ~= nil then
        self.m_tBlessBagList = tBagList
    end

    if tEquipList ~= nil then
        self.m_tEquipList = tEquipList 
    end
    --如果融合界面存在，则更新
    WndAscending:resetBagAndEquipList(tBagList, tEquipList)
end

--@brief    动态显示拾取
function WndBless:onPickUpAnimation(element)
    -- body
    WZLog("WndBless:onPickUpAnimation",self.m_nPickUpIndex, type(self.m_tPickUpList))
    if self.m_tPickUpList == nil or #self.m_tPickUpList == 0 then
        element:disableSchedule()
        self:_removeUnableTouchImage()
        return
    end
    if self.m_nPickUpIndex > #self.m_tPickUpList then
        element:disableSchedule()   
        self.m_tPickUpList = nil
        return
    end

    local btnBlessBag = GetElement(self.m_root, "btnBlessBag_WndBless", WZUIButton)
    local tempElement, tempNewObj = CellBlessItem:createElement()
    tempElement:setScale(1)
    tempNewObj:setData(self.m_tPickUpList[self.m_nPickUpIndex], 7, self.m_root)
    local conForNewItem = GetElement(self.m_root, "conForNewItem_WndBless", WZUIContainer)
    local actPt = self.m_tPickUpList[self.m_nPickUpIndex].actPt
    WZLog("WndBless:onPickUpAnimation", actPt.x, actPt.y)
    conForNewItem:addChild(tempElement)
    tempElement:setPosition(GlobalMethod:ccp(actPt.x, actPt.y))

    self:_createMoveAction(tempElement, btnBlessBag, 1)
    --移除原来位置的祝福
    local tagIndex = 0
    local conBlessList = GetElement(self.m_root, "tableconBlessList_WndBless", WZUITableContainer)
    local celElement = conBlessList:getCellElement(tagIndex) 
    while celElement do
        local cellElement = celElement:getChildElement("CellBlessItem")
        local tNewObj = WZUIContainer:luaTo(cellElement):getLuaObjectIndex()
        local tData = tNewObj:getData()
        if tData.blessId == self.m_tPickUpList[self.m_nPickUpIndex].blessId then
            conBlessList:removeCellElementByReset(tagIndex);
            break
        end
        tagIndex = tagIndex + 1
        celElement = conBlessList:getCellElement(tagIndex) 
    end

    self.m_nPickUpIndex = self.m_nPickUpIndex + 1

end


--@brief    动态显示出售
function WndBless:onSellOutAnimation(element)
    -- body
    if self.m_tSellOutList == nil or #self.m_tSellOutList == 0 then
        element:disableSchedule()
        self:_removeUnableTouchImage()
        return
    end
    if self.m_nSellOutIndex > #self.m_tSellOutList then
        element:disableSchedule()   
        self.m_tSellOutList = nil
        return
    end
    --创建一个可以用来移动的祝福
    local tempElement, tempNewObj = CellBlessItem:createElement()
    tempElement:setScale(1)
    tempNewObj:setData(self.m_tSellOutList[self.m_nSellOutIndex], 7, self.m_root)
    local conForNewItem = GetElement(self.m_root, "conForNewItem_WndBless", WZUIContainer)
    local actPt = self.m_tSellOutList[self.m_nSellOutIndex].actPt
    WZLog("WndBless:onSellOutAnimation", actPt.x, actPt.y)
    conForNewItem:addChild(tempElement)
    tempElement:setPosition(GlobalMethod:ccp(actPt.x, actPt.y))

    self:_createMoveAction(tempElement, self.m_goldNode, 3)
    --移除原来位置的祝福
    local tagIndex = 0
    local conBlessList = GetElement(self.m_root, "tableconBlessList_WndBless", WZUITableContainer)
    local celElement = conBlessList:getCellElement(tagIndex) 
    while celElement do
        local cellElement = celElement:getChildElement("CellBlessItem")
        local tNewObj = WZUIContainer:luaTo(cellElement):getLuaObjectIndex()
        local tData = tNewObj:getData()
        if tData.blessId == self.m_tSellOutList[self.m_nSellOutIndex].blessId then
            conBlessList:removeCellElementByReset(tagIndex);
            break
        end
        tagIndex = tagIndex + 1
        celElement = conBlessList:getCellElement(tagIndex) 
    end

    self.m_nSellOutIndex = self.m_nSellOutIndex + 1

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    添加顶部钻石栏
function WndBless:_addTop()
    -- body
    local conTop = GetElement(self.m_root, "conTop_WndBless", WZUIContainer)
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_qifu.png", WndBless, WndBless.onCloseClick, true, false, false,nil,{goldType = 3})
    conTop:addChild(celElement)

    self.m_goldNode = tNewObj:getGoldNode()
    self.m_topCellLua = tNewObj
end

--@brief    添加祈福师
function WndBless:_addBlessedMen()
    -- body
    if self.m_tBlessedMenData == nil or #self.m_tBlessedMenData == 0 then 
        WZLog("******* WndBless:_addBlessedMen ****** nil")
        return
    end

    for i = 1, #self.m_tBlessedMenData - 1 do
        local tData = self.m_tBlessedMenData[i]
        local element, tNewObj = CellBlessedMen:createElement()
        local conBlessedMen = GetElement(self.m_root, string.format("conBlessedMen%d_WndBless", i), WZUIContainer)
        tNewObj:setData(tData)
        if i == 4 then   --设置召唤回调
            tNewObj:setCallBackFun(self, self.onClickCall)
        end
        element:setTag(99)
        conBlessedMen:addChild(element)
    end
end

--@brief    获取当前类型的祝福最高等级
function WndBless:_getMaxLevel(itemId)
    -- body
    local nLevel = 0

    for i, value in pairs(GDatatab_pray) do
        if value.item_id == itemId and value.level > nLevel then
            nLevel = value.level
        end
    end

    return nLevel
end

--@brief    生成可用于被某祝福吞噬的所有祝福
function WndBless:_generalBlessItemsForDevour(tData)
    -- body
    local nMaxLevel = self:_getMaxLevel(tData.item_id)
    local tTemp = {}
    --挑选品质低于当前
    for i = 1, #self.m_tBlessHallList do
        if self.m_tBlessHallList[i].basicInfo.sub_type == 32 or (tData.blessId ~= self.m_tBlessHallList[i].blessId and self.m_tBlessHallList[i].basicInfo.sub_type ~= 31 and tData.quality >= self.m_tBlessHallList[i].quality and self.m_tBlessHallList[i].quality < 4 ) then
            local tBlessTemp = self.m_tBlessHallList[i]
            tBlessTemp.bIsChoose = false
            WZLog("WndBless:_generalBlessItemsForDevour", tBlessTemp.blessId, i, self.m_tBlessHallList[i].blessId)
            table.insert(tTemp, tBlessTemp)
        end
    end

    return tTemp
end

--@brief    查找品质最高可吞噬其他祝福的祝福
function WndBless:_findTheHeightestBlessItem()
    -- body
    local tHeightestItem = self.m_tBlessHallList[1] 
    if self.m_tBlessHallList[1].basicInfo.sub_type == 31 or self.m_tBlessHallList[1].basicInfo.sub_type == 32 or tHeightestItem.level >= self:_getMaxLevel(tHeightestItem.level) then
        for i = 1, #self.m_tBlessHallList do
            if self.m_tBlessHallList[i].basicInfo.sub_type ~= 31 and self.m_tBlessHallList[i].basicInfo.sub_type ~= 32 and self.m_tBlessHallList[i].level < self:_getMaxLevel(self.m_tBlessHallList[i].item_id) then
                tHeightestItem = self.m_tBlessHallList[i]
                break 
            end
        end
    end
    --找出品质最高的
    for i = 2, #self.m_tBlessHallList do
        if self.m_tBlessHallList[i].basicInfo.sub_type ~= 31 and self.m_tBlessHallList[i].basicInfo.sub_type ~= 32 and self.m_tBlessHallList[i].quality > tHeightestItem.quality and self.m_tBlessHallList[i].level < self:_getMaxLevel(self.m_tBlessHallList[i].item_id) then
            tHeightestItem = self.m_tBlessHallList[i]
            break 
        end
    end
    --找出同品质中等级最高的
    for i = 1, #self.m_tBlessHallList do
        if self.m_tBlessHallList[i].quality == tHeightestItem.quality and self.m_tBlessHallList[i].level < self:_getMaxLevel(self.m_tBlessHallList[i].item_id) then 
            if self.m_tBlessHallList[i].id > tHeightestItem.id then
                tHeightestItem = self.m_tBlessHallList[i]
            elseif self.m_tBlessHallList[i].id == tHeightestItem.id then
                if self.m_tBlessHallList[i].level == tHeightestItem.level then 
                    if self.m_tBlessHallList[i].curExp > tHeightestItem.curExp then
                        tHeightestItem = self.m_tBlessHallList[i]
                    end
                else
                    if self.m_tBlessHallList[i].level > tHeightestItem.level then 
                        tHeightestItem = self.m_tBlessHallList[i]
                    end
                end
            end
        end
    end
    --找出是否有可被吞噬的祝福
    local bIsCanDevourAll = false
    for i = 1, #self.m_tBlessHallList do
        if self.m_tBlessHallList[i].blessId ~= tHeightestItem.blessId and self.m_tBlessHallList[i].basicInfo.sub_type ~= 31 and ((self.m_tBlessHallList[i].basicInfo.sub_type ~= 32 and ((tHeightestItem.quality >= 3 and self.m_tBlessHallList[i].quality < tHeightestItem.quality) or (tHeightestItem.quality < 3 and self.m_tBlessHallList[i].quality <= tHeightestItem.quality))) or self.m_tBlessHallList[i].basicInfo.sub_type == 32) then
            bIsCanDevourAll = true
        end
    end

    return tHeightestItem, bIsCanDevourAll
end

--@brief    更新祈福师
function WndBless:_updateBlessMen(nextBlessMenId)
    -- body
    if self.m_nBlessMenId ~= nextBlessMenId then
        --原来的祈福师变灰
        local nBlessMenId = self.m_nBlessMenId
        if self.m_nBlessMenId == 5 then  --5和3都是同一个祈福师
            nBlessMenId = 3
        end

        local conBlessedMen = GetElement(self.m_root, string.format("conBlessedMen%d_WndBless", nBlessMenId + 1), WZUIContainer)
        local element = conBlessedMen:getChildByTag(99)
        local tNewObj = WZUIContainer:luaTo(element):getLuaObjectIndex()
        tNewObj:resetData(false)
        --新的祈福师激活
        nBlessMenId = nextBlessMenId
        if nextBlessMenId == 5 then  --5和3都是同一个祈福师
            nBlessMenId = 3
        end
        local conBlessedMenNext = GetElement(self.m_root, string.format("conBlessedMen%d_WndBless", nBlessMenId + 1), WZUIContainer)
        local element = conBlessedMenNext:getChildByTag(99)
        local tNewObj = WZUIContainer:luaTo(element):getLuaObjectIndex()
        tNewObj:resetData(true)

        self.m_nBlessMenId = nextBlessMenId
    end
end

--@brief    数据加载动画
function WndBless:_createLoading()
    -- body
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndBless:_stopLoading()
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end

--@brief    祈福师的冒泡的话
--@param    nLastMenId:上一个祈福师的id
--@param    nBlessMenId:当前祈福师id
--@param    tData:当前祈福获得的祝福数据
--@param    talkText : 冒泡内容
function WndBless:_createBlessMenTalk(nLastMenId, nBlessMenId, tData, talkText)
    -- body
    WZLog("WndBless:_createBlessMenTalk")
    local nameFormat 
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "th" then
        nameFormat = {[[<T C="255,255,255" S="18" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="99,255,95" S="18" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="93,222,254" S="18" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="198,130,255" S="18" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="255,227,116" S="18" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]]}
    elseif ProjConfig.LANGUAGE == "tr" then
        nameFormat = {[[<T C="255,255,255" S="15" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="99,255,95" S="15" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="93,222,254" S="15" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="198,130,255" S="15" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="255,227,116" S="15" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]]}
    else
        nameFormat = {[[<T C="255,255,255" S="22" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="99,255,95" S="22" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="93,222,254" S="22" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="198,130,255" S="22" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]], [[<T C="255,227,116" S="22" P="1" SE="1" SS="4" SC="79,60,48">%s</T>]]}
    end
    tBlessMenData = self.m_tBlessedMenData[nLastMenId + 1]
    local nCurBlessMenId = nLastMenId
    if nCurBlessMenId == 5 then  --5和3都是同一个祈福师
        nCurBlessMenId = 3
    end
    local conBlessedMen = GetElement(self.m_root, string.format("conBlessedMen%d_WndBless", nCurBlessMenId + 1), WZUIContainer)

    if conBlessedMen:getChildByTag(88) then
        conBlessedMen:removeChildByTag(88, true)
    end

    local imgTalkBk = WZUIImage:create()
    imgTalkBk:setFile("ui/common/common_scale9_kk.png")
    imgTalkBk:setUseOriginSize(true)
    imgTalkBk:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    if nLastMenId == 0 then
        imgTalkBk:setRelativePosition(GlobalMethod:ccp(0.8,1))
    else
        imgTalkBk:setRelativePosition(GlobalMethod:ccp(0.5,1))
    end

    imgTalkBk:setTag(88)
    conBlessedMen:addChild(imgTalkBk)

    local txtString = talkText
    local txtContent
    if txtString == nil then 
        local name = string.format(nameFormat[tData.basicInfo.quality + 1], tData.basicInfo.name)
        WZLog("WndBless:_createBlessMenTalk 222", name, tData.basicInfo.quality)

        if nLastMenId >= nBlessMenId then
            txtString = string.format(tBlessMenData.fail, name)
        else
            txtString = string.format(tBlessMenData.success, name)
        end
        txtContent = txtString
    else
        local sContentFormat = [[<T C="127,70,26" S="22" P="1">%s</T>]]
        txtContent = string.format(sContentFormat, txtString)
    end
    WZLog("WndBless:_createBlessMenTalk 111", txtContent)

    local freeLabel = WZUIFreeTextBox:create()
    freeLabel:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    freeLabel:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    freeLabel:setMaxWidth(240)
    freeLabel:setShowText(txtContent)
    imgTalkBk:addChild(freeLabel)
    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" then
        freeLabel:setScale(0.8)
        freeLabel:setMaxWidth(300)
    elseif ProjConfig.LANGUAGE == "th" then
        imgTalkBk:setScale(0.8)
        freeLabel:setMaxWidth(250)
    elseif ProjConfig.LANGUAGE == "tr" then
        freeLabel:setMaxWidth(260)
    else
        freeLabel:setMaxWidth(240)
    end
    if ProjConfig.LANGUAGE == "vn" then
        freeLabel:setScale(0.8)
    end
    imgTalkBk:enableSchedule("onDesappear", 1.3)
end

--@brief    定时删除添加的祈福师对话
function WndBless:onDesappear(element)
    --body
    element:disableSchedule()
    element:removeFromParentAndCleanup(true)
end

--@brief    召唤弹框
function WndBless:_callMsgBox()
    -- body
    local tVipData = self:_getVipLimitData()

    --次數已經用完
    if tVipData == nil then
        MsgBoxManager:showTipBox(LocalStrings.CALL_TIMES_FINISH)
        return 
    end
    --vip等級不夠
    if tVipData.vip_level > CacheCenter:getPlayerInfo().vipLevel then 
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
        MsgBoxManager:showConfirmBox(LocalStrings.CALL_UNSUCCESS, self, self.needHigherCallBack, nil, tCustomUIConfig)
        return 
    end
    --提示需要消耗的钻石，当前召唤次数
    local txtContent 
    if self.m_nSummonNum == 0 then
        txtContent = LocalStrings.CALL_FREE_ATT
    else
        txtContent = string.format(LocalStrings.CALL_TIMES_COST,tVipData.cost[1][2],self.m_nSummonNum)
    end
    MsgBoxManager:showConfirmBox(txtContent,self,self.callSure, nil, nil)
end

function WndBless:callSure(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        if self.m_nSummonNum == 0 then --普通召唤
            WZLog("WndBless:callSure 111")
            self:_createLoading()
            ProtocolProcessorBless:send_PRAY_Call(1)
        else
            WZLog("WndBless:callSure 222")
            local tVipData = self:_getVipLimitData()
            if tVipData ~= nil then
                local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
                if not JudgeMoneyIsEnough(tVipData.cost[1][1], tVipData.cost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, tCustomUIConfig, 1, self, self.sureUseDiamondInstead) then 
                    return 
                end
            end
            
            self:sureUseDiamondInstead()
        end
    end
end

--@brief    确认用钻石代替礼券召唤回调
function WndBless:sureUseDiamondInstead()
    -- body
    self:_createLoading()
    ProtocolProcessorBless:send_PRAY_Call(2)
end

--@brief    提示提升VIP等級的回调
--@param    nId:消息id
--@param    nResType:响应类型(超时，确定，取消)
function WndBless:needHigherCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

--@brief    获取当前VIP限购数据
function WndBless:_getVipLimitData()
    -- body
    for key, value in pairs(GDatatab_vip_restriction) do
        if value.type == 11 and value.count == self.m_nSummonNum + 1 then
            return value
        end
    end

    return nil 
end

--@brief    祝福移动动画
--@param    element:需要移动的节点
--@param    moveToNode:需要移动到的节点
--@param    actionIndex : 播放的动作索引 ， 1：拾取，2：祈福，3：出售
function WndBless:_createMoveAction(element, moveToNode, actionIndex)
    -- body
    self.m_nCreateActionNum = self.m_nCreateActionNum + 1
    if actionIndex == 1 or actionIndex == 3 then
        local ptElementX = element:getPositionX()
        local ptElementY = element:getPositionY()

        -- 获得element在parentElement坐标系中的坐标  
        local pt = moveToNode:convertToNodeSpace(GlobalMethod:ccp(ptElementX,ptElementY))
        moveToNode = WZUIContainer:luaTo(moveToNode)
        local conSize = moveToNode:getAbsContentSize()

        WZLog("WndBless:_createMoveAction", -pt.x, -pt.y)

        local moveBy
        if actionIndex == 1 then
            moveBy = CCMoveBy:create(0.4, ccp(-pt.x + conSize.width/2, conSize.height/2-pt.y))
        elseif actionIndex == 3 then
            moveBy = CCMoveBy:create(0.4, ccp(-pt.x + conSize.width/8, conSize.height/2-pt.y))
        end
        local scaleTo  = CCScaleTo:create(0.4, 0.2)

        local spawnAction = CCSpawn:createWithTwoActions(moveBy, scaleTo)
        local actionArray = CCArray:create()
        actionArray:addObject(spawnAction)
        actionArray:addObject(CCCallFuncN:create(_removeTheActionNode))
        local repH = CCSequence:create(actionArray)
        
        element:runAction(repH)
    elseif actionIndex == 2 then
        local ptElementX = element:getPositionX()
        local ptElementY = element:getPositionY()

        -- 获得element在parentElement坐标系中的坐标  
        local pt = moveToNode:convertToNodeSpace(GlobalMethod:ccp(ptElementX,ptElementY))
        local targetPtX = moveToNode:getPositionX()
        local targetPtY = moveToNode:getPositionY()

        local moveBy = CCMoveBy:create(0.2, GlobalMethod:ccp(targetPtX - pt.x, targetPtY - pt.y))
        local scaleTo  = CCScaleTo:create(0.2, 1)

        local spawnAction = CCSpawn:createWithTwoActions(moveBy, scaleTo)
        local actionArray = CCArray:create()
        actionArray:addObject(spawnAction)
        actionArray:addObject(CCCallFuncN:create(_showTheTargetNode))
        local repH = CCSequence:create(actionArray)
        
        element:runAction(repH)
    end
end

--@brief    动画回调
function _removeTheActionNode(element)
    --body
    local nTag = element:getTag()
    WZLog("_removeTheActionNode", nTag)
    element:removeFromParentAndCleanup(true)
    element = nil
    -- if self.m_nPickupEffectId then
    --     SoundManager:stopEffectSound(self.m_nPickupEffectId)
    --     self.m_nPickupEffectId = nil 
    -- end
    WndBless:_removeUnableTouchImage()
end

--@brief    当祝福从祈福师飘到相应的位置后，设置该位置隐藏的祝福为可见
function _showTheTargetNode(element)
    -- body
    element = WZUIContainer:luaTo(element)--element:getChildElement("CellBlessItem")
    local tNewObj = element:getLuaObjectIndex()
    local tData = tNewObj:getData()
    WZLog("_showTheTargetNode 0000 ", tData.blessId)
    element:removeFromParentAndCleanup(true)
    element = nil
    --将隐藏掉的祝福显示出来
    local conBlessList = GetElement(WndBless.m_root, "tableconBlessList_WndBless", WZUITableContainer)

    local tagIndex = 0
    local tempElement = conBlessList:getCellElement(tagIndex) 
    while tempElement do
        local cellElement = tempElement:getChildElement("CellBlessItem")
        local tCell = WZUIContainer:luaTo(cellElement):getLuaObjectIndex()
        local tDataTemp = tCell:getData()
		WZLog("show_bless", tagIndex, WndBless.m_nTotal, #WndBless.m_tBlessHallList, WndBless.m_nMaxBlessNum)
        if tDataTemp.blessId == tData.blessId then
            cellElement:setVisible(true)
            tempElement:setVisible(true)
			if (WndBless.m_nTotal == 1 or WndBless.m_nTotal == 2) and (tagIndex+1==#WndBless.m_tBlessHallList) then
				local autoSell = GetElement(WndBless.m_root,"autoSell",WZUICheckBox)
    			if autoSell:getCheckIndex() == 1 then
					WndBless:onClickSellAll1()
    			end
			elseif (tagIndex + 1) == WndBless.m_nMaxBlessNum then
				local autoSell = GetElement(WndBless.m_root,"autoSell",WZUICheckBox)
    			if autoSell:getCheckIndex() == 1 then
					WndBless:onClickSellAll1()
    			end
			end
            break
        end
        tagIndex = tagIndex + 1
        tempElement = conBlessList:getCellElement(tagIndex) 
    end

   WndBless:_removeUnableTouchImage()
end

--@brief    拾取或祈福动画时，屏蔽掉操作
function WndBless:_createUnvisibleImage()
    -- body
    self.m_nCreateActionNum = 0 
    if self.m_root:getChildByTag(666) then
        self.m_root:removeChildByTag(666, true)
    end

    local img = WZUIImage:create()
    img:setFile("ui/common/common_black_bg.png")
    img:setScaleX(30)
    img:setScaleY(50)
    img:setOpacity(0)
    self.m_root:addChild(img, 100, 666)
    WZLog("WndBless:_createUnvisibleImage")
end

--@brief    移除触摸屏蔽
function WndBless:_removeUnableTouchImage()
    -- body
    if self.m_nCreateActionNum > 0 then
        self.m_nCreateActionNum = self.m_nCreateActionNum - 1
    end
    if self.m_nCreateActionNum <= 0 then
        WZLog("WndBless:_removeUnableTouchImage")
        if self.m_root:getChildByTag(666) then
            self.m_root:removeChildByTag(666, true)
        end
    end
end

--@brief    检测是否有可拾取的祝福
--@param    nType:1->用于拾取；2->用于吞噬
function WndBless:_checkBlessItemForPickup(nType)
    -- body
    local bIsExist = false 

    for i = 1, #self.m_tBlessHallList do
        if nType == 2 and self.m_tBlessHallList[i].basicInfo.sub_type ~= 31 and self.m_tBlessHallList[i].basicInfo.sub_type ~= 32 then
            bIsExist = true
            break 
        elseif nType == 1 and self.m_tBlessHallList[i].basicInfo.sub_type ~= 31 then
            bIsExist = true
            break 
        end
    end

    return bIsExist
end

--@brief    出售成功后，提示获得金币数量动画
function WndBless:_gainGoldCoins()
    -- body
    if self.m_tSellOutList == nil or #self.m_tSellOutList == 0 then
        --移除触摸屏蔽层
        self:_removeUnableTouchImage()
        return 
    end
    --计算获得的总金币数量
    local nGoldCoinsNum = self:_caculateGoldNum()

    self:_createAtlasFont(nGoldCoinsNum)

    self.m_tSellOutList = nil
end

--@brief    计算出售获得的总金币数
function WndBless:_caculateGoldNum()
    -- body
    if self.m_tSellOutList == nil or #self.m_tSellOutList == 0 then
        return 0
    end
    local nGoldNum = 0

    for i = 1, #self.m_tSellOutList do
        nGoldNum = nGoldNum + self.m_tSellOutList[i].basicInfo.recycleMess[1][2]
    end

    return nGoldNum
end

--@brief    创建节点WZUILabelAtlasFont,用于显示出售成功后的结果显示
--@param    #2增加的数量
function WndBless:_createAtlasFont(nAddNum)
    -- body
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS2) 
    --加号
    local imgAddSign = WZUIImage:create()
    imgAddSign:setFile("ui/common/common_num_yaoqianshujiahao.png")
    imgAddSign:setUseOriginSize(true)

    --增加的类型图标
    local imgIcon = WZUIImage:create()
    imgIcon:setFile("ui/common/common_icon_jinbi.png")
    imgIcon:setUseOriginSize(true)

    --获得的结果数量
    local txtAtlasFont = WZUILabelAtlasFont:create()
    txtAtlasFont:setCharMapFileName("ui/common_num/common_num_yaoqianshuzi.png")
    txtAtlasFont:setStartChar(48)
    txtAtlasFont:setHeight(34)
    txtAtlasFont:setWidth(26)
    txtAtlasFont:setUseOriginSize(true)

    txtAtlasFont:setText(nAddNum)

    imgAddSign:setAnchorPoint(ccp(0.5, 0.5))
    imgAddSign:setRelativePosition(ccp(0.43, 0.5))

    imgIcon:setAnchorPoint(ccp(1, 0.5))
    imgIcon:setRelativePosition(ccp(0.49, 0.5))

    txtAtlasFont:setAnchorPoint(ccp(0, 0.5))
    txtAtlasFont:setRelativePosition(ccp(0.5, 0.5))

    local conResult = WZUIContainer:create()
    local conRoot = GetElement(self.m_root, "conForNewItem_WndBless", WZUIContainer)

     if conResult then
        conResult:addChild(imgAddSign)
        conResult:addChild(imgIcon)
        conResult:addChild(txtAtlasFont)
        
        conRoot:addChild(conResult, 10, 10)
     end
    
    local actionScaleTo1 = WZUIActionScaleTo:create()
    actionScaleTo1:setDuration(0.2)
    actionScaleTo1:setScaleY(1.1)
    actionScaleTo1:setScaleX(1.1)
    local actionScaleTo2 = WZUIActionScaleTo:create()
    actionScaleTo2:setDuration(0.2)
    actionScaleTo2:setScaleY(0.7)
    actionScaleTo2:setScaleX(0.7)
    local actionScaleTo3 = WZUIActionScaleTo:create()
    actionScaleTo3:setDuration(0.2)
    actionScaleTo3:setScaleY(0.85)
    actionScaleTo3:setScaleX(0.85)
     local actionScaleTo4 = WZUIActionScaleTo:create()
    actionScaleTo4:setDuration(0.5)
    actionScaleTo4:setScaleY(0.85)
    actionScaleTo4:setScaleX(0.85)
    local actionSqu = WZUIActionSequence:create()
    actionSqu:setIsLoop(false)
    actionSqu:setChildAction(actionScaleTo1)
    actionSqu:setChildAction(actionScaleTo2)
    actionSqu:setChildAction(actionScaleTo3)
    actionSqu:setChildAction(actionScaleTo4)

    local action = WZUIActionSpawn:create()

    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(0.6)
    actMoveTo:setMoveX(0.5)
    actMoveTo:setMoveY(0.65)

    local actFadeTo = WZUIActionContainerFadeFromTo:create()
    actFadeTo:setDuration(0.6)
    actFadeTo:setOpacityFrom(255)
    actFadeTo:setOpacityTo(0)

    action:setChildAction(actFadeTo)
    action:setChildAction(actMoveTo)

    actionSqu:setChildAction(action)
    actionSqu:setFinishLuaFunction("onActionFinishBack")

    conResult:runUIAction(actionSqu)
end

function WndBless:onActionFinishBack(element, b)
    -- body
    WZLog("***********************WndBless:onActionFinishBack****************************")
    element:removeFromParentAndCleanup(true)
    element = nil

    --移除触摸屏蔽层
    self:_removeUnableTouchImage()
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------------语言适配Begin--------------------------------------
function WndBless:_adaptLanguage_en()
    GetElement(self.m_root,"imgBlessMen2_WndBless",WZUIImage):setVisible(false)
    GetElement(self.m_root,"imgBlessMen1_WndBless",WZUIImage):setVisible(false)
    local txtBlessMan = GetElement(self.m_root,"txtBlessMan_WndBless",WZUILabelTTF)
    txtBlessMan:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
    txtBlessMan:setFontSize(16)
    
    GetElement(self.m_root,"imgbtn1_WndBless",WZUIImage):setScale(0.7)
end

function WndBless:_adaptLanguage_th(  )
    local txtBlessMan = GetElement(self.m_root,"txtBlessMan_WndBless",WZUILabelTTF)
    txtBlessMan:setFontSize(18)

    local txtSub4 = GetElement(self.m_root,"txtSub4_WndBless",WZUILabelTTF)
    txtSub4:setScale(0.8)
    txtSub4:setRelativePosition(GlobalMethod:ccp(0.69,-0.046))
    
    local txtSub5 = GetElement(self.m_root,"txtSub5_WndBless",WZUILabelTTF)
    txtSub5:setScale(0.8)
    txtSub5:setRelativePosition(GlobalMethod:ccp(0.69,-0.046))
end

function WndBless:_adaptLanguage_pt(  )
    --GetElement(self.m_root,"txtBlessBag_WndBless",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"imgBlessMen2_WndBless",WZUIImage):setVisible(false)
    GetElement(self.m_root,"imgBlessMen1_WndBless",WZUIImage):setVisible(false)
    local txtBlessMan = GetElement(self.m_root,"txtBlessMan_WndBless",WZUILabelTTF)
    txtBlessMan:setRelativePosition(GlobalMethod:ccp(0.3,0.5))
    txtBlessMan:setFontSize(16)

    GetElement(self.m_root,"imgbtn1_WndBless",WZUIImage):setScale(0.7)
    GetElement(self.m_root,"imgbtn2_WndBless",WZUIImage):setScale(0.9)
    GetElement(self.m_root,"imgbtn3_WndBless",WZUIImage):setScale(0.9)
    GetElement(self.m_root,"imgbtn4_WndBless",WZUIImage):setScale(0.9)
end

function WndBless:_adaptLanguage_vn()
    WZLog("WndBless:_adaptLanguage_vn")
    local txtSub4 = GetElement(self.m_root,"txtSub4_WndBless",WZUILabelTTF)
    txtSub4:setScale(0.8)
    txtSub4:setRelativePosition(GlobalMethod:ccp(0.7,-0.046))
    
    local txtSub5 = GetElement(self.m_root,"txtSub5_WndBless",WZUILabelTTF)
    txtSub5:setScale(0.8)
    txtSub5:setRelativePosition(GlobalMethod:ccp(0.7,-0.046))
end

function WndBless:_adaptLanguage_tr(  )
    --GetElement(self.m_root,"txtBlessBag_WndBless",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtBlessMan_WndBless",WZUILabelTTF):setFontSize(12)

    GetElement(self.m_root,"imgbtn2_WndBless",WZUIImage):setScale(0.75)
    GetElement(self.m_root,"imgbtn3_WndBless",WZUIImage):setScale(0.75)
    GetElement(self.m_root,"imgbtn4_WndBless",WZUIImage):setScale(0.75)

    local txtSub4 = GetElement(self.m_root,"txtSub4_WndBless",WZUILabelTTF)
    txtSub4:setScale(0.7)
    txtSub4:setRelativePosition(GlobalMethod:ccp(0.72,-0.046))
    local txtSub5 = GetElement(self.m_root,"txtSub5_WndBless",WZUILabelTTF)
    txtSub5:setScale(0.7)
    txtSub5:setRelativePosition(GlobalMethod:ccp(0.72,-0.046))
end

function WndBless:_adaptLanguage_es(  )
    --GetElement(self.m_root,"txtBlessBag_WndBless",WZUILabelTTF):setScale(0.7)
    for i=1,2 do
        GetElement(self.m_root,"imgBlessMen"..i.."_WndBless",WZUIImage):setVisible(false)
    end
    local txtBlessMan = GetElement(self.m_root,"txtBlessMan_WndBless",WZUILabelTTF)
    txtBlessMan:setFontSize(16)
    txtBlessMan:setRelativePosition(GlobalMethod:ccp(0.3,0.5))

    GetElement(self.m_root,"txtSub4_WndBless",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"autoSell",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.035,0.11))
    GetElement(self.m_root,"txtSub5_WndBless",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"quickPray",WZUICheckBox):setRelativePosition(GlobalMethod:ccp(0.035,0.11))

    GetElement(self.m_root,"imgbtn1_WndBless",WZUIImage):setScale(0.7)
    GetElement(self.m_root,"imgbtn2_WndBless",WZUIImage):setScale(0.9)
    GetElement(self.m_root,"imgbtn3_WndBless",WZUIImage):setScale(0.9)
    
end
-------------------------------------------语言适配End----------------------------------------
