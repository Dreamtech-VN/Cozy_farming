--CellShopFriend.lua
--@brief	CellShopFriend的UI模块
--@date		2016-4-24
--@author	binshao
--@note		商城赠送好友列表cell

-------------------------------------公有方法模块--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellShopFriend:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellShopFriend:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellShopFriend:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellShopFriend")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
    AdaptLanguage(self)
end

-- 选择当前cell
function CellShopFriend:onSelect()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local index = self.m_root:getTag()
    WZLog("---------------------sel-----------------",index)
    self.selState = not self.selState
    WndShopGiven:updateSelState(index,self.selState)
end
-------------------------------------私有方法模块--------------------------------------

--@brief  更新cell界面元素
function CellShopFriend:_update()
	if self.m_root == nil then return end

    -- 头像
    local con = GetElement(self.m_root, "conHead_CellShopFriend", WZUIContainer)
    CellHead:show(con,self.data.headId,self.data.faceId,self.data.sex,nil,nil,self.data.vipLv,self.data.headColor)

    -- 等级和名字
    local txtLv = GetElement(self.m_root, "txtFriendLv_CellShopFriend", WZUILabelTTF)
    local txtName = GetElement(self.m_root, "txtFriendName_CellShopFriend", WZUILabelTTF)
    txtLv:setText("LV"..self.data.level)
    txtLv:setText(self.data.name)

--    -- 好友度
--    local txtFriendPoint = GetElement(self.m_root, "txtFriendPoint_CellShopFriend", WZUILabelTTF)
--    txtFriendPoint:setText(self.data.friendPoint)

    -- 好友度
    local text = [[<T C="255,227,116" S="20" P="0">%s</T><T C="255,255,255" S="20" P="0">%d</T>]]
    local ftbFriendPoint = GetElement(self.m_root, "ftbFriendPoint_CellShopFriend", WZUIFreeTextBox)
    ftbFriendPoint:setShowText(string.format(text,LocalStrings.FRIENDLINESS, self.data.friendPoint))

    -- 选中状态
    local con = GetElement(self.m_root, "conSel_CellShopFriend", WZUIContainer)
    con:setVisible(self.selState)
end

-- 设置选中状态
function CellShopFriend:setCellSel(bVisible)
    self.selState = bVisible
    if self.loadEnd == false then return end
    local con = GetElement(self.m_root, "conSel_CellShopFriend", WZUIContainer)
    con:setVisible(self.selState)
end

----------------------------------语言适配Begin-------------------------------------------
function CellShopFriend:_adaptLanguage_pt(  )
    GetElement(self.m_root,"ftbFriendPoint_CellShopFriend",WZUIFreeTextBox):setScale(0.7)
end

function CellShopFriend:_adaptLanguage_en(  )
    GetElement(self.m_root,"ftbFriendPoint_CellShopFriend",WZUIFreeTextBox):setScale(0.8)
end

function CellShopFriend:_adaptLanguage_tr(  )
    GetElement(self.m_root,"ftbFriendPoint_CellShopFriend",WZUIFreeTextBox):setScale(0.8)
end

function CellShopFriend:_adaptLanguage_es(  )
    GetElement(self.m_root,"ftbFriendPoint_CellShopFriend",WZUIFreeTextBox):setScale(0.7)
end
----------------------------------语言适配End---------------------------------------------