--WndHVFertilizerListData.lua
--@brief	WndHVFertilizerList的数据模块
--@date		2022/06/23
--@author	XTX
--@note		度假村-肥料

WndHVFertilizerList = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVFertilizerList:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDataList = nil 
	self.m_tFieldData = nil 
	self.m_tLuaTable = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVFertilizerList:_unInit()
	self.m_root = nil
	self.m_tDataList = nil 
	self.m_tFieldData = nil 
	self.m_tLuaTable = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVFertilizerList:createElement()
	if WndHVFertilizerList.m_root ~= nil then
		WndHVFertilizerList.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVFertilizerList")
	assert(element, "WndHVFertilizerList create element failed!")
	self:_init()
	return element
end

--@brief 	设置肥料数据
function WndHVFertilizerList:setData(tFieldData, luaTable)
	self.m_tFieldData = tFieldData
	self.m_tLuaTable = luaTable
	self.m_tDataList = self.m_tLuaTable:getFertilizerData()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
