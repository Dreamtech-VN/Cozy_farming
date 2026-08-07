--CellRecover.lua
--@brief	CellRecover的UI模块
--@date		2015/06/26
--@author	zsq
--@note		背包出售Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRecover:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRecover:onExit(element)
	self:_unInit()
end

--@brief	取消出售
function CellRecover:onCancel(element)
	WZLog("CellRecover:onCancel",self.m_root:getTag())
	--更新数据，刷新右侧出售背包
	local tempList = WndSell.m_tData
	for i=1,#tempList do
		if tempList[i].playerItemId == self.m_tData.playerItemId then
			tempList[i].sellHook = false
			break
		end 	
	end
	--Add By Tianxiang_Xu
	local tempSellList = WndSell.m_tSellList
	for i=1,#tempSellList do
		if tempSellList[i].playerItemId == self.m_tData.playerItemId then
			table.remove(tempSellList, i)
			break
		end 	
	end
	--End Add
	WndSell:_update(true)
	--更新数据，刷新左侧出售列表
	local tempSell = WndSellList.m_tLeft
	for i=1,#tempSell do
		if tempSell[i].playerItemId == self.m_tData.playerItemId then
			table.remove(tempSell,i)
			break
		end
	end
	WndSellList:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置Cell
function CellRecover:setCellRecover(tData)
	if tData == nil then return end
	self.m_tData = tData
   	GetElement(self.m_root, "name_CellRecover", WZUILabelTTF):setText(tData.basicInfo.name)
   	GetElement(self.m_root, "name_CellRecover", WZUILabelTTF):setColor(QUALITYCOLOR[tData.basicInfo.quality])
   	GetElement(self.m_root, "price_CellRecover", WZUILabelTTF):setText(tData.basicInfo.recycle)

   	local con = GetElement(self.m_root, "conGrid_CellRecover", WZUIContainer)
	if con:getChildByTag(100) then
		con:removeChildByTag(100)
	end

	local cellElement,lua = CellGoodItem:createElement()
	cellElement:setTag(100)
	lua:setCellGoodItem(tData,4)
	con:addChild(cellElement)
end




-------------------------------------私有方法模块End----------------------------------------
