--CellPhantomItem1Data.lua
--@brief	CellPhantomItem1的数据模块
--@date		2021/03/04
--@author	hyc
--@note		皮肤Item

CellPhantomItem1 = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellPhantomItem1:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_bIsLoaded = false 
	self.selState = false 
	self.m_tData = nil 
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPhantomItem1:_unInit()
	self.m_root = nil
	self.m_bIsLoaded = nil 
	self.selState = nil 
	self.m_tData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellPhantomItem1:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellPhantomItem1 table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
	element:setName("__CellPhantomItem1")
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(402, 98))
	element:setLuaObjectIndex(tNewObj)
	
	return element,tNewObj
end

--@brief 	设置数据
function CellPhantomItem1:setData(tData)
	-- body
	self.m_tData = tData 

	--碎片
    --碎片数量
	local itemId = tData.channel
	local needNum = 1
	local debrisId 
	for k,v in pairs(GDatatab_itemmerge) do
		if ((v.id >= 8000 and v.id < 10000) or (v.id >= 161000 and v.id < 163000) or (v.id >= 157000 and v.id < 160000)) and v.items[1][1] == itemId then
			debrisId = v.id
			needNum = v.scrap[1][2]
		end
	end
	--已拥有，升品数量
	if tData.own then
		if tData.sp_cost == -1 then
			needNum = 1
		else
			debrisId = tData.sp_cost[1][1]
			needNum = tData.sp_cost[1][2]
		end
	end
	local tDebris = CacheCenter:getPlayerItemById(debrisId)
	local debrisNum = 0
	if tDebris ~= nil then
		debrisNum = tDebris.lastNum
	else
		debrisNum = 0
	end

	self.tDebris = tDebris
	--碎片数量是否足够
	self.enough = (debrisNum>=needNum)
--	WZLog(tData.name.."碎片足够？", self.enough)
end

--@brief 	刷新数据
function CellPhantomItem1:resetData(tData)
	-- body
	self.m_tData = tData
	if self.m_bIsLoaded == false then return end 
	
	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPhantomItem1:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------
