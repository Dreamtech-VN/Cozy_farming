-- 许愿池奖励
-- @brief:许愿池奖励Data 模块
-- @date: 2017-03-13 17:37:34
-- @author: zhenwei_jian
-- @note:许愿池奖励

local CellPromiseShrineGiftItem = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellPromiseShrineGiftItem:_init()
	self.m_root = nil	 	  			--场景根节点 
	self.m_itemId = nil
	self.m_bIsGood = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellPromiseShrineGiftItem:_unInit()
	self.m_root = nil 
	self.m_itemId = nil
	self.m_bIsGood = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
--@param  	isGoold 是否稀有
function CellPromiseShrineGiftItem:createElement(itemId, isGood)
	self.m_itemId = itemId
	self.m_bIsGood = isGood

	local tInstance = self:_new()
	tInstance:_init()

	local element = WZUISystem:getInstance():createElement("CellPromiseShrineGiftItem") 
	element:setLuaObjectIndex(tInstance)
	tolua.setpeer(element, tInstance)
	return element, tInstance
end
-------------------------------------公有方法模块End--------------------------------------





-------------------------------------私有方法模块Begin--------------------------------------


--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellPromiseShrineGiftItem:_new( )
	local tInstance = {}
	setmetatable(tInstance, {__index = CellPromiseShrineGiftItem})
	return tInstance
end
-------------------------------------私有方法模块End--------------------------------------




--rawset _G 这样设置全局表 好处是:容易定位该全局变量定义的位置
rawset(_G, "CellPromiseShrineGiftItem", CellPromiseShrineGiftItem)