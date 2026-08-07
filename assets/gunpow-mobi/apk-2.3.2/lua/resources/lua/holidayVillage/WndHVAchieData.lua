--WndHVAchieData.lua
--@brief	WndHVAchie的数据模块
--@date		2022/05/27
--@author	XTX
--@note		度假村-成就界面

WndHVAchie = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHVAchie:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tAchieData = nil 			--成就数据
	self.m_achieElementSel = nil 		--使用的成就
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHVAchie:_unInit()
	self.m_root = nil
	self.m_tAchieData = nil 			--成就数据
	self.m_achieElementSel = nil 		--使用的成就
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHVAchie:createElement()
	if WndHVAchie.m_root ~= nil then
		WindowManager:removeWindow(WndHVAchie.m_root, WndHVAchie, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHVAchie")
	assert(element, "WndHVAchie create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndHVAchie:showInterface()
	local wndhvAchie = WndHVAchie:createElement()
	if wndhvAchie then 
		WindowManager:addWindow(wndhvAchie, WndHVAchie, false, nil, nil, true)
	end
end

--@brief 	设置成就数据
function WndHVAchie:setData(progress)
	self.m_tAchieData = {}

	for i, value in pairs(GDatatab_holiday_achievement) do
		local tItem = {}

		tItem.id = value.id
		tItem.progress = progress
		tItem.target = value.exp
		tItem.icon = value.icon
		tItem.name = value.name
		tItem.property = value.property
		if progress >= value.exp then 
			tItem.status = 1
		else
			tItem.status = 0
		end

		table.insert(self.m_tAchieData, tItem)
	end

	table.sort( self.m_tAchieData, function (a,b) return a.id < b.id end )

	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
