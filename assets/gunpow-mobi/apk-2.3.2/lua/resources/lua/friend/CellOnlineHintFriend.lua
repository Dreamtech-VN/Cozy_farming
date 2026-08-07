--CellOnlineHintFriend.lua
--@brief	CellOnlineHintFriend的UI模块
--@date		2016/04/29
--@author	Tianxiang_Xu
--@note		好友上线提示子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellOnlineHintFriend:onEnter(element)
	self.m_root = element
    --AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellOnlineHintFriend:onExit(element)
	self:_unInit()
end

--@brief    点击复选框回调
function CellOnlineHintFriend:onChoose(element)
    -- body
    WZLog("CellOnlineHintFriend:onChoose", self.m_tFriend.isOnlineRemind)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    if self.m_nType == 1 then
        if self.m_tFriend.isOnlineRemind == nil or self.m_tFriend.isOnlineRemind == false or self.m_tFriend.isOnlineRemind == 0 then
            self.m_tFriend.isOnlineRemind = true
        else
            self.m_tFriend.isOnlineRemind = false
        end
    elseif self.m_nType == 2 then
        if self.m_tFriend.isAddForBest == nil or self.m_tFriend.isAddForBest == false or self.m_tFriend.isAddForBest == 0 then
            local bCanChoose = WndOnlineHintFriend:bestFriendAtt()
            if bCanChoose then
                self.m_tFriend.isAddForBest = true
            else
                return 
            end
        else
            self.m_tFriend.isAddForBest = false
        end
    elseif self.m_nType == 3 then
        if self.m_tFriend.isAddForSendCard == nil or self.m_tFriend.isAddForSendCard == false or self.m_tFriend.isAddForSendCard == 0 then
            local bCanChoose = WndOnlineHintFriend:bestFriendAtt()
            if bCanChoose then
                self.m_tFriend.isAddForSendCard = true
            else
                return 
            end
        else
            self.m_tFriend.isAddForSendCard = false
        end
    elseif self.m_nType == 4 then
        if self.m_tFriend.isTop == nil or self.m_tFriend.isTop == false or self.m_tFriend.isTop == 0 then
            self.m_tFriend.isTop = true
        else
            self.m_tFriend.isTop = false
        end
    end

    self:_updateGouStatus()

    if self.m_tCallBack then
        self.m_tCallBack[2](self.m_tCallBack[1], self.m_tFriend)
    end
end

--@brief    查看玩家信息
function CellOnlineHintFriend:onCheckInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tCallBack then
        self.m_tCallBack[3](self.m_tCallBack[1], self.m_tFriend)
    end

    WndCheckOther:show(self.m_tFriend.id)
end

--@brief    加载节点信息
function CellOnlineHintFriend:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellOnlineHintFriend")
    self.m_root:addChild(cellElement)

    self:_update()
    AdaptLanguage(self)
end

--@brief    获取好友ID
function CellOnlineHintFriend:getFriendId()
    -- body
    return self.m_tFriend.id
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新信息
function CellOnlineHintFriend:_update()
    -- body
    self:_showName()
    self:_showHeadIcon()
    self:_updateGouStatus()
end

--@brief    显示名称
function CellOnlineHintFriend:_showName()
    local txtName = WZUIFreeTextBox:luaTo(self.m_root:getChildElement("txtName_CellOnlineHintFriend"))
    local msg = string.format(LocalStrings.LevelAndNameFormat,self.m_tFriend.level,self.m_tFriend.name)
    if self.m_nType == 3 and self.m_tFriend.serverId ~= CacheCenter:getPlayerInfo().serverId then 
        local nameFormat = [[<T S="22" C="229,105,22" P="0">Lv%d</T><BL>10</BL><I Z="1" P="0">ui/common/common_icon_kuafu.png</I><T S="22" C="127,70,26" P="0">%s</T>]]
        msg = string.format(nameFormat,self.m_tFriend.level,self.m_tFriend.name)
    end
    txtName:setShowText(msg)

    local txtFriendsLiness = GetElement(self.m_root, "txtFriendsLiness_CellOnlineHintFriend", WZUIFreeTextBox)
    local sValueFormat = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,255,255" S="22" P="1">%d</T>]]
    if self.m_tFriend.friendliness then
        local sFriendsLiness = string.format(sValueFormat, LocalStrings.FRIENDLINESS, self.m_tFriend.friendliness)
        txtFriendsLiness:setShowText(sFriendsLiness)
    end
end

--@brief    显示玩家头像
function CellOnlineHintFriend:_showHeadIcon()
    WZLog("CellOnlineHintFriend:_showHeadIcon()")
    --设置默认显示
    local conHead = GetElement(self.m_root,"conHead_CellOnlineHintFriend",WZUIContainer)
    local bIsOnline = false 
    if self.m_nType == 1 then
        bIsOnline = false 
    elseif self.m_nType == 2 then
        if self.m_tFriend.isOnline == false or self.m_tFriend.isOnline == 0 then
            bIsOnline = true
        end
    end
    local cellElement =  CellHead:show(conHead,self.m_tFriend.headItemId,self.m_tFriend.faceItemId,self.m_tFriend.sex, bIsOnline, nil, self.m_tFriend.vipLevel, self.m_tFriend.headColor, nil, nil, nil, nil, self.m_tFriend.headEffectId)
    cellElement:setScale(1.15)
end

--@brief    显示或隐藏勾
function CellOnlineHintFriend:_updateGouStatus()
    -- body
    local imgSel = GetElement(self.m_root, "imgSel_CellOnlineHintFriend", WZUIImage)
    imgSel:setFile("ui/common/common_gx.png")
    if self.m_nType == 1 then
        if self.m_tFriend.isOnlineRemind == nil or self.m_tFriend.isOnlineRemind == false or self.m_tFriend.isOnlineRemind == 0 then
            imgSel:setVisible(false)
        else
            imgSel:setVisible(true)
        end
    elseif self.m_nType == 2 then
        if self.m_tFriend.isAddForBest == nil or self.m_tFriend.isAddForBest == false or self.m_tFriend.isAddForBest == 0 then
            imgSel:setVisible(false)
        else
            imgSel:setVisible(true)
        end
    elseif self.m_nType == 3 then
        if self.m_tFriend.isAddForSendCard == nil or self.m_tFriend.isAddForSendCard == false or self.m_tFriend.isAddForSendCard == 0 then
            imgSel:setVisible(false)
        else
            imgSel:setVisible(true)
        end
    elseif self.m_nType == 4 then
        if self.m_tFriend.isTop == nil or self.m_tFriend.isTop == false or self.m_tFriend.isTop == 0 then
            imgSel:setVisible(false)
        else
            imgSel:setVisible(true)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------
------------------------------------语言适配Begin-------------------------------------------
function CellOnlineHintFriend:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtFriendsLiness_CellOnlineHintFriend",WZUIFreeTextBox):setScale(0.8)
end

function CellOnlineHintFriend:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtFriendsLiness_CellOnlineHintFriend",WZUIFreeTextBox):setScale(0.8)
end

function CellOnlineHintFriend:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtFriendsLiness_CellOnlineHintFriend",WZUIFreeTextBox):setScale(0.8)
end
--------------------------------------语言适配End-----------------------------------------