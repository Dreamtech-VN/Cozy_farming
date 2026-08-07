--CellFriendInvite.lua
--@brief	CellFriendInvite的UI模块
--@date		2016/06/07
--@author	Tianxiang_Xu
--@note		邀请码好友子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFriendInvite:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFriendInvite:onExit(element)
	self:_unInit()
end

--@brief    点击查看玩家信息回调
function CellFriendInvite:onCheckInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellFriendInvite:onCheckInfo", self.m_tFriend.id)
    local playerInfo = CacheCenter:getPlayerInfo()
    if GlobalMethod:crossServiceOpen() == 0 and self.m_tFriend.serverId ~= playerInfo.serverId then
        MsgBoxManager:showTipBox(LocalStrings.CROSS_SERVICE_TIP2)
        return
    end
    WndCheckOther:show(self.m_tFriend.id)
end

--@brief    加载cell的数据信息
function CellFriendInvite:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellFriendInvite")
    self.m_root:addChild(cellElement)

    if self.m_tFriend then
        self:_update()
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新cell的信息
function CellFriendInvite:_update()
    -- body
    self:_showPhone()
    self:_showName()
    self:_showLevel()
    self:_showServer()
    
    AdaptLanguage(self)
end

--@brief    显示头像
function CellFriendInvite:_showPhone()
    --设置默认显示
    local conHead = WZUIContainer:luaTo(self.m_root:getChildElement("conHead_CellFriendInvite"))
    local m_bIsOffline = false   
    if self.m_tFriend.isOnline == 0 or self.m_tFriend.isOnline == false then
        m_bIsOffline = true  
    end
    if m_bIsOffline then 
        WZLog("玩家不在线")
    else 
        WZLog("玩家在线")
    end 
    local cellElement =  CellHead:show(conHead,self.m_tFriend.headItemId,self.m_tFriend.faceItemId,self.m_tFriend.sex,m_bIsOffline, nil, self.m_tFriend.vipLevel, self.m_tFriend.headColor)
    cellElement:setScale(1.13)
end

--@brief    显示名称
function CellFriendInvite:_showName()
    local txtName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtName_CellFriendInvite"))
    txtName:setText(self.m_tFriend.name or "")
end

--@brief    显示等级
function CellFriendInvite:_showLevel()
    local txtLevel= WZUILabelTTF:luaTo(self.m_root:getChildElement("txtLevel_CellFriendInvite"))
    txtLevel:setText(LocalStrings.MOUNT_LEVEL1 .. self.m_tFriend.level)
end

--@brief    显示服务器
function CellFriendInvite:_showServer()
    -- body
    local txtServerName = GetElement(self.m_root, "txtServerName_CellFriendInvite", WZUIFreeTextBox)
    local sFormat = [[<T C="79,60,48" S="22" P="1">%s </T><T C="105,65,46" S="22" P="1">%s</T>]]
    local serverName = CacheCenter:getServerNameByServerId(self.m_tFriend.serverId)
    if serverName then
        local txtContent = string.format(sFormat, LocalStrings.SETTING_SERVE_NAME, serverName)
        txtServerName:setShowText(txtContent)
    end
end

-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配Begin----------------------------------------
function CellFriendInvite:_adaptLanguage_hk(  )
    local txtName = GetElement(self.m_root, "txtName_CellFriendInvite", WZUILabelTTF)
    txtName:setScale(0.8)
    local txtLevel = GetElement(self.m_root, "txtLevel_CellFriendInvite", WZUILabelTTF)
    txtLevel:setScale(0.8)
    local txtServerName = GetElement(self.m_root, "txtServerName_CellFriendInvite", WZUIFreeTextBox)
    txtServerName:setScale(0.8)
    txtServerName:setMaxWidth(250)
end
-------------------------------------语言适配End----------------------------------------
