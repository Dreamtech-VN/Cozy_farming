--WndTabooBoxOpen.lua
--@brief	WndTabooBoxOpen的UI模块
--@date		2017/05/03


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTabooBoxOpen:onEnter(element)
	self.m_root = element
    self.isUseTicket = CacheCenter:getGameParam().isUseTicket
	self:_initView()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTabooBoxOpen:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndTabooBoxOpen:onBtnCloseClick(element)
    WZLog("WndTabooBoxOpen:onBtnCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

-- 点击物品后的回调
function WndTabooBoxOpen:onClickListItem(tItem, nTag, tData)
    WZLog("WndTabooBoxOpen:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false, nil, true)
end

--@brief	开启解锁宝箱点击回调
function WndTabooBoxOpen:onBtnOpenStartClick(element)
    WZLog("WndTabooBoxOpen:onBtnOpenStartClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --有在解锁宝箱
    if self.m_tData.boxCountdown > 0 then
        MsgBoxManager:showTipBox(LocalStrings.TABOO_BOX_OPENING,nil,nil,nil,nil,nil,nil,nil,true)
        return
    end
	ProtocolProcessorTaboo:send_ZONE_ChoiceBox(1, self.m_tData.boxIndex)


end

--@brief	立即解锁宝箱点击回调
function WndTabooBoxOpen:onBtnOpenCostClick(element)
    WZLog("WndTabooBoxOpen:onBtnOpenCostClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local cost = 0
    if self.m_nLeftTime then
        cost = tonumber(CacheCenter:getGameParam().boxOpenPricePerMin) * math.ceil(self.m_nLeftTime/60)
    end

    local fragmentCount =  CacheCenter:getPlayerItemCountById(1)

    if self.isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, cost, nil, nil, Chat_Channel_Taboo_Section, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
            return
        end
    else
        if not JudgeMoneyIsEnough(1, cost, nil, nil, Chat_Channel_Taboo_Section, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
            return
        end
    end

    self:sureToUseDiamondInstead()
end

--@brief    用钻石代替礼券开启宝箱确认按钮回调
function WndTabooBoxOpen:sureToUseDiamondInstead()
    -- body
    SceneTabooBattle.g_currentBoxId = self.m_tData.boxId

    ProtocolProcessorTaboo:send_ZONE_ChoiceBox(3, self.m_tData.boxIndex)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	领取解锁宝箱点击回调
function WndTabooBoxOpen:onBtnOpenComClick(element)
    WZLog("WndTabooBoxOpen:onBtnOpenComClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
    SceneTabooBattle.g_currentBoxId = self.m_tData.boxId

	ProtocolProcessorTaboo:send_ZONE_ChoiceBox(2, self.m_tData.boxIndex)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	领取额外宝箱点击回调
function WndTabooBoxOpen:onBtnOpenCommonClick(element)
    WZLog("WndTabooBoxOpen:onBtnOpenCommonClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local template = GDatatab_item["id_"..self.m_tData.boxId]
	local cost = 0
    
    if self.m_nBoxType == 2 then
        cost = template.value
    else
        cost = math.ceil(template.value/60) * tonumber(CacheCenter:getGameParam().boxOpenPricePerMin)
        if self.m_tData.boxStatus == 2 then
            cost = math.ceil(self.m_tData.boxCountdown/60) * tonumber(CacheCenter:getGameParam().boxOpenPricePerMin)
        end
    end

    local fragmentCount =  CacheCenter:getPlayerItemCountById(1)

    if self.isUseTicket == "0" then
        if not JudgeMoneyIsEnough(70, cost, nil, nil, Chat_Channel_Taboo_Section, nil, nil, nil, nil, self, self.sureToUseDiamondInstead2) then
            return
        end
    else
        if not JudgeMoneyIsEnough(1, cost, nil, nil, Chat_Channel_Taboo_Section, nil, nil, nil, nil, self, self.sureToUseDiamondInstead2) then
            return
        end
    end
    
    self:sureToUseDiamondInstead2()
end

--@brief	放弃宝箱点击回调
function WndTabooBoxOpen:onBtnOpenCommonCancelClick(element)
    WZLog("WndTabooBoxOpen:onBtnOpenCommonCancelClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nBoxType == 2 then
	   ProtocolProcessorTaboo:send_ZONE_ChoiceDiamondBox(2)
    else
        ProtocolProcessorTaboo:send_ZONE_ChoiceBox(5,3)
    end
    self.m_bIsBoxAction = false
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    用钻石代替礼券开启宝箱确认按钮回调
function WndTabooBoxOpen:sureToUseDiamondInstead2()
    -- body
    if self.m_nBoxType == 2 then
       ProtocolProcessorTaboo:send_ZONE_ChoiceDiamondBox(1)
    else
        if self.m_tData.boxStatus == 1 then
            ProtocolProcessorTaboo:send_ZONE_ChoiceBox(3,self.m_tData.boxIndex)
        elseif self.m_tData.boxStatus == 2 then
            ProtocolProcessorTaboo:send_ZONE_ChoiceBox(3,self.m_tData.boxIndex)
        else
            ProtocolProcessorTaboo:send_ZONE_ChoiceBox(2,self.m_tData.boxIndex)
        end
        ProtocolProcessorTaboo.g_bOffRushBox = true
        SceneTabooBattle.g_currentBoxId = self.m_tData.boxId
    end
    self.m_bIsBoxAction = true
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief
function WndTabooBoxOpen:_initView()
    WZLog("WndTabooBoxOpen:_initView",self.m_tData.boxId)

    GetElement(self.m_root,"txtBox_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_GET_DES)
    
    local template = GDatatab_item["id_"..self.m_tData.boxId]

    local imgPath = template.icon
    
    local img = GetElement(self.m_root,"imgBox_WndTabooBoxOpen",WZUIImage)
    img:setFile(imgPath)

    local imgCostIcon1 = GetElement(self.m_root, "imgCostIcon1_WndTabooBoxOpen", WZUIImage)
    if imgCostIcon1 then
        if self.isUseTicket == "0" then
            imgCostIcon1:setFile(GDatatab_item["id_70"].icon)
        else
            imgCostIcon1:setFile(GDatatab_item["id_1"].icon)
        end
        imgCostIcon1:setScale(0.5)
    end

    local imgCostIcon2 = GetElement(self.m_root, "imgCostIcon2_WndTabooBoxOpen", WZUIImage)
    if imgCostIcon2 then
        if self.isUseTicket == "0" then
            imgCostIcon2:setFile(GDatatab_item["id_70"].icon)
        else
            imgCostIcon2:setFile(GDatatab_item["id_1"].icon)
        end
        imgCostIcon2:setScale(0.5)
    end

    local conTabReward = GetElement(self.m_root, "conTabReward_WndTabooBoxOpen", WZUITableContainer)
    conTabReward:cleanTable()

    local sex = CacheCenter:getPlayerInfo().sex
    local giftList = {}
    local sexIndex = {"man_item_id","woman_item_id"}
    for k,v in pairs(GDatatab_gifts) do
        if v.item_id ==  self.m_tData.boxId then
            local temp = {}
            temp.id = v[sexIndex[sex+1]]
            temp.count = v["count"]
            temp.sortId = v.id
            table.insert(giftList,temp)
        end
    end

    local sortFunc = function(a, b) return a.sortId > b.sortId end
    table.sort(giftList , sortFunc)

    local list = GetSortRewardItemList(giftList)
    --奖励显示
    for i = 1 ,#list do
        WZLog("WndTabooBoxOpen:_initView list",i)
        local eItem, tItem = self:_createCellGoodItem(list[i].count,list[i].id)
        eItem:setTag(i-1)
        conTabReward:setCellElement(eItem)
    end
    self:_updateState()
end

--@brief 状态刷新
function WndTabooBoxOpen:_updateState()
    local conBtnOpen = GetElement(self.m_root,"conBtnOpen_WndTabooBoxOpen",WZUIContainer)
    local conBtnOpenCom = GetElement(self.m_root,"conBtnOpenCom_WndTabooBoxOpen",WZUIContainer)
    local conBtnOpenCommon = GetElement(self.m_root,"conBtnOpenCommon_WndTabooBoxOpen",WZUIContainer)
    conBtnOpen:setVisible(false)
    conBtnOpenCom:setVisible(false)
    conBtnOpenCommon:setVisible(false)
    self:_setCountDown(false)
    self.m_nLeftTime = nil
    --无宝箱
    if self.m_tData.boxStatus == 0 then
        return
    end
    

    local template = GDatatab_item["id_"..self.m_tData.boxId]
    --解锁宝箱
    if self.m_nBoxType == 1 then
    	if self.m_tData.boxStatus == 1 then
        	--未解锁
        	conBtnOpen:setVisible(true)
        	local openTime = template.value
        	local sNextTime = returnToTimeFormat(math.floor(openTime))
        	GetElement(self.m_root,"labCountDown_WndTabooBoxOpen",WZUILabelTTF):setText(sNextTime)
        
        	GetElement(self.m_root,"labTop_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_TITLE1)
           
            GetElement(self.m_root,"conBtnOpenStart_WndTabooBoxOpen",WZUIContainer):setVisible(true)
            GetElement(self.m_root,"conBtnOpenCost_WndTabooBoxOpen",WZUIContainer):setVisible(false)

	    elseif self.m_tData.boxStatus == 2 then
	        --正在解锁
	        conBtnOpen:setVisible(true)
	    	self.m_nLeftTime = self.m_tData.boxCountdown
	    	GetElement(self.m_root,"conBtnOpenStart_WndTabooBoxOpen",WZUIContainer):setVisible(false)
        	GetElement(self.m_root,"conBtnOpenCost_WndTabooBoxOpen",WZUIContainer):setVisible(true)
        	GetElement(self.m_root,"labTop_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_TITLE1)
	    	self:_setCountDown(true)
	    elseif self.m_tData.boxStatus == 3 then
	        --可领取
	        conBtnOpenCom:setVisible(true)
	        GetElement(self.m_root,"labTop_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_TITLE2)
	    end
    elseif self.m_nBoxType == 2 then
    	GetElement(self.m_root,"labTop_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_TITLE3)
        GetElement(self.m_root,"labCommonCost_WndTabooBoxOpen",WZUILabelTTF):setText(template.value)
        -- GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setVisible(true)
        GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_OPEN_COMMON_DES)
        GetElement(self.m_root,"labBtnCommonCancle_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_OPEN_CANCEL)
    	--普通宝箱
    	conBtnOpenCommon:setVisible(true)
        GetElement(self.m_root,"BtnOpenCommon1_WndTabooBoxOpen",WZUIButton):setVisible(true)
        GetElement(self.m_root,"BtnOpenCommon2_WndTabooBoxOpen",WZUIButton):setVisible(false)
    else
        local cost = math.ceil(template.value/60)*tonumber(CacheCenter:getGameParam().boxOpenPricePerMin)
        --溢出宝箱
        GetElement(self.m_root,"labTop_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_TITLE2)
        -- GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setVisible(false)
        GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_OPEN_COMMON_DES_2)
        GetElement(self.m_root,"labBtnCommonCancle_WndTabooBoxOpen",WZUILabelTTF):setText(LocalStrings.TABOO_BOX_OPEN_CANCEL2)
        conBtnOpenCommon:setVisible(true)

        if self.m_tData.boxStatus == 3 then
            GetElement(self.m_root,"BtnOpenCommon1_WndTabooBoxOpen",WZUIButton):setVisible(false)
            GetElement(self.m_root,"BtnOpenCommon2_WndTabooBoxOpen",WZUIButton):setVisible(true)
        else
            GetElement(self.m_root,"BtnOpenCommon1_WndTabooBoxOpen",WZUIButton):setVisible(true)
            GetElement(self.m_root,"BtnOpenCommon2_WndTabooBoxOpen",WZUIButton):setVisible(false)
        end
        --解锁中
        if self.m_tData.boxStatus == 2 then
            cost = math.ceil(self.m_tData.boxCountdown/60) * tonumber(CacheCenter:getGameParam().boxOpenPricePerMin)
        end
        --消耗
        GetElement(self.m_root,"labCommonCost_WndTabooBoxOpen",WZUILabelTTF):setText(cost)

    end
end


--@brief    创建一个物品格子
--@param    nIndex, 序号
--@param    nItemId, 物品id
function WndTabooBoxOpen:_createCellGoodItem(nCount, nItemId)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setScale(0.8)
    tItem:setItemClickFun(self, self.onClickListItem)
    tItem:setCellGoodLocalId(nItemId, nCount, 16)
    return eItem, tItem
end

function WndTabooBoxOpen:_setCountDown(value)
    if value == true then
        self.m_root:enableSchedule("_timeUpdate",0)
    else
        self.m_root:disableSchedule()
    end
end

--@brief 时间
function WndTabooBoxOpen:_timeUpdate(element,dt)
    if self.m_nLeftTime then
        self.m_nLeftTime = self.m_nLeftTime - dt
        if self.m_nLeftTime > 0 then
            local sNextTime = returnToTimeFormat(math.floor(self.m_nLeftTime))
            GetElement(self.m_root,"labCountDown_WndTabooBoxOpen",WZUILabelTTF):setText(sNextTime)

            local cost = tonumber(CacheCenter:getGameParam().boxOpenPricePerMin) * math.ceil(self.m_nLeftTime/60)
            GetElement(self.m_root,"labCost_WndTabooBoxOpen",WZUILabelTTF):setText(cost)
        else
           self.m_nLeftTime = nil
           self.m_root:disableSchedule()
           ProtocolProcessorTaboo:send_ZONE_GetBoxInfo()
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

------------------------------------- 语言适配Begin-----------------------------------------
function WndTabooBoxOpen:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtBtnOpenStart1_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtBtnOpenStart2_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setScale(0.75)

    local labCost = GetElement(self.m_root,"labCost_WndTabooBoxOpen",WZUILabelTTF)
    labCost:setRelativePosition(GlobalMethod:ccp(0.37,0.5))
    local imgOpenCost = GetElement(self.m_root,"imgCostIcon1_WndTabooBoxOpen",WZUIImage)
    imgOpenCost:setRelativePosition(GlobalMethod:ccp(0.51,0.52328))
    local txtOpenCost = GetElement(self.m_root,"labCost2_WndTabooBoxOpen",WZUILabelTTF)
    txtOpenCost:setRelativePosition(GlobalMethod:ccp(0.78,0.5))

    local labCost = GetElement(self.m_root,"labCommonCost_WndTabooBoxOpen",WZUILabelTTF)
    labCost:setRelativePosition(GlobalMethod:ccp(0.37,0.5))
    local imgOpenCost = GetElement(self.m_root,"imgCostIcon2_WndTabooBoxOpen",WZUIImage)
    imgOpenCost:setRelativePosition(GlobalMethod:ccp(0.51,0.52328))
    local txtOpenCost = GetElement(self.m_root,"labCommonCost2_WndTabooBoxOpen",WZUILabelTTF)
    txtOpenCost:setRelativePosition(GlobalMethod:ccp(0.78,0.5))
end

function WndTabooBoxOpen:_adaptLanguage_en(  )
    local labBtnCommonCancle = GetElement(self.m_root,"labBtnCommonCancle_WndTabooBoxOpen",WZUILabelTTF)
    labBtnCommonCancle:setScale(0.6)
    labBtnCommonCancle:setDimensions(GlobalMethod:CCSize(200))

    GetElement(self.m_root,"labCommonCost_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"imgCostIcon2_WndTabooBoxOpen",WZUIImage):setScale(0.5)
    GetElement(self.m_root,"labCommonCost2_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)
    
    GetElement(self.m_root,"labCost_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"imgCostIcon1_WndTabooBoxOpen",WZUIImage):setScale(0.5)
    GetElement(self.m_root,"labCost2_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(380))
end

function WndTabooBoxOpen:_adaptLanguage_th(  )
    local labBtnCommonCancle = GetElement(self.m_root,"labBtnCommonCancle_WndTabooBoxOpen",WZUILabelTTF)
    labBtnCommonCancle:setScale(0.6)
    labBtnCommonCancle:setDimensions(GlobalMethod:CCSize(200))

    GetElement(self.m_root,"labCommonCost_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"imgCostIcon2_WndTabooBoxOpen",WZUIImage):setScale(0.6)
    --GetElement(self.m_root,"labCommonCost2_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)
    
    GetElement(self.m_root,"labCost_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"imgCostIcon1_WndTabooBoxOpen",WZUIImage):setScale(0.6)
    --GetElement(self.m_root,"labCost2_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setScale(0.8)
end

function WndTabooBoxOpen:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtBox_WndTabooBoxOpen",WZUILabelTTF):setScale(0.7)

    local txtBtnOpenStart1 = GetElement(self.m_root,"txtBtnOpenStart1_WndTabooBoxOpen",WZUILabelTTF)
    txtBtnOpenStart1:setScale(0.7)
    txtBtnOpenStart1:setDimensions(GlobalMethod:CCSize(160))
    local txtBtnOpenStart2 = GetElement(self.m_root,"txtBtnOpenStart2_WndTabooBoxOpen",WZUILabelTTF)
    txtBtnOpenStart2:setScale(0.7)
    txtBtnOpenStart2:setDimensions(GlobalMethod:CCSize(160))

    local labCost = GetElement(self.m_root,"labCost_WndTabooBoxOpen",WZUILabelTTF)
    labCost:setScale(0.55)
    labCost:setRelativePosition(GlobalMethod:ccp(0.208029,0.5))
    local imgOpenCost = GetElement(self.m_root,"imgCostIcon1_WndTabooBoxOpen",WZUIImage)
    imgOpenCost:setScale(0.4)
    imgOpenCost:setRelativePosition(GlobalMethod:ccp(0.306554,0.52328))
    local txtOpenCost = GetElement(self.m_root,"labCost2_WndTabooBoxOpen",WZUILabelTTF)
    txtOpenCost:setScale(0.55)
    txtOpenCost:setRelativePosition(GlobalMethod:ccp(0.667883,0.5))

    local labCost = GetElement(self.m_root,"labCommonCost_WndTabooBoxOpen",WZUILabelTTF)
    labCost:setScale(0.55)
    labCost:setRelativePosition(GlobalMethod:ccp(0.208029,0.5))
    local imgOpenCost = GetElement(self.m_root,"imgCostIcon2_WndTabooBoxOpen",WZUIImage)
    imgOpenCost:setScale(0.4)
    imgOpenCost:setRelativePosition(GlobalMethod:ccp(0.306554,0.52328))
    local txtOpenCost = GetElement(self.m_root,"labCommonCost2_WndTabooBoxOpen",WZUILabelTTF)
    txtOpenCost:setScale(0.55)
    txtOpenCost:setRelativePosition(GlobalMethod:ccp(0.667883,0.5))

    GetElement(self.m_root,"txtMapEventOn1_WndTabooBoxOpen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtMapEventOn2_WndTabooBoxOpen",WZUILabelTTF):setScale(0.8)
    
    GetElement(self.m_root,"txtMapEventCommon1_WndTabooBoxOpen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtMapEventCommon2_WndTabooBoxOpen",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(400))

    local labBtnCommonCancle = GetElement(self.m_root,"labBtnCommonCancle_WndTabooBoxOpen",WZUILabelTTF)
    labBtnCommonCancle:setScale(0.8)
    labBtnCommonCancle:setDimensions(GlobalMethod:CCSize(160))
end

function WndTabooBoxOpen:_adaptLanguage_es(  )
    local txtBtnOpenStart1 = GetElement(self.m_root,"txtBtnOpenStart1_WndTabooBoxOpen",WZUILabelTTF)
    txtBtnOpenStart1:setScale(0.8)
    txtBtnOpenStart1:setDimensions(GlobalMethod:CCSize(120))
    local txtBtnOpenStart2 = GetElement(self.m_root,"txtBtnOpenStart2_WndTabooBoxOpen",WZUILabelTTF)
    txtBtnOpenStart2:setScale(0.8)
    txtBtnOpenStart2:setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtWorldBossOpenTimeDown_WndTabooBoxOpen",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtBox_WndTabooBoxOpen",WZUILabelTTF):setScale(0.6)

    GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(400))

    GetElement(self.m_root,"labCommonCost_WndTabooBoxOpen",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"labCost_WndTabooBoxOpen",WZUILabelTTF):setScale(0.9)

    local labBtnCommonCancle = GetElement(self.m_root,"labBtnCommonCancle_WndTabooBoxOpen",WZUILabelTTF)
    labBtnCommonCancle:setScale(0.7)
    labBtnCommonCancle:setDimensions(GlobalMethod:CCSize(180))
end

function WndTabooBoxOpen:_adaptLanguage_tr(  )
    local txtBtnOpenStart1 = GetElement(self.m_root,"txtBtnOpenStart1_WndTabooBoxOpen",WZUILabelTTF)
    txtBtnOpenStart1:setScale(0.8)
    txtBtnOpenStart1:setDimensions(GlobalMethod:CCSize(150,0))
    local txtBtnOpenStart2 = GetElement(self.m_root,"txtBtnOpenStart2_WndTabooBoxOpen",WZUILabelTTF)
    txtBtnOpenStart2:setScale(0.8)
    txtBtnOpenStart2:setDimensions(GlobalMethod:CCSize(150,0))

    GetElement(self.m_root,"txtWorldBossOpenTimeDown_WndTabooBoxOpen",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(120))

    GetElement(self.m_root,"txtBox_WndTabooBoxOpen",WZUILabelTTF):setScale(0.6)

    GetElement(self.m_root,"labCommonDes_WndTabooBoxOpen",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(400))

    GetElement(self.m_root,"labCommonCost_WndTabooBoxOpen",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"labCost_WndTabooBoxOpen",WZUILabelTTF):setScale(0.9)

    local labBtnCommonCancle = GetElement(self.m_root,"labBtnCommonCancle_WndTabooBoxOpen",WZUILabelTTF)
    labBtnCommonCancle:setScale(0.7)
    labBtnCommonCancle:setDimensions(GlobalMethod:CCSize(180))
end
---------------------------------------语言始配End------------------------------------------