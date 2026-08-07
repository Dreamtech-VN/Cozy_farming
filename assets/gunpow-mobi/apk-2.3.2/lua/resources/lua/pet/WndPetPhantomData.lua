--WndPetPhantomData.lua
--@brief	WndPetPhantom的数据模块
--@date		2018/03/06
--@author	Tianxiang_Xu
--@note		宠物幻型

WndPetPhantom = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetPhantom:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tPetData = nil 	
	self.m_tCurData = nil 			--当前数据
	self.m_tClickData = nil 		--选中的宠物数据
	self.m_nPetSelId = nil 
	self.m_tClickPetCell = nil 
	self.m_nLoadingId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetPhantom:_unInit()
	self.m_root = nil
	self.m_tPetData = nil 	
	self.m_tCurData = nil 			--当前数据
	self.m_tClickData = nil 		--选中的宠物数据
	self.m_nPetSelId = nil 
	self.m_tClickPetCell = nil 
	self.m_nLoadingId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetPhantom:createElement()
	if WndPetPhantom.m_root ~= nil then
		WndPetPhantom.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndPetPhantom")
	assert(element, "WndPetPhantom create element failed!")
	self:_init()
	return element
end


--@brief 	外部接口
function WndPetPhantom:showInterface()
	-- body
	local wndTemp = WndPetPhantom:createElement()
	if wndTemp then
		WindowManager:addWindow(wndTemp, WndPetPhantom, nil, nil, nil, true)
	end
end

--@brief	设置可幻型宠物数据
function WndPetPhantom:setPetsData(itemId)
	-- body
	self:closeLoading() 

	self.m_tPetData = {}	
	local adavanceLevel = self.m_tCurData.advancedLevel
	WZLog("WndPetPhantom:setPetsData", Serialize(itemId))
	for i = 1, #itemId do
		local tItem = {}

		local tTempData = self:getAdavanceData(itemId[i], adavanceLevel)
		local tBasicData = GDatatab_item["id_" .. itemId[i]]
		if tBasicData and tBasicData.quality == 4 then
			tItem.itemId = itemId[i]
			tItem.icon = tBasicData.icon
			tItem.advancedLevel = adavanceLevel
			tItem.animation = tBasicData.animation_index_code
			tItem.name = tBasicData.name

			table.insert(self.m_tPetData, tItem)
		else
			if tTempData then
				tItem.itemId = itemId[i]
				tItem.icon = tTempData.evo_icon
				tItem.advancedLevel = tTempData.level
				tItem.animation = tTempData.animation
				tItem.name = tTempData.evo_name

				table.insert(self.m_tPetData, tItem)
			end
		end
	end

	if #self.m_tPetData > 0 then
		table.sort(self.m_tPetData, function (a,b)
			-- body
			return a.itemId < b.itemId
		end)
		if self.m_nPetSelId == nil then
			self.m_nPetSelId = self.m_tPetData[1].itemId
		end
	end

	self:_update()
end

--@brief 	幻化成功
function WndPetPhantom:phantomSuccess(playerPetId, targetItemId)
	-- body
	self:closeLoading()

	MsgBoxManager:showTipBox(LocalStrings.PET_TEXT7)
	self.m_tCurData.petSkinItemId = targetItemId
	--刷新形象
	self:_showPetAniLeft()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	获取宠物的进化数据
--@param 	宠物的物品id
--@param 	宠物的进化等级
function WndPetPhantom:getAdavanceData(itemId, adavanceLevel)
	-- body
	local tData 
	for i, v in pairs(GDatatab_pet_advanced) do
		if v.item_id == itemId and v.level == adavanceLevel then
			tData = CopyTable(v)
			break 
		end
	end

	return tData 
end

--load菊花
function WndPetPhantom:showLoading()
  self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--关闭菊花
function WndPetPhantom:closeLoading()
  MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end


-------------------------------------私有方法模块End----------------------------------------
