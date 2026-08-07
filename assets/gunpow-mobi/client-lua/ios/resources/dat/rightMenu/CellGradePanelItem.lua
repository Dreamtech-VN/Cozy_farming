--CellGradePanelItem.lua
--@brief    CellGradePanelItem的UI模块
--@date     2014/12/03
--@author   wuweidong
--@note     限时登录子选项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function CellGradePanelItem:onEnter(element)
    self.m_root = element
end

--@brief onEnter函数执行完成回调
function CellGradePanelItem:onEnterTransitionDidFinish(element)
  self.m_root:enableSchedule("scheduleUpdateTime", 1.0)
   
end

--@brief 定时器
function CellGradePanelItem:scheduleUpdateTime(element, data)
    if self.m_bIsLoad == false then return end
   if self.b_needCountDown then 
        --WZLog("tag=="..self.tag)
        local txt_button_item = GetElement(self.m_root,"txt_button_item",WZUILabelTTF)
        if self.nTime == 0 then 
            self.b_needCountDown = false 
            txt_button_item:setText(LocalStrings.ACTIVE_BTN_GET)
            self.b_canSendProtocol = true
            txt_button_item:setFontSize(24)
            txt_button_item:setStrokeColor(GlobalMethod:ccc3(0,72,3))
            local btn_item_getReward = GetElement(self.m_root,"btn_item_getReward",WZUIButton)
            btn_item_getReward:setVisible(true)
            if self.nType==1 then 
                if self.m_cellItemObj then 
                    self.m_cellItemObj:AddRedDot()
                end
                ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(106)
            end 
        else
            self.nTime = self.nTime - 1
            local hour = self.nTime/3600
            hour = math.floor(hour)
            local min = (self.nTime-hour*3600)/60
            min = math.floor(min)
            local sec = self.nTime%60
            local TimeStr = string.format("%02d:%02d:%02d",hour,min,sec)
            txt_button_item:setText(TimeStr)
            txt_button_item:setStrokeColor(GlobalMethod:ccc3(0,72,3))
        end 
   end 
end


--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function CellGradePanelItem:onExit(element)
    self.m_root:disableSchedule()
    self:_unInit()
end


--@brief    显示内容
function CellGradePanelItem:ShowCellItem( )
    self:_initItemMessage()
end

--@brief    事件回调
function CellGradePanelItem:event_getReward(  )
    WZLog("CellGradePanelItem:event_getReward")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.nType==1 and  not self.b_canSendProtocol then 
        MsgBoxManager:showTipBox(LocalStrings.TIME_NOT_UP)
    elseif  self.nType==1 and self.b_canSendProtocol then
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        self.m_nloadingId = MsgBoxManager:showLoadingBox()
        CellGradePanelItem.m_current_click = self
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId,self.rewardId)
    elseif  self.nType==0 then  
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        CellGradePanelItem.m_current_click = self
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId,self.rewardId)
    elseif  self.nType==2 then  
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        CellGradePanelItem.m_current_click = self
        ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_nActivityId,self.rewardId)
    end 
end

--@brief    礼包回调
function CellGradePanelItem:BtnDoneEvent()
    WZLog("CellGradePanelItem:BtnDoneEvent()::"..self.tag)
    local positionX,movepositionX = 0
    if self.nType==1 then 
        positionX,movepositionX = CellLoginActivityPanel:getFreeListPositionX()
    end 
    local wndtotalrewardlist,tLua = WndTotalRewardList:createElement()
    local tItemId = {}
    local tItemNum = {} 
    for i=1,#self.m_tData do
        table.insert(tItemId,self.m_tData[i].id)
        table.insert(tItemNum,self.m_tData[i].num)
    end
    if wndtotalrewardlist ~= nil then
        WindowManager:addWindow(wndtotalrewardlist, WndTotalRewardList)
        --0.825
        local ItemTag = (positionX-movepositionX)/140
        ItemTag = math.floor(ItemTag)
        local ItemTagCache = ItemTag
        ItemTag = self.tag-ItemTag-1
        local MoveDistance = (positionX-movepositionX)%140
        local moveCellItem = 0.1*(MoveDistance/37)
        local OrginX = 1.0
        if self.nType==1 then
            OrginX = 0.9 
        end 
        if ((self.tag-ItemTagCache)==1 or (((self.tag-ItemTagCache)==2) and MoveDistance>30)) then
            tLua:_setItemListForActivity(tItemId,tItemNum,OrginX-moveCellItem+ItemTag*0.375,#self.m_tData,false,0,self.nType)
        else
            OrginX = OrginX - 1.3
            tLua:_setItemListForActivity(tItemId,tItemNum,OrginX-moveCellItem+ItemTag*0.375,#self.m_tData,false,0,self.nType)
        end
    end
end

--@brief    设置剩余时长
function CellGradePanelItem:setTime( nTime )
    self.nTime = nTime
end

--@brief    加载cell数据信息
function CellGradePanelItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellGradePanelItem")
    self.m_root:addChild(cellElement)

    self.m_bIsLoad = true
    self:ShowCellItem()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief   刷新面板内容
function CellGradePanelItem:_initItemMessage()
    WZLog("CellGradePanelItem:_initItemMessage",self.Parameters1)
    local txt_grade_value = GetElement(self.m_root,"txt_grade_value",WZUILabelTTF)
    if txt_grade_value == nil then
        return
    end
    if self.nType == 1 then
        txt_grade_value:setText(self.Parameters1)
        GetElement(self.m_root, "txtDays_CellGradePanelItem", WZUILabelTTF):setVisible(false)
    else
        txt_grade_value:setText(LocalStrings.TOTAL_COUNT)
        GetElement(self.m_root, "txtDays_CellGradePanelItem", WZUILabelTTF):setText(" " .. self.Parameters1 .. " ")
    end
    local btn_item_getReward = GetElement(self.m_root,"btn_item_getReward",WZUIButton)
    if btn_item_getReward == nil then
        return
    end
    local txt_button_item = GetElement(self.m_root,"txt_button_item",WZUILabelTTF)
    txt_button_item:setText(LocalStrings.ACTIVE_BTN_GET)
    
    if self.nType==1 then 
        btn_item_getReward:setVisible(true)
        WZLog("button state="..tonumber(self.Parameters3))

        if -1 == tonumber(self.Parameters3) and (self.nTime <= 0) then 
            btn_item_getReward:setTouchEnable(false)
            txt_button_item:setText(LocalStrings.ACTIVE_BTN_GET)
            self.b_canSendProtocol = false 
            txt_button_item:setEnableStroke(true)
            txt_button_item:setStrokeSize(4)
            txt_button_item:setStrokeColor(GlobalMethod:ccc3(79,60,48))
            txt_button_item:setColor(GlobalMethod:ccc3(255,255,255))
        elseif -1 == tonumber(self.Parameters3) and (self.nTime>0) then 
            local hour = self.nTime/3600
            hour = math.floor(hour)
            local min = (self.nTime-hour*3600)/60
            min = math.floor(min)
            local sec = self.nTime%60
            local TimeStr = string.format("%02d:%02d:%02d",hour,min,sec)
            txt_button_item:setText(TimeStr)
            txt_button_item:setFontSize(24)
            self.b_canSendProtocol = false
            self.b_needCountDown = true
            btn_item_getReward:setVisible(true)
        elseif 0 == tonumber(self.Parameters3) then 
            self.b_canSendProtocol = true
            btn_item_getReward:setTouchEnable(true)
        elseif 1 == tonumber(self.Parameters3) then 
            self.b_canSendProtocol = false
            txt_button_item:setVisible(false)
            btn_item_getReward:setVisible(false)
            self:_ShowGetRewarded()
        elseif tonumber(self.Parameters3) == 2 then
            txt_button_item:setStrokeColor(GlobalMethod:ccc3(79,60,48))
            txt_button_item:setColor(GlobalMethod:ccc3(255,255,255))
            btn_item_getReward:setTouchEnable(false)
            txt_button_item:setText(LocalStrings.MONTH_CARDS_TIP6)
        end 
        if btn_item_getReward:getTouchEnable() then 
            txt_button_item:setStrokeColor(GlobalMethod:ccc3(0,72,3))
        end 
	elseif self.nType == 2 then
        if tonumber(self.Parameters3) == -1 then
            btn_item_getReward:setTouchEnable(false)
            btn_item_getReward:setVisible(false)
			GetElement(self.m_root,"txtCant",WZUILabelTTF):setVisible(true)
            txt_button_item:setStrokeColor(GlobalMethod:ccc3(79,60,48))
            txt_button_item:setColor(GlobalMethod:ccc3(255,255,255))
            self.b_canSendProtocol = false
        elseif tonumber(self.Parameters3) == 0 then
            self.b_canSendProtocol = true
            btn_item_getReward:setTouchEnable(true)
        elseif tonumber(self.Parameters3) == 1 then
            self.b_canSendProtocol = false
            btn_item_getReward:setVisible(false)
            txt_button_item:setVisible(false)
            self:_ShowGetRewarded()
        end
    else
        if tonumber(self.Parameters3) == -1 then
            btn_item_getReward:setTouchEnable(false)
            txt_button_item:setStrokeColor(GlobalMethod:ccc3(79,60,48))
            txt_button_item:setColor(GlobalMethod:ccc3(255,255,255))
            self.b_canSendProtocol = false
        elseif tonumber(self.Parameters3) == 0 then
            self.b_canSendProtocol = true
            btn_item_getReward:setTouchEnable(true)
        elseif tonumber(self.Parameters3) == 1 then
            self.b_canSendProtocol = false
            btn_item_getReward:setVisible(false)
            txt_button_item:setVisible(false)
            self:_ShowGetRewarded()
        end
    end

    WZLog("*********** self.nType **********", self.nType,#self.m_tData)
    local nItemCount = 1
    for idx=1,#self.m_tData do
        if self.m_tData[idx].id ~= -1 then
            local key = "id_"..self.m_tData[idx].id
            local tTempItem = GDatatab_item[key]
            if tTempItem ~= nil then
                local ConItem = GetElement(self.m_root,"ConItem_"..nItemCount,WZUIContainer)
                local celElement,tLuaObj = CellGoodItem:createElement()
                if ConItem ~= nil and celElement ~= nil then 
                    celElement = WZUIContainer:luaTo(celElement)
                --    WZLog("key="..key)
                    local itemInfo = {id = self.m_tData[idx].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tData[idx].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                    tLuaObj:setCellGoodItem(itemInfo,16)
                    celElement:setTag(idx-1)
                    tLuaObj:setItemClickFun(self,self.onOthersClick)
                    ConItem:addChild(celElement)
                end
                nItemCount = nItemCount + 1
            end
        end
    end
    AdaptLanguage(self)
end

--@brief    其它Item点击回调
function CellGradePanelItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    if self.nType == 1 then
        WndItemInfo:showInfo(luaTable.m_root,CellLoginActivityPanel.m_current.m_root,1,tData,false)
    elseif self.nType == 0 then
        WndItemInfo:showInfo(luaTable.m_root,CellTotalLoginPanel.m_current.m_root,1,tData,false)
    elseif self.nType == 2 then
        WndItemInfo:showInfo(luaTable.m_root,CellNewTotalLogin.m_current.m_root,1,tData,false)
    end
end
--@brief    奖励获取成功回调  
function CellGradePanelItem:_GetRewardOk()
    local btn_item_getReward = GetElement(self.m_root,"btn_item_getReward",WZUIButton)
    if btn_item_getReward == nil then
        WZLog("btn_item_getReward is nil")
        return
    end
    btn_item_getReward:setTouchEnable(false)
    WZLog("CellGradePanelItem:_GetRewardOk")
    local txt_button_item = GetElement(self.m_root,"txt_button_item",WZUILabelTTF)
    txt_button_item:setText(LocalStrings.ACTIVE_GET)

    txt_button_item:setVisible(false)
    btn_item_getReward:setVisible(false)
    self:_ShowGetRewarded()
    if self.m_FuncCallback ~= nil then 
        local tluaObj = self.m_tCallBackLuaObjMap[self.m_FuncCallback]
        self.m_FuncCallback(tluaObj,self.rewardId)
    end
end


function CellGradePanelItem:_ShowGetRewarded(  )
    WZLog("********* CellGradePanelItem:_ShowGetRewarded ***********")
    local img_GetReward = WZUIImage:create()
    img_GetReward = WZUIImage:luaTo(img_GetReward)
    img_GetReward:setFile("ui/common/commom_icon_ylq.png")
    img_GetReward:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    img_GetReward:setUseOriginSize(true)
    img_GetReward:setRotation(28)
    local conBtn_CellGradePanelItem = GetElement(self.m_root,"conBtn_CellGradePanelItem",WZUIContainer)
    conBtn_CellGradePanelItem:addChild(img_GetReward, 0, 888)
    -- local txt = WZUILabelTTF:create()
    -- txt:setFontSize(24)
    -- txt:setColor(GlobalMethod:ccc3(158,129,121))
    -- txt:setText(LocalStrings.ACTIVE_GET)
    -- txt:setBoldFont(false)
    -- txt:setEnableStroke(false)
    -- txt:setStrokeColor(GlobalMethod:ccc3(158,129,121))
    -- txt:setStrokeSize(4)
    -- txt:setTouchEnable(false)
    -- txt:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    -- txt:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    -- local conBtn_CellGradePanelItem = GetElement(self.m_root,"conBtn_CellGradePanelItem",WZUIContainer)
    -- conBtn_CellGradePanelItem:addChild(txt, 0, 888)
    WZLog("********* CellGradePanelItem:_ShowGetRewarded  END***********")
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------
function CellGradePanelItem:_adaptLanguage_vn()
    WZLog("CellGradePanelItem:_adaptLanguage_vn ")
    local txtDays = GetElement(self.m_root,"txtDays_CellGradePanelItem",WZUILabelTTF)
    txtDays:setRelativePosition(GlobalMethod:ccp(0.162917,0.5))
end

function CellGradePanelItem:_adaptLanguage_tr(  )
    local txtDays = GetElement(self.m_root,"txtDays_CellGradePanelItem",WZUILabelTTF)
    txtDays:setRelativePosition(GlobalMethod:ccp(0.162917,0.5))
end

function CellGradePanelItem:_adaptLanguage_pt()
    local txtDays = GetElement(self.m_root,"txt_button_item",WZUILabelTTF)
    txtDays:setFontSize(20)

    local ImgArrow = GetElement(self.m_root,"ImgArrow_CellGradePanelItem",WZUIImage)
    ImgArrow:setRelativePosition(GlobalMethod:ccp(0.68,0.5))
end

function CellGradePanelItem:_adaptLanguage_es()
    local txtGrade = GetElement(self.m_root,"txtGrade_CellGradePanelItem",WZUILabelTTF)
    txtGrade:setRelativePosition(GlobalMethod:ccp(1.8,0.5))
    local txtDays = GetElement(self.m_root,"txtDays_CellGradePanelItem",WZUILabelTTF)
    txtDays:setRelativePosition(GlobalMethod:ccp(0.25,0.5))
end
-------------------------------------语言适配模块End----------------------------------------
