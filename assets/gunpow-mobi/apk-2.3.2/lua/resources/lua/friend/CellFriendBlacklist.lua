--CellFriendBlacklist.lua
--@brief	CellFriendBlacklist的UI模块
--@date		2018/04/19
--@author	Tianxiang_Xu
--@note		黑名单


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFriendBlacklist:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFriendBlacklist:onExit(element)
	self:_unInit()
end

--点击好友头像
function CellFriendBlacklist:event_ClickHead( element )
	WZLog("CellFriendBlacklist:event_ClickHead")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self.m_tBackFun[2](self.m_tBackFun[1] ,self,nil,self.m_tFriend)

	WndCheckOther:show(self.m_tFriend.id)
end

--@brief 	点击删除黑名单按钮回调
function CellFriendBlacklist:onDelBlackFriend(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	ProtocolProcessorWndFriends:send_FRIENT_BlackListOperate(1, self.m_tFriend.id)
end

--@brief    
function CellFriendBlacklist:onLoadData(element)
    -- body
    local celElement = WZUISystem:getInstance():createElement("CellFriendBlacklist")
    self.m_root:addChild(celElement)
    --更新函数
    self:_update()
end

--@brief 	获取id
function CellFriendBlacklist:getFriendId()
	-- body
	return self.m_tFriend.id
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新函数
function CellFriendBlacklist:_update()
	if self.m_root == nil or self.m_tFriend == nil then
		return
	end

	self:_showSex()--显示性别或顺序id
	self:_showOnline(self.m_nType)--显示在线或上一次登录时间
	self:_showName()--显示名称
	self:_showLevel()--显示等级
end

--@brief	显示性别
function CellFriendBlacklist:_showSex()
	self:_showPhone()--显示头像
end

--@brief	显示头像
function CellFriendBlacklist:_showPhone()
	--设置默认显示
	local conHead = WZUIContainer:luaTo(self.m_root:getChildElement("conHead_CellFriendBlacklist"))
    WZLog("sex===",self.m_tFriend.sex)
	local m_bIsOffline = false   
	if self.m_tFriend.isOnline == 0 or self.m_tFriend.isOnline == false then
		m_bIsOffline = true  
	end
	if m_bIsOffline then 
		WZLog("玩家不在线")
	else 
		WZLog("玩家在线")
	end 
	local cellElement =  CellHead:show(conHead,self.m_tFriend.headItemId,self.m_tFriend.faceItemId,self.m_tFriend.sex,m_bIsOffline, nil, self.m_tFriend.vipLevel, self.m_tFriend.headColor, nil, nil, nil, nil, self.m_tFriend.headEffectId)
	cellElement:setScale(1.13)
end

--@brief	显示名称
function CellFriendBlacklist:_showName()
	local txtName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtName_CellFriendBlacklist"))
	local imgKuafu = GetElement(self.m_root, "imgKuafu_CellFriendBlacklist", WZUIImage)

	if self.m_tFriend.serverId ~= CacheCenter:getPlayerInfo().serverId then
		imgKuafu:setVisible(true)
		txtName:setRelativePosition(GlobalMethod:ccp(0.15, 0.63))
	end
	txtName:setText(self.m_tFriend.name or "")
end

--@brief	显示等级
function CellFriendBlacklist:_showLevel()
	local txtLevel = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtLevel_CellFriendBlacklist"))
	local txtLevelNum = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtLevelNum_CellFriendBlacklist"))
	txtLevel:setText(LocalStrings.LEVEL .. "：")
	txtLevelNum:setText(self.m_tFriend.level)
end

--@brief	显示在线
function CellFriendBlacklist:_showOnline(nType)
	local txtOnlineState = GetElement(self.m_root, "txtOnlineState_CellFriendBlacklist", WZUILabelTTF)
	
	if self.m_tFriend.isOnline == 0 or self.m_tFriend.isOnline == false then
        txtOnlineState:setText(LocalStrings.ISOFFLINE)
	else
        txtOnlineState:setText(LocalStrings.ISONLINE)
	end
end

-------------------------------------私有方法模块End----------------------------------------
