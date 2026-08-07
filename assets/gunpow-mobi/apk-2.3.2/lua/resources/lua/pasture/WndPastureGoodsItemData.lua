--WndPastureGoodsItemData.lua
--@brief	WndPastureGoodsItem的数据模块
--@date		2021/04/19
--@author	hyx
--@note		牧场背包物品

WndPastureGoodsItem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPastureGoodsItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nScale = nil
	self.m_bIsAdd = nil
	self.m_tItemData = nil
	self.m_bIsShowTips = nil
	self.m_tOteherData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPastureGoodsItem:_unInit()
	self.m_root = nil
	self.m_nScale = nil
	self.m_bIsAdd = nil
	self.m_tItemData = nil
	self.m_bIsShowTips = nil
	self.m_tOteherData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
--[[
scale: 缩放
is_add：是否显示加号
]]
function WndPastureGoodsItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "WndPastureGoodsItem table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("WndPastureGoodsItem")
	assert(element, "WndPastureGoodsItem element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	
	return element,tNewObj
end

--目前之传入技能id
function WndPastureGoodsItem:setData(id, scale, is_show_tips, is_add)
	self.m_nScale = scale or 1
	id = id or 0
	if id == 0 then
		self.m_tItemData = nil
	end
	local skillInfo = GDatatab_skill["id_"..id]
	if skillInfo then
		self.m_tItemData = skillInfo
	end
	self.m_bIsShowTips = is_show_tips or false
	self.m_bIsAdd = is_add or nil
	self:_updata()
end
function WndPastureGoodsItem:getData()
	return self.m_tItemData
end
--[[
next_desc: 不显示下一级的情况
]]
function WndPastureGoodsItem:setOtherData(other_data)
	self.m_tOteherData = other_data
end

function WndPastureGoodsItem:setCallFunc(func)
	self.m_sCallFunc = func
end

--如果有物品的时候，再次点击的回调函数
function WndPastureGoodsItem:setOtherCallFunc(func)
	self.m_sOtherCallFunc = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPastureGoodsItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------
