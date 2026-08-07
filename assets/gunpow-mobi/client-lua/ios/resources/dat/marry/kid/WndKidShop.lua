--WndKidShop.lua
--@brief	WndKidShop的UI模块
--@date		2018/05/09
--@author	Tianxiang_Xu
--@note		小家商店


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKidShop:onEnter(element)
	self.m_root = element
	CacheCenter:registerUpatePlayerHomeItemObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKidShop:onExit(element)
	CacheCenter:unregisterUpatePlayerHomeItemObserver(self)
	self:_unInit()
end

--@brief    界面加载完成回调
function WndKidShop:onEnterTransitionDidFinish(element)
    -- body
    if self.m_nType == 7 then
    	GetElement(self.m_root, "btnRule_WndKidShop", WZUIButton):setVisible(true)
    end
    self:setDataByType(self.m_nType)
end

--@brief 	获取建筑饰品商店数据
function WndKidShop:getShopData(tData, nType)
	-- body
	WZLog("WndKidShop:getShopData", Serialize(tData))
	local tTempList = {}
	for i = 1, #tData do
		if nType == 1 and tData[i].buildingData.type == nType then
			table.insert(tTempList, tData[i])
		elseif nType == 2 and tData[i].buildingData.type ~= 1 then
			table.insert(tTempList, tData[i])
		end
	end

	table.sort(tTempList, function (a,b)
		-- body
		return a.itemId < b.itemId
	end)

	self.m_tDataList = CopyTable(tTempList)

	self:_update()
end

--@brief    规则按钮回调
function WndKidShop:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.KID_TEXT115)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndKidShop:_update()
	-- body
	self:_createList()
end

--@brief 	创建列表
function WndKidShop:_createList()
	-- body
	local tableShop = GetElement(self.m_root, "tableShop_WndKidShop", WZUITableContainer)
	tableShop:cleanTable()
	local conShop = GetElement(self.m_root, "conShop_WndKidShop", WZUIContainer)
	if self.m_tDataList == nil or #self.m_tDataList == 0 then
		if self.m_nType == 7 then
			ShowPanelNullTip( conShop, LocalStrings.KID_TEXT74)
		else
			ShowPanelNullTip( conShop, LocalStrings.KID_TEXT75)
		end
		return 
	end
	removeShowPanelNullTip(conShop)

	WZLog("WndKidShop:_createList")
	for i = 1, #self.m_tDataList do
		local element, tNewObj = CellKidBagItem:createElement()
		if element and tNewObj then
			element:setTag(i - 1)
			if self.m_nType == 1 or self.m_nType == 2 then
				tNewObj:setData(self.m_tDataList[i], 1, self.m_nType)
			elseif self.m_nType == 7 and self.m_tDataList[i].maintype == 30 then
				tNewObj:setData(self.m_tDataList[i], 1, self.m_nType)
			else
				tNewObj:setData(self.m_tDataList[i], 2, self.m_nType)
			end

			tableShop:setCellElement(element)
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------
