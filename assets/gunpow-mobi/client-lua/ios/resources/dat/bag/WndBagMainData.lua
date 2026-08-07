--WndBagMainData.lua
--@brief	WndBagMain的数据模块
--@date		2017/07/06
--@author	zsq
--@note		玩家角色主面板

WndBagMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBagMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nSubWin = nil
	self.m_tSub1 = nil
	self.m_tSub2 = nil
	self.m_tSub3 = nil
	self.m_tSub4 = nil
	self.m_tSub5 = nil
	self.m_tSub6 = nil
	self.jumpTag = nil
	self.m_nDesignationIndex = nil 		--成就跳转的时候用于表示跳到成就还是徽章
	--获取g_bHaveNewDesi的值
	if not g_bHaveRedPointForAchieEntry then
		g_bHaveRedPointForAchieEntry = g_bHaveNewDesi
	end
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBagMain:_unInit()
	self.m_root = nil
	self.m_nSubWin = nil
	self.m_tSub1 = nil
	self.m_tSub2 = nil
	self.m_tSub3 = nil
	self.m_tSub4 = nil
	self.m_tSub5 = nil
	self.m_tSub6 = nil
	self.jumpTag = nil
	self.m_nDesignationIndex = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBagMain:createElement()
	if WndBagMain.m_root ~= nil then
		WindowManager:removeWindow(WndBagMain.m_root, WndBagMain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndBagMain")
	assert(element, "WndBagMain create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	进入背包装备
function WndBagMain:showBagEquip()
	WZLog("WndBagMain:showBagDress")
	if self.m_root == nil then
		local wndBagElement = WndBagMain:createElement()
		WndBagMain.jumpTag = "Equip"
		WindowManager:addWindow(wndBagElement, WndBagMain, nil, nil, true)
	end
end

--@brief	进入背包时装
function WndBagMain:showBagDress()
	WZLog("WndBagMain:showBagDress")
	if self.m_root == nil then
		local wndBagElement = WndBagMain:createElement()
		WndBagMain.jumpTag = "Dress"
		WindowManager:addWindow(wndBagElement, WndBagMain, nil, nil, true)
	end
end

--@brief	进入背包幻化
function WndBagMain:showBagPhantom()
	WZLog("WndBagMain:showBagPhantom")
	if self.m_root == nil then
		local wndBagElement = WndBagMain:createElement()
		WndBagMain.jumpTag = "Phantom"
		WindowManager:addWindow(wndBagElement, WndBagMain, nil, nil, true)
	end
end

--@brief	进入祈福背包
function WndBagMain:showBagBless()
	WZLog("WndBagMain:showBagBless")
	if self.m_root == nil then
		local wndBagElement = WndBagMain:createElement()
		WndBagMain.jumpTag = "BlessBag"
		WindowManager:addWindow(wndBagElement, WndBagMain, nil, nil, true)
	end
end

--@brief	进入符文
function WndBagMain:showRune()
	WZLog("WndBagMain:showRune")
	if self.m_root == nil then
		local wndBagElement = WndBagMain:createElement()
		WndBagMain.jumpTag = "Rune"
		WindowManager:addWindow(wndBagElement, WndBagMain, nil, nil, true)
	end
end

--@brief	进入成就
--@param 	index:0->成就；2->徽章
function WndBagMain:showBagDesignation(index)
	WZLog("WndBagMain:showBagDesignation")
	if self.m_root == nil then
		local wndBagElement = WndBagMain:createElement()
		WndBagMain.jumpTag = "Designation"
		WndBagMain.m_nDesignationIndex = index or 0
		WindowManager:addWindow(wndBagElement, WndBagMain, nil, nil, true)
	end
end

--@brief	进入修炼
function WndBagMain:showPractice()
	WZLog("WndBagMain:showPractice")
	if self.m_root == nil then
		local wndBagElement = WndBagMain:createElement()
		WndBagMain.jumpTag = "xiuLian"
		WindowManager:addWindow(wndBagElement, WndBagMain, nil, nil, true)
	end
end
-------------------------------------私有方法模块End----------------------------------------
