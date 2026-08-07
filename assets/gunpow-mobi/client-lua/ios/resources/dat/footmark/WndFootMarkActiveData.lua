--WndFootMarkActiveData.lua
--@brief	WndFootMarkActive的数据模块
--@date		2017/11/28
--@author	Tianxiang_Xu
--@note		激活足迹界面

WndFootMarkActive = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFootMarkActive:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nFootMarkId = nil 
	self.m_anim = nil 
	self.m_tOldFootPos = nil 
	self.m_bIsFirst = true 
	self.m_nMoveMaxDis = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFootMarkActive:_unInit()
	self.m_root = nil
	self.m_nFootMarkId = nil 
	self.m_anim = nil 
	self.m_tOldFootPos = nil 
	self.m_bIsFirst = nil 
	self.m_nMoveMaxDis = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFootMarkActive:createElement()
	if WndFootMarkActive.m_root ~= nil then
		WindowManager:removeWindow(WndFootMarkActive.m_root, WndFootMarkActive, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFootMarkActive")
	assert(element, "WndFootMarkActive create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndFootMarkActive:showInterface(id)
	-- body
--	if not CheckButtonOpen(141) then return end 

	local wndFoot = WndFootMarkActive:createElement()
	if wndFoot then 
		self.m_nFootMarkId = id 
		WindowManager:addWindow(wndFoot, WndFootMarkActive, nil, nil, nil, true)
	end
end

--@brief 	还有体验时间时候使用体验卡展示使用结果
function WndFootMarkActive:showUseCarTips()
	-- body 
	if g_nUseFootMarkId then 
		local basicData = GDatatab_item["id_" .. g_nUseFootMarkId]
		local nAddDays = basicData.property[1][2]
		MsgBoxManager:showTipBox(string.format(LocalStrings.FOOTMARK_TEXT23, nAddDays))
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------
