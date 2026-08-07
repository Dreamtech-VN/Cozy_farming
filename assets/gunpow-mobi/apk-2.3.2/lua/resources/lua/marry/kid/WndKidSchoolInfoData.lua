--WndKidSchoolInfoData.lua
--@brief	WndKidSchoolInfo的数据模块
--@date		2021/04/23
--@author	yrd
--@note		孩子学校信息

WndKidSchoolInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndKidSchoolInfo:_init()
	self.m_root = nil	 	  			--场景根节点

	self.m_schoolId = nil				--学校id
	self.m_schoolName = nil				--学校名
	self.m_masterId = nil				--学校校长
	self.m_level = nil					--学校等级
	self.m_effectId = nil				--对应tab_scstudy的id
	self.m_schoolExp = nil				--学校经验
	self.m_num = nil					--学校人数
	self.m_needPassword = nil			--是否需要密码
	self.m_masterName = nil				--校长名
	self.m_maxExp = nil					--当前等级最大经验值
	self.m_declaration = nil			--学校宣言
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndKidSchoolInfo:_unInit()
	self.m_root = nil

	self.m_schoolId = nil
	self.m_schoolName = nil
	self.m_masterId = nil
	self.m_level = nil
	self.m_effectId = nil
	self.m_schoolExp = nil
	self.m_num = nil
	self.m_needPassword = nil
	self.m_masterName = nil
	self.m_maxExp = nil
	self.m_declaration = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndKidSchoolInfo:createElement()
	if WndKidSchoolInfo.m_root ~= nil then
		WindowManager:removeWindow(WndKidSchoolInfo.m_root, WndKidSchoolInfo, true)
	end
	local element = WZUISystem:getInstance():createElement("WndKidSchoolInfo")
	assert(element, "WndKidSchoolInfo create element failed!")
	self:_init()
	return element
end

--@brief	外部接口
function WndKidSchoolInfo:showInterface(schoolId, schoolName, masterId, level, effectId, schoolExp, num, needPassword, masterName, maxExp, declaration)
	if WndKidSchoolInfo.m_root == nil then
		local wnd = WndKidSchoolInfo:createElement()
	    WindowManager:addWindow(wnd, WndKidSchoolInfo, nil, false, nil, true)
	end

	self.m_schoolId = schoolId
	self.m_schoolName = schoolName
	self.m_masterId = masterId
	self.m_level = level
	self.m_effectId = effectId
	self.m_schoolExp = schoolExp
	self.m_num = num
	self.m_needPassword = needPassword
	self.m_masterName = masterName
	self.m_maxExp = maxExp
	self.m_declaration = declaration
	self:updateUI()
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------
