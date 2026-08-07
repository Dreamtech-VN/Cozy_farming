--WndPastureMakeData.lua
--@brief	WndPastureMake的数据模块
--@date		2021/04/17
--@author	hyx
--@note		牧场道具制作

WndPastureMake = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPastureMake:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTableId = -1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPastureMake:_unInit()
	self.m_root = nil
	self.m_nTableId = -1
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPastureMake:createElement(tableid)
	if WndPastureMake.m_root ~= nil then
		WindowManager:removeWindow(WndPastureMake.m_root, WndPastureMake, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPastureMake")
	assert(element, "WndPastureMake create element failed!")
	self:_init()
	self.m_nTableId = tableid
	return element
end

--提取道具制作的物品
function WndPastureMake:setMakeItemData(  )
	local level = WndPastureBusiness:getPastureLevel()
	local data = {}
	local table_insert = table.insert
	for i,v in pairs(GDatatab_pasture_factory) do
		if data[v.type] == nil then
			data[v.type] = {}
		end
		table_insert(data[v.type], v)
	end

	local temp_data = {}
	for i=1,#data do
		table.sort( data[i], function(a,b) return a.needlevel < b.needlevel end)
		if level == 1 then
			table_insert(temp_data,data[i][1])
		else
			local index = nil
			for k=1, #data[i] do
				if level == data[i][k].needlevel then
					index = k
				end
			end
			if index == nil then
				if level > data[i][#data[i]].needlevel then
					index = #data[i]
				else
					for m=1,#data[i] do
						if data[i][m].needlevel > level then
							index = m - 1
							break
						end
					end
				end
				if data[i][index] == nil then
					index = 1
				end
			end
			table_insert(temp_data, data[i][index])
		end
	end

	table.sort( temp_data, function(a,b) return a.id < b.id end)
	return temp_data
end


--==============道具制作子项===================
PastureMakeItem = {}
function PastureMakeItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function PastureMakeItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function PastureMakeItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(226,236))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function PastureMakeItem:setCellMakeItemData(tableid,data)
	self.m_nCellTableId = tableid
	self.m_tMakeItemData = data
end
--@brief 	开始加载
function PastureMakeItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("makeItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()
end
function PastureMakeItem:setData()
	if not self.m_tMakeItemData then return end
	local data = self.m_tMakeItemData

	local imgMaskLock = GetElement(self.m_root,"imgMaskLock",WZUIContainer)
	local level = WndPastureBusiness:getPastureLevel()
	imgMaskLock:setVisible(data.needlevel > level)

	GetElement(self.m_root,"txtName",WZUILabelTTF):setText(data.name)
	local txtCount = GetElement(self.m_root,"txtCount",WZUILabelTTF)
	local skill_info = GDatatab_skill["id_"..data.skillid]
	if skill_info then
		txtCount:setText(skill_info.param3)
	end
	local skill_com = GetElement(self.m_root,"skill_com",WZUIContainer)
	local item, itemObj = WndPastureGoodsItem:createElement()
	itemObj:setData(data.skillid)
	itemObj:setOtherData({next_desc = true})
	itemObj:setDefaultTip(true)
	skill_com:addChild(item)

	local txtConsume = GetElement(self.m_root,"txtConsume",WZUIFreeTextBox)
	local str = [[<I Z="0.5">%s</I><T C="255,236,193" S="20" P="1"> %d</T>]]
	local info = GDatatab_item["id_"..data.use[1][1]]
	txtConsume:setShowText(string.format(str, info.icon, data.use[1][2]))
end

function PastureMakeItem:onBtnSureMake()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMakeItemData then
		GlobalGame:getGameEventDispathcer():Dispatch(PastureEvent.PastureEvent_WorkShopMakeSureId, self.m_nCellTableId, self.m_tMakeItemData)
	end
	WindowManager:removeWindow(WndPastureMake.m_root, WndPastureMake, true)
end
function PastureMakeItem:onBtnLock()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMakeItemData then
		MsgBoxManager:showTipBox(string.format(LocalStrings.PASTURE_TEXT56, self.m_tMakeItemData.needlevel))
	end
end
--@return	新建的表实例对象
function PastureMakeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
