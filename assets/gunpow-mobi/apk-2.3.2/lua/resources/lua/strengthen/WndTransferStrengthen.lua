--WndTransferStrengthen.lua
--@brief	WndTransferStrengthen的UI模块
--@date		2014/8/16
--@author	zsq
--@note		继承窗口



-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTransferStrengthen:onEnter(element)
	self.m_root = element
	
	--设置控件静态文本
	self:_setUIStaticText()
	
	--初始化转移窗口UI
	self:_initTransferUI()
	
	--更新装备转移信息
	self:_updateTransferInfo()	
	
	--切换聊天频道
	ChangeChatChannel(Chat_Channel_Forged_Inherit)

	--多语言版本界面适配
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTransferStrengthen:onExit(element)
	self:_unInit()
    Teach:isStartTeach("WndTransferStrengthen:onExit")
end

--@brief	转移按钮被按下时调用的函数
--@param	element:转移按钮的UI节点引用
--@note		在这里做转移按钮被按下时的响应操作
function WndTransferStrengthen:onTransfer(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if TeachGroup1.TASK_GO_ID == TeachGroup1.TASK_ID_15 then
        TeachGroup1:endTeachStep({38,5})
    end
	--是否添加了装备1
    if self.m_weapon1LuaObj.m_tItem == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end
    --是否添加了装备2
    if self.m_weapon2LuaObj.m_tItem == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end
    --装备是否同类型
    if self.m_weapon1LuaObj.m_tItem.subtype ~= self.m_weapon2LuaObj.m_tItem.subtype and (tonumber(self.m_weapon1LuaObj.m_tItem.subtype) > 1 or tonumber(self.m_weapon2LuaObj.m_tItem.subtype) > 1) then
        MsgBoxManager:showTipBox(LocalStrings.STRENGTHENINFO1)
        return
    end
    --装备1的强化等级和升星等级是否都大于装备2的
    local eStrongLv1 = self.m_weapon1LuaObj.m_tItem.extraInfo.strongLevel
    local eStarLv1 = self.m_weapon1LuaObj.m_tItem.extraInfo.starLevel
    local eStrongLv2 = self.m_weapon2LuaObj.m_tItem.extraInfo.strongLevel
    local eStarLv2 = self.m_weapon2LuaObj.m_tItem.extraInfo.starLevel
    if eStrongLv1 <= eStrongLv2 and eStarLv1 <= eStarLv2 then
        MsgBoxManager:showTipBox(LocalStrings.EQUIPONE_LESS_THAN_EQUIPTWO)
        return
    end

    --转移石是否足够
    local bagTransferStone = CacheCenter:getPlayerItemCountById(117)
    if bagTransferStone < self.m_needMaterialsNum then
        MsgBoxManager:showConfirmBox(LocalStrings.BUY_TRANSFERSTONE_MESSAGE,self,self.buyTransferStone,nil,nil)
        return
    end

	--保存宝石id
	if self.m_weapon2LuaObj.m_tItem.extraInfo ~= nil and self.m_weapon2LuaObj.m_tItem.extraInfo.hpStone ~= nil then
		self.stone1 = tonumber(self.m_weapon2LuaObj.m_tItem.extraInfo.hpStone)
	else
		self.stone1 = nil
	end
	if self.m_weapon2LuaObj.m_tItem.extraInfo ~= nil and self.m_weapon2LuaObj.m_tItem.extraInfo.attackStone ~= nil then
		self.stone2 = tonumber(self.m_weapon2LuaObj.m_tItem.extraInfo.attackStone)
	else
		self.stone2 = nil
	end
	if self.m_weapon2LuaObj.m_tItem.extraInfo ~= nil and self.m_weapon2LuaObj.m_tItem.extraInfo.defendStone ~= nil then
		self.stone3 = tonumber(self.m_weapon2LuaObj.m_tItem.extraInfo.defendStone)
	else
		self.stone3 = nil
	end
	if self.m_weapon2LuaObj.m_tItem.extraInfo ~= nil and self.m_weapon2LuaObj.m_tItem.extraInfo.gongmingStone ~= nil then
		self.stone4 = tonumber(self.m_weapon2LuaObj.m_tItem.extraInfo.gongmingStone)
	else
		self.stone4 = nil
	end
	--是否橙装转移给紫装
	if self.m_weapon1LuaObj.m_tItem.basicInfo.quality == 4 and self.m_weapon2LuaObj.m_tItem.basicInfo.quality == 3 then
    	--圣光结晶是否足够
    	local bagHoly = CacheCenter:getPlayerItemCountById(182)
    	if tonumber(bagHoly) < tonumber(self.m_needHolyNum) then
    	    --MsgBoxManager:showConfirmBox(LocalStrings.BUY_TRANSFERSTONE_MESSAGE,self,self.buyTransferStone,nil,nil)
			--checkIsOnSale(182)
			WndFastGetItems:show(182)
    	    return
    	end

        MsgBoxManager:showConfirmBox(LocalStrings.STRENGTHEN6,self,self.showAni,nil,nil)
        return
	else
    	--金币是否足够
    	local bagGold = CacheCenter:getMoneyList().gold
    	if bagGold < self.m_nNeedGold then
    	    MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH,self,self.buyGold,nil,nil)
    	--    MsgBoxManager:showTipBox(LocalStrings.GOLD_COIN_NOT_ENOUGH)
    	    return
    	end
	end

	--播放spine动画
	self:showAni()
end

-- --@brief	播放spine动画
-- function WndTransferStrengthen:showAni()
-- 	self.m_root:enableSchedule("showAni1",0.25)
-- 	local spine = GetElement(self.m_root,"spine1",WZUISpine)
--     spine:setVisible(true)
-- 	spine:play("dz_sg_01",false)	
-- end

-- --@brief	播放spine动画
-- function WndTransferStrengthen:showAni1(element,t)
-- 	self.m_root:enableSchedule("showAni2",0.5)
-- 	local spine = GetElement(self.m_root,"spine3",WZUISpine)
--     spine:setVisible(true)
-- 	spine:play("dz_jc_01",false)	
-- end

-- --@brief	播放spine动画
-- function WndTransferStrengthen:showAni2(element,t)
-- 	self.m_root:enableSchedule("showAniFinish",0.65)
-- 	local spine = GetElement(self.m_root,"spine2",WZUISpine)
--     spine:setVisible(true)
-- 	spine:play("dz_sg_02",false)	
-- end

--@brief	播放spine动画
function WndTransferStrengthen:showAni()
	self.m_root:enableSchedule("showAniFinish",0.5)
	local spine = GetElement(self.m_root,"spine3",WZUISpine)
    spine:setVisible(true)
	spine:play("dz_jc_01",false)	
end

--@brief	播放spine动画完成
function WndTransferStrengthen:showAniFinish(element,t)
	element:disableSchedule()
    --发送请求
	if self.m_weapon1LuaObj.m_tItem == nil or self.m_weapon2LuaObj.m_tItem == nil then return end
    ProtocolProcessorStrengthen:send_FORGING_MoveAttribute(self.m_weapon1LuaObj.m_tItem.playerItemId, self.m_weapon2LuaObj.m_tItem.playerItemId)
	WndStrengthen:setHasStringthen(5)
end

--@brief	购买金币框
--@param	nResType:响应类型(超时，确定，取消)
function WndTransferStrengthen:buyGold(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndBuyActivity:showBuyInterface(26)
	end
end
--@brief    购买转移石
function WndTransferStrengthen:buyTransferStone(element,btnTag)
    if btnTag == MSGBOXTYPE_CONFIRM then
        --checkIsOnSale(117,LocalStrings.ITEMNOTSALE)
		WndFastGetItems:show(117)
    end
end

--@brief    购买成功后调用
function WndTransferStrengthen:buyCallBack()
    local bagTransStoneNum = CacheCenter:getPlayerItemCountById(117) --背包中升星石数量
    --转移石
    local txtBagStone = GetElement(self.m_root,"txtBagTransStoneNum_WndTransferStrengthen",WZUILabelTTF)
    local bagStoneStr = string.format("%d)",bagTransStoneNum)
    txtBagStone:setText(bagStoneStr)
end

--@brief	装备1框被点击时的回调函数
--@param	element:装备1框内置按钮的UI节点引用
--@note		在这里做装备1框被点击时的响应操作
function WndTransferStrengthen:onWeapon1Clicked(tItemTable, nTag, tData)
	--被点击时的缩放效果
	tItemTable:_runSelectedAction()
    WndSelectTipsStrengthen:showSelectTips(3)


	do return end
    local tEquip = nil
    --没有装备：
    if self.m_weapon1LuaObj.m_tItem == nil then
        --添加推荐装备
        tEquip = WndStrengthen:getRecommendEquip()
    end
    WndStrengthen:updateCellEquip(tEquip)
end

--@brief	装备2框被点击时的回调函数
--@param	element:装备2框内置按钮的UI节点引用
--@note		在这里做装备2框被点击时的响应操作
function WndTransferStrengthen:onWeapon2Clicked(tItemTable, nTag, tData)
    WZLog("WndTransferStrengthen:onWeapon2Clicked")
	--被点击时的缩放效果
	tItemTable:_runSelectedAction()
    if self.m_weapon1LuaObj.m_tItem == nil then return end
    if self.m_weapon2LuaObj.m_tItem == nil then
        WndSelectTipsStrengthen:showSelectTips(2,self.m_weapon1LuaObj.m_tItem)
    else
        self.m_weapon2LuaObj:removeAllChild()
        WndStrengthen:updateEquipList()
        self:_updateEquipInfo2()
		self:setEquip2InfoVisible(false)
   		-- GetElement(self.m_weapon2Element, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
		--隐藏箭头
	--	GetElement(self.m_root,"imgArrow_WndTransfer",WZUIImage):setVisible(false)
    end
end

--@brief	转移成功后的回调用函数
--@note		转移成功后的回调用函数
function WndTransferStrengthen:onTransferSuccess()
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
	-- --隐藏箭头
	-- GetElement(self.m_root,"imgArrow_WndTransfer",WZUIImage):setVisible(false)
	self:setEquip2InfoVisible(false)
	if self.m_weapon1LuaObj.m_tItem == nil or self.m_weapon2LuaObj.m_tItem == nil then return end
	--修改装备信息
	local weapon1Level = self.m_weapon1LuaObj.m_tItem.extraInfo.strongLevel
	local weapon1StarLevel = self.m_weapon1LuaObj.m_tItem.extraInfo.starLevel
	local weapon2Level = self.m_weapon2LuaObj.m_tItem.extraInfo.strongLevel
	local weapon2StarLevel = self.m_weapon2LuaObj.m_tItem.extraInfo.starLevel
	local weaponLevel,weaponStarLevel
	weaponLevel = weapon1Level
	weaponStarLevel = weapon1StarLevel
	if weapon2Level > weapon1Level then
		weaponLevel = weapon2Level
	end
	if weapon2StarLevel > weapon1StarLevel then
		weaponStarLevel = weapon2StarLevel
	end

	local attackStone = self.m_weapon1LuaObj.m_tItem.extraInfo and self.m_weapon1LuaObj.m_tItem.extraInfo.attackStone or 0
	local defendStone = self.m_weapon1LuaObj.m_tItem.extraInfo and self.m_weapon1LuaObj.m_tItem.extraInfo.defendStone or 0
	local hpStone = self.m_weapon1LuaObj.m_tItem.extraInfo and self.m_weapon1LuaObj.m_tItem.extraInfo.hpStone or 0
	local gongmingStone = self.m_weapon1LuaObj.m_tItem.extraInfo and self.m_weapon1LuaObj.m_tItem.extraInfo.gongmingStone or 0

	self.m_weapon1LuaObj.m_tItem.extraInfo.strongLevel = 0
	self.m_weapon1LuaObj.m_tItem.extraInfo.starLevel = 0
	self.m_weapon1LuaObj.m_tItem.extraInfo.missTimes = 0
	self.m_weapon1LuaObj.m_tItem.extraInfo.attackStone = 0
	self.m_weapon1LuaObj.m_tItem.extraInfo.defendStone = 0
	self.m_weapon1LuaObj.m_tItem.extraInfo.hpStone = 0
	self.m_weapon1LuaObj.m_tItem.extraInfo.gongmingStone = 0

	self.m_weapon2LuaObj.m_tItem.extraInfo.strongLevel = weaponLevel
	self.m_weapon2LuaObj.m_tItem.extraInfo.starLevel = weaponStarLevel
	self.m_weapon2LuaObj.m_tItem.extraInfo.attackStone = attackStone
	self.m_weapon2LuaObj.m_tItem.extraInfo.defendStone = defendStone
	self.m_weapon2LuaObj.m_tItem.extraInfo.hpStone = hpStone
	self.m_weapon2LuaObj.m_tItem.extraInfo.gongmingStone = gongmingStone

	if self.m_weapon1LuaObj.m_tItem.basicInfo.quality == 4 and self.m_weapon2LuaObj.m_tItem.basicInfo.quality == 3 then
		--self.m_weapon1LuaObj.m_tItem.basicInfo.quality, self.m_weapon2LuaObj.m_tItem.basicInfo.quality = self.m_weapon2LuaObj.m_tItem.basicInfo.quality, self.m_weapon1LuaObj.m_tItem.basicInfo.quality
		self.m_weapon1LuaObj.m_tItem.basicInfo.quality = 3
		self.m_weapon2LuaObj.m_tItem.basicInfo.quality = 4
	end

	--刷新显示效果
	self.m_weapon2LuaObj:setCellGoodItem(self.m_weapon2LuaObj.m_tItem,15)
    WZLog("WndTransferStrengthen:onTransferSuccess")
    WndStrengthen:updateCellEquip(self.m_weapon1LuaObj.m_tItem,4)
	
	--显示转移结果
	PopupResult("ui/common/common_icon_jcz.png")

	--弹出卸下的宝石
	local stoneIds = {}
	local stoneNums = {}
	for i=1,4 do
		if self["stone"..i] ~= nil and self["stone"..i] ~= 0 then
			table.insert(stoneIds,self["stone"..i])
			table.insert(stoneNums,1)
		end
	end
	if #stoneIds > 0 then
		WZLog("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhkkkkkkkkkkkkkkkkkkkkkk",Serialize(stoneIds))
		WndRewardShow:showById(stoneIds,stoneNums)
	end

	self.m_bIsTransfering = false
end

--@brief 	清理界面
--@note 	切换到转移界面时清理界面
function WndTransferStrengthen:clear()
	self.m_weapon1LuaObj:removeAllChild()
	self.m_weapon2LuaObj:removeAllChild()
	--更新转移按钮状态
	self:_updateTransferBtnStatus()
	--更新装备转移信息
	self:_updateTransferInfo()
end

--@brief    添加装备到cell
--@param    tEquip:装备
--@author   zsq
function WndTransferStrengthen:addEquipToCell(tEquip,tag)
    local tag = tag or 0
    self.m_tCurSelectedEquip1 = tEquip
    if tEquip == nil then
        self.m_weapon1LuaObj:removeAllChild()
        self.m_weapon2LuaObj:removeAllChild()
        WndStrengthen:updateEquipList()
        self.m_weapon2LuaObj:lockCell()
		self:setEquip1InfoVisible(false)
        self:setEquip2InfoVisible(false)
   		-- GetElement(self.m_weapon1Element, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
    else
        self.m_weapon1LuaObj:setCellGoodItem(tEquip,15) --添加到cell
        if tag ~= 1 then
            self.m_weapon2LuaObj:removeAllChild()
            WndStrengthen:updateEquipList()
        end
        self.m_weapon2LuaObj:unLockCell()
		self:setEquip1InfoVisible(true)
        self:setEquip2InfoVisible(false)
   		-- GetElement(self.m_weapon1Element, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
    end

    self:_updateTransferInfo()
end

--@brief	设置装备1信息是否可见
function WndTransferStrengthen:setEquip1InfoVisible(bFlag)
    GetElement(self.m_root, "conEquipCurInfo1_WndTransferStrengthen", WZUIContainer):setVisible(bFlag)
    -- GetElement(self.m_root, "conEquipAfterInfo1_WndTransferStrengthen", WZUIContainer):setVisible(bFlag)
	-- GetElement(self.m_root,"arrowEquip1",WZUIImage):setVisible(bFlag)
	-- GetElement(self.m_root,"txtDesc1_WndTransferStrengthen",WZUILabelTTF):setVisible(not bFlag)
end

--@brief	设置装备2信息是否可见
function WndTransferStrengthen:setEquip2InfoVisible(bFlag)
    -- GetElement(self.m_root, "conEquipCurInfo2_WndTransferStrengthen", WZUIContainer):setVisible(bFlag)
    GetElement(self.m_root, "conEquipAfterInfo2_WndTransferStrengthen", WZUIContainer):setVisible(bFlag)
	-- GetElement(self.m_root,"arrowEquip2",WZUIImage):setVisible(bFlag)
	-- GetElement(self.m_root,"txtDesc2_WndTransferStrengthen",WZUILabelTTF):setVisible(not bFlag)
end

--@brief     选择装备确定后回调
--@param     tEquip:选择的装备
function WndTransferStrengthen:addEquipToCell2(tEquip)
    WndStrengthen:updateEquipList(tEquip)
    self.m_weapon2LuaObj:setCellGoodItem(tEquip,15) --添加到cell
    self:_updateEquipInfo2()
	self:setEquip2InfoVisible(true)
   	-- GetElement(self.m_weapon2Element, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
	self:setChengCost()
end

--@brief	设置橙装消耗
function WndTransferStrengthen:setChengCost()
	WZLog("WndTransferStrengthen:setChengCost",CacheCenter:getGameParam().orangeEquiMoveAttrCost)
    if self.m_weapon1LuaObj.m_tItem == nil or self.m_weapon2LuaObj.m_tItem == nil then
		return
	end
	if self.m_weapon1LuaObj.m_tItem.basicInfo.quality == 4 and self.m_weapon2LuaObj.m_tItem.basicInfo.quality == 3 then
		local orangeEquiMoveAttrToPurpleCost = CacheCenter:getGameParam().orangeEquiMoveAttrToPurpleCost
		if orangeEquiMoveAttrToPurpleCost == nil or orangeEquiMoveAttrToPurpleCost == "" then return end
		local id, num = SplitItemString(orangeEquiMoveAttrToPurpleCost)
    	GetElement(self.m_root,"txtCost_WndTransferStrengthen",WZUILabelTTF):setText(num[1])
		GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setFile(GDatatab_item["id_"..id[1]].icon)
		GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setScale(0.5)
		self.m_needHolyNum = num[1]
	elseif self.m_weapon1LuaObj.m_tItem.basicInfo.quality == 4 and self.m_weapon2LuaObj.m_tItem.basicInfo.quality == 4 then
		local orangeEquiMoveAttrToOrangeCost = CacheCenter:getGameParam().orangeEquiMoveAttrToOrangeCost
		if orangeEquiMoveAttrToOrangeCost == nil or orangeEquiMoveAttrToOrangeCost == "" then return end
		local id, num = SplitItemString(orangeEquiMoveAttrToOrangeCost)
    	GetElement(self.m_root,"txtCost_WndTransferStrengthen",WZUILabelTTF):setText(num[1])
		GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setFile(GDatatab_item["id_"..id[1]].icon)
		GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setScale(0.5)
		self.m_needHolyNum = num[1]
	else
    	GetElement(self.m_root,"txtCost_WndTransferStrengthen",WZUILabelTTF):setText(self.m_nNeedGold)
		GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setFile(GDatatab_item["id_2"].icon)
		GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setScale(0.5)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置控件静态文本
--@note		设置控件静态文本
function WndTransferStrengthen:_setUIStaticText()
    --转移花费、拥有、转移
    GetElement(self.m_root,"txtTransCostWord_WndTransferStrengthen",WZUILabelTTF):setText(LocalStrings.TRANSFER_COST..":")
    GetElement(self.m_root,"txtOwnWord_WndTransferStrengthen",WZUILabelTTF):setText("("..LocalStrings.OWN)
    if ProjConfig.LANGUAGE == "ug" then
    	GetElement(self.m_root,"txtOwnWord_WndTransferStrengthen",WZUILabelTTF):setText(LocalStrings.OWN)
    end
    for i=1,3,1 do
        local sName = string.format("txtTransfer%d_WndTransferStrengthen", i)
        local txtTransfer = self.m_root:getChildElement(sName)
        if txtTransfer ~= nil then
            WZUILabelTTF:luaTo(txtTransfer):setText(LocalStrings.TRANSFER)
        end
    end
end

--@brief	初始化转移窗口UI
--@note		初始化转移窗口UI
function WndTransferStrengthen:_initTransferUI()
    --装备1
    local conEquip1 = self.m_root:getChildElement("conEquipIcon1_WndTransferStrengthen")
    if conEquip1 ~= nil then
        self.m_weapon1Element, self.m_weapon1LuaObj = CellGoodItem:createElement()
        if self.m_weapon1Element ~= nil and self.m_weapon1LuaObj ~= nil then
            conEquip1:addChild(self.m_weapon1Element,-1)
            self.m_weapon1Element:setScale(1)
   			GetElement(self.m_weapon1Element, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
   			GetElement(self.m_weapon1Element, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
   			GetElement(self.m_weapon1Element, "btnImg1_CellGoodItem", WZUI9Image):setVisible(false)
   			GetElement(self.m_weapon1Element, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
        end
        --装备1被点击时回调
        self.m_weapon1LuaObj:setItemClickFun(self, self.onWeapon1Clicked)
    end
    --装备2
    local conEquip2 = self.m_root:getChildElement("conEquipIcon2_WndTransferStrengthen")
    if conEquip2 ~= nil then
        self.m_weapon2Element, self.m_weapon2LuaObj = CellGoodItem:createElement()
        if self.m_weapon2Element ~= nil and self.m_weapon2LuaObj ~= nil then
            conEquip2:addChild(self.m_weapon2Element,-1)
            self.m_weapon2Element:setScale(1)
   			GetElement(self.m_weapon2Element, "btnImg_CellGoodItem", WZUI9Image):setVisible(false)
   			GetElement(self.m_weapon2Element, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
   			GetElement(self.m_weapon2Element, "btnImg1_CellGoodItem", WZUI9Image):setVisible(false)
   			GetElement(self.m_weapon2Element, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
        end
        --装备2被点击时回调
        self.m_weapon2LuaObj:setItemClickFun(self, self.onWeapon2Clicked)
        self.m_weapon2LuaObj:lockCell()
    end
end

--@brief	更新转移按钮状态
--@note		更新转移按钮状态
function WndTransferStrengthen:_updateTransferBtnStatus()
	local bFlag = false
	if (self.m_weapon1LuaObj.m_tItem ~= nil) and (self.m_weapon2LuaObj.m_tItem ~= nil) then
		local bFlag1 = self.m_weapon1LuaObj.m_tItem.extraInfo.strongLevel > self.m_weapon2LuaObj.m_tItem.extraInfo.strongLevel
		local bFlag2 = self.m_weapon1LuaObj.m_tItem.extraInfo.starLevel > self.m_weapon2LuaObj.m_tItem.extraInfo.starLevel
		if bFlag1 or bFlag2 then
			bFlag = true
		end
	end
	
	local btnTransfer = self.m_root:getChildElement("btnTransfer_WndTransferStrengthen")
	if btnTransfer ~= nil then
		btnTransfer:setTouchEnable(bFlag)
	end
    
    Teach:isStartTeach("WndTransferStrengthen:_updateTransferBtnStatus")
end

--@brief 	更新装备转移信息
--@note 	更新装备转移信息
function WndTransferStrengthen:_updateTransferInfo()
    self:_updateEquipInfo1()
    self:_updateEquipInfo2()
end

--@brief    更新装备1的信息
--@author   hyq
function WndTransferStrengthen:_updateEquipInfo1()
    --装备1：当前/转移后-强化等级、升星等级、属性加成
    local eCurStrengthLv1 = ""
    local eCurStarLv1 = ""
    local eAfterStrengthLv1 = ""
    local eAfterStarLv1 = ""
    local addEquipStr1 = ""
    local equipName1 = ""
    local costGold = 0
    local costTransferStone = 0
    local bagTransferStone = CacheCenter:getPlayerItemCountById(117)
    local bagGold = CacheCenter:getMoneyList().gold
	local eQuality
    if self.m_weapon1LuaObj.m_tItem ~= nil then
        --装备名
        equipName1 = self.m_weapon1LuaObj.m_tItem.basicInfo.name
        --强化等级
        local eStrLv1 = self.m_weapon1LuaObj.m_tItem.extraInfo.strongLevel
        eCurStrengthLv1 = string.format(LocalStrings.LV.."%d",eStrLv1)
        eAfterStrengthLv1 = string.format(LocalStrings.LV.."%d",0)
        --升星等级
        local eStarLv1 = self.m_weapon1LuaObj.m_tItem.extraInfo.starLevel
        eCurStarLv1 = string.format("%d",eStarLv1)
        eAfterStarLv1 = string.format("%d",0)
        --总属性 = 基础属性 + 升星属性 + 强化属性
        local property = self.m_weapon1LuaObj.m_tItem.basicInfo.property
        eQuality = self.m_weapon1LuaObj.m_tItem.basicInfo.quality
		local equipType = self.m_weapon1LuaObj.m_tItem.basicInfo.main_type == 43 and 2 or 1
        local attrName1 = ATTR_TITLE[property[1][1]]
        local baseAttr1 = property[1][2]
        local eStrAttr1 = 0
        local eStarAttr1 = 0
        if eStrLv1 > 0 then
            eStrAttr1 = WndIntensifyStrengthen:getStrengthenTableInfo(eQuality,eStrLv1,property[1][1],equipType).attrAdd
        end
        if eStarLv1 > 0 then
        	if self.m_weapon1LuaObj.m_tItem.basicInfo.main_type == 43 then
				for k,v in pairs(GDatatab_pet_stars_up) do
					if (v.quality == eQuality or v.quality == -1 and eQuality < 4) and v.level == eStarLv1 then
						eStarAttr1 = property[1][2] * (v.property_rate/10000)
					end
				end
        	else
	        	if GDatatab_stars_up["id_"..eStarLv1] then
		            eStarAttr1 = property[1][2] * (GDatatab_stars_up["id_"..eStarLv1].property_rate/10000)
		        end
		    end
        end
        local totalAttr1 = self.m_weapon1LuaObj.m_tItem.extraInfo[tostring(property[1][1])]
		baseAttr1 = self.m_weapon1LuaObj.m_tItem.basicInfo.property[1][2]--totalAttr1 - eStrAttr1 - eStarAttr1
        
        --消耗金币
        costGold = (eStarLv1 + math.floor(eStrLv1/5) + 1) * 1000
        --消耗转移石 (升星等级 + 强化等级/5)*1 + 1
        costTransferStone = (eStarLv1 + math.floor(eStrLv1/5)) * 1 + 1
        
        GetElement(self.m_root,"imgAddIcon1_WndTransferStrengthen",WZUIImage):setVisible(false)
        --当前属性加成
        GetElement(self.m_root, "txtCurAttrAddName_WndTransferStrengthen", WZUILabelTTF):setText(attrName1)
        GetElement(self.m_root, "txtCurAttrAddValue_WndTransferStrengthen", WZUILabelTTF):setText("+" .. totalAttr1)
        --转移后属性加成
        -- GetElement(self.m_root, "txtAfterAttrAddName_WndTransferStrengthen", WZUILabelTTF):setText(attrName1)
        -- GetElement(self.m_root, "txtAfterAttrAddValue_WndTransferStrengthen", WZUILabelTTF):setText("+" .. baseAttr1)
    else
        GetElement(self.m_root,"imgAddIcon1_WndTransferStrengthen",WZUIImage):setVisible(true)
    end
    self.m_nNeedGold = costGold
    self.m_needMaterialsNum = costTransferStone
 --    --获取控件并初始化数据
 --    GetElement(self.m_root,"txtEquipName1_WndTransferStrengthen",WZUILabelTTF):setText(equipName1)   --装备名
	-- if eQuality ~= nil then
 --   		GetElement(self.m_root,"txtEquipName1_WndTransferStrengthen",WZUILabelTTF):setColor(QUALITYCOLOR[eQuality])
	-- end

	if eQuality ~= nil then
		for i=1,4 do
			local armature = GetElement(self.m_root,"armature1_"..i.."_WndStrengthen",WZArmature)
			armature:setVisible(i==eQuality)
		end
	end

    GetElement(self.m_root,"txtCurStrongLv1_WndTransferStrengthen",WZUILabelTTF):setText(eCurStrengthLv1)   --当前强化等级
    GetElement(self.m_root,"txtCurStarLv1_WndTransferStrengthen",WZUILabelTTF):setText(eCurStarLv1)   --当前升星等级
    
    -- GetElement(self.m_root,"txtAfterStrongLv1_WndTransferStrengthen",WZUILabelTTF):setText(eAfterStrengthLv1)   --转移后强化等级
    -- GetElement(self.m_root,"txtAfterStarLv1_WndTransferStrengthen",WZUILabelTTF):setText(eAfterStarLv1)   --转移后升星等级

    --消耗金币
    local txtCostGold = GetElement(self.m_root,"txtCost_WndTransferStrengthen",WZUILabelTTF)
	GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setFile(GDatatab_item["id_2"].icon)
    txtCostGold:setText(costGold)
    --转移石
    local txtCostStone = GetElement(self.m_root,"txtCostTransStoneNum_WndTransferStrengthen",WZUILabelTTF)
    txtCostStone:setText(costTransferStone)

    local txtBagStone = GetElement(self.m_root,"txtBagTransStoneNum_WndTransferStrengthen",WZUILabelTTF)
    local bagStoneStr = string.format("%d)",bagTransferStone)
    if ProjConfig.LANGUAGE == "ug" then
    	bagStoneStr = string.format("%d",bagTransferStone)
    end
    txtBagStone:setText(bagStoneStr)
    -- --武器技能
    -- self:_updateWeaponOneSkill(self.m_weapon1LuaObj.m_tItem)


    --光圈
	local colorIndex = self.m_weapon1LuaObj.m_tItem and self.m_weapon1LuaObj.m_tItem.basicInfo.quality or 1
	for i=1,4 do
		local armature = GetElement(self.m_root,"armature1_"..i.."_WndStrengthen",WZArmature)
		armature:setVisible(i==colorIndex)
	end

		--橙装消耗圣灵材料
		if self.m_weapon1LuaObj.m_tItem ~= nil and self.m_weapon1LuaObj.m_tItem.basicInfo.quality == 4 then
		local orangeEquiMoveAttrToPurpleCost = CacheCenter:getGameParam().orangeEquiMoveAttrToPurpleCost
		if orangeEquiMoveAttrToPurpleCost ~= nil and orangeEquiMoveAttrToPurpleCost ~= "" then
		local id, num = SplitItemString(orangeEquiMoveAttrToPurpleCost)
    	GetElement(self.m_root,"txtCost_WndTransferStrengthen",WZUILabelTTF):setText(num[1])
		GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setFile(GDatatab_item["id_"..id[1]].icon)
		GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setScale(0.5)
		self.m_needHolyNum = num[1]
		end
		end
end

--@brief    更新装备2的信息
--@author   hyq
function WndTransferStrengthen:_updateEquipInfo2()
    --装备2：当前/转移后-强化等级、升星等级、属性加成
    local eCurStrengthLv2 = ""
    local eCurStarLv2 = ""
    local eCurAttrAdd2 = ""
    local eAfterStrengthLv2 = ""
    local eAfterStarLv2 = ""
    local eAfterAttrAdd2 = ""
    local addEquipStr2 = ""
    local equipName2 = ""
	local eQuality
    if self.m_weapon2LuaObj.m_tItem ~= nil then
        --装备名
        equipName2 = self.m_weapon2LuaObj.m_tItem.basicInfo.name
        --强化等级
        local eStrLv2 = self.m_weapon2LuaObj.m_tItem.extraInfo.strongLevel
        local e1StrLv = self.m_weapon1LuaObj.m_tItem.extraInfo.strongLevel
        local e2AfterStrLv = eStrLv2
        if e1StrLv > eStrLv2 then
            e2AfterStrLv = e1StrLv
        end
        eCurStrengthLv2 = string.format(LocalStrings.LV.."%d",eStrLv2)
        eAfterStrengthLv2 = string.format(LocalStrings.LV.."%d",e2AfterStrLv)
        --升星等级
        local eStarLv2 = tonumber(self.m_weapon2LuaObj.m_tItem.extraInfo.starLevel)
        local e1StarLv = tonumber(self.m_weapon1LuaObj.m_tItem.extraInfo.starLevel)
        local e2AfterStarLv = eStarLv2
        if e1StarLv > eStarLv2 then
            e2AfterStarLv = e1StarLv
        end
        eCurStarLv2 = string.format("%d",eStarLv2)
        eAfterStarLv2 = string.format("%d",e2AfterStarLv)
        --总属性 = 基础属性 + 升星属性 + 强化属性
		local basicInfo = self.m_weapon2LuaObj.m_tItem.basicInfo
		local equipType = self.m_weapon2LuaObj.m_tItem.basicInfo.main_type == 43 and 2 or 1
		local upAttr = 0
		if self.m_weapon1LuaObj.m_tItem.basicInfo.quality == 4 and self.m_weapon2LuaObj.m_tItem.basicInfo.quality == 3 then
			upAttr = basicInfo.property[1][2]
			basicInfo = GDatatab_item["id_"..(basicInfo.id%10000 + 30000)]
			upAttr = basicInfo.property[1][2] - upAttr
		end
		WZLog("物品2ID",basicInfo.id,upAttr)
        local property = basicInfo.property
        local attrName2 = ATTR_TITLE[property[1][1]]
        local baseAttr2 = property[1][2]
        eQuality = basicInfo.quality
        local attrType = property[1][1]
        local eStrAttr2 = 0
        local eStarAttr2 = 0
        local e2StrAttr = 0
        local e2StarAttr = 0
        if eStrLv2 > 0 then
            eStrAttr2 = WndIntensifyStrengthen:getStrengthenTableInfo(eQuality,eStrLv2,attrType,equipType).attrAdd
        end
        if eStarLv2 > 0 then
			if self.m_weapon2LuaObj.m_tItem.basicInfo.main_type == 43 then
				for k,v in pairs(GDatatab_pet_stars_up) do
					if (v.quality == eQuality or v.quality == -1 and eQuality < 4) and v.level == eStarLv2 then
						eStarAttr2 = property[1][2] * (v.property_rate/10000)
					end
				end
			else
	        	if GDatatab_stars_up["id_"..eStarLv2] then
		            eStarAttr2 = property[1][2] * (GDatatab_stars_up["id_"..eStarLv2].property_rate/10000)
		        end
		    end
        end
        if e2AfterStrLv > 0 then
            e2StrAttr = WndIntensifyStrengthen:getStrengthenTableInfo(eQuality,e2AfterStrLv,attrType,equipType).attrAdd
        end
        if e2AfterStarLv > 0 then
        	if self.m_weapon2LuaObj.m_tItem.basicInfo.main_type == 43 then
				for k,v in pairs(GDatatab_pet_stars_up) do
					if (v.quality == eQuality or v.quality == -1 and eQuality < 4) and v.level == e2AfterStarLv then
						e2StarAttr = (property[1][2] + e2StrAttr) * (v.property_rate/10000)
					end
				end
        	else
	        	if GDatatab_stars_up["id_"..e2AfterStarLv] then
		            e2StarAttr = (property[1][2] + e2StrAttr) * (GDatatab_stars_up["id_"..e2AfterStarLv].property_rate/10000)
		        end
		    end
        end

        local totalAttr2 = self.m_weapon2LuaObj.m_tItem.extraInfo[tostring(property[1][1])]
        local totalAttrAfter2 = totalAttr2 + math.ceil(e2StrAttr) + math.ceil(e2StarAttr) - math.ceil(eStrAttr2) - math.ceil(eStarAttr2)
		if self.m_weapon1LuaObj.m_tItem.basicInfo.quality == 4 and self.m_weapon2LuaObj.m_tItem.basicInfo.quality == 3 then
			totalAttrAfter2 = totalAttrAfter2 + upAttr
		end
        eCurAttrAdd2 = string.format([[<T C="233,166,62" S="20" P="0">%s</T><T C="255,236,193" S="20" P="0">+%d</T>]],attrName2,totalAttr2)
        eAfterAttrAdd2 = string.format([[<T C="233,166,62" S="20" P="0">%s</T><T C="99,255,95" S="20" P="0">+%d</T>]],attrName2,totalAttrAfter2)
        
        GetElement(self.m_root,"imgAddIcon2_WndTransferStrengthen",WZUIImage):setVisible(false)
        -- --继承前的属性加成
        -- GetElement(self.m_root, "txtCurAttrAdd2Name_WndTransferStrengthen", WZUILabelTTF):setText(attrName2)
        -- GetElement(self.m_root, "txtCurAttrAdd2Value_WndTransferStrengthen", WZUILabelTTF):setText("+" .. totalAttr2)
        --继承后的属性加成
        GetElement(self.m_root, "txtAfterAttrAdd2Name_WndTransferStrengthen", WZUILabelTTF):setText(attrName2)
        GetElement(self.m_root, "txtAfterAttrAdd2Value_WndTransferStrengthen", WZUILabelTTF):setText("+" .. math.floor(totalAttrAfter2))
    end
 --    --获取控件并初始化数据
 --    GetElement(self.m_root,"txtEquipName2_WndTransferStrengthen",WZUILabelTTF):setText(equipName2)   --装备名
	-- if eQuality ~= nil then
 --   		GetElement(self.m_root,"txtEquipName2_WndTransferStrengthen",WZUILabelTTF):setColor(QUALITYCOLOR[eQuality])
	-- end

    -- GetElement(self.m_root,"txtCurStrongLv2_WndTransferStrengthen",WZUILabelTTF):setText(eCurStrengthLv2)   --当前强化等级
    -- GetElement(self.m_root,"txtCurStarLv2_WndTransferStrengthen",WZUILabelTTF):setText(eCurStarLv2)   --当前升星等级

    GetElement(self.m_root,"txtAfterStrongLv2_WndTransferStrengthen",WZUILabelTTF):setText(eAfterStrengthLv2)   --转移后强化等级
    GetElement(self.m_root,"txtAfterStarLv2_WndTransferStrengthen",WZUILabelTTF):setText(eAfterStarLv2)   --转移后升星等级

    if self.m_weapon1LuaObj.m_tItem ~= nil and self.m_weapon2LuaObj.m_tItem == nil then
        addEquipStr2 = LocalStrings.PLEASE_SELECT_TRANSFER_EQUIP
        GetElement(self.m_root,"imgAddIcon2_WndTransferStrengthen",WZUIImage):setVisible(true)
    end
	 
    if self.m_weapon1LuaObj.m_tItem ~= nil and self.m_weapon2LuaObj.m_tItem ~= nil 
		and self.m_weapon1LuaObj.m_tItem.basicInfo.quality == 4 
		and self.m_weapon2LuaObj.m_tItem.basicInfo.quality == 3 then
    	GetElement(self.m_root,"txtAfterStarLv2_WndTransferStrengthen",WZUILabelTTF):setText(self.m_weapon1LuaObj.m_tItem.extraInfo.starLevel)--转移后升星等级
	end

    if self.m_weapon1LuaObj.m_tItem == nil then
        self.m_weapon2LuaObj:lockCell()
        GetElement(self.m_root,"imgAddIcon2_WndTransferStrengthen",WZUIImage):setVisible(false)
    else
        self.m_weapon2LuaObj:unLockCell()
    end
    -- --武器技能
    -- self:_updateWeaponTwoSkill(self.m_weapon1LuaObj.m_tItem, self.m_weapon2LuaObj.m_tItem)


    --光圈
	local colorIndex = self.m_weapon2LuaObj.m_tItem and self.m_weapon2LuaObj.m_tItem.basicInfo.quality or 1
	for i=1,4 do
		local armature = GetElement(self.m_root,"armature2_"..i.."_WndStrengthen",WZArmature)
		armature:setVisible(i==colorIndex)
	end
end

--@brief    更新武器1的技能
function WndTransferStrengthen:_updateWeaponOneSkill(tWeapon1)
    -- body
    WZLog("***** _updateWeaponOneSkill ***** ")
    --判断是否为武器，不是武器，直接返回
    local conCurSkills1 = GetElement(self.m_root, "conCurSkills1_WndTransferStrengthen", WZUIContainer)
    conCurSkills1:setVisible(false)
    local conAfterSkills1 = GetElement(self.m_root, "conAfterSkills1_WndTransferStrengthen", WZUIContainer)
    conAfterSkills1:setVisible(false)
    local conEquipCurInfo1 = GetElement(self.m_root, "conEquipCurInfo1_WndTransferStrengthen", WZUIContainer)
    local conEquipAfterInfo1 = GetElement(self.m_root, "conEquipAfterInfo1_WndTransferStrengthen", WZUIContainer)
    if tWeapon1 == nil then return end
    local extraInfo = tWeapon1.extraInfo
    if extraInfo.weaponskill == nil or extraInfo.weaponskill == "" then return end
    local skillIdList = SplitStringWithSeparator(extraInfo.weaponskill, "|")
    WZLog("WndTransferStrengthen:loadWeaponSkills", Serialize(skillIdList), #skillIdList)
    if skillIdList == nil or #skillIdList == 0 then return end

    conEquipCurInfo1:setRelativePosition(GlobalMethod:ccp(0.46, 0.4))
    conEquipAfterInfo1:setRelativePosition(GlobalMethod:ccp(0.82, 0.4))
    conCurSkills1:setVisible(false)
    conAfterSkills1:setVisible(false)
    
    --武器当前的技能
    for i = 1, 5 do
        local sConName = string.format("conCSkill%d_WndSophisticStrengthen", i)
        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)
        if conSkill ~= nil then
            conSkill:removeAllChildrenWithCleanup(true)
        end
    end
    for i = 1, #skillIdList do
    	if skillIdList[i] and tonumber(skillIdList[i]) ~= -1 then
	        local sConName = string.format("conCSkill%d_WndSophisticStrengthen", i)
	        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)
	        if conSkill ~= nil then
	            local cellElement = WZUISystem:getInstance():createElement("conSkill_WndTransferStrengthen")
	            if cellElement ~= nil then
	                cellElement:setVisible(true)
	                local tData = GDatatab_skill["id_" .. skillIdList[i]]
	                self:_setWeaponSkillData(cellElement, tData.icon, tData.lv_icon)
	                cellElement:setTag(i - 1)
	                conSkill:addChild(cellElement)
	            end
	        end
	    end
    end
    --武器被继承后的技能
    local baseSkillList = tWeapon1.basicInfo.power_skill[1]
    for i = 1, 5 do
        local sConName = string.format("conASkill%d_WndSophisticStrengthen", i)
        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)
        if conSkill ~= nil then
            conSkill:removeAllChildrenWithCleanup(true)
        end
    end
    for i = 1, #baseSkillList do
        local sConName = string.format("conASkill%d_WndSophisticStrengthen", i)
        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)
        if conSkill ~= nil then
            local cellElement = WZUISystem:getInstance():createElement("conSkill_WndTransferStrengthen")
            if cellElement ~= nil then
                cellElement:setVisible(true)
                local tData = GDatatab_skill["id_" .. baseSkillList[i]]
                self:_setWeaponSkillData(cellElement, tData.icon, tData.lv_icon)
                cellElement:setTag(i - 1)
                conSkill:addChild(cellElement)
            end
        end
    end
end

--@brief    更新武器2的技能
--@param    tWeapon1:被继承的武器
--@param    tWeapon2:要继承的武器
function WndTransferStrengthen:_updateWeaponTwoSkill(tWeapon1, tWeapon2)
    -- body
    WZLog("***** _updateWeaponTwoSkill ***** ")
    --判断是否为武器，不是武器，直接返回
    local conCurSkills2 = GetElement(self.m_root, "conCurSkills2_WndTransferStrengthen", WZUIContainer)
    conCurSkills2:setVisible(false)
    local conAfterSkills2 = GetElement(self.m_root, "conAfterSkills2_WndTransferStrengthen", WZUIContainer)
    conAfterSkills2:setVisible(false)
    local conEquipCurInfo2 = GetElement(self.m_root, "conEquipCurInfo2_WndTransferStrengthen", WZUIContainer)
    local conEquipAfterInfo2 = GetElement(self.m_root, "conEquipAfterInfo2_WndTransferStrengthen", WZUIContainer)
    if tWeapon1 == nil or tWeapon2 == nil then return end
    local extraInfo = tWeapon2.extraInfo
    if extraInfo.weaponskill == nil or extraInfo.weaponskill == "" then return end
    local skillIdList = SplitStringWithSeparator(extraInfo.weaponskill, "|")
    WZLog("WndTransferStrengthen:_updateWeaponTwoSkill", Serialize(skillIdList), #skillIdList)
    if skillIdList == nil or #skillIdList == 0 then return end

    conEquipCurInfo2:setRelativePosition(GlobalMethod:ccp(0.46, 0.36))
    conEquipAfterInfo2:setRelativePosition(GlobalMethod:ccp(0.82, 0.36))
    conCurSkills2:setVisible(false)
    conAfterSkills2:setVisible(false)
    
    --武器当前的技能
    for i = 1, 5 do
        local sConName = string.format("conNextCSkill%d_WndSophisticStrengthen", i)
        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)
        if conSkill ~= nil then
            conSkill:removeAllChildrenWithCleanup(true)
        end
    end
    for i = 1, #skillIdList do
        local sConName = string.format("conNextCSkill%d_WndSophisticStrengthen", i)
        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)
        if conSkill ~= nil then
            local cellElement = WZUISystem:getInstance():createElement("conSkill_WndTransferStrengthen")
            if cellElement ~= nil then
                cellElement:setVisible(true)
                local tData = GDatatab_skill["id_" .. skillIdList[i]]
                self:_setWeaponSkillData(cellElement, tData.icon, tData.lv_icon)
                cellElement:setTag(i - 1)
                conSkill:addChild(cellElement)
            end
        end
    end
    --武器被继承后的技能
    extraInfo = tWeapon1.extraInfo
    if extraInfo.weaponskill == nil or extraInfo.weaponskill == "" then return end
    local NewSkillList = SplitStringWithSeparator(extraInfo.weaponskill, "|")
    WZLog("WndTransferStrengthen:_updateWeaponTwoSkill", Serialize(NewSkillList), #NewSkillList)
    if NewSkillList == nil or #NewSkillList == 0 then return end
    
    for i = 1, 5 do
        local sConName = string.format("conNextASkill%d_WndSophisticStrengthen", i)
        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)
        if conSkill ~= nil then
            conSkill:removeAllChildrenWithCleanup(true)
        end
    end
    for i = 1, #skillIdList do
        local sConName = string.format("conNextASkill%d_WndSophisticStrengthen", i)
        local conSkill = GetElement(self.m_root, sConName, WZUIContainer)

        if conSkill ~= nil then
            local cellElement = WZUISystem:getInstance():createElement("conSkill_WndTransferStrengthen")
            if cellElement ~= nil then
                cellElement:setVisible(true)
                local tData
                if i <= #NewSkillList then
                    tData = GDatatab_skill["id_" .. NewSkillList[i]]
                else
                    tData = GDatatab_skill["id_" .. skillIdList[i]]
                end
                self:_setWeaponSkillData(cellElement, tData.icon, tData.lv_icon)
                cellElement:setTag(i - 1)
                conSkill:addChild(cellElement)
            end
        end
    end
end

--@brief    设置武器技能数据
function WndTransferStrengthen:_setWeaponSkillData(cellElement, iconFile, lvIconFile)
    --body
    local imgSkillP = GetElement(cellElement, "imgSkillP_WndTransferStrengthen", WZUIImage)
    --技能等级图标
    local imgSkillLv = GetElement(cellElement, "imgSkillLv_WndTransferStrengthen", WZUIImage)
    if imgSkillP == nil then return end

    imgSkillP:setFile(iconFile)
    imgSkillLv:setFile(lvIconFile)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Begin----------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function WndTransferStrengthen:_adaptLanguage_en()
    GetElement(self.m_root,"txtBagTransStoneNum_WndTransferStrengthen",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.923,0.5))

    GetElement(self.m_root,"txtCurStrongLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurStarLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAddName_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAddValue_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtAfterStrongLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterStarLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAddName_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAddValue_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    
    GetElement(self.m_root,"txtCurStrongLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurStarLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtAfterStrongLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterStarLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
end

--@brief	越南语适配函数
function WndTransferStrengthen:_adaptLanguage_vn()
    local txtCurAttrAddName = GetElement(self.m_root,"txtCurAttrAddName_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAddName:setFontSize(16)

    local txtCurAttrAddValue = GetElement(self.m_root,"txtCurAttrAddValue_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAddValue:setFontSize(16)

    local txtAfterAttrAddName = GetElement(self.m_root,"txtAfterAttrAddName_WndTransferStrengthen",WZUILabelTTF)
    if txtAfterAttrAddName then
	    txtAfterAttrAddName:setFontSize(16)
	end
    local txtAfterAttrAddValue = GetElement(self.m_root,"txtAfterAttrAddValue_WndTransferStrengthen",WZUILabelTTF)
    if txtAfterAttrAddValue then
	    txtAfterAttrAddValue:setFontSize(16)
	end
    local txtCurAttrAdd2Name = GetElement(self.m_root,"txtCurAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF)
    if txtCurAttrAdd2Name then
	    txtCurAttrAdd2Name:setFontSize(16)
	end
    local txtCurAttrAdd2Value = GetElement(self.m_root,"txtCurAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF)
    if txtCurAttrAdd2Value then
	    txtCurAttrAdd2Value:setFontSize(16)
	end

    local txtAfterAttrAdd2Name = GetElement(self.m_root,"txtAfterAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF)
    if txtAfterAttrAdd2Name then
	    txtAfterAttrAdd2Name:setFontSize(16)
	end
    local txtAfterAttrAdd2Value = GetElement(self.m_root,"txtAfterAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF)
    if txtAfterAttrAdd2Value then
	    txtAfterAttrAdd2Value:setFontSize(16)
	end

end

--@brief	葡语适配函数
--@note		葡语适配函数
function WndTransferStrengthen:_adaptLanguage_pt()
    GetElement(self.m_root,"txtOwnWord_WndTransferStrengthen",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtTransCostWord_WndTransferStrengthen",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.02,0.5))

    local txtCurAttrAddName = GetElement(self.m_root,"txtCurAttrAddName_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAddName:setScale(0.7)

    local txtCurAttrAddValue = GetElement(self.m_root,"txtCurAttrAddValue_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAddValue:setScale(0.7)

    local txtAfterAttrAddName = GetElement(self.m_root,"txtAfterAttrAddName_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAddName:setScale(0.7)

    local txtAfterAttrAddValue = GetElement(self.m_root,"txtAfterAttrAddValue_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAddValue:setScale(0.7)

    local txtCurAttrAdd2Name = GetElement(self.m_root,"txtCurAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAdd2Name:setScale(0.7)

    local txtCurAttrAdd2Value = GetElement(self.m_root,"txtCurAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAdd2Value:setScale(0.7)

    local txtAfterAttrAdd2Name = GetElement(self.m_root,"txtAfterAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAdd2Name:setScale(0.7)

    local txtAfterAttrAdd2Value = GetElement(self.m_root,"txtAfterAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAdd2Value:setScale(0.7)

    local txtBagTransStoneNum = GetElement(self.m_root,"txtBagTransStoneNum_WndTransferStrengthen",WZUILabelTTF)
    txtBagTransStoneNum:setRelativePosition(GlobalMethod:ccp(0.9,0.5))
end

--@beief    泰语适配
function WndTransferStrengthen:_adaptLanguage_th( )
    GetElement(self.m_root,"txtBagTransStoneNum_WndTransferStrengthen",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.78,0.5))

    GetElement(self.m_root,"txtCurStrongLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurStarLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAddName_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAddValue_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtAfterStrongLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterStarLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAddName_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAddValue_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtCurStrongLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurStarLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtAfterStrongLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterStarLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)

end

function WndTransferStrengthen:_adaptLanguage_tr(  )
    local txtBagTransStoneNum = GetElement(self.m_root,"txtBagTransStoneNum_WndTransferStrengthen",WZUILabelTTF)
    txtBagTransStoneNum:setRelativePosition(GlobalMethod:ccp(1.03,0.5))

    GetElement(self.m_root,"txtCurStrongLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurStarLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAddName_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    local txtCurAttrAddValue = GetElement(self.m_root,"txtCurAttrAddValue_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAddValue:setScale(0.8)
    txtCurAttrAddValue:setRelativePosition(GlobalMethod:ccp(1.13,0.5))

    GetElement(self.m_root, "conEquipAfterInfo1_WndTransferStrengthen", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.81,0.4))
    GetElement(self.m_root,"txtAfterStrongLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterStarLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAddName_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    local txtAfterAttrAddValue = GetElement(self.m_root,"txtAfterAttrAddValue_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAddValue:setScale(0.8)
    txtAfterAttrAddValue:setRelativePosition(GlobalMethod:ccp(1.13,0.5))
    
    GetElement(self.m_root,"txtCurStrongLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurStarLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    local txtCurAttrAdd2Value = GetElement(self.m_root,"txtCurAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAdd2Value:setScale(0.8)
    txtCurAttrAdd2Value:setRelativePosition(GlobalMethod:ccp(1.13,0.5))

    GetElement(self.m_root, "conEquipAfterInfo2_WndTransferStrengthen", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.81,0.4))
    GetElement(self.m_root,"txtAfterStrongLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterStarLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    local txtAfterAttrAdd2Value = GetElement(self.m_root,"txtAfterAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAdd2Value:setScale(0.8)
    txtAfterAttrAdd2Value:setRelativePosition(GlobalMethod:ccp(1.13,0.5))
end

function WndTransferStrengthen:_adaptLanguage_es(  )
    local txtBagT = GetElement(self.m_root,"txtBagTransStoneNum_WndTransferStrengthen",WZUILabelTTF)
    txtBagT:setRelativePosition(GlobalMethod:ccp(0.92,0.5))
    local txtTransfer = GetElement(self.m_root,"txtTransCostWord_WndTransferStrengthen",WZUILabelTTF)
    txtTransfer:setFontSize(20)
    txtTransfer:setRelativePosition(GlobalMethod:ccp(-0.01,0.5))

    GetElement(self.m_root,"txtCurAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtCurAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtAfterAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF):setFontSize(16)
    GetElement(self.m_root,"txtAfterAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF):setFontSize(16)

    GetElement(self.m_root,"txtCurStrongLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterStrongLv2_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtCurStrongLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurStarLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtCurAttrAddName_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    local txtCurAttrAddValue = GetElement(self.m_root,"txtCurAttrAddValue_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAddValue:setScale(0.8)
    -- txtCurAttrAddValue:setRelativePosition(GlobalMethod:ccp(0.5,0.1))

    GetElement(self.m_root,"txtAfterStrongLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterStarLv1_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtAfterAttrAddName_WndTransferStrengthen",WZUILabelTTF):setScale(0.8)
    local txtAfterAttrAddValue = GetElement(self.m_root,"txtAfterAttrAddValue_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAddValue:setScale(0.8)
    -- txtAfterAttrAddValue:setRelativePosition(GlobalMethod:ccp(0.5,0.1))

    
end

function WndTransferStrengthen:_adaptLanguage_ug(  )
    local txtTransfer1 = GetElement(self.m_root,"txtTransfer1_WndTransferStrengthen",WZUILabelTTF)
    txtTransfer1:setScale(0.7)
    txtTransfer1:setDimensions(GlobalMethod:CCSize(160))
    txtTransfer1:setAlignment(kCCTextAlignmentCenter)
    local txtTransfer2 = GetElement(self.m_root,"txtTransfer2_WndTransferStrengthen",WZUILabelTTF)
    txtTransfer2:setScale(0.7)
    txtTransfer2:setDimensions(GlobalMethod:CCSize(160))
    txtTransfer2:setAlignment(kCCTextAlignmentCenter)
    local txtTransfer3 = GetElement(self.m_root,"txtTransfer3_WndTransferStrengthen",WZUILabelTTF)
    txtTransfer3:setScale(0.7)
    txtTransfer3:setDimensions(GlobalMethod:CCSize(160))
    txtTransfer3:setAlignment(kCCTextAlignmentCenter)

    GetElement(self.m_root,"txtBefore_WndTransferStrengthen",WZUILabelTTF):setScale(0.45)
    GetElement(self.m_root,"txtAfter_WndTransferStrengthen",WZUILabelTTF):setScale(0.45)
	
    local txtCurAttrAddName = GetElement(self.m_root,"txtCurAttrAddName_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAddName:setScale(0.6)
    txtCurAttrAddName:setDimensions(GlobalMethod:CCSize(120))
    GetElement(self.m_root,"txtCurAttrAddValue_WndTransferStrengthen",WZUILabelTTF):setScale(0.6)
    local txtAfterAttrAddName = GetElement(self.m_root,"txtAfterAttrAddName_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAddName:setScale(0.6)
    txtAfterAttrAddName:setDimensions(GlobalMethod:CCSize(120))
    GetElement(self.m_root,"txtAfterAttrAddValue_WndTransferStrengthen",WZUILabelTTF):setScale(0.6)

    local txtCurAttrAdd2Name = GetElement(self.m_root,"txtCurAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF)
    txtCurAttrAdd2Name:setScale(0.6)
    txtCurAttrAdd2Name:setDimensions(GlobalMethod:CCSize(120))
    GetElement(self.m_root,"txtCurAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF):setScale(0.6)
    local txtAfterAttrAdd2Name = GetElement(self.m_root,"txtAfterAttrAdd2Name_WndTransferStrengthen",WZUILabelTTF)
    txtAfterAttrAdd2Name:setScale(0.6)
    txtAfterAttrAdd2Name:setDimensions(GlobalMethod:CCSize(120))
    GetElement(self.m_root,"txtAfterAttrAdd2Value_WndTransferStrengthen",WZUILabelTTF):setScale(0.6)

    GetElement(self.m_root,"txtTransCostWord_WndTransferStrengthen",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.95,0.5))
    GetElement(self.m_root,"imgCost1_Wnd",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.767872,0.5))
    local txtCost = GetElement(self.m_root,"txtCost_WndTransferStrengthen",WZUILabelTTF)
    txtCost:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtCost:setRelativePosition(GlobalMethod:ccp(0.72145,0.5))
    GetElement(self.m_root,"conImgCostItem_WndTransferStrengthen",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.42,0.5))
    local txtCostTransStoneNum = GetElement(self.m_root,"txtCostTransStoneNum_WndTransferStrengthen",WZUILabelTTF)
    txtCostTransStoneNum:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtCostTransStoneNum:setRelativePosition(GlobalMethod:ccp(0.376521,0.5))
    GetElement(self.m_root,"txtOwnWord_WndTransferStrengthen",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.1,0.5))
    local txtBagTransStoneNum = GetElement(self.m_root,"txtBagTransStoneNum_WndTransferStrengthen",WZUILabelTTF)
    txtBagTransStoneNum:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtBagTransStoneNum:setRelativePosition(GlobalMethod:ccp(0.09,0.5))
end
-------------------------------------语言适配模块End----------------------------------------
