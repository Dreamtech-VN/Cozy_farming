--WndCopyPetInfoView.lua
--@brief	WndCopyPetInfoView的UI模块
--@date		2015/09/09
--@author	mbq
--@note		爬塔


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyPetInfoView:onEnter(element)
	self.m_root = element
    self:_initUI()
    self:_updateLabelPos()
    self:_initEvent()
    self:_updatePlayerHpView(0)
    self:_updatePlayerAttRoundView(0)
    self:_updatePetScoreView(0)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyPetInfoView:onExit(element)
	self:_unInit()
    self:_removeEvent()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化ui
function WndCopyPetInfoView:_initUI()
    self.m_tEggScoreTitleLab = GetElement(self.m_root, "eggScoreTitle_WndCopyPetInfoView", WZUILabelTTF)
    self.m_tAttRoundTitleLab = GetElement(self.m_root, "attRoundTitle_WndCopyPetInfoView", WZUILabelTTF)
    self.m_tTargetHurtTitleLab = GetElement(self.m_root,"targetHurtTitle_WndCopyPetInfoView", WZUILabelTTF)

    self.m_tEggScoreLab = GetElement(self.m_root, "eggScore_WndCopyPetInfoView", WZUILabelTTF)
    self.m_tAttRoundLab = GetElement(self.m_root, "attRound_WndCopyPetInfoView", WZUILabelTTF)
    self.m_tTargetHurtLab = GetElement(self.m_root,"targetHurt_WndCopyPetInfoView", WZUILabelTTF)
end

--@brief 刷新位置
function WndCopyPetInfoView:_updateLabelPos()
    local parentSize = self.m_tEggScoreTitleLab:getParent():getContentSize()

    
    self.m_tEggScoreTitleLab:setText(LocalStrings.EGG_SCORE)
    local size = self.m_tEggScoreTitleLab:getLabelContentSize()
    local pos = self.m_tEggScoreTitleLab:getRelativePosition()
    self.m_tEggScoreLab:setRelativePositionLuaTo((size.width + 10)/ parentSize.width,pos.y)

    self.m_tAttRoundTitleLab:setText(LocalStrings.ATT_ROUND)
    local size = self.m_tAttRoundTitleLab:getLabelContentSize()
    local pos = self.m_tAttRoundTitleLab:getRelativePosition()
    self.m_tAttRoundLab:setRelativePositionLuaTo((size.width + 10)/ parentSize.width,pos.y)


    self.m_tTargetHurtTitleLab:setText(LocalStrings.TARGET_HURT_HP)
    local size = self.m_tTargetHurtTitleLab:getLabelContentSize()
    local pos = self.m_tTargetHurtTitleLab:getRelativePosition()
    self.m_tTargetHurtLab:setRelativePositionLuaTo((size.width + 10)/ parentSize.width,pos.y)
  
end

--@brief 刷新hp信息
function WndCopyPetInfoView:_updatePlayerHpView(hpPrec)
    local result = tostring(hpPrec) .. "/" .. tostring(100 - self.m_tMapInfo.parameter3)
    self.m_tTargetHurtLab:setText(result)
end

--@brief 刷新攻击回合
function WndCopyPetInfoView:_updatePlayerAttRoundView(attRound)
    local result = tostring(attRound) .. "/" .. tostring(self.m_tMapInfo.parameter5)
    self.m_tAttRoundLab:setText(result)
end

--@brief 刷新分数
function WndCopyPetInfoView:_updatePetScoreView(score)
    local result = tostring(score) .. "/" .. tostring(self.m_tMapInfo.parameter4)
    self.m_tEggScoreLab:setText(result)
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndCopyPetInfoView:_adaptLanguage_pt()
    local eggScoreTitle = GetElement(self.m_root, "eggScoreTitle_WndCopyPetInfoView", WZUILabelTTF)
    eggScoreTitle:setScale(0.8)
    eggScoreTitle:setDimensions(GlobalMethod:CCSize(120))
    local eggScore = GetElement(self.m_root, "eggScore_WndCopyPetInfoView", WZUILabelTTF)
    eggScore:setScale(0.8)
    eggScore:setRelativePosition(GlobalMethod:ccp(0.48,0.15))

    local attRoundTitle = GetElement(self.m_root, "attRoundTitle_WndCopyPetInfoView", WZUILabelTTF)
    attRoundTitle:setScale(0.9)
    local attRound = GetElement(self.m_root, "attRound_WndCopyPetInfoView", WZUILabelTTF)
    attRound:setScale(0.9)

    local targetHurtTitle = GetElement(self.m_root, "targetHurtTitle_WndCopyPetInfoView", WZUILabelTTF)
    targetHurtTitle:setScale(0.9)
    local targetHurt = GetElement(self.m_root, "targetHurt_WndCopyPetInfoView", WZUILabelTTF)
    targetHurt:setScale(0.9)
    
end

function WndCopyPetInfoView:_adaptLanguage_vn()
    local targetHurtTitle = GetElement(self.m_root, "targetHurtTitle_WndCopyPetInfoView", WZUILabelTTF)
    targetHurtTitle:setScale(0.8)
    local targetHurt = GetElement(self.m_root, "targetHurt_WndCopyPetInfoView", WZUILabelTTF)
    targetHurt:setScale(0.8)
    targetHurt:setRelativePosition(GlobalMethod:ccp(0.722727,0.85))

    local attRoundTitle = GetElement(self.m_root, "attRoundTitle_WndCopyPetInfoView", WZUILabelTTF)
    attRoundTitle:setScale(0.8)
    local attRound = GetElement(self.m_root, "attRound_WndCopyPetInfoView", WZUILabelTTF)
    attRound:setScale(0.8)
    attRound:setRelativePosition(GlobalMethod:ccp(0.263636,0.5))

    local eggScoreTitle = GetElement(self.m_root, "eggScoreTitle_WndCopyPetInfoView", WZUILabelTTF)
    eggScoreTitle:setScale(0.8)
    local eggScore = GetElement(self.m_root, "eggScore_WndCopyPetInfoView", WZUILabelTTF)
    eggScore:setScale(0.8)
    eggScore:setRelativePosition(GlobalMethod:ccp(0.431818,0.15))
end
-------------------------------------语言适配End--------------------------------------------
