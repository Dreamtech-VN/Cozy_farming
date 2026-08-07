--CellDynamic.lua
--@brief	CellFriends的UI模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDynamic:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDynamic:onExit(element)
	self:_unInit()
end

--@brief	背景按钮函数
--@param	element:表绑定的UI节点引用
function CellDynamic:onBackClick(element)
	element = WZUIButton:luaTo(element)
end

--@brief	赠送回调
function CellDynamic:onGitfClick(element)
	WZLog("回赠活力回调:CellDynamic:onGitfClick:")
	CellDynamic.m_current_click = self
	local tagT = self.m_root:getTag()
	CellDynamic.m_current_click.tagT = tagT 
	local tag = tonumber(WZUIButton:luaTo(element):getTag())
	CellDynamic.m_current_click.tag = tag
	
	if self.m_tBackFun and self.m_tBackFun[1] and self.m_tBackFun[3] then
		self.m_tBackFun[3](self.m_tBackFun[1],self,tagT,self.m_tFriend, self.m_root)
	end
end

--@brief	领取回调
function CellDynamic:onRecvClick(element)
	CellDynamic.m_current_click = self
	local tagT = self.m_root:getTag()
	CellDynamic.m_current_click.tagT = tagT 
	local tag = tonumber(WZUIButton:luaTo(element):getTag())
	CellDynamic.m_current_click.tag = tag
	WZLog("领取回调:CellDynamic:onRecvClick:", tag)
	if tag == 1 then 
		if self.m_tBackFun and self.m_tBackFun[1] and self.m_tBackFun[2] then
			self.m_tBackFun[2](self.m_tBackFun[1], self, tagT, self.m_tFriend)
		end
	end	
end

--@brief 	好友申请通过回调
function CellDynamic:onSure(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	CellDynamic.m_current_click = self
	local tagT = self.m_root:getTag()
	CellDynamic.m_current_click.tagT = tagT 
	local tag = tonumber(WZUIButton:luaTo(element):getTag())
	CellDynamic.m_current_click.tag = tag

    if self.m_tBackFun and self.m_tBackFun[1] and self.m_tBackFun[4] then
		self.m_tBackFun[4](self.m_tBackFun[1],self.m_tFriend.id, self, self.m_tFriend.typeList)
	end
end

--@brief 	好友申请拒绝回调
function CellDynamic:onRefuse(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	CellDynamic.m_current_click = self
	local tagT = self.m_root:getTag()
	CellDynamic.m_current_click.tagT = tagT 
	local tag = tonumber(WZUIButton:luaTo(element):getTag())
	CellDynamic.m_current_click.tag = tag
	
	if self.m_tBackFun and self.m_tBackFun[1] and self.m_tBackFun[5] then
		self.m_tBackFun[5](self.m_tBackFun[1],self.m_tFriend.id, self, self.m_tFriend.typeList)
	end
end

--@brief 	查看玩家信息
function CellDynamic:onClickHead( element )
	WZLog("CellDynamic:event_ClickHead")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tFriend.id)
end

function CellDynamic:getData()
	-- body
	return self.m_tFriend
end

--@brief 	加载数据
function CellDynamic:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellDynamic")
	self.m_root:addChild(celElement)
	--更新函数
	self:_update()
end

--@brief 	
function CellDynamic:getNodeTag()
	-- body
	return self.m_root:getTag()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief	显示头像
function CellDynamic:_showBK()
	--设置默认显示
    local imgBK = GetElement(self.m_root, "imgBK_CellDynamic", WZUI9Image)
    local bHaveRelation = CacheCenter:judgeWhetherHaveRelation(self.m_tFriend.id)
	if self.m_tFriend.typeList == 7 or self.m_tFriend.typeList == 8 or bHaveRelation or self.m_tFriend.typeList == 9 then
        imgBK:setFile("ui/common/common_scale9_di78.png")
    end
end

--点击好友头像
function CellDynamic:event_ClickHead( element )
	WZLog("CellDynamic:event_ClickHead")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tFriend.id)
end

--@brief	显示在线
function CellDynamic:_showOnline(m_node)
	local m_tFriendInfo
	for i,v in pairs(CacheCenter:getFriendList()) do
		if v.id == self.m_tFriend.id then 
			m_tFriendInfo = v
			self.level = v.level;
		end
	end
end

--@brief	更新函数
function CellDynamic:_update()
	if self.m_root == nil or self.m_tFriend == nil then
		return
	end
	WZLog("CellDynamic:_update():",self.m_root:getTag())
    self:_showBK()
	self:_showName()--显示名称
	self:_showTime(self.m_tFriend.status, self.m_tFriend.sendType, self.m_tFriend.typeList)--时间
	self:_showGiftButton(self.m_tFriend.status, self.m_tFriend.sendType, self.m_tFriend.typeList)
--	self:_showPhone()
--	self:_showVigor()--活力值
end

--@brief	显示名称
function CellDynamic:_showName()
	WZLog("CellDynamic:_showName()::",self.m_tFriend.name,self.m_tFriend.typeList)
	return self:_showTTF(self.m_tFriend.name, self.m_tFriend.typeList)
end

--@brief	活力值
function CellDynamic:_showVigor()
	
end

function CellDynamic:createTTF(desc,pt,anchor,font,Align,color,sclolor)
	desc = desc or ""
	font = font or 22
	color = color or GlobalMethod:ccc3(105,65,46)
	sclolor = sclolor or GlobalMethod:ccc3(61,25,4)
	Align = Align or kCCTextAlignmentLeft
	anchor = anchor or GlobalMethod:ccp(0,0.5)
	pt = pt or GlobalMethod:ccp(0,0.5)
	local txt = WZUILabelTTF:create()
	txt:setFontSize(font)
	txt:setColor(color)
	txt:setText(desc)
	txt:setBoldFont(false)
	--txt:setEnableStroke(true)
	--txt:setStrokeColor(sclolor)
	--txt:setStrokeSize(1)
	txt:setTouchEnable(false)
	txt:setAlignment(Align)
	txt:setAnchorPoint(anchor)
	txt:setRelativePosition(pt)
	return txt
end

--@brief	显示时间
function CellDynamic:_showTime(status, sendType, typeList)
	local txtOnlineState = GetElement(self.m_root, "txtOnlineState_CellDynamic", WZUILabelTTF)
	if status == 1 or sendType == 1 or typeList == 4 then
		local dateTime = self:_returnOfflineAtt(self.m_tFriend.time)
		
		txtOnlineState:setText(dateTime)
		txtOnlineState:setVisible(true)
	else
		txtOnlineState:setVisible(false)
	end
end

--@brief	显示按钮
--@param 	sendType:回赠按钮的状态
--@typeList  	1为被赠送活力;2为被赠送礼物;3为同阵营战斗;4为好友申请;5为赠送礼物;6为赠送活力;7密友申请；8解除密友；9双修申请
function CellDynamic:_showGiftButton(status, sendType, typeList)
	local btnGiveVigor = GetElement(self.m_root, "btnGiveVigor_CellDynamic", WZUIButton)
	local btnIsRecv = GetElement(self.m_root, "btnIsRecv_CellDynamic", WZUIButton)
	local btnAgree = GetElement(self.m_root, "btnAgree_CellDynamic", WZUIButton)
	local btnReject = GetElement(self.m_root, "btnReject_CellDynamic", WZUIButton)
	local txtOnlineState = GetElement(self.m_root, "txtOnlineState_CellDynamic", WZUILabelTTF)

    WZLog("status====",status, sendType, typeList)
    if txtOnlineState then
        if status == 1 or sendType == 1 or typeList == 4 then
        	txtOnlineState:setVisible(true)
    	else
    		txtOnlineState:setVisible(false)
    	end
    end
    if typeList == 1 then
    	if status == 1 then
    		btnIsRecv:setVisible(true)
    	else
    		btnIsRecv:setVisible(false)
    	end
    	if sendType == 1 then
			btnGiveVigor:setVisible(true)
		else
			btnGiveVigor:setVisible(false)
		end
	elseif typeList == 2 then
		
	elseif typeList == 3 then
		
	elseif typeList == 4 or typeList == 7 then
		if status == 1 then
			btnAgree:setVisible(true)
			btnReject:setVisible(true)
		else
			btnAgree:setVisible(false)
			btnReject:setVisible(false)
		end
	elseif typeList == 5 then
		
	elseif typeList == 6 then
		if status == 1 then
    		btnIsRecv:setVisible(true)
    	else
    		btnIsRecv:setVisible(false)
    	end
    	if sendType == 1 then
			btnGiveVigor:setVisible(true)
		else
			btnGiveVigor:setVisible(false)
		end
    elseif typeList == 8 then
    elseif typeList == 9 then 
    	if status == 1 then
			btnAgree:setVisible(true)
			btnReject:setVisible(true)
		else
			btnAgree:setVisible(false)
			btnReject:setVisible(false)
		end
	end

end

--@brief 	设置描述内容
--@type  	1为被赠送活力;2为被赠送礼物;3为同阵营战斗;4为好友申请;5为赠送礼物;6为赠送活力;7密友申请；8解除密友；9双修申请
function CellDynamic:_showTTF(desc,type)
	local txtDesName = GetElement(self.m_root, "txtToName_CellDynamic", WZUIFreeTextBox)
	local txtDesContent = GetElement(self.m_root, "txtAddDes_CellDynamic", WZUIFreeTextBox)
	
	local sName 
	local sContent 
	if type == 1 then
		sName = string.format(LocalStrings.TO_YOU, self.m_tFriend.name)
		sContent = string.format(LocalStrings.VIGOR_ADD_FRIENDLINESS, self.m_tFriend.vigor, self.m_tFriend.friendliness)
	elseif type == 2 then
		sName = string.format(LocalStrings.TO_YOU, self.m_tFriend.name)
		sContent = string.format(LocalStrings.GIFT_ADD_FRIENDLINESS, self.m_tFriend.friendliness)
	elseif type == 3 then
		sName = string.format(LocalStrings.WITH_YOU, self.m_tFriend.name)
		sContent = string.format(LocalStrings.FIGHT_TOGETHER_FRIENDLINESS, self.m_tFriend.friendliness)
	elseif type == 4 then
        sName = string.format(LocalStrings.TO_YOU, self.m_tFriend.name)
        if self.m_tFriend.serverId ~= nil and self.m_tFriend.serverId ~= CacheCenter:getPlayerInfo().serverId then
            local sMarkName = [[<I P="1">ui/common/common_icon_kuafu.png</I>]]

            sName = sMarkName .. sName
        end
		sContent = LocalStrings.FRIEND_APPLY
	elseif type == 5 then
		sName = string.format(LocalStrings.YOU_TO, self.m_tFriend.name)
		sContent = string.format(LocalStrings.GIFT_ADD_FRIENDLINESS, self.m_tFriend.friendliness)
	elseif type == 6 then
		sName = string.format(LocalStrings.YOU_TO, self.m_tFriend.name)
		sContent = string.format(LocalStrings.VIGOR_ADD_FRIENDLINESS, self.m_tFriend.vigor, self.m_tFriend.friendliness)
    elseif type == 7 then
        sName = string.format(LocalStrings.TO_YOU, self.m_tFriend.name)
        local nMaxHave = tonumber(CacheCenter:getGameParam()["maxChum"])
        local nLeftNum = nMaxHave - CacheCenter:getBestFriendNum() 
        sContent = string.format(LocalStrings.FRIENDS_BESTFRIEND5, nLeftNum)
    elseif type == 8 then
        sName = string.format(LocalStrings.WITH_YOU, self.m_tFriend.name)
        sContent = LocalStrings.FRIENDS_BESTFRIEND6
    elseif type == 9 then
    	sName = string.format(LocalStrings.TO_YOU, self.m_tFriend.name)
        sContent = LocalStrings.PRACTICE_TEXT8
	end
	txtDesName:setShowText(sName)
	txtDesContent:setShowText(sContent)
end

--@brief	字体排版
function CellDynamic:_showTTFLayout(txtA,txtB)
	local dir = 4
	local sizeA = txtA:getContentSize()
	local rePosA = txtA:getRelativePosition()
	local lpSize = txtA:getParent():getContentSize()
	local x = rePosA.x + (sizeA.width + dir)/lpSize.width
	local y = rePosA.y
	txtB:setRelativePosition(GlobalMethod:ccp(x,y))	
end


--@brief    计算离线时间
function CellDynamic:_returnOfflineAtt(offlineTime)
    -- body
    local curTime = SystemTime:getServerTime()
    if offlineTime == nil then
    	offlineTime = 0 
    end
    local nTime = curTime - offlineTime
    local sText = ""
    if offlineTime <=0 then  --针对老客户
        nTime = 1
        local sTimeString = string.format(LocalStrings.HOUR_BEFORE, nTime)
        sText = sText .. sTimeString
        return sText
    end
    if nTime < 60 * 60 then    --xx分钟前
        nTime = (nTime / 60) + 1
        local sTimeString = string.format(LocalStrings.MINUTE_BEFORE, nTime)
        sText = sText .. sTimeString
    elseif nTime < 3600 * 24 then --xx小时前
        nTime = nTime / 3600
        local sTimeString = string.format(LocalStrings.HOUR_BEFORE, nTime)
        sText = sText .. sTimeString
    elseif nTime < 3600 * 24 * 7 then --xx天前
        nTime = nTime / (3600 * 24)
        local sTimeString = string.format(LocalStrings.DAY_BEFORE, nTime)
        sText = sText .. sTimeString
    elseif nTime < 3600 * 24 * 7 * 4 then --xx周前
        nTime = nTime / (3600 * 24 * 7)
        local sTimeString = string.format(LocalStrings.WEEK_BEFORE, nTime)
        sText = sText .. sTimeString
    elseif nTime < 3600 * 24 * 30 * 12 then --xx月前
        nTime = math.floor(nTime / (3600 * 24 * 30))
        if nTime == 0 then 
            nTime = 1
        end
        local sTimeString = string.format(LocalStrings.MONTH_BEFORE, nTime)
        sText = sText .. sTimeString
    else    --xx年前
        nTime = nTime / (3600 * 24 * 30 * 12)
        local sTimeString = string.format(LocalStrings.YEAR_BEFORE, nTime)
        sText = sText .. sTimeString
    end

    return sText
end
-------------------------------------私有方法模块End----------------------------------------









