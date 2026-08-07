--CellTransactionLog.lua
--@brief	CellTransactionLog的UI模块
--@date		2017/03/15
--@author	zsq
--@note		交易行商品Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTransactionLog:onEnter(element)
	self.m_root = element
end

function CellTransactionLog:onEnterTransitionDidFinish(element)
	
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTransactionLog:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellTransactionLog:update()
	local itemId = self.m_tData.itemIds
	local logType = self.m_tData.logType
	local tItem = GDatatab_item["id_"..itemId]
	local quality = tItem.quality
	if quality == 0 then quality = 1 end
	local text = GetElement(self.m_root,"logDetail_Cell",WZUIFreeTextBox)
	local template = LocalStrings["TRANSACTION"..(32+logType*4+quality)]
	if logType == 0 then
		text:setShowText(string.format(template,tItem.name,tostring(self.m_tData.itemNums),tostring(self.m_tData.prices),tostring(self.m_tData.addSpar)))
	elseif logType == 1 then
		text:setShowText(string.format(template,tItem.name,tostring(self.m_tData.itemNums),tostring(self.m_tData.prices)))
	end
	GetElement(self.m_root,"txtTime",WZUILabelTTF):setText(self.m_tData.commodityTime)
end




-------------------------------------私有方法模块End----------------------------------------
