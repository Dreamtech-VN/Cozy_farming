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
    CreateLimitPackage(43, self.m_root, GlobalMethod:ccp(0, 0.945))
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
    if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end

	if self.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] == nil then self.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] = 0 end
    if self.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] <= 0 then
		local hasStone = false
    	local tMaterialItems = CopyTable(CacheCenter:getMaterialList())
    	for i,v in pairs(tMaterialItems) do
    	    if v.maintype == 6 and v.subtype == sub_type then
    	        hasStone = true
    	    end
    	end
		if hasStone then
        	--打开宝石列表 maintype=6,subtype=1 ,value = 等级
        	local t  = {}
        	t.type = sub_type
        	t.tData = self[LuaObj[sub_type+1]].m_tItem
        	WndSelectTipsStrengthen:showSelectTips(1,t)
		else 
			MsgBoxManager:showTipBox(LocalStrings.NEEDSTONE)
		end
    else
		local tData = self[LuaObj[sub_type+1]].m_tItem
		if tData.basicInfo.value == GEMMAXLEVEL then
    		tData.tBtnList = {LocalStrings.REMOVE_STONE}
		else
    		tData.tBtnList = {LocalStrings.REMOVE_STONE,LocalStrings.STAR_SOUL_BUTTON_UPDATE}
		end
    	WndItemInfo:showInfo(self[Element[sub_type+1]],GetElement(WndStrengthen.m_root,"conMidLeft_WndStrengthen",WZUIContainer),1,tData)
    	WndItemInfo:setClickButtonCallback(self,self.dismantleCallback)
    end
end

function WndGemMountingStrengthen:dismantleCallback(tag, tData)
	WZLog("WndGemMountingStrengthen:dismantleCallback",tag)
	local sub_type = tData.basicInfo.sub_type
	if tonumber(tag) == 1 then
		self:_createLoading()
		--拆卸宝石
		self.punchType = sub_type
		WndGemMountingStrengthen.m_nUpgradeGemId = nil
    	WndGemMountingStrengthen.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]] = 0
		ProtocolProcessorStrengthen:send_FORGING_Dismantle(self.m_tCurSelectedEquip.playerItemId, ProtocolType[sub_type+1])
	else
		WndUpgradeGem:show(self.m_tCurSelectedEquip, self.m_tCurSelectedEquip.extraInfo[GemName[sub_type+1]])
	end

    WndItemInfo:onCloseClick()
end

--@brief    点击攻击宝石cell回调
function WndGemMountingStrengthen:onAttackStoneCellClick()
    WZLog("WndGemMountingStrengthen:onAttackStoneCellClick()")
	self:onCellClick(1)
end

--@brief    点击防御宝石cell回调
--@author   zsq
function WndGemMountingStrengthen:onDefenseStoneCellClick()
    WZLog("WndGemMountingStrengthen:onDefenseStoneCellClick()")
	self:onCellClick(2)
end

--@brief    点击生命宝石cell回调
function WndGemMountingStrengthen:onLifeStoneCellClick()
    WZLog("WndGemMountingStrengthen:onLifeStoneCellClick()")
	self:onCellClick(0)
end

--@brief    点击共鸣宝石回调
function WndGemMountingStrengthen:onExtremeStoneCellClick()
    WZLog("WndGemMountingStrengthen:onExtremeStoneCellClick()")
	if CacheCenter:getPlayerInfo().level < 50 then
		MsgBoxManager:showTipBox(string.format(LocalStrings.NEWSTONE3, tostring(50)))
		return
	end
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

	local fightTitle = GetElement(self.m_root,"fireTitle",WZUILabelTTF)
	local fightText = GetElement(self.m_root,"fire_WndGem",WZUILabelAtlasFont)
	fightTitle:setVisible(false)
	fightText:setVisible(false)

    if self.m_tCurSelectedEquip ~= nil then
        --添加已镶嵌攻击宝石、更新攻击宝石cell信息
        self:_addGemMountingAttackStone()
        --添加已镶嵌防御宝石、更新防御宝石cell信息
        self:_addGemMountingDefenseStone()
        --添加已镶嵌生命宝石、更新生命宝石cell信息
        self:_addGemMountingSpecialStone()
        --添加已镶嵌共鸣宝石、更新共鸣宝石cell信息
        self:_addGemMountingExtremeStone()
    
		--显示宝石战斗力
		local attack = 0
		local defend = 0
		local hp = 0

		local extreme = 1
		local extremeId = self.m_tCurSelectedEquip.extraInfo.gongmingStone
        if extremeId > 0 then
			extreme = 1 + GDatatab_item["id_"..extremeId].property[1][2]/100
			--extreme = 1.2
		end

		local attackId = self.m_tCurSelectedEquip.extraInfo.attackStone
        if attackId > 0 then
			attack = GDatatab_item["id_"..attackId].property[1][2]*extreme
			attack = math.floor(attack)
		end
		local defendId = self.m_tCurSelectedEquip.extraInfo.defendStone
        if defendId > 0 then
			defend = GDatatab_item["id_"..defendId].property[1][2]*extreme
			defend = math.floor(defend)
		end
		local hpId = self.m_tCurSelectedEquip.extraInfo.hpStone
        if hpId > 0 then
			hp = GDatatab_item["id_"..hpId].property[1][2]*extreme
			hp = math.floor(hp)
		end

		local fighting = math.ceil(0.75*(hp+4.8*attack+6*defend))
		if fighting > 0 then
			--一些战斗力差1的数值调整
			if fighting == 8 then fighting = 7 end
			if fighting == 33 then fighting = 32 end
			if fighting == 134 then fighting = 133 end
			if fighting == 422 then fighting = 421 end

			if fighting == 9 then fighting = 8 end
			if fighting == 93 then fighting = 92 end
			if fighting == 135 then fighting = 134 end
			if fighting == 324 then fighting = 323 end
			fightTitle:setVisible(true)
			fightText:setVisible(true)
			fightText:setText(fighting)
		end
    end
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
    local stonesId = WZLuaVector_int_:create()
    stonesId:push(tData.playerItemId)
    ProtocolProcessorStrengthen:send_FORGING_Mosaic(self.m_tCurSelectedEquip.playerItemId, stonesId)
end

--@brief  点击限时特惠礼包按钮回调
function WndGemMountingStrengthen:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	初始化镶嵌窗口UI
function WndGemMountingStrengthen:_initGemMountingUI()
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
    
        self:_addExtremeStone(tempData)
	end
end

--@brief	清空攻击镶嵌石
function WndGemMountingStrengthen:_clearAttackStone()
    if self.m_attackStoneLuaObj.m_tItem ~= nil then self.m_attackStoneLuaObj:removeAllChild() end
   	GetElement(self.m_root,"img9AttackBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi.png")
    self:_updateAttackAttribute()
end

--@brief	清空防御镶嵌石
function WndGemMountingStrengthen:_clearDefenseStone()
    if self.m_defenseStoneLuaObj.m_tItem ~= nil then self.m_defenseStoneLuaObj:removeAllChild() end
   	GetElement(self.m_root,"img9DefenseBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi.png")
    self:_updateDefenseAttribute()
end

--@brief	清空生命镶嵌石
function WndGemMountingStrengthen:_clearSpecialStone()
    if self.m_specialStoneLuaObj.m_tItem ~= nil then self.m_specialStoneLuaObj:removeAllChild() end
   	GetElement(self.m_root,"img9SpecialBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi.png")
    self:_updateSpecialAttribute()
end

--@brief	清空共鸣石
function WndGemMountingStrengthen:_clearExtremeStone()
    if self.m_extremeStoneLuaObj.m_tItem ~= nil then self.m_extremeStoneLuaObj:removeAllChild() end
   	GetElement(self.m_root,"img9EBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi.png")
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
    local tipsStr = ""
	local mount = false
    local txtTips = GetElement(self.m_root,"txtAttackTips_WndGemMountingStrengthen",WZUILabelTTF)
	GetElement(self.m_root,"chuanshu1",WZUISpine):setVisible(false)
    if self.m_tCurSelectedEquip ~= nil then
			if self.m_tCurSelectedEquip.extraInfo.attackStone == nil then self.m_tCurSelectedEquip.extraInfo.attackStone = 0 end
        if self.m_tCurSelectedEquip.extraInfo.attackStone > 0 then --已经镶嵌
            tipsStr = LocalStrings.CLICK_TO_REMOVE
			mount = true
    		GetElement(self.m_root,"img9AttackBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi3.png")
			--共鸣特效
			if self.m_tCurSelectedEquip.extraInfo.gongmingStone ~= nil and self.m_tCurSelectedEquip.extraInfo.gongmingStone > 0 then
				GetElement(self.m_root,"chuanshu1",WZUISpine):setVisible(true)
			end
        else
    		GetElement(self.m_root,"img9AttackBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi.png")
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
    local tipsStr = ""
	local mount = false
    local txtTips = GetElement(self.m_root,"txtDefenseTips_WndGemMountingStrengthen",WZUILabelTTF)
	GetElement(self.m_root,"chuanshu2",WZUISpine):setVisible(false)
    if self.m_tCurSelectedEquip ~= nil then
			if self.m_tCurSelectedEquip.extraInfo.defendStone == nil then self.m_tCurSelectedEquip.extraInfo.defendStone = 0 end
        if self.m_tCurSelectedEquip.extraInfo.defendStone > 0 then --已经镶嵌
            tipsStr = LocalStrings.CLICK_TO_REMOVE
			mount = true
    		GetElement(self.m_root,"img9DefenseBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi3.png")
			--共鸣特效
			if self.m_tCurSelectedEquip.extraInfo.gongmingStone ~= nil and self.m_tCurSelectedEquip.extraInfo.gongmingStone > 0 then
				GetElement(self.m_root,"chuanshu2",WZUISpine):setVisible(true)
			end
        else
    		GetElement(self.m_root,"img9DefenseBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi.png")
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
    local tipsStr = ""
	local mount = false
    local txtTips = GetElement(self.m_root,"txtLifeTips_WndGemMountingStrengthen",WZUILabelTTF)
	GetElement(self.m_root,"chuanshu0",WZUISpine):setVisible(false)
    if self.m_tCurSelectedEquip ~= nil then
			if self.m_tCurSelectedEquip.extraInfo.hpStone == nil then self.m_tCurSelectedEquip.extraInfo.hpStone = 0 end
        if self.m_tCurSelectedEquip.extraInfo.hpStone > 0 then --已经镶嵌
            tipsStr = LocalStrings.CLICK_TO_REMOVE
			mount = true
    		GetElement(self.m_root,"img9SpecialBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi3.png")
			--共鸣特效
			if self.m_tCurSelectedEquip.extraInfo.gongmingStone ~= nil and self.m_tCurSelectedEquip.extraInfo.gongmingStone > 0 then
				GetElement(self.m_root,"chuanshu0",WZUISpine):setVisible(true)
			end
        else
    		GetElement(self.m_root,"img9SpecialBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi.png")
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
	if CacheCenter:getPlayerInfo().level < 50 then
		imgAddIcon:setFile("ui/common/common_icon_suo.png")
	else
		imgAddIcon:setFile("ui/common/common_icon_cwjh.png")
	end

    local tipsStr = ""
	local mount = false
    local txtTips = GetElement(self.m_root,"txtExtremeTips_WndGemMountingStrengthen",WZUILabelTTF)
    if self.m_tCurSelectedEquip ~= nil then
		if self.m_tCurSelectedEquip.extraInfo.gongmingStone == nil then self.m_tCurSelectedEquip.extraInfo.gongmingStone = 0 end
        if self.m_tCurSelectedEquip.extraInfo.gongmingStone > 0 then --已经镶嵌
			gongming1:setVisible(true)
            tipsStr = LocalStrings.CLICK_TO_REMOVE
			mount = true
    		GetElement(self.m_root,"img9EBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi3.png")
        else
    		GetElement(self.m_root,"img9EBg_WndGemMountingStrengthen",WZUI9Image):setFile("ui/strengthen/common_scale9duzaodi.png")
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
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function WndGemMountingStrengthen:_adaptLanguage_en()
	GetElement(self.m_root,"fire_WndGem",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.52,0.93))
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
	GetElement(self.m_root,"fire_WndGem",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.52,0.93))
	for i=1,4 do
		local txtNoSetting = GetElement(self.m_root,"txtNoSetting"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtNoSetting:setDimensions(GlobalMethod:CCSize(140))
		local txtTypeName = GetElement(self.m_root,"txtTypeName"..i.."_WndGemMountingStrengthen",WZUILabelTTF)
		txtTypeName:setRelativePosition(GlobalMethod:ccp(0.5,0.3))
	end
	
	local conStoneInfo1 = GetElement(self.m_root,"conStoneInfo1_WndGemMountingStrengthen",WZUIContainer)
	local conDefenseAttr = GetElement(self.m_root,"conDefenseAttr_WndGemmountingStrengthen",WZUIContainer)
	local conSpecialAttr = GetElement(self.m_root,"conSpecialAttr_WndGemmountingStrengthen",WZUIContainer)
	local conMainAttr = GetElement(self.m_root,"conMainAttr_WndGemmountingStrengthen",WZUIContainer)


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
    -- GetElement(self.m_root,"fire_WndGem",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.5,0.02))
    for i=1,3 do
        GetElement(self.m_root,"txtNoSetting"..i.."_WndGemMountingStrengthen",WZUILabelTTF):setFontSize(14)
        GetElement(self.m_root,"txtTypeName"..i.."_WndGemMountingStrengthen",WZUILabelTTF):setFontSize(16)
    end
    GetElement(self.m_root,"fireTitle",WZUILabelTTF):setFontSize(18)
end

function WndGemMountingStrengthen:_adaptLanguage_es(  )
	GetElement(self.m_root,"fire_WndGem",WZUILabelAtlasFont):setRelativePosition(GlobalMethod:ccp(0.52,0.93))
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

-------------------------------------语言适配模块End----------------------------------------
