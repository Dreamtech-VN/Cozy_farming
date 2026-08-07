--WndImproveStrengthen.lua
--@brief	WndImproveStrengthen的UI模块
--@date		2014/8/16
--@author	zsq
--@note		升星窗口

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndImproveStrengthen:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndImproveStrengthen:onExit(element)
	doStopAllActions(self.m_root)
	CacheCenter:unregisterUpatePlayerItemObserver(self)

	self:_unInit()
	Teach:isStartTeach("WndImproveStrengthen:onExit")
end

--@brief	加载动画
function WndImproveStrengthen:onEnterTransitionDidFinish(element)
    --最高星级
	self.m_nMaxStarLevel = tonumber(CacheCenter:getGameParam().maxStarLevel)
    --新手定推礼包入口
    local conTop = GetElement(self.m_root, "conTop_WndImproveStrengthen", WZUIContainer)
    CreateLimitPackage(41, conTop, GlobalMethod:ccp(0.1, 0.95))
	--更新装备升星信息
	self:_updateImproveInfo()

	--初始化升星石，圣灵石格子
	self:_initGrid()

	--切换聊天频道
	ChangeChatChannel(Chat_Channel_Forged_Upg)

	--多语言版本界面适配
	AdaptLanguage(self)

	--隐藏升星成功特效
  	local spine = GetElement(self.m_root,"starAni",WZUISpine)
	spine:setVisible(false)

	GetElement(self.m_root,"ttfLucky",WZUILabelTTF):setText("")
end

--@brief	初始化强化窗口UI
--@note		初始化强化窗口UI
function WndImproveStrengthen:_initGrid()
	--升星石
	local conStarStone = self.m_root:getChildElement("conStarStone_WndImproveStrengthen")
	if conStarStone ~= nil then
		self.m_starStoneElement, self.m_starStoneLuaObj = CellGoodItem:createElement()
        self.m_starStoneLuaObj:setItemClickFun(self,self.onStarStoneClicked)
		if self.m_starStoneElement ~= nil and self.m_starStoneLuaObj ~= nil then
			conStarStone:addChild(self.m_starStoneElement)
            self.m_starStoneElement:setScale(0.9)
    		GetElement(self.m_starStoneElement, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    		GetElement(self.m_starStoneElement, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
   			GetElement(self.m_starStoneElement, "btnImg1_CellGoodItem", WZUI9Image):setVisible(false)
   			GetElement(self.m_starStoneElement, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
		end
	end
	--圣灵石
	local conHolyStone = self.m_root:getChildElement("conHolyStone_WndImproveStrengthen")
	if conHolyStone ~= nil then
		self.m_holyStoneElement, self.m_holyStoneLuaObj = CellGoodItem:createElement()
        self.m_holyStoneLuaObj:setItemClickFun(self,self.onHolyStoneClicked)
		if self.m_holyStoneElement ~= nil and self.m_holyStoneLuaObj ~= nil then
			conHolyStone:addChild(self.m_holyStoneElement)
            self.m_holyStoneElement:setScale(0.9)
    		GetElement(self.m_holyStoneElement, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_scale9_beibaodi2.png")
    		GetElement(self.m_holyStoneElement, "btnImg_CellGoodItem", WZUI9Image):setScale(0.9)
   			GetElement(self.m_holyStoneElement, "btnImg1_CellGoodItem", WZUI9Image):setVisible(false)
   			GetElement(self.m_holyStoneElement, "btnImg2_CellGoodItem", WZUI9Image):setVisible(false)
		end
	end

	--材料名设置为升星石
	GetElement(self.m_root, "stoneName1", WZUILabelTTF):setText(LocalStrings.STAR_STONE)
	--材料名设置为圣灵石
	GetElement(self.m_root, "stoneName2", WZUILabelTTF):setText(LocalStrings.HOLY_STONE)
end

--@brief	升星石被点击时的回调函数
function WndImproveStrengthen:onStarStoneClicked(tItemTable)
    --强化石不可取消
    if self.m_starStoneLuaObj.m_tItem ~= nil and self.m_bStarStoneEnough == true then
    	--强化装备必须消耗强化石，不可卸下
    	MsgBoxManager:showTipBox(LocalStrings.STRENGTHEN1)
        return
    end
	--被点击时的缩放效果
	tItemTable:_runSelectedAction()
	if (self.m_tCurSelectedEquip == nil) then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
		return
	end
    --购买强化石
    --MsgBoxManager:showConfirmBox(LocalStrings.BUY_STARSTONE_MESSAGE, self, self.buyStrengthStone, nil, nil)
    local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
    local quality = self.m_tCurSelectedEquip.basicInfo.quality
    if starLevel >= self.m_nMaxStarLevel then return end
    local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
    local materialId = self:getStarsUpTable(starLevel + 1, quality, equipType).item_id
    WndFastGetItems:show(materialId)--打开快速购买窗口
end

--@brief	圣灵石被点击时的回调函数
function WndImproveStrengthen:onHolyStoneClicked(tItemTable)
    --被点击时的缩放效果
    tItemTable:_runSelectedAction()

    --没有装备
    if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end
	if self.m_holyStoneLuaObj.m_tItem == nil then
        local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
        local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
		local quality = self.m_tCurSelectedEquip.basicInfo.quality
        local tagDemotion = self:getStarsUpTable(starLevel + 1, quality, equipType).isDemote
        if starLevel >= self.m_nMaxStarLevel or tagDemotion == 0 then
            return
        end
        --获得背包中圣灵石
		local tTable = self:getStarsUpTable(starLevel + 1, quality, equipType)
    	local stoneId = tTable.item1_id
        local costStoneNum = tTable.num1
        local bagStoneNum =  CacheCenter:getPlayerItemCountById(stoneId)
		if bagStoneNum >= costStoneNum then
			self:_addHolyStone()
		else
			--没有圣灵石
			--checkIsOnSale(stoneId)
			WndFastGetItems:show(stoneId)
		end
	else
		--清空圣灵石
		self:_clearHolyStone()
	end
end

--@brief    添加或取消装备时调用
--@author   zsq
function WndImproveStrengthen:addEquipToCell(tEquip, isUpdata)
	isUpdata = isUpdata or nil
    self.m_tCurSelectedEquip = tEquip
	if tEquip == nil then
		GetElement(self.m_root,"arrow_WndImproveStrengthen",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setVisible(false)

		--材料名设置为升星石
		GetElement(self.m_root, "stoneName1", WZUILabelTTF):setText(LocalStrings.STAR_STONE)
		--材料名设置为圣灵石
		GetElement(self.m_root, "stoneName2", WZUILabelTTF):setText(LocalStrings.HOLY_STONE)
	else
		GetElement(self.m_root,"arrow_WndImproveStrengthen",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setVisible(true)
	end
    --更新数据
    self:_updateImproveInfo(isUpdata)
    --添加材料
    self:_autoAddMaterials()
end

--@brief	升星按钮被按下时调用的函数
--@param	element:升星按钮的UI节点引用
--@note		在这里做升星按钮被按下时的响应操作
function WndImproveStrengthen:onImprove(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    do TeachGroup1:endTeachStep({10,4}) end

	--正在升星直接返回
	if self.m_bIsImproving == true then
		self.m_root:enableSchedule("onImproveCall",0.35)
		WZLog("等服务器返回")
		return 
	end
    --是否有装备
    if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
        return
    end

    local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
	local quality = self.m_tCurSelectedEquip.basicInfo.quality
    local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
 
    if starLevel >= self.m_nMaxStarLevel then
        MsgBoxManager:showTipBox(LocalStrings.EQUIP_REACHED_MAX_STAR_LEVEL)
        return
    end
    --金币是否足够
    local playerGold = CacheCenter:getMoneyList().gold
    if self.m_nImproveNeedGold > playerGold then
        MsgBoxManager:showConfirmBox(LocalStrings.GOLD_COIN_NOT_ENOUGH, self, self.buyGold, nil, nil)
        return
    end
    --升星石是否足够
    local materialId = self:getStarsUpTable(starLevel + 1, quality, equipType).item_id
    local bagStarStoneNum = CacheCenter:getPlayerItemCountById(materialId) --背包中升星石数量
    local costStoneNum = self:getStarsUpTable(starLevel + 1, quality, equipType).num
	if bagStarStoneNum < costStoneNum then
        --MsgBoxManager:showConfirmBox(LocalStrings.BUY_STARSTONE_MESSAGE, self, self.buyHolyStone, nil, nil)
        WndFastGetItems:show(materialId)
        return
	end
	--是否有圣灵石
	if starLevel >= 4 and (self.m_holyStoneLuaObj == nil or self.m_holyStoneLuaObj.m_tItem == nil) then
		WZLog("--WndImproveStrengthen:onImprove--")
        local msg1 = LocalStrings.TIPS1	
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.CONTINUE_GAME, [MSGBOXUICFG_USEFREETXT] = true}
		MsgBoxManager:showConfirmBoxWithBg(msg1, self, self.sendImproveProtocol, MSGBOXLEVEL_HIGH, tCustomUIConfig)
		return
	end

	--如果还在进行战斗力动画，删除动画和消息队列
	if GlobalGame.g_tWndFightingList ~= nil and #GlobalGame.g_tWndFightingList ~= 0 then
    	for i,v in pairs(GlobalGame.g_tWndFightingList) do
    	    if v and v.m_root then
    	        WindowManager:removeWindow(v.m_root, v, true)
    	        GlobalGame.g_tWndFightingList[i] = nil
    	    end
    	end
		MsgBoxManager:_removeMsgByType(MSGBOXTYPE_FIGHTANI)
	end

	--发送请求
	self:sendImproveProtocol()
end

function WndImproveStrengthen:onImproveCall()
	WZLog("WndImproveStrengthen:onImproveCall")
	self.m_root:disableSchedule()
	self.m_bIsImproving = false
end

--@brief	发送升星协议
function WndImproveStrengthen:sendImproveProtocol()
	if self.m_tCurSelectedEquip == nil then
        MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
		return
	end
	self.m_bIsImproving = true

	local viStarStoneID = {}
	if self.m_holyStoneLuaObj ~= nil and self.m_holyStoneLuaObj.m_tItem ~= nil then
		table.insert(viStarStoneID, self.m_holyStoneLuaObj.m_tItem.playerItemId)
	end
	local viEquipID = {}
	local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
	local is_tempBool = nil
	if starLevel < 12 then
        if self.m_tCurSelectedEquip.basicInfo.main_type == 4 then
            viEquipID = {0}
        end
	else
		is_tempBool = true
		for i,v in pairs(self.m_tChooseStarPlayerId) do
			if v then
				table.insert(viEquipID,v)
			end
		end
	end
	if is_tempBool and GetTableLen(self.m_tChooseStarPlayerId) > 0 then
		local str = string.format(LocalStrings.OPTIMIZE_TEXT101,GetTableLen(self.m_tChooseStarPlayerId))
		MsgBoxManager:showConfirmBox(str, self, function()
			self:_createLoading()
            if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
                local consume = #viStarStoneID ~= 0
                ProtocolProcessorScenePets:send_PET_PetUpEquip(self.m_tCurSelectedEquip.playerItemId, 2, consume, 0, viEquipID)
            else
    			ProtocolProcessorStrengthen:send_FORGING_UpStarNew(self.m_tCurSelectedEquip.playerItemId, TableToVector(viStarStoneID, WZLuaVector_int_), TableToVector(viEquipID, WZLuaVector_int_))
            end
		end,nil,nil,nil,nil,nil,function()
			self.m_bIsImproving = false
		end)
	else
		self:_createLoading()
        if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
            local consume = #viStarStoneID ~= 0
            ProtocolProcessorScenePets:send_PET_PetUpEquip(self.m_tCurSelectedEquip.playerItemId, 2, consume, 0, viEquipID)
        else
    		ProtocolProcessorStrengthen:send_FORGING_UpStarNew(self.m_tCurSelectedEquip.playerItemId, TableToVector(viStarStoneID, WZLuaVector_int_), TableToVector(viEquipID, WZLuaVector_int_))
        end
	end
    self.m_tChooseStarPlayerId = {}
end

--@brief	快速购买金币框
--@param	nResType:响应类型(超时，确定，取消)
function WndImproveStrengthen:buyGold(nId, nResType)
	if nResType == MSGBOXRESTYPE_CONFIRM then
		WndBuyActivity:showBuyInterface(26)
	end
end

--@brief 	升星成功后的回调
--@note 	执行升星成功后的操作
function WndImproveStrengthen:onImproveSuccess(result)
    --关闭加载框
    self:_closeLoading()
    self.m_bIsImproving = false
    --显示升星结果
    if result then
        PopupResult("ui/common/common_icon_sxdjtsz.png")
        SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
        local starLevel = tonumber(self.m_tCurSelectedEquip.extraInfo.starLevel)
        local spine = GetElement(self.m_root,"starAni",WZUISpine)
        spine:setVisible(true)
        spine:setRelativePosition(ccp((starLevel-1)*0.104-0.4,0.5))
        spine:play("shengxing",false)   
    else
        PopupResult("ui/common/common_icon_sxsb.png")
        SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_FAILED)
    end
    --升星变化
    if self.m_tCurSelectedEquip == nil then return end
    local tEquip
    local equipList = CacheCenter:getEquipList(true)
    for k,v in pairs(equipList) do
        if v.playerItemId == self.m_tCurSelectedEquip.playerItemId then
            tEquip = v
            break
        end
    end
    WndStrengthen.m_bReloadEquipList = false
    WndStrengthen:_addWeaponToCell(tEquip)
end

--@brief    升星成功后的回调
--@note     执行升星成功后的操作
function WndImproveStrengthen:onImproveSuccess2(playerItemId, starLevel, starExp, status)
    --关闭加载框
    self:_closeLoading()
    self.m_bIsImproving = false

    --显示升星结果
    if status then
        PopupResult("ui/common/common_icon_sxdjtsz.png")
        SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
        local starLevel = tonumber(self.m_tCurSelectedEquip.extraInfo.starLevel)
        local spine = GetElement(self.m_root,"starAni",WZUISpine)
        spine:setVisible(true)
        spine:setRelativePosition(ccp((starLevel-1)*0.104-0.4,0.5))
        spine:play("shengxing",false)   
    else
        PopupResult("ui/common/common_icon_sxsb.png")
        SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_FAILED)
    end
    --升星变化
    if self.m_tCurSelectedEquip == nil then return end
    local tEquip
    local equipList = CacheCenter:getPetsEquipmentList()
    for k,v in pairs(equipList) do
        if v.playerItemId == playerItemId then
            tEquip = v
            break
        end
    end
    WndStrengthen.m_bReloadEquipList = false
    WndStrengthen:_addWeaponToCell(tEquip)
end

--@brief    购买道具后自动添加道具
--@author   zsq
function WndImproveStrengthen:buyCallBack()
    if self.m_root == nil then return end

    --强化失败会掉级时自动放入圣灵石
    self:_addHolyStone()
    --自动放入强化石
    self:_addStarStone()
end

--@brief	自动放入强化材料
function WndImproveStrengthen:_autoAddMaterials()
    if not self.m_holyStoneLuaObj then return end

    self.m_holyStoneLuaObj:unLockCell()
    self.m_starStoneLuaObj:unLockCell()
    self:_clearAllStone()
    --是否添加装备
    if self.m_tCurSelectedEquip == nil then
        return
    end
    --是否达到最大强化等级
	local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
	local quality = self.m_tCurSelectedEquip.basicInfo.quality
    local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
    if starLevel >= self.m_nMaxStarLevel then
        self.m_holyStoneLuaObj:lockCell()
        self.m_starStoneLuaObj:lockCell()
        return
    end
    --强化等级是否存在
    if self:getStarsUpTable(starLevel + 1, quality, equipType) == nil then
        return
    end

	--自动放入强化石
    self:_addStarStone()

	--强化失败会掉级时自动放入圣灵石
    self:_addHolyStone()
end

--@brief	添加升星石
function WndImproveStrengthen:_addStarStone(tItemTable, nTag, tData)
    if self.m_starStoneLuaObj.m_tItem ~= nil then
		self.m_starStoneLuaObj:removeAllChild()
    end 
    --是否添加装备
    if self.m_tCurSelectedEquip == nil then return end
    --是否达到最大强化等级
    local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
	local quality = self.m_tCurSelectedEquip.basicInfo.quality
    local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
    if starLevel >= self.m_nMaxStarLevel then return end
    --强化等级是否存在
    if self:getStarsUpTable(starLevel + 1, quality, equipType) == nil then return end
	--显示圣灵石名字
	GetElement(self.m_root, "stoneName1", WZUILabelTTF):setText(GDatatab_item["id_"..self:getStarsUpTable(starLevel + 1, quality, equipType).item_id].name)

    self.m_starStoneLuaObj:unLockCell()

    local stoneId = self:getStarsUpTable(starLevel + 1, quality, equipType).item_id
    local costStoneNum = self:getStarsUpTable(starLevel + 1, quality, equipType).num
    local bagStoneNum =  CacheCenter:getPlayerItemCountById(stoneId)

    --更新显示的数量
    local txtStrengthStoneNum = GetElement(self.m_root,"txtStarStoneNum_WndImproveStrengthen",WZUILabelTTF)
    local txtString2 = string.format("%d/%d",bagStoneNum,costStoneNum)
    txtStrengthStoneNum:setText(txtString2)
    if costStoneNum > bagStoneNum then
        txtStrengthStoneNum:setColor(GlobalMethod:ccc3(255,89,74))
        txtStrengthStoneNum:setStrokeColor(GlobalMethod:ccc3(158,0,0))
		self.m_bStarStoneEnough = false
    else
        txtStrengthStoneNum:setColor(GlobalMethod:ccc3(255,255,255))
        txtStrengthStoneNum:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		self.m_bStarStoneEnough = true
    end

    local tMaterialItems = CopyTable(CacheCenter:getMaterialList())
    local tData = nil
    for i,v in pairs(tMaterialItems) do
        if v.id == stoneId then
            tData = v
            break
        end
    end

	if self.m_starStoneLuaObj ~= nil then
		--隐藏强化石1默认背景
		self:_setStarStoneBgVisible(false)
		--放入强化石1
		local tempData = CopyTable(tData)
		
		if tData == nil then
			local basicInfo = GDatatab_item["id_"..stoneId]
            tData = {name=basicInfo.name,icon=basicInfo.icon,lastTime=0,lastNum=0,quality=basicInfo.quality,basicInfo=CopyTable(basicInfo)}
			self.m_starStoneLuaObj:setCellGoodItem(tData,11)
		else
			self.m_starStoneLuaObj:setCellGoodItem(tempData,11)
		end
	end
end


--@brief	添加圣灵石
--@param	tItemTable:物品项所属表对象
--@param	nTag:物品项在相应TableContainer中对应的tag
--@note		添加圣灵石
function WndImproveStrengthen:_addHolyStone(tItemTable, nTag, tData)
    if self.m_holyStoneLuaObj.m_tItem ~= nil then return end
    --是否添加装备
    if self.m_tCurSelectedEquip == nil then return end
    --是否达到最大强化等级
    local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
	local quality = self.m_tCurSelectedEquip.basicInfo.quality
    local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
    if starLevel >= self.m_nMaxStarLevel then return end
    --强化等级是否存在
    if self:getStarsUpTable(starLevel + 1, quality, equipType) == nil then return end
	--显示圣灵石名字
	GetElement(self.m_root, "stoneName2", WZUILabelTTF):setText(GDatatab_item["id_"..self:getStarsUpTable(starLevel + 1, quality, equipType).item1_id].name)
    --是否会降级
    if self:getStarsUpTable(starLevel + 1, quality, equipType).isDemote == 0 then
        self.m_holyStoneLuaObj:lockCell()
    	GetElement(self.m_root,"imgAddHolyStone_WndImproveStrengthen",WZUIImage):setFile("ui/common/common_icon_suo3.png")
        return
    end

    self.m_holyStoneLuaObj:unLockCell()
   	GetElement(self.m_root,"imgAddHolyStone_WndImproveStrengthen",WZUIImage):setFile("ui/common/common_icon_cwjh.png")

    --圣灵石数量
	local tTable = self:getStarsUpTable(starLevel + 1, quality, equipType)
   	local stoneId = tTable.item1_id
    local costStoneNum = tTable.num1
    local bagStoneNum =  CacheCenter:getPlayerItemCountById(stoneId)
    if costStoneNum > bagStoneNum then
        return
    end
    --更新显示的数量
    local txtHolyStoneNum = GetElement(self.m_root,"txtHolyStoneNum_WndImproveStrengthen",WZUILabelTTF)
    local txtString3 = string.format("%d/%d",bagStoneNum,costStoneNum)
    txtHolyStoneNum:setText(txtString3)
    if costStoneNum > bagStoneNum then
        txtHolyStoneNum:setColor(GlobalMethod:ccc3(255,89,74))
        txtHolyStoneNum:setStrokeColor(GlobalMethod:ccc3(158,0,0))
    else
        txtHolyStoneNum:setColor(GlobalMethod:ccc3(255,255,255))
        txtHolyStoneNum:setStrokeColor(GlobalMethod:ccc3(79,60,48))
    end

    local tMaterialItems = CacheCenter:getMaterialList()
    local tData = nil
    for i,v in pairs(tMaterialItems) do
        if v.id == stoneId then
            tData = v
            break
        end
    end

    if self.m_holyStoneLuaObj ~= nil then
        local tempData = CopyTable(tData)
        self.m_holyStoneLuaObj:setCellGoodItem(tempData,11)
    end

	--不显示圣灵石默认背景
	self:_setHolyStoneBgVisible(false)
end

--@brief	清空所有石头
function WndImproveStrengthen:_clearAllStone()
	self:_clearStarStone()
	self:_clearHolyStone()
end

--@brief	清空升星石
function WndImproveStrengthen:_clearStarStone()
	if self.m_starStoneLuaObj.m_tItem == nil then
		return
	end

	--清空强化石1数据
	self.m_starStoneLuaObj:removeAllChild()

	--显示强化石1默认背景
	self:_setStarStoneBgVisible(true)

	--材料名设置为升星石
	GetElement(self.m_root, "stoneName1", WZUILabelTTF):setText(LocalStrings.STAR_STONE)
end

--@brief	清空圣灵石
function WndImproveStrengthen:_clearHolyStone()
	if self.m_holyStoneLuaObj.m_tItem == nil then
		return
	end

	--清空圣灵石数据
	self.m_holyStoneLuaObj:removeAllChild()

	--显示圣灵石默认背景
	self:_setHolyStoneBgVisible(true)

	--材料名设置为圣灵石
	GetElement(self.m_root, "stoneName2", WZUILabelTTF):setText(LocalStrings.HOLY_STONE)
end

--@brief	设置升星石默认背景是否可见
function WndImproveStrengthen:_setStarStoneBgVisible(bFlag)
	GetElement(self.m_root, "txtStarStoneNum_WndImproveStrengthen", WZUILabelTTF):setVisible(not bFlag)
	GetElement(self.m_root, "imgAddStarStone_WndImproveStrengthen", WZUIImage):setVisible(bFlag)
	GetElement(self.m_root, "imgAdd1_WndImproveStrengthen", WZUIImage):setVisible(bFlag)
	GetElement(self.m_root, "imgAdd2_WndImproveStrengthen", WZUIImage):setVisible(bFlag)
	GetElement(self.m_root, "imgAdd5_WndImproveStrengthen", WZUIImage):setVisible(bFlag)
	if self.m_tCurSelectedEquip ~= nil and self.m_tCurSelectedEquip.extraInfo ~= nil then
		local starLevel = tonumber(self.m_tCurSelectedEquip.extraInfo.starLevel)
		if starLevel <= 4 then
			GetElement(self.m_root, "imgAdd2_WndImproveStrengthen", WZUIImage):setFile(GDatatab_item["id_108"].icon)
		elseif starLevel <= 8 then
			GetElement(self.m_root, "imgAdd2_WndImproveStrengthen", WZUIImage):setFile(GDatatab_item["id_109"].icon)
		elseif starLevel <= 12 then
			GetElement(self.m_root, "imgAdd2_WndImproveStrengthen", WZUIImage):setFile(GDatatab_item["id_110"].icon)
		end
		GetElement(self.m_root, "imgAdd2_WndImproveStrengthen", WZUIImage):setGrayRender(true)
	end
end

--@brief	设置圣灵石默认背景是否可见
function WndImproveStrengthen:_setHolyStoneBgVisible(bFlag)
	GetElement(self.m_root, "txtHolyStoneNum_WndImproveStrengthen", WZUILabelTTF):setVisible(not bFlag)
	GetElement(self.m_root, "imgAddHolyStone_WndImproveStrengthen", WZUIImage):setVisible(bFlag)
	GetElement(self.m_root, "imgAdd3_WndImproveStrengthen", WZUIImage):setVisible(bFlag)
	GetElement(self.m_root, "imgAdd4_WndImproveStrengthen", WZUIImage):setVisible(bFlag)
	GetElement(self.m_root, "imgAdd6_WndImproveStrengthen", WZUIImage):setVisible(bFlag)
end

--@brief	设置最高级状态
--@param	state:"normal","topLevel"
function WndImproveStrengthen:setDisplayState(state)
	local conLeftAttr = GetElement(self.m_root,"conLeftAttr",WZUIContainer)
	local conRightAttr = GetElement(self.m_root,"conRightAttr",WZUIContainer)
	conRightAttr:setVisible(true)

	if state == "normal" then
		GetElement(self.m_root,"conBottom_WndImproveStrengthen",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conStarStone_WndImproveStrengthen",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conHolyStone_WndImproveStrengthen",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"arrow_WndImproveStrengthen",WZUI9Image):setVisible(true)
		conLeftAttr:setRelativePosition(GlobalMethod:ccp(0.03,0))
		GetElement(WndStrengthen.m_root, "conMidBg", WZUIContainer):setVisible(false)
	elseif state == "topLevel" then
		GetElement(self.m_root,"conBottom_WndImproveStrengthen",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conStarStone_WndImproveStrengthen",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conHolyStone_WndImproveStrengthen",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"arrow_WndImproveStrengthen",WZUI9Image):setVisible(false)
		conLeftAttr:setRelativePosition(GlobalMethod:ccp(0.3,0))
		conRightAttr:setVisible(false)
		GetElement(WndStrengthen.m_root, "conMidBg", WZUIContainer):setVisible(true)

		local starLevel = 0
	    if self.m_tCurSelectedEquip and self.m_tCurSelectedEquip.extraInfo then
	    	starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
	    	if starLevel >= 20 then
	    		local conTop = GetElement(self.m_root,"conTop_WndImproveStrengthen",WZUIContainer)
	    		local starLevelCon1 = GetElement(conTop,"starLevelCon1",WZUIContainer)
	    		starLevelCon1:setVisible(true)
	    		GetElement(starLevelCon1,"conExp_WndImproveStrengthen",WZUIContainer):setVisible(false)
	    		GetElement(conLeftAttr, "txtLevel_WndImproveStrengthen",WZUILabelTTF):setText("Lv20")
	    		local tEquipStarInfo = self:_getEquipStarInfo()
			    local eCurAttrAdd = tEquipStarInfo.equipCurAttr --当前属性加成
			    GetElement(conLeftAttr, "txtAttack_WndImproveStrengthen", WZUIFreeTextBox):setShowText(eCurAttrAdd)

	    		GetElement(conTop,"starLevelCon2",WZUIContainer):setVisible(false)
	    		GetElement(conTop,"starLevelCon2_1",WZUIContainer):setVisible(true)
	    	end
	    end
	end
	if self.m_tCurSelectedEquip == nil then
		GetElement(self.m_root,"arrow_WndImproveStrengthen",WZUI9Image):setVisible(false)
	end

	if ProjConfig.LANGUAGE == "vn" then
		if state == "normal" then
			conLeftAttr:setRelativePosition(GlobalMethod:ccp(-0.12,0))
		end
	end
end

--@brief	升星幸运值tip
function WndImproveStrengthen:onMissTip(element)
	WndItemInfo:showInfo(GetElement(self.m_root,"imgStar7_WndImproveStrengthen",WZUIImage),self.m_root,3,LocalStrings.TIPS2,false)
end

--@brief  点击限时特惠礼包按钮回调
function WndImproveStrengthen:OpenNewUserPackage(element)
    --body
    OpenNewUserPackage(element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	更新装备升星信息
--@note 	更新装备升星信息
function WndImproveStrengthen:_updateImproveInfo(isUpdata)
	--更新装备升星属性信息
    local tEquipStarInfo = self:_getEquipStarInfo()
    local eCurLevel = tEquipStarInfo.equipCurLv --当前升星等级
    local eNextLevel = tEquipStarInfo.equipNextLv--下一级升星等级
    local eCurAttrAdd = tEquipStarInfo.equipCurAttr --当前属性加成
    local eNextAttrAdd = tEquipStarInfo.equipNextAttr--下一级属性加成
    local eCostGold = tEquipStarInfo.goldCostNum  --消耗金币数量

    local starLevel = 0
    if self.m_tCurSelectedEquip and self.m_tCurSelectedEquip.extraInfo then
    	starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
    end
    --消耗金币
	GetElement(self.m_root, "txtCost_WndImproveStrengthen", WZUILabelTTF):setText(eCostGold)
	self.m_nImproveNeedGold = tonumber(eCostGold)
	--成功率
	GetElement(self.m_root, "txtSuccessRate_WndIntensifyStrengthen", WZUILabelTTF):setText(tEquipStarInfo.rate)
    local txtRandomRate = GetElement(self.m_root, "txtRandomRate", WZUILabelTTF)
    if starLevel >= 12 and CheckButtonShow(215) then
        txtRandomRate:setText("(+0%)")
    else
        txtRandomRate:setText("")
    end
    --幸运值
	if tEquipStarInfo.missTimes == "" or tEquipStarInfo.missTimes == nil then
		GetElement(self.m_root,"expPer_Wnd",WZUILabelTTF):setText("")
		GetElement(self.m_root,"progrExpProgress_Wnd",WZUIProgress):setPercentage(0)
		GetElement(self.m_root,"ttfLucky",WZUILabelTTF):setText(LocalStrings.LUCKVALUE..":0%")
	else
		GetElement(self.m_root,"expPer_Wnd",WZUILabelTTF):setText(tEquipStarInfo.missTimes.."/"..tEquipStarInfo.miss)
		GetElement(self.m_root,"expPer_Wnd",WZUILabelTTF):setText("")
		local percent = string.format("%0.1f",tEquipStarInfo.missTimes/tEquipStarInfo.miss*100)
		GetElement(self.m_root,"progrExpProgress_Wnd",WZUIProgress):setPercentage(percent)
		GetElement(self.m_root,"ttfLucky",WZUILabelTTF):setText(LocalStrings.LUCKVALUE..":"..percent.."%")
	end

    local conTop = GetElement(self.m_root,"conTop_WndImproveStrengthen",WZUIContainer)
    local starLevelCon1 = GetElement(conTop,"starLevelCon1",WZUIContainer)
    starLevelCon1:setVisible(false)
    local starLevelCon2 = GetElement(conTop,"starLevelCon2",WZUIContainer)
    starLevelCon2:setVisible(false)
    local starLevelCon2_1 = GetElement(conTop,"starLevelCon2_1",WZUIContainer)
    starLevelCon2_1:setVisible(false)
    if starLevel < 12 then
    	starLevelCon1:setVisible(true)
    	GetElement(starLevelCon1,"conExp_WndImproveStrengthen",WZUIContainer):setVisible(true)
    	self:setStarLevel1(eCurLevel, eNextLevel, eCurAttrAdd, eNextAttrAdd, eCostGold, tEquipStarInfo)
    else
        if self.m_tCurSelectedEquip and self.m_tCurSelectedEquip.basicInfo.quality ~= 4 and starLevel == 12 or self.m_tCurSelectedEquip.basicInfo.main_type == 43 then --宠物装备只能1~12星
    		starLevelCon1:setVisible(true)
    		self:setStarLevel1(eCurLevel, eNextLevel, eCurAttrAdd, eNextAttrAdd, eCostGold, tEquipStarInfo)
    	else
    		if CheckButtonShow(215) then
		    	for i=13, 20 do
		    		local imgStar = GetElement(starLevelCon2_1,"imgStar"..i,WZUIImage)
		    		if i <= starLevel then
		    			imgStar:setFile("ui/common/common_icon_xingxing2_h.png")
		    			imgStar:setGrayRender(false)
		    		else
			    		imgStar:setGrayRender(true)
			    	end
		    	end
		    	starLevelCon2:setVisible(true)
		    	starLevelCon2_1:setVisible(true)
		    	local txtCurAttr = GetElement(self.m_root, "txtCurAttr", WZUIFreeTextBox)
		    	local str = [[%s<BL>20</BL><I Z="0.8">ui/common/common_icon_jiehunjiantou.png</I><BL>20</BL>%s]]
		    	txtCurAttr:setShowText(string.format(str,eCurAttrAdd,eNextAttrAdd))
		    	if self.m_tCurSelectedEquip then
			    	local subtype = self.m_tCurSelectedEquip.subtype
                    local violeList
                    if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
                        violeList = CacheCenter:getPetEquipCostList(subtype)
                    else
                        violeList = CacheCenter:getVioletEquipList(subtype)
                    end
					local violetFreeList = GetElement(conTop,"violetFreeList",WZUIFreeListContainer)
					violetFreeList:removeAll()
					if next(violeList) == nil then
						ShowPanelNullTip(violetFreeList, LocalStrings.STAR_STONE1, ccc3(255,255,255))
					else
                        removeShowPanelNullTip(violetFreeList)
                        doStopAllActions(self.m_root)
						self.m_tChooseStarItem = {}
						self.m_tChooseStarPlayerId = {}
						local id = self.m_tCurSelectedEquip.basicInfo.id
						local change_id = nil
                        if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
                            for i,v in pairs(GDatatab_pet_item_advanced) do
                                if v.items[1][1] == id then
                                    change_id = v.scrap[1][1]
                                end
                            end
                        else
    				    	for i,v in pairs(GDatatab_item_advanced) do
    				    		if v.items[1][1] == id then
    				    			change_id = v.scrap[1][1]
    				    		end
    				    	end
                        end
						for i=1, #violeList do
							-- delayRun(self.m_root, i / DEFAULT_FPS,function ()
								local element, tLuaObj = CellGoodItem:createElement()
								element:setScale(0.8)
								element:setTag(i)
								tLuaObj:setCellGoodItem(violeList[i], 1)
								-- if (id == violeList[i].basicInfo.id) or (change_id and change_id == violeList[i].basicInfo.id) then
								-- 	tLuaObj:setProtomeSelect()
								-- end
								violetFreeList:pushBack(WZUIContainer:luaTo(element))
								violetFreeList:getMoveElement():setPositionX(violetFreeList:getMaxPosition().x)
								tLuaObj:setItemClickFun(self, self.onItemClick)
							-- end)
						end
					end
				end
			else
				starLevelCon1:setVisible(true)
				GetElement(starLevelCon1,"conExp_WndImproveStrengthen",WZUIContainer):setVisible(true)
    			self:setStarLevel1(eCurLevel, eNextLevel, eCurAttrAdd, eNextAttrAdd, eCostGold, tEquipStarInfo)
			end
		end
    end
end
--1-12级以前
function WndImproveStrengthen:setStarLevel1(eCurLevel, eNextLevel, eCurAttrAdd, eNextAttrAdd, eCostGold, tEquipStarInfo)
	--装备当前等级
	GetElement(self.m_root, "txtLevel_WndImproveStrengthen", WZUILabelTTF):setText(eCurLevel)
	--装备提升等级
	GetElement(self.m_root, "txtLevelUp_WndImproveStrengthen", WZUILabelTTF):setText(eNextLevel)
    --装备当前属性加成
	GetElement(self.m_root, "txtAttack_WndImproveStrengthen", WZUIFreeTextBox):setShowText(eCurAttrAdd)
	--装备下一级属性加成
	GetElement(self.m_root, "txtAttackUp_WndImproveStrengthen", WZUIFreeTextBox):setShowText(eNextAttrAdd)

    local txtAttack = GetElement(self.m_root, "txtAttack_WndImproveStrengthen", WZUIFreeTextBox)
    local txtAttackUp = GetElement(self.m_root, "txtAttackUp_WndImproveStrengthen", WZUIFreeTextBox)
    if self.m_tCurSelectedEquip and self.m_tCurSelectedEquip.basicInfo.property[2] and self.m_tCurSelectedEquip.basicInfo.property[2][1] ~= 18 then
        txtAttack:setRelativePosition(GlobalMethod:ccp(0.07,0.3))
        txtAttack:setScale(0.7)
        txtAttackUp:setRelativePosition(GlobalMethod:ccp(0.07,0.3))
        txtAttackUp:setScale(0.7)
    else
        txtAttack:setRelativePosition(GlobalMethod:ccp(0.13,0.3))
        txtAttack:setScale(1)
        txtAttackUp:setRelativePosition(GlobalMethod:ccp(0.13,0.3))
        txtAttackUp:setScale(1)
    end

	--更新装备星级和经验
	self:_updateStarLevel()
end
function WndImproveStrengthen:onItemClick( tCell,tag,tData )
	if tData == nil then return end
	WndItemInfo:onCloseClick()
    if self.m_tChooseStarItem[tData.playerItemId] == nil then
    	if GetTableLen(self.m_tChooseStarPlayerId) >= 5 then
    		MsgBoxManager:showTipBox(LocalStrings.CHESTMAXNUM)
    	else
	    	tCell:setItemSelState(true)
	    	self.m_tChooseStarItem[tData.playerItemId] = true
	    	self.m_tChooseStarPlayerId[tag] = tData.playerItemId
    	end
    else
    	tCell:setItemSelState(false)
    	self.m_tChooseStarItem[tData.playerItemId] = nil
    	self.m_tChooseStarPlayerId[tag] = nil
    end
    --[[
	同名系数：不同名则=1，同名则取系统配置表 starsUpTimes1 第一个参数（要除以100）
	橙装系数：非橙装则=1，橙装则取系统配置表 starsUpTimes2 第一个参数（要除以100）
    ]]
	local starsUpTimes1 = CacheCenter:getGameParam().starsUpTimes1
	local starsUpTimes2 = CacheCenter:getGameParam().starsUpTimes2
    if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
        starsUpTimes1 = CacheCenter:getGameParam().petEquipstarsUpTimesEqual
        starsUpTimes2 = CacheCenter:getGameParam().petEquipstarsUpTimesOrange
    end
	local rate = 0
    if self.m_tCurSelectedEquip and self.m_tCurSelectedEquip.basicInfo then
    	local id = self.m_tCurSelectedEquip.basicInfo.id
    	local change_id = nil
        if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
            for i,v in pairs(GDatatab_pet_item_advanced) do
                if v.items[1][1] == id then
                    change_id = v.scrap[1][1]
                end
            end
        else
        	for i,v in pairs(GDatatab_item_advanced) do
        		if v.items[1][1] == id then
        			change_id = v.scrap[1][1]
        		end
        	end
        end
    	local quality = self.m_tCurSelectedEquip.basicInfo.quality
    	local subtype = self.m_tCurSelectedEquip.subtype
        local violeList
        if self.m_tCurSelectedEquip.basicInfo.main_type == 43 then
            violeList = CacheCenter:getPetEquipCostList(subtype)
        else
            violeList = CacheCenter:getVioletEquipList(subtype)
        end
		local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
		local quality = self.m_tCurSelectedEquip.basicInfo.quality
        local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
		local t = self:getStarsUpTable(starLevel + 1, quality, equipType)
		if t then
	    	for i,v in pairs(self.m_tChooseStarPlayerId) do
	    		for k,m in pairs(violeList) do
	    			if m.playerItemId == v then
	    				local temp_num1, temp_num2 = 1,1
	    				if id == m.basicInfo.id then
	    					local _string = string.sub(starsUpTimes1,2,-2) 
							local num = SplitStringWithSeparator(_string,",")[1]
							temp_num1 = tonumber(num) / 100
	    				end
	    				if change_id and change_id == m.basicInfo.id then
	    					local _string = string.sub(starsUpTimes1,2,-2) 
							local num = SplitStringWithSeparator(_string,",")[1]
							temp_num1 = tonumber(num) / 100
	    				end
	    				if quality == m.basicInfo.quality then
	    					local _string = string.sub(starsUpTimes2,2,-2) 
							local num = SplitStringWithSeparator(_string,",")[1]
							temp_num2 = tonumber(num) / 100
	    				end
	    				rate = rate + (tonumber(t.kprobability_add)/100) * temp_num1 * temp_num2
	    				break
	    			end
	    		end
	    	end
	    end
    end
    --成功率
	local txtRandomRate = GetElement(self.m_root, "txtRandomRate", WZUILabelTTF)
	txtRandomRate:setText(string.format("(+%s%%)",tostring(rate)))
	
end
--@brief    从配置表中获取装备升星信息
--@author   zsq
function WndImproveStrengthen:_getEquipStarInfo()
    local dataTable = {}
    dataTable.equipCurLv = "" --1装备当前强化等级
    dataTable.equipNextLv = ""--2装备下一级强化等级
    dataTable.equipCurAttr = ""--3装备当前强化属性加成
    dataTable.equipNextAttr = ""--4装备下一级强化属性加成
	dataTable.rate = "0%"
    dataTable.goldCostNum = 0 --10消耗金币
    dataTable.stoneId = -1
	dataTable.missTimes = ""
	dataTable.miss = ""
    --如果已经添加装备
    local curEquip = self.m_tCurSelectedEquip
    if curEquip ~= nil then
        local starLevel = curEquip.extraInfo.starLevel
		local quality = curEquip.basicInfo.quality
        --当前等级
        dataTable.equipCurLv = string.format("Lv%d", starLevel)
        --当前属性加成
        local property = curEquip.basicInfo.property
        local attrName = ""
        local curAttr = ""
        if property[1] ~= nil then
            attrName = ATTR_TITLE[property[1][1]]
			curAttr = curEquip.extraInfo[tostring(property[1][1])]
        end
        if property[2] ~= nil and property[2][1] ~= 18 then --属性2
            attrName2 = ATTR_TITLE[property[2][1]]
            curAttr2 = curEquip.extraInfo[tostring(property[2][1])]
        end
        local _size = 22
        if starLevel >= 13 then
        	_size = 20
        end
		local equipCurAttr = [[<T C="255,236,193" S="%d" P="1" SC="127,70,26" SS="4" SE="1">%s</T><T C="255,236,193" S="%d" P="1" SC="127,70,26" SS="4" SE="1">+%d</T>]]
        dataTable.equipCurAttr = string.format(equipCurAttr,_size,attrName,_size,curAttr)
        if property[2] ~= nil and property[2][1] ~= 18 then --属性2
            dataTable.equipCurAttr = dataTable.equipCurAttr .. " " .. string.format(equipCurAttr,_size,attrName2,_size,curAttr2)
        end
        
		-- 计算属性 （原始属性 + 强化属性）*（1+升星比率）+镶嵌属性
        if starLevel < self.m_nMaxStarLevel then
            local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
			dataTable.missTimes = curEquip.extraInfo.missTimes
			local m_tUpData = self:getStarsUpTable(starLevel + 1, quality, equipType)
			if not m_tUpData then
				m_tUpData = self:getStarsUpTable(starLevel, quality, equipType)
			end
			dataTable.miss = m_tUpData.miss
			--计算基础属性
    		local equality = self.m_tCurSelectedEquip.basicInfo.quality
			local strongLevel = self.m_tCurSelectedEquip.extraInfo.strongLevel
			local baseAttr = property[1][2] 
            local baseAttr2 = 0
            if property[2] ~= nil and property[2][1] ~= 18 then --属性2
                baseAttr2 = property[2][2] 
            end
			--橙装加上品级属性
			local addPercentValue = 0;
			if equality == 4 and self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade ~= nil and self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade ~= "" then
				local grade = SplitStringWithSeparator(self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade, "|")
				WZLog("??ddd",self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade,Serialize(grade),property[1][2])
                addPercentValue = math.ceil(property[1][2] * tonumber(grade[2])/100)
			end
			baseAttr = baseAttr + addPercentValue
			baseAttr = baseAttr + WndIntensifyStrengthen:getStrengthenTableInfo(equality,strongLevel,property[1][1],equipType).attrAdd
			--baseAttr=（原始属性 + 强化属性）
            if property[2] ~= nil and property[2][1] ~= 18 then --属性2
                local addPercentValue2 = 0;
                if equality == 4 and self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade ~= nil and self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade ~= "" then
                    local grade = SplitStringWithSeparator(self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade, "|")
                    WZLog("??ddd2",self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade,Serialize(grade),property[2][2])
                    addPercentValue2 = math.ceil(property[2][2] * tonumber(grade[2])/100)
                end
                baseAttr2 = baseAttr2 + addPercentValue2
                local tStrongInfo0 = WndIntensifyStrengthen:getStrengthenTableInfo(equality,strongLevel,property[2][1],equipType)
                if tStrongInfo0.attrAdd == nil then
                    tStrongInfo0.attrAdd = 0
                end
                baseAttr2 = baseAttr2 + tStrongInfo0.attrAdd
            end

			--当前等级的强化升星加成
			local prevAttr = 0

            if starLevel > 0 then
				--升星提升属性等于(装备基础属性加上强化属性)*提升倍率
                prevAttr = math.ceil(baseAttr * (self:getStarsUpTable(starLevel, quality, equipType).property_rate/10000))
            end

            local prevAttr2 = 0
            if property[2] ~= nil and property[2][1] ~= 18 then --属性2
                if starLevel > 0 then
                    --升星提升属性等于(装备基础属性加上强化属性)*提升倍率
                    prevAttr2 = math.ceil(baseAttr2 * (self:getStarsUpTable(starLevel, quality, equipType).property_rate/10000))
                end
            end

			--下一等级的强化升星加成
			local nextAttr = prevAttr
            local nextAttr2 = 0
            if property[2] ~= nil and property[2][1] ~= 18 then --属性2
                nextAttr2 = prevAttr2
            end
            local t = self:getStarsUpTable(starLevel + 1, quality, equipType)
            if t == nil then
                return dataTable
            end
            nextAttr = math.ceil(baseAttr * (t.property_rate/10000))
            if property[2] ~= nil and property[2][1] ~= 18 then --属性2
                nextAttr2 = math.ceil(baseAttr2 * (t.property_rate/10000))
            end
            --下一级强化等级
            dataTable.equipNextLv = string.format("Lv%d", starLevel+1)
            --属性加成
            if property[1] ~= nil then
                local nextAttr = curAttr - prevAttr + nextAttr
				local equipNextAttr = [[<T C="255,236,193" S="%d" P="1" SC="127,70,26" SS="4" SE="1">%s</T><T C="99,255,95" S="%d" P="1" SC="127,70,26" SS="4" SE="1">+%d</T>]]
				if nextAttr == 2582 then nextAttr = 2581 end
                dataTable.equipNextAttr = string.format(equipNextAttr,_size,attrName,_size,nextAttr)
            end
            if property[2] ~= nil and property[2][1] ~= 18 then --属性2
                local nextAttr2 = curAttr2 - prevAttr2 + nextAttr2
                local equipNextAttr = [[<T C="255,236,193" S="%d" P="1" SC="127,70,26" SS="4" SE="1">%s</T><T C="99,255,95" S="%d" P="1" SC="127,70,26" SS="4" SE="1">+%d</T>]]
                if nextAttr2 == 2582 then nextAttr2 = 2581 end
                dataTable.equipNextAttr = dataTable.equipNextAttr .. " " ..string.format(equipNextAttr,_size,attrName2,_size,nextAttr2)
            end
            --消耗金币数量
            dataTable.goldCostNum = t.cost[1][2]
			--成功率
			dataTable.rate = tonumber(t.kprobability)/100
			local temp_str = ""
			if starLevel >= 12 and CheckButtonShow(215) then
				GetElement(self.m_root, "txtRandomRate", WZUILabelTTF):setText("(+0%)")
			end
			dataTable.rate = dataTable.rate.."%"
        else
            dataTable.maxLevelTips = LocalStrings.REACH_MAX_STRONG_LEVLE
			dataTable.missTimes = 100
			dataTable.miss = 100
        end
    end

    return dataTable
end

--@brief	更新装备星级图片显示
--@brief	更新装备星级图片显示
function WndImproveStrengthen:_updateStarLevel()
    --升星等级对应图标
	for i=1,12 do
		GetElement(self.m_root, "imgStar" .. i .. "_WndImproveStrengthen", WZUIImage):setGrayRender(true)
		GetElement(self.m_root, "imgStar" .. i .. "_WndImproveStrengthen", WZUIImage):setVisible(true)
	end
	if self.m_tCurSelectedEquip ~= nil then
		local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel

		for i=1,12 do
			local imgStarF = GetElement(self.m_root, "imgStar" .. i .. "_WndImproveStrengthen", WZUIImage)
            --显示星星
			if i > 0 and i <= starLevel then
				imgStarF:setFile("ui/common/common_icon_xingxing2.png")
				imgStarF:setScale(1)
				imgStarF:setGrayRender(false)
			end
		end
	end
end

--@brief 	刷新升星石和圣灵石的数量
function WndImproveStrengthen:_updateStarAndHolyStoneNum()
	--是否添加装备
    if self.m_tCurSelectedEquip == nil then return end
    local equipType = self.m_tCurSelectedEquip.basicInfo.main_type == 43 and 2 or 1
    --是否达到最大强化等级
    local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
	local quality = self.m_tCurSelectedEquip.basicInfo.quality
    if starLevel >= self.m_nMaxStarLevel then return end
    --强化等级是否存在
    if self:getStarsUpTable(starLevel + 1, quality, equipType) == nil then return end

    if self.m_starStoneLuaObj then 
	    self.m_starStoneLuaObj:unLockCell()
	end

    local stoneId = self:getStarsUpTable(starLevel + 1, quality, equipType).item_id
    local costStoneNum = self:getStarsUpTable(starLevel + 1, quality, equipType).num
    local bagStoneNum =  CacheCenter:getPlayerItemCountById(stoneId)

    --更新显示的数量
    local txtStrengthStoneNum = GetElement(self.m_root,"txtStarStoneNum_WndImproveStrengthen",WZUILabelTTF)
    local txtString2 = string.format("%d/%d",bagStoneNum,costStoneNum)
    txtStrengthStoneNum:setText(txtString2)
    if costStoneNum > bagStoneNum then
        txtStrengthStoneNum:setColor(GlobalMethod:ccc3(255,89,74))
        txtStrengthStoneNum:setStrokeColor(GlobalMethod:ccc3(158,0,0))
		self.m_bStarStoneEnough = false
    else
        txtStrengthStoneNum:setColor(GlobalMethod:ccc3(255,255,255))
        txtStrengthStoneNum:setStrokeColor(GlobalMethod:ccc3(79,60,48))
		self.m_bStarStoneEnough = true
    end
    --圣灵石
    --圣灵石数量
	local tTable = self:getStarsUpTable(starLevel + 1, quality, equipType)
   	local stoneId = tTable.item1_id
    local costStoneNum = tTable.num1
    local bagStoneNum =  CacheCenter:getPlayerItemCountById(stoneId)
    if costStoneNum > bagStoneNum then
        return
    end
    --更新显示的数量
    local txtHolyStoneNum = GetElement(self.m_root,"txtHolyStoneNum_WndImproveStrengthen",WZUILabelTTF)
    local txtString3 = string.format("%d/%d",bagStoneNum,costStoneNum)
    txtHolyStoneNum:setText(txtString3)
    if costStoneNum > bagStoneNum then
        txtHolyStoneNum:setColor(GlobalMethod:ccc3(255,89,74))
        txtHolyStoneNum:setStrokeColor(GlobalMethod:ccc3(158,0,0))
    else
        txtHolyStoneNum:setColor(GlobalMethod:ccc3(255,255,255))
        txtHolyStoneNum:setStrokeColor(GlobalMethod:ccc3(79,60,48))
    end
end
-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin----------------------------------
function WndImproveStrengthen:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtCost_WndImproveStrengthen",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtSuccessRateTitle_WndIntensifyStrengthen",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtCostOneTime_WndImproveStrengthen",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(-0.01,0.57))
    
    GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setScale(0.7)
end

function WndImproveStrengthen:_adaptLanguage_en(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(460))
    txtDesc:setScale(0.8)
    GetElement(self.m_root,"txtCost_WndImproveStrengthen",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtSuccessRateTitle_WndIntensifyStrengthen",WZUILabelTTF):setFontSize(20)

    GetElement(self.m_root, "stoneName1", WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "stoneName2", WZUILabelTTF):setScale(0.7)
end

function WndImproveStrengthen:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtCost_WndImproveStrengthen",WZUILabelTTF):setFontSize(18)
    GetElement(self.m_root,"txtSuccessRateTitle_WndIntensifyStrengthen",WZUILabelTTF):setFontSize(18)
    local txtCostOne = GetElement(self.m_root,"txtCostOneTime_WndImproveStrengthen",WZUILabelTTF)
    txtCostOne:setRelativePosition(GlobalMethod:ccp(-0.06,0.57))
    txtCostOne:setFontSize(18)
    
    GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"stoneName1",WZUILabelTTF):setFontSize(12)
    for i=1,3 do
        local txtImprove = GetElement(self.m_root,"txtImprove"..i.."_WndImproveStrenthen",WZUILabelTTF)
        txtImprove:setDimensions(GlobalMethod:CCSize(130,0))
        txtImprove:setScale(0.8)
    end
    GetElement(self.m_root,"stoneName2",WZUILabelTTF):setFontSize(14)

    local txtAttack = GetElement(self.m_root, "txtAttack_WndImproveStrengthen", WZUIFreeTextBox)
    txtAttack:setScale(0.7)
    local txtAttackUp = GetElement(self.m_root, "txtAttackUp_WndImproveStrengthen", WZUIFreeTextBox)
    txtAttackUp:setScale(0.7)
end

function WndImproveStrengthen:_adaptLanguage_tr(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(460))
    txtDesc:setScale(0.8)

    GetElement(self.m_root, "stoneName1", WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "stoneName2", WZUILabelTTF):setScale(0.7)
end

function WndImproveStrengthen:_adaptLanguage_ug(  )
    local txtDesc = GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF)
    txtDesc:setDimensions(GlobalMethod:CCSize(500))
    txtDesc:setScale(0.7)

    GetElement(self.m_root, "stoneName1", WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root, "stoneName2", WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"txtCostOneTime_WndImproveStrengthen",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.82,0.57))
    GetElement(self.m_root,"conGold_WndImproveStrengthen",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.631115,0.57))
    local conImgCostGold = GetElement(self.m_root,"conImgCostGold_WndImproveStrengthen",WZUIContainer)
    conImgCostGold:setScale(0.7)
    conImgCostGold:setRelativePosition(GlobalMethod:ccp(0.807692,0.5))
    local conImgCostGoldNum = GetElement(self.m_root,"conImgCostGoldNum_WndImproveStrengthen",WZUIContainer)
    conImgCostGoldNum:setScale(0.7)
    conImgCostGoldNum:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    conImgCostGoldNum:setRelativePosition(GlobalMethod:ccp(0.799995,0.5))
    local txtCost = GetElement(self.m_root,"txtCost_WndImproveStrengthen",WZUILabelTTF)
    txtCost:setRelativePosition(GlobalMethod:ccp(1,0.5))
    txtCost:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    GetElement(self.m_root,"conSuccessRate_WndIntensifyStrengthen",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.111733,0.57))
    local txtSuccessRateTitle = GetElement(self.m_root,"txtSuccessRateTitle_WndIntensifyStrengthen",WZUILabelTTF)
    txtSuccessRateTitle:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    txtSuccessRateTitle:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    txtSuccessRateTitle:setDimensions(GlobalMethod:CCSize(200))
    txtSuccessRateTitle:setScale(0.7)
    local txtSuccessRate = GetElement(self.m_root,"txtSuccessRate_WndIntensifyStrengthen",WZUILabelTTF)
    txtSuccessRate:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    txtSuccessRate:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtSuccessRate:setScale(0.7)

    local txtImprove1 = GetElement(self.m_root,"txtImprove1_WndImproveStrenthen",WZUILabelTTF)
    txtImprove1:setDimensions(GlobalMethod:CCSize(160))
    txtImprove1:setScale(0.7)
    local txtImprove2 = GetElement(self.m_root,"txtImprove2_WndImproveStrenthen",WZUILabelTTF)
    txtImprove2:setDimensions(GlobalMethod:CCSize(160))
    txtImprove2:setScale(0.7)
    local txtImprove3 = GetElement(self.m_root,"txtImprove3_WndImproveStrenthen",WZUILabelTTF)
    txtImprove3:setDimensions(GlobalMethod:CCSize(160))
    txtImprove3:setScale(0.7)

    local txtAttack = GetElement(self.m_root, "txtAttack_WndImproveStrengthen", WZUIFreeTextBox)
    txtAttack:setScale(0.6)
    txtAttack:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txtAttack:setRelativePosition(GlobalMethod:ccp(0.5,0.325))
    txtAttack:setMaxWidth(400)
    local txtAttackUp = GetElement(self.m_root, "txtAttackUp_WndImproveStrengthen", WZUIFreeTextBox)
    txtAttackUp:setScale(0.6)
    txtAttackUp:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    txtAttackUp:setRelativePosition(GlobalMethod:ccp(0.5,0.325))
    txtAttackUp:setMaxWidth(400)
end

function WndImproveStrengthen:_adaptLanguage_vn(  )
    local txtSuccessRate = GetElement(self.m_root,"txtSuccessRate_WndIntensifyStrengthen",WZUILabelTTF)
    txtSuccessRate:setRelativePosition(GlobalMethod:ccp(0.6,0.45))
end

------------------------------------语言适配End---------------------------------------------
