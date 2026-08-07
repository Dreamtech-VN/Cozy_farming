--WndMagicGemUpgradeSelectData.lua
--@brief	WndMagicGemUpgradeSelect的数据模块
--@date		2019/07/24
--@author	yrd
--@note		魔力宝石升级选择

WndMagicGemUpgradeSelect = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMagicGemUpgradeSelect:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil 					--物品数据
	self.m_nNum = nil 					--选择数量
	self.m_nMaxNum = nil 				--最大数量
	self.m_tag = nil 					--选中格子的tag
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMagicGemUpgradeSelect:_unInit()
	self.m_root = nil
	self.m_tData = nil 					--物品数据
	self.m_nNum = nil 					--选择数量
	self.m_nMaxNum = nil 				--最大数量
	self.m_tag = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMagicGemUpgradeSelect:createElement()
	if WndMagicGemUpgradeSelect.m_root ~= nil then
		WindowManager:removeWindow(WndMagicGemUpgradeSelect.m_root, WndMagicGemUpgradeSelect, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMagicGemUpgradeSelect")
	assert(element, "WndMagicGemUpgradeSelect create element failed!")
	self:_init()
	return element
end

--@brief	修改数量
function WndMagicGemUpgradeSelect:setNum(num)
	WZLog("WndMagicGemUpgradeSelect:onAdd")
	self.m_nNum = num
	self:refresh()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
