--CellNewExchangeItem.lua
--@brief	CellNewExchangeItem的UI模块
--@date		2017/09/26
--@author	Tianxiang_Xu
--@note		新的兑换活动的兑换节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellNewExchangeItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellNewExchangeItem:onExit(element)
	self:_unInit()
end

--@brief    加载cell信息数据
function CellNewExchangeItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellNewExchangeItem")
    self.m_root:addChild(celElement)

    self:_update()
    AdaptLanguage(self)
end

--@brief    点击Item时回调tips
function CellNewExchangeItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellExchangePanel.m_current.m_root,1,tData,false)
end

--@brief    点击兑换回调
function CellNewExchangeItem:onClickExchange(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    local bIsHaved = false
    local dataId 
    local hasMount = false 
    local checkGift 
    local text
    for i = 1, #self.m_tRewardsData do
        local itemId = self.m_tRewardsData[i].id
        --是否已有无限期时装
        bIsHaved = gCheckHaveOrNot(itemId)
        if bIsHaved then 
            dataId = itemId
            break 
        end
        --是否已有坐骑
        hasMount = checkOwnMount(itemId)
        if hasMount then 
            break 
        end
        --礼包内是否有时装或坐骑
        checkGift, text = checkGiftOwn(itemId)
        if checkGift then 
            break 
        end
    end

    if bIsHaved then
        local tBasicInfo = GDatatab_item["id_" .. dataId]

        MsgBoxManager:showConfirmBox(string.format(LocalStrings.ACTIVITY_HAVED_ATT, tBasicInfo.name), self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    elseif hasMount then
        MsgBoxManager:showConfirmBox(LocalStrings.OWNMOUNT, self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    elseif checkGift then
        MsgBoxManager:showConfirmBox(string.format(LocalStrings.OWN1, text), self, self.event_SureBuyAgain, MSGBOXLEVEL_NORMAL, nil)
    else
        self:event_SureBuyAgain()
    end
end

function CellNewExchangeItem:event_SureBuyAgain()
    local sAtt = self:_checkGoodsEnough()
    if sAtt then
        MsgBoxManager:showTipBox(sAtt .. " " .. LocalStrings.NOT_ENABLE)
        return
    end

    if self.m_nLeftTimes <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.ATH_CNT_NOT_ENOUGH)
        return 
    end

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_rewardId)
    end
end

--@brief    获取奖励Id
function CellNewExchangeItem:getRewardId()
    -- body
    return self.m_rewardId
end

--@brief    兑换成功后，更新数据
function CellNewExchangeItem:refreshData(bRefreshTimes)
    -- body
    if bRefreshTimes then
        --剩余次数
        self.m_nLeftTimes = self.m_nLeftTimes - 1
        local ftxtCondition = GetElement(self.m_root, "ftxtCondition_CellNewExchangeItem", WZUIFreeTextBox)
        if ftxtCondition then
            local costId = self.m_tConsumeData[1].id
            local costIcon = GDatatab_item["id_" .. costId].icon
            ftxtCondition:setShowText(string.format(LocalStrings.NEWEXCHANGE_TEXT1, costIcon, self.m_tConsumeData[1].num, self.m_nLeftTimes))
        end
        --按钮的状态
        self:setBtnState()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    显示cell信息
function CellNewExchangeItem:_update()
    -- body
    WZLog("CellNewExchangeItem:_update")
    --剩余次数
    local ftxtCondition = GetElement(self.m_root, "ftxtCondition_CellNewExchangeItem", WZUIFreeTextBox)
    if ftxtCondition then
        local costId = self.m_tConsumeData[1].id
        local costIcon = GDatatab_item["id_" .. costId].icon

        ftxtCondition:setShowText(string.format(LocalStrings.NEWEXCHANGE_TEXT1, costIcon, self.m_tConsumeData[1].num, self.m_nLeftTimes))
    end
    --兑换得到的物品
    for i = 1, #self.m_tRewardsData do
        local conItem = GetElement(self.m_root, "ConItem" .. i .. "_CellNewExchangeItem", WZUIContainer)
        if conItem then
            local element, tNewObj = CellGoodItem:createElement()
            local key = "id_" .. self.m_tRewardsData[i].id
            if element and tNewObj then
                local itemInfo = {id = self.m_tRewardsData[i].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tRewardsData[i].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                tNewObj:setCellGoodItem(itemInfo,17)
     
                tNewObj:setItemClickFun(self,self.onOthersClick)
                conItem:addChild(element)
            end
        end
    end
    --按钮的状态
    self:setBtnState()
end

--@brief    检测消耗道具是否不足
function CellNewExchangeItem:_checkGoodsEnough()
    -- body
    local sAtt = nil 
    if self.m_tConsumeData then
        for i = 1, #self.m_tConsumeData do
            local nLastNum = CacheCenter:getPlayerItemCountById(self.m_tConsumeData[i].id)
            local key = "id_" .. self.m_tConsumeData[i].id
            if GDatatab_item[key].main_type == 5 then 
                if nLastNum ~= self.m_tConsumeData[i].num then
                    sAtt = GDatatab_item[key].name
                    break 
                end
            else
                if nLastNum < self.m_tConsumeData[i].num then
                    sAtt = GDatatab_item[key].name
                    break 
                end
            end
        end
    end

    return sAtt
end

--@brief    设置按钮的触摸
function CellNewExchangeItem:setBtnState()
    -- body
    local btn_GetReward = GetElement(self.m_root, "btn_GetReward_CellNewExchangeItem", WZUIButton)
    local txtExchange = GetElement(self.m_root, "txtExchange_CellNewExchangeItem", WZUILabelTTF)
    if self.m_nLeftTimes <= 0 then 
        btn_GetReward:setTouchEnable(false)
        txtExchange:setColor(GlobalMethod:ccc3(255,255,255))
        txtExchange:setStrokeColor(GlobalMethod:ccc3(79,60,48))
    else
        btn_GetReward:setTouchEnable(true)
        txtExchange:setColor(GlobalMethod:ccc3(255,236,193))
        txtExchange:setStrokeColor(GlobalMethod:ccc3(128,54,13))
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellNewExchangeItem:_adaptLanguage_es(  )
    local ftxtCondition = GetElement(self.m_root, "ftxtCondition_CellNewExchangeItem", WZUIFreeTextBox)
    ftxtCondition:setScale(0.75)
    ftxtCondition:setMaxWidth(1000)
end

function CellNewExchangeItem:_adaptLanguage_en(  )
    local ftxtCondition = GetElement(self.m_root, "ftxtCondition_CellNewExchangeItem", WZUIFreeTextBox)
    ftxtCondition:setScale(0.75)
    ftxtCondition:setMaxWidth(1000)
end

function CellNewExchangeItem:_adaptLanguage_pt(  )
    local ftxtCondition = GetElement(self.m_root, "ftxtCondition_CellNewExchangeItem", WZUIFreeTextBox)
    ftxtCondition:setScale(0.75)
    ftxtCondition:setMaxWidth(1000)
end

function CellNewExchangeItem:_adaptLanguage_tr(  )
    local ftxtCondition = GetElement(self.m_root, "ftxtCondition_CellNewExchangeItem", WZUIFreeTextBox)
    ftxtCondition:setScale(0.75)
    ftxtCondition:setMaxWidth(1000)
end
---------------------------------------语言适配End------------------------------------------
