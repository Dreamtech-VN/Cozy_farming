--CellRankListItem.lua
--@brief	CellRankListItem的UI模块
--@date		2015/04/22
--@author	hyq
--@note		排行榜标签格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRankListItem:onEnter(element)
    WZLog("CellRankListItem:onEnter(element)")
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRankListItem:onExit(element)
	self:_unInit()
end

--@brief    设置按钮为当前选中时，选中效果可见
function CellRankListItem:setSelSignVisible(bBool)
    -- body
    self.m_bIsHighLight = bBool 
    if self.m_bIsLoad == false then return end
    GetElement(self.m_root, "conSelSign_CellRankListItem", WZUIContainer):setVisible(bBool)
end

-------------------------------------公有方法模块End----------------------------------------
--@brief    点击Cell时回调函数
function CellRankListItem:onCellClickedCallback(element)
    WZLog("CellRankListItem:onCellClickedCallback",self.m_nRankListType)
    WndRankList:itemCellClicked(self.m_nRankListType)
end

--@brief    加载cell数据信息
function CellRankListItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellRankListItem")
    self.m_root:addChild(cellElement)
    self.m_bIsLoad = true
    self:_update()
    AdaptLanguage(self)
end
-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新信息
function CellRankListItem:_update()
    -- body
    if self.m_root == nil then return end
    --设置label
    local itemNameLabel = GetElement(self.m_root, "label_item", WZUILabelTTF)
    if itemNameLabel ~= nil then 
        WZLog("self.m_tItemName[nType]",self.m_tItemName[self.m_nRankListType])
        itemNameLabel:setText(self.m_tItemName[self.m_nRankListType])
    end
    --选中状态
    self:setSelSignVisible(self.m_bIsHighLight)
end




-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin-----------------------------------------
function CellRankListItem:_adaptLanguage_tr(  )
    local label = GetElement(self.m_root,"label_item",WZUILabelTTF)
    label:setDimensions(GlobalMethod:CCSize(140,0))
    label:setFontSize(24)
end

function CellRankListItem:_adaptLanguage_es(  )
    local label = GetElement(self.m_root,"label_item",WZUILabelTTF)
    label:setDimensions(GlobalMethod:CCSize(140,0))
    label:setFontSize(24)
end
---------------------------------------语言适配End-------------------------------------------