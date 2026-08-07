--WndGemMountingStrengthen.lua
--@brief	WndGemMountingStrengthen的UI模块
--@date		2014/8/16
--@author	zsq
--@note		镶嵌窗口

local GemName = {"hpStone","attackStone","defendStone","","","gongmingStone"}
local LuaObj = {"m_specialStoneLuaObj","m_attackStoneLuaObj","m_defenseStoneLuaObj","","","m_extremeStoneLuaObj"}
local Element = {"m_specialStoneElement","m_attackStoneElement","m_defenseStoneElement","","","m_extremeStoneElement"}
local ProtocolType = {3,1,2,0,0,4}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGemMountingStrengthen:onEnter(element)
	self.m_root = element

	--初始化镶嵌窗口UI
	self:_initGemMountingUI()
	
	--更新镶嵌属性信息
	self:_updateGemMountingAttributeInfo()
	
	--新手定推礼包入口
    CreateLimitPackage(43, self.m_root, GlobalMethod:ccp(0.1, 0.95))
	--切换聊天频道
	ChangeChatChannel(Chat_Channel_Forged_Inlay)

	--多语言版本界面适配
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGemMountingStrengthen:onExit(element)
	self:_unInit()
    Teach:isStartTeach("WndGemMountingStrengthen:onExit")
end

--@brief	快速购买金币框
--@param	nResType:响应类型(超时，确定，取消)
function WndGemMountingStrengthen:buyGold(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndBuyActivity:showBuyInterface(26)
	end
end

--@brief	镶嵌成功后的回调函数
--@note		在这里做镶嵌成功后需要做的操作
function WndGemMountingStrengthen:onGemMountingSuccess()
	SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
	if self.m_tCurSelectedStone == nil then return end
    --更新信息
    local subtype = self.m_tCurSelectedStone.subtype
    local stoneid = self.m_tCurSelectedStone.basicInfo.id
    --更新装备镶嵌信息
    self.m_tCurSelectedEquip.extraInfo[GemName[subtype+1]] = stoneid

	self:_closeLoading()
    WndStrengthen:updateCellEquip(self.m_tCurSelectedEquip)
	--显示镶嵌成功
	self:_showGemMountingResult(1)
	
	self.m_bIsGemMounting = false
end

--@brief	拆卸成功后的回调函数
--@note		在这里做拆卸成功后需要做的操作
function WndGemMountingStrengthen:onRemoveSuccess()
	SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
	local subtype = self.punchType
    --更新装备镶嵌信息
    self.m_tCurSelectedEquip.extraInfo[GemName[subtype+1]] = 0
	
    WndStrengthen:updateCellEquip(self.m_tCurSelectedEquip)
	self:_closeLoading()
	--显示拆卸成功
	self:_showGemMountingResult(2)
end

--@param	sub_type:宝石子类型
function WndGemMountingStrengthen:onCellClick(sub_type)
	self.m_tSelStoneCell = nil 
	self:setStoneSeatState(sub_type)
    if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end
    WZLog("WndGemMountingStrengthen:onCellClick", sub_type)
	local hasStone = false
	local tMaterialItems = {}
	if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
		tMaterialItems = CopyTable(CacheCenter:getPetEquipGemsList())
		for i,v in pairs(tMaterialItems) do
		    if v.subtype == sub_type then
		        hasStone = true
		        break 
		    end
		end
	else
		tMaterialItems = CopyTable(CacheCenter:getMaterialList())
		for i,v in pairs(tMaterialItems) do
		    if v.maintype == 6 and v.subtype == sub_type then
		        hasStone = true
		        break 
		    end
		end
	end
	local conUpgrade = GetElement(self.m_root, "conUpgrade_WndGemMountingStrengthen", WZUIContainer)
	conUpgrade:removeAllChildrenWithCleanup(true)
	local tbGemList = GetElement(self.m_root, "tbGemList_WndGemMountingStrengthen", WZUITableContainer)
	tbGemList:setVisible(false)
	local btnRight = GetElement(self.m_root, "btnRight_WndGemMountingStrengthen", WZUIButton)
	btnRight:setRelativePosition(GlobalMethod:ccp(0.74, 0.5))
	local btnLeft = GetElement(self.m_root, "btnLeft_WndGemMountingStrengthen", WZUIButton)
	local btnGetStone = GetElement(self.m_root, "btnGetStone_WndGemMountingStrengthen", WZUIButton)
	btnGetStone:setVisible(false)
	GetElement(self.m_root, "txtMaxLevel_WndGemMountingStrengthen", WZUILabelTTF):setVisible(false)

	if self.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] == nil then self.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] = 0 end
    if self.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] <= 0 then
		if hasStone then
        	--打开宝石列表 maintype=6,subtype=1 ,value = 等级
        	self.m_nOperateType = 0
        	self:showStoneList(sub_type, 1)

			btnLeft:setVisible(false)
			btnRight:setVisible(true)
			btnRight:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))

			GetElement(self.m_root, "txtBtnRight_WndGemMountingStrengthen", WZUILabelTTF):setText(LocalStrings.GEMMOUNTING)

			self:setCost({{2, 0}})
		else 
			btnGetStone:setVisible(true)
			btnRight:setVisible(false)
			btnLeft:setVisible(false)
			GetElement(self.m_root, "ftxtCost_WndGemMountingStrengthen", WZUIFreeTextBox):setVisible(false)
		end
		self:showPropertyAtt(4)
    else
    	self.m_nSelStoneSubType = sub_type
		local tData = self[LuaObj[sub_type+1]].m_tItem
    	local subType = tData.basicInfo.sub_type

		local magicUpInfo = GDatatab_dig_up["id_"..tData.id]
		local magicChangeInfo = GDatatab_dig_change["id_"..tData.id]

		local tGemExp = {"hpGemExp","attackGemExp","defendGemExp","","","gongmingGemExp"}

		local curexp = self.m_tCurSelectedEquip.extraInfo[tGemExp[tData.basicInfo.sub_type+1]] or 0
		if tData.basicInfo.main_type == 44 then --宠物装备宝石
			if tData.basicInfo.value < 8 then --普通宝石升级
				self.m_nOperateType = 1
				WZLog("WndGemMountingStrengthen:onCellClick one", self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]])
				WndUpgradeGem:show(self.m_tCurSelectedEquip, self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]], conUpgrade)
				self:showPropertyAtt(1, self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]])
			else
				if not hasStone then 
					btnGetStone:setVisible(true)
				end
			end
		else --人物装备宝石
			if tData.id <= 41000 and tData.basicInfo.value < 7 or (sub_type == 5 and tData.basicInfo.value < GEMMAXLEVEL) then --普通宝石升级
				self.m_nOperateType = 1
				WZLog("WndGemMountingStrengthen:onCellClick one", self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]])
				WndUpgradeGem:show(self.m_tCurSelectedEquip, self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]], conUpgrade)
				self:showPropertyAtt(1, self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]])
			else
				if not hasStone then 
					btnGetStone:setVisible(true)
				end
			end
		end

		local strInlaid = ""
		local strProAttrOther = ""
		local rightText = ""
		btnRight:setVisible(false)
		btnLeft:setVisible(true)
		btnLeft:setRelativePosition(GlobalMethod:ccp(0.26, 0.5))
		if tData.basicInfo.main_type == 44 then --宠物装备宝石
			if tData.basicInfo.value < 8 then --普通宝石升级
				btnRight:setVisible(true)
				rightText = LocalStrings.STAR_SOUL_BUTTON_UPDATE
			else --普通宝石达到最大等级
				GetElement(self.m_root, "ftxtCost_WndGemMountingStrengthen", WZUIFreeTextBox):setVisible(false)
				GetElement(self.m_root, "txtMaxLevel_WndGemMountingStrengthen", WZUILabelTTF):setVisible(true)
				btnLeft:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
				self:showStoneList(nil, 1)
				self:showPropertyAtt(1, self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]], 0)

				strInlaid = LocalStrings.PET_EQUIPMENT_15

	    		GetElement(self.m_root, "conPro_WndGemMountingStrengthen", WZUIContainer):setVisible(false)
				local tItemInfo = GDatatab_item["id_"..tData.basicInfo.id]
				strProAttrOther = strProAttrOther .. ATTR_TITLE[tItemInfo.property[1][1]]
				if tItemInfo.sub_type == 5 then 
					strProAttrOther = strProAttrOther .. "+" ..tItemInfo.property[1][2] .. "%"
				else
					strProAttrOther = strProAttrOther .. "+" .. tItemInfo.property[1][2]
				end
			end
		else --人物装备宝石
			if tData.id <= 41000 and tData.basicInfo.value < 7 or (sub_type == 5 and tData.basicInfo.value < GEMMAXLEVEL) then --普通宝石升级
				btnRight:setVisible(true)
	    		rightText = LocalStrings.STAR_SOUL_BUTTON_UPDATE
			elseif magicChangeInfo and tData.id <= 41000 and tData.basicInfo.value >= 7 then --宝石融合成魔力宝石
				GetElement(self.m_root, "ftxtCost_WndGemMountingStrengthen", WZUIFreeTextBox):setVisible(false)
	    		GetElement(self.m_root, "conPro_WndGemMountingStrengthen", WZUIContainer):setVisible(false)
				tbGemList:setVisible(false)
	    		rightText = LocalStrings.ASCENDING_FUSE1
	    		WndGemHandle:showInterface(self.m_tCurSelectedEquip, tData, conUpgrade)
	    		btnGetStone:setVisible(false)
			elseif tData.id > 41000 and magicUpInfo and magicUpInfo.ad_up ~= -1 and curexp >= magicUpInfo.up_exp then --魔力宝石进阶
				GetElement(self.m_root, "ftxtCost_WndGemMountingStrengthen", WZUIFreeTextBox):setVisible(false)
	    		GetElement(self.m_root, "conPro_WndGemMountingStrengthen", WZUIContainer):setVisible(false)
				tbGemList:setVisible(false)
	    		rightText = LocalStrings.ASCENDING6
	    		WndGemHandle:showInterface(self.m_tCurSelectedEquip, tData, conUpgrade)
	    		btnGetStone:setVisible(false)
			elseif tData.id > 41000 and magicUpInfo and magicUpInfo.up_exp ~= -1 then --魔力宝石升级
				GetElement(self.m_root, "ftxtCost_WndGemMountingStrengthen", WZUIFreeTextBox):setVisible(false)
	    		rightText = LocalStrings.STAR_SOUL_BUTTON_UPDATE
	    		WndMagicGemUpgrade:showInterface(self.m_tCurSelectedEquip, tData, conUpgrade)
	    	elseif tData.id > 41000 and magicUpInfo and magicUpInfo.up_exp == -1 then 
				GetElement(self.m_root, "ftxtCost_WndGemMountingStrengthen", WZUIFreeTextBox):setVisible(false)
				GetElement(self.m_root, "txtMaxLevel_WndGemMountingStrengthen", WZUILabelTTF):setVisible(true)
				btnLeft:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
				self:showStoneList(nil, 2)
				self:showPropertyAtt(2, self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]], 0)
			elseif sub_type == 5 and tData.basicInfo.value >= GEMMAXLEVEL then --共鸣宝石达到最大等级
				GetElement(self.m_root, "ftxtCost_WndGemMountingStrengthen", WZUIFreeTextBox):setVisible(false)
				GetElement(self.m_root, "txtMaxLevel_WndGemMountingStrengthen", WZUILabelTTF):setVisible(true)
				btnLeft:setRelativePosition(GlobalMethod:ccp(0.5, 0.5))
				self:showStoneList(sub_type, 1)
				self:showPropertyAtt(1, self.m_tCurSelectedEquip.extraInfo[GemName[subType+1]], 0)
			end
		end

		GetElement(self.m_root, "txtBtnLeft_WndGemMountingStrengthen", WZUILabelTTF):setText(LocalStrings.REMOVE_STONE)
		GetElement(self.m_root, "txtBtnRight_WndGemMountingStrengthen", WZUILabelTTF):setText(rightText)

		--主要宠物装备用到
		GetElement(self.m_root, "txtNotInlaidGem_WndGemMountingStrengthen", WZUILabelTTF):setText(strInlaid)
		GetElement(self.m_root, "txtProAttrOther_WndGemMountingStrengthen", WZUILabelTTF):setText(strProAttrOther)
    end
end

function WndGemMountingStrengthen:dismantleCallback(tag, tData)
	WZLog("WndGemMountingStrengthen:dismantleCallback",tag)
	local sub_type = tData.basicInfo.sub_type
	if tonumber(tag) == 1 then
		self:_createLoading()
		--拆卸宝石
		if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
			self.punchType = sub_type
			WndGemMountingStrengthen.m_nUpgradeGemId = nil
	    	WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] = 0
			ProtocolProcessorScenePets:send_PET_PetEquipUnMosaic(self.m_tCurSelectedEquip.playerItemId, tData.id)
		else
			self.punchType = sub_type
			WndGemMountingStrengthen.m_nUpgradeGemId = nil
	    	WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] = 0
			ProtocolProcessorStrengthen:send_FORGING_Dismantle(self.m_tCurSelectedEquip.playerItemId, ProtocolType[sub_type+1])
		end
	else
		local magicUpInfo = GDatatab_dig_up["id_"..tData.id]

		if tData.tBtnList[tonumber(tag)] == LocalStrings.STAR_SOUL_BUTTON_UPDATE then --升级按钮
			if tData.id <= 41000 and tData.basicInfo.value < GEMMAXLEVEL then --普通宝石升级
	    		WndUpgradeGem:show(self.m_tCurSelectedEquip, self.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]])
			elseif tData.id > 41000 and magicUpInfo and magicUpInfo.up_exp ~= -1 then --魔力宝石升级
	    		WndMagicGemUpgrade:showInterface(self.m_tCurSelectedEquip, tData)
			end
		elseif tData.tBtnList[tonumber(tag)] == LocalStrings.ASCENDING_FUSE1 or tData.tBtnList[tonumber(tag)] == LocalStrings.ASCENDING6 then --魔力宝石融合和进阶按钮
			WndGemHandle:showInterface(self.m_tCurSelectedEquip, tData)
		end
	end

    WndItemInfo:onCloseClick()
end

--@brief    点击攻击宝石cell回调
function WndGemMountingStrengthen:onAttackStoneCellClick()
    WZLog("WndGemMountingStrengthen:onAttackStoneCellClick()")
    self.m_nSelStoneSeat = 1 
	self:onCellClick(1)
end

--@brief    点击防御宝石cell回调
--@author   zsq
function WndGemMountingStrengthen:onDefenseStoneCellClick()
    WZLog("WndGemMountingStrengthen:onDefenseStoneCellClick()")
    self.m_nSelStoneSeat = 2
	self:onCellClick(2)
end

--@brief    点击生命宝石cell回调
function WndGemMountingStrengthen:onLifeStoneCellClick()
    WZLog("WndGemMountingStrengthen:onLifeStoneCellClick()")
    self.m_nSelStoneSeat = 0
	self:onCellClick(0)
end

--@brief    点击共鸣宝石回调
function WndGemMountingStrengthen:onExtremeStoneCellClick()
    WZLog("WndGemMountingStrengthen:onExtremeStoneCellClick()")
	if CheckButtonOpen(195) ~= true then
		return
	end
	self.m_nSelStoneSeat = 5 
	self:onCellClick(5)
end

--@brief    添加装备时调用
--@author   zsq
function WndGemMountingStrengthen:addEquipToCell(tEquip)
    self.m_tCurSelectedEquip = tEquip  --当前选择的装备

    --移除攻击宝石、更新攻击宝石cell信息
    self:_clearAttackStone()
    --移除防御宝石、更新防御宝石cell信息
    self:_clearDefenseStone()
    --移除生命宝石、更新生命宝石cell信息
    self:_clearSpecialStone()
    --移除共鸣石、更新共鸣石cell信息
    self:_clearExtremeStone()

    if self.m_tCurSelectedEquip ~= nil then
        --添加已镶嵌攻击宝石、更新攻击宝石cell信息
        self:_addGemMountingAttackStone()
        --添加已镶嵌防御宝石、更新防御宝石cell信息
        self:_addGemMountingDefenseStone()
        --添加已镶嵌生命宝石、更新生命宝石cell信息
        self:_addGemMountingSpecialStone()
        --添加已镶嵌共鸣宝石、更新共鸣宝石cell信息
        self:_addGemMountingExtremeStone()
    end

    if self.m_nSelStoneSeat == nil then 
		self.m_nSelStoneSeat = 1
	end

	self:onCellClick(self.m_nSelStoneSeat)
end

--@brief    选择宝石添加到cell时调用
--@author   zsq
function WndGemMountingStrengthen:addStoneToCell(tData)
    --判断是否放入装备
    if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end
    if tData == nil then return end
    --更新当前选择的宝石
    self.m_tCurSelectedStone = tData

	self:_createLoading()
    --发送镶嵌协议
    if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
    	ProtocolProcessorScenePets:send_PET_PetEquipMosaic(self.m_tCurSelectedEquip.playerItemId, tData.playerItemId)
    else
	    local stonesId = WZLuaVector_int_:create()
	    stonesId:push(tData.playerItemId)
	    ProtocolProcessorStrengthen:send_FORGING_Mosaic(self.m_tCurSelectedEquip.playerItemId, stonesId)
	end
end

--@brief  点击限时特惠礼包按钮回调
function WndGemMountingStrengthen:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end

--@brief 	获取路径
function WndGemMountingStrengthen:onClickGetStone(element)

	if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
		if self.m_nSelStoneSeat == 0 then
			WndFastGetItems:show(74001)
		elseif self.m_nSelStoneSeat == 1 then
			WndFastGetItems:show(74101)
		elseif self.m_nSelStoneSeat == 2 then
			WndFastGetItems:show(74201)
		end
	else
		if self.m_nSelStoneSeat == 0 then
			WndFastGetItems:show(120)
		elseif self.m_nSelStoneSeat == 1 then
			WndFastGetItems:show(130)
		elseif self.m_nSelStoneSeat == 2 then
			WndFastGetItems:show(140)
		elseif self.m_nSelStoneSeat == 5 then
			WndFastGetItems:show(21140)
		end
	end
end

--@brief 	点击宝石镶嵌回调
function WndGemMountingStrengthen:onClickItem(tCell, tag, tData)
	WZLog("WndGemMountingStrengthen:onClickItem")
	if self.m_tSelStoneCell then
		self.m_tSelStoneCell:removeGouIcon()
	end

	self.m_tSelStoneCell = tCell 
	self.m_tSelStoneCell:showSelectedIcon(4)

	--更新消耗
	local level = GDatatab_item["id_" .. tData.basicInfo.id].value
	local tCostList = GDatatab_mosaic_config["id_"..level].cost

	if tData.basicInfo.main_type == 44 then
		self:setCost({{2, 0}})
	else
		self:setCost(tCostList)
	end
	self:showPropertyAtt(3, tData.basicInfo.id)
end

--@brief 	点击拆卸按钮回调
function WndGemMountingStrengthen:onClickLeft(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = self[LuaObj[self.m_nSelStoneSubType+1]].m_tItem
	local sub_type = tData.basicInfo.sub_type
	self:_createLoading()
	--拆卸宝石
	if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
		self.punchType = sub_type
		WndGemMountingStrengthen.m_nUpgradeGemId = nil
		WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] = 0
		ProtocolProcessorScenePets:send_PET_PetEquipUnMosaic(self.m_tCurSelectedEquip.playerItemId, tData.id)
	else
		if tData.basicInfo.value >= 13 then
			MsgBoxManager:showConfirmBox(LocalStrings.GEM_DISMANTLING, self, self.sureToUnload, nil, nil)
		else
			self:sureToUnload()
		end
	end
end

--@brief 	确认卸下
function WndGemMountingStrengthen:sureToUnload()
	local tData = self[LuaObj[self.m_nSelStoneSubType+1]].m_tItem
	local sub_type = tData.basicInfo.sub_type
	self.punchType = sub_type
	WndGemMountingStrengthen.m_nUpgradeGemId = nil
	WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] = 0
	ProtocolProcessorStrengthen:send_FORGING_Dismantle(self.m_tCurSelectedEquip.playerItemId, ProtocolType[sub_type+1])
end

--@brief 	点击升级/镶嵌按钮回调
function WndGemMountingStrengthen:onClickRight(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_nOperateType == 0 then 
		if self.m_tSelStoneCell then 
			local tData = self.m_tSelStoneCell:getData()
			local level = GDatatab_item["id_" .. tData.basicInfo.id].value
			local tCostList = GDatatab_mosaic_config["id_"..level].cost
			for i = 1, #tCostList do
				if not JudgeMoneyIsEnough(tCostList[i][1], tCostList[i][2]) then 
					return 
				end
			end
			WZLog("WndGemMountingStrengthen:onClickRight", Serialize(tData))
			self:addStoneToCell(tData)
		else
			MsgBoxManager:showTipBox(LocalStrings.GEM_STONE2)
		end
		return 
	elseif self.m_nOperateType == 1 then 
		WndUpgradeGem:onSure(element)
	end
end

--@brief 	设置获取宝石按钮是否可见
function WndGemMountingStrengthen:setGetStoneBtnVisible(bVisible)
	if self.m_root == nil then return end 

	GetElement(self.m_root, "btnGetStone_WndGemMountingStrengthen", WZUIButton):setVisible(bVisible)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化镶嵌窗口UI
function WndGemMountingStrengthen:_initGemMountingUI()
	self:setSpineAni()
	--攻击镶嵌石
	local conAttackStone = self.m_root:getChildElement("conAttackStone_WndGemMountingStrengthen")
	if conAttackStone ~= nil then
		self.m_attackStoneElement, self.m_attackStoneLuaObj = CellGoodItem:createElement()
		if self.m_attackStoneElement ~= nil and self.m_attackStoneLuaObj ~= nil then
			conAttackStone:addChild(self.m_attackStoneElement)
            self.m_attackStoneElement:setScale(1)
			self.m_attackStoneLuaObj:_setBgImgVisible(false)
			self.m_attackStoneLuaObj:setItemClickFun(self,self.onAttackStoneCellClick)
		end
	end
	
	--防御镶嵌石
	local conDefenseStone = self.m_root:getChildElement("conDefenseStone_WndGemMountingStrengthen")
	if conDefenseStone ~= nil then
		self.m_defenseStoneElement, self.m_defenseStoneLuaObj = CellGoodItem:createElement()
		if self.m_defenseStoneElement ~= nil and self.m_defenseStoneLuaObj ~= nil then
			conDefenseStone:addChild(self.m_defenseStoneElement)
            self.m_defenseStoneElement:setScale(1)
			self.m_defenseStoneLuaObj:_setBgImgVisible(false)
			self.m_defenseStoneLuaObj:setItemClickFun(self,self.onDefenseStoneCellClick)
		end
	end
	
	--生命镶嵌石
	local conSpecialStone = self.m_root:getChildElement("conSpecialStone_WndGemmountingStrengthen")
	if conSpecialStone ~= nil then
		self.m_specialStoneElement, self.m_specialStoneLuaObj = CellGoodItem:createElement()
		if self.m_specialStoneElement ~= nil and self.m_specialStoneLuaObj ~= nil then
			conSpecialStone:addChild(self.m_specialStoneElement)
            self.m_specialStoneElement:setScale(1)
			self.m_specialStoneLuaObj:_setBgImgVisible(false)
			self.m_specialStoneLuaObj:setItemClickFun(self,self.onLifeStoneCellClick)
		end
	end

	--共鸣宝石
	local conStone = self.m_root:getChildElement("conExtremeStone_WndGemmountingStrengthen")
	if conStone ~= nil then
		self.m_extremeStoneElement, self.m_extremeStoneLuaObj = CellGoodItem:createElement()
		if self.m_extremeStoneElement ~= nil and self.m_extremeStoneLuaObj ~= nil then
			conStone:addChild(self.m_extremeStoneElement)
            self.m_extremeStoneElement:setScale(1)
			self.m_extremeStoneLuaObj:_setBgImgVisible(false)
			self.m_extremeStoneLuaObj:setItemClickFun(self,self.onExtremeStoneCellClick)
		end
	end
end

--@brief	添加攻击镶嵌石
--@author   zsq
function WndGemMountingStrengthen:_addAttackStone(tData)
	if self.m_tCurSelectedEquip == nil or tData == nil then
		return
	end
	--放入攻击镶嵌石
	if self.m_attackStoneLuaObj ~= nil then
        if self.m_attackStoneLuaObj.m_tItem ~= nil then
            self.m_attackStoneLuaObj:removeAllChild()
        end
		local data = CopyTable(tData)
		data.lastNum = 0
		self.m_attackStoneLuaObj:setCellGoodItem(data,15)
	end
    self:_updateAttackAttribute()
end

--@brief	添加已经镶嵌的攻击石
function WndGemMountingStrengthen:_addGemMountingAttackStone()
	if (self.m_tCurSelectedEquip ~= nil) then
        local tempData = {}
		local id = self.m_tCurSelectedEquip.extraInfo.attackStone
        if id <= 0 then return end
		tempData.id = id
		tempData.maintype = GDatatab_item["id_"..id].type
		tempData.subtype = GDatatab_item["id_"..id].subtype
		tempData.lastNum = 1
		tempData.basicInfo = GDatatab_item["id_"..id]
		tempData.icon = GDatatab_item["id_"..id].icon
		tempData.quality = GDatatab_item["id_"..id].quality

		if self.m_nSelStoneSeat == nil then 
			self.m_nSelStoneSeat = 1
		end
        
        self:_addAttackStone(tempData)
	end
end

--@brief	添加防御镶嵌石
--@author   zsq
function WndGemMountingStrengthen:_addDefenseStone(tData)
	if self.m_tCurSelectedEquip == nil or tData == nil then
		return
	end

	--放入防御镶嵌石
	if self.m_defenseStoneLuaObj ~= nil then
        if self.m_defenseStoneLuaObj.m_tItem ~= nil then
            self.m_defenseStoneLuaObj:removeAllChild()
        end
		local data = CopyTable(tData)
		data.lastNum = 0
		self.m_defenseStoneLuaObj:setCellGoodItem(data,15)
        
        self:_updateDefenseAttribute()
	end
end

--@brief	添加已经镶嵌的防御石
function WndGemMountingStrengthen:_addGemMountingDefenseStone()
	if (self.m_tCurSelectedEquip ~= nil) then
		local tempData = {}
		local id = self.m_tCurSelectedEquip.extraInfo.defendStone
        if id <= 0 then return end
		tempData.id = id
		tempData.maintype = GDatatab_item["id_"..id].type
		tempData.subtype = GDatatab_item["id_"..id].subtype
		tempData.lastNum = 1
		tempData.basicInfo = GDatatab_item["id_"..id]
		tempData.icon = GDatatab_item["id_"..id].icon
		tempData.quality = GDatatab_item["id_"..id].quality

		if self.m_nSelStoneSeat == nil then 
			self.m_nSelStoneSeat = 2
		end
		
        self:_addDefenseStone(tempData)
	end
end

--@brief	添加生命镶嵌石
function WndGemMountingStrengthen:_addSpecialStone(tData)
	if self.m_tCurSelectedEquip == nil or tData == nil then
		return
	end
	--放入生命镶嵌石
	if self.m_specialStoneLuaObj ~= nil then
        if self.m_specialStoneLuaObj.m_tItem ~= nil then
            self.m_specialStoneLuaObj:removeAllChild()
        end
		local data = CopyTable(tData)
		data.lastNum = 0
		self.m_specialStoneLuaObj:setCellGoodItem(data,15)
        
        self:_updateSpecialAttribute()
	end
end

--@brief	添加已经镶嵌的生命石
function WndGemMountingStrengthen:_addGemMountingSpecialStone()
	if (self.m_tCurSelectedEquip ~= nil) then
        local tempData = {}
		local id = self.m_tCurSelectedEquip.extraInfo.hpStone
        if id <= 0 then return end
		tempData.id = id
		tempData.maintype = GDatatab_item["id_"..id].type
		tempData.subtype = GDatatab_item["id_"..id].subtype
		tempData.lastNum = 1
		tempData.basicInfo = GDatatab_item["id_"..id]
		tempData.icon = GDatatab_item["id_"..id].icon
		tempData.quality = GDatatab_item["id_"..id].quality

		if self.m_nSelStoneSeat == nil then 
			self.m_nSelStoneSeat = 0
		end
    
        self:_addSpecialStone(tempData)
	end
end

--@brief	添加共鸣镶嵌石
function WndGemMountingStrengthen:_addExtremeStone(tData)
	if self.m_tCurSelectedEquip == nil or tData == nil then
		return
	end
	--放入共鸣镶嵌石
	if self.m_extremeStoneLuaObj ~= nil then
        if self.m_extremeStoneLuaObj.m_tItem ~= nil then
            self.m_extremeStoneLuaObj:removeAllChild()
        end
		local data = CopyTable(tData)
		data.lastNum = 0
		self.m_extremeStoneLuaObj:setCellGoodItem(data,15)
        
        self:_updateExtremeAttribute()
	end
end

--@brief	添加已经镶嵌的共鸣石
function WndGemMountingStrengthen:_addGemMountingExtremeStone()
	if (self.m_tCurSelectedEquip ~= nil) then
        local tempData = {}
		local id = self.m_tCurSelectedEquip.extraInfo.gongmingStone
        if id <= 0 then return end
		tempData.id = id
		tempData.maintype = GDatatab_item["id_"..id].type
		tempData.subtype = GDatatab_item["id_"..id].subtype
		tempData.lastNum = 1
		tempData.basicInfo = GDatatab_item["id_"..id]
		tempData.icon = GDatatab_item["id_"..id].icon
		tempData.quality = GDatatab_item["id_"..id].quality

		if self.m_nSelStoneSeat == nil then 
			self.m_nSelStoneSeat = 5
		end
    
        self:_addExtremeStone(tempData)
	end
end

--@brief	清空攻击镶嵌石
function WndGemMountingStrengthen:_clearAttackStone()
    if self.m_attackStoneLuaObj.m_tItem ~= nil then self.m_attackStoneLuaObj:removeAllChild() end
    self:_updateAttackAttribute()
end

--@brief	清空防御镶嵌石
function WndGemMountingStrengthen:_clearDefenseStone()
    if self.m_defenseStoneLuaObj.m_tItem ~= nil then self.m_defenseStoneLuaObj:removeAllChild() end
    self:_updateDefenseAttribute()
end

--@brief	清空生命镶嵌石
function WndGemMountingStrengthen:_clearSpecialStone()
    if self.m_specialStoneLuaObj.m_tItem ~= nil then self.m_specialStoneLuaObj:removeAllChild() end
    self:_updateSpecialAttribute()
end

--@brief	清空共鸣石
function WndGemMountingStrengthen:_clearExtremeStone()
    if self.m_extremeStoneLuaObj.m_tItem ~= nil then self.m_extremeStoneLuaObj:removeAllChild() end
	local gongming1 = GetElement(self.m_root,"gongming1",WZUISpine)
	gongming1:setVisible(false)
    self:_updateExtremeAttribute()
end

--@biref	更新镶嵌属性信息
--@note		更新镶嵌属性信息
function WndGemMountingStrengthen:_updateGemMountingAttributeInfo()
	--攻击属性
	self:_updateAttackAttribute()
	--防御属性
	self:_updateDefenseAttribute()
	--生命属性
	self:_updateSpecialAttribute()
	--共鸣属性
	self:_updateExtremeAttribute()
end

--@biref	更新攻击镶嵌石属性信息
function WndGemMountingStrengthen:_updateAttackAttribute()
    --攻击cell：宝石类别，未镶嵌，宝石名称，属性加成，更改按钮
    local typeName = ""
    local settingStr = ""
    local attackStoneName = ""
    local attackAdd = ""
	local quality = 1
	local level = ""
    if  self.m_attackStoneLuaObj.m_tItem ~= nil then
        local id = self.m_attackStoneLuaObj.m_tItem.id
        attackAdd = LocalStrings.ATTACK .. "+" .. GDatatab_item["id_"..id].property[1][2]
        attackStoneName = GDatatab_item["id_"..id].name
		quality = GDatatab_item["id_"..id].quality 
		level = GDatatab_item["id_"..id].value
    else
        attackAdd = LocalStrings.ATTACK .. "+" .. 0
        typeName = LocalStrings.ATTACK_STONE_1
        settingStr = string.format("[%s]",LocalStrings.NOSTONE_STRENGTHEN)
    end
    --获取控件并初始化
    GetElement(self.m_root,"txtTypeName1_WndGemMountingStrengthen",WZUILabelTTF):setText(typeName)
    GetElement(self.m_root,"txtNoSetting1_WndGemMountingStrengthen",WZUILabelTTF):setText(settingStr)
    GetElement(self.m_root,"txtAttackName_WndGemMountingStrengthen",WZUILabelTTF):setText(attackStoneName)
    GetElement(self.m_root,"txtAttackName_WndGemMountingStrengthen",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
    GetElement(self.m_root,"txtAttackAdd_WndGemMountingStrengthen",WZUILabelTTF):setText(attackAdd)
    GetElement(self.m_root,"txtAttackLevel_WndGemMountingStrengthen",WZUILabelTTF):setText(level)

    local imgAddIcon = GetElement(self.m_root,"imgAddAttack_WndGemmountingStrengthen",WZUIImage)
    if self.m_tCurSelectedEquip ~= nil and self.m_attackStoneLuaObj.m_tItem == nil then
        imgAddIcon:setVisible(true)
    else
        imgAddIcon:setVisible(false)
    end

    --红点
    local bIsRed = false
	local tEquip = WndStrengthen:getRecommendEquip2()
	for i = 1, #tEquip do
		if tEquip[i].basicInfo and tEquip[i].basicInfo.time_limit == -1 and tEquip[i].isUse then
		    if self.m_tCurSelectedEquip ~= nil and self.m_attackStoneLuaObj.m_tItem == nil and self.m_tCurSelectedEquip.playerItemId == tEquip[i].playerItemId then
		    	bIsRed = true
		    	break
		    end
		end
	end
    local imgAttackRed = GetElement(self.m_root,"imgAttackRed_WndGemMountingStrengthen",WZUIImage)
	imgAttackRed:setVisible(bIsRed)

    local tipsStr = ""
	local mount = false
    local txtTips = GetElement(self.m_root,"txtAttackTips_WndGemMountingStrengthen",WZUILabelTTF)
	GetElement(self.m_root,"chuanshu1",WZUISpine):setVisible(false)
    if self.m_tCurSelectedEquip ~= nil then
		if self.m_tCurSelectedEquip.extraInfo.attackStone == nil then self.m_tCurSelectedEquip.extraInfo.attackStone = 0 end
        if self.m_tCurSelectedEquip.extraInfo.attackStone > 0 then --已经镶嵌
            tipsStr = LocalStrings.CLICK_TO_REMOVE
			mount = true
			--共鸣特效
			if self.m_tCurSelectedEquip.extraInfo.gongmingStone ~= nil and self.m_tCurSelectedEquip.extraInfo.gongmingStone > 0 then
				GetElement(self.m_root,"chuanshu1",WZUISpine):setVisible(true)
			end
        else
            if self.m_attackStoneLuaObj.m_tItem == nil then --没有镶嵌且没有添加宝石
                tipsStr = LocalStrings.CLICK_TO_ADD
            else
                tipsStr = LocalStrings.CLICK_TO_CHANGE
            end
        end
    end
   	GetElement(self.m_root,"txtTypeName1_WndGemMountingStrengthen",WZUILabelTTF):setVisible(not mount)
   	GetElement(self.m_root,"txtNoSetting1_WndGemMountingStrengthen",WZUILabelTTF):setVisible(not mount)
   	GetElement(self.m_root,"txtAttackName_WndGemMountingStrengthen",WZUILabelTTF):setVisible(mount)
   	GetElement(self.m_root,"txtAttackAdd_WndGemMountingStrengthen",WZUILabelTTF):setVisible(mount)
   	GetElement(self.m_root,"conAttack",WZUIContainer):setVisible(mount)
    txtTips:setText(tipsStr)
end

--@biref	更新防御镶嵌石属性信息
--@note		更新防御镶嵌石属性信息
function WndGemMountingStrengthen:_updateDefenseAttribute()
    local typeName = ""
    local settingStr = ""
    local defenseStoneName = ""
    local defenseAdd = ""
	local quality = 1
	local level = ""
    if  self.m_defenseStoneLuaObj.m_tItem ~= nil then
        local id = self.m_defenseStoneLuaObj.m_tItem.id
        defenseAdd = LocalStrings.DEFENSE .. "+" .. GDatatab_item["id_"..id].property[1][2]
        defenseStoneName = GDatatab_item["id_"..id].name
        quality = GDatatab_item["id_"..id].quality
		level = GDatatab_item["id_"..id].value
    else
        defenseAdd = LocalStrings.DEFENSE .. "+" .. 0
        typeName = LocalStrings.DEFENSE_STONE_1
        settingStr = string.format("[%s]",LocalStrings.NOSTONE_STRENGTHEN)
    end
    --获取控件并初始化
    GetElement(self.m_root,"txtTypeName2_WndGemMountingStrengthen",WZUILabelTTF):setText(typeName)
    GetElement(self.m_root,"txtNoSetting2_WndGemMountingStrengthen",WZUILabelTTF):setText(settingStr)
    GetElement(self.m_root,"txtDefenseName_WndGemMountingStrengthen",WZUILabelTTF):setText(defenseStoneName)
    GetElement(self.m_root,"txtDefenseName_WndGemMountingStrengthen",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
    GetElement(self.m_root,"txtDefenseAdd_WndGemMountingStrengthen",WZUILabelTTF):setText(defenseAdd)
    GetElement(self.m_root,"txtDefenseLevel_WndGemMountingStrengthen",WZUILabelTTF):setText(level)

    local imgAddIcon = GetElement(self.m_root,"imgAddDefense_WndGemmountingStrengthen",WZUIImage)
    if self.m_tCurSelectedEquip ~= nil and self.m_defenseStoneLuaObj.m_tItem == nil then
        imgAddIcon:setVisible(true)
    else
        imgAddIcon:setVisible(false)
    end

    --红点
    local bIsRed = false
	local tEquip = WndStrengthen:getRecommendEquip2()
	for i = 1, #tEquip do
		if tEquip[i].basicInfo and tEquip[i].basicInfo.time_limit == -1 and tEquip[i].isUse then
		    if self.m_tCurSelectedEquip ~= nil and self.m_defenseStoneLuaObj.m_tItem == nil and self.m_tCurSelectedEquip.playerItemId == tEquip[i].playerItemId then
		    	bIsRed = true
		    	break
		    end
		end
	end
    local imgDefenseRed = GetElement(self.m_root,"imgDefenseRed_WndGemMountingStrengthen",WZUIImage)
    imgDefenseRed:setVisible(bIsRed)

    local tipsStr = ""
	local mount = false
    local txtTips = GetElement(self.m_root,"txtDefenseTips_WndGemMountingStrengthen",WZUILabelTTF)
	GetElement(self.m_root,"chuanshu2",WZUISpine):setVisible(false)
    if self.m_tCurSelectedEquip ~= nil then
			if self.m_tCurSelectedEquip.extraInfo.defendStone == nil then self.m_tCurSelectedEquip.extraInfo.defendStone = 0 end
        if self.m_tCurSelectedEquip.extraInfo.defendStone > 0 then --已经镶嵌
            tipsStr = LocalStrings.CLICK_TO_REMOVE
			mount = true
			--共鸣特效
			if self.m_tCurSelectedEquip.extraInfo.gongmingStone ~= nil and self.m_tCurSelectedEquip.extraInfo.gongmingStone > 0 then
				GetElement(self.m_root,"chuanshu2",WZUISpine):setVisible(true)
			end
        else
            if self.m_defenseStoneLuaObj.m_tItem == nil then --没有镶嵌且没有添加宝石
                tipsStr = LocalStrings.CLICK_TO_ADD
            else
                tipsStr = LocalStrings.CLICK_TO_CHANGE
            end
        end
    end
   	GetElement(self.m_root,"txtTypeName2_WndGemMountingStrengthen",WZUILabelTTF):setVisible(not mount)
   	GetElement(self.m_root,"txtNoSetting2_WndGemMountingStrengthen",WZUILabelTTF):setVisible(not mount)
   	GetElement(self.m_root,"txtDefenseName_WndGemMountingStrengthen",WZUILabelTTF):setVisible(mount)
   	GetElement(self.m_root,"txtDefenseAdd_WndGemMountingStrengthen",WZUILabelTTF):setVisible(mount)
   	GetElement(self.m_root,"conDefense",WZUIContainer):setVisible(mount)
    txtTips:setText(tipsStr)
end

--@biref	更新生命镶嵌石属性信息
--@note		更新生命镶嵌石属性信息
function WndGemMountingStrengthen:_updateSpecialAttribute()
    local typeName = ""
    local settingStr = ""
    local lifeStoneName = ""
    local lifeAdd = ""
	local quality = 1
	local level = ""
    if  self.m_specialStoneLuaObj.m_tItem ~= nil then
        local id = self.m_specialStoneLuaObj.m_tItem.id
        lifeAdd = LocalStrings.HEALTH .. "+" .. GDatatab_item["id_"..id].property[1][2]
        lifeStoneName = GDatatab_item["id_"..id].name
        quality = GDatatab_item["id_"..id].quality
		level = GDatatab_item["id_"..id].value
    else
        lifeAdd = LocalStrings.HEALTH .. "+" .. 0
        typeName = LocalStrings.HP_STONE
        settingStr = string.format("[%s]",LocalStrings.NOSTONE_STRENGTHEN)
    end
    --获取控件并初始化
    GetElement(self.m_root,"txtTypeName3_WndGemMountingStrengthen",WZUILabelTTF):setText(typeName)
    GetElement(self.m_root,"txtNoSetting3_WndGemMountingStrengthen",WZUILabelTTF):setText(settingStr)
    GetElement(self.m_root,"txtLifeName_WndGemMountingStrengthen",WZUILabelTTF):setText(lifeStoneName)
    GetElement(self.m_root,"txtLifeName_WndGemMountingStrengthen",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
    GetElement(self.m_root,"txtLifeAdd_WndGemMountingStrengthen",WZUILabelTTF):setText(lifeAdd)
    GetElement(self.m_root,"txtLiftLevel_WndGemMountingStrengthen",WZUILabelTTF):setText(level)

    local imgAddIcon = GetElement(self.m_root,"imgAddSpecial_WndGemmountingStrengthen",WZUIImage)
    if self.m_tCurSelectedEquip ~= nil and self.m_specialStoneLuaObj.m_tItem == nil then
        imgAddIcon:setVisible(true)
    else
        imgAddIcon:setVisible(false)
    end

    --红点
    local bIsRed = false
	local tEquip = WndStrengthen:getRecommendEquip2()
	for i = 1, #tEquip do
		if tEquip[i].basicInfo and tEquip[i].basicInfo.time_limit == -1 and tEquip[i].isUse then
		    if self.m_tCurSelectedEquip ~= nil and self.m_specialStoneLuaObj.m_tItem == nil and self.m_tCurSelectedEquip.playerItemId == tEquip[i].playerItemId then
		    	bIsRed = true
		    	break
		    end
		end
	end
    local imgSpecialRed = GetElement(self.m_root,"imgSpecialRed_WndGemMountingStrengthen",WZUIImage)
    imgSpecialRed:setVisible(bIsRed)

    local tipsStr = ""
	local mount = false
    local txtTips = GetElement(self.m_root,"txtLifeTips_WndGemMountingStrengthen",WZUILabelTTF)
	GetElement(self.m_root,"chuanshu0",WZUISpine):setVisible(false)
    if self.m_tCurSelectedEquip ~= nil then
			if self.m_tCurSelectedEquip.extraInfo.hpStone == nil then self.m_tCurSelectedEquip.extraInfo.hpStone = 0 end
        if self.m_tCurSelectedEquip.extraInfo.hpStone > 0 then --已经镶嵌
            tipsStr = LocalStrings.CLICK_TO_REMOVE
			mount = true
			--共鸣特效
			if self.m_tCurSelectedEquip.extraInfo.gongmingStone ~= nil and self.m_tCurSelectedEquip.extraInfo.gongmingStone > 0 then
				GetElement(self.m_root,"chuanshu0",WZUISpine):setVisible(true)
			end
        else
            if self.m_specialStoneLuaObj.m_tItem == nil then --没有镶嵌且没有添加宝石
                tipsStr = LocalStrings.CLICK_TO_ADD
            else
                tipsStr = LocalStrings.CLICK_TO_CHANGE
            end
        end
    end
   	GetElement(self.m_root,"txtTypeName3_WndGemMountingStrengthen",WZUILabelTTF):setVisible(not mount)
   	GetElement(self.m_root,"txtNoSetting3_WndGemMountingStrengthen",WZUILabelTTF):setVisible(not mount)
   	GetElement(self.m_root,"txtLifeName_WndGemMountingStrengthen",WZUILabelTTF):setVisible(mount)
   	GetElement(self.m_root,"txtLifeAdd_WndGemMountingStrengthen",WZUILabelTTF):setVisible(mount)
   	GetElement(self.m_root,"conLift",WZUIContainer):setVisible(mount)
    txtTips:setText(tipsStr)
end

--@biref	更新共鸣石属性信息
function WndGemMountingStrengthen:_updateExtremeAttribute()
    local typeName = ""
    local settingStr = ""
    local lifeStoneName = ""
    local lifeAdd = ""
	local quality = 1
	local level = ""
    if  self.m_extremeStoneLuaObj.m_tItem ~= nil then
        local id = self.m_extremeStoneLuaObj.m_tItem.id
        lifeAdd = LocalStrings.NEWSTONE1 .. "+" .. GDatatab_item["id_"..id].property[1][2].."%"
        lifeStoneName = GDatatab_item["id_"..id].name
        quality = GDatatab_item["id_"..id].quality
		level = GDatatab_item["id_"..id].value
    else
        lifeAdd = LocalStrings.NEWSTONE1 .. "+" .. "0" .."%"
        typeName = LocalStrings.NEWSTONE2
        settingStr = string.format("[%s]",LocalStrings.NOSTONE_STRENGTHEN)
    end
    --获取控件并初始化
    GetElement(self.m_root,"txtTypeName4_WndGemMountingStrengthen",WZUILabelTTF):setText(typeName)
    GetElement(self.m_root,"txtNoSetting4_WndGemMountingStrengthen",WZUILabelTTF):setText(settingStr)
    GetElement(self.m_root,"txtExtremeName_WndGemMountingStrengthen",WZUILabelTTF):setText(lifeStoneName)
    GetElement(self.m_root,"txtExtremeName_WndGemMountingStrengthen",WZUILabelTTF):setColor(QUALITYCOLOR[quality])
    GetElement(self.m_root,"txtExtremeAdd_WndGemMountingStrengthen",WZUILabelTTF):setText(lifeAdd)
    GetElement(self.m_root,"txtExtremeLevel_WndGemMountingStrengthen",WZUILabelTTF):setText(level)

    local imgAddIcon = GetElement(self.m_root,"imgAddExtreme_WndGemmountingStrengthen",WZUIImage)
	local gongming1 = GetElement(self.m_root,"gongming1",WZUISpine)
    if self.m_tCurSelectedEquip ~= nil and self.m_extremeStoneLuaObj.m_tItem == nil then
        imgAddIcon:setVisible(true)
    else
        imgAddIcon:setVisible(false)
    end
	if CheckButtonOpen(195,true) ~= true then
		imgAddIcon:setFile("ui/common/common_icon_suo.png")
	else
		imgAddIcon:setFile("ui/common/common_btn_add.png")
	end

	--红点
	local bIsRed = false
	local tEquip = WndStrengthen:getRecommendEquip2()
	for i = 1, #tEquip do
		if tEquip[i].basicInfo and tEquip[i].basicInfo.time_limit == -1 and tEquip[i].isUse then
		    if self.m_tCurSelectedEquip ~= nil and self.m_extremeStoneLuaObj.m_tItem == nil and self.m_tCurSelectedEquip.playerItemId == tEquip[i].playerItemId and CheckButtonOpen(195,true) then
		        bIsRed = true
		        break
		    end
		end
	end
    local imgMainRed = GetElement(self.m_root,"imgMainRed_WndGemMountingStrengthen",WZUIImage)
    imgMainRed:setVisible(bIsRed)

    local tipsStr = ""
	local mount = false
    local txtTips = GetElement(self.m_root,"txtExtremeTips_WndGemMountingStrengthen",WZUILabelTTF)
    if self.m_tCurSelectedEquip ~= nil then
		if self.m_tCurSelectedEquip.extraInfo.gongmingStone == nil then self.m_tCurSelectedEquip.extraInfo.gongmingStone = 0 end
        if self.m_tCurSelectedEquip.extraInfo.gongmingStone > 0 then --已经镶嵌
			gongming1:setVisible(true)
            tipsStr = LocalStrings.CLICK_TO_REMOVE
			mount = true
        else
			gongming1:setVisible(false)
            if self.m_extremeStoneLuaObj.m_tItem == nil then --没有镶嵌且没有添加宝石
                tipsStr = LocalStrings.CLICK_TO_ADD
            else
                tipsStr = LocalStrings.CLICK_TO_CHANGE
            end
        end
    end
   	GetElement(self.m_root,"txtTypeName4_WndGemMountingStrengthen",WZUILabelTTF):setVisible(not mount)
   	GetElement(self.m_root,"txtNoSetting4_WndGemMountingStrengthen",WZUILabelTTF):setVisible(not mount)
   	GetElement(self.m_root,"txtExtremeName_WndGemMountingStrengthen",WZUILabelTTF):setVisible(mount)
   	GetElement(self.m_root,"txtExtremeAdd_WndGemMountingStrengthen",WZUILabelTTF):setVisible(mount)
   	GetElement(self.m_root,"conExtreme",WZUIContainer):setVisible(mount)
    txtTips:setText(tipsStr)
end

--@brief	显示镶嵌相关操作结果
--@param	nType:操作结果类型（0是打孔成功，1是镶嵌成功，2是拆卸成功，3是拆卸失败，4是拆卸失败并失去宝石）
--@note		显示镶嵌相关操作结果
function WndGemMountingStrengthen:_showGemMountingResult(nType)
	if nType == 1 then
	--镶嵌成功
		PopupResult("ui/common/common_icon_xqz.png")
	elseif nType == 2 then
	--拆卸成功
		PopupResult("ui/common/common_icon_cxcg.png")
	end
end

--@brief 显示宝石列表
--@param 	listType : 1镶嵌列表；2吞噬列表(只有宝石达到最大等级才会用到)
function WndGemMountingStrengthen:showStoneList(sub_type, listType)
	local tbGemList = GetElement(self.m_root, "tbGemList_WndGemMountingStrengthen", WZUITableContainer)
	tbGemList:setVisible(true)
	tbGemList:cleanTable()
	local tListData = {}
	local tMaterialItems = {}
	if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
		tMaterialItems = CopyTable(CacheCenter:getPetEquipGemsList())
	    for i,v in pairs(tMaterialItems) do
	    	if listType == 1 then 
		        if v.subtype == sub_type then
		            table.insert(tListData,v)
		        end
		    elseif listType == 2 then 
		        if v.subtype ~= 5 then
		            table.insert(tListData,v)
		        end
		        if #tListData <= 0 then 
		        	self:setGetStoneBtnVisible(true)
		        else
		        	self:setGetStoneBtnVisible(false)
		        end
		    end
	    end
	else
		tMaterialItems = CopyTable(CacheCenter:getMaterialList())
	    for i,v in pairs(tMaterialItems) do
	    	if listType == 1 then 
		        if v.maintype == 6 and v.subtype == sub_type then
		            table.insert(tListData,v)
		        end
		    elseif listType == 2 then 
		        if v.maintype == 6 and v.subtype ~= 5 then
		            table.insert(tListData,v)
		        end
		        if #tListData <= 0 then 
		        	self:setGetStoneBtnVisible(true)
		        else
		        	self:setGetStoneBtnVisible(false)
		        end
		    end
	    end
	end

    if listType == 1 then 
    	table.sort(tListData, _sortStone)
    elseif listType == 2 then 
		table.sort(tListData, sortToLow )
	end

	WZLog("WndGemMountingStrengthen:showStoneList", #tListData)
    for i = 1, #tListData do
    	local element, tNewObj = CellGoodItem:createElement()
    	if element and tNewObj then 
    		element:setTag(i - 1)
    		tNewObj:setCellGoodItem(tListData[i], 4)
    		element:setScale(0.78)
    		if listType == 1 then 
    			tNewObj:setItemClickFun(self, self.onClickItem)
    		end

    		tbGemList:setCellElement(element)
    	end
    end
end

--@brief    宝石排序函数
function _sortStone(a,b)
    --宝石等级
    local aKey = "id_" .. a.basicInfo.id
    local bKey = "id_" .. b.basicInfo.id
    local aLv = GDatatab_item[aKey].value
    local bLv = GDatatab_item[bKey].value
    if aLv > bLv then
        return true
    else
        return false
    end
end

--@brief 	设置消耗
function WndGemMountingStrengthen:setCost(tCostList)
	if self.m_root == nil then return end 

	local ftxtCost = GetElement(self.m_root, "ftxtCost_WndGemMountingStrengthen", WZUIFreeTextBox)
	ftxtCost:setVisible(true)
	local sFormat = [[<T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">%s</T>]]
	local sCostString = string.format(sFormat, LocalStrings.CONSUME)

	local costFormat = [[<I Z="0.53" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SE="1" SS="4">%d</T><BL>32</BL>]]
	for i = 1, #tCostList do
		local basicInfo = GDatatab_item["id_" .. tCostList[i][1]]
		local tempString = string.format(costFormat, basicInfo.icon, tCostList[i][2])

		sCostString = sCostString .. tempString
	end

	ftxtCost:setShowText(sCostString)
end

--@brief 	展示属性
--@param 	nType : 1普通宝石升级；2魔力宝石升级；3镶嵌；4清除
--@param 	addLevel : 可提升等级（nType=2时候才有用）
function WndGemMountingStrengthen:showPropertyAtt(nType, stoneId, addLevel)
	if self.m_root == nil then return end 

	GetElement(self.m_root, "conPro_WndGemMountingStrengthen", WZUIContainer):setVisible(true)
	--清空之前的数据
	for i = 1, 2 do
		local txtProAtt = GetElement(self.m_root,"txtProAtt1" .. i .. "_WndGemMountingStrengthen",WZUILabelTTF)
		txtProAtt:setText("")
		local txtProValue = GetElement(self.m_root,"txtProValue1"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtProValue:setText("")

		local txtProAtt2 = GetElement(self.m_root,"txtProAtt2" .. i .. "_WndGemMountingStrengthen",WZUILabelTTF)
		txtProAtt2:setText("")
		local txtProValue2 = GetElement(self.m_root,"txtProValue2"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtProValue2:setText("")

		GetElement(self.m_root, "imgArrow" .. i .. "_WndGemMountingStrengthen", WZUIImage):setVisible(false)
	end

	--主要宠物装备用到
	GetElement(self.m_root, "txtNotInlaidGem_WndGemMountingStrengthen", WZUILabelTTF):setText("")
	GetElement(self.m_root, "txtProAttrOther_WndGemMountingStrengthen", WZUILabelTTF):setText("")

	if nType == 4 then return end 

	local pre_id = stoneId 
	local post_id = -1
	if nType == 1 then 
		if GDatatab_itemmerge["id_" .. pre_id] then
			post_id = GDatatab_itemmerge["id_" .. pre_id].items[1][1]
		end
	elseif nType == 2 then 
		if addLevel <= 1 then 
			post_id = GDatatab_dig_up["id_" .. pre_id].behind_id
		else
			local nTempLevel = addLevel
			local nTempStoneId = stoneId 
			while nTempLevel > 0 do
				post_id = GDatatab_dig_up["id_" .. nTempStoneId].behind_id

				nTempStoneId = post_id
				nTempLevel = nTempLevel - 1
			end
		end
	elseif nType == 3 then 
		post_id = stoneId
	end
	local leftItemInfo = CopyTable(GDatatab_item["id_"..pre_id])
	local rightItemInfo = GDatatab_item["id_"..post_id]
	if nType == 3 then --镶嵌时候，前面属性显示0
		leftItemInfo.property = {}
		for i=1, #rightItemInfo.property do
			local tItem = {}
			tItem[1] = rightItemInfo.property[i][1]
			tItem[2] = 0

			table.insert(leftItemInfo.property, tItem)
		end
	end
	local subType = leftItemInfo.sub_type
	--升级前
	for i=1, #leftItemInfo.property do
		local txtProAtt = GetElement(self.m_root,"txtProAtt1" .. i .. "_WndGemMountingStrengthen",WZUILabelTTF)
		txtProAtt:setText(ATTR_TITLE[leftItemInfo.property[i][1]])
		local txtProValue = GetElement(self.m_root,"txtProValue1"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		if subType == 5 then 
			txtProValue:setText(leftItemInfo.property[i][2] .. "%")
		else
			txtProValue:setText(leftItemInfo.property[i][2])
		end
	end
	
	-- 右边宝石
	if rightItemInfo then 
		for i=1, #rightItemInfo.property do
			local txtProAtt = GetElement(self.m_root,"txtProAtt2"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
			txtProAtt:setText(ATTR_TITLE[rightItemInfo.property[i][1]])
			local txtProValue = GetElement(self.m_root,"txtProValue2"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
			if subType == 5 then 
				txtProValue:setText(rightItemInfo.property[i][2] .. "%")
			else
				txtProValue:setText(rightItemInfo.property[i][2])
			end

			GetElement(self.m_root, "imgArrow" .. i .. "_WndGemMountingStrengthen", WZUIImage):setVisible(true)
		end
	else
		for i=1, #leftItemInfo.property do
			local txtProAtt = GetElement(self.m_root,"txtProAtt2"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
			txtProAtt:setText(ATTR_TITLE[leftItemInfo.property[i][1]])
			local txtProValue = GetElement(self.m_root,"txtProValue2"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
			txtProValue:setText("???")

			GetElement(self.m_root, "imgArrow" .. i .. "_WndGemMountingStrengthen", WZUIImage):setVisible(true)
		end
	end
end

--@brief 	设置选中宝石槽的状态
function WndGemMountingStrengthen:setStoneSeatState(sub_type)
	GetElement(self.m_root, "img9AttackBg_WndGemMountingStrengthen", WZUI9Image):setFile("ui/common/common_dz.png")
	GetElement(self.m_root, "img9DefenseBg_WndGemMountingStrengthen", WZUI9Image):setFile("ui/common/common_dz.png")
	GetElement(self.m_root, "img9SpecialBg_WndGemMountingStrengthen", WZUI9Image):setFile("ui/common/common_dz.png")
	GetElement(self.m_root, "img9EBg_WndGemMountingStrengthen", WZUI9Image):setFile("ui/common/common_dz.png")
	if sub_type == 1 then 
		GetElement(self.m_root, "img9AttackBg_WndGemMountingStrengthen", WZUI9Image):setFile("ui/common/common_dz_xz.png")
	elseif sub_type == 2 then 
		GetElement(self.m_root, "img9DefenseBg_WndGemMountingStrengthen", WZUI9Image):setFile("ui/common/common_dz_xz.png")
	elseif sub_type == 0 then 
		GetElement(self.m_root, "img9SpecialBg_WndGemMountingStrengthen", WZUI9Image):setFile("ui/common/common_dz_xz.png")
	elseif sub_type == 5 then 
		GetElement(self.m_root, "img9EBg_WndGemMountingStrengthen", WZUI9Image):setFile("ui/common/common_dz_xz.png")
	end
end

--@brief    设置开箱特效
function WndGemMountingStrengthen:setSpineAni()
    local gongming1 = GetElement(self.m_root, "gongming1", WZUISpine)
    local spinePath = "ui/otherUI/UI_gongming"
    local bIsExist = CheckEffectFile(spinePath)

    if bIsExist then 
        gongming1:setFileJson(spinePath .. ".json")
        gongming1:setFileAtlas(spinePath .. ".atlas")
        gongming1:play("gongming", true)
    end

    local chuanshu0 = GetElement(self.m_root, "chuanshu0", WZUISpine)
    local chuanshu1 = GetElement(self.m_root, "chuanshu1", WZUISpine)
    local chuanshu2 = GetElement(self.m_root, "chuanshu2", WZUISpine)
    local spinePath2 = "ui/otherUI/UI_gongming_chuanshu"
    local bIsExist2 = CheckEffectFile(spinePath2)

    if bIsExist2 then 
        chuanshu0:setFileJson(spinePath2 .. ".json")
        chuanshu0:setFileAtlas(spinePath2 .. ".atlas")
        chuanshu0:play("chuanshu", true)

        chuanshu1:setFileJson(spinePath2 .. ".json")
        chuanshu1:setFileAtlas(spinePath2 .. ".atlas")
        chuanshu1:play("chuanshu", true)

        chuanshu2:setFileJson(spinePath2 .. ".json")
        chuanshu2:setFileAtlas(spinePath2 .. ".atlas")
        chuanshu2:play("chuanshu", true)
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function WndGemMountingStrengthen:_adaptLanguage_en()
	GetElement(self.m_root,"txtAttackName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtAttackAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDefenseName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDefenseAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLifeName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLifeAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtExtremeName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtExtremeAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
end

function WndGemMountingStrengthen:_adaptLanguage_pt(  )
	for i=1,4 do
		local txtNoSetting = GetElement(self.m_root,"txtNoSetting"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtNoSetting:setDimensions(GlobalMethod:CCSize(140))
		local txtTypeName = GetElement(self.m_root,"txtTypeName"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtTypeName:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
	end

	GetElement(self.m_root,"txtAttackName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtAttackAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDefenseName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDefenseAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLifeName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLifeAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtExtremeName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtExtremeAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
end

function WndGemMountingStrengthen:_adaptLanguage_tr(  )
    for i=1,3 do
        GetElement(self.m_root,"txtNoSetting"..i.."_WndGemMountingStrengthen",WZUILabelTTF):setFontSize(14)
        GetElement(self.m_root,"txtTypeName"..i.."_WndGemMountingStrengthen",WZUILabelTTF):setFontSize(16)
    end
end

function WndGemMountingStrengthen:_adaptLanguage_es(  )
    for i=1,4 do
		local txtNoSetting = GetElement(self.m_root,"txtNoSetting"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtNoSetting:setDimensions(GlobalMethod:CCSize(140))
		local txtTypeName = GetElement(self.m_root,"txtTypeName"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtTypeName:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
	end
    
    GetElement(self.m_root,"txtAttackName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtAttackAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDefenseName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDefenseAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLifeName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLifeAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtExtremeName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtExtremeAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
end

function WndGemMountingStrengthen:_adaptLanguage_ug(  )
    for i=1,4 do
		local txtNoSetting = GetElement(self.m_root,"txtNoSetting"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtNoSetting:setDimensions(GlobalMethod:CCSize(140))
		txtNoSetting:setScale(0.8)
		local txtTypeName = GetElement(self.m_root,"txtTypeName"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtTypeName:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
		txtTypeName:setScale(0.8)
	end
    GetElement(self.m_root,"txtAttackName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtAttackAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDefenseName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtDefenseAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLifeName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLifeAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtExtremeName_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtExtremeAdd_WndGemMountingStrengthen",WZUILabelTTF):setScale(0.8)

	local fireTitle = GetElement(self.m_root,"fireTitle",WZUILabelTTF)
	fireTitle:setRelativePosition(GlobalMethod:ccp(0.65,0.93))
	local fire_WndGem = GetElement(self.m_root,"fire_WndGem",WZUILabelAtlasFont)
	fire_WndGem:setRelativePosition(GlobalMethod:ccp(0.27,0.93))
	fire_WndGem:setAnchorPoint(GlobalMethod:ccp(1,0.5))

end

function WndGemMountingStrengthen:_adaptLanguage_vn()
	local txtProAtt11 = GetElement(self.m_root,"txtProAtt11_WndGemMountingStrengthen",WZUILabelTTF)
	local txtProValue11 = GetElement(self.m_root,"txtProValue11_WndGemMountingStrengthen",WZUILabelTTF)
	local txtProAtt12 = GetElement(self.m_root,"txtProAtt12_WndGemMountingStrengthen",WZUILabelTTF)
	local txtProValue12 = GetElement(self.m_root,"txtProValue12_WndGemMountingStrengthen",WZUILabelTTF)
	local txtProAtt21 = GetElement(self.m_root,"txtProAtt21_WndGemMountingStrengthen",WZUILabelTTF)
	local txtProValue21 = GetElement(self.m_root,"txtProValue21_WndGemMountingStrengthen",WZUILabelTTF)
	local txtProAtt22 = GetElement(self.m_root,"txtProAtt22_WndGemMountingStrengthen",WZUILabelTTF)
	local txtProValue22 = GetElement(self.m_root,"txtProValue22_WndGemMountingStrengthen",WZUILabelTTF)
	txtProAtt11:setFontSize(14)
	txtProValue11:setFontSize(14)
	txtProAtt12:setFontSize(14)
	txtProValue12:setFontSize(14)
	txtProAtt21:setFontSize(14)
	txtProValue21:setFontSize(14)
	txtProAtt22:setFontSize(14)
	txtProValue22:setFontSize(14)
end
-------------------------------------语言适配模块End----------------------------------------
