--WndCoupleData.lua
--@brief	WndCouple的数据模块
--@date		2022/07/18
--@author	yrd
--@note		夫妻界面

WndCouple = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCouple:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nThemeIndex = 1 				--标题按钮索引
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCouple:_unInit()
	self.m_root = nil
	self.m_nThemeIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCouple:createElement()
	if WndCouple.m_root ~= nil then
		WindowManager:removeWindow(WndCouple.m_root, WndCouple, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCouple")
	assert(element, "WndCouple create element failed!")
	self:_init()
	return element
end

--@brief 	跳转到相应的标签
function WndCouple:showInterface(nIndex)
    local wndCouple = WndCouple:createElement()
    WindowManager:addWindow(wndCouple,WndCouple)
    self.m_nThemeIndex = nIndex
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
