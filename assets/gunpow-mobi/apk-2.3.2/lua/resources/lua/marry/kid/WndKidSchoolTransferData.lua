--WndKidSchoolTransferData.lua
--@brief	WndKidSchoolTransfer的数据模块
--@date		2021/05/27
--@author	yrd
--@note		孩子学校-转让

WndKidSchoolTransfer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidSchoolTransfer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidSchoolTransfer:_unInit()
	self.m_root = nil
	self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidSchoolTransfer:createElement()
	if WndKidSchoolTransfer.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolTransfer.m_root, WndKidSchoolTransfer, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidSchoolTransfer")
	assert(element, "WndKidSchoolTransfer create element failed!")
	self:_init()
	return element
end

function WndKidSchoolTransfer:showInterface(tData)
	local wnd = WndKidSchoolTransfer:createElement()
	if wnd ~= nil then
		self.m_tData = tData
	    WindowManager:addWindow(wnd, WndKidSchoolTransfer, nil, false, nil, true)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
