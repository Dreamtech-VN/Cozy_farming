--CellCardItem.lua
--@brief	CellCardItem的UI模块
--@date		2016/07/26
--@author	Tianxiang_Xu
--@note		卡牌系统-卡片


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCardItem:onEnter(element)
	self.m_root = element
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCardItem:onExit(element)
	self:_unInit()
end

--@brief    加载
function CellCardItem:onLoadData(element)
    if self.m_bCreateOther ~= true then
        return
    end

    local celElement = WZUISystem:getInstance():createElement("CellCardItem")
    self.m_root:addChild(celElement)

    self:_update()
end

--@brief    点击卡牌回调
function CellCardItem:onClickCard(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self, self.m_tData)
    end
end

--@brief    设置数量条是否可见
function CellCardItem:setPrgVisible(bVisible)
    -- body
    if self.m_root == nil then return end

    GetElement(self.m_root, "conExp_CellCardItem", WZUIContainer):setVisible(bVisible)
end

--@brief    设置右上角状态特效是否可见
function CellCardItem:setSpineVisible(bVisible)
    -- body
    local cardCoinNum = CacheCenter:getMoneyList().card
    if self.m_tData.useType == 1 then
        if self.m_tData.cost[1][2] <= cardCoinNum and self.m_tData.cost[2][2] <= self.m_tData.curNum then
            return 
        end
    end
    if self.m_root == nil then return end

    GetElement(self.m_root, "spineRightCorner_CellCardItem", WZUISpine):setVisible(bVisible)
end

--@brief    设置右上角状态特效是否可见
function CellCardItem:setHighLightVisible(bVisible)
    -- body
    if self.m_root == nil then return end

    GetElement(self.m_root, "conHightLight_CellCardItem", WZUIContainer):setVisible(bVisible)
end

--@brief    获取节点数据
function CellCardItem:getData()
    -- body
    return self.m_tData
end

--@brief    播放升级动画
--@param    name:动画的名字
function CellCardItem:playUpgradeSpine(name)
    -- body
    WZLog("CellCardItem:playUpgradeSpine")
    local spineRightCorner = GetElement(self.m_root, "spineRightCorner_CellCardItem", WZUISpine)
    spineRightCorner:setVisible(true)
--    spineRightCorner:setAnimationName(name)
    spineRightCorner:play(name,false)
end

function CellCardItem:spineUpgradeEnd(element,action,val)
    local spineRightCorner = GetElement(self.m_root, "spineRightCorner_CellCardItem", WZUISpine)
    local actionName = spineRightCorner:getAnimationName()
    if actionName == "lvlup" then
        WZLog("spineUpgradeEnd",element,action,val)
        if "complete" == action then
            local cardCoinNum = CacheCenter:getMoneyList().card
            if self.m_tData.cost[1][2] <= cardCoinNum and self.m_tData.cost[2][2] <= self.m_tData.curNum then
                spineRightCorner:play("up",true)
            else
                spineRightCorner:play("up",true)
                spineRightCorner:setVisible(false)
            end
        end
    end
end

--@brief    更新商店中显示的卡牌的数量
function CellCardItem:updateNum(tData)
    -- body
    if tData == nil then return end 

    local txtExp = GetElement(self.m_root, "txtExp_CellCardItem", WZUILabelTTF)
    local prgExp = GetElement(self.m_root, "prgExp_CellCardItem", WZUIProgress)
    if tData.level >= WndCard:_getMaxLevel(tData.item_id) then
        txtExp:setText(tData.curNum .. "/" .. "Max")
        prgExp:setPercentage(100)
    else
        txtExp:setText(tData.curNum .. "/" .. tData.upgradeNum)
        prgExp:setPercentage(math.floor(100 * tData.curNum / tData.upgradeNum))
    end
end

--@brief    升级后更新卡牌的信息显示
function CellCardItem:updateAfterUpgrade(tData)
    -- body
    self.m_tData = tData 
    if tData == nil then return end 

    --等级
    local txtLevel = GetElement(self.m_root, "txtLevel_CellCardItem", WZUILabelTTF)
    if self.m_tData.level == nil or self.m_tData.level == 0 then
        txtLevel:setText("?")
    else
        txtLevel:setText(self.m_tData.level)
    end

    --特效
    local spineRightCorner = GetElement(self.m_root, "spineRightCorner_CellCardItem", WZUISpine)
    local cardCoinNum = CacheCenter:getMoneyList().card
    if self.m_tData.cost[1][2] <= cardCoinNum and self.m_tData.cost[2][2] <= self.m_tData.curNum then
        if self.m_tData.level >= WndCard:_getMaxLevel(self.m_tData.item_id) then
            spineRightCorner:setVisible(false)
        else
            spineRightCorner:setVisible(true)
        end
    else
        spineRightCorner:setVisible(false)
    end
    --数量
    local txtExp = GetElement(self.m_root, "txtExp_CellCardItem", WZUILabelTTF)
    local prgExp = GetElement(self.m_root, "prgExp_CellCardItem", WZUIProgress)
    if tData.level >= WndCard:_getMaxLevel(tData.item_id) then
        txtExp:setText(tData.curNum .. "/" .. "Max")
        prgExp:setPercentage(100)
    else
        txtExp:setText(tData.curNum .. "/" .. tData.upgradeNum)
        prgExp:setPercentage(math.floor(100 * tData.curNum / tData.upgradeNum))
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新cell数据
function CellCardItem:_update()
    if self.m_tData == nil then
        GetElement(self.m_root, "imgCardIcon_CellCardItem", WZUIImage):setFile("")
        GetElement(self.m_root, "imgQualityRect_CellCardItem", WZUI9Image):setFile("ui/common/common_icon_pflv.png")
        GetElement(self.m_root, "conExp_CellCardItem", WZUIContainer):setVisible(false)
        GetElement(self.m_root, "txtLevel_CellCardItem", WZUILabelTTF):setText(1)
        GetElement(self.m_root, "spineRightCorner_CellCardItem", WZUISpine):setVisible(false)
        return
    end
    local qualityRect = {"ui/common/common_icon_pflv.png", "ui/common/common_icon_pflan.png", "ui/common/common_icon_pfzi.png", "ui/common/common_icon_pfcheng.png"}
    --卡牌图标
    local imgCardIcon = GetElement(self.m_root, "imgCardIcon_CellCardItem", WZUIImage)
    imgCardIcon:setFile(self.m_tData.basicInfo.icon)
    --品质框
    local imgQualityRect = GetElement(self.m_root, "imgQualityRect_CellCardItem", WZUI9Image)
    imgQualityRect:setFile(qualityRect[self.m_tData.basicInfo.quality])
    --等级
    local txtLevel = GetElement(self.m_root, "txtLevel_CellCardItem", WZUILabelTTF)
    if self.m_tData.level == nil or self.m_tData.level == 0 then
        txtLevel:setText("?")
    else
        txtLevel:setText(self.m_tData.level)
    end
    --位置
    -- if self.m_relativePosition then
    --     GetElement(self.m_root,"conCard_CellCardItem",WZUIContainer):setRelativePosition(self.m_relativePosition)
    -- end
    -- GetElement(self.m_root,"conCard_CellCardItem",WZUIContainer):setRelativePosition(self.m_relativePosition)
    --经验条
    local conExp = GetElement(self.m_root, "conExp_CellCardItem", WZUIContainer)
    local spineRightCorner = GetElement(self.m_root, "spineRightCorner_CellCardItem", WZUISpine)
    if self.m_tData.state == nil or self.m_tData.state == 0 then     --未激活
        conExp:setVisible(false)
        imgCardIcon:setGrayRender(true)
        spineRightCorner:setVisible(false)
    else
        local cardCoinNum = CacheCenter:getMoneyList().card
        if self.m_tData.useType == 2 then
            spineRightCorner:setVisible(false)
        elseif self.m_tData.useType == 8 then  --卡套界面
            spineRightCorner:setVisible(false)
            conExp:setVisible(false)
            return 
        else
            if self.m_tData.cost[1][2] <= cardCoinNum and self.m_tData.cost[2][2] <= self.m_tData.curNum then
                if self.m_tData.level >= WndCard:_getMaxLevel(self.m_tData.item_id) then
                    spineRightCorner:setVisible(false)
                else
                    spineRightCorner:setVisible(true)
                end
            else
                if self.m_tData.bIsNew == true then
                    spineRightCorner:setVisible(true)
                    spineRightCorner:setAnimationName("new")
                else
                    spineRightCorner:setVisible(false)
                end
            end
        end
        conExp:setVisible(true)
        local txtExp = GetElement(self.m_root, "txtExp_CellCardItem", WZUILabelTTF)
        local prgExp = GetElement(self.m_root, "prgExp_CellCardItem", WZUIProgress)
        if self.m_tData.level >= WndCard:_getMaxLevel(self.m_tData.item_id) then
            txtExp:setText(self.m_tData.curNum .. "/" .. "Max")
            prgExp:setPercentage(100)
        else
            txtExp:setText(self.m_tData.curNum .. "/" .. self.m_tData.upgradeNum)
            prgExp:setPercentage(math.floor(100 * self.m_tData.curNum / self.m_tData.upgradeNum))
        end
    end
end



-------------------------------------私有方法模块End----------------------------------------
