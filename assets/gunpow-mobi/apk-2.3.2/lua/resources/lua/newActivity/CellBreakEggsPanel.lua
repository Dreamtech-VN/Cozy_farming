--CellBreakEggsPanel.lua
--@brief	CellBreakEggsPanel的UI模块
--@date		2017/08/23
--@author	Tianxiang_Xu
--@note		砸金蛋活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellBreakEggsPanel:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellBreakEggsPanel:onExit(element)
	self:_unInit()
end

--@brief    点击奖励预览按钮回调
function CellBreakEggsPanel:onClickReward(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndGoodsFull:showInterface(2)
    local tIdList = {}
    local tempEgg = GDatatab_egg
    for i, v in pairs(tempEgg) do
        table.insert(tIdList, v.item_id[1][1])
    end

    local itemTemp  = GDatatab_item

    local function getQuality(a)
        -- body
        return itemTemp["id_" .. a].quality
    end
    table.sort(tIdList, function (a,b)
        -- body
        local qualityA = getQuality(a)
        local qualityB = getQuality(b)
        if qualityA ~= qualityB then 
            return qualityA < qualityB
        else
            return a < b
        end
    end)
    WndGoodsFull:initRewardList(tIdList)
end

--@brief    显示信息
function CellBreakEggsPanel:showWindow()
    -- body
    if self.m_root == nil then return end 
    
    local txtCurWord = GetElement(self.m_root, "txtCurWord_CellBreakEggsPanel", WZUILabelTTF)
    if txtCurWord then
        txtCurWord:setText(LocalStrings.ACTIVITY_PREPAID_PHONE .. ":")
    end
    
    self:_showTime()
    self:_showCurRechargeInfo()
    self:_showAttAndHummerNum()
    self:_showEggsList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    展示广告图
function CellBreakEggsPanel:_showBK()
    -- body
    local imgBK = GetElement(self.m_root, "imgBK_CellBreakEggsPanel", WZUIImage)
    if imgBK then  
        if self.m_content then
            WZTempLog("self.m_content.....", self.m_content)
            local nStart, nEnd = string.find(self.m_content, ".png")
            if nStart then
                imgBK:setFile(self.m_content)
            end
        end
    end
end
--@brief    显示活动时间
function CellBreakEggsPanel:_showTime()
    -- body
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellBreakEggsPanel", WZUILabelTTF)
    if txtTimeWord then 
        txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    local txtTime = GetElement(self.m_root, "txtTime_CellBreakEggsPanel", WZUILabelTTF)
    if txtTime then 
        local sStartDate = os.date("*t", self.m_nStartTime)
        local sEndDate = os.date("*t", self.m_nEndTime)
        txtTime:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, sStartDate.month, sStartDate.day, sStartDate.hour, sStartDate.min, sEndDate.month, sEndDate.day, sEndDate.hour, sEndDate.min))
    end
end

--@brief    设置当前充值信息
function CellBreakEggsPanel:_showCurRechargeInfo()
    -- body
    --当前充值进度
    local prgCurRecharge = GetElement(self.m_root, "prgCurRecharge_CellBreakEggsPanel", WZUIProgress)
    if prgCurRecharge then 
        prgCurRecharge:setPercentage(math.floor(100 * math.fmod(self.m_nTotalDiamond, self.m_needDiamond)/self.m_needDiamond))
    end
    --进度数字
    local txtCurValue = GetElement(self.m_root, "txtCurValue_CellBreakEggsPanel", WZUILabelTTF)
    if txtCurValue then 
        txtCurValue:setText(math.fmod(self.m_nTotalDiamond, self.m_needDiamond) .. "/" .. self.m_needDiamond)
    end
    --充值概况
    local ftxtInfo = GetElement(self.m_root, "ftxtInfo_CellBreakEggsPanel", WZUIFreeTextBox)
    if ftxtInfo then
        ftxtInfo:setShowText(string.format(LocalStrings.NEWACTIVITY_TEXT1, self.m_needDiamond, self.m_nTotalDiamond))
    end
end

--@brief    显示提示文字和锤子的数目
function CellBreakEggsPanel:_showAttAndHummerNum()
    -- body
    local txtBreakAtt = GetElement(self.m_root, "txtBreakAtt_CellBreakEggsPanel", WZUILabelTTF)
    if txtBreakAtt then 
        local nBreakTimes = self:getBreakTimes()
        if math.fmod(nBreakTimes, 3) == 0 then 
            txtBreakAtt:setVisible(true)
            txtBreakAtt:setText(LocalStrings.NEWACTIVITY_TEXT5)
        else
            txtBreakAtt:setVisible(false)
        end
    end
    --锤子数目
    local ftxtHammerNum = GetElement(self.m_root, "ftxtHammerNum_CellBreakEggsPanel", WZUIFreeTextBox)
    if ftxtHammerNum then 
        ftxtHammerNum:setShowText(string.format(LocalStrings.NEWACTIVITY_TEXT4, self.m_nHummerNum))
    end
end

--@brief    显示金蛋
function CellBreakEggsPanel:_showEggsList()
    -- body
    local tableEggsList = GetElement(self.m_root, "tableEggsList_CellBreakEggsPanel", WZUITableContainer)
    if tableEggsList then
        tableEggsList:cleanTable()
    end

    self.m_tEggsCell = {}
    if self.m_tRewardId then
        for i = 1, #self.m_tRewardId do
            local tData = {}
            tData.rewardId = self.m_tRewardId[i]
            tData.state = self.m_tStatus[i]

            local element, tNewObj = CellBreakEggsItem:createElement()
            if element and tNewObj then 
                element:setTag(i - 1)
                tNewObj:setData(tData, self.m_nActivityId)

                tableEggsList:setCellElement(element)
                table.insert(self.m_tEggsCell, tNewObj)
            end
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellBreakEggsPanel:_adaptLanguage_vn(  )
    GetElement(self.m_root, "txtTime_CellBreakEggsPanel", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
end
function CellBreakEggsPanel:_adaptLanguage_pt(  )
    local ftxtInfo = GetElement(self.m_root, "ftxtInfo_CellBreakEggsPanel", WZUIFreeTextBox)
    if ftxtInfo then
        ftxtInfo:setScale(0.8)
        ftxtInfo:setMaxWidth(800)
    end
end
function CellBreakEggsPanel:_adaptLanguage_es(  )
    local ftxtInfo = GetElement(self.m_root, "ftxtInfo_CellBreakEggsPanel", WZUIFreeTextBox)
    if ftxtInfo then
        ftxtInfo:setScale(0.8)
        ftxtInfo:setMaxWidth(800)
    end
end
function CellBreakEggsPanel:_adaptLanguage_en(  )
    local ftxtInfo = GetElement(self.m_root, "ftxtInfo_CellBreakEggsPanel", WZUIFreeTextBox)
    if ftxtInfo then
        ftxtInfo:setScale(0.8)
        ftxtInfo:setMaxWidth(800)
    end
end
---------------------------------------语言适配End------------------------------------------