--WndHVOperate.lua
--@brief	WndHVOperate的UI模块
--@date		2022/05/16
--@author	XTX
--@note		度假村操作界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHVOperate:onEnter(element)
	self.m_root = element

    self:_adaptIphoneX()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHVOperate:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndHVOperate:onEnterTransitionDidFinish(element)
    -- body
    self:_addTop()
    self:_initStaticText()
end

--@brief 	点击成就按钮回调
function WndHVOperate:onClickAchie(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndHVAchie:showInterface()
end

--@brief 	点击图鉴按钮回调
function WndHVOperate:onClickLibrary(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndHVLibrary:showInterface(self.m_tLuaTable)
end

--@brief 	点击仓库按钮回调
function WndHVOperate:onClickStore(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndHVStore:showInterface(self.m_tLuaTable)
end

--@brief 	点击商店按钮回调
function WndHVOperate:onClickShop(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndHVShop:showInterface()
end

--@brief 	点击排行榜按钮回调
function WndHVOperate:onClickRank(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndShopRank:showInterface(26)
end

--@brief    点击精灵按钮回调
function WndHVOperate:onClickSpirit(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndHVSpirit:showInterface()
end

--@brief 	点击回村按钮回调
function WndHVOperate:onClickGoHome(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	SceneHolidayVillage:showInterface()
end

--@brief 	点击好友度假村按钮回调
function WndHVOperate:onClickFriendHome(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local conRankList = GetElement(self.m_root, "conRankList_WndHVOperate", WZUIContainer)
    if self.m_nRankState == 0 then
        self.m_nRankState = 1 
        if self.m_nTag == nil then 
            self.m_nTag = 3
        end
        local nIndex = GetElement(self.m_root, "checkGroup_WndHVOperate", WZUICheckBoxGroup):getCheckIndex()
        WZLog("WndHVOperate:onClickFriendHome", self.m_nTag, nIndex)
        if self.m_nTag == 1 then 
            ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetVisitorRecord()
        else
        --    hhhhTime = WZThread:getUTickCount()
            ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetRanks(1)
        end

        local screenSize = CCEGLView:sharedOpenGLView():getFrameSize()
        local nPositionX = 1 - 325/screenSize.width
        if IsIphoneX() then
            conRankList:setAnchorPoint(GlobalMethod:ccp(1,0.5))
            conRankList:setRelativePosition(GlobalMethod:ccp(0.955, 0.46))
        else
            conRankList:setAnchorPoint(GlobalMethod:ccp(1,0.5))
            conRankList:setRelativePosition(GlobalMethod:ccp(1, 0.46))
        end
        GetElement(self.m_root, "conForRankList_WndHVOperate", WZUIContainer):setVisible(true)

        GetElement(self.m_root,"editInputId_WndHVOperate",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
    else
        self:hideRankList()
    end
end

function WndHVOperate:hideRankList()
    --body
    if self.m_nRankState == 1 then
        self.m_nRankState = 0
        GetElement(self.m_root, "conForRankList_WndHVOperate", WZUIContainer):setVisible(false)
        local conRankList = GetElement(self.m_root, "conRankList_WndHVOperate", WZUIContainer)
        conRankList:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        if IsIphoneX() then 
            conRankList:setRelativePosition(GlobalMethod:ccp(0.955, 0.46))
        else
            conRankList:setRelativePosition(GlobalMethod:ccp(1, 0.46))
        end
    end
end

function WndHVOperate:checkPointInBtn(pt)
    if self.m_root == nil then return end
    local btn = GetElement(self.m_root, "conRankList_WndHVOperate", WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    end 

    btn = GetElement(self.m_root, "btnFriendHome_WndHVOperate", WZUIButton)
    if btn == nil then return false end
    btnSize = btn:getContentSize()
    --获得btn的世界坐标
    ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    else
        return false
    end 
end

function WndHVOperate:onTab(element) 
    WZLog("WndHVOperate:onTab",element:getTag())
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local tag = tonumber(element:getTag())
    if self.m_nTag == tag then return end 
    self.m_nTag = tag
    if self.m_nTag == 1 then 
        ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetVisitorRecord()
    elseif self.m_nTag == 3 then 
        ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetRanks(1)
    end
end

--@brief    点击土坑添加相应的按钮操作
function WndHVOperate:onClickBuildingCallBack()
    WZLog("WndHVOperate:onClickBuildingCallBack")
    self:_showFuncBtnList()
end

--@brief    点击土坑操作按钮回调
--@param    opType:1=播种；2=施肥；3=浇水；4=捕捉；5=采摘；6=偷取；7=土坑；8=挖坑；9=扩建；10=花盆
function WndHVOperate:onClickOperateCallBack(opType, element)
    if self.m_root == nil then return end 

    local tData = self.m_tOperateData --操作的土坑数据
    WZLog("WndHVOperate:onClickOperateCallBack", Serialize(tData))
    if opType == 1 then 
        WndHVStore:showInterface(self.m_tLuaTable, true, tData)
    elseif opType == 2 then 
        local tFertilizer = self.m_tLuaTable:getFertilizerData()
        if #tFertilizer > 0 then 
            self.m_tLuaTable:_createFertilizerList(opType, true, tData)
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[59])
        end
    elseif opType == 3 then 
        if tData.plantId > 0 and not tData.bIsWater then 
            self.m_tLuaTable:setOperateType(opType, tData)
            self.m_tLuaTable:waterCallBack(tData)
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[49])
        end
    elseif opType == 4 then 
        if tData.plantId > 0 then 
            if tData.plantPests > 0 then 
                self.m_tLuaTable:setOperateType(opType, tData)
                self.m_tLuaTable:catchCallBack(tData)
            end
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[54])
        end
    elseif opType == 5 then 
        if tData.plantId > 0 and tData.plantStatus == PLANT_STATUS.MATURITY then 
            self.m_tLuaTable:setOperateType(opType, tData)
            self.m_tLuaTable:collectCallBack(tData)
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[55])
        end
    elseif opType == 6 then 
        if tData.plantId > 0 and tData.plantStatus == PLANT_STATUS.MATURITY then 
            self.m_tLuaTable:setOperateType(opType, tData)
            self.m_tLuaTable:collectCallBack(tData)
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[55])
        end
    elseif opType == 7 then 
        WndHVField:showInterface(tData, self.m_tLuaTable)
    elseif opType == 8 then 
        if tData.plantId == 0 and not tData.bIsDig then 
            self.m_tLuaTable:setOperateType(opType, tData)
            self.m_tLuaTable:digCallBack(tData)
        else
            MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[48])
        end
    elseif opType == 9 then 
        local strFormat = [[<T C="127,70,26" S="22" P="1">%s</T>]]
        local strFormat2 = [[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="22" P="1">%d </T>]]
        local tFieldConfig = WndHVField:getFieldLevelData(self.m_tOperateData)
        local strContent = ""
        if tFieldConfig.maintype == 2 then 
            strContent = string.format(strFormat, LocalStrings.HOLIDAYVILLAGE_TEXT3[22])
        else
            strContent = string.format(strFormat, LocalStrings.HOLIDAYVILLAGE_TEXT1[41])
        end
        WZLog("tFieldConfigtFieldConfigtFieldConfig", Serialize(tFieldConfig))
        if tFieldConfig.lv_cost ~= -1 then 
            strContent = strContent .. LocalStrings.HOLIDAYVILLAGE_TEXT1[97]
            for i = 1, #tFieldConfig.lv_cost do
                local basidInfo = GDatatab_item["id_" .. tFieldConfig.lv_cost[i][1]]
                local strContent2 = string.format(strFormat2, basidInfo.icon, tFieldConfig.lv_cost[i][2])

                strContent = strContent .. strContent2
            end
        end

        MsgBoxManager:showConfirmBox(strContent, self, self.sureToExtend)
    elseif opType == 10 then 
        local tFieldConfig = WndHVField:getFieldLevelData(self.m_tOperateData)
        local tFlowerpots = CacheCenter:getHVFlowerpots(tFieldConfig.maintype)
        local tAllFlowerpots = CacheCenter:getAllFlowerpot()
        if self.m_tOperateData.flowerpotId and self.m_tOperateData.flowerpotId > 0 then 
            local bIsNeedAdd = true 
            for i = 1, #tFlowerpots do
                if tFlowerpots[i].id == self.m_tOperateData.flowerpotId then 
                    bIsNeedAdd = false 
                    break 
                end
            end
            if bIsNeedAdd then 
                local tTempItem = {}
                tTempItem.id = self.m_tOperateData.flowerpotId
                tTempItem.lastTime = 1
                tTempItem.lastNum = 1
                tTempItem.isUse = true
                tTempItem.basicInfo = CopyTable(GDatatab_item["id_" .. self.m_tOperateData.flowerpotId])
                if tTempItem.basicInfo ~= nil then
                    tTempItem.maintype = tTempItem.basicInfo.main_type
                    tTempItem.subtype = tTempItem.basicInfo.sub_type
                end

                table.insert(tFlowerpots, 1, tTempItem)
            end
        end
        --创建可用花盆列表
        if #tFlowerpots < #tAllFlowerpots then 
            for i = 1, #tAllFlowerpots do
                if tAllFlowerpots[i].sub_type == tFieldConfig.maintype then 
                    local bIsExist = false 
                    for j = 1, #tFlowerpots do
                        if tFlowerpots[j].id == tAllFlowerpots[i].id then 
                            bIsExist = true
                            break 
                        end
                    end
                    if not bIsExist then 
                        local tTempItem = {}
                        tTempItem.id = tAllFlowerpots[i].id 
                        tTempItem.lastTime = 0
                        tTempItem.lastNum = 0
                        tTempItem.isUse = false
                        tTempItem.basicInfo = CopyTable(tAllFlowerpots[i])
                        if tTempItem.basicInfo ~= nil then
                            tTempItem.maintype = tTempItem.basicInfo.main_type
                            tTempItem.subtype = tTempItem.basicInfo.sub_type
                        end

                        table.insert(tFlowerpots, tTempItem)
                    end
                end
            end
        end
        if #tFlowerpots <= 0 then 
            MsgBoxManager:showTipBox(LocalStrings.DAZZLERANK_TEXT1[12])
            return 
        end

        local tData = {}
        tData.fieldId = self.m_tOperateData.fieldId
        tData.usingFlowerpot = self.m_tOperateData.flowerpotId
        tData.flowerpots = tFlowerpots
        WndTips:show(element, self.m_root, 90, tData, GlobalMethod:ccp(0,80) , true)
    end
end

--@brief    确认开垦土坑
function WndHVOperate:sureToExtend(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then 
        local tFieldConfig = WndHVField:getFieldLevelData(self.m_tOperateData)
        if tFieldConfig.lv_cost ~= -1 then 
            for i = 1, #tFieldConfig.lv_cost do
                if not JudgeMoneyIsEnough(tFieldConfig.lv_cost[i][1], tFieldConfig.lv_cost[i][2]) then 
                    local basidInfo = GDatatab_item["id_" .. tFieldConfig.lv_cost[i][1]]
                    MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1, basidInfo.name))
                    return 
                end
            end
        end
        local hostInfo = self.m_tLuaTable:getHostInfo()
        if hostInfo.hvLevel >= tFieldConfig.need_lv then 
            self.m_tLuaTable:setOperateType(9)
            self.m_tLuaTable:extendFieldCallBack(self.m_tOperateData)
        else
            MsgBoxManager:showTipBox(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[42], tFieldConfig.need_lv))
        end
    end
end

--@brief    点击增加能量按钮回调
function WndHVOperate:onAddEnergy(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local luaTable = self.m_tLuaTable 

    local playerInfo = luaTable:getHostInfo()
    local tConfigLevel, bIsMaxLv = self:getMaxExpAndEnergy(playerInfo.hvLevel, playerInfo.hvExp)
    if playerInfo.hvCurEnergy >= tConfigLevel.energy_limit then 
        MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT1[92])
        return 
    end
    local tData = {55401, 55403, 55404}
    local tTempItem = {}
    for i = 1, #tData do
        local ownNum = luaTable:getItemCountByItemId(tData[i])
        if true or ownNum > 0 then 
            table.insert(tTempItem, tData[i])
        end
    end
    
    if true or #tTempItem > 0 then 
        local wndOpenChest = WndOpenChest:createElement()
        WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
        WndOpenChest:setHVEnergyData(tTempItem, luaTable)
    else
        WndFastGetItems:show(tData[1])
    end
end
--@brief    点击查找公会ID按钮时
function WndHVOperate:onClickFindCommunityId(element)
    WZLog(" WndHVOperate:onClickFindCommunityId")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local inputText = nil 
    local editInputId  = self.m_root:getChildElement("editInputId_WndHVOperate")
    if editInputId ~= nil then 
        editInputId = WZUIEditBox:luaTo(editInputId)
        if editInputId ~= nil then 
            inputText = editInputId:getText()
        end 
    end 
    if tonumber(inputText) ~= nil then     --输入全是数字
        --获取并显示公会信息
        ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetRanks(1, tonumber(inputText))
        --显示取消查找按钮
        GetElement(self.m_root,"btnCancelFind_WndHVOperate",WZUIButton):setVisible(true)
    elseif inputText == LocalStrings.MASTERINFO16 or inputText == "" then 
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO16)
    else  
        MsgBoxManager:showTipBox(LocalStrings.MASTERINFO22)
    end 
end 

function WndHVOperate:onCancelFind(element) 
    WZLog("WndHVOperate:onCancelFind", tonumber(self.m_nTag))
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --隐藏取消查找按钮
    GetElement(self.m_root,"btnCancelFind_WndHVOperate",WZUIButton):setVisible(false)
    --刷新界面
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_GetRanks(1)
     
    GetElement(self.m_root,"editInputId_WndHVOperate",WZUIEditBox):setText("")
    GetElement(self.m_root,"editInputId_WndHVOperate",WZUIEditBox):setPlaceHolder(LocalStrings.MASTERINFO16)
end

--@brief    触摸开始回调
function WndHVOperate:onTouchBegin(element)
    if self.m_topCellLua then
        self.m_topCellLua.goldCellInfo.tcell:removeCreateTips()
    end
end

--@brief    点击弹提示语
function WndHVOperate:onClickTips(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nTag = element:getTag()
    if nTag == 1 then 
        local nCurTime = WZThread:getUTickCount()
        local nCount = #LocalStrings.HOLIDAYVILLAGE_TEXT2[1]
        local nIndex = math.fmod(nCurTime, nCount) + 1

        local tData = {}
        tData.txtTitle = LocalStrings.HOLIDAYVILLAGE_TEXT2[1][nIndex]
        tData.nType = 2
        local conOutSide = GetElement(self.m_root, "conOutSide_WndHVOperate", WZUIContainer)
        WndTips:show(element, conOutSide, 52, tData, GlobalMethod:ccp(250,100), true)
    elseif nTag == 2 then 
        local conForBg = GetElement(self.m_root, "conForBg_WndHVOperate", WZUIContainer)
        if not conForBg:isVisible() then
            conForBg:setVisible(true)
            self:showFrame()
        end
    end
end

--@brief    点击鲜花订单按钮回调
function WndHVOperate:onClickOrder(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndHVFlowerOrder:showInterface()
end

--@brief    装饰界面点击标签回调
function WndHVOperate:onClickTab(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)

    local nTag = element:getTag()
    if self.m_nTabIndex == nTag then return end 

    self.m_nTabIndex = nTag
    self:showFrame()
end

--@brief    关闭设置背景界面
function WndHVOperate:onCloseBgSet(element)
    -- body
    local conForBg = GetElement(self.m_root, "conForBg_WndHVOperate", WZUIContainer)
    if conForBg:isVisible() then
        conForBg:setVisible(false)
    end
end

--@brief    点击许愿按钮回调
function WndHVOperate:onClickWish(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local nCurTime = SystemTime:getServerTime()

    local nLeftSeconds = self.m_tWishConfig[2] + self.m_nLastWishTime - nCurTime 
    WZLog("WndHVOperate:onClickWish", nLeftSeconds)
    if nLeftSeconds > 0 then 
        MsgBoxManager:showTipBox(LocalStrings.HOLIDAYVILLAGE_TEXT2[20])
        return 
    end
    ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_WishingTree()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief     添加顶部货币栏
function WndHVOperate:_addTop()
    -- body
    local celElement, tNewObj = CellTopHandle:createElement()
    if self.m_nWinType == 0 then 
        tNewObj:setTopData("ui/common/common_icon_djc.png", SceneHolidayVillage, SceneHolidayVillage.onClickClose, true, nil, false,nil, {goldType = 17}, false, false)
    elseif self.m_nWinType == 1 then 
        tNewObj:setTopData("ui/common/common_icon_sssl.png", SceneHVTree, SceneHVTree.onClickClose, true, nil, false,nil, {goldType = 17}, false, false)
        GetElement(self.m_root, "conWish_WndHVOperate", WZUIContainer):setVisible(true)
        local strConfig = CacheCenter:getGameParam()["holidayVillageWishingTreeConfig"]
        local strTemp = string.sub(strConfig,2,-2) 
        local times = tonumber(SplitStringWithSeparator(strTemp,",")[1])
        local nSeconds = tonumber(SplitStringWithSeparator(strTemp,",")[2])
        self.m_tWishConfig = {times, nSeconds}
    end
    self.m_root:addChild(celElement)

    self.m_topCellLua = tNewObj
end

--@brief 	设置玩家的头像、名字
function WndHVOperate:_showPlayerInfo()
	-- body
    if self.m_root == nil then return end 
    
    local luaTable = self.m_tLuaTable 
	local playerInfo = luaTable:getHostInfo()
	--玩家名字
	local txtPlayerName = GetElement(self.m_root, "txtPlayerName_WndHVOperate", WZUILabelTTF)
	if txtPlayerName then 
		txtPlayerName:setText(playerInfo.name)
	end
	--玩家头像
	local conPlayerIcon = GetElement(self.m_root, "conPlayerIcon_WndHVOperate", WZUIContainer)
	local celElement = CellHead:show(conPlayerIcon, playerInfo.headId, playerInfo.faceId, playerInfo.sex, nil, nil, playerInfo.vipLevel, playerInfo.headColor, nil, nil, nil, nil, playerInfo.headEffectId)
	self:_showOtherInfo()
    if luaTable:isMyHolidayVillage() then 
        GetElement(self.m_root, "conRightButtom_WndHVOperate", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "conLeftBtnFriend_WndHVOperate", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "btnAddEnergy_WndHVOperate", WZUIButton):setVisible(true)
        GetElement(self.m_root, "btnLibrary_WndHVOperate", WZUIButton):setVisible(true)
        GetElement(self.m_root, "btnDecoration_WndHVOperate", WZUIButton):setVisible(true)
    else
        GetElement(self.m_root, "conRightButtom_WndHVOperate", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "btnAddEnergy_WndHVOperate", WZUIButton):setVisible(false)
        GetElement(self.m_root, "btnLibrary_WndHVOperate", WZUIButton):setVisible(false)
        GetElement(self.m_root, "conLeftBtnFriend_WndHVOperate", WZUIContainer):setVisible(true)
        GetElement(self.m_root, "btnDecoration_WndHVOperate", WZUIButton):setVisible(false)
    end
end

--@brief 	设置静态文本
function WndHVOperate:_initStaticText()
	GetElement(self.m_root, "txtFriendHV_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[2])
	GetElement(self.m_root, "txtBtnStore_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[7])
	GetElement(self.m_root, "txtGoHome_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[8])
	GetElement(self.m_root, "txtTabLog1_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[9])
	GetElement(self.m_root, "txtTabLog2_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[9])
    GetElement(self.m_root, "txtEnergyWord_WndHVOprate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[36])
    GetElement(self.m_root, "txtFriendRank1_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[40])
    GetElement(self.m_root, "txtFriendRank2_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[40])
    GetElement(self.m_root, "txtFlowerOrder_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT3[2])
    GetElement(self.m_root, "txtBtnSpirit_WndHVOperate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT4[1])
    GetElement(self.m_root, "txtTab1_WndHVOparate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[2])
    GetElement(self.m_root, "txtTabSel1_WndHVOparate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[2])
    GetElement(self.m_root, "txtTab2_WndHVOparate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[3])
    GetElement(self.m_root, "txtTabSel2_WndHVOparate", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT2[3])
end

--@brief 	设置玩家的度假成就、度假等级、度假能量值
function WndHVOperate:_showOtherInfo()
	local playerInfo = self.m_tLuaTable:getHostInfo()
	--度假成就
	local txtAchieTitle = GetElement(self.m_root, "txtAchieTitle_WndHVOperate", WZUILabelTTF)
	if txtAchieTitle then 
        local achieData = GDatatab_holiday_achievement["id_" .. playerInfo.achieId]
        if achieData then 
		    txtAchieTitle:setText(achieData.name)
        end
	end
	--度假村等级
	local txtHVLevel = GetElement(self.m_root, "txtHVLevel_WndHVOperate", WZUILabelTTF)
	txtHVLevel:setText(LocalStrings.LV .. playerInfo.hvLevel)
	local txtExp = GetElement(self.m_root, "txtExp_WndHVOperate", WZUILabelTTF)
    local tConfigLevel, bIsMaxLv = self:getMaxExpAndEnergy(playerInfo.hvLevel, playerInfo.hvExp)
    if bIsMaxLv then 
       txtExp:setText("Max")
    else
	   txtExp:setText(playerInfo.hvExp .. "/" .. tConfigLevel.exp)
    end
	local prgExp = GetElement(self.m_root, "prgExp_WndHVOperate", WZUIProgress)
	local percentage = math.floor(100 * playerInfo.hvExp/tConfigLevel.exp)
	if percentage > 100 then 
		percentage = 100 
	end
	prgExp:setPercentage(percentage)
	--度假村能量值
	local txtEnergyExp = GetElement(self.m_root, "txtEnergyExp_WndHVOperate", WZUILabelTTF)
	txtEnergyExp:setText(playerInfo.hvCurEnergy .. "/" .. tConfigLevel.energy_limit)
	local prgEnergyExp = GetElement(self.m_root, "prgEnergyExp_WndHVOperate", WZUIProgress)
	local perEnergy = math.floor(100 * playerInfo.hvCurEnergy/tConfigLevel.energy_limit)
	if perEnergy > 100 then 
		perEnergy = 100 
	end
	prgEnergyExp:setPercentage(perEnergy)
end

--@brief 	我的好友的度假村
--@param    nType:3=好友度假村；4=好友访问日志
function WndHVOperate:showRank(nType) 
    if self.m_root == nil then return end
    local tbCon = GetElement(self.m_root,"tbcon_WndHVOperate",WZUITableContainer)
    tbCon:cleanTable()
    local conSize = GlobalMethod:CCSize(374,90)
    nType = nType or 3
    if nType == 3 then 
        GetElement(self.m_root, "conForSearch_WndHVOperate", WZUIContainer):setVisible(true)
        tbCon:setAbsContentSize(GlobalMethod:CCSize(390,446))
        tbCon:setCellElementHeight(0.2)
    elseif nType == 4 then 
        GetElement(self.m_root, "conForSearch_WndHVOperate", WZUIContainer):setVisible(false)
        tbCon:setAbsContentSize(GlobalMethod:CCSize(390,496))
        tbCon:setCellElementHeight(0.12)
        conSize = GlobalMethod:CCSize(374,60)
    end
    tbCon:updateRelativeSize()

    --没有数据时显示提示
    if self.m_tDataList == nil or #self.m_tDataList == 0 then 
        ShowPanelNullTip(tbCon,nil,GlobalMethod:ccc3(255,236,193))
        return 
    else
        removeShowPanelNullTip(tbCon)
    end

    for i = 1, #self.m_tDataList do
        local celElement, tCell = CellFamilyRankNew:createElement(conSize)
        if celElement ~= nil and tCell ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
            tCell:setData(self.m_tDataList[i], nType)
            celElement:setTag(i - 1)
            tbCon:setCellElement(celElement)
        end 
    end

    tbCon:getMoveElement():setPositionY(tbCon:getMinPosition().y)
end

--@brief    根据不同的功能建筑，不同的状态，显示不同的功能按钮
--@note     1=播种；2=施肥；3=浇水；4=捕捉；5=采摘；6=偷取；7=土坑；8=挖坑；9=扩建；10=花盆
function WndHVOperate:_showFuncBtnList()
    -- body
    if self.m_tLuaTable.m_clickInfo == nil or self.m_tLuaTable.m_clickInfo == {} then
        return 
    end

    local tBtnWords = {LocalStrings.HOLIDAYVILLAGE_TEXT1[3], LocalStrings.HOLIDAYVILLAGE_TEXT1[6], LocalStrings.HOLIDAYVILLAGE_TEXT1[53], LocalStrings.HOLIDAYVILLAGE_TEXT1[35], LocalStrings.HOLIDAYVILLAGE_TEXT1[33], LocalStrings.HOLIDAYVILLAGE_TEXT1[34], LocalStrings.HOLIDAYVILLAGE_TEXT1[4], LocalStrings.HOLIDAYVILLAGE_TEXT1[52], LocalStrings.HOLIDAYVILLAGE_TEXT1[32], LocalStrings.HOLIDAYVILLAGE_TEXT3[21], LocalStrings.DAZZLERANK_TEXT1[11]}
    local tData = self.m_tLuaTable.m_clickInfo.tData 
    local tBtnIndex = {}
    local tBtnName = {}
    local tBtnNode = {}
    local nBtnIndex = 1
    if self.m_tLuaTable:isMyHolidayVillage() then 
        if tData.fieldStatus == 0 then --可扩建的土坑
            tBtnIndex[nBtnIndex] = 9
            tBtnName[nBtnIndex] = tBtnWords[9]
            nBtnIndex = nBtnIndex + 1
            tBtnNode = {"btnHV1_conFieldBtn"}
        elseif tData.fieldStatus == 1 then 
            if tData.plantId == 0 then  --尚未播种
                if tData.bIsDig then 
                    tBtnIndex[nBtnIndex] = 1
                    tBtnName[nBtnIndex] = tBtnWords[1]
                else
                    tBtnIndex[nBtnIndex] = 8
                    tBtnName[nBtnIndex] = tBtnWords[8]
                end
                nBtnIndex = nBtnIndex + 1
                tBtnIndex[nBtnIndex] = 7
                if tData.configId == 1 then 
                    tBtnName[nBtnIndex] = tBtnWords[7]
                elseif tData.configId == 2 then 
                    tBtnName[nBtnIndex] = tBtnWords[10]
                end
                nBtnIndex = nBtnIndex + 1
                tBtnIndex[nBtnIndex] = 10
                tBtnName[nBtnIndex] = tBtnWords[11]
                nBtnIndex = nBtnIndex + 1
                tBtnNode = {"btnHV2_conFieldBtn", "btnHV3_conFieldBtn", "btnHV4_conFieldBtn"}
            else
                if tData.bIsWater and tData.plantStatus ~= PLANT_STATUS.MATURITY then 
                    tBtnIndex[nBtnIndex] = 2
                    tBtnName[nBtnIndex] = tBtnWords[2]
                    nBtnIndex = nBtnIndex + 1
                end
                tBtnIndex[nBtnIndex] = 7
                if tData.configId == 1 then 
                    tBtnName[nBtnIndex] = tBtnWords[7]
                elseif tData.configId == 2 then 
                    tBtnName[nBtnIndex] = tBtnWords[10]
                end
                nBtnIndex = nBtnIndex + 1
                tBtnIndex[nBtnIndex] = 10
                tBtnName[nBtnIndex] = tBtnWords[11]
                nBtnIndex = nBtnIndex + 1
                if nBtnIndex == 4 then 
                    tBtnNode = {"btnHV2_conFieldBtn", "btnHV3_conFieldBtn", "btnHV4_conFieldBtn"}
                else
                    tBtnNode = {"btnHV2_conFieldBtn", "btnHV3_conFieldBtn"}
                end
            end
        end
    end

    --显示按钮
    local nBtnNum = GetTableLen(tBtnIndex)
    local tDataTemp = CopyTable(tData)
    tDataTemp.tBtnIndex = tBtnIndex
    tDataTemp.tBtnName = tBtnName
    tDataTemp.tBtnNode = tBtnNode
    self.m_tOperateData = tDataTemp
    WZLog("WndHVOperate:_showFuncBtnList", nBtnNum)
    self:_updateBtnShow()
end

--@brief    度假村土坑操作按钮
function WndHVOperate:_updateBtnShow()
    local tData = self.m_tOperateData 
    WZLog("WndHVOperate:_updateBtnShow")
    local conForBuilding = nil
    if self.m_nWinType == 0 then 
        conForBuilding = GetElement(self.m_tLuaTable.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    elseif self.m_nWinType == 1 then 
        conForBuilding = GetElement(self.m_tLuaTable.m_root, "conForBuilding_hvTreeScene", WZUIContainer)
    end
    local nTag = 99989
    local element = conForBuilding:getChildByTag(nTag)
    if not element then 
        element = WZUISystem:getInstance():createElement("conFieldBtn_WndHVOperate")
        element:setTag(nTag)
        conForBuilding:addChild(element)
    else
        element = WZUIContainer:luaTo(element)
    end
    local fieldData = tData
    local indexX, indexY = fieldData.indexX, fieldData.indexY

    local nTempX, nTempY = self.m_tLuaTable:_getAbsPosition(indexX, indexY, fieldData.basicData)
    element:setVisible(true)
    element:setAbsPosition(GlobalMethod:ccp(nTempX, nTempY))
    element:setZOrder(nTag)

    for i = 1, 4 do
        local btnHV = GetElement(element, "btnHV" .. i .. "_conFieldBtn", WZUIButton)
        btnHV:setTag(-1)
        btnHV:setVisible(false)
    end
    local conPlantDetail = GetElement(element, "conPlantDetail_conFieldBtn", WZUIContainer)
    conPlantDetail:setVisible(false)

    for i = 1, #tData.tBtnIndex do
        local btnHV = GetElement(element, tData.tBtnNode[i], WZUIButton)
        btnHV:setTag(tData.tBtnIndex[i])
        btnHV:setVisible(true)
        GetElement(btnHV, "txtBtn_conFieldBtn", WZUILabelTTF):setText(tData.tBtnName[i])
    end
    if self.m_tLuaTable:isMyHolidayVillage() then 
        --显示作物详情Tips
        if tData.plantId > 0 then 
            conPlantDetail:setVisible(true)
            local txtPlantName = GetElement(element, "txtPlantName_conFieldBtn", WZUILabelTTF)
            txtPlantName:setText(tData.plantInfo.name)
            --清空原来的内容
            for i = 1, 3 do
                GetElement(element, "txtPlantWord" .. i .. "_conFieldBtn", WZUILabelTTF):setText("")
                GetElement(element, "txtPlantNum" .. i .. "_conFieldBtn", WZUILabelTTF):setText("")
            end
            GetElement(element, "txtPlantWord4_conFieldBtn", WZUILabelTTF):setText("")
            GetElement(element, "txtPlantWord5_conFieldBtn", WZUILabelTTF):setText("")

            local fertilizerInc = tData.fertilizerIncr --增产化肥Id
            local fertilizerWords = nil 
            local reduceWords = nil 
            local nHeight = 20 
            local nConWidth = 10  
            if tData.plantStatus == PLANT_STATUS.SEED then 
                local txtPlantWord1 = GetElement(element, "txtPlantWord1_conFieldBtn", WZUILabelTTF)
                txtPlantWord1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[72])
                local txtSize = txtPlantWord1:getContentSize()
                if txtSize.width > nConWidth then 
                    nConWidth = txtSize.width 
                end
                WZLog("WndHVOperate:_updateBtnShow 00", txtSize.height)
                nHeight = nHeight + txtSize.height + 20 
                local leftSeconds = tData.plantGroupTime - SystemTime:getServerTime()
                local strTime = ""
                if leftSeconds >= 24 * 3600 then 
                    strTime = returnToTimeFormat_Day(leftSeconds)
                else
                    local hours = math.floor(leftSeconds/3600)
                    local minutes = math.floor((leftSeconds%3600)/60)
                    local seconds = leftSeconds%60
                    if hours > 0 then 
                        strTime = hours .. LocalStrings.HOUR1 .. minutes .. LocalStrings.MINUTE1
                    elseif minutes > 0 then 
                        strTime = minutes .. LocalStrings.MINUTE1
                    elseif seconds > 0 then 
                        strTime = seconds .. LocalStrings.SECOND
                    end
                end
                local txtPlantWord2 = GetElement(element, "txtPlantWord2_conFieldBtn", WZUILabelTTF)
                txtPlantWord2:setText(strTime)
                txtSize = txtPlantWord2:getContentSize()
                WZLog("WndHVOperate:_updateBtnShow 11", txtSize.height)
                if txtSize.width > nConWidth then 
                    nConWidth = txtSize.width 
                end
                nHeight = nHeight + txtSize.height + 20 
                WZLog("WndHVOperate:_updateBtnShow 11", nConWidth, nHeight)
                --增产化肥提示语节点
                fertilizerWords = GetElement(element, "txtPlantWord3_conFieldBtn", WZUILabelTTF)
                reduceWords = GetElement(element, "txtPlantWord4_conFieldBtn", WZUILabelTTF)
            elseif tData.plantStatus == PLANT_STATUS.SEEDLING then 
                local txtPlantWord1 = GetElement(element, "txtPlantWord1_conFieldBtn", WZUILabelTTF)
                txtPlantWord1:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[73])
                local txtSize = txtPlantWord1:getContentSize()
                if txtSize.width > nConWidth then 
                    nConWidth = txtSize.width 
                end
                nHeight = nHeight + txtSize.height + 20 
                local leftSeconds = tData.plantGroupTime - SystemTime:getServerTime()
                local strTime = ""
                if leftSeconds >= 24 * 3600 then 
                    strTime = returnToTimeFormat_Day(leftSeconds)
                else
                    local hours = math.floor(leftSeconds/3600)
                    local minutes = math.floor((leftSeconds%3600)/60)
                    local seconds = leftSeconds%60
                    if hours > 0 then 
                        strTime = hours .. LocalStrings.HOUR1 .. minutes .. LocalStrings.MINUTE1
                    elseif minutes > 0 then 
                        strTime = minutes .. LocalStrings.MINUTE1
                    elseif seconds > 0 then 
                        strTime = seconds .. LocalStrings.SECOND
                    end
                end
                local txtPlantWord2 = GetElement(element, "txtPlantWord2_conFieldBtn", WZUILabelTTF)
                txtPlantWord2:setText(strTime)
                txtSize = txtPlantWord2:getContentSize()
                if txtSize.width > nConWidth then 
                    nConWidth = txtSize.width 
                end
                nHeight = nHeight + txtSize.height + 20 
                --增产化肥提示语节点
                fertilizerWords = GetElement(element, "txtPlantWord3_conFieldBtn", WZUILabelTTF)
                reduceWords = GetElement(element, "txtPlantWord4_conFieldBtn", WZUILabelTTF)
            elseif tData.plantStatus == PLANT_STATUS.MATURITY then 
                nConWidth = 115
                --产量
                GetElement(element, "txtPlantWord1_conFieldBtn", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[68])
                GetElement(element, "txtPlantNum1_conFieldBtn", WZUILabelTTF):setText(tData.totalNum)
                --剩余
                GetElement(element, "txtPlantWord2_conFieldBtn", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[69])
                GetElement(element, "txtPlantNum2_conFieldBtn", WZUILabelTTF):setText(tData.leftNum)
                --经验
                GetElement(element, "txtPlantWord3_conFieldBtn", WZUILabelTTF):setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[70])
                GetElement(element, "txtPlantNum3_conFieldBtn", WZUILabelTTF):setText(tData.plantExp)
                nHeight = 135 
                --增产化肥提示语节点
                fertilizerWords = GetElement(element, "txtPlantWord4_conFieldBtn", WZUILabelTTF)
                reduceWords = GetElement(element, "txtPlantWord5_conFieldBtn", WZUILabelTTF)
            end

            local bIsHavedFertilizer = false --是否施过增产肥
            if fertilizerWords and fertilizerInc and fertilizerInc > 0 then 
                local basidData = GDatatab_item["id_" .. fertilizerInc]
                if basidData then 
                    fertilizerWords:setText(string.format(LocalStrings.HOLIDAYVILLAGE_TEXT1[75], basidData.value))
                    local txtSize = fertilizerWords:getContentSize()
                    if txtSize.width > nConWidth then 
                        nConWidth = txtSize.width
                    end
                    nHeight = nHeight + txtSize.height + 20 
                    bIsHavedFertilizer = true 
                end
            end
            if not bIsHavedFertilizer then 
                reduceWords = fertilizerWords
            end
            if reduceWords and tData.reduceNumes and tData.reduceNumes > 0 then 
                reduceWords:setText(LocalStrings.HOLIDAYVILLAGE_TEXT1[91] .. tData.reduceNumes)
                local txtSize = reduceWords:getContentSize()
                if txtSize.width > nConWidth then 
                    nConWidth = txtSize.width
                end
                nHeight = nHeight + txtSize.height + 20 
            end
            conPlantDetail:setAbsContentSize(GlobalMethod:CCSize(nConWidth + 20, nHeight))
            conPlantDetail:updateRelativeSize()

            if ProjConfig.LANGUAGE == "vn" then
                for i = 1, 3 do
                    GetElement(element, "txtPlantWord" .. i .. "_conFieldBtn", WZUILabelTTF):setScale(0.7)
                    GetElement(element, "txtPlantNum" .. i .. "_conFieldBtn", WZUILabelTTF):setScale(0.7)
                end
            end
        end
    end
end

--@brief    隐藏操作按钮
function WndHVOperate:_hideOperateBtn()
    local conForBuilding = nil
    if self.m_nWinType == 0 then 
        conForBuilding = GetElement(self.m_tLuaTable.m_root, "conForBuilding_holidayVillageMap", WZUIContainer)
    elseif self.m_nWinType == 1 then 
        conForBuilding = GetElement(self.m_tLuaTable.m_root, "conForBuilding_hvTreeScene", WZUIContainer)
    end
    if conForBuilding == nil then return end 
    local nTag = 99989
    local element = conForBuilding:getChildByTag(nTag)
    if element then 
        element:setVisible(false)
    end

    local clickInfo = self.m_tLuaTable:getClickFieldData()
    if clickInfo and clickInfo.tCell then
        clickInfo.tCell:setArrowVisible(false)
        self.m_tLuaTable:setOperateType(0)
    end
end

--@brief    iphoneX适配
function WndHVOperate:_adaptIphoneX()
    if IsIphoneX() then
        GetElement(self.m_root, "conRightButtom_WndHVOperate", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.04,0.27))
        GetElement(self.m_root, "conLeftBtnFriend_WndHVOperate", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.04,0.27))
        local conRankList = GetElement(self.m_root,"conRankList_WndHVOperate",WZUIContainer)
        conRankList:setRelativePosition(GlobalMethod:ccp(0.955, 0.46))
        GetElement(self.m_root, "conWish_WndHVOperate", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.955,0.67))
    end
end

--@brief    设置鲜花订单按钮是否可见
function WndHVOperate:_setFlowerOrderBtnVisible(bVisible, bRedDotVisible)
    if self.m_root == nil then return end 
    
    if bVisible ~= nil then 
        GetElement(self.m_root, "btnFlowerOrder_WndHVOperate", WZUIButton):setVisible(bVisible)
    end

    if bRedDotVisible ~= nil then 
        GetElement(self.m_root, "imgOrderRed_WndHVOperate", WZUIImage):setVisible(bRedDotVisible)
    end
end

--@brief    显示头像框和信息框
function WndHVOperate:showFrame()
    local tbFrame = GetElement(self.m_root, "tbFrame_WndHVOperate", WZUITableContainer)
    tbFrame:cleanTable()
    local conFrame = GetElement(self.m_root, "conFrame_WndHVOperate", WZUIContainer)

    local tListData = {}
    local tAllFlowerpots = CacheCenter:getAllFlowerpot()
    local hostInfo = self.m_tLuaTable:getHostInfo()
    WZLog("WndHVOperate:showFrame 000", self.m_nTabIndex, #tAllFlowerpots)
    self.m_tCellUsing = nil 
    local nUsingId = 0 
    if self.m_nTabIndex == 1 then 
        local nSubType = 3
        tListData = CacheCenter:getHVFlowerpots(nSubType)
        if hostInfo.houseId and hostInfo.houseId > 0 then 
            nUsingId = hostInfo.houseId
            local bIsNeedAdd = true 
            for i = 1, #tListData do
                if tListData[i].id == hostInfo.houseId then 
                    bIsNeedAdd = false 
                    break 
                end
            end
            if bIsNeedAdd then 
                local tTempItem = {}
                tTempItem.id = hostInfo.houseId
                tTempItem.lastTime = 1
                tTempItem.lastNum = 1
                tTempItem.isUse = true
                tTempItem.basicInfo = CopyTable(GDatatab_item["id_" .. hostInfo.houseId])
                if tTempItem.basicInfo ~= nil then
                    tTempItem.maintype = tTempItem.basicInfo.main_type
                    tTempItem.subtype = tTempItem.basicInfo.sub_type
                end

                table.insert(tListData, 1, tTempItem)
            end
        end
        --创建可用小屋列表
        if #tListData < #tAllFlowerpots then 
            for i = 1, #tAllFlowerpots do
                if tAllFlowerpots[i].sub_type == nSubType then 
                    local bIsExist = false 
                    for j = 1, #tListData do
                        if tListData[j].id == tAllFlowerpots[i].id then 
                            bIsExist = true
                            break 
                        end
                    end
                    if not bIsExist then 
                        local tTempItem = {}
                        tTempItem.id = tAllFlowerpots[i].id 
                        tTempItem.lastTime = 0
                        tTempItem.lastNum = 0
                        tTempItem.isUse = false
                        tTempItem.basicInfo = CopyTable(tAllFlowerpots[i])
                        if tTempItem.basicInfo ~= nil then
                            tTempItem.maintype = tTempItem.basicInfo.main_type
                            tTempItem.subtype = tTempItem.basicInfo.sub_type
                        end

                        table.insert(tListData, tTempItem)
                    end
                end
            end
        end
    elseif self.m_nTabIndex == 2 then 
        local nSubType = 4
        tListData = CacheCenter:getHVFlowerpots(nSubType)
        if hostInfo.waterWheelId and hostInfo.waterWheelId > 0 then 
            nUsingId = hostInfo.waterWheelId
            local bIsNeedAdd = true 
            for i = 1, #tListData do
                if tListData[i].id == hostInfo.waterWheelId then 
                    bIsNeedAdd = false 
                    break 
                end
            end
            if bIsNeedAdd then 
                local tTempItem = {}
                tTempItem.id = hostInfo.waterWheelId
                tTempItem.lastTime = 1
                tTempItem.lastNum = 1
                tTempItem.isUse = true
                tTempItem.basicInfo = CopyTable(GDatatab_item["id_" .. hostInfo.waterWheelId])
                if tTempItem.basicInfo ~= nil then
                    tTempItem.maintype = tTempItem.basicInfo.main_type
                    tTempItem.subtype = tTempItem.basicInfo.sub_type
                end

                table.insert(tListData, 1, tTempItem)
            end
        end
        --创建可用水车列表
        if #tListData < #tAllFlowerpots then 
            for i = 1, #tAllFlowerpots do
                if tAllFlowerpots[i].sub_type == nSubType then 
                    local bIsExist = false 
                    for j = 1, #tListData do
                        if tListData[j].id == tAllFlowerpots[i].id then 
                            bIsExist = true
                            break 
                        end
                    end
                    if not bIsExist then 
                        local tTempItem = {}
                        tTempItem.id = tAllFlowerpots[i].id 
                        tTempItem.lastTime = 0
                        tTempItem.lastNum = 0
                        tTempItem.isUse = false
                        tTempItem.basicInfo = CopyTable(tAllFlowerpots[i])
                        if tTempItem.basicInfo ~= nil then
                            tTempItem.maintype = tTempItem.basicInfo.main_type
                            tTempItem.subtype = tTempItem.basicInfo.sub_type
                        end

                        table.insert(tListData, tTempItem)
                    end
                end
            end
        end
    end
    if tListData == nil or #tListData == 0 then 
        ShowPanelNullTip( conFrame, LocalStrings.CHARM_RESULT)
        return 
    end

    table.sort(tListData, sortHeadAndInfoRect)
    removeShowPanelNullTip(conFrame)

    for i = 1, #tListData do
        local celElement,tCell = CellGoodItem:createElement()
        if celElement and tCell then
            celElement:setTag(i - 1)
            tCell:setCellGoodItem(tListData[i], 2)
            tCell:setItemClickFun(self, self.onItemClick)
            if tListData[i].lastNum == 0 then 
                tCell:setGrayRender(true)
            end
            if tListData[i].id == nUsingId then 
                self.m_tCellUsing = tCell
                tCell:setWear(true)
            end

            tbFrame:setCellElement(celElement)
        end
    end
end

--@brief    点击物品回调
function WndHVOperate:onItemClick(tCell,tag,tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local hostInfo = self.m_tLuaTable:getHostInfo()
    local tempData = CopyTable(tData)
    local operateId = nil 
    if tData.basicInfo.sub_type == 3 then 
        operateId = hostInfo.houseId
    elseif tData.basicInfo.sub_type == 4 then 
        operateId = hostInfo.waterWheelId
    end
    if operateId and tData.basicInfo.id == operateId then 
        tempData.tBtnList = {LocalStrings.UNROYAL}
        tempData.basicInfo.nBtnTag = 1
    elseif tData.lastNum > 0 then 
        tempData.tBtnList = {LocalStrings.FAMILYSHOP2}
        tempData.basicInfo.nBtnTag = 2
    else
        tempData.tBtnList = {LocalStrings.SKINSKILL4}
        tempData.basicInfo.nBtnTag = 3
    end
    self.m_tCellOperate = tCell
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1, tempData, true,nil,true) 
    WndItemInfo:setClickButtonCallback(self,self.operateDecoration)
end

--@brief    卸下装饰按钮回调
function WndHVOperate:operateDecoration(nTag, tData)
    WZLog("WndHVOperate:operateDecoration", Serialize(tData))
    if tData.basicInfo.nBtnTag == 1 then --卸下
        ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_Decorations(tData.basicInfo.id)
    elseif tData.basicInfo.nBtnTag == 2 then --装饰
        ProtocolProcessorHolidayVillage:send_HOLIDAYVILLAGE_Decorations(tData.basicInfo.id)
    elseif tData.basicInfo.nBtnTag == 3 then --装饰
        WndFastGetItems:show(tData.basicInfo.id, 1)
    end
end

--@brief    设置许愿按钮的状态
--@param    opTime:0=显示
--@param    useTime:今天已经许愿次数
--@param    lastWishTime:上次许愿时间戳
function WndHVOperate:_setWishBtnState(opType, useTimes, lastWishTime)
    WZLog("WndHVOperate:_setWishBtnState", tostring(self.m_root))
    if self.m_root == nil then return end 

    if self.m_nWinType == 1 then 
        local txtWishTime = GetElement(self.m_root, "txtWishTime_WndHVOperate", WZUILabelTTF)
        local txtColdTime = GetElement(self.m_root, "txtColdTime_WndHVOperate", WZUILabelTTF)
        local txtColdWords = GetElement(self.m_root, "txtColdWords_WndHVOperate", WZUILabelTTF)
        local btnWish = GetElement(self.m_root, "btnWish_WndHVOperate", WZUIButton)
        local nCurTime = SystemTime:getServerTime()

        if opType == 0 then 
            local nLeftSeconds = self.m_tWishConfig[2] + lastWishTime - nCurTime 
            local nLeftTimes = self.m_tWishConfig[1] - useTimes
            self.m_nUseWishTimes = useTimes
            txtWishTime:setText(LocalStrings.SHOP_GOODSSHEGN .. nLeftTimes .. LocalStrings.SHOP_CISHU)
            if nLeftSeconds > 0 then 
                btnWish:setTouchEnable(false)
                txtColdWords:setVisible(true)
                local minutes = math.floor(nLeftSeconds/60)
                local seconds = nLeftSeconds%60
                txtColdTime:setText(string.format("%02d:%02d", minutes, seconds))
                if self.m_nLastWishTime == nil or self.m_nLastWishTime ~= lastWishTime then 
                    self.m_nLastWishTime = lastWishTime
                    btnWish:enableSchedule("_countDownWishCold", 1)
                end
            else
                if self.m_nLastWishTime == nil then 
                    self.m_nLastWishTime = lastWishTime
                end
                if nLeftTimes > 0 then 
                    btnWish:setTouchEnable(true)
                else
                    btnWish:setTouchEnable(false)
                end
                txtColdWords:setVisible(false)
                txtColdTime:setText("")
                btnWish:disableSchedule()
            end
        elseif opType == 1 then 
            local nLeftTimes = self.m_tWishConfig[1] - self.m_nUseWishTimes
            if nLeftTimes > 0 then 
                btnWish:setTouchEnable(true)
            else
                btnWish:setTouchEnable(false)
            end
            txtColdWords:setVisible(false)
            txtColdTime:setText("")
            btnWish:disableSchedule()
        end
    end
end

--@brief    许愿冷却时间倒计时
function WndHVOperate:_countDownWishCold(element)
    if self.m_nLastWishTime == nil then return end 

    local nCurTime = SystemTime:getServerTime()

    local nLeftSeconds = self.m_tWishConfig[2] + self.m_nLastWishTime - nCurTime 
    local txtColdTime = GetElement(self.m_root, "txtColdTime_WndHVOperate", WZUILabelTTF)
    if nLeftSeconds > 0 then 
        local minutes = math.floor(nLeftSeconds/60)
        local seconds = nLeftSeconds%60
        txtColdTime:setText(string.format("%02d:%02d", minutes, seconds))
    else
        self:_setWishBtnState(1)
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndHVOperate:_adaptLanguage_vn()
    GetElement(self.m_root, "txtEnergyWord_WndHVOprate", WZUILabelTTF):setScale(0.5)
    GetElement(self.m_root, "txtFriendHV_WndHVOperate", WZUILabelTTF):setScale(0.8)
end

-------------------------------------语言适配End----------------------------------------
