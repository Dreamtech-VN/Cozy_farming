--WndEquip.lua
--@brief	CellPlayerGoodsList的数据模块
--@date		2014/01/07
--@author	zsq
--@note		玩家物品项

WndEquip = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndEquip:_init()
	self.m_root = nil  			--根节点
	self.m_nBagIndex = 0
	self.m_nItem = nil
	self.m_tItem = nil
	self.m_tBtnFun = nil 
	self.m_nY = nil 
	self.allSub = nil

	self.m_tGridList = {}		--格子表对象列表
	self.m_nAddGridIndex = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndEquip:_unInit()
	self.m_root = nil
	self.m_nBagIndex = nil
	self.m_nItem = nil
	self.m_tItem = nil
	self.m_tBtnFun = nil 
	self.m_nY = nil 
	self.allSub = nil

	self.m_tGridList = nil		--格子表对象列表
	self.m_nAddGridIndex = nil
end

--@brief	全部列表
function WndEquip:setAllData(tArms)
	if self.m_root == nil or tArms == nil then
		return
	end
	--self.m_tItem = CopyTable(tArms)
	self.m_tItem = tArms
	table.sort(self.m_tItem , sortAll)
end

--@brief	武器列表
function WndEquip:setArmsData(tArms)
	if self.m_root == nil or tArms == nil then
		return
	end
	--self.m_tItem = CopyTable(tArms)
	self.m_tItem = tArms
	table.sort(self.m_tItem , sortArms)
end

--@brief	防具列表
function WndEquip:setDressData(tDress)
	if self.m_root == nil or tDress == nil then
		return
	end
	--self.m_tItem =  CopyTable(tDress)
	WZLog("防具列表", Serialize(tDress))
	self.m_tItem =  tDress
	table.sort(self.m_tItem , sortDress)
end

--@brief	宝石列表
function WndEquip:setGemData(tData)
	if self.m_root == nil or tData == nil then
		return
	end
	--self.m_tItem =  CopyTable(tData)
	self.m_tItem =  tData
	table.sort(self.m_tItem , sortGem)
end

--@brief	其它列表
function WndEquip:setOtherData(tOther)
	if self.m_root == nil or tOther == nil then
		return
	end
	--self.m_tItem = CopyTable(tOther)
	self.m_tItem = tOther
	table.sort(self.m_tItem , sortOther)
end

--@brief	皮肤列表
function WndEquip:setSkinData(tOther)
	if self.m_root == nil or tOther == nil then
		return
	end
	--self.m_tItem = CopyTable(tOther)
	self.m_tItem = tOther
	table.sort(self.m_tItem , sortSkin)
end

--@brief	更新玩家物品信息(数据更新)
function WndEquip:updatePlayerItemData()
	if WndBag.m_bOpenStrengthen == true then return end
	if self.m_root == nil then return end

	if WndBag ~= nil and (WndBag.m_bFrameIndex == 1 or WndBag.m_bFrameIndex == 3) then
		self:updateItemList()
	end
end

function WndEquip:updateItemList()
	if self.m_root == nil then
		return
	end
	if self.m_nBagIndex == 1 then
		self:setArmsData(CacheCenter:getWeaponList())--武器列表
	elseif self.m_nBagIndex == 2 then
		self:setDressData(CacheCenter:getDefendList())--道具列表
	elseif self.m_nBagIndex == 3 then
		self:setOtherData(CacheCenter:getBagMaterialList())--材料列表
	elseif self.m_nBagIndex == 4 then
		self:setOtherData(CacheCenter:getPlayerAndPetGemList())--宝石列表
	elseif self.m_nBagIndex == 5 then
		self:setSkinData(CacheCenter:getSkinAndFootList())--皮肤列表
	else
		self:setArmsData(CacheCenter:getEquipAllList(self.allSub))--武器列表
	end
	self:_updateItem()--更新物品列表
end

--@brief	更新玩家身上装备
function WndEquip:updateEquipItem(tData)
	if tData == nil or tData.maintype == nil then
		return
	end
	for i,data in pairs(self.m_tItem) do 
		if tData.maintype == data.maintype and tData.subtype == data.subtype and tData.id == data.id then
			self.m_tItem[i].isUse = false 
			self:_sortTable(self.m_nBagIndex)--排序
			self:_updateItem()
			break
		end
	end
end

--@brief	按钮回调
function WndEquip:setBtnBackFun(lua,onStrongClick,onSaleClick)
	if lua and onStrongClick then
		self.m_tBtnFun = {}
		self.m_tBtnFun[1] = lua
		self.m_tBtnFun[2] = onStrongClick
		self.m_tBtnFun[3] = onSaleClick
	end
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndEquip:createElement()
	local element = WZUISystem:getInstance():createElement("WndEquip")
	assert(element, "WndEquip create element failed!")
	self:_init()
	return element
end

function WndEquip:setItemBackFun(tCell,backFun,onItem)
	if tCell and backFun then
		self.m_tItemBack = {}
		self.m_tItemBack[1] = tCell
		self.m_tItemBack[2] = backFun
		self.m_tItemBack[3] = onItem
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置文本内容属性
function WndEquip:_setTxtDesc(tCell,desc)
	if self.m_root == nil or tCell == nil then
		return
	end
	desc = desc or ""
	tCell = WZUILabelTTF:luaTo(tCell)
	tCell:setText(desc)
end

--显示tip信息
function WndEquip:_addTip(tItem,element,pCell)
	if tItem == nil or element == nil or pCell == nil then
		return
	end
	WndItemInfo:showInfo(element,pCell,1,tItem)
	--事件回调
	WndItemInfo:setExpiredFun(self,self.onItemExpired)--期按回调
	WndItemInfo:setWearFun(self,self.onItemWear)--穿上回调
	WndItemInfo:setRoyalFun(self,self.onItemRoyal)--御下回调
	WndItemInfo:setUseFun(self,self.onItemApply)--使用回调
	WndItemInfo:setStrengFun(self,self.onStrengthen,self.onStrengthen)--强化
end


--@brief  获取两个值的最大
function WndEquip:_getMaxSort(x)
	if x == true then
		return 1 
	else
		return 0
	end
end

function WndEquip:_getMaxRecommended(x,y)
	if x == true then
		return 1 
	else
		return 0
	end
end

--是否过期
function WndEquip:_getMaxExpired(x)
	if x == true  then
		return 0 
	else
		return 1
	end
end

--装备类型
function WndEquip:_getMaxType(tData)
	local maintype = tData.maintype
	local subtype = tData.subtype
	local priority
	local index = 0
	local subIndex = 0
	if maintype == 7 then-- 物品是否是材料
		index = 2
	elseif maintype == 6 then--物品是否是宝石  
		index = 1
	elseif maintype == 2 then--物品是否是道具
		index = 3
	elseif maintype == 4 then-- 物品是否是装备 
		index = 4
		if subtype == 0 or subtype == 1 then
			subIndex = 9
		end
		if subtype == 4 then
			subIndex = 8
		end
		if subtype == 3 then
			subIndex = 7
		end
		if subtype == 5 then
			subIndex = 6
		end
		if subtype == 2 then
			subIndex = 5
		end
		if subtype == 6 then
			subIndex = 4
		end
	end
	if subtype < 9 then
		--subIndex = 9 - subtype  
	else
		subIndex = 0
	end
	priority = index * 10 + subIndex
	return priority
end

--@brief	全部标签排序
function sortAll(a,b)
	local x = WndEquip:_getMaxSort(a.isUse)--穿上
	local y = WndEquip:_getMaxSort(b.isUse)--穿上
	local r = WndEquip:_getMaxRecommended(a.recommended,a.expired)--推荐
	local t = WndEquip:_getMaxRecommended(b.recommended,b.expired)--推荐
	local n = WndEquip:_getMaxExpired(a.expired)
	local m = WndEquip:_getMaxExpired(b.expired)
	local e = WndEquip:_getMaxType(a)
	local f = WndEquip:_getMaxType(b)
	if x ~= y then--是否已装备
		return x >= y 
	elseif r~=t then--是否推荐
		return r >= t
	--elseif n ~= m then--不过期
	--	return n > m
	elseif e ~= f then--类型排序 
		return e >= f
	elseif a.basicInfo.quality ~= b.basicInfo.quality then --品质
		return a.basicInfo.quality >= b.basicInfo.quality
	else--ID排序 
		return a.id < b.id
	end
end

--@brief  武器列表排序函数
function sortArms(a,b)
	local x = WndEquip:_getMaxSort(a.isUse)--穿上
	local y = WndEquip:_getMaxSort(b.isUse)--穿上
	local r = WndEquip:_getMaxRecommended(a.recommended,a.expired)--推荐
	local t = WndEquip:_getMaxRecommended(b.recommended,b.expired)--推荐
	local n = WndEquip:_getMaxExpired(a.expired)
	local m = WndEquip:_getMaxExpired(b.expired)
	local e = WndEquip:_getMaxType(a)
	local f = WndEquip:_getMaxType(b)
	if x ~= y then--是否装备
		return x >= y
	elseif r~=t then--是否推荐
		return r >= t
	--elseif n ~= m then--不过期
	--	return n > m
	elseif x == 0 and y == 0 and a.extraInfo.starLevel ~= nil and b.extraInfo.starLevel ~= nil and a.extraInfo.starLevel ~= b.extraInfo.starLevel then
		return a.extraInfo.starLevel > b.extraInfo.starLevel
	elseif x == 0 and y == 0 and a.extraInfo.strongLevel ~= nil and b.extraInfo.strongLevel ~= nil and a.extraInfo.strongLevel ~= b.extraInfo.strongLevel then
		return a.extraInfo.strongLevel > b.extraInfo.strongLevel
	elseif x == 0 and y == 0 and a.basicInfo.quality ~= b.basicInfo.quality then 
		return a.basicInfo.quality >= b.basicInfo.quality
	elseif e ~= f then--类型排序
		return e >= f
	else 
		return a.id < b.id
	end
end


--@brief  装扮列表排序函数
function sortDress(a,b)
	local x = WndEquip:_getMaxSort(a.isUse)--穿上
	local y = WndEquip:_getMaxSort(b.isUse)--穿上
	local r = WndEquip:_getMaxRecommended(a.recommended,a.expired)--推荐
	local t = WndEquip:_getMaxRecommended(b.recommended,b.expired)--推荐
	local n = WndEquip:_getMaxExpired(a.expired)
	local m = WndEquip:_getMaxExpired(b.expired)
	local e = WndEquip:_getMaxType(a)
	local f = WndEquip:_getMaxType(b)
	if x ~= y then--是否装备
		return x >= y
	elseif r~=t then--是否推荐
		return r >= t
	elseif n ~= m then--不过期
		return n > m
	elseif a.basicInfo.quality ~= b.basicInfo.quality then 
		return a.basicInfo.quality >= b.basicInfo.quality
	elseif e ~= f then 
		return e >= f
	else 
		return a.id > b.id
	end
end

--@brief  宝石排序函数
function sortGem(a,b)
	if a.basicInfo.sub_type ~= b.basicInfo.sub_type then
		return a.basicInfo.sub_type < b.basicInfo.sub_type 
	else
		if a.basicInfo.quality ~= b.basicInfo.quality then
			return a.basicInfo.quality > b.basicInfo.quality
		else
			return a.id < b.id 
		end
	end
end

--@brief  其它列表排序函数
function sortOther(a,b)
	local n = WndEquip:_getDay(a)
	local m = WndEquip:_getDay(b)
	if n ~= m then
		return n >= m 
	elseif a.basicInfo.quality ~= b.basicInfo.quality then
		return a.basicInfo.quality > b.basicInfo.quality 
	else
		return a.id < b.id 
	end
end

--@brief  皮肤列表排序函数
function sortSkin(a,b)
	if a.basicInfo.main_type ~= b.basicInfo.main_type then
		return a.basicInfo.main_type > b.basicInfo.main_type
	elseif a.basicInfo.quality ~= b.basicInfo.quality then
		return a.basicInfo.quality > b.basicInfo.quality 
	else
		return a.id < b.id
	end
end

function WndEquip:_getDay(ab)
	if ab and ab.basicInfo.use_type and ab.basicInfo.use_type == 1 and ab.lastTime < 0 then
		return 0
	else 
		return 1 
	end
end

--@brief  获取两个值的最大
function WndEquip:_getMaxdays(d)
	if d == -1 then
		return 1 
	else
		return 0
	end
end

--@brief  获取当前穿上的装扮的tag
function WndEquip:_getCurItemUseTag(tItem)
	for i,data in pairs(self.m_tItem) do 
		if tItem.maintype < 2 and data.maintype < 2 and data.isUse == true then
			return i-1
		elseif data.isUse == true and data.maintype == tItem.maintype and data.subtype == tItem.subtype then
			return i-1
		elseif tItem.maintype == 17 then
			local tag = self:_checkRank(data,tItem,i)
			if tag then
				return tag
			end
		end
	end
end

--这个函数是针对旧的戒指做判断
function WndEquip:_checkRank(data,tItem,i)
	if WndPlayer.m_root and WndPlayer.m_tPlayer and WndPlayer.m_tPlayer[3] and WndPlayer.m_tPlayer[4] then
		if tItem.subtype == 0 or tItem.subtype == 1 then
			if WndPlayer.m_tPlayer[3].id == data.id then
				return i-1
			end
		else
			if WndPlayer.m_tPlayer[4].id == data.id then
				return i-1
			end
		end
	end
end

--@brief  排序
function WndEquip:_sortTable(tag)
	if tag == 1 then
		table.sort(self.m_tItem , sortArms)
	elseif tag == 2 then
		table.sort(self.m_tItem , sortDress)
	elseif tag == 3 then
	end
end

--@brief   显示文本属性
function WndEquip:_setTxtDesc(element,desc)
	if self.m_root == nil or element == nil then
		return
	end
	desc = desc or ""
	element = WZUILabelTTF:luaTo(element)
	element:setText(desc)
end

--@brief	英文包适配函数
function WndEquip:_adaptLanguage_vn()
	if self.m_root == nil then
		return
	end
	WZUILabelTTF:luaTo(self.m_root:getChildElement("txtArms_WndEquip")):setFontSize(20)
	WZUILabelTTF:luaTo(self.m_root:getChildElement("txtDress_WndEquip")):setFontSize(20)
	WZUILabelTTF:luaTo(self.m_root:getChildElement("txtOther_WndEquip")):setFontSize(20)
	WZUILabelTTF:luaTo(self.m_root:getChildElement("txtOther_WndEquip")):setFontSize(20)
	WZUILabelTTF:luaTo(self.m_root:getChildElement("txtOther_WndEquip")):setFontSize(20)
end

-------------------------------------私有方法模块End----------------------------------------
