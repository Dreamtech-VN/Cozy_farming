--WndMagicBuyLevelData.lua
--@brief	WndMagicBuyLevel的数据模块
--@date		2019/10/23
--@author	Tianxiang_Xu
--@note		幻石系统-购买等级界面

WndMagicBuyLevel = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMagicBuyLevel:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_ncostId = nil
	self.m_ncostCount = nil
	self.m_nNum = 1
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMagicBuyLevel:_unInit()
	self.m_root = nil
	self.m_ncostId = nil
	self.m_ncostCount = nil
	self.m_nNum = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMagicBuyLevel:createElement()
	if WndMagicBuyLevel.m_root ~= nil then
		WindowManager:removeWindow(WndMagicBuyLevel.m_root, WndMagicBuyLevel, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMagicBuyLevel")
	assert(element, "WndMagicBuyLevel create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndMagicBuyLevel:showInterface()
	-- body
	local wndStone = WndMagicBuyLevel:createElement()
	if wndStone then 
		WindowManager:addWindow(wndStone,WndMagicBuyLevel,nil,nil,nil,true)
	end
end

--@brief 	购买等级成功
function WndMagicBuyLevel:buyLevelSuccess()
	-- body
	if self.m_root == nil then return end 

	MsgBoxManager:showTipBox(LocalStrings.SHOP_BUY_SUCCESS .. "," .. LocalStrings.MAGIC_STONE_TEXT7 .. "+" .. self.m_nNum)
	self.m_nNum = 1
	self:initUI()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
