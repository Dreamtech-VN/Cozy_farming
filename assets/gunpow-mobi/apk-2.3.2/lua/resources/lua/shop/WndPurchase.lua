--WndPurchase.lua
--@brief	WndPurchase的UI模块
--@date		2015-10-12
--@author	binshao
--@note		商城购买接口


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPurchase:onEnter(element)
    assert(0)
	self.m_root = element
	AdaptLanguage(self)
	WindowManagerAni:createAction(element,true)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPurchase:onExit(element)
	self:_unInit()
end

-- 改变购买价格
function WndPurchase:OnCellCallBack()
    local cost,count,showDay = self.curCellData.tcell:GetCurPropPrice()
	for i=1,3 do
		GetElement(self.m_root,"costShow"..i,WZUILabelTTF):setText(cost)
	end
	GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(false)
	GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(false)

	if self.costId == 1 then
		GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"costText1",WZUILabelTTF):setText(string.format(LocalStrings.SHOPBUY1, tostring(1),GDatatab_item["id_1"].name))
	elseif self.costId == 177 then
		GetElement(self.m_root,"conCost1",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conCost2",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"costText2",WZUILabelTTF):setText(string.format(LocalStrings.SHOPBUY1, tostring(1), GDatatab_item["id_177"].name))
        --越南粉钻不能用蓝钻代替
        GetElement(self.m_root, "checkInfo1_WndEquip", WZUICheckBox):setVisible(false)
	else
    	local ftb = GetElement(self.m_root,"ftbBuyDesc_WndPurchase",WZUIFreeTextBox)
		local icon = GDatatab_item["id_"..self.costId].icon
    	if showDay then
    		ftb:setShowText(string.format(LocalStrings.SHOP_BUY_DESC3,1,icon,cost))
    	else
    		ftb:setShowText(string.format(LocalStrings.SHOP_BUY_DESC3,count,icon,cost))
    	end
	end
end

-- 创建加载框
function WndPurchase:createLoading()
    if not self.m_nLoadingId then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox(15,self,self.closeLoading)
    end
end

-- 关闭加载框
function WndPurchase:closeLoading()
    if self.m_nLoadingId then
        WZLog("----------------close WndPurchase--------------",self.m_nLoadingId)
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
        self.m_nLoadingId = nil
    end
end


--@brief	商城购买接口入口函数
--@param	nBuyType: 商品类型：1:武器 2:头饰 3:脸谱 4：衣服 5：翅膀 6：道具 
--@param    id:物品id
--@param    sender：表名
--@param    callbackFunction：回调方法
--@param    nZorder：界面order用于聊天
--@param	other: 自定义回调，不用可为空
--@param	buyType:1:赠送,2:索要,3:购买
--@param	specialOffer  是否是特价限购
-- shopData 是否使用商城当前物品
-- isHideGiven 是否屏蔽索要按键，true为屏蔽
--@param    ownerId：物品所属玩家Id(针对小孩时装添加)
function WndPurchase:showBuyInterface(nBuyType,id,sender,callbackFunction,nZorder,other,shopData, buyType,hideGiven,shopId, specialOffer, ownerId, jumpBuyInfo)
	WZLog("WndPurchase:showBuyInterface",shopId)
	self.nZorder = nZorder
	--判断物品是否上架
	CacheCenter:getShopItems(function(t,shopItemList)
        self.tShopItemList = shopData or shopItemList

        -- 根据当前的商品ID，获取商品的信息，若获取失败，提示未上架
        local tData
        local isOnSale = false
		local inShop = (WndShop.m_root ~= nil and WndBagMain.m_root == nil) or jumpBuyInfo ~= nil
		if inShop and (WndShop.leftIndex == 3 or WndShop.leftIndex == 4 or (jumpBuyInfo and (jumpBuyInfo[1] == 3 or jumpBuyInfo[1] == 4))) then
			local leftTag = 1
			local tag = WndShop.leftIndex or jumpBuyInfo[1]
        	if tag == 2 then
        	    leftTag = WndShop.dressTopIndex or jumpBuyInfo[2]
        	elseif tag == 3 then
        	    leftTag = WndShop.propTopIndex or jumpBuyInfo[2]
        	elseif tag == 4 then
        	    leftTag = WndShop.limitTopIndex or jumpBuyInfo[2]
			end
        	for k,v in pairs(self.tShopItemList) do
				local mainType
				local subType
        		local curType = json.decode(v.mainType)
        		for k,v in pairs(curType) do
        		    mainType = tonumber(k)
					subType = tonumber(v)
        		end
                if shopId then
                    if v.shopItemId == id and v.id == shopId and mainType == tag and subType == leftTag and v.isOnSale == true then
                        tData = v
                        isOnSale = v.isOnSale
                        break
                    end
                else
            	    if v.shopItemId == id and mainType == tag and subType == leftTag and v.isOnSale == true then
            	        tData = v
            	        isOnSale = v.isOnSale
            	        break
            	    end
                end
        	end
			WZLog("购买路径1")
		elseif inShop and (WndShop.leftIndex == 1) then
        	for k,v in pairs(self.tShopItemList) do
        	    if v.shopItemId == id and v.id == shopId then
        	        tData = v
        	        isOnSale = v.isOnSale
        	        break
        	    end
        	end
			WZLog("购买路径2")
		elseif inShop and (WndShop.leftIndex == 2 or (jumpBuyInfo and jumpBuyInfo[1] == 2)) then
        	for k,v in pairs(self.tShopItemList) do
                if shopId then
                    if v.shopItemId == id and v.id == shopId then
                        tData = v
                        isOnSale = v.isOnSale
                        break
                    end
                else
            	    if v.shopItemId == id then
            	        tData = v
            	        isOnSale = v.isOnSale
            	        break
            	    end
                end
        	end
			WZLog("购买路径3")
		elseif inShop and (WndShop.leftIndex == 5) then
        	for k,v in pairs(self.tShopItemList) do
				local mainType
				local subType
        		local curType = json.decode(v.mainType)
        		for k,v in pairs(curType) do
        		    mainType = tonumber(k)
					subType = tonumber(v)
        		end
				if CacheCenter:getPlayerItemById(id) == nil then
                    if shopId then
                        if v.shopItemId == id and v.id == shopId and mainType == WndShop.leftIndex then
                            tData = v
                            isOnSale = v.isOnSale
                            break
                        end
                    else
            	    	if v.shopItemId == id and mainType == WndShop.leftIndex then
            	    	    tData = v
            	    	    isOnSale = v.isOnSale
            	    	    break
            	    	end
                    end
				else
                    if shopId then
                        if v.shopItemId == id and v.id == shopId and mainType == 2 then
                            tData = v
                            isOnSale = v.isOnSale
                            break
                        end
                    else
            	    	if v.shopItemId == id and mainType == 2 then
            	    	    tData = v
            	    	    isOnSale = v.isOnSale
            	    	    break
            	    	end
                    end
				end
        	end
			WZLog("购买路径4")
		else
            local tempData = nil --出现在商城表但是没有上架的物品数据
        	for k,v in pairs(self.tShopItemList) do
				local mainType
				local subType
        		local curType = json.decode(v.mainType)
        		for k,v in pairs(curType) do
        		    mainType = tonumber(k)
					subType = tonumber(v)
        		end
                if shopId then
                    if v.shopItemId == id and v.id == shopId and mainType ~= 5 and mainType ~= 4 then
                        tData = v
                        isOnSale = v.isOnSale
                        tempData = nil
                        break
                    end
                else
                    --商城表可能出现多个相同itemid,但是有些没上架的情况,所以商城表发现目标物品但目标物品没上架的话就继续循环,直到找到一个上架的目标物品
                    if v.shopItemId == id and mainType ~= 5 and mainType ~= 4 and v.isOnSale == true then
            	        tData = v
            	        isOnSale = v.isOnSale
                        tempData = nil
                        break
                    elseif tempData == nil and v.shopItemId == id and mainType ~= 5 and mainType ~= 4 and v.isOnSale == false then --这里判断是目标物品但是物品没有上架就继续循环,直到循环结束都没有一个上架的话就默认选第一个商品
                        tempData = v
                    end
                end
        	end
            if tempData ~= nil then
                tData = v
            end
			--WZLog("日志1",Serialize(tData))
			WZLog("购买路径5")
		end
		if tData == nil then
        	for k,v in pairs(self.tShopItemList) do
                if shopId then
                    if v.shopItemId == id and v.id == shopId then
                        tData = v
                        isOnSale = v.isOnSale
                        break
                    end
                else
            	    if v.shopItemId == id then
            	        tData = v
            	        isOnSale = v.isOnSale
            	        break
            	    end
                end
        	end
			--WZLog("日志2",Serialize(tData))
			WZLog("购买路径6")
		end
        --商品未上架，弹出提示
        if isOnSale == false and tData and tData.basicInfo and tData.basicInfo.sale_again == 0 then
			if id == 191 or id == 189 or id == 190 then
				MsgBoxManager:showTipBox(LocalStrings.ASCENDING22)
				return
			end
            MsgBoxManager:showTipBox(LocalStrings.ITEMNOTSALE)
            return
        end

        if self.m_root == nil then
            local wndPurchase = WndPurchase:createElement()
            if nZorder~=nil then wndPurchase:setZOrder(nZorder) end
            wndPurchase:setVisible(false)
            WindowManager:addWindow(wndPurchase,WndPurchase,true,nil,nil)
        end

        self.m_sender=sender
        self.m_callFunction=callbackFunction
        self.m_sOther = other
        self.m_nBuyType = nBuyType
        if tData then
            self.m_nGoodsID = tData.id
        end
        self.m_root:setVisible(true)
		self.specialOffer = specialOffer
        self.m_nOwnerId = ownerId

        local tempData = {}
        if tData and tData.mainType then
            tempData.initData = CopyTable(tData)
            local curType = json.decode(tData.mainType)
            for k,v in pairs(curType) do
                local mainType = tonumber(k)
                local subType = tonumber(v)
                tempData.mainType = mainType
                tempData.subType = subType
            end
            self.costId = tempData.initData.moneyId
        end
        if WndShop.leftIndex == 6 then 
            tempData.initData.moneyId = tempData.initData.moneyId2
        end
        
        WZLog("CCCCCCCCCCCCCCCCCCCC", Serialize(tempData))
        local tagProp = GetElement(self.m_root, "tabProp_WndPurchase", WZUITableContainer)
        local cell, tcell =  CellSelCount:createElement()
        cell:setTag(0)
        tagProp:setCellElement(cell)
        self:_addCurCellData(cell,tcell)
        tcell:SetCallBackFunc(self,self.OnCellCallBack)
        tcell:SetCellPriceData(tempData)

        self.buyType = buyType or 4
        WZLog("--------------------self.buyTpe-----------------",self.buyType)
        -- 初始化btn的描述
        local str = {LocalStrings.GIVE,LocalStrings.SHOP_BUY_DESC1,LocalStrings.BUY,LocalStrings.BUY}
        WZLog("------------------btnName----------------",self.buyType,str[self.buyType])
        local btnName = GetElement(self.m_root, "txtBtnName_WndPurchase", WZUILabelTTF)
        btnName:setText(str[self.buyType])

        -- 初始化标题
        local str = {LocalStrings.SHOP_DESC10,LocalStrings.SHOP_DESC11,LocalStrings.PURCHASE,LocalStrings.PURCHASE }
        local txtTitle = GetElement(self.m_root, "txtTitle_WndPurchase", WZUILabelTTF)
        txtTitle:setText(str[self.buyType])

        self.selData = tempData
		WZLog("商品信息",Serialize(self.selData))

        local btn = GetElement(self.m_root, "btnGiven_WndPurchase", WZUIButton)
        local ios = tonumber(CacheCenter:getGameParam().gameStatus)
        local isHideGiven = false
        if tData then
            isHideGiven = tData.transaction == -1 and true or false
        end
		if hideGiven == true then isHideGiven = true end
        if ios == 1 or isHideGiven then
            btn:setVisible(false)
        else
            local isDress = WndShop:judgePropIsDress(self.selData)
            WZLog("888888888888888", isDress, WndShop:selSexIsSame(), self.buyType)
            if self.buyType == 1 then
                if (isDress and WndShop:selSexIsSame()) or (not isDress) then
                    btn:setVisible(true)
                else
                    btn:setVisible(false)
                end
            else
                btn:setVisible(self.buyType == 4)
            end
        end
    end)
end


--@brief	购买成功后回调
--@param	与协议字段一致
function WndPurchase:BuyResult()
	--调用回调函数
	if self.m_sender ~= nil and self.m_callFunction ~= nil then
		self.m_callFunction(self.m_sender)
	end

    local curData = self.curCellData.tcell:GetCurCellData()
    local id = curData.id
    local count = curData.data[curData.tag].num
    
    for i = #NOTRECYCLEIDS, 1 ,-1 do
        if NOTRECYCLEIDS[i] == CacheCenter:getShopGoodData(id).basicInfo.id and count == -1 then
            table.remove(NOTRECYCLEIDS, i)
        end
    end

    self:closeLoading()
    -- 更新限购商品的个数
    WndShop:UpdatePropLimitCount(id, count)
    -- 移除当前窗口
    local isDress = WndShop:judgePropIsDress(self.selData)
    --时装、购买第一个、限购 关闭购买窗口
    if isDress or curData.index == 0 or self.selData.mainType == 4 or self.selData.initData.limitLeave ~= -1 then 
        WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
    end
end
--------------------------------------------------------------------------------------

----------------------------------------关于界面点击----------------------------------
--@brief	关闭窗口
--@param	element:表绑定的UI节点引用
function WndPurchase:onclickClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    if self.m_callFunction~=nil and self.m_sender~=nil and self.m_bBuyResult then
		self.m_callFunction(self.m_sender)
	end

    WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
end

--@brief    关闭界面回调
function WndPurchase:onTempClose()
    WZLog("WndPurchase:onTempClose")
    if self.m_callFunction~=nil and self.m_sender~=nil and self.m_bBuyResult then
        self.m_callFunction(self.m_sender)
    end
    WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
end

-- 索要
function WndPurchase:onGiven()
	WZLog("WndPurchase:onGiven",type(self.selData),self.selData)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    local isDress = WndShop:judgePropIsDress(self.selData)
    local cost = self.curCellData.tcell:GetCurPropPrice()
    WZLog("-------------WndPurchase onGiven----------------",self.buyType,isDress)
    local sex = isDress and WndShop:getShopSelSex() or 2
    local price2 = 0
    if self.curCellData.tcell:GetTData().initData.moneyId == 177 then --越南粉钻
        price2 = cost
    end
    WndShopGiven:showWnd(2,{self.selData},cost,sex,price2)
end

function WndPurchase:clickSure()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local cost = self.curCellData.tcell:GetCurPropPrice()
    local data = self.curCellData.tcell:GetCurCellData()
    
    if self.buyType == 1 then
        local needVip = tonumber(CacheCenter:getGameParam().mallOperateVip)
        local needLv = tonumber(CacheCenter:getGameParam().mallOperatePlayerLevel)
        local curVip = CacheCenter:getPlayerInfo().vipLevel
        local curLv = CacheCenter:getPlayerInfo().level
        WZLog("----------------vip limit-------------------",curVip,needVip,needLv)
        if curVip >= needVip then
            if curLv < needLv then
                MsgBoxManager:showTipBox(string.format(LocalStrings.SHOP_DESC14,needLv))
                return
            end
        local checked = tonumber(GetElement(self.m_root,"checkGroup_WndBuy",WZUICheckBoxGroup):getCheckIndex())
        if checked == 1 then
            if JudgeMoneyIsEnough(1,cost,nil,nil,43, nil, nil, nil, nil) then
                self:_canBuy2()
                return
            else
                return  
            end
        end
            if JudgeMoneyIsEnough(data.moneyId,cost,nil,nil,43, nil, nil, nil, nil, self, self._canBuy1) then
                self:_canBuy1()
            end
        else
            local function vipNotEnough()
                WndVip:showWndUI(0)
            end
            MsgBoxManager:showConfirmBox(LocalStrings.SHOP_DESC9, nil, vipNotEnough)
        end
    elseif self.buyType == 2 then
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        local isDress = WndShop:judgePropIsDress(self.selData)
        WZLog("-------------WndPurchase onclickBuy----------------",self.buyType,isDress)
        local sex = isDress and WndShop:getShopSelSex() or 2

        local price2 = 0
        if self.curCellData.tcell:GetTData().initData.moneyId == 177 then --越南粉钻
            price2 = cost
        end

        WndShopGiven:showWnd(2,{self.selData},cost,sex,price2)
    elseif self.buyType == 3 or self.buyType == 4 then
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        local checked = tonumber(GetElement(self.m_root,"checkGroup_WndBuy",WZUICheckBoxGroup):getCheckIndex())
        if checked == 1 then
            if JudgeMoneyIsEnough(1,cost,nil,nil,43, nil, nil, nil, nil) then
                self:_canBuy2()
                return
            else
                return  
            end
        end
    WZLog("--------------WndPurChasejj-------------------",cost)
        if  JudgeMoneyIsEnough(data.moneyId,cost,nil,nil,43, nil, nil, nil, nil, self, self._canBuy2) then
            self:_canBuy2()
        end
    end
end

--@brief	点击单件购买
--@param	element:表绑定的UI节点引用
function WndPurchase:onclickBuy(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local cost = self.curCellData.tcell:GetCurPropPrice()
    local data = self.curCellData.tcell:GetCurCellData()
    WZLog("--------------WndPurChase?-------------------",self.buyType)
    WZLog("--------------WndPurChase-------------------",cost)
    WZLog("--------------WndPurChase-------------------",data.moneyId)
	--性别不符不能购买
	local itemSex = self.selData.initData.basicInfo.sex
    --小孩物品不检测性别
    WZLog("--------------WndPurChase-------------------", CacheCenter:getPlayerInfo().sex, itemSex)
    if self.selData.initData.basicInfo.main_type ~= 31 then
    	if itemSex ~= CacheCenter:getPlayerInfo().sex and itemSex ~= 2 and self.buyType ~= 1 then
    		MsgBoxManager:showTipBox(LocalStrings.CANTBUY)
    		return
    	end
    end
	if tonumber(cost) == 0 then
		MsgBoxManager:showTipBox(LocalStrings.CANTBUY)
		return
	end

    --兑换判断如果该物品已下架，则关闭窗口，并提示
    if self.selData.mainType == 5 and self.selData.initData.discountTime > 0 and self.selData.initData.discountTime <= SystemTime:getServerTime() then 
        MsgBoxManager:showTipBox(LocalStrings.SHOP_GOODS_TIMEOUT)
        WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
        return 
    end

        --人物等级少于使用物品等级时弹出提示框
    local level = CacheCenter:getPlayerInfo().level
    WZLog("点击单件购买",level,self.selData.initData.basicInfo.use_level)
    if tonumber(level) <= self.selData.initData.basicInfo.use_level and not ISSHOW_USELEVEL then
        MsgBoxManager:showConfirmBoxWithBg(string.format(LocalStrings.USE_LEVEL_CONTENT,self.selData.initData.basicInfo.use_level),self,self.clickSure,MSGBOXLEVEL_HIGH,nil,true)
        return
    end
    if self.buyType == 1 then
        local needVip = tonumber(CacheCenter:getGameParam().mallOperateVip)
        local needLv = tonumber(CacheCenter:getGameParam().mallOperatePlayerLevel)
        local curVip = CacheCenter:getPlayerInfo().vipLevel
        local curLv = CacheCenter:getPlayerInfo().level
        WZLog("----------------vip limit-------------------",curVip,needVip,needLv)
        if curVip >= needVip then
            if curLv < needLv then
                MsgBoxManager:showTipBox(string.format(LocalStrings.SHOP_DESC14,needLv))
                return
            end
		local checked = tonumber(GetElement(self.m_root,"checkGroup_WndBuy",WZUICheckBoxGroup):getCheckIndex())
		if checked == 1 then
        	if JudgeMoneyIsEnough(1,cost,nil,nil,43, nil, nil, nil, nil) then
            	self:_canBuy2()
				return
			else
				return	
			end
		end
            if JudgeMoneyIsEnough(data.moneyId,cost,nil,nil,43, nil, nil, nil, nil, self, self._canBuy1) then
                self:_canBuy1()
            end
        else
            local function vipNotEnough()
                WndVip:showWndUI(0)
            end
            MsgBoxManager:showConfirmBox(LocalStrings.SHOP_DESC9, nil, vipNotEnough)
        end
    elseif self.buyType == 2 then
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        local isDress = WndShop:judgePropIsDress(self.selData)
        WZLog("-------------WndPurchase onclickBuy----------------",self.buyType,isDress)
        local sex = isDress and WndShop:getShopSelSex() or 2

        local price2 = 0
        if self.curCellData.tcell:GetTData().initData.moneyId == 177 then --越南粉钻
            price2 = cost
        end

        WndShopGiven:showWnd(2,{self.selData},cost,sex,price2)
    elseif self.buyType == 3 or self.buyType == 4 then
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        local pCnt = CacheCenter:getPlayerItemCountById(tonumber(data.moneyId))
        if pCnt < tonumber(self.selData.initData.floorPrice) then
            if tonumber(data.moneyId) == 1 then
                -- WndVip:showWndUI(0)
                if JudgeMoneyIsEnough(1,cost,nil,nil,43, nil, nil, nil, nil) then
                    self:_canBuy2()
                end
            elseif tonumber(data.moneyId) == 177 then
                -- WndVip:showWndUI(0)
                if JudgeMoneyIsEnough(177,cost,nil,nil,43, nil, nil, nil, nil) then
                    self:_canBuy2()
                end
            else
                MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
            end
            return
        end
		local checked = tonumber(GetElement(self.m_root,"checkGroup_WndBuy",WZUICheckBoxGroup):getCheckIndex())
		if checked == 1 then
        	if JudgeMoneyIsEnough(1,cost,nil,nil,43, nil, nil, nil, nil) then
            	self:_canBuy2()
				return
			else
				return	
			end
		end
    WZLog("--------------WndPurChasejj-------------------",cost)
        if  JudgeMoneyIsEnough(data.moneyId,cost,nil,nil,43, nil, nil, nil, nil, self, self._canBuy2) then
            self:_canBuy2()
        end
    end
end

--@brief    执行购买
function WndPurchase:_canBuy1()
    -- body
    local cost = self.curCellData.tcell:GetCurPropPrice()
    local isDress = WndShop:judgePropIsDress(self.selData)
    WZLog("-------------WndPurchase:_canBuy1----------------",self.buyType,isDress)
    local sex = isDress and WndShop:getShopSelSex() or 2

    local price2 = 0
    if self.curCellData.tcell:GetTData().initData.moneyId == 177 then --越南粉钻
        price2 = cost
    end

    WndShopGiven:showWnd(1,{self.selData},cost,sex,price2)
end

--@brief    执行购买2
function WndPurchase:_canBuy2()
    -- body
    local cost = self.curCellData.tcell:GetCurPropPrice()
    local data = self.curCellData.tcell:GetCurCellData()
    local index = data.index
    local id = data.id
    local count = WZLuaVector_int_:create()
    count:push(index)
    local mallId = WZLuaVector_int_:create()
    mallId:push(id )
    local price = WZLuaVector_int_:create()
    price:push(cost )

    -- 如果玩家拥有该物品的无限期，则不需要购买
    local info = self.curCellData.tcell:GetTData()
    if checkIsIndefinite(info.shopItemId) then
        MsgBoxManager:showTipBox(LocalStrings.SHOP_NO_NEED, nil, nil, nil, nil)
        WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
        return
    end
    self.buyFlag = true
    g_bIsShowWndDressUp = false
    self:createLoading()
	local checked = tonumber(GetElement(self.m_root,"checkGroup_WndBuy",WZUICheckBoxGroup):getCheckIndex()) + 1
	WZLog("WndBuy:canBuy", checked)
    local nKidSex = 9
    WZLog("WndPurchase:_canBuy2   FFFFF", Serialize(self.selData))
    if self.selData.initData.basicInfo.main_type == 31 then
        local tCurKidData = SceneKidHome.m_tKidData[WndKidDress.m_nKidIndex]
        if tCurKidData then
            nKidSex = tCurKidData.sex
        end
    end
    WZLog("WndPurchase:_canBuy2   GGGGG", type(nKidSex), type(self.m_nOwnerId), nKidSex, self.m_nOwnerId)
	if self.specialOffer then
    	ProtocolProcessorWndShop:send_MALL_BuyItems(count, mallId, checked, 1, nKidSex, self.m_nOwnerId, price)
	else
    	ProtocolProcessorWndShop:send_MALL_BuyItems(count, mallId, checked, 0, nKidSex, self.m_nOwnerId, price)
	end
    TeachGroup1:endTeachStep({26,7})
    PostPlayerEvent:postEvent(PostPlayerEvent.event_tenLvClickPay)
    
    local isEndTeach26, teachStep26 = TeachGroup1:isTeachFinish(26)
    if isEndTeach26 ~= true and CacheCenter:getPlayerInfo().level <= 10 and  (TeachGroup1:isTaskTeachFinish(TeachGroup1.TASK_ID_7) or TeachGroup1.ISTEACHMODE) then
        --TeachGroup1:startGroupLevelUp(false, false, true, {26,8,GlobalGame.g_tWndBottomBarObj.m_root})

        WindowManager:removeTeachShelterLayer()
        WindowManager:addTeachShelterLayer( 999999 )
    end
end

-- 获取当前选择的商品信息
function WndPurchase:getPropIdAndIndex()
    local data = self.curCellData.tcell:GetCurCellData()
    local index = data.index
    local id = data.id
    WZLog("------------WndPurchase:getPropIdAndIndex------------",index,id)
    local count = WZLuaVector_int_:create()
    count:push(index)
    local mallId = WZLuaVector_int_:create()
    mallId:push(id )


    return mallId,count
end

function WndPurchase:closeWndBuy()
    WindowManagerAni:createDisappearAction(self.m_root,nil,self, true)
end

-------------------------------------公有方法模块End----------------------------------------

----------------------------------------语言适配Begin--------------------------------------
function WndPurchase:_adaptLanguage_en(  )
    local ftbBuy = GetElement(self.m_root,"ftbBuyDesc_WndPurchase",WZUIFreeTextBox)
    ftbBuy:setScale(0.8)
    ftbBuy:setMaxWidth(600)
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.65)
end

function WndPurchase:_adaptLanguage_pt(  )
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.7)
end

function WndPurchase:_adaptLanguage_es(  )
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.7)
end

function WndPurchase:_adaptLanguage_th(  )
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.7)
end

function WndPurchase:_adaptLanguage_vn(  )
    GetElement(self.m_root,"costText1",WZUILabelTTF):setScale(0.62)
    GetElement(self.m_root,"costText2",WZUILabelTTF):setScale(0.62)
end

function WndPurchase:_adaptLanguage_tr(  )
    local costText1 = GetElement(self.m_root,"costText1",WZUILabelTTF)
    costText1:setScale(0.55)
    costText1:setDimensions(GlobalMethod:CCSize(480))
    local costText2 = GetElement(self.m_root,"costText2",WZUILabelTTF)
    costText2:setScale(0.55)
    costText2:setDimensions(GlobalMethod:CCSize(480))
end

function WndPurchase:_adaptLanguage_ug(  )
    local costText1 = GetElement(self.m_root,"costText1",WZUILabelTTF)
    costText1:setScale(0.55)
    costText1:setDimensions(GlobalMethod:CCSize(480))
    local costText2 = GetElement(self.m_root,"costText2",WZUILabelTTF)
    costText2:setScale(0.55)
    costText2:setDimensions(GlobalMethod:CCSize(480))

    local txtGiven = GetElement(self.m_root,"txtGiven_WndPurchase",WZUILabelTTF)
    txtGiven:setScale(0.7)
    txtGiven:setDimensions(GlobalMethod:CCSize(150))
    local txtBtnName = GetElement(self.m_root,"txtBtnName_WndPurchase",WZUILabelTTF)
    txtBtnName:setScale(0.7)
    txtBtnName:setDimensions(GlobalMethod:CCSize(150))
end
-----------------------------------------语言适配End----------------------------------------