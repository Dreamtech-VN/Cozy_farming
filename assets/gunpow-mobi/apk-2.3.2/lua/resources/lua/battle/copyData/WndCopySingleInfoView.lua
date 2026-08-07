--WndCopySingleInfoView.lua
--@brief	WndCopySingleInfoView的UI模块
--@date		2015/11/09
--@author	mbq
--@note		单人副本战斗UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndCopySingleInfoView:onEnter(element)
    self.m_root = element
    if WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 9999 then
        self.m_root:setVisible(false)
    end
    self:_initUI()
    self:_updateLabelPos()
    self:_initEvent()
    self:_updatePlayerHpView(100)
    self:_updatePlayerAttRoundView(0)
    AdaptLanguage(self)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndCopySingleInfoView:onExit(element)
    self:_unInit()
    self:_removeEvent()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化ui
function WndCopySingleInfoView:_initUI()
    self.m_tPassBtn = GetElement(self.m_root,"imgCO_WndCopySingleInfoView",WZUIImage)
    self.m_tHpBtn = GetElement(self.m_root,"imgCT_WndCopySingleInfoView",WZUIImage)
    self.m_tAttackBtn = GetElement(self.m_root,"imgCF_WndCopySingleInfoView",WZUIImage)

    self.m_tRemainHpTitleLab = GetElement(self.m_root, "txtDescribeT_WndCopySingleInfoView", WZUILabelTTF)
    self.m_tAttRoundTitleLab = GetElement(self.m_root, "txtDescribeF_WndCopySingleInfoView", WZUILabelTTF)

    self.m_tRemainHpLab = GetElement(self.m_root, "txtResultT_WndCopySingleInfoView", WZUILabelTTF)
    self.m_tAttRoundLab = GetElement(self.m_root, "txtResultF_WndCopySingleInfoView", WZUILabelTTF)
end

--@brief 刷新位置
function WndCopySingleInfoView:_updateLabelPos()
    local parentSize = self.m_tRemainHpTitleLab:getParent():getContentSize()


    local hpTile = tostring(self.m_tMapInfo.pass_hp)..LocalStrings.BATTLE_LEFT_HP
    self.m_tRemainHpTitleLab:setText(hpTile)
    local hpTileSize = self.m_tRemainHpTitleLab:getLabelContentSize()
    local hpTilePos = self.m_tRemainHpTitleLab:getRelativePosition()
    self.m_tRemainHpLab:setRelativePositionLuaTo((hpTileSize.width + 18)/ parentSize.width,hpTilePos.y)


    local attTile = tostring(self.m_tMapInfo.pass_round)..LocalStrings.BATTLE_ATT_TIME
    self.m_tAttRoundTitleLab:setText(attTile)
    local attTileSize = self.m_tAttRoundTitleLab:getLabelContentSize()
    local attTilePos = self.m_tAttRoundTitleLab:getRelativePosition()
    self.m_tAttRoundLab:setRelativePositionLuaTo((attTileSize.width + 18)/ parentSize.width,attTilePos.y)
  
end

--@brief 刷新hp信息
function WndCopySingleInfoView:_updatePlayerHpView(hpPrec)
    local result = tostring(hpPrec)
    self.m_tRemainHpLab:setText(result)
    if hpPrec < self.m_tMapInfo.pass_hp then
        self.m_tHpBtn:setGrayRender(true)
    else
        self.m_tHpBtn:setGrayRender(false)
    end 
end

--@brief 刷新攻击回合
function WndCopySingleInfoView:_updatePlayerAttRoundView(attRound)
    local result = tostring(attRound)
    self.m_tAttRoundLab:setText(result)
    if attRound > self.m_tMapInfo.pass_round then
        self.m_tAttackBtn:setGrayRender(true)
    end
end



-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-------------------------------------------
function WndCopySingleInfoView:_adaptLanguage_vn( )
    GetElement(self.m_root,"txtDescribeT_WndCopySingleInfoView",WZUILabelTTF):setFontSize(12)
    local txtResultT = GetElement(self.m_root,"txtResultT_WndCopySingleInfoView",WZUILabelTTF)
    txtResultT:setRelativePosition(GlobalMethod:ccp(0.745,0.5))
    txtResultT:setFontSize(12)

    local txtDescribeT = GetElement(self.m_root,"txtDescribeT_WndCopySingleInfoView",WZUILabelTTF)
    txtDescribeT:setFontSize(12)
end

function WndCopySingleInfoView:_adaptLanguage_en(  )
    GetElement(self.m_root,"imgView_WndCopySingleInfoView",WZUI9Image):setScaleX(1.4)

    GetElement(self.m_root,"imgCO_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))
    GetElement(self.m_root,"imgCF_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))
    GetElement(self.m_root,"imgCT_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))

    GetElement(self.m_root,"txtDescribeO_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
    GetElement(self.m_root,"txtDescribeF_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
    GetElement(self.m_root,"txtDescribeT_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))

    local parentSize = self.m_tRemainHpTitleLab:getParent():getContentSize()

    local hpTileSize = self.m_tRemainHpTitleLab:getLabelContentSize()
    local hpTilePos = self.m_tRemainHpTitleLab:getRelativePosition()
    self.m_tRemainHpLab:setRelativePositionLuaTo((hpTileSize.width - 32)/ parentSize.width,hpTilePos.y)

    local attTileSize = self.m_tAttRoundTitleLab:getLabelContentSize()
    local attTilePos = self.m_tAttRoundTitleLab:getRelativePosition()
    self.m_tAttRoundLab:setRelativePositionLuaTo((attTileSize.width - 32)/ parentSize.width,attTilePos.y)
end

function WndCopySingleInfoView:_adaptLanguage_pt( )
    GetElement(self.m_root,"imgView_WndCopySingleInfoView",WZUI9Image):setScaleX(1.4)

    GetElement(self.m_root,"imgCO_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))
    GetElement(self.m_root,"imgCF_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))
    GetElement(self.m_root,"imgCT_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))

    GetElement(self.m_root,"txtDescribeO_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
    GetElement(self.m_root,"txtDescribeF_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
    GetElement(self.m_root,"txtDescribeT_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))

    local parentSize = self.m_tRemainHpTitleLab:getParent():getContentSize()

    local hpTileSize = self.m_tRemainHpTitleLab:getLabelContentSize()
    local hpTilePos = self.m_tRemainHpTitleLab:getRelativePosition()
    self.m_tRemainHpLab:setRelativePositionLuaTo((hpTileSize.width - 32)/ parentSize.width,hpTilePos.y)

    local attTileSize = self.m_tAttRoundTitleLab:getLabelContentSize()
    local attTilePos = self.m_tAttRoundTitleLab:getRelativePosition()
    self.m_tAttRoundLab:setRelativePositionLuaTo((attTileSize.width - 32)/ parentSize.width,attTilePos.y)
end

function WndCopySingleInfoView:_adaptLanguage_es( )
    GetElement(self.m_root,"imgView_WndCopySingleInfoView",WZUI9Image):setScaleX(1.4)

    GetElement(self.m_root,"imgCO_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))
    GetElement(self.m_root,"imgCF_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))
    GetElement(self.m_root,"imgCT_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))

    GetElement(self.m_root,"txtDescribeO_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
    GetElement(self.m_root,"txtDescribeF_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
    GetElement(self.m_root,"txtDescribeT_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))

    local parentSize = self.m_tRemainHpTitleLab:getParent():getContentSize()

    local hpTileSize = self.m_tRemainHpTitleLab:getLabelContentSize()
    local hpTilePos = self.m_tRemainHpTitleLab:getRelativePosition()
    self.m_tRemainHpLab:setRelativePositionLuaTo((hpTileSize.width - 32)/ parentSize.width,hpTilePos.y)

    local attTileSize = self.m_tAttRoundTitleLab:getLabelContentSize()
    local attTilePos = self.m_tAttRoundTitleLab:getRelativePosition()
    self.m_tAttRoundLab:setRelativePositionLuaTo((attTileSize.width - 32)/ parentSize.width,attTilePos.y)
end

function WndCopySingleInfoView:_adaptLanguage_tr( )
    GetElement(self.m_root,"imgView_WndCopySingleInfoView",WZUI9Image):setScaleX(1.4)

    GetElement(self.m_root,"imgCO_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))
    GetElement(self.m_root,"imgCF_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))
    GetElement(self.m_root,"imgCT_WndCopySingleInfoView",WZUIImage):setRelativePosition(GlobalMethod:ccp(-0.44,0.5))

    GetElement(self.m_root,"txtDescribeO_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
    GetElement(self.m_root,"txtDescribeF_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))
    GetElement(self.m_root,"txtDescribeT_WndCopySingleInfoView",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.27,0.5))

    local parentSize = self.m_tRemainHpTitleLab:getParent():getContentSize()

    local hpTileSize = self.m_tRemainHpTitleLab:getLabelContentSize()
    local hpTilePos = self.m_tRemainHpTitleLab:getRelativePosition()
    self.m_tRemainHpLab:setRelativePositionLuaTo((hpTileSize.width - 32)/ parentSize.width,hpTilePos.y)

    local attTileSize = self.m_tAttRoundTitleLab:getLabelContentSize()
    local attTilePos = self.m_tAttRoundTitleLab:getRelativePosition()
    self.m_tAttRoundLab:setRelativePositionLuaTo((attTileSize.width - 32)/ parentSize.width,attTilePos.y)
end


function WndCopySingleInfoView:_adaptLanguage_ug( )
    GetElement(self.m_root,"imgView_WndCopySingleInfoView",WZUI9Image):setScaleX(1.5)
    local conditionO = GetElement(self.m_root,"conditionO_WndCopySingleInfoView",WZUIContainer)
    conditionO:setScale(0.8)
    conditionO:setRelativePosition(GlobalMethod:ccp(0.596,0.981982))
    local conditionF = GetElement(self.m_root,"conditionF_WndCopySingleInfoView",WZUIContainer)
    conditionF:setScale(0.8)
    conditionF:setRelativePosition(GlobalMethod:ccp(0.596,0.5))
    local conditionT = GetElement(self.m_root,"conditionT_WndCopySingleInfoView",WZUIContainer)
    conditionT:setScale(0.8)
    conditionT:setRelativePosition(GlobalMethod:ccp(0.596,0.018018))
    
end
-------------------------------------语言适配End--------------------------------------------