--WndPlayer.lua
--@brief	WndPlayerGoodsList的数据模块
--@date		2014/01/07
--@author	llg
--@note		玩家物品项

WndPlayer = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndPlayer:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tPlayer = nil		--玩家身上列表
	self.m_tRole = nil
	self.m_tItemBack = nil
	self.equipGridList = nil	--装备格子列表对象
	self.gridList = nil			--查看自己的时装格子表对象列表
	self.otherGridList = nil	--查看其他玩家时装格子表对象列表
	self.m_tPlayerAni = nil
	self.m_bCheckOther = nil    --是否正在查看其他玩家

	self.m_tItem = nil			--查看tips的物品
	self.m_bChangeDress = nil	--是否在换装
	self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPlayer:_unInit()
	self.m_root = nil
	self.m_tPlayer = nil
	self.m_tRole = nil
	self.m_tItemBack = nil
	self.equipGridList = nil	--装备格子列表对象
	self.gridList = nil	
	self.otherGridList = nil	
	self.m_tPlayerAni = nil
	self.m_bCheckOther = nil

	self.m_tItem = nil			--查看tips的物品
	self.m_bChangeDress = nil	--是否在换装
	self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndPlayer:createElement()
	local element = WZUISystem:getInstance():createElement("WndPlayer")
	assert(element, "WndPlayer create element failed!")
	self:_init()
	return element
end

--@brief	缓存推送更新物品时调用的函数
function WndPlayer:updatePlayerItemData()
	WZLog("WndPlayer:updatePlayerItemData")
	--WndDressList.m_tTryWearList = nil
	if self.m_root == nil then return end

	--self:updateDressGrid()
	self:setPlayerBodyData(CacheCenter:getEquipmentList()) 
end

--@brief	缓存推送更新玩家基本信息(数据更新)
function WndPlayer:updatePlayerInfoData()
	if WndBag.m_bOpenStrengthen == true then return end
	if self.m_root == nil then return end

	if self.m_bCheckOther ~= true then
		self:setPlayerData(CacheCenter:getPlayerInfo())
	end
end

function WndPlayer:setPlayerData(tData)
	if self.m_root == nil or tData == nil then
		return
	end
	self.m_tRole = tData
	self:_updateFire(self.m_tRole)
	self:_showPet()
end

--@brief	从缓存取数据显示装备和人物
function WndPlayer:setPlayerBodyData(tEquip)
	WZLog("WndPlayer:setPlayerBodyData")
	if self.m_root == nil or tEquip == nil then return end
	table.sort(tEquip,sortRanking)
	self.m_tPlayer = {}

	for i,data in pairs(tEquip) do 
		local tag = self:_getItemIndex(data)
		data.extraInfo = data.extraInfo or {}
		self.m_tPlayer[tag] = data
	end

	self:_showRoleItem()--设置角色Item图片
	self.m_root:enableSchedule("_setPlayer",0)
end

function WndPlayer:refreshRole() 
	WZLog("WndPlayer:refreshRole()",CacheCenter:getPlayerInfo().shapeId)
	self.m_root:enableSchedule("_setPlayer",0.5)
end

function WndPlayer:setItemBackFun(tCell,backFun,onItem)
	if tCell and backFun then
		self.m_tItemBack = {}
		self.m_tItemBack[1] = tCell
		self.m_tItemBack[2] = backFun
		self.m_tItemBack[3] = onItem
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPlayer:_hasEquipLua(tCell,index)
	if tCell[index] ~= nil and tCell[index].basicInfo then
		return tCell[index].basicInfo
	end
	return {}
end

--显示tip信息
function WndPlayer:_addTip(tItem,element,pCell)
	WZLog("WndPlayer:_addTip",self.m_bCheckOther)
	if self.m_bCheckOther == true then
		WndItemInfo:showInfo(element,WndCheckOther.m_root,1,tItem,false)
		return
	end
	if tItem == nil or element == nil or pCell == nil then
		return
	end
	self.m_tItem = tItem

	WndItemInfo:showInfo(element,pCell,1,tItem,true)
	--事件回调
	WndItemInfo:setExpiredFun(self,self.onItemExpired)--期按回调
	WndItemInfo:setRoyalFun(self,self.onItemRoyal)--卸下回调
	WndItemInfo:setUseFun(self,onItemApply)--使用回调
	WndItemInfo:setStrengFun(self,self.onStrengthen,self.onStrengthen)--强化
end

--@brief	卸下回调
function WndPlayer:onItemRoyal()
	WZLog("WndPlayer:onItemRoyal")
	local id = WZLuaVector_int_:create()
	id:push(self.m_tItem.playerItemId)
	ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id)
end

--获得装扮tag
function WndPlayer:_getItemIndex(tData)
	WZLog("WndPlayer:_getItemIndex",tData.maintype,tData.subtype)
	local maintype = tData.maintype or tData.main_type
	local subtype = tData.subtype or tData.sub_type
	local index = 0
	if maintype == 4 and subtype < 2 then --武器
		index = 1
	elseif maintype == 4 and subtype == 3 then--物品是否是项链装备
		index = 2
	elseif maintype == 4 and subtype == 2 then--物品是否是戒指装备
		index = 3
	elseif maintype == 4 and subtype == 4 then--物品是否是手镯装备
		index = 4
	elseif maintype == 4 and subtype == 5 then--物品是否是宝物装备
		index = 5
	elseif maintype == 4 and subtype == 6 then--物品是否是勋章装备
		index = 6
	elseif maintype == 4 and subtype == 7 then--物品是否是耳坠装备
		index = 7
	elseif maintype == 4 and subtype == 8 then--物品是否是副手装备
		index = 8
	elseif maintype == 5 and subtype == 0 then-- 物品是否是头部 
		index = 9
	elseif maintype == 5 and subtype == 1 then--物品是否是脸谱
		index = 10
	elseif maintype == 5 and subtype == 2 then--物品是否是衣服  
		index = 11
	elseif maintype == 5 and subtype == 3 then-- 物品是否是翅膀装备
		index = 12
	end
	WZLog("WndPlayer:_getItemIndex::",tData.id,maintype,subtype,index,tData.basicInfo.name,tData.basicInfo.animation_index_code)
	return index
end

--@brief	空白item显示tip信息(说明)
function WndPlayer:_getEmptyItemDesc(tag)
	if tag == 1 then
		return LocalStrings.WEAPON--"武器"
	elseif tag == 2 then
		return LocalStrings.NECKLACE--"项链"
	elseif tag == 3 then
		return LocalStrings.RINGLEFTEXP--"戒子"
	elseif tag == 4 then
		return LocalStrings.BRACELET--"手镯"
	elseif tag == 5 then
		return LocalStrings.TREASURE--"宝物"
	elseif tag == 6 then
		return LocalStrings.MEDAL--"勋章"
	elseif tag == 7 then
		return LocalStrings.NEWBAG8--"耳坠"
	elseif tag == 8 then
		return LocalStrings.NEWBAG9--"副手"
	else
		return LocalStrings.HEAD--"发型"
	end
end

--@brief  装扮列表排序函数
function sortRanking(a,b)
	return a.id > b.id
end

-------------------------------------私有方法模块End----------------------------------------
