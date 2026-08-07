--WndKingShopData.lua
--@brief	WndKingShop的数据模块
--@date		2015/5/12
--@author	Zjh
--@note

WndKingShop = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKingShop:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_tData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKingShop:_unInit()
	self.m_root = nil

	self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKingShop:createElement()
	local element = WZUISystem:getInstance():createElement("WndKingShop")
	assert(element, "WndKingShop create element failed!")
	self:_init()
	return element
end

function WndKingShop:setData(tData)
	self.m_tData = {}
	for i,v in ipairs(tData.kingMallId) do
		local tCellData = {}
		tCellData.id 			= tData.kingMallId[i]
		tCellData.rest_num 		= tData.leaveTimes[i]
		table.insert(self.m_tData,tCellData)
	end
	self:_updateShopList()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
