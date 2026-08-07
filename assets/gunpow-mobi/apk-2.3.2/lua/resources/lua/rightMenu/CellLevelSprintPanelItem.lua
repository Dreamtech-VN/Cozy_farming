--CellLevelSprintPanelItem.lua
--@brief	CellLevelSprintPanelItem的UI模块
--@date		2015/05/13
--@author	weidong_wu
--@note		等级冲刺

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLevelSprintPanelItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLevelSprintPanelItem:onExit(element)
	self:_unInit()
end

--@brief    加载item
function CellLevelSprintPanelItem:ShowCellItem(  )
    self:_initItemMsg()
    self:_setRewardList()
    AdaptLanguage(self)
end

--@brief    tips回调
function  CellLevelSprintPanelItem:BtnDoneEvent()
    WZLog("CellLevelSprintPanel:BtnDoneEvent()::"..self.tag)
    local positionY,movepositionY = CellLevelSprintPanel:getFreeListPositionY()
    WZLog("..."..positionY.."..."..movepositionY)
    local MoveDistance = math.abs((positionY-movepositionY))%125
    --ItemTag = math.abs(ItemTag)
    --ItemTag = self:_getIntPart(ItemTag)
    local reduceItem = math.abs((positionY-movepositionY))/125

    local  ItemTag = self.tag-1
    WZLog("ItemTag="..ItemTag)
    local CellIdx = self.tag-1-math.floor(reduceItem)
   	local moveCellItem = math.abs((positionY-movepositionY))/125

    --local moveCellItem = 0.1*(MoveDistance/12.5)

    if (MoveDistance > 40.0 and CellIdx == 0) then 
        return
    end    

    if (MoveDistance < 40.0 and CellIdx == 2 ) or (MoveDistance==0 and CellIdx==2) then
        return
    end

    if CellIdx > 2 then 
    	return 
    end 


    -- local wndtotalrewardlist,tLua = WndTotalRewardList:createElement()
    -- local tItemId = {}
    -- local tItemNum = {}
    -- for i=1,#self.m_tData do
    --     table.insert(tItemId,self.m_tData[i].id)
    --     table.insert(tItemNum,self.m_tData[i].num)
    -- end
    -- if wndtotalrewardlist ~= nil then
    --     WindowManager:addWindow(wndtotalrewardlist, WndTotalRewardList)
    --     tLua:_setItemListForActivity(tItemId,tItemNum,0.45-ItemTag+moveCellItem,#self.m_tData,true,self.status,0.875)
    -- end
end


--@brief    获取奖励
function CellLevelSprintPanelItem:event_getReward(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    CellLevelSprintPanelItem.m_current_click = self
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.typeIndex,self.rewardId)
end

--@brief    加载cell数据信息
function CellLevelSprintPanelItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellLevelSprintPanelItem")
    self.m_root:addChild(cellElement)

    self:ShowCellItem()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@breif    设置Item显示的信息
function CellLevelSprintPanelItem:_initItemMsg(  )
    local txtBtnItem_CellLevelSprintPanel = GetElement(self.m_root,"txtBtnItem_CellLevelSprintPanel",WZUILabelTTF)
    txtBtnItem_CellLevelSprintPanel:setText(LocalStrings.ACTIVE_BTN_GET)

    local btnItemGetReward_CellLevelSprint = GetElement(self.m_root,"btnItemGetReward_CellLevelSprint",WZUIButton)
    if btnItemGetReward_CellLevelSprint == nil then
        return
    end
    if -1==tonumber(self.status) or tonumber(self.status)==1 then
        btnItemGetReward_CellLevelSprint:setTouchEnable(false)
        if tonumber(self.status)==1 then 
            btnItemGetReward_CellLevelSprint:setVisible(false)
            txtBtnItem_CellLevelSprintPanel:setVisible(false)
            self:_setImageIcon()
        end
        txtBtnItem_CellLevelSprintPanel:setEnableStroke(true)
        txtBtnItem_CellLevelSprintPanel:setStrokeSize(4)
        if tonumber(self.status)==1 then
            txtBtnItem_CellLevelSprintPanel:setStrokeColor(GlobalMethod:ccc3(0,108,3))
            txtBtnItem_CellLevelSprintPanel:setColor(GlobalMethod:ccc3(255,250,236))
        else
            txtBtnItem_CellLevelSprintPanel:setStrokeColor(GlobalMethod:ccc3(80,61,50))
            txtBtnItem_CellLevelSprintPanel:setColor(GlobalMethod:ccc3(255,255,255))
        end        
    elseif tonumber(self.status)==0 then
        btnItemGetReward_CellLevelSprint:setTouchEnable(true)
    end

    local ItemNameContainer_Obj = GetElement(self.m_root,"ItemNameContainer_Obj",WZUIContainer)
    if ItemNameContainer_Obj == nil then 
        return 
    end 
    
    local str_info = string.format(LocalStrings.ACTIVITY_SHOW_LEVEL,self.target)
    local title_info_1 = self:createTTF(str_info,GlobalMethod:ccp(0.02,0.5),GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(127,70,26))
    local wordCount = title_info_1:getWordCount()
    ItemNameContainer_Obj:addChild(title_info_1, 0, 88)
    local pos = wordCount*22 + 4 
    local title_info_2 = self:createTTF(LocalStrings.ACTIVITY_BIG_GIFTPACKS,GlobalMethod:ccp(pos/486,0.5),GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(229,105,22))
    ItemNameContainer_Obj:addChild(title_info_2,0,89)
end


--@breif    取一个数的整数部分
function CellLevelSprintPanelItem:_getIntPart(x)
    if x <= 0 then
        return math.ceil(x)
    end
    if math.ceil(x) == x then
        x = math.ceil(x)
    else
        x = math.ceil(x) - 1
    end
    return x
end

--@brief    奖励获取成功回调  
function CellLevelSprintPanelItem:_GetRewardOk(  )
    WZLog("CellLevelSprintPanelItem:_GetRewardOk")
    if CellLevelSprintPanelItem.m_current_click.m_root == nil then return end
    local btnItemGetReward_CellLevelSprint = GetElement(CellLevelSprintPanelItem.m_current_click.m_root,"btnItemGetReward_CellLevelSprint",WZUIButton)
    if btnItemGetReward_CellLevelSprint == nil then
        WZLog("btnItemGetReward_CellLevelSprint is nil")
        return
    end
    --btnItemGetReward_CellLevelSprint:setTouchEnable(false)
    local txtBtnItem_CellLevelSprintPanel = GetElement(CellLevelSprintPanelItem.m_current_click.m_root,"txtBtnItem_CellLevelSprintPanel",WZUILabelTTF)
    --txtBtnItem_CellLevelSprintPanel:setText(LocalStrings.ACTIVE_GET)

    btnItemGetReward_CellLevelSprint:setVisible(false)
    txtBtnItem_CellLevelSprintPanel:setVisible(false)
    CellLevelSprintPanelItem.m_current_click:_setImageIcon()
    if CellLevelSprintPanelItem.m_current_click.m_FuncCallback ~= nil then 
        local tluaObj = CellLevelSprintPanelItem.m_current_click.m_tCallBackLuaObjMap[CellLevelSprintPanelItem.m_current_click.m_FuncCallback]
        CellLevelSprintPanelItem.m_current_click.m_FuncCallback(tluaObj,CellLevelSprintPanelItem.m_current_click.rewardId)
    end
end


--@brief    显示奖励图标
function CellLevelSprintPanelItem:_setRewardList(  )
    local ItemCount = #self.m_tData
    for i=1,ItemCount do
        local img_con_Item = GetElement(self.m_root,"ConItem_"..i,WZUIContainer)
        local key = "id_"..self.m_tData[i].id
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
           
            local itemInfo = {id = self.m_tData[i].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tData[i].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tLuaObj:setCellGoodItem(itemInfo,4)
            tLuaObj:clearItemQualityPic()
            celElement:setScale(0.90)
            celElement:setTag(i-1)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
        end
        img_con_Item:addChild(celElement)

    end
end

--@brief    其它Item点击回调
function CellLevelSprintPanelItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellLevelSprintPanel.m_current.m_root,1,tData,false)
end

function CellLevelSprintPanelItem:_setImageIcon(  )
   
    local img_GetReward = WZUIImage:create()
    img_GetReward = WZUIImage:luaTo(img_GetReward)
    img_GetReward:setFile("ui/common/commom_icon_ylq.png")
    img_GetReward:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    img_GetReward:setUseOriginSize(true)
    img_GetReward:setRotation(28)
    local conBtn_CellLevelSprintPanelItem = GetElement(self.m_root,"conBtn_CellLevelSprintPanelItem",WZUIContainer)
    conBtn_CellLevelSprintPanelItem:addChild(img_GetReward, 0, 888)
end


function CellLevelSprintPanelItem:createTTF(desc,pt,anchor,font,Align,color)
    desc = desc or ""
    font = font or 22
    color = color or GlobalMethod:ccc3(255,227,116)
    Align = Align or kCCTextAlignmentLeft
    anchor = anchor or GlobalMethod:ccp(0,0.5)
    pt = pt or GlobalMethod:ccp(0,0.5)
    local txt = WZUILabelTTF:create()
    txt:setFontSize(font)
    txt:setColor(color)
    txt:setText(desc)
    txt:setBoldFont(false)
    txt:setTouchEnable(false)
    txt:setAlignment(Align)
    txt:setAnchorPoint(anchor)
    txt:setRelativePosition(pt)
    return txt
end
-------------------------------------私有方法模块End----------------------------------------
function CellLevelSprintPanelItem:_adaptLanguage_pt(  )
end

function CellLevelSprintPanelItem:_adaptLanguage_th(  )
end

function CellLevelSprintPanelItem:_adaptLanguage_en(  )
end