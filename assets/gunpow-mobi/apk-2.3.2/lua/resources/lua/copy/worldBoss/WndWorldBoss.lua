--WndWorldBoss.lua
--@brief	WndWorldBoss的UI模块
--@date		2015-9-24
--@author	binshao
--@note		一键继承窗口模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndWorldBoss:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	打开加载动画
function WndWorldBoss:onEnterTransitionDidFinish(element)
    WZLog("WndWorldBoss:onEnterTransitionDidFinish")
    self:_initOpenDesc()
    self:showEquipList() 
end


--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndWorldBoss:onExit(element)
    ProtocolProcessorSceneWorldBoss:unregAll()
    self.m_root:disableSchedule()
	self:_unInit()
end

-- 关闭按钮回调函数
function WndWorldBoss:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self:onCloseActionCallback()
end

function WndWorldBoss:onCloseActionCallback()
    WindowManager:removeWindow(self.m_root , self , true)
end

-- 创建加载框
function WndWorldBoss:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox(10)
end

-- 关闭加载框
function WndWorldBoss:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    self.m_nLoadingId = nil 
end

-----------------------------------------------回调start----------------------------------------------------------------
-- 选择boss1
function WndWorldBoss:onClickCancel( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndWorldBoss:onClickCancel")
    local transferState = WZLuaVector_int_:create()
    for i = 1, GetTableLen(self.m_Id) do
        transferState:push(0)
    end

    WZLog("WndWorldBoss:onClickCancel one", Serialize(self.m_Id))
    ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(TableToVector(self.m_Id, WZLuaVector_int_), transferState)
    self:onCloseActionCallback()
end

-- 选择boss2
function WndWorldBoss:onClickTransfer( element )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("WndWorldBoss:onClickTransfer")
    local transferState = WZLuaVector_int_:create()
    for i = 1, GetTableLen(self.m_Id) do
        transferState:push(1)
    end

    ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(TableToVector(self.m_Id, WZLuaVector_int_), transferState)
    self:onCloseActionCallback()
end

function WndWorldBoss:onItemClick(tCell,tag,tData)
    if tData == nil or tCell == nil then
       return
    end

    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tCell.m_root,self.m_root,1,tData,false)
end
-----------------------------------------------回调end------------------------------------------------------------------

---------------------------------------------私有方法模块start----------------------------------------------------------
-- 初始化boss主界面
function WndWorldBoss:_initOpenDesc()
    local ftxtDesc = GetElement(self.m_root, "ftxtDesc_WndWorldBoss", WZUIFreeTextBox)
    if ftxtDesc then 
        ftxtDesc:setShowText(LocalStrings.ONEKEY_TRANSFER2)
    end

    self:_upMoveContainerLayer()
end

--@brief   显示装备列表
function WndWorldBoss:showEquipList() 
    local tbEquipList = GetElement(self.m_root, "tbEquipList_WndWorldBoss", WZUITableContainer)
    tbEquipList:cleanTable()

    for i = 1, 8 do
        local element = WZUISystem:getInstance():createElement("CellTransferItem")
        element:setVisible(true)
        element:setTag(i - 1)
        tbEquipList:setCellElement(element)
        if self.m_tEquipList[i] then 
            --旧装备
            local conEquip1 = GetElement(element, "conEquip1_WndWorldBoss", WZUIContainer)
            local celElement, tNewObj = CellGoodItem:createElement()
            tNewObj:setCellGoodItem(self.m_tEquipList[i][1], 1)
            tNewObj:setItemClickFun(self, self.onItemClick)
            conEquip1:addChild(celElement)
            --新装备
            local conEquip2 = GetElement(element, "conEquip2_WndWorldBoss", WZUIContainer)
            local celElement, tNewObj = CellGoodItem:createElement()
            
            tNewObj:setCellGoodItem(self.m_tEquipList[i][2], 1)
            tNewObj:setItemClickFun(self, self.onItemClick)
            conEquip2:addChild(celElement)
        end
    end
end

--@brief    更新滚动容器内部布局函数
function WndWorldBoss:_upMoveContainerLayer()
    WZLog("WndWorldBoss:_upMoveContainerLayer()")
    if self.m_root == nil then
        return
    end
    --获取规则说明内容文本的大小
    local txtExplanation = GetElement(self.m_root, "ftxtDesc_WndWorldBoss", WZUIFreeTextBox)
    local txtSize = txtExplanation:getContentSize() 
    txtExplanation:setAnchorPoint(ccp(0,1))
    txtExplanation:setPositionY(txtSize.height-5)

    local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndWorldBoss")
    if rollconExplanation == nil then 
        return
    end
    rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
    local rollSize = rollconExplanation:getContentSize()
    --更改滚动容器Element的大小
    local moveElement = rollconExplanation:getMoveElement()
    local size = moveElement:getRelativeSize()
    moveElement:setRelativeSize( CCSize(1 , txtSize.height / rollSize.height ) )
    --moveElement:setContentSize(txtSize)
    rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
    moveElement:setPositionY(rollconExplanation:getMinPosition().y)
end
---------------------------------------------私有方法模块End------------------------------------------------------------
----------------------------------------------语言适配Begin-----------------------------------------------------------------
function WndWorldBoss:_adaptLanguage_en(  )
    
end

function WndWorldBoss:_adaptLanguage_pt(  )
    
end

function WndWorldBoss:_adaptLanguage_cn(  )
    
end

function WndWorldBoss:_adaptLanguage_tr(  )
   
end
----------------------------------------------语言适配End----------------------------------------------------