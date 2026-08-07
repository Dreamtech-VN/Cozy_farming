--WndRuneBag.lua
--@brief	WndRuneBag的UI模块
--@date		2017/03/21
--@author	qixiang
--@note		符文背包


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRuneBag:onEnter(element)
	self.m_root = element
	self:showList()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRuneBag:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--关闭界面
function WndRuneBag:onClickClose(element)
	-- body
	WZLog("WndRuneBag:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	if self.m_tCallbackLua and self.m_tCallbackFun then
		self.m_tCallbackFun(self.m_tCallbackLua,self.m_nSlotIndex,self.m_nRuneId)
	end
end

--显示背包列表的符文数据
function WndRuneBag:showList()
	WZLog("WndRuneBag:showList =",self.m_nRuneType)
	local getElement = GetElement
	local tabRuneList = getElement(self.m_root,"tabRuneList_WndRuneBag",WZUITableContainer)
	local rowIndex = tabRuneList:getCurrentRowIndex()
	local txtNullTip = getElement(self.m_root,"txtNullTip_WndRuneBag",WZUILabelTTF)
	local txtTitleName = getElement(self.m_root,"txtTitleName_WndRuneBag",WZUILabelTTF)
	local conRuneList = getElement(self.m_root,"conRuneList_WndRuneBag",WZUIContainer)
	tabRuneList:cleanTable()
	txtNullTip:setVisible(false)
	local conRuneStore = getElement(self.m_root,"conRuneStore_WndRuneBag",WZUIContainer)
	local conRuneDraw = getElement(self.m_root,"conRuneDraw_WndRuneBag",WZUIContainer)
	conRuneDraw:setVisible(true)
	conRuneStore:setVisible(true)
	local temp = {}
	local gDatatab_item = GDatatab_item
	local runeType = nil
	
	if self.m_nRuneType ~= nil then
		for i,v in ipairs(self.m_tRuneList) do
			runeType = gDatatab_item["id_"..v[1]].sub_type
			if runeType == self.m_nRuneType then
				table.insert(temp,v)
			end
	    end
	else
		temp = self.m_tRuneList
	end
	
	if temp == nil or not temp[1] then
		txtNullTip:setVisible(true)
		return
	end
	txtNullTip:setVisible(false)
	if self.m_nRuneType then
		table.sort( temp, function (a,b)
			if gDatatab_item["id_" ..a[1]].value > gDatatab_item["id_" .. b[1]].value then
				return true
			end
			return false
	    end)
    else
    	table.sort( temp, function (a,b)
    		local aRuneInfo = gDatatab_item["id_" ..a[1]]
    		local bRuneInfo = gDatatab_item["id_" ..b[1]]
    		local aRuneLevel = aRuneInfo.value
    		local bRuneLevel = bRuneInfo.value
			if aRuneLevel > bRuneLevel then
				return true
			elseif aRuneLevel == bRuneLevel then
				if aRuneInfo.sub_type == bRuneInfo.sub_type then
					if aRuneInfo.id > bRuneInfo.id then
						return true
					end
				elseif aRuneInfo.sub_type < bRuneInfo.sub_type then
					return true
				end
			end
			return false
	    end)
	end
	for i,v in ipairs(temp) do
		local cellRuneInfo ,luaObject = CellRuneInfo:createElement()
		cellRuneInfo:setTag(i-1)
		luaObject:setRuneIdAndNum(v[1],v[2])
		luaObject:setClickCallBack(self.onClickLoadCallback,self)
		tabRuneList:setCellElement(cellRuneInfo)
	end
	WZLog("rowIndex=",rowIndex)
	if rowIndex > 0 then
		--rowIndex = rowIndex
		tabRuneList:setContentOffsetByRowIndex(rowIndex)
	end
end


--批量出售
function WndRuneBag:toSellRune(element)
	WZLog("WndRuneBag:toSellRune")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local itemIds = {}
	local itemNums = {}
	local isUseds = {}
	for i,v in ipairs(self.m_tRuneList) do
		table.insert(itemIds,v[1])
		table.insert(itemNums,v[2])
		table.insert(isUseds,0)
	end
	WndSellRune:showWindow(itemIds,itemNums,isUseds)
end


--装载符文回调
--runeId : 符文ID
function WndRuneBag:onClickLoadCallback(runeId,cellTag)
	-- body
	WZLog("WndRuneBag:onClickLoadCallback ",runeId,self.m_nSlotIndex)
	if runeId and self.m_nSlotIndex then --查看全部的符文不能进行符文装载
		ProtocolProcessorSceneRune:send_RUNE_UpdateRune(self.m_nSlotIndex,runeId)
	else --没有选中槽位
		local itemInfo = GDatatab_item["id_" .. runeId]
		local subType = itemInfo.sub_type
		local slotIndex = SceneRune:findSlotBySlotType(subType)
		WZLog("slotIndex =",slotIndex)
		if slotIndex == nil then
			MsgBoxManager:showTipBox(LocalStrings.LOAD_SLOT_NULL_TIP)
		else
			ProtocolProcessorSceneRune:send_RUNE_UpdateRune(slotIndex,runeId)
		end
	end
end

--抽取符文
function WndRuneBag:toDrawRune(element)
	WZLog("WndRuneBag:toDrawRune")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	SceneRuneLockDraw:show()
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndRuneBag:_adaptLanguage_en(  )
	local txtDraw = GetElement(self.m_root,"txtDraw_WndRuneBag",WZUILabelTTF)
	txtDraw:setDimensions(GlobalMethod:CCSize(100,0))
	txtDraw:setScale(0.8)
	GetElement(self.m_root,"txtTitleName_WndRuneBag",WZUILabelTTF):setScale(0.8)
end

function WndRuneBag:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtSellAll_WndRuneBag",WZUILabelTTF):setScale(0.7)
end

function WndRuneBag:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtDraw_WndRuneBag",WZUILabelTTF):setScale(0.7)

	local txtSell = GetElement(self.m_root,"txtSellAll_WndRuneBag",WZUILabelTTF)
	txtSell:setScale(0.7)
	txtSell:setDimensions(GlobalMethod:CCSize(130,0))

	GetElement(self.m_root,"txtTitleName_WndRuneBag",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtNullTip_WndRuneBag",WZUILabelTTF):setScale(0.8)
end

function WndRuneBag:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtDraw_WndRuneBag",WZUILabelTTF):setScale(0.7)

	local txtSell = GetElement(self.m_root,"txtSellAll_WndRuneBag",WZUILabelTTF)
	txtSell:setScale(0.7)
	txtSell:setDimensions(GlobalMethod:CCSize(150,0))

	GetElement(self.m_root,"txtTitleName_WndRuneBag",WZUILabelTTF):setScale(0.8)
end

function WndRuneBag:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTitleName_WndRuneBag",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtDraw_WndRuneBag",WZUILabelTTF):setScale(0.7)
	local txtSell = GetElement(self.m_root,"txtSellAll_WndRuneBag",WZUILabelTTF)
	txtSell:setScale(0.8)
	txtSell:setDimensions(GlobalMethod:CCSize(130,0))
end
-------------------------------------语言适配End--------------------------------------------