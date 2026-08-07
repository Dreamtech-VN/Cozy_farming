--WndMagicBuyLevel.lua
--@brief	WndMagicBuyLevel的UI模块
--@date		2019/10/23
--@author	Tianxiang_Xu
--@note		幻石系统-购买等级界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMagicBuyLevel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMagicBuyLevel:onExit(element)
	self:_unInit()
end

--@brief	界面加载完成回调
function WndMagicBuyLevel:onEnterTransitionDidFinish(element)
	--body
	local sBuyCost = CacheCenter:getGameParam().stonelevelcost
	local string = string.sub(sBuyCost, 2, -2) 
	self.m_ncostId = tonumber(SplitStringWithSeparator(string,",")[1])
	self.m_ncostCount = tonumber(SplitStringWithSeparator(string,",")[2])

	self:initUI()
end


function WndMagicBuyLevel:initUI()
	-- body
	WZLog("WndMagicBuyLevel:initUI")
	local imgCostItem = GetElement(self.m_root,"imgCostItem_WndMagicBuyLevel",WZUIImage)
	local itemInfo = GDatatab_item["id_" .. self.m_ncostId]
	local icon = itemInfo.icon
	imgCostItem:setFile(icon)
	imgCostItem:setScale(0.5)

	GetElement(self.m_root,"useNum_WndMagicBuyLevel",WZUILabelTTF):setText(self.m_nNum)

	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndMagicBuyLevel",WZUILabelTTF)
	txtCostNum:setText(self.m_ncostCount)
	
	--提升到提示语
    local txtTips = GetElement(self.m_root,"txtTips_WndMagicBuyLevel",WZUILabelTTF)
    local nUptoLevel = WndMagicStone:getMagicStoneLevel() + self.m_nNum
    txtTips:setText(string.format(LocalStrings.MAGIC_STONE_TEXT8, self.m_nNum, nUptoLevel))
end

--更新购买价格
function WndMagicBuyLevel:updateCostCount()
	WZLog("WndMagicBuyLevel:updateCostCount")
	local useNum = GetElement(self.m_root,"useNum_WndMagicBuyLevel",WZUILabelTTF)
	local num = tonumber(useNum:getText())

	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndMagicBuyLevel",WZUILabelTTF)
	local costCount = num * self.m_ncostCount
	txtCostNum:setText(costCount)
	--提升到提示语
	local txtTips = GetElement(self.m_root,"txtTips_WndMagicBuyLevel",WZUILabelTTF)
    local nUptoLevel = WndMagicStone:getMagicStoneLevel() + self.m_nNum
    txtTips:setText(string.format(LocalStrings.MAGIC_STONE_TEXT8, self.m_nNum, nUptoLevel))
end

function WndMagicBuyLevel:onClose(element)
	-- body
	WZLog("WndMagicBuyLevel:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	关闭窗口
function WndMagicBuyLevel:closeWin()
	if self.m_root == nil then return end 
	
	WindowManager:removeWindow(self.m_root, self, true)
end

--购买
function WndMagicBuyLevel:onClickBuy(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("WndMagicBuyLevel:onClickBuy")
	if g_cityExtenInfo.magicStoneStatus == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.MAGIC_STONE_TEXT23)
		return 
	end
	local txtCostNum = GetElement(self.m_root,"txtCostNum_WndMagicBuyLevel",WZUILabelTTF)
	local costNum = tonumber(txtCostNum:getText())
	local diamondCount = CacheCenter:getPlayerItemCountById(self.m_ncostId)
	local name = GDatatab_item["id_" .. self.m_ncostId].name
	if not JudgeMoneyIsEnough(self.m_ncostId, costNum, nil, nil, GlobalGame.g_nCurrentUIChannelId, nil, nil, nil, nil, self, self.sureToUseDiamondInstead) then
		return
	end
	
	--发送购买等级协议
	self:sureToUseDiamondInstead()
end

--@brief 	确定购买
function WndMagicBuyLevel:sureToUseDiamondInstead()
	-- body
	if g_cityExtenInfo.magicStoneStatus == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.MAGIC_STONE_TEXT23)
		return 
	end
	local useNum = GetElement(self.m_root,"useNum_WndMagicBuyLevel",WZUILabelTTF)
	local addLevel = tonumber(useNum:getText())
	WndMagicStone:setBuyLevel(true)
	ProtocolProcessorWndMagicStone:send_MAGICSTONE_BuyLevel(addLevel)
end

--一次减十个
function WndMagicBuyLevel:onMutiReduce(element)
	WZLog("WndMagicBuyLevel:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 10 then
		self.m_nNum = self.m_nNum -10
	elseif  self.m_nNum > 1 then
		self.m_nNum = 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndMagicBuyLevel",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--一次减一个
function WndMagicBuyLevel:onReduce(element)
	WZLog("WndMagicBuyLevel:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndMagicBuyLevel",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--一次加一个
function WndMagicBuyLevel:onAdd(element)
	WZLog("WndMagicBuyLevel:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local max = 100
	if self.m_nNum + 1 <= max then
		self.m_nNum = self.m_nNum + 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	GetElement(self.m_root,"useNum_WndMagicBuyLevel",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end

--@brief	增加10个
function WndMagicBuyLevel:onMutiAdd(element)
	WZLog("WndMagicBuyLevel:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local max = 100
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
	GetElement(self.m_root,"useNum_WndMagicBuyLevel",WZUILabelTTF):setText(self.m_nNum)
	self:updateCostCount()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新界面
function WndMagicBuyLevel:_update()
	-- body
	
end




-------------------------------------私有方法模块End----------------------------------------
