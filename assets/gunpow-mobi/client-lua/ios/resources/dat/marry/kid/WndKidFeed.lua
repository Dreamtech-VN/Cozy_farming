--WndKidFeed.lua
--@brief	WndKidFeed的UI模块
--@date		2018/05/07
--@author	Tianxiang_Xu
--@note		小孩喂食界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidFeed:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	CacheCenter:registerUpatePlayerHomeItemObserver(self)
end

--@brief    界面加载完成回调
function WndKidFeed:onEnterTransitionDidFinish(element)
    -- body
    self.m_nKidIndex = self:getKidIndexById(self.m_tKidData)

    self:setNumBtnVivible()
    self:setStaticText()
    self:getFoodList()

    self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidFeed:onExit(element)
	CacheCenter:unregisterUpatePlayerHomeItemObserver(self)
	self:_unInit()
end

--@brief	关闭
function WndKidFeed:onClose(element)
	WZLog("WndKidFeed:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	if self.m_root == nil then
		return
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief 	触摸开始回调
function WndKidFeed:onTouchBegan(element, pt)
	-- body
	if self.m_root and not self:checkPointInBtn(pt) then
        self:hideSuitList()
    end
end

--@brief	点击喂食按钮回调
function WndKidFeed:onClick(element)
	WZLog("WndKidFeed:onClick",self.playerItemId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum <= 0 then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT5)
		return
	end

	--发送喂食协议对小孩进行喂食
	local tCurKidData = SceneKidHome.m_tKidData[self.m_nKidIndex]
	if self.m_nType == 1 and tCurKidData.happiness >= self.m_nMaxGrowValue then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT113)
		return 
	end

	local tData = self.m_tData
	local level = CacheCenter:getPlayerInfo().level
	--判断是否达到等级
	if tonumber(level) < tonumber(tData.basicInfo.use_level) then
		MsgBoxManager:showTipBox(LocalStrings.OPENGIFTLEVEL)
		return
	end
	local nOwnNum = CacheCenter:getPlayerHomeItemCountById(self.m_tData.basicInfo.id)
	if nOwnNum == 0 then
		--购买界面，快速购买
		checkIsOnSale(self.m_tData.basicInfo.id)
		return 
	end
	if self.m_nType == 1 then --喂食，解除哭状态
		ProtocolProcessorKid:send_WEDDING_AppeaseChild(tCurKidData.id, 2, tData.basicInfo.id, self.m_nNum)
	elseif self.m_nType == 2 then --解决尿裤子
		ProtocolProcessorKid:send_WEDDING_AppeaseChild(tCurKidData.id, 3, tData.basicInfo.id, self.m_nNum)
	end
end

--@brief	减少10个
function WndKidFeed:onMutiReduce(element)
	WZLog("WndKidFeed:onMutiReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum > 10 then
		self.m_nNum = self.m_nNum - 10
	else
		self.m_nNum = 1
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndKidFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end

--@brief	减少1个
function WndKidFeed:onReduce(element)
	WZLog("WndKidFeed:onReduce")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nNum - 1 >= 1 then
		self.m_nNum = self.m_nNum - 1
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMINNUM)
	end
	GetElement(self.m_root,"useNum_WndKidFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end

--@brief	增加10个
function WndKidFeed:onMutiAdd(element)
	WZLog("WndKidFeed:onMutiAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = self.m_tData
	local number = CacheCenter:getPlayerHomeItemCountById(self.m_tData.basicInfo.id)
	self.m_nMaxNum = math.min(100, number)
	if self.m_nNum < self.m_nMaxNum - 10 then
		local bCanAdd = self:getGrowValueAfterUse()
		if bCanAdd then
			local nLeftNum = self:getExdAddNum()
			if nLeftNum >= 10 then
				self.m_nNum = self.m_nNum + 10
			else
				self.m_nNum = self.m_nNum + nLeftNum
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT114)
			return 
		end
	else
		local bCanAdd = self:getGrowValueAfterUse()
		if bCanAdd then
			local nLeftNum = self:getExdAddNum()
			if nLeftNum >= self.m_nMaxNum - self.m_nNum then
				self.m_nNum = self.m_nMaxNum
				MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
			else
				self.m_nNum = self.m_nNum + nLeftNum
			end
		else
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT114)
			return 
		end
	end
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_WndKidFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end

--@brief	增加1个
function WndKidFeed:onAdd(element)
	WZLog("WndKidFeed:onAdd")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--使用加体力物品，要判断是否达到上限
	local tData = self.m_tData
	local number = CacheCenter:getPlayerHomeItemCountById(self.m_tData.basicInfo.id)
	self.m_nMaxNum = math.min(100, number)
	if self.m_nNum + 1 <= self.m_nMaxNum then
		local bCanAdd = self:getGrowValueAfterUse()
		if bCanAdd then
			self.m_nNum = self.m_nNum + 1
		else
			MsgBoxManager:showTipBox(LocalStrings.KID_TEXT114)
		end
	else
		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
	end
	if self.m_nNum == 0 then self.m_nNum = 1 end
	GetElement(self.m_root,"useNum_WndKidFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end

--@brief 	选中某一食物
function WndKidFeed:chooseFood(tCell, tag, tData)
	-- body
	if self.m_tData and self.m_tData.basicInfo.id == tData.basicInfo.id then return end 
	WZLog("WndKidFeed:chooseFood")
	if self.m_tClickCell then
		self.m_tClickCell:setItemSelState(false)
	end
	self.m_tData = tData
	self.m_tClickCell = tCell
	self.m_tClickCell:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")

	--切换食物，重置数量
	self.m_nNum = 1
	GetElement(self.m_root,"useNum_WndKidFeed",WZUILabelTTF):setText(self.m_nNum)
	self:setAddValue()
end

--@brief 	隐藏套装列表
function WndKidFeed:hideSuitList()
	-- body
	if self.m_root == nil then return end 
	if self.m_bIsOpenList == false then return end 

	self.m_bIsOpenList = not self.m_bIsOpenList
	self:setArrowAndListState()
end

--@brief 	设置箭头和列表的状态
function WndKidFeed:setArrowAndListState()
	-- body
	local imgArrow = GetElement(self.m_root, "imgArrow_WndKidFeed", WZUIImage)
	if imgArrow then
		imgArrow:setFlipY(self.m_bIsOpenList)
	end
	GetElement(self.m_root, "conOther_WndKidFeed", WZUIContainer):setVisible(self.m_bIsOpenList)
end

--@brief 	点击当前孩子按钮回调
--@note 	收起或展示孩子列表
function WndKidFeed:onClickShow(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_bIsOpenList = not self.m_bIsOpenList
	
	self:setArrowAndListState()
end

--@brief 	点击切换孩子回调
function WndKidFeed:onClickChange(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local nTag = element:getTag()
	--如果点击的是正在使用的，则不处理
	if nTag == self.m_nKidIndex then
		return 
	end

	self.m_nKidIndex = nTag

	local nGapY = 1/(2 * 2)
	self.m_nodeKidSel:setRelativePosition(GlobalMethod:ccp(0.5, (1 - nGapY) - (self.m_nKidIndex - 1) * nGapY * 2))

	self:hideSuitList()

	self:setFeedKidName()
end

--@brief 	成长值
function WndKidFeed:setGrowValue()
	-- body
	local tData = SceneKidHome.m_tKidData[self.m_nKidIndex]

	local ftxtGrowValue = GetElement(self.m_root, "ftxtGrowValue_WndKidFeed", WZUIFreeTextBox)
	if ftxtGrowValue then
		ftxtGrowValue:setShowText(string.format(LocalStrings.KID_TEXT111, tData.happiness, self.m_nMaxGrowValue))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndKidFeed:_update()
	-- body
	self:setFeedKidName()
	self:_createSuitList()
	self:_createFoodsList()
	self:setAddValue()
end

--@brief 	设置标题和按钮字
function WndKidFeed:setStaticText()
	-- body
	if SceneKidHome.m_tKidData and #SceneKidHome.m_tKidData == 2 then
		--显示孩子选择按钮
		GetElement(self.m_root, "conForChooseBaby_WndKidFeed", WZUIContainer):setVisible(true)
	else
		GetElement(self.m_root, "conForChooseBaby_WndKidFeed", WZUIContainer):setVisible(false)
	end

	if self.m_nType == 1 then
		GetElement(self.m_root,"txtTitle_WndKidFeed",WZUILabelTTF):setText(LocalStrings.KID_TEXT4)
		GetElement(self.m_root, "txtFeed_WndKidFeed", WZUILabelTTF):setText(LocalStrings.FAMILY_TEXT50)
	else
		GetElement(self.m_root,"txtTitle_WndKidFeed",WZUILabelTTF):setText(LocalStrings.KID_TEXT11)
		GetElement(self.m_root, "txtFeed_WndKidFeed", WZUILabelTTF):setText(LocalStrings.KID_TEXT12)
	end
	GetElement(self.m_root,"txtExplanation_WndKidFeed",WZUILabelTTF):setText(LocalStrings.OPENCHEST1)
	GetElement(self.m_root,"useNum_WndKidFeed",WZUILabelTTF):setText(self.m_nNum)
end

--@brief 	创建食物列表
function WndKidFeed:_createFoodsList()
	-- body
	local tbForFood = GetElement(self.m_root, "tbForFood_WndKidFeed", WZUITableContainer)
	local conForLimitFood = GetElement(self.m_root, "conForLimitFood_WndKidFeed", WZUIContainer)
	tbForFood:cleanTable()

	if #self.m_tFoodsList > 3 then
		tbForFood:setVisible(true)
		conForLimitFood:setVisible(false)
		for i = 1, #self.m_tFoodsList do
			local element, tNewObj = CellGoodItem:createElement()
			if element and tNewObj then
				element:setTag(i - 1)
				local number = CacheCenter:getPlayerHomeItemCountById(self.m_tFoodsList[i].id)
				tNewObj:setCellGoodLocalId(self.m_tFoodsList[i].id, number, 4, true)
				tNewObj:setItemClickFun(self, self.chooseFood)
				if self.m_tData == nil then
					self.m_tData = {}
					self.m_tData.basicInfo = self.m_tFoodsList[i]
					tNewObj:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")
					self.m_tClickCell = tNewObj
				elseif self.m_tData and self.m_tData.basicInfo.id == self.m_tFoodsList[i].id then
					tNewObj:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")
					self.m_tClickCell = tNewObj
				end
				tNewObj:setItemCount(number)
				tNewObj:_setItemVisible(true)
				tbForFood:setCellElement(element)
			end
		end
	else
		tbForFood:setVisible(false)
		conForLimitFood:setVisible(true)

		for i = 1, #self.m_tFoodsList do
			local element, tNewObj = CellGoodItem:createElement()
			local conItem = GetElement(self.m_root, "conItem" .. i .. "_WndKidFeed", WZUIContainer)
			conItem:setVisible(true)
			conItem:removeAllChildrenWithCleanup(true)
			if element and tNewObj then
				local number = CacheCenter:getPlayerHomeItemCountById(self.m_tFoodsList[i].id)
				tNewObj:setCellGoodLocalId(self.m_tFoodsList[i].id, number, 4, true)
				tNewObj:setItemClickFun(self, self.chooseFood)
				if self.m_tData == nil then
					self.m_tData = {}
					self.m_tData.basicInfo = self.m_tFoodsList[i]
					tNewObj:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")
					self.m_tClickCell = tNewObj
				elseif self.m_tData and self.m_tData.basicInfo.id == self.m_tFoodsList[i].id then
					tNewObj:setItemSelState(true, "ui/common/common_scale9_beibaodi_sel.png")
					self.m_tClickCell = tNewObj
				end
				tNewObj:setItemCount(number)
				tNewObj:_setItemVisible(true)
				conItem:addChild(element)
			end
		end

		if #self.m_tFoodsList == 1 then
			GetElement(self.m_root, "conItem1_WndKidFeed", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		elseif #self.m_tFoodsList == 2 then
			GetElement(self.m_root, "conItem1_WndKidFeed", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.35,0.5))
			GetElement(self.m_root, "conItem2_WndKidFeed", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.65,0.5))
		end
	end
end

--@brief 	设置可以增长的愉悦值
function WndKidFeed:setAddValue()
	-- body
	local txtFoodDesc = GetElement(self.m_root, "txtFoodDesc_WndKidFeed", WZUILabelTTF)
	if txtFoodDesc then
		if self.m_nNum and self.m_nNum > 0 then
			local nValue = self.m_tData.basicInfo.value * self.m_nNum
			if self.m_nType == 2 then
				txtFoodDesc:setText(string.format(LocalStrings.KID_TEXT112, self.m_tData.basicInfo.name, nValue))
			else
				txtFoodDesc:setText(string.format(LocalStrings.KID_TEXT6, self.m_tData.basicInfo.name, nValue))
			end
		else
			txtFoodDesc:setText("")
		end
	end
end

--@brief 	
function WndKidFeed:checkPointInBtn(pt)
	-- body
	local btn
	btn = GetElement(self.m_root, "conForChooseBaby_WndKidFeed", WZUIContainer)
	if btn then
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end
	btn = GetElement(self.m_root, "conOther_WndKidFeed", WZUIContainer)
	if btn then
		local btnSize = btn:getContentSize()
		--获得btn的世界坐标
		local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
		if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
			return true
		end 
	end

	return false 
end

--@brief 	创建套装列表
function WndKidFeed:_createSuitList()
	-- body
	if SceneKidHome.m_tKidData and #SceneKidHome.m_tKidData == 2 then
		local conOther = GetElement(self.m_root, "conOther_WndKidFeed", WZUIContainer)
		local conKidList = GetElement(self.m_root, "conKidList_WndKidFeed", WZUIContainer)
		self.m_nodeKidSel = nil 
		conKidList:removeAllChildrenWithCleanup(true)

		local nTotalNum = 2
		local nNum = nTotalNum

		conOther:setAbsContentSize(GlobalMethod:CCSize(122, nNum * 34))
		conOther:updateRelativeSize()
		local nGapY = 1/(nNum * 2)
		for i = 1, nTotalNum do
			local btnSuit = self:_createBtn(SceneKidHome.m_tKidData[i].name)
	    	btnSuit:setRelativePosition(GlobalMethod:ccp(0.38, (1 - nGapY) - (i - 1) * nGapY * 2))
	    	btnSuit:setTag(i)

	    	conKidList:addChild(btnSuit)

    		if i == self.m_nKidIndex then
				self:_createRectSel()
				self.m_nodeKidSel:setRelativePosition(GlobalMethod:ccp(0.5, (1 - nGapY) - (i - 1) * nGapY * 2))
			end
		end
	end
end

--@brief 	创建选中当前选中的套装
function WndKidFeed:_createRectSel()
	-- body
	if self.m_nodeKidSel == nil then
		self.m_nodeKidSel = WZUIContainer:create()
		self.m_nodeKidSel:setAbsContentSize(GlobalMethod:CCSize(116,30))
		self.m_nodeKidSel:setUseAbsSize(true)

		local img9 = WZUI9Image:create()
		img9:setFile("ui/common/common_scale9_wbbsxz.png")

		self.m_nodeKidSel:addChild(img9)

		local conKidList = GetElement(self.m_root, "conKidList_WndKidFeed", WZUIContainer)
		conKidList:addChild(self.m_nodeKidSel)
	end
end

--@brief    创建按钮
function WndKidFeed:_createBtn(btnText, fontSize, FontColor)
    -- body
    local btnSuit = WZUIButton:create()
    btnSuit:setUseAbsSize(true)
    btnSuit:setAbsContentSize(GlobalMethod:CCSize(118, 34))
    local imgNor = WZUIImage:create()
    imgNor:setFile("ui/common/common_scale9_fengexian2.png")
    imgNor:setUseOriginSize(true)
    imgNor:setScaleX(0.17)
    imgNor:setScaleY(0.3)
    imgNor:setRelativePosition(GlobalMethod:ccp(0.6,0.07))
    if btnText ~= "+" then
    	btnSuit:addChild(imgNor)
    end

    local txtBtn = WZUILabelTTF:create()
    if fontSize then 
    	txtBtn:setFontSize(fontSize)
    else
    	txtBtn:setFontSize(20)
    end
    if FontColor then
    	txtBtn:setColor(FontColor)
    else
    	txtBtn:setColor(GlobalMethod:ccc3(255,236,193))
    end
    txtBtn:setEnableStroke(false)
    txtBtn:setStrokeSize(4)
    txtBtn:setStrokeColor(GlobalMethod:ccc3(127,70,26))
    txtBtn:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    txtBtn:setRelativePosition(GlobalMethod:ccp(0.2,0.45))
    txtBtn:setText(btnText)
    txtBtn:setTag(44)
    btnSuit:addChild(txtBtn)
    btnSuit:setLuaDoneFunctionName("onClickChange")

    return btnSuit
end

--@brief 	设置按钮名字
function WndKidFeed:setFeedKidName()
	-- body
	WZLog("WndKidFeed:setFeedKidName", self.m_nKidIndex)
	local tData = SceneKidHome.m_tKidData[self.m_nKidIndex]
	GetElement(self.m_root, "txtCurBabyName_WndKidFeed", WZUILabelTTF):setText(tData.name)

	self:setGrowValue()
end

--@brief 	设置按钮的可见与否
function WndKidFeed:setNumBtnVivible()
	-- body
	local mutiReduce = GetElement(self.m_root, "mutiReduce_WndKidFeed", WZUIButton)
	local mutiAdd = GetElement(self.m_root, "mutiAdd_WndKidFeed", WZUIButton)
	local reduce = GetElement(self.m_root, "reduce_WndKidFeed", WZUIButton)
	local add = GetElement(self.m_root, "add_WndKidFeed", WZUIButton)

	if self.m_nType == 1 then
		mutiReduce:setVisible(true)
		mutiAdd:setVisible(true)
		reduce:setVisible(true)
		add:setVisible(true)
	else
		mutiReduce:setVisible(false)
		mutiAdd:setVisible(false)
		reduce:setVisible(false)
		add:setVisible(false)
	end
end
-------------------------------------私有方法模块End----------------------------------------



-------------------------------------语言适配Begin----------------------------------------
function WndKidFeed:_adaptLanguage_vn( )
	local txtFoodDesc = GetElement(self.m_root, "txtFoodDesc_WndKidFeed", WZUILabelTTF)
	txtFoodDesc:setScale(0.8)
end

function WndKidFeed:_adaptLanguage_th( )
	local txtFeed = GetElement(self.m_root, "txtFeed_WndKidFeed", WZUILabelTTF)
	txtFeed:setScale(0.7)
	txtFeed:setDimensions(GlobalMethod:CCSize(150))
end

function WndKidFeed:_adaptLanguage_en( )
	local txtFeed = GetElement(self.m_root, "txtFeed_WndKidFeed", WZUILabelTTF)
	txtFeed:setScale(0.7)
	txtFeed:setDimensions(GlobalMethod:CCSize(150))
end

function WndKidFeed:_adaptLanguage_es( )
	GetElement(self.m_root,"txtExplanation_WndKidFeed",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(360))
	GetElement(self.m_root, "txtFoodDesc_WndKidFeed", WZUILabelTTF):setScale(0.75)

	local txtFeed = GetElement(self.m_root, "txtFeed_WndKidFeed", WZUILabelTTF)
	txtFeed:setScale(0.7)
	txtFeed:setDimensions(GlobalMethod:CCSize(150))
	
	GetElement(self.m_root, "ftxtGrowValue_WndKidFeed", WZUIFreeTextBox):setScale(0.7)
end

function WndKidFeed:_adaptLanguage_pt( )
	GetElement(self.m_root,"txtExplanation_WndKidFeed",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(360))
	GetElement(self.m_root, "txtFoodDesc_WndKidFeed", WZUILabelTTF):setScale(0.75)
	
	local txtFeed = GetElement(self.m_root, "txtFeed_WndKidFeed", WZUILabelTTF)
	txtFeed:setScale(0.7)
	txtFeed:setDimensions(GlobalMethod:CCSize(150))

	GetElement(self.m_root, "ftxtGrowValue_WndKidFeed", WZUIFreeTextBox):setScale(0.7)
end
-------------------------------------语言适配End----------------------------------------