--WndPetsEquipmentData.lua
--@brief	WndPetsEquipment的数据模块
--@date		2022/04/25
--@author	yrd
--@note		宠物装备

WndPetsEquipment = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetsEquipment:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_tCurPetsInfo = nil 			--当前宠物信息数据
	self.m_tBagItemDataList = nil		--背包中的装备数据列表
	self.m_tBagItemObjList = nil		--背包中的装备对象列表
	self.m_tEquipItemDataList = nil		--装备中的装备数据列表
	self.m_tEquipItemObjList = nil 		--装备中的装备对象列表

	self.m_nMaxGridsNum = 200 			--背包最大格子数

	self.m_tEquipmentShowList = nil		--装备界面背包显示列表
	self.m_nShowSubType = -1 			--装备界面背包显示类型 -1:全部显示

	self.m_tCellDressSuit = nil 		--切换宠物装备方案

	self.m_nInterfaceType = 1 			--界面类型 1:装备界面 2继承界面

	self.m_tInheritItem1 = nil 			--继承界面第一件装备对象
	self.m_tInheritItem2 = nil 			--继承界面第二件装备对象

	self.m_tBagItemsObjList2 = nil 		--继承界面背包格子对象列表
	self.m_tInheritShowList = nil		--继承界面背包显示列表
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetsEquipment:_unInit()
	self.m_root = nil	 	  			--场景根节点

	self.m_tCurPetsInfo = nil 			--当前宠物信息数据
	self.m_tBagItemDataList = nil		--背包中的装备数据列表
	self.m_tBagItemObjList = nil		--背包中的装备对象列表
	self.m_tEquipItemDataList = nil		--装备中的装备数据列表
	self.m_tEquipItemObjList = nil 		--装备中的装备对象列表

	self.m_nMaxGridsNum = nil 			--背包最大格子数

	self.m_tEquipmentShowList = nil		--装备界面背包显示列表
	self.m_nShowSubType = nil 			--装备界面背包显示类型 -1:全部显示

	self.m_tCellDressSuit = nil 		--切换宠物装备方案
	
	self.m_nInterfaceType = nil			--界面类型 1:装备界面 2继承界面

	self.m_tInheritItem1 = nil 			--继承界面第一件装备对象
	self.m_tInheritItem2 = nil 			--继承界面第二件装备对象

	self.m_tBagItemsObjList2 = nil 		--继承界面背包格子对象列表
	self.m_tInheritShowList = nil		--继承界面背包显示列表
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetsEquipment:createElement()
	if WndPetsEquipment.m_root ~= nil then
		WindowManager:removeWindow(WndPetsEquipment.m_root, WndPetsEquipment, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPetsEquipment")
	assert(element, "WndPetsEquipment create element failed!")
	self:_init()
	return element
end

--@brief 	更新多套时装数据
function WndPetsEquipment:updatePetEuqipSchemeData(nType)
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
    	self.m_tCellDressSuit:changeDressSuitOK()
    else
    	self.m_tCellDressSuit:setSuitData()
    end

    -- if self.m_root == nil then return end 
    -- self:setPetEuqipName()
end

--@brief 	更新宠物装备数据
function WndPetsEquipment:updatePetEquipCacheData()
	self:updatepetEquipData()
end

--@brief	设置装备信息数据
function WndPetsEquipment:updatepetEquipData()

	local tPetsEquipmentList = CopyTable(CacheCenter:getPetsEquipmentList())

	--背包中数据
	self.m_tBagItemDataList = tPetsEquipmentList
	table.sort( self.m_tBagItemDataList, function(a,b)
		if a.isUse ~= b.isUse then
			if a.isUse == true then
				return true
			elseif b.isUse == true then
				return false
			end
		else
			if a.basicInfo.quality ~= b.basicInfo.quality then
				return a.basicInfo.quality > b.basicInfo.quality
			else
				if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
					return a.basicInfo.sub_type > b.basicInfo.sub_type
				else
					if a.playerItemId ~= b.playerItemId then
						return a.playerItemId > b.playerItemId
					else
					end
				end
			end
		end
	end )

	--装备中数据
	self.m_tEquipItemDataList = {}
	local subTypeToTag = {[0]=1,2,3,4,5,6}
	for i=1,#tPetsEquipmentList do
		if tPetsEquipmentList[i].isUse == true then
			local sub_type = tPetsEquipmentList[i].basicInfo.sub_type
			self.m_tEquipItemDataList[subTypeToTag[sub_type]] = tPetsEquipmentList[i]
		end
	end

	self:updateUI()
	if self.m_nInterfaceType == 2 then
		self:updateInheritBag()
	end
end

--@brief	更新当前宠物信息
function WndPetsEquipment:updateCurPetInfo()
	if not self.m_root then
		return
	end
	self.m_tCurPetsInfo = nil

	local petsList =  CacheCenter:getPlayerPetInfo()
    table.sort(petsList,sortPets)

	if WndPets.m_tCurPetsInfo and not self:isExpPet(WndPets.m_tCurPetsInfo.itemId) then
		self.m_tCurPetsInfo = WndPets.m_tCurPetsInfo
	else
		for i=1,#petsList do
			if not self:isExpPet(petsList[i].itemId) then
				self.m_tCurPetsInfo = petsList[i]
				break
			end
		end
	end

	self:updatepetEquipData()
	self:_addDressSuit()

end

--@brief    设置装备界面显示类型数据
function WndPetsEquipment:setShowSubType(nSubType)
	self.m_nShowSubType = nSubType
end

--@brief	更新装备界面显示列表数据
function WndPetsEquipment:updateBagShowData()
	if self.m_nShowSubType == nil or self.m_nShowSubType == -1 then
		self.m_tEquipmentShowList = self.m_tBagItemDataList
	else
		self.m_tEquipmentShowList = self:getBagDataBySubType(self.m_nShowSubType)
	end
end

--@brief	根据子类型获取背包数据
function WndPetsEquipment:getBagDataBySubType(nSubType)
	local tData = {}
	for i=1,#self.m_tBagItemDataList do
		if self.m_tBagItemDataList[i].basicInfo.sub_type == nSubType then
			table.insert(tData,self.m_tBagItemDataList[i])
		end
	end
	return tData
end



--@brief	更新继承界面显示列表数据
function WndPetsEquipment:updateInheritShowData()
	if self.m_tInheritItem1 == nil then
		self.m_tInheritShowList = self.m_tBagItemDataList
	else
		self.m_tInheritShowList = {}
		for i=1,#self.m_tBagItemDataList do
			local tData = self.m_tInheritItem1:getData()
			local tBagItem = self.m_tBagItemDataList[i]
			if tData.basicInfo.sub_type == tBagItem.basicInfo.sub_type and tData.playerItemId ~= tBagItem.playerItemId then --相同部位
				if (tData.basicInfo.quality == 4 and self:isZeroLvAndStar(tData) and self:isNoGem(tData)) and (self:isZeroLvAndStar(tBagItem) and tBagItem.basicInfo.quality == 3) then --第一个装备是0级0星0石的橙装,背包显示0级0星紫装
					table.insert(self.m_tInheritShowList,self.m_tBagItemDataList[i])
				elseif (tData.basicInfo.quality == 4 and not (self:isZeroLvAndStar(tData) and self:isNoGem(tData))) and (self:isZeroLvAndStar(tBagItem) and (tBagItem.basicInfo.quality == 3 or tBagItem.basicInfo.quality == 4)) then --第一个装备不是0级0星0石的橙装,背包显示0级0星紫或橙装
					table.insert(self.m_tInheritShowList,self.m_tBagItemDataList[i])
				elseif tData.basicInfo.quality ~= 4 and tData.basicInfo.quality == tBagItem.basicInfo.quality and self:isZeroLvAndStar(tBagItem) then --第一个装备不是橙装,背包显示0级0星同品质装备
					table.insert(self.m_tInheritShowList,self.m_tBagItemDataList[i])
				end
			end
		end
	end
end

--@brief	更新继承界面返回
function WndPetsEquipment:getPetEquipExtendsOK()
	MsgBoxManager:showTipBox(LocalStrings.PET_EQUIPMENT_17)
	WndPetsEquipment:initInheritUI()
end

--@brief	是否0级0星
function WndPetsEquipment:isZeroLvAndStar(tData)
	if tData.extraInfo.strongLevel == 0 and tData.extraInfo.starLevel == 0 then
		return true
	else
		return false
	end
end

--@brief	是否无宝石
function WndPetsEquipment:isNoGem(tData)
	if tData.extraInfo.attackStone == 0 and tData.extraInfo.defendStone == 0 and tData.extraInfo.hpStone == 0 and tData.extraInfo.gongmingStone == 0 then
		return true
	else
		return false
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
