--WndAthBuy.lua
--@brief	WndAthBuy的UI模块
--@date		2015/04/22
--@author	binshao
--@note		竞技场商店购买弹框

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAthBuy:onEnter(element)
	self.m_root = element
end

--@brief    弹窗动画完成后的回调
function WndAthBuy:actionCallback(element, data)

end

--@brief onEnter函数执行完成回调
function WndAthBuy:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAthBuy:onExit(element)

end

--@brief	关闭整个窗口的动画效果
function WndAthBuy:onReturnActionCallback()
    WindowManager:removeWindow(self.m_root , WndAthBuy , true)
end

--@brief	关闭设置界面btn的点击回调函数
--@param	element:表绑定的UI节点引用
function WndAthBuy:onBtnClose( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root,"onReturnActionCallback",self)
end

function WndAthBuy:onBtnBuy()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nType == 1 then
		ProtocolProcessorSceneCommunity:send_GUILD_BuyGuildStore(self.tData.storeId )
	elseif self.m_nType == 2 then
		ProtocolProcessorSceneKing:send_KING_GetMallBuy( TableToIntVector( {self.tData.storeId} ) )
    else
        local athMoney = CacheCenter:getMoneyList().athMoney
        if self.tData.costNum > athMoney then
            MsgBoxManager:showConfirmBox(LocalStrings.ATHMONEY_NOT_ENOUGH, nil,nil, nil, nil,true)
        else
            ProtocolProcessorSceneHall:send_ROOM_BuyArenaStore(self.tData.storeId )
            WZLog("---------------------send-------------------------------")
        end
	end
    WZLog("---------buy info --------------","prop_id = ",self.tData.storeId,"buy type = ",self.m_nType)
    WindowManager:removeWindow(self.m_root , WndAthBuy , true)
end

function WndAthBuy:buySuccess()
    self.tData.status = 1
    WndAthShop:updateSellStatus(self.tData.storeId)
    WndAthShop:updateAthMoney()
end

--@brief	设置货币图标
function WndAthBuy:setMoneyIcon(icon)
	if icon == nil then return end
    GetElement(self.m_root,"imgMoney_WndAthBuy",WZUIImage):setFile(icon)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin-------------------------------------
function WndAthBuy:_update()
    self:_setPropInfoUI()
    self:_createPropIcon()
end

function WndAthBuy:_createPropIcon()
    local conP = GetElement(self.m_root,"conProp_WndAthBuy",WZUIContainer)

    local cell,tcell = CellGoodItem:createElement()
    conP:addChild(cell)
    --cell:setScale(0.8)
    tcell:setCellGoodItem(self.tData,2)
end

-- 设置购买窗口的基本信息
function WndAthBuy:_setPropInfoUI()
    local txtName = GetElement(self.m_root,"txtName_WndAthBuy",WZUILabelTTF)
    txtName:setText(self.tData.basicInfo.name)

    local haveCnt = getBagItemCount(self.tData.propId)
    if not haveCnt then haveCnt = 0 end
    local txtHaveNum = GetElement(self.m_root,"txtHaveNum_WndAthBuy",WZUIFreeTextBox)
    txtHaveNum:setShowText(string.format(LocalStrings.ATH_SHOP_HAVE_NUM,haveCnt))


    local txtDesc = GetElement(self.m_root,"txtDesc_WndAthBuy",WZUILabelTTF)
    txtDesc:setText(self.tData.basicInfo.desc)

    local txtPrice = GetElement(self.m_root,"txtPrice_WndAthBuy",WZUILabelTTF)
    txtPrice:setText(self.tData.costNum)
end
-------------------------------------私有方法模块End--------------------------------------