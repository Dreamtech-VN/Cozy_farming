--WndEquipNew
--@date		2014/01/07
--@author	zsq
--@note		玩家物品项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEquipNew:onEnter(element)
	self.m_root = element
end

--@brief	加载资源完成后
function WndEquipNew:onEnterTransitionDidFinish(element)
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	self:_moreLanguage()
	AdaptLanguage(self)
	--self.m_root:enableSchedule("onFinishLoad",0)
	self:onFinishLoad()
end

--@brief	延迟一帧加载背包物品
function WndEquipNew:onFinishLoad(element,t)
	--element:disableSchedule()

	local tempBaagIndex = 2
	local TempListData = CacheCenter:getPropList()
	if CacheCenter:getPlayerInfo().level <= 10 then
		tempBaagIndex = 1
		TempListData = CacheCenter:getEquipList()
	end


	self.m_nBagIndex = tempBaagIndex
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	--self:setArmsData(CacheCenter:getEquipList())
	self:setAllData(TempListData)
	self:_updateItem()--更新装备

	WndBagRole:updateRedDot() --更新红点
end

--@brief	延迟一帧加载背包装备
function WndEquipNew:onLoadEquip()
	self:setAllData(CacheCenter:getEquipAllList(self.allSub))
	self:_updateItem()--更新装备
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEquipNew:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
end

function WndEquipNew:onCloseClick() 
	if self.m_root == nil then return end
	WndBagRole:onCloseClick()
end

--@brief	点击合成回调
function WndEquipNew:onSynthesis(element)
	WZLog("WndEquipNew:onSynthesis",type(WndBagRole.m_tWndSynthesis),type(WndBagRole.m_tWndSynthesisList))
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if CheckButtonOpen(32) ~= true then return end

	GetElement(WndBagRole.m_root,"conSell_WndBag",WZUIContainer):setVisible(false)
	GetElement(WndBagRole.m_root,"conSellList_WndBag",WZUIContainer):setVisible(false)
	GetElement(WndBagRole.m_root,"conSynthesis_WndBag",WZUIContainer):setVisible(true)
	GetElement(WndBagRole.m_root,"conSynthesisList_WndBag",WZUIContainer):setVisible(true)
	WZLog("WndEquipNew:onSynthesis1",GetElement(WndBagRole.m_root,"conSynthesis_WndBag",WZUIContainer):isVisible())
	WZLog("WndEquipNew:onSynthesis2",GetElement(WndBagRole.m_root,"conSynthesisList_WndBag",WZUIContainer):isVisible())
	if WndBagRole.m_tWndSynthesis ~= nil then
		WndBagRole.m_tWndSynthesis.m_root:setVisible(true)
		GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer):setVisible(false)
		GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer):setVisible(false)
	end
	if WndBagRole.m_tWndSynthesisList ~= nil then
		WndBagRole.m_tWndSynthesisList.m_root:setVisible(true)
	end

	--创建合成窗口
	if WndBagRole.m_tWndSynthesis == nil then
		local conSell = GetElement(WndBagRole.m_root,"conSynthesis_WndBag",WZUIContainer)
		local celElement = WndSynthesisRight:createElement()
		conSell:addChild(celElement)
		WndBagRole.m_tWndSynthesis = celElement:getLuaObjectIndex()
		WndBagRole.m_tWndSynthesis.m_root:setVisible(false)
		-- WindowManagerAni:createSwitchEquip(GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer),1,true,WndBagRole.m_tWndSynthesis.m_root)
		GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer):setVisible(false)
		WndBagRole.m_tWndSynthesis.m_root:setVisible(true)
	end

	--创建合成物品列表窗口
	if WndBagRole.m_tWndSynthesisList == nil then
		local conSellList = GetElement(WndBagRole.m_root,"conSynthesisList_WndBag",WZUIContainer)
		local celElement = WndSynthesisLeft:createElement()
		conSellList:addChild(celElement)
		WndBagRole.m_tWndSynthesisList = celElement:getLuaObjectIndex()
		WndBagRole.m_tWndSynthesisList.m_root:setVisible(false)
		-- WindowManagerAni:createSwitchEquip(GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer),0,true,WndBagRole.m_tWndSynthesisList.m_root)
		GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer):setVisible(false)
		WndBagRole.m_tWndSynthesisList.m_root:setVisible(true)
	end

end

--@brief	点击回收回调
function WndEquipNew:onSaleClick()
	WZLog("WndEquipNew:onSaleClick")
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	GetElement(WndBagRole.m_root,"conSell_WndBag",WZUIContainer):setVisible(true)
	GetElement(WndBagRole.m_root,"conSellList_WndBag",WZUIContainer):setVisible(true)
	GetElement(WndBagRole.m_root,"conSynthesis_WndBag",WZUIContainer):setVisible(false)
	GetElement(WndBagRole.m_root,"conSynthesisList_WndBag",WZUIContainer):setVisible(false)
	if WndBagRole.m_tWndSell ~= nil then
		WndBagRole.m_tWndSell.m_root:setVisible(true)
		GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer):setVisible(false)
		GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer):setVisible(false)
	end
	if WndBagRole.m_tWndSellList ~= nil then
		WndBagRole.m_tWndSellList.m_root:setVisible(true)
	end
	
	--创建出售窗口
	if WndBagRole.m_tWndSell == nil then
		local conSell = GetElement(WndBagRole.m_root,"conSell_WndBag",WZUIContainer)
		local celElement = WndSell:createElement()
		conSell:addChild(celElement)
		WndBagRole.m_tWndSell = celElement:getLuaObjectIndex()
		WndBagRole.m_tWndSell.m_root:setVisible(false)
		-- WindowManagerAni:createSwitchEquip(GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer),1,true,WndBagRole.m_tWndSell.m_root)
		GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer):setVisible(false)
		WndBagRole.m_tWndSell.m_root:setVisible(true)
	end

	--创建出售物品列表窗口
	if WndBagRole.m_tWndSellList == nil then
		local conSellList = GetElement(WndBagRole.m_root,"conSellList_WndBag",WZUIContainer)
		local celElement = WndSellList:createElement()
		conSellList:addChild(celElement)
		WndBagRole.m_tWndSellList = celElement:getLuaObjectIndex()
		WndBagRole.m_tWndSellList.m_root:setVisible(false)
		-- WindowManagerAni:createSwitchEquip(GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer),0,true,WndBagRole.m_tWndSellList.m_root)
		GetElement(WndBagRole.m_root,"conLeft_WndBag",WZUIContainer):setVisible(false)
		WndBagRole.m_tWndSellList.m_root:setVisible(true)
	end

	--GetElement(WndBagRole.m_root,"conRight_WndBag",WZUIContainer):setVisible(true)
end

--@brief	全部复选框回调
function WndEquipNew:onAllSelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("全部复选框回调")
	if self.m_nBagIndex == 0 then
		return
	end
	self.m_nY = nil 
	self.m_nBagIndex = 0
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setAllData(CacheCenter:getAllList())
	self:_updateItem()--更新装备
    GetElement(self.m_root, "itemNum_WndEquipNew", WZUILabelTTF):setVisible(true)
end

--@brief	装备复选框回调
function WndEquipNew:onArmsSelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("装备复选框回调")
	if self.m_nBagIndex == 1 then
		return
	end
	self.m_nY = nil 
	self.m_nBagIndex = 1
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setArmsData(CacheCenter:getEquipList())
	self:_updateItem()--更新装备
    GetElement(self.m_root, "itemNum_WndEquipNew", WZUILabelTTF):setVisible(false)
end

--@brief	道具复选框回调
function WndEquipNew:onDressSelect(element)
	WZLog("道具复选框回调")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nBagIndex == 2 then
		return
	end
	self.m_nY = nil 
	self.m_nBagIndex = 2
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setDressData(CacheCenter:getPropList())
	self:_updateItem()--更新道具列表
    GetElement(self.m_root, "itemNum_WndEquipNew", WZUILabelTTF):setVisible(false)
end

--@brief	宝石复选框回调
function WndEquipNew:onGemSelect(element)
	WZLog("宝石复选框回调")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nBagIndex == 4 then
		return
	end
	self.m_nY = nil 
	self.m_nBagIndex = 4
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setGemData(CacheCenter:getPlayerAndPetGemList())
	self:_updateItem()--更新道具列表
    GetElement(self.m_root, "itemNum_WndEquipNew", WZUILabelTTF):setVisible(false)
end

--@brief	材料复选框回调
function WndEquipNew:onOthersSelect(element)
	WZLog("材料复选框回调")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nBagIndex == 3 then
		return
	end
	self.m_nY = nil 
	self.m_nBagIndex = 3
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setOtherData(CacheCenter:getBagMaterialList())
	self:_updateItem()--更新其它列表
    GetElement(self.m_root, "itemNum_WndEquipNew", WZUILabelTTF):setVisible(false)
end

--@brief	皮肤复选框回调
function WndEquipNew:onSkinSelect(element)
	WZLog("皮肤复选框回调")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nBagIndex == 5 then
		return
	end
	self.m_nY = nil 
	self.m_nBagIndex = 5
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setSkinData(CacheCenter:getSkinAndFootList())
	self:_updateItem()--更新其它列表
    GetElement(self.m_root, "itemNum_WndEquipNew", WZUILabelTTF):setVisible(false)
end

--@brief	Item点击回调
function WndEquipNew:onItemClick(luaTable,tag,tData)
	self.m_nY = self:_getMovePostion()
	if tData == nil then
		return
	--elseif self.m_tItemBack then
	--	self.m_tItemBack[3](self.m_tItemBack[1],1)
	end
	self.m_nItem = tag
	local parent = WZUIContainer:luaTo(WndBagRole.m_root:getChildElement("conRight_WndBag"))
	local tItem = CopyTable(self.m_tItem[tag+1])
	if self.m_nBagIndex ~= 3 then
		tItem.lock = 2 
	end
	self:_addTip(tItem,luaTable.m_root,parent)--添加tip信息
end

-- --@brief	强化回调
-- function WndEquipNew:onStrengthen(luaTable,tData)

-- end

-- --@brief	穿上回调
-- function WndEquipNew:onItemWear(luaTable,tData)
-- 	WZLog("WndEquipNew:onItemWear穿上回调")
--     if CheckButtonOpen(ISLAND_RIGHT_PLAYER) then
--         WndBagMain:showBag()
--     end
-- end

-- --@brief	卸下回调
-- function WndEquipNew:onItemRoyal(luaTable,tData)
-- 	WZLog("WndEquipNew:onItemRoyal卸下回调",luaTable)
--    	--local id = WZLuaVector_int_:create()
-- 	--id:push(tData.playerItemId)
-- 	--ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)
--     if CheckButtonOpen(ISLAND_RIGHT_PLAYER) then
--         WndBagMain:showBag()
--     end
-- end

--@brief	强化回调
function WndEquipNew:onStrengthen(luaTable,tData)
	if (luaTable == nil or tonumber(luaTable) ~= nil ) and self.m_tItemBack then
		self.m_tItemBack[2](self.m_tItemBack[1],5,luaTable or 0)--关闭强化研究院返回0:没变化
	else
		self.m_tItemBack[2](self.m_tItemBack[1],5,-1)--打开强化研究院
	end
end

--@brief	穿上回调
function WndEquipNew:onItemWear(luaTable,tData)
	WZLog("穿上回调")
	if self.m_tItemBack then
		self.m_tItemBack[2](self.m_tItemBack[1],2,tData)
	end
end

--@brief	御下回调
function WndEquipNew:onItemRoyal(luaTable,tData)
	WZLog("WndEquipNew:onItemRoyal御下回调",luaTable)
	if self.m_tItemBack then
		self.m_tItemBack[2](self.m_tItemBack[1],3,tData)
	end
end

--@brief	使用回调
function WndEquipNew:onItemApply(luaTable,tData)
	WZLog("WndEquipNew:onItemApply使用回调",luaTable,tData.id)
	if self.m_tItemBack then
		self.m_tItemBack[2](self.m_tItemBack[1],4,tData)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   更新装备
function WndEquipNew:_updateItem()
	--WZLog("WndEquipNew:_updateItem",debug.traceback())
	WZLog("WndEquipNew:_updateItem")
	if self.m_root == nil or self.m_tItem == nil then
		return
	end
	self:cleanBag()
	self.m_nAddGridIndex = 1
	self.m_root:enableSchedule("_updateItem1",0)
end

--@brief	每帧更新一排装备
function WndEquipNew:_updateItem1(element, t)
	self.m_root:disableSchedule()
	--如果格子对象列表为nil,初始化为空表格
	if self.m_tGridList == nil then self.m_tGridList = {} end
	WZLog("格子总数",#self.m_tGridList)

	local tableConGoods = GetElement(self.m_root,"tableConGoods_WndEquipNew",WZUITableContainer)
	tableConGoods:setLoadCountPerFrame(4)

	--if self.m_nAddGridIndex <= #self.m_tItem then	
		local start = self.m_nAddGridIndex
		--local endIndex = math.min(self.m_nAddGridIndex+15,#self.m_tItem)
		local endIndex = #self.m_tItem
		for i=start,endIndex do
			if self.m_tGridList[i] == nil then
				--格子不够,创建格子
				local celElement,tCell = CellGrid:createElement()
				if celElement and tCell then
					celElement:setTag(i-1)
					tableConGoods:setCellElement(celElement)
					tCell:setCellGoodItem(self.m_tItem[i],2)
					tCell:setItemClickFun(self,self.onItemClick)
					table.insert(self.m_tGridList,tCell)
				end
			else
				--有格子,直接设置
				self.m_tGridList[i]:setCellGoodItem(self.m_tItem[i],2)
				self.m_tGridList[i]:setItemClickFun(self,self.onItemClick)
			end 
			self.m_nAddGridIndex = self.m_nAddGridIndex + 1
		end
	--else
		--element:disableSchedule()
		--设置格子数量
    	GetElement(self.m_root, "itemNum_WndEquipNew", WZUILabelTTF):setText(#self.m_tItem.."/"..CacheCenter:getGameParam().gridNum)
		self:_createEmptyItem(tableConGoods,#self.m_tGridList)--创建空白Item
		--将剩下的格子设置为空
		for i=#self.m_tItem+1,#self.m_tGridList do
			self.m_tGridList[i]:removeAllChild()
		end
		self:_setTableconPostion()

    	-- local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
    	-- local isEndTeach26, step26 = TeachGroup1:isTeachFinish(26)
    	-- WZLog("WndEquipNew:_updateItem",step8 )
    	-- if isEndTeach8 ~= true and step8 > 0 and step8 < 5 then
    	-- 	PostPlayerEvent:postEvent(PostPlayerEvent.event_fourLvChooseEquip)
    	--     TeachGroup1:startGroup({8,4, tableConGoods})
    	-- end
	--end
end

--@param	创建空白Item
--@param	tableConGoods:容器对象
--@param	总格子数,大于20且是4整数倍时直接返回
function WndEquipNew:_createEmptyItem(tableConGoods,num)
	local maxCount = 20
	if num > 20 then
		if num % 4 == 0 then
			maxCount = 0
		else
			maxCount = 4 - num %4
		end
	else
		maxCount = 20-num
	end
	if tableConGoods == nil or maxCount == 0 then
		return 
	end
	for i=1,maxCount do
		local celElement,tCell = CellGrid:createElement()
		if celElement and tCell then
			celElement:setTag(num+i-1)
			tableConGoods:setCellElement(celElement)
			tCell:setItemClickFun(self,self.onItemClick)
			table.insert(self.m_tGridList,tCell)
		end
	end

end

--@brief	清空背包
function WndEquipNew:cleanBag()
	local tableConGoods = self.m_root:getChildElement("tableConGoods_WndEquipNew")
	tableConGoods = WZUITableContainer:luaTo(tableConGoods)
	tableConGoods:cleanTable()
	self.m_tGridList = {}
end

--@brief   设置复选框文本颜色
function WndEquipNew:_setTextColorByTag(tag)
	WZLog("WndEquipNew:_setTextColorByTag")
    GetElement(self.m_root, "imgAll_WndEquipNew", WZUI9Image):setVisible(false)
    GetElement(self.m_root, "imgArms_WndEquipNew", WZUI9Image):setVisible(false)
    GetElement(self.m_root, "imgDress_WndEquipNew", WZUI9Image):setVisible(false)
    GetElement(self.m_root, "imgOther_WndEquipNew", WZUI9Image):setVisible(false)
    GetElement(self.m_root, "imgGem_WndEquipNew", WZUI9Image):setVisible(false)
    GetElement(self.m_root, "imgSkin_WndEquipNew", WZUI9Image):setVisible(false)
	if tag == 1 then
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquipNew"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtOther_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtGem_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtSkin_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgArms_WndEquipNew", WZUI9Image):setVisible(true)
	elseif tag == 2 then
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquipNew"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtOther_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtGem_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtSkin_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgDress_WndEquipNew", WZUI9Image):setVisible(true)
	elseif tag == 3 then
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtOther_WndEquipNew"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtGem_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtSkin_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgOther_WndEquipNew", WZUI9Image):setVisible(true)
	elseif tag == 4 then
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtGem_WndEquipNew"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtOther_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtSkin_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgGem_WndEquipNew", WZUI9Image):setVisible(true)
	elseif tag == 5 then
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtGem_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtOther_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtSkin_WndEquipNew"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgSkin_WndEquipNew", WZUI9Image):setVisible(true)
	else
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtOther_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquipNew"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtSkin_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtGem_WndEquipNew"),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgAll_WndEquipNew", WZUI9Image):setVisible(true)
	end
end

--@brief   多语言版本文本
function WndEquipNew:_moreLanguage()
	local tCell = nil 
	--全部
	tCell = self.m_root:getChildElement("txtAll_WndEquipNew")
	self:_setTxtDesc(tCell,LocalStrings.CHAT_ALL)
	--武器
	tCell = self.m_root:getChildElement("txtArms_WndEquipNew")
	self:_setTxtDesc(tCell,LocalStrings.EQUIP)
	--装扮
	tCell = self.m_root:getChildElement("txtDress_WndEquipNew")
	self:_setTxtDesc(tCell,LocalStrings.PROP)
	--其它
	tCell = self.m_root:getChildElement("txtOther_WndEquipNew")
	self:_setTxtDesc(tCell,LocalStrings.MATERIAL)
	--出售
	tCell = self.m_root:getChildElement("txtSale_WndEquipNew")
	self:_setTxtDesc(tCell,LocalStrings.SELL)
	tCell = nil 
end

--@brief   文本颜色和描边颜色
function WndEquipNew:_setTextColor(txt,color,strcolor)
	if self.m_root == nil or txt == nil then
		return
	end
	color = color or GlobalMethod:ccc3(127,70,26)

	txt = WZUILabelTTF:luaTo(txt)
	txt:setColor(color)
	if strcolor then
		txt:setEnableStroke(true)
		txt:setStrokeColor(strcolor)
	else
		txt:setEnableStroke(false)
	end
	color = nil 
	strcolor = nil 
end

function WndEquipNew:_setTableconPostion()
	local tablecon = WZUITableContainer:luaTo(self.m_root:getChildElement("tableConGoods_WndEquipNew"))
	local moveEle= tablecon:getMoveElement()
	self.m_nY = self.m_nY or moveEle:getPositionY()
	moveEle:setPositionY(self.m_nY)
	tablecon:updateTopDownPosition()
	if self.m_nBagIndex ~= 3 then
		self.m_nY = nil 
	end
end

function WndEquipNew:_getMovePostion()
	local tablecon = WZUITableContainer:luaTo(self.m_root:getChildElement("tableConGoods_WndEquipNew"))
	local moveEle= tablecon:getMoveElement()
	local b = moveEle:getPositionY()
	WZLog("mvoePt:::",b)
	return b
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------
function WndEquipNew:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtOther_WndEquipNew",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtSkin_WndEquipNew",WZUILabelTTF):setScale(0.55)
end

function WndEquipNew:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtSkin_WndEquipNew",WZUILabelTTF):setFontSize(18)
end
function WndEquipNew:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtOther_WndEquipNew",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtGem_WndEquipNew",WZUILabelTTF):setFontSize(18)
	GetElement(self.m_root,"txtSale_WndEquipNew",WZUILabelTTF):setScale(0.8)
end

function WndEquipNew:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtOther_WndEquipNew",WZUILabelTTF):setFontSize(22)

	GetElement(self.m_root,"txtSkin_WndEquipNew",WZUILabelTTF):setFontSize(20)
end

function WndEquipNew:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtOther_WndEquipNew",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtDress_WndEquipNew",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtSkin_WndEquipNew",WZUILabelTTF):setFontSize(16)
end

function WndEquipNew:_adaptLanguage_ug(  )
	GetElement(self.m_root,"txtOther_WndEquipNew",WZUILabelTTF):setScale(0.6)

	GetElement(self.m_root,"txtSale_WndEquipNew",WZUILabelTTF):setScale(0.7)
end
-------------------------------------语言适配模块End----------------------------------------



