--CellGrid.lua
--@brief	CellGrid的UI模块
--@date		2016/05/18
--@author	zsq
--@note		装载CellGoodItem


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGrid:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGrid:onExit(element)
	self:_unInit()
end

--@brief	设置数据
function CellGrid:setCellGoodItem(tData,nType)
--	WZLog("CellGrid:setCellGoodItem")
	self.m_tData = tData
	self.m_nType = nType
	if self.m_tCell == nil then return end
	self.m_tCell:setCellGoodItem(tData,nType)
end

--@brief	设置回调
function CellGrid:setItemClickFun(tCell,backFun)
--	WZLog("CellGrid:setItemClickFun")
	self.m_tTable = tCell
	self.m_tBackFun = backFun
	if self.m_tCell == nil then return end
	self.m_tCell:setItemClickFun(tCell,backFun)
end

--@brief	设置来源的Tag
function CellGrid:setFromTag(tag)
	self.m_nFromTag = tag
	if self.m_tCell == nil then return end
	self.m_tCell:setFromTag(tag)
end

--=========勾选和移除==========
function CellGrid:showSelectedIcon(nType)
    if self.m_tCell == nil then return end
    self.m_tCell:_showSell(nType)
end
function CellGrid:removeGouIcon()
	if self.m_tCell == nil then return end
	self.m_tCell:removeGouIcon()
end
--=================
--@brief	清空
function CellGrid:removeAllChild()
	if self.m_tCell == nil then return end
	self.m_tCell:removeAllChild()
end

--@brief	设置灰色
function CellGrid:setGrayRender(bool)
	if self.m_tCell == nil then return end
	self.m_tCell:setGrayRender(bool)
end

--@brief	设置高亮
function CellGrid:setHighLight(bool)
	if self.m_tCell == nil then return end
	self.m_tCell:setHighLight(bool)
end

--@brief	添加已拥有角标
function CellGrid:_addSidebarOwn()
	if self.m_tCell == nil then return end
	self.m_tCell:_addSidebarOwn()
end
--@brief	
function CellGrid:clearItemQualityPic(is_quality, quality_score)
	if self.m_tCell == nil then return end
	self.m_tCell:clearItemQualityPic(is_quality, quality_score)
end
--物品数量换成品质（目前用于坐骑灵石）
function CellGrid:setVisibleItemCount(count)
	if self.m_tCell == nil then 
		WZLog("CellGrid:setVisibleItemCount self.m_tCell == nil, count = ", count)
		return 
	end
	self.m_tCell:setVisibleItemCount(count)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	用数据更新cell
function CellGrid:onLoadData(element)
--	WZLog("CellGrid:onLoadData")
	local cellElement = WZUISystem:getInstance():createElement("CellGrid")
    self.m_root:addChild(cellElement)

	--创建格子
	local celElement,tCell = CellGoodItem:createElement()
	if celElement and tCell then
		self.m_tCell = tCell
		self.m_root:addChild(celElement)
		tCell:setCellGoodItem(self.m_tData,self.m_nType)
		tCell:setItemClickFun(self.m_tTable,self.m_tBackFun)
		celElement:setTag(self.m_root:getTag())
	end

	if self.m_tCell ~= nil and self.m_nFromTag ~= nil then
		self.m_tCell:setFromTag(tag)
	end
end

-------------------------------------私有方法模块End----------------------------------------
