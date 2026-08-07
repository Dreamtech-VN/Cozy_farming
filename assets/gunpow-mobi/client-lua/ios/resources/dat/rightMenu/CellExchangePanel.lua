--CellExchangePanel.lua
--@brief	CellExchangePanel的UI模块
--@date		2016/08/13
--@author	Tianxiang_Xu
--@note		物品兑换活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellExchangePanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellExchangePanel:onExit(element)
	self:_unInit()
end

--@brief    显示
function CellExchangePanel:showWindow()
    -- body
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE then
        local conConSume = GetElement(self.m_root, "conConSume_CellExchangePanel", WZUIContainer)
        if conConSume then
            conConSume:setAbsContentSize(GlobalMethod:CCSize(500,210))
            conConSume:updateRelativeSize()
        end
    end
    self:_showTime()
    self:_showList()
    if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE then
        self:_createRuleBtn()
    else
        self:_setExplainMessage()
    end
end

--@brief    点击兑换回调
--@brief    兑换的奖励Id
function CellExchangePanel:onClickExchange(rewardId)
    -- body
    WZLog("CellExchangePanel:onClickExchange", rewardId)
    self.m_ClickRewardId = rewardId

    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_activityId, self.m_ClickRewardId)
end

--@brief    点击规则按钮回调
function CellExchangePanel:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.NEWEXCHANGE_TEXT3) 
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    设置活动时间
function CellExchangePanel:_showTime()
    -- body
    --字“活动时间”
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellExchangePanel", WZUILabelTTF)
    if txtTimeWord then
        txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    --活动时间
    local txtTime = GetElement(self.m_root, "txtTime_CellExchangePanel", WZUILabelTTF)
    if txtTime then
        local sStartDate = os.date("*t", self.m_startTime)
        local sEndDate = os.date("*t", self.m_endTime)
        txtTime:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, sStartDate.month, sStartDate.day, sStartDate.hour, sStartDate.min, sEndDate.month, sEndDate.day, sEndDate.hour, sEndDate.min))
    end
    --展示图片
    local bIsDraw = false 
    if self.m_tips[1] ~= nil then
        local nStart, nEnd = string.find(self.m_tips[1], ".png")
        if nStart then
            local imgBK = GetElement(self.m_root, "imgBK_CellExchangePanel", WZUIImage)
            bIsDraw = true
            if imgBK then
                imgBK:setFile(self.m_tips[1])
            end

            --调整容器大小
            if self.m_tips[2] ~= nil and (tonumber(self.m_tips[2]) == 6 or tonumber(self.m_tips[2]) == 7) then   --兑换称号
                local conConSume = GetElement(self.m_root, "conConSume_CellExchangePanel", WZUIContainer)
                if conConSume then
                    conConSume:setAbsContentSize(GlobalMethod:CCSize(500,200))
                    conConSume:updateRelativeSize()
                end
                local conRule = GetElement(self.m_root, "conRule_CellExchangePanel", WZUIContainer)
                if conRule then
                    conRule:setAbsContentSize(GlobalMethod:CCSize(250,90))
                    conRule:updateRelativeSize()
                    conRule:setRelativePosition(GlobalMethod:ccp(0.26,-0.05))
                end
                local conForTitle = GetElement(self.m_root, "conForTitle_CellExchangePanel", WZUIContainer)
                --称号特效
                local tDataTitie
                if tonumber(self.m_tips[2]) == 6 then
                    tDataTitie = GDatatab_achievement["id_11030"]
                elseif tonumber(self.m_tips[2]) == 7 then
                    tDataTitie = GDatatab_achievement["id_11031"]
                end
                local nodeLabel = WZUILabelTTF:create()
                nodeLabel:setFontSize(22)
                nodeLabel:setColor(GlobalMethod:ccc3(229,105,22))
                nodeLabel:setEnableStroke(true)
                nodeLabel:setStrokeSize(4)
                nodeLabel:setStrokeColor(GlobalMethod:ccc3(105,65,46))
                nodeLabel:setRelativePosition(GlobalMethod:ccp(0.27,0.48))

                CreateDesiSpine(conForTitle, nodeLabel, tDataTitie.name, GlobalMethod:ccp(0.27,0.75))

                conForTitle:addChild(nodeLabel)
            else
                if self.m_nActivityType ~= g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE then
                    local conConSume = GetElement(self.m_root, "conConSume_CellExchangePanel", WZUIContainer)
                    if conConSume then
                        conConSume:setAbsContentSize(GlobalMethod:CCSize(500,200))
                        conConSume:updateRelativeSize()
                    end
                    local conRule = GetElement(self.m_root, "conRule_CellExchangePanel", WZUIContainer)
                    if conRule then
                        if tonumber(self.m_tips[2]) == 8 then
                            conRule:setAbsContentSize(GlobalMethod:CCSize(250,90))
                            conRule:setRelativePosition(GlobalMethod:ccp(0.26,-0.08))
                        else
                            conRule:setAbsContentSize(GlobalMethod:CCSize(250,160))
                            conRule:setRelativePosition(GlobalMethod:ccp(0.26,0.16))
                        end
                        conRule:updateRelativeSize()
                    end
                end
            end
            local txtDesc = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
            if txtDesc then
                txtDesc:setMaxWidth(250)
            end
            --角色的待机
            if self.m_tips[2] ~= nil then   --兑换称号
                if tonumber(self.m_tips[2]) == 6 then
                    local tData = {}
                    local tItem = {}
                    tItem.headId = 4212
                    tItem.faceId = 4412
                    tItem.bodyId = 4612
                    tItem.sex = 1 
                    table.insert(tData, tItem)
                    local tData2 = {}
                    tData2.headId = 4112
                    tData2.faceId = 4312
                    tData2.bodyId = 4512
                    tData2.sex = 0 
                    table.insert(tData, tData2)
                    self:_setPlayer(tData, false, GlobalMethod:ccp(0.5,-0.5))
                end
            else
                if self.m_nActivityType ~= g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE then
                    local tData = {}
                    local tItem = {}
                    tItem.headId = 4213
                    tItem.faceId = 4413
                    tItem.bodyId = 4613
                    tItem.sex = 1 
                    table.insert(tData, tItem)
                    local tData2 = {}
                    tData2.headId = 4113
                    tData2.faceId = 4313
                    tData2.bodyId = 4513
                    tData2.sex = 0 
                    table.insert(tData, tData2)
                    self:_setPlayer(tData, false, GlobalMethod:ccp(0.5,-0.5))
                end
            end
        end
    end

    if not bIsDraw and self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE then
        GetElement(self.m_root, "imgBK_CellExchangePanel", WZUIImage):setFile("ui/gameActivity/activity_pic_dhhd2.png")
    end 
end

--@brief    显示兑换列表、
function CellExchangePanel:_showList()
    -- body
    local flconList = GetElement(self.m_root, "flconList_CellExchangePanel", WZUIFreeListContainer)
    flconList:removeAll()

    local nCount = #self.m_rewardCounts
    
    local tData = {}
    local nIndex = 1 
    for i = 1, nCount do
        local tItem = {}
        tItem.tRewardData = {}
        tItem.tConsumeData = {}
        if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_EXCHANGE or self.m_nActivityType == g_tGameActivityTypes.ACIVIITY_OLD_EXCHANGE then
            local tRewardData = {}
            tRewardData.id = self.m_rewardItems[(i - 1)*2 + 1]
            tRewardData.num = self.m_rewardItems[(i - 1)*2 + 2]
            table.insert(tItem.tRewardData, tRewardData)
            for j = 1, self.m_rewardItemsParamCount[i] do
                --消耗物品数据
                local tConsumeData = {}
                tConsumeData.id = self.m_target[nIndex]
                tConsumeData.num = self.m_target[nIndex + 1]
                table.insert(tItem.tConsumeData, tConsumeData)

                nIndex = nIndex + 2
            end
        elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE then
            local tConsumeData = {}
            tConsumeData.id = self.m_target[(i - 1)*2 + 1]
            tConsumeData.num = self.m_target[(i - 1)*2 + 2]
            table.insert(tItem.tConsumeData, tConsumeData)
            for j = 1, self.m_rewardItemsParamCount[i] do
                --消耗物品数据
                local tRewardData = {}
                tRewardData.id = self.m_rewardItems[nIndex]
                tRewardData.num = self.m_rewardItems[nIndex + 1]
                local tBasicData = GDatatab_item["id_" .. self.m_rewardItems[nIndex]]
                if tBasicData and (tBasicData.sex == 2 or tBasicData.sex == CacheCenter:getPlayerInfo().sex) then
                    table.insert(tItem.tRewardData, tRewardData)
                end

                nIndex = nIndex + 2
            end
        end

        table.insert(tData, tItem)
    end
    
    self.m_tCellObj = {}
    for i = 1, nCount do
        if self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_EXCHANGE or self.m_nActivityType == g_tGameActivityTypes.ACIVIITY_OLD_EXCHANGE then 
            local element, tNewObj = CellExchangeItem:createElement()
            if element and tNewObj then
                tNewObj:setData(tData[i].tRewardData, tData[i].tConsumeData, self.m_rewardCounts[i], self.m_rewardId[i])
                tNewObj:setCallBackFunc(self, self.onClickExchange)
                element:setTag(i - 1)
                element = WZUIContainer:luaTo(element)
                element:setAbsContentSize(GlobalMethod:CCSize(486,106))
                element:setRelativeSize(GlobalMethod:CCSize(1,106/310))
                if self.m_tips[1] ~= nil then
                    local nStart, nEnd = string.find(self.m_tips[1], ".png")
                    if nStart then
                        element:setAbsContentSize(GlobalMethod:CCSize(486,106))
                        element:setRelativeSize(GlobalMethod:CCSize(1,106/200))
                    end
                end
                flconList:pushBack(element)

                table.insert(self.m_tCellObj, tNewObj)
            end
        elseif self.m_nActivityType == g_tGameActivityTypes.ACTIVITY_NEW_EXCHANGE then
            local element, tNewObj = CellNewExchangeItem:createElement()
            if element and tNewObj then
                tNewObj:setData(tData[i].tRewardData, tData[i].tConsumeData, self.m_rewardCounts[i], self.m_rewardId[i])
                tNewObj:setCallBackFunc(self, self.onClickExchange)
                element:setTag(i - 1)
                element = WZUIContainer:luaTo(element)
                element:setAbsContentSize(GlobalMethod:CCSize(486,138))
                element:setRelativeSize(GlobalMethod:CCSize(1,138/210))
                if self.m_tips[1] ~= nil then
                    local nStart, nEnd = string.find(self.m_tips[1], ".png")
                    if nStart then
                        element:setAbsContentSize(GlobalMethod:CCSize(486,138))
                        element:setRelativeSize(GlobalMethod:CCSize(1,138/200))
                    end
                end
                flconList:pushBack(element)

                table.insert(self.m_tCellObj, tNewObj)
            end
        end
    end

    flconList:getMoveElement():setPositionY(flconList:getMinPosition().y)
end

--@brief 设置活动说明内容
function CellExchangePanel:_setExplainMessage( )
    local txtDesc1 = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
    txtDesc1:setShowText(self.m_content) 
    self:_upMoveContainerLayer()
end

--@brief    更新滚动容器内部布局函数
function CellExchangePanel:_upMoveContainerLayer()
    WZLog("self:_upMoveContainerLayer()")
    if self.m_root == nil then
        return
    end
    --获取规则说明内容文本的大小
    local txtExplanation = GetElement(self.m_root, "txtDesc1", WZUIFreeTextBox)
    local txtSize = txtExplanation:getContentSize() 
    txtExplanation:setAnchorPoint(GlobalMethod:ccp(0,1))
    txtExplanation:setPositionY(txtSize.height)
    WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
--
    
    local rollconExplanation = self.m_root:getChildElement("rollconExplanation_CellExchangePanel")
    if rollconExplanation == nil then 
        return
    end
    rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
    local rollSize = rollconExplanation:getContentSize()
    --更改滚动容器Element的大小
    local moveElement = rollconExplanation:getMoveElement()
    local size = moveElement:getRelativeSize()
    moveElement:setRelativeSize( GlobalMethod:CCSize(1 , txtSize.height / rollSize.height ) )
    rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
    moveElement:setPositionY(rollconExplanation:getMinPosition().y)
    WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

--@brief   玩家人物
--@param   tData玩家数据
--@param    角色的锚点
function CellExchangePanel:_setPlayer(tData, bFlipX, ccpAnchor)
    if self.m_root == nil then return end

    local anchorPoint = ccpAnchor or GlobalMethod:ccp(0.5, 0)
    local bBool = bFlipX or false
    for i = 1, #tData do
        local nSex = tData[i].sex or 0
        local tEquip = {}
        table.insert(tEquip,tData[i].headId)
        table.insert(tEquip,tData[i].faceId)
        table.insert(tEquip,tData[i].bodyId)
        table.insert(tEquip,tData[i].wingId)

        local conPlayerAni = GetElement(self.m_root, string.format("conRole%d_CellExchangePanel", i), WZUIContainer)

        local conPlayer = CreatePlayerFigure(nSex, tEquip, "wait0")
        conPlayerAni:addChild(conPlayer:getAnimNode())
        conPlayer:getAnimNode():setScale(0.85)
        conPlayer:setFlipX(bBool)
        conPlayer:getAnimNode():setRelativePosition(anchorPoint) 
    end
end

--@brief    创建规则按钮
function CellExchangePanel:_createRuleBtn()
    -- body
    local btnRule = WZUIButton:create()
    btnRule:setName("btnRule_CellExchangePanel")
    btnRule:setUseAbsSize(true)
    btnRule:setAbsContentSize(GlobalMethod:CCSize(60,60))
    btnRule:setRelativePosition(GlobalMethod:ccp(0.95,0.95))
    local imgNor = WZUIImage:create()
    imgNor:setUseOriginSize(true)
    imgNor:setFile("ui/common/common_icon_gth.png")
    local imgSel = WZUIImage:create()
    imgSel:setUseOriginSize(true)
    imgSel:setFile("ui/common/common_icon_gth.png")
    imgSel:setScale(1.1)
    btnRule:setNormalElement(imgNor)
    btnRule:setSelectElement(imgSel)
    btnRule:setLuaDoneFunctionName("onClickRule")

    self.m_root:addChild(btnRule)
end
-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin------------------------------------------
function CellExchangePanel:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtTime_CellExchangePanel",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end
--------------------------------------语言适配End-------------------------------------------