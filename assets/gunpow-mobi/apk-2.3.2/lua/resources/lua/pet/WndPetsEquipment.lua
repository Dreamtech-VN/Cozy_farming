--WndPetsEquipment.lua
--@brief	WndPetsEquipment的UI模块
--@date		2022/04/25
--@author	yrd
--@note		宠物装备


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPetsEquipment:onEnter(element)
	self.m_root = element

    self:setInterfaceType(self.m_nInterfaceType)
    self:updateCurPetInfo()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPetsEquipment:onExit(element)
    CacheCenter:unregisterUpdatePetEquipObserver(self)
    CacheCenter:unregisterPetEuqipSchemeObserver(self)
	self:_unInit()
end

--@brief    加载动画
function WndPetsEquipment:onEnterTransitionDidFinish(element)
    self:_createItemGrids1()
    self:_createItemGrids2()
    CacheCenter:registerUpdatePetEquipObserver(self) --注册宠物装备
    CacheCenter:registerPetEuqipSchemeObserver(self) --注册多套宠物装备方案
end

--@brief    更新界面
function WndPetsEquipment:updateUI()
    self:showPetInfo()
    self:showPetItem()
    self:updateBag()
end


--@brief  显示宠物信息 
function WndPetsEquipment:showPetInfo()
    if self.m_tCurPetsInfo == nil then
        return
    end
  --星星品质
    local aptitude = WndPets:getAptitude(self.m_tCurPetsInfo.giftSkill)
    for i = 1, 7 do
        GetElement(self.m_root,"imgAptitude"..i.."_WndPetsEquipment",WZUIImage):setVisible(i <= aptitude)
    end
    WndPets:setAptitudePost(self.m_root, "conAptitude_WndPetsEquipment", aptitude)
    --名字
    local nameText = GetElement(self.m_root,"txtPetName_WndPetsEquipment",WZUIFreeTextBox)
    self:setPetName(self.m_tCurPetsInfo.itemId, nameText)

    --宠物形象
    local conPetAni = GetElement(self.m_root,"conPetAni_WndPetsEquipment",WZUIContainer)
    conPetAni:removeAllChildrenWithCleanup(true)
    self.petAni = CreatePetAni(conPetAni, nil, self.m_tCurPetsInfo.animation, self.m_tCurPetsInfo.advancedLevel, self.m_tCurPetsInfo.petSkinItemId)
    -- self:playAttackAni()

    local txtPhantoming = GetElement(self.m_root, "txtPhantoming_WndPetsEquipment", WZUILabelTTF)
    if txtPhantoming then
        if self.m_tCurPetsInfo.petSkinItemId > 0 then
            txtPhantoming:setVisible(true)
        else
            txtPhantoming:setVisible(false)
        end
    end
end

--@brief 判断是否是经验宝宝
--@param petId 宠物的id
function WndPetsEquipment:isExpPet(petId)
    if GDatatab_item["id_"..petId].sub_type == 0 then
        return true
    end
    return false
end

--@brief 根据宠物Id获取宠物类型图标
function WndPetsEquipment:getTypeById(petId)
    WZLog("WndPetsEquipment:getTypeById:",petId)
    local petType = 0
    for k, v in pairs(GDatatab_pet) do
        if v.item_id == petId then
            petType = v.id_type
        end
    end
    if petType == 1 then --生命
        return "ui/common/common_cw_xue.png"
    elseif petType == 2 then --攻击
        return "ui/common/common_cw_gong.png"
    elseif petType == 3 then --防御
        return "ui/common/common_cw_fang.png"
    elseif petType == 4 then --均衡
        return "ui/common/common_cw_jun.png"
    elseif petType == 5 then --经验
        return "ui/common/common_cw_exp.png"
    end
    return ""
end

--@brief   根据不同宠物的品质设置不同的字体颜色
--@param nNum 宠物的品质
--@param sName 宠物的名称
--@param txtObj 字体的节点
--@param nLevel 宠物的进阶等级
--@param bShowWar 是否显示出战状态
--@param nlv 宠物等级
function WndPetsEquipment:setPetName(nNum,txtObj,sName, nLevel, bShowWar, nlv)
    WZLog("WndPetsEquipment:setPetName:",bShowWar)
    if nNum == nil then return end

    local txtColor = g_sFtxtQualityColor
    local petQuality = GDatatab_item["id_"..nNum].quality
    local level = nLevel or self.m_tCurPetsInfo.advancedLevel
    local lv = nlv or self.m_tCurPetsInfo.upgradeLevel
    local color = txtColor[petQuality]
    local s0 = self:getTypeById(nNum)
    if sName ~= null then
        sName = " "..sName
    end
    local s1 = sName or " "..self.m_tCurPetsInfo.name
    s1 = " Lv"..lv..s1
    local s2 = ""
    if level >= 1 then
        s2 = " +"..level
    end
    local s3 = ""
    if bShowWar == nil or bShowWar == true then
        if self.m_tCurPetsInfo.isInUsed then
            s3 = "("..LocalStrings.PETATWAR..")"
        else
            s3 = "("..LocalStrings.PETREST..")" 
        end
    end
    if self:isExpPet(nNum)  then
        s3 = ""
    end
    local sLevel = string.format([[<I>%s</I><T C=%s S="22" P="1" SE="1" SS="4" SC="132,66,29">%s</T><T C="0,255,0" S="22" P="1" SE="1" SS="4" SC="132,66,29">%s</T><T C="255,89,74" S="22" P="1" SE="1" SS="4" SC="132,66,29">%s</T>]],s0,color, s1, s2, s3)
    txtObj:setShowText(sLevel)
end

--@brief    宠物功能按钮点击调用的函数
--@param    element:表绑定的UI节点引用
function WndPetsEquipment:onFunctionClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    local tag = element:getTag()
    if tag == 1 then
        if CheckButtonOpen(40) then
            WndStrengthen:jumpTo(1)
        end
    elseif tag == 2 then
        if CheckButtonOpen(41) then
            WndStrengthen:jumpTo(2)
        end
    elseif tag == 3 then
        if CheckButtonOpen(43) then
            WndStrengthen:jumpTo(3)
        end
    elseif tag == 4 then
        if CheckButtonOpen(80) then
            WndAscending:jumpTo(1)
        end
    elseif tag == 5 then
        WndPetRecover:showInterface(2)
    elseif tag == 6 then --继承
        self:setInterfaceType(2)
    end
end

--@brief    设置界面类型 1装备界面 2继承界面
function WndPetsEquipment:setInterfaceType(nType)
    self.m_nInterfaceType = nType

    local conInterface1 = GetElement(self.m_root,"conInterface1_WndPetsEquipment",WZUIContainer)
    local conInterface2 = GetElement(self.m_root,"conInterface2_WndPetsEquipment",WZUIContainer)
    if nType == 1 then
        conInterface1:setVisible(true)
        conInterface2:setVisible(false)
    elseif nType == 2 then
        conInterface1:setVisible(false)
        conInterface2:setVisible(true)

        self:initInheritUI()
    end
end

--@brief    点击规则按钮
function WndPetsEquipment:onClickRule(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface1(LocalStrings.PET_EQUIPMENT_2)
end


--@brief   设置宠物装备
function WndPetsEquipment:showPetItem()
    WZLog("WndPetsEquipment:showPetItem")
    if self.m_tEquipItemObjList == nil then self:initEquipGrid() end
    for i=1,6 do
        if self.m_tEquipItemDataList[i] and self.m_tEquipItemDataList[i].id ~= 0 then
            self.m_tEquipItemObjList[i]:setCellGoodItem(self.m_tEquipItemDataList[i],1)
            GetElement(self.m_tEquipItemObjList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_js_zb_di.png")
            GetElement(self.m_tEquipItemObjList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
        else
            local tCell = self.m_tEquipItemObjList[i]
            tCell:removeAllChild()
            GetElement(tCell.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_js_zb_di.png")
            GetElement(tCell.m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
            GetElement(tCell.m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_js_zb_di.png")
            GetElement(tCell.m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_js_zb_di.png")
        end

        --装备栏位置没有物品时，显示该位置应该放置的物品类型图片
        self:_createBlankText(i)
    end
end

--@brief    初始化6个装备格子
function WndPetsEquipment:initEquipGrid()
    WZLog("WndPetsEquipment:initEquipGrid")
    self.m_tEquipItemObjList = {}
    for i=1,6 do
        local con = self.m_root:getChildElement("conEquip"..i.."_WndPetsEquipment")
        if con ~= nil then
            local cellElement,tLuaObj = CellGoodItem:createElement()
            if cellElement ~= nil and tLuaObj ~= nil then
                tLuaObj:setItemClickFun(self,self.onEquipBackFun)
                con:addChild(cellElement)
                cellElement:setTag(i)
                table.insert(self.m_tEquipItemObjList,tLuaObj)
            end
        end
    end
end

--@brief    点击装备格子回调
function WndPetsEquipment:onEquipBackFun(luaTable,tag,tData)
    local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)

    local tagToSubType = {0,1,2,3,4,5}
    local tagToId = {0,1,2,3,4,5}
    local tBagData = self:getBagDataBySubType(tagToSubType[tag])
    if tBagData == nil or #tBagData == 0 then
        WndFastGetItems:show(7820+tagToId[tag])
        return
    else
        self:setShowSubType(tagToSubType[tag])
        self:updateBag()
    end

    if tData == nil then
        WndItemInfo:showInfo(luaTable.m_root,conTips,3,LocalStrings.PET_EQUIPMENT_3[tag],false)
        return
    end
    self:_addTip1(tData,luaTable.m_root,conTips)--添加tip信息
end

--@brief    装备栏空白时的说明
function WndPetsEquipment:_createBlankText(tag)
    local sName = "conEquip%d_WndPetsEquipment"
    sName = string.format(sName,tag)
    local con = self.m_root:getChildElement(sName)
    if con:getChildByTag(80+tag) then
        con:removeChildByTag(80+tag,true)
    end

    if self.m_tEquipItemDataList[tag] ~= nil and self.m_tEquipItemDataList[tag].id ~= 0 then return end

    --tag 1：利爪，2：战帽，3：铠甲，4：项圈，5：尾巴，6：护符
    local iconList = {"ui/pet/common_icon_cw_lz.png","ui/pet/common_icon_cw_tkj.png","ui/pet/common_icon_cw_kj.png",
            "ui/pet/common_icon_cw_xq.png","ui/pet/common_icon_cw_ws.png","ui/pet/common_icon_cw_ps.png",}
    local icon = iconList[tag]

    local img = WZUIImage:create()
    img:setFile(icon)
    img:setTag(80+tag)
    img:setUseOriginSize(true)
    img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    img:setTouchEnable(false)
    con:addChild(img)
end

--@brief    使用中装备显示tip信息
function WndPetsEquipment:_addTip1(tItem,element,pCell)
    WZLog("WndPetsEquipment:_addTip1",tItem,element,pCell)
    if tItem == nil or element == nil or pCell == nil then
        return
    end
    WndItemInfo:showInfo(element,pCell,1,tItem,true)
    --事件回调
    WndItemInfo:setUseFun(self,self.onItemApply)--穿上回调
    WndItemInfo:setRoyalFun(self,self.onItemRoyal)--卸下回调
end


--@brief    创建空背包格子
function WndPetsEquipment:_createItemGrids1()
    local tcItemBag = GetElement(self.m_root, "tcItemBag1_WndPetsEquipment", WZUITableContainer)
    self.m_tBagItemObjList = {}
    for i = 1, self.m_nMaxGridsNum do
        local cellElement,tLuaObj = CellGoodItem:createElement()
        if cellElement ~= nil and tLuaObj ~= nil then
            cellElement:setTag(i-1)
            tcItemBag:setCellElement(cellElement)
            table.insert(self.m_tBagItemObjList,tLuaObj)
            tLuaObj:setItemClickFun(self,self.onItemClick1)
        end
    end
end

--@brief    更新装备界面背包
function WndPetsEquipment:updateBag()
    WZLog("WndPetsEquipment:updateBag")
    self:updateBagShowData()
    local tcItemBag = GetElement(self.m_root,"tcItemBag1_WndPetsEquipment",WZUITableContainer)
    self.m_nStartIndex1 = 1
    tcItemBag:enableSchedule("_addBagSchedule1",0)
end

--@brief    每帧加载装备Cell
function WndPetsEquipment:_addBagSchedule1(element)
    local tcItemBag = GetElement(self.m_root,"tcItemBag1_WndPetsEquipment",WZUITableContainer)

    for i=self.m_nStartIndex1,self.m_nMaxGridsNum do
        if self.m_tEquipmentShowList[i] then
            self.m_tBagItemObjList[i]:setCellGoodItem(self.m_tEquipmentShowList[i],2)
        else
            self.m_tBagItemObjList[i]:removeAllChild()
        end
        self.m_nStartIndex1 = self.m_nStartIndex1 + 1
    end

    if self.m_nStartIndex1 > self.m_nMaxGridsNum then
        element:disableSchedule()
    end
end

--@brief    点击背包物品回调
function WndPetsEquipment:onItemClick1(luaTable,tag,tData)
    local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
    self:_addTip2(tData,luaTable.m_root,conTips)--添加tip信息
end

--@brief    背包中装备显示tip信息
function WndPetsEquipment:_addTip2(tItem,element,pCell)
    WZLog("WndPetsEquipment:_addTip2",tItem,element,pCell)
    WndItemInfo:closeWin()
    if tItem == nil or element == nil or pCell == nil then
        return
    end
    WndItemInfo:showInfo(element,pCell,1,tItem,true)
    --事件回调
    WndItemInfo:setUseFun(self,self.onItemApply)--穿上回调
    WndItemInfo:setRoyalFun(self,self.onItemRoyal)--卸下回调
end

--@brief    穿上回调
function WndPetsEquipment:onItemApply(luaTable,tData)
    WZLog("WndPetsEquipment:onItemApply")

    ProtocolProcessorScenePets:send_PET_PetWearORUnEquip(tData.playerItemId,CacheCenter:getCurPetEquipScheme())
end

--@brief    卸下回调
function WndPetsEquipment:onItemRoyal(luaTable,tData)
    WZLog("WndPetsEquipment:onItemRoyal")

    ProtocolProcessorScenePets:send_PET_PetWearORUnEquip(tData.playerItemId,CacheCenter:getCurPetEquipScheme())
end

--@brief    添加时装套装入口
function WndPetsEquipment:_addDressSuit()
    if CheckButtonOpen(223, false) then
        local conForDressSuit = GetElement(self.m_root, "conForDressSuit_WndPetsEquipment", WZUIContainer)
        if conForDressSuit then
            local wndDress, tCell = WndDressSuit:createElement()
            if wndDress and tCell then
                tCell:setType(10)
                self.m_tCellDressSuit = tCell
                conForDressSuit:addChild(wndDress)
            end
        end
    end
end

--@brief    隐藏方案
function WndPetsEquipment:hideScheme(element, pt)
    if self.m_tCellDressSuit and not self.m_tCellDressSuit:checkPointInBtn(pt) then
        self.m_tCellDressSuit:hideSuitList()
    end
end

-------------------------------------宠物装备继承-------------------------------------

--@brief    点击返回按钮
function WndPetsEquipment:onClickBack(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:setInterfaceType(1)
end

--@brief    点击继承按钮
function WndPetsEquipment:onTransfer(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tInheritItem1 == nil or self.m_tInheritItem2 == nil then
        MsgBoxManager:showTipBox(LocalStrings.PET_EQUIPMENT_18)
    end

    if self.m_tInheritItem1 then
        for k,v in pairs(GDatatab_pet_equip_extends) do
            if self.m_tInheritItem1:getData().basicInfo.quality == v.quality and self.m_tInheritItem1:getData().extraInfo.starLevel == v.star then
                local itemId = v.cost[1][1]
                local num = v.cost[1][2]
                if not JudgeMoneyIsEnough(itemId, num, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
                    return 
                end
            end
        end
    end

    if self.m_tInheritItem1 and self.m_tInheritItem2 then
        local playerItemId = self.m_tInheritItem1:getData().playerItemId
        local targetItem = self.m_tInheritItem2:getData().playerItemId
        ProtocolProcessorScenePets:send_PET_PetEquipExtends(playerItemId, targetItem)
    end

end

--@brief    更新继承界面
function WndPetsEquipment:initInheritUI()
    self.m_tInheritItem1 = nil
    self.m_tInheritItem2 = nil
    self:initInheritLeftUI()
    self:initInheritRightUI()
end

--@brief    更新继承左边界面
function WndPetsEquipment:initInheritLeftUI()
    self:setInheritQuality1(1)
    self:setInheritQuality2(1)

    local conEquipItem1 = GetElement(self.m_root,"conEquipItem1_WndPetsEquipment",WZUIContainer)
    local conEquipItem2 = GetElement(self.m_root,"conEquipItem2_WndPetsEquipment",WZUIContainer)
    conEquipItem1:removeAllChildrenWithCleanup(true)
    conEquipItem2:removeAllChildrenWithCleanup(true)

    local conAddIcon1 = GetElement(self.m_root,"conAddIcon1_WndPetsEquipment",WZUIContainer)
    local conAddIcon2 = GetElement(self.m_root,"conAddIcon2_WndPetsEquipment",WZUIContainer)
    conAddIcon1:setVisible(true)
    conAddIcon2:setVisible(true)

    self:updateInheritText()
end

--@brief    更新继承右边界面
function WndPetsEquipment:initInheritRightUI()
    self:setInheritSelectStatus(-1)
    self:updateInheritBag()
end

--@brief    创建空背包格子
function WndPetsEquipment:_createItemGrids2()
    local tcItemsBag2 = GetElement(self.m_root, "tcItemsBag2_WndPetsEquipment", WZUITableContainer)
    self.m_tBagItemsObjList2 = {}
    for i = 1, self.m_nMaxGridsNum do
        local cellElement,tLuaObj = CellGoodItem:createElement()
        if cellElement ~= nil and tLuaObj ~= nil then
            cellElement:setTag(i-1)
            tcItemsBag2:setCellElement(cellElement)
            table.insert(self.m_tBagItemsObjList2,tLuaObj)
            tLuaObj:setItemClickFun(self,self.onItemClick2)
        end
    end
end

--@brief    更新继承界面背包
function WndPetsEquipment:updateInheritBag()
    WZLog("WndPetsEquipment:updateBag")
    self:updateInheritShowData()
    local tcItemsBag2 = GetElement(self.m_root,"tcItemsBag2_WndPetsEquipment",WZUITableContainer)
    self.m_nStartIndex2 = 1
    tcItemsBag2:enableSchedule("_addBagSchedule2")
end

--@brief    每帧加载装备Cell
function WndPetsEquipment:_addBagSchedule2(element)
    local tcItemsBag2 = GetElement(self.m_root,"tcItemsBag2_WndPetsEquipment",WZUITableContainer)

    for i=self.m_nStartIndex2,self.m_nMaxGridsNum do
        if self.m_tInheritShowList[i] then
            self.m_tBagItemsObjList2[i]:setCellGoodItem(self.m_tInheritShowList[i],2)
        else
            self.m_tBagItemsObjList2[i]:removeAllChild()
        end
        self.m_nStartIndex2 = self.m_nStartIndex2 + 1
    end

    if self.m_nStartIndex2 > self.m_nMaxGridsNum then
        element:disableSchedule()
    end
end

--@brief    点击背包添加物品回调
function WndPetsEquipment:onItemClick2(luaTable,tag,tData)
    WZLog("WndPetsEquipment:onItemClick2",Serialize(tData))
    if tData == nil then return end
    --装备信息
    local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
    WndItemInfo:showInfo(luaTable.m_root,conTips,1,tData,true)
    WndItemInfo:setUseFun(self,self.onClickPutItem)
end

--@brief    放上装备到继承栏
function WndPetsEquipment:onClickPutItem(luaTable,tData)
    local conAddIcon1 = GetElement(self.m_root,"conAddIcon1_WndPetsEquipment",WZUIContainer)
    local conAddIcon2 = GetElement(self.m_root,"conAddIcon2_WndPetsEquipment",WZUIContainer)
    local conEquipItem1 = GetElement(self.m_root,"conEquipItem1_WndPetsEquipment",WZUIContainer)
    local conEquipItem2 = GetElement(self.m_root,"conEquipItem2_WndPetsEquipment",WZUIContainer)
    if self.m_tInheritItem1 == nil then

        --原装备无任何强化/升星/镶嵌/升品,提示"该装备无可继承项目,无法继承"
        if tData.basicInfo.quality ~= 4 and self:isZeroLvAndStar(tData) and self:isNoGem(tData) then
            MsgBoxManager:showTipBox(LocalStrings.PET_EQUIPMENT_19)
            return
        end

        local cellElement,tLuaObj = CellGoodItem:createElement()
        if cellElement ~= nil and tLuaObj ~= nil then
            conAddIcon1:setVisible(false)
            conEquipItem1:removeAllChildrenWithCleanup(true)
            conEquipItem1:addChild(cellElement)
            tLuaObj:setCellGoodItem(tData,2)
            tLuaObj:setItemClickFun(self,self.onClickInheritItem1)
            self.m_tInheritItem1 = tLuaObj
        end
        self:setInheritQuality1(tData.basicInfo.quality)

        self:updateInheritBag()

        self:updateInheritText()
    else
        local cellElement,tLuaObj = CellGoodItem:createElement()
        if cellElement ~= nil and tLuaObj ~= nil then
            conAddIcon2:setVisible(false)
            conEquipItem2:removeAllChildrenWithCleanup(true)
            conEquipItem2:addChild(cellElement)
            tLuaObj:setCellGoodItem(tData,2)
            tLuaObj:setItemClickFun(self,self.onClickInheritItem2)
            self.m_tInheritItem2 = tLuaObj
        end
        self:setInheritQuality2(tData.basicInfo.quality)

        self:updateInheritText()

        self:setInheritSelectStatus(tData.playerItemId)
    end
end

--@brief    设置继承界面格子选中状态
--@param    nPlayerItemId : 玩家物品唯一id -1表示没有选中
function WndPetsEquipment:setInheritSelectStatus(nPlayerItemId)
    for i=1,#self.m_tBagItemsObjList2 do
        if self.m_tBagItemsObjList2[i]:getData() and self.m_tBagItemsObjList2[i]:getData().playerItemId == nPlayerItemId then
            self.m_tBagItemsObjList2[i]:setItemSelState2(true)
        else
            self.m_tBagItemsObjList2[i]:setItemSelState2(false)
        end
    end
end

--@brief    点击卸下继承界面第一个装备
function WndPetsEquipment:onClickInheritItem1(element)
    self:initInheritUI()
end

--@brief    点击卸下继承界面第二个装备
function WndPetsEquipment:onClickInheritItem2(element)
    self.m_tInheritItem2 = nil

    self:setInheritQuality2(0)
    local conEquipItem2 = GetElement(self.m_root,"conEquipItem2_WndPetsEquipment",WZUIContainer)
    conEquipItem2:removeAllChildrenWithCleanup(true)

    local conAddIcon2 = GetElement(self.m_root,"conAddIcon2_WndPetsEquipment",WZUIContainer)
    conAddIcon2:setVisible(true)

    self:updateInheritText()

    self:setInheritSelectStatus(-1)
end

--@brief   更新继承文本
function WndPetsEquipment:updateInheritText()
    local conTransLv1 = GetElement(self.m_root,"conTransLv1_WndPetsEquipment",WZUIContainer)
    local conTransLv2 = GetElement(self.m_root,"conTransLv2_WndPetsEquipment",WZUIContainer)
    conTransLv1:setVisible(true)
    conTransLv2:setVisible(false)

    local imgTransferCost = GetElement(self.m_root,"imgTransferCost_WndPetsEquipment",WZUIImage)
    local txtTransferCost = GetElement(self.m_root,"txtTransferCost_WndPetsEquipment",WZUILabelTTF)
    imgTransferCost:setFile("")
    txtTransferCost:setText("")

    --属性
    local ftbTransferAttr1 = GetElement(self.m_root,"ftbTransferAttr1_WndStrengthen",WZUIFreeTextBox)
    local ftbTransferAttr2 = GetElement(self.m_root,"ftbTransferAttr2_WndStrengthen",WZUIFreeTextBox)
    ftbTransferAttr1:setShowText("")
    ftbTransferAttr2:setShowText("")
    local strformat = [[<T C="255,236,193" S="18" P="1" SC="127,70,26" SE="1" SS="4" >%s</T><T C="99,255,95" S="18" P="1" SC="127,70,26" SE="1" SS="4" >+%d</T>]]

    if self.m_tInheritItem1 then
        conTransLv1:setVisible(false)
        conTransLv2:setVisible(true)
        for k,v in pairs(GDatatab_pet_equip_extends) do
            if self.m_tInheritItem1:getData().basicInfo.quality == v.quality and self.m_tInheritItem1:getData().extraInfo.starLevel == v.star then
                --等级星级
                local txtEquipLv1 = GetElement(self.m_root,"txtEquipLv1_WndPetsEquipment",WZUILabelTTF)
                local txtEquipLv2 = GetElement(self.m_root,"txtEquipLv2_WndPetsEquipment",WZUILabelTTF)
                local txtReduceStarRate = GetElement(self.m_root,"txtReduceStarRate_WndPetsEquipment",WZUILabelTTF)
                local petEquipdownlevel = tonumber(CacheCenter:getGameParam().petEquipdownlevel)
                local tempLv1 = self.m_tInheritItem1:getData().extraInfo.strongLevel
                local tempLv2 = math.ceil(self.m_tInheritItem1:getData().extraInfo.strongLevel * (petEquipdownlevel/100))
                txtEquipLv1:setText(tempLv1)
                txtEquipLv2:setText(tempLv2)
                for i = 1, #v.rate do
                    if v.rate[i][1] == 0 then
                        txtReduceStarRate:setText(LocalStrings.PET_EQUIPMENT_16 .. ":" .. v.rate[i][2] .. "%") 
                    end
                end
                --消耗
                local tCostInfo = GDatatab_item["id_"..v.cost[1][1]]
                imgTransferCost:setFile(tCostInfo.icon)
                txtTransferCost:setText(v.cost[1][2])
            end
        end
        --属性
        local attrkey = self.m_tInheritItem1:getData().basicInfo.property[1][1]
        local attrvalue = self.m_tInheritItem1:getData().extraInfo[tostring(attrkey)]
        ftbTransferAttr1:setShowText(string.format(strformat,ATTR_TITLE[attrkey],attrvalue))
    end

    if self.m_tInheritItem2 then
        --属性
        local attrkey = self.m_tInheritItem2:getData().basicInfo.property[1][1]
        local attrvalue = self.m_tInheritItem2:getData().extraInfo[tostring(attrkey)]
        ftbTransferAttr2:setShowText(string.format(strformat,ATTR_TITLE[attrkey],attrvalue))
    end
end

--@brief   设置第一个装备品质特效
function WndPetsEquipment:setInheritQuality1(nQuality)
    for i=1,4 do
        local armature1 = GetElement(self.m_root,"armature1_"..i.."_WndStrengthen",WZArmature)
        armature1:setVisible(i == nQuality)
    end
end

--@brief   设置第二个装备品质特效
function WndPetsEquipment:setInheritQuality2(nQuality)
    for i=1,4 do
        local armature2 = GetElement(self.m_root,"armature2_"..i.."_WndStrengthen",WZArmature)
        armature2:setVisible(i == nQuality)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
