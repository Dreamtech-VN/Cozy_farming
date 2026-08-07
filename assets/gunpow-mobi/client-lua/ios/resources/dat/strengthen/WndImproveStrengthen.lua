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
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndImproveStrengthen:onExit(element)
	self:_unInit()
	Teach:isStartTeach("WndImproveStrengthen:onExit")
end

--@brief	加载动画
function WndImproveStrengthen:onEnterTransitionDidFinish(element)
    --最高星级
	self.m_nMaxStarLevel = tonumber(CacheCenter:getGameParam().maxStarLevel)
	
    --新手定推礼包入口
    local conTop = GetElement(self.m_root, "conTop_WndImproveStrengthen", WZUIContainer)
    CreateLimitPackage(41, conTop, GlobalMethod:ccp(0, 1))
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
    local materialId = self:getStarsUpTable(starLevel + 1, quality).item_id
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
        local starLevel = self.m_tCurSelectedEquip.extraInfo.starLevel
		local quality = self.m_tCurSelectedEquip.basicInfo.quality
        local tagDemotion = self:getStarsUpTable(starLevel + 1, quality).isDemote
        if starLevel >= self.m_nMaxStarLevel or tagDemotion == 0 then
            return
        end
        --获得背包中圣灵石
		local tTable = self:getStarsUpTable(starLevel + 1, quality)
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
	self:displayTip()
end

--@brief	自动显示添加石头提示
function WndImproveStrengthen:displayTip()
	--GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setVisible(false)
	if self.m_holyStoneLuaObj.m_tItem == nil then
		--GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setVisible(true)
		--GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setText(LocalStrings.STRENGTENTIP2)
	end
	if self.m_tCurSelectedEquip ~= nil and self.m_tCurSelectedEquip.extraInfo.starLevel == self.m_nMaxStarLevel then
		--GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setVisible(false)
	end
end

--@brief    添加或取消装备时调用
--@author   zsq
function WndImproveStrengthen:addEquipToCell(tEquip)
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
    self:_updateImproveInfo()
    --添加材料
    self:_autoAddMaterials()
end

--@brief	升星按钮被按下时调用的函数
--@param	element:升星按钮的UI节点引用
--@note		在这里做升星按钮被按下时的响应操作
function WndImproveStrengthen:onImprove(element)	
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    do TeachGroup1:endTeachStep({10,5}) end

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
    local materialId = self:getStarsUpTable(starLevel + 1, quality).item_id
    local bagStarStoneNum = CacheCenter:getPlayerItemCountById(materialId) --背包中升星石数量
    local costStoneNum = self:getStarsUpTable(starLevel + 1, quality).num
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

	local viStarStoneID = WZLuaVector_int_:create()

	if self.m_holyStoneLuaObj ~= nil and self.m_holyStoneLuaObj.m_tItem ~= nil then
		viStarStoneID:push(self.m_holyStoneLuaObj.m_tItem.playerItemId)
	end

    self:_createLoading()
	ProtocolProcessorStrengthen:send_FORGING_UpStarNew(self.m_tCurSelectedEquip.playerItemId, viStarStoneID)
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

    --显示强化结果
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
    if starLevel >= self.m_nMaxStarLevel then
        self.m_holyStoneLuaObj:lockCell()
        self.m_starStoneLuaObj:lockCell()
        return
    end
    --强化等级是否存在
    if self:getStarsUpTable(starLevel + 1, quality) == nil then
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
    if starLevel >= self.m_nMaxStarLevel then return end
    --强化等级是否存在
    if self:getStarsUpTable(starLevel + 1, quality) == nil then return end
	--显示圣灵石名字
	GetElement(self.m_root, "stoneName1", WZUILabelTTF):setText(GDatatab_item["id_"..self:getStarsUpTable(starLevel + 1, quality).item_id].name)

    self.m_starStoneLuaObj:unLockCell()

    local stoneId = self:getStarsUpTable(starLevel + 1, quality).item_id
    local costStoneNum = self:getStarsUpTable(starLevel + 1, quality).num
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
    if starLevel >= self.m_nMaxStarLevel then return end
    --强化等级是否存在
    if self:getStarsUpTable(starLevel + 1, quality) == nil then return end
	--显示圣灵石名字
	GetElement(self.m_root, "stoneName2", WZUILabelTTF):setText(GDatatab_item["id_"..self:getStarsUpTable(starLevel + 1, quality).item1_id].name)
    --是否会降级
    if self:getStarsUpTable(starLevel + 1, quality).isDemote == 0 then
        self.m_holyStoneLuaObj:lockCell()
    	GetElement(self.m_root,"imgAddHolyStone_WndImproveStrengthen",WZUIImage):setFile("ui/common/common_icon_suo3.png")
        return
    end

    self.m_holyStoneLuaObj:unLockCell()
   	GetElement(self.m_root,"imgAddHolyStone_WndImproveStrengthen",WZUIImage):setFile("ui/common/common_icon_cwjh.png")

    --圣灵石数量
	local tTable = self:getStarsUpTable(starLevel + 1, quality)
   	local stoneId = tTable.item1_id
    local costStoneNum = tTable.num1
    local bagStoneNum =  CacheCenter:getPlayerItemCountById(stoneId)
    if costStoneNum > bagStoneNum then
		--GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setVisible(true)
		--GetElement(self.m_root,"txtDesc_WndImproveStrengthen",WZUILabelTTF):setText(LocalStrings.STRENGTENTIP2)
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
	if state == "normal" then
		GetElement(self.m_root,"conBottom_WndImproveStrengthen",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conStarStone_WndImproveStrengthen",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"conHolyStone_WndImproveStrengthen",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"arrow_WndImproveStrengthen",WZUI9Image):setVisible(true)
		GetElement(self.m_root,"conLeftAttr",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.03,0))
		GetElement(WndStrengthen.m_root, "conMidBg", WZUIContainer):setVisible(false)
	elseif state == "topLevel" then
		GetElement(self.m_root,"conBottom_WndImproveStrengthen",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conStarStone_WndImproveStrengthen",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"conHolyStone_WndImproveStrengthen",WZUIContainer):setVisible(false)
		GetElement(self.m_root,"arrow_WndImproveStrengthen",WZUI9Image):setVisible(false)
		GetElement(self.m_root,"conLeftAttr",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.3,0))
		GetElement(WndStrengthen.m_root, "conMidBg", WZUIContainer):setVisible(true)
	end
	if self.m_tCurSelectedEquip == nil then
		GetElement(self.m_root,"arrow_WndImproveStrengthen",WZUI9Image):setVisible(false)
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
function WndImproveStrengthen:_updateImproveInfo()
	--更新装备升星属性信息
    local tEquipStarInfo = self:_getEquipStarInfo()
    local eCurLevel = tEquipStarInfo.equipCurLv --当前升星等级
    local eNextLevel = tEquipStarInfo.equipNextLv--下一级升星等级
    local eCurAttrAdd = tEquipStarInfo.equipCurAttr --当前属性加成
    local eNextAttrAdd = tEquipStarInfo.equipNextAttr--下一级属性加成
    local eCostGold = tEquipStarInfo.goldCostNum  --消耗金币数量
    local bagStarStoneNum = CacheCenter:getPlayerItemCountById(113) --背包中升星石数量
    local bagStarStoneNumStr = string.format("%d)",bagStarStoneNum)
    --装备当前等级
	local txtLevel = GetElement(self.m_root, "txtLevel_WndImproveStrengthen", WZUILabelTTF)
	txtLevel:setText(eCurLevel)
	txtLevel:setVisible(false)
	--装备提升等级
	local txtLevelUp = GetElement(self.m_root, "txtLevelUp_WndImproveStrengthen", WZUILabelTTF)
	txtLevelUp:setText(eNextLevel)
	txtLevelUp:setVisible(false)
    --装备当前属性加成
	local txtAttack = GetElement(self.m_root, "txtAttack_WndImproveStrengthen", WZUIFreeTextBox)
	txtAttack:setShowText(eCurAttrAdd)
	--装备下一级属性加成
	local txtAttackUp = GetElement(self.m_root, "txtAttackUp_WndImproveStrengthen", WZUIFreeTextBox)
	txtAttackUp:setShowText(eNextAttrAdd)
    --消耗金币
	local txtCost = GetElement(self.m_root, "txtCost_WndImproveStrengthen", WZUILabelTTF)
	txtCost:setText(eCostGold)
	self.m_nImproveNeedGold = tonumber(eCostGold)
	--更新装备星级和经验
	self:_updateStarLevel()
	--成功率
	GetElement(self.m_root, "txtSuccessRate_WndIntensifyStrengthen", WZUILabelTTF):setText(tEquipStarInfo.rate)
	--幸运值
	if tEquipStarInfo.missTimes == "" or tEquipStarInfo.missTimes == nil then
		GetElement(self.m_root,"expPer_Wnd",WZUILabelTTF):setText("")
		GetElement(self.m_root,"progrExpProgress_Wnd",WZUIProgress):setPercentage(0)
		GetElement(self.m_root,"ttfLucky",WZUILabelTTF):setText(LocalStrings.LUCKVALUE..":0%")
	else
		GetElement(self.m_root,"expPer_Wnd",WZUILabelTTF):setText(tEquipStarInfo.missTimes.."/"..tEquipStarInfo.miss)
		GetElement(self.m_root,"expPer_Wnd",WZUILabelTTF):setText("")
		local percent = math.floor(tEquipStarInfo.missTimes/tEquipStarInfo.miss*100)
		GetElement(self.m_root,"progrExpProgress_Wnd",WZUIProgress):setPercentage(percent)
		GetElement(self.m_root,"ttfLucky",WZUILabelTTF):setText(LocalStrings.LUCKVALUE..":"..percent.."%")
	end
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
    if curEquip~= nil  then
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
		local equipCurAttr = [[<T C="233,166,62" S="20" P="0">%s</T><T C="255,236,193" S="20" P="0">+%d</T>]]
        dataTable.equipCurAttr = string.format(equipCurAttr,attrName,curAttr)
        
		-- 计算属性 （原始属性 + 强化属性）*（1+升星比率）+镶嵌属性
        if starLevel < self.m_nMaxStarLevel then
			dataTable.missTimes = curEquip.extraInfo.missTimes
			dataTable.miss = self:getStarsUpTable(starLevel + 1, quality).miss
			WZLog("计算幸运值", dataTable.missTimes, dataTable.miss)
			--计算基础属性
    		local equality = self.m_tCurSelectedEquip.basicInfo.quality
			local strongLevel = self.m_tCurSelectedEquip.extraInfo.strongLevel 
			--local baseAttr = property[1][2] + WndIntensifyStrengthen:getStrengthenTableInfo(equality,strongLevel,property[1][1]).attrAdd
			local baseAttr = property[1][2] 
			--橙装加上品级属性
			local addPercentValue = 0;
			if equality == 4 and self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade ~= nil and self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade ~= "" then
				--MsgBoxManager:showTipBox(self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade)
				local grade = SplitStringWithSeparator(self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade, "|")
				WZLog("??ddd",self.m_tCurSelectedEquip.extraInfo.orangeEquiGrade,Serialize(grade),property[1][2])
                addPercentValue = math.ceil(property[1][2] * tonumber(grade[2])/100)
			end
			baseAttr = baseAttr + addPercentValue
			baseAttr = baseAttr + WndIntensifyStrengthen:getStrengthenTableInfo(equality,strongLevel,property[1][1]).attrAdd
			--baseAttr=（原始属性 + 强化属性）

			--当前等级的强化升星加成
			local prevAttr = 0

            if starLevel > 0 then
				--升星提升属性等于(装备基础属性加上强化属性)*提升倍率
                prevAttr = math.ceil(baseAttr * (self:getStarsUpTable(starLevel, quality).property_rate/10000))
            end

			--下一等级的强化升星加成
			local nextAttr = prevAttr
            local t = self:getStarsUpTable(starLevel + 1, quality)
            if t == nil then
                return dataTable
            end
            nextAttr = math.ceil(baseAttr * (t.property_rate/10000))


            --下一级强化等级
            dataTable.equipNextLv = string.format("Lv%d", starLevel+1)
            --属性加成
            if property[1] ~= nil then
                local nextAttr = curAttr - prevAttr + nextAttr
				local equipNextAttr = [[<T C="233,166,62" S="20" P="0">%s</T><T C="99,255,95" S="20" P="0">+%d</T>]]
				if nextAttr == 2582 then nextAttr = 2581 end
                dataTable.equipNextAttr = string.format(equipNextAttr,attrName,nextAttr)
            end
            --消耗金币数量
            dataTable.goldCostNum = t.cost[1][2]
			--成功率
			dataTable.rate = tonumber(t.kprobability)/100
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
------------------------------------语言适配End---------------------------------------------
