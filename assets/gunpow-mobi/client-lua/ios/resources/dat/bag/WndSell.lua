--WndSell.lua
--@brief	WndSell的UI模块
--@date		2015/07/03
--@author	zsq
--@note		出售背包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSell:onEnter(element)
	self.m_root = element
	self:_moreLanguage()
	AdaptLanguage(self)
end

function WndSell:onEnterTransitionDidFinish(element)
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品
	self.m_nIndex = 1
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSell:onExit(element)
	CacheCenter:unregisterUpatePlayerItemObserver(self)
	self:_unInit()
end

function WndSell:_moreLanguage()
	GetElement(self.m_root,"ttfBagTitle_WndBag",WZUILabelTTF):setText(LocalStrings.WNDPLAYERINFO5)
end

function WndSell:onSaleClick() 
	WndEquipNew:onSaleClick()
end

function WndSell:onSynthesis() 
	WndEquipNew:onSynthesis()
end

function WndSell:onCloseClick() 
	if self.m_root == nil then return end
	WndBagRole:onCloseClick()
end

--@brief	全部复选框回调
function WndSell:onTab1(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("全部复选框回调")
	if self.m_nIndex == 1 then
		return 
	end
	self.m_nIndex = 1
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(true)
end

--@brief	装备复选框回调
function WndSell:onTab2(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("装备复选框回调")
	if self.m_nIndex == 2 then
		return 
	end
	self.m_nIndex = 2
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(true)
end

--@brief	道具复选框回调
function WndSell:onTab3(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("道具复选框回调")
	if self.m_nIndex == 3 then
		return 
	end
	self.m_nIndex = 3
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
end

--@brief	材料复选框回调
function WndSell:onTab4(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("材料复选框回调")
	if self.m_nIndex == 4 then
		return 
	end
	self.m_nIndex = 4
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
end

--@brief	宝石复选框回调
function WndSell:onTab5(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WZLog("宝石复选框回调")
	if self.m_nIndex == 5 then
		return 
	end
	self.m_nIndex = 5
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_setTextColorByTag(self.m_nIndex)
	self:_update(false)
	GetElement(self.m_root,"btn3",WZUIButton):setVisible(false)
end

function WndSell:onSelect(element)
	WZLog("WndSell:onSelect")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	if self.m_tSellList == nil then self.m_tSellList = {} end
	local sellCount = #self.m_tSellList
	local find = false
	for i=1,#self.m_tData do
		local tData = self.m_tData[i]
		--紫色品质以下的装备
		if tData.basicInfo.main_type == 4 and tData.basicInfo.quality < 3 and tData.sellHook ~= true and sellCount < 16 then
			WndSell:onRightItemClick(nil, i-1, tData)	
			sellCount = sellCount + 1
			find = true
		end
	end

	if not find then
		if sellCount == 16 then
			MsgBoxManager:showTipBox(LocalStrings.BAGTIP4)
		else
			MsgBoxManager:showTipBox(LocalStrings.QUICKSELECT4)
		end
	end

	GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF):setText(LocalStrings.PETRECOVERNUM..#self.m_tSellList.."/16")
end

--@brief	右边物品点击回调
function WndSell:onRightItemClick(lua,tag,tData)
	WZLog("WndSell:onRightItemClick",tag)
	if self.m_root == nil or tData == nil then
		return
	end
	if tag == nil then return end

	--记录出售物品列表
	if self.m_tSellList == nil then self.m_tSellList = {} end
	
	--一次最多回收16类物品
	if (self.m_tData[tag+1].sellHook == nil or self.m_tData[tag+1].sellHook == false) and #self.m_tSellList >= 16 then 
		MsgBoxManager:showTipBox(LocalStrings.BAGTIP4)
		return
	end

	self.m_nTag = tag
	local tDataList = self.m_tData


	--物品状态为未出售，则选中出售，左边出售列表增加该物品
	if tDataList[tag+1].sellHook == false or tDataList[tag+1].sellHook == nil then
		local tItem = tDataList[tag+1]

		if self:isUseTimeLimit(tDataList[tag+1]) then
		  --MsgBoxManager:showConfirmCancelBox(LocalStrings.USINGLIMITEQUIP or "", self, self.useLimitCall, nil)
		  MsgBoxManager:showConfirmBoxWithBg(LocalStrings.USINGLIMITEQUIP or "", self, self.useLimitCall, MSGBOXLEVEL_HIGH, {[MSGBOXUICFG_USEFREETXT] = true})
			return
		end

		--出售坐骑兑换卡前确认
		if tItem.basicInfo.main_type == 2 and tItem.basicInfo.sub_type == 11 then
			MsgBoxManager:showConfirmCancelBox(LocalStrings.SELLINFO1, self, self.sellhorse, MSGBOXLEVEL_HIGH,nil)
			return
		end

		if tDataList[tag+1].lastNum == 1 then
			tDataList[tag+1].sellHook = true
			local tempData = CopyTable(tDataList[tag+1])
			tempData.sellHook = false
			table.insert(self.m_tSellList,tempData)
			WndSellList:_update()
			self.m_tData = self:getCurData()
			self:_update(true)
		else
			WndSellNum:show(tDataList[tag+1])
		end
	else
	--物品状态为出售，则取消出售，左边出售列表删除该物品
		tDataList[tag+1].sellHook = false
		for i=1,#self.m_tSellList do
			if self.m_tSellList[i].playerItemId == tDataList[tag+1].playerItemId then
				table.remove(self.m_tSellList,i)
				break
			end
		end
		self.m_tData = self:getCurData()
		self:_update(true)
		WndSellList:_update()
	end

	GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF):setText(LocalStrings.PETRECOVERNUM..#self.m_tSellList.."/16")
end

function WndSell:sellhorse(nId, nResType) 
	if nResType ~= MSGBOXRESTYPE_CONFIRM then return end
	self:useLimitCall()
end

function WndSell:useLimitCall(nId, nResType) 
	WZLog("WndSell:useLimitCall")

	local tDataList = self.m_tData
	local tag = self.m_nTag

	--物品状态为未出售，则选中出售，左边出售列表增加该物品
	if tDataList[tag+1].sellHook == false or tDataList[tag+1].sellHook == nil then
		if tDataList[tag+1].lastNum == 1 then
			tDataList[tag+1].sellHook = true
			local tempData = CopyTable(tDataList[tag+1])
			tempData.sellHook = false
			table.insert(self.m_tSellList,tempData)
			WndSellList:_update()
			self.m_tData = self:getCurData()
			self:_update(true)
		else
			WndSellNum:show(tDataList[tag+1])
		end
	else
	--物品状态为出售，则取消出售，左边出售列表删除该物品
		tDataList[tag+1].sellHook = false
		for i=1,#self.m_tSellList do
			if self.m_tSellList[i].playerItemId == tDataList[tag+1].playerItemId then
				table.remove(self.m_tSellList,i)
				break
			end
		end
		self.m_tData = self:getCurData()
		self:_update(true)
		WndSellList:_update()
	end
	GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF):setText(LocalStrings.PETRECOVERNUM..#self.m_tSellList.."/16")
end

function WndSell:onRightItemClick1(tData)
	tData.sellHook = false
	table.insert(self.m_tSellList,tData)
	self.m_tData = self:getCurData()
	self:_update(true)
	WndSellList:_update()
end

--@brief	出售成功,刷新列表
function WndSell:updatePlayerItemData()
	WZLog("WndSell:updatePlayerItemData")
	if self.m_root == nil then return end
	 
    local tbconList = GetElement(self.m_root, "tableCon_WndSell", WZUITableContainer)
    local nCurPositionY = tbconList:getMoveElement():getPositionY()
    local tLastSize = tbconList:getMoveElement():getContentSize()

	--首先清空列表
	self:cleanBag()
	self.m_tData = self:getCurData()
	self:_update()

    --重新设置列表的位置
    local tCurSize = tbconList:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > tbconList:getMaxPosition().y then
        nTempPositionY = tbconList:getMaxPosition().y
    end
    tbconList:getMoveElement():setPositionY(nTempPositionY)
end

--@brief	是否正在使用限时装备
function WndSell:isUseTimeLimit(tData) 
	if tData.basicInfo.main_type ~= 4 then return false end

	local tDataList = CacheCenter:getEquipedList()
	if tData.basicInfo.main_type == 4 and tData.basicInfo.sub_type == 0 or tData.basicInfo.sub_type == 1 then
		for i=1,#tDataList do
			if tDataList[i].basicInfo.main_type == 4 and (tDataList[i].basicInfo.sub_type == 0 or tDataList[i].basicInfo.sub_type == 1) and tDataList[i].basicInfo.time_limit ~= -1 then
				return true
			end
		end
	end

	for i=1,#tDataList do
		if tDataList[i].basicInfo.main_type == 4 and tDataList[i].basicInfo.sub_type == tData.basicInfo.sub_type and tDataList[i].basicInfo.time_limit ~= -1 then
			return true
		end
	end
	return false
end

--@brief	获得该装备部位拥有几件装备
function WndSell:hasEquipNum(tData) 
	return 1
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	刷新出售物品
--@param 	bResetPosition 为true，则不重置，否则，重新刷新表
function WndSell:_update(bResetPosition)
	WZLog("WndSell:_update")
	if self.m_root == nil then
		return
	end
	local bResetPositionY = bResetPosition or false
	local tableConRight = WZUITableContainer:luaTo(self.m_root:getChildElement("tableCon_WndSell"))
	tableConRight:setLoadCountPerFrame(4)
	local tablePositionY = tableConRight:getMoveElement():getPositionY()

	--如果格子对象列表为nil,初始化为空表格
	if self.m_tGridList == nil then self.m_tGridList = {} end

	for i=1,#self.m_tData do
		if self.m_tSellList ~= nil then
			for k=1,#self.m_tSellList do
				if self.m_tSellList[k].playerItemId == self.m_tData[i].playerItemId then
					self.m_tData[i].sellHook = true
					self.m_tData[i].lastNum =  self.m_tData[i].lastNum - self.m_tSellList[k].lastNum
				end
			end
		end
		if self.m_tGridList[i] == nil then
			--格子不够,创建格子
			local celElement,tCell = CellGrid:createElement()
			if celElement and tCell then
				celElement:setTag(i-1)
				tableConRight:setCellElement(celElement)
				tCell:setCellGoodItem(self.m_tData[i], 30)
				tCell:setItemClickFun(self,self.onRightItemClick)
				table.insert(self.m_tGridList,tCell)
			end
		else
			--有格子,直接设置
			self.m_tGridList[i]:setCellGoodItem(self.m_tData[i], 30)
			self.m_tGridList[i]:setItemClickFun(self,self.onRightItemClick)
		end 
	end

	self:_createEmptyItem(tableConRight,#self.m_tGridList)--创建空白Item
	--将剩下的格子设置为空
	for i=#self.m_tData+1,#self.m_tGridList do
		self.m_tGridList[i]:removeAllChild()
	end
	--Add By Tianxiang_Xu
	if bResetPositionY then
		tableConRight:getMoveElement():setPositionY(tablePositionY)
	else
		tableConRight:getMoveElement():setPositionY(tableConRight:getMinPosition().y)
	end
	GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF):setText(LocalStrings.PETRECOVERNUM..#self.m_tSellList.."/16")
end

--@param	创建空白Item
function WndSell:_createEmptyItem(tableConGoods,num)
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
			tCell:setItemClickFun(self,self.onRightItemClick)
			table.insert(self.m_tGridList,tCell)
		end
	end
end

--@brief	清空背包
function WndSell:cleanBag()
	local tableConGoods = self.m_root:getChildElement("tableCon_WndSell")
	tableConGoods = WZUITableContainer:luaTo(tableConGoods)
	tableConGoods:cleanTable()
	self.m_tGridList = {}
end

--@brief   设置复选框文本颜色
function WndSell:_setTextColorByTag(tag)
	WZLog("WndSell:_setTextColorByTag",tag)
	for i=1,5 do
		self:_setTextColor(self.m_root:getChildElement("txtTab"..i.."_WndSell"),GlobalMethod:ccc3(255,236,193),GlobalMethod:ccc3(105,65,46))
    	GetElement(self.m_root, "imgTab"..i.."_WndSell", WZUI9Image):setVisible(false)
	end
	self:_setTextColor(self.m_root:getChildElement("txtTab"..tag.."_WndSell"))
   	GetElement(self.m_root, "imgTab"..tag.."_WndSell", WZUI9Image):setVisible(true)
end

--@brief   文本颜色和描边颜色
function WndSell:_setTextColor(txt,color,strcolor)
	WZLog("WndRecover:_setTextColor")
	if self.m_root == nil or txt == nil then
		return
	end
	local color = color or GlobalMethod:ccc3(255,236,193)
	local strcolor = strcolor or GlobalMethod:ccc3(128,54,13)
	txt = WZUILabelTTF:luaTo(txt)
	txt:setColor(color)
	txt:setStrokeColor(strcolor)
end



-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin-----------------------------------------
function WndSell:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF):setFontSize(22)

	local txtQuickSelect = GetElement(self.m_root,"txtQuickSelect_WndEquipNew",WZUILabelTTF)
	txtQuickSelect:setScale(0.7)
	txtQuickSelect:setDimensions(GlobalMethod:CCSize(160))

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
end


function WndSell:_adaptLanguage_th(  )
	GetElement(self.m_root,"ttfBagTitle_WndBag",WZUILabelTTF):setText(LocalStrings.WNDPLAYERINFO5)

	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.8)
end

function WndSell:_adaptLanguage_pt(  )
	local txtTab1 = GetElement(self.m_root,"txtTab1_WndSell",WZUILabelTTF)
    local txtTab2 = GetElement(self.m_root,"txtTab2_WndSell",WZUILabelTTF)
    local txtTab3 = GetElement(self.m_root,"txtTab3_WndSell",WZUILabelTTF)
    local txtTab4 = GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF)

    txtTab1:setFontSize(22)
    txtTab2:setFontSize(22)
    txtTab3:setFontSize(22)
    txtTab4:setFontSize(22)

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
	
	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))

	local txtQuickSelect = GetElement(self.m_root,"txtQuickSelect_WndEquipNew",WZUILabelTTF)
	txtQuickSelect:setScale(0.7)
	txtQuickSelect:setDimensions(GlobalMethod:CCSize(160))
    
    -- GetElement(self.m_root,"imgArrow1_WndEquip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.23,0.945))
    -- GetElement(self.m_root,"imgArrow2_WndEquip",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.77,0.945))
end

function WndSell:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtTab5_WndSell",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtSale_WndEquipNew",WZUILabelTTF):setScale(0.7)

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
end

function WndSell:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtTab2_WndSell",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtTab3_WndSell",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtTab4_WndSell",WZUILabelTTF):setFontSize(22)

	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
	
	local txtQuickSelect = GetElement(self.m_root,"txtQuickSelect_WndEquipNew",WZUILabelTTF)
	txtQuickSelect:setScale(0.7)
	txtQuickSelect:setDimensions(GlobalMethod:CCSize(160))


end

function WndSell:_adaptLanguage_vn(  )
	-- GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF):setScale(0.7)
	
	local txtChoiceNum = GetElement(self.m_root,"txtChoiceNum_WndSell",WZUILabelTTF)
	txtChoiceNum:setScale(0.7)
	txtChoiceNum:setDimensions(GlobalMethod:CCSize(240))
	local txtChoice = GetElement(self.m_root,"txtChoice_WndSell",WZUILabelTTF)
	txtChoice:setScale(0.7)
	txtChoice:setDimensions(GlobalMethod:CCSize(280))
end
-------------------------------------语言适配End-------------------------------------------
