--WndRuneBookData.lua
--@brief	WndRuneBook的数据模块
--@date		2017/03/14
--@author	peiting_mao
--@note		符文图鉴

WndRuneBook = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRuneBook:_init()
	self.m_root = nil	 	  			--场景根节点
	self.typeTag = 0 					--记录符文类型tag值
	self.levelTag = 1 					--记录符文等级tag值
	self.preCell = nil					--记录之前的图鉴类型对象
	self.itemIds = nil					--拥有的符文ID
	self.itemNums = nil					--拥有的符文数量
	self.isUseds = nil					--拥有的符文装载的个数
	self.preTag = 0			            --记录之前点击的属性复选框类型值
	self.preLevel = 1 					--记录之前点击的符文等级
	self.m_topCellLua = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRuneBook:_unInit()
	self.m_root = nil
	self.typeTag = nil
	self.levelTag = nil
	self.preCell = nil
	self.itemIds = nil
	self.itemNums = nil
	self.isUseds = nil
	self.preTag = nil
	self.preLevel = nil
	self.m_topCellLua = nil 
end

function WndRuneBook:getRuneList( itemIds,itemNums,isUseds )
	--WZLog("--WndRuneBook:getRuneList--",Serialize(itemIds),Serialize(itemNums),Serialize(isUseds))
	if self.m_root == nil then return end
	self.itemIds = itemIds
	self.itemNums = itemNums
	self.isUseds = isUseds
	self:_update(self.typeTag)
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRuneBook:createElement()
	local element = WZUISystem:getInstance():createElement("WndRuneBook")
	assert(element, "WndRuneBook create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
