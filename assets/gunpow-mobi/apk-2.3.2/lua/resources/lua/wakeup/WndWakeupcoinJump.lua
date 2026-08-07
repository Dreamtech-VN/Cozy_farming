--WndWakeupcoinJump.lua
--@brief    WndWakeupcoinJump的UI模块
--@date     2016/03/31
--@author   Tianxiang_Xu
--@note     好友礼物列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndWakeupcoinJump:onEnter(element)
    self.m_root = element
    CacheCenter:registerUpatePlayerItemObserver(self)
    self:setData()
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndWakeupcoinJump:onExit(element)
    self:_unInit()
    CacheCenter:unregisterUpatePlayerItemObserver(self)
end


--@brief    触摸开始函数
function WndWakeupcoinJump:onTouchBegin(element, pt)
    WZLog("WndWakeupcoinJump:onTouchBegin",pt.x,pt.y)
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt,dir)
    if bPoint == true then
        WZLog("回调函数:",type(bPoint),bPoint)
    else
        WndItemInfo:onCloseClick()
    end
    if not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end
end

--@brief    关闭界面
function WndWakeupcoinJump:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    
    WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
    
end

--@brief    关闭按钮回调事件
function WndWakeupcoinJump:onCloseActionCallback(element,data)
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    其它Item点击回调
function WndWakeupcoinJump:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData,false)
end

--@brief    点击赠送按钮回调
function WndWakeupcoinJump:onGiveGiftClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if not WndCheckOther.m_tPlayerInfo.isFriend then
        MsgBoxManager:showTipBox(LocalStrings.GIFTLIMIT_ATT)
        return 
    end
    
    local nTag = element:getTag() + 1
    tData = self.m_tGiftList[nTag]
    self.m_nClickItemTag = nTag - 1
    local nLastNum = getBagItemCount(tData.id)
    WZLog("WndWakeupcoinJump:onGiveGiftClick", Serialize(tData))
    if nLastNum <= 0 then
        local sNotEnoughAtt = string.format(LocalStrings.FRIEND_GIFT_NOT_ENOUGH, tData.name) 
        MsgBoxManager:showConfirmBox(sNotEnoughAtt, self, self._buyGift, nil, nil)
        return 
    end
    ProtocolProcessorWndFriends:send_FRIEND_SendGift(self.m_nFriendId, tData.id)
end

--@brief    收到缓存推送后更新装备信息
function WndWakeupcoinJump:updatePlayerItemData()
    if WndWakeupcoinJump.m_root == nil then return end
    WZLog("WndWakeupcoinJump:updatePlayerItemData")
    local tableGiftList = GetElement(self.m_root, "tableconGiftList_WndWakeupcoinJump", WZUITableContainer)
    if self.m_nClickItemTag ~= nil then
        local tData = self.m_tGiftList[self.m_nClickItemTag + 1]
        -- 购买成功后，刷新数量显示
        local element = tableGiftList:getCellElement(self.m_nClickItemTag)
        local conForGift = GetElement(element, "conForGift_WndWakeupcoinJump", WZUIContainer) 
        local cellElement = conForGift:getChildByTag(99)
        if cellElement then
            cellElement = WZUIContainer:luaTo(cellElement)
            local tLuaObj = cellElement:getLuaObjectIndex()
            if tLuaObj then
                local key = "id_"..tData.id
                local num = getBagItemCount(tData.id)
                local itemInfo = {id = tData.id, name=tData.name,icon=tData.icon,lastTime=num,quality=tData.quality,basicInfo=CopyTable(GDatatab_item[key])}
                tLuaObj:setCellGoodItem(itemInfo,4)
            end
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面信息
function WndWakeupcoinJump:_update()
    -- body
    local tGiftList = self.m_tGiftList
    local tableGiftList = GetElement(self.m_root, "tableconGiftList_WndWakeupcoinJump", WZUITableContainer)
    WZLog("***** WndWakeupcoinJump:_update *****", Serialize(tGiftList))
    for i = 1, #tGiftList do
        local element = WZUISystem:getInstance():createElement("conCellFriendGift")
        if element then
            WZLog("***** WndWakeupcoinJump:_update ***** 11111") 
            element:setVisible(true)
            self:_updateCellInfo(element, tGiftList[i])
        end

        local btnGiveGift = GetElement(element, "btnGiveGift_conCellFriendGift", WZUIButton)
        btnGiveGift:setTag(i - 1)

        element:setTag(i - 1)
        tableGiftList:setCellElement(element)
    end
end

--@brief    更新礼物子项的显示信息
function WndWakeupcoinJump:_updateCellInfo(element, tData)
    -- body
    --增加友好度提示
    local txtFriendliness = GetElement(element, "txtFriendliness_conCellFriendGift", WZUIFreeTextBox)
    local sFormat = LocalStrings.ADD_FRIENDLINESS
    if ProjConfig.LANGUAGE == "vn" then 
        sFormat = string.gsub(LocalStrings.ADD_FRIENDLINESS, "24", "16")
    end
    local sDesText = string.format(sFormat, tData.value)
    txtFriendliness:setShowText(sDesText)
    --礼物的图标
    local conForGift = GetElement(element, "conForGift_WndWakeupcoinJump", WZUIContainer) 

    local celElement,tLuaObj = CellGoodItem:createElement()
    if celElement ~= nil then 
        celElement = WZUIContainer:luaTo(celElement)
        local key = "id_"..tData.id
        local num = getBagItemCount(tData.id)
        local itemInfo = {id = tData.id, name=tData.name,icon=tData.icon,lastTime=num,quality=tData.quality,basicInfo=CopyTable(GDatatab_item[key])}
        tLuaObj:setCellGoodItem(itemInfo,4)
        tLuaObj:setItemClickFun(self,self.onOthersClick)
    end
    celElement:setTag(99)
    conForGift:addChild(celElement)
end

--@brief    礼物不足,跳到购买界面
function WndWakeupcoinJump:_buyGift(element, btnTag)
    -- body
    local tData = self.m_tGiftList[self.m_nClickItemTag + 1]
    WZLog("WndWakeupcoinJump:_buyGift 000", btnTag, MSGBOXTYPE_CONFIRM)
    if btnTag == MSGBOXTYPE_CONFIRM then
        WZLog("WndWakeupcoinJump:_buyGift", tData.id)
        local materialId = tData.id
        checkIsOnSale(materialId,LocalStrings.ITEMNOTSALE)--打开购买窗口
    end
end

--@brief    显示好友度
function WndWakeupcoinJump:_updateFriendliness()
    -- body
    if self.m_nFriendliness then
        local txtFriendLiness = GetElement(self.m_root, "txtFriendLiness_WndWakeupcoinJump", WZUILabelTTF)
        txtFriendLiness:setText(LocalStrings.FRIENDLINESS .. self.m_nFriendliness)
    end
end
-------------------------------------私有方法模块End----------------------------------------
