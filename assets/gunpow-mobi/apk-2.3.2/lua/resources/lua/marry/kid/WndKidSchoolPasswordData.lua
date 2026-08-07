--WndKidSchoolPasswordData.lua
--@brief	WndKidSchoolPassword的数据模块
--@date		2021/04/23
--@author	yrd
--@note		孩子学校密码

WndKidSchoolPassword = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidSchoolPassword:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nSchoolId = nil 				--学校id
	self.m_nSchoolName = nil 			--学校名
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidSchoolPassword:_unInit()
	self.m_root = nil
	self.m_nSchoolId = nil
	self.m_nSchoolName = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidSchoolPassword:createElement()
	if WndKidSchoolPassword.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolPassword.m_root, WndKidSchoolPassword, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidSchoolPassword")
	assert(element, "WndKidSchoolPassword create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndKidSchoolPassword:showInterface(schoolId,schoolName)
	local wnd = WndKidSchoolPassword:createElement()
	if wnd ~= nil then
	    WindowManager:addWindow(wnd, WndKidSchoolPassword, nil, false, nil, true)
	end

	self.m_nSchoolId = schoolId
	self.m_nSchoolName = schoolName
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
