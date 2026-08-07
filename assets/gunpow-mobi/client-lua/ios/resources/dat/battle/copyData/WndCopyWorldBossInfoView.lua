--WndCopyWorldBossInfoView.lua
--@brief	WndCopyWorldBossInfoView的UI模块
--@date		2015/11/09
--@author	mbq
--@note		世界副本战斗UI


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyWorldBossInfoView:onEnter(element)
	self.m_root = element
    self:_initUI()
    self:_initEvent()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyWorldBossInfoView:onExit(element)
	self:_unInit()
    self:_removeEvent()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化ui
function WndCopyWorldBossInfoView:_initUI()
    self.m_tHpProgress = WZUIProgress:luaTo(GetElement(self.m_root,"proHP_WndCopyWorldBossInfoView"))
    self.m_tHpLable = GetElement(self.m_root, "txtHP_WndCopyWorldBossInfoView", WZUILabelTTF)
    local monster = WBattleGlobal:getCurrent():getBossArray()[1]
    self.m_nMaxHp = monster:getMaxHp()
    self:_updatePlayerHpView(monster:getHp())
end

--@brief 刷新hp信息
function WndCopyWorldBossInfoView:_updatePlayerHpView(curHP)
    local precent = math.ceil(10000*curHP/self.m_nMaxHp)/100
    self.m_tHpProgress:setPercentage(precent)
    local str = string.format("%0.2f", precent) 
    self.m_tHpLable:setText(str.."%")
end




-------------------------------------私有方法模块End----------------------------------------
