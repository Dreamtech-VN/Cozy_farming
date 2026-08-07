--WndBlessBag.lua
--@brief	WndBlessBag的UI模块
--@date		2016/03/29
--@author	Tianxiang_Xu
--@note		祈福背包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBlessBag:onEnter(element)
	self.m_root = element

    AdaptLanguage(self)

    local isEndTeach, step = TeachGroup1:isTeachFinish(42)
    if isEndTeach ~= true and CacheCenter:getPlayerInfo().level == 19 then
        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBlessBag:onExit(element)
    if WndBless.m_root == nil then
        ProtocolProcessorBless:unregAll()
    end
	self:_unInit()
end

--@brief    界面动画加载完成调用函数
function WndBlessBag:onEnterTransitionDidFinish(element)
    -- body
    ProtocolProcessorBless:regAll()
    ChangeChatChannel(Chat_Channel_BlessBag)
    --祈福背包最大格子数
    local llll = tonumber(CacheCenter:getGameParam()["prayBagSize"])
    WZLog("WndBlessBag:onEnterTransitionDidFinish", llll)
    self.m_nMaxGridsNum = tonumber(CacheCenter:getGameParam()["prayBagSize"]) or 20
    WZLog("WndBlessBag:onEnterTransitionDidFinish", self.m_nMaxGridsNum)
    --新手定推礼包入口
    local conRight = GetElement(self.m_root, "conRight_WndBlessBag", WZUIContainer)
    CreateLimitPackage(64, conRight, GlobalMethod:ccp(0.89, 0.95))
    --添加钻石金币栏
--    self:_addTop()
    --创建角色动画
    self:_createPlayer()
    --创建空格子
    self:_createItemGrids()

    self:_createLoading()
    g_blessDataGetIndex = 2
    ProtocolProcessorBless:send_PRAY_GetPrayMess() 
end

--@brief    觸摸開始
function WndBlessBag:onTouchBegan(element, pt)
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
function WndBlessBag:onCloseClick(element)
    -- body
    --播放点击音效
    self.m_root:removeFromParentAndCleanup(true)
end

--@brief    点击祈福商店按钮回调
function WndBlessBag:onClickBlessShop(element)
    -- body
    --播放音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndStore:showStoreByType(4)
end

--@brief    点击祈福按钮回调
function WndBlessBag:onClickBless(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if WndBless.m_root and WndBagMain.m_root then
        WindowManager:removeWindow(WndBagMain.m_root, WndBagMain, true)
    end
    WndBless:showInterface()
end

--@brief    点击祈福融合按钮回调
function WndBlessBag:onClickBlessFuse(element)
    -- body
    if not CheckButtonOpen(82) then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        return 
    end

    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
    if WndBless.m_root then
        WindowManager:removeWindow(WndBless.m_root, WndBless, true)
    end
    WndAscending:jumpTo(3)
end

--@brief    点击一键吞噬按钮回调
function WndBlessBag:onClickDevourAll(element)
    -- body
    --播放音效
    WZLog("WndBlessBag:onClickDevourAll")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --提示
    if self.m_tBlessItemList == nil or #self.m_tBlessItemList <= 1 then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_HOUSE_NIL)
        return
    end
    --找出当前最高品质的祝福
    local tDevourItem, bIsCanDevourAll = self:_findTheHeightestBlessItem()
    WZLog("WndBlessBag:onClickDevourAll 222", Serialize(tDevourItem), bIsCanDevourAll)
    if tDevourItem.level < self:_getMaxLevel(tDevourItem.item_id) and bIsCanDevourAll then
        local name = "Lv" .. tDevourItem.level .. tDevourItem.basicInfo.name
        local sAtt = string.format(LocalStrings.DEVOUR_ATT, name)
        WZLog("WndBlessBag:onClickDevourAll 111", tDevourItem.level, tDevourItem.basicInfo.name, sAtt)
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
function WndBlessBag:sureToDevourAll(element, btnTag)
    -- body
    if btnTag == MSGBOXTYPE_CONFIRM then
        self:_createLoading()
        ProtocolProcessorBless:send_PRAY_FastDevour(2)
    end
end

--@brief    点击前往按钮回调
function WndBlessBag:onClickGotoBless(element)
    -- body
    self:onCloseClick(element)
end

--@brief    tips吞噬按钮点击响应事件
function WndBlessBag:onClickDevour(tData)
    -- body
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
        WndDevour:setData(tData, tDevourList)
    end
end

--@brief    tips装备按钮点击响应事件
--@param    nEquiConIndex:装备到的装备栏的索引
function WndBlessBag:onClickEquip(tData, nEquiConIndex)
    -- body
    WZLog("WndBlessBag:onClickEquip")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local bIsEquipSame = false

    if nEquiConIndex then
        self.m_nEquipRectIndex = nEquiConIndex
    else
        self.m_nEquipRectIndex = nil 
        --获取可用的装备栏索引
        self.m_nEquipRectIndex, bIsEquipSame= self:_getCanUseEquipIndex(tData)
    end
    if not self.m_nEquipRectIndex then
        MsgBoxManager:showTipBox(LocalStrings.NO_USE_EQUIP_RECT)
        return
    elseif bIsEquipSame then
        self.m_tTakeOffData = nil 
        MsgBoxManager:showTipBox(LocalStrings.EQUIP_THE_SAME_ATT)
        return
    else 
        self:_createLoading()
        --保存要装备的祝福数据
        self.m_tDressUpData = tData
        self.m_nOperateType = 1
        ProtocolProcessorBless:send_PRAY_Equip(1, tData.blessId)
        TeachGroup1:endTeachStep({42,8})
    end
end

--@brief    tips卸下按钮点击相应事件
function WndBlessBag:onClickTakeOff(tData)
    -- body
    WZLog("WndBlessBag:onClickTakeOff")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nBlessNum = #self.m_tBlessItemList
    --判断背包中是否有空的格子
    if nBlessNum >= self.m_nMaxGridsNum then
        MsgBoxManager:showTipBox(LocalStrings.BLESS_BAG_FULL2)
        return 
    end
    --发送卸下协议
    self:_createLoading()
    --保存卸下的祝福数据
    self.m_tTakeOffData = tData
    self.m_nOperateType = 2
    ProtocolProcessorBless:send_PRAY_Equip(2, tData.blessId)
end

--@brief    清理掉被吞噬的祝福
--@param    被吞噬掉的祝福的Id
function WndBlessBag:cleanBeDevourBless(tBeDevourIds)
    --body
    if self.m_root == nil then return end
    --移除祈福背包祝福列表中已经被吞噬的祝福
    for i = 1, #tBeDevourIds do
        for j = 1, #self.m_tBlessItemList do
            if self.m_tBlessItemList[j].blessId == tBeDevourIds[i] then
                table.remove(self.m_tBlessItemList, j)
                break
            end
        end
    end
    --重新设置各节点的数据
    for i = 1, #self.m_tBlessItemList do
        if self.m_tCellGridsList[i] then
            self.m_tCellGridsList[i]:setCallBackFun(self, self.onClickDevour, self.onClickEquip, self.onClickTakeOff)
            self.m_tCellGridsList[i]:setData(self.m_tBlessItemList[i], 4, self.m_root)
        end
    end
    --被吞噬掉的设置为空白
    for j = #self.m_tBlessItemList + 1, #self.m_tBlessItemList + #tBeDevourIds do
        if self.m_tCellGridsList[j] then
            self.m_tCellGridsList[j]:setData(nil, 1)
        end
    end

    --背包底部数值
    self:_updateGridsNum()
end

--@brief    祝福吞噬后，更新数据信息
--@param    tData: 吞噬后的新数据
function WndBlessBag:updateTheBlessItemInfo(tData)
    --body
    WZLog("WndBlessBag:updateTheBlessItemInfo")
    --背包中的祝福
    if tData.userType == 2 then
        for j = 1, #self.m_tBlessItemList do
            if self.m_tBlessItemList[j].blessId == tData.blessId then
                self.m_tBlessItemList[j] = tData
                self.m_tCellGridsList[j]:resetData(tData)
                break
            end
        end
    elseif tData.userType == 3 then   --装备栏中的祝福
        for j = 1, #self.m_tEquipList do
            if self.m_tEquipList[j].tData then
                if self.m_tEquipList[j].tData.blessId == tData.blessId then
                    local conEquipGrid = GetElement(self.m_root, string.format("conEquipGrid%d_WndBlessBag", j), WZUIContainer)
                    local cellElement = conEquipGrid:getChildByTag(999)
                    local tNewObj = cellElement:getLuaObjectIndex()
                    self.m_tEquipList[j].tData = tData
                    if tNewObj then
                        tNewObj:resetData(tData)
                    end
                    break
                end
            end
        end
    end

    --更新祈福屋中背包和装备栏的数据
    WndBless:resetBagAndEquipList(self.m_tBlessItemList, self.m_tEquipList)
    --如果是用来被融合的祝福升级，则更新数据
    WndAscending:resetBagAndEquipList(self.m_tBlessItemList, self.m_tEquipList)
end

--@brief    获取背包中背包祝福和装备的数据
function WndBlessBag:getBagList()
    -- body
    return self.m_tBlessItemList, self.m_tEquipList
end

--@brief    一键装备成功 
function WndBlessBag:oneKeyEquipOK(rectIndex, equipBlessId, fightNum)
    -- body
    self:_stopLoading()
    self:updateRoleFighting(fightNum)
    WZLog("WndBlessBag:oneKeyEquipOK", Serialize(rectIndex), Serialize(equipBlessId))
    for i = 1, #rectIndex do
        for j = 1, #self.m_tBlessItemList do
            if self.m_tBlessItemList[j].blessId == equipBlessId[i] then
                self.m_nEquipRectIndex = rectIndex[i]
                self:dressUpDealWith(self.m_tBlessItemList[j], nil)
                break 
            end
        end
    end
end

--@brief    装备或卸下成功处理方法
function WndBlessBag:operateOK(prayNum, equipPrayId, equipId, equipLevel, bagIds, bagExps, bagPrayIds, fightNum)
    --body
    self:_stopLoading()
    WZLog("WndBlessBag:operateOK", equipPrayId:size(), bagIds:size(), fightNum)
    self.m_nBlessFighting = fightNum
    --同步到祈福屋中
    WndBless:resetFighting(fightNum)
    
    if self.m_nOperateType == 1 then 
        self:dressUpDealWith(self.m_tDressUpData, self.m_tTakeOffData)
        self.m_tTakeOffData = nil
        self.m_tDressUpData = nil 
    elseif self.m_nOperateType == 2 then
        self:takeOffDealWith(self.m_tTakeOffData)
        self.m_tTakeOffData = nil
    end
    --更新战力
    local txtBlessFighting = GetElement(self.m_root, "txtBlessFighting_WndBlessBag", WZUILabelTTF)
    txtBlessFighting:setText(LocalStrings.BLESS_FIGHTING .. self.m_nBlessFighting)
end

--@brief    更新祝福战力加成
--@param    fighting:当前最新战力
function WndBlessBag:updateRoleFighting(fighting)
    -- body
    self.m_nBlessFighting = fighting
    --同步到祈福屋中
    WndBless:resetFighting(fighting)
    --更新战力
    local txtBlessFighting = GetElement(self.m_root, "txtBlessFighting_WndBlessBag", WZUILabelTTF)
    txtBlessFighting:setText(LocalStrings.BLESS_FIGHTING .. self.m_nBlessFighting)
end

--@brief    装备祝福后，数据的更新处理
--@param    tEquipData: 装备的祝福数据
--@param    tTakeOffData: 如果是装备到空的格子，则这个数据为空，如果是挤掉相应的属性的格子中的祝福，则是被挤掉的祝福的数据
function WndBlessBag:dressUpDealWith(tEquipData, tTakeOffData)
    --body
    --将被挤掉的祝福放到背包栏
    --将卸下的祝福放到背包中
    if tTakeOffData then
        self:_updateBagListShow(tTakeOffData, true)
    end
    WZLog("WndBlessBag:dressUpDealWith")
    local nIndex = self.m_nEquipRectIndex
    --更新相应的装备栏的显示
    local conEquipGrid = GetElement(self.m_root, string.format("conEquipGrid%d_WndBlessBag", nIndex), WZUIContainer)
    conEquipGrid:removeChildByTag(999, true)

    self.m_tEquipList[nIndex].status = 1
    tEquipData.userType = 3
    self.m_tEquipList[nIndex].tData = tEquipData
    
    local cellElement, tNewObj = CellBlessItem:createElement()
    if cellElement and tNewObj then
        cellElement:setTag(999)
        tNewObj:setCallBackFun(self, self.onClickDevour, self.onClickEquip, self.onClickTakeOff)
        tNewObj:setData(self.m_tEquipList[nIndex].tData, 2, self.m_root)
        conEquipGrid:addChild(cellElement)
    end
    --更新背包栏的显示
    self:_updateBagListShow(tEquipData, false)
    --背包底部数值
    self:_updateGridsNum()
    --更新祈福屋中背包和装备栏的数据
    WndBless:resetBagAndEquipList(self.m_tBlessItemList, self.m_tEquipList)
end

--@brief    卸下数据更新处理
--@param    卸下的祝福数据
function WndBlessBag:takeOffDealWith(tData)
    -- body
    --移除掉装备栏的祝福
    local nEquiConIndex = nil    
    for i = 1, #self.m_tEquipList do
        if self.m_tEquipList[i].status == 1 then
            local tTempData = self.m_tEquipList[i].tData 
            if tTempData.blessId == tData.blessId then
                nEquiConIndex = i 
                break 
            end
        end
    end
    WZLog("WndBlessBag:takeOffDealWith", nEquiConIndex)
    if nEquiConIndex then
        local conEquipGrid = GetElement(self.m_root, string.format("conEquipGrid%d_WndBlessBag", nEquiConIndex), WZUIContainer)
        conEquipGrid:removeChildByTag(999, true)
        --添加加号图标
        self.m_tEquipList[nEquiConIndex].status = 0
        self.m_tEquipList[nEquiConIndex].tData = nil 
        local imgPlusIcon = self:_createPlusIcon()
        imgPlusIcon:setTag(999)
        conEquipGrid:addChild(imgPlusIcon)
    end
    --将卸下的祝福放到背包中
    self:_updateBagListShow(tData, true)
    --背包底部数值
    self:_updateGridsNum()
    --更新祈福屋中背包和装备栏的数据
    WndBless:resetBagAndEquipList(self.m_tBlessItemList, self.m_tEquipList)
end

--@brief    购买成功后，更新背包列表祝福数据
--@param    新增的祝福数据
function WndBlessBag:resetBagList(blessId, id, exp)
    if self.m_root == nil then return end
    WZLog("WndBlessBag:resetBagList")
    local tAddItemList = {}
    for i = 0, blessId:size() - 1 do 
        local nId = id:get(i)
        local tData = CopyTable(GDatatab_pray["id_"..nId])
        tData.userType = 2
        tData.curExp = exp:get(i)
        tData.blessId = blessId:get(i)
        tData.basicInfo = CopyTable(GDatatab_item["id_"..tData.item_id])
        tData.name = tData.basicInfo.name

        table.insert(tAddItemList, tData)
    end

    for i = 1, #tAddItemList do
        self:_updateBagListShow(tAddItemList[i], true)
    end
    --背包底部数值
    self:_updateGridsNum()

    --更新祈福屋中背包和装备栏的数据
    WndBless:resetBagAndEquipList(self.m_tBlessItemList, nil)
end

--@brief    弹出选择祝福界面
--@param    
function WndBlessBag:onSelectEquipBlessItem(element)
    -- body
    WZLog("WndBlessBag:onSelectEquipBlessItem")
    local tTempEquipList = self:_generalBlessItemsForEquip()
    if tTempEquipList == nil or #tTempEquipList == 0 then
        SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESSITEM_CAN_EQUIP)
        return
    end
    local parentTag = element:getParent():getTag()
    WZLog("WndBlessBag:onSelectEquipBlessItem",parentTag)
    self.m_nEquipRectIndex = parentTag
    --自动计算战力最高的祝福装备
    table.sort(tTempEquipList, function (a,b)
        -- body
        local fightingA = WndBlessBag:_caculateFighting(a.property)
        local fightingB = WndBlessBag:_caculateFighting(b.property)
        if fightingA ~= fightingB then
            return fightingA > fightingB 
        else
            return a.blessId < b.blessId
        end
    end)
    local tData = tTempEquipList[1]
    WZLog("WndBlessBag:onSelectEquipBlessItem  1111",tData.blessId)
    self:onClickEquip(tData, self.m_nEquipRectIndex)
    --通过玩家自己选择装备的祝福
--    WndDevour:show(2, tTempEquipList, self, self.onClickEquip, self.m_nEquipRectIndex)
end

--@brief    点击角色
--@note     播放另外一个动画
function WndBlessBag:onClickRole(element)
    -- body
    WZLog("WndBlessBag:onClickRole")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tRoleAni == nil or self.m_bIsPlaying == true then return end
    self.m_bIsPlaying = true
    self.m_tRoleAni:play(g_tRoleAnitionName[2],false)
    local conRole = GetElement(self.m_root, "conRole_WndBlessBag", WZUIContainer)
    conRole:enableSchedule("changeRoleAni")
end

--@brief    角色relax动画播完的回调
function WndBlessBag:changeRoleAni(element, delta)
    -- body
    if not self.m_tRoleAni:isPlaying() then
        local isEnd = self.m_tRoleAni:isCurrentAnimationDone()
        if isEnd then
            self.m_tRoleAni:play("wait0", true)
            element:disableSchedule()
            self.m_bIsPlaying = false
        end
    end
end

--@brief    点击一键装备按钮回调
function WndBlessBag:onClickQuickEquip(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local tTempEquipList = self:_generalBlessItemsForEquip()
    if tTempEquipList == nil or #tTempEquipList == 0 then
        MsgBoxManager:showTipBox(LocalStrings.NO_BLESSITEM_CAN_EQUIP)
        return
    end

    local rectIndex = nil 
    for i = 1, #self.m_tEquipList do
        if self.m_tEquipList[i].status == 0 then
            rectIndex = i 
            break
        end
    end

    if not rectIndex then
        MsgBoxManager:showTipBox(LocalStrings.NO_USE_EQUIP_RECT)
        return
    end

    --发送一键装备协议
    self:_createLoading()
    self.m_nOperateType = 1
    ProtocolProcessorBless:send_PRAY_FastEquip( )
end

--@brief    点击祈福属性按钮回调
function WndBlessBag:onClickProperty(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tData = {}
    tData.property = self:caculateProperty()
    tData.fighting = self.m_nBlessFighting

    WndTips:show(element,self.m_root,42,tData, GlobalMethod:ccp(200, 200))
end

--@brief  点击限时特惠礼包按钮回调
function WndBlessBag:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    添加顶部钻石栏
function WndBlessBag:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/common/common_icon_qifubb.png", WndBlessBag, WndBlessBag.onCloseClick, true, false, false,nil,{goldType = 3})
    self.m_root:addChild(celElement)

    self.m_topCellLua = tNewObj
end

--@brief    创建角色动画
function WndBlessBag:_createPlayer()
    -- body
    local conTitle = GetElement(self.m_root, "conTitle_WndBlessBag", WZUIContainer)
    local txtTitle = GetElement(self.m_root, "txtTitle_WndBlessBag", WZUILabelTTF)
    local tempPoint = GlobalMethod:ccp(0.5,1.32)
    if CacheCenter:getPlayerInfo().title == nil or CacheCenter:getPlayerInfo().title == "" then
        conTitle:setVisible(false)
    else
        conTitle:setVisible(true)
        CreateDesiSpine(conTitle, txtTitle, CacheCenter:getPlayerInfo().title, tempPoint, true)
    end

    local sex = CacheCenter:getPlayerInfo().sex
    local tEquip = CacheCenter:getEquipmentList()
    WZLog("****** WndBlessBag:_createPlayer ******", Serialize(tEquip))
    local headColor, bodyColor = CacheCenter:getHeadAndBodyColor()
    local con = CreatePlayerFigure( sex , tEquip, nil, nil, nil, nil, nil, nil, nil, nil, headColor, bodyColor)
    self.m_tRoleAni = con

    local conRole = GetElement(self.m_root, "conRole_WndBlessBag", WZUIContainer)
    con:getAnimNode():setAnchorPoint(GlobalMethod:ccp(0.5, 0))
    con:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5, 0))
    conRole:addChild(con:getAnimNode())
end

--@brief    创建背包格子
function WndBlessBag:_createItemGrids()
    -- body
    local tableBagList = GetElement(self.m_root, "tableBagList_WndBlessBag", WZUITableContainer)
    local nMaxNum = self.m_nMaxGridsNum
    if self.m_tCellGridsList == nil then
        self.m_tCellGridsList = {}
    end
    for i = 1, nMaxNum do
        WZLog("*****WndBlessBag:_createItemGrids*****")
        local element, tCell = CellBlessItem:createElement()
        WZLog("****** WndBlessBag:_createItemGrids ******", tostring(element), tostring(tCell))
        if element and tCell then
            element:setTag(i - 1)
            tableBagList:setCellElement(element)
            tCell:setData(nil, 1)
            table.insert(self.m_tCellGridsList, tCell)
        end
    end

    local isEndTeach, step = TeachGroup1:isTeachFinish(42)
    if isEndTeach ~= true and CacheCenter:getPlayerInfo().level == 24 then
        TeachGroup1:startGroup({42,7,tableBagList})
    else
        TeachGroup1:removeTeach()
    end
end

--@brief    更新背包左边栏数据
function WndBlessBag:_updateLeftInfo()
    -- body
    local txtBlessFighting = GetElement(self.m_root, "txtBlessFighting_WndBlessBag", WZUILabelTTF)
    txtBlessFighting:setText(LocalStrings.BLESS_FIGHTING .. self.m_nBlessFighting)
    WZLog("WndBlessBag:_updateLeftInfo")
    for i = 1, #self.m_tEquipList do
        local conEquipGrid = GetElement(self.m_root, string.format("conEquipGrid%d_WndBlessBag", i), WZUIContainer)
        if conEquipGrid:getChildByTag(999) then
            conEquipGrid:removeChildByTag(999, true)
        end
        if self.m_tEquipList[i].status == -1 then       --未开启
            local txtOpenLevel = self:_createLabelTTF(self.m_tEquipList[i].openLevel)
            txtOpenLevel:setTag(999)
            conEquipGrid:addChild(txtOpenLevel)
        elseif self.m_tEquipList[i].status == 0 then    --已开启，没装备
            local imgPlusIcon = self:_createPlusIcon()
            imgPlusIcon:setTag(999)
            conEquipGrid:addChild(imgPlusIcon)
        elseif self.m_tEquipList[i].status == 1 then    --已装备
            local cellElement, tNewObj = CellBlessItem:createElement()
            if cellElement and tNewObj then
                cellElement:setTag(999)
                tNewObj:setCallBackFun(self, self.onClickDevour, self.onClickEquip, self.onClickTakeOff)
                tNewObj:setData(self.m_tEquipList[i].tData, 2, self.m_root)
                conEquipGrid:addChild(cellElement)
            end
        end
    end

end

--@brief    更新背包底部数值
function WndBlessBag:_updateGridsNum()
    -- body
    local fitemNum = GetElement(self.m_root, "fitemNum_WndBlessBag", WZUIFreeTextBox)
    local formatNum = [[<T C="79,60,48" S="22" P="1">%s：</T><T C="128,54,13" S="22" P="1">%s</T>]]
    if self.m_tBlessItemList then
        local txtGridsNum = #self.m_tBlessItemList .. "/" .. self.m_nMaxGridsNum
        fitemNum:setShowText(string.format(formatNum, LocalStrings.NUM1, txtGridsNum))
    end
end

--@brief    创建等级开放文字
function WndBlessBag:_createLabelTTF(nOpenLevel)
    -- body
    local txtOpenLevel = WZUIFreeTextBox:create()
    txtOpenLevel:setMaxWidth(78)
    txtOpenLevel:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
    txtOpenLevel:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
    local sOpenLevel = string.format(LocalStrings.BLESS_EQUIP_OPEN_ATT, nOpenLevel)
    txtOpenLevel:setShowText(sOpenLevel)

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
        txtOpenLevel:setMaxWidth(130)
        txtOpenLevel:setRelativePosition(GlobalMethod:ccp(0.515,0.5))
        txtOpenLevel:setScale(0.9)
    end

    return txtOpenLevel
end

--@brief    创建+号图标
function WndBlessBag:_createPlusIcon()
    -- body
    local btnPlus = WZUIButton:create()

    local imgPlusIcon = WZUIImage:create()
    imgPlusIcon:setFile("ui/common/common_icon_cwjh.png")
    imgPlusIcon:setUseOriginSize(true)
    imgPlusIcon:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    imgPlusIcon:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    imgPlusIcon:setScale(0.8)
    --选中图片
    local imgPlusIconSel = WZUIImage:create()
    imgPlusIconSel:setFile("ui/common/common_icon_cwjh.png")
    imgPlusIconSel:setUseOriginSize(true)
    imgPlusIconSel:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    imgPlusIconSel:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    imgPlusIconSel:setScale(0.8)

    btnPlus:setNormalElement(imgPlusIcon)
    btnPlus:setSelectElement(imgPlusIconSel)
    btnPlus:setLuaActionName("Normal")
    btnPlus:setLuaDoneFunctionName("onSelectEquipBlessItem")

    return btnPlus
end

--@brief    获取当前类型的祝福最高等级
function WndBlessBag:_getMaxLevel(itemId)
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
function WndBlessBag:_generalBlessItemsForDevour(tData)
    -- body
    local nMaxLevel = self:_getMaxLevel(tData.item_id)
    local tTemp = {}
    --挑选品质低于当前，或品质相同但还没到达最高等级的祝福
    for i = 1, #self.m_tBlessItemList do
        WZLog("WndBlessBag:_generalBlessItemsForDevour", self.m_tBlessItemList[i].basicInfo.sub_type, self.m_tBlessItemList[i].basicInfo.name)
        if self.m_tBlessItemList[i].basicInfo.sub_type == 32 or (tData.blessId ~= self.m_tBlessItemList[i].blessId and self.m_tBlessItemList[i].basicInfo.sub_type ~= 31 and tData.quality >= self.m_tBlessItemList[i].quality and self.m_tBlessItemList[i].quality < 4 ) then
            local tBlessTemp = self.m_tBlessItemList[i]
            tBlessTemp.bIsChoose = false
            table.insert(tTemp, tBlessTemp)
        end
    end

    return tTemp
end

--@brief    生成可用于装备的所有祝福
function WndBlessBag:_generalBlessItemsForEquip()
    -- body
    local tTemp = {}
    --挑选不是垃圾，不是经验，不是噩运的祝福
    for i = 1, #self.m_tBlessItemList do
        if self.m_tBlessItemList[i].basicInfo.sub_type ~= 30 and self.m_tBlessItemList[i].basicInfo.sub_type ~= 31 and self.m_tBlessItemList[i].basicInfo.sub_type ~= 32 then
            local bIsEquipSameType = false
            --屏蔽掉已经装备的同类型的祝福
            for j = 1, #self.m_tEquipList do
                if self.m_tEquipList[j].status == 1 and self.m_tBlessItemList[i].basicInfo.sub_type == self.m_tEquipList[j].tData.basicInfo.sub_type then
                    bIsEquipSameType = true
                    break
                end
            end
            if bIsEquipSameType == false then
                local tBlessTemp = self.m_tBlessItemList[i]
                tBlessTemp.bIsChoose = false
                table.insert(tTemp, tBlessTemp)
            end
        end
    end

    return tTemp
end

--@brief    返回可用于装备的空装备栏索引，没有，则返回nil
--@param    tData : 要装备的祝福的数据
function WndBlessBag:_getCanUseEquipIndex(tData)
    -- body
    local nIndex = nil 
    local bIsEquipSame = false  --是否已经装备同类型的祝福
    for i = 1, #self.m_tEquipList do
        if self.m_tEquipList[i].status == 1 and self.m_tEquipList[i].tData.basicInfo.sub_type == tData.basicInfo.sub_type then
            self.m_tTakeOffData = self.m_tEquipList[i].tData
            nIndex = i 
            bIsEquipSame = true
            break
        end
    end

    if nIndex then
        return nIndex, bIsEquipSame
    end

    for i = 1, #self.m_tEquipList do
        if self.m_tEquipList[i].status == 0 then
            nIndex = i 
            break
        end
    end

    return nIndex, bIsEquipSame
end

--@brief    更新背包栏显示
--@param    tData:增加或减少的祝福数据
--@param    bIsAdd : true:是新增数据，false:是减少数据
function WndBlessBag:_updateBagListShow(tData, bIsAdd)
    -- body
    WZLog("WndBlessBag:_updateBagListShow")
    local nIndex = 0 
    if bIsAdd then
        tData.userType = 2   --标记在背包栏
        table.insert(self.m_tBlessItemList, tData)
        table.sort(self.m_tBlessItemList, sortBlessItem)
    end

    for i = 1, #self.m_tBlessItemList do
        if tData.blessId == self.m_tBlessItemList[i].blessId then
            nIndex = i
        end
    end

    if not bIsAdd then
        self.m_tCellGridsList[#self.m_tBlessItemList]:setData(nil, 1)
        table.remove(self.m_tBlessItemList, nIndex)
    end

    for i = nIndex, #self.m_tBlessItemList do
        if self.m_tCellGridsList[i] then
            self.m_tCellGridsList[i]:setCallBackFun(self, self.onClickDevour, self.onClickEquip, self.onClickTakeOff)
            self.m_tCellGridsList[i]:setData(self.m_tBlessItemList[i], 4, self.m_root)
        end
    end
end

--@brief    查找品质最高可吞噬其他祝福的祝福
function WndBlessBag:_findTheHeightestBlessItem()
    -- body
    -- body
    local tHeightestItem = self.m_tBlessItemList[1] 
    if self.m_tBlessItemList[1].basicInfo.sub_type == 31 or self.m_tBlessItemList[1].basicInfo.sub_type == 32 or tHeightestItem.level >= self:_getMaxLevel(tHeightestItem.level) then
        for i = 1, #self.m_tBlessItemList do
            if self.m_tBlessItemList[i].basicInfo.sub_type ~= 31 and self.m_tBlessItemList[i].basicInfo.sub_type ~= 32 and self.m_tBlessItemList[i].level < self:_getMaxLevel(self.m_tBlessItemList[i].item_id) then
                tHeightestItem = self.m_tBlessItemList[i]
                break 
            end
        end
    end

    --找出品质最高的
    for i = 2, #self.m_tBlessItemList do
        if self.m_tBlessItemList[i].basicInfo.sub_type ~= 31 and self.m_tBlessItemList[i].basicInfo.sub_type ~= 32 and self.m_tBlessItemList[i].quality > tHeightestItem.quality and self.m_tBlessItemList[i].level < self:_getMaxLevel(self.m_tBlessItemList[i].item_id) then
            tHeightestItem = self.m_tBlessItemList[i]
            break 
        end
    end
    --找出同品质中等级最高的
    for i = 1, #self.m_tBlessItemList do
        if self.m_tBlessItemList[i].quality == tHeightestItem.quality and self.m_tBlessItemList[i].level < self:_getMaxLevel(self.m_tBlessItemList[i].item_id) then 
            if self.m_tBlessItemList[i].id > tHeightestItem.id then
                tHeightestItem = self.m_tBlessItemList[i]
            elseif self.m_tBlessItemList[i].id == tHeightestItem.id then
                if self.m_tBlessItemList[i].level == tHeightestItem.level then 
                    if self.m_tBlessItemList[i].curExp > tHeightestItem.curExp then
                        tHeightestItem = self.m_tBlessItemList[i]
                    end
                else
                    if self.m_tBlessItemList[i].level > tHeightestItem.level then 
                        tHeightestItem = self.m_tBlessItemList[i]
                    end
                end
            end
        end
    end
    --找出是否有可被吞噬的祝福
    local bIsCanDevourAll = false
    for i = 1, #self.m_tBlessItemList do
        if self.m_tBlessItemList[i].blessId ~= tHeightestItem.blessId and self.m_tBlessItemList[i].basicInfo.sub_type ~= 31 and ((self.m_tBlessItemList[i].basicInfo.sub_type ~= 32 and ((tHeightestItem.quality >= 3 and self.m_tBlessItemList[i].quality < tHeightestItem.quality) or (tHeightestItem.quality < 3 and self.m_tBlessItemList[i].quality <= tHeightestItem.quality))) or self.m_tBlessItemList[i].basicInfo.sub_type == 32) then
            bIsCanDevourAll = true
        end
    end

    return tHeightestItem, bIsCanDevourAll
end

--@brief    数据加载动画
function WndBlessBag:_createLoading()
    -- body
    self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief    加载动画停止
function WndBlessBag:_stopLoading()
    -- body
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    self.m_nLoadingId = nil 
end
-------------------------------------私有方法模块End----------------------------------------

------------------------------------------语言适配Begin---------------------------------------
function WndBlessBag:_adaptLanguage_en(  )
    local txtDevour = GetElement(self.m_root,"txtDevourAll_WndBlessBag",WZUILabelTTF)
    txtDevour:setScale(0.8)
    txtDevour:setDimensions(GlobalMethod:CCSize(110,0))

    GetElement(self.m_root,"txtTitle_WndBlessBag",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtShop_WndBlessBag",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtFuse_WndBlessBag",WZUILabelTTF):setScale(0.9)

    local txtFuse = GetElement(self.m_root,"txtFuse_WndBlessBag",WZUILabelTTF)
    txtFuse:setScale(0.8)
    txtFuse:setDimensions(GlobalMethod:CCSize(110,0))

    GetElement(self.m_root,"txtEquipAll_WndBlessBag",WZUILabelTTF):setFontSize(11)
end

function WndBlessBag:_adaptLanguage_pt(  )
    -- local txtDevour = GetElement(self.m_root,"txtDevourAll_WndBlessBag",WZUILabelTTF)
    -- txtDevour:setScale(0.8)
    -- txtDevour:setDimensions(GlobalMethod:CCSize(110,0))
    --GetElement(self.m_root,"txtTitle_WndBlessBag",WZUILabelTTF):setFontSize(22)
    -- local txtFuse = GetElement(self.m_root,"txtFuse_WndBlessBag",WZUILabelTTF)
    -- txtFuse:setScale(0.8)
    -- txtFuse:setDimensions(GlobalMethod:CCSize(110,0))

    --GetElement(self.m_root,"txtShop_WndBlessBag",WZUILabelTTF):setScale(0.77)
    GetElement(self.m_root,"txtEquipAll_WndBlessBag",WZUILabelTTF):setFontSize(10)
    GetElement(self.m_root,"txtBlessPro_WndBlessBag",WZUILabelTTF):setFontSize(14)
    
    GetElement(self.m_root,"txtTitle_WndBlessBag",WZUILabelTTF):setScale(0.8)
end

function WndBlessBag:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtShop_WndBlessBag",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtFuse_WndBlessBag",WZUILabelTTF):setScale(0.7)
    --GetElement(self.m_root,"txtTitle_WndBlessBag",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtEquipAll_WndBlessBag",WZUILabelTTF):setFontSize(11)
    GetElement(self.m_root,"txtBlessPro_WndBlessBag",WZUILabelTTF):setFontSize(14)
end

function WndBlessBag:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtShop_WndBlessBag",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"txtBlessPro_WndBlessBag",WZUILabelTTF):setFontSize(12)

    local txtFuse = GetElement(self.m_root,"txtFuse_WndBlessBag",WZUILabelTTF)
    txtFuse:setScale(0.7)
    txtFuse:setDimensions(GlobalMethod:CCSize(130,0))
end

function WndBlessBag:_adaptLanguage_es(  )
    local txtShop = GetElement(self.m_root,"txtShop_WndBlessBag",WZUILabelTTF)
    txtShop:setDimensions(GlobalMethod:CCSize(130,0))
    txtShop:setScale(0.8)

    local txtFuse = GetElement(self.m_root,"txtFuse_WndBlessBag",WZUILabelTTF)
    txtFuse:setDimensions(GlobalMethod:CCSize(130,0))
    txtFuse:setScale(0.8)
    
    -- local txtDevourAll = GetElement(self.m_root,"txtDevourAll_WndBlessBag",WZUILabelTTF)
    -- txtDevourAll:setDimensions(GlobalMethod:CCSize(130,0))
    -- txtDevourAll:setScale(0.8)

    GetElement(self.m_root,"txtEquipAll_WndBlessBag",WZUILabelTTF):setFontSize(10)
    GetElement(self.m_root,"txtBlessPro_WndBlessBag",WZUILabelTTF):setFontSize(14)
    
    GetElement(self.m_root,"txtTitle_WndBlessBag",WZUILabelTTF):setScale(0.8)
end

function WndBlessBag:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtEquipAll_WndBlessBag",WZUILabelTTF):setFontSize(13)
    GetElement(self.m_root,"txtBlessPro_WndBlessBag",WZUILabelTTF):setFontSize(14)
end

function WndBlessBag:_adaptLanguage_hk(  )
    GetElement(self.m_root,"txtTitle_WndBlessBag",WZUILabelTTF):setScale(0.8)
end
------------------------------------------语言适配End-------------------------------------------