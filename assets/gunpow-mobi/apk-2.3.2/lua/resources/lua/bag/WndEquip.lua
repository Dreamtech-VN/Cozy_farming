--WndEquip
--@date		2014/01/07
--@author	zsq
--@note		玩家物品项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndEquip:onEnter(element)
	self.m_root = element
end

--@brief	加载资源完成后
function WndEquip:onEnterTransitionDidFinish(element)
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	self:_moreLanguage()
	AdaptLanguage(self)
	--self.m_root:enableSchedule("onFinishLoad",0)
	self:onFinishLoad()
end

--@brief	延迟一帧加载背包物品
function WndEquip:onFinishLoad(element,t)
	if self.m_root == nil then return end
	--element:disableSchedule()
	self.m_nBagIndex = 0
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setAllData(CacheCenter:getEquipAllList(self.allSub))
	self:_updateItem()--更新装备
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndEquip:onExit(element)
	self:_unInit()
	CacheCenter:unregisterUpatePlayerItemObserver(self)
    Teach:isStartTeach("WndEquip:onExit")
end

--@brief	点击合成回调
function WndEquip:onSynthesis(element)
	WZLog("WndEquip:onSynthesis")
	if WndItemInfo.m_root ~= nil then return end
	WndBag:onSynthesis(element)
end

--@brief	点击出售回调
function WndEquip:onSaleClick(element)
	WZLog("WndEquip:onSaleClick", WndItemInfo.m_root ~= nil)
	if WndItemInfo.m_root ~= nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --MsgBoxManager:showTipBox("此功能暂未开放")
	--do return end
	if self.m_tBtnFun then
		self.m_tBtnFun[3](self.m_tBtnFun[1])
	end
	WndBag:onSaleClick()
end

--@brief	全部复选框回调
function WndEquip:onAllSelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("全部复选框回调")
	--if self.m_nBagIndex == 0 then
	--	return
	--end
	self.allSub = nil
	self.m_nY = nil 
	self.m_nBagIndex = 0
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setAllData(CacheCenter:getEquipAllList(self.allSub))
	self:_updateItem()--更新装备
    GetElement(self.m_root, "itemNum_WndEquip", WZUILabelTTF):setVisible(false)
end

--@brief	武器复选框回调
function WndEquip:onArmsSelect(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("武器复选框回调")
	if self.m_nBagIndex == 1 then
		return
	end
	self.m_nY = nil 
	self.m_nBagIndex = 1
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setArmsData(CacheCenter:getWeaponList())
	self:_updateItem()--更新装备
    GetElement(self.m_root, "itemNum_WndEquip", WZUILabelTTF):setVisible(false)
end

--@brief	防具复选框回调
function WndEquip:onDefendSelect(element)
	WZLog("防具复选框回调")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_nBagIndex == 2 then
		return
	end
	self.m_nY = nil 
	self.m_nBagIndex = 2
	self.m_nItem = 1
	self:_setTextColorByTag(self.m_nBagIndex)
	self:setDressData(CacheCenter:getDefendList())
	self:_updateItem()--更新道具列表
    GetElement(self.m_root, "itemNum_WndEquip", WZUILabelTTF):setVisible(false)
end

--@brief	宝石复选框回调
function WndEquip:onGemSelect(element)
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
    GetElement(self.m_root, "itemNum_WndEquip", WZUILabelTTF):setVisible(false)
end

--@brief	材料复选框回调
function WndEquip:onOthersSelect(element)
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
    GetElement(self.m_root, "itemNum_WndEquip", WZUILabelTTF):setVisible(false)
end

--@brief	皮肤复选框回调
function WndEquip:onSkinSelect(element)
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
    GetElement(self.m_root, "itemNum_WndEquip", WZUILabelTTF):setVisible(false)
end

--@brief	Item点击回调
function WndEquip:onItemClick(luaTable,tag,tData)
	self.m_nY = self:_getMovePostion()
	if tData == nil then
		return
	elseif self.m_tItemBack then
		self.m_tItemBack[3](self.m_tItemBack[1],1)
	end
	self.m_nItem = tag
	local parent = WZUIContainer:luaTo(WndBag.m_root:getChildElement("conRightB_WndBag"))
	local tItem = CopyTable(self.m_tItem[tag+1])
	if self.m_nBagIndex ~= 3 then
		tItem.lock = 2 
	end
	self:_addTip(tItem,luaTable.m_root,parent)--添加tip信息
end

--@brief	强化回调
function WndEquip:onStrengthen(luaTable,tData)
	if (luaTable == nil or tonumber(luaTable) ~= nil ) and self.m_tItemBack then
		self.m_tItemBack[2](self.m_tItemBack[1],5,luaTable or 0)--关闭强化研究院返回0:没变化
	else
		self.m_tItemBack[2](self.m_tItemBack[1],5,-1)--打开强化研究院
	end
end

--@brief	穿上回调
function WndEquip:onItemWear(luaTable,tData)
	WZLog("穿上回调")
	if self.m_tItemBack then
		self.m_tItemBack[2](self.m_tItemBack[1],2,tData)
	end
end

--@brief	御下回调
function WndEquip:onItemRoyal(luaTable,tData)
	WZLog("WndEquip:onItemRoyal御下回调",luaTable)
	if self.m_tItemBack then
		self.m_tItemBack[2](self.m_tItemBack[1],3,tData)
	end
end

--@brief	使用回调
function WndEquip:onItemApply(luaTable,tData)
	WZLog("WndEquip:onItemApply使用回调",luaTable,tData.id)
	if self.m_tItemBack then
		self.m_tItemBack[2](self.m_tItemBack[1],4,tData)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   更新装备
function WndEquip:_updateItem()
	--WZLog("WndEquip:_updateItem",debug.traceback())
	WZLog("WndEquip:_updateItem")
	if self.m_root == nil or self.m_tItem == nil then
		return
	end
	self:cleanBag()
	self.m_nAddGridIndex = 1
	self.m_root:enableSchedule("_updateItem1",0)
end

--@brief	每帧更新一排装备
function WndEquip:_updateItem1(element, t)
	self.m_root:disableSchedule()
	--如果格子对象列表为nil,初始化为空表格
	if self.m_tGridList == nil then self.m_tGridList = {} end
	WZLog("格子总数",#self.m_tGridList)

	local tableConGoods = GetElement(self.m_root,"tableConGoods_WndEquip",WZUITableContainer)
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
					tCell:clearItemQualityPic()
					tCell:setItemClickFun(self,self.onItemClick)
					celElement:setScale(0.95)
					table.insert(self.m_tGridList,tCell)
				end
			else
				--有格子,直接设置
				self.m_tGridList[i]:setCellGoodItem(self.m_tItem[i],2)
				self.m_tGridList[i]:clearItemQualityPic()
				self.m_tGridList[i]:setItemClickFun(self,self.onItemClick)
			end 
			self.m_nAddGridIndex = self.m_nAddGridIndex + 1
		end
	--else
		--element:disableSchedule()
		--设置格子数量
    	GetElement(self.m_root, "itemNum_WndEquip", WZUILabelTTF):setText(#self.m_tItem.."/"..CacheCenter:getGameParam().gridNum)
		self:_createEmptyItem(tableConGoods,#self.m_tGridList)--创建空白Item
		--将剩下的格子设置为空
		for i=#self.m_tItem+1,#self.m_tGridList do
			self.m_tGridList[i]:removeAllChild()
		end
		self:_setTableconPostion()

    	-- local isEndTeach8, step8 = TeachGroup1:isTeachFinish(8)
    	-- local isEndTeach26, step26 = TeachGroup1:isTeachFinish(26)
    	-- WZLog("WndEquip:_updateItem",step8 )
    	-- if isEndTeach8 ~= true and step8 > 0 and step8 < 5 then
    	-- 	PostPlayerEvent:postEvent(PostPlayerEvent.event_fourLvChooseEquip)
    	--     TeachGroup1:startGroup({8,4, tableConGoods})
    	-- end
	--end
end

--@param	创建空白Item
--@param	tableConGoods:容器对象
--@param	总格子数,大于20且是4整数倍时直接返回
function WndEquip:_createEmptyItem(tableConGoods,num)
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
			celElement:setScale(0.95)
			tCell:setItemClickFun(self,self.onItemClick)
			table.insert(self.m_tGridList,tCell)
		end
	end

end

--@brief	清空背包
function WndEquip:cleanBag()
	local tableConGoods = self.m_root:getChildElement("tableConGoods_WndEquip")
	tableConGoods = WZUITableContainer:luaTo(tableConGoods)
	tableConGoods:cleanTable()
	self.m_tGridList = {}
end

--@brief   设置复选框文本颜色
function WndEquip:_setTextColorByTag(tag)
	WZLog("WndEquip:_setTextColorByTag")
    GetElement(self.m_root, "imgAll_WndEquip", WZUI9Image):setVisible(false)
    GetElement(self.m_root, "imgArms_WndEquip", WZUI9Image):setVisible(false)
    GetElement(self.m_root, "imgDress_WndEquip", WZUI9Image):setVisible(false)
	if tag == 1 then
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquip"))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquip"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquip"),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgArms_WndEquip", WZUI9Image):setVisible(true)
	elseif tag == 2 then
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquip"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquip"))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquip"),GlobalMethod:ccc3(127,70,26))
    	GetElement(self.m_root, "imgDress_WndEquip", WZUI9Image):setVisible(true)
	elseif tag == 0 then
		self:_setTextColor(self.m_root:getChildElement("txtArms_WndEquip"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtDress_WndEquip"),GlobalMethod:ccc3(127,70,26))
		self:_setTextColor(self.m_root:getChildElement("txtAll_WndEquip"))
    	GetElement(self.m_root, "imgAll_WndEquip", WZUI9Image):setVisible(true)
	end
end

--@brief   多语言版本文本
function WndEquip:_moreLanguage()
	local tCell = nil 
	--全部
	tCell = self.m_root:getChildElement("txtAll_WndEquip")
	self:_setTxtDesc(tCell,LocalStrings.CHAT_ALL)
	--武器
	tCell = self.m_root:getChildElement("txtArms_WndEquip")
	self:_setTxtDesc(tCell,LocalStrings.EQUIP)
	--装扮
	tCell = self.m_root:getChildElement("txtDress_WndEquip")
	self:_setTxtDesc(tCell,LocalStrings.PROP)
	tCell = nil 
end

--@brief   文本颜色和描边颜色
function WndEquip:_setTextColor(txt,color,strcolor)
	if self.m_root == nil or txt == nil then
		return
	end
	if color and strcolor == nil then
		txt = WZUILabelTTF:luaTo(txt)
		txt:setEnableStroke(false)
		txt:setColor(color)
		return
	end
	color = color or GlobalMethod:ccc3(255,236,193)
	strcolor = strcolor or GlobalMethod:ccc3(132,66,29)
	txt = WZUILabelTTF:luaTo(txt)
	txt:setEnableStroke(true)
	txt:setColor(color)
	txt:setStrokeColor(strcolor)
	color = nil 
	strcolor = nil 
end

function WndEquip:_setTableconPostion()
	local tablecon = WZUITableContainer:luaTo(self.m_root:getChildElement("tableConGoods_WndEquip"))
	local moveEle= tablecon:getMoveElement()
	self.m_nY = self.m_nY or moveEle:getPositionY()
	moveEle:setPositionY(self.m_nY)
	tablecon:updateTopDownPosition()
	if self.m_nBagIndex ~= 3 then
		self.m_nY = nil 
	end
end

function WndEquip:_getMovePostion()
	local tablecon = WZUITableContainer:luaTo(self.m_root:getChildElement("tableConGoods_WndEquip"))
	local moveEle= tablecon:getMoveElement()
	local b = moveEle:getPositionY()
	WZLog("mvoePt:::",b)
	return b
end
-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配模块Begin----------------------------------------

function WndEquip:_adaptLanguage_vn()
    WZLog("WndEquip:_adaptLanguage_vn ")
    local txtAll = GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF)
    local txtArms = GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF)
    local txtDress = GetElement(self.m_root,"txtDress_WndEquip",WZUILabelTTF)
    --local txtOther = GetElement(self.m_root,"txtOther_WndEquip",WZUILabelTTF)

    txtAll:setFontSize(22)
    txtArms:setFontSize(22)
    txtDress:setFontSize(22)
    --txtOther:setFontSize(22)
end

function WndEquip:_adaptLanguage_th()
    WZLog("WndEquip:_adaptLanguage_th ")
    -- local txtAll = GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF)
    -- local txtArms = GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF)
    local txtDress = GetElement(self.m_root,"txtDress_WndEquip",WZUILabelTTF)
    --local txtOther = GetElement(self.m_root,"txtOther_WndEquip",WZUILabelTTF)

    -- txtAll:setFontSize(22)
    -- txtArms:setFontSize(22)
    txtDress:setFontSize(18)
    --txtOther:setFontSize(22)
end

function WndEquip:_adaptLanguage_en()
    WZLog("WndEquip:_adaptLanguage_en ")
    local txtAll = GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF)
    local txtArms = GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF)
    local txtDress = GetElement(self.m_root,"txtDress_WndEquip",WZUILabelTTF)
    --local txtOther = GetElement(self.m_root,"txtOther_WndEquip",WZUILabelTTF)

    txtAll:setFontSize(22)
    txtArms:setFontSize(20)
    txtDress:setFontSize(22)
    --txtOther:setFontSize(22)
end

function WndEquip:_adaptLanguage_pt(  )
	-- local txtAll = GetElement(self.m_root,"txtAll_WndEquip",WZUILabelTTF)
 --    local txtArms = GetElement(self.m_root,"txtArms_WndEquip",WZUILabelTTF)
    local txtDress = GetElement(self.m_root,"txtDress_WndEquip",WZUILabelTTF)
    --local txtOther = GetElement(self.m_root,"txtOther_WndEquip",WZUILabelTTF)

    -- txtAll:setFontSize(22)
    -- txtArms:setFontSize(22)
    txtDress:setFontSize(16)
    txtDress:setDimensions(GlobalMethod:CCSize(100,0))
    --txtOther:setFontSize(22)

    --GetElement(self.m_root,"imgArrow1_WndEquip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.23,0.945))
    --GetElement(self.m_root,"imgArrow2_WndEquip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.77,0.945))
end

function WndEquip:_adaptLanguage_tr(  )
	--GetElement(self.m_root,"txtOther_WndEquip",WZUILabelTTF):setFontSize(20)
	local txtSale = GetElement(self.m_root,"txtSale_WndEquip",WZUILabelTTF)
	txtSale:setScale(0.8)
	txtSale:setDimensions(GlobalMethod:CCSize(130,0))

	--GetElement(self.m_root,"txtGem_WndEquip",WZUILabelTTF):setFontSize(20)
end

function WndEquip:_adaptLanguage_es(  )
	local txtDress = GetElement(self.m_root,"txtDress_WndEquip",WZUILabelTTF)
	txtDress:setFontSize(16)
    txtDress:setDimensions(GlobalMethod:CCSize(100,0))
end

function WndEquip:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtDress_WndEquip",WZUILabelTTF):setFontSize(18)
end

function WndEquip:_adaptLanguage_ug(  )
	local txtDress = GetElement(self.m_root,"txtDress_WndEquip",WZUILabelTTF)
	txtDress:setScale(0.5)
    txtDress:setDimensions(GlobalMethod:CCSize(160,0))
end
-------------------------------------语言适配模块End----------------------------------------



