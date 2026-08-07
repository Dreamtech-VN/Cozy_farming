--WndFootShop.lua
--@brief	WndFootShop的UI模块
--@date		2021/11/02
--@author	XTX
--@note		足迹城市商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootShop:onEnter(element)
	self.m_root = element

	ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityShop()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFootShop:onExit(element)
	self:_unInit()
end

function WndFootShop:onClickClose(element)
	WZLog("WndFootShop:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    self:onCloseActionCallback()
end

--@brief	窗口动画关闭完成回调
function WndFootShop:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击货币回调
function WndFootShop:onClickCoin(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    local nTag = element:getTag()
    if self.m_tCoinList[nTag] then 
        WndFastGetItems:show(self.m_tCoinList[nTag])
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  更新活跃度信息列表
function WndFootShop:update()
	self:_setLocalText()

	local tabList = GetElement(self.m_root, "tabList_WndFootShop", WZUITableContainer)
    tabList:cleanTable()
    local nCount = #self.m_tShopList
    if nCount < 6 then 
        nCount = 6  
    end
    for i = 1, nCount do
        local element, tNewObj = CellCommunityShop:createElement()
        if element and tNewObj then 
            local v = self.m_tShopList[i]
            element:setVisible(true)
            element:setTag(i-1)
            tNewObj:setShowType(6)
            if v then 
                tNewObj:setCellShop(v, v.id, v.itemId, v.itemNum, v.costNum, v.costId, 10)
            else
                tNewObj:setCellShop()
            end

            tabList:setCellElement(element)
        end
    end

    if self.m_nCurPosY then 
        tabList:getMoveElement():setPositionY(self.m_nCurPosY)
    end
end

--@brief  设置本地界面文本
function WndFootShop:_setLocalText()
	for i = 1, #self.m_tCoinList do
        local conCoin = GetElement(self.m_root, "conCoin" .. i .. "_WndFootShop", WZUIContainer)
        conCoin:setVisible(true)
        local imgIcon = GetElement(conCoin, "imgIcon_WndFootShop", WZUIImage)
        if imgIcon then 
            local basicInfo = GDatatab_item["id_" .. self.m_tCoinList[i]]
            imgIcon:setFile(basicInfo.icon)
        end
    end

    self:updateCoinNum()
end

--@brief    刷新晶石数量
function WndFootShop:updateCoinNum()
    if self.m_root == nil then return end 
    
    for i = 1, #self.m_tCoinList do
        local conCoin = GetElement(self.m_root, "conCoin" .. i .. "_WndFootShop", WZUIContainer)
        local txtNum = GetElement(conCoin, "txtNum_WndFootShop", WZUILabelTTF)
        local nCount = CacheCenter:getPlayerItemCountById(self.m_tCoinList[i])
        if txtNum then 
            txtNum:setText(nCount)
        end
    end
end


-------------------------------------私有方法模块End----------------------------------------
