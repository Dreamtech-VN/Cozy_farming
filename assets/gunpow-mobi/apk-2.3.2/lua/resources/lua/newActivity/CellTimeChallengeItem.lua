--CellTimeChallengeItem.lua
--@brief	CellTimeChallengeItem的UI模块
--@date		2017/08/24
--@author	Tianxiang_Xu
--@note		开服活动-限时挑战-子节点Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTimeChallengeItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTimeChallengeItem:onExit(element)
	self:_unInit()
end

--@brief    点击领取按钮回调
function CellTimeChallengeItem:onClickReceive(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end

    CellTimeChallengeItem.m_current_click = self
    CellTimeChallengePanel.m_current:onClickReceive(self.m_tData, self.m_nActivityId)
end

--@brief    加载
function CellTimeChallengeItem:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellTimeChallengeItem")
    self.m_root:addChild(celElement)

    self.m_bIsLoaded = true
    self:_update()
    AdaptLanguage(self)
end

--@brief    点击奖励物品回调
function CellTimeChallengeItem:onClickItem(luaTable, tag, tData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- body
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root, WndGameActivity.m_root, 1, tData, false, nil, false, nil, nil, false)
end

--@brief    获取rewardId
function CellTimeChallengeItem:getRewardId()
    -- body
    return self.m_tData.rewardId
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellTimeChallengeItem:_update()
    -- body
    local txtContent = GetElement(self.m_root, "txtContent_CellTimeChallengeItem", WZUILabelTTF)
    if txtContent then 
        txtContent:setText(self.m_tData.content)
    end
    --奖励
    local con1 = GetElement(self.m_root, "con1_CellTimeChallengeItem", WZUIContainer)
    if con1 then 
        con1:removeAllChildrenWithCleanup(true)
        local element, tNewObj = CellGoodItem:createElement()
        if element and tNewObj then 
            tNewObj:setCellGoodLocalId(self.m_tData.id, self.m_tData.num, 4)
            tNewObj:setItemClickFun(self, self.onClickItem)
            tNewObj:clearItemQualityPic()
            element:setScale(0.90)
            con1:addChild(element)
        end
    end

    self:setRewardState()
end

--@brief    领取按钮的状态
function CellTimeChallengeItem:setRewardState(state)
    -- body
    if state ~= nil then 
        self.m_tData.state = state
    end
    --状态
    local btnReceive = GetElement(self.m_root, "btnReceive_CellTimeChallengeItem", WZUIButton)
    local imgHavedGet = GetElement(self.m_root, "imgHavedGet_CellTimeChallengeItem", WZUIImage)
    if self.m_tData.state == -1 then 
        btnReceive:setVisible(true)
        btnReceive:setTouchEnable(false)
    elseif self.m_tData.state == 0 then
        btnReceive:setVisible(true)
        btnReceive:setTouchEnable(true)
    else
        btnReceive:setVisible(false)
        imgHavedGet:setVisible(true)
    end
end


-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellTimeChallengeItem:_adaptLanguage_es(  )
    -- body
    local txtContent = GetElement(self.m_root, "txtContent_CellTimeChallengeItem", WZUILabelTTF)
    if txtContent then 
        txtContent:setScale(0.7)
    end
end

-------------------------------------语言适配End----------------------------------------