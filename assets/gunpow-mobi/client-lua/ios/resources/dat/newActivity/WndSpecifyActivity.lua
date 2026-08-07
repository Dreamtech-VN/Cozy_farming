--WndSpecifyActivity.lua
--@brief	WndSpecifyActivity的UI模块
--@date		2017/08/21
--@author	Tianxiang_Xu
--@note		定向推送活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpecifyActivity:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpecifyActivity:onExit(element)
	self:_unInit()
end

--@brief    onenter函数已执行
function WndSpecifyActivity:onEnterTransitionDidFinish(element)
    WZLog("WndSpecifyActivity:onEnterTransitionDidFinish")
    
end

--@brief    关闭窗口
function WndSpecifyActivity:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManagerAni:createDisappearAction(self.m_root,"actionCallback_close",self)
end

--@brief    弹窗动画完成后的回调
function WndSpecifyActivity:actionCallback_close(element,data)
    if self.m_tMsgData ~= nil then 
        self.m_tMsgData.nStatus = MSGBOXSTATUS_DONE
    end
    WindowManager:removeWindow(self.m_root , self , true)
end

--@brief    点击左边栏按钮回调
function WndSpecifyActivity:onClickLeftMenu(nItemId)
    -- body
    self.m_nCurItemId = nItemId

    self:_setLightVisible()
    self:chooseMethod()
end

function WndSpecifyActivity:chooseMethod()
    --刷新右边栏内容
    local tItem = self:_getSelData(self.m_nCurItemId)
    self:_updateActivityContext(tItem.item_id, tItem.count, tItem.giftType, tItem.originPrice)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    更新界面信息
function WndSpecifyActivity:_update()
    -- body
    --标题
    self:_setTitle()
    --左边栏
    self:_createLeftMenu()
    self:chooseMethod()
end

--@brief    设置界面标题
function WndSpecifyActivity:_setTitle()
    -- body
    local imgTitle = GetElement(self.m_root, "imgTitle_WndSpecifyActivity", WZUIImage)

    ChangeChatChannel(Chat_Channel_Welfare_Weal)
    imgTitle:setFile("ui/common/common_icon_tjbox.png")
end

--@brief    设置左边列表菜单
function WndSpecifyActivity:_createLeftMenu()
    -- body
    local flListItem = GetElement(self.m_root, "flListItem_WndSpecifyActivity", WZUIFreeListContainer)
    flListItem:removeAll()
    self.m_tLeftCell = {}

    local bIsExist = self:_checkUI_IDExist(self.m_nCurItemId)

    for i = 1, #self.m_tListItem do
        WZLog("WndSpecifyActivity:_createLeftMenu", self.m_tListItem[i].item_id)
        local element, tCell = CellWelfareItem:createElement()
        if element and tCell then
            if i == 1 and (bIsExist == false or self.m_nCurItemId == nil) then
                self.m_nCurItemId = self.m_tListItem[i].item_id
            end

            tCell:setData(self.m_tListItem[i].name, self.m_tListItem[i].item_id)
            tCell:setCallBack(self, self.onClickLeftMenu)
            element = WZUIContainer:luaTo(element)
            flListItem:pushBack(element)
            table.insert(self.m_tLeftCell, tCell)
        end
    end
    flListItem:getMoveElement():setPositionY(flListItem:getMinPosition().y)
    --
    self:_setLightVisible()
end

--@brief    设置选中的左边菜单变亮
function WndSpecifyActivity:_setLightVisible()
    -- body
    if self.m_tLeftCell then
        for i = 1, #self.m_tLeftCell do
            if self.m_tLeftCell[i]:getItemId() == self.m_nCurItemId then
                self.m_tLeftCell[i]:setLightVisible(true)
            else
                self.m_tLeftCell[i]:setLightVisible(false)
            end
        end
    end
end

--@brief    设置面板内容
function WndSpecifyActivity:_updateActivityContext(item_id, count, nGiftType, originPrice)
    WZLog("WndSpecifyActivity::_updateActivityContext")
    local con_ActivityContext = GetElement(self.m_root,"conContext_WndSpecifyActivity",WZUIContainer)
    if con_ActivityContext == nil then
        return
    end
    con_ActivityContext:removeAllChildrenWithCleanup(true)
    WZLog("m_nCurrentSelectTypeId="..self.m_nCurItemId)
    
    self.m_tCommonPanelElement,self.m_tCommonPanelLuaObj = CellSpecifyPanel:createElement()
    self.m_tCommonPanelElement = WZUIContainer:luaTo(self.m_tCommonPanelElement)

    con_ActivityContext:addChild(self.m_tCommonPanelElement)

    self.m_tCommonPanelLuaObj:setMessage(item_id, count, nGiftType, originPrice)
    
    if self.m_tCommonPanelElement ~= nil then
        self.m_tCommonPanelLuaObj:showWindow()
    end
end

--@brief    判断传进来的ui_id是否存在列表当中
--@param    item_id:检测的item_id
function WndSpecifyActivity:_checkUI_IDExist(item_id)
    -- body
    if self.m_tListItem == nil or item_id == nil then 
        return false 
    end

    for i = 1, #self.m_tListItem do
        if self.m_tListItem[i].item_id == item_id then
            return true
        end
    end

    return false
end

--@brief    根据item_id，返回相应的数据
function WndSpecifyActivity:_getSelData(item_id)
    --body
    for i = 1, #self.m_tListItem do
        if self.m_tListItem[i].item_id == item_id then
            return self.m_tListItem[i]
        end
    end

    return nil 
end
-------------------------------------私有方法模块End----------------------------------------
