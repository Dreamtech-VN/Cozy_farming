--WndChooseStockNumData.lua
--@brief	WndChooseStockNum的数据模块
--@date		2017/09/27
--@author	Tianxiang_Xu
--@note		选择入股数量界面

WndChooseStockNum = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndChooseStockNum:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 
	self.m_nTempNum = nil 				--临时的入股数量
	self.m_bIsCanChooseNum = false  		
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndChooseStockNum:_unInit()
	self.m_root = nil
	self.m_tData = nil 
	self.m_nTempNum = nil
	self.m_bIsCanChooseNum = nil  	
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndChooseStockNum:createElement()
	if WndChooseStockNum.m_root ~= nil then
		WindowManager:removeWindow(WndChooseStockNum.m_root, WndChooseStockNum, true)
	end
	local element = WZUISystem:getInstance():createElement("WndChooseStockNum")
	assert(element, "WndChooseStockNum create element failed!")
	self:_init()
	return element
end

--brief 	外部接口
function WndChooseStockNum:showInterface(tData)
	-- body
	local wndStock = WndChooseStockNum:createElement()
	if wndStock then 
		self.m_tData =CopyTable(tData) 
		WindowManager:addWindow(wndStock, WndChooseStockNum, nil, nil, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
