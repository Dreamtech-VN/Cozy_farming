--CellTabooBox.lua
--@brief	CellTabooBox的UI模块
--@date		2017/04/21
--@note		card


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTabooBox:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTabooBox:onExit(element)
	self:_unInit()
end


--@brief	点击按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellTabooBox:onBtnBoxClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndTabooBoxOpen:show(self.m_tData,1)
end

--@brief    点击按钮时被调用的函数
--@param    element:按钮绑定的UI节点引用
function CellTabooBox:onBtnCancelClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    MsgBoxManager:showConfirmCancelBox(LocalStrings.TABOO_BOX_DISCARD, self, self.discardBox, nil, nil)
end

--@brief   丢弃宝箱
function CellTabooBox:discardBox(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
       ProtocolProcessorTaboo:send_ZONE_ChoiceBox(5, self.m_tData.boxIndex)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function CellTabooBox:_update()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    self:_updateState()
    -- self.m_tData.boxIndex
    -- self.m_tData.boxCountdown
end

--@brief 状态刷新
function CellTabooBox:_updateState()
    self:_setCountDown(false)
    --无宝箱
    if not self.m_tData or self.m_tData.boxStatus == 0 then
        GetElement(self.m_root,"conInfoView_CellTabooBox",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"txtEmptySlots_CellTabooBox",WZUILabelTTF):setVisible(true)
        return
    end

    GetElement(self.m_root,"conInfoView_CellTabooBox",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"txtEmptySlots_CellTabooBox",WZUILabelTTF):setVisible(false)
    local conOpen = GetElement(self.m_root,"conOpen_CellTabooBox",WZUIContainer)
    local conTime = GetElement(self.m_root,"conTime_CellTabooBox",WZUIContainer)
    local conGet = GetElement(self.m_root,"conGet_CellTabooBox",WZUIContainer)
    local cancel = GetElement(self.m_root,"cancelBtn_CellTabooBox",WZUIButton)
    conOpen:setVisible(false)
    conTime:setVisible(false)
    conGet:setVisible(false)
    cancel:setVisible(true)
    self.m_nLeftTime = nil

    --消耗图标
    local imgCostIcon = GetElement(self.m_root, "imgCostIcon_CellTabooBox", WZUIImage)
    if imgCostIcon then
        if CacheCenter:getGameParam().isUseTicket == "0" then
            imgCostIcon:setFile(GDatatab_item["id_70"].icon)
        else
            imgCostIcon:setFile(GDatatab_item["id_1"].icon)
        end
        imgCostIcon:setScale(0.35)
    end
    
    if self.m_tData.boxStatus == 1 then
        --未解锁
        conOpen:setVisible(true)
    elseif self.m_tData.boxStatus == 2 then
        --正在解锁
        conTime:setVisible(true)
        self.m_nLeftTime = self.m_tData.boxCountdown
        self:_setCountDown(true)
    elseif self.m_tData.boxStatus == 3 then
        --可领取
        conGet:setVisible(true)
        cancel:setVisible(false)
    else
        GetElement(self.m_root,"conInfoView_CellTabooBox",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"txtEmptySlots_CellTabooBox",WZUILabelTTF):setVisible(true)
    end

    local template = GDatatab_item["id_"..self.m_tData.boxId]
    local imgPath = template.icon
    
    local img = GetElement(self.m_root,"imgBox_CellTabooBox",WZUIImage)
    img:setFile(imgPath)
end

function CellTabooBox:_setCountDown(value)
    if value == true then
        self.m_root:enableSchedule("_timeUpdate",0)
    else
        self.m_root:disableSchedule()
    end
    -- body
end

--@brief 时间
function CellTabooBox:_timeUpdate(element,dt)
    if self.m_nLeftTime then
        self.m_nLeftTime = self.m_nLeftTime - dt
        self.m_tData.boxCountdown = self.m_nLeftTime
        if self.m_nLeftTime > 0 then
            local sNextTime = returnToTimeFormat(math.floor(self.m_nLeftTime))
            GetElement(self.m_root,"labLeftTime_CellTabooBox",WZUILabelTTF):setText(sNextTime)

            local cost = tonumber(CacheCenter:getGameParam().boxOpenPricePerMin) * math.ceil(self.m_nLeftTime/60)
            GetElement(self.m_root,"labCost_CellTabooBox",WZUILabelTTF):setText(cost)
        else
           self.m_nLeftTime = nil
           self.m_root:disableSchedule()
           ProtocolProcessorTaboo:send_ZONE_GetBoxInfo()
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellTabooBox:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtOpen_CellTabooBox",WZUILabelTTF):setScale(0.8)
    
end

function CellTabooBox:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtOpen_CellTabooBox",WZUILabelTTF):setScale(0.75)
    GetElement(self.m_root,"txtGet_CellTabooBox",WZUILabelTTF):setScale(0.8)
end

function CellTabooBox:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtGet_CellTabooBox",WZUILabelTTF):setScale(0.8)
    local txtOpen = GetElement(self.m_root,"txtOpen_CellTabooBox",WZUILabelTTF)
    txtOpen:setDimensions(GlobalMethod:CCSize(130,0))
    txtOpen:setScale(0.7)
    GetElement(self.m_root,"txtEmptySlots_CellTabooBox",WZUILabelTTF):setScale(0.8)
end

function CellTabooBox:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtGet_CellTabooBox",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80))
    local txtOpen = GetElement(self.m_root,"txtOpen_CellTabooBox",WZUILabelTTF)
    txtOpen:setDimensions(GlobalMethod:CCSize(130,0))
    txtOpen:setScale(0.7)
    GetElement(self.m_root,"txtEmptySlots_CellTabooBox",WZUILabelTTF):setScale(0.8)
end

function CellTabooBox:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtGet_CellTabooBox",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(80))
    local txtOpen = GetElement(self.m_root,"txtOpen_CellTabooBox",WZUILabelTTF)
    txtOpen:setDimensions(GlobalMethod:CCSize(130,0))
    txtOpen:setScale(0.7)
    GetElement(self.m_root,"txtEmptySlots_CellTabooBox",WZUILabelTTF):setScale(0.8)
end
---------------------------------------语言适配End------------------------------------------
