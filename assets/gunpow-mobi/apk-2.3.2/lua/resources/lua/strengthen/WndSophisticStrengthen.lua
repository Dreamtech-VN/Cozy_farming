--WndSophisticStrengthen.lua
--@brief	WndSophisticStrengthen的UI模块
--@date		2016/01/07
--@author	Tianxiang_Xu
--@note		洗练功能模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSophisticStrengthen:onEnter(element)
	self.m_root = element
    ChangeChatChannel(Chat_Channel_Forged_Sophistic)
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSophisticStrengthen:onExit(element)
	self:_unInit()
end

--@brief    加载界面完成
function WndSophisticStrengthen:onEnterTransitionDidFinish(element)
    -- body
    self.m_tSkillLockStatus = {0,0,0,0,0}
    local nCostStone = tonumber(CacheCenter:getGameParam()["weaponWashingNum"])
    if nCostStone == nil then
        nCostStone = 1
    end
    self.m_nCostLockNum = 0   
    self.m_nCostSophisticStoneNum = nCostStone
    self:_setStaticText()
end

--@brief 触摸开始回调
function WndSophisticStrengthen:onTouchBegin(element, pt)
    -- body
end

--@brief    点击技能回调
function WndSophisticStrengthen:onClickSkill(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    nTag = nTag + 1
    self.m_nClickSkillIndex = nTag

    local tData = self.m_tSkillDataList[nTag]
    WndTips:show(element,self.m_root,24,tData,GlobalMethod:ccp(120,100))
end

--@brief    点击技能tips锁定/解锁按钮调用的函数
function WndSophisticStrengthen:onClickLockCallBack(tData)
    -- body
    WZLog("****** WndSophisticStrengthen:onClickLockCallBack *****")
    --锁定时，技能锁不足
    local nIndex = 1
    for i = 1, #self.m_tSkillDataList do 
        if self.m_tSkillDataList[i].id == tData.id then
            nIndex = i 
            break 
        end
    end

    self:lockOrUnlockSkill(tData, nIndex)
end

--@brief    锁定或解锁
function WndSophisticStrengthen:lockOrUnlockSkill(tData, nIndex)
    -- body
    skillData = tData or self.m_tSkillDataList[nIndex]
    --更新消耗技能锁的数量的显示
    if skillData.status == 0 then
        self.m_nCostLockNum = self.m_nCostLockNum + 1
        self.m_tSkillDataList[nIndex].status = 1
        self.m_tSkillLockStatus[nIndex] = 1
    elseif skillData.status == 1 then
        self.m_nCostLockNum = self.m_nCostLockNum - 1
        self.m_tSkillDataList[nIndex].status = 0
        self.m_tSkillLockStatus[nIndex] = 0
    end

    --判断该武器的技能是否被全部锁定,如果全部锁定，则洗练按钮不可触摸
    local bAllLock = self:_lockAllSkills()
    if bAllLock then
        GetElement(self.m_root, "btnSophistic_WndSophisticStrengthen", WZUIButton):setTouchEnable(false)
    else
        GetElement(self.m_root, "btnSophistic_WndSophisticStrengthen", WZUIButton):setTouchEnable(true)
    end

    WZLog("******WndSophisticStrengthen:lockOrUnlockSkill*******", nIndex)
    self:_updateWeaponSkillInfo(self.m_cellElementList[nIndex], self.m_tSkillDataList[nIndex])
    self.m_nClickSkillIndex = nil
    --更新消耗信息
    self:_setStaticText()
end

--@brief    点击洗练按钮进行洗练
function WndSophisticStrengthen:onSophistic(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --提示装备框没有装备
    if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.SOPHISTIC_PUT_WEAPON)
        return
    end

    --首次点击洗练，弹友情提示
    local bShowSophisticAtt = LoadDesiRedPointVisible(CacheCenter:getPlayerInfo().id)
    local nOpenLevel = GDatatab_button_info["id_58"].open_level + 2
    if bShowSophisticAtt and CacheCenter:getPlayerInfo().level < nOpenLevel then
        SaveSophisticAttVisible(CacheCenter:getPlayerInfo().id, false)
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME}
        MsgBoxManager:showConfirmBox(LocalStrings.FIRST_SOPHISTIC_ATT, self, self.jumpToSophistic, nil, tCustomUIConfig, nil, LocalStrings.FIRST_LOCK_ATT)
        return 
    end
    
    self:jumpToSophistic()
end

--@brief    洗练各个情况跳转
function WndSophisticStrengthen:jumpToSophistic()
    -- body
    --技能锁不足
    if self.m_nLockItemNum < self.m_nCostLockNum then
        MsgBoxManager:showConfirmBox(LocalStrings.SOPHISTIC_LOCK_NOT_ENOUGH, self, self.buySkillLock, nil, nil)
        return
    end
    --洗练石不足
    if self.m_nSophisticStoneNum < self.m_nCostSophisticStoneNum then
        MsgBoxManager:showConfirmBox(LocalStrings.SOPHISTIC_STONE_NOT_ENOUGH, self, self.buySophisticStone, nil, nil)
        return
    end
    --判断是否有高等级技能未锁定,有则弹出提示框
    local bHavedHightLevelSkillUnLock = self:_haveHightLevelSkillsUnLock()
    if bHavedHightLevelSkillUnLock then
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME}
        MsgBoxManager:showConfirmBoxWithBg(LocalStrings.SOPHISTIC_LOCK_ASK, self, self.onClickSure, nil, tCustomUIConfig)
        return
    end

    local VansGridID = WZLuaVector_int_:create()
    for i = 1,#self.m_tSkillLockStatus do
        if self.m_tSkillLockStatus[i] == 1 then 
            VansGridID:push(i)
            WZLog("****** WndSophisticStrengthen:onSophistic 000 *****", i)
        end
    end
    WZLog("******** WndSophisticStrengthen:onSophistic *******")
    ProtocolProcessorStrengthen:send_FORGING_WeaponWashing(self.m_tCurSelectedEquip.playerItemId, VansGridID)
end

--@brief    跳到购买洗练石界面
function WndSophisticStrengthen:buySophisticStone(element, btnTag)
    -- body
    if btnTag == MSGBOXTYPE_CONFIRM then
        if self.m_tCurSelectedEquip == nil then return end
        local materialId = 158
        checkIsOnSale(materialId,LocalStrings.ITEMNOTSALE)--打开购买窗口
    end
end

--@brief    跳到购买技能锁界面
function WndSophisticStrengthen:buySkillLock(element, btnTag)
    -- body
    if btnTag == MSGBOXTYPE_CONFIRM then
        if self.m_tCurSelectedEquip == nil then return end
        local materialId = 159
        checkIsOnSale(materialId,LocalStrings.ITEMNOTSALE)--打开购买窗口
    end
end

--@brief    高等级技能未锁定提示确定回调
function WndSophisticStrengthen:onClickSure(element)
    -- body
    local VansGridID = WZLuaVector_int_:create()
    for i = 1,#self.m_tSkillLockStatus do
        if self.m_tSkillLockStatus[i] == 1 then 
            VansGridID:push(i)
        end
    end
    WZLog("******** WndSophisticStrengthen:onClickSure *******")
    ProtocolProcessorStrengthen:send_FORGING_WeaponWashing(self.m_tCurSelectedEquip.playerItemId, VansGridID)
end

--@brief    添加或取消装备时调用
--@author   zsq
function WndSophisticStrengthen:addEquipToCell(tEquip)
    local bIsResetLock = false
    if self.m_tCurSelectedEquip ~= nil and tEquip ~= nil then
        if self.m_tCurSelectedEquip.playerItemId ~= tEquip.playerItemId then
            bIsResetLock = true
        end
    end
    WZLog("*********** 111222333 ***********", bIsResetLock)
    self.m_tCurSelectedEquip = tEquip
    self.m_nCostLockNum = 0
    GetElement(self.m_root, "btnSophistic_WndSophisticStrengthen", WZUIButton):setTouchEnable(true)

    if tEquip == nil then
        WZLog("******** WndSophisticStrengthen:addEquipToCell 000 ********")
        GetElement(self.m_root, "conMid_WndSophisticStrengthen", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "conCost", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "btnSophistic_WndSophisticStrengthen", WZUIButton):setVisible(false)
        GetElement(self.m_root, "conSophisticInfo_WndSophisticStrengthen", WZUIContainer):setVisible(true)
        self.m_tSkillLockStatus = {0,0,0,0,0}
        return
    else
        --判断是武器的时候才添加,不是武器不添加
        if tEquip.maintype ~= 4 or (tEquip.maintype == 4 and tEquip.subtype ~= 0 and tEquip.subtype ~= 1) then
            WZLog("******** WndSophisticStrengthen:addEquipToCell 111 ********", tEquip.maintype, tEquip.subtype)
            self.m_tCurSelectedEquip = nil 
            GetElement(self.m_root, "conMid_WndSophisticStrengthen", WZUIContainer):setVisible(false)
            GetElement(self.m_root, "conCost", WZUIContainer):setVisible(false)
            GetElement(self.m_root, "btnSophistic_WndSophisticStrengthen", WZUIButton):setVisible(false)
            return 
        end
    end
    WZLog("******** WndSophisticStrengthen:addEquipToCell 222 ********")
    GetElement(self.m_root, "conMid_WndSophisticStrengthen", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "conCost", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "btnSophistic_WndSophisticStrengthen", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "conSophisticInfo_WndSophisticStrengthen", WZUIContainer):setVisible(false)
    if bIsResetLock then
        self.m_tSkillLockStatus = {0,0,0,0,0}
    end
    --更新数据
    self:loadWeaponSkills()
    --更新消耗
    self:_setStaticText()
end

--@brief    加载武器技能
function WndSophisticStrengthen:loadWeaponSkills()
    -- body
    if self.m_tCurSelectedEquip == nil then return end
    local extraInfo = self.m_tCurSelectedEquip.extraInfo
    local skillIdList = SplitStringWithSeparator(extraInfo.weaponskill, "|")
    WZLog("WndSophisticStrengthen:loadWeaponSkills", Serialize(skillIdList), #skillIdList)

    if self.m_cellElementList ~= nil and self.m_cellElementList ~= {} then
        for j = 1, #self.m_cellElementList do
            self.m_cellElementList[j]:removeFromParentAndCleanup(true)
        end
    end

    self.m_tSkillDataList = {} 
    self.m_cellElementList = {}
    
    for i = 1, 5 do
        local sConName = string.format("conSkill%d_WndSophisticStrengthen", i)
        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)
        if conSkill ~= nil then
            local cellElement = WZUISystem:getInstance():createElement("conSkill_WndSophisticStrengthen")
            if cellElement ~= nil then
                cellElement:setVisible(true)
                self.m_cellElementList[i] = cellElement
                local tData = nil 
                if skillIdList[i] ~= nil then
                    tData = GDatatab_skill["id_" .. skillIdList[i]]
                    tData.status = self.m_tSkillLockStatus[i]
                    if self.m_tSkillLockStatus[i] == 1 then
                        self.m_nCostLockNum = self.m_nCostLockNum + 1
                    end
                    table.insert(self.m_tSkillDataList, tData)
                end
                self:_setWeaponSkillData(cellElement, tData)
                cellElement:setTag(i - 1)
                conSkill:addChild(cellElement)
                local btnSkill = GetElement(cellElement, "btnSkillCell_WndSophisticStrengthen", WZUIButton)
                btnSkill = WZUIButton:luaTo(btnSkill)
                btnSkill:setTag(i - 1)
            end
        end
    end
end

--@brief    洗练成功
--@param    result:true->成功
function WndSophisticStrengthen:sophisticOk(result)
    -- body
    WZLog("***** WndSophisticStrengthen:sophisticOk *****", result)
    if not result then return end
    --洗练成功音效
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
    --播放洗练特效动画
    local spineSophistic = GetElement(self.m_root, "spineSophistic_WndSophisticStrengthen", WZUISpine)
    spineSophistic:setVisible(true)
    spineSophistic:play("effect", false)
    --特效动画  END 
    local tPlayerItemList = CacheCenter:getPlayerItems()
    for i = 1, #tPlayerItemList do
        if tPlayerItemList[i].playerItemId == self.m_tCurSelectedEquip.playerItemId then
            self.m_tCurSelectedEquip = tPlayerItemList[i]
            break
        end
    end
    self.m_nLockItemNum = getBagItemCount(159)
    self.m_nSophisticStoneNum = getBagItemCount(158)
    --更新界面信息
    local extraInfo = self.m_tCurSelectedEquip.extraInfo
    local skillIdList = SplitStringWithSeparator(extraInfo.weaponskill, "|")
    WZLog("******* sophisticOk ******",Serialize(self.m_tCurSelectedEquip.extraInfo))
    for j = #self.m_tSkillDataList, 1, -1 do
        if self.m_tSkillDataList[j].status == 0 then
            local tData = nil
            if skillIdList[j] ~= nil then
                tData = GDatatab_skill["id_" .. skillIdList[j]]
                tData.status = self.m_tSkillLockStatus[j]
                self.m_tSkillDataList[j] = tData

                self:_setWeaponSkillData(self.m_cellElementList[j], tData)
            end
        elseif self.m_tSkillDataList[j].status == 1 then
            --原来有锁的，判断根据剩余去除
            -- if self.m_nCostLockNum > self.m_nLockItemNum then
            --     self.m_nCostLockNum = self.m_nCostLockNum - 1
            --     self.m_tSkillDataList[j].status = 0
            --     self.m_tSkillLockStatus[j] = 0 
            --     self:_updateWeaponSkillInfo(self.m_cellElementList[j], self.m_tSkillDataList[j])
            -- end
        end
    end

    --更新消耗信息
    self:_setStaticText()

    WndStrengthen:updateCellEquip(self.m_tCurSelectedEquip)

    --提示升级成功
    PopupResult("ui/common/common_icon_xilz.png")
end

--@brief    洗练动画播完后的回调
function WndSophisticStrengthen:spineCallBack()
    -- body
    local spineSophistic = GetElement(self.m_root, "spineSophistic_WndSophisticStrengthen", WZUISpine)
--    spineSophistic:setVisible(false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    初始化文本控件
function WndSophisticStrengthen:_setStaticText()
    -- body
    self.m_nLockItemNum = getBagItemCount(159)
    self.m_nSophisticStoneNum = getBagItemCount(158)
    local sLockItemFile = self:_getIconFile(159)
    local sSophisticStoneItemFile = self:_getIconFile(158)
    --花费消耗
    local sCost = string.format(LocalStrings.SOPHISTIC_COST,sSophisticStoneItemFile, self.m_nCostSophisticStoneNum, self.m_nSophisticStoneNum, sLockItemFile, self.m_nCostLockNum,self.m_nLockItemNum)
    GetElement(self.m_root, "freetxtCost_WndSophisticStrengthen", WZUIFreeTextBox):setShowText(sCost)
end

--@brief    获取奖励物品的图标
function WndSophisticStrengthen:_getIconFile(itemId)
    -- body
    local tItemTable = GDatatab_item["id_" .. tostring(itemId)]

    return tItemTable.icon
end

--@brief    设置武器技能数据
--@param    element:技能子节点
--@param    tData:技能数据
function WndSophisticStrengthen:_setWeaponSkillData(element, tData)
    -- body
    local imgLock = GetElement(element, "imgLock_WndSophisticStrengthen", WZUIImage)
    local btnSkillCell = GetElement(element, "btnSkillCell_WndSophisticStrengthen", WZUIButton)
    local imgLockIn = GetElement(element, "imgLockIn_WndSophisticStrengthen", WZUIImage)

    if tData == nil then
        imgLock:setVisible(false)
        btnSkillCell:setTouchEnable(false)
        imgLockIn:setVisible(true)
        return 
    end
    imgLockIn:setVisible(false)
    --技能锁
    if tData.status == 0 then
        imgLock:setVisible(false)
    else
        imgLock:setVisible(true)
    end
    --技能图
    local imgSkillP = GetElement(element, "imgSkillP_WndSophisticStrengthen", WZUIImage)
    imgSkillP:setFile(tData.icon)
    --技能等级图标
    local imgSkillLv = GetElement(element, "imgSkillLv_WndSophisticStrengthen", WZUIImage)
    imgSkillLv:setFile(tData.lv_icon)
    --行动值
    local conActionValue = GetElement(element, "conActionValue_WndSophisticStrengthen", WZUIContainer)
    conActionValue:setVisible(true)
    local lafActionValue = GetElement(element, "lafActionValue_WndSophisticStrengthen", WZUILabelAtlasFont)
    lafActionValue:setText(math.ceil(tData.consume/1000))
end

--@brief    更新武器技能显示信息
--@note     更新技能锁
function WndSophisticStrengthen:_updateWeaponSkillInfo(element, tData)
    -- body
    local imgLock = GetElement(element, "imgLock_WndSophisticStrengthen", WZUIImage)
    if tData == nil then
        return 
    end
    --技能锁
    if tData.status == 0 then
        imgLock:setVisible(false)
    else
        imgLock:setVisible(true)
    end
end

--@brief    判断武器技能是否全部被锁定
function WndSophisticStrengthen:_lockAllSkills()
    -- body
    local bAllLock = true 
    for i = 1, #self.m_tSkillDataList do
        if self.m_tSkillLockStatus[i] == 0 then 
           bAllLock = false
           break  
        end
    end

    return bAllLock 
end

--@brief    判断武器是否有高等级技能未锁定
function WndSophisticStrengthen:_haveHightLevelSkillsUnLock()
    -- body
    local bHaveHighLevelUnLock = false 
    for i = 1, #self.m_tSkillDataList do
        WZLog("WndSophisticStrengthen:_haveHightLevelSkillsUnLock", self.m_tSkillLockStatus[i], self.m_tSkillDataList[i].specialAttackParam)
        if self.m_tSkillLockStatus[i] == 0 and self.m_tSkillDataList[i].specialAttackParam > 3 then 
           bHaveHighLevelUnLock = true
           break  
        end
    end

    return bHaveHighLevelUnLock 
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
--@brief    英文包适配函数
function WndSophisticStrengthen:_adaptLanguage_en()
    if self.m_root == nil then
        return
    end
end

function WndSophisticStrengthen:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtLockAtt_WndSophisticStrengthen",WZUILabelTTF):setFontSize(12)
end

function WndSophisticStrengthen:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtLockAtt_WndSophisticStrengthen",WZUILabelTTF):setFontSize(14)
end
-------------------------------------语言适配模块End----------------------------------------