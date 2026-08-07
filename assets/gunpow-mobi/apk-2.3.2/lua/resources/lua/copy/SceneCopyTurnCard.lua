--SceneCopyTurnCard.lua
--@brief	SceneCopyTurnCard的UI模块
--@date		2015/04/20
--@author	xiaoyu_wu
--@note		副本翻牌界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCopyTurnCard:onEnter(element)
	self.m_root = element
    
    self:_initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCopyTurnCard:onExit(element)
	self:_unInit()
end

--@brief	点击卡牌时被调用的函数
--@param	tCard:卡牌绑定的UI节点引用
function SceneCopyTurnCard:onClickCard(tCard)
    self:flipCard(tCard)
end

--@brief    翻牌
--@param    tCard,卡牌绑定的lua表对象
function SceneCopyTurnCard:flipCard(tCard)
    if tCard == nil then
        return
    end
    tCard:setData(104, 2)
    tCard:flipCard()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化界面
function SceneCopyTurnCard:_initUI()
    self:_setUIStaticText()
    self:_initCard()
    self:_updateCost()
    self:_updatePeople()
end

--@brief	初始化翻牌
function SceneCopyTurnCard:_initCard()
    local tbcon = GetElement(self.m_root, "tbcon_SceneCopyTurnCard", WZUITableContainer)
    tbcon:cleanTable()
    self.m_tCardObjList = {}
    for i = 1, 21 do
        local eCard, tCard = CellSettlementCard:createElement()
        eCard:setTag(i-1)
        eCard:setScale(0.92)
        tbcon:setCellElement(eCard)
        
        tCard:setClickCallback(function(tClickedCard)
            self:onClickCard(tClickedCard)
        end)
        self.m_tCardObjList[i] = tCard
    end
end

--@brief	更新翻牌消耗
function SceneCopyTurnCard:_updateCost()
    if self.m_root == nil then
        return
    end
    local txtCost = GetElement(self.m_root, "txtCost_SceneCopyTurnCard", WZUIFreeTextBox)
    local sCost = string.format(LocalStrings.TURN_CARD_COST, "ui/main/shop/tickets_s.png", 50)
    txtCost:setShowText(sCost)
end

--@brief	更新翻牌人数
function SceneCopyTurnCard:_updatePeople()
    if self.m_root == nil then
        return
    end
    local txtPeople = GetElement(self.m_root, "txtPeople_SceneCopyTurnCard", WZUILabelTTF)
    txtPeople:setText(2)
end

--@brief	设置控件静态文本
--@note		设置控件静态文本
function SceneCopyTurnCard:_setUIStaticText()
	--描边字
    local tNameMap = {
        {"txtWaiting_SceneCopyTurnCard", LocalStrings.WAITING_OTHERS_TURN_CARD},
    }
    for i,v in ipairs(tNameMap) do
        local txt = GetElement(self.m_root, v[1], WZUILabelTTF)
        txt:setText(v[2])
    end
end

-------------------------------------私有方法模块End----------------------------------------
