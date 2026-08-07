--WndProfessionCrystalLibraryData.lua
--@brief	WndProfessionCrystalLibrary的数据模块
--@date		2021/02/07
--@author	XTX
--@note		职业水晶图鉴

WndProfessionCrystalLibrary = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndProfessionCrystalLibrary:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tLibraryData = nil 
	self.m_nProfession = nil 
	self.m_nRoleOrPet = nil 			--1角色，2宠物
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndProfessionCrystalLibrary:_unInit()
	self.m_root = nil
	self.m_tLibraryData = nil 
	self.m_nProfession = nil 
	self.m_nRoleOrPet = nil 			--1角色，2宠物
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndProfessionCrystalLibrary:createElement()
	if WndProfessionCrystalLibrary.m_root ~= nil then
		WindowManager:removeWindow(WndProfessionCrystalLibrary.m_root, WndProfessionCrystalLibrary, true)
	end
	local element = WZUISystem:getInstance():createElement("WndProfessionCrystalLibrary")
	assert(element, "WndProfessionCrystalLibrary create element failed!")
	self:_init()
	return element
end

--@brief 	设置数据
function WndProfessionCrystalLibrary:setData()
	-- body
	self.m_tLibraryData = {}
	for i, value in pairs(GDatatab_mage_Skill) do
		if self.m_nRoleOrPet == 1 then 
			if value.profession == self.m_nProfession and value.node == 4 and value.lv == 1 then 
				table.insert(self.m_tLibraryData, CopyTable(value))
			end
		else
			if value.profession == self.m_nProfession and value.node == 3 and value.lv == 1 then 
				table.insert(self.m_tLibraryData, CopyTable(value))
			end
		end
	end
	--获取合成水晶图标
	for i = 1, #self.m_tLibraryData do
		local nIndex = 0 
		for j, value in pairs(GDatatab_mage_Skill) do
			if self.m_nRoleOrPet == 1 then 
				if value.profession == self.m_nProfession and type(value.attribute) == "table" then 
					if value.node == 2 and self.m_tLibraryData[i].crystalIcon1 == nil then 
						for k = 1, #value.attribute do
							if value.attribute[k][1] == self.m_tLibraryData[i].id then 
								self.m_tLibraryData[i].crystalIcon1 = value.icon
								nIndex = nIndex + 1
								break 
							end
						end
					elseif value.node == 3 and self.m_tLibraryData[i].crystalIcon2 == nil then 
						for k = 1, #value.attribute do
							if value.attribute[k][1] == self.m_tLibraryData[i].id then 
								self.m_tLibraryData[i].crystalIcon2 = value.icon
								nIndex = nIndex + 1
								break 
							end
						end
					end
					if nIndex >= 2 then 
						break 
					end
				end
			elseif self.m_nRoleOrPet == 2 then 
				if value.profession == self.m_nProfession and type(value.attribute) == "table" then 
					if value.node == 1 and self.m_tLibraryData[i].crystalIcon1 == nil then 
						for k = 1, #value.attribute do
							if value.attribute[k][1] == self.m_tLibraryData[i].id then 
								self.m_tLibraryData[i].crystalIcon1 = value.icon
								nIndex = nIndex + 1
								break 
							end
						end
					elseif value.node == 2 and self.m_tLibraryData[i].crystalIcon2 == nil then 
						for k = 1, #value.attribute do
							if value.attribute[k][1] == self.m_tLibraryData[i].id then 
								self.m_tLibraryData[i].crystalIcon2 = value.icon
								nIndex = nIndex + 1
								break 
							end
						end
					end
					if nIndex >= 2 then 
						break 
					end
				end
			end
		end
	end
	--获取最高等级描述
	for i = 1, #self.m_tLibraryData do
		local parentId = self.m_tLibraryData[i].parent_id
		local tTempData = self.m_tLibraryData[i]
		while parentId ~= -1 do
			tTempData = GDatatab_mage_Skill["id_" .. parentId[1][1]]
			parentId = tTempData.parent_id
		end

		self.m_tLibraryData[i].name = tTempData.name
		self.m_tLibraryData[i].desc = tTempData.desc
		self.m_tLibraryData[i].icon = tTempData.icon
	end
	self:_update()
end

--@brief 	外部接口
function WndProfessionCrystalLibrary:showInterface(professionId, nRoleOrPet)
	-- body
	local wndLibrary = WndProfessionCrystalLibrary:createElement()
	if wndLibrary then 
		self.m_nProfession = professionId 
		self.m_nRoleOrPet = nRoleOrPet
		WZLog("WndProfessionCrystalLibrary:showInterface", professionId, nRoleOrPet)
		WindowManager:addWindow(wndLibrary, WndProfessionCrystalLibrary, nil, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
