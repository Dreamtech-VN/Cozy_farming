--WndMarriage.lua
--@brief	WndMarriage的UI模块
--@date		2022/07/19
--@author	yrd
--@note		夫妻界面-姻缘


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarriage:onEnter(element)
	self.m_root = element

	self:_initStaticText()

    self:updatePlayerInfo()

    ProtocolProcessorWndMarriage:regAll()
    WndMarryManager:createLoading()
    ProtocolProcessorWndMarriage:send_COUPLE_MarriageInfo()

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarriage:onExit(element)
	self:_unInit()
	ProtocolProcessorWndMarriage:unregAll()
end

--@brief  初始化静态文本
function WndMarriage:_initStaticText()
	GetElement(self.m_root,"txtMarriageExpWord_WndMarriage",WZUILabelTTF):setText("Exp:")
	GetElement(self.m_root,"txtMarriageLuckWord_WndMarriage",WZUILabelTTF):setText(LocalStrings.COUPLE_TEXT2[2]..":")
	GetElement(self.m_root,"txtBtnConnected_WndMarriage",WZUILabelTTF):setText(LocalStrings.COUPLE_TEXT2[3])

	self:_setSpineAni()
end

--@brief  更新夫妻关系信息
function WndMarriage:updateInfo()
    local wifeName =  WZUILabelTTF:luaTo(self.m_root:getChildElement("txtWifeName_WndMarriage"))
    local husbandName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtHusbandName_WndMarriage"))
    wifeName:setText(self.m_sWomanName)
    husbandName:setText(self.m_sManeName)
    if self.m_nManServerId ~= CacheCenter:getPlayerInfo().serverId then 
        GetElement(self.m_root, "imgKuafuIconHb_WndMarriage", WZUIImage):setVisible(true)
    end
    if self.m_nWomanServerId ~= CacheCenter:getPlayerInfo().serverId then 
        GetElement(self.m_root, "imgKuafuIconWife_WndMarriage", WZUIImage):setVisible(true)
    end
    
    if not self.m_bPlayerLoadFinish then
        local conWifeImage = WZUIContainer:luaTo(self.m_root:getChildElement("conWifeFigure_WndMarriage"))
        local conHusbandImg = WZUIContainer:luaTo(self.m_root:getChildElement("conHusbandFigure_WndMarriage"))

        self:showPlayerAnim(0,self.m_nManHeadId,self.m_nManFaceId,self.m_nManBodyId, self.m_nManWingId,conHusbandImg, self.m_nManHeadColor,self.m_nManBodyColor)
        self:showPlayerAnim(1,self.m_nWomanHeadId,self.m_nWomanFaceId,self.m_nWomanBodyId, self.m_nWomanWingId,conWifeImage,self.m_nWomanHeadColor,self.m_nWomanBodyColor)

        self:showCoupleAnimation()

	    self.m_bPlayerLoadFinish = true
    end
end

--@brief   玩家人物
function WndMarriage:showPlayerAnim(sex,head,face,body,wing,conAmin,headColor,bodyColor)
    local nSex = sex--玩家性别 

    local tEquip = nil
    tEquip = { head,face,body,wing}
    local conPlayer = CreatePlayerFigure(nSex,tEquip,nil,nil,nil,nil,nil,nil,nil,nil,headColor,bodyColor,false)
    conAmin:removeChildByTag(50,true)
    local animNode = conPlayer:getAnimNode()
    animNode:setTouchEnable(false)
    animNode:setTag(50)
    animNode:setAnchorPoint(GlobalMethod:ccp(0.5,0))
    animNode:setRelativePosition(GlobalMethod:ccp(0.5,-0.02))
    --animNode:setScale(0.8)
    conAmin:addChild(animNode)
    if sex == 0 then
        conPlayer:setFlipX(true)
    end
end

--@brief   更新姻缘信息
function WndMarriage:updateMarriageInfo()
	WZLog("WndMarriage:updateMarriageInfo",tostring(self.m_bIsTraining),self.m_nSoulLevel,self.m_nCurSoulExp)
	if self.m_bIsTraining ~= true then
		self.m_nSoulLevel = self.m_nLvl 
		self.m_nCurSoulExp = self.m_nExp
	end

	if self.m_nSoulLevel > self.m_nLvl then
		self.m_nSoulLevel = self.m_nLvl 
		self.m_nCurSoulExp = self.m_nExp
		self.m_bIsTraining = false
	elseif self.m_nSoulLevel == self.m_nLvl and self.m_nCurSoulExp > self.m_nExp then
		self.m_nSoulLevel = self.m_nLvl 
		self.m_nCurSoulExp = self.m_nExp
		self.m_bIsTraining = false
	end

	local nextLevel = self.m_nSoulLevel + 1
	local tNextLevelInfo = GDatatab_marry_level["id_"..nextLevel]

	if tNextLevelInfo then
		self.m_nTotalExpForAni = tonumber(tNextLevelInfo.blessing)
	end

	local conOperation0 = GetElement(self.m_root,"conOperation0_WndMarriage",WZUIContainer)
	local conOperation1 = GetElement(self.m_root,"conOperation1_WndMarriage",WZUIContainer)
	local conOperation2 = GetElement(self.m_root,"conOperation2_WndMarriage",WZUIContainer)

	--爱心
	local imgLove = GetElement(self.m_root,"imgLove_WndMarriage",WZUIImage)
	if self.m_nSoulLevel <= 39 then
		imgLove:setFile("ui/common/progress_marry_fq_01.png")
	elseif self.m_nSoulLevel <= 79 then
		imgLove:setFile("ui/common/progress_marry_fq_02.png")
	elseif self.m_nSoulLevel <= 100 then
		imgLove:setFile("ui/common/progress_marry_fq_03.png")
	end

	--玩家操作栏
	if self.m_bIsTraining ~= true then
		if tNextLevelInfo == nil then
			conOperation0:setVisible(true)
			conOperation1:setVisible(false)
			conOperation2:setVisible(false)
		elseif tNextLevelInfo and tNextLevelInfo.type == 1 then
			conOperation0:setVisible(false)
			conOperation1:setVisible(true)
			conOperation2:setVisible(false)
		elseif tNextLevelInfo and tNextLevelInfo.type == 2 then
			conOperation0:setVisible(false)
			conOperation1:setVisible(false)
			conOperation2:setVisible(true)
		end
	end

	--进度条
	if tNextLevelInfo == nil then
		self:setDynamicPrg(100)
	elseif tNextLevelInfo and tNextLevelInfo.type == 1 then
		self:setDynamicPrg(self.m_nCurSoulExp/tNextLevelInfo.blessing*100)
	elseif tNextLevelInfo and tNextLevelInfo.type == 2 then
		self:setDynamicPrg(self.m_nLuckyValue/tNextLevelInfo.blessing*100)
	end

	--人物下方的经验或幸运值
	local conExp1 = GetElement(self.m_root,"conExp1_WndMarriage",WZUIContainer)
	local conExp2 = GetElement(self.m_root,"conExp2_WndMarriage",WZUIContainer)

	if tNextLevelInfo == nil then
		conExp1:setVisible(false)
		conExp2:setVisible(false)
	elseif tNextLevelInfo and tNextLevelInfo.type == 1 then
		conExp1:setVisible(true)
		conExp2:setVisible(false)
		GetElement(self.m_root,"txtMarriageExpValue_WndMarriage",WZUILabelTTF):setText(self.m_nCurSoulExp.."/"..tNextLevelInfo.blessing)
	elseif tNextLevelInfo and tNextLevelInfo.type == 2 then
		conExp1:setVisible(false)
		conExp2:setVisible(true)
		GetElement(self.m_root,"txtMarriageLuckValue_WndMarriage",WZUILabelTTF):setText(math.floor(self.m_nLuckyValue/tNextLevelInfo.blessing*100).."%")
	end

	--消耗
	if self.m_bIsTraining ~= true then
		if tNextLevelInfo and tNextLevelInfo.type == 1 then
			self:updateCostList()

			local nLevelDifference = self.m_nCoupleLvl - self.m_nSoulLevel
			if nLevelDifference > 0 then
				local marryLeveladd = CacheCenter:getGameParam().marryLeveladd
				local nAddLuckyRatio = nLevelDifference * marryLeveladd / 100
				GetElement(self.m_root,"txtItemAddLucky_WndMarriage",WZUILabelTTF):setText("(+".. nAddLuckyRatio .."%)")
			else
				GetElement(self.m_root,"txtItemAddLucky_WndMarriage",WZUILabelTTF):setText("")
			end
		elseif tNextLevelInfo and tNextLevelInfo.type == 2 then
			local itemInfo = GDatatab_item["id_"..tNextLevelInfo.item[1][1]]
			local strFormat = [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T><I Z="0.5">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T><T C="127,70,26" S="20" P="1">%s</T>]]
			local strContent = string.format(strFormat, LocalStrings.COST, itemInfo.icon, tNextLevelInfo.item[1][2], string.format(LocalStrings.MOUNT_PILL_CNT, getBagItemCount(tNextLevelInfo.item[1][1])))
			local ftbCostItem1 = GetElement(self.m_root,"ftbCostItem1_WndMarriage",WZUIFreeTextBox)
			ftbCostItem1:setShowText(strContent)

			local strFormat2 = [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T><T C="255,227,116" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T>]]
			strContent2 = string.format(strFormat2,LocalStrings.BAGTIP12,(tNextLevelInfo.rate/100).."%")
			local ftbCostItem2 = GetElement(self.m_root,"ftbCostItem2_WndMarriage",WZUIFreeTextBox)
			ftbCostItem2:setShowText(strContent2)
		end
	end

	--属性
	local nCurLevel = self.m_nSoulLevel
	local nextLevel = nCurLevel + 1
	local tCurLevelInfo = GDatatab_marry_level["id_"..nCurLevel]
	local tNextLevelInfo = GDatatab_marry_level["id_"..nextLevel]
	local conPlayerProp = GetElement(self.m_root,"conPlayerProp_WndMarriage",WZUIContainer)
	conPlayerProp:removeAllChildrenWithCleanup(true)
	local propPtY = 0.95
	local strNextLv = nextLevel
	if tNextLevelInfo == nil then
		strNextLv = "MAX"
	end
	WndMarriage:createPropertyGrid(conPlayerProp,ccp(0.5,propPtY),LocalStrings.LEVEL..":",nCurLevel,strNextLv)
	if tCurLevelInfo then
		if tNextLevelInfo then
			for i=1,#tNextLevelInfo.property_rate do
				local strCurProperty = tCurLevelInfo.property_rate[i] and tCurLevelInfo.property_rate[i][2] or ""
				WndMarriage:createPropertyGrid(conPlayerProp,ccp(0.5,propPtY-(i*0.075)),ATTR_TITLE[tNextLevelInfo.property_rate[i][1]]..":",strCurProperty,tNextLevelInfo.property_rate[i][2])
			end
		else
			for i=1,#tCurLevelInfo.property_rate do
				local strNextProperty = tNextLevelInfo and tNextLevelInfo.property_rate[i][2] or "MAX"
				WndMarriage:createPropertyGrid(conPlayerProp,ccp(0.5,propPtY-(i*0.075)),ATTR_TITLE[tCurLevelInfo.property_rate[i][1]]..":",tCurLevelInfo.property_rate[i][2],strNextProperty)
			end
		end
	else
		for i=1,#tNextLevelInfo.property_rate do
			WndMarriage:createPropertyGrid(conPlayerProp,ccp(0.5,propPtY-(i*0.075)),ATTR_TITLE[tNextLevelInfo.property_rate[i][1]]..":",0,tNextLevelInfo.property_rate[i][2])
		end
	end


	--自己等级
	GetElement(self.m_root,"txtMarriageLevel_WndMarriage",WZUILabelTTF):setText(LocalStrings.LV.."."..self.m_nSoulLevel)
	--伴侣等级
	local txtCompanionLevel = GetElement(self.m_root,"txtCompanionLevel_WndMarriage",WZUILabelTTF)
	txtCompanionLevel:setText(LocalStrings.COUPLE_TEXT2[4]..":"..self.m_nCoupleLvl)

	--技能
	local nMinLevel = math.min(self.m_nSoulLevel, self.m_nCoupleLvl)
	local tMinLevelInfo = GDatatab_marry_level["id_"..nMinLevel]
	if tMinLevelInfo and tMinLevelInfo.buff_id ~= -1 then
		GetElement(self.m_root,"conSkill_WndMarriage",WZUIContainer):setVisible(true)
		local tBuffInfo = GDatatab_buff["id_"..tMinLevelInfo.buff_id]
		GetElement(self.m_root,"imgSkill_WndMarriage",WZUIImage):setFile("battleitems/" .. tBuffInfo.buff_icon .. ".png")
		GetElement(self.m_root,"txtSkill1_WndMarriage",WZUILabelTTF):setText(tBuffInfo.buff_name)
		GetElement(self.m_root,"txtSkill2_WndMarriage",WZUILabelTTF):setText(tBuffInfo.buff_remark)
		GetElement(self.m_root,"txtNoSkill_WndMarriage",WZUILabelTTF):setText("")
	else
		GetElement(self.m_root,"conSkill_WndMarriage",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"txtSkill1_WndMarriage",WZUILabelTTF):setText("")
		GetElement(self.m_root,"txtSkill2_WndMarriage",WZUILabelTTF):setText("")
	
		local myMarry = GDatatab_marry_level["id_"..self.m_nSoulLevel]
		local coupleMarry = GDatatab_marry_level["id_"..self.m_nCoupleLvl]
		if myMarry == nil or myMarry and myMarry.buff_id == -1 then
			GetElement(self.m_root,"txtNoSkill_WndMarriage",WZUILabelTTF):setText(LocalStrings.COUPLE_TEXT2[8])
		elseif coupleMarry == nil or coupleMarry and coupleMarry.buff_id == -1 then
			GetElement(self.m_root,"txtNoSkill_WndMarriage",WZUILabelTTF):setText(LocalStrings.COUPLE_TEXT2[9])
		end
	end
end

--@brief   创建一个属性条
function WndMarriage:createPropertyGrid(element,pt,txtW,txt1,txt2)
	local con = WZUIContainer:create()
	con:setAbsContentSize(GlobalMethod:CCSize(360,20))
    con:setUseAbsSize(true)
    con:setRelativePosition(pt)
    element:addChild(con)

	local ttf1 = WZUILabelTTF:create()
	ttf1:setText(txtW)
	ttf1:setFontSize(20)
	ttf1:setColor(GlobalMethod:ccc3(127,70,26))
	ttf1:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttf1:setRelativePosition(GlobalMethod:ccp(0.04,0.5))
	ttf1:setVisible(txt1~="")
	con:addChild(ttf1)

	local ttf2 = WZUILabelTTF:create()
	ttf2:setText(txt1)
	ttf2:setFontSize(20)
	ttf2:setColor(GlobalMethod:ccc3(229,105,22))
	ttf2:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttf2:setRelativePosition(GlobalMethod:ccp(0.23,0.5))
	ttf2:setVisible(txt1~="")
	con:addChild(ttf2)

	local imgJT = WZUIImage:create()
	imgJT:setFile("ui/common/common_icon_jiehunjiantou.png")
	imgJT:setUseOriginSize(true)
	imgJT:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	imgJT:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	imgJT:setScale(0.8)
	con:addChild(imgJT)

	local ttf3 = WZUILabelTTF:create()
	ttf3:setText(txtW)
	ttf3:setFontSize(20)
	ttf3:setColor(GlobalMethod:ccc3(127,70,26))
	ttf3:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttf3:setRelativePosition(GlobalMethod:ccp(0.64,0.5))
	con:addChild(ttf3)

	local ttf4 = WZUILabelTTF:create()
	ttf4:setText(txt2)
	ttf4:setFontSize(20)
	ttf4:setColor(GlobalMethod:ccc3(99,255,95))
	ttf4:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	ttf4:setRelativePosition(GlobalMethod:ccp(0.83,0.5))
	con:addChild(ttf4)
end

--@brief   更新升级时消耗物品列表
function WndMarriage:updateCostList()
	local nextLevel = self.m_nLvl + 1
	local tNextLevelInfo = GDatatab_marry_level["id_"..nextLevel]

	self.m_tCostItemList = {}
	for i=1,3 do
		local conCostItem = GetElement(self.m_root,"conCostItem"..i.."_WndMarriage",WZUIContainer)
		conCostItem:removeAllChildrenWithCleanup(true)
		if tNextLevelInfo.item[1][i] then
			local element, tLuaObj = CellGoodItem:createElement()
			tLuaObj:setCellGoodLocalId(tNextLevelInfo.item[1][i], getBagItemCount(tNextLevelInfo.item[1][i]), 17, true)
			tLuaObj:setItemClickFun(self,self.onSelectCostItem)
			element:setScale(0.88)
			element:setTag(i)
			conCostItem:addChild(WZUIContainer:luaTo(element))
			table.insert(self.m_tCostItemList,tLuaObj)
		end
	end

	self:updateSelectCost()
end

--@brief   更新选中物品
function WndMarriage:updateSelectCost()
	if self.m_nCostSelectIdx > #self.m_tCostItemList then
		self.m_nCostSelectIdx = 1
	end

	for i=1,#self.m_tCostItemList do
		self.m_tCostItemList[i]:setItemSelState2(false)
	end
	self.m_tCostItemList[self.m_nCostSelectIdx]:setItemSelState2(true)

	--更新加成显示
	local nAddNum = self.m_tCostItemList[self.m_nCostSelectIdx]:getData().basicInfo.value
	local txtItemAddValue = GetElement(self.m_root,"txtItemAddValue_WndMarriage",WZUILabelTTF)
	txtItemAddValue:setText(LocalStrings.COUPLE_TEXT2[11].."+"..nAddNum)
end

--@brief   点击选择消耗物品
function WndMarriage:onSelectCostItem(luaTable,tag,tData)
	self.m_nCostSelectIdx = tag
	self:updateSelectCost()
end

--@brief   点击使用消耗去升级
function WndMarriage:onClickUpgrade(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local nTag = element:getTag()

	if self.m_bIsTraining then
		return
	end

	if nTag == 1 then
		local nextLevel = self.m_nLvl + 1
		local tNextLevelInfo = GDatatab_marry_level["id_"..nextLevel]
		if tNextLevelInfo.type == 2 then
			MsgBoxManager:showTipBox(LocalStrings.COUPLE_TEXT2[10])
			return
		end
		if tNextLevelInfo == nil then
			MsgBoxManager:showTipBox(LocalStrings.COUPLE_TEXT2[7])
			return
		end

		local itemId = self.m_tCostItemList[self.m_nCostSelectIdx]:getData().basicInfo.id
		local num = 1

	    if not JudgeMoneyIsEnough(itemId, num, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
	        return 
	    end
		ProtocolProcessorWndMarriage:send_COUPLE_MarriageUpgrade(1, itemId, num)
	elseif nTag == 2 then
		local nextLevel = self.m_nLvl + 1
		local tNextLevelInfo = GDatatab_marry_level["id_"..nextLevel]
		if tNextLevelInfo.type == 2 then
			MsgBoxManager:showTipBox(LocalStrings.COUPLE_TEXT2[10])
			return
		end
		if tNextLevelInfo == nil then
			MsgBoxManager:showTipBox(LocalStrings.COUPLE_TEXT2[7])
			return
		end

		local itemId = self.m_tCostItemList[self.m_nCostSelectIdx]:getData().basicInfo.id
		local num = 5

	    if not JudgeMoneyIsEnough(itemId, num, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
	        return 
	    end
		ProtocolProcessorWndMarriage:send_COUPLE_MarriageUpgrade(1, itemId, num)
	elseif nTag == 3 then
		local nextLevel = self.m_nLvl + 1
		local tNextLevelInfo = GDatatab_marry_level["id_"..nextLevel]
		if tNextLevelInfo == nil then
			MsgBoxManager:showTipBox(LocalStrings.COUPLE_TEXT2[7])
			return
		end

		local itemId = tNextLevelInfo.item[1][1]
		local num = tNextLevelInfo.item[1][2]
		
	    if not JudgeMoneyIsEnough(itemId, num, nil, nil, GlobalGame.g_nCurrentUIChannelId) then
	        return 
	    end
		ProtocolProcessorWndMarriage:send_COUPLE_MarriageUpgrade(2, itemId, num)
	end
end

--@brief    设置爱心进度
function WndMarriage:setDynamicPrg(nPercentage)
    --进度条
    local progressExp = GetElement(self.m_root, "progressExp_WndMarriage", WZUIProgress)
    if progressExp then
        progressExp:setPercentage(nPercentage)
    end
    --水纹的大小
    local spineCrimp = GetElement(self.m_root, "spineCrimp_WndMarriage", WZUISpine)
    local spineBubble = GetElement(self.m_root, "spineBubble_WndMarriage", WZUISpine)
    local nPtY1 = nPercentage / 100
    if spineCrimp then
        spineCrimp:setRelativePosition(GlobalMethod:ccp(0.5,  nPtY1))
    end
    local offY = -0.5
	local nPtY2 = nPercentage / 100 + offY
    if spineBubble then
        spineBubble:setRelativePosition(GlobalMethod:ccp(0.5, nPtY2))
    end
end


--@brief    挖到宝物的特效
function WndMarriage:_displayTrainParticle(nTag)
    WZLog("WndMarriage:_displayTrainParticle", nTag)
    local nLineIndex = math.floor(math.random(1,3))

    local particleTrain = CCParticleSystemQuad:create("particle/ui_juexingzhihun_tuowei.plist")
    particleTrain:setDuration(kCCParticleDurationInfinity)
    particleTrain:setAutoRemoveOnFinish(true)


	local tQualityColor = {{99,255,95},{93,222,254},{198,130,255},{233,166,62},{255,89,74}}
    local nItemquality = self.m_tCostItemList[nTag]:getData().basicInfo.quality
    if nTag == 1 then
        particleTrain:setStartColor(ccc4f(tQualityColor[nItemquality][1]/255,tQualityColor[nItemquality][2]/255,tQualityColor[nItemquality][3]/255,1))
        particleTrain:setEndColor(ccc4f(0,0,0,0))
    elseif nTag == 2 then
        particleTrain:setStartColor(ccc4f(tQualityColor[nItemquality][1]/255,tQualityColor[nItemquality][2]/255,tQualityColor[nItemquality][3]/255,1))
        particleTrain:setEndColor(ccc4f(0,0,0,0))
    elseif nTag == 3 then
        particleTrain:setStartColor(ccc4f(tQualityColor[nItemquality][1]/255,tQualityColor[nItemquality][2]/255,tQualityColor[nItemquality][3]/255,1))
        particleTrain:setEndColor(ccc4f(0,0,0,0))
    end
    particleTrain:setPosition(self.m_tStartPoint[nTag][1], self.m_tStartPoint[nTag][2])

    local conContent = GetElement(self.m_root, "conContent_WndMarriage", WZUIContainer)
    conContent:addChild(particleTrain)

    if particleTrain then
        particleTrain:setVisible(true)

        local arrayAni = CCArray:create()

        local delayAni2 = CCDelayTime:create(0.3)
        local delayAni3 = CCDelayTime:create(0.5)
        local moveTo
        if nLineIndex == 1 then
            moveTo = CCMoveTo:create(0.5, ccp(self.m_tTargetPoint[1][1], self.m_tTargetPoint[1][2]))
        elseif nLineIndex == 2 then
            local configInfo = ccBezierConfig()
            configInfo.endPosition = GlobalMethod:ccp(self.m_tTargetPoint[1][1],self.m_tTargetPoint[1][2])
            configInfo.controlPoint_1 = GlobalMethod:ccp(self.m_tSecondPoint[nTag][1][1],self.m_tSecondPoint[nTag][1][2])
            configInfo.controlPoint_2 = GlobalMethod:ccp(self.m_tThirdPoint[nTag][1][1],self.m_tThirdPoint[nTag][1][2])

            moveTo = CCBezierTo:create(0.5, configInfo)
        else
            local configInfo = ccBezierConfig()
            configInfo.endPosition = GlobalMethod:ccp(self.m_tTargetPoint[1][1],self.m_tTargetPoint[1][2])
            configInfo.controlPoint_1 = GlobalMethod:ccp(self.m_tSecondPoint[nTag][2][1],self.m_tSecondPoint[nTag][2][2])
            configInfo.controlPoint_2 = GlobalMethod:ccp(self.m_tThirdPoint[nTag][2][1],self.m_tThirdPoint[nTag][2][2])

            moveTo = CCBezierTo:create(0.5, configInfo)
        end
        local delayAni5 = CCDelayTime:create(0.5)
        local functionAni4 = CCCallFuncN:create(WndMarriage_afterParticle)

        arrayAni:addObject(delayAni3)
        arrayAni:addObject(moveTo)
        arrayAni:addObject(delayAni2)
        arrayAni:addObject(delayAni5)
        arrayAni:addObject(functionAni4)

        local sequence = CCSequence:create(arrayAni)
        particleTrain:runAction(sequence)
    end
end

--@brief    特效播放完成后的回调
function WndMarriage_afterParticle(element)

    if WndMarriage.baseExp[WndMarriage.m_nIndex] then
	    WndMarriage.m_nTempBaseExp = WndMarriage.baseExp[WndMarriage.m_nIndex] 
	    WndMarriage.m_nDoubleTimes = WndMarriage.multiple[WndMarriage.m_nIndex] 
	    WndMarriage:_createAtlasFont(WndMarriage.m_nTempBaseExp, WndMarriage.m_nDoubleTimes)

	    --展示经验条变化动画
	    WndMarriage:showProgress()
		WndMarriage.m_nIndex = WndMarriage.m_nIndex + 1
	end

    if element then
        element:removeFromParentAndCleanup(true)
    end
end

function WndMarriage:_createAtlasFont(nAddNum, nMultiple)
    WZLog("WndMarriage:_createAtlasFont")
    --音效
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS2) 
    --加号
    local imgAddSign = WZUIImage:create()
    imgAddSign:setFile("ui/common_num/jy_+.png")
    imgAddSign:setUseOriginSize(true)
    imgAddSign:setAnchorPoint(ccp(1, 0.5))
    imgAddSign:setRelativePosition(ccp(0.59, 0.5))

    --增加的类型图标
    local txtExp = WZUILabelTTF:create()
    txtExp:setFontSize(34)
    txtExp:setAnchorPoint(ccp(0, 0.5))
    txtExp:setRelativePosition(ccp(0.595, 0.5))
    txtExp:setText(LocalStrings.COUPLE_TEXT2[11])
    txtExp:setColor(GlobalMethod:ccc3(255,255,255))
    txtExp:setStrokeColor(GlobalMethod:ccc3(176,32,212))
    txtExp:setEnableStroke(true)
    txtExp:setStrokeSize(4)

    --获得的结果数量
    local txtAtlasFont = WZUILabelAtlasFont:create()
    txtAtlasFont:setCharMapFileName("ui/common_num/jy_0-9.png")
    txtAtlasFont:setStartChar(48)
    txtAtlasFont:setHeight(33)
    txtAtlasFont:setWidth(23)
    txtAtlasFont:setUseOriginSize(true)
    txtAtlasFont:setAnchorPoint(ccp(0, 0.5))
    txtAtlasFont:setRelativePosition(ccp(0.86, 0.5))

    txtAtlasFont:setText(nAddNum)

    local imgBaoJi = nil 
    local imgMulSign = nil 
    local txtAtlasBaoJiNum = nil

    if nMultiple > 1 and nMultiple < 5 then
    	--暴击
        imgBaoJi = WZUIImage:create()
        imgBaoJi:setFile("ui/marrige/common_icon_jy_hyxd.png")
        imgBaoJi:setUseOriginSize(true)
        imgBaoJi:setAnchorPoint(ccp(0, 0.5))
        imgBaoJi:setRelativePosition(ccp(-0.17, 0.5))
        --乘号
        imgMulSign = WZUIImage:create()
        imgMulSign:setFile("ui/common_num/jy_x.png")
        imgMulSign:setUseOriginSize(true)
        imgMulSign:setAnchorPoint(ccp(1, 0.5))
        imgMulSign:setRelativePosition(ccp(0.4, 0.5))
        --暴击倍数
        txtAtlasBaoJiNum = WZUILabelAtlasFont:create()
        txtAtlasBaoJiNum:setCharMapFileName("ui/common_num/jy_0-9.png")
        txtAtlasBaoJiNum:setStartChar(48)
        txtAtlasBaoJiNum:setHeight(33)
        txtAtlasBaoJiNum:setWidth(23)
        txtAtlasBaoJiNum:setUseOriginSize(true)
        txtAtlasBaoJiNum:setAnchorPoint(ccp(0, 0.5))
        txtAtlasBaoJiNum:setRelativePosition(ccp(0.4, 0.5))
        txtAtlasBaoJiNum:setText(nMultiple)
    elseif nMultiple >= 5 and nMultiple < 10 then
    	--暴击
        imgBaoJi = WZUIImage:create()
        imgBaoJi:setFile("ui/marrige/common_icon_jy_xxxy.png")
        imgBaoJi:setUseOriginSize(true)
        imgBaoJi:setAnchorPoint(ccp(0, 0.5))
        imgBaoJi:setRelativePosition(ccp(-0.17, 0.5))
        --乘号
        imgMulSign = WZUIImage:create()
        imgMulSign:setFile("ui/common_num/jy_x.png")
        imgMulSign:setUseOriginSize(true)
        imgMulSign:setAnchorPoint(ccp(1, 0.5))
        imgMulSign:setRelativePosition(ccp(0.4, 0.5))
        --暴击倍数
        txtAtlasBaoJiNum = WZUILabelAtlasFont:create()
        txtAtlasBaoJiNum:setCharMapFileName("ui/common_num/jy_0-9.png")
        txtAtlasBaoJiNum:setStartChar(48)
        txtAtlasBaoJiNum:setHeight(33)
        txtAtlasBaoJiNum:setWidth(23)
        txtAtlasBaoJiNum:setUseOriginSize(true)
        txtAtlasBaoJiNum:setAnchorPoint(ccp(0, 0.5))
        txtAtlasBaoJiNum:setRelativePosition(ccp(0.4, 0.5))
        txtAtlasBaoJiNum:setText(nMultiple)
    elseif nMultiple >= 10 then
    	--暴击
        imgBaoJi = WZUIImage:create()
        imgBaoJi:setFile("ui/marrige/common_icon_jy_yjtx.png")
        imgBaoJi:setUseOriginSize(true)
        imgBaoJi:setAnchorPoint(ccp(0, 0.5))
        imgBaoJi:setRelativePosition(ccp(-0.17, 0.5))
        --乘号
        imgMulSign = WZUIImage:create()
        imgMulSign:setFile("ui/common_num/jy_x.png")
        imgMulSign:setUseOriginSize(true)
        imgMulSign:setAnchorPoint(ccp(1, 0.5))
        imgMulSign:setRelativePosition(ccp(0.4, 0.5))
        --暴击倍数
        txtAtlasBaoJiNum = WZUILabelAtlasFont:create()
        txtAtlasBaoJiNum:setCharMapFileName("ui/common_num/jy_0-9.png")
        txtAtlasBaoJiNum:setStartChar(48)
        txtAtlasBaoJiNum:setHeight(33)
        txtAtlasBaoJiNum:setWidth(23)
        txtAtlasBaoJiNum:setUseOriginSize(true)
        txtAtlasBaoJiNum:setAnchorPoint(ccp(0, 0.5))
        txtAtlasBaoJiNum:setRelativePosition(ccp(0.4, 0.5))
        txtAtlasBaoJiNum:setText(nMultiple)
    else  --没有暴击时候，居中
        imgAddSign:setAnchorPoint(ccp(0.5, 0.5))
        imgAddSign:setRelativePosition(ccp(0.27, 0.5))

        txtExp:setAnchorPoint(ccp(1, 0.5))
        txtExp:setRelativePosition(ccp(0.45, 0.5))

        txtAtlasFont:setAnchorPoint(ccp(0, 0.5))
        txtAtlasFont:setRelativePosition(ccp(0.5, 0.5))
    end

    local conResult = WZUIContainer:create()
	conResult:setAbsContentSize(GlobalMethod:CCSize(440,100))
	conResult:setUseAbsSize(true)
    local conRoot = GetElement(self.m_root, "conContent_WndMarriage", WZUIContainer)

     if conResult then
        conResult:addChild(imgAddSign)
        conResult:addChild(txtExp)
        conResult:addChild(txtAtlasFont)
        if nMultiple > 1 then
            conResult:addChild(imgBaoJi)
            conResult:addChild(imgMulSign)
            conResult:addChild(txtAtlasBaoJiNum)
        end
        conRoot:addChild(conResult, 10, 10)
     end
    --购买成功后的界面特效
    local actionScaleTo1 = WZUIActionScaleTo:create()
    actionScaleTo1:setDuration(0.2)
    actionScaleTo1:setScaleY(1.1)
    actionScaleTo1:setScaleX(1.1)
    local actionScaleTo2 = WZUIActionScaleTo:create()
    actionScaleTo2:setDuration(0.2)
    actionScaleTo2:setScaleY(0.7)
    actionScaleTo2:setScaleX(0.7)
    local actionScaleTo3 = WZUIActionScaleTo:create()
    actionScaleTo3:setDuration(0.2)
    actionScaleTo3:setScaleY(0.85)
    actionScaleTo3:setScaleX(0.85)
     local actionScaleTo4 = WZUIActionScaleTo:create()
    actionScaleTo4:setDuration(0.5)
    actionScaleTo4:setScaleY(0.85)
    actionScaleTo4:setScaleX(0.85)
    local actionSqu = WZUIActionSequence:create()
    actionSqu:setIsLoop(false)
    actionSqu:setChildAction(actionScaleTo1)
    actionSqu:setChildAction(actionScaleTo2)
    actionSqu:setChildAction(actionScaleTo3)
    actionSqu:setChildAction(actionScaleTo4)

    local action = WZUIActionSpawn:create()

    local actMoveTo = WZUIActionMoveTo:create()
    actMoveTo:setDuration(0.6)
    actMoveTo:setMoveX(0.5)
    actMoveTo:setMoveY(0.65)

    local actFadeTo = WZUIActionContainerFadeFromTo:create()
    actFadeTo:setDuration(0.6)
    actFadeTo:setOpacityFrom(255)
    actFadeTo:setOpacityTo(0)

    action:setChildAction(actFadeTo)
    action:setChildAction(actMoveTo)

    actionSqu:setChildAction(action)
    actionSqu:setFinishLuaFunction("onActionFinishBack")

    conResult:runUIAction(actionSqu)
end

function WndMarriage:onActionFinishBack(element, b)
    -- body
    WZLog("***********************WndMarriage:onActionFinishBack****************************")
    local conContent = GetElement(self.m_root, "conContent_WndMarriage", WZUIContainer)
    if conContent then
        conContent:disableSchedule()
    end

    element:removeFromParentAndCleanup(true)
    element = nil
end

--@brief    滚动显示消耗进度
function WndMarriage:showProgress()
    self.m_nTempExp = self.m_nCurSoulExp
    self.m_nEachAddExpForPgr = math.floor(self.m_nTotalExpForAni/50)
    self.m_nTempLevel = self.m_nSoulLevel

    local conSoulLeft = GetElement(self.m_root, "conLoveProgress_WndMarriage", WZUIContainer)
    if conSoulLeft then
        WZLog("WndMarriage:showProgress")
        conSoulLeft:enableSchedule("displayPrg", 0.01)
    end
end

function WndMarriage:displayPrg()
    WZLog("WndMarriage:displayPrg one", self.m_nTempExp, self.m_nEachAddExpForPgr)
    local conSoulLeft = GetElement(self.m_root, "conLoveProgress_WndMarriage", WZUIContainer)
    self.m_nTempExp = self.m_nTempExp + self.m_nEachAddExpForPgr 
    if self.m_nTempExp >= self.m_nTotalExpForAni then
        self.m_nTempExp = self.m_nTempExp - self.m_nTotalExpForAni 
        self.m_nTempLevel = self.m_nTempLevel + 1
		local tempNextLevel = self.m_nTempLevel + 1
		local tUpgradeData = GDatatab_marry_level["id_"..tempNextLevel]
        if tUpgradeData then
            self.m_nEachAddExpForPgr = math.floor(tUpgradeData.blessing/50)
        end
    end
    if self.m_nTempLevel > self.m_nLvl or self.m_nTempLevel == self.m_nLvl and self.m_nTempExp >= self.m_nExp then
    	WZLog("WndMarriage:displayPrg two", self.m_nTempLevel , self.m_nLvl , self.m_nTempExp, self.m_nExp)
        conSoulLeft:disableSchedule()

        self.m_bIsTraining = false 
        self:updateMarriageInfo()
        return
	end

	self.m_nCurSoulExp, self.m_nSoulLevel = self.m_nTempExp, self.m_nTempLevel
    self:updateMarriageInfo()
end

--@brief    点击规则按钮
function WndMarriage:onClickRule(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.COUPLE_TEXT3)
end

--@brief    显示伴侣互动动画
function WndMarriage:showCoupleAnimation()
    local conWifeFigure = GetElement(self.m_root,"conWifeFigure_WndMarriage",WZUIContainer)
    ShowCoupleAni(conWifeFigure, true, GlobalMethod:ccp(0.5,0.74), 1)
    local conHusbandFigure = GetElement(self.m_root,"conHusbandFigure_WndMarriage",WZUIContainer)
    ShowCoupleAni(conHusbandFigure, true, GlobalMethod:ccp(0.5,0.74), 1)
end

--@brief 	设置待机特效
function WndMarriage:_setSpineAni()
	local spinePath = "ui/otherUI/ui_yy_jieyuan"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		local spineCrimp = GetElement(self.m_root, "spineCrimp_WndMarriage", WZUISpine)
		local spineBubble = GetElement(self.m_root, "spineBubble_WndMarriage", WZUISpine)
		local spineFlower = GetElement(self.m_root, "spineFlower_WndMarriage", WZUISpine)
		if spineCrimp then 
			spineCrimp:setFileJson(spinePath .. ".json")
			spineCrimp:setFileAtlas(spinePath .. ".atlas")
			spineCrimp:play("wait_1", true)
		end
		if spineBubble then 
			spineBubble:setFileJson(spinePath .. ".json")
			spineBubble:setFileAtlas(spinePath .. ".atlas")
			spineBubble:play("wait_2", true)
		end
		if spineFlower then 
			spineFlower:setFileJson(spinePath .. ".json")
			spineFlower:setFileAtlas(spinePath .. ".atlas")
			spineFlower:play("wait_3", true)
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------



--------------------------------语言适配Begin------------------------------------

function WndMarriage:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtNoSkill_WndMarriage",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(340,0))
	GetElement(self.m_root,"txtSkill2_WndMarriage",WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root,"txtItemAddValue_WndMarriage",WZUILabelTTF):setScale(0.8)
end

----------------------------------语言适配End-------------------------------------