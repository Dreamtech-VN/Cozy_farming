--WndCopyFlyInfoView.lua
--@brief	WndCopyFlyInfoView的UI模块
--@date		2017/2/15
--@author	jianfeng_mo
--@note		训练营战斗UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndCopyFlyInfoView:onEnter(element)
    self.m_root = element
    if WBattleGlobal:getCurrent().m_tMakePairOk.mapId == 9999 then
        self.m_root:setVisible(false)
    end
    self:_initUI()
    self:_updateLabelPos()
    self:_initEvent()
    self:_updatePlayerFlyView()
    self:_updatePlayerAttRoundView(0)

    AdaptLanguage(self)
end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndCopyFlyInfoView:onExit(element)
    self:_unInit()
    self:_removeEvent()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化ui
function WndCopyFlyInfoView:_initUI()
    self.m_tPassBtn = GetElement(self.m_root,"imgCO_WndCopyFlyInfoView",WZUIImage)
    self.m_tHpBtn = GetElement(self.m_root,"imgCT_WndCopyFlyInfoView",WZUIImage)
    self.m_tAttackBtn = GetElement(self.m_root,"imgCF_WndCopyFlyInfoView",WZUIImage)

    self.m_tRemainHpTitleLab = GetElement(self.m_root, "txtDescribeT_WndCopyFlyInfoView", WZUILabelTTF)
    self.m_tAttRoundTitleLab = GetElement(self.m_root, "txtDescribeF_WndCopyFlyInfoView", WZUILabelTTF)

    self.m_tRemainHpLab = GetElement(self.m_root, "txtResultT_WndCopyFlyInfoView", WZUILabelTTF)
    self.m_tAttRoundLab = GetElement(self.m_root, "txtResultF_WndCopyFlyInfoView", WZUILabelTTF)
end

--@brief 刷新位置
function WndCopyFlyInfoView:_updateLabelPos()
    local parentSize = self.m_tRemainHpTitleLab:getParent():getContentSize()


    local hpTile = string.format(LocalStrings.TRAINCAMP_DEC6, self.m_tMapInfo.pass_count)
    if WBattleGlobal:getCurrent():isFlyCopy() then
        hpTile = string.format(LocalStrings.TRAINCAMP_DEC6, self.m_tMapInfo.pass_count)
    elseif WBattleGlobal:getCurrent():isWindCopy() or WBattleGlobal:getCurrent():isHoleCopy() or WBattleGlobal:getCurrent():isThrowCopy() then
        --欧洲要求改的
        if ProjConfig.CHANNEL_ID == 1061 or ProjConfig.CHANNEL_ID == 1062 or ProjConfig.CHANNEL_ID == 1051 or ProjConfig.CHANNEL_ID == 1048 or ProjConfig.CHANNEL_ID == 1053 then
            if ProjConfig.LANGUAGE == "en" then
                hpTile = LocalStrings.TRAINCAMP_DEC7
            else
                hpTile = string.format(LocalStrings.TRAINCAMP_DEC7, self.m_tMapInfo.pass_count)
            end
        else
            hpTile = string.format(LocalStrings.TRAINCAMP_DEC7, self.m_tMapInfo.pass_count)
        end
    end
    self.m_tRemainHpTitleLab:setText(hpTile)
    local hpTileSize = self.m_tRemainHpTitleLab:getLabelContentSize()
    local hpTilePos = self.m_tRemainHpTitleLab:getRelativePosition()
    self.m_tRemainHpLab:setRelativePositionLuaTo((hpTileSize.width + 36)/ parentSize.width,hpTilePos.y)


    local attTile = tostring(self.m_tMapInfo.pass_round)..LocalStrings.BATTLE_ATT_TIME
    self.m_tAttRoundTitleLab:setText(attTile)
    local attTileSize = self.m_tAttRoundTitleLab:getLabelContentSize()
    local attTilePos = self.m_tAttRoundTitleLab:getRelativePosition()
    self.m_tAttRoundLab:setRelativePositionLuaTo((attTileSize.width + 36)/ parentSize.width,attTilePos.y)
  
end

--@brief 刷新fly信息
function WndCopyFlyInfoView:_updatePlayerFlyView()
    self.m_tRemainHpLab:setText(self.m_nCount)
    -- if self.m_nCount > self.m_tMapInfo.pass_count then
    --     self.m_tHpBtn:setGrayRender(true)
    -- end 
end

--@brief 刷新攻击回合
function WndCopyFlyInfoView:_updatePlayerAttRoundView(attRound)
    local result = tostring(attRound)
    self.m_tAttRoundLab:setText(result)
    if attRound > self.m_tMapInfo.pass_round then
        self.m_tAttackBtn:setGrayRender(true)
    end
end



-------------------------------------私有方法模块End----------------------------------------


function WndCopyFlyInfoView:_adaptLanguage_tr( )
    local txtDescribeT = GetElement(self.m_root,"txtDescribeT_WndCopyFlyInfoView",WZUILabelTTF)
    

    local txtResultT = GetElement(self.m_root, "txtResultT_WndCopyFlyInfoView", WZUILabelTTF)

    if WBattleGlobal:getCurrent():isFlyCopy() then
        txtDescribeT:setScale(0.7)
        txtDescribeT:setDimensions(GlobalMethod:CCSize(200))

        txtResultT:setRelativePosition(GlobalMethod:ccp(0.79,0.5))
    else
        txtDescribeT:setScale(0.9)
        txtDescribeT:setDimensions(GlobalMethod:CCSize(0))
        txtResultT:setScale(0.9)
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.944545,0.5))
    end
end

-------------------------------------私语言适配Begin----------------------------------------
function WndCopyFlyInfoView:_adaptLanguage_th( )
    GetElement(self.m_root, "txtDescribeO_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.75)

    GetElement(self.m_root, "txtDescribeF_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.75)
    local txtResultF = GetElement(self.m_root, "txtResultF_WndCopyFlyInfoView", WZUILabelTTF)
    txtResultF:setScale(0.75)
    txtResultF:setRelativePosition(GlobalMethod:ccp(0.545455,0.5))

    GetElement(self.m_root, "txtDescribeT_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.75)
    local txtResultT = GetElement(self.m_root, "txtResultT_WndCopyFlyInfoView", WZUILabelTTF)
    txtResultT:setScale(0.75)
    if WBattleGlobal:getCurrent():isFlyCopy() then
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.915758,0.5))
    else
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.511213,0.5))
    end
end

function WndCopyFlyInfoView:_adaptLanguage_en( )
    GetElement(self.m_root, "txtDescribeO_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.65)

    GetElement(self.m_root, "txtDescribeF_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.65)
    local txtResultF = GetElement(self.m_root, "txtResultF_WndCopyFlyInfoView", WZUILabelTTF)
    txtResultF:setScale(0.65)
    txtResultF:setRelativePosition(GlobalMethod:ccp(0.52,0.5))

    GetElement(self.m_root, "txtDescribeT_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.65)
    local txtResultT = GetElement(self.m_root, "txtResultT_WndCopyFlyInfoView", WZUILabelTTF)
    txtResultT:setScale(0.65)
    if WBattleGlobal:getCurrent():isFlyCopy() then
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.979395,0.5))
    else
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.58394,0.5))
    end
end

function WndCopyFlyInfoView:_adaptLanguage_es( )
    GetElement(self.m_root, "txtDescribeO_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root, "txtDescribeF_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.7)
    local txtResultF = GetElement(self.m_root, "txtResultF_WndCopyFlyInfoView", WZUILabelTTF)
    txtResultF:setScale(0.7)
    txtResultF:setRelativePosition(GlobalMethod:ccp(0.45,0.5))

    GetElement(self.m_root, "txtDescribeT_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.7)
    local txtResultT = GetElement(self.m_root, "txtResultT_WndCopyFlyInfoView", WZUILabelTTF)
    txtResultT:setScale(0.7)
    if WBattleGlobal:getCurrent():isFlyCopy() then
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.88394,0.5))
    else
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.724849,0.5))
    end
end

function WndCopyFlyInfoView:_adaptLanguage_pt( )
    GetElement(self.m_root, "txtDescribeO_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root, "txtDescribeF_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.7)
    local txtResultF = GetElement(self.m_root, "txtResultF_WndCopyFlyInfoView", WZUILabelTTF)
    txtResultF:setScale(0.7)
    txtResultF:setRelativePosition(GlobalMethod:ccp(0.45,0.5))

    GetElement(self.m_root, "txtDescribeT_WndCopyFlyInfoView", WZUILabelTTF):setScale(0.7)
    local txtResultT = GetElement(self.m_root, "txtResultT_WndCopyFlyInfoView", WZUILabelTTF)
    txtResultT:setScale(0.7)
    if WBattleGlobal:getCurrent():isFlyCopy() then
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.88394,0.5))
    else
        txtResultT:setRelativePosition(GlobalMethod:ccp(0.724849,0.5))
    end
end
-------------------------------------语言适配End----------------------------------------