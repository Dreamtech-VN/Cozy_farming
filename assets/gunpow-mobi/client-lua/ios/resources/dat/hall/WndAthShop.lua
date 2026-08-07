--WndAthShop.lua
--@brief	WndAthShop的UI模块
--@date		2015/04/22
--@author	binshao
--@note		竞技场商店

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAthShop:onEnter(element)
	self.m_root = element
    self:_initMoreLanguage()
    self:_initVipLimit()
end

--@brief    弹窗动画完成后的回调
function WndAthShop:actionCallback(element, data)
    ProtocolProcessorSceneHall:send_ROOM_GetArenaStore( )
end

--@brief onEnter函数执行完成回调
function WndAthShop:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAthShop:onExit(element)

end

--@brief	关闭整个窗口的动画效果
function WndAthShop:onReturnActionCallback(elem,data)
    WindowManager:removeWindow(self.m_root , WndAthShop , true)
end

function WndAthShop:setAthShopInfo(data)
    self.tData = data
    self:_createAllPropUI()
end

--@brief	关闭设置界面btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndAthShop:onBtnReturn( element )
	WZLog("sun---WndAthShopy:onBtnCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root,"onReturnActionCallback",self)
end

-- 竞技商店刷新确认
function WndAthShop:refreshSure(tag)
    local costId,costCnt = self:_getCost()
    if JudgeMoneyIsEnough(costId,costCnt,nil,nil,8) then
        self:createLoadingBox()
        ProtocolProcessorSceneHall:send_ROOM_RefreshArenaStore()
    end

--    local costId,costCnt = self:_getCost()
--    local Money  = CacheCenter:getPlayerItemCountById(costId)
--    WZLog("-------------------110-------------------",costId,costCnt,Money)
--    if Money < costCnt then
--        MsgBoxManager:showTipBox(LocalStrings.ATHMONEY_NOT_ENOUGH, nil,nil, nil, nil)
--        return
--    end

end

-- 刷新商品信息
function WndAthShop:OnBtnRefresh()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local costId,costCnt = self:_getCost()
    -- 刷新次数不足
    if not costId then
        MsgBoxManager:showTipBox(LocalStrings.ATH_REFRESH_LIMIT, nil, nil, nil, nil)
        return
    end

    -- 弹出刷新确认提示
    MsgBoxManager:showConfirmBox(string.format(LocalStrings.ATH_REFRESH_COST,costCnt,self.tData.refreshCount),self,self.refreshSure, nil, nil)
end

--@brief   弹框TIPS
function WndAthShop:onTouchBtn(element,pt)
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt)
    if bPoint == false then WndItemInfo:onCloseClick() end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin-------------------------------------
-- 创建商店UI
function WndAthShop:_createAllPropUI()
    local tabR = GetElement(self.m_root,"tabProp_WndAthShop",WZUITableContainer)
    WZLog("---------------5555-------------------#self.tData.prop",#self.tData.prop)
    for i = 1, #self.tData.prop do
        local cell,tcell = CellAthShop:createElement()
        cell:setTag(i-1)
        tabR:setCellElement(cell)
        tcell:SetData(self.tData.prop[i])
        self:_setCell(i,cell,tcell)
    end

    local athMoney = CacheCenter:getMoneyList().athMoney
    local txtMoney = GetElement(self.m_root,"txtShopMoney_WndAthShop",WZUILabelTTF)
    txtMoney:setText(athMoney)
    WZLog("--------------------88-------------------------",CacheCenter:getMoneyList().athMoney)
end

-- 玩家购买道具后，显示道具卖完状态
function WndAthShop:updateSellStatus(id)
    local tag = self:_findIndexById(id)
    local tcell = self.cell[tag].tcell
    tcell:updateSellStatus()
end

-- 更新竞技场货币
function WndAthShop:updateAthMoney()
    local athMoney = CacheCenter:getMoneyList().athMoney
    local txtMoney = GetElement(self.m_root,"txtShopMoney_WndAthShop",WZUILabelTTF)
    txtMoney:setText(athMoney)
end

-- 初始化多语言版本
function WndAthShop:_initMoreLanguage()
    local txtRemind = GetElement(self.m_root,"txtRemind_WndAthShop",WZUIFreeTextBox)
    txtRemind:setShowText(string.format(LocalStrings.ATH_SHOP_CHANGE," 24:00 "))
end

function WndAthShop:buySuccess()
    self.curSelData.status = 1
    MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS)
	SoundManager:playEffectSound(SoundDefine.E_S_KILL_GOUMAICHENGGONG)
    WndAthShop:updateSellStatus(self.curSelData.storeId)
    WndAthShop:updateAthMoney()
end

function WndAthShop:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingBox)
    end
end

function WndAthShop:closeLoadingBox()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end
-------------------------------------私有方法模块End--------------------------------------