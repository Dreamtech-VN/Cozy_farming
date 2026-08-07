--WndExchangeExp.lua
--@brief	WndExchangeExp的UI模块
--@date		2016/12/06
--@author	Tianxiang_Xu
--@note		兑换经验窗口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndExchangeExp:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndExchangeExp:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndExchangeExp:onEnterTransitionDidFinish( element )
    -- body
    self.m_nGainId = tonumber(CacheCenter:getGameParam()["overflowExpExchangeGainItemId"])

    self:_createLoading()
    ProtocolProcessorRecycling:send_PLAYERITEM_GetOverflowedExpExchange( )
end

--@brief    点击快速转化按钮回调
function WndExchangeExp:onClickQuick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tCostData = GDatatab_item["id_318"]
    local tGainData = GDatatab_item["id_" .. self.m_nGainId]
    if self.m_nCurSpillExp < self.m_nCostExp then
        MsgBoxManager:showTipBox(string.format(LocalStrings.EXCHANGEEXP_TEXT6, tCostData.name, tGainData.name))
        return 
    end

    local sAttContent = string.format(LocalStrings.EXCHANGEEXP_TEXT7, self.m_nTotalCostExp, tCostData.name, self.m_nTotalGainRewards, tGainData.name)
    MsgBoxManager:showConfirmBox(sAttContent, self, self.onSure)
end

--@brief    点击转化按钮回调
function WndExchangeExp:onClickOne(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_nCurSpillExp < self.m_nCostExp then
        local tCostData = GDatatab_item["id_318"]
        local tGainData = GDatatab_item["id_" .. self.m_nGainId]

        MsgBoxManager:showTipBox(string.format(LocalStrings.EXCHANGEEXP_TEXT6, tCostData.name, tGainData.name))
        return 
    end

    self:_createLoading()
    ProtocolProcessorRecycling:send_PLAYERITEM_ExchangeExp(0)
end

--@brief    点击规则按钮回调
function WndExchangeExp:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WndSingleMapDesc:showInterface1(LocalStrings.EXCHANGEEXP_TEXT9)
end

--@brief    点击关闭按钮回调
function WndExchangeExp:onClickClose(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    
    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    确认快速转化
function WndExchangeExp:onSure()
    -- body
    self:_createLoading()
    ProtocolProcessorRecycling:send_PLAYERITEM_ExchangeExp(1)
end
----------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新显示
function WndExchangeExp:_update()
    -- body
    self:_setStaticText()
end
--@brief    设置文本内容
function WndExchangeExp:_setStaticText()
    --body
    --当前溢出的经验
    local txtSpillExp = GetElement(self.m_root, "txtSpillExp_WndExchangeExp", WZUILabelTTF)
    if txtSpillExp then
        if self.m_nCurSpillExp == nil then
            self.m_nCurSpillExp = 0 
        end
        txtSpillExp:setText(string.format(LocalStrings.EXCHANGEEXP_TEXT4, self.m_nCurSpillExp))
    end
    --第几次转化
    local txtExchangeTimes = GetElement(self.m_root, "txtExchangeTimes_WndExchangeExp", WZUILabelTTF)
    if txtExchangeTimes then
        if self.m_nExchangeTimes == nil then
            self.m_nExchangeTimes = 1
        end
        txtExchangeTimes:setText(string.format(LocalStrings.EXCHANGEEXP_TEXT5, self.m_nExchangeTimes + 1))
    end
    --消耗
    local txtCostNum = GetElement(self.m_root, "txtCostNum_WndExchangeExp", WZUILabelTTF)
    if txtCostNum then
        if self.m_nCostExp == nil then
            self.m_nCostExp = 0
        end
        txtCostNum:setText(self.m_nCostExp)
    end
    --获得
    local txtGainNum = GetElement(self.m_root, "txtGainNum_WndExchangeExp", WZUILabelTTF)
    if txtGainNum then
        if self.m_nGainRewards == nil then
            self.m_nGainRewards = 0
        end
        txtGainNum:setText(self.m_nGainRewards)
    end

    --消耗图标
    local tCostData = GDatatab_item["id_318"]
    if tCostData then
        local imgCostIcon = GetElement(self.m_root, "imgCostIcon_WndExchangeExp", WZUIImage)
        if imgCostIcon then
            imgCostIcon:setFile(tCostData.icon)
        end
    end
    --获得图标
    local tGainData = GDatatab_item["id_" .. self.m_nGainId]
    if tGainData then
        local imgGainIcon = GetElement(self.m_root, "imgGainIcon_WndExchangeExp", WZUIImage)
        if imgGainIcon then
            imgGainIcon:setFile(tGainData.icon)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin------------------------------------------
function WndExchangeExp:_adaptLanguage_en(  )
    local txtQuite = GetElement(self.m_root,"txtQuite_WndExchangeExp",WZUILabelTTF)
    txtQuite:setDimensions(GlobalMethod:CCSize(100,0))
    txtQuite:setFontSize(20)
end

function WndExchangeExp:_adaptLanguage_vn(  )
    local txtQuite = GetElement(self.m_root,"txtQuite_WndExchangeExp",WZUILabelTTF)
    txtQuite:setDimensions(GlobalMethod:CCSize(100,0))
    txtQuite:setFontSize(18)
end

function WndExchangeExp:_adaptLanguage_es(  )
    local txtQuite = GetElement(self.m_root,"txtQuite_WndExchangeExp",WZUILabelTTF)
    txtQuite:setDimensions(GlobalMethod:CCSize(100,0))
    txtQuite:setFontSize(18)

    local txtComfire = GetElement(self.m_root,"txtComfire_WndExchangeExp",WZUILabelTTF)
    txtComfire:setFontSize(18)
end

function WndExchangeExp:_adaptLanguage_tr(  )
    local txtQuite = GetElement(self.m_root,"txtQuite_WndExchangeExp",WZUILabelTTF)
    txtQuite:setDimensions(GlobalMethod:CCSize(120,0))
    txtQuite:setScale(0.7)
end

function WndExchangeExp:_adaptLanguage_pt(  )
    local txtQuite = GetElement(self.m_root,"txtQuite_WndExchangeExp",WZUILabelTTF)
    txtQuite:setDimensions(GlobalMethod:CCSize(140,0))
    txtQuite:setScale(0.7)
end
-------------------------------------语言适配End--------------------------------------------