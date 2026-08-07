--WndCopyTowerInfoView.lua
--@brief	WndCopyTowerInfoView的UI模块
--@date		2015/09/09
--@author	mbq
--@note		爬塔


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyTowerInfoView:onEnter(element)
	self.m_root = element
    self:_initUI()
    self:_updateLabelPos()
    self:_initEvent()
    self:_updatePlayerHpView(100)
    self:_updatePlayerAttRoundView(0)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyTowerInfoView:onExit(element)
	self:_unInit()
    self:_removeEvent()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化ui
function WndCopyTowerInfoView:_initUI()
    self.m_tRemainHpTitleLab = GetElement(self.m_root, "remainHpTitle_WndCopyTowerInfoView", WZUILabelTTF)
    self.m_tAttRoundTitleLab = GetElement(self.m_root, "attRoundTitle_WndCopyTowerInfoView", WZUILabelTTF)

    self.m_tRemainHpLab = GetElement(self.m_root, "remainHp_WndCopyTowerInfoView", WZUILabelTTF)
    self.m_tAttRoundLab = GetElement(self.m_root, "attRound_WndCopyTowerInfoView", WZUILabelTTF)
end

--@brief 刷新位置
function WndCopyTowerInfoView:_updateLabelPos()
    local parentSize = self.m_tRemainHpTitleLab:getParent():getContentSize()


    local hpTile = tostring(self.m_tMapInfo.pass_hp)..LocalStrings.BATTLE_LEFT_HP
    self.m_tRemainHpTitleLab:setText(hpTile)
    local hpTileSize = self.m_tRemainHpTitleLab:getLabelContentSize()
    local hpTilePos = self.m_tRemainHpTitleLab:getRelativePosition()
    self.m_tRemainHpLab:setRelativePositionLuaTo((hpTileSize.width + 10)/ parentSize.width,hpTilePos.y)


    local attTile = tostring(self.m_tMapInfo.pass_round)..LocalStrings.BATTLE_ATT_TIME
    self.m_tAttRoundTitleLab:setText(attTile)
    local attTileSize = self.m_tAttRoundTitleLab:getLabelContentSize()
    local attTilePos = self.m_tAttRoundTitleLab:getRelativePosition()
    self.m_tAttRoundLab:setRelativePositionLuaTo((attTileSize.width + 10)/ parentSize.width,attTilePos.y)
  
end

--@brief 刷新hp信息
function WndCopyTowerInfoView:_updatePlayerHpView(hpPrec)
    local result = tostring(hpPrec)
    self.m_tRemainHpLab:setText(result)
end

--@brief 刷新攻击回合
function WndCopyTowerInfoView:_updatePlayerAttRoundView(attRound)
    local result = tostring(attRound)
    self.m_tAttRoundLab:setText(result)
end



-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndCopyTowerInfoView:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtTowerDesc_WndCopyTowerInfoView",WZUILabelTTF):setFontSize(12)
end
--------------------------------------语言适配End-------------------------------------------