--WndPhantomGroup.lua
--@brief	WndPhantomGroup的UI模块
--@date		2021/12/30
--@author	yrd
--@note		皮肤幻化-共生录


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPhantomGroup:onEnter(element)
	self.m_root = element

	ProtocolProcessorPhantom:regAll()
	ProtocolProcessorPhantom:send_SHAPE_GetShapeGroupList()

	CacheCenter:registerUpatePlayerItemObserver(self)

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPhantomGroup:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

--@brief	加载动画
function WndPhantomGroup:onEnterTransitionDidFinish(element)

end

--@brief	观察者模式-物品更新
function WndPhantomGroup:updatePlayerItemData()
	if self.m_root == nil then
		return
	end
	if self.m_tData == nil then
		return
	end

	local tCurShapeData = self.m_tData[self.m_nCurShapeIndex]
	local nSkillId = tCurShapeData.shapeGroupInfo.skill_id
	local tCurSkillInfo = GDatatab_skill["id_"..nSkillId]
	local tAdvanceInfo = GDatatab_shape_group_advance["id_"..tCurSkillInfo.specialAttackParam]
	local costInfo = GDatatab_item["id_"..tAdvanceInfo.cost[1][1]]
	local nOwnNum = CacheCenter:getPlayerItemCountById(costInfo.id)
	GetElement(self.m_root,"txtActivationOwn_WndPhantomGroup",WZUILabelTTF):setText(string.format(LocalStrings.MOUNT_PILL_CNT,nOwnNum))
end

--@brief	选择界面 1主界面 2激活进阶界面
function WndPhantomGroup:showUIByType()
	local conInterface1 = GetElement(self.m_root,"conInterface1_WndPhantomGroup",WZUIContainer)
	local conInterface2 = GetElement(self.m_root,"conInterface2_WndPhantomGroup",WZUIContainer)
	if self.m_nUIType == 1 then
		conInterface1:setVisible(true)
		conInterface2:setVisible(false)
	elseif self.m_nUIType == 2 then
		conInterface1:setVisible(false)
		conInterface2:setVisible(true)
	end
end

--@brief	更新界面
function WndPhantomGroup:updateUI()
	self:showUIByType()
	if self.m_nUIType == 1 then
		self:updateShapeGroupList()
	elseif self.m_nUIType == 2 then
		self:updateShapeGroupInfo()
	end
end

--@brief	更新共生录列表
function WndPhantomGroup:updateShapeGroupList()
	local flcItems1 = GetElement(self.m_root,"flcItems1_WndPhantomGroup",WZUIFreeListContainer)
	local flcItems2 = GetElement(self.m_root,"flcItems2_WndPhantomGroup",WZUIFreeListContainer)
	flcItems1:removeAll()
	flcItems2:removeAll()
	self.m_tShapeGroupObj = {}

	local nMaxPageNum = 10 --每页最多展示数量
	local nStartIndex = (self.m_nCurPagesNum - 1) * nMaxPageNum + 1 --当前页头一个皮肤组合的索引
	local nEndIndex = math.min(self.m_nCurPagesNum * nMaxPageNum, #self.m_tData) --当前页最后一个皮肤组合的索引
	for i = 0, nEndIndex - nStartIndex do
		local nIndex = nStartIndex+i
		local cellItem, tNewObj = CellPhantomGroup:createElement()
		tNewObj:setData(self.m_tData[nIndex],nIndex)
		tNewObj:setUseIndex(self.m_nUseShapeGroupId)
		if i < 5 then --左边展示5个
			cellItem:setTag(i)
			flcItems1:pushBack(cellItem)
		else --右边展示5个
			cellItem:setTag(i-5)
			flcItems2:pushBack(cellItem)
		end
		table.insert(self.m_tShapeGroupObj,tNewObj)
	end
end

--@brief	点击翻页按钮回调
function WndPhantomGroup:onClickTurnPage(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()

	if tag == 1 then
		if self.m_nCurPagesNum <= 1 then
			MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT36)
			return
		end
		self.m_nCurPagesNum = self.m_nCurPagesNum - 1
	elseif tag == 2 then
		local nMaxPageNum = 10 --每页最多展示数量
		local nMaxPage = math.ceil(#self.m_tData / nMaxPageNum)
		if self.m_nCurPagesNum >= nMaxPage then
			MsgBoxManager:showTipBox(LocalStrings.FRIENDCIRCLE_TEXT35)
			return
		end
		self.m_nCurPagesNum = self.m_nCurPagesNum + 1
	end
	self:updateShapeGroupList()
end

--@brief	更新共生录组合详情
function WndPhantomGroup:updateShapeGroupInfo()
	local tCurShapeData = self.m_tData[self.m_nCurShapeIndex]
	local conSkinAni = GetElement(self.m_root,"conSkinAni_WndPhantomGroup",WZUIContainer)
	conSkinAni:removeAllChildrenWithCleanup(true)
	--激活界面还是进阶界面
	local conActivation = GetElement(self.m_root,"conActivation_WndPhantomGroup",WZUIContainer)
	local conAdvanced = GetElement(self.m_root,"conAdvanced_WndPhantomGroup",WZUIContainer)
	if tCurShapeData.status == 2 then --进阶界面
		conActivation:setVisible(false)
		conAdvanced:setVisible(true)
	else --激活界面
		conActivation:setVisible(true)
		conAdvanced:setVisible(false)
	end
	self:updateShapeGroupSkill()
	--皮肤形象
	local tSkinIds = {}
	local sex = CacheCenter:getPlayerInfo().sex
	if sex == 0 then
		tSkinIds = tCurShapeData.shapeGroupInfo.skin_male[1]
	else
		tSkinIds = tCurShapeData.shapeGroupInfo.skin_female[1]
	end
	for i=1,#tSkinIds do
		local nScale = tCurShapeData.shapeGroupInfo.scale[1][i]
		local position = tCurShapeData.shapeGroupInfo.position[i]
		local conShape = self:createShapeAni(tSkinIds[i],nScale)
		conShape:setRelativePosition(GlobalMethod:ccp(position[1],position[2]))
		conSkinAni:addChild(conShape)

		if not WndPhantomGroup:hasSkin(tSkinIds[i]) then
			local conInactive = self:createConInactive()
			conInactive:setRelativePosition(GlobalMethod:ccp(position[1],position[2]))
			conSkinAni:addChild(conInactive)
		end
	end
	--组合名称
	local txtUI2Name = GetElement(self.m_root,"txtUI2Name_WndPhantomGroup",WZUILabelTTF)
	txtUI2Name:setText(tCurShapeData.shapeGroupInfo.name)
	--描述
	local txtUI2Desc = GetElement(self.m_root,"txtUI2Desc_WndPhantomGroup",WZUILabelTTF)
	txtUI2Desc:setText(tCurShapeData.shapeGroupInfo.desc)
	txtUI2Desc:setPositionY(txtUI2Desc:getContentSize().height)
	local scrollConDesc = GetElement(self.m_root,"scrollConDesc_WndPhantomGroup",WZUIScrollContainer)
	local moveElement = scrollConDesc:getMoveElement()
	moveElement:setRelativeSize( CCSize( moveElement:getRelativeSize().width , (txtUI2Desc:getLabelContentSize().height + 10) / scrollConDesc:getContentSize().height ) )
	scrollConDesc:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(scrollConDesc:getMinPosition().y)
end

--@brief	更新共生录组合技能
function WndPhantomGroup:updateShapeGroupSkill()
	local tCurShapeData = self.m_tData[self.m_nCurShapeIndex]
	local nSkillId = tCurShapeData.shapeGroupInfo.skill_id
	local tCurSkillInfo = GDatatab_skill["id_"..nSkillId]
	local offsetLevel = tCurShapeData.advanceLevel - 1
	while offsetLevel > 0 do
		offsetLevel = offsetLevel - 1
		tCurSkillInfo = GDatatab_skill["id_"..tCurSkillInfo.upgrade_id]
	end
	local tNextSkillInfo = GDatatab_skill["id_"..tCurSkillInfo.upgrade_id]

	local tAdvanceInfo = GDatatab_shape_group_advance["id_"..tCurSkillInfo.specialAttackParam]

	if tCurShapeData.status == 2 then --进阶界面
		-- 当前等级技能
		GetElement(self.m_root,"imgSkillPrevIcon2_WndPhantomGroup",WZUIImage):setFile(tCurSkillInfo.icon)
		GetElement(self.m_root,"imgSkillPrevLevel2_WndPhantomGroup",WZUIImage):setFile(tCurSkillInfo.lv_icon)
		GetElement(self.m_root,"txtSkillPrevName2_WndPhantomGroup",WZUILabelTTF):setText(tCurSkillInfo.name)
		GetElement(self.m_root,"txtSkillPrevLv2_WndPhantomGroup",WZUILabelTTF):setText(LocalStrings.LV..tCurSkillInfo.specialAttackParam)
		GetElement(self.m_root,"txtSkillPrevDesc2_WndPhantomGroup",WZUILabelTTF):setText(tCurSkillInfo.tool_desc)
		-- 下一级技能
		local conAdvancedCost = GetElement(self.m_root,"conAdvancedCost_WndPhantomGroup",WZUIContainer)
		local conAdvancedLevelMax = GetElement(self.m_root,"conAdvancedLevelMax_WndPhantomGroup",WZUIContainer)
		local conSkillNext2 = GetElement(self.m_root,"conSkillNext2_WndPhantomGroup",WZUIContainer)
		local imgSkillArrow2 = GetElement(self.m_root,"imgSkillArrow2_WndPhantomGroup",WZUIImage)
		if tNextSkillInfo then --等级未满
			conSkillNext2:setVisible(true)
			imgSkillArrow2:setVisible(true)
			conAdvancedCost:setVisible(true)
			conAdvancedLevelMax:setVisible(false)
			-- 下一级技能
			GetElement(self.m_root,"imgSkillNextIcon2_WndPhantomGroup",WZUIImage):setFile(tNextSkillInfo.icon)
			GetElement(self.m_root,"imgSkillNextLevel2_WndPhantomGroup",WZUIImage):setFile(tNextSkillInfo.lv_icon)
			GetElement(self.m_root,"txtSkillNextName2_WndPhantomGroup",WZUILabelTTF):setText(tNextSkillInfo.name)
			GetElement(self.m_root,"txtSkillNextLv2_WndPhantomGroup",WZUILabelTTF):setText(LocalStrings.LV..tNextSkillInfo.specialAttackParam)
			GetElement(self.m_root,"txtSkillNextDesc2_WndPhantomGroup",WZUILabelTTF):setText(tNextSkillInfo.tool_desc)
			-- 消耗
			local costInfo = GDatatab_item["id_"..tAdvanceInfo.cost[1][1]]
			GetElement(self.m_root,"imgActivationCost_WndPhantomGroup",WZUIImage):setFile(costInfo.icon)
			GetElement(self.m_root,"txtActivationCost_WndPhantomGroup",WZUILabelTTF):setText(tAdvanceInfo.cost[1][2])
			-- 拥有
			local nOwnNum = CacheCenter:getPlayerItemCountById(costInfo.id)
			GetElement(self.m_root,"txtActivationOwn_WndPhantomGroup",WZUILabelTTF):setText(string.format(LocalStrings.MOUNT_PILL_CNT,nOwnNum))
			-- 成功率
			local probability = tAdvanceInfo.probability / 100 -- tAdvanceInfo.probability / 10000 * 100
			GetElement(self.m_root,"txtActivationSuccess_WndPhantomGroup",WZUILabelTTF):setText(probability.."%")
			-- 进阶按钮
			GetElement(self.m_root,"btnAdvanced_WndPhantomGroup",WZUIButton):setTouchEnable(true)
		else --等级已满
			conSkillNext2:setVisible(false)
			imgSkillArrow2:setVisible(false)
			conAdvancedCost:setVisible(false)
			conAdvancedLevelMax:setVisible(true)
			-- 进阶按钮
			GetElement(self.m_root,"btnAdvanced_WndPhantomGroup",WZUIButton):setTouchEnable(false)
		end
		-- 幸运值
		local nLuckyRatio = math.floor(tCurShapeData.advanceBlessingValue / tAdvanceInfo.blessing * 100)
		GetElement(self.m_root,"txtActivationLuck_WndPhantomGroup",WZUILabelTTF):setText(LocalStrings.LUCKY_NAME..nLuckyRatio.."%")
		GetElement(self.m_root,"progActivationLuck_WndPhantomGroup",WZUIProgress):setPercentage(nLuckyRatio)
	else --激活界面
		GetElement(self.m_root,"imgSkillPrevIcon1_WndPhantomGroup",WZUIImage):setFile(tCurSkillInfo.icon)
		GetElement(self.m_root,"imgSkillPrevLevel1_WndPhantomGroup",WZUIImage):setFile(tCurSkillInfo.lv_icon)
		GetElement(self.m_root,"txtSkillPrevName1_WndPhantomGroup",WZUILabelTTF):setText(tCurSkillInfo.name)
		GetElement(self.m_root,"txtSkillPrevLv1_WndPhantomGroup",WZUILabelTTF):setText(LocalStrings.LV..tCurSkillInfo.specialAttackParam)
		GetElement(self.m_root,"txtSkillPrevDesc1_WndPhantomGroup",WZUILabelTTF):setText(tCurSkillInfo.tool_desc)
		--激活按钮
		GetElement(self.m_root,"btnActivation_WndPhantomGroup",WZUIButton):setTouchEnable(tCurShapeData.status == 1)
		local txtSkillActivateDesc = GetElement(self.m_root,"txtSkillActivateDesc_WndPhantomGroup",WZUILabelTTF)
		if tCurShapeData.status == 0 then
			txtSkillActivateDesc:setText(LocalStrings.PHANTOM_COMBINATION_2)
		else
			txtSkillActivateDesc:setText(LocalStrings.PHANTOM_COMBINATION_5)
		end
	end
end

--@brief	创建一个皮肤动画
function WndPhantomGroup:createShapeAni(nShapeId,nScale)
	pos = pos or GlobalMethod:ccp(0.5,0.5)
	playerAni = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, nil, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, nShapeId)
	playerAni:getAnimNode():setAnchorPoint(ccp(0.5,0.5))
	playerAni:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0.2))
	playerAni:getAnimNode():setTouchSwallow(false)
	playerAni:setScale(nScale)

	local conShape = WZUIContainer:create()
    conShape:setAbsContentSize(GlobalMethod:CCSize(150,300))
    conShape:setUseAbsSize(true)
    conShape:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	conShape:addChild(playerAni:getAnimNode())

    local btnJump = WZUIButton:create()
    btnJump:setTag(nShapeId) --用来点击按钮跳转具体皮肤id
    btnJump:setLuaDoneFunctionName("onClickJumpShape")
	conShape:addChild(btnJump)

	return conShape
end

--@brief 	点击跳转皮肤回调
function WndPhantomGroup:onClickJumpShape(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local shapeId = element:getTag()
	if shapeId > 0 then
		WndPets:jumpPhantomGroup(shapeId)
	end
end

--@brief	创建一个未激活图标容器
function WndPhantomGroup:createConInactive()
    local conInactive = WZUIContainer:create()
    conInactive:setAbsContentSize(GlobalMethod:CCSize(120,72))
    conInactive:setUseAbsSize(true)
	conInactive:setTouchSwallow(false)

    local imgInactive = WZUIImage:create()
    imgInactive:setFile("ui/common/common_bq_04.png")
    imgInactive:setUseOriginSize(true)
    conInactive:addChild(imgInactive)

    local txtInactive = WZUILabelTTF:create()
    txtInactive:setFontSize(24)
    txtInactive:setColor(GlobalMethod:ccc3(255,255,255))
    txtInactive:setRotation(-15)
    txtInactive:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
    conInactive:addChild(txtInactive)
    
    return conInactive
end

--@brief	点击返回按钮回调
function WndPhantomGroup:onClickBackBtn(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPhantomGroup.m_nUIType = 1
	WndPhantomGroup:updateUI()
end

--@brief	点击激活按钮回调
function WndPhantomGroup:onClickActivation(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local shapeGroupId = self.m_tData[self.m_nCurShapeIndex].shapeGroupId
	ProtocolProcessorPhantom:send_SHAPE_ActiveShapeGroup(shapeGroupId)
end

--@brief	点击进阶按钮回调
function WndPhantomGroup:onClickAdvanced(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tCurShapeData = self.m_tData[self.m_nCurShapeIndex]
	local tAdvanceInfo = GDatatab_shape_group_advance["id_"..tCurShapeData.advanceLevel]
	local tCost = tAdvanceInfo.cost
	if not JudgeMoneyIsEnough(tCost[1][1], tCost[1][2], nil, nil, GlobalGame.g_nCurrentUIChannelId) then 
		return 
	end

	local shapeGroupId = self.m_tData[self.m_nCurShapeIndex].shapeGroupId
	ProtocolProcessorPhantom:send_SHAPE_AdvanceShapeGroup(shapeGroupId)
end

--@brief	点击前一个皮肤回调
function WndPhantomGroup:onClickPrevShape(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nCurShapeIndex <= 1 then
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_COMBINATION_6)
		return
	end
	self.m_nCurShapeIndex = self.m_nCurShapeIndex - 1
	
	local nMaxPageNum = 10 --每页最多展示数量
	self.m_nCurPagesNum = math.ceil(self.m_nCurShapeIndex / nMaxPageNum)

	self:updateUI()
end

--@brief	点击后一个皮肤回调
function WndPhantomGroup:onClickNextShape(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nCurShapeIndex >= #self.m_tData then
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_COMBINATION_7)
		return
	end
	self.m_nCurShapeIndex = self.m_nCurShapeIndex + 1

	local nMaxPageNum = 10 --每页最多展示数量
	self.m_nCurPagesNum = math.ceil(self.m_nCurShapeIndex / nMaxPageNum)

	self:updateUI()
end

--@brief	点击后一个皮肤回调
function WndPhantomGroup:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.PHANTOM_COMBINATION_8)
end

--@brief	点击属性按钮回调
function WndPhantomGroup:onClickProp(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {level=self.m_tData[self.m_nCurShapeIndex].advanceLevel,property=self.m_tProperty,fighting=self.m_nFighting}
	WndTips:show(element, self.m_root, 80, tData, GlobalMethod:ccp(0,-150))
end

--@brief	点击进阶消耗物品回调
function WndPhantomGroup:onClickActivationItem(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tCurShapeData = self.m_tData[self.m_nCurShapeIndex]
	local tAdvanceInfo = GDatatab_shape_group_advance["id_"..tCurShapeData.advanceLevel]
	local tCost = tAdvanceInfo.cost
	local tItemInfo = GDatatab_item["id_"..tCost[1][1]]
	WndItemInfo:showInfo(element,self.m_root,1,tItemInfo,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------皮肤组合格子begin----------------------------------------

--@brief	点击皮肤组合格子回调
function CellPhantomGroup:onClickGroupItem(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPhantomGroup.m_nCurShapeIndex = self.m_nIndex
	WndPhantomGroup.m_nUIType = 2
	WndPhantomGroup:updateUI()
end

-------------------------------------皮肤组合格子end----------------------------------------

function WndPhantomGroup:_adaptLanguage_vn()
	local txtSkillPrevDesc1 = GetElement(self.m_root,"txtSkillPrevDesc1_WndPhantomGroup",WZUILabelTTF)
	txtSkillPrevDesc1:setFontSize(16)
	local txtSkillPrevDesc2 = GetElement(self.m_root,"txtSkillPrevDesc2_WndPhantomGroup",WZUILabelTTF)
	txtSkillPrevDesc2:setFontSize(16)
	local txtSkillNextDesc2 = GetElement(self.m_root,"txtSkillNextDesc2_WndPhantomGroup",WZUILabelTTF)
	txtSkillNextDesc2:setFontSize(16)
end