--CellSignItems.lua
--@brief	CellSignItems的UI模块
--@date		2014/01/21
--@author	SuYuan
--@note		每日签到奖励物品


--控件元素的位置信息，单位为像素
local ITEM1_POSX = 67.5
local ITEM1_POSY = 64
local ITEM2_POSX = 217.5
local ITEM2_POSY = 64
local ITEM3_POSX = 367.5
local ITEM3_POSY = 64

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSignItems:onEnter(element)
	self.m_root = element
	
	--初始化控件
	self:_initCellSignItems()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSignItems:onExit(element)
	self:_unInit()
end

--@brief	设置签到奖励数据
--@param	tSignItemsData:物品数据
--@note		设置签到奖励数据
function CellSignItems:setItemsData(tSignItemsData)
	--设置标题
	local txtTitle = self.m_root:getChildElement("txtTitle_CellSignItems")
	if txtTitle ~= nil then
		local language = ProjConfig.LANGUAGE
		local sP =  self.scaleFromLanguage[language] or 1 -- 缩放比例
		WZUILabelTTF:luaTo(txtTitle):setScaleX(sP)
		if 0 == tSignItemsData[1] then
			WZUILabelTTF:luaTo(txtTitle):setText(LocalStrings.DAILYSIGN_REWARD)
		elseif 1 == tSignItemsData[1] then
			WZUILabelTTF:luaTo(txtTitle):setText(LocalStrings.CONTINUALSIGN .. tSignItemsData[2] .. LocalStrings.DAILYSIGN_MSG)
		elseif 2 == tSignItemsData[1] then
			WZUILabelTTF:luaTo(txtTitle):setText(LocalStrings.MONTHLYSIGN .. tSignItemsData[2] .. LocalStrings.DAILYSIGN_MSG1)
		end
	end
	--设置签到奖励物品数据
	self:_addItemData(tSignItemsData[3])
	--隐藏为空的物品项
	self:_hideNilItem()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化控件
--@note		初始化控件
function CellSignItems:_initCellSignItems()
	local conItems = self.m_root:getChildElement("conItems_CellSignItems")
	if conItems ~= nil then
		self.m_itemElement1, self.m_itemLuaObj1 = CellItem:createElement()
		if self.m_itemElement1 ~= nil and self.m_itemLuaObj1 ~= nil then
			conItems:addChild(self.m_itemElement1)
			self.m_itemElement1:setUseAbsCoordinate(true)
			self.m_itemElement1:setAbsPosition(GlobalMethod:ccp(ITEM1_POSX, ITEM2_POSY))
		end
		
		self.m_itemElement2, self.m_itemLuaObj2 = CellItem:createElement()
		if self.m_itemElement2 ~= nil and self.m_itemLuaObj2 ~= nil then
			conItems:addChild(self.m_itemElement2)
			self.m_itemElement2:setUseAbsCoordinate(true)
			self.m_itemElement2:setAbsPosition(GlobalMethod:ccp(ITEM2_POSX, ITEM2_POSY))
		end
		
		self.m_itemElement3, self.m_itemLuaObj3 = CellItem:createElement()
		if self.m_itemElement3 ~= nil and self.m_itemLuaObj3 ~= nil then
			conItems:addChild(self.m_itemElement3)
			self.m_itemElement3:setUseAbsCoordinate(true)
			self.m_itemElement3:setAbsPosition(GlobalMethod:ccp(ITEM3_POSX, ITEM3_POSY))
		end
	end
end

--@brief	添加签到奖励物品数据
--@param	tItemsData:物品数据
--@note		添加签到奖励物品数据
function CellSignItems:_addItemData(tItemsData)
	for k,v in pairs(tItemsData) do
		if self.m_itemLuaObj1:isItemNil() then
			self.m_itemLuaObj1:setName(v[1])
			self.m_itemLuaObj1:setImg(v[2])
			self.m_itemLuaObj1:setNum(v[3])
		elseif self.m_itemLuaObj2:isItemNil() then
			self.m_itemLuaObj2:setName(v[1])
			self.m_itemLuaObj2:setImg(v[2])
			self.m_itemLuaObj2:setNum(v[3])
		elseif self.m_itemLuaObj3:isItemNil() then
			self.m_itemLuaObj3:setName(v[1])
			self.m_itemLuaObj3:setImg(v[2])
			self.m_itemLuaObj3:setNum(v[3])
		end
	end
end

--@brief	隐藏为空的物品项
--@note		隐藏为空的物品项
function CellSignItems:_hideNilItem()
	if self.m_itemLuaObj1:isItemNil() then
		self.m_itemLuaObj1:setElementVisible(false)
	end
	if self.m_itemLuaObj2:isItemNil() then
		self.m_itemLuaObj2:setElementVisible(false)
	end
	if self.m_itemLuaObj3:isItemNil() then
		self.m_itemLuaObj3:setElementVisible(false)
	end
end

-------------------------------------私有方法模块End----------------------------------------




