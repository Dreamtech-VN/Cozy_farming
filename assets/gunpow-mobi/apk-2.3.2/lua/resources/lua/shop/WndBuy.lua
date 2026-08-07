--WndBuy.lua
--@brief	WndBuy的UI模块
--@date		2015/05/26
--@author	binshao
--@note		点击保存形象时购买的物品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuy:onEnter(element)
	self.m_root = element

    -- 苹果审核需要屏蔽索要和赠送
    local ios = tonumber(CacheCenter:getGameParam().gameStatus)
    WZLog("-------------hideState---------",ios)
    if ios == 1 then
        local con =  GetElement(self.m_root,"conHide_WndBuy",WZUIContainer)
        con:setVisible(false)
    end
end

--@brief    弹窗动画完成后的回调
function WndBuy:actionCallback(element, data)

end

--@brief onEnter函数执行完成回调
function WndBuy:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBuy:onExit(element)
	self:_unInit()
end

--@brief	显示接口
function WndBuy:showBuyInterface(tData,sex,type)
	if self.m_root == nil then
		local wndBuy = WndBuy:createElement()
	    WindowManager:addWindow(wndBuy,WndBuy,true,nil,nil)
	end
	self.propData = tData
    self.selSex = sex
    self.showType = type
	self:_update()
end

-- 创建加载框
function WndBuy:createLoading()
    if not self.m_nLoadingId then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox(15,self,self.closeLoading)
    end
end

-- 关闭加载框
function WndBuy:closeLoading()
    if self.m_nLoadingId then
        WZLog("----------------close wndBuy--------------",self.m_nLoadingId)
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
        self.m_nLoadingId = nil
    end
end

--@brief	显示接口
function WndBuy:showByID(tData)
	if self.m_root == nil then
		local wndBuy = WndBuy:createElement()
	    WindowManager:addWindow(wndBuy,WndBuy,true)
	end

    local con =  GetElement(self.m_root,"conHide_WndBuy",WZUIContainer)
    con:setVisible(false)
    
	CacheCenter:getShopItems(function(t,shopItemList)
		local tempList = {}
		for i=1,#tData do
			for k,v in pairs(shopItemList) do
				if v.shopItemId == tData[i] then
                    local newData = {}
                    newData.subType = v.basicInfo.sub_type
                    newData.mainType = v.basicInfo.mainType
                    newData.initData = v
					table.insert(tempList,newData)
				end
			end
		end
		self.propData = tempList
        self.selSex = CacheCenter:getPlayerInfo().sex
		self:_update()
	end)
end

--@brief	关闭窗口
--@param	element:表绑定的UI节点引用
function WndBuy:onclickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

-- 更新商品价格和数量
function WndBuy:updateMoney()
    if not self.m_root then return end
    local needMoney,shopCnt = 0,0
	local moneyId = 1

	self.m_tMoneyId = {[1]=0,[177]=0,[35]=0}
	self.m_tNeedMoney = {[1]=0,[177]=0,[35]=0}

    for i = 1, #self.cellData do
        local tcell = self.cellData[i].tcell
		moneyId = tcell:getMoneyId()
        if moneyId ~= 177 then
            needMoney = needMoney + tcell:GetCurPropPrice()
        end
        if tcell:GetCurPropPrice() > 0 then  shopCnt = shopCnt + 1 end
		self.m_tMoneyId[tonumber(moneyId)] = self.m_tMoneyId[tonumber(moneyId)] + 1
		self.m_tNeedMoney[tonumber(moneyId)] = self.m_tNeedMoney[tonumber(moneyId)] + tcell:GetCurPropPrice()
    end
    --越南粉钻和蓝钻分开
    self.propPrice = needMoney
    self.propPrice2 = self.m_tNeedMoney[177]

	self.moneyId = moneyId
	WZLog("WndBuy:updateMoney", Serialize(self.m_tNeedMoney), self.moneyId)

    -- 设置购买商品的总价格和数量
    --local ftb = GetElement(self.m_root,"ftbBuyDesc_WndBuy",WZUIFreeTextBox)
    --ftb:setShowText(string.format(LocalStrings.SHOP_BUY_DESC3,shopCnt,GDatatab_item["id_"..moneyId].icon,needMoney))
	GetElement(self.m_root,"costText1",WZUILabelTTF):setText(string.format(LocalStrings.SHOPBUY1, tostring(self.m_tMoneyId[1]), GDatatab_item["id_1"].name))
	-- if CacheCenter:getGameParam().isUseTicket == "0" then
        GetElement(self.m_root,"costText2",WZUILabelTTF):setText(string.format(LocalStrings.SHOPBUY1, tostring(self.m_tMoneyId[177]), GDatatab_item["id_177"].name))
	-- end
    GetElement(self.m_root,"costShow3",WZUILabelTTF):setText(self.m_tNeedMoney[1])
    GetElement(self.m_root,"costShow1",WZUILabelTTF):setText(self.m_tNeedMoney[177])
    GetElement(self.m_root,"costShow2",WZUILabelTTF):setText(self.m_tNeedMoney[177])

    GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(true)
    GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(true)
    if self.m_tNeedMoney[1] == 0 then
        GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"conCost2",WZUIContainer):setRelativePosition(ccp(0.46,0.72))
    end
    if self.m_tNeedMoney[177] == 0 then
        GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"conCost1",WZUIContainer):setRelativePosition(ccp(0.46,0.72))
    end
    if self.m_tMoneyId[35] ~= 0 then 
        GetElement(self.m_root, "checkGroup_WndBuy", WZUICheckBoxGroup):setTouchEnable(false)
        GetElement(self.m_root, "checkInfo1_WndEquip", WZUICheckBox):setCheckIndex(1)
        GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(true)

        GetElement(self.m_root, "checkInfo2_WndEquip", WZUICheckBox):setVisible(true)
        GetElement(self.m_root,"costShow2",WZUILabelTTF):setText(self.m_tNeedMoney[1])
        GetElement(self.m_root,"costShow4",WZUILabelTTF):setText(self.m_tNeedMoney[35])

        GetElement(self.m_root,"costText2",WZUILabelTTF):setText(string.format(LocalStrings.SHOPBUY1, tostring(self.m_tMoneyId[35]), GDatatab_item["id_" .. 35].name))
        GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"conCost2",WZUIContainer):setRelativePosition(ccp(0.46,0.72))
        GetElement(self.m_root, "imgOtherCost_WndBuy", WZUIImage):setFile(GDatatab_item["id_35"].icon)
    end 
    --越南粉钻不能用蓝钻代替
    GetElement(self.m_root, "checkInfo1_WndEquip", WZUICheckBox):setVisible(false)
end

-- 索要
function WndBuy:onGived()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    WZLog("----------------onGived-------------------")
    if WndShop:selSexIsSame() then
        local mallId,count = WndBuy:getPropIdAndIndex()
        WndShopGiven:showWnd(2,self.propData,self.propPrice,self.selSex,self.propPrice2)
    else
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DESC8)
    end
end

-- 赠送
function WndBuy:onGive()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local needVip = tonumber(CacheCenter:getGameParam().mallOperateVip)
    local needLv = tonumber(CacheCenter:getGameParam().mallOperatePlayerLevel)
    local curLv = CacheCenter:getPlayerInfo().level
    local curVip = CacheCenter:getPlayerInfo().vipLevel
    WZLog("----------------onGive-------------------",curVip,needVip,needLv)
    if curVip >= needVip then
        if curLv < needLv then
            MsgBoxManager:showTipBox(string.format(LocalStrings.SHOP_DESC14,needLv))
            return
        end
        local mallId,count = WndBuy:getPropIdAndIndex()
        WndShopGiven:showWnd(1,self.propData,self.propPrice,self.selSex,self.propPrice2)
    else
        local function vipNotEnough()
            WndVip:showWndUI(0)
        end
        MsgBoxManager:showConfirmBox(LocalStrings.SHOP_DESC9, nil, vipNotEnough)
    end
end

-- 按键（钱够，然后时装类型匹配）
function WndBuy:onClickbuyBtn()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
	local moneyId = self.moneyId or 1
	WZLog("WndBuy:onClickbuyBtn",moneyId)
    if WndShop.m_root then
        if WndShop:canBuyShopItem() then
			self:moneyCanBuy()
        end
    elseif WndBag.m_root then
		self:moneyCanBuy()
    elseif Wndwardrobe.m_root then
        self:moneyCanBuy()
    elseif WndKidDress.m_root then
		self:moneyCanBuy()
    end
end

function WndBuy:moneyCanBuy() 
	local checked = tonumber(GetElement(self.m_root,"checkGroup_WndBuy",WZUICheckBoxGroup):getCheckIndex()) 
	if checked == 1 then
        if JudgeMoneyIsEnough(1,self.m_tNeedMoney[1]+self.m_tNeedMoney[177],nil,nil,43, nil, nil, nil, nil, self, self.canBuy) then
            self:canBuy()
			return
		else
			return	
        end
	end
    if self.m_tNeedMoney[35] and self.m_tNeedMoney[35] ~= 0 then 
        for i, value in pairs(self.m_tNeedMoney) do
            if value > 0 then 
                if not JudgeMoneyIsEnough(i, value,nil,nil,43, nil, nil, nil, nil, self, self.canBuy) then
                    return
                end
            end
        end
    else
        if not JudgeMoneyIsEnough(1,self.m_tNeedMoney[1],nil,nil,43, nil, nil, nil, nil, self, self.canBuy) then
    		return
        end
        -- if CacheCenter:getGameParam().isUseTicket == "0" then
            if not JudgeMoneyIsEnough(177,self.m_tNeedMoney[177],nil,nil,43, nil, nil, nil, nil, self, self.canBuy) then
    		    return
            end
        -- end
    end
    self:canBuy()
end

-- 购买成功回调
function WndBuy:BuyResult()
    self:closeLoading()
    if WndShop.m_root then
        WndShop:afterBuyAndSaveImage(self.realBuyItemId)
    end
    if WndKidDress.m_root then
        WndKidDress:cleanTryState()
    end
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 创建价格选择列表
function WndBuy:_update()
    local conSave =  GetElement(self.m_root,"conSave_WndBuy",WZUIContainer)
    local conGive =  GetElement(self.m_root,"conGive_WndBuy",WZUIContainer)

    if self.showType == 6 then
        conSave:setVisible(false)
        conGive:setVisible(true)
	elseif self.showType == 7 then
        conSave:setVisible(true)
        conGive:setVisible(false)
	elseif self.showType == 2 then
        conSave:setVisible(true)
        conGive:setVisible(false)
		GetElement(self.m_root,"conHide_WndBuy",WZUIContainer):setVisible(false)
    else
        conSave:setVisible(true)
        conGive:setVisible(false)
    end



	local tbcItem = WZUITableContainer:luaTo(self.m_root:getChildElement("tbcItemWndBuy"))
	tbcItem:cleanTable()
    self.cellData = {}
	for i = 1 ,#self.propData do
		local  cell, tcell = CellSelPrice:createElement()
        cell:setTag(i-1)
		tbcItem:setCellElement(cell)
        tcell:SetCellPriceData(self.propData[i])
        self:AddCurCellData(i,cell,tcell)
        tcell:SetCallBackFunc(self,self.updateMoney)
		if self.propData[i].initData.transaction == -1 then
			GetElement(self.m_root,"conHide_WndBuy",WZUIContainer):setVisible(false)
			GetElement(self.m_root,"conGive_WndBuy",WZUIContainer):setVisible(false)
		end
	end
	self:updateMoney()
end

--@brief	购买
function WndBuy:canBuy()
	local VansID = WZLuaVector_int_:create()
    local VansPriceID = WZLuaVector_int_:create()
    local VansPriceValue = WZLuaVector_int_:create()

    local butCnt = 0
    for i = 1, #self.cellData do
        local tcell = self.cellData[i].tcell
        local data = tcell:GetCurData()
        if data.index ~= -1 then
            VansID:push(data.id)
            VansPriceID:push(data.index)
            VansPriceValue:push(tcell:GetCurPropPrice())
            butCnt = butCnt + 1
            table.insert(self.realBuyItemId,data.id)
        end
    end

    -- 没有商品直接返回
    if butCnt == 0 then
        WindowManager:removeWindow(self.m_root, self, true)
        return
    end

    self.buyFlag = true
    g_bIsShowWndDressUp = false
    self:createLoading()

	local checked = tonumber(GetElement(self.m_root,"checkGroup_WndBuy",WZUICheckBoxGroup):getCheckIndex()) + 1
	WZLog("WndBuy:canBuy", checked)
    if self.m_tNeedMoney[35] and self.m_tNeedMoney[35] ~= 0 then 
        checked = 1
    end
	ProtocolProcessorWndShop:send_MALL_BuyItems(VansPriceID, VansID, checked, 0, self.selSex, nil, VansPriceValue)
end

-- 获取当前选择的商品信息
function WndBuy:getPropIdAndIndex()
    local VansID = WZLuaVector_int_:create()
    local VansPriceID = WZLuaVector_int_:create()
    for i = 1, #self.cellData do
        local tcell = self.cellData[i].tcell
        local data = tcell:GetCurData()
        if data.index ~= -1 then
            VansID:push(data.id)
            VansPriceID:push(data.index)
        end
    end

    return VansID,VansPriceID
end

-- 关闭窗口
function WndBuy:closeWndBuy()
    WindowManager:removeWindow(self.m_root, self, true)
end

function WndBuy:_adaptLanguage_vn()
    WZLog("WndBuy:_adaptLanguage_vn")

    local ftbBuyDesc = GetElement(self.m_root,"ftbBuyDesc_WndBuy",WZUIFreeTextBox)
    ftbBuyDesc:setRelativePosition(GlobalMethod:ccp(-0.0273973,0.5))
    ftbBuyDesc:setScale(0.9) 
end

function WndBuy:_adaptLanguage_tr()
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.55)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.55)

    GetElement(self.m_root,"ftbBuyDesc_WndBuy",WZUIFreeTextBox):setScale(0.8)
end
function WndBuy:_adaptLanguage_th()
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.7)
end
function WndBuy:_adaptLanguage_en()
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.65)
end

function WndBuy:_adaptLanguage_vn()
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.62)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.62)
end

function WndBuy:_adaptLanguage_pt()
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.7)
end

function WndBuy:_adaptLanguage_es()
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.7)
end

function WndBuy:_adaptLanguage_ug(  )
    local costText1 = GetElement(self.m_root,"costText1",WZUILabelTTF)
    costText1:setScale(0.55)
    costText1:setDimensions(GlobalMethod:CCSize(480))
    local costText2 = GetElement(self.m_root,"costText2",WZUILabelTTF)
    costText2:setScale(0.55)
    costText2:setDimensions(GlobalMethod:CCSize(480))

end
-------------------------------------私有方法模块End----------------------------------------
