--WndPhantomEquipment.lua
--@brief	WndPhantomEquipment的UI模块
--@date		2021/05/06
--@author	yrd
--@note		幻化装备


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPhantomEquipment:onEnter(element)
	WZLog("WndPhantomEquipment:onEnter")
	self.m_root = element
	ProtocolProcessorPhantom:regAll()
	ProtocolProcessorPhantom:send_SHAPE_SendEquipInfo( )

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPhantomEquipment:onExit(element)
	self:_unInit()
	-- ProtocolProcessorPhantom:unregAll()
end

--@brief	加载动画
function WndPhantomEquipment:onEnterTransitionDidFinish(element)
	local skinequipcell = CacheCenter:getGameParam().skinequipcell or 200
	self.m_nMaxGridsNum = tonumber(skinequipcell)
	self:_createItemGrids1()
	self:_createItemGrids2()
	self:_createItemGrids3()
end

function WndPhantomEquipment:showUIByType()
	local conType1 = GetElement(self.m_root,"conType1_WndPhantomEquipment",WZUIContainer)
	local conType2 = GetElement(self.m_root,"conType2_WndPhantomEquipment",WZUIContainer)
	local conType3 = GetElement(self.m_root,"conType3_WndPhantomEquipment",WZUIContainer)

	if self.m_nUIType == 1 then
		conType1:setVisible(true)
		conType2:setVisible(false)
		conType3:setVisible(false)
	elseif self.m_nUIType == 2 then
		conType1:setVisible(false)
		conType2:setVisible(true)
		conType3:setVisible(false)
	elseif self.m_nUIType == 3 then
		conType1:setVisible(false)
		conType2:setVisible(false)
		conType3:setVisible(true)
	end
end

--@brief	更新界面
function WndPhantomEquipment:updateUI()
	self:updateAlbumRedDot()

	self:showUIByType()

	if self.m_nUIType == 1 then
		self:updateBag1()
		self:createRole()
		self:showRoleItem()
	elseif self.m_nUIType == 2 then
		self:updateBag2()
		self:updateSynthesisItem()
	elseif self.m_nUIType == 3 then
		self:updateBag3()
		self:updateRecastItem()
	end

end

--@brief	刷新皮肤装备图鉴红点
function WndPhantomEquipment:updateAlbumRedDot()
	local bShowRed = false
	for i=1,#self.m_tAlbumList do
		if self.m_tAlbumList[i].status == 1 then
			bShowRed = true
			break
		end
	end
	--服务端没有及时推红点协议刷新红点时,手动发送取消红点皮肤装备图鉴
	if bShowRed == false then
		if GlobalGame.g_tRedPointList.phantomEquipment == true then
			GlobalGame.g_tRedPointList.phantomEquipment = false
			ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(284)
		end
	end

	WndPhantomEquipment:showAlbumRedDot()
	WndPets:updateRedDot()
end

--@brief	返回主界面按钮回调
function WndPhantomEquipment:onClickBack(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nUIType = 1
	self.m_bInitBagPos = true
	self:initEquipmentDataList()
	self:updateUI()
end

--@brief	前往合成界面按钮回调
function WndPhantomEquipment:onClickSynthesis(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nUIType = 2
	self.m_bInitBagPos = true
	self:initSynthesisDataList()
	self:updateUI()
end

--@brief	前往重铸界面按钮回调
function WndPhantomEquipment:onClickRecast(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nUIType = 3
	self.m_bInitBagPos = true
	self:initRecastDataList()
	self:updateUI()
end

--@brief	显示皮肤装备红点
function WndPhantomEquipment:showAlbumRedDot()
	if self.m_root == nil then return end 

    local imgAlbumRedDot = GetElement(self.m_root,"imgAlbumRedDot_WndPhantomEquipment",WZUIImage)
    if GlobalGame.g_tRedPointList.phantomEquipment then
        imgAlbumRedDot:setVisible(true)
    else
        imgAlbumRedDot:setVisible(false)
    end
end

--@brief	点击规则按钮回调
function WndPhantomEquipment:onClickRuleEquipment(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.PHANTOM_EQUIPMENT23)
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------装备界面begin----------------------------------------

--@brief    创建空背包格子
function WndPhantomEquipment:_createItemGrids1()
    local tcItemBag = GetElement(self.m_root, "tcItemBag1_WndPhantomEquipment", WZUITableContainer)
    self.m_tEquipmentCellList = {}
    for i = 1, self.m_nMaxGridsNum do
		local cellElement,tLuaObj = CellGoodItem:createElement()
		if cellElement ~= nil and tLuaObj ~= nil then
			cellElement:setTag(i-1)
			tcItemBag:setCellElement(cellElement)
			table.insert(self.m_tEquipmentCellList,tLuaObj)
			tLuaObj:setItemClickFun(self,self.onItemClick1)
		end
    end
end

--@brief	更新装备界面背包
function WndPhantomEquipment:updateBag1()
	WZLog("WndPhantomEquipment:updateBag1")
	self:updateBagShowData()
	local tcItemBag = GetElement(self.m_root,"tcItemBag1_WndPhantomEquipment",WZUITableContainer)
	self.m_nStartIndex1 = 1
	tcItemBag:enableSchedule("_addBagSchedule1",0)
end

--@brief	每帧加载装备Cell
function WndPhantomEquipment:_addBagSchedule1(element)
	local tcItemBag = GetElement(self.m_root,"tcItemBag1_WndPhantomEquipment",WZUITableContainer)

	for i=self.m_nStartIndex1,self.m_nMaxGridsNum do
		if self.m_tEquipmentShowList[i] then
			self.m_tEquipmentCellList[i]:setCellGoodItem(self.m_tEquipmentShowList[i],2)
		else
			self.m_tEquipmentCellList[i]:removeAllChild()
		end
		self.m_nStartIndex1 = self.m_nStartIndex1 + 1
	end

	if self.m_nStartIndex1 > self.m_nMaxGridsNum then
		element:disableSchedule()
		--拉倒最上面
		if self.m_bInitBagPos == true then
			tcItemBag:getMoveElement():setPositionY(tcItemBag:getMinPosition().y)
		end
		self.m_bInitBagPos = false
	end
end

--@brief	点击背包物品回调
function WndPhantomEquipment:onItemClick1(luaTable,tag,tData)
	local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
	self:_addTip2(tData,luaTable.m_root,conTips)--添加tip信息
end

--@brief	背包中装备显示tip信息
function WndPhantomEquipment:_addTip2(tItem,element,pCell)
	WZLog("WndPhantomEquipment:_addTip2",tItem,element,pCell)
	WndItemInfo:closeWin()
	if tItem == nil or element == nil or pCell == nil then
		return
	end
	WndItemInfo:showInfo(element,pCell,1,tItem,true)
	--事件回调
	WndItemInfo:setUseFun(self,self.onItemApply)--穿上或卸下回调
end

--@brief	穿上回调
function WndPhantomEquipment:onItemApply(luaTable,tData)
	WZLog("WndPhantomEquipment:onItemApply")
	if tData.basicInfo.quality > self.m_nQuality then
	    local shapeequipdemand = string.sub(CacheCenter:getGameParam()["shapeequipdemand"],2,-2)
	    local tShapeequipdemand = SplitStringWithSeparator(shapeequipdemand, ",")
	    local nUnlockCount = tShapeequipdemand[tData.basicInfo.quality+1] --多少皮肤数量可解锁
		MsgBoxManager:showTipBox(string.format(LocalStrings.PHANTOM_EQUIPMENT7,nUnlockCount,LocalStrings.PHANTOM_EQUIPMENT8[tData.basicInfo.quality+1]))
		return
	end
	local ids = WZLuaVector_int_:create()
	ids:push(tData.playerItemId)
	ProtocolProcessorPhantom:send_SHAPE_UseEquip(ids)
end

--@brief	创建角色形象
function WndPhantomEquipment:createRole()
	local conPlayerAni = GetElement(self.m_root, "conPlayerAni_WndPhantomEquipment", WZUIContainer)
	
	if conPlayerAni:getChildByTag(50) then
		conPlayerAni:removeChildByTag(50, true)
		self.m_tPlayerAni = nil
	end
	if self.m_nShapeId and self.m_nShapeId > 0 then
		self.m_tPlayerAni = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equipList, "wait0", nil, nil ,nil, nil, nil ,nil, nil, nil, nil,true, self.m_nShapeId)
		self.m_tPlayerAni:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
	else
    	local equipList = CacheCenter:getEquipedDecorationList()
    	local head, body = CacheCenter:getHeadAndBodyColor()
		self.m_tPlayerAni = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equipList, "wait0", nil, nil, nil, nil, nil, nil, nil, head, body, false)
		self.m_tPlayerAni:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0))
	end

	self.m_tPlayerAni:getAnimNode():setAnchorPoint(ccp(0.5,0))
	self.m_tPlayerAni:play("wait0",true)

	conPlayerAni:addChild(self.m_tPlayerAni:getAnimNode(), 0, 50)
end

--@brief	初始化6个装备格子
function WndPhantomEquipment:initEquipGrid()
	WZLog("WndPhantomEquipment:initEquipGrid")
	self.m_tEquipGridList = {}
	for i=1,6 do
		local con = self.m_root:getChildElement("conEquip"..i.."_WndPhantomEquipment")
		if con ~= nil then
		    local cellElement,tLuaObj = CellGoodItem:createElement()
			if cellElement ~= nil and tLuaObj ~= nil then
    	    	tLuaObj:setItemClickFun(self,self.onEquipBackFun)
				con:addChild(cellElement)
            	cellElement:setTag(i)
				table.insert(self.m_tEquipGridList,tLuaObj)
			end
		end
	end
end

--@brief	点击装备格子回调
function WndPhantomEquipment:onEquipBackFun(luaTable,tag,tData)
	local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)

	local tagToSubType = {0,1,2,3,4,5}
	local tagToId = {0,1,2,3,4,5}
	local tBagData = self:getBagDataBySubType(tagToSubType[tag])
	if tBagData == nil or #tBagData == 0 then
		WndFastGetItems:show(7810+tagToId[tag])
		return
	else
		self:setShowSubType(tagToSubType[tag])
		self:updateBag1()
	end

	if tData == nil then
		local strItem = {LocalStrings.WEAPON,LocalStrings.NEWBAG9,LocalStrings.PHANTOM_EQUIPMENT2,LocalStrings.PHANTOM_EQUIPMENT3,LocalStrings.PHANTOM_EQUIPMENT4,LocalStrings.PHANTOM_EQUIPMENT5,}
		WndItemInfo:showInfo(luaTable.m_root,conTips,3,strItem[tag],false)
		return
	end
	self:_addTip1(tData,luaTable.m_root,conTips)--添加tip信息
end

--@brief   设置角色装备
function WndPhantomEquipment:showRoleItem()
	WZLog("WndPhantomEquipment:showRoleItem")
	if self.m_tEquipGridList == nil then self:initEquipGrid() end
	for i=1,6 do
		if self.m_tEquipmentList[i] and self.m_tEquipmentList[i].id ~= 0 then
			self.m_tEquipGridList[i]:setCellGoodItem(self.m_tEquipmentList[i],2)
    		GetElement(self.m_tEquipGridList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_js_zb_di.png")
    		GetElement(self.m_tEquipGridList[i].m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
		else
			local tCell = self.m_tEquipGridList[i]
			tCell:removeAllChild()
    		GetElement(tCell.m_root, "btnImg_CellGoodItem", WZUI9Image):setFile("ui/common/common_js_zb_di.png")
    		GetElement(tCell.m_root, "btnImg_CellGoodItem", WZUI9Image):setVisible(true)
    		GetElement(tCell.m_root, "btnImg1_CellGoodItem", WZUI9Image):setFile("ui/common/common_js_zb_di.png")
    		GetElement(tCell.m_root, "btnImg2_CellGoodItem", WZUI9Image):setFile("ui/common/common_js_zb_di.png")
		end

		--装备栏位置没有物品时，显示该位置应该放置的物品类型图片
		self:_createBlankText(i)
	end
end

--@brief	装备栏空白时的说明
function WndPhantomEquipment:_createBlankText(tag)
	local sName = "conEquip%d_WndPhantomEquipment"
	sName = string.format(sName,tag)
	local con = self.m_root:getChildElement(sName)
	if con:getChildByTag(80+tag) then
		con:removeChildByTag(80+tag,true)
	end

	if self.m_tEquipmentList[tag] ~= nil and self.m_tEquipmentList[tag].id ~= 0 then return end

	--tag 1：武器，2：副手，3：帽子，4：上衣，5：裤子，6：鞋子
	local iconList = {"ui/phantom/common_icon_wq.png","ui/phantom/common_icon_fs.png","ui/phantom/common_icon_mz.png",
			"ui/phantom/common_icon_sy.png","ui/phantom/common_icon_kz.png","ui/phantom/common_icon_xz.png",}
	local icon = iconList[tag]

	local img = WZUIImage:create()
	img:setFile(icon)
	img:setTag(80+tag)
	img:setUseOriginSize(true)
	img:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	img:setTouchEnable(false)
	con:addChild(img)
end

--@brief	使用中装备显示tip信息
function WndPhantomEquipment:_addTip1(tItem,element,pCell)
	WZLog("WndPhantomEquipment:_addTip1",tItem,element,pCell)
	if tItem == nil or element == nil or pCell == nil then
		return
	end
	WndItemInfo:showInfo(element,pCell,1,tItem,true)
	--事件回调
	WndItemInfo:setUseFun(self,self.onItemRoyal)--卸下回调
end

--@brief	卸下回调
function WndPhantomEquipment:onItemRoyal(luaTable,tData)
	WZLog("WndPhantomEquipment:onItemRoyal")
	if tData.basicInfo.quality > self.m_nQuality then
	    local shapeequipdemand = string.sub(CacheCenter:getGameParam()["shapeequipdemand"],2,-2)
	    local tShapeequipdemand = SplitStringWithSeparator(shapeequipdemand, ",")
	    local nUnlockCount = tShapeequipdemand[tData.basicInfo.quality] --多少皮肤数量可解锁
		MsgBoxManager:showTipBox(string.format(LocalStrings.PHANTOM_EQUIPMENT7,nUnlockCount,LocalStrings.PHANTOM_EQUIPMENT8[tData.basicInfo.quality]))
		return
	end
	local ids = WZLuaVector_int_:create()
	ids:push(tData.playerItemId)
	ProtocolProcessorPhantom:send_SHAPE_UseEquip(ids)
end

--@brief	"一键装备"按钮回调
function WndPhantomEquipment:onSwitchBtn()
	WZLog("WndPhantomEquipment:onSwitchBtn")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local ids = WZLuaVector_int_:create()
	local sell = false
	for k,v in pairs(self.m_tEquipmentDataList) do
		if v.recommended == true then
        	ids:push(v.playerItemId)
			sell = true
		end
	end
	WZLog("WndPhantomEquipment:onSwitchBtn2",Serialize(VectorToTable(ids)))
	if sell == true then
		ProtocolProcessorPhantom:send_SHAPE_UseEquip(ids)
	end
end

--@brief	查看属性按钮回调
function WndPhantomEquipment:onEquipAttr(element) 
	WZLog("WndPhantomEquipment:onEquipAttr")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
	WndTips:show(element,conTips,71,{},GlobalMethod:ccp(0,-140),true)
end

--@brief	点击图鉴按钮回调
function WndPhantomEquipment:onClickAlbum(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndPhantomEquAlbum:showInterface()
end

-------------------------------------装备界面end----------------------------------------


-------------------------------------合成界面begin----------------------------------------

--@brief    创建空背包格子
function WndPhantomEquipment:_createItemGrids2()
    local tcItemBag = GetElement(self.m_root, "tcItemBag2_WndPhantomEquipment", WZUITableContainer)
    self.m_tSynthesisCellList = {}
    for i = 1, self.m_nMaxGridsNum do
		local cellElement,tLuaObj = CellGoodItem:createElement()
		if cellElement ~= nil and tLuaObj ~= nil then
			cellElement:setTag(i-1)
			tcItemBag:setCellElement(cellElement)
			table.insert(self.m_tSynthesisCellList,tLuaObj)
			tLuaObj:setItemClickFun(self,self.onItemPut1)
		end
    end
end

--@brief	更新合成界面背包
function WndPhantomEquipment:updateBag2()
	WZLog("WndPhantomEquipment:updateBag2")
	local tcItemBag = GetElement(self.m_root,"tcItemBag2_WndPhantomEquipment",WZUITableContainer)
	self.m_nStartIndex2 = 1
	tcItemBag:enableSchedule("_addBagSchedule2",0)
end

--@brief	每帧加载装备Cell
function WndPhantomEquipment:_addBagSchedule2(element)
	local tcItemBag = GetElement(self.m_root,"tcItemBag2_WndPhantomEquipment",WZUITableContainer)

	for i=self.m_nStartIndex2,self.m_nMaxGridsNum do
		if self.m_tSynthesisDataList[i] then
			self.m_tSynthesisCellList[i]:setCellGoodItem(self.m_tSynthesisDataList[i],2)
			if self.m_tSynthesisDataList[i].sellHook == true then --勾选标识
				self.m_tSynthesisCellList[i]:showSelectedIcon()
			else
				self.m_tSynthesisCellList[i]:removeGouIcon()
			end
			if self.m_tSynthesisDataList[i].lock == true then --锁标识
				self.m_tSynthesisCellList[i]:showLock2()
			else
				self.m_tSynthesisCellList[i]:removeLock2()
			end
			--红点
			self:setRedDot(self.m_tSynthesisCellList[i].m_root, false)
			local tSynthesisRedDotList = self:getSynthesisRedDotList()
			for j=1,#tSynthesisRedDotList do
				if tSynthesisRedDotList[j].playerItemId == self.m_tSynthesisDataList[i].playerItemId then
					self:setRedDot(self.m_tSynthesisCellList[i].m_root, true, GlobalMethod:ccp(0.87,0.87))
				end
			end
		else
			self.m_tSynthesisCellList[i]:removeAllChild()
			--移除红点
			self:setRedDot(self.m_tSynthesisCellList[i].m_root, false)
		end
		self.m_nStartIndex2 = self.m_nStartIndex2 + 1
	end

	if self.m_nStartIndex2 > self.m_nMaxGridsNum then
		element:disableSchedule()
		--拉倒最上面
		if self.m_bInitBagPos == true then
			tcItemBag:getMoveElement():setPositionY(tcItemBag:getMinPosition().y)
		end
		self.m_bInitBagPos = false
	end
end

--@brief	放入回调
function WndPhantomEquipment:onItemPut1(luaTable,tag,tData)
	WZLog("WndPhantomEquipment:onItemPut1",Serialize(tData))
	if tData.lock == true then
		return
	end
	--最多放入3件装备
	if tData.sellHook ~= true and #self.m_tSynthesisSelectList >= 3 then
		MsgBoxManager:showTipBox(string.format(LocalStrings.PHANTOM_EQUIPMENT10,#self.m_tSynthesisSelectList))
		return
	end

	self.m_tSynthesisSelectList = {}
	for i=1,#self.m_tSynthesisDataList do
		if self.m_tSynthesisDataList[i].playerItemId == tData.playerItemId then
			self.m_tSynthesisDataList[i].sellHook = not tData.sellHook
		end
		if self.m_tSynthesisDataList[i].sellHook == true then
			table.insert(self.m_tSynthesisSelectList,self.m_tSynthesisDataList[i])
		end
	end

	self.m_tSynthesisDataList = self:getSynthesisLockList(self.m_tSynthesisDataList,self.m_tSynthesisSelectList)
	self:updateUI()
end

--@brief	更新左侧选中的合成物品
function WndPhantomEquipment:updateSynthesisItem()
	--清空
	for i=1,3 do
		local conSynthesisEquip = GetElement(self.m_root,"conSynthesisEquip"..i.."_WndPhantomEquipment",WZUIContainer)
		conSynthesisEquip:removeAllChildrenWithCleanup(true)
	end
	local conSynthesisAfter = GetElement(self.m_root,"conSynthesisAfter_WndPhantomEquipment",WZUIContainer)
	conSynthesisAfter:removeAllChildrenWithCleanup(true)

	--3个待合成装备
	for i=1,#self.m_tSynthesisSelectList do
		local conSynthesisEquip = GetElement(self.m_root,"conSynthesisEquip"..i.."_WndPhantomEquipment",WZUIContainer)
		local cellElement,tLuaObj = CellGoodItem:createElement()
		if cellElement ~= nil and tLuaObj ~= nil then
			tLuaObj:setCellGoodItem(self.m_tSynthesisSelectList[i],2)
			tLuaObj:setItemClickFun(self,self.onItemClick3)
			conSynthesisEquip:addChild(cellElement)
		end
	end

	--初始化合成消耗
	local imgSynthesisCost = GetElement(self.m_root,"imgSynthesisCost_WndPhantomEquipment",WZUIImage)
	imgSynthesisCost:setFile("shopitems/gold.png")
	local txtSynthesisCost = GetElement(self.m_root,"txtSynthesisCost_WndPhantomEquipment",WZUILabelTTF)
	txtSynthesisCost:setText("0")
	--合成预览
	self.m_tSynthesisCost = nil
	if #self.m_tSynthesisSelectList ~= 0 then
		local nAfterId = 0 --记录合成后显示的id
		for i=1,#self.m_tSynthesisSelectList do
			if self.m_tSynthesisSelectList[i].basicInfo then
				--勾选的物品中,有装备和晶石则预览显示高阶装备,只有晶石则预览显示高阶晶石
				if self.m_tSynthesisSelectList[i].basicInfo.sub_type == 6 then
					if nAfterId == 0 then
						nAfterId = self.m_tSynthesisSelectList[i].basicInfo.id
					end
				else
					nAfterId = self.m_tSynthesisSelectList[i].basicInfo.id
				end
			end
		end
		for key,value in pairs(GDatatab_skinequip_mix) do
			if value.scrap == nAfterId then
				--设置合成后的装备
				local cellElement,tLuaObj = CellGoodItem:createElement()
				if cellElement ~= nil and tLuaObj ~= nil then
					tLuaObj:setCellGoodLocalId(value.items,1,2)
					tLuaObj:setItemClickFun(self,self.onItemClick4)
					conSynthesisAfter:addChild(cellElement)
				end
				--设置合成消耗
				local tItemInfo = GDatatab_item["id_"..value.cost[1][1]]
				imgSynthesisCost:setFile(tItemInfo.icon)
				txtSynthesisCost:setText(value.cost[1][2])
				self.m_tSynthesisCost = value.cost[1]
			end
		end
	end

end

--@brief	点击合成界面勾选物品回调 从勾选物品列表中删除点中的这个
function WndPhantomEquipment:onItemClick3(luaTable,tag,tData)
	WZLog("WndPhantomEquipment:onItemClick3")

	self.m_tSynthesisSelectList = {}
	for i=1,#self.m_tSynthesisDataList do
		if self.m_tSynthesisDataList[i].playerItemId == tData.playerItemId then
			self.m_tSynthesisDataList[i].sellHook = not tData.sellHook
		end
		if self.m_tSynthesisDataList[i].sellHook == true then
			table.insert(self.m_tSynthesisSelectList,self.m_tSynthesisDataList[i])
		end
	end

	self.m_tSynthesisDataList = self:getSynthesisLockList(self.m_tSynthesisDataList,self.m_tSynthesisSelectList)
	self:updateUI()
end

--@brief	点击合成界面合成后物品回调
function WndPhantomEquipment:onItemClick4(luaTable,tag,tData)
	WZLog("WndPhantomEquipment:onItemClick4")
	WndItemInfo:closeWin()
	local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
	if tData == nil or luaTable.m_root == nil or conTips == nil then
		return
	end
	WndItemInfo:showInfo(luaTable.m_root,conTips,1,tData,true)
end

--@brief	点击合成物品按钮回调
function WndPhantomEquipment:onClickEquSynthesis(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if #self.m_tSynthesisSelectList ~= 3 then
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_EQUIPMENT12)
		return
	end

	--合成表没有的3个晶石不能合成
	if #self.m_tSynthesisSelectList == 3 and self:getSynthesisSelectSubtype() == -1 then
		if self:checkCanSynthetic(self.m_tSynthesisSelectList[1].id) ~= true then
			MsgBoxManager:showTipBox(LocalStrings.PHANTOM_EQUIPMENT24)
			return
		end
	end

	if self.m_tSynthesisCost and self.m_tSynthesisCost[1] and self.m_tSynthesisCost[2] then
		--判断货币是否足够
	    if not JudgeMoneyIsEnough(self.m_tSynthesisCost[1], self.m_tSynthesisCost[2], nil, nil, ISLAND_RIGHT_PHANTOM) then
	        return 
	    end
	end

	local ids = WZLuaVector_int_:create()
	for k,v in pairs(self.m_tSynthesisSelectList) do
        ids:push(v.playerItemId)
	end
	ProtocolProcessorPhantom:send_SHAPE_MergeEquip(ids)
end

--@brief	点击合成规则按钮回调
function WndPhantomEquipment:onClickRuleSynthesis(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.PHANTOM_EQUIPMENT16)
end

--@brief	点击"自动放入"按钮回调
function WndPhantomEquipment:onClickAutoPut(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	self.m_tSynthesisSelectList = {}
	local tCanSynthesisList = self:getCanSynthesisList()
	if #tCanSynthesisList < 3 then
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_EQUIPMENT25)
		return
	end

	for i=1,#self.m_tSynthesisDataList do
		self.m_tSynthesisDataList[i].sellHook = false
		for j=1,#tCanSynthesisList do
			if self.m_tSynthesisDataList[i].playerItemId == tCanSynthesisList[j].playerItemId then
				self.m_tSynthesisDataList[i].sellHook = true
				table.insert(self.m_tSynthesisSelectList,self.m_tSynthesisDataList[i])
			end
		end
	end
	self.m_tSynthesisDataList = self:getSynthesisLockList(self.m_tSynthesisDataList,self.m_tSynthesisSelectList)
	self:updateUI()
end

-------------------------------------合成界面end----------------------------------------


-------------------------------------重铸界面begin----------------------------------------

--@brief    创建空背包格子
function WndPhantomEquipment:_createItemGrids3()
    local tcItemBag = GetElement(self.m_root, "tcItemBag3_WndPhantomEquipment", WZUITableContainer)
    self.m_tRecastCellList = {}
    for i = 1, self.m_nMaxGridsNum do
		local cellElement,tLuaObj = CellGoodItem:createElement()
		if cellElement ~= nil and tLuaObj ~= nil then
			cellElement:setTag(i-1)
			tcItemBag:setCellElement(cellElement)
			table.insert(self.m_tRecastCellList,tLuaObj)
			tLuaObj:setItemClickFun(self,self.onItemPut2)
		end
    end
end

--@brief	重铸装备界面背包
function WndPhantomEquipment:updateBag3()
	WZLog("WndPhantomEquipment:updateBag3")
	local tcItemBag = GetElement(self.m_root,"tcItemBag3_WndPhantomEquipment",WZUITableContainer)
	self.m_nStartIndex3 = 1
	tcItemBag:enableSchedule("_addBagSchedule3",0)
end

--@brief	每帧加载装备Cell
function WndPhantomEquipment:_addBagSchedule3(element)
	local tcItemBag = GetElement(self.m_root,"tcItemBag3_WndPhantomEquipment",WZUITableContainer)

	for i=self.m_nStartIndex3,self.m_nMaxGridsNum do
		if self.m_tRecastDataList[i] then
			self.m_tRecastCellList[i]:setCellGoodItem(self.m_tRecastDataList[i],2)
			if self.m_tRecastDataList[i].sellHook == true then --勾选标识
				self.m_tRecastCellList[i]:showSelectedIcon()
			else
				self.m_tRecastCellList[i]:removeGouIcon()
			end
			if self.m_tRecastDataList[i].lock == true then --锁标识
				self.m_tRecastCellList[i]:showLock2()
			else
				self.m_tRecastCellList[i]:removeLock2()
			end
		else
			self.m_tRecastCellList[i]:removeAllChild()
		end
		self.m_nStartIndex3 = self.m_nStartIndex3 + 1
	end

	if self.m_nStartIndex3 > self.m_nMaxGridsNum then
		element:disableSchedule()
		--拉倒最上面
		if self.m_bInitBagPos == true then
			tcItemBag:getMoveElement():setPositionY(tcItemBag:getMinPosition().y)
		end
		self.m_bInitBagPos = false
	end
end

--@brief	放入回调
function WndPhantomEquipment:onItemPut2(luaTable,tag,tData)
	WZLog("WndPhantomEquipment:onItemPut2")
	if tData.lock == true then
		return
	end
	--最多放入几件装备
	if tData.sellHook ~= true and #self.m_tRecastSelectList >= self.m_nRecastMaxCount then
		MsgBoxManager:showTipBox(string.format(LocalStrings.PHANTOM_EQUIPMENT10,self.m_nRecastMaxCount))
		return
	end

	self.m_tRecastSelectList = {}
	for i=1,#self.m_tRecastDataList do
		if self.m_tRecastDataList[i].playerItemId == tData.playerItemId then
			self.m_tRecastDataList[i].sellHook = not tData.sellHook
		end
		if self.m_tRecastDataList[i].sellHook == true then
			table.insert(self.m_tRecastSelectList,self.m_tRecastDataList[i])
		end
	end

	self.m_tRecastDataList = self:getRecastLockList(self.m_tRecastDataList,self.m_tRecastSelectList)
	self:updateUI()
end

--@brief	更新左侧选中的合成物品
function WndPhantomEquipment:updateRecastItem( )
	WZLog("WndPhantomEquipment:updateRecastItem")

	--清空
	for i=1,3 do
		local conRecastEquip = GetElement(self.m_root,"conRecastEquip"..i.."_WndPhantomEquipment",WZUIContainer)
		conRecastEquip:removeAllChildrenWithCleanup(true)
	end
	local conRecastQuestion1 = GetElement(self.m_root,"conRecastQuestion1_WndPhantomEquipment",WZUIContainer)
	conRecastQuestion1:setVisible(false)
	local conRecastAfter1 = GetElement(self.m_root,"conRecastAfter1_WndPhantomEquipment",WZUIContainer)
	conRecastAfter1:setRelativePosition(GlobalMethod:ccp(0.5,0.452))
	local conRecastAfter2 = GetElement(self.m_root,"conRecastAfter2_WndPhantomEquipment",WZUIContainer)
	conRecastAfter2:removeAllChildrenWithCleanup(true)
	local txtRecastAfter1 = GetElement(self.m_root,"txtRecastAfter1_WndPhantomEquipment",WZUILabelTTF)
	txtRecastAfter1:setText("")
	local txtRecastAfter2 = GetElement(self.m_root,"txtRecastAfter2_WndPhantomEquipment",WZUILabelTTF)
	txtRecastAfter2:setText("")
	--清空预览装备
	local imgRecastQuestion1 = GetElement(self.m_root,"imgRecastQuestion1_WndPhantomEquipment",WZUIImage)
	imgRecastQuestion1:setFile("")
	local imgRecastQuesQuality1 = GetElement(self.m_root,"imgRecastQuesQuality1_WndPhantomEquipment",WZUIImage)
	imgRecastQuesQuality1:setFile("")
	--还原带放入格子
	local conRecastLock3 = GetElement(self.m_root,"conRecastLock3_WndPhantomEquipment",WZUIContainer)
	conRecastLock3:setVisible(false)
	self.m_nRecastMaxCount = 3

	--3个待重铸装备
	for i=1,#self.m_tRecastSelectList do
		local conRecastEquip = GetElement(self.m_root,"conRecastEquip"..i.."_WndPhantomEquipment",WZUIContainer)
		local cellElement,tLuaObj = CellGoodItem:createElement()
		if cellElement ~= nil and tLuaObj ~= nil then
			tLuaObj:setCellGoodItem(self.m_tRecastSelectList[i],2)
			tLuaObj:setItemClickFun(self,self.onItemClick6)
			conRecastEquip:addChild(cellElement)
		end
	end

	--初始化重铸消耗
	local imgRecastCost = GetElement(self.m_root,"imgRecastCost_WndPhantomEquipment",WZUIImage)
	imgRecastCost:setFile("shopitems/gold.png")
	local txtRecastCost = GetElement(self.m_root,"txtRecastCost_WndPhantomEquipment",WZUILabelTTF)
	txtRecastCost:setText("0")
	--重铸预览
	self.m_tRecastCost = nil
	if #self.m_tRecastSelectList ~= 0 then
		for key,value in pairs(GDatatab_skinequip_recast) do
			if self.m_tRecastSelectList[1].basicInfo.quality == value.quality and self.m_tRecastSelectList[1].basicInfo.sub_type == value.part then
				--设置重铸消耗
				local tItemInfo = GDatatab_item["id_"..value.cost[1][1]]
				imgRecastCost:setFile(tItemInfo.icon)
				txtRecastCost:setText(value.cost[1][2])
				self.m_tRecastCost = value.cost[1]
				--设置重铸后的装备
				conRecastQuestion1:setVisible(true)
				-- 1：武器，2：副手，3：帽子，4：上衣，5：裤子，6：鞋子
				local iconList = {"ui/phantom/common_icon_wq.png","ui/phantom/common_icon_fs.png","ui/phantom/common_icon_mz.png",
						"ui/phantom/common_icon_sy.png","ui/phantom/common_icon_kz.png","ui/phantom/common_icon_xz.png",}
				local qualityPic = {"ui/common/frame_green.png","ui/common/frame_bule.png","ui/common/frame_violet.png",
						"ui/common/frame_orange.png","ui/common/common_scale9_hong.png","ui/common/common_scale9_cai.png"}
				qualityPic[0] = "ui/common/common_scale9_bai.png"
				imgRecastQuestion1:setFile(iconList[self.m_tRecastSelectList[1].basicInfo.sub_type+1])
				imgRecastQuesQuality1:setFile(qualityPic[self.m_tRecastSelectList[1].basicInfo.quality])
				--3件重铸时显示晶石
				if #self.m_tRecastSelectList == 3 then
					conRecastAfter1:setRelativePosition(GlobalMethod:ccp(0.36,0.452))
					txtRecastAfter1:setText((100-value.probability_crystal[1][2]).."%")
					txtRecastAfter2:setText(value.probability_crystal[1][2].."%")
					local cellElement,tLuaObj = CellGoodItem:createElement()
					if cellElement ~= nil and tLuaObj ~= nil then
						tLuaObj:setCellGoodLocalId(value.probability_crystal[1][1],1,2)
						tLuaObj:setItemClickFun(self,self.onItemClick7)
						conRecastAfter2:addChild(cellElement)
					end
				end
				--晶石概率为0时,锁闭第3个格子
				if value.probability_crystal[1][2] == 0 then
					conRecastLock3:setVisible(true)
					self.m_nRecastMaxCount = 2
				end
			end
		end
	end
end

--@brief	点击重铸界面勾选物品回调 从勾选物品列表中删除点中的这个
function WndPhantomEquipment:onItemClick6(luaTable,tag,tData)
	WZLog("WndPhantomEquipment:onItemClick6")

	self.m_tRecastSelectList = {}
	for i=1,#self.m_tRecastDataList do
		if self.m_tRecastDataList[i].playerItemId == tData.playerItemId then
			self.m_tRecastDataList[i].sellHook = not tData.sellHook
		end
		if self.m_tRecastDataList[i].sellHook == true then
			table.insert(self.m_tRecastSelectList,self.m_tRecastDataList[i])
		end
	end

	self.m_tRecastDataList = self:getRecastLockList(self.m_tRecastDataList,self.m_tRecastSelectList)
	self:updateUI()
end

--@brief	点击预览的未知装备回调
function WndPhantomEquipment:onClickUnknownEquipment(element)
	if self.m_tRecastSelectList and self.m_tRecastSelectList[1] and self.m_tRecastSelectList[1].basicInfo and self.m_tRecastSelectList[1].basicInfo.quality then
		--创建一个未知部位物品数据去显示弹窗
		local tempbasicInfo = self.m_tRecastSelectList[1].basicInfo
		local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
		local strQuality = LocalStrings.PHANTOM_EQUIPMENT8[tempbasicInfo.quality+1]
		--tag 1：武器，2：副手，3：帽子，4：上衣，5：裤子，6：鞋子
		local iconList = {"ui/phantom/common_icon_wq.png","ui/phantom/common_icon_fs.png","ui/phantom/common_icon_mz.png",
				"ui/phantom/common_icon_sy.png","ui/phantom/common_icon_kz.png","ui/phantom/common_icon_xz.png",}
		local strItem = {LocalStrings.WEAPON,LocalStrings.NEWBAG9,LocalStrings.PHANTOM_EQUIPMENT2,LocalStrings.PHANTOM_EQUIPMENT3,LocalStrings.PHANTOM_EQUIPMENT4,LocalStrings.PHANTOM_EQUIPMENT5,}
		--名字 "随机"+颜色+部位
		local name = LocalStrings.NEW_SHOP_1..strQuality..strItem[tempbasicInfo.sub_type+1]
		local icon = iconList[tempbasicInfo.sub_type+1]
		local desc = string.format(LocalStrings.PHANTOM_EQUIPMENT13,strQuality,strItem[tempbasicInfo.sub_type+1])
		local quality = tempbasicInfo.quality

		local tData = {}
		tData.basicInfo={id=0,name=name,icon=icon,desc=desc,quality=quality,use_level=1}
		WndItemInfo:showInfo(conTips,self.m_root,1,tData,false, ccp(-200,0), true)
	end
end

--@brief	点击预览的重铸晶石回调
function WndPhantomEquipment:onItemClick7(luaTable,tag,tData)
	local conTips = GetElement(WndPets.m_root,"conTips_WndPets",WZUIContainer)
	if tData == nil or luaTable.m_root == nil or conTips == nil then
		return
	end
	WndItemInfo:showInfo(luaTable.m_root,conTips,1,tData,true)
end

--@brief	点击重铸物品按钮回调
function WndPhantomEquipment:onClickEquRecast(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if #self.m_tRecastSelectList < 2 then
		MsgBoxManager:showTipBox(LocalStrings.PHANTOM_EQUIPMENT14)
		return
	end

	if self.m_tRecastCost and self.m_tRecastCost[1] and self.m_tRecastCost[2] then
		--判断货币是否足够
	    if not JudgeMoneyIsEnough(self.m_tRecastCost[1], self.m_tRecastCost[2], nil, nil, ISLAND_RIGHT_PHANTOM) then
	        return 
	    end
	end

	--有橙色以上品质 弹二级确认框
	local tempQuality = self.m_tRecastSelectList[1].basicInfo.quality
	if tempQuality >= 4 then
		local strTips = string.format(LocalStrings.PHANTOM_EQUIPMENT22,#self.m_tRecastSelectList,LocalStrings.PHANTOM_EQUIPMENT8[tempQuality+1])
		MsgBoxManager:showConfirmCancelBox(strTips, self,self.sureToRecast, nil, nil, "phantom_equipment_recast")
		return
	end

	self:sendAgainEquip()
end

--@brief	确认重铸
function WndPhantomEquipment:sureToRecast(nId, nResType)
	if nResType ~= MSGBOXRESTYPE_CONFIRM then return end
	self:sendAgainEquip()
end

--@brief	发送重铸协议重铸
function WndPhantomEquipment:sendAgainEquip()
	local ids = WZLuaVector_int_:create()
	for k,v in pairs(self.m_tRecastSelectList) do
        ids:push(v.playerItemId)
	end
	ProtocolProcessorPhantom:send_SHAPE_AgainEquip(ids)
end

--@brief	点击重铸规则按钮回调
function WndPhantomEquipment:onClickRuleRecast(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndSingleMapDesc:showInterface1(LocalStrings.PHANTOM_EQUIPMENT17)
end

-------------------------------------重铸界面end----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    节点中添加一个红色提示
--@param    element 节点
--@param    state 是否显示节点
--@param    pos 位置，可以为Nil
function WndPhantomEquipment:setRedDot(element, state, pos)
	if state then
		if element:getChildByTag(999) == nil then
			local img = WZUIImage:create()
			img:setFile("ui/common/common_icon_xiaodianzhui.png")
        	img:setTouchEnable(false)
			img:setUseOriginSize(true)
			img:setTag(999)
			img:setAnchorPoint(ccp(0.5,0.5))
			if pos == nil then 
				img:setRelativePosition(ccp(1,1))
			else
				img:setRelativePosition(pos)
			end
			element:addChild(img, 2)
		end
	else
		if element:getChildByTag(999) then
			element:removeChildByTag(999, true)
		end
	end 
end 




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndPhantomEquipment:_adaptLanguage_vn( ... )
	GetElement(self.m_root,"txtQuickEquip_WndPhantomEquipment",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配End----------------------------------------