--CellMarryBetrothed.lua
--@brief	CellMarryBetrothed的UI模块
--@date		2020/11/09
--@author	yrd
--@note		结婚请柬中好友格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMarryBetrothed:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMarryBetrothed:onExit(element)
	self:_unInit()
end


--@brief    加载cell数据信息
function CellMarryBetrothed:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellMarryBetrothed")
    self.m_root:addChild(cellElement)
    self:_update()
    AdaptLanguage(self)
end

--@brief	更新函数
function CellMarryBetrothed:_update()
	if self.m_root == nil or self.m_tFriend == nil then
		return
	end
	self:_showName()--显示名称
	self:_showHeadIcon()
    self:setStatus()  --选中状态
end

function CellMarryBetrothed:setIndex(status)
	self.m_tFriend.status = status
end

function CellMarryBetrothed:getIndex()
	return self.m_tFriend.status
end

function CellMarryBetrothed:setChoicesItem(index)
	local imgSel = WZUIImage:luaTo(self.m_root:getChildElement("imgSel_CellMarryBetrothed"))
	imgSel:setVisible(true)
    self.m_tFriend.status = 1
	if index == 1 then
		imgSel:setVisible(false)
        self.m_tFriend.status = 0
	end
end

--@brief    设置好友的状态：选中或未选中
function CellMarryBetrothed:setStatus()
    local imgSel = WZUIImage:luaTo(self.m_root:getChildElement("imgSel_CellMarryBetrothed"))
    if self.m_tFriend.status == 0 then
        imgSel:setVisible(false)
    elseif self.m_tFriend.status == 1 then
        imgSel:setVisible(true)
    end
end

--@brief	显示名称
function CellMarryBetrothed:_showName()
	local txtName = WZUIFreeTextBox:luaTo(self.m_root:getChildElement("txtName_CellMarryBetrothed"))
	local msg = string.format(LocalStrings.LevelAndNameFormat,self.m_tFriend.level,self.m_tFriend.name)
    if self.m_tFriend.serverId ~= CacheCenter:getPlayerInfo().serverId then
        msg = string.format(LocalStrings.LevelAndNameFormat2,self.m_tFriend.level,self.m_tFriend.name)
    end
	txtName:setShowText(msg)
end

--@brief    显示玩家头像
function CellMarryBetrothed:_showHeadIcon()
    WZLog("CellMarryBetrothed:_showHeadIcon()")
    --设置默认显示
    local conHead = GetElement(self.m_root,"conHead_CellMarryBetrothed",WZUIContainer)

    local isOffLine = false
    if self.m_tFriend.isOnline == 0 or self.m_tFriend.isOnline == false then
        isOffLine = true
    end
    local cellElement =  CellHead:show(conHead,self.m_tFriend.headItemId,self.m_tFriend.faceItemId,self.m_tFriend.sex, isOffLine, nil, self.m_tFriend.vipLevel, self.m_tFriend.headColor)
    cellElement:setScale(1.15)
end

--点击好友头像
function CellMarryBetrothed:event_ClickHead( element )
    WZLog("CellFriendList:event_ClickHead")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tFriend.id)
end

function CellMarryBetrothed:onBackClick(element)
    self:setChoicesItem(self.m_tFriend.status)
    local tag = self.m_root:getTag()
    self.m_tBackFun[2](self.m_tBackFun[1],self,tag,self.m_tFriend)
end

function CellMarryBetrothed:onChoose(element)
	self:setChoicesItem(self.m_tFriend.status)
	local tag = self.m_root:getTag()
	self.m_tBackFun[2](self.m_tBackFun[1],self,tag,self.m_tFriend)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
