--WndPastureMountData.lua
--@brief	WndPastureMount的数据模块
--@date		2021/04/17
--@author	hyx
--@note		牧场坐骑

WndPastureMount = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPastureMount:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCollectData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPastureMount:_unInit()
	self.m_root = nil
	self.m_tCollectData = {}
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPastureMount:createElement()
	if WndPastureMount.m_root ~= nil then
		WindowManager:removeWindow(WndPastureMount.m_root, WndPastureMount, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPastureMount")
	assert(element, "WndPastureMount create element failed!")
	self:_init()
	return element
end

--排序
function WndPastureMount:taskTableSort(data_sort)
	local temp = {
		[0] = 2, --未完成
		[2] = 1, --完成未领取
		[1] = 3, --完成
	}
	local function testFunc(a,b)
		if a and b then
			if a.status ~= b.status then
				if temp[a.status] and temp[b.status] then
					return temp[a.status] < temp[b.status]
				else
					return false
				end
			else
				return a.id < b.id
			end
		end
	end
	table.sort(data_sort, testFunc)
end
function WndPastureMount:setCollectMountData()
	local data = {}
	local index = 1
	if next(self.m_tCollectData) ~= nil then
		for i=1,#self.m_tCollectData do
			local info = GDatatab_pasture_collect["id_"..self.m_tCollectData[i].collectId]
			--状态,0、未完成,1、完成(服务端搞来的)  2 完成未领取 
			if info and info.nextid == -1 then --每次都会显示的
				data[index] = self:setListData(i, info)
				index = index + 1
			else
				--如果出现的id是已完成的时候
				if info and self.m_tCollectData[info.nextid] and self.m_tCollectData[info.nextid].status == 1 then
					data[index] = self:setListData(i, info)
					index = index + 1
				end
			end
		end
		self:taskTableSort(data)
	end
	return data
end

function WndPastureMount:setListData(index, info)
	local tab = {}

	tab.id = self.m_tCollectData[index].collectId
	tab.type = info.type
	tab.progress = self.m_tCollectData[index].progress
	tab.tager = info.require
	tab.status = self.m_tCollectData[index].status
	if tab.status == 0 then
		if tab.type == 1 then
			if self.m_tCollectData[index].progress >= tab.tager then
				tab.status = 2
			end
		elseif tab.type == 2 then
			if self.m_tCollectData[index].progress >= 1 then
				tab.status = 2
			end
		end
	end
	tab.effect = info.effect
	return tab
end

--==============坐骑收集子项===================
PastureMountItem = {}
function PastureMountItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function PastureMountItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function PastureMountItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(740,102))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function PastureMountItem:setMountCellItem(data)
	self.m_tMountCellData = data
end

--@brief 	开始加载
function PastureMountItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("PastureMountItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()

	AdaptLanguage(self)
end
function PastureMountItem:setData()
	if not self.m_tMountCellData then return end

	local data = self.m_tMountCellData
	local tabItem = nil
	local txtName = GetElement(self.m_root,"txtName",WZUIFreeTextBox)
	local txtCount = GetElement(self.m_root,"txtCount",WZUILabelTTF)
	if data.type == 1 then
		txtName:setShowText(string.format(LocalStrings.PASTURE_TEXT31,data.tager))
		tabItem = GDatatab_item["id_10000"]
		txtCount:setText(data.progress.."/"..data.tager)
	elseif data.type == 2 then
		local mount_info = GDatatab_mounts["id_"..data.tager]
		tabItem = GDatatab_item["id_"..mount_info.item_id]
		txtName:setShowText(string.format(LocalStrings.PASTURE_TEXT52,tabItem.name))
		txtCount:setText("")
	end
	--状态,0、未完成,1、完成(服务端搞来的)  2 完成未领取 
	local btnFinish = GetElement(self.m_root,"btnFinish",WZUIButton)
	local txtFinish = GetElement(self.m_root,"txtFinish",WZUILabelTTF)

	txtFinish:setVisible(data.status == 1)
	if data.status == 0 or data.status == 2 then
		txtCount:setVisible(true)
		btnFinish:setVisible(true)
		if data.status == 0 then
			btnFinish:setTouchEnable(false)
		elseif data.status == 2 then
			btnFinish:setTouchEnable(true)
		end
	end

	local goods_item = GetElement(self.m_root,"goods_item",WZUIContainer)
	if tabItem then
		local celElement, tNewObj = CellGoodItem:createElement()
		goods_item:addChild(celElement)
		local itemInfo = {id=i, name=tabItem.name,icon=tabItem.icon,lastNum=1,quality=tabItem.quality,basicInfo=CopyTable(tabItem)}
		tNewObj:setCellGoodItem(itemInfo,1)
	end
	local txtDesc = GetElement(self.m_root,"txtDesc",WZUILabelTTF)
	local temp_type = data.effect[1][1]
	local desc = ""
	if temp_type == -1 then
		desc = LocalStrings.PASTURE_TEXT32.."-"..data.effect[1][2]..LocalStrings.SECOND
	elseif temp_type == 0 then
		desc = LocalStrings.PASTURE_TEXT33..data.effect[1][2].."%"
	elseif temp_type == 97 then
		desc = LocalStrings.PASTURE_TEXT34..data.effect[1][2].."%"
	elseif temp_type == 98 then
		desc = LocalStrings.PASTURE_TEXT35..data.effect[1][2].."%"
	elseif temp_type == 99 then
		desc = LocalStrings.PASTURE_TEXT36..data.effect[1][2].."%"
	end
	txtDesc:setText(desc)
end

function PastureMountItem:onBtnFinish()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tMountCellData then
		ProtocolProcessorFamily:send_MOUNTSPASTURE_FinishPastureCollection(self.m_tMountCellData.id)
	end
end
--@return	新建的表实例对象
function PastureMountItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function PastureMountItem:_adaptLanguage_vn()
	GetElement(self.m_root,"txtName",WZUIFreeTextBox):setRelativePosition(GlobalMethod:ccp(0.164,0.71))
end
-------------------------------------语言适配end----------------------------------------
