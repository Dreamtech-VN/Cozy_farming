--CellMarryFriend.lua
--@brief	CellMarryFriend的UI模块
--@date		2014/03/26
--@author	liangguang_long
--@note		附近好友模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMarryFriend:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMarryFriend:onExit(element)
	self:_unInit()
end

--@brief	背景按钮函数
--@param	element:表绑定的UI节点引用
function CellMarryFriend:onBackClick(element)
	element = WZUIButton:luaTo(element)
	local tag = self.m_root:getTag()
	self.m_tBackFun[2](self.m_tBackFun[1],self,tag,self.m_tFriend)
    self:onChoose(element)  
end

function CellMarryFriend:setIndex(status)
	self.m_tFriend.status = status
end

function CellMarryFriend:getIndex()
	return self.m_tFriend.status
end

function CellMarryFriend:setChoicesItem(index)
	local imgSel = WZUIImage:luaTo(self.m_root:getChildElement("imgSel_CellMarryFriend"))
	imgSel:setFile("ui/common/common_icon_gou.png")
	imgSel:setVisible(true)
    self.m_tFriend.status = 1
	if index == 1 then
		imgSel:setVisible(false)
        self.m_tFriend.status = 0
	end
	WZLog("self.m_tFriend.status:::",self.m_root:getTag())
end

--@brief    设置好友的状态：选中或未选中
function CellMarryFriend:setStatus()
    -- body
    local imgSel = WZUIImage:luaTo(self.m_root:getChildElement("imgSel_CellMarryFriend"))
    imgSel:setFile("ui/common/common_icon_gou.png")
    if self.m_tFriend.status == 0 then
        imgSel:setVisible(false)
        WZLog("CellMarryFriend:setStatus   11111")
    elseif self.m_tFriend.status == 1 then
        imgSel:setVisible(true)
        WZLog("CellMarryFriend:setStatus   22222")
    end
end

function CellMarryFriend:onChoose(element)	
	self:setChoicesItem(self.m_tFriend.status)
	local tag = self.m_root:getTag()
	self.m_tBackFun[3](self.m_tBackFun[1],self,tag,self.m_tFriend)
end

--@brief    加载cell数据信息
function CellMarryFriend:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellMarryFriend")
    self.m_root:addChild(cellElement)
    self:_update()
    AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellMarryFriend:_update()
	if self.m_root == nil or self.m_tFriend == nil then
		return
	end
	self:_showName()--显示名称
	self:_showHeadIcon()
    self:setStatus()  --选中状态
end
		
--@brief	显示名称
function CellMarryFriend:_showName()
	local txtName = WZUIFreeTextBox:luaTo(self.m_root:getChildElement("txtName_CellMarryFriend"))
	local msg = string.format(self.m_tLevelAndNameFormat,self.m_tFriend.level,self.m_tFriend.name)
	txtName:setShowText(msg)
    if self.m_nInterface == 5 then
        GetElement(self.m_root, "btnPlayerInfo_CellMarryFriend", WZUIButton):setTouchEnable(false)
        local txtFriendsLiness = GetElement(self.m_root, "txtFriendsLiness_CellMarryFriend", WZUIFreeTextBox)
        local sValueFormat = [[<T C="255,227,116" S="22" P="1">%s</T><T C="255,255,255" S="22" P="1">%d</T>]]
        if self.m_tFriend.friendliness then
            local sFriendsLiness = string.format(sValueFormat, LocalStrings.FRIENDLINESS, self.m_tFriend.friendliness)
            txtFriendsLiness:setShowText(sFriendsLiness)
        end
    else
        GetElement(self.m_root, "btnPlayerInfo_CellMarryFriend", WZUIButton):setTouchEnable(true)
        txtName:setRelativePosition(GlobalMethod:ccp(0.03,0.5))
        GetElement(self.m_root, "conFriendliness_CellMarryFriend", WZUIContainer):setVisible(false)
    end
end

--@brief    显示玩家头像
function CellMarryFriend:_showHeadIcon()
    WZLog("CellMarryFriend:_showHeadIcon()")
    --设置默认显示
    local conHead = GetElement(self.m_root,"conHead_CellMarryFriend",WZUIContainer)

    local isOffLine = false
    if self.m_tFriend.isOnline == 0 or self.m_tFriend.isOnline == false then
        isOffLine = true
    end
    local cellElement =  CellHead:show(conHead,self.m_tFriend.headItemId,self.m_tFriend.faceItemId,self.m_tFriend.sex, isOffLine, nil, self.m_tFriend.vipLevel, self.m_tFriend.headColor)
    cellElement:setScale(1.15)
end

--点击好友头像
function CellMarryFriend:event_ClickHead( element )
    WZLog("CellFriendList:event_ClickHead")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tFriend.id)
end
-------------------------------------私有方法模块End----------------------------------------

------------------------------------------语言适配Begin-------------------------------------
function CellMarryFriend:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtFriendsLiness_CellMarryFriend",WZUIFreeTextBox):setScale(0.8)
end

function CellMarryFriend:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtFriendsLiness_CellMarryFriend",WZUIFreeTextBox):setScale(0.8)
end
------------------------------------------语言适配End--------------------------------------






