--WndHVFieldData.lua
--@brief	WndHVField的数据模块
--@date		2022/05/31
--@author	XTX
--@note		度假村-土坑界面

WndHVField = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVField:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 
	self.m_tFieldStoneConfigData = nil  --土坑源石槽配置
	self.m_tLuaTable = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVField:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_tFieldStoneConfigData = nil 
	self.m_tLuaTable = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVField:createElement()
	if WndHVField.m_root ~= nil then
		WindowManager:removeWindow(WndHVField.m_root, WndHVField, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVField")
	assert(element, "WndHVField create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVField:showInterface(tData, luaTable)
	local wndhv = WndHVField:createElement()
	if wndhv then 
		self.m_tData = tData
		self.m_tLuaTable = luaTable
		WindowManager:addWindow(wndhv, WndHVField, false, nil, nil, true)
	end
end

--@brief 	 数据刷新：镶嵌和升级
function WndHVField:updateFieldData(tData)
	if self.m_root == nil then return end 

	self.m_tData = tData
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	根据土坑获取该土坑源石槽开启等级数据
function WndHVField:_getFieldStoneConfigData()
	if self.m_tFieldStoneConfigData == nil then 
		local tData = self.m_tData

		self.m_tFieldStoneConfigData = {}
		for i, value in pairs(GDatatab_holiday_stone) do 
			if value.clod_id == tData.fieldId then 
				local tItem = {}
				tItem.pos = value.type
				tItem.openLv = value.lv
				tItem.stone_type = SplitStringWithSeparator(tostring(value.stone_type), ",", nil, true)

				self.m_tFieldStoneConfigData[tItem.pos] = tItem
			end
		end
	end

	return self.m_tFieldStoneConfigData
end

--@brief 	获取当前等级和下一级土坑数据
function WndHVField:getFieldLevelData(tData)
	local curData = nil 
	local nextData = nil 
	for i, value in pairs(GDatatab_holiday_earth_pit) do
		if value.lv == tData.fieldLv and value.type == tData.fieldId then 
			curData = value
			if value.exp == -1 and value.lv_cost == -1 then 
				break 
			end
		elseif value.lv == tData.fieldLv + 1 and value.type == tData.fieldId then 
			nextData = value
		end

		if curData and nextData then 
			break 
		end
	end

	return curData, nextData
end
-------------------------------------私有方法模块End----------------------------------------
