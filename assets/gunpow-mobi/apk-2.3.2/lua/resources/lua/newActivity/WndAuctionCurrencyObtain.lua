--WndAuctionCurrencyObtain.lua
--@brief	WndAuctionCurrencyObtain的UI模块
--@date		2020/08/04
--@author	yrd
--@note		竞拍币获取途径


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndAuctionCurrencyObtain:onEnter(element)
	self.m_root = element

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndAuctionCurrencyObtain:onExit(element)
	self:_unInit()
end

-- function WndAuctionCurrencyObtain:onEnterTransitionDidFinish()
-- 	WindowManagerAni:createAction(self.m_root,false,"actionCallback",self)
-- 	-- self:updateUI()
-- end

-- function WndAuctionCurrencyObtain:actionCallback()
-- 	self:updateUI()
-- end

function WndAuctionCurrencyObtain:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndAuctionCurrencyObtain:updateUI()
	local con1 = GetElement(self.m_root,"con1_WndAuctionCurrencyObtain",WZUIContainer)
	local con2 = GetElement(self.m_root,"con2_WndAuctionCurrencyObtain",WZUIContainer)
	if self.m_nType == 1 then
		con1:setVisible(true)
		con2:setVisible(false)
		self:updateCon1()
	elseif self.m_nType == 2 then
		con1:setVisible(false)
		con2:setVisible(true)
		self:updateCon2()
	end
end

--@brief	竞拍币获取途径
function WndAuctionCurrencyObtain:updateCon1()
	local itemId = CellAuctionHouse.m_currencyId

	local itemNum = CacheCenter:getPlayerItemCountById(itemId)
	local itemInfo = GDatatab_item["id_"..itemId]

	local txtTitle = GetElement(self.m_root,"txtTitle_WndAuctionCurrencyObtain",WZUILabelTTF)
	txtTitle:setText(LocalStrings.SKINSKILL4)

	local conItem = GetElement(self.m_root,"conItem_WndAuctionCurrencyObtain",WZUIContainer)
    conItem:removeAllChildrenWithCleanup(true)
    local element, tNewObj = CellGoodItem:createElement()
    if element and tNewObj then 
        tNewObj:setCellGoodLocalId(itemId, itemNum, 1)
        tNewObj:setItemClickFun(self, self.onClickItem)
        tNewObj:setBackImgFile2()
        conItem:addChild(element)
    end

	local txtItemName = GetElement(self.m_root,"txtItemName_WndAuctionCurrencyObtain",WZUILabelTTF)
    txtItemName:setColor(QUALITYCOLOR[itemInfo.quality])
    txtItemName:setText(itemInfo.name)


	local txtNum1 = GetElement(self.m_root,"txtNum1_WndAuctionCurrencyObtain",WZUILabelTTF)
	txtNum1:setText(LocalStrings.NUM1)
	local txtNum2 = GetElement(self.m_root,"txtNum2_WndAuctionCurrencyObtain",WZUILabelTTF)
	txtNum2:setText(itemNum)
end

--@brief	竞拍规则
function WndAuctionCurrencyObtain:updateCon2()
	local txtTitle = GetElement(self.m_root,"txtTitle_WndAuctionCurrencyObtain",WZUILabelTTF)
	txtTitle:setText(LocalStrings.AUCTION_HOUSE_TEXT15)
	local ftbDesc = GetElement(self.m_root,"ftbDesc_WndAuctionCurrencyObtain",WZUIFreeTextBox)
	ftbDesc:setShowText(LocalStrings.AUCTION_HOUSE_TEXT10)

	self:_upMoveContainerLayer1()
end


--@brief  	更新滚动容器内部布局函数
function WndAuctionCurrencyObtain:_upMoveContainerLayer1()
	if self.m_root == nil then
		return
	end
	--获取规则说明内容文本的大小
	local txtExplanation = GetElement(self.m_root, "ftbDesc_WndAuctionCurrencyObtain", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0.5,1))
	txtExplanation:setPositionY(txtSize.height-5)
	WZLog("富文本框尺寸是",txtSize.width,txtSize.height)
	
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndAuctionCurrencyObtain")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1 , txtSize.height / rollSize.height ) )
	--moveElement:setContentSize(txtSize)
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
	WZLog("滚动容器大小",rollSize.width,rollSize.height)
end

--@brief	点击竞拍币回调
function WndAuctionCurrencyObtain:onClickItem(luaTable,tag,tData)
	WndItemInfo:showInfo(luaTable.m_root,self.m_root,1,tData, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

function WndAuctionCurrencyObtain:_adaptLanguage_vn()
	GetElement(self.m_root,"txtDesc_WndAuctionCurrencyObtain",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(600,0))
end