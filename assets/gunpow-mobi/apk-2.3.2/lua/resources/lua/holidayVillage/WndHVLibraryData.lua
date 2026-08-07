--WndHVLibraryData.lua
--@brief	WndHVLibrary的数据模块
--@date		2022/05/28
--@author	XTX
--@note		度假村-图鉴界面

WndHVLibrary = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVLibrary:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLibraryData = nil 			--图鉴数据
	self.m_tLuaTable = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVLibrary:_unInit()
	self.m_root = nil
	self.m_tLibraryData = nil 			--图鉴数据
	self.m_tLuaTable = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVLibrary:createElement()
	if WndHVLibrary.m_root ~= nil then
		WindowManager:removeWindow(WndHVLibrary.m_root, WndHVLibrary, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVLibrary")
	assert(element, "WndHVLibrary create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVLibrary:showInterface(luaTable)
	local wndhv = WndHVLibrary:createElement()
	if wndhv then 
		self.m_tLuaTable = luaTable
		WindowManager:addWindow(wndhv, WndHVLibrary, false, nil, nil, true)
	end
end

--@brief 	设置图鉴数据
--@param    synType : 同步类型，0-同步，1-增，2-更新，3-删
--@param 	level:-1=未解锁，0=可解锁，大于0=升级
function WndHVLibrary:setLibraryData(synType, ids, level)
	if synType == 0 then 
		for i = 1, #ids do
			local basicData = GDatatab_holiday_picture["id_" .. ids[i]]
			for j = 1, #self.m_tLibraryData do
				if basicData and basicData.plant == self.m_tLibraryData[j].plant then 
					local tItem = self.m_tLibraryData[j]

					tItem.id = basicData.id
					tItem.level = level[i]
					tItem.needNum = basicData.num

					tItem.property = {basicData.exp, basicData.attain_exp, basicData.energy, basicData.reward}
					tItem.cost = basicData.cost
					if tItem.cost ~= -1 then 
						local nextData = self:getNextLevelData(basicData.plant, level[i])
						tItem.nextProperty = {nextData.exp, nextData.attain_exp, nextData.energy, nextData.reward}
					end

					break 
				end
			end
		end

		self:_update()
	elseif synType == 2 then 
		for i = 1, #ids do
			self:upgradeSuccess(ids[i], level[i])
		end
	end
end

--@brief 	升级/解锁成功
function WndHVLibrary:upgradeSuccess(id, level)
	local basicData = GDatatab_holiday_picture["id_" .. id]
	for i = 1, #self.m_tLibraryData do
		if basicData and self.m_tLibraryData[i].plant == basicData.plant then 
			local nLastLevel = self.m_tLibraryData[i].level

			self.m_tLibraryData[i].id = id
			self.m_tLibraryData[i].level = level
			self.m_tLibraryData[i].needNum = basicData.num

			self.m_tLibraryData[i].property = {basicData.exp, basicData.attain_exp, basicData.energy, basicData.reward}
			self.m_tLibraryData[i].cost = basicData.cost
			if basicData.cost ~= -1 then 
				local nextData = self:getNextLevelData(basicData.plant, level)
				self.m_tLibraryData[i].nextProperty = {nextData.exp, nextData.attain_exp, nextData.energy, nextData.reward}
			else
				self.m_tLibraryData[i].nextProperty = nil 
			end
			--更新相应图鉴显示
			WZLog("WndHVLibrary:upgradeSuccess")
			if self.m_tCellSel and self.m_tCellSelData and self.m_tCellSelData.plant == basicData.plant then 
				self.m_tCellSelData = self.m_tLibraryData[i]
				self.m_tCellSel:showStatus(self.m_tLibraryData[i])
			end
			--更新升级或隐藏解锁界面
			if nLastLevel == 0 then 
				MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT24)
				self:_hideUnlockInterface()
			else
				MsgBoxManager:showTipBox(LocalStrings.NEWSKILL14)
				self:_showUpgradeDetail()
			end
			break 
		end
	end
end

--@brief 	获取图鉴对应的物品id
function WndHVLibrary:getItemIdByPlantId(plantId)
	for i, value in pairs(GDatatab_holiday_seed) do
		if value.id == plantId then 
			return value
		end
	end
end

--@brief 	获取图鉴下一级数据
function WndHVLibrary:getNextLevelData(plantId, level)
	for i, value in pairs(GDatatab_holiday_picture) do
		if value.plant == plantId and value.lv == level + 1 then 
			return value
		end
	end
end

--@brief 	根据物品id获取种子数据
function WndHVLibrary:getSeedDataByItemId(itemId)
	for i, value in pairs(GDatatab_holiday_seed) do
		if value.item_id == itemId then 
			return value
		end
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化图鉴数据
function  WndHVLibrary:_initLibraryData()
	-- body
	self.m_tLibraryData = {}
	for i, value in pairs(GDatatab_holiday_picture) do
		if value.lv == 0 then 
			local tItem = {}

			local seedData = self:getItemIdByPlantId(value.plant)
			local basicInfo = GDatatab_item["id_" .. seedData.item_id]
			tItem.plant = value.plant
			tItem.level = value.lv
			local nOwnNum = self.m_tLuaTable:getItemCountByItemId(seedData.item_id)
			if value.num > nOwnNum then 
				tItem.level = -1
			end
			tItem.needItemId = seedData.item_id
			tItem.needNum = value.num
			tItem.icon = basicInfo.icon
			tItem.name = basicInfo.name
			tItem.property = {value.exp, value.attain_exp, value.energy, value.reward}
			tItem.cost = value.cost

			table.insert(self.m_tLibraryData, tItem)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------
CellHVLibraryItem = {
}

function CellHVLibraryItem:_init()
	self.m_root = nil 
	self.m_bIsLoaded = false 
	self.m_tData = nil 
end

function CellHVLibraryItem:_unInit()
	self.m_root = nil 
	self.m_bIsLoaded = nil 
	self.m_tData = nil 
end

function CellHVLibraryItem:createElement()
	local tNewObj = self:_new()
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setName("__CellHVLibraryItem")
	element:setAbsContentSize(GlobalMethod:CCSize(156,194))
	element:setLuaObjectIndex(tNewObj)

	return element, tNewObj
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHVLibraryItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHVLibraryItem:onExit(element)
	self:_unInit()
end

--@brief 	点击解锁、升级按钮回调
function CellHVLibraryItem:onClickUpgrade(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WndHVLibrary:onClickUpgradeCallBack(self, self.m_tData)
end

--@brief 	设置数据
function CellHVLibraryItem:setData(tData)
	self.m_tData = tData 
end

--@brief 	加载
function CellHVLibraryItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("CellHVLibraryItem")
	celElement:setVisible(true)
	self.m_root:addChild(celElement)
	self.m_bIsLoaded = true 

	self:_update()
end

--@brief 	刷新
function CellHVLibraryItem:_update()
	local imgIcon = GetElement(self.m_root, "imgIcon_CellHVLibraryItem", WZUIImage)
	if imgIcon then 
		imgIcon:setFile(self.m_tData.icon)
	end
	local txtName = GetElement(self.m_root, "txtName_CellHVLibraryItem", WZUILabelTTF)
	txtName:setText(self.m_tData.name)
	self:showStatus()
end

--@brief 	设置名字、等级，按钮状态
function CellHVLibraryItem:showStatus(tData)
	if tData then 
		self.m_tData = tData
	end
	WZLog("CellHVLibraryItem:showStatus", type(tDate), self.m_bIsLoaded)
	if self.m_bIsLoaded == false then return end 

	local txtLv = GetElement(self.m_root, "txtLv_CellHVLibraryItem", WZUILabelTTF)
	local txtBtn1 = GetElement(self.m_root, "txtBtn1_CellHVLibraryItem", WZUILabelTTF)
	local txtBtn2 = GetElement(self.m_root, "txtBtn2_CellHVLibraryItem", WZUILabelTTF)
	local txtBtn3 = GetElement(self.m_root, "txtBtn3_CellHVLibraryItem", WZUILabelTTF)
	local imgBtn1 = GetElement(self.m_root, "imgBtn1_CellHVLibraryItem", WZUIImage)
	local imgBtn2 = GetElement(self.m_root, "imgBtn2_CellHVLibraryItem", WZUIImage)
	local imgBtn3 = GetElement(self.m_root, "imgBtn3_CellHVLibraryItem", WZUIImage)
	local btnUpgrade = GetElement(self.m_root, "btnUpgrade_CellHVLibrary", WZUIButton)
	local conLock = GetElement(self.m_root, "conLock_CellHVLibraryItem", WZUIContainer)
	if self.m_tData.level == -1 then 
		conLock:setVisible(true)
		btnUpgrade:setTouchEnable(false)
		txtBtn1:setText(LocalStrings.TIPSWORD6)
		txtBtn2:setText(LocalStrings.TIPSWORD6)
		txtBtn3:setText(LocalStrings.TIPSWORD6)
		txtBtn1:setStrokeColor(GlobalMethod:ccc3(163,74,20))
		txtBtn2:setStrokeColor(GlobalMethod:ccc3(163,74,20))
		imgBtn1:setFile("ui/common/common_btn_05.png")
		imgBtn2:setFile("ui/common/common_btn_05.png")
		imgBtn3:setFile("ui/common/common_btn_05.png")
		txtLv:setText("")
	elseif self.m_tData.level == 0 then 
		conLock:setVisible(true)
		btnUpgrade:setTouchEnable(true)
		txtBtn1:setText(LocalStrings.TIPSWORD6)
		txtBtn2:setText(LocalStrings.TIPSWORD6)
		txtBtn3:setText(LocalStrings.TIPSWORD6)
		txtBtn1:setStrokeColor(GlobalMethod:ccc3(163,74,20))
		txtBtn2:setStrokeColor(GlobalMethod:ccc3(163,74,20))
		imgBtn1:setFile("ui/common/common_btn_05.png")
		imgBtn2:setFile("ui/common/common_btn_05.png")
		imgBtn3:setFile("ui/common/common_btn_05.png")
		txtLv:setText(LocalStrings.LV .. self.m_tData.level)
	else
		conLock:setVisible(false)
		btnUpgrade:setTouchEnable(true)
		txtBtn1:setText(LocalStrings.STAR_SOUL_BUTTON_UPDATE)
		txtBtn2:setText(LocalStrings.STAR_SOUL_BUTTON_UPDATE)
		txtBtn3:setText(LocalStrings.STAR_SOUL_BUTTON_UPDATE)
		txtBtn1:setStrokeColor(GlobalMethod:ccc3(0,108,3))
		txtBtn2:setStrokeColor(GlobalMethod:ccc3(0,108,3))
		imgBtn1:setFile("ui/common/common_btn_06.png")
		imgBtn2:setFile("ui/common/common_btn_06.png")
		imgBtn3:setFile("ui/common/common_btn_06.png")
		txtLv:setText(LocalStrings.LV .. self.m_tData.level)
	end
end

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellHVLibraryItem:_new()
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self

	return tNewObj
end