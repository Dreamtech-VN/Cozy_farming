--WndBuyMultipleItem.lua
--@brief	WndBuyMultipleItem的UI模块
--@date		2017/02/16
--@author	qixiang
--@note		用于购买多个物品


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndBuyMultipleItem:onEnter(element)
	self.m_root = element
	self:initUI()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndBuyMultipleItem:onExit(element)
	self:_unInit()
end

--@brief	开始点击窗口后的回调
--@param	element:窗口绑定的lua表
--@param    pt:坐标点
function WndBuyMultipleItem:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
    WndTips:onCloseClick()
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndBuyMultipleItem:onClickListItem(tItem, nTag, tData)
    WZLog("WndBuyMultipleItem:onClickListItem")
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false)
end

function WndBuyMultipleItem:initUI()
	-- body
	WZLog("WndBuyMultipleItem:initUI")
	local txtOwn = GetElement(self.m_root,"txtOwn_WndBuyMultipleItem",WZUILabelTTF)
	local imgCostItem = GetElement(self.m_root,"imgCostItem_WndBuyMultipleItem",WZUIImage)
	local itemInfo = GDatatab_item["id_" .. self.m_ncostId]
	local icon = itemInfo.icon
	imgCostItem:setFile(icon)
	if self.m_showtype == 4 and (self.m_ncostId == 160077 or self.m_ncostId == 160139) then
		imgCostItem:setScale(0.6)
		txtOwn:setVisible(false)
	elseif self.m_showtype == 3 then 
		imgCostItem:setScale(0.6)
	elseif self.m_showtype == 5 or self.m_showtype == 6 then 
		imgCostItem:setScale(0.6)
	end

	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndBuyMultipeItem",WZUILabelTTF)
	txtCostNum:setText(self.m_ncostCount)

	
	local diamondCount = CacheCenter:getPlayerItemCountById(self.m_ncostId)
	local temp = string.format(LocalStrings.PETHASNUM,diamondCount)
	txtOwn:setText(temp)	

	local conChest = GetElement(self.m_root,"conChest_WndBuyMultipleItem",WZUIContainer)
	local eItem, tItem = CellGoodItem:createElement()
    tItem:setItemClickFun(self, self.onClickListItem)
    local tData = nil
    local txtTitle = GetElement(self.m_root,"txtTitle_WndBuyMultipleItem",WZUILabelTTF)
    if self.m_showtype == 4 then
    	txtTitle:setText(LocalStrings.GAME_ACIVIITY_OLD_EXCHANGE)
	    tData = {
	        id = self.m_nitemId,
	        lastNum = self.m_tLimitConfig[1],
	        lastTime = self.m_tLimitConfig[1],
	        isUse = false,
	        data = "",
	        playerItemId = -1,
	        isZero = true,
	        basicInfo = GetItemLocalData(self.m_nitemId)
	    }
	else
		txtTitle:setText(LocalStrings.BUY)
		tData = {
	        id = self.m_nitemId,
	        lastNum = self.m_nitemCount,
	        lastTime = self.m_nitemCount,
	        isUse = false,
	        data = "",
	        playerItemId = -1,
	        isZero = true,
	        basicInfo = GetItemLocalData(self.m_nitemId)
	    }
	end
    tItem:setCellGoodItem(tData,4)
    conChest:addChild(eItem)

    local txtTips = GetElement(self.m_root,"txtTips_WndBuyMultipleItem",WZUILabelTTF)
    txtTips:setText(LocalStrings.OPENCHEST1)
    if self.m_showtype == 1 then
    	GetElement(self.m_root,"mutiReduce_WndBuyMultipleItem",WZUIButton):setVisible(false)
    	GetElement(self.m_root,"mutiAdd_WndBuyMultipleItem",WZUIButton):setVisible(false)
    	if self.m_limitNum then
    		-- OPENCHEST2 = "每日限购%d个(剩余%d个)",
	    	txtTips:setText(string.format(LocalStrings.OPENCHEST2, math.min(self.m_nitemCount,self.m_limitNum), self.m_limitNum))
	    end
	    GetElement(self.m_root,"conCost_WndBuyMultipleItem",WZUIContainer):setVisible(true)
	    GetElement(self.m_root,"conOperation",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	    if self.m_nitemCount and self.m_limitNum then
		    local nCurNum = math.min(self.m_nitemCount ,self.m_limitNum) > 0 and math.min(self.m_nitemCount ,self.m_limitNum) or 1
		    self.m_nNum = nCurNum
		end
	    GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	    self:updateCostCount()
	elseif self.m_showtype == 3 then 
		if self.m_tLimitConfig then 
			if self.m_tLimitConfig[1] == 1 then
				if self.m_limitNum then
			    	txtTips:setText(string.format(LocalStrings.MAGIC_STONE_TEXT17, self.m_tLimitConfig[2], self.m_limitNum))
			    end 
			elseif self.m_tLimitConfig[1] == 2 then 
				GetElement(self.m_root,"mutiReduce_WndBuyMultipleItem",WZUIButton):setVisible(false)
		    	GetElement(self.m_root,"mutiAdd_WndBuyMultipleItem",WZUIButton):setVisible(false)
		    	if self.m_limitNum then
			    	txtTips:setText(string.format(LocalStrings.MAGIC_STONE_TEXT16, self.m_tLimitConfig[2], self.m_limitNum))
			    end
			end
		end
	elseif self.m_showtype == 4 then
		GetElement(self.m_root,"mutiReduce_WndBuyMultipleItem",WZUIButton):setVisible(false)
    	GetElement(self.m_root,"mutiAdd_WndBuyMultipleItem",WZUIButton):setVisible(false)
	    GetElement(self.m_root,"conCost_WndBuyMultipleItem",WZUIContainer):setVisible(true)
	    GetElement(self.m_root,"conOperation",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.53))
	    self.m_nNum = 1
	    if self.m_limitNum then
    		if self.m_limitNum < 0 then
    			txtTips:setVisible(false)
    		else
    			if self.m_tLimitConfig and self.m_tLimitConfig[2] == 2 then
    				txtTips:setText(string.format(LocalStrings.OPENCHEST3, self.m_nitemCount, self.m_limitNum))
    			else
			    	txtTips:setText(string.format(LocalStrings.OPENCHEST2, self.m_nitemCount, self.m_limitNum))
			    end
		    end
	    end
	    GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	    self:updateCostCount()
	elseif self.m_showtype == 6 then 
		if self.m_tLimitConfig and self.m_tLimitConfig[1] then 
			GetElement(self.m_root,"mutiReduce_WndBuyMultipleItem",WZUIButton):setVisible(false)
	    	GetElement(self.m_root,"mutiAdd_WndBuyMultipleItem",WZUIButton):setVisible(false)
	    	if self.m_limitNum then
		    	txtTips:setText(string.format(LocalStrings.MAGIC_STONE_TEXT16, self.m_tLimitConfig[1], self.m_limitNum))
		    end
		end
    end
end

--更新购买价格
function WndBuyMultipleItem:updateCostCount()
	WZLog("WndBuyMultipleItem:updateCostCount")
	local useNum = GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF)
	local num = tonumber(useNum:getText())
	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndBuyMultipeItem",WZUILabelTTF)
	local costCount = num * self.m_ncostCount
	txtCostNum:setText(costCount)
end

function WndBuyMultipleItem:onClose(element)
	-- body
	WZLog("WndBuyMultipleItem:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	关闭窗口
function WndBuyMultipleItem:closeWin()
	if self.m_root == nil then return end 
	
	WindowManager:removeWindow(self.m_root, self, true)
end

--购买
function WndBuyMultipleItem:onClickBuy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndBuyMultipleItem:onClickBuy")
	if self.m_limitNum and self.m_limitNum < 0 then
		if self.m_nNum <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.PEOPLE_SHOP_TEXT17)
			return
		end
	else
		if self.m_nitemCount <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.COMMUNITY_SHOP_OWN_COUNT)
			return
		end
	end

	if self.m_showtype == 3 then 
		if g_cityExtenInfo.magicStoneStatus == 0 then 
			MsgBoxManager:showTipBox(LocalStrings.MAGIC_STONE_TEXT23)
			return 
		end
	end
	
	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndBuyMultipeItem",WZUILabelTTF)
	local costNum = tonumber(txtCostNum:getText())
	local diamondCount = CacheCenter:getPlayerItemCountById(self.m_ncostId)
	local name = GDatatab_item["id_" .. self.m_ncostId].name
	if costNum > diamondCount then
		if self.m_ncostId == 160139 then
			MsgBoxManager:showTipBox(LocalStrings.ACTIVITY_TEXT122)
		else
			WndFastGetItems:show(self.m_ncostId)
			MsgBoxManager:showTipBox(string.format(LocalStrings.CARD_COUNT1,name))	
		end
		return
	end
	
	if self.m_buyCallbackLua and self.m_buyCallbackFun then
		self.m_buyCallbackFun(self.m_buyCallbackLua,self.m_nitemId,self.m_nNum,self.m_nStoreId)
		WindowManager:removeWindow(self.m_root, self, true)
	end
end

--一次减十个
function WndBuyMultipleItem:onMutiReduce(element)
	WZLog("WndBuyMultipleItem:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 10 then
		self.m_nNum = self.m_nNum - 10
	elseif self.m_nNum > 1 then
		self.m_nNum = 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--一次减一个
function WndBuyMultipleItem:onReduce(element)
	WZLog("WndBuyMultipleItem:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--一次加一个
function WndBuyMultipleItem:onAdd(element)
	WZLog("WndBuyMultipleItem:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local useNum_WndBuyMultipleItem = GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF)
	local max = math.min(self.m_nitemCount, 100)
	if self.m_limitNum then 
		if self.m_limitNum < 0 then
			local num = CacheCenter:getPlayerItemCountById(160077)
			self.m_nNum = self.m_nNum + 1
			if (self.m_ncostCount*self.m_nNum) > num then
				MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
				self.m_nNum = self.m_nNum - 1
				return
			end
			useNum_WndBuyMultipleItem:setText(self.m_nNum)
			self:updateCostCount()
			return
		else
			max = math.min(self.m_nitemCount,self.m_limitNum) 
		end
	end
	if self.m_showtype == 3 or self.m_showtype == 5 or self.m_showtype == 6 then 
		max = self.m_limitNum
	end
	if self.m_nNum + 1 <= max then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	useNum_WndBuyMultipleItem:setText(self.m_nNum)
	self:updateCostCount()
end

--@brief	增加10个
function WndBuyMultipleItem:onMutiAdd(element)
	WZLog("WndBuyMultipleItem:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local max = math.min(self.m_nitemCount, 100)
	if self.m_limitNum then max = math.min(self.m_nitemCount ,self.m_limitNum) end
	if self.m_showtype == 3 or self.m_showtype == 5 or self.m_showtype == 6 then 
		max = self.m_limitNum
	end
	if self.m_nNum + 10 <= max then
		self.m_nNum = self.m_nNum + 10
	else
		if self.m_nNum >= max then
			MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
			return
		else
			self.m_nNum = max
		end
	end
	GetElement(self.m_root,"useNum_WndBuyMultipleItem",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndBuyMultipleItem:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtCost_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.114308,0.5))
	GetElement(self.m_root,"imgCostItem_WndBuyMultipleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.260157,0.5))
	GetElement(self.m_root,"txtOwn_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.642858,0.5))
	GetElement(self.m_root,"txtTips_WndBuyMultipleItem",WZUILabelTTF):setScale(0.7)
end

function WndBuyMultipleItem:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtCost_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.114308,0.5))
	GetElement(self.m_root,"imgCostItem_WndBuyMultipleItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.260157,0.5))
	GetElement(self.m_root,"txtOwn_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.642858,0.5))
end

function WndBuyMultipleItem:_adaptLanguage_es(  )
	local txtCost = GetElement(self.m_root,"txtCost_WndBuyMultipleItem",WZUILabelTTF)
	txtCost:setRelativePosition(GlobalMethod:ccp(0.145,0.5))
	local txtOwn = GetElement(self.m_root,"txtOwn_WndBuyMultipleItem",WZUILabelTTF)
	txtOwn:setRelativePosition(GlobalMethod:ccp(0.634,0.5))
	GetElement(self.m_root,"txtTips_WndBuyMultipleItem",WZUILabelTTF):setScale(0.7)
end

function WndBuyMultipleItem:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtCost_WndBuyMultipleItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.171451,0.5))
end
-------------------------------------私有方法模块End----------------------------------------
