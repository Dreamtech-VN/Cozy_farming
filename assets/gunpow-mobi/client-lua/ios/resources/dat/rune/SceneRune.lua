--SceneRune.lua
--@brief	SceneRune的UI模块
--@date		2017/03/14
--@author	qixiang_xie
--@note		符文系统


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneRune:onEnter(element)
	self.m_root = element
	ProtocolProcessorSceneRune:regAll()
	ChangeChatChannel(Chat_Channel_MainBagRune)
	self:initRuneSlotInfo()
	--self:initUI()
	ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneRune:onExit(element)
	ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
	ProtocolProcessorSceneRune:unregAll()
	self:_unInit()
end

--查看符文槽信息
function SceneRune:onClickRuneSlot(element)
	WZLog("SceneRune:onClickRuneSlot")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local getElement = GetElement
	local parent = element:getParent()
	parent = WZUIContainer:luaTo(parent)
	local tag = parent:getTag()
	if self.m_nCurSelSlotIndex == tag then
		return
	end
	local slotInfo = GDatatab_rune_grid["id_"..tag]
	local imageLock = getElement(parent,"imgLock_SceneRune",WZUIImage)
	local file = imageLock:getFile()
	local txtOpenLevel = getElement(parent,"txtOpenLevel_SceneRune",WZUILabelTTF)
	
	if imageLock and tag < 41 and imageLock:isVisible() and (file == "ui/rune/common_icon_suo6.png" or file == "ui/rune/common_icon_suo5.png" or file == "ui/rune/common_icon_suo4.png") then--槽位是否已锁
		MsgBoxManager:showTipBox(LocalStrings.RUNE_LOCK_TIP)
		return
	end

	if txtOpenLevel:getText() ~= "" and txtOpenLevel:getText() ~= LocalStrings.STAR_SOUL_NOT_ACTIVE then 
		local temp = LocalStrings.RUNE_OPEN_BY_DIAMONDS
		temp = string.format(temp,slotInfo.cost[1][2])
		self.m_nOpenSlotIndex = tag
		MsgBoxManager:showConfirmBox(temp,self,self.clickOpenSlotByDiamonds,nil,nil)
		return
	end

	if imageLock and (file == "ui/rune/common_icon_hongzuan.png" or file == "ui/rune/common_icon_huangzuan.png" or file == "ui/rune/common_icon_lvzuan.png") then --钻石开启
		local temp = LocalStrings.RUNE_OPEN_BY_DIAMONDS
		temp = string.format(temp,slotInfo.cost[1][2])
		self.m_nOpenSlotIndex = tag
		MsgBoxManager:showConfirmBox(temp,self,self.clickOpenSlotByDiamonds,nil,nil)
		return
	end

	if tag == 41 or tag == 42  or tag == 43 or tag == 44 then--点击了圣痕的槽位
		local imgBg = getElement(parent,"imgBg_SceneRune",WZUIImage)
		local txtOpenLevel = getElement(parent,"txtOpenLevel_SceneRune",WZUILabelTTF)
		local bigRuneId = nil
		if txtOpenLevel:getText() ~= "" then
			bigRuneId = 0
		else
			bigRuneId = imgBg:getTag()
		end
		self:showBigRune(tag,bigRuneId,element)
	else
		if self.m_rootPreviousSel then
			self.m_rootPreviousSel:setVisible(false)
			self.m_rootPreviousSel = nil
	    end
		self.m_nCurSelSlotIndex = tag
		local imgLight = getElement(parent,"imgLight_SceneRune",WZUIImage)
		imgLight:setVisible(true)
		self.m_rootPreviousSel = imgLight

		local imgBg = getElement(parent,"imgBg_SceneRune",WZUIImage)
		local bLoadRune = false
		local runeId = nil
		for i,v in ipairs(self.m_tRuneSlotInfo) do
			if v[1] == tag then
				if v[2] > 0 then
					runeId = v[2]
					bLoadRune = true
					break
				end
			end
		end
		local conRight = getElement(self.m_root,"conRight_SceneRune",WZUIContainer)
		local child1 = conRight:getChildByTag(220)
		local child2 = conRight:getChildByTag(119)
		if child1 then
			child1 = WZUIWindow:luaTo(child1)
			child1:removeFromParentAndCleanup(true)
		end
		if child2 then
			child2 = WZUIWindow:luaTo(child2)
			child2:removeFromParentAndCleanup(true)
		end
		if not bLoadRune then --槽位已打开但没有装备符文
			local runeType = slotInfo.type ---可以装载的符文类型
			local conRuneTotalInfo = getElement(self.m_root,"conRuneTotalInfo_SceneRune",WZUIContainer)
			conRuneTotalInfo:setVisible(false)
			WndRuneBag:show(runeType,self.m_nCurSelSlotIndex,conRight,self.m_tRuneList)
			WndRuneBag:setCloseCallback(self,self.closeRuneBag)
		else
			self:showRuneInfoByRuneId(self.m_nCurSelSlotIndex,runeId)
		end
	end
end

--@brief 钻石开启槽位
function SceneRune:clickOpenSlotByDiamonds(element,btnTag)
    WZLog("SceneRune:clickOpenSlotByDiamonds", btnTag, MSGBOXTYPE_CONFIRM)
    if btnTag == MSGBOXTYPE_CONFIRM then
    	local slotInfo = GDatatab_rune_grid["id_"..self.m_nOpenSlotIndex ]
    	local costCount = slotInfo.cost[1][2]
    	
    	WZLog("SceneRune:clickOpenSlotByDiamonds", slotInfo.cost[1][1])
    	if not JudgeMoneyIsEnough(slotInfo.cost[1][1], costCount,nil, nil, 198, nil, nil, nil, nil, self, self.clickSureMoney) then
            return
        end
        self:clickSureMoney()
    end
end

--@brief	点击确认使用宣誓代替礼券开启格子回调
function SceneRune:clickSureMoney()
	WZLog("SceneRune:clickSureMoney")
	ProtocolProcessorSceneRune:send_RUNE_OpenPlace(self.m_nOpenSlotIndex)
end

--符文商店
function SceneRune:toRuneStore(element)
	WZLog("SceneRune:toRuneStore")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndStore:showStoreByType(7,self,self.closeStoreCallback)
end

--从符文商店返回
function SceneRune:closeStoreCallback(bChange)
	WZLog("SceneRune:closeStoreCallback")
	if bChange then
		ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
	end
end

function SceneRune:onExplain(element)
	WZLog("SceneRune:onExplain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface(LocalStrings.RUNE_EXPLAIN)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- function SceneRune:initUI()
-- 	WZLog("SceneRune:initUI")
-- 	self:addTop()
-- end

--显示符文槽位信息
function SceneRune:showRuneSlot()
	WZLog("SceneRune:showRuneSlot",Serialize(self.m_tLocalSlotInfo))
	local playerInfo = CacheCenter:getPlayerInfo()
	local playerLevel = playerInfo.level
	local getElement = GetElement
	local conLeft = getElement(self.m_root,"conLeft_SceneRune",WZUIContainer)
	local slotIndex = nil
	local bShowLevelOpen = false
	for i,v in ipairs(self.m_tLocalSlotInfo) do
		local parent = nil
		slotIndex = v.sequence
		if v.type == 1 then
			parent = getElement(conLeft,"conRuneType1_SceneRune",WZUIContainer)
		elseif v.type == 2 then
			parent = getElement(conLeft,"conRuneType2_SceneRune",WZUIContainer)
		elseif v.type == 3 then
			parent = getElement(conLeft,"conRuneType3_SceneRune",WZUIContainer)
		end
		local conRun = getElement(parent,"conRun" .. slotIndex .. "_SceneRune",WZUIContainer)
		conRun:setTag(v.id)
		local imgBg = getElement(conRun,"imgBg_SceneRune",WZUIImage)
		imgBg:setFile("")
		local txtOpenLevel = getElement(conRun,"txtOpenLevel_SceneRune",WZUILabelTTF)
		txtOpenLevel:setText("")
		local imgLock = getElement(conRun,"imgLock_SceneRune",WZUIImage)
		imgLock:setFile("")
		imgLock:setVisible(true)

		local imgRed = getElement(conRun,"imgRed_SceneRune",WZUIImage)
		imgRed:setVisible(false)
		local openLevel = v.open_level
		if playerLevel >= openLevel then
			self:setSlotBg(1,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
			imgRed:setVisible(self:bShowRed(v.id))
		else
			local slotState = self:findSlotState(v.id)
			if slotState then
				self:setSlotBg(1,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
				imgRed:setVisible(self:bShowRed(v.id))
			else
				if i > 3 then
					if bShowLevelOpen == false then
						bShowLevelOpen = true
						self:setSlotBg(2,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
					else
						local previousSlotIndex = v.parent
			    		local state = self:findSlotState(previousSlotIndex)
			    		
			    		if state then
			    			self:setSlotBg(3,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
			    		else
			    			self:setSlotBg(4,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
			    		end
					end
		    	else
		    		if i == 1 then
		    			self:setSlotBg(2,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
		    		elseif i == 2 then
		    			self:setSlotBg(3,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
		    		elseif i == 3 then
		    			self:setSlotBg(3,v.type,txtOpenLevel,imgBg,imgLock,openLevel)
		    		end
			    end
			end
		end
	end
	self:showRuneAttributeInfo()
end


--显示符文的总属性信息
function SceneRune:showRuneAttributeInfo()
	WZLog("SceneRune:showRuneAttributeInfo")
	local getElement = GetElement
	local conRuneTotalInfo = getElement(self.m_root,"conRuneTotalInfo_SceneRune",WZUIContainer)
	local afLevel = getElement(conRuneTotalInfo,"afLevel_SceneRune",WZUILabelAtlasFont)
	afLevel:setText(self.m_nRuneTotalLevel)

	-- local lafight = getElement(conRuneTotalInfo,"lafight_SceneRune",WZUILabelAtlasFont)
	-- lafight:setText("0")
	local txtFight = getElement(conRuneTotalInfo,"txtFight_SceneRune",WZUILabelTTF)
	txtFight:setText("0")

	local tabRuneAttr = getElement(conRuneTotalInfo,"tabRuneAttr_SceneRune",WZUITableContainer)
	tabRuneAttr:cleanTable()

	local tempT = {LocalStrings.HEALTH,LocalStrings.ATTACK,LocalStrings.DEFENSE,LocalStrings.CRIT,LocalStrings.FREESTORM,LocalStrings.TIZHI,LocalStrings.POWER,LocalStrings.PRACTICE_ARMOR,LocalStrings.AGILITY,LocalStrings.LUCKY,LocalStrings.ANTIBREAKING,LocalStrings.AVOIDINJURY}
	local tempV = {}
	local runeId = nil
	local runeInfo = nil
	local runeProperty = nil
	local runeProId = nil
	local tempP = 0
	for i,v in ipairs(self.m_tRuneSlotInfo) do
		runeId = v[2]
		if runeId > 0 then
			runeInfo = GDatatab_item["id_" .. runeId]
			runeProperty = runeInfo.property
			for j,k in ipairs(runeProperty) do
				runeProId = k[1]
				runeProId = tostring(runeProId)
				tempP = tempV[runeProId]
				if tempP == nil then
					tempP = 0
				end
				tempV[runeProId] = tempP + k[2]
			end
		end
	end
	local tempPP = nil
	for i,v in ipairs(self.m_tStigmataInfo) do
		tempPP = GDatatab_rune_level["id_" .. v]
		for j,k in ipairs(tempPP.property) do
			runeProId = k[1]
			runeProId = tostring(runeProId)
			tempPP = tempV[runeProId]
			if tempPP == nil then
				tempPP = 0
			end
			tempV[runeProId] = tempPP + k[2]
		end
	end

	local tempVV = {"1","3","4","5","7","9","10","11","12","13","19","20"}
	local index = 0
	for i,v in ipairs(tempVV) do
		if tempV[v] then
			local cellAttribute = CreateElement("CellAttribute_SceneRune")
			cellAttribute = WZUIContainer:luaTo(cellAttribute)
			cellAttribute:setVisible(true)
			local txtName = getElement(cellAttribute,"txtName_CellRuneInfo",WZUILabelTTF)
			local txtV = getElement(cellAttribute,"txtV_CellRuneInfo",WZUILabelTTF)
			txtName:setText(tempT[i])
			txtV:setText("+" .. tempV[v])
			cellAttribute:setTag(index)
			tabRuneAttr:setCellElement(cellAttribute)
			index = index + 1
		end
	end

	--总的战力
	local totalFight = GlobalMethod:getCombatEffect(tempV)
	local txtNotMsgTip = getElement(conRuneTotalInfo,"txtNotMsgTip_SceneRune",WZUILabelTTF)
	if totalFight <= 0 then
		txtNotMsgTip:setVisible(true)
	else
		txtNotMsgTip:setVisible(false)
	end
	txtFight:setText(totalFight)
end

--显示符文槽上的符文信息
function SceneRune:showSlotRuneInfoById(slotIndex)
	WZLog("SceneRune:showSlotRuneInfoById =",slotIndex)
	local getElement = GetElement
	local runeInfo = GDatatab_rune_grid["id_"..slotIndex]
	local temp = nil
	local parent = nil
	local conLeft = getElement(self.m_root,"conLeft_SceneRune",WZUIContainer)
	if runeInfo.type == 1 then
		temp = runeInfo.sequence
		parent = getElement(conLeft,"conRuneType1_SceneRune",WZUIContainer)
	elseif runeInfo.type == 2 then
		temp = runeInfo.sequence
		parent = getElement(conLeft,"conRuneType2_SceneRune",WZUIContainer)
	elseif runeInfo.type == 3 then
		temp = runeInfo.sequence
		parent = getElement(conLeft,"conRuneType3_SceneRune",WZUIContainer)
	end
	local conRun = getElement(parent,"conRun" .. temp .. "_SceneRune",WZUIContainer)
	local imgBg = getElement(conRun,"imgBg_SceneRune",WZUIImage)
	imgBg:setFile("")
	local txtOpenLevel = getElement(conRun,"txtOpenLevel_SceneRune",WZUILabelTTF)
	txtOpenLevel:setText("")
	local imgLock = getElement(conRun,"imgLock_SceneRune",WZUIImage)
	imgLock:setFile("")
	imgLock:setVisible(true)
	local slotRuneId = nil
	local imgRed = getElement(conRun,"imgRed_SceneRune",WZUIImage)
	imgRed:setVisible(false)
	for i,v in ipairs(self.m_tRuneSlotInfo) do
		if v[1] == slotIndex then
			slotRuneId = v[2]
			break
		end
	end
	
	if slotRuneId ~= nil and slotRuneId > 0 then
		local itemInfo = GDatatab_item["id_" .. slotRuneId]
		if itemInfo then
			imgBg:setFile(itemInfo.icon)
		end
	else
		local bRed = self:bShowRed(slotIndex)
		imgRed:setVisible(bRed)
		self:setSlotBg(1,runeInfo.type,nil,imgBg)
	end
end

--@brief    关闭按钮点击回调
--@param 	element:button的引用
function SceneRune:onCloseClick(element)
	WZLog("SceneRune:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
    --replaceScene(SceneCity:createElement())
end

--卸载所有的符文回符文背包
function SceneRune:onUnloadAllRune(element)
	WZLog("SceneRune:onUnloadAllRune")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local bShow = false
	for i,v in ipairs(self.m_tRuneSlotInfo) do
		if v[2] > 0 then
			bShow = true
			break
		end
	end
	if not bShow then
		MsgBoxManager:showTipBox(LocalStrings.NOT_RUNE_TO_UNLOAD)
	else
		MsgBoxManager:showConfirmCancelBox(LocalStrings.UNLOAD_ALL_RUNE,self,self.clickSureBack, nil, nil)
	end
end

--@brief 卸载所有符文
function SceneRune:clickSureBack(element, btnTag)
    -- body
    WZLog("SceneRune:clickSureBack")
    if btnTag == MSGBOXTYPE_CONFIRM then
        ProtocolProcessorSceneRune:send_RUNE_UpdateRune(-1,0)
    end
end

--符文背包
function SceneRune:toRuneBag(element)
	WZLog("SceneRune:toRuneBag")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local getElement = GetElement
	local conRight = getElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	local conRuneTotalInfo = getElement(conRight,"conRuneTotalInfo_SceneRune",WZUIContainer)
	conRuneTotalInfo:setVisible(false)
	WndRuneBag:show(nil,nil,conRight,self.m_tRuneList)
	WndRuneBag:setCloseCallback(self,self.closeRuneBag)
end

--关闭符文背包
function SceneRune:closeRuneBag()
	WZLog("SceneRune:closeRuneBag")
	self:removeRuneBagNode()
	if self.m_rootPreviousSel then
		self.m_rootPreviousSel:setVisible(false)
		self.m_rootPreviousSel = nil
	end
	self.m_nCurSelSlotIndex = nil
	self:showRuneTotalInfo()
end

function SceneRune:removeRuneBagNode()
	WZLog("SceneRune:removeRuneBagNode")
	local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	local childNode = conRight:getChildByTag(119)
	if childNode then
		childNode:removeFromParentAndCleanup(true)
	end
end

function SceneRune:showRuneTotalInfo()
	WZLog("SceneRune:showRuneTotalInfo")
	local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	local conRuneTotalInfo = GetElement(conRight,"conRuneTotalInfo_SceneRune",WZUIContainer)
	conRuneTotalInfo:setVisible(true)
end

function SceneRune:removeRuneInfoNode()
	WZLog("SceneRune:removeRuneInfoNode")
	local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	local childNode = conRight:getChildByTag(220)
	if childNode then
		childNode:removeFromParentAndCleanup(true)
	end
end

--关闭符文信息
function SceneRune:closeRuneInfo()
	WZLog("SceneRune:closeRuneInfo")
	self:removeRuneInfoNode()
	if self.m_rootPreviousSel then
		self.m_rootPreviousSel:setVisible(false)
		self.m_rootPreviousSel = nil
	end
	self.m_nCurSelSlotIndex = nil
	self:showRuneTotalInfo()
end

--打开符文图鉴
function SceneRune:onClickRunePokedex(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local wndElement = WndRuneBook:createElement()
	WindowManager:addWindow(wndElement,WndRuneBook)
	if self.m_rootPreviousSel then
		self.m_rootPreviousSel:setVisible(false)
		self.m_rootPreviousSel = nil
	end
	self.m_tSelSlotIndex = nil
	self.m_nCurSelSlotIndex = nil
    local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	local childNode = conRight:getChildByTag(220)
	if childNode then
		childNode:removeFromParentAndCleanup(true)
	end

	local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	local childNode = conRight:getChildByTag(119)
	if childNode then
		childNode:removeFromParentAndCleanup(true)
	end
	self:showRuneTotalInfo()
end

--显示当前点击的符文槽信息
--slotIndex : 符文槽位置
--suneID : 符文ID
function SceneRune:showRuneInfoByRuneId(slotIndex,suneID)
	WZLog("SceneRune:showRuneInfoByRuneId ",slotIndex,suneID)
	local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	local conRuneTotalInfo = GetElement(conRight,"conRuneTotalInfo_SceneRune",WZUIContainer)
	conRuneTotalInfo:setVisible(false)
	WndRuneInfo:show(suneID,slotIndex,conRight)
	WndRuneInfo:setChangeRune(self,self.changeRuneCallback)
	WndRuneInfo:setCloseRuneInfoCallbcak(self,self.closeRuneInfo)
end

--更换符文回调
function SceneRune:changeRuneCallback(runeId,slotIndex)
	local runeType = GDatatab_item["id_"..runeId].sub_type
	local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	WndRuneBag:show(runeType,slotIndex,conRight,self.m_tRuneList,runeId)
	WndRuneBag:setCloseCallback(self,self.closeRuneBagAndOpenRuneInfo)
end

--关闭符文背包打开符文信息
function SceneRune:closeRuneBagAndOpenRuneInfo(slotIndex,suneID)
	WZLog("SceneRune:closeRuneBagAndOpenRuneInfo ",slotIndex,suneID)
	local conRight = GetElement(self.m_root,"conRight_SceneRune",WZUIContainer)
	local conRuneTotalInfo = GetElement(conRight,"conRuneTotalInfo_SceneRune",WZUIContainer)
	conRuneTotalInfo:setVisible(false)
	local childNode = conRight:getChildByTag(119)
	if childNode then
		childNode:removeFromParentAndCleanup(true)
	end

	WndRuneInfo:show(suneID,slotIndex,conRight)
	WndRuneInfo:setChangeRune(self,self.changeRuneCallback)
	WndRuneInfo:setCloseRuneInfoCallbcak(self,self.closeRuneInfo)
end

--显示圣痕tip
function SceneRune:showBigRune(tag,bigRuneId,element)
	WZLog("SceneRune:showBigRune")
	local bigRuneIcon = nil
	if tag == 44 then
		if bigRuneId <= 0 then
			bigRuneIcon = "ui/rune/common_scale9_fuwendashenghendi03.png"
		else
			bigRuneIcon = GDatatab_rune_level["id_" .. bigRuneId].img
		end
	else
		if bigRuneId <= 0 then
			bigRuneIcon = "ui/rune/common_scale9_fuwenzidi03.png"
		else
			bigRuneIcon = GDatatab_rune_level["id_" .. bigRuneId].img
		end
	end
	
	local bigRuneLevel = nil
	if bigRuneId <= 0 then
		bigRuneLevel = string.format(LocalStrings.BIG_RUNE_LEVEL,0)
	else
		local bigRuneInfo = GDatatab_rune_level["id_" .. bigRuneId]
		bigRuneLevel = string.format(LocalStrings.BIG_RUNE_LEVEL,bigRuneInfo.level)
	end

	local describe = nil
	local tipType = 33
	local attrList = nil
	local bMaxLevel = false

	local nextAttri1 = ""
	local nextAttri2 = ""
	local nextAttri3 = ""

	local nextAttriV1 = ""
	local nextAttriV2 = ""
	local nextAttriV3 = ""
	if tag == 41 then
		for k,v in pairs(GDatatab_rune_level) do
			if v.type == 1 and v.level == 1 then
				local actLevel = v.activation_level
				describe = string.format(LocalStrings.RED_RUNE_LEVEL,actLevel)
				attrList = v.property
				break
			end
		end
	elseif tag == 42 then
		for k,v in pairs(GDatatab_rune_level) do
			if v.type == 2 and v.level == 1 then
				local actLevel = v.activation_level
				describe = string.format(LocalStrings.GREEN_RUNE_LEVEL,actLevel)
				attrList = v.property
				break
			end
		end
	elseif tag == 43 then
		for k,v in pairs(GDatatab_rune_level) do
			if v.type == 3 and v.level == 1 then
				local actLevel = v.activation_level
				describe = string.format(LocalStrings.YELLOW_RUNE_LEVEL,actLevel)
				attrList = v.property
				break
			end
		end
	else
		for k,v in pairs(GDatatab_rune_level) do
			if v.type == -1 and v.level == 1 then
				local actLevel = v.activation_level
				describe = string.format(LocalStrings.BIG_RUNE_LEVEL_ACT,actLevel)
				attrList = v.property
				break
			end
		end
	end
	if bigRuneId > 0 then
		local bigRuneInfo = GDatatab_rune_level["id_" .. bigRuneId]
		attrList = bigRuneInfo.property
		local tempPP = {}
		for k,v in pairs(GDatatab_rune_level) do
			if bigRuneInfo.type == bigRuneInfo.type then
				table.insert(tempPP,v)
			end
		end
		local maxIndex = #tempPP
		table.sort(tempPP,function (a,b)
			if a.level < b.level then
				return true
			end
		end)
		local maxLevel = tempPP[maxIndex].level
		if bigRuneInfo.level >= maxLevel then
			bMaxLevel = true
		else
			local nextRuneId = bigRuneId + 1
			local nextBigRuneInfo = GDatatab_rune_level["id_" .. nextRuneId]
			if nextBigRuneInfo.type == 1 then
				local actLevel = nextBigRuneInfo.activation_level
				describe = string.format(LocalStrings.RED_RUNE_LEVEL,actLevel)
			elseif nextBigRuneInfo.type == 2 then
				local actLevel = nextBigRuneInfo.activation_level
				describe = string.format(LocalStrings.GREEN_RUNE_LEVEL,actLevel)
			elseif nextBigRuneInfo.type == 3 then
				local actLevel = nextBigRuneInfo.activation_level
				describe = string.format(LocalStrings.YELLOW_RUNE_LEVEL,actLevel)
			elseif nextBigRuneInfo.type == -1 then
				local actLevel = nextBigRuneInfo.activation_level
				describe = string.format(LocalStrings.BIG_UPDATE_LEVEL,actLevel)
			end
			for i,v in ipairs(nextBigRuneInfo.property) do
				if i == 1 then
				    nextAttri1 = ATTR_TITLE[v[1]]
				    nextAttriV1 = tostring(v[2])
				elseif i == 2 then
					nextAttri2 = ATTR_TITLE[v[1]]
					nextAttriV2 = tostring(v[2])
				elseif i == 3 then
					nextAttri3 = ATTR_TITLE[v[1]]
					nextAttriV3 = tostring(v[2])
				end
			end
		end
	end

	local attri1 = ""
	local attri2 = ""
	local attri3 = ""
	local attriV1 = ""
	local attriV2 = ""
	local attriV3 = ""

	for i,v in ipairs(attrList) do
		if i == 1 then
			attri1 = ATTR_TITLE[v[1]]
			attriV1 = tostring(v[2])
		elseif i == 2 then
			attri2 = ATTR_TITLE[v[1]]
			attriV2 = tostring(v[2])
		elseif i == 3 then
			attri3 = ATTR_TITLE[v[1]]
			attriV3 = tostring(v[2])
		end
	end

	local tipsType = 33
	local txtColor = ccc3(138,122,106)
	local tData = nil
	if bigRuneId <= 0 or bMaxLevel then
		tipsType = 34
		if bMaxLevel then
			describe = LocalStrings.RUNE_LEVEL_MAX
			txtColor = ccc3(255,89,74)
		end
		tData = {["status"]=bigRuneId,["img"]=bigRuneIcon,["title"]=bigRuneLevel,["text"]=describe,["txtColor"]=txtColor,
		["attrTitle1"]=attri1,["attrTitle2"]=attri2,["attrTitle3"]=attri3,["attrVal1"]=attriV1,["attrVal2"]=attriV2,["attrVal3"]=attriV3}
	else
		tData = {["status"]=bigRuneId,["img"]=bigRuneIcon,["title"]=bigRuneLevel,["text"]=describe,
		["attrTitle1"]=attri1,["attrTitle2"]=attri2,["attrTitle3"]=attri3,["attrTitle4"]=nextAttri1,["attrTitle5"]=nextAttri2,["attrTitle6"]=nextAttri3,
		["attrVal1"]=attriV1,["attrVal2"]=attriV2,["attrVal3"]=attriV3,["attrVal4"]=nextAttriV1,["attrVal5"]=nextAttriV2,["attrVal6"]=nextAttriV3}
	end
	
	WndTips:show(element,self.m_root,tipsType,tData,GlobalMethod:ccp(250,0))
end


-------------------------------------私有方法模块End----------------------------------------

------------------------------------语言适配Begin-----------------------------------
function SceneRune:_adaptLanguage_en(  )
	local txtBackpack = GetElement(self.m_root,"txtBackpack_SceneRune",WZUILabelTTF)
	txtBackpack:setDimensions(GlobalMethod:CCSize(120,0))
	txtBackpack:setScale(0.7)

	GetElement(self.m_root,"txtRemove_SceneRune",WZUILabelTTF):setScale(0.7)
end

function SceneRune:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtRemove_SceneRune",WZUILabelTTF):setScale(0.7)
end

function SceneRune:_adaptLanguage_pt(  )
	local txtBackpack = GetElement(self.m_root,"txtBackpack_SceneRune",WZUILabelTTF)
	txtBackpack:setDimensions(GlobalMethod:CCSize(100,0))
	txtBackpack:setScale(0.7)
	local txtRemove = GetElement(self.m_root,"txtRemove_SceneRune",WZUILabelTTF)
	txtRemove:setScale(0.7)
	txtRemove:setDimensions(GlobalMethod:CCSize(100,0))
end

function SceneRune:_adaptLanguage_vn(  )
	local txtBackpack = GetElement(self.m_root,"txtBackpack_SceneRune",WZUILabelTTF)
	-- txtBackpack:setDimensions(GlobalMethod:CCSize(100,0))
	txtBackpack:setScale(0.75)
	local txtRemove = GetElement(self.m_root,"txtRemove_SceneRune",WZUILabelTTF)
	txtRemove:setScale(0.75)
	-- txtRemove:setDimensions(GlobalMethod:CCSize(100,0))
end

function SceneRune:_adaptLanguage_es(  )
	local txtBackpack = GetElement(self.m_root,"txtBackpack_SceneRune",WZUILabelTTF)
	txtBackpack:setDimensions(GlobalMethod:CCSize(110,0))
	txtBackpack:setScale(0.7)
	local txtRemove = GetElement(self.m_root,"txtRemove_SceneRune",WZUILabelTTF)
	txtRemove:setScale(0.7)
	txtRemove:setDimensions(GlobalMethod:CCSize(100,0))

	GetElement(self.m_root,"txtRuneFight_SceneRune",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.4,0.907878))
end

function SceneRune:_adaptLanguage_tr(  )
	local txtBackpack = GetElement(self.m_root,"txtBackpack_SceneRune",WZUILabelTTF)
	txtBackpack:setDimensions(GlobalMethod:CCSize(140,0))
	txtBackpack:setScale(0.7)
	
	local txtRemove = GetElement(self.m_root,"txtRemove_SceneRune",WZUILabelTTF)
	txtRemove:setScale(0.7)
	txtRemove:setDimensions(GlobalMethod:CCSize(140,0))

	GetElement(self.m_root,"imgTJ_SceneRune",WZUIImage):setScale(0.8)
	local imgSD = GetElement(self.m_root,"imgSD_SceneRune",WZUIImage)
	imgSD:setScale(0.8)
	-- imgSD:setRelativePosition(GlobalMethod:ccp(0.65,0.216312))
	
end
------------------------------------语言适配End--------------------------------------