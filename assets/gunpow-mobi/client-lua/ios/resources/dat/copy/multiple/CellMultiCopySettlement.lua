--CellMultiCopySettlement.lua
--@brief	CellMultiCopySettlement的UI模块
--@date		2015/05/22
--@author	xiaoyu_wu
--@note		多人副本结算单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMultiCopySettlement:onEnter(element)
	self.m_root = element
    self:_setUIStaticText()
    AdaptLanguage(self)
end

----@brief onEnter函数执行完成回调
function CellMultiCopySettlement:onEnterTransitionDidFinish(element)
    
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMultiCopySettlement:onExit(element)
	self:_unInit()
end

--@brief	设置延迟显示单元格时间
--@param    nDelayTime, 延迟时间
function CellMultiCopySettlement:setDelayDisplayTime(nDelayTime)
    if self.m_root then
        self.m_root:enableSchedule("scheduleDisplay", nDelayTime)
    end
end

--@brief	显示单元格定时器
--@param	element:定时器绑定的节点
--@param    delta:时间间隔
function CellMultiCopySettlement:scheduleDisplay(element, delta)
    element:disableSchedule()
    if self.m_root then
        local con = GetElement(self.m_root, "conSettlement_CellMultiCopySettlement", WZUIContainer)
        con:setVisible(true)

        local conPro = GetElement(self.m_root, "conPro_CellMultiCopySettlement", WZUIContainer)
        local conPro1 = GetElement(self.m_root, "conPro1_CellMultiCopySettlement", WZUIContainer)
        local act1 = CCScaleTo:create(0.2,1)
        conPro:runAction(act1)
        local actionArray = CCArray:create()
        local act1 = CCDelayTime:create(0.2)
        local act2 = CCScaleTo:create(0.2,1)
        actionArray:addObject(act1)
        actionArray:addObject(act2)
        local repH = CCSequence:create(actionArray)
        conPro1:runAction(repH)

        self.m_root:enableSchedule("animationFinished", 0.6)
    end
end

function CellMultiCopySettlement:animationFinished()
    WZLog("CellMultiCopySettlement:animationFinished")
    self.m_root:disableSchedule()

    if self.m_nAddExp == 0 then return end
    self.m_root:enableSchedule("scheduleUpdateExp",0.1)
    SoundManager:playEffectSound(SoundDefine.E_S_SETTLEMENT)
end

--@brief	更新经验条定时器
--@param	element:定时器绑定的节点
--@param    delta:时间间隔
function CellMultiCopySettlement:scheduleUpdateExp(element, delta)
    if self.m_root == nil then
        element:disableSchedule()
        return
    end
    WZLog("CellMultiCopySettlement:scheduleUpdateExp")
    local nMaxExp = GetMaxExpByLevel(self.m_nCurLevel)
    local snAdd =math.max(1, math.floor(self.m_nAddExp/20))
    local nAddExp = math.min(self.m_nAddExp-self.m_nCurAddExp, snAdd)
     WZLog("CellMultiCopySettlement:scheduleUpdateExp:", nAddExp)
     WZLog("CellMultiCopySettlement:scheduleUpdateExp:", snAdd, math.floor(self.m_nAddExp/20))
    self.m_nCurAddExp = self.m_nCurAddExp + nAddExp
    self.m_nCurExp = self.m_nCurExp + nAddExp

    WZLog("------------max level---------------------",GetPlayerMaxLevel())
    if self.m_nCurExp >= nMaxExp and self.m_nCurLevel < GetPlayerMaxLevel() then
        self.m_nCurLevel = self.m_nCurLevel + 1
        self.m_nCurExp = self.m_nCurExp - nMaxExp
        self:_showUpgrade()
        self:_updatePlayerLv()
        if self.m_nCurLevel == GetPlayerMaxLevel() then element:disableSchedule() end
    end
    self:_updateExpProgress()
    if self.m_nCurAddExp >= self.m_nAddExp then
        element:disableSchedule()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function CellMultiCopySettlement:_update()
    WZLog("CellMultiCopySettlement:_update")
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    self:_updateSettlement()
    self:_updatePlayerLv()
end

-- 更新玩家的名字和等级
function CellMultiCopySettlement:_updatePlayerLv()
    local txtName = GetElement(self.m_root, "txtPlayerName_CellMultiCopySettlement", WZUILabelTTF)
    local txtLv = GetElement(self.m_root, "txtPlayerLv_CellMultiCopySettlement", WZUILabelTTF)
    txtName:setText(self.m_tData.name)
    txtLv:setText("Lv"..self.m_nCurLevel)
    if self.m_tData.id == CacheCenter:getPlayerInfo().id then
        txtName:setColor(GlobalMethod:ccc3(99,255,95))
        txtLv:setColor(GlobalMethod:ccc3(99,255,95))
    else
        txtName:setColor(GlobalMethod:ccc3(255,236,193))
        txtLv:setColor(GlobalMethod:ccc3(255,236,193))
    end
end

--@brief	更新玩家结算信息
function CellMultiCopySettlement:_updateSettlement()
    WZLog("CellMultiCopySettlement:_updateSettlement")
    local conSettlement = GetElement(self.m_root, "conSettlement_CellMultiCopySettlement")
    conSettlement:setVisible(true)
    local nGold = 0
    local nExp = 0
    for i,v in ipairs(self.m_tData.reward) do
        if v.rewardId == 2 then --金币
            nGold = v.rewardCount
        elseif v.rewardId == 3 then --经验
            nExp = v.rewardCount
        end
    end
    WZLog("CellMultiCopySettlement:_updateSettlement:", nGold, nExp)
    local txtGold = GetElement(self.m_root, "txtGold_CellMultiCopySettlement", WZUILabelTTF)
    txtGold:setText(nGold)
    local txtExp = GetElement(self.m_root, "txtExp_CellMultiCopySettlement", WZUILabelTTF)
    txtExp:setText(nExp)

    local nMaxExp = GetMaxExpByLevel(self.m_tData.level)
    if self.m_tData.level == GetPlayerMaxLevel() and self.m_tData.exp + nExp >= nMaxExp then nExp = nMaxExp - self.m_tData.exp end
    WZLog("---------------------520520------------------",self.m_tData.level,GetPlayerMaxLevel(),nExp,type(GetPlayerMaxLevel()))
    self.m_nAddExp = nExp
    self.m_nCurAddExp = 0
    self.m_nCurLevel = self.m_tData.level
    self.m_nCurExp = self.m_tData.exp
    WZLog("WWW:", self.m_nAddExp, self.m_nCurExp)
    self:_updateExpProgress()

    -- 伤害
    local ftbStr = [[<T C="255,227,116" S="22" P="0">%s</T><T C="255,236,193" S="22" P="0">%s</T>]]
    local ftb = GetElement(self.m_root, "ftbHurt_CellMultiCopySettlement", WZUIFreeTextBox)
    ftb:setShowText(string.format(ftbStr,LocalStrings.HURT,self.m_tData.hurtNum.."%"))

--    local txtHurt = GetElement(self.m_root, "txtHurt_CellMultiCopySettlement", WZUILabelTTF)
--    txtHurt:setText(self.m_tData.hurtNum.."%")

    -- MVP
    if self.m_tData.mvp then
        local imgMvp = GetElement(self.m_root, "imgMvp_CellMultiCopySettlement", WZUIImage)
        imgMvp:setVisible(true)
    end
end

--@brief	显示升级
function CellMultiCopySettlement:_showUpgrade()
    local imgUpgrade = GetElement(self.m_root, "imgUpgrade_CellMultiCopySettlement")
    imgUpgrade:setVisible(true)
end

--@brief	更新经验值进度条
function CellMultiCopySettlement:_updateExpProgress()
    local nMaxExp = GetMaxExpByLevel(self.m_nCurLevel)
    local prg = GetElement(self.m_root, "prgExp_CellMultiCopySettlement", WZUIProgress)
    prg:setPercentage(math.min(self.m_nCurExp*100/nMaxExp, 100))

    local txtExp = GetElement(self.m_root, "prgTxt_CellMultiCopySettlement", WZUILabelTTF)
    txtExp:setText(self.m_nCurExp.."/"..nMaxExp)
    WZLog("-------------------104-----------------------",self.m_nCurExp,nMaxExp)
    
end

--@brief	设置控件静态文本
--@note		设置控件静态文本
function CellMultiCopySettlement:_setUIStaticText()
    local tNameMap = {
        
    }
    for i,v in ipairs(tNameMap) do
        local txt = GetElement(self.m_root, v[1], WZUILabelTTF)
        txt:setText(v[2])
    end
end

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配Begin------------------------------------------
function CellMultiCopySettlement:_adaptLanguage_en(  )
    local ftb = GetElement(self.m_root,"ftbHurt_CellMultiCopySettlement",WZUIFreeTextBox)
    ftb:setScale(0.7)
    GetElement(self.m_root, "imgMvp_CellMultiCopySettlement", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.92,0.5))
    ftb:setRelativePosition(GlobalMethod:ccp(0.46,0.808218))
    GetElement(self.m_root,"txtPlayerName_CellMultiCopySettlement",WZUILabelTTF):setFontSize(16)
end

function CellMultiCopySettlement:_adaptLanguage_vn(  )
    local ftb = GetElement(self.m_root,"ftbHurt_CellMultiCopySettlement",WZUIFreeTextBox)
    ftb:setScale(0.7)
    ftb:setRelativePosition(GlobalMethod:ccp(0.46,0.808218))
end

function CellMultiCopySettlement:_adaptLanguage_pt(  )
    local ftb = GetElement(self.m_root,"ftbHurt_CellMultiCopySettlement",WZUIFreeTextBox)
    ftb:setScale(0.8)
    ftb:setRelativePosition(GlobalMethod:ccp(0.46,0.808218))
end

function CellMultiCopySettlement:_adaptLanguage_tr(  )
    local ftb = GetElement(self.m_root,"ftbHurt_CellMultiCopySettlement",WZUIFreeTextBox)
    ftb:setScale(0.7)
    GetElement(self.m_root, "imgMvp_CellMultiCopySettlement", WZUIImage):setRelativePosition(GlobalMethod:ccp(0.92,0.5))
    --ftb:setRelativePosition(GlobalMethod:ccp(0.46,0.808218))
end

function CellMultiCopySettlement:_adaptLanguage_es(  )
    local ftb = GetElement(self.m_root,"ftbHurt_CellMultiCopySettlement",WZUIFreeTextBox)
    ftb:setScale(0.7)
    ftb:setRelativePosition(GlobalMethod:ccp(0.46,0.808218))
end
-------------------------------------语言适配End--------------------------------------------